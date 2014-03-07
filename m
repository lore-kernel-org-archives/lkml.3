Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaCGPFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:05:44 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37958 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751648AbaCGPFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:05:42 -0500
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] asm-generic: rwsem: de-PPCify rwsem.h
Date: Fri,  7 Mar 2014 15:05:24 +0000
Message-Id: <1394204724-18898-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asm-generic/rwsem.h used to live under arch/powerpc. During its
liberation to common code, a few references to its former home where
preserved, in particular the definition of RWSEM_ACTIVE_MASK is
predicated on CONFIG_PPC64.

This patch updates the ifdefs and comments to architecturally neutral
versions.

Cc: Arnd Bergmann <arnd@arndb.de>
Acked-by: Richard Kuo <rkuo@codeaurora.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---

Hi Arnd,

Any chance you could queue this for 3.15 please? It means I can easily
move arm64 over to the asm-generic rwsem implementation afterwards.

Cheers,

Will

 include/asm-generic/rwsem.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/asm-generic/rwsem.h b/include/asm-generic/rwsem.h
index bb1e2cdeb9bf..d48bf5a95cc1 100644
--- a/include/asm-generic/rwsem.h
+++ b/include/asm-generic/rwsem.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_POWERPC_RWSEM_H
-#define _ASM_POWERPC_RWSEM_H
+#ifndef _ASM_GENERIC_RWSEM_H
+#define _ASM_GENERIC_RWSEM_H
 
 #ifndef _LINUX_RWSEM_H
 #error "Please don't include <asm/rwsem.h> directly, use <linux/rwsem.h> instead."
@@ -8,7 +8,7 @@
 #ifdef __KERNEL__
 
 /*
- * R/W semaphores for PPC using the stuff in lib/rwsem.c.
+ * R/W semaphores originally for PPC using the stuff in lib/rwsem.c.
  * Adapted largely from include/asm-i386/rwsem.h
  * by Paul Mackerras <paulus@samba.org>.
  */
@@ -16,7 +16,7 @@
 /*
  * the semaphore definition
  */
-#ifdef CONFIG_PPC64
+#ifdef CONFIG_64BIT
 # define RWSEM_ACTIVE_MASK		0xffffffffL
 #else
 # define RWSEM_ACTIVE_MASK		0x0000ffffL
@@ -129,4 +129,4 @@ static inline long rwsem_atomic_update(long delta, struct rw_semaphore *sem)
 }
 
 #endif	/* __KERNEL__ */
-#endif	/* _ASM_POWERPC_RWSEM_H */
+#endif	/* _ASM_GENERIC_RWSEM_H */
-- 
1.8.2.2

