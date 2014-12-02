Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbaLBIuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:50:14 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:21895 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaLBIuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:50:00 -0500
X-AuditID: cbfee68e-f79b46d000002b74-a6-547d7d36e584
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, marc.zyngier@arm.com,
        arnd@arndb.de, olof@lixom.net, catalin.marinas@arm.com,
        will.deacon@arm.com, s.nawrocki@samsung.com, tomasz.figa@gmail.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, geunsik.lim@samsung.com,
        sw0312.kim@samsung.com, jh80.chung@samsung.com, cw00.choi@samsung.com,
        a.kesavan@samsung.com, pankaj.dubey@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 02/19] clk: samsung: exynos5433: Add MUX clocks of CMU_TOP
 domain
Date: Tue, 02 Dec 2014 17:49:39 +0900
Message-id: <1417510196-6714-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsWyRsSkRNestjbEYM16UYvHaxYzWfyddIzd
	4v2yHkaLy/u1La5/ec5qMf/IOVaLPxNa2Swm3Z/AYnHjVxurRe+Cq2wWZ5vesFtsenyN1eLy
	rjlsFjPO7wPqv/OPzWLp9YtMFqeuf2azWLT1C7vF4TftrBYzJr9ks1i16w+jxcuPJ1gcxDzW
	zFvD6PH71yRGj52z7rJ7bF5S73HlRBOrR9+WVYwenzfJBbBHcdmkpOZklqUW6dslcGXsblnC
	VHAzuGLqq0esDYy/3LsYOTkkBEwkGma+Y4WwxSQu3FvP1sXIxSEksJRR4u2UTWwwRcvX3YZK
	TGeU+LnsNViHkEATk8Tse0IgNpuAlsT+FzfAGkQEnCUapjYygTQwC7xhlthzfzcLSEJYIFji
	y8GFzCA2i4CqxIWGCWA2r4CLxIb+w8wQ2xQkli2fCbaAU8BVoutMHzvEMheJX60f2UGGSghM
	5ZD4N/kwI8QgAYlvkw8BLeAASshKbDoANUdS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLSK07M
	LS7NS9dLzs/dxAiMx9P/nvXtYLx5wPoQowAHoxIP74nzNSFCrIllxZW5hxhNgTZMZJYSTc4H
	Rn1eSbyhsZmRhamJqbGRuaWZkjhvgtTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2Mjs32
	d3cGXvgy7cJp2wLupEWxsbutPt7IPclTIVRf3BfcuEo1ZkvYEYetp9reuMW8YJ4spXb+Xfud
	zHPTNCw+xB0uSKzI8UherPjMstuvf3NXi8sEfdbLjByVx8/uindsvzedi1HqrZzmYscv0apJ
	3tbLzsbdfTP1Z4q2htqer58cc1J6Zh5VYinOSDTUYi4qTgQAkhekvsICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jQV2z2toQg8/bOC0er1nMZPF30jF2
	i/fLehgtLu/Xtrj+5Tmrxfwj51gt/kxoZbOYdH8Ci8WNX22sFr0LrrJZnG16w26x6fE1VovL
	u+awWcw4vw+o/84/Noul1y8yWZy6/pnNYtHWL+wWh9+0s1rMmPySzWLVrj+MFi8/nmBxEPNY
	M28No8fvX5MYPXbOusvusXlJvceVE02sHn1bVjF6fN4kF8Ae1cBok5GamJJapJCal5yfkpmX
	bqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0mpJCWWJOKVAoILG4WEnfDtOE0BA3
	XQuYxghd35AguB4jAzSQsIYxY3fLEqaCm8EVU189Ym1g/OXexcjJISFgIrF83W02CFtM4sK9
	9UA2F4eQwHRGiZ/LXrOCJIQEmpgkZt8TArHZBLQk9r+4AdYgIuAs0TC1kQmkgVngDbPEnvu7
	WUASwgLBEl8OLmQGsVkEVCUuNEwAs3kFXCQ29B9mhtimILFs+UywBZwCrhJdZ/rYIZa5SPxq
	/cg+gZF3ASPDKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgaH8mtYNxZYPFIUYBDkYlHt4T
	52tChFgTy4orcw8xSnAwK4nw/jKuDRHiTUmsrEotyo8vKs1JLT7EaAp01URmKdHkfGAiyiuJ
	NzQ2MTOyNDI3tDAyNlcS571xMzdESCA9sSQ1OzW1ILUIpo+Jg1OqgdGrh+H8HEmTJZcN7h/y
	al+UL3g4/5zH4qUWh1l/7BEy3hnHe6ChSI39yIcJzNOLFikfCWFSfhp679S3OuGgvHkLGFTy
	P/fWSf2+5iHK0F7GOcFPMT1qlvBRH86gUwddlLumda6adKdu9b6Wzd/2F5qw/f4gp+2gs//D
	y1VBZxuYE3cdfD+N86QSS3FGoqEWc1FxIgBNZUKEDAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the MUX (multiplexer) clocks for CMU_TOP domain of Exynos5433.
