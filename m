Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbaKNSew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:34:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964931AbaKNSev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:34:51 -0500
From: Rafael Aquini <aquini@redhat.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <jweiner@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: do not overwrite reserved pages counter at show_mem()
Date: Fri, 14 Nov 2014 13:34:29 -0500
Message-Id: <e34cbf786f7c16d4330889825aa5b13141cc085c.1415989668.git.aquini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor fixlet to perform the reserved pages counter aggregation
for each node, at show_mem()

Signed-off-by: Rafael Aquini <aquini@redhat.com>
---
 lib/show_mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/show_mem.c b/lib/show_mem.c
index 0922579..5e25627 100644
--- a/lib/show_mem.c
+++ b/lib/show_mem.c
@@ -28,7 +28,7 @@ void show_mem(unsigned int filter)
 				continue;
 
 			total += zone->present_pages;
-			reserved = zone->present_pages - zone->managed_pages;
+			reserved += zone->present_pages - zone->managed_pages;
 
 			if (is_highmem_idx(zoneid))
 				highmem += zone->present_pages;
-- 
1.9.3

