Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbaHDODK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:03:10 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:35432 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbaHDODH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:03:07 -0400
From: Humberto Silva Naves <hsnaves@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Humberto Silva Naves <hsnaves@gmail.com>
Subject: [PATCH 2/2] clk: samsung: Make pll initialization structures read-only.
Date: Mon,  4 Aug 2014 16:02:48 +0200
Message-Id: <1407160968-12108-3-git-send-email-hsnaves@gmail.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1407160968-12108-1-git-send-email-hsnaves@gmail.com>
References: <1407160968-12108-1-git-send-email-hsnaves@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the structures and tables related to the PLL clock
initialization that were previously as __initdata are now marked
as __initconst.

Signed-off-by: Humberto Silva Naves <hsnaves@gmail.com>
---
 drivers/clk/samsung/clk-exynos3250.c |  6 +++---
 drivers/clk/samsung/clk-exynos4.c    | 16 ++++++++--------
 drivers/clk/samsung/clk-exynos5250.c |  8 ++++----
 drivers/clk/samsung/clk-exynos5260.c | 14 +++++++-------
 drivers/clk/samsung/clk-exynos5410.c |  2 +-
 drivers/clk/samsung/clk-exynos5420.c |  4 ++--
 drivers/clk/samsung/clk-s3c2410.c    |  8 ++++----
 drivers/clk/samsung/clk-s3c2412.c    |  2 +-
 drivers/clk/samsung/clk-s3c2443.c    |  4 ++--
 drivers/clk/samsung/clk-s3c64xx.c    |  2 +-
 10 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos3250.c b/drivers/clk/samsung/clk-exynos3250.c
index ede6742..691b79b 100644
--- a/drivers/clk/samsung/clk-exynos3250.c
+++ b/drivers/clk/samsung/clk-exynos3250.c
@@ -703,7 +703,7 @@ static struct samsung_gate_clock gate_clks[] __initdata = {
 };
 
 /* APLL & MPLL & BPLL & UPLL */
