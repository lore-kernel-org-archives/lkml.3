Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbbAVWVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 17:21:12 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60991 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbbAVWUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 17:20:49 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Scott Jiang <scott.jiang.linux@gmail.com>,
        adi-buildroot-devel@lists.sourceforge.net
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 01/15] media: blackfin: bfin_capture: drop buf_init() callback
Date: Thu, 22 Jan 2015 22:18:34 +0000
Message-Id: <1421965128-10470-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421965128-10470-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1421965128-10470-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch drops the buf_init() callback as init
of buf list is not required.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 3112844..d4eeae9 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -302,14 +302,6 @@ static int bcap_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static int bcap_buffer_init(struct vb2_buffer *vb)
-{
-	struct bcap_buffer *buf = to_bcap_vb(vb);
-
-	INIT_LIST_HEAD(&buf->list);
-	return 0;
-}
-
 static int bcap_buffer_prepare(struct vb2_buffer *vb)
 {
 	struct bcap_device *bcap_dev = vb2_get_drv_priv(vb->vb2_queue);
@@ -441,7 +433,6 @@ static void bcap_stop_streaming(struct vb2_queue *vq)
 
 static struct vb2_ops bcap_video_qops = {
 	.queue_setup            = bcap_queue_setup,
-	.buf_init               = bcap_buffer_init,
 	.buf_prepare            = bcap_buffer_prepare,
 	.buf_cleanup            = bcap_buffer_cleanup,
 	.buf_queue              = bcap_buffer_queue,
-- 
2.1.0

