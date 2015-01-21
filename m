Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbbAUQaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:30:05 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:50270 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbbAUQ34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:29:56 -0500
Message-ID: <54BFD3F6.2090907@atmel.com>
Date: Wed, 21 Jan 2015 17:29:42 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Bo Shen <voice.shen@atmel.com>, "Wenyou Yang" <Wenyou.Yang@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 15/17] ARM: at91: remove old setup
References: <1421359100-8930-1-git-send-email-alexandre.belloni@free-electrons.com> <1421359100-8930-16-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1421359100-8930-16-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 15/01/2015 22:58, Alexandre Belloni a écrit :
> The old initialization is not used anymore, remove it.
> Also remove now unused cpu.h and at91_dbgu.h
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  arch/arm/mach-at91/generic.h                   |   4 -
>  arch/arm/mach-at91/include/mach/at91_dbgu.h    |  63 ------
>  arch/arm/mach-at91/include/mach/at91_ramc.h    |   6 -
>  arch/arm/mach-at91/include/mach/at91sam9_smc.h |   2 -
>  arch/arm/mach-at91/include/mach/cpu.h          | 240 --------------------

BTW, both at91_dbgu.h and cpu.h are needed for the uncompress.h AT91
file. I need to re-integrate both of them until this feature is
completely generalized with multi-platform. Are you okay with this
modification?

>  arch/arm/mach-at91/pm.c                        |   5 +-
>  arch/arm/mach-at91/setup.c                     | 301 -------------------------

I'm perfectly fine with removing the old setup code as we have the full
DT initialization in place.
This setup code didn't prove it had added any benefit in comparison with
the usual DT initialization process. Code is much more simpler and clearer.

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

I plan to queue these patches really soon on top of my
at91-3.20-cleanup branch.

Thanks, bye.


