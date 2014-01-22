Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbaAVSKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 13:10:14 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:32976 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaAVSKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 13:10:12 -0500
Message-ID: <1390414208.2866.11.camel@j-VirtualBox>
Subject: Re: [PATCH 2/2] sched: add statistic for rq->max_idle_balance_cost
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alex Shi <alex.shi@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        daniel.lezcano@linaro.org, Mike Galbraith <efault@gmx.de>,
        wangyun@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 22 Jan 2014 10:10:08 -0800
In-Reply-To: <20140122160901.GW13532@twins.programming.kicks-ass.net>
References: <1390282399-17091-1-git-send-email-alex.shi@linaro.org>
	 <1390282399-17091-2-git-send-email-alex.shi@linaro.org>
	 <CAGQ1y=4rgj8qPeKQhNTA5__VzrOQ1uCqFZrVLO3MO9MfL+6UEg@mail.gmail.com>
	 <52DF802D.4030608@linaro.org>
	 <20140122160901.GW13532@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-22 at 17:09 +0100, Peter Zijlstra wrote:
> On Wed, Jan 22, 2014 at 04:24:13PM +0800, Alex Shi wrote:
> > From: Alex Shi <alex.shi@linaro.org>
> > Date: Tue, 21 Jan 2014 13:28:55 +0800
> > Subject: [RFC PATCH] sched: add statistic for rq->max_idle_balance_cost
> > 
> > It's useful to track this value in debug mode.
> > 
> > Signed-off-by: Alex Shi <alex.shi@linaro.org>
> > ---
> >  kernel/sched/debug.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
> > index 1e43e70..f5c529a 100644
> > --- a/kernel/sched/debug.c
> > +++ b/kernel/sched/debug.c
> > @@ -315,6 +315,7 @@ do {									\
> >  	P(sched_goidle);
> >  #ifdef CONFIG_SMP
> >  	P64(avg_idle);
> > +	P64(max_idle_balance_cost);
> >  #endif
> >   	P(ttwu_count);
> 
> Not also the per-sd value in sd_alloc_ctl_domain_table() ?

Yeah, tracking the sd->max_newidle_lb_cost can also be useful.


