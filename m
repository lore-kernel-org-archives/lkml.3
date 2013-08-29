Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab3H2XcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 19:32:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49023 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756821Ab3H2XcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 19:32:17 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: [PATCH] ksm: Remove redundant __GFP_ZERO from kcalloc
Date: Thu, 29 Aug 2013 16:32:14 -0700
Message-Id: <1c47ec33fcbbf393f8d6decc9b3d6e18ed8b09a1.1377819069.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kcalloc returns zeroed memory.
There's no need to use this flag.

Signed-off-by: Joe Perches <joe@perches.com>
---
 mm/ksm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 0bea2b2..175fff7 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2309,8 +2309,8 @@ static ssize_t merge_across_nodes_store(struct kobject *kobj,
 			 * Allocate stable and unstable together:
 			 * MAXSMP NODES_SHIFT 10 will use 16kB.
 			 */
-			buf = kcalloc(nr_node_ids + nr_node_ids,
-				sizeof(*buf), GFP_KERNEL | __GFP_ZERO);
+			buf = kcalloc(nr_node_ids + nr_node_ids, sizeof(*buf),
+				      GFP_KERNEL);
 			/* Let us assume that RB_ROOT is NULL is zero */
 			if (!buf)
 				err = -ENOMEM;
-- 
1.8.1.2.459.gbcd45b4.dirty

