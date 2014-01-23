Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbaAWJzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 04:55:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55845 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaAWJzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 04:55:15 -0500
Date: Thu, 23 Jan 2014 10:54:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@linaro.org>
Cc: Jason Low <jason.low2@hp.com>, Ingo Molnar <mingo@redhat.com>,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        daniel.lezcano@linaro.org, Mike Galbraith <efault@gmx.de>,
        wangyun@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] sched: add statistic for rq->max_idle_balance_cost
Message-ID: <20140123095443.GQ30183@twins.programming.kicks-ass.net>
References: <1390282399-17091-1-git-send-email-alex.shi@linaro.org>
 <1390282399-17091-2-git-send-email-alex.shi@linaro.org>
 <CAGQ1y=4rgj8qPeKQhNTA5__VzrOQ1uCqFZrVLO3MO9MfL+6UEg@mail.gmail.com>
 <52DF802D.4030608@linaro.org>
 <20140122160901.GW13532@twins.programming.kicks-ass.net>
 <1390414208.2866.11.camel@j-VirtualBox>
 <52E0BB75.2080102@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E0BB75.2080102@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 02:49:25PM +0800, Alex Shi wrote:
> On 01/23/2014 02:10 AM, Jason Low wrote:
> >>> > >  	P64(avg_idle);
> >>> > > +	P64(max_idle_balance_cost);
> >>> > >  #endif
> >>> > >   	P(ttwu_count);
> >> > 
> >> > Not also the per-sd value in sd_alloc_ctl_domain_table() ?
> > Yeah, tracking the sd->max_newidle_lb_cost can also be useful.
> > 
> > 
> 
> Thanks for suggestion!
> 
> I thought the sd->max_newidle_lb_cost keep changing. But yes, it's
> still meaningful. 
> BTW, in the pandaboard ES, sd balance cost is about 1~2ms.

That's an insane amount of time for only 2 cpus.

> ---
> 
> From d37e712b623fb6776d0caba8e4bd06460e26b84e Mon Sep 17 00:00:00 2001
> From: Alex Shi <alex.shi@linaro.org>
> Date: Tue, 21 Jan 2014 13:28:55 +0800
> Subject: [PATCH] sched: add statistic for newidle load balance cost
> 
> Tracking rq->max_idle_balance_cost and sd->max_newidle_lb_cost
> It's useful to track these values in debug mode.
> 
> Signed-off-by: Alex Shi <alex.shi@linaro.org>
> ---
>  kernel/sched/core.c  | 7 +++++--
>  kernel/sched/debug.c | 1 +
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index c3f3824..a046bc3 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4293,7 +4293,7 @@ set_table_entry(struct ctl_table *entry,
>  static struct ctl_table *
>  sd_alloc_ctl_domain_table(struct sched_domain *sd)
>  {
> -	struct ctl_table *table = sd_alloc_ctl_entry(8);
> +	struct ctl_table *table = sd_alloc_ctl_entry(9);

tip/master has 13 there, not 8.
