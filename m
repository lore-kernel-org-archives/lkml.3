Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825AbaE3N0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:26:51 -0400
Received: from service87.mimecast.com ([91.220.42.44]:50244 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaE3N0u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:26:50 -0400
Message-ID: <53888719.70604@arm.com>
Date: Fri, 30 May 2014 14:26:49 +0100
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v2 10/11] sched: move cfs task on a CPU with higher capacity
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org> <1400860385-14555-11-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1400860385-14555-11-git-send-email-vincent.guittot@linaro.org>
X-OriginalArrivalTime: 30 May 2014 13:26:45.0313 (UTC) FILETIME=[CD501B10:01CF7C0A]
X-MC-Unique: 114053014264801001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/05/14 16:53, Vincent Guittot wrote:
> If the CPU is used for handling lot of IRQs, trig a load balance to check if
> it's worth moving its tasks on another CPU that has more capacity
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  kernel/sched/fair.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index e8a30f9..2501e49 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5948,6 +5948,13 @@ static bool update_sd_pick_busiest(struct lb_env *env,
>  	if (sgs->sum_nr_running > sgs->group_capacity)
>  		return true;
>  
> +	/*
> +	 * The group capacity is reduced probably because of activity from other

Here 'group capacity' refers to sgs->group_power and not to
sgs->group_capacity, right?

> +	 * sched class or interrupts which use part of the available capacity
> +	 */

... 'interrupts' only w/ CONFIG_IRQ_TIME_ACCOUNTING=y, right ?

> +	if ((sg->sgp->power_orig * 100) > (sgs->group_power * env->sd->imbalance_pct))
> +		return true;
> +
[...]


