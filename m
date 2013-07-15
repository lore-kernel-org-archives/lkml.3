Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab3GOKIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 06:08:09 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:57535 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab3GOKII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 06:08:08 -0400
X-AuditID: 9c93017e-b7b62ae000000eeb-e1-51e3c671df7d
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
Subject: [PATCH 5/9] mm, hugetlb: remove redundant list_empty check in gather_surplus_pages()
Date: Mon, 15 Jul 2013 18:52:43 +0900
Message-Id: <1373881967-16153-6-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373881967-16153-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1373881967-16153-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If list is empty, list_for_each_entry_safe() doesn't do anything.
So, this check is redundant. Remove it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a838e6b..d4a1695 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1019,10 +1019,8 @@ free:
 	spin_unlock(&hugetlb_lock);
 
 	/* Free unnecessary surplus pages to the buddy allocator */
-	if (!list_empty(&surplus_list)) {
-		list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
-			put_page(page);
-		}
+	list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
+		put_page(page);
 	}
 	spin_lock(&hugetlb_lock);
 
-- 
1.7.9.5

