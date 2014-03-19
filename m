Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635AbaCSIG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 04:06:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:31916 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbaCSIEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 04:04:08 -0400
X-AuditID: cbfee68e-b7f566d000002344-c9-53294f6d655b
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/5] f2fs: throttle the memory footprint with a sysfs entry
Date: Wed, 19 Mar 2014 17:02:06 +0900
Message-id: <1395216129-13656-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1395216129-13656-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1395216129-13656-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t8zQ91cf81ggxmHBSyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyjj0+h9rwWTrivMn
	drA2MP7R72Lk5JAQMJG4fOo2M4QtJnHh3nq2LkYuDiGBZYwSTbd/sMEUzTo/gxEiMZ1RovlI
	K5TTySSxcNpNoHYODjYBbYnN+w1AGkQEmCUWTD0PVsMsMIFR4v+i9ywgCWEBb4k1e1eygtgs
	AqoSb+f+ZQSxeQXcJU492w91hrbEtucTweKcAh4Sh25eAIsLAdU8fXuFBWSohMB3Nokbq99A
	DRKQ+Db5EAvIERICshKbDkDNkZQ4uOIGywRG4QWMDKsYRVMLkguKk9KLjPSKE3OLS/PS9ZLz
	czcxQoK2bwfjzQPWhxiTgcZNZJYSTc4HBn1eSbyhsZmRhamJqbGRuaUZacJK4ryLHiYFCQmk
	J5akZqemFqQWxReV5qQWH2Jk4uCUamBUtjxrf27T3UuaH5ZZXd/7qGie6AnGqM5AqX2b5pX/
	ETjAoBiZYFCYUpC0t1OT3a4+KrBvko2+c630xMNlfU9fvX31vUVonVamzYz4by7RN1nNG1kl
	Wq+823b6opQJz7dCw+7CB4mPeRdkLjh6bue6gM/vnR4qCHl/+HIySDaS9VgXt8+d4CglluKM
	REMt5qLiRACZGMCXcAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jQd1cf81gg945PBbXd/1lsri0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesb
	EgTXY2SABhLWMWYcev2PtWCydcX5EztYGxj/6HcxcnJICJhIzDo/gxHCFpO4cG89WxcjF4eQ
	wHRGieYjrYwQTieTxMJpN5m7GDk42AS0JTbvNwBpEBFgllgw9TxYDbPABEaJ/4ves4AkhAW8
	JdbsXckKYrMIqEq8nfsXbAOvgLvEqWf7mSG2aUtsez4RLM4p4CFx6OYFsLgQUM3Tt1dYJjDy
	LmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHBPPpHYwrmywOMQowMGoxMN7IEojWIg1
	say4MvcQowQHs5IIr/BdoBBvSmJlVWpRfnxRaU5q8SHGZKCrJjJLiSbnA+M1ryTe0NjEzMjS
	yMzCyMTcnDRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoYnf7a9N6dPmFxsM1qw5Lwn2fi
	T0wxFVcsr9gwgcXgWNC1Y4XMls8V5VYp7fir/e/uEa2w+pq95zdN/MQs5vNAosLuS4H8zL1m
	Pp//cs7kX7BqE9fh4Kyb91m0v8ntz5sReqIj5aXXQ82/k7/PbZwyYUVV4T1D/1l/cw5/4bXy
	ur3kRtEcJfcpFUosxRmJhlrMRcWJAJr0qnzNAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces ram_thresh, a sysfs entry, which controls the memory
footprint used by the free nid list and the nat cache.

Previously, the free nid list was controlled by MAX_FREE_NIDS, while the nat
cache was managed by NM_WOUT_THRESHOLD.
However, this approach cannot be applied dynamically according to the system.

So, this patch adds ram_thresh that users can specify the threshold, which is
in order of 1 / 1024.
For example, if the total ram size is 4GB and the value is set to 10 by default,
f2fs tries to control the number of free nids and nat caches not to consume over
10 * (4GB / 1024) = 10MB.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 Documentation/ABI/testing/sysfs-fs-f2fs |  6 ++++++
 Documentation/filesystems/f2fs.txt      |  4 ++++
 fs/f2fs/f2fs.h                          |  1 +
 fs/f2fs/node.c                          | 23 ++++++++++++++++++++---
 fs/f2fs/node.h                          | 11 ++++++++---
 fs/f2fs/super.c                         |  5 +++++
 6 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-fs-f2fs b/Documentation/ABI/testing/sysfs-fs-f2fs
