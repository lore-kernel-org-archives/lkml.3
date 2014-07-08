Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbaGHOaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:30:52 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:63634 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaGHOau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:30:50 -0400
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-media@vger.kernel.org
Cc: gregkh@linuxfoundation.org, m.chehab@samsung.com,
        ismael.luceno@corp.bluecherry.net,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Subject: [PATCH 1/2] solo6x10: expose encoder quantization setting as V4L2 control
Date: Tue,  8 Jul 2014 17:30:33 +0300
Message-Id: <1404829834-8747-1-git-send-email-andrey.utkin@corp.bluecherry.net>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

solo6*10 boards have configurable quantization parameter which takes
values from 0 to 31, inclusively.

This change enables setting it with ioctl VIDIOC_S_CTRL with id
V4L2_CID_MPEG_VIDEO_H264_MIN_QP.
---
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
index b8ff113..bf6eb06 100644
--- a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
@@ -1111,6 +1111,9 @@ static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
 		solo_enc->gop = ctrl->val;
 		return 0;
+	case V4L2_CID_MPEG_VIDEO_H264_MIN_QP:
+		solo_enc->qp = ctrl->val;
+		return 0;
 	case V4L2_CID_MOTION_THRESHOLD:
 		solo_enc->motion_thresh = ctrl->val;
 		if (!solo_enc->motion_global || !solo_enc->motion_enabled)
@@ -1260,6 +1263,8 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev,
 			V4L2_CID_SHARPNESS, 0, 15, 1, 0);
 	v4l2_ctrl_new_std(hdl, &solo_ctrl_ops,
 			V4L2_CID_MPEG_VIDEO_GOP_SIZE, 1, 255, 1, solo_dev->fps);
+	v4l2_ctrl_new_std(hdl, &solo_ctrl_ops,
+			V4L2_CID_MPEG_VIDEO_H264_MIN_QP, 0, 31, 1, SOLO_DEFAULT_QP);
 	v4l2_ctrl_new_custom(hdl, &solo_motion_threshold_ctrl, NULL);
 	v4l2_ctrl_new_custom(hdl, &solo_motion_enable_ctrl, NULL);
 	v4l2_ctrl_new_custom(hdl, &solo_osd_text_ctrl, NULL);
-- 
1.8.3.2

