Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab3EPLXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:23:35 -0400
Received: from sauhun.de ([89.238.76.85]:56123 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663Ab3EPLOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:14:55 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org
Subject: [PATCH 12/33] drivers/mtd/nand: don't check resource with devm_ioremap_resource
Date: Thu, 16 May 2013 13:15:40 +0200
Message-Id: <1368702961-4325-13-git-send-email-wsa@the-dreams.de>
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
 drivers/mtd/nand/lpc32xx_mlc.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/mtd/nand/lpc32xx_mlc.c b/drivers/mtd/nand/lpc32xx_mlc.c
index a94facb..fd1df5e 100644
--- a/drivers/mtd/nand/lpc32xx_mlc.c
+++ b/drivers/mtd/nand/lpc32xx_mlc.c
@@ -672,11 +672,6 @@ static int lpc32xx_nand_probe(struct platform_device *pdev)
 	}
 
 	rc = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (rc == NULL) {
-		dev_err(&pdev->dev, "No memory resource found for device!\r\n");
-		return -ENXIO;
-	}
-
 	host->io_base = devm_ioremap_resource(&pdev->dev, rc);
 	if (IS_ERR(host->io_base))
 		return PTR_ERR(host->io_base);
-- 
1.7.10.4

