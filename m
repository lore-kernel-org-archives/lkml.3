Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab3EAQBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 12:01:24 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60398 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761657Ab3EAQBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 12:01:16 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, vinod.koul@intel.com,
        per.forlin@stericsson.com, rabin@rab.in,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] dmaengine: ste_dma40: Remove redundant address fetching function
Date: Wed,  1 May 2013 17:01:10 +0100
Message-Id: <1367424070-326-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addresses are now stored in local data structures and are easy to
obtain, thus a specialist function used to fetch them is now surplus
to requirement.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c |   18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index f00a428..18d9e12 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2250,24 +2250,6 @@ err:
 	return NULL;
 }
 
-static dma_addr_t
-d40_get_dev_addr(struct d40_chan *chan, enum dma_transfer_direction direction)
-{
-	struct stedma40_platform_data *plat = chan->base->plat_data;
-	struct stedma40_chan_cfg *cfg = &chan->dma_cfg;
-	dma_addr_t addr = 0;
-
-	if (chan->runtime_addr)
-		return chan->runtime_addr;
-
-	if (direction == DMA_DEV_TO_MEM)
-		addr = plat->dev_rx[cfg->dev_type];
-	else if (direction == DMA_MEM_TO_DEV)
-		addr = plat->dev_tx[cfg->dev_type];
-
-	return addr;
-}
-
 static struct dma_async_tx_descriptor *
 d40_prep_sg(struct dma_chan *dchan, struct scatterlist *sg_src,
 	    struct scatterlist *sg_dst, unsigned int sg_len,
-- 
1.7.10.4

