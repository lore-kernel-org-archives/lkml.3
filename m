Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab3FGF5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 01:57:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:19696 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab3FGF5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 01:57:22 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-00-51b1763fbdd5
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/2] f2fs: support xattr security labels
Date: Fri, 07 Jun 2013 14:55:57 +0900
Message-id: <1370584557-20592-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1370584557-20592-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1370584557-20592-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t8zfV37so2BBq83W1tc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlTHnME/BfKOKYyfb
	WRoYp2l2MXJySAiYSOw4tYMNwhaTuHBvPZDNxSEksIxRYu2a46wwRdvbOxghEtMZJf68XcsC
	khASaGOS2P2jsouRg4NNQFti834DkLCIALPEgqnnweqZBSYwSvxf9B6sXljAQmLGzTuMIPUs
	AqoS++/Eg4R5BdwlHn9czgixS1di9f/n7CA2p4CHxNcJr9kgVrlLHLjZxQIyU0LgO5vEnJYW
	ZpAEi4CAxLfJh1hAZkoIyEpsOsAMMUdS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLUK07MLS7N
	S9dLzs/dxAgJ194djLcPWB9iTAYaN5FZSjQ5HxjueSXxhsZmRhamJqbGRuaWZqQJK4nzqrVY
	BwoJpCeWpGanphakFsUXleakFh9iZOLglGpgjLiXt+/QxuAPTUbLDM++vWXItvDn5Pqr02qq
	frvcjJ4Ut0roqZV5iewNjqypHf0Z8md23DvE7/pl474Jiic2JvwyfbN4otbxqC6rR+aHJ1Vf
	5UpXMl0XW8b90e5v4qXpD/dwCtUEWxsfvy7r+qBotcjPSd4FC0wd9/mKMilsusfu8SzX/vLh
	B0osxRmJhlrMRcWJAHOPJbhtAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jQV37so2BBo/fmVlc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5gx5zBPwXyjimMn21kaGKdpdjFyckgImEhsb+9ghLDFJC7cW8/WxcjFISQw
	nVHiz9u1LCAJIYE2JondPyq7GDk42AS0JTbvNwAJiwgwSyyYep4RpJ5ZYAKjxP9F78HqhQUs
	JGbcvMMIUs8ioCqx/048SJhXwF3i8cflULt0JVb/f84OYnMKeEh8nfCaDWKVu8SBm10sExh5
	FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjoZnUjsYVzZYHGIU4GBU4uH9uWpDoBBr
	YllxZe4hRgkOZiUR3vVpGwOFeFMSK6tSi/Lji0pzUosPMSYDHTWRWUo0OR8YqXkl8YbGJmZG
	lkZmFkYm5uakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnVwGjPqlqzpGNVj1DRCja/yx3C
	W8+rVAkVuFl1PYvxnci+OO3Tn8vhu9JvbfN6ZNf4/nvEtsXnZimxv2LqS5qlfGB2VvnkRVmb
	GL9aBJ6xPLMssf2YlvTBkyJpfPMem7o/8w4/LG7+K1tzfY6alMu5jCPfjjlkPV7obO9x6bwa
	owTzq/Ae1akztZVYijMSDbWYi4oTARN6Yg3KAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the support of security labels for f2fs, which will be used
by SElinux.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/Kconfig |  9 +++++++++
 fs/f2fs/dir.c   |  5 +++++
 fs/f2fs/xattr.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/f2fs/xattr.h | 12 +++++++++++-
 4 files changed, 82 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/Kconfig b/fs/f2fs/Kconfig
index fd27e7e..2214cc9 100644
--- a/fs/f2fs/Kconfig
+++ b/fs/f2fs/Kconfig
@@ -51,3 +51,12 @@ config F2FS_FS_POSIX_ACL
 	  Linux website <http://acl.bestbits.at/>.
 
 	  If you don't know what Access Control Lists are, say N
+
+config F2FS_FS_SECURITY
+	bool "F2FS Security Labels"
+	depends on F2FS_FS_XATTR
+	help
+	  Security labels provide acls used by the security modules
+	  like SELinux. This option should be used with the xattr mode.
+
+	  If you are not using a security module, say N.
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 67e2d13..81a1d6f 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -13,6 +13,7 @@
 #include "f2fs.h"
 #include "node.h"
 #include "acl.h"
