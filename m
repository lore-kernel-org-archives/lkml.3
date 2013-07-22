Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab3GVIlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 04:41:00 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:63826 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777Ab3GVIgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 04:36:39 -0400
X-AuditID: 9c93016f-b7b50ae0000021a9-c9-51ecef135f04
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
Subject: [PATCH v2 02/10] mm, hugetlb: remove err label in dequeue_huge_page_vma()
Date: Mon, 22 Jul 2013 17:36:23 +0900
Message-Id: <1374482191-3500-3-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374482191-3500-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1374482191-3500-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This label is not needed now, because there is no error handling
except returing NULL.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index fc4988c..d87f70b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -546,11 +546,11 @@ static struct page *dequeue_huge_page_vma(struct hstate *h,
 	 */
 	if (!vma_has_reserves(vma) &&
 			h->free_huge_pages - h->resv_huge_pages == 0)
-		goto err;
+		return NULL;
 
 	/* If reserves cannot be used, ensure enough pages are in the pool */
 	if (avoid_reserve && h->free_huge_pages - h->resv_huge_pages == 0)
-		goto err;
+		return NULL;
 
 retry_cpuset:
 	cpuset_mems_cookie = get_mems_allowed();
@@ -573,9 +573,6 @@ retry_cpuset:
 	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
 		goto retry_cpuset;
 	return page;
-
-err:
-	return NULL;
 }
 
 static void update_and_free_page(struct hstate *h, struct page *page)
-- 
1.7.9.5

