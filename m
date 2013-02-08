Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946468Ab3BHMo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 07:44:26 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18208 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946359Ab3BHMoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 07:44:24 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 08 Feb 2013 04:42:01 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: <pdeschrijver@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, Stephen Warren <swarren@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Joseph Lo <josephl@nvidia.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] clk: tegra: No 7.1 super clk dividers on Tegra20
Date: Fri, 8 Feb 2013 14:44:09 +0200
Message-ID: <1360327453-29242-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike Tegra30, Tegra20 does not have a 7.1 divider for the CPU superclk.
Remove the clocks related to the divider.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-tegra20.c |   36 ++----------------------------------
 1 files changed, 2 insertions(+), 34 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index 4612b2e..90ae8f3 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -711,8 +711,8 @@ static void tegra20_pll_init(void)
 }
 
 static const char *cclk_parents[] = { "clk_m", "pll_c", "clk_32k", "pll_m",
-				      "pll_p_cclk", "pll_p_out4_cclk",
-				      "pll_p_out3_cclk", "clk_d", "pll_x" };
+				      "pll_p", "pll_p_out4",
+				      "pll_p_out3", "clk_d", "pll_x" };
 static const char *sclk_parents[] = { "clk_m", "pll_c_out1", "pll_p_out4",
 				      "pll_p_out3", "pll_p_out2", "clk_d",
 				      "clk_32k", "pll_m_out1" };
@@ -721,38 +721,6 @@ static void tegra20_super_clk_init(void)
 {
 	struct clk *clk;
 
-	/*
-	 * DIV_U71 dividers for CCLK, these dividers are used only
-	 * if parent clock is fixed rate.
-	 */
-
-	/*
-	 * Clock input to cclk divided from pll_p using
-	 * U71 divider of cclk.
-	 */
-	clk = tegra_clk_register_divider("pll_p_cclk", "pll_p",
-				clk_base + SUPER_CCLK_DIVIDER, 0,
-				TEGRA_DIVIDER_INT, 16, 8, 1, NULL);
-	clk_register_clkdev(clk, "pll_p_cclk", NULL);
-
-	/*
-	 * Clock input to cclk divided from pll_p_out3 using
-	 * U71 divider of cclk.
-	 */
-	clk = tegra_clk_register_divider("pll_p_out3_cclk", "pll_p_out3",
-				clk_base + SUPER_CCLK_DIVIDER, 0,
-				TEGRA_DIVIDER_INT, 16, 8, 1, NULL);
-	clk_register_clkdev(clk, "pll_p_out3_cclk", NULL);
-
-	/*
-	 * Clock input to cclk divided from pll_p_out4 using
-	 * U71 divider of cclk.
-	 */
-	clk = tegra_clk_register_divider("pll_p_out4_cclk", "pll_p_out4",
-				clk_base + SUPER_CCLK_DIVIDER, 0,
-				TEGRA_DIVIDER_INT, 16, 8, 1, NULL);
-	clk_register_clkdev(clk, "pll_p_out4_cclk", NULL);
-
 	/* CCLK */
 	clk = tegra_clk_register_super_mux("cclk", cclk_parents,
 			      ARRAY_SIZE(cclk_parents), CLK_SET_RATE_PARENT,
-- 
1.7.7.rc0.72.g4b5ea.dirty

