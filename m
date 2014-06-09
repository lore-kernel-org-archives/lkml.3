Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbaFIJLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:11:51 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58446 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754883AbaFIIvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 053/146] clk: tegra: Fix wrong value written to PLLE_AUX
Date: Mon,  9 Jun 2014 10:49:48 +0200
Message-Id: <1c982327c143125d3fc60763e6d8924b3bb6f028.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/clk/tegra/clk-pll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index e09f09ce44f8..4c1d9bbe3191 100644
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
1.9.3

