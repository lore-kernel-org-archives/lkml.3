Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab3LMOKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:10:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40439 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502Ab3LMOKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:10:17 -0500
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 7/7] mm: page_alloc: Default allow file pages to use remote nodes for fair allocation policy
Date: Fri, 13 Dec 2013 14:10:07 +0000
Message-Id: <1386943807-29601-8-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386943807-29601-1-git-send-email-mgorman@suse.de>
References: <1386943807-29601-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Indications from Johannes that he wanted this. Needs some data and/or justification why
thrash protection needs it plus docs describing how MPOL_LOCAL is now different before
it should be considered finished. I do not necessarily agree this patch is necessary
but it's worth punting it out there for discussion and testing.

Not signed off
---
 mm/page_alloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bf49918..bce40c0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1885,7 +1885,8 @@ unsigned __bitwise__ zone_distribute_mode __read_mostly;
 #define DISTRIBUTE_STUPID_ANON	(DISTRIBUTE_LOCAL_ANON|DISTRIBUTE_REMOTE_ANON)
 #define DISTRIBUTE_STUPID_FILE	(DISTRIBUTE_LOCAL_FILE|DISTRIBUTE_REMOTE_FILE)
 #define DISTRIBUTE_STUPID_SLAB	(DISTRIBUTE_LOCAL_SLAB|DISTRIBUTE_REMOTE_SLAB)
-#define DISTRIBUTE_DEFAULT	(DISTRIBUTE_LOCAL_ANON|DISTRIBUTE_LOCAL_FILE|DISTRIBUTE_LOCAL_SLAB)
+#define DISTRIBUTE_DEFAULT	(DISTRIBUTE_LOCAL_ANON|DISTRIBUTE_LOCAL_FILE|DISTRIBUTE_LOCAL_SLAB| \
+				 DISTRIBUTE_REMOTE_FILE)
 
 /* Only these GFP flags are affected by the fair zone allocation policy */
 #define DISTRIBUTE_GFP_MASK	((GFP_MOVABLE_MASK|__GFP_PAGECACHE))
-- 
1.8.4

