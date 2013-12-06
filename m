Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161548Ab3LFNBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:01:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43945 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161478Ab3LFNB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:01:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Helge Deller <deller@gmx.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 088/272] parisc: break out SOCK_NONBLOCK define to own asm header file
Date: Fri,  6 Dec 2013 12:56:17 +0000
Message-Id: <1386334761-25517-89-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 38c7937379276a5ea8c54481205003af2f2b5694 upstream.

Break SOCK_NONBLOCK out to its own asm-file as other arches do. This
fixes build errors with auditd and probably other packages.

Signed-off-by: Helge Deller <deller@gmx.de>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/parisc/include/asm/socket.h      | 11 +++++++++++
 arch/parisc/include/uapi/asm/socket.h | 11 +++--------
 2 files changed, 14 insertions(+), 8 deletions(-)
 create mode 100644 arch/parisc/include/asm/socket.h

diff --git a/arch/parisc/include/asm/socket.h b/arch/parisc/include/asm/socket.h
new file mode 100644
index 0000000..748016c
--- /dev/null
+++ b/arch/parisc/include/asm/socket.h
@@ -0,0 +1,11 @@
+#ifndef _ASM_SOCKET_H
+#define _ASM_SOCKET_H
+
+#include <uapi/asm/socket.h>
+
+/* O_NONBLOCK clashes with the bits used for socket types.  Therefore we
+ * have to define SOCK_NONBLOCK to a different value here.
+ */
+#define SOCK_NONBLOCK	0x40000000
+
+#endif /* _ASM_SOCKET_H */
diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
index 71700e6..9f2174f 100644
--- a/arch/parisc/include/uapi/asm/socket.h
+++ b/arch/parisc/include/uapi/asm/socket.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_SOCKET_H
-#define _ASM_SOCKET_H
+#ifndef _UAPI_ASM_SOCKET_H
+#define _UAPI_ASM_SOCKET_H
 
 #include <asm/sockios.h>
 
@@ -75,9 +75,4 @@
 
 #define SO_BUSY_POLL		0x4027
 
-/* O_NONBLOCK clashes with the bits used for socket types.  Therefore we
- * have to define SOCK_NONBLOCK to a different value here.
- */
-#define SOCK_NONBLOCK   0x40000000
-
-#endif /* _ASM_SOCKET_H */
+#endif /* _UAPI_ASM_SOCKET_H */
-- 
1.8.3.2

