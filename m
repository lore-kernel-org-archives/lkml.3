Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbaCNJaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 05:30:23 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64220 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543AbaCNJaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 05:30:15 -0400
X-AuditID: cbfee68e-b7f566d000002344-f4-5322cc2549dd
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsaung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3 2/8] devfreq: exynos4: Support devicetree to get device id of
 Exynos4 SoC
Date: Fri, 14 Mar 2014 18:30:02 +0900
Message-id: <1394789408-14648-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1394789408-14648-1-git-send-email-cw00.choi@samsung.com>
References: <1394789408-14648-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWyRsSkUFf1jFKwwbNpehYdPb9ZLK5/ec5q
	Mf/IOVaLc69WMlqcbXrDbrGwbQmLxeVdc9gsPvceYbSYcX4fk8XS6xeZLG43rmCzePPjLJPF
	hOlrWSwer3jLbvHqYBuLA7/HmnlrGD1WLv/C5rF4z0smj5/Lt7N79G1Zxehx/MZ2Jo/Pm+Q8
	Ns4NDeCI4rJJSc3JLEst0rdL4MpY1NPHUrBXoGJj93z2BsbnvF2MnBwSAiYSf98vZIWwxSQu
	3FvP1sXIxSEksJRR4vPSu6wwRdt/P2WFSCxilGh48JwZwmlkkjjz7QQjSBWbgJbE/hc32EBs
	EQFziV1Lf4KNYhZ4xiRxq7+PCSQhLBArsfnRRLCxLAKqEseaXoM18Aq4Stw8fhhqnZzEhz2P
	2EFsTgE3ibfN08AWCAHV9HUfYAIZKiHwll3iydYfUIMEJL5NPsTSxcgBlJCV2HSAGWKOpMTB
	FTdYJjAKL2BkWMUomlqQXFCclF5kpFecmFtcmpeul5yfu4kRGFen/z3r28F484D1IcZkoHET
	maVEk/OBcZlXEm9obGZkYWpiamxkbmlGmrCSOO+ih0lBQgLpiSWp2ampBalF8UWlOanFhxiZ
	ODilGhhXrN+/5sbGCbMdnIzXxBvZGjhOXraM6bDr0YC90Xee3xGa1+Nv13RWMFB85ZzvLbqt
	t/+GubwXyvVasaugbkJVT96VhzZ6ory7Ddx0I2w0Sl5ftb6/KL1NI3/5Cjnl0JSjNxyZM6tu
	bxNNK42K/i/18oeM9rajj1rvvs9afWTbjn6tAK0peh5KLMUZiYZazEXFiQAI4nTiwQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgK7qGaVggx9H1Cw6en6zWFz/8pzV
	Yv6Rc6wW516tZLQ42/SG3WJh2xIWi8u75rBZfO49wmgx4/w+Joul1y8yWdxuXMFm8ebHWSaL
	CdPXslg8XvGW3eLVwTYWB36PNfPWMHqsXP6FzWPxnpdMHj+Xb2f36NuyitHj+I3tTB6fN8l5
	bJwbGsAR1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuW
	mQN0vZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxY1FPH0vBXoGKjd3z
	2RsYn/N2MXJySAiYSGz//ZQVwhaTuHBvPVsXIxeHkMAiRomGB8+ZIZxGJokz304wglSxCWhJ
	7H9xgw3EFhEwl9i19CdYB7PAMyaJW/19TCAJYYFYic2PJoKNZRFQlTjW9BqsgVfAVeLm8cNQ
	6+QkPux5xA5icwq4Sbxtnga2QAiopq/7ANMERt4FjAyrGEVTC5ILipPScw31ihNzi0vz0vWS
	83M3MYKj9pnUDsaVDRaHGAU4GJV4eB0OKwYLsSaWFVfmHmKU4GBWEuFlmKcULMSbklhZlVqU
	H19UmpNafIgxGeiqicxSosn5wISSVxJvaGxiZmRpZG5oYWRsTpqwkjjvgVbrQCGB9MSS1OzU
	1ILUIpgtTBycUg2MGVpGS2NevuoTNHxQffrvOvX9aXk/nqeqCDs+XtXY+9FUJyzK6mRfx+eA
	Upt3UmdUnrUovip9pMno/0pJ/0uEVW0n9ysLQ5FtW9fuZgi4eDP6anTA/g11RbZNL5oEw8vu
	/MjIiTb26F7iaxdxWCBE7N7KHSafrIV23cv7ISp5Z3XmPrF7mhVKLMUZiYZazEXFiQCKTPI4
	HgMAAA==
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
index 378e4bd..2d2b44b 100644
--- a/drivers/devfreq/exynos/exynos4_bus.c
+++ b/drivers/devfreq/exynos/exynos4_bus.c
@@ -23,6 +23,7 @@
 #include <linux/devfreq.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
+#include <linux/of.h>
 #include <linux/module.h>
 
 /* Exynos4 ASV has been in the mailing list, but not upstreamed, yet. */
@@ -1014,6 +1015,28 @@ unlock:
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
@@ -1027,7 +1050,7 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	data->type = pdev->id_entry->driver_data;
+	data->type = exynos4_busfreq_get_driver_data(pdev);
 	data->dmc[0].hw_base = S5P_VA_DMC0;
 	data->dmc[1].hw_base = S5P_VA_DMC1;
 	data->pm_notifier.notifier_call = exynos4_busfreq_pm_notifier_event;
@@ -1151,6 +1174,7 @@ static struct platform_driver exynos4_busfreq_driver = {
 		.name	= "exynos4-busfreq",
 		.owner	= THIS_MODULE,
 		.pm	= &exynos4_busfreq_pm,
+		.of_match_table = exynos4_busfreq_id_match,
 	},
 };
 
-- 
1.8.0

