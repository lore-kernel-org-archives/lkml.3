Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826AbaHVQcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:32:16 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:42899 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206AbaHVQac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:30:32 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] errno.h: Improve ENOSYS's comment
Date: Fri, 22 Aug 2014 09:30:27 -0700
Message-Id: <5c34ad9efb9b1ef1ffed1077d064ad877819dffc.1408724938.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ENOSYS is the mechanism used by user code to detect whether the
running kernel implements a given system call.  It should not be
returned by anything except an unimplemented system call.

Unfortunately, it is rather frequently used in the kernel to
indicate that various new functions of existing system calls are not
implemented.  This should be discouraged.

Improve the command in errno.h to help clarify ENOSYS's purpose.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 include/uapi/asm-generic/errno.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/asm-generic/errno.h b/include/uapi/asm-generic/errno.h
index 1e1ea6e..b24a400 100644
--- a/include/uapi/asm-generic/errno.h
+++ b/include/uapi/asm-generic/errno.h
@@ -6,7 +6,7 @@
 #define	EDEADLK		35	/* Resource deadlock would occur */
 #define	ENAMETOOLONG	36	/* File name too long */
 #define	ENOLCK		37	/* No record locks available */
-#define	ENOSYS		38	/* Function not implemented */
+#define	ENOSYS		38	/* Bad system call number */
 #define	ENOTEMPTY	39	/* Directory not empty */
 #define	ELOOP		40	/* Too many symbolic links encountered */
 #define	EWOULDBLOCK	EAGAIN	/* Operation would block */
-- 
1.9.3

