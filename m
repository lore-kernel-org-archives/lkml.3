Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933879Ab3GPXHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 19:07:01 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:59678 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323Ab3GPXG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 19:06:59 -0400
From: Alban Browaeys <alban.browaeys@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alban Browaeys <prahal@yahoo.com>
Subject: [PATCH 4/4] [media] em28xx: Fix vidioc fmt vid cap v4l2 compliance
Date: Wed, 17 Jul 2013 01:06:46 +0200
Message-Id: <1374016006-27678-1-git-send-email-prahal@yahoo.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set fmt.pix.priv to zero in vidioc_g_fmt_vid_cap
 and vidioc_try_fmt_vid_cap.

Catched by v4l2-compliance.

Signed-off-by: Alban Browaeys <prahal@yahoo.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 1a577ed..42930a4 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -943,6 +943,8 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 	else
 		f->fmt.pix.field = dev->interlaced ?
 			   V4L2_FIELD_INTERLACED : V4L2_FIELD_TOP;
+	f->fmt.pix.priv = 0;
+
 	return 0;
 }
 
@@ -1008,6 +1010,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	else
 		f->fmt.pix.field = dev->interlaced ?
 			   V4L2_FIELD_INTERLACED : V4L2_FIELD_TOP;
+	f->fmt.pix.priv = 0;
 
 	return 0;
 }
-- 
1.8.3.2

