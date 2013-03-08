Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934063Ab3CHKJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 05:09:32 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:61589 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934019Ab3CHKJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 05:09:30 -0500
From: Johan Hovold <jhovold@gmail.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 1/2] w1-gpio: remove erroneous __exit and __exit_p()
Date: Fri,  8 Mar 2013 11:07:59 +0100
Message-Id: <1362737280-13714-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8a1861d997 ("w1-gpio: Simplify & get rid of defines") changed
(apparently unknowingly) the driver to a hotpluggable platform-device
driver but did not not update the section markers for probe and remove
(to __devinit/exit, which have since been removed). A later commit fixed
the section mismatch for probe, but left remove marked with __exit.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/w1/masters/w1-gpio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
index d39dfa4..012817a 100644
--- a/drivers/w1/masters/w1-gpio.c
+++ b/drivers/w1/masters/w1-gpio.c
@@ -158,7 +158,7 @@ static int w1_gpio_probe(struct platform_device *pdev)
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
+	.remove	= w1_gpio_remove,
 	.suspend = w1_gpio_suspend,
 	.resume = w1_gpio_resume,
 };
-- 
1.8.1.1

