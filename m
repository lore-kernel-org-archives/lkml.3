Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548Ab3JOO5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:57:52 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11740 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab3JOO5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:57:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 15 Oct 2013 07:57:49 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hiroshi Doyu <hdoyu@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: [PATCH v3 15/19] clk: tegra20: replace enum by binding header
Date: Tue, 15 Oct 2013 17:53:00 +0300
Message-ID: <1381848794-11761-16-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com>
References: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com>
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
 drivers/clk/tegra/clk-tegra20.c |  302 ++++++++++++++++++---------------------
 1 files changed, 142 insertions(+), 160 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index 80445d3..b2d3361 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -22,6 +22,7 @@
 #include <linux/of_address.h>
 #include <linux/clk/tegra.h>
 #include <linux/delay.h>
+#include <dt-bindings/clock/tegra20-car.h>
 
 #include "clk.h"
 
@@ -201,25 +202,6 @@ static DEFINE_SPINLOCK(sysrate_lock);
 			_clk_num, _gate_flags,	\
 			_clk_id)
 
-/* IDs assigned here must be in sync with DT bindings definition
- * for Tegra20 clocks .
- */
-enum tegra20_clk {
-	cpu, ac97 = 3, rtc, timer, uarta, gpio = 8, sdmmc2, i2s1 = 11, i2c1,
-	ndflash, sdmmc1, sdmmc4, twc, pwm, i2s2, epp, gr2d = 21, usbd, isp,
-	gr3d, ide, disp2, disp1, host1x, vcp, cache2 = 31, mem, ahbdma, apbdma,
-	kbc = 36, stat_mon, pmc, fuse, kfuse, sbc1, nor, spi, sbc2, xio, sbc3,
-	dvc, dsi, mipi = 50, hdmi, csi, tvdac, i2c2, uartc, emc = 57, usb2,
-	usb3, mpe, vde, bsea, bsev, speedo, uartd, uarte, i2c3, sbc4, sdmmc3,
-	pex, owr, afi, csite, pcie_xclk, avpucq = 75, la, irama = 84, iramb,
-	iramc, iramd, cram2, audio_2x, clk_d, csus = 92, cdev2, cdev1,
-	uartb = 96, vfir, spdif_in, spdif_out, vi, vi_sensor, tvo, cve,
-	osc, clk_32k, clk_m, sclk, cclk, hclk, pclk, blink, pll_a, pll_a_out0,
-	pll_c, pll_c_out1, pll_d, pll_d_out0, pll_e, pll_m, pll_m_out1,
-	pll_p, pll_p_out1, pll_p_out2, pll_p_out3, pll_p_out4, pll_s, pll_u,
-	pll_x, cop, audio, pll_ref, twd, clk_max,
-};
-
 static struct clk **clks;
 
 static struct tegra_clk_pll_freq_table pll_c_freq_table[] = {
@@ -544,7 +526,7 @@ static void tegra20_pll_init(void)
 	clk = tegra_clk_register_pll("pll_c", "pll_ref", clk_base, NULL, 0,
 			    &pll_c_params, NULL);
 	clk_register_clkdev(clk, "pll_c", NULL);
-	clks[pll_c] = clk;
+	clks[TEGRA20_CLK_PLL_C] = clk;
 
 	/* PLLC_OUT1 */
 	clk = tegra_clk_register_divider("pll_c_out1_div", "pll_c",
@@ -554,13 +536,13 @@ static void tegra20_pll_init(void)
 				clk_base + PLLC_OUT, 1, 0, CLK_SET_RATE_PARENT,
 				0, NULL);
 	clk_register_clkdev(clk, "pll_c_out1", NULL);
-	clks[pll_c_out1] = clk;
+	clks[TEGRA20_CLK_PLL_C_OUT1] = clk;
 
 	/* PLLP */
 	clk = tegra_clk_register_pll("pll_p", "pll_ref", clk_base, NULL, 0,
 			    &pll_p_params, NULL);
 	clk_register_clkdev(clk, "pll_p", NULL);
-	clks[pll_p] = clk;
+	clks[TEGRA20_CLK_PLL_P] = clk;
 
 	/* PLLP_OUT1 */
 	clk = tegra_clk_register_divider("pll_p_out1_div", "pll_p",
@@ -572,7 +554,7 @@ static void tegra20_pll_init(void)
 				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
 				&pll_div_lock);
 	clk_register_clkdev(clk, "pll_p_out1", NULL);
-	clks[pll_p_out1] = clk;
+	clks[TEGRA20_CLK_PLL_P_OUT1] = clk;
 
 	/* PLLP_OUT2 */
 	clk = tegra_clk_register_divider("pll_p_out2_div", "pll_p",
@@ -584,7 +566,7 @@ static void tegra20_pll_init(void)
 				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
 				&pll_div_lock);
 	clk_register_clkdev(clk, "pll_p_out2", NULL);
-	clks[pll_p_out2] = clk;
+	clks[TEGRA20_CLK_PLL_P_OUT2] = clk;
 
 	/* PLLP_OUT3 */
 	clk = tegra_clk_register_divider("pll_p_out3_div", "pll_p",
@@ -596,7 +578,7 @@ static void tegra20_pll_init(void)
 				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
 				&pll_div_lock);
 	clk_register_clkdev(clk, "pll_p_out3", NULL);
-	clks[pll_p_out3] = clk;
+	clks[TEGRA20_CLK_PLL_P_OUT3] = clk;
 
 	/* PLLP_OUT4 */
 	clk = tegra_clk_register_divider("pll_p_out4_div", "pll_p",
@@ -608,14 +590,14 @@ static void tegra20_pll_init(void)
 				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
 				&pll_div_lock);
 	clk_register_clkdev(clk, "pll_p_out4", NULL);
-	clks[pll_p_out4] = clk;
+	clks[TEGRA20_CLK_PLL_P_OUT4] = clk;
 
 	/* PLLM */
 	clk = tegra_clk_register_pll("pll_m", "pll_ref", clk_base, NULL,
 			    CLK_IGNORE_UNUSED | CLK_SET_RATE_GATE,
 			    &pll_m_params, NULL);
 	clk_register_clkdev(clk, "pll_m", NULL);
-	clks[pll_m] = clk;
+	clks[TEGRA20_CLK_PLL_M] = clk;
 
 	/* PLLM_OUT1 */
 	clk = tegra_clk_register_divider("pll_m_out1_div", "pll_m",
@@ -625,37 +607,37 @@ static void tegra20_pll_init(void)
 				clk_base + PLLM_OUT, 1, 0, CLK_IGNORE_UNUSED |
 				CLK_SET_RATE_PARENT, 0, NULL);
 	clk_register_clkdev(clk, "pll_m_out1", NULL);
-	clks[pll_m_out1] = clk;
+	clks[TEGRA20_CLK_PLL_M_OUT1] = clk;
 
 	/* PLLX */
 	clk = tegra_clk_register_pll("pll_x", "pll_ref", clk_base, NULL, 0,
 			    &pll_x_params, NULL);
 	clk_register_clkdev(clk, "pll_x", NULL);
-	clks[pll_x] = clk;
+	clks[TEGRA20_CLK_PLL_X] = clk;
 
 	/* PLLU */
 	clk = tegra_clk_register_pll("pll_u", "pll_ref", clk_base, NULL, 0,
 			    &pll_u_params, NULL);
 	clk_register_clkdev(clk, "pll_u", NULL);
-	clks[pll_u] = clk;
+	clks[TEGRA20_CLK_PLL_U] = clk;
 
 	/* PLLD */
 	clk = tegra_clk_register_pll("pll_d", "pll_ref", clk_base, NULL, 0,
 			    &pll_d_params, NULL);
 	clk_register_clkdev(clk, "pll_d", NULL);
-	clks[pll_d] = clk;
+	clks[TEGRA20_CLK_PLL_D] = clk;
 
 	/* PLLD_OUT0 */
 	clk = clk_register_fixed_factor(NULL, "pll_d_out0", "pll_d",
 					CLK_SET_RATE_PARENT, 1, 2);
 	clk_register_clkdev(clk, "pll_d_out0", NULL);
-	clks[pll_d_out0] = clk;
+	clks[TEGRA20_CLK_PLL_D_OUT0] = clk;
 
 	/* PLLA */
 	clk = tegra_clk_register_pll("pll_a", "pll_p_out1", clk_base, NULL, 0,
 			    &pll_a_params, NULL);
 	clk_register_clkdev(clk, "pll_a", NULL);
-	clks[pll_a] = clk;
+	clks[TEGRA20_CLK_PLL_A] = clk;
 
 	/* PLLA_OUT0 */
 	clk = tegra_clk_register_divider("pll_a_out0_div", "pll_a",
@@ -665,13 +647,13 @@ static void tegra20_pll_init(void)
 				clk_base + PLLA_OUT, 1, 0, CLK_IGNORE_UNUSED |
 				CLK_SET_RATE_PARENT, 0, NULL);
 	clk_register_clkdev(clk, "pll_a_out0", NULL);
-	clks[pll_a_out0] = clk;
+	clks[TEGRA20_CLK_PLL_A_OUT0] = clk;
 
 	/* PLLE */
 	clk = tegra_clk_register_plle("pll_e", "pll_ref", clk_base, pmc_base,
 			     0, &pll_e_params, NULL);
 	clk_register_clkdev(clk, "pll_e", NULL);
-	clks[pll_e] = clk;
+	clks[TEGRA20_CLK_PLL_E] = clk;
 }
 
 static const char *cclk_parents[] = { "clk_m", "pll_c", "clk_32k", "pll_m",
@@ -690,14 +672,14 @@ static void tegra20_super_clk_init(void)
 			      ARRAY_SIZE(cclk_parents), CLK_SET_RATE_PARENT,
 			      clk_base + CCLK_BURST_POLICY, 0, 4, 0, 0, NULL);
 	clk_register_clkdev(clk, "cclk", NULL);
