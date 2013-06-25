Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab3FYI4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:56:37 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:49375 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab3FYIzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:55:55 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 5/6] crypto: ux500: use dmaengine_prep_slave_sg API
Date: Tue, 25 Jun 2013 10:54:48 +0200
Message-Id: <1372150489-25594-6-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1372150489-25594-1-git-send-email-fabio.baltieri@linaro.org>
References: <1372150489-25594-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dmaengine_prep_slave_sg inline function instead of going through the
structures manually.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/crypto/ux500/cryp/cryp_core.c | 20 ++++++++++----------
 drivers/crypto/ux500/hash/hash_core.c |  4 ++--
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 1957c18..0cd89df 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -553,10 +553,10 @@ static int cryp_set_dma_transfer(struct cryp_ctx *ctx,
 		dev_dbg(ctx->device->dev, "[%s]: Setting up DMA for buffer "
 			"(TO_DEVICE)", __func__);
 
-		desc = channel->device->device_prep_slave_sg(channel,
-					     ctx->device->dma.sg_src,
-					     ctx->device->dma.sg_src_len,
-					     direction, DMA_CTRL_ACK, NULL);
+		desc = dmaengine_prep_slave_sg(channel,
+				ctx->device->dma.sg_src,
+				ctx->device->dma.sg_src_len,
+				direction, DMA_CTRL_ACK);
 		break;
 
 	case DMA_FROM_DEVICE:
@@ -577,12 +577,12 @@ static int cryp_set_dma_transfer(struct cryp_ctx *ctx,
 		dev_dbg(ctx->device->dev, "[%s]: Setting up DMA for buffer "
 			"(FROM_DEVICE)", __func__);
 
-		desc = channel->device->device_prep_slave_sg(channel,
-					     ctx->device->dma.sg_dst,
-					     ctx->device->dma.sg_dst_len,
-					     direction,
-					     DMA_CTRL_ACK |
-					     DMA_PREP_INTERRUPT, NULL);
+		desc = dmaengine_prep_slave_sg(channel,
+				ctx->device->dma.sg_dst,
+				ctx->device->dma.sg_dst_len,
+				direction,
+				DMA_CTRL_ACK |
+				DMA_PREP_INTERRUPT);
 
 		desc->callback = cryp_dma_out_callback;
 		desc->callback_param = ctx;
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 8c2817804..3527777 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -180,9 +180,9 @@ static int hash_set_dma_transfer(struct hash_ctx *ctx, struct scatterlist *sg,
 
 	dev_dbg(ctx->device->dev, "[%s]: Setting up DMA for buffer "
 			"(TO_DEVICE)", __func__);
-	desc = channel->device->device_prep_slave_sg(channel,
+	desc = dmaengine_prep_slave_sg(channel,
 			ctx->device->dma.sg, ctx->device->dma.sg_len,
-			direction, DMA_CTRL_ACK | DMA_PREP_INTERRUPT, NULL);
+			direction, DMA_CTRL_ACK | DMA_PREP_INTERRUPT);
 	if (!desc) {
 		dev_err(ctx->device->dev,
 			"[%s]: device_prep_slave_sg() failed!", __func__);
-- 
1.8.2

