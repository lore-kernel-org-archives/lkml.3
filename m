Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629Ab3CNNMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 09:12:16 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:47235 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757795Ab3CNNLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 09:11:55 -0400
From: Fabio Porcedda <fabio.porcedda@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-ide@vger.kernel.org,
        lm-sensors@lm-sensors.org, linux-input@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 05/10] drivers: ide: use module_platform_driver_probe()
Date: Thu, 14 Mar 2013 14:11:26 +0100
Message-Id: <1363266691-15757-7-git-send-email-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com>
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers to use the
module_platform_driver_probe() macro which makes the code smaller and
a bit simpler.

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-ide@vger.kernel.org
---
 drivers/ide/gayle.c     | 15 +--------------
 drivers/ide/tx4938ide.c | 13 +------------
 drivers/ide/tx4939ide.c | 13 +------------
 3 files changed, 3 insertions(+), 38 deletions(-)

diff --git a/drivers/ide/gayle.c b/drivers/ide/gayle.c
index 51beb85..0a8440a 100644
--- a/drivers/ide/gayle.c
+++ b/drivers/ide/gayle.c
@@ -183,20 +183,7 @@ static struct platform_driver amiga_gayle_ide_driver = {
 	},
 };
 
-static int __init amiga_gayle_ide_init(void)
-{
-	return platform_driver_probe(&amiga_gayle_ide_driver,
-				     amiga_gayle_ide_probe);
-}
-
-module_init(amiga_gayle_ide_init);
-
-static void __exit amiga_gayle_ide_exit(void)
-{
-	platform_driver_unregister(&amiga_gayle_ide_driver);
-}
-
-module_exit(amiga_gayle_ide_exit);
+module_platform_driver_probe(amiga_gayle_ide_driver, amiga_gayle_ide_probe);
 
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:amiga-gayle-ide");
diff --git a/drivers/ide/tx4938ide.c b/drivers/ide/tx4938ide.c
index 91d49dd..ede8575 100644
--- a/drivers/ide/tx4938ide.c
+++ b/drivers/ide/tx4938ide.c
@@ -203,18 +203,7 @@ static struct platform_driver tx4938ide_driver = {
 	.remove = __exit_p(tx4938ide_remove),
 };
 
-static int __init tx4938ide_init(void)
-{
-	return platform_driver_probe(&tx4938ide_driver, tx4938ide_probe);
-}
-
-static void __exit tx4938ide_exit(void)
-{
-	platform_driver_unregister(&tx4938ide_driver);
-}
-
-module_init(tx4938ide_init);
-module_exit(tx4938ide_exit);
+module_platform_driver_probe(tx4938ide_driver, tx4938ide_probe);
 
 MODULE_DESCRIPTION("TX4938 internal IDE driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/ide/tx4939ide.c b/drivers/ide/tx4939ide.c
index c0ab800..4ecdee5 100644
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -624,18 +624,7 @@ static struct platform_driver tx4939ide_driver = {
 	.resume = tx4939ide_resume,
 };
 
-static int __init tx4939ide_init(void)
-{
-	return platform_driver_probe(&tx4939ide_driver, tx4939ide_probe);
-}
-
-static void __exit tx4939ide_exit(void)
-{
-	platform_driver_unregister(&tx4939ide_driver);
-}
-
-module_init(tx4939ide_init);
-module_exit(tx4939ide_exit);
+module_platform_driver_probe(tx4939ide_driver, tx4939ide_probe);
 
 MODULE_DESCRIPTION("TX4939 internal IDE driver");
 MODULE_LICENSE("GPL");
-- 
1.8.1.5

