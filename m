Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328AbaD2RRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 13:17:35 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:32802 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758311AbaD2RRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 13:17:33 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao4WAAvcX1NbsnvL/2dsb2JhbABZgwasGwUBAQEEAZlzAgKBJBd0glMTHCMYgQIkE4hFAck1hVWII1eEQAEDjwCKDwGSYoMzO4Et
Date: Tue, 29 Apr 2014 19:19:34 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Joel Becker <jlbec@evilplan.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/configs/item.c: kernel-doc fixes + clean-up
Message-Id: <20140429191934.a4568129c64fa1ec2ac72771@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Fix function parameter documentation
-EXPORT_SYMBOLS moved after corresponding functions
-Small coding style and checkpatch warning fixes

Cc: Joel Becker <jlbec@evilplan.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/configfs/item.c | 58 ++++++++++++++++++++++++++----------------------------
 1 file changed, 28 insertions(+), 30 deletions(-)

diff --git a/fs/configfs/item.c b/fs/configfs/item.c
index 50cee7f..e65f9ff 100644
--- a/fs/configfs/item.c
+++ b/fs/configfs/item.c
@@ -19,7 +19,7 @@
  * Boston, MA 021110-1307, USA.
  *
  * Based on kobject:
- * 	kobject is Copyright (c) 2002-2003 Patrick Mochel
+ *	kobject is Copyright (c) 2002-2003 Patrick Mochel
  *
  * configfs Copyright (C) 2005 Oracle.  All rights reserved.
  *
@@ -35,9 +35,9 @@
 #include <linux/configfs.h>
 
 
-static inline struct config_item * to_item(struct list_head * entry)
+static inline struct config_item *to_item(struct list_head *entry)
 {
-	return container_of(entry,struct config_item,ci_entry);
+	return container_of(entry, struct config_item, ci_entry);
 }
 
 /* Evil kernel */
@@ -47,34 +47,35 @@ static void config_item_release(struct kref *kref);
  *	config_item_init - initialize item.
  *	@item:	item in question.
  */
-void config_item_init(struct config_item * item)
+void config_item_init(struct config_item *item)
 {
 	kref_init(&item->ci_kref);
 	INIT_LIST_HEAD(&item->ci_entry);
 }
+EXPORT_SYMBOL(config_item_init);
 
 /**
  *	config_item_set_name - Set the name of an item
  *	@item:	item.
- *	@name:	name.
+ *	@fmt:  The vsnprintf()'s format string.
  *
  *	If strlen(name) >= CONFIGFS_ITEM_NAME_LEN, then use a
  *	dynamically allocated string that @item->ci_name points to.
  *	Otherwise, use the static @item->ci_namebuf array.
  */
-int config_item_set_name(struct config_item * item, const char * fmt, ...)
+int config_item_set_name(struct config_item *item, const char *fmt, ...)
 {
 	int error = 0;
 	int limit = CONFIGFS_ITEM_NAME_LEN;
 	int need;
 	va_list args;
-	char * name;
+	char *name;
 
 	/*
 	 * First, try the static array
 	 */
-	va_start(args,fmt);
-	need = vsnprintf(item->ci_namebuf,limit,fmt,args);
+	va_start(args, fmt);
+	need = vsnprintf(item->ci_namebuf, limit, fmt, args);
 	va_end(args);
 	if (need < limit)
 		name = item->ci_namebuf;
@@ -83,13 +84,13 @@ int config_item_set_name(struct config_item * item, const char * fmt, ...)
 		 * Need more space? Allocate it and try again
 		 */
 		limit = need + 1;
-		name = kmalloc(limit,GFP_KERNEL);
+		name = kmalloc(limit, GFP_KERNEL);
 		if (!name) {
 			error = -ENOMEM;
 			goto Done;
 		}
-		va_start(args,fmt);
-		need = vsnprintf(name,limit,fmt,args);
+		va_start(args, fmt);
+		need = vsnprintf(name, limit, fmt, args);
 		va_end(args);
 
 		/* Still? Give up. */
@@ -109,7 +110,6 @@ int config_item_set_name(struct config_item * item, const char * fmt, ...)
  Done:
 	return error;
 }
-
 EXPORT_SYMBOL(config_item_set_name);
 
 void config_item_init_type_name(struct config_item *item,
@@ -131,20 +131,21 @@ void config_group_init_type_name(struct config_group *group, const char *name,
 }
 EXPORT_SYMBOL(config_group_init_type_name);
 
-struct config_item * config_item_get(struct config_item * item)
+struct config_item *config_item_get(struct config_item *item)
 {
 	if (item)
 		kref_get(&item->ci_kref);
 	return item;
 }
+EXPORT_SYMBOL(config_item_get);
 
-static void config_item_cleanup(struct config_item * item)
+static void config_item_cleanup(struct config_item *item)
 {
-	struct config_item_type * t = item->ci_type;
-	struct config_group * s = item->ci_group;
-	struct config_item * parent = item->ci_parent;
+	struct config_item_type *t = item->ci_type;
+	struct config_group *s = item->ci_group;
+	struct config_item *parent = item->ci_parent;
 
-	pr_debug("config_item %s: cleaning up\n",config_item_name(item));
+	pr_debug("config_item %s: cleaning up\n", config_item_name(item));
 	if (item->ci_name != item->ci_namebuf)
 		kfree(item->ci_name);
 	item->ci_name = NULL;
@@ -167,21 +168,23 @@ static void config_item_release(struct kref *kref)
  *
  *	Decrement the refcount, and if 0, call config_item_cleanup().
  */
-void config_item_put(struct config_item * item)
+void config_item_put(struct config_item *item)
 {
 	if (item)
 		kref_put(&item->ci_kref, config_item_release);
 }
+EXPORT_SYMBOL(config_item_put);
 
 /**
  *	config_group_init - initialize a group for use
- *	@k:	group
+ *	@group:	config_group
  */
 void config_group_init(struct config_group *group)
 {
 	config_item_init(&group->cg_item);
 	INIT_LIST_HEAD(&group->cg_children);
 }
+EXPORT_SYMBOL(config_group_init);
 
 /**
  *	config_group_find_item - search for item in group.
@@ -195,11 +198,11 @@ void config_group_init(struct config_group *group)
 struct config_item *config_group_find_item(struct config_group *group,
 					   const char *name)
 {
-	struct list_head * entry;
-	struct config_item * ret = NULL;
+	struct list_head *entry;
+	struct config_item *ret = NULL;
 
-	list_for_each(entry,&group->cg_children) {
-		struct config_item * item = to_item(entry);
+	list_for_each(entry, &group->cg_children) {
+		struct config_item *item = to_item(entry);
 		if (config_item_name(item) &&
 		    !strcmp(config_item_name(item), name)) {
 			ret = config_item_get(item);
@@ -208,9 +211,4 @@ struct config_item *config_group_find_item(struct config_group *group,
 	}
 	return ret;
 }
-
-EXPORT_SYMBOL(config_item_init);
-EXPORT_SYMBOL(config_group_init);
-EXPORT_SYMBOL(config_item_get);
-EXPORT_SYMBOL(config_item_put);
 EXPORT_SYMBOL(config_group_find_item);
-- 
1.8.4.5

