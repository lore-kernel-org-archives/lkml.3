Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab3FKLJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 07:09:29 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:39608 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab3FKLJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 07:09:28 -0400
Date: Tue, 11 Jun 2013 12:09:23 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com,
        Mike Turquette <mturquette@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 21/33 v2] clk: ux500: Add Device Tree support for the PRCC
 Kernel clock
Message-ID: <20130611110923.GB3330@laptop>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
 <1370521041-32318-22-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370521041-32318-22-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables clocks to be specified from Device Tree via phandles
to the "prcc-kernel-clock" node.

Cc: Mike Turquette <mturquette@linaro.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/drivers/clk/ux500/u8500_clk.c b/drivers/clk/ux500/u8500_clk.c
index ff02a26..c9ac350 100644
--- a/drivers/clk/ux500/u8500_clk.c
+++ b/drivers/clk/ux500/u8500_clk.c
@@ -20,11 +20,14 @@
 
 static struct clk *prcmu_clk[PRCMU_NUM_CLKS];
 static struct clk *prcc_pclk[(PRCC_NUM_PERIPH_CLUSTERS + 1) * PRCC_PERIPHS_PER_CLUSTER];
+static struct clk *prcc_kclk[(PRCC_NUM_PERIPH_CLUSTERS + 1) * PRCC_PERIPHS_PER_CLUSTER];
 
 #define PRCC_SHOW(clk, base, bit) \
 	clk[(base * PRCC_PERIPHS_PER_CLUSTER) + bit]
 #define PRCC_PCLK_STORE(clk, base, bit)	\
 	prcc_pclk[(base * PRCC_PERIPHS_PER_CLUSTER) + bit] = clk
+#define PRCC_KCLK_STORE(clk, base, bit)        \
+	prcc_kclk[(base * PRCC_PERIPHS_PER_CLUSTER) + bit] = clk
 
 struct clk *ux500_twocell_get(struct of_phandle_args *clkspec, void *data)
 {
@@ -538,110 +541,136 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
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
@@ -658,5 +687,8 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 		}
 		if (!of_node_cmp(child->name, "prcc-periph-clock"))
 			of_clk_add_provider(child, ux500_twocell_get, prcc_pclk);
+
+		if (!of_node_cmp(child->name, "prcc-kernel-clock"))
+			of_clk_add_provider(child, ux500_twocell_get, prcc_kclk);
 	}
 }
