Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbaBQWDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:03:44 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40426 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbaBQV6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:58:55 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Colin Cross <ccross@android.com>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 03/14] staging: android: Split uapi out of ashmem.h
Date: Mon, 17 Feb 2014 13:58:31 -0800
Message-Id: <1392674322-9036-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392674322-9036-1-git-send-email-john.stultz@linaro.org>
References: <1392674322-9036-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Move the userspace interface of ashmem.h to
drivers/staging/android/uapi/ashmem.h

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Colin Cross <ccross@android.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Colin Cross <ccross@android.com>
[jstultz: Minor commit message tweak]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ashmem.h      | 30 +---------------------
 drivers/staging/android/uapi/ashmem.h | 47 +++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 29 deletions(-)
 create mode 100644 drivers/staging/android/uapi/ashmem.h

diff --git a/drivers/staging/android/ashmem.h b/drivers/staging/android/ashmem.h
index 8dc0f0d..5abcfd7 100644
--- a/drivers/staging/android/ashmem.h
+++ b/drivers/staging/android/ashmem.h
@@ -16,35 +16,7 @@
 #include <linux/ioctl.h>
 #include <linux/compat.h>
 
-#define ASHMEM_NAME_LEN		256
-
-#define ASHMEM_NAME_DEF		"dev/ashmem"
-
-/* Return values from ASHMEM_PIN: Was the mapping purged while unpinned? */
-#define ASHMEM_NOT_PURGED	0
-#define ASHMEM_WAS_PURGED	1
-
-/* Return values from ASHMEM_GET_PIN_STATUS: Is the mapping pinned? */
-#define ASHMEM_IS_UNPINNED	0
-#define ASHMEM_IS_PINNED	1
-
-struct ashmem_pin {
-	__u32 offset;	/* offset into region, in bytes, page-aligned */
-	__u32 len;	/* length forward from offset, in bytes, page-aligned */
-};
-
-#define __ASHMEMIOC		0x77
-
-#define ASHMEM_SET_NAME		_IOW(__ASHMEMIOC, 1, char[ASHMEM_NAME_LEN])
-#define ASHMEM_GET_NAME		_IOR(__ASHMEMIOC, 2, char[ASHMEM_NAME_LEN])
-#define ASHMEM_SET_SIZE		_IOW(__ASHMEMIOC, 3, size_t)
-#define ASHMEM_GET_SIZE		_IO(__ASHMEMIOC, 4)
-#define ASHMEM_SET_PROT_MASK	_IOW(__ASHMEMIOC, 5, unsigned long)
-#define ASHMEM_GET_PROT_MASK	_IO(__ASHMEMIOC, 6)
-#define ASHMEM_PIN		_IOW(__ASHMEMIOC, 7, struct ashmem_pin)
-#define ASHMEM_UNPIN		_IOW(__ASHMEMIOC, 8, struct ashmem_pin)
-#define ASHMEM_GET_PIN_STATUS	_IO(__ASHMEMIOC, 9)
-#define ASHMEM_PURGE_ALL_CACHES	_IO(__ASHMEMIOC, 10)
+#include "uapi/ashmem.h"
 
 /* support of 32bit userspace on 64bit platforms */
 #ifdef CONFIG_COMPAT
diff --git a/drivers/staging/android/uapi/ashmem.h b/drivers/staging/android/uapi/ashmem.h
new file mode 100644
index 0000000..ba4743c
--- /dev/null
+++ b/drivers/staging/android/uapi/ashmem.h
@@ -0,0 +1,47 @@
+/*
+ * drivers/staging/android/uapi/ashmem.h
+ *
+ * Copyright 2008 Google Inc.
+ * Author: Robert Love
+ *
+ * This file is dual licensed.  It may be redistributed and/or modified
+ * under the terms of the Apache 2.0 License OR version 2 of the GNU
+ * General Public License.
+ */
+
+#ifndef _UAPI_LINUX_ASHMEM_H
+#define _UAPI_LINUX_ASHMEM_H
+
+#include <linux/ioctl.h>
+
+#define ASHMEM_NAME_LEN		256
+
+#define ASHMEM_NAME_DEF		"dev/ashmem"
+
+/* Return values from ASHMEM_PIN: Was the mapping purged while unpinned? */
+#define ASHMEM_NOT_PURGED	0
+#define ASHMEM_WAS_PURGED	1
+
+/* Return values from ASHMEM_GET_PIN_STATUS: Is the mapping pinned? */
+#define ASHMEM_IS_UNPINNED	0
+#define ASHMEM_IS_PINNED	1
+
+struct ashmem_pin {
+	__u32 offset;	/* offset into region, in bytes, page-aligned */
+	__u32 len;	/* length forward from offset, in bytes, page-aligned */
+};
+
+#define __ASHMEMIOC		0x77
+
+#define ASHMEM_SET_NAME		_IOW(__ASHMEMIOC, 1, char[ASHMEM_NAME_LEN])
+#define ASHMEM_GET_NAME		_IOR(__ASHMEMIOC, 2, char[ASHMEM_NAME_LEN])
+#define ASHMEM_SET_SIZE		_IOW(__ASHMEMIOC, 3, size_t)
+#define ASHMEM_GET_SIZE		_IO(__ASHMEMIOC, 4)
+#define ASHMEM_SET_PROT_MASK	_IOW(__ASHMEMIOC, 5, unsigned long)
+#define ASHMEM_GET_PROT_MASK	_IO(__ASHMEMIOC, 6)
+#define ASHMEM_PIN		_IOW(__ASHMEMIOC, 7, struct ashmem_pin)
+#define ASHMEM_UNPIN		_IOW(__ASHMEMIOC, 8, struct ashmem_pin)
+#define ASHMEM_GET_PIN_STATUS	_IO(__ASHMEMIOC, 9)
+#define ASHMEM_PURGE_ALL_CACHES	_IO(__ASHMEMIOC, 10)
+
+#endif	/* _UAPI_LINUX_ASHMEM_H */
-- 
1.8.3.2

