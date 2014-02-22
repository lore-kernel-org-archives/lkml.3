Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132AbaBVAuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 19:50:51 -0500
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:47298
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754870AbaBVAut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 19:50:49 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [RFC] [PATCH 5/6] media: em28xx-video - implement em28xx_ops: suspend/resume hooks
Date: Fri, 21 Feb 2014 17:50:17 -0700
Message-Id: <428b784414ab17562ee30396bdd999885b3916ad.1393027856.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1393027856.git.shuah.kh@samsung.com>
References: <cover.1393027856.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1393027856.git.shuah.kh@samsung.com>
References: <cover.1393027856.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement em28xx_ops: suspend/resume hooks. em28xx usb driver will
invoke em28xx_ops: suspend and resume hooks for all its extensions
from its suspend() and resume() interfaces.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index c3c9289..1df6750 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1933,6 +1933,32 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 	return 0;
 }
 
+static int em28xx_v4l2_suspend(struct em28xx *dev)
+{
+	if (dev->is_audio_only)
+		return 0;
+
+	if (!dev->has_video)
+		return 0;
+
+	em28xx_info("Suspending video extension");
+	em28xx_stop_urbs(dev);
+	return 0;
+}
+
+static int em28xx_v4l2_resume(struct em28xx *dev)
+{
+	if (dev->is_audio_only)
+		return 0;
+
+	if (!dev->has_video)
+		return 0;
+
+	em28xx_info("Resuming video extension");
+	/* what do we do here */
+	return 0;
+}
+
 /*
  * em28xx_v4l2_close()
  * stops streaming and deallocates all resources allocated by the v4l2
@@ -2504,6 +2530,8 @@ static struct em28xx_ops v4l2_ops = {
 	.name = "Em28xx v4l2 Extension",
 	.init = em28xx_v4l2_init,
 	.fini = em28xx_v4l2_fini,
+	.suspend = em28xx_v4l2_suspend,
+	.resume = em28xx_v4l2_resume,
 };
 
 static int __init em28xx_video_register(void)
-- 
1.8.3.2

