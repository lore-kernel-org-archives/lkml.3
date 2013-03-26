Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934072Ab3CZJPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 05:15:16 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:50987 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759520Ab3CZJNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 05:13:30 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: kevin@allwinnertech.com, sunny@allwinnertech.com, shuge@allwinnertech.com,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/10] clocksource: sunxi: Rename sunxi to sun4i
Date: Tue, 26 Mar 2013 10:13:11 +0100
Message-Id: <1364289198-11589-5-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364289198-11589-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1364289198-11589-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the introduction of the Allwinner SoC platforms, sunxi was
initially meant as a generic name for all the variants of the Allwinner
SoC.

It was ok at the time of the support of only the A10 and A13 that
looks pretty much the same, but it's beginning to be troublesome with
the future addition of the Allwinner A31 (sun6i) that is quite
different, and would introduce some weird logic, where sunxi would
actually mean in some case sun4i and sun5i but without sun6i...

Moreover, it makes the compatible strings naming scheme not consistent
with other architectures, where usually for this kind of compability, we
just use the oldest SoC name that has this IP, so let's do just this.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 ...r,sunxi-timer.txt => allwinner,sun4i-timer.txt} |    4 +--
 arch/arm/mach-sunxi/Kconfig                        |    4 +--
 drivers/clocksource/Kconfig                        |    2 +-
 drivers/clocksource/Makefile                       |    2 +-
 .../clocksource/{sunxi_timer.c => sun4i_timer.c}   |   34 ++++++++++----------
 5 files changed, 23 insertions(+), 23 deletions(-)
 rename Documentation/devicetree/bindings/timer/{allwinner,sunxi-timer.txt => allwinner,sun4i-timer.txt} (78%)
 rename drivers/clocksource/{sunxi_timer.c => sun4i_timer.c} (80%)

diff --git a/Documentation/devicetree/bindings/timer/allwinner,sunxi-timer.txt b/Documentation/devicetree/bindings/timer/allwinner,sun4i-timer.txt
similarity index 78%
rename from Documentation/devicetree/bindings/timer/allwinner,sunxi-timer.txt
rename to Documentation/devicetree/bindings/timer/allwinner,sun4i-timer.txt
index 0c7b64e..48aeb78 100644
--- a/Documentation/devicetree/bindings/timer/allwinner,sunxi-timer.txt
+++ b/Documentation/devicetree/bindings/timer/allwinner,sun4i-timer.txt
@@ -2,7 +2,7 @@ Allwinner A1X SoCs Timer Controller
 
 Required properties:
 
-- compatible : should be "allwinner,sunxi-timer"
+- compatible : should be "allwinner,sun4i-timer"
 - reg : Specifies base physical address and size of the registers.
 - interrupts : The interrupt of the first timer
 - clocks: phandle to the source clock (usually a 24 MHz fixed clock)
