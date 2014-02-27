Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbaB0Ej6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 23:39:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbaB0Ej5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 23:39:57 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] mm: call vma_adjust_trans_huge() only for thp-enabled vma
Date: Wed, 26 Feb 2014 23:39:37 -0500
Message-Id: <1393475977-3381-4-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1393475977-3381-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1393475977-3381-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vma_adjust() is called also for vma(VM_HUGETLB) and it could happen that
we happen to try to split hugetlbfs hugepage. So exclude the possibility.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 mm/mmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git next-20140220.orig/mm/mmap.c next-20140220/mm/mmap.c
index f53397806d7f..45a9c0d51e3f 100644
--- next-20140220.orig/mm/mmap.c
+++ next-20140220/mm/mmap.c
@@ -772,7 +772,8 @@ again:			remove_next = 1 + (end > next->vm_end);
 		}
 	}
 
-	vma_adjust_trans_huge(vma, start, end, adjust_next);
+	if (transparent_hugepage_enabled(vma))
+		vma_adjust_trans_huge(vma, start, end, adjust_next);
 
 	anon_vma = vma->anon_vma;
 	if (!anon_vma && adjust_next)
-- 
1.8.5.3

