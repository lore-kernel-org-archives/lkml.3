Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbaEPNv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:51:57 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:63736 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933009AbaEPNka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:40:30 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 19/49] media: davinci: vpif_display: drop cropcap
Date: Fri, 16 May 2014 19:03:24 +0530
Message-Id: <1400247235-31434-21-git-send-email-prabhakar.csengg@gmail.com>
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
 drivers/media/platform/davinci/vpif_display.c |   19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index fef03be..9848996 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -761,24 +761,6 @@ static int vpif_g_std(struct file *file, void *priv, v4l2_std_id *std)
 	return 0;
 }
 
-static int vpif_cropcap(struct file *file, void *priv,
-			struct v4l2_cropcap *crop)
-{
-	struct video_device *vdev = video_devdata(file);
-	struct channel_obj *ch = video_get_drvdata(vdev);
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-
-	if (V4L2_BUF_TYPE_VIDEO_OUTPUT != crop->type)
-		return -EINVAL;
-
-	crop->bounds.left = crop->bounds.top = 0;
-	crop->defrect.left = crop->defrect.top = 0;
-	crop->defrect.height = crop->bounds.height = common->height;
-	crop->defrect.width = crop->bounds.width = common->width;
-
-	return 0;
-}
-
 static int vpif_enum_output(struct file *file, void *fh,
 				struct v4l2_output *output)
 {
@@ -1070,7 +1052,6 @@ static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
 	.vidioc_enum_output		= vpif_enum_output,
 	.vidioc_s_output		= vpif_s_output,
 	.vidioc_g_output		= vpif_g_output,
-	.vidioc_cropcap         	= vpif_cropcap,
 	.vidioc_enum_dv_timings         = vpif_enum_dv_timings,
 	.vidioc_s_dv_timings            = vpif_s_dv_timings,
 	.vidioc_g_dv_timings            = vpif_g_dv_timings,
-- 
1.7.9.5

