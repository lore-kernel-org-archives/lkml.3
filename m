Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484Ab3EGUtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 16:49:33 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:47814 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760Ab3EGUtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 16:49:32 -0400
From: j.glisse@gmail.com
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH 1/3] mm: honor FOLL_GET flag in follow_hugetlb_page
Date: Tue,  7 May 2013 16:45:54 -0400
Message-Id: <1367959554-3218-1-git-send-email-j.glisse@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jerome Glisse <jglisse@redhat.com>

Do not increase page count if FOLL_GET is not set.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 mm/hugetlb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1a12f5b..5d1e46b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2991,7 +2991,9 @@ long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 same_page:
 		if (pages) {
 			pages[i] = mem_map_offset(page, pfn_offset);
-			get_page(pages[i]);
+			if (flags & FOLL_GET) {
+				get_page_foll(pages[i]);
+			}
 		}
 
 		if (vmas)
-- 
1.8.2.1

