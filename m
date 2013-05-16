Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab3EPUgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 16:36:14 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:56753 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab3EPUgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 16:36:12 -0400
From: bmheight@gmail.com
To: gregkh@linuxfoundation.org
Cc: john.stultz@linaro.org, konkers@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Brandon Height <bmheight@gmail.com>
Subject: [PATCH 2/2] Staging: android: sync: use seq_puts()/seq_putc() to follow coding style
Date: Thu, 16 May 2013 10:30:02 -1000
Message-Id: <1368736202-10673-1-git-send-email-bmheight@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brandon Height <bmheight@gmail.com>

Utilized seq_puts() for strings without format specifiers.
Utilized seq_putc() for seq_printf(s, "\n")

Signed-off-by: Brandon Height <bmheight@gmail.com>
---
 drivers/staging/android/sync.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index 36ed35e..a7891e6 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -875,11 +875,11 @@ static void sync_print_pt(struct seq_file *s, struct sync_pt *pt, bool fence)
 			seq_printf(s, " / %s", value);
 		}
 	} else if (pt->parent->ops->print_pt) {
-		seq_printf(s, ": ");
+		seq_puts(s, ": ");
 		pt->parent->ops->print_pt(s, pt);
 	}
 
-	seq_printf(s, "\n");
+	seq_putc(s, '\n');
 }
 
 static void sync_print_obj(struct seq_file *s, struct sync_timeline *obj)
@@ -894,11 +894,11 @@ static void sync_print_obj(struct seq_file *s, struct sync_timeline *obj)
 		obj->ops->timeline_value_str(obj, value, sizeof(value));
 		seq_printf(s, ": %s", value);
 	} else if (obj->ops->print_obj) {
-		seq_printf(s, ": ");
+		seq_puts(s, ": ");
 		obj->ops->print_obj(s, obj);
 	}
 
-	seq_printf(s, "\n");
+	seq_putc(s, '\n');
 
 	spin_lock_irqsave(&obj->child_list_lock, flags);
 	list_for_each(pos, &obj->child_list_head) {
@@ -939,7 +939,7 @@ static int sync_debugfs_show(struct seq_file *s, void *unused)
 	unsigned long flags;
 	struct list_head *pos;
 
-	seq_printf(s, "objs:\n--------------\n");
+	seq_puts(s, "objs:\n--------------\n");
 
 	spin_lock_irqsave(&sync_timeline_list_lock, flags);
 	list_for_each(pos, &sync_timeline_list_head) {
@@ -948,11 +948,11 @@ static int sync_debugfs_show(struct seq_file *s, void *unused)
 				     sync_timeline_list);
 
 		sync_print_obj(s, obj);
-		seq_printf(s, "\n");
+		seq_putc(s, '\n');
 	}
 	spin_unlock_irqrestore(&sync_timeline_list_lock, flags);
 
-	seq_printf(s, "fences:\n--------------\n");
+	seq_puts(s, "fences:\n--------------\n");
 
 	spin_lock_irqsave(&sync_fence_list_lock, flags);
 	list_for_each(pos, &sync_fence_list_head) {
@@ -960,7 +960,7 @@ static int sync_debugfs_show(struct seq_file *s, void *unused)
 			container_of(pos, struct sync_fence, sync_fence_list);
 
 		sync_print_fence(s, fence);
-		seq_printf(s, "\n");
+		seq_putc(s, '\n');
 	}
 	spin_unlock_irqrestore(&sync_fence_list_lock, flags);
 	return 0;
-- 
1.8.1.2

