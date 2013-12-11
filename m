Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab3LKKQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 05:16:28 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:48957 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab3LKKQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 05:16:23 -0500
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Peter Zijlstra <peterz@infradead.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v6 4/6] sched/numa: fix set cpupid on page migration twice against normal page
Date: Wed, 11 Dec 2013 18:15:59 +0800
Message-Id: <1386756961-3887-5-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1386756961-3887-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386756961-3887-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121110-1396-0000-0000-00000401341F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 7851a45cd3 (mm: numa: Copy cpupid on page migration) copy over
the cpupid at page migration time, there is unnecessary to set it again
in function alloc_misplaced_dst_page, this patch fix it.

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/migrate.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index fdb70f7..d4228c6 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1557,8 +1557,6 @@ static struct page *alloc_misplaced_dst_page(struct page *page,
 					  __GFP_NOMEMALLOC | __GFP_NORETRY |
 					  __GFP_NOWARN) &
 					 ~GFP_IOFS, 0);
-	if (newpage)
-		page_cpupid_xchg_last(newpage, page_cpupid_last(page));
 
 	return newpage;
 }
-- 
1.7.5.4

