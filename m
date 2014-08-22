Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693AbaHVRtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 13:49:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52369 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932469AbaHVRtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 13:49:22 -0400
Date: Fri, 22 Aug 2014 18:48:35 +0100
From: Will Deacon <will.deacon@arm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>,
        "akpm@linuxfoundation.org" <akpm@linuxfoundation.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH 19/35] [PATCH 19/36] arm: Replace __this_cpu_ptr with
 raw_cpu_ptr
Message-ID: <20140822174835.GD19961@arm.com>
References: <20140817173023.439660246@linux.com>
 <20140817173035.870898843@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140817173035.870898843@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2014 at 06:30:42PM +0100, Christoph Lameter wrote:
> __this_cpu_ptr is being phased out. So replace with raw_cpu_ptr.
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> CC: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Christoph Lameter <cl@linux.com>
> ---
>  arch/arm/kernel/smp_twd.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Looks good to me:

  Acked-by: Will Deacon <will.deacon@arm.com>

Will

> Index: linux/arch/arm/kernel/smp_twd.c
> ===================================================================
> --- linux.orig/arch/arm/kernel/smp_twd.c
> +++ linux/arch/arm/kernel/smp_twd.c
> @@ -92,7 +92,7 @@ static int twd_timer_ack(void)
>  
>  static void twd_timer_stop(void)
>  {
> -	struct clock_event_device *clk = __this_cpu_ptr(twd_evt);
> +	struct clock_event_device *clk = raw_cpu_ptr(twd_evt);
>  
>  	twd_set_mode(CLOCK_EVT_MODE_UNUSED, clk);
>  	disable_percpu_irq(clk->irq);
> @@ -108,7 +108,7 @@ static void twd_update_frequency(void *n
>  {
>  	twd_timer_rate = *((unsigned long *) new_rate);
>  
> -	clockevents_update_freq(__this_cpu_ptr(twd_evt), twd_timer_rate);
> +	clockevents_update_freq(raw_cpu_ptr(twd_evt), twd_timer_rate);
>  }
>  
>  static int twd_rate_change(struct notifier_block *nb,
> @@ -134,7 +134,7 @@ static struct notifier_block twd_clk_nb
>  
>  static int twd_clk_init(void)
>  {
> -	if (twd_evt && __this_cpu_ptr(twd_evt) && !IS_ERR(twd_clk))
> +	if (twd_evt && raw_cpu_ptr(twd_evt) && !IS_ERR(twd_clk))
>  		return clk_notifier_register(twd_clk, &twd_clk_nb);
>  
>  	return 0;
> @@ -153,7 +153,7 @@ static void twd_update_frequency(void *d
>  {
>  	twd_timer_rate = clk_get_rate(twd_clk);
>  
> -	clockevents_update_freq(__this_cpu_ptr(twd_evt), twd_timer_rate);
> +	clockevents_update_freq(raw_cpu_ptr(twd_evt), twd_timer_rate);
>  }
>  
>  static int twd_cpufreq_transition(struct notifier_block *nb,
> @@ -179,7 +179,7 @@ static struct notifier_block twd_cpufreq
>  
>  static int twd_cpufreq_init(void)
>  {
> -	if (twd_evt && __this_cpu_ptr(twd_evt) && !IS_ERR(twd_clk))
> +	if (twd_evt && raw_cpu_ptr(twd_evt) && !IS_ERR(twd_clk))
>  		return cpufreq_register_notifier(&twd_cpufreq_nb,
>  			CPUFREQ_TRANSITION_NOTIFIER);
>  
> @@ -269,7 +269,7 @@ static void twd_get_clock(struct device_
>   */
>  static void twd_timer_setup(void)
>  {
> -	struct clock_event_device *clk = __this_cpu_ptr(twd_evt);
> +	struct clock_event_device *clk = raw_cpu_ptr(twd_evt);
>  	int cpu = smp_processor_id();
>  
>  	/*
> 
> 
