Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbaKQKmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 05:42:24 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:34452 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaKQKmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 05:42:22 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: v4l2-subdev.h: drop the guard CONFIG_VIDEO_V4L2_SUBDEV_API for v4l2_subdev_get_try_*()
Date: Mon, 17 Nov 2014 10:41:53 +0000
Message-Id: <1416220913-5047-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch removes the guard CONFIG_VIDEO_V4L2_SUBDEV_API
for v4l2_subdev_get_try_*() functions.
In cases where a subdev using v4l2_subdev_get_try_*() calls
internally and the bridge using subdev pad ops which is
not MC aware forces to select MEDIA_CONTROLLER, as
VIDEO_V4L2_SUBDEV_API is dependent on it.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 include/media/v4l2-subdev.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 5860292..076ca11 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -642,7 +642,6 @@ struct v4l2_subdev_fh {
 #define to_v4l2_subdev_fh(fh)	\
 	container_of(fh, struct v4l2_subdev_fh, vfh)
 
-#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 #define __V4L2_SUBDEV_MK_GET_TRY(rtype, fun_name, field_name)		\
 	static inline struct rtype *					\
 	v4l2_subdev_get_try_##fun_name(struct v4l2_subdev_fh *fh,	\
@@ -656,7 +655,6 @@ struct v4l2_subdev_fh {
 __V4L2_SUBDEV_MK_GET_TRY(v4l2_mbus_framefmt, format, try_fmt)
 __V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, crop, try_crop)
 __V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, compose, try_compose)
-#endif
 
 extern const struct v4l2_file_operations v4l2_subdev_fops;
 
-- 
1.9.1

