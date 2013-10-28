Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab3J1FjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 01:39:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33708 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab3J1FjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 01:39:18 -0400
X-AuditID: cbfee68f-b7f836d000001b39-b6-526df884b17c
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de, grundler@chromium.org,
        cpgs@samsung.com
Subject: [PATCH v5] iio: exynos_adc: use wait_for_completion_timeout instead of
 interruptible
Date: Mon, 28 Oct 2013 11:11:05 +0530
Message-id: <1382938865-3779-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1381479821-17276-1-git-send-email-ch.naveen@samsung.com>
References: <1381479821-17276-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42JZI2JSpdvyIzfIYMJ1U4uXhzQtzi47yGbR
	vHg9m8WrIz+YLJZMns9qMe/IOxaLy7vmsFnMOL+PyWLRtv/MDpwesxsusnjsnHWX3WP/3DXs
	HkveHGL16NuyitHj8ya5ALYoLpuU1JzMstQifbsEroy+A5MZCx4qV2x5PJG1gXGtbBcjJ4eE
	gInEvueLWCFsMYkL99azdTFycQgJLGWUeLF9NnMXIwdY0f3b7BDxRYwSl7c/YANpEBLoYZI4
	8FQNxGYTMJM4uGg1O0i9iICsxMxuPZB6ZoELjBJN35aygsSFBeIlzu+xBylnEVCVWHz4FAuI
	zSvgIvHv8npGiBsUJbqfTWADKecUcJPoOiEOsclVYufaPWCnSQhsY5dY9KeVCWKOgMS3yYdY
	IM6Uldh0gBlijKTEwRU3WCYwCi9gZFjFKJpakFxQnJReZKxXnJhbXJqXrpecn7uJERj8p/89
	69/BePeA9SHGZKBxE5mlRJPzgdGTVxJvaGxmZGFqYmpsZG5pRpqwkjjv/YdJQUIC6Yklqdmp
	qQWpRfFFpTmpxYcYmTg4pRoYV/85+6n7XM+TJwdfHl7e9o8jmMPhSXgP04ec9TzTP15cMn26
	26XOja5SO38daF0T3MNRELB3p5OW8S8TN92KsJIiHaNbKWn2KQezO7VerVyfvqpb8ODye8sT
	PzbVpPixZeySivv5fWu52Z1VD1hmLojcUL18k1G9qozCo8y4dL20xm3+O7feVmIpzkg01GIu
	Kk4EAHUkptuUAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t9jAd2WH7lBBmdOaVm8PKRpcXbZQTaL
	5sXr2SxeHfnBZLFk8nxWi3lH3rFYXN41h81ixvl9TBaLtv1nduD0mN1wkcVj56y77B77565h
	91jy5hCrR9+WVYwenzfJBbBFNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp
	5CXmptoqufgE6Lpl5gBdpaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM
	6DswmbHgoXLFlscTWRsY18p2MXJwSAiYSNy/zd7FyAlkiklcuLeerYuRi0NIYBGjxOXtD9hA
	EkICPUwSB56qgdhsAmYSBxetZgfpFRGQlZjZrQdSzyxwgVGi6dtSVpC4sEC8xPk99iDlLAKq
	EosPn2IBsXkFXCT+XV7PCLFLUaL72QQ2kHJOATeJrhPiEJtcJXau3cM2gZF3ASPDKkbR1ILk
	guKk9FwjveLE3OLSvHS95PzcTYzg2HomvYNxVYPFIUYBDkYlHt4Na3ODhFgTy4orcw8xSnAw
	K4nw9t0CCvGmJFZWpRblxxeV5qQWH2JMBjpqIrOUaHI+MO7zSuINjU3MTY1NLU0sTMwsSRNW
	Euc92GodKCSQnliSmp2aWpBaBLOFiYNTqoFx0pPiioMzDNT/yj1alfNpe5H4bW8jjyU7b/JM
	nnduV5BE1ZYSAx/fM6Ib/Q9t/jZHVelh0pUdvU+f1VvP+t+u9O5FnZpN1NKDDJxqfU0bpSM3
	un0q3bKv1qOx5WWottKO8LBA/1WTi8y2nHiwbsGl6p0pPGKLl8Y8Np8X5rhscrya4F15XV43
	JZbijERDLeai4kQA5ukXoPECAAA=
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
4. Add INIT_COMPLETION before the wait_for_completion_timeout in raw_read()

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
+	INIT_COMPLETION(info->completion);
 
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

