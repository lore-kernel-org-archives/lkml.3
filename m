Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750941Ab3CJFFZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 00:05:25 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:48199 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab3CJFFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 00:05:24 -0500
MIME-Version: 1.0
Date: Sun, 10 Mar 2013 13:05:23 +0800
Message-ID: <CAJd=RBDPPpqhHh3CJAwkC4J=tukDLErwf6juS+x3irvu3PHdbA@mail.gmail.com>
Subject: [PATCH] vmscan: minor cleanup for kswapd
From: Hillf Danton <dhillf@gmail.com>
To: Linux-MM <linux-mm@kvack.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The local variable, total_scanned, is no longer used, so clean up now.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/vmscan.c	Thu Feb 21 20:01:02 2013
+++ b/mm/vmscan.c	Sun Mar 10 12:52:10 2013
@@ -2619,7 +2619,6 @@ static unsigned long balance_pgdat(pg_da
 	bool pgdat_is_balanced = false;
 	int i;
 	int end_zone = 0;	/* Inclusive.  0 = ZONE_DMA */
-	unsigned long total_scanned;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	unsigned long nr_soft_reclaimed;
 	unsigned long nr_soft_scanned;
@@ -2639,7 +2638,6 @@ static unsigned long balance_pgdat(pg_da
 		.gfp_mask = sc.gfp_mask,
 	};
 loop_again:
-	total_scanned = 0;
 	sc.priority = DEF_PRIORITY;
 	sc.nr_reclaimed = 0;
 	sc.may_writepage = !laptop_mode;
@@ -2730,7 +2728,6 @@ loop_again:
 							order, sc.gfp_mask,
 							&nr_soft_scanned);
 			sc.nr_reclaimed += nr_soft_reclaimed;
-			total_scanned += nr_soft_scanned;

 			/*
 			 * We put equal pressure on every zone, unless
@@ -2765,7 +2762,6 @@ loop_again:
 				reclaim_state->reclaimed_slab = 0;
 				nr_slab = shrink_slab(&shrink, sc.nr_scanned, lru_pages);
 				sc.nr_reclaimed += reclaim_state->reclaimed_slab;
-				total_scanned += sc.nr_scanned;

 				if (nr_slab == 0 && !zone_reclaimable(zone))
 					zone->all_unreclaimable = 1;
--
