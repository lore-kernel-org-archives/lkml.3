Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbaBKKq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 05:46:56 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:56153 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaBKKqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:46:47 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: sjenning@linux.vnet.ibm.com, trivial@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH 2/2] mm/zswap: update zsmalloc in comment to zbud
Date: Tue, 11 Feb 2014 19:46:30 +0900
Message-Id: <1392115590-15260-2-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1392115590-15260-1-git-send-email-sj38.park@gmail.com>
References: <1392115590-15260-1-git-send-email-sj38.park@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zswap used zsmalloc before and now using zbud. But, some comments
saying it use zsmalloc yet. Fix the trivial problems.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 mm/zswap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 5b22453..25312eb 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -165,7 +165,7 @@ static void zswap_comp_exit(void)
  *            be held while changing the refcount.  Since the lock must
  *            be held, there is no reason to also make refcount atomic.
  * offset - the swap offset for the entry.  Index into the red-black tree.
- * handle - zsmalloc allocation handle that stores the compressed page data
+ * handle - zbud allocation handle that stores the compressed page data
  * length - the length in bytes of the compressed page data.  Needed during
  *          decompression
  */
@@ -282,7 +282,7 @@ static void zswap_rb_erase(struct rb_root *root, struct zswap_entry *entry)
 }
 
 /*
- * Carries out the common pattern of freeing and entry's zsmalloc allocation,
+ * Carries out the common pattern of freeing and entry's zbud allocation,
  * freeing the entry itself, and decrementing the number of stored pages.
  */
 static void zswap_free_entry(struct zswap_tree *tree,
-- 
1.8.1.2

