Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbaL2L7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 06:59:13 -0500
Received: from mx2.parallels.com ([199.115.105.18]:58354 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaL2L7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 06:59:12 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH TRIVIAL] swap: remove unused mem_cgroup_uncharge_swapcache declaration
Date: Mon, 29 Dec 2014 14:58:57 +0300
Message-ID: <1419854337-15161-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The body of this function was removed by commit 0a31bc97c80c ("mm:
memcontrol: rewrite uncharge API").

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 include/linux/swap.h |   15 ---------------
 mm/shmem.c           |    2 +-
 2 files changed, 1 insertion(+), 16 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 34e8b60ab973..7067eca501e2 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -437,16 +437,6 @@ extern int reuse_swap_page(struct page *);
 extern int try_to_free_swap(struct page *);
 struct backing_dev_info;
 
-#ifdef CONFIG_MEMCG
-extern void
-mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout);
-#else
-static inline void
-mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout)
-{
-}
-#endif
-
 #else /* CONFIG_SWAP */
 
 #define swap_address_space(entry)		(NULL)
@@ -547,11 +537,6 @@ static inline swp_entry_t get_swap_page(void)
 	return entry;
 }
 
-static inline void
-mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent)
-{
-}
-
 #endif /* CONFIG_SWAP */
 #endif /* __KERNEL__*/
 #endif /* _LINUX_SWAP_H */
diff --git a/mm/shmem.c b/mm/shmem.c
index 185836ba53ef..0c92e925c4bf 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1131,7 +1131,7 @@ repeat:
 			 * truncated or holepunched since swap was confirmed.
 			 * shmem_undo_range() will have done some of the
 			 * unaccounting, now delete_from_swap_cache() will do
-			 * the rest (including mem_cgroup_uncharge_swapcache).
+			 * the rest.
 			 * Reset swap.val? No, leave it so "failed" goes back to
 			 * "repeat": reading a hole and writing should succeed.
 			 */
-- 
1.7.10.4

