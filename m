Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbaF3P4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:56:07 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:50044 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbaF3PxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:53:14 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 14/18] drbd: explicitly submit meta data requests with REQ_NOIDLE
Date: Mon, 30 Jun 2014 17:53:03 +0200
Message-Id: <1404143587-24344-15-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
References: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

For some reason we have assumed NOIDLE was implied
by one of the other flags we set. It is not (anymore?).
Explicitly set REQ_NOIDLE for synchronous meta data updates,
or we can seriously starve random writes when using CFQ.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 278c31f..14b2f27 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -150,7 +150,7 @@ static int _drbd_md_sync_page_io(struct drbd_device *device,
 
 	if ((rw & WRITE) && !test_bit(MD_NO_FUA, &device->flags))
 		rw |= REQ_FUA | REQ_FLUSH;
-	rw |= REQ_SYNC;
+	rw |= REQ_SYNC | REQ_NOIDLE;
 
 	bio = bio_alloc_drbd(GFP_NOIO);
 	bio->bi_bdev = bdev->md_bdev;
-- 
1.9.1

