Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab3GYByJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 21:54:09 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:18460 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab3GYByH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 21:54:07 -0400
Message-ID: <51F08505.6050402@huawei.com>
Date: Thu, 25 Jul 2013 09:53:09 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Cgroups <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH] memcg: remove redundant code in mem_cgroup_force_empty_write()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vfs guarantees the cgroup won't be destroyed, so it's redundant
to get a css reference.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 mm/memcontrol.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 03c8bf7..aa3e478 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5015,15 +5015,10 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 static int mem_cgroup_force_empty_write(struct cgroup *cont, unsigned int event)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
-	int ret;
 
 	if (mem_cgroup_is_root(memcg))
 		return -EINVAL;
-	css_get(&memcg->css);
-	ret = mem_cgroup_force_empty(memcg);
-	css_put(&memcg->css);
-
-	return ret;
+	return mem_cgroup_force_empty(memcg);
 }
 
 
-- 
1.8.0.2
