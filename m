Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641AbaFXQd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:33:27 -0400
Received: from mx2.parallels.com ([199.115.105.18]:56211 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921AbaFXQdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 12:33:18 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: [PATCH -mm 1/3] page-cgroup: trivial cleanup
Date: Tue, 24 Jun 2014 20:33:04 +0400
Message-ID: <9f5abf8dcb07fe5462f12f81867f199c22e883d3.1403626729.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add forward declarations for struct pglist_data, mem_cgroup.

Remove __init, __meminit from function prototypes and inline functions.

Remove redundant inclusion of bit_spinlock.h.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 include/linux/page_cgroup.h |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
index 97b5c39a31c8..23863edb95ff 100644
--- a/include/linux/page_cgroup.h
+++ b/include/linux/page_cgroup.h
@@ -12,8 +12,10 @@ enum {
 #ifndef __GENERATING_BOUNDS_H
 #include <generated/bounds.h>
 
+struct pglist_data;
+
 #ifdef CONFIG_MEMCG
-#include <linux/bit_spinlock.h>
+struct mem_cgroup;
 
 /*
  * Page Cgroup can be considered as an extended mem_map.
@@ -27,16 +29,16 @@ struct page_cgroup {
 	struct mem_cgroup *mem_cgroup;
 };
 
-void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat);
+extern void pgdat_page_cgroup_init(struct pglist_data *pgdat);
 
 #ifdef CONFIG_SPARSEMEM
-static inline void __init page_cgroup_init_flatmem(void)
+static inline void page_cgroup_init_flatmem(void)
 {
 }
-extern void __init page_cgroup_init(void);
+extern void page_cgroup_init(void);
 #else
-void __init page_cgroup_init_flatmem(void);
-static inline void __init page_cgroup_init(void)
+extern void page_cgroup_init_flatmem(void);
+static inline void page_cgroup_init(void)
 {
 }
 #endif
@@ -48,11 +50,10 @@ static inline int PageCgroupUsed(struct page_cgroup *pc)
 {
 	return test_bit(PCG_USED, &pc->flags);
 }
-
-#else /* CONFIG_MEMCG */
+#else /* !CONFIG_MEMCG */
 struct page_cgroup;
 
-static inline void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat)
+static inline void pgdat_page_cgroup_init(struct pglist_data *pgdat)
 {
 }
 
@@ -65,10 +66,9 @@ static inline void page_cgroup_init(void)
 {
 }
 
-static inline void __init page_cgroup_init_flatmem(void)
+static inline void page_cgroup_init_flatmem(void)
 {
 }
-
 #endif /* CONFIG_MEMCG */
 
 #include <linux/swap.h>
-- 
1.7.10.4

