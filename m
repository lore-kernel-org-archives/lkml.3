Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab3DNVVH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 17:21:07 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:53682 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab3DNVVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 17:21:05 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] drivers: dma: Use devm_request_and_ioremap
Date: Fri, 12 Apr 2013 04:08:08 +0300
Message-Id: <1365728888-24161-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_request_and_ioremap function which provides more consistent error
handling.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 drivers/dma/txx9dmac.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/dma/txx9dmac.c b/drivers/dma/txx9dmac.c
index 913f55c..471f9f1 100644
--- a/drivers/dma/txx9dmac.c
+++ b/drivers/dma/txx9dmac.c
@@ -1217,11 +1217,7 @@ static int __init txx9dmac_probe(struct platform_device *pdev)
 	if (!ddev)
 		return -ENOMEM;
 
-	if (!devm_request_mem_region(&pdev->dev, io->start, resource_size(io),
-				     dev_name(&pdev->dev)))
-		return -EBUSY;
-
-	ddev->regs = devm_ioremap(&pdev->dev, io->start, resource_size(io));
+	ddev->regs = devm_request_and_ioremap(&pdev->dev, io);
 	if (!ddev->regs)
 		return -ENOMEM;
 	ddev->have_64bit_regs = pdata->have_64bit_regs;
-- 
1.7.9.5

