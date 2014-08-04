Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbaHDD0A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 23:26:00 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:62970 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaHDDZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 23:25:58 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: udovdh@xs4all.nl
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] v4l2: Change call of function in videobuf2-core.c
Date: Sun,  3 Aug 2014 23:25:51 -0400
Message-Id: <1407122751-30689-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the call of vb2_buffer_core to use VB2_BUFFER_STATE_ACTIVE
inside the for instead of not setting in correctly to VB2_BUFFER_STATE_ERROR.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 7c4489c..08e478b 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2115,7 +2115,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
 		for (i = 0; i < q->num_buffers; ++i)
 			if (q->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
-				vb2_buffer_done(q->bufs[i], VB2_BUF_STATE_ERROR);
+				vb2_buffer_done(q->bufs[i], VB2_BUF_STATE_ACTIVE);
 		/* Must be zero now */
 		WARN_ON(atomic_read(&q->owned_by_drv_count));
 	}
-- 
1.9.1

