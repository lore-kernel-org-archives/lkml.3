Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaLZOmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 09:42:49 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:17530 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751807AbaLZOm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 09:42:27 -0500
X-IronPort-AV: E=Sophos;i="5.07,647,1413237600"; 
   d="scan'208";a="114895455"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/27] [media] usbvision: Use setup_timer
Date: Fri, 26 Dec 2014 15:35:36 +0100
Message-Id: <1419604558-29743-6-git-send-email-Julia.Lawall@lip6.fr>
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

-init_timer(&t);
+setup_timer(&t,f,d);
-t.data = d;
-t.function = f;
// </smpl>

The semantic patch also changes the cast to long to a cast to unsigned
long in the data initializer, as unsigned long is the type of the data field.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/usb/usbvision/usbvision-core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-core.c b/drivers/media/usb/usbvision/usbvision-core.c
index 302aa07..64c63d3 100644
--- a/drivers/media/usb/usbvision/usbvision-core.c
+++ b/drivers/media/usb/usbvision/usbvision-core.c
@@ -2194,9 +2194,8 @@ static void usbvision_power_off_timer(unsigned long data)
 
 void usbvision_init_power_off_timer(struct usb_usbvision *usbvision)
 {
-	init_timer(&usbvision->power_off_timer);
-	usbvision->power_off_timer.data = (long)usbvision;
-	usbvision->power_off_timer.function = usbvision_power_off_timer;
+	setup_timer(&usbvision->power_off_timer, usbvision_power_off_timer,
+		    (unsigned long)usbvision);
 }
 
 void usbvision_set_power_off_timer(struct usb_usbvision *usbvision)

