Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaFEKQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 06:16:37 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:51767 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaFEKQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 06:16:36 -0400
Date: Thu, 5 Jun 2014 12:16:32 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 0/6] sched: expel confusing usage of the term "power"
Message-ID: <20140605101632.GB24275@gmail.com>
References: <1401142779-6633-1-git-send-email-nicolas.pitre@linaro.org>
 <20140605100905.GA24275@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140605100905.GA24275@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Erm, I meant to hijack a thread of Daniel to report this bug ... so 
ignore this :)

Thanks,

	Ingo

* Ingo Molnar <mingo@kernel.org> wrote:

> 
> So I'm hijacking this thread a bit to report a bug in the following 
> patch:
> 
> Author: Daniel Lezcano <daniel.lezcano@linaro.org>
> Date:   Tue Jun 3 14:59:05 2014 +0200
> 
>     sched: Move enum CPU_[xxx_]IDLE to private sched.h
>     
>     The different enum CPU_IDLE, CPU_NOT_IDLE, CPU_NEWLY_IDLE and
>     CPU_MAX_IDLE_TYPES are only used in kernel/sched/fair.c and
>     kernel/sched/stats.c.
> 
> on x86-64 defconfig it fails to build with:
> 
> In file included from 
> /home/mingo/tip/arch/x86/kernel/asm-offsets.c:9:0:
> /home/mingo/tip/include/linux/sched.h:939:24: error: 
> ‘CPU_MAX_IDLE_TYPES’ undeclared here (not in a function)
>   unsigned int lb_count[CPU_MAX_IDLE_TYPES];
>                         ^
> make[2]: *** [arch/x86/kernel/asm-offsets.s] Error 1
> make[1]: *** [prepare0] Error 2
> make: *** [sub-make] Error 2
> 
> Find below the version that came to me.
> 
> Thanks,
> 
> 	Ingo
> 
> ===========================>
> From 21e0efe63f6766fc9b685ca8d5744101f9a21270 Mon Sep 17 00:00:00 2001
> From: Daniel Lezcano <daniel.lezcano@linaro.org>
> Date: Tue, 3 Jun 2014 14:59:05 +0200
> Subject: [PATCH] sched: Move enum CPU_[xxx_]IDLE to private sched.h
> 
> The different enum CPU_IDLE, CPU_NOT_IDLE, CPU_NEWLY_IDLE and
> CPU_MAX_IDLE_TYPES are only used in kernel/sched/fair.c and
> kernel/sched/stats.c.
> 
> Move their definitions in the private 'sched.h' file located in the
> same place than the files above.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Link: http://lkml.kernel.org/r/1401800345-29468-1-git-send-email-daniel.lezcano@linaro.org
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  include/linux/sched.h | 7 -------
>  kernel/sched/sched.h  | 7 +++++++
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index ce93768..b313c2e 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -846,13 +846,6 @@ static inline int sched_info_on(void)
>  #endif
>  }
>  
> -enum cpu_idle_type {
> -	CPU_IDLE,
> -	CPU_NOT_IDLE,
> -	CPU_NEWLY_IDLE,
> -	CPU_MAX_IDLE_TYPES
> -};
> -
>  /*
>   * Increase resolution of cpu_capacity calculations
>   */
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 956b8ca..9ab7d95 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -23,6 +23,13 @@ extern atomic_long_t calc_load_tasks;
>  extern long calc_load_fold_active(struct rq *this_rq);
>  extern void update_cpu_load_active(struct rq *this_rq);
>  
> +enum cpu_idle_type {
> +	CPU_IDLE,
> +	CPU_NOT_IDLE,
> +	CPU_NEWLY_IDLE,
> +	CPU_MAX_IDLE_TYPES
> +};
> +
>  /*
>   * Helpers for converting nanosecond timing to jiffy resolution
>   */
> 
