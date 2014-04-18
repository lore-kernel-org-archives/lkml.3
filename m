Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaDRIQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 04:16:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18587 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbaDRIPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 04:15:30 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-c8-5350df20dea6
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: adjust free mem size to flush dentry blocks
Date: Fri, 18 Apr 2014 17:13:24 +0900
Message-id: <1397808804-5997-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t8zA12F+wHBBtevaVlc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfG4aQ9zwWSjiouN
	85gbGPs1uxg5OSQETCQW3n7MAmGLSVy4t56ti5GLQ0hgGaPE1YNvGWGKtrd0MkEkFjFKHNnz
	hxXC6WSSuDnvAXsXIwcHm4C2xOb9BiANIgLMEgumnmcEqWEWmMAo8X/Re7AVwgJOEr96HrGD
	2CwCqhK7HywEi/MKuEnM6noNdYa2xLbnE8GaJQTus0kcu/8bqkFA4tvkQywgyyQEZCU2HWCG
	qJeUOLjiBssERsEFjAyrGEVTC5ILipPSiwz1ihNzi0vz0vWS83M3MUKCsHcH4+0D1ocYk4HG
	TWSWEk3OBwZxXkm8obGZkYWpiamxkbmlGWnCSuK8SQ+TgoQE0hNLUrNTUwtSi+KLSnNSiw8x
	MnFwSjUwJnN5TpOZvqHkkknDLT+bDTxRq8VKT6V2FPod4u5evvy327Lr10OkrzyYFTn5eJuP
	6++p4ddWsFe9CpzP9KL/8Gne9E3f3i3S3bBIZZn0el6rn0liAZKqc6PLFnJ0rmLd3crc19Fd
	rxj0c4GyQsn5x0cFnv+xdFQ+tbpfYErjkaV2Dxl1FlaHK7EUZyQaajEXFScCALuiysRYAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jAV2F+wHBBh1z1Syu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8x43LSHuWCyUcXFxnnMDYz9ml2MnBwSAiYS21s6mSBsMYkL99azdTFycQgJ
	LGKUOLLnDyuE08kkcXPeA/YuRg4ONgFtic37DUAaRASYJRZMPc8IUsMsMIFR4v+i9ywgCWEB
	J4lfPY/YQWwWAVWJ3Q8WgsV5BdwkZnW9ZoHYpi2x7flExgmM3AsYGVYxiqYWJBcUJ6XnGuoV
	J+YWl+al6yXn525iBIf4M6kdjCsbLA4xCnAwKvHwCugFBAuxJpYVV+YeYpTgYFYS4VUuBQrx
	piRWVqUW5ccXleakFh9iTAbaPpFZSjQ5Hxh/eSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQS
	SE8sSc1OTS1ILYLZwsTBKdXAeO6jtIlqbefm0psZedfqmyobF1+58eDOjTn3bzNHnvp6plx6
	9i82deO9/0V+an1ji6tRnMv2b3llYOOsrk1PHKPCLmquUT4wp9a293jswRUqi6XM9wYeDfwm
	fnOr893i2B93fp3Q2D1h7gPFxsjMcLPt1gI1Jd1G7398P6ixqn3TWq65qbJtdkosxRmJhlrM
	RcWJAGLQrGG1AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If so many dirty dentry blocks are cached, not reached to the flush condition,
we should fall into livelock in balance_dirty_pages.
So, let's consider the mem size for the condition.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c |  3 ++-
 fs/f2fs/f2fs.h |  1 +
 fs/f2fs/node.c | 44 ++++++++++++++++++++++++++------------------
 fs/f2fs/node.h |  5 +++--
 4 files changed, 32 insertions(+), 21 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index b5cd6d1..6b89b25 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -863,7 +863,8 @@ static int f2fs_write_data_pages(struct address_space *mapping,
 		return 0;
 
 	if (S_ISDIR(inode->i_mode) && wbc->sync_mode == WB_SYNC_NONE &&
-			get_dirty_dents(inode) < nr_pages_to_skip(sbi, DATA))
+			get_dirty_dents(inode) < nr_pages_to_skip(sbi, DATA) &&
+			available_free_memory(sbi, DIRTY_DENTS))
 		goto skip_write;
 
 	diff = nr_pages_to_write(sbi, DATA, wbc);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 556d06b..97da71d 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1143,6 +1143,7 @@ f2fs_hash_t f2fs_dentry_hash(const char *, size_t);
 struct dnode_of_data;
 struct node_info;
 
+bool available_free_memory(struct f2fs_sb_info *, int);
 int is_checkpointed_node(struct f2fs_sb_info *, nid_t);
 bool fsync_mark_done(struct f2fs_sb_info *, nid_t);
 void get_node_info(struct f2fs_sb_info *, nid_t, struct node_info *);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 64755f4..2803ef6 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -26,20 +26,26 @@
 static struct kmem_cache *nat_entry_slab;
 static struct kmem_cache *free_nid_slab;
 
