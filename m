Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab3CNWMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 18:12:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63767 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab3CNWMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 18:12:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@vger.kernel.org
Cc: patches@linaro.org, Olof Johansson <olof@lixom.net>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Robert Schwebel <r.schwebel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 5/6] ARM: kill Hynix h720x platform
Date: Thu, 14 Mar 2013 23:12:07 +0100
Message-Id: <1363299128-8192-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363299128-8192-1-git-send-email-arnd@arndb.de>
References: <1363299128-8192-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:PVkYINs8Pz6uT3Wfljor90GtlIsJuOe9c9o7cKtjzjP
 aJtO8Jda5SPCzMTza/4IVNK8ENsHzQ102YrDw6WwVOulwXq1X9
 YdMrvUdScUe5bRxAaEFItJmf+bliMWewB9KIbJpshn+SDGmTeQ
 HR7PfHeOAZgLSmoqYcfzQEgwA1E2U57VmhoA6obeZMxqByglg8
 yuoeGbsAAXIixrf/MDS9UAcovK/syR5E1T+Q95t9EGkjlEM4Dp
 D6HhWQdBECUxyJ5PBHQ9HiXTc/6+OEIw2vvQjZ3zM0dPjfKYqf
 QXitG7/Num8fU9EZu6Bya/WM3P8Hx8hxUEew6MH9/9Okf8IDeU
 4ssqJls0zpABxv7ukiExO+iDNrawswz3c2J0Vm2J1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform was merged about 10 years ago, and has seen few updates
for most of the time since. The people that merged the code seem
no longer interested in it either, so let's remove it now.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
---
 arch/arm/Kconfig                               |  10 -
 arch/arm/Makefile                              |   1 -
 arch/arm/configs/h7201_defconfig               |  27 ---
 arch/arm/configs/h7202_defconfig               |  47 -----
 arch/arm/mach-h720x/Kconfig                    |  40 ----
 arch/arm/mach-h720x/Makefile                   |  16 --
 arch/arm/mach-h720x/Makefile.boot              |   2 -
 arch/arm/mach-h720x/common.c                   | 268 -------------------------
 arch/arm/mach-h720x/common.h                   |  30 ---
 arch/arm/mach-h720x/cpu-h7201.c                |  57 ------
 arch/arm/mach-h720x/cpu-h7202.c                | 225 ---------------------
 arch/arm/mach-h720x/h7201-eval.c               |  38 ----
 arch/arm/mach-h720x/h7202-eval.c               |  81 --------
 arch/arm/mach-h720x/include/mach/boards.h      |  53 -----
 arch/arm/mach-h720x/include/mach/debug-macro.S |  40 ----
 arch/arm/mach-h720x/include/mach/entry-macro.S |  57 ------
 arch/arm/mach-h720x/include/mach/h7201-regs.h  |  67 -------
 arch/arm/mach-h720x/include/mach/h7202-regs.h  | 155 --------------
 arch/arm/mach-h720x/include/mach/hardware.h    | 190 ------------------
 arch/arm/mach-h720x/include/mach/irqs.h        | 116 -----------
 arch/arm/mach-h720x/include/mach/isa-dma.h     |  19 --
 arch/arm/mach-h720x/include/mach/timex.h       |  15 --
 arch/arm/mach-h720x/include/mach/uncompress.h  |  36 ----
 23 files changed, 1590 deletions(-)
 delete mode 100644 arch/arm/configs/h7201_defconfig
 delete mode 100644 arch/arm/configs/h7202_defconfig
 delete mode 100644 arch/arm/mach-h720x/Kconfig
 delete mode 100644 arch/arm/mach-h720x/Makefile
 delete mode 100644 arch/arm/mach-h720x/Makefile.boot
 delete mode 100644 arch/arm/mach-h720x/common.c
 delete mode 100644 arch/arm/mach-h720x/common.h
 delete mode 100644 arch/arm/mach-h720x/cpu-h7201.c
 delete mode 100644 arch/arm/mach-h720x/cpu-h7202.c
 delete mode 100644 arch/arm/mach-h720x/h7201-eval.c
 delete mode 100644 arch/arm/mach-h720x/h7202-eval.c
 delete mode 100644 arch/arm/mach-h720x/include/mach/boards.h
 delete mode 100644 arch/arm/mach-h720x/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-h720x/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-h720x/include/mach/h7201-regs.h
 delete mode 100644 arch/arm/mach-h720x/include/mach/h7202-regs.h
 delete mode 100644 arch/arm/mach-h720x/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-h720x/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-h720x/include/mach/isa-dma.h
 delete mode 100644 arch/arm/mach-h720x/include/mach/timex.h
 delete mode 100644 arch/arm/mach-h720x/include/mach/uncompress.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 9d2e825..26e9251 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -485,14 +485,6 @@ config ARCH_NETX
 	help
 	  This enables support for systems based on the Hilscher NetX Soc
 
-config ARCH_H720X
-	bool "Hynix HMS720x-based"
-	select ARCH_USES_GETTIMEOFFSET
-	select CPU_ARM720T
-	select ISA_DMA_API
-	help
-	  This enables support for systems based on the Hynix HMS720x
-
 config ARCH_IOP13XX
 	bool "IOP13xx-based"
 	depends on MMU
@@ -1041,8 +1033,6 @@ source "arch/arm/mach-ep93xx/Kconfig"
 
 source "arch/arm/mach-footbridge/Kconfig"
 
-source "arch/arm/mach-h720x/Kconfig"
-
 source "arch/arm/mach-highbank/Kconfig"
 
 source "arch/arm/mach-integrator/Kconfig"
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index b514a0a..5f4576d 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -145,7 +145,6 @@ machine-$(CONFIG_ARCH_DAVINCI)		+= davinci
 machine-$(CONFIG_ARCH_DOVE)		+= dove
 machine-$(CONFIG_ARCH_EBSA110)		+= ebsa110
 machine-$(CONFIG_ARCH_EP93XX)		+= ep93xx
-machine-$(CONFIG_ARCH_H720X)		+= h720x
 machine-$(CONFIG_ARCH_HIGHBANK)		+= highbank
 machine-$(CONFIG_ARCH_INTEGRATOR)	+= integrator
 machine-$(CONFIG_ARCH_IOP13XX)		+= iop13xx
