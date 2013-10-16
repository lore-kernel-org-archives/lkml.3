Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761413Ab3JPRW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:22:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:32753 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761321Ab3JPRWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:22:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="417851300"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
        linux@arm.linux.org.uk, Vinod Koul <vinod.koul@intel.com>,
        Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 13/28] dmaengine: ioat: use DMA_COMPLETE for dma completion status
Date: Wed, 16 Oct 2013 21:58:31 +0530
Message-Id: <1381940926-25564-14-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/ioat/dma.c    |    4 ++--
 drivers/dma/ioat/dma_v3.c |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index 5ff6fc1..a0f0fce 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -733,7 +733,7 @@ ioat_dma_tx_status(struct dma_chan *c, dma_cookie_t cookie,
 	enum dma_status ret;
 
 	ret = dma_cookie_status(c, cookie, txstate);
-	if (ret == DMA_SUCCESS)
+	if (ret == DMA_COMPLETE)
 		return ret;
 
 	device->cleanup_fn((unsigned long) c);
@@ -859,7 +859,7 @@ int ioat_dma_self_test(struct ioatdma_device *device)
 
 	if (tmo == 0 ||
 	    dma->device_tx_status(dma_chan, cookie, NULL)
-					!= DMA_SUCCESS) {
+					!= DMA_COMPLETE) {
 		dev_err(dev, "Self-test copy timed out, disabling\n");
 		err = -ENODEV;
 		goto unmap_dma;
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index d8ececa..806b4ce 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -807,7 +807,7 @@ ioat3_tx_status(struct dma_chan *c, dma_cookie_t cookie,
 	enum dma_status ret;
 
 	ret = dma_cookie_status(c, cookie, txstate);
-	if (ret == DMA_SUCCESS)
+	if (ret == DMA_COMPLETE)
 		return ret;
 
 	ioat3_cleanup(ioat);
@@ -1468,7 +1468,7 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
 
 	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
 
-	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_SUCCESS) {
+	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
 		dev_err(dev, "Self-test xor timed out\n");
 		err = -ENODEV;
 		goto dma_unmap;
@@ -1530,7 +1530,7 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
 
 	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
 
-	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_SUCCESS) {
+	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
 		dev_err(dev, "Self-test validate timed out\n");
 		err = -ENODEV;
 		goto dma_unmap;
@@ -1577,7 +1577,7 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
 
 	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
 
-	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_SUCCESS) {
+	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
 		dev_err(dev, "Self-test 2nd validate timed out\n");
 		err = -ENODEV;
 		goto dma_unmap;
-- 
1.7.0.4

