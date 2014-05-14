Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaENRhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:37:35 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:42192 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbaENRhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:37:34 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 1/2] usb: gadget: net2280: Fix NULL pointer dereference
Date: Wed, 14 May 2014 19:37:26 +0200
Message-Id: <1400089046-18245-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.0.0.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When DEBUG is enabled driver->driver.name is accessed, but driver
can be NULL

[  174.411689] BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
[  174.429043] RIP: 0010:[<ffffffffa0131ca3>]  [<ffffffffa0131ca3>] net2280_stop+0xa3/0x100 [net2280]
[  174.457910] Call Trace:
[  174.459503]  [<ffffffffa00dd92a>] usb_gadget_remove_driver+0x5a/0xb0 [udc_core]
[  174.462693]  [<ffffffffa00ddd84>] usb_del_gadget_udc+0xb4/0x110 [udc_core]
[  174.464316]  [<ffffffffa012e2bf>] net2280_remove+0x2f/0x1c0 [net2280]

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/gadget/net2280.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index 43e5e2f..4978e63 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -1972,7 +1972,9 @@ static int net2280_stop(struct usb_gadget *_gadget,
 	device_remove_file (&dev->pdev->dev, &dev_attr_function);
 	device_remove_file (&dev->pdev->dev, &dev_attr_queues);
 
-	DEBUG (dev, "unregistered driver '%s'\n", driver->driver.name);
+	if (driver)
+		DEBUG(dev, "unregistered driver '%s'\n", driver->driver.name);
+
 	return 0;
 }
 
-- 
2.0.0.rc0

