Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaFJRhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 13:37:36 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:46172 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751921AbaFJRhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 13:37:34 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsQNAFNBl1NbskA7/2dsb2JhbABZgw2sFAEBBpkSgQgXdYRgI4EaN4hGAcxKF4VWiHMdhCsEj12GPYQKiyiIHYM+Ow
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] MM/PAGE_ALLOC add __meminit to alloc_pages_exact_nid
Date: Tue, 10 Jun 2014 19:36:14 +0200
Message-Id: <1402421774-4044-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_pages_exact_nid is only called by
__meminit alloc_page_cgroup

Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 include/linux/gfp.h | 2 +-
 mm/page_alloc.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 6eb1fb3..5e7219d 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -360,7 +360,7 @@ extern unsigned long get_zeroed_page(gfp_t gfp_mask);
 void *alloc_pages_exact(size_t size, gfp_t gfp_mask);
 void free_pages_exact(void *virt, size_t size);
 /* This is different from alloc_pages_exact_node !!! */
-void *alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask);
+void * __meminit alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask);
 
 #define __get_free_page(gfp_mask) \
 		__get_free_pages((gfp_mask), 0)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4f59fa2..530837e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2949,7 +2949,7 @@ EXPORT_SYMBOL(alloc_pages_exact);
  * Note this is not alloc_pages_exact_node() which allocates on a specific node,
  * but is not exact.
  */
-void *alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask)
+void * __meminit alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask)
 {
 	unsigned order = get_order(size);
 	struct page *p = alloc_pages_node(nid, gfp_mask, order);
-- 
1.8.4.5

