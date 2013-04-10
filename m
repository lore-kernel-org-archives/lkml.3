Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965025Ab3DJUap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 16:30:45 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:50651 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935800Ab3DJUan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 16:30:43 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] mm: Simplify for_each_populated_zone()
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 11 Apr 2013 01:57:33 +0530
Message-ID: <20130410202727.20368.29222.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 13041020-9264-0000-0000-0000037DE805
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the if/else block to make it more readable.

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/mmzone.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ede2749..2489042 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -948,9 +948,7 @@ extern struct zone *next_zone(struct zone *zone);
 	for (zone = (first_online_pgdat())->node_zones; \
 	     zone;					\
 	     zone = next_zone(zone))			\
-		if (!populated_zone(zone))		\
-			; /* do nothing */		\
-		else
+		if (populated_zone(zone))
 
 static inline struct zone *zonelist_zone(struct zoneref *zoneref)
 {

