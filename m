Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbaCMIRs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 04:17:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:8436 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbaCMIRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 04:17:39 -0400
X-AuditID: cbfee690-b7f266d00000287c-8f-5321699b317d
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsaung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 1/8] devfreq: exynos4: Support devicetree to get device id of
 Exynos4 SoC
Date: Thu, 13 Mar 2014 17:17:22 +0900
Message-id: <1394698649-20996-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
References: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsWyRsSkRHd2pmKwwa5DRhYdPb9ZLK5/ec5q
	Mf/IOVaLc69WMlqcbXrDbrGwbQmLxeVdc9gsPvceYbSYcX4fk8XS6xeZLG43rmCzePPjLJPF
	hOlrWSwer3jLbvHqYBuLA7/HmnlrGD1WLv/C5rF4z0smj5/Lt7N79G1Zxehx/MZ2Jo/Pm+Q8
	Ns4NDeCI4rJJSc3JLEst0rdL4Mro3NrGVLBXoKJ7hUUD43PeLkZODgkBE4lL93rYIGwxiQv3
	1gPZXBxCAksZJT49vsIEU/T52mQWiMR0Rok12zuZIJxGJolt/76zglSxCWhJ7H9xA2yUiIC5
	xK6lP8FGMQs8Y5K41d8H1MHBISwQK/GxOxqkhkVAVeLBxZnsIDavgKtEw7J5jBDb5CQ+7HkE
	FucUcJO4eXca2BVCQDUXWqcwg8yUEPjILjHjRysLxCABiW+TD7GAzJcQkJXYdIAZYo6kxMEV
	N1gmMAovYGRYxSiaWpBcUJyUXmSiV5yYW1yal66XnJ+7iREYU6f/PZuwg/HeAetDjMlA4yYy
	S4km5wNjMq8k3tDYzMjC1MTU2Mjc0ow0YSVxXrVHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4
	OKUaGPt2WN3/t0VToLd4/T7eTSfSDYouMefIVZc7zc5ZEq/xRfEFq5XruouGcgKc3AumnbYX
	Mu9h+H0u8+ONtUXLAmsEYmdMLN8nphXob6LJPTm6dJ6IeSBLk0PirCPLH1Ys/eLzetGMdI6w
	BfEXN/fy9Ya96JVZyyfHN6nc3GWPU9Ot0gPvK49vV2Ipzkg01GIuKk4EAGrvQSS/AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xoO7sTMVgg4VzNC06en6zWFz/8pzV
	Yv6Rc6wW516tZLQ42/SG3WJh2xIWi8u75rBZfO49wmgx4/w+Joul1y8yWdxuXMFm8ebHWSaL
	CdPXslg8XvGW3eLVwTYWB36PNfPWMHqsXP6FzWPxnpdMHj+Xb2f36NuyitHj+I3tTB6fN8l5
	bJwbGsAR1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuW
	mQN0vZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxo3NrG1PBXoGK7hUW
	DYzPebsYOTkkBEwkPl+bzAJhi0lcuLeerYuRi0NIYDqjxJrtnUwQTiOTxLZ/31lBqtgEtCT2
	v7jBBmKLCJhL7Fr6E6yDWeAZk8St/j6gDg4OYYFYiY/d0SA1LAKqEg8uzmQHsXkFXCUals1j
	hNgmJ/FhzyOwOKeAm8TNu9OYQGwhoJoLrVOYJzDyLmBkWMUomlqQXFCclJ5rqFecmFtcmpeu
	l5yfu4kRHLHPpHYwrmywOMQowMGoxMO7YrlCsBBrYllxZe4hRgkOZiURXk8fxWAh3pTEyqrU
	ovz4otKc1OJDjMlAV01klhJNzgcmk7ySeENjEzMjSyNzQwsjY3PShJXEeQ+0WgcKCaQnlqRm
	p6YWpBbBbGHi4JRqYDTZkDbt0GSb7wvP3SsRmuZXeJYh8veB+NQGqa//jqkrWYkcmfg5baqr
	tVyO1i6DjTu8vYIa13Wum7erhvGHzQq9F1es7u9XOzb5lrv4pm8KBrs+ubH8e8UwT0ErKWTp
	d6PGctP7YT779IStyqVa2nn/sPxdLLT9LONlA+Xr5in7ny3Zs293S7sSS3FGoqEWc1FxIgBF
	oC5HHAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch support DT(DeviceTree) method to probe exynos4_bus and get device
id of each Exynos4 SoC by using dt helper function.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/devfreq/exynos/exynos4_bus.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
index e07b0c6..168a7c6 100644
--- a/drivers/devfreq/exynos/exynos4_bus.c
+++ b/drivers/devfreq/exynos/exynos4_bus.c
@@ -23,6 +23,7 @@
 #include <linux/devfreq.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
+#include <linux/of.h>
 #include <linux/module.h>
 
 /* Exynos4 ASV has been in the mailing list, but not upstreamed, yet. */
@@ -1017,6 +1018,28 @@ unlock:
 	return NOTIFY_DONE;
 }
 
+static struct of_device_id exynos4_busfreq_id_match[] = {
+	{
+		.compatible = "samsung,exynos4210-busfreq",
+		.data = (void *)TYPE_BUSF_EXYNOS4210,
+	}, {
+		.compatible = "samsung,exynos4x12-busfreq",
+		.data = (void *)TYPE_BUSF_EXYNOS4x12,
+	},
+};
+
+static int exynos4_busfreq_get_driver_data(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	const struct of_device_id *match;
+
+	match = of_match_node(exynos4_busfreq_id_match, dev->of_node);
+	if (!match)
+		return -ENODEV;
+
+	return (int) match->data;
+}
+
 static int exynos4_busfreq_probe(struct platform_device *pdev)
 {
 	struct busfreq_data *data;
@@ -1030,7 +1053,7 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	data->type = pdev->id_entry->driver_data;
+	data->type = exynos4_busfreq_get_driver_data(pdev);
 	data->dmc[0].hw_base = S5P_VA_DMC0;
 	data->dmc[1].hw_base = S5P_VA_DMC1;
 	data->pm_notifier.notifier_call = exynos4_busfreq_pm_notifier_event;
@@ -1135,6 +1158,7 @@ static struct platform_driver exynos4_busfreq_driver = {
 		.name	= "exynos4-busfreq",
 		.owner	= THIS_MODULE,
 		.pm	= &exynos4_busfreq_pm,
+		.of_match_table = exynos4_busfreq_id_match,
 	},
 };
 
-- 
1.8.0

