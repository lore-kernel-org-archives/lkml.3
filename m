Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbaG1VWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:22:53 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37277 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbaG1VRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:17:47 -0400
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
Subject: [PATCH 30/35] irqchip: add irq-omap-intc.h header
Date: Mon, 28 Jul 2014 16:16:18 -0500
Message-ID: <1406582183-696-31-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.1.563.g66f467c
In-Reply-To: <1406582183-696-1-git-send-email-balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP INTC irqchip driver will be moved under
drivers/irqchip/ soon but we still have a dependency
with mach-omap2 when it comes to idle functions.

In order to make it easy to share those function
prototypes with OMAP PM code, we introduce this new
header.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/board-3430sdp.c        |  1 +
 arch/arm/mach-omap2/board-am3517crane.c    |  1 +
 arch/arm/mach-omap2/board-am3517evm.c      |  1 +
 arch/arm/mach-omap2/board-cm-t35.c         |  1 +
 arch/arm/mach-omap2/board-cm-t3517.c       |  1 +
 arch/arm/mach-omap2/board-devkit8000.c     |  1 +
 arch/arm/mach-omap2/board-ldp.c            |  1 +
 arch/arm/mach-omap2/board-omap3beagle.c    |  1 +
 arch/arm/mach-omap2/board-omap3logic.c     |  1 +
 arch/arm/mach-omap2/board-omap3pandora.c   |  1 +
 arch/arm/mach-omap2/board-omap3stalker.c   |  1 +
 arch/arm/mach-omap2/board-omap3touchbook.c |  1 +
 arch/arm/mach-omap2/board-overo.c          |  1 +
 arch/arm/mach-omap2/board-rx51.c           |  1 +
 arch/arm/mach-omap2/board-ti8168evm.c      |  1 +
 arch/arm/mach-omap2/common.h               |  9 ---------
 arch/arm/mach-omap2/cpuidle34xx.c          |  1 +
 arch/arm/mach-omap2/irq.c                  |  1 +
 arch/arm/mach-omap2/pm24xx.c               |  1 +
 arch/arm/mach-omap2/pm34xx.c               |  1 +
 include/linux/irqchip/irq-omap-intc.h      | 32 ++++++++++++++++++++++++++++++
 21 files changed, 51 insertions(+), 9 deletions(-)
 create mode 100644 include/linux/irqchip/irq-omap-intc.h

diff --git a/arch/arm/mach-omap2/board-3430sdp.c b/arch/arm/mach-omap2/board-3430sdp.c
index d21a304..bd79a51 100644
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@ -27,6 +27,7 @@
 #include <linux/platform_data/spi-omap2-mcspi.h>
 #include <linux/platform_data/omap-twl4030.h>
 #include <linux/usb/phy.h>
+#include <linux/irqchip/irq-omap-intc.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/mach-omap2/board-am3517crane.c b/arch/arm/mach-omap2/board-am3517crane.c
index 212c316..1fdcd67 100644
--- a/arch/arm/mach-omap2/board-am3517crane.c
+++ b/arch/arm/mach-omap2/board-am3517crane.c
@@ -24,6 +24,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
+#include <linux/irqchip/irq-omap-intc.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/mach-omap2/board-am3517evm.c b/arch/arm/mach-omap2/board-am3517evm.c
index 1c091b3..117c07a 100644
--- a/arch/arm/mach-omap2/board-am3517evm.c
+++ b/arch/arm/mach-omap2/board-am3517evm.c
@@ -27,6 +27,7 @@
 #include <linux/mmc/host.h>
 #include <linux/usb/musb.h>
 #include <linux/platform_data/gpio-omap.h>
+#include <linux/irqchip/irq-omap-intc.h>
 
 #include "am35xx.h"
 #include <asm/mach-types.h>
diff --git a/arch/arm/mach-omap2/board-cm-t35.c b/arch/arm/mach-omap2/board-cm-t35.c
index c6df8ee..0e3e447 100644
--- a/arch/arm/mach-omap2/board-cm-t35.c
+++ b/arch/arm/mach-omap2/board-cm-t35.c
@@ -26,6 +26,7 @@
 #include <linux/delay.h>
 #include <linux/gpio.h>
 #include <linux/platform_data/gpio-omap.h>
+#include <linux/irqchip/irq-omap-intc.h>
 
 #include <linux/platform_data/at24.h>
 #include <linux/i2c/twl.h>
