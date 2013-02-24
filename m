Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406Ab3BXXQi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 18:16:38 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:51494 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759351Ab3BXXQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 18:16:36 -0500
From: Syam Sidhardhan <syamsidhardh@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: syamsidhardh@gmail.com, vinod.koul@intel.com, djbw@fb.com
Subject: [PATCH] dma: imx-dma: Remove redundant NULL check before kfree
Date: Mon, 25 Feb 2013 04:46:26 +0530
Message-Id: <1361747786-29597-1-git-send-email-s.syam@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kfree on NULL pointer is a no-op.

Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
---
 drivers/dma/imx-dma.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 70b8975..0988583 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -859,8 +859,7 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_cyclic(
 
 	desc = list_first_entry(&imxdmac->ld_free, struct imxdma_desc, node);
 
-	if (imxdmac->sg_list)
-		kfree(imxdmac->sg_list);
+	kfree(imxdmac->sg_list);
 
 	imxdmac->sg_list = kcalloc(periods + 1,
 			sizeof(struct scatterlist), GFP_KERNEL);
-- 
1.7.9.5

