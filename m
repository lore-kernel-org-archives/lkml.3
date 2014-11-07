Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaKGVTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 16:19:06 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:64430 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaKGVTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 16:19:03 -0500
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: linux-usb@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, kernel-janitors@vger.kernel.org,
        gregkh@linuxfoundation.org, mgorman@suse.de, ddstreet@ieee.org,
        jeffrey.t.kirsher@intel.com, yamada.m@jp.panasonic.com,
        kenhelias@firemail.de, oleg@redhat.com, akpm@linux-foundation.org,
        shuah.kh@samsung.com, valentina.manea.m@gmail.com,
        yann.morin.1998@free.fr, laijs@cn.fujitsu.com,
        mathieu.desnoyers@efficios.com, rostedt@goodmis.org,
        josh@joshtriplett.org, paulmck@linux.vnet.ibm.com,
        m.chehab@samsung.com, awalls@md.metrocast.net, airlied@linux.ie,
        christian.koenig@amd.com, alexander.deucher@amd.com
Cc: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH] Replace mentions of "list_struct" to "list_head"
Date: Sat,  8 Nov 2014 01:18:48 +0400
Message-Id: <1415395128-7976-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no such thing as "list_struct".

Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 drivers/gpu/drm/radeon/mkregtable.c  | 24 ++++++++++++------------
 drivers/media/pci/cx18/cx18-driver.h |  2 +-
 include/linux/list.h                 | 34 +++++++++++++++++-----------------
 include/linux/plist.h                | 10 +++++-----
 include/linux/rculist.h              |  8 ++++----
 scripts/kconfig/list.h               |  6 +++---
 tools/usb/usbip/libsrc/list.h        |  2 +-
 7 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/drivers/gpu/drm/radeon/mkregtable.c b/drivers/gpu/drm/radeon/mkregtable.c
index 4a85bb6..b928c17 100644
--- a/drivers/gpu/drm/radeon/mkregtable.c
+++ b/drivers/gpu/drm/radeon/mkregtable.c
@@ -347,7 +347,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * list_entry - get the struct for this entry
  * @ptr:	the &struct list_head pointer.
  * @type:	the type of the struct this is embedded in.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  */
 #define list_entry(ptr, type, member) \
 	container_of(ptr, type, member)
@@ -356,7 +356,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * list_first_entry - get the first element from a list
  * @ptr:	the list head to take the element from.
  * @type:	the type of the struct this is embedded in.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  *
  * Note, that list is expected to be not empty.
  */
