Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223Ab3FFMSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:18:14 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:51378 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933428Ab3FFMSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:18:07 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 21/33] clk: ux500: Add Device Tree support for the PRCC Kernel clock
Date: Thu,  6 Jun 2013 13:17:09 +0100
Message-Id: <1370521041-32318-22-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables clocks to be specified from Device Tree via phandles
to the "prcc-kernel-clock" node.

Cc: Mike Turquette <mturquette@linaro.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/clk/ux500/u8500_clk.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/clk/ux500/u8500_clk.c b/drivers/clk/ux500/u8500_clk.c
index 86de1a7..c3ed09c 100644
--- a/drivers/clk/ux500/u8500_clk.c
+++ b/drivers/clk/ux500/u8500_clk.c
@@ -20,6 +20,7 @@
 
 static struct clk *prcmu_clk[PRCMU_NUM_CLKS];
 static struct clk *prcc_pclk[(PRCC_NUM_PERIPH_CLUSTERS + 1) * PRCC_PERIPHS_PER_CLUSTER];
+static struct clk *prcc_kclk[(PRCC_NUM_PERIPH_CLUSTERS + 1) * PRCC_PERIPHS_PER_CLUSTER];
 
 #define PRCC_SHOW(clk, base, bit) \
 	clk[(base * PRCC_PERIPHS_PER_CLUSTER) + bit]
@@ -540,110 +541,136 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 	clk = clk_reg_prcc_kclk("p1_uart0_kclk", "uartclk",
 			clkrst1_base, BIT(0), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "uart0");
+	PRCC_KCLK_STORE(clk, 1, 0);
 
 	clk = clk_reg_prcc_kclk("p1_uart1_kclk", "uartclk",
 			clkrst1_base, BIT(1), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "uart1");
+	PRCC_KCLK_STORE(clk, 1, 1);
 
 	clk = clk_reg_prcc_kclk("p1_i2c1_kclk", "i2cclk",
 			clkrst1_base, BIT(2), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "nmk-i2c.1");
+	PRCC_KCLK_STORE(clk, 1, 2);
 
 	clk = clk_reg_prcc_kclk("p1_msp0_kclk", "msp02clk",
 			clkrst1_base, BIT(3), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "msp0");
 	clk_register_clkdev(clk, NULL, "ux500-msp-i2s.0");
+	PRCC_KCLK_STORE(clk, 1, 3);
 
 	clk = clk_reg_prcc_kclk("p1_msp1_kclk", "msp1clk",
 			clkrst1_base, BIT(4), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "msp1");
 	clk_register_clkdev(clk, NULL, "ux500-msp-i2s.1");
+	PRCC_KCLK_STORE(clk, 1, 4);
 
 	clk = clk_reg_prcc_kclk("p1_sdi0_kclk", "sdmmcclk",
 			clkrst1_base, BIT(5), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "sdi0");
+	PRCC_KCLK_STORE(clk, 1, 5);
 
 	clk = clk_reg_prcc_kclk("p1_i2c2_kclk", "i2cclk",
 			clkrst1_base, BIT(6), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "nmk-i2c.2");
+	PRCC_KCLK_STORE(clk, 1, 6);
 
 	clk = clk_reg_prcc_kclk("p1_slimbus0_kclk", "slimclk",
 			clkrst1_base, BIT(8), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "slimbus0");
+	PRCC_KCLK_STORE(clk, 1, 8);
 
 	clk = clk_reg_prcc_kclk("p1_i2c4_kclk", "i2cclk",
 			clkrst1_base, BIT(9), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "nmk-i2c.4");
+	PRCC_KCLK_STORE(clk, 1, 9);
 
 	clk = clk_reg_prcc_kclk("p1_msp3_kclk", "msp1clk",
 			clkrst1_base, BIT(10), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "msp3");
 	clk_register_clkdev(clk, NULL, "ux500-msp-i2s.3");
+	PRCC_KCLK_STORE(clk, 1, 10);
 
 	/* Periph2 */
 	clk = clk_reg_prcc_kclk("p2_i2c3_kclk", "i2cclk",
 			clkrst2_base, BIT(0), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "nmk-i2c.3");
