Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbaF3PxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:53:13 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:49988 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbaF3PxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:53:10 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 03/18] drbd: rename drbd_free_bc() to drbd_free_ldev()
Date: Mon, 30 Jun 2014 17:52:52 +0200
Message-Id: <1404143587-24344-4-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
References: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the member of drbd_device is called ldev

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  | 2 +-
 drivers/block/drbd/drbd_main.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index c87bc8e..82ece1b 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -950,7 +950,7 @@ extern int drbd_send_ov_request(struct drbd_peer_device *, sector_t sector, int
 extern int drbd_send_bitmap(struct drbd_device *device);
 extern void drbd_send_sr_reply(struct drbd_peer_device *, enum drbd_state_rv retcode);
 extern void conn_send_sr_reply(struct drbd_connection *connection, enum drbd_state_rv retcode);
-extern void drbd_free_bc(struct drbd_backing_dev *ldev);
+extern void drbd_free_ldev(struct drbd_backing_dev *ldev);
 extern void drbd_device_cleanup(struct drbd_device *device);
 void drbd_print_uuids(struct drbd_device *device, const char *text);
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index a6af935..8e0813d 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1992,7 +1992,7 @@ void drbd_device_cleanup(struct drbd_device *device)
 		drbd_bm_cleanup(device);
 	}
 
-	drbd_free_bc(device->ldev);
+	drbd_free_ldev(device->ldev);
 	device->ldev = NULL;
 
 	clear_bit(AL_SUSPENDED, &device->flags);
@@ -2187,7 +2187,7 @@ void drbd_destroy_device(struct kref *kref)
 	if (device->this_bdev)
 		bdput(device->this_bdev);
 
-	drbd_free_bc(device->ldev);
+	drbd_free_ldev(device->ldev);
 	device->ldev = NULL;
 
 	drbd_release_all_peer_reqs(device);
@@ -2960,7 +2960,7 @@ fail:
 	return err;
 }
 
-void drbd_free_bc(struct drbd_backing_dev *ldev)
+void drbd_free_ldev(struct drbd_backing_dev *ldev)
 {
 	if (ldev == NULL)
 		return;
@@ -3533,7 +3533,7 @@ void drbd_ldev_destroy(struct drbd_device *device)
 	lc_destroy(device->act_log);
 	device->act_log = NULL;
 	__no_warn(local,
-		drbd_free_bc(device->ldev);
+		drbd_free_ldev(device->ldev);
 		device->ldev = NULL;);
 
 	clear_bit(GO_DISKLESS, &device->flags);
-- 
1.9.1

