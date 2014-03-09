Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaCIIP0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 04:15:26 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:41939 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaCIIPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 04:15:15 -0400
From: Choi Gi-yong <yong@gnoy.org>
To: joe@perches.com
Cc: tj@kernel.org, linux-kernel@vger.kernel.org, Choi Gi-yong <yong@gnoy.org>
Subject: [PATCH 2/2] mm: Changed pr_warning() to pr_warn()
Date: Sun,  9 Mar 2014 17:15:00 +0900
Message-Id: <1394352900-13629-1-git-send-email-yong@gnoy.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Choi Gi-yong <yong@gnoy.org>
---
 mm/percpu.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index ff6cce2..061f312 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -812,8 +812,8 @@ fail_unlock:
 fail_unlock_mutex:
 	mutex_unlock(&pcpu_alloc_mutex);
 	if (warn_limit) {
-		pr_warn("PERCPU: allocation failed, size=%zu align=%zu, "
-			   "%s\n", size, align, err);
+		pr_warn("PERCPU: allocation failed, size=%zu align=%zu, %s\n",
+	size, align, err);
 		dump_stack();
 		if (!--warn_limit)
 			pr_info("PERCPU: limit reached, disable warning\n");
@@ -1689,9 +1689,8 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
 
 	/* warn if maximum distance is further than 75% of vmalloc space */
 	if (max_distance > VMALLOC_TOTAL * 3 / 4) {
-		pr_warn("PERCPU: max_distance=0x%zx too large for vmalloc "
-			   "space 0x%lx\n", max_distance,
-			   VMALLOC_TOTAL);
+		pr_warn("PERCPU: max_distance=0x%zx too large for vmalloc space 0x%lx\n",
+	max_distance, VMALLOC_TOTAL);
 #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
 		/* and fail if we have fallback */
 		rc = -EINVAL;
@@ -1773,8 +1772,8 @@ int __init pcpu_page_first_chunk(size_t reserved_size,
 
 			ptr = alloc_fn(cpu, PAGE_SIZE, PAGE_SIZE);
 			if (!ptr) {
-				pr_warn("PERCPU: failed to allocate %s page "
-					   "for cpu%u\n", psize_str, cpu);
+				pr_warn("PERCPU: failed to allocate %s page for cpu%u\n",
+	psize_str, cpu);
 				goto enomem;
 			}
 			/* kmemleak tracks the percpu allocations separately */
-- 
1.8.3.2

