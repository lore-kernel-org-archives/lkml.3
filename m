Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291AbaLBWis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 17:38:48 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54723 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933048AbaLBWiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 17:38:46 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: memcontrol.c:  Cleaning up function that are not used anywhere
Date: Tue,  2 Dec 2014 23:41:23 +0100
Message-Id: <1417560083-27157-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove function mem_cgroup_lru_names_not_uptodate() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 mm/memcontrol.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d6ac0e3..5edd1fe 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4379,11 +4379,6 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
 }
 #endif /* CONFIG_NUMA */
 
-static inline void mem_cgroup_lru_names_not_uptodate(void)
-{
-	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
-}
-
 static int memcg_stat_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
-- 
1.7.10.4

