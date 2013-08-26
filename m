Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab3HZLQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 07:16:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64107 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab3HZLQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 07:16:49 -0400
X-AuditID: cbfee68e-b7f756d000004512-65-521b39200369
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/5] f2fs: add flags for inline xattrs
Date: Mon, 26 Aug 2013 20:16:37 +0900
Message-id: <1377515801-15243-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.3.1.437.g0dbd812
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zY10FS+kgg7u3BS2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyrj97DhjwUr1isuH
	ZrM3MDYrdDFyckgImEicOP6NEcIWk7hwbz0biC0ksIxR4t6SVJiaUwt3snQxcgHFpzNKfOz7
	yQ7htDFJbDh/irmLkYODTUBbYvN+A5AGEQFmiQVTzzOC1DALTGCU+L/oPQtIQljATOLYgstg
	21gEVCWO/20Ai/MKuEvs3b6OGWKbrsSiEwdZQZolBO6zSZxpWMkO0SAg8W3yIRaQZRICshKb
	DkDVS0ocXHGDZQKj4AJGhlWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsYISHYt4Px5gHrQ4zJ
	QOMmMkuJJucDQzivJN7Q2MzIwtTE1NjI3NKMNGElcV61FutAIYH0xJLU7NTUgtSi+KLSnNTi
	Q4xMHJxSDYwbvDunXFmx9ft/RkE+/qQUmUuZ7Rslfm9oZtxmWaS1+eJGXpadjVocH8Ukzjtx
	9t20P3ys5OuOI9l6ObMnKluZ7Lp5z9hiAdO8h30T5p3QY3XeMjEtivvDy0s57eyVE9WOhN77
	FrP/3KpZf7KddQuZ9l/t8dtsr872IX1ZkvyX6F2zGC3MtDKUWIozEg21mIuKEwEJrTdoVwIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jQV0FS+kgg20feCyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8y4/ew4Y8FK9YrLh2azNzA2K3QxcnJICJhInFq4kwXCFpO4cG89WxcjF4eQ
	wHRGiY99P9khnDYmiQ3nTzF3MXJwsAloS2zebwDSICLALLFg6nlGkBpmgQmMEv8XvQebJCxg
	JnFswWVGEJtFQFXi+N8GsDivgLvE3u3rmCG26UosOnGQdQIj9wJGhlWMoqkFyQXFSem5RnrF
	ibnFpXnpesn5uZsYwSH+THoH46oGi0OMAhyMSjy8AWzSQUKsiWXFlbmHGCU4mJVEeM1FgUK8
	KYmVValF+fFFpTmpxYcYk4G2T2SWEk3OB8ZfXkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE
	0hNLUrNTUwtSi2C2MHFwSjUwsmrXnp4yT+PO6yWvjRr5Bf9G3JjU0bFhgYxLjMruJu0bP4y2
	v/zmH60b9HSlmvfR394z3388IlF4dIfAOd6uGObZyV/Mp60t/VVwljk653uE82pTqdC7Otf3
	H0hoXrzKc/fkn2usf/Bozfmq5aJqK7/ryLQVT1XND1z4GjHvwJfdIjwKyu+rvJVYijMSDbWY
	i4oTAbjw+sy1AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds basic inode flags for inline xattrs, F2FS_INLINE_XATTR,
and add a mount option, inline_xattr, which is enabled when xattr is set.

If the mount option is enabled, all the files are marked with the inline_xattrs
flag.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h          | 18 ++++++++++++++++++
 fs/f2fs/inode.c         |  2 ++
 fs/f2fs/super.c         | 14 ++++++++++++++
 include/linux/f2fs_fs.h |  4 +++-
 4 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 5348b63..b82f141 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -29,6 +29,7 @@
 #define F2FS_MOUNT_XATTR_USER		0x00000010
 #define F2FS_MOUNT_POSIX_ACL		0x00000020
 #define F2FS_MOUNT_DISABLE_EXT_IDENTIFY	0x00000040
+#define F2FS_MOUNT_INLINE_XATTR		0x00000080
 
 #define clear_opt(sbi, option)	(sbi->mount_opt.opt &= ~F2FS_MOUNT_##option)
 #define set_opt(sbi, option)	(sbi->mount_opt.opt |= F2FS_MOUNT_##option)
@@ -892,6 +893,7 @@ enum {
 	FI_NO_ALLOC,		/* should not allocate any blocks */
 	FI_UPDATE_DIR,		/* should update inode block for consistency */
 	FI_DELAY_IPUT,		/* used for the recovery */
+	FI_INLINE_XATTR,	/* used for inline xattr */
 };
 
 static inline void set_inode_flag(struct f2fs_inode_info *fi, int flag)
@@ -924,6 +926,22 @@ static inline int cond_clear_inode_flag(struct f2fs_inode_info *fi, int flag)
 	return 0;
 }
 
