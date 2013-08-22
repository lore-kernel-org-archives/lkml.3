Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab3HVIoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 04:44:30 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46116 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab3HVIoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 04:44:20 -0400
X-AuditID: 9c93017d-b7cdfae0000026c0-50-5215cf62c2df
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 03/16] slab: remove colouroff in struct slab
Date: Thu, 22 Aug 2013 17:44:12 +0900
Message-Id: <1377161065-30552-4-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now there is no user colouroff, so remove it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index 180f532..d9f81a0 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -219,7 +219,6 @@ struct slab {
 	union {
 		struct {
 			struct list_head list;
-			unsigned long colouroff;
 			void *s_mem;		/* including colour offset */
 			unsigned int inuse;	/* num of objs active in slab */
 			kmem_bufctl_t free;
@@ -2624,7 +2623,6 @@ static struct slab *alloc_slabmgmt(struct kmem_cache *cachep,
 		colour_off += cachep->slab_size;
 	}
 	slabp->inuse = 0;
-	slabp->colouroff = colour_off;
 	slabp->s_mem = addr + colour_off;
 	slabp->nodeid = nodeid;
 	slabp->free = 0;
-- 
1.7.9.5

