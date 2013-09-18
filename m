Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3IRMS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:18:57 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:65294 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab3IRMPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:15:15 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 28/41] clk: ux500: Add Device Tree support for the RTC clock
Date: Wed, 18 Sep 2013 13:14:25 +0100
Message-Id: <1379506478-16625-29-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the RTC fixed frequency clock to be specified from
Device Tree via phandles to the "rtc32k-clock" node.

Acked-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/clk/ux500/u8500_of_clk.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/ux500/u8500_of_clk.c b/drivers/clk/ux500/u8500_of_clk.c
index 4fcafd0..fc647cf 100644
--- a/drivers/clk/ux500/u8500_of_clk.c
+++ b/drivers/clk/ux500/u8500_of_clk.c
@@ -60,7 +60,7 @@ void u8500_of_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 	struct device_node *np = NULL;
 	struct device_node *child = NULL;
 	const char *sgaclk_parent = NULL;
-	struct clk *clk;
+	struct clk *clk, *rtc_clk;
 
 	if (of_have_populated_dt())
 		np = of_find_matching_node(NULL, u8500_clk_of_match);
@@ -84,7 +84,7 @@ void u8500_of_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 
 	/* FIXME: Add sys, ulp and int clocks here. */
 
-	clk = clk_register_fixed_rate(NULL, "rtc32k", "NULL",
+	rtc_clk = clk_register_fixed_rate(NULL, "rtc32k", "NULL",
 				CLK_IS_ROOT|CLK_IGNORE_UNUSED,
 				32768);
 
@@ -548,5 +548,8 @@ void u8500_of_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 
 		if (!of_node_cmp(child->name, "prcc-kernel-clock"))
 			of_clk_add_provider(child, ux500_twocell_get, prcc_kclk);
+
+		if (!of_node_cmp(child->name, "rtc32k-clock"))
+			of_clk_add_provider(child, of_clk_src_simple_get, rtc_clk);
 	}
 }
-- 
1.8.1.2

