Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966999AbaFTUX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:23:56 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:40429 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966819AbaFTUXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:23:55 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsHACWYpFNXQzOZ/2dsb2JhbABZgw2rRwUBAQEBAQEFAZkqgQ4XdYQxLyOBGjeILgMVAcNkFYZDF4ViiEMBAU8dhC0Ej22KV4swiCqDRDuBOg
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Evgeniy Dushistov <dushistov@mail.ru>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/5] FS/UFS: use pr_fmt
Date: Fri, 20 Jun 2014 22:22:18 +0200
Message-Id: <1403295738-4844-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace UFS-fs, UFS-fs: and UFS: by pr_fmt with module name "ufs: "

Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ufs/super.c | 15 +++++++--------
 fs/ufs/ufs.h   |  6 ++++++
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 9778b9f..cfa878e 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -65,7 +65,6 @@
  * Evgeniy Dushistov <dushistov@mail.ru>, 2007
  */
 
-
 #include <linux/exportfs.h>
 #include <linux/module.h>
 #include <linux/bitops.h>
@@ -310,13 +309,13 @@ void ufs_error (struct super_block * sb, const char * function,
 	va_end (args);
 	switch (UFS_SB(sb)->s_mount_opt & UFS_MOUNT_ONERROR) {
 	case UFS_MOUNT_ONERROR_PANIC:
-		panic ("UFS-fs panic (device %s): %s: %s\n", 
+		panic("panic (device %s): %s: %s\n",
 			sb->s_id, function, error_buf);
 
 	case UFS_MOUNT_ONERROR_LOCK:
 	case UFS_MOUNT_ONERROR_UMOUNT:
 	case UFS_MOUNT_ONERROR_REPAIR:
-		pr_crit("UFS-fs error (device %s): %s: %s\n",
+		pr_crit("error (device %s): %s: %s\n",
 			sb->s_id, function, error_buf);
 	}		
 }
@@ -340,7 +339,7 @@ void ufs_panic (struct super_block * sb, const char * function,
 	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
 	va_end (args);
 	sb->s_flags |= MS_RDONLY;
-	pr_crit("UFS-fs panic (device %s): %s: %s\n",
+	pr_crit("panic (device %s): %s: %s\n",
 		sb->s_id, function, error_buf);
 }
 
@@ -352,7 +351,7 @@ void ufs_warning (struct super_block * sb, const char * function,
 	va_start (args, fmt);
 	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
 	va_end (args);
-	pr_warn("UFS-fs warning (device %s): %s: %s\n",
+	pr_warn("warning (device %s): %s: %s\n",
 		sb->s_id, function, error_buf);
 }
 
@@ -464,12 +463,12 @@ static int ufs_parse_options (char * options, unsigned * mount_options)
 			ufs_set_opt (*mount_options, ONERROR_UMOUNT);
 			break;
 		case Opt_onerror_repair:
-			pr_err("UFS-fs: Unable to do repair on error, will lock lock instead\n");
+			pr_err("Unable to do repair on error, will lock lock instead\n");
 			ufs_clear_opt (*mount_options, ONERROR);
 			ufs_set_opt (*mount_options, ONERROR_REPAIR);
 			break;
 		default:
-			pr_err("UFS-fs: Invalid option: \"%s\" or missing value\n", p);
+			pr_err("Invalid option: \"%s\" or missing value\n", p);
 			return 0;
 		}
 	}
@@ -972,7 +971,7 @@ static int ufs_fill_super(struct super_block *sb, void *data, int silent)
 	
 again:	
 	if (!sb_set_blocksize(sb, block_size)) {
-		pr_err("UFS: failed to set blocksize\n");
+		pr_err("failed to set blocksize\n");
 		goto failed;
 	}
 
diff --git a/fs/ufs/ufs.h b/fs/ufs/ufs.h
index 343e6fc..cbe1e9b 100644
--- a/fs/ufs/ufs.h
+++ b/fs/ufs/ufs.h
@@ -1,6 +1,12 @@
 #ifndef _UFS_UFS_H
 #define _UFS_UFS_H 1
 
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define UFS_MAX_GROUP_LOADED 8
 #define UFS_CGNO_EMPTY ((unsigned)-1)
 
-- 
1.8.4.5

