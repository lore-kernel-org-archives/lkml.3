Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933497AbaEPNmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:42:37 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:47985 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932605AbaEPNme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:42:34 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 42/49] media: davinci: vpif_capture: drop cropcap
Date: Fri, 16 May 2014 19:03:48 +0530
Message-Id: <1400247235-31434-45-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch drops cropcap as this driver doesnt support cropping.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_capture.c |   25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index e967cf7..113d333 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1100,30 +1100,6 @@ static int vpif_querycap(struct file *file, void  *priv,
 }
 
 /**
- * vpif_cropcap() - cropcap handler
- * @file: file ptr
- * @priv: file handle
- * @crop: ptr to v4l2_cropcap structure
- */
-static int vpif_cropcap(struct file *file, void *priv,
-			struct v4l2_cropcap *crop)
-{
-	struct video_device *vdev = video_devdata(file);
-	struct channel_obj *ch = video_get_drvdata(vdev);
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-
-	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != crop->type)
-		return -EINVAL;
-
-	crop->bounds.left = 0;
-	crop->bounds.top = 0;
-	crop->bounds.height = common->height;
-	crop->bounds.width = common->width;
-	crop->defrect = crop->bounds;
-	return 0;
-}
-
-/**
  * vpif_enum_dv_timings() - ENUM_DV_TIMINGS handler
  * @file: file ptr
  * @priv: file handle
@@ -1308,7 +1284,6 @@ static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
 	.vidioc_s_std           	= vpif_s_std,
 	.vidioc_g_std			= vpif_g_std,
 
-	.vidioc_cropcap         	= vpif_cropcap,
 	.vidioc_enum_dv_timings         = vpif_enum_dv_timings,
 	.vidioc_query_dv_timings        = vpif_query_dv_timings,
 	.vidioc_s_dv_timings            = vpif_s_dv_timings,
-- 
1.7.9.5

