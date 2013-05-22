Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab3EVKUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 06:20:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:52101 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546Ab3EVKUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 06:20:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,718,1363158000"; 
   d="scan'208";a="341609011"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        David Cohen <david.a.cohen@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 4/5] gpio-langwell: amend error messages
Date: Wed, 22 May 2013 13:20:13 +0300
Message-Id: <1369218014-28990-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1369218014-28990-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1369218014-28990-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to use hardcoded device name in the error messages, because
dev_err() prefixes the message with the device name anyway.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/gpio/gpio-langwell.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
index 54b6caf..313d190 100644
--- a/drivers/gpio/gpio-langwell.c
+++ b/drivers/gpio/gpio-langwell.c
@@ -347,7 +347,7 @@ static int lnw_gpio_probe(struct pci_dev *pdev,
 
 	lnw = devm_kzalloc(&pdev->dev, sizeof(*lnw), GFP_KERNEL);
 	if (!lnw) {
-		dev_err(&pdev->dev, "can't allocate langwell_gpio chip data\n");
+		dev_err(&pdev->dev, "can't allocate chip data\n");
 		return -ENOMEM;
 	}
 
@@ -374,7 +374,7 @@ static int lnw_gpio_probe(struct pci_dev *pdev,
 	pci_set_drvdata(pdev, lnw);
 	retval = gpiochip_add(&lnw->chip);
 	if (retval) {
-		dev_err(&pdev->dev, "langwell gpiochip_add error %d\n", retval);
+		dev_err(&pdev->dev, "gpiochip_add error %d\n", retval);
 		return retval;
 	}
 
@@ -408,8 +408,7 @@ static int wp_gpio_probe(struct platform_device *pdev)
 
 	lnw = devm_kzalloc(&pdev->dev, sizeof(struct lnw_gpio), GFP_KERNEL);
 	if (!lnw) {
-		dev_err(&pdev->dev,
-			"can't allocate whitneypoint_gpio chip data\n");
+		dev_err(&pdev->dev, "can't allocate chip data\n");
 		return -ENOMEM;
 	}
 
@@ -432,8 +431,7 @@ static int wp_gpio_probe(struct platform_device *pdev)
 	gc->can_sleep = 0;
 	retval = gpiochip_add(gc);
 	if (retval) {
-		dev_err(&pdev->dev, "whitneypoint gpiochip_add error %d\n",
-								retval);
+		dev_err(&pdev->dev, "gpiochip_add error %d\n", retval);
 		return retval;
 	}
 	platform_set_drvdata(pdev, lnw);
-- 
1.8.2.rc0.22.gb3600c3

