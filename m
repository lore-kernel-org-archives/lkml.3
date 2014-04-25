Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaDYJIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:08:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13336 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbaDYJI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:08:26 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-02-535a26036a04
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, cw00.choi@samsung.com,
        jkosina@suse.cz, labbe.montjoie@gmail.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Manish Badarkhe <badarkhe.manish@gmail.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 5/5] devfreq: exynos5: Use devm_devfreq_* function using device
 resource management
Date: Fri, 25 Apr 2014 18:08:14 +0900
Message-id: <1398416894-6782-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398416894-6782-1-git-send-email-cw00.choi@samsung.com>
References: <1398416894-6782-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsWyRsSkRJdZLSrY4PMJQ4vHaxYzWWycsZ7V
	Yt7Et+wW1788Z7XYPWcxi0XvgqtsFmeb3rBbrF+wkM1i0+NrrBaXd81hs/jce4TRYsb5fUwW
	txtXsFm8+XGWyeLxCqDek396GR0EPHbOusvusXjPSyaPO9f2sHlsXlLv0bdlFaPHmQVH2D2O
	39jO5PF5k1wARxSXTUpqTmZZapG+XQJXxr1ZT5kLTolUbG7rYWpg3CHYxcjBISFgItFzvb6L
	kRPIFJO4cG89G4gtJLCUUeLpEXGIuInEkbf/GLsYuYDiixglji35wgThNDFJdJ1oYwepYhPQ
	ktj/4gZYt4iAucSupT/BbGaBy8wSj/fogtjCAqkS/759YgaxWQRUJXY8OsUIYvMKuEhsfdvN
	ArFNTuLDnkdgMzkFXCXaf75lhbjIRaLx8St2kMUSAl/ZJWbNfc8IMUhA4tvkQywQ38hKbDrA
	DDFHUuLgihssExiFFzAyrGIUTS1ILihOSi8y1CtOzC0uzUvXS87P3cQIjK3T/5717mC8fcD6
	EGMy0LiJzFKiyfnA2MwriTc0NjOyMDUxNTYytzQjTVhJnDfpYVKQkEB6YklqdmpqQWpRfFFp
	TmrxIUYmDk6pBsYgzT0nTvsKRJ7+ePeciVtnGnufiY3JAXWJyzePKC0/t6O2bmKuXr9xy/yK
	n5VejxgrvhUusA6XdJCvWBfu2vshyj+GV1b+08t5DJo6mms3rz/F2b7qUtCZQ50cQcW7fj11
	5aide+uLZEixh1nnk19TJqziu/jwV/ucrwc5z9tGpce6Ky1W01NiKc5INNRiLipOBAB2EPdf
	wwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xgC6zWlSwwb712haP1yxmstg4Yz2r
	xbyJb9ktrn95zmqxe85iFoveBVfZLM42vWG3WL9gIZvFpsfXWC0u75rDZvG59wijxYzz+5gs
	bjeuYLN48+Msk8XjFUC9J//0MjoIeOycdZfdY/Gel0wed67tYfPYvKTeo2/LKkaPMwuOsHsc
	v7GdyePzJrkAjqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUX
	nwBdt8wcoBeUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBn3Zj1lLjgl
	UrG5rYepgXGHYBcjJ4eEgInEkbf/GCFsMYkL99azdTFycQgJLGKUOLbkCxOE08Qk0XWijR2k
	ik1AS2L/ixtsILaIgLnErqU/wWxmgcvMEo/36ILYwgKpEv++fWIGsVkEVCV2PDoFtoFXwEVi
	69tuFohtchIf9jwCm8kp4CrR/vMtK4gtBFTT+PgV+wRG3gWMDKsYRVMLkguKk9JzDfWKE3OL
	S/PS9ZLzczcxgqP3mdQOxpUNFocYBTgYlXh4P6hFBguxJpYVV+YeYpTgYFYS4Z0hERUsxJuS
	WFmVWpQfX1Sak1p8iDEZ6KqJzFKiyfnAxJJXEm9obGJmZGlkbmhhZGxOmrCSOO+BVutAIYH0
	xJLU7NTUgtQimC1MHJxSDYwHueKDq3lFp8/J8BafZlfhHH9NjentksZTCs21u/6dNZk9L6j/
	77IJybMjDiz+ZMRyX1/FLiR8htO2x1nnFxvqip+aXDRLewa//o/te7MvnbfXEvTV/+Lz+NXi
	vxGs+dzmTJaZP/yuv+C/+ZHn0zm30+nrhSb4x5sub3mmw2mmoR1403jugZlKLMUZiYZazEXF
	iQDY7C07IgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses devm_devfreq_add_device()/devm_devfreq_register_opp_notifier()
to control automatically the resource of devfreq.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Manish Badarkhe <badarkhe.manish@gmail.com>
Cc: Abhilash Kesavan <a.kesavan@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
---
 drivers/devfreq/exynos/exynos5_bus.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/devfreq/exynos/exynos5_bus.c b/drivers/devfreq/exynos/exynos5_bus.c
index ab54a69..1f622f8 100644
--- a/drivers/devfreq/exynos/exynos5_bus.c
+++ b/drivers/devfreq/exynos/exynos5_bus.c
@@ -165,11 +165,6 @@ static int exynos5_int_get_dev_status(struct device *dev,
 }
 static void exynos5_int_exit(struct device *dev)
 {
-	struct platform_device *pdev = container_of(dev, struct platform_device,
-						    dev);
-	struct busfreq_data_int *data = platform_get_drvdata(pdev);
-
-	devfreq_unregister_opp_notifier(dev, data->devfreq);
 }
 
 static struct devfreq_dev_profile exynos5_devfreq_int_profile = {
@@ -343,30 +338,29 @@ static int exynos5_busfreq_int_probe(struct platform_device *pdev)
 
 	busfreq_mon_reset(ppmu_data);
 
-	data->devfreq = devfreq_add_device(dev, &exynos5_devfreq_int_profile,
+	data->devfreq = devm_devfreq_add_device(dev, &exynos5_devfreq_int_profile,
 					   "simple_ondemand", NULL);
-
 	if (IS_ERR(data->devfreq)) {
 		err = PTR_ERR(data->devfreq);
-		goto err_devfreq_add;
+		return err;
 	}
 
-	devfreq_register_opp_notifier(dev, data->devfreq);
+	err = devm_devfreq_register_opp_notifier(dev, data->devfreq);
+	if (err < 0) {
+		dev_err(dev, "Failed to register opp notifier\n");
+		return err;
+	}
 
 	err = register_pm_notifier(&data->pm_notifier);
 	if (err) {
 		dev_err(dev, "Failed to setup pm notifier\n");
-		goto err_devfreq_add;
+		return err;
 	}
 
 	/* TODO: Add a new QOS class for int/mif bus */
 	pm_qos_add_request(&data->int_req, PM_QOS_NETWORK_THROUGHPUT, -1);
 
 	return 0;
-
-err_devfreq_add:
-	devfreq_remove_device(data->devfreq);
-	return err;
 }
 
 static int exynos5_busfreq_int_remove(struct platform_device *pdev)
@@ -375,7 +369,6 @@ static int exynos5_busfreq_int_remove(struct platform_device *pdev)
 
 	pm_qos_remove_request(&data->int_req);
 	unregister_pm_notifier(&data->pm_notifier);
-	devfreq_remove_device(data->devfreq);
 
 	return 0;
 }
-- 
1.8.0

