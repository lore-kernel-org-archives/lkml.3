Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbaGKQNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:13:35 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:60572 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbaGKQNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:13:33 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2 1/6] dmaengine: Update documentation for inline wrappers
Date: Fri, 11 Jul 2014 18:13:23 +0200
Message-Id: <1405095208-14642-1-git-send-email-geert+renesas@glider.be>
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
v2:
  - Added one more conversion in the textual explanation.
---
 Documentation/dmaengine.txt | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/Documentation/dmaengine.txt b/Documentation/dmaengine.txt
index 87d3f192e160..11fb87ff6cd0 100644
--- a/Documentation/dmaengine.txt
+++ b/Documentation/dmaengine.txt
@@ -84,21 +84,21 @@ The slave DMA usage consists of following steps:
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
 
    The peripheral driver is expected to have mapped the scatterlist for
-   the DMA operation prior to calling device_prep_slave_sg, and must
+   the DMA operation prior to calling dmaengine_prep_slave_sg(), and must
    keep the scatterlist mapped until the DMA operation has completed.
    The scatterlist must be mapped using the DMA struct device.
    If a mapping needs to be synchronized later, dma_sync_*_for_*() must be
@@ -109,8 +109,7 @@ The slave DMA usage consists of following steps:
 	if (nr_sg == 0)
 		/* error */
 
-	desc = chan->device->device_prep_slave_sg(chan, sgl, nr_sg,
-			direction, flags);
+	desc = dmaengine_prep_slave_sg(chan, sgl, nr_sg, direction, flags);
 
    Once a descriptor has been obtained, the callback information can be
    added and the descriptor must then be submitted.  Some DMA engine
@@ -190,11 +189,11 @@ Further APIs:
    description of this API.
 
    This can be used in conjunction with dma_async_is_complete() and
-   the cookie returned from 'descriptor->submit()' to check for
+   the cookie returned from dmaengine_submit() to check for
    completion of a specific DMA transaction.
 
    Note:
 	Not all DMA engine drivers can return reliable information for
 	a running DMA channel.  It is recommended that DMA engine users
-	pause or stop (via dmaengine_terminate_all) the channel before
+	pause or stop (via dmaengine_terminate_all()) the channel before
 	using this API.
-- 
1.9.1

