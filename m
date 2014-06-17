Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967367AbaFQVyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:54:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55018 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967254AbaFQVxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:53:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 139/212] clk: tegra: Fix wrong value written to PLLE_AUX
Date: Tue, 17 Jun 2014 14:43:53 -0700
Message-Id: <1403041506-13646-140-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>

commit d2c834abe2b39a2d5a6c38ef44de87c97cbb34b4 upstream.

The value written to PLLE_AUX was incorrect due to a wrong variable
being used. Without this fix SATA does not work.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Tested-by: Mikko Perttunen <mperttunen@nvidia.com>
Reviewed-by: Thierry Reding <treding@nvidia.com>
Tested-by: Thierry Reding <treding@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
[mturquette@linaro.org: improved changelog]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/clk/tegra/clk-pll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index e09f09c..4c1d9bb 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -1594,7 +1594,7 @@ struct clk *tegra_clk_register_plle_tegra114(const char *name,
 					"pll_re_vco");
 	} else {
 		val_aux &= ~(PLLE_AUX_PLLRE_SEL | PLLE_AUX_PLLP_SEL);
-		pll_writel(val, pll_params->aux_reg, pll);
+		pll_writel(val_aux, pll_params->aux_reg, pll);
 	}
 
 	clk = _tegra_clk_register_pll(pll, name, parent_name, flags,
-- 
1.9.1

