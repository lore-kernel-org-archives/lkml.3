Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbaDNB4y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 21:56:54 -0400
Received: from smtprelay0187.hostedemail.com ([216.40.44.187]:48242 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754576AbaDNB4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 21:56:50 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:966:968:973:988:989:1260:1345:1359:1437:1534:1543:1711:1730:1747:1777:1792:2196:2198:2199:2200:2393:2559:2562:3138:3139:3140:3141:3142:3354:3865:3866:3867:3868:3870:3871:3872:3874:4321:4385:5007:6261:8660:10004:10026:10848:11026:11658:11914:12043:12296:12438:12517:12519:12555:13148:13230:13255,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fish12_588a431896103
X-Filterd-Recvd-Size: 4041
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH -next 3.16 18/19] mm: Convert use of typedef ctl_table to struct ctl_table
Date: Sun, 13 Apr 2014 18:55:50 -0700
Message-Id: <ea251e288bc8a4882a55fe5a1ad1f7a09abd5be0.1397438826.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1397438826.git.joe@perches.com>
References: <cover.1397438826.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 mm/page-writeback.c |  2 +-
 mm/page_alloc.c     | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index ef41349..023cf08 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1682,7 +1682,7 @@ void throttle_vm_writeout(gfp_t gfp_mask)
 /*
  * sysctl handler for /proc/sys/vm/dirty_writeback_centisecs
  */
-int dirty_writeback_centisecs_handler(ctl_table *table, int write,
+int dirty_writeback_centisecs_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	proc_dointvec(table, write, buffer, length, ppos);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5dba293..0128d50 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3351,7 +3351,7 @@ early_param("numa_zonelist_order", setup_numa_zonelist_order);
 /*
  * sysctl handler for numa_zonelist_order
  */
-int numa_zonelist_order_handler(ctl_table *table, int write,
+int numa_zonelist_order_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *length,
 		loff_t *ppos)
 {
@@ -5774,7 +5774,7 @@ module_init(init_per_zone_wmark_min)
  *	that we can call two helper functions whenever min_free_kbytes
  *	changes.
  */
-int min_free_kbytes_sysctl_handler(ctl_table *table, int write,
+int min_free_kbytes_sysctl_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	int rc;
@@ -5791,7 +5791,7 @@ int min_free_kbytes_sysctl_handler(ctl_table *table, int write,
 }
 
 #ifdef CONFIG_NUMA
-int sysctl_min_unmapped_ratio_sysctl_handler(ctl_table *table, int write,
+int sysctl_min_unmapped_ratio_sysctl_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	struct zone *zone;
@@ -5807,7 +5807,7 @@ int sysctl_min_unmapped_ratio_sysctl_handler(ctl_table *table, int write,
 	return 0;
 }
 
-int sysctl_min_slab_ratio_sysctl_handler(ctl_table *table, int write,
+int sysctl_min_slab_ratio_sysctl_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	struct zone *zone;
@@ -5833,7 +5833,7 @@ int sysctl_min_slab_ratio_sysctl_handler(ctl_table *table, int write,
  * minimum watermarks. The lowmem reserve ratio can only make sense
  * if in function of the boot time zone sizes.
  */
-int lowmem_reserve_ratio_sysctl_handler(ctl_table *table, int write,
+int lowmem_reserve_ratio_sysctl_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	proc_dointvec_minmax(table, write, buffer, length, ppos);
@@ -5846,7 +5846,7 @@ int lowmem_reserve_ratio_sysctl_handler(ctl_table *table, int write,
  * cpu.  It is the fraction of total pages in each zone that a hot per cpu
  * pagelist can have before it gets flushed back to buddy allocator.
  */
-int percpu_pagelist_fraction_sysctl_handler(ctl_table *table, int write,
+int percpu_pagelist_fraction_sysctl_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	struct zone *zone;
-- 
1.8.1.2.459.gbcd45b4.dirty

