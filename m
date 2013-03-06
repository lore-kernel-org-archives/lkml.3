Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab3CFFbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:31:17 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:25399 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab3CFFbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:31:15 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-0c-5136d4a2cb73
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 12/30] rtc: rtc-lpc32xx: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:31:14 +0900
Message-id: <004e01ce1a2b$d185dd10$74919730$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAAIrSA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zA91FV8wCDQ52S1pc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mvve3mQrmcFQsm/KQsYHxC1sXIyeHhICJxIq9L5kgbDGJC/fW
	A8W5OIQEljFK/Pw/mxWmqPf4MmaIxCJGiSVb/7BCOLOZJA5PvwrWziagJvHly2H2LkYODhEB
	fYm2Fg2QGmaBXkaJM7272UFqhARsJa52r2IGsTkF7CSWP57FAlIvLOAusfeLPIjJIqAq8Wpt
	EEgFL1D1p0VH2CFsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nLDNIqIaAu8eivLkhYRMBIomHm
	aXaIEhGJfS/eMYJcIyGwjF1i6uTfjCAJFgEBiW+TD7FA9MpKbDrADPGupMTBFTdYJjBKzEKy
	eRaSzbOQbJ6FZMUCRpZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGCFxNXEH4/0D1ocYk4HW
	T2SWEk3OB8ZlXkm8obGxiZmJqYm5pam5KWnCSuK88pdkAoUE0hNLUrNTUwtSi+KLSnNSiw8x
	MnFwSjUwTg+6+kLsU5pfk65Uw4UVosVvGedN+altpr5/+he+3+dWf+E09C08e4o95kzsr6+M
	P/Q+n3x23O/RwtWOE26/ecJ9a+c0y38/7TaVX163ipFbjDNlYpe8rHGalFDCwvnLAtc9u/7x
	m2KB3HxTbf+5P+y7owWU/j1iLXghkL6AZ7vSfm2hVtP/R5RYijMSDbWYi4oTAT3gYF7BAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgO6iK2aBBj3vhC0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jRt/720wFczgqlk15yNjA
	+IWti5GTQ0LARKL3+DJmCFtM4sK99UBxLg4hgUWMEku2/mGFcGYzSRyefpUJpIpNQE3iy5fD
	7F2MHBwiAvoSbS0aIDXMAr2MEmd6d7OD1AgJ2Epc7V4FNpVTwE5i+eNZLCD1wgLuEnu/yIOY
	LAKqEq/WBoFU8AJVf1p0hB3CFpT4MfkeC4jNLKAlsX7ncSYIW15i85q3zCCtEgLqEo/+6oKE
	RQSMJBpmnmaHKBGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rqFecmFtc
	mpeul5yfu4kRHLXPpHYwrmywOMQowMGoxMNroWQWKMSaWFZcmXuIUYKDWUmEl+sMUIg3JbGy
	KrUoP76oNCe1+BBjMtCfE5mlRJPzgQklryTe0NjEzMjSyMzCyMTcnDRhJXFexlNPAoQE0hNL
	UrNTUwtSi2C2MHFwSjUw8s0v/fVYjiU+ln36w6PmH08nJ+g96WRsEPNZFH3xr+pX3f251Syc
	Z2R3akZUKUgr+Rx4EJVgr535Si7CfAJjw25dtr8XAhgkJeeG/Xi87tmT/klBizbxG5kWftkq
	kXSa5YXXBsUSnWkKZxdwRcUHrjWv4lvd8VGyTc4hqy/nROeDZVGTRGWUWIozEg21mIuKEwEM
	MN+IHgMAAA==
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
 drivers/rtc/rtc-lpc32xx.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-lpc32xx.c b/drivers/rtc/rtc-lpc32xx.c
index 40a5983..a0709f9 100644
--- a/drivers/rtc/rtc-lpc32xx.c
+++ b/drivers/rtc/rtc-lpc32xx.c
@@ -273,8 +273,8 @@ static int lpc32xx_rtc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, rtc);
 
-	rtc->rtc = rtc_device_register(RTC_NAME, &pdev->dev, &lpc32xx_rtc_ops,
-		THIS_MODULE);
+	rtc->rtc = devm_rtc_device_register(RTC_NAME, &pdev->dev,
+					&lpc32xx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc)) {
 		dev_err(&pdev->dev, "Can't get RTC\n");
 		platform_set_drvdata(pdev, NULL);
@@ -307,7 +307,6 @@ static int lpc32xx_rtc_remove(struct platform_device *pdev)
 		device_init_wakeup(&pdev->dev, 0);
 
 	platform_set_drvdata(pdev, NULL);
-	rtc_device_unregister(rtc->rtc);
 
 	return 0;
 }
-- 
1.7.2.5


