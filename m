Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758993Ab3BGQtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:49:22 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:65012 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758830Ab3BGQtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:49:20 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, LDOC <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>, Rob Landley <rob@landley.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH v3] media: add support for decoder as one of media entity types
Date: Thu,  7 Feb 2013 22:18:51 +0530
Message-Id: <1360255731-3504-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

A lot of SOCs including Texas Instruments Davinci family mainly use
video decoders as input devices. This patch adds a flag
'MEDIA_ENT_T_V4L2_SUBDEV_DECODER' media entity type for decoder's.
Along side updates the documentation for this media entity type.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Cc: Rob Landley <rob@landley.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 Changes for v3:
 1: Fixed Nit pointed by Sylwester.

 Changes for v2:
 1: Sending as a separate patch.
 2: Added documentation for the added media entity type.
 3: Improved the commit message.
 
 .../DocBook/media/v4l/media-ioc-enum-entities.xml  |   10 ++++++++++
 include/uapi/linux/media.h                         |    2 ++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
index 576b68b..116c301 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
@@ -272,6 +272,16 @@
 	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_LENS</constant></entry>
 	    <entry>Lens controller</entry>
 	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_DECODER</constant></entry>
+	    <entry>Video decoder, the basic function of the video decoder is to
+	    accept analogue video from a wide variety of sources such as
+	    broadcast, DVD players, cameras and video cassette recorders, in
+	    either NTSC, PAL or HD format and still occasionally SECAM, separate
+	    it into its component parts, luminance and chrominance, and output
+	    it in some digital video standard, with appropriate embedded timing
+	    signals.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 0ef8833..ed49574 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -56,6 +56,8 @@ struct media_device_info {
 #define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR	(MEDIA_ENT_T_V4L2_SUBDEV + 1)
 #define MEDIA_ENT_T_V4L2_SUBDEV_FLASH	(MEDIA_ENT_T_V4L2_SUBDEV + 2)
 #define MEDIA_ENT_T_V4L2_SUBDEV_LENS	(MEDIA_ENT_T_V4L2_SUBDEV + 3)
+/* A converter of analogue video to its digital representation. */
+#define MEDIA_ENT_T_V4L2_SUBDEV_DECODER	(MEDIA_ENT_T_V4L2_SUBDEV + 4)
 
 #define MEDIA_ENT_FL_DEFAULT		(1 << 0)
 
-- 
1.7.0.4

