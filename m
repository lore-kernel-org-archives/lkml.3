Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab3HBCCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 22:02:47 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50761 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab3HBCCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 22:02:46 -0400
X-AuditID: 9c93016f-b7b05ae000002bbd-ea-51fb1344d287
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH] mm, slab_common: add 'unlikely' to size check of kmalloc_slab()
Date: Fri,  2 Aug 2013 11:02:42 +0900
Message-Id: <1375408962-16743-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Size is usually below than KMALLOC_MAX_SIZE.
If we add a 'unlikely' macro, compiler can make better code.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 538bade..f0410eb 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -373,7 +373,7 @@ struct kmem_cache *kmalloc_slab(size_t size, gfp_t flags)
 {
 	int index;
 
-	if (size > KMALLOC_MAX_SIZE) {
+	if (unlikely(size > KMALLOC_MAX_SIZE)) {
 		WARN_ON_ONCE(!(flags & __GFP_NOWARN));
 		return NULL;
 	}
-- 
1.7.9.5

