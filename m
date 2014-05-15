Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbaEORc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:32:56 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:53951 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbaEORcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:32:53 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-2b-5374fa412b43
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Mark Brown <broonie@kernel.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH RFC 1/4] clk: samsung: exynos4: Add missing DMC clock hierarchy
Date: Thu, 15 May 2014 19:32:28 +0200
Message-id: <1400175151-27779-2-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1400175151-27779-1-git-send-email-t.figa@samsung.com>
References: <1400175151-27779-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t/xq7qOv0qCDfq/GlpMffiEzWL+kXOs
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jslh75C67xdLrF5ksnk64yGaxaOsXdospiw6zWrTuPcJu
	sX7GaxaLVbv+MFq0/93L5sDvsWbeGkaPnbPusntsWtXJ5nHn2h42j81L6j36tqxi9Pi8SS6A
	PYrLJiU1J7MstUjfLoErY/6xa2wFm/UrljTeZWpgnKDRxcjJISFgIrH53S8WCFtM4sK99Wxd
	jFwcQgJLGSVaHi2AcvqYJC7t+ABWxSagJvG54REbiC0ioCrxuW0BO0gRs8A0FolVy9rZQRLC
	Av4SOyfNYASxWYCK1s68AtbMK+AkcWj7NCaIdXIS/1+uALM5BZwlPi6ZAjZUCKjm7t4OtgmM
	vAsYGVYxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihITulx2Mi49ZHWIU4GBU4uHt2F8cLMSa
	WFZcmXuIUYKDWUmE1/x5SbAQb0piZVVqUX58UWlOavEhRiYOTqkGRn6HA119n1ga7E+c/zRh
	7czKu4rL+yf238qS4OHV/uzh/NTsv0zfJGeun49PG4n31bzOuh1UeJkr8cM6056zE4VYTSMP
	Zrm23fVdEZHy6NGBJuHL9d5sgYFfvT0e1by0kdyd2S/63j1faCnPydR1T4L2mQXtn7nmQ7ie
	al5K7fr3Un/y67I3KLEUZyQaajEXFScCACofQec7AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing definitions of clocks from DMC clock domain,
which are necessary to properly represent CLKOUT clock hierarchy added
in further patch.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 drivers/clk/samsung/clk-exynos4.c | 41 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index b4f9672..a274611 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -397,10 +397,15 @@ PNAME(mout_audio2_p4210) = { "cdclk2", "none", "sclk_hdmi24m",
 				"sclk_epll", "sclk_vpll", };
 PNAME(mout_mixer_p4210)	= { "sclk_dac", "sclk_hdmi", };
 PNAME(mout_dac_p4210)	= { "sclk_vpll", "sclk_hdmiphy", };
+PNAME(mout_pwi_p4210) = { "xxti", "xusbxti", "sclk_hdmi24m", "sclk_usbphy0",
+				"sclk_usbphy1", "sclk_hdmiphy", "none",
+				"sclk_epll", "sclk_vpll" };
 
 /* Exynos 4x12-specific parent groups */
 PNAME(mout_mpll_user_p4x12) = { "fin_pll", "sclk_mpll", };
 PNAME(mout_core_p4x12)	= { "mout_apll", "mout_mpll_user_c", };
