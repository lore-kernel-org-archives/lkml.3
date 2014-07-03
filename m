Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965149AbaGCOyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:54:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51794 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758397AbaGCOt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:49:59 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        dwmw2@infradead.org, dbaryshkov@gmail.com
Cc: Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH RESEND 09/18] AT91: Probe the reset driver
Date: Thu,  3 Jul 2014 16:41:24 +0200
Message-Id: <1404398493-28907-10-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404398493-28907-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1404398493-28907-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register the reset device in the right SoCs so that the reset driver is
actually probed even in the old-style probing case.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-at91/at91sam9260.c | 26 ++++++++++++++++++++++++++
 arch/arm/mach-at91/at91sam9261.c | 26 ++++++++++++++++++++++++++
 arch/arm/mach-at91/at91sam9263.c | 26 ++++++++++++++++++++++++++
 arch/arm/mach-at91/at91sam9g45.c | 31 +++++++++++++++++++++++++++++++
 arch/arm/mach-at91/at91sam9rl.c  | 26 ++++++++++++++++++++++++++
 5 files changed, 135 insertions(+)

diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index c3d22be73b7c..9ffab0cf94cd 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/platform_device.h>
 #include <linux/clk/at91_pmc.h>
 
 #include <asm/proc-fns.h>
@@ -358,6 +359,30 @@ static void __init at91sam9260_initialize(void)
 	at91_gpio_init(at91sam9260_gpio, 3);
 }
 
