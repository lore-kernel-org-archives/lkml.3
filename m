Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbaLEGes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 01:34:48 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:54095 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaLEGer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 01:34:47 -0500
Message-ID: <54815200.4040807@hitachi.com>
Date: Fri, 05 Dec 2014 15:34:40 +0900
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
References: <20141204194109.7376.84279.stgit@localhost.localdomain> <20141204194123.7376.22964.stgit@localhost.localdomain> <20141205050843.GA18217@sejong> <5481414B.5090805@hitachi.com> <20141205055245.GB18217@sejong>
In-Reply-To: <20141205055245.GB18217@sejong>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/12/05 14:52), Namhyung Kim wrote:
> On Fri, Dec 05, 2014 at 02:23:23PM +0900, Masami Hiramatsu wrote:
>> (2014/12/05 14:08), Namhyung Kim wrote:
>>> On Thu, Dec 04, 2014 at 02:41:23PM -0500, Masami Hiramatsu wrote:
>>>> Add --verbose/-v option for showing echo output in testcases.
>>>> This is good for checking the progress of testcases which
>>>> take a longer time to run.
>>>>
>>>> To implement this feature, all the testcase failures are
>>>> captured in ftracetest and send signal to set SIG_RESULT=FAIL.
>>>>
>>>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>>>> ---
>>>
>>> [SNIP]
>>>> -  # setup PID and PPID, $$ is not updated.
>>>> -  (cd $TRACING_DIR; read PID _ < /proc/self/stat ;
>>>> -   set -e; set -x; . $1) >> $testlog 2>&1
>>>> -  eval_result $? $SIG_RESULT
>>>> +  if [ $VERBOSE -ne 0 ]; then
>>>> +    __run_test $1 2>> $testlog | tee -a $testlog
>>>
>>> Shouldn't it be
>>>
>>>        __run_test $1 2>&1 | tee -a $testlog
>>>
>>> ?
>>
>> No, that outputs both stdout and stderr to $testlog and console.
>> What I'd like to do above is only stdout to $testlog and console and
>> stderr goes only to $testlog. (Note that __run_test set -x which outputs
>> every executed command to stderr)
> 
> Hmm.. so the actual output of the failing command is not shown on
> console even when -v option is given, right?

No, if a command fails, the testcase is automatically terminated
(by set -e) and $testlog is dumped on console, so that tester can
trace back the log.

> Anyway I worried about that the order of messages might be mixed..
> 
>   echo msg1 > /dev/stdout
>   echo msg2 > /dev/stderr
>   echo msg3 > /dev/stdout
>   echo msg4 > /dev/stderr
> 
> So the output in this case can be like msg2, msg4, msg1, and msg3..?

I'm not sure this can happen... Would you have any other good way to
solve this?

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


