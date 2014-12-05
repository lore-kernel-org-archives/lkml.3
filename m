Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750937AbaLEFXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 00:23:32 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40375 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaLEFXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 00:23:30 -0500
Message-ID: <5481414B.5090805@hitachi.com>
Date: Fri, 05 Dec 2014 14:23:23 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/2] ftracetest: Add --verbose option for showing echo
 output
References: <20141204194109.7376.84279.stgit@localhost.localdomain> <20141204194123.7376.22964.stgit@localhost.localdomain> <20141205050843.GA18217@sejong>
In-Reply-To: <20141205050843.GA18217@sejong>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/12/05 14:08), Namhyung Kim wrote:
> On Thu, Dec 04, 2014 at 02:41:23PM -0500, Masami Hiramatsu wrote:
>> Add --verbose/-v option for showing echo output in testcases.
>> This is good for checking the progress of testcases which
>> take a longer time to run.
>>
>> To implement this feature, all the testcase failures are
>> captured in ftracetest and send signal to set SIG_RESULT=FAIL.
>>
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> ---
> 
> [SNIP]
>> -  # setup PID and PPID, $$ is not updated.
>> -  (cd $TRACING_DIR; read PID _ < /proc/self/stat ;
>> -   set -e; set -x; . $1) >> $testlog 2>&1
>> -  eval_result $? $SIG_RESULT
>> +  if [ $VERBOSE -ne 0 ]; then
>> +    __run_test $1 2>> $testlog | tee -a $testlog
> 
> Shouldn't it be
> 
>        __run_test $1 2>&1 | tee -a $testlog
> 
> ?

No, that outputs both stdout and stderr to $testlog and console.
What I'd like to do above is only stdout to $testlog and console and
stderr goes only to $testlog. (Note that __run_test set -x which outputs
every executed command to stderr)

Thank you,

> 
> Thanks,
> Namhyung
> 
> 
>> +  else
>> +    __run_test $1 >> $testlog 2>&1
>> +  fi
>> +  eval_result $SIG_RESULT
>>    if [ $? -eq 0 ]; then
>>      # Remove test log if the test was done as it was expected.
>>      [ $KEEP_LOG -eq 0 ] && rm $testlog
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


