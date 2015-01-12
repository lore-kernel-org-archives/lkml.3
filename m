Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbbALSna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:43:30 -0500
Received: from down.free-electrons.com ([37.187.137.238]:56623 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755683AbbALSm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:42:26 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 4/7] ARM: at91: remove useless at91_sysirq_mask_rtx
Date: Mon, 12 Jan 2015 19:42:13 +0100
Message-Id: <1421088136-10172-5-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421088136-10172-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421088136-10172-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irq fixup from at91_sysirq_mask_rtc and at91_sysirq_mask_rtt is now handled
by aic_common_rtc_irq_fixup and aic_common_rtt_irq_fixup. Remove those useless
functions.
Also remove the now unused mach/at91_rtt.h header.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/Makefile                |  2 +-
 arch/arm/mach-at91/at91sam9260.c           |  2 -
 arch/arm/mach-at91/at91sam9261.c           |  2 -
 arch/arm/mach-at91/at91sam9263.c           |  3 --
 arch/arm/mach-at91/at91sam9g45.c           |  3 --
 arch/arm/mach-at91/at91sam9n12.c           |  6 ---
 arch/arm/mach-at91/at91sam9rl.c            |  3 --
 arch/arm/mach-at91/at91sam9x5.c            | 10 ----
 arch/arm/mach-at91/generic.h               |  4 --
 arch/arm/mach-at91/include/mach/at91_rtt.h | 35 --------------
 arch/arm/mach-at91/sama5d3.c               |  6 ---
 arch/arm/mach-at91/sysirq_mask.c           | 75 ------------------------------
 12 files changed, 1 insertion(+), 150 deletions(-)
 delete mode 100644 arch/arm/mach-at91/include/mach/at91_rtt.h
 delete mode 100644 arch/arm/mach-at91/sysirq_mask.c

diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index 9165a4aa7f0d..8ef7d9a2e855 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-obj-y		:= setup.o sysirq_mask.o
+obj-y		:= setup.o
 
 obj-$(CONFIG_SOC_AT91SAM9)	+= sam9_smc.o
 
diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index 78137c24d90b..34e2abe82ae4 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -51,8 +51,6 @@ static void __init at91sam9260_map_io(void)
 static void __init at91sam9260_initialize(void)
 {
 	arm_pm_idle = at91sam9_idle;
-
-	at91_sysirq_mask_rtt(AT91SAM9260_BASE_RTT);
 }
 
 AT91_SOC_START(at91sam9260)
diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index d29953ecb0c4..47878b849975 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -32,8 +32,6 @@ static void __init at91sam9261_map_io(void)
 static void __init at91sam9261_initialize(void)
 {
 	arm_pm_idle = at91sam9_idle;
-
-	at91_sysirq_mask_rtt(AT91SAM9261_BASE_RTT);
 }
 
 AT91_SOC_START(at91sam9261)
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index e7ad14864083..aabcb66145d0 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -29,9 +29,6 @@ static void __init at91sam9263_map_io(void)
 static void __init at91sam9263_initialize(void)
 {
 	arm_pm_idle = at91sam9_idle;
-
-	at91_sysirq_mask_rtt(AT91SAM9263_BASE_RTT0);
-	at91_sysirq_mask_rtt(AT91SAM9263_BASE_RTT1);
 }
 
 AT91_SOC_START(at91sam9263)
diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index b6117bea9a6f..b044dbcc0dcc 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -29,9 +29,6 @@ static void __init at91sam9g45_map_io(void)
 static void __init at91sam9g45_initialize(void)
 {
 	arm_pm_idle = at91sam9_idle;
-
-	at91_sysirq_mask_rtc(AT91SAM9G45_BASE_RTC);
-	at91_sysirq_mask_rtt(AT91SAM9G45_BASE_RTT);
 }
 
 AT91_SOC_START(at91sam9g45)