+#include "xattr.h"
 
 static unsigned long dir_blocks(struct inode *inode)
 {
@@ -334,6 +335,10 @@ static struct page *init_inode_metadata(struct inode *inode,
 		if (err)
 			goto error;
 
+		err = f2fs_init_security(inode, dir, name);
+		if (err)
+			goto error;
+
 		wait_on_page_writeback(page);
 	} else {
 		page = get_node_page(F2FS_SB(dir->i_sb), inode->i_ino);
diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index ae61f35..b5292fa 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -20,6 +20,7 @@
  */
 #include <linux/rwsem.h>
 #include <linux/f2fs_fs.h>
+#include <linux/security.h>
 #include "f2fs.h"
 #include "xattr.h"
 
@@ -43,6 +44,10 @@ static size_t f2fs_xattr_generic_list(struct dentry *dentry, char *list,
 		prefix = XATTR_TRUSTED_PREFIX;
 		prefix_len = XATTR_TRUSTED_PREFIX_LEN;
 		break;
+	case F2FS_XATTR_INDEX_SECURITY:
+		prefix = XATTR_SECURITY_PREFIX;
+		prefix_len = XATTR_SECURITY_PREFIX_LEN;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -70,13 +75,14 @@ static int f2fs_xattr_generic_get(struct dentry *dentry, const char *name,
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 		break;
+	case F2FS_XATTR_INDEX_SECURITY:
+		break;
 	default:
 		return -EINVAL;
 	}
 	if (strcmp(name, "") == 0)
 		return -EINVAL;
-	return f2fs_getxattr(dentry->d_inode, type, name,
-			buffer, size);
+	return f2fs_getxattr(dentry->d_inode, type, name, buffer, size);
 }
 
 static int f2fs_xattr_generic_set(struct dentry *dentry, const char *name,
@@ -93,6 +99,8 @@ static int f2fs_xattr_generic_set(struct dentry *dentry, const char *name,
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 		break;
+	case F2FS_XATTR_INDEX_SECURITY:
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -145,6 +153,40 @@ static int f2fs_xattr_advise_set(struct dentry *dentry, const char *name,
 	return 0;
 }
 
+#ifdef CONFIG_F2FS_FS_SECURITY
+static int f2fs_initxattrs(struct inode *inode, const struct xattr *xattr_array,
+		void *fs_info)
+{
+	const struct xattr *xattr;
+	char *name;
+	int err = 0;
+
+	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
+		name = kmalloc(XATTR_SECURITY_PREFIX_LEN +
+			       strlen(xattr->name) + 1, GFP_NOFS);
+		if (!name) {
+			err = -ENOMEM;
+			break;
+		}
+		strcpy(name, XATTR_SECURITY_PREFIX);
+		strcpy(name + XATTR_SECURITY_PREFIX_LEN, xattr->name);
+		err = f2fs_setxattr(inode, F2FS_XATTR_INDEX_SECURITY, name,
+					xattr->value, xattr->value_len);
+		kfree(name);
+		if (err < 0)
+			break;
+	}
+	return err;
+}
+
+int f2fs_init_security(struct inode *inode, struct inode *dir,
+				const struct qstr *qstr)
+{
+	return security_inode_init_security(inode, dir, qstr,
+				&f2fs_initxattrs, NULL);
+}
+#endif
+
 const struct xattr_handler f2fs_xattr_user_handler = {
 	.prefix	= XATTR_USER_PREFIX,
 	.flags	= F2FS_XATTR_INDEX_USER,
@@ -169,6 +211,13 @@ const struct xattr_handler f2fs_xattr_advise_handler = {
 	.set    = f2fs_xattr_advise_set,
 };
 
+const struct xattr_handler f2fs_xattr_security_handler = {
+	.prefix	= XATTR_SECURITY_PREFIX,
+	.list	= f2fs_xattr_generic_list,
+	.get	= f2fs_xattr_generic_get,
+	.set	= f2fs_xattr_generic_set,
+};
+
 static const struct xattr_handler *f2fs_xattr_handler_map[] = {
 	[F2FS_XATTR_INDEX_USER] = &f2fs_xattr_user_handler,
 #ifdef CONFIG_F2FS_FS_POSIX_ACL
@@ -177,6 +226,9 @@ static const struct xattr_handler *f2fs_xattr_handler_map[] = {
 #endif
 	[F2FS_XATTR_INDEX_TRUSTED] = &f2fs_xattr_trusted_handler,
 	[F2FS_XATTR_INDEX_ADVISE] = &f2fs_xattr_advise_handler,
+#ifdef CONFIG_F2FS_FS_SECURITY
+	[F2FS_XATTR_INDEX_SECURITY] = &f2fs_xattr_security_handler,
+#endif
 };
 
 const struct xattr_handler *f2fs_xattr_handlers[] = {
@@ -187,6 +239,9 @@ const struct xattr_handler *f2fs_xattr_handlers[] = {
 #endif
 	&f2fs_xattr_trusted_handler,
 	&f2fs_xattr_advise_handler,
+#ifdef CONFIG_F2FS_FS_SECURITY
+	&f2fs_xattr_security_handler,
+#endif
 	NULL,
 };
 
diff --git a/fs/f2fs/xattr.h b/fs/f2fs/xattr.h
index 49c9558..14e1329 100644
--- a/fs/f2fs/xattr.h
+++ b/fs/f2fs/xattr.h
@@ -112,6 +112,7 @@ extern const struct xattr_handler f2fs_xattr_trusted_handler;
 extern const struct xattr_handler f2fs_xattr_acl_access_handler;
 extern const struct xattr_handler f2fs_xattr_acl_default_handler;
 extern const struct xattr_handler f2fs_xattr_advise_handler;
+extern const struct xattr_handler f2fs_xattr_security_handler;
 
 extern const struct xattr_handler *f2fs_xattr_handlers[];
 
@@ -121,7 +122,6 @@ extern int f2fs_getxattr(struct inode *inode, int name_index, const char *name,
 		void *buffer, size_t buffer_size);
 extern ssize_t f2fs_listxattr(struct dentry *dentry, char *buffer,
 		size_t buffer_size);
-
 #else
 
 #define f2fs_xattr_handlers	NULL
@@ -142,4 +142,14 @@ static inline ssize_t f2fs_listxattr(struct dentry *dentry, char *buffer,
 }
 #endif
 
+#ifdef CONFIG_F2FS_FS_SECURITY
+extern int f2fs_init_security(struct inode *inode, struct inode *dir,
+				const struct qstr *qstr);
+#else
+static inline int f2fs_init_security(struct inode *inode, struct inode *dir,
+				const struct qstr *qstr)
+{
+	return 0;
+}
+#endif
 #endif /* __F2FS_XATTR_H__ */
-- 
1.8.1.3.566.gaa39828

