Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab3JOFNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:13:36 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:23141 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab3JOFN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:13:28 -0400
X-AuditID: cbfee68d-b7eff6d000000f29-a7-525ccef7a11f
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de, cpgs@samsung.com
Subject: [PATCH v4] iio: exynos_adc: use wait_for_completion_timeout instead of
 interruptible
Date: Tue, 15 Oct 2013 10:45:35 +0530
Message-id: <1381814135-16252-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1381479821-17276-1-git-send-email-ch.naveen@samsung.com>
References: <1381479821-17276-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkVvf7uZgggxv/OCxeHtK0OLvsIJtF
	8+L1bBZLJs9ntZh35B2LxeVdc9gsZpzfx2SxaNt/ZgcOj9kNF1k8ds66y+6xf+4ado8lbw6x
	evRtWcXo8XmTXABbFJdNSmpOZllqkb5dAlfGtzPfWAsWK1Z0vz/C3sC4VLqLkZNDQsBE4tv2
	M+wQtpjEhXvr2boYuTiEBJYyShz5/4IVpujBsR9gRUIC0xkl/jxRhCjqYZJon9fCApJgEzCT
	OLhoNVARB4eIgKzEzG49kBpmgZ2MEj39E5lA4sIC8RJvFnuBlLMIqEpM2HmcEcTmFXCVmLPu
	G9QuRYnuZxPYQMo5Bdwkuk6IQ6x1ldi5dg/YbRICq9gl5t29wAoxR0Di2+RDLCD1EkBrNx1g
	hhgjKXFwxQ2WCYzCCxgZVjGKphYkFxQnpRcZ6hUn5haX5qXrJefnbmIEBv3pf896dzDePmB9
	iDEZaNxEZinR5Hxg1OSVxBsamxlZmJqYGhuZW5qRJqwkzqvWYh0oJJCeWJKanZpakFoUX1Sa
	k1p8iJGJg1OqgdFeof/Diuz+MGfjp4+Ev4paKVn2His5sSV+XsO1iubNVyKnJH9a/HXby/cH
	JdKr+GY9Lj7842C42amHZv5MZ+bNMHbVfv6cz4Jj3h2fnCIn6ePLXjdL9x46sv7Gea21v6+L
	RC97tm7/ki6RgD7ulFsCXOVBhdvPzL3xjePukcfKzPVNU/QuR/crsRRnJBpqMRcVJwIAAEUH
	8pACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jQd1v52KCDLZ+sLF4eUjT4uyyg2wW
	zYvXs1ksmTyf1WLekXcsFpd3zWGzmHF+H5PFom3/mR04PGY3XGTx2DnrLrvH/rlr2D2WvDnE
	6tG3ZRWjx+dNcgFsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2
	Si4+AbpumTlABykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM76d+cZa
	sFixovv9EfYGxqXSXYycHBICJhIPjv1gh7DFJC7cW88GYgsJTGeU+PNEsYuRC8juYZJon9fC
	ApJgEzCTOLhoNVADB4eIgKzEzG49kBpmgZ2MEj39E5lA4sIC8RJvFnuBlLMIqEpM2HmcEcTm
	FXCVmLPuGyvELkWJ7mcT2EDKOQXcJLpOiEOsdZXYuXYP2wRG3gWMDKsYRVMLkguKk9JzjfSK
	E3OLS/PS9ZLzczcxgmPqmfQOxlUNFocYBTgYlXh4f/DGBAmxJpYVV+YeYpTgYFYS4c2pBgrx
	piRWVqUW5ccXleakFh9iTAY6aiKzlGhyPjDe80riDY1NzE2NTS1NLEzMLEkTVhLnPdhqHSgk
	kJ5YkpqdmlqQWgSzhYmDU6qBkYdLhq159oUb7YeDFvG6+GbxRyVtShCxuOTGYCrz0Hne1jvc
	f/ne7e7OVZPJryuzLp/OJThbiHH688WHT1sbfthvYWN3ZWJGs3DcXjEBmUid3l+/FaSdlX5c
	PF2Z+23yutbdBV6i/sq3mK68LJjKd8xLe0ZO3+/gbbU6xx6nP+ZlFPr1e/lZJZbijERDLeai
	4kQAEwiR5u0CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does the following
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

 drivers/iio/adc/exynos_adc.c |   69 +++++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 31 deletions(-)

diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index d25b262..ac25e3e 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -82,7 +82,7 @@ enum adc_version {
 #define ADC_CON_EN_START	(1u << 0)
 #define ADC_DATX_MASK		0xFFF
 
-#define EXYNOS_ADC_TIMEOUT	(msecs_to_jiffies(1000))
+#define EXYNOS_ADC_TIMEOUT	(msecs_to_jiffies(100))
 
 struct exynos_adc {
 	void __iomem		*regs;
@@ -112,6 +112,30 @@ static inline unsigned int exynos_adc_get_version(struct platform_device *pdev)
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
@@ -121,6 +145,7 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
 	struct exynos_adc *info = iio_priv(indio_dev);
 	unsigned long timeout;
 	u32 con1, con2;
+	int ret;
 
 	if (mask != IIO_CHAN_INFO_RAW)
 		return -EINVAL;
@@ -145,16 +170,22 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
 				ADC_V1_CON(info->regs));
 	}
 
-	timeout = wait_for_completion_interruptible_timeout
+	INIT_COMPLETION(info->completion);
+
+	timeout = wait_for_completion_timeout
 			(&info->completion, EXYNOS_ADC_TIMEOUT);
-	*val = info->value;
+	if (timeout == 0) {
+		dev_warn(&indio_dev->dev, "Conversion timed out reseting\n");
+		exynos_adc_hw_init(info);
+		ret = -ETIMEDOUT;
+	} else {
+		*val = info->value;
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
@@ -226,30 +257,6 @@ static int exynos_adc_remove_devices(struct device *dev, void *c)
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
1.7.10.4

