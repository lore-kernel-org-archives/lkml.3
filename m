Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbaCNJdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 05:33:19 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59049 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940AbaCNJaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 05:30:22 -0400
X-AuditID: cbfee690-b7f266d00000287c-9b-5322cc249edb
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsaung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3 1/8] devfreq: exynos4: Fix bug of resource leak and code
 clean on probe()
Date: Fri, 14 Mar 2014 18:30:01 +0900
Message-id: <1394789408-14648-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1394789408-14648-1-git-send-email-cw00.choi@samsung.com>
References: <1394789408-14648-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsWyRsSkWFfljFKwwdXn1hYdPb9ZLK5/ec5q
	Mf/IOVaLc69WMlqcbXrDbrGwbQmLxeVdc9gsPvceYbSYcX4fk8XS6xeZLG43rmCzePPjLJPF
	hOlrWSwer3jLbvHqYBuLA7/HmnlrGD1WLv/C5rF4z0smj5/Lt7N79G1Zxehx/MZ2Jo/Pm+Q8
	Ns4NDeCI4rJJSc3JLEst0rdL4MrY/3Mie8EK4YqV3WuZGhg7BboYOTkkBEwkvs+fxARhi0lc
	uLeeDcQWEljKKPH8YmwXIwdYzZ/PQCYXUHgRo8STM4fYIZxGJonvc4+xgDSwCWhJ7H9xA6xZ
	RMBcYtfSn2wgRcwCz5gkbvX3gW0QFoiV2PjwOSOIzSKgKnHwQwM7iM0r4Cqx/+MZdogr5CQ+
	7HkEZnMKuEm8bZ7GCHGRq0Rf9wGoSz+yS5x8YgQxR0Di2+RDLBCXykpsOsAMUSIpcXDFDZYJ
	jMILGBlWMYqmFiQXFCelF5noFSfmFpfmpesl5+duYgRG1Ol/zybsYLx3wPoQYzLQuInMUqLJ
	+cCIzCuJNzQ2M7IwNTE1NjK3NCNNWEmcV+1RUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkG
	xqAf3PwqL11ur2KvZHTNqMtY5eCRqpB2ovQJU2eXvsDb60m3xV8lVobeb2yrerk5Z1mo5DEv
	3sDNaz/O5BJj3X10stHieQ+uPDm6YrLgm/8T3Ha619es9mjmnMXiHiJY5PuYgydze11nizr3
	5nXex0wlTxw/MqWmWv9Nvdqd2d3mTtx6fa7pSizFGYmGWsxFxYkAU2Zhhr4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgK7KGaVggzfnTCw6en6zWFz/8pzV
	Yv6Rc6wW516tZLQ42/SG3WJh2xIWi8u75rBZfO49wmgx4/w+Joul1y8yWdxuXMFm8ebHWSaL
	CdPXslg8XvGW3eLVwTYWB36PNfPWMHqsXP6FzWPxnpdMHj+Xb2f36NuyitHj+I3tTB6fN8l5
	bJwbGsAR1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuW
	mQN0vZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxY//PiewFK4QrVnav
	ZWpg7BToYuTgkBAwkfjzObaLkRPIFJO4cG89WxcjF4eQwCJGiSdnDrFDOI1MEt/nHmMBqWIT
	0JLY/+IGG4gtImAusWvpT7AOZoFnTBK3+vuYQBLCArESGx8+ZwSxWQRUJQ5+aGAHsXkFXCX2
	fzzDDrFOTuLDnkdgNqeAm8Tb5mlg9UJANX3dB5gmMPIuYGRYxSiaWpBcUJyUnmukV5yYW1ya
	l66XnJ+7iREcs8+kdzCuarA4xCjAwajEwzvjqGKwEGtiWXFl7iFGCQ5mJRFehnlKwUK8KYmV
	ValF+fFFpTmpxYcYk4GumsgsJZqcD0wneSXxhsYmZkaWRuaGFkbG5qQJK4nzHmy1DhQSSE8s
	Sc1OTS1ILYLZwsTBKdXA2OxhFlHA8vERu9QZpSsFO0o9alQD/HsTdj2cZFm4QM+LmVtC5nTD
	PY/i5kcLVKvaXoldnpkQavO3uZF19qH4Nd9/7Oy8mR2rt/+yxMJ2pYSItOe/VzT9vf6o0/vw
	T+3PBx8qtfP+ZyxfIPwobM3Oy4zzNqTp7ct7LzBx6vPTZpPufGRSv7HeSomlOCPRUIu5qDgR
	AIypqwgdAwAA
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
 drivers/devfreq/exynos/exynos4_bus.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
index e07b0c6..378e4bd 100644
--- a/drivers/devfreq/exynos/exynos4_bus.c
+++ b/drivers/devfreq/exynos/exynos4_bus.c
@@ -765,9 +765,6 @@ static int exynos4_bus_get_dev_status(struct device *dev,
 
 static void exynos4_bus_exit(struct device *dev)
 {
-	struct busfreq_data *data = dev_get_drvdata(dev);
-
-	devfreq_unregister_opp_notifier(dev, data->devfreq);
 }
 
 static struct devfreq_dev_profile exynos4_devfreq_profile = {
@@ -1048,8 +1045,11 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
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
@@ -1086,23 +1086,39 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
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

