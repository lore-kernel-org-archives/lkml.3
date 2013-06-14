Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661Ab3FNCnD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:43:03 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33730 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932452Ab3FNCnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:43:00 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 32/33] mm: Convert use of typedef ctl_table to struct ctl_table
Date: Thu, 13 Jun 2013 19:37:57 -0700
Message-Id: <6fb5d1179e36d791b82400a791e280b9720d559b.1371177118.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 mm/page-writeback.c |  2 +-
 mm/page_alloc.c     | 15 ++++++++-------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 4514ad7..82d1b74 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1546,7 +1546,7 @@ void throttle_vm_writeout(gfp_t gfp_mask)
 /*
  * sysctl handler for /proc/sys/vm/dirty_writeback_centisecs
  */
-int dirty_writeback_centisecs_handler(ctl_table *table, int write,
+int dirty_writeback_centisecs_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	proc_dointvec(table, write, buffer, length, ppos);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 18102e1..c0afdb7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3244,7 +3244,7 @@ early_param("numa_zonelist_order", setup_numa_zonelist_order);
 /*
  * sysctl handler for numa_zonelist_order
  */
-int numa_zonelist_order_handler(ctl_table *table, int write,
+int numa_zonelist_order_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *length,
 		loff_t *ppos)
 {
@@ -5591,8 +5591,9 @@ module_init(init_per_zone_wmark_min)
  *	that we can call two helper functions whenever min_free_kbytes
  *	changes.
  */
-int min_free_kbytes_sysctl_handler(ctl_table *table, int write, 
-	void __user *buffer, size_t *length, loff_t *ppos)
+int min_free_kbytes_sysctl_handler(struct ctl_table *table, int write,
+				   void __user *buffer,
+				   size_t *length, loff_t *ppos)
 {
 	proc_dointvec(table, write, buffer, length, ppos);
 	if (write)
@@ -5601,7 +5602,7 @@ int min_free_kbytes_sysctl_handler(ctl_table *table, int write,
 }
 
 #ifdef CONFIG_NUMA
-int sysctl_min_unmapped_ratio_sysctl_handler(ctl_table *table, int write,
+int sysctl_min_unmapped_ratio_sysctl_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	struct zone *zone;
@@ -5617,7 +5618,7 @@ int sysctl_min_unmapped_ratio_sysctl_handler(ctl_table *table, int write,
 	return 0;
 }
 
-int sysctl_min_slab_ratio_sysctl_handler(ctl_table *table, int write,
+int sysctl_min_slab_ratio_sysctl_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	struct zone *zone;
@@ -5643,7 +5644,7 @@ int sysctl_min_slab_ratio_sysctl_handler(ctl_table *table, int write,
  * minimum watermarks. The lowmem reserve ratio can only make sense
  * if in function of the boot time zone sizes.
  */
-int lowmem_reserve_ratio_sysctl_handler(ctl_table *table, int write,
+int lowmem_reserve_ratio_sysctl_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	proc_dointvec_minmax(table, write, buffer, length, ppos);
@@ -5656,7 +5657,7 @@ int lowmem_reserve_ratio_sysctl_handler(ctl_table *table, int write,
  * cpu.  It is the fraction of total pages in each zone that a hot per cpu pagelist
  * can have before it gets flushed back to buddy allocator.
  */
-int percpu_pagelist_fraction_sysctl_handler(ctl_table *table, int write,
+int percpu_pagelist_fraction_sysctl_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	struct zone *zone;
-- 
1.8.1.2.459.gbcd45b4.dirty

