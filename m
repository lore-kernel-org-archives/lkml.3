Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbaCMPHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:07:06 -0400
Received: from relay.parallels.com ([195.214.232.42]:56647 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbaCMPG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:06:58 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <glommer@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@openvz.org>
Subject: [PATCH RESEND -mm 04/12] memcg: move slab caches list/mutex init to memcg creation
Date: Thu, 13 Mar 2014 19:06:42 +0400
Message-ID: <0da16031316cf06d622e891f4afc8740c478d674.1394708827.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1394708827.git.vdavydov@parallels.com>
References: <cover.1394708827.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I need them initialized for cgroups that haven't got kmem accounting
initialized.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@gmail.com>
---
 mm/memcontrol.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 21974ec406bb..3659d90d5a40 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5043,8 +5043,6 @@ static int __memcg_activate_kmem(struct mem_cgroup *memcg,
 		goto out_rmid;
 
 	memcg->kmemcg_id = memcg_id;
-	INIT_LIST_HEAD(&memcg->memcg_slab_caches);
-	mutex_init(&memcg->slab_caches_mutex);
 
 	/*
 	 * We couldn't have accounted to this cgroup, because it hasn't got the
@@ -5791,6 +5789,9 @@ static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
 	int ret;
 
 	memcg->kmemcg_id = -1;
+	INIT_LIST_HEAD(&memcg->memcg_slab_caches);
+	mutex_init(&memcg->slab_caches_mutex);
+
 	ret = memcg_propagate_kmem(memcg);
 	if (ret)
 		return ret;
-- 
1.7.10.4

