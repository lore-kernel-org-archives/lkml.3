Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179AbaEIHoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:44:04 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:30189 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaEIHnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:43:19 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-a1-536c87165745
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, jkosina@suse.cz,
        labbe.montjoie@gmail.com, a.kesavan@samsung.com,
        sreekumar.c@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Manish Badarkhe <badarkhe.manish@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv2 5/5] devfreq: exynos5: Use devm_devfreq_* function using
 device resource management
Date: Fri, 09 May 2014 16:43:11 +0900
Message-id: <1399621391-27228-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1399621391-27228-1-git-send-email-cw00.choi@samsung.com>
References: <1399621391-27228-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsWyRsSkQFesPSfYYOFmKYvHaxYzWWycsZ7V
	Yt7Et+wW1788Z7XYPWcxi0XvgqtsFmeb3rBbrF+wkM1i0+NrrBaXd81hs/jce4TRYsb5fUwW
	txtXsFm8+XGWyeLxCqDek396GS0OPlzA7CDosXPWXXaPxXteMnncubaHzWPzknqPvi2rGD3O
	LDjC7nH8xnYmj8+b5AI4orhsUlJzMstSi/TtErgy5v55x17QLV6x5sYqlgbGI8JdjJwcEgIm
	Ev0XTrNA2GISF+6tZ+ti5OIQEljKKPFvzhH2LkYOsKKrX9gh4osYJbqXz4EqamKSmHiyiR2k
	m01AS2L/ixtsILaIgLnErqU/wWxmgRfMEs8Wy4EMEhZIlzh7Uw8kzCKgKjHp515GkDCvgKvE
	gpsCEDfISXzY8whsIqeAm8T6tgnMILYQUMnkZV1gayUEfrJLNN/dzAgxR0Di2+RDLBB3ykps
	OsAMMUdS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLSK07MLS7NS9dLzs/dxAiMsdP/nvXtYLx5
	wPoQYzLQuInMUqLJ+cAYzSuJNzQ2M7IwNTE1NjK3NCNNWEmcd9HDpCAhgfTEktTs1NSC1KL4
	otKc1OJDjEwcnFINjMbS2nxJzHXS5ml5dVMKjh7cY713V+MP47jPhiJ7TD/PPpV9QsxSWbDS
	L0JmoseiDq+yTtbrTKkvvJ5sdZnKvdJchtl6B/c2LaVztcfEUn7rcPVnht/Js1m0IL6y/mP3
	xtby2y9rj5rPCa+Yc33OQcktdiZ2v0/HBy94+SCXcVHX6mN/n55+qcRSnJFoqMVcVJwIAJ9c
	e+HHAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAV2x9pxgg7fXBSwer1nMZLFxxnpW
	i3kT37JbXP/ynNVi95zFLBa9C66yWZxtesNusX7BQjaLTY+vsVpc3jWHzeJz7xFGixnn9zFZ
	3G5cwWbx5sdZJovHK4B6T/7pZbQ4+HABs4Ogx85Zd9k9Fu95yeRx59oeNo/NS+o9+rasYvQ4
	s+AIu8fxG9uZPD5vkgvgiGpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshL
	zE21VXLxCdB1y8wB+kNJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmDH3
	zzv2gm7xijU3VrE0MB4R7mLk4JAQMJG4+oW9i5ETyBSTuHBvPVsXIxeHkMAiRonu5XOgnCYm
	iYknm8Cq2AS0JPa/uMEGYosImEvsWvoTzGYWeMEs8WyxHMhQYYF0ibM39UDCLAKqEpN+7mUE
	CfMKuEosuCkAsUtO4sOeR2ATOQXcJNa3TWAGsYWASiYv62KbwMi7gJFhFaNoakFyQXFSeq6R
	XnFibnFpXrpecn7uJkZwBD+T3sG4qsHiEKMAB6MSD++LKdnBQqyJZcWVuYcYJTiYlUR4pdJz
	goV4UxIrq1KL8uOLSnNSiw8xJgMdNZFZSjQ5H5hc8kriDY1NzIwsjcwNLYyMzUkTVhLnPdhq
	HSgkkJ5YkpqdmlqQWgSzhYmDU6qBMfZaxN4ndcrJCjc269p+/fiXL8dejHWyYlmZmfXyRffW
	X2QJ1DgQ9p456WO7AePmHTts+TIY3OOFjzVN3N6Xc+/F4zMfgrMmnJUWaQqcyC+5VNrA2dsi
	9VDizIsC9d/W/tukLZdqHzrZj0eMaZaM1bZD5QuWWwcoTfhx9cGZb7N9yqwP6f2do8RSnJFo
	qMVcVJwIAPiVPWUkAwAA
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
 drivers/devfreq/exynos/exynos5_bus.c | 29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/devfreq/exynos/exynos5_bus.c b/drivers/devfreq/exynos/exynos5_bus.c
index ab54a69..6cd0392 100644
--- a/drivers/devfreq/exynos/exynos5_bus.c
+++ b/drivers/devfreq/exynos/exynos5_bus.c
@@ -163,21 +163,12 @@ static int exynos5_int_get_dev_status(struct device *dev,
 
 	return 0;
 }
-static void exynos5_int_exit(struct device *dev)
-{
-	struct platform_device *pdev = container_of(dev, struct platform_device,
-						    dev);
-	struct busfreq_data_int *data = platform_get_drvdata(pdev);
-
-	devfreq_unregister_opp_notifier(dev, data->devfreq);
-}
 
 static struct devfreq_dev_profile exynos5_devfreq_int_profile = {
 	.initial_freq		= 160000,
 	.polling_ms		= 100,
 	.target			= exynos5_busfreq_int_target,
 	.get_dev_status		= exynos5_int_get_dev_status,
-	.exit			= exynos5_int_exit,
 };
 
 static int exynos5250_init_int_tables(struct busfreq_data_int *data)
@@ -343,30 +334,27 @@ static int exynos5_busfreq_int_probe(struct platform_device *pdev)
 
 	busfreq_mon_reset(ppmu_data);
 
-	data->devfreq = devfreq_add_device(dev, &exynos5_devfreq_int_profile,
+	data->devfreq = devm_devfreq_add_device(dev, &exynos5_devfreq_int_profile,
 					   "simple_ondemand", NULL);
+	if (IS_ERR(data->devfreq))
+		return PTR_ERR(data->devfreq);
 
-	if (IS_ERR(data->devfreq)) {
-		err = PTR_ERR(data->devfreq);
-		goto err_devfreq_add;
+	err = devm_devfreq_register_opp_notifier(dev, data->devfreq);
+	if (err < 0) {
+		dev_err(dev, "Failed to register opp notifier\n");
+		return err;
 	}
 
-	devfreq_register_opp_notifier(dev, data->devfreq);
-
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
@@ -375,7 +363,6 @@ static int exynos5_busfreq_int_remove(struct platform_device *pdev)
 
 	pm_qos_remove_request(&data->int_req);
 	unregister_pm_notifier(&data->pm_notifier);
-	devfreq_remove_device(data->devfreq);
 
 	return 0;
 }
-- 
1.8.0

