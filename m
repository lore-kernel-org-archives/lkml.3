Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab3EXXgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 19:36:25 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.4]:24269 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752676Ab3EXXgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 19:36:24 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-127.messagelabs.com!1369438172!7086987!1
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/14] misc/ep93xx_pwm: use module_platform_driver()
Date: Fri, 24 May 2013 16:28:14 -0700
User-Agent: KMail/1.9.9
CC: <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        Ryan Mallon <rmallon@gmail.com>, <mcrapet@gmail.com>,
        <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201305241628.14705.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the (*probe) function to the platform_driver and use the
module_platform_driver() macro to initialize the module.

Remove the unnecessary __init and __exit tags.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Matthieu Crapet <mcrapet@gmail.com>
---
 drivers/misc/ep93xx_pwm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/ep93xx_pwm.c b/drivers/misc/ep93xx_pwm.c
index dd570d1..b5ad0c6 100644
--- a/drivers/misc/ep93xx_pwm.c
+++ b/drivers/misc/ep93xx_pwm.c
@@ -215,7 +215,7 @@ static const struct attribute_group ep93xx_pwm_sysfs_files = {
 	.attrs	= ep93xx_pwm_attrs,
 };
 
-static int __init ep93xx_pwm_probe(struct platform_device *pdev)
+static int ep93xx_pwm_probe(struct platform_device *pdev)
 {
 	struct ep93xx_pwm *pwm;
 	struct resource *res;
@@ -257,7 +257,7 @@ static int __init ep93xx_pwm_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int __exit ep93xx_pwm_remove(struct platform_device *pdev)
+static int ep93xx_pwm_remove(struct platform_device *pdev)
 {
 	struct ep93xx_pwm *pwm = platform_get_drvdata(pdev);
 
@@ -274,10 +274,10 @@ static struct platform_driver ep93xx_pwm_driver = {
 		.name	= "ep93xx-pwm",
 		.owner	= THIS_MODULE,
 	},
-	.remove		= __exit_p(ep93xx_pwm_remove),
+	.probe		= ep93xx_pwm_probe,
+	.remove		= ep93xx_pwm_remove,
 };
-
-module_platform_driver_probe(ep93xx_pwm_driver, ep93xx_pwm_probe);
+module_platform_driver(ep93xx_pwm_driver);
 
 MODULE_AUTHOR("Matthieu Crapet <mcrapet@gmail.com>, "
 	      "H Hartley Sweeten <hsweeten@visionengravers.com>");
-- 
1.8.1.4

