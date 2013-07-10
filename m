Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab3GJP7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 11:59:20 -0400
Received: from sauhun.de ([89.238.76.85]:44302 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab3GJP67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 11:58:59 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 03/12] drivers/misc: don't use devm_pinctrl_get_select_default() in probe
Date: Wed, 10 Jul 2013 16:57:38 +0100
Message-Id: <1373471889-18107-3-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1373471889-18107-1-git-send-email-wsa@the-dreams.de>
References: <1373471889-18107-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
we can rely on device core for setting the default pins. Compile tested only.

Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/misc/atmel-ssc.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/misc/atmel-ssc.c b/drivers/misc/atmel-ssc.c
index f7b90661..551ddde 100644
--- a/drivers/misc/atmel-ssc.c
+++ b/drivers/misc/atmel-ssc.c
@@ -19,7 +19,6 @@
 #include <linux/module.h>
 
 #include <linux/of.h>
-#include <linux/pinctrl/consumer.h>
 
 /* Serialize access to ssc_list and user count */
 static DEFINE_SPINLOCK(user_lock);
@@ -132,13 +131,6 @@ static int ssc_probe(struct platform_device *pdev)
 	struct resource *regs;
 	struct ssc_device *ssc;
 	const struct atmel_ssc_platform_data *plat_dat;
-	struct pinctrl *pinctrl;
-
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl)) {
-		dev_err(&pdev->dev, "Failed to request pinctrl\n");
-		return PTR_ERR(pinctrl);
-	}
 
 	ssc = devm_kzalloc(&pdev->dev, sizeof(struct ssc_device), GFP_KERNEL);
 	if (!ssc) {
-- 
1.7.10.4

