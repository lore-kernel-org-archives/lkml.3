Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbaGNNVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:21:05 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:33880 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018AbaGNNVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:21:02 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch 1/3] mm: vmscan: rework compaction-ready signaling in direct reclaim fix
Date: Mon, 14 Jul 2014 09:20:47 -0400
Message-Id: <1405344049-19868-2-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1405344049-19868-1-git-send-email-hannes@cmpxchg.org>
References: <1405344049-19868-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per Mel, replace out label with breaks from the loop.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/vmscan.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35747a75bf08..6f43df4a5253 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2496,10 +2496,10 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 
 		total_scanned += sc->nr_scanned;
 		if (sc->nr_reclaimed >= sc->nr_to_reclaim)
-			goto out;
+			break;
 
 		if (sc->compaction_ready)
-			goto out;
+			break;
 
 		/*
 		 * If we're getting trouble reclaiming, start doing
@@ -2523,7 +2523,6 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 		}
 	} while (--sc->priority >= 0);
 
-out:
 	delayacct_freepages_end();
 
 	if (sc->nr_reclaimed)
-- 
2.0.0

