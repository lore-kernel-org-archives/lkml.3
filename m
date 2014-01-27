Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbaA0IYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 03:24:33 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:53806 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbaA0IYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 03:24:31 -0500
Message-ID: <52E617BF.4030500@linaro.org>
Date: Mon, 27 Jan 2014 09:24:31 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 3/9] idle: no more arch_cpu_idle_prepare() users
References: <1390802904-28399-1-git-send-email-nicolas.pitre@linaro.org> <1390802904-28399-4-git-send-email-nicolas.pitre@linaro.org>
In-Reply-To: <1390802904-28399-4-git-send-email-nicolas.pitre@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2014 07:08 AM, Nicolas Pitre wrote:
> ... so we can get rid of it entirely.
>
> Signed-off-by: Nicolas Pitre <nico@linaro.org>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
>   include/linux/cpu.h | 1 -
>   kernel/cpu/idle.c   | 2 --
>   2 files changed, 3 deletions(-)
>
> diff --git a/include/linux/cpu.h b/include/linux/cpu.h
> index 03e235ad1b..218fab7521 100644
> --- a/include/linux/cpu.h
> +++ b/include/linux/cpu.h
> @@ -221,7 +221,6 @@ void cpu_idle(void);
>   void cpu_idle_poll_ctrl(bool enable);
>
>   void arch_cpu_idle(void);
> -void arch_cpu_idle_prepare(void);
>   void arch_cpu_idle_enter(void);
>   void arch_cpu_idle_exit(void);
>   void arch_cpu_idle_dead(void);
> diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
> index 988573a9a3..4e327e211b 100644
> --- a/kernel/cpu/idle.c
> +++ b/kernel/cpu/idle.c
> @@ -52,7 +52,6 @@ static inline int cpu_idle_poll(void)
>   }
>
>   /* Weak implementations for optional arch specific functions */
> -void __weak arch_cpu_idle_prepare(void) { }
>   void __weak arch_cpu_idle_enter(void) { }
>   void __weak arch_cpu_idle_exit(void) { }
>   void __weak arch_cpu_idle_dead(void) { }
> @@ -136,6 +135,5 @@ void cpu_startup_entry(enum cpuhp_state state)
>   	boot_init_stack_canary();
>   #endif
>   	__current_set_polling();
> -	arch_cpu_idle_prepare();
>   	cpu_idle_loop();
>   }
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

