Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab3J2XPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 19:15:36 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:60902 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab3J2XPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 19:15:34 -0400
From: Rashika Kheria <rashika.kheria@gmail.com>
To: opw-kernel@googlegroups.com, Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH v7 3/3] Staging: zram: Fix variable dereferenced before check
Date: Wed, 30 Oct 2013 04:45:24 +0530
Message-Id: <a40fc8ee88e324a8f5ee5c79750e160b5c16288c.1383087326.git.rashika.kheria@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20131019110539.GA25167@gmail.com>
References: <20131019110539.GA25167@gmail.com>
In-Reply-To: <cc16130b4e23207971139eff313a4ec71f51c187.1383087326.git.rashika.kheria@gmail.com>
References: <cc16130b4e23207971139eff313a4ec71f51c187.1383087326.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following Smatch warning in zram_drv.c-
drivers/staging/zram/zram_drv.c:899
destroy_device() warn: variable dereferenced before check 'zram->disk' (see line 896)

Cc: stable@vger.kernel.org
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/staging/zram/zram_drv.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 592e760..bf28d56 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -901,13 +901,10 @@ static void destroy_device(struct zram *zram)
 	sysfs_remove_group(&disk_to_dev(zram->disk)->kobj,
 			&zram_disk_attr_group);
 
-	if (zram->disk) {
-		del_gendisk(zram->disk);
-		put_disk(zram->disk);
-	}
+	del_gendisk(zram->disk);
+	put_disk(zram->disk);
 
-	if (zram->queue)
-		blk_cleanup_queue(zram->queue);
+	blk_cleanup_queue(zram->queue);
 }
 
 static int __init zram_init(void)
-- 
1.7.9.5

