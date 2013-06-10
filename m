Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab3FJTSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 15:18:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22824 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab3FJTSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 15:18:21 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: penberg@kernel.org, cl@linux.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] slab: prevent warnings when allocating with __GFP_NOWARN
Date: Mon, 10 Jun 2013 15:18:00 -0400
Message-Id: <1370891880-2644-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

slab would still spew a warning when a big allocation happens with the
__GFP_NOWARN fleg is set. Prevent that to conform to __GFP_NOWARN.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 mm/slab_common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index ff3218a..2d41450 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -373,8 +373,10 @@ struct kmem_cache *kmalloc_slab(size_t size, gfp_t flags)
 {
 	int index;
 
-	if (WARN_ON_ONCE(size > KMALLOC_MAX_SIZE))
+	if (size > KMALLOC_MAX_SIZE) {
+		WARN_ON_ONCE(!(flags & __GFP_NOWARN));
 		return NULL;
+	}
 
 	if (size <= 192) {
 		if (!size)
-- 
1.8.2.1

