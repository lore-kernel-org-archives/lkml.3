Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbbAJCON (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 21:14:13 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:56957 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708AbbAJCOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 21:14:11 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 1/3] mm: memcontrol: remove unnecessary soft limit tree node test
Date: Fri,  9 Jan 2015 21:13:59 -0500
Message-Id: <1420856041-27647-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.2.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc_node() automatically falls back to nodes with suitable memory.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index fd9e542fc26f..aad254b30708 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4520,13 +4520,10 @@ static void __init mem_cgroup_soft_limit_tree_init(void)
 {
 	struct mem_cgroup_tree_per_node *rtpn;
 	struct mem_cgroup_tree_per_zone *rtpz;
-	int tmp, node, zone;
+	int node, zone;
 
 	for_each_node(node) {
-		tmp = node;
-		if (!node_state(node, N_NORMAL_MEMORY))
-			tmp = -1;
-		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, tmp);
+		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, node);
 		BUG_ON(!rtpn);
 
 		soft_limit_tree.rb_tree_per_node[node] = rtpn;
-- 
2.2.0

