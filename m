Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab3GQNwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 09:52:46 -0400
Received: from 16.mo1.mail-out.ovh.net ([178.33.104.224]:35906 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753666Ab3GQNwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 09:52:45 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Mike Turquette <mturquette@linaro.org>,
        Andrew Victor <linux@maxim.org.za>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH v2 09/42] ARM: at91: add PMC usb clock
Date: Wed, 17 Jul 2013 15:52:18 +0200
Message-Id: <1374069138-14101-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 11636738487371528300
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the at91 usb clock implementation using common clk framework.
This clock is used to clock usb ports (ohci, ehci and udc).

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/mach-at91/Kconfig |   11 ++
 drivers/clk/at91/Makefile  |    1 +
 drivers/clk/at91/clk-usb.c |  303 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/clk/at91.h   |    9 ++
 4 files changed, 324 insertions(+)
 create mode 100644 drivers/clk/at91/clk-usb.c

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 1a24a1f..ac18755 100644
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
 
@@ -69,6 +72,7 @@ config SOC_SAMA5D3
 	select HAVE_FB_ATMEL
 	select HAVE_AT91_DBGU1
 	select HAVE_AT91_UTMI
+	select HAVE_AT91_USB_CLK
 	help
 	  Select this if you are using one of Atmel's SAMA5D3 family SoC.
 	  This support covers SAMA5D31, SAMA5D33, SAMA5D34, SAMA5D35.
@@ -82,11 +86,13 @@ config SOC_AT91RM9200
 	select HAVE_AT91_DBGU0
 	select MULTI_IRQ_HANDLER
 	select SPARSE_IRQ
+	select HAVE_AT91_USB_CLK
 
 config SOC_AT91SAM9260
 	bool "AT91SAM9260, AT91SAM9XE or AT91SAM9G20"
 	select HAVE_AT91_DBGU0
 	select SOC_AT91SAM9
+	select HAVE_AT91_USB_CLK
 	help
 	  Select this if you are using one of Atmel's AT91SAM9260, AT91SAM9XE
 	  or AT91SAM9G20 SoC.
@@ -96,6 +102,7 @@ config SOC_AT91SAM9261
 	select HAVE_AT91_DBGU0
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
+	select HAVE_AT91_USB_CLK
 	help
 	  Select this if you are using one of Atmel's AT91SAM9261 or AT91SAM9G10 SoC.
 
@@ -104,6 +111,7 @@ config SOC_AT91SAM9263
 	select HAVE_AT91_DBGU1
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
+	select HAVE_AT91_USB_CLK
 
 config SOC_AT91SAM9RL
 	bool "AT91SAM9RL"
@@ -118,6 +126,7 @@ config SOC_AT91SAM9G45
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
 	select HAVE_AT91_UTMI
+	select HAVE_AT91_USB_CLK
 	help
 	  Select this if you are using one of Atmel's AT91SAM9G45 family SoC.
 	  This support covers AT91SAM9G45, AT91SAM9G46, AT91SAM9M10 and AT91SAM9M11.
@@ -128,6 +137,7 @@ config SOC_AT91SAM9X5
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
 	select HAVE_AT91_UTMI
