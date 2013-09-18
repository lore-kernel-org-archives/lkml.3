Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab3IRMTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:19:40 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:39854 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab3IRMPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:15:13 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 25/41] clk: ux500: Add Device Tree support for the PRCMU clock
Date: Wed, 18 Sep 2013 13:14:22 +0100
Message-Id: <1379506478-16625-26-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables clocks to be specified from Device Tree via phandles
to the "prcmu-clock" node.

Acked-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/clk/ux500/u8500_of_clk.c | 50 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 48 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/ux500/u8500_of_clk.c b/drivers/clk/ux500/u8500_of_clk.c
index b9b3317..f5534fd 100644
--- a/drivers/clk/ux500/u8500_of_clk.c
+++ b/drivers/clk/ux500/u8500_of_clk.c
@@ -15,6 +15,8 @@
 #include <linux/platform_data/clk-ux500.h>
 #include "clk.h"
 
+static struct clk *prcmu_clk[PRCMU_NUM_CLKS];
+
 #define PRCC_SHOW(clk, base, bit) \
 	clk[(base * PRCC_PERIPHS_PER_CLUSTER) + bit]
 
@@ -61,12 +63,15 @@ void u8500_of_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 	/* Clock sources */
 	clk = clk_reg_prcmu_gate("soc0_pll", NULL, PRCMU_PLLSOC0,
 				CLK_IS_ROOT|CLK_IGNORE_UNUSED);
+	prcmu_clk[PRCMU_PLLSOC0] = clk;
 
 	clk = clk_reg_prcmu_gate("soc1_pll", NULL, PRCMU_PLLSOC1,
 				CLK_IS_ROOT|CLK_IGNORE_UNUSED);
+	prcmu_clk[PRCMU_PLLSOC1] = clk;
 
 	clk = clk_reg_prcmu_gate("ddr_pll", NULL, PRCMU_PLLDDR,
 				CLK_IS_ROOT|CLK_IGNORE_UNUSED);
+	prcmu_clk[PRCMU_PLLDDR] = clk;
 
 	/* FIXME: Add sys, ulp and int clocks here. */
 
@@ -94,93 +99,128 @@ void u8500_of_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 	else
 		clk = clk_reg_prcmu_gate("sgclk", NULL,
 					PRCMU_SGACLK, CLK_IS_ROOT);
+	prcmu_clk[PRCMU_SGACLK] = clk;
 
 	clk = clk_reg_prcmu_gate("uartclk", NULL, PRCMU_UARTCLK, CLK_IS_ROOT);
+	prcmu_clk[PRCMU_UARTCLK] = clk;
 
 	clk = clk_reg_prcmu_gate("msp02clk", NULL, PRCMU_MSP02CLK, CLK_IS_ROOT);
+	prcmu_clk[PRCMU_MSP02CLK] = clk;
 
 	clk = clk_reg_prcmu_gate("msp1clk", NULL, PRCMU_MSP1CLK, CLK_IS_ROOT);
+	prcmu_clk[PRCMU_MSP1CLK] = clk;
 
 	clk = clk_reg_prcmu_gate("i2cclk", NULL, PRCMU_I2CCLK, CLK_IS_ROOT);
+	prcmu_clk[PRCMU_I2CCLK] = clk;
 
 	clk = clk_reg_prcmu_gate("slimclk", NULL, PRCMU_SLIMCLK, CLK_IS_ROOT);
+	prcmu_clk[PRCMU_SLIMCLK] = clk;
 
 	clk = clk_reg_prcmu_gate("per1clk", NULL, PRCMU_PER1CLK, CLK_IS_ROOT);
+	prcmu_clk[PRCMU_PER1CLK] = clk;
 
 	clk = clk_reg_prcmu_gate("per2clk", NULL, PRCMU_PER2CLK, CLK_IS_ROOT);
+	prcmu_clk[PRCMU_PER2CLK] = clk;
 
 	clk = clk_reg_prcmu_gate("per3clk", NULL, PRCMU_PER3CLK, CLK_IS_ROOT);
+	prcmu_clk[PRCMU_PER3CLK] = clk;
 
 	clk = clk_reg_prcmu_gate("per5clk", NULL, PRCMU_PER5CLK, CLK_IS_ROOT);
+	prcmu_clk[PRCMU_PER5CLK] = clk;
 
 	clk = clk_reg_prcmu_gate("per6clk", NULL, PRCMU_PER6CLK, CLK_IS_ROOT);
+	prcmu_clk[PRCMU_PER6CLK] = clk;
 
 	clk = clk_reg_prcmu_gate("per7clk", NULL, PRCMU_PER7CLK, CLK_IS_ROOT);
+	prcmu_clk[PRCMU_PER7CLK] = clk;
 
 	clk = clk_reg_prcmu_scalable("lcdclk", NULL, PRCMU_LCDCLK, 0,
 				CLK_IS_ROOT|CLK_SET_RATE_GATE);
+	prcmu_clk[PRCMU_LCDCLK] = clk;
 
 	clk = clk_reg_prcmu_opp_gate("bmlclk", NULL, PRCMU_BMLCLK, CLK_IS_ROOT);
+	prcmu_clk[PRCMU_BMLCLK] = clk;
 
 	clk = clk_reg_prcmu_scalable("hsitxclk", NULL, PRCMU_HSITXCLK, 0,
 				CLK_IS_ROOT|CLK_SET_RATE_GATE);