diff --git a/arch/arm/configs/h7201_defconfig b/arch/arm/configs/h7201_defconfig
deleted file mode 100644
index bee94d2..0000000
--- a/arch/arm/configs/h7201_defconfig
+++ /dev/null
@@ -1,27 +0,0 @@
-CONFIG_EXPERIMENTAL=y
-CONFIG_SYSVIPC=y
-CONFIG_LOG_BUF_SHIFT=14
-CONFIG_BLK_DEV_INITRD=y
-CONFIG_MODULES=y
-CONFIG_ARCH_H720X=y
-CONFIG_ARCH_H7201=y
-CONFIG_ZBOOT_ROM_TEXT=0x0
-CONFIG_ZBOOT_ROM_BSS=0x0
-CONFIG_FPE_NWFPE=y
-CONFIG_MTD=y
-CONFIG_MTD_DEBUG=y
-CONFIG_MTD_PARTITIONS=y
-CONFIG_MTD_CHAR=y
-CONFIG_MTD_BLOCK=y
-CONFIG_MTD_CFI=y
-CONFIG_MTD_CFI_ADV_OPTIONS=y
-CONFIG_MTD_CFI_INTELEXT=y
-CONFIG_BLK_DEV_RAM=y
-CONFIG_BLK_DEV_RAM_SIZE=8192
-# CONFIG_INPUT_KEYBOARD is not set
-# CONFIG_INPUT_MOUSE is not set
-# CONFIG_VGA_CONSOLE is not set
-CONFIG_SOUND=m
-CONFIG_EXT2_FS=y
-CONFIG_JFFS2_FS=y
-CONFIG_DEBUG_USER=y
diff --git a/arch/arm/configs/h7202_defconfig b/arch/arm/configs/h7202_defconfig
deleted file mode 100644
index e16d3f3..0000000
--- a/arch/arm/configs/h7202_defconfig
+++ /dev/null
@@ -1,47 +0,0 @@
-CONFIG_EXPERIMENTAL=y
-CONFIG_SYSVIPC=y
-CONFIG_LOG_BUF_SHIFT=14
-CONFIG_MODULES=y
-CONFIG_ARCH_H720X=y
-CONFIG_ARCH_H7202=y
-# CONFIG_ARM_THUMB is not set
-CONFIG_ZBOOT_ROM_TEXT=0x0
-CONFIG_ZBOOT_ROM_BSS=0x0
-CONFIG_CMDLINE="console=ttyS0,19200"
-CONFIG_FPE_NWFPE=y
-CONFIG_FPE_NWFPE_XP=y
-CONFIG_NET=y
-CONFIG_UNIX=y
-CONFIG_INET=y
-CONFIG_IP_PNP=y
-CONFIG_IP_PNP_BOOTP=y
-# CONFIG_IPV6 is not set
-CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
-CONFIG_MTD_CMDLINE_PARTS=y
-CONFIG_MTD_CHAR=y
-CONFIG_MTD_BLOCK=y
-CONFIG_MTD_CFI=y
-CONFIG_MTD_CFI_INTELEXT=y
-CONFIG_MTD_H720X=y
-CONFIG_NETDEVICES=y
-CONFIG_NET_ETHERNET=y
-CONFIG_SERIAL_8250=y
-CONFIG_SERIAL_8250_CONSOLE=y
-CONFIG_FB=y
-CONFIG_FB_MODE_HELPERS=y
-# CONFIG_VGA_CONSOLE is not set
-CONFIG_USB_GADGET=m
-CONFIG_USB_ZERO=m
-CONFIG_USB_GADGETFS=m
-CONFIG_USB_MASS_STORAGE=m
-CONFIG_USB_G_SERIAL=m
-CONFIG_EXT2_FS=y
-CONFIG_TMPFS=y
-CONFIG_JFFS2_FS=y
-CONFIG_NFS_FS=y
-CONFIG_NFS_V3=y
-CONFIG_MAGIC_SYSRQ=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_DEBUG_INFO=y
-CONFIG_DEBUG_USER=y
diff --git a/arch/arm/mach-h720x/Kconfig b/arch/arm/mach-h720x/Kconfig
deleted file mode 100644
index 6bb755b..0000000
--- a/arch/arm/mach-h720x/Kconfig
+++ /dev/null
@@ -1,40 +0,0 @@
-if ARCH_H720X
-
-menu "h720x Implementations"
-
-config ARCH_H7201
-	bool "gms30c7201"
-	depends on ARCH_H720X
-	select CPU_H7201
-	select ZONE_DMA
-	help
-	  Say Y here if you are using the Hynix GMS30C7201 Reference Board
-
-config ARCH_H7202
-	bool "hms30c7202"
-	depends on ARCH_H720X
-	select CPU_H7202
-	select ZONE_DMA
-	help
-	  Say Y here if you are using the Hynix HMS30C7202 Reference Board
-
-endmenu
-
-config CPU_H7201
-	bool
-	help
-	  Select code specific to h7201 variants
-
-config CPU_H7202
-	bool
-	help
-	  Select code specific to h7202 variants
-config H7202_SERIAL23
-	depends on CPU_H7202
-	bool "Use serial ports 2+3"
-	help
-	  Say Y here if you wish to use serial ports 2+3. They share their
-	  pins with the keyboard matrix controller, so you have to decide.
-
-
-endif
diff --git a/arch/arm/mach-h720x/Makefile b/arch/arm/mach-h720x/Makefile
deleted file mode 100644
index e4cf728..0000000
--- a/arch/arm/mach-h720x/Makefile
+++ /dev/null
@@ -1,16 +0,0 @@
-#
-# Makefile for the linux kernel.
-#
-
-# Common support
-obj-y := common.o
-obj-m :=
-obj-n :=
-obj-  :=
-
-# Specific board support
-
-obj-$(CONFIG_ARCH_H7201)		+= h7201-eval.o
-obj-$(CONFIG_ARCH_H7202)		+= h7202-eval.o
-obj-$(CONFIG_CPU_H7201) 		+= cpu-h7201.o
-obj-$(CONFIG_CPU_H7202) 		+= cpu-h7202.o
diff --git a/arch/arm/mach-h720x/Makefile.boot b/arch/arm/mach-h720x/Makefile.boot
deleted file mode 100644
index d875a70..0000000
--- a/arch/arm/mach-h720x/Makefile.boot
+++ /dev/null
@@ -1,2 +0,0 @@
-   zreladdr-$(CONFIG_ARCH_H720X)	+= 0x40008000
-
diff --git a/arch/arm/mach-h720x/common.c b/arch/arm/mach-h720x/common.c
deleted file mode 100644
index 17ef91f..0000000
--- a/arch/arm/mach-h720x/common.c
+++ /dev/null
@@ -1,268 +0,0 @@
-/*
- * linux/arch/arm/mach-h720x/common.c
- *
- * Copyright (C) 2003 Thomas Gleixner <tglx@linutronix.de>
- *               2003 Robert Schwebel <r.schwebel@pengutronix.de>
- *               2004 Sascha Hauer    <s.hauer@pengutronix.de>
- *
- * common stuff for Hynix h720x processors
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-
-#include <linux/sched.h>
-#include <linux/mman.h>
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <linux/io.h>
-
-#include <asm/page.h>
-#include <asm/pgtable.h>
-#include <asm/dma.h>
-#include <mach/hardware.h>
-#include <asm/irq.h>
-#include <asm/system_misc.h>
-#include <asm/mach/irq.h>
-#include <asm/mach/map.h>
-#include <mach/irqs.h>
-
-#include <asm/mach/dma.h>
-
-#if 0
-#define IRQDBG(args...) printk(args)
-#else
-#define IRQDBG(args...) do {} while(0)
-#endif
-
-void __init arch_dma_init(dma_t *dma)
-{
-}
-
-/*
- * Return nsecs since last timer reload
- * (timercount * (usecs perjiffie)) / (ticks per jiffie)
- */
-u32 h720x_gettimeoffset(void)
-{
-	return ((CPU_REG(TIMER_VIRT, TM0_COUNT) * tick_usec) / LATCH) * 1000;
-}
-
-/*
- * mask Global irq's
- */
-static void mask_global_irq(struct irq_data *d)
-{
-	CPU_REG (IRQC_VIRT, IRQC_IER) &= ~(1 << d->irq);
-}
-
-/*
- * unmask Global irq's
- */
-static void unmask_global_irq(struct irq_data *d)
-{
-	CPU_REG (IRQC_VIRT, IRQC_IER) |= (1 << d->irq);
-}
-
-
-/*
- * ack GPIO irq's
- * Ack only for edge triggered int's valid
- */
-static void inline ack_gpio_irq(struct irq_data *d)
-{
-	u32 reg_base = GPIO_VIRT(IRQ_TO_REGNO(d->irq));
-	u32 bit = IRQ_TO_BIT(d->irq);
-	if ( (CPU_REG (reg_base, GPIO_EDGE) & bit))
-		CPU_REG (reg_base, GPIO_CLR) = bit;
-}
-
-/*
- * mask GPIO irq's
- */
-static void inline mask_gpio_irq(struct irq_data *d)
-{
-	u32 reg_base = GPIO_VIRT(IRQ_TO_REGNO(d->irq));
-	u32 bit = IRQ_TO_BIT(d->irq);
-	CPU_REG (reg_base, GPIO_MASK) &= ~bit;
-}
-
-/*
- * unmask GPIO irq's
- */
-static void inline unmask_gpio_irq(struct irq_data *d)
-{
-	u32 reg_base = GPIO_VIRT(IRQ_TO_REGNO(d->irq));
-	u32 bit = IRQ_TO_BIT(d->irq);
-	CPU_REG (reg_base, GPIO_MASK) |= bit;
-}
-
-static void
-h720x_gpio_handler(unsigned int mask, unsigned int irq,
-                 struct irq_desc *desc)
-{
-	IRQDBG("%s irq: %d\n", __func__, irq);
-	while (mask) {
-		if (mask & 1) {
-			IRQDBG("handling irq %d\n", irq);
-			generic_handle_irq(irq);
-		}
-		irq++;
-		mask >>= 1;
-	}
-}
-
-static void
-h720x_gpioa_demux_handler(unsigned int irq_unused, struct irq_desc *desc)
-{
-	unsigned int mask, irq;
-
-	mask = CPU_REG(GPIO_A_VIRT,GPIO_STAT);
-	irq = IRQ_CHAINED_GPIOA(0);
-	IRQDBG("%s mask: 0x%08x irq: %d\n", __func__, mask,irq);
-	h720x_gpio_handler(mask, irq, desc);
-}
-
-static void
-h720x_gpiob_demux_handler(unsigned int irq_unused, struct irq_desc *desc)
-{
-	unsigned int mask, irq;
-	mask = CPU_REG(GPIO_B_VIRT,GPIO_STAT);
-	irq = IRQ_CHAINED_GPIOB(0);
-	IRQDBG("%s mask: 0x%08x irq: %d\n", __func__, mask,irq);
-	h720x_gpio_handler(mask, irq, desc);
-}
-
-static void
-h720x_gpioc_demux_handler(unsigned int irq_unused, struct irq_desc *desc)
-{
-	unsigned int mask, irq;
-
-	mask = CPU_REG(GPIO_C_VIRT,GPIO_STAT);
-	irq = IRQ_CHAINED_GPIOC(0);
-	IRQDBG("%s mask: 0x%08x irq: %d\n", __func__, mask,irq);
-	h720x_gpio_handler(mask, irq, desc);
-}
-
-static void
-h720x_gpiod_demux_handler(unsigned int irq_unused, struct irq_desc *desc)
-{
-	unsigned int mask, irq;
-
-	mask = CPU_REG(GPIO_D_VIRT,GPIO_STAT);
-	irq = IRQ_CHAINED_GPIOD(0);
-	IRQDBG("%s mask: 0x%08x irq: %d\n", __func__, mask,irq);
-	h720x_gpio_handler(mask, irq, desc);
-}
-
-#ifdef CONFIG_CPU_H7202
-static void
-h720x_gpioe_demux_handler(unsigned int irq_unused, struct irq_desc *desc)
-{
-	unsigned int mask, irq;
-
-	mask = CPU_REG(GPIO_E_VIRT,GPIO_STAT);
-	irq = IRQ_CHAINED_GPIOE(0);
-	IRQDBG("%s mask: 0x%08x irq: %d\n", __func__, mask,irq);
-	h720x_gpio_handler(mask, irq, desc);
-}
-#endif
-
-static struct irq_chip h720x_global_chip = {
-	.irq_ack = mask_global_irq,
-	.irq_mask = mask_global_irq,
-	.irq_unmask = unmask_global_irq,
-};
-
-static struct irq_chip h720x_gpio_chip = {
-	.irq_ack = ack_gpio_irq,
-	.irq_mask = mask_gpio_irq,
-	.irq_unmask = unmask_gpio_irq,
-};
-
-/*
- * Initialize IRQ's, mask all, enable multiplexed irq's
- */
-void __init h720x_init_irq (void)
-{
-	int 	irq;
-
-	/* Mask global irq's */
-	CPU_REG (IRQC_VIRT, IRQC_IER) = 0x0;
-
-	/* Mask all multiplexed irq's */
-	CPU_REG (GPIO_A_VIRT, GPIO_MASK) = 0x0;
-	CPU_REG (GPIO_B_VIRT, GPIO_MASK) = 0x0;
-	CPU_REG (GPIO_C_VIRT, GPIO_MASK) = 0x0;
-	CPU_REG (GPIO_D_VIRT, GPIO_MASK) = 0x0;
-
-	/* Initialize global IRQ's, fast path */
-	for (irq = 0; irq < NR_GLBL_IRQS; irq++) {
-		irq_set_chip_and_handler(irq, &h720x_global_chip,
-					 handle_level_irq);
-		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
-	}
-
-	/* Initialize multiplexed IRQ's, slow path */
-	for (irq = IRQ_CHAINED_GPIOA(0) ; irq <= IRQ_CHAINED_GPIOD(31); irq++) {
-		irq_set_chip_and_handler(irq, &h720x_gpio_chip,
-					 handle_edge_irq);
-		set_irq_flags(irq, IRQF_VALID );
-	}
-	irq_set_chained_handler(IRQ_GPIOA, h720x_gpioa_demux_handler);
-	irq_set_chained_handler(IRQ_GPIOB, h720x_gpiob_demux_handler);
-	irq_set_chained_handler(IRQ_GPIOC, h720x_gpioc_demux_handler);
-	irq_set_chained_handler(IRQ_GPIOD, h720x_gpiod_demux_handler);
-
-#ifdef CONFIG_CPU_H7202
-	for (irq = IRQ_CHAINED_GPIOE(0) ; irq <= IRQ_CHAINED_GPIOE(31); irq++) {
-		irq_set_chip_and_handler(irq, &h720x_gpio_chip,
-					 handle_edge_irq);
-		set_irq_flags(irq, IRQF_VALID );
-	}
-	irq_set_chained_handler(IRQ_GPIOE, h720x_gpioe_demux_handler);
-#endif
-
-	/* Enable multiplexed irq's */
-	CPU_REG (IRQC_VIRT, IRQC_IER) = IRQ_ENA_MUX;
-}
-
-static struct map_desc h720x_io_desc[] __initdata = {
-	{
-		.virtual	= IO_VIRT,
-		.pfn		= __phys_to_pfn(IO_PHYS),
-		.length		= IO_SIZE,
-		.type		= MT_DEVICE
-	},
-};
-
-/* Initialize io tables */
-void __init h720x_map_io(void)
-{
-	iotable_init(h720x_io_desc,ARRAY_SIZE(h720x_io_desc));
-}
-
-void h720x_restart(char mode, const char *cmd)
-{
-	CPU_REG (PMU_BASE, PMU_STAT) |= PMU_WARMRESET;
-}
-
-static void h720x__idle(void)
-{
-	CPU_REG (PMU_BASE, PMU_MODE) = PMU_MODE_IDLE;
-	nop();
-	nop();
-	CPU_REG (PMU_BASE, PMU_MODE) = PMU_MODE_RUN;
-	nop();
-	nop();
-}
-
-static int __init h720x_idle_init(void)
-{
-	arm_pm_idle = h720x__idle;
-	return 0;
-}
-
-arch_initcall(h720x_idle_init);
diff --git a/arch/arm/mach-h720x/common.h b/arch/arm/mach-h720x/common.h
deleted file mode 100644
index 7e73841..0000000
--- a/arch/arm/mach-h720x/common.h
+++ /dev/null
@@ -1,30 +0,0 @@
-/*
- * linux/arch/arm/mach-h720x/common.h
- *
- * Copyright (C) 2003 Thomas Gleixner <tglx@linutronix.de>
- *               2003 Robert Schwebel <r.schwebel@pengutronix.de>
- *               2004 Sascha Hauer    <s.hauer@pengutronix.de>
- *
- * Architecture specific stuff for Hynix GMS30C7201 development board
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-
-extern u32 h720x_gettimeoffset(void);
-extern void __init h720x_init_irq(void);
-extern void __init h720x_map_io(void);
-extern void h720x_restart(char, const char *);
-
-#ifdef CONFIG_ARCH_H7202
-extern void h7202_timer_init(void);
-extern void __init init_hw_h7202(void);
-extern void __init h7202_init_irq(void);
-extern void __init h7202_init_time(void);
-#endif
-
-#ifdef CONFIG_ARCH_H7201
-extern void h7201_timer_init(void);
-#endif
diff --git a/arch/arm/mach-h720x/cpu-h7201.c b/arch/arm/mach-h720x/cpu-h7201.c
deleted file mode 100644
index 13c7412..0000000
--- a/arch/arm/mach-h720x/cpu-h7201.c
+++ /dev/null
@@ -1,57 +0,0 @@
-/*
- * linux/arch/arm/mach-h720x/cpu-h7201.c
- *
- * Copyright (C) 2003 Thomas Gleixner <tglx@linutronix.de>
- *               2003 Robert Schwebel <r.schwebel@pengutronix.de>
- *               2004 Sascha Hauer    <s.hauer@pengutronix.de>
- *
- * processor specific stuff for the Hynix h7201
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <linux/module.h>
-#include <asm/types.h>
-#include <mach/hardware.h>
-#include <asm/irq.h>
-#include <mach/irqs.h>
-#include <asm/mach/irq.h>
-#include <asm/mach/time.h>
-#include "common.h"
-/*
- * Timer interrupt handler
- */
-static irqreturn_t
-h7201_timer_interrupt(int irq, void *dev_id)
-{
-	CPU_REG (TIMER_VIRT, TIMER_TOPSTAT);
-	timer_tick();
-
-	return IRQ_HANDLED;
-}
-
-static struct irqaction h7201_timer_irq = {
-	.name		= "h7201 Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
-	.handler	= h7201_timer_interrupt,
-};
-
-/*
- * Setup TIMER0 as system timer
- */
-void __init h7201_timer_init(void)
-{
-	arch_gettimeoffset = h720x_gettimeoffset;
-
-	CPU_REG (TIMER_VIRT, TM0_PERIOD) = LATCH;
-	CPU_REG (TIMER_VIRT, TM0_CTRL) = TM_RESET;
-	CPU_REG (TIMER_VIRT, TM0_CTRL) = TM_REPEAT | TM_START;
-	CPU_REG (TIMER_VIRT, TIMER_TOPCTRL) = ENABLE_TM0_INTR | TIMER_ENABLE_BIT;
-
-	setup_irq(IRQ_TIMER0, &h7201_timer_irq);
-}
diff --git a/arch/arm/mach-h720x/cpu-h7202.c b/arch/arm/mach-h720x/cpu-h7202.c
deleted file mode 100644
index e2ae7e8..0000000
--- a/arch/arm/mach-h720x/cpu-h7202.c
+++ /dev/null
@@ -1,225 +0,0 @@
-/*
- * linux/arch/arm/mach-h720x/cpu-h7202.c
- *
- * Copyright (C) 2003 Thomas Gleixner <tglx@linutronix.de>
- *               2003 Robert Schwebel <r.schwebel@pengutronix.de>
- *               2004 Sascha Hauer    <s.hauer@pengutronix.de>
- *
- * processor specific stuff for the Hynix h7202
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <linux/module.h>
-#include <asm/types.h>
-#include <mach/hardware.h>
-#include <asm/irq.h>
-#include <mach/irqs.h>
-#include <asm/mach/irq.h>
-#include <asm/mach/time.h>
-#include <linux/device.h>
-#include <linux/serial_8250.h>
-#include "common.h"
-
-static struct resource h7202ps2_resources[] = {
-	[0] = {
-		.start	= 0x8002c000,
-		.end	= 0x8002c040,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= IRQ_PS2,
-		.end	= IRQ_PS2,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device h7202ps2_device = {
-	.name		= "h7202ps2",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(h7202ps2_resources),
-	.resource	= h7202ps2_resources,
-};
-
-static struct plat_serial8250_port serial_platform_data[] = {
-	{
-		.membase	= (void*)SERIAL0_VIRT,
-		.mapbase	= SERIAL0_BASE,
-		.irq		= IRQ_UART0,
-		.uartclk	= 2*1843200,
-		.regshift	= 2,
-		.iotype		= UPIO_MEM,
-		.flags		= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST,
-	},
-	{
-		.membase	= (void*)SERIAL1_VIRT,
-		.mapbase	= SERIAL1_BASE,
-		.irq		= IRQ_UART1,
-		.uartclk	= 2*1843200,
-		.regshift	= 2,
-		.iotype		= UPIO_MEM,
-		.flags		= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST,
-	},
-#ifdef CONFIG_H7202_SERIAL23
-	{
-		.membase	= (void*)SERIAL2_VIRT,
-		.mapbase	= SERIAL2_BASE,
-		.irq		= IRQ_UART2,
-		.uartclk	= 2*1843200,
-		.regshift	= 2,
-		.iotype		= UPIO_MEM,
-		.flags		= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST,
-	},
-	{
-		.membase	= (void*)SERIAL3_VIRT,
-		.mapbase	= SERIAL3_BASE,
-		.irq		= IRQ_UART3,
-		.uartclk	= 2*1843200,
-		.regshift	= 2,
-		.iotype		= UPIO_MEM,
-		.flags		= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST,
-	},
-#endif
-	{ },
-};
-
-static struct platform_device serial_device = {
-	.name			= "serial8250",
-	.id			= PLAT8250_DEV_PLATFORM,
-	.dev			= {
-		.platform_data	= serial_platform_data,
-	},
-};
-
-static struct platform_device *devices[] __initdata = {
-	&h7202ps2_device,
-	&serial_device,
-};
-
-/* Although we have two interrupt lines for the timers, we only have one
- * status register which clears all pending timer interrupts on reading. So
- * we have to handle all timer interrupts in one place.
- */
-static void
-h7202_timerx_demux_handler(unsigned int irq_unused, struct irq_desc *desc)
-{
-	unsigned int mask, irq;
-
-	mask = CPU_REG (TIMER_VIRT, TIMER_TOPSTAT);
-
-	if ( mask & TSTAT_T0INT ) {
-		timer_tick();
-		if( mask == TSTAT_T0INT )
-			return;
-	}
-
-	mask >>= 1;
-	irq = IRQ_TIMER1;
-	while (mask) {
-		if (mask & 1)
-			generic_handle_irq(irq);
-		irq++;
-		mask >>= 1;
-	}
-}
-
-/*
- * Timer interrupt handler
- */
-static irqreturn_t
-h7202_timer_interrupt(int irq, void *dev_id)
-{
-	h7202_timerx_demux_handler(0, NULL);
-	return IRQ_HANDLED;
-}
-
-/*
- * mask multiplexed timer IRQs
- */
-static void inline __mask_timerx_irq(unsigned int irq)
-{
-	unsigned int bit;
-	bit = 2 << ((irq == IRQ_TIMER64B) ? 4 : (irq - IRQ_TIMER1));
-	CPU_REG (TIMER_VIRT, TIMER_TOPCTRL) &= ~bit;
-}
-
-static void inline mask_timerx_irq(struct irq_data *d)
-{
-	__mask_timerx_irq(d->irq);
-}
-
-/*
- * unmask multiplexed timer IRQs
- */
-static void inline unmask_timerx_irq(struct irq_data *d)
-{
-	unsigned int bit;
-	bit = 2 << ((d->irq == IRQ_TIMER64B) ? 4 : (d->irq - IRQ_TIMER1));
-	CPU_REG (TIMER_VIRT, TIMER_TOPCTRL) |= bit;
-}
-
-static struct irq_chip h7202_timerx_chip = {
-	.irq_ack = mask_timerx_irq,
-	.irq_mask = mask_timerx_irq,
-	.irq_unmask = unmask_timerx_irq,
-};
-
-static struct irqaction h7202_timer_irq = {
-	.name		= "h7202 Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
-	.handler	= h7202_timer_interrupt,
-};
-
-/*
- * Setup TIMER0 as system timer
- */
-void __init h7202_timer_init(void)
-{
-	arch_gettimeoffset = h720x_gettimeoffset;
-
-	CPU_REG (TIMER_VIRT, TM0_PERIOD) = LATCH;
-	CPU_REG (TIMER_VIRT, TM0_CTRL) = TM_RESET;
-	CPU_REG (TIMER_VIRT, TM0_CTRL) = TM_REPEAT | TM_START;
-	CPU_REG (TIMER_VIRT, TIMER_TOPCTRL) = ENABLE_TM0_INTR | TIMER_ENABLE_BIT;
-
-	setup_irq(IRQ_TIMER0, &h7202_timer_irq);
-}
-
-void __init h7202_init_irq (void)
-{
-	int 	irq;
-
-	CPU_REG (GPIO_E_VIRT, GPIO_MASK) = 0x0;
-
-	for (irq = IRQ_TIMER1;
-	                  irq < IRQ_CHAINED_TIMERX(NR_TIMERX_IRQS); irq++) {
-		__mask_timerx_irq(irq);
-		irq_set_chip_and_handler(irq, &h7202_timerx_chip,
-					 handle_edge_irq);
-		set_irq_flags(irq, IRQF_VALID );
-	}
-	irq_set_chained_handler(IRQ_TIMERX, h7202_timerx_demux_handler);
-
-	h720x_init_irq();
-}
-
-void __init init_hw_h7202(void)
-{
-	/* Enable clocks */
-	CPU_REG (PMU_BASE, PMU_PLL_CTRL) |= PLL_2_EN | PLL_1_EN | PLL_3_MUTE;
-
-	CPU_REG (SERIAL0_VIRT, SERIAL_ENABLE) = SERIAL_ENABLE_EN;
-	CPU_REG (SERIAL1_VIRT, SERIAL_ENABLE) = SERIAL_ENABLE_EN;
-#ifdef CONFIG_H7202_SERIAL23
-	CPU_REG (SERIAL2_VIRT, SERIAL_ENABLE) = SERIAL_ENABLE_EN;
-	CPU_REG (SERIAL3_VIRT, SERIAL_ENABLE) = SERIAL_ENABLE_EN;
-	CPU_IO (GPIO_AMULSEL) = AMULSEL_USIN2 | AMULSEL_USOUT2 |
-	                        AMULSEL_USIN3 | AMULSEL_USOUT3;
-#endif
-	(void) platform_add_devices(devices, ARRAY_SIZE(devices));
-}
diff --git a/arch/arm/mach-h720x/h7201-eval.c b/arch/arm/mach-h720x/h7201-eval.c
deleted file mode 100644
index 4fdeb68..0000000
--- a/arch/arm/mach-h720x/h7201-eval.c
+++ /dev/null
@@ -1,38 +0,0 @@
-/*
- * linux/arch/arm/mach-h720x/h7201-eval.c
- *
- * Copyright (C) 2003 Thomas Gleixner <tglx@linutronix.de>
- *               2003 Robert Schwebel <r.schwebel@pengutronix.de>
- *               2004 Sascha Hauer    <s.hauer@pengutronix.de>
- *
- * Architecture specific stuff for Hynix GMS30C7201 development board
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/string.h>
-#include <linux/device.h>
-
-#include <asm/setup.h>
-#include <asm/types.h>
-#include <asm/mach-types.h>
-#include <asm/page.h>
-#include <asm/mach/arch.h>
-#include <mach/hardware.h>
-#include "common.h"
-
-MACHINE_START(H7201, "Hynix GMS30C7201")
-	/* Maintainer: Robert Schwebel, Pengutronix */
-	.atag_offset	= 0x1000,
-	.map_io		= h720x_map_io,
-	.init_irq	= h720x_init_irq,
-	.init_time	= h7201_timer_init,
-	.dma_zone_size	= SZ_256M,
-	.restart	= h720x_restart,
-MACHINE_END
diff --git a/arch/arm/mach-h720x/h7202-eval.c b/arch/arm/mach-h720x/h7202-eval.c
deleted file mode 100644
index f68e967..0000000
--- a/arch/arm/mach-h720x/h7202-eval.c
+++ /dev/null
@@ -1,81 +0,0 @@
-/*
- * linux/arch/arm/mach-h720x/h7202-eval.c
- *
- * Copyright (C) 2003 Thomas Gleixner <tglx@linutronix.de>
- *               2003 Robert Schwebel <r.schwebel@pengutronix.de>
- *		 2004 Sascha Hauer <s.hauer@pengutronix.de>
- *
- * Architecture specific stuff for Hynix HMS30C7202 development board
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/string.h>
-#include <linux/platform_device.h>
-
-#include <asm/setup.h>
-#include <asm/types.h>
-#include <asm/mach-types.h>
-#include <asm/page.h>
-#include <asm/mach/arch.h>
-#include <mach/irqs.h>
-#include <mach/hardware.h>
-#include "common.h"
-
-static struct resource cirrus_resources[] = {
-	[0] = {
-		.start	= ETH0_PHYS + 0x300,
-		.end	= ETH0_PHYS + 0x300 + 0x10,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= IRQ_CHAINED_GPIOB(8),
-		.end	= IRQ_CHAINED_GPIOB(8),
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device cirrus_device = {
-	.name		= "cirrus-cs89x0",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(cirrus_resources),
-	.resource	= cirrus_resources,
-};
-
-static struct platform_device *devices[] __initdata = {
-	&cirrus_device,
-};
-
-/*
- * Hardware init. This is called early in initcalls
- * Place pin inits here. So you avoid adding ugly
- * #ifdef stuff to common drivers.
- * Use this only, if your bootloader is not able
- * to initialize the pins proper.
- */
-static void __init init_eval_h7202(void)
-{
-	init_hw_h7202();
-	(void) platform_add_devices(devices, ARRAY_SIZE(devices));
-
-	/* Enable interrupt on portb bit 8 (ethernet) */
-	CPU_REG (GPIO_B_VIRT, GPIO_POL) &= ~(1 << 8);
-	CPU_REG (GPIO_B_VIRT, GPIO_EN) |= (1 << 8);
-}
-
-MACHINE_START(H7202, "Hynix HMS30C7202")
-	/* Maintainer: Robert Schwebel, Pengutronix */
-	.atag_offset	= 0x100,
-	.map_io		= h720x_map_io,
-	.init_irq	= h7202_init_irq,
-	.init_time	= h7202_timer_init,
-	.init_machine	= init_eval_h7202,
-	.dma_zone_size	= SZ_256M,
-	.restart	= h720x_restart,
-MACHINE_END
diff --git a/arch/arm/mach-h720x/include/mach/boards.h b/arch/arm/mach-h720x/include/mach/boards.h
deleted file mode 100644
index 38b8e0d..0000000
--- a/arch/arm/mach-h720x/include/mach/boards.h
+++ /dev/null
@@ -1,53 +0,0 @@
-/*
- * arch/arm/mach-h720x/include/mach/boards.h
- *
- * Copyright (C) 2003 Thomas Gleixner <tglx@linutronix.de>
- *           (C) 2003 Robert Schwebel <r.schwebel@pengutronix.de>
- *
- * This file contains the board specific defines for various devices
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef __ASM_ARCH_HARDWARE_INCMACH_H
-#error Do not include this file directly. Include asm/hardware.h instead !
-#endif
-
-/* Hynix H7202 developer board specific device defines */
-#ifdef CONFIG_ARCH_H7202
-
-/* FLASH */
-#define H720X_FLASH_VIRT	0xd0000000
-#define H720X_FLASH_PHYS	0x00000000
-#define H720X_FLASH_SIZE	0x02000000
-
-/* onboard LAN controller */
-# define ETH0_PHYS		0x08000000
-
-/* Touch screen defines */
-/* GPIO Port */
-#define PEN_GPIO		GPIO_B_VIRT
-/* Bitmask for pen down interrupt */
-#define PEN_INT_BIT		(1<<7)
-/* Bitmask for pen up interrupt */
-#define PEN_ENA_BIT		(1<<6)
-/* pen up interrupt */
-#define IRQ_PEN			IRQ_MUX_GPIOB(7)
-
-#endif
-
-/* Hynix H7201 developer board specific device defines */
-#if defined (CONFIG_ARCH_H7201)
-/* ROM DISK SPACE */
-#define ROM_DISK_BASE           0xc1800000
-#define ROM_DISK_START          0x41800000
-#define ROM_DISK_SIZE           0x00700000
-
-/* SRAM DISK SPACE */
-#define SRAM_DISK_BASE          0xf1000000
-#define SRAM_DISK_START         0x04000000
-#define SRAM_DISK_SIZE          0x00400000
-#endif
-
diff --git a/arch/arm/mach-h720x/include/mach/debug-macro.S b/arch/arm/mach-h720x/include/mach/debug-macro.S
deleted file mode 100644
index 8a46157..0000000
--- a/arch/arm/mach-h720x/include/mach/debug-macro.S
+++ /dev/null
@@ -1,40 +0,0 @@
-/* arch/arm/mach-h720x/include/mach/debug-macro.S
- *
- * Debugging macro include header
- *
- *  Copyright (C) 1994-1999 Russell King
- *  Moved from linux/arch/arm/kernel/debug.S by Ben Dooks
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
-*/
-
-#include <mach/hardware.h>
-
-		.equ    io_virt, IO_VIRT
-		.equ    io_phys, IO_PHYS
-
-		.macro  addruart, rp, rv, tmp
-		mov     \rp, #0x00020000	@ UART1
-		add     \rv, \rp, #io_virt	@ virtual address
-		add     \rp, \rp, #io_phys	@ physical base address
-		.endm
-
-		.macro  senduart,rd,rx
-		str     \rd, [\rx, #0x0]        @ UARTDR
-
-		.endm
-
-		.macro  waituart,rd,rx
-1001:		ldr     \rd, [\rx, #0x18]       @ UARTFLG
-		tst     \rd, #1 << 5	       @ UARTFLGUTXFF - 1 when full
-		bne     1001b
-		.endm
-
-		.macro  busyuart,rd,rx
-1001:		ldr     \rd, [\rx, #0x18]       @ UARTFLG
-		tst     \rd, #1 << 3	       @ UARTFLGUBUSY - 1 when busy
-		bne     1001b
-		.endm
diff --git a/arch/arm/mach-h720x/include/mach/entry-macro.S b/arch/arm/mach-h720x/include/mach/entry-macro.S
deleted file mode 100644
index 75267fa..0000000
--- a/arch/arm/mach-h720x/include/mach/entry-macro.S
+++ /dev/null
@@ -1,57 +0,0 @@
-/*
- * arch/arm/mach-h720x/include/mach/entry-macro.S
- *
- * Low-level IRQ helper macros for Hynix HMS720x based platforms
- *
- * This file is licensed under  the terms of the GNU General Public
- * License version 2. This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
- */
-
-		.macro  get_irqnr_preamble, base, tmp
-		.endm
-
-		.macro  get_irqnr_and_base, irqnr, irqstat, base, tmp
-#if defined (CONFIG_CPU_H7201) || defined (CONFIG_CPU_H7202)
-		@ we could use the id register on H7202, but this is not
-		@ properly updated when we come back from asm_do_irq
-		@ without a previous return from interrupt
-		@ (see loops below in irq_svc, irq_usr)
-		@ We see unmasked pending ints only, as the masked pending ints
-		@ are not visible here
-
-		mov     \base, #0xf0000000	       @ base register
-		orr     \base, \base, #0x24000	       @ irqbase
-		ldr     \irqstat, [\base, #0x04]        @ get interrupt status
-#if defined (CONFIG_CPU_H7201)
-		ldr	\tmp, =0x001fffff
-#else
-		mvn     \tmp, #0xc0000000
-#endif
-		and     \irqstat, \irqstat, \tmp        @ mask out unused ints
-		mov     \irqnr, #0
-
-		mov     \tmp, #0xff00
-		orr     \tmp, \tmp, #0xff
-		tst     \irqstat, \tmp
-		addeq   \irqnr, \irqnr, #16
-		moveq   \irqstat, \irqstat, lsr #16
-		tst     \irqstat, #255
-		addeq   \irqnr, \irqnr, #8
-		moveq   \irqstat, \irqstat, lsr #8
-		tst     \irqstat, #15
-		addeq   \irqnr, \irqnr, #4
-		moveq   \irqstat, \irqstat, lsr #4
-		tst     \irqstat, #3
-		addeq   \irqnr, \irqnr, #2
-		moveq   \irqstat, \irqstat, lsr #2
-		tst     \irqstat, #1
-		addeq   \irqnr, \irqnr, #1
-		moveq   \irqstat, \irqstat, lsr #1
-		tst     \irqstat, #1		       @ bit 0 should be set
-		.endm
-
-#else
-#error hynix processor selection missmatch
-#endif
-
diff --git a/arch/arm/mach-h720x/include/mach/h7201-regs.h b/arch/arm/mach-h720x/include/mach/h7201-regs.h
deleted file mode 100644
index 611b494..0000000
--- a/arch/arm/mach-h720x/include/mach/h7201-regs.h
+++ /dev/null
@@ -1,67 +0,0 @@
-/*
- * arch/arm/mach-h720x/include/mach/h7201-regs.h
- *
- * Copyright (C) 2000 Jungjun Kim, Hynix Semiconductor Inc.
- *           (C) 2003 Thomas Gleixner <tglx@linutronix.de>
- *           (C) 2003 Robert Schwebel <r.schwebel@pengutronix.de>
- *           (C) 2004 Sascha Hauer    <s.hauer@pengutronix.de>
- *
- * This file contains the hardware definitions of the h720x processors
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Do not add implementations specific defines here. This files contains
- * only defines of the onchip peripherals. Add those defines to boards.h,
- * which is included by this file.
- */
-
-#define SERIAL2_VIRT 		(IO_VIRT + 0x50100)
-#define SERIAL3_VIRT 		(IO_VIRT + 0x50200)
-
-/*
- * PCMCIA
- */
-#define PCMCIA0_ATT_BASE        0xe5000000
-#define PCMCIA0_ATT_SIZE        0x00200000
-#define PCMCIA0_ATT_START       0x20000000
-#define PCMCIA0_MEM_BASE        0xe5200000
-#define PCMCIA0_MEM_SIZE        0x00200000
-#define PCMCIA0_MEM_START       0x24000000
-#define PCMCIA0_IO_BASE         0xe5400000
-#define PCMCIA0_IO_SIZE         0x00200000
-#define PCMCIA0_IO_START        0x28000000
-
-#define PCMCIA1_ATT_BASE        0xe5600000
-#define PCMCIA1_ATT_SIZE        0x00200000
-#define PCMCIA1_ATT_START       0x30000000
-#define PCMCIA1_MEM_BASE        0xe5800000
-#define PCMCIA1_MEM_SIZE        0x00200000
-#define PCMCIA1_MEM_START       0x34000000
-#define PCMCIA1_IO_BASE         0xe5a00000
-#define PCMCIA1_IO_SIZE         0x00200000
-#define PCMCIA1_IO_START        0x38000000
-
-#define PRIME3C_BASE            0xf0050000
-#define PRIME3C_SIZE            0x00001000
-#define PRIME3C_START           0x10000000
-
-/* VGA Controller */
-#define VGA_RAMBASE 		0x50
-#define VGA_TIMING0 		0x60
-#define VGA_TIMING1 		0x64
-#define VGA_TIMING2 		0x68
-#define VGA_TIMING3 		0x6c
-
-#define LCD_CTRL_VGA_ENABLE   	0x00000100
-#define LCD_CTRL_VGA_BPP_MASK 	0x00000600
-#define LCD_CTRL_VGA_4BPP    	0x00000000
-#define LCD_CTRL_VGA_8BPP    	0x00000200
-#define LCD_CTRL_VGA_16BPP   	0x00000300
-#define LCD_CTRL_SHARE_DMA    	0x00000800
-#define LCD_CTRL_VDE          	0x00100000
-#define LCD_CTRL_LPE          	0x00400000	/* LCD Power enable */
-#define LCD_CTRL_BLE          	0x00800000	/* LCD backlight enable */
-
-#define VGA_PALETTE_BASE	(IO_VIRT + 0x10800)
diff --git a/arch/arm/mach-h720x/include/mach/h7202-regs.h b/arch/arm/mach-h720x/include/mach/h7202-regs.h
deleted file mode 100644
index 17c12eb..0000000
--- a/arch/arm/mach-h720x/include/mach/h7202-regs.h
+++ /dev/null
@@ -1,155 +0,0 @@
-/*
- * arch/arm/mach-h720x/include/mach/h7202-regs.h
- *
- * Copyright (C) 2000 Jungjun Kim, Hynix Semiconductor Inc.
- *           (C) 2003 Thomas Gleixner <tglx@linutronix.de>
- *           (C) 2003 Robert Schwebel <r.schwebel@pengutronix.de>
- *           (C) 2004 Sascha Hauer    <s.hauer@pengutronix.de>
- *
- * This file contains the hardware definitions of the h720x processors
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Do not add implementations specific defines here. This files contains
- * only defines of the onchip peripherals. Add those defines to boards.h,
- * which is included by this file.
- */
-
-#define SERIAL2_OFS		0x2d000
-#define SERIAL2_BASE		(IO_PHYS + SERIAL2_OFS)
-#define SERIAL2_VIRT 		(IO_VIRT + SERIAL2_OFS)
-#define SERIAL3_OFS		0x2e000
-#define SERIAL3_BASE		(IO_PHYS + SERIAL3_OFS)
-#define SERIAL3_VIRT 		(IO_VIRT + SERIAL3_OFS)
-
-/* Matrix Keyboard Controller */
-#define KBD_VIRT		(IO_VIRT + 0x22000)
-#define KBD_KBCR		0x00
-#define KBD_KBSC		0x04
-#define KBD_KBTR		0x08
-#define KBD_KBVR0		0x0C
-#define KBD_KBVR1		0x10
-#define KBD_KBSR		0x18
-
-#define KBD_KBCR_SCANENABLE	(1 << 7)
-#define KBD_KBCR_NPOWERDOWN	(1 << 2)
-#define KBD_KBCR_CLKSEL_MASK	(3)
-#define KBD_KBCR_CLKSEL_PCLK2	0x0
-#define KBD_KBCR_CLKSEL_PCLK128	0x1
-#define KBD_KBCR_CLKSEL_PCLK256	0x2
-#define KBD_KBCR_CLKSEL_PCLK512	0x3
-
-#define KBD_KBSR_INTR		(1 << 0)
-#define KBD_KBSR_WAKEUP		(1 << 1)
-
-/* USB device controller */
-
-#define USBD_BASE		(IO_VIRT + 0x12000)
-#define USBD_LENGTH		0x3C
-
-#define USBD_GCTRL		0x00
-#define USBD_EPCTRL		0x04
-#define USBD_INTMASK		0x08
-#define USBD_INTSTAT		0x0C
-#define USBD_PWR		0x10
-#define USBD_DMARXTX		0x14
-#define USBD_DEVID		0x18
-#define USBD_DEVCLASS		0x1C
-#define USBD_INTCLASS		0x20
-#define USBD_SETUP0		0x24
-#define USBD_SETUP1		0x28
-#define USBD_ENDP0RD		0x2C
-#define USBD_ENDP0WT		0x30
-#define USBD_ENDP1RD		0x34
-#define USBD_ENDP2WT		0x38
-
-/* PS/2 port */
-#define PSDATA 0x00
-#define PSSTAT 0x04
-#define PSSTAT_TXEMPTY (1<<0)
-#define PSSTAT_TXBUSY (1<<1)
-#define PSSTAT_RXFULL (1<<2)
-#define PSSTAT_RXBUSY (1<<3)
-#define PSSTAT_CLKIN (1<<4)
-#define PSSTAT_DATAIN (1<<5)
-#define PSSTAT_PARITY (1<<6)
-
-#define PSCONF 0x08
-#define PSCONF_ENABLE (1<<0)
-#define PSCONF_TXINTEN (1<<2)
-#define PSCONF_RXINTEN (1<<3)
-#define PSCONF_FORCECLKLOW (1<<4)
-#define PSCONF_FORCEDATLOW (1<<5)
-#define PSCONF_LCE (1<<6)
-
-#define PSINTR 0x0C
-#define PSINTR_TXINT (1<<0)
-#define PSINTR_RXINT (1<<1)
-#define PSINTR_PAR (1<<2)
-#define PSINTR_RXTO (1<<3)
-#define PSINTR_TXTO (1<<4)
-
-#define PSTDLO 0x10 /* clk low before start transmission */
-#define PSTPRI 0x14 /* PRI clock */
-#define PSTXMT 0x18 /* maximum transmission time */
-#define PSTREC 0x20 /* maximum receive time */
-#define PSPWDN 0x3c
-
-/* ADC converter */
-#define ADC_BASE 		(IO_VIRT + 0x29000)
-#define ADC_CR 			0x00
-#define ADC_TSCTRL 		0x04
-#define ADC_BT_CTRL 		0x08
-#define ADC_MC_CTRL		0x0C
-#define ADC_STATUS		0x10
-
-/* ADC control register bits */
-#define ADC_CR_PW_CTRL 		0x80
-#define ADC_CR_DIRECTC		0x04
-#define ADC_CR_CONTIME_NO	0x00
-#define ADC_CR_CONTIME_2	0x04
-#define ADC_CR_CONTIME_4	0x08
-#define ADC_CR_CONTIME_ADE	0x0c
-#define ADC_CR_LONGCALTIME	0x01
-
-/* ADC touch panel register bits */
-#define ADC_TSCTRL_ENABLE 	0x80
-#define ADC_TSCTRL_INTR   	0x40
-#define	ADC_TSCTRL_SWBYPSS	0x20
-#define ADC_TSCTRL_SWINVT	0x10
-#define ADC_TSCTRL_S400   	0x03
-#define ADC_TSCTRL_S200   	0x02
-#define ADC_TSCTRL_S100   	0x01
-#define ADC_TSCTRL_S50    	0x00
-
-/* ADC Interrupt Status Register bits */
-#define ADC_STATUS_TS_BIT	0x80
-#define ADC_STATUS_MBT_BIT	0x40
-#define ADC_STATUS_BBT_BIT	0x20
-#define ADC_STATUS_MIC_BIT	0x10
-
-/* Touch data registers */
-#define ADC_TS_X0X1  		0x30
-#define ADC_TS_X2X3		0x34
-#define ADC_TS_Y0Y1		0x38
-#define ADC_TS_Y2Y3  		0x3c
-#define ADC_TS_X4X5  		0x40
-#define ADC_TS_X6X7  		0x44
-#define ADC_TS_Y4Y5		0x48
-#define ADC_TS_Y6Y7		0x50
-
-/* battery data */
-#define ADC_MB_DATA		0x54
-#define ADC_BB_DATA		0x58
-
-/* Sound data register */
-#define ADC_SD_DAT0 		0x60
-#define ADC_SD_DAT1		0x64
-#define ADC_SD_DAT2		0x68
-#define ADC_SD_DAT3		0x6c
-#define ADC_SD_DAT4		0x70
-#define ADC_SD_DAT5		0x74
-#define ADC_SD_DAT6		0x78
-#define ADC_SD_DAT7		0x7c
diff --git a/arch/arm/mach-h720x/include/mach/hardware.h b/arch/arm/mach-h720x/include/mach/hardware.h
deleted file mode 100644
index c55a52c..0000000
--- a/arch/arm/mach-h720x/include/mach/hardware.h
+++ /dev/null
@@ -1,190 +0,0 @@
-/*
- * arch/arm/mach-h720x/include/mach/hardware.h
- *
- * Copyright (C) 2000 Jungjun Kim, Hynix Semiconductor Inc.
- *           (C) 2003 Thomas Gleixner <tglx@linutronix.de>
- *           (C) 2003 Robert Schwebel <r.schwebel@pengutronix.de>
- *
- * This file contains the hardware definitions of the h720x processors
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Do not add implementations specific defines here. This files contains
- * only defines of the onchip peripherals. Add those defines to boards.h,
- * which is included by this file.
- */
-
-#ifndef __ASM_ARCH_HARDWARE_H
-#define __ASM_ARCH_HARDWARE_H
-
-#define IOCLK (3686400L)
-
-/* Onchip peripherals */
-
-#define IO_VIRT			0xf0000000	/* IO peripherals */
-#define IO_PHYS			0x80000000
-#define IO_SIZE			0x00050000
-
-#ifdef CONFIG_CPU_H7202
-#include "h7202-regs.h"
-#elif defined CONFIG_CPU_H7201
-#include "h7201-regs.h"
-#else
-#error machine definition mismatch
-#endif
-
-/* Macro to access the CPU IO */
-#define CPU_IO(x) (*(volatile u32*)(x))
-
-/* Macro to access general purpose regs (base, offset) */
-#define CPU_REG(x,y) CPU_IO(x+y)
-
-/* Macro to access irq related regs */
-#define IRQ_REG(x) CPU_REG(IRQC_VIRT,x)
-
-/* CPU registers */
-/* general purpose I/O */
-#define GPIO_VIRT(x)		(IO_VIRT + 0x23000 + ((x)<<5))
-#define GPIO_A_VIRT		(GPIO_VIRT(0))
-#define GPIO_B_VIRT		(GPIO_VIRT(1))
-#define GPIO_C_VIRT		(GPIO_VIRT(2))
-#define GPIO_D_VIRT		(GPIO_VIRT(3))
-#define GPIO_E_VIRT		(GPIO_VIRT(4))
-#define GPIO_AMULSEL		(GPIO_VIRT(0) + 0xA4)
-
-#define AMULSEL_USIN2	(1<<5)
-#define AMULSEL_USOUT2	(1<<6)
-#define AMULSEL_USIN3	(1<<13)
-#define AMULSEL_USOUT3	(1<<14)
-#define AMULSEL_IRDIN	(1<<15)
-#define AMULSEL_IRDOUT	(1<<7)
-
-/* Register offsets general purpose I/O */
-#define GPIO_DATA		0x00
-#define GPIO_DIR		0x04
-#define GPIO_MASK		0x08
-#define GPIO_STAT		0x0C
-#define GPIO_EDGE		0x10
-#define GPIO_CLR		0x14
-#define GPIO_POL		0x18
-#define GPIO_EN			0x1C
-
-/*interrupt controller */
-#define IRQC_VIRT		(IO_VIRT + 0x24000)
-/* register offset interrupt controller */
-#define IRQC_IER		0x00
-#define IRQC_ISR		0x04
-
-/* timer unit */
-#define TIMER_VIRT		(IO_VIRT + 0x25000)
-/* Register offsets timer unit */
-#define TM0_PERIOD   		0x00
-#define TM0_COUNT    		0x08
-#define TM0_CTRL     		0x10
-#define TM1_PERIOD   		0x20
-#define TM1_COUNT    		0x28
-#define TM1_CTRL     		0x30
-#define TM2_PERIOD   		0x40
-#define TM2_COUNT    		0x48
-#define TM2_CTRL     		0x50
-#define TIMER_TOPCTRL		0x60
-#define TIMER_TOPSTAT		0x64
-#define T64_COUNTL		0x80
-#define T64_COUNTH		0x84
-#define T64_CTRL		0x88
-#define T64_BASEL		0x94
-#define T64_BASEH		0x98
-/* Bitmaks timer unit TOPSTAT reg */
-#define TSTAT_T0INT		0x1
-#define TSTAT_T1INT		0x2
-#define TSTAT_T2INT		0x4
-#define TSTAT_T3INT		0x8
-/* Bit description of TMx_CTRL register */
-#define TM_START  		0x1
-#define TM_REPEAT 		0x2
-#define TM_RESET  		0x4
-/* Bit description of TIMER_CTRL register */
-#define ENABLE_TM0_INTR  	0x1
-#define ENABLE_TM1_INTR  	0x2
-#define ENABLE_TM2_INTR  	0x4
-#define TIMER_ENABLE_BIT 	0x8
-#define ENABLE_TIMER64   	0x10
-#define ENABLE_TIMER64_INT	0x20
-
-/* PMU & PLL */
-#define PMU_BASE 		(IO_VIRT + 0x1000)
-#define PMU_MODE		0x00
-#define PMU_STAT   		0x20
-#define PMU_PLL_CTRL 		0x28
-
-/* PMU Mode bits */
-#define PMU_MODE_SLOW		0x00
-#define PMU_MODE_RUN		0x01
-#define PMU_MODE_IDLE		0x02
-#define PMU_MODE_SLEEP		0x03
-#define PMU_MODE_INIT		0x04
-#define PMU_MODE_DEEPSLEEP	0x07
-#define PMU_MODE_WAKEUP		0x08
-
-/* PMU ... */
-#define PLL_2_EN		0x8000
-#define PLL_1_EN		0x4000
-#define PLL_3_MUTE		0x0080
-
-/* Control bits for PMU/ PLL */
-#define PMU_WARMRESET		0x00010000
-#define PLL_CTRL_MASK23		0x000080ff
-
-/* LCD Controller */
-#define LCD_BASE 		(IO_VIRT + 0x10000)
-#define LCD_CTRL 		0x00
-#define LCD_STATUS		0x04
-#define LCD_STATUS_M		0x08
-#define LCD_INTERRUPT		0x0C
-#define LCD_DBAR		0x10
-#define LCD_DCAR		0x14
-#define LCD_TIMING0 		0x20
-#define LCD_TIMING1 		0x24
-#define LCD_TIMING2 		0x28
-#define LCD_TEST		0x40
-
-/* LCD Control Bits */
-#define LCD_CTRL_LCD_ENABLE   	0x00000001
-/* Bits per pixel */
-#define LCD_CTRL_LCD_BPP_MASK 	0x00000006
-#define LCD_CTRL_LCD_4BPP    	0x00000000
-#define LCD_CTRL_LCD_8BPP    	0x00000002
-#define LCD_CTRL_LCD_16BPP   	0x00000004
-#define LCD_CTRL_LCD_BW		0x00000008
-#define LCD_CTRL_LCD_TFT	0x00000010
-#define LCD_CTRL_BGR		0x00001000
-#define LCD_CTRL_LCD_VCOMP	0x00080000
-#define LCD_CTRL_LCD_MONO8	0x00200000
-#define LCD_CTRL_LCD_PWR	0x00400000
-#define LCD_CTRL_LCD_BLE	0x00800000
-#define LCD_CTRL_LDBUSEN	0x01000000
-
-/* Palette */
-#define LCD_PALETTE_BASE 	(IO_VIRT + 0x10400)
-
-/* Serial ports */
-#define SERIAL0_OFS		0x20000
-#define SERIAL0_VIRT 		(IO_VIRT + SERIAL0_OFS)
-#define SERIAL0_BASE		(IO_PHYS + SERIAL0_OFS)
-
-#define SERIAL1_OFS		0x21000
-#define SERIAL1_VIRT 		(IO_VIRT + SERIAL1_OFS)
-#define SERIAL1_BASE		(IO_PHYS + SERIAL1_OFS)
-
-#define SERIAL_ENABLE		0x30
-#define SERIAL_ENABLE_EN	(1<<0)
-
-/* General defines to pacify gcc */
-
-#define __ASM_ARCH_HARDWARE_INCMACH_H
-#include "boards.h"
-#undef __ASM_ARCH_HARDWARE_INCMACH_H
-
-#endif				/* __ASM_ARCH_HARDWARE_H */
diff --git a/arch/arm/mach-h720x/include/mach/irqs.h b/arch/arm/mach-h720x/include/mach/irqs.h
deleted file mode 100644
index 430a92b..0000000
--- a/arch/arm/mach-h720x/include/mach/irqs.h
+++ /dev/null
@@ -1,116 +0,0 @@
-/*
- * arch/arm/mach-h720x/include/mach/irqs.h
- *
- * Copyright (C) 2000 Jungjun Kim
- *           (C) 2003 Robert Schwebel <r.schwebel@pengutronix.de>
- *           (C) 2003 Thomas Gleixner <tglx@linutronix.de>
- *
- */
-
-#ifndef __ASM_ARCH_IRQS_H
-#define __ASM_ARCH_IRQS_H
-
-#if defined (CONFIG_CPU_H7201)
-
-#define IRQ_PMU		0		/* 0x000001 */
-#define IRQ_DMA		1 		/* 0x000002 */
-#define IRQ_LCD		2		/* 0x000004 */
-#define IRQ_VGA		3 		/* 0x000008 */
-#define IRQ_PCMCIA1 	4 		/* 0x000010 */
-#define IRQ_PCMCIA2 	5 		/* 0x000020 */
-#define IRQ_AFE		6 		/* 0x000040 */
-#define IRQ_AIC		7 		/* 0x000080 */
-#define IRQ_KEYBOARD 	8 		/* 0x000100 */
-#define IRQ_TIMER0	9 		/* 0x000200 */
-#define IRQ_RTC		10		/* 0x000400 */
-#define IRQ_SOUND	11		/* 0x000800 */
-#define IRQ_USB		12		/* 0x001000 */
-#define IRQ_IrDA 	13		/* 0x002000 */
-#define IRQ_UART0	14		/* 0x004000 */
-#define IRQ_UART1	15		/* 0x008000 */
-#define IRQ_SPI		16		/* 0x010000 */
-#define IRQ_GPIOA 	17		/* 0x020000 */
-#define IRQ_GPIOB	18		/* 0x040000 */
-#define IRQ_GPIOC	19		/* 0x080000 */
-#define IRQ_GPIOD	20		/* 0x100000 */
-#define IRQ_CommRX	21		/* 0x200000 */
-#define IRQ_CommTX	22		/* 0x400000 */
-#define IRQ_Soft	23		/* 0x800000 */
-
-#define NR_GLBL_IRQS	24
-
-#define IRQ_CHAINED_GPIOA(x)  (NR_GLBL_IRQS + x)
-#define IRQ_CHAINED_GPIOB(x)  (IRQ_CHAINED_GPIOA(32) + x)
-#define IRQ_CHAINED_GPIOC(x)  (IRQ_CHAINED_GPIOB(32) + x)
-#define IRQ_CHAINED_GPIOD(x)  (IRQ_CHAINED_GPIOC(32) + x)
-#define NR_IRQS               IRQ_CHAINED_GPIOD(32)
-
-/* Enable mask for multiplexed interrupts */
-#define IRQ_ENA_MUX	(1<<IRQ_GPIOA) | (1<<IRQ_GPIOB) \
-			| (1<<IRQ_GPIOC) | (1<<IRQ_GPIOD)
-
-
-#elif defined (CONFIG_CPU_H7202)
-
-#define IRQ_PMU		0		/* 0x00000001 */
-#define IRQ_DMA		1		/* 0x00000002 */
-#define IRQ_LCD		2		/* 0x00000004 */
-#define IRQ_SOUND	3		/* 0x00000008 */
-#define IRQ_I2S		4		/* 0x00000010 */
-#define IRQ_USB 	5		/* 0x00000020 */
-#define IRQ_MMC 	6		/* 0x00000040 */
-#define IRQ_RTC 	7		/* 0x00000080 */
-#define IRQ_UART0 	8		/* 0x00000100 */
-#define IRQ_UART1 	9		/* 0x00000200 */
-#define IRQ_UART2 	10		/* 0x00000400 */
-#define IRQ_UART3 	11		/* 0x00000800 */
-#define IRQ_KBD 	12		/* 0x00001000 */
-#define IRQ_PS2 	13		/* 0x00002000 */
-#define IRQ_AIC 	14		/* 0x00004000 */
-#define IRQ_TIMER0 	15		/* 0x00008000 */
-#define IRQ_TIMERX 	16		/* 0x00010000 */
-#define IRQ_WDT 	17		/* 0x00020000 */
-#define IRQ_CAN0 	18		/* 0x00040000 */
-#define IRQ_CAN1 	19		/* 0x00080000 */
-#define IRQ_EXT0 	20		/* 0x00100000 */
-#define IRQ_EXT1 	21		/* 0x00200000 */
-#define IRQ_GPIOA 	22		/* 0x00400000 */
-#define IRQ_GPIOB 	23		/* 0x00800000 */
-#define IRQ_GPIOC 	24		/* 0x01000000 */
-#define IRQ_GPIOD 	25		/* 0x02000000 */
-#define IRQ_GPIOE 	26		/* 0x04000000 */
-#define IRQ_COMMRX 	27		/* 0x08000000 */
-#define IRQ_COMMTX 	28		/* 0x10000000 */
-#define IRQ_SMC 	29		/* 0x20000000 */
-#define IRQ_Soft 	30		/* 0x40000000 */
-#define IRQ_RESERVED1 	31		/* 0x80000000 */
-#define NR_GLBL_IRQS	32
-
-#define NR_TIMERX_IRQS	3
-
-#define IRQ_CHAINED_GPIOA(x)  (NR_GLBL_IRQS + x)
-#define IRQ_CHAINED_GPIOB(x)  (IRQ_CHAINED_GPIOA(32) + x)
-#define IRQ_CHAINED_GPIOC(x)  (IRQ_CHAINED_GPIOB(32) + x)
-#define IRQ_CHAINED_GPIOD(x)  (IRQ_CHAINED_GPIOC(32) + x)
-#define IRQ_CHAINED_GPIOE(x)  (IRQ_CHAINED_GPIOD(32) + x)
-#define IRQ_CHAINED_TIMERX(x) (IRQ_CHAINED_GPIOE(32) + x)
-#define IRQ_TIMER1            (IRQ_CHAINED_TIMERX(0))
-#define IRQ_TIMER2            (IRQ_CHAINED_TIMERX(1))
-#define IRQ_TIMER64B          (IRQ_CHAINED_TIMERX(2))
-
-#define NR_IRQS		(IRQ_CHAINED_TIMERX(NR_TIMERX_IRQS))
-
-/* Enable mask for multiplexed interrupts */
-#define IRQ_ENA_MUX	(1<<IRQ_TIMERX) | (1<<IRQ_GPIOA) | (1<<IRQ_GPIOB) | \
-			(1<<IRQ_GPIOC) 	| (1<<IRQ_GPIOD) | (1<<IRQ_GPIOE) | \
-			(1<<IRQ_TIMERX)
-
-#else
-#error cpu definition mismatch
-#endif
-
-/* decode irq number to register number */
-#define IRQ_TO_REGNO(irq) ((irq - NR_GLBL_IRQS) >> 5)
-#define IRQ_TO_BIT(irq) (1 << ((irq - NR_GLBL_IRQS) % 32))
-
-#endif
diff --git a/arch/arm/mach-h720x/include/mach/isa-dma.h b/arch/arm/mach-h720x/include/mach/isa-dma.h
deleted file mode 100644
index 3eafb3f..0000000
--- a/arch/arm/mach-h720x/include/mach/isa-dma.h
+++ /dev/null
@@ -1,19 +0,0 @@
-/*
- * arch/arm/mach-h720x/include/mach/isa-dma.h
- *
- * Architecture DMA routes
- *
- * Copyright (C) 1997.1998 Russell King
- */
-#ifndef __ASM_ARCH_DMA_H
-#define __ASM_ARCH_DMA_H
-
-#if defined (CONFIG_CPU_H7201)
-#define MAX_DMA_CHANNELS	3
-#elif defined (CONFIG_CPU_H7202)
-#define MAX_DMA_CHANNELS	4
-#else
-#error processor definition missmatch
-#endif
-
-#endif /* __ASM_ARCH_DMA_H */
diff --git a/arch/arm/mach-h720x/include/mach/timex.h b/arch/arm/mach-h720x/include/mach/timex.h
deleted file mode 100644
index 3f2f447..0000000
--- a/arch/arm/mach-h720x/include/mach/timex.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * arch/arm/mach-h720x/include/mach/timex.h
- * Copyright (C) 2000 Jungjun Kim, Hynix Semiconductor Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef __ASM_ARCH_TIMEX
-#define __ASM_ARCH_TIMEX
-
-#define CLOCK_TICK_RATE		3686400
-
-#endif
diff --git a/arch/arm/mach-h720x/include/mach/uncompress.h b/arch/arm/mach-h720x/include/mach/uncompress.h
deleted file mode 100644
index 43e343c..0000000
--- a/arch/arm/mach-h720x/include/mach/uncompress.h
+++ /dev/null
@@ -1,36 +0,0 @@
-/*
- * arch/arm/mach-h720x/include/mach/uncompress.h
- *
- * Copyright (C) 2001-2002 Jungjun Kim
- */
-
-#ifndef __ASM_ARCH_UNCOMPRESS_H
-#define __ASM_ARCH_UNCOMPRESS_H
-
-#include <mach/hardware.h>
-
-#define LSR 	0x14
-#define TEMPTY 	0x40
-
-static inline void putc(int c)
-{
-	volatile unsigned char *p = (volatile unsigned char *)(IO_PHYS+0x20000);
-
-	/* wait until transmit buffer is empty */
-	while((p[LSR] & TEMPTY) == 0x0)
-		barrier();
-
-	/* write next character */
-	*p = c;
-}
-
-static inline void flush(void)
-{
-}
-
-/*
- * nothing to do
- */
-#define arch_decomp_setup()
-
-#endif
-- 
1.8.1.2

