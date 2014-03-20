Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbaCTDCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 23:02:50 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36117 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaCTC7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 22:59:21 -0400
X-AuditID: cbfee690-b7f266d00000287c-88-532a59878b83
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, t.figa@samsaung.com, b.zolnierkie@samsaung.com,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv4 1/5] devfreq: exynos4: Fix bug of resource leak and code
 clean on probe()
Date: Thu, 20 Mar 2014 11:59:09 +0900
Message-id: <1395284353-22458-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1395284353-22458-1-git-send-email-cw00.choi@samsung.com>
References: <1395284353-22458-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWyRsSkSLcjUivYYPUuRouOnt8sFte/PGe1
	ONv0ht3i8q45bBYzzu9jsrjduILN4vGKt+wWN6fOZnLg8Fi85yWTx8/l29k9+rasYvT4vEku
	gCWKyyYlNSezLLVI3y6BK+P706nMBStFKza8OsHcwHhLsIuRk0NCwETi0ZntbBC2mMSFe+uB
	bC4OIYGljBJn9/xigSm69+MdVGIRo8TmGzegnEYmiUdLT4G1swloSex/cQPMFhEwl9i19CdY
	EbPATkaJ/bcXMYIkhAViJfb33AIbyyKgKnHizxywOK+Aq8THuc9YIdbJSXzY84gdxOYUcJM4
	+ng22FAhoJoPPSBxLqCa6ewS1z9eYoYYJCDxbfIhoKEcQAlZiU0HmCHmSEocXHGDZQKj8AJG
	hlWMoqkFyQXFSelFJnrFibnFpXnpesn5uZsYgaF++t+zCTsY7x2wPsSYDDRuIrOUaHI+MFby
	SuINjc2MLExNTI2NzC3NSBNWEudVe5QUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoGx3G5e
	+D9lyXshxz5snVgZ9zh2Vf+f7DqD2dU/dFgXrZ9R9K2pYsVemRUinv3sFfI7LUVaqthf+d5g
	c+zQj5v7/82+W3M9Kr/v7a+bFm5u4Prxg4d37HYNs/h3CkEVH3N+et66Obkv1eH1rH3y+R4T
	V3Nnai7Pm7tL7cxj5TPthSoHFgi5qXArsRRnJBpqMRcVJwIAVDzUJ4sCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t9jAd32SK1gg7cNZhYdPb9ZLK5/ec5q
	cbbpDbvF5V1z2CxmnN/HZHG7cQWbxeMVb9ktbk6dzeTA4bF4z0smj5/Lt7N79G1ZxejxeZNc
	AEtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtAd
	SgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaM70+nMhesFK3Y8OoEcwPj
	LcEuRk4OCQETiXs/3rFB2GISF+6tB7K5OIQEFjFKbL5xA8ppZJJ4tPQUWBWbgJbE/hc3wGwR
	AXOJXUt/ghUxC+xklNh/exEjSEJYIFZif88tFhCbRUBV4sSfOWBxXgFXiY9zn7FCrJOT+LDn
	ETuIzSngJnH08WywoUJANR96HrFPYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4
	kp5J72Bc1WBxiFGAg1GJh3fFHs1gIdbEsuLK3EOMEhzMSiK81u5awUK8KYmVValF+fFFpTmp
	xYcYk4GumsgsJZqcD4zyvJJ4Q2MTMyNLI3NDCyNjc9KElcR5D7ZaBwoJpCeWpGanphakFsFs
	YeLglGpgLJwq5jHF49Q711DD9cWPz66r0WmTZXfWWfznUusZ0+Iff6+8OGJ9jol1eqwa92HT
	FXLxecmsSUdTD+se3+L3/WK9hm/FR/1j3WeS3ttZCuXVfdf48bRU6EZ8U/PmOatF2oLZvjbs
	+/Jfe5FPlOgCRpv7ltmP/go51+QYr1fqSp91WrfZY7WWEktxRqKhFnNRcSIAiQGWDegCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix bug about resource leak when happening probe fail and code clean
to add debug message.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/devfreq/exynos/exynos4_bus.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
index e07b0c6..4c1bbd9 100644
--- a/drivers/devfreq/exynos/exynos4_bus.c
+++ b/drivers/devfreq/exynos/exynos4_bus.c
@@ -763,19 +763,11 @@ static int exynos4_bus_get_dev_status(struct device *dev,
 	return 0;
 }
 
-static void exynos4_bus_exit(struct device *dev)
-{
-	struct busfreq_data *data = dev_get_drvdata(dev);
-
-	devfreq_unregister_opp_notifier(dev, data->devfreq);
-}
-
 static struct devfreq_dev_profile exynos4_devfreq_profile = {
 	.initial_freq	= 400000,
 	.polling_ms	= 50,
 	.target		= exynos4_bus_target,
 	.get_dev_status	= exynos4_bus_get_dev_status,
-	.exit		= exynos4_bus_exit,
 };
 
 static int exynos4210_init_tables(struct busfreq_data *data)
@@ -1048,8 +1040,11 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
 		dev_err(dev, "Cannot determine the device id %d\n", data->type);
 		err = -EINVAL;
 	}
-	if (err)
+	if (err) {
+		dev_err(dev, "Cannot initialize busfreq table %d\n",
+			     data->type);
 		return err;
+	}
 
 	data->vdd_int = devm_regulator_get(dev, "vdd_int");
 	if (IS_ERR(data->vdd_int)) {
@@ -1086,23 +1081,39 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
 	if (IS_ERR(data->devfreq))
 		return PTR_ERR(data->devfreq);
 
-	devfreq_register_opp_notifier(dev, data->devfreq);
+	/* Register opp_notifier for Exynos4 busfreq */
+	err = devfreq_register_opp_notifier(dev, data->devfreq);
+	if (err < 0) {
+		dev_err(dev, "Failed to register opp notifier\n");
+		goto err_notifier_opp;
+	}
 
+	/* Register pm_notifier for Exynos4 busfreq */
 	err = register_pm_notifier(&data->pm_notifier);
 	if (err) {
 		dev_err(dev, "Failed to setup pm notifier\n");
-		devfreq_remove_device(data->devfreq);
-		return err;
+		goto err_notifier_pm;
 	}
 
 	return 0;
+
+err_notifier_pm:
+	devfreq_unregister_opp_notifier(dev, data->devfreq);
+err_notifier_opp:
+	devfreq_remove_device(data->devfreq);
+
+	return err;
 }
 
 static int exynos4_busfreq_remove(struct platform_device *pdev)
 {
 	struct busfreq_data *data = platform_get_drvdata(pdev);
 
+	/* Unregister all of notifier chain */
 	unregister_pm_notifier(&data->pm_notifier);
+	devfreq_unregister_opp_notifier(data->dev, data->devfreq);
+
+	/* Remove devfreq instance */
 	devfreq_remove_device(data->devfreq);
 
 	return 0;
-- 
1.8.0

