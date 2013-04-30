Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944Ab3D3BJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 21:09:32 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26055 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758753Ab3D3BJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 21:09:30 -0400
X-AuditID: cbfee690-b7f136d000000fea-8b-517f19c8c95f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Rafael J. Wysocki'" <rjw@sisk.pl>
Cc: linux-pm@vger.kernel.org, "'Len Brown'" <len.brown@intel.com>,
        "'Pavel Machek'" <pavel@ucw.cz>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        linux-i2c@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] PM: Add pm_ops_ptr() macro
Date: Tue, 30 Apr 2013 10:09:22 +0900
Message-id: <000201ce453f$5ce4fc90$16aef5b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5FP1F9kiI9kOQDTOmqJModGhzCsA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t8zY90TkvWBBhPXaFvMWb+GzeLywkus
	FrOm7GWy6Pj7hdHi8q45bBafe48wWtw9dZTNon9hL5PFyhOzmB04PRbvecnkcWLGbxaPvi2r
	GD0eLW5h9Dh56gmLx4rV39k9Pm+SC2CP4rJJSc3JLEst0rdL4MrYuncKW8FUvoory5rZGxhP
	cXcxcnJICJhILOjaxwRhi0lcuLeerYuRi0NIYBmjxLIHnWwwRTunXGOESCxilLh6aCcrhPOL
	UeJt3w9mkCo2ATWJL18Os3cxcnCICKhLHDspAlLDLNDHJHHg9k02kLiwgLbEuo9RIOUsAqoS
	m44vZQSxeQUsJdaf3scGYQtK/Jh8jwXEZhbQkli/8zgThC0vsXnNW2aIgxQkdpx9DdYrIqAn
	MWdqByNEjYjEvhfvwA6VEPjJLrHsYSsbxDIBiW+TD7GA3CAhICux6QDUHEmJgytusExgFJuF
	ZPUsJKtnIVk9C8mKBYwsqxhFUwuSC4qT0otM9IoTc4tL89L1kvNzNzFC4nbCDsZ7B6wPMSYD
	rZ/ILCWanA+M+7ySeENjMyMLUxNTYyNzSzPShJXEedVbrAOFBNITS1KzU1MLUovii0pzUosP
	MTJxcEo1MBZcfGrH8POJ59WzZ6esOTTVJS4/6PTluqTAb1KtB+Y+PTzxKbu36Q5Lu61iFw2n
	3637ve6Q7kPjD1uv3pvv5XruSVDfrPZZopNXbJ/t/EtUlctxrVPGw6Xpqcotm7tWOhpyr1z5
	tK9TyWVrYtkH/m6v59PFLfg0w78b3FvE/fbzJifbH0tnCnxUYinOSDTUYi4qTgQAX7KHRPEC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsVy+t9jAd0TkvWBBu1v1CzmrF/DZnF54SVW
	i1lT9jJZdPz9wmhxedccNovPvUcYLe6eOspm0b+wl8li5YlZzA6cHov3vGTyODHjN4tH35ZV
	jB6PFrcwepw89YTFY8Xq7+wenzfJBbBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjq
	GlpamCsp5CXmptoqufgE6Lpl5gDdpqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfI
	AA0krGPM2Lp3ClvBVL6KK8ua2RsYT3F3MXJySAiYSOycco0RwhaTuHBvPVsXIxeHkMAiRomr
	h3ayQji/GCXe9v1gBqliE1CT+PLlMHsXIweHiIC6xLGTIiA1zAJ9TBIHbt9kA4kLC2hLrPsY
	BVLOIqAqsen4UrAFvAKWEutP72ODsAUlfky+xwJiMwtoSazfeZwJwpaX2LzmLTPEQQoSO86+
	BusVEdCTmDO1gxGiRkRi34t3jBMYBWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6RXnFi
	bnFpXrpecn7uJkZwUngmvYNxVYPFIUYBDkYlHt4dS+oChVgTy4orcw8xSnAwK4nw1vHWBwrx
	piRWVqUW5ccXleakFh9iTAb6dCKzlGhyPjBh5ZXEGxqbmBlZGplZGJmYm5MmrCTOe7DVOlBI
	ID2xJDU7NbUgtQhmCxMHp1QD4+KmKfLu7dkHHz9fo7L3+ERDgY5m08w5fdcTejZe6prb4nRo
	ddiqHI2dUgEChw7u5r39p1+nPXh9ZPyfsFsiK332hM1I3fnV/PR1t5RHcZev7f5yeZ5y5vnn
	6zoUvuXsyBfcPMNceucJv+wZdbpJot0POSuPMC172PhANS1m2uf5uTMmMH84d1KJpTgj0VCL
	uag4EQDPxNylTgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pm_ops_ptr() macro that allows the .pm entry in the driver structures
to be assigned without having an #define xxx NULL for the case that PM is
not enabled.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/i2c/busses/i2c-s3c2410.c |    8 +-------
 include/linux/pm.h               |    2 ++
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index 6e8ee92..e7b6639 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -1218,7 +1218,6 @@ static int s3c24xx_i2c_resume(struct device *dev)
 }
 #endif
 
-#ifdef CONFIG_PM
 static const struct dev_pm_ops s3c24xx_i2c_dev_pm_ops = {
 #ifdef CONFIG_PM_SLEEP
 	.suspend_noirq = s3c24xx_i2c_suspend_noirq,
@@ -1226,11 +1225,6 @@ static const struct dev_pm_ops s3c24xx_i2c_dev_pm_ops = {
 #endif
 };
 
-#define S3C24XX_DEV_PM_OPS (&s3c24xx_i2c_dev_pm_ops)
-#else
-#define S3C24XX_DEV_PM_OPS NULL
-#endif
-
 /* device driver for platform bus bits */
 
 static struct platform_driver s3c24xx_i2c_driver = {
@@ -1240,7 +1234,7 @@ static struct platform_driver s3c24xx_i2c_driver = {
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= "s3c-i2c",
-		.pm	= S3C24XX_DEV_PM_OPS,
+		.pm	= pm_ops_ptr(&s3c24xx_i2c_dev_pm_ops),
 		.of_match_table = of_match_ptr(s3c24xx_i2c_match),
 	},
 };
diff --git a/include/linux/pm.h b/include/linux/pm.h
index a224c7f..bd50d15 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -55,8 +55,10 @@ struct device;
 
 #ifdef CONFIG_PM
 extern const char power_group_name[];		/* = "power" */
+#define pm_ops_ptr(_ptr)	(_ptr)
 #else
 #define power_group_name	NULL
+#define pm_ops_ptr(_ptr)	NULL
 #endif
 
 typedef struct pm_message {
-- 
1.7.2.5


