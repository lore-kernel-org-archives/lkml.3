Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab3LFJNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 04:13:44 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:42465 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab3LFJMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 04:12:34 -0500
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v2 1/6] sched/numa: fix set cpupid on page migration twice
Date: Fri,  6 Dec 2013 17:12:11 +0800
Message-Id: <1386321136-27538-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120609-5490-0000-0000-0000049C00A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 7851a45cd3 (mm: numa: Copy cpupid on page migration) copy over 
the cpupid at page migration time, there is unnecessary to set it again 
in migrate_misplaced_transhuge_page, this patch fix it.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/migrate.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index bb94004..fdb70f7 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1736,8 +1736,6 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 	if (!new_page)
 		goto out_fail;
 
-	page_cpupid_xchg_last(new_page, page_cpupid_last(page));
-
 	isolated = numamigrate_isolate_page(pgdat, page);
 	if (!isolated) {
 		put_page(new_page);
-- 
1.7.7.6

