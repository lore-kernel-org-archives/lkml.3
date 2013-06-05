Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab3FEOJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:09:51 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16349 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731Ab3FEOJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:09:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 05 Jun 2013 07:08:43 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] clk: tegra: Add fields for override bits
Date: Wed, 5 Jun 2013 17:08:26 +0300
Message-ID: <1370441329-8619-2-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1370441329-8619-1-git-send-email-pdeschrijver@nvidia.com>
References: <1370441329-8619-1-git-send-email-pdeschrijver@nvidia.com>
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

