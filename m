Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761513Ab3JPRXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:23:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:53147 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761445Ab3JPRXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:23:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="417851317"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
        linux@arm.linux.org.uk, Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 17/28] dmaengine: mv_xor: use DMA_COMPLETE for dma completion status
Date: Wed, 16 Oct 2013 21:58:35 +0530
Message-Id: <1381940926-25564-18-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/dma/mv_xor.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 536dcb8..8d5bce9 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -749,7 +749,7 @@ static enum dma_status mv_xor_status(struct dma_chan *chan,
 	enum dma_status ret;
 
 	ret = dma_cookie_status(chan, cookie, txstate);
-	if (ret == DMA_SUCCESS) {
+	if (ret == DMA_COMPLETE) {
 		mv_xor_clean_completed_slots(mv_chan);
 		return ret;
 	}
@@ -874,7 +874,7 @@ static int mv_xor_memcpy_self_test(struct mv_xor_chan *mv_chan)
 	msleep(1);
 
 	if (mv_xor_status(dma_chan, cookie, NULL) !=
-	    DMA_SUCCESS) {
+	    DMA_COMPLETE) {
 		dev_err(dma_chan->device->dev,
 			"Self-test copy timed out, disabling\n");
 		err = -ENODEV;
@@ -968,7 +968,7 @@ mv_xor_xor_self_test(struct mv_xor_chan *mv_chan)
 	msleep(8);
 
 	if (mv_xor_status(dma_chan, cookie, NULL) !=
-	    DMA_SUCCESS) {
+	    DMA_COMPLETE) {
 		dev_err(dma_chan->device->dev,
 			"Self-test xor timed out, disabling\n");
 		err = -ENODEV;
-- 
1.7.0.4