diff --git a/arch/arm/mach-at91/at91sam9n12.c b/arch/arm/mach-at91/at91sam9n12.c
index dee569b1987e..0135f868ea4f 100644
--- a/arch/arm/mach-at91/at91sam9n12.c
+++ b/arch/arm/mach-at91/at91sam9n12.c
@@ -21,12 +21,6 @@ static void __init at91sam9n12_map_io(void)
 	at91_init_sram(0, AT91SAM9N12_SRAM_BASE, AT91SAM9N12_SRAM_SIZE);
 }
 
-static void __init at91sam9n12_initialize(void)
-{
-	at91_sysirq_mask_rtc(AT91SAM9N12_BASE_RTC);
-}
-
 AT91_SOC_START(at91sam9n12)
 	.map_io = at91sam9n12_map_io,
-	.init = at91sam9n12_initialize,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
index f25b9aec9c50..7d303c132032 100644
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@ -42,9 +42,6 @@ static void __init at91sam9rl_map_io(void)
 static void __init at91sam9rl_initialize(void)
 {
 	arm_pm_idle = at91sam9_idle;
-
-	at91_sysirq_mask_rtc(AT91SAM9RL_BASE_RTC);
-	at91_sysirq_mask_rtt(AT91SAM9RL_BASE_RTT);
 }
 
 AT91_SOC_START(at91sam9rl)
diff --git a/arch/arm/mach-at91/at91sam9x5.c b/arch/arm/mach-at91/at91sam9x5.c
index f0d5a69a7237..aa17520ccb0a 100644
--- a/arch/arm/mach-at91/at91sam9x5.c
+++ b/arch/arm/mach-at91/at91sam9x5.c
@@ -21,16 +21,6 @@ static void __init at91sam9x5_map_io(void)
 	at91_init_sram(0, AT91SAM9X5_SRAM_BASE, AT91SAM9X5_SRAM_SIZE);
 }
 
-static void __init at91sam9x5_initialize(void)
-{
-	at91_sysirq_mask_rtc(AT91SAM9X5_BASE_RTC);
-}
-
-/* --------------------------------------------------------------------
- *  Interrupt initialization
- * -------------------------------------------------------------------- */
-
 AT91_SOC_START(at91sam9x5)
 	.map_io = at91sam9x5_map_io,
-	.init = at91sam9x5_initialize,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index d53324210adf..e0368aa06390 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -25,10 +25,6 @@ extern void __init at91rm9200_set_type(int type);
 extern void __init at91rm9200_dt_initialize(void);
 extern void __init at91_dt_initialize(void);
 
- /* Interrupts */
-extern void __init at91_sysirq_mask_rtc(u32 rtc_base);
-extern void __init at91_sysirq_mask_rtt(u32 rtt_base);
-
  /* Timer */
 extern void at91rm9200_timer_init(void);
 
diff --git a/arch/arm/mach-at91/include/mach/at91_rtt.h b/arch/arm/mach-at91/include/mach/at91_rtt.h
deleted file mode 100644
index 7ec75de8bbb6..000000000000
--- a/arch/arm/mach-at91/include/mach/at91_rtt.h
+++ /dev/null
@@ -1,35 +0,0 @@
-/*
- * arch/arm/mach-at91/include/mach/at91_rtt.h
- *
- * Copyright (C) 2007 Andrew Victor
- * Copyright (C) 2007 Atmel Corporation.
- *
- * Real-time Timer (RTT) - System peripherals regsters.
- * Based on AT91SAM9261 datasheet revision D.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef AT91_RTT_H
-#define AT91_RTT_H
-
-#define AT91_RTT_MR		0x00			/* Real-time Mode Register */
-#define		AT91_RTT_RTPRES		(0xffff << 0)		/* Real-time Timer Prescaler Value */
-#define		AT91_RTT_ALMIEN		(1 << 16)		/* Alarm Interrupt Enable */
-#define		AT91_RTT_RTTINCIEN	(1 << 17)		/* Real Time Timer Increment Interrupt Enable */
-#define		AT91_RTT_RTTRST		(1 << 18)		/* Real Time Timer Restart */
-
-#define AT91_RTT_AR		0x04			/* Real-time Alarm Register */
-#define		AT91_RTT_ALMV		(0xffffffff)		/* Alarm Value */
-
-#define AT91_RTT_VR		0x08			/* Real-time Value Register */
-#define		AT91_RTT_CRTV		(0xffffffff)		/* Current Real-time Value */
-
-#define AT91_RTT_SR		0x0c			/* Real-time Status Register */
-#define		AT91_RTT_ALMS		(1 << 0)		/* Real-time Alarm Status */
-#define		AT91_RTT_RTTINC		(1 << 1)		/* Real-time Timer Increment */
-
-#endif
diff --git a/arch/arm/mach-at91/sama5d3.c b/arch/arm/mach-at91/sama5d3.c
index 3d775d08de08..ae58feada72b 100644
--- a/arch/arm/mach-at91/sama5d3.c
+++ b/arch/arm/mach-at91/sama5d3.c
@@ -30,12 +30,6 @@ static void __init sama5d3_map_io(void)
 	at91_init_sram(0, SAMA5D3_SRAM_BASE, SAMA5D3_SRAM_SIZE);
 }
 
