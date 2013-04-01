Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878Ab3DAJqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:46:51 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20287 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758109Ab3DAJqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:46:49 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-06-51595788b77c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
In-reply-to: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
Subject: [PATCH 14/27] rtc: rtc-msm6242: use devm_*() functions
Date: Mon, 01 Apr 2013 18:46:48 +0900
Message-id: <001901ce2ebd$d412c6a0$7c3853e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4uvSmu8Ej3RSKpRZmzfFm2iz9KEwAAJ5UQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zY92O8MhAgzOH1CyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKeNGzgr1gtWBFd38TSwPjJr4uRk4OCQETifVXrzJC2GISF+6tZwOxhQSWMUrcnhoO
	U3Pr/l+gOBdQfBGjxM0Ff9ghnF+MEouefGEFqWITUJP48uUwUIKDQ0RAX6KtRQOkhlmgl1Hi
	TO9udoipthI/zn5nBrE5Bewk3iycB7ZZWMBe4uffZjCbRUBV4nvPNBYQmxeovn3TSSYIW1Di
	x+R7YHFmAS2J9TuPM0HY8hKb17xlBtkrIaAu8eivLkhYRMBI4teL74wQJSIS+168YwS5R0Lg
	HrvE9U2XWSB2CUh8m3yIBaJXVmLTAWaIhyUlDq64wTKBUWIWks2zkGyehWTzLCQrFjCyrGIU
	TS1ILihOSi8y1itOzC0uzUvXS87P3cQIidT+HYx3D1gfYkwGWj+RWUo0OR8Y6Xkl8YbGZkYW
	piamxkbmlmakCSuJ86q1WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYEw83GZyT2Rn6pfZ
	YqcYw/+ldLQ/c94fY17txDvrpMC0iuSpshrKTfOOX++8bSr2oe3oNG1rC8a9Bk9CGs+5rfVv
	MDgo9fJnWsIhozBP8TDDyyrybfPP3ODk9NZd5TJDU8Zz5k3rbMNyfg1735gnHTd3HZa0sbh7
	q3BJV/Tq5soOwSzDqK8HlViKMxINtZiLihMB8pc9ReoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jAd2O8MhAg00blCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzHjRs4K9YLVgRXd/E0sD4ya+LkZODgkBE4lb
	9/+yQdhiEhfurQeyuTiEBBYxStxc8IcdwvnFKLHoyRdWkCo2ATWJL18OAyU4OEQE9CXaWjRA
	apgFehklzvTuZgepERKwlfhx9jsziM0pYCfxZuE8RhBbWMBe4uffZjCbRUBV4nvPNBYQmxeo
	vn3TSSYIW1Dix+R7YHFmAS2J9TuPM0HY8hKb17xlBtkrIaAu8eivLkhYRMBI4teL74wQJSIS
	+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCE8Ez
	6R2MqxosDjEKcDAq8fBGXIgIFGJNLCuuzD3EKMHBrCTC6/MNKMSbklhZlVqUH19UmpNafIgx
	GejRicxSosn5wCSVVxJvaGxiZmRpZGZhZGJuTpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTByc
	Ug2M7h0HghbxmgQ88XcWmsC1n1ntgeSsGm6J+gIzw0XmxpIPT4krl4r1q6XJ9ezbvN3lLteN
	vLnzXXeEy/t++hcQqKYx53/xfZO8sGTjjkaxp25KlvotvznZzhtb9e9ZfunR16k8uvlm2o1N
	dSwsxnn/PV69lDZ8qOeheP69VMuUazOlIu4HlSixFGckGmoxFxUnAgD1x4UKSAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-msm6242.c |   32 +++++++++++---------------------
 1 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/rtc/rtc-msm6242.c b/drivers/rtc/rtc-msm6242.c
index 3ac1e8e..771f86a 100644
--- a/drivers/rtc/rtc-msm6242.c
+++ b/drivers/rtc/rtc-msm6242.c
@@ -194,30 +194,28 @@ static const struct rtc_class_ops msm6242_rtc_ops = {
 	.set_time	= msm6242_set_time,
 };
 
-static int __init msm6242_rtc_probe(struct platform_device *dev)
+static int __init msm6242_rtc_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct msm6242_priv *priv;
 	struct rtc_device *rtc;
 	int error;
 
-	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENODEV;
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
-	priv->regs = ioremap(res->start, resource_size(res));
-	if (!priv->regs) {
-		error = -ENOMEM;
-		goto out_free_priv;
-	}
-	platform_set_drvdata(dev, priv);
+	priv->regs = devm_ioremap(&pdev->dev, res->start, resource_size(res));
+	if (!priv->regs)
+		return -ENOMEM;
+	platform_set_drvdata(pdev, priv);
 
-	rtc = rtc_device_register("rtc-msm6242", &dev->dev, &msm6242_rtc_ops,
-				  THIS_MODULE);
+	rtc = devm_rtc_device_register(&pdev->dev, "rtc-msm6242",
+				&msm6242_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		error = PTR_ERR(rtc);
 		goto out_unmap;
@@ -227,20 +225,12 @@ static int __init msm6242_rtc_probe(struct platform_device *dev)
 	return 0;
 
 out_unmap:
-	platform_set_drvdata(dev, NULL);
-	iounmap(priv->regs);
-out_free_priv:
-	kfree(priv);
+	platform_set_drvdata(pdev, NULL);
 	return error;
 }
 
-static int __exit msm6242_rtc_remove(struct platform_device *dev)
+static int __exit msm6242_rtc_remove(struct platform_device *pdev)
 {
-	struct msm6242_priv *priv = platform_get_drvdata(dev);
-
-	rtc_device_unregister(priv->rtc);
-	iounmap(priv->regs);
-	kfree(priv);
 	return 0;
 }
 
-- 
1.7.2.5


