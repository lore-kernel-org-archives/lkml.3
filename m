Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600Ab3EEIkK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 04:40:10 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:61966 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3EEIkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 04:40:09 -0400
From: chenlibo.3@gmail.com
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        lizefan@huawei.com, Libo Chen <libo.chen@huawei.com>
Subject: [PATCH] mtd: fix kfree bcm47xxsflash
Date: Sun,  5 May 2013 01:40:25 -0700
Message-Id: <1367743225-3484-1-git-send-email-libo.chen@huawei.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Libo Chen <libo.chen@huawei.com>

mtd is just member of bcm47xxsflash, so we should free bcm47xxsflash  not its member.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/mtd/devices/bcm47xxsflash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/bcm47xxsflash.c b/drivers/mtd/devices/bcm47xxsflash.c
index 9526628..4aa9141 100644
--- a/drivers/mtd/devices/bcm47xxsflash.c
+++ b/drivers/mtd/devices/bcm47xxsflash.c
@@ -76,7 +76,7 @@ static int bcm47xxsflash_bcma_probe(struct platform_device *pdev)
 	return 0;
 
 err_dev_reg:
-	kfree(&b47s->mtd);
+	kfree(b47s);
 out:
 	return err;
 }
-- 
1.8.1.2

