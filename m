Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaIYADA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 20:03:00 -0400
Received: from icp-osb-irony-out6.external.iinet.net.au ([203.59.1.222]:31655
	"EHLO icp-osb-irony-out6.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751134AbaIYAC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 20:02:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: An8DAM1aI1SVhxBY/2dsb2JhbAANPQwKukQGnAMBgR8BhH4BAQQaXgEQCw0LCQoMDwkDAgECAUUGAQwBBQIBAbVelyYBF4YSiSEBDg5OB4RLAQSGJosQk2CRU1qCSgEBAQ
X-IronPort-AV: E=Sophos;i="5.04,592,1406563200"; 
   d="scan'208";a="75196726"
Message-ID: <54235BB5.5020909@uclinux.org>
Date: Thu, 25 Sep 2014 10:03:01 +1000
From: Greg Ungerer <gerg@uclinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, u.kleine-koenig@pengutronix.de,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        ARM Maintainers <arm@kernel.org>
CC: linux-kernel@vger.kernel.org, Patrice Vilchez <patrice.vilchez@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [RFC PATCH] ARM: at91: remove no-MMU at91x40 support
References: <1411568281-3924-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1411568281-3924-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/09/14 00:18, Nicolas Ferre wrote:
> As there is currently no-one to take care of this old !MMU target and as its
> support in recent kernels is a bit rotten, remove this at91x40 support and the
> board file associated with it (at91eb01).
> There are modern ARM !MMU in Mainline now so this target is not interesting for
> building tests anymore. It would be better to start from these modern ARM !MMU
> platforms to reintroduce at91x40 support if needed.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Greg Ungerer <gerg@uclinux.org>


> ---
>  arch/arm/configs/at91x40_defconfig           | 48 --------------
>  arch/arm/mach-at91/Kconfig                   | 25 ++------
>  arch/arm/mach-at91/Kconfig.non_dt            | 17 -----
>  arch/arm/mach-at91/Makefile                  |  4 --
>  arch/arm/mach-at91/at91x40.c                 | 93 ----------------------------
>  arch/arm/mach-at91/at91x40_time.c            | 85 -------------------------
>  arch/arm/mach-at91/board-eb01.c              | 52 ----------------
>  arch/arm/mach-at91/generic.h                 |  3 -
>  arch/arm/mach-at91/include/mach/at91_dbgu.h  |  3 -
>  arch/arm/mach-at91/include/mach/at91x40.h    | 60 ------------------
>  arch/arm/mach-at91/include/mach/cpu.h        |  1 -
>  arch/arm/mach-at91/include/mach/hardware.h   |  4 --
>  arch/arm/mach-at91/include/mach/uncompress.h |  7 ---
>  arch/arm/mach-at91/setup.c                   |  2 +-
>  drivers/rtc/Kconfig                          |  2 +-
>  15 files changed, 7 insertions(+), 399 deletions(-)
>  delete mode 100644 arch/arm/configs/at91x40_defconfig
>  delete mode 100644 arch/arm/mach-at91/at91x40.c
>  delete mode 100644 arch/arm/mach-at91/at91x40_time.c
>  delete mode 100644 arch/arm/mach-at91/board-eb01.c
>  delete mode 100644 arch/arm/mach-at91/include/mach/at91x40.h
> 
> diff --git a/arch/arm/configs/at91x40_defconfig b/arch/arm/configs/at91x40_defconfig
> deleted file mode 100644
> index c55e9212fcbb..000000000000
> --- a/arch/arm/configs/at91x40_defconfig
> +++ /dev/null
> @@ -1,48 +0,0 @@
> -CONFIG_EXPERIMENTAL=y
> -CONFIG_LOG_BUF_SHIFT=14
> -CONFIG_EMBEDDED=y
> -# CONFIG_HOTPLUG is not set
> -# CONFIG_ELF_CORE is not set
> -# CONFIG_FUTEX is not set
> -# CONFIG_TIMERFD is not set
> -# CONFIG_VM_EVENT_COUNTERS is not set
> -# CONFIG_COMPAT_BRK is not set
> -CONFIG_SLAB=y
> -# CONFIG_LBDAF is not set
> -# CONFIG_BLK_DEV_BSG is not set
> -# CONFIG_IOSCHED_DEADLINE is not set
> -# CONFIG_IOSCHED_CFQ is not set
> -# CONFIG_MMU is not set
> -CONFIG_ARCH_AT91=y
> -CONFIG_ARCH_AT91X40=y
> -CONFIG_MACH_AT91EB01=y
> -CONFIG_AT91_EARLY_USART0=y
> -CONFIG_CPU_ARM7TDMI=y
> -CONFIG_SET_MEM_PARAM=y
> -CONFIG_DRAM_BASE=0x01000000
> -CONFIG_DRAM_SIZE=0x00400000
> -CONFIG_FLASH_MEM_BASE=0x01400000
> -CONFIG_PROCESSOR_ID=0x14000040
> -CONFIG_ZBOOT_ROM_TEXT=0x0
> -CONFIG_ZBOOT_ROM_BSS=0x0
> -CONFIG_BINFMT_FLAT=y
> -# CONFIG_SUSPEND is not set
> -# CONFIG_FW_LOADER is not set
> -CONFIG_MTD=y
> -CONFIG_MTD_PARTITIONS=y
> -CONFIG_MTD_CHAR=y
> -CONFIG_MTD_BLOCK=y
> -CONFIG_MTD_RAM=y
> -CONFIG_MTD_ROM=y
> -CONFIG_BLK_DEV_RAM=y
> -# CONFIG_INPUT is not set
> -# CONFIG_SERIO is not set
> -# CONFIG_VT is not set
> -# CONFIG_DEVKMEM is not set
> -# CONFIG_HW_RANDOM is not set
> -# CONFIG_HWMON is not set
> -# CONFIG_USB_SUPPORT is not set
> -CONFIG_EXT2_FS=y
> -# CONFIG_DNOTIFY is not set
> -CONFIG_ROMFS_FS=y
> -# CONFIG_ENABLE_MUST_CHECK is not set
> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> index 807b22dadcb6..f3bd8abd25c0 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -18,26 +18,22 @@ config HAVE_AT91_DBGU2
>  config AT91_USE_OLD_CLK
>  	bool
>  
> -config AT91_PMC_UNIT
> -	bool
> -	default !ARCH_AT91X40
> -
>  config COMMON_CLK_AT91
>  	bool
> -	default AT91_PMC_UNIT && USE_OF && !AT91_USE_OLD_CLK
> +	default USE_OF && !AT91_USE_OLD_CLK
>  	select COMMON_CLK
>  
>  config OLD_CLK_AT91
>  	bool
> -	default AT91_PMC_UNIT && AT91_USE_OLD_CLK
> +	default AT91_USE_OLD_CLK
>  
>  config AT91_SAM9_ALT_RESET
>  	bool
> -	default !ARCH_AT91X40
> +	default y
>  
>  config AT91_SAM9G45_RESET
>  	bool
> -	default !ARCH_AT91X40
> +	default y
>  
>  config AT91_SAM9_TIME
>  	bool
> @@ -71,17 +67,6 @@ choice
>  
>  	prompt "Core type"
>  
> -config ARCH_AT91X40
> -	bool "ARM7 AT91X40"
> -	depends on !MMU
> -	select CPU_ARM7TDMI
> -	select ARCH_USES_GETTIMEOFFSET
> -	select MULTI_IRQ_HANDLER
> -	select SPARSE_IRQ
> -
> -	help
> -	  Select this if you are using one of Atmel's AT91X40 SoC.
> -
>  config SOC_SAM_V4_V5
>  	bool "ARM9 AT91SAM9/AT91RM9200"
>  	help
> @@ -207,7 +192,7 @@ config SOC_AT91SAM9N12
>  endif # SOC_SAM_V4_V5
>  
>  
> -if SOC_SAM_V4_V5 || ARCH_AT91X40
> +if SOC_SAM_V4_V5
>  source arch/arm/mach-at91/Kconfig.non_dt
>  endif
>  
> diff --git a/arch/arm/mach-at91/Kconfig.non_dt b/arch/arm/mach-at91/Kconfig.non_dt
> index aa31e556e2e5..2c62a078c1d9 100644
> --- a/arch/arm/mach-at91/Kconfig.non_dt
> +++ b/arch/arm/mach-at91/Kconfig.non_dt
> @@ -5,7 +5,6 @@ config HAVE_AT91_DATAFLASH_CARD
>  
>  choice
>  	prompt "Atmel AT91 Processor Devices for non DT boards"
> -	depends on !ARCH_AT91X40
>  
>  config ARCH_AT91_NONE
>  	bool "None"
> @@ -311,22 +310,6 @@ endif
>  
>  # ----------------------------------------------------------
>  
> -if ARCH_AT91X40
> -
> -comment "AT91X40 Board Type"
> -
> -config MACH_AT91EB01
> -	bool "Atmel AT91EB01 Evaluation Kit"
> -	help
> -	  Select this if you are using Atmel's AT91EB01 Evaluation Kit.
> -	  It is also a popular target for simulators such as GDB's
> -	  ARM simulator (commonly known as the ARMulator) and the
> -	  Skyeye simulator.
> -
> -endif
> -
> -# ----------------------------------------------------------
> -
>  comment "AT91 Board Options"
>  
>  config MTD_AT91_DATAFLASH_CARD
> diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
> index 3e9f01ca142a..3c27e434dad7 100644
> --- a/arch/arm/mach-at91/Makefile
> +++ b/arch/arm/mach-at91/Makefile
> @@ -31,7 +31,6 @@ obj-$(CONFIG_ARCH_AT91SAM9261)	+= at91sam9261_devices.o
>  obj-$(CONFIG_ARCH_AT91SAM9263)	+= at91sam9263_devices.o
>  obj-$(CONFIG_ARCH_AT91SAM9RL)	+= at91sam9rl_devices.o
>  obj-$(CONFIG_ARCH_AT91SAM9G45)	+= at91sam9g45_devices.o
> -obj-$(CONFIG_ARCH_AT91X40)	+= at91x40.o at91x40_time.o
>  
>  # AT91RM9200 board-specific support
>  obj-$(CONFIG_MACH_ONEARM)	+= board-1arm.o
> @@ -87,9 +86,6 @@ obj-$(CONFIG_MACH_AT91SAM9_DT) += board-dt-sam9.o
>  # SAMA5 board with device-tree
>  obj-$(CONFIG_MACH_SAMA5_DT) += board-dt-sama5.o
>  
> -# AT91X40 board-specific support
> -obj-$(CONFIG_MACH_AT91EB01)	+= board-eb01.o
> -
>  # Drivers
>  obj-y				+= leds.o
>  
> diff --git a/arch/arm/mach-at91/at91x40.c b/arch/arm/mach-at91/at91x40.c
> deleted file mode 100644
> index 7523f1cdfe1d..000000000000
> --- a/arch/arm/mach-at91/at91x40.c
> +++ /dev/null
> @@ -1,93 +0,0 @@
> -/*
> - * arch/arm/mach-at91/at91x40.c
> - *
> - * (C) Copyright 2007, Greg Ungerer <gerg@snapgear.com>
> - * Copyright (C) 2005 SAN People
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - */
> -
> -#include <linux/kernel.h>
> -#include <linux/init.h>
> -#include <linux/irq.h>
> -#include <linux/io.h>
> -#include <asm/proc-fns.h>
> -#include <asm/system_misc.h>
> -#include <asm/mach/arch.h>
> -#include <mach/at91x40.h>
> -#include <mach/at91_st.h>
> -#include <mach/hardware.h>
> -
> -#include "at91_aic.h"
> -#include "generic.h"
> -
> -/*
> - * Export the clock functions for the AT91X40. Some external code common
> - * to all AT91 family parts relys on this, like the gpio and serial support.
> - */
> -int clk_enable(struct clk *clk)
> -{
> -	return 0;
> -}
> -
> -void clk_disable(struct clk *clk)
> -{
> -}
> -
> -unsigned long clk_get_rate(struct clk *clk)
> -{
> -	return AT91X40_MASTER_CLOCK;
> -}
> -
> -static void at91x40_idle(void)
> -{
> -	/*
> -	 * Disable the processor clock.  The processor will be automatically
> -	 * re-enabled by an interrupt or by a reset.
> -	 */
> -	__raw_writel(AT91_PS_CR_CPU, AT91_IO_P2V(AT91_PS_CR));
> -	cpu_do_idle();
> -}
> -
> -void __init at91x40_initialize(unsigned long main_clock)
> -{
> -	arm_pm_idle = at91x40_idle;
> -}
> -
> -/*
> - * The default interrupt priority levels (0 = lowest, 7 = highest).
> - */
> -static unsigned int at91x40_default_irq_priority[NR_AIC_IRQS] __initdata = {
> -	7,	/* Advanced Interrupt Controller (FIQ) */
> -	0,	/* System Peripherals */
> -	0,	/* USART 0 */
> -	0,	/* USART 1 */
> -	2,	/* Timer Counter 0 */
> -	2,	/* Timer Counter 1 */
> -	2,	/* Timer Counter 2 */
> -	0,	/* Watchdog timer */
> -	0,	/* Parallel IO Controller A */
> -	0,	/* Reserved */
> -	0,	/* Reserved */
> -	0,	/* Reserved */
> -	0,	/* Reserved */
> -	0,	/* Reserved */
> -	0,	/* Reserved */
> -	0,	/* Reserved */
> -	0,	/* External IRQ0 */
> -	0,	/* External IRQ1 */
> -	0,	/* External IRQ2 */
> -};
> -
> -void __init at91x40_init_interrupts(unsigned int priority[NR_AIC_IRQS])
> -{
> -	u32  extern_irq = (1 << AT91X40_ID_IRQ0) | (1 << AT91X40_ID_IRQ1)
> -			| (1 << AT91X40_ID_IRQ2);
> -	if (!priority)
> -		priority = at91x40_default_irq_priority;
> -
> -	at91_aic_init(priority, extern_irq);
> -}
> diff --git a/arch/arm/mach-at91/at91x40_time.c b/arch/arm/mach-at91/at91x40_time.c
> deleted file mode 100644
> index 07d0bf2ac2da..000000000000
> --- a/arch/arm/mach-at91/at91x40_time.c
> +++ /dev/null
> @@ -1,85 +0,0 @@
> -/*
> - * arch/arm/mach-at91/at91x40_time.c
> - *
> - * (C) Copyright 2007, Greg Ungerer <gerg@snapgear.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> - */
> -
> -#include <linux/kernel.h>
> -#include <linux/init.h>
> -#include <linux/interrupt.h>
> -#include <linux/irq.h>
> -#include <linux/time.h>
> -#include <linux/io.h>
> -#include <mach/hardware.h>
> -#include <mach/at91x40.h>
> -#include <asm/mach/time.h>
> -
> -#include "at91_tc.h"
> -
> -#define at91_tc_read(field) \
> -	__raw_readl(AT91_IO_P2V(AT91_TC) + field)
> -
> -#define at91_tc_write(field, value) \
> -	__raw_writel(value, AT91_IO_P2V(AT91_TC) + field)
> -
> -/*
> - *	3 counter/timer units present.
> - */
> -#define	AT91_TC_CLK0BASE	0
> -#define	AT91_TC_CLK1BASE	0x40
> -#define	AT91_TC_CLK2BASE	0x80
> -
> -static u32 at91x40_gettimeoffset(void)
> -{
> -	return (at91_tc_read(AT91_TC_CLK1BASE + AT91_TC_CV) * 1000000 /
> -		(AT91X40_MASTER_CLOCK / 128)) * 1000;
> -}
> -
> -static irqreturn_t at91x40_timer_interrupt(int irq, void *dev_id)
> -{
> -	at91_tc_read(AT91_TC_CLK1BASE + AT91_TC_SR);
> -	timer_tick();
> -	return IRQ_HANDLED;
> -}
> -
> -static struct irqaction at91x40_timer_irq = {
> -	.name		= "at91_tick",
> -	.flags		= IRQF_TIMER,
> -	.handler	= at91x40_timer_interrupt
> -};
> -
> -void __init at91x40_timer_init(void)
> -{
> -	unsigned int v;
> -
> -	arch_gettimeoffset = at91x40_gettimeoffset;
> -
> -	at91_tc_write(AT91_TC_BCR, 0);
> -	v = at91_tc_read(AT91_TC_BMR);
> -	v = (v & ~AT91_TC_TC1XC1S) | AT91_TC_TC1XC1S_NONE;
> -	at91_tc_write(AT91_TC_BMR, v);
> -
> -	at91_tc_write(AT91_TC_CLK1BASE + AT91_TC_CCR, AT91_TC_CLKDIS);
> -	at91_tc_write(AT91_TC_CLK1BASE + AT91_TC_CMR, (AT91_TC_TIMER_CLOCK4 | AT91_TC_CPCTRG));
> -	at91_tc_write(AT91_TC_CLK1BASE + AT91_TC_IDR, 0xffffffff);
> -	at91_tc_write(AT91_TC_CLK1BASE + AT91_TC_RC, (AT91X40_MASTER_CLOCK / 128) / HZ - 1);
> -	at91_tc_write(AT91_TC_CLK1BASE + AT91_TC_IER, (1<<4));
> -
> -	setup_irq(AT91X40_ID_TC1, &at91x40_timer_irq);
> -
> -	at91_tc_write(AT91_TC_CLK1BASE + AT91_TC_CCR, (AT91_TC_SWTRG | AT91_TC_CLKEN));
> -}
> diff --git a/arch/arm/mach-at91/board-eb01.c b/arch/arm/mach-at91/board-eb01.c
> deleted file mode 100644
> index becf0a6a289e..000000000000
> --- a/arch/arm/mach-at91/board-eb01.c
> +++ /dev/null
> @@ -1,52 +0,0 @@
> -/*
> - * arch/arm/mach-at91/board-eb01.c
> - *
> - * (C) Copyright 2007, Greg Ungerer <gerg@snapgear.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> - */
> -
> -#include <linux/kernel.h>
> -#include <linux/init.h>
> -#include <linux/module.h>
> -#include <linux/platform_device.h>
> -#include <linux/irq.h>
> -#include <asm/mach-types.h>
> -#include <mach/hardware.h>
> -#include <asm/mach/arch.h>
> -#include <asm/mach/map.h>
> -
> -#include "at91_aic.h"
> -#include "board.h"
> -#include "generic.h"
> -
> -static void __init at91eb01_init_irq(void)
> -{
> -	at91x40_init_interrupts(NULL);
> -}
> -
> -static void __init at91eb01_init_early(void)
> -{
> -	at91x40_initialize(40000000);
> -}
> -
> -MACHINE_START(AT91EB01, "Atmel AT91 EB01")
> -	/* Maintainer: Greg Ungerer <gerg@snapgear.com> */
> -	.init_time	= at91x40_timer_init,
> -	.handle_irq	= at91_aic_handle_irq,
> -	.init_early	= at91eb01_init_early,
> -	.init_irq	= at91eb01_init_irq,
> -MACHINE_END
> -
> diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
> index cddf1e51c50e..4c12d1eba4d6 100644
> --- a/arch/arm/mach-at91/generic.h
> +++ b/arch/arm/mach-at91/generic.h
> @@ -21,14 +21,12 @@ extern void __init at91_init_sram(int bank, unsigned long base,
>   /* Processors */
>  extern void __init at91rm9200_set_type(int type);
>  extern void __init at91_initialize(unsigned long main_clock);
> -extern void __init at91x40_initialize(unsigned long main_clock);
>  extern void __init at91rm9200_dt_initialize(void);
>  extern void __init at91_dt_initialize(void);
>  
>   /* Interrupts */
>  extern void __init at91_init_irq_default(void);
>  extern void __init at91_init_interrupts(unsigned int priority[]);
> -extern void __init at91x40_init_interrupts(unsigned int priority[]);
>  extern void __init at91_aic_init(unsigned int priority[],
>  				 unsigned int ext_irq_mask);
>  extern int  __init at91_aic_of_init(struct device_node *node,
> @@ -44,7 +42,6 @@ extern void at91rm9200_ioremap_st(u32 addr);
>  extern void at91rm9200_timer_init(void);
>  extern void at91sam926x_ioremap_pit(u32 addr);
>  extern void at91sam926x_pit_init(void);
> -extern void at91x40_timer_init(void);
>  
>   /* Clocks */
>  #ifdef CONFIG_OLD_CLK_AT91
> diff --git a/arch/arm/mach-at91/include/mach/at91_dbgu.h b/arch/arm/mach-at91/include/mach/at91_dbgu.h
> index 3b5948566e52..42925e8f78e4 100644
> --- a/arch/arm/mach-at91/include/mach/at91_dbgu.h
> +++ b/arch/arm/mach-at91/include/mach/at91_dbgu.h
> @@ -16,7 +16,6 @@
>  #ifndef AT91_DBGU_H
>  #define AT91_DBGU_H
>  
> -#if !defined(CONFIG_ARCH_AT91X40)
>  #define AT91_DBGU_CR		(0x00)	/* Control Register */
>  #define AT91_DBGU_MR		(0x04)	/* Mode Register */
>  #define AT91_DBGU_IER		(0x08)	/* Interrupt Enable Register */
> @@ -34,8 +33,6 @@
>  #define AT91_DBGU_FNR		(0x48)	/* Force NTRST Register [SAM9 only] */
>  #define		AT91_DBGU_FNTRST	(1 << 0)		/* Force NTRST */
>  
> -#endif /* AT91_DBGU */
> -
>  /*
>   * Some AT91 parts that don't have full DEBUG units still support the ID
>   * and extensions register.
> diff --git a/arch/arm/mach-at91/include/mach/at91x40.h b/arch/arm/mach-at91/include/mach/at91x40.h
> deleted file mode 100644
> index 38dca2bb027f..000000000000
> --- a/arch/arm/mach-at91/include/mach/at91x40.h
> +++ /dev/null
> @@ -1,60 +0,0 @@
> -/*
> - * arch/arm/mach-at91/include/mach/at91x40.h
> - *
> - * (C) Copyright 2007, Greg Ungerer <gerg@snapgear.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - */
> -
> -#ifndef AT91X40_H
> -#define AT91X40_H
> -
> -/*
> - *	IRQ list.
> - */
> -#define AT91X40_ID_USART0	2	/* USART port 0 */
> -#define AT91X40_ID_USART1	3	/* USART port 1 */
> -#define AT91X40_ID_TC0		4	/* Timer/Counter 0 */
> -#define AT91X40_ID_TC1		5	/* Timer/Counter 1*/
> -#define AT91X40_ID_TC2		6	/* Timer/Counter 2*/
> -#define AT91X40_ID_WD		7	/* Watchdog? */
> -#define AT91X40_ID_PIOA		8	/* Parallel IO Controller A */
> -
> -#define AT91X40_ID_IRQ0		16	/* External IRQ 0 */
> -#define AT91X40_ID_IRQ1		17	/* External IRQ 1 */
> -#define AT91X40_ID_IRQ2		18	/* External IRQ 2 */
> -
> -/*
> - * System Peripherals
> - */
> -#define AT91_BASE_SYS	0xffc00000
> -
> -#define AT91_EBI	0xffe00000	/* External Bus Interface */
> -#define AT91_SF		0xfff00000	/* Special Function */
> -#define AT91_USART1	0xfffcc000	/* USART 1 */
> -#define AT91_USART0	0xfffd0000	/* USART 0 */
> -#define AT91_TC		0xfffe0000	/* Timer Counter */
> -#define AT91_PIOA	0xffff0000	/* PIO Controller A */
> -#define AT91_PS		0xffff4000	/* Power Save */
> -#define AT91_WD		0xffff8000	/* Watchdog Timer */
> -
> -/*
> - * The AT91x40 series doesn't have a debug unit like the other AT91 parts.
> - * But it does have a chip identify register and extension ID, so define at
> - * least these here.
> - */
> -#define AT91_DBGU_CIDR	(AT91_SF + 0)	/* CIDR in PS segment */
> -#define AT91_DBGU_EXID	(AT91_SF + 4)	/* EXID in PS segment */
> -
> -/*
> - * Support defines for the simple Power Controller module.
> - */
> -#define	AT91_PS_CR	(AT91_PS + 0)	/* PS Control register */
> -#define	AT91_PS_CR_CPU	(1 << 0)	/* CPU clock disable bit */
> -
> -#define AT91X40_MASTER_CLOCK	40000000
> -
> -#endif /* AT91X40_H */
> diff --git a/arch/arm/mach-at91/include/mach/cpu.h b/arch/arm/mach-at91/include/mach/cpu.h
> index b27e9ca65653..61914fb35f5d 100644
> --- a/arch/arm/mach-at91/include/mach/cpu.h
> +++ b/arch/arm/mach-at91/include/mach/cpu.h
> @@ -62,7 +62,6 @@
>  #define ARCH_EXID_SAMA5D43	0x00000003
>  #define ARCH_EXID_SAMA5D44	0x00000004
>  
> -#define ARCH_FAMILY_AT91X92	0x09200000
>  #define ARCH_FAMILY_AT91SAM9	0x01900000
>  #define ARCH_FAMILY_AT91SAM9XE	0x02900000
>  
> diff --git a/arch/arm/mach-at91/include/mach/hardware.h b/arch/arm/mach-at91/include/mach/hardware.h
> index d84776f6b8ac..3fe30f613f23 100644
> --- a/arch/arm/mach-at91/include/mach/hardware.h
> +++ b/arch/arm/mach-at91/include/mach/hardware.h
> @@ -24,9 +24,6 @@
>  /* sama5d4 */
>  #define AT91_BASE_DBGU2	0xfc069000
>  
> -#if defined(CONFIG_ARCH_AT91X40)
> -#include <mach/at91x40.h>
> -#else
>  #include <mach/at91rm9200.h>
>  #include <mach/at91sam9260.h>
>  #include <mach/at91sam9261.h>
> @@ -55,7 +52,6 @@
>   * On sama5d4 there is no system controller, we map some needed peripherals
>   */
>  #define AT91_ALT_BASE_SYS	0xfc069000
> -#endif
>  
>  /*
>   * On all at91 have the Advanced Interrupt Controller starts at address
> diff --git a/arch/arm/mach-at91/include/mach/uncompress.h b/arch/arm/mach-at91/include/mach/uncompress.h
> index acb2d890ad7e..4ebb609369e3 100644
> --- a/arch/arm/mach-at91/include/mach/uncompress.h
> +++ b/arch/arm/mach-at91/include/mach/uncompress.h
> @@ -31,7 +31,6 @@
>  
>  void __iomem *at91_uart;
>  
> -#if !defined(CONFIG_ARCH_AT91X40)
>  static const u32 uarts_rm9200[] = {
>  	AT91_BASE_DBGU0,
>  	AT91RM9200_BASE_US0,
> @@ -188,12 +187,6 @@ static inline void arch_decomp_setup(void)
>  
>  	at91_uart = NULL;
>  }
> -#else
> -static inline void arch_decomp_setup(void)
> -{
> -	at91_uart = NULL;
> -}
> -#endif
>  
>  /*
>   * The following code assumes the serial port has already been
> diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
> index 535a6e70f4ef..7fcb9fa5aa31 100644
> --- a/arch/arm/mach-at91/setup.c
> +++ b/arch/arm/mach-at91/setup.c
> @@ -440,7 +440,7 @@ void __init at91_ioremap_matrix(u32 base_addr)
>  		panic("Impossible to ioremap at91_matrix_base\n");
>  }
>  
> -#if defined(CONFIG_OF) && !defined(CONFIG_ARCH_AT91X40)
> +#if defined(CONFIG_OF)
>  static struct of_device_id rstc_ids[] = {
>  	{ .compatible = "atmel,at91sam9260-rstc", .data = at91sam9_alt_restart },
>  	{ .compatible = "atmel,at91sam9g45-rstc", .data = at91sam9g45_restart },
> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> index a168e96142b9..65acf0707f63 100644
> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -1080,7 +1080,7 @@ config RTC_DRV_AT91RM9200
>  
>  config RTC_DRV_AT91SAM9
>  	tristate "AT91SAM9x/AT91CAP9 RTT as RTC"
> -	depends on ARCH_AT91 && !(ARCH_AT91RM9200 || ARCH_AT91X40)
> +	depends on ARCH_AT91 && !ARCH_AT91RM9200
>  	help
>  	  RTC driver for the Atmel AT91SAM9x and AT91CAP9 internal RTT
>  	  (Real Time Timer). These timers are powered by the backup power
> 

