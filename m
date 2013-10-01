Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998Ab3JALJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 07:09:19 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:43700 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab3JALJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 07:09:15 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the cgroup tree
Date: Tue,  1 Oct 2013 13:07:19 +0200
Message-Id: <1380625644-11331-3-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <20131001110344.GA20249@ulmo.nvidia.com>
References: <20131001110344.GA20249@ulmo.nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the cgroup tree got a conflict in:

	mm/memcontrol.c

I fixed it up (see below). Please check if the resolution looks correct.

Thanks,
Thierry
---
diff --cc mm/memcontrol.c
index 1c52ddb,65a46ef..84dcc5c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@@ -6203,9 -5979,6 +6216,8 @@@ static void __mem_cgroup_free(struct me
  	int node;
  	size_t size = memcg_size();
  
 +	mem_cgroup_remove_from_trees(memcg);
- 	free_css_id(&mem_cgroup_subsys, &memcg->css);
 +
  	for_each_node(node)
  		free_mem_cgroup_per_zone_info(memcg, node);
  
