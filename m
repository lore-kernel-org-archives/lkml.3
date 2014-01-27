Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaA0IdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 03:33:15 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:37970 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbaA0IdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 03:33:13 -0500
Message-ID: <52E619C9.4050406@linaro.org>
Date: Mon, 27 Jan 2014 09:33:13 +0100
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
Subject: Re: [PATCH 5/9] ARM: remove redundant cpuidle_idle_call()
References: <1390802904-28399-1-git-send-email-nicolas.pitre@linaro.org> <1390802904-28399-6-git-send-email-nicolas.pitre@linaro.org>
In-Reply-To: <1390802904-28399-6-git-send-email-nicolas.pitre@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2014 07:08 AM, Nicolas Pitre wrote:
> The core idle loop now takes care of it.
>
> Signed-off-by: Nicolas Pitre <nico@linaro.org>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>


> ---
>   arch/arm/kernel/process.c | 16 +++++-----------
>   1 file changed, 5 insertions(+), 11 deletions(-)
>
> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> index 725b8c95e0..34a59b7614 100644
> --- a/arch/arm/kernel/process.c
> +++ b/arch/arm/kernel/process.c
> @@ -30,7 +30,6 @@
>   #include <linux/uaccess.h>
>   #include <linux/random.h>
>   #include <linux/hw_breakpoint.h>
> -#include <linux/cpuidle.h>
>   #include <linux/leds.h>
>   #include <linux/reboot.h>
>
> @@ -133,7 +132,11 @@ EXPORT_SYMBOL_GPL(arm_pm_restart);
>
>   void (*arm_pm_idle)(void);
>
> -static void default_idle(void)
> +/*
> + * Called from the core idle loop.
> + */
> +
> +void arch_cpu_idle(void)
>   {
>   	if (arm_pm_idle)
>   		arm_pm_idle();
> @@ -163,15 +166,6 @@ void arch_cpu_idle_dead(void)
>   #endif
>
>   /*
> - * Called from the core idle loop.
> - */
> -void arch_cpu_idle(void)
> -{
> -	if (cpuidle_idle_call())
> -		default_idle();
> -}
> -
> -/*
>    * Called by kexec, immediately prior to machine_kexec().
>    *
>    * This must completely disable all secondary CPUs; simply causing those CPUs
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

