Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbaAVQJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 11:09:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33084 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbaAVQJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 11:09:27 -0500
Date: Wed, 22 Jan 2014 17:09:01 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@linaro.org>
Cc: Jason Low <jason.low2@hp.com>, Ingo Molnar <mingo@redhat.com>,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        daniel.lezcano@linaro.org, Mike Galbraith <efault@gmx.de>,
        wangyun@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] sched: add statistic for rq->max_idle_balance_cost
Message-ID: <20140122160901.GW13532@twins.programming.kicks-ass.net>
References: <1390282399-17091-1-git-send-email-alex.shi@linaro.org>
 <1390282399-17091-2-git-send-email-alex.shi@linaro.org>
 <CAGQ1y=4rgj8qPeKQhNTA5__VzrOQ1uCqFZrVLO3MO9MfL+6UEg@mail.gmail.com>
 <52DF802D.4030608@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DF802D.4030608@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 04:24:13PM +0800, Alex Shi wrote:
> From: Alex Shi <alex.shi@linaro.org>
> Date: Tue, 21 Jan 2014 13:28:55 +0800
> Subject: [RFC PATCH] sched: add statistic for rq->max_idle_balance_cost
> 
> It's useful to track this value in debug mode.
> 
> Signed-off-by: Alex Shi <alex.shi@linaro.org>
> ---
>  kernel/sched/debug.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
> index 1e43e70..f5c529a 100644
> --- a/kernel/sched/debug.c
> +++ b/kernel/sched/debug.c
> @@ -315,6 +315,7 @@ do {									\
>  	P(sched_goidle);
>  #ifdef CONFIG_SMP
>  	P64(avg_idle);
> +	P64(max_idle_balance_cost);
>  #endif
>   	P(ttwu_count);

Not also the per-sd value in sd_alloc_ctl_domain_table() ?

