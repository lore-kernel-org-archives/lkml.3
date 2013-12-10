Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab3LJCfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 21:35:46 -0500
Received: from mail-yh0-f74.google.com ([209.85.213.74]:43221 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab3LJCfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 21:35:43 -0500
From: Colin Cross <ccross@android.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Colin Cross <ccross@android.com>
Subject: [PATCH] ioprio: move userspace api into uapi
Date: Mon,  9 Dec 2013 18:35:40 -0800
Message-Id: <1386642940-2321-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the userspace interface described in
Documentation/block/ioprio.txt from include/linux/ioprio.h to
include/uapi/linux/ioprio.h.

Signed-off-by: Colin Cross <ccross@android.com>
---
 include/linux/ioprio.h      | 42 +----------------------------------------
 include/uapi/linux/ioprio.h | 46 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 41 deletions(-)
 create mode 100644 include/uapi/linux/ioprio.h

diff --git a/include/linux/ioprio.h b/include/linux/ioprio.h
index beb9ce1c2c23..45e19bafae6a 100644
--- a/include/linux/ioprio.h
+++ b/include/linux/ioprio.h
@@ -4,47 +4,7 @@
 #include <linux/sched.h>
 #include <linux/iocontext.h>
 
-/*
- * Gives us 8 prio classes with 13-bits of data for each class
- */
-#define IOPRIO_BITS		(16)
-#define IOPRIO_CLASS_SHIFT	(13)
-#define IOPRIO_PRIO_MASK	((1UL << IOPRIO_CLASS_SHIFT) - 1)
-
-#define IOPRIO_PRIO_CLASS(mask)	((mask) >> IOPRIO_CLASS_SHIFT)
-#define IOPRIO_PRIO_DATA(mask)	((mask) & IOPRIO_PRIO_MASK)
-#define IOPRIO_PRIO_VALUE(class, data)	(((class) << IOPRIO_CLASS_SHIFT) | data)
-
-#define ioprio_valid(mask)	(IOPRIO_PRIO_CLASS((mask)) != IOPRIO_CLASS_NONE)
-
-/*
- * These are the io priority groups as implemented by CFQ. RT is the realtime
- * class, it always gets premium service. BE is the best-effort scheduling
- * class, the default for any process. IDLE is the idle scheduling class, it
- * is only served when no one else is using the disk.
- */
-enum {
-	IOPRIO_CLASS_NONE,
-	IOPRIO_CLASS_RT,
-	IOPRIO_CLASS_BE,
-	IOPRIO_CLASS_IDLE,
-};
-
-/*
- * 8 best effort priority levels are supported
- */
-#define IOPRIO_BE_NR	(8)
-
-enum {
-	IOPRIO_WHO_PROCESS = 1,
-	IOPRIO_WHO_PGRP,
-	IOPRIO_WHO_USER,
-};
-
-/*
- * Fallback BE priority
- */
-#define IOPRIO_NORM	(4)
+#include <uapi/linux/ioprio.h>
 
 /*
  * if process has set io priority explicitly, use that. if not, convert
diff --git a/include/uapi/linux/ioprio.h b/include/uapi/linux/ioprio.h
new file mode 100644
index 000000000000..2ee40e2881b8
--- /dev/null
+++ b/include/uapi/linux/ioprio.h
@@ -0,0 +1,46 @@
+#ifndef _UAPI_LINUX_IOPRIO_H
+#define _UAPI_LINUX_IOPRIO_H
+
+/*
+ * Gives us 8 prio classes with 13-bits of data for each class
+ */
+#define IOPRIO_BITS		(16)
+#define IOPRIO_CLASS_SHIFT	(13)
+#define IOPRIO_PRIO_MASK	((1UL << IOPRIO_CLASS_SHIFT) - 1)
+
+#define IOPRIO_PRIO_CLASS(mask)	((mask) >> IOPRIO_CLASS_SHIFT)
+#define IOPRIO_PRIO_DATA(mask)	((mask) & IOPRIO_PRIO_MASK)
+#define IOPRIO_PRIO_VALUE(class, data)	(((class) << IOPRIO_CLASS_SHIFT) | data)
+
+#define ioprio_valid(mask)	(IOPRIO_PRIO_CLASS((mask)) != IOPRIO_CLASS_NONE)
+
+/*
+ * These are the io priority groups as implemented by CFQ. RT is the realtime
+ * class, it always gets premium service. BE is the best-effort scheduling
+ * class, the default for any process. IDLE is the idle scheduling class, it
+ * is only served when no one else is using the disk.
+ */
+enum {
+	IOPRIO_CLASS_NONE,
+	IOPRIO_CLASS_RT,
+	IOPRIO_CLASS_BE,
+	IOPRIO_CLASS_IDLE,
+};
+
+/*
+ * 8 best effort priority levels are supported
+ */
+#define IOPRIO_BE_NR	(8)
+
+enum {
+	IOPRIO_WHO_PROCESS = 1,
+	IOPRIO_WHO_PGRP,
+	IOPRIO_WHO_USER,
+};
+
+/*
+ * Fallback BE priority
+ */
+#define IOPRIO_NORM	(4)
+
+#endif /* _UAPI_LINUX_IOPRIO_H */
-- 
1.8.5.1

