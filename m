Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885Ab3BGQa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:30:59 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7354 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab3BGQa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:30:57 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 07 Feb 2013 08:27:45 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: <pdeschrijver@nvidia.com>
CC: Stephen Warren <swarren@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] clk: tegra: local arrays should be static
Date: Thu, 7 Feb 2013 18:30:36 +0200
Message-ID: <1360254640-25831-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cclk_g_parents, cclk_lp_parents and sclk_parents are only accessed from within
clk-tegra30.c. Declare them static to avoid namespace polution.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-tegra30.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index a163812..d169ef0 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -1249,16 +1249,16 @@ static void __init tegra30_pmc_clk_init(void)
 
 }
 
-const char *cclk_g_parents[] = { "clk_m", "pll_c", "clk_32k", "pll_m",
-				 "pll_p_cclkg", "pll_p_out4_cclkg",
-				 "pll_p_out3_cclkg", "unused", "pll_x" };
-const char *cclk_lp_parents[] = { "clk_m", "pll_c", "clk_32k", "pll_m",
-				  "pll_p_cclklp", "pll_p_out4_cclklp",
-				  "pll_p_out3_cclklp", "unused", "pll_x",
-				  "pll_x_out0" };
-const char *sclk_parents[] = { "clk_m", "pll_c_out1", "pll_p_out4",
-			       "pll_p_out3", "pll_p_out2", "unused",
-			       "clk_32k", "pll_m_out1" };
+static const char *cclk_g_parents[] = { "clk_m", "pll_c", "clk_32k", "pll_m",
+					"pll_p_cclkg", "pll_p_out4_cclkg",
+					"pll_p_out3_cclkg", "unused", "pll_x" };
+static const char *cclk_lp_parents[] = { "clk_m", "pll_c", "clk_32k", "pll_m",
+					 "pll_p_cclklp", "pll_p_out4_cclklp",
+					 "pll_p_out3_cclklp", "unused", "pll_x",
+					 "pll_x_out0" };
+static const char *sclk_parents[] = { "clk_m", "pll_c_out1", "pll_p_out4",
+				      "pll_p_out3", "pll_p_out2", "unused",
+				      "clk_32k", "pll_m_out1" };
 
 static void __init tegra30_super_clk_init(void)
 {
-- 
1.7.7.rc0.72.g4b5ea.dirty

