Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655AbaDHTC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 15:02:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757448AbaDHTC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 15:02:57 -0400
From: Luiz Capitulino <lcapitulino@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, mtosatti@redhat.com, aarcange@redhat.com,
        mgorman@suse.de, akpm@linux-foundation.org, andi@firstfloor.org,
        davidlohr@hp.com, rientjes@google.com, isimatu.yasuaki@jp.fujitsu.com,
        yinghai@kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com
Subject: [PATCH 1/5] hugetlb: prep_compound_gigantic_page(): drop __init marker
Date: Tue,  8 Apr 2014 15:02:16 -0400
Message-Id: <1396983740-26047-2-git-send-email-lcapitulino@redhat.com>
In-Reply-To: <1396983740-26047-1-git-send-email-lcapitulino@redhat.com>
References: <1396983740-26047-1-git-send-email-lcapitulino@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is going to be used by non-init code in a future
commit.

Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
---
 mm/hugetlb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 7c02b9d..319db28 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -689,8 +689,7 @@ static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
 	put_page(page); /* free it into the hugepage allocator */
 }
 
-static void __init prep_compound_gigantic_page(struct page *page,
-					       unsigned long order)
+static void prep_compound_gigantic_page(struct page *page, unsigned long order)
 {
 	int i;
 	int nr_pages = 1 << order;
-- 
1.8.1.4

