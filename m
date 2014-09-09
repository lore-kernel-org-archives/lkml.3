Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbaIIOwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:52:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753668AbaIIOwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:52:31 -0400
Date: Tue, 9 Sep 2014 15:52:28 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linuxfoundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: page_alloc: Make paranoid check in move_freepages a
 VM_BUG_ON
Message-ID: <20140909145228.GB12309@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 2.6.24 there has been a paranoid check in move_freepages that looks
up the zone of two pages. This is a very slow path and the only time I've
seen this bug trigger recently is when memory initialisation was broken
during patch development. Despite the fact it's a slow path, this patch
converts the check to a VM_BUG_ON anyway as it is served its purpose by now.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0a7ed33..6fbd814 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1014,7 +1014,7 @@ int move_freepages(struct zone *zone,
 	 * Remove at a later date when no bug reports exist related to
 	 * grouping pages by mobility
 	 */
-	BUG_ON(page_zone(start_page) != page_zone(end_page));
+	VM_BUG_ON(page_zone(start_page) != page_zone(end_page));
 #endif
 
 	for (page = start_page; page <= end_page;) {
