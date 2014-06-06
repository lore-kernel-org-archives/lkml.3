Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaFFTbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 15:31:16 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:48382 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaFFTbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 15:31:15 -0400
From: Jeremiah Mahler <jmmahler@gmail.com>
X-Google-Original-From: "Jeremiah Mahler" <jeri@hudson>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-doc@vger.kernel.org, trivial@kernel.org,
        linux-kernel@vger.kernel.org, Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH] usb: doc: hotplug.txt code typos
Date: Fri,  6 Jun 2014 12:29:17 -0700
Message-Id: <1402082957-320-1-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed several typos in the code examples given in
Documentation/usb/hotplug.txt.

  - missing [] with array of struct usb_device_id

  - checkpatch.pl warning: space between function name and parenthesis

  - missing terminating ';'

Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
---
 Documentation/usb/hotplug.txt | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/usb/hotplug.txt b/Documentation/usb/hotplug.txt
index 6424b13..a80b0e9 100644
--- a/Documentation/usb/hotplug.txt
+++ b/Documentation/usb/hotplug.txt
@@ -105,13 +105,13 @@ macros such as these, and use driver_info to store more information.
 A short example, for a driver that supports several specific USB devices
 and their quirks, might have a MODULE_DEVICE_TABLE like this:
 
-    static const struct usb_device_id mydriver_id_table = {
+    static const struct usb_device_id mydriver_id_table[] = {
 	{ USB_DEVICE (0x9999, 0xaaaa), driver_info: QUIRK_X },
 	{ USB_DEVICE (0xbbbb, 0x8888), driver_info: QUIRK_Y|QUIRK_Z },
 	...
 	{ } /* end with an all-zeroes entry */
-    }
-    MODULE_DEVICE_TABLE (usb, mydriver_id_table);
+    };
+    MODULE_DEVICE_TABLE(usb, mydriver_id_table);
 
 Most USB device drivers should pass these tables to the USB subsystem as
 well as to the module management subsystem.  Not all, though: some driver
@@ -134,7 +134,7 @@ something like this:
 	if exposing any operations through usbdevfs:
 	    .ioctl		= my_ioctl,
 	*/
-    }
+    };
 
 When the USB subsystem knows about a driver's device ID table, it's used when
 choosing drivers to probe().  The thread doing new device processing checks
-- 
2.0.0

