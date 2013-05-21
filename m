Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab3EUKdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 06:33:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:15537 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535Ab3EUKdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 06:33:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,713,1363158000"; 
   d="scan'208";a="341022192"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        David Cohen <david.a.cohen@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/4] gpio-langwell: amend error messages
Date: Tue, 21 May 2013 13:33:04 +0300
Message-Id: <1369132386-11725-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1369132386-11725-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1369132386-11725-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of hardcoded names let's use __func__ macro.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/gpio/gpio-langwell.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
index c1f33dd..ab797cc 100644
--- a/drivers/gpio/gpio-langwell.c
+++ b/drivers/gpio/gpio-langwell.c
@@ -392,7 +392,7 @@ static int lnw_gpio_probe(struct pci_dev *pdev,
 	pci_set_drvdata(pdev, lnw);
 	retval = gpiochip_add(&lnw->chip);
 	if (retval) {
-		dev_err(&pdev->dev, "langwell gpiochip_add error %d\n", retval);
+		dev_err(&pdev->dev, "%s error %d\n", __func__, retval);
 		goto err_ioremap;
 	}
 
@@ -459,8 +459,7 @@ static int wp_gpio_probe(struct platform_device *pdev)
 	gc->can_sleep = 0;
 	retval = gpiochip_add(gc);
 	if (retval) {
-		dev_err(&pdev->dev, "whitneypoint gpiochip_add error %d\n",
-								retval);
+		dev_err(&pdev->dev, "%s error %d\n", __func__, retval);
 		goto err_ioremap;
 	}
 	platform_set_drvdata(pdev, lnw);
-- 
1.8.2.rc0.22.gb3600c3

