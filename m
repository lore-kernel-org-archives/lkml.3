Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab3LRANL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 19:13:11 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:33731 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab3LRANI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 19:13:08 -0500
X-AuditID: cbfee690-b7f206d000000aee-49-52b0e8920ea1
Message-id: <1387325521.2101.212.camel@kjgkr>
Subject: Re: [PATCH] f2fs: introduce a new direct_IO write path
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Date: Wed, 18 Dec 2013 09:12:01 +0900
In-reply-to: <1387244992-7038-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1387244992-7038-1-git-send-email-jaegeuk.kim@samsung.com>
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zQ91JLzYEGTQ0q1pcWuRusWfvSRaL
	y7vmsDkwe+xe8JnJ4/MmuQCmKC6blNSczLLUIn27BK6M4zu+sBcsD6x4f/gpcwPjAacuRk4O
	CQETiefXrrJD2GISF+6tZwOxhQSWMUrMmagLU9M4/zdQDRdQfDqjxPpLrSwQRa8YJbqu5oLY
	vAK6EheONYA1CwvYS+xt7mTqYuTgYBPQlti83wCiXFHi7f67rCBhESD78nsnEJNZwENi17FS
	kAoWAVWJdw0dTCA2p4C7xKQFt6CucZN4cKiDEcTmFxCVOLxwOzOIzSygLjFp3iJmiCuVJHa3
	d7JDxOUlNq95ywxxmKDEj8n3WECulxDYxi6xvesyG8QyAYlvkw+xgNwgISArsekA1BxJiYMr
	brBMYJSYhWTFLCRjZyEZu4CReRWjaGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGSFxN2MF474D1
	IcZkoJUTmaVEk/OBcZlXEm9obGZkYWpiamxkbmlGmrCSOK/ao6QgIYH0xJLU7NTUgtSi+KLS
	nNTiQ4xMHJxSDYx28x5Yf87vWP2leILmSoep+/NVJfZpJDE/kUl4sHD+5MCd8Q9W6srXPSvx
	FthvdSPEwtuj3dkrrrXGYqnsx5cZdjc291kwiuj5nFETcsjb9SnSevn3kMLFH2Ycu8riEiDx
	+tOJirhZz7x4ZA6aPV09oXKOsSPPSwa1V+uUZoleKFcLvcAR4qbEUpyRaKjFXFScCADfu+/6
	wQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xoO6kFxuCDNY8kbe4tMjdYs/ekywW
	l3fNYXNg9ti94DOTx+dNcgFMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZK
	CnmJuam2Si4+AbpumTlAO5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWM
	Gcd3fGEvWB5Y8f7wU+YGxgNOXYycHBICJhKN83+zQ9hiEhfurWfrYuTiEBKYziix/lIrC0hC
	SOAVo0TX1VwQm1dAV+LCsQY2EFtYwF5ib3MnUxcjBwebgLbE5v0GEOWKEm/332UFCYsA2Zff
	O4GYzAIeEruOlYJUsAioSrxr6GACsTkF3CUmLbjFBtHpJvHgUAcjiM0vICpxeOF2ZhCbWUBd
	YtK8RcwQVypJ7G7vZIeIy0tsXvOWGeIwQYkfk++xTGAUmoWkZRaSsllIyhYwMq9iFE0tSC4o
	TkrPNdQrTswtLs1L10vOz93ECI7bZ1I7GFc2WBxiFOBgVOLh5Zi9PkiINbGsuDL3EKMEB7OS
	CO/OexuChHhTEiurUovy44tKc1KLDzEmA303kVlKNDkfmFLySuINjU3MjCyNzCyMTMzNSRNW
	Euc90GodKCSQnliSmp2aWpBaBLOFiYNTqoExevbTNdEnK6dek7k6Z/LmEmbly2tPNvj8nH70
	aduly13GHDzXfNMajmd/Ckn3XnQ6yUHYanZWZ2rfD82dfMFqV66csv7a+cVPnfGJYtBjW9kj
	P9l+M6sGLoma/XyRjcYpVctJHIUKV2dPPbVX1mbdNfZbepyRRhc3F3nJxHu92WC8OYHXn1VN
	iaU4I9FQi7moOBEAw0sLtx8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change log from v1:
 o fix NOSPC error handling

