Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbaDYKSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 06:18:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:51849 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbaDYKQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 06:16:43 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-62-535a360ab1d5
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de, cpgs@samsung.com,
        grundler@chromium.org
Subject: [PATCH 4/5] iio: exynos_adc: do a soft reset in case of timeout
Date: Fri, 25 Apr 2014 15:44:46 +0530
Message-id: <1398420888-5506-5-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398420888-5506-1-git-send-email-ch.naveen@samsung.com>
References: <1398420888-5506-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42JZI2JSpctlFhVssHodj8XLQ5oWZ5cdZLNo
	XryezeLVkR9MFksmz2e1mHfkHYvF5V1z2CxmnN/HZLFo239mB06P2Q0XWTx2zrrL7rF/7hp2
	jyVvDrF69G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV8aiU7/ZC46IVkxtP8PWwHhHsIuRk0NC
	wESi5fVuRghbTOLCvfVsXYxcHEICSxklfh87wwxTNH/HD1aIxHRGiYW3djBDOP1MEld7p4BV
	sQmYSRxctJq9i5GDQ0RAVmJmtx5IDbPABUaJn18msILUCAt4SHx4fhDMZhFQlXi7ZyMTiM0r
	4CLx9U4rM0ivhICCxJxJNiBhTgFXifW7j4GVCwGV3N/yB+wICYFd7BKnz5xjg5gjIPFt8iEW
	iF5ZiU0HoI6WlDi44gbLBEbhBYwMqxhFUwuSC4qT0ouM9YoTc4tL89L1kvNzNzECY+D0v2f9
	OxjvHrA+xJgMNG4is5Rocj4whvJK4g2NzYwsTE1MjY3MLc1IE1YS573/MClISCA9sSQ1OzW1
	ILUovqg0J7X4ECMTB6dUA6Otdf+0z7bmCZt4LrFvE/scvmOv4aM5D3xfrn93aXuoVoS7/K5D
	qf3dC9fUWFjK/d2ZuKFMZrLswdbYU/wfGOO7776VfnZuy/fAlA2V0kslHstwTzvbeUe+XXPv
	2wfl22d/y/32KNbvwNRdnuv4DlaVtH7ijV8S8j9AaOuUm+vvvGlji+xdcnWTEktxRqKhFnNR
	cSIA/YbOmpcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t9jQV0us6hgg+WbWS1eHtK0OLvsIJtF
	8+L1bBavjvxgslgyeT6rxbwj71gsLu+aw2Yx4/w+JotF2/4zO3B6zG64yOKxc9Zddo/9c9ew
	eyx5c4jVo2/LKkaPz5vkAtiiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU
	8hJzU22VXHwCdN0yc4CuUlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBm
	LDr1m73giGjF1PYzbA2MdwS7GDk5JARMJObv+MEKYYtJXLi3nq2LkYtDSGA6o8TCWzuYIZx+
	JomrvVOYQarYBMwkDi5azd7FyMEhIiArMbNbD6SGWeACo8TPLxPAJgkLeEh8eH4QzGYRUJV4
	u2cjE4jNK+Ai8fVOKzNIr4SAgsScSTYgYU4BV4n1u4+BlQsBldzf8od1AiPvAkaGVYyiqQXJ
	BcVJ6bmGesWJucWleel6yfm5mxjBEfZMagfjygaLQ4wCHIxKPLwf1CKDhVgTy4orcw8xSnAw
	K4nwyppEBQvxpiRWVqUW5ccXleakFh9iTAY6aiKzlGhyPjD680riDY1NzE2NTS1NLEzMLEkT
	VhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qB0d9C66val4sxBmyxK56+9lUxrjetDGh3mNu5
	9O6kIKmjL59cbXNvOaj30MPceYFO1Y4fLm0zf+7T7vx58OxDP/nHL/KM1eQjjF7cWnDr9dlM
	id3Jd+bwldxMO29xvPfR7d5tz+Y+/u299K/jWetE/eXTN37K9PsQYP9HqfXuccXki8pRtS8i
	ryixFGckGmoxFxUnAgBhYB0D9AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do a soft reset software if a timeout happens.
This is applicable only for ADC_V2.

Change-Id: I939eaa06254e0b246dd636df9470f2eb392c2be1
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
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

