Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab3I3Laq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 07:30:46 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:52005 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab3I3L2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 07:28:00 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the cgroup tree
Date: Mon, 30 Sep 2013 13:26:05 +0200
Message-Id: <1380540373-25352-3-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380540373-25352-1-git-send-email-treding@nvidia.com>
References: <1380540373-25352-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the cgroup tree got conflicts in

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
  
