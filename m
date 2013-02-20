Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933878Ab3BTGLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 01:11:20 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:17808 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933529Ab3BTGLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 01:11:15 -0500
X-AuditID: cbfee68e-b7fc26d000001938-8d-5124690258c6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
In-reply-to: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
Subject: [PATCH 04/11] mfd: intel_msic: use devm_gpio_request_one()
Date: Wed, 20 Feb 2013 15:11:14 +0900
Message-id: <002901ce0f31$16413770$42c3a650$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4PMNZl2zNDd+kPTaydPUTuUPUSLQAACwww
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zY12mTJVAg47j4haXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj7eXfbAXLeSo6z95iamBs5Opi5OSQEDCR6N16hg3CFpO4cG89
	mC0ksIxRYvm/jC5GDrCa48t4uhi5gMLTGSWWLJ7LBuHMZpJY/2I+M0gDm4CaxJcvh9lBbBEB
	LYnuY+fZQJqZBVwkjk4TgZhpK/F97T9WEJtTwE5i16PzYLawgLPEmVkrmUBsFgFVid2HVoLF
	eYHqfz/ewQJhC0r8mHwPzGYGGr9+53EmCFteYvOat8wQd6pLPPqrC3GBkcSH59OhSkQk9r14
	xwhysoTAPHaJaZNeskPsEpD4NvkQC0SvrMSmA8yQYJCUOLjiBssERolZSDbPQrJ5FpLNs5Cs
	WMDIsopRNLUguaA4Kb3ISK84Mbe4NC9dLzk/dxMjJKr6djDePGB9iDEZaP1EZinR5HxgVOaV
	xBsaG5uYmZiamFuampuSJqwkzit/SSZQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2NVa6qu
	iqvRh5ldLEHcP8ynCerdqJ7/9Pj3O5sdvF9phvMmF0tUKy1I2eH25FbT+/4DchbL7i+Jmp+6
	/OP/KzM/r0l2PRS7xSZTik/uZjT/4/O/mddMaLvzylPcMzgrfF+M4uJF/zbN2/Z/SziH26UH
	nE8ZF4WqXL09z+L9z2BvzYrT017JXl+uxFKckWioxVxUnAgATzpd2MACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xoC5TpkqgwYzbwhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4+3l32wFy3kqOs/eYmpg
	bOTqYuTgkBAwkTi+jKeLkRPIFJO4cG89WxcjF4eQwHRGiSWL50I5s5kk1r+YzwxSxSagJvHl
	y2F2EFtEQEui+9h5NpBBzAIuEkeniYCEhQRsJb6v/ccKYnMK2EnsenQezBYWcJY4M2slE4jN
	IqAqsfvQSrA4L1D978c7WCBsQYkfk++B2cxA49fvPM4EYctLbF7zlhniZnWJR391IS4wkvjw
	fDpUiYjEvhfvGCcwCs1CMmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FwjveLE3OLSvHS95Pzc
	TYzgqH0mvYNxVYPFIUYBDkYlHt6GhcqBQqyJZcWVuYcYJTiYlUR4m51UAoV4UxIrq1KL8uOL
	SnNSiw8xJgM9OpFZSjQ5H5hQ8kriDY1NzIwsjcwsjEzMzUkTVhLnZTz1JEBIID2xJDU7NbUg
	tQhmCxMHp1QDY3SakHqNltiuDafebzlhJPir7hzXOYErUlMnvj3wbu+KR6Wt/eUdHCWSz7c2
	z1J+nss/93Dd3yfrL8XNjSx16M4+ye3fdybX6YaJsshzgT15Oi+5O5bF/TWoF5RVTD6+7uBz
	5R5bvuyFLnOEPbfUN61Y1X9qZrLg/YZ6vfBa3bVBcop+ZR2+SizFGYmGWsxFxYkA5d7u6B4D	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_gpio_request_one() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/intel_msic.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/intel_msic.c b/drivers/mfd/intel_msic.c
index 1804331..5be3b5e 100644
--- a/drivers/mfd/intel_msic.c
+++ b/drivers/mfd/intel_msic.c
@@ -323,7 +323,8 @@ static int intel_msic_init_devices(struct intel_msic *msic)
 	if (pdata->ocd) {
 		unsigned gpio = pdata->ocd->gpio;
 
-		ret = gpio_request_one(gpio, GPIOF_IN, "ocd_gpio");
+		ret = devm_gpio_request_one(&pdev->dev, gpio,
+					GPIOF_IN, "ocd_gpio");
 		if (ret) {
 			dev_err(&pdev->dev, "failed to register OCD GPIO\n");
 			return ret;
@@ -332,7 +333,6 @@ static int intel_msic_init_devices(struct intel_msic *msic)
 		ret = gpio_to_irq(gpio);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "no IRQ number for OCD GPIO\n");
-			gpio_free(gpio);
 			return ret;
 		}
 
@@ -359,8 +359,6 @@ static int intel_msic_init_devices(struct intel_msic *msic)
 
 fail:
 	mfd_remove_devices(&pdev->dev);
-	if (pdata->ocd)
-		gpio_free(pdata->ocd->gpio);
 
 	return ret;
 }
@@ -368,12 +366,8 @@ fail:
 static void intel_msic_remove_devices(struct intel_msic *msic)
 {
 	struct platform_device *pdev = msic->pdev;
-	struct intel_msic_platform_data *pdata = pdev->dev.platform_data;
 
 	mfd_remove_devices(&pdev->dev);
-
-	if (pdata->ocd)
-		gpio_free(pdata->ocd->gpio);
 }
 
 static int intel_msic_probe(struct platform_device *pdev)
-- 
1.7.2.5


