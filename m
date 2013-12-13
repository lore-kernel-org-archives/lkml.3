Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab3LMGvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 01:51:09 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:52563 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab3LMGuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 01:50:35 -0500
X-AuditID: 9c93017e-b7c17ae000003961-d9-52aaae3850da
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Rafael Aquini <aquini@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <js1304@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Vlastimil Babka <vbabka@suse.cz>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v3 6/6] mm/migrate: remove unused function, fail_migrate_page()
Date: Fri, 13 Dec 2013 15:53:31 +0900
Message-Id: <1386917611-11319-7-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386917611-11319-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1386917611-11319-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fail_migrate_page() isn't used anywhere, so remove it.

Acked-by: Christoph Lameter <cl@linux.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index e4671f9..4308018 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -41,9 +41,6 @@ extern int migrate_page(struct address_space *,
 extern int migrate_pages(struct list_head *l, new_page_t x,
 		unsigned long private, enum migrate_mode mode, int reason);
 
-extern int fail_migrate_page(struct address_space *,
-			struct page *, struct page *);
-
 extern int migrate_prep(void);
 extern int migrate_prep_local(void);
 extern int migrate_vmas(struct mm_struct *mm,
@@ -83,7 +80,6 @@ static inline int migrate_huge_page_move_mapping(struct address_space *mapping,
 
 /* Possible settings for the migrate_page() method in address_operations */
 #define migrate_page NULL
-#define fail_migrate_page NULL
 
 #endif /* CONFIG_MIGRATION */
 
diff --git a/mm/migrate.c b/mm/migrate.c
index fa73ee3..d538404 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -550,14 +550,6 @@ void migrate_page_copy(struct page *newpage, struct page *page)
  *                    Migration functions
  ***********************************************************/
 
-/* Always fail migration. Used for mappings that are not movable */
-int fail_migrate_page(struct address_space *mapping,
-			struct page *newpage, struct page *page)
-{
-	return -EIO;
-}
-EXPORT_SYMBOL(fail_migrate_page);
-
 /*
  * Common logic to directly migrate a single page suitable for
  * pages that do not use PagePrivate/PagePrivate2.
-- 
1.7.9.5

