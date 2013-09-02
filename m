Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220Ab3IBIJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:09:04 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:47051 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758161Ab3IBIJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:09:03 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: vinod.koul@intel.com, djbw@fb.com, sachin.kamat@linaro.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 1/1] dma: imx-dma: Remove redundant NULL check
Date: Mon,  2 Sep 2013 13:21:18 +0530
Message-Id: <1378108278-4051-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kfree on a NULL pointer is a no-op. Null pointer check is
not necessary.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/dma/imx-dma.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index ff2aab9..78f8ca5 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -805,10 +805,8 @@ static void imxdma_free_chan_resources(struct dma_chan *chan)
 	}
 	INIT_LIST_HEAD(&imxdmac->ld_free);
 
-	if (imxdmac->sg_list) {
-		kfree(imxdmac->sg_list);
-		imxdmac->sg_list = NULL;
-	}
+	kfree(imxdmac->sg_list);
+	imxdmac->sg_list = NULL;
 }
 
 static struct dma_async_tx_descriptor *imxdma_prep_slave_sg(
-- 
1.7.9.5

