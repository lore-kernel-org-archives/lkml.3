Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab3CFHyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:54:23 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:46706 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab3CFHyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:54:17 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-6a-5136f62806d0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 20/30] rtc: rtc-s3c: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:54:15 +0900
Message-id: <008e01ce1a3f$cc967f80$65c37e80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAAPUiw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zfV2Nb2aBBm2ruC2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKmPfiMlvBP86KC1cfszQwzuboYuTkkBAwkfjV+JsZwhaTuHBvPVsXIxeHkMAyRolT
	c/axwBTdWbuaHSIxnVFix41NrBDOL0aJ1jenwNrZBNQkvnw5DFTFwSEioC/R1qIBUsMs0Mso
	caZ3N1hcSMBWomceD0g5p4CdxJSJj9lBbGEBN4k3Rw8wgdgsAqoSr2c1gsV5gcovL/3KDGEL
	SvyYfA/sIGYBLYn1O48zQdjyEpvXvGUGGS8hoC7x6K8uSFhEwEii4eUCZogSEYl9L94xQvxy
	j12ieZs/xCoBiW+TD7FAtMpKbDoADQdJiYMrbrBMYJSYhWTxLCSLZyFZPAvJhgWMLKsYRVML
	kguKk9KLTPWKE3OLS/PS9ZLzczcxQuJ04g7G+wesDzEmA62fyCwlmpwPjPO8knhDY2MTMxNT
	E3NLU3NT0oSVxHnlL8kECgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamAslNn2KnsWc0229g6B
	AwybGDSd2SaKHpqycM6EGfrN98ITqp++vl1RWRX066zYvY6C9eUmy5VuVwlIyVadTDq3cdH9
	GwkOJ4NEtHuF4pZNmaF36YvGqu3V6pavQ/5ulQnw3S976txuPb7rGpnsCxM2cunzKEpvaZih
	wGyi/WPZ7ilr6larTVqvxFKckWioxVxUnAgAoIfRKukCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQV2Nb2aBBh872C2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzJj34jJbwT/OigtXH7M0MM7m6GLk5JAQMJG4
	s3Y1O4QtJnHh3nq2LkYuDiGB6YwSO25sYoVwfjFKtL45xQxSxSagJvHly2GgDg4OEQF9ibYW
	DZAaZoFeRokzvbvB4kICthI983hAyjkF7CSmTHwMtkBYwE3izdEDTCA2i4CqxOtZjWBxXqDy
	y0u/MkPYghI/Jt9jAbGZBbQk1u88zgRhy0tsXvOWGWS8hIC6xKO/uiBhEQEjiYaXC5ghSkQk
	9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEp4Fn
	0jsYVzVYHGIU4GBU4uGdoGIWKMSaWFZcmXuIUYKDWUmEl+sMUIg3JbGyKrUoP76oNCe1+BBj
	MtCjE5mlRJPzgSkqryTe0NjEzMjSyMzCyMTcnDRhJXFexlNPAoQE0hNLUrNTUwtSi2C2MHFw
	SjUwKgv7fm0Vkd0/JUTH6+b3K+96PrWs/Lr0UNGd0sVCt3Rkrlbvua7/8OsUNV2DoAcG5Vwp
	fW8MhQ/ffJjmYRMuc//4L4WZh04e2cqwexq7WvXRxRPj8zMnHeuQN2fvsZENNsxZc/dI5CyV
	AMnE2ZcO736yS6qZ94Dq3+XKd3c+SJhVGD4/7dmNX0osxRmJhlrMRcWJAD5njJtHAwAA
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

 drivers/rtc/rtc-s3c.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index fb994e9..7dcf719 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -423,10 +423,7 @@ static void s3c_rtc_enable(struct platform_device *pdev, int en)
 
 static int s3c_rtc_remove(struct platform_device *dev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(dev);
-
 	platform_set_drvdata(dev, NULL);
-	rtc_device_unregister(rtc);
 
 	s3c_rtc_setaie(&dev->dev, 0);
 
@@ -511,7 +508,7 @@ static int s3c_rtc_probe(struct platform_device *pdev)
 
 	/* register RTC and exit */
 
-	rtc = rtc_device_register("s3c", &pdev->dev, &s3c_rtcops,
+	rtc = devm_rtc_device_register(&pdev->dev, "s3c", &s3c_rtcops,
 				  THIS_MODULE);
 
 	if (IS_ERR(rtc)) {
@@ -574,7 +571,6 @@ static int s3c_rtc_probe(struct platform_device *pdev)
 
  err_alarm_irq:
 	platform_set_drvdata(pdev, NULL);
-	rtc_device_unregister(rtc);
 
  err_nortc:
 	s3c_rtc_enable(pdev, 0);
-- 
1.7.2.5


