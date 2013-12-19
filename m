Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab3LSPE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:04:58 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:48542 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab3LSPEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:04:54 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 21/38] workqueue: add missing put_device call
Date: Thu, 19 Dec 2013 16:03:32 +0100
Message-Id: <1387465429-3568-22-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387465429-3568-2-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that we give up the last reference to the device.
Remove the kfree() as that is the job of wq_device_release which will now
be called due to the reference count actually reaching zero.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 kernel/workqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 987293d..f3b3398 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3361,7 +3361,7 @@ int workqueue_sysfs_register(struct workqueue_struct *wq)
 
 	ret = device_register(&wq_dev->dev);
 	if (ret) {
-		kfree(wq_dev);
+		put_device(&wq_dev->dev);
 		wq->wq_dev = NULL;
 		return ret;
 	}
-- 
1.8.3.1

