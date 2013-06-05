Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab3FEOaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:30:06 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17323 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020Ab3FEOaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:30:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 05 Jun 2013 07:29:37 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] clk: tegra: fix sclk_parents
Date: Wed, 5 Jun 2013 17:29:28 +0300
Message-ID: <1370442573-17512-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the correct parents for sclk according to the TRM.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-tegra114.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index 2774379e..758ba7d 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -1735,7 +1735,7 @@ static void __init tegra114_pmc_clk_init(void __iomem *pmc_base)
 }
 
 static const char *sclk_parents[] = { "clk_m", "pll_c_out1", "pll_p_out4",
-			       "pll_p_out3", "pll_p_out2", "unused",
+			       "pll_p", "pll_p_out2", "unused",
 			       "clk_32k", "pll_m_out1" };
 
 static const char *cclk_g_parents[] = { "clk_m", "pll_c", "clk_32k", "pll_m",
-- 
1.7.7.rc0.72.g4b5ea.dirty

