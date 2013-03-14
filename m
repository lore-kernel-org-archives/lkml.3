Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab3CNIYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:24:15 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:26478 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968Ab3CNIYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:24:11 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-b3-5141892b1e1d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 29/30] rtc: rtc-wm8350: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:24:10 +0900
Message-id: <00a001ce208d$4db9c1a0$e92d44e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAAedJA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t8zY13tTsdAg1mvmC2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKmL+XtaCFq+LA+ycsDYxbOLoYOTgkBEwkPqxV7WLkBDLFJC7cW8/WxcjFISSwjFGi
	/9x2RoiEiUT/iWWMEInpjBILLz+Dcn4xSqy7/ZMVpIpNQE3iy5fD7CBTRQT0JdpaNEBqmAV6
	GSXO9O4GiwsJ2Epc/28HYnIK2ElsWC8G0iks4Cbx7tUjsF0sAqoS89ZMYwGxeYGq5/x+yQ5h
	C0r8mHwPLM4soCWxfudxJghbXmLzmrfMEL+oSzz6qwsSFhEwkni3spkdokREYt+Ld2AXSwjc
	Y5c4eG8SE8QuAYlvkw+xQPTKSmw6wAzxrqTEwRU3WCYwSsxCsnkWks2zkGyehWTFAkaWVYyi
	qQXJBcVJ6UWmesWJucWleel6yfm5mxghMTpxB+P9A9aHGJOB1k9klhJNzgfGeF5JvKGxmZGF
	qYmpsZG5pRlpwkrivOot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGDlW/FJZUbxV0nnH
	eye3FCbOKD7nY5ejNpdEf+J8uYq9Ov5uWaVgzvvkb+aNkkc+2vSWHtq+Wkw4PntF9o20/tXe
	Pw4wt3ddELxszCWfdTP2pjKjA9+ER0WT+j89qWF8dSbU4+OxXhYz9lqNjScuPbB82itRd9Km
	eV9y/dnjO7zP/pkkY+TUpcRSnJFoqMVcVJwIANMZb0PnAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQV2tTsdAg7MfbSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzJi/l7WghaviwPsnLA2MWzi6GDk5JARMJPpP
	LGOEsMUkLtxbz9bFyMUhJDCdUWLh5WeMEM4vRol1t3+yglSxCahJfPlymL2LkYNDREBfoq1F
	A6SGWaCXUeJM726wuJCArcT1/3YgJqeAncSG9WIgncICbhLvXj0C28UioCoxb800FhCbF6h6
	zu+X7BC2oMSPyffA4swCWhLrdx5ngrDlJTavecsMMlJCQF3i0V9dkLCIgJHEu5XN7BAlIhL7
	XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYJTwDPp
	HYyrGiwOMQpwMCrx8EaIOgYKsSaWFVfmHmKU4GBWEuH19AIK8aYkVlalFuXHF5XmpBYfYkwG
	enQis5Rocj4wPeWVxBsam5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dU
	A2Nh5NfAr7ekf1TPnfowL6tK3DLM449o/8/8lrvR25+meH7e48KzJC5r444w59Wl++8oxvK/
	YlqgmKySIRydbth0++FHl0Rx9+V2c9rqVwepneEwi0jwEmaufbnBVWb3fosTs65a5H/UPPZu
	h+ey647TpkuzPf3w7dD8gFVfZ6c+O7y5smxBqooSS3FGoqEWc1FxIgCuzbxyRQMAAA==
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
 drivers/rtc/rtc-wm8350.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-wm8350.c b/drivers/rtc/rtc-wm8350.c
index 8ad86ae..af81dd6 100644
--- a/drivers/rtc/rtc-wm8350.c
+++ b/drivers/rtc/rtc-wm8350.c
@@ -439,8 +439,8 @@ static int wm8350_rtc_probe(struct platform_device *pdev)
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	wm_rtc->rtc = rtc_device_register("wm8350", &pdev->dev,
-					  &wm8350_rtc_ops, THIS_MODULE);
+	wm_rtc->rtc = devm_rtc_device_register(&pdev->dev, "wm8350",
+					&wm8350_rtc_ops, THIS_MODULE);
 	if (IS_ERR(wm_rtc->rtc)) {
 		ret = PTR_ERR(wm_rtc->rtc);
 		dev_err(&pdev->dev, "failed to register RTC: %d\n", ret);
@@ -462,13 +462,10 @@ static int wm8350_rtc_probe(struct platform_device *pdev)
 static int wm8350_rtc_remove(struct platform_device *pdev)
 {
 	struct wm8350 *wm8350 = platform_get_drvdata(pdev);
-	struct wm8350_rtc *wm_rtc = &wm8350->rtc;
 
 	wm8350_free_irq(wm8350, WM8350_IRQ_RTC_SEC, wm8350);
 	wm8350_free_irq(wm8350, WM8350_IRQ_RTC_ALM, wm8350);
 
-	rtc_device_unregister(wm_rtc->rtc);
-
 	return 0;
 }
 
-- 
1.7.2.5


