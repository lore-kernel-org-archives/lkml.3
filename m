Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186Ab3K1Npu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 08:45:50 -0500
Received: from 16.mo6.mail-out.ovh.net ([87.98.139.208]:40437 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757220Ab3K1Npr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 08:45:47 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: [PATCH v6 12/16] clk: at91: add PMC usb clock
Date: Thu, 28 Nov 2013 14:45:15 +0100
Message-Id: <1385646315-8205-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385642184-6467-1-git-send-email-b.brezillon@overkiz.com>
References: <1385642184-6467-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 5258515516133308524
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new at91 usb clock implementation using common clk framework.
This clock is used to clock usb ports (ohci, ehci and udc).

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/Kconfig |   11 ++
 drivers/clk/at91/Makefile  |    1 +
 drivers/clk/at91/clk-usb.c |  398 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/at91/pmc.c     |   15 ++
 drivers/clk/at91/pmc.h     |    9 +
 5 files changed, 434 insertions(+)
 create mode 100644 drivers/clk/at91/clk-usb.c

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 6ad37da..b76dc4c 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -3,6 +3,9 @@ if ARCH_AT91
 config HAVE_AT91_UTMI
 	bool
 
+config HAVE_AT91_USB_CLK
+	bool
+
 config HAVE_AT91_DBGU0
 	bool
 
@@ -82,6 +85,7 @@ config SOC_SAMA5D3
 	select HAVE_AT91_DBGU1
 	select AT91_USE_OLD_CLK
 	select HAVE_AT91_UTMI
+	select HAVE_AT91_USB_CLK
 	help
 	  Select this if you are using one of Atmel's SAMA5D3 family SoC.
 	  This support covers SAMA5D31, SAMA5D33, SAMA5D34, SAMA5D35.
@@ -96,12 +100,14 @@ config SOC_AT91RM9200
 	select MULTI_IRQ_HANDLER
 	select SPARSE_IRQ
 	select AT91_USE_OLD_CLK
+	select HAVE_AT91_USB_CLK
 
 config SOC_AT91SAM9260
 	bool "AT91SAM9260, AT91SAM9XE or AT91SAM9G20"
 	select HAVE_AT91_DBGU0
 	select SOC_AT91SAM9
 	select AT91_USE_OLD_CLK
+	select HAVE_AT91_USB_CLK
 	help
 	  Select this if you are using one of Atmel's AT91SAM9260, AT91SAM9XE
 	  or AT91SAM9G20 SoC.
@@ -112,6 +118,7 @@ config SOC_AT91SAM9261
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
 	select AT91_USE_OLD_CLK
+	select HAVE_AT91_USB_CLK
 	help
 	  Select this if you are using one of Atmel's AT91SAM9261 or AT91SAM9G10 SoC.
 
@@ -121,6 +128,7 @@ config SOC_AT91SAM9263
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
 	select AT91_USE_OLD_CLK
+	select HAVE_AT91_USB_CLK
 
 config SOC_AT91SAM9RL
 	bool "AT91SAM9RL"
@@ -137,6 +145,7 @@ config SOC_AT91SAM9G45
 	select SOC_AT91SAM9
 	select AT91_USE_OLD_CLK
 	select HAVE_AT91_UTMI
+	select HAVE_AT91_USB_CLK
 	help
 	  Select this if you are using one of Atmel's AT91SAM9G45 family SoC.
 	  This support covers AT91SAM9G45, AT91SAM9G46, AT91SAM9M10 and AT91SAM9M11.
@@ -148,6 +157,7 @@ config SOC_AT91SAM9X5
 	select SOC_AT91SAM9
 	select AT91_USE_OLD_CLK
 	select HAVE_AT91_UTMI
+	select HAVE_AT91_USB_CLK
 	help
 	  Select this if you are using one of Atmel's AT91SAM9x5 family SoC.
 	  This means that your SAM9 name finishes with a '5' (except if it is
@@ -161,6 +171,7 @@ config SOC_AT91SAM9N12
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
 	select AT91_USE_OLD_CLK
+	select HAVE_AT91_USB_CLK
 	help
 	  Select this if you are using Atmel's AT91SAM9N12 SoC.
 
diff --git a/drivers/clk/at91/Makefile b/drivers/clk/at91/Makefile
index a824883..61db058 100644
--- a/drivers/clk/at91/Makefile
+++ b/drivers/clk/at91/Makefile
@@ -8,3 +8,4 @@ obj-y += clk-system.o clk-peripheral.o
 
 obj-$(CONFIG_AT91_PROGRAMMABLE_CLOCKS)	+= clk-programmable.o
 obj-$(CONFIG_HAVE_AT91_UTMI)		+= clk-utmi.o
+obj-$(CONFIG_HAVE_AT91_USB_CLK)		+= clk-usb.o
diff --git a/drivers/clk/at91/clk-usb.c b/drivers/clk/at91/clk-usb.c
new file mode 100644
index 0000000..7d1d26a
--- /dev/null
+++ b/drivers/clk/at91/clk-usb.c
@@ -0,0 +1,398 @@
+/*
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
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/io.h>
+
+#include "pmc.h"
+
+#define USB_SOURCE_MAX		2
+
+#define SAM9X5_USB_DIV_SHIFT	8
+#define SAM9X5_USB_MAX_DIV	0xf
+
+#define RM9200_USB_DIV_SHIFT	28
+#define RM9200_USB_DIV_TAB_SIZE	4
+
+struct at91sam9x5_clk_usb {
+	struct clk_hw hw;
+	struct at91_pmc *pmc;
+};
+
+#define to_at91sam9x5_clk_usb(hw) \
+	container_of(hw, struct at91sam9x5_clk_usb, hw)
+
+struct at91rm9200_clk_usb {
+	struct clk_hw hw;
+	struct at91_pmc *pmc;
+	u32 divisors[4];
+};
+
+#define to_at91rm9200_clk_usb(hw) \
+	container_of(hw, struct at91rm9200_clk_usb, hw)
+
+static unsigned long at91sam9x5_clk_usb_recalc_rate(struct clk_hw *hw,
+						    unsigned long parent_rate)
+{
+	u32 tmp;
+	u8 usbdiv;
+	struct at91sam9x5_clk_usb *usb = to_at91sam9x5_clk_usb(hw);
+	struct at91_pmc *pmc = usb->pmc;
+
+	tmp = pmc_read(pmc, AT91_PMC_USB);
+	usbdiv = (tmp & AT91_PMC_OHCIUSBDIV) >> SAM9X5_USB_DIV_SHIFT;
+	return parent_rate / (usbdiv + 1);
+}
+
+static long at91sam9x5_clk_usb_round_rate(struct clk_hw *hw, unsigned long rate,
+					  unsigned long *parent_rate)
+{
+	unsigned long div;
+	unsigned long bestrate;
+	unsigned long tmp;
+
+	if (rate >= *parent_rate)
+		return *parent_rate;
+
+	div = *parent_rate / rate;
+	if (div >= SAM9X5_USB_MAX_DIV)
+		return *parent_rate / (SAM9X5_USB_MAX_DIV + 1);
+
+	bestrate = *parent_rate / div;
+	tmp = *parent_rate / (div + 1);
+	if (bestrate - rate > rate - tmp)
+		bestrate = tmp;
+
+	return bestrate;
+}
+
+static int at91sam9x5_clk_usb_set_parent(struct clk_hw *hw, u8 index)
+{
+	u32 tmp;
+	struct at91sam9x5_clk_usb *usb = to_at91sam9x5_clk_usb(hw);
+	struct at91_pmc *pmc = usb->pmc;
+
+	if (index > 1)
+		return -EINVAL;
+	tmp = pmc_read(pmc, AT91_PMC_USB) & ~AT91_PMC_USBS;
+	if (index)
+		tmp |= AT91_PMC_USBS;
+	pmc_write(pmc, AT91_PMC_USB, tmp);
+	return 0;
+}
+
+static u8 at91sam9x5_clk_usb_get_parent(struct clk_hw *hw)
+{
+	struct at91sam9x5_clk_usb *usb = to_at91sam9x5_clk_usb(hw);
+	struct at91_pmc *pmc = usb->pmc;
+
+	return pmc_read(pmc, AT91_PMC_USB) & AT91_PMC_USBS;
+}
+
+static int at91sam9x5_clk_usb_set_rate(struct clk_hw *hw, unsigned long rate,
+				       unsigned long parent_rate)
+{
+	u32 tmp;
+	struct at91sam9x5_clk_usb *usb = to_at91sam9x5_clk_usb(hw);
+	struct at91_pmc *pmc = usb->pmc;
+	unsigned long div = parent_rate / rate;
+
+	if (parent_rate % rate || div < 1 || div >= SAM9X5_USB_MAX_DIV)
+		return -EINVAL;
+
+	tmp = pmc_read(pmc, AT91_PMC_USB) & ~AT91_PMC_OHCIUSBDIV;
+	tmp |= (div - 1) << SAM9X5_USB_DIV_SHIFT;
+	pmc_write(pmc, AT91_PMC_USB, tmp);
+
+	return 0;
+}
+
+static const struct clk_ops at91sam9x5_usb_ops = {
+	.recalc_rate = at91sam9x5_clk_usb_recalc_rate,
+	.round_rate = at91sam9x5_clk_usb_round_rate,
+	.get_parent = at91sam9x5_clk_usb_get_parent,
+	.set_parent = at91sam9x5_clk_usb_set_parent,
+	.set_rate = at91sam9x5_clk_usb_set_rate,
+};
+
+static int at91sam9n12_clk_usb_enable(struct clk_hw *hw)
+{
+	struct at91sam9x5_clk_usb *usb = to_at91sam9x5_clk_usb(hw);
+	struct at91_pmc *pmc = usb->pmc;
+
+	pmc_write(pmc, AT91_PMC_USB,
+		  pmc_read(pmc, AT91_PMC_USB) | AT91_PMC_USBS);
+	return 0;
+}
+
+static void at91sam9n12_clk_usb_disable(struct clk_hw *hw)
+{
+	struct at91sam9x5_clk_usb *usb = to_at91sam9x5_clk_usb(hw);
+	struct at91_pmc *pmc = usb->pmc;
+
+	pmc_write(pmc, AT91_PMC_USB,
+		  pmc_read(pmc, AT91_PMC_USB) & ~AT91_PMC_USBS);
+}
+
+static int at91sam9n12_clk_usb_is_enabled(struct clk_hw *hw)
+{
+	struct at91sam9x5_clk_usb *usb = to_at91sam9x5_clk_usb(hw);
+	struct at91_pmc *pmc = usb->pmc;
+
+	return !!(pmc_read(pmc, AT91_PMC_USB) & AT91_PMC_USBS);
+}
+
+static const struct clk_ops at91sam9n12_usb_ops = {
+	.enable = at91sam9n12_clk_usb_enable,
+	.disable = at91sam9n12_clk_usb_disable,
+	.is_enabled = at91sam9n12_clk_usb_is_enabled,
+	.recalc_rate = at91sam9x5_clk_usb_recalc_rate,
+	.round_rate = at91sam9x5_clk_usb_round_rate,
+	.set_rate = at91sam9x5_clk_usb_set_rate,
+};
+
+static struct clk * __init
+at91sam9x5_clk_register_usb(struct at91_pmc *pmc, const char *name,
+			    const char **parent_names, u8 num_parents)
+{
+	struct at91sam9x5_clk_usb *usb;
+	struct clk *clk = NULL;
+	struct clk_init_data init;
+
+	usb = kzalloc(sizeof(*usb), GFP_KERNEL);
+	if (!usb)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &at91sam9x5_usb_ops;
+	init.parent_names = parent_names;
+	init.num_parents = num_parents;
+	init.flags = CLK_SET_RATE_GATE | CLK_SET_PARENT_GATE;
+
+	usb->hw.init = &init;
+	usb->pmc = pmc;
+
+	clk = clk_register(NULL, &usb->hw);
+	if (IS_ERR(clk))
+		kfree(usb);
+
+	return clk;
+}
+
+static struct clk * __init
+at91sam9n12_clk_register_usb(struct at91_pmc *pmc, const char *name,
+			     const char *parent_name)
+{
+	struct at91sam9x5_clk_usb *usb;
+	struct clk *clk = NULL;
+	struct clk_init_data init;
+
+	usb = kzalloc(sizeof(*usb), GFP_KERNEL);
+	if (!usb)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &at91sam9n12_usb_ops;
+	init.parent_names = &parent_name;
+	init.num_parents = 1;
+	init.flags = CLK_SET_RATE_GATE;
+
+	usb->hw.init = &init;
+	usb->pmc = pmc;
+
+	clk = clk_register(NULL, &usb->hw);
+	if (IS_ERR(clk))
+		kfree(usb);
+
+	return clk;
+}
+
+static unsigned long at91rm9200_clk_usb_recalc_rate(struct clk_hw *hw,
+						    unsigned long parent_rate)
+{
+	struct at91rm9200_clk_usb *usb = to_at91rm9200_clk_usb(hw);
+	struct at91_pmc *pmc = usb->pmc;
+	u32 tmp;
+	u8 usbdiv;
+
+	tmp = pmc_read(pmc, AT91_CKGR_PLLBR);
+	usbdiv = (tmp & AT91_PMC_USBDIV) >> RM9200_USB_DIV_SHIFT;
+	if (usb->divisors[usbdiv])
+		return parent_rate / usb->divisors[usbdiv];
+
+	return 0;
+}
+
+static long at91rm9200_clk_usb_round_rate(struct clk_hw *hw, unsigned long rate,
+					  unsigned long *parent_rate)
+{
+	struct at91rm9200_clk_usb *usb = to_at91rm9200_clk_usb(hw);
+	unsigned long bestrate = 0;
+	int bestdiff = -1;
+	unsigned long tmprate;
+	int tmpdiff;
+	int i = 0;
+
+	for (i = 0; i < 4; i++) {
+		if (!usb->divisors[i])
+			continue;
+		tmprate = *parent_rate / usb->divisors[i];
+		if (tmprate < rate)
+			tmpdiff = rate - tmprate;
+		else
+			tmpdiff = tmprate - rate;
+
+		if (bestdiff < 0 || bestdiff > tmpdiff) {
+			bestrate = tmprate;
+			bestdiff = tmpdiff;
+		}
+
+		if (!bestdiff)
+			break;
+	}
+
+	return bestrate;
+}
+
+static int at91rm9200_clk_usb_set_rate(struct clk_hw *hw, unsigned long rate,
+				       unsigned long parent_rate)
+{
+	u32 tmp;
+	int i;
+	struct at91rm9200_clk_usb *usb = to_at91rm9200_clk_usb(hw);
+	struct at91_pmc *pmc = usb->pmc;
+	unsigned long div = parent_rate / rate;
+
+	if (parent_rate % rate)
+		return -EINVAL;
+	for (i = 0; i < RM9200_USB_DIV_TAB_SIZE; i++) {
+		if (usb->divisors[i] == div) {
+			tmp = pmc_read(pmc, AT91_CKGR_PLLBR) &
+			      ~AT91_PMC_USBDIV;
+			tmp |= i << RM9200_USB_DIV_SHIFT;
+			pmc_write(pmc, AT91_CKGR_PLLBR, tmp);
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
+static const struct clk_ops at91rm9200_usb_ops = {
+	.recalc_rate = at91rm9200_clk_usb_recalc_rate,
+	.round_rate = at91rm9200_clk_usb_round_rate,
+	.set_rate = at91rm9200_clk_usb_set_rate,
+};
+
+static struct clk * __init
+at91rm9200_clk_register_usb(struct at91_pmc *pmc, const char *name,
+			    const char *parent_name, const u32 *divisors)
+{
+	struct at91rm9200_clk_usb *usb;
+	struct clk *clk = NULL;
+	struct clk_init_data init;
+
+	usb = kzalloc(sizeof(*usb), GFP_KERNEL);
+	if (!usb)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &at91rm9200_usb_ops;
+	init.parent_names = &parent_name;
+	init.num_parents = 1;
+	init.flags = 0;
+
+	usb->hw.init = &init;
+	usb->pmc = pmc;
+	memcpy(usb->divisors, divisors, sizeof(usb->divisors));
+
+	clk = clk_register(NULL, &usb->hw);
+	if (IS_ERR(clk))
+		kfree(usb);
+
+	return clk;
+}
+
+void __init of_at91sam9x5_clk_usb_setup(struct device_node *np,
+					struct at91_pmc *pmc)
+{
+	struct clk *clk;
+	int i;
+	int num_parents;
+	const char *parent_names[USB_SOURCE_MAX];
+	const char *name = np->name;
+
+	num_parents = of_count_phandle_with_args(np, "clocks", "#clock-cells");
+	if (num_parents <= 0 || num_parents > USB_SOURCE_MAX)
+		return;
+
+	for (i = 0; i < num_parents; i++) {
+		parent_names[i] = of_clk_get_parent_name(np, i);
+		if (!parent_names[i])
+			return;
+	}
+
+	of_property_read_string(np, "clock-output-names", &name);
+
+	clk = at91sam9x5_clk_register_usb(pmc, name, parent_names, num_parents);
+	if (IS_ERR(clk))
+		return;
+
+	of_clk_add_provider(np, of_clk_src_simple_get, clk);
+}
+
+void __init of_at91sam9n12_clk_usb_setup(struct device_node *np,
+					 struct at91_pmc *pmc)
+{
+	struct clk *clk;
+	const char *parent_name;
+	const char *name = np->name;
+
+	parent_name = of_clk_get_parent_name(np, 0);
+	if (!parent_name)
+		return;
+
+	of_property_read_string(np, "clock-output-names", &name);
+
+	clk = at91sam9n12_clk_register_usb(pmc, name, parent_name);
+	if (IS_ERR(clk))
+		return;
+
+	of_clk_add_provider(np, of_clk_src_simple_get, clk);
+}
+
+void __init of_at91rm9200_clk_usb_setup(struct device_node *np,
+					struct at91_pmc *pmc)
+{
+	struct clk *clk;
+	const char *parent_name;
+	const char *name = np->name;
+	u32 divisors[4] = {0, 0, 0, 0};
+
+	parent_name = of_clk_get_parent_name(np, 0);
+	if (!parent_name)
+		return;
+
+	of_property_read_u32_array(np, "atmel,clk-divisors", divisors, 4);
+	if (!divisors[0])
+		return;
+
+	of_property_read_string(np, "clock-output-names", &name);
+
+	clk = at91rm9200_clk_register_usb(pmc, name, parent_name, divisors);
+	if (IS_ERR(clk))
+		return;
+
+	of_clk_add_provider(np, of_clk_src_simple_get, clk);
+}
diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
index 0f667fd..4fba500 100644
--- a/drivers/clk/at91/pmc.c
+++ b/drivers/clk/at91/pmc.c
@@ -300,6 +300,21 @@ static const struct of_device_id pmc_clk_ids[] __initdata = {
 		.data = of_at91sam9x5_clk_utmi_setup,
 	},
 #endif
+	/* USB clock */
+#if defined(CONFIG_HAVE_AT91_USB_CLK)
+	{
+		.compatible = "atmel,at91rm9200-clk-usb",
+		.data = of_at91rm9200_clk_usb_setup,
+	},
+	{
+		.compatible = "atmel,at91sam9x5-clk-usb",
+		.data = of_at91sam9x5_clk_usb_setup,
+	},
+	{
+		.compatible = "atmel,at91sam9n12-clk-usb",
+		.data = of_at91sam9n12_clk_usb_setup,
+	},
+#endif
 	{ /*sentinel*/ }
 };
 
diff --git a/drivers/clk/at91/pmc.h b/drivers/clk/at91/pmc.h
index 8e18ab0..2483ddc 100644
--- a/drivers/clk/at91/pmc.h
+++ b/drivers/clk/at91/pmc.h
@@ -99,4 +99,13 @@ extern void __init of_at91sam9x5_clk_utmi_setup(struct device_node *np,
 						struct at91_pmc *pmc);
 #endif
 
+#if defined(CONFIG_HAVE_AT91_USB_CLK)
+extern void __init of_at91rm9200_clk_usb_setup(struct device_node *np,
+					       struct at91_pmc *pmc);
+extern void __init of_at91sam9x5_clk_usb_setup(struct device_node *np,
+					       struct at91_pmc *pmc);
+extern void __init of_at91sam9n12_clk_usb_setup(struct device_node *np,
+						struct at91_pmc *pmc);
+#endif
+
 #endif /* __PMC_H_ */
-- 
1.7.9.5

