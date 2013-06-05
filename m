Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab3FEOKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:10:35 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16372 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab3FEOKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:10:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 05 Jun 2013 07:09:27 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] clk: tegra: override bits for Tegra30 PLLM
Date: Wed, 5 Jun 2013 17:08:28 +0300
Message-ID: <1370441329-8619-4-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1370441329-8619-1-git-send-email-pdeschrijver@nvidia.com>
References: <1370441329-8619-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-tegra30.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index b62e140..e598656 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -252,6 +252,9 @@
 #define CLK_RESET_CCLK_RUN_POLICY		2
 #define CLK_RESET_CCLK_BURST_POLICY_PLLX	8
 
+/* PLLM override registers */
+#define PMC_PLLM_WB0_OVERRIDE 0x1dc
+
 #ifdef CONFIG_PM_SLEEP
 static struct cpu_clk_suspend_context {
 	u32 pllx_misc;
@@ -563,6 +566,18 @@ static struct tegra_clk_pll_params pll_c_params = {
 	.lock_delay = 300,
 };
 
+static struct div_nmp pllm_nmp = {
+	.divn_shift = 8,
+	.divn_width = 10,
+	.override_divn_shift = 5,
+	.divm_shift = 0,
+	.divm_width = 5,
+	.override_divm_shift = 0,
+	.divp_shift = 20,
+	.divp_width = 3,
+	.override_divp_shift = 15,
+};
+
 static struct tegra_clk_pll_params pll_m_params = {
 	.input_min = 2000000,
 	.input_max = 31000000,
@@ -575,6 +590,9 @@ static struct tegra_clk_pll_params pll_m_params = {
 	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
+	.div_nmp = &pllm_nmp,
+	.pmc_divnm_reg = PMC_PLLM_WB0_OVERRIDE,
+	.pmc_divp_reg = PMC_PLLM_WB0_OVERRIDE,
 };
 
 static struct tegra_clk_pll_params pll_p_params = {
-- 
1.7.7.rc0.72.g4b5ea.dirty

