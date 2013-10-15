Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529Ab3JOO5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:57:42 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:16850 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab3JOO5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:57:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 15 Oct 2013 07:57:37 -0700
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
Subject: [PATCH v3 14/19] clk: tegra30: replace enum by binding header
Date: Tue, 15 Oct 2013 17:52:59 +0300
Message-ID: <1381848794-11761-15-git-send-email-pdeschrijver@nvidia.com>
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
 drivers/clk/tegra/clk-tegra30.c |  434 ++++++++++++++++++---------------------
 1 files changed, 203 insertions(+), 231 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index 4157fbf..046df9a 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -23,7 +23,7 @@
 #include <linux/of_address.h>
 #include <linux/clk/tegra.h>
 #include <linux/tegra-powergate.h>
-
+#include <dt-bindings/clock/tegra30-car.h>
 #include "clk.h"
 
 #define OSC_CTRL			0x50
@@ -283,34 +283,6 @@ static DEFINE_SPINLOCK(sysrate_lock);
 			_clk_num, _gate_flags,	\
 			_clk_id)
 
-/*
- * IDs assigned here must be in sync with DT bindings definition
- * for Tegra30 clocks.
- */
-enum tegra30_clk {
-	cpu, rtc = 4, timer, uarta, gpio = 8, sdmmc2, i2s1 = 11, i2c1, ndflash,
-	sdmmc1, sdmmc4, pwm = 17, i2s2, epp, gr2d = 21, usbd, isp, gr3d,
-	disp2 = 26, disp1, host1x, vcp, i2s0, cop_cache, mc, ahbdma, apbdma,
-	kbc = 36, statmon, pmc, kfuse = 40, sbc1, nor, sbc2 = 44, sbc3 = 46,
-	i2c5, dsia, mipi = 50, hdmi, csi, tvdac, i2c2, uartc, emc = 57, usb2,
-	usb3, mpe, vde, bsea, bsev, speedo, uartd, uarte, i2c3, sbc4, sdmmc3,
-	pcie, owr, afi, csite, pciex, avpucq, la, dtv = 79, ndspeed, i2cslow,
-	dsib, irama = 84, iramb, iramc, iramd, cram2, audio_2x = 90, csus = 92,
-	cdev2, cdev1, cpu_g = 96, cpu_lp, gr3d2, mselect, tsensor, i2s3, i2s4,
-	i2c4, sbc5, sbc6, d_audio, apbif, dam0, dam1, dam2, hda2codec_2x,
-	atomics, audio0_2x, audio1_2x, audio2_2x, audio3_2x, audio4_2x,
-	spdif_2x, actmon, extern1, extern2, extern3, sata_oob, sata, hda,
-	se = 127, hda2hdmi, sata_cold, uartb = 160, vfir, spdif_in, spdif_out,
-	vi, vi_sensor, fuse, fuse_burn, cve, tvo, clk_32k, clk_m, clk_m_div2,
-	clk_m_div4, pll_ref, pll_c, pll_c_out1, pll_m, pll_m_out1, pll_p,
-	pll_p_out1, pll_p_out2, pll_p_out3, pll_p_out4, pll_a, pll_a_out0,
-	pll_d, pll_d_out0, pll_d2, pll_d2_out0, pll_u, pll_x, pll_x_out0, pll_e,
-	spdif_in_sync, i2s0_sync, i2s1_sync, i2s2_sync, i2s3_sync, i2s4_sync,
-	vimclk_sync, audio0, audio1, audio2, audio3, audio4, spdif, clk_out_1,
-	clk_out_2, clk_out_3, sclk, blink, cclk_g, cclk_lp, twd, cml0, cml1,
-	hclk, pclk, clk_out_1_mux = 300, clk_max
-};
-
 static struct clk **clks;
 
 /*
@@ -807,7 +779,7 @@ static void __init tegra30_pll_init(void)
 	clk = tegra_clk_register_pll("pll_c", "pll_ref", clk_base, pmc_base, 0,
 				&pll_c_params, NULL);
 	clk_register_clkdev(clk, "pll_c", NULL);
-	clks[pll_c] = clk;
+	clks[TEGRA30_CLK_PLL_C] = clk;
 
 	/* PLLC_OUT1 */
 	clk = tegra_clk_register_divider("pll_c_out1_div", "pll_c",
@@ -817,13 +789,13 @@ static void __init tegra30_pll_init(void)
 				clk_base + PLLC_OUT, 1, 0, CLK_SET_RATE_PARENT,
 				0, NULL);
 	clk_register_clkdev(clk, "pll_c_out1", NULL);
-	clks[pll_c_out1] = clk;
+	clks[TEGRA30_CLK_PLL_C_OUT1] = clk;
 
 	/* PLLP */
 	clk = tegra_clk_register_pll("pll_p", "pll_ref", clk_base, pmc_base, 0,
 				&pll_p_params, NULL);
 	clk_register_clkdev(clk, "pll_p", NULL);
-	clks[pll_p] = clk;
+	clks[TEGRA30_CLK_PLL_P] = clk;
 
 	/* PLLP_OUT1 */
 	clk = tegra_clk_register_divider("pll_p_out1_div", "pll_p",
@@ -835,7 +807,7 @@ static void __init tegra30_pll_init(void)
 				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
 				&pll_div_lock);
 	clk_register_clkdev(clk, "pll_p_out1", NULL);
-	clks[pll_p_out1] = clk;
+	clks[TEGRA30_CLK_PLL_P_OUT1] = clk;
 
 	/* PLLP_OUT2 */
 	clk = tegra_clk_register_divider("pll_p_out2_div", "pll_p",
@@ -847,7 +819,7 @@ static void __init tegra30_pll_init(void)
 				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
 				&pll_div_lock);
 	clk_register_clkdev(clk, "pll_p_out2", NULL);
-	clks[pll_p_out2] = clk;
+	clks[TEGRA30_CLK_PLL_P_OUT2] = clk;
 
 	/* PLLP_OUT3 */
 	clk = tegra_clk_register_divider("pll_p_out3_div", "pll_p",
@@ -859,7 +831,7 @@ static void __init tegra30_pll_init(void)
 				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
 				&pll_div_lock);
 	clk_register_clkdev(clk, "pll_p_out3", NULL);
-	clks[pll_p_out3] = clk;
+	clks[TEGRA30_CLK_PLL_P_OUT3] = clk;
 
 	/* PLLP_OUT4 */
 	clk = tegra_clk_register_divider("pll_p_out4_div", "pll_p",
@@ -871,14 +843,14 @@ static void __init tegra30_pll_init(void)
 				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
 				&pll_div_lock);
 	clk_register_clkdev(clk, "pll_p_out4", NULL);
-	clks[pll_p_out4] = clk;
+	clks[TEGRA30_CLK_PLL_P_OUT4] = clk;
 
 	/* PLLM */
 	clk = tegra_clk_register_pll("pll_m", "pll_ref", clk_base, pmc_base,
 			    CLK_IGNORE_UNUSED | CLK_SET_RATE_GATE,
 			    &pll_m_params, NULL);
 	clk_register_clkdev(clk, "pll_m", NULL);
-	clks[pll_m] = clk;
+	clks[TEGRA30_CLK_PLL_M] = clk;
 
 	/* PLLM_OUT1 */
 	clk = tegra_clk_register_divider("pll_m_out1_div", "pll_m",
@@ -888,25 +860,25 @@ static void __init tegra30_pll_init(void)
 				clk_base + PLLM_OUT, 1, 0, CLK_IGNORE_UNUSED |
 				CLK_SET_RATE_PARENT, 0, NULL);
 	clk_register_clkdev(clk, "pll_m_out1", NULL);
-	clks[pll_m_out1] = clk;
+	clks[TEGRA30_CLK_PLL_M_OUT1] = clk;
 
 	/* PLLX */
 	clk = tegra_clk_register_pll("pll_x", "pll_ref", clk_base, pmc_base, 0,
 			    &pll_x_params, NULL);
 	clk_register_clkdev(clk, "pll_x", NULL);
-	clks[pll_x] = clk;
+	clks[TEGRA30_CLK_PLL_X] = clk;
 
 	/* PLLX_OUT0 */
 	clk = clk_register_fixed_factor(NULL, "pll_x_out0", "pll_x",
 					CLK_SET_RATE_PARENT, 1, 2);
 	clk_register_clkdev(clk, "pll_x_out0", NULL);
-	clks[pll_x_out0] = clk;
+	clks[TEGRA30_CLK_PLL_X_OUT0] = clk;
 
 	/* PLLU */
 	clk = tegra_clk_register_pll("pll_u", "pll_ref", clk_base, pmc_base, 0,
 			    &pll_u_params, NULL);
 	clk_register_clkdev(clk, "pll_u", NULL);
-	clks[pll_u] = clk;
+	clks[TEGRA30_CLK_PLL_U] = clk;
 
 	tegra30_utmi_param_configure();
 
@@ -914,31 +886,31 @@ static void __init tegra30_pll_init(void)
 	clk = tegra_clk_register_pll("pll_d", "pll_ref", clk_base, pmc_base, 0,
 			    &pll_d_params, &pll_d_lock);
 	clk_register_clkdev(clk, "pll_d", NULL);
-	clks[pll_d] = clk;
+	clks[TEGRA30_CLK_PLL_D] = clk;
 
 	/* PLLD_OUT0 */
 	clk = clk_register_fixed_factor(NULL, "pll_d_out0", "pll_d",
 					CLK_SET_RATE_PARENT, 1, 2);
 	clk_register_clkdev(clk, "pll_d_out0", NULL);
