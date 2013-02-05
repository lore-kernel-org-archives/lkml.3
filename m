Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab3BEQYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:24:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57461 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785Ab3BEQYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:24:15 -0500
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Tejun Heo <htejun@gmail.com>
Subject: [PATCH 3/3] memcg: cleanup mem_cgroup_init comment
Date: Tue,  5 Feb 2013 17:24:01 +0100
Message-Id: <1360081441-1960-4-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360081441-1960-1-git-send-email-mhocko@suse.cz>
References: <1360081441-1960-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should encourage all memcg controller initialization independent on
a specific mem_cgroup to be done here rather than exploit css_alloc
callback and assume that nothing happens before root cgroup is created.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e9c1690..b97008c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7007,10 +7007,12 @@ static void __init enable_swap_cgroup(void)
 #endif
 
 /*
- * The rest of init is performed during ->css_alloc() for root css which
- * happens before initcalls.  hotcpu_notifier() can't be done together as
- * it would introduce circular locking by adding cgroup_lock -> cpu hotplug
- * dependency.  Do it from a subsys_initcall().
+ * subsys_initcall() for memory controller.
+ *
+ * Some parts like hotcpu_notifier() have to be initialized from this context
+ * because of lock dependencies (cgroup_lock -> cpu hotplug) but basically
+ * everything that doesn't depend on a specific mem_cgroup structure should
+ * be initialized from here.
  */
 static int __init mem_cgroup_init(void)
 {
-- 
1.7.10.4

