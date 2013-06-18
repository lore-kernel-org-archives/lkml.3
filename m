Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab3FRC1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 22:27:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab3FRC1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 22:27:10 -0400
Date: Mon, 17 Jun 2013 22:27:03 -0400
Message-Id: <201306180227.r5I2R3ji010972@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7/7] list: Remove __list_for_each
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__list_for_each used to be the non prefetch() aware list walking primitive.
When we removed the prefetch macros from the list routines, it became
redundant. Given it does exactly the same thing as list_for_each now,
we might as well remove it and call list_for_each directly.

Signed-off-by: Dave Jones <davej@redhat.com>
---
 include/linux/list.h | 11 -----------
 1 file changed, 11 deletions(-)

Note: Only to be merged after 1-6 are in Linus tree.

diff --git a/include/linux/list.h b/include/linux/list.h
index b83e565..f4d8a2f 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -381,17 +381,6 @@ static inline void list_splice_tail_init(struct list_head *list,
 	for (pos = (head)->next; pos != (head); pos = pos->next)
 
 /**
- * __list_for_each	-	iterate over a list
- * @pos:	the &struct list_head to use as a loop cursor.
- * @head:	the head for your list.
- *
- * This variant doesn't differ from list_for_each() any more.
- * We don't do prefetching in either case.
- */
-#define __list_for_each(pos, head) \
-	for (pos = (head)->next; pos != (head); pos = pos->next)
-
-/**
  * list_for_each_prev	-	iterate over a list backwards
  * @pos:	the &struct list_head to use as a loop cursor.
  * @head:	the head for your list.
-- 
1.8.1.4

