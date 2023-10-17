#!/bin/bash

set -e

java_dir=$(ls /usr/lib/jvm | grep -Em1 "java-[0-9]{2}-openjdk")

[ ! -z "$java_dir" ] && \
{ export PATH=/usr/lib/jvm/$java_dir/bin:$PATH; \
  export JAVA_HOME=/usr/lib/jvm/$java_dir; }

[ -z "$ANDROID_HOME" ] && \
export ANDROID_HOME=$PWD/sdk

[ -z "$ANDROID_SDK_ROOT" ] && \
export ANDROID_SDK_ROOT=$PWD/sdk

gradleTarget=assembleDebug
target=debug
file=app-debug
if [ "$1" == "release" ];then
    gradleTarget=assembleRelease
    target=release
    file=app-release-unsigned
fi
./gradlew $gradleTarget
LD_LIBRARY_PATH=./signapk/ java -jar signapk/signapk.jar keys/platform.x509.pem keys/platform.pk8 ./app/build/outputs/apk/$target/${file}.apk TrebleApp.apk
