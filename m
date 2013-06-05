Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab3FENwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 09:52:53 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15974 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256Ab3FENwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 09:52:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 05 Jun 2013 06:52:23 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] clk: tegra: PLL m,n,p init for Tegra114
Date: Wed, 5 Jun 2013 16:51:26 +0300
Message-ID: <1370440301-3562-3-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1370440301-3562-1-git-send-email-pdeschrijver@nvidia.com>
References: <1370440301-3562-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-tegra114.c |   77 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 77 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index 5e029fe..d29ad1d 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -268,6 +268,15 @@ static DEFINE_SPINLOCK(clk_doubler_lock);
 static DEFINE_SPINLOCK(clk_out_lock);
 static DEFINE_SPINLOCK(sysrate_lock);
 
+static struct div_nmp pllxc_nmp = {
+	.divm_shift = 0,
+	.divm_width = 8,
+	.divn_shift = 8,
+	.divn_width = 8,
+	.divp_shift = 20,
+	.divp_width = 4,
+};
+
 static struct pdiv_map pllxc_p[] = {
 	{ .pdiv = 1, .hw_val = 0 },
 	{ .pdiv = 2, .hw_val = 1 },
@@ -316,6 +325,16 @@ static struct tegra_clk_pll_params pll_c_params = {
 	.stepa_shift = 17,
 	.stepb_shift = 9,
 	.pdiv_tohw = pllxc_p,
+	.div_nmp = &pllxc_nmp,
+};
+
+static struct div_nmp pllcx_nmp = {
+	.divm_shift = 0,
+	.divm_width = 2,
+	.divn_shift = 8,
+	.divn_width = 8,
+	.divp_shift = 20,
+	.divp_width = 3,
 };
 
 static struct pdiv_map pllc_p[] = {
@@ -349,6 +368,8 @@ static struct tegra_clk_pll_params pll_c2_params = {
 	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
 	.pdiv_tohw = pllc_p,
+	.div_nmp = &pllcx_nmp,
+	.max_p = 7,
 	.ext_misc_reg[0] = 0x4f0,
 	.ext_misc_reg[1] = 0x4f4,
 	.ext_misc_reg[2] = 0x4f8,
@@ -367,11 +388,22 @@ static struct tegra_clk_pll_params pll_c3_params = {
 	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
 	.pdiv_tohw = pllc_p,
+	.div_nmp = &pllcx_nmp,
+	.max_p = 7,
 	.ext_misc_reg[0] = 0x504,
 	.ext_misc_reg[1] = 0x508,
 	.ext_misc_reg[2] = 0x50c,
 };
 
+static struct div_nmp pllm_nmp = {
+	.divm_shift = 0,
+	.divm_width = 8,
+	.divn_shift = 8,
+	.divn_width = 8,
+	.divp_shift = 20,
+	.divp_width = 1,
+};
+
 static struct pdiv_map pllm_p[] = {
 	{ .pdiv = 1, .hw_val = 0 },
 	{ .pdiv = 2, .hw_val = 1 },
@@ -401,6 +433,16 @@ static struct tegra_clk_pll_params pll_m_params = {
 	.lock_delay = 300,
 	.max_p = 2,
 	.pdiv_tohw = pllm_p,
+	.div_nmp = &pllm_nmp,
+};
+
+static struct div_nmp pllp_nmp = {
+	.divm_shift = 0,
+	.divm_width = 5,
+	.divn_shift = 8,
+	.divn_width = 10,
+	.divp_shift = 20,
+	.divp_width = 3,
 };
 
 static struct tegra_clk_pll_freq_table pll_p_freq_table[] = {
@@ -424,6 +466,7 @@ static struct tegra_clk_pll_params pll_p_params = {
 	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
+	.div_nmp = &pllp_nmp,
 };
 
 static struct tegra_clk_pll_freq_table pll_a_freq_table[] = {
@@ -450,6 +493,7 @@ static struct tegra_clk_pll_params pll_a_params = {
 	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
+	.div_nmp = &pllp_nmp,
 };
 
 static struct tegra_clk_pll_freq_table pll_d_freq_table[] = {
@@ -485,6 +529,7 @@ static struct tegra_clk_pll_params pll_d_params = {
 	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLLDU_MISC_LOCK_ENABLE,
 	.lock_delay = 1000,
+	.div_nmp = &pllp_nmp,
 };
 
 static struct tegra_clk_pll_params pll_d2_params = {
@@ -499,6 +544,7 @@ static struct tegra_clk_pll_params pll_d2_params = {
 	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLLDU_MISC_LOCK_ENABLE,
 	.lock_delay = 1000,
+	.div_nmp = &pllp_nmp,
 };
 
 static struct pdiv_map pllu_p[] = {
@@ -507,6 +553,15 @@ static struct pdiv_map pllu_p[] = {
 	{ .pdiv = 0, .hw_val = 0 },
 };
 
+static struct div_nmp pllu_nmp = {
+	.divm_shift = 0,
+	.divm_width = 5,
+	.divn_shift = 8,
+	.divn_width = 10,
+	.divp_shift = 20,
+	.divp_width = 1,
+};
+
 static struct tegra_clk_pll_freq_table pll_u_freq_table[] = {
 	{12000000, 480000000, 960, 12, 0, 12},
 	{13000000, 480000000, 960, 13, 0, 12},
@@ -529,6 +584,7 @@ static struct tegra_clk_pll_params pll_u_params = {
 	.lock_enable_bit_idx = PLLDU_MISC_LOCK_ENABLE,
 	.lock_delay = 1000,
 	.pdiv_tohw = pllu_p,
+	.div_nmp = &pllu_nmp,
 };
 
 static struct tegra_clk_pll_freq_table pll_x_freq_table[] = {
@@ -561,6 +617,7 @@ static struct tegra_clk_pll_params pll_x_params = {
 	.stepa_shift = 16,
 	.stepb_shift = 24,
 	.pdiv_tohw = pllxc_p,
+	.div_nmp = &pllxc_nmp,
 };
 
 static struct tegra_clk_pll_freq_table pll_e_freq_table[] = {
@@ -570,6 +627,15 @@ static struct tegra_clk_pll_freq_table pll_e_freq_table[] = {
 	{0, 0, 0, 0, 0, 0},
 };
 
+static struct div_nmp plle_nmp = {
+	.divm_shift = 0,
+	.divm_width = 8,
+	.divn_shift = 8,
+	.divn_width = 8,
+	.divp_shift = 24,
+	.divp_width = 4,
+};
+
 static struct tegra_clk_pll_params pll_e_params = {
 	.input_min = 12000000,
 	.input_max = 1000000000,
@@ -583,6 +649,16 @@ static struct tegra_clk_pll_params pll_e_params = {
 	.lock_mask = PLLE_MISC_LOCK,
 	.lock_enable_bit_idx = PLLE_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
+	.div_nmp = &plle_nmp,
+};
+
+static struct div_nmp pllre_nmp = {
+	.divm_shift = 0,
+	.divm_width = 8,
+	.divn_shift = 8,
+	.divn_width = 8,
+	.divp_shift = 16,
+	.divp_width = 4,
 };
 
 static struct tegra_clk_pll_params pll_re_vco_params = {
@@ -599,6 +675,7 @@ static struct tegra_clk_pll_params pll_re_vco_params = {
 	.lock_delay = 300,
 	.iddq_reg = PLLRE_MISC,
 	.iddq_bit_idx = PLLRE_IDDQ_BIT,
+	.div_nmp = &pllre_nmp,
 };
 
 /* Peripheral clock registers */
-- 
1.7.7.rc0.72.g4b5ea.dirty

