Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaLEW0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:26:10 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:57266 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaLEW0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:26:08 -0500
Message-ID: <5482316D.607@gmail.com>
Date: Sat, 06 Dec 2014 06:27:57 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: hannes@cmpxchg.org, mhocko@suse.cz
CC: cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: [PATCH] mm: memcontrol: Skip test_mem_cgroup_node_reclaimable() when
 no MAX_NUMNODES or not more than 1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

test_mem_cgroup_node_reclaimable() is only used when "MAX_NUMNODES > 1",
so move it into related quote.

The related warning (with allmodconfig under parisc):

    CC      mm/memcontrol.o
  mm/memcontrol.c:1629:13: warning: 'test_mem_cgroup_node_reclaimable' defined but not used [-Wunused-function]
   static bool test_mem_cgroup_node_reclaimable(struct mem_cgroup *memcg,
               ^

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c6ac50e..d538b08 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1616,6 +1616,7 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			 NULL, "Memory cgroup out of memory");
 }
 
+#if MAX_NUMNODES > 1
 /**
  * test_mem_cgroup_node_reclaimable
  * @memcg: the target memcg
@@ -1638,7 +1639,6 @@ static bool test_mem_cgroup_node_reclaimable(struct mem_cgroup *memcg,
 	return false;
 
 }
-#if MAX_NUMNODES > 1
 
 /*
  * Always updating the nodemask is not very good - even if we have an empty
-- 
1.9.3
