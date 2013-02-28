Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759810Ab3B1O6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:58:00 -0500
Received: from fallback8.mail.ru ([94.100.176.136]:39747 "EHLO
	fallback8.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759750Ab3B1O5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:57:55 -0500
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Dong Aisheng <dong.aisheng@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH v6 1/2] mfd: syscon: Removed unneeded field "dev" from private driver structure
Date: Thu, 28 Feb 2013 18:57:13 +0400
Message-Id: <1362063434-8318-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.7.12.4
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/mfd/syscon.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index 61aea63..674af14 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -25,17 +25,15 @@
 static struct platform_driver syscon_driver;
 
 struct syscon {
-	struct device *dev;
 	void __iomem *base;
 	struct regmap *regmap;
 };
 
 static int syscon_match(struct device *dev, void *data)
 {
-	struct syscon *syscon = dev_get_drvdata(dev);
 	struct device_node *dn = data;
 
-	return (syscon->dev->of_node == dn) ? 1 : 0;
+	return (dev->of_node == dn) ? 1 : 0;
 }
 
 struct regmap *syscon_node_to_regmap(struct device_node *np)
@@ -130,7 +128,6 @@ static int syscon_probe(struct platform_device *pdev)
 		return PTR_ERR(syscon->regmap);
 	}
 
-	syscon->dev = dev;
 	platform_set_drvdata(pdev, syscon);
 
 	dev_info(dev, "syscon regmap start 0x%x end 0x%x registered\n",
-- 
1.7.12.4

