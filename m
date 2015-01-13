Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192AbbAMGqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 01:46:05 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:63616 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbbAMGqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 01:46:02 -0500
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>
Subject: [PATCH] memcg: remove extra newlines from memcg oom kill log
Date: Mon, 12 Jan 2015 22:45:39 -0800
Message-Id: <1421131539-3211-1-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e61734c55c24 ("cgroup: remove cgroup->name") added two extra
newlines to memcg oom kill log messages.  This makes dmesg hard to read
and parse.  The issue affects 3.15+.
Example:
  Task in /t                          <<< extra #1
   killed as a result of limit of /t
                                      <<< extra #2
  memory: usage 102400kB, limit 102400kB, failcnt 274712

Remove the extra newlines from memcg oom kill messages, so the messages
look like:
  Task in /t killed as a result of limit of /t
  memory: usage 102400kB, limit 102400kB, failcnt 240649

Fixes: e61734c55c24 ("cgroup: remove cgroup->name")
Signed-off-by: Greg Thelen <gthelen@google.com>
---
 mm/memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 851924fa5170..683b4782019b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1477,9 +1477,9 @@ void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
 
 	pr_info("Task in ");
 	pr_cont_cgroup_path(task_cgroup(p, memory_cgrp_id));
-	pr_info(" killed as a result of limit of ");
+	pr_cont(" killed as a result of limit of ");
 	pr_cont_cgroup_path(memcg->css.cgroup);
-	pr_info("\n");
+	pr_cont("\n");
 
 	rcu_read_unlock();
 
-- 
2.2.0.rc0.207.ga3a616c

