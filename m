Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaKBDOd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 23:14:33 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:58041 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbaKBDOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 23:14:30 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch] mm: memcontrol: remove stale page_cgroup_lock comment
Date: Sat,  1 Nov 2014 23:14:20 -0400
Message-Id: <1414898060-4658-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no cgroup-specific page lock anymore.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 38f0647a2f12..d20928597a07 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2467,10 +2467,6 @@ static void commit_charge(struct page *page, struct mem_cgroup *memcg,
 	int isolated;
 
 	VM_BUG_ON_PAGE(pc->mem_cgroup, page);
-	/*
-	 * we don't need page_cgroup_lock about tail pages, becase they are not
-	 * accessed by any other context at this point.
-	 */
 
 	/*
 	 * In some cases, SwapCache and FUSE(splice_buf->radixtree), the page
-- 
2.1.3

