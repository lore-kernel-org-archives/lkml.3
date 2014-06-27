Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbaF0INU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 04:13:20 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:8710 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbaF0IMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 04:12:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 27 Jun 2014 01:02:43 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <rui.zhang@intel.com>, <edubezval@gmail.com>, <swarren@wwwdotorg.org>,
        <thierry.reding@gmail.com>, <pdeschrijver@nvidia.com>,
        <mlongnecker@nvidia.com>
CC: <linux-pm@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH 5/6] clk: tegra: Add soctherm and tsensor clocks to Tegra124 init table
Date: Fri, 27 Jun 2014 11:11:38 +0300
Message-ID: <1403856699-2140-6-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1403856699-2140-1-git-send-email-mperttunen@nvidia.com>
References: <1403856699-2140-1-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the two clocks, soctherm and tsensor, to the T124 initialization table.
They are required for soctherm-based thermal sensing.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
Peter, one more zero for TSENSOR, please :)
 drivers/clk/tegra/clk-tegra124.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
index 80efe51..abeec63 100644
--- a/drivers/clk/tegra/clk-tegra124.c
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -1369,6 +1369,8 @@ static struct tegra_clk_init_table init_table[] __initdata = {
 	{TEGRA124_CLK_XUSB_HS_SRC, TEGRA124_CLK_PLL_U_60M, 60000000, 0},
 	{TEGRA124_CLK_XUSB_FALCON_SRC, TEGRA124_CLK_PLL_RE_OUT, 224000000, 0},
 	{TEGRA124_CLK_XUSB_HOST_SRC, TEGRA124_CLK_PLL_RE_OUT, 112000000, 0},
+	{TEGRA124_CLK_SOC_THERM, TEGRA124_CLK_PLL_P, 51000000, 0},
+	{TEGRA124_CLK_TSENSOR, TEGRA124_CLK_CLK_M, 400000, 0},
 	/* This MUST be the last entry. */
 	{TEGRA124_CLK_CLK_MAX, TEGRA124_CLK_CLK_MAX, 0, 0},
 };
-- 
1.8.1.5

