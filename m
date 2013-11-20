Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab3KTRzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 12:55:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550Ab3KTRwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 12:52:01 -0500
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
Subject: [PATCH 8/8] mm/hugetlb.c: defer PageHeadHuge() symbol export
Date: Wed, 20 Nov 2013 18:51:16 +0100
Message-Id: <1384969876-6374-9-git-send-email-aarcange@redhat.com>
In-Reply-To: <1384969876-6374-1-git-send-email-aarcange@redhat.com>
References: <1384969876-6374-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No actual need of it. So keep it internal.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 mm/hugetlb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 9b8a14b..133ea72 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -743,7 +743,6 @@ int PageHeadHuge(struct page *page_head)
 
 	return get_compound_page_dtor(page_head) == free_huge_page;
 }
-EXPORT_SYMBOL_GPL(PageHeadHuge);
 
 pgoff_t __basepage_index(struct page *page)
 {
