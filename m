Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030240Ab3FTLDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:03:06 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:37749 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030223Ab3FTLDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:03:02 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: mturquette@linaro.org, kgene.kim@samsung.com, tomasz.figa@gmail.com,
        patches@linaro.org
Subject: [PATCH v2 2/2] clk: exynos4: Fix clock aliases for cpufreq related clocks
Date: Thu, 20 Jun 2013 16:17:18 +0530
Message-Id: <1371725238-25437-3-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371725238-25437-1-git-send-email-tushar.behera@linaro.org>
References: <1371725238-25437-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq driver for EXYNOS4 based SoCs are not platform drivers, hence
we cannot currently pass the clock names through a device tree node.
Instead, we need to make them available through a global alias.

Clock alias modifications for EXYNOS4 specific clocks are as below.

Alias for clock 'arm_clk' is 'armclk'.
Alias for clock 'mout_apll' is 'mout_apll'.
Alias for clock 'mout_core' is 'moutcore'.

For EXYNOS4210, alias for clock 'sclk_mpll' is 'mout_mpll'.
For EXYNOS4412, alias for clock 'mout_mpll_user_c' is 'mout_mpll'.

Some of the clock aliases are newly defined and some are fixed up.

While at it, also modify the debug messages to print the clock
values appropriately.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
Changes for v2:
* Clocks for EXYNOS4X12 has also been modified.
* Debug messages are updated to reflect the change in clock alias.
* Updated commit message to better describe the changes.

 drivers/clk/samsung/clk-exynos4.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index addc738..1bdb882 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -356,8 +356,8 @@ struct samsung_fixed_rate_clock exynos4210_fixed_rate_clks[] __initdata = {
 
 /* list of mux clocks supported in all exynos4 soc's */
 struct samsung_mux_clock exynos4_mux_clks[] __initdata = {
-	MUX_F(mout_apll, "mout_apll", mout_apll_p, SRC_CPU, 0, 1,
-			CLK_SET_RATE_PARENT, 0),
+	MUX_FA(mout_apll, "mout_apll", mout_apll_p, SRC_CPU, 0, 1,
+			CLK_SET_RATE_PARENT, 0, "mout_apll"),
 	MUX(none, "mout_hdmi", mout_hdmi_p, SRC_TV, 0, 1),
 	MUX(none, "mout_mfc1", sclk_evpll_p, SRC_MFC, 4, 1),
 	MUX(none, "mout_mfc", mout_mfc_p, SRC_MFC, 8, 1),
@@ -385,9 +385,9 @@ struct samsung_mux_clock exynos4210_mux_clks[] __initdata = {
 	MUX(none, "mout_g2d", mout_g2d_p, E4210_SRC_IMAGE, 8, 1),
 	MUX(none, "mout_fimd1", group1_p4210, E4210_SRC_LCD1, 0, 4),
 	MUX(none, "mout_mipi1", group1_p4210, E4210_SRC_LCD1, 12, 4),
-	MUX_A(sclk_mpll, "sclk_mpll", mout_mpll_p, SRC_CPU, 8, 1, "sclk_mpll"),
+	MUX_A(sclk_mpll, "sclk_mpll", mout_mpll_p, SRC_CPU, 8, 1, "mout_mpll"),
 	MUX_A(mout_core, "mout_core", mout_core_p4210,
-			SRC_CPU, 16, 1, "mout_core"),
+			SRC_CPU, 16, 1, "moutcore"),
 	MUX_A(sclk_vpll, "sclk_vpll", sclk_vpll_p4210,
 			SRC_TOP0, 8, 1, "sclk_vpll"),
 	MUX(mout_fimc0, "mout_fimc0", group1_p4210, SRC_CAM, 0, 4),
@@ -424,8 +424,8 @@ struct samsung_mux_clock exynos4210_mux_clks[] __initdata = {
 
 /* list of mux clocks supported in exynos4x12 soc */
 struct samsung_mux_clock exynos4x12_mux_clks[] __initdata = {
-	MUX(mout_mpll_user_c, "mout_mpll_user_c", mout_mpll_user_p4x12,
-			SRC_CPU, 24, 1),
+	MUX_A(mout_mpll_user_c, "mout_mpll_user_c", mout_mpll_user_p4x12,
+			SRC_CPU, 24, 1, "mout_mpll"),
 	MUX(none, "mout_aclk266_gps", aclk_p4412, SRC_TOP1, 4, 1),
 	MUX(none, "mout_aclk400_mcuisp", aclk_p4412, SRC_TOP1, 8, 1),
 	MUX(mout_mpll_user_t, "mout_mpll_user_t", mout_mpll_user_p4x12,
@@ -449,7 +449,8 @@ struct samsung_mux_clock exynos4x12_mux_clks[] __initdata = {
 			SRC_DMC, 12, 1, "sclk_mpll"),
 	MUX_A(sclk_vpll, "sclk_vpll", mout_vpll_p,
 			SRC_TOP0, 8, 1, "sclk_vpll"),
-	MUX(mout_core, "mout_core", mout_core_p4x12, SRC_CPU, 16, 1),
+	MUX_A(mout_core, "mout_core", mout_core_p4x12,
+			SRC_CPU, 16, 1, "moutcore"),
 	MUX(mout_fimc0, "mout_fimc0", group1_p4x12, SRC_CAM, 0, 4),
 	MUX(mout_fimc1, "mout_fimc1", group1_p4x12, SRC_CAM, 4, 4),
 	MUX(mout_fimc2, "mout_fimc2", group1_p4x12, SRC_CAM, 8, 4),
@@ -537,7 +538,7 @@ struct samsung_div_clock exynos4_div_clks[] __initdata = {
 	DIV(none, "div_spi_pre2", "div_spi2", DIV_PERIL2, 8, 8),
 	DIV(none, "div_audio1", "mout_audio1", DIV_PERIL4, 0, 4),
 	DIV(none, "div_audio2", "mout_audio2", DIV_PERIL4, 16, 4),
-	DIV_A(arm_clk, "arm_clk", "div_core2", DIV_CPU0, 28, 3, "arm_clk"),
+	DIV_A(arm_clk, "arm_clk", "div_core2", DIV_CPU0, 28, 3, "armclk"),
 	DIV_A(sclk_apll, "sclk_apll", "mout_apll",
 			DIV_CPU0, 24, 3, "sclk_apll"),
 	DIV_F(none, "div_mipi_pre0", "div_mipi0", DIV_LCD0, 20, 4,
@@ -1070,9 +1071,9 @@ void __init exynos4_clk_init(struct device_node *np, enum exynos4_soc exynos4_so
 	pr_info("%s clocks: sclk_apll = %ld, sclk_mpll = %ld\n"
 		"\tsclk_epll = %ld, sclk_vpll = %ld, arm_clk = %ld\n",
 		exynos4_soc == EXYNOS4210 ? "Exynos4210" : "Exynos4x12",
-		_get_rate("sclk_apll"),	_get_rate("sclk_mpll"),
+		_get_rate("sclk_apll"),	_get_rate("mout_mpll"),
 		_get_rate("sclk_epll"), _get_rate("sclk_vpll"),
-		_get_rate("arm_clk"));
+		_get_rate("armclk"));
 }
 
 
-- 
1.7.9.5

