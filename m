Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab3BDE3E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 23:29:04 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:41023 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab3BDE3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 23:29:03 -0500
Date: Sun, 3 Feb 2013 20:29:01 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Glauber Costa <glommer@parallels.com>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] memcg: stop warning on memcg_propagate_kmem
Message-ID: <alpine.LNX.2.00.1302032023280.4611@eggly.anvils>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whilst I run the risk of a flogging for disloyalty to the Lord of Sealand,
I do have CONFIG_MEMCG=y CONFIG_MEMCG_KMEM not set, and grow tired of the
"mm/memcontrol.c:4972:12: warning: `memcg_propagate_kmem' defined but not
used [-Wunused-function]" seen in 3.8-rc: move the #ifdef outwards.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- 3.8-rc6/mm/memcontrol.c	2012-12-22 09:43:27.628015582 -0800
+++ linux/mm/memcontrol.c	2013-02-02 16:56:06.188325771 -0800
@@ -4969,6 +4969,7 @@ out:
 	return ret;
 }
 
+#ifdef CONFIG_MEMCG_KMEM
 static int memcg_propagate_kmem(struct mem_cgroup *memcg)
 {
 	int ret = 0;
@@ -4977,7 +4978,6 @@ static int memcg_propagate_kmem(struct m
 		goto out;
 
 	memcg->kmem_account_flags = parent->kmem_account_flags;
-#ifdef CONFIG_MEMCG_KMEM
 	/*
 	 * When that happen, we need to disable the static branch only on those
 	 * memcgs that enabled it. To achieve this, we would be forced to
@@ -5003,10 +5003,10 @@ static int memcg_propagate_kmem(struct m
 	mutex_lock(&set_limit_mutex);
 	ret = memcg_update_cache_sizes(memcg);
 	mutex_unlock(&set_limit_mutex);
-#endif
 out:
 	return ret;
 }
+#endif /* CONFIG_MEMCG_KMEM */
 
 /*
  * The user of this function is...
