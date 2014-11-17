Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaKQNpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:45:10 -0500
Received: from down.free-electrons.com ([37.187.137.238]:48947 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752477AbaKQNpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:45:04 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v5 02/61] crypto: ux500: Use dmaengine_terminate_all API
Date: Mon, 17 Nov 2014 14:41:56 +0100
Message-Id: <1416231775-31252-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are removing the dmaengine_device_control API, that shouldn't even have been
exposed in the first place. Change the callers to use the proper API.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/crypto/ux500/cryp/cryp_core.c | 4 ++--
 drivers/crypto/ux500/hash/hash_core.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 92105f3dc8e0..75bd0f1e9a94 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -606,12 +606,12 @@ static void cryp_dma_done(struct cryp_ctx *ctx)
 	dev_dbg(ctx->device->dev, "[%s]: ", __func__);
 
 	chan = ctx->device->dma.chan_mem2cryp;
-	dmaengine_device_control(chan, DMA_TERMINATE_ALL, 0);
+	dmaengine_terminate_all(chan);
 	dma_unmap_sg(chan->device->dev, ctx->device->dma.sg_src,
 		     ctx->device->dma.sg_src_len, DMA_TO_DEVICE);
 
 	chan = ctx->device->dma.chan_cryp2mem;
-	dmaengine_device_control(chan, DMA_TERMINATE_ALL, 0);
+	dmaengine_terminate_all(chan);
 	dma_unmap_sg(chan->device->dev, ctx->device->dma.sg_dst,
 		     ctx->device->dma.sg_dst_len, DMA_FROM_DEVICE);
 }
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 1c73f4fbc252..48bdc5df7b3b 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -202,7 +202,7 @@ static void hash_dma_done(struct hash_ctx *ctx)
 	struct dma_chan *chan;
 
 	chan = ctx->device->dma.chan_mem2hash;
-	dmaengine_device_control(chan, DMA_TERMINATE_ALL, 0);
+	dmaengine_terminate_all(chan);
 	dma_unmap_sg(chan->device->dev, ctx->device->dma.sg,
 		     ctx->device->dma.sg_len, DMA_TO_DEVICE);
 }
-- 
2.1.1

