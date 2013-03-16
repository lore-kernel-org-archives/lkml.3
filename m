Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab3CPBHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 21:07:21 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.201]:29476 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755031Ab3CPBHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 21:07:20 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-131.messagelabs.com!1363396039!23397520!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] misc: ep93xx_pwm.c: fix section mismatch and use module_platform_driver
Date: Fri, 15 Mar 2013 18:07:13 -0700
User-Agent: KMail/1.9.9
CC: Ryan Mallon <rmallon@gmail.com>, <arnd@arndb.de>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201303151807.14074.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the __init tags from the ep93xx_pwm_probe() and
ep93xx_pwm_remove() functions to fix the section mismatch
warnings.

Use module_platform_driver() to remove the init/exit boilerplate.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/ep93xx_pwm.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/misc/ep93xx_pwm.c b/drivers/misc/ep93xx_pwm.c
index 16d7179..4a674f6 100644
--- a/drivers/misc/ep93xx_pwm.c
+++ b/drivers/misc/ep93xx_pwm.c
@@ -269,7 +269,7 @@ static const struct attribute_group ep93xx_pwm_sysfs_files = {
 	.attrs	= ep93xx_pwm_attrs,
 };
 
-static int __init ep93xx_pwm_probe(struct platform_device *pdev)
+static int ep93xx_pwm_probe(struct platform_device *pdev)
 {
 	struct ep93xx_pwm *pwm;
 	struct resource *res;
@@ -339,7 +339,7 @@ fail_no_mem:
 	return err;
 }
 
-static int __exit ep93xx_pwm_remove(struct platform_device *pdev)
+static int ep93xx_pwm_remove(struct platform_device *pdev)
 {
 	struct ep93xx_pwm *pwm = platform_get_drvdata(pdev);
 	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -362,21 +362,10 @@ static struct platform_driver ep93xx_pwm_driver = {
 		.name	= "ep93xx-pwm",
 		.owner	= THIS_MODULE,
 	},
-	.remove		= __exit_p(ep93xx_pwm_remove),
+	.probe		= ep93xx_pwm_probe,
+	.remove		= ep93xx_pwm_remove,
 };
-
-static int __init ep93xx_pwm_init(void)
-{
-	return platform_driver_probe(&ep93xx_pwm_driver, ep93xx_pwm_probe);
-}
-
-static void __exit ep93xx_pwm_exit(void)
-{
-	platform_driver_unregister(&ep93xx_pwm_driver);
-}
-
-module_init(ep93xx_pwm_init);
-module_exit(ep93xx_pwm_exit);
+module_platform_driver(ep93xx_pwm_driver);
 
 MODULE_AUTHOR("Matthieu Crapet <mcrapet@gmail.com>, "
 	      "H Hartley Sweeten <hsweeten@visionengravers.com>");
-- 
1.8.1.4

