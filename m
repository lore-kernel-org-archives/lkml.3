Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179Ab3APNIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:08:09 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:34111 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab3APNII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:08:08 -0500
From: Volokh Konstantin <volokh84@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, gregkh@linuxfoundation.org, volokh84@gmail.com,
        dhowells@redhat.com, rdunlap@xenotime.net, hans.verkuil@cisco.com,
        justinmattock@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] staging: media: go7007: firmware protection Protection for unfirmware load
Date: Wed, 16 Jan 2013 17:00:49 +0400
Message-Id: <1358341251-10087-2-git-send-email-volokh84@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1358341251-10087-1-git-send-email-volokh84@gmail.com>
References: <1358341251-10087-1-git-send-email-volokh84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
---
 drivers/staging/media/go7007/go7007-usb.c  |    2 +-
 drivers/staging/media/go7007/go7007-v4l2.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index 5443e25..a6cad15 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -1245,7 +1245,6 @@ static void go7007_usb_disconnect(struct usb_interface *intf)
 	struct urb *vurb, *aurb;
 	int i;
 
-	go->status = STATUS_SHUTDOWN;
 	usb_kill_urb(usb->intr_urb);
 
 	/* Free USB-related structs */
@@ -1269,6 +1268,7 @@ static void go7007_usb_disconnect(struct usb_interface *intf)
 	kfree(go->hpi_context);
 
 	go7007_remove(go);
+	go->status = STATUS_SHUTDOWN;
 }
 
 static struct usb_driver go7007_usb_driver = {
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index e6fa543..a69250f 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -1832,5 +1832,6 @@ void go7007_v4l2_remove(struct go7007 *go)
 	mutex_unlock(&go->hw_lock);
 	if (go->video_dev)
 		video_unregister_device(go->video_dev);
-	v4l2_device_unregister(&go->v4l2_dev);
+	if (go->status != STATUS_SHUTDOWN)
+		v4l2_device_unregister(&go->v4l2_dev);
 }
-- 
1.7.7.6

