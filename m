Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbaKEKX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:23:26 -0500
Received: from mx2.parallels.com ([199.115.105.18]:54992 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbaKEKXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:23:23 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm] memcg: __mem_cgroup_free: remove stale disarm_static_keys comment
Date: Wed, 5 Nov 2014 13:23:14 +0300
Message-ID: <1415182994-2866-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuset code stopped using cgroup_lock in favor of cpuset_mutex long ago.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/memcontrol.c |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9a37d99aee54..95ee47c0f0a2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4610,17 +4610,6 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
 
 	free_percpu(memcg->stat);
 
-	/*
-	 * We need to make sure that (at least for now), the jump label
-	 * destruction code runs outside of the cgroup lock. This is because
-	 * get_online_cpus(), which is called from the static_branch update,
-	 * can't be called inside the cgroup_lock. cpusets are the ones
-	 * enforcing this dependency, so if they ever change, we might as well.
-	 *
-	 * schedule_work() will guarantee this happens. Be careful if you need
-	 * to move this code around, and make sure it is outside
-	 * the cgroup_lock.
-	 */
 	disarm_static_keys(memcg);
 	kfree(memcg);
 }
-- 
1.7.10.4

