Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab3HLLCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 07:02:12 -0400
Received: from mga14.intel.com ([143.182.124.37]:28712 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569Ab3HLLCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 07:02:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,861,1367996400"; 
   d="scan'208";a="280802208"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: Linus <linus.walleij@linaro.org>
Cc: linux-gpio@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH] gpio-lynxpoint: Fix warning about unbalanced pm_runtime_enable
Date: Mon, 12 Aug 2013 14:05:41 +0300
Message-Id: <1376305541-5857-1-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Missing pm_runtime_disable call in driver remove path caused
an unbalanaced pm_runtime_enable warning when driver was reloaded

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/gpio/gpio-lynxpoint.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-lynxpoint.c b/drivers/gpio/gpio-lynxpoint.c
index 761c470..2d9ca60 100644
--- a/drivers/gpio/gpio-lynxpoint.c
+++ b/drivers/gpio/gpio-lynxpoint.c
@@ -444,6 +444,7 @@ static int lp_gpio_remove(struct platform_device *pdev)
 {
 	struct lp_gpio *lg = platform_get_drvdata(pdev);
 	int err;
+	pm_runtime_disable(&pdev->dev);
 	err = gpiochip_remove(&lg->chip);
 	if (err)
 		dev_warn(&pdev->dev, "failed to remove gpio_chip.\n");
-- 
1.7.4.1

