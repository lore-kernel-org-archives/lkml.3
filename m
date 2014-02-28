Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaB1A2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 19:28:20 -0500
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:47728 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751808AbaB1A1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 19:27:33 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, ly80toro@cip.cs.fau.de, andy.grover@gmail.com,
        valentina.manea.m@gmail.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH 1/3] staging/usbip: add uapi header to export usbip kernel interfaces
Date: Thu, 27 Feb 2014 17:27:25 -0700
Message-Id: <10c9784313c5bafc6410b95cb3b569d5925eeaaa.1393542201.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1393542201.git.shuah.kh@samsung.com>
References: <cover.1393542201.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1393542201.git.shuah.kh@samsung.com>
References: <cover.1393542201.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usbip userspace has duplicated enum definition to report usbip device
status maintained by the kernel. Adding an usbip uapi header file will
define the kernel - userspace interface for this device status.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 include/uapi/linux/Kbuild  |    1 +
 include/uapi/linux/usbip.h |   26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)
 create mode 100644 include/uapi/linux/usbip.h

diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 3ce25b5..4fb4800 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -393,6 +393,7 @@ header-y += un.h
 header-y += unistd.h
 header-y += unix_diag.h
 header-y += usbdevice_fs.h
+header-y += usbip.h
 header-y += utime.h
 header-y += utsname.h
 header-y += uuid.h
diff --git a/include/uapi/linux/usbip.h b/include/uapi/linux/usbip.h
new file mode 100644
index 0000000..fa5db30
--- /dev/null
+++ b/include/uapi/linux/usbip.h
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

