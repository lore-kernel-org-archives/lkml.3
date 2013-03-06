Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab3CFEOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 23:14:24 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:33842 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab3CFEOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 23:14:22 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-53-5136c29c0a08
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        gregkh@linuxfoundation.org, naveenkrishna.ch@gmail.com,
        lars@metafoo.de, dan.carpenter@oracle.com
Subject: [PATCH] iio: adc: exynos5_adc: fix compilation warnings
Date: Wed, 06 Mar 2013 09:41:32 +0530
Message-id: <1362543092-6446-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsWyRsSkSnfuIbNAg9Zyi3lH3rFYXN41h81i
	xvl9TA7MHp83yQUwRnHZpKTmZJalFunbJXBldG2YwViwQrjixbG3jA2MN/i7GDk5JARMJLbc
	u80OYYtJXLi3nq2LkYtDSGApo0TPnh2MMEUXv25ggUgsYpQ4+WQZI4TTwyTx+8ZVNpAqNgEz
	iYOLVgON4uAQEZCVmNmtB1LDLLCKUeLJjS9gk4QFHCTmnZ7JDGKzCKhKNE2bwApi8wq4SOw7
	3soI0ishoCAxZ5INSK+EwBk2icVfljJC1AtIfJt8iAWiRlZi0wFmiOMkJQ6uuMEygVFwASPD
	KkbR1ILkguKk9CJTveLE3OLSvHS95PzcTYzAIDv979nEHYz3D1gfYkwGGjeRWUo0OR8YpHkl
	8YbGJuamxqZmRpaWlqakCSuJ88pfkgkUEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwDi1/trE
	rHlL73/7wPLzQYy5dNAWF8XtmtOe6B3afHzBxuw3i64UfT103nXewTNuiUXb+Y/cib84V/Pd
	pr7E2gXL43k8Ilr+hzzP+Ka2K37pkxaJou8tV9c/e/tpr+XiffOjTNmOX4uUXPhTnkXJ4pXp
	019y/V1G8dfE8z7/VbpyJKNcs45/Cec2JZbijERDLeai4kQAcubXNkgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t9jAd05h8wCDd5vMrCYd+Qdi8XlXXPY
	LGac38fkwOzxeZNcAGNUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJu
	qq2Si0+ArltmDtB8JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWNG14YZ
	jAUrhCteHHvL2MB4g7+LkZNDQsBE4uLXDSwQtpjEhXvr2boYuTiEBBYxSpx8sowRwulhkvh9
	4yobSBWbgJnEwUWr2bsYOThEBGQlZnbrgdQwC6xilHhy4wsjSI2wgIPEvNMzmUFsFgFViaZp
	E1hBbF4BF4l9x1sZQXolBBQk5kyymcDIvYCRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZG
	cBA/k97BuKrB4hCjAAejEg/vBBWzQCHWxLLiytxDjBIczEoivO+WAYV4UxIrq1KL8uOLSnNS
	iw8xJgMtn8gsJZqcD4ywvJJ4Q2MTc1NjU0sTCxMzS9KElcR5GU89CRASSE8sSc1OTS1ILYLZ
	wsTBKdXAGOY7X1CvaYeOiXTwRafQ88cvsjJGRnfIu6W9zz6c88VIJ4MvsvHJ5IN5LPfX+f37
	8//Fh4upixsjIxq01b2kF5wvdHT/nzztkU5l4IQN0rI3Qz6uDV/ZZ5P+xHyXc8phpiVTTpws
	k3Bqmnvmw8aVabf3ZST8f3Jzcddnnu+CFu8jrdmPrtCeq8RSnJFoqMVcVJwIACYiDIamAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naveen Krishna Ch <ch.naveen@samsung.com>

Fixes the compilation warnings and potential NULL pointer
dereferencing pointed out by "Dan Carpenter".

Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
---
 drivers/iio/adc/exynos_adc.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index ed6fdd7..67d07aa 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -92,7 +92,7 @@ struct exynos_adc {
 	struct completion	completion;
 
 	u32			value;
-	unsigned int            version;
+	unsigned int		version;
 };
 
 static const struct of_device_id exynos_adc_match[] = {
@@ -102,12 +102,15 @@ static const struct of_device_id exynos_adc_match[] = {
 };
 MODULE_DEVICE_TABLE(of, exynos_adc_match);
 
-static inline unsigned int exynos_adc_get_version(struct platform_device *pdev)
+static inline int exynos_adc_get_version(struct platform_device *pdev)
 {
 	const struct of_device_id *match;
 
 	match = of_match_node(exynos_adc_match, pdev->dev.of_node);
-	return (unsigned int)match->data;
+	if (!match)
+		return -ENODEV;
+
+	return (int)match->data;
 }
 
 static int exynos_read_raw(struct iio_dev *indio_dev,
@@ -117,7 +120,7 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
 				long mask)
 {
 	struct exynos_adc *info = iio_priv(indio_dev);
-	unsigned long timeout;
+	int timeout;
 	u32 con1, con2;
 
 	if (mask != IIO_CHAN_INFO_RAW)
@@ -255,7 +258,7 @@ static int exynos_adc_probe(struct platform_device *pdev)
 	struct iio_dev *indio_dev = NULL;
 	struct resource	*mem;
 	int ret = -ENODEV;
-	int irq;
+	int irq, version;
 
 	if (!np)
 		return ret;
@@ -268,6 +271,15 @@ static int exynos_adc_probe(struct platform_device *pdev)
 
 	info = iio_priv(indio_dev);
 
+	version = exynos_adc_get_version(pdev);
+	if (version < 0) {
+		dev_err(&pdev->dev, "no matching of_node, err = %d\n", version);
+		ret = version;
+		goto err_iio;
+	}
+
+	info->version = version;
+
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
 	info->regs = devm_request_and_ioremap(&pdev->dev, mem);
@@ -311,8 +323,6 @@ static int exynos_adc_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 
-	info->version = exynos_adc_get_version(pdev);
-
 	platform_set_drvdata(pdev, indio_dev);
 
 	indio_dev->name = dev_name(&pdev->dev);
-- 
1.7.9.5

