Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab3J1MXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 08:23:54 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:41334 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403Ab3J1MXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:23:53 -0400
From: Rashika Kheria <rashika.kheria@gmail.com>
To: opw-kernel@googlegroups.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minchan Kim <minchan@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v6 2/3] Staging: zram: Fix variable dereferenced before check
Date: Mon, 28 Oct 2013 17:53:40 +0530
Message-Id: <01cafd6f9a98d41c243ae507ae731edc5cca045a.1382962788.git.rashika.kheria@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20131019110539.GA25167@gmail.com>
References: <20131019110539.GA25167@gmail.com>
In-Reply-To: <cc16130b4e23207971139eff313a4ec71f51c187.1382962788.git.rashika.kheria@gmail.com>
References: <cc16130b4e23207971139eff313a4ec71f51c187.1382962788.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following Smatch warning in zram_drv.c-
drivers/staging/zram/zram_drv.c:899
destroy_device() warn: variable dereferenced before check 'zram->disk' (see line 896)

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---

This revision fixes the following issues of the previous revision-
Seperating patches into Bug fix and Smatch fix 

 drivers/staging/zram/zram_drv.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index d640a8f..9027975 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -898,13 +898,10 @@ static void destroy_device(struct zram *zram)
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