@@ -406,7 +406,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * list_for_each_entry	-	iterate over list of given type
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  */
 #define list_for_each_entry(pos, head, member)				\
 	for (pos = list_entry((head)->next, typeof(*pos), member);	\
@@ -417,7 +417,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * list_for_each_entry_reverse - iterate backwards over list of given type.
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  */
 #define list_for_each_entry_reverse(pos, head, member)			\
 	for (pos = list_entry((head)->prev, typeof(*pos), member);	\
@@ -428,7 +428,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * list_prepare_entry - prepare a pos entry for use in list_for_each_entry_continue()
  * @pos:	the type * to use as a start point
  * @head:	the head of the list
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  *
  * Prepares a pos entry for use as a start point in list_for_each_entry_continue().
  */
@@ -439,7 +439,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * list_for_each_entry_continue - continue iteration over list of given type
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  *
  * Continue to iterate over list of given type, continuing after
  * the current position.
@@ -453,7 +453,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * list_for_each_entry_continue_reverse - iterate backwards from the given point
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  *
  * Start to iterate over list of given type backwards, continuing after
  * the current position.
@@ -467,7 +467,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * list_for_each_entry_from - iterate over list of given type from the current point
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  *
  * Iterate over list of given type, continuing from current position.
  */
@@ -480,7 +480,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * @pos:	the type * to use as a loop cursor.
  * @n:		another type * to use as temporary storage
  * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  */
 #define list_for_each_entry_safe(pos, n, head, member)			\
 	for (pos = list_entry((head)->next, typeof(*pos), member),	\
@@ -493,7 +493,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * @pos:	the type * to use as a loop cursor.
  * @n:		another type * to use as temporary storage
  * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  *
  * Iterate over list of given type, continuing after current point,
  * safe against removal of list entry.
@@ -509,7 +509,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * @pos:	the type * to use as a loop cursor.
  * @n:		another type * to use as temporary storage
  * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  *
  * Iterate over list of given type from current point, safe against
  * removal of list entry.
@@ -524,7 +524,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * @pos:	the type * to use as a loop cursor.
  * @n:		another type * to use as temporary storage
  * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  *
  * Iterate backwards over list of given type, safe against removal
  * of list entry.
diff --git a/drivers/media/pci/cx18/cx18-driver.h b/drivers/media/pci/cx18/cx18-driver.h
index 57f4688..da59ec3 100644
--- a/drivers/media/pci/cx18/cx18-driver.h
+++ b/drivers/media/pci/cx18/cx18-driver.h
@@ -290,7 +290,7 @@ struct cx18_options {
  * list_entry_is_past_end - check if a previous loop cursor is off list end
  * @pos:	the type * previously used as a loop cursor.
  * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  *
  * Check if the entry's list_head is the head of the list, thus it's not a
  * real entry but was the loop cursor that walked past the end
diff --git a/include/linux/list.h b/include/linux/list.h
index f33f831..feb773c 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -346,7 +346,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * list_entry - get the struct for this entry
  * @ptr:	the &struct list_head pointer.
  * @type:	the type of the struct this is embedded in.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  */
 #define list_entry(ptr, type, member) \
 	container_of(ptr, type, member)
@@ -355,7 +355,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * list_first_entry - get the first element from a list
  * @ptr:	the list head to take the element from.
  * @type:	the type of the struct this is embedded in.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  *
  * Note, that list is expected to be not empty.
  */
@@ -366,7 +366,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * list_last_entry - get the last element from a list
  * @ptr:	the list head to take the element from.
  * @type:	the type of the struct this is embedded in.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  *
  * Note, that list is expected to be not empty.
  */
@@ -377,7 +377,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * list_first_entry_or_null - get the first element from a list
  * @ptr:	the list head to take the element from.
  * @type:	the type of the struct this is embedded in.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  *
  * Note that if the list is empty, it returns NULL.
  */
@@ -387,7 +387,7 @@ static inline void list_splice_tail_init(struct list_head *list,
 /**
  * list_next_entry - get the next element in list
  * @pos:	the type * to cursor
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  */
 #define list_next_entry(pos, member) \
 	list_entry((pos)->member.next, typeof(*(pos)), member)
@@ -395,7 +395,7 @@ static inline void list_splice_tail_init(struct list_head *list,
 /**
  * list_prev_entry - get the prev element in list
  * @pos:	the type * to cursor
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  */
 #define list_prev_entry(pos, member) \
 	list_entry((pos)->member.prev, typeof(*(pos)), member)
@@ -441,7 +441,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * list_for_each_entry	-	iterate over list of given type
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  */
 #define list_for_each_entry(pos, head, member)				\
 	for (pos = list_first_entry(head, typeof(*pos), member);	\
@@ -452,7 +452,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * list_for_each_entry_reverse - iterate backwards over list of given type.
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  */
 #define list_for_each_entry_reverse(pos, head, member)			\
 	for (pos = list_last_entry(head, typeof(*pos), member);		\
@@ -463,7 +463,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * list_prepare_entry - prepare a pos entry for use in list_for_each_entry_continue()
  * @pos:	the type * to use as a start point
  * @head:	the head of the list
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  *
  * Prepares a pos entry for use as a start point in list_for_each_entry_continue().
  */
@@ -474,7 +474,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * list_for_each_entry_continue - continue iteration over list of given type
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  *
  * Continue to iterate over list of given type, continuing after
  * the current position.
@@ -488,7 +488,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * list_for_each_entry_continue_reverse - iterate backwards from the given point
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  *
  * Start to iterate over list of given type backwards, continuing after
  * the current position.
@@ -502,7 +502,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * list_for_each_entry_from - iterate over list of given type from the current point
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  *
  * Iterate over list of given type, continuing from current position.
  */
@@ -515,7 +515,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * @pos:	the type * to use as a loop cursor.
  * @n:		another type * to use as temporary storage
  * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  */
 #define list_for_each_entry_safe(pos, n, head, member)			\
 	for (pos = list_first_entry(head, typeof(*pos), member),	\
@@ -528,7 +528,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * @pos:	the type * to use as a loop cursor.
  * @n:		another type * to use as temporary storage
  * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  *
  * Iterate over list of given type, continuing after current point,
  * safe against removal of list entry.
@@ -544,7 +544,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * @pos:	the type * to use as a loop cursor.
  * @n:		another type * to use as temporary storage
  * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  *
  * Iterate over list of given type from current point, safe against
  * removal of list entry.
@@ -559,7 +559,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * @pos:	the type * to use as a loop cursor.
  * @n:		another type * to use as temporary storage
  * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  *
  * Iterate backwards over list of given type, safe against removal
  * of list entry.
@@ -574,7 +574,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * list_safe_reset_next - reset a stale list_for_each_entry_safe loop
  * @pos:	the loop cursor used in the list_for_each_entry_safe loop
  * @n:		temporary storage used in list_for_each_entry_safe
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  *
  * list_safe_reset_next is not safe to use in general if the list may be
  * modified concurrently (eg. the lock is dropped in the loop body). An
diff --git a/include/linux/plist.h b/include/linux/plist.h
index 8b6c970..9788360 100644
--- a/include/linux/plist.h
+++ b/include/linux/plist.h
@@ -176,7 +176,7 @@ extern void plist_requeue(struct plist_node *node, struct plist_head *head);
  * plist_for_each_entry	- iterate over list of given type
  * @pos:	the type * to use as a loop counter
  * @head:	the head for your list
- * @mem:	the name of the list_struct within the struct
+ * @mem:	the name of the list_head within the struct
  */
 #define plist_for_each_entry(pos, head, mem)	\
 	 list_for_each_entry(pos, &(head)->node_list, mem.node_list)
@@ -185,7 +185,7 @@ extern void plist_requeue(struct plist_node *node, struct plist_head *head);
  * plist_for_each_entry_continue - continue iteration over list of given type
  * @pos:	the type * to use as a loop cursor
  * @head:	the head for your list
- * @m:		the name of the list_struct within the struct
+ * @m:		the name of the list_head within the struct
  *
  * Continue to iterate over list of given type, continuing after
  * the current position.
@@ -198,7 +198,7 @@ extern void plist_requeue(struct plist_node *node, struct plist_head *head);
  * @pos:	the type * to use as a loop counter
  * @n:		another type * to use as temporary storage
  * @head:	the head for your list
- * @m:		the name of the list_struct within the struct
+ * @m:		the name of the list_head within the struct
  *
  * Iterate over list of given type, safe against removal of list entry.
  */
@@ -229,7 +229,7 @@ static inline int plist_node_empty(const struct plist_node *node)
  * plist_first_entry - get the struct for the first entry
  * @head:	the &struct plist_head pointer
  * @type:	the type of the struct this is embedded in
- * @member:	the name of the list_struct within the struct
+ * @member:	the name of the list_head within the struct
  */
 #ifdef CONFIG_DEBUG_PI_LIST
 # define plist_first_entry(head, type, member)	\
@@ -246,7 +246,7 @@ static inline int plist_node_empty(const struct plist_node *node)
  * plist_last_entry - get the struct for the last entry
  * @head:	the &struct plist_head pointer
  * @type:	the type of the struct this is embedded in
- * @member:	the name of the list_struct within the struct
+ * @member:	the name of the list_head within the struct
  */
 #ifdef CONFIG_DEBUG_PI_LIST
 # define plist_last_entry(head, type, member)	\
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 372ad5e..664060b 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -241,7 +241,7 @@ static inline void list_splice_init_rcu(struct list_head *list,
  * list_entry_rcu - get the struct for this entry
  * @ptr:        the &struct list_head pointer.
  * @type:       the type of the struct this is embedded in.
- * @member:     the name of the list_struct within the struct.
+ * @member:     the name of the list_head within the struct.
  *
  * This primitive may safely run concurrently with the _rcu list-mutation
  * primitives such as list_add_rcu() as long as it's guarded by rcu_read_lock().
@@ -278,7 +278,7 @@ static inline void list_splice_init_rcu(struct list_head *list,
  * list_first_or_null_rcu - get the first element from a list
  * @ptr:        the list head to take the element from.
  * @type:       the type of the struct this is embedded in.
- * @member:     the name of the list_struct within the struct.
+ * @member:     the name of the list_head within the struct.
  *
  * Note that if the list is empty, it returns NULL.
  *
@@ -296,7 +296,7 @@ static inline void list_splice_init_rcu(struct list_head *list,
  * list_for_each_entry_rcu	-	iterate over rcu list of given type
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  *
  * This list-traversal primitive may safely run concurrently with
  * the _rcu list-mutation primitives such as list_add_rcu()
@@ -311,7 +311,7 @@ static inline void list_splice_init_rcu(struct list_head *list,
  * list_for_each_entry_continue_rcu - continue iteration over list of given type
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  *
  * Continue to iterate over list of given type, continuing after
  * the current position.
diff --git a/scripts/kconfig/list.h b/scripts/kconfig/list.h
index 685d80e..2cf23f0 100644
--- a/scripts/kconfig/list.h
+++ b/scripts/kconfig/list.h
@@ -34,7 +34,7 @@ struct list_head {
  * list_entry - get the struct for this entry
  * @ptr:	the &struct list_head pointer.
  * @type:	the type of the struct this is embedded in.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  */
 #define list_entry(ptr, type, member) \
 	container_of(ptr, type, member)
@@ -43,7 +43,7 @@ struct list_head {
  * list_for_each_entry	-	iterate over list of given type
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  */
 #define list_for_each_entry(pos, head, member)				\
 	for (pos = list_entry((head)->next, typeof(*pos), member);	\
@@ -55,7 +55,7 @@ struct list_head {
  * @pos:	the type * to use as a loop cursor.
  * @n:		another type * to use as temporary storage
  * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  */
 #define list_for_each_entry_safe(pos, n, head, member)			\
 	for (pos = list_entry((head)->next, typeof(*pos), member),	\
diff --git a/tools/usb/usbip/libsrc/list.h b/tools/usb/usbip/libsrc/list.h
index 8d0c936..5eaaa78 100644
--- a/tools/usb/usbip/libsrc/list.h
+++ b/tools/usb/usbip/libsrc/list.h
@@ -98,7 +98,7 @@ static inline void list_del(struct list_head *entry)
  * list_entry - get the struct for this entry
  * @ptr:	the &struct list_head pointer.
  * @type:	the type of the struct this is embedded in.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_head within the struct.
  */
 #define list_entry(ptr, type, member) \
 	container_of(ptr, type, member)
-- 
1.8.5.5