+	PRCC_KCLK_STORE(clk, 2, 0);
 
 	clk = clk_reg_prcc_kclk("p2_sdi4_kclk", "sdmmcclk",
 			clkrst2_base, BIT(2), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "sdi4");
+	PRCC_KCLK_STORE(clk, 2, 2);
 
 	clk = clk_reg_prcc_kclk("p2_msp2_kclk", "msp02clk",
 			clkrst2_base, BIT(3), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "msp2");
 	clk_register_clkdev(clk, NULL, "ux500-msp-i2s.2");
+	PRCC_KCLK_STORE(clk, 2, 3);
 
 	clk = clk_reg_prcc_kclk("p2_sdi1_kclk", "sdmmcclk",
 			clkrst2_base, BIT(4), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "sdi1");
+	PRCC_KCLK_STORE(clk, 2, 4);
 
 	clk = clk_reg_prcc_kclk("p2_sdi3_kclk", "sdmmcclk",
 			clkrst2_base, BIT(5), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "sdi3");
+	PRCC_KCLK_STORE(clk, 2, 5);
 
 	/* Note that rate is received from parent. */
 	clk = clk_reg_prcc_kclk("p2_ssirx_kclk", "hsirxclk",
 			clkrst2_base, BIT(6),
 			CLK_SET_RATE_GATE|CLK_SET_RATE_PARENT);
+	PRCC_KCLK_STORE(clk, 2, 6);
+
 	clk = clk_reg_prcc_kclk("p2_ssitx_kclk", "hsitxclk",
 			clkrst2_base, BIT(7),
 			CLK_SET_RATE_GATE|CLK_SET_RATE_PARENT);
+	PRCC_KCLK_STORE(clk, 2, 7);
 
 	/* Periph3 */
 	clk = clk_reg_prcc_kclk("p3_ssp0_kclk", "sspclk",
 			clkrst3_base, BIT(1), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "ssp0");
+	PRCC_KCLK_STORE(clk, 3, 1);
 
 	clk = clk_reg_prcc_kclk("p3_ssp1_kclk", "sspclk",
 			clkrst3_base, BIT(2), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "ssp1");
+	PRCC_KCLK_STORE(clk, 3, 2);
 
 	clk = clk_reg_prcc_kclk("p3_i2c0_kclk", "i2cclk",
 			clkrst3_base, BIT(3), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "nmk-i2c.0");
+	PRCC_KCLK_STORE(clk, 3, 3);
 
 	clk = clk_reg_prcc_kclk("p3_sdi2_kclk", "sdmmcclk",
 			clkrst3_base, BIT(4), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "sdi2");
+	PRCC_KCLK_STORE(clk, 3, 4);
 
 	clk = clk_reg_prcc_kclk("p3_ske_kclk", "rtc32k",
 			clkrst3_base, BIT(5), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "ske");
 	clk_register_clkdev(clk, NULL, "nmk-ske-keypad");
+	PRCC_KCLK_STORE(clk, 3, 5);
 
 	clk = clk_reg_prcc_kclk("p3_uart2_kclk", "uartclk",
 			clkrst3_base, BIT(6), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "uart2");
+	PRCC_KCLK_STORE(clk, 3, 6);
 
 	clk = clk_reg_prcc_kclk("p3_sdi5_kclk", "sdmmcclk",
 			clkrst3_base, BIT(7), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "sdi5");
+	PRCC_KCLK_STORE(clk, 3, 7);
 
 	/* Periph6 */
 	clk = clk_reg_prcc_kclk("p3_rng_kclk", "rngclk",
 			clkrst6_base, BIT(0), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "rng");
+	PRCC_KCLK_STORE(clk, 6, 0);
 
 	if (of_have_populated_dt())
 		np = of_find_matching_node(NULL, u8500_clk_of_match);
@@ -660,5 +687,8 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 		}
 		if (!of_node_cmp(child->name, "prcc-periph-clock"))
 			of_clk_add_provider(child, ux500_twocell_get, prcc_pclk);
+
+		if (!of_node_cmp(child->name, "prcc-kernel-clock"))
+			of_clk_add_provider(child, ux500_twocell_get, prcc_kclk);
 	}
 }
-- 
1.7.10.4

