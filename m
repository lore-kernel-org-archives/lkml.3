Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab3KORs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 12:48:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab3KORsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 12:48:20 -0500
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
Subject: [PATCH 2/3] mm: hugetlb: use get_page_foll in follow_hugetlb_page
Date: Fri, 15 Nov 2013 18:47:47 +0100
Message-Id: <1384537668-10283-3-git-send-email-aarcange@redhat.com>
In-Reply-To: <1384537668-10283-1-git-send-email-aarcange@redhat.com>
References: <1384537668-10283-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_page_foll is more optimal and is always safe to use under the PT
lock. More so for hugetlbfs as there's no risk of race conditions with
split_huge_page regardless of the PT lock.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 mm/hugetlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 14737f8e..f03e068 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3113,7 +3113,7 @@ long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 same_page:
 		if (pages) {
 			pages[i] = mem_map_offset(page, pfn_offset);
-			get_page(pages[i]);
+			get_page_foll(pages[i]);
 		}
 
 		if (vmas)
