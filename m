Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab3KJQ7a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 11:59:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab3KJQ6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 11:58:46 -0500
Date: Sun, 10 Nov 2013 18:00:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eilon Greenstein <eilong@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] list: introduce list_last_entry(), use
	list_{first,last}_entry()
Message-ID: <20131110170010.GA314@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131110165947.GA32758@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We alredy have list_first_entry(), it makes sense to also add
list_last_entry() for consistency. And we use both helpers in
in list_for_each_*().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/list.h |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index c88a591..ef95941 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -362,6 +362,17 @@ static inline void list_splice_tail_init(struct list_head *list,
 	list_entry((ptr)->next, type, member)
 
 /**
+ * list_last_entry - get the last element from a list
+ * @ptr:	the list head to take the element from.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * Note, that list is expected to be not empty.
+ */
+#define list_last_entry(ptr, type, member) \
+	list_entry((ptr)->prev, type, member)
+
+/**
  * list_first_entry_or_null - get the first element from a list
  * @ptr:	the list head to take the element from.
  * @type:	the type of the struct this is embedded in.
@@ -432,7 +443,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * @member:	the name of the list_struct within the struct.
  */
 #define list_for_each_entry(pos, head, member)				\
-	for (pos = list_entry((head)->next, typeof(*pos), member);	\
+	for (pos = list_first_entry(head, typeof(*pos), member);	\
 	     &pos->member != (head);					\
 	     pos = list_next_entry(pos, member))
 
@@ -443,7 +454,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * @member:	the name of the list_struct within the struct.
  */
 #define list_for_each_entry_reverse(pos, head, member)			\
-	for (pos = list_entry((head)->prev, typeof(*pos), member);	\
+	for (pos = list_last_entry(head, typeof(*pos), member);		\
 	     &pos->member != (head); 					\
 	     pos = list_prev_entry(pos, member))
 
@@ -506,7 +517,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * @member:	the name of the list_struct within the struct.
  */
 #define list_for_each_entry_safe(pos, n, head, member)			\
-	for (pos = list_entry((head)->next, typeof(*pos), member),	\
+	for (pos = list_first_entry(head, typeof(*pos), member),	\
 		n = list_next_entry(pos, member);			\
 	     &pos->member != (head); 					\
 	     pos = n, n = list_next_entry(n, member))
@@ -553,7 +564,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * of list entry.
  */
 #define list_for_each_entry_safe_reverse(pos, n, head, member)		\
-	for (pos = list_entry((head)->prev, typeof(*pos), member),	\
+	for (pos = list_last_entry(head, typeof(*pos), member),		\
 		n = list_prev_entry(pos, member);			\
 	     &pos->member != (head); 					\
 	     pos = n, n = list_prev_entry(n, member))
-- 
1.5.5.1

