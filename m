Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab3L0ApC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 19:45:02 -0500
Received: from mail-qc0-f202.google.com ([209.85.216.202]:51734 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3L0Aov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 19:44:51 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Zhang <markz@nvidia.com>,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH 4/7] clk: tegra: fix host1x clock on Tegra124
Date: Thu, 26 Dec 2013 16:44:24 -0800
Message-Id: <1388105067-24438-5-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1388105067-24438-1-git-send-email-abrestic@chromium.org>
References: <1388105067-24438-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Zhang <markz@nvidia.com>

The host1x clock on Tegra124 is a 3-bit wide mux with 6 parents.
Change thte id to tegra_clk_host1x_8 so that the correct clock gets
registered.

Signed-off-by: Mark Zhang <markz@nvidia.com>
Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/clk/tegra/clk-tegra124.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
index 0fc9126..743ccb4 100644
--- a/drivers/clk/tegra/clk-tegra124.c
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -775,7 +775,7 @@ static struct tegra_clk tegra124_clks[tegra_clk_max] __initdata = {
 	[tegra_clk_gr3d] = { .dt_id = TEGRA124_CLK_GR_3D, .present = true },
 	[tegra_clk_disp2] = { .dt_id = TEGRA124_CLK_DISP2, .present = true },
 	[tegra_clk_disp1] = { .dt_id = TEGRA124_CLK_DISP1, .present = true },
-	[tegra_clk_host1x] = { .dt_id = TEGRA124_CLK_HOST1X, .present = true },
+	[tegra_clk_host1x_8] = { .dt_id = TEGRA124_CLK_HOST1X, .present = true },
 	[tegra_clk_vcp] = { .dt_id = TEGRA124_CLK_VCP, .present = true },
 	[tegra_clk_i2s0] = { .dt_id = TEGRA124_CLK_I2S0, .present = true },
 	[tegra_clk_apbdma] = { .dt_id = TEGRA124_CLK_APBDMA, .present = true },
-- 
1.8.5.1

