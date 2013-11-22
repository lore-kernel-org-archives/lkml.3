Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab3KVRsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 12:48:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877Ab3KVRsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 12:48:52 -0500
Date: Fri, 22 Nov 2013 12:01:06 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, dave.hansen@intel.com
Subject: [PATCH] mmzone.h: constify some zone access functions
Message-ID: <20131122120106.4c372847@redhat.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Luiz capitulino <lcapitulino@redhat.com>
---
 include/linux/mmzone.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index bd791e4..5e202d6 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -560,12 +560,12 @@ static inline bool zone_spans_pfn(const struct zone *zone, unsigned long pfn)
 	return zone->zone_start_pfn <= pfn && pfn < zone_end_pfn(zone);
 }
 
-static inline bool zone_is_initialized(struct zone *zone)
+static inline bool zone_is_initialized(const struct zone *zone)
 {
 	return !!zone->wait_table;
 }
 
-static inline bool zone_is_empty(struct zone *zone)
+static inline bool zone_is_empty(const struct zone *zone)
 {
 	return zone->spanned_pages == 0;
 }
@@ -843,7 +843,7 @@ unsigned long __init node_memmap_size_bytes(int, unsigned long, unsigned long);
  */
 #define zone_idx(zone)		((zone) - (zone)->zone_pgdat->node_zones)
 
-static inline int populated_zone(struct zone *zone)
+static inline int populated_zone(const struct zone *zone)
 {
 	return (!!zone->present_pages);
 }
-- 
1.8.3.1

