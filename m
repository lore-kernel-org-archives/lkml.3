Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbaK2LYQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 06:24:16 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:56028 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbaK2LYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 06:24:15 -0500
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
To: minchan@kernel.org, ngupta@vflare.org, ddstreet@ieee.org
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: [RFC PATCH] mm/zsmalloc: allocate exactly size of struct zs_pool
Date: Sat, 29 Nov 2014 19:23:55 +0800
Message-Id: <1417260235-32053-1-git-send-email-opensource.ganesh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In zs_create_pool(), we allocate memory more then sizeof(struct zs_pool)
  ovhd_size = roundup(sizeof(*pool), PAGE_SIZE);

This patch allocate memory of exactly needed size.

Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
---
 mm/zsmalloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 2021df5..4d0a063 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -979,12 +979,11 @@ static bool can_merge(struct size_class *prev, int size, int pages_per_zspage)
  */
 struct zs_pool *zs_create_pool(gfp_t flags)
 {
-	int i, ovhd_size;
+	int i;
 	struct zs_pool *pool;
 	struct size_class *prev_class = NULL;
 
-	ovhd_size = roundup(sizeof(*pool), PAGE_SIZE);
-	pool = kzalloc(ovhd_size, GFP_KERNEL);
+	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
 	if (!pool)
 		return NULL;
 
-- 
1.7.9.5

