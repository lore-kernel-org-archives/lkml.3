Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab3BWH7E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 02:59:04 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:63429 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab3BWH6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 02:58:43 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ville Syrjala <syrjala@sci.fi>, Daniel Mack <zonque@gmail.com>
Subject: [PATCH 1/5] W1: w1-gpio - fix incorrect __init/__exit markups
Date: Fri, 22 Feb 2013 23:58:36 -0800
Message-Id: <1361606320-4479-1-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should not be using __init/__exit markups on probe() and remove()
methods unless platform_device_probe() is used, because other methods
allow unbinding device through sysfs and these methods should not be
discarded.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

This was just compiled - no hardware.

 drivers/w1/masters/w1-gpio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
index 85b363a..799dafd 100644
--- a/drivers/w1/masters/w1-gpio.c
+++ b/drivers/w1/masters/w1-gpio.c
@@ -72,7 +72,7 @@ static int w1_gpio_probe_dt(struct platform_device *pdev)
 	return 0;
 }
 
-static int __init w1_gpio_probe(struct platform_device *pdev)
+static int w1_gpio_probe(struct platform_device *pdev)
 {
 	struct w1_bus_master *master;
 	struct w1_gpio_platform_data *pdata;
@@ -158,7 +158,7 @@ static int __init w1_gpio_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int __exit w1_gpio_remove(struct platform_device *pdev)
+static int w1_gpio_remove(struct platform_device *pdev)
 {
 	struct w1_bus_master *master = platform_get_drvdata(pdev);
 	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
@@ -210,7 +210,7 @@ static struct platform_driver w1_gpio_driver = {
 		.of_match_table = of_match_ptr(w1_gpio_dt_ids),
 	},
 	.probe = w1_gpio_probe,
-	.remove	= __exit_p(w1_gpio_remove),
+	.remove = w1_gpio_remove,
 	.suspend = w1_gpio_suspend,
 	.resume = w1_gpio_resume,
 };
-- 
1.7.11.7

