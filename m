Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbbAVWVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 17:21:09 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:59290 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbbAVWUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 17:20:49 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Scott Jiang <scott.jiang.linux@gmail.com>,
        adi-buildroot-devel@lists.sourceforge.net
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 04/15] media: blackfin: bfin_capture: improve buf_prepare() callback
Date: Thu, 22 Jan 2015 22:18:37 +0000
Message-Id: <1421965128-10470-5-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421965128-10470-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1421965128-10470-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch improves the buf_prepare() callback.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index a997eac..8bd94a1 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -305,16 +305,12 @@ static int bcap_queue_setup(struct vb2_queue *vq,
 static int bcap_buffer_prepare(struct vb2_buffer *vb)
 {
 	struct bcap_device *bcap_dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct bcap_buffer *buf = to_bcap_vb(vb);
-	unsigned long size;
 
-	size = bcap_dev->fmt.sizeimage;
-	if (vb2_plane_size(vb, 0) < size) {
-		v4l2_err(&bcap_dev->v4l2_dev, "buffer too small (%lu < %lu)\n",
-				vb2_plane_size(vb, 0), size);
+	vb2_set_plane_payload(vb, 0, bcap_dev->fmt.sizeimage);
+	if (vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
 		return -EINVAL;
-	}
-	vb2_set_plane_payload(&buf->vb, 0, size);
+
+	vb->v4l2_buf.field = bcap_dev->fmt.field;
 
 	return 0;
 }
-- 
2.1.0

