Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbaJLUlE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 16:41:04 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:53464 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaJLUk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 16:40:58 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 04/15] media: davinci: vpbe: drop buf_cleanup() callback
Date: Sun, 12 Oct 2014 21:40:34 +0100
Message-Id: <1413146445-7304-5-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch drops buf_cleanup() callback as this callback
is never called with buffer state active.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpbe_display.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 6f9599d..491b832 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -285,29 +285,6 @@ static void vpbe_buffer_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&disp->dma_queue_lock, flags);
 }
 
-/*
- * vpbe_buf_cleanup()
- * This function is called from the vb2 layer to free memory allocated to
- * the buffers
- */
-static void vpbe_buf_cleanup(struct vb2_buffer *vb)
-{
-	/* Get the file handle object and layer object */
-	struct vpbe_layer *layer = vb2_get_drv_priv(vb->vb2_queue);
-	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
-	struct vpbe_disp_buffer *buf = container_of(vb,
-					struct vpbe_disp_buffer, vb);
-	unsigned long flags;
-
-	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
-			"vpbe_buf_cleanup\n");
-
-	spin_lock_irqsave(&layer->irqlock, flags);
-	if (vb->state == VB2_BUF_STATE_ACTIVE)
-		list_del_init(&buf->list);
-	spin_unlock_irqrestore(&layer->irqlock, flags);
-}
-
 static int vpbe_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct vpbe_layer *layer = vb2_get_drv_priv(vq);
@@ -385,7 +362,6 @@ static struct vb2_ops video_qops = {
 	.buf_prepare = vpbe_buffer_prepare,
 	.start_streaming = vpbe_start_streaming,
 	.stop_streaming = vpbe_stop_streaming,
-	.buf_cleanup = vpbe_buf_cleanup,
 	.buf_queue = vpbe_buffer_queue,
 };
 
-- 
1.9.1

