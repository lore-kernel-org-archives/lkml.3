Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab3KGEBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 23:01:42 -0500
Received: from intranet.asianux.com ([58.214.24.6]:40691 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab3KGEBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 23:01:35 -0500
X-Spam-Score: -100.8
Message-ID: <527B111C.7030303@asianux.com>
Date: Thu, 07 Nov 2013 12:03:40 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "dhowells@redhat.com" <dhowells@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, mcree@orcon.net.nz,
        Dave Jones <davej@redhat.com>, sandeen@redhat.com,
        Al Viro <viro@zeniv.linux.org.uk>, ak@linux.intel.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        alpha <linux-alpha@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch: alpha: uapi: be sure of "_UAPI" prefix for all guard
 macros
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For all uapi headers, need use "_UAPI" prefix for its guard macro
(which will be stripped by "scripts/headers_installler.sh").

Also delete the redundant files (ipcbuf.h, kvm_para.h, and poll.h)
which are already in Kbuild.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/alpha/include/uapi/asm/auxvec.h      |    6 +++---
 arch/alpha/include/uapi/asm/bitsperlong.h |    6 +++---
 arch/alpha/include/uapi/asm/byteorder.h   |    6 +++---
 arch/alpha/include/uapi/asm/errno.h       |    6 +++---
 arch/alpha/include/uapi/asm/fcntl.h       |    6 +++---
 arch/alpha/include/uapi/asm/gentrap.h     |    6 +++---
 arch/alpha/include/uapi/asm/ioctl.h       |    6 +++---
 arch/alpha/include/uapi/asm/ioctls.h      |    6 +++---
 arch/alpha/include/uapi/asm/ipcbuf.h      |    1 -
 arch/alpha/include/uapi/asm/kvm_para.h    |    1 -
 arch/alpha/include/uapi/asm/mman.h        |    6 +++---
 arch/alpha/include/uapi/asm/msgbuf.h      |    6 +++---
 arch/alpha/include/uapi/asm/poll.h        |    1 -
 arch/alpha/include/uapi/asm/posix_types.h |    6 +++---
 arch/alpha/include/uapi/asm/reg.h         |    6 +++---
 arch/alpha/include/uapi/asm/regdef.h      |    6 +++---
 arch/alpha/include/uapi/asm/resource.h    |    6 +++---
 arch/alpha/include/uapi/asm/sembuf.h      |    6 +++---
 arch/alpha/include/uapi/asm/setup.h       |    6 +++---
 arch/alpha/include/uapi/asm/shmbuf.h      |    6 +++---
 arch/alpha/include/uapi/asm/sigcontext.h  |    6 +++---
 arch/alpha/include/uapi/asm/siginfo.h     |    6 +++---
 arch/alpha/include/uapi/asm/sockios.h     |    6 +++---
 arch/alpha/include/uapi/asm/stat.h        |    6 +++---
 arch/alpha/include/uapi/asm/statfs.h      |    6 +++---
 arch/alpha/include/uapi/asm/swab.h        |    6 +++---
 arch/alpha/include/uapi/asm/sysinfo.h     |    6 +++---
 arch/alpha/include/uapi/asm/termbits.h    |    6 +++---
 28 files changed, 75 insertions(+), 78 deletions(-)
 delete mode 100644 arch/alpha/include/uapi/asm/ipcbuf.h
 delete mode 100644 arch/alpha/include/uapi/asm/kvm_para.h
 delete mode 100644 arch/alpha/include/uapi/asm/poll.h

diff --git a/arch/alpha/include/uapi/asm/auxvec.h b/arch/alpha/include/uapi/asm/auxvec.h
index a3a579d..d297271 100644
--- a/arch/alpha/include/uapi/asm/auxvec.h
+++ b/arch/alpha/include/uapi/asm/auxvec.h
@@ -1,5 +1,5 @@
-#ifndef __ASM_ALPHA_AUXVEC_H
-#define __ASM_ALPHA_AUXVEC_H
+#ifndef _UAPI__ASM_ALPHA_AUXVEC_H
+#define _UAPI__ASM_ALPHA_AUXVEC_H
 
 /* Reserve these numbers for any future use of a VDSO.  */
 #if 0
@@ -23,4 +23,4 @@
 
 #define AT_VECTOR_SIZE_ARCH 4 /* entries in ARCH_DLINFO */
 
-#endif /* __ASM_ALPHA_AUXVEC_H */
+#endif /* _UAPI__ASM_ALPHA_AUXVEC_H */
diff --git a/arch/alpha/include/uapi/asm/bitsperlong.h b/arch/alpha/include/uapi/asm/bitsperlong.h
index ad57f78..c3d1159 100644
--- a/arch/alpha/include/uapi/asm/bitsperlong.h
+++ b/arch/alpha/include/uapi/asm/bitsperlong.h
@@ -1,8 +1,8 @@
-#ifndef __ASM_ALPHA_BITSPERLONG_H
-#define __ASM_ALPHA_BITSPERLONG_H
+#ifndef _UAPI__ASM_ALPHA_BITSPERLONG_H
+#define _UAPI__ASM_ALPHA_BITSPERLONG_H
 
 #define __BITS_PER_LONG 64
 
 #include <asm-generic/bitsperlong.h>
 
-#endif /* __ASM_ALPHA_BITSPERLONG_H */
+#endif /* _UAPI__ASM_ALPHA_BITSPERLONG_H */
diff --git a/arch/alpha/include/uapi/asm/byteorder.h b/arch/alpha/include/uapi/asm/byteorder.h
index 7368309..331ca69 100644
--- a/arch/alpha/include/uapi/asm/byteorder.h
+++ b/arch/alpha/include/uapi/asm/byteorder.h
@@ -1,6 +1,6 @@
-#ifndef _ALPHA_BYTEORDER_H
-#define _ALPHA_BYTEORDER_H
+#ifndef _UAPI_ALPHA_BYTEORDER_H
+#define _UAPI_ALPHA_BYTEORDER_H
 
 #include <linux/byteorder/little_endian.h>
 
-#endif /* _ALPHA_BYTEORDER_H */
+#endif /* _UAPI_ALPHA_BYTEORDER_H */
diff --git a/arch/alpha/include/uapi/asm/errno.h b/arch/alpha/include/uapi/asm/errno.h
index 17f92aa..656023c 100644
--- a/arch/alpha/include/uapi/asm/errno.h
+++ b/arch/alpha/include/uapi/asm/errno.h
@@ -1,5 +1,5 @@
-#ifndef _ALPHA_ERRNO_H
-#define _ALPHA_ERRNO_H
+#ifndef _UAPI_ALPHA_ERRNO_H
+#define _UAPI_ALPHA_ERRNO_H
 
 #include <asm-generic/errno-base.h>
 
@@ -124,4 +124,4 @@
 
 #define EHWPOISON	139	/* Memory page has hardware error */
 
-#endif
+#endif /* _UAPI_ALPHA_ERRNO_H */
diff --git a/arch/alpha/include/uapi/asm/fcntl.h b/arch/alpha/include/uapi/asm/fcntl.h
index 09f49a6..46bd65a 100644
--- a/arch/alpha/include/uapi/asm/fcntl.h
+++ b/arch/alpha/include/uapi/asm/fcntl.h
@@ -1,5 +1,5 @@
-#ifndef _ALPHA_FCNTL_H
-#define _ALPHA_FCNTL_H
+#ifndef _UAPI_ALPHA_FCNTL_H
+#define _UAPI_ALPHA_FCNTL_H
 
 #define O_CREAT		 01000	/* not fcntl */
 #define O_TRUNC		 02000	/* not fcntl */
@@ -54,4 +54,4 @@
 
 #include <asm-generic/fcntl.h>
 
-#endif
+#endif /* _UAPI_ALPHA_FCNTL_H */
diff --git a/arch/alpha/include/uapi/asm/gentrap.h b/arch/alpha/include/uapi/asm/gentrap.h
index ae50cc3..8c40e37 100644
--- a/arch/alpha/include/uapi/asm/gentrap.h
+++ b/arch/alpha/include/uapi/asm/gentrap.h
@@ -1,5 +1,5 @@
-#ifndef _ASMAXP_GENTRAP_H
-#define _ASMAXP_GENTRAP_H
+#ifndef _UAPI_ASMAXP_GENTRAP_H
+#define _UAPI_ASMAXP_GENTRAP_H
 
 /*
  * Definitions for gentrap causes.  They are generated by user-level
@@ -34,4 +34,4 @@
 
 /* the remaining codes (-26..-1023) are reserved. */
 
-#endif /* _ASMAXP_GENTRAP_H */
+#endif /* _UAPI_ASMAXP_GENTRAP_H */
diff --git a/arch/alpha/include/uapi/asm/ioctl.h b/arch/alpha/include/uapi/asm/ioctl.h
index fc63727..e22781f 100644
--- a/arch/alpha/include/uapi/asm/ioctl.h
+++ b/arch/alpha/include/uapi/asm/ioctl.h
@@ -1,5 +1,5 @@
-#ifndef _ALPHA_IOCTL_H
-#define _ALPHA_IOCTL_H
+#ifndef _UAPI_ALPHA_IOCTL_H
+#define _UAPI_ALPHA_IOCTL_H
 
 /*
  * The original linux ioctl numbering scheme was just a general
@@ -63,4 +63,4 @@
 #define IOCSIZE_MASK	(_IOC_SIZEMASK << _IOC_SIZESHIFT)
 #define IOCSIZE_SHIFT	(_IOC_SIZESHIFT)
 
-#endif /* _ALPHA_IOCTL_H */
+#endif /* _UAPI_ALPHA_IOCTL_H */
diff --git a/arch/alpha/include/uapi/asm/ioctls.h b/arch/alpha/include/uapi/asm/ioctls.h
index 92c557b..4930bb2 100644
--- a/arch/alpha/include/uapi/asm/ioctls.h
+++ b/arch/alpha/include/uapi/asm/ioctls.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_ALPHA_IOCTLS_H
-#define _ASM_ALPHA_IOCTLS_H
+#ifndef _UAPI_ASM_ALPHA_IOCTLS_H
+#define _UAPI_ASM_ALPHA_IOCTLS_H
 
 #include <asm/ioctl.h>
 
@@ -114,4 +114,4 @@
 #define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
 #define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
 
-#endif /* _ASM_ALPHA_IOCTLS_H */
+#endif /* _UAPI_ASM_ALPHA_IOCTLS_H */
diff --git a/arch/alpha/include/uapi/asm/ipcbuf.h b/arch/alpha/include/uapi/asm/ipcbuf.h
deleted file mode 100644
index 84c7e51..0000000
--- a/arch/alpha/include/uapi/asm/ipcbuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipcbuf.h>
diff --git a/arch/alpha/include/uapi/asm/kvm_para.h b/arch/alpha/include/uapi/asm/kvm_para.h
deleted file mode 100644
index 14fab8f..0000000
--- a/arch/alpha/include/uapi/asm/kvm_para.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kvm_para.h>
diff --git a/arch/alpha/include/uapi/asm/mman.h b/arch/alpha/include/uapi/asm/mman.h
index 0086b47..141f440 100644
--- a/arch/alpha/include/uapi/asm/mman.h
+++ b/arch/alpha/include/uapi/asm/mman.h
@@ -1,5 +1,5 @@
-#ifndef __ALPHA_MMAN_H__
-#define __ALPHA_MMAN_H__
+#ifndef _UAPI__ALPHA_MMAN_H__
+#define _UAPI__ALPHA_MMAN_H__
 
 #define PROT_READ	0x1		/* page can be read */
 #define PROT_WRITE	0x2		/* page can be written */
@@ -74,4 +74,4 @@
 #define MAP_HUGE_SHIFT	26
 #define MAP_HUGE_MASK	0x3f
 
-#endif /* __ALPHA_MMAN_H__ */
+#endif /* _UAPI__ALPHA_MMAN_H__ */
diff --git a/arch/alpha/include/uapi/asm/msgbuf.h b/arch/alpha/include/uapi/asm/msgbuf.h
index 9849650..63811d7 100644
--- a/arch/alpha/include/uapi/asm/msgbuf.h
+++ b/arch/alpha/include/uapi/asm/msgbuf.h
@@ -1,5 +1,5 @@
-#ifndef _ALPHA_MSGBUF_H
-#define _ALPHA_MSGBUF_H
+#ifndef _UAPI_ALPHA_MSGBUF_H
+#define _UAPI_ALPHA_MSGBUF_H
 
 /* 
  * The msqid64_ds structure for alpha architecture.
@@ -24,4 +24,4 @@ struct msqid64_ds {
 	unsigned long  __unused2;
 };
 
-#endif /* _ALPHA_MSGBUF_H */
+#endif /* _UAPI_ALPHA_MSGBUF_H */
diff --git a/arch/alpha/include/uapi/asm/poll.h b/arch/alpha/include/uapi/asm/poll.h
deleted file mode 100644
index c98509d..0000000
--- a/arch/alpha/include/uapi/asm/poll.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/poll.h>
diff --git a/arch/alpha/include/uapi/asm/posix_types.h b/arch/alpha/include/uapi/asm/posix_types.h
index 5a8a483..d3d21e8 100644
--- a/arch/alpha/include/uapi/asm/posix_types.h
+++ b/arch/alpha/include/uapi/asm/posix_types.h
@@ -1,5 +1,5 @@
-#ifndef _ALPHA_POSIX_TYPES_H
-#define _ALPHA_POSIX_TYPES_H
+#ifndef _UAPI_ALPHA_POSIX_TYPES_H
+#define _UAPI_ALPHA_POSIX_TYPES_H
 
 /*
  * This file is generally used by user-level software, so you need to
@@ -14,4 +14,4 @@ typedef unsigned long	__kernel_sigset_t;	/* at least 32 bits */
 
 #include <asm-generic/posix_types.h>
 
-#endif /* _ALPHA_POSIX_TYPES_H */
+#endif /* _UAPI_ALPHA_POSIX_TYPES_H */
diff --git a/arch/alpha/include/uapi/asm/reg.h b/arch/alpha/include/uapi/asm/reg.h
index 86ff916..9fd7433 100644
--- a/arch/alpha/include/uapi/asm/reg.h
+++ b/arch/alpha/include/uapi/asm/reg.h
@@ -1,5 +1,5 @@
-#ifndef __reg_h__
-#define __reg_h__
+#ifndef _UAPI__reg_h__
+#define _UAPI__reg_h__
 
 /*
  * Exception frame offsets.
@@ -49,4 +49,4 @@
 #define CORE_REG(reg, ubase) \
 	(((unsigned long *)((unsigned long)(ubase)))[reg])
 
-#endif /* __reg_h__ */
+#endif /* _UAPI__reg_h__ */
diff --git a/arch/alpha/include/uapi/asm/regdef.h b/arch/alpha/include/uapi/asm/regdef.h
index 142df9c..268cb3e 100644
--- a/arch/alpha/include/uapi/asm/regdef.h
+++ b/arch/alpha/include/uapi/asm/regdef.h
@@ -1,5 +1,5 @@
-#ifndef __alpha_regdef_h__
-#define __alpha_regdef_h__
+#ifndef _UAPI__alpha_regdef_h__
+#define _UAPI__alpha_regdef_h__
 
 #define v0	$0	/* function return value */
 
@@ -41,4 +41,4 @@
 #define sp	$30	/* stack pointer */
 #define zero	$31	/* reads as zero, writes are noops */
 
-#endif /* __alpha_regdef_h__ */
+#endif /* _UAPI__alpha_regdef_h__ */
diff --git a/arch/alpha/include/uapi/asm/resource.h b/arch/alpha/include/uapi/asm/resource.h
index c10874f..5f7c549 100644
--- a/arch/alpha/include/uapi/asm/resource.h
+++ b/arch/alpha/include/uapi/asm/resource.h
@@ -1,5 +1,5 @@
-#ifndef _ALPHA_RESOURCE_H
-#define _ALPHA_RESOURCE_H
+#ifndef _UAPI_ALPHA_RESOURCE_H
+#define _UAPI_ALPHA_RESOURCE_H
 
 /*
  * Alpha/Linux-specific ordering of these four resource limit IDs,
@@ -19,4 +19,4 @@
 
 #include <asm-generic/resource.h>
 
-#endif /* _ALPHA_RESOURCE_H */
+#endif /* _UAPI_ALPHA_RESOURCE_H */
diff --git a/arch/alpha/include/uapi/asm/sembuf.h b/arch/alpha/include/uapi/asm/sembuf.h
index 7b38b15..e227b21 100644
--- a/arch/alpha/include/uapi/asm/sembuf.h
+++ b/arch/alpha/include/uapi/asm/sembuf.h
@@ -1,5 +1,5 @@
-#ifndef _ALPHA_SEMBUF_H
-#define _ALPHA_SEMBUF_H
+#ifndef _UAPI_ALPHA_SEMBUF_H
+#define _UAPI_ALPHA_SEMBUF_H
 
 /* 
  * The semid64_ds structure for alpha architecture.
@@ -19,4 +19,4 @@ struct semid64_ds {
 	unsigned long	__unused2;
 };
 
-#endif /* _ALPHA_SEMBUF_H */
+#endif /* _UAPI_ALPHA_SEMBUF_H */
diff --git a/arch/alpha/include/uapi/asm/setup.h b/arch/alpha/include/uapi/asm/setup.h
index b50014b..8f26aa4 100644
--- a/arch/alpha/include/uapi/asm/setup.h
+++ b/arch/alpha/include/uapi/asm/setup.h
@@ -1,5 +1,5 @@
-#ifndef __ALPHA_SETUP_H
-#define __ALPHA_SETUP_H
+#ifndef _UAPI__ALPHA_SETUP_H
+#define _UAPI__ALPHA_SETUP_H
 
 #define COMMAND_LINE_SIZE	256
 
@@ -39,4 +39,4 @@
 #define INITRD_START		(*(unsigned long *) (PARAM+0x100))
 #define INITRD_SIZE		(*(unsigned long *) (PARAM+0x108))
 
-#endif
+#endif /* _UAPI__ALPHA_SETUP_H */
diff --git a/arch/alpha/include/uapi/asm/shmbuf.h b/arch/alpha/include/uapi/asm/shmbuf.h
index 37ee84f..d752749 100644
--- a/arch/alpha/include/uapi/asm/shmbuf.h
+++ b/arch/alpha/include/uapi/asm/shmbuf.h
@@ -1,5 +1,5 @@
-#ifndef _ALPHA_SHMBUF_H
-#define _ALPHA_SHMBUF_H
+#ifndef _UAPI_ALPHA_SHMBUF_H
+#define _UAPI_ALPHA_SHMBUF_H
 
 /* 
  * The shmid64_ds structure for alpha architecture.
@@ -35,4 +35,4 @@ struct shminfo64 {
 	unsigned long	__unused4;
 };
 
-#endif /* _ALPHA_SHMBUF_H */
+#endif /* _UAPI_ALPHA_SHMBUF_H */
diff --git a/arch/alpha/include/uapi/asm/sigcontext.h b/arch/alpha/include/uapi/asm/sigcontext.h
index 323cdb0..5294d5a 100644
--- a/arch/alpha/include/uapi/asm/sigcontext.h
+++ b/arch/alpha/include/uapi/asm/sigcontext.h
@@ -1,5 +1,5 @@
-#ifndef _ASMAXP_SIGCONTEXT_H
-#define _ASMAXP_SIGCONTEXT_H
+#ifndef _UAPI_ASMAXP_SIGCONTEXT_H
+#define _UAPI_ASMAXP_SIGCONTEXT_H
 
 struct sigcontext {
 	/*
@@ -31,4 +31,4 @@ struct sigcontext {
 };
 
 
-#endif
+#endif /* _UAPI_ASMAXP_SIGCONTEXT_H */
diff --git a/arch/alpha/include/uapi/asm/siginfo.h b/arch/alpha/include/uapi/asm/siginfo.h
index 9822362..d8fb147 100644
--- a/arch/alpha/include/uapi/asm/siginfo.h
+++ b/arch/alpha/include/uapi/asm/siginfo.h
@@ -1,9 +1,9 @@
-#ifndef _ALPHA_SIGINFO_H
-#define _ALPHA_SIGINFO_H
+#ifndef _UAPI_ALPHA_SIGINFO_H
+#define _UAPI_ALPHA_SIGINFO_H
 
 #define __ARCH_SI_PREAMBLE_SIZE		(4 * sizeof(int))
 #define __ARCH_SI_TRAPNO
 
 #include <asm-generic/siginfo.h>
 
-#endif
+#endif /* _UAPI_ALPHA_SIGINFO_H */
diff --git a/arch/alpha/include/uapi/asm/sockios.h b/arch/alpha/include/uapi/asm/sockios.h
index 7932c7a..6a1adac 100644
--- a/arch/alpha/include/uapi/asm/sockios.h
+++ b/arch/alpha/include/uapi/asm/sockios.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_ALPHA_SOCKIOS_H
-#define _ASM_ALPHA_SOCKIOS_H
+#ifndef _UAPI_ASM_ALPHA_SOCKIOS_H
+#define _UAPI_ASM_ALPHA_SOCKIOS_H
 
 /* Socket-level I/O control calls. */
 
@@ -13,4 +13,4 @@
 #define SIOCGSTAMP	0x8906		/* Get stamp (timeval) */
 #define SIOCGSTAMPNS	0x8907		/* Get stamp (timespec) */
 
-#endif /* _ASM_ALPHA_SOCKIOS_H */
+#endif /* _UAPI_ASM_ALPHA_SOCKIOS_H */
diff --git a/arch/alpha/include/uapi/asm/stat.h b/arch/alpha/include/uapi/asm/stat.h
index 07ad3e6..485ebc6 100644
--- a/arch/alpha/include/uapi/asm/stat.h
+++ b/arch/alpha/include/uapi/asm/stat.h
@@ -1,5 +1,5 @@
-#ifndef _ALPHA_STAT_H
-#define _ALPHA_STAT_H
+#ifndef _UAPI_ALPHA_STAT_H
+#define _UAPI_ALPHA_STAT_H
 
 struct stat {
 	unsigned int	st_dev;
@@ -45,4 +45,4 @@ struct stat64 {
   	long		__unused[3];
 };
 
-#endif
+#endif /* _UAPI_ALPHA_STAT_H */
diff --git a/arch/alpha/include/uapi/asm/statfs.h b/arch/alpha/include/uapi/asm/statfs.h
index ccd2e18..4b9ae7b 100644
--- a/arch/alpha/include/uapi/asm/statfs.h
+++ b/arch/alpha/include/uapi/asm/statfs.h
@@ -1,5 +1,5 @@
-#ifndef _ALPHA_STATFS_H
-#define _ALPHA_STATFS_H
+#ifndef _UAPI_ALPHA_STATFS_H
+#define _UAPI_ALPHA_STATFS_H
 
 #include <linux/types.h>
 
@@ -9,4 +9,4 @@
 
 #include <asm-generic/statfs.h>
 
-#endif
+#endif /* _UAPI_ALPHA_STATFS_H */
diff --git a/arch/alpha/include/uapi/asm/swab.h b/arch/alpha/include/uapi/asm/swab.h
index 4d682b1..db18d10 100644
--- a/arch/alpha/include/uapi/asm/swab.h
+++ b/arch/alpha/include/uapi/asm/swab.h
@@ -1,5 +1,5 @@
-#ifndef _ALPHA_SWAB_H
-#define _ALPHA_SWAB_H
+#ifndef _UAPI_ALPHA_SWAB_H
+#define _UAPI_ALPHA_SWAB_H
 
 #include <linux/types.h>
 #include <linux/compiler.h>
@@ -39,4 +39,4 @@ static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 
 #endif /* __GNUC__ */
 
-#endif /* _ALPHA_SWAB_H */
+#endif /* _UAPI_ALPHA_SWAB_H */
diff --git a/arch/alpha/include/uapi/asm/sysinfo.h b/arch/alpha/include/uapi/asm/sysinfo.h
index 0b80e79..0466499 100644
--- a/arch/alpha/include/uapi/asm/sysinfo.h
+++ b/arch/alpha/include/uapi/asm/sysinfo.h
@@ -2,8 +2,8 @@
  * include/asm-alpha/sysinfo.h
  */
 
-#ifndef __ASM_ALPHA_SYSINFO_H
-#define __ASM_ALPHA_SYSINFO_H
+#ifndef _UAPI__ASM_ALPHA_SYSINFO_H
+#define _UAPI__ASM_ALPHA_SYSINFO_H
 
 /* This defines the subset of the OSF/1 getsysinfo/setsysinfo calls
    that we support.  */
@@ -28,4 +28,4 @@
 #define UAC_NOFIX			2
 #define UAC_SIGBUS			4
 
-#endif /* __ASM_ALPHA_SYSINFO_H */
+#endif /* _UAPI__ASM_ALPHA_SYSINFO_H */
diff --git a/arch/alpha/include/uapi/asm/termbits.h b/arch/alpha/include/uapi/asm/termbits.h
index 879dd35..c6e92ef 100644
--- a/arch/alpha/include/uapi/asm/termbits.h
+++ b/arch/alpha/include/uapi/asm/termbits.h
@@ -1,5 +1,5 @@
-#ifndef _ALPHA_TERMBITS_H
-#define _ALPHA_TERMBITS_H
+#ifndef _UAPI_ALPHA_TERMBITS_H
+#define _UAPI_ALPHA_TERMBITS_H
 
 #include <linux/posix_types.h>
 
@@ -198,4 +198,4 @@ struct ktermios {
 #define	TCSADRAIN	1
 #define	TCSAFLUSH	2
 
-#endif /* _ALPHA_TERMBITS_H */
+#endif /* _UAPI_ALPHA_TERMBITS_H */
-- 
1.7.7.6
