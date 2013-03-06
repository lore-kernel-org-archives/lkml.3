Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396Ab3CFF1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:27:15 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:15915 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab3CFF1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:27:12 -0500
X-AuditID: cbfee68d-b7f636d0000009be-03-5136d3a5c0f5
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 01/30] rtc: rtc-88pm80x: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:27:01 +0900
Message-id: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zfd2ll80CDXauVLBYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANYrLJiU1J7Ms
	tUjfLoEr413HFNaCJRwVn34YNzD+Zeti5OSQEDCR2Lr6JTOELSZx4d56oDgXh5DAMkaJBy+P
	McEULW/9yAyRmM4ocXvrIqiqX4wSV3ZMYQGpYhNQk/jy5TB7FyMHh4iAvkRbiwZIDbNAL6PE
	md7dYHFhAXeJBT3yIOUsAqoSa1/9BGvlFbCVuNPTwwZhC0r8mHwPLM4soCWxfudxJghbXmLz
	mrfMIGMkBNQlHv3VBQmLCOhJtM06CVUiIrHvxTtGkLUSAofYJea+XsECsUtA4tvkQywQvbIS
	mw5APSwpcXDFDZYJjGKzkGyehWTzLCSbZyFZsYCRZRWjaGpBckFxUnqRoV5xYm5xaV66XnJ+
	7iZGSNz17mC8fcD6EGMy0PqJzFKiyfnAuM0riTc0NjYxMzE1Mbc0NTclTVhJnFfukkygkEB6
	YklqdmpqQWpRfFFpTmrxIUYmDk6pBkbpKF3muyfmPUyfyrDs4keRl0+uLlvBVcn9a+58y0Nm
	X3823vTy8nayjN7733/yNv+yrNdSxl6LixZtW7dzV5rHbh8D/t25rP7bSzJc7nieXNjxLMr8
	rdrO/U37BBOieFc6h6xTU2vRutf126CMMdolIeZOh/7Pk/5557P9X2eu+R9lOYn9GrsSS3FG
	oqEWc1FxIgBIkAnR0QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jQd2ll80CDe6elrZYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMeNdxxTWgiUcFZ9+GDcw/mXrYuTkkBAwkVje
	+pEZwhaTuHBvPVCci0NIYDqjxO2ti6CcX4wSV3ZMYQGpYhNQk/jy5TB7FyMHh4iAvkRbiwZI
	DbNAL6PEmd7dYHFhAXeJBT3yIOUsAqoSa1/9BGvlFbCVuNPTwwZhC0r8mHwPLM4soCWxfudx
	JghbXmLzmrfMIGMkBNQlHv3VBQmLCOhJtM06CVUiIrHvxTvGCYwCs5BMmoVk0iwkk2YhaVnA
	yLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIziqn0ntYFzZYHGIUYCDUYmH10LJLFCINbGs
	uDL3EKMEB7OSCC/XGaAQb0piZVVqUX58UWlOavEhxmSgRycyS4km5wMTTl5JvKGxiZmRpZGZ
	hZGJuTlpwkrivIynngQICaQnlqRmp6YWpBbBbGHi4JRqYCyq3GGdrtFXcqFz3YUFW5h8ZjY7
	Xkg1O3Epd6mRNMNrKSHj2K/me04LeQpbrG1cOtmh58hrv061+dfjKh96XT29kf/gIetPBmdn
	Rsz8zXqP6ZH1nBTFpS5RniZxHN90pvPlVRYvylvVafbm4K4z3z64fdGp/qs5s3KjtNrdsBdu
	f1vf2jozTVRiKc5INNRiLipOBAD5TFnKLgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-88pm80x.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-88pm80x.c b/drivers/rtc/rtc-88pm80x.c
index 63b17eb..3e2d264 100644
--- a/drivers/rtc/rtc-88pm80x.c
+++ b/drivers/rtc/rtc-88pm80x.c
@@ -312,7 +312,7 @@ static int pm80x_rtc_probe(struct platform_device *pdev)
 	}
 	rtc_tm_to_time(&tm, &ticks);
 
-	info->rtc_dev = rtc_device_register("88pm80x-rtc", &pdev->dev,
+	info->rtc_dev = devm_rtc_device_register("88pm80x-rtc", &pdev->dev,
 					    &pm80x_rtc_ops, THIS_MODULE);
 	if (IS_ERR(info->rtc_dev)) {
 		ret = PTR_ERR(info->rtc_dev);
@@ -346,7 +346,6 @@ static int pm80x_rtc_remove(struct platform_device *pdev)
 {
 	struct pm80x_rtc_info *info = platform_get_drvdata(pdev);
 	platform_set_drvdata(pdev, NULL);
-	rtc_device_unregister(info->rtc_dev);
 	pm80x_free_irq(info->chip, info->irq, info);
 	return 0;
 }
-- 
1.7.2.5


