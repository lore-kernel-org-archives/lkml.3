Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbaIDEj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 00:39:59 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:38844 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaIDEj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 00:39:58 -0400
Message-ID: <5407ED17.5060000@hitachi.com>
Date: Thu, 04 Sep 2014 13:39:51 +0900
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
Subject: Re: Re: [RFC PATCH v3 4/4] ftracetest: Add XFAIL/XPASS and POSIX.3
 std. result codes
References: <20140902110632.3207.20043.stgit@kbuild-f20.novalocal> <20140902110659.3207.67086.stgit@kbuild-f20.novalocal> <87mwag9kyp.fsf@sejong.aot.lge.com>
In-Reply-To: <87mwag9kyp.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/09/04 11:29), Namhyung Kim wrote:
>> diff --git a/tools/testing/ftrace/test.d/basic3.tc b/tools/testing/ftrace/test.d/basic3.tc
>> index 0c1a3a2..7bc5a53 100644
>> --- a/tools/testing/ftrace/test.d/basic3.tc
>> +++ b/tools/testing/ftrace/test.d/basic3.tc
>> @@ -1,8 +1,9 @@
>>  #!/bin/sh
>>  # description: Basic trace clock test
>> -[ -f trace_clock ] || exit 1
>> +[ -f trace_clock ] || exit $FAIL # this is basic feature, must be there
>>  for c in `cat trace_clock | tr  -d \[\]`; do
>> -  echo $c > trace_clock || exit 1
>> -  grep '\['$c'\]' trace_clock || exit 1
>> +  echo $c > trace_clock || exit $FAIL
>> +  grep '\['$c'\]' trace_clock || exit $FAIL
>>  done
>> -echo local > trace_clock
>> +echo local > trace_clock || exit $FAIL
>> +exit $PASS
> 
> IMHO it's a bit sad that we need to write every test in this way -
> adding '|| exit $FAIL' for every command.  It'd be better if only
> exceptional cases require that explicitly and normal cases live in
> simple.
> 
> Can we do better - like using trap or something?

Hmm, no, trap is only for the signal trapping, and using signal
means run "kill" command for special errors. That may not be what
you want... :(

Perhaps, "set -e" may help you to simplify the script. But
since it also returns various exit code, you can not control it.
(I hope to have the "atexit" for dash...)

Anyway, IMHO, the test cases should express what happened clearly
since the test is a kind of verification process.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


