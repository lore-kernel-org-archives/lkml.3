Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbaBMHOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 02:14:45 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:39456 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaBMHOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 02:14:42 -0500
Message-ID: <52FC70D8.5060107@linaro.org>
Date: Thu, 13 Feb 2014 15:14:32 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>, peterz@infradead.org,
        mingo@kernel.org
CC: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH V2 1/3] sched: Remove cpu parameter for idle_balance()
References: <1391728237-4441-1-git-send-email-daniel.lezcano@linaro.org> <1391728237-4441-2-git-send-email-daniel.lezcano@linaro.org>
In-Reply-To: <1391728237-4441-2-git-send-email-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 07:10 AM, Daniel Lezcano wrote:
> The cpu parameter passed to idle_balance is not needed as it could
> be retrieved from the struct rq.
> 
> Cc: alex.shi@linaro.org
> Cc: peterz@infradead.org
> Cc: mingo@kernel.org
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

Reviewed-by: Alex Shi <alex.shi@linaro.org>
> ---
>  kernel/sched/core.c  |    2 +-
>  kernel/sched/fair.c  |    3 ++-
>  kernel/sched/sched.h |    4 ++--
>  3 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 210a12a..16b97dd 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2705,7 +2705,7 @@ need_resched:
>  	pre_schedule(rq, prev);
>  
>  	if (unlikely(!rq->nr_running))
> -		idle_balance(cpu, rq);
> +		idle_balance(rq);
>  
>  	put_prev_task(rq, prev);
>  	next = pick_next_task(rq);
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 4caa803..428bc9d 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -6531,12 +6531,13 @@ out:
>   * idle_balance is called by schedule() if this_cpu is about to become
>   * idle. Attempts to pull tasks from other CPUs.
>   */
> -void idle_balance(int this_cpu, struct rq *this_rq)
> +void idle_balance(struct rq *this_rq)
>  {
>  	struct sched_domain *sd;
>  	int pulled_task = 0;
>  	unsigned long next_balance = jiffies + HZ;
>  	u64 curr_cost = 0;
> +	int this_cpu = this_rq->cpu;
>  
>  	this_rq->idle_stamp = rq_clock(this_rq);
>  
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index c2119fd..1436219 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -1176,14 +1176,14 @@ extern const struct sched_class idle_sched_class;
>  extern void update_group_power(struct sched_domain *sd, int cpu);
>  
>  extern void trigger_load_balance(struct rq *rq);
> -extern void idle_balance(int this_cpu, struct rq *this_rq);
> +extern void idle_balance(struct rq *this_rq);
>  
>  extern void idle_enter_fair(struct rq *this_rq);
>  extern void idle_exit_fair(struct rq *this_rq);
>  
>  #else	/* CONFIG_SMP */
>  
> -static inline void idle_balance(int cpu, struct rq *rq)
> +static inline void idle_balance(struct rq *rq)
>  {
>  }
>  
> 


-- 
Thanks
    Alex
