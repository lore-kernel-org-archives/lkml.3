Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab3LMXQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 18:16:32 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:63120 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab3LMXQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 18:16:31 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/2] dma: pl08x: allow zero slave channels
Date: Sat, 14 Dec 2013 00:16:23 +0100
Message-Id: <1386976583-31395-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It might happen that a platform wants to use its DMA engine for
memcpy only, and then we have zero slave channels to initialize,
so allow the slave initialization to return zero.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/amba-pl08x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index ec4ee5c1fe9d..f68f1c1d560b 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -2167,7 +2167,7 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 	/* Register slave channels */
 	ret = pl08x_dma_init_virtual_channels(pl08x, &pl08x->slave,
 			pl08x->pd->num_slave_channels, true);
-	if (ret <= 0) {
+	if (ret < 0) {
 		dev_warn(&pl08x->adev->dev,
 			"%s failed to enumerate slave channels - %d\n",
 				__func__, ret);
-- 
1.8.3.1

