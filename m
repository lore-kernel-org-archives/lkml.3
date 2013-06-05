Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab3FEOWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:22:22 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17164 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767Ab3FEOWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:22:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 05 Jun 2013 07:21:55 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] clk: tegra: fix pllre initilization
Date: Wed, 5 Jun 2013 17:21:46 +0300
Message-ID: <1370442111-13215-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PLLRE flags weren't set correctly. Fixed in this patch.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-pll.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index 4293643..197074a 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -1424,7 +1424,7 @@ struct clk *tegra_clk_register_pllre(const char *name, const char *parent_name,
 	struct tegra_clk_pll *pll;
 	struct clk *clk;
 
-	pll_flags |= TEGRA_PLL_HAS_LOCK_ENABLE;
+	pll_flags |= TEGRA_PLL_HAS_LOCK_ENABLE | TEGRA_PLL_LOCK_MISC;
 	pll = _tegra_init_pll(clk_base, pmc, fixed_rate, pll_params, pll_flags,
 			      freq_table, lock);
 	if (IS_ERR(pll))
@@ -1451,7 +1451,6 @@ struct clk *tegra_clk_register_pllre(const char *name, const char *parent_name,
 	val &= ~BIT(29);
 	pll_writel_misc(val, pll);
 
-	pll_flags |= TEGRA_PLL_LOCK_MISC;
 	clk = _tegra_clk_register_pll(pll, name, parent_name, flags,
 				      &tegra_clk_pllre_ops);
 	if (IS_ERR(clk))
-- 
1.7.7.rc0.72.g4b5ea.dirty

