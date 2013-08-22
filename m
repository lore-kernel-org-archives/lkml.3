Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab3HVIIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 04:08:12 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:39679 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab3HVIIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 04:08:05 -0400
Message-ID: <5215C6D6.3030309@linux.vnet.ibm.com>
Date: Thu, 22 Aug 2013 16:07:50 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: open list <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        x86@kernel.org, linux-acpi@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        John Stultz <john.stultz@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Feng Tang <feng.tang@intel.com>
Subject: Re: [PATCH 08/11] sched/cleanup: remove the extra parm of sched_clock_idle_wakeup_event()
References: <5215C233.9060907@linux.vnet.ibm.com> <5215C484.5010407@linux.vnet.ibm.com>
In-Reply-To: <5215C484.5010407@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082207-9574-0000-0000-0000094918B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2013 03:57 PM, Michael wang wrote:
> Parm 'delta_ns' has not been used, remove it to make code clean.
[snip]
>  
> -extern void sched_clock_idle_sleep_event(void);
> -extern void sched_clock_idle_wakeup_event(u64 delta_ns);

Also remove the extra declaration here.

Regards,
Michael Wang

> -
>  #ifdef CONFIG_HOTPLUG_CPU
>  extern void idle_task_exit(void);
>  #else
> diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
> index c3ae144..d111c58 100644
> --- a/kernel/sched/clock.c
> +++ b/kernel/sched/clock.c
> @@ -294,7 +294,7 @@ EXPORT_SYMBOL_GPL(sched_clock_idle_sleep_event);
>  /*
>   * We just idled delta nanoseconds (called with irqs disabled):
>   */
> -void sched_clock_idle_wakeup_event(u64 delta_ns)
> +void sched_clock_idle_wakeup_event(void)
>  {
>  	if (timekeeping_suspended)
>  		return;
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 3612fc7..4b24d9e 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -433,7 +433,7 @@ static void tick_nohz_stop_idle(int cpu, ktime_t now)
>  	update_ts_time_stats(cpu, ts, now, NULL);
>  	ts->idle_active = 0;
>  
> -	sched_clock_idle_wakeup_event(0);
> +	sched_clock_idle_wakeup_event();
>  }
>  
>  static ktime_t tick_nohz_start_idle(int cpu, struct tick_sched *ts)
> 

