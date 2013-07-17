Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab3GQLAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 07:00:17 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50990 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab3GQLAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 07:00:14 -0400
From: Mark Brown <broonie@kernel.org>
To: Mike Turquette <mturquette@linaro.org>, Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Wed, 17 Jul 2013 11:59:45 +0100
Message-Id: <1374058786-16603-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.2
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 1/2] clk: samsung: Staticise non-exported symbols
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

This avoids polluting the global namespace and silences lots of sparse
warnings. The change pushes us over 80 columns a lot but I couldn't see
a tasteful place to break the lines as-is.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/clk/samsung/clk-exynos-audss.c |  2 +-
 drivers/clk/samsung/clk-exynos4.c      | 30 ++++++++++++++++--------------
 drivers/clk/samsung/clk-exynos5250.c   | 14 +++++++-------
 drivers/clk/samsung/clk-exynos5420.c   | 14 +++++++-------
 drivers/clk/samsung/clk-exynos5440.c   | 14 +++++++-------
 5 files changed, 38 insertions(+), 36 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos-audss.c b/drivers/clk/samsung/clk-exynos-audss.c
index 9b1bbd5..51b48da 100644
--- a/drivers/clk/samsung/clk-exynos-audss.c
+++ b/drivers/clk/samsung/clk-exynos-audss.c
@@ -62,7 +62,7 @@ static struct syscore_ops exynos_audss_clk_syscore_ops = {
 #endif /* CONFIG_PM_SLEEP */
 
 /* register exynos_audss clocks */
-void __init exynos_audss_clk_init(struct device_node *np)
+static void __init exynos_audss_clk_init(struct device_node *np)
 {
 	reg_base = of_iomap(np, 0);
 	if (!reg_base) {
diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index 1bdb882..0a91ff4 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -338,24 +338,24 @@ PNAME(mout_user_aclk200_p4x12) = {"fin_pll", "div_aclk200", };
 PNAME(mout_user_aclk266_gps_p4x12) = {"fin_pll", "div_aclk266_gps", };
 
 /* fixed rate clocks generated outside the soc */
-struct samsung_fixed_rate_clock exynos4_fixed_rate_ext_clks[] __initdata = {
+static struct samsung_fixed_rate_clock exynos4_fixed_rate_ext_clks[] __initdata = {
 	FRATE(xxti, "xxti", NULL, CLK_IS_ROOT, 0),
 	FRATE(xusbxti, "xusbxti", NULL, CLK_IS_ROOT, 0),
 };
 
 /* fixed rate clocks generated inside the soc */
-struct samsung_fixed_rate_clock exynos4_fixed_rate_clks[] __initdata = {
+static struct samsung_fixed_rate_clock exynos4_fixed_rate_clks[] __initdata = {
 	FRATE(none, "sclk_hdmi24m", NULL, CLK_IS_ROOT, 24000000),
 	FRATE(none, "sclk_hdmiphy", NULL, CLK_IS_ROOT, 27000000),
 	FRATE(none, "sclk_usbphy0", NULL, CLK_IS_ROOT, 48000000),
 };
 
-struct samsung_fixed_rate_clock exynos4210_fixed_rate_clks[] __initdata = {
+static struct samsung_fixed_rate_clock exynos4210_fixed_rate_clks[] __initdata = {
 	FRATE(none, "sclk_usbphy1", NULL, CLK_IS_ROOT, 48000000),
 };
 
 /* list of mux clocks supported in all exynos4 soc's */
-struct samsung_mux_clock exynos4_mux_clks[] __initdata = {
+static struct samsung_mux_clock exynos4_mux_clks[] __initdata = {
 	MUX_FA(mout_apll, "mout_apll", mout_apll_p, SRC_CPU, 0, 1,
 			CLK_SET_RATE_PARENT, 0, "mout_apll"),
 	MUX(none, "mout_hdmi", mout_hdmi_p, SRC_TV, 0, 1),
@@ -372,7 +372,7 @@ struct samsung_mux_clock exynos4_mux_clks[] __initdata = {
 };
 
 /* list of mux clocks supported in exynos4210 soc */
-struct samsung_mux_clock exynos4210_mux_clks[] __initdata = {
+static struct samsung_mux_clock exynos4210_mux_clks[] __initdata = {
 	MUX(none, "mout_aclk200", sclk_ampll_p4210, SRC_TOP0, 12, 1),
 	MUX(none, "mout_aclk100", sclk_ampll_p4210, SRC_TOP0, 16, 1),
 	MUX(none, "mout_aclk160", sclk_ampll_p4210, SRC_TOP0, 20, 1),
@@ -423,7 +423,7 @@ struct samsung_mux_clock exynos4210_mux_clks[] __initdata = {
 };
 
 /* list of mux clocks supported in exynos4x12 soc */
-struct samsung_mux_clock exynos4x12_mux_clks[] __initdata = {
+static struct samsung_mux_clock exynos4x12_mux_clks[] __initdata = {
 	MUX_A(mout_mpll_user_c, "mout_mpll_user_c", mout_mpll_user_p4x12,
 			SRC_CPU, 24, 1, "mout_mpll"),
 	MUX(none, "mout_aclk266_gps", aclk_p4412, SRC_TOP1, 4, 1),
@@ -491,7 +491,7 @@ struct samsung_mux_clock exynos4x12_mux_clks[] __initdata = {
 };
 
 /* list of divider clocks supported in all exynos4 soc's */
-struct samsung_div_clock exynos4_div_clks[] __initdata = {
+static struct samsung_div_clock exynos4_div_clks[] __initdata = {
 	DIV(none, "div_core", "mout_core", DIV_CPU0, 0, 3),
 	DIV(none, "div_core2", "div_core", DIV_CPU0, 28, 3),
 	DIV(none, "div_fimc0", "mout_fimc0", DIV_CAM, 0, 4),
@@ -554,7 +554,7 @@ struct samsung_div_clock exynos4_div_clks[] __initdata = {
 };
 
 /* list of divider clocks supported in exynos4210 soc */
-struct samsung_div_clock exynos4210_div_clks[] __initdata = {
+static struct samsung_div_clock exynos4210_div_clks[] __initdata = {
 	DIV(aclk200, "aclk200", "mout_aclk200", DIV_TOP, 0, 3),
 	DIV(sclk_fimg2d, "sclk_fimg2d", "mout_g2d", DIV_IMAGE, 0, 4),
 	DIV(none, "div_fimd1", "mout_fimd1", E4210_DIV_LCD1, 0, 4),
@@ -565,7 +565,7 @@ struct samsung_div_clock exynos4210_div_clks[] __initdata = {
 };
 
 /* list of divider clocks supported in exynos4x12 soc */
-struct samsung_div_clock exynos4x12_div_clks[] __initdata = {
+static struct samsung_div_clock exynos4x12_div_clks[] __initdata = {
 	DIV(none, "div_mdnie0", "mout_mdnie0", DIV_LCD0, 4, 4),
 	DIV(none, "div_mdnie_pwm0", "mout_mdnie_pwm0", DIV_LCD0, 8, 4),
 	DIV(none, "div_mdnie_pwm_pre0", "div_mdnie_pwm0", DIV_LCD0, 12, 4),
@@ -590,7 +590,7 @@ struct samsung_div_clock exynos4x12_div_clks[] __initdata = {
 };
 
 /* list of gate clocks supported in all exynos4 soc's */
-struct samsung_gate_clock exynos4_gate_clks[] __initdata = {
+static struct samsung_gate_clock exynos4_gate_clks[] __initdata = {
 	/*
 	 * After all Exynos4 based platforms are migrated to use device tree,
 	 * the device name and clock alias names specified below for some
@@ -782,7 +782,7 @@ struct samsung_gate_clock exynos4_gate_clks[] __initdata = {
 };
 
 /* list of gate clocks supported in exynos4210 soc */
-struct samsung_gate_clock exynos4210_gate_clks[] __initdata = {
+static struct samsung_gate_clock exynos4210_gate_clks[] __initdata = {
 	GATE(tvenc, "tvenc", "aclk160", GATE_IP_TV, 2, 0, 0),
 	GATE(g2d, "g2d", "aclk200", E4210_GATE_IP_IMAGE, 0, 0, 0),
 	GATE(rotator, "rotator", "aclk200", E4210_GATE_IP_IMAGE, 1, 0, 0),
@@ -817,7 +817,7 @@ struct samsung_gate_clock exynos4210_gate_clks[] __initdata = {
 };
 
 /* list of gate clocks supported in exynos4x12 soc */
-struct samsung_gate_clock exynos4x12_gate_clks[] __initdata = {
+static struct samsung_gate_clock exynos4x12_gate_clks[] __initdata = {
 	GATE(audss, "audss", "sclk_epll", E4X12_GATE_IP_MAUDIO, 0, 0, 0),
 	GATE(mdnie0, "mdnie0", "aclk160", GATE_IP_LCD0, 2, 0, 0),
 	GATE(rotator, "rotator", "aclk200", E4X12_GATE_IP_IMAGE, 1, 0, 0),
@@ -974,7 +974,7 @@ static void __init exynos4_clk_register_finpll(unsigned long xom)
  * xxti and xusbxti clocks. These clocks are then registered with the specified
  * clock speed.
  */
-void __init exynos4_clk_register_fixed_ext(unsigned long xxti_f,
+static void __init exynos4_clk_register_fixed_ext(unsigned long xxti_f,
 						unsigned long xusbxti_f)
 {
 	exynos4_fixed_rate_ext_clks[0].fixed_rate = xxti_f;
@@ -990,7 +990,9 @@ static __initdata struct of_device_id ext_clk_match[] = {
 };
 
 /* register exynos4 clocks */
-void __init exynos4_clk_init(struct device_node *np, enum exynos4_soc exynos4_soc, void __iomem *reg_base, unsigned long xom)
+static void __init exynos4_clk_init(struct device_node *np,
+				    enum exynos4_soc exynos4_soc,
+				    void __iomem *reg_base, unsigned long xom)
 {
 	struct clk *apll, *mpll, *epll, *vpll;
 
diff --git a/drivers/clk/samsung/clk-exynos5250.c b/drivers/clk/samsung/clk-exynos5250.c
index 6f767c5..6b2b66d 100644
--- a/drivers/clk/samsung/clk-exynos5250.c
+++ b/drivers/clk/samsung/clk-exynos5250.c
@@ -191,24 +191,24 @@ PNAME(mout_spdif_p)	= { "sclk_audio0", "sclk_audio1", "sclk_audio2",
 				"spdif_extclk" };
 
 /* fixed rate clocks generated outside the soc */
-struct samsung_fixed_rate_clock exynos5250_fixed_rate_ext_clks[] __initdata = {
+static struct samsung_fixed_rate_clock exynos5250_fixed_rate_ext_clks[] __initdata = {
 	FRATE(fin_pll, "fin_pll", NULL, CLK_IS_ROOT, 0),
 };
 
 /* fixed rate clocks generated inside the soc */
-struct samsung_fixed_rate_clock exynos5250_fixed_rate_clks[] __initdata = {
+static struct samsung_fixed_rate_clock exynos5250_fixed_rate_clks[] __initdata = {
 	FRATE(none, "sclk_hdmiphy", NULL, CLK_IS_ROOT, 24000000),
 	FRATE(none, "sclk_hdmi27m", NULL, CLK_IS_ROOT, 27000000),
 	FRATE(none, "sclk_dptxphy", NULL, CLK_IS_ROOT, 24000000),
 	FRATE(none, "sclk_uhostphy", NULL, CLK_IS_ROOT, 48000000),
 };
 
-struct samsung_fixed_factor_clock exynos5250_fixed_factor_clks[] __initdata = {
+static struct samsung_fixed_factor_clock exynos5250_fixed_factor_clks[] __initdata = {
 	FFACTOR(none, "fout_mplldiv2", "fout_mpll", 1, 2, 0),
 	FFACTOR(none, "fout_bplldiv2", "fout_bpll", 1, 2, 0),
 };
 
-struct samsung_mux_clock exynos5250_mux_clks[] __initdata = {
+static struct samsung_mux_clock exynos5250_mux_clks[] __initdata = {
 	MUX_A(none, "mout_apll", mout_apll_p, SRC_CPU, 0, 1, "mout_apll"),
 	MUX_A(none, "mout_cpu", mout_cpu_p, SRC_CPU, 16, 1, "mout_cpu"),
 	MUX(none, "mout_mpll_fout", mout_mpll_fout_p, PLL_DIV2_SEL, 4, 1),
@@ -254,7 +254,7 @@ struct samsung_mux_clock exynos5250_mux_clks[] __initdata = {
 	MUX(none, "mout_spi2", mout_group1_p, SRC_PERIC1, 24, 4),
 };
 
-struct samsung_div_clock exynos5250_div_clks[] __initdata = {
+static struct samsung_div_clock exynos5250_div_clks[] __initdata = {
 	DIV(none, "div_arm", "mout_cpu", DIV_CPU0, 0, 3),
 	DIV(none, "sclk_apll", "mout_apll", DIV_CPU0, 24, 3),
 	DIV(none, "aclk66_pre", "sclk_mpll_user", DIV_TOP1, 24, 3),
@@ -314,7 +314,7 @@ struct samsung_div_clock exynos5250_div_clks[] __initdata = {
 			DIV_PERIC2, 8, 8, CLK_SET_RATE_PARENT, 0),
 };
 
-struct samsung_gate_clock exynos5250_gate_clks[] __initdata = {
+static struct samsung_gate_clock exynos5250_gate_clks[] __initdata = {
 	GATE(gscl0, "gscl0", "none", GATE_IP_GSCL, 0, 0, 0),
 	GATE(gscl1, "gscl1", "none", GATE_IP_GSCL, 1, 0, 0),
 	GATE(gscl2, "gscl2", "aclk266", GATE_IP_GSCL, 2, 0, 0),
@@ -471,7 +471,7 @@ static __initdata struct of_device_id ext_clk_match[] = {
 };
 
 /* register exynox5250 clocks */
-void __init exynos5250_clk_init(struct device_node *np)
+static void __init exynos5250_clk_init(struct device_node *np)
 {
 	void __iomem *reg_base;
 	struct clk *apll, *mpll, *epll, *vpll, *bpll, *gpll, *cpll;
diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk-exynos5420.c
index 68a96cb..125728a 100644
--- a/drivers/clk/samsung/clk-exynos5420.c
+++ b/drivers/clk/samsung/clk-exynos5420.c
@@ -262,12 +262,12 @@ PNAME(maudio0_p)	= { "fin_pll", "maudio_clk", "sclk_dpll", "sclk_mpll",
 			  "sclk_spll", "sclk_ipll", "sclk_epll", "sclk_rpll" };
 
 /* fixed rate clocks generated outside the soc */
-struct samsung_fixed_rate_clock exynos5420_fixed_rate_ext_clks[] __initdata = {
+static struct samsung_fixed_rate_clock exynos5420_fixed_rate_ext_clks[] __initdata = {
 	FRATE(fin_pll, "fin_pll", NULL, CLK_IS_ROOT, 0),
 };
 
 /* fixed rate clocks generated inside the soc */
-struct samsung_fixed_rate_clock exynos5420_fixed_rate_clks[] __initdata = {
+static struct samsung_fixed_rate_clock exynos5420_fixed_rate_clks[] __initdata = {
 	FRATE(none, "sclk_hdmiphy", NULL, CLK_IS_ROOT, 24000000),
 	FRATE(none, "sclk_pwi", NULL, CLK_IS_ROOT, 24000000),
 	FRATE(none, "sclk_usbh20", NULL, CLK_IS_ROOT, 48000000),
@@ -275,11 +275,11 @@ struct samsung_fixed_rate_clock exynos5420_fixed_rate_clks[] __initdata = {
 	FRATE(none, "sclk_usbh20_scan_clk", NULL, CLK_IS_ROOT, 480000000),
 };
 
-struct samsung_fixed_factor_clock exynos5420_fixed_factor_clks[] __initdata = {
+static struct samsung_fixed_factor_clock exynos5420_fixed_factor_clks[] __initdata = {
 	FFACTOR(none, "sclk_hsic_12m", "fin_pll", 1, 2, 0),
 };
 
-struct samsung_mux_clock exynos5420_mux_clks[] __initdata = {
+static struct samsung_mux_clock exynos5420_mux_clks[] __initdata = {
 	MUX(none, "mout_mspll_kfc", mspll_cpu_p, SRC_TOP7, 8, 2),
 	MUX(none, "mout_mspll_cpu", mspll_cpu_p, SRC_TOP7, 12, 2),
 	MUX(none, "mout_apll", apll_p, SRC_CPU, 0, 1),
@@ -399,7 +399,7 @@ struct samsung_mux_clock exynos5420_mux_clks[] __initdata = {
 	MUX(none, "mout_spi2", group2_p, SRC_PERIC1, 28, 3),
 };
 
-struct samsung_div_clock exynos5420_div_clks[] __initdata = {
+static struct samsung_div_clock exynos5420_div_clks[] __initdata = {
 	DIV(none, "div_arm", "mout_cpu", DIV_CPU0, 0, 3),
 	DIV(none, "sclk_apll", "mout_apll", DIV_CPU0, 24, 3),
 	DIV(none, "armclk2", "div_arm", DIV_CPU0, 28, 3),
@@ -479,7 +479,7 @@ struct samsung_div_clock exynos5420_div_clks[] __initdata = {
 	DIV(none, "dout_pre_spi2", "dout_spi2", DIV_PERIC4, 24, 8),
 };
 
-struct samsung_gate_clock exynos5420_gate_clks[] __initdata = {
+static struct samsung_gate_clock exynos5420_gate_clks[] __initdata = {
 	/* TODO: Re-verify the CG bits for all the gate clocks */
 	GATE_A(mct, "pclk_st", "aclk66_psgen", GATE_BUS_PERIS1, 2, 0, 0, "mct"),
 
@@ -704,7 +704,7 @@ static __initdata struct of_device_id ext_clk_match[] = {
 };
 
 /* register exynos5420 clocks */
-void __init exynos5420_clk_init(struct device_node *np)
+static void __init exynos5420_clk_init(struct device_node *np)
 {
 	void __iomem *reg_base;
 	struct clk *apll, *bpll, *cpll, *dpll, *epll, *ipll, *kpll, *mpll;
diff --git a/drivers/clk/samsung/clk-exynos5440.c b/drivers/clk/samsung/clk-exynos5440.c
index 7d54341..6d043a2 100644
--- a/drivers/clk/samsung/clk-exynos5440.c
+++ b/drivers/clk/samsung/clk-exynos5440.c
@@ -41,12 +41,12 @@ PNAME(mout_armclk_p)	= { "cplla", "cpllb" };
 PNAME(mout_spi_p)	= { "div125", "div200" };
 
 /* fixed rate clocks generated outside the soc */
-struct samsung_fixed_rate_clock exynos5440_fixed_rate_ext_clks[] __initdata = {
+static struct samsung_fixed_rate_clock exynos5440_fixed_rate_ext_clks[] __initdata = {
 	FRATE(none, "xtal", NULL, CLK_IS_ROOT, 0),
 };
 
 /* fixed rate clocks */
-struct samsung_fixed_rate_clock exynos5440_fixed_rate_clks[] __initdata = {
+static struct samsung_fixed_rate_clock exynos5440_fixed_rate_clks[] __initdata = {
 	FRATE(none, "ppll", NULL, CLK_IS_ROOT, 1000000000),
 	FRATE(none, "usb_phy0", NULL, CLK_IS_ROOT, 60000000),
 	FRATE(none, "usb_phy1", NULL, CLK_IS_ROOT, 60000000),
@@ -55,26 +55,26 @@ struct samsung_fixed_rate_clock exynos5440_fixed_rate_clks[] __initdata = {
 };
 
 /* fixed factor clocks */
-struct samsung_fixed_factor_clock exynos5440_fixed_factor_clks[] __initdata = {
+static struct samsung_fixed_factor_clock exynos5440_fixed_factor_clks[] __initdata = {
 	FFACTOR(none, "div250", "ppll", 1, 4, 0),
 	FFACTOR(none, "div200", "ppll", 1, 5, 0),
 	FFACTOR(none, "div125", "div250", 1, 2, 0),
 };
 
 /* mux clocks */
-struct samsung_mux_clock exynos5440_mux_clks[] __initdata = {
+static struct samsung_mux_clock exynos5440_mux_clks[] __initdata = {
 	MUX(none, "mout_spi", mout_spi_p, MISC_DOUT1, 5, 1),
 	MUX_A(arm_clk, "arm_clk", mout_armclk_p,
 			CPU_CLK_STATUS, 0, 1, "armclk"),
 };
 
 /* divider clocks */
-struct samsung_div_clock exynos5440_div_clks[] __initdata = {
+static struct samsung_div_clock exynos5440_div_clks[] __initdata = {
 	DIV(spi_baud, "div_spi", "mout_spi", MISC_DOUT1, 3, 2),
 };
 
 /* gate clocks */
-struct samsung_gate_clock exynos5440_gate_clks[] __initdata = {
+static struct samsung_gate_clock exynos5440_gate_clks[] __initdata = {
 	GATE(pb0_250, "pb0_250", "div250", CLKEN_OV_VAL, 3, 0, 0),
 	GATE(pr0_250, "pr0_250", "div250", CLKEN_OV_VAL, 4, 0, 0),
 	GATE(pr1_250, "pr1_250", "div250", CLKEN_OV_VAL, 5, 0, 0),
@@ -103,7 +103,7 @@ static __initdata struct of_device_id ext_clk_match[] = {
 };
 
 /* register exynos5440 clocks */
-void __init exynos5440_clk_init(struct device_node *np)
+static void __init exynos5440_clk_init(struct device_node *np)
 {
 	void __iomem *reg_base;
 
-- 
1.8.3.2

