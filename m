Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbaJLUow (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 16:44:52 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:39898 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbaJLUkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 16:40:55 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 02/15] media: davinci: vpbe: drop buf_init() callback
Date: Sun, 12 Oct 2014 21:40:32 +0100
Message-Id: <1413146445-7304-3-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch drops the buf_init() callback as init
of buf list is not required.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpbe_display.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index ff9eac4..e2bda17 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -322,15 +322,6 @@ static void vpbe_wait_finish(struct vb2_queue *vq)
 	mutex_lock(&layer->opslock);
 }
 
-static int vpbe_buffer_init(struct vb2_buffer *vb)
-{
-	struct vpbe_disp_buffer *buf = container_of(vb,
-					struct vpbe_disp_buffer, vb);
-
-	INIT_LIST_HEAD(&buf->list);
-	return 0;
-}
-
 static int vpbe_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct vpbe_layer *layer = vb2_get_drv_priv(vq);
@@ -405,7 +396,6 @@ static struct vb2_ops video_qops = {
 	.queue_setup = vpbe_buffer_queue_setup,
 	.wait_prepare = vpbe_wait_prepare,
 	.wait_finish = vpbe_wait_finish,
-	.buf_init = vpbe_buffer_init,
 	.buf_prepare = vpbe_buffer_prepare,
 	.start_streaming = vpbe_start_streaming,
 	.stop_streaming = vpbe_stop_streaming,
-- 
1.9.1

