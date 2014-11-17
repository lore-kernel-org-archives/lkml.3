Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbaKQNw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:52:58 -0500
Received: from down.free-electrons.com ([37.187.137.238]:49106 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753021AbaKQNpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:45:40 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v5 46/61] dmaengine: pch-dma: Rename device_control
Date: Mon, 17 Nov 2014 14:42:40 +0100
Message-Id: <1416231775-31252-47-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the device_control callback of the Intel PCH DMA driver to terminate_all
since it's all it's really doing. That will eventually be used to retrieve
slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/pch_dma.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 9f9ca9fe5ce6..d03b9c93ccab 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -665,16 +665,12 @@ err_desc_get:
 	return NULL;
 }
 
-static int pd_device_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-			     unsigned long arg)
+static int pd_device_terminate_all(struct dma_chan *chan)
 {
 	struct pch_dma_chan *pd_chan = to_pd_chan(chan);
 	struct pch_dma_desc *desc, *_d;
 	LIST_HEAD(list);
 
-	if (cmd != DMA_TERMINATE_ALL)
-		return -ENXIO;
-
 	spin_lock_irq(&pd_chan->lock);
 
 	pdc_set_mode(&pd_chan->chan, DMA_CTL0_DISABLE);
@@ -932,7 +928,7 @@ static int pch_dma_probe(struct pci_dev *pdev,
 	pd->dma.device_tx_status = pd_tx_status;
 	pd->dma.device_issue_pending = pd_issue_pending;
 	pd->dma.device_prep_slave_sg = pd_prep_slave_sg;
-	pd->dma.device_control = pd_device_control;
+	pd->dma.device_terminate_all = pd_device_terminate_all;
 
 	err = dma_async_device_register(&pd->dma);
 	if (err) {
-- 
2.1.1

