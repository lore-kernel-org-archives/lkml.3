Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013Ab3ICNMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 09:12:12 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10623 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab3ICNMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 09:12:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 03 Sep 2013 06:09:23 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Joseph Lo <josephl@nvidia.com>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] clk: tegra: replace enum tegra114_clk by binding header
Date: Tue, 3 Sep 2013 16:11:49 +0300
Message-ID: <1378213915-10222-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the clock IDs are now specified in a header file, we can use those
definitions instead of maintaining an internal enum.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

---

Note: Depends on '[PATCH] ARM: tegra114: add missing clocks to binding'
---
 drivers/clk/tegra/clk-tegra114.c |  431 +++++++++++++++++--------------------
 1 files changed, 198 insertions(+), 233 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index cd94b0c..a26e5ef 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -23,6 +23,7 @@
 #include <linux/delay.h>
 #include <linux/export.h>
 #include <linux/clk/tegra.h>
+#include <dt-bindings/clock/tegra114-car.h>
 
 #include "clk.h"
 
@@ -864,43 +865,6 @@ static unsigned long tegra114_input_freq[] = {
 			periph_clk_enb_refcnt, _gate_flags , _clk_id,	\
 			mux_d_audio_clk_idx, 0)
 
-enum tegra114_clk {
-	rtc = 4, timer = 5, uarta = 6, sdmmc2 = 9, i2s1 = 11, i2c1 = 12,
-	ndflash = 13, sdmmc1 = 14, sdmmc4 = 15, pwm = 17, i2s2 = 18, epp = 19,
-	gr_2d = 21, usbd = 22, isp = 23, gr_3d = 24, disp2 = 26, disp1 = 27,
-	host1x = 28, vcp = 29, i2s0 = 30, apbdma = 34, kbc = 36, kfuse = 40,
-	sbc1 = 41, nor = 42, sbc2 = 44, sbc3 = 46, i2c5 = 47, dsia = 48,
-	mipi = 50, hdmi = 51, csi = 52, i2c2 = 54, uartc = 55, mipi_cal = 56,
-	emc, usb2, usb3, vde = 61, bsea = 62, bsev = 63, uartd = 65,
-	i2c3 = 67, sbc4 = 68, sdmmc3 = 69, owr = 71, csite = 73,
-	la = 76, trace = 77, soc_therm = 78, dtv = 79, ndspeed = 80,
-	i2cslow = 81, dsib = 82, tsec = 83, xusb_host = 89, msenc = 91,
-	csus = 92, mselect = 99, tsensor = 100, i2s3 = 101, i2s4 = 102,
-	i2c4 = 103, sbc5 = 104, sbc6 = 105, d_audio, apbif = 107, dam0, dam1,
-	dam2, hda2codec_2x = 111, audio0_2x = 113, audio1_2x, audio2_2x,
-	audio3_2x, audio4_2x, spdif_2x, actmon = 119, extern1 = 120,
-	extern2 = 121, extern3 = 122, hda = 125, se = 127, hda2hdmi = 128,
-	cilab = 144, cilcd = 145, cile = 146, dsialp = 147, dsiblp = 148,
-	dds = 150, dp2 = 152, amx = 153, adx = 154, xusb_ss = 156, uartb = 192,
-	vfir, spdif_in, spdif_out, vi, vi_sensor, fuse, fuse_burn, clk_32k,
-	clk_m, clk_m_div2, clk_m_div4, pll_ref, pll_c, pll_c_out1, pll_c2,
-	pll_c3, pll_m, pll_m_out1, pll_p, pll_p_out1, pll_p_out2, pll_p_out3,
-	pll_p_out4, pll_a, pll_a_out0, pll_d, pll_d_out0, pll_d2, pll_d2_out0,
-	pll_u, pll_u_480M, pll_u_60M, pll_u_48M, pll_u_12M, pll_x, pll_x_out0,
-	pll_re_vco, pll_re_out, pll_e_out0, spdif_in_sync, i2s0_sync,
-	i2s1_sync, i2s2_sync, i2s3_sync, i2s4_sync, vimclk_sync, audio0,
-	audio1, audio2, audio3, audio4, spdif, clk_out_1, clk_out_2, clk_out_3,
-	blink, xusb_host_src = 252, xusb_falcon_src, xusb_fs_src, xusb_ss_src,
-	xusb_dev_src, xusb_dev, xusb_hs_src, sclk, hclk, pclk, cclk_g, cclk_lp,
-	dfll_ref = 264, dfll_soc,
-
-	/* Mux clocks */
-
-	audio0_mux = 300, audio1_mux, audio2_mux, audio3_mux, audio4_mux,
-	spdif_mux, clk_out_1_mux, clk_out_2_mux, clk_out_3_mux, dsia_mux,
-	dsib_mux, clk_max,
-};
-
 struct utmi_clk_param {
 	/* Oscillator Frequency in KHz */
 	u32 osc_frequency;
@@ -1064,7 +1028,7 @@ static const struct clk_div_table pll_re_div_table[] = {
 	{ .val = 0, .div = 0 },
 };
 
-static struct clk *clks[clk_max];
+static struct clk *clks[TEGRA114_CLK_CLK_MAX];
 static struct clk_onecell_data clk_data;
 
 static unsigned long osc_freq;
@@ -1087,7 +1051,7 @@ static int __init tegra114_osc_clk_init(void __iomem *clk_base)
 	clk = clk_register_fixed_rate(NULL, "clk_m", NULL, CLK_IS_ROOT,
 				      osc_freq);
 	clk_register_clkdev(clk, "clk_m", NULL);
-	clks[clk_m] = clk;
+	clks[TEGRA114_CLK_CLK_M] = clk;
 
 	/* pll_ref */
 	val = (val >> OSC_CTRL_PLL_REF_DIV_SHIFT) & 3;
@@ -1095,7 +1059,7 @@ static int __init tegra114_osc_clk_init(void __iomem *clk_base)
 	clk = clk_register_fixed_factor(NULL, "pll_ref", "clk_m",
 					CLK_SET_RATE_PARENT, 1, pll_ref_div);
 	clk_register_clkdev(clk, "pll_ref", NULL);
-	clks[pll_ref] = clk;
+	clks[TEGRA114_CLK_PLL_REF] = clk;
 
 	pll_ref_freq = osc_freq / pll_ref_div;
 
@@ -1110,19 +1074,19 @@ static void __init tegra114_fixed_clk_init(void __iomem *clk_base)
 	clk = clk_register_fixed_rate(NULL, "clk_32k", NULL, CLK_IS_ROOT,
 				      32768);
 	clk_register_clkdev(clk, "clk_32k", NULL);
-	clks[clk_32k] = clk;
+	clks[TEGRA114_CLK_CLK_32K] = clk;
 
 	/* clk_m_div2 */
 	clk = clk_register_fixed_factor(NULL, "clk_m_div2", "clk_m",
 					CLK_SET_RATE_PARENT, 1, 2);
 	clk_register_clkdev(clk, "clk_m_div2", NULL);
-	clks[clk_m_div2] = clk;
+	clks[TEGRA114_CLK_CLK_M_DIV2] = clk;
 
 	/* clk_m_div4 */
 	clk = clk_register_fixed_factor(NULL, "clk_m_div4", "clk_m",
 					CLK_SET_RATE_PARENT, 1, 4);
 	clk_register_clkdev(clk, "clk_m_div4", NULL);
-	clks[clk_m_div4] = clk;
+	clks[TEGRA114_CLK_CLK_M_DIV4] = clk;
 
 }
 
@@ -1279,7 +1243,7 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 				pmc, 0, 0, &pll_c_params, TEGRA_PLL_USE_LOCK,
 				pll_c_freq_table, NULL);
 		clk_register_clkdev(clk, "pll_c", NULL);
-		clks[pll_c] = clk;
+		clks[TEGRA114_CLK_PLL_C] = clk;
 
 		/* PLLC_OUT1 */
 		clk = tegra_clk_register_divider("pll_c_out1_div", "pll_c",
@@ -1289,7 +1253,7 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 					clk_base + PLLC_OUT, 1, 0,
 					CLK_SET_RATE_PARENT, 0, NULL);
 		clk_register_clkdev(clk, "pll_c_out1", NULL);
-		clks[pll_c_out1] = clk;
+		clks[TEGRA114_CLK_PLL_C_OUT1] = clk;
 	}
 
 	/* PLLC2 */
@@ -1298,7 +1262,7 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 			     &pll_c2_params, TEGRA_PLL_USE_LOCK,
 			     pll_cx_freq_table, NULL);
 	clk_register_clkdev(clk, "pll_c2", NULL);
-	clks[pll_c2] = clk;
+	clks[TEGRA114_CLK_PLL_C2] = clk;
 
 	/* PLLC3 */
 	_clip_vco_min(&pll_c3_params);
@@ -1306,7 +1270,7 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 			     &pll_c3_params, TEGRA_PLL_USE_LOCK,
 			     pll_cx_freq_table, NULL);
 	clk_register_clkdev(clk, "pll_c3", NULL);
-	clks[pll_c3] = clk;
+	clks[TEGRA114_CLK_PLL_C3] = clk;
 
 	/* PLLP */
 	clk = tegra_clk_register_pll("pll_p", "pll_ref", clk_base, pmc, 0,
@@ -1314,7 +1278,7 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 			    TEGRA_PLL_FIXED | TEGRA_PLL_USE_LOCK,
 			    pll_p_freq_table, NULL);
 	clk_register_clkdev(clk, "pll_p", NULL);
-	clks[pll_p] = clk;
+	clks[TEGRA114_CLK_PLL_P] = clk;
 
 	/* PLLP_OUT1 */
 	clk = tegra_clk_register_divider("pll_p_out1_div", "pll_p",
@@ -1325,7 +1289,7 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
 				&pll_div_lock);
 	clk_register_clkdev(clk, "pll_p_out1", NULL);
-	clks[pll_p_out1] = clk;
+	clks[TEGRA114_CLK_PLL_P_OUT1] = clk;
 
 	/* PLLP_OUT2 */
 	clk = tegra_clk_register_divider("pll_p_out2_div", "pll_p",
@@ -1337,7 +1301,7 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
 				&pll_div_lock);
 	clk_register_clkdev(clk, "pll_p_out2", NULL);
