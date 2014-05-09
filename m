Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbaEINCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 09:02:09 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:49111 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584AbaEINCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 09:02:04 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: mturquette@linaro.org, t.figa@samsung.com, kgene.kim@samsung.com,
        galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org
Subject: [PATCH 2/4] clk: samsung: exynos5420: Add xclkout debug clock
Date: Fri,  9 May 2014 18:30:08 +0530
Message-Id: <1399640410-30957-3-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399640410-30957-1-git-send-email-tushar.behera@linaro.org>
References: <1399640410-30957-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new clock provider has been added to configure the XCLKOUT debug
clock. Added a minimal implemetation for Exynos5420 clock driver.

Right now, only one valid parent clock from XCLKOUT is defined
in existing clock driver. The driver will be updated later for other
for other parent clocks.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
CC: Tomasz Figa <t.figa@samsung.com>
---
 drivers/clk/samsung/clk-exynos5420.c   |   14 ++++++++++++++
 include/dt-bindings/clock/exynos5420.h |    5 ++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk-exynos5420.c
index 60b2681..a8f6527 100644
--- a/drivers/clk/samsung/clk-exynos5420.c
+++ b/drivers/clk/samsung/clk-exynos5420.c
@@ -296,6 +296,13 @@ PNAME(hdmi_p)	= { "dout_hdmi_pixel", "sclk_hdmiphy" };
 PNAME(maudio0_p)	= { "fin_pll", "maudio_clk", "sclk_dpll", "sclk_mpll",
 			  "sclk_spll", "sclk_ipll", "sclk_epll", "sclk_rpll" };
 
+PNAME(xclkout_p) = {
+	"dummy", "dummy", "dummy", "dummy",
+	"dummy", "dummy", "dummy", "dummy",
+	"dummy", "dummy", "dummy", "dummy",
+	"dummy", "dummy", "dummy", "dummy",
+	"fin_pll", "dummy", "dummy" };
+
 /* fixed rate clocks generated outside the soc */
 static struct samsung_fixed_rate_clock exynos5420_fixed_rate_ext_clks[] __initdata = {
 	FRATE(CLK_FIN_PLL, "fin_pll", NULL, CLK_IS_ROOT, 0),
@@ -308,6 +315,7 @@ static struct samsung_fixed_rate_clock exynos5420_fixed_rate_clks[] __initdata =
 	FRATE(0, "sclk_usbh20", NULL, CLK_IS_ROOT, 48000000),
 	FRATE(0, "mphy_refclk_ixtal24", NULL, CLK_IS_ROOT, 48000000),
 	FRATE(0, "sclk_usbh20_scan_clk", NULL, CLK_IS_ROOT, 480000000),
+	FRATE(0, "dummy", NULL, CLK_IS_ROOT, 0),
 };
 
 static struct samsung_fixed_factor_clock exynos5420_fixed_factor_clks[] __initdata = {
@@ -770,6 +778,10 @@ static struct samsung_pll_clock exynos5420_plls[nr_plls] __initdata = {
 		KPLL_CON0, NULL),
 };
 
+static struct samsung_out_clock exynos5420_clkout[] __initdata = {
+	CLKOUT(CLK_XCLKOUT, "xclkout", xclkout_p),
+};
+
 static struct of_device_id ext_clk_match[] __initdata = {
 	{ .compatible = "samsung,exynos5420-oscclk", .data = (void *)0, },
 	{ },
@@ -802,6 +814,8 @@ static void __init exynos5420_clk_init(struct device_node *np)
 			ARRAY_SIZE(exynos5420_div_clks));
 	samsung_clk_register_gate(exynos5420_gate_clks,
 			ARRAY_SIZE(exynos5420_gate_clks));
+	samsung_clk_register_clkout(np,
+			exynos5420_clkout, ARRAY_SIZE(exynos5420_clkout));
 
 	exynos5420_clk_sleep_init();
 }
diff --git a/include/dt-bindings/clock/exynos5420.h b/include/dt-bindings/clock/exynos5420.h
index 5eefd88..28eca32 100644
--- a/include/dt-bindings/clock/exynos5420.h
+++ b/include/dt-bindings/clock/exynos5420.h
@@ -182,7 +182,10 @@
 /* divider clocks */
 #define CLK_DOUT_PIXEL		768
 
+/* debug clocks */
+#define CLK_XCLKOUT		896
+
 /* must be greater than maximal clock id */
-#define CLK_NR_CLKS		769
+#define CLK_NR_CLKS		897
 
 #endif /* _DT_BINDINGS_CLOCK_EXYNOS_5420_H */
-- 
1.7.9.5

