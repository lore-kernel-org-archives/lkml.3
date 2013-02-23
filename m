Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780Ab3BWFQE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 00:16:04 -0500
Received: from fallback4.mail.ru ([94.100.176.42]:36454 "EHLO
	fallback4.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab3BWFQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 00:16:01 -0500
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Dong Aisheng <dong.aisheng@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH v5 1/3] mfd: syscon: Removed support for unloading
Date: Sat, 23 Feb 2013 09:15:18 +0400
Message-Id: <1361596520-19332-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.7.12.4
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver can be used in various subsystems and therefore should not
be unloaded when it is defined in the kernel configuration, so remove
support for unloading it.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/mfd/syscon.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index 61aea63..55d7915 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -139,17 +139,6 @@ static int syscon_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int syscon_remove(struct platform_device *pdev)
-{
-	struct syscon *syscon;
-
-	syscon = platform_get_drvdata(pdev);
-	iounmap(syscon->base);
-	platform_set_drvdata(pdev, NULL);
-
-	return 0;
-}
-
 static struct platform_driver syscon_driver = {
 	.driver = {
 		.name = "syscon",
@@ -157,7 +146,6 @@ static struct platform_driver syscon_driver = {
 		.of_match_table = of_syscon_match,
 	},
 	.probe		= syscon_probe,
-	.remove		= syscon_remove,
 };
 
 static int __init syscon_init(void)
@@ -166,12 +154,6 @@ static int __init syscon_init(void)
 }
 postcore_initcall(syscon_init);
 
-static void __exit syscon_exit(void)
-{
-	platform_driver_unregister(&syscon_driver);
-}
-module_exit(syscon_exit);
-
 MODULE_AUTHOR("Dong Aisheng <dong.aisheng@linaro.org>");
 MODULE_DESCRIPTION("System Control driver");
 MODULE_LICENSE("GPL v2");
-- 
1.7.12.4

