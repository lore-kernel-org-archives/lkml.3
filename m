Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272AbaD1M2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 08:28:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57826 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932076AbaD1M1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 08:27:08 -0400
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Roman Gushchin <klamm@yandex-team.ru>,
        LKML <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH 3/4] memcg, doc: clarify global vs. limit reclaims
Date: Mon, 28 Apr 2014 14:26:44 +0200
Message-Id: <1398688005-26207-4-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 2.0.0.rc0
In-Reply-To: <1398688005-26207-1-git-send-email-mhocko@suse.cz>
References: <1398688005-26207-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Be explicit about global and hard limit reclaims in our documentation.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 Documentation/cgroups/memory.txt | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index 4937e6fff9b4..add1be001416 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -236,23 +236,26 @@ it by cgroup.
 2.5 Reclaim
 
 Each cgroup maintains a per cgroup LRU which has the same structure as
-global VM. When a cgroup goes over its limit, we first try
-to reclaim memory from the cgroup so as to make space for the new
-pages that the cgroup has touched. If the reclaim is unsuccessful,
-an OOM routine is invoked to select and kill the bulkiest task in the
-cgroup. (See 10. OOM Control below.)
-
-The reclaim algorithm has not been modified for cgroups, except that
-pages that are selected for reclaiming come from the per-cgroup LRU
-list.
-
-NOTE: Reclaim does not work for the root cgroup, since we cannot set any
-limits on the root cgroup.
+global VM. Cgroups can get reclaimed basically under two conditions
+ - under global memory pressure when all cgroups are reclaimed
+   proportionally wrt. their LRU size in a round robin fashion
+ - when a cgroup or its hierarchical parent (see 6. Hierarchical support)
+   hits hard limit. If the reclaim is unsuccessful, an OOM routine is invoked
+   to select and kill the bulkiest task in the cgroup. (See 10. OOM Control
+   below.)
+
+Global and hard-limit reclaims share the same code the only difference
+is the objective of the reclaim. The global reclaim aims at balancing
+zones' watermarks while the limit reclaim frees some memory to allow new
+charges.
+
+NOTE: Hard limit reclaim does not work for the root cgroup, since we cannot set
+any limits on the root cgroup.
 
 Note2: When panic_on_oom is set to "2", the whole system will panic.
 
-When oom event notifier is registered, event will be delivered.
-(See oom_control section)
+When oom event notifier is registered, event will be delivered to the root
+of the memory pressure which cannot be handled (See oom_control section)
 
 2.6 Locking
 
-- 
2.0.0.rc0

