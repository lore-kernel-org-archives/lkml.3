Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab3KLIgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 03:36:49 -0500
Received: from intranet.asianux.com ([58.214.24.6]:19916 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab3KLIgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 03:36:40 -0500
X-Spam-Score: -100.9
Message-ID: <5281E917.4030408@asianux.com>
Date: Tue, 12 Nov 2013 16:38:47 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
CC: Al Viro <viro@zeniv.linux.org.uk>, David Miller <davem@davemloft.net>,
        eliezer.tamir@linux.intel.com, bernat@luffy.cx, therbert@google.com,
        jacob.e.keller@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dhowells@redhat.com" <dhowells@redhat.com>
Subject: [PATCH] arch: avr32: uapi: be sure of "_UAPI" prefix for all guard
 macros
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For all uapi headers, need use "_UAPI" prefix for its guard macro
(which will be stripped by "scripts/headers_installer.sh").

Also remove redundant files (bitsperlong.h, errno.h, fcntl.h, ioctl.h,
ioctls.h, ipcbuf.h, kvm_para.h, mman.h, poll.h, resource.h, siginfo.h,
statfs.h, and unistd.h) which are already in Kbuild.

Also be sure that all "#endif" only have one empty line above, and each
file has guard macro.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/avr32/include/uapi/asm/auxvec.h      |    6 +++---
 arch/avr32/include/uapi/asm/bitsperlong.h |    1 -
 arch/avr32/include/uapi/asm/byteorder.h   |    6 +++---
 arch/avr32/include/uapi/asm/cachectl.h    |    6 +++---
 arch/avr32/include/uapi/asm/errno.h       |    6 ------
 arch/avr32/include/uapi/asm/fcntl.h       |    6 ------
 arch/avr32/include/uapi/asm/ioctl.h       |    6 ------
 arch/avr32/include/uapi/asm/ioctls.h      |    6 ------
 arch/avr32/include/uapi/asm/ipcbuf.h      |    1 -
 arch/avr32/include/uapi/asm/kvm_para.h    |    1 -
 arch/avr32/include/uapi/asm/mman.h        |    1 -
 arch/avr32/include/uapi/asm/msgbuf.h      |    6 +++---
 arch/avr32/include/uapi/asm/poll.h        |    1 -
 arch/avr32/include/uapi/asm/posix_types.h |    6 +++---
 arch/avr32/include/uapi/asm/resource.h    |    6 ------
 arch/avr32/include/uapi/asm/sembuf.h      |    6 +++---
 arch/avr32/include/uapi/asm/setup.h       |    1 -
 arch/avr32/include/uapi/asm/shmbuf.h      |    6 +++---
 arch/avr32/include/uapi/asm/sigcontext.h  |    6 +++---
 arch/avr32/include/uapi/asm/siginfo.h     |    6 ------
 arch/avr32/include/uapi/asm/signal.h      |    1 -
 arch/avr32/include/uapi/asm/socket.h      |    6 +++---
 arch/avr32/include/uapi/asm/sockios.h     |    6 +++---
 arch/avr32/include/uapi/asm/stat.h        |    6 +++---
 arch/avr32/include/uapi/asm/statfs.h      |    6 ------
 arch/avr32/include/uapi/asm/swab.h        |    6 +++---
 arch/avr32/include/uapi/asm/termbits.h    |    6 +++---
 arch/avr32/include/uapi/asm/termios.h     |    1 -
 arch/avr32/include/uapi/asm/types.h       |    5 +++++
 arch/avr32/include/uapi/asm/unistd.h      |    1 -
 30 files changed, 44 insertions(+), 90 deletions(-)
 delete mode 100644 arch/avr32/include/uapi/asm/bitsperlong.h
 delete mode 100644 arch/avr32/include/uapi/asm/errno.h
 delete mode 100644 arch/avr32/include/uapi/asm/fcntl.h
 delete mode 100644 arch/avr32/include/uapi/asm/ioctl.h
 delete mode 100644 arch/avr32/include/uapi/asm/ioctls.h
 delete mode 100644 arch/avr32/include/uapi/asm/ipcbuf.h
 delete mode 100644 arch/avr32/include/uapi/asm/kvm_para.h
 delete mode 100644 arch/avr32/include/uapi/asm/mman.h
 delete mode 100644 arch/avr32/include/uapi/asm/poll.h
 delete mode 100644 arch/avr32/include/uapi/asm/resource.h
 delete mode 100644 arch/avr32/include/uapi/asm/siginfo.h
 delete mode 100644 arch/avr32/include/uapi/asm/statfs.h

diff --git a/arch/avr32/include/uapi/asm/auxvec.h b/arch/avr32/include/uapi/asm/auxvec.h
index d5dd435..4f02da3 100644
--- a/arch/avr32/include/uapi/asm/auxvec.h
+++ b/arch/avr32/include/uapi/asm/auxvec.h
@@ -1,4 +1,4 @@
-#ifndef __ASM_AVR32_AUXVEC_H
-#define __ASM_AVR32_AUXVEC_H
+#ifndef _UAPI__ASM_AVR32_AUXVEC_H
+#define _UAPI__ASM_AVR32_AUXVEC_H
 
-#endif /* __ASM_AVR32_AUXVEC_H */
+#endif /* _UAPI__ASM_AVR32_AUXVEC_H */
diff --git a/arch/avr32/include/uapi/asm/bitsperlong.h b/arch/avr32/include/uapi/asm/bitsperlong.h
deleted file mode 100644
index 6dc0bb0..0000000
--- a/arch/avr32/include/uapi/asm/bitsperlong.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/bitsperlong.h>
diff --git a/arch/avr32/include/uapi/asm/byteorder.h b/arch/avr32/include/uapi/asm/byteorder.h
index 50abc21..71242f0 100644
--- a/arch/avr32/include/uapi/asm/byteorder.h
+++ b/arch/avr32/include/uapi/asm/byteorder.h
@@ -1,9 +1,9 @@
 /*
  * AVR32 endian-conversion functions.
  */
-#ifndef __ASM_AVR32_BYTEORDER_H
-#define __ASM_AVR32_BYTEORDER_H
+#ifndef _UAPI__ASM_AVR32_BYTEORDER_H
+#define _UAPI__ASM_AVR32_BYTEORDER_H
 
 #include <linux/byteorder/big_endian.h>
 
-#endif /* __ASM_AVR32_BYTEORDER_H */
+#endif /* _UAPI__ASM_AVR32_BYTEORDER_H */
diff --git a/arch/avr32/include/uapi/asm/cachectl.h b/arch/avr32/include/uapi/asm/cachectl.h
index 4faf1ce..573a958 100644
--- a/arch/avr32/include/uapi/asm/cachectl.h
+++ b/arch/avr32/include/uapi/asm/cachectl.h
@@ -1,5 +1,5 @@
-#ifndef __ASM_AVR32_CACHECTL_H
-#define __ASM_AVR32_CACHECTL_H
+#ifndef _UAPI__ASM_AVR32_CACHECTL_H
+#define _UAPI__ASM_AVR32_CACHECTL_H
 
 /*
  * Operations that can be performed through the cacheflush system call
@@ -8,4 +8,4 @@
 /* Clean the data cache, then invalidate the icache */
 #define CACHE_IFLUSH	0
 
-#endif /* __ASM_AVR32_CACHECTL_H */
+#endif /* _UAPI__ASM_AVR32_CACHECTL_H */
diff --git a/arch/avr32/include/uapi/asm/errno.h b/arch/avr32/include/uapi/asm/errno.h
deleted file mode 100644
index 558a724..0000000
--- a/arch/avr32/include/uapi/asm/errno.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_AVR32_ERRNO_H
-#define __ASM_AVR32_ERRNO_H
-
-#include <asm-generic/errno.h>
-
-#endif /* __ASM_AVR32_ERRNO_H */
diff --git a/arch/avr32/include/uapi/asm/fcntl.h b/arch/avr32/include/uapi/asm/fcntl.h
deleted file mode 100644
index 14c0c44..0000000
--- a/arch/avr32/include/uapi/asm/fcntl.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_AVR32_FCNTL_H
-#define __ASM_AVR32_FCNTL_H
-
-#include <asm-generic/fcntl.h>
-
-#endif /* __ASM_AVR32_FCNTL_H */
diff --git a/arch/avr32/include/uapi/asm/ioctl.h b/arch/avr32/include/uapi/asm/ioctl.h
deleted file mode 100644
index c8472c1..0000000
--- a/arch/avr32/include/uapi/asm/ioctl.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_AVR32_IOCTL_H
-#define __ASM_AVR32_IOCTL_H
-
-#include <asm-generic/ioctl.h>
-
-#endif /* __ASM_AVR32_IOCTL_H */
diff --git a/arch/avr32/include/uapi/asm/ioctls.h b/arch/avr32/include/uapi/asm/ioctls.h
deleted file mode 100644
index 909cf66..0000000
--- a/arch/avr32/include/uapi/asm/ioctls.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_AVR32_IOCTLS_H
-#define __ASM_AVR32_IOCTLS_H
-
-#include <asm-generic/ioctls.h>
-
-#endif /* __ASM_AVR32_IOCTLS_H */
diff --git a/arch/avr32/include/uapi/asm/ipcbuf.h b/arch/avr32/include/uapi/asm/ipcbuf.h
deleted file mode 100644
index 84c7e51..0000000
--- a/arch/avr32/include/uapi/asm/ipcbuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipcbuf.h>
diff --git a/arch/avr32/include/uapi/asm/kvm_para.h b/arch/avr32/include/uapi/asm/kvm_para.h
deleted file mode 100644
index 14fab8f..0000000
--- a/arch/avr32/include/uapi/asm/kvm_para.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kvm_para.h>
diff --git a/arch/avr32/include/uapi/asm/mman.h b/arch/avr32/include/uapi/asm/mman.h
deleted file mode 100644
index 8eebf89..0000000
--- a/arch/avr32/include/uapi/asm/mman.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/mman.h>
diff --git a/arch/avr32/include/uapi/asm/msgbuf.h b/arch/avr32/include/uapi/asm/msgbuf.h
index ac18bc4..9eae6ef 100644
--- a/arch/avr32/include/uapi/asm/msgbuf.h
+++ b/arch/avr32/include/uapi/asm/msgbuf.h
@@ -1,5 +1,5 @@
-#ifndef __ASM_AVR32_MSGBUF_H
-#define __ASM_AVR32_MSGBUF_H
+#ifndef _UAPI__ASM_AVR32_MSGBUF_H
+#define _UAPI__ASM_AVR32_MSGBUF_H
 
 /*
  * The msqid64_ds structure for i386 architecture.
@@ -28,4 +28,4 @@ struct msqid64_ds {
 	unsigned long  __unused5;
 };
 
-#endif /* __ASM_AVR32_MSGBUF_H */
+#endif /* _UAPI__ASM_AVR32_MSGBUF_H */
diff --git a/arch/avr32/include/uapi/asm/poll.h b/arch/avr32/include/uapi/asm/poll.h
deleted file mode 100644
index c98509d..0000000
--- a/arch/avr32/include/uapi/asm/poll.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/poll.h>
diff --git a/arch/avr32/include/uapi/asm/posix_types.h b/arch/avr32/include/uapi/asm/posix_types.h
index 9ba9e74..5b813a8 100644
--- a/arch/avr32/include/uapi/asm/posix_types.h
+++ b/arch/avr32/include/uapi/asm/posix_types.h
@@ -5,8 +5,8 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#ifndef __ASM_AVR32_POSIX_TYPES_H
-#define __ASM_AVR32_POSIX_TYPES_H
+#ifndef _UAPI__ASM_AVR32_POSIX_TYPES_H
+#define _UAPI__ASM_AVR32_POSIX_TYPES_H
 
 /*
  * This file is generally used by user-level software, so you need to
@@ -34,4 +34,4 @@ typedef unsigned short  __kernel_old_dev_t;
 
 #include <asm-generic/posix_types.h>
 
-#endif /* __ASM_AVR32_POSIX_TYPES_H */
+#endif /* _UAPI__ASM_AVR32_POSIX_TYPES_H */
diff --git a/arch/avr32/include/uapi/asm/resource.h b/arch/avr32/include/uapi/asm/resource.h
deleted file mode 100644
index c6dd101..0000000
--- a/arch/avr32/include/uapi/asm/resource.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_AVR32_RESOURCE_H
-#define __ASM_AVR32_RESOURCE_H
-
-#include <asm-generic/resource.h>
-
-#endif /* __ASM_AVR32_RESOURCE_H */
diff --git a/arch/avr32/include/uapi/asm/sembuf.h b/arch/avr32/include/uapi/asm/sembuf.h
index e472216..6c6f7cf 100644
--- a/arch/avr32/include/uapi/asm/sembuf.h
+++ b/arch/avr32/include/uapi/asm/sembuf.h
@@ -1,5 +1,5 @@
-#ifndef __ASM_AVR32_SEMBUF_H
-#define __ASM_AVR32_SEMBUF_H
+#ifndef _UAPI__ASM_AVR32_SEMBUF_H
+#define _UAPI__ASM_AVR32_SEMBUF_H
 
 /*
 * The semid64_ds structure for AVR32 architecture.
@@ -22,4 +22,4 @@ struct semid64_ds {
         unsigned long   __unused4;
 };
 
-#endif /* __ASM_AVR32_SEMBUF_H */
+#endif /* _UAPI__ASM_AVR32_SEMBUF_H */
diff --git a/arch/avr32/include/uapi/asm/setup.h b/arch/avr32/include/uapi/asm/setup.h
index e58aa93..a654df7 100644
--- a/arch/avr32/include/uapi/asm/setup.h
+++ b/arch/avr32/include/uapi/asm/setup.h
@@ -13,5 +13,4 @@
 
 #define COMMAND_LINE_SIZE 256
 
-
 #endif /* _UAPI__ASM_AVR32_SETUP_H__ */
diff --git a/arch/avr32/include/uapi/asm/shmbuf.h b/arch/avr32/include/uapi/asm/shmbuf.h
index c62fba4..b94cf8b 100644
--- a/arch/avr32/include/uapi/asm/shmbuf.h
+++ b/arch/avr32/include/uapi/asm/shmbuf.h
@@ -1,5 +1,5 @@
-#ifndef __ASM_AVR32_SHMBUF_H
-#define __ASM_AVR32_SHMBUF_H
+#ifndef _UAPI__ASM_AVR32_SHMBUF_H
+#define _UAPI__ASM_AVR32_SHMBUF_H
 
 /*
  * The shmid64_ds structure for i386 architecture.
@@ -39,4 +39,4 @@ struct shminfo64 {
 	unsigned long	__unused4;
 };
 
-#endif /* __ASM_AVR32_SHMBUF_H */
+#endif /* _UAPI__ASM_AVR32_SHMBUF_H */
diff --git a/arch/avr32/include/uapi/asm/sigcontext.h b/arch/avr32/include/uapi/asm/sigcontext.h
index e04062b..27e56bf 100644
--- a/arch/avr32/include/uapi/asm/sigcontext.h
+++ b/arch/avr32/include/uapi/asm/sigcontext.h
@@ -5,8 +5,8 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#ifndef __ASM_AVR32_SIGCONTEXT_H
-#define __ASM_AVR32_SIGCONTEXT_H
+#ifndef _UAPI__ASM_AVR32_SIGCONTEXT_H
+#define _UAPI__ASM_AVR32_SIGCONTEXT_H
 
 struct sigcontext {
 	unsigned long	oldmask;
@@ -31,4 +31,4 @@ struct sigcontext {
 	unsigned long	r0;
 };
 
-#endif /* __ASM_AVR32_SIGCONTEXT_H */
+#endif /* _UAPI__ASM_AVR32_SIGCONTEXT_H */
diff --git a/arch/avr32/include/uapi/asm/siginfo.h b/arch/avr32/include/uapi/asm/siginfo.h
deleted file mode 100644
index 5ee93f4..0000000
--- a/arch/avr32/include/uapi/asm/siginfo.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _AVR32_SIGINFO_H
-#define _AVR32_SIGINFO_H
-
-#include <asm-generic/siginfo.h>
-
-#endif
diff --git a/arch/avr32/include/uapi/asm/signal.h b/arch/avr32/include/uapi/asm/signal.h
index 1b77a93..ffe8c77 100644
--- a/arch/avr32/include/uapi/asm/signal.h
+++ b/arch/avr32/include/uapi/asm/signal.h
@@ -118,5 +118,4 @@ typedef struct sigaltstack {
 	size_t ss_size;
 } stack_t;
 
-
 #endif /* _UAPI__ASM_AVR32_SIGNAL_H */
diff --git a/arch/avr32/include/uapi/asm/socket.h b/arch/avr32/include/uapi/asm/socket.h
index 4399364..cbf902e 100644
--- a/arch/avr32/include/uapi/asm/socket.h
+++ b/arch/avr32/include/uapi/asm/socket.h
@@ -1,5 +1,5 @@
-#ifndef __ASM_AVR32_SOCKET_H
-#define __ASM_AVR32_SOCKET_H
+#ifndef _UAPI__ASM_AVR32_SOCKET_H
+#define _UAPI__ASM_AVR32_SOCKET_H
 
 #include <asm/sockios.h>
 
@@ -78,4 +78,4 @@
 
 #define SO_MAX_PACING_RATE	47
 
-#endif /* __ASM_AVR32_SOCKET_H */
+#endif /* _UAPI__ASM_AVR32_SOCKET_H */
diff --git a/arch/avr32/include/uapi/asm/sockios.h b/arch/avr32/include/uapi/asm/sockios.h
index 0802d74..d04785453 100644
--- a/arch/avr32/include/uapi/asm/sockios.h
+++ b/arch/avr32/include/uapi/asm/sockios.h
@@ -1,5 +1,5 @@
-#ifndef __ASM_AVR32_SOCKIOS_H
-#define __ASM_AVR32_SOCKIOS_H
+#ifndef _UAPI__ASM_AVR32_SOCKIOS_H
+#define _UAPI__ASM_AVR32_SOCKIOS_H
 
 /* Socket-level I/O control calls. */
 #define FIOSETOWN 	0x8901
@@ -10,4 +10,4 @@
 #define SIOCGSTAMP	0x8906		/* Get stamp (timeval) */
 #define SIOCGSTAMPNS	0x8907		/* Get stamp (timespec) */
 
-#endif /* __ASM_AVR32_SOCKIOS_H */
+#endif /* _UAPI__ASM_AVR32_SOCKIOS_H */
diff --git a/arch/avr32/include/uapi/asm/stat.h b/arch/avr32/include/uapi/asm/stat.h
index e72881e..c06acef 100644
--- a/arch/avr32/include/uapi/asm/stat.h
+++ b/arch/avr32/include/uapi/asm/stat.h
@@ -5,8 +5,8 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#ifndef __ASM_AVR32_STAT_H
-#define __ASM_AVR32_STAT_H
+#ifndef _UAPI__ASM_AVR32_STAT_H
+#define _UAPI__ASM_AVR32_STAT_H
 
 struct __old_kernel_stat {
         unsigned short st_dev;
@@ -76,4 +76,4 @@ struct stat64 {
 	unsigned long	__unused2;
 };
 
-#endif /* __ASM_AVR32_STAT_H */
+#endif /* _UAPI__ASM_AVR32_STAT_H */
diff --git a/arch/avr32/include/uapi/asm/statfs.h b/arch/avr32/include/uapi/asm/statfs.h
deleted file mode 100644
index 2961bd1..0000000
--- a/arch/avr32/include/uapi/asm/statfs.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_AVR32_STATFS_H
-#define __ASM_AVR32_STATFS_H
-
-#include <asm-generic/statfs.h>
-
-#endif /* __ASM_AVR32_STATFS_H */
diff --git a/arch/avr32/include/uapi/asm/swab.h b/arch/avr32/include/uapi/asm/swab.h
index 14cc737..1a03549 100644
--- a/arch/avr32/include/uapi/asm/swab.h
+++ b/arch/avr32/include/uapi/asm/swab.h
@@ -1,8 +1,8 @@
 /*
  * AVR32 byteswapping functions.
  */
-#ifndef __ASM_AVR32_SWAB_H
-#define __ASM_AVR32_SWAB_H
+#ifndef _UAPI__ASM_AVR32_SWAB_H
+#define _UAPI__ASM_AVR32_SWAB_H
 
 #include <linux/types.h>
 #include <linux/compiler.h>
@@ -32,4 +32,4 @@ static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
 #define __arch_swab32 __arch_swab32
 #endif
 
-#endif /* __ASM_AVR32_SWAB_H */
+#endif /* _UAPI__ASM_AVR32_SWAB_H */
diff --git a/arch/avr32/include/uapi/asm/termbits.h b/arch/avr32/include/uapi/asm/termbits.h
index 366adc5..32789cc 100644
--- a/arch/avr32/include/uapi/asm/termbits.h
+++ b/arch/avr32/include/uapi/asm/termbits.h
@@ -1,5 +1,5 @@
-#ifndef __ASM_AVR32_TERMBITS_H
-#define __ASM_AVR32_TERMBITS_H
+#ifndef _UAPI__ASM_AVR32_TERMBITS_H
+#define _UAPI__ASM_AVR32_TERMBITS_H
 
 #include <linux/posix_types.h>
 
@@ -193,4 +193,4 @@ struct ktermios {
 #define	TCSADRAIN	1
 #define	TCSAFLUSH	2
 
-#endif /* __ASM_AVR32_TERMBITS_H */
+#endif /* _UAPI__ASM_AVR32_TERMBITS_H */
diff --git a/arch/avr32/include/uapi/asm/termios.h b/arch/avr32/include/uapi/asm/termios.h
index b8ef8ea..c8a0081 100644
--- a/arch/avr32/include/uapi/asm/termios.h
+++ b/arch/avr32/include/uapi/asm/termios.h
@@ -46,5 +46,4 @@ struct termio {
 
 /* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
 
-
 #endif /* _UAPI__ASM_AVR32_TERMIOS_H */
diff --git a/arch/avr32/include/uapi/asm/types.h b/arch/avr32/include/uapi/asm/types.h
index bb34ad3..7c986c4 100644
--- a/arch/avr32/include/uapi/asm/types.h
+++ b/arch/avr32/include/uapi/asm/types.h
@@ -5,4 +5,9 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#ifndef _UAPI__ASM_AVR32_TYPES_H
+#define _UAPI__ASM_AVR32_TYPES_H
+
 #include <asm-generic/int-ll64.h>
+
+#endif /* _UAPI__ASM_AVR32_TYPES_H */
diff --git a/arch/avr32/include/uapi/asm/unistd.h b/arch/avr32/include/uapi/asm/unistd.h
index 3eaa687..8822bf4 100644
--- a/arch/avr32/include/uapi/asm/unistd.h
+++ b/arch/avr32/include/uapi/asm/unistd.h
@@ -301,5 +301,4 @@
 #define __NR_eventfd		281
 #define __NR_setns		283
 
-
 #endif /* _UAPI__ASM_AVR32_UNISTD_H */
-- 
1.7.7.6
