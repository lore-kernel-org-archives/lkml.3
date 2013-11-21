Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab3KUCi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 21:38:27 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:13241 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab3KUCiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 21:38:23 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 20 Nov 2013 18:32:22 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] clk: tegra: add FUSE clock device
Date: Thu, 21 Nov 2013 11:38:10 +0900
Message-ID: <1385001490-18927-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This clock is needed to ensure the FUSE registers can be accessed
without freezing the system.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/clk/tegra/clk-tegra114.c | 1 +
 drivers/clk/tegra/clk-tegra124.c | 1 +
 drivers/clk/tegra/clk-tegra20.c  | 1 +
 drivers/clk/tegra/clk-tegra30.c  | 2 +-
 4 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index dbab27f773b5..b29d31d94d2e 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -925,6 +925,7 @@ static struct tegra_devclk devclks[] __initdata = {
 	{ .con_id = "sclk", .dt_id = TEGRA114_CLK_SCLK },
 	{ .con_id = "hclk", .dt_id = TEGRA114_CLK_HCLK },
 	{ .con_id = "pclk", .dt_id = TEGRA114_CLK_PCLK },
+	{ .con_id = "fuse", .dt_id = TEGRA114_CLK_FUSE },
 	{ .dev_id = "rtc-tegra", .dt_id = TEGRA114_CLK_RTC },
 	{ .dev_id = "timer", .dt_id = TEGRA114_CLK_TIMER },
 };
diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
index 266e80b51d38..e123fd218983 100644
--- a/drivers/clk/tegra/clk-tegra124.c
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -1007,6 +1007,7 @@ static struct tegra_devclk devclks[] __initdata = {
 	{ .con_id = "sclk", .dt_id = TEGRA124_CLK_SCLK },
 	{ .con_id = "hclk", .dt_id = TEGRA124_CLK_HCLK },
 	{ .con_id = "pclk", .dt_id = TEGRA124_CLK_PCLK },
+	{ .con_id = "fuse", .dt_id = TEGRA124_CLK_FUSE },
 	{ .dev_id = "rtc-tegra", .dt_id = TEGRA124_CLK_RTC },
 	{ .dev_id = "timer", .dt_id = TEGRA124_CLK_TIMER },
 };
diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index 58faac5f509e..9dd264886621 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -452,6 +452,7 @@ static struct tegra_devclk devclks[] __initdata = {
 	{ .con_id = "sclk", .dt_id = TEGRA20_CLK_SCLK },
 	{ .con_id = "hclk", .dt_id = TEGRA20_CLK_HCLK },
 	{ .con_id = "pclk", .dt_id = TEGRA20_CLK_PCLK },
+	{ .con_id = "fuse", .dt_id = TEGRA20_CLK_FUSE },
 	{ .con_id = "twd", .dt_id = TEGRA20_CLK_TWD },
 	{ .con_id = "audio", .dt_id = TEGRA20_CLK_AUDIO },
 	{ .con_id = "audio_2x", .dt_id = TEGRA20_CLK_AUDIO_2X },
diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index 51c093c96657..6d96b307d48c 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -659,7 +659,7 @@ static struct tegra_devclk devclks[] __initdata = {
 	{ .con_id = "pcie", .dev_id = "tegra-pcie", .dt_id = TEGRA30_CLK_PCIE },
 	{ .con_id = "afi", .dev_id = "tegra-pcie", .dt_id = TEGRA30_CLK_AFI },
 	{ .con_id = "pciex", .dev_id = "tegra-pcie", .dt_id = TEGRA30_CLK_PCIEX },
-	{ .con_id = "fuse", .dev_id = "fuse-tegra", .dt_id = TEGRA30_CLK_FUSE },
+	{ .con_id = "fuse", .dt_id = TEGRA30_CLK_FUSE },
 	{ .con_id = "fuse_burn", .dev_id = "fuse-tegra", .dt_id = TEGRA30_CLK_FUSE_BURN },
 	{ .con_id = "apbif", .dev_id = "tegra30-ahub", .dt_id = TEGRA30_CLK_APBIF },
 	{ .con_id = "hda2hdmi", .dev_id = "tegra30-hda", .dt_id = TEGRA30_CLK_HDA2HDMI },
-- 
1.8.4.2

