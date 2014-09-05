Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbaIEWvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 18:51:46 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43545 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbaIEWrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 18:47:42 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org
Subject: [PATCH v2 09/15] clk: qcom: Add MSM8960/APQ8064's HFPLLs
Date: Fri,  5 Sep 2014 15:47:29 -0700
Message-Id: <1409957256-23729-11-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.rc2.4.g1a517f0
In-Reply-To: <1409957256-23729-1-git-send-email-sboyd@codeaurora.org>
References: <1409957256-23729-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Describe the HFPLLs present on MSM8960 and APQ8064 devices.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/gcc-msm8960.c               | 172 +++++++++++++++++++++++++++
 include/dt-bindings/clock/qcom,gcc-msm8960.h |   2 +
 2 files changed, 174 insertions(+)

diff --git a/drivers/clk/qcom/gcc-msm8960.c b/drivers/clk/qcom/gcc-msm8960.c
index 007534f7a2d7..e60327baf5db 100644
--- a/drivers/clk/qcom/gcc-msm8960.c
+++ b/drivers/clk/qcom/gcc-msm8960.c
@@ -30,6 +30,7 @@
 #include "clk-pll.h"
 #include "clk-rcg.h"
 #include "clk-branch.h"
+#include "clk-hfpll.h"
 #include "reset.h"
 
 static struct clk_pll pll3 = {
@@ -75,6 +76,164 @@ static struct clk_regmap pll8_vote = {
 	},
 };
 