diff --git a/arch/arm/mach-omap2/board-cm-t3517.c b/arch/arm/mach-omap2/board-cm-t3517.c
index 8a2c167..8854878 100644
--- a/arch/arm/mach-omap2/board-cm-t3517.c
+++ b/arch/arm/mach-omap2/board-cm-t3517.c
@@ -34,6 +34,7 @@
 #include <linux/mtd/partitions.h>
 #include <linux/mmc/host.h>
 #include <linux/can/platform/ti_hecc.h>
+#include <linux/irqchip/irq-omap-intc.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index d8e4f34..be05a3e 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -24,6 +24,7 @@
 #include <linux/gpio.h>
 #include <linux/input.h>
 #include <linux/gpio_keys.h>
+#include <linux/irqchip/irq-omap-intc.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
diff --git a/arch/arm/mach-omap2/board-ldp.c b/arch/arm/mach-omap2/board-ldp.c
index c2975af..4c010c2 100644
--- a/arch/arm/mach-omap2/board-ldp.c
+++ b/arch/arm/mach-omap2/board-ldp.c
@@ -30,6 +30,7 @@
 #include <linux/mmc/host.h>
 #include <linux/usb/phy.h>
 #include <linux/platform_data/spi-omap2-mcspi.h>
+#include <linux/irqchip/irq-omap-intc.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index 81de1c6..26c3232 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -27,6 +27,7 @@
 #include <linux/gpio_keys.h>
 #include <linux/pm_opp.h>
 #include <linux/cpu.h>
+#include <linux/irqchip/irq-omap-intc.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
diff --git a/arch/arm/mach-omap2/board-omap3logic.c b/arch/arm/mach-omap2/board-omap3logic.c
index 6049f60..cd1bc90 100644
--- a/arch/arm/mach-omap2/board-omap3logic.c
+++ b/arch/arm/mach-omap2/board-omap3logic.c
@@ -23,6 +23,7 @@
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/gpio.h>
+#include <linux/irqchip/irq-omap-intc.h>
 
 #include <linux/regulator/fixed.h>
 #include <linux/regulator/machine.h>
diff --git a/arch/arm/mach-omap2/board-omap3pandora.c b/arch/arm/mach-omap2/board-omap3pandora.c
index f322016..72a3fae 100644
--- a/arch/arm/mach-omap2/board-omap3pandora.c
+++ b/arch/arm/mach-omap2/board-omap3pandora.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
+#include <linux/irqchip/irq-omap-intc.h>
 
 #include <linux/spi/spi.h>
 #include <linux/regulator/machine.h>
diff --git a/arch/arm/mach-omap2/board-omap3stalker.c b/arch/arm/mach-omap2/board-omap3stalker.c
index 6311f4b..8e93215 100644
--- a/arch/arm/mach-omap2/board-omap3stalker.c
+++ b/arch/arm/mach-omap2/board-omap3stalker.c
@@ -23,6 +23,7 @@
 #include <linux/gpio.h>
 #include <linux/input.h>
 #include <linux/gpio_keys.h>
+#include <linux/irqchip/irq-omap-intc.h>
 
 #include <linux/regulator/fixed.h>
 #include <linux/regulator/machine.h>
diff --git a/arch/arm/mach-omap2/board-omap3touchbook.c b/arch/arm/mach-omap2/board-omap3touchbook.c
index d454508..c86927b 100644
--- a/arch/arm/mach-omap2/board-omap3touchbook.c
+++ b/arch/arm/mach-omap2/board-omap3touchbook.c
@@ -23,6 +23,7 @@
 #include <linux/gpio.h>
 #include <linux/input.h>
 #include <linux/gpio_keys.h>
+#include <linux/irqchip/irq-omap-intc.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
diff --git a/arch/arm/mach-omap2/board-overo.c b/arch/arm/mach-omap2/board-overo.c
index 2dae6cc..628c96c 100644
--- a/arch/arm/mach-omap2/board-overo.c
+++ b/arch/arm/mach-omap2/board-overo.c
@@ -31,6 +31,7 @@
 #include <linux/regulator/machine.h>
 #include <linux/regulator/fixed.h>
 #include <linux/spi/spi.h>
+#include <linux/irqchip/irq-omap-intc.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
diff --git a/arch/arm/mach-omap2/board-rx51.c b/arch/arm/mach-omap2/board-rx51.c
index 2d1e5a6..d0b05e0 100644
--- a/arch/arm/mach-omap2/board-rx51.c
+++ b/arch/arm/mach-omap2/board-rx51.c
@@ -22,6 +22,7 @@
 #include <linux/usb/phy.h>
 #include <linux/usb/musb.h>
 #include <linux/platform_data/spi-omap2-mcspi.h>
