Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab3LJPxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:53:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923Ab3LJPvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:51:46 -0500
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Thorlton <athorlton@sgi.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 13/18] mm: numa: Make NUMA-migrate related functions static
Date: Tue, 10 Dec 2013 15:51:31 +0000
Message-Id: <1386690695-27380-14-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386690695-27380-1-git-send-email-mgorman@suse.de>
References: <1386690695-27380-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

numamigrate_update_ratelimit and numamigrate_isolate_page only have callers
in mm/migrate.c. This patch makes them static.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
---
 mm/migrate.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 0c4fbf6..b6eef65 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1593,7 +1593,8 @@ bool migrate_ratelimited(int node)
 }
 
 /* Returns true if the node is migrate rate-limited after the update */
-bool numamigrate_update_ratelimit(pg_data_t *pgdat, unsigned long nr_pages)
+static bool numamigrate_update_ratelimit(pg_data_t *pgdat,
+					unsigned long nr_pages)
 {
 	bool rate_limited = false;
 
@@ -1617,7 +1618,7 @@ bool numamigrate_update_ratelimit(pg_data_t *pgdat, unsigned long nr_pages)
 	return rate_limited;
 }
 
-int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
+static int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
 {
 	int page_lru;
 
-- 
1.8.4