-static inline bool available_free_memory(struct f2fs_nm_info *nm_i, int type)
+bool available_free_memory(struct f2fs_sb_info *sbi, int type)
 {
+	struct f2fs_nm_info *nm_i = NM_I(sbi);
 	struct sysinfo val;
 	unsigned long mem_size = 0;
+	bool res = false;
 
 	si_meminfo(&val);
-	if (type == FREE_NIDS)
-		mem_size = nm_i->fcnt * sizeof(struct free_nid);
-	else if (type == NAT_ENTRIES)
-		mem_size += nm_i->nat_cnt * sizeof(struct nat_entry);
-	mem_size >>= 12;
-
-	/* give 50:50 memory for free nids and nat caches respectively */
-	return (mem_size < ((val.totalram * nm_i->ram_thresh) >> 11));
+	/* give 25%, 25%, 50% memory for each components respectively */
+	if (type == FREE_NIDS) {
+		mem_size = (nm_i->fcnt * sizeof(struct free_nid)) >> 12;
+		res = mem_size < ((val.totalram * nm_i->ram_thresh / 100) >> 2);
+	} else if (type == NAT_ENTRIES) {
+		mem_size = (nm_i->nat_cnt * sizeof(struct nat_entry)) >> 12;
+		res = mem_size < ((val.totalram * nm_i->ram_thresh / 100) >> 2);
+	} else if (type == DIRTY_DENTS) {
+		mem_size = get_pages(sbi, F2FS_DIRTY_DENTS);
+		res = mem_size < ((val.totalram * nm_i->ram_thresh / 100) >> 1);
+	}
+	return res;
 }
 
 static void clear_node_page_dirty(struct page *page)
@@ -241,7 +247,7 @@ int try_to_free_nats(struct f2fs_sb_info *sbi, int nr_shrink)
 {
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 
-	if (available_free_memory(nm_i, NAT_ENTRIES))
+	if (available_free_memory(sbi, NAT_ENTRIES))
 		return 0;
 
 	write_lock(&nm_i->nat_tree_lock);
@@ -1310,13 +1316,14 @@ static void __del_from_free_nid_list(struct f2fs_nm_info *nm_i,
 	radix_tree_delete(&nm_i->free_nid_root, i->nid);
 }
 
-static int add_free_nid(struct f2fs_nm_info *nm_i, nid_t nid, bool build)
+static int add_free_nid(struct f2fs_sb_info *sbi, nid_t nid, bool build)
 {
+	struct f2fs_nm_info *nm_i = NM_I(sbi);
 	struct free_nid *i;
 	struct nat_entry *ne;
 	bool allocated = false;
 
-	if (!available_free_memory(nm_i, FREE_NIDS))
+	if (!available_free_memory(sbi, FREE_NIDS))
 		return -1;
 
 	/* 0 nid should not be used */
@@ -1369,9 +1376,10 @@ static void remove_free_nid(struct f2fs_nm_info *nm_i, nid_t nid)
 		kmem_cache_free(free_nid_slab, i);
 }
 
-static void scan_nat_page(struct f2fs_nm_info *nm_i,
+static void scan_nat_page(struct f2fs_sb_info *sbi,
 			struct page *nat_page, nid_t start_nid)
 {
+	struct f2fs_nm_info *nm_i = NM_I(sbi);
 	struct f2fs_nat_block *nat_blk = page_address(nat_page);
 	block_t blk_addr;
 	int i;
@@ -1386,7 +1394,7 @@ static void scan_nat_page(struct f2fs_nm_info *nm_i,
 		blk_addr = le32_to_cpu(nat_blk->entries[i].block_addr);
 		f2fs_bug_on(blk_addr == NEW_ADDR);
 		if (blk_addr == NULL_ADDR) {
-			if (add_free_nid(nm_i, start_nid, true) < 0)
+			if (add_free_nid(sbi, start_nid, true) < 0)
 				break;
 		}
 	}
@@ -1410,7 +1418,7 @@ static void build_free_nids(struct f2fs_sb_info *sbi)
 	while (1) {
 		struct page *page = get_current_nat_page(sbi, nid);
 
-		scan_nat_page(nm_i, page, nid);
+		scan_nat_page(sbi, page, nid);
 		f2fs_put_page(page, 1);
 
 		nid += (NAT_ENTRY_PER_BLOCK - (nid % NAT_ENTRY_PER_BLOCK));
@@ -1430,7 +1438,7 @@ static void build_free_nids(struct f2fs_sb_info *sbi)
 		block_t addr = le32_to_cpu(nat_in_journal(sum, i).block_addr);
 		nid = le32_to_cpu(nid_in_journal(sum, i));
 		if (addr == NULL_ADDR)
-			add_free_nid(nm_i, nid, true);
+			add_free_nid(sbi, nid, true);
 		else
 			remove_free_nid(nm_i, nid);
 	}
@@ -1507,7 +1515,7 @@ void alloc_nid_failed(struct f2fs_sb_info *sbi, nid_t nid)
 	spin_lock(&nm_i->free_nid_list_lock);
 	i = __lookup_free_nid_list(nm_i, nid);
 	f2fs_bug_on(!i || i->state != NID_ALLOC);
-	if (!available_free_memory(nm_i, FREE_NIDS)) {
+	if (!available_free_memory(sbi, FREE_NIDS)) {
 		__del_from_free_nid_list(nm_i, i);
 		need_free = true;
 	} else {
@@ -1835,7 +1843,7 @@ flush_now:
 		}
 
 		if (nat_get_blkaddr(ne) == NULL_ADDR &&
-				add_free_nid(NM_I(sbi), nid, false) <= 0) {
+				add_free_nid(sbi, nid, false) <= 0) {
 			write_lock(&nm_i->nat_tree_lock);
 			__del_from_nat_cache(nm_i, ne);
 			write_unlock(&nm_i->nat_tree_lock);
diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index 41bb65b..a076c88 100644
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -83,9 +83,10 @@ static inline void raw_nat_from_node_info(struct f2fs_nat_entry *raw_ne,
 	raw_ne->version = ni->version;
 }
 
-enum nid_type {
+enum mem_type {
 	FREE_NIDS,	/* indicates the free nid list */
-	NAT_ENTRIES	/* indicates the cached nat entry */
+	NAT_ENTRIES,	/* indicates the cached nat entry */
+	DIRTY_DENTS	/* indicates dirty dentry pages */
 };
 
 /*
-- 
1.8.4.474.g128a96c

