Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbaJCOgn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 10:36:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:34347 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbaJCOgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 10:36:40 -0400
Date: Fri, 3 Oct 2014 16:36:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        riel@redhat.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com, pjt@google.com,
        bsegall@google.com
Subject: Re: [PATCH v6 3/6] sched: add utilization_avg_contrib
Message-ID: <20141003143634.GL2849@worktop.programming.kicks-ass.net>
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
> +++ b/kernel/sched/sched.h
> @@ -339,8 +339,14 @@ struct cfs_rq {
>  	 * Under CFS, load is tracked on a per-entity basis and aggregated up.
>  	 * This allows for the description of both thread and group usage (in
>  	 * the FAIR_GROUP_SCHED case).
> +	 * runnable_load_avg is the sum of the load_avg_contrib of the
> +	 * sched_entities on the rq.

> +	 * blocked_load_avg is similar to runnable_load_avg except that its
> +	 * the blocked sched_entities on the rq.

Strictly speaking blocked entities aren't on a rq as such, but yeah, no
idea how to better put it. Just being a pedantic, which isn't helpful I
guess :-)

> +	 * utilization_load_avg is the sum of the average running time of the
> +	 * sched_entities on the rq.
>  	 */

So I think there was some talk about a blocked_utilization thingy, which
would track the avg running time of the tasks currently asleep, right?

> +	unsigned long runnable_load_avg, blocked_load_avg, utilization_load_avg;
>  	atomic64_t decay_counter;
>  	u64 last_decay;
>  	atomic_long_t removed_load;
