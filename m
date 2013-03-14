Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab3CNJMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 05:12:31 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18486 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab3CNJMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 05:12:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 14 Mar 2013 02:12:27 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-tegra@vger.kernel.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Axel Lin <axel.lin@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] memory: tegra30: Fix build error w/o PM
Date: Thu, 14 Mar 2013 11:12:10 +0200
Message-ID: <1363252334-4672-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make this depend on CONFIG_PM.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 drivers/memory/tegra30-mc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/memory/tegra30-mc.c b/drivers/memory/tegra30-mc.c
index 0b97598..f4ae074 100644
--- a/drivers/memory/tegra30-mc.c
+++ b/drivers/memory/tegra30-mc.c
@@ -268,6 +268,7 @@ static const u32 tegra30_mc_ctx[] = {
 	MC_INTMASK,
 };
 
+#ifdef CONFIG_PM
 static int tegra30_mc_suspend(struct device *dev)
 {
 	int i;
@@ -291,6 +292,7 @@ static int tegra30_mc_resume(struct device *dev)
 	mc_readl(mc, MC_TIMING_CONTROL);
 	return 0;
 }
+#endif
 
 static UNIVERSAL_DEV_PM_OPS(tegra30_mc_pm,
 			    tegra30_mc_suspend,
-- 
1.8.1.5

