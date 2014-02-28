Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaB1A1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 19:27:51 -0500
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:49502
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751420AbaB1A1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 19:27:34 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, ly80toro@cip.cs.fau.de, andy.grover@gmail.com,
        valentina.manea.m@gmail.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH 3/3] staging/usbip: change usbip userspace to include new uapi usbip.h
Date: Thu, 27 Feb 2014 17:27:27 -0700
Message-Id: <ef4f30883a4e7a18d99fe05036e1fa95e72ba4a2.1393542201.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1393542201.git.shuah.kh@samsung.com>
References: <cover.1393542201.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1393542201.git.shuah.kh@samsung.com>
References: <cover.1393542201.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usbip userspace has duplicated enum definition to report usbip device
status maintained by the kernel. A new uapi usbip.h now defines the
usbip device status for kernel and userspace to use. Change usbip
userspace to include uapi usbip.h for usbip device status.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 .../staging/usbip/userspace/libsrc/usbip_common.h  |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.h b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
index 2cb81b3..d336f14 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_common.h
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
@@ -15,6 +15,9 @@
 #include <syslog.h>
 #include <unistd.h>
 #include <linux/usb/ch9.h>
+/* this is temporary to build in tree, once usbip.h
+ *  appears under linux headers - change it to <linux/usbip.h> */
+#include <../../../../../include/uapi/linux/usbip.h>
 
 #ifndef USBIDS_FILE
 #define USBIDS_FILE "/usr/share/hwdata/usb.ids"
@@ -77,23 +80,6 @@ extern int usbip_use_debug ;
 		abort();				\
 	} while (0)
 
-/* FIXME: how to sync with drivers/usbip_common.h ? */
-enum usbip_device_status {
-	/* sdev is available. */
-	SDEV_ST_AVAILABLE = 0x01,
-	/* sdev is now used. */
-	SDEV_ST_USED,
-	/* sdev is unusable because of a fatal error. */
-	SDEV_ST_ERROR,
-
-	/* vdev does not connect a remote device. */
-	VDEV_ST_NULL,
-	/* vdev is used, but the USB address is not assigned yet */
-	VDEV_ST_NOTASSIGNED,
-	VDEV_ST_USED,
-	VDEV_ST_ERROR
-};
-
 struct usbip_usb_interface {
 	uint8_t bInterfaceClass;
 	uint8_t bInterfaceSubClass;
-- 
1.7.10.4

