Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab3IRMPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:15:18 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:49133 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab3IRMPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:15:14 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 26/41] clk: ux500: Add Device Tree support for the PRCC Peripheral clock
Date: Wed, 18 Sep 2013 13:14:23 +0100
Message-Id: <1379506478-16625-27-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables clocks to be specified from Device Tree via phandles
to the "prcc-periph-clock" node.

Acked-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/clk/ux500/u8500_of_clk.c | 52 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/clk/ux500/u8500_of_clk.c b/drivers/clk/ux500/u8500_of_clk.c
index f5534fd..dcc736a 100644
--- a/drivers/clk/ux500/u8500_of_clk.c
+++ b/drivers/clk/ux500/u8500_of_clk.c
@@ -15,10 +15,16 @@
 #include <linux/platform_data/clk-ux500.h>
 #include "clk.h"
 
+#define PRCC_NUM_PERIPH_CLUSTERS 6
+#define PRCC_PERIPHS_PER_CLUSTER 32
+
 static struct clk *prcmu_clk[PRCMU_NUM_CLKS];
+static struct clk *prcc_pclk[(PRCC_NUM_PERIPH_CLUSTERS + 1) * PRCC_PERIPHS_PER_CLUSTER];
 
 #define PRCC_SHOW(clk, base, bit) \
 	clk[(base * PRCC_PERIPHS_PER_CLUSTER) + bit]
