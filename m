Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbaKGOLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:11:21 -0500
Received: from down.free-electrons.com ([37.187.137.238]:59116 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752381AbaKGOH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:07:56 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 03/10] [media] Make use of the new media_bus_format definitions
Date: Fri,  7 Nov 2014 15:07:42 +0100
Message-Id: <1415369269-5064-4-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415369269-5064-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1415369269-5064-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace references to the v4l2_mbus_pixelcode enum with the new
media_bus_format enum in all common headers.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/media/v4l2-mediabus.h    | 2 +-
 include/media/v4l2-subdev.h      | 2 +-
 include/uapi/linux/v4l2-subdev.h | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 395c4a9..59d7397 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -98,7 +98,7 @@ static inline void v4l2_fill_pix_format(struct v4l2_pix_format *pix_fmt,
 
 static inline void v4l2_fill_mbus_format(struct v4l2_mbus_framefmt *mbus_fmt,
 			   const struct v4l2_pix_format *pix_fmt,
-			   enum v4l2_mbus_pixelcode code)
+			   u32 code)
 {
 	mbus_fmt->width = pix_fmt->width;
 	mbus_fmt->height = pix_fmt->height;
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index d746572..5860292 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -341,7 +341,7 @@ struct v4l2_subdev_video_ops {
 	int (*query_dv_timings)(struct v4l2_subdev *sd,
 			struct v4l2_dv_timings *timings);
 	int (*enum_mbus_fmt)(struct v4l2_subdev *sd, unsigned int index,
-			     enum v4l2_mbus_pixelcode *code);
+			     u32 *code);
 	int (*enum_mbus_fsizes)(struct v4l2_subdev *sd,
 			     struct v4l2_frmsizeenum *fsize);
 	int (*g_mbus_fmt)(struct v4l2_subdev *sd,
diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
index a619cdd..e0a7e3d 100644
--- a/include/uapi/linux/v4l2-subdev.h
+++ b/include/uapi/linux/v4l2-subdev.h
@@ -68,7 +68,7 @@ struct v4l2_subdev_crop {
  * struct v4l2_subdev_mbus_code_enum - Media bus format enumeration
  * @pad: pad number, as reported by the media API
  * @index: format index during enumeration
- * @code: format code (from enum v4l2_mbus_pixelcode)
+ * @code: format code (MEDIA_BUS_FMT_ definitions)
  */
 struct v4l2_subdev_mbus_code_enum {
 	__u32 pad;
@@ -81,7 +81,7 @@ struct v4l2_subdev_mbus_code_enum {
  * struct v4l2_subdev_frame_size_enum - Media bus format enumeration
  * @pad: pad number, as reported by the media API
  * @index: format index during enumeration
- * @code: format code (from enum v4l2_mbus_pixelcode)
+ * @code: format code (MEDIA_BUS_FMT_ definitions)
  */
 struct v4l2_subdev_frame_size_enum {
 	__u32 index;
@@ -109,7 +109,7 @@ struct v4l2_subdev_frame_interval {
  * struct v4l2_subdev_frame_interval_enum - Frame interval enumeration
  * @pad: pad number, as reported by the media API
  * @index: frame interval index during enumeration
- * @code: format code (from enum v4l2_mbus_pixelcode)
+ * @code: format code (MEDIA_BUS_FMT_ definitions)
  * @width: frame width in pixels
  * @height: frame height in pixels
  * @interval: frame interval in seconds
-- 
1.9.1

