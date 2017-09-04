#!/usr/bin/env bash

# Copyright (c) 2017, Baidu.com, Inc. All Rights Reserved

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

curdir=`dirname "$0"`
curdir=`cd "$curdir"; pwd`

export PALO_HOME=`cd "$curdir/.."; pwd`
export PID_DIR=`cd "$curdir"; pwd`

while read line; do
    envline=`echo $line | sed 's/[[:blank:]]*=[[:blank:]]*/=/g' | sed 's/^[[:blank:]]*//g' | egrep "^[[:upper:]]([[:upper:]]|_|[[:digit:]])*="`
    envline=`eval "echo $envline"`
    if [[ $envline == *"="* ]]; then
        eval 'export "$envline"'
    fi
done < $PALO_HOME/conf/fe.conf

pidfile=$PID_DIR/fe.pid

if [ -f $pidfile ]; then
   pid=`cat $pidfile`
   pidcomm=`ps -p $pid -o comm=`
   
   if [ "java" != "$pidcomm" ]; then
       echo "ERROR: pid process may not be fe. "
   fi

   if kill -9 $pid > /dev/null 2>&1; then
        echo "stop $pidcomm, and remove pid file. "
        rm $pidfile
   fi
fi

