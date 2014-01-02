Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265AbaABL0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 06:26:07 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:40115 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaABL0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 06:26:05 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: mgorman@suse.de, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH] mm: page_alloc: use enum instead of number for migratetype
Date: Thu,  2 Jan 2014 20:25:22 +0900
Message-Id: <1388661922-10957-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using enum instead of number for migratetype everywhere would be better
for reading and understanding.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 mm/page_alloc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5bcbca5..08f6ed7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -646,7 +646,7 @@ static inline int free_pages_check(struct page *page)
 static void free_pcppages_bulk(struct zone *zone, int count,
 					struct per_cpu_pages *pcp)
 {
-	int migratetype = 0;
+	int migratetype = MIGRATE_UNMOVABLE;
 	int batch_free = 0;
 	int to_free = count;
 
@@ -667,7 +667,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 		do {
 			batch_free++;
 			if (++migratetype == MIGRATE_PCPTYPES)
-				migratetype = 0;
+				migratetype = MIGRATE_UNMOVABLE;
 			list = &pcp->lists[migratetype];
 		} while (list_empty(list));
 
@@ -4158,7 +4158,9 @@ static void pageset_init(struct per_cpu_pageset *p)
 
 	pcp = &p->pcp;
 	pcp->count = 0;
-	for (migratetype = 0; migratetype < MIGRATE_PCPTYPES; migratetype++)
+
+	for (migratetype = MIGRATE_UNMOVABLE; migratetype < MIGRATE_PCPTYPES;
+						migratetype++)
 		INIT_LIST_HEAD(&pcp->lists[migratetype]);
 }
 
-- 
1.8.1.2

