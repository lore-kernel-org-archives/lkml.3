Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933405Ab3GCXav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 19:30:51 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:24849 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694Ab3GCXau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 19:30:50 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, tangchen@cn.fujitsu.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH] mm/memory_hotplug.c: Fix return value of online_pages()
Date: Wed,  3 Jul 2013 17:29:59 -0600
Message-Id: <1372894199-19623-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

online_pages() is called from memory_block_action() when a user
requests to online a memory block via sysfs.  This function needs
to return a proper error value in case of error.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 mm/memory_hotplug.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index cd2990f..ca1dd3a 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -914,19 +914,19 @@ int __ref online_pages(unsigned long pfn, unsigned long nr_pages, int online_typ
 	if ((zone_idx(zone) > ZONE_NORMAL || online_type == ONLINE_MOVABLE) &&
 	    !can_online_high_movable(zone)) {
 		unlock_memory_hotplug();
-		return -1;
+		return -EINVAL;
 	}
 
 	if (online_type == ONLINE_KERNEL && zone_idx(zone) == ZONE_MOVABLE) {
 		if (move_pfn_range_left(zone - 1, zone, pfn, pfn + nr_pages)) {
 			unlock_memory_hotplug();
-			return -1;
+			return -EINVAL;
 		}
 	}
 	if (online_type == ONLINE_MOVABLE && zone_idx(zone) == ZONE_MOVABLE - 1) {
 		if (move_pfn_range_right(zone, zone + 1, pfn, pfn + nr_pages)) {
 			unlock_memory_hotplug();
-			return -1;
+			return -EINVAL;
 		}
 	}
 
