Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab3JLC60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 22:58:26 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:44396 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab3JLC6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 22:58:24 -0400
Message-ID: <5258BABF.4020404@linux.vnet.ibm.com>
Date: Sat, 12 Oct 2013 10:58:07 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Morten Rasmussen <morten.rasmussen@arm.com>, mingo@kernel.org,
        peterz@infradead.org
CC: pjt@google.com, arjan@linux.intel.com, rjw@sisk.pl,
        dirk.j.brandewie@intel.com, vincent.guittot@linaro.org,
        alex.shi@linaro.org, preeti@linux.vnet.ibm.com, efault@gmx.de,
        corbet@lwn.net, tglx@linutronix.de, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [RFC][PATCH 3/7] sched: power: go_faster/slower power driver
 hints
References: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com> <1381511957-29776-4-git-send-email-morten.rasmussen@arm.com>
In-Reply-To: <1381511957-29776-4-git-send-email-morten.rasmussen@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101202-9574-0000-0000-00000A0ACD4E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Morten

On 10/12/2013 01:19 AM, Morten Rasmussen wrote:
[snip]
>  
> @@ -5743,6 +5772,7 @@ static void run_rebalance_domains(struct softirq_action *h)
>  	 */
>  	nohz_idle_balance(this_cpu, idle);
>  
> +	inc_cpu_capacity(this_cpu);

Just wondering is this check necessary here? if rq get more tasks during
the balance, enqueue_task() should already do the check each time when
we move_task(), isn't it?

Regards,
Michael Wang

>  	power_late_callback(this_cpu);
>  }
>  
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 907a967..88e7968 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -1367,8 +1367,26 @@ static inline u64 irq_time_read(int cpu)
>  
>  #ifdef CONFIG_SCHED_POWER
>  extern void power_late_callback(int cpu);
> +extern int at_max_capacity(int cpu);
> +extern int go_faster(int cpu, int hint);
> +extern int go_slower(int cpu, int hint);
>  #else
>  static inline void power_late_callback(int cpu)
>  {
>  }
> +
> +static inline int at_max_capacity(int cpu)
> +{
> +	return 1;
> +}
> +
> +static inline int go_faster(int cpu, int hint)
> +{
> +	return 0;
> +}
> +
> +static inline int go_slower(int cpu, int hint)
> +{
> +	return 0;
> +}
>  #endif /* CONFIG_SCHED_POWER */
> 

