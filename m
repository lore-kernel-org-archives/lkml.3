Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaCVUaV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 16:30:21 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:58597 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbaCVUaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 16:30:14 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [PATCH] block: Use RCU_INIT_POINTER(x, NULL) in blk-ioc.c
Date: Sun, 23 Mar 2014 01:59:14 +0530
Message-Id: <1395520154-2815-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)

The rcu_assign_pointer() ensures that the initialization of a structure 
is carried out before storing a pointer to that structure. 
And in the case of the NULL pointer, there is no structure to initialize.
So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 block/blk-ioc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 242df01..6585186 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -69,7 +69,7 @@ static void ioc_destroy_icq(struct io_cq *icq)
 	 * will.  Hint assignment itself can race safely.
 	 */
 	if (rcu_dereference_raw(ioc->icq_hint) == icq)
-		rcu_assign_pointer(ioc->icq_hint, NULL);
+		RCU_INIT_POINTER(ioc->icq_hint, NULL);
 
 	ioc_exit_icq(icq);
 
-- 
1.7.9.5

