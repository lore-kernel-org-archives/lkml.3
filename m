Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbaCCXi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 18:38:56 -0500
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:46316
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755623AbaCCXix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 18:38:53 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, ly80toro@cip.cs.fau.de, andy.grover@gmail.com,
        valentina.manea.m@gmail.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH v2 1/3] staging/usbip: add uapi header to export usbip kernel interfaces
Date: Mon,  3 Mar 2014 16:38:43 -0700
Message-Id: <da4a9ceaff47761ff0bec4ad5750709dae8528de.1393882836.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1393882836.git.shuah.kh@samsung.com>
References: <cover.1393882836.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1393882836.git.shuah.kh@samsung.com>
References: <cover.1393882836.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usbip userspace has duplicated enum definition to report usbip device
status maintained by the kernel. Adding an usbip uapi header file will
define the kernel - userspace interface for this device status. This
new uapi file is added under usbip/uapi to keep the staging tree code
self-contained. When usbip moves to mainline drivers, this file should
be moved under uapi/linux

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/staging/usbip/uapi/usbip.h |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 drivers/staging/usbip/uapi/usbip.h

diff --git a/drivers/staging/usbip/uapi/usbip.h b/drivers/staging/usbip/uapi/usbip.h
new file mode 100644
index 0000000..fa5db30
--- /dev/null
+++ b/drivers/staging/usbip/uapi/usbip.h
@@ -0,0 +1,26 @@
+/*
+ *	usbip.h
+ *
+ *	USBIP uapi defines and function prototypes etc.
+*/
+
+#ifndef _UAPI_LINUX_USBIP_H
+#define _UAPI_LINUX_USBIP_H
+
+/* usbip device status - exported in usbip device sysfs status */
+enum usbip_device_status {
+	/* sdev is available. */
+	SDEV_ST_AVAILABLE = 0x01,
+	/* sdev is now used. */
+	SDEV_ST_USED,
+	/* sdev is unusable because of a fatal error. */
+	SDEV_ST_ERROR,
+
+	/* vdev does not connect a remote device. */
+	VDEV_ST_NULL,
+	/* vdev is used, but the USB address is not assigned yet */
+	VDEV_ST_NOTASSIGNED,
+	VDEV_ST_USED,
+	VDEV_ST_ERROR
+};
+#endif /* _UAPI_LINUX_USBIP_H */
-- 
1.7.10.4

