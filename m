Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbaBJUAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:00:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34974 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbaBJTqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:46:31 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 079/124] mfd: max77686: Fix regmap resource leak on driver remove
Date: Mon, 10 Feb 2014 11:40:19 -0800
Message-Id: <1392061264-28124-80-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

commit 74142ffc0b52cfe6f9d2f6f34a5f3eedbfe3ce51 upstream.

The regmap used by max77686 MFD driver was not freed with regmap_exit()
on driver exit. This lead to leak of resources.

Replace regmap_init_i2c() call in driver probe with initialization of
managed register map so the regmap will be properly freed by the device
management code.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/mfd/max77686.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index 4d73963..5b6f118 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -102,7 +102,7 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 	max77686->irq_gpio = pdata->irq_gpio;
 	max77686->irq = i2c->irq;
 
-	max77686->regmap = regmap_init_i2c(i2c, &max77686_regmap_config);
+	max77686->regmap = devm_regmap_init_i2c(i2c, &max77686_regmap_config);
 	if (IS_ERR(max77686->regmap)) {
 		ret = PTR_ERR(max77686->regmap);
 		dev_err(max77686->dev, "Failed to allocate register map: %d\n",
-- 
1.8.3.2

