Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751113AbaDYBY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 21:24:28 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:59208 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaDYBY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 21:24:27 -0400
Message-ID: <1398389061.4424.1.camel@phoenix>
Subject: [PATCH] mfd: rdc321x: Fix off-by-one for ngpio setting
From: Axel Lin <axel.lin@ingics.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Florian Fainelli <florian@openwrt.org>
Date: Fri, 25 Apr 2014 09:24:21 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The valid gpio is GPIO0 ~ GPIO58, so ngpio should be 59.
This patch also renames RDC321X_MAX_GPIO to RDC321X_NUM_GPIO because it
actually means the number of available GPIOs.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/rdc321x-southbridge.c | 2 +-
 include/linux/mfd/rdc321x.h       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/rdc321x-southbridge.c b/drivers/mfd/rdc321x-southbridge.c
index c795697..6575585 100644
--- a/drivers/mfd/rdc321x-southbridge.c
+++ b/drivers/mfd/rdc321x-southbridge.c
@@ -38,7 +38,7 @@ static struct resource rdc321x_wdt_resource[] = {
 };
 
 static struct rdc321x_gpio_pdata rdc321x_gpio_pdata = {
-	.max_gpios	= RDC321X_MAX_GPIO,
+	.max_gpios	= RDC321X_NUM_GPIO,
 };
 
 static struct resource rdc321x_gpio_resources[] = {
diff --git a/include/linux/mfd/rdc321x.h b/include/linux/mfd/rdc321x.h
index 4bdf19c..442743a 100644
--- a/include/linux/mfd/rdc321x.h
+++ b/include/linux/mfd/rdc321x.h
@@ -12,7 +12,7 @@
 #define RDC321X_GPIO_CTRL_REG2	0x84
 #define RDC321X_GPIO_DATA_REG2	0x88
 
-#define RDC321X_MAX_GPIO	58
+#define RDC321X_NUM_GPIO	59
 
 struct rdc321x_gpio_pdata {
 	struct pci_dev *sb_pdev;
-- 
1.8.3.2