-	clks[pll_p_out2] = clk;
+	clks[TEGRA114_CLK_PLL_P_OUT2] = clk;
 
 	/* PLLP_OUT3 */
 	clk = tegra_clk_register_divider("pll_p_out3_div", "pll_p",
@@ -1348,7 +1312,7 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
 				&pll_div_lock);
 	clk_register_clkdev(clk, "pll_p_out3", NULL);
-	clks[pll_p_out3] = clk;
+	clks[TEGRA114_CLK_PLL_P_OUT3] = clk;
 
 	/* PLLP_OUT4 */
 	clk = tegra_clk_register_divider("pll_p_out4_div", "pll_p",
@@ -1360,7 +1324,7 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
 				&pll_div_lock);
 	clk_register_clkdev(clk, "pll_p_out4", NULL);
-	clks[pll_p_out4] = clk;
+	clks[TEGRA114_CLK_PLL_P_OUT4] = clk;
 
 	/* PLLM */
 	_clip_vco_min(&pll_m_params);
@@ -1369,7 +1333,7 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 			     &pll_m_params, TEGRA_PLL_USE_LOCK,
 			     pll_m_freq_table, NULL);
 	clk_register_clkdev(clk, "pll_m", NULL);
-	clks[pll_m] = clk;
+	clks[TEGRA114_CLK_PLL_M] = clk;
 
 	/* PLLM_OUT1 */
 	clk = tegra_clk_register_divider("pll_m_out1_div", "pll_m",
@@ -1379,7 +1343,7 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 				clk_base + PLLM_OUT, 1, 0, CLK_IGNORE_UNUSED |
 				CLK_SET_RATE_PARENT, 0, NULL);
 	clk_register_clkdev(clk, "pll_m_out1", NULL);
-	clks[pll_m_out1] = clk;
+	clks[TEGRA114_CLK_PLL_M_OUT1] = clk;
 
 	/* PLLM_UD */
 	clk = clk_register_fixed_factor(NULL, "pll_m_ud", "pll_m",
@@ -1393,14 +1357,14 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 				pmc, CLK_IGNORE_UNUSED, 0, &pll_x_params,
 				TEGRA_PLL_USE_LOCK, pll_x_freq_table, NULL);
 		clk_register_clkdev(clk, "pll_x", NULL);
-		clks[pll_x] = clk;
+		clks[TEGRA114_CLK_PLL_X] = clk;
 	}
 
 	/* PLLX_OUT0 */
 	clk = clk_register_fixed_factor(NULL, "pll_x_out0", "pll_x",
 					CLK_SET_RATE_PARENT, 1, 2);
 	clk_register_clkdev(clk, "pll_x_out0", NULL);
-	clks[pll_x_out0] = clk;
+	clks[TEGRA114_CLK_PLL_X_OUT0] = clk;
 
 	/* PLLU */
 	val = readl(clk_base + pll_u_params.base_reg);
@@ -1412,7 +1376,7 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 			    TEGRA_PLL_HAS_CPCON | TEGRA_PLL_SET_LFCON |
 			    TEGRA_PLL_USE_LOCK, pll_u_freq_table, &pll_u_lock);
 	clk_register_clkdev(clk, "pll_u", NULL);
-	clks[pll_u] = clk;
+	clks[TEGRA114_CLK_PLL_U] = clk;
 
 	tegra114_utmi_param_configure(clk_base);
 
@@ -1421,25 +1385,25 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 				CLK_SET_RATE_PARENT, clk_base + PLLU_BASE,
 				22, 0, &pll_u_lock);
 	clk_register_clkdev(clk, "pll_u_480M", NULL);
-	clks[pll_u_480M] = clk;
+	clks[TEGRA114_CLK_PLL_U_480M] = clk;
 
 	/* PLLU_60M */
 	clk = clk_register_fixed_factor(NULL, "pll_u_60M", "pll_u",
 					CLK_SET_RATE_PARENT, 1, 8);
 	clk_register_clkdev(clk, "pll_u_60M", NULL);
-	clks[pll_u_60M] = clk;
+	clks[TEGRA114_CLK_PLL_U_60M] = clk;
 
 	/* PLLU_48M */
 	clk = clk_register_fixed_factor(NULL, "pll_u_48M", "pll_u",
 					CLK_SET_RATE_PARENT, 1, 10);
 	clk_register_clkdev(clk, "pll_u_48M", NULL);
-	clks[pll_u_48M] = clk;
+	clks[TEGRA114_CLK_PLL_U_48M] = clk;
 
 	/* PLLU_12M */
 	clk = clk_register_fixed_factor(NULL, "pll_u_12M", "pll_u",
 					CLK_SET_RATE_PARENT, 1, 40);
 	clk_register_clkdev(clk, "pll_u_12M", NULL);
-	clks[pll_u_12M] = clk;
+	clks[TEGRA114_CLK_PLL_U_12M] = clk;
 
 	/* PLLD */
 	clk = tegra_clk_register_pll("pll_d", "pll_ref", clk_base, pmc, 0,
@@ -1447,13 +1411,13 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 			    TEGRA_PLL_HAS_CPCON | TEGRA_PLL_SET_LFCON |
 			    TEGRA_PLL_USE_LOCK, pll_d_freq_table, &pll_d_lock);
 	clk_register_clkdev(clk, "pll_d", NULL);
-	clks[pll_d] = clk;
+	clks[TEGRA114_CLK_PLL_D] = clk;
 
 	/* PLLD_OUT0 */
 	clk = clk_register_fixed_factor(NULL, "pll_d_out0", "pll_d",
 					CLK_SET_RATE_PARENT, 1, 2);
 	clk_register_clkdev(clk, "pll_d_out0", NULL);
-	clks[pll_d_out0] = clk;
+	clks[TEGRA114_CLK_PLL_D_OUT0] = clk;
 
 	/* PLLD2 */
 	clk = tegra_clk_register_pll("pll_d2", "pll_ref", clk_base, pmc, 0,
@@ -1461,20 +1425,20 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 			    TEGRA_PLL_HAS_CPCON | TEGRA_PLL_SET_LFCON |
 			    TEGRA_PLL_USE_LOCK, pll_d_freq_table, &pll_d2_lock);
 	clk_register_clkdev(clk, "pll_d2", NULL);
-	clks[pll_d2] = clk;
+	clks[TEGRA114_CLK_PLL_D2] = clk;
 
 	/* PLLD2_OUT0 */
 	clk = clk_register_fixed_factor(NULL, "pll_d2_out0", "pll_d2",
 					CLK_SET_RATE_PARENT, 1, 2);
 	clk_register_clkdev(clk, "pll_d2_out0", NULL);
-	clks[pll_d2_out0] = clk;
+	clks[TEGRA114_CLK_PLL_D2_OUT0] = clk;
 
 	/* PLLA */
 	clk = tegra_clk_register_pll("pll_a", "pll_p_out1", clk_base, pmc, 0,
 			    0, &pll_a_params, TEGRA_PLL_HAS_CPCON |
 			    TEGRA_PLL_USE_LOCK, pll_a_freq_table, NULL);
 	clk_register_clkdev(clk, "pll_a", NULL);
-	clks[pll_a] = clk;
+	clks[TEGRA114_CLK_PLL_A] = clk;
 
 	/* PLLA_OUT0 */
 	clk = tegra_clk_register_divider("pll_a_out0_div", "pll_a",
@@ -1484,7 +1448,7 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 				clk_base + PLLA_OUT, 1, 0, CLK_IGNORE_UNUSED |
 				CLK_SET_RATE_PARENT, 0, NULL);
 	clk_register_clkdev(clk, "pll_a_out0", NULL);
-	clks[pll_a_out0] = clk;
+	clks[TEGRA114_CLK_PLL_A_OUT0] = clk;
 
 	/* PLLRE */
 	_clip_vco_min(&pll_re_vco_params);
@@ -1492,20 +1456,20 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 			     0, 0, &pll_re_vco_params, TEGRA_PLL_USE_LOCK,
 			     NULL, &pll_re_lock, pll_ref_freq);
 	clk_register_clkdev(clk, "pll_re_vco", NULL);
-	clks[pll_re_vco] = clk;
+	clks[TEGRA114_CLK_PLL_RE_VCO] = clk;
 
 	clk = clk_register_divider_table(NULL, "pll_re_out", "pll_re_vco", 0,
 					 clk_base + PLLRE_BASE, 16, 4, 0,
 					 pll_re_div_table, &pll_re_lock);
 	clk_register_clkdev(clk, "pll_re_out", NULL);
-	clks[pll_re_out] = clk;
+	clks[TEGRA114_CLK_PLL_RE_OUT] = clk;
 
 	/* PLLE */
 	clk = tegra_clk_register_plle_tegra114("pll_e_out0", "pll_re_vco",
 				      clk_base, 0, 100000000, &pll_e_params,
 				      pll_e_freq_table, NULL);
 	clk_register_clkdev(clk, "pll_e_out0", NULL);
