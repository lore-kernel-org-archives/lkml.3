Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbaLaB5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 20:57:09 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:58390 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbaLaB5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 20:57:07 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, gorcunov@openvz.org, davidel@xmailserver.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] timerfd: export defines to userspace
Date: Tue, 30 Dec 2014 20:56:59 -0500
Message-Id: <1419991019-5139-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since userspace is expected to call timerfd syscalls directly with these
flags/ioctls, make sure we export them so they don't have to duplicate
the values themselves.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/linux/timerfd.h      | 20 +-------------------
 include/uapi/linux/Kbuild    |  1 +
 include/uapi/linux/timerfd.h | 36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 19 deletions(-)
 create mode 100644 include/uapi/linux/timerfd.h

diff --git a/include/linux/timerfd.h b/include/linux/timerfd.h
index bd36ce4..bab0b1a 100644
--- a/include/linux/timerfd.h
+++ b/include/linux/timerfd.h
@@ -8,23 +8,7 @@
 #ifndef _LINUX_TIMERFD_H
 #define _LINUX_TIMERFD_H
 
-/* For O_CLOEXEC and O_NONBLOCK */
-#include <linux/fcntl.h>
-
-/* For _IO helpers */
-#include <linux/ioctl.h>
-
-/*
- * CAREFUL: Check include/asm-generic/fcntl.h when defining
- * new flags, since they might collide with O_* ones. We want
- * to re-use O_* flags that couldn't possibly have a meaning
- * from eventfd, in order to leave a free define-space for
- * shared O_* flags.
- */
-#define TFD_TIMER_ABSTIME (1 << 0)
-#define TFD_TIMER_CANCEL_ON_SET (1 << 1)
-#define TFD_CLOEXEC O_CLOEXEC
-#define TFD_NONBLOCK O_NONBLOCK
+#include <uapi/linux/timerfd.h>
 
 #define TFD_SHARED_FCNTL_FLAGS (TFD_CLOEXEC | TFD_NONBLOCK)
 /* Flags for timerfd_create.  */
@@ -32,6 +16,4 @@
 /* Flags for timerfd_settime.  */
 #define TFD_SETTIME_FLAGS (TFD_TIMER_ABSTIME | TFD_TIMER_CANCEL_ON_SET)
 
-#define TFD_IOC_SET_TICKS	_IOW('T', 0, u64)
-
 #endif /* _LINUX_TIMERFD_H */
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 8523f9b..62ac5e7 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -384,6 +384,7 @@ header-y += tcp_metrics.h
 header-y += telephony.h
 header-y += termios.h
 header-y += time.h
+header-y += timerfd.h
 header-y += times.h
 header-y += timex.h
 header-y += tiocl.h
diff --git a/include/uapi/linux/timerfd.h b/include/uapi/linux/timerfd.h
new file mode 100644
index 0000000..6fcfaa8
--- /dev/null
+++ b/include/uapi/linux/timerfd.h
@@ -0,0 +1,36 @@
+/*
+ *  include/linux/timerfd.h
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ */
+
+#ifndef _UAPI_LINUX_TIMERFD_H
+#define _UAPI_LINUX_TIMERFD_H
+
+#include <linux/types.h>
+
+/* For O_CLOEXEC and O_NONBLOCK */
+#include <linux/fcntl.h>
+
+/* For _IO helpers */
+#include <linux/ioctl.h>
+
+/*
+ * CAREFUL: Check include/asm-generic/fcntl.h when defining
+ * new flags, since they might collide with O_* ones. We want
+ * to re-use O_* flags that couldn't possibly have a meaning
+ * from eventfd, in order to leave a free define-space for
+ * shared O_* flags.
+ *
+ * Also make sure to update the masks in include/linux/timerfd.h
+ * when adding new flags.
+ */
+#define TFD_TIMER_ABSTIME (1 << 0)
+#define TFD_TIMER_CANCEL_ON_SET (1 << 1)
+#define TFD_CLOEXEC O_CLOEXEC
+#define TFD_NONBLOCK O_NONBLOCK
+
+#define TFD_IOC_SET_TICKS	_IOW('T', 0, __u64)
+
+#endif /* _UAPI_LINUX_TIMERFD_H */
-- 
2.2.1

