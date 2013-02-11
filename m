Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927Ab3BKSq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 13:46:28 -0500
Received: from fallback7.mail.ru ([94.100.176.135]:46416 "EHLO
	fallback7.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758697Ab3BKSq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 13:46:27 -0500
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Dong Aisheng <dong.aisheng@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>, Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH v2 2/3] mfd: syscon: Removed unneeded field "dev" from private driver structure
Date: Mon, 11 Feb 2013 22:42:52 +0400
Message-Id: <1360608173-12907-2-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1360608173-12907-1-git-send-email-shc_work@mail.ru>
References: <1360608173-12907-1-git-send-email-shc_work@mail.ru>
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
index e1886fb..4a7ed5a 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -24,17 +24,15 @@
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
@@ -129,7 +127,6 @@ static int syscon_probe(struct platform_device *pdev)
 		return PTR_ERR(syscon->regmap);
 	}
 
-	syscon->dev = dev;
 	platform_set_drvdata(pdev, syscon);
 
 	dev_info(dev, "syscon regmap start 0x%x end 0x%x registered\n",
-- 
1.7.12.4

