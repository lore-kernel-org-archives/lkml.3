Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab3AOHUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 02:20:23 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45219 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab3AOHUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 02:20:19 -0500
X-AuditID: 9c930179-b7b0cae0000065b4-34-50f5032f7961
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, js1304@gmail.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 3/3] slub: add 'likely' macro to inc_slabs_node()
Date: Tue, 15 Jan 2013 16:20:02 +0900
Message-Id: <1358234402-2615-3-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358234402-2615-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1358234402-2615-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After boot phase, 'n' always exist.
So add 'likely' macro for helping compiler.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slub.c b/mm/slub.c
index 830348b..6f82070 100644
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

