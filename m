Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab3G3Ooz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 10:44:55 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:42111 "EHLO
	mail.free-electrons.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751246Ab3G3Oow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 10:44:52 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 2/4] clk: sunxi: Allow to specify the divider width from the dividers data
Date: Tue, 30 Jul 2013 16:44:20 +0200
Message-Id: <1375195462-19566-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1375195462-19566-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1375195462-19566-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The divider width used to be hardcoded. Some A31 dividers are no longer
with the hardcoded width, so we need to make it specific to each divider
and set it in the dividers data.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clk/sunxi/clk-sunxi.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index 3c91888..6e9cbc9 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -277,26 +277,28 @@ static void __init sunxi_mux_clk_setup(struct device_node *node,
  * sunxi_divider_clk_setup() - Setup function for simple divider clocks
  */
 
-#define SUNXI_DIVISOR_WIDTH	2
-
 struct div_data {
-	u8 shift;
-	u8 pow;
+	u8	shift;
+	u8	pow;
+	u8	width;
 };
 
 static const __initconst struct div_data sun4i_axi_data = {
-	.shift = 0,
-	.pow = 0,
+	.shift	= 0,
+	.pow	= 0,
+	.width	= 2,
 };
 
 static const __initconst struct div_data sun4i_ahb_data = {
-	.shift = 4,
-	.pow = 1,
+	.shift	= 4,
+	.pow	= 1,
+	.width	= 2,
 };
 
 static const __initconst struct div_data sun4i_apb0_data = {
-	.shift = 8,
-	.pow = 1,
+	.shift	= 8,
+	.pow	= 1,
+	.width	= 2,
 };
 
 static void __init sunxi_divider_clk_setup(struct device_node *node,
@@ -312,7 +314,7 @@ static void __init sunxi_divider_clk_setup(struct device_node *node,
 	clk_parent = of_clk_get_parent_name(node, 0);
 
 	clk = clk_register_divider(NULL, clk_name, clk_parent, 0,
-				   reg, data->shift, SUNXI_DIVISOR_WIDTH,
+				   reg, data->shift, data->width,
 				   data->pow ? CLK_DIVIDER_POWER_OF_TWO : 0,
 				   &clk_lock);
 	if (clk) {
-- 
1.8.3.4