-	clks[pll_d_out0] = clk;
+	clks[TEGRA30_CLK_PLL_D_OUT0] = clk;
 
 	/* PLLD2 */
 	clk = tegra_clk_register_pll("pll_d2", "pll_ref", clk_base, pmc_base, 0,
 			    &pll_d2_params, NULL);
 	clk_register_clkdev(clk, "pll_d2", NULL);
-	clks[pll_d2] = clk;
+	clks[TEGRA30_CLK_PLL_D2] = clk;
 
 	/* PLLD2_OUT0 */
 	clk = clk_register_fixed_factor(NULL, "pll_d2_out0", "pll_d2",
 					CLK_SET_RATE_PARENT, 1, 2);
 	clk_register_clkdev(clk, "pll_d2_out0", NULL);
-	clks[pll_d2_out0] = clk;
+	clks[TEGRA30_CLK_PLL_D2_OUT0] = clk;
 
 	/* PLLA */
 	clk = tegra_clk_register_pll("pll_a", "pll_p_out1", clk_base, pmc_base,
 			    0, &pll_a_params, NULL);
 	clk_register_clkdev(clk, "pll_a", NULL);
-	clks[pll_a] = clk;
+	clks[TEGRA30_CLK_PLL_A] = clk;
 
 	/* PLLA_OUT0 */
 	clk = tegra_clk_register_divider("pll_a_out0_div", "pll_a",
@@ -948,7 +920,7 @@ static void __init tegra30_pll_init(void)
 				clk_base + PLLA_OUT, 1, 0, CLK_IGNORE_UNUSED |
 				CLK_SET_RATE_PARENT, 0, NULL);
 	clk_register_clkdev(clk, "pll_a_out0", NULL);
-	clks[pll_a_out0] = clk;
+	clks[TEGRA30_CLK_PLL_A_OUT0] = clk;
 
 	/* PLLE */
 	clk = clk_register_mux(NULL, "pll_e_mux", pll_e_parents,
@@ -958,7 +930,7 @@ static void __init tegra30_pll_init(void)
 	clk = tegra_clk_register_plle("pll_e", "pll_e_mux", clk_base, pmc_base,
 			     CLK_GET_RATE_NOCACHE, &pll_e_params, NULL);
 	clk_register_clkdev(clk, "pll_e", NULL);
-	clks[pll_e] = clk;
+	clks[TEGRA30_CLK_PLL_E] = clk;
 }
 
 static const char *mux_audio_sync_clk[] = { "spdif_in_sync", "i2s0_sync",
@@ -978,37 +950,37 @@ static void __init tegra30_audio_clk_init(void)
 	clk = tegra_clk_register_sync_source("spdif_in_sync", 24000000,
 					     24000000);
 	clk_register_clkdev(clk, "spdif_in_sync", NULL);
-	clks[spdif_in_sync] = clk;
+	clks[TEGRA30_CLK_SPDIF_IN_SYNC] = clk;
 
 	/* i2s0_sync */
 	clk = tegra_clk_register_sync_source("i2s0_sync", 24000000, 24000000);
 	clk_register_clkdev(clk, "i2s0_sync", NULL);
-	clks[i2s0_sync] = clk;
+	clks[TEGRA30_CLK_I2S0_SYNC] = clk;
 
 	/* i2s1_sync */
 	clk = tegra_clk_register_sync_source("i2s1_sync", 24000000, 24000000);
 	clk_register_clkdev(clk, "i2s1_sync", NULL);
-	clks[i2s1_sync] = clk;
+	clks[TEGRA30_CLK_I2S1_SYNC] = clk;
 
 	/* i2s2_sync */
 	clk = tegra_clk_register_sync_source("i2s2_sync", 24000000, 24000000);
 	clk_register_clkdev(clk, "i2s2_sync", NULL);
-	clks[i2s2_sync] = clk;
+	clks[TEGRA30_CLK_I2S2_SYNC] = clk;
 
 	/* i2s3_sync */
 	clk = tegra_clk_register_sync_source("i2s3_sync", 24000000, 24000000);
 	clk_register_clkdev(clk, "i2s3_sync", NULL);
-	clks[i2s3_sync] = clk;
+	clks[TEGRA30_CLK_I2S3_SYNC] = clk;
 
 	/* i2s4_sync */
 	clk = tegra_clk_register_sync_source("i2s4_sync", 24000000, 24000000);
 	clk_register_clkdev(clk, "i2s4_sync", NULL);
-	clks[i2s4_sync] = clk;
+	clks[TEGRA30_CLK_I2S4_SYNC] = clk;
 
 	/* vimclk_sync */
 	clk = tegra_clk_register_sync_source("vimclk_sync", 24000000, 24000000);
 	clk_register_clkdev(clk, "vimclk_sync", NULL);
-	clks[vimclk_sync] = clk;
+	clks[TEGRA30_CLK_VIMCLK_SYNC] = clk;
 
 	/* audio0 */
 	clk = clk_register_mux(NULL, "audio0_mux", mux_audio_sync_clk,
@@ -1019,7 +991,7 @@ static void __init tegra30_audio_clk_init(void)
 				clk_base + AUDIO_SYNC_CLK_I2S0, 4,
 				CLK_GATE_SET_TO_DISABLE, NULL);
 	clk_register_clkdev(clk, "audio0", NULL);
-	clks[audio0] = clk;
+	clks[TEGRA30_CLK_AUDIO0] = clk;
 
 	/* audio1 */
 	clk = clk_register_mux(NULL, "audio1_mux", mux_audio_sync_clk,
@@ -1030,7 +1002,7 @@ static void __init tegra30_audio_clk_init(void)
 				clk_base + AUDIO_SYNC_CLK_I2S1, 4,
 				CLK_GATE_SET_TO_DISABLE, NULL);
 	clk_register_clkdev(clk, "audio1", NULL);
-	clks[audio1] = clk;
+	clks[TEGRA30_CLK_AUDIO1] = clk;
 
 	/* audio2 */
 	clk = clk_register_mux(NULL, "audio2_mux", mux_audio_sync_clk,
@@ -1041,7 +1013,7 @@ static void __init tegra30_audio_clk_init(void)
 				clk_base + AUDIO_SYNC_CLK_I2S2, 4,
 				CLK_GATE_SET_TO_DISABLE, NULL);
 	clk_register_clkdev(clk, "audio2", NULL);
-	clks[audio2] = clk;
+	clks[TEGRA30_CLK_AUDIO2] = clk;
 
 	/* audio3 */
 	clk = clk_register_mux(NULL, "audio3_mux", mux_audio_sync_clk,
@@ -1052,7 +1024,7 @@ static void __init tegra30_audio_clk_init(void)
 				clk_base + AUDIO_SYNC_CLK_I2S3, 4,
 				CLK_GATE_SET_TO_DISABLE, NULL);
 	clk_register_clkdev(clk, "audio3", NULL);
-	clks[audio3] = clk;
+	clks[TEGRA30_CLK_AUDIO3] = clk;
 
 	/* audio4 */
 	clk = clk_register_mux(NULL, "audio4_mux", mux_audio_sync_clk,
@@ -1063,7 +1035,7 @@ static void __init tegra30_audio_clk_init(void)
 				clk_base + AUDIO_SYNC_CLK_I2S4, 4,
 				CLK_GATE_SET_TO_DISABLE, NULL);
 	clk_register_clkdev(clk, "audio4", NULL);
-	clks[audio4] = clk;
+	clks[TEGRA30_CLK_AUDIO4] = clk;
 
 	/* spdif */
 	clk = clk_register_mux(NULL, "spdif_mux", mux_audio_sync_clk,
@@ -1074,7 +1046,7 @@ static void __init tegra30_audio_clk_init(void)
 				clk_base + AUDIO_SYNC_CLK_SPDIF, 4,
 				CLK_GATE_SET_TO_DISABLE, NULL);
 	clk_register_clkdev(clk, "spdif", NULL);
-	clks[spdif] = clk;
+	clks[TEGRA30_CLK_SPDIF] = clk;
 
 	/* audio0_2x */
 	clk = clk_register_fixed_factor(NULL, "audio0_doubler", "audio0",
@@ -1087,7 +1059,7 @@ static void __init tegra30_audio_clk_init(void)
 				    CLK_SET_RATE_PARENT, 113,
 				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "audio0_2x", NULL);
-	clks[audio0_2x] = clk;
+	clks[TEGRA30_CLK_AUDIO0_2X] = clk;
 
 	/* audio1_2x */
 	clk = clk_register_fixed_factor(NULL, "audio1_doubler", "audio1",
@@ -1100,7 +1072,7 @@ static void __init tegra30_audio_clk_init(void)
 				    CLK_SET_RATE_PARENT, 114,
 				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "audio1_2x", NULL);
-	clks[audio1_2x] = clk;
+	clks[TEGRA30_CLK_AUDIO1_2X] = clk;
 
 	/* audio2_2x */
 	clk = clk_register_fixed_factor(NULL, "audio2_doubler", "audio2",
@@ -1113,7 +1085,7 @@ static void __init tegra30_audio_clk_init(void)
 				    CLK_SET_RATE_PARENT, 115,
 				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "audio2_2x", NULL);
-	clks[audio2_2x] = clk;
+	clks[TEGRA30_CLK_AUDIO2_2X] = clk;
 
 	/* audio3_2x */
 	clk = clk_register_fixed_factor(NULL, "audio3_doubler", "audio3",
@@ -1126,7 +1098,7 @@ static void __init tegra30_audio_clk_init(void)
 				    CLK_SET_RATE_PARENT, 116,
 				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "audio3_2x", NULL);
-	clks[audio3_2x] = clk;
+	clks[TEGRA30_CLK_AUDIO3_2X] = clk;
 
 	/* audio4_2x */
 	clk = clk_register_fixed_factor(NULL, "audio4_doubler", "audio4",
@@ -1139,7 +1111,7 @@ static void __init tegra30_audio_clk_init(void)
 				    CLK_SET_RATE_PARENT, 117,
 				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "audio4_2x", NULL);
-	clks[audio4_2x] = clk;
+	clks[TEGRA30_CLK_AUDIO4_2X] = clk;
 
 	/* spdif_2x */
 	clk = clk_register_fixed_factor(NULL, "spdif_doubler", "spdif",
@@ -1152,7 +1124,7 @@ static void __init tegra30_audio_clk_init(void)
 				    CLK_SET_RATE_PARENT, 118,
 				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "spdif_2x", NULL);
-	clks[spdif_2x] = clk;
+	clks[TEGRA30_CLK_SPDIF_2X] = clk;
 }
 
 static void __init tegra30_pmc_clk_init(void)
