Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab3DFEid (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 00:38:33 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:40335 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab3DFEic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 00:38:32 -0400
MIME-Version: 1.0
Date: Sat, 6 Apr 2013 12:38:30 +0800
Message-ID: <CAPgLHd_TF5QwAL3Bibr7rPdRtJoCqmQQWNtHiH0GP7a8hnK5xA@mail.gmail.com>
Subject: [PATCH -next v2] drbd: fix error return code in drbd_init()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: drbd-dev@lists.linbit.com
Cc: yongjun_wei@trendmicro.com.cn, drbd-user@lists.linbit.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/block/drbd/drbd_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 1b93a726..93b3505 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2763,8 +2763,6 @@ int __init drbd_init(void)
 	/*
 	 * allocate all necessary structs
 	 */
-	err = -ENOMEM;
-
 	init_waitqueue_head(&drbd_pp_wait);
 
 	drbd_proc = NULL; /* play safe for drbd_cleanup */
@@ -2774,6 +2772,7 @@ int __init drbd_init(void)
 	if (err)
 		goto fail;
 
+	err = -ENOMEM;
 	drbd_proc = proc_create_data("drbd", S_IFREG | S_IRUGO , NULL, &drbd_proc_fops, NULL);
 	if (!drbd_proc)	{
 		printk(KERN_ERR "drbd: unable to register proc file\n");
@@ -2804,7 +2803,6 @@ int __init drbd_init(void)
 fail:
 	drbd_cleanup();
 	if (err == -ENOMEM)
-		/* currently always the case */
 		printk(KERN_ERR "drbd: ran out of memory\n");
 	else
 		printk(KERN_ERR "drbd: initialization failure\n");

