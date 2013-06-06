Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab3FFLg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:36:58 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:57940 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932940Ab3FFLgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:36:55 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: mturquette@linaro.org, kgene.kim@samsung.com, patches@linaro.org
Subject: [PATCH 2/2] clk: exynos4: Add alias for cpufreq related clocks
Date: Thu,  6 Jun 2013 16:52:28 +0530
Message-Id: <1370517749-29892-3-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370517749-29892-1-git-send-email-tushar.behera@linaro.org>
References: <1370517749-29892-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq driver for EXYNOS4 based SoCs are not platform drivers, hence
we cannot currently pass the clock names through a device tree node.
Instead, we need to make them available through a global alias.

'armclk', 'moutcore', 'mout_mpll' and 'mout_apll' clock aliases are
defined.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/clk/samsung/clk-exynos4.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index 3c1f888..1e4258a 100644
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
@@ -534,7 +534,7 @@ struct samsung_div_clock exynos4_div_clks[] __initdata = {
 	DIV(none, "div_spi_pre2", "div_spi2", DIV_PERIL2, 8, 8),
 	DIV(none, "div_audio1", "mout_audio1", DIV_PERIL4, 0, 4),
 	DIV(none, "div_audio2", "mout_audio2", DIV_PERIL4, 16, 4),
-	DIV_A(arm_clk, "arm_clk", "div_core2", DIV_CPU0, 28, 3, "arm_clk"),
+	DIV_A(arm_clk, "arm_clk", "div_core2", DIV_CPU0, 28, 3, "armclk"),
 	DIV_A(sclk_apll, "sclk_apll", "mout_apll",
 			DIV_CPU0, 24, 3, "sclk_apll"),
 	DIV_F(none, "div_mipi_pre0", "div_mipi0", DIV_LCD0, 20, 4,
-- 
1.7.9.5