+PNAME(mout_gdl_p4x12)	= { "mout_mpll_user_l", "sclk_apll", };
+PNAME(mout_gdr_p4x12)	= { "mout_mpll_user_r", "sclk_apll", };
 PNAME(sclk_ampll_p4x12)	= { "mout_mpll_user_t", "sclk_apll", };
 PNAME(group1_p4x12)	= { "xxti", "xusbxti", "sclk_hdmi24m", "sclk_usbphy0",
 				"none",	"sclk_hdmiphy", "mout_mpll_user_t",
@@ -418,6 +423,9 @@ PNAME(aclk_p4412)	= { "mout_mpll_user_t", "sclk_apll", };
 PNAME(mout_user_aclk400_mcuisp_p4x12) = {"fin_pll", "div_aclk400_mcuisp", };
 PNAME(mout_user_aclk200_p4x12) = {"fin_pll", "div_aclk200", };
 PNAME(mout_user_aclk266_gps_p4x12) = {"fin_pll", "div_aclk266_gps", };
+PNAME(mout_pwi_p4x12) = { "xxti", "xusbxti", "sclk_hdmi24m", "sclk_usbphy0",
+				"none", "sclk_hdmiphy", "sclk_mpll",
+				"sclk_epll", "sclk_vpll" };
 
 /* fixed rate clocks generated outside the soc */
 static struct samsung_fixed_rate_clock exynos4_fixed_rate_ext_clks[] __initdata = {
@@ -451,6 +459,9 @@ static struct samsung_mux_clock exynos4_mux_clks[] __initdata = {
 	MUX(0, "mout_onenand1", mout_onenand1_p, SRC_TOP0, 0, 1),
 	MUX(CLK_SCLK_EPLL, "sclk_epll", mout_epll_p, SRC_TOP0, 4, 1),
 	MUX(0, "mout_onenand", mout_onenand_p, SRC_TOP0, 28, 1),
+
+	MUX(0, "mout_dmc_bus", sclk_ampll_p4210, SRC_DMC, 4, 1),
+	MUX(0, "mout_dphy", sclk_ampll_p4210, SRC_DMC, 8, 1),
 };
 
 /* list of mux clocks supported in exynos4210 soc */
@@ -459,6 +470,10 @@ static struct samsung_mux_clock exynos4210_mux_early[] __initdata = {
 };
 
 static struct samsung_mux_clock exynos4210_mux_clks[] __initdata = {
+	MUX(0, "mout_gdl", sclk_ampll_p4210, SRC_LEFTBUS, 0, 1),
+
+	MUX(0, "mout_gdr", sclk_ampll_p4210, SRC_RIGHTBUS, 0, 1),
+
 	MUX(0, "mout_aclk200", sclk_ampll_p4210, SRC_TOP0, 12, 1),
 	MUX(0, "mout_aclk100", sclk_ampll_p4210, SRC_TOP0, 16, 1),
 	MUX(0, "mout_aclk160", sclk_ampll_p4210, SRC_TOP0, 20, 1),
@@ -503,10 +518,18 @@ static struct samsung_mux_clock exynos4210_mux_clks[] __initdata = {
 	MUX(0, "mout_spi0", group1_p4210, SRC_PERIL1, 16, 4),
 	MUX(0, "mout_spi1", group1_p4210, SRC_PERIL1, 20, 4),
 	MUX(0, "mout_spi2", group1_p4210, SRC_PERIL1, 24, 4),
+
+	MUX(0, "mout_pwi", mout_pwi_p4210, SRC_DMC, 16, 4),
 };
 
 /* list of mux clocks supported in exynos4x12 soc */
 static struct samsung_mux_clock exynos4x12_mux_clks[] __initdata = {
+	MUX(0, "mout_mpll_user_l", mout_mpll_p, SRC_LEFTBUS, 4, 1),
+	MUX(0, "mout_gdl", mout_gdl_p4x12, SRC_LEFTBUS, 0, 1),
+
+	MUX(0, "mout_mpll_user_r", mout_mpll_p, SRC_RIGHTBUS, 4, 1),
+	MUX(0, "mout_gdr", mout_gdr_p4x12, SRC_RIGHTBUS, 0, 1),
+
 	MUX(CLK_MOUT_MPLL_USER_C, "mout_mpll_user_c", mout_mpll_user_p4x12,
 			SRC_CPU, 24, 1),
 	MUX(0, "mout_aclk266_gps", aclk_p4412, SRC_TOP1, 4, 1),
@@ -565,6 +588,8 @@ static struct samsung_mux_clock exynos4x12_mux_clks[] __initdata = {
 	MUX(0, "mout_spi0_isp", group1_p4x12, E4X12_SRC_ISP, 4, 4),
 	MUX(0, "mout_spi1_isp", group1_p4x12, E4X12_SRC_ISP, 8, 4),
 	MUX(0, "mout_uart_isp", group1_p4x12, E4X12_SRC_ISP, 12, 4),
+	MUX(0, "mout_c2c", sclk_ampll_p4210, SRC_DMC, 0, 1),
+	MUX(0, "mout_pwi", mout_pwi_p4x12, SRC_DMC, 16, 4),
 	MUX(0, "mout_g2d0", sclk_ampll_p4210, SRC_DMC, 20, 1),
 	MUX(0, "mout_g2d1", sclk_evpll_p, SRC_DMC, 24, 1),
 	MUX(0, "mout_g2d", mout_g2d_p, SRC_DMC, 28, 1),
@@ -572,6 +597,12 @@ static struct samsung_mux_clock exynos4x12_mux_clks[] __initdata = {
 
 /* list of divider clocks supported in all exynos4 soc's */
 static struct samsung_div_clock exynos4_div_clks[] __initdata = {
+	DIV(0, "div_gdl", "mout_gdl", DIV_LEFTBUS, 0, 3),
+	DIV(0, "div_gpl", "div_gdl", DIV_LEFTBUS, 4, 3),
+
+	DIV(0, "div_gdr", "mout_gdr", DIV_RIGHTBUS, 0, 3),
+	DIV(0, "div_gpr", "div_gdr", DIV_RIGHTBUS, 4, 3),
+
 	DIV(0, "div_core", "mout_core", DIV_CPU0, 0, 3),
 	DIV(0, "div_core2", "div_core", DIV_CPU0, 28, 3),
 	DIV(0, "div_fimc0", "mout_fimc0", DIV_CAM, 0, 4),
@@ -631,6 +662,14 @@ static struct samsung_div_clock exynos4_div_clks[] __initdata = {
 			CLK_SET_RATE_PARENT, 0),
 	DIV_F(0, "div_mmc_pre3", "div_mmc3", DIV_FSYS2, 24, 8,
 			CLK_SET_RATE_PARENT, 0),
+
+	DIV(0, "div_acp", "mout_dmc_bus", DIV_DMC0, 0, 3),
+	DIV(0, "div_acp_pclk", "div_acp", DIV_DMC0, 4, 3),
+	DIV(0, "div_dphy", "mout_dphy", DIV_DMC0, 8, 3),
+	DIV(0, "div_dmc", "mout_dmc_bus", DIV_DMC0, 12, 3),
+	DIV(0, "div_dmcd", "div_dmc", DIV_DMC0, 16, 3),
+	DIV(0, "div_dmcp", "div_dmcd", DIV_DMC0, 20, 3),
+	DIV(0, "div_pwi", "mout_pwi", DIV_DMC1, 8, 4),
 };
 
 /* list of divider clocks supported in exynos4210 soc */
@@ -671,6 +710,8 @@ static struct samsung_div_clock exynos4x12_div_clks[] __initdata = {
 	DIV_F(CLK_DIV_MCUISP1, "div_mcuisp1", "div_mcuisp0", E4X12_DIV_ISP1,
 						8, 3, CLK_GET_RATE_NOCACHE, 0),
 	DIV(CLK_SCLK_FIMG2D, "sclk_fimg2d", "mout_g2d", DIV_DMC1, 0, 4),
+	DIV(0, "div_c2c", "mout_c2c", DIV_DMC1, 4, 3),
+	DIV(0, "div_c2c_aclk", "div_c2c", DIV_DMC1, 12, 3),
 };
 
 /* list of gate clocks supported in all exynos4 soc's */
-- 
1.9.2

