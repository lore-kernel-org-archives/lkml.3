Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab3CFHtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:49:52 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:57375 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab3CFHtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:49:50 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-e4-5136f51ca6d0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 07/30] rtc: rtc-ds1553: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:49:48 +0900
Message-id: <008101ce1a3f$2d6b1f60$88415e20$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAAFQTQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zQ13Zr2aBBm8WMVpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MWz9nMxa85azomXeZsYFxAkcXIyeHhICJxI2fU9kgbDGJC/fW
	A9lcHEICyxglnq/czwRT1HFiMitEYhGjxJzODiYIZzaTxI7N7SwgVWwCahJfvhxm72Lk4BAR
	0Jdoa9EAqWEW6GWUONO7GywuJGAr0TOPB6ScU8BOYsrEx+wgtrCAp8TxD9+BbHYOFgFViX/e
	IFFeoOJPy1ezQdiCEj8m3wNbxCygJbF+53EmCFteYvOat8wgwyUE1CUe/dUFCYsIGEl0N99g
	hCgRkdj34h0jyDESAsvYJbaf/AbWyyIgIPFt8iEWiF5ZiU0HmCG+lZQ4uOIGywRGiVlINs9C
	snkWks2zkKxYwMiyilE0tSC5oDgpvchYrzgxt7g0L10vOT93EyMkqvp3MN49YH2IMRlo/URm
	KdHkfGBU5pXEGxobm5iZmJqYW5qam5ImrCTOK39JJlBIID2xJDU7NbUgtSi+qDQntfgQIxMH
	p1QDo8K/i0VyDPls9941msm3Tgo2W+awX9NigkTvh39GchezpZ1sZ14v+sfAG3N2f/7Cvzse
	3WIKND266fI51dOtHbde1UZapW+9fSpuz9vsnbfOde2486zyjpizyuf7IowqD2UZs7j0fPZn
	WGzwZG6IiTWLrjy16fNT+4n+76M+zJK+Ztxj8ueUmxJLcUaioRZzUXEiALOBlX7AAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgK7MV7NAg+6NFhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x49bP2YwFbzkreuZdZmxg
	nMDRxcjJISFgItFxYjIrhC0mceHeerYuRi4OIYFFjBJzOjuYIJzZTBI7NrezgFSxCahJfPly
	mL2LkYNDREBfoq1FA6SGWaCXUeJM726wuJCArUTPPB6Qck4BO4kpEx+zg9jCAp4Sxz98B7LZ
	OVgEVCX+eYNEeYGKPy1fzQZhC0r8mHwPbBGzgJbE+p3HmSBseYnNa94ygwyXEFCXePRXFyQs
	ImAk0d18gxGiRERi34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFp
	Xrpecn7uJkZwzD6T2sG4ssHiEKMAB6MSD6+FklmgEGtiWXFl7iFGCQ5mJRFerjNAId6UxMqq
	1KL8+KLSnNTiQ4zJQG9OZJYSTc4HppO8knhDYxMzI0sjMwsjE3Nz0oSVxHkZTz0JEBJITyxJ
	zU5NLUgtgtnCxMEp1cAocjT+sdVvZ06xz3P2t8ydONupismAgVFkTtcv2yUBd+Qtwz0d6q8d
	rbmV2xgu6WvwzqXua/fSW/MvyNhvtDS7fTnplZdA0roSEXt557rZ1pw60iIWPxmzPYJWKZ/b
	0/H4w/ufWfymhos7fp07fO1Go9m0bmXv5T1qL4vF0/mPhpbY+i6TF1RiKc5INNRiLipOBACw
	MwNeHQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- used 'struct device *dev' as the first argument

 drivers/rtc/rtc-ds1553.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-ds1553.c b/drivers/rtc/rtc-ds1553.c
index 25ce062..8c6c952 100644
--- a/drivers/rtc/rtc-ds1553.c
+++ b/drivers/rtc/rtc-ds1553.c
@@ -326,15 +326,14 @@ static int ds1553_rtc_probe(struct platform_device *pdev)
 		}
 	}
 
-	rtc = rtc_device_register(pdev->name, &pdev->dev,
+	rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 				  &ds1553_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 	pdata->rtc = rtc;
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &ds1553_nvram_attr);
-	if (ret)
-		rtc_device_unregister(rtc);
+
 	return ret;
 }
 
@@ -343,7 +342,6 @@ static int ds1553_rtc_remove(struct platform_device *pdev)
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
 	sysfs_remove_bin_file(&pdev->dev.kobj, &ds1553_nvram_attr);
-	rtc_device_unregister(pdata->rtc);
 	if (pdata->irq > 0)
 		writeb(0, pdata->ioaddr + RTC_INTERRUPTS);
 	return 0;
-- 
1.7.2.5


