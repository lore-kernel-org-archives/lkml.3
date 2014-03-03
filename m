Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbaCCXi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 18:38:59 -0500
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:60638
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755691AbaCCXi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 18:38:57 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, ly80toro@cip.cs.fau.de, andy.grover@gmail.com,
        valentina.manea.m@gmail.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH v2 3/3] staging/usbip: change usbip userspace to include new uapi usbip.h
Date: Mon,  3 Mar 2014 16:38:45 -0700
Message-Id: <8fbf55dee298a26dd42aaa9155aa0fc6ec3a0afd.1393882836.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1393882836.git.shuah.kh@samsung.com>
References: <cover.1393882836.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1393882836.git.shuah.kh@samsung.com>
References: <cover.1393882836.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usbip userspace has duplicated enum definition to report usbip device
status maintained by the kernel. A new uapi usbip.h now defines the
usbip device status for kernel and userspace to use. Change usbip
userspace to include uapi usbip.h for usbip device status.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 .../staging/usbip/userspace/libsrc/usbip_common.h    |   18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.h b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
index 2cb81b3..5af59d4 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_common.h
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
@@ -15,6 +15,7 @@
 #include <syslog.h>
 #include <unistd.h>
 #include <linux/usb/ch9.h>
+#include "../../uapi/usbip.h"
 
 #ifndef USBIDS_FILE
 #define USBIDS_FILE "/usr/share/hwdata/usb.ids"
@@ -77,23 +78,6 @@ extern int usbip_use_debug ;
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