@@ -1165,12 +1137,12 @@ static void __init tegra30_pmc_clk_init(void)
 			       CLK_SET_RATE_NO_REPARENT,
 			       pmc_base + PMC_CLK_OUT_CNTRL, 6, 3, 0,
 			       &clk_out_lock);
-	clks[clk_out_1_mux] = clk;
+	clks[TEGRA30_CLK_CLK_OUT_1_MUX] = clk;
 	clk = clk_register_gate(NULL, "clk_out_1", "clk_out_1_mux", 0,
 				pmc_base + PMC_CLK_OUT_CNTRL, 2, 0,
 				&clk_out_lock);
 	clk_register_clkdev(clk, "extern1", "clk_out_1");
-	clks[clk_out_1] = clk;
+	clks[TEGRA30_CLK_CLK_OUT_1] = clk;
 
 	/* clk_out_2 */
 	clk = clk_register_mux(NULL, "clk_out_2_mux", clk_out2_parents,
@@ -1182,7 +1154,7 @@ static void __init tegra30_pmc_clk_init(void)
 				pmc_base + PMC_CLK_OUT_CNTRL, 10, 0,
 				&clk_out_lock);
 	clk_register_clkdev(clk, "extern2", "clk_out_2");
-	clks[clk_out_2] = clk;
+	clks[TEGRA30_CLK_CLK_OUT_2] = clk;
 
 	/* clk_out_3 */
 	clk = clk_register_mux(NULL, "clk_out_3_mux", clk_out3_parents,
@@ -1194,7 +1166,7 @@ static void __init tegra30_pmc_clk_init(void)
 				pmc_base + PMC_CLK_OUT_CNTRL, 18, 0,
 				&clk_out_lock);
 	clk_register_clkdev(clk, "extern3", "clk_out_3");
-	clks[clk_out_3] = clk;
+	clks[TEGRA30_CLK_CLK_OUT_3] = clk;
 
 	/* blink */
 	writel_relaxed(0, pmc_base + PMC_BLINK_TIMER);
@@ -1205,7 +1177,7 @@ static void __init tegra30_pmc_clk_init(void)
 				pmc_base + PMC_CTRL,
 				PMC_CTRL_BLINK_ENB, 0, NULL);
 	clk_register_clkdev(clk, "blink", NULL);
-	clks[blink] = clk;
+	clks[TEGRA30_CLK_BLINK] = clk;
 
 }
 
@@ -1258,7 +1230,7 @@ static void __init tegra30_super_clk_init(void)
 				  clk_base + CCLKG_BURST_POLICY,
 				  0, 4, 0, 0, NULL);
 	clk_register_clkdev(clk, "cclk_g", NULL);
-	clks[cclk_g] = clk;
+	clks[TEGRA30_CLK_CCLK_G] = clk;
 
 	/*
 	 * Clock input to cclk_lp divided from pll_p using
@@ -1295,7 +1267,7 @@ static void __init tegra30_super_clk_init(void)
 				  TEGRA_DIVIDER_2, 4, 8, 9,
 			      NULL);
 	clk_register_clkdev(clk, "cclk_lp", NULL);
-	clks[cclk_lp] = clk;
+	clks[TEGRA30_CLK_CCLK_LP] = clk;
 
 	/* SCLK */
 	clk = tegra_clk_register_super_mux("sclk", sclk_parents,
@@ -1304,7 +1276,7 @@ static void __init tegra30_super_clk_init(void)
 				  clk_base + SCLK_BURST_POLICY,
 				  0, 4, 0, 0, NULL);
 	clk_register_clkdev(clk, "sclk", NULL);
