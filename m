Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab3FEUY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:24:57 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:53185 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234Ab3FEUY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:24:56 -0400
From: Aldo Iljazi <neonsync1@gmail.com>
To: gregh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Aldo Iljazi <neonsync1@gmail.com>
Subject: [PATCH] Staging: anrdroid: sync.c: fixed all checkpatch errors and warnings
Date: Wed,  5 Jun 2013 23:23:47 +0300
Message-Id: <1370463827-6881-1-git-send-email-neonsync1@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Aldo Iljazi <neonsync1@gmail.com>
---
 drivers/staging/android/sync.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index 3893a35..8bd5bf3 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -125,9 +125,8 @@ static void sync_timeline_remove_pt(struct sync_pt *pt)
 	spin_unlock_irqrestore(&obj->active_list_lock, flags);
 
 	spin_lock_irqsave(&obj->child_list_lock, flags);
-	if (!list_empty(&pt->child_list)) {
+	if (!list_empty(&pt->child_list))
 		list_del_init(&pt->child_list);
-	}
 	spin_unlock_irqrestore(&obj->child_list_lock, flags);
 }
 
@@ -876,11 +875,11 @@ static void sync_print_pt(struct seq_file *s, struct sync_pt *pt, bool fence)
 			seq_printf(s, " / %s", value);
 		}
 	} else if (pt->parent->ops->print_pt) {
-		seq_printf(s, ": ");
+		seq_puts(s, ": ");
 		pt->parent->ops->print_pt(s, pt);
 	}
 
-	seq_printf(s, "\n");
+	seq_puts(s, "\n");
 }
 
 static void sync_print_obj(struct seq_file *s, struct sync_timeline *obj)
@@ -893,13 +892,13 @@ static void sync_print_obj(struct seq_file *s, struct sync_timeline *obj)
 	if (obj->ops->timeline_value_str) {
 		char value[64];
 		obj->ops->timeline_value_str(obj, value, sizeof(value));
-		seq_printf(s, ": %s", value);
+		seq_puts(s, ": %s", value);
 	} else if (obj->ops->print_obj) {
-		seq_printf(s, ": ");
+		seq_puts(s, ": ");
 		obj->ops->print_obj(s, obj);
 	}
 
-	seq_printf(s, "\n");
+	seq_puts(s, "\n");
 
 	spin_lock_irqsave(&obj->child_list_lock, flags);
 	list_for_each(pos, &obj->child_list_head) {
@@ -940,7 +939,7 @@ static int sync_debugfs_show(struct seq_file *s, void *unused)
 	unsigned long flags;
 	struct list_head *pos;
 
-	seq_printf(s, "objs:\n--------------\n");
+	seq_puts(s, "objs:\n--------------\n");
 
 	spin_lock_irqsave(&sync_timeline_list_lock, flags);
 	list_for_each(pos, &sync_timeline_list_head) {
@@ -949,11 +948,11 @@ static int sync_debugfs_show(struct seq_file *s, void *unused)
 				     sync_timeline_list);
 
 		sync_print_obj(s, obj);
-		seq_printf(s, "\n");
+		seq_puts(s, "\n");
 	}
 	spin_unlock_irqrestore(&sync_timeline_list_lock, flags);
 
-	seq_printf(s, "fences:\n--------------\n");
+	seq_puts(s, "fences:\n--------------\n");
 
 	spin_lock_irqsave(&sync_fence_list_lock, flags);
 	list_for_each(pos, &sync_fence_list_head) {
@@ -961,7 +960,7 @@ static int sync_debugfs_show(struct seq_file *s, void *unused)
 			container_of(pos, struct sync_fence, sync_fence_list);
 
 		sync_print_fence(s, fence);
-		seq_printf(s, "\n");
+		seq_puts(s, "\n");
 	}
 	spin_unlock_irqrestore(&sync_fence_list_lock, flags);
 	return 0;
-- 
1.7.10.4