-	clks[cclk] = clk;
+	clks[TEGRA20_CLK_CCLK] = clk;
 
 	/* SCLK */
 	clk = tegra_clk_register_super_mux("sclk", sclk_parents,
 			      ARRAY_SIZE(sclk_parents), CLK_SET_RATE_PARENT,
 			      clk_base + SCLK_BURST_POLICY, 0, 4, 0, 0, NULL);
 	clk_register_clkdev(clk, "sclk", NULL);
-	clks[sclk] = clk;
+	clks[TEGRA20_CLK_SCLK] = clk;
 
 	/* HCLK */
 	clk = clk_register_divider(NULL, "hclk_div", "sclk", 0,
@@ -707,7 +689,7 @@ static void tegra20_super_clk_init(void)
 				clk_base + CLK_SYSTEM_RATE, 7,
 				CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
 	clk_register_clkdev(clk, "hclk", NULL);
-	clks[hclk] = clk;
+	clks[TEGRA20_CLK_HCLK] = clk;
 
 	/* PCLK */
 	clk = clk_register_divider(NULL, "pclk_div", "hclk", 0,
@@ -717,12 +699,12 @@ static void tegra20_super_clk_init(void)
 				clk_base + CLK_SYSTEM_RATE, 3,
 				CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
 	clk_register_clkdev(clk, "pclk", NULL);
-	clks[pclk] = clk;
+	clks[TEGRA20_CLK_PCLK] = clk;
 
 	/* twd */
 	clk = clk_register_fixed_factor(NULL, "twd", "cclk", 0, 1, 4);
 	clk_register_clkdev(clk, "twd", NULL);
-	clks[twd] = clk;
+	clks[TEGRA20_CLK_TWD] = clk;
 }
 
 static const char *audio_parents[] = {"spdif_in", "i2s1", "i2s2", "unused",
@@ -742,7 +724,7 @@ static void __init tegra20_audio_clk_init(void)
 				clk_base + AUDIO_SYNC_CLK, 4,
 				CLK_GATE_SET_TO_DISABLE, NULL);
 	clk_register_clkdev(clk, "audio", NULL);
-	clks[audio] = clk;
+	clks[TEGRA20_CLK_AUDIO] = clk;
 
 	/* audio_2x */
 	clk = clk_register_fixed_factor(NULL, "audio_doubler", "audio",
@@ -752,7 +734,7 @@ static void __init tegra20_audio_clk_init(void)
 				    CLK_SET_RATE_PARENT, 89,
 				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "audio_2x", NULL);
-	clks[audio_2x] = clk;
+	clks[TEGRA20_CLK_AUDIO_2X] = clk;
 
 }
 
