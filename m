Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbaAOPB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:01:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50829 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbaAOPBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:01:19 -0500
From: Michal Hocko <mhocko@suse.cz>
To: <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC 2/3] memcg: do not check PF_EXITING in mem_cgroup_out_of_memory
Date: Wed, 15 Jan 2014 16:01:07 +0100
Message-Id: <1389798068-19885-3-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389798068-19885-1-git-send-email-mhocko@suse.cz>
References: <1389798068-19885-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

because all tasks with PF_EXITING will skip the charge since (memcg: do
not hang on OOM when killed by userspace OOM access to memory reserves)
was merged.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 491d368ae488..97ae5cf12f5e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1766,7 +1766,7 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * select it.  The goal is to allow it to allocate so that it may
 	 * quickly exit and free its memory.
 	 */
-	if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
+	if (fatal_signal_pending(current)) {
 		set_thread_flag(TIF_MEMDIE);
 		return;
 	}
-- 
1.8.5.2

