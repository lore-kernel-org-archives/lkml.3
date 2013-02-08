Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946583Ab3BHOjt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:39:49 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62418 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946444Ab3BHOic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:38:32 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] HID: multitouch: remove usbhid dependency
Date: Fri,  8 Feb 2013 15:37:35 +0100
Message-Id: <1360334256-22127-7-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 32258ba..184ac0a 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -32,7 +32,6 @@
 #include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/input/mt.h>
-#include "usbhid/usbhid.h"
 
 
 MODULE_AUTHOR("Stephane Chatty <chatty@enac.fr>");
@@ -907,7 +906,7 @@ static int mt_resume(struct hid_device *hdev)
 
 	intf = to_usb_interface(hdev->dev.parent);
 	interface = intf->cur_altsetting;
-	dev = hid_to_usb_dev(hdev);
+	dev = interface_to_usbdev(intf);
 
 	/* Some Elan legacy devices require SET_IDLE to be set on resume.
 	 * It should be safe to send it to other devices too.
-- 
1.8.1

