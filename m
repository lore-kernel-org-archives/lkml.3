Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbaAVR4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 12:56:19 -0500
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:49167
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755184AbaAVR4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 12:56:15 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, ly80toro@cip.cs.fau.de
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH] staging/usbip: Change userspace to use linux include for usb_device_speed enum
Date: Wed, 22 Jan 2014 10:56:12 -0700
Message-Id: <1390413372-3451-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove usb_device_speed enum define from usbip_common.h and change it to
include linux/usb/ch9.h instead.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/staging/usbip/userspace/libsrc/usbip_common.h | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.h b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
index 938ad1c..2cb81b3 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_common.h
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
@@ -14,6 +14,7 @@
 
 #include <syslog.h>
 #include <unistd.h>
+#include <linux/usb/ch9.h>
 
 #ifndef USBIDS_FILE
 #define USBIDS_FILE "/usr/share/hwdata/usb.ids"
@@ -76,13 +77,6 @@ extern int usbip_use_debug ;
 		abort();				\
 	} while (0)
 
-enum usb_device_speed {
-	USB_SPEED_UNKNOWN = 0,                  /* enumerating */
-	USB_SPEED_LOW, USB_SPEED_FULL,          /* usb 1.1 */
-	USB_SPEED_HIGH,                         /* usb 2.0 */
-	USB_SPEED_VARIABLE                      /* wireless (usb 2.5) */
-};
-
 /* FIXME: how to sync with drivers/usbip_common.h ? */
 enum usbip_device_status {
 	/* sdev is available. */
-- 
1.8.3.2

