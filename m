Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab3FNMjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 08:39:24 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:43060 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab3FNMjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 08:39:23 -0400
Message-ID: <51BB0EF1.7040303@gmail.com>
Date: Fri, 14 Jun 2013 20:39:13 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: Remove unused functions is_{normal_idx, normal, dma32,
 dma}
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

These functions are nowhere used, so remove them.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 include/linux/mmzone.h |   28 ----------------------------
 1 files changed, 0 insertions(+), 28 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 5c76737..32f0105 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -843,11 +843,6 @@ static inline int is_highmem_idx(enum zone_type idx)
 #endif
 }
 
-static inline int is_normal_idx(enum zone_type idx)
-{
-	return (idx == ZONE_NORMAL);
-}
-
 /**
  * is_highmem - helper function to quickly check if a struct zone is a 
  *              highmem zone or not.  This is an attempt to keep references
@@ -866,29 +861,6 @@ static inline int is_highmem(struct zone *zone)
 #endif
 }
 
-static inline int is_normal(struct zone *zone)
-{
-	return zone == zone->zone_pgdat->node_zones + ZONE_NORMAL;
-}
-
-static inline int is_dma32(struct zone *zone)
-{
-#ifdef CONFIG_ZONE_DMA32
-	return zone == zone->zone_pgdat->node_zones + ZONE_DMA32;
-#else
-	return 0;
-#endif
-}
-
-static inline int is_dma(struct zone *zone)
-{
-#ifdef CONFIG_ZONE_DMA
-	return zone == zone->zone_pgdat->node_zones + ZONE_DMA;
-#else
-	return 0;
-#endif
-}
-
 /* These two functions are used to setup the per zone pages min values */
 struct ctl_table;
 int min_free_kbytes_sysctl_handler(struct ctl_table *, int,
-- 
1.7.1
