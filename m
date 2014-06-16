Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaFPNNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:13:33 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:45826 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbaFPNNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:13:31 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] dmaengine: Update documentation for inline wrappers
Date: Mon, 16 Jun 2014 15:13:24 +0200
Message-Id: <1402924404-32211-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the last few years, several inline wrappers for DMA operations have
been introduced:
  - commit 16052827d98fbc13c31ebad560af4bd53e2b4dd5 ("dmaengine/dma_slave:
    introduce inline wrappers"),
  - commit a14acb4ac2a1486f6633c55eb7f7ded07f3ec9fc ("DMAEngine: add
    dmaengine_prep_interleaved_dma wrapper for interleaved api"),
  - commit 6e3ecaf0ad49de0bed829d409a164e7107c02993 ("dmaengine: add
    wrapper functions for device control functions").

Update the documentation to use the wrappers.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/dmaengine.txt | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/Documentation/dmaengine.txt b/Documentation/dmaengine.txt
index 879b6e31e2da..2def665baf6e 100644
--- a/Documentation/dmaengine.txt
+++ b/Documentation/dmaengine.txt
@@ -84,16 +84,16 @@ The slave DMA usage consists of following steps:
    the given transaction.
 
    Interface:
-	struct dma_async_tx_descriptor *(*chan->device->device_prep_slave_sg)(
+	struct dma_async_tx_descriptor *dmaengine_prep_slave_sg(
 		struct dma_chan *chan, struct scatterlist *sgl,
 		unsigned int sg_len, enum dma_data_direction direction,
 		unsigned long flags);
 
-	struct dma_async_tx_descriptor *(*chan->device->device_prep_dma_cyclic)(
+	struct dma_async_tx_descriptor *dmaengine_prep_dma_cyclic(
 		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
 		size_t period_len, enum dma_data_direction direction);
 
-	struct dma_async_tx_descriptor *(*device_prep_interleaved_dma)(
+	struct dma_async_tx_descriptor *dmaengine_prep_interleaved_dma(
 		struct dma_chan *chan, struct dma_interleaved_template *xt,
 		unsigned long flags);
 
@@ -107,8 +107,7 @@ The slave DMA usage consists of following steps:
 	if (nr_sg == 0)
 		/* error */
 
-	desc = chan->device->device_prep_slave_sg(chan, sgl, nr_sg,
-			direction, flags);
+	desc = dmaengine_prep_slave_sg(chan, sgl, nr_sg, direction, flags);
 
    Once a descriptor has been obtained, the callback information can be
    added and the descriptor must then be submitted.  Some DMA engine
@@ -188,7 +187,7 @@ Further APIs:
    description of this API.
 
    This can be used in conjunction with dma_async_is_complete() and
-   the cookie returned from 'descriptor->submit()' to check for
+   the cookie returned from dmaengine_submit() to check for
    completion of a specific DMA transaction.
 
    Note:
-- 
1.9.1

