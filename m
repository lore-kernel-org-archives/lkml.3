Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989Ab3CSFQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 01:16:06 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46401 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757379Ab3CSFPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 01:15:50 -0400
X-AuditID: 9c93016f-b7bfaae000003db8-5b-5147f4820123
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Yinghai Lu <yinghai@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Jiang Liu <liuj97@gmail.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 3/3] mm, nobootmem: do memset() after memblock_reserve()
Date: Tue, 19 Mar 2013 14:16:01 +0900
Message-Id: <1363670161-9214-3-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363670161-9214-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1363670161-9214-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we do memset() before reserving the area.
This may not cause any problem, but it is somewhat weird.
So change execution order.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 589c673..f11ec1c 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -46,8 +46,8 @@ static void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
 		return NULL;
 
 	ptr = phys_to_virt(addr);
-	memset(ptr, 0, size);
 	memblock_reserve(addr, size);
+	memset(ptr, 0, size);
 	/*
 	 * The min_count is set to 0 so that bootmem allocated blocks
 	 * are never reported as leaks.
-- 
1.7.9.5

