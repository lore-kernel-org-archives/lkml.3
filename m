Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab3C0NJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:09:24 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44220 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab3C0NJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:09:19 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com, Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: [PATCH 02/17] drbd: reset ap_in_flight counter for new connections
Date: Wed, 27 Mar 2013 14:08:34 +0100
Message-Id: <1364389729-17559-3-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
References: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 1921871..cd172b4 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -849,6 +849,7 @@ int drbd_connected(struct drbd_conf *mdev)
 		err = drbd_send_current_state(mdev);
 	clear_bit(USE_DEGR_WFC_T, &mdev->flags);
 	clear_bit(RESIZE_PENDING, &mdev->flags);
+	atomic_set(&mdev->ap_in_flight, 0);
 	mod_timer(&mdev->request_timer, jiffies + HZ); /* just start it here. */
 	return err;
 }
-- 
1.7.9.5

