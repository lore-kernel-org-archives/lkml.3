Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab3GXKCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 06:02:13 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:57044 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab3GXKCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 06:02:11 -0400
Message-ID: <51EFA5F5.3020406@huawei.com>
Date: Wed, 24 Jul 2013 18:01:25 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: [PATCH v2 4/8] memcg: convert to use cgroup_is_descendant()
References: <51EFA554.6080801@huawei.com>
In-Reply-To: <51EFA554.6080801@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparation to kill css_id.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d12ca6f..626c426 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1434,7 +1434,7 @@ bool __mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
 		return true;
 	if (!root_memcg->use_hierarchy || !memcg)
 		return false;
-	return css_is_ancestor(&memcg->css, &root_memcg->css);
+	return cgroup_is_descendant(memcg->css.cgroup, root_memcg->css.cgroup);
 }
 
 static bool mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
-- 
1.8.0.2

