Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbaCHDv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 22:51:28 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:62620 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbaCHDv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 22:51:27 -0500
From: Choi Gi-yong <yong@gnoy.org>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, Choi Gi-yong <yong@gnoy.org>
Subject: [PATCH 2/2] mm: Changed pr_warning() to pr_warn()
Date: Sat,  8 Mar 2014 12:51:21 +0900
Message-Id: <1394250681-5258-1-git-send-email-yong@gnoy.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Choi Gi-yong <yong@gnoy.org>
---
 mm/percpu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 6528ffa..dca284f 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -813,7 +813,7 @@ fail_unlock:
 fail_unlock_mutex:
 	mutex_unlock(&pcpu_alloc_mutex);
 	if (warn_limit) {
-		pr_warning("PERCPU: allocation failed, size=%zu align=%zu, "
+		pr_warn("PERCPU: allocation failed, size=%zu align=%zu, "
 			   "%s\n", size, align, err);
 		dump_stack();
 		if (!--warn_limit)
@@ -1397,7 +1397,7 @@ static int __init percpu_alloc_setup(char *str)
 		pcpu_chosen_fc = PCPU_FC_PAGE;
 #endif
 	else
-		pr_warning("PERCPU: unknown allocator %s specified\n", str);
+		pr_warn("PERCPU: unknown allocator %s specified\n", str);
 
 	return 0;
 }
@@ -1690,7 +1690,7 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
 
 	/* warn if maximum distance is further than 75% of vmalloc space */
 	if (max_distance > VMALLOC_TOTAL * 3 / 4) {
-		pr_warning("PERCPU: max_distance=0x%zx too large for vmalloc "
+		pr_warn("PERCPU: max_distance=0x%zx too large for vmalloc "
 			   "space 0x%lx\n", max_distance,
 			   VMALLOC_TOTAL);
 #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
@@ -1774,7 +1774,7 @@ int __init pcpu_page_first_chunk(size_t reserved_size,
 
 			ptr = alloc_fn(cpu, PAGE_SIZE, PAGE_SIZE);
 			if (!ptr) {
-				pr_warning("PERCPU: failed to allocate %s page "
+				pr_warn("PERCPU: failed to allocate %s page "
 					   "for cpu%u\n", psize_str, cpu);
 				goto enomem;
 			}
-- 
1.8.3.2

