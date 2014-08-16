Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaHPPzp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 11:55:45 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:9513 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbaHPPzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 11:55:44 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: axboe@fb.com, Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] brd: add ram disk visibility option
Date: Sat, 16 Aug 2014 19:55:30 +0400
Message-Id: <1408204530-16726-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index c7d138e..3598110 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -442,12 +442,15 @@ static int rd_nr;
 int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
 static int max_part;
 static int part_shift;
+static int part_show = 0;
 module_param(rd_nr, int, S_IRUGO);
 MODULE_PARM_DESC(rd_nr, "Maximum number of brd devices");
 module_param(rd_size, int, S_IRUGO);
 MODULE_PARM_DESC(rd_size, "Size of each RAM disk in kbytes.");
 module_param(max_part, int, S_IRUGO);
 MODULE_PARM_DESC(max_part, "Maximum number of partitions per RAM disk");
+module_param(part_show, int, S_IRUGO);
+MODULE_PARM_DESC(part_show, "Control RAM disk visibility in /proc/partitions");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(RAMDISK_MAJOR);
 MODULE_ALIAS("rd");
@@ -501,7 +504,8 @@ static struct brd_device *brd_alloc(int i)
 	disk->fops		= &brd_fops;
 	disk->private_data	= brd;
 	disk->queue		= brd->brd_queue;
-	disk->flags |= GENHD_FL_SUPPRESS_PARTITION_INFO;
+	if (!part_show)
+		disk->flags |= GENHD_FL_SUPPRESS_PARTITION_INFO;
 	sprintf(disk->disk_name, "ram%d", i);
 	set_capacity(disk, rd_size * 2);
 
-- 
1.7.1