@@ -772,56 +754,56 @@ static const char *mux_pllpdc_clkm[] = {"pll_p", "pll_d_out0", "pll_c",
 static const char *mux_pllmcp_clkm[] = {"pll_m", "pll_c", "pll_p", "clk_m"};
 
 static struct tegra_periph_init_data tegra_periph_clk_list[] = {
-	TEGRA_INIT_DATA_MUX("i2s1",	NULL,		"tegra20-i2s.0", i2s1_parents,	    CLK_SOURCE_I2S1,	  11,	TEGRA_PERIPH_ON_APB, i2s1),
-	TEGRA_INIT_DATA_MUX("i2s2",	NULL,		"tegra20-i2s.1", i2s2_parents,	    CLK_SOURCE_I2S2,	  18,	TEGRA_PERIPH_ON_APB, i2s2),
-	TEGRA_INIT_DATA_MUX("spdif_out", "spdif_out",	"tegra20-spdif", spdif_out_parents, CLK_SOURCE_SPDIF_OUT, 10,	TEGRA_PERIPH_ON_APB, spdif_out),
-	TEGRA_INIT_DATA_MUX("spdif_in",	"spdif_in",	"tegra20-spdif", spdif_in_parents,  CLK_SOURCE_SPDIF_IN,  10,	TEGRA_PERIPH_ON_APB, spdif_in),
-	TEGRA_INIT_DATA_MUX("sbc1",	NULL,		"spi_tegra.0",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC1,	  41,	TEGRA_PERIPH_ON_APB, sbc1),
-	TEGRA_INIT_DATA_MUX("sbc2",	NULL,		"spi_tegra.1",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC2,	  44,	TEGRA_PERIPH_ON_APB, sbc2),
-	TEGRA_INIT_DATA_MUX("sbc3",	NULL,		"spi_tegra.2",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC3,	  46,	TEGRA_PERIPH_ON_APB, sbc3),
-	TEGRA_INIT_DATA_MUX("sbc4",	NULL,		"spi_tegra.3",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC4,	  68,	TEGRA_PERIPH_ON_APB, sbc4),
-	TEGRA_INIT_DATA_MUX("spi",	NULL,		"spi",		 mux_pllpcm_clkm,   CLK_SOURCE_SPI,	  43,	TEGRA_PERIPH_ON_APB, spi),
-	TEGRA_INIT_DATA_MUX("xio",	NULL,		"xio",		 mux_pllpcm_clkm,   CLK_SOURCE_XIO,	  45,	0, xio),
-	TEGRA_INIT_DATA_MUX("twc",	NULL,		"twc",		 mux_pllpcm_clkm,   CLK_SOURCE_TWC,	  16,	TEGRA_PERIPH_ON_APB, twc),
-	TEGRA_INIT_DATA_MUX("ide",	NULL,		"ide",		 mux_pllpcm_clkm,   CLK_SOURCE_XIO,	  25,	0, ide),
-	TEGRA_INIT_DATA_MUX("ndflash",	NULL,		"tegra_nand",	 mux_pllpcm_clkm,   CLK_SOURCE_NDFLASH,	  13,	0, ndflash),
-	TEGRA_INIT_DATA_MUX("vfir",	NULL,		"vfir",		 mux_pllpcm_clkm,   CLK_SOURCE_VFIR,	  7,	TEGRA_PERIPH_ON_APB, vfir),
-	TEGRA_INIT_DATA_MUX("csite",	NULL,		"csite",	 mux_pllpcm_clkm,   CLK_SOURCE_CSITE,	  73,	0, csite),
-	TEGRA_INIT_DATA_MUX("la",	NULL,		"la",		 mux_pllpcm_clkm,   CLK_SOURCE_LA,	  76,	0, la),
-	TEGRA_INIT_DATA_MUX("owr",	NULL,		"tegra_w1",	 mux_pllpcm_clkm,   CLK_SOURCE_OWR,	  71,	TEGRA_PERIPH_ON_APB, owr),
-	TEGRA_INIT_DATA_MUX("mipi",	NULL,		"mipi",		 mux_pllpcm_clkm,   CLK_SOURCE_MIPI,	  50,	TEGRA_PERIPH_ON_APB, mipi),
-	TEGRA_INIT_DATA_MUX("vde",	NULL,		"vde",		 mux_pllpcm_clkm,   CLK_SOURCE_VDE,	  61,	0, vde),
-	TEGRA_INIT_DATA_MUX("vi",	"vi",		"tegra_camera",	 mux_pllmcpa,	    CLK_SOURCE_VI,	  20,	0, vi),
-	TEGRA_INIT_DATA_MUX("epp",	NULL,		"epp",		 mux_pllmcpa,	    CLK_SOURCE_EPP,	  19,	0, epp),
-	TEGRA_INIT_DATA_MUX("mpe",	NULL,		"mpe",		 mux_pllmcpa,	    CLK_SOURCE_MPE,	  60,	0, mpe),
-	TEGRA_INIT_DATA_MUX("host1x",	NULL,		"host1x",	 mux_pllmcpa,	    CLK_SOURCE_HOST1X,	  28,	0, host1x),
-	TEGRA_INIT_DATA_MUX("3d",	NULL,		"3d",		 mux_pllmcpa,	    CLK_SOURCE_3D,	  24,	TEGRA_PERIPH_MANUAL_RESET, gr3d),
-	TEGRA_INIT_DATA_MUX("2d",	NULL,		"2d",		 mux_pllmcpa,	    CLK_SOURCE_2D,	  21,	0, gr2d),
-	TEGRA_INIT_DATA_MUX("nor",	NULL,		"tegra-nor",	 mux_pllpcm_clkm,   CLK_SOURCE_NOR,	  42,	0, nor),
-	TEGRA_INIT_DATA_MUX("sdmmc1",	NULL,		"sdhci-tegra.0", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC1,	  14,	0, sdmmc1),
-	TEGRA_INIT_DATA_MUX("sdmmc2",	NULL,		"sdhci-tegra.1", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC2,	  9,	0, sdmmc2),
-	TEGRA_INIT_DATA_MUX("sdmmc3",	NULL,		"sdhci-tegra.2", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC3,	  69,	0, sdmmc3),
-	TEGRA_INIT_DATA_MUX("sdmmc4",	NULL,		"sdhci-tegra.3", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC4,	  15,	0, sdmmc4),
-	TEGRA_INIT_DATA_MUX("cve",	NULL,		"cve",		 mux_pllpdc_clkm,   CLK_SOURCE_CVE,	  49,	0, cve),
-	TEGRA_INIT_DATA_MUX("tvo",	NULL,		"tvo",		 mux_pllpdc_clkm,   CLK_SOURCE_TVO,	  49,	0, tvo),
-	TEGRA_INIT_DATA_MUX("tvdac",	NULL,		"tvdac",	 mux_pllpdc_clkm,   CLK_SOURCE_TVDAC,	  53,	0, tvdac),
-	TEGRA_INIT_DATA_MUX("vi_sensor", "vi_sensor",	"tegra_camera",	 mux_pllmcpa,	    CLK_SOURCE_VI_SENSOR, 20,	TEGRA_PERIPH_NO_RESET, vi_sensor),
-	TEGRA_INIT_DATA_DIV16("i2c1",	"div-clk",	"tegra-i2c.0",	 mux_pllpcm_clkm,   CLK_SOURCE_I2C1,	  12,	TEGRA_PERIPH_ON_APB, i2c1),
-	TEGRA_INIT_DATA_DIV16("i2c2",	"div-clk",	"tegra-i2c.1",	 mux_pllpcm_clkm,   CLK_SOURCE_I2C2,	  54,	TEGRA_PERIPH_ON_APB, i2c2),
-	TEGRA_INIT_DATA_DIV16("i2c3",	"div-clk",	"tegra-i2c.2",	 mux_pllpcm_clkm,   CLK_SOURCE_I2C3,	  67,	TEGRA_PERIPH_ON_APB, i2c3),
-	TEGRA_INIT_DATA_DIV16("dvc",	"div-clk",	"tegra-i2c.3",	 mux_pllpcm_clkm,   CLK_SOURCE_DVC,	  47,	TEGRA_PERIPH_ON_APB, dvc),
-	TEGRA_INIT_DATA_MUX("hdmi",	NULL,		"hdmi",		 mux_pllpdc_clkm,   CLK_SOURCE_HDMI,	  51,	0, hdmi),
-	TEGRA_INIT_DATA("pwm",		NULL,		"tegra-pwm",	 pwm_parents,	    CLK_SOURCE_PWM,	  28, 3, 0, 0, 8, 1, 0, 17, TEGRA_PERIPH_ON_APB, pwm),
+	TEGRA_INIT_DATA_MUX("i2s1",	NULL,		"tegra20-i2s.0", i2s1_parents,	    CLK_SOURCE_I2S1,	  11,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_I2S1),
+	TEGRA_INIT_DATA_MUX("i2s2",	NULL,		"tegra20-i2s.1", i2s2_parents,	    CLK_SOURCE_I2S2,	  18,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_I2S2),
+	TEGRA_INIT_DATA_MUX("spdif_out", "spdif_out",	"tegra20-spdif", spdif_out_parents, CLK_SOURCE_SPDIF_OUT, 10,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SPDIF_OUT),
+	TEGRA_INIT_DATA_MUX("spdif_in",	"spdif_in",	"tegra20-spdif", spdif_in_parents,  CLK_SOURCE_SPDIF_IN,  10,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SPDIF_IN),
+	TEGRA_INIT_DATA_MUX("sbc1",	NULL,		"spi_tegra.0",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC1,	  41,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SBC1),
+	TEGRA_INIT_DATA_MUX("sbc2",	NULL,		"spi_tegra.1",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC2,	  44,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SBC2),
+	TEGRA_INIT_DATA_MUX("sbc3",	NULL,		"spi_tegra.2",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC3,	  46,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SBC3),
+	TEGRA_INIT_DATA_MUX("sbc4",	NULL,		"spi_tegra.3",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC4,	  68,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SBC4),
+	TEGRA_INIT_DATA_MUX("spi",	NULL,		"spi",		 mux_pllpcm_clkm,   CLK_SOURCE_SPI,	  43,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SPI),
+	TEGRA_INIT_DATA_MUX("xio",	NULL,		"xio",		 mux_pllpcm_clkm,   CLK_SOURCE_XIO,	  45,	 0, TEGRA20_CLK_XIO),
+	TEGRA_INIT_DATA_MUX("twc",	NULL,		"twc",		 mux_pllpcm_clkm,   CLK_SOURCE_TWC,	  16,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_TWC),
+	TEGRA_INIT_DATA_MUX("ide",	NULL,		"ide",		 mux_pllpcm_clkm,   CLK_SOURCE_XIO,	  25,	 0, TEGRA20_CLK_IDE),
+	TEGRA_INIT_DATA_MUX("ndflash",	NULL,		"tegra_nand",	 mux_pllpcm_clkm,   CLK_SOURCE_NDFLASH,	  13,	 0, TEGRA20_CLK_NDFLASH),
+	TEGRA_INIT_DATA_MUX("vfir",	NULL,		"vfir",		 mux_pllpcm_clkm,   CLK_SOURCE_VFIR,	  7,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_VFIR),
+	TEGRA_INIT_DATA_MUX("csite",	NULL,		"csite",	 mux_pllpcm_clkm,   CLK_SOURCE_CSITE,	  73,	 0, TEGRA20_CLK_CSITE),
+	TEGRA_INIT_DATA_MUX("la",	NULL,		"la",		 mux_pllpcm_clkm,   CLK_SOURCE_LA,	  76,	 0, TEGRA20_CLK_LA),
+	TEGRA_INIT_DATA_MUX("owr",	NULL,		"tegra_w1",	 mux_pllpcm_clkm,   CLK_SOURCE_OWR,	  71,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_OWR),
+	TEGRA_INIT_DATA_MUX("mipi",	NULL,		"mipi",		 mux_pllpcm_clkm,   CLK_SOURCE_MIPI,	  50,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_MIPI),
+	TEGRA_INIT_DATA_MUX("vde",	NULL,		"vde",		 mux_pllpcm_clkm,   CLK_SOURCE_VDE,	  61,	 0, TEGRA20_CLK_VDE),
+	TEGRA_INIT_DATA_MUX("vi",	"vi",		"tegra_camera",	 mux_pllmcpa,	    CLK_SOURCE_VI,	  20,	 0, TEGRA20_CLK_VI),
+	TEGRA_INIT_DATA_MUX("epp",	NULL,		"epp",		 mux_pllmcpa,	    CLK_SOURCE_EPP,	  19,	 0, TEGRA20_CLK_EPP),
+	TEGRA_INIT_DATA_MUX("mpe",	NULL,		"mpe",		 mux_pllmcpa,	    CLK_SOURCE_MPE,	  60,	 0, TEGRA20_CLK_MPE),
+	TEGRA_INIT_DATA_MUX("host1x",	NULL,		"host1x",	 mux_pllmcpa,	    CLK_SOURCE_HOST1X,	  28,	 0, TEGRA20_CLK_HOST1X),
+	TEGRA_INIT_DATA_MUX("3d",	NULL,		"3d",		 mux_pllmcpa,	    CLK_SOURCE_3D,	  24,	 TEGRA_PERIPH_MANUAL_RESET, TEGRA20_CLK_GR3D),
+	TEGRA_INIT_DATA_MUX("2d",	NULL,		"2d",		 mux_pllmcpa,	    CLK_SOURCE_2D,	  21,	 0, TEGRA20_CLK_GR2D),
+	TEGRA_INIT_DATA_MUX("nor",	NULL,		"tegra-nor",	 mux_pllpcm_clkm,   CLK_SOURCE_NOR,	  42,	 0, TEGRA20_CLK_NOR),
+	TEGRA_INIT_DATA_MUX("sdmmc1",	NULL,		"sdhci-tegra.0", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC1,	  14,	 0, TEGRA20_CLK_SDMMC1),
+	TEGRA_INIT_DATA_MUX("sdmmc2",	NULL,		"sdhci-tegra.1", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC2,	  9,	 0, TEGRA20_CLK_SDMMC2),
+	TEGRA_INIT_DATA_MUX("sdmmc3",	NULL,		"sdhci-tegra.2", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC3,	  69,	 0, TEGRA20_CLK_SDMMC3),
+	TEGRA_INIT_DATA_MUX("sdmmc4",	NULL,		"sdhci-tegra.3", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC4,	  15,	 0, TEGRA20_CLK_SDMMC4),
+	TEGRA_INIT_DATA_MUX("cve",	NULL,		"cve",		 mux_pllpdc_clkm,   CLK_SOURCE_CVE,	  49,	 0, TEGRA20_CLK_CVE),
+	TEGRA_INIT_DATA_MUX("tvo",	NULL,		"tvo",		 mux_pllpdc_clkm,   CLK_SOURCE_TVO,	  49,	 0, TEGRA20_CLK_TVO),
+	TEGRA_INIT_DATA_MUX("tvdac",	NULL,		"tvdac",	 mux_pllpdc_clkm,   CLK_SOURCE_TVDAC,	  53,	 0, TEGRA20_CLK_TVDAC),
+	TEGRA_INIT_DATA_MUX("vi_sensor", "vi_sensor",	"tegra_camera",	 mux_pllmcpa,	    CLK_SOURCE_VI_SENSOR, 20,	 TEGRA_PERIPH_NO_RESET, TEGRA20_CLK_VI_SENSOR),
+	TEGRA_INIT_DATA_DIV16("i2c1",	"div-clk",	"tegra-i2c.0",	 mux_pllpcm_clkm,   CLK_SOURCE_I2C1,	  12,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_I2C1),
+	TEGRA_INIT_DATA_DIV16("i2c2",	"div-clk",	"tegra-i2c.1",	 mux_pllpcm_clkm,   CLK_SOURCE_I2C2,	  54,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_I2C2),
+	TEGRA_INIT_DATA_DIV16("i2c3",	"div-clk",	"tegra-i2c.2",	 mux_pllpcm_clkm,   CLK_SOURCE_I2C3,	  67,		TEGRA_PERIPH_ON_APB, TEGRA20_CLK_I2C3),
+	TEGRA_INIT_DATA_DIV16("dvc",	"div-clk",	"tegra-i2c.3",	 mux_pllpcm_clkm,   CLK_SOURCE_DVC,	  47,		TEGRA_PERIPH_ON_APB, TEGRA20_CLK_DVC),
+	TEGRA_INIT_DATA_MUX("hdmi",	NULL,		"hdmi",		 mux_pllpdc_clkm,   CLK_SOURCE_HDMI,	  51,		0, TEGRA20_CLK_HDMI),
+	TEGRA_INIT_DATA("pwm",		NULL,		"tegra-pwm",	 pwm_parents,	    CLK_SOURCE_PWM,	  28, 3, 0, 0, 8, 1, 0,  17, TEGRA_PERIPH_ON_APB, TEGRA20_CLK_PWM),
 };
 
 static struct tegra_periph_init_data tegra_periph_nodiv_clk_list[] = {
-	TEGRA_INIT_DATA_NODIV("uarta",	NULL, "tegra_uart.0", mux_pllpcm_clkm, CLK_SOURCE_UARTA, 30, 2, 6,  TEGRA_PERIPH_ON_APB, uarta),
-	TEGRA_INIT_DATA_NODIV("uartb",	NULL, "tegra_uart.1", mux_pllpcm_clkm, CLK_SOURCE_UARTB, 30, 2, 7,  TEGRA_PERIPH_ON_APB, uartb),
-	TEGRA_INIT_DATA_NODIV("uartc",	NULL, "tegra_uart.2", mux_pllpcm_clkm, CLK_SOURCE_UARTC, 30, 2, 55, TEGRA_PERIPH_ON_APB, uartc),
-	TEGRA_INIT_DATA_NODIV("uartd",	NULL, "tegra_uart.3", mux_pllpcm_clkm, CLK_SOURCE_UARTD, 30, 2, 65, TEGRA_PERIPH_ON_APB, uartd),
-	TEGRA_INIT_DATA_NODIV("uarte",	NULL, "tegra_uart.4", mux_pllpcm_clkm, CLK_SOURCE_UARTE, 30, 2, 66, TEGRA_PERIPH_ON_APB, uarte),
-	TEGRA_INIT_DATA_NODIV("disp1",	NULL, "tegradc.0",    mux_pllpdc_clkm, CLK_SOURCE_DISP1, 30, 2, 27, 0, disp1),
-	TEGRA_INIT_DATA_NODIV("disp2",	NULL, "tegradc.1",    mux_pllpdc_clkm, CLK_SOURCE_DISP2, 30, 2, 26, 0, disp2),
+	TEGRA_INIT_DATA_NODIV("uarta",	NULL, "tegra_uart.0", mux_pllpcm_clkm, CLK_SOURCE_UARTA, 30, 2, 6,   TEGRA_PERIPH_ON_APB, TEGRA20_CLK_UARTA),
+	TEGRA_INIT_DATA_NODIV("uartb",	NULL, "tegra_uart.1", mux_pllpcm_clkm, CLK_SOURCE_UARTB, 30, 2, 7,   TEGRA_PERIPH_ON_APB, TEGRA20_CLK_UARTB),
+	TEGRA_INIT_DATA_NODIV("uartc",	NULL, "tegra_uart.2", mux_pllpcm_clkm, CLK_SOURCE_UARTC, 30, 2, 55,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_UARTC),
+	TEGRA_INIT_DATA_NODIV("uartd",	NULL, "tegra_uart.3", mux_pllpcm_clkm, CLK_SOURCE_UARTD, 30, 2, 65,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_UARTD),
+	TEGRA_INIT_DATA_NODIV("uarte",	NULL, "tegra_uart.4", mux_pllpcm_clkm, CLK_SOURCE_UARTE, 30, 2, 66,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_UARTE),
+	TEGRA_INIT_DATA_NODIV("disp1",	NULL, "tegradc.0",    mux_pllpdc_clkm, CLK_SOURCE_DISP1, 30, 2, 27,  0, TEGRA20_CLK_DISP1),
+	TEGRA_INIT_DATA_NODIV("disp2",	NULL, "tegradc.1",    mux_pllpdc_clkm, CLK_SOURCE_DISP2, 30, 2, 26,  0, TEGRA20_CLK_DISP2),
 };
 
 static void __init tegra20_periph_clk_init(void)
@@ -835,58 +817,58 @@ static void __init tegra20_periph_clk_init(void)
 				    TEGRA_PERIPH_ON_APB,
 				    clk_base, 0, 3, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "tegra20-ac97");
