Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422972Ab3CVUZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 16:25:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422943Ab3CVUZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 16:25:20 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 08/10] migrate: remove VM_HUGETLB from vma flag check in vma_migratable()
Date: Fri, 22 Mar 2013 16:23:53 -0400
Message-Id: <1363983835-20184-9-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1363983835-20184-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1363983835-20184-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables hugepage migration from migrate_pages(2),
move_pages(2), and mbind(2).

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 include/linux/mempolicy.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git v3.9-rc3.orig/include/linux/mempolicy.h v3.9-rc3/include/linux/mempolicy.h
index 0d7df39..2e475b5 100644
--- v3.9-rc3.orig/include/linux/mempolicy.h
+++ v3.9-rc3/include/linux/mempolicy.h
@@ -173,7 +173,7 @@ extern int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol);
 /* Check if a vma is migratable */
 static inline int vma_migratable(struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & (VM_IO | VM_HUGETLB | VM_PFNMAP))
+	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
 		return 0;
 	/*
 	 * Migration allocates pages in the highest zone. If we cannot
-- 
1.7.11.7

