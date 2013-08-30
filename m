Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab3H3Dph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 23:45:37 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:22633 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab3H3Dpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 23:45:36 -0400
Message-ID: <52201539.8050003@huawei.com>
Date: Fri, 30 Aug 2013 11:44:57 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Li Zefan <lizefan@huawei.com>
CC: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        <tj@kernel.org>, <laijs@cn.fujitsu.com>, <cgroups@vger.kernel.org>,
        <containers@lists.linux-foundation.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] mm/cgroup: use N_MEMORY instead of N_HIGH_MEMORY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 8219fc48a(mm: node_states: introduce N_MEMORY),
we introduced N_MEMORY, now N_MEMORY stands for the nodes that has any memory,
and N_HIGH_MEMORY stands for the nodes that has normal or high memory.

The code here need to handle with the nodes which have memory,
we should use N_MEMORY instead.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 mm/page_cgroup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 6d757e3..f6f7603 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -116,7 +116,7 @@ static void *__meminit alloc_page_cgroup(size_t size, int nid)
 		return addr;
 	}
 
-	if (node_state(nid, N_HIGH_MEMORY))
+	if (node_state(nid, N_MEMORY))
 		addr = vzalloc_node(size, nid);
 	else
 		addr = vzalloc(size);
-- 
1.7.1


