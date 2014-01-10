Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711AbaAJH0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 02:26:21 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:58769 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaAJH0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 02:26:17 -0500
X-AuditID: cbfee6a4-b7fb26d000005ed6-30-52cfa097f189
Date: Fri, 10 Jan 2014 07:26:15 +0000 (GMT)
From: Yuan Zhong <yuan.mark.zhong@samsung.com>
Subject: [f2fs-dev] [PATCH] f2fs: remove the needless parameter of
 f2fs_wait_on_page_writeback
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Reply-to: yuan.mark.zhong@samsung.com
MIME-version: 1.0
X-MTR: 20140110062036523@yuan.mark.zhong
Msgkey: 20140110062036523@yuan.mark.zhong
X-EPLocale: en_US.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140110062036523@yuan.mark.zhong
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <22129358.426611389338774522.JavaMail.weblogic@epv6ml02>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t/t6brTF5wPMujaz2NxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyrq82K5ilXjFvi3UD4xS1LkZODiEBLYn3Px4yg9gSAiYS2/6s
	ZISwxSQu3FvP1sXIBVQzn1Hi/PxvYAkWAVWJtpN7wRrYBPQl7uzbBxYXFoiT6Fg/mx3EFhFQ
	kJjcthmshlmgSqL/2TWmLkYOoEGqEsfXloKEeQUEJU7OfMICsUtD4v7+PewQcU2Jid9OsUPE
	5SSWTL3MBGHzSsxof8oCE5/2dQ3UzdIS52dtgLt58ffHUHF+iWO3d4CtBel9cj8YZszuzV/Y
	IGwBialnDjJClOhKbHiRAxHmk1iz8C0LzJRdp5Yzw7Te3zKXCeIpRYkp3Q/ZIWwDiSOL5rCi
	+4pXwEXi7/OzTBMY5WYhSc1C0j4LSTuymgWMLKsYRVMLkguKk9IrTPSKE3OLS/PS9ZLzczcx
	guP72ZIdjA0XrA8xCnAwKvHwFsw6HyTEmlhWXJl7iFGCg1lJhLe5FSjEm5JYWZValB9fVJqT
	WnyIUZqDRUmcd8GtpCAhgfTEktTs1NSC1CKYLBMHp1QDY9WG6U9+9steLLbKvO92dt8sqTKx
	91ZTi9T/nZvN4LY2r/Vi+DHN27w51+QMRZIWhVqribBEZdRk9kRJO+z2eOJ1+u+7z7ILP3tv
	epQuL5iztNXvwdvtdTuaJM86STksv3VaTDIkPaNrZ6FB0IXS1ElPo9RmO11KfpI218Vmsayi
	ycEkCbNYJZbijERDLeai4kQAX89KA+sCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0A7QQUj007506

"boo sync" parameter is never referenced in f2fs_wait_on_page_writeback.
We should remove this parameter.

Signed-off-by: Yuan Zhong <yuan.mark.zhong@samsung.com>
---
 fs/f2fs/data.c    |    2 +-
 fs/f2fs/f2fs.h    |    2 +-
 fs/f2fs/gc.c      |    4 ++--
 fs/f2fs/inline.c  |    2 +-
 fs/f2fs/inode.c   |    2 +-
 fs/f2fs/segment.c |    2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 63d1902..19ad066 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -226,7 +226,7 @@ static void __set_data_blkaddr(struct dnode_of_data *dn, block_t new_addr)
 	struct page *node_page = dn->node_page;
 	unsigned int ofs_in_node = dn->ofs_in_node;
 
-	f2fs_wait_on_page_writeback(node_page, NODE, false);
+	f2fs_wait_on_page_writeback(node_page, NODE);
 
 	rn = F2FS_NODE(node_page);
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 5f7dc4f..8466b5e 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1132,7 +1132,7 @@ void rewrite_node_page(struct f2fs_sb_info *, struct page *,
 				struct f2fs_summary *, block_t, block_t);
 void allocate_data_block(struct f2fs_sb_info *, struct page *,
 		block_t, block_t *, struct f2fs_summary *, int);
-void f2fs_wait_on_page_writeback(struct page *, enum page_type, bool);
+void f2fs_wait_on_page_writeback(struct page *, enum page_type);
 void write_data_summaries(struct f2fs_sb_info *, block_t);
 void write_node_summaries(struct f2fs_sb_info *, block_t);
 int lookup_journal_in_cursum(struct f2fs_summary_block *,
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 9117cca..ea0371e 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -428,7 +428,7 @@ next_step:
 
 		/* set page dirty and write it */
 		if (gc_type == FG_GC) {
-			f2fs_wait_on_page_writeback(node_page, NODE, true);
+			f2fs_wait_on_page_writeback(node_page, NODE);
 			set_page_dirty(node_page);
 		} else {
 			if (!PageWriteback(node_page))
@@ -533,7 +533,7 @@ static void move_data_page(struct inode *inode, struct page *page, int gc_type)
 	} else {
 		struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 
-		f2fs_wait_on_page_writeback(page, DATA, true);
+		f2fs_wait_on_page_writeback(page, DATA);
 
 		if (clear_page_dirty_for_io(page) &&
 			S_ISDIR(inode->i_mode)) {
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index e0d800a..31ee5b1 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -106,7 +106,7 @@ static int __f2fs_convert_inline_data(struct inode *inode, struct page *page)
 	set_page_writeback(page);
 	write_data_page(page, &dn, &new_blk_addr, &fio);
 	update_extent_cache(new_blk_addr, &dn);
-	f2fs_wait_on_page_writeback(page, DATA, true);
+	f2fs_wait_on_page_writeback(page, DATA);
 
 	/* clear inline data and flag after data writeback */
 	zero_user_segment(ipage, INLINE_DATA_OFFSET,
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 915f9a8..ffa4c6d 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -175,7 +175,7 @@ void update_inode(struct inode *inode, struct page *node_page)
 {
 	struct f2fs_inode *ri;
 
-	f2fs_wait_on_page_writeback(node_page, NODE, false);
+	f2fs_wait_on_page_writeback(node_page, NODE);
 
 	ri = F2FS_INODE(node_page);
 
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 5f84639..a934e6f 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1053,7 +1053,7 @@ void rewrite_node_page(struct f2fs_sb_info *sbi,
 }
 
 void f2fs_wait_on_page_writeback(struct page *page,
-				enum page_type type, bool sync)
+				enum page_type type)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(page->mapping->host->i_sb);
 	if (PageWriteback(page)) {
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