CMU_TOP domain provides source clocks to other CMU domains.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 drivers/clk/samsung/clk-exynos5433.c   | 90 ++++++++++++++++++++++++++++++++++
 include/dt-bindings/clock/exynos5433.h | 31 +++++++++++-
 2 files changed, 119 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos5433.c b/drivers/clk/samsung/clk-exynos5433.c
index 0877663..88e8cac 100644
--- a/drivers/clk/samsung/clk-exynos5433.c
+++ b/drivers/clk/samsung/clk-exynos5433.c
@@ -208,6 +208,7 @@ PNAME(mout_mphy_pll_user_p)	= { "fin_pll", "sclk_mphy_pll", };
 PNAME(mout_mfc_pll_user_p)	= { "fin_pll", "sclk_mfc_pll", };
 PNAME(mout_bus_pll_user_p)	= { "fin_pll", "sclk_bus_pll", };
 PNAME(mout_bus_pll_user_t_p)	= { "fin_pll", "mout_bus_pll_user", };
+PNAME(mout_mphy_pll_user_t_p)	= { "fin_pll", "mout_mphy_pll_user", };
 
 PNAME(mout_bus_mfc_pll_user_p)	= { "mout_bus_pll_user", "mout_mfc_pll_user",};
 PNAME(mout_mfc_bus_pll_user_p)	= { "mout_mfc_pll_user", "mout_bus_pll_user",};
@@ -215,6 +216,12 @@ PNAME(mout_aclk_cam1_552_b_p)	= { "mout_aclk_cam1_552_a",
 				    "mout_mfc_pll_user", };
 PNAME(mout_aclk_cam1_552_a_p)	= { "mout_isp_pll", "mout_bus_pll_user", };
 
