Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbaFZP0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 11:26:51 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6840 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbaFZP0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 11:26:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 26 Jun 2014 08:16:54 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] clk: tegra124: init table updates
Date: Thu, 26 Jun 2014 18:26:43 +0300
Message-ID: <1403796403-26443-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure some clocks critical for system operation are always on. Also enable
csite for JTAG debugging and set the tsensor clock frequency for the upcoming
soctherm driver.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

---

Changes in v2:
 * Fix missing word in description
 * Add hclk and pclk clocks
---
 drivers/clk/tegra/clk-tegra124.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
index 80efe51..1e3a79a 100644
--- a/drivers/clk/tegra/clk-tegra124.c
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -1369,6 +1369,13 @@ static struct tegra_clk_init_table init_table[] __initdata = {
 	{TEGRA124_CLK_XUSB_HS_SRC, TEGRA124_CLK_PLL_U_60M, 60000000, 0},
 	{TEGRA124_CLK_XUSB_FALCON_SRC, TEGRA124_CLK_PLL_RE_OUT, 224000000, 0},
 	{TEGRA124_CLK_XUSB_HOST_SRC, TEGRA124_CLK_PLL_RE_OUT, 112000000, 0},
+	{TEGRA124_CLK_EMC, TEGRA124_CLK_CLK_MAX, 0, 1},
+	{TEGRA124_CLK_CCLK_G, TEGRA124_CLK_CLK_MAX, 0, 1},
+	{TEGRA124_CLK_MSELECT, TEGRA124_CLK_CLK_MAX, 0, 1},
+	{TEGRA124_CLK_HCLK, TEGRA124_CLK_CLK_MAX, 0, 1},
+	{TEGRA124_CLK_PCLK, TEGRA124_CLK_CLK_MAX, 0, 1},
+	{TEGRA124_CLK_CSITE, TEGRA124_CLK_CLK_MAX, 0, 1},
+	{TEGRA124_CLK_TSENSOR, TEGRA124_CLK_CLK_M, 40000, 0},
 	/* This MUST be the last entry. */
 	{TEGRA124_CLK_CLK_MAX, TEGRA124_CLK_CLK_MAX, 0, 0},
 };
-- 
1.7.7.rc0.72.g4b5ea.dirty

