Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab3EUOaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 10:30:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37115 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab3EUOaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 10:30:11 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] videobuf2-core: call __setup_offsets only for mmap memory type
Date: Tue, 21 May 2013 16:30:05 +0200
Message-Id: <1369146605-10648-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.8.2.rc2
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__setup_offsets fills the v4l2_planes' mem_offset fields, which is only valid
for V4L2_MEMORY_MMAP type buffers. For V4L2_MEMORY_DMABUF and _USERPTR buffers,
this incorrectly overwrites the fd and userptr fields.

Reported-by: Michael Olbrich <m.olbrich@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/v4l2-core/videobuf2-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 5f7ae44..9e12f75 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -241,7 +241,8 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 		q->bufs[q->num_buffers + buffer] = vb;
 	}
 
-	__setup_offsets(q, buffer);
+	if (memory == V4L2_MEMORY_MMAP)
+		__setup_offsets(q, buffer);
 
 	dprintk(1, "Allocated %d buffers, %d plane(s) each\n",
 			buffer, num_planes);
-- 
1.8.2.rc2

