Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab3LWWFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 17:05:08 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:60668 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758105Ab3LWV6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:58:54 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 09/27] drbd: Function prototype cleanups
Date: Mon, 23 Dec 2013 22:50:38 +0100
Message-Id: <1387835456-29695-10-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
References: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    2 ++
 drivers/block/drbd/drbd_main.c |    5 -----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index d7eade8..c9eea4d 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1340,6 +1340,8 @@ extern void resync_timer_fn(unsigned long data);
 extern void start_resync_timer_fn(unsigned long data);
 
 /* drbd_receiver.c */
+extern int drbd_receiver(struct drbd_thread *thi);
+extern int drbd_asender(struct drbd_thread *thi);
 extern int drbd_rs_should_slow_down(struct drbd_device *device, sector_t sector);
 extern int drbd_submit_peer_request(struct drbd_device *,
 				    struct drbd_peer_request *, const unsigned,
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index a2003cd..a7f992f 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -58,11 +58,6 @@
 #include "drbd_vli.h"
 
 static DEFINE_MUTEX(drbd_main_mutex);
-int drbd_receiver(struct drbd_thread *);
-int drbd_worker(struct drbd_thread *);
-int drbd_asender(struct drbd_thread *);
-
-int drbd_init(void);
 static int drbd_open(struct block_device *bdev, fmode_t mode);
 static void drbd_release(struct gendisk *gd, fmode_t mode);
 static int w_md_sync(struct drbd_work *w, int unused);
-- 
1.7.9.5

