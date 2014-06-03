Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945AbaFDHPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 03:15:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:47213 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932067AbaFDHPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 03:15:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,971,1392192000"; 
   d="scan'208";a="549487850"
Date: Wed, 4 Jun 2014 07:11:29 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v2 08/11] sched: get CPU's activity statistic
Message-ID: <20140603231129.GA662@intel.com>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-9-git-send-email-vincent.guittot@linaro.org>
 <20140528121001.GI19967@e103034-lin>
 <20140603154058.GY30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603154058.GY30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The basic problem is that worst case: sum starting from 0 and period
> > already at LOAD_AVG_MAX = 47742, it takes LOAD_AVG_MAX_N = 345 periods
> > (ms) for sum to reach 47742. In other words, the cpu might have been
> > fully utilized for 345 ms before it is considered fully utilized.
> > Periodic load-balancing happens much more frequently than that.
> 
> Like said earlier the 94% mark is actually hit much sooner, but yes,
> likely still too slow.
> 
> 50% at 32 ms, 75% at 64 ms, 87.5% at 96 ms, etc..
> 
> > In the previous
> > discussion [1] it was suggested that a sum of unweighted task
> > runnable_avg_{sum,period} ratio instead. That is, an unweighted
> > equivalent to weighted_cpuload(). That isn't a perfect solution either.
> > It is fine as long as the cpus are not fully utilized, but when they are
> > we need to use weighted_cpuload() to preserve smp_nice. What to do
> > around the tipping point needs more thought, but I think that is
> > currently the best proposal for a solution for task and cpu utilization.
> 
> I'm not too worried about the tipping point, per task runnable figures
> of an overloaded cpu are higher, so migration between an overloaded cpu
> and an underloaded cpu are going to be tricky no matter what we do.
> 
Hi,

Can I join this dicussion late?

As I understand, you are talking about a metric for cpu activity. And the
issues about runnable_avg_sum is its sluggishness to latest change, and also
need unweighted load averages.

You might be aware of my recent proposal to CPU ConCurrency (CC). It is 1) an
average of nr_running, or 2) nr_running weighted CPU utilization. So it is a
combination of CPU utlization and run queue (both factored  natually). It
meets the needs you talked, I think. You can take it as a candidate, or at
least we can talk about it?

Thanks,
Yuyang
