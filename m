Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbaJMSge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 14:36:34 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:2683 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225AbaJMSgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 14:36:33 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: axboe@fb.com, keith.busch@intel.com,
        Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] block: update locking context for blk_free_devt
Date: Mon, 13 Oct 2014 22:35:57 +0400
Message-Id: <1413225357-18981-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After 2da78092 this function will not longer sleepy

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 block/genhd.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 09da5e4..ae9aaa5 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -441,12 +441,10 @@ int blk_alloc_devt(struct hd_struct *part, dev_t *devt)
  * Free @devt which was allocated using blk_alloc_devt().
  *
  * CONTEXT:
- * Might sleep.
+ * Don't care.
  */
 void blk_free_devt(dev_t devt)
 {
-	might_sleep();
-
 	if (devt == MKDEV(0, 0))
 		return;
 
-- 
1.7.1