+	select HAVE_AT91_USB_CLK
 	help
 	  Select this if you are using one of Atmel's AT91SAM9x5 family SoC.
 	  This means that your SAM9 name finishes with a '5' (except if it is
@@ -140,6 +150,7 @@ config SOC_AT91SAM9N12
 	select HAVE_AT91_DBGU0
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
+	select HAVE_AT91_USB_CLK
 	help
 	  Select this if you are using Atmel's AT91SAM9N12 SoC.
 
diff --git a/drivers/clk/at91/Makefile b/drivers/clk/at91/Makefile
index 76d09f0..bbfd245 100644
--- a/drivers/clk/at91/Makefile
+++ b/drivers/clk/at91/Makefile
@@ -7,3 +7,4 @@ obj-y += clk-system.o clk-peripheral.o
 
 obj-$(CONFIG_AT91_PROGRAMMABLE_CLOCKS)	+= clk-programmable.o
 obj-$(CONFIG_HAVE_AT91_UTMI)		+= clk-utmi.o
+obj-$(CONFIG_HAVE_AT91_USB_CLK)		+= clk-usb.o
diff --git a/drivers/clk/at91/clk-usb.c b/drivers/clk/at91/clk-usb.c
new file mode 100644
index 0000000..4af0fe3
--- /dev/null
+++ b/drivers/clk/at91/clk-usb.c
@@ -0,0 +1,303 @@
+/*
+ * drivers/clk/at91/clk-usb.c
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
+#include <linux/clk/at91.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/io.h>
+
+#define USB_SOURCE_MAX		2
+
+#define to_at91sam9x5_clk_usb(hw) \
+	container_of(hw, struct at91sam9x5_clk_usb, hw)
+struct at91sam9x5_clk_usb {
+	struct clk_hw hw;
+	u8 usbs0_unused; /* sam9n12 uses usbs0 to disable usb clock */
+};
+
+#define to_at91rm9200_clk_usb(hw) \
+	container_of(hw, struct at91rm9200_clk_usb, hw)
+struct at91rm9200_clk_usb {
+	struct clk_hw hw;
+	u32 divisors[4];
+};
+
+static unsigned long at91sam9x5_clk_usb_recalc_rate(struct clk_hw *hw,
+						    unsigned long parent_rate)
+{
+	u32 tmp;
+	u8 usbdiv;
+	tmp = at91_pmc_read(AT91_PMC_USB);
+	usbdiv = (tmp & AT91_PMC_OHCIUSBDIV) >> 8;
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
+	if (div > 15)
+		return *parent_rate / 16;
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
+	if (usb->usbs0_unused)
+		index++;
+	if (index > 1)
+		return -EINVAL;
+	tmp = at91_pmc_read(AT91_PMC_USB) & ~AT91_PMC_USBS;
+	if (index)
+		tmp |= AT91_PMC_USBS;
+	at91_pmc_write(AT91_PMC_USB, tmp);
+	return 0;
+}
+
+static u8 at91sam9x5_clk_usb_get_parent(struct clk_hw *hw)
+{
+	struct at91sam9x5_clk_usb *usb = to_at91sam9x5_clk_usb(hw);
+	if (usb->usbs0_unused)
+		return 0;
+	return at91_pmc_read(AT91_PMC_USB) & AT91_PMC_USBS;
+}
+
+static int at91sam9x5_clk_usb_set_rate(struct clk_hw *hw, unsigned long rate,
+				       unsigned long parent_rate)
+{
+	u32 tmp;
+	unsigned long div = parent_rate / rate;
+	if (parent_rate % rate || div < 1 || div > 16)
+		return -EINVAL;
+	tmp = at91_pmc_read(AT91_PMC_USB) & ~AT91_PMC_OHCIUSBDIV;
+	tmp |= (div - 1) << 8;
+	at91_pmc_write(AT91_PMC_USB, tmp);
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
+struct clk * __init
+at91sam9x5_clk_register_usb(const char *name, const char **parent_names,
+			    u8 num_parents, u8 usbs0_unused)
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
+	usb->usbs0_unused = usbs0_unused;
+	usb->hw.init = &init;
+
+	clk = clk_register(NULL, &usb->hw);
+
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
+	u32 tmp;
+	u8 usbdiv;
+	tmp = at91_pmc_read(AT91_CKGR_PLLBR);
+	usbdiv = (tmp & AT91_PMC_USBDIV) >> 28;
+	if (usb->divisors[usbdiv])
+		return parent_rate / usb->divisors[usbdiv];
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
+	unsigned long div = parent_rate / rate;
+	if (parent_rate % rate)
+		return -EINVAL;
+	for (i = 0; i < 4; i++) {
+		if (usb->divisors[i] == div) {
+			tmp = at91_pmc_read(AT91_CKGR_PLLBR) &
+			      ~AT91_PMC_USBDIV;
+			tmp |= i << 8;
+			at91_pmc_write(AT91_PMC_USB, tmp);
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
+struct clk * __init
+at91rm9200_clk_register_usb(const char *name, const char *parent_name,
+			    const u32 *divisors)
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
+	memcpy(usb->divisors, divisors, sizeof(usb->divisors));
+
+	clk = clk_register(NULL, &usb->hw);
+
+	if (IS_ERR(clk))
+		kfree(usb);
+
+	return clk;
+}
+
+#if defined(CONFIG_OF)
+static void __init of_at91sam9x5_clk_usb_setup(struct device_node *np)
+{
+	struct clk *clk;
+	int i;
+	int num_parents;
+	u8 usbs0_unused;
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
+	usbs0_unused = of_property_read_bool(np, "usbs0-unused");
+	of_property_read_string(np, "clock-output-names", &name);
+
+	clk = at91sam9x5_clk_register_usb(name, parent_names, num_parents,
+					  usbs0_unused);
+
+	if (IS_ERR(clk))
+		return;
+
+	of_clk_add_provider(np, of_clk_src_simple_get, clk);
+}
+CLK_OF_DECLARE(at91sam9x5_clk_usb, "atmel,at91sam9x5-clk-usb",
+	       of_at91sam9x5_clk_usb_setup);
+
+static void __init of_at91rm9200_clk_usb_setup(struct device_node *np)
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
+	of_property_read_u32_array(np, "divisors", divisors, 4);
+	if (!divisors[0])
+		return;
+
+	of_property_read_string(np, "clock-output-names", &name);
+
+	clk = at91rm9200_clk_register_usb(name, parent_name, divisors);
+
+	if (IS_ERR(clk))
+		return;
+
+	of_clk_add_provider(np, of_clk_src_simple_get, clk);
+}
+CLK_OF_DECLARE(at91rm9200_clk_usb, "atmel,at91rm9200-clk-usb",
+	       of_at91rm9200_clk_usb_setup);
+#endif
diff --git a/include/linux/clk/at91.h b/include/linux/clk/at91.h
index 47ef7e8..2d083d1 100644
--- a/include/linux/clk/at91.h
+++ b/include/linux/clk/at91.h
@@ -292,4 +292,13 @@ at91_clk_register_programmable(const char *name, const char **parent_names,
 struct clk * __init
 at91_clk_register_utmi(const char *name, const char *parent_name);
 
+
+struct clk * __init
+at91rm9200_clk_register_usb(const char *name, const char *parent_name,
+			    const u32 *divisors);
+
+struct clk * __init
+at91sam9x5_clk_register_usb(const char *name, const char **parent_names,
+			    u8 num_parents, u8 usbs0_unused);
+
 #endif
-- 
1.7.9.5

