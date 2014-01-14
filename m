Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbaANBvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 20:51:25 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:36382 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbaANBvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 20:51:23 -0500
Date: Mon, 13 Jan 2014 17:50:49 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Michal Hocko <mhocko@suse.cz>
cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] mm/memcg: fix last_dead_count memory wastage
Message-ID: <alpine.LSU.2.11.1401131742370.2229@eggly.anvils>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shorten mem_cgroup_reclaim_iter.last_dead_count from unsigned long to
int: it's assigned from an int and compared with an int, and adjacent
to an unsigned int: so there's no point to it being unsigned long,
which wasted 104 bytes in every mem_cgroup_per_zone.
    
Signed-off-by: Hugh Dickins <hughd@google.com>
---
Putting this one first as it should be nicely uncontroversial.
I'm assuming much too late for v3.13, so all 3 diffed against mmotm.

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm/mm/memcontrol.c	2014-01-10 18:25:02.236448954 -0800
+++ linux/mm/memcontrol.c	2014-01-12 22:21:10.700570471 -0800
@@ -149,7 +149,7 @@ struct mem_cgroup_reclaim_iter {
 	 * matches memcg->dead_count of the hierarchy root group.
 	 */
 	struct mem_cgroup *last_visited;
-	unsigned long last_dead_count;
+	int last_dead_count;
 
 	/* scan generation, increased every round-trip */
 	unsigned int generation;
