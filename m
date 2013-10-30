Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab3J3NNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:13:43 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:40071 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab3J3NNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:13:42 -0400
From: Rashika Kheria <rashika.kheria@gmail.com>
To: opw-kernel@googlegroups.com, Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v8 3/3] Staging: zram: Fix variable dereferenced before check
Date: Wed, 30 Oct 2013 18:43:32 +0530
Message-Id: <a73fda4aab5db355a97488d6a87d20b8e1778b5c.1383138164.git.rashika.kheria@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20131019110539.GA25167@gmail.com>
References: <20131019110539.GA25167@gmail.com>
In-Reply-To: <3d7e050910ca994862e7880b4bd3681267681b56.1383138164.git.rashika.kheria@gmail.com>
References: <3d7e050910ca994862e7880b4bd3681267681b56.1383138164.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following Smatch warning in zram_drv.c-
drivers/staging/zram/zram_drv.c:899
destroy_device() warn: variable dereferenced before check 'zram->disk' (see line 896)

Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---

This revision fixes the following issues of the previous revision-
Removes Cc to stable@vger.kernel.org as it is just a Smatch warning fix

 drivers/staging/zram/zram_drv.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 0bc2835..cfa1d2e 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -909,13 +909,10 @@ static void destroy_device(struct zram *zram)
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

