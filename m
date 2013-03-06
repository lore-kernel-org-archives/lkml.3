Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab3CFH47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:56:59 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:53838 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab3CFH4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:56:55 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-45-5136f6c61a4e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 28/30] rtc: rtc-tx4939: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:56:53 +0900
Message-id: <009601ce1a40$2af08d00$80d1a700$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAAVGIw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zQ91j38wCDXqfiFssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV0fvtEmvBAu6KcxPvsjUw7ubsYuTgkBAwkbh5T7WLkRPIFJO4cG89WxcjF4eQwDJG
	ifWHL7FBJEwkdu36xghiCwlMZ5TYf5cTougXo8TGz4tYQBJsAmoSX74cZgcZKiKgL9HWogFS
	wyzQyyhxpnc3WFxIwFaiZx4PSDmngJ3ElImP2UFsYQFPif8L2sDmswioSuy/chfM5gUq/3zq
	AROELSjxY/I9sFXMAloS63ceZ4Kw5SU2r3nLDPGLusSjv7ogYREBI4l561ZAlYtI7HvxjhHk
	HAmBe+wSD9ufsEDsEpD4NvkQC0SvrMSmA8wQ70pKHFxxg2UCo8QsJJtnIdk8C8nmWUhWLGBk
	WcUomlqQXFCclF5kpFecmFtcmpeul5yfu4kREqV9OxhvHrA+xJgMtH4is5Rocj4wyvNK4g2N
	jU3MTExNzC1NzU1JE1YS55W/JBMoJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgbGo38Z2+4dD
	VQEvpMMYt6rnral7FnsyfV+xK6+UWSVncdQH5tqoA1vFbGZ5SbNl3zM6yGKi97sifArz3ygW
	1/ytLatl4+b//bdLbv2VLbGh2ucU3786luv3UbLTiDskw+lzVu/XPf2OBzPXzOvdFJmqq1dg
	pTltskmScdWKh1m355SbHdzErMRSnJFoqMVcVJwIANXws5voAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd1j38wCDU51CFssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmNH77RJrwQLuinMT77I1MO7m7GLk5JAQMJHY
	tesbI4QtJnHh3no2EFtIYDqjxP67QDVcQPYvRomNnxexgCTYBNQkvnw5zN7FyMEhIqAv0dai
	AVLDLNDLKHGmdzdYXEjAVqJnHg9IOaeAncSUiY/ZQWxhAU+J/wvawHaxCKhK7L9yF8zmBSr/
	fOoBE4QtKPFj8j2wVcwCWhLrdx5ngrDlJTavecsMMl5CQF3i0V9dkLCIgJHEvHUroMpFJPa9
	eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBCeBZ9I7
	GFc1WBxiFOBgVOLhnaBiFijEmlhWXJl7iFGCg1lJhJfrDFCINyWxsiq1KD++qDQntfgQYzLQ
	oxOZpUST84EJKq8k3tDYxMzI0sjMwsjE3Jw0YSVxXsZTTwKEBNITS1KzU1MLUotgtjBxcEo1
	MM44Fsx6RX9+d+DMnU3nNfa/vvJSav48J9uThZ8szib/OBcdo3rhTWB33xr+g5d+R5p8eXv9
	dVB+q10H553mtRsvR61cFliUdXS6kM72YrHvotzRDi+/TY5uZ25ebBwTb2WzaK/A/eYlZ93n
	HPTlZOtclDnxZssM/ZeBWlsVndiO+gov+nyEeZYSS3FGoqEWc1FxIgDzx+ONRgMAAA==
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
Changes since v1:
- used 'struct device *dev' as the first argument

 drivers/rtc/rtc-tx4939.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-tx4939.c b/drivers/rtc/rtc-tx4939.c
index a12bfac..cf28f68 100644
--- a/drivers/rtc/rtc-tx4939.c
+++ b/drivers/rtc/rtc-tx4939.c
@@ -268,14 +268,13 @@ static int __init tx4939_rtc_probe(struct platform_device *pdev)
 	if (devm_request_irq(&pdev->dev, irq, tx4939_rtc_interrupt,
 			     0, pdev->name, &pdev->dev) < 0)
 		return -EBUSY;
-	rtc = rtc_device_register(pdev->name, &pdev->dev,
+	rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 				  &tx4939_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 	pdata->rtc = rtc;
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &tx4939_rtc_nvram_attr);
-	if (ret)
-		rtc_device_unregister(rtc);
+
 	return ret;
 }
 
@@ -284,7 +283,6 @@ static int __exit tx4939_rtc_remove(struct platform_device *pdev)
 	struct tx4939rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
 	sysfs_remove_bin_file(&pdev->dev.kobj, &tx4939_rtc_nvram_attr);
-	rtc_device_unregister(pdata->rtc);
 	spin_lock_irq(&pdata->lock);
 	tx4939_rtc_cmd(pdata->rtcreg, TX4939_RTCCTL_COMMAND_NOP);
 	spin_unlock_irq(&pdata->lock);
-- 
1.7.2.5


