Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064AbaIKM3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:29:22 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:47800 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998AbaIKM3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:29:16 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 4/9] drbd: Avoid inconsistent locking warning
Date: Thu, 11 Sep 2014 14:29:08 +0200
Message-Id: <1410438553-30440-5-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410438553-30440-1-git-send-email-philipp.reisner@linbit.com>
References: <1410438553-30440-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

request_timer_fn() takes resource->req_lock via the device and releases it via
the connection.  Avoid this as it is confusing static code checkers.

Reported-by: "Dan Carpenter" <dan.carpenter@oracle.com>
Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_req.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index c67717d..5a01c53 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1645,6 +1645,6 @@ void request_timer_fn(unsigned long data)
 		? oldest_submit_jif + dt : now + et;
 	nt = time_before(ent, dt) ? ent : dt;
 out:
-	spin_unlock_irq(&connection->resource->req_lock);
+	spin_unlock_irq(&device->resource->req_lock);
 	mod_timer(&device->request_timer, nt);
 }
-- 
1.9.1

