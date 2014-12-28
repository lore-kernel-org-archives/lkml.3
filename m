Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbaL1QMt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 11:12:49 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:40998 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaL1QMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 11:12:47 -0500
From: Aniroop Mathur <aniroop.mathur@gmail.com>
To: <schwidefsky@de.ibm.com>, <heiko.carstens@de.ibm.com>,
        <linux390@de.ibm.com>, <linux-s390@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Cc: <aniroop.mathur@gmail.com>, <a.mathur@samsung.com>
Subject: [PATCH] s390: Initialize nr_devices count variable to -1
Date: Sun, 28 Dec 2014 21:42:53 +0530
Message-Id: <1419783173-3066-1-git-send-email-aniroop.mathur@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aniroop Mathur <a.mathur@samsung.com>

This patch initializes nr_device count variable to -1 to avoid extra
subtraction operation performed everytime scm block device is set up.

Signed-off-by: Aniroop Mathur <a.mathur@samsung.com>
---
 drivers/s390/block/scm_blk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/block/scm_blk.c b/drivers/s390/block/scm_blk.c
index 76bed17..ee2bd6f 100644
--- a/drivers/s390/block/scm_blk.c
+++ b/drivers/s390/block/scm_blk.c
@@ -23,7 +23,7 @@ static int scm_major;
 static DEFINE_SPINLOCK(list_lock);
 static LIST_HEAD(inactive_requests);
 static unsigned int nr_requests = 64;
-static atomic_t nr_devices = ATOMIC_INIT(0);
+static atomic_t nr_devices = ATOMIC_INIT(-1);
 module_param(nr_requests, uint, S_IRUGO);
 MODULE_PARM_DESC(nr_requests, "Number of parallel requests.");
 
@@ -357,7 +357,7 @@ int scm_blk_dev_setup(struct scm_blk_dev *bdev, struct scm_device *scmdev)
 	int len, ret = -ENOMEM;
 	unsigned int devindex, nr_max_blk;
 
-	devindex = atomic_inc_return(&nr_devices) - 1;
+	devindex = atomic_inc_return(&nr_devices);
 	/* scma..scmz + scmaa..scmzz */
 	if (devindex > 701) {
 		ret = -ENODEV;
-- 
1.9.1

