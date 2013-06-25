Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab3FYIz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:55:57 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:65232 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab3FYIzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:55:52 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 4/6] crypto: ux500: use dmaengine_device_control API
Date: Tue, 25 Jun 2013 10:54:47 +0200
Message-Id: <1372150489-25594-5-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1372150489-25594-1-git-send-email-fabio.baltieri@linaro.org>
References: <1372150489-25594-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dmaengine_device_control inline function instead of going through the
structures manually.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/crypto/ux500/cryp/cryp_core.c | 4 ++--
 drivers/crypto/ux500/hash/hash_core.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index b675bbd..1957c18 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -607,12 +607,12 @@ static void cryp_dma_done(struct cryp_ctx *ctx)
 	dev_dbg(ctx->device->dev, "[%s]: ", __func__);
 
 	chan = ctx->device->dma.chan_mem2cryp;
-	chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
+	dmaengine_device_control(chan, DMA_TERMINATE_ALL, 0);
 	dma_unmap_sg(chan->device->dev, ctx->device->dma.sg_src,
 		     ctx->device->dma.sg_src_len, DMA_TO_DEVICE);
 
 	chan = ctx->device->dma.chan_cryp2mem;
-	chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
+	dmaengine_device_control(chan, DMA_TERMINATE_ALL, 0);
 	dma_unmap_sg(chan->device->dev, ctx->device->dma.sg_dst,
 		     ctx->device->dma.sg_dst_len, DMA_FROM_DEVICE);
 }
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index dbf7b63..8c2817804 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -203,7 +203,7 @@ static void hash_dma_done(struct hash_ctx *ctx)
 	struct dma_chan *chan;
 
 	chan = ctx->device->dma.chan_mem2hash;
-	chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
+	dmaengine_device_control(chan, DMA_TERMINATE_ALL, 0);
 	dma_unmap_sg(chan->device->dev, ctx->device->dma.sg,
 			ctx->device->dma.sg_len, DMA_TO_DEVICE);
 
-- 
1.8.2

