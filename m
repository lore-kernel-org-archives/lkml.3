Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbaLTKwN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 05:52:13 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:47570 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbaLTKsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 05:48:08 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Scott Jiang <scott.jiang.linux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 01/15] media: blackfin: bfin_capture: drop buf_init() callback
Date: Sat, 20 Dec 2014 16:17:28 +0530
Message-Id: <1419072462-3168-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419072462-3168-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1419072462-3168-1-git-send-email-prabhakar.csengg@gmail.com>
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
1.9.1

