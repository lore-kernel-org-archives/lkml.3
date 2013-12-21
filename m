Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab3LUAJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 19:09:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49396 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab3LUAJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 19:09:37 -0500
Date: Fri, 20 Dec 2013 16:09:26 -0800
From: "tip-bot for H.J. Lu" <tipbot@zytor.com>
Message-ID: <tip-b70fedc15892de8bc78f711d7821dd0916cc5508@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, hjl.tools@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, hjl.tools@gmail.com
In-Reply-To: <CAMe9rOquPtWEro0GQ=Z95pZJ=c7GGkSHynjN4FbiB4p445x-Ng@mail.gmail.com>
References: <CAMe9rOquPtWEro0GQ=Z95pZJ=c7GGkSHynjN4FbiB4p445x-Ng@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/x32] x86, x32: Use __kernel_long_t/
 __kernel_ulong_t in x86-64 stat.h
Git-Commit-ID: b70fedc15892de8bc78f711d7821dd0916cc5508
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 20 Dec 2013 16:09:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b70fedc15892de8bc78f711d7821dd0916cc5508
Gitweb:     http://git.kernel.org/tip/b70fedc15892de8bc78f711d7821dd0916cc5508
Author:     H.J. Lu <hjl.tools@gmail.com>
AuthorDate: Mon, 16 Dec 2013 16:09:51 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 20 Dec 2013 16:04:35 -0800

x86, x32: Use __kernel_long_t/__kernel_ulong_t in x86-64 stat.h

Both x32 and x86-64 use the same stat system call interface.  But x32
long is 32-bit.  This patch changes x86 uapi <asm/stat.h> to use
 __kernel_long_t/__kernel_ulong_t in x86-64 stat.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
Link: http://lkml.kernel.org/r/CAMe9rOquPtWEro0GQ=Z95pZJ=c7GGkSHynjN4FbiB4p445x-Ng@mail.gmail.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/uapi/asm/stat.h | 42 +++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/uapi/asm/stat.h b/arch/x86/include/uapi/asm/stat.h
index 7b3ddc3..bc03eb5 100644
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
