Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933854Ab3GWSCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:02:37 -0400
Received: from sauhun.de ([89.238.76.85]:58696 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933845Ab3GWSCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:02:33 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Subject: [PATCH 04/27] drivers/dma: don't check resource with devm_ioremap_resource
Date: Tue, 23 Jul 2013 20:01:37 +0200
Message-Id: <1374602524-3398-5-git-send-email-wsa@the-dreams.de>
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

 drivers/dma/mmp_pdma.c |    3 ---
 drivers/dma/mmp_tdma.c |    3 ---
 2 files changed, 6 deletions(-)

diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
index c26699f..7eba967 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -778,9 +778,6 @@ static int mmp_pdma_probe(struct platform_device *op)
 	pdev->dev = &op->dev;
 
 	iores = platform_get_resource(op, IORESOURCE_MEM, 0);
-	if (!iores)
-		return -EINVAL;
-
 	pdev->base = devm_ioremap_resource(pdev->dev, iores);
 	if (IS_ERR(pdev->base))
 		return PTR_ERR(pdev->base);
diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
index 9b93665..1f1885a 100644
--- a/drivers/dma/mmp_tdma.c
+++ b/drivers/dma/mmp_tdma.c
@@ -549,9 +549,6 @@ static int mmp_tdma_probe(struct platform_device *pdev)
 	}
 
 	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!iores)
-		return -EINVAL;
-
 	tdev->base = devm_ioremap_resource(&pdev->dev, iores);
 	if (IS_ERR(tdev->base))
 		return PTR_ERR(tdev->base);
-- 
1.7.10.4

