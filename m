Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967332Ab3E3CYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 22:24:52 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:47861 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967287Ab3E3CYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 22:24:36 -0400
Message-ID: <51A6B7D8.8090600@huawei.com>
Date: Thu, 30 May 2013 10:22:16 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: <dwmw2@infradead.org>, Andy Shevchenko <andy.shevchenko@gmail.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        <artem.bityutskiy@linux.intel.com>,
        Bill Pemberton <wfp5p@virginia.edu>, <hauke@hauke-m.de>,
        <linux-mtd@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH RESEND 2/2] mtd: bcm47: convert to module_platform_driver
 instead of init/exit
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


convert to module_platform_driver instead of init/exit

Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Libo chen <libo.chen@huawei.com>
---
 drivers/mtd/devices/bcm47xxsflash.c |   20 +-------------------
 1 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/drivers/mtd/devices/bcm47xxsflash.c b/drivers/mtd/devices/bcm47xxsflash.c
index 2630d5c..54230cd 100644
--- a/drivers/mtd/devices/bcm47xxsflash.c
+++ b/drivers/mtd/devices/bcm47xxsflash.c
@@ -108,22 +108,4 @@ static struct platform_driver bcma_sflash_driver = {
  * Init
  **************************************************/

-static int __init bcm47xxsflash_init(void)
-{
-	int err;
-
-	err = platform_driver_register(&bcma_sflash_driver);
-	if (err)
-		pr_err("Failed to register BCMA serial flash driver: %d\n",
-		       err);
-
-	return err;
-}
-
-static void __exit bcm47xxsflash_exit(void)
-{
-	platform_driver_unregister(&bcma_sflash_driver);
-}
-
-module_init(bcm47xxsflash_init);
-module_exit(bcm47xxsflash_exit);
+module_platform_driver(bcma_sflash_driver);
-- 
1.7.1


