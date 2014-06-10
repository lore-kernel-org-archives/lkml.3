Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbaFJTzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:55:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35723 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbaFJTy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:54:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Michal Hocko <mhocko@suse.cz>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 043/160] mm/hugetlb.c: add cond_resched_lock() in return_unused_surplus_pages()
Date: Tue, 10 Jun 2014 12:44:43 -0700
Message-Id: <1402429600-20477-44-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Mizuma, Masayoshi" <m.mizuma@jp.fujitsu.com>

commit 7848a4bf51b34f41fcc9bd77e837126d99ae84e3 upstream.

soft lockup in freeing gigantic hugepage fixed in commit 55f67141a892 "mm:
hugetlb: fix softlockup when a large number of hugepages are freed." can
happen in return_unused_surplus_pages(), so let's fix it.

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/hugetlb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index aad231c..c8c4a03 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1143,6 +1143,7 @@ static void return_unused_surplus_pages(struct hstate *h,
 	while (nr_pages--) {
 		if (!free_pool_huge_page(h, &node_states[N_MEMORY], 1))
 			break;
+		cond_resched_lock(&hugetlb_lock);
 	}
 }
 
-- 
1.9.1

