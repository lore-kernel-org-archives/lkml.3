Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab3GNGkY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 02:40:24 -0400
Received: from fallback2.mail.ru ([94.100.176.87]:43590 "EHLO
	fallback2.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab3GNGkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 02:40:23 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH] mfd: syscon: Remove "base" field from private driver data
Date: Sun, 14 Jul 2013 10:39:42 +0400
Message-Id: <1373783982-26035-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.1.5
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes "base" field from private driver data.
No reason to store this variable.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/mfd/syscon.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index 1a31512..27db1f9 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -25,7 +25,6 @@
 static struct platform_driver syscon_driver;
 
 struct syscon {
-	void __iomem *base;
 	struct regmap *regmap;
 };
 
@@ -129,6 +128,7 @@ static int syscon_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct syscon *syscon;
 	struct resource *res;
+	void __iomem *base;
 
 	syscon = devm_kzalloc(dev, sizeof(*syscon), GFP_KERNEL);
 	if (!syscon)
@@ -138,12 +138,12 @@ static int syscon_probe(struct platform_device *pdev)
 	if (!res)
 		return -ENOENT;
 
-	syscon->base = devm_ioremap(dev, res->start, resource_size(res));
-	if (!syscon->base)
+	base = devm_ioremap(dev, res->start, resource_size(res));
+	if (!base)
 		return -ENOMEM;
 
 	syscon_regmap_config.max_register = res->end - res->start - 3;
-	syscon->regmap = devm_regmap_init_mmio(dev, syscon->base,
+	syscon->regmap = devm_regmap_init_mmio(dev, base,
 					&syscon_regmap_config);
 	if (IS_ERR(syscon->regmap)) {
 		dev_err(dev, "regmap init failed\n");
-- 
1.8.1.5

