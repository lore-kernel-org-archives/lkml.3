Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933969Ab3GWSDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:03:08 -0400
Received: from sauhun.de ([89.238.76.85]:58728 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933941Ab3GWSDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:03:05 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Stephen Warren <swarren@wwwdotorg.org>,
        linux-tegra@vger.kernel.org
Subject: [PATCH 10/27] drivers/memory: don't check resource with devm_ioremap_resource
Date: Tue, 23 Jul 2013 20:01:43 +0200
Message-Id: <1374602524-3398-11-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
Please apply via the subsystem-tree.

 drivers/memory/tegra20-mc.c |    2 --
 drivers/memory/tegra30-mc.c |    2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/memory/tegra20-mc.c b/drivers/memory/tegra20-mc.c
index 0548eea..7cd82b8 100644
--- a/drivers/memory/tegra20-mc.c
+++ b/drivers/memory/tegra20-mc.c
@@ -218,8 +218,6 @@ static int tegra20_mc_probe(struct platform_device *pdev)
 		struct resource *res;
 
 		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
-		if (!res)
-			return -ENODEV;
 		mc->regs[i] = devm_ioremap_resource(&pdev->dev, res);
 		if (IS_ERR(mc->regs[i]))
 			return PTR_ERR(mc->regs[i]);
diff --git a/drivers/memory/tegra30-mc.c b/drivers/memory/tegra30-mc.c
index 58d2979..ef79345 100644
--- a/drivers/memory/tegra30-mc.c
+++ b/drivers/memory/tegra30-mc.c
@@ -340,8 +340,6 @@ static int tegra30_mc_probe(struct platform_device *pdev)
 		struct resource *res;
 
 		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
-		if (!res)
-			return -ENODEV;
 		mc->regs[i] = devm_ioremap_resource(&pdev->dev, res);
 		if (IS_ERR(mc->regs[i]))
 			return PTR_ERR(mc->regs[i]);
-- 
1.7.10.4