+PNAME(mout_aclk_mfc_400_c_p)	= { "mout_aclk_mfc_400_b",
+				    "mout_mphy_pll_user", };
+PNAME(mout_aclk_mfc_400_b_p)	= { "mout_aclk_mfc_400_a",
+				    "mout_bus_pll_user", };
+PNAME(mout_aclk_mfc_400_a_p)	= { "mout_mfc_pll_user", "mout_isp_pll", };
+
 PNAME(mout_bus_mphy_pll_user_p)	= { "mout_bus_pll_user",
 				    "mout_mphy_pll_user", };
 PNAME(mout_aclk_mscl_b_p)	= { "mout_aclk_mscl_400_a",
@@ -231,11 +238,26 @@ PNAME(mout_sclk_mmc0_d_p)	= { "mout_sclk_mmc0_c", "mout_isp_pll", };
 PNAME(mout_sclk_mmc0_c_p)	= { "mout_sclk_mmc0_b", "mout_mphy_pll_user",};
 PNAME(mout_sclk_mmc0_b_p)	= { "mout_sclk_mmc0_a", "mout_mfc_pll_user", };
 
+PNAME(mout_sclk_spdif_p)	= { "sclk_audio0", "sclk_audio1",
+				    "fin_pll", "ioclk_spdif_extclk", };
+PNAME(mout_sclk_audio1_p)	= { "ioclk_audiocdclk1", "fin_pll",
+				    "mout_aud_pll_user_t",};
+PNAME(mout_sclk_audio0_p)	= { "ioclk_audiocdclk0", "fin_pll",
+				    "mout_aud_pll_user_t",};
+
 static struct samsung_fixed_factor_clock top_fixed_factor_clks[] __initdata = {
 	FFACTOR(0, "sclk_bus_pll", "fout_bus_pll", 1, 1, 0),
 	FFACTOR(0, "sclk_mfc_pll", "fout_mfc_pll", 1, 1, 0),
 };
 
+static struct samsung_fixed_rate_clock top_fixed_clks[] __initdata = {
+	/* Xi2s{0|1}CDCLK input clock for I2S/PCM */
+	FRATE(0, "ioclk_audiocdclk1", NULL, CLK_IS_ROOT, 100000000),
+	FRATE(0, "ioclk_audiocdclk0", NULL, CLK_IS_ROOT, 100000000),
+	/* Xi2s1SDI input clock for SPDIF */
+	FRATE(0, "ioclk_spdif_extclk", NULL, CLK_IS_ROOT, 100000000),
+};
+
 static struct samsung_mux_clock top_mux_clks[] __initdata = {
 	/* MUX_SEL_TOP0 */
 	MUX(CLK_MOUT_AUD_PLL, "mout_aud_pll", mout_aud_pll_p, MUX_SEL_TOP0,
@@ -281,6 +303,14 @@ static struct samsung_mux_clock top_mux_clks[] __initdata = {
 	MUX(CLK_MOUT_ACLK_G2D_400_A, "mout_aclk_g2d_400_a",
 			mout_bus_mfc_pll_user_p, MUX_SEL_TOP3, 0, 1),
 
+	/* MUX_SEL_TOP4 */
+	MUX(CLK_MOUT_ACLK_MFC_400_C, "mout_aclk_mfc_400_c",
+			mout_aclk_mfc_400_c_p, MUX_SEL_TOP4, 8, 1),
+	MUX(CLK_MOUT_ACLK_MFC_400_B, "mout_aclk_mfc_400_b",
+			mout_aclk_mfc_400_b_p, MUX_SEL_TOP4, 4, 1),
+	MUX(CLK_MOUT_ACLK_MFC_400_A, "mout_aclk_mfc_400_a",
+			mout_aclk_mfc_400_a_p, MUX_SEL_TOP4, 0, 1),
+
 	/* MUX_SEL_TOP_MSCL */
 	MUX(CLK_MOUT_SCLK_JPEG_C, "mout_sclk_jpeg_c", mout_sclk_jpeg_c_p,
 			MUX_SEL_TOP_MSCL, 8, 1),
@@ -289,6 +319,20 @@ static struct samsung_mux_clock top_mux_clks[] __initdata = {
 	MUX(CLK_MOUT_SCLK_JPEG_A, "mout_sclk_jpeg_a", mout_bus_pll_user_t_p,
 			MUX_SEL_TOP_MSCL, 0, 1),
 
+	/* MUX_SEL_TOP_CAM1 */
+	MUX(CLK_MOUT_SCLK_ISP_SENSOR2, "mout_sclk_isp_sensor2",
+			mout_bus_pll_user_t_p, MUX_SEL_TOP_CAM1, 24, 1),
+	MUX(CLK_MOUT_SCLK_ISP_SENSOR1, "mout_sclk_isp_sensor1",
+			mout_bus_pll_user_t_p, MUX_SEL_TOP_CAM1, 20, 1),
+	MUX(CLK_MOUT_SCLK_ISP_SENSOR0, "mout_sclk_isp_sensor0",
+			mout_bus_pll_user_t_p, MUX_SEL_TOP_CAM1, 16, 1),
+	MUX(CLK_MOUT_SCLK_ISP_UART, "mout_sclk_isp_uart",
+			mout_bus_pll_user_t_p, MUX_SEL_TOP_CAM1, 8, 1),
+	MUX(CLK_MOUT_SCLK_ISP_SPI1, "mout_sclk_isp_spi1",
+			mout_bus_pll_user_t_p, MUX_SEL_TOP_CAM1, 4, 1),
+	MUX(CLK_MOUT_SCLK_ISP_SPI0, "mout_sclk_isp_spi0",
+			mout_bus_pll_user_t_p, MUX_SEL_TOP_CAM1, 0, 1),
+
 	/* MUX_SEL_TOP_FSYS0 */
 	MUX(CLK_MOUT_SCLK_MMC2_B, "mout_sclk_mmc2_b", mout_sclk_mmc2_b_p,
 			MUX_SEL_TOP_FSYS0, 28, 1),
@@ -307,6 +351,16 @@ static struct samsung_mux_clock top_mux_clks[] __initdata = {
 	MUX(CLK_MOUT_SCLK_MMC0_A, "mout_sclk_mmc0_a", mout_bus_pll_user_t_p,
 			MUX_SEL_TOP_FSYS0, 0, 1),
 
+	/* MUX_SEL_TOP_FSYS1 */
+	MUX(CLK_MOUT_SCLK_PCIE_100, "mout_sclk_pcie_100", mout_bus_pll_user_t_p,
+			MUX_SEL_TOP_FSYS1, 12, 1),
+	MUX(CLK_MOUT_SCLK_UFSUNIPRO, "mout_sclk_ufsunipro",
+			mout_mphy_pll_user_t_p, MUX_SEL_TOP_FSYS1, 8, 1),
+	MUX(CLK_MOUT_SCLK_USBHOST30, "mout_sclk_usbhost30",
+			mout_bus_pll_user_t_p, MUX_SEL_TOP_FSYS1, 4, 1),
+	MUX(CLK_MOUT_SCLK_USBDRD30, "mout_sclk_usbdrd30",
+			mout_bus_pll_user_t_p, MUX_SEL_TOP_FSYS1, 0, 1),
+
 	/* MUX_SEL_TOP_PERIC0 */
 	MUX(CLK_MOUT_SCLK_SPI4, "mout_sclk_spi4", mout_bus_pll_user_t_p,
 			MUX_SEL_TOP_PERIC0, 28, 1),
@@ -324,6 +378,16 @@ static struct samsung_mux_clock top_mux_clks[] __initdata = {
 			MUX_SEL_TOP_PERIC0, 4, 1),
 	MUX(CLK_MOUT_SCLK_SPI0, "mout_sclk_spi0", mout_bus_pll_user_t_p,
 			MUX_SEL_TOP_PERIC0, 0, 1),
+
+	/* MUX_SEL_TOP_PERIC1 */
+	MUX(CLK_MOUT_SCLK_SLIMBUS, "mout_sclk_slimbus", mout_aud_pll_user_p,
+			MUX_SEL_TOP_PERIC1, 16, 1),
+	MUX(CLK_MOUT_SCLK_SPDIF, "mout_sclk_spdif", mout_sclk_spdif_p,
+			MUX_SEL_TOP_PERIC1, 12, 2),
+	MUX(CLK_MOUT_SCLK_AUDIO1, "mout_sclk_audio1", mout_sclk_audio1_p,
+			MUX_SEL_TOP_PERIC1, 4, 2),
+	MUX(CLK_MOUT_SCLK_AUDIO0, "mout_sclk_audio0", mout_sclk_audio0_p,
+			MUX_SEL_TOP_PERIC1, 0, 2),
 };
 
 static struct samsung_div_clock top_div_clks[] __initdata = {
@@ -387,6 +451,16 @@ static struct samsung_div_clock top_div_clks[] __initdata = {
 	DIV(CLK_DIV_SCLK_UART0, "div_sclk_uart0", "mout_sclk_uart1",
 			DIV_TOP_PERIC2, 0, 4),
 
+	/* DIV_TOP_PERIC3 */
+	DIV(CLK_DIV_SCLK_I2S1, "div_sclk_i2s1", "sclk_audio1",
+			DIV_TOP_PERIC3, 16, 6),
+	DIV(CLK_DIV_SCLK_PCM1, "div_sclk_pcm1", "sclk_audio1",
+			DIV_TOP_PERIC3, 8, 8),
+	DIV(CLK_DIV_SCLK_AUDIO1, "div_sclk_audio1", "mout_sclk_audio1",
+			DIV_TOP_PERIC3, 4, 4),
+	DIV(CLK_DIV_SCLK_AUDIO0, "div_sclk_audio0", "mout_sclk_audio0",
+			DIV_TOP_PERIC3, 0, 4),
+
 	/* DIV_TOP_PERIC4 */
 	DIV(CLK_DIV_SCLK_SPI4_B, "div_sclk_spi4_b", "div_sclk_spi4_a",
 			DIV_TOP_PERIC4, 16, 8),
@@ -420,6 +494,12 @@ static struct samsung_gate_clock top_gate_clks[] __initdata = {
 			ENABLE_SCLK_TOP_PERIC, 12, CLK_SET_RATE_PARENT, 0),
 	GATE(CLK_SCLK_SPI3_PERIC, "sclk_spi3_peric", "div_sclk_spi3_b",
 			ENABLE_SCLK_TOP_PERIC, 11, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_SPDIF_PERIC, "sclk_spdif_peric", "mout_sclk_spdif",
+			ENABLE_SCLK_TOP_PERIC, 9, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_I2S1_PERIC, "sclk_i2s1_peric", "div_sclk_i2s1",
+			ENABLE_SCLK_TOP_PERIC, 8, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_PCM1_PERIC, "sclk_pcm1_peric", "div_sclk_pcm1",
+			ENABLE_SCLK_TOP_PERIC, 7, CLK_SET_RATE_PARENT, 0),
 	GATE(CLK_SCLK_UART2_PERIC, "sclk_uart2_peric", "div_sclk_uart2",
 			ENABLE_SCLK_TOP_PERIC, 5, 0, 0),
 	GATE(CLK_SCLK_UART1_PERIC, "sclk_uart1_peric", "div_sclk_uart1",
@@ -432,6 +512,14 @@ static struct samsung_gate_clock top_gate_clks[] __initdata = {
 			ENABLE_SCLK_TOP_PERIC, 1, CLK_SET_RATE_PARENT, 0),
 	GATE(CLK_SCLK_SPI0_PERIC, "sclk_spi0_peric", "div_sclk_spi0_b",
 			ENABLE_SCLK_TOP_PERIC, 0, CLK_SET_RATE_PARENT, 0),
+
+	/* MUX_ENABLE_TOP_PERIC1 */
+	GATE(CLK_SCLK_SLIMBUS, "sclk_slimbus", "mout_sclk_slimbus",
+			MUX_ENABLE_TOP_PERIC1, 16, 0, 0),
+	GATE(CLK_SCLK_AUDIO1, "sclk_audio1", "div_sclk_audio1",
+			MUX_ENABLE_TOP_PERIC1, 4, 0, 0),
+	GATE(CLK_SCLK_AUDIO0, "sclk_audio0", "div_sclk_audio0",
+			MUX_ENABLE_TOP_PERIC1, 0, 0, 0),
 };
 
 /*
@@ -518,6 +606,8 @@ static struct samsung_cmu_info top_cmu_info __initdata = {
 	.nr_div_clks		= ARRAY_SIZE(top_div_clks),
 	.gate_clks		= top_gate_clks,
 	.nr_gate_clks		= ARRAY_SIZE(top_gate_clks),
+	.fixed_clks		= top_fixed_clks,
+	.nr_fixed_clks		= ARRAY_SIZE(top_fixed_clks),
 	.fixed_factor_clks	= top_fixed_factor_clks,
 	.nr_fixed_factor_clks	= ARRAY_SIZE(top_fixed_factor_clks),
 	.nr_clk_ids		= TOP_NR_CLK,
diff --git a/include/dt-bindings/clock/exynos5433.h b/include/dt-bindings/clock/exynos5433.h
index ea35d52..e0f7928 100644
--- a/include/dt-bindings/clock/exynos5433.h
+++ b/include/dt-bindings/clock/exynos5433.h
@@ -51,6 +51,23 @@
 #define CLK_MOUT_SCLK_SPI2		44
 #define CLK_MOUT_SCLK_SPI1		45
 #define CLK_MOUT_SCLK_SPI0		46
+#define CLK_MOUT_ACLK_MFC_400_C		47
+#define CLK_MOUT_ACLK_MFC_400_B		48
+#define CLK_MOUT_ACLK_MFC_400_A		49
+#define CLK_MOUT_SCLK_ISP_SENSOR2	50
+#define CLK_MOUT_SCLK_ISP_SENSOR1	51
+#define CLK_MOUT_SCLK_ISP_SENSOR0	52
+#define CLK_MOUT_SCLK_ISP_UART		53
+#define CLK_MOUT_SCLK_ISP_SPI1		54
+#define CLK_MOUT_SCLK_ISP_SPI0		55
+#define CLK_MOUT_SCLK_PCIE_100		56
+#define CLK_MOUT_SCLK_UFSUNIPRO		57
+#define CLK_MOUT_SCLK_USBHOST30		58
+#define CLK_MOUT_SCLK_USBDRD30		59
+#define CLK_MOUT_SCLK_SLIMBUS		60
+#define CLK_MOUT_SCLK_SPDIF		61
+#define CLK_MOUT_SCLK_AUDIO1		62
+#define CLK_MOUT_SCLK_AUDIO0		63
 
 #define CLK_DIV_ACLK_FSYS_200		100
 #define CLK_DIV_ACLK_IMEM_SSSX		101
@@ -79,6 +96,10 @@
 #define CLK_DIV_SCLK_SPI4_A		124
 #define CLK_DIV_SCLK_SPI3_B		125
 #define CLK_DIV_SCLK_SPI3_A		126
+#define CLK_DIV_SCLK_I2S1		127
+#define CLK_DIV_SCLK_PCM1		128
+#define CLK_DIV_SCLK_AUDIO1		129
+#define CLK_DIV_SCLK_AUDIO0		130
 
 #define CLK_ACLK_PERIC_66		200
 #define CLK_ACLK_PERIS_66		201
@@ -94,8 +115,14 @@
 #define CLK_SCLK_SPI2_PERIC		211
 #define CLK_SCLK_SPI1_PERIC		212
 #define CLK_SCLK_SPI0_PERIC		213
-
-#define TOP_NR_CLK			214
+#define CLK_SCLK_SPDIF_PERIC		214
+#define CLK_SCLK_I2S1_PERIC		215
+#define CLK_SCLK_PCM1_PERIC		216
+#define CLK_SCLK_SLIMBUS		217
+#define CLK_SCLK_AUDIO1			218
+#define CLK_SCLK_AUDIO0			219
+
+#define TOP_NR_CLK			220
 
 /* CMU_CPIF */
 #define CLK_FOUT_MPHY_PLL		1
-- 
1.8.5.5

