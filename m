Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab3DPMGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 08:06:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261Ab3DPMGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 08:06:50 -0400
From: Michal Marek <mmarek@suse.cz>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [media] em28xx: Put remaining .vidioc_g_chip_info instance under ADV_DEBUG
Date: Tue, 16 Apr 2013 14:06:30 +0200
Message-Id: <1366113990-19801-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit cd634f1 ("[media] v4l2: put VIDIOC_DBG_G_CHIP_NAME under
ADV_DEBUG") missed the initializer of radio_ioctl_ops:

drivers/media/usb/em28xx/em28xx-video.c:1830:2: error: unknown field 'vidioc_g_chip_info' specified in initializer
drivers/media/usb/em28xx/em28xx-video.c:1830:26: error: 'vidioc_g_chip_info' undeclared here (not in a function)

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 drivers/media/usb/em28xx/em28xx-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index c27c1f6..32d60e5 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1827,8 +1827,8 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 	.vidioc_g_chip_ident  = vidioc_g_chip_ident,
-	.vidioc_g_chip_info   = vidioc_g_chip_info,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
+	.vidioc_g_chip_info   = vidioc_g_chip_info,
 	.vidioc_g_register    = vidioc_g_register,
 	.vidioc_s_register    = vidioc_s_register,
 #endif
-- 
1.8.2.1

