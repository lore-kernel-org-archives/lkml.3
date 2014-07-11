Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbaGKOVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:21:35 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:13628 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbaGKOTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:19:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 11 Jul 2014 07:11:56 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <pdeschrijver@nvidia.com>, <pgaikwad@nvidia.com>, <mturquette@linaro.org>,
        <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH 1/8] clk: tegra124: Remove old emc_mux and emc clocks
Date: Fri, 11 Jul 2014 17:18:26 +0300
Message-ID: <1405088313-20048-2-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These clocks have never been able to do anything.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 drivers/clk/tegra/clk-tegra124.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
index 80efe51..99cc5ea 100644
--- a/drivers/clk/tegra/clk-tegra124.c
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -29,7 +29,6 @@
 #include "clk-id.h"
 
 #define CLK_SOURCE_CSITE 0x1d4
-#define CLK_SOURCE_EMC 0x19c
 
 #define PLLC_BASE 0x80
 #define PLLC_OUT 0x84
@@ -149,11 +148,6 @@ static const char *mux_plld_out0_plld2_out0[] = {
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
@@ -789,7 +783,6 @@ static struct tegra_clk tegra124_clks[tegra_clk_max] __initdata = {
 	[tegra_clk_i2c2] = { .dt_id = TEGRA124_CLK_I2C2, .present = true },
 	[tegra_clk_uartc] = { .dt_id = TEGRA124_CLK_UARTC, .present = true },
 	[tegra_clk_mipi_cal] = { .dt_id = TEGRA124_CLK_MIPI_CAL, .present = true },
-	[tegra_clk_emc] = { .dt_id = TEGRA124_CLK_EMC, .present = true },
 	[tegra_clk_usb2] = { .dt_id = TEGRA124_CLK_USB2, .present = true },
 	[tegra_clk_usb3] = { .dt_id = TEGRA124_CLK_USB3, .present = true },
 	[tegra_clk_vde_8] = { .dt_id = TEGRA124_CLK_VDE, .present = true },
@@ -1123,12 +1116,6 @@ static __init void tegra124_periph_clk_init(void __iomem *clk_base,
 			       clk_base + PLLD2_BASE, 25, 1, 0, &pll_d2_lock);
 	clks[TEGRA124_CLK_DSIB_MUX] = clk;
 
-	/* emc mux */
-	clk = clk_register_mux(NULL, "emc_mux", mux_pllmcp_clkm,
-			       ARRAY_SIZE(mux_pllmcp_clkm), 0,
-			       clk_base + CLK_SOURCE_EMC,
-			       29, 3, 0, NULL);
-
 	/* cml0 */
 	clk = clk_register_gate(NULL, "cml0", "pll_e", 0, clk_base + PLLE_AUX,
 				0, 0, &pll_e_lock);
-- 
1.8.1.5