>From b8511a74fe98b67247a9feeed58441e8f5ffd705 Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Date: Mon, 16 Dec 2013 19:04:05 +0900
Subject: [PATCH] f2fs: introduce a new direct_IO write path
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
linux-f2fs-devel@lists.sourceforge.net

Previously, f2fs doesn't support direct IOs with high performance, which
throws
every write requests via the buffered write path, resulting in highly
performance degradation due to memory opeations like copy_from_user.

This patch introduces a new direct IO path in which every write requests
are
processed by generic blockdev_direct_IO() with enhanced get_block
function.

The get_data_block() in f2fs handles:
1. if original data blocks are allocates, then give them to blockdev.
2. otherwise,
  a. preallocate requested block addresses
  b. do not use extent cache for better performance
  c. give the block addresses to blockdev

This policy induces that:
- new allocated data are sequentially written to the disk
- updated data are randomly written to the disk.
- f2fs gives consistency on its file meta, not file data.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c    | 152
++++++++++++++++++++++++++++++++++++++++--------------
 fs/f2fs/f2fs.h    |   2 +
 fs/f2fs/segment.c |  23 ++++++---
 3 files changed, 129 insertions(+), 48 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 15956fa..a0950bc 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -570,74 +570,151 @@ repeat:
 	return page;
 }
 
+static int __allocate_data_block(struct dnode_of_data *dn)
+{
+	struct f2fs_sb_info *sbi = F2FS_SB(dn->inode->i_sb);
+	struct f2fs_summary sum;
+	block_t new_blkaddr;
+	struct node_info ni;
+	int type;
+
+	if (unlikely(is_inode_flag_set(F2FS_I(dn->inode), FI_NO_ALLOC)))
+		return -EPERM;
+	if (unlikely(!inc_valid_block_count(sbi, dn->inode, 1)))
+		return -ENOSPC;
+
+	__set_data_blkaddr(dn, NEW_ADDR);
+	dn->data_blkaddr = NEW_ADDR;
+
+	get_node_info(sbi, dn->nid, &ni);
+	set_summary(&sum, dn->nid, dn->ofs_in_node, ni.version);
+
+	type = CURSEG_WARM_DATA;
+
+	allocate_data_block(sbi, NULL, NULL_ADDR, &new_blkaddr, &sum, type);
+
+	/* direct IO doesn't use extent cache to maximize the performance */
+	set_inode_flag(F2FS_I(dn->inode), FI_NO_EXTENT);
+	update_extent_cache(new_blkaddr, dn);
+	clear_inode_flag(F2FS_I(dn->inode), FI_NO_EXTENT);
+
+	dn->data_blkaddr = new_blkaddr;
+	return 0;
+}
+
 /*
  * This function should be used by the data read flow only where it
  * does not check the "create" flag that indicates block allocation.
  * The reason for this special functionality is to exploit VFS
readahead
  * mechanism.
  */
