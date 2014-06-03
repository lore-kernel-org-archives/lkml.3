Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911AbaFCL5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:57:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43682 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453AbaFCLmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:42:09 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 091/138] clk: tegra: Fix wrong value written to PLLE_AUX
Date: Tue,  3 Jun 2014 12:38:57 +0100
Message-Id: <1401795584-22664-92-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/clk/tegra/clk-pll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index 197074a57754..59c39f32bba8 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -1592,7 +1592,7 @@ struct clk *tegra_clk_register_plle_tegra114(const char *name,
 			  (val & PLLE_AUX_PLLP_SEL) ? "pllp_out0" : "pll_ref");
 	} else {
 		val_aux |= PLLE_AUX_PLLRE_SEL;
-		pll_writel(val, pll_params->aux_reg, pll);
+		pll_writel(val_aux, pll_params->aux_reg, pll);
 	}
 
 	clk = _tegra_clk_register_pll(pll, name, parent_name, flags,
-- 
1.9.1

