Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab3LQXz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 18:55:26 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:38106 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab3LQXzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 18:55:25 -0500
Date: Tue, 17 Dec 2013 15:55:18 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 04/13] tick: Use timekeeping_cpu() to elect the CPU
 handling timekeeping duty
Message-ID: <20131217235518.GL19211@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
 <1387320692-28460-5-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387320692-28460-5-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121723-6688-0000-0000-000004A575F4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 11:51:23PM +0100, Frederic Weisbecker wrote:
> Now that we have an API to determine if a CPU is allowed to handle
> timekeeping duty, use it now on timekeeper selection time for clarity.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Alex Shi <alex.shi@linaro.org>
> Cc: Kevin Hilman <khilman@linaro.org>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  kernel/time/tick-common.c | 2 +-
>  kernel/time/tick-sched.c  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
> index 64522ec..755dcd6 100644
> --- a/kernel/time/tick-common.c
> +++ b/kernel/time/tick-common.c
> @@ -163,7 +163,7 @@ static void tick_setup_device(struct tick_device *td,
>  		 * this cpu:
>  		 */
>  		if (tick_do_timer_cpu == TICK_DO_TIMER_BOOT) {
> -			if (!tick_nohz_full_cpu(cpu))
> +			if (tick_timekeeping_cpu(cpu))
>  				tick_do_timer_cpu = cpu;
>  			else
>  				tick_do_timer_cpu = TICK_DO_TIMER_NONE;
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index df6432d..ea0d411 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -118,7 +118,7 @@ static void tick_sched_do_timer(ktime_t now)
>  	 * jiffies_lock.
>  	 */
>  	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE)
> -	    && !tick_nohz_full_cpu(cpu))
> +	    && tick_timekeeping_cpu(cpu))
>  		tick_do_timer_cpu = cpu;
>  #endif
> 
> -- 
> 1.8.3.1
> 

