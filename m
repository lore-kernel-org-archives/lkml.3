Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab3KLJB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 04:01:58 -0500
Received: from intranet.asianux.com ([58.214.24.6]:63957 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab3KLJBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 04:01:55 -0500
X-Spam-Score: -100.9
Message-ID: <5281EF04.6000304@asianux.com>
Date: Tue, 12 Nov 2013 17:04:04 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Jones <davej@redhat.com>
CC: "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch: blackfin: uapi: be sure of "_UAPI" prefix for all guard
 macros
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For all uapi headers, need use "_UAPI" prefix for its guard macro
(which will be stripped by "scripts/headers_installer.sh").

Also be sure that all files have their guard macros.

Also be sure that all "#endif" are followed with comments, and no '\t'
for guard macro


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/blackfin/include/uapi/asm/byteorder.h   |    5 +++++
 arch/blackfin/include/uapi/asm/cachectl.h    |    6 +++---
 arch/blackfin/include/uapi/asm/fcntl.h       |    6 +++---
 arch/blackfin/include/uapi/asm/ioctls.h      |    6 +++---
 arch/blackfin/include/uapi/asm/poll.h        |    6 +++---
 arch/blackfin/include/uapi/asm/posix_types.h |    6 +++---
 arch/blackfin/include/uapi/asm/sigcontext.h  |    6 +++---
 arch/blackfin/include/uapi/asm/siginfo.h     |    6 +++---
 arch/blackfin/include/uapi/asm/signal.h      |    6 +++---
 arch/blackfin/include/uapi/asm/stat.h        |    6 +++---
 arch/blackfin/include/uapi/asm/swab.h        |    6 +++---
 11 files changed, 35 insertions(+), 30 deletions(-)

diff --git a/arch/blackfin/include/uapi/asm/byteorder.h b/arch/blackfin/include/uapi/asm/byteorder.h
index 9558416..3b125da 100644
--- a/arch/blackfin/include/uapi/asm/byteorder.h
+++ b/arch/blackfin/include/uapi/asm/byteorder.h
@@ -1 +1,6 @@
+#ifndef _UAPI__BFIN_ASM_BYTEORDER_H
+#define _UAPI__BFIN_ASM_BYTEORDER_H
+
 #include <linux/byteorder/little_endian.h>
+
+#endif /* _UAPI__BFIN_ASM_BYTEORDER_H */
diff --git a/arch/blackfin/include/uapi/asm/cachectl.h b/arch/blackfin/include/uapi/asm/cachectl.h
index 03255df..4fdab75 100644
--- a/arch/blackfin/include/uapi/asm/cachectl.h
+++ b/arch/blackfin/include/uapi/asm/cachectl.h
@@ -7,8 +7,8 @@
  * Licensed under the GPL-2 or later.
  */
 
-#ifndef	_ASM_CACHECTL
-#define	_ASM_CACHECTL
+#ifndef _UAPI_ASM_CACHECTL
+#define _UAPI_ASM_CACHECTL
 
 /*
  * Options for cacheflush system call
@@ -17,4 +17,4 @@
 #define	DCACHE	(1<<1)		/* writeback and flush data cache */
 #define	BCACHE	(ICACHE|DCACHE)	/* flush both caches              */
 
-#endif	/* _ASM_CACHECTL */
+#endif /* _UAPI_ASM_CACHECTL */
diff --git a/arch/blackfin/include/uapi/asm/fcntl.h b/arch/blackfin/include/uapi/asm/fcntl.h
index 251c911..f51ad9a 100644
--- a/arch/blackfin/include/uapi/asm/fcntl.h
+++ b/arch/blackfin/include/uapi/asm/fcntl.h
@@ -4,8 +4,8 @@
  * Licensed under the GPL-2 or later.
  */
 
-#ifndef _BFIN_FCNTL_H
-#define _BFIN_FCNTL_H
+#ifndef _UAPI_BFIN_FCNTL_H
+#define _UAPI_BFIN_FCNTL_H
 
 #define O_DIRECTORY	 040000	/* must be a directory */
 #define O_NOFOLLOW	0100000	/* don't follow links */
@@ -14,4 +14,4 @@
 
 #include <asm-generic/fcntl.h>
 
-#endif
+#endif /* _UAPI_BFIN_FCNTL_H */
diff --git a/arch/blackfin/include/uapi/asm/ioctls.h b/arch/blackfin/include/uapi/asm/ioctls.h
index eca8d75..9a41c20 100644
--- a/arch/blackfin/include/uapi/asm/ioctls.h
+++ b/arch/blackfin/include/uapi/asm/ioctls.h
@@ -1,7 +1,7 @@
-#ifndef __ARCH_BFIN_IOCTLS_H__
-#define __ARCH_BFIN_IOCTLS_H__
+#ifndef _UAPI__ARCH_BFIN_IOCTLS_H__
+#define _UAPI__ARCH_BFIN_IOCTLS_H__
 
 #define FIOQSIZE	0x545E
 #include <asm-generic/ioctls.h>
 
-#endif
+#endif /* _UAPI__ARCH_BFIN_IOCTLS_H__ */
diff --git a/arch/blackfin/include/uapi/asm/poll.h b/arch/blackfin/include/uapi/asm/poll.h
index 072d896..99c7d68 100644
--- a/arch/blackfin/include/uapi/asm/poll.h
+++ b/arch/blackfin/include/uapi/asm/poll.h
@@ -5,12 +5,12 @@
  *
  */
 
-#ifndef __BFIN_POLL_H
-#define __BFIN_POLL_H
+#ifndef _UAPI__BFIN_POLL_H
+#define _UAPI__BFIN_POLL_H
 
 #define POLLWRNORM	4 /* POLLOUT */
 #define POLLWRBAND	256
 
 #include <asm-generic/poll.h>
 
-#endif
+#endif /* _UAPI__BFIN_POLL_H */
diff --git a/arch/blackfin/include/uapi/asm/posix_types.h b/arch/blackfin/include/uapi/asm/posix_types.h
index 1bd3436..9608ef6 100644
--- a/arch/blackfin/include/uapi/asm/posix_types.h
+++ b/arch/blackfin/include/uapi/asm/posix_types.h
@@ -4,8 +4,8 @@
  * Licensed under the GPL-2 or later.
  */
 
-#ifndef __ARCH_BFIN_POSIX_TYPES_H
-#define __ARCH_BFIN_POSIX_TYPES_H
+#ifndef _UAPI__ARCH_BFIN_POSIX_TYPES_H
+#define _UAPI__ARCH_BFIN_POSIX_TYPES_H
 
 typedef unsigned short __kernel_mode_t;
 #define __kernel_mode_t __kernel_mode_t
@@ -27,4 +27,4 @@ typedef unsigned short __kernel_old_dev_t;
 
 #include <asm-generic/posix_types.h>
 
-#endif
+#endif /* _UAPI__ARCH_BFIN_POSIX_TYPES_H */
diff --git a/arch/blackfin/include/uapi/asm/sigcontext.h b/arch/blackfin/include/uapi/asm/sigcontext.h
index 906bdc1..b58f12d 100644
--- a/arch/blackfin/include/uapi/asm/sigcontext.h
+++ b/arch/blackfin/include/uapi/asm/sigcontext.h
@@ -4,8 +4,8 @@
  * Licensed under the GPL-2 or later.
  */
 
-#ifndef _ASM_BLACKFIN_SIGCONTEXT_H
-#define _ASM_BLACKFIN_SIGCONTEXT_H
+#ifndef _UAPI_ASM_BLACKFIN_SIGCONTEXT_H
+#define _UAPI_ASM_BLACKFIN_SIGCONTEXT_H
 
 /* Add new entries at the end of the structure only.  */
 struct sigcontext {
@@ -58,4 +58,4 @@ struct sigcontext {
 	unsigned long sc_seqstat;
 };
 
-#endif
+#endif /* _UAPI_ASM_BLACKFIN_SIGCONTEXT_H */
diff --git a/arch/blackfin/include/uapi/asm/siginfo.h b/arch/blackfin/include/uapi/asm/siginfo.h
index 3e81306..c72f4e6 100644
--- a/arch/blackfin/include/uapi/asm/siginfo.h
+++ b/arch/blackfin/include/uapi/asm/siginfo.h
@@ -4,8 +4,8 @@
  * Licensed under the GPL-2 or later.
  */
 
-#ifndef _BFIN_SIGINFO_H
-#define _BFIN_SIGINFO_H
+#ifndef _UAPI_BFIN_SIGINFO_H
+#define _UAPI_BFIN_SIGINFO_H
 
 #include <linux/types.h>
 #include <asm-generic/siginfo.h>
@@ -38,4 +38,4 @@
  */
 #define SEGV_STACKFLOW	(__SI_FAULT|3)	/* stack overflow */
 
-#endif
+#endif /* _UAPI_BFIN_SIGINFO_H */
diff --git a/arch/blackfin/include/uapi/asm/signal.h b/arch/blackfin/include/uapi/asm/signal.h
index 77a3bf3..f0a0d8b 100644
--- a/arch/blackfin/include/uapi/asm/signal.h
+++ b/arch/blackfin/include/uapi/asm/signal.h
@@ -1,7 +1,7 @@
-#ifndef _BLACKFIN_SIGNAL_H
-#define _BLACKFIN_SIGNAL_H
+#ifndef _UAPI_BLACKFIN_SIGNAL_H
+#define _UAPI_BLACKFIN_SIGNAL_H
 
 #define SA_RESTORER 0x04000000
 #include <asm-generic/signal.h>
 
-#endif
+#endif /* _UAPI_BLACKFIN_SIGNAL_H */
diff --git a/arch/blackfin/include/uapi/asm/stat.h b/arch/blackfin/include/uapi/asm/stat.h
index 2e27665..d3068a7 100644
--- a/arch/blackfin/include/uapi/asm/stat.h
+++ b/arch/blackfin/include/uapi/asm/stat.h
@@ -4,8 +4,8 @@
  * Licensed under the GPL-2.
  */
 
-#ifndef _BFIN_STAT_H
-#define _BFIN_STAT_H
+#ifndef _UAPI_BFIN_STAT_H
+#define _UAPI_BFIN_STAT_H
 
 struct stat {
 	unsigned short st_dev;
@@ -66,4 +66,4 @@ struct stat64 {
 	unsigned long long st_ino;
 };
 
-#endif				/* _BFIN_STAT_H */
+#endif /* _UAPI_BFIN_STAT_H */
diff --git a/arch/blackfin/include/uapi/asm/swab.h b/arch/blackfin/include/uapi/asm/swab.h
index 89de650..f5626b7 100644
--- a/arch/blackfin/include/uapi/asm/swab.h
+++ b/arch/blackfin/include/uapi/asm/swab.h
@@ -4,8 +4,8 @@
  * Licensed under the GPL-2 or later.
  */
 
-#ifndef _BLACKFIN_SWAB_H
-#define _BLACKFIN_SWAB_H
+#ifndef _UAPI_BLACKFIN_SWAB_H
+#define _UAPI_BLACKFIN_SWAB_H
 
 #include <linux/types.h>
 #include <asm-generic/swab.h>
@@ -47,4 +47,4 @@ static __inline__ __attribute_const__ __u16 __arch_swab16(__u16 xx)
 
 #endif /* __GNUC__ */
 
-#endif				/* _BLACKFIN_SWAB_H */
+#endif /* _UAPI_BLACKFIN_SWAB_H */
-- 
1.7.7.6
