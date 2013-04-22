Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab3DVIYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 04:24:00 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:60980 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab3DVIX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 04:23:59 -0400
X-AuditID: 9c93016f-b7c87ae000002520-82-5174f39b56c8
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Yinghai Lu <yinghai@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Jiang Liu <liuj97@gmail.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 2/2] mm, nobootmem: do memset() after memblock_reserve()
Date: Mon, 22 Apr 2013 17:25:13 +0900
Message-Id: <1366619113-28017-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1366619113-28017-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1366619113-28017-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we do memset() before reserving the area.
This may not cause any problem, but it is somewhat weird.
So change execution order.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index a31be7a..bdd3fa2 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -45,9 +45,9 @@ static void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
 	if (!addr)
 		return NULL;
 
+	memblock_reserve(addr, size);
 	ptr = phys_to_virt(addr);
 	memset(ptr, 0, size);
-	memblock_reserve(addr, size);
 	/*
 	 * The min_count is set to 0 so that bootmem allocated blocks
 	 * are never reported as leaks.
-- 
1.7.9.5

