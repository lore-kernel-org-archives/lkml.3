Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab3AUKLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:11:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56589 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab3AUKKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:10:21 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 22/33] power: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:09:15 +0100
Message-Id: <1358762966-20791-23-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:AmiAaMmNf7soWbHINfiGB3Vmgu45bow599N9/K3hmG7
 NNcilryTbK4vNx03r9tKnbDkl6WkJYYJ3V20XHxBo5Mq4Yqq79
 jK/wQ/RxnlTrB8XJpFGBxF1KrXsza035awyc3Q7rpsc/VyGhi1
 h8Y2ZkvGY/bNaBJMyALQAjaNNjz2v4vadm8gbCkFC1Cz670hdI
 ppMaGojmP1gpiEA49i+t98eUC3XjNn9xMCE7hf3KcYzSR2cBq5
 6jgioUyW1oqHZX76dp6K8A0mTLjTkIaz8M8foYOTUYheRVwnuW
 XhQsDv+1l7RMLlx80HISCTtMd1USVWv8p1ZM4iNw/79LlnzNLp
 WNbHE/l3KW+fa1jnGvXyYoIq5yjUnhNRhGmyYmH7TNE1rV4dHV
 QdW42MAB7XfLSVDJ7OI5vV9LxtQ1xUOniDvQtmAXNeCYBRzy6d
 upqmQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/power/jz4740-battery.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
index bf91489..c675553 100644
--- a/drivers/power/jz4740-battery.c
+++ b/drivers/power/jz4740-battery.c
@@ -22,6 +22,7 @@
 #include <linux/io.h>
 
 #include <linux/delay.h>
+#include <linux/err.h>
 #include <linux/gpio.h>
 #include <linux/mfd/core.h>
 #include <linux/power_supply.h>
@@ -266,9 +267,9 @@ static int jz_battery_probe(struct platform_device *pdev)
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	jz_battery->base = devm_request_and_ioremap(&pdev->dev, mem);
-	if (!jz_battery->base)
-		return -EBUSY;
+	jz_battery->base = devm_ioremap_resource(&pdev->dev, mem);
+	if (IS_ERR(jz_battery->base))
+		return PTR_ERR(jz_battery->base);
 
 	battery = &jz_battery->battery;
 	battery->name = pdata->info.name;
-- 
1.8.1.1

