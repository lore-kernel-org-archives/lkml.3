Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968Ab3EGAYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 20:24:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:51183 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794Ab3EGAYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 20:24:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,624,1363158000"; 
   d="scan'208";a="298563232"
Message-ID: <518849CB.9080103@intel.com>
Date: Tue, 07 May 2013 08:24:43 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 5/7] sched: compute runnable load avg in cpu_load and
 cpu_avg_load_per_task
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-6-git-send-email-alex.shi@intel.com> <CAPM31RLJe19FH+RYipwm4kwtzmFHoS2xGTx4iZ9+qwDJZ_pf3A@mail.gmail.com> <5187C59F.1020305@intel.com> <CAPM31RJBiGtLPbBwuWJQvW6e=5x=X7+Qx5YKJkjtyr_HDEqivg@mail.gmail.com>
In-Reply-To: <CAPM31RJBiGtLPbBwuWJQvW6e=5x=X7+Qx5YKJkjtyr_HDEqivg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The load-balancer has a longer time horizon; think of blocked_loag_avg
> to be a signal for the load, already assigned to this cpu, which is
> expected to appear (within roughly the next quantum).
> 
> Consider the following scenario:
> 
> tasks: A,B (40% busy), C (90% busy)
> 
> Suppose we have:
> CPU 0:  CPU 1:
>  A            C
>  B
> 
> Then, when C blocks the load balancer ticks.
> 
> If we considered only runnable_load then A or B would be eligible for
> migration to CPU 1, which is essentially where we are today.

Thanks for re-clarify. Yes, that's the value of blocked_load_avg here. :)
Anyway, will try to measure them by some benchmarks.
> 
>>
>> But your concern is worth to try. I will change the patchset and give
>> the testing results.
>> I guess not, the old load.weight is unsigned long, and runnable_load_avg
>> is smaller than the load.weight. so it should be fine.
>>
>> btw, according to above reason, guess move runnable_load_avg to
>> 'unsigned long' type is ok, do you think so?
>>
> 
> Hmm, so long as it's unsigned long and not u32 that should be OK.
> 
> From a technical standpoint:
> We make the argument that we run out of address space before we can
> overflow load.weight in the 32-bit case, we can make the same argument
> here.

thanks for the comments and input! :)
> 
>>
>> --
>> Thanks
>>     Alex


-- 
Thanks
    Alex
