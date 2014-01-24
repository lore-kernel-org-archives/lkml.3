Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaAXSeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 13:34:19 -0500
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:42326 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752259AbaAXSeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 13:34:17 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, ly80toro@cip.cs.fau.de, alan@linux.intel.com,
        thomas.pugliese@gmail.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH v2] staging/usbip: userspace to use linux header for usb_device_speed enum, missing speeds to speed_strings array
Date: Fri, 24 Jan 2014 11:34:13 -0700
Message-Id: <1390588453-27723-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove usb_device_speed enum define from usbip_common.h and change it to
include linux/usb/ch9.h instead. Add speed strings for usb wireless and 3.0
to speed_strings array.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---

v2: combined the following two userspace patches and addressed comments.
https://lkml.org/lkml/2014/1/22/336
https://lkml.org/lkml/2014/1/22/420

 drivers/staging/usbip/userspace/libsrc/usbip_common.c | 2 ++
 drivers/staging/usbip/userspace/libsrc/usbip_common.h | 8 +-------
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.c b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
index 66f03cc..6620d18 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_common.c
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
@@ -23,6 +23,8 @@ static const struct speed_string speed_strings[] = {
 	{ USB_SPEED_LOW,  "1.5", "Low Speed(1.5Mbps)"  },
 	{ USB_SPEED_FULL, "12",  "Full Speed(12Mbps)" },
 	{ USB_SPEED_HIGH, "480", "High Speed(480Mbps)" },
+	{ USB_SPEED_WIRELESS, "53.3-480", "Wireless"},
+	{ USB_SPEED_SUPER, "5000", "Super Speed(5000Mbps)" },
 	{ 0, NULL, NULL }
 };
 
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

