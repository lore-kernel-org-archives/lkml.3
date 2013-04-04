Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763570Ab3DDGRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 02:17:12 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:62766 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756663Ab3DDGRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 02:17:10 -0400
MIME-Version: 1.0
Date: Thu, 4 Apr 2013 14:17:09 +0800
Message-ID: <CAPgLHd9NdpPH74owO-5=h7G2Qmhb5OJSWnuo=gPWHhnUbE6ULQ@mail.gmail.com>
Subject: [PATCH -next] drbd: fix error return code in drbd_init()
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
 drivers/block/drbd/drbd_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 1b93a726..768bca9 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2777,6 +2777,7 @@ int __init drbd_init(void)
 	drbd_proc = proc_create_data("drbd", S_IFREG | S_IRUGO , NULL, &drbd_proc_fops, NULL);
 	if (!drbd_proc)	{
 		printk(KERN_ERR "drbd: unable to register proc file\n");
+		err = -ENOMEM;
 		goto fail;
 	}
 
@@ -2786,6 +2787,7 @@ int __init drbd_init(void)
 	retry.wq = create_singlethread_workqueue("drbd-reissue");
 	if (!retry.wq) {
 		printk(KERN_ERR "drbd: unable to create retry workqueue\n");
+		err = -ENOMEM;
 		goto fail;
 	}
 	INIT_WORK(&retry.worker, do_retry);

