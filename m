Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbaG1VTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:19:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59258 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbaG1VSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:18:01 -0400
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        <bcousson@baylibre.com>, <linux@arm.linux.org.uk>,
        <khilman@deeprootsystems.com>, <tglx@linutronix.de>,
        <jason@lakedaemon.net>, <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 31/35] arm: omap: irq: move irq.c to drivers/irqchip/
Date: Mon, 28 Jul 2014 16:16:19 -0500
Message-ID: <1406582183-696-32-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.1.563.g66f467c
In-Reply-To: <1406582183-696-1-git-send-email-balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just move the code over as it has no dependencies
on arch/arm/ anymore.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/Kconfig                                  | 1 +
 arch/arm/mach-omap2/Makefile                                 | 3 +--
 drivers/irqchip/Kconfig                                      | 5 +++++
 drivers/irqchip/Makefile                                     | 1 +
 arch/arm/mach-omap2/irq.c => drivers/irqchip/irq-omap-intc.c | 9 +++++----
 5 files changed, 13 insertions(+), 6 deletions(-)
 rename arch/arm/mach-omap2/irq.c => drivers/irqchip/irq-omap-intc.c (98%)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 1c1ed73..97e2216 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -92,6 +92,7 @@ config ARCH_OMAP2PLUS
 	select PINCTRL
 	select SOC_BUS
 	select TI_PRIV_EDMA
+	select OMAP_IRQCHIP
 	help
 	  Systems based on OMAP2, OMAP3, OMAP4 or OMAP5
 
diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 8ca99e9..f6eb43c 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -10,7 +10,6 @@ obj-y := id.o io.o control.o mux.o devices.o fb.o serial.o gpmc.o timer.o pm.o \
 	 common.o gpio.o dma.o wd_timer.o display.o i2c.o hdq1w.o omap_hwmod.o \
 	 omap_device.o sram.o drm.o
 
-omap-2-3-common				= irq.o
 hwmod-common				= omap_hwmod.o omap_hwmod_reset.o \
 					  omap_hwmod_common_data.o
 clock-common				= clock.o clock_common_data.o \
@@ -20,7 +19,7 @@ secure-common				= omap-smc.o omap-secure.o
 obj-$(CONFIG_ARCH_OMAP2) += $(omap-2-3-common) $(hwmod-common)
 obj-$(CONFIG_ARCH_OMAP3) += $(omap-2-3-common) $(hwmod-common) $(secure-common)
 obj-$(CONFIG_ARCH_OMAP4) += $(hwmod-common) $(secure-common)
-obj-$(CONFIG_SOC_AM33XX) += irq.o $(hwmod-common)
+obj-$(CONFIG_SOC_AM33XX) += $(hwmod-common)
 obj-$(CONFIG_SOC_OMAP5)	 += $(hwmod-common) $(secure-common)
 obj-$(CONFIG_SOC_AM43XX) += $(hwmod-common) $(secure-common)
 obj-$(CONFIG_SOC_DRA7XX) += $(hwmod-common) $(secure-common)
diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index bbb746e..2db68b5 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -53,6 +53,11 @@ config CLPS711X_IRQCHIP
 	select SPARSE_IRQ
 	default y
 
+config OMAP_IRQCHIP
+	bool
+	select GENERIC_IRQ_CHIP
+	select IRQ_DOMAIN
+
 config ORION_IRQCHIP
 	bool
 	select IRQ_DOMAIN
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 62a13e5..87f26de 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_METAG_PERFCOUNTER_IRQS)	+= irq-metag.o
 obj-$(CONFIG_ARCH_MOXART)		+= irq-moxart.o
 obj-$(CONFIG_CLPS711X_IRQCHIP)		+= irq-clps711x.o
 obj-$(CONFIG_ORION_IRQCHIP)		+= irq-orion.o
+obj-$(CONFIG_OMAP_IRQCHIP)		+= irq-omap-intc.o
 obj-$(CONFIG_ARCH_SUNXI)		+= irq-sun4i.o
 obj-$(CONFIG_ARCH_SUNXI)		+= irq-sunxi-nmi.o
 obj-$(CONFIG_ARCH_SPEAR3XX)		+= spear-shirq.o
diff --git a/arch/arm/mach-omap2/irq.c b/drivers/irqchip/irq-omap-intc.c
similarity index 98%
rename from arch/arm/mach-omap2/irq.c
rename to drivers/irqchip/irq-omap-intc.c
index ed249c7..30f5fa0 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/drivers/irqchip/irq-omap-intc.c
@@ -17,16 +17,17 @@
 #include <linux/io.h>
 
 #include <asm/exception.h>
-#include <asm/mach/irq.h>
 #include <linux/irqdomain.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/irqchip/irq-omap-intc.h>
 
-#include "soc.h"
-#include "common.h"
-#include "../../drivers/irqchip/irqchip.h"
+#include "irqchip.h"
+
+/* Define these here for now until we drop all board-files */
+#define OMAP24XX_IC_BASE	0x480fe000
+#define OMAP34XX_IC_BASE	0x48200000
 
 /* selected INTC register offsets */
 
-- 
2.0.1.563.g66f467c

