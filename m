Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab3LBUVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:21:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab3LBTRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 3.12 034/212] parisc: break out SOCK_NONBLOCK define to own asm header file
Date: Mon,  2 Dec 2013 11:13:45 -0800
Message-Id: <20131202191252.320637887@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 38c7937379276a5ea8c54481205003af2f2b5694 upstream.

Break SOCK_NONBLOCK out to its own asm-file as other arches do. This
fixes build errors with auditd and probably other packages.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/include/asm/socket.h      |   11 +++++++++++
 arch/parisc/include/uapi/asm/socket.h |   11 +++--------
 2 files changed, 14 insertions(+), 8 deletions(-)

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


