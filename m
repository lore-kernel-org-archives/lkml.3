Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbaDWFZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 01:25:49 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:61342 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaDWFZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 01:25:43 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-62-53574ed60aee
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/3] f2fs: pass flags field to setxattr functions
Date: Wed, 23 Apr 2014 14:23:31 +0900
Message-id: <1398230612-7062-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1398230612-7062-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1398230612-7062-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t8zY93rfuHBBt0GFtd3/WWyuLTI3WLP
	3pMsFpd3zWFzYPHYveAzk0ffllWMHp83yQUwR3HZpKTmZJalFunbJXBlbLu9l6ngs2zFsQmd
	rA2MCyW6GDk5JARMJN4c7meDsMUkLtxbD2RzcQgJLGOUmH9rNitc0YbtzCC2kMAiRok1m9Mh
	ijqZJGa+O8rUxcjBwSagLbF5vwFIjYgAs8SCqecZQWqYBSYwSvxf9J4FJCEs4Chx4cFKsEEs
	AqoSt+/vBFvAK+Am0dg4kxFimbbEtucTwWxOAXeJkxvXsUIsdpN4NnE+2HUSAt/ZJM61rWaB
	GCQg8W3yIRaQIyQEZCU2HWCGmCMpcXDFDZYJjMILGBlWMYqmFiQXFCelFxnrFSfmFpfmpesl
	5+duYoQEbP8OxrsHrA8xJgONm8gsJZqcDwz4vJJ4Q2MzIwtTE1NjI3NLM9KElcR57z9MChIS
	SE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAeGz2pmiT7X4y75byHOPeyqvqfvHHFB8elbql0zNa
	6u65r1oa/+RhiLEX40s/9m+hl78LFTyab7Zkl/rfdfqmjxeJbuFbfvlVHf+cEvUn835smJH5
	cl5Frs98Q65n1TMXMWzYeKkrQX4zo+I+foYSdx3rf1ZKLRuWa27fzei963nijncaLXsnKSix
	FGckGmoxFxUnAgBpe2XfbgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jAd1rfuHBBmc3W1pc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5ix7fZepoLPshXHJnSyNjAulOhi5OSQEDCReLNhOzOELSZx4d56NhBbSGAR
	o8SazeldjFxAdieTxMx3R5m6GDk42AS0JTbvNwCpERFgllgw9TwjSA2zwARGif+L3rOAJIQF
	HCUuPFgJNpRFQFXi9v2drCA2r4CbRGPjTEaIZdoS255PBLM5BdwlTm5cxwqx2E3i2cT5bBMY
	eRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI6IZ1I7GFc2WBxiFOBgVOLhLVgZFizE
	mlhWXJl7iFGCg1lJhHfmR6AQb0piZVVqUX58UWlOavEhxmSgqyYyS4km5wOjNa8k3tDYxMzI
	0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGHnjSzatmLmpwEGoYV5at87v
	i/Hxu05Pn9tsGBq3x3qOhnjlnhud++56v178UF9nyTHP8w8enjpkULDgbT6PhbF1gXZI2Bpd
	/s0puY9OtU6S4dKpdpa7spbrptuHmVrfNts3PXY0mKHOZZvr87TMr79jM/8MuVV35jKvKyrd
	uaYnsP5hxSbd9UosxRmJhlrMRcWJAI5Lg9TMAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch passes the "flags" field to the low level setxattr functions
to use XATTR_REPLACE in the following patches.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/acl.c   |  2 +-
 fs/f2fs/xattr.c | 13 +++++++------
 fs/f2fs/xattr.h |  4 ++--
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
index e93e4ec..dbe2141 100644
--- a/fs/f2fs/acl.c
+++ b/fs/f2fs/acl.c
@@ -240,7 +240,7 @@ static int __f2fs_set_acl(struct inode *inode, int type,
 		}
 	}
 
-	error = f2fs_setxattr(inode, name_index, "", value, size, ipage);
+	error = f2fs_setxattr(inode, name_index, "", value, size, ipage, 0);
 
 	kfree(value);
 	if (!error)
diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index 1de057d..bbe9c2b 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -108,7 +108,8 @@ static int f2fs_xattr_generic_set(struct dentry *dentry, const char *name,
 	if (strcmp(name, "") == 0)
 		return -EINVAL;
 
-	return f2fs_setxattr(dentry->d_inode, type, name, value, size, NULL);
+	return f2fs_setxattr(dentry->d_inode, type, name,
+					value, size, NULL, flags);
 }
 
 static size_t f2fs_xattr_advise_list(struct dentry *dentry, char *list,
@@ -157,7 +158,7 @@ static int f2fs_xattr_advise_set(struct dentry *dentry, const char *name,
 #ifdef CONFIG_F2FS_FS_SECURITY
 static int __f2fs_setxattr(struct inode *inode, int index,
 			const char *name, const void *value, size_t size,
-			struct page *ipage);
+			struct page *ipage, int);
 
 static int f2fs_initxattrs(struct inode *inode, const struct xattr *xattr_array,
 		void *page)
@@ -168,7 +169,7 @@ static int f2fs_initxattrs(struct inode *inode, const struct xattr *xattr_array,
 	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
 		err = __f2fs_setxattr(inode, F2FS_XATTR_INDEX_SECURITY,
 				xattr->name, xattr->value,
-				xattr->value_len, (struct page *)page);
+				xattr->value_len, (struct page *)page, 0);
 		if (err < 0)
 			break;
 	}
@@ -479,7 +480,7 @@ cleanup:
 
 static int __f2fs_setxattr(struct inode *inode, int index,
 			const char *name, const void *value, size_t size,
-			struct page *ipage)
+			struct page *ipage, int flags)
 {
 	struct f2fs_inode_info *fi = F2FS_I(inode);
 	struct f2fs_xattr_entry *here, *last;
@@ -586,7 +587,7 @@ exit:
 
 int f2fs_setxattr(struct inode *inode, int index, const char *name,
 				const void *value, size_t size,
-				struct page *ipage)
+				struct page *ipage, int flags)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	int err;
@@ -596,7 +597,7 @@ int f2fs_setxattr(struct inode *inode, int index, const char *name,
 	f2fs_lock_op(sbi);
 	/* protect xattr_ver */
 	down_write(&F2FS_I(inode)->i_sem);
-	err = __f2fs_setxattr(inode, index, name, value, size, ipage);
+	err = __f2fs_setxattr(inode, index, name, value, size, ipage, flags);
 	up_write(&F2FS_I(inode)->i_sem);
 	f2fs_unlock_op(sbi);
 
diff --git a/fs/f2fs/xattr.h b/fs/f2fs/xattr.h
index 79bc2bb..34ab7db 100644
--- a/fs/f2fs/xattr.h
+++ b/fs/f2fs/xattr.h
@@ -114,14 +114,14 @@ extern const struct xattr_handler f2fs_xattr_security_handler;
 extern const struct xattr_handler *f2fs_xattr_handlers[];
 
 extern int f2fs_setxattr(struct inode *, int, const char *,
-				const void *, size_t, struct page *);
+				const void *, size_t, struct page *, int);
 extern int f2fs_getxattr(struct inode *, int, const char *, void *, size_t);
 extern ssize_t f2fs_listxattr(struct dentry *, char *, size_t);
 #else
 
 #define f2fs_xattr_handlers	NULL
 static inline int f2fs_setxattr(struct inode *inode, int index,
-		const char *name, const void *value, size_t size)
+		const char *name, const void *value, size_t size, int flags)
 {
 	return -EOPNOTSUPP;
 }
-- 
1.8.4.474.g128a96c

