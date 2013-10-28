Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab3J1MYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 08:24:51 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:64578 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756313Ab3J1MYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:24:50 -0400
From: Rashika Kheria <rashika.kheria@gmail.com>
To: opw-kernel@googlegroups.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minchan Kim <minchan@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v6 3/3] Staging: zram: Fix decrement of variable by calling bdput()
Date: Mon, 28 Oct 2013 17:54:39 +0530
Message-Id: <7d016b6c725b88e5f61e21daaacf6c2e205537e0.1382962788.git.rashika.kheria@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20131019110539.GA25167@gmail.com>
References: <20131019110539.GA25167@gmail.com>
In-Reply-To: <cc16130b4e23207971139eff313a4ec71f51c187.1382962788.git.rashika.kheria@gmail.com>
References: <cc16130b4e23207971139eff313a4ec71f51c187.1382962788.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by Jerome Marchand "The code in reset_store get the block device
(bdget_disk()) but it does not put it (bdput()) when it's done using it.
The usage count is therefor incremented but never decremented."

Hence, this patch introduces a call to bdput() to decrement the variable after usage.

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/staging/zram/zram_drv.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 9027975..98dac15 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -664,6 +664,7 @@ static ssize_t reset_store(struct device *dev,
 
 	/* Make sure all pending I/O is finished */
 	fsync_bdev(bdev);
+	bdput(bdev);
 
 	zram_reset_device(zram, true);
 	return len;
-- 
1.7.9.5