+static inline void get_inline_info(struct f2fs_inode_info *fi,
+					struct f2fs_inode *ri)
+{
+	if (ri->i_inline & F2FS_INLINE_XATTR)
+		set_inode_flag(fi, FI_INLINE_XATTR);
+}
+
+static inline void set_raw_inline(struct f2fs_inode_info *fi,
+					struct f2fs_inode *ri)
+{
+	ri->i_inline = 0;
+
+	if (is_inode_flag_set(fi, FI_INLINE_XATTR))
+		ri->i_inline |= F2FS_INLINE_XATTR;
+}
+
 static inline int f2fs_readonly(struct super_block *sb)
 {
 	return sb->s_flags & MS_RDONLY;
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 7f8569b..9339cd2 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -85,6 +85,7 @@ static int do_read_inode(struct inode *inode)
 	fi->i_advise = ri->i_advise;
 	fi->i_pino = le32_to_cpu(ri->i_pino);
 	get_extent_info(&fi->ext, ri->i_ext);
+	get_inline_info(fi, ri);
 	f2fs_put_page(node_page, 1);
 	return 0;
 }
@@ -164,6 +165,7 @@ void update_inode(struct inode *inode, struct page *node_page)
 	ri->i_size = cpu_to_le64(i_size_read(inode));
 	ri->i_blocks = cpu_to_le64(inode->i_blocks);
 	set_raw_extent(&F2FS_I(inode)->ext, &ri->i_ext);
+	set_raw_inline(F2FS_I(inode), ri);
 
 	ri->i_atime = cpu_to_le64(inode->i_atime.tv_sec);
 	ri->i_ctime = cpu_to_le64(inode->i_ctime.tv_sec);
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index d28c452..70ecf48 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -47,6 +47,7 @@ enum {
 	Opt_noacl,
 	Opt_active_logs,
 	Opt_disable_ext_identify,
+	Opt_inline_xattr,
 	Opt_err,
 };
 
@@ -59,6 +60,7 @@ static match_table_t f2fs_tokens = {
 	{Opt_noacl, "noacl"},
 	{Opt_active_logs, "active_logs=%u"},
 	{Opt_disable_ext_identify, "disable_ext_identify"},
+	{Opt_inline_xattr, "inline_xattr"},
 	{Opt_err, NULL},
 };
 
@@ -238,11 +240,18 @@ static int parse_options(struct super_block *sb, char *options)
 		case Opt_nouser_xattr:
 			clear_opt(sbi, XATTR_USER);
 			break;
+		case Opt_inline_xattr:
+			set_opt(sbi, INLINE_XATTR);
+			break;
 #else
 		case Opt_nouser_xattr:
 			f2fs_msg(sb, KERN_INFO,
 				"nouser_xattr options not supported");
 			break;
+		case Opt_inline_xattr:
+			f2fs_msg(sb, KERN_INFO,
+				"inline_xattr options not supported");
+			break;
 #endif
 #ifdef CONFIG_F2FS_FS_POSIX_ACL
 		case Opt_noacl:
@@ -292,6 +301,9 @@ static struct inode *f2fs_alloc_inode(struct super_block *sb)
 
 	set_inode_flag(fi, FI_NEW_INODE);
 
+	if (test_opt(F2FS_SB(sb), INLINE_XATTR))
+		set_inode_flag(fi, FI_INLINE_XATTR);
+
 	return &fi->vfs_inode;
 }
 
@@ -444,6 +456,8 @@ static int f2fs_show_options(struct seq_file *seq, struct dentry *root)
 		seq_puts(seq, ",user_xattr");
 	else
 		seq_puts(seq, ",nouser_xattr");
+	if (test_opt(sbi, INLINE_XATTR))
+		seq_puts(seq, ",inline_xattr");
 #endif
 #ifdef CONFIG_F2FS_FS_POSIX_ACL
 	if (test_opt(sbi, POSIX_ACL))
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index 383d5e3..10ab11f 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -144,10 +144,12 @@ struct f2fs_extent {
 #define ADDRS_PER_BLOCK         1018	/* Address Pointers in a Direct Block */
 #define NIDS_PER_BLOCK          1018	/* Node IDs in an Indirect Block */
 
+#define F2FS_INLINE_XATTR	0x01	/* file inline xattr flag */
+
 struct f2fs_inode {
 	__le16 i_mode;			/* file mode */
 	__u8 i_advise;			/* file hints */
-	__u8 i_reserved;		/* reserved */
+	__u8 i_inline;			/* file inline flags */
 	__le32 i_uid;			/* user ID */
 	__le32 i_gid;			/* group ID */
 	__le32 i_links;			/* links count */
-- 
1.8.3.1.437.g0dbd812

