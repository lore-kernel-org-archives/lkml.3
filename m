Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab3KEJnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 04:43:55 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:59708 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab3KEJnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 04:43:51 -0500
X-AuditID: cbfee68f-b7f836d000001b39-8f-5278bdd509ec
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de, grundler@chromium.org,
        cpgs@samsung.com
Subject: [PATCH v6] iio: exynos_adc: use wait_for_completion_timeout instead of
 interruptible
Date: Tue, 05 Nov 2013 15:15:30 +0530
Message-id: <1383644730-23228-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1381479821-17276-1-git-send-email-ch.naveen@samsung.com>
References: <1381479821-17276-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42JZI2JSpXttb0WQwfEOZouXhzQtzi47yGbR
	vHg9m8WrIz+YLJZMns9qMe/IOxaLy7vmsFnMOL+PyWLRtv/MDpwesxsusnjsnHWX3WP/3DXs
	HkveHGL16NuyitHj8ya5ALYoLpuU1JzMstQifbsEroz9p46xFxxTrfh2fyZ7A+MnuS5GTg4J
	AROJtrfrWCBsMYkL99azdTFycQgJLGWUWPhzBWsXIwdY0bl5NiA1QgLTGSWm7nCDqOlhkvj/
	6BQ7SIJNwEzi4KLV7CD1IgKyEjO79UBqmAUuMEo0fVvKClIjLBAv8f3eFDYQm0VAVWLW9L3M
	IPW8Aq4S0w4zQ9ygKNH9bAIbSJhTwE2i64Q4xFpXiZ1r94CdJiGwiV3izKebrBBjBCS+TT7E
	AnGmrMSmA1BjJCUOrrjBMoFReAEjwypG0dSC5ILipPQiY73ixNzi0rx0veT83E2MwOA//e9Z
	/w7GuwesDzEmA42byCwlmpwPjJ68knhDYzMjC1MTU2Mjc0sz0oSVxHnvP0wKEhJITyxJzU5N
	LUgtii8qzUktPsTIxMEp1cDoe/UH95wFTAz/Pa+mNvk3Ov9yfBj2yKF6Qk7lzGnZPr/djZJK
	NYtO7Kq1u+aq8WDmmdKQT50Hr173l5Yve9CgrdnSEfxE1HJJcdwPTzWhzMCo3cqJoseSZK/o
	uQUaSkeeLxM2XsX+nUNOU8Wq8lXKj7UFh1ouKBgzrbCd0qzUuXPJg/P9B5VYijMSDbWYi4oT
	AUuPxF2UAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t9jQd2reyuCDK5vNrd4eUjT4uyyg2wW
	zYvXs1m8OvKDyWLJ5PmsFvOOvGOxuLxrDpvFjPP7mCwWbfvP7MDpMbvhIovHzll32T32z13D
	7rHkzSFWj74tqxg9Pm+SC2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdS
	yEvMTbVVcvEJ0HXLzAG6SkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOY
	sf/UMfaCY6oV3+7PZG9g/CTXxcjBISFgInFunk0XIyeQKSZx4d56NhBbSGA6o8TUHW5djFxA
	dg+TxP9Hp9hBEmwCZhIHF61mB+kVEZCVmNmtB1LDLHCBUaLp21JWkBphgXiJ7/emgA1iEVCV
	mDV9LzNIPa+Aq8S0w8wQuxQlup9NYAMJcwq4SXSdEIdY6yqxc+0etgmMvAsYGVYxiqYWJBcU
	J6XnGukVJ+YWl+al6yXn525iBMfWM+kdjKsaLA4xCnAwKvHwXgytCBJiTSwrrsw9xCjBwawk
	wsuxGyjEm5JYWZValB9fVJqTWnyIMRnoponMUqLJ+cC4zyuJNzQ2MTc1NrU0sTAxsyRNWEmc
	92CrdaCQQHpiSWp2ampBahHMFiYOTqkGxolTl7lzacbumunP+HzfrcvzuqwWB7o32nqs4n5z
	scR/zdN9LbyNaRUvk7+4XBSdoCX7W9GyriPjjH7NsntT5W68fOefwsx2mHGxvmlZoYXL2Uyt
	+2F+Csb7TA6VswrVvqjakveue2eR35pbXjV2CtuF/uqYx2no2n2KXxWy64Vo0taCC9zPlFiK
	MxINtZiLihMBlX5qHfECAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. The irq routine is so simple (just one register read) shouldn't be long
   Hence, reduce the timeout to 100milli secs,
2. With 100ms of wait time, interruptible is very much unnecessary.
   Hence, use wait_for_completion_timeout instead of
   wait_for_completion_interruptible_timeout
3. Reset software if a timeout happens.
4. Add reinit_completion() before the wait_for_completion_timeout in raw_read()

Note: submitted for review at https://patchwork.kernel.org/patch/2279591/

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Reviewed-on: https://chromium-review.googlesource.com/172724
Reviewed-by: Doug Anderson <dianders@chromium.org>
---
Changes since v1:
As per discussion at
http://marc.info/?l=linux-kernel&m=136517637228869&w=3