index 32b0809..4ac2c25 100644
--- a/Documentation/ABI/testing/sysfs-fs-f2fs
+++ b/Documentation/ABI/testing/sysfs-fs-f2fs
@@ -55,3 +55,9 @@ Date:		January 2014
 Contact:	"Jaegeuk Kim" <jaegeuk.kim@samsung.com>
 Description:
 		 Controls the number of trials to find a victim segment.
+
+What:		/sys/fs/f2fs/<disk>/ram_thresh
+Date:		March 2014
+Contact:	"Jaegeuk Kim" <jaegeuk.kim@samsung.com>
+Description:
+		 Controls the memory footprint used by f2fs.
diff --git a/Documentation/filesystems/f2fs.txt b/Documentation/filesystems/f2fs.txt
index 803784e..f415b9f 100644
--- a/Documentation/filesystems/f2fs.txt
+++ b/Documentation/filesystems/f2fs.txt
@@ -202,6 +202,10 @@ Files in /sys/fs/f2fs/<devname>
 			      Otherwise, it needs to decrease this value to
 			      reduce the space overhead. The default value is 0.
 
+ ram_thresh                   This parameter controls the memory footprint used
+			      by free nids and cached nat entries. By default,
+			      10 is set, which indicates 10 MB / 1 GB RAM.
+
 ================================================================================
 USAGE
 ================================================================================
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 59fac1a..05c6524 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -242,6 +242,7 @@ struct f2fs_nm_info {
 	block_t nat_blkaddr;		/* base disk address of NAT */
 	nid_t max_nid;			/* maximum possible node ids */
 	nid_t next_scan_nid;		/* the next nid to be scanned */
+	unsigned int ram_thresh;	/* control the memory footprint */
 
 	/* NAT cache management */
 	struct radix_tree_root nat_root;/* root of the nat entry cache */
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 04450a5..9cf524d 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -26,6 +26,22 @@
 static struct kmem_cache *nat_entry_slab;
 static struct kmem_cache *free_nid_slab;
 
+static inline bool available_free_memory(struct f2fs_nm_info *nm_i, int type)
+{
+	struct sysinfo val;
+	unsigned long mem_size = 0;
+
+	si_meminfo(&val);
+	if (type == FREE_NIDS)
+		mem_size = nm_i->fcnt * sizeof(struct free_nid);
+	else if (type == NAT_ENTRIES)
+		mem_size += nm_i->nat_cnt * sizeof(struct nat_entry);
+	mem_size >>= 12;
+
+	/* give 50:50 memory for free nids and nat caches respectively */
+	return (mem_size < ((val.totalram * nm_i->ram_thresh) >> 11));
+}
+
 static void clear_node_page_dirty(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
@@ -208,7 +224,7 @@ int try_to_free_nats(struct f2fs_sb_info *sbi, int nr_shrink)
 {
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 
-	if (nm_i->nat_cnt <= NM_WOUT_THRESHOLD || nr_shrink <= 0)
+	if (available_free_memory(nm_i, NAT_ENTRIES) || nr_shrink <= 0)
 		return 0;
 
 	write_lock(&nm_i->nat_tree_lock);
@@ -1286,7 +1302,7 @@ static int add_free_nid(struct f2fs_nm_info *nm_i, nid_t nid, bool build)
 	struct nat_entry *ne;
 	bool allocated = false;
 
-	if (nm_i->fcnt > 2 * MAX_FREE_NIDS)
+	if (!available_free_memory(nm_i, FREE_NIDS))
 		return -1;
 
 	/* 0 nid should not be used */
@@ -1471,7 +1487,7 @@ void alloc_nid_failed(struct f2fs_sb_info *sbi, nid_t nid)
 	spin_lock(&nm_i->free_nid_list_lock);
 	i = __lookup_free_nid_list(nm_i, nid);
 	f2fs_bug_on(!i || i->state != NID_ALLOC);
-	if (nm_i->fcnt > 2 * MAX_FREE_NIDS) {
+	if (!available_free_memory(nm_i, FREE_NIDS)) {
 		__del_from_free_nid_list(nm_i, i);
 	} else {
 		i->state = NID_NEW;
@@ -1834,6 +1850,7 @@ static int init_node_manager(struct f2fs_sb_info *sbi)
 	nm_i->max_nid = NAT_ENTRY_PER_BLOCK * nat_blocks - 3;
 	nm_i->fcnt = 0;
 	nm_i->nat_cnt = 0;
+	nm_i->ram_thresh = DEF_RAM_THRESHOLD;
 
 	INIT_RADIX_TREE(&nm_i->free_nid_root, GFP_ATOMIC);
 	INIT_LIST_HEAD(&nm_i->free_nid_list);
diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index ee6d286..c972154 100644
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -17,15 +17,15 @@
 /* # of pages to perform readahead before building free nids */
 #define FREE_NID_PAGES 4
 
-/* maximum # of free node ids to produce during build_free_nids */
-#define MAX_FREE_NIDS (NAT_ENTRY_PER_BLOCK * FREE_NID_PAGES)
-
 /* maximum readahead size for node during getting data blocks */
 #define MAX_RA_NODE		128
 
 /* maximum cached nat entries to manage memory footprint */
 #define NM_WOUT_THRESHOLD	(64 * NAT_ENTRY_PER_BLOCK)
 
+/* control the memory footprint threshold (10MB per 1GB ram) */
+#define DEF_RAM_THRESHOLD	10
+
 /* vector size for gang look-up from nat cache that consists of radix tree */
 #define NATVEC_SIZE	64
 
@@ -77,6 +77,11 @@ static inline void node_info_from_raw_nat(struct node_info *ni,
 	ni->version = raw_ne->version;
 }
 
+enum nid_type {
+	FREE_NIDS,	/* indicates the free nid list */
+	NAT_ENTRIES	/* indicates the cached nat entry */
+};
+
 /*
  * For free nid mangement
  */
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index dbe402b..34c47b2 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -74,6 +74,7 @@ static match_table_t f2fs_tokens = {
 enum {
 	GC_THREAD,	/* struct f2fs_gc_thread */
 	SM_INFO,	/* struct f2fs_sm_info */
+	NM_INFO,	/* struct f2fs_nm_info */
 	F2FS_SBI,	/* struct f2fs_sb_info */
 };
 
@@ -92,6 +93,8 @@ static unsigned char *__struct_ptr(struct f2fs_sb_info *sbi, int struct_type)
 		return (unsigned char *)sbi->gc_thread;
 	else if (struct_type == SM_INFO)
 		return (unsigned char *)SM_I(sbi);
+	else if (struct_type == NM_INFO)
+		return (unsigned char *)NM_I(sbi);
 	else if (struct_type == F2FS_SBI)
 		return (unsigned char *)sbi;
 	return NULL;
@@ -183,6 +186,7 @@ F2FS_RW_ATTR(SM_INFO, f2fs_sm_info, reclaim_segments, rec_prefree_segments);
 F2FS_RW_ATTR(SM_INFO, f2fs_sm_info, max_small_discards, max_discards);
 F2FS_RW_ATTR(SM_INFO, f2fs_sm_info, ipu_policy, ipu_policy);
 F2FS_RW_ATTR(SM_INFO, f2fs_sm_info, min_ipu_util, min_ipu_util);
+F2FS_RW_ATTR(NM_INFO, f2fs_nm_info, ram_thresh, ram_thresh);
 F2FS_RW_ATTR(F2FS_SBI, f2fs_sb_info, max_victim_search, max_victim_search);
 F2FS_RW_ATTR(F2FS_SBI, f2fs_sb_info, dir_level, dir_level);
 
@@ -198,6 +202,7 @@ static struct attribute *f2fs_attrs[] = {
 	ATTR_LIST(min_ipu_util),
 	ATTR_LIST(max_victim_search),
 	ATTR_LIST(dir_level),
+	ATTR_LIST(ram_thresh),
 	NULL,
 };
 
-- 
1.8.4.474.g128a96c

