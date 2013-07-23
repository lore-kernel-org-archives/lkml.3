Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934145Ab3GWSD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:03:56 -0400
Received: from sauhun.de ([89.238.76.85]:51127 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933643Ab3GWSDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:03:55 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Wan ZongShun <mcuos.com@gmail.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org
Subject: [PATCH 20/27] drivers/watchdog: don't check resource with devm_ioremap_resource
Date: Tue, 23 Jul 2013 20:01:53 +0200
Message-Id: <1374602524-3398-21-git-send-email-wsa@the-dreams.de>
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

 drivers/watchdog/nuc900_wdt.c |    5 -----
 drivers/watchdog/ts72xx_wdt.c |   10 ----------
 2 files changed, 15 deletions(-)

diff --git a/drivers/watchdog/nuc900_wdt.c b/drivers/watchdog/nuc900_wdt.c
index e2b6d2c..b15b6ef 100644
--- a/drivers/watchdog/nuc900_wdt.c
+++ b/drivers/watchdog/nuc900_wdt.c
@@ -256,11 +256,6 @@ static int nuc900wdt_probe(struct platform_device *pdev)
 	spin_lock_init(&nuc900_wdt->wdt_lock);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "no memory resource specified\n");
-		return -ENOENT;
-	}
-
 	nuc900_wdt->wdt_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(nuc900_wdt->wdt_base))
 		return PTR_ERR(nuc900_wdt->wdt_base);
diff --git a/drivers/watchdog/ts72xx_wdt.c b/drivers/watchdog/ts72xx_wdt.c
index 4da59b4..42913f1 100644
--- a/drivers/watchdog/ts72xx_wdt.c
+++ b/drivers/watchdog/ts72xx_wdt.c
@@ -403,21 +403,11 @@ static int ts72xx_wdt_probe(struct platform_device *pdev)
 	}
 
 	r1 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r1) {
-		dev_err(&pdev->dev, "failed to get memory resource\n");
-		return -ENODEV;
-	}
-
 	wdt->control_reg = devm_ioremap_resource(&pdev->dev, r1);
 	if (IS_ERR(wdt->control_reg))
 		return PTR_ERR(wdt->control_reg);
 
 	r2 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (!r2) {
-		dev_err(&pdev->dev, "failed to get memory resource\n");
-		return -ENODEV;
-	}
-
 	wdt->feed_reg = devm_ioremap_resource(&pdev->dev, r2);
 	if (IS_ERR(wdt->feed_reg))
 		return PTR_ERR(wdt->feed_reg);
-- 
1.7.10.4

