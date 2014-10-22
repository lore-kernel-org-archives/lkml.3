Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469AbaJVP56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:57:58 -0400
Received: from down.free-electrons.com ([37.187.137.238]:54159 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754932AbaJVPp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:45:57 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 46/59] dmaengine: pch-dma: Rename device_control
Date: Wed, 22 Oct 2014 17:44:00 +0200
Message-Id: <1413992653-21963-47-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
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

