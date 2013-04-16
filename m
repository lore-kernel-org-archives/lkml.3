Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935935Ab3DPKvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 06:51:48 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:35777 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934702Ab3DPKvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 06:51:46 -0400
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] media: davinci: vpif: allign the buffers size to page page size boundary
Date: Tue, 16 Apr 2013 16:21:33 +0530
Message-Id: <1366109493-27874-1-git-send-email-prabhakar.csengg@gmail.com>
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
 drivers/media/platform/davinci/vpif_capture.c |    1 +
 drivers/media/platform/davinci/vpif_display.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 5f98df1..25981d6 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -183,6 +183,7 @@ static int vpif_buffer_queue_setup(struct vb2_queue *vq,
 		*nbuffers = config_params.min_numbuffers;
 
 	*nplanes = 1;
+	size = PAGE_ALIGN(size);
 	sizes[0] = size;
 	alloc_ctxs[0] = common->alloc_ctx;
 
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 1b3fb5c..3414715 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -162,6 +162,7 @@ static int vpif_buffer_queue_setup(struct vb2_queue *vq,
 			*nbuffers = config_params.min_numbuffers;
 
 	*nplanes = 1;
+	size = PAGE_ALIGN(size);
 	sizes[0] = size;
 	alloc_ctxs[0] = common->alloc_ctx;
 	return 0;
-- 
1.7.4.1

