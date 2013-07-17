Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab3GQCoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 22:44:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab3GQCoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 22:44:19 -0400
Date: Tue, 16 Jul 2013 22:44:08 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: linked-list: Remove __list_for_each
Message-ID: <20130717024408.GA15266@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__list_for_each used to be the non prefetch() aware list walking primitive.
When we removed the prefetch macros from the list routines, it became
redundant. Given it does exactly the same thing as list_for_each now,
we might as well remove it and call list_for_each directly.

All users of __list_for_each have been converted to list_for_each calls
in the current merge window.
    
Signed-off-by: Dave Jones <davej@redhat.com>

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
