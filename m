Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbaEWI1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 04:27:41 -0400
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:39568 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaEWI1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 04:27:38 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: [PATCH 09/22] clk: sunxi: Implement A31 PLL6 as a divs clock for 2x output
Date: Fri, 23 May 2014 15:51:12 +0800
Message-Id: <1400831485-28576-10-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1400831485-28576-1-git-send-email-wens@csie.org>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some clock modules on the A31 use PLL6x2 as one of their inputs.
This patch changes the PLL6 implementation for A31 to a divs clock,
i.e. clock with multiple outputs that have different dividers.

This behavior is consistent with previous SoC's by Allwinner.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 drivers/clk/sunxi/clk-sunxi.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index 6857c6e..339cabc 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -496,6 +496,7 @@ static const struct factors_data sun6i_a31_pll6_data __initconst = {
 	.enable = 31,
 	.table = &sun6i_a31_pll6_config,
 	.getter = sun6i_a31_get_pll6_factors,
+	.name = "pll6",
 };
 
 static const struct factors_data sun4i_apb1_data __initconst = {
@@ -969,6 +970,14 @@ static const struct divs_data pll6_divs_data __initconst = {
 	}
 };
 
+static const struct divs_data sun6i_a31_pll6_divs_data __initconst = {
+	.factors = &sun6i_a31_pll6_data,
+	.ndivs = 1,
+	.div = {
+		{ .fixed = 2 }, /* P, other */
+	}
+};
+
 /**
  * sunxi_divs_clk_setup() - Setup function for leaf divisors on clocks
  *
@@ -1108,7 +1117,6 @@ static const struct of_device_id clk_factors_match[] __initconst = {
 	{.compatible = "allwinner,sun4i-a10-pll1-clk", .data = &sun4i_pll1_data,},
 	{.compatible = "allwinner,sun6i-a31-pll1-clk", .data = &sun6i_a31_pll1_data,},
 	{.compatible = "allwinner,sun7i-a20-pll4-clk", .data = &sun7i_a20_pll4_data,},
-	{.compatible = "allwinner,sun6i-a31-pll6-clk", .data = &sun6i_a31_pll6_data,},
 	{.compatible = "allwinner,sun4i-a10-apb1-clk", .data = &sun4i_apb1_data,},
 	{.compatible = "allwinner,sun4i-a10-mod0-clk", .data = &sun4i_mod0_data,},
 	{.compatible = "allwinner,sun7i-a20-out-clk", .data = &sun7i_a20_out_data,},
@@ -1128,6 +1136,7 @@ static const struct of_device_id clk_div_match[] __initconst = {
 static const struct of_device_id clk_divs_match[] __initconst = {
 	{.compatible = "allwinner,sun4i-a10-pll5-clk", .data = &pll5_divs_data,},
 	{.compatible = "allwinner,sun4i-a10-pll6-clk", .data = &pll6_divs_data,},
+	{.compatible = "allwinner,sun6i-a31-pll6-clk", .data = &sun6i_a31_pll6_divs_data,},
 	{}
 };
 
-- 
2.0.0.rc2

