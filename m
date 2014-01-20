Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbaATQtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 11:49:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48288 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbaATQtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 11:49:09 -0500
Date: Mon, 20 Jan 2014 08:48:43 -0800
Message-Id: <201401201648.s0KGmhJP004248@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/x32 for v3.14
Cc: Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the first few of a set of patches by H.J. Lu to make the
kernel uapi headers usable for x32, as required by some non-glibc
libcs.  These particular patches make the stat and statfs structures
usable.

The following changes since commit 319e2e3f63c348a9b66db4667efa73178e18b17d:

  Linux 3.13-rc4 (2013-12-15 12:31:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-x32-for-linus

The head of this tree is 79dbbc60493f357912d5f1da5a23147ba0c01c7a.

  x86, x32: Use __kernel_long_t for __statfs_word (2013-12-20 16:06:21 -0800)

----------------------------------------------------------------

H.J. Lu (2):
      x86, x32: Use __kernel_long_t/__kernel_ulong_t in x86-64 stat.h
      x86, x32: Use __kernel_long_t for __statfs_word

 arch/x86/include/uapi/asm/stat.h  | 42 ++++++++++++++++++++-------------------
 include/uapi/asm-generic/statfs.h |  2 +-
 2 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/uapi/asm/stat.h b/arch/x86/include/uapi/asm/stat.h
index 7b3ddc348585..bc03eb5d6360 100644
--- a/arch/x86/include/uapi/asm/stat.h
+++ b/arch/x86/include/uapi/asm/stat.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_STAT_H
 #define _ASM_X86_STAT_H
 
+#include <asm/posix_types.h>
+
 #define STAT_HAVE_NSEC 1
 
 #ifdef __i386__
@@ -78,26 +80,26 @@ struct stat64 {
 #else /* __i386__ */
 
 struct stat {
-	unsigned long	st_dev;
-	unsigned long	st_ino;
-	unsigned long	st_nlink;
-
-	unsigned int	st_mode;
-	unsigned int	st_uid;
-	unsigned int	st_gid;
-	unsigned int	__pad0;
-	unsigned long	st_rdev;
-	long		st_size;
-	long		st_blksize;
-	long		st_blocks;	/* Number 512-byte blocks allocated. */
-
-	unsigned long	st_atime;
-	unsigned long	st_atime_nsec;
-	unsigned long	st_mtime;
-	unsigned long	st_mtime_nsec;
-	unsigned long	st_ctime;
-	unsigned long   st_ctime_nsec;
-	long		__unused[3];
+	__kernel_ulong_t	st_dev;
+	__kernel_ulong_t	st_ino;
+	__kernel_ulong_t	st_nlink;
+
+	unsigned int		st_mode;
+	unsigned int		st_uid;
+	unsigned int		st_gid;
+	unsigned int		__pad0;
+	__kernel_ulong_t	st_rdev;
+	__kernel_long_t		st_size;
+	__kernel_long_t		st_blksize;
+	__kernel_long_t		st_blocks;	/* Number 512-byte blocks allocated. */
+
+	__kernel_ulong_t	st_atime;
+	__kernel_ulong_t	st_atime_nsec;
+	__kernel_ulong_t	st_mtime;
+	__kernel_ulong_t	st_mtime_nsec;
+	__kernel_ulong_t	st_ctime;
+	__kernel_ulong_t	st_ctime_nsec;
+	__kernel_long_t		__unused[3];
 };
 
 /* We don't need to memset the whole thing just to initialize the padding */
diff --git a/include/uapi/asm-generic/statfs.h b/include/uapi/asm-generic/statfs.h
index 0999647fca13..cb89cc730f0b 100644
--- a/include/uapi/asm-generic/statfs.h
+++ b/include/uapi/asm-generic/statfs.h
@@ -13,7 +13,7 @@
  */
 #ifndef __statfs_word
 #if __BITS_PER_LONG == 64
-#define __statfs_word long
+#define __statfs_word __kernel_long_t
 #else
 #define __statfs_word __u32
 #endif
