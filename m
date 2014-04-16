Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbaDPFPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 01:15:17 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:51536 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaDPFPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 01:15:13 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-ee-534e11e09f43
Message-id: <1397625191.7727.11.camel@kjgkr>
Subject: Re: [PATCH 3/3] f2fs: flush dirty directory pages when scattered pages
 are gathered
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Date: Wed, 16 Apr 2014 14:13:11 +0900
In-reply-to: <1397559423-27411-3-git-send-email-jaegeuk.kim@samsung.com>
References: <1397559423-27411-1-git-send-email-jaegeuk.kim@samsung.com>
 <1397559423-27411-3-git-send-email-jaegeuk.kim@samsung.com>
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t8zY90Hgn7BBlu2K1lcWuRusWfvSRaL
	y7vmsDkwe+xe8JnJ4/MmuQCmKC6blNSczLLUIn27BK6Mjln7WQoWmlZcWP2MrYHxsHYXIyeH
	hICJxMIFV5kgbDGJC/fWs3UxcnEICSxjlDhy9QsrTFFX7x1GiMR0Rom/L68yQzivGCUe/f7B
	CFLFK6AjcWr/OWYQW1ggTuLG9n/sXYwcHGwC2hKb9xuAhIUEFCXe7r/LChIWAbIvv3cCMZkF
	PCR2HSsFqWARUJVomj0fbC0nUHj5owcsEJtaGSUW3ZkOluAXEJU4vHA72CZmAXWJSfMWMUPc
	qSSxu72THSIuL7F5zVtmiMsEJX5Mvgc2SEJgE7vEnuN9bBDbBCS+TT7EAnKEhICsxKYDUHMk
	JQ6uuMEygVFiFpIVs5CMnYVk7AJG5lWMoqkFyQXFSelFhnrFibnFpXnpesn5uZsYIdHVu4Px
	9gHrQ4zJQCsnMkuJJucDozOvJN7Q2MzIwtTE1NjI3NKMNGElcd6kh0lBQgLpiSWp2ampBalF
	8UWlOanFhxiZODilGhjlNiml/FxcPPn9oft51nmHE45/q/j0jbVtx7egsiht/7yaVXtNDl6t
	4Y47/pLF08j5+vWDVyt+zg9uOt4Q+z/x7g3rAp9TZ1/uMbxwP2m2WDFn0sxMjiKVki3z4rz4
	f+kIbRe3+3p/jbfgwwlKahNO6/5SFG1nsL50P2N6+tnsb+26a5PDHl5UYinOSDTUYi4qTgQA
	9u/TYsQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+xoO4DQb9gg9U3ZC0uLXK32LP3JIvF
	5V1z2ByYPXYv+Mzk8XmTXABTVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmS
	Ql5ibqqtkotPgK5bZg7QDiWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1j
	Rses/SwFC00rLqx+xtbAeFi7i5GTQ0LARKKr9w4jhC0mceHeerYuRi4OIYHpjBJ/X15lhnBe
	MUo8+v0DrIpXQEfi1P5zzCC2sECcxI3t/9i7GDk42AS0JTbvNwAJCwkoSrzdf5cVJCwCZF9+
	7wRiMgt4SOw6VgpSwSKgKtE0ez4riM0JFF7+6AELxKZWRolFd6aDJfgFRCUOL9wOtolZQF1i
	0rxFzBB3Kknsbu9kh4jLS2xe85YZ4jJBiR+T77FMYBSahaRlFpKyWUjKFjAyr2IUTS1ILihO
	Ss810itOzC0uzUvXS87P3cQIjt1n0jsYVzVYHGIU4GBU4uGdmeMbLMSaWFZcmXuIUYKDWUmE
	98sXoBBvSmJlVWpRfnxRaU5q8SHGZKD3JjJLiSbnA9NKXkm8obGJmZGlkZmFkYm5OWnCSuK8
	B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwRt+XmhovbJ2pfb6RffqfnY3XAj6efXBItv9/sX2e
	8b1A6XAv+T8pwv9uHsvXX1TFuTa2PXhV671/U7TZ2+vm8F6J8b34ZuLkrQ7TYt7NMps+4abY
	yax32ZfPbmG17VcraIsXOPR+2ll5y9cL9ytsi760wHzigweSaUx265ffZpisqhdR/+TvRyWW
	4oxEQy3mouJEALY13tUhAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Please ignore this, since it turns out that is doesn't solve the
problem.
Instead, please consider the following patch.

>From ac9ad0b1de42dc311323b9c3b8f431f4b097b43b Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Date: Wed, 16 Apr 2014 10:47:06 +0900
Subject: [PATCH] f2fs: adjust free mem size to flush dentry blocks

