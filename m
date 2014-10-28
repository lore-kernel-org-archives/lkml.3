Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbaJ1Vaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:30:55 -0400
Received: from down.free-electrons.com ([37.187.137.238]:37133 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932117AbaJ1Vav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:30:51 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v4 46/58] dmaengine: td: Rename device_control
Date: Tue, 28 Oct 2014 22:26:01 +0100
Message-Id: <1414531573-18807-47-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414531573-18807-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1414531573-18807-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the device_control callback of the Timberdal DMA driver to terminate_all
since it's all it's really doing. That will eventually be used to retrieve
slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/timb_dma.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index 4506a7b4f972..0536a75354d6 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -561,8 +561,7 @@ static struct dma_async_tx_descriptor *td_prep_slave_sg(struct dma_chan *chan,
 	return &td_desc->txd;
 }
 
-static int td_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-		      unsigned long arg)
+static int td_terminate_all(struct dma_chan *chan)
 {
 	struct timb_dma_chan *td_chan =
 		container_of(chan, struct timb_dma_chan, chan);
@@ -570,9 +569,6 @@ static int td_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 
 	dev_dbg(chan2dev(chan), "%s: Entry\n", __func__);
 
-	if (cmd != DMA_TERMINATE_ALL)
-		return -ENXIO;
-
 	/* first the easy part, put the queue into the free list */
 	spin_lock_bh(&td_chan->lock);
 	list_for_each_entry_safe(td_desc, _td_desc, &td_chan->queue,
@@ -697,7 +693,7 @@ static int td_probe(struct platform_device *pdev)
 	dma_cap_set(DMA_SLAVE, td->dma.cap_mask);
 	dma_cap_set(DMA_PRIVATE, td->dma.cap_mask);
 	td->dma.device_prep_slave_sg = td_prep_slave_sg;
-	td->dma.device_control = td_control;
+	td->dma.device_terminate_all = td_terminate_all;
 
 	td->dma.dev = &pdev->dev;
 
-- 
2.1.1

