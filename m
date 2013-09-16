Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab3IPIdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:33:54 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:59762 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235Ab3IPIde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:33:34 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH 9/9] gpio: tegra: Use module_platform_driver()
Date: Mon, 16 Sep 2013 10:32:06 +0200
Message-Id: <1379320326-13241-10-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379320326-13241-1-git-send-email-treding@nvidia.com>
References: <1379320326-13241-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the driver core now resolving interrupt references at probe time,
it is no longer necessary to force explicit probe ordering using
initcalls.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Note that there are potentially many more drivers that can be switched
to the generic module_*_driver() interfaces now that interrupts can be
resolved later and deferred probe should be able to handle all the
ordering issues.
---
 drivers/gpio/gpio-tegra.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index 9a62672..766e6ef 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -513,12 +513,7 @@ static struct platform_driver tegra_gpio_driver = {
 	},
 	.probe		= tegra_gpio_probe,
 };
-
-static int __init tegra_gpio_init(void)
-{
-	return platform_driver_register(&tegra_gpio_driver);
-}
-postcore_initcall(tegra_gpio_init);
+module_platform_driver(tegra_gpio_driver);
 
 #ifdef	CONFIG_DEBUG_FS
 
-- 
1.8.4

