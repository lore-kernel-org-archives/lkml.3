Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab3C0NJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:09:52 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44313 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab3C0NJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:09:25 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com, Lars Ellenberg <lars.ellenberg@linbit.com>,
        Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 17/17] drbd: fix if(); found by kbuild test robot
Date: Wed, 27 Mar 2013 14:08:49 +0100
Message-Id: <1364389729-17559-18-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
References: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Recently introduced al_begin_io_nonblock() was returning -EBUSY,
even when it should return -EWOULDBLOCK.

Impact:
A few spurious wake_up() calls in prepare_al_transaction_nonblock().

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 6afe173..6608076 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -389,7 +389,7 @@ int drbd_al_begin_io_nonblock(struct drbd_conf *mdev, struct drbd_interval *i)
 		if (unlikely(tmp != NULL)) {
 			struct bm_extent  *bm_ext = lc_entry(tmp, struct bm_extent, lce);
 			if (test_bit(BME_NO_WRITES, &bm_ext->flags)) {
-				if (!test_and_set_bit(BME_PRIORITY, &bm_ext->flags));
+				if (!test_and_set_bit(BME_PRIORITY, &bm_ext->flags))
 					return -EBUSY;
 				return -EWOULDBLOCK;
 			}
-- 
1.7.9.5

