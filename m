Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933692Ab3FFMXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:23:45 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:63727 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933364Ab3FFMSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:18:00 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 17/33] clk: ux500: Provide u8500_clk with skeleton Device Tree support
Date: Thu,  6 Jun 2013 13:17:05 +0100
Message-Id: <1370521041-32318-18-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functional components will be added on a per-clock basis.

Cc: Mike Turquette <mturquette@linaro.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/clk/ux500/u8500_clk.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/clk/ux500/u8500_clk.c b/drivers/clk/ux500/u8500_clk.c
index 0b4f35a..ef948ff 100644
--- a/drivers/clk/ux500/u8500_clk.c
+++ b/drivers/clk/ux500/u8500_clk.c
@@ -7,6 +7,7 @@
  * License terms: GNU General Public License (GPL) version 2
  */
 
+#include <linux/of.h>
 #include <linux/clk.h>
 #include <linux/clkdev.h>
 #include <linux/clk-provider.h>
@@ -14,10 +15,17 @@
 #include <linux/platform_data/clk-ux500.h>
 #include "clk.h"
 
+const static struct of_device_id u8500_clk_of_match[] = {
+       { .compatible = "stericsson,u8500-clks", },
+       { },
+};
+
 void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 		    u32 clkrst5_base, u32 clkrst6_base)
 {
 	struct prcmu_fw_version *fw_version;
+	struct device_node *np = NULL;
+	struct device_node *child = NULL;
 	const char *sgaclk_parent = NULL;
 	struct clk *clk;
 
@@ -522,4 +530,13 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 	clk = clk_reg_prcc_kclk("p3_rng_kclk", "rngclk",
 			clkrst6_base, BIT(0), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "rng");
+
+	if (of_have_populated_dt())
+		np = of_find_matching_node(NULL, u8500_clk_of_match);
+	if (!np)
+		return;
+
+	for_each_child_of_node(np, child) {
+		/* Place holder for supported nodes. */
+	}
 }
-- 
1.7.10.4