-static int get_data_block_ro(struct inode *inode, sector_t iblock,
+static int get_data_block(struct inode *inode, sector_t iblock,
 			struct buffer_head *bh_result, int create)
 {
+	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	unsigned int blkbits = inode->i_sb->s_blocksize_bits;
 	unsigned maxblocks = bh_result->b_size >> blkbits;
 	struct dnode_of_data dn;
-	pgoff_t pgofs;
-	int err;
+	int mode = create ? ALLOC_NODE : LOOKUP_NODE_RA;
+	pgoff_t pgofs, end_offset;
+	int err = 0, ofs = 1;
+	bool allocated = false;
 
 	/* Get the page offset from the block offset(iblock) */
 	pgofs =	(pgoff_t)(iblock >> (PAGE_CACHE_SHIFT - blkbits));
 
-	if (check_extent_cache(inode, pgofs, bh_result)) {
-		trace_f2fs_get_data_block(inode, iblock, bh_result, 0);
-		return 0;
-	}
+	if (check_extent_cache(inode, pgofs, bh_result))
+		goto out;
+
+	if (create)
+		f2fs_lock_op(sbi);
 
 	/* When reading holes, we need its node page */
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
-	err = get_dnode_of_data(&dn, pgofs, LOOKUP_NODE_RA);
-	if (err) {
-		trace_f2fs_get_data_block(inode, iblock, bh_result, err);
-		return (err == -ENOENT) ? 0 : err;
+	err = get_dnode_of_data(&dn, pgofs, mode);
+	if (err || dn.data_blkaddr == NEW_ADDR) {
+		if (err == -ENOENT)
+			err = 0;
+		goto unlock_out;
 	}
 
-	/* It does not support data allocation */
-	f2fs_bug_on(create);
-
-	if (dn.data_blkaddr != NEW_ADDR && dn.data_blkaddr != NULL_ADDR) {
-		int i;
-		unsigned int end_offset;
-
+	if (dn.data_blkaddr != NULL_ADDR) {
+		map_bh(bh_result, inode->i_sb, dn.data_blkaddr);
+	} else if (create) {
+		err = __allocate_data_block(&dn);
+		if (err)
+			goto put_out;
+		allocated = true;
+		map_bh(bh_result, inode->i_sb, dn.data_blkaddr);
+	} else {
+		goto put_out;
+	}
+
+	end_offset = IS_INODE(dn.node_page) ?
+			ADDRS_PER_INODE(F2FS_I(inode)) : ADDRS_PER_BLOCK;
+	bh_result->b_size = (((size_t)1) << blkbits);
+	dn.ofs_in_node++;
+	pgofs++;
+
+get_next:
+	if (dn.ofs_in_node >= end_offset) {
+		if (allocated)
+			sync_inode_page(&dn);
+		allocated = false;
+		f2fs_put_dnode(&dn);
+
+		set_new_dnode(&dn, inode, NULL, NULL, 0);
+		err = get_dnode_of_data(&dn, pgofs, mode);
+		if (err || dn.data_blkaddr == NEW_ADDR) {
+			if (err == -ENOENT)
+				err = 0;
+			goto unlock_out;
+		}
 		end_offset = IS_INODE(dn.node_page) ?
-				ADDRS_PER_INODE(F2FS_I(inode)) :
-				ADDRS_PER_BLOCK;
-
-		clear_buffer_new(bh_result);
+			ADDRS_PER_INODE(F2FS_I(inode)) : ADDRS_PER_BLOCK;
+	}
 
+	if (maxblocks > (bh_result->b_size >> blkbits)) {
+		block_t blkaddr = datablock_addr(dn.node_page, dn.ofs_in_node);
+		if (blkaddr == NULL_ADDR && create) {
+			err = __allocate_data_block(&dn);
+			if (err)
+				goto sync_out;
+			allocated = true;
+			blkaddr = dn.data_blkaddr;
+		}
 		/* Give more consecutive addresses for the read ahead */
-		for (i = 0; i < end_offset - dn.ofs_in_node; i++)
-			if (((datablock_addr(dn.node_page,
-							dn.ofs_in_node + i))
-				!= (dn.data_blkaddr + i)) || maxblocks == i)
-				break;
-		map_bh(bh_result, inode->i_sb, dn.data_blkaddr);
-		bh_result->b_size = (((size_t)i) << blkbits);
+		if (blkaddr == (bh_result->b_blocknr + ofs)) {
+			ofs++;
+			dn.ofs_in_node++;
+			pgofs++;
+			bh_result->b_size += (((size_t)1) << blkbits);
+			goto get_next;
+		}
 	}
+sync_out:
+	if (allocated)
+		sync_inode_page(&dn);
+put_out:
 	f2fs_put_dnode(&dn);
-	trace_f2fs_get_data_block(inode, iblock, bh_result, 0);
-	return 0;
+unlock_out:
+	if (create)
+		f2fs_unlock_op(sbi);
+out:
+	trace_f2fs_get_data_block(inode, iblock, bh_result, err);
+	return err;
 }
 
 static int f2fs_read_data_page(struct file *file, struct page *page)
 {
-	return mpage_readpage(page, get_data_block_ro);
+	return mpage_readpage(page, get_data_block);
 }
 
 static int f2fs_read_data_pages(struct file *file,
 			struct address_space *mapping,
 			struct list_head *pages, unsigned nr_pages)
 {
-	return mpage_readpages(mapping, pages, nr_pages, get_data_block_ro);
+	return mpage_readpages(mapping, pages, nr_pages, get_data_block);
 }
 
 int do_write_data_page(struct page *page, struct f2fs_io_info *fio)
@@ -883,13 +960,8 @@ static ssize_t f2fs_direct_IO(int rw, struct kiocb
*iocb,
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
-
-	if (rw == WRITE)
-		return 0;
-
-	/* Needs synchronization with the cleaner */
 	return blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
-						  get_data_block_ro);
+							get_data_block);
 }
 
 static void f2fs_invalidate_data_page(struct page *page, unsigned int
offset,
@@ -928,7 +1000,7 @@ static int f2fs_set_data_page_dirty(struct page
*page)
 
 static sector_t f2fs_bmap(struct address_space *mapping, sector_t
block)
 {
-	return generic_block_bmap(mapping, block, get_data_block_ro);
+	return generic_block_bmap(mapping, block, get_data_block);
 }
 
 const struct address_space_operations f2fs_dblock_aops = {
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 1b05a62..8cbc5a6 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1115,6 +1115,8 @@ void recover_data_page(struct f2fs_sb_info *,
struct page *,
 				struct f2fs_summary *, block_t, block_t);
 void rewrite_node_page(struct f2fs_sb_info *, struct page *,
 				struct f2fs_summary *, block_t, block_t);
+void allocate_data_block(struct f2fs_sb_info *, struct page *,
+		block_t, block_t *, struct f2fs_summary *, int);
 void f2fs_wait_on_page_writeback(struct page *, enum page_type, bool);
 void write_data_summaries(struct f2fs_sb_info *, block_t);
 void write_node_summaries(struct f2fs_sb_info *, block_t);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 5b890ce..9f8bdd0 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -854,16 +854,14 @@ static int __get_segment_type(struct page *page,
enum page_type p_type)
 	return __get_segment_type_6(page, p_type);
 }
 
-static void do_write_page(struct f2fs_sb_info *sbi, struct page *page,
-			block_t old_blkaddr, block_t *new_blkaddr,
-			struct f2fs_summary *sum, struct f2fs_io_info *fio)
+void allocate_data_block(struct f2fs_sb_info *sbi, struct page *page,
+		block_t old_blkaddr, block_t *new_blkaddr,
+		struct f2fs_summary *sum, int type)
 {
 	struct sit_info *sit_i = SIT_I(sbi);
 	struct curseg_info *curseg;
 	unsigned int old_cursegno;
-	int type;
 
-	type = __get_segment_type(page, fio->type);
 	curseg = CURSEG_I(sbi, type);
 
 	mutex_lock(&curseg->curseg_mutex);
@@ -896,13 +894,22 @@ static void do_write_page(struct f2fs_sb_info
*sbi, struct page *page,
 	locate_dirty_segment(sbi, GET_SEGNO(sbi, old_blkaddr));
 	mutex_unlock(&sit_i->sentry_lock);
 
-	if (fio->type == NODE)
+	if (page && IS_NODESEG(type))
 		fill_node_footer_blkaddr(page, NEXT_FREE_BLKADDR(sbi, curseg));
 
+	mutex_unlock(&curseg->curseg_mutex);
+}
+
+static void do_write_page(struct f2fs_sb_info *sbi, struct page *page,
+			block_t old_blkaddr, block_t *new_blkaddr,
+			struct f2fs_summary *sum, struct f2fs_io_info *fio)
+{
+	int type = __get_segment_type(page, fio->type);
+
+	allocate_data_block(sbi, page, old_blkaddr, new_blkaddr, sum, type);
+
 	/* writeout dirty page into bdev */
 	f2fs_submit_page_mbio(sbi, page, *new_blkaddr, fio);
-
-	mutex_unlock(&curseg->curseg_mutex);
 }
 
 void write_meta_page(struct f2fs_sb_info *sbi, struct page *page)
-- 
1.8.4.474.g128a96c



-- 
Jaegeuk Kim
Samsung

