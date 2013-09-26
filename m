Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab3IZGVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 02:21:42 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:61055 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab3IZGVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 02:21:40 -0400
Message-ID: <5243D267.3010704@gmail.com>
Date: Thu, 26 Sep 2013 08:21:27 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/26] ARM: exynos: remove custom .init_time hook
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com> <1379526839-14798-13-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1379526839-14798-13-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 07:53 PM, Sebastian Hesselbarth wrote:
> With arch/arm calling of_clk_init(NULL) from time_init(), we can now
> remove custom .init_time hooks. While at it, also remove some now
> redundant includes.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---

Ping,

Kukjin can you please comment on this patch?

Thanks!

> Cc: Olof Johansson <olof@lixom.net>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>   arch/arm/mach-exynos/common.c          |    8 --------
>   arch/arm/mach-exynos/common.h          |    1 -
>   arch/arm/mach-exynos/mach-exynos4-dt.c |    2 --
>   arch/arm/mach-exynos/mach-exynos5-dt.c |    2 --
>   4 files changed, 13 deletions(-)
>
> diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
> index ba95e5d..a4e7ba8 100644
> --- a/arch/arm/mach-exynos/common.c
> +++ b/arch/arm/mach-exynos/common.c
> @@ -26,8 +26,6 @@
>   #include <linux/export.h>
>   #include <linux/irqdomain.h>
>   #include <linux/of_address.h>
> -#include <linux/clocksource.h>
> -#include <linux/clk-provider.h>
>   #include <linux/irqchip/arm-gic.h>
>   #include <linux/irqchip/chained_irq.h>
>
> @@ -367,12 +365,6 @@ static void __init exynos5_map_io(void)
>   		iotable_init(exynos5250_iodesc, ARRAY_SIZE(exynos5250_iodesc));
>   }
>
> -void __init exynos_init_time(void)
> -{
> -	of_clk_init(NULL);
> -	clocksource_of_init();
> -}
> -
>   struct bus_type exynos_subsys = {
>   	.name		= "exynos-core",
>   	.dev_name	= "exynos-core",
> diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
> index 8646a14..f0fa205 100644
> --- a/arch/arm/mach-exynos/common.h
> +++ b/arch/arm/mach-exynos/common.h
> @@ -16,7 +16,6 @@
>   #include <linux/of.h>
>
>   void mct_init(void __iomem *base, int irq_g0, int irq_l0, int irq_l1);
> -void exynos_init_time(void);
>
>   struct map_desc;
>   void exynos_init_io(void);
> diff --git a/arch/arm/mach-exynos/mach-exynos4-dt.c b/arch/arm/mach-exynos/mach-exynos4-dt.c
> index 0099c6c..6858d73 100644
> --- a/arch/arm/mach-exynos/mach-exynos4-dt.c
> +++ b/arch/arm/mach-exynos/mach-exynos4-dt.c
> @@ -16,7 +16,6 @@
>   #include <linux/of_fdt.h>
>   #include <linux/serial_core.h>
>   #include <linux/memblock.h>
> -#include <linux/clocksource.h>
>
>   #include <asm/mach/arch.h>
>   #include <plat/mfc.h>
> @@ -54,7 +53,6 @@ DT_MACHINE_START(EXYNOS4210_DT, "Samsung Exynos4 (Flattened Device Tree)")
>   	.init_early	= exynos_firmware_init,
>   	.init_machine	= exynos4_dt_machine_init,
>   	.init_late	= exynos_init_late,
> -	.init_time	= exynos_init_time,
>   	.dt_compat	= exynos4_dt_compat,
>   	.restart        = exynos4_restart,
>   	.reserve	= exynos4_reserve,
> diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
> index f874b77..bac2105 100644
> --- a/arch/arm/mach-exynos/mach-exynos5-dt.c
> +++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
> @@ -13,7 +13,6 @@
>   #include <linux/of_fdt.h>
>   #include <linux/memblock.h>
>   #include <linux/io.h>
> -#include <linux/clocksource.h>
>
>   #include <asm/mach/arch.h>
>   #include <mach/regs-pmu.h>
> @@ -76,7 +75,6 @@ DT_MACHINE_START(EXYNOS5_DT, "SAMSUNG EXYNOS5 (Flattened Device Tree)")
>   	.map_io		= exynos_init_io,
>   	.init_machine	= exynos5_dt_machine_init,
>   	.init_late	= exynos_init_late,
> -	.init_time	= exynos_init_time,
>   	.dt_compat	= exynos5_dt_compat,
>   	.restart        = exynos5_restart,
>   	.reserve	= exynos5_reserve,
>

