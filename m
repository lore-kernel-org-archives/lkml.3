Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564Ab3EWMAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:00:31 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:63422 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758216Ab3EWMAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:00:30 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <wsa@the-dreams.de>
CC: <guz.fnst@cn.fujitsu.com>, <sonic.zhang@analog.com>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <libo.chen@huawei.com>
Subject: [PATCH RFC v3 3/3] i2c: pxa: use module_platform_driver() replace init/exit
Date: Thu, 23 May 2013 20:00:11 +0800
Message-ID: <1369310411-35652-1-git-send-email-libo.chen@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use module_platform_driver() macro to replace the module init/exit

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/i2c/busses/i2c-pxa.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index 7b10102..e9c3524 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -1242,15 +1242,7 @@ static struct platform_driver i2c_pxa_driver = {
 	.id_table	= i2c_pxa_id_table,
 };
 
-static int __init i2c_adap_pxa_init(void)
-{
-	return platform_driver_register(&i2c_pxa_driver);
-}
-
-static void __exit i2c_adap_pxa_exit(void)
-{
-	platform_driver_unregister(&i2c_pxa_driver);
-}
+module_platform_driver(i2c_pxa_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:pxa2xx-i2c");
-- 
1.7.1


