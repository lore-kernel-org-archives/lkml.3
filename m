Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbaIELKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 07:10:49 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49784 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756675AbaIELKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 07:10:47 -0400
Message-ID: <54099A26.60405@linux.vnet.ibm.com>
Date: Fri, 05 Sep 2014 16:40:30 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>, peterz@infradead.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
CC: riel@redhat.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com
Subject: Re: [PATCH v5 03/12] sched: fix avg_load computation
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org> <1409051215-16788-4-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1409051215-16788-4-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090511-0320-0000-0000-000000677343
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 04:36 PM, Vincent Guittot wrote:
> The computation of avg_load and avg_load_per_task should only takes into
> account the number of cfs tasks. The non cfs task are already taken into
> account by decreasing the cpu's capacity and they will be tracked in the
> CPU's utilization (group_utilization) of the next patches
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  kernel/sched/fair.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 87b9dc7..b85e9f7 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4092,7 +4092,7 @@ static unsigned long capacity_of(int cpu)
>  static unsigned long cpu_avg_load_per_task(int cpu)
>  {
>  	struct rq *rq = cpu_rq(cpu);
> -	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
> +	unsigned long nr_running = ACCESS_ONCE(rq->cfs.h_nr_running);
>  	unsigned long load_avg = rq->cfs.runnable_load_avg;
> 
>  	if (nr_running)
> @@ -5985,7 +5985,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
>  			load = source_load(i, load_idx);
> 
>  		sgs->group_load += load;
> -		sgs->sum_nr_running += rq->nr_running;
> +		sgs->sum_nr_running += rq->cfs.h_nr_running;

Yes this was one of the concerns I had around the usage of
rq->nr_running. Looks good to me.

> 
>  		if (rq->nr_running > 1)
>  			*overload = true;
> 
Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>

