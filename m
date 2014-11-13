Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670AbaKMLMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:12:43 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:35136 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364AbaKMLMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:12:40 -0500
Message-ID: <54649221.9060307@atmel.com>
Date: Thu, 13 Nov 2014 12:12:33 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "Sebastian Reichel" <sre@kernel.org>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] ARM: at91: move sdramc/ddrsdr header to include/soc/at91
References: <1415393901-18469-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1415393901-18469-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 21:58, Alexandre Belloni :
> Move the (DDR) SDRAM controller headers to include/soc/at91 to remove the
> dependency on mach/ headers from the at91-reset driver.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
> As my previous attempts were not popular, solve the mach/ headers issue by
> simply moving them. I'll get back to better driver separation when it will be
> possible to map the SRAM as executable memory.
> 
>  MAINTAINERS                                        |   1 +
>  arch/arm/mach-at91/include/mach/at91_ramc.h        |   6 +-
>  .../arm/mach-at91/include/mach/at91rm9200_sdramc.h |  63 -----------
>  arch/arm/mach-at91/include/mach/at91sam9_ddrsdr.h  | 124 ---------------------
>  arch/arm/mach-at91/include/mach/at91sam9_sdramc.h  |  85 --------------
>  arch/arm/mach-at91/pm.h                            |   1 -
>  drivers/power/reset/at91-reset.c                   |   4 +-
>  include/soc/at91/at91rm9200_sdramc.h               |  63 +++++++++++
>  include/soc/at91/at91sam9_ddrsdr.h                 | 124 +++++++++++++++++++++
>  include/soc/at91/at91sam9_sdramc.h                 |  85 ++++++++++++++
>  10 files changed, 278 insertions(+), 278 deletions(-)
>  delete mode 100644 arch/arm/mach-at91/include/mach/at91rm9200_sdramc.h
>  delete mode 100644 arch/arm/mach-at91/include/mach/at91sam9_ddrsdr.h
>  delete mode 100644 arch/arm/mach-at91/include/mach/at91sam9_sdramc.h
>  create mode 100644 include/soc/at91/at91rm9200_sdramc.h
>  create mode 100644 include/soc/at91/at91sam9_ddrsdr.h
>  create mode 100644 include/soc/at91/at91sam9_sdramc.h

This would have been cleaner and easier to understand with
git format-patch -M

--8<--------------------------------
 MAINTAINERS                                                         | 1 +
 arch/arm/mach-at91/include/mach/at91_ramc.h                         | 6 +++---
 arch/arm/mach-at91/pm.h                                             | 1 -
 drivers/power/reset/at91-reset.c                                    | 4 ++--
 .../mach-at91/include/mach => include/soc/at91}/at91rm9200_sdramc.h | 0
 .../mach-at91/include/mach => include/soc/at91}/at91sam9_ddrsdr.h   | 0
 .../mach-at91/include/mach => include/soc/at91}/at91sam9_sdramc.h   | 0
 7 files changed, 6 insertions(+), 6 deletions(-)
 rename {arch/arm/mach-at91/include/mach => include/soc/at91}/at91rm9200_sdramc.h (100%)
 rename {arch/arm/mach-at91/include/mach => include/soc/at91}/at91sam9_ddrsdr.h (100%)
 rename {arch/arm/mach-at91/include/mach => include/soc/at91}/at91sam9_sdramc.h (100%)
--8<--------------------------------

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

and queued for at91-3.19-cleanup

Bye,

 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3c6427190be2..e8f5474ce9b4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -861,6 +861,7 @@ W:	http://maxim.org.za/at91_26.html