+	prcmu_clk[PRCMU_HSITXCLK] = clk;
 
 	clk = clk_reg_prcmu_scalable("hsirxclk", NULL, PRCMU_HSIRXCLK, 0,
 				CLK_IS_ROOT|CLK_SET_RATE_GATE);
+	prcmu_clk[PRCMU_HSIRXCLK] = clk;
 
 	clk = clk_reg_prcmu_scalable("hdmiclk", NULL, PRCMU_HDMICLK, 0,
 				CLK_IS_ROOT|CLK_SET_RATE_GATE);
+	prcmu_clk[PRCMU_HDMICLK] = clk;
 
 	clk = clk_reg_prcmu_gate("apeatclk", NULL, PRCMU_APEATCLK, CLK_IS_ROOT);
+	prcmu_clk[PRCMU_APEATCLK] = clk;
 
 	clk = clk_reg_prcmu_gate("apetraceclk", NULL, PRCMU_APETRACECLK,
 				CLK_IS_ROOT);
+	prcmu_clk[PRCMU_APETRACECLK] = clk;
 
 	clk = clk_reg_prcmu_gate("mcdeclk", NULL, PRCMU_MCDECLK, CLK_IS_ROOT);
+	prcmu_clk[PRCMU_MCDECLK] = clk;
 
 	clk = clk_reg_prcmu_opp_gate("ipi2cclk", NULL, PRCMU_IPI2CCLK,
 				CLK_IS_ROOT);
+	prcmu_clk[PRCMU_IPI2CCLK] = clk;
 
 	clk = clk_reg_prcmu_gate("dsialtclk", NULL, PRCMU_DSIALTCLK,
 				CLK_IS_ROOT);
+	prcmu_clk[PRCMU_DSIALTCLK] = clk;
 
 	clk = clk_reg_prcmu_gate("dmaclk", NULL, PRCMU_DMACLK, CLK_IS_ROOT);
+	prcmu_clk[PRCMU_DMACLK] = clk;
 
 	clk = clk_reg_prcmu_gate("b2r2clk", NULL, PRCMU_B2R2CLK, CLK_IS_ROOT);
+	prcmu_clk[PRCMU_B2R2CLK] = clk;
 
 	clk = clk_reg_prcmu_scalable("tvclk", NULL, PRCMU_TVCLK, 0,
 				CLK_IS_ROOT|CLK_SET_RATE_GATE);
+	prcmu_clk[PRCMU_TVCLK] = clk;
 
 	clk = clk_reg_prcmu_gate("sspclk", NULL, PRCMU_SSPCLK, CLK_IS_ROOT);
+	prcmu_clk[PRCMU_SSPCLK] = clk;
 
 	clk = clk_reg_prcmu_gate("rngclk", NULL, PRCMU_RNGCLK, CLK_IS_ROOT);
+	prcmu_clk[PRCMU_RNGCLK] = clk;
 
 	clk = clk_reg_prcmu_gate("uiccclk", NULL, PRCMU_UICCCLK, CLK_IS_ROOT);
+	prcmu_clk[PRCMU_UICCCLK] = clk;
 
 	clk = clk_reg_prcmu_gate("timclk", NULL, PRCMU_TIMCLK, CLK_IS_ROOT);
+	prcmu_clk[PRCMU_TIMCLK] = clk;
 
 	clk = clk_reg_prcmu_opp_volt_scalable("sdmmcclk", NULL, PRCMU_SDMMCCLK,
 					100000000,
 					CLK_IS_ROOT|CLK_SET_RATE_GATE);
+	prcmu_clk[PRCMU_SDMMCCLK] = clk;
 
 	clk = clk_reg_prcmu_scalable("dsi_pll", "hdmiclk",
 				PRCMU_PLLDSI, 0, CLK_SET_RATE_GATE);
-
+	prcmu_clk[PRCMU_PLLDSI] = clk;
 
 	clk = clk_reg_prcmu_scalable("dsi0clk", "dsi_pll",
 				PRCMU_DSI0CLK, 0, CLK_SET_RATE_GATE);
+	prcmu_clk[PRCMU_DSI0CLK] = clk;
 
 	clk = clk_reg_prcmu_scalable("dsi1clk", "dsi_pll",
 				PRCMU_DSI1CLK, 0, CLK_SET_RATE_GATE);
+	prcmu_clk[PRCMU_DSI1CLK] = clk;
 
 	clk = clk_reg_prcmu_scalable("dsi0escclk", "tvclk",
 				PRCMU_DSI0ESCCLK, 0, CLK_SET_RATE_GATE);
+	prcmu_clk[PRCMU_DSI0ESCCLK] = clk;
 
 	clk = clk_reg_prcmu_scalable("dsi1escclk", "tvclk",
 				PRCMU_DSI1ESCCLK, 0, CLK_SET_RATE_GATE);
+	prcmu_clk[PRCMU_DSI1ESCCLK] = clk;
 
 	clk = clk_reg_prcmu_scalable("dsi2escclk", "tvclk",
 				PRCMU_DSI2ESCCLK, 0, CLK_SET_RATE_GATE);
+	prcmu_clk[PRCMU_DSI2ESCCLK] = clk;
 
 	clk = clk_reg_prcmu_scalable_rate("armss", NULL,
 				PRCMU_ARMSS, 0, CLK_IS_ROOT|CLK_IGNORE_UNUSED);
@@ -417,6 +457,12 @@ void u8500_of_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 			clkrst6_base, BIT(0), CLK_SET_RATE_GATE);
 
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
1.8.1.2

