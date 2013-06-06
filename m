Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933678Ab3FFMWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:22:50 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:59686 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933446Ab3FFMSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:18:04 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 19/33] clk: ux500: Add Device Tree support for the PRCMU clock
Date: Thu,  6 Jun 2013 13:17:07 +0100
Message-Id: <1370521041-32318-20-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables clocks to be specified from Device Tree via phandles
to the "prcmu-clock" node.

Cc: Mike Turquette <mturquette@linaro.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/clk/ux500/u8500_clk.c |   50 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 48 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/ux500/u8500_clk.c b/drivers/clk/ux500/u8500_clk.c
index 3a7040b..4f5ad4c 100644
--- a/drivers/clk/ux500/u8500_clk.c
+++ b/drivers/clk/ux500/u8500_clk.c
@@ -15,6 +15,8 @@
 #include <linux/platform_data/clk-ux500.h>
 #include "clk.h"
 
+static struct clk *prcmu_clk[PRCMU_NUM_CLKS];
+
 struct clk *ux500_twocell_get(struct of_phandle_args *clkspec, void *data)
 {
 	struct clk **clk_data = data;
@@ -52,14 +54,17 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 	clk = clk_reg_prcmu_gate("soc0_pll", NULL, PRCMU_PLLSOC0,
 				CLK_IS_ROOT|CLK_IGNORE_UNUSED);
 	clk_register_clkdev(clk, "soc0_pll", NULL);
+	prcmu_clk[PRCMU_PLLSOC0] = clk;
 
 	clk = clk_reg_prcmu_gate("soc1_pll", NULL, PRCMU_PLLSOC1,
 				CLK_IS_ROOT|CLK_IGNORE_UNUSED);
 	clk_register_clkdev(clk, "soc1_pll", NULL);
+	prcmu_clk[PRCMU_PLLSOC1] = clk;
 
 	clk = clk_reg_prcmu_gate("ddr_pll", NULL, PRCMU_PLLDDR,
 				CLK_IS_ROOT|CLK_IGNORE_UNUSED);
 	clk_register_clkdev(clk, "ddr_pll", NULL);
+	prcmu_clk[PRCMU_PLLDDR] = clk;
 
 	/* FIXME: Add sys, ulp and int clocks here. */
 
@@ -90,65 +95,84 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 		clk = clk_reg_prcmu_gate("sgclk", NULL,
 					PRCMU_SGACLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "mali");
+	prcmu_clk[PRCMU_SGACLK] = clk;
 
 	clk = clk_reg_prcmu_gate("uartclk", NULL, PRCMU_UARTCLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "UART");
+	prcmu_clk[PRCMU_UARTCLK] = clk;
 
 	clk = clk_reg_prcmu_gate("msp02clk", NULL, PRCMU_MSP02CLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "MSP02");
+	prcmu_clk[PRCMU_MSP02CLK] = clk;
 
 	clk = clk_reg_prcmu_gate("msp1clk", NULL, PRCMU_MSP1CLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "MSP1");
+	prcmu_clk[PRCMU_MSP1CLK] = clk;
 
 	clk = clk_reg_prcmu_gate("i2cclk", NULL, PRCMU_I2CCLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "I2C");
+	prcmu_clk[PRCMU_I2CCLK] = clk;
 
 	clk = clk_reg_prcmu_gate("slimclk", NULL, PRCMU_SLIMCLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "slim");
+	prcmu_clk[PRCMU_SLIMCLK] = clk;
 
 	clk = clk_reg_prcmu_gate("per1clk", NULL, PRCMU_PER1CLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "PERIPH1");
+	prcmu_clk[PRCMU_PER1CLK] = clk;
 
 	clk = clk_reg_prcmu_gate("per2clk", NULL, PRCMU_PER2CLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "PERIPH2");
+	prcmu_clk[PRCMU_PER2CLK] = clk;
 
 	clk = clk_reg_prcmu_gate("per3clk", NULL, PRCMU_PER3CLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "PERIPH3");
+	prcmu_clk[PRCMU_PER3CLK] = clk;
 
 	clk = clk_reg_prcmu_gate("per5clk", NULL, PRCMU_PER5CLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "PERIPH5");
+	prcmu_clk[PRCMU_PER5CLK] = clk;
 
 	clk = clk_reg_prcmu_gate("per6clk", NULL, PRCMU_PER6CLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "PERIPH6");
+	prcmu_clk[PRCMU_PER6CLK] = clk;
 
 	clk = clk_reg_prcmu_gate("per7clk", NULL, PRCMU_PER7CLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "PERIPH7");
+	prcmu_clk[PRCMU_PER7CLK] = clk;
 
 	clk = clk_reg_prcmu_scalable("lcdclk", NULL, PRCMU_LCDCLK, 0,
 				CLK_IS_ROOT|CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "lcd");
 	clk_register_clkdev(clk, "lcd", "mcde");
+	prcmu_clk[PRCMU_LCDCLK] = clk;
 
 	clk = clk_reg_prcmu_opp_gate("bmlclk", NULL, PRCMU_BMLCLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "bml");
+	prcmu_clk[PRCMU_BMLCLK] = clk;
 
 	clk = clk_reg_prcmu_scalable("hsitxclk", NULL, PRCMU_HSITXCLK, 0,
 				CLK_IS_ROOT|CLK_SET_RATE_GATE);
+	prcmu_clk[PRCMU_HSITXCLK] = clk;
 
 	clk = clk_reg_prcmu_scalable("hsirxclk", NULL, PRCMU_HSIRXCLK, 0,
 				CLK_IS_ROOT|CLK_SET_RATE_GATE);
+	prcmu_clk[PRCMU_HSIRXCLK] = clk;
 
 	clk = clk_reg_prcmu_scalable("hdmiclk", NULL, PRCMU_HDMICLK, 0,
 				CLK_IS_ROOT|CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "hdmi");
 	clk_register_clkdev(clk, "hdmi", "mcde");
+	prcmu_clk[PRCMU_HDMICLK] = clk;
 
 	clk = clk_reg_prcmu_gate("apeatclk", NULL, PRCMU_APEATCLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "apeat");
+	prcmu_clk[PRCMU_APEATCLK] = clk;
 
 	clk = clk_reg_prcmu_gate("apetraceclk", NULL, PRCMU_APETRACECLK,
 				CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "apetrace");
+	prcmu_clk[PRCMU_APETRACECLK] = clk;
 
 	clk = clk_reg_prcmu_gate("mcdeclk", NULL, PRCMU_MCDECLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "mcde");
@@ -156,76 +180,92 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 	clk_register_clkdev(clk, "dsisys", "dsilink.0");
 	clk_register_clkdev(clk, "dsisys", "dsilink.1");
 	clk_register_clkdev(clk, "dsisys", "dsilink.2");
+	prcmu_clk[PRCMU_MCDECLK] = clk;
 
 	clk = clk_reg_prcmu_opp_gate("ipi2cclk", NULL, PRCMU_IPI2CCLK,
 				CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "ipi2");
+	prcmu_clk[PRCMU_IPI2CCLK] = clk;
 
 	clk = clk_reg_prcmu_gate("dsialtclk", NULL, PRCMU_DSIALTCLK,
 				CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "dsialt");
+	prcmu_clk[PRCMU_DSIALTCLK] = clk;
 
 	clk = clk_reg_prcmu_gate("dmaclk", NULL, PRCMU_DMACLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "dma40.0");
+	prcmu_clk[PRCMU_DMACLK] = clk;
 
 	clk = clk_reg_prcmu_gate("b2r2clk", NULL, PRCMU_B2R2CLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "b2r2");
 	clk_register_clkdev(clk, NULL, "b2r2_core");
 	clk_register_clkdev(clk, NULL, "U8500-B2R2.0");
+	prcmu_clk[PRCMU_B2R2CLK] = clk;
 
 	clk = clk_reg_prcmu_scalable("tvclk", NULL, PRCMU_TVCLK, 0,
 				CLK_IS_ROOT|CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "tv");
 	clk_register_clkdev(clk, "tv", "mcde");
+	prcmu_clk[PRCMU_TVCLK] = clk;
 
 	clk = clk_reg_prcmu_gate("sspclk", NULL, PRCMU_SSPCLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "SSP");
+	prcmu_clk[PRCMU_SSPCLK] = clk;
 
 	clk = clk_reg_prcmu_gate("rngclk", NULL, PRCMU_RNGCLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "rngclk");
+	prcmu_clk[PRCMU_RNGCLK] = clk;
 
 	clk = clk_reg_prcmu_gate("uiccclk", NULL, PRCMU_UICCCLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "uicc");
+	prcmu_clk[PRCMU_UICCCLK] = clk;
 
 	clk = clk_reg_prcmu_gate("timclk", NULL, PRCMU_TIMCLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "mtu0");
 	clk_register_clkdev(clk, NULL, "mtu1");
+	prcmu_clk[PRCMU_TIMCLK] = clk;
 
 	clk = clk_reg_prcmu_opp_volt_scalable("sdmmcclk", NULL, PRCMU_SDMMCCLK,
 					100000000,
 					CLK_IS_ROOT|CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "sdmmc");
+	prcmu_clk[PRCMU_SDMMCCLK] = clk;
 
 	clk = clk_reg_prcmu_scalable("dsi_pll", "hdmiclk",
 				PRCMU_PLLDSI, 0, CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, "dsihs2", "mcde");
 	clk_register_clkdev(clk, "dsihs2", "dsilink.2");
-
+	prcmu_clk[PRCMU_PLLDSI] = clk;
 
 	clk = clk_reg_prcmu_scalable("dsi0clk", "dsi_pll",
 				PRCMU_DSI0CLK, 0, CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, "dsihs0", "mcde");
 	clk_register_clkdev(clk, "dsihs0", "dsilink.0");
+	prcmu_clk[PRCMU_DSI0CLK] = clk;
 
 	clk = clk_reg_prcmu_scalable("dsi1clk", "dsi_pll",
 				PRCMU_DSI1CLK, 0, CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, "dsihs1", "mcde");
 	clk_register_clkdev(clk, "dsihs1", "dsilink.1");
+	prcmu_clk[PRCMU_DSI1CLK] = clk;
 
 	clk = clk_reg_prcmu_scalable("dsi0escclk", "tvclk",
 				PRCMU_DSI0ESCCLK, 0, CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, "dsilp0", "dsilink.0");
 	clk_register_clkdev(clk, "dsilp0", "mcde");
+	prcmu_clk[PRCMU_DSI0ESCCLK] = clk;
 
 	clk = clk_reg_prcmu_scalable("dsi1escclk", "tvclk",
 				PRCMU_DSI1ESCCLK, 0, CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, "dsilp1", "dsilink.1");
 	clk_register_clkdev(clk, "dsilp1", "mcde");
+	prcmu_clk[PRCMU_DSI1ESCCLK] = clk;
 
 	clk = clk_reg_prcmu_scalable("dsi2escclk", "tvclk",
 				PRCMU_DSI2ESCCLK, 0, CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, "dsilp2", "dsilink.2");
 	clk_register_clkdev(clk, "dsilp2", "mcde");
+	prcmu_clk[PRCMU_DSI2ESCCLK] = clk;
 
 	clk = clk_reg_prcmu_scalable_rate("armss", NULL,
 				PRCMU_ARMSS, 0, CLK_IS_ROOT|CLK_IGNORE_UNUSED);
@@ -556,6 +596,12 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 		return;
 
 	for_each_child_of_node(np, child) {
-		/* Place holder for supported nodes. */
+		static struct clk_onecell_data clk_data;
+
+		if (!of_node_cmp(child->name, "prcmu-clock")) {
+			clk_data.clks = prcmu_clk;
+			clk_data.clk_num = ARRAY_SIZE(prcmu_clk);
+			of_clk_add_provider(child, of_clk_src_onecell_get, &clk_data);
+		}
 	}
 }
-- 
1.7.10.4

