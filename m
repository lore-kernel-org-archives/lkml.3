Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762898Ab3DCIyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:54:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57050 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762511Ab3DCIyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:54:02 -0400
From: Michal Hocko <mhocko@suse.cz>
To: linux-mm@kvack.org
Cc: Li Zefan <lizefan@huawei.com>, Glauber Costa <glommer@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: [PATCH 1/2] Revert "memcg: avoid dangling reference count in creation failure."
Date: Wed,  3 Apr 2013 10:53:53 +0200
Message-Id: <1364979234-16427-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130403085056.GD14384@dhcp22.suse.cz>
References: <20130403085056.GD14384@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit e4715f01be697a3730c78f8ffffb595591d6a88c

mem_cgroup_put is hierarchy aware so mem_cgroup_put(memcg) already drops
an additional reference from all parents so the additional
mem_cgrroup_put(parent) potentially causes use-after-free.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f608546..6de6d70 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6424,8 +6424,6 @@ mem_cgroup_css_online(struct cgroup *cont)
 		 * call __mem_cgroup_free, so return directly
 		 */
 		mem_cgroup_put(memcg);
-		if (parent->use_hierarchy)
-			mem_cgroup_put(parent);
 	}
 	return error;
 }
-- 
1.7.10.4

