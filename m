Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab3BFUNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:13:55 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:35999 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757896Ab3BFTt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:49:27 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/77] block/loop: don't use idr_remove_all()
Date: Wed,  6 Feb 2013 11:39:36 -0800
Message-Id: <1360179649-22465-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop its usage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 drivers/block/loop.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index ae12512..3b9c32b 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1911,7 +1911,6 @@ static void __exit loop_exit(void)
 	range = max_loop ? max_loop << part_shift : 1UL << MINORBITS;
 
 	idr_for_each(&loop_index_idr, &loop_exit_cb, NULL);
-	idr_remove_all(&loop_index_idr);
 	idr_destroy(&loop_index_idr);
 
 	blk_unregister_region(MKDEV(LOOP_MAJOR, 0), range);
-- 
1.8.1

