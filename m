Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab3HEUq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:46:56 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50773 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755349Ab3HEUnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:43:06 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv3 1/4] clk: sunxi: Rename the structure to prepare the addition of sun6i
Date: Mon,  5 Aug 2013 22:42:58 +0200
Message-Id: <1375735381-18214-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1375735381-18214-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1375735381-18214-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename all the generic-named structure to sun4i to avoid confusion when
we will introduce the sun6i (A31) clocks.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Reviewed-by: Emilio López <emilio@elopez.com.ar>
---
 drivers/clk/sunxi/clk-sunxi.c | 54 +++++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index 567963f..9a03ede 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -25,12 +25,12 @@
 static DEFINE_SPINLOCK(clk_lock);
 
 /**
- * sunxi_osc_clk_setup() - Setup function for gatable oscillator
+ * sun4i_osc_clk_setup() - Setup function for gatable oscillator
  */
 
 #define SUNXI_OSC24M_GATE	0
 
-static void __init sunxi_osc_clk_setup(struct device_node *node)
+static void __init sun4i_osc_clk_setup(struct device_node *node)
 {
 	struct clk *clk;
 	struct clk_fixed_rate *fixed;
@@ -69,18 +69,18 @@ static void __init sunxi_osc_clk_setup(struct device_node *node)
 		clk_register_clkdev(clk, clk_name, NULL);
 	}
 }
-CLK_OF_DECLARE(sunxi_osc, "allwinner,sun4i-osc-clk", sunxi_osc_clk_setup);
+CLK_OF_DECLARE(sun4i_osc, "allwinner,sun4i-osc-clk", sun4i_osc_clk_setup);
 
 
 
 /**
- * sunxi_get_pll1_factors() - calculates n, k, m, p factors for PLL1
+ * sun4i_get_pll1_factors() - calculates n, k, m, p factors for PLL1
  * PLL1 rate is calculated as follows
  * rate = (parent_rate * n * (k + 1) >> p) / (m + 1);
  * parent_rate is always 24Mhz
  */
 
-static void sunxi_get_pll1_factors(u32 *freq, u32 parent_rate,
+static void sun4i_get_pll1_factors(u32 *freq, u32 parent_rate,
 				   u8 *n, u8 *k, u8 *m, u8 *p)
 {
 	u8 div;
@@ -128,12 +128,12 @@ static void sunxi_get_pll1_factors(u32 *freq, u32 parent_rate,
 
 
 /**
- * sunxi_get_apb1_factors() - calculates m, p factors for APB1
+ * sun4i_get_apb1_factors() - calculates m, p factors for APB1
  * APB1 rate is calculated as follows
  * rate = (parent_rate >> p) / (m + 1);
  */
 
-static void sunxi_get_apb1_factors(u32 *freq, u32 parent_rate,
+static void sun4i_get_apb1_factors(u32 *freq, u32 parent_rate,
 				   u8 *n, u8 *k, u8 *m, u8 *p)
 {
 	u8 calcm, calcp;
@@ -179,7 +179,7 @@ struct factors_data {
 	void (*getter) (u32 *rate, u32 parent_rate, u8 *n, u8 *k, u8 *m, u8 *p);
 };
 
-static struct clk_factors_config pll1_config = {
+static struct clk_factors_config sun4i_pll1_config = {
 	.nshift = 8,
 	.nwidth = 5,
 	.kshift = 4,
@@ -190,21 +190,21 @@ static struct clk_factors_config pll1_config = {
 	.pwidth = 2,
 };
 
-static struct clk_factors_config apb1_config = {
+static struct clk_factors_config sun4i_apb1_config = {
 	.mshift = 0,
 	.mwidth = 5,
 	.pshift = 16,
 	.pwidth = 2,
 };
 
-static const __initconst struct factors_data pll1_data = {
-	.table = &pll1_config,
-	.getter = sunxi_get_pll1_factors,
+static const __initconst struct factors_data sun4i_pll1_data = {
+	.table = &sun4i_pll1_config,
+	.getter = sun4i_get_pll1_factors,
 };
 
-static const __initconst struct factors_data apb1_data = {
-	.table = &apb1_config,
-	.getter = sunxi_get_apb1_factors,
+static const __initconst struct factors_data sun4i_apb1_data = {
+	.table = &sun4i_apb1_config,
+	.getter = sun4i_get_apb1_factors,
 };
 
 static void __init sunxi_factors_clk_setup(struct device_node *node,
@@ -240,11 +240,11 @@ struct mux_data {
 	u8 shift;
 };
 
-static const __initconst struct mux_data cpu_mux_data = {
+static const __initconst struct mux_data sun4i_cpu_mux_data = {
 	.shift = 16,
 };
 
-static const __initconst struct mux_data apb1_mux_data = {
+static const __initconst struct mux_data sun4i_apb1_mux_data = {
 	.shift = 24,
 };
 
@@ -285,17 +285,17 @@ struct div_data {
 	u8 pow;
 };
 
-static const __initconst struct div_data axi_data = {
+static const __initconst struct div_data sun4i_axi_data = {
 	.shift = 0,
 	.pow = 0,
 };
 
-static const __initconst struct div_data ahb_data = {
+static const __initconst struct div_data sun4i_ahb_data = {
 	.shift = 4,
 	.pow = 1,
 };
 
-static const __initconst struct div_data apb0_data = {
+static const __initconst struct div_data sun4i_apb0_data = {
 	.shift = 8,
 	.pow = 1,
 };
@@ -425,23 +425,23 @@ static void __init sunxi_gates_clk_setup(struct device_node *node,
 
 /* Matches for factors clocks */
 static const __initconst struct of_device_id clk_factors_match[] = {
-	{.compatible = "allwinner,sun4i-pll1-clk", .data = &pll1_data,},
-	{.compatible = "allwinner,sun4i-apb1-clk", .data = &apb1_data,},
+	{.compatible = "allwinner,sun4i-pll1-clk", .data = &sun4i_pll1_data,},
+	{.compatible = "allwinner,sun4i-apb1-clk", .data = &sun4i_apb1_data,},
 	{}
 };
 
 /* Matches for divider clocks */
 static const __initconst struct of_device_id clk_div_match[] = {
-	{.compatible = "allwinner,sun4i-axi-clk", .data = &axi_data,},
-	{.compatible = "allwinner,sun4i-ahb-clk", .data = &ahb_data,},
-	{.compatible = "allwinner,sun4i-apb0-clk", .data = &apb0_data,},
+	{.compatible = "allwinner,sun4i-axi-clk", .data = &sun4i_axi_data,},
+	{.compatible = "allwinner,sun4i-ahb-clk", .data = &sun4i_ahb_data,},
+	{.compatible = "allwinner,sun4i-apb0-clk", .data = &sun4i_apb0_data,},
 	{}
 };
 
 /* Matches for mux clocks */
 static const __initconst struct of_device_id clk_mux_match[] = {
-	{.compatible = "allwinner,sun4i-cpu-clk", .data = &cpu_mux_data,},
-	{.compatible = "allwinner,sun4i-apb1-mux-clk", .data = &apb1_mux_data,},
+	{.compatible = "allwinner,sun4i-cpu-clk", .data = &sun4i_cpu_mux_data,},
+	{.compatible = "allwinner,sun4i-apb1-mux-clk", .data = &sun4i_apb1_mux_data,},
 	{}
 };
 
-- 
1.8.3.4

