Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbaDZLk5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 07:40:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:22868 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaDZLjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 07:39:47 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-1b-535b9b02f6e5
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de, cpgs@samsung.com,
        grundler@chromium.org, jic23@kernel.org
Subject: [PATCH 4/5 v2] iio: exynos_adc: do a soft reset in case of timeout
Date: Sat, 26 Apr 2014 17:07:55 +0530
Message-id: <1398512276-4105-5-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398512276-4105-1-git-send-email-ch.naveen@samsung.com>
References: <1398512276-4105-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42JZI2JSo8s0OzrYYMkkCYuXhzQtzi47yGbR
	vHg9m8WrIz+YLB40rWKyWDJ5PqvFvCPvWCwu75rDZjHj/D4mi0Xb/jM7cHnMbrjI4rFz1l12
	j02rOtk89s9dw+6x5M0hVo++LasYPT5vkgtgj+KySUnNySxLLdK3S+DKaFo6lbHgkGjF78st
	7A2MNwS7GDk5JARMJG6sO8UMYYtJXLi3nq2LkYtDSGApo0TTpFPsMEXtz6cxQiSmM0rM7X8N
	VdXPJDHpRBMbSBWbgJnEwUWrgTo4OEQEZCVmduuB1DALPGKUmPGwlxGkRljAW6K/r5MJxGYR
	UJW4evgXWJxXwEWi5eE2FpBeCQEFiTmTbEDCnAKuEhMXXQUrFwIqeTvxNdRBh9gl7j9yhRgj
	IPFt8iGoVlmJTQegnpGUOLjiBssERuEFjAyrGEVTC5ILipPSi4z0ihNzi0vz0vWS83M3MQKj
	4vS/Z307GG8esD7EmAw0biKzlGhyPjCq8kriDY3NjCxMTUyNjcwtzUgTVhLnXfQwKUhIID2x
	JDU7NbUgtSi+qDQntfgQIxMHp1QD47J7bB1Ju3psfHq/xJ2LW6+5cTqviIW12qvn5w65HxZV
	4dBVPmHHsNxLn3/RvY1TnY7XOPNMMxBgF6lQ55r+Z1Gq8kreadPes3xfL/RKclGdhJG9jHLE
	jYPeVZyhQibrWLktJt0uXhH3Z0KXxNprOgZ/frxl/udqUC+xsOILU+x5HV9llRcCSizFGYmG
	WsxFxYkANroVnqACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jQV2m2dHBBqc+8Fm8PKRpcXbZQTaL
	5sXr2SxeHfnBZPGgaRWTxZLJ81kt5h15x2JxedccNosZ5/cxWSza9p/ZgctjdsNFFo+ds+6y
	e2xa1cnmsX/uGnaPJW8OsXr0bVnF6PF5k1wAe1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8
	qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0H1KCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1D
	guB6jAzQQMIaxoympVMZCw6JVvy+3MLewHhDsIuRk0NCwESi/fk0RghbTOLCvfVsXYxcHEIC
	0xkl5va/hnL6mSQmnWhiA6liEzCTOLhoNXsXIweHiICsxMxuPZAaZoFHjBIzHvaCTRIW8Jbo
	7+tkArFZBFQlrh7+BRbnFXCRaHm4jQWkV0JAQWLOJBuQMKeAq8TERVfByoWASt5OfM0+gZF3
	ASPDKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgqHsmtYNxZYPFIUYBDkYlHt4dOVHBQqyJ
	ZcWVuYcYJTiYlUR4F6VEBwvxpiRWVqUW5ccXleakFh9iTAY6aiKzlGhyPjAh5JXEGxqbmJsa
	m1qaWJiYWZImrCTOe6DVOlBIID2xJDU7NbUgtQhmCxMHp1QDo2iG1Y1na2emn52fVrU4VNO9
	noWr0quydsmZf7vv/JDouxkp4NVluOiY49XTq/5J95pY9nC/tnwqJKSY+Vt56e6vLLNnKf+N
	3HUtfQLzxJyJBkGl509pRfr06r579l3pLq/+MvfwKscrqfE6m0/8YNXdwPWWU175iGXjk2Df
	V2X2qVIB8TqtSizFGYmGWsxFxYkARak70v4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do a soft reset software if a timeout happens.
This is applicable only for ADC_V2.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Reviewed-by: Doug Anderson <dianders@chromium.org>
---
This change is a part of the patch reviewed at https://lkml.org/lkml/2013/11/5/92

 drivers/iio/adc/exynos_adc.c |   50 ++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 24 deletions(-)

diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index 4d2467a..805c9f6 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
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
@@ -149,6 +173,8 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
 	timeout = wait_for_completion_timeout
 			(&info->completion, EXYNOS_ADC_TIMEOUT);
 	if (timeout == 0) {
+		dev_warn(&indio_dev->dev, "Conversion timed out! Resetting\n");
+		exynos_adc_hw_init(info);
 		ret = -ETIMEDOUT;
 	} else {
 		*val = info->value;
@@ -230,30 +256,6 @@ static int exynos_adc_remove_devices(struct device *dev, void *c)
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
1.7.9.5

