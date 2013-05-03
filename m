Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762158Ab3ECAGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 20:06:18 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55422 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761737Ab3ECABu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 20:01:50 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v3 30/31] mm/page_alloc: use manage_pages instead of present pages when calculating default_zonelist_order()
Date: Thu,  2 May 2013 17:01:02 -0700
Message-Id: <1367539263-19999-31-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050300-7182-0000-0000-00000684BA31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4fe35b24..cc7b332 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3514,8 +3514,8 @@ static int default_zonelist_order(void)
 			z = &NODE_DATA(nid)->node_zones[zone_type];
 			if (populated_zone(z)) {
 				if (zone_type < ZONE_NORMAL)
-					low_kmem_size += z->present_pages;
-				total_size += z->present_pages;
+					low_kmem_size += z->managed_pages;
+				total_size += z->managed_pages;
 			} else if (zone_type == ZONE_NORMAL) {
 				/*
 				 * If any node has only lowmem, then node order
@@ -3545,8 +3545,8 @@ static int default_zonelist_order(void)
 			z = &NODE_DATA(nid)->node_zones[zone_type];
 			if (populated_zone(z)) {
 				if (zone_type < ZONE_NORMAL)
-					low_kmem_size += z->present_pages;
-				total_size += z->present_pages;
+					low_kmem_size += z->managed_pages;
+				total_size += z->managed_pages;
 			}
 		}
 		if (low_kmem_size &&
-- 
1.8.2.2

