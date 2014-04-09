Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726AbaDIH2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 03:28:13 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.103]:48235 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696AbaDIH2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 03:28:10 -0400
From: Christoph Jaeger <christophjaeger@linux.com>
To: davem@davemloft.net
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Jaeger <christophjaeger@linux.com>
Subject: [PATCH] ide: use module_platform_driver()
Date: Wed,  9 Apr 2014 09:28:01 +0200
Message-Id: <1397028481-30757-1-git-send-email-christophjaeger@linux.com>
X-Mailer: git-send-email 1.9.0
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate boilerplate code by using module_platform_driver().

Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>
---
 drivers/ide/au1xxx-ide.c   | 13 +------------
 drivers/ide/ide_platform.c | 13 +------------
 2 files changed, 2 insertions(+), 24 deletions(-)

diff --git a/drivers/ide/au1xxx-ide.c b/drivers/ide/au1xxx-ide.c
index 259786c..07ea580 100644
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -592,18 +592,7 @@ static struct platform_driver au1200_ide_driver = {
 	.remove		= au_ide_remove,
 };
 
-static int __init au_ide_init(void)
-{
-	return platform_driver_register(&au1200_ide_driver);
-}
-
-static void __exit au_ide_exit(void)
-{
-	platform_driver_unregister(&au1200_ide_driver);
-}
+module_platform_driver(au1200_ide_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("AU1200 IDE driver");
-
-module_init(au_ide_init);
-module_exit(au_ide_exit);
diff --git a/drivers/ide/ide_platform.c b/drivers/ide/ide_platform.c
index a8b4b6a..d48de6d 100644
--- a/drivers/ide/ide_platform.c
+++ b/drivers/ide/ide_platform.c
@@ -131,19 +131,8 @@ static struct platform_driver platform_ide_driver = {
 	.remove = plat_ide_remove,
 };
 
-static int __init platform_ide_init(void)
-{
-	return platform_driver_register(&platform_ide_driver);
-}
-
-static void __exit platform_ide_exit(void)
-{
-	platform_driver_unregister(&platform_ide_driver);
-}
+module_platform_driver(platform_ide_driver);
 
 MODULE_DESCRIPTION("Platform IDE driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:pata_platform");
-
-module_init(platform_ide_init);
-module_exit(platform_ide_exit);
-- 
1.9.0

