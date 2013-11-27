Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab3K0Kl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 05:41:26 -0500
Received: from hall.aurel32.net ([195.154.112.97]:54803 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab3K0KlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 05:41:23 -0500
From: Aurelien Jarno <aurelien@aurel32.net>
To: linux-kernel@vger.kernel.org
Cc: Aurelien Jarno <aurelien@aurel32.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] UAPI linux/fs.h: add a warning about wrong ioctl argument types
Date: Wed, 27 Nov 2013 11:40:39 +0100
Message-Id: <1385548839-16617-1-git-send-email-aurelien@aurel32.net>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FS_IOC_GETFLAGS, FS_IOC_SETFLAGS, FS_IOC_GETVERSION and
FS_IOC_SETVERSION ioctls are declared for historical reasons with a long
argument, while in practice they take an int argument. This is
unfortunately not possible to fix that without breaking the kernel ABI.

However good programmers actually lookup for the argument type of these
ioctls in <fs/linux.h> and end-up using a long. This breaks on 64-bit
big endian machines.

Instead of letting the same "mistake" to be done again and again, add an
explanation to <fs/linux.h> so that people use the correct argument type
in their code. Also add a small comment on the same line while staying
within 80 characters so that the issue appears when doing a grep on this
file.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
---
 include/uapi/linux/fs.h | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 6c28b61..baeb803 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -154,10 +154,16 @@ struct inodes_stat_t {
 #define FITHAW		_IOWR('X', 120, int)	/* Thaw */
 #define FITRIM		_IOWR('X', 121, struct fstrim_range)	/* Trim */
 
-#define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
-#define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
-#define	FS_IOC_GETVERSION		_IOR('v', 1, long)
-#define	FS_IOC_SETVERSION		_IOW('v', 2, long)
+/*
+ * WARNING: The next four following ioctls actually take an int argument
+ * despite their definition. This is important to support 64-bit big-endian
+ * machines.
+ */
+#define	FS_IOC_GETFLAGS			_IOR('f', 1, long) /* should be int */
+#define	FS_IOC_SETFLAGS			_IOW('f', 2, long) /* should be int */
+#define	FS_IOC_GETVERSION		_IOR('v', 1, long) /* should be int */
+#define	FS_IOC_SETVERSION		_IOW('v', 2, long) /* should be int */
+
 #define FS_IOC_FIEMAP			_IOWR('f', 11, struct fiemap)
 #define FS_IOC32_GETFLAGS		_IOR('f', 1, int)
 #define FS_IOC32_SETFLAGS		_IOW('f', 2, int)
-- 
1.8.4.2

