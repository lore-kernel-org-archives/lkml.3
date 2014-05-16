Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906AbaEPNu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:50:27 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6183 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655AbaEPNuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:50:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 16 May 2014 06:44:59 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: Mike Turquette <mturquette@linaro.org>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH] clk: tegra: Fix wrong value written to PLLE_AUX
Date: Fri, 16 May 2014 16:50:20 +0300
Message-ID: <1400248220-16025-1-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The value written to PLLE_AUX was incorrect due to a wrong variable
being used.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Tested-by: Mikko Perttunen <mperttunen@nvidia.com>
---
  This fix is required for the (upcoming) SATA support.
 drivers/clk/tegra/clk-pll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index 0d20241..e1769ad 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -1718,7 +1718,7 @@ struct clk *tegra_clk_register_plle_tegra114(const char *name,
 					"pll_re_vco");
 	} else {
 		val_aux &= ~(PLLE_AUX_PLLRE_SEL | PLLE_AUX_PLLP_SEL);
-		pll_writel(val, pll_params->aux_reg, pll);
+		pll_writel(val_aux, pll_params->aux_reg, pll);
 	}
 
 	clk = _tegra_clk_register_pll(pll, name, parent_name, flags,
-- 
1.7.9.5

