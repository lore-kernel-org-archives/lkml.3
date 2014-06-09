Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329AbaFIOfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 10:35:09 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:44655 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaFIOfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 10:35:06 -0400
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] mfd: syscon: Use module_platform_driver()
Date: Mon, 9 Jun 2014 22:34:14 +0800
Message-ID: <1402324454-15872-1-git-send-email-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 1.8.3.msysgit.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.21.224]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to module_platform_drive() to eliminate boilerplate code.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 drivers/mfd/syscon.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index ca15878..6c2c874 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -173,17 +173,7 @@ static struct platform_driver syscon_driver = {
 	.id_table	= syscon_ids,
 };
 
-static int __init syscon_init(void)
-{
-	return platform_driver_register(&syscon_driver);
-}
-postcore_initcall(syscon_init);
-
-static void __exit syscon_exit(void)
-{
-	platform_driver_unregister(&syscon_driver);
-}
-module_exit(syscon_exit);
+module_platform_driver(syscon_driver)
 
 MODULE_AUTHOR("Dong Aisheng <dong.aisheng@linaro.org>");
 MODULE_DESCRIPTION("System Control driver");
-- 
1.7.1


