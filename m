Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab3LJJ2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:28:44 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:48574 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab3LJJTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:19:55 -0500
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v4 07/12] sched/numa: fix set cpupid on page migration twice against normal page
Date: Tue, 10 Dec 2013 17:19:30 +0800
Message-Id: <1386667175-19952-7-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1386667175-19952-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386667175-19952-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121009-1396-0000-0000-000003FFE2FD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 7851a45cd3 (mm: numa: Copy cpupid on page migration) copy over
the cpupid at page migration time, there is unnecessary to set it again
in function alloc_misplaced_dst_page, this patch fix it.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/migrate.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index b1b6663..508cde4 100644
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
1.7.7.6

