Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab3CFF2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:28:06 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:48140 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3CFF2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:28:02 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-63-5136d3e04674
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 03/30] rtc: rtc-da9052: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:28:00 +0900
Message-id: <004501ce1a2b$5ddc2ef0$19948cd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAABkvA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zI90Hl80CDd5+k7BYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANYrLJiU1J7Ms
	tUjfLoEr48jd/YwF/9krlj/vY21gvMTWxcjJISFgIvHr5g4WCFtM4sK99UBxLg4hgWWMEj0n
	PjHBFP34vp8VIjGdUWLRlQ52COcXo8SeJUvBqtgE1CS+fDkMlODgEBHQl2hr0QCpYRboZZQ4
	07ubHaRGSMBW4mr3KmYQm1PATmL541ksIPXCAm4SOx4lg4RZBFQlXm87BFbOC1R+8nYnG4Qt
	KPFj8j2wS5kFtCTW7zzOBGHLS2xe85YZZIyEgLrEo7+6IGERASOJyT9fQpWLSOx78Y4R5BwJ
	gXvsEs9PzWGD2CUg8W3yIRaIXlmJTQeYIf6VlDi44gbLBEaJWUg2z0KyeRaSzbOQrFjAyLKK
	UTS1ILmgOCm9yEivODG3uDQvXS85P3cTIyRS+3Yw3jxgfYgxGWj9RGYp0eR8YKTnlcQbGhub
	mJmYmphbmpqbkiasJM4rf0kmUEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAMjN8Pz4k73+Vti
	tsubO21W/p/4O/f54/ffBO85u4ZxCLLn1Dz6Vui1JLHIQlj57WX3mE3O+nMrT6mUuJ6u8ZDb
	aNfnoLA379JVyd6A1z4SWVv/Xk/4sTTm373OfVWs3Ie3H+Bk17gjcP9uA6vRB4kbzNfiF6zM
	yp1ruIthr/mZ0EmmDuuP6zxQYinOSDTUYi4qTgQAwk5JLOoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd0Hl80CDQ7/FrFYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMePI3f2MBf/ZK5Y/72NtYLzE1sXIySEhYCLx
	4/t+VghbTOLCvfVAcS4OIYHpjBKLrnSwQzi/GCX2LFnKBFLFJqAm8eXLYaAEB4eIgL5EW4sG
	SA2zQC+jxJne3ewgNUICthJXu1cxg9icAnYSyx/PYgGpFxZwk9jxKBkkzCKgKvF62yGwcl6g
	8pO3O9kgbEGJH5PvsYDYzAJaEut3HmeCsOUlNq95ywwyRkJAXeLRX12QsIiAkcTkny+hykUk
	9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEp4Fn
	UjsYVzZYHGIU4GBU4uG1UDILFGJNLCuuzD3EKMHBrCTCy3UGKMSbklhZlVqUH19UmpNafIgx
	GejRicxSosn5wBSVVxJvaGxiZmRpZGZhZGJuTpqwkjgv46knAUIC6YklqdmpqQWpRTBbmDg4
	pRoYT56p2r9gu/H/mk16PZtOzn2WO0HcMu7LvW9Pnf8ss952vWlnx29G0e9XO93ctkYnLfjm
	mBJQ/pjn+a+31ltuGdoGHSxcl3A6oOKW/Jfa/g/qNZYyNv2nGxbxBkgFXTQ9tt250OSCekBj
	m3j3f+WM9qsHG35c2t+n9NVgu4Pu38lZO6bVHTk3RYmlOCPRUIu5qDgRADTeCSpHAwAA
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
 drivers/rtc/rtc-da9052.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-da9052.c b/drivers/rtc/rtc-da9052.c
index 0dde688..f229525 100644
--- a/drivers/rtc/rtc-da9052.c
+++ b/drivers/rtc/rtc-da9052.c
@@ -249,7 +249,7 @@ static int da9052_rtc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	rtc->rtc = devm_rtc_device_register(pdev->name, &pdev->dev,
 				       &da9052_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc))
 		return PTR_ERR(rtc->rtc);
@@ -259,9 +259,6 @@ static int da9052_rtc_probe(struct platform_device *pdev)
 
 static int da9052_rtc_remove(struct platform_device *pdev)
 {
-	struct da9052_rtc *rtc = pdev->dev.platform_data;
-
-	rtc_device_unregister(rtc->rtc);
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
-- 
1.7.2.5