-	clks[pll_e_out0] = clk;
+	clks[TEGRA114_CLK_PLL_E_OUT0] = clk;
 }
 
 static const char *mux_audio_sync_clk[] = { "spdif_in_sync", "i2s0_sync",
@@ -1532,109 +1496,109 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 	clk = tegra_clk_register_sync_source("spdif_in_sync", 24000000,
 					     24000000);
 	clk_register_clkdev(clk, "spdif_in_sync", NULL);
-	clks[spdif_in_sync] = clk;
+	clks[TEGRA114_CLK_SPDIF_IN_SYNC] = clk;
 
 	/* i2s0_sync */
 	clk = tegra_clk_register_sync_source("i2s0_sync", 24000000, 24000000);
 	clk_register_clkdev(clk, "i2s0_sync", NULL);
-	clks[i2s0_sync] = clk;
+	clks[TEGRA114_CLK_I2S0_SYNC] = clk;
 
 	/* i2s1_sync */
 	clk = tegra_clk_register_sync_source("i2s1_sync", 24000000, 24000000);
 	clk_register_clkdev(clk, "i2s1_sync", NULL);
-	clks[i2s1_sync] = clk;
+	clks[TEGRA114_CLK_I2S1_SYNC] = clk;
 
 	/* i2s2_sync */
 	clk = tegra_clk_register_sync_source("i2s2_sync", 24000000, 24000000);
 	clk_register_clkdev(clk, "i2s2_sync", NULL);
-	clks[i2s2_sync] = clk;
+	clks[TEGRA114_CLK_I2S2_SYNC] = clk;
 
 	/* i2s3_sync */
 	clk = tegra_clk_register_sync_source("i2s3_sync", 24000000, 24000000);
 	clk_register_clkdev(clk, "i2s3_sync", NULL);
-	clks[i2s3_sync] = clk;
+	clks[TEGRA114_CLK_I2S3_SYNC] = clk;
 
 	/* i2s4_sync */
 	clk = tegra_clk_register_sync_source("i2s4_sync", 24000000, 24000000);
 	clk_register_clkdev(clk, "i2s4_sync", NULL);
-	clks[i2s4_sync] = clk;
+	clks[TEGRA114_CLK_I2S4_SYNC] = clk;
 
 	/* vimclk_sync */
 	clk = tegra_clk_register_sync_source("vimclk_sync", 24000000, 24000000);
 	clk_register_clkdev(clk, "vimclk_sync", NULL);
-	clks[vimclk_sync] = clk;
+	clks[TEGRA114_CLK_VIMCLK_SYNC] = clk;
 
 	/* audio0 */
 	clk = clk_register_mux(NULL, "audio0_mux", mux_audio_sync_clk,
 			       ARRAY_SIZE(mux_audio_sync_clk), 0,
 			       clk_base + AUDIO_SYNC_CLK_I2S0, 0, 3, 0,
 			       NULL);
-	clks[audio0_mux] = clk;
+	clks[TEGRA114_CLK_AUDIO0_MUX] = clk;
 	clk = clk_register_gate(NULL, "audio0", "audio0_mux", 0,
 				clk_base + AUDIO_SYNC_CLK_I2S0, 4,
 				CLK_GATE_SET_TO_DISABLE, NULL);
 	clk_register_clkdev(clk, "audio0", NULL);
-	clks[audio0] = clk;
+	clks[TEGRA114_CLK_AUDIO0] = clk;
 
 	/* audio1 */
 	clk = clk_register_mux(NULL, "audio1_mux", mux_audio_sync_clk,
 			       ARRAY_SIZE(mux_audio_sync_clk), 0,
 			       clk_base + AUDIO_SYNC_CLK_I2S1, 0, 3, 0,
 			       NULL);
-	clks[audio1_mux] = clk;
+	clks[TEGRA114_CLK_AUDIO1_MUX] = clk;
 	clk = clk_register_gate(NULL, "audio1", "audio1_mux", 0,
 				clk_base + AUDIO_SYNC_CLK_I2S1, 4,
 				CLK_GATE_SET_TO_DISABLE, NULL);
 	clk_register_clkdev(clk, "audio1", NULL);
-	clks[audio1] = clk;
+	clks[TEGRA114_CLK_AUDIO1] = clk;
 
 	/* audio2 */
 	clk = clk_register_mux(NULL, "audio2_mux", mux_audio_sync_clk,
 			       ARRAY_SIZE(mux_audio_sync_clk), 0,
 			       clk_base + AUDIO_SYNC_CLK_I2S2, 0, 3, 0,
 			       NULL);
-	clks[audio2_mux] = clk;
+	clks[TEGRA114_CLK_AUDIO2_MUX] = clk;
 	clk = clk_register_gate(NULL, "audio2", "audio2_mux", 0,
 				clk_base + AUDIO_SYNC_CLK_I2S2, 4,
 				CLK_GATE_SET_TO_DISABLE, NULL);
 	clk_register_clkdev(clk, "audio2", NULL);
-	clks[audio2] = clk;
+	clks[TEGRA114_CLK_AUDIO2] = clk;
 
 	/* audio3 */
 	clk = clk_register_mux(NULL, "audio3_mux", mux_audio_sync_clk,
 			       ARRAY_SIZE(mux_audio_sync_clk), 0,
 			       clk_base + AUDIO_SYNC_CLK_I2S3, 0, 3, 0,
 			       NULL);
-	clks[audio3_mux] = clk;
+	clks[TEGRA114_CLK_AUDIO3_MUX] = clk;
 	clk = clk_register_gate(NULL, "audio3", "audio3_mux", 0,
 				clk_base + AUDIO_SYNC_CLK_I2S3, 4,
 				CLK_GATE_SET_TO_DISABLE, NULL);
 	clk_register_clkdev(clk, "audio3", NULL);
-	clks[audio3] = clk;
+	clks[TEGRA114_CLK_AUDIO3] = clk;
 
 	/* audio4 */
 	clk = clk_register_mux(NULL, "audio4_mux", mux_audio_sync_clk,
 			       ARRAY_SIZE(mux_audio_sync_clk), 0,
 			       clk_base + AUDIO_SYNC_CLK_I2S4, 0, 3, 0,
 			       NULL);
-	clks[audio4_mux] = clk;
+	clks[TEGRA114_CLK_AUDIO4_MUX] = clk;
 	clk = clk_register_gate(NULL, "audio4", "audio4_mux", 0,
 				clk_base + AUDIO_SYNC_CLK_I2S4, 4,
 				CLK_GATE_SET_TO_DISABLE, NULL);
 	clk_register_clkdev(clk, "audio4", NULL);
-	clks[audio4] = clk;
+	clks[TEGRA114_CLK_AUDIO4] = clk;
 
 	/* spdif */
 	clk = clk_register_mux(NULL, "spdif_mux", mux_audio_sync_clk,
 			       ARRAY_SIZE(mux_audio_sync_clk), 0,
 			       clk_base + AUDIO_SYNC_CLK_SPDIF, 0, 3, 0,
 			       NULL);
-	clks[spdif_mux] = clk;
+	clks[TEGRA114_CLK_SPDIF_MUX] = clk;
 	clk = clk_register_gate(NULL, "spdif", "spdif_mux", 0,
 				clk_base + AUDIO_SYNC_CLK_SPDIF, 4,
 				CLK_GATE_SET_TO_DISABLE, NULL);
 	clk_register_clkdev(clk, "spdif", NULL);
-	clks[spdif] = clk;
+	clks[TEGRA114_CLK_SPDIF] = clk;
 
 	/* audio0_2x */
 	clk = clk_register_fixed_factor(NULL, "audio0_doubler", "audio0",
@@ -1647,7 +1611,7 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 				  CLK_SET_RATE_PARENT, 113, &periph_v_regs,
 				  periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "audio0_2x", NULL);
-	clks[audio0_2x] = clk;
+	clks[TEGRA114_CLK_AUDIO0_2X] = clk;
 
 	/* audio1_2x */
 	clk = clk_register_fixed_factor(NULL, "audio1_doubler", "audio1",
@@ -1660,7 +1624,7 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 				  CLK_SET_RATE_PARENT, 114, &periph_v_regs,
 				  periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "audio1_2x", NULL);
-	clks[audio1_2x] = clk;
+	clks[TEGRA114_CLK_AUDIO1_2X] = clk;
 
 	/* audio2_2x */
 	clk = clk_register_fixed_factor(NULL, "audio2_doubler", "audio2",
@@ -1673,7 +1637,7 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 				  CLK_SET_RATE_PARENT, 115, &periph_v_regs,
 				  periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "audio2_2x", NULL);
-	clks[audio2_2x] = clk;
+	clks[TEGRA114_CLK_AUDIO2_2X] = clk;
 
 	/* audio3_2x */
 	clk = clk_register_fixed_factor(NULL, "audio3_doubler", "audio3",
@@ -1686,7 +1650,7 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 				  CLK_SET_RATE_PARENT, 116, &periph_v_regs,
 				  periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "audio3_2x", NULL);
-	clks[audio3_2x] = clk;
+	clks[TEGRA114_CLK_AUDIO3_2X] = clk;
 
 	/* audio4_2x */
 	clk = clk_register_fixed_factor(NULL, "audio4_doubler", "audio4",
@@ -1699,7 +1663,7 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 				  CLK_SET_RATE_PARENT, 117, &periph_v_regs,
 				  periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "audio4_2x", NULL);
-	clks[audio4_2x] = clk;
+	clks[TEGRA114_CLK_AUDIO4_2X] = clk;
 
 	/* spdif_2x */
 	clk = clk_register_fixed_factor(NULL, "spdif_doubler", "spdif",
@@ -1712,7 +1676,7 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 				  CLK_SET_RATE_PARENT, 118,
 				  &periph_v_regs, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "spdif_2x", NULL);
-	clks[spdif_2x] = clk;
+	clks[TEGRA114_CLK_SPDIF_2X] = clk;
 }
 
 static void __init tegra114_pmc_clk_init(void __iomem *pmc_base)
@@ -1724,36 +1688,36 @@ static void __init tegra114_pmc_clk_init(void __iomem *pmc_base)
 			       ARRAY_SIZE(clk_out1_parents), 0,
 			       pmc_base + PMC_CLK_OUT_CNTRL, 6, 3, 0,
 			       &clk_out_lock);
-	clks[clk_out_1_mux] = clk;
+	clks[TEGRA114_CLK_CLK_OUT_1_MUX] = clk;
 	clk = clk_register_gate(NULL, "clk_out_1", "clk_out_1_mux", 0,
 				pmc_base + PMC_CLK_OUT_CNTRL, 2, 0,
 				&clk_out_lock);
 	clk_register_clkdev(clk, "extern1", "clk_out_1");
-	clks[clk_out_1] = clk;
+	clks[TEGRA114_CLK_CLK_OUT_1] = clk;
 
 	/* clk_out_2 */
 	clk = clk_register_mux(NULL, "clk_out_2_mux", clk_out2_parents,
 			       ARRAY_SIZE(clk_out2_parents), 0,
 			       pmc_base + PMC_CLK_OUT_CNTRL, 14, 3, 0,
 			       &clk_out_lock);
-	clks[clk_out_2_mux] = clk;
+	clks[TEGRA114_CLK_CLK_OUT_2_MUX] = clk;
 	clk = clk_register_gate(NULL, "clk_out_2", "clk_out_2_mux", 0,
 				pmc_base + PMC_CLK_OUT_CNTRL, 10, 0,
 				&clk_out_lock);
 	clk_register_clkdev(clk, "extern2", "clk_out_2");
