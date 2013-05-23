Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807Ab3EWJSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 05:18:21 -0400
Received: from 20.mo5.mail-out.ovh.net ([91.121.55.239]:51276 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756588Ab3EWJSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 05:18:18 -0400
X-Greylist: delayed 720 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 May 2013 05:18:17 EDT
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <brezillonboris@gmail.com>
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: [PATCH 1/3] ARM: at91: move at91 aic driver to drivers/irqchip
Date: Thu, 23 May 2013 10:49:48 +0200
Message-Id: <1369298990-9826-2-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369298990-9826-1-git-send-email-b.brezillon@overkiz.com>
References: <1369298990-9826-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 15577388163004806220
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeihedrtdduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeihedrtdduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <brezillonboris@gmail.com>

Move arch/arm/mach-at91/irq.c to drivers/irqchip/irq-at91.c.
Move arch/arm/mach-at91/at91_aic.h to
arch/arm/mach-at91/include/mach/at91_aic.h to avoid ugly reference
to header file :
#include "../../arch/arm/mach-at91/at91_aic.h"

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/mach-at91/Makefile                |    2 +-
 arch/arm/mach-at91/at91_aic.h              |   99 -----
 arch/arm/mach-at91/at91rm9200.c            |    2 +-
 arch/arm/mach-at91/at91sam9260.c           |    2 +-
 arch/arm/mach-at91/at91sam9261.c           |    2 +-
 arch/arm/mach-at91/at91sam9263.c           |    2 +-
 arch/arm/mach-at91/at91sam9g45.c           |    2 +-
 arch/arm/mach-at91/at91sam9rl.c            |    2 +-
 arch/arm/mach-at91/at91x40.c               |    2 +-
 arch/arm/mach-at91/board-1arm.c            |    2 +-
 arch/arm/mach-at91/board-afeb-9260v1.c     |    2 +-
 arch/arm/mach-at91/board-cam60.c           |    2 +-
 arch/arm/mach-at91/board-carmeva.c         |    2 +-
 arch/arm/mach-at91/board-cpu9krea.c        |    2 +-
 arch/arm/mach-at91/board-cpuat91.c         |    2 +-
 arch/arm/mach-at91/board-csb337.c          |    2 +-
 arch/arm/mach-at91/board-csb637.c          |    2 +-
 arch/arm/mach-at91/board-dt-rm9200.c       |    3 +-
 arch/arm/mach-at91/board-dt-sam9.c         |    3 +-
 arch/arm/mach-at91/board-dt-sama5.c        |    3 +-
 arch/arm/mach-at91/board-eb01.c            |    3 +-
 arch/arm/mach-at91/board-eb9200.c          |    3 +-
 arch/arm/mach-at91/board-ecbat91.c         |    2 +-
 arch/arm/mach-at91/board-eco920.c          |    2 +-
 arch/arm/mach-at91/board-flexibity.c       |    2 +-
 arch/arm/mach-at91/board-foxg20.c          |    2 +-
 arch/arm/mach-at91/board-gsia18s.c         |    2 +-
 arch/arm/mach-at91/board-kafa.c            |    2 +-
 arch/arm/mach-at91/board-kb9202.c          |    2 +-
 arch/arm/mach-at91/board-pcontrol-g20.c    |    2 +-
 arch/arm/mach-at91/board-picotux200.c      |    2 +-
 arch/arm/mach-at91/board-qil-a9260.c       |    2 +-
 arch/arm/mach-at91/board-rm9200dk.c        |    2 +-
 arch/arm/mach-at91/board-rm9200ek.c        |    2 +-
 arch/arm/mach-at91/board-rsi-ews.c         |    3 +-
 arch/arm/mach-at91/board-sam9-l9260.c      |    2 +-
 arch/arm/mach-at91/board-sam9260ek.c       |    2 +-
 arch/arm/mach-at91/board-sam9261ek.c       |    2 +-
 arch/arm/mach-at91/board-sam9263ek.c       |    2 +-
 arch/arm/mach-at91/board-sam9g20ek.c       |    2 +-
 arch/arm/mach-at91/board-sam9m10g45ek.c    |    2 +-
 arch/arm/mach-at91/board-sam9rlek.c        |    2 +-
 arch/arm/mach-at91/board-snapper9260.c     |    2 +-
 arch/arm/mach-at91/board-stamp9g20.c       |    2 +-
 arch/arm/mach-at91/board-usb-a926x.c       |    2 +-
 arch/arm/mach-at91/board-yl-9200.c         |    2 +-
 arch/arm/mach-at91/include/mach/at91_aic.h |   99 +++++
 arch/arm/mach-at91/irq.c                   |  547 ----------------------------
 arch/arm/mach-at91/pm.c                    |    2 +-
 drivers/irqchip/Makefile                   |    1 +
 drivers/irqchip/irq-at91.c                 |  547 ++++++++++++++++++++++++++++
 51 files changed, 699 insertions(+), 692 deletions(-)

diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index 788562d..5333701 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-obj-y		:= irq.o gpio.o setup.o
+obj-y		:= gpio.o setup.o
 obj-m		:=
 obj-n		:=
 obj-		:=
diff --git a/arch/arm/mach-at91/at91_aic.h b/arch/arm/mach-at91/at91_aic.h
deleted file mode 100644
index eaea661..0000000
--- a/arch/arm/mach-at91/at91_aic.h
+++ /dev/null
@@ -1,99 +0,0 @@
-/*
- * arch/arm/mach-at91/include/mach/at91_aic.h
- *
- * Copyright (C) 2005 Ivan Kokshaysky
- * Copyright (C) SAN People
- *
- * Advanced Interrupt Controller (AIC) - System peripherals registers.
- * Based on AT91RM9200 datasheet revision E.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef AT91_AIC_H
-#define AT91_AIC_H
-
-#ifndef __ASSEMBLY__
-extern void __iomem *at91_aic_base;
-
-#define at91_aic_read(field) \
-	__raw_readl(at91_aic_base + field)
-
-#define at91_aic_write(field, value) \
-	__raw_writel(value, at91_aic_base + field)
-#else
-.extern at91_aic_base
-#endif
-
-/* Number of irq lines managed by AIC */
-#define NR_AIC_IRQS	32
-#define NR_AIC5_IRQS	128
-
-#define AT91_AIC5_SSR		0x0			/* Source Select Register [AIC5] */
-#define 	AT91_AIC5_INTSEL_MSK	(0x7f << 0)		/* Interrupt Line Selection Mask */
-
-#define AT91_AIC_IRQ_MIN_PRIORITY	0
-#define AT91_AIC_IRQ_MAX_PRIORITY	7
-
-#define AT91_AIC_SMR(n)		((n) * 4)		/* Source Mode Registers 0-31 */
-#define AT91_AIC5_SMR		0x4			/* Source Mode Register [AIC5] */
-#define		AT91_AIC_PRIOR		(7 << 0)		/* Priority Level */
-#define		AT91_AIC_SRCTYPE	(3 << 5)		/* Interrupt Source Type */
-#define			AT91_AIC_SRCTYPE_LOW		(0 << 5)
-#define			AT91_AIC_SRCTYPE_FALLING	(1 << 5)
-#define			AT91_AIC_SRCTYPE_HIGH		(2 << 5)
-#define			AT91_AIC_SRCTYPE_RISING		(3 << 5)
-
-#define AT91_AIC_SVR(n)		(0x80 + ((n) * 4))	/* Source Vector Registers 0-31 */
-#define AT91_AIC5_SVR		0x8			/* Source Vector Register [AIC5] */
-#define AT91_AIC_IVR		0x100			/* Interrupt Vector Register */
-#define AT91_AIC5_IVR		0x10			/* Interrupt Vector Register [AIC5] */
-#define AT91_AIC_FVR		0x104			/* Fast Interrupt Vector Register */
-#define AT91_AIC5_FVR		0x14			/* Fast Interrupt Vector Register [AIC5] */
-#define AT91_AIC_ISR		0x108			/* Interrupt Status Register */
-#define AT91_AIC5_ISR		0x18			/* Interrupt Status Register [AIC5] */
-#define		AT91_AIC_IRQID		(0x1f << 0)		/* Current Interrupt Identifier */
-
-#define AT91_AIC_IPR		0x10c			/* Interrupt Pending Register */
-#define AT91_AIC5_IPR0		0x20			/* Interrupt Pending Register 0 [AIC5] */
-#define AT91_AIC5_IPR1		0x24			/* Interrupt Pending Register 1 [AIC5] */
-#define AT91_AIC5_IPR2		0x28			/* Interrupt Pending Register 2 [AIC5] */
-#define AT91_AIC5_IPR3		0x2c			/* Interrupt Pending Register 3 [AIC5] */
-#define AT91_AIC_IMR		0x110			/* Interrupt Mask Register */
-#define AT91_AIC5_IMR		0x30			/* Interrupt Mask Register [AIC5] */
-#define AT91_AIC_CISR		0x114			/* Core Interrupt Status Register */
-#define AT91_AIC5_CISR		0x34			/* Core Interrupt Status Register [AIC5] */
-#define		AT91_AIC_NFIQ		(1 << 0)		/* nFIQ Status */
-#define		AT91_AIC_NIRQ		(1 << 1)		/* nIRQ Status */
-
-#define AT91_AIC_IECR		0x120			/* Interrupt Enable Command Register */
-#define AT91_AIC5_IECR		0x40			/* Interrupt Enable Command Register [AIC5] */
-#define AT91_AIC_IDCR		0x124			/* Interrupt Disable Command Register */
-#define AT91_AIC5_IDCR		0x44			/* Interrupt Disable Command Register [AIC5] */
-#define AT91_AIC_ICCR		0x128			/* Interrupt Clear Command Register */
-#define AT91_AIC5_ICCR		0x48			/* Interrupt Clear Command Register [AIC5] */
-#define AT91_AIC_ISCR		0x12c			/* Interrupt Set Command Register */
-#define AT91_AIC5_ISCR		0x4c			/* Interrupt Set Command Register [AIC5] */
-#define AT91_AIC_EOICR		0x130			/* End of Interrupt Command Register */
-#define AT91_AIC5_EOICR		0x38			/* End of Interrupt Command Register [AIC5] */
-#define AT91_AIC_SPU		0x134			/* Spurious Interrupt Vector Register */
-#define AT91_AIC5_SPU		0x3c			/* Spurious Interrupt Vector Register [AIC5] */
-#define AT91_AIC_DCR		0x138			/* Debug Control Register */
-#define AT91_AIC5_DCR		0x6c			/* Debug Control Register [AIC5] */
-#define		AT91_AIC_DCR_PROT	(1 << 0)		/* Protection Mode */
-#define		AT91_AIC_DCR_GMSK	(1 << 1)		/* General Mask */
-
-#define AT91_AIC_FFER		0x140			/* Fast Forcing Enable Register [SAM9 only] */
-#define AT91_AIC5_FFER		0x50			/* Fast Forcing Enable Register [AIC5] */
-#define AT91_AIC_FFDR		0x144			/* Fast Forcing Disable Register [SAM9 only] */
-#define AT91_AIC5_FFDR		0x54			/* Fast Forcing Disable Register [AIC5] */
-#define AT91_AIC_FFSR		0x148			/* Fast Forcing Status Register [SAM9 only] */
-#define AT91_AIC5_FFSR		0x58			/* Fast Forcing Status Register [AIC5] */
-
-void at91_aic_handle_irq(struct pt_regs *regs);
-void at91_aic5_handle_irq(struct pt_regs *regs);
-
-#endif
diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
index d193a40..6c1204a 100644
--- a/arch/arm/mach-at91/at91rm9200.c
+++ b/arch/arm/mach-at91/at91rm9200.c
@@ -20,8 +20,8 @@
 #include <mach/at91_pmc.h>
 #include <mach/at91_st.h>
 #include <mach/cpu.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "soc.h"
 #include "generic.h"
 #include "clock.h"
diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index a8ce245..55332fa 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -21,8 +21,8 @@
 #include <mach/at91_dbgu.h>
 #include <mach/at91sam9260.h>
 #include <mach/at91_pmc.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "at91_rstc.h"
 #include "soc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index 25efb5a..6db61e6 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -20,8 +20,8 @@
 #include <mach/cpu.h>
 #include <mach/at91sam9261.h>
 #include <mach/at91_pmc.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "at91_rstc.h"
 #include "soc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index f44ffd2..b9ec043 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -19,8 +19,8 @@
 #include <asm/system_misc.h>
 #include <mach/at91sam9263.h>
 #include <mach/at91_pmc.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "at91_rstc.h"
 #include "soc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index 8b7fce0..1270707 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -20,8 +20,8 @@
 #include <mach/at91sam9g45.h>
 #include <mach/at91_pmc.h>
 #include <mach/cpu.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "soc.h"
 #include "generic.h"
 #include "clock.h"
diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
index f77fae5..d5f77d6 100644
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@ -20,8 +20,8 @@
 #include <mach/at91_dbgu.h>
 #include <mach/at91sam9rl.h>
 #include <mach/at91_pmc.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "at91_rstc.h"
 #include "soc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/at91x40.c b/arch/arm/mach-at91/at91x40.c
index 19ca793..e8b30fb 100644
--- a/arch/arm/mach-at91/at91x40.c
+++ b/arch/arm/mach-at91/at91x40.c
@@ -20,8 +20,8 @@
 #include <mach/at91x40.h>
 #include <mach/at91_st.h>
 #include <mach/timex.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "generic.h"
 
 /*
diff --git a/arch/arm/mach-at91/board-1arm.c b/arch/arm/mach-at91/board-1arm.c
index 35ab632..8037dfe 100644
--- a/arch/arm/mach-at91/board-1arm.c
+++ b/arch/arm/mach-at91/board-1arm.c
@@ -34,9 +34,9 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
+#include <mach/at91_aic.h>
 #include <mach/cpu.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-afeb-9260v1.c b/arch/arm/mach-at91/board-afeb-9260v1.c
index f95e31c..28bea23 100644
--- a/arch/arm/mach-at91/board-afeb-9260v1.c
+++ b/arch/arm/mach-at91/board-afeb-9260v1.c
@@ -42,8 +42,8 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-cam60.c b/arch/arm/mach-at91/board-cam60.c
index ade948b..6ebdf32 100644
--- a/arch/arm/mach-at91/board-cam60.c
+++ b/arch/arm/mach-at91/board-cam60.c
@@ -39,8 +39,8 @@
 #include <asm/mach/irq.h>
 
 #include <mach/at91sam9_smc.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-carmeva.c b/arch/arm/mach-at91/board-carmeva.c
index 9298305..842db49 100644
--- a/arch/arm/mach-at91/board-carmeva.c
+++ b/arch/arm/mach-at91/board-carmeva.c
@@ -35,8 +35,8 @@
 #include <asm/mach/irq.h>
 
 #include <mach/hardware.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-cpu9krea.c b/arch/arm/mach-at91/board-cpu9krea.c
index 008527e..4714e9e 100644
--- a/arch/arm/mach-at91/board-cpu9krea.c
+++ b/arch/arm/mach-at91/board-cpu9krea.c
@@ -43,8 +43,8 @@
 #include <mach/at91sam9_smc.h>
 #include <mach/at91sam9260_matrix.h>
 #include <mach/at91_matrix.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-cpuat91.c b/arch/arm/mach-at91/board-cpuat91.c
index 42f1353..c1663ed 100644
--- a/arch/arm/mach-at91/board-cpuat91.c
+++ b/arch/arm/mach-at91/board-cpuat91.c
@@ -39,8 +39,8 @@
 #include <mach/at91rm9200_mc.h>
 #include <mach/at91_ramc.h>
 #include <mach/cpu.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-csb337.c b/arch/arm/mach-at91/board-csb337.c
index e5fde215..3231703 100644
--- a/arch/arm/mach-at91/board-csb337.c
+++ b/arch/arm/mach-at91/board-csb337.c
@@ -38,8 +38,8 @@
 #include <asm/mach/irq.h>
 
 #include <mach/hardware.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-csb637.c b/arch/arm/mach-at91/board-csb637.c
index fdf1106..d58c7e6 100644
--- a/arch/arm/mach-at91/board-csb637.c
+++ b/arch/arm/mach-at91/board-csb637.c
@@ -35,8 +35,8 @@
 #include <asm/mach/irq.h>
 
 #include <mach/hardware.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-dt-rm9200.c b/arch/arm/mach-at91/board-dt-rm9200.c
index 3fcb662..0c2a06d 100644
--- a/arch/arm/mach-at91/board-dt-rm9200.c
+++ b/arch/arm/mach-at91/board-dt-rm9200.c
@@ -22,7 +22,8 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include "at91_aic.h"
+#include <mach/at91_aic.h>
+
 #include "generic.h"
 
 
diff --git a/arch/arm/mach-at91/board-dt-sam9.c b/arch/arm/mach-at91/board-dt-sam9.c
index 8db3013..ac899d8 100644
--- a/arch/arm/mach-at91/board-dt-sam9.c
+++ b/arch/arm/mach-at91/board-dt-sam9.c
@@ -21,7 +21,8 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include "at91_aic.h"
+#include <mach/at91_aic.h>
+
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
index 705305e..43b8f7a 100644
--- a/arch/arm/mach-at91/board-dt-sama5.c
+++ b/arch/arm/mach-at91/board-dt-sama5.c
@@ -23,7 +23,8 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include "at91_aic.h"
+#include <mach/at91_aic.h>
+
 #include "generic.h"
 
 
diff --git a/arch/arm/mach-at91/board-eb01.c b/arch/arm/mach-at91/board-eb01.c
index becf0a6..4097ede 100644
--- a/arch/arm/mach-at91/board-eb01.c
+++ b/arch/arm/mach-at91/board-eb01.c
@@ -28,7 +28,8 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 
-#include "at91_aic.h"
+#include <mach/at91_aic.h>
+
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-eb9200.c b/arch/arm/mach-at91/board-eb9200.c
index f9be816..afa5ebb 100644
--- a/arch/arm/mach-at91/board-eb9200.c
+++ b/arch/arm/mach-at91/board-eb9200.c
@@ -35,7 +35,8 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include "at91_aic.h"
+#include <mach/at91_aic.h>
+
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-ecbat91.c b/arch/arm/mach-at91/board-ecbat91.c
index b2fcd71..c794768 100644
--- a/arch/arm/mach-at91/board-ecbat91.c
+++ b/arch/arm/mach-at91/board-ecbat91.c
@@ -38,8 +38,8 @@
 #include <asm/mach/irq.h>
 
 #include <mach/cpu.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-eco920.c b/arch/arm/mach-at91/board-eco920.c
index 77de410..fc3e373 100644
--- a/arch/arm/mach-at91/board-eco920.c
+++ b/arch/arm/mach-at91/board-eco920.c
@@ -27,8 +27,8 @@
 #include <mach/at91rm9200_mc.h>
 #include <mach/at91_ramc.h>
 #include <mach/cpu.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-flexibity.c b/arch/arm/mach-at91/board-flexibity.c
index 737c085..59a1958 100644
--- a/arch/arm/mach-at91/board-flexibity.c
+++ b/arch/arm/mach-at91/board-flexibity.c
@@ -33,8 +33,8 @@
 #include <asm/mach/irq.h>
 
 #include <mach/hardware.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-foxg20.c b/arch/arm/mach-at91/board-foxg20.c
index c20a870..4b4df05 100644
--- a/arch/arm/mach-at91/board-foxg20.c
+++ b/arch/arm/mach-at91/board-foxg20.c
@@ -42,8 +42,8 @@
 #include <asm/mach/irq.h>
 
 #include <mach/at91sam9_smc.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-gsia18s.c b/arch/arm/mach-at91/board-gsia18s.c
index c1d61d2..1babcbd 100644
--- a/arch/arm/mach-at91/board-gsia18s.c
+++ b/arch/arm/mach-at91/board-gsia18s.c
@@ -31,8 +31,8 @@
 #include <asm/mach/arch.h>
 
 #include <mach/at91sam9_smc.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-kafa.c b/arch/arm/mach-at91/board-kafa.c
index 88e2f5d..aca52d3 100644
--- a/arch/arm/mach-at91/board-kafa.c
+++ b/arch/arm/mach-at91/board-kafa.c
@@ -35,8 +35,8 @@
 #include <asm/mach/irq.h>
 
 #include <mach/cpu.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-kb9202.c b/arch/arm/mach-at91/board-kb9202.c
index 0c519d9..7768df0 100644
--- a/arch/arm/mach-at91/board-kb9202.c
+++ b/arch/arm/mach-at91/board-kb9202.c
@@ -38,8 +38,8 @@
 #include <mach/cpu.h>
 #include <mach/at91rm9200_mc.h>
 #include <mach/at91_ramc.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-pcontrol-g20.c b/arch/arm/mach-at91/board-pcontrol-g20.c
index 65c0d6b..6df21db 100644
--- a/arch/arm/mach-at91/board-pcontrol-g20.c
+++ b/arch/arm/mach-at91/board-pcontrol-g20.c
@@ -30,8 +30,8 @@
 #include <asm/mach/arch.h>
 
 #include <mach/at91sam9_smc.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-picotux200.c b/arch/arm/mach-at91/board-picotux200.c
index ab2b2ec..566b30c 100644
--- a/arch/arm/mach-at91/board-picotux200.c
+++ b/arch/arm/mach-at91/board-picotux200.c
@@ -39,8 +39,8 @@
 
 #include <mach/at91rm9200_mc.h>
 #include <mach/at91_ramc.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-qil-a9260.c b/arch/arm/mach-at91/board-qil-a9260.c
index aa3bc9b..0ae5eb1 100644
--- a/arch/arm/mach-at91/board-qil-a9260.c
+++ b/arch/arm/mach-at91/board-qil-a9260.c
@@ -41,8 +41,8 @@
 
 #include <mach/hardware.h>
 #include <mach/at91sam9_smc.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "at91_shdwc.h"
 #include "board.h"
 #include "sam9_smc.h"
diff --git a/arch/arm/mach-at91/board-rm9200dk.c b/arch/arm/mach-at91/board-rm9200dk.c
index 690541b..82f0335e 100644
--- a/arch/arm/mach-at91/board-rm9200dk.c
+++ b/arch/arm/mach-at91/board-rm9200dk.c
@@ -41,8 +41,8 @@
 #include <mach/hardware.h>
 #include <mach/at91rm9200_mc.h>
 #include <mach/at91_ramc.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-rm9200ek.c b/arch/arm/mach-at91/board-rm9200ek.c
index 8b17dad..5e8a4f7 100644
--- a/arch/arm/mach-at91/board-rm9200ek.c
+++ b/arch/arm/mach-at91/board-rm9200ek.c
@@ -41,8 +41,8 @@
 #include <mach/hardware.h>
 #include <mach/at91rm9200_mc.h>
 #include <mach/at91_ramc.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-rsi-ews.c b/arch/arm/mach-at91/board-rsi-ews.c
index f6d7f19..e7d0a69 100644
--- a/arch/arm/mach-at91/board-rsi-ews.c
+++ b/arch/arm/mach-at91/board-rsi-ews.c
@@ -28,7 +28,8 @@
 
 #include <linux/gpio.h>
 
-#include "at91_aic.h"
+#include <mach/at91_aic.h>
+
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-sam9-l9260.c b/arch/arm/mach-at91/board-sam9-l9260.c
index 43ee4dc..2e400cd 100644
--- a/arch/arm/mach-at91/board-sam9-l9260.c
+++ b/arch/arm/mach-at91/board-sam9-l9260.c
@@ -38,8 +38,8 @@
 #include <asm/mach/irq.h>
 
 #include <mach/at91sam9_smc.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-sam9260ek.c b/arch/arm/mach-at91/board-sam9260ek.c
index 0b153c8..66ee7ac 100644
--- a/arch/arm/mach-at91/board-sam9260ek.c
+++ b/arch/arm/mach-at91/board-sam9260ek.c
@@ -43,8 +43,8 @@
 #include <mach/hardware.h>
 #include <mach/at91sam9_smc.h>
 #include <mach/system_rev.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "at91_shdwc.h"
 #include "board.h"
 #include "sam9_smc.h"
diff --git a/arch/arm/mach-at91/board-sam9261ek.c b/arch/arm/mach-at91/board-sam9261ek.c
index b446645..515957e 100644
--- a/arch/arm/mach-at91/board-sam9261ek.c
+++ b/arch/arm/mach-at91/board-sam9261ek.c
@@ -47,8 +47,8 @@
 #include <mach/hardware.h>
 #include <mach/at91sam9_smc.h>
 #include <mach/system_rev.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "at91_shdwc.h"
 #include "board.h"
 #include "sam9_smc.h"
diff --git a/arch/arm/mach-at91/board-sam9263ek.c b/arch/arm/mach-at91/board-sam9263ek.c
index 3284df0..1099272 100644
--- a/arch/arm/mach-at91/board-sam9263ek.c
+++ b/arch/arm/mach-at91/board-sam9263ek.c
@@ -46,8 +46,8 @@
 #include <mach/hardware.h>
 #include <mach/at91sam9_smc.h>
 #include <mach/system_rev.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "at91_shdwc.h"
 #include "board.h"
 #include "sam9_smc.h"
diff --git a/arch/arm/mach-at91/board-sam9g20ek.c b/arch/arm/mach-at91/board-sam9g20ek.c
index f9cd1f2..9fe718b 100644
--- a/arch/arm/mach-at91/board-sam9g20ek.c
+++ b/arch/arm/mach-at91/board-sam9g20ek.c
@@ -45,8 +45,8 @@
 
 #include <mach/at91sam9_smc.h>
 #include <mach/system_rev.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
index 2a94896..1846647 100644
--- a/arch/arm/mach-at91/board-sam9m10g45ek.c
+++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
@@ -44,8 +44,8 @@
 
 #include <mach/at91sam9_smc.h>
 #include <mach/system_rev.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "at91_shdwc.h"
 #include "board.h"
 #include "sam9_smc.h"
diff --git a/arch/arm/mach-at91/board-sam9rlek.c b/arch/arm/mach-at91/board-sam9rlek.c
index aa265dc..623f2d1 100644
--- a/arch/arm/mach-at91/board-sam9rlek.c
+++ b/arch/arm/mach-at91/board-sam9rlek.c
@@ -31,9 +31,9 @@
 
 #include <mach/hardware.h>
 #include <mach/at91sam9_smc.h>
+#include <mach/at91_aic.h>
 
 
-#include "at91_aic.h"
 #include "at91_shdwc.h"
 #include "board.h"
 #include "sam9_smc.h"
diff --git a/arch/arm/mach-at91/board-snapper9260.c b/arch/arm/mach-at91/board-snapper9260.c
index 3aaa978..8fef38a 100644
--- a/arch/arm/mach-at91/board-snapper9260.c
+++ b/arch/arm/mach-at91/board-snapper9260.c
@@ -33,8 +33,8 @@
 
 #include <mach/hardware.h>
 #include <mach/at91sam9_smc.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-stamp9g20.c b/arch/arm/mach-at91/board-stamp9g20.c
index 869cbec..6bda942 100644
--- a/arch/arm/mach-at91/board-stamp9g20.c
+++ b/arch/arm/mach-at91/board-stamp9g20.c
@@ -26,8 +26,8 @@
 #include <asm/mach/arch.h>
 
 #include <mach/at91sam9_smc.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-usb-a926x.c b/arch/arm/mach-at91/board-usb-a926x.c
index 2487d94..cedbc66 100644
--- a/arch/arm/mach-at91/board-usb-a926x.c
+++ b/arch/arm/mach-at91/board-usb-a926x.c
@@ -42,8 +42,8 @@
 
 #include <mach/hardware.h>
 #include <mach/at91sam9_smc.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "at91_shdwc.h"
 #include "board.h"
 #include "sam9_smc.h"
diff --git a/arch/arm/mach-at91/board-yl-9200.c b/arch/arm/mach-at91/board-yl-9200.c
index be08377..c61d8c9 100644
--- a/arch/arm/mach-at91/board-yl-9200.c
+++ b/arch/arm/mach-at91/board-yl-9200.c
@@ -46,8 +46,8 @@
 #include <mach/at91rm9200_mc.h>
 #include <mach/at91_ramc.h>
 #include <mach/cpu.h>
+#include <mach/at91_aic.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/include/mach/at91_aic.h b/arch/arm/mach-at91/include/mach/at91_aic.h
new file mode 100644
index 0000000..eaea661
--- /dev/null
+++ b/arch/arm/mach-at91/include/mach/at91_aic.h
@@ -0,0 +1,99 @@
+/*
+ * arch/arm/mach-at91/include/mach/at91_aic.h
+ *
+ * Copyright (C) 2005 Ivan Kokshaysky
+ * Copyright (C) SAN People
+ *
+ * Advanced Interrupt Controller (AIC) - System peripherals registers.
+ * Based on AT91RM9200 datasheet revision E.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef AT91_AIC_H
+#define AT91_AIC_H
+
+#ifndef __ASSEMBLY__
+extern void __iomem *at91_aic_base;
+
+#define at91_aic_read(field) \
+	__raw_readl(at91_aic_base + field)
+
+#define at91_aic_write(field, value) \
+	__raw_writel(value, at91_aic_base + field)
+#else
+.extern at91_aic_base
+#endif
+
+/* Number of irq lines managed by AIC */
+#define NR_AIC_IRQS	32
+#define NR_AIC5_IRQS	128
+
+#define AT91_AIC5_SSR		0x0			/* Source Select Register [AIC5] */
+#define 	AT91_AIC5_INTSEL_MSK	(0x7f << 0)		/* Interrupt Line Selection Mask */
+
+#define AT91_AIC_IRQ_MIN_PRIORITY	0
+#define AT91_AIC_IRQ_MAX_PRIORITY	7
+
+#define AT91_AIC_SMR(n)		((n) * 4)		/* Source Mode Registers 0-31 */
+#define AT91_AIC5_SMR		0x4			/* Source Mode Register [AIC5] */
+#define		AT91_AIC_PRIOR		(7 << 0)		/* Priority Level */
+#define		AT91_AIC_SRCTYPE	(3 << 5)		/* Interrupt Source Type */
+#define			AT91_AIC_SRCTYPE_LOW		(0 << 5)
+#define			AT91_AIC_SRCTYPE_FALLING	(1 << 5)
+#define			AT91_AIC_SRCTYPE_HIGH		(2 << 5)
+#define			AT91_AIC_SRCTYPE_RISING		(3 << 5)
+
+#define AT91_AIC_SVR(n)		(0x80 + ((n) * 4))	/* Source Vector Registers 0-31 */
+#define AT91_AIC5_SVR		0x8			/* Source Vector Register [AIC5] */
+#define AT91_AIC_IVR		0x100			/* Interrupt Vector Register */
+#define AT91_AIC5_IVR		0x10			/* Interrupt Vector Register [AIC5] */
+#define AT91_AIC_FVR		0x104			/* Fast Interrupt Vector Register */
+#define AT91_AIC5_FVR		0x14			/* Fast Interrupt Vector Register [AIC5] */
+#define AT91_AIC_ISR		0x108			/* Interrupt Status Register */
+#define AT91_AIC5_ISR		0x18			/* Interrupt Status Register [AIC5] */
+#define		AT91_AIC_IRQID		(0x1f << 0)		/* Current Interrupt Identifier */
+
+#define AT91_AIC_IPR		0x10c			/* Interrupt Pending Register */
+#define AT91_AIC5_IPR0		0x20			/* Interrupt Pending Register 0 [AIC5] */
+#define AT91_AIC5_IPR1		0x24			/* Interrupt Pending Register 1 [AIC5] */
+#define AT91_AIC5_IPR2		0x28			/* Interrupt Pending Register 2 [AIC5] */
+#define AT91_AIC5_IPR3		0x2c			/* Interrupt Pending Register 3 [AIC5] */
+#define AT91_AIC_IMR		0x110			/* Interrupt Mask Register */
+#define AT91_AIC5_IMR		0x30			/* Interrupt Mask Register [AIC5] */
+#define AT91_AIC_CISR		0x114			/* Core Interrupt Status Register */
+#define AT91_AIC5_CISR		0x34			/* Core Interrupt Status Register [AIC5] */
+#define		AT91_AIC_NFIQ		(1 << 0)		/* nFIQ Status */
+#define		AT91_AIC_NIRQ		(1 << 1)		/* nIRQ Status */
+
+#define AT91_AIC_IECR		0x120			/* Interrupt Enable Command Register */
+#define AT91_AIC5_IECR		0x40			/* Interrupt Enable Command Register [AIC5] */
+#define AT91_AIC_IDCR		0x124			/* Interrupt Disable Command Register */
+#define AT91_AIC5_IDCR		0x44			/* Interrupt Disable Command Register [AIC5] */
+#define AT91_AIC_ICCR		0x128			/* Interrupt Clear Command Register */
+#define AT91_AIC5_ICCR		0x48			/* Interrupt Clear Command Register [AIC5] */
+#define AT91_AIC_ISCR		0x12c			/* Interrupt Set Command Register */
+#define AT91_AIC5_ISCR		0x4c			/* Interrupt Set Command Register [AIC5] */
+#define AT91_AIC_EOICR		0x130			/* End of Interrupt Command Register */
+#define AT91_AIC5_EOICR		0x38			/* End of Interrupt Command Register [AIC5] */
+#define AT91_AIC_SPU		0x134			/* Spurious Interrupt Vector Register */
+#define AT91_AIC5_SPU		0x3c			/* Spurious Interrupt Vector Register [AIC5] */
+#define AT91_AIC_DCR		0x138			/* Debug Control Register */
+#define AT91_AIC5_DCR		0x6c			/* Debug Control Register [AIC5] */
+#define		AT91_AIC_DCR_PROT	(1 << 0)		/* Protection Mode */
+#define		AT91_AIC_DCR_GMSK	(1 << 1)		/* General Mask */
+
+#define AT91_AIC_FFER		0x140			/* Fast Forcing Enable Register [SAM9 only] */
+#define AT91_AIC5_FFER		0x50			/* Fast Forcing Enable Register [AIC5] */
+#define AT91_AIC_FFDR		0x144			/* Fast Forcing Disable Register [SAM9 only] */
+#define AT91_AIC5_FFDR		0x54			/* Fast Forcing Disable Register [AIC5] */
+#define AT91_AIC_FFSR		0x148			/* Fast Forcing Status Register [SAM9 only] */
+#define AT91_AIC5_FFSR		0x58			/* Fast Forcing Status Register [AIC5] */
+
+void at91_aic_handle_irq(struct pt_regs *regs);
+void at91_aic5_handle_irq(struct pt_regs *regs);
+
+#endif
diff --git a/arch/arm/mach-at91/irq.c b/arch/arm/mach-at91/irq.c
deleted file mode 100644
index e0ca591..0000000
--- a/arch/arm/mach-at91/irq.c
+++ /dev/null
@@ -1,547 +0,0 @@
-/*
- * linux/arch/arm/mach-at91/irq.c
- *
- *  Copyright (C) 2004 SAN People
- *  Copyright (C) 2004 ATMEL
- *  Copyright (C) Rick Bronson
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/mm.h>
-#include <linux/bitmap.h>
-#include <linux/types.h>
-#include <linux/irq.h>
-#include <linux/of.h>
-#include <linux/of_address.h>
-#include <linux/of_irq.h>
-#include <linux/irqdomain.h>
-#include <linux/err.h>
-#include <linux/slab.h>
-
-#include <mach/hardware.h>
-#include <asm/irq.h>
-#include <asm/setup.h>
-
-#include <asm/exception.h>
-#include <asm/mach/arch.h>
-#include <asm/mach/irq.h>
-#include <asm/mach/map.h>
-
-#include "at91_aic.h"
-
-void __iomem *at91_aic_base;
-static struct irq_domain *at91_aic_domain;
-static struct device_node *at91_aic_np;
-static unsigned int n_irqs = NR_AIC_IRQS;
-static unsigned long at91_aic_caps = 0;
-
-/* AIC5 introduces a Source Select Register */
-#define AT91_AIC_CAP_AIC5	(1 << 0)
-#define has_aic5()		(at91_aic_caps & AT91_AIC_CAP_AIC5)
-
-#ifdef CONFIG_PM
-
-static unsigned long *wakeups;
-static unsigned long *backups;
-
-#define set_backup(bit) set_bit(bit, backups)
-#define clear_backup(bit) clear_bit(bit, backups)
-
-static int at91_aic_pm_init(void)
-{
-	backups = kzalloc(BITS_TO_LONGS(n_irqs) * sizeof(*backups), GFP_KERNEL);
-	if (!backups)
-		return -ENOMEM;
-
-	wakeups = kzalloc(BITS_TO_LONGS(n_irqs) * sizeof(*backups), GFP_KERNEL);
-	if (!wakeups) {
-		kfree(backups);
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-static int at91_aic_set_wake(struct irq_data *d, unsigned value)
-{
-	if (unlikely(d->hwirq >= n_irqs))
-		return -EINVAL;
-
-	if (value)
-		set_bit(d->hwirq, wakeups);
-	else
-		clear_bit(d->hwirq, wakeups);
-
-	return 0;
-}
-
-void at91_irq_suspend(void)
-{
-	int bit = -1;
-
-	if (has_aic5()) {
-		/* disable enabled irqs */
-		while ((bit = find_next_bit(backups, n_irqs, bit + 1)) < n_irqs) {
-			at91_aic_write(AT91_AIC5_SSR,
-				       bit & AT91_AIC5_INTSEL_MSK);
-			at91_aic_write(AT91_AIC5_IDCR, 1);
-		}
-		/* enable wakeup irqs */
-		bit = -1;
-		while ((bit = find_next_bit(wakeups, n_irqs, bit + 1)) < n_irqs) {
-			at91_aic_write(AT91_AIC5_SSR,
-				       bit & AT91_AIC5_INTSEL_MSK);
-			at91_aic_write(AT91_AIC5_IECR, 1);
-		}
-	} else {
-		at91_aic_write(AT91_AIC_IDCR, *backups);
-		at91_aic_write(AT91_AIC_IECR, *wakeups);
-	}
-}
-
-void at91_irq_resume(void)
-{
-	int bit = -1;
-
-	if (has_aic5()) {
-		/* disable wakeup irqs */
-		while ((bit = find_next_bit(wakeups, n_irqs, bit + 1)) < n_irqs) {
-			at91_aic_write(AT91_AIC5_SSR,
-				       bit & AT91_AIC5_INTSEL_MSK);
-			at91_aic_write(AT91_AIC5_IDCR, 1);
-		}
-		/* enable irqs disabled for suspend */
-		bit = -1;
-		while ((bit = find_next_bit(backups, n_irqs, bit + 1)) < n_irqs) {
-			at91_aic_write(AT91_AIC5_SSR,
-				       bit & AT91_AIC5_INTSEL_MSK);
-			at91_aic_write(AT91_AIC5_IECR, 1);
-		}
-	} else {
-		at91_aic_write(AT91_AIC_IDCR, *wakeups);
-		at91_aic_write(AT91_AIC_IECR, *backups);
-	}
-}
-
-#else
-static inline int at91_aic_pm_init(void)
-{
-	return 0;
-}
-
-#define set_backup(bit)
-#define clear_backup(bit)
-#define at91_aic_set_wake	NULL
-
-#endif /* CONFIG_PM */
-
-asmlinkage void __exception_irq_entry
-at91_aic_handle_irq(struct pt_regs *regs)
-{
-	u32 irqnr;
-	u32 irqstat;
-
-	irqnr = at91_aic_read(AT91_AIC_IVR);
-	irqstat = at91_aic_read(AT91_AIC_ISR);
-
-	/*
-	 * ISR value is 0 when there is no current interrupt or when there is
-	 * a spurious interrupt
-	 */
-	if (!irqstat)
-		at91_aic_write(AT91_AIC_EOICR, 0);
-	else
-		handle_IRQ(irqnr, regs);
-}
-
-asmlinkage void __exception_irq_entry
-at91_aic5_handle_irq(struct pt_regs *regs)
-{
-	u32 irqnr;
-	u32 irqstat;
-
-	irqnr = at91_aic_read(AT91_AIC5_IVR);
-	irqstat = at91_aic_read(AT91_AIC5_ISR);
-
-	if (!irqstat)
-		at91_aic_write(AT91_AIC5_EOICR, 0);
-	else
-		handle_IRQ(irqnr, regs);
-}
-
-static void at91_aic_mask_irq(struct irq_data *d)
-{
-	/* Disable interrupt on AIC */
-	at91_aic_write(AT91_AIC_IDCR, 1 << d->hwirq);
-	/* Update ISR cache */
-	clear_backup(d->hwirq);
-}
-
-static void __maybe_unused at91_aic5_mask_irq(struct irq_data *d)
-{
-	/* Disable interrupt on AIC5 */
-	at91_aic_write(AT91_AIC5_SSR, d->hwirq & AT91_AIC5_INTSEL_MSK);
-	at91_aic_write(AT91_AIC5_IDCR, 1);
-	/* Update ISR cache */
-	clear_backup(d->hwirq);
-}
-
-static void at91_aic_unmask_irq(struct irq_data *d)
-{
-	/* Enable interrupt on AIC */
-	at91_aic_write(AT91_AIC_IECR, 1 << d->hwirq);
-	/* Update ISR cache */
-	set_backup(d->hwirq);
-}
-
-static void __maybe_unused at91_aic5_unmask_irq(struct irq_data *d)
-{
-	/* Enable interrupt on AIC5 */
-	at91_aic_write(AT91_AIC5_SSR, d->hwirq & AT91_AIC5_INTSEL_MSK);
-	at91_aic_write(AT91_AIC5_IECR, 1);
-	/* Update ISR cache */
-	set_backup(d->hwirq);
-}
-
-static void at91_aic_eoi(struct irq_data *d)
-{
-	/*
-	 * Mark end-of-interrupt on AIC, the controller doesn't care about
-	 * the value written. Moreover it's a write-only register.
-	 */
-	at91_aic_write(AT91_AIC_EOICR, 0);
-}
-
-static void __maybe_unused at91_aic5_eoi(struct irq_data *d)
-{
-	at91_aic_write(AT91_AIC5_EOICR, 0);
-}
-
-unsigned long *at91_extern_irq;
-
-#define is_extern_irq(hwirq) test_bit(hwirq, at91_extern_irq)
-
-static int at91_aic_compute_srctype(struct irq_data *d, unsigned type)
-{
-	int srctype;
-
-	switch (type) {
-	case IRQ_TYPE_LEVEL_HIGH:
-		srctype = AT91_AIC_SRCTYPE_HIGH;
-		break;
-	case IRQ_TYPE_EDGE_RISING:
-		srctype = AT91_AIC_SRCTYPE_RISING;
-		break;
-	case IRQ_TYPE_LEVEL_LOW:
-		if ((d->hwirq == AT91_ID_FIQ) || is_extern_irq(d->hwirq))		/* only supported on external interrupts */
-			srctype = AT91_AIC_SRCTYPE_LOW;
-		else
-			srctype = -EINVAL;
-		break;
-	case IRQ_TYPE_EDGE_FALLING:
-		if ((d->hwirq == AT91_ID_FIQ) || is_extern_irq(d->hwirq))		/* only supported on external interrupts */
-			srctype = AT91_AIC_SRCTYPE_FALLING;
-		else
-			srctype = -EINVAL;
-		break;
-	default:
-		srctype = -EINVAL;
-	}
-
-	return srctype;
-}
-
-static int at91_aic_set_type(struct irq_data *d, unsigned type)
-{
-	unsigned int smr;
-	int srctype;
-
-	srctype = at91_aic_compute_srctype(d, type);
-	if (srctype < 0)
-		return srctype;
-
-	if (has_aic5()) {
-		at91_aic_write(AT91_AIC5_SSR,
-			       d->hwirq & AT91_AIC5_INTSEL_MSK);
-		smr = at91_aic_read(AT91_AIC5_SMR) & ~AT91_AIC_SRCTYPE;
-		at91_aic_write(AT91_AIC5_SMR, smr | srctype);
-	} else {
-		smr = at91_aic_read(AT91_AIC_SMR(d->hwirq))
-		      & ~AT91_AIC_SRCTYPE;
-		at91_aic_write(AT91_AIC_SMR(d->hwirq), smr | srctype);
-	}
-
-	return 0;
-}
-
-static struct irq_chip at91_aic_chip = {
-	.name		= "AIC",
-	.irq_mask	= at91_aic_mask_irq,
-	.irq_unmask	= at91_aic_unmask_irq,
-	.irq_set_type	= at91_aic_set_type,
-	.irq_set_wake	= at91_aic_set_wake,
-	.irq_eoi	= at91_aic_eoi,
-};
-
-static void __init at91_aic_hw_init(unsigned int spu_vector)
-{
-	int i;
-
-	/*
-	 * Perform 8 End Of Interrupt Command to make sure AIC
-	 * will not Lock out nIRQ
-	 */
-	for (i = 0; i < 8; i++)
-		at91_aic_write(AT91_AIC_EOICR, 0);
-
-	/*
-	 * Spurious Interrupt ID in Spurious Vector Register.
-	 * When there is no current interrupt, the IRQ Vector Register
-	 * reads the value stored in AIC_SPU
-	 */
-	at91_aic_write(AT91_AIC_SPU, spu_vector);
-
-	/* No debugging in AIC: Debug (Protect) Control Register */
-	at91_aic_write(AT91_AIC_DCR, 0);
-
-	/* Disable and clear all interrupts initially */
-	at91_aic_write(AT91_AIC_IDCR, 0xFFFFFFFF);
-	at91_aic_write(AT91_AIC_ICCR, 0xFFFFFFFF);
-}
-
-static void __init __maybe_unused at91_aic5_hw_init(unsigned int spu_vector)
-{
-	int i;
-
-	/*
-	 * Perform 8 End Of Interrupt Command to make sure AIC
-	 * will not Lock out nIRQ
-	 */
-	for (i = 0; i < 8; i++)
-		at91_aic_write(AT91_AIC5_EOICR, 0);
-
-	/*
-	 * Spurious Interrupt ID in Spurious Vector Register.
-	 * When there is no current interrupt, the IRQ Vector Register
-	 * reads the value stored in AIC_SPU
-	 */
-	at91_aic_write(AT91_AIC5_SPU, spu_vector);
-
-	/* No debugging in AIC: Debug (Protect) Control Register */
-	at91_aic_write(AT91_AIC5_DCR, 0);
-
-	/* Disable and clear all interrupts initially */
-	for (i = 0; i < n_irqs; i++) {
-		at91_aic_write(AT91_AIC5_SSR, i & AT91_AIC5_INTSEL_MSK);
-		at91_aic_write(AT91_AIC5_IDCR, 1);
-		at91_aic_write(AT91_AIC5_ICCR, 1);
-	}
-}
-
-#if defined(CONFIG_OF)
-static unsigned int *at91_aic_irq_priorities;
-
-static int at91_aic_irq_map(struct irq_domain *h, unsigned int virq,
-							irq_hw_number_t hw)
-{
-	/* Put virq number in Source Vector Register */
-	at91_aic_write(AT91_AIC_SVR(hw), virq);
-
-	/* Active Low interrupt, with priority */
-	at91_aic_write(AT91_AIC_SMR(hw),
-		       AT91_AIC_SRCTYPE_LOW | at91_aic_irq_priorities[hw]);
-
-	irq_set_chip_and_handler(virq, &at91_aic_chip, handle_fasteoi_irq);
-	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
-
-	return 0;
-}
-
-static int at91_aic5_irq_map(struct irq_domain *h, unsigned int virq,
-		irq_hw_number_t hw)
-{
-	at91_aic_write(AT91_AIC5_SSR, hw & AT91_AIC5_INTSEL_MSK);
-
-	/* Put virq number in Source Vector Register */
-	at91_aic_write(AT91_AIC5_SVR, virq);
-
-	/* Active Low interrupt, with priority */
-	at91_aic_write(AT91_AIC5_SMR,
-		       AT91_AIC_SRCTYPE_LOW | at91_aic_irq_priorities[hw]);
-
-	irq_set_chip_and_handler(virq, &at91_aic_chip, handle_fasteoi_irq);
-	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
-
-	return 0;
-}
-
-static int at91_aic_irq_domain_xlate(struct irq_domain *d, struct device_node *ctrlr,
-				const u32 *intspec, unsigned int intsize,
-				irq_hw_number_t *out_hwirq, unsigned int *out_type)
-{
-	if (WARN_ON(intsize < 3))
-		return -EINVAL;
-	if (WARN_ON(intspec[0] >= n_irqs))
-		return -EINVAL;
-	if (WARN_ON((intspec[2] < AT91_AIC_IRQ_MIN_PRIORITY)
-		    || (intspec[2] > AT91_AIC_IRQ_MAX_PRIORITY)))
-		return -EINVAL;
-
-	*out_hwirq = intspec[0];
-	*out_type = intspec[1] & IRQ_TYPE_SENSE_MASK;
-	at91_aic_irq_priorities[*out_hwirq] = intspec[2];
-
-	return 0;
-}
-
-static struct irq_domain_ops at91_aic_irq_ops = {
-	.map	= at91_aic_irq_map,
-	.xlate	= at91_aic_irq_domain_xlate,
-};
-
-int __init at91_aic_of_common_init(struct device_node *node,
-				    struct device_node *parent)
-{
-	struct property *prop;
-	const __be32 *p;
-	u32 val;
-
-	at91_extern_irq = kzalloc(BITS_TO_LONGS(n_irqs)
-				  * sizeof(*at91_extern_irq), GFP_KERNEL);
-	if (!at91_extern_irq)
-		return -ENOMEM;
-
-	if (at91_aic_pm_init()) {
-		kfree(at91_extern_irq);
-		return -ENOMEM;
-	}
-
-	at91_aic_irq_priorities = kzalloc(n_irqs
-					  * sizeof(*at91_aic_irq_priorities),
-					  GFP_KERNEL);
-	if (!at91_aic_irq_priorities)
-		return -ENOMEM;
-
-	at91_aic_base = of_iomap(node, 0);
-	at91_aic_np = node;
-
-	at91_aic_domain = irq_domain_add_linear(at91_aic_np, n_irqs,
-						&at91_aic_irq_ops, NULL);
-	if (!at91_aic_domain)
-		panic("Unable to add AIC irq domain (DT)\n");
-
-	of_property_for_each_u32(node, "atmel,external-irqs", prop, p, val) {
-		if (val >= n_irqs)
-			pr_warn("AIC: external irq %d >= %d skip it\n",
-				val, n_irqs);
-		else
-			set_bit(val, at91_extern_irq);
-	}
-
-	irq_set_default_host(at91_aic_domain);
-
-	return 0;
-}
-
-int __init at91_aic_of_init(struct device_node *node,
-				     struct device_node *parent)
-{
-	int err;
-
-	err = at91_aic_of_common_init(node, parent);
-	if (err)
-		return err;
-
-	at91_aic_hw_init(n_irqs);
-
-	return 0;
-}
-
-int __init at91_aic5_of_init(struct device_node *node,
-				     struct device_node *parent)
-{
-	int err;
-
-	at91_aic_caps |= AT91_AIC_CAP_AIC5;
-	n_irqs = NR_AIC5_IRQS;
-	at91_aic_chip.irq_ack           = at91_aic5_mask_irq;
-	at91_aic_chip.irq_mask		= at91_aic5_mask_irq;
-	at91_aic_chip.irq_unmask	= at91_aic5_unmask_irq;
-	at91_aic_chip.irq_eoi		= at91_aic5_eoi;
-	at91_aic_irq_ops.map		= at91_aic5_irq_map;
-
-	err = at91_aic_of_common_init(node, parent);
-	if (err)
-		return err;
-
-	at91_aic5_hw_init(n_irqs);
-
-	return 0;
-}
-#endif
-
-/*
- * Initialize the AIC interrupt controller.
- */
-void __init at91_aic_init(unsigned int *priority, unsigned int ext_irq_mask)
-{
-	unsigned int i;
-	int irq_base;
-
-	at91_extern_irq = kzalloc(BITS_TO_LONGS(n_irqs)
-				  * sizeof(*at91_extern_irq), GFP_KERNEL);
-
-	if (at91_aic_pm_init() || at91_extern_irq == NULL)
-		panic("Unable to allocate bit maps\n");
-
-	*at91_extern_irq = ext_irq_mask;
-
-	at91_aic_base = ioremap(AT91_AIC, 512);
-	if (!at91_aic_base)
-		panic("Unable to ioremap AIC registers\n");
-
-	/* Add irq domain for AIC */
-	irq_base = irq_alloc_descs(-1, 0, n_irqs, 0);
-	if (irq_base < 0) {
-		WARN(1, "Cannot allocate irq_descs, assuming pre-allocated\n");
-		irq_base = 0;
-	}
-	at91_aic_domain = irq_domain_add_legacy(at91_aic_np, n_irqs,
-						irq_base, 0,
-						&irq_domain_simple_ops, NULL);
-
-	if (!at91_aic_domain)
-		panic("Unable to add AIC irq domain\n");
-
-	irq_set_default_host(at91_aic_domain);
-
-	/*
-	 * The IVR is used by macro get_irqnr_and_base to read and verify.
-	 * The irq number is NR_AIC_IRQS when a spurious interrupt has occurred.
-	 */
-	for (i = 0; i < n_irqs; i++) {
-		/* Put hardware irq number in Source Vector Register: */
-		at91_aic_write(AT91_AIC_SVR(i), NR_IRQS_LEGACY + i);
-		/* Active Low interrupt, with the specified priority */
-		at91_aic_write(AT91_AIC_SMR(i), AT91_AIC_SRCTYPE_LOW | priority[i]);
-		irq_set_chip_and_handler(NR_IRQS_LEGACY + i, &at91_aic_chip, handle_fasteoi_irq);
-		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
-	}
-
-	at91_aic_hw_init(n_irqs);
-}
diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 530db30..d2a24e8 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -26,9 +26,9 @@
 #include <asm/mach/irq.h>
 
 #include <mach/at91_pmc.h>
+#include <mach/at91_aic.h>
 #include <mach/cpu.h>
 
-#include "at91_aic.h"
 #include "generic.h"
 #include "pm.h"
 
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index cda4cb5..208b708 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_IRQCHIP)			+= irqchip.o
 
+obj-$(CONFIG_ARCH_AT91)			+= irq-at91.o
 obj-$(CONFIG_ARCH_BCM2835)		+= irq-bcm2835.o
 obj-$(CONFIG_ARCH_EXYNOS)		+= exynos-combiner.o
 obj-$(CONFIG_ARCH_MVEBU)		+= irq-armada-370-xp.o
diff --git a/drivers/irqchip/irq-at91.c b/drivers/irqchip/irq-at91.c
new file mode 100644
index 0000000..daf2959
--- /dev/null
+++ b/drivers/irqchip/irq-at91.c
@@ -0,0 +1,547 @@
+/*
+ * linux/arch/arm/mach-at91/irq.c
+ *
+ *  Copyright (C) 2004 SAN People
+ *  Copyright (C) 2004 ATMEL
+ *  Copyright (C) Rick Bronson
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/bitmap.h>
+#include <linux/types.h>
+#include <linux/irq.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/irqdomain.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+
+#include <mach/hardware.h>
+#include <asm/irq.h>
+#include <asm/setup.h>
+
+#include <asm/exception.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/irq.h>
+#include <asm/mach/map.h>
+
+#include <mach/at91_aic.h>
+
+void __iomem *at91_aic_base;
+static struct irq_domain *at91_aic_domain;
+static struct device_node *at91_aic_np;
+static unsigned int n_irqs = NR_AIC_IRQS;
+static unsigned long at91_aic_caps = 0;
+
+/* AIC5 introduces a Source Select Register */
+#define AT91_AIC_CAP_AIC5	(1 << 0)
+#define has_aic5()		(at91_aic_caps & AT91_AIC_CAP_AIC5)
+
+#ifdef CONFIG_PM
+
+static unsigned long *wakeups;
+static unsigned long *backups;
+
+#define set_backup(bit) set_bit(bit, backups)
+#define clear_backup(bit) clear_bit(bit, backups)
+
+static int at91_aic_pm_init(void)
+{
+	backups = kzalloc(BITS_TO_LONGS(n_irqs) * sizeof(*backups), GFP_KERNEL);
+	if (!backups)
+		return -ENOMEM;
+
+	wakeups = kzalloc(BITS_TO_LONGS(n_irqs) * sizeof(*backups), GFP_KERNEL);
+	if (!wakeups) {
+		kfree(backups);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int at91_aic_set_wake(struct irq_data *d, unsigned value)
+{
+	if (unlikely(d->hwirq >= n_irqs))
+		return -EINVAL;
+
+	if (value)
+		set_bit(d->hwirq, wakeups);
+	else
+		clear_bit(d->hwirq, wakeups);
+
+	return 0;
+}
+
+void at91_irq_suspend(void)
+{
+	int bit = -1;
+
+	if (has_aic5()) {
+		/* disable enabled irqs */
+		while ((bit = find_next_bit(backups, n_irqs, bit + 1)) < n_irqs) {
+			at91_aic_write(AT91_AIC5_SSR,
+				       bit & AT91_AIC5_INTSEL_MSK);
+			at91_aic_write(AT91_AIC5_IDCR, 1);
+		}
+		/* enable wakeup irqs */
+		bit = -1;
+		while ((bit = find_next_bit(wakeups, n_irqs, bit + 1)) < n_irqs) {
+			at91_aic_write(AT91_AIC5_SSR,
+				       bit & AT91_AIC5_INTSEL_MSK);
+			at91_aic_write(AT91_AIC5_IECR, 1);
+		}
+	} else {
+		at91_aic_write(AT91_AIC_IDCR, *backups);
+		at91_aic_write(AT91_AIC_IECR, *wakeups);
+	}
+}
+
+void at91_irq_resume(void)
+{
+	int bit = -1;
+
+	if (has_aic5()) {
+		/* disable wakeup irqs */
+		while ((bit = find_next_bit(wakeups, n_irqs, bit + 1)) < n_irqs) {
+			at91_aic_write(AT91_AIC5_SSR,
+				       bit & AT91_AIC5_INTSEL_MSK);
+			at91_aic_write(AT91_AIC5_IDCR, 1);
+		}
+		/* enable irqs disabled for suspend */
+		bit = -1;
+		while ((bit = find_next_bit(backups, n_irqs, bit + 1)) < n_irqs) {
+			at91_aic_write(AT91_AIC5_SSR,
+				       bit & AT91_AIC5_INTSEL_MSK);
+			at91_aic_write(AT91_AIC5_IECR, 1);
+		}
+	} else {
+		at91_aic_write(AT91_AIC_IDCR, *wakeups);
+		at91_aic_write(AT91_AIC_IECR, *backups);
+	}
+}
+
+#else
+static inline int at91_aic_pm_init(void)
+{
+	return 0;
+}
+
+#define set_backup(bit)
+#define clear_backup(bit)
+#define at91_aic_set_wake	NULL
+
+#endif /* CONFIG_PM */
+
+asmlinkage void __exception_irq_entry
+at91_aic_handle_irq(struct pt_regs *regs)
+{
+	u32 irqnr;
+	u32 irqstat;
+
+	irqnr = at91_aic_read(AT91_AIC_IVR);
+	irqstat = at91_aic_read(AT91_AIC_ISR);
+
+	/*
+	 * ISR value is 0 when there is no current interrupt or when there is
+	 * a spurious interrupt
+	 */
+	if (!irqstat)
+		at91_aic_write(AT91_AIC_EOICR, 0);
+	else
+		handle_IRQ(irqnr, regs);
+}
+
+asmlinkage void __exception_irq_entry
+at91_aic5_handle_irq(struct pt_regs *regs)
+{
+	u32 irqnr;
+	u32 irqstat;
+
+	irqnr = at91_aic_read(AT91_AIC5_IVR);
+	irqstat = at91_aic_read(AT91_AIC5_ISR);
+
+	if (!irqstat)
+		at91_aic_write(AT91_AIC5_EOICR, 0);
+	else
+		handle_IRQ(irqnr, regs);
+}
+
+static void at91_aic_mask_irq(struct irq_data *d)
+{
+	/* Disable interrupt on AIC */
+	at91_aic_write(AT91_AIC_IDCR, 1 << d->hwirq);
+	/* Update ISR cache */
+	clear_backup(d->hwirq);
+}
+
+static void __maybe_unused at91_aic5_mask_irq(struct irq_data *d)
+{
+	/* Disable interrupt on AIC5 */
+	at91_aic_write(AT91_AIC5_SSR, d->hwirq & AT91_AIC5_INTSEL_MSK);
+	at91_aic_write(AT91_AIC5_IDCR, 1);
+	/* Update ISR cache */
+	clear_backup(d->hwirq);
+}
+
+static void at91_aic_unmask_irq(struct irq_data *d)
+{
+	/* Enable interrupt on AIC */
+	at91_aic_write(AT91_AIC_IECR, 1 << d->hwirq);
+	/* Update ISR cache */
+	set_backup(d->hwirq);
+}
+
+static void __maybe_unused at91_aic5_unmask_irq(struct irq_data *d)
+{
+	/* Enable interrupt on AIC5 */
+	at91_aic_write(AT91_AIC5_SSR, d->hwirq & AT91_AIC5_INTSEL_MSK);
+	at91_aic_write(AT91_AIC5_IECR, 1);
+	/* Update ISR cache */
+	set_backup(d->hwirq);
+}
+
+static void at91_aic_eoi(struct irq_data *d)
+{
+	/*
+	 * Mark end-of-interrupt on AIC, the controller doesn't care about
+	 * the value written. Moreover it's a write-only register.
+	 */
+	at91_aic_write(AT91_AIC_EOICR, 0);
+}
+
+static void __maybe_unused at91_aic5_eoi(struct irq_data *d)
+{
+	at91_aic_write(AT91_AIC5_EOICR, 0);
+}
+
+unsigned long *at91_extern_irq;
+
+#define is_extern_irq(hwirq) test_bit(hwirq, at91_extern_irq)
+
+static int at91_aic_compute_srctype(struct irq_data *d, unsigned type)
+{
+	int srctype;
+
+	switch (type) {
+	case IRQ_TYPE_LEVEL_HIGH:
+		srctype = AT91_AIC_SRCTYPE_HIGH;
+		break;
+	case IRQ_TYPE_EDGE_RISING:
+		srctype = AT91_AIC_SRCTYPE_RISING;
+		break;
+	case IRQ_TYPE_LEVEL_LOW:
+		if ((d->hwirq == AT91_ID_FIQ) || is_extern_irq(d->hwirq))		/* only supported on external interrupts */
+			srctype = AT91_AIC_SRCTYPE_LOW;
+		else
+			srctype = -EINVAL;
+		break;
+	case IRQ_TYPE_EDGE_FALLING:
+		if ((d->hwirq == AT91_ID_FIQ) || is_extern_irq(d->hwirq))		/* only supported on external interrupts */
+			srctype = AT91_AIC_SRCTYPE_FALLING;
+		else
+			srctype = -EINVAL;
+		break;
+	default:
+		srctype = -EINVAL;
+	}
+
+	return srctype;
+}
+
+static int at91_aic_set_type(struct irq_data *d, unsigned type)
+{
+	unsigned int smr;
+	int srctype;
+
+	srctype = at91_aic_compute_srctype(d, type);
+	if (srctype < 0)
+		return srctype;
+
+	if (has_aic5()) {
+		at91_aic_write(AT91_AIC5_SSR,
+			       d->hwirq & AT91_AIC5_INTSEL_MSK);
+		smr = at91_aic_read(AT91_AIC5_SMR) & ~AT91_AIC_SRCTYPE;
+		at91_aic_write(AT91_AIC5_SMR, smr | srctype);
+	} else {
+		smr = at91_aic_read(AT91_AIC_SMR(d->hwirq))
+		      & ~AT91_AIC_SRCTYPE;
+		at91_aic_write(AT91_AIC_SMR(d->hwirq), smr | srctype);
+	}
+
+	return 0;
+}
+
+static struct irq_chip at91_aic_chip = {
+	.name		= "AIC",
+	.irq_mask	= at91_aic_mask_irq,
+	.irq_unmask	= at91_aic_unmask_irq,
+	.irq_set_type	= at91_aic_set_type,
+	.irq_set_wake	= at91_aic_set_wake,
+	.irq_eoi	= at91_aic_eoi,
+};
+
+static void __init at91_aic_hw_init(unsigned int spu_vector)
+{
+	int i;
+
+	/*
+	 * Perform 8 End Of Interrupt Command to make sure AIC
+	 * will not Lock out nIRQ
+	 */
+	for (i = 0; i < 8; i++)
+		at91_aic_write(AT91_AIC_EOICR, 0);
+
+	/*
+	 * Spurious Interrupt ID in Spurious Vector Register.
+	 * When there is no current interrupt, the IRQ Vector Register
+	 * reads the value stored in AIC_SPU
+	 */
+	at91_aic_write(AT91_AIC_SPU, spu_vector);
+
+	/* No debugging in AIC: Debug (Protect) Control Register */
+	at91_aic_write(AT91_AIC_DCR, 0);
+
+	/* Disable and clear all interrupts initially */
+	at91_aic_write(AT91_AIC_IDCR, 0xFFFFFFFF);
+	at91_aic_write(AT91_AIC_ICCR, 0xFFFFFFFF);
+}
+
+static void __init __maybe_unused at91_aic5_hw_init(unsigned int spu_vector)
+{
+	int i;
+
+	/*
+	 * Perform 8 End Of Interrupt Command to make sure AIC
+	 * will not Lock out nIRQ
+	 */
+	for (i = 0; i < 8; i++)
+		at91_aic_write(AT91_AIC5_EOICR, 0);
+
+	/*
+	 * Spurious Interrupt ID in Spurious Vector Register.
+	 * When there is no current interrupt, the IRQ Vector Register
+	 * reads the value stored in AIC_SPU
+	 */
+	at91_aic_write(AT91_AIC5_SPU, spu_vector);
+
+	/* No debugging in AIC: Debug (Protect) Control Register */
+	at91_aic_write(AT91_AIC5_DCR, 0);
+
+	/* Disable and clear all interrupts initially */
+	for (i = 0; i < n_irqs; i++) {
+		at91_aic_write(AT91_AIC5_SSR, i & AT91_AIC5_INTSEL_MSK);
+		at91_aic_write(AT91_AIC5_IDCR, 1);
+		at91_aic_write(AT91_AIC5_ICCR, 1);
+	}
+}
+
+#if defined(CONFIG_OF)
+static unsigned int *at91_aic_irq_priorities;
+
+static int at91_aic_irq_map(struct irq_domain *h, unsigned int virq,
+							irq_hw_number_t hw)
+{
+	/* Put virq number in Source Vector Register */
+	at91_aic_write(AT91_AIC_SVR(hw), virq);
+
+	/* Active Low interrupt, with priority */
+	at91_aic_write(AT91_AIC_SMR(hw),
+		       AT91_AIC_SRCTYPE_LOW | at91_aic_irq_priorities[hw]);
+
+	irq_set_chip_and_handler(virq, &at91_aic_chip, handle_fasteoi_irq);
+	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
+
+	return 0;
+}
+
+static int at91_aic5_irq_map(struct irq_domain *h, unsigned int virq,
+		irq_hw_number_t hw)
+{
+	at91_aic_write(AT91_AIC5_SSR, hw & AT91_AIC5_INTSEL_MSK);
+
+	/* Put virq number in Source Vector Register */
+	at91_aic_write(AT91_AIC5_SVR, virq);
+
+	/* Active Low interrupt, with priority */
+	at91_aic_write(AT91_AIC5_SMR,
+		       AT91_AIC_SRCTYPE_LOW | at91_aic_irq_priorities[hw]);
+
+	irq_set_chip_and_handler(virq, &at91_aic_chip, handle_fasteoi_irq);
+	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
+
+	return 0;
+}
+
+static int at91_aic_irq_domain_xlate(struct irq_domain *d, struct device_node *ctrlr,
+				const u32 *intspec, unsigned int intsize,
+				irq_hw_number_t *out_hwirq, unsigned int *out_type)
+{
+	if (WARN_ON(intsize < 3))
+		return -EINVAL;
+	if (WARN_ON(intspec[0] >= n_irqs))
+		return -EINVAL;
+	if (WARN_ON((intspec[2] < AT91_AIC_IRQ_MIN_PRIORITY)
+		    || (intspec[2] > AT91_AIC_IRQ_MAX_PRIORITY)))
+		return -EINVAL;
+
+	*out_hwirq = intspec[0];
+	*out_type = intspec[1] & IRQ_TYPE_SENSE_MASK;
+	at91_aic_irq_priorities[*out_hwirq] = intspec[2];
+
+	return 0;
+}
+
+static struct irq_domain_ops at91_aic_irq_ops = {
+	.map	= at91_aic_irq_map,
+	.xlate	= at91_aic_irq_domain_xlate,
+};
+
+int __init at91_aic_of_common_init(struct device_node *node,
+				    struct device_node *parent)
+{
+	struct property *prop;
+	const __be32 *p;
+	u32 val;
+
+	at91_extern_irq = kzalloc(BITS_TO_LONGS(n_irqs)
+				  * sizeof(*at91_extern_irq), GFP_KERNEL);
+	if (!at91_extern_irq)
+		return -ENOMEM;
+
+	if (at91_aic_pm_init()) {
+		kfree(at91_extern_irq);
+		return -ENOMEM;
+	}
+
+	at91_aic_irq_priorities = kzalloc(n_irqs
+					  * sizeof(*at91_aic_irq_priorities),
+					  GFP_KERNEL);
+	if (!at91_aic_irq_priorities)
+		return -ENOMEM;
+
+	at91_aic_base = of_iomap(node, 0);
+	at91_aic_np = node;
+
+	at91_aic_domain = irq_domain_add_linear(at91_aic_np, n_irqs,
+						&at91_aic_irq_ops, NULL);
+	if (!at91_aic_domain)
+		panic("Unable to add AIC irq domain (DT)\n");
+
+	of_property_for_each_u32(node, "atmel,external-irqs", prop, p, val) {
+		if (val >= n_irqs)
+			pr_warn("AIC: external irq %d >= %d skip it\n",
+				val, n_irqs);
+		else
+			set_bit(val, at91_extern_irq);
+	}
+
+	irq_set_default_host(at91_aic_domain);
+
+	return 0;
+}
+
+int __init at91_aic_of_init(struct device_node *node,
+				     struct device_node *parent)
+{
+	int err;
+
+	err = at91_aic_of_common_init(node, parent);
+	if (err)
+		return err;
+
+	at91_aic_hw_init(n_irqs);
+
+	return 0;
+}
+
+int __init at91_aic5_of_init(struct device_node *node,
+				     struct device_node *parent)
+{
+	int err;
+
+	at91_aic_caps |= AT91_AIC_CAP_AIC5;
+	n_irqs = NR_AIC5_IRQS;
+	at91_aic_chip.irq_ack           = at91_aic5_mask_irq;
+	at91_aic_chip.irq_mask		= at91_aic5_mask_irq;
+	at91_aic_chip.irq_unmask	= at91_aic5_unmask_irq;
+	at91_aic_chip.irq_eoi		= at91_aic5_eoi;
+	at91_aic_irq_ops.map		= at91_aic5_irq_map;
+
+	err = at91_aic_of_common_init(node, parent);
+	if (err)
+		return err;
+
+	at91_aic5_hw_init(n_irqs);
+
+	return 0;
+}
+#endif
+
+/*
+ * Initialize the AIC interrupt controller.
+ */
+void __init at91_aic_init(unsigned int *priority, unsigned int ext_irq_mask)
+{
+	unsigned int i;
+	int irq_base;
+
+	at91_extern_irq = kzalloc(BITS_TO_LONGS(n_irqs)
+				  * sizeof(*at91_extern_irq), GFP_KERNEL);
+
+	if (at91_aic_pm_init() || at91_extern_irq == NULL)
+		panic("Unable to allocate bit maps\n");
+
+	*at91_extern_irq = ext_irq_mask;
+
+	at91_aic_base = ioremap(AT91_AIC, 512);
+	if (!at91_aic_base)
+		panic("Unable to ioremap AIC registers\n");
+
+	/* Add irq domain for AIC */
+	irq_base = irq_alloc_descs(-1, 0, n_irqs, 0);
+	if (irq_base < 0) {
+		WARN(1, "Cannot allocate irq_descs, assuming pre-allocated\n");
+		irq_base = 0;
+	}
+	at91_aic_domain = irq_domain_add_legacy(at91_aic_np, n_irqs,
+						irq_base, 0,
+						&irq_domain_simple_ops, NULL);
+
+	if (!at91_aic_domain)
+		panic("Unable to add AIC irq domain\n");
+
+	irq_set_default_host(at91_aic_domain);
+
+	/*
+	 * The IVR is used by macro get_irqnr_and_base to read and verify.
+	 * The irq number is NR_AIC_IRQS when a spurious interrupt has occurred.
+	 */
+	for (i = 0; i < n_irqs; i++) {
+		/* Put hardware irq number in Source Vector Register: */
+		at91_aic_write(AT91_AIC_SVR(i), NR_IRQS_LEGACY + i);
+		/* Active Low interrupt, with the specified priority */
+		at91_aic_write(AT91_AIC_SMR(i), AT91_AIC_SRCTYPE_LOW | priority[i]);
+		irq_set_chip_and_handler(NR_IRQS_LEGACY + i, &at91_aic_chip, handle_fasteoi_irq);
+		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
+	}
+
+	at91_aic_hw_init(n_irqs);
+}
-- 
1.7.9.5

