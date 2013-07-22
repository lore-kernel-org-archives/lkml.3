Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab3GVIkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 04:40:10 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:63826 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819Ab3GVIgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 04:36:40 -0400
X-AuditID: 9c93016f-b7b50ae0000021a9-d4-51ecef15348f
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 06/10] mm, hugetlb: remove redundant list_empty check in gather_surplus_pages()
Date: Mon, 22 Jul 2013 17:36:27 +0900
Message-Id: <1374482191-3500-7-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374482191-3500-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1374482191-3500-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If list is empty, list_for_each_entry_safe() doesn't do anything.
So, this check is redundant. Remove it.

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 3ac0a6f..7ca8733 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1017,11 +1017,8 @@ free:
 	spin_unlock(&hugetlb_lock);
 
 	/* Free unnecessary surplus pages to the buddy allocator */
-	if (!list_empty(&surplus_list)) {
-		list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
-			put_page(page);
-		}
-	}
+	list_for_each_entry_safe(page, tmp, &surplus_list, lru)
+		put_page(page);
 	spin_lock(&hugetlb_lock);
 
 	return ret;
-- 
1.7.9.5

