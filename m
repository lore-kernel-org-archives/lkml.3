Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbbAVWX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 17:23:58 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:53206 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139AbbAVWVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 17:21:03 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Scott Jiang <scott.jiang.linux@gmail.com>,
        adi-buildroot-devel@lists.sourceforge.net
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 15/15] media: blackfin: bfin_capture: set v4l2 buffer sequence
Date: Thu, 22 Jan 2015 22:18:48 +0000
Message-Id: <1421965128-10470-16-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421965128-10470-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1421965128-10470-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch adds support to set the v4l2 buffer sequence.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index f154f25..65c1301 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -103,6 +103,8 @@ struct bcap_device {
 	struct completion comp;
 	/* prepare to stop */
 	bool stop;
+	/* vb2 buffer sequence counter */
+	unsigned sequence;
 };
 
 static const struct bcap_format bcap_formats[] = {
@@ -342,6 +344,8 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
 		goto err;
 	}
 
+	bcap_dev->sequence = 0;
+
 	reinit_completion(&bcap_dev->comp);
 	bcap_dev->stop = false;
 
@@ -412,6 +416,7 @@ static irqreturn_t bcap_isr(int irq, void *dev_id)
 			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 			ppi->err = false;
 		} else {
+			vb->v4l2_buf.sequence = bcap_dev->sequence++;
 			vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
 		}
 		bcap_dev->cur_frm = list_entry(bcap_dev->dma_queue.next,
-- 
2.1.0

