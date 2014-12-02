Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbaLBFwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 00:52:24 -0500
Received: from ozlabs.org ([103.22.144.67]:58325 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbaLBFwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 00:52:23 -0500
From: Michael Ellerman <mpe@ellerman.id.au>
To: <linux-kernel@vger.kernel.org>
Cc: shuahkh@osg.samsung.com, Andrew Morton <akpm@osdl.org>,
        gorcunov@openvz.org, Arnd Bergmann <arnd@arndb.de>, cov@codeaurora.org
Subject: [PATCH 1/3] kcmp: Move kcmp.h into uapi
Date: Tue,  2 Dec 2014 16:52:06 +1100
Message-Id: <1417499528-23377-1-git-send-email-mpe@ellerman.id.au>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kcmp.h appears to be part of the API, it's documented in kcmp(2), and
the selftests/kcmp code uses it. So move it to uapi so it's actually
exported.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 include/linux/kcmp.h      | 17 -----------------
 include/uapi/linux/Kbuild |  1 +
 include/uapi/linux/kcmp.h | 17 +++++++++++++++++
 3 files changed, 18 insertions(+), 17 deletions(-)
 delete mode 100644 include/linux/kcmp.h
 create mode 100644 include/uapi/linux/kcmp.h

diff --git a/include/linux/kcmp.h b/include/linux/kcmp.h
deleted file mode 100644
index 2dcd1b3aafc8..000000000000
--- a/include/linux/kcmp.h
+++ /dev/null
@@ -1,17 +0,0 @@
-#ifndef _LINUX_KCMP_H
-#define _LINUX_KCMP_H
-
-/* Comparison type */
-enum kcmp_type {
-	KCMP_FILE,
-	KCMP_VM,
-	KCMP_FILES,
-	KCMP_FS,
-	KCMP_SIGHAND,
-	KCMP_IO,
-	KCMP_SYSVSEM,
-
-	KCMP_TYPES,
-};
-
-#endif /* _LINUX_KCMP_H */
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 4c94f31a8c99..a7b3071c03f2 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -211,6 +211,7 @@ header-y += ivtvfb.h
 header-y += ixjuser.h
 header-y += jffs2.h
 header-y += joystick.h
+header-y += kcmp.h
 header-y += kd.h
 header-y += kdev_t.h
 header-y += kernel-page-flags.h
diff --git a/include/uapi/linux/kcmp.h b/include/uapi/linux/kcmp.h
new file mode 100644
index 000000000000..84df14b37360
--- /dev/null
+++ b/include/uapi/linux/kcmp.h
@@ -0,0 +1,17 @@
+#ifndef _UAPI_LINUX_KCMP_H
+#define _UAPI_LINUX_KCMP_H
+
+/* Comparison type */
+enum kcmp_type {
+	KCMP_FILE,
+	KCMP_VM,
+	KCMP_FILES,
+	KCMP_FS,
+	KCMP_SIGHAND,
+	KCMP_IO,
+	KCMP_SYSVSEM,
+
+	KCMP_TYPES,
+};
+
+#endif /* _UAPI_LINUX_KCMP_H */
-- 
1.9.1

