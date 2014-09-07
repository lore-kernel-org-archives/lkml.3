Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbaIGXFd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 19:05:33 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:52264 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbaIGXEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 19:04:11 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/6] bdi: remove unused stuff
Date: Mon,  8 Sep 2014 08:03:57 +0900
Message-Id: <1410131041-1881-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410131041-1881-1-git-send-email-tj@kernel.org>
References: <1410131041-1881-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two flags and one bdi_writeback field are no longer used.  Remove
them.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/backing-dev.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index e488e94..2103a7f 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -28,12 +28,10 @@ struct dentry;
  * Bits in backing_dev_info.state
  */
 enum bdi_state {
-	BDI_wb_alloc,		/* Default embedded wb allocated */
 	BDI_async_congested,	/* The async (write) queue is getting full */
 	BDI_sync_congested,	/* The sync queue is getting full */
 	BDI_registered,		/* bdi_register() was done */
 	BDI_writeback_running,	/* Writeback is in progress */
-	BDI_unused,		/* Available bits start here */
 };
 
 typedef int (congested_fn)(void *, int);
@@ -50,7 +48,6 @@ enum bdi_stat_item {
 
 struct bdi_writeback {
 	struct backing_dev_info *bdi;	/* our parent bdi */
-	unsigned int nr;
 
 	unsigned long last_old_flush;	/* last old data flush */
 
-- 
1.9.3