>  7 files changed, 4 insertions(+), 617 deletions(-)
>  delete mode 100644 arch/arm/mach-at91/include/mach/at91_dbgu.h
>  delete mode 100644 arch/arm/mach-at91/include/mach/cpu.h
> 
> diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
> index 1e60faec2eba..881e73a27fab 100644
> --- a/arch/arm/mach-at91/generic.h
> +++ b/arch/arm/mach-at91/generic.h
> @@ -14,10 +14,6 @@
>  #include <linux/of.h>
>  #include <linux/reboot.h>
>  
> - /* Map io */
> -extern void __init at91_map_io(void);
> -extern void __init at91_alt_map_io(void);
> -
>   /* Processors */
>  extern void __init at91_dt_initialize(void);
>  
> diff --git a/arch/arm/mach-at91/include/mach/at91_dbgu.h b/arch/arm/mach-at91/include/mach/at91_dbgu.h
> deleted file mode 100644
> index 42925e8f78e4..000000000000
> --- a/arch/arm/mach-at91/include/mach/at91_dbgu.h
> +++ /dev/null
> @@ -1,63 +0,0 @@
> -/*
> - * arch/arm/mach-at91/include/mach/at91_dbgu.h
> - *
> - * Copyright (C) 2005 Ivan Kokshaysky
> - * Copyright (C) SAN People
> - *
> - * Debug Unit (DBGU) - System peripherals registers.
> - * Based on AT91RM9200 datasheet revision E.
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - */
> -
> -#ifndef AT91_DBGU_H
> -#define AT91_DBGU_H
> -
> -#define AT91_DBGU_CR		(0x00)	/* Control Register */
> -#define AT91_DBGU_MR		(0x04)	/* Mode Register */
> -#define AT91_DBGU_IER		(0x08)	/* Interrupt Enable Register */
> -#define		AT91_DBGU_TXRDY		(1 << 1)		/* Transmitter Ready */
> -#define		AT91_DBGU_TXEMPTY	(1 << 9)		/* Transmitter Empty */
> -#define AT91_DBGU_IDR		(0x0c)	/* Interrupt Disable Register */
> -#define AT91_DBGU_IMR		(0x10)	/* Interrupt Mask Register */
> -#define AT91_DBGU_SR		(0x14)	/* Status Register */
> -#define AT91_DBGU_RHR		(0x18)	/* Receiver Holding Register */
> -#define AT91_DBGU_THR		(0x1c)	/* Transmitter Holding Register */
> -#define AT91_DBGU_BRGR		(0x20)	/* Baud Rate Generator Register */
> -
> -#define AT91_DBGU_CIDR		(0x40)	/* Chip ID Register */
> -#define AT91_DBGU_EXID		(0x44)	/* Chip ID Extension Register */
> -#define AT91_DBGU_FNR		(0x48)	/* Force NTRST Register [SAM9 only] */
> -#define		AT91_DBGU_FNTRST	(1 << 0)		/* Force NTRST */
> -
> -/*
> - * Some AT91 parts that don't have full DEBUG units still support the ID
> - * and extensions register.
> - */
> -#define		AT91_CIDR_VERSION	(0x1f << 0)		/* Version of the Device */
> -#define		AT91_CIDR_EPROC		(7    << 5)		/* Embedded Processor */
> -#define		AT91_CIDR_NVPSIZ	(0xf  << 8)		/* Nonvolatile Program Memory Size */
> -#define		AT91_CIDR_NVPSIZ2	(0xf  << 12)		/* Second Nonvolatile Program Memory Size */
> -#define		AT91_CIDR_SRAMSIZ	(0xf  << 16)		/* Internal SRAM Size */
> -#define			AT91_CIDR_SRAMSIZ_1K	(1 << 16)
> -#define			AT91_CIDR_SRAMSIZ_2K	(2 << 16)
> -#define			AT91_CIDR_SRAMSIZ_112K	(4 << 16)
> -#define			AT91_CIDR_SRAMSIZ_4K	(5 << 16)
> -#define			AT91_CIDR_SRAMSIZ_80K	(6 << 16)
> -#define			AT91_CIDR_SRAMSIZ_160K	(7 << 16)
> -#define			AT91_CIDR_SRAMSIZ_8K	(8 << 16)
> -#define			AT91_CIDR_SRAMSIZ_16K	(9 << 16)
> -#define			AT91_CIDR_SRAMSIZ_32K	(10 << 16)
> -#define			AT91_CIDR_SRAMSIZ_64K	(11 << 16)
> -#define			AT91_CIDR_SRAMSIZ_128K	(12 << 16)
> -#define			AT91_CIDR_SRAMSIZ_256K	(13 << 16)
> -#define			AT91_CIDR_SRAMSIZ_96K	(14 << 16)
> -#define			AT91_CIDR_SRAMSIZ_512K	(15 << 16)
> -#define		AT91_CIDR_ARCH		(0xff << 20)		/* Architecture Identifier */
> -#define		AT91_CIDR_NVPTYP	(7    << 28)		/* Nonvolatile Program Memory Type */
> -#define		AT91_CIDR_EXT		(1    << 31)		/* Extension Flag */
> -
> -#endif
> diff --git a/arch/arm/mach-at91/include/mach/at91_ramc.h b/arch/arm/mach-at91/include/mach/at91_ramc.h
> index e4492b151fee..80431ece8a54 100644
> --- a/arch/arm/mach-at91/include/mach/at91_ramc.h
> +++ b/arch/arm/mach-at91/include/mach/at91_ramc.h
> @@ -9,17 +9,11 @@
>  #ifndef __AT91_RAMC_H__
>  #define __AT91_RAMC_H__
>  
> -#ifndef __ASSEMBLY__
> -extern void __iomem *at91_ramc_base[];
> -
>  #define at91_ramc_read(id, field) \
>  	__raw_readl(at91_ramc_base[id] + field)
>  
>  #define at91_ramc_write(id, field, value) \
>  	__raw_writel(value, at91_ramc_base[id] + field)
> -#else
> -.extern at91_ramc_base
> -#endif
>  
>  #define AT91_MEMCTRL_MC		0
>  #define AT91_MEMCTRL_SDRAMC	1
> diff --git a/arch/arm/mach-at91/include/mach/at91sam9_smc.h b/arch/arm/mach-at91/include/mach/at91sam9_smc.h
> index 175e1fdd9fe8..ff54a0ce90e3 100644
> --- a/arch/arm/mach-at91/include/mach/at91sam9_smc.h
> +++ b/arch/arm/mach-at91/include/mach/at91sam9_smc.h
> @@ -16,8 +16,6 @@
>  #ifndef AT91SAM9_SMC_H
>  #define AT91SAM9_SMC_H
>  
> -#include <mach/cpu.h>
> -
>  #ifndef __ASSEMBLY__
>  struct sam9_smc_config {
>  	/* Setup register */
> diff --git a/arch/arm/mach-at91/include/mach/cpu.h b/arch/arm/mach-at91/include/mach/cpu.h
> deleted file mode 100644
> index 61914fb35f5d..000000000000
> --- a/arch/arm/mach-at91/include/mach/cpu.h
> +++ /dev/null
> @@ -1,240 +0,0 @@
> -/*
> - * arch/arm/mach-at91/include/mach/cpu.h
> - *
> - * Copyright (C) 2006 SAN People
> - * Copyright (C) 2011 Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - */
> -
> -#ifndef __MACH_CPU_H__
> -#define __MACH_CPU_H__
> -
> -#define ARCH_ID_AT91RM9200	0x09290780
> -#define ARCH_ID_AT91SAM9260	0x019803a0
> -#define ARCH_ID_AT91SAM9261	0x019703a0
> -#define ARCH_ID_AT91SAM9263	0x019607a0
> -#define ARCH_ID_AT91SAM9G10	0x019903a0
> -#define ARCH_ID_AT91SAM9G20	0x019905a0
> -#define ARCH_ID_AT91SAM9RL64	0x019b03a0
> -#define ARCH_ID_AT91SAM9G45	0x819b05a0
> -#define ARCH_ID_AT91SAM9G45MRL	0x819b05a2	/* aka 9G45-ES2 & non ES lots */
> -#define ARCH_ID_AT91SAM9G45ES	0x819b05a1	/* 9G45-ES (Engineering Sample) */
> -#define ARCH_ID_AT91SAM9X5	0x819a05a0
> -#define ARCH_ID_AT91SAM9N12	0x819a07a0
> -
> -#define ARCH_ID_AT91SAM9XE128	0x329973a0
> -#define ARCH_ID_AT91SAM9XE256	0x329a93a0
> -#define ARCH_ID_AT91SAM9XE512	0x329aa3a0
> -
> -#define ARCH_ID_AT91M40800	0x14080044
> -#define ARCH_ID_AT91R40807	0x44080746
> -#define ARCH_ID_AT91M40807	0x14080745
> -#define ARCH_ID_AT91R40008	0x44000840
> -
> -#define ARCH_ID_SAMA5		0x8A5C07C0
> -
> -#define ARCH_EXID_AT91SAM9M11	0x00000001
> -#define ARCH_EXID_AT91SAM9M10	0x00000002
> -#define ARCH_EXID_AT91SAM9G46	0x00000003
> -#define ARCH_EXID_AT91SAM9G45	0x00000004
> -
> -#define ARCH_EXID_AT91SAM9G15	0x00000000
> -#define ARCH_EXID_AT91SAM9G35	0x00000001
> -#define ARCH_EXID_AT91SAM9X35	0x00000002
> -#define ARCH_EXID_AT91SAM9G25	0x00000003
> -#define ARCH_EXID_AT91SAM9X25	0x00000004
> -
> -#define ARCH_EXID_SAMA5D3	0x00004300
> -#define ARCH_EXID_SAMA5D31	0x00444300
> -#define ARCH_EXID_SAMA5D33	0x00414300
> -#define ARCH_EXID_SAMA5D34	0x00414301
> -#define ARCH_EXID_SAMA5D35	0x00584300
> -#define ARCH_EXID_SAMA5D36	0x00004301
> -
> -#define ARCH_EXID_SAMA5D4	0x00000007
> -#define ARCH_EXID_SAMA5D41	0x00000001
> -#define ARCH_EXID_SAMA5D42	0x00000002
> -#define ARCH_EXID_SAMA5D43	0x00000003
> -#define ARCH_EXID_SAMA5D44	0x00000004
> -
> -#define ARCH_FAMILY_AT91SAM9	0x01900000
> -#define ARCH_FAMILY_AT91SAM9XE	0x02900000
> -
> -/* RM9200 type */
> -#define ARCH_REVISON_9200_BGA	(0 << 0)
> -#define ARCH_REVISON_9200_PQFP	(1 << 0)
> -
> -#ifndef __ASSEMBLY__
> -enum at91_soc_type {
> -	/* 920T */
> -	AT91_SOC_RM9200,
> -
> -	/* SAM92xx */
> -	AT91_SOC_SAM9260, AT91_SOC_SAM9261, AT91_SOC_SAM9263,
> -
> -	/* SAM9Gxx */
> -	AT91_SOC_SAM9G10, AT91_SOC_SAM9G20, AT91_SOC_SAM9G45,
> -
> -	/* SAM9RL */
> -	AT91_SOC_SAM9RL,
> -
> -	/* SAM9X5 */
> -	AT91_SOC_SAM9X5,
> -
> -	/* SAM9N12 */
> -	AT91_SOC_SAM9N12,
> -
> -	/* SAMA5D3 */
> -	AT91_SOC_SAMA5D3,
> -
> -	/* SAMA5D4 */
> -	AT91_SOC_SAMA5D4,
> -
> -	/* Unknown type */
> -	AT91_SOC_UNKNOWN,
> -};
> -
> -enum at91_soc_subtype {
> -	/* RM9200 */
> -	AT91_SOC_RM9200_BGA, AT91_SOC_RM9200_PQFP,
> -
> -	/* SAM9260 */
> -	AT91_SOC_SAM9XE,
> -
> -	/* SAM9G45 */
> -	AT91_SOC_SAM9G45ES, AT91_SOC_SAM9M10, AT91_SOC_SAM9G46, AT91_SOC_SAM9M11,
> -
> -	/* SAM9X5 */
> -	AT91_SOC_SAM9G15, AT91_SOC_SAM9G35, AT91_SOC_SAM9X35,
> -	AT91_SOC_SAM9G25, AT91_SOC_SAM9X25,
> -
> -	/* SAMA5D3 */
> -	AT91_SOC_SAMA5D31, AT91_SOC_SAMA5D33, AT91_SOC_SAMA5D34,
> -	AT91_SOC_SAMA5D35, AT91_SOC_SAMA5D36,
> -
> -	/* SAMA5D4 */
> -	AT91_SOC_SAMA5D41, AT91_SOC_SAMA5D42, AT91_SOC_SAMA5D43,
> -	AT91_SOC_SAMA5D44,
> -
> -	/* No subtype for this SoC */
> -	AT91_SOC_SUBTYPE_NONE,
> -
> -	/* Unknown subtype */
> -	AT91_SOC_SUBTYPE_UNKNOWN,
> -};
> -
> -struct at91_socinfo {
> -	unsigned int type, subtype;
> -	unsigned int cidr, exid;
> -};
> -
> -extern struct at91_socinfo at91_soc_initdata;
> -const char *at91_get_soc_type(struct at91_socinfo *c);
> -const char *at91_get_soc_subtype(struct at91_socinfo *c);
> -
> -static inline int at91_soc_is_detected(void)
> -{
> -	return at91_soc_initdata.type != AT91_SOC_UNKNOWN;
> -}
> -
> -#ifdef CONFIG_SOC_AT91RM9200
> -#define cpu_is_at91rm9200()	(at91_soc_initdata.type == AT91_SOC_RM9200)
> -#define cpu_is_at91rm9200_bga()	(at91_soc_initdata.subtype == AT91_SOC_RM9200_BGA)
> -#define cpu_is_at91rm9200_pqfp() (at91_soc_initdata.subtype == AT91_SOC_RM9200_PQFP)
> -#else
> -#define cpu_is_at91rm9200()	(0)
> -#define cpu_is_at91rm9200_bga()	(0)
> -#define cpu_is_at91rm9200_pqfp() (0)
> -#endif
> -
> -#ifdef CONFIG_SOC_AT91SAM9260
> -#define cpu_is_at91sam9xe()	(at91_soc_initdata.subtype == AT91_SOC_SAM9XE)
> -#define cpu_is_at91sam9260()	(at91_soc_initdata.type == AT91_SOC_SAM9260)
> -#define cpu_is_at91sam9g20()	(at91_soc_initdata.type == AT91_SOC_SAM9G20)
> -#else
> -#define cpu_is_at91sam9xe()	(0)
> -#define cpu_is_at91sam9260()	(0)
> -#define cpu_is_at91sam9g20()	(0)
> -#endif
> -
> -#ifdef CONFIG_SOC_AT91SAM9261
> -#define cpu_is_at91sam9261()	(at91_soc_initdata.type == AT91_SOC_SAM9261)
> -#define cpu_is_at91sam9g10()	(at91_soc_initdata.type == AT91_SOC_SAM9G10)
> -#else
> -#define cpu_is_at91sam9261()	(0)
> -#define cpu_is_at91sam9g10()	(0)
> -#endif
> -
> -#ifdef CONFIG_SOC_AT91SAM9263
> -#define cpu_is_at91sam9263()	(at91_soc_initdata.type == AT91_SOC_SAM9263)
> -#else
> -#define cpu_is_at91sam9263()	(0)
> -#endif
> -
> -#ifdef CONFIG_SOC_AT91SAM9RL
> -#define cpu_is_at91sam9rl()	(at91_soc_initdata.type == AT91_SOC_SAM9RL)
> -#else
> -#define cpu_is_at91sam9rl()	(0)
> -#endif
> -
> -#ifdef CONFIG_SOC_AT91SAM9G45
> -#define cpu_is_at91sam9g45()	(at91_soc_initdata.type == AT91_SOC_SAM9G45)
> -#define cpu_is_at91sam9g45es()	(at91_soc_initdata.subtype == AT91_SOC_SAM9G45ES)
> -#define cpu_is_at91sam9m10()	(at91_soc_initdata.subtype == AT91_SOC_SAM9M10)
> -#define cpu_is_at91sam9g46()	(at91_soc_initdata.subtype == AT91_SOC_SAM9G46)
> -#define cpu_is_at91sam9m11()	(at91_soc_initdata.subtype == AT91_SOC_SAM9M11)
> -#else
> -#define cpu_is_at91sam9g45()	(0)
> -#define cpu_is_at91sam9g45es()	(0)
> -#define cpu_is_at91sam9m10()	(0)
> -#define cpu_is_at91sam9g46()	(0)
> -#define cpu_is_at91sam9m11()	(0)
> -#endif
> -
> -#ifdef CONFIG_SOC_AT91SAM9X5
> -#define cpu_is_at91sam9x5()	(at91_soc_initdata.type == AT91_SOC_SAM9X5)
> -#define cpu_is_at91sam9g15()	(at91_soc_initdata.subtype == AT91_SOC_SAM9G15)
> -#define cpu_is_at91sam9g35()	(at91_soc_initdata.subtype == AT91_SOC_SAM9G35)
> -#define cpu_is_at91sam9x35()	(at91_soc_initdata.subtype == AT91_SOC_SAM9X35)
> -#define cpu_is_at91sam9g25()	(at91_soc_initdata.subtype == AT91_SOC_SAM9G25)
> -#define cpu_is_at91sam9x25()	(at91_soc_initdata.subtype == AT91_SOC_SAM9X25)
> -#else
> -#define cpu_is_at91sam9x5()	(0)
> -#define cpu_is_at91sam9g15()	(0)
> -#define cpu_is_at91sam9g35()	(0)
> -#define cpu_is_at91sam9x35()	(0)
> -#define cpu_is_at91sam9g25()	(0)
> -#define cpu_is_at91sam9x25()	(0)
> -#endif
> -
> -#ifdef CONFIG_SOC_AT91SAM9N12
> -#define cpu_is_at91sam9n12()	(at91_soc_initdata.type == AT91_SOC_SAM9N12)
> -#else
> -#define cpu_is_at91sam9n12()	(0)
> -#endif
> -
> -#ifdef CONFIG_SOC_SAMA5D3
> -#define cpu_is_sama5d3()	(at91_soc_initdata.type == AT91_SOC_SAMA5D3)
> -#else
> -#define cpu_is_sama5d3()	(0)
> -#endif
> -
> -#ifdef CONFIG_SOC_SAMA5D4
> -#define cpu_is_sama5d4()	(at91_soc_initdata.type == AT91_SOC_SAMA5D4)
> -#else
> -#define cpu_is_sama5d4()	(0)
> -#endif
> -
> -/*
> - * Since this is ARM, we will never run on any AVR32 CPU. But these
> - * definitions may reduce clutter in common drivers.
> - */
> -#define cpu_is_at32ap7000()	(0)
> -#endif /* __ASSEMBLY__ */
> -
> -#endif /* __MACH_CPU_H__ */
> diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
> index 778f11132b31..11bf992838af 100644
> --- a/arch/arm/mach-at91/pm.c
> +++ b/arch/arm/mach-at91/pm.c
> @@ -19,6 +19,7 @@
>  #include <linux/sysfs.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
> +#include <linux/of_address.h>
>  #include <linux/of_platform.h>
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
> @@ -29,10 +30,12 @@
>  #include <asm/mach/time.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/cpu.h>
>  #include <mach/hardware.h>
>  
>  #include "generic.h"
> +
> +static void __iomem *at91_ramc_base[2];
> +
>  #include "pm.h"
>  
>  static struct {
> diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
> index 42ebe8d41433..4036e3e0ff96 100644
> --- a/arch/arm/mach-at91/setup.c
> +++ b/arch/arm/mach-at91/setup.c
> @@ -7,321 +7,20 @@
>  
>  #define pr_fmt(fmt)	"AT91: " fmt
>  
> -#include <linux/module.h>
>  #include <linux/io.h>
> -#include <linux/mm.h>
>  #include <linux/pm.h>
>  #include <linux/of_address.h>
> -#include <linux/pinctrl/machine.h>
> -#include <linux/clk/at91_pmc.h>
>  
>  #include <asm/system_misc.h>
> -#include <asm/mach/map.h>
>  
>  #include <mach/hardware.h>
> -#include <mach/cpu.h>
> -#include <mach/at91_dbgu.h>
>  
>  #include "generic.h"
>  #include "pm.h"
>  
> -struct at91_socinfo at91_soc_initdata;
> -EXPORT_SYMBOL(at91_soc_initdata);
> -
>  void __iomem *at91_ramc_base[2];
>  EXPORT_SYMBOL_GPL(at91_ramc_base);
>  
> -static struct map_desc at91_io_desc __initdata __maybe_unused = {
> -	.virtual	= (unsigned long)AT91_VA_BASE_SYS,
> -	.pfn		= __phys_to_pfn(AT91_BASE_SYS),
> -	.length		= SZ_16K,
> -	.type		= MT_DEVICE,
> -};
> -
> -static struct map_desc at91_alt_io_desc __initdata __maybe_unused = {
> -	.virtual	= (unsigned long)AT91_ALT_VA_BASE_SYS,
> -	.pfn		= __phys_to_pfn(AT91_ALT_BASE_SYS),
> -	.length		= 24 * SZ_1K,
> -	.type		= MT_DEVICE,
> -};
> -
> -static void __init soc_detect(u32 dbgu_base)
> -{
> -	u32 cidr, socid;
> -
> -	cidr = __raw_readl(AT91_IO_P2V(dbgu_base) + AT91_DBGU_CIDR);
> -	socid = cidr & ~AT91_CIDR_VERSION;
> -
> -	switch (socid) {
> -	case ARCH_ID_AT91RM9200:
> -		at91_soc_initdata.type = AT91_SOC_RM9200;
> -		if (at91_soc_initdata.subtype == AT91_SOC_SUBTYPE_UNKNOWN)
> -			at91_soc_initdata.subtype = AT91_SOC_RM9200_BGA;
> -		break;
> -
> -	case ARCH_ID_AT91SAM9260:
> -		at91_soc_initdata.type = AT91_SOC_SAM9260;
> -		at91_soc_initdata.subtype = AT91_SOC_SUBTYPE_NONE;
> -		break;
> -
> -	case ARCH_ID_AT91SAM9261:
> -		at91_soc_initdata.type = AT91_SOC_SAM9261;
> -		at91_soc_initdata.subtype = AT91_SOC_SUBTYPE_NONE;
> -		break;
> -
> -	case ARCH_ID_AT91SAM9263:
> -		at91_soc_initdata.type = AT91_SOC_SAM9263;
> -		at91_soc_initdata.subtype = AT91_SOC_SUBTYPE_NONE;
> -		break;
> -
> -	case ARCH_ID_AT91SAM9G20:
> -		at91_soc_initdata.type = AT91_SOC_SAM9G20;
> -		at91_soc_initdata.subtype = AT91_SOC_SUBTYPE_NONE;
> -		break;
> -
> -	case ARCH_ID_AT91SAM9G45:
> -		at91_soc_initdata.type = AT91_SOC_SAM9G45;
> -		if (cidr == ARCH_ID_AT91SAM9G45ES)
> -			at91_soc_initdata.subtype = AT91_SOC_SAM9G45ES;
> -		break;
> -
> -	case ARCH_ID_AT91SAM9RL64:
> -		at91_soc_initdata.type = AT91_SOC_SAM9RL;
> -		at91_soc_initdata.subtype = AT91_SOC_SUBTYPE_NONE;
> -		break;
> -
> -	case ARCH_ID_AT91SAM9X5:
> -		at91_soc_initdata.type = AT91_SOC_SAM9X5;
> -		break;
> -
> -	case ARCH_ID_AT91SAM9N12:
> -		at91_soc_initdata.type = AT91_SOC_SAM9N12;
> -		break;
> -
> -	case ARCH_ID_SAMA5:
> -		at91_soc_initdata.exid = __raw_readl(AT91_IO_P2V(dbgu_base) + AT91_DBGU_EXID);
> -		if (at91_soc_initdata.exid & ARCH_EXID_SAMA5D3) {
> -			at91_soc_initdata.type = AT91_SOC_SAMA5D3;
> -		}
> -		break;
> -	}
> -
> -	/* at91sam9g10 */
> -	if ((socid & ~AT91_CIDR_EXT) == ARCH_ID_AT91SAM9G10) {
> -		at91_soc_initdata.type = AT91_SOC_SAM9G10;
> -		at91_soc_initdata.subtype = AT91_SOC_SUBTYPE_NONE;
> -	}
> -	/* at91sam9xe */
> -	else if ((cidr & AT91_CIDR_ARCH) == ARCH_FAMILY_AT91SAM9XE) {
> -		at91_soc_initdata.type = AT91_SOC_SAM9260;
> -		at91_soc_initdata.subtype = AT91_SOC_SAM9XE;
> -	}
> -
> -	if (!at91_soc_is_detected())
> -		return;
> -
> -	at91_soc_initdata.cidr = cidr;
> -
> -	/* sub version of soc */
> -	if (!at91_soc_initdata.exid)
> -		at91_soc_initdata.exid = __raw_readl(AT91_IO_P2V(dbgu_base) + AT91_DBGU_EXID);
> -
> -	if (at91_soc_initdata.type == AT91_SOC_SAM9G45) {
> -		switch (at91_soc_initdata.exid) {
> -		case ARCH_EXID_AT91SAM9M10:
> -			at91_soc_initdata.subtype = AT91_SOC_SAM9M10;
> -			break;
> -		case ARCH_EXID_AT91SAM9G46:
> -			at91_soc_initdata.subtype = AT91_SOC_SAM9G46;
> -			break;
> -		case ARCH_EXID_AT91SAM9M11:
> -			at91_soc_initdata.subtype = AT91_SOC_SAM9M11;
> -			break;
> -		}
> -	}
> -
> -	if (at91_soc_initdata.type == AT91_SOC_SAM9X5) {
> -		switch (at91_soc_initdata.exid) {
> -		case ARCH_EXID_AT91SAM9G15:
> -			at91_soc_initdata.subtype = AT91_SOC_SAM9G15;
> -			break;
> -		case ARCH_EXID_AT91SAM9G35:
> -			at91_soc_initdata.subtype = AT91_SOC_SAM9G35;
> -			break;
> -		case ARCH_EXID_AT91SAM9X35:
> -			at91_soc_initdata.subtype = AT91_SOC_SAM9X35;
> -			break;
> -		case ARCH_EXID_AT91SAM9G25:
> -			at91_soc_initdata.subtype = AT91_SOC_SAM9G25;
> -			break;
> -		case ARCH_EXID_AT91SAM9X25:
> -			at91_soc_initdata.subtype = AT91_SOC_SAM9X25;
> -			break;
> -		}
> -	}
> -
> -	if (at91_soc_initdata.type == AT91_SOC_SAMA5D3) {
> -		switch (at91_soc_initdata.exid) {
> -		case ARCH_EXID_SAMA5D31:
> -			at91_soc_initdata.subtype = AT91_SOC_SAMA5D31;
> -			break;
> -		case ARCH_EXID_SAMA5D33:
> -			at91_soc_initdata.subtype = AT91_SOC_SAMA5D33;
> -			break;
> -		case ARCH_EXID_SAMA5D34:
> -			at91_soc_initdata.subtype = AT91_SOC_SAMA5D34;
> -			break;
> -		case ARCH_EXID_SAMA5D35:
> -			at91_soc_initdata.subtype = AT91_SOC_SAMA5D35;
> -			break;
> -		case ARCH_EXID_SAMA5D36:
> -			at91_soc_initdata.subtype = AT91_SOC_SAMA5D36;
> -			break;
> -		}
> -	}
> -}
> -
> -static void __init alt_soc_detect(u32 dbgu_base)
> -{
> -	u32 cidr, socid;
> -
> -	/* SoC ID */
> -	cidr = __raw_readl(AT91_ALT_IO_P2V(dbgu_base) + AT91_DBGU_CIDR);
> -	socid = cidr & ~AT91_CIDR_VERSION;
> -
> -	switch (socid) {
> -	case ARCH_ID_SAMA5:
> -		at91_soc_initdata.exid = __raw_readl(AT91_ALT_IO_P2V(dbgu_base) + AT91_DBGU_EXID);
> -		if (at91_soc_initdata.exid & ARCH_EXID_SAMA5D3) {
> -			at91_soc_initdata.type = AT91_SOC_SAMA5D3;
> -		} else if (at91_soc_initdata.exid & ARCH_EXID_SAMA5D4) {
> -			at91_soc_initdata.type = AT91_SOC_SAMA5D4;
> -		}
> -		break;
> -	}
> -
> -	if (!at91_soc_is_detected())
> -		return;
> -
> -	at91_soc_initdata.cidr = cidr;
> -
> -	/* sub version of soc */
> -	if (!at91_soc_initdata.exid)
> -		at91_soc_initdata.exid = __raw_readl(AT91_ALT_IO_P2V(dbgu_base) + AT91_DBGU_EXID);
> -
> -	if (at91_soc_initdata.type == AT91_SOC_SAMA5D4) {
> -		switch (at91_soc_initdata.exid) {
> -		case ARCH_EXID_SAMA5D41:
> -			at91_soc_initdata.subtype = AT91_SOC_SAMA5D41;
> -			break;
> -		case ARCH_EXID_SAMA5D42:
> -			at91_soc_initdata.subtype = AT91_SOC_SAMA5D42;
> -			break;
> -		case ARCH_EXID_SAMA5D43:
> -			at91_soc_initdata.subtype = AT91_SOC_SAMA5D43;
> -			break;
> -		case ARCH_EXID_SAMA5D44:
> -			at91_soc_initdata.subtype = AT91_SOC_SAMA5D44;
> -			break;
> -		}
> -	}
> -}
> -
> -static const char *soc_name[] = {
> -	[AT91_SOC_RM9200]	= "at91rm9200",
> -	[AT91_SOC_SAM9260]	= "at91sam9260",
> -	[AT91_SOC_SAM9261]	= "at91sam9261",
> -	[AT91_SOC_SAM9263]	= "at91sam9263",
> -	[AT91_SOC_SAM9G10]	= "at91sam9g10",
> -	[AT91_SOC_SAM9G20]	= "at91sam9g20",
> -	[AT91_SOC_SAM9G45]	= "at91sam9g45",
> -	[AT91_SOC_SAM9RL]	= "at91sam9rl",
> -	[AT91_SOC_SAM9X5]	= "at91sam9x5",
> -	[AT91_SOC_SAM9N12]	= "at91sam9n12",
> -	[AT91_SOC_SAMA5D3]	= "sama5d3",
> -	[AT91_SOC_SAMA5D4]	= "sama5d4",
> -	[AT91_SOC_UNKNOWN]	= "Unknown",
> -};
> -
> -const char *at91_get_soc_type(struct at91_socinfo *c)
> -{
> -	return soc_name[c->type];
> -}
> -EXPORT_SYMBOL(at91_get_soc_type);
> -
> -static const char *soc_subtype_name[] = {
> -	[AT91_SOC_RM9200_BGA]	= "at91rm9200 BGA",
> -	[AT91_SOC_RM9200_PQFP]	= "at91rm9200 PQFP",
> -	[AT91_SOC_SAM9XE]	= "at91sam9xe",
> -	[AT91_SOC_SAM9G45ES]	= "at91sam9g45es",
> -	[AT91_SOC_SAM9M10]	= "at91sam9m10",
> -	[AT91_SOC_SAM9G46]	= "at91sam9g46",
> -	[AT91_SOC_SAM9M11]	= "at91sam9m11",
> -	[AT91_SOC_SAM9G15]	= "at91sam9g15",
> -	[AT91_SOC_SAM9G35]	= "at91sam9g35",
> -	[AT91_SOC_SAM9X35]	= "at91sam9x35",
> -	[AT91_SOC_SAM9G25]	= "at91sam9g25",
> -	[AT91_SOC_SAM9X25]	= "at91sam9x25",
> -	[AT91_SOC_SAMA5D31]	= "sama5d31",
> -	[AT91_SOC_SAMA5D33]	= "sama5d33",
> -	[AT91_SOC_SAMA5D34]	= "sama5d34",
> -	[AT91_SOC_SAMA5D35]	= "sama5d35",
> -	[AT91_SOC_SAMA5D36]	= "sama5d36",
> -	[AT91_SOC_SAMA5D41]	= "sama5d41",
> -	[AT91_SOC_SAMA5D42]	= "sama5d42",
> -	[AT91_SOC_SAMA5D43]	= "sama5d43",
> -	[AT91_SOC_SAMA5D44]	= "sama5d44",
> -	[AT91_SOC_SUBTYPE_NONE]	= "None",
> -	[AT91_SOC_SUBTYPE_UNKNOWN] = "Unknown",
> -};
> -
> -const char *at91_get_soc_subtype(struct at91_socinfo *c)
> -{
> -	return soc_subtype_name[c->subtype];
> -}
> -EXPORT_SYMBOL(at91_get_soc_subtype);
> -
> -void __init at91_map_io(void)
> -{
> -	/* Map peripherals */
> -	iotable_init(&at91_io_desc, 1);
> -
> -	at91_soc_initdata.type = AT91_SOC_UNKNOWN;
> -	at91_soc_initdata.subtype = AT91_SOC_SUBTYPE_UNKNOWN;
> -
> -	soc_detect(AT91_BASE_DBGU0);
> -	if (!at91_soc_is_detected())
> -		soc_detect(AT91_BASE_DBGU1);
> -
> -	if (!at91_soc_is_detected())
> -		panic(pr_fmt("Impossible to detect the SOC type"));
> -
> -	pr_info("Detected soc type: %s\n",
> -		at91_get_soc_type(&at91_soc_initdata));
> -	if (at91_soc_initdata.subtype != AT91_SOC_SUBTYPE_NONE)
> -		pr_info("Detected soc subtype: %s\n",
> -			at91_get_soc_subtype(&at91_soc_initdata));
> -}
> -
> -void __init at91_alt_map_io(void)
> -{
> -	/* Map peripherals */
> -	iotable_init(&at91_alt_io_desc, 1);
> -
> -	at91_soc_initdata.type = AT91_SOC_UNKNOWN;
> -	at91_soc_initdata.subtype = AT91_SOC_SUBTYPE_UNKNOWN;
> -
> -	alt_soc_detect(AT91_BASE_DBGU2);
> -	if (!at91_soc_is_detected())
> -		panic("AT91: Impossible to detect the SOC type");
> -
> -	pr_info("AT91: Detected soc type: %s\n",
> -		at91_get_soc_type(&at91_soc_initdata));
> -	if (at91_soc_initdata.subtype != AT91_SOC_SUBTYPE_NONE)
> -		pr_info("AT91: Detected soc subtype: %s\n",
> -			at91_get_soc_subtype(&at91_soc_initdata));
> -}
> -
>  static struct of_device_id ramc_ids[] = {
>  	{ .compatible = "atmel,at91rm9200-sdramc", .data = at91rm9200_standby },
>  	{ .compatible = "atmel,at91sam9260-sdramc", .data = at91sam9_sdram_standby },
> 


-- 
Nicolas Ferre