-	clks[ac97] = clk;
+	clks[TEGRA20_CLK_AC97] = clk;
 
 	/* apbdma */
 	clk = tegra_clk_register_periph_gate("apbdma", "pclk", 0, clk_base,
 				    0, 34, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "tegra-apbdma");
-	clks[apbdma] = clk;
+	clks[TEGRA20_CLK_APBDMA] = clk;
 
 	/* rtc */
 	clk = tegra_clk_register_periph_gate("rtc", "clk_32k",
 				    TEGRA_PERIPH_NO_RESET,
 				    clk_base, 0, 4, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "rtc-tegra");
-	clks[rtc] = clk;
+	clks[TEGRA20_CLK_RTC] = clk;
 
 	/* timer */
 	clk = tegra_clk_register_periph_gate("timer", "clk_m", 0, clk_base,
 				    0, 5, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "timer");
-	clks[timer] = clk;
+	clks[TEGRA20_CLK_TIMER] = clk;
 
 	/* kbc */
 	clk = tegra_clk_register_periph_gate("kbc", "clk_32k",
 				    TEGRA_PERIPH_NO_RESET | TEGRA_PERIPH_ON_APB,
 				    clk_base, 0, 36, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "tegra-kbc");
-	clks[kbc] = clk;
+	clks[TEGRA20_CLK_KBC] = clk;
 
 	/* csus */
 	clk = tegra_clk_register_periph_gate("csus", "clk_m",
 				    TEGRA_PERIPH_NO_RESET,
 				    clk_base, 0, 92, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "csus", "tengra_camera");
