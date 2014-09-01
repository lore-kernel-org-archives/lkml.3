Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaIADRa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 23:17:30 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39559 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbaIADR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 23:17:28 -0400
Message-ID: <5403E53F.50806@hitachi.com>
Date: Mon, 01 Sep 2014 12:17:19 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 4/4] ftracetest: Add XFAIL/XPASS/UNSUPPORTED as
 result code
References: <20140826111511.5711.28493.stgit@kbuild-fedora.novalocal> <20140826111539.5711.93588.stgit@kbuild-fedora.novalocal> <53FFD1E8.6070508@osg.samsung.com>
In-Reply-To: <53FFD1E8.6070508@osg.samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/08/29 10:05), Shuah Khan wrote:
> On 08/26/2014 05:15 AM, Masami Hiramatsu wrote:
>> Add XFAIL, XPASS and UNSUPPORTED as a result code. These are
>> used for the results that test case is expected to fail or
>> unsupported feature (by config).
>> This also introduces PASS/FAIL/XFAIL/XPASS/UNSUP result codes
>> for each testcase. Since the results are not binary, each
>> testcase must use these code to return the test result.
>>
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> ---
>>  tools/testing/ftrace/ftracetest                    |   61 +++++++++++++++-----
>>  tools/testing/ftrace/test.d/basic1.tc              |    6 ++
>>  tools/testing/ftrace/test.d/basic2.tc              |    6 +-
>>  tools/testing/ftrace/test.d/basic3.tc              |    9 ++-
>>  .../testing/ftrace/test.d/kprobe/add_and_remove.tc |   15 +++--
>>  tools/testing/ftrace/test.d/kprobe/busy_check.tc   |   20 +++----
>>  tools/testing/ftrace/test.d/template               |    6 ++
>>  7 files changed, 84 insertions(+), 39 deletions(-)
>>
>> diff --git a/tools/testing/ftrace/ftracetest b/tools/testing/ftrace/ftracetest
>> index 0378c8a..bfcd56a 100755
>> --- a/tools/testing/ftrace/ftracetest
>> +++ b/tools/testing/ftrace/ftracetest
>> @@ -107,22 +107,53 @@ catlog() { #file
>>  }
>>  
>>  # Testcase management
>> +# Test result codes
>> +PASS=0	# The test succeeded.
>> +FAIL=1	# The test failed, but was expected to succeed.
>> +XFAIL=2	# The test failed, and was expected to fail.
>> +XPASS=3	# The test succeeded, but was expected to fail.
> 
> This one is confusing. It is still a failure. XFAIL case is
> expected to fail, using that convention XPASS should be
> expected to pass?

I see, but they have been already used as above by Dejagnu testing framework.
http://www.delorie.com/gnu/docs/dejagnu/dejagnu_6.html

Of course, it might be better to support only POSIX compatible results at
first.

> Can we use XFAIL0 for XFAIL pass case and XFAIL1 for XFAIL fail
> case?

No, new definition can confuse developers.
To avoid confusion, I'd like to use the same definitions as Dejegnu does.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


