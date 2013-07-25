Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab3GYVHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 17:07:34 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:34868 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab3GYVHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 17:07:30 -0400
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: mturquette@linaro.org
Cc: linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2] clk: exynos4: Add CLK_GET_RATE_NOCACHE flag for the Exynos4x12 ISP clocks
Date: Thu, 25 Jul 2013 23:07:05 +0200
Message-Id: <1374786425-6697-1-git-send-email-sylvester.nawrocki@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

The ISP clock registers belong to the ISP power domain and may change
their values if this power domain is switched off/on. Add
CLK_GET_RATE_NOCACHE flags to ensure we do not rely on invalid cached
data when setting or getting frequency of those clocks.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

Rebased onto v3.11-rc2.

 drivers/clk/samsung/clk-exynos4.c |   64 +++++++++++++++++++-----------------
 1 files changed, 34 insertions(+), 30 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index 1bdb882..4e57397 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -581,11 +581,15 @@ struct samsung_div_clock exynos4x12_div_clks[] __initdata = {
 	DIV(none, "div_spi1_isp", "mout_spi1_isp", E4X12_DIV_ISP, 16, 4),
 	DIV(none, "div_spi1_isp_pre", "div_spi1_isp", E4X12_DIV_ISP, 20, 8),
 	DIV(none, "div_uart_isp", "mout_uart_isp", E4X12_DIV_ISP, 28, 4),
-	DIV(div_isp0, "div_isp0", "aclk200", E4X12_DIV_ISP0, 0, 3),
-	DIV(div_isp1, "div_isp1", "aclk200", E4X12_DIV_ISP0, 4, 3),
+	DIV_F(div_isp0, "div_isp0", "aclk200", E4X12_DIV_ISP0, 0, 3,
+						CLK_GET_RATE_NOCACHE, 0),
+	DIV_F(div_isp1, "div_isp1", "aclk200", E4X12_DIV_ISP0, 4, 3,
+						CLK_GET_RATE_NOCACHE, 0),
 	DIV(none, "div_mpwm", "div_isp1", E4X12_DIV_ISP1, 0, 3),
-	DIV(div_mcuisp0, "div_mcuisp0", "aclk400_mcuisp", E4X12_DIV_ISP1, 4, 3),
-	DIV(div_mcuisp1, "div_mcuisp1", "div_mcuisp0", E4X12_DIV_ISP1, 8, 3),
+	DIV_F(div_mcuisp0, "div_mcuisp0", "aclk400_mcuisp", E4X12_DIV_ISP1,
+						4, 3, CLK_GET_RATE_NOCACHE, 0),
+	DIV_F(div_mcuisp1, "div_mcuisp1", "div_mcuisp0", E4X12_DIV_ISP1,
+						8, 3, CLK_GET_RATE_NOCACHE, 0),
 	DIV(sclk_fimg2d, "sclk_fimg2d", "mout_g2d", DIV_DMC1, 0, 4),
 };

@@ -863,57 +867,57 @@ struct samsung_gate_clock exynos4x12_gate_clks[] __initdata = {
 	GATE_DA(i2s0, "samsung-i2s.0", "i2s0", "aclk100",
 			E4X12_GATE_IP_MAUDIO, 3, 0, 0, "iis"),
 	GATE(fimc_isp, "isp", "aclk200", E4X12_GATE_ISP0, 0,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(fimc_drc, "drc", "aclk200", E4X12_GATE_ISP0, 1,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(fimc_fd, "fd", "aclk200", E4X12_GATE_ISP0, 2,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(fimc_lite0, "lite0", "aclk200", E4X12_GATE_ISP0, 3,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(fimc_lite1, "lite1", "aclk200", E4X12_GATE_ISP0, 4,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(mcuisp, "mcuisp", "aclk200", E4X12_GATE_ISP0, 5,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(gicisp, "gicisp", "aclk200", E4X12_GATE_ISP0, 7,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(smmu_isp, "smmu_isp", "aclk200", E4X12_GATE_ISP0, 8,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(smmu_drc, "smmu_drc", "aclk200", E4X12_GATE_ISP0, 9,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(smmu_fd, "smmu_fd", "aclk200", E4X12_GATE_ISP0, 10,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(smmu_lite0, "smmu_lite0", "aclk200", E4X12_GATE_ISP0, 11,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(smmu_lite1, "smmu_lite1", "aclk200", E4X12_GATE_ISP0, 12,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(ppmuispmx, "ppmuispmx", "aclk200", E4X12_GATE_ISP0, 20,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(ppmuispx, "ppmuispx", "aclk200", E4X12_GATE_ISP0, 21,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(mcuctl_isp, "mcuctl_isp", "aclk200", E4X12_GATE_ISP0, 23,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(mpwm_isp, "mpwm_isp", "aclk200", E4X12_GATE_ISP0, 24,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(i2c0_isp, "i2c0_isp", "aclk200", E4X12_GATE_ISP0, 25,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(i2c1_isp, "i2c1_isp", "aclk200", E4X12_GATE_ISP0, 26,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(mtcadc_isp, "mtcadc_isp", "aclk200", E4X12_GATE_ISP0, 27,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(pwm_isp, "pwm_isp", "aclk200", E4X12_GATE_ISP0, 28,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(wdt_isp, "wdt_isp", "aclk200", E4X12_GATE_ISP0, 30,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(uart_isp, "uart_isp", "aclk200", E4X12_GATE_ISP0, 31,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(asyncaxim, "asyncaxim", "aclk200", E4X12_GATE_ISP1, 0,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(smmu_ispcx, "smmu_ispcx", "aclk200", E4X12_GATE_ISP1, 4,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(spi0_isp, "spi0_isp", "aclk200", E4X12_GATE_ISP1, 12,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(spi1_isp, "spi1_isp", "aclk200", E4X12_GATE_ISP1, 13,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(g2d, "g2d", "aclk200", GATE_IP_DMC, 23, 0, 0),
 };

--
1.7.4.1

