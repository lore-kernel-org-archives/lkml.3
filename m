Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbbALSyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:54:32 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:60900 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbbALSy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:54:28 -0500
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Greg Thelen <gthelen@google.com>
Subject: [PATCH] memcg: add BUILD_BUG_ON() for string tables
Date: Mon, 12 Jan 2015 10:54:23 -0800
Message-Id: <1421088863-14270-1-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use BUILD_BUG_ON() to compile assert that memcg string tables are in
sync with corresponding enums.  There aren't currently any issues with
these tables.  This is just defensive.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 mm/memcontrol.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ef91e856c7e4..8d1ca6c55480 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3699,6 +3699,10 @@ static int memcg_stat_show(struct seq_file *m, void *v)
 	struct mem_cgroup *mi;
 	unsigned int i;
 
+	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_stat_names) !=
+		     MEM_CGROUP_STAT_NSTATS);
+	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_events_names) !=
+		     MEM_CGROUP_EVENTS_NSTATS);
 	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
 
 	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
-- 
2.2.0.rc0.207.ga3a616c

