Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934226Ab3E1NgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:36:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:32277 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934196Ab3E1NgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:36:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,758,1363158000"; 
   d="scan'208";a="344371099"
Message-ID: <51A4B2CD.4010801@intel.com>
Date: Tue, 28 May 2013 21:36:13 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com
Subject: Re: [patch v6 8/8] sched: remove blocked_load_avg in tg
References: <1368199049-2798-1-git-send-email-alex.shi@intel.com> <1368199049-2798-9-git-send-email-alex.shi@intel.com> <20130514083148.GD15942@dyad.programming.kicks-ass.net> <5192217D.5030706@intel.com> <20130516092308.GH19669@dyad.programming.kicks-ass.net>
In-Reply-To: <20130516092308.GH19669@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 05:23 PM, Peter Zijlstra wrote:
> On Tue, May 14, 2013 at 07:35:25PM +0800, Alex Shi wrote:
> 
>> > I tested all benchmarks on cover letter maintained, aim7, kbuild etc.
>> > with autogroup enabled. There is no clear performance change.
>> > But since the machine just run benchmark without anyother load, that
>> > doesn't enough.
> Back when we started with smp-fair cgroup muck someone wrote a test for it. I
> _think_ it ended up in the LTP test-suite.

Peter:

copy changlong's testing result again, the ltp cgroup stress testing
show this patchset can reduce the stress testing time:

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

Paul, would you like to give some comments?

> 
> Now I don't know if that's up-to-date enough to catch some of the cases we've
> recently fixed (as in the past few years) so it might want to be updated.
> 
> Paul, do you guys at Google have some nice test-cases for all this?



-- 
Thanks
    Alex
