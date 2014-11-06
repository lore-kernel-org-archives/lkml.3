Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaKFDjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 22:39:04 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:41540 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaKFDiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 22:38:12 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] clk: sunxi: Removed unused/incorrect sun6i-a31-apb2-clk driver
Date: Thu,  6 Nov 2014 11:38:03 +0800
Message-Id: <1415245083-20452-5-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415245083-20452-1-git-send-email-wens@csie.org>
References: <1415245083-20452-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver does not match the hardware, which is actually compatible
to sun4i-a10-apb1-clk. Since we've switch to the correct one, drop
this driver.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 Documentation/devicetree/bindings/clock/sunxi.txt | 1 -
 drivers/clk/sunxi/clk-sunxi.c                     | 7 -------
 2 files changed, 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Documentation/devicetree/bindings/clock/sunxi.txt
index 6ddcf6e..d199f91 100644
--- a/Documentation/devicetree/bindings/clock/sunxi.txt
+++ b/Documentation/devicetree/bindings/clock/sunxi.txt
@@ -52,7 +52,6 @@ Required properties:
 	"allwinner,sun7i-a20-apb1-gates-clk" - for the APB1 gates on A20
 	"allwinner,sun8i-a23-apb1-gates-clk" - for the APB1 gates on A23
 	"allwinner,sun9i-a80-apb1-gates-clk" - for the APB1 gates on A80
-	"allwinner,sun6i-a31-apb2-div-clk" - for the APB2 gates on A31
 	"allwinner,sun6i-a31-apb2-gates-clk" - for the APB2 gates on A31
 	"allwinner,sun8i-a23-apb2-gates-clk" - for the APB2 gates on A23
 	"allwinner,sun5i-a13-mbus-clk" - for the MBUS clock on A13
diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index 4133e27..46d98e3 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -632,12 +632,6 @@ static const struct div_data sun4i_apb0_data __initconst = {
 	.table	= sun4i_apb0_table,
 };
 
-static const struct div_data sun6i_a31_apb2_div_data __initconst = {
-	.shift	= 0,
-	.pow	= 0,
-	.width	= 4,
-};
-
 static void __init sunxi_divider_clk_setup(struct device_node *node,
 					   struct div_data *data)
 {
@@ -1093,7 +1087,6 @@ static const struct of_device_id clk_div_match[] __initconst = {
 	{.compatible = "allwinner,sun8i-a23-axi-clk", .data = &sun8i_a23_axi_data,},
 	{.compatible = "allwinner,sun4i-a10-ahb-clk", .data = &sun4i_ahb_data,},
 	{.compatible = "allwinner,sun4i-a10-apb0-clk", .data = &sun4i_apb0_data,},
-	{.compatible = "allwinner,sun6i-a31-apb2-div-clk", .data = &sun6i_a31_apb2_div_data,},
 	{}
 };
 
-- 
2.1.1

