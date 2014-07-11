Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbaGKOUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:20:43 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:13631 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118AbaGKOTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:19:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 11 Jul 2014 07:12:04 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <pdeschrijver@nvidia.com>, <pgaikwad@nvidia.com>, <mturquette@linaro.org>,
        <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH 4/8] clk: tegra124: Add PLL_M_UD and PLL_C_UD clocks
Date: Fri, 11 Jul 2014 17:18:29 +0300
Message-ID: <1405088313-20048-5-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These clocks are used as parents for some EMC timings.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 drivers/clk/tegra/clk-tegra124.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
index 99cc5ea..a4f8150 100644
--- a/drivers/clk/tegra/clk-tegra124.c
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -1153,6 +1153,12 @@ static void __init tegra124_pll_init(void __iomem *clk_base,
 	clk_register_clkdev(clk, "pll_c_out1", NULL);
 	clks[TEGRA124_CLK_PLL_C_OUT1] = clk;
 
+	/* PLLC_UD */
+	clk = clk_register_fixed_factor(NULL, "pll_c_ud", "pll_c",
+					CLK_SET_RATE_PARENT, 1, 1);
+	clk_register_clkdev(clk, "pll_c_ud", NULL);
+	clks[TEGRA124_CLK_PLL_C_UD] = clk;
+
 	/* PLLC2 */
 	clk = tegra_clk_register_pllc("pll_c2", "pll_ref", clk_base, pmc, 0,
 			     &pll_c2_params, NULL);
@@ -1185,6 +1191,8 @@ static void __init tegra124_pll_init(void __iomem *clk_base,
 	/* PLLM_UD */
 	clk = clk_register_fixed_factor(NULL, "pll_m_ud", "pll_m",
 					CLK_SET_RATE_PARENT, 1, 1);
+	clk_register_clkdev(clk, "pll_m_ud", NULL);
+	clks[TEGRA124_CLK_PLL_M_UD] = clk;
 
 	/* PLLU */
 	val = readl(clk_base + pll_u_params.base_reg);
-- 
1.8.1.5

