Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbaDRCVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 22:21:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56410 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaDRCUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 22:20:34 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-46-53508bf0dc9a
From: Chanwoo Choi <cw00.choi@samsung.com>
To: rjw@rjwysocki.net, viresh.kumar@linaro.org
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 1/2] cpufreq: exynos: Use dev_err/info function instead of
 pr_err/info
Date: Fri, 18 Apr 2014 11:20:33 +0900
Message-id: <1397787634-9334-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397787634-9334-1-git-send-email-cw00.choi@samsung.com>
References: <1397787634-9334-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42JZI2JSoPuhOyDYYNVKS4unTT/YLa5/ec5q
	0bvgKpvF2aY37BabHl9jtbi8aw6bxefeI4wWM87vY7I4c/oSq8XGrx4OXB53ru1h89i8pN5j
	y9V2Fo++LasYPT5vkgtgjeKySUnNySxLLdK3S+DKmHHiHGPBVJmKG5dvMjcw/hDrYuTkkBAw
	kZg//Q8rhC0mceHeerYuRi4OIYGljBLLz69mgym6cGU+K0RiEaPEm/Zd7BBOE5PEqomHWECq
	2AS0JPa/uAHUwcEhIqAn8fdzLUgNs8AvRonJfXPAVggLREjc2twHVs8ioCpxf/I+MJtXwEWi
	d/lrqDPkJD7secQOYnMKuEqcanvFDGILAdW8P7KSEaJmE7vEhO44iDkCEt8mg9zAARSXldh0
	gBmiRFLi4IobLBMYhRcwMqxiFE0tSC4oTkovMtUrTswtLs1L10vOz93ECIyA0/+eTdzBeP+A
	9SHGZKBxE5mlRJPzgRGUVxJvaGxmZGFqYmpsZG5pRpqwkjhv+qOkICGB9MSS1OzU1ILUovii
	0pzU4kOMTBycUg2M+vyhggK7N29xyw581fmuMf7W5rj1GZMkcz/fK+9wqff6U7Cz8fkUGRNJ
	xSmFlz/vOnyMPe1Gvfj0378evNo3sezwtw5fnlm594M+7wjpyFOfzK19am363O9yD38x2Uw4
	Zl4mm3toxr+AzgmcjU8tTJjcWJ9NybYxT+pRaJiWd9/I4XEYX5CoEktxRqKhFnNRcSIAawV0
	spYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t9jAd0P3QHBBs3/9S2eNv1gt7j+5Tmr
	Re+Cq2wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8nizOlLrBYbv3o4cHncubaHzWPzknqP
	LVfbWTz6tqxi9Pi8SS6ANaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEv
	MTfVVsnFJ0DXLTMH6CglhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8aM
	E+cYC6bKVNy4fJO5gfGHWBcjJ4eEgInEhSvzWSFsMYkL99azdTFycQgJLGKUeNO+ix3CaWKS
	WDXxEAtIFZuAlsT+FzeAqjg4RAT0JP5+rgWpYRb4xSgxuW8O2CRhgQiJW5v7wOpZBFQl7k/e
	B2bzCrhI9C5/DbVNTuLDnkfsIDangKvEqbZXzCC2EFDN+yMrGScw8i5gZFjFKJpakFxQnJSe
	a6hXnJhbXJqXrpecn7uJERxhz6R2MK5ssDjEKMDBqMTDK6AXECzEmlhWXJl7iFGCg1lJhFe5
	FCjEm5JYWZValB9fVJqTWnyIMRnoqonMUqLJ+cDozyuJNzQ2MTOyNDI3tDAyNidNWEmc90Cr
	daCQQHpiSWp2ampBahHMFiYOTqkGRjVf2zvTls3OEE7cyNM899TyN7eS6+qyGxzmXLo/L+Db
	zcVzDrutWzjvkNuzzI26dxeWqTGc656SWVroe/7nf6viXG3t2twIq+B1NZMY1JevEf8TxqWz
	w7rGmdNVeemrp4KvHL5VnTR+N4lLN2u59MkwxRWqc75vDA2oeHj5mUvTSdH61efSriixFGck
	GmoxFxUnAgD6BJ5g9AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses dev_err/info function to show accurate log message with device name