+#include <linux/irqchip/irq-omap-intc.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/mach-omap2/board-ti8168evm.c b/arch/arm/mach-omap2/board-ti8168evm.c
index 6273c28..2707593 100644
--- a/arch/arm/mach-omap2/board-ti8168evm.c
+++ b/arch/arm/mach-omap2/board-ti8168evm.c
@@ -15,6 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/irqchip/irq-omap-intc.h>
 #include <linux/usb/musb.h>
 
 #include <asm/mach-types.h>
diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
index 1dd0021..7df6efd 100644
--- a/arch/arm/mach-omap2/common.h
+++ b/arch/arm/mach-omap2/common.h
@@ -210,15 +210,6 @@ extern struct device *omap2_get_iva_device(void);
 extern struct device *omap2_get_l3_device(void);
 extern struct device *omap4_get_dsp_device(void);
 
-void omap2_init_irq(void);
-void omap3_init_irq(void);
-void ti81xx_init_irq(void);
-extern int omap_irq_pending(void);
-void omap_intc_save_context(void);
-void omap_intc_restore_context(void);
-void omap3_intc_suspend(void);
-void omap3_intc_prepare_idle(void);
-void omap3_intc_resume_idle(void);
 void omap_gic_of_init(void);
 
 #ifdef CONFIG_CACHE_L2X0
diff --git a/arch/arm/mach-omap2/cpuidle34xx.c b/arch/arm/mach-omap2/cpuidle34xx.c
index e18709d..8f03ac0 100644
--- a/arch/arm/mach-omap2/cpuidle34xx.c
+++ b/arch/arm/mach-omap2/cpuidle34xx.c
@@ -27,6 +27,7 @@
 #include <linux/export.h>
 #include <linux/cpu_pm.h>
 #include <asm/cpuidle.h>
+#include <linux/irqchip/irq-omap-intc.h>
 
 #include "powerdomain.h"
 #include "clockdomain.h"
diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
index b2993e4..ed249c7 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -22,6 +22,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/irqchip/irq-omap-intc.h>
 
 #include "soc.h"
 #include "common.h"
diff --git a/arch/arm/mach-omap2/pm24xx.c b/arch/arm/mach-omap2/pm24xx.c
index a5ea988..b912a84 100644
--- a/arch/arm/mach-omap2/pm24xx.c
+++ b/arch/arm/mach-omap2/pm24xx.c
@@ -30,6 +30,7 @@
 #include <linux/time.h>
 #include <linux/gpio.h>
 #include <linux/platform_data/gpio-omap.h>
+#include <linux/irqchip/irq-omap-intc.h>
 
 #include <asm/fncpy.h>
 
diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
index 507d8ee..320e7f2 100644
--- a/arch/arm/mach-omap2/pm34xx.c
+++ b/arch/arm/mach-omap2/pm34xx.c
@@ -30,6 +30,7 @@
 #include <linux/slab.h>
 #include <linux/omap-dma.h>
 #include <linux/platform_data/gpio-omap.h>
+#include <linux/irqchip/irq-omap-intc.h>
 
 #include <trace/events/power.h>
 
diff --git a/include/linux/irqchip/irq-omap-intc.h b/include/linux/irqchip/irq-omap-intc.h
new file mode 100644
index 0000000..e06b370
--- /dev/null
+++ b/include/linux/irqchip/irq-omap-intc.h
@@ -0,0 +1,32 @@
+/**
+ * irq-omap-intc.h - INTC Idle Functions
+ *
+ * Copyright (C) 2014 Texas Instruments Incorporated - http://www.ti.com
+ *
+ * Author: Felipe Balbi <balbi@ti.com>
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2  of
+ * the License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __INCLUDE_LINUX_IRQCHIP_IRQ_OMAP_INTC_H
+#define __INCLUDE_LINUX_IRQCHIP_IRQ_OMAP_INTC_H
+
+void omap2_init_irq(void);
+void omap3_init_irq(void);
+void ti81xx_init_irq(void);
+
+int omap_irq_pending(void);
+void omap_intc_save_context(void);
+void omap_intc_restore_context(void);
+void omap3_intc_suspend(void);
+void omap3_intc_prepare_idle(void);
+void omap3_intc_resume_idle(void);
+
+#endif /* __INCLUDE_LINUX_IRQCHIP_IRQ_OMAP_INTC_H */
-- 
2.0.1.563.g66f467c

