Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966695Ab3HHVIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 17:08:32 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:55117 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966674Ab3HHVIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 17:08:30 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Arnd Bergmann <arnd@arndb.de>, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 3/4] asm-generic: Add missing include guards
Date: Thu,  8 Aug 2013 21:07:01 +0000
Message-Id: <1375996022-8298-4-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375996022-8298-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1375996022-8298-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add include guards to include/asm-generic/{ide_iops,unistd,xor}.h.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/asm-generic/ide_iops.h |    4 ++++
 include/asm-generic/unistd.h   |    5 +++++
 include/asm-generic/xor.h      |    4 ++++
 3 files changed, 13 insertions(+)

diff --git a/include/asm-generic/ide_iops.h b/include/asm-generic/ide_iops.h
index 1b91d06..cfe2ab8 100644
--- a/include/asm-generic/ide_iops.h
+++ b/include/asm-generic/ide_iops.h
@@ -1,4 +1,6 @@
 /* Generic I/O and MEMIO string operations.  */
+#ifndef _ASM_GENERIC_IDE_IOPS_H
+#define _ASM_GENERIC_IDE_IOPS_H
 
 #define __ide_insw	insw
 #define __ide_insl	insl
@@ -36,3 +38,5 @@ static __inline__ void __ide_mm_outsl(void __iomem * port, void *addr, u32 count
 		addr += 4;
 	}
 }
+
+#endif /* _ASM_GENERIC_IDE_IOPS_H */
diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index cccc86e..0cff2e9 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -1,3 +1,6 @@
+#ifndef _ASM_GENERIC_UNISTD_H
+#define _ASM_GENERIC_UNISTD_H
+
 #include <uapi/asm-generic/unistd.h>
 #include <linux/export.h>
 
@@ -10,3 +13,5 @@
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_LLSEEK
 #endif
+
+#endif /* _ASM_GENERIC_UNISTD_H */
diff --git a/include/asm-generic/xor.h b/include/asm-generic/xor.h
index b4d8432..d063878 100644
--- a/include/asm-generic/xor.h
+++ b/include/asm-generic/xor.h
@@ -12,6 +12,8 @@
  * (for example /usr/src/linux/COPYING); if not, write to the Free
  * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
+#ifndef _ASM_GENERIC_XOR_H
+#define _ASM_GENERIC_XOR_H
 
 #include <linux/prefetch.h>
 
@@ -716,3 +718,5 @@ static struct xor_block_template xor_block_32regs_p __maybe_unused = {
 		xor_speed(&xor_block_32regs);	\
 		xor_speed(&xor_block_32regs_p);	\
 	} while (0)
+
+#endif /* _ASM_GENERIC_XOR_H */
-- 
1.7.9.5