@@ -10,7 +10,7 @@ Required properties:
 Example:
 
 timer {
-	compatible = "allwinner,sunxi-timer";
+	compatible = "allwinner,sun4i-timer";
 	reg = <0x01c20c00 0x400>;
 	interrupts = <22>;
 	clocks = <&osc>;
diff --git a/arch/arm/mach-sunxi/Kconfig b/arch/arm/mach-sunxi/Kconfig
index 06c2894..d259c78 100644
--- a/arch/arm/mach-sunxi/Kconfig
+++ b/arch/arm/mach-sunxi/Kconfig
@@ -7,5 +7,5 @@ config ARCH_SUNXI
 	select GENERIC_IRQ_CHIP
 	select PINCTRL
 	select SPARSE_IRQ
-	select SUNXI_TIMER
-	select PINCTRL_SUNXI
\ No newline at end of file
+	select SUN4I_TIMER
+	select PINCTRL_SUNXI
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index e507ab7..9002185 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -25,7 +25,7 @@ config DW_APB_TIMER_OF
 config ARMADA_370_XP_TIMER
 	bool
 
-config SUNXI_TIMER
+config SUN4I_TIMER
 	bool
 
 config VT8500_TIMER
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 4d8283a..7d5d23a 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -16,7 +16,7 @@ obj-$(CONFIG_CLKSRC_NOMADIK_MTU)	+= nomadik-mtu.o
 obj-$(CONFIG_CLKSRC_DBX500_PRCMU)	+= clksrc-dbx500-prcmu.o
 obj-$(CONFIG_ARMADA_370_XP_TIMER)	+= time-armada-370-xp.o
 obj-$(CONFIG_ARCH_BCM2835)	+= bcm2835_timer.o
-obj-$(CONFIG_SUNXI_TIMER)	+= sunxi_timer.o
+obj-$(CONFIG_SUN4I_TIMER)	+= sun4i_timer.o
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra20_timer.o
 obj-$(CONFIG_VT8500_TIMER)	+= vt8500_timer.o
 
diff --git a/drivers/clocksource/sunxi_timer.c b/drivers/clocksource/sun4i_timer.c
similarity index 80%
rename from drivers/clocksource/sunxi_timer.c
rename to drivers/clocksource/sun4i_timer.c
index 308bbe3..d4674e7 100644
--- a/drivers/clocksource/sunxi_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -37,7 +37,7 @@
 
 static void __iomem *timer_base;
 
-static void sunxi_clkevt_mode(enum clock_event_mode mode,
+static void sun4i_clkevt_mode(enum clock_event_mode mode,
 			      struct clock_event_device *clk)
 {
 	u32 u = readl(timer_base + TIMER_CTL_REG(0));
@@ -59,7 +59,7 @@ static void sunxi_clkevt_mode(enum clock_event_mode mode,
 	}
 }
 
-static int sunxi_clkevt_next_event(unsigned long evt,
+static int sun4i_clkevt_next_event(unsigned long evt,
 				   struct clock_event_device *unused)
 {
 	u32 u = readl(timer_base + TIMER_CTL_REG(0));
@@ -70,16 +70,16 @@ static int sunxi_clkevt_next_event(unsigned long evt,
 	return 0;
 }
 
-static struct clock_event_device sunxi_clockevent = {
-	.name = "sunxi_tick",
+static struct clock_event_device sun4i_clockevent = {
+	.name = "sun4i_tick",
 	.rating = 300,
 	.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
-	.set_mode = sunxi_clkevt_mode,
-	.set_next_event = sunxi_clkevt_next_event,
+	.set_mode = sun4i_clkevt_mode,
+	.set_next_event = sun4i_clkevt_next_event,
 };
 
 
-static irqreturn_t sunxi_timer_interrupt(int irq, void *dev_id)
+static irqreturn_t sun4i_timer_interrupt(int irq, void *dev_id)
 {
 	struct clock_event_device *evt = (struct clock_event_device *)dev_id;
 
@@ -89,14 +89,14 @@ static irqreturn_t sunxi_timer_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static struct irqaction sunxi_timer_irq = {
-	.name = "sunxi_timer0",
+static struct irqaction sun4i_timer_irq = {
+	.name = "sun4i_timer0",
 	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
-	.handler = sunxi_timer_interrupt,
-	.dev_id = &sunxi_clockevent,
+	.handler = sun4i_timer_interrupt,
+	.dev_id = &sun4i_clockevent,
 };
 
-static void __init sunxi_timer_init(struct device_node *node)
+static void __init sun4i_timer_init(struct device_node *node)
 {
 	unsigned long rate = 0;
 	struct clk *clk;
@@ -131,7 +131,7 @@ static void __init sunxi_timer_init(struct device_node *node)
 	val = readl(timer_base + TIMER_CTL_REG(0));
 	writel(val | TIMER_CTL_AUTORELOAD, timer_base + TIMER_CTL_REG(0));
 
-	ret = setup_irq(irq, &sunxi_timer_irq);
+	ret = setup_irq(irq, &sun4i_timer_irq);
 	if (ret)
 		pr_warn("failed to setup irq %d\n", irq);
 
@@ -139,10 +139,10 @@ static void __init sunxi_timer_init(struct device_node *node)
 	val = readl(timer_base + TIMER_IRQ_EN_REG);
 	writel(val | TIMER_IRQ_EN(0), timer_base + TIMER_IRQ_EN_REG);
 
-	sunxi_clockevent.cpumask = cpumask_of(0);
+	sun4i_clockevent.cpumask = cpumask_of(0);
 
-	clockevents_config_and_register(&sunxi_clockevent, rate / TIMER_SCAL,
+	clockevents_config_and_register(&sun4i_clockevent, rate / TIMER_SCAL,
 					0x1, 0xff);
 }
-CLOCKSOURCE_OF_DECLARE(sunxi, "allwinner,sunxi-timer",
-		       sunxi_timer_init);
+CLOCKSOURCE_OF_DECLARE(sun4i, "allwinner,sun4i-timer",
+		       sun4i_timer_init);
-- 
1.7.10.4

