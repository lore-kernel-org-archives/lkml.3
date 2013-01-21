Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab3AUIBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 03:01:44 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53513 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab3AUIBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 03:01:34 -0500
X-AuditID: 9c93016f-b7b70ae000000e36-3f-50fcf5da2a45
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, js1304@gmail.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 3/3] slub: add 'likely' macro to inc_slabs_node()
Date: Mon, 21 Jan 2013 17:01:27 +0900
Message-Id: <1358755287-3899-3-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358755287-3899-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1358755287-3899-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After boot phase, 'n' always exist.
So add 'likely' macro for helping compiler.

Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slub.c b/mm/slub.c
index 8b95364..ddbd401 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1005,7 +1005,7 @@ static inline void inc_slabs_node(struct kmem_cache *s, int node, int objects)
 	 * dilemma by deferring the increment of the count during
 	 * bootstrap (see early_kmem_cache_node_alloc).
 	 */
-	if (n) {
+	if (likely(n)) {
 		atomic_long_inc(&n->nr_slabs);
 		atomic_long_add(objects, &n->total_objects);
 	}
-- 
1.7.9.5

