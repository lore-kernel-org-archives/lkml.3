Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389Ab3IBLnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 07:43:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:11648 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063Ab3IBLnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 07:43:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1006,1367996400"; 
   d="scan'208";a="372213801"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ning Qu <quning@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH] mm: fix accounting on page_remove_rmap()
Date: Mon,  2 Sep 2013 14:43:11 +0300
Message-Id: <1378122191-15479-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's typo in page_remove_rmap(): we increase NR_ANON_PAGES counter
instead of decreasing it. Let's fix this.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Ning Qu <quning@google.com>
---
 mm/rmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 52cc59a..6219f07 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1156,7 +1156,7 @@ void page_remove_rmap(struct page *page)
 			__dec_zone_page_state(page,
 					      NR_ANON_TRANSPARENT_HUGEPAGES);
 		__mod_zone_page_state(page_zone(page), NR_ANON_PAGES,
-				hpage_nr_pages(page));
+				-hpage_nr_pages(page));
 	} else {
 		__dec_zone_page_state(page, NR_FILE_MAPPED);
 		mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_FILE_MAPPED);
-- 
1.8.4.rc3

