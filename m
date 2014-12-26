Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbaLZOwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 09:52:41 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:4736 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751659AbaLZOmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 09:42:25 -0500
X-IronPort-AV: E=Sophos;i="5.07,647,1413237600"; 
   d="scan'208";a="114895451"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/27] [media] au0828: Use setup_timer
Date: Fri, 26 Dec 2014 15:35:32 +0100
Message-Id: <1419604558-29743-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1419604558-29743-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1419604558-29743-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert a call to init_timer and accompanying intializations of
the timer's data and function fields to a call to setup_timer.

A simplified version of the semantic match that fixes this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression t,f,d;
@@

-t.function = f;
-t.data = d;
-init_timer(&t);
+setup_timer(&t,f,d);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/usb/au0828/au0828-video.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 5f337b1..0b24791 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -2043,13 +2043,10 @@ int au0828_analog_register(struct au0828_dev *dev,
 	INIT_LIST_HEAD(&dev->vbiq.active);
 	INIT_LIST_HEAD(&dev->vbiq.queued);
 
-	dev->vid_timeout.function = au0828_vid_buffer_timeout;
-	dev->vid_timeout.data = (unsigned long) dev;
-	init_timer(&dev->vid_timeout);
-
-	dev->vbi_timeout.function = au0828_vbi_buffer_timeout;
-	dev->vbi_timeout.data = (unsigned long) dev;
-	init_timer(&dev->vbi_timeout);
+	setup_timer(&dev->vid_timeout, au0828_vid_buffer_timeout,
+		    (unsigned long)dev);
+	setup_timer(&dev->vbi_timeout, au0828_vbi_buffer_timeout,
+		    (unsigned long)dev);
 
 	dev->width = NTSC_STD_W;
 	dev->height = NTSC_STD_H;