-static struct samsung_pll_rate_table exynos3250_pll_rates[] = {
+static const struct samsung_pll_rate_table exynos3250_pll_rates[] __initconst = {
 	PLL_35XX_RATE(1200000000, 24000000, 400, 4, 1),
 	PLL_35XX_RATE(1100000000, 24000000, 275, 3, 1),
 	PLL_35XX_RATE(1066000000, 24000000, 533, 6, 1),
@@ -725,7 +725,7 @@ static struct samsung_pll_rate_table exynos3250_pll_rates[] = {
 };
 
 /* VPLL */
-static struct samsung_pll_rate_table exynos3250_vpll_rates[] = {
+static const struct samsung_pll_rate_table exynos3250_vpll_rates[] __initconst = {
 	PLL_36XX_RATE(600000000, 24000000, 100, 2, 1,     0),
 	PLL_36XX_RATE(533000000, 24000000, 266, 3, 2, 32768),
 	PLL_36XX_RATE(519230987, 24000000, 173, 2, 2,  5046),
@@ -755,7 +755,7 @@ static struct samsung_pll_rate_table exynos3250_vpll_rates[] = {
 	{ /* sentinel */ }
 };
 
-static struct samsung_pll_clock exynos3250_plls[nr_plls] __initdata = {
+static const struct samsung_pll_clock exynos3250_plls[nr_plls] __initconst = {
 	[apll] = PLL(pll_35xx, CLK_FOUT_APLL, "fout_apll", "fin_pll",
 			APLL_LOCK, APLL_CON0, exynos3250_pll_rates),
 	[mpll] = PLL(pll_35xx, CLK_FOUT_MPLL, "fout_mpll", "fin_pll",
diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index ab690c8..f214a35 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -1261,7 +1261,7 @@ static const struct of_device_id ext_clk_match[] __initconst = {
 };
 
 /* PLLs PMS values */
-static struct samsung_pll_rate_table exynos4210_apll_rates[] __initdata = {
+static const struct samsung_pll_rate_table exynos4210_apll_rates[] __initconst = {
 	PLL_45XX_RATE(1200000000, 24000000, 150,  3, 1, 28),
 	PLL_45XX_RATE(1000000000, 24000000, 250,  6, 1, 28),
 	PLL_45XX_RATE( 800000000, 24000000, 200,  6, 1, 28),
@@ -1274,7 +1274,7 @@ static struct samsung_pll_rate_table exynos4210_apll_rates[] __initdata = {
 	{ /* sentinel */ }
 };
 
-static struct samsung_pll_rate_table exynos4210_epll_rates[] __initdata = {
+static const struct samsung_pll_rate_table exynos4210_epll_rates[] __initconst = {
 	PLL_4600_RATE(192000000, 24000000, 48, 3, 1,     0, 0),
 	PLL_4600_RATE(180633605, 24000000, 45, 3, 1, 10381, 0),
 	PLL_4600_RATE(180000000, 24000000, 45, 3, 1,     0, 0),
@@ -1285,7 +1285,7 @@ static struct samsung_pll_rate_table exynos4210_epll_rates[] __initdata = {
 	{ /* sentinel */ }
 };
 
-static struct samsung_pll_rate_table exynos4210_vpll_rates[] __initdata = {
+static const struct samsung_pll_rate_table exynos4210_vpll_rates[] __initconst = {
 	PLL_4650_RATE(360000000, 24000000, 44, 3, 0, 1024, 0, 14, 0),
 	PLL_4650_RATE(324000000, 24000000, 53, 2, 1, 1024, 1,  1, 1),
 	PLL_4650_RATE(259617187, 24000000, 63, 3, 1, 1950, 0, 20, 1),
@@ -1294,7 +1294,7 @@ static struct samsung_pll_rate_table exynos4210_vpll_rates[] __initdata = {
 	{ /* sentinel */ }
 };
 
-static struct samsung_pll_rate_table exynos4x12_apll_rates[] __initdata = {
+static const struct samsung_pll_rate_table exynos4x12_apll_rates[] __initconst = {
 	PLL_35XX_RATE(1500000000, 24000000, 250, 4, 0),
 	PLL_35XX_RATE(1400000000, 24000000, 175, 3, 0),
 	PLL_35XX_RATE(1300000000, 24000000, 325, 6, 0),
@@ -1312,7 +1312,7 @@ static struct samsung_pll_rate_table exynos4x12_apll_rates[] __initdata = {
 	{ /* sentinel */ }
 };
 
-static struct samsung_pll_rate_table exynos4x12_epll_rates[] __initdata = {
+static const struct samsung_pll_rate_table exynos4x12_epll_rates[] __initconst = {
 	PLL_36XX_RATE(192000000, 24000000, 48, 3, 1,     0),
 	PLL_36XX_RATE(180633605, 24000000, 45, 3, 1, 10381),
 	PLL_36XX_RATE(180000000, 24000000, 45, 3, 1,     0),
@@ -1323,7 +1323,7 @@ static struct samsung_pll_rate_table exynos4x12_epll_rates[] __initdata = {
 	{ /* sentinel */ }
 };
 
-static struct samsung_pll_rate_table exynos4x12_vpll_rates[] __initdata = {
+static const struct samsung_pll_rate_table exynos4x12_vpll_rates[] __initconst = {
 	PLL_36XX_RATE(533000000, 24000000, 133, 3, 1, 16384),
 	PLL_36XX_RATE(440000000, 24000000, 110, 3, 1,     0),
 	PLL_36XX_RATE(350000000, 24000000, 175, 3, 2,     0),
@@ -1334,7 +1334,7 @@ static struct samsung_pll_rate_table exynos4x12_vpll_rates[] __initdata = {
 	{ /* sentinel */ }
 };
 
-static struct samsung_pll_clock exynos4210_plls[nr_plls] __initdata = {
+static const struct samsung_pll_clock exynos4210_plls[nr_plls] __initconst = {
 	[apll] = PLL_A(pll_4508, CLK_FOUT_APLL, "fout_apll", "fin_pll",
 		APLL_LOCK, APLL_CON0, "fout_apll", exynos4210_apll_rates),
 	[mpll] = PLL_A(pll_4508, CLK_FOUT_MPLL, "fout_mpll", "fin_pll",
@@ -1345,7 +1345,7 @@ static struct samsung_pll_clock exynos4210_plls[nr_plls] __initdata = {
 		VPLL_LOCK, VPLL_CON0, "fout_vpll", exynos4210_vpll_rates),
 };
 
-static struct samsung_pll_clock exynos4x12_plls[nr_plls] __initdata = {
+static const struct samsung_pll_clock exynos4x12_plls[nr_plls] __initconst = {
 	[apll] = PLL(pll_35xx, CLK_FOUT_APLL, "fout_apll", "fin_pll",
 			APLL_LOCK, APLL_CON0, exynos4x12_apll_rates),
 	[mpll] = PLL(pll_35xx, CLK_FOUT_MPLL, "fout_mpll", "fin_pll",
diff --git a/drivers/clk/samsung/clk-exynos5250.c b/drivers/clk/samsung/clk-exynos5250.c
index af3a660..d152fc9 100644
--- a/drivers/clk/samsung/clk-exynos5250.c
+++ b/drivers/clk/samsung/clk-exynos5250.c
@@ -687,7 +687,7 @@ static struct samsung_gate_clock exynos5250_gate_clks[] __initdata = {
 			GATE_IP_ISP1, 7, 0, 0),
 };
 
-static struct samsung_pll_rate_table vpll_24mhz_tbl[] __initdata = {
+static const struct samsung_pll_rate_table vpll_24mhz_tbl[] __initconst = {
 	/* PLL_36XX_RATE(rate, m, p, s, k) */
 	PLL_36XX_RATE(266000000, 24000000, 266, 3, 3, 0),
 	/* Not in UM, but need for eDP on snow */
@@ -695,7 +695,7 @@ static struct samsung_pll_rate_table vpll_24mhz_tbl[] __initdata = {
 	{ },
 };
 
-static struct samsung_pll_rate_table epll_24mhz_tbl[] __initdata = {
+static const struct samsung_pll_rate_table epll_24mhz_tbl[] __initconst = {
 	/* PLL_36XX_RATE(rate, m, p, s, k) */
 	PLL_36XX_RATE(192000000, 24000000,  64, 2, 2,     0),
 	PLL_36XX_RATE(180633600, 24000000,  90, 3, 2, 20762),
@@ -708,7 +708,7 @@ static struct samsung_pll_rate_table epll_24mhz_tbl[] __initdata = {
 	{ },
 };
 
-static struct samsung_pll_rate_table apll_24mhz_tbl[] __initdata = {
+static const struct samsung_pll_rate_table apll_24mhz_tbl[] __initconst = {
 	/* PLL_35XX_RATE(rate, m, p, s) */
 	PLL_35XX_RATE(1700000000, 24000000, 425, 6, 0),
 	PLL_35XX_RATE(1600000000, 24000000, 200, 3, 0),
@@ -729,7 +729,7 @@ static struct samsung_pll_rate_table apll_24mhz_tbl[] __initdata = {
 	{ },
 };
 
-static struct samsung_pll_clock exynos5250_plls[nr_plls] __initdata = {
+static const struct samsung_pll_clock exynos5250_plls[nr_plls] __initconst = {
 	[apll] = PLL_A(pll_35xx, CLK_FOUT_APLL, "fout_apll", "fin_pll",
 		APLL_LOCK, APLL_CON0, "fout_apll", apll_24mhz_tbl),
 	[mpll] = PLL_A(pll_35xx, CLK_FOUT_MPLL, "fout_mpll", "fin_pll",
diff --git a/drivers/clk/samsung/clk-exynos5260.c b/drivers/clk/samsung/clk-exynos5260.c
index 0a9016a..624912a 100644
--- a/drivers/clk/samsung/clk-exynos5260.c
+++ b/drivers/clk/samsung/clk-exynos5260.c
@@ -59,7 +59,7 @@ struct exynos5260_cmu_info {
  * Applicable for all 2550 Type PLLS for Exynos5260, listed below
  * DISP_PLL, EGL_PLL, KFC_PLL, MEM_PLL, BUS_PLL, MEDIA_PLL, G3D_PLL.
  */
-static struct samsung_pll_rate_table pll2550_24mhz_tbl[] __initdata = {
+static const struct samsung_pll_rate_table pll2550_24mhz_tbl[] __initconst = {
 	PLL_35XX_RATE(1700000000, 24000000, 425,  6, 0),
 	PLL_35XX_RATE(1600000000, 24000000, 200,  3, 0),
 	PLL_35XX_RATE(1500000000, 24000000, 250,  4, 0),
@@ -92,7 +92,7 @@ static struct samsung_pll_rate_table pll2550_24mhz_tbl[] __initdata = {
 /*
  * Applicable for 2650 Type PLL for AUD_PLL.
  */
-static struct samsung_pll_rate_table pll2650_24mhz_tbl[] __initdata = {
+static const struct samsung_pll_rate_table pll2650_24mhz_tbl[] __initconst = {
 	PLL_36XX_RATE(1600000000, 24000000, 200, 3, 0, 0),
 	PLL_36XX_RATE(1200000000, 24000000, 100, 2, 0, 0),
 	PLL_36XX_RATE(1000000000, 24000000, 250, 3, 1, 0),
@@ -514,7 +514,7 @@ struct samsung_div_clock egl_div_clks[] __initdata = {
 	DIV(EGL_DOUT_EGL_PLL, "dout_egl_pll", "mout_egl_b", DIV_EGL, 24, 3),
 };
 
-static struct samsung_pll_clock egl_pll_clks[] __initdata = {
+static const struct samsung_pll_clock egl_pll_clks[] __initconst = {
 	PLL(pll_2550xx, EGL_FOUT_EGL_PLL, "fout_egl_pll", "fin_pll",
 		EGL_PLL_LOCK, EGL_PLL_CON0,
 		pll2550_24mhz_tbl),
@@ -766,7 +766,7 @@ struct samsung_gate_clock g3d_gate_clks[] __initdata = {
 			EN_IP_G3D, 3, 0, 0),
 };
 
-static struct samsung_pll_clock g3d_pll_clks[] __initdata = {
+static const struct samsung_pll_clock g3d_pll_clks[] __initconst = {
 	PLL(pll_2550, G3D_FOUT_G3D_PLL, "fout_g3d_pll", "fin_pll",
 		G3D_PLL_LOCK, G3D_PLL_CON0,
 		pll2550_24mhz_tbl),
@@ -1084,7 +1084,7 @@ struct samsung_div_clock kfc_div_clks[] __initdata = {
 	DIV(KFC_DOUT_KFC_PLL, "dout_kfc_pll", "mout_kfc", DIV_KFC, 24, 3),
 };
 
-static struct samsung_pll_clock kfc_pll_clks[] __initdata = {
+static const struct samsung_pll_clock kfc_pll_clks[] __initconst = {
 	PLL(pll_2550xx, KFC_FOUT_KFC_PLL, "fout_kfc_pll", "fin_pll",
 		KFC_PLL_LOCK, KFC_PLL_CON0,
 		pll2550_24mhz_tbl),
@@ -1281,7 +1281,7 @@ struct samsung_gate_clock mif_gate_clks[] __initdata = {
 			CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0),
 };
 
-static struct samsung_pll_clock mif_pll_clks[] __initdata = {
+static const struct samsung_pll_clock mif_pll_clks[] __initconst = {
 	PLL(pll_2550xx, MIF_FOUT_MEM_PLL, "fout_mem_pll", "fin_pll",
 		MEM_PLL_LOCK, MEM_PLL_CON0,
 		pll2550_24mhz_tbl),
@@ -1948,7 +1948,7 @@ struct samsung_gate_clock top_gate_clks[] __initdata = {
 			CLK_SET_RATE_PARENT, 0),
 };
 
-static struct samsung_pll_clock top_pll_clks[] __initdata = {
+static const struct samsung_pll_clock top_pll_clks[] __initconst = {
 	PLL(pll_2550xx, TOP_FOUT_DISP_PLL, "fout_disp_pll", "fin_pll",
 		DISP_PLL_LOCK, DISP_PLL_CON0,
 		pll2550_24mhz_tbl),
diff --git a/drivers/clk/samsung/clk-exynos5410.c b/drivers/clk/samsung/clk-exynos5410.c
index 231475b..bfa5434 100644
--- a/drivers/clk/samsung/clk-exynos5410.c
+++ b/drivers/clk/samsung/clk-exynos5410.c
@@ -169,7 +169,7 @@ static struct samsung_gate_clock exynos5410_gate_clks[] __initdata = {
 			SRC_MASK_PERIC0, 8, CLK_SET_RATE_PARENT, 0),
 };
 
-static struct samsung_pll_clock exynos5410_plls[nr_plls] __initdata = {
+static const struct samsung_pll_clock exynos5410_plls[nr_plls] __initconst = {
 	[apll] = PLL(pll_35xx, CLK_FOUT_APLL, "fout_apll", "fin_pll", APLL_LOCK,
 		APLL_CON0, NULL),
 	[cpll] = PLL(pll_35xx, CLK_FOUT_CPLL, "fout_cpll", "fin_pll", CPLL_LOCK,
diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk-exynos5420.c
index 87e9c11..911c748 100644
--- a/drivers/clk/samsung/clk-exynos5420.c
+++ b/drivers/clk/samsung/clk-exynos5420.c
@@ -1196,7 +1196,7 @@ static struct samsung_gate_clock exynos5x_gate_clks[] __initdata = {
 	GATE(CLK_G3D, "g3d", "mout_user_aclk_g3d", GATE_IP_G3D, 9, 0, 0),
 };
 
-static const struct samsung_pll_rate_table exynos5420_pll2550x_24mhz_tbl[] = {
+static const const struct samsung_pll_rate_table exynos5420_pll2550x_24mhz_tbl[] __initconst = {
 	PLL_35XX_RATE(2000000000, 24000000, 250, 3, 0),
 	PLL_35XX_RATE(1900000000, 24000000, 475, 6, 0),
 	PLL_35XX_RATE(1800000000, 24000000, 225, 3, 0),
@@ -1219,7 +1219,7 @@ static const struct samsung_pll_rate_table exynos5420_pll2550x_24mhz_tbl[] = {
 	{ },
 };
 
-static struct samsung_pll_clock exynos5x_plls[nr_plls] __initdata = {
+static const struct samsung_pll_clock exynos5x_plls[nr_plls] __initconst = {
 	[apll] = PLL(pll_2550, CLK_FOUT_APLL, "fout_apll", "fin_pll", APLL_LOCK,
 		APLL_CON0, exynos5420_pll2550x_24mhz_tbl),
 	[cpll] = PLL(pll_2550, CLK_FOUT_CPLL, "fout_cpll", "fin_pll", CPLL_LOCK,
diff --git a/drivers/clk/samsung/clk-s3c2410.c b/drivers/clk/samsung/clk-s3c2410.c
index 4cff9a1..1c31896 100644
--- a/drivers/clk/samsung/clk-s3c2410.c
+++ b/drivers/clk/samsung/clk-s3c2410.c
@@ -161,7 +161,7 @@ struct samsung_clock_alias s3c2410_common_aliases[] __initdata = {
 
 /* S3C2410 specific clocks */
 
-static struct samsung_pll_rate_table pll_s3c2410_12mhz_tbl[] __initdata = {
+static const struct samsung_pll_rate_table pll_s3c2410_12mhz_tbl[] __initconst = {
 	/* 2410A extras */
 	PLL_35XX_RATE(270000000, 12000000, 127, 1, 1),
 	PLL_35XX_RATE(268000000, 12000000, 126, 1, 1),
@@ -194,7 +194,7 @@ static struct samsung_pll_rate_table pll_s3c2410_12mhz_tbl[] __initdata = {
 	{ /* sentinel */ },
 };
 
-static struct samsung_pll_clock s3c2410_plls[] __initdata = {
+static const struct samsung_pll_clock s3c2410_plls[] __initconst = {
 	[mpll] = PLL(pll_s3c2410_mpll, MPLL, "mpll", "xti",
 			LOCKTIME, MPLLCON, pll_s3c2410_12mhz_tbl),
 	[upll] = PLL(pll_s3c2410_upll, UPLL, "upll", "xti",
@@ -228,7 +228,7 @@ struct samsung_clock_alias s3c2410_aliases[] __initdata = {
 
 /* S3C244x specific clocks */
 
-static struct samsung_pll_rate_table pll_s3c244x_12mhz_tbl[] __initdata = {
+static const struct samsung_pll_rate_table pll_s3c244x_12mhz_tbl[] __initconst = {
 	PLL_35XX_RATE(400000000, 12000000, 0x5c, 1, 1),
 	PLL_35XX_RATE(390000000, 12000000, 0x7a, 2, 1),
 	PLL_35XX_RATE(380000000, 12000000, 0x57, 1, 1),
@@ -259,7 +259,7 @@ static struct samsung_pll_rate_table pll_s3c244x_12mhz_tbl[] __initdata = {
 	{ /* sentinel */ },
 };
 
-static struct samsung_pll_clock s3c244x_common_plls[] __initdata = {
+static const struct samsung_pll_clock s3c244x_common_plls[] __initconst = {
 	[mpll] = PLL(pll_s3c2440_mpll, MPLL, "mpll", "xti",
 			LOCKTIME, MPLLCON, pll_s3c244x_12mhz_tbl),
 	[upll] = PLL(pll_s3c2410_upll, UPLL, "upll", "xti",
diff --git a/drivers/clk/samsung/clk-s3c2412.c b/drivers/clk/samsung/clk-s3c2412.c
index 34af09f..5f3f782 100644
--- a/drivers/clk/samsung/clk-s3c2412.c
+++ b/drivers/clk/samsung/clk-s3c2412.c
@@ -143,7 +143,7 @@ struct samsung_mux_clock s3c2412_muxes[] __initdata = {
 	MUX(ARMCLK, "armclk", armclk_p, CLKDIVN, 4, 1),
 };
 
-static struct samsung_pll_clock s3c2412_plls[] __initdata = {
+static const struct samsung_pll_clock s3c2412_plls[] __initconst = {
 	[mpll] = PLL(pll_s3c2440_mpll, MPLL, "mpll", "xti",
 						LOCKTIME, MPLLCON, NULL),
 	[upll] = PLL(pll_s3c2410_upll, UPLL, "upll", "urefclk",
diff --git a/drivers/clk/samsung/clk-s3c2443.c b/drivers/clk/samsung/clk-s3c2443.c
index c92f853..513c757 100644
--- a/drivers/clk/samsung/clk-s3c2443.c
+++ b/drivers/clk/samsung/clk-s3c2443.c
@@ -220,7 +220,7 @@ struct samsung_clock_alias s3c2443_common_aliases[] __initdata = {
 
 /* S3C2416 specific clocks */
 
-static struct samsung_pll_clock s3c2416_pll_clks[] __initdata = {
+static const struct samsung_pll_clock s3c2416_pll_clks[] __initconst = {
 	[mpll] = PLL(pll_6552_s3c2416, 0, "mpll", "mpllref",
 						LOCKCON0, MPLLCON, NULL),
 	[epll] = PLL(pll_6553, 0, "epll", "epllref",
@@ -274,7 +274,7 @@ struct samsung_clock_alias s3c2416_aliases[] __initdata = {
 
 /* S3C2443 specific clocks */
 
-static struct samsung_pll_clock s3c2443_pll_clks[] __initdata = {
+static const struct samsung_pll_clock s3c2443_pll_clks[] __initconst = {
 	[mpll] = PLL(pll_3000, 0, "mpll", "mpllref",
 						LOCKCON0, MPLLCON, NULL),
 	[epll] = PLL(pll_2126, 0, "epll", "epllref",
diff --git a/drivers/clk/samsung/clk-s3c64xx.c b/drivers/clk/samsung/clk-s3c64xx.c
index 0f590e5..f25fdfa 100644
--- a/drivers/clk/samsung/clk-s3c64xx.c
+++ b/drivers/clk/samsung/clk-s3c64xx.c
@@ -364,7 +364,7 @@ GATE_CLOCKS(s3c6410_gate_clks) __initdata = {
 };
 
 /* List of PLL clocks. */
-static struct samsung_pll_clock s3c64xx_pll_clks[] __initdata = {
+static const struct samsung_pll_clock s3c64xx_pll_clks[] __initconst = {
 	[apll] = PLL(pll_6552, FOUT_APLL, "fout_apll", "fin_pll",
 						APLL_LOCK, APLL_CON, NULL),
 	[mpll] = PLL(pll_6552, FOUT_MPLL, "fout_mpll", "fin_pll",
-- 
2.0.1

