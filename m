Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbaDPK12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:27:28 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:12483 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211AbaDPK1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:27:06 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-f3-534e5af727cf
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>
Subject: [PATCH 3/8] extcon: gpio: Use devm_extcon_dev_register()
Date: Wed, 16 Apr 2014 19:26:58 +0900
Message-id: <1397644023-32516-4-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397644023-32516-1-git-send-email-sangjung.woo@samsung.com>
References: <1397644023-32516-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsWyRsSkWPdHlF+wwa45jBbXvzxntbi8aw6b
	xe3GFWwWC/aUOLB49G1ZxejxeZNcAFMUl01Kak5mWWqRvl0CV8a2pZMYC17xVWxvjGpgXMjT
	xcjJISFgIrGrvYcZwhaTuHBvPVsXIxeHkMBSRolfP6YzwRT963jJDJFYxCgx5cExRginjUli
	6aYusCo2AV2JJwcug40SEQiW6Dh5HCzOLOApMXdyFxuILSzgKLFly3ewOIuAqsSke5OBBnFw
	8Ap4SEw94gBiSggoSMyZZANSwQnUufnVN2aQsBBQxb2vZiBbJQRes0ks/HGPHWKKgMS3yYdY
	IFplJTYdgPpFUuLgihssExiFFzAyrGIUTS1ILihOSi8y1StOzC0uzUvXS87P3cQIDNHT/55N
	3MF4/4D1IcZkoHETmaVEk/OBIZ5XEm9obGZkYWpiamxkbmlGmrCSOG/6o6QgIYH0xJLU7NTU
	gtSi+KLSnNTiQ4xMHJxSDYw6XQ6MZdKHvm3YdiD5lmxWZef+3IcnDul+KntxgjHd+Kfunrt/
	tuyR/ufEe+IKF2OS8Ov69KvuIsUL53885iWct6H6/ZwDrxdrbDAVV570ePO/Xe73cq33+zlG
	O+ht1ts0LfFpidSna8zaG/LjO46USla3lZ65cVRvmYoy721jjTmrHVu2FU5TYinOSDTUYi4q
	TgQAznhHymcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t9jAd3vUX7BBr2HzSyuf3nOanF51xw2
	i9uNK9gsFuwpcWDx6NuyitHj8ya5AKaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0Nd
	Q0sLcyWFvMTcVFslF58AXbfMHKBFSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM
	0EDCGsaMbUsnMRa84qvY3gh00EKeLkZODgkBE4l/HS+ZIWwxiQv31rN1MXJxCAksYpSY8uAY
	I4TTxiSxdFMXE0gVm4CuxJMDl8E6RASCJTpOHgeLMwt4Ssyd3MUGYgsLOEps2fIdLM4ioCox
	6d5koEEcHLwCHhJTjziAmBICChJzJtmAVHACdW5+9Y0ZJCwEVHHvq9kERt4FjAyrGEVTC5IL
	ipPScw31ihNzi0vz0vWS83M3MYIj4JnUDsaVDRaHGAU4GJV4eGfk+AYLsSaWFVfmHmKU4GBW
	EuFtjPQLFuJNSaysSi3Kjy8qzUktPsSYDHTSRGYp0eR8YHTmlcQbGpuYGVkamRtaGBmbkyas
	JM57oNU6UEggPbEkNTs1tSC1CGYLEwenVAPjtHlv65myA/ayrCz6taT2WFjY6ivfE1pX8k5z
	r5f2fLVpw5PGNXaum577LJO1OJbBsCRJjOO+iI5g29xm/eD/jZv7k3JbvbaI5v/dtGHvVOFH
	r0x2X15dtLhJ//vKAP/jvWd+876WqpQqLpUWsd3vv9e0r/fv8xpRmVv9hkdzFzcYXFmdE8yr
	xFKckWioxVxUnAgAtDBnD8QCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the resource-managed extcon device register function (i.e.
devm_extcon_dev_register()) instead of extcon_dev_register(). If extcon device
is attached with this function, that extcon device is automatically unregistered
on driver detach. That reduces tiresome managing code.

Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
---
 drivers/extcon/extcon-gpio.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index 13d5222..43af34c 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -121,34 +121,27 @@ static int gpio_extcon_probe(struct platform_device *pdev)
 				msecs_to_jiffies(pdata->debounce);
 	}
 
-	ret = extcon_dev_register(&extcon_data->edev);
+	ret = devm_extcon_dev_register(&pdev->dev, &extcon_data->edev);
 	if (ret < 0)
 		return ret;
 
 	INIT_DELAYED_WORK(&extcon_data->work, gpio_extcon_work);
 
 	extcon_data->irq = gpio_to_irq(extcon_data->gpio);
-	if (extcon_data->irq < 0) {
-		ret = extcon_data->irq;
-		goto err;
-	}
+	if (extcon_data->irq < 0)
+		return extcon_data->irq;
 
 	ret = request_any_context_irq(extcon_data->irq, gpio_irq_handler,
 				      pdata->irq_flags, pdev->name,
 				      extcon_data);
 	if (ret < 0)
-		goto err;
+		return ret;
 
 	platform_set_drvdata(pdev, extcon_data);
 	/* Perform initial detection */
 	gpio_extcon_work(&extcon_data->work.work);
 
 	return 0;
-
-err:
-	extcon_dev_unregister(&extcon_data->edev);
-
-	return ret;
 }
 
 static int gpio_extcon_remove(struct platform_device *pdev)
@@ -157,7 +150,6 @@ static int gpio_extcon_remove(struct platform_device *pdev)
 
 	cancel_delayed_work_sync(&extcon_data->work);
 	free_irq(extcon_data->irq, extcon_data);
-	extcon_dev_unregister(&extcon_data->edev);
 
 	return 0;
 }
-- 
1.7.9.5

