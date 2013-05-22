Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab3EVKav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 06:30:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:16838 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079Ab3EVKau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 06:30:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,718,1363158000"; 
   d="scan'208";a="341311145"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] gpio-lynxpoint: remove unnecessary platform_set_drvdata()
Date: Wed, 22 May 2013 13:30:46 +0300
Message-Id: <1369218646-29556-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 0998d06310 "device-core: Ensure drvdata = NULL when no driver is bound",
this is done by driver core after device_release or on probe failure. Thus we
can remove all platform_set_drvdata(pdev, NULL) in drivers.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/gpio/gpio-lynxpoint.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-lynxpoint.c b/drivers/gpio/gpio-lynxpoint.c
index 86c17de..588991d 100644
--- a/drivers/gpio/gpio-lynxpoint.c
+++ b/drivers/gpio/gpio-lynxpoint.c
@@ -444,10 +444,10 @@ static int lp_gpio_remove(struct platform_device *pdev)
 {
 	struct lp_gpio *lg = platform_get_drvdata(pdev);
 	int err;
+
 	err = gpiochip_remove(&lg->chip);
 	if (err)
 		dev_warn(&pdev->dev, "failed to remove gpio_chip.\n");
-	platform_set_drvdata(pdev, NULL);
 	return 0;
 }
 
-- 
1.8.2.rc0.22.gb3600c3

