Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab3EPLSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:18:09 -0400
Received: from sauhun.de ([89.238.76.85]:56265 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748Ab3EPLPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:15:35 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: [PATCH 28/33] drivers/watchdog: don't check resource with devm_ioremap_resource
Date: Thu, 16 May 2013 13:15:56 +0200
Message-Id: <1368702961-4325-29-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
References: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/watchdog/ath79_wdt.c   |    5 -----
 drivers/watchdog/davinci_wdt.c |    5 -----
 drivers/watchdog/imx2_wdt.c    |    5 -----
 3 files changed, 15 deletions(-)

diff --git a/drivers/watchdog/ath79_wdt.c b/drivers/watchdog/ath79_wdt.c
index d184c48..37cb09b 100644
--- a/drivers/watchdog/ath79_wdt.c
+++ b/drivers/watchdog/ath79_wdt.c
@@ -248,11 +248,6 @@ static int ath79_wdt_probe(struct platform_device *pdev)
 		return -EBUSY;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "no memory resource found\n");
-		return -EINVAL;
-	}
-
 	wdt_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(wdt_base))
 		return PTR_ERR(wdt_base);
diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index 100d4fb..bead774 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -217,11 +217,6 @@ static int davinci_wdt_probe(struct platform_device *pdev)
 	dev_info(dev, "heartbeat %d sec\n", heartbeat);
 
 	wdt_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (wdt_mem == NULL) {
-		dev_err(dev, "failed to get memory region resource\n");
-		return -ENOENT;
-	}
-
 	wdt_base = devm_ioremap_resource(dev, wdt_mem);
 	if (IS_ERR(wdt_base))
 		return PTR_ERR(wdt_base);
diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index ff90882..62946c2 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -257,11 +257,6 @@ static int __init imx2_wdt_probe(struct platform_device *pdev)
 	struct resource *res;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "can't get device resources\n");
-		return -ENODEV;
-	}
-
 	imx2_wdt.base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(imx2_wdt.base))
 		return PTR_ERR(imx2_wdt.base);
-- 
1.7.10.4

