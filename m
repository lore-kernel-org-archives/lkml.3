Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbaDNMDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 08:03:53 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:65090 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbaDNMDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 08:03:52 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-30-534bcea5b8d3
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/2] mfd: sec-core: Remove duplicated device type from sec_pmic
Date: Mon, 14 Apr 2014 14:03:34 +0200
Message-id: <1397477015-13900-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNJMWRmVeSWpSXmKPExsVy+t/xy7pLz3kHG/yfrWaxccZ6VovXLwwt
	zja9Ybe4//Uoo8XlXXPYLNYeuctucbqb1eLiii9MDhwed67tYfOYdzLQo2/LKkaPz5vkAlii
	uGxSUnMyy1KL9O0SuDI2dXxiKbjHV3HsWk0D43SeLkZODgkBE4lJjz+wQdhiEhfurQezhQSW
	Mkrs3O3RxcgFZPcxSTS/6WQGSbAJGEtsXr6EDSQhItDHKHH+7RpGEIdZ4CijxPTet0wgVcIC
	/hLHPx9lB7FZBFQlfq7dxwpi8wq4S0z48ogVYp2CxLIva5knMHIvYGRYxSiaWppcUJyUnmuo
	V5yYW1yal66XnJ+7iRESIF92MC4+ZnWIUYCDUYmHt3OOd7AQa2JZcWXuIUYJDmYlEV7XrUAh
	3pTEyqrUovz4otKc1OJDjEwcnFINjJWyTLO3Rc85eehT9wkV6fBZt76ahm+8IF+WlBessWq/
	8H9ZXc8ktxuKK36u+LlnafzLM/MXO8ke7TOzPnK7iMO9My5qT53252S9dxXb7ghWM3B7HM6q
	XMlWGfycRXbq+cqvL83DfrjdaF6487f/NfV7hW4ruyOLvdd9O3N9f1q+WGLfuZcFkkosxRmJ
	hlrMRcWJAJNVaw3uAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device type was stored in sec_pmic state container twice:
 - unsigned long type
 - int device_type

The 'type' field was never used outside of probe so it can be safely
removed.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/sec-core.c           | 5 +++--
 include/linux/mfd/samsung/core.h | 1 -
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index d4682c6cbff5..fccfd71f8abd 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -251,6 +251,7 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 	struct sec_platform_data *pdata = dev_get_platdata(&i2c->dev);
 	const struct regmap_config *regmap;
 	struct sec_pmic_dev *sec_pmic;
+	unsigned long device_type;
 	int ret;
 
 	sec_pmic = devm_kzalloc(&i2c->dev, sizeof(struct sec_pmic_dev),
@@ -262,7 +263,7 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 	sec_pmic->dev = &i2c->dev;
 	sec_pmic->i2c = i2c;
 	sec_pmic->irq = i2c->irq;
-	sec_pmic->type = sec_i2c_get_driver_data(i2c, id);
+	device_type = sec_i2c_get_driver_data(i2c, id);
 
 	if (sec_pmic->dev->of_node) {
 		pdata = sec_pmic_i2c_parse_dt_pdata(sec_pmic->dev);
@@ -270,7 +271,7 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 			ret = PTR_ERR(pdata);
 			return ret;
 		}
-		pdata->device_type = sec_pmic->type;
+		pdata->device_type = (int)device_type;
 	}
 	if (pdata) {
 		sec_pmic->device_type = pdata->device_type;
diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
index 84aaf6c25794..2633083262ea 100644
--- a/include/linux/mfd/samsung/core.h
+++ b/include/linux/mfd/samsung/core.h
@@ -49,7 +49,6 @@ struct sec_pmic_dev {
 	struct regmap_irq_chip_data *irq_data;
 
 	int ono;
-	unsigned long type;
 	bool wakeup;
 	bool wtsr_smpl;
 };
-- 
1.8.3.2

