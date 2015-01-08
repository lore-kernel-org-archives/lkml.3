Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052AbbAHQ6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 11:58:10 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:64839 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204AbbAHQ6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 11:58:05 -0500
Message-ID: <54AEB719.5060103@linaro.org>
Date: Thu, 08 Jan 2015 17:58:01 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-tegra@vger.kernel.org, Allen Martin <amartin@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH] clocksource: tegra: wrap arch/arm-specific sections in
 CONFIG_ARM
References: <alpine.DEB.2.02.1412092201200.31750@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.02.1412092201200.31750@utopia.booyaka.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2014 11:07 PM, Paul Walmsley wrote:
>
> Like several of the other files in drivers/clocksource,
> tegra20_timer.c contains code that can only compile when CONFIG_ARM is
> enabled.  This causes obvious problems when trying to compile this
> code for NVIDIA ARM64-based SoCs, such as Tegra132.  The same timer IP
> blocks exist, so it seems appropriate to provide support for them.
>
> So until we figure out a better way to partition this code, wrap the
> delay_timer and persistent_clock support code with preprocessor tests
> for CONFIG_ARM.
 >
>  (The delay_timer code should not be needed at all on
> ARM64 due to the presence of the ARMv8 architected timer.  The
> persistent_clock support code could become important once power
> management modes are implemented that turn off the CPU complex.)

IIUC, the cpuidle driver is not yet ready, right ?

If it is the case, this driver is not needed yet, no ?

Perhaps you can rework a bit this driver in the meantime to have a 
better fix than disabling the code with macros ?

Otherwise, please try at least to group the code into a minimal set of 
macros.

One comment below.

> Signed-off-by: Paul Walmsley <paul@pwsan.com>
> Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
> Cc: Allen Martin <amartin@nvidia.com>
> Cc: Stephen Warren <swarren@nvidia.com>
> Cc: Thierry Reding <treding@nvidia.com>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> ---
> Applies against next-20141209.
> Intended for v3.20.
> Boot-tested on Tegra124 Jetson TK1 on next-20141209.
> Also boot-tested on Tegra132 Norrin FFD on next-20141209 + extra,
> unrelated patches.
>
>   drivers/clocksource/tegra20_timer.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
>
> diff --git a/drivers/clocksource/tegra20_timer.c b/drivers/clocksource/tegra20_timer.c
> index d2616ef16770..83a8f5c9e139 100644
> --- a/drivers/clocksource/tegra20_timer.c
> +++ b/drivers/clocksource/tegra20_timer.c
> @@ -29,8 +29,10 @@
>   #include <linux/sched_clock.h>
>   #include <linux/delay.h>
>
> +#ifdef CONFIG_ARM
>   #include <asm/mach/time.h>
>   #include <asm/smp_twd.h>

Is smp_twd.h really needed ?

> +#endif

[ ... ]

Thanks
   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

