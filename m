Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab3I3H67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 03:58:59 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44889 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab3I3H65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 03:58:57 -0400
X-AuditID: 9c93016f-b7bc8ae000004e6e-d2-52492f3e6bb3
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
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH] mm, hugetlb: correct missing private flag clearing
Date: Mon, 30 Sep 2013 16:59:44 +0900
Message-Id: <1380527985-18499-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should clear the page's private flag when returing the page to
the page allocator or the hugepage pool. This patch fixes it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
Hello, Andrew.

I sent the new version of commit ('07443a8') before you did pull request,
but it isn't included. It may be losted :)
So I send this fix. IMO, this is good for v3.12.

Thanks.

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b49579c..691f226 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -653,6 +653,7 @@ static void free_huge_page(struct page *page)
 	BUG_ON(page_count(page));
 	BUG_ON(page_mapcount(page));
 	restore_reserve = PagePrivate(page);
+	ClearPagePrivate(page);
 
 	spin_lock(&hugetlb_lock);
 	hugetlb_cgroup_uncharge_page(hstate_index(h),
-- 
1.7.9.5

