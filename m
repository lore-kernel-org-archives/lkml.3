Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936197Ab3DJHNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 03:13:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54495 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab3DJHNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 03:13:20 -0400
From: Jan Luebbe <jlu@pengutronix.de>
To: Rodolfo Giometti <giometti@enneenne.com>,
        James Nuss <jamesnuss@nanometrics.ca>
Cc: linux-kernel@vger.kernel.org, Jan Luebbe <jlu@pengutronix.de>
Subject: [PATCH 2/2] pps-gpio: convert to module_platform_driver
Date: Wed, 10 Apr 2013 09:12:38 +0200
Message-Id: <1365577958-13295-2-git-send-email-jlu@pengutronix.de>
X-Mailer: git-send-email 1.8.2.rc2
In-Reply-To: <1365577958-13295-1-git-send-email-jlu@pengutronix.de>
References: <1365577958-13295-1-git-send-email-jlu@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: jlu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes some boilerplate code (no functional changes).

Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
---
 drivers/pps/clients/pps-gpio.c |   18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/pps/clients/pps-gpio.c b/drivers/pps/clients/pps-gpio.c
index 221858d..6768f95 100644
--- a/drivers/pps/clients/pps-gpio.c
+++ b/drivers/pps/clients/pps-gpio.c
@@ -188,23 +188,7 @@ static struct platform_driver pps_gpio_driver = {
 	},
 };
 
-static int __init pps_gpio_init(void)
-{
-	int ret = platform_driver_register(&pps_gpio_driver);
-	if (ret < 0)
-		pr_err("failed to register platform driver\n");
-	return ret;
-}
-
-static void __exit pps_gpio_exit(void)
-{
-	platform_driver_unregister(&pps_gpio_driver);
-	pr_debug("unregistered platform driver\n");
-}
-
-module_init(pps_gpio_init);
-module_exit(pps_gpio_exit);
-
+module_platform_driver(pps_gpio_driver);
 MODULE_AUTHOR("Ricardo Martins <rasm@fe.up.pt>");
 MODULE_AUTHOR("James Nuss <jamesnuss@nanometrics.ca>");
 MODULE_DESCRIPTION("Use GPIO pin as PPS source");
-- 
1.7.10.4

