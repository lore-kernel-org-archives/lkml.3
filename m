Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806AbaGOXy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:54:26 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:47955 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760736AbaGOXyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:54:18 -0400
Message-ID: <53C5BF24.9030302@samsung.com>
Date: Wed, 16 Jul 2014 08:54:12 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
CC: linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Tomasz Figa <tomasz.figa@gmail.com>, Mark Brown <broonie@kernel.org>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 13/19] ARM: s5pv210: move debug-macro.S into the common
 space
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com> <1404496099-26708-14-git-send-email-t.figa@samsung.com>
In-Reply-To: <1404496099-26708-14-git-send-email-t.figa@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/14 02:48, Tomasz Figa wrote:
> Move debug-macro.S from mach/include to include/debug where
> all other common debug macros are.
>
> Signed-off-by: Tomasz Figa<t.figa@samsung.com>
> ---
>   arch/arm/Kconfig.debug                           | 12 +++++--
>   arch/arm/include/debug/s5pv210.S                 | 34 ++++++++++++++++++++
>   arch/arm/mach-s5pv210/include/mach/debug-macro.S | 41 ------------------------
>   3 files changed, 44 insertions(+), 43 deletions(-)
>   create mode 100644 arch/arm/include/debug/s5pv210.S
>   delete mode 100644 arch/arm/mach-s5pv210/include/mach/debug-macro.S
>
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index 8f90595..c2bcfcf 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -617,6 +617,7 @@ choice
>   		depends on PLAT_SAMSUNG
>   		select DEBUG_EXYNOS_UART if ARCH_EXYNOS
>   		select DEBUG_S3C24XX_UART if ARCH_S3C24XX
> +		select DEBUG_S5PV210_UART if ARCH_S5PV210
>   		bool "Use S3C UART 0 for low-level debug"
>   		help
>   		  Say Y here if you want the debug print routines to direct
> @@ -630,6 +631,7 @@ choice
>   		depends on PLAT_SAMSUNG
>   		select DEBUG_EXYNOS_UART if ARCH_EXYNOS
>   		select DEBUG_S3C24XX_UART if ARCH_S3C24XX
> +		select DEBUG_S5PV210_UART if ARCH_S5PV210
>   		bool "Use S3C UART 1 for low-level debug"
>   		help
>   		  Say Y here if you want the debug print routines to direct
> @@ -643,6 +645,7 @@ choice
>   		depends on PLAT_SAMSUNG
>   		select DEBUG_EXYNOS_UART if ARCH_EXYNOS
>   		select DEBUG_S3C24XX_UART if ARCH_S3C24XX
> +		select DEBUG_S5PV210_UART if ARCH_S5PV210
>   		bool "Use S3C UART 2 for low-level debug"
>   		help
>   		  Say Y here if you want the debug print routines to direct
> @@ -653,8 +656,9 @@ choice
>   		  by CONFIG_S3C_LOWLEVEL_UART_PORT.
>
>   	config DEBUG_S3C_UART3
> -		depends on PLAT_SAMSUNG&&  ARCH_EXYNOS
> -		select DEBUG_EXYNOS_UART
> +		depends on PLAT_SAMSUNG&&  (ARCH_EXYNOS || ARCH_S5PV210)
> +		select DEBUG_EXYNOS_UART if ARCH_EXYNOS
> +		select DEBUG_S5PV210_UART if ARCH_S5PV210
>   		bool "Use S3C UART 3 for low-level debug"
>   		help
>   		  Say Y here if you want the debug print routines to direct
> @@ -949,6 +953,9 @@ config DEBUG_S3C2410_UART
>   config DEBUG_S3C24XX_UART
>   	bool
>
> +config DEBUG_S5PV210_UART
> +	bool
> +
>   config DEBUG_OMAP2PLUS_UART
>   	bool
>   	depends on ARCH_OMAP2PLUS
> @@ -1009,6 +1016,7 @@ config DEBUG_LL_INCLUDE
>   	default "debug/msm.S" if DEBUG_MSM_UART || DEBUG_QCOM_UARTDM
>   	default "debug/omap2plus.S" if DEBUG_OMAP2PLUS_UART
>   	default "debug/s3c24xx.S" if DEBUG_S3C24XX_UART
> +	default "debug/s5pv210.S" if DEBUG_S5PV210_UART
>   	default "debug/sirf.S" if DEBUG_SIRFPRIMA2_UART1 || DEBUG_SIRFMARCO_UART1
>   	default "debug/sti.S" if DEBUG_STI_UART
>   	default "debug/tegra.S" if DEBUG_TEGRA_UART
> diff --git a/arch/arm/include/debug/s5pv210.S b/arch/arm/include/debug/s5pv210.S
> new file mode 100644
> index 0000000..4f1a73e
> --- /dev/null
> +++ b/arch/arm/include/debug/s5pv210.S
> @@ -0,0 +1,34 @@
> +/*
> + * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> +*/
> +
> +/* pull in the relevant register and map files. */
> +
> +#define S3C_ADDR_BASE   0xF6000000
> +#define S3C_VA_UART	S3C_ADDR_BASE + 0x01000000
> +#define S5PV210_PA_UART	0xe2900000
> +
> +	/* note, for the boot process to work we have to keep the UART
> +	 * virtual address aligned to an 1MiB boundary for the L1
> +	 * mapping the head code makes. We keep the UART virtual address
> +	 * aligned and add in the offset when we load the value here.
> +	 */
> +
> +	.macro addruart, rp, rv, tmp
> +		ldr	\rp, =S5PV210_PA_UART
> +		ldr	\rv, =S3C_VA_UART
> +#if CONFIG_DEBUG_S3C_UART != 0
> +		add	\rp, \rp, #(0x400 * CONFIG_DEBUG_S3C_UART)
> +		add	\rv, \rv, #(0x400 * CONFIG_DEBUG_S3C_UART)
> +#endif
> +	.endm
> +
> +#define fifo_full fifo_full_s5pv210
> +#define fifo_level fifo_level_s5pv210
> +
> +#include<debug/samsung.S>
> diff --git a/arch/arm/mach-s5pv210/include/mach/debug-macro.S b/arch/arm/mach-s5pv210/include/mach/debug-macro.S
> deleted file mode 100644
> index 30b511a..0000000

Tomasz,

I couldn't apply this one from this your series because of conflict with 
others. Can you please respin this one?

Thanks,
-Kukjin
