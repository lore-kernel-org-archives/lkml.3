Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431AbaJVP5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:57:34 -0400
Received: from down.free-electrons.com ([37.187.137.238]:54095 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753356AbaJVPqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:46:00 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 48/59] dmaengine: txx9: Rename device_control
Date: Wed, 22 Oct 2014 17:44:02 +0200
Message-Id: <1413992653-21963-49-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the device_control callback of the TXX9 DMA driver to terminate_all
since it's all it's really doing. That will eventually be used to retrieve
slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/txx9dmac.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/txx9dmac.c b/drivers/dma/txx9dmac.c
index 17686caf64d5..cb24d3efe3a2 100644
--- a/drivers/dma/txx9dmac.c
+++ b/drivers/dma/txx9dmac.c
@@ -901,17 +901,12 @@ txx9dmac_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	return &first->txd;
 }
 
-static int txx9dmac_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-			    unsigned long arg)
+static int txx9dmac_terminate_all(struct dma_chan *chan)
 {
 	struct txx9dmac_chan *dc = to_txx9dmac_chan(chan);
 	struct txx9dmac_desc *desc, *_desc;
 	LIST_HEAD(list);
 
-	/* Only supports DMA_TERMINATE_ALL */
-	if (cmd != DMA_TERMINATE_ALL)
-		return -EINVAL;
-
 	dev_vdbg(chan2dev(chan), "terminate_all\n");
 	spin_lock_bh(&dc->lock);
 
@@ -1109,7 +1104,7 @@ static int __init txx9dmac_chan_probe(struct platform_device *pdev)
 	dc->dma.dev = &pdev->dev;
 	dc->dma.device_alloc_chan_resources = txx9dmac_alloc_chan_resources;
 	dc->dma.device_free_chan_resources = txx9dmac_free_chan_resources;
-	dc->dma.device_control = txx9dmac_control;
+	dc->dma.device_terminate_all = txx9dmac_terminate_all;
 	dc->dma.device_tx_status = txx9dmac_tx_status;
 	dc->dma.device_issue_pending = txx9dmac_issue_pending;
 	if (pdata && pdata->memcpy_chan == ch) {
-- 
2.1.1

