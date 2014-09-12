Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbaILGuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 02:50:07 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:55751 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbaILGuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 02:50:03 -0400
From: gxt@mprc.pku.edu.cn
To: linux-kernel@vger.kernel.org
Cc: gxt@pku.edu.cn, linux@roeck-us.net, gang.chen.5i5j@gmail.com,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Qin Rui <qinrui@pku.edu.cn>
Subject: [PATCH 2/4] unicore32-oldabi: add stat.h support for UNICORE32_OLDABI
Date: Fri, 12 Sep 2014 14:41:44 +0800
Message-Id: <a9da8d056d46c33d2bde17f4d38b0f106a3b2d69.1410502415.git.gxt@mprc.pku.edu.cn>
X-Mailer: git-send-email 2.0.0.GIT
In-Reply-To: <1b5cc90293670926b5a1e5a06995e527442f8bde.1410502415.git.gxt@mprc.pku.edu.cn>
References: <1b5cc90293670926b5a1e5a06995e527442f8bde.1410502415.git.gxt@mprc.pku.edu.cn>
In-Reply-To: <1b5cc90293670926b5a1e5a06995e527442f8bde.1410502415.git.gxt@mprc.pku.edu.cn>
References: <1b5cc90293670926b5a1e5a06995e527442f8bde.1410502415.git.gxt@mprc.pku.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <gxt@mprc.pku.edu.cn>

Remove generated code in arch/unicore32/include/asm/Kbuild, and
restore asm/stat.h for UNICORE32_OLDABI.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Qin Rui <qinrui@pku.edu.cn>
---
 arch/unicore32/include/asm/Kbuild             |  1 -
 arch/unicore32/include/uapi/asm/stat-oldabi.h | 71 +++++++++++++++++++++++++++
 arch/unicore32/include/uapi/asm/stat.h        | 19 +++++++
 3 files changed, 90 insertions(+), 1 deletion(-)
 create mode 100644 arch/unicore32/include/uapi/asm/stat-oldabi.h
 create mode 100644 arch/unicore32/include/uapi/asm/stat.h

diff --git a/arch/unicore32/include/asm/Kbuild b/arch/unicore32/include/asm/Kbuild
index 1e5fb87..78cf393 100644
--- a/arch/unicore32/include/asm/Kbuild
+++ b/arch/unicore32/include/asm/Kbuild
@@ -49,7 +49,6 @@ generic-y += signal.h
 generic-y += sizes.h
 generic-y += socket.h
 generic-y += sockios.h
-generic-y += stat.h
 generic-y += statfs.h
 generic-y += swab.h
 generic-y += syscalls.h
diff --git a/arch/unicore32/include/uapi/asm/stat-oldabi.h b/arch/unicore32/include/uapi/asm/stat-oldabi.h
new file mode 100644
index 0000000..d36ce13
--- /dev/null
+++ b/arch/unicore32/include/uapi/asm/stat-oldabi.h
@@ -0,0 +1,71 @@
+/*
+ * Code specific to UniCore32 ISA
+ *
+ * Copyright (C) 2014 GUAN Xuetao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE32_ASM_STAT_OLDABI_H__
+#define __UNICORE32_ASM_STAT_OLDABI_H__
+
+#define STAT_HAVE_NSEC 1
+
+struct stat {
+	unsigned long	st_dev;		/* Device.  */
+	unsigned long	st_ino;		/* File serial number.  */
+	unsigned int	st_mode;	/* File mode.  */
+	unsigned int	st_nlink;	/* Link count.  */
+	unsigned int	st_uid;		/* User ID of the file's owner.  */
+	unsigned int	st_gid;		/* Group ID of the file's group. */
+	unsigned long	st_rdev;	/* Device number, if device.  */
+	unsigned long	__pad1;
+	long		st_size;	/* Size of file, in bytes.  */
+	int		st_blksize;	/* Optimal block size for I/O.  */
+	int		__pad2;
+	long		st_blocks;	/* Number 512-byte blocks allocated. */
+	int		st_atime;	/* Time of last access.  */
+	unsigned int	st_atime_nsec;
+	int		st_mtime;	/* Time of last modification.  */
+	unsigned int	st_mtime_nsec;
+	int		st_ctime;	/* Time of last status change.  */
+	unsigned int	st_ctime_nsec;
+	unsigned int	__unused4;
+	unsigned int	__unused5;
+};
+
+/*
+ * This matches struct stat64 in glibc2.1, hence the absolutely
+ * insane amounts of padding around dev_t's.
+ * Note: The kernel zero's the padded region because glibc might read them
+ * in the hope that the kernel has stretched to using larger sizes.
+ */
+#define STAT64_HAS_BROKEN_ST_INO
+
+struct stat64 {
+	unsigned long long	st_dev;		/* Device.  */
+	unsigned char		__pad0[4];
+	unsigned long		__st_ino;
+	unsigned int		st_mode;	/* File mode.  */
+	unsigned int		st_nlink;	/* Link count.  */
+	unsigned int		st_uid;		/* UID of the file's owner.  */
+	unsigned int		st_gid;		/* GID of the file's group. */
+	unsigned long long	st_rdev;	/* Device number, if device. */
+
+	unsigned char   __pad3[4];
+
+	long long	st_size;	/* Size of file, in bytes.  */
+	int		st_blksize;	/* Optimal block size for I/O.  */
+	long long	st_blocks;	/* Number 512-byte blocks allocated. */
+	int		st_atime;	/* Time of last access.  */
+	unsigned int	st_atime_nsec;
+	int		st_mtime;	/* Time of last modification.  */
+	unsigned int	st_mtime_nsec;
+	int		st_ctime;	/* Time of last status change.  */
+	unsigned int	st_ctime_nsec;
+
+	unsigned long long	st_ino;
+};
+
+#endif /* __UNICORE32_ASM_STAT_OLDABI_H__ */
diff --git a/arch/unicore32/include/uapi/asm/stat.h b/arch/unicore32/include/uapi/asm/stat.h
new file mode 100644
index 0000000..2cff377d
--- /dev/null
+++ b/arch/unicore32/include/uapi/asm/stat.h
@@ -0,0 +1,19 @@
+/*
+ * Code specific to UniCore32 ISA
+ *
+ * Copyright (C) 2014 GUAN Xuetao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE32_ASM_STAT_H__
+#define __UNICORE32_ASM_STAT_H__
+
+#ifndef CONFIG_UNICORE32_OLDABI
+#include <asm-generic/stat.h>
+#else
+#include <asm/stat-oldabi.h>
+#endif /* CONFIG_UNICORE32_OLDABI */
+
+#endif /* __UNICORE32_ASM_STAT_H__ */
-- 
2.0.0.GIT

