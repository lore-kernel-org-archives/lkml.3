Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab3D2JbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 05:31:23 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:63648 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab3D2JbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 05:31:22 -0400
X-AuditID: cbfee690-b7f136d000000fea-31-517e3de83bc8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH RESEND 2/2] watchdog: wm831x_wdt: use devm_gpio_request_one()
Date: Mon, 29 Apr 2013 18:31:20 +0900
Message-id: <000a01ce44bc$4ebef180$ec3cd480$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5EvEf+5FrrDCo0T4ypx10GaaR2Lg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t8zfd0XtnWBBgcmG1nMWb+GzeLywkus
	Fpd3zWGzuLFuH7vFrRkvWB1YPa5tFvM4MeM3i0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBl
	vN+xl7XgLF/F3OnzmRoYT3N3MXJySAiYSPTvm8gEYYtJXLi3nq2LkYtDSGAZo8TBl7dZYIpO
	LfzLDJFYxCjxZdNCFgjnF6PEma5lrCBVbAJqEl++HGbvYuTgEBHQl2hr0QCpYRboYJQ48HQp
	WI2wgK/EjVf/wWpYBFQl5h61BQnzClhKfD7bxQxhC0r8mHwPbDGzgJbE+p3HmSBseYnNa94y
	QxykILHj7GtGEFtEQE+isesAO0SNiMS+F+8YQfZKCOxjl7jw8hlYM4uAgMS3yYdYQPZKCMhK
	bDoANUdS4uCKGywTGMVmIVk9C8nqWUhWz0KyYgEjyypG0dSC5ILipPQiE73ixNzi0rx0veT8
	3E2MkHibsIPx3gHrQ4zJQOsnMkuJJucD4zWvJN7Q2MzIwtTE1NjI3NKMNGElcV71FutAIYH0
	xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYw1dRLVl5Tt/7Bf7jS7Ux6kEsaS7NbA9dLV2nRenn+n
	Wvbm5UkT1nqbbN1wsPXIvh/BjBt9nxr351+aMk1/3qOdSx1bdtbyXD/k3Prz4pKTtxZ9Z954
	z/Fb9/GvIY8mv0ztmblj//W6Q3kzwwu9GJ8v3+AjoSMiE9wjFnCP7bqfXJCE8MorrQeVWIoz
	Eg21mIuKEwGnRVfezQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jAd0XtnWBBr0tehZz1q9hs7i88BKr
	xeVdc9gsbqzbx25xa8YLVgdWj2ubxTxOzPjN4tG3ZRWjx+dNcgEsUQ2MNhmpiSmpRQqpecn5
	KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAe5UUyhJzSoFCAYnFxUr6dpgm
	hIa46VrANEbo+oYEwfUYGaCBhHWMGe937GUtOMtXMXf6fKYGxtPcXYycHBICJhKnFv5lhrDF
	JC7cW8/WxcjFISSwiFHiy6aFLBDOL0aJM13LWEGq2ATUJL58OczexcjBISKgL9HWogFSwyzQ
	wShx4OlSsBphAV+JG6/+g9WwCKhKzD1qCxLmFbCU+Hy2ixnCFpT4MfkeC4jNLKAlsX7ncSYI
	W15i85q3UAcpSOw4+5oRxBYR0JNo7DrADlEjIrHvxTvGCYwCs5CMmoVk1Cwko2YhaVnAyLKK
	UTS1ILmgOCk911CvODG3uDQvXS85P3cTIzian0ntYFzZYHGIUYCDUYmHN2BzbaAQa2JZcWXu
	IUYJDmYlEd4VlnWBQrwpiZVVqUX58UWlOanFhxiTgR6dyCwlmpwPTDR5JfGGxiZmRpZGZhZG
	JubmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cDoaBJwYu+GpI5dJm7b3R5MeFtzjSvE
	9ckHNo7zy0r/3glYyVHKfLi9NPfbleQ7tx72Jd3y0dl24JenG/ORSc6nWo8/PH50MV9pUNDn
	nclXcwKDXVmYK/+cMbS5/0s8U1nEXG/Nu8iq0OmM948av1d/xLtO9xO7rWAbR2de7OJzL2ef
	1jg3Z9JMJZbijERDLeai4kQA3kMZOioDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_gpio_request_one() to make cleanup paths simpler.
Also, GPIOF_DIR_OUT | GPIOF_INIT_LOW is replaced with
GPIOF_OUT_INIT_LOW.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/watchdog/wm831x_wdt.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/watchdog/wm831x_wdt.c b/drivers/watchdog/wm831x_wdt.c
index 9dcb6d0..3348ddd 100644
--- a/drivers/watchdog/wm831x_wdt.c
+++ b/drivers/watchdog/wm831x_wdt.c
@@ -247,9 +247,10 @@ static int wm831x_wdt_probe(struct platform_device *pdev)
 		reg |= pdata->software << WM831X_WDOG_RST_SRC_SHIFT;
 
 		if (pdata->update_gpio) {
-			ret = gpio_request_one(pdata->update_gpio,
-					       GPIOF_DIR_OUT | GPIOF_INIT_LOW,
-					       "Watchdog update");
+			ret = devm_gpio_request_one(&pdev->dev,
+						pdata->update_gpio,
+						GPIOF_OUT_INIT_LOW,
+						"Watchdog update");
 			if (ret < 0) {
 				dev_err(wm831x->dev,
 					"Failed to request update GPIO: %d\n",
@@ -270,7 +271,7 @@ static int wm831x_wdt_probe(struct platform_device *pdev)
 		} else {
 			dev_err(wm831x->dev,
 				"Failed to unlock security key: %d\n", ret);
-			goto err_gpio;
+			goto err;
 		}
 	}
 
@@ -278,16 +279,13 @@ static int wm831x_wdt_probe(struct platform_device *pdev)
 	if (ret != 0) {
 		dev_err(wm831x->dev, "watchdog_register_device() failed: %d\n",
 			ret);
-		goto err_gpio;
+		goto err;
 	}
 
 	dev_set_drvdata(&pdev->dev, driver_data);
 
 	return 0;
 
-err_gpio:
-	if (driver_data->update_gpio)
-		gpio_free(driver_data->update_gpio);
 err:
 	return ret;
 }
@@ -298,9 +296,6 @@ static int wm831x_wdt_remove(struct platform_device *pdev)
 
 	watchdog_unregister_device(&driver_data->wdt);
 
-	if (driver_data->update_gpio)
-		gpio_free(driver_data->update_gpio);
-
 	return 0;
 }
 
-- 
1.7.2.5


