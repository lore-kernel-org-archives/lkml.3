Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab3EWHc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 03:32:27 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:50528 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab3EWHc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 03:32:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130516092308.GH19669@dyad.programming.kicks-ass.net>
References: <1368199049-2798-1-git-send-email-alex.shi@intel.com>
	<1368199049-2798-9-git-send-email-alex.shi@intel.com>
	<20130514083148.GD15942@dyad.programming.kicks-ass.net>
	<5192217D.5030706@intel.com>
	<20130516092308.GH19669@dyad.programming.kicks-ass.net>
Date: Thu, 23 May 2013 15:32:25 +0800
Message-ID: <CAJWCg7PKpGgHKqhm6Xq8DfVEWGoDsgS8s99r3JS7Wce7WS=B_Q@mail.gmail.com>
Subject: Re: [patch v6 8/8] sched: remove blocked_load_avg in tg
From: Changlong Xie <xiechanglong87@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alex Shi <alex.shi@intel.com>, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mgorman@suse.de, riel@redhat.com, wangyun@linux.vnet.ibm.com,
        Changlong Xie <changlongx.xie@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/16 Peter Zijlstra <peterz@infradead.org>:
> On Tue, May 14, 2013 at 07:35:25PM +0800, Alex Shi wrote:
>
>> I tested all benchmarks on cover letter maintained, aim7, kbuild etc.
>> with autogroup enabled. There is no clear performance change.
>> But since the machine just run benchmark without anyother load, that
>> doesn't enough.
>
> Back when we started with smp-fair cgroup muck someone wrote a test for it. I
> _think_ it ended up in the LTP test-suite.
>

Hi Peter

I just download the lastest ltp from
http://sourceforge.net/projects/ltp/files/LTP%20Source/ltp-20130503/
and do cgroup benchmark tests on our SB-EP machine with 2S*8CORE*2SMT,
64G memory.

Following is my testing procedures:
1. tar -xvf ltp-full-20130503.tar
2. cd ltp-full-20130503
3. ./configure prefix=/mnt/ltp && make -j32 && sudo make install
4. cd /mnt/ltp

# create general testcase named cgroup_fj
5. echo -e "cgroup_fj  run_cgroup_test_fj.sh" > runtest/cgroup

# we only test cpuset/cpu/cpuacct cgroup benchmark cases, here is my
cgroup_fj_testcases.sh
6. [changlox@lkp-sb03 bin]$ cat testcases/bin/cgroup_fj_testcases.sh
stress 2 2 1 1 1
stress 4 2 1 1 1
stress 5 2 1 1 1
stress 2 1 1 1 2
stress 2 1 1 2 1
stress 2 1 1 2 2
stress 2 1 1 2 3
stress 2 1 2 1 1
stress 2 1 2 1 2
stress 2 1 2 1 3
stress 2 1 2 2 1
stress 2 1 2 2 2
stress 4 1 1 1 2
stress 4 1 2 1 1
stress 4 1 2 1 2
stress 4 1 2 1 3
stress 5 1 1 1 2
stress 5 1 1 2 1
stress 5 1 1 2 2
stress 5 1 1 2 3
stress 5 1 2 1 1
stress 5 1 2 1 2
stress 5 1 2 1 3
stress 5 1 2 2 1
stress 5 1 2 2 2

# run test
7. sudo ./runltp -p -l /tmp/cgroup.results.log  -d /tmp -o
/tmp/cgroup.log -f cgroup

my test results:
3.10-rc1          patch1-7         patch1-8
duration=764   duration=754   duration=750
duration=764   duration=754   duration=751
duration=763   duration=755   duration=751

duration means the seconds of testing cost.

Tested-by: Changlong Xie <changlongx.xie@intel.com>

> Now I don't know if that's up-to-date enough to catch some of the cases we've
> recently fixed (as in the past few years) so it might want to be updated.
>
> Paul, do you guys at Google have some nice test-cases for all this?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



--
Best regards
Changlox