instead of pr_err/info function.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/cpufreq/exynos-cpufreq.c | 21 ++++++++++++---------
 drivers/cpufreq/exynos-cpufreq.h |  1 +
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index f99cfe2..8b4bb4a 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -49,6 +49,7 @@ static int exynos_cpufreq_scale(unsigned int target_freq)
 	struct cpufreq_policy *policy = cpufreq_cpu_get(0);
 	unsigned int arm_volt, safe_arm_volt = 0;
 	unsigned int mpll_freq_khz = exynos_info->mpll_freq_khz;
+	struct device *dev = exynos_info->dev;
 	unsigned int old_freq;
 	int index, old_index;
 	int ret = 0;
@@ -90,8 +91,8 @@ static int exynos_cpufreq_scale(unsigned int target_freq)
 		/* Firstly, voltage up to increase frequency */
 		ret = regulator_set_voltage(arm_regulator, arm_volt, arm_volt);
 		if (ret) {
-			pr_err("%s: failed to set cpu voltage to %d\n",
-				__func__, arm_volt);
+			dev_err(dev, "failed to set cpu voltage to %d\n",
+				arm_volt);
 			return ret;
 		}
 	}
@@ -100,8 +101,8 @@ static int exynos_cpufreq_scale(unsigned int target_freq)
 		ret = regulator_set_voltage(arm_regulator, safe_arm_volt,
 				      safe_arm_volt);
 		if (ret) {
-			pr_err("%s: failed to set cpu voltage to %d\n",
-				__func__, safe_arm_volt);
+			dev_err(dev, "failed to set cpu voltage to %d\n",
+				safe_arm_volt);
 			return ret;
 		}
 	}
@@ -115,8 +116,8 @@ static int exynos_cpufreq_scale(unsigned int target_freq)
 		ret = regulator_set_voltage(arm_regulator, arm_volt,
 				arm_volt);
 		if (ret) {
-			pr_err("%s: failed to set cpu voltage to %d\n",
-				__func__, arm_volt);
+			dev_err(dev, "failed to set cpu voltage to %d\n",
+				arm_volt);
 			goto out;
 		}
 	}
@@ -163,6 +164,8 @@ static int exynos_cpufreq_probe(struct platform_device *pdev)
 	if (!exynos_info)
 		return -ENOMEM;
 
+	exynos_info->dev = &pdev->dev;
+
 	if (soc_is_exynos4210())
 		ret = exynos4210_cpufreq_init(exynos_info);
 	else if (soc_is_exynos4212() || soc_is_exynos4412())
@@ -176,13 +179,13 @@ static int exynos_cpufreq_probe(struct platform_device *pdev)
 		goto err_vdd_arm;
 
 	if (exynos_info->set_freq == NULL) {
-		pr_err("%s: No set_freq function (ERR)\n", __func__);
+		dev_err(&pdev->dev, "No set_freq function (ERR)\n");
 		goto err_vdd_arm;
 	}
 
 	arm_regulator = regulator_get(NULL, "vdd_arm");
 	if (IS_ERR(arm_regulator)) {
-		pr_err("%s: failed to get resource vdd_arm\n", __func__);
+		dev_err(&pdev->dev, "failed to get resource vdd_arm\n");
 		goto err_vdd_arm;
 	}
 
@@ -192,7 +195,7 @@ static int exynos_cpufreq_probe(struct platform_device *pdev)
 	if (!cpufreq_register_driver(&exynos_driver))
 		return 0;
 
-	pr_err("%s: failed to register cpufreq driver\n", __func__);
+	dev_err(&pdev->dev, "failed to register cpufreq driver\n");
 	regulator_put(arm_regulator);
 err_vdd_arm:
 	kfree(exynos_info);
diff --git a/drivers/cpufreq/exynos-cpufreq.h b/drivers/cpufreq/exynos-cpufreq.h
index 3ddade8..b72ff10 100644
--- a/drivers/cpufreq/exynos-cpufreq.h
+++ b/drivers/cpufreq/exynos-cpufreq.h
@@ -34,6 +34,7 @@ struct apll_freq {
 };
 
 struct exynos_dvfs_info {
+	struct device	*dev;
 	unsigned long	mpll_freq_khz;
 	unsigned int	pll_safe_idx;
 	struct clk	*cpu_clk;
-- 
1.8.0

