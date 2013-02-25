Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab3BYKdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 05:33:00 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:62805 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231Ab3BYKcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 05:32:55 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/8] HID: multitouch: remove explicit usbhid dependency
Date: Mon, 25 Feb 2013 11:31:48 +0100
Message-Id: <1361788310-6048-7-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361788310-6048-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1361788310-6048-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of the cleanup of the HID drivers
against their low-level transport layer.
With new touchscreens relying on I2C, it's better to
handle now these dependencies before users get kernel oopses.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
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
1.8.1.2

