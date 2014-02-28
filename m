Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaB1A1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 19:27:35 -0500
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:57123 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991AbaB1A1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 19:27:34 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, ly80toro@cip.cs.fau.de, andy.grover@gmail.com,
        valentina.manea.m@gmail.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH 2/3] staging/usbip: change usbip to include new uapi usbip.h
Date: Thu, 27 Feb 2014 17:27:26 -0700
Message-Id: <dbbe5fffc27bf23cfffa99ea3d048ea75aa4e536.1393542201.git.shuah.kh@samsung.com>
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
kernel space to include uapi usbip.h for usbip device status.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/staging/usbip/usbip_common.h |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/usbip/usbip_common.h b/drivers/staging/usbip/usbip_common.h
index 7e6c543..846ef5b 100644
--- a/drivers/staging/usbip/usbip_common.h
+++ b/drivers/staging/usbip/usbip_common.h
@@ -29,6 +29,7 @@
 #include <linux/types.h>
 #include <linux/usb.h>
 #include <linux/wait.h>
+#include <uapi/linux/usbip.h>
 
 #define USBIP_VERSION "1.0.0"
 
@@ -235,22 +236,6 @@ enum usbip_side {
 	USBIP_STUB,
 };
 
-enum usbip_status {
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
 /* event handler */
 #define USBIP_EH_SHUTDOWN	(1 << 0)
 #define USBIP_EH_BYE		(1 << 1)
@@ -271,7 +256,7 @@ enum usbip_status {
 /* a common structure for stub_device and vhci_device */
 struct usbip_device {
 	enum usbip_side side;
-	enum usbip_status status;
+	enum usbip_device_status status;
 
 	/* lock for status */
 	spinlock_t lock;
-- 
1.7.10.4

