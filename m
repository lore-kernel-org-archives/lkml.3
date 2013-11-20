Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab3KTRwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 12:52:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab3KTRvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 12:51:50 -0500
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Khalid Aziz <khalid.aziz@oracle.com>,
        Pravin Shelar <pshelar@nicira.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Christoph Lameter <cl@linux.com>, Johannes Weiner <jweiner@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Minchan Kim <minchan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6/8] mm/hugetlb.c: simplify PageHeadHuge() and PageHuge()
Date: Wed, 20 Nov 2013 18:51:14 +0100
Message-Id: <1384969876-6374-7-git-send-email-aarcange@redhat.com>
In-Reply-To: <1384969876-6374-1-git-send-email-aarcange@redhat.com>
References: <1384969876-6374-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 mm/hugetlb.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f03e068..9b8a14b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -724,15 +724,11 @@ static void prep_compound_gigantic_page(struct page *page, unsigned long order)
  */
 int PageHuge(struct page *page)
 {
-	compound_page_dtor *dtor;
-
 	if (!PageCompound(page))
 		return 0;
 
 	page = compound_head(page);
-	dtor = get_compound_page_dtor(page);
-
-	return dtor == free_huge_page;
+	return get_compound_page_dtor(page) == free_huge_page;
 }
 EXPORT_SYMBOL_GPL(PageHuge);
 
@@ -742,14 +738,10 @@ EXPORT_SYMBOL_GPL(PageHuge);
  */
 int PageHeadHuge(struct page *page_head)
 {
-	compound_page_dtor *dtor;
-
 	if (!PageHead(page_head))
 		return 0;
 
-	dtor = get_compound_page_dtor(page_head);
-
-	return dtor == free_huge_page;
+	return get_compound_page_dtor(page_head) == free_huge_page;
 }
 EXPORT_SYMBOL_GPL(PageHeadHuge);
 
