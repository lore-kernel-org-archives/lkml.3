Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbaELO6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 10:58:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35387 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758634AbaELO6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 10:58:04 -0400
Date: Mon, 12 May 2014 16:58:03 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        hannes@cmpxchg.org
Subject: [PATCH] memcg: deprecate memory.force_empty knob
Message-ID: <20140512145803.GF9564@dhcp22.suse.cz>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <1399671091-23867-3-git-send-email-tj@kernel.org>
 <20140512145324.GE9564@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140512145324.GE9564@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And this one for deprecating force_empty.
---
>From 9bb3119900baa07b92fac932991cf94dd930f907 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 12 May 2014 16:20:46 +0200
Subject: [PATCH] memcg: deprecate memory.force_empty knob

force_empty has been introduced primarily to drop memory before it gets
reparented on the group removal. This alone doesn't sound fully
justified because reparented pages which are not in use can reclaimed
also later when there is a memory pressure on the parent level.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 Documentation/cgroups/memory.txt | 3 +++
 mm/memcontrol.c                  | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index f0f67b44ea07..fc9fad984bfb 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -477,6 +477,9 @@ About use_hierarchy, see Section 6.
   write will still return success. In this case, it is expected that
   memory.kmem.usage_in_bytes == memory.usage_in_bytes.
 
+  Please note that this knob is considered deprecated and will be removed
+  in future.
+
   About use_hierarchy, see Section 6.
 
 5.2 stat file
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b030b15b626a..912104d6d2a9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4793,6 +4793,10 @@ static int mem_cgroup_force_empty_write(struct cgroup_subsys_state *css,
 
 	if (mem_cgroup_is_root(memcg))
 		return -EINVAL;
+	pr_info("%s (%d): memory.force_empty is deprecated and will be removed.",
+			current->comm, task_pid_nr(current));
+	pr_cont(" Let us know if you know if it needed in your usecase at");
+	pr_cont(" linux-mm@kvack.org\n");
 	return mem_cgroup_force_empty(memcg);
 }
 
-- 
2.0.0.rc0

-- 
Michal Hocko
SUSE Labs