-	clks[clk_out_2] = clk;
+	clks[TEGRA114_CLK_CLK_OUT_2] = clk;
 
 	/* clk_out_3 */
 	clk = clk_register_mux(NULL, "clk_out_3_mux", clk_out3_parents,
 			       ARRAY_SIZE(clk_out3_parents), 0,
 			       pmc_base + PMC_CLK_OUT_CNTRL, 22, 3, 0,
 			       &clk_out_lock);
-	clks[clk_out_3_mux] = clk;
+	clks[TEGRA114_CLK_CLK_OUT_3_MUX] = clk;
 	clk = clk_register_gate(NULL, "clk_out_3", "clk_out_3_mux", 0,
 				pmc_base + PMC_CLK_OUT_CNTRL, 18, 0,
 				&clk_out_lock);
 	clk_register_clkdev(clk, "extern3", "clk_out_3");
-	clks[clk_out_3] = clk;
+	clks[TEGRA114_CLK_CLK_OUT_3] = clk;
 
 	/* blink */
 	/* clear the blink timer register to directly output clk_32k */
@@ -1765,7 +1729,7 @@ static void __init tegra114_pmc_clk_init(void __iomem *pmc_base)
 				pmc_base + PMC_CTRL,
 				PMC_CTRL_BLINK_ENB, 0, NULL);
 	clk_register_clkdev(clk, "blink", NULL);
-	clks[blink] = clk;
+	clks[TEGRA114_CLK_BLINK] = clk;
 
 }
 
@@ -1792,7 +1756,7 @@ static void __init tegra114_super_clk_init(void __iomem *clk_base)
 					clk_base + CCLKG_BURST_POLICY,
 					0, 4, 0, 0, NULL);
 	clk_register_clkdev(clk, "cclk_g", NULL);
-	clks[cclk_g] = clk;
+	clks[TEGRA114_CLK_CCLK_G] = clk;
 
 	/* CCLKLP */
 	clk = tegra_clk_register_super_mux("cclk_lp", cclk_lp_parents,
@@ -1801,7 +1765,7 @@ static void __init tegra114_super_clk_init(void __iomem *clk_base)
 					clk_base + CCLKLP_BURST_POLICY,
 					0, 4, 8, 9, NULL);
 	clk_register_clkdev(clk, "cclk_lp", NULL);
-	clks[cclk_lp] = clk;
+	clks[TEGRA114_CLK_CCLK_LP] = clk;
 
 	/* SCLK */
 	clk = tegra_clk_register_super_mux("sclk", sclk_parents,
@@ -1810,7 +1774,7 @@ static void __init tegra114_super_clk_init(void __iomem *clk_base)
 					clk_base + SCLK_BURST_POLICY,
 					0, 4, 0, 0, NULL);
 	clk_register_clkdev(clk, "sclk", NULL);