-	clks[csus] = clk;
+	clks[TEGRA20_CLK_CSUS] = clk;
 
 	/* vcp */
 	clk = tegra_clk_register_periph_gate("vcp", "clk_m", 0,
 				    clk_base, 0, 29, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "vcp", "tegra-avp");
-	clks[vcp] = clk;
+	clks[TEGRA20_CLK_VCP] = clk;
 
 	/* bsea */
 	clk = tegra_clk_register_periph_gate("bsea", "clk_m", 0,
 				    clk_base, 0, 62, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "bsea", "tegra-avp");
-	clks[bsea] = clk;
+	clks[TEGRA20_CLK_BSEA] = clk;
 
 	/* bsev */
 	clk = tegra_clk_register_periph_gate("bsev", "clk_m", 0,
 				    clk_base, 0, 63, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "bsev", "tegra-aes");
-	clks[bsev] = clk;
+	clks[TEGRA20_CLK_BSEV] = clk;
 
 	/* emc */
 	clk = clk_register_mux(NULL, "emc_mux", mux_pllmcp_clkm,
@@ -897,61 +879,61 @@ static void __init tegra20_periph_clk_init(void)
 	clk = tegra_clk_register_periph_gate("emc", "emc_mux", 0, clk_base, 0,
 				    57, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "emc", NULL);
-	clks[emc] = clk;
+	clks[TEGRA20_CLK_EMC] = clk;
 
 	/* usbd */
 	clk = tegra_clk_register_periph_gate("usbd", "clk_m", 0, clk_base, 0,
 				    22, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "fsl-tegra-udc");
-	clks[usbd] = clk;
+	clks[TEGRA20_CLK_USBD] = clk;
 
 	/* usb2 */
 	clk = tegra_clk_register_periph_gate("usb2", "clk_m", 0, clk_base, 0,
 				    58, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "tegra-ehci.1");
-	clks[usb2] = clk;
+	clks[TEGRA20_CLK_USB2] = clk;
 
 	/* usb3 */
 	clk = tegra_clk_register_periph_gate("usb3", "clk_m", 0, clk_base, 0,
 				    59, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "tegra-ehci.2");
-	clks[usb3] = clk;
+	clks[TEGRA20_CLK_USB3] = clk;
 
 	/* dsi */
 	clk = tegra_clk_register_periph_gate("dsi", "pll_d", 0, clk_base, 0,
 				    48, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "dsi");
-	clks[dsi] = clk;
+	clks[TEGRA20_CLK_DSI] = clk;
 
 	/* csi */
 	clk = tegra_clk_register_periph_gate("csi", "pll_p_out3", 0, clk_base,
 				    0, 52, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "csi", "tegra_camera");
-	clks[csi] = clk;
+	clks[TEGRA20_CLK_CSI] = clk;
 
 	/* isp */
 	clk = tegra_clk_register_periph_gate("isp", "clk_m", 0, clk_base, 0, 23,
 				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "isp", "tegra_camera");
-	clks[isp] = clk;
+	clks[TEGRA20_CLK_ISP] = clk;
 
 	/* pex */
 	clk = tegra_clk_register_periph_gate("pex", "clk_m", 0, clk_base, 0, 70,
 				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "pex", NULL);
-	clks[pex] = clk;
+	clks[TEGRA20_CLK_PEX] = clk;
 
 	/* afi */
 	clk = tegra_clk_register_periph_gate("afi", "clk_m", 0, clk_base, 0, 72,
 				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "afi", NULL);
-	clks[afi] = clk;
+	clks[TEGRA20_CLK_AFI] = clk;
 
 	/* pcie_xclk */
 	clk = tegra_clk_register_periph_gate("pcie_xclk", "clk_m", 0, clk_base,
 				    0, 74, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "pcie_xclk", NULL);
-	clks[pcie_xclk] = clk;
+	clks[TEGRA20_CLK_PCIE_XCLK] = clk;
 
 	/* cdev1 */
 	clk = clk_register_fixed_rate(NULL, "cdev1_fixed", NULL, CLK_IS_ROOT,
@@ -959,7 +941,7 @@ static void __init tegra20_periph_clk_init(void)
 	clk = tegra_clk_register_periph_gate("cdev1", "cdev1_fixed", 0,
 				    clk_base, 0, 94, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "cdev1", NULL);
-	clks[cdev1] = clk;
+	clks[TEGRA20_CLK_CDEV1] = clk;
 
 	/* cdev2 */
 	clk = clk_register_fixed_rate(NULL, "cdev2_fixed", NULL, CLK_IS_ROOT,
@@ -967,7 +949,7 @@ static void __init tegra20_periph_clk_init(void)
 	clk = tegra_clk_register_periph_gate("cdev2", "cdev2_fixed", 0,
 				    clk_base, 0, 93, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "cdev2", NULL);
-	clks[cdev2] = clk;
+	clks[TEGRA20_CLK_CDEV2] = clk;
 
 	for (i = 0; i < ARRAY_SIZE(tegra_periph_clk_list); i++) {
 		data = &tegra_periph_clk_list[i];
@@ -998,7 +980,7 @@ static void __init tegra20_fixed_clk_init(void)
 	clk = clk_register_fixed_rate(NULL, "clk_32k", NULL, CLK_IS_ROOT,
 				      32768);
 	clk_register_clkdev(clk, "clk_32k", NULL);
-	clks[clk_32k] = clk;
+	clks[TEGRA20_CLK_CLK_32K] = clk;
 }
 
 static void __init tegra20_pmc_clk_init(void)
@@ -1014,7 +996,7 @@ static void __init tegra20_pmc_clk_init(void)
 				pmc_base + PMC_CTRL,
 				PMC_CTRL_BLINK_ENB, 0, NULL);
 	clk_register_clkdev(clk, "blink", NULL);
-	clks[blink] = clk;
+	clks[TEGRA20_CLK_BLINK] = clk;
 }
 
 static void __init tegra20_osc_clk_init(void)
@@ -1029,14 +1011,14 @@ static void __init tegra20_osc_clk_init(void)
 	clk = clk_register_fixed_rate(NULL, "clk_m", NULL, CLK_IS_ROOT |
 				      CLK_IGNORE_UNUSED, input_freq);
 	clk_register_clkdev(clk, "clk_m", NULL);
-	clks[clk_m] = clk;
+	clks[TEGRA20_CLK_CLK_M] = clk;
 
 	/* pll_ref */
 	pll_ref_div = tegra20_get_pll_ref_div();
 	clk = clk_register_fixed_factor(NULL, "pll_ref", "clk_m",
 					CLK_SET_RATE_PARENT, 1, pll_ref_div);
 	clk_register_clkdev(clk, "pll_ref", NULL);
-	clks[pll_ref] = clk;
+	clks[TEGRA20_CLK_PLL_REF] = clk;
 }
 
 /* Tegra20 CPU clock and reset control functions */
