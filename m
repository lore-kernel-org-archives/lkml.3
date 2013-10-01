Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab3JARhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 13:37:55 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60898 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab3JARhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 13:37:50 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-56-524b086cf317
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Heiko Stuebner <heiko@sntech.de>,
        Naour Romain <romain.naour@openwide.fr>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Tarek Dakhran <t.dakhran@samsung.com>
Subject: Re: [PATCH 5/6] ARM: EXYNOS: Minor fixes to enable EXYNOS5410 support
Date: Tue, 01 Oct 2013 19:37:43 +0200
Message-id: <2138155.cI0KCUKyhh@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1380644227-12244-6-git-send-email-v.tyrtov@samsung.com>
References: <1380644227-12244-1-git-send-email-v.tyrtov@samsung.com>
 <1380644227-12244-6-git-send-email-v.tyrtov@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t9jAd0cDu8gg6ZNIhaT1h1gspj3WdZi
	/pFzrBb/H71mtTj3aiWjRe+Cq2wWmx5fY7VY2LaExeLyrjlsFjPO72OyuH2Z12Lp9YtMFk8n
	XGSzmDB9LYvF4RVAM9a9nM5iseVnB6PFq4NtLBbrn59itNi8aSqzxdQZP9gdRD3WzFvD6NHS
	3MPmseDzFXaPv6teMHusXP6FzePV6pmsHneu7WHzeHfuHLvH5iX1Hq+usXj0bVnF6LH92jxm
	j8+b5Dw2zg0N4IvisklJzcksSy3St0vgynh++D1jwTX5iqm9i9gaGBdLdjFyckgImEis3baI
	HcIWk7hwbz1bFyMXh5DAIkaJ/QtPM0E4LUwSS05MAKtiE7CSmNi+ihHEFhHQkVj97gJYB7PA
	O1aJj5MvMoEkhAX8JG7NngvUwMHBIqAq8a9BGyTMK6Ap8fD6OhYQW1TAU+LTpKXMIDangKvE
	vzdzwFqFBOolFnxpYISoF5T4MfkeWD2zgLzEvv1TWSFsHYn9rdPYJjAKzEJSNgtJ2SwkZQsY
	mVcxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBMfwM6kdjCsbLA4xCnAwKvHwSjz0ChJiTSwr
	rsw9xCjBwawkwmt/FijEm5JYWZValB9fVJqTWnyIUZqDRUmc90CrdaCQQHpiSWp2ampBahFM
	lomDU6qBMflPV/oTuY/XMn9su9wl8mpzwgJL16V7Zn7KmJ28PPTI4Rn+d8W4bbK2ygtyKXzS
	i7/OuH632J4QFuauheZSO46te3T2QdarS1YtpvoiL5denCFkqym2Zr876wyped2WiaXvzp5J
	3afHFvBIbH9BSYZkwsrtdd1fHfatcVG9m8Z/4MeCtrtsfkosxRmJhlrMRcWJAClsafrdAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday, October 01, 2013 08:17:06 PM Vyacheslav Tyrtov wrote:
> From: Tarek Dakhran <t.dakhran@samsung.com>
> 
> Configure ARM_NR_BANKS as 16 for EXYNOS SoC.
> Enable cci_control_port_by_index for ACE_PORT.
> Add additional irqs for Exynos MCT.
> Set irq base as 256 for EXYNOS5410 SoC.

It would be better if these changes were separate patches as they touch
different code areas.

> Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
> ---
>  arch/arm/Kconfig                  |  2 +-
>  drivers/bus/arm-cci.c             |  7 +++++++
>  drivers/clocksource/exynos_mct.c  |  8 +++++++-
>  drivers/irqchip/exynos-combiner.c | 12 +++++++++++-
>  4 files changed, 26 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 3f7714d..7f88896 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1080,7 +1080,7 @@ source arch/arm/mm/Kconfig
>  
>  config ARM_NR_BANKS
>  	int
> -	default 16 if ARCH_EP93XX
> +	default 16 if ARCH_EP93XX || ARCH_EXYNOS
>  	default 8
>  
>  config IWMMXT
> diff --git a/drivers/bus/arm-cci.c b/drivers/bus/arm-cci.c
> index 2009266..f2f5df1 100644
> --- a/drivers/bus/arm-cci.c
> +++ b/drivers/bus/arm-cci.c
> @@ -363,8 +363,15 @@ int notrace __cci_control_port_by_index(u32 port, bool enable)
>  	 * interface (ie cci_disable_port_by_cpu(); control by general purpose
>  	 * indexing is therefore disabled for ACE ports.
>  	 */
> +
> +	/*
> +	 * Using this way to enable cci_port on EXYNOS5410 SoC
> +	 */
> +
> +#ifndef CONFIG_SOC_EXYNOS5410
>  	if (ports[port].type == ACE_PORT)
>  		return -EPERM;
> +#endif

This won't work for multiplatform kernels, please detect EXYNOS5410
at runtime using the device tree info.

>  	cci_port_control(port, enable);
>  	return 0;
> diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
> index 5b34768..33884d7 100644
> --- a/drivers/clocksource/exynos_mct.c
> +++ b/drivers/clocksource/exynos_mct.c
> @@ -71,6 +71,12 @@ enum {
>  	MCT_L1_IRQ,
>  	MCT_L2_IRQ,
>  	MCT_L3_IRQ,
> +#ifdef CONFIG_ARM_CCI
> +	MCT_L4_IRQ,
> +	MCT_L5_IRQ,
> +	MCT_L6_IRQ,
> +	MCT_L7_IRQ,
> +#endif
>  	MCT_NR_IRQS,
>  };
>  
> @@ -406,7 +412,7 @@ static int exynos4_local_timer_setup(struct clock_event_device *evt)
>  	mevt = container_of(evt, struct mct_clock_event_device, evt);
>  
>  	mevt->base = EXYNOS4_MCT_L_BASE(cpu);
> -	sprintf(mevt->name, "mct_tick%d", cpu);
> +	snprintf(mevt->name, 10, "mct_tick%d", cpu);

What is the rationale behind this change?

Also there is nothing about it in the patch description.

>  	evt->name = mevt->name;
>  	evt->cpumask = cpumask_of(cpu);
> diff --git a/drivers/irqchip/exynos-combiner.c b/drivers/irqchip/exynos-combiner.c
> index 868ed40..2e056fc 100644
> --- a/drivers/irqchip/exynos-combiner.c
> +++ b/drivers/irqchip/exynos-combiner.c
> @@ -18,6 +18,7 @@
>  #include <linux/of_address.h>
>  #include <linux/of_irq.h>
>  #include <asm/mach/irq.h>
> +#include <plat/cpu.h>
>  
>  #include "irqchip.h"
>  
> @@ -66,6 +67,11 @@ static void combiner_handle_cascade_irq(unsigned int irq, struct irq_desc *desc)
>  	struct irq_chip *chip = irq_get_chip(irq);
>  	unsigned int cascade_irq, combiner_irq;
>  	unsigned long status;

Please add a newline here.

> +	if (unlikely(!chip || !chip_data)) {
> +		printk_once(KERN_ALERT "%s: Chip not found for IRQ %d\n"
> +				, __func__, irq);
> +		return;
> +	}

There is nothing about this change in the patch description.

>  	chained_irq_enter(chip, desc);
>  
> @@ -226,7 +232,11 @@ static int __init combiner_of_init(struct device_node *np,
>  	 * get their IRQ from DT, remove this in order to get dynamic
>  	 * allocation.
>  	 */
> -	irq_base = 160;
> +
> +	if (soc_is_exynos5410())
> +		irq_base = 256;
> +	else
> +		irq_base = 160;
>  
>  	combiner_init(combiner_base, np, max_nr, irq_base);

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

