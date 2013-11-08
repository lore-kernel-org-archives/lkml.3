Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab3KHKIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 05:08:52 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:37987 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab3KHKIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 05:08:50 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org (open list:VIDEOBUF2 FRAMEWORK),
        linux-kernel@vger.kernel.org (open list), sylvester.nawrocki@gmail.com,
        hverkuil@xs4all.nl
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] vb2: Return 0 when streamon and streamoff are already on/off
Date: Fri,  8 Nov 2013 11:08:45 +0100
Message-Id: <1383905325-6163-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the doc:

If VIDIOC_STREAMON is called when streaming is already in progress,
or if VIDIOC_STREAMOFF is called when streaming is already stopped,
then the ioctl does nothing and 0 is returned.

The current implementation was returning -EINVAL instead.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index c979946..a3c8eff 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1695,8 +1695,8 @@ int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 	}
 
 	if (q->streaming) {
-		dprintk(1, "streamon: already streaming\n");
-		return -EBUSY;
+		dprintk(3, "streamon successful: already streaming\n");
+		return 0;
 	}
 
 	/*
@@ -1752,8 +1752,8 @@ int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 	}
 
 	if (!q->streaming) {
-		dprintk(1, "streamoff: not streaming\n");
-		return -EINVAL;
+		dprintk(3, "streamoff successful: not streaming\n");
+		return 0;
 	}
 
 	/*
-- 
1.8.4.rc3

