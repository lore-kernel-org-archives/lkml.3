Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab3LWV6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 16:58:55 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:60638 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757962Ab3LWV6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:58:53 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 21/27] drbd: Make w_make_resync_request() static
Date: Mon, 23 Dec 2013 22:50:50 +0100
Message-Id: <1387835456-29695-22-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h    |    1 -
 drivers/block/drbd/drbd_worker.c |    4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 12dc970..2e262fd 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1316,7 +1316,6 @@ extern int w_e_end_ov_req(struct drbd_work *, int);
 extern int w_ov_finished(struct drbd_work *, int);
 extern int w_resync_timer(struct drbd_work *, int);
 extern int w_send_write_hint(struct drbd_work *, int);
-extern int w_make_resync_request(struct drbd_work *, int);
 extern int w_send_dblock(struct drbd_work *, int);
 extern int w_send_read_req(struct drbd_work *, int);
 extern int w_e_reissue(struct drbd_work *, int);
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index abcfdab..b0f6ae0 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -40,7 +40,7 @@
 #include "drbd_req.h"
 
 static int w_make_ov_request(struct drbd_work *, int);
-
+static int w_make_resync_request(struct drbd_work *, int);
 
 /* endio handlers:
  *   drbd_md_io_complete (defined here)
@@ -565,7 +565,7 @@ static int drbd_rs_number_requests(struct drbd_device *device)
 	return number;
 }
 
-int w_make_resync_request(struct drbd_work *w, int cancel)
+static int w_make_resync_request(struct drbd_work *w, int cancel)
 {
 	struct drbd_device_work *dw = device_work(w);
 	struct drbd_device *device = dw->device;
-- 
1.7.9.5

