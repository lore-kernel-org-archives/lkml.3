Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255Ab3APAZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:25:55 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59906 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758181Ab3APAZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 19:25:53 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 10/17] mm/vmstat: use zone_end_pfn() instead of opencoding
Date: Tue, 15 Jan 2013 16:24:47 -0800
Message-Id: <1358295894-24167-11-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011600-7182-0000-0000-000004762EF8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In vmstat, use zone_end_pfn() instead of an opencoded version.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/vmstat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 9800306..ca99641 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -890,7 +890,7 @@ static void pagetypeinfo_showblockcount_print(struct seq_file *m,
 	int mtype;
 	unsigned long pfn;
 	unsigned long start_pfn = zone->zone_start_pfn;
-	unsigned long end_pfn = start_pfn + zone->spanned_pages;
+	unsigned long end_pfn = zone_end_pfn(zone);
 	unsigned long count[MIGRATE_TYPES] = { 0, };
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
-- 
1.8.0.3

