Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750978AbaHTNje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:39:34 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:49136 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaHTNjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:39:31 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 2/2] ARM: shmobile: Move legacy INTC definitions from irqs.h to intc.h
Date: Wed, 20 Aug 2014 15:39:23 +0200
Message-Id: <1408541963-20736-3-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408541963-20736-1-git-send-email-geert+renesas@glider.be>
References: <1408541963-20736-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move all definitions for legacy INTC from the common "irqs.h" to the
INTC-specific "intc.h".
Include "intc.h" in sh7372/sh73a0 CPU and board files where needed.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/arm/mach-shmobile/board-kzm9g.c    | 1 +
 arch/arm/mach-shmobile/board-mackerel.c | 1 +
 arch/arm/mach-shmobile/intc.h           | 6 ++++++
 arch/arm/mach-shmobile/irqs.h           | 6 ------
 arch/arm/mach-shmobile/setup-sh7372.c   | 1 +
 arch/arm/mach-shmobile/setup-sh73a0.c   | 1 +
 6 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-shmobile/board-kzm9g.c b/arch/arm/mach-shmobile/board-kzm9g.c
index 36593cb20e57..77e36fa0b142 100644
--- a/arch/arm/mach-shmobile/board-kzm9g.c
+++ b/arch/arm/mach-shmobile/board-kzm9g.c
@@ -50,6 +50,7 @@
 #include <video/sh_mobile_lcdc.h>
 
 #include "common.h"
+#include "intc.h"
 #include "irqs.h"
 #include "sh73a0.h"
 
diff --git a/arch/arm/mach-shmobile/board-mackerel.c b/arch/arm/mach-shmobile/board-mackerel.c
index 79f448e93abb..b7c4261492b0 100644
--- a/arch/arm/mach-shmobile/board-mackerel.c
+++ b/arch/arm/mach-shmobile/board-mackerel.c
@@ -63,6 +63,7 @@
 #include <asm/mach-types.h>
 
 #include "common.h"
+#include "intc.h"
 #include "irqs.h"
 #include "pm-rmobile.h"
 #include "sh-gpio.h"
diff --git a/arch/arm/mach-shmobile/intc.h b/arch/arm/mach-shmobile/intc.h
index a5603c76cfe0..0313cf798c32 100644
--- a/arch/arm/mach-shmobile/intc.h
+++ b/arch/arm/mach-shmobile/intc.h
@@ -1,5 +1,6 @@
 #ifndef __ASM_MACH_INTC_H
 #define __ASM_MACH_INTC_H
+
 #include <linux/sh_intc.h>
 
 #define INTC_IRQ_PINS_ENUM_16L(p)				\
@@ -287,4 +288,9 @@ static struct intc_desc p ## _desc __initdata = {			\
 			     p ## _sense_registers, NULL),		\
 }
 
+/* INTCS */
+#define INTCS_VECT_BASE		0x3400
+#define INTCS_VECT(n, vect)	INTC_VECT((n), INTCS_VECT_BASE + (vect))
+#define intcs_evt2irq(evt)	evt2irq(INTCS_VECT_BASE + (evt))
+
 #endif  /* __ASM_MACH_INTC_H */
diff --git a/arch/arm/mach-shmobile/irqs.h b/arch/arm/mach-shmobile/irqs.h
index 8e28223f1b3c..3070f6d887eb 100644
--- a/arch/arm/mach-shmobile/irqs.h
+++ b/arch/arm/mach-shmobile/irqs.h
@@ -1,18 +1,12 @@
 #ifndef __SHMOBILE_IRQS_H
 #define __SHMOBILE_IRQS_H
 
-#include <linux/sh_intc.h>
 #include "include/mach/irqs.h"
 
 /* GIC */
 #define gic_spi(nr)		((nr) + 32)
 #define gic_iid(nr)		(nr) /* ICCIAR / interrupt ID */
 
-/* INTCS */
-#define INTCS_VECT_BASE		0x3400
-#define INTCS_VECT(n, vect)	INTC_VECT((n), INTCS_VECT_BASE + (vect))
-#define intcs_evt2irq(evt)	evt2irq(INTCS_VECT_BASE + (evt))
-
 /* GPIO IRQ */
 #define _GPIO_IRQ_BASE		2500
 #define GPIO_IRQ_BASE(x)	(_GPIO_IRQ_BASE + (32 * x))
diff --git a/arch/arm/mach-shmobile/setup-sh7372.c b/arch/arm/mach-shmobile/setup-sh7372.c
index 3731eccccef4..eaf5d1332c4b 100644
--- a/arch/arm/mach-shmobile/setup-sh7372.c
+++ b/arch/arm/mach-shmobile/setup-sh7372.c
@@ -41,6 +41,7 @@
 
 #include "common.h"
 #include "dma-register.h"
+#include "intc.h"
 #include "irqs.h"
 #include "pm-rmobile.h"
 #include "sh7372.h"
diff --git a/arch/arm/mach-shmobile/setup-sh73a0.c b/arch/arm/mach-shmobile/setup-sh73a0.c
index e7a0296b81b1..4c7022830e30 100644
--- a/arch/arm/mach-shmobile/setup-sh73a0.c
+++ b/arch/arm/mach-shmobile/setup-sh73a0.c
@@ -40,6 +40,7 @@
 
 #include "common.h"
 #include "dma-register.h"
+#include "intc.h"
 #include "irqs.h"
 #include "sh73a0.h"
 
-- 
1.9.1

