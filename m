Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbaDVVXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:23:48 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:48737 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758528AbaDVVXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 17:23:43 -0400
Date: Tue, 22 Apr 2014 23:23:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: tglx@linutronix.de, linaro-kernel@lists.linaro.org,
        linaro-networking@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 01/19] tick: trivial cleanups
Message-ID: <20140422212330.GA18483@localhost.localdomain>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
 <f3f95d6a68a1d3aec3a30c2384848a06ad32459b.1398072824.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3f95d6a68a1d3aec3a30c2384848a06ad32459b.1398072824.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 03:24:57PM +0530, Viresh Kumar wrote:
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 6558b7a..9e9ddba 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -108,7 +108,6 @@ static ktime_t tick_init_jiffy_update(void)
>  	return period;
>  }
>  
> -
>  static void tick_sched_do_timer(ktime_t now)
>  {
>  	int cpu = smp_processor_id();
> @@ -248,8 +247,8 @@ void tick_nohz_full_kick_all(void)
>  		return;
>  
>  	preempt_disable();
> -	smp_call_function_many(tick_nohz_full_mask,
> -			       nohz_full_kick_ipi, NULL, false);
> +	smp_call_function_many(tick_nohz_full_mask, nohz_full_kick_ipi, NULL,
> +			       false);

Breaking < 80 char lines is arguable although I'm not sure it still matters in 2014.

But I don't see much the point of the above change. I usually prefer when line contents
are a bit balanced. It may be a matter of taste I guess.