-static void __init sama5d3_initialize(void)
-{
-	at91_sysirq_mask_rtc(SAMA5D3_BASE_RTC);
-}
-
 AT91_SOC_START(sama5d3)
 	.map_io = sama5d3_map_io,
-	.init = sama5d3_initialize,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/sysirq_mask.c b/arch/arm/mach-at91/sysirq_mask.c
deleted file mode 100644
index f8bc3511a8c8..000000000000
--- a/arch/arm/mach-at91/sysirq_mask.c
+++ /dev/null
@@ -1,75 +0,0 @@
-/*
- * sysirq_mask.c - System-interrupt masking
- *
- * Copyright (C) 2013 Johan Hovold <jhovold@gmail.com>
- *
- * Functions to disable system interrupts from backup-powered peripherals.
- *
- * The RTC and RTT-peripherals are generally powered by backup power (VDDBU)
- * and are not reset on wake-up, user, watchdog or software reset. This means
- * that their interrupts may be enabled during early boot (e.g. after a user
- * reset).
- *
- * As the RTC and RTT share the system-interrupt line with the PIT, an
- * interrupt occurring before a handler has been installed would lead to the
- * system interrupt being disabled and prevent the system from booting.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <linux/io.h>
-#include <mach/at91_rtt.h>
-
-#include "generic.h"
-
-#define AT91_RTC_IDR		0x24	/* Interrupt Disable Register */
-#define AT91_RTC_IMR		0x28	/* Interrupt Mask Register */
-#define AT91_RTC_IRQ_MASK	0x1f	/* Available IRQs mask */
-
-void __init at91_sysirq_mask_rtc(u32 rtc_base)
-{
-	void __iomem *base;
-
-	base = ioremap(rtc_base, 64);
-	if (!base)
-		return;
-
-	/*
-	 * sam9x5 SoCs have the following errata:
-	 * "RTC: Interrupt Mask Register cannot be used
-	 *  Interrupt Mask Register read always returns 0."
-	 *
-	 * Hence we're not relying on IMR values to disable
-	 * interrupts.
-	 */
-	writel_relaxed(AT91_RTC_IRQ_MASK, base + AT91_RTC_IDR);
-	(void)readl_relaxed(base + AT91_RTC_IMR);	/* flush */
-
-	iounmap(base);
-}
-
-void __init at91_sysirq_mask_rtt(u32 rtt_base)
-{
-	void __iomem *base;
-	void __iomem *reg;
-	u32 mode;
-
-	base = ioremap(rtt_base, 16);
-	if (!base)
-		return;
-
-	reg = base + AT91_RTT_MR;
-
-	mode = readl_relaxed(reg);
-	if (mode & (AT91_RTT_ALMIEN | AT91_RTT_RTTINCIEN)) {
-		pr_info("AT91: Disabling rtt irq\n");
-		mode &= ~(AT91_RTT_ALMIEN | AT91_RTT_RTTINCIEN);
-		writel_relaxed(mode, reg);
-		(void)readl_relaxed(reg);			/* flush */
-	}
-
-	iounmap(base);
-}
-- 
2.1.0

