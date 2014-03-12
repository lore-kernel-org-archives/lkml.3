Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbaCLB3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 21:29:04 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:33949 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756487AbaCLB27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 21:28:59 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 5/8] memcg: remove unnecessary !mm check from try_get_mem_cgroup_from_mm()
Date: Tue, 11 Mar 2014 21:28:31 -0400
Message-Id: <1394587714-6966-6-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
References: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users pass either a mm that has been established under task lock, or
use a verified current->mm, which means the task can't be exiting.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c40186cf22ad..1780e66ec61e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1075,13 +1075,6 @@ struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
 {
 	struct mem_cgroup *memcg = NULL;
 
-	if (!mm)
-		return NULL;
-	/*
-	 * Because we have no locks, mm->owner's may be being moved to other
-	 * cgroup. We use css_tryget() here even if this looks
-	 * pessimistic (rather than adding locks here).
-	 */
 	rcu_read_lock();
 	do {
 		memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
-- 
1.9.0