>  W:	http://www.linux4sam.org
>  S:	Supported
>  F:	arch/arm/mach-at91/
> +F:	include/soc/at91/
>  F:	arch/arm/boot/dts/at91*.dts
>  F:	arch/arm/boot/dts/at91*.dtsi
>  F:	arch/arm/boot/dts/sama*.dts
> diff --git a/arch/arm/mach-at91/include/mach/at91_ramc.h b/arch/arm/mach-at91/include/mach/at91_ramc.h
> index d8aeb278614e..e4492b151fee 100644
> --- a/arch/arm/mach-at91/include/mach/at91_ramc.h
> +++ b/arch/arm/mach-at91/include/mach/at91_ramc.h
> @@ -25,8 +25,8 @@ extern void __iomem *at91_ramc_base[];
>  #define AT91_MEMCTRL_SDRAMC	1
>  #define AT91_MEMCTRL_DDRSDR	2
>  
> -#include <mach/at91rm9200_sdramc.h>
> -#include <mach/at91sam9_ddrsdr.h>
> -#include <mach/at91sam9_sdramc.h>
> +#include <soc/at91/at91rm9200_sdramc.h>
> +#include <soc/at91/at91sam9_ddrsdr.h>
> +#include <soc/at91/at91sam9_sdramc.h>
>  
>  #endif /* __AT91_RAMC_H__ */
> diff --git a/arch/arm/mach-at91/include/mach/at91rm9200_sdramc.h b/arch/arm/mach-at91/include/mach/at91rm9200_sdramc.h
> deleted file mode 100644
> index aa047f458f1b..000000000000
> --- a/arch/arm/mach-at91/include/mach/at91rm9200_sdramc.h
> +++ /dev/null
> @@ -1,63 +0,0 @@
> -/*
> - * arch/arm/mach-at91/include/mach/at91rm9200_sdramc.h
> - *
> - * Copyright (C) 2005 Ivan Kokshaysky
> - * Copyright (C) SAN People
> - *
> - * Memory Controllers (SDRAMC only) - System peripherals registers.
> - * Based on AT91RM9200 datasheet revision E.
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - */
> -
> -#ifndef AT91RM9200_SDRAMC_H
> -#define AT91RM9200_SDRAMC_H
> -
> -/* SDRAM Controller registers */
> -#define AT91RM9200_SDRAMC_MR		0x90			/* Mode Register */
> -#define		AT91RM9200_SDRAMC_MODE	(0xf << 0)		/* Command Mode */
> -#define			AT91RM9200_SDRAMC_MODE_NORMAL		(0 << 0)
> -#define			AT91RM9200_SDRAMC_MODE_NOP		(1 << 0)
> -#define			AT91RM9200_SDRAMC_MODE_PRECHARGE	(2 << 0)
> -#define			AT91RM9200_SDRAMC_MODE_LMR		(3 << 0)
> -#define			AT91RM9200_SDRAMC_MODE_REFRESH	(4 << 0)
> -#define		AT91RM9200_SDRAMC_DBW		(1   << 4)		/* Data Bus Width */
> -#define			AT91RM9200_SDRAMC_DBW_32	(0 << 4)
> -#define			AT91RM9200_SDRAMC_DBW_16	(1 << 4)
> -
> -#define AT91RM9200_SDRAMC_TR		0x94			/* Refresh Timer Register */
> -#define		AT91RM9200_SDRAMC_COUNT	(0xfff << 0)		/* Refresh Timer Count */
> -
> -#define AT91RM9200_SDRAMC_CR		0x98			/* Configuration Register */
> -#define		AT91RM9200_SDRAMC_NC		(3   <<  0)		/* Number of Column Bits */
> -#define			AT91RM9200_SDRAMC_NC_8	(0 << 0)
> -#define			AT91RM9200_SDRAMC_NC_9	(1 << 0)
> -#define			AT91RM9200_SDRAMC_NC_10	(2 << 0)
> -#define			AT91RM9200_SDRAMC_NC_11	(3 << 0)
> -#define		AT91RM9200_SDRAMC_NR		(3   <<  2)		/* Number of Row Bits */
> -#define			AT91RM9200_SDRAMC_NR_11	(0 << 2)
> -#define			AT91RM9200_SDRAMC_NR_12	(1 << 2)
> -#define			AT91RM9200_SDRAMC_NR_13	(2 << 2)
> -#define		AT91RM9200_SDRAMC_NB		(1   <<  4)		/* Number of Banks */
> -#define			AT91RM9200_SDRAMC_NB_2	(0 << 4)
> -#define			AT91RM9200_SDRAMC_NB_4	(1 << 4)
> -#define		AT91RM9200_SDRAMC_CAS		(3   <<  5)		/* CAS Latency */
> -#define			AT91RM9200_SDRAMC_CAS_2	(2 << 5)
> -#define		AT91RM9200_SDRAMC_TWR		(0xf <<  7)		/* Write Recovery Delay */
> -#define		AT91RM9200_SDRAMC_TRC		(0xf << 11)		/* Row Cycle Delay */
> -#define		AT91RM9200_SDRAMC_TRP		(0xf << 15)		/* Row Precharge Delay */
> -#define		AT91RM9200_SDRAMC_TRCD	(0xf << 19)		/* Row to Column Delay */
> -#define		AT91RM9200_SDRAMC_TRAS	(0xf << 23)		/* Active to Precharge Delay */
> -#define		AT91RM9200_SDRAMC_TXSR	(0xf << 27)		/* Exit Self Refresh to Active Delay */
> -
> -#define AT91RM9200_SDRAMC_SRR		0x9c			/* Self Refresh Register */
> -#define AT91RM9200_SDRAMC_LPR		0xa0			/* Low Power Register */
> -#define AT91RM9200_SDRAMC_IER		0xa4			/* Interrupt Enable Register */
> -#define AT91RM9200_SDRAMC_IDR		0xa8			/* Interrupt Disable Register */
> -#define AT91RM9200_SDRAMC_IMR		0xac			/* Interrupt Mask Register */
> -#define AT91RM9200_SDRAMC_ISR		0xb0			/* Interrupt Status Register */
> -
> -#endif
> diff --git a/arch/arm/mach-at91/include/mach/at91sam9_ddrsdr.h b/arch/arm/mach-at91/include/mach/at91sam9_ddrsdr.h
> deleted file mode 100644
> index 0210797abf2e..000000000000
> --- a/arch/arm/mach-at91/include/mach/at91sam9_ddrsdr.h
> +++ /dev/null
> @@ -1,124 +0,0 @@
> -/*
> - * Header file for the Atmel DDR/SDR SDRAM Controller
> - *
> - * Copyright (C) 2010 Atmel Corporation
> - *	Nicolas Ferre <nicolas.ferre@atmel.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - */
> -#ifndef AT91SAM9_DDRSDR_H
> -#define AT91SAM9_DDRSDR_H
> -
> -#define AT91_DDRSDRC_MR		0x00	/* Mode Register */
> -#define		AT91_DDRSDRC_MODE	(0x7 << 0)		/* Command Mode */
> -#define			AT91_DDRSDRC_MODE_NORMAL	0
> -#define			AT91_DDRSDRC_MODE_NOP		1
> -#define			AT91_DDRSDRC_MODE_PRECHARGE	2
> -#define			AT91_DDRSDRC_MODE_LMR		3
> -#define			AT91_DDRSDRC_MODE_REFRESH	4
> -#define			AT91_DDRSDRC_MODE_EXT_LMR	5
> -#define			AT91_DDRSDRC_MODE_DEEP		6
> -
> -#define AT91_DDRSDRC_RTR	0x04	/* Refresh Timer Register */
> -#define		AT91_DDRSDRC_COUNT	(0xfff << 0)		/* Refresh Timer Counter */
> -
> -#define AT91_DDRSDRC_CR		0x08	/* Configuration Register */
> -#define		AT91_DDRSDRC_NC		(3 << 0)		/* Number of Column Bits */
> -#define			AT91_DDRSDRC_NC_SDR8	(0 << 0)
> -#define			AT91_DDRSDRC_NC_SDR9	(1 << 0)
> -#define			AT91_DDRSDRC_NC_SDR10	(2 << 0)
> -#define			AT91_DDRSDRC_NC_SDR11	(3 << 0)
> -#define			AT91_DDRSDRC_NC_DDR9	(0 << 0)
> -#define			AT91_DDRSDRC_NC_DDR10	(1 << 0)
> -#define			AT91_DDRSDRC_NC_DDR11	(2 << 0)
> -#define			AT91_DDRSDRC_NC_DDR12	(3 << 0)
> -#define		AT91_DDRSDRC_NR		(3 << 2)		/* Number of Row Bits */
> -#define			AT91_DDRSDRC_NR_11	(0 << 2)
> -#define			AT91_DDRSDRC_NR_12	(1 << 2)
> -#define			AT91_DDRSDRC_NR_13	(2 << 2)
> -#define			AT91_DDRSDRC_NR_14	(3 << 2)
> -#define		AT91_DDRSDRC_CAS	(7 << 4)		/* CAS Latency */
> -#define			AT91_DDRSDRC_CAS_2	(2 << 4)
> -#define			AT91_DDRSDRC_CAS_3	(3 << 4)
> -#define			AT91_DDRSDRC_CAS_25	(6 << 4)
> -#define		AT91_DDRSDRC_RST_DLL	(1 << 7)		/* Reset DLL */
> -#define		AT91_DDRSDRC_DICDS	(1 << 8)		/* Output impedance control */
> -#define		AT91_DDRSDRC_DIS_DLL	(1 << 9)		/* Disable DLL [SAM9 Only] */
> -#define		AT91_DDRSDRC_OCD	(1 << 12)		/* Off-Chip Driver [SAM9 Only] */
> -#define		AT91_DDRSDRC_DQMS	(1 << 16)		/* Mask Data is Shared [SAM9 Only] */
> -#define		AT91_DDRSDRC_ACTBST	(1 << 18)		/* Active Bank X to Burst Stop Read Access Bank Y [SAM9 Only] */
> -
> -#define AT91_DDRSDRC_T0PR	0x0C	/* Timing 0 Register */
> -#define		AT91_DDRSDRC_TRAS	(0xf <<  0)		/* Active to Precharge delay */
> -#define		AT91_DDRSDRC_TRCD	(0xf <<  4)		/* Row to Column delay */
> -#define		AT91_DDRSDRC_TWR	(0xf <<  8)		/* Write recovery delay */
> -#define		AT91_DDRSDRC_TRC	(0xf << 12)		/* Row cycle delay */
> -#define		AT91_DDRSDRC_TRP	(0xf << 16)		/* Row precharge delay */
> -#define		AT91_DDRSDRC_TRRD	(0xf << 20)		/* Active BankA to BankB */
> -#define		AT91_DDRSDRC_TWTR	(0x7 << 24)		/* Internal Write to Read delay */
> -#define		AT91_DDRSDRC_RED_WRRD	(0x1 << 27)		/* Reduce Write to Read Delay [SAM9 Only] */
> -#define		AT91_DDRSDRC_TMRD	(0xf << 28)		/* Load mode to active/refresh delay */
> -
> -#define AT91_DDRSDRC_T1PR	0x10	/* Timing 1 Register */
> -#define		AT91_DDRSDRC_TRFC	(0x1f << 0)		/* Row Cycle Delay */
> -#define		AT91_DDRSDRC_TXSNR	(0xff << 8)		/* Exit self-refresh to non-read */
> -#define		AT91_DDRSDRC_TXSRD	(0xff << 16)		/* Exit self-refresh to read */
> -#define		AT91_DDRSDRC_TXP	(0xf  << 24)		/* Exit power-down delay */
> -
> -#define AT91_DDRSDRC_T2PR	0x14	/* Timing 2 Register [SAM9 Only] */
> -#define		AT91_DDRSDRC_TXARD	(0xf  << 0)		/* Exit active power down delay to read command in mode "Fast Exit" */
> -#define		AT91_DDRSDRC_TXARDS	(0xf  << 4)		/* Exit active power down delay to read command in mode "Slow Exit" */
> -#define		AT91_DDRSDRC_TRPA	(0xf  << 8)		/* Row Precharge All delay */
> -#define		AT91_DDRSDRC_TRTP	(0x7  << 12)		/* Read to Precharge delay */
> -
> -#define AT91_DDRSDRC_LPR	0x1C	/* Low Power Register */
> -#define		AT91_DDRSDRC_LPCB	(3 << 0)		/* Low-power Configurations */
> -#define			AT91_DDRSDRC_LPCB_DISABLE		0
> -#define			AT91_DDRSDRC_LPCB_SELF_REFRESH		1
> -#define			AT91_DDRSDRC_LPCB_POWER_DOWN		2
> -#define			AT91_DDRSDRC_LPCB_DEEP_POWER_DOWN	3
> -#define		AT91_DDRSDRC_CLKFR	(1 << 2)	/* Clock Frozen */
> -#define		AT91_DDRSDRC_PASR	(7 << 4)	/* Partial Array Self Refresh */
> -#define		AT91_DDRSDRC_TCSR	(3 << 8)	/* Temperature Compensated Self Refresh */
> -#define		AT91_DDRSDRC_DS		(3 << 10)	/* Drive Strength */
> -#define		AT91_DDRSDRC_TIMEOUT	(3 << 12)	/* Time to define when Low Power Mode is enabled */
> -#define			AT91_DDRSDRC_TIMEOUT_0_CLK_CYCLES	(0 << 12)
> -#define			AT91_DDRSDRC_TIMEOUT_64_CLK_CYCLES	(1 << 12)
> -#define			AT91_DDRSDRC_TIMEOUT_128_CLK_CYCLES	(2 << 12)
> -#define		AT91_DDRSDRC_APDE	(1 << 16)	 /* Active power down exit time */
> -#define		AT91_DDRSDRC_UPD_MR	(3 << 20)	 /* Update load mode register and extended mode register */
> -
> -#define AT91_DDRSDRC_MDR	0x20	/* Memory Device Register */
> -#define		AT91_DDRSDRC_MD		(3 << 0)		/* Memory Device Type */
> -#define			AT91_DDRSDRC_MD_SDR		0
> -#define			AT91_DDRSDRC_MD_LOW_POWER_SDR	1
> -#define			AT91_DDRSDRC_MD_LOW_POWER_DDR	3
> -#define			AT91_DDRSDRC_MD_DDR2		6	/* [SAM9 Only] */
> -#define		AT91_DDRSDRC_DBW	(1 << 4)		/* Data Bus Width */
> -#define			AT91_DDRSDRC_DBW_32BITS		(0 <<  4)
> -#define			AT91_DDRSDRC_DBW_16BITS		(1 <<  4)
> -
> -#define AT91_DDRSDRC_DLL	0x24	/* DLL Information Register */
> -#define		AT91_DDRSDRC_MDINC	(1 << 0)		/* Master Delay increment */
> -#define		AT91_DDRSDRC_MDDEC	(1 << 1)		/* Master Delay decrement */
> -#define		AT91_DDRSDRC_MDOVF	(1 << 2)		/* Master Delay Overflow */
> -#define		AT91_DDRSDRC_MDVAL	(0xff <<  8)		/* Master Delay value */
> -
> -#define AT91_DDRSDRC_HS		0x2C	/* High Speed Register [SAM9 Only] */
> -#define		AT91_DDRSDRC_DIS_ATCP_RD	(1 << 2)	/* Anticip read access is disabled */
> -
> -#define AT91_DDRSDRC_DELAY(n)	(0x30 + (0x4 * (n)))	/* Delay I/O Register n */
> -
> -#define AT91_DDRSDRC_WPMR	0xE4	/* Write Protect Mode Register [SAM9 Only] */
> -#define		AT91_DDRSDRC_WP		(1 << 0)		/* Write protect enable */
> -#define		AT91_DDRSDRC_WPKEY	(0xffffff << 8)		/* Write protect key */
> -#define		AT91_DDRSDRC_KEY	(0x444452 << 8)		/* Write protect key = "DDR" */
> -
> -#define AT91_DDRSDRC_WPSR	0xE8	/* Write Protect Status Register [SAM9 Only] */
> -#define		AT91_DDRSDRC_WPVS	(1 << 0)		/* Write protect violation status */
> -#define		AT91_DDRSDRC_WPVSRC	(0xffff << 8)		/* Write protect violation source */
> -
> -#endif
> diff --git a/arch/arm/mach-at91/include/mach/at91sam9_sdramc.h b/arch/arm/mach-at91/include/mach/at91sam9_sdramc.h
> deleted file mode 100644
> index 3d085a9a7450..000000000000
> --- a/arch/arm/mach-at91/include/mach/at91sam9_sdramc.h
> +++ /dev/null
> @@ -1,85 +0,0 @@
> -/*
> - * arch/arm/mach-at91/include/mach/at91sam9_sdramc.h
> - *
> - * Copyright (C) 2007 Andrew Victor
> - * Copyright (C) 2007 Atmel Corporation.
> - *
> - * SDRAM Controllers (SDRAMC) - System peripherals registers.
> - * Based on AT91SAM9261 datasheet revision D.
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - */
> -
> -#ifndef AT91SAM9_SDRAMC_H
> -#define AT91SAM9_SDRAMC_H
> -
> -/* SDRAM Controller (SDRAMC) registers */
> -#define AT91_SDRAMC_MR		0x00	/* SDRAM Controller Mode Register */
> -#define		AT91_SDRAMC_MODE	(0xf << 0)		/* Command Mode */
> -#define			AT91_SDRAMC_MODE_NORMAL		0
> -#define			AT91_SDRAMC_MODE_NOP		1
> -#define			AT91_SDRAMC_MODE_PRECHARGE	2
> -#define			AT91_SDRAMC_MODE_LMR		3
> -#define			AT91_SDRAMC_MODE_REFRESH	4
> -#define			AT91_SDRAMC_MODE_EXT_LMR	5
> -#define			AT91_SDRAMC_MODE_DEEP		6
> -
> -#define AT91_SDRAMC_TR		0x04	/* SDRAM Controller Refresh Timer Register */
> -#define		AT91_SDRAMC_COUNT	(0xfff << 0)		/* Refresh Timer Counter */
> -
> -#define AT91_SDRAMC_CR		0x08	/* SDRAM Controller Configuration Register */
> -#define		AT91_SDRAMC_NC		(3 << 0)		/* Number of Column Bits */
> -#define			AT91_SDRAMC_NC_8	(0 << 0)
> -#define			AT91_SDRAMC_NC_9	(1 << 0)
> -#define			AT91_SDRAMC_NC_10	(2 << 0)
> -#define			AT91_SDRAMC_NC_11	(3 << 0)
> -#define		AT91_SDRAMC_NR		(3 << 2)		/* Number of Row Bits */
> -#define			AT91_SDRAMC_NR_11	(0 << 2)
> -#define			AT91_SDRAMC_NR_12	(1 << 2)
> -#define			AT91_SDRAMC_NR_13	(2 << 2)
> -#define		AT91_SDRAMC_NB		(1 << 4)		/* Number of Banks */
> -#define			AT91_SDRAMC_NB_2	(0 << 4)
> -#define			AT91_SDRAMC_NB_4	(1 << 4)
> -#define		AT91_SDRAMC_CAS		(3 << 5)		/* CAS Latency */
> -#define			AT91_SDRAMC_CAS_1	(1 << 5)
> -#define			AT91_SDRAMC_CAS_2	(2 << 5)
> -#define			AT91_SDRAMC_CAS_3	(3 << 5)
> -#define		AT91_SDRAMC_DBW		(1 << 7)		/* Data Bus Width */
> -#define			AT91_SDRAMC_DBW_32	(0 << 7)
> -#define			AT91_SDRAMC_DBW_16	(1 << 7)
> -#define		AT91_SDRAMC_TWR		(0xf <<  8)		/* Write Recovery Delay */
> -#define		AT91_SDRAMC_TRC		(0xf << 12)		/* Row Cycle Delay */
> -#define		AT91_SDRAMC_TRP		(0xf << 16)		/* Row Precharge Delay */
> -#define		AT91_SDRAMC_TRCD	(0xf << 20)		/* Row to Column Delay */
> -#define		AT91_SDRAMC_TRAS	(0xf << 24)		/* Active to Precharge Delay */
> -#define		AT91_SDRAMC_TXSR	(0xf << 28)		/* Exit Self Refresh to Active Delay */
> -
> -#define AT91_SDRAMC_LPR		0x10	/* SDRAM Controller Low Power Register */
> -#define		AT91_SDRAMC_LPCB		(3 << 0)	/* Low-power Configurations */
> -#define			AT91_SDRAMC_LPCB_DISABLE		0
> -#define			AT91_SDRAMC_LPCB_SELF_REFRESH		1
> -#define			AT91_SDRAMC_LPCB_POWER_DOWN		2
> -#define			AT91_SDRAMC_LPCB_DEEP_POWER_DOWN	3
> -#define		AT91_SDRAMC_PASR		(7 << 4)	/* Partial Array Self Refresh */
> -#define		AT91_SDRAMC_TCSR		(3 << 8)	/* Temperature Compensated Self Refresh */
> -#define		AT91_SDRAMC_DS			(3 << 10)	/* Drive Strength */
> -#define		AT91_SDRAMC_TIMEOUT		(3 << 12)	/* Time to define when Low Power Mode is enabled */
> -#define			AT91_SDRAMC_TIMEOUT_0_CLK_CYCLES	(0 << 12)
> -#define			AT91_SDRAMC_TIMEOUT_64_CLK_CYCLES	(1 << 12)
> -#define			AT91_SDRAMC_TIMEOUT_128_CLK_CYCLES	(2 << 12)
> -
> -#define AT91_SDRAMC_IER		0x14	/* SDRAM Controller Interrupt Enable Register */
> -#define AT91_SDRAMC_IDR		0x18	/* SDRAM Controller Interrupt Disable Register */
> -#define AT91_SDRAMC_IMR		0x1C	/* SDRAM Controller Interrupt Mask Register */
> -#define AT91_SDRAMC_ISR		0x20	/* SDRAM Controller Interrupt Status Register */
> -#define		AT91_SDRAMC_RES		(1 << 0)		/* Refresh Error Status */
> -
> -#define AT91_SDRAMC_MDR		0x24	/* SDRAM Memory Device Register */
> -#define		AT91_SDRAMC_MD		(3 << 0)		/* Memory Device Type */
> -#define			AT91_SDRAMC_MD_SDRAM		0
> -#define			AT91_SDRAMC_MD_LOW_POWER_SDRAM	1
> -
> -#endif
> diff --git a/arch/arm/mach-at91/pm.h b/arch/arm/mach-at91/pm.h
> index c5101dcb4fb0..d2c89963af2d 100644
> --- a/arch/arm/mach-at91/pm.h
> +++ b/arch/arm/mach-at91/pm.h
> @@ -14,7 +14,6 @@
>  #include <asm/proc-fns.h>
>  
>  #include <mach/at91_ramc.h>
> -#include <mach/at91rm9200_sdramc.h>
>  
>  #ifdef CONFIG_PM
>  extern void at91_pm_set_standby(void (*at91_standby)(void));
> diff --git a/drivers/power/reset/at91-reset.c b/drivers/power/reset/at91-reset.c
> index 3cb36693343a..69a75d99ae92 100644
> --- a/drivers/power/reset/at91-reset.c
> +++ b/drivers/power/reset/at91-reset.c
> @@ -19,8 +19,8 @@
>  
>  #include <asm/system_misc.h>
>  
> -#include <mach/at91sam9_ddrsdr.h>
> -#include <mach/at91sam9_sdramc.h>
> +#include <soc/at91/at91sam9_ddrsdr.h>
> +#include <soc/at91/at91sam9_sdramc.h>
>  
>  #define AT91_RSTC_CR	0x00		/* Reset Controller Control Register */
>  #define AT91_RSTC_PROCRST	BIT(0)		/* Processor Reset */
> diff --git a/include/soc/at91/at91rm9200_sdramc.h b/include/soc/at91/at91rm9200_sdramc.h
> new file mode 100644
> index 000000000000..aa047f458f1b
> --- /dev/null
> +++ b/include/soc/at91/at91rm9200_sdramc.h
> @@ -0,0 +1,63 @@
> +/*
> + * arch/arm/mach-at91/include/mach/at91rm9200_sdramc.h
> + *
> + * Copyright (C) 2005 Ivan Kokshaysky
> + * Copyright (C) SAN People
> + *
> + * Memory Controllers (SDRAMC only) - System peripherals registers.
> + * Based on AT91RM9200 datasheet revision E.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#ifndef AT91RM9200_SDRAMC_H
> +#define AT91RM9200_SDRAMC_H
> +
> +/* SDRAM Controller registers */
> +#define AT91RM9200_SDRAMC_MR		0x90			/* Mode Register */
> +#define		AT91RM9200_SDRAMC_MODE	(0xf << 0)		/* Command Mode */
> +#define			AT91RM9200_SDRAMC_MODE_NORMAL		(0 << 0)
> +#define			AT91RM9200_SDRAMC_MODE_NOP		(1 << 0)
> +#define			AT91RM9200_SDRAMC_MODE_PRECHARGE	(2 << 0)
> +#define			AT91RM9200_SDRAMC_MODE_LMR		(3 << 0)
> +#define			AT91RM9200_SDRAMC_MODE_REFRESH	(4 << 0)
> +#define		AT91RM9200_SDRAMC_DBW		(1   << 4)		/* Data Bus Width */
> +#define			AT91RM9200_SDRAMC_DBW_32	(0 << 4)
> +#define			AT91RM9200_SDRAMC_DBW_16	(1 << 4)
> +
> +#define AT91RM9200_SDRAMC_TR		0x94			/* Refresh Timer Register */
> +#define		AT91RM9200_SDRAMC_COUNT	(0xfff << 0)		/* Refresh Timer Count */
> +
> +#define AT91RM9200_SDRAMC_CR		0x98			/* Configuration Register */
> +#define		AT91RM9200_SDRAMC_NC		(3   <<  0)		/* Number of Column Bits */
> +#define			AT91RM9200_SDRAMC_NC_8	(0 << 0)
> +#define			AT91RM9200_SDRAMC_NC_9	(1 << 0)
> +#define			AT91RM9200_SDRAMC_NC_10	(2 << 0)
> +#define			AT91RM9200_SDRAMC_NC_11	(3 << 0)
> +#define		AT91RM9200_SDRAMC_NR		(3   <<  2)		/* Number of Row Bits */
> +#define			AT91RM9200_SDRAMC_NR_11	(0 << 2)
> +#define			AT91RM9200_SDRAMC_NR_12	(1 << 2)
> +#define			AT91RM9200_SDRAMC_NR_13	(2 << 2)
> +#define		AT91RM9200_SDRAMC_NB		(1   <<  4)		/* Number of Banks */
> +#define			AT91RM9200_SDRAMC_NB_2	(0 << 4)
> +#define			AT91RM9200_SDRAMC_NB_4	(1 << 4)
> +#define		AT91RM9200_SDRAMC_CAS		(3   <<  5)		/* CAS Latency */
> +#define			AT91RM9200_SDRAMC_CAS_2	(2 << 5)
> +#define		AT91RM9200_SDRAMC_TWR		(0xf <<  7)		/* Write Recovery Delay */
> +#define		AT91RM9200_SDRAMC_TRC		(0xf << 11)		/* Row Cycle Delay */
> +#define		AT91RM9200_SDRAMC_TRP		(0xf << 15)		/* Row Precharge Delay */
> +#define		AT91RM9200_SDRAMC_TRCD	(0xf << 19)		/* Row to Column Delay */
> +#define		AT91RM9200_SDRAMC_TRAS	(0xf << 23)		/* Active to Precharge Delay */
> +#define		AT91RM9200_SDRAMC_TXSR	(0xf << 27)		/* Exit Self Refresh to Active Delay */
> +
> +#define AT91RM9200_SDRAMC_SRR		0x9c			/* Self Refresh Register */
> +#define AT91RM9200_SDRAMC_LPR		0xa0			/* Low Power Register */
> +#define AT91RM9200_SDRAMC_IER		0xa4			/* Interrupt Enable Register */
> +#define AT91RM9200_SDRAMC_IDR		0xa8			/* Interrupt Disable Register */
> +#define AT91RM9200_SDRAMC_IMR		0xac			/* Interrupt Mask Register */
> +#define AT91RM9200_SDRAMC_ISR		0xb0			/* Interrupt Status Register */
> +
> +#endif
> diff --git a/include/soc/at91/at91sam9_ddrsdr.h b/include/soc/at91/at91sam9_ddrsdr.h
> new file mode 100644
> index 000000000000..0210797abf2e
> --- /dev/null
> +++ b/include/soc/at91/at91sam9_ddrsdr.h
> @@ -0,0 +1,124 @@
> +/*
> + * Header file for the Atmel DDR/SDR SDRAM Controller
> + *
> + * Copyright (C) 2010 Atmel Corporation
> + *	Nicolas Ferre <nicolas.ferre@atmel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#ifndef AT91SAM9_DDRSDR_H
> +#define AT91SAM9_DDRSDR_H
> +
> +#define AT91_DDRSDRC_MR		0x00	/* Mode Register */
> +#define		AT91_DDRSDRC_MODE	(0x7 << 0)		/* Command Mode */
> +#define			AT91_DDRSDRC_MODE_NORMAL	0
> +#define			AT91_DDRSDRC_MODE_NOP		1
> +#define			AT91_DDRSDRC_MODE_PRECHARGE	2
> +#define			AT91_DDRSDRC_MODE_LMR		3
> +#define			AT91_DDRSDRC_MODE_REFRESH	4
> +#define			AT91_DDRSDRC_MODE_EXT_LMR	5
> +#define			AT91_DDRSDRC_MODE_DEEP		6
> +
> +#define AT91_DDRSDRC_RTR	0x04	/* Refresh Timer Register */
> +#define		AT91_DDRSDRC_COUNT	(0xfff << 0)		/* Refresh Timer Counter */
> +
> +#define AT91_DDRSDRC_CR		0x08	/* Configuration Register */
> +#define		AT91_DDRSDRC_NC		(3 << 0)		/* Number of Column Bits */
> +#define			AT91_DDRSDRC_NC_SDR8	(0 << 0)
> +#define			AT91_DDRSDRC_NC_SDR9	(1 << 0)
> +#define			AT91_DDRSDRC_NC_SDR10	(2 << 0)
> +#define			AT91_DDRSDRC_NC_SDR11	(3 << 0)
> +#define			AT91_DDRSDRC_NC_DDR9	(0 << 0)
> +#define			AT91_DDRSDRC_NC_DDR10	(1 << 0)
> +#define			AT91_DDRSDRC_NC_DDR11	(2 << 0)
> +#define			AT91_DDRSDRC_NC_DDR12	(3 << 0)
> +#define		AT91_DDRSDRC_NR		(3 << 2)		/* Number of Row Bits */
> +#define			AT91_DDRSDRC_NR_11	(0 << 2)
> +#define			AT91_DDRSDRC_NR_12	(1 << 2)
> +#define			AT91_DDRSDRC_NR_13	(2 << 2)
> +#define			AT91_DDRSDRC_NR_14	(3 << 2)
> +#define		AT91_DDRSDRC_CAS	(7 << 4)		/* CAS Latency */
> +#define			AT91_DDRSDRC_CAS_2	(2 << 4)
> +#define			AT91_DDRSDRC_CAS_3	(3 << 4)
> +#define			AT91_DDRSDRC_CAS_25	(6 << 4)
> +#define		AT91_DDRSDRC_RST_DLL	(1 << 7)		/* Reset DLL */
> +#define		AT91_DDRSDRC_DICDS	(1 << 8)		/* Output impedance control */
> +#define		AT91_DDRSDRC_DIS_DLL	(1 << 9)		/* Disable DLL [SAM9 Only] */
> +#define		AT91_DDRSDRC_OCD	(1 << 12)		/* Off-Chip Driver [SAM9 Only] */
> +#define		AT91_DDRSDRC_DQMS	(1 << 16)		/* Mask Data is Shared [SAM9 Only] */
> +#define		AT91_DDRSDRC_ACTBST	(1 << 18)		/* Active Bank X to Burst Stop Read Access Bank Y [SAM9 Only] */
> +
> +#define AT91_DDRSDRC_T0PR	0x0C	/* Timing 0 Register */
> +#define		AT91_DDRSDRC_TRAS	(0xf <<  0)		/* Active to Precharge delay */
> +#define		AT91_DDRSDRC_TRCD	(0xf <<  4)		/* Row to Column delay */
> +#define		AT91_DDRSDRC_TWR	(0xf <<  8)		/* Write recovery delay */
> +#define		AT91_DDRSDRC_TRC	(0xf << 12)		/* Row cycle delay */
> +#define		AT91_DDRSDRC_TRP	(0xf << 16)		/* Row precharge delay */
> +#define		AT91_DDRSDRC_TRRD	(0xf << 20)		/* Active BankA to BankB */
> +#define		AT91_DDRSDRC_TWTR	(0x7 << 24)		/* Internal Write to Read delay */
> +#define		AT91_DDRSDRC_RED_WRRD	(0x1 << 27)		/* Reduce Write to Read Delay [SAM9 Only] */
> +#define		AT91_DDRSDRC_TMRD	(0xf << 28)		/* Load mode to active/refresh delay */
> +
> +#define AT91_DDRSDRC_T1PR	0x10	/* Timing 1 Register */
> +#define		AT91_DDRSDRC_TRFC	(0x1f << 0)		/* Row Cycle Delay */
> +#define		AT91_DDRSDRC_TXSNR	(0xff << 8)		/* Exit self-refresh to non-read */
> +#define		AT91_DDRSDRC_TXSRD	(0xff << 16)		/* Exit self-refresh to read */
> +#define		AT91_DDRSDRC_TXP	(0xf  << 24)		/* Exit power-down delay */
> +
> +#define AT91_DDRSDRC_T2PR	0x14	/* Timing 2 Register [SAM9 Only] */
> +#define		AT91_DDRSDRC_TXARD	(0xf  << 0)		/* Exit active power down delay to read command in mode "Fast Exit" */
> +#define		AT91_DDRSDRC_TXARDS	(0xf  << 4)		/* Exit active power down delay to read command in mode "Slow Exit" */
> +#define		AT91_DDRSDRC_TRPA	(0xf  << 8)		/* Row Precharge All delay */
> +#define		AT91_DDRSDRC_TRTP	(0x7  << 12)		/* Read to Precharge delay */
> +
> +#define AT91_DDRSDRC_LPR	0x1C	/* Low Power Register */
> +#define		AT91_DDRSDRC_LPCB	(3 << 0)		/* Low-power Configurations */
> +#define			AT91_DDRSDRC_LPCB_DISABLE		0
> +#define			AT91_DDRSDRC_LPCB_SELF_REFRESH		1
> +#define			AT91_DDRSDRC_LPCB_POWER_DOWN		2
> +#define			AT91_DDRSDRC_LPCB_DEEP_POWER_DOWN	3
> +#define		AT91_DDRSDRC_CLKFR	(1 << 2)	/* Clock Frozen */
> +#define		AT91_DDRSDRC_PASR	(7 << 4)	/* Partial Array Self Refresh */
> +#define		AT91_DDRSDRC_TCSR	(3 << 8)	/* Temperature Compensated Self Refresh */
> +#define		AT91_DDRSDRC_DS		(3 << 10)	/* Drive Strength */
> +#define		AT91_DDRSDRC_TIMEOUT	(3 << 12)	/* Time to define when Low Power Mode is enabled */
> +#define			AT91_DDRSDRC_TIMEOUT_0_CLK_CYCLES	(0 << 12)
> +#define			AT91_DDRSDRC_TIMEOUT_64_CLK_CYCLES	(1 << 12)
> +#define			AT91_DDRSDRC_TIMEOUT_128_CLK_CYCLES	(2 << 12)
> +#define		AT91_DDRSDRC_APDE	(1 << 16)	 /* Active power down exit time */
> +#define		AT91_DDRSDRC_UPD_MR	(3 << 20)	 /* Update load mode register and extended mode register */
> +
> +#define AT91_DDRSDRC_MDR	0x20	/* Memory Device Register */
> +#define		AT91_DDRSDRC_MD		(3 << 0)		/* Memory Device Type */
> +#define			AT91_DDRSDRC_MD_SDR		0
> +#define			AT91_DDRSDRC_MD_LOW_POWER_SDR	1
> +#define			AT91_DDRSDRC_MD_LOW_POWER_DDR	3
> +#define			AT91_DDRSDRC_MD_DDR2		6	/* [SAM9 Only] */
> +#define		AT91_DDRSDRC_DBW	(1 << 4)		/* Data Bus Width */
> +#define			AT91_DDRSDRC_DBW_32BITS		(0 <<  4)
> +#define			AT91_DDRSDRC_DBW_16BITS		(1 <<  4)
> +
> +#define AT91_DDRSDRC_DLL	0x24	/* DLL Information Register */
> +#define		AT91_DDRSDRC_MDINC	(1 << 0)		/* Master Delay increment */
> +#define		AT91_DDRSDRC_MDDEC	(1 << 1)		/* Master Delay decrement */
> +#define		AT91_DDRSDRC_MDOVF	(1 << 2)		/* Master Delay Overflow */
> +#define		AT91_DDRSDRC_MDVAL	(0xff <<  8)		/* Master Delay value */
> +
> +#define AT91_DDRSDRC_HS		0x2C	/* High Speed Register [SAM9 Only] */
> +#define		AT91_DDRSDRC_DIS_ATCP_RD	(1 << 2)	/* Anticip read access is disabled */
> +
> +#define AT91_DDRSDRC_DELAY(n)	(0x30 + (0x4 * (n)))	/* Delay I/O Register n */
> +
> +#define AT91_DDRSDRC_WPMR	0xE4	/* Write Protect Mode Register [SAM9 Only] */
> +#define		AT91_DDRSDRC_WP		(1 << 0)		/* Write protect enable */
> +#define		AT91_DDRSDRC_WPKEY	(0xffffff << 8)		/* Write protect key */
> +#define		AT91_DDRSDRC_KEY	(0x444452 << 8)		/* Write protect key = "DDR" */
> +
> +#define AT91_DDRSDRC_WPSR	0xE8	/* Write Protect Status Register [SAM9 Only] */
> +#define		AT91_DDRSDRC_WPVS	(1 << 0)		/* Write protect violation status */
> +#define		AT91_DDRSDRC_WPVSRC	(0xffff << 8)		/* Write protect violation source */
> +
> +#endif
> diff --git a/include/soc/at91/at91sam9_sdramc.h b/include/soc/at91/at91sam9_sdramc.h
> new file mode 100644
> index 000000000000..3d085a9a7450
> --- /dev/null
> +++ b/include/soc/at91/at91sam9_sdramc.h
> @@ -0,0 +1,85 @@
> +/*
> + * arch/arm/mach-at91/include/mach/at91sam9_sdramc.h
> + *
> + * Copyright (C) 2007 Andrew Victor
> + * Copyright (C) 2007 Atmel Corporation.
> + *
> + * SDRAM Controllers (SDRAMC) - System peripherals registers.
> + * Based on AT91SAM9261 datasheet revision D.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#ifndef AT91SAM9_SDRAMC_H
> +#define AT91SAM9_SDRAMC_H
> +
> +/* SDRAM Controller (SDRAMC) registers */
> +#define AT91_SDRAMC_MR		0x00	/* SDRAM Controller Mode Register */
> +#define		AT91_SDRAMC_MODE	(0xf << 0)		/* Command Mode */
> +#define			AT91_SDRAMC_MODE_NORMAL		0
> +#define			AT91_SDRAMC_MODE_NOP		1
> +#define			AT91_SDRAMC_MODE_PRECHARGE	2
> +#define			AT91_SDRAMC_MODE_LMR		3
> +#define			AT91_SDRAMC_MODE_REFRESH	4
> +#define			AT91_SDRAMC_MODE_EXT_LMR	5
> +#define			AT91_SDRAMC_MODE_DEEP		6
> +
> +#define AT91_SDRAMC_TR		0x04	/* SDRAM Controller Refresh Timer Register */
> +#define		AT91_SDRAMC_COUNT	(0xfff << 0)		/* Refresh Timer Counter */
> +
> +#define AT91_SDRAMC_CR		0x08	/* SDRAM Controller Configuration Register */
> +#define		AT91_SDRAMC_NC		(3 << 0)		/* Number of Column Bits */
> +#define			AT91_SDRAMC_NC_8	(0 << 0)
> +#define			AT91_SDRAMC_NC_9	(1 << 0)
> +#define			AT91_SDRAMC_NC_10	(2 << 0)
> +#define			AT91_SDRAMC_NC_11	(3 << 0)
> +#define		AT91_SDRAMC_NR		(3 << 2)		/* Number of Row Bits */
> +#define			AT91_SDRAMC_NR_11	(0 << 2)
> +#define			AT91_SDRAMC_NR_12	(1 << 2)
> +#define			AT91_SDRAMC_NR_13	(2 << 2)
> +#define		AT91_SDRAMC_NB		(1 << 4)		/* Number of Banks */
> +#define			AT91_SDRAMC_NB_2	(0 << 4)
> +#define			AT91_SDRAMC_NB_4	(1 << 4)
> +#define		AT91_SDRAMC_CAS		(3 << 5)		/* CAS Latency */
> +#define			AT91_SDRAMC_CAS_1	(1 << 5)
> +#define			AT91_SDRAMC_CAS_2	(2 << 5)
> +#define			AT91_SDRAMC_CAS_3	(3 << 5)
> +#define		AT91_SDRAMC_DBW		(1 << 7)		/* Data Bus Width */
> +#define			AT91_SDRAMC_DBW_32	(0 << 7)
> +#define			AT91_SDRAMC_DBW_16	(1 << 7)
> +#define		AT91_SDRAMC_TWR		(0xf <<  8)		/* Write Recovery Delay */
> +#define		AT91_SDRAMC_TRC		(0xf << 12)		/* Row Cycle Delay */
> +#define		AT91_SDRAMC_TRP		(0xf << 16)		/* Row Precharge Delay */
> +#define		AT91_SDRAMC_TRCD	(0xf << 20)		/* Row to Column Delay */
> +#define		AT91_SDRAMC_TRAS	(0xf << 24)		/* Active to Precharge Delay */
> +#define		AT91_SDRAMC_TXSR	(0xf << 28)		/* Exit Self Refresh to Active Delay */
> +
> +#define AT91_SDRAMC_LPR		0x10	/* SDRAM Controller Low Power Register */
> +#define		AT91_SDRAMC_LPCB		(3 << 0)	/* Low-power Configurations */
> +#define			AT91_SDRAMC_LPCB_DISABLE		0
> +#define			AT91_SDRAMC_LPCB_SELF_REFRESH		1
> +#define			AT91_SDRAMC_LPCB_POWER_DOWN		2
> +#define			AT91_SDRAMC_LPCB_DEEP_POWER_DOWN	3
> +#define		AT91_SDRAMC_PASR		(7 << 4)	/* Partial Array Self Refresh */
> +#define		AT91_SDRAMC_TCSR		(3 << 8)	/* Temperature Compensated Self Refresh */
> +#define		AT91_SDRAMC_DS			(3 << 10)	/* Drive Strength */
> +#define		AT91_SDRAMC_TIMEOUT		(3 << 12)	/* Time to define when Low Power Mode is enabled */
> +#define			AT91_SDRAMC_TIMEOUT_0_CLK_CYCLES	(0 << 12)
> +#define			AT91_SDRAMC_TIMEOUT_64_CLK_CYCLES	(1 << 12)
> +#define			AT91_SDRAMC_TIMEOUT_128_CLK_CYCLES	(2 << 12)
> +
> +#define AT91_SDRAMC_IER		0x14	/* SDRAM Controller Interrupt Enable Register */
> +#define AT91_SDRAMC_IDR		0x18	/* SDRAM Controller Interrupt Disable Register */
> +#define AT91_SDRAMC_IMR		0x1C	/* SDRAM Controller Interrupt Mask Register */
> +#define AT91_SDRAMC_ISR		0x20	/* SDRAM Controller Interrupt Status Register */
> +#define		AT91_SDRAMC_RES		(1 << 0)		/* Refresh Error Status */
> +
> +#define AT91_SDRAMC_MDR		0x24	/* SDRAM Memory Device Register */
> +#define		AT91_SDRAMC_MD		(3 << 0)		/* Memory Device Type */
> +#define			AT91_SDRAMC_MD_SDRAM		0
> +#define			AT91_SDRAMC_MD_LOW_POWER_SDRAM	1
> +
> +#endif
> 


-- 
Nicolas Ferre