@@ -1170,49 +1152,49 @@ static struct tegra_cpu_car_ops tegra20_cpu_car_ops = {
 };
 
 static struct tegra_clk_init_table init_table[] __initdata = {
-	{pll_p, clk_max, 216000000, 1},
-	{pll_p_out1, clk_max, 28800000, 1},
-	{pll_p_out2, clk_max, 48000000, 1},
-	{pll_p_out3, clk_max, 72000000, 1},
-	{pll_p_out4, clk_max, 24000000, 1},
-	{pll_c, clk_max, 600000000, 1},
-	{pll_c_out1, clk_max, 120000000, 1},
-	{sclk, pll_c_out1, 0, 1},
-	{hclk, clk_max, 0, 1},
-	{pclk, clk_max, 60000000, 1},
-	{csite, clk_max, 0, 1},
-	{emc, clk_max, 0, 1},
-	{cclk, clk_max, 0, 1},
-	{uarta, pll_p, 0, 0},
-	{uartb, pll_p, 0, 0},
-	{uartc, pll_p, 0, 0},
-	{uartd, pll_p, 0, 0},
-	{uarte, pll_p, 0, 0},
-	{pll_a, clk_max, 56448000, 1},
-	{pll_a_out0, clk_max, 11289600, 1},
-	{cdev1, clk_max, 0, 1},
-	{blink, clk_max, 32768, 1},
-	{i2s1, pll_a_out0, 11289600, 0},
-	{i2s2, pll_a_out0, 11289600, 0},
-	{sdmmc1, pll_p, 48000000, 0},
-	{sdmmc3, pll_p, 48000000, 0},
-	{sdmmc4, pll_p, 48000000, 0},
-	{spi, pll_p, 20000000, 0},
-	{sbc1, pll_p, 100000000, 0},
-	{sbc2, pll_p, 100000000, 0},
-	{sbc3, pll_p, 100000000, 0},
-	{sbc4, pll_p, 100000000, 0},
-	{host1x, pll_c, 150000000, 0},
-	{disp1, pll_p, 600000000, 0},
-	{disp2, pll_p, 600000000, 0},
-	{gr2d, pll_c, 300000000, 0},
-	{gr3d, pll_c, 300000000, 0},
-	{clk_max, clk_max, 0, 0}, /* This MUST be the last entry */
+	{TEGRA20_CLK_PLL_P, TEGRA20_CLK_CLK_MAX, 216000000, 1},
+	{TEGRA20_CLK_PLL_P_OUT1, TEGRA20_CLK_CLK_MAX, 28800000, 1},
+	{TEGRA20_CLK_PLL_P_OUT2, TEGRA20_CLK_CLK_MAX, 48000000, 1},
+	{TEGRA20_CLK_PLL_P_OUT3, TEGRA20_CLK_CLK_MAX, 72000000, 1},
+	{TEGRA20_CLK_PLL_P_OUT4, TEGRA20_CLK_CLK_MAX, 24000000, 1},
+	{TEGRA20_CLK_PLL_C, TEGRA20_CLK_CLK_MAX, 600000000, 1},
+	{TEGRA20_CLK_PLL_C_OUT1, TEGRA20_CLK_CLK_MAX, 120000000, 1},
+	{TEGRA20_CLK_SCLK, TEGRA20_CLK_PLL_C_OUT1, 0, 1},
+	{TEGRA20_CLK_HCLK, TEGRA20_CLK_CLK_MAX, 0, 1},
+	{TEGRA20_CLK_PCLK, TEGRA20_CLK_CLK_MAX, 60000000, 1},
+	{TEGRA20_CLK_CSITE, TEGRA20_CLK_CLK_MAX, 0, 1},
+	{TEGRA20_CLK_EMC, TEGRA20_CLK_CLK_MAX, 0, 1},
+	{TEGRA20_CLK_CCLK, TEGRA20_CLK_CLK_MAX, 0, 1},
+	{TEGRA20_CLK_UARTA, TEGRA20_CLK_PLL_P, 0, 0},
+	{TEGRA20_CLK_UARTB, TEGRA20_CLK_PLL_P, 0, 0},
+	{TEGRA20_CLK_UARTC, TEGRA20_CLK_PLL_P, 0, 0},
+	{TEGRA20_CLK_UARTD, TEGRA20_CLK_PLL_P, 0, 0},
+	{TEGRA20_CLK_UARTE, TEGRA20_CLK_PLL_P, 0, 0},
+	{TEGRA20_CLK_PLL_A, TEGRA20_CLK_CLK_MAX, 56448000, 1},
+	{TEGRA20_CLK_PLL_A_OUT0, TEGRA20_CLK_CLK_MAX, 11289600, 1},
+	{TEGRA20_CLK_CDEV1, TEGRA20_CLK_CLK_MAX, 0, 1},
+	{TEGRA20_CLK_BLINK, TEGRA20_CLK_CLK_MAX, 32768, 1},
+	{TEGRA20_CLK_I2S1, TEGRA20_CLK_PLL_A_OUT0, 11289600, 0},
+	{TEGRA20_CLK_I2S2, TEGRA20_CLK_PLL_A_OUT0, 11289600, 0},
+	{TEGRA20_CLK_SDMMC1, TEGRA20_CLK_PLL_P, 48000000, 0},
+	{TEGRA20_CLK_SDMMC3, TEGRA20_CLK_PLL_P, 48000000, 0},
+	{TEGRA20_CLK_SDMMC4, TEGRA20_CLK_PLL_P, 48000000, 0},
+	{TEGRA20_CLK_SPI, TEGRA20_CLK_PLL_P, 20000000, 0},
+	{TEGRA20_CLK_SBC1, TEGRA20_CLK_PLL_P, 100000000, 0},
+	{TEGRA20_CLK_SBC2, TEGRA20_CLK_PLL_P, 100000000, 0},
+	{TEGRA20_CLK_SBC3, TEGRA20_CLK_PLL_P, 100000000, 0},
+	{TEGRA20_CLK_SBC4, TEGRA20_CLK_PLL_P, 100000000, 0},
+	{TEGRA20_CLK_HOST1X, TEGRA20_CLK_PLL_C, 150000000, 0},
+	{TEGRA20_CLK_DISP1, TEGRA20_CLK_PLL_P, 600000000, 0},
+	{TEGRA20_CLK_DISP2, TEGRA20_CLK_PLL_P, 600000000, 0},
+	{TEGRA20_CLK_GR2D, TEGRA20_CLK_PLL_C, 300000000, 0},
+	{TEGRA20_CLK_GR3D, TEGRA20_CLK_PLL_C, 300000000, 0},
+	{TEGRA20_CLK_CLK_MAX, TEGRA20_CLK_CLK_MAX, 0, 0}, /* This MUST be the last entry */
 };
 
 static void __init tegra20_clock_apply_init_table(void)
 {
-	tegra_init_from_table(init_table, clks, clk_max);
+	tegra_init_from_table(init_table, clks, TEGRA20_CLK_CLK_MAX);
 }
 
 /*
@@ -1221,11 +1203,11 @@ static void __init tegra20_clock_apply_init_table(void)
  * table under two names.
  */
 static struct tegra_clk_duplicate tegra_clk_duplicates[] = {
-	TEGRA_CLK_DUPLICATE(usbd,   "utmip-pad",    NULL),
-	TEGRA_CLK_DUPLICATE(usbd,   "tegra-ehci.0", NULL),
-	TEGRA_CLK_DUPLICATE(usbd,   "tegra-otg",    NULL),
-	TEGRA_CLK_DUPLICATE(cclk,   NULL,           "cpu"),
-	TEGRA_CLK_DUPLICATE(clk_max, NULL, NULL), /* Must be the last entry */
+	TEGRA_CLK_DUPLICATE(TEGRA20_CLK_USBD,   "utmip-pad",    NULL),
+	TEGRA_CLK_DUPLICATE(TEGRA20_CLK_USBD,   "tegra-ehci.0", NULL),
+	TEGRA_CLK_DUPLICATE(TEGRA20_CLK_USBD,   "tegra-otg",    NULL),
+	TEGRA_CLK_DUPLICATE(TEGRA20_CLK_CCLK,   NULL,           "cpu"),
+	TEGRA_CLK_DUPLICATE(TEGRA20_CLK_CLK_MAX, NULL, NULL), /* Must be the last entry */
 };
 
 static const struct of_device_id pmc_match[] __initconst = {
@@ -1255,7 +1237,7 @@ static void __init tegra20_clock_init(struct device_node *np)
 		BUG();
 	}
 
-	clks = tegra_clk_init(clk_max, 3);
+	clks = tegra_clk_init(TEGRA20_CLK_CLK_MAX, 3);
 	if (!clks)
 		return;
 
@@ -1267,7 +1249,7 @@ static void __init tegra20_clock_init(struct device_node *np)
 	tegra20_periph_clk_init();
 	tegra20_audio_clk_init();
 
-	tegra_init_dup_clks(tegra_clk_duplicates, clks, clk_max);
+	tegra_init_dup_clks(tegra_clk_duplicates, clks, TEGRA20_CLK_CLK_MAX);
 
 	tegra_add_of_provider(np);
 
-- 
1.7.7.rc0.72.g4b5ea.dirty

