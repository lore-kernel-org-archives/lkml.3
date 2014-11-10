Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbaKJMoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:44:08 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:59896 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaKJMoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:44:06 -0500
Date: Mon, 10 Nov 2014 13:43:53 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: rjw@rjwysocki.net, preeti@linux.vnet.ibm.com, nicolas.pitre@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org, lenb@kernel.org
Subject: Re: [PATCH V3 3/6] sched: idle: Get the next timer event and pass it
 the cpuidle framework
Message-ID: <20141110124353.GO3337@twins.programming.kicks-ass.net>
References: <1415370687-18688-1-git-send-email-daniel.lezcano@linaro.org>
 <1415370687-18688-4-git-send-email-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415370687-18688-4-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 03:31:24PM +0100, Daniel Lezcano wrote:
>  static void cpu_idle_loop(void)
>  {
> -	unsigned int latency_req;
> +	unsigned int latency_req, next_timer_event;
>  
>  	while (1) {
>  		/*
> @@ -221,6 +222,9 @@ static void cpu_idle_loop(void)
>  
>  			latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
>  
> +			next_timer_event =
> +				ktime_to_us(tick_nohz_get_sleep_length());
> +
>  			/*
>  			 * In poll mode we reenable interrupts and spin.
>  			 *
> @@ -238,7 +242,8 @@ static void cpu_idle_loop(void)
>  			    tick_check_broadcast_expired())
>  				cpu_idle_poll();
>  			else
> -				cpuidle_idle_call(latency_req);
> +				cpuidle_idle_call(latency_req,
> +						  next_timer_event);
>  
>  			arch_cpu_idle_exit();
>  		}

Why do we want to query the next timer in the poll case? Afaict the
other patches don't make use of this either.


