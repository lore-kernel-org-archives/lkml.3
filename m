Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933540Ab3CGVoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 16:44:22 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:63667 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759861Ab3CGVoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 16:44:19 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, laijs@cn.fujitsu.com, fengguang.wu@intel.com
Cc: linux-kernel@vger.kernel.org, jmoyer@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/4] writeback: remove unused bdi_pending_list
Date: Thu,  7 Mar 2013 13:44:07 -0800
Message-Id: <1362692649-25570-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362692649-25570-1-git-send-email-tj@kernel.org>
References: <1362692649-25570-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no user left.  Remove it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Fengguang Wu <fengguang.wu@intel.com>
---
 include/linux/backing-dev.h | 1 -
 mm/backing-dev.c            | 4 +---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 3504599..a5ef27f 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -130,7 +130,6 @@ void bdi_lock_two(struct bdi_writeback *wb1, struct bdi_writeback *wb2);
 
 extern spinlock_t bdi_lock;
 extern struct list_head bdi_list;
-extern struct list_head bdi_pending_list;
 
 static inline int wb_has_dirty_io(struct bdi_writeback *wb)
 {
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 41733c5..657569b 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -31,13 +31,11 @@ EXPORT_SYMBOL_GPL(noop_backing_dev_info);
 static struct class *bdi_class;
 
 /*
- * bdi_lock protects updates to bdi_list and bdi_pending_list, as well as
- * reader side protection for bdi_pending_list. bdi_list has RCU reader side
+ * bdi_lock protects updates to bdi_list. bdi_list has RCU reader side
  * locking.
  */
 DEFINE_SPINLOCK(bdi_lock);
 LIST_HEAD(bdi_list);
-LIST_HEAD(bdi_pending_list);
 
 void bdi_lock_two(struct bdi_writeback *wb1, struct bdi_writeback *wb2)
 {
-- 
1.8.1.4

