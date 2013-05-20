Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab3ETGir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 02:38:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:51340 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab3ETGip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 02:38:45 -0400
X-AuditID: cbfee691-b7fef6d000002d62-c6-5199c4ee13fc
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de
Subject: [PATCH] iio: exynos_adc: fix wrong structure extration in suspend and
 resume
Date: Mon, 20 May 2013 12:04:49 +0530
Message-id: <1369031689-23189-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsWyRsSkSvfdkZmBBsv/aFmcXXaQzaJ58Xo2
	iyWT57NazDvyjsXi8q45bBYzzu9jsli07T+zA7vH7IaLLB47Z91l99g/dw27x5I3h1g9Pm+S
	C2CN4rJJSc3JLEst0rdL4MpYcXoxe8FJ7oqL848xNTA+4uxi5OSQEDCRmDK1lwnCFpO4cG89
	WxcjF4eQwFJGiVcPm1lhiro2bGYGsYUEpjNKPNpWClHUwyRxZ8ZVsG42ATOJg4tWs3cxcnCI
	CMhKzOzWA6lhFljOKLHk2gd2kBphgXCJsxe/s4HYLAKqEi9e9YDFeQVcJTbP7GcE6ZUQUJCY
	M8kGYm87u8Tqz54Q5QIS3yYfYoEokZXYdIAZokRS4uCKGywTGAUXMDKsYhRNLUguKE5KLzLV
	K07MLS7NS9dLzs/dxAgM2dP/nk3cwXj/gPUhxmSgcROZpUST84Ehn1cSb2hsZmRhamJqbGRu
	aUaasJI4r3qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxlW9fRMOvJl3auG2deYWSeI3
	tpy9aLZu1u2qh58ajX8zHDv+bl34NL65f03OeldUfnsv9OL5kj/r3KZmtF/w4zwko6D0ZZbc
	mSzDz9tq69tPq1lc3+jezDw1P/dm26/kq853A56ktAfEuTvsWVtS88R2y0kF6wWOZWWWXf68
	a5p+ifdealnBxqjEUpyRaKjFXFScCAAM/ycPbwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jQd13R2YGGtzpVLI4u+wgm0Xz4vVs
	Fksmz2e1mHfkHYvF5V1z2CxmnN/HZLFo239mB3aP2Q0XWTx2zrrL7rF/7hp2jyVvDrF6fN4k
	F8Aa1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0
	h5JCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxY8XpxewFJ7krLs4/xtTA
	+Iizi5GTQ0LARKJrw2ZmCFtM4sK99WwgtpDAdEaJR9tKuxi5gOweJok7M64ygSTYBMwkDi5a
	zd7FyMEhIiArMbNbD6SGWWA5o8SSax/YQWqEBcIlzl78DjaIRUBV4sWrHrA4r4CrxOaZ/Ywg
	vRICChJzJtlMYORewMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4Jp5J7WBc2WBxiFGA
	g1GJhzcjaGagEGtiWXFl7iFGCQ5mJRHe6G6gEG9KYmVValF+fFFpTmrxIcZkoOUTmaVEk/OB
	8ZpXEm9obGJuamxqaWJhYmZJmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYyuiYqFUlM/
	Wz+cxOkZ2nM/btbJd6WBDizryovtshT/8dVcDq41+GTke+lOp9/N0m9K7askuWL0TrwMLVyn
	9/TXIYM5WgsyJ/xcvW5ifNoRichnMedEnGz3XfNiDDj87++GHP0nzB7T1ZX8tq1aPfGEkkvy
	BKH97+uylt9cFaT6dr+/m9GJG0xKLMUZiYZazEXFiQBo/AkyzQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The exynos_adc device structure was wrongly extracted from the dev*
correcting the same.

Using the regular conversion of
struct device* -> struct platform_device* -> struct exynos_adc* seems wrong.
Instead we should be doing
struct device* -> struct iio_dev* -> struct exynos_adc*

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
 drivers/iio/adc/exynos_adc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index a6c4df5..2347df5 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -403,8 +403,8 @@ static int exynos_adc_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM_SLEEP
 static int exynos_adc_suspend(struct device *dev)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct exynos_adc *info = platform_get_drvdata(pdev);
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct exynos_adc *info = iio_priv(indio_dev);
 	u32 con;
 
 	if (info->version == ADC_V2) {
@@ -426,8 +426,8 @@ static int exynos_adc_suspend(struct device *dev)
 
 static int exynos_adc_resume(struct device *dev)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct exynos_adc *info = platform_get_drvdata(pdev);
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct exynos_adc *info = iio_priv(indio_dev);
 	int ret;
 
 	ret = regulator_enable(info->vdd);
-- 
1.7.12.4

