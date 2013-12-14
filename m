Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab3LNIPt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 03:15:49 -0500
Received: from relay.parallels.com ([195.214.232.42]:36208 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab3LNIPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 03:15:47 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <mhocko@suse.cz>
CC: <glommer@gmail.com>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <linux-mm@kvack.org>, <devel@openvz.org>,
        "Glauber Costa" <glommer@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Balbir Singh" <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 1/2] memcg: fix memcg_size() calculation
Date: Sat, 14 Dec 2013 12:15:33 +0400
Message-ID: <965cbb70fb55fe50a77382537b9a1b7455deac86.1387007793.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.24.25.125]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mem_cgroup structure contains nr_node_ids pointers to
mem_cgroup_per_node objects, not the objects themselves.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bf5e894..7f1a356 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -338,7 +338,7 @@ struct mem_cgroup {
 static size_t memcg_size(void)
 {
 	return sizeof(struct mem_cgroup) +
-		nr_node_ids * sizeof(struct mem_cgroup_per_node);
+		nr_node_ids * sizeof(struct mem_cgroup_per_node *);
 }
 
 /* internal only representation about the status of kmem accounting. */
-- 
1.7.10.4

