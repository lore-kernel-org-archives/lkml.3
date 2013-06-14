Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572Ab3FNB51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 21:57:27 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:49445 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759431Ab3FNB5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 21:57:23 -0400
Message-ID: <51BA77A6.70404@huawei.com>
Date: Fri, 14 Jun 2013 09:53:42 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, Glauber Costa <glommer@openvz.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, Michal Hocko <mhocko@suse.cz>
Subject: [PATCH v4 1/9] Revert "memcg: avoid dangling reference count in creation
 failure."
References: <51BA7794.2000305@huawei.com>
In-Reply-To: <51BA7794.2000305@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Hocko <mhocko@suse.cz>

This reverts commit e4715f01be697a3730c78f8ffffb595591d6a88c

mem_cgroup_put is hierarchy aware so mem_cgroup_put(memcg) already drops
an additional reference from all parents so the additional
mem_cgrroup_put(parent) potentially causes use-after-free.

Cc: <stable@vger.kernel.org> # 3.9+
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2e851f4..0bacc0d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6332,8 +6332,6 @@ mem_cgroup_css_online(struct cgroup *cont)
 		 * call __mem_cgroup_free, so return directly
 		 */
 		mem_cgroup_put(memcg);
-		if (parent->use_hierarchy)
-			mem_cgroup_put(parent);
 	}
 	return error;
 }
-- 
1.8.0.2
