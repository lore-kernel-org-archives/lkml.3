Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbaKQNwD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:52:03 -0500
Received: from down.free-electrons.com ([37.187.137.238]:49106 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753173AbaKQNpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:45:43 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v5 49/61] dmaengine: rapidio: tsi721: Rename device_control
Date: Mon, 17 Nov 2014 14:42:43 +0100
Message-Id: <1416231775-31252-50-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the device_control callback of the TXX9 DMA driver to terminate_all
since it's all it's really doing. That will eventually be used to retrieve
slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/rapidio/devices/tsi721_dma.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/rapidio/devices/tsi721_dma.c b/drivers/rapidio/devices/tsi721_dma.c
index f64c5decb747..47295940a868 100644
--- a/drivers/rapidio/devices/tsi721_dma.c
+++ b/drivers/rapidio/devices/tsi721_dma.c
@@ -815,8 +815,7 @@ struct dma_async_tx_descriptor *tsi721_prep_rio_sg(struct dma_chan *dchan,
 	return txd;
 }
 
-static int tsi721_device_control(struct dma_chan *dchan, enum dma_ctrl_cmd cmd,
-			     unsigned long arg)
+static int tsi721_terminate_all(struct dma_chan *dchan)
 {
 	struct tsi721_bdma_chan *bdma_chan = to_tsi721_chan(dchan);
 	struct tsi721_tx_desc *desc, *_d;
@@ -825,9 +824,6 @@ static int tsi721_device_control(struct dma_chan *dchan, enum dma_ctrl_cmd cmd,
 
 	dev_dbg(dchan->device->dev, "%s: Entry\n", __func__);
 
-	if (cmd != DMA_TERMINATE_ALL)
-		return -ENOSYS;
-
 	spin_lock_bh(&bdma_chan->lock);
 
 	bdma_chan->active = false;
@@ -901,7 +897,7 @@ int tsi721_register_dma(struct tsi721_device *priv)
 	mport->dma.device_tx_status = tsi721_tx_status;
 	mport->dma.device_issue_pending = tsi721_issue_pending;
 	mport->dma.device_prep_slave_sg = tsi721_prep_rio_sg;
-	mport->dma.device_control = tsi721_device_control;
+	mport->dma.device_terminate_all = tsi721_terminate_all;
 
 	err = dma_async_device_register(&mport->dma);
 	if (err)
-- 
2.1.1

