Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298Ab3KMGT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 01:19:59 -0500
Received: from 5.mo2.mail-out.ovh.net ([87.98.181.248]:39380 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758217Ab3KMGTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 01:19:53 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Richard Genoud <richard.genoud@gmail.com>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: [PATCH v5 12/17] clk: at91: add PMC utmi clock
Date: Wed, 13 Nov 2013 07:17:23 +0100
Message-Id: <1384323443-5515-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384289513-3068-1-git-send-email-b.brezillon@overkiz.com>
References: <1384289513-3068-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 1802284275981383904
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrieefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrieefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds new at91 utmi clock implementation using common clk framework.

This clock is a pll with a fixed factor (x40).
It is used as a source for usb clock.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/Kconfig  |    7 ++
 drivers/clk/at91/Makefile   |    1 +
 drivers/clk/at91/clk-utmi.c |  162 +++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/at91/pmc.c      |    7 ++
 drivers/clk/at91/pmc.h      |    5 ++
 5 files changed, 182 insertions(+)
 create mode 100644 drivers/clk/at91/clk-utmi.c

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 85b53a4..6ad37da 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -1,5 +1,8 @@
 if ARCH_AT91
 
+config HAVE_AT91_UTMI
+	bool
+
 config HAVE_AT91_DBGU0
 	bool
 
@@ -78,6 +81,7 @@ config SOC_SAMA5D3
 	select HAVE_FB_ATMEL
 	select HAVE_AT91_DBGU1
 	select AT91_USE_OLD_CLK
+	select HAVE_AT91_UTMI
 	help
 	  Select this if you are using one of Atmel's SAMA5D3 family SoC.
 	  This support covers SAMA5D31, SAMA5D33, SAMA5D34, SAMA5D35.
@@ -124,6 +128,7 @@ config SOC_AT91SAM9RL
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
 	select AT91_USE_OLD_CLK
+	select HAVE_AT91_UTMI
 
 config SOC_AT91SAM9G45
 	bool "AT91SAM9G45 or AT91SAM9M10 families"
@@ -131,6 +136,7 @@ config SOC_AT91SAM9G45
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
 	select AT91_USE_OLD_CLK
+	select HAVE_AT91_UTMI
 	help
 	  Select this if you are using one of Atmel's AT91SAM9G45 family SoC.
 	  This support covers AT91SAM9G45, AT91SAM9G46, AT91SAM9M10 and AT91SAM9M11.
@@ -141,6 +147,7 @@ config SOC_AT91SAM9X5
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
 	select AT91_USE_OLD_CLK
+	select HAVE_AT91_UTMI
 	help
 	  Select this if you are using one of Atmel's AT91SAM9x5 family SoC.
 	  This means that your SAM9 name finishes with a '5' (except if it is
diff --git a/drivers/clk/at91/Makefile b/drivers/clk/at91/Makefile
index 3873b62..a824883 100644
--- a/drivers/clk/at91/Makefile
+++ b/drivers/clk/at91/Makefile
@@ -7,3 +7,4 @@ obj-y += clk-main.o clk-pll.o clk-plldiv.o clk-master.o
 obj-y += clk-system.o clk-peripheral.o
 
 obj-$(CONFIG_AT91_PROGRAMMABLE_CLOCKS)	+= clk-programmable.o
+obj-$(CONFIG_HAVE_AT91_UTMI)		+= clk-utmi.o
diff --git a/drivers/clk/at91/clk-utmi.c b/drivers/clk/at91/clk-utmi.c
new file mode 100644
index 0000000..9a133df
--- /dev/null
+++ b/drivers/clk/at91/clk-utmi.c
@@ -0,0 +1,162 @@
+/*
+ * drivers/clk/at91/clk-utmi.c
+ *
+ *  Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/clkdev.h>
+#include <linux/clk/at91_pmc.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/io.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
+
+#include "pmc.h"
+
+#define UTMI_FIXED_MUL		40
+
+struct clk_utmi {
+	struct clk_hw hw;
+	struct at91_pmc *pmc;
+	unsigned int irq;
+	wait_queue_head_t wait;
+};
+
+#define to_clk_utmi(hw) container_of(hw, struct clk_utmi, hw)
+
+static irqreturn_t clk_utmi_irq_handler(int irq, void *dev_id)
+{
+	struct clk_utmi *utmi = (struct clk_utmi *)dev_id;
+
+	wake_up(&utmi->wait);
+	disable_irq_nosync(utmi->irq);
+
+	return IRQ_HANDLED;
+}
+
+static int clk_utmi_prepare(struct clk_hw *hw)
+{
+	struct clk_utmi *utmi = to_clk_utmi(hw);
+	struct at91_pmc *pmc = utmi->pmc;
+	u32 tmp = at91_pmc_read(AT91_CKGR_UCKR) | AT91_PMC_UPLLEN |
+		  AT91_PMC_UPLLCOUNT | AT91_PMC_BIASEN;
+
+	pmc_write(pmc, AT91_CKGR_UCKR, tmp);
+
+	while (!(pmc_read(pmc, AT91_PMC_SR) & AT91_PMC_LOCKU)) {
+		enable_irq(utmi->irq);
+		wait_event(utmi->wait,
+			   pmc_read(pmc, AT91_PMC_SR) & AT91_PMC_LOCKU);
+	}
+
+	return 0;
+}
+
+static int clk_utmi_is_ready(struct clk_hw *hw)
+{
+	struct clk_utmi *utmi = to_clk_utmi(hw);
+	struct at91_pmc *pmc = utmi->pmc;
+
+	return !!(pmc_read(pmc, AT91_PMC_SR) & AT91_PMC_LOCKU);
+}
+
+static void clk_utmi_disable(struct clk_hw *hw)
+{
+	struct clk_utmi *utmi = to_clk_utmi(hw);
+	struct at91_pmc *pmc = utmi->pmc;
+	u32 tmp = at91_pmc_read(AT91_CKGR_UCKR) & ~AT91_PMC_UPLLEN;
+
+	pmc_write(pmc, AT91_CKGR_UCKR, tmp);
+}
+
+static unsigned long clk_utmi_recalc_rate(struct clk_hw *hw,
+					  unsigned long parent_rate)
+{
+	/* UTMI clk is a fixed clk multiplier */
+	return parent_rate * UTMI_FIXED_MUL;
+}
+
+static const struct clk_ops utmi_ops = {
+	.prepare = clk_utmi_prepare,
+	.is_prepared = clk_utmi_is_ready,
+	.disable = clk_utmi_disable,
+	.is_enabled = clk_utmi_is_ready,
+	.recalc_rate = clk_utmi_recalc_rate,
+};
+
+static struct clk * __init
+at91_clk_register_utmi(struct at91_pmc *pmc, unsigned int irq,
+		       const char *name, const char *parent_name)
+{
+	int ret;
+	struct clk_utmi *utmi;
+	struct clk *clk = NULL;
+	struct clk_init_data init;
+
+	utmi = kzalloc(sizeof(*utmi), GFP_KERNEL);
+	if (!utmi)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &utmi_ops;
+	init.parent_names = parent_name ? &parent_name : NULL;
+	init.num_parents = parent_name ? 1 : 0;
+	init.flags = CLK_SET_RATE_GATE;
+
+	utmi->hw.init = &init;
+	utmi->pmc = pmc;
+	utmi->irq = irq;
+	init_waitqueue_head(&utmi->wait);
+	irq_set_status_flags(utmi->irq, IRQ_NOAUTOEN);
+	ret = request_irq(utmi->irq, clk_utmi_irq_handler,
+			  IRQF_TRIGGER_HIGH, "clk-utmi", utmi);
+	if (ret)
+		return ERR_PTR(ret);
+
+	clk = clk_register(NULL, &utmi->hw);
+	if (IS_ERR(clk))
+		kfree(utmi);
+
+	return clk;
+}
+
+static void __init
+of_at91_clk_utmi_setup(struct device_node *np, struct at91_pmc *pmc)
+{
+	unsigned int irq;
+	struct clk *clk;
+	const char *parent_name;
+	const char *name = np->name;
+
+	parent_name = of_clk_get_parent_name(np, 0);
+
+	of_property_read_string(np, "clock-output-names", &name);
+
+	irq = irq_of_parse_and_map(np, 0);
+	if (!irq)
+		return;
+
+	clk = at91_clk_register_utmi(pmc, irq, name, parent_name);
+	if (IS_ERR(clk))
+		return;
+
+	of_clk_add_provider(np, of_clk_src_simple_get, clk);
+	return;
+}
+
+void __init of_at91sam9x5_clk_utmi_setup(struct device_node *np,
+					 struct at91_pmc *pmc)
+{
+	of_at91_clk_utmi_setup(np, pmc);
+}
diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
index ffe8ac8..009d1b2 100644
--- a/drivers/clk/at91/pmc.c
+++ b/drivers/clk/at91/pmc.c
@@ -295,6 +295,13 @@ static const struct of_device_id pmc_clk_ids[] __initdata = {
 		.data = of_at91sam9x5_clk_prog_setup,
 	},
 #endif
+	/* UTMI clock */
+#if defined(CONFIG_HAVE_AT91_UTMI)
+	{
+		.compatible = "atmel,at91sam9x5-clk-utmi",
+		.data = of_at91sam9x5_clk_utmi_setup,
+	},
+#endif
 	{ /*sentinel*/ }
 };
 
diff --git a/drivers/clk/at91/pmc.h b/drivers/clk/at91/pmc.h
index 6eeed49..8e18ab0 100644
--- a/drivers/clk/at91/pmc.h
+++ b/drivers/clk/at91/pmc.h
@@ -94,4 +94,9 @@ extern void __init of_at91sam9x5_clk_prog_setup(struct device_node *np,
 						struct at91_pmc *pmc);
 #endif
 
+#if defined(CONFIG_HAVE_AT91_UTMI)
+extern void __init of_at91sam9x5_clk_utmi_setup(struct device_node *np,
+						struct at91_pmc *pmc);
+#endif
+
 #endif /* __PMC_H_ */
-- 
1.7.9.5

