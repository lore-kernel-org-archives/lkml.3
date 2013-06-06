Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483Ab3FFMSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:18:10 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37421 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933457Ab3FFMSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:18:05 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 20/33] clk: ux500: Add Device Tree support for the PRCC Peripheral clock
Date: Thu,  6 Jun 2013 13:17:08 +0100
Message-Id: <1370521041-32318-21-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables clocks to be specified from Device Tree via phandles
to the "prcc-periph-clock" node.

Cc: Mike Turquette <mturquette@linaro.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/clk/ux500/u8500_clk.c |   57 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/drivers/clk/ux500/u8500_clk.c b/drivers/clk/ux500/u8500_clk.c
index 4f5ad4c..86de1a7 100644
--- a/drivers/clk/ux500/u8500_clk.c
+++ b/drivers/clk/ux500/u8500_clk.c
@@ -15,7 +15,18 @@
 #include <linux/platform_data/clk-ux500.h>
 #include "clk.h"
 
+#define PRCC_NUM_PERIPH_CLUSTERS 6
+#define PRCC_PERIPHS_PER_CLUSTER 32
+
 static struct clk *prcmu_clk[PRCMU_NUM_CLKS];
+static struct clk *prcc_pclk[(PRCC_NUM_PERIPH_CLUSTERS + 1) * PRCC_PERIPHS_PER_CLUSTER];
+
+#define PRCC_SHOW(clk, base, bit) \
+	clk[(base * PRCC_PERIPHS_PER_CLUSTER) + bit]
+#define PRCC_PCLK_STORE(clk, base, bit)	\
+	prcc_pclk[(base * PRCC_PERIPHS_PER_CLUSTER) + bit] = clk
+#define PRCC_KCLK_STORE(clk, base, bit)	\
+	prcc_kclk[(base * PRCC_PERIPHS_PER_CLUSTER) + bit] = clk
 
 struct clk *ux500_twocell_get(struct of_phandle_args *clkspec, void *data)
 {
@@ -285,143 +296,176 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 	clk = clk_reg_prcc_pclk("p1_pclk0", "per1clk", clkrst1_base,
 				BIT(0), 0);
 	clk_register_clkdev(clk, "apb_pclk", "uart0");
+	PRCC_PCLK_STORE(clk, 1, 0);
 
 	clk = clk_reg_prcc_pclk("p1_pclk1", "per1clk", clkrst1_base,
 				BIT(1), 0);
 	clk_register_clkdev(clk, "apb_pclk", "uart1");
+	PRCC_PCLK_STORE(clk, 1, 1);
 
 	clk = clk_reg_prcc_pclk("p1_pclk2", "per1clk", clkrst1_base,
 				BIT(2), 0);
 	clk_register_clkdev(clk, "apb_pclk", "nmk-i2c.1");
+	PRCC_PCLK_STORE(clk, 1, 2);
 
 	clk = clk_reg_prcc_pclk("p1_pclk3", "per1clk", clkrst1_base,
 				BIT(3), 0);
 	clk_register_clkdev(clk, "apb_pclk", "msp0");
 	clk_register_clkdev(clk, "apb_pclk", "ux500-msp-i2s.0");
+	PRCC_PCLK_STORE(clk, 1, 3);
 
 	clk = clk_reg_prcc_pclk("p1_pclk4", "per1clk", clkrst1_base,
 				BIT(4), 0);
 	clk_register_clkdev(clk, "apb_pclk", "msp1");
 	clk_register_clkdev(clk, "apb_pclk", "ux500-msp-i2s.1");
+	PRCC_PCLK_STORE(clk, 1, 4);
 
 	clk = clk_reg_prcc_pclk("p1_pclk5", "per1clk", clkrst1_base,
 				BIT(5), 0);
 	clk_register_clkdev(clk, "apb_pclk", "sdi0");
+	PRCC_PCLK_STORE(clk, 1, 5);
 
 	clk = clk_reg_prcc_pclk("p1_pclk6", "per1clk", clkrst1_base,
 				BIT(6), 0);
 	clk_register_clkdev(clk, "apb_pclk", "nmk-i2c.2");
+	PRCC_PCLK_STORE(clk, 1, 6);
 
 	clk = clk_reg_prcc_pclk("p1_pclk7", "per1clk", clkrst1_base,
 				BIT(7), 0);
 	clk_register_clkdev(clk, NULL, "spi3");
+	PRCC_PCLK_STORE(clk, 1, 7);
 
 	clk = clk_reg_prcc_pclk("p1_pclk8", "per1clk", clkrst1_base,
 				BIT(8), 0);
 	clk_register_clkdev(clk, "apb_pclk", "slimbus0");
+	PRCC_PCLK_STORE(clk, 1, 8);
 
 	clk = clk_reg_prcc_pclk("p1_pclk9", "per1clk", clkrst1_base,
 				BIT(9), 0);
 	clk_register_clkdev(clk, NULL, "gpio.0");
 	clk_register_clkdev(clk, NULL, "gpio.1");
 	clk_register_clkdev(clk, NULL, "gpioblock0");
+	PRCC_PCLK_STORE(clk, 1, 9);
 
 	clk = clk_reg_prcc_pclk("p1_pclk10", "per1clk", clkrst1_base,
 				BIT(10), 0);
 	clk_register_clkdev(clk, "apb_pclk", "nmk-i2c.4");
+	PRCC_PCLK_STORE(clk, 1, 10);
 
 	clk = clk_reg_prcc_pclk("p1_pclk11", "per1clk", clkrst1_base,
 				BIT(11), 0);
 	clk_register_clkdev(clk, "apb_pclk", "msp3");
 	clk_register_clkdev(clk, "apb_pclk", "ux500-msp-i2s.3");
+	PRCC_PCLK_STORE(clk, 1, 11);
 
 	clk = clk_reg_prcc_pclk("p2_pclk0", "per2clk", clkrst2_base,
 				BIT(0), 0);
 	clk_register_clkdev(clk, "apb_pclk", "nmk-i2c.3");
+	PRCC_PCLK_STORE(clk, 2, 0);
 
 	clk = clk_reg_prcc_pclk("p2_pclk1", "per2clk", clkrst2_base,
 				BIT(1), 0);
 	clk_register_clkdev(clk, NULL, "spi2");
+	PRCC_PCLK_STORE(clk, 2, 1);
 
 	clk = clk_reg_prcc_pclk("p2_pclk2", "per2clk", clkrst2_base,
 				BIT(2), 0);
 	clk_register_clkdev(clk, NULL, "spi1");
+	PRCC_PCLK_STORE(clk, 2, 2);
 
 	clk = clk_reg_prcc_pclk("p2_pclk3", "per2clk", clkrst2_base,
 				BIT(3), 0);
 	clk_register_clkdev(clk, NULL, "pwl");
+	PRCC_PCLK_STORE(clk, 2, 3);
 
 	clk = clk_reg_prcc_pclk("p2_pclk4", "per2clk", clkrst2_base,
 				BIT(4), 0);
 	clk_register_clkdev(clk, "apb_pclk", "sdi4");
+	PRCC_PCLK_STORE(clk, 2, 4);
 
 	clk = clk_reg_prcc_pclk("p2_pclk5", "per2clk", clkrst2_base,
 				BIT(5), 0);
 	clk_register_clkdev(clk, "apb_pclk", "msp2");
 	clk_register_clkdev(clk, "apb_pclk", "ux500-msp-i2s.2");
+	PRCC_PCLK_STORE(clk, 2, 5);
 
 	clk = clk_reg_prcc_pclk("p2_pclk6", "per2clk", clkrst2_base,
 				BIT(6), 0);
 	clk_register_clkdev(clk, "apb_pclk", "sdi1");
+	PRCC_PCLK_STORE(clk, 2, 6);
 
 	clk = clk_reg_prcc_pclk("p2_pclk7", "per2clk", clkrst2_base,
 				BIT(7), 0);
 	clk_register_clkdev(clk, "apb_pclk", "sdi3");
+	PRCC_PCLK_STORE(clk, 2, 7);
 
 	clk = clk_reg_prcc_pclk("p2_pclk8", "per2clk", clkrst2_base,
 				BIT(8), 0);
 	clk_register_clkdev(clk, NULL, "spi0");
+	PRCC_PCLK_STORE(clk, 2, 8);
 
 	clk = clk_reg_prcc_pclk("p2_pclk9", "per2clk", clkrst2_base,
 				BIT(9), 0);
 	clk_register_clkdev(clk, "hsir_hclk", "ste_hsi.0");
+	PRCC_PCLK_STORE(clk, 2, 9);
 
 	clk = clk_reg_prcc_pclk("p2_pclk10", "per2clk", clkrst2_base,
 				BIT(10), 0);
 	clk_register_clkdev(clk, "hsit_hclk", "ste_hsi.0");
+	PRCC_PCLK_STORE(clk, 2, 10);
 
 	clk = clk_reg_prcc_pclk("p2_pclk11", "per2clk", clkrst2_base,
 				BIT(11), 0);
 	clk_register_clkdev(clk, NULL, "gpio.6");
 	clk_register_clkdev(clk, NULL, "gpio.7");
 	clk_register_clkdev(clk, NULL, "gpioblock1");
+	PRCC_PCLK_STORE(clk, 2, 1);
 
 	clk = clk_reg_prcc_pclk("p2_pclk12", "per2clk", clkrst2_base,
 				BIT(12), 0);
+	PRCC_PCLK_STORE(clk, 2, 12);
 
 	clk = clk_reg_prcc_pclk("p3_pclk0", "per3clk", clkrst3_base,
 				BIT(0), 0);
 	clk_register_clkdev(clk, "fsmc", NULL);
 	clk_register_clkdev(clk, NULL, "smsc911x");
+	PRCC_PCLK_STORE(clk, 3, 0);
 
 	clk = clk_reg_prcc_pclk("p3_pclk1", "per3clk", clkrst3_base,
 				BIT(1), 0);
 	clk_register_clkdev(clk, "apb_pclk", "ssp0");
+	PRCC_PCLK_STORE(clk, 3, 1);
 
 	clk = clk_reg_prcc_pclk("p3_pclk2", "per3clk", clkrst3_base,
 				BIT(2), 0);
 	clk_register_clkdev(clk, "apb_pclk", "ssp1");
+	PRCC_PCLK_STORE(clk, 3, 2);
 
 	clk = clk_reg_prcc_pclk("p3_pclk3", "per3clk", clkrst3_base,
 				BIT(3), 0);
 	clk_register_clkdev(clk, "apb_pclk", "nmk-i2c.0");
+	PRCC_PCLK_STORE(clk, 3, 3);
 
 	clk = clk_reg_prcc_pclk("p3_pclk4", "per3clk", clkrst3_base,
 				BIT(4), 0);
 	clk_register_clkdev(clk, "apb_pclk", "sdi2");
+	PRCC_PCLK_STORE(clk, 3, 4);
 
 	clk = clk_reg_prcc_pclk("p3_pclk5", "per3clk", clkrst3_base,
 				BIT(5), 0);
 	clk_register_clkdev(clk, "apb_pclk", "ske");
 	clk_register_clkdev(clk, "apb_pclk", "nmk-ske-keypad");
+	PRCC_PCLK_STORE(clk, 3, 5);
 
 	clk = clk_reg_prcc_pclk("p3_pclk6", "per3clk", clkrst3_base,
 				BIT(6), 0);
 	clk_register_clkdev(clk, "apb_pclk", "uart2");
+	PRCC_PCLK_STORE(clk, 3, 6);
 
 	clk = clk_reg_prcc_pclk("p3_pclk7", "per3clk", clkrst3_base,
 				BIT(7), 0);
 	clk_register_clkdev(clk, "apb_pclk", "sdi5");
+	PRCC_PCLK_STORE(clk, 3, 7);
 
 	clk = clk_reg_prcc_pclk("p3_pclk8", "per3clk", clkrst3_base,
 				BIT(8), 0);
@@ -430,48 +474,59 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 	clk_register_clkdev(clk, NULL, "gpio.4");
 	clk_register_clkdev(clk, NULL, "gpio.5");
 	clk_register_clkdev(clk, NULL, "gpioblock2");
+	PRCC_PCLK_STORE(clk, 3, 8);
 
 	clk = clk_reg_prcc_pclk("p5_pclk0", "per5clk", clkrst5_base,
 				BIT(0), 0);
 	clk_register_clkdev(clk, "usb", "musb-ux500.0");
+	PRCC_PCLK_STORE(clk, 5, 0);
 
 	clk = clk_reg_prcc_pclk("p5_pclk1", "per5clk", clkrst5_base,
 				BIT(1), 0);
 	clk_register_clkdev(clk, NULL, "gpio.8");
 	clk_register_clkdev(clk, NULL, "gpioblock3");
+	PRCC_PCLK_STORE(clk, 5, 1);
 
 	clk = clk_reg_prcc_pclk("p6_pclk0", "per6clk", clkrst6_base,
 				BIT(0), 0);
 	clk_register_clkdev(clk, "apb_pclk", "rng");
+	PRCC_PCLK_STORE(clk, 6, 0);
 
 	clk = clk_reg_prcc_pclk("p6_pclk1", "per6clk", clkrst6_base,
 				BIT(1), 0);
 	clk_register_clkdev(clk, NULL, "cryp0");
 	clk_register_clkdev(clk, NULL, "cryp1");
+	PRCC_PCLK_STORE(clk, 6, 1);
 
 	clk = clk_reg_prcc_pclk("p6_pclk2", "per6clk", clkrst6_base,
 				BIT(2), 0);
 	clk_register_clkdev(clk, NULL, "hash0");
+	PRCC_PCLK_STORE(clk, 6, 2);
 
 	clk = clk_reg_prcc_pclk("p6_pclk3", "per6clk", clkrst6_base,
 				BIT(3), 0);
 	clk_register_clkdev(clk, NULL, "pka");
+	PRCC_PCLK_STORE(clk, 6, 3);
 
 	clk = clk_reg_prcc_pclk("p6_pclk4", "per6clk", clkrst6_base,
 				BIT(4), 0);
 	clk_register_clkdev(clk, NULL, "hash1");
+	PRCC_PCLK_STORE(clk, 6, 4);
 
 	clk = clk_reg_prcc_pclk("p6_pclk5", "per6clk", clkrst6_base,
 				BIT(5), 0);
 	clk_register_clkdev(clk, NULL, "cfgreg");
+	PRCC_PCLK_STORE(clk, 6, 5);
 
 	clk = clk_reg_prcc_pclk("p6_pclk6", "per6clk", clkrst6_base,
 				BIT(6), 0);
 	clk_register_clkdev(clk, "apb_pclk", "mtu0");
+	PRCC_PCLK_STORE(clk, 6, 6);
 
 	clk = clk_reg_prcc_pclk("p6_pclk7", "per6clk", clkrst6_base,
 				BIT(7), 0);
 	clk_register_clkdev(clk, "apb_pclk", "mtu1");
+	PRCC_PCLK_STORE(clk, 6, 7);
 
 	/* PRCC K-clocks
 	 *
@@ -603,5 +658,7 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 			clk_data.clk_num = ARRAY_SIZE(prcmu_clk);
 			of_clk_add_provider(child, of_clk_src_onecell_get, &clk_data);
 		}
+		if (!of_node_cmp(child->name, "prcc-periph-clock"))
+			of_clk_add_provider(child, ux500_twocell_get, prcc_pclk);
 	}
 }
-- 
1.7.10.4

