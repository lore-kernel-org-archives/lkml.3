Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933456AbaBEANY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 19:13:24 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:47582 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164AbaBEANX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 19:13:23 -0500
Date: Tue, 4 Feb 2014 16:13:20 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Michal Hocko <mhocko@suse.cz>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch] mm, hugetlb: mark some bootstrap functions as __init
Message-ID: <alpine.DEB.2.02.1402041612120.14962@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both prep_compound_huge_page() and prep_compound_gigantic_page() are only
called at bootstrap and can be marked as __init.

The __SetPageTail(page) in prep_compound_gigantic_page() happening before
page->first_page is initialized is not concerning since this is
bootstrap.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/hugetlb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -653,7 +653,8 @@ static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
 	put_page(page); /* free it into the hugepage allocator */
 }
 
-static void prep_compound_gigantic_page(struct page *page, unsigned long order)
+static void __init prep_compound_gigantic_page(struct page *page,
+					       unsigned long order)
 {
 	int i;
 	int nr_pages = 1 << order;
@@ -1294,7 +1295,7 @@ found:
 	return 1;
 }
 
-static void prep_compound_huge_page(struct page *page, int order)
+static void __init prep_compound_huge_page(struct page *page, int order)
 {
 	if (unlikely(order > (MAX_ORDER - 1)))
 		prep_compound_gigantic_page(page, order);
