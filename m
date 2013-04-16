Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997Ab3DPLKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 07:10:23 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36100 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab3DPLKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 07:10:21 -0400
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] media: davinci: vpbe: align the buffers size to page page size boundary
Date: Tue, 16 Apr 2013 16:40:01 +0530
Message-Id: <1366110601-18424-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

with recent commit with id 068a0df76023926af958a336a78bef60468d2033
which adds add length check for mmap, the application were failing to
mmap the buffers.

This patch aligns the the buffer size to page size boundary for both
capture and display driver so the it pass the check.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/platform/davinci/vpbe_display.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 1802f11..ff8fe76 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -258,7 +258,7 @@ vpbe_buffer_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 		*nbuffers = layer->numbuffers = VPBE_DEFAULT_NUM_BUFS;
 
 	*nplanes = 1;
-	sizes[0] = layer->pix_fmt.sizeimage;
+	sizes[0] = PAGE_ALIGN(layer->pix_fmt.sizeimage);
 	alloc_ctxs[0] = layer->alloc_ctx;
 
 	return 0;
-- 
1.7.4.1

