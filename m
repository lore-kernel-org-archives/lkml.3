Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbaLRQhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 11:37:18 -0500
Received: from resqmta-po-05v.sys.comcast.net ([96.114.154.164]:35608 "EHLO
	resqmta-po-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751178AbaLRQhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 11:37:16 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: m.chehab@samsung.com, hans.verkuil@cisco.com, dheitmueller@kernellabs.com,
        prabhakar.csengg@gmail.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, ttmesterr@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] media: au0828 change to not zero out fmt.pix.priv
Date: Thu, 18 Dec 2014 09:20:11 -0700
Message-Id: <54b748fa5cb6883d6ce348c38328161409c1f1be.1418918402.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1418918401.git.shuahkh@osg.samsung.com>
References: <cover.1418918401.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1418918401.git.shuahkh@osg.samsung.com>
References: <cover.1418918401.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to zero out fmt.pix.priv in vidioc_g_fmt_vid_cap()
vidioc_try_fmt_vid_cap(), and vidioc_s_fmt_vid_cap(). Remove it.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-video.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 3011ca8..ef49b2e 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1104,7 +1104,6 @@ static int au0828_set_format(struct au0828_dev *dev, unsigned int cmd,
 	format->fmt.pix.sizeimage = width * height * 2;
 	format->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 	format->fmt.pix.field = V4L2_FIELD_INTERLACED;
-	format->fmt.pix.priv = 0;
 
 	if (cmd == VIDIOC_TRY_FMT)
 		return 0;
@@ -1189,7 +1188,6 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.sizeimage = dev->frame_size;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M; /* NTSC/PAL */
 	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
-	f->fmt.pix.priv = 0;
 	return 0;
 }
 
-- 
2.1.0

