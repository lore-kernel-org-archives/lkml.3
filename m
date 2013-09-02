Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab3IBImG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:42:06 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:54089 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab3IBImE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:42:04 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: vinod.koul@intel.com, sachin.kamat@linaro.org,
        Saeed Bishara <saeed@marvell.com>
Subject: [PATCH 1/1] dma: mv_xor: Fix incorrect error path
Date: Mon,  2 Sep 2013 13:54:20 +0530
Message-Id: <1378110260-2374-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return directly if memory allocation fails. There is no need
of dma_free_coherent().

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Saeed Bishara <saeed@marvell.com>
---
 drivers/dma/mv_xor.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 856ea77..536dcb8 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1036,10 +1036,8 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 	struct dma_device *dma_dev;
 
 	mv_chan = devm_kzalloc(&pdev->dev, sizeof(*mv_chan), GFP_KERNEL);
-	if (!mv_chan) {
-		ret = -ENOMEM;
-		goto err_free_dma;
-	}
+	if (!mv_chan)
+		return ERR_PTR(-ENOMEM);
 
 	mv_chan->idx = idx;
 	mv_chan->irq = irq;
-- 
1.7.9.5