+static struct hfpll_data hfpll0_data = {
+	.mode_reg = 0x3200,
+	.l_reg = 0x3208,
+	.m_reg = 0x320c,
+	.n_reg = 0x3210,
+	.config_reg = 0x3204,
+	.status_reg = 0x321c,
+	.config_val = 0x7845c665,
+	.droop_reg = 0x3214,
+	.droop_val = 0x0108c000,
+	.min_rate = 600000000UL,
+	.max_rate = 1800000000UL,
+};
+
+static struct clk_hfpll hfpll0 = {
+	.d = &hfpll0_data,
+	.clkr.hw.init = &(struct clk_init_data){
+		.parent_names = (const char *[]){ "pxo" },
+		.num_parents = 1,
+		.name = "hfpll0",
+		.ops = &clk_ops_hfpll,
+		.flags = CLK_IGNORE_UNUSED,
+	},
+	.lock = __SPIN_LOCK_UNLOCKED(hfpll0.lock),
+};
+
+static struct hfpll_data hfpll1_8064_data = {
+	.mode_reg = 0x3240,
+	.l_reg = 0x3248,
+	.m_reg = 0x324c,
+	.n_reg = 0x3250,
+	.config_reg = 0x3244,
+	.status_reg = 0x325c,
+	.config_val = 0x7845c665,
+	.droop_reg = 0x3254,
+	.droop_val = 0x0108c000,
+	.min_rate = 600000000UL,
+	.max_rate = 1800000000UL,
+};
+
+static struct hfpll_data hfpll1_data = {
+	.mode_reg = 0x3300,
+	.l_reg = 0x3308,
+	.m_reg = 0x330c,
+	.n_reg = 0x3310,
+	.config_reg = 0x3304,
+	.status_reg = 0x331c,
+	.config_val = 0x7845c665,
+	.droop_reg = 0x3314,
+	.droop_val = 0x0108c000,
+	.min_rate = 600000000UL,
+	.max_rate = 1800000000UL,
+};
+
+static struct clk_hfpll hfpll1 = {
+	.d = &hfpll1_data,
+	.clkr.hw.init = &(struct clk_init_data){
+		.parent_names = (const char *[]){ "pxo" },
+		.num_parents = 1,
+		.name = "hfpll1",
+		.ops = &clk_ops_hfpll,
+		.flags = CLK_IGNORE_UNUSED,
+	},
+	.lock = __SPIN_LOCK_UNLOCKED(hfpll1.lock),
+};
+
+static struct hfpll_data hfpll2_data = {
+	.mode_reg = 0x3280,
+	.l_reg = 0x3288,
+	.m_reg = 0x328c,
+	.n_reg = 0x3290,
+	.config_reg = 0x3284,
+	.status_reg = 0x329c,
+	.config_val = 0x7845c665,
+	.droop_reg = 0x3294,
+	.droop_val = 0x0108c000,
+	.min_rate = 600000000UL,
+	.max_rate = 1800000000UL,
+};
+
+static struct clk_hfpll hfpll2 = {
+	.d = &hfpll2_data,
+	.clkr.hw.init = &(struct clk_init_data){
+		.parent_names = (const char *[]){ "pxo" },
+		.num_parents = 1,
+		.name = "hfpll2",
+		.ops = &clk_ops_hfpll,
+		.flags = CLK_IGNORE_UNUSED,
+	},
+	.lock = __SPIN_LOCK_UNLOCKED(hfpll2.lock),
+};
+
+static struct hfpll_data hfpll3_data = {
+	.mode_reg = 0x32c0,
+	.l_reg = 0x32c8,
+	.m_reg = 0x32cc,
+	.n_reg = 0x32d0,
+	.config_reg = 0x32c4,
+	.status_reg = 0x32dc,
+	.config_val = 0x7845c665,
+	.droop_reg = 0x32d4,
+	.droop_val = 0x0108c000,
+	.min_rate = 600000000UL,
+	.max_rate = 1800000000UL,
+};
+
+static struct clk_hfpll hfpll3 = {
+	.d = &hfpll3_data,
+	.clkr.hw.init = &(struct clk_init_data){
+		.parent_names = (const char *[]){ "pxo" },
+		.num_parents = 1,
+		.name = "hfpll3",
+		.ops = &clk_ops_hfpll,
+		.flags = CLK_IGNORE_UNUSED,
+	},
+	.lock = __SPIN_LOCK_UNLOCKED(hfpll3.lock),
+};
+
+static struct hfpll_data hfpll_l2_8064_data = {
+	.mode_reg = 0x3300,
+	.l_reg = 0x3308,
+	.m_reg = 0x330c,
+	.n_reg = 0x3310,
+	.config_reg = 0x3304,
+	.status_reg = 0x331c,
+	.config_val = 0x7845c665,
+	.droop_reg = 0x3314,
+	.droop_val = 0x0108c000,
+	.min_rate = 600000000UL,
+	.max_rate = 1800000000UL,
+};
+
+static struct hfpll_data hfpll_l2_data = {
+	.mode_reg = 0x3400,
+	.l_reg = 0x3408,
+	.m_reg = 0x340c,
+	.n_reg = 0x3410,
+	.config_reg = 0x3404,
+	.status_reg = 0x341c,
+	.config_val = 0x7845c665,
+	.droop_reg = 0x3414,
+	.droop_val = 0x0108c000,
+	.min_rate = 600000000UL,
+	.max_rate = 1800000000UL,
+};
+
+static struct clk_hfpll hfpll_l2 = {
+	.d = &hfpll_l2_data,
+	.clkr.hw.init = &(struct clk_init_data){
+		.parent_names = (const char *[]){ "pxo" },
+		.num_parents = 1,
+		.name = "hfpll_l2",
+		.ops = &clk_ops_hfpll,
+		.flags = CLK_IGNORE_UNUSED,
+	},
+	.lock = __SPIN_LOCK_UNLOCKED(hfpll_l2.lock),
+};
+
 static struct clk_pll pll14 = {
 	.l_reg = 0x31c4,
 	.m_reg = 0x31c8,
@@ -3140,6 +3299,9 @@ static struct clk_regmap *gcc_msm8960_clks[] = {
 	[PMIC_ARB1_H_CLK] = &pmic_arb1_h_clk.clkr,
 	[PMIC_SSBI2_CLK] = &pmic_ssbi2_clk.clkr,
 	[RPM_MSG_RAM_H_CLK] = &rpm_msg_ram_h_clk.clkr,
+	[PLL9] = &hfpll0.clkr,
+	[PLL10] = &hfpll1.clkr,
+	[PLL12] = &hfpll_l2.clkr,
 };
 
 static const struct qcom_reset_map gcc_msm8960_resets[] = {
@@ -3350,6 +3512,11 @@ static struct clk_regmap *gcc_apq8064_clks[] = {
 	[PMIC_ARB1_H_CLK] = &pmic_arb1_h_clk.clkr,
 	[PMIC_SSBI2_CLK] = &pmic_ssbi2_clk.clkr,
 	[RPM_MSG_RAM_H_CLK] = &rpm_msg_ram_h_clk.clkr,
+	[PLL9] = &hfpll0.clkr,
+	[PLL10] = &hfpll1.clkr,
+	[PLL12] = &hfpll_l2.clkr,
+	[PLL16] = &hfpll2.clkr,
+	[PLL17] = &hfpll3.clkr,
 };
 
 static const struct qcom_reset_map gcc_apq8064_resets[] = {
@@ -3496,6 +3663,11 @@ static int gcc_msm8960_probe(struct platform_device *pdev)
 	if (!match)
 		return -EINVAL;
 
+	if (match->data == &gcc_apq8064_desc) {
+		hfpll1.d = &hfpll1_8064_data;
+		hfpll_l2.d = &hfpll_l2_8064_data;
+	}
+
 	/* Temporary until RPM clocks supported */
 	clk = clk_register_fixed_rate(dev, "cxo", NULL, CLK_IS_ROOT, 19200000);
 	if (IS_ERR(clk))
diff --git a/include/dt-bindings/clock/qcom,gcc-msm8960.h b/include/dt-bindings/clock/qcom,gcc-msm8960.h
index 7d20eedfee98..e02742fc81cc 100644
--- a/include/dt-bindings/clock/qcom,gcc-msm8960.h
+++ b/include/dt-bindings/clock/qcom,gcc-msm8960.h
@@ -319,5 +319,7 @@
 #define CE3_SRC					303
 #define CE3_CORE_CLK				304
 #define CE3_H_CLK				305
+#define PLL16					306
+#define PLL17					307
 
 #endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

