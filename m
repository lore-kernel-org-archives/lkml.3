Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbaD1M2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 08:28:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57835 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932149AbaD1M1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 08:27:11 -0400
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Roman Gushchin <klamm@yandex-team.ru>,
        LKML <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH 4/4] memcg: Document memory.low_limit_in_bytes
Date: Mon, 28 Apr 2014 14:26:45 +0200
Message-Id: <1398688005-26207-5-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 2.0.0.rc0
In-Reply-To: <1398688005-26207-1-git-send-email-mhocko@suse.cz>
References: <1398688005-26207-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Describe low_limit_in_bytes and its effect.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 Documentation/cgroups/memory.txt | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index add1be001416..a52913fe96fb 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -57,6 +57,7 @@ Brief summary of control files.
  memory.memsw.usage_in_bytes	 # show current res_counter usage for memory+Swap
 				 (See 5.5 for details)
  memory.limit_in_bytes		 # set/show limit of memory usage
+ memory.low_limit_in_bytes	 # set/show low limit for memory reclaim
  memory.memsw.limit_in_bytes	 # set/show limit of memory+Swap usage
  memory.failcnt			 # show the number of memory usage hits limits
  memory.memsw.failcnt		 # show the number of memory+Swap hits limits
@@ -249,6 +250,14 @@ is the objective of the reclaim. The global reclaim aims at balancing
 zones' watermarks while the limit reclaim frees some memory to allow new
 charges.
 
+Groups might be also protected from both global and limit reclaim by
+low_limit_in_bytes knob. If the limit is non-zero the reclaim logic
+doesn't include groups (and their subgroups - see 6. Hierarchy support)
+which are bellow the low limit if there is other eligible cgroup in the
+reclaimed hierarchy. If all groups which participate reclaim are under
+their low limits then all of them are reclaimed and the low limit is
+ignored.
+
 NOTE: Hard limit reclaim does not work for the root cgroup, since we cannot set
 any limits on the root cgroup.
 
-- 
2.0.0.rc0