-	clks[sclk] = clk;
+	clks[TEGRA30_CLK_SCLK] = clk;
 
 	/* HCLK */
 	clk = clk_register_divider(NULL, "hclk_div", "sclk", 0,
@@ -1314,7 +1286,7 @@ static void __init tegra30_super_clk_init(void)
 				clk_base + SYSTEM_CLK_RATE, 7,
 				CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
 	clk_register_clkdev(clk, "hclk", NULL);
-	clks[hclk] = clk;
+	clks[TEGRA30_CLK_HCLK] = clk;
 
 	/* PCLK */
 	clk = clk_register_divider(NULL, "pclk_div", "hclk", 0,
@@ -1324,13 +1296,13 @@ static void __init tegra30_super_clk_init(void)
 				clk_base + SYSTEM_CLK_RATE, 3,
 				CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
 	clk_register_clkdev(clk, "pclk", NULL);
-	clks[pclk] = clk;
+	clks[TEGRA30_CLK_PCLK] = clk;
 
 	/* twd */
 	clk = clk_register_fixed_factor(NULL, "twd", "cclk_g",
 					CLK_SET_RATE_PARENT, 1, 2);
 	clk_register_clkdev(clk, "twd", NULL);
-	clks[twd] = clk;
+	clks[TEGRA30_CLK_TWD] = clk;
 }
 
 static const char *mux_pllacp_clkm[] = { "pll_a_out0", "unused", "pll_p",
@@ -1368,77 +1340,77 @@ static const char *mux_plld_out0_plld2_out0[] = { "pll_d_out0",
 						  "pll_d2_out0" };
 
 static struct tegra_periph_init_data tegra_periph_clk_list[] = {
-	TEGRA_INIT_DATA_MUX("i2s0",	NULL,		"tegra30-i2s.0",	i2s0_parents,		CLK_SOURCE_I2S0,	30,	TEGRA_PERIPH_ON_APB, i2s0),
-	TEGRA_INIT_DATA_MUX("i2s1",	NULL,		"tegra30-i2s.1",	i2s1_parents,		CLK_SOURCE_I2S1,	11,	TEGRA_PERIPH_ON_APB, i2s1),
-	TEGRA_INIT_DATA_MUX("i2s2",	NULL,		"tegra30-i2s.2",	i2s2_parents,		CLK_SOURCE_I2S2,	18,	TEGRA_PERIPH_ON_APB, i2s2),
-	TEGRA_INIT_DATA_MUX("i2s3",	NULL,		"tegra30-i2s.3",	i2s3_parents,		CLK_SOURCE_I2S3,	101,	TEGRA_PERIPH_ON_APB, i2s3),
-	TEGRA_INIT_DATA_MUX("i2s4",	NULL,		"tegra30-i2s.4",	i2s4_parents,		CLK_SOURCE_I2S4,	102,	TEGRA_PERIPH_ON_APB, i2s4),
-	TEGRA_INIT_DATA_MUX("spdif_out", "spdif_out",	"tegra30-spdif",	spdif_out_parents,	CLK_SOURCE_SPDIF_OUT,	10,	TEGRA_PERIPH_ON_APB, spdif_out),
-	TEGRA_INIT_DATA_MUX("spdif_in",	"spdif_in",	"tegra30-spdif",	spdif_in_parents,	CLK_SOURCE_SPDIF_IN,	10,	TEGRA_PERIPH_ON_APB, spdif_in),
-	TEGRA_INIT_DATA_MUX("d_audio",	"d_audio",	"tegra30-ahub",		mux_pllacp_clkm,	CLK_SOURCE_D_AUDIO,	106,	0, d_audio),
-	TEGRA_INIT_DATA_MUX("dam0",	NULL,		"tegra30-dam.0",	mux_pllacp_clkm,	CLK_SOURCE_DAM0,	108,	0, dam0),
-	TEGRA_INIT_DATA_MUX("dam1",	NULL,		"tegra30-dam.1",	mux_pllacp_clkm,	CLK_SOURCE_DAM1,	109,	0, dam1),
-	TEGRA_INIT_DATA_MUX("dam2",	NULL,		"tegra30-dam.2",	mux_pllacp_clkm,	CLK_SOURCE_DAM2,	110,	0, dam2),
-	TEGRA_INIT_DATA_MUX("hda",	"hda",		"tegra30-hda",		mux_pllpcm_clkm,	CLK_SOURCE_HDA,		125,	0, hda),
-	TEGRA_INIT_DATA_MUX("hda2codec_2x", "hda2codec", "tegra30-hda",		mux_pllpcm_clkm,	CLK_SOURCE_HDA2CODEC_2X, 111,	0, hda2codec_2x),
-	TEGRA_INIT_DATA_MUX("sbc1",	NULL,		"spi_tegra.0",		mux_pllpcm_clkm,	CLK_SOURCE_SBC1,	41,	TEGRA_PERIPH_ON_APB, sbc1),
-	TEGRA_INIT_DATA_MUX("sbc2",	NULL,		"spi_tegra.1",		mux_pllpcm_clkm,	CLK_SOURCE_SBC2,	44,	TEGRA_PERIPH_ON_APB, sbc2),
-	TEGRA_INIT_DATA_MUX("sbc3",	NULL,		"spi_tegra.2",		mux_pllpcm_clkm,	CLK_SOURCE_SBC3,	46,	TEGRA_PERIPH_ON_APB, sbc3),
-	TEGRA_INIT_DATA_MUX("sbc4",	NULL,		"spi_tegra.3",		mux_pllpcm_clkm,	CLK_SOURCE_SBC4,	68,	TEGRA_PERIPH_ON_APB, sbc4),
-	TEGRA_INIT_DATA_MUX("sbc5",	NULL,		"spi_tegra.4",		mux_pllpcm_clkm,	CLK_SOURCE_SBC5,	104,	TEGRA_PERIPH_ON_APB, sbc5),
-	TEGRA_INIT_DATA_MUX("sbc6",	NULL,		"spi_tegra.5",		mux_pllpcm_clkm,	CLK_SOURCE_SBC6,	105,	TEGRA_PERIPH_ON_APB, sbc6),
-	TEGRA_INIT_DATA_MUX("sata_oob",	NULL,		"tegra_sata_oob",	mux_pllpcm_clkm,	CLK_SOURCE_SATA_OOB,	123,	TEGRA_PERIPH_ON_APB, sata_oob),
-	TEGRA_INIT_DATA_MUX("sata",	NULL,		"tegra_sata",		mux_pllpcm_clkm,	CLK_SOURCE_SATA,	124,	TEGRA_PERIPH_ON_APB, sata),
-	TEGRA_INIT_DATA_MUX("ndflash",	NULL,		"tegra_nand",		mux_pllpcm_clkm,	CLK_SOURCE_NDFLASH,	13,	TEGRA_PERIPH_ON_APB, ndflash),
-	TEGRA_INIT_DATA_MUX("ndspeed",	NULL,		"tegra_nand_speed",	mux_pllpcm_clkm,	CLK_SOURCE_NDSPEED,	80,	TEGRA_PERIPH_ON_APB, ndspeed),
-	TEGRA_INIT_DATA_MUX("vfir",	NULL,		"vfir",			mux_pllpcm_clkm,	CLK_SOURCE_VFIR,	7,	TEGRA_PERIPH_ON_APB, vfir),
-	TEGRA_INIT_DATA_MUX("csite",	NULL,		"csite",		mux_pllpcm_clkm,	CLK_SOURCE_CSITE,	73,	TEGRA_PERIPH_ON_APB, csite),
-	TEGRA_INIT_DATA_MUX("la",	NULL,		"la",			mux_pllpcm_clkm,	CLK_SOURCE_LA,		76,	TEGRA_PERIPH_ON_APB, la),
-	TEGRA_INIT_DATA_MUX("owr",	NULL,		"tegra_w1",		mux_pllpcm_clkm,	CLK_SOURCE_OWR,		71,	TEGRA_PERIPH_ON_APB, owr),
-	TEGRA_INIT_DATA_MUX("mipi",	NULL,		"mipi",			mux_pllpcm_clkm,	CLK_SOURCE_MIPI,	50,	TEGRA_PERIPH_ON_APB, mipi),
-	TEGRA_INIT_DATA_MUX("tsensor",	NULL,		"tegra-tsensor",	mux_pllpc_clkm_clk32k,	CLK_SOURCE_TSENSOR,	100,	TEGRA_PERIPH_ON_APB, tsensor),
-	TEGRA_INIT_DATA_MUX("i2cslow",	NULL,		"i2cslow",		mux_pllpc_clk32k_clkm,	CLK_SOURCE_I2CSLOW,	81,	TEGRA_PERIPH_ON_APB, i2cslow),
-	TEGRA_INIT_DATA_INT("vde",	NULL,		"vde",			mux_pllpcm_clkm,	CLK_SOURCE_VDE,		61,	0, vde),
-	TEGRA_INIT_DATA_INT("vi",	"vi",		"tegra_camera",		mux_pllmcpa,		CLK_SOURCE_VI,		20,	0, vi),
-	TEGRA_INIT_DATA_INT("epp",	NULL,		"epp",			mux_pllmcpa,		CLK_SOURCE_EPP,		19,	0, epp),
-	TEGRA_INIT_DATA_INT("mpe",	NULL,		"mpe",			mux_pllmcpa,		CLK_SOURCE_MPE,		60,	0, mpe),
-	TEGRA_INIT_DATA_INT("host1x",	NULL,		"host1x",		mux_pllmcpa,		CLK_SOURCE_HOST1X,	28,	0, host1x),
-	TEGRA_INIT_DATA_INT("3d",	NULL,		"3d",			mux_pllmcpa,		CLK_SOURCE_3D,		24,	TEGRA_PERIPH_MANUAL_RESET, gr3d),
-	TEGRA_INIT_DATA_INT("3d2",	NULL,		"3d2",			mux_pllmcpa,		CLK_SOURCE_3D2,		98,	TEGRA_PERIPH_MANUAL_RESET, gr3d2),
-	TEGRA_INIT_DATA_INT("2d",	NULL,		"2d",			mux_pllmcpa,		CLK_SOURCE_2D,		21,	0, gr2d),
-	TEGRA_INIT_DATA_INT("se",	NULL,		"se",			mux_pllpcm_clkm,	CLK_SOURCE_SE,		127,	0, se),
-	TEGRA_INIT_DATA_MUX("mselect",	NULL,		"mselect",		mux_pllp_clkm,		CLK_SOURCE_MSELECT,	99,	0, mselect),
-	TEGRA_INIT_DATA_MUX("nor",	NULL,		"tegra-nor",		mux_pllpcm_clkm,	CLK_SOURCE_NOR,		42,	0, nor),
-	TEGRA_INIT_DATA_MUX("sdmmc1",	NULL,		"sdhci-tegra.0",	mux_pllpcm_clkm,	CLK_SOURCE_SDMMC1,	14,	0, sdmmc1),
-	TEGRA_INIT_DATA_MUX("sdmmc2",	NULL,		"sdhci-tegra.1",	mux_pllpcm_clkm,	CLK_SOURCE_SDMMC2,	9,	0, sdmmc2),
-	TEGRA_INIT_DATA_MUX("sdmmc3",	NULL,		"sdhci-tegra.2",	mux_pllpcm_clkm,	CLK_SOURCE_SDMMC3,	69,	0, sdmmc3),
-	TEGRA_INIT_DATA_MUX("sdmmc4",	NULL,		"sdhci-tegra.3",	mux_pllpcm_clkm,	CLK_SOURCE_SDMMC4,	15,	0, sdmmc4),
-	TEGRA_INIT_DATA_MUX("cve",	NULL,		"cve",			mux_pllpdc_clkm,	CLK_SOURCE_CVE,		49,	0, cve),
-	TEGRA_INIT_DATA_MUX("tvo",	NULL,		"tvo",			mux_pllpdc_clkm,	CLK_SOURCE_TVO,		49,	0, tvo),
-	TEGRA_INIT_DATA_MUX("tvdac",	NULL,		"tvdac",		mux_pllpdc_clkm,	CLK_SOURCE_TVDAC,	53,	0, tvdac),
-	TEGRA_INIT_DATA_MUX("actmon",	NULL,		"actmon",		mux_pllpc_clk32k_clkm,	CLK_SOURCE_ACTMON,	119,	0, actmon),
-	TEGRA_INIT_DATA_MUX("vi_sensor", "vi_sensor",	"tegra_camera",		mux_pllmcpa,		CLK_SOURCE_VI_SENSOR,	20,	TEGRA_PERIPH_NO_RESET, vi_sensor),
-	TEGRA_INIT_DATA_DIV16("i2c1",	"div-clk",	"tegra-i2c.0",		mux_pllp_clkm,		CLK_SOURCE_I2C1,	12,	TEGRA_PERIPH_ON_APB, i2c1),
-	TEGRA_INIT_DATA_DIV16("i2c2",	"div-clk",	"tegra-i2c.1",		mux_pllp_clkm,		CLK_SOURCE_I2C2,	54,	TEGRA_PERIPH_ON_APB, i2c2),
-	TEGRA_INIT_DATA_DIV16("i2c3",	"div-clk",	"tegra-i2c.2",		mux_pllp_clkm,		CLK_SOURCE_I2C3,	67,	TEGRA_PERIPH_ON_APB, i2c3),
-	TEGRA_INIT_DATA_DIV16("i2c4",	"div-clk",	"tegra-i2c.3",		mux_pllp_clkm,		CLK_SOURCE_I2C4,	103,	TEGRA_PERIPH_ON_APB, i2c4),
-	TEGRA_INIT_DATA_DIV16("i2c5",	"div-clk",	"tegra-i2c.4",		mux_pllp_clkm,		CLK_SOURCE_I2C5,	47,	TEGRA_PERIPH_ON_APB, i2c5),
-	TEGRA_INIT_DATA_UART("uarta",	NULL,		"tegra_uart.0",		mux_pllpcm_clkm,	CLK_SOURCE_UARTA,	6,	uarta),
-	TEGRA_INIT_DATA_UART("uartb",	NULL,		"tegra_uart.1",		mux_pllpcm_clkm,	CLK_SOURCE_UARTB,	7,	uartb),
-	TEGRA_INIT_DATA_UART("uartc",	NULL,		"tegra_uart.2",		mux_pllpcm_clkm,	CLK_SOURCE_UARTC,	55,	uartc),
-	TEGRA_INIT_DATA_UART("uartd",	NULL,		"tegra_uart.3",		mux_pllpcm_clkm,	CLK_SOURCE_UARTD,	65,	uartd),
-	TEGRA_INIT_DATA_UART("uarte",	NULL,		"tegra_uart.4",		mux_pllpcm_clkm,	CLK_SOURCE_UARTE,	66,	uarte),
-	TEGRA_INIT_DATA_MUX8("hdmi",	NULL,		"hdmi",			mux_pllpmdacd2_clkm,	CLK_SOURCE_HDMI,	51,	0, hdmi),
-	TEGRA_INIT_DATA_MUX8("extern1",	NULL,		"extern1",		mux_plla_clk32k_pllp_clkm_plle,	CLK_SOURCE_EXTERN1,	120,	0, extern1),
-	TEGRA_INIT_DATA_MUX8("extern2",	NULL,		"extern2",		mux_plla_clk32k_pllp_clkm_plle,	CLK_SOURCE_EXTERN2,	121,	0, extern2),
-	TEGRA_INIT_DATA_MUX8("extern3",	NULL,		"extern3",		mux_plla_clk32k_pllp_clkm_plle,	CLK_SOURCE_EXTERN3,	122,	0, extern3),
-	TEGRA_INIT_DATA("pwm",		NULL,		"pwm",			mux_pllpc_clk32k_clkm,	CLK_SOURCE_PWM,		28, 2, 0, 0, 8, 1, 0, 17, 0, pwm),
+	TEGRA_INIT_DATA_MUX("i2s0",	NULL,		"tegra30-i2s.0",	i2s0_parents,		CLK_SOURCE_I2S0,	30,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2S0),
+	TEGRA_INIT_DATA_MUX("i2s1",	NULL,		"tegra30-i2s.1",	i2s1_parents,		CLK_SOURCE_I2S1,	11,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2S1),
+	TEGRA_INIT_DATA_MUX("i2s2",	NULL,		"tegra30-i2s.2",	i2s2_parents,		CLK_SOURCE_I2S2,	18,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2S2),
+	TEGRA_INIT_DATA_MUX("i2s3",	NULL,		"tegra30-i2s.3",	i2s3_parents,		CLK_SOURCE_I2S3,	101,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2S3),
+	TEGRA_INIT_DATA_MUX("i2s4",	NULL,		"tegra30-i2s.4",	i2s4_parents,		CLK_SOURCE_I2S4,	102,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2S4),
+	TEGRA_INIT_DATA_MUX("spdif_out", "spdif_out",	"tegra30-spdif",	spdif_out_parents,	CLK_SOURCE_SPDIF_OUT,	10,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SPDIF_OUT),
+	TEGRA_INIT_DATA_MUX("spdif_in",	"spdif_in",	"tegra30-spdif",	spdif_in_parents,	CLK_SOURCE_SPDIF_IN,	10,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SPDIF_IN),
+	TEGRA_INIT_DATA_MUX("d_audio",	"d_audio",	"tegra30-ahub",		mux_pllacp_clkm,	CLK_SOURCE_D_AUDIO,	106,	0, TEGRA30_CLK_D_AUDIO),
+	TEGRA_INIT_DATA_MUX("dam0",	NULL,		"tegra30-dam.0",	mux_pllacp_clkm,	CLK_SOURCE_DAM0,	108,	0, TEGRA30_CLK_DAM0),
+	TEGRA_INIT_DATA_MUX("dam1",	NULL,		"tegra30-dam.1",	mux_pllacp_clkm,	CLK_SOURCE_DAM1,	109,	0, TEGRA30_CLK_DAM1),
+	TEGRA_INIT_DATA_MUX("dam2",	NULL,		"tegra30-dam.2",	mux_pllacp_clkm,	CLK_SOURCE_DAM2,	110,	0, TEGRA30_CLK_DAM2),
+	TEGRA_INIT_DATA_MUX("hda",	"hda",		"tegra30-hda",		mux_pllpcm_clkm,	CLK_SOURCE_HDA,		125,	0, TEGRA30_CLK_HDA),
+	TEGRA_INIT_DATA_MUX("hda2codec_2x", "hda2codec", "tegra30-hda",		mux_pllpcm_clkm,	CLK_SOURCE_HDA2CODEC_2X, 111,	0, TEGRA30_CLK_HDA2CODEC_2X),
+	TEGRA_INIT_DATA_MUX("sbc1",	NULL,		"spi_tegra.0",		mux_pllpcm_clkm,	CLK_SOURCE_SBC1,	41,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SBC1),
+	TEGRA_INIT_DATA_MUX("sbc2",	NULL,		"spi_tegra.1",		mux_pllpcm_clkm,	CLK_SOURCE_SBC2,	44,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SBC2),
+	TEGRA_INIT_DATA_MUX("sbc3",	NULL,		"spi_tegra.2",		mux_pllpcm_clkm,	CLK_SOURCE_SBC3,	46,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SBC3),
+	TEGRA_INIT_DATA_MUX("sbc4",	NULL,		"spi_tegra.3",		mux_pllpcm_clkm,	CLK_SOURCE_SBC4,	68,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SBC4),
+	TEGRA_INIT_DATA_MUX("sbc5",	NULL,		"spi_tegra.4",		mux_pllpcm_clkm,	CLK_SOURCE_SBC5,	104,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SBC5),
+	TEGRA_INIT_DATA_MUX("sbc6",	NULL,		"spi_tegra.5",		mux_pllpcm_clkm,	CLK_SOURCE_SBC6,	105,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SBC6),
+	TEGRA_INIT_DATA_MUX("sata_oob",	NULL,		"tegra_sata_oob",	mux_pllpcm_clkm,	CLK_SOURCE_SATA_OOB,	123,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SATA_OOB),
+	TEGRA_INIT_DATA_MUX("sata",	NULL,		"tegra_sata",		mux_pllpcm_clkm,	CLK_SOURCE_SATA,	124,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SATA),
+	TEGRA_INIT_DATA_MUX("ndflash",	NULL,		"tegra_nand",		mux_pllpcm_clkm,	CLK_SOURCE_NDFLASH,	13,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_NDFLASH),
+	TEGRA_INIT_DATA_MUX("ndspeed",	NULL,		"tegra_nand_speed",	mux_pllpcm_clkm,	CLK_SOURCE_NDSPEED,	80,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_NDSPEED),
+	TEGRA_INIT_DATA_MUX("vfir",	NULL,		"vfir",			mux_pllpcm_clkm,	CLK_SOURCE_VFIR,	7,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_VFIR),
+	TEGRA_INIT_DATA_MUX("csite",	NULL,		"csite",		mux_pllpcm_clkm,	CLK_SOURCE_CSITE,	73,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_CSITE),
+	TEGRA_INIT_DATA_MUX("la",	NULL,		"la",			mux_pllpcm_clkm,	CLK_SOURCE_LA,		76,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_LA),
+	TEGRA_INIT_DATA_MUX("owr",	NULL,		"tegra_w1",		mux_pllpcm_clkm,	CLK_SOURCE_OWR,		71,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_OWR),
+	TEGRA_INIT_DATA_MUX("mipi",	NULL,		"mipi",			mux_pllpcm_clkm,	CLK_SOURCE_MIPI,	50,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_MIPI),
+	TEGRA_INIT_DATA_MUX("tsensor",	NULL,		"tegra-tsensor",	mux_pllpc_clkm_clk32k,	CLK_SOURCE_TSENSOR,	100,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_TSENSOR),
+	TEGRA_INIT_DATA_MUX("i2cslow",	NULL,		"i2cslow",		mux_pllpc_clk32k_clkm,	CLK_SOURCE_I2CSLOW,	81,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2CSLOW),
+	TEGRA_INIT_DATA_INT("vde",	NULL,		"vde",			mux_pllpcm_clkm,	CLK_SOURCE_VDE,		61,	0, TEGRA30_CLK_VDE),
+	TEGRA_INIT_DATA_INT("vi",	"vi",		"tegra_camera",		mux_pllmcpa,		CLK_SOURCE_VI,		20,	0, TEGRA30_CLK_VI),
+	TEGRA_INIT_DATA_INT("epp",	NULL,		"epp",			mux_pllmcpa,		CLK_SOURCE_EPP,		19,	0, TEGRA30_CLK_EPP),
+	TEGRA_INIT_DATA_INT("mpe",	NULL,		"mpe",			mux_pllmcpa,		CLK_SOURCE_MPE,		60,	0, TEGRA30_CLK_MPE),
+	TEGRA_INIT_DATA_INT("host1x",	NULL,		"host1x",		mux_pllmcpa,		CLK_SOURCE_HOST1X,	28,	0, TEGRA30_CLK_HOST1X),
+	TEGRA_INIT_DATA_INT("3d",	NULL,		"3d",			mux_pllmcpa,		CLK_SOURCE_3D,		24,	TEGRA_PERIPH_MANUAL_RESET, TEGRA30_CLK_GR3D),
+	TEGRA_INIT_DATA_INT("3d2",	NULL,		"3d2",			mux_pllmcpa,		CLK_SOURCE_3D2,		98,	TEGRA_PERIPH_MANUAL_RESET, TEGRA30_CLK_GR3D2),
+	TEGRA_INIT_DATA_INT("2d",	NULL,		"2d",			mux_pllmcpa,		CLK_SOURCE_2D,		21,	0, TEGRA30_CLK_GR2D),
+	TEGRA_INIT_DATA_INT("se",	NULL,		"se",			mux_pllpcm_clkm,	CLK_SOURCE_SE,		127,	0, TEGRA30_CLK_SE),
+	TEGRA_INIT_DATA_MUX("mselect",	NULL,		"mselect",		mux_pllp_clkm,		CLK_SOURCE_MSELECT,	99,	0, TEGRA30_CLK_MSELECT),
+	TEGRA_INIT_DATA_MUX("nor",	NULL,		"tegra-nor",		mux_pllpcm_clkm,	CLK_SOURCE_NOR,		42,	0, TEGRA30_CLK_NOR),
+	TEGRA_INIT_DATA_MUX("sdmmc1",	NULL,		"sdhci-tegra.0",	mux_pllpcm_clkm,	CLK_SOURCE_SDMMC1,	14,	0, TEGRA30_CLK_SDMMC1),
+	TEGRA_INIT_DATA_MUX("sdmmc2",	NULL,		"sdhci-tegra.1",	mux_pllpcm_clkm,	CLK_SOURCE_SDMMC2,	9,	0, TEGRA30_CLK_SDMMC2),
+	TEGRA_INIT_DATA_MUX("sdmmc3",	NULL,		"sdhci-tegra.2",	mux_pllpcm_clkm,	CLK_SOURCE_SDMMC3,	69,	0, TEGRA30_CLK_SDMMC3),
+	TEGRA_INIT_DATA_MUX("sdmmc4",	NULL,		"sdhci-tegra.3",	mux_pllpcm_clkm,	CLK_SOURCE_SDMMC4,	15,	0, TEGRA30_CLK_SDMMC4),
+	TEGRA_INIT_DATA_MUX("cve",	NULL,		"cve",			mux_pllpdc_clkm,	CLK_SOURCE_CVE,		49,	0, TEGRA30_CLK_CVE),
+	TEGRA_INIT_DATA_MUX("tvo",	NULL,		"tvo",			mux_pllpdc_clkm,	CLK_SOURCE_TVO,		49,	0, TEGRA30_CLK_TVO),
+	TEGRA_INIT_DATA_MUX("tvdac",	NULL,		"tvdac",		mux_pllpdc_clkm,	CLK_SOURCE_TVDAC,	53,	0, TEGRA30_CLK_TVDAC),
+	TEGRA_INIT_DATA_MUX("actmon",	NULL,		"actmon",		mux_pllpc_clk32k_clkm,	CLK_SOURCE_ACTMON,	119,	0, TEGRA30_CLK_ACTMON),
+	TEGRA_INIT_DATA_MUX("vi_sensor", "vi_sensor",	"tegra_camera",		mux_pllmcpa,		CLK_SOURCE_VI_SENSOR,	20,	TEGRA_PERIPH_NO_RESET, TEGRA30_CLK_VI_SENSOR),
+	TEGRA_INIT_DATA_DIV16("i2c1",	"div-clk",	"tegra-i2c.0",		mux_pllp_clkm,		CLK_SOURCE_I2C1,	12,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2C1),
+	TEGRA_INIT_DATA_DIV16("i2c2",	"div-clk",	"tegra-i2c.1",		mux_pllp_clkm,		CLK_SOURCE_I2C2,	54,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2C2),
+	TEGRA_INIT_DATA_DIV16("i2c3",	"div-clk",	"tegra-i2c.2",		mux_pllp_clkm,		CLK_SOURCE_I2C3,	67,		TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2C3),
+	TEGRA_INIT_DATA_DIV16("i2c4",	"div-clk",	"tegra-i2c.3",		mux_pllp_clkm,		CLK_SOURCE_I2C4,	103,		TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2C4),
+	TEGRA_INIT_DATA_DIV16("i2c5",	"div-clk",	"tegra-i2c.4",		mux_pllp_clkm,		CLK_SOURCE_I2C5,	47,		TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2C5),
+	TEGRA_INIT_DATA_UART("uarta",	NULL,		"tegra_uart.0",		mux_pllpcm_clkm,	CLK_SOURCE_UARTA,	6,	TEGRA30_CLK_UARTA),
+	TEGRA_INIT_DATA_UART("uartb",	NULL,		"tegra_uart.1",		mux_pllpcm_clkm,	CLK_SOURCE_UARTB,	7,	TEGRA30_CLK_UARTB),
+	TEGRA_INIT_DATA_UART("uartc",	NULL,		"tegra_uart.2",		mux_pllpcm_clkm,	CLK_SOURCE_UARTC,	55,	TEGRA30_CLK_UARTC),
+	TEGRA_INIT_DATA_UART("uartd",	NULL,		"tegra_uart.3",		mux_pllpcm_clkm,	CLK_SOURCE_UARTD,	65,	TEGRA30_CLK_UARTD),
+	TEGRA_INIT_DATA_UART("uarte",	NULL,		"tegra_uart.4",		mux_pllpcm_clkm,	CLK_SOURCE_UARTE,	66,	TEGRA30_CLK_UARTE),
+	TEGRA_INIT_DATA_MUX8("hdmi",	NULL,		"hdmi",			mux_pllpmdacd2_clkm,	CLK_SOURCE_HDMI,	51,		0, TEGRA30_CLK_HDMI),
+	TEGRA_INIT_DATA_MUX8("extern1",	NULL,		"extern1",		mux_plla_clk32k_pllp_clkm_plle,	CLK_SOURCE_EXTERN1,	120,		0, TEGRA30_CLK_EXTERN1),
+	TEGRA_INIT_DATA_MUX8("extern2",	NULL,		"extern2",		mux_plla_clk32k_pllp_clkm_plle,	CLK_SOURCE_EXTERN2,	121,		0, TEGRA30_CLK_EXTERN2),
+	TEGRA_INIT_DATA_MUX8("extern3",	NULL,		"extern3",		mux_plla_clk32k_pllp_clkm_plle,	CLK_SOURCE_EXTERN3,	122,		0, TEGRA30_CLK_EXTERN3),
+	TEGRA_INIT_DATA("pwm",		NULL,		"pwm",			mux_pllpc_clk32k_clkm,	CLK_SOURCE_PWM,		28, 2, 0, 0, 8, 1, 0, 17, 0, TEGRA30_CLK_PWM),
 };
 
 static struct tegra_periph_init_data tegra_periph_nodiv_clk_list[] = {
-	TEGRA_INIT_DATA_NODIV("disp1",	NULL, "tegradc.0", mux_pllpmdacd2_clkm,	     CLK_SOURCE_DISP1,	29, 3, 27, 0, disp1),
-	TEGRA_INIT_DATA_NODIV("disp2",	NULL, "tegradc.1", mux_pllpmdacd2_clkm,      CLK_SOURCE_DISP2,	29, 3, 26, 0, disp2),
-	TEGRA_INIT_DATA_NODIV("dsib",	NULL, "tegradc.1", mux_plld_out0_plld2_out0, CLK_SOURCE_DSIB,	25, 1, 82, 0, dsib),
+	TEGRA_INIT_DATA_NODIV("disp1",	NULL, "tegradc.0", mux_pllpmdacd2_clkm,	     CLK_SOURCE_DISP1,	29, 3, 27, 0, TEGRA30_CLK_DISP1),
+	TEGRA_INIT_DATA_NODIV("disp2",	NULL, "tegradc.1", mux_pllpmdacd2_clkm,      CLK_SOURCE_DISP2,	29, 3, 26, 0, TEGRA30_CLK_DISP2),
+	TEGRA_INIT_DATA_NODIV("dsib",	NULL, "tegradc.1", mux_plld_out0_plld2_out0, CLK_SOURCE_DSIB,	25, 1, 82, 0, TEGRA30_CLK_DSIB),
 };
 
 static void __init tegra30_periph_clk_init(void)
@@ -1451,154 +1423,154 @@ static void __init tegra30_periph_clk_init(void)
 	clk = tegra_clk_register_periph_gate("apbdma", "clk_m", 0, clk_base, 0, 34,
 				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "tegra-apbdma");
-	clks[apbdma] = clk;
+	clks[TEGRA30_CLK_APBDMA] = clk;
 
 	/* rtc */
 	clk = tegra_clk_register_periph_gate("rtc", "clk_32k",
 				    TEGRA_PERIPH_NO_RESET | TEGRA_PERIPH_ON_APB,
 				    clk_base, 0, 4, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "rtc-tegra");
-	clks[rtc] = clk;
+	clks[TEGRA30_CLK_RTC] = clk;
 
 	/* timer */
 	clk = tegra_clk_register_periph_gate("timer", "clk_m", 0, clk_base, 0,
 				    5, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "timer");
-	clks[timer] = clk;
+	clks[TEGRA30_CLK_TIMER] = clk;
 
 	/* kbc */
 	clk = tegra_clk_register_periph_gate("kbc", "clk_32k",
 				    TEGRA_PERIPH_NO_RESET | TEGRA_PERIPH_ON_APB,
 				    clk_base, 0, 36, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "tegra-kbc");
-	clks[kbc] = clk;
+	clks[TEGRA30_CLK_KBC] = clk;
 
 	/* csus */
 	clk = tegra_clk_register_periph_gate("csus", "clk_m",
 				    TEGRA_PERIPH_NO_RESET | TEGRA_PERIPH_ON_APB,
 				    clk_base, 0, 92, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "csus", "tengra_camera");
-	clks[csus] = clk;
+	clks[TEGRA30_CLK_CSUS] = clk;
 
 	/* vcp */
 	clk = tegra_clk_register_periph_gate("vcp", "clk_m", 0, clk_base, 0, 29,
 				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "vcp", "tegra-avp");
-	clks[vcp] = clk;
+	clks[TEGRA30_CLK_VCP] = clk;
 
 	/* bsea */
 	clk = tegra_clk_register_periph_gate("bsea", "clk_m", 0, clk_base, 0,
 				    62, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "bsea", "tegra-avp");
-	clks[bsea] = clk;
+	clks[TEGRA30_CLK_BSEA] = clk;
 
 	/* bsev */
 	clk = tegra_clk_register_periph_gate("bsev", "clk_m", 0, clk_base, 0,
 				    63, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "bsev", "tegra-aes");
-	clks[bsev] = clk;
+	clks[TEGRA30_CLK_BSEV] = clk;
 
 	/* usbd */
 	clk = tegra_clk_register_periph_gate("usbd", "clk_m", 0, clk_base, 0,
 				    22, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "fsl-tegra-udc");
-	clks[usbd] = clk;
+	clks[TEGRA30_CLK_USBD] = clk;
 
 	/* usb2 */
 	clk = tegra_clk_register_periph_gate("usb2", "clk_m", 0, clk_base, 0,
 				    58, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "tegra-ehci.1");
-	clks[usb2] = clk;
+	clks[TEGRA30_CLK_USB2] = clk;
 
 	/* usb3 */
 	clk = tegra_clk_register_periph_gate("usb3", "clk_m", 0, clk_base, 0,
 				    59, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "tegra-ehci.2");
-	clks[usb3] = clk;
+	clks[TEGRA30_CLK_USB3] = clk;
 
 	/* dsia */
 	clk = tegra_clk_register_periph_gate("dsia", "pll_d_out0", 0, clk_base,
 				    0, 48, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "dsia", "tegradc.0");
-	clks[dsia] = clk;
+	clks[TEGRA30_CLK_DSIA] = clk;
 
 	/* csi */
 	clk = tegra_clk_register_periph_gate("csi", "pll_p_out3", 0, clk_base,
 				    0, 52, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "csi", "tegra_camera");
-	clks[csi] = clk;
+	clks[TEGRA30_CLK_CSI] = clk;
 
 	/* isp */
 	clk = tegra_clk_register_periph_gate("isp", "clk_m", 0, clk_base, 0, 23,
 				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "isp", "tegra_camera");
-	clks[isp] = clk;
+	clks[TEGRA30_CLK_ISP] = clk;
 
 	/* pcie */
 	clk = tegra_clk_register_periph_gate("pcie", "clk_m", 0, clk_base, 0,
 				    70, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "pcie", "tegra-pcie");
-	clks[pcie] = clk;
+	clks[TEGRA30_CLK_PCIE] = clk;
 
 	/* afi */
 	clk = tegra_clk_register_periph_gate("afi", "clk_m", 0, clk_base, 0, 72,
 				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "afi", "tegra-pcie");
-	clks[afi] = clk;
+	clks[TEGRA30_CLK_AFI] = clk;
 
 	/* pciex */
 	clk = tegra_clk_register_periph_gate("pciex", "pll_e", 0, clk_base, 0,
 				    74, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "pciex", "tegra-pcie");
-	clks[pciex] = clk;
+	clks[TEGRA30_CLK_PCIEX] = clk;
 
 	/* kfuse */
 	clk = tegra_clk_register_periph_gate("kfuse", "clk_m",
 				    TEGRA_PERIPH_ON_APB,
 				    clk_base, 0, 40, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "kfuse-tegra");
-	clks[kfuse] = clk;
+	clks[TEGRA30_CLK_KFUSE] = clk;
 
 	/* fuse */
 	clk = tegra_clk_register_periph_gate("fuse", "clk_m",
 				    TEGRA_PERIPH_ON_APB,
 				    clk_base, 0, 39, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "fuse", "fuse-tegra");
-	clks[fuse] = clk;
+	clks[TEGRA30_CLK_FUSE] = clk;
 
 	/* fuse_burn */
 	clk = tegra_clk_register_periph_gate("fuse_burn", "clk_m",
 				    TEGRA_PERIPH_ON_APB,
 				    clk_base, 0, 39, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "fuse_burn", "fuse-tegra");
-	clks[fuse_burn] = clk;
+	clks[TEGRA30_CLK_FUSE_BURN] = clk;
 
 	/* apbif */
 	clk = tegra_clk_register_periph_gate("apbif", "clk_m", 0,
 				    clk_base, 0, 107, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "apbif", "tegra30-ahub");
-	clks[apbif] = clk;
+	clks[TEGRA30_CLK_APBIF] = clk;
 
 	/* hda2hdmi */
 	clk = tegra_clk_register_periph_gate("hda2hdmi", "clk_m",
 				    TEGRA_PERIPH_ON_APB,
 				    clk_base, 0, 128, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "hda2hdmi", "tegra30-hda");
-	clks[hda2hdmi] = clk;
+	clks[TEGRA30_CLK_HDA2HDMI] = clk;
 
 	/* sata_cold */
 	clk = tegra_clk_register_periph_gate("sata_cold", "clk_m",
 				    TEGRA_PERIPH_ON_APB,
 				    clk_base, 0, 129, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "tegra_sata_cold");
-	clks[sata_cold] = clk;
+	clks[TEGRA30_CLK_SATA_COLD] = clk;
 
 	/* dtv */
 	clk = tegra_clk_register_periph_gate("dtv", "clk_m",
 				    TEGRA_PERIPH_ON_APB,
 				    clk_base, 0, 79, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "dtv");
-	clks[dtv] = clk;
+	clks[TEGRA30_CLK_DTV] = clk;
 
 	/* emc */
 	clk = clk_register_mux(NULL, "emc_mux", mux_pllmcp_clkm,
@@ -1609,7 +1581,7 @@ static void __init tegra30_periph_clk_init(void)
 	clk = tegra_clk_register_periph_gate("emc", "emc_mux", 0, clk_base, 0,
 				    57, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "emc", NULL);
-	clks[emc] = clk;
+	clks[TEGRA30_CLK_EMC] = clk;
 
 	for (i = 0; i < ARRAY_SIZE(tegra_periph_clk_list); i++) {
 		data = &tegra_periph_clk_list[i];
@@ -1639,31 +1611,31 @@ static void __init tegra30_fixed_clk_init(void)
 	clk = clk_register_fixed_rate(NULL, "clk_32k", NULL, CLK_IS_ROOT,
 				32768);
 	clk_register_clkdev(clk, "clk_32k", NULL);
-	clks[clk_32k] = clk;
+	clks[TEGRA30_CLK_CLK_32K] = clk;
 
 	/* clk_m_div2 */
 	clk = clk_register_fixed_factor(NULL, "clk_m_div2", "clk_m",
 				CLK_SET_RATE_PARENT, 1, 2);
 	clk_register_clkdev(clk, "clk_m_div2", NULL);
-	clks[clk_m_div2] = clk;
+	clks[TEGRA30_CLK_CLK_M_DIV2] = clk;
 
 	/* clk_m_div4 */
 	clk = clk_register_fixed_factor(NULL, "clk_m_div4", "clk_m",
 				CLK_SET_RATE_PARENT, 1, 4);
 	clk_register_clkdev(clk, "clk_m_div4", NULL);
-	clks[clk_m_div4] = clk;
+	clks[TEGRA30_CLK_CLK_M_DIV4] = clk;
 
 	/* cml0 */
 	clk = clk_register_gate(NULL, "cml0", "pll_e", 0, clk_base + PLLE_AUX,
 				0, 0, &cml_lock);
 	clk_register_clkdev(clk, "cml0", NULL);
-	clks[cml0] = clk;
+	clks[TEGRA30_CLK_CML0] = clk;
 
 	/* cml1 */
 	clk = clk_register_gate(NULL, "cml1", "pll_e", 0, clk_base + PLLE_AUX,
 				1, 0, &cml_lock);
 	clk_register_clkdev(clk, "cml1", NULL);
-	clks[cml1] = clk;
+	clks[TEGRA30_CLK_CML1] = clk;
 }
 
 static void __init tegra30_osc_clk_init(void)
@@ -1677,14 +1649,14 @@ static void __init tegra30_osc_clk_init(void)
 	clk = clk_register_fixed_rate(NULL, "clk_m", NULL, CLK_IS_ROOT,
 				input_freq);
 	clk_register_clkdev(clk, "clk_m", NULL);
-	clks[clk_m] = clk;
+	clks[TEGRA30_CLK_CLK_M] = clk;
 
 	/* pll_ref */
 	pll_ref_div = tegra30_get_pll_ref_div();
 	clk = clk_register_fixed_factor(NULL, "pll_ref", "clk_m",
 				CLK_SET_RATE_PARENT, 1, pll_ref_div);
 	clk_register_clkdev(clk, "pll_ref", NULL);
-	clks[pll_ref] = clk;
+	clks[TEGRA30_CLK_PLL_REF] = clk;
 }
 
 /* Tegra30 CPU clock and reset control functions */
@@ -1826,48 +1798,48 @@ static struct tegra_cpu_car_ops tegra30_cpu_car_ops = {
 };
 
 static struct tegra_clk_init_table init_table[] __initdata = {
-	{uarta, pll_p, 408000000, 0},
-	{uartb, pll_p, 408000000, 0},
-	{uartc, pll_p, 408000000, 0},
-	{uartd, pll_p, 408000000, 0},
-	{uarte, pll_p, 408000000, 0},
-	{pll_a, clk_max, 564480000, 1},
-	{pll_a_out0, clk_max, 11289600, 1},
-	{extern1, pll_a_out0, 0, 1},
-	{clk_out_1_mux, extern1, 0, 0},
-	{clk_out_1, clk_max, 0, 1},
-	{blink, clk_max, 0, 1},
-	{i2s0, pll_a_out0, 11289600, 0},
-	{i2s1, pll_a_out0, 11289600, 0},
-	{i2s2, pll_a_out0, 11289600, 0},
-	{i2s3, pll_a_out0, 11289600, 0},
-	{i2s4, pll_a_out0, 11289600, 0},
-	{sdmmc1, pll_p, 48000000, 0},
-	{sdmmc2, pll_p, 48000000, 0},
-	{sdmmc3, pll_p, 48000000, 0},
-	{pll_m, clk_max, 0, 1},
-	{pclk, clk_max, 0, 1},
-	{csite, clk_max, 0, 1},
-	{emc, clk_max, 0, 1},
-	{mselect, clk_max, 0, 1},
-	{sbc1, pll_p, 100000000, 0},
-	{sbc2, pll_p, 100000000, 0},
-	{sbc3, pll_p, 100000000, 0},
-	{sbc4, pll_p, 100000000, 0},
-	{sbc5, pll_p, 100000000, 0},
-	{sbc6, pll_p, 100000000, 0},
-	{host1x, pll_c, 150000000, 0},
-	{disp1, pll_p, 600000000, 0},
-	{disp2, pll_p, 600000000, 0},
-	{twd, clk_max, 0, 1},
-	{gr2d, pll_c, 300000000, 0},
-	{gr3d, pll_c, 300000000, 0},
-	{clk_max, clk_max, 0, 0}, /* This MUST be the last entry. */
+	{TEGRA30_CLK_UARTA, TEGRA30_CLK_PLL_P, 408000000, 0},
+	{TEGRA30_CLK_UARTB, TEGRA30_CLK_PLL_P, 408000000, 0},
+	{TEGRA30_CLK_UARTC, TEGRA30_CLK_PLL_P, 408000000, 0},
+	{TEGRA30_CLK_UARTD, TEGRA30_CLK_PLL_P, 408000000, 0},
+	{TEGRA30_CLK_UARTE, TEGRA30_CLK_PLL_P, 408000000, 0},
+	{TEGRA30_CLK_PLL_A, TEGRA30_CLK_CLK_MAX, 564480000, 1},
+	{TEGRA30_CLK_PLL_A_OUT0, TEGRA30_CLK_CLK_MAX, 11289600, 1},
+	{TEGRA30_CLK_EXTERN1, TEGRA30_CLK_PLL_A_OUT0, 0, 1},
+	{TEGRA30_CLK_CLK_OUT_1_MUX, TEGRA30_CLK_EXTERN1, 0, 0},
+	{TEGRA30_CLK_CLK_OUT_1, TEGRA30_CLK_CLK_MAX, 0, 1},
+	{TEGRA30_CLK_BLINK, TEGRA30_CLK_CLK_MAX, 0, 1},
+	{TEGRA30_CLK_I2S0, TEGRA30_CLK_PLL_A_OUT0, 11289600, 0},
+	{TEGRA30_CLK_I2S1, TEGRA30_CLK_PLL_A_OUT0, 11289600, 0},
+	{TEGRA30_CLK_I2S2, TEGRA30_CLK_PLL_A_OUT0, 11289600, 0},
+	{TEGRA30_CLK_I2S3, TEGRA30_CLK_PLL_A_OUT0, 11289600, 0},
+	{TEGRA30_CLK_I2S4, TEGRA30_CLK_PLL_A_OUT0, 11289600, 0},
+	{TEGRA30_CLK_SDMMC1, TEGRA30_CLK_PLL_P, 48000000, 0},
+	{TEGRA30_CLK_SDMMC2, TEGRA30_CLK_PLL_P, 48000000, 0},
+	{TEGRA30_CLK_SDMMC3, TEGRA30_CLK_PLL_P, 48000000, 0},
+	{TEGRA30_CLK_PLL_M, TEGRA30_CLK_CLK_MAX, 0, 1},
+	{TEGRA30_CLK_PCLK, TEGRA30_CLK_CLK_MAX, 0, 1},
+	{TEGRA30_CLK_CSITE, TEGRA30_CLK_CLK_MAX, 0, 1},
+	{TEGRA30_CLK_EMC, TEGRA30_CLK_CLK_MAX, 0, 1},
+	{TEGRA30_CLK_MSELECT, TEGRA30_CLK_CLK_MAX, 0, 1},
+	{TEGRA30_CLK_SBC1, TEGRA30_CLK_PLL_P, 100000000, 0},
+	{TEGRA30_CLK_SBC2, TEGRA30_CLK_PLL_P, 100000000, 0},
+	{TEGRA30_CLK_SBC3, TEGRA30_CLK_PLL_P, 100000000, 0},
+	{TEGRA30_CLK_SBC4, TEGRA30_CLK_PLL_P, 100000000, 0},
+	{TEGRA30_CLK_SBC5, TEGRA30_CLK_PLL_P, 100000000, 0},
+	{TEGRA30_CLK_SBC6, TEGRA30_CLK_PLL_P, 100000000, 0},
+	{TEGRA30_CLK_HOST1X, TEGRA30_CLK_PLL_C, 150000000, 0},
+	{TEGRA30_CLK_DISP1, TEGRA30_CLK_PLL_P, 600000000, 0},
+	{TEGRA30_CLK_DISP2, TEGRA30_CLK_PLL_P, 600000000, 0},
+	{TEGRA30_CLK_TWD, TEGRA30_CLK_CLK_MAX, 0, 1},
+	{TEGRA30_CLK_GR2D, TEGRA30_CLK_PLL_C, 300000000, 0},
+	{TEGRA30_CLK_GR3D, TEGRA30_CLK_PLL_C, 300000000, 0},
+	{TEGRA30_CLK_CLK_MAX, TEGRA30_CLK_CLK_MAX, 0, 0}, /* This MUST be the last entry. */
 };
 
 static void __init tegra30_clock_apply_init_table(void)
 {
-	tegra_init_from_table(init_table, clks, clk_max);
+	tegra_init_from_table(init_table, clks, TEGRA30_CLK_CLK_MAX);
 }
 
 /*
@@ -1876,19 +1848,19 @@ static void __init tegra30_clock_apply_init_table(void)
  * table under two names.
  */
 static struct tegra_clk_duplicate tegra_clk_duplicates[] = {
-	TEGRA_CLK_DUPLICATE(usbd, "utmip-pad", NULL),
-	TEGRA_CLK_DUPLICATE(usbd, "tegra-ehci.0", NULL),
-	TEGRA_CLK_DUPLICATE(usbd, "tegra-otg", NULL),
-	TEGRA_CLK_DUPLICATE(bsev, "tegra-avp", "bsev"),
-	TEGRA_CLK_DUPLICATE(bsev, "nvavp", "bsev"),
-	TEGRA_CLK_DUPLICATE(vde, "tegra-aes", "vde"),
-	TEGRA_CLK_DUPLICATE(bsea, "tegra-aes", "bsea"),
-	TEGRA_CLK_DUPLICATE(bsea, "nvavp", "bsea"),
-	TEGRA_CLK_DUPLICATE(cml1, "tegra_sata_cml", NULL),
-	TEGRA_CLK_DUPLICATE(cml0, "tegra_pcie", "cml"),
-	TEGRA_CLK_DUPLICATE(pciex, "tegra_pcie", "pciex"),
-	TEGRA_CLK_DUPLICATE(vcp, "nvavp", "vcp"),
-	TEGRA_CLK_DUPLICATE(clk_max, NULL, NULL), /* MUST be the last entry */
+	TEGRA_CLK_DUPLICATE(TEGRA30_CLK_USBD, "utmip-pad", NULL),
+	TEGRA_CLK_DUPLICATE(TEGRA30_CLK_USBD, "tegra-ehci.0", NULL),
+	TEGRA_CLK_DUPLICATE(TEGRA30_CLK_USBD, "tegra-otg", NULL),
+	TEGRA_CLK_DUPLICATE(TEGRA30_CLK_BSEV, "tegra-avp", "bsev"),
+	TEGRA_CLK_DUPLICATE(TEGRA30_CLK_BSEV, "nvavp", "bsev"),
+	TEGRA_CLK_DUPLICATE(TEGRA30_CLK_VDE, "tegra-aes", "vde"),
+	TEGRA_CLK_DUPLICATE(TEGRA30_CLK_BSEA, "tegra-aes", "bsea"),
+	TEGRA_CLK_DUPLICATE(TEGRA30_CLK_BSEA, "nvavp", "bsea"),
+	TEGRA_CLK_DUPLICATE(TEGRA30_CLK_CML1, "tegra_sata_cml", NULL),
+	TEGRA_CLK_DUPLICATE(TEGRA30_CLK_CML0, "tegra_pcie", "cml"),
+	TEGRA_CLK_DUPLICATE(TEGRA30_CLK_PCIEX, "tegra_pcie", "pciex"),
+	TEGRA_CLK_DUPLICATE(TEGRA30_CLK_VCP, "nvavp", "vcp"),
+	TEGRA_CLK_DUPLICATE(TEGRA30_CLK_CLK_MAX, NULL, NULL), /* MUST be the last entry */
 };
 
 static const struct of_device_id pmc_match[] __initconst = {
@@ -1918,7 +1890,7 @@ static void __init tegra30_clock_init(struct device_node *np)
 		BUG();
 	}
 
-	clks = tegra_clk_init(clk_max, 5);
+	clks = tegra_clk_init(TEGRA30_CLK_CLK_MAX, 5);
 	if (!clks) {
 		WARN_ON(1);
 		return;
@@ -1932,7 +1904,7 @@ static void __init tegra30_clock_init(struct device_node *np)
 	tegra30_audio_clk_init();
 	tegra30_pmc_clk_init();
 
-	tegra_init_dup_clks(tegra_clk_duplicates, clks, clk_max);
+	tegra_init_dup_clks(tegra_clk_duplicates, clks, TEGRA30_CLK_CLK_MAX);
 
 	tegra_add_of_provider(np);
 
-- 
1.7.7.rc0.72.g4b5ea.dirty

