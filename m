Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbaBGMKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:10:13 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:54216 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbaBGMKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:10:11 -0500
Date: Fri, 7 Feb 2014 17:40:06 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org, josh@joshtriplett.org
Subject: [PATCH 6/9] mm: Mark function as static in memcontrol.c
Message-ID: <0dbbc0fe4360069993ef8a9ca179f30482610270.1391167128.git.rashika.kheria@gmail.com>
References: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in memcontrol.c because it is not used outside
this file.

This also eliminates the following warning in memcontrol.c:
mm/memcontrol.c:3089:5: warning: no previous prototype for ‘memcg_update_cache_sizes’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bf5e894..fbec2a5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3086,7 +3086,7 @@ int memcg_cache_id(struct mem_cgroup *memcg)
  * But when we create a new cache, we can call this as well if its parent
  * is kmem-limited. That will have to hold set_limit_mutex as well.
  */
-int memcg_update_cache_sizes(struct mem_cgroup *memcg)
+static int memcg_update_cache_sizes(struct mem_cgroup *memcg)
 {
 	int num, ret;
 
-- 
1.7.9.5

