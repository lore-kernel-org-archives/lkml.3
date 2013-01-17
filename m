Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab3AQWyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 17:54:18 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:33601 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab3AQWyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 17:54:12 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>, David Hansen <dave@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 1/9] mm: add SECTION_IN_PAGE_FLAGS
Date: Thu, 17 Jan 2013 14:52:53 -0800
Message-Id: <1358463181-17956-2-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <1358463181-17956-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1358463181-17956-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011722-2398-0000-0000-0000102DD8C9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of directly utilizing a combination of config options to determine this,
add a macro to specifically address it.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/mm.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 66e2f7c..ef69564 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -625,6 +625,10 @@ static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
 #define NODE_NOT_IN_PAGE_FLAGS
 #endif
 
+#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+#define SECTION_IN_PAGE_FLAGS
+#endif
+
 /*
  * Define the bit shifts to access each section.  For non-existent
  * sections we define the shift as 0; that plus a 0 mask ensures
@@ -727,7 +731,7 @@ static inline struct zone *page_zone(const struct page *page)
 	return &NODE_DATA(page_to_nid(page))->node_zones[page_zonenum(page)];
 }
 
-#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+#ifdef SECTION_IN_PAGE_FLAGS
 static inline void set_page_section(struct page *page, unsigned long section)
 {
 	page->flags &= ~(SECTIONS_MASK << SECTIONS_PGSHIFT);
@@ -757,7 +761,7 @@ static inline void set_page_links(struct page *page, enum zone_type zone,
 {
 	set_page_zone(page, zone);
 	set_page_node(page, node);
-#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+#ifdef SECTION_IN_PAGE_FLAGS
 	set_page_section(page, pfn_to_section_nr(pfn));
 #endif
 }
-- 
1.8.0.3

