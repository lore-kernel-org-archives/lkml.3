Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbaJJMvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 08:51:00 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:50230 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbaJJMux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 08:50:53 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Rhyland Klein <rklein@nvidia.com>,
        Mikko Perttunen <mikko.perttunen@kapsi.fi>,
        Thierry Reding <treding@nvidia.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH 01/10] clk: tegra124: Remove old emc_mux and emc clocks
Date: Fri, 10 Oct 2014 14:46:52 +0200
Message-Id: <1412945262-6068-2-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412945262-6068-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1412945262-6068-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikko Perttunen <mperttunen@nvidia.com>

These clocks have never been able to do anything.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/clk/tegra/clk-tegra124.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
index f5f9bac..9c9b3cb 100644
--- a/drivers/clk/tegra/clk-tegra124.c
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -150,11 +150,6 @@ static const char *mux_plld_out0_plld2_out0[] = {
 };
 #define mux_plld_out0_plld2_out0_idx NULL
 
-static const char *mux_pllmcp_clkm[] = {
-	"pll_m", "pll_c", "pll_p", "clk_m", "pll_m_ud", "pll_c2", "pll_c3",
-};
-#define mux_pllmcp_clkm_idx NULL
-
 static struct div_nmp pllxc_nmp = {
 	.divm_shift = 0,
 	.divm_width = 8,
@@ -790,7 +785,6 @@ static struct tegra_clk tegra124_clks[tegra_clk_max] __initdata = {
 	[tegra_clk_i2c2] = { .dt_id = TEGRA124_CLK_I2C2, .present = true },
 	[tegra_clk_uartc] = { .dt_id = TEGRA124_CLK_UARTC, .present = true },
 	[tegra_clk_mipi_cal] = { .dt_id = TEGRA124_CLK_MIPI_CAL, .present = true },
-	[tegra_clk_emc] = { .dt_id = TEGRA124_CLK_EMC, .present = true },
 	[tegra_clk_usb2] = { .dt_id = TEGRA124_CLK_USB2, .present = true },
 	[tegra_clk_usb3] = { .dt_id = TEGRA124_CLK_USB3, .present = true },
 	[tegra_clk_vde_8] = { .dt_id = TEGRA124_CLK_VDE, .present = true },
@@ -1124,11 +1118,6 @@ static __init void tegra124_periph_clk_init(void __iomem *clk_base,
 			       clk_base + PLLD2_BASE, 25, 1, 0, &pll_d2_lock);
 	clks[TEGRA124_CLK_DSIB_MUX] = clk;
 
-	/* emc mux */
-	clk = clk_register_mux(NULL, "emc_mux", mux_pllmcp_clkm,
-			       ARRAY_SIZE(mux_pllmcp_clkm), 0,
-			       clk_base + CLK_SOURCE_EMC,
-			       29, 3, 0, &emc_lock);
 
 	clk = tegra_clk_register_mc("mc", "emc_mux", clk_base + CLK_SOURCE_EMC,
 				    &emc_lock);
-- 
1.9.3

