Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655Ab3FFKuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:50:16 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7897 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390Ab3FFKuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:50:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 06 Jun 2013 03:49:53 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/4] clk: tegra: Add fields for override bits
Date: Thu, 6 Jun 2013 13:47:28 +0300
Message-ID: <1370515677-6807-2-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1370515677-6807-1-git-send-email-pdeschrijver@nvidia.com>
References: <1370515677-6807-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PLLM can have override bits in the PMC. Describe those in the PLL parameters.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index d70eb2d..e01ac46 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -136,6 +136,9 @@ struct pdiv_map {
  * @divm_width:	width of the input divider bit field
  * @divp_shift:	shift to the post divider bit field
  * @divp_width:	width of the post divider bit field
+ * @override_divn_shift: shift to the feedback divider bitfield in override reg
+ * @override_divm_shift: shift to the input divider bitfield in override reg
+ * @override_divp_shift: shift to the post divider bitfield in override reg
  */
 struct div_nmp {
 	u8		divn_shift;
@@ -144,6 +147,9 @@ struct div_nmp {
 	u8		divm_width;
 	u8		divp_shift;
 	u8		divp_width;
+	u8		override_divn_shift;
+	u8		override_divm_shift;
+	u8		override_divp_shift;
 };
 
 /**
@@ -180,6 +186,8 @@ struct tegra_clk_pll_params {
 	u32		aux_reg;
 	u32		dyn_ramp_reg;
 	u32		ext_misc_reg[3];
+	u32		pmc_divnm_reg;
+	u32		pmc_divp_reg;
 	int		stepa_shift;
 	int		stepb_shift;
 	int		lock_delay;
-- 
1.7.7.rc0.72.g4b5ea.dirty