+static struct resource rstc_resources[] = {
+	[0] = {
+		.start  = AT91SAM9260_BASE_RSTC,
+		.end    = AT91SAM9260_BASE_RSTC + SZ_16 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = AT91SAM9260_BASE_SDRAMC,
+		.end    = AT91SAM9260_BASE_SDRAMC + SZ_512 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device rstc_device = {
+	.name           = "at91-sam9-reset",
+	.resource       = rstc_resources,
+	.num_resources  = ARRAY_SIZE(rstc_resources),
+};
+
+static void __init at91sam9260_register_devices(void)
+{
+	platform_device_register(&rstc_device);
+}
+
 /* --------------------------------------------------------------------
  *  Interrupt initialization
  * -------------------------------------------------------------------- */
@@ -407,5 +432,6 @@ AT91_SOC_START(at91sam9260)
 		    | (1 << AT91SAM9260_ID_IRQ2),
 	.ioremap_registers = at91sam9260_ioremap_registers,
 	.register_clocks = at91sam9260_register_clocks,
+	.register_devices = at91sam9260_register_devices,
 	.init = at91sam9260_initialize,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index fb164a5d04a9..41fa9b9a6f05 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/platform_device.h>
 #include <linux/clk/at91_pmc.h>
 
 #include <asm/proc-fns.h>
@@ -321,6 +322,30 @@ static void __init at91sam9261_initialize(void)
 	at91_gpio_init(at91sam9261_gpio, 3);
 }
 
+static struct resource rstc_resources[] = {
+	[0] = {
+		.start  = AT91SAM9261_BASE_RSTC,
+		.end    = AT91SAM9261_BASE_RSTC + SZ_16 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = AT91SAM9261_BASE_SDRAMC,
+		.end    = AT91SAM9261_BASE_SDRAMC + SZ_512 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device rstc_device = {
+	.name           = "at91-sam9-reset",
+	.resource       = rstc_resources,
+	.num_resources  = ARRAY_SIZE(rstc_resources),
+};
+
+static void __init at91sam9261_register_devices(void)
+{
+	platform_device_register(&rstc_device);
+}
+
 /* --------------------------------------------------------------------
  *  Interrupt initialization
  * -------------------------------------------------------------------- */
@@ -370,5 +395,6 @@ AT91_SOC_START(at91sam9261)
 		    | (1 << AT91SAM9261_ID_IRQ2),
 	.ioremap_registers = at91sam9261_ioremap_registers,
 	.register_clocks = at91sam9261_register_clocks,
+	.register_devices = at91sam9261_register_devices,
 	.init = at91sam9261_initialize,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index f30290572293..0c6949c342dc 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/platform_device.h>
 #include <linux/clk/at91_pmc.h>
 
 #include <asm/proc-fns.h>
@@ -339,6 +340,30 @@ static void __init at91sam9263_initialize(void)
 	at91_gpio_init(at91sam9263_gpio, 5);
 }
 
+static struct resource rstc_resources[] = {
+	[0] = {
+		.start  = AT91SAM9263_BASE_RSTC,
+		.end    = AT91SAM9263_BASE_RSTC + SZ_16 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = AT91SAM9263_BASE_SDRAMC0,
+		.end    = AT91SAM9263_BASE_SDRAMC0 + SZ_512 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device rstc_device = {
+	.name           = "at91-sam9-reset",
+	.resource       = rstc_resources,
+	.num_resources  = ARRAY_SIZE(rstc_resources),
+};
+
+static void __init at91sam9263_register_devices(void)
+{
+	platform_device_register(&rstc_device);
+}
+
 /* --------------------------------------------------------------------
  *  Interrupt initialization
  * -------------------------------------------------------------------- */
@@ -387,5 +412,6 @@ AT91_SOC_START(at91sam9263)
 	.extern_irq = (1 << AT91SAM9263_ID_IRQ0) | (1 << AT91SAM9263_ID_IRQ1),
 	.ioremap_registers = at91sam9263_ioremap_registers,
 	.register_clocks = at91sam9263_register_clocks,
+	.register_devices = at91sam9263_register_devices,
 	.init = at91sam9263_initialize,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index 9d3d544ac19c..61c0bc1185e9 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
 #include <linux/clk/at91_pmc.h>
+#include <linux/platform_device.h>
 
 #include <asm/irq.h>
 #include <asm/mach/arch.h>
@@ -388,6 +389,35 @@ static void __init at91sam9g45_initialize(void)
 	at91_gpio_init(at91sam9g45_gpio, 5);
 }
 
+static struct resource rstc_resources[] = {
+	[0] = {
+		.start  = AT91SAM9G45_BASE_RSTC,
+		.end    = AT91SAM9G45_BASE_RSTC + SZ_16 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = AT91SAM9G45_BASE_DDRSDRC1,
+		.end    = AT91SAM9G45_BASE_DDRSDRC1 + SZ_512 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	[2] = {
+		.start  = AT91SAM9G45_BASE_DDRSDRC0,
+		.end    = AT91SAM9G45_BASE_DDRSDRC0 + SZ_512 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device rstc_device = {
+	.name           = "at91-g45-reset",
+	.resource       = rstc_resources,
+	.num_resources  = ARRAY_SIZE(rstc_resources),
+};
+
+static void __init at91sam9g45_register_devices(void)
+{
+	platform_device_register(&rstc_device);
+}
+
 /* --------------------------------------------------------------------
  *  Interrupt initialization
  * -------------------------------------------------------------------- */
@@ -436,5 +466,6 @@ AT91_SOC_START(at91sam9g45)
 	.extern_irq = (1 << AT91SAM9G45_ID_IRQ0),
 	.ioremap_registers = at91sam9g45_ioremap_registers,
 	.register_clocks = at91sam9g45_register_clocks,
+	.register_devices = at91sam9g45_register_devices,
 	.init = at91sam9g45_initialize,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
index a79960f57e6a..417c8b6fb85e 100644
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/platform_device.h>
 #include <linux/clk/at91_pmc.h>
 
 #include <asm/proc-fns.h>
@@ -331,6 +332,30 @@ static void __init at91sam9rl_initialize(void)
 	at91_gpio_init(at91sam9rl_gpio, 4);
 }
 
+static struct resource rstc_resources[] = {
+	[0] = {
+		.start  = AT91SAM9RL_BASE_RSTC,
+		.end    = AT91SAM9RL_BASE_RSTC + SZ_16 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = AT91SAM9RL_BASE_SDRAMC,
+		.end    = AT91SAM9RL_BASE_SDRAMC + SZ_512 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device rstc_device = {
+	.name           = "at91-sam9-reset",
+	.resource       = rstc_resources,
+	.num_resources  = ARRAY_SIZE(rstc_resources),
+};
+
+static void __init at91sam9rl_register_devices(void)
+{
+	platform_device_register(&rstc_device);
+}
+
 /* --------------------------------------------------------------------
  *  Interrupt initialization
  * -------------------------------------------------------------------- */
@@ -381,5 +406,6 @@ AT91_SOC_START(at91sam9rl)
 #if defined(CONFIG_OLD_CLK_AT91)
 	.register_clocks = at91sam9rl_register_clocks,
 #endif
+	.register_devices = at91sam9rl_register_devices,
 	.init = at91sam9rl_initialize,
 AT91_SOC_END
-- 
2.0.1