+#define PRCC_PCLK_STORE(clk, base, bit)	\
+	prcc_pclk[(base * PRCC_PERIPHS_PER_CLUSTER) + bit] = clk
 
 struct clk *ux500_twocell_get(struct of_phandle_args *clkspec, void *data)
 {
@@ -237,135 +243,179 @@ void u8500_of_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 	/* PRCC P-clocks */
 	clk = clk_reg_prcc_pclk("p1_pclk0", "per1clk", clkrst1_base,
 				BIT(0), 0);
+	PRCC_PCLK_STORE(clk, 1, 0);
 
 	clk = clk_reg_prcc_pclk("p1_pclk1", "per1clk", clkrst1_base,
 				BIT(1), 0);
+	PRCC_PCLK_STORE(clk, 1, 1);
 
 	clk = clk_reg_prcc_pclk("p1_pclk2", "per1clk", clkrst1_base,
 				BIT(2), 0);
+	PRCC_PCLK_STORE(clk, 1, 2);
 
 	clk = clk_reg_prcc_pclk("p1_pclk3", "per1clk", clkrst1_base,
 				BIT(3), 0);
+	PRCC_PCLK_STORE(clk, 1, 3);
 
 	clk = clk_reg_prcc_pclk("p1_pclk4", "per1clk", clkrst1_base,
 				BIT(4), 0);
+	PRCC_PCLK_STORE(clk, 1, 4);
 
 	clk = clk_reg_prcc_pclk("p1_pclk5", "per1clk", clkrst1_base,
 				BIT(5), 0);
+	PRCC_PCLK_STORE(clk, 1, 5);
 
 	clk = clk_reg_prcc_pclk("p1_pclk6", "per1clk", clkrst1_base,
 				BIT(6), 0);
+	PRCC_PCLK_STORE(clk, 1, 6);
 
 	clk = clk_reg_prcc_pclk("p1_pclk7", "per1clk", clkrst1_base,
 				BIT(7), 0);
+	PRCC_PCLK_STORE(clk, 1, 7);
 
 	clk = clk_reg_prcc_pclk("p1_pclk8", "per1clk", clkrst1_base,
 				BIT(8), 0);
+	PRCC_PCLK_STORE(clk, 1, 8);
 
 	clk = clk_reg_prcc_pclk("p1_pclk9", "per1clk", clkrst1_base,
 				BIT(9), 0);
+	PRCC_PCLK_STORE(clk, 1, 9);
 
 	clk = clk_reg_prcc_pclk("p1_pclk10", "per1clk", clkrst1_base,
 				BIT(10), 0);
+	PRCC_PCLK_STORE(clk, 1, 10);
 
 	clk = clk_reg_prcc_pclk("p1_pclk11", "per1clk", clkrst1_base,
 				BIT(11), 0);
+	PRCC_PCLK_STORE(clk, 1, 11);
 
 	clk = clk_reg_prcc_pclk("p2_pclk0", "per2clk", clkrst2_base,
 				BIT(0), 0);
+	PRCC_PCLK_STORE(clk, 2, 0);
 
 	clk = clk_reg_prcc_pclk("p2_pclk1", "per2clk", clkrst2_base,
 				BIT(1), 0);
+	PRCC_PCLK_STORE(clk, 2, 1);
 
 	clk = clk_reg_prcc_pclk("p2_pclk2", "per2clk", clkrst2_base,
 				BIT(2), 0);
+	PRCC_PCLK_STORE(clk, 2, 2);
 
 	clk = clk_reg_prcc_pclk("p2_pclk3", "per2clk", clkrst2_base,
 				BIT(3), 0);
+	PRCC_PCLK_STORE(clk, 2, 3);
 
 	clk = clk_reg_prcc_pclk("p2_pclk4", "per2clk", clkrst2_base,
 				BIT(4), 0);
+	PRCC_PCLK_STORE(clk, 2, 4);
 
 	clk = clk_reg_prcc_pclk("p2_pclk5", "per2clk", clkrst2_base,
 				BIT(5), 0);
+	PRCC_PCLK_STORE(clk, 2, 5);
 
 	clk = clk_reg_prcc_pclk("p2_pclk6", "per2clk", clkrst2_base,
 				BIT(6), 0);
+	PRCC_PCLK_STORE(clk, 2, 6);
 
 	clk = clk_reg_prcc_pclk("p2_pclk7", "per2clk", clkrst2_base,
 				BIT(7), 0);
+	PRCC_PCLK_STORE(clk, 2, 7);
 
 	clk = clk_reg_prcc_pclk("p2_pclk8", "per2clk", clkrst2_base,
 				BIT(8), 0);
+	PRCC_PCLK_STORE(clk, 2, 8);
 
 	clk = clk_reg_prcc_pclk("p2_pclk9", "per2clk", clkrst2_base,
 				BIT(9), 0);
+	PRCC_PCLK_STORE(clk, 2, 9);
 
 	clk = clk_reg_prcc_pclk("p2_pclk10", "per2clk", clkrst2_base,
 				BIT(10), 0);
+	PRCC_PCLK_STORE(clk, 2, 10);
 
 	clk = clk_reg_prcc_pclk("p2_pclk11", "per2clk", clkrst2_base,
 				BIT(11), 0);
+	PRCC_PCLK_STORE(clk, 2, 1);
 
 	clk = clk_reg_prcc_pclk("p2_pclk12", "per2clk", clkrst2_base,
 				BIT(12), 0);
+	PRCC_PCLK_STORE(clk, 2, 12);
 
 	clk = clk_reg_prcc_pclk("p3_pclk0", "per3clk", clkrst3_base,
 				BIT(0), 0);
+	PRCC_PCLK_STORE(clk, 3, 0);
 
 	clk = clk_reg_prcc_pclk("p3_pclk1", "per3clk", clkrst3_base,
 				BIT(1), 0);
+	PRCC_PCLK_STORE(clk, 3, 1);
 
 	clk = clk_reg_prcc_pclk("p3_pclk2", "per3clk", clkrst3_base,
 				BIT(2), 0);
+	PRCC_PCLK_STORE(clk, 3, 2);
 
 	clk = clk_reg_prcc_pclk("p3_pclk3", "per3clk", clkrst3_base,
 				BIT(3), 0);
+	PRCC_PCLK_STORE(clk, 3, 3);
 
 	clk = clk_reg_prcc_pclk("p3_pclk4", "per3clk", clkrst3_base,
 				BIT(4), 0);
+	PRCC_PCLK_STORE(clk, 3, 4);
 
 	clk = clk_reg_prcc_pclk("p3_pclk5", "per3clk", clkrst3_base,
 				BIT(5), 0);
+	PRCC_PCLK_STORE(clk, 3, 5);
 
 	clk = clk_reg_prcc_pclk("p3_pclk6", "per3clk", clkrst3_base,
 				BIT(6), 0);
+	PRCC_PCLK_STORE(clk, 3, 6);
 
 	clk = clk_reg_prcc_pclk("p3_pclk7", "per3clk", clkrst3_base,
 				BIT(7), 0);
+	PRCC_PCLK_STORE(clk, 3, 7);
 
 	clk = clk_reg_prcc_pclk("p3_pclk8", "per3clk", clkrst3_base,
 				BIT(8), 0);
+	PRCC_PCLK_STORE(clk, 3, 8);
 
 	clk = clk_reg_prcc_pclk("p5_pclk0", "per5clk", clkrst5_base,
 				BIT(0), 0);
+	PRCC_PCLK_STORE(clk, 5, 0);
 
 	clk = clk_reg_prcc_pclk("p5_pclk1", "per5clk", clkrst5_base,
 				BIT(1), 0);
+	PRCC_PCLK_STORE(clk, 5, 1);
 
 	clk = clk_reg_prcc_pclk("p6_pclk0", "per6clk", clkrst6_base,
 				BIT(0), 0);
+	PRCC_PCLK_STORE(clk, 6, 0);
 
 	clk = clk_reg_prcc_pclk("p6_pclk1", "per6clk", clkrst6_base,
 				BIT(1), 0);
+	PRCC_PCLK_STORE(clk, 6, 1);
 
 	clk = clk_reg_prcc_pclk("p6_pclk2", "per6clk", clkrst6_base,
 				BIT(2), 0);
+	PRCC_PCLK_STORE(clk, 6, 2);
 
 	clk = clk_reg_prcc_pclk("p6_pclk3", "per6clk", clkrst6_base,
 				BIT(3), 0);
+	PRCC_PCLK_STORE(clk, 6, 3);
 
 	clk = clk_reg_prcc_pclk("p6_pclk4", "per6clk", clkrst6_base,
 				BIT(4), 0);
+	PRCC_PCLK_STORE(clk, 6, 4);
 
 	clk = clk_reg_prcc_pclk("p6_pclk5", "per6clk", clkrst6_base,
 				BIT(5), 0);
+	PRCC_PCLK_STORE(clk, 6, 5);
 
 	clk = clk_reg_prcc_pclk("p6_pclk6", "per6clk", clkrst6_base,
 				BIT(6), 0);
+	PRCC_PCLK_STORE(clk, 6, 6);
 
 	clk = clk_reg_prcc_pclk("p6_pclk7", "per6clk", clkrst6_base,
 				BIT(7), 0);
+	PRCC_PCLK_STORE(clk, 6, 7);
 
 	/* PRCC K-clocks
 	 *
@@ -464,5 +514,7 @@ void u8500_of_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 			clk_data.clk_num = ARRAY_SIZE(prcmu_clk);
 			of_clk_add_provider(child, of_clk_src_onecell_get, &clk_data);
 		}
+		if (!of_node_cmp(child->name, "prcc-periph-clock"))
+			of_clk_add_provider(child, ux500_twocell_get, prcc_pclk);
 	}
 }
-- 
1.8.1.2