If so many dirty dentry blocks are cached, not reached to the flush
condition,
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
@@ -863,7 +863,8 @@ static int f2fs_write_data_pages(struct
address_space *mapping,
 		return 0;
 
 	if (S_ISDIR(inode->i_mode) && wbc->sync_mode == WB_SYNC_NONE &&
-			get_dirty_dents(inode) < nr_pages_to_skip(sbi, DATA))
+			get_dirty_dents(inode) < nr_pages_to_skip(sbi, DATA) &&
+			available_free_memory(sbi, DIRTY_DENTS))
 		goto skip_write;
 
 	diff = nr_pages_to_write(sbi, DATA, wbc);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 2c5a5da..afca412 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1140,6 +1140,7 @@ f2fs_hash_t f2fs_dentry_hash(const char *,
size_t);
 struct dnode_of_data;
 struct node_info;
 
+bool available_free_memory(struct f2fs_sb_info *, int);
 int is_checkpointed_node(struct f2fs_sb_info *, nid_t);
 bool fsync_mark_done(struct f2fs_sb_info *, nid_t);
 void get_node_info(struct f2fs_sb_info *, nid_t, struct node_info *);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index f760793..d08671b 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -26,20 +26,26 @@
 static struct kmem_cache *nat_entry_slab;
 static struct kmem_cache *free_nid_slab;
 
-static inline bool available_free_memory(struct f2fs_nm_info *nm_i, int
type)
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
@@ -243,7 +249,7 @@ int try_to_free_nats(struct f2fs_sb_info *sbi, int
nr_shrink)
 {
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 
-	if (available_free_memory(nm_i, NAT_ENTRIES))
+	if (available_free_memory(sbi, NAT_ENTRIES))
 		return 0;
 
 	write_lock(&nm_i->nat_tree_lock);
@@ -1312,13 +1318,14 @@ static void __del_from_free_nid_list(struct
f2fs_nm_info *nm_i,
 	radix_tree_delete(&nm_i->free_nid_root, i->nid);
 }
 
-static int add_free_nid(struct f2fs_nm_info *nm_i, nid_t nid, bool
build)
+static int add_free_nid(struct f2fs_sb_info *sbi, nid_t nid, bool
build)
 {
+	struct f2fs_nm_info *nm_i = NM_I(sbi);
 	struct free_nid *i;
 	struct nat_entry *ne;
 	bool allocated = false;
 
-	if (!available_free_memory(nm_i, FREE_NIDS))
+	if (!available_free_memory(sbi, FREE_NIDS))
 		return -1;
 
 	/* 0 nid should not be used */
@@ -1371,9 +1378,10 @@ static void remove_free_nid(struct f2fs_nm_info
*nm_i, nid_t nid)
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
@@ -1388,7 +1396,7 @@ static void scan_nat_page(struct f2fs_nm_info
*nm_i,
 		blk_addr = le32_to_cpu(nat_blk->entries[i].block_addr);
 		f2fs_bug_on(blk_addr == NEW_ADDR);
 		if (blk_addr == NULL_ADDR) {
-			if (add_free_nid(nm_i, start_nid, true) < 0)
+			if (add_free_nid(sbi, start_nid, true) < 0)
 				break;
 		}
 	}
@@ -1412,7 +1420,7 @@ static void build_free_nids(struct f2fs_sb_info
*sbi)
 	while (1) {
 		struct page *page = get_current_nat_page(sbi, nid);
 
-		scan_nat_page(nm_i, page, nid);
+		scan_nat_page(sbi, page, nid);
 		f2fs_put_page(page, 1);
 
 		nid += (NAT_ENTRY_PER_BLOCK - (nid % NAT_ENTRY_PER_BLOCK));
@@ -1432,7 +1440,7 @@ static void build_free_nids(struct f2fs_sb_info
*sbi)
 		block_t addr = le32_to_cpu(nat_in_journal(sum, i).block_addr);
 		nid = le32_to_cpu(nid_in_journal(sum, i));
 		if (addr == NULL_ADDR)
-			add_free_nid(nm_i, nid, true);
+			add_free_nid(sbi, nid, true);
 		else
 			remove_free_nid(nm_i, nid);
 	}
@@ -1509,7 +1517,7 @@ void alloc_nid_failed(struct f2fs_sb_info *sbi,
nid_t nid)
 	spin_lock(&nm_i->free_nid_list_lock);
 	i = __lookup_free_nid_list(nm_i, nid);
 	f2fs_bug_on(!i || i->state != NID_ALLOC);
-	if (!available_free_memory(nm_i, FREE_NIDS)) {
+	if (!available_free_memory(sbi, FREE_NIDS)) {
 		__del_from_free_nid_list(nm_i, i);
 		need_free = true;
 	} else {
@@ -1840,7 +1848,7 @@ flush_now:
 		}
 
 		if (nat_get_blkaddr(ne) == NULL_ADDR &&
-				add_free_nid(NM_I(sbi), nid, false) <= 0) {
+				add_free_nid(sbi, nid, false) <= 0) {
 			write_lock(&nm_i->nat_tree_lock);
 			__del_from_nat_cache(nm_i, ne);
 			write_unlock(&nm_i->nat_tree_lock);
diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index 5decc1a..b517077 100644
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -75,9 +75,10 @@ static inline void node_info_from_raw_nat(struct
node_info *ni,
 	ni->version = raw_ne->version;
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


-- 
Jaegeuk Kim
Samsung

