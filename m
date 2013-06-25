Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab3FYOuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 10:50:22 -0400
Received: from mail09.linbit.com ([212.69.161.110]:50481 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab3FYOuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 10:50:13 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 2/6] drbd: fix error return code in drbd_init()
Date: Tue, 25 Jun 2013 16:50:04 +0200
Message-Id: <1372171808-30515-3-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372171808-30515-1-git-send-email-philipp.reisner@linbit.com>
References: <1372171808-30515-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_main.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index a5dca6a..49040a3 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2762,8 +2762,6 @@ int __init drbd_init(void)
 	/*
 	 * allocate all necessary structs
 	 */
-	err = -ENOMEM;
-
 	init_waitqueue_head(&drbd_pp_wait);
 
 	drbd_proc = NULL; /* play safe for drbd_cleanup */
@@ -2773,6 +2771,7 @@ int __init drbd_init(void)
 	if (err)
 		goto fail;
 
+	err = -ENOMEM;
 	drbd_proc = proc_create_data("drbd", S_IFREG | S_IRUGO , NULL, &drbd_proc_fops, NULL);
 	if (!drbd_proc)	{
 		printk(KERN_ERR "drbd: unable to register proc file\n");
@@ -2803,7 +2802,6 @@ int __init drbd_init(void)
 fail:
 	drbd_cleanup();
 	if (err == -ENOMEM)
-		/* currently always the case */
 		printk(KERN_ERR "drbd: ran out of memory\n");
 	else
 		printk(KERN_ERR "drbd: initialization failure\n");
-- 
1.7.9.5

