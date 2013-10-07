Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab3JGQYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:24:12 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:38278 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab3JGQYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:24:10 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: [PATCH] mm: trivial: fix typos
Date: Mon,  7 Oct 2013 11:23:49 -0500
Message-Id: <1381163029-8808-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100716-1344-0000-0000-0000023BEDC0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix comment typos in swapfile.c

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 mm/swapfile.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 3963fc2..7968c1b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -707,7 +707,7 @@ noswap:
 	return (swp_entry_t) {0};
 }
 
-/* The only caller of this function is now susupend routine */
+/* The only caller of this function is now suspend routine */
 swp_entry_t get_swap_page_of_type(int type)
 {
 	struct swap_info_struct *si;
@@ -845,7 +845,7 @@ static unsigned char swap_entry_free(struct swap_info_struct *p,
 }
 
 /*
- * Caller has made sure that the swapdevice corresponding to entry
+ * Caller has made sure that the swap device corresponding to entry
  * is still around or has not been recycled.
  */
 void swap_free(swp_entry_t entry)
@@ -947,7 +947,7 @@ int try_to_free_swap(struct page *page)
 	 * original page might be freed under memory pressure, then
 	 * later read back in from swap, now with the wrong data.
 	 *
-	 * Hibration suspends storage while it is writing the image
+	 * Hibernation suspends storage while it is writing the image
 	 * to disk so check that here.
 	 */
 	if (pm_suspended_storage())
@@ -1179,7 +1179,7 @@ static int unuse_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 	 * some architectures (e.g. x86_32 with PAE) we might catch a glimpse
 	 * of unmatched parts which look like swp_pte, so unuse_pte must
 	 * recheck under pte lock.  Scanning without pte lock lets it be
-	 * preemptible whenever CONFIG_PREEMPT but not CONFIG_HIGHPTE.
+	 * preemptable whenever CONFIG_PREEMPT but not CONFIG_HIGHPTE.
 	 */
 	pte = pte_offset_map(pmd, addr);
 	do {
@@ -1932,7 +1932,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	vfree(swap_map);
 	vfree(cluster_info);
 	vfree(frontswap_map);
-	/* Destroy swap account informatin */
+	/* Destroy swap account information */
 	swap_cgroup_swapoff(type);
 
 	inode = mapping->host;
@@ -2784,8 +2784,8 @@ int add_swap_count_continuation(swp_entry_t entry, gfp_t gfp_mask)
 
 	/*
 	 * We are fortunate that although vmalloc_to_page uses pte_offset_map,
-	 * no architecture is using highmem pages for kernel pagetables: so it
-	 * will not corrupt the GFP_ATOMIC caller's atomic pagetable kmaps.
+	 * no architecture is using highmem pages for kernel page tables: so it
+	 * will not corrupt the GFP_ATOMIC caller's atomic page table kmaps.
 	 */
 	head = vmalloc_to_page(si->swap_map + offset);
 	offset &= ~PAGE_MASK;
-- 
1.8.4

