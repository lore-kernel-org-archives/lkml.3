Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750905Ab3EIEAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 00:00:55 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:58290 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab3EIEAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 00:00:54 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: make stat/statfs 64-bit for x86_64 kernels
Date: Thu,  9 May 2013 00:00:57 -0400
Message-Id: <1368072057-7832-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When including these headers in the x32 ABI, the structs get declared
with 32bit sizes which is incorrect.  Use long long and such to make
it work both with x32 and x86_64.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/x86/include/uapi/asm/stat.h   | 38 +++++++++++++++++++-------------------
 arch/x86/include/uapi/asm/statfs.h |  5 +++++
 2 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/uapi/asm/stat.h b/arch/x86/include/uapi/asm/stat.h
index 7b3ddc3..e9d6951 100644
--- a/arch/x86/include/uapi/asm/stat.h
+++ b/arch/x86/include/uapi/asm/stat.h
@@ -78,26 +78,26 @@ struct stat64 {
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
+	unsigned long long	st_dev;
+	unsigned long long	st_ino;
+	unsigned long long	st_nlink;
 
-	unsigned long	st_atime;
-	unsigned long	st_atime_nsec;
-	unsigned long	st_mtime;
-	unsigned long	st_mtime_nsec;
-	unsigned long	st_ctime;
-	unsigned long   st_ctime_nsec;
-	long		__unused[3];
+	unsigned int		st_mode;
+	unsigned int		st_uid;
+	unsigned int		st_gid;
+	unsigned int		__pad0;
+	unsigned long long	st_rdev;
+	long long		st_size;
+	long long		st_blksize;
+	long long		st_blocks;	/* Number 512-byte blocks allocated. */
+
+	unsigned long long	st_atime;
+	unsigned long long	st_atime_nsec;
+	unsigned long long	st_mtime;
+	unsigned long long	st_mtime_nsec;
+	unsigned long long	st_ctime;
+	unsigned long long	st_ctime_nsec;
+	long long		__unused[3];
 };
 
 /* We don't need to memset the whole thing just to initialize the padding */
diff --git a/arch/x86/include/uapi/asm/statfs.h b/arch/x86/include/uapi/asm/statfs.h
index 2d0adbf..3cb5744 100644
--- a/arch/x86/include/uapi/asm/statfs.h
+++ b/arch/x86/include/uapi/asm/statfs.h
@@ -8,5 +8,10 @@
  */
 #define ARCH_PACK_COMPAT_STATFS64 __attribute__((packed,aligned(4)))
 
+/* For x86-64, both the 64bit and x32 ABIs have 64bit fields. */
+#ifdef __x86_64__
+#define __statfs_word __u64
+#endif
+
 #include <asm-generic/statfs.h>
 #endif /* _ASM_X86_STATFS_H */
-- 
1.8.2.1

