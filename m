Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaDDN4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 09:56:49 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10005 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbaDDN4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 09:56:01 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 04 Apr 2014 06:49:13 -0700
From: Thierry Reding <treding@nvidia.com>
To: Mike Turquette <mturquette@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
CC: Stephen Warren <swarren@wwwdotorg.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/3] clk: tegra: Fix enabling of PLLE
Date: Fri, 4 Apr 2014 15:55:15 +0200
Message-ID: <1396619715-15524-3-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396619715-15524-1-git-send-email-treding@nvidia.com>
References: <1396619715-15524-1-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When enabling the PLLE as its final step, clk_plle_enable() would
accidentally OR in the value previously written to the PLLE_SS_CTRL
register.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v2:
- new patch

 drivers/clk/tegra/clk-pll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index 1187187a1cf2..7a1b70dac824 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -757,7 +757,7 @@ static int clk_plle_enable(struct clk_hw *hw)
 	val |= PLLE_SS_DISABLE;
 	writel(val, pll->clk_base + PLLE_SS_CTRL);
 
-	val |= pll_readl_base(pll);
+	val = pll_readl_base(pll);
 	val |= (PLL_BASE_BYPASS | PLL_BASE_ENABLE);
 	pll_writel_base(val, pll);
 
-- 
1.9.1

