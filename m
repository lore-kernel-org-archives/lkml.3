Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbaIDBsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 21:48:14 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:36732 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaIDBsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 21:48:12 -0400
Message-ID: <5407C4D5.3090601@hitachi.com>
Date: Thu, 04 Sep 2014 10:48:05 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v3 1/4] ftracetest: Initial commit for ftracetest
References: <20140902110632.3207.20043.stgit@kbuild-f20.novalocal> <20140902110639.3207.38388.stgit@kbuild-f20.novalocal> <87r3zs9n6m.fsf@sejong.aot.lge.com>
In-Reply-To: <87r3zs9n6m.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/09/04 10:41), Namhyung Kim wrote:
> Hi Masami,
> 
> Just a nit..
> 
> 
> On Tue, 02 Sep 2014 11:06:39 +0000, Masami Hiramatsu wrote:
>> ftracetest is a collection of testcase shell-scripts for ftrace.
>> To avoid regressions of ftrace, these testcases check correct
>> ftrace behaviors. If someone would like to add any features on
>> ftrace, the patch series should have at least one testcase for
>> checking the new behavior.
> 
> 
> [SNIP]
>> +# Run one test case
>> +run_test() { # testfile
>> +  local testname=`basename $1`
>> +  local testlog=`mktemp --tmpdir=$LOG_DIR ${testname}-XXXXXX.log`
>> +  testcase $1
>> +  echo "execute: "$1 > $testlog
>> +  (cd $TRACING_DIR; set -x ; . $t) >> $testlog 2>&1
> 
> s/$t/$1/ ?

Oops, right! I missed that. Since the $1 is same as $t, the
test itself works, but it should be fixed.

Thank you!

> 
> Thanks,
> Namhyung
> 
> 
>> +  ret=$?
>> +  if [ $ret -ne 0 ]; then
>> +    failed
>> +    catlog $testlog
>> +  else
>> +    passed
>> +    [ $KEEP_LOG -eq 0 ] && rm $testlog
>> +  fi
>> +}
>> +
>> +# Main loop
>> +for t in $TEST_CASES; do
>> +  run_test $t
>> +done
>> +prlog ""
>> +prlog "# of passed: " `echo $PASSED_CASES | wc -w`
>> +prlog "# of failed: " `echo $FAILED_CASES | wc -w`
>> +
>> +test -z "$FAILED_CASES" # if no error, return 0
>> diff --git a/tools/testing/ftrace/test.d/template b/tools/testing/ftrace/test.d/template
>> new file mode 100644
>> index 0000000..ce5f735
>> --- /dev/null
>> +++ b/tools/testing/ftrace/test.d/template
>> @@ -0,0 +1,4 @@
>> +#!/bin/sh
>> +# description: %HERE DESCRIBE WHAT THIS DOES%
>> +# you have to add ".tc" extention for your testcase file
>> +exit 0 # Return 0 if the test is passed, otherwise return !0
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