-	clks[sclk] = clk;
+	clks[TEGRA114_CLK_SCLK] = clk;
 
 	/* HCLK */
 	clk = clk_register_divider(NULL, "hclk_div", "sclk", 0,
@@ -1820,7 +1784,7 @@ static void __init tegra114_super_clk_init(void __iomem *clk_base)
 				CLK_IGNORE_UNUSED, clk_base + SYSTEM_CLK_RATE,
 				7, CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
 	clk_register_clkdev(clk, "hclk", NULL);
-	clks[hclk] = clk;
+	clks[TEGRA114_CLK_HCLK] = clk;
 
 	/* PCLK */
 	clk = clk_register_divider(NULL, "pclk_div", "hclk", 0,
@@ -1830,90 +1794,90 @@ static void __init tegra114_super_clk_init(void __iomem *clk_base)
 				CLK_IGNORE_UNUSED, clk_base + SYSTEM_CLK_RATE,
 				3, CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
 	clk_register_clkdev(clk, "pclk", NULL);
-	clks[pclk] = clk;
+	clks[TEGRA114_CLK_PCLK] = clk;
 }
 
 static struct tegra_periph_init_data tegra_periph_clk_list[] = {
-	TEGRA_INIT_DATA_MUX("i2s0", NULL, "tegra30-i2s.0", mux_pllaout0_audio0_2x_pllp_clkm, CLK_SOURCE_I2S0, 30, &periph_l_regs, TEGRA_PERIPH_ON_APB, i2s0),
-	TEGRA_INIT_DATA_MUX("i2s1", NULL, "tegra30-i2s.1", mux_pllaout0_audio1_2x_pllp_clkm, CLK_SOURCE_I2S1, 11, &periph_l_regs, TEGRA_PERIPH_ON_APB, i2s1),
-	TEGRA_INIT_DATA_MUX("i2s2", NULL, "tegra30-i2s.2", mux_pllaout0_audio2_2x_pllp_clkm, CLK_SOURCE_I2S2, 18, &periph_l_regs, TEGRA_PERIPH_ON_APB, i2s2),
-	TEGRA_INIT_DATA_MUX("i2s3", NULL, "tegra30-i2s.3", mux_pllaout0_audio3_2x_pllp_clkm, CLK_SOURCE_I2S3, 101, &periph_v_regs, TEGRA_PERIPH_ON_APB, i2s3),
-	TEGRA_INIT_DATA_MUX("i2s4", NULL, "tegra30-i2s.4", mux_pllaout0_audio4_2x_pllp_clkm, CLK_SOURCE_I2S4, 102, &periph_v_regs, TEGRA_PERIPH_ON_APB, i2s4),
-	TEGRA_INIT_DATA_MUX("spdif_out", "spdif_out", "tegra30-spdif", mux_pllaout0_audio_2x_pllp_clkm, CLK_SOURCE_SPDIF_OUT, 10, &periph_l_regs, TEGRA_PERIPH_ON_APB, spdif_out),
-	TEGRA_INIT_DATA_MUX("spdif_in", "spdif_in", "tegra30-spdif", mux_pllp_pllc_pllm, CLK_SOURCE_SPDIF_IN, 10, &periph_l_regs, TEGRA_PERIPH_ON_APB, spdif_in),
-	TEGRA_INIT_DATA_MUX("pwm", NULL, "pwm", mux_pllp_pllc_clk32_clkm, CLK_SOURCE_PWM, 17, &periph_l_regs, TEGRA_PERIPH_ON_APB, pwm),
-	TEGRA_INIT_DATA_MUX("adx", NULL, "adx", mux_plla_pllc_pllp_clkm, CLK_SOURCE_ADX, 154, &periph_w_regs, TEGRA_PERIPH_ON_APB, adx),
-	TEGRA_INIT_DATA_MUX("amx", NULL, "amx", mux_plla_pllc_pllp_clkm, CLK_SOURCE_AMX, 153, &periph_w_regs, TEGRA_PERIPH_ON_APB, amx),
-	TEGRA_INIT_DATA_MUX("hda", "hda", "tegra30-hda", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_HDA, 125, &periph_v_regs, TEGRA_PERIPH_ON_APB, hda),
-	TEGRA_INIT_DATA_MUX("hda2codec_2x", "hda2codec", "tegra30-hda", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_HDA2CODEC_2X, 111, &periph_v_regs, TEGRA_PERIPH_ON_APB, hda2codec_2x),
-	TEGRA_INIT_DATA_MUX("sbc1", NULL, "tegra11-spi.0", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC1, 41, &periph_h_regs, TEGRA_PERIPH_ON_APB, sbc1),
-	TEGRA_INIT_DATA_MUX("sbc2", NULL, "tegra11-spi.1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC2, 44, &periph_h_regs, TEGRA_PERIPH_ON_APB, sbc2),
-	TEGRA_INIT_DATA_MUX("sbc3", NULL, "tegra11-spi.2", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC3, 46, &periph_h_regs, TEGRA_PERIPH_ON_APB, sbc3),
-	TEGRA_INIT_DATA_MUX("sbc4", NULL, "tegra11-spi.3", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC4, 68, &periph_u_regs, TEGRA_PERIPH_ON_APB, sbc4),
-	TEGRA_INIT_DATA_MUX("sbc5", NULL, "tegra11-spi.4", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC5, 104, &periph_v_regs, TEGRA_PERIPH_ON_APB, sbc5),
-	TEGRA_INIT_DATA_MUX("sbc6", NULL, "tegra11-spi.5", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC6, 105, &periph_v_regs, TEGRA_PERIPH_ON_APB, sbc6),
-	TEGRA_INIT_DATA_MUX8("ndflash", NULL, "tegra_nand", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_NDFLASH, 13, &periph_u_regs, TEGRA_PERIPH_ON_APB, ndspeed),
-	TEGRA_INIT_DATA_MUX8("ndspeed", NULL, "tegra_nand_speed", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_NDSPEED, 80, &periph_u_regs, TEGRA_PERIPH_ON_APB, ndspeed),
-	TEGRA_INIT_DATA_MUX("vfir", NULL, "vfir", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_VFIR, 7, &periph_l_regs, TEGRA_PERIPH_ON_APB, vfir),
-	TEGRA_INIT_DATA_MUX("sdmmc1", NULL, "sdhci-tegra.0", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC1, 14, &periph_l_regs, 0, sdmmc1),
-	TEGRA_INIT_DATA_MUX("sdmmc2", NULL, "sdhci-tegra.1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC2, 9, &periph_l_regs, 0, sdmmc2),
-	TEGRA_INIT_DATA_MUX("sdmmc3", NULL, "sdhci-tegra.2", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC3, 69, &periph_u_regs, 0, sdmmc3),
-	TEGRA_INIT_DATA_MUX("sdmmc4", NULL, "sdhci-tegra.3", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC4, 15, &periph_l_regs, 0, sdmmc4),
-	TEGRA_INIT_DATA_INT("vde", NULL, "vde", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_VDE, 61, &periph_h_regs, 0, vde),
-	TEGRA_INIT_DATA_MUX_FLAGS("csite", NULL, "csite", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_CSITE, 73, &periph_u_regs, TEGRA_PERIPH_ON_APB, csite, CLK_IGNORE_UNUSED),
-	TEGRA_INIT_DATA_MUX("la", NULL, "la", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_LA, 76, &periph_u_regs, TEGRA_PERIPH_ON_APB, la),
-	TEGRA_INIT_DATA_MUX("trace", NULL, "trace", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_TRACE, 77, &periph_u_regs, TEGRA_PERIPH_ON_APB, trace),
-	TEGRA_INIT_DATA_MUX("owr", NULL, "tegra_w1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_OWR, 71, &periph_u_regs, TEGRA_PERIPH_ON_APB, owr),
-	TEGRA_INIT_DATA_MUX("nor", NULL, "tegra-nor", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_NOR, 42, &periph_h_regs, 0, nor),
-	TEGRA_INIT_DATA_MUX("mipi", NULL, "mipi", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_MIPI, 50, &periph_h_regs, TEGRA_PERIPH_ON_APB, mipi),
-	TEGRA_INIT_DATA_I2C("i2c1", "div-clk", "tegra11-i2c.0", mux_pllp_clkm, CLK_SOURCE_I2C1, 12, &periph_l_regs, i2c1),
-	TEGRA_INIT_DATA_I2C("i2c2", "div-clk", "tegra11-i2c.1", mux_pllp_clkm, CLK_SOURCE_I2C2, 54, &periph_h_regs, i2c2),
-	TEGRA_INIT_DATA_I2C("i2c3", "div-clk", "tegra11-i2c.2", mux_pllp_clkm, CLK_SOURCE_I2C3, 67, &periph_u_regs, i2c3),
-	TEGRA_INIT_DATA_I2C("i2c4", "div-clk", "tegra11-i2c.3", mux_pllp_clkm, CLK_SOURCE_I2C4, 103, &periph_v_regs, i2c4),
-	TEGRA_INIT_DATA_I2C("i2c5", "div-clk", "tegra11-i2c.4", mux_pllp_clkm, CLK_SOURCE_I2C5, 47, &periph_h_regs, i2c5),
-	TEGRA_INIT_DATA_UART("uarta", NULL, "tegra_uart.0", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTA, 6, &periph_l_regs, uarta),
-	TEGRA_INIT_DATA_UART("uartb", NULL, "tegra_uart.1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTB, 7, &periph_l_regs, uartb),
-	TEGRA_INIT_DATA_UART("uartc", NULL, "tegra_uart.2", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTC, 55, &periph_h_regs, uartc),
-	TEGRA_INIT_DATA_UART("uartd", NULL, "tegra_uart.3", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTD, 65, &periph_u_regs, uartd),
-	TEGRA_INIT_DATA_INT("3d", NULL, "3d", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_3D, 24, &periph_l_regs, 0, gr_3d),
-	TEGRA_INIT_DATA_INT("2d", NULL, "2d", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_2D, 21, &periph_l_regs, 0, gr_2d),
-	TEGRA_INIT_DATA_MUX("vi_sensor", "vi_sensor", "tegra_camera", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI_SENSOR, 20, &periph_l_regs, TEGRA_PERIPH_NO_RESET, vi_sensor),
-	TEGRA_INIT_DATA_INT8("vi", "vi", "tegra_camera", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI, 20, &periph_l_regs, 0, vi),
-	TEGRA_INIT_DATA_INT8("epp", NULL, "epp", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_EPP, 19, &periph_l_regs, 0, epp),
-	TEGRA_INIT_DATA_INT8("msenc", NULL, "msenc", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_MSENC, 91, &periph_u_regs, TEGRA_PERIPH_WAR_1005168, msenc),
-	TEGRA_INIT_DATA_INT8("tsec", NULL, "tsec", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_TSEC, 83, &periph_u_regs, 0, tsec),
-	TEGRA_INIT_DATA_INT8("host1x", NULL, "host1x", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_HOST1X, 28, &periph_l_regs, 0, host1x),
-	TEGRA_INIT_DATA_MUX8("hdmi", NULL, "hdmi", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_HDMI, 51, &periph_h_regs, 0, hdmi),
-	TEGRA_INIT_DATA_MUX("cilab", "cilab", "tegra_camera", mux_pllp_pllc_clkm, CLK_SOURCE_CILAB, 144, &periph_w_regs, 0, cilab),
-	TEGRA_INIT_DATA_MUX("cilcd", "cilcd", "tegra_camera", mux_pllp_pllc_clkm, CLK_SOURCE_CILCD, 145, &periph_w_regs, 0, cilcd),
-	TEGRA_INIT_DATA_MUX("cile", "cile", "tegra_camera", mux_pllp_pllc_clkm, CLK_SOURCE_CILE, 146, &periph_w_regs, 0, cile),
-	TEGRA_INIT_DATA_MUX("dsialp", "dsialp", "tegradc.0", mux_pllp_pllc_clkm, CLK_SOURCE_DSIALP, 147, &periph_w_regs, 0, dsialp),
-	TEGRA_INIT_DATA_MUX("dsiblp", "dsiblp", "tegradc.1", mux_pllp_pllc_clkm, CLK_SOURCE_DSIBLP, 148, &periph_w_regs, 0, dsiblp),
-	TEGRA_INIT_DATA_MUX("tsensor", NULL, "tegra-tsensor", mux_pllp_pllc_clkm_clk32, CLK_SOURCE_TSENSOR, 100, &periph_v_regs, TEGRA_PERIPH_ON_APB, tsensor),
-	TEGRA_INIT_DATA_MUX("actmon", NULL, "actmon", mux_pllp_pllc_clk32_clkm, CLK_SOURCE_ACTMON, 119, &periph_v_regs, 0, actmon),
-	TEGRA_INIT_DATA_MUX8("extern1", NULL, "extern1", mux_plla_clk32_pllp_clkm_plle, CLK_SOURCE_EXTERN1, 120, &periph_v_regs, 0, extern1),
-	TEGRA_INIT_DATA_MUX8("extern2", NULL, "extern2", mux_plla_clk32_pllp_clkm_plle, CLK_SOURCE_EXTERN2, 121, &periph_v_regs, 0, extern2),
-	TEGRA_INIT_DATA_MUX8("extern3", NULL, "extern3", mux_plla_clk32_pllp_clkm_plle, CLK_SOURCE_EXTERN3, 122, &periph_v_regs, 0, extern3),
-	TEGRA_INIT_DATA_MUX("i2cslow", NULL, "i2cslow", mux_pllp_pllc_clk32_clkm, CLK_SOURCE_I2CSLOW, 81, &periph_u_regs, TEGRA_PERIPH_ON_APB, i2cslow),
-	TEGRA_INIT_DATA_INT8("se", NULL, "se", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SE, 127, &periph_v_regs, TEGRA_PERIPH_ON_APB, se),
-	TEGRA_INIT_DATA_INT_FLAGS("mselect", NULL, "mselect", mux_pllp_clkm, CLK_SOURCE_MSELECT, 99, &periph_v_regs, 0, mselect, CLK_IGNORE_UNUSED),
-	TEGRA_INIT_DATA_MUX("dfll_ref", "ref", "t114_dfll", mux_pllp_clkm, CLK_SOURCE_DFLL_REF, 155, &periph_w_regs, TEGRA_PERIPH_ON_APB, dfll_ref),
-	TEGRA_INIT_DATA_MUX("dfll_soc", "soc", "t114_dfll", mux_pllp_clkm, CLK_SOURCE_DFLL_SOC, 155, &periph_w_regs, TEGRA_PERIPH_ON_APB, dfll_soc),
-	TEGRA_INIT_DATA_MUX8("soc_therm", NULL, "soc_therm", mux_pllm_pllc_pllp_plla, CLK_SOURCE_SOC_THERM, 78, &periph_u_regs, TEGRA_PERIPH_ON_APB, soc_therm),
-	TEGRA_INIT_DATA_XUSB("xusb_host_src", "host_src", "tegra_xhci", mux_clkm_pllp_pllc_pllre, CLK_SOURCE_XUSB_HOST_SRC, 143, &periph_w_regs, TEGRA_PERIPH_ON_APB | TEGRA_PERIPH_NO_RESET, xusb_host_src),
-	TEGRA_INIT_DATA_XUSB("xusb_falcon_src", "falcon_src", "tegra_xhci", mux_clkm_pllp_pllc_pllre, CLK_SOURCE_XUSB_FALCON_SRC, 143, &periph_w_regs, TEGRA_PERIPH_NO_RESET, xusb_falcon_src),
-	TEGRA_INIT_DATA_XUSB("xusb_fs_src", "fs_src", "tegra_xhci", mux_clkm_48M_pllp_480M, CLK_SOURCE_XUSB_FS_SRC, 143, &periph_w_regs, TEGRA_PERIPH_NO_RESET, xusb_fs_src),
-	TEGRA_INIT_DATA_XUSB("xusb_ss_src", "ss_src", "tegra_xhci", mux_clkm_pllre_clk32_480M_pllc_ref, CLK_SOURCE_XUSB_SS_SRC, 143, &periph_w_regs, TEGRA_PERIPH_NO_RESET, xusb_ss_src),
-	TEGRA_INIT_DATA_XUSB("xusb_dev_src", "dev_src", "tegra_xhci", mux_clkm_pllp_pllc_pllre, CLK_SOURCE_XUSB_DEV_SRC, 95, &periph_u_regs, TEGRA_PERIPH_ON_APB | TEGRA_PERIPH_NO_RESET, xusb_dev_src),
-	TEGRA_INIT_DATA_AUDIO("d_audio", "d_audio", "tegra30-ahub", CLK_SOURCE_D_AUDIO, 106, &periph_v_regs, TEGRA_PERIPH_ON_APB, d_audio),
-	TEGRA_INIT_DATA_AUDIO("dam0", NULL, "tegra30-dam.0", CLK_SOURCE_DAM0, 108, &periph_v_regs, TEGRA_PERIPH_ON_APB, dam0),
-	TEGRA_INIT_DATA_AUDIO("dam1", NULL, "tegra30-dam.1", CLK_SOURCE_DAM1, 109, &periph_v_regs, TEGRA_PERIPH_ON_APB, dam1),
-	TEGRA_INIT_DATA_AUDIO("dam2", NULL, "tegra30-dam.2", CLK_SOURCE_DAM2, 110, &periph_v_regs, TEGRA_PERIPH_ON_APB, dam2),
+	TEGRA_INIT_DATA_MUX("i2s0", NULL, "tegra30-i2s.0", mux_pllaout0_audio0_2x_pllp_clkm, CLK_SOURCE_I2S0, 30, &periph_l_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S0),
+	TEGRA_INIT_DATA_MUX("i2s1", NULL, "tegra30-i2s.1", mux_pllaout0_audio1_2x_pllp_clkm, CLK_SOURCE_I2S1, 11, &periph_l_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S1),
+	TEGRA_INIT_DATA_MUX("i2s2", NULL, "tegra30-i2s.2", mux_pllaout0_audio2_2x_pllp_clkm, CLK_SOURCE_I2S2, 18, &periph_l_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S2),
+	TEGRA_INIT_DATA_MUX("i2s3", NULL, "tegra30-i2s.3", mux_pllaout0_audio3_2x_pllp_clkm, CLK_SOURCE_I2S3, 101, &periph_v_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S3),
+	TEGRA_INIT_DATA_MUX("i2s4", NULL, "tegra30-i2s.4", mux_pllaout0_audio4_2x_pllp_clkm, CLK_SOURCE_I2S4, 102, &periph_v_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S4),
+	TEGRA_INIT_DATA_MUX("spdif_out", "spdif_out", "tegra30-spdif", mux_pllaout0_audio_2x_pllp_clkm, CLK_SOURCE_SPDIF_OUT, 10, &periph_l_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SPDIF_OUT),
+	TEGRA_INIT_DATA_MUX("spdif_in", "spdif_in", "tegra30-spdif", mux_pllp_pllc_pllm, CLK_SOURCE_SPDIF_IN, 10, &periph_l_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SPDIF_IN),
+	TEGRA_INIT_DATA_MUX("pwm", NULL, "pwm", mux_pllp_pllc_clk32_clkm, CLK_SOURCE_PWM, 17, &periph_l_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_PWM),
+	TEGRA_INIT_DATA_MUX("adx", NULL, "adx", mux_plla_pllc_pllp_clkm, CLK_SOURCE_ADX, 154, &periph_w_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_ADX),
+	TEGRA_INIT_DATA_MUX("amx", NULL, "amx", mux_plla_pllc_pllp_clkm, CLK_SOURCE_AMX, 153, &periph_w_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_AMX),
+	TEGRA_INIT_DATA_MUX("hda", "hda", "tegra30-hda", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_HDA, 125, &periph_v_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_HDA),
+	TEGRA_INIT_DATA_MUX("hda2codec_2x", "hda2codec", "tegra30-hda", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_HDA2CODEC_2X, 111, &periph_v_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_HDA2CODEC_2X),
+	TEGRA_INIT_DATA_MUX("sbc1", NULL, "tegra11-spi.0", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC1, 41, &periph_h_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC1),
+	TEGRA_INIT_DATA_MUX("sbc2", NULL, "tegra11-spi.1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC2, 44, &periph_h_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC2),
+	TEGRA_INIT_DATA_MUX("sbc3", NULL, "tegra11-spi.2", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC3, 46, &periph_h_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC3),
+	TEGRA_INIT_DATA_MUX("sbc4", NULL, "tegra11-spi.3", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC4, 68, &periph_u_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC4),
+	TEGRA_INIT_DATA_MUX("sbc5", NULL, "tegra11-spi.4", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC5, 104, &periph_v_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC5),
+	TEGRA_INIT_DATA_MUX("sbc6", NULL, "tegra11-spi.5", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC6, 105, &periph_v_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC6),
+	TEGRA_INIT_DATA_MUX8("ndflash", NULL, "tegra_nand", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_NDFLASH, 13, &periph_u_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_NDSPEED),
+	TEGRA_INIT_DATA_MUX8("ndspeed", NULL, "tegra_nand_speed", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_NDSPEED, 80, &periph_u_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_NDSPEED),
+	TEGRA_INIT_DATA_MUX("vfir", NULL, "vfir", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_VFIR, 7, &periph_l_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_VFIR),
+	TEGRA_INIT_DATA_MUX("sdmmc1", NULL, "sdhci-tegra.0", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC1, 14, &periph_l_regs, 0, TEGRA114_CLK_SDMMC1),
+	TEGRA_INIT_DATA_MUX("sdmmc2", NULL, "sdhci-tegra.1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC2, 9, &periph_l_regs, 0, TEGRA114_CLK_SDMMC2),
+	TEGRA_INIT_DATA_MUX("sdmmc3", NULL, "sdhci-tegra.2", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC3, 69, &periph_u_regs, 0, TEGRA114_CLK_SDMMC3),
+	TEGRA_INIT_DATA_MUX("sdmmc4", NULL, "sdhci-tegra.3", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC4, 15, &periph_l_regs, 0, TEGRA114_CLK_SDMMC4),
+	TEGRA_INIT_DATA_INT("vde", NULL, "vde", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_VDE, 61, &periph_h_regs, 0, TEGRA114_CLK_VDE),
+	TEGRA_INIT_DATA_MUX_FLAGS("csite", NULL, "csite", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_CSITE, 73, &periph_u_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_CSITE, CLK_IGNORE_UNUSED),
+	TEGRA_INIT_DATA_MUX("la", NULL, "la", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_LA, 76, &periph_u_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_LA),
+	TEGRA_INIT_DATA_MUX("trace", NULL, "trace", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_TRACE, 77, &periph_u_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_TRACE),
+	TEGRA_INIT_DATA_MUX("owr", NULL, "tegra_w1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_OWR, 71, &periph_u_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_OWR),
+	TEGRA_INIT_DATA_MUX("nor", NULL, "tegra-nor", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_NOR, 42, &periph_h_regs, 0, TEGRA114_CLK_NOR),
+	TEGRA_INIT_DATA_MUX("mipi", NULL, "mipi", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_MIPI, 50, &periph_h_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_MIPI),
+	TEGRA_INIT_DATA_I2C("i2c1", "div-clk", "tegra11-i2c.0", mux_pllp_clkm, CLK_SOURCE_I2C1, 12, &periph_l_regs, TEGRA114_CLK_I2C1),
+	TEGRA_INIT_DATA_I2C("i2c2", "div-clk", "tegra11-i2c.1", mux_pllp_clkm, CLK_SOURCE_I2C2, 54, &periph_h_regs, TEGRA114_CLK_I2C2),
+	TEGRA_INIT_DATA_I2C("i2c3", "div-clk", "tegra11-i2c.2", mux_pllp_clkm, CLK_SOURCE_I2C3, 67, &periph_u_regs, TEGRA114_CLK_I2C3),
+	TEGRA_INIT_DATA_I2C("i2c4", "div-clk", "tegra11-i2c.3", mux_pllp_clkm, CLK_SOURCE_I2C4, 103, &periph_v_regs, TEGRA114_CLK_I2C4),
+	TEGRA_INIT_DATA_I2C("i2c5", "div-clk", "tegra11-i2c.4", mux_pllp_clkm, CLK_SOURCE_I2C5, 47, &periph_h_regs, TEGRA114_CLK_I2C5),
+	TEGRA_INIT_DATA_UART("uarta", NULL, "tegra_uart.0", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTA, 6, &periph_l_regs, TEGRA114_CLK_UARTA),
+	TEGRA_INIT_DATA_UART("uartb", NULL, "tegra_uart.1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTB, 7, &periph_l_regs, TEGRA114_CLK_UARTB),
+	TEGRA_INIT_DATA_UART("uartc", NULL, "tegra_uart.2", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTC, 55, &periph_h_regs, TEGRA114_CLK_UARTC),
+	TEGRA_INIT_DATA_UART("uartd", NULL, "tegra_uart.3", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTD, 65, &periph_u_regs, TEGRA114_CLK_UARTD),
+	TEGRA_INIT_DATA_INT("3d", NULL, "3d", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_3D, 24, &periph_l_regs, 0, TEGRA114_CLK_GR_3D),
+	TEGRA_INIT_DATA_INT("2d", NULL, "2d", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_2D, 21, &periph_l_regs, 0, TEGRA114_CLK_GR_2D),
+	TEGRA_INIT_DATA_MUX("vi_sensor", "vi_sensor", "tegra_camera", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI_SENSOR, 20, &periph_l_regs, TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_VI_SENSOR),
+	TEGRA_INIT_DATA_INT8("vi", "vi", "tegra_camera", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI, 20, &periph_l_regs, 0, TEGRA114_CLK_VI),
+	TEGRA_INIT_DATA_INT8("epp", NULL, "epp", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_EPP, 19, &periph_l_regs, 0, TEGRA114_CLK_EPP),
+	TEGRA_INIT_DATA_INT8("msenc", NULL, "msenc", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_MSENC, 91, &periph_u_regs, TEGRA_PERIPH_WAR_1005168, TEGRA114_CLK_MSENC),
+	TEGRA_INIT_DATA_INT8("tsec", NULL, "tsec", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_TSEC, 83, &periph_u_regs, 0, TEGRA114_CLK_TSEC),
+	TEGRA_INIT_DATA_INT8("host1x", NULL, "host1x", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_HOST1X, 28, &periph_l_regs, 0, TEGRA114_CLK_HOST1X),
+	TEGRA_INIT_DATA_MUX8("hdmi", NULL, "hdmi", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_HDMI, 51, &periph_h_regs, 0, TEGRA114_CLK_HDMI),
+	TEGRA_INIT_DATA_MUX("cilab", "cilab", "tegra_camera", mux_pllp_pllc_clkm, CLK_SOURCE_CILAB, 144, &periph_w_regs, 0, TEGRA114_CLK_CILAB),
+	TEGRA_INIT_DATA_MUX("cilcd", "cilcd", "tegra_camera", mux_pllp_pllc_clkm, CLK_SOURCE_CILCD, 145, &periph_w_regs, 0, TEGRA114_CLK_CILCD),
+	TEGRA_INIT_DATA_MUX("cile", "cile", "tegra_camera", mux_pllp_pllc_clkm, CLK_SOURCE_CILE, 146, &periph_w_regs, 0, TEGRA114_CLK_CILE),
+	TEGRA_INIT_DATA_MUX("dsialp", "dsialp", "tegradc.0", mux_pllp_pllc_clkm, CLK_SOURCE_DSIALP, 147, &periph_w_regs, 0, TEGRA114_CLK_DSIALP),
+	TEGRA_INIT_DATA_MUX("dsiblp", "dsiblp", "tegradc.1", mux_pllp_pllc_clkm, CLK_SOURCE_DSIBLP, 148, &periph_w_regs, 0, TEGRA114_CLK_DSIBLP),
+	TEGRA_INIT_DATA_MUX("tsensor", NULL, "tegra-tsensor", mux_pllp_pllc_clkm_clk32, CLK_SOURCE_TSENSOR, 100, &periph_v_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_TSENSOR),
+	TEGRA_INIT_DATA_MUX("actmon", NULL, "actmon", mux_pllp_pllc_clk32_clkm, CLK_SOURCE_ACTMON, 119, &periph_v_regs, 0, TEGRA114_CLK_ACTMON),
+	TEGRA_INIT_DATA_MUX8("extern1", NULL, "extern1", mux_plla_clk32_pllp_clkm_plle, CLK_SOURCE_EXTERN1, 120, &periph_v_regs, 0, TEGRA114_CLK_EXTERN1),
+	TEGRA_INIT_DATA_MUX8("extern2", NULL, "extern2", mux_plla_clk32_pllp_clkm_plle, CLK_SOURCE_EXTERN2, 121, &periph_v_regs, 0, TEGRA114_CLK_EXTERN2),
+	TEGRA_INIT_DATA_MUX8("extern3", NULL, "extern3", mux_plla_clk32_pllp_clkm_plle, CLK_SOURCE_EXTERN3, 122, &periph_v_regs, 0, TEGRA114_CLK_EXTERN3),
+	TEGRA_INIT_DATA_MUX("i2cslow", NULL, "i2cslow", mux_pllp_pllc_clk32_clkm, CLK_SOURCE_I2CSLOW, 81, &periph_u_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2CSLOW),
+	TEGRA_INIT_DATA_INT8("se", NULL, "se", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SE, 127, &periph_v_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SE),
+	TEGRA_INIT_DATA_INT_FLAGS("mselect", NULL, "mselect", mux_pllp_clkm, CLK_SOURCE_MSELECT, 99, &periph_v_regs, 0, TEGRA114_CLK_MSELECT, CLK_IGNORE_UNUSED),
+	TEGRA_INIT_DATA_MUX("dfll_ref", "ref", "t114_dfll", mux_pllp_clkm, CLK_SOURCE_DFLL_REF, 155, &periph_w_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DFLL_REF),
+	TEGRA_INIT_DATA_MUX("dfll_soc", "soc", "t114_dfll", mux_pllp_clkm, CLK_SOURCE_DFLL_SOC, 155, &periph_w_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DFLL_SOC),
+	TEGRA_INIT_DATA_MUX8("soc_therm", NULL, "soc_therm", mux_pllm_pllc_pllp_plla, CLK_SOURCE_SOC_THERM, 78, &periph_u_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SOC_THERM),
+	TEGRA_INIT_DATA_XUSB("xusb_host_src", "host_src", "tegra_xhci", mux_clkm_pllp_pllc_pllre, CLK_SOURCE_XUSB_HOST_SRC, 143, &periph_w_regs, TEGRA_PERIPH_ON_APB | TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_HOST_SRC),
+	TEGRA_INIT_DATA_XUSB("xusb_falcon_src", "falcon_src", "tegra_xhci", mux_clkm_pllp_pllc_pllre, CLK_SOURCE_XUSB_FALCON_SRC, 143, &periph_w_regs, TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_FALCON_SRC),
+	TEGRA_INIT_DATA_XUSB("xusb_fs_src", "fs_src", "tegra_xhci", mux_clkm_48M_pllp_480M, CLK_SOURCE_XUSB_FS_SRC, 143, &periph_w_regs, TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_FS_SRC),
+	TEGRA_INIT_DATA_XUSB("xusb_ss_src", "ss_src", "tegra_xhci", mux_clkm_pllre_clk32_480M_pllc_ref, CLK_SOURCE_XUSB_SS_SRC, 143, &periph_w_regs, TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_SS_SRC),
+	TEGRA_INIT_DATA_XUSB("xusb_dev_src", "dev_src", "tegra_xhci", mux_clkm_pllp_pllc_pllre, CLK_SOURCE_XUSB_DEV_SRC, 95, &periph_u_regs, TEGRA_PERIPH_ON_APB | TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_DEV_SRC),
+	TEGRA_INIT_DATA_AUDIO("d_audio", "d_audio", "tegra30-ahub", CLK_SOURCE_D_AUDIO, 106, &periph_v_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_D_AUDIO),
+	TEGRA_INIT_DATA_AUDIO("dam0", NULL, "tegra30-dam.0", CLK_SOURCE_DAM0, 108, &periph_v_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DAM0),
+	TEGRA_INIT_DATA_AUDIO("dam1", NULL, "tegra30-dam.1", CLK_SOURCE_DAM1, 109, &periph_v_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DAM1),
+	TEGRA_INIT_DATA_AUDIO("dam2", NULL, "tegra30-dam.2", CLK_SOURCE_DAM2, 110, &periph_v_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DAM2),
 };
 
 static struct tegra_periph_init_data tegra_periph_nodiv_clk_list[] = {
-	TEGRA_INIT_DATA_NODIV("disp1", NULL, "tegradc.0", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_DISP1, 29, 7, 27, &periph_l_regs, 0, disp1),
-	TEGRA_INIT_DATA_NODIV("disp2", NULL, "tegradc.1", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_DISP2, 29, 7, 26, &periph_l_regs, 0, disp2),
+	TEGRA_INIT_DATA_NODIV("disp1", NULL, "tegradc.0", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_DISP1, 29, 7, 27, &periph_l_regs, 0, TEGRA114_CLK_DISP1),
+	TEGRA_INIT_DATA_NODIV("disp2", NULL, "tegradc.1", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_DISP2, 29, 7, 26, &periph_l_regs, 0, TEGRA114_CLK_DISP2),
 };
 
 static __init void tegra114_periph_clk_init(void __iomem *clk_base)
@@ -1927,7 +1891,7 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base)
 	clk = tegra_clk_register_periph_gate("apbdma", "clk_m", 0, clk_base,
 				  0, 34, &periph_h_regs,
 				  periph_clk_enb_refcnt);
-	clks[apbdma] = clk;
+	clks[TEGRA114_CLK_APBDMA] = clk;
 
 	/* rtc */
 	clk = tegra_clk_register_periph_gate("rtc", "clk_32k",
@@ -1936,7 +1900,7 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base)
 				    0, 4, &periph_l_regs,
 				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "rtc-tegra");
-	clks[rtc] = clk;
+	clks[TEGRA114_CLK_RTC] = clk;
 
 	/* kbc */
 	clk = tegra_clk_register_periph_gate("kbc", "clk_32k",
@@ -1944,142 +1908,142 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base)
 				    TEGRA_PERIPH_NO_RESET, clk_base,
 				    0, 36, &periph_h_regs,
 				    periph_clk_enb_refcnt);
-	clks[kbc] = clk;
+	clks[TEGRA114_CLK_KBC] = clk;
 
 	/* timer */
 	clk = tegra_clk_register_periph_gate("timer", "clk_m", 0, clk_base,
 				  0, 5, &periph_l_regs,
 				  periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "timer");
-	clks[timer] = clk;
+	clks[TEGRA114_CLK_TIMER] = clk;
 
 	/* kfuse */
 	clk = tegra_clk_register_periph_gate("kfuse", "clk_m",
 				  TEGRA_PERIPH_ON_APB, clk_base,  0, 40,
 				  &periph_h_regs, periph_clk_enb_refcnt);
-	clks[kfuse] = clk;
+	clks[TEGRA114_CLK_KFUSE] = clk;
 
 	/* fuse */
 	clk = tegra_clk_register_periph_gate("fuse", "clk_m",
 				  TEGRA_PERIPH_ON_APB, clk_base,  0, 39,
 				  &periph_h_regs, periph_clk_enb_refcnt);
-	clks[fuse] = clk;
+	clks[TEGRA114_CLK_FUSE] = clk;
 
 	/* fuse_burn */
 	clk = tegra_clk_register_periph_gate("fuse_burn", "clk_m",
 				  TEGRA_PERIPH_ON_APB, clk_base,  0, 39,
 				  &periph_h_regs, periph_clk_enb_refcnt);
-	clks[fuse_burn] = clk;
+	clks[TEGRA114_CLK_FUSE_BURN] = clk;
 
 	/* apbif */
 	clk = tegra_clk_register_periph_gate("apbif", "clk_m",
 				  TEGRA_PERIPH_ON_APB, clk_base,  0, 107,
 				  &periph_v_regs, periph_clk_enb_refcnt);
-	clks[apbif] = clk;
+	clks[TEGRA114_CLK_APBIF] = clk;
 
 	/* hda2hdmi */
 	clk = tegra_clk_register_periph_gate("hda2hdmi", "clk_m",
 				    TEGRA_PERIPH_ON_APB, clk_base,  0, 128,
 				    &periph_w_regs, periph_clk_enb_refcnt);
-	clks[hda2hdmi] = clk;
+	clks[TEGRA114_CLK_HDA2HDMI] = clk;
 
 	/* vcp */
 	clk = tegra_clk_register_periph_gate("vcp", "clk_m", 0, clk_base,  0,
 				  29, &periph_l_regs,
 				  periph_clk_enb_refcnt);
-	clks[vcp] = clk;
+	clks[TEGRA114_CLK_VCP] = clk;
 
 	/* bsea */
 	clk = tegra_clk_register_periph_gate("bsea", "clk_m", 0, clk_base,
 				  0, 62, &periph_h_regs,
 				  periph_clk_enb_refcnt);
-	clks[bsea] = clk;
+	clks[TEGRA114_CLK_BSEA] = clk;
 
 	/* bsev */
 	clk = tegra_clk_register_periph_gate("bsev", "clk_m", 0, clk_base,
 				  0, 63, &periph_h_regs,
 				  periph_clk_enb_refcnt);
-	clks[bsev] = clk;
+	clks[TEGRA114_CLK_BSEV] = clk;
 
 	/* mipi-cal */
 	clk = tegra_clk_register_periph_gate("mipi-cal", "clk_m", 0, clk_base,
 				   0, 56, &periph_h_regs,
 				  periph_clk_enb_refcnt);
-	clks[mipi_cal] = clk;
+	clks[TEGRA114_CLK_MIPI_CAL] = clk;
 
 	/* usbd */
 	clk = tegra_clk_register_periph_gate("usbd", "clk_m", 0, clk_base,
 				  0, 22, &periph_l_regs,
 				  periph_clk_enb_refcnt);
-	clks[usbd] = clk;
+	clks[TEGRA114_CLK_USBD] = clk;
 
 	/* usb2 */
 	clk = tegra_clk_register_periph_gate("usb2", "clk_m", 0, clk_base,
 				  0, 58, &periph_h_regs,
 				  periph_clk_enb_refcnt);
-	clks[usb2] = clk;
+	clks[TEGRA114_CLK_USB2] = clk;
 
 	/* usb3 */
 	clk = tegra_clk_register_periph_gate("usb3", "clk_m", 0, clk_base,
 				  0, 59, &periph_h_regs,
 				  periph_clk_enb_refcnt);
-	clks[usb3] = clk;
+	clks[TEGRA114_CLK_USB3] = clk;
 
 	/* csi */
 	clk = tegra_clk_register_periph_gate("csi", "pll_p_out3", 0, clk_base,
 				   0, 52, &periph_h_regs,
 				  periph_clk_enb_refcnt);
-	clks[csi] = clk;
+	clks[TEGRA114_CLK_CSI] = clk;
 
 	/* isp */
 	clk = tegra_clk_register_periph_gate("isp", "clk_m", 0, clk_base, 0,
 				  23, &periph_l_regs,
 				  periph_clk_enb_refcnt);
-	clks[isp] = clk;
+	clks[TEGRA114_CLK_ISP] = clk;
 
 	/* csus */
 	clk = tegra_clk_register_periph_gate("csus", "clk_m",
 				  TEGRA_PERIPH_NO_RESET, clk_base, 0, 92,
 				  &periph_u_regs, periph_clk_enb_refcnt);
-	clks[csus] = clk;
+	clks[TEGRA114_CLK_CSUS] = clk;
 
 	/* dds */
 	clk = tegra_clk_register_periph_gate("dds", "clk_m",
 				  TEGRA_PERIPH_ON_APB, clk_base, 0, 150,
 				  &periph_w_regs, periph_clk_enb_refcnt);
-	clks[dds] = clk;
+	clks[TEGRA114_CLK_DDS] = clk;
 
 	/* dp2 */
 	clk = tegra_clk_register_periph_gate("dp2", "clk_m",
 				  TEGRA_PERIPH_ON_APB, clk_base, 0, 152,
 				  &periph_w_regs, periph_clk_enb_refcnt);
-	clks[dp2] = clk;
+	clks[TEGRA114_CLK_DP2] = clk;
 
 	/* dtv */
 	clk = tegra_clk_register_periph_gate("dtv", "clk_m",
 				    TEGRA_PERIPH_ON_APB, clk_base, 0, 79,
 				    &periph_u_regs, periph_clk_enb_refcnt);
-	clks[dtv] = clk;
+	clks[TEGRA114_CLK_DTV] = clk;
 
 	/* dsia */
 	clk = clk_register_mux(NULL, "dsia_mux", mux_plld_out0_plld2_out0,
 			       ARRAY_SIZE(mux_plld_out0_plld2_out0), 0,
 			       clk_base + PLLD_BASE, 25, 1, 0, &pll_d_lock);
-	clks[dsia_mux] = clk;
+	clks[TEGRA114_CLK_DSIA_MUX] = clk;
 	clk = tegra_clk_register_periph_gate("dsia", "dsia_mux", 0, clk_base,
 				    0, 48, &periph_h_regs,
 				    periph_clk_enb_refcnt);
-	clks[dsia] = clk;
+	clks[TEGRA114_CLK_DSIA] = clk;
 
 	/* dsib */
 	clk = clk_register_mux(NULL, "dsib_mux", mux_plld_out0_plld2_out0,
 			       ARRAY_SIZE(mux_plld_out0_plld2_out0), 0,
 			       clk_base + PLLD2_BASE, 25, 1, 0, &pll_d2_lock);
-	clks[dsib_mux] = clk;
+	clks[TEGRA114_CLK_DSIB_MUX] = clk;
 	clk = tegra_clk_register_periph_gate("dsib", "dsib_mux", 0, clk_base,
 				    0, 82, &periph_u_regs,
 				    periph_clk_enb_refcnt);
-	clks[dsib] = clk;
+	clks[TEGRA114_CLK_DSIB] = clk;
 
 	/* xusb_hs_src */
 	val = readl(clk_base + CLK_SOURCE_XUSB_SS_SRC);
@@ -2088,25 +2052,25 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base)
 
 	clk = clk_register_fixed_factor(NULL, "xusb_hs_src", "pll_u_60M", 0,
 					1, 1);
-	clks[xusb_hs_src] = clk;
+	clks[TEGRA114_CLK_XUSB_HS_SRC] = clk;
 
 	/* xusb_host */
 	clk = tegra_clk_register_periph_gate("xusb_host", "xusb_host_src", 0,
 				    clk_base, 0, 89, &periph_u_regs,
 				    periph_clk_enb_refcnt);
-	clks[xusb_host] = clk;
+	clks[TEGRA114_CLK_XUSB_HOST] = clk;
 
 	/* xusb_ss */
 	clk = tegra_clk_register_periph_gate("xusb_ss", "xusb_ss_src", 0,
 				    clk_base, 0, 156, &periph_w_regs,
 				    periph_clk_enb_refcnt);
-	clks[xusb_host] = clk;
+	clks[TEGRA114_CLK_XUSB_HOST] = clk;
 
 	/* xusb_dev */
 	clk = tegra_clk_register_periph_gate("xusb_dev", "xusb_dev_src", 0,
 				    clk_base, 0, 95, &periph_u_regs,
 				    periph_clk_enb_refcnt);
-	clks[xusb_dev] = clk;
+	clks[TEGRA114_CLK_XUSB_DEV] = clk;
 
 	/* emc */
 	clk = clk_register_mux(NULL, "emc_mux", mux_pllmcp_clkm,
@@ -2116,7 +2080,7 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base)
 	clk = tegra_clk_register_periph_gate("emc", "emc_mux", 0, clk_base,
 				CLK_IGNORE_UNUSED, 57, &periph_h_regs,
 				periph_clk_enb_refcnt);
-	clks[emc] = clk;
+	clks[TEGRA114_CLK_EMC] = clk;
 
 	for (i = 0; i < ARRAY_SIZE(tegra_periph_clk_list); i++) {
 		data = &tegra_periph_clk_list[i];
@@ -2195,28 +2159,29 @@ static const struct of_device_id pmc_match[] __initconst = {
  * breaks
  */
 static struct tegra_clk_init_table init_table[] __initdata = {
-	{uarta, pll_p, 408000000, 0},
-	{uartb, pll_p, 408000000, 0},
-	{uartc, pll_p, 408000000, 0},
-	{uartd, pll_p, 408000000, 0},
-	{pll_a, clk_max, 564480000, 1},
-	{pll_a_out0, clk_max, 11289600, 1},
-	{extern1, pll_a_out0, 0, 1},
-	{clk_out_1_mux, extern1, 0, 1},
-	{clk_out_1, clk_max, 0, 1},
-	{i2s0, pll_a_out0, 11289600, 0},
-	{i2s1, pll_a_out0, 11289600, 0},
-	{i2s2, pll_a_out0, 11289600, 0},
-	{i2s3, pll_a_out0, 11289600, 0},
-	{i2s4, pll_a_out0, 11289600, 0},
-	{dfll_soc, pll_p, 51000000, 1},
-	{dfll_ref, pll_p, 51000000, 1},
-	{clk_max, clk_max, 0, 0}, /* This MUST be the last entry. */
+	{TEGRA114_CLK_UARTA, TEGRA114_CLK_PLL_P, 408000000, 0},
+	{TEGRA114_CLK_UARTB, TEGRA114_CLK_PLL_P, 408000000, 0},
+	{TEGRA114_CLK_UARTC, TEGRA114_CLK_PLL_P, 408000000, 0},
+	{TEGRA114_CLK_UARTD, TEGRA114_CLK_PLL_P, 408000000, 0},
+	{TEGRA114_CLK_PLL_A, TEGRA114_CLK_CLK_MAX, 564480000, 1},
+	{TEGRA114_CLK_PLL_A_OUT0, TEGRA114_CLK_CLK_MAX, 11289600, 1},
+	{TEGRA114_CLK_EXTERN1, TEGRA114_CLK_PLL_A_OUT0, 0, 1},
+	{TEGRA114_CLK_CLK_OUT_1_MUX, TEGRA114_CLK_EXTERN1, 0, 1},
+	{TEGRA114_CLK_CLK_OUT_1, TEGRA114_CLK_CLK_MAX, 0, 1},
+	{TEGRA114_CLK_I2S0, TEGRA114_CLK_PLL_A_OUT0, 11289600, 0},
+	{TEGRA114_CLK_I2S1, TEGRA114_CLK_PLL_A_OUT0, 11289600, 0},
+	{TEGRA114_CLK_I2S2, TEGRA114_CLK_PLL_A_OUT0, 11289600, 0},
+	{TEGRA114_CLK_I2S3, TEGRA114_CLK_PLL_A_OUT0, 11289600, 0},
+	{TEGRA114_CLK_I2S4, TEGRA114_CLK_PLL_A_OUT0, 11289600, 0},
+	{TEGRA114_CLK_DFLL_SOC, TEGRA114_CLK_PLL_P, 51000000, 1},
+	{TEGRA114_CLK_DFLL_REF, TEGRA114_CLK_PLL_P, 51000000, 1},
+	/* This MUST be the last entry. */
+	{TEGRA114_CLK_CLK_MAX, TEGRA114_CLK_CLK_MAX, 0, 0},
 };
 
 static void __init tegra114_clock_apply_init_table(void)
 {
-	tegra_init_from_table(init_table, clks, clk_max);
+	tegra_init_from_table(init_table, clks, TEGRA114_CLK_CLK_MAX);
 }
 
 
-- 
1.7.7.rc0.72.g4b5ea.dirty

