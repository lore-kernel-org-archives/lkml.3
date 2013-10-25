Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab3JYFgD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 01:36:03 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62964 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3JYFfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 01:35:54 -0400
X-AuditID: cbfee690-b7f3d6d000001c4a-0a-526a032954dd
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/2] f2fs: add tracepoint for set_page_dirty
Date: Fri, 25 Oct 2013 14:34:58 +0900
Message-id: <1382679299-18250-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zQ11N5qwgg1VHOS2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyvi36CJrwS/JipnH
	57A3MM4X7WLk5JAQMJH4POEFI4QtJnHh3nq2LkYuDiGBZYwSV0+2scAUnbu9gBUisYhR4tn7
	l1BVzUwSt67MYe9i5OBgE9CW2LzfAKRBRIBZYsHU84wgNcwCExgl/i96DzZJWMBG4vK6v2wg
	9SwCqhLbn4LV8wq4S3ROXMkOsUxbYtvziWC9EgL32SQutrWBJVgEBCS+TT7EAtIrISArsekA
	M0S9pMTBFTdYJjAKLmBkWMUomlqQXFCclF5kolecmFtcmpeul5yfu4kREoITdjDeO2B9iDEZ
	aNxEZinR5HxgCOeVxBsamxlZmJqYGhuZW5qRJqwkzqv2KClISCA9sSQ1OzW1ILUovqg0J7X4
	ECMTB6dUA2PjK8HYOEWVrq3fz3yZ3XNcfUp6X1en6IK0jlfBf+7INHabmgebvoxZ2isczn9Z
	rLvwV1S4++UJZ7Pu2O1cOFOwKeJRoeHCE54vPi1hWHBVIjH1jtAcLi7LkNfaHM2TyiP06uRi
	ZBvE+J5uVhG8mHvORtJ6gk7uMpUL0f/538h8LZP6WSFer8RSnJFoqMVcVJwIAOYXCDVXAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jAV1N5qwgg94VrBbXd/1lsri0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesb
	EgTXY2SABhLWMWb8W3SRteCXZMXM43PYGxjni3YxcnJICJhInLu9gBXCFpO4cG89WxcjF4eQ
	wCJGiWfvX0I5zUwSt67MYe9i5OBgE9CW2LzfAKRBRIBZYsHU84wgNcwCExgl/i96zwKSEBaw
	kbi87i8bSD2LgKrE9qdg9bwC7hKdE1eyQyzTltj2fCLjBEbuBYwMqxhFUwuSC4qT0nON9IoT
	c4tL89L1kvNzNzGCA/yZ9A7GVQ0WhxgFOBiVeHgTZmQGCbEmlhVX5h5ilOBgVhLhrTkNFOJN
	SaysSi3Kjy8qzUktPsSYDLR8IrOUaHI+MPrySuINjU3MjCyNzCyMTMzNSRNWEuc92GodKCSQ
	nliSmp2aWpBaBLOFiYNTqoHRVrT/2EI/6UkHxWedbGOsXhPlO73tpiL70x6O+yaH9PWtL/eL
	y+1WWCh5Ty5m4+XZB24oclxifR9cd8Ul7Cvn2WXMkTqx7yLy+9cz5Sf9+Z4k1L3UJE+tycvt
	fLPEfrsPnxyqs+vSz1jaX1mee8RLdsnXby9v+HuorDnJfDleWdX0yc1bG38psRRnJBpqMRcV
	JwIA9uAUbbQCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a tracepoint for set_page_dirty.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c        |  2 ++
 fs/f2fs/data.c              |  2 ++
 fs/f2fs/node.c              |  2 ++
 include/trace/events/f2fs.h | 44 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 50 insertions(+)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 5649a9d..6526f50 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -167,6 +167,8 @@ static int f2fs_set_meta_page_dirty(struct page *page)
 	struct address_space *mapping = page->mapping;
 	struct f2fs_sb_info *sbi = F2FS_SB(mapping->host->i_sb);
 
+	trace_f2fs_set_page_dirty(page, META);
+
 	SetPageUptodate(page);
 	if (!PageDirty(page)) {
 		__set_page_dirty_nobuffers(page);
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 4d4718f..be47eae 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -756,6 +756,8 @@ static int f2fs_set_data_page_dirty(struct page *page)
 	struct address_space *mapping = page->mapping;
 	struct inode *inode = mapping->host;
 
+	trace_f2fs_set_page_dirty(page, DATA);
+
 	SetPageUptodate(page);
 	if (!PageDirty(page)) {
 		__set_page_dirty_nobuffers(page);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 7bac481..304d5ce 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1225,6 +1225,8 @@ static int f2fs_set_node_page_dirty(struct page *page)
 	struct address_space *mapping = page->mapping;
 	struct f2fs_sb_info *sbi = F2FS_SB(mapping->host->i_sb);
 
+	trace_f2fs_set_page_dirty(page, NODE);
+
 	SetPageUptodate(page);
 	if (!PageDirty(page)) {
 		__set_page_dirty_nobuffers(page);
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 52ae548..ebde3af 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -36,6 +36,11 @@
 		{ CURSEG_COLD_NODE, 	"Cold NODE" },			\
 		{ NO_CHECK_TYPE, 	"No TYPE" })
 
+#define show_file_type(type)						\
+	__print_symbolic(type,						\
+		{ 0,		"FILE" },				\
+		{ 1,		"DIR" })
+
 #define show_gc_type(type)						\
 	__print_symbolic(type,						\
 		{ FG_GC,	"Foreground GC" },			\
@@ -623,6 +628,45 @@ TRACE_EVENT(f2fs_do_submit_bio,
 		__entry->size)
 );
 
+DECLARE_EVENT_CLASS(f2fs__page,
+
+	TP_PROTO(struct page *page, int type),
+
+	TP_ARGS(page, type),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(int, type)
+		__field(int, dir)
+		__field(pgoff_t, index)
+		__field(int, dirty)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= page->mapping->host->i_sb->s_dev;
+		__entry->ino	= page->mapping->host->i_ino;
+		__entry->type	= type;
+		__entry->dir	= S_ISDIR(page->mapping->host->i_mode);
+		__entry->index	= page->index;
+		__entry->dirty	= PageDirty(page);
+	),
+
+	TP_printk("dev = (%d,%d), ino = %lu, %s, %s, index = %lu, dirty = %d",
+		show_dev_ino(__entry),
+		show_block_type(__entry->type),
+		show_file_type(__entry->dir),
+		(unsigned long)__entry->index,
+		__entry->dirty)
+);
+
+DEFINE_EVENT(f2fs__page, f2fs_set_page_dirty,
+
+	TP_PROTO(struct page *page, int type),
+
+	TP_ARGS(page, type)
+);
+
 TRACE_EVENT(f2fs_submit_write_page,
 
 	TP_PROTO(struct page *page, block_t blk_addr, int type),
-- 
1.8.4.474.g128a96c

