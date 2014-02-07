Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaBGMI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:08:56 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:50818 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbaBGMIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:08:52 -0500
Date: Fri, 7 Feb 2014 17:38:47 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Ingo Molnar <mingo@kernel.org>, linux-mm@kvack.org,
        josh@joshtriplett.org
Subject: [PATCH 5/9] mm: Mark functions as static in migrate.c
Message-ID: <2f62d7bb34ad1797b2990524239d4de90f8073a4.1391167128.git.rashika.kheria@gmail.com>
References: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions as static in migrate.c because they are not used outside
this file.

This eliminates the following warnings in mm/migrate.c:
mm/migrate.c:1595:6: warning: no previous prototype for ‘numamigrate_update_ratelimit’ [-Wmissing-prototypes]
mm/migrate.c:1619:5: warning: no previous prototype for ‘numamigrate_isolate_page’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 mm/migrate.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index bb94004..c916e73 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1592,7 +1592,8 @@ bool migrate_ratelimited(int node)
 }
 
 /* Returns true if the node is migrate rate-limited after the update */
-bool numamigrate_update_ratelimit(pg_data_t *pgdat, unsigned long nr_pages)
+static bool numamigrate_update_ratelimit(pg_data_t *pgdat,
+					 unsigned long nr_pages)
 {
 	bool rate_limited = false;
 
@@ -1616,7 +1617,7 @@ bool numamigrate_update_ratelimit(pg_data_t *pgdat, unsigned long nr_pages)
 	return rate_limited;
 }
 
-int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
+static int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
 {
 	int page_lru;
 
-- 
1.7.9.5

