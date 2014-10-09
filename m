Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbaJIMRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 08:17:06 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46426 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaJIMQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 08:16:57 -0400
Date: Thu, 9 Oct 2014 14:16:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, kamalesh@linux.vnet.ibm.com,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        riel@redhat.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com
Subject: Re: [PATCH v7 6/7] sched: replace capacity_factor by usage
Message-ID: <20141009121643.GQ4750@worktop.programming.kicks-ass.net>
References: <1412684017-16595-1-git-send-email-vincent.guittot@linaro.org>
 <1412684017-16595-7-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412684017-16595-7-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 02:13:36PM +0200, Vincent Guittot wrote:
> +static inline bool
> +group_has_capacity(struct lb_env *env, struct sg_lb_stats *sgs)
>  {
> +	if ((sgs->group_capacity * 100) >
> +			(sgs->group_usage * env->sd->imbalance_pct))
> +		return true;

Why the imb_pct there? We're looking for 100% utilization, not 130 or
whatnot, right?

> +	if (sgs->sum_nr_running < sgs->group_weight)
> +		return true;

With the code as it stands, this is the cheaper test (no mults) so why
is it second?

> +	return false;
> +}
>  
> +static inline bool
> +group_is_overloaded(struct lb_env *env, struct sg_lb_stats *sgs)
> +{
> +	if (sgs->sum_nr_running <= sgs->group_weight)
> +		return false;
> +
> +	if ((sgs->group_capacity * 100) <
> +			(sgs->group_usage * env->sd->imbalance_pct))
> +		return true;
>  
> +	return false;
>  }

Same thing here wrt imb_pct
