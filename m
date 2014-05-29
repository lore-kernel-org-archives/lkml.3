Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934547AbaE2OEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:04:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:48018 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932751AbaE2OEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 10:04:32 -0400
Date: Thu, 29 May 2014 16:04:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org
Subject: Re: [PATCH v2 10/11] sched: move cfs task on a CPU with higher
 capacity
Message-ID: <20140529140427.GI11074@laptop.programming.kicks-ass.net>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-11-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400860385-14555-11-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 05:53:04PM +0200, Vincent Guittot wrote:
> @@ -7282,6 +7289,12 @@ static inline int nohz_kick_needed(struct rq *rq)
>  
>  		if (nr_busy > 1)
>  			goto need_kick_unlock;
> +
> +		if ((rq->cfs.h_nr_running >= 1)
> +		 && ((rq->cpu_power * sd->imbalance_pct) <
> +					(rq->cpu_power_orig * 100)))
> +			goto need_kick_unlock;
> +
>  	}
>  
>  	sd = rcu_dereference(per_cpu(sd_asym, cpu));

So what happens when a cpu is consistently low on power (say due to a
pinned RT task) the balancer would quickly adjust the load level, but
this would endlessly kick things into action, even though we're balanced
just fine.