Changes since v2:
None.
Rebased and reposting.

Changes since v3:
1. commit message change and
2. removed an unncessary assignment

Changes since v4:
Moved INIT_COMPLETION call to the starting of the function

Changes since v5:
INIT_COMPLETION was replaced by reinit_completion
("tree-wide: use reinit_completion instead of INIT_COMPLETION").
Use it to avoid the following build error:
undefined identifier 'INIT_COMPLETION'


 drivers/iio/adc/exynos_adc.c | 69 ++++++++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 31 deletions(-)

diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index 0f2ca60..a675751 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -81,7 +81,7 @@ enum adc_version {
 #define ADC_CON_EN_START	(1u << 0)
 #define ADC_DATX_MASK		0xFFF
 
-#define EXYNOS_ADC_TIMEOUT	(msecs_to_jiffies(1000))
+#define EXYNOS_ADC_TIMEOUT	(msecs_to_jiffies(100))
 
 struct exynos_adc {
 	void __iomem		*regs;
@@ -111,6 +111,30 @@ static inline unsigned int exynos_adc_get_version(struct platform_device *pdev)
 	return (unsigned int)match->data;
 }
 
+static void exynos_adc_hw_init(struct exynos_adc *info)
+{
+	u32 con1, con2;
+
+	if (info->version == ADC_V2) {
+		con1 = ADC_V2_CON1_SOFT_RESET;
+		writel(con1, ADC_V2_CON1(info->regs));
+
+		con2 = ADC_V2_CON2_OSEL | ADC_V2_CON2_ESEL |
+			ADC_V2_CON2_HIGHF | ADC_V2_CON2_C_TIME(0);
+		writel(con2, ADC_V2_CON2(info->regs));
+
+		/* Enable interrupts */
+		writel(1, ADC_V2_INT_EN(info->regs));
+	} else {
+		/* set default prescaler values and Enable prescaler */
+		con1 =  ADC_V1_CON_PRSCLV(49) | ADC_V1_CON_PRSCEN;
+
+		/* Enable 12-bit ADC resolution */
+		con1 |= ADC_V1_CON_RES;
+		writel(con1, ADC_V1_CON(info->regs));
+	}
+}
+
 static int exynos_read_raw(struct iio_dev *indio_dev,
 				struct iio_chan_spec const *chan,
 				int *val,
@@ -120,11 +144,13 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
 	struct exynos_adc *info = iio_priv(indio_dev);
 	unsigned long timeout;
 	u32 con1, con2;
+	int ret;
 
 	if (mask != IIO_CHAN_INFO_RAW)
 		return -EINVAL;
 
 	mutex_lock(&indio_dev->mlock);
+	reinit_completion(&info->completion);
 
 	/* Select the channel to be used and Trigger conversion */
 	if (info->version == ADC_V2) {
@@ -144,16 +170,21 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
 				ADC_V1_CON(info->regs));
 	}
 
-	timeout = wait_for_completion_interruptible_timeout
+	timeout = wait_for_completion_timeout
 			(&info->completion, EXYNOS_ADC_TIMEOUT);
-	*val = info->value;
+	if (timeout == 0) {
+		dev_warn(&indio_dev->dev, "Conversion timed out! Resetting\n");
+		exynos_adc_hw_init(info);
+		ret = -ETIMEDOUT;
+	} else {
+		*val = info->value;
+		*val2 = 0;
+		ret = IIO_VAL_INT;
+	}
 
 	mutex_unlock(&indio_dev->mlock);
 
-	if (timeout == 0)
-		return -ETIMEDOUT;
-
-	return IIO_VAL_INT;
+	return ret;
 }
 
 static irqreturn_t exynos_adc_isr(int irq, void *dev_id)
@@ -225,30 +256,6 @@ static int exynos_adc_remove_devices(struct device *dev, void *c)
 	return 0;
 }
 
-static void exynos_adc_hw_init(struct exynos_adc *info)
-{
-	u32 con1, con2;
-
-	if (info->version == ADC_V2) {
-		con1 = ADC_V2_CON1_SOFT_RESET;
-		writel(con1, ADC_V2_CON1(info->regs));
-
-		con2 = ADC_V2_CON2_OSEL | ADC_V2_CON2_ESEL |
-			ADC_V2_CON2_HIGHF | ADC_V2_CON2_C_TIME(0);
-		writel(con2, ADC_V2_CON2(info->regs));
-
-		/* Enable interrupts */
-		writel(1, ADC_V2_INT_EN(info->regs));
-	} else {
-		/* set default prescaler values and Enable prescaler */
-		con1 =  ADC_V1_CON_PRSCLV(49) | ADC_V1_CON_PRSCEN;
-
-		/* Enable 12-bit ADC resolution */
-		con1 |= ADC_V1_CON_RES;
-		writel(con1, ADC_V1_CON(info->regs));
-	}
-}
-
 static int exynos_adc_probe(struct platform_device *pdev)
 {
 	struct exynos_adc *info = NULL;
-- 
1.7.12.4

