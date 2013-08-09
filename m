Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967562Ab3HIGVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 02:21:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:17606 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967449Ab3HIGVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 02:21:05 -0400
X-AuditID: cbfee68f-b7f436d000000f81-19-52048a4d4f26
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 3/3] f2fs: introduce cur_cp_versioin function to reduce code
 size
Date: Fri, 09 Aug 2013 15:20:30 +0900
Message-id: <1376029230-303-3-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.3.1.437.g0dbd812
In-reply-to: <1376029230-303-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1376029230-303-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t8zQ13fLpYgg2dLjCyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyjjbt52poEmpYm3b
	L9YGxjUyXYycHBICJhIPVl1mh7DFJC7cW8/WxcjFISSwjFGiddU0VpiinfeOMEMkpjNKrLlz
	mhXCaWOSeNA+mbGLkYODTUBbYvN+A5AGEQFmiQVTzzOC1DALTGCU+L/oPQtIjbBAsMShF1Ig
	NSwCqhITJ69hAgnzCrhKvJmgDLFLV2LRiYNgezkF3CTe/J0AZgsBlXRd+gY2UkLgO5vEw5fv
	GCHmCEh8m3wIbLyEgKzEpgPMEHMkJQ6uuMEygVF4ASPDKkbR1ILkguKk9CJjveLE3OLSvHS9
	5PzcTYyQgO3fwXj3gPUhxmSgcROZpUST84EBn1cSb2hsZmRhamJqbGRuaUaasJI4r1qLdaCQ
	QHpiSWp2ampBalF8UWlOavEhRiYOTqkGxk0x9Y6Ci0qknu0wl21/0ntPZq2U2+e+uz/W170t
	DN+7w4vx09lNEQkMV5UbMranfdOLlfTvPuI+szLhlNa93i/dnmaBn3YfbxMQqzK8Lmp/gTsv
	Z9afg/dWntFV/azhkP7iwo2QlgMLzeqLoiINKs/f3lJdWhTeOKXB67/ErP0z/HX/m7yUUmIp
	zkg01GIuKk4EAAy+TONuAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jQV3fLpYgg0kvdS2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8w427edqaBJqWJt2y/WBsY1Ml2MnBwSAiYSO+8dYYawxSQu3FvP1sXIxSEk
	MJ1RYs2d06wQThuTxIP2yYxdjBwcbALaEpv3G4A0iAgwSyyYep4RpIZZYAKjxP9F71lAaoQF
	giUOvZACqWERUJWYOHkNE0iYV8BV4s0EZYhduhKLThxkBbE5Bdwk3vydAGYLAZV0XfrGOIGR
	dwEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Hh4JrWDcWWDxSFGAQ5GJR5exe3MQUKs
	iWXFlbmHGCU4mJVEeF9kAYV4UxIrq1KL8uOLSnNSiw8xJgMdNZFZSjQ5HxireSXxhsYmZkaW
	RmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXA6Nli+3b2zKPaapwfC8/0z+n7
	HHK+PlP066VnjhVLQ9h45eSk961m+v765sXJ7/6dTJzKsX8ht7bao/IqSf68NlbJbTwbPe6Y
	P2/IXfRfV1OEK2zJhPwmL4HDoY+nufUxer8/tji25dHZHa73d9kapLT4m9hoJ556qPd/z9HD
	s43r/jZXvbSyUGIpzkg01GIuKk4EAMEjjcvLAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a new inline function, cur_cp_version, to reduce redundant
