Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab3AZBbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 20:31:42 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:37324 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab3AZBbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 20:31:23 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 03/14] block/loop: don't use idr_remove_all()
Date: Fri, 25 Jan 2013 17:31:01 -0800
Message-Id: <1359163872-1949-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359163872-1949-1-git-send-email-tj@kernel.org>
References: <1359163872-1949-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop its usage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
This patch depends on an earlier idr patch and given the trivial
nature of the patch, I think it would be best to route these together
through -mm.  Please holler if there's any objection.

Thanks.

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

