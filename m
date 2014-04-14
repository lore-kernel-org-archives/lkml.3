Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbaDNXJC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 19:09:02 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:54689 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaDNXJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 19:09:00 -0400
Date: Tue, 15 Apr 2014 01:08:57 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: tglx@linutronix.de, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org
Subject: Re: [PATCH 24/38] tick-sched: don't check tick_nohz_full_cpu() in
 __tick_nohz_task_switch()
Message-ID: <20140414230855.GC1877@localhost.localdomain>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
 <ec2173fa3a7e754e45fb9409e44f77fa051610b7.1397492345.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec2173fa3a7e754e45fb9409e44f77fa051610b7.1397492345.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 09:53:46PM +0530, Viresh Kumar wrote:
> __tick_nohz_task_switch() calls tick_nohz_full_kick(), which is already checking
> tick_nohz_full_cpu() and so we don't need to repeat the same check here.
> 
> Remove it.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Ack.

> ---
>  kernel/time/tick-sched.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 256f4a3..5a99859 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -261,13 +261,9 @@ void __tick_nohz_task_switch(struct task_struct *tsk)
>  
>  	local_irq_save(flags);
>  
> -	if (!tick_nohz_full_cpu(smp_processor_id()))
> -		goto out;
> -
>  	if (tick_nohz_tick_stopped() && !can_stop_full_tick())
>  		tick_nohz_full_kick();
>  
> -out:
>  	local_irq_restore(flags);
>  }
>  
> -- 
> 1.7.12.rc2.18.g61b472e
> 
