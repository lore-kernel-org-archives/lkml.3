Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab3L0ApG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 19:45:06 -0500
Received: from mail-yh0-f74.google.com ([209.85.213.74]:61530 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab3L0Aov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 19:44:51 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rhyland Klein <rklein@nvidia.com>,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH 2/7] clk: tegra: Fix PLLD mnp table
Date: Thu, 26 Dec 2013 16:44:22 -0800
Message-Id: <1388105067-24438-3-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1388105067-24438-1-git-send-email-abrestic@chromium.org>
References: <1388105067-24438-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rhyland Klein <rklein@nvidia.com>

PLLD was using the same mnp table as PLLP.  Fix it to use its own
table which is different from PLLP's.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/clk/tegra/clk-tegra124.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
index 28bb238..14c3f2f 100644
--- a/drivers/clk/tegra/clk-tegra124.c
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -570,6 +570,15 @@ static struct tegra_clk_pll_params pll_a_params = {
 	.flags = TEGRA_PLL_HAS_CPCON | TEGRA_PLL_USE_LOCK,
 };
 
+static struct div_nmp plld_nmp = {
+	.divm_shift = 0,
+	.divm_width = 5,
+	.divn_shift = 8,
+	.divn_width = 11,
+	.divp_shift = 20,
+	.divp_width = 3,
+};
+
 static struct tegra_clk_pll_freq_table pll_d_freq_table[] = {
 	{12000000, 216000000, 864, 12, 4, 12},
 	{13000000, 216000000, 864, 13, 4, 12},
@@ -603,7 +612,7 @@ static struct tegra_clk_pll_params pll_d_params = {
 	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLLDU_MISC_LOCK_ENABLE,
 	.lock_delay = 1000,
-	.div_nmp = &pllp_nmp,
+	.div_nmp = &plld_nmp,
 	.freq_table = pll_d_freq_table,
 	.flags = TEGRA_PLL_HAS_CPCON | TEGRA_PLL_SET_LFCON |
 		 TEGRA_PLL_USE_LOCK,
-- 
1.8.5.1

