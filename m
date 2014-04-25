Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbaDYJI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:08:28 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:37007 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbaDYJIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:08:20 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-bc-535a26027375
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, cw00.choi@samsung.com,
        jkosina@suse.cz, labbe.montjoie@gmail.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 4/5] devfreq: exynos4: Use devm_devfreq_* function using device
 resource management
Date: Fri, 25 Apr 2014 18:08:13 +0900
Message-id: <1398416894-6782-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398416894-6782-1-git-send-email-cw00.choi@samsung.com>
References: <1398416894-6782-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsWyRsSkRJdZLSrY4PUvZouNM9azWlz/8pzV
	YvecxSwWvQuuslmcbXrDbrF+wUI2i02Pr7FaXN41h83ic+8RRosZ5/cxWdxuXMFm8ebHWSaL
	xyveslvsXNfJ7sDnsXPWXXaPxXteMnlsXlLv0bdlFaPHmQVH2D2O39jO5LH03lFGj8+b5AI4
	orhsUlJzMstSi/TtErgyzm6/zlywTqji9KzsBsZz/F2MnBwSAiYSKy42s0HYYhIX7q0Hsrk4
	hASWMko0vD7NBFP0c9MrFojEIkaJb+c7GSGcJiaJeVv2sYNUsQloSex/cQNslIiAucSupT/B
	RjEL/GWSmDHtMViRsECqxOutr1i7GDk4WARUJVbtqAUJ8wq4SMyc/4gFYpucxIc9j8DKOQVc
	Jdp/vmUFsYWAahofv2IHmSkh8JJdYuOh82AJFgEBiW+TD7GAzJQQkJXYdIAZYo6kxMEVN1gm
	MAovYGRYxSiaWpBcUJyUXmSqV5yYW1yal66XnJ+7iREYSaf/PZu4g/H+AetDjMlA4yYyS4km
	5wMjMa8k3tDYzMjC1MTU2Mjc0ow0YSVx3vRHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUa
	GNWefeKb8/bPVB2NO+q3HvB9dfl7Ke94XihH0NRAIV1L24cfkjZJ/91zLNJp55MpvJtrGB5O
	qEiO+unFMGve+d3an6T/8T9mY2vVemD5aVvF3O1vNW99DttxitGP1ejJtO12k8rUPhfyiFfO
	ZGEs1VvG5bz3i/PZP3yVIvW3c26UFfEWcF3Zz6LEUpyRaKjFXFScCACCqdJAugIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+xgC6TWlSwwcTPlhYbZ6xntbj+5Tmr
	xe45i1ksehdcZbM42/SG3WL9goVsFpseX2O1uLxrDpvF594jjBYzzu9jsrjduILN4s2Ps0wW
	j1e8ZbfYua6T3YHPY+esu+wei/e8ZPLYvKTeo2/LKkaPMwuOsHscv7GdyWPpvaOMHp83yQVw
	RDUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHa6k
	UJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzDi7/TpzwTqhitOzshsYz/F3
	MXJySAiYSPzc9IoFwhaTuHBvPVsXIxeHkMAiRolv5zsZIZwmJol5W/axg1SxCWhJ7H9xgw3E
	FhEwl9i19CdYB7PAXyaJGdMegxUJC6RKvN76irWLkYODRUBVYtWOWpAwr4CLxMz5j6C2yUl8
	2PMIrJxTwFWi/edbVhBbCKim8fEr9gmMvAsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525i
	BMfpM6kdjCsbLA4xCnAwKvHwflCLDBZiTSwrrsw9xCjBwawkwjtDIipYiDclsbIqtSg/vqg0
	J7X4EGMy0FETmaVEk/OBKSSvJN7Q2MTMyNLI3NDCyNicNGElcd4DrdaBQgLpiSWp2ampBalF
	MFuYODilGhgPZS1kyjTZNYvv8rzKxTbFfLfzuE4tcf3bZHbfKZ5JozjZab+o1W3R3DUnK/gd
	ud/Yy1n1dT97M0GgzjJZcuLHZHd11lehDzf5XN/Z3yN/037SF7dbBlseZMyPPa103KNmvlkc
	l2/on54/H/4/mhgbMDHP9PmP/n2bT4d5M0VVTmU6ZlAac1GJpTgj0VCLuag4EQALH0h4FwMA	AA==
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
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
---
 drivers/devfreq/exynos/exynos4_bus.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
index d257f1f..bebb0a4 100644
--- a/drivers/devfreq/exynos/exynos4_bus.c
+++ b/drivers/devfreq/exynos/exynos4_bus.c
@@ -979,7 +979,7 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, data);
 
-	data->devfreq = devfreq_add_device(dev, &exynos4_devfreq_profile,
+	data->devfreq = devm_devfreq_add_device(dev, &exynos4_devfreq_profile,
 					   "simple_ondemand", NULL);
 	if (IS_ERR(data->devfreq))
 		return PTR_ERR(data->devfreq);
@@ -991,27 +991,20 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
 	busfreq_mon_reset(ppmu_data);
 
 	/* Register opp_notifier for Exynos4 busfreq */
-	err = devfreq_register_opp_notifier(dev, data->devfreq);
+	err = devm_devfreq_register_opp_notifier(dev, data->devfreq);
 	if (err < 0) {
 		dev_err(dev, "Failed to register opp notifier\n");
-		goto err_notifier_opp;
+		return err;
 	}
 
 	/* Register pm_notifier for Exynos4 busfreq */
 	err = register_pm_notifier(&data->pm_notifier);
 	if (err) {
 		dev_err(dev, "Failed to setup pm notifier\n");
-		goto err_notifier_pm;
+		return err;
 	}
 
 	return 0;
-
-err_notifier_pm:
-	devfreq_unregister_opp_notifier(dev, data->devfreq);
-err_notifier_opp:
-	devfreq_remove_device(data->devfreq);
-
-	return err;
 }
 
 static int exynos4_busfreq_remove(struct platform_device *pdev)
@@ -1020,10 +1013,6 @@ static int exynos4_busfreq_remove(struct platform_device *pdev)
 
 	/* Unregister all of notifier chain */
 	unregister_pm_notifier(&data->pm_notifier);
-	devfreq_unregister_opp_notifier(data->dev, data->devfreq);
-
-	/* Remove devfreq instance */
-	devfreq_remove_device(data->devfreq);
 
 	return 0;
 }
-- 
1.8.0

