Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934022Ab3GWSDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:03:21 -0400
Received: from sauhun.de ([89.238.76.85]:58730 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933982Ab3GWSDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:03:10 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org
Subject: [PATCH 11/27] drivers/mtd/nand: don't check resource with devm_ioremap_resource
Date: Tue, 23 Jul 2013 20:01:44 +0200
Message-Id: <1374602524-3398-12-git-send-email-wsa@the-dreams.de>
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

 drivers/mtd/nand/mxc_nand.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index 07e5784..d1feb97 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -1446,8 +1446,6 @@ static int mxcnd_probe(struct platform_device *pdev)
 
 	if (host->devtype_data->needs_ip) {
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-		if (!res)
-			return -ENODEV;
 		host->regs_ip = devm_ioremap_resource(&pdev->dev, res);
 		if (IS_ERR(host->regs_ip))
 			return PTR_ERR(host->regs_ip);
@@ -1457,9 +1455,6 @@ static int mxcnd_probe(struct platform_device *pdev)
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	}
 
-	if (!res)
-		return -ENODEV;
-
 	host->base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(host->base))
 		return PTR_ERR(host->base);
-- 
1.7.10.4

