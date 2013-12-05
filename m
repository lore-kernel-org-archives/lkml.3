Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab3LEBDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 20:03:07 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:19692 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab3LEBDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 20:03:03 -0500
X-AuditID: cbfee68f-b7f256d000003c1b-4f-529fd0c4a008
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Kevin Hilman'" <khilman@linaro.org>,
        "'Tony Lindgren'" <tony@atomide.com>,
        "'Grygorii Strashko'" <grygorii.strashko@ti.com>,
        "'Peter Ujfalusi'" <peter.ujfalusi@ti.com>
Subject: [PATCH 1/2] rtc: rtc-twl: Use devm_*() functions
Date: Thu, 05 Dec 2013 10:03:00 +0900
Message-id: <000001cef155$be1674e0$3a435ea0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7xVbT2xOcYR3GdRSO1O8jmIZkciA==
Content-language: ko
x-cr-hashedpuzzle: TsVq XiZR Z/oE j0XL leEd qqET ynst 1yGj AAtEvA== ACd/Ow==
 ACz79Q== AD/P0w== AHVMsg== AHXHXQ== AHoa5Q==
 AIiYEQ==;9;YQAuAHoAdQBtAG0AbwBAAHQAbwB3AGUAcgB0AGUAYwBoAC4AaQB0ADsAYQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGcAcgB5AGcAbwByAGkAaQAuAHMAdAByAGEAcwBoAGsAbwBAAHQAaQAuAGMAbwBtADsAagBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGsAaABpAGwAbQBhAG4AQABsAGkAbgBhAHIAbwAuAG8AcgBnADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHAAZQB0AGUAcgAuAHUAagBmAGEAbAB1AHMAaQBAAHQAaQAuAGMAbwBtADsAcgB0AGMALQBsAGkAbgB1AHgAQABnAG8AbwBnAGwAZQBnAHIAbwB1AHAAcwAuAGMAbwBtADsAdABvAG4AeQBAAGEAdABvAG0AaQBkAGUALgBjAG8AbQA=;Sosha1_v1;7;{A3E1E5B1-6A64-404D-BC59-84D578F179D7};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Thu,
 05 Dec 2013 01:02:45
 GMT;WwBQAEEAVABDAEgAIAAxAC8AMgBdACAAcgB0AGMAOgAgAHIAdABjAC0AdAB3AGwAOgAgAFUAcwBlACAAZABlAHYAbQBfACoAKAApACAAZgB1AG4AYwB0AGkAbwBuAHMA
x-cr-puzzleid: {A3E1E5B1-6A64-404D-BC59-84D578F179D7}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t8zY90jF+YHGby6o2Gx5OJVdos569ew
	WaycwmJxeeElVouvh1cwWlzeNYfNYtbHH6wW+zs7GC32X/Fy4PT49nUSi8eeiSfZPO5c28Pm
	cWLGbxaPvi2rGD2O39jO5DF93k8mj8+b5AI4orhsUlJzMstSi/TtErgyFr3/zFQwR6qi48Na
	pgbGHtEuRk4OCQETiaXbnjFC2GISF+6tZ+ti5OIQEljGKHF8/TYmmKIz719BJaYzSkz4eJUd
	wvnFKLHs9TJmkCo2ATWJL18OAyU4OEQE9CXaWjRAapgFtjFJ/H/6iREkLixgKfFskwhIOYuA
	qsTBfYdZQWxeAVuJ1evnsUDYghI/Jt8Ds5kFtCTW7zzOBGHLS2xe85YZZIyEgLrEo7+6IGER
	AT2JBzvPsUGUiEjse/EO6pkd7BLPVyZC2KYSv6dfYQQ5R0JgIofE+knP2SBuEJD4NvkQC8RM
	WYlNB5gh6iUlDq64wTKBUWIWkotmIbloFpKLZiFZvYCRZRWjaGpBckFxUnqRsV5xYm5xaV66
	XnJ+7iZGSKz372C8e8D6EGMy0PqJzFKiyfnAVJFXEm9obGZkYWpiamxkbmlGmrCSOO/9h0lB
	QgLpiSWp2ampBalF8UWlOanFhxiZODilGhhVMg3cONe3+kZuW7irJ6on4tN7gaD/nKFh1QL5
	ySt82D32RV12n/EnK7zd4o6jg38lt4WJ28KmYqslqnM9sx9/1VnNvtRn6/N3p1QSC2T/P0zq
	unbr6eeuGSpRTrfvfo4o3FCTf9xdwuXzM0vNxAfhjrrPLUJ9NrhoHtSwqtdb4eHXzXzphhJL
	cUaioRZzUXEiAGB0ZTkLAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsVy+t9jQd0jF+YHGew9omyx5OJVdos569ew
	WaycwmJxeeElVouvh1cwWlzeNYfNYtbHH6wW+zs7GC32X/Fy4PT49nUSi8eeiSfZPO5c28Pm
	cWLGbxaPvi2rGD2O39jO5DF93k8mj8+b5AI4ohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNN
	zQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAzlNSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsS
	BNdjZIAGEtYxZix6/5mpYI5URceHtUwNjD2iXYycHBICJhJn3r9ig7DFJC7cWw9kc3EICUxn
	lJjw8So7hPOLUWLZ62XMIFVsAmoSX74cBkpwcIgI6Eu0tWiA1DALbGOS+P/0EyNIXFjAUuLZ
	JhGQchYBVYmD+w6zgti8ArYSq9fPY4GwBSV+TL4HZjMLaEms33mcCcKWl9i85i0zyBgJAXWJ
	R391QcIiAnoSD3aeY4MoEZHY9+IdI8TNO9glnq9MhLBNJX5Pv8I4gVFoFpINs5BsmIVkwywk
	oxYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECE4kz6R3MK5qsDjEKMDBqMTD+yJxfpAQ
	a2JZcWXuIUYJDmYlEd5/NUAh3pTEyqrUovz4otKc1OJDjMnAAJjILCWanA9Mcnkl8YbGJmZG
	lkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwFjDfaf/2gL9xlN7Xzv+P72k
	4K3YVZnKTLHolcFt1dcuGPyf35h5Jca6kYXJWsjo4Aqet9pWu/YVf318uDjbfL5p+5zrh678
	/7x89uyWpQHXfO4Zq7xTZFz2/uSvsLAyQ8MD0/nWJ6wPbhIrVjz9TuzDTYVVnZXtPE6sJTrx
	RgtOTPoi/tR+j4ESS3FGoqEWc1FxIgD2JKFMaAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler, and remove
unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-twl.c |   38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index c2e80d7..1915464 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -479,7 +479,7 @@ static int twl_rtc_probe(struct platform_device *pdev)
 	u8 rd_reg;
 
 	if (irq <= 0)
-		goto out1;
+		return ret;
 
 	/* Initialize the register map */
 	if (twl_class_is_4030())
@@ -489,7 +489,7 @@ static int twl_rtc_probe(struct platform_device *pdev)
 
 	ret = twl_rtc_read_u8(&rd_reg, REG_RTC_STATUS_REG);
 	if (ret < 0)
-		goto out1;
+		return ret;
 
 	if (rd_reg & BIT_RTC_STATUS_REG_POWER_UP_M)
 		dev_warn(&pdev->dev, "Power up reset detected.\n");
@@ -500,7 +500,7 @@ static int twl_rtc_probe(struct platform_device *pdev)
 	/* Clear RTC Power up reset and pending alarm interrupts */
 	ret = twl_rtc_write_u8(rd_reg, REG_RTC_STATUS_REG);
 	if (ret < 0)
-		goto out1;
+		return ret;
 
 	if (twl_class_is_6030()) {
 		twl6030_interrupt_unmask(TWL6030_RTC_INT_MASK,
@@ -512,7 +512,7 @@ static int twl_rtc_probe(struct platform_device *pdev)
 	dev_info(&pdev->dev, "Enabling TWL-RTC\n");
 	ret = twl_rtc_write_u8(BIT_RTC_CTRL_REG_STOP_RTC_M, REG_RTC_CTRL_REG);
 	if (ret < 0)
-		goto out1;
+		return ret;
 
 	/* ensure interrupts are disabled, bootloaders can be strange */
 	ret = twl_rtc_write_u8(0, REG_RTC_INTERRUPTS_REG);
@@ -522,34 +522,29 @@ static int twl_rtc_probe(struct platform_device *pdev)
 	/* init cached IRQ enable bits */
 	ret = twl_rtc_read_u8(&rtc_irq_bits, REG_RTC_INTERRUPTS_REG);
 	if (ret < 0)
-		goto out1;
+		return ret;
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	rtc = rtc_device_register(pdev->name,
-				  &pdev->dev, &twl_rtc_ops, THIS_MODULE);
+	rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
+					&twl_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
-		ret = PTR_ERR(rtc);
 		dev_err(&pdev->dev, "can't register RTC device, err %ld\n",
 			PTR_ERR(rtc));
-		goto out1;
+		return PTR_ERR(rtc);
 	}
 
-	ret = request_threaded_irq(irq, NULL, twl_rtc_interrupt,
-				   IRQF_TRIGGER_RISING | IRQF_ONESHOT,
-				   dev_name(&rtc->dev), rtc);
+	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+					twl_rtc_interrupt,
+					IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+					dev_name(&rtc->dev), rtc);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "IRQ is not free.\n");
-		goto out2;
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, rtc);
 	return 0;
-
-out2:
-	rtc_device_unregister(rtc);
-out1:
-	return ret;
 }
 
 /*
@@ -559,9 +554,6 @@ out1:
 static int twl_rtc_remove(struct platform_device *pdev)
 {
 	/* leave rtc running, but disable irqs */
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
-	int irq = platform_get_irq(pdev, 0);
-
 	mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_ALARM_M);
 	mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_TIMER_M);
 	if (twl_class_is_6030()) {
@@ -571,10 +563,6 @@ static int twl_rtc_remove(struct platform_device *pdev)
 			REG_INT_MSK_STS_A);
 	}
 
-
-	free_irq(irq, rtc);
-
-	rtc_device_unregister(rtc);
 	return 0;
 }
 
-- 
1.7.10.4


