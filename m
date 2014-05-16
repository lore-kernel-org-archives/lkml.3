Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263AbaEPNlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:41:39 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:56555 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933242AbaEPNlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:41:35 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 30/49] media: davinci: vpif_capture: drop buf_cleanup() callback
Date: Fri, 16 May 2014 19:03:36 +0530
Message-Id: <1400247235-31434-33-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch drops buf_cleanup() callback as this callback
is never called with buffer state active.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_capture.c |   24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index fd384d0..6c5ff0f 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -201,29 +201,6 @@ static void vpif_buffer_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&common->irqlock, flags);
 }
 
-/**
- * vpif_buf_cleanup : Callback function to free buffer
- * @vb: ptr to vb2_buffer
- *
- * This function is called from the videobuf2 layer to free memory
- * allocated to  the buffers
- */
-static void vpif_buf_cleanup(struct vb2_buffer *vb)
-{
-	struct channel_obj *ch = vb2_get_drv_priv(vb->vb2_queue);
-	struct vpif_cap_buffer *buf = to_vpif_buffer(vb);
-	struct common_obj *common;
-	unsigned long flags;
-
-	common = &ch->common[VPIF_VIDEO_INDEX];
-
-	spin_lock_irqsave(&common->irqlock, flags);
-	if (vb->state == VB2_BUF_STATE_ACTIVE)
-		list_del_init(&buf->list);
-	spin_unlock_irqrestore(&common->irqlock, flags);
-
-}
-
 static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct vpif_capture_config *vpif_config_data =
@@ -370,7 +347,6 @@ static struct vb2_ops video_qops = {
 	.buf_prepare		= vpif_buffer_prepare,
 	.start_streaming	= vpif_start_streaming,
 	.stop_streaming		= vpif_stop_streaming,
-	.buf_cleanup		= vpif_buf_cleanup,
 	.buf_queue		= vpif_buffer_queue,
 };
 
-- 
1.7.9.5

