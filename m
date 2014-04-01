Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbaDAKqC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 06:46:02 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:47934 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbaDAKqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 06:46:00 -0400
Message-ID: <533A97EF.7030900@linux.vnet.ibm.com>
Date: Tue, 01 Apr 2014 16:11:51 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        Morten.Rasmussen@arm.com, efault@gmx.de,
        linaro-kernel@lists.linaro.org
Subject: Re: [RFC 4/4] sched: add per group cpu_power_orig
References: <1396013246-6577-1-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1396013246-6577-1-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040110-6688-0000-0000-000000C41E78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

On 03/28/2014 06:57 PM, Vincent Guittot wrote:
> This new field cpu_power_orig reflects the available capacity of a CPUs unlike
> the cpu_power which reflects the current capacity that can be altered by
> frequency and rt tasks.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>

Should not the subject be "add per rq cpu_power_orig"?

Regards
Preeti U Murthy
> ---
>  kernel/sched/core.c  | 2 +-
>  kernel/sched/fair.c  | 1 +
>  kernel/sched/sched.h | 1 +
>  3 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 5b20b27..8513f83 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6911,7 +6911,7 @@ void __init sched_init(void)
>  #ifdef CONFIG_SMP
>  		rq->sd = NULL;
>  		rq->rd = NULL;
> -		rq->cpu_power = SCHED_POWER_SCALE;
> +		rq->cpu_power = rq->cpu_power_orig = SCHED_POWER_SCALE;
>  		rq->post_schedule = 0;
>  		rq->active_balance = 0;
>  		rq->next_balance = jiffies;
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 7387c05..f1e4db6 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5611,6 +5611,7 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
> 
>  	power >>= SCHED_POWER_SHIFT;
> 
> +	cpu_rq(cpu)->cpu_power_orig = power;
>  	sdg->sgp->power_orig = power;
> 
>  	if (sched_feat(ARCH_POWER))
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 46c3784..2abdf5c 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -578,6 +578,7 @@ struct rq {
>  	struct sched_domain *sd;
> 
>  	unsigned long cpu_power;
> +	unsigned long cpu_power_orig;
> 
>  	unsigned char idle_balance;
>  	/* For active balancing */
> 

