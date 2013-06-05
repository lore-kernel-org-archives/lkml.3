Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab3FENiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 09:38:08 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16205 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab3FENiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 09:38:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 05 Jun 2013 06:36:54 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] clk: tegra: pllp_out2 divider is int only
Date: Wed, 5 Jun 2013 16:37:17 +0300
Message-ID: <1370439442-30852-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pllp_out2 should be integer only, the fractional bit should always be 0.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-tegra114.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index eb27764..5e029fe 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -1203,8 +1203,8 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 	/* PLLP_OUT2 */
 	clk = tegra_clk_register_divider("pll_p_out2_div", "pll_p",
 				clk_base + PLLP_OUTA, 0, TEGRA_DIVIDER_FIXED |
-				TEGRA_DIVIDER_ROUND_UP, 24, 8, 1,
-				&pll_div_lock);
+				TEGRA_DIVIDER_ROUND_UP | TEGRA_DIVIDER_INT, 24,
+				8, 1, &pll_div_lock);
 	clk = tegra_clk_register_pll_out("pll_p_out2", "pll_p_out2_div",
 				clk_base + PLLP_OUTA, 17, 16,
 				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
-- 
1.7.7.rc0.72.g4b5ea.dirty

