Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab3LWWEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 17:04:16 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:60677 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394Ab3LWV6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:58:55 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 14/27] drbd: Remove useless assertion
Date: Mon, 23 Dec 2013 22:50:43 +0100
Message-Id: <1387835456-29695-15-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
References: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@kernel.org>

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_state.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 1aef152..3f5c5a5 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1165,10 +1165,8 @@ static int w_after_state_ch(struct drbd_work *w, int unused)
 	struct drbd_device *device = w->device;
 
 	after_state_ch(device, ascw->os, ascw->ns, ascw->flags);
-	if (ascw->flags & CS_WAIT_COMPLETE) {
-		D_ASSERT(device, ascw->done != NULL);
+	if (ascw->flags & CS_WAIT_COMPLETE)
 		complete(ascw->done);
-	}
 	kfree(ascw);
 
 	return 0;
-- 
1.7.9.5