codes.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c | 6 +++---
 fs/f2fs/f2fs.h       | 7 ++++++-
 fs/f2fs/file.c       | 3 +--
 fs/f2fs/recovery.c   | 4 ++--
 fs/f2fs/xattr.c      | 2 +-
 5 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index c5a5c39..bb31220 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -379,7 +379,7 @@ static struct page *validate_checkpoint(struct f2fs_sb_info *sbi,
 	if (!f2fs_crc_valid(crc, cp_block, crc_offset))
 		goto invalid_cp1;
 
-	pre_version = le64_to_cpu(cp_block->checkpoint_ver);
+	pre_version = cur_cp_version(cp_block);
 
 	/* Read the 2nd cp block in this CP pack */
 	cp_addr += le32_to_cpu(cp_block->cp_pack_total_block_count) - 1;
@@ -394,7 +394,7 @@ static struct page *validate_checkpoint(struct f2fs_sb_info *sbi,
 	if (!f2fs_crc_valid(crc, cp_block, crc_offset))
 		goto invalid_cp2;
 
-	cur_version = le64_to_cpu(cp_block->checkpoint_ver);
+	cur_version = cur_cp_version(cp_block);
 
 	if (cur_version == pre_version) {
 		*version = cur_version;
@@ -799,7 +799,7 @@ void write_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
 	 * Increase the version number so that
 	 * SIT entries and seg summaries are written at correct place
 	 */
-	ckpt_ver = le64_to_cpu(ckpt->checkpoint_ver);
+	ckpt_ver = cur_cp_version(ckpt);
 	ckpt->checkpoint_ver = cpu_to_le64(++ckpt_ver);
 
 	/* write cached NAT/SIT entries to NAT/SIT area */
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index c1c9670..5348b63 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -503,6 +503,11 @@ static inline void F2FS_RESET_SB_DIRT(struct f2fs_sb_info *sbi)
 	sbi->s_dirty = 0;
 }
 
+static inline unsigned long long cur_cp_version(struct f2fs_checkpoint *cp)
+{
+	return le64_to_cpu(cp->checkpoint_ver);
+}
+
 static inline bool is_set_ckpt_flags(struct f2fs_checkpoint *cp, unsigned int f)
 {
 	unsigned int ckpt_flags = le32_to_cpu(cp->ckpt_flags);
@@ -691,7 +696,7 @@ static inline block_t __start_cp_addr(struct f2fs_sb_info *sbi)
 {
 	block_t start_addr;
 	struct f2fs_checkpoint *ckpt = F2FS_CKPT(sbi);
-	unsigned long long ckpt_version = le64_to_cpu(ckpt->checkpoint_ver);
+	unsigned long long ckpt_version = cur_cp_version(ckpt);
 
 	start_addr = le32_to_cpu(F2FS_RAW_SUPER(sbi)->cp_blkaddr);
 
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 49a414d..dface4f 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -161,8 +161,7 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		need_cp = true;
 	else if (!is_checkpointed_node(sbi, F2FS_I(inode)->i_pino))
 		need_cp = true;
-	else if (F2FS_I(inode)->xattr_ver ==
-			le64_to_cpu(F2FS_CKPT(sbi)->checkpoint_ver))
+	else if (F2FS_I(inode)->xattr_ver == cur_cp_version(F2FS_CKPT(sbi)))
 		need_cp = true;
 
 	if (need_cp) {
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 639eb34..c6908b5 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -117,7 +117,7 @@ static int recover_inode(struct inode *inode, struct page *node_page)
 
 static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 {
-	unsigned long long cp_ver = le64_to_cpu(sbi->ckpt->checkpoint_ver);
+	unsigned long long cp_ver = cur_cp_version(F2FS_CKPT(sbi));
 	struct curseg_info *curseg;
 	struct page *page;
 	block_t blkaddr;
@@ -355,7 +355,7 @@ err:
 static int recover_data(struct f2fs_sb_info *sbi,
 				struct list_head *head, int type)
 {
-	unsigned long long cp_ver = le64_to_cpu(sbi->ckpt->checkpoint_ver);
+	unsigned long long cp_ver = cur_cp_version(F2FS_CKPT(sbi));
 	struct curseg_info *curseg;
 	struct page *page;
 	int err = 0;
diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index 0f6d2a1..fb16f71 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -488,7 +488,7 @@ int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
 	}
 
 	/* store checkpoint version for conducting checkpoint during fsync */
-	fi->xattr_ver = le64_to_cpu(F2FS_CKPT(sbi)->checkpoint_ver);
+	fi->xattr_ver = cur_cp_version(F2FS_CKPT(sbi));
 
 	if (ipage)
 		update_inode(inode, ipage);
-- 
1.8.3.1.437.g0dbd812

