Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab3LTMlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 07:41:42 -0500
Received: from mail09.linbit.com ([212.69.161.110]:38662 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab3LTMjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 07:39:35 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 16/26] drbd: conn_try_disconnect(): Use parameter instead of the global variable
Date: Fri, 20 Dec 2013 13:29:13 +0100
Message-Id: <1387542563-6833-17-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
References: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index d7c7c24..e804487 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2317,7 +2317,7 @@ static enum drbd_state_rv conn_try_disconnect(struct drbd_connection *connection
 		 * The state handling only uses drbd_thread_stop_nowait(),
 		 * we want to really wait here until the receiver is no more.
 		 */
-		drbd_thread_stop(&adm_ctx.connection->receiver);
+		drbd_thread_stop(&connection->receiver);
 
 		/* Race breaker.  This additional state change request may be
 		 * necessary, if this was a forced disconnect during a receiver
-- 
1.7.9.5

