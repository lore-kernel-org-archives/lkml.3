Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964AbaFZPsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 11:48:36 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6567 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbaFZPse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 11:48:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 26 Jun 2014 08:38:39 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] clk: tegra: export clock names for debugging
Date: Thu, 26 Jun 2014 18:48:25 +0300
Message-ID: <1403797705-26910-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When writing a module for testing or debugging purposes, there is no way to
get hold of clk handles. This patch solves this by exposing all valid clocks
as clkdev's for the virtual device tegra-clk-debug.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
index c0a7d77..3315fca 100644
--- a/drivers/clk/tegra/clk.c
+++ b/drivers/clk/tegra/clk.c
@@ -277,6 +277,12 @@ void __init tegra_register_devclks(struct tegra_devclk *dev_clks, int num)
 	for (i = 0; i < num; i++, dev_clks++)
 		clk_register_clkdev(clks[dev_clks->dt_id], dev_clks->con_id,
 				dev_clks->dev_id);
+
+	for (i = 0; i < clk_num; i++) {
+		if (!IS_ERR(clks[i]) || !clks[i])
+			clk_register_clkdev(clks[i], __clk_get_name(clks[i]),
+				"tegra-clk-debug");
+	}
 }
 
 struct clk ** __init tegra_lookup_dt_id(int clk_id,
-- 
1.7.7.rc0.72.g4b5ea.dirty

