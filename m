Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaBTMXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 07:23:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59688 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbaBTMXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 07:23:30 -0500
Date: Thu, 20 Feb 2014 13:23:13 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Lei Wen <leiwen@marvell.com>
Cc: mingo@redhat.com, preeti.lkml@gmail.com, daniel.lezcano@linaro.org,
        viresh.kumar@linaro.org, xjian@marvell.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: keep quiescent cpu out of idle balance loop
Message-ID: <20140220122311.GO27965@twins.programming.kicks-ass.net>
References: <20140220085017.GL6835@laptop.programming.kicks-ass.net>
 <1392887824-20138-1-git-send-email-leiwen@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392887824-20138-1-git-send-email-leiwen@marvell.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 05:17:04PM +0800, Lei Wen wrote:
> +++ b/kernel/sched/fair.c
> @@ -6883,6 +6883,13 @@ void nohz_balance_enter_idle(int cpu)
>  	if (!cpu_active(cpu))
>  		return;
>  
> +	/*
> +	 * If this cpu is kept outside of root domain, we don't bother
> +	 * to ask it for nohz balance.
> +	 */
> +	if (!cpumask_test_cpu(cpu, this_rq()->rd.span))

 rd->span

Otherwise the compiler gets upset. Fixed it.

> +		return;
> +
>  	if (test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))
>  		return;
>  
> -- 
> 1.8.3.2
> 
