Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbaKTNWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:22:09 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:54447 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbaKTNWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:22:07 -0500
From: Mahendran Ganesh <opensource.ganesh@gmail.com>
To: minchan@kernel.org, ngupta@vflare.org, iamjoonsoo.kim@lge.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mahendran Ganesh <opensource.ganesh@gmail.com>
Subject: [RFC PATCH] mm/zsmalloc: remove unnecessary check
Date: Thu, 20 Nov 2014 21:21:56 +0800
Message-Id: <1416489716-9967-1-git-send-email-opensource.ganesh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ZS_SIZE_CLASSES is calc by:
  ((ZS_MAX_ALLOC_SIZE - ZS_MIN_ALLOC_SIZE) / ZS_SIZE_CLASS_DELTA + 1)

So when i is in [0, ZS_SIZE_CLASSES - 1), the size:
  size = ZS_MIN_ALLOC_SIZE + i * ZS_SIZE_CLASS_DELTA
will not be greater than ZS_MAX_ALLOC_SIZE

This patch removes the unnecessary check.

Signed-off-by: Mahendran Ganesh <opensource.ganesh@gmail.com>
---
 mm/zsmalloc.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index b3b57ef..f2279e2 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -973,8 +973,6 @@ struct zs_pool *zs_create_pool(gfp_t flags)
 		struct size_class *prev_class;
 
 		size = ZS_MIN_ALLOC_SIZE + i * ZS_SIZE_CLASS_DELTA;
-		if (size > ZS_MAX_ALLOC_SIZE)
-			size = ZS_MAX_ALLOC_SIZE;
 		pages_per_zspage = get_pages_per_zspage(size);
 
 		/*
-- 
1.7.9.5

