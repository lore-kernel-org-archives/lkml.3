Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab3L0ApL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 19:45:11 -0500
Received: from mail-oa0-f74.google.com ([209.85.219.74]:48451 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab3L0Aov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 19:44:51 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        David Ung <davidu@nvidia.com>,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH 3/7] clk: tegra: PLLD2 fixes for hdmi
Date: Thu, 26 Dec 2013 16:44:23 -0800
Message-Id: <1388105067-24438-4-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1388105067-24438-1-git-send-email-abrestic@chromium.org>
References: <1388105067-24438-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ung <davidu@nvidia.com>

Set correct pll_d2_out0 divider and correct the p div values for pll_d2.

Signed-off-by: David Ung <davidu@nvidia.com>
Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/clk/tegra/clk-tegra124.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
index 14c3f2f..0fc9126 100644
--- a/drivers/clk/tegra/clk-tegra124.c
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -619,12 +619,11 @@ static struct tegra_clk_pll_params pll_d_params = {
 };
 
 static struct tegra_clk_pll_freq_table tegra124_pll_d2_freq_table[] = {
-	{ 12000000, 148500000,  99, 1, 8},
-	{ 12000000, 594000000,  99, 1, 1},
-	{ 13000000, 594000000,  91, 1, 1},      /* actual: 591.5 MHz */
-	{ 16800000, 594000000,  71, 1, 1},      /* actual: 596.4 MHz */
-	{ 19200000, 594000000,  62, 1, 1},      /* actual: 595.2 MHz */
-	{ 26000000, 594000000,  91, 2, 1},      /* actual: 591.5 MHz */
+	{ 12000000, 594000000,  99, 1, 2},
+	{ 13000000, 594000000,  91, 1, 2},      /* actual: 591.5 MHz */
+	{ 16800000, 594000000,  71, 1, 2},      /* actual: 596.4 MHz */
+	{ 19200000, 594000000,  62, 1, 2},      /* actual: 595.2 MHz */
+	{ 26000000, 594000000,  91, 2, 2},      /* actual: 591.5 MHz */
 	{ 0, 0, 0, 0, 0, 0 },
 };
 
@@ -1295,9 +1294,9 @@ static void __init tegra124_pll_init(void __iomem *clk_base,
 	clk_register_clkdev(clk, "pll_d2", NULL);
 	clks[TEGRA124_CLK_PLL_D2] = clk;
 
-	/* PLLD2_OUT0 ?? */
+	/* PLLD2_OUT0 */
 	clk = clk_register_fixed_factor(NULL, "pll_d2_out0", "pll_d2",
-					CLK_SET_RATE_PARENT, 1, 2);
+					CLK_SET_RATE_PARENT, 1, 1);
 	clk_register_clkdev(clk, "pll_d2_out0", NULL);
 	clks[TEGRA124_CLK_PLL_D2_OUT0] = clk;
 
-- 
1.8.5.1

