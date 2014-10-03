Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbaJCOQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 10:16:25 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33428 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbaJCOQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 10:16:21 -0400
Date: Fri, 3 Oct 2014 16:15:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        riel@redhat.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com, pjt@google.com,
        bsegall@google.com
Subject: Re: [PATCH v6 3/6] sched: add utilization_avg_contrib
Message-ID: <20141003141559.GK2849@worktop.programming.kicks-ass.net>
References: <1411488485-10025-1-git-send-email-vincent.guittot@linaro.org>
 <1411488485-10025-4-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411488485-10025-4-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 06:08:02PM +0200, Vincent Guittot wrote:
>  struct sched_avg {
> +	u64 last_runnable_update;
> +	s64 decay_count;
> +	/*
> +	 * utilization_avg_contrib describes the amount of time that a
> +	 * sched_entity is running on a CPU. It is based on running_avg_sum
> +	 * and is scaled in the range [0..SCHED_LOAD_SCALE].
> +	 * load_avg_contrib described the the amount of time that a
> +	 * sched_entity is runnable on a rq. It is based on both
> +	 * runnable_avg_sum and the weight of the task.
> +	 */
> +	unsigned long load_avg_contrib, utilization_avg_contrib;
>  	/*
>  	 * These sums represent an infinite geometric series and so are bound
>  	 * above by 1024/(1-y).  Thus we only need a u32 to store them for all
>  	 * choices of y < 1-2^(-32)*1024.
> +	 * runnable_avg_sum represents the amount of time a sched_entity is on
> +	 * the runqueue whereas running_avg_sum reflects the time the
> +	 * sched_entity is effectively running on the runqueue.

I would say: 'running on the cpu'. I would further clarify that runnable
also includes running, the above could be read such that runnable is
only the time spend waiting on the queue, excluding the time spend on
the cpu.

>  	 */
> +	u32 runnable_avg_sum, avg_period, running_avg_sum;
>  };
