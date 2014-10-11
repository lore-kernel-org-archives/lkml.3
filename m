Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaJKQOx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 12:14:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:2781 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbaJKQOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 12:14:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="398750156"
From: Vinod Koul <vinod.koul@intel.com>
To: dmaengine@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/12] [media] V4L2: mx3_camer: use dmaengine_pause() API
Date: Sat, 11 Oct 2014 21:10:31 +0530
Message-Id: <1413042040-28222-3-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1413041973-28146-1-git-send-email-vinod.koul@intel.com>
References: <1413041973-28146-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drivers should use dmaengine_pause() API instead of
accessing the device_control which will be deprecated soon

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/media/platform/soc_camera/mx3_camera.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 83315df..7696a87 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -415,10 +415,8 @@ static void mx3_stop_streaming(struct vb2_queue *q)
 	struct mx3_camera_buffer *buf, *tmp;
 	unsigned long flags;
 
-	if (ichan) {
-		struct dma_chan *chan = &ichan->dma_chan;
-		chan->device->device_control(chan, DMA_PAUSE, 0);
-	}
+	if (ichan)
+		dmaengine_pause(&ichan->dma_chan);
 
 	spin_lock_irqsave(&mx3_cam->lock, flags);
 
-- 
1.7.0.4

