Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab3JKIVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 04:21:43 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:40384 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab3JKIVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:21:39 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-9d-5257b5075127
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de, tomasz.figa@gmail.com
Subject: [PATCH v3] iio: exynos_adc: use wait_for_completion_timeout instead of
 interruptible
Date: Fri, 11 Oct 2013 13:53:41 +0530
Message-id: <1381479821-17276-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1365048389-6364-1-git-send-email-naveenkrishna.ch@gmail.com>
References: <1365048389-6364-1-git-send-email-naveenkrishna.ch@gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsWyRsSkSpd9a3iQwcxWLouzyw6yWTQvXs9m
	sWTyfFaLeUfesVhc3jWHzWLG+X1MFou2/We2WLXrD6MDh8fshossHjtn3WX32D93DbvHkjeH
	WD0+b5ILYI3isklJzcksSy3St0vgyji+ej9TwWSFirnbjrI0MK6T6mLk5JAQMJE4emcBE4Qt
	JnHh3nq2LkYuDiGBpYwSDRPusMIUfWjoZQSxhQSmM0pcvs8OUdTDJPHgzhewBJuAmcTBRauB
	EhwcIgKyEjO79UBqmAX2MUpM2biVBaRGWCBeYs/G1cwgNouAqsSvdztYQOp5BVwldr4LhNil
	KNH9bAIbiM0p4CVx/N80qL2eEiebLrND1CxjlzhyVwRijIDEt8mHwMZIAK3ddIAZokRS4uCK
	GywTGIUXMDKsYhRNLUguKE5KLzLVK07MLS7NS9dLzs/dxAgM9tP/nk3cwXj/gPUhxmSgcROZ
	pUST84HRklcSb2hsZmRhamJqbGRuaUaasJI4r3qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYO
	TqkGxl22xzkjU/eWTBGQOKvoNSNMpif1AW9wwb8YsQO/Xm+3yBLLdnmZbu43Y+P3W+sL/1ek
	fHb+yvor1jFT0uJafWJYqFp64fXey+27DKUN4pyWeRuUs/IsMD2wUNcvx9Xr7xc7rquu+05w
	zFBdn/zx406Jsxa/Hx87o259dHPDnJyEHc7n6/+vUWIpzkg01GIuKk4EAG8RK/WMAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t9jQV32reFBBu1lFmeXHWSzaF68ns1i
	yeT5rBbzjrxjsbi8aw6bxYzz+5gsFm37z2yxatcfRgcOj9kNF1k8ds66y+6xf+4ado8lbw6x
	enzeJBfAGtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6Dr
	lpkDdIuSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMeP46v1MBZMVKuZu
	O8rSwLhOqouRk0NCwETiQ0MvI4QtJnHh3no2EFtIYDqjxOX77F2MXEB2D5PEgztfwIrYBMwk
	Di5aDZTg4BARkJWY2a0HUsMssI9RYsrGrSwgNcIC8RJ7Nq5mBrFZBFQlfr3bwQJSzyvgKrHz
	XSDELkWJ7mcTwHZxCnhJHP83jRFir6fEyabL7BMYeRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L
	10vOz93ECI6lZ1I7GFc2WBxiFOBgVOLhffA3LEiINbGsuDL3EKMEB7OSCO+++eFBQrwpiZVV
	qUX58UWlOanFhxiTgY6ayCwlmpwPjPO8knhDYxNzU2NTSxMLEzNL0oSVxHkPtFoHCgmkJ5ak
	ZqemFqQWwWxh4uCUamBUujhj8Xa12mcX32lctJylFnioiy0rp0U5qMk1d2Z9T+GZOVMu1e+s
	TJo828ryx6/4W5mORxdYRU1+tFv4tJKWqNLk+dwa1z5rbz7jt/xewT/XvColh9u7t7VXnohU
	KBPpDo8RU9Zs+XZx1izf6btvdPI+vr5BYvOHLaEBBZrXzz3+vmqxXnaWEktxRqKhFnNRcSIA
	pU8Y1+kCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does the following
1. use wait_for_completion_timeout instead of
   wait_for_completion_interruptible_timeout
2. Reset software if a timeout happens.
3. Also reduce the timeout to 100milli secs

Note: submitted for review at https://patchwork.kernel.org/patch/2279591/

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>
---
Changes since v1:
As per discussion at
http://marc.info/?l=linux-kernel&m=136517637228869&w=3

This patch does the following
1. use wait_for_completion_timeout instead of
   wait_for_completion_interruptible_timeout
2. Reset software if a timeout happens.
3. Also reduce the timeout to 100milli secs

Changes since v2:
None.
Rebased and reposting.

---
 drivers/iio/adc/exynos_adc.c |   66 +++++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 30 deletions(-)

diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index d25b262..f18ed7e 100644
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
@@ -145,16 +170,21 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
 				ADC_V1_CON(info->regs));
 	}
 
-	timeout = wait_for_completion_interruptible_timeout
+	timeout = wait_for_completion_timeout
 			(&info->completion, EXYNOS_ADC_TIMEOUT);
+	if (timeout == 0) {
+		dev_warn(&indio_dev->dev, "Conversion timed out reseting\n");
+		exynos_adc_hw_init(info);
+		ret = -ETIMEDOUT;
+	} else {
+		*val = info->value;
+		ret = IIO_VAL_INT;
+	}
 	*val = info->value;
 
 	mutex_unlock(&indio_dev->mlock);
 
-	if (timeout == 0)
-		return -ETIMEDOUT;
-
-	return IIO_VAL_INT;
+	return ret;
 }
 
 static irqreturn_t exynos_adc_isr(int irq, void *dev_id)
@@ -226,30 +256,6 @@ static int exynos_adc_remove_devices(struct device *dev, void *c)
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

