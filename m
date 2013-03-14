Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab3CNILY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:11:24 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14167 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab3CNILW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:11:22 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-cc-514186294f02
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 03/30] rtc: rtc-bq32k: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:11:21 +0900
Message-id: <008601ce208b$83197630$894c6290$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAABIsQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t8zY13NNsdAgxVtEhZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRnHZpKTmZJal
	FunbJXBlTG56y1hwgb1iSdMX1gbGlWxdjJwcEgImEh/6HrNA2GISF+6tB4sLCSxjlFi5NB+m
	5u6uRmaI+HRGiWMtVV2MXED2L0aJ21umMIEk2ATUJL58OczexcjBISKgL9HWogFSwyzQyyhx
	pnc3WFxIwFbi+n87EJNTwE5iw3oxkE5hAVeJGVOmgq1lEVCVWNS6gB3E5gWq/vKzhRnCFpT4
	Mfke2JnMAloS63ceZ4Kw5SU2r3nLDDJSQkBd4tFfXZCwiICRxKctC5ghSkQk9r14xwjxyT12
	iRsbAiFWCUh8m3yIBaJVVmLTAWaIEkmJgytusExglJiFZPEsJItnIVk8C8mGBYwsqxhFUwuS
	C4qT0ouM9YoTc4tL89L1kvNzNzFCIrR/B+PdA9aHGJOB1k9klhJNzgdGeF5JvKGxmZGFqYmp
	sZG5pRlpwkrivGot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGGtfW8n3LeGWeKDHzPrH
	mWfmj7A1/gs0t6084BxxI2LpAst9lrLz9f/EFZzeE60bXqOq7HvnjJTkNM6nekva1O4JTHJg
	YDDPkvLNZnWSVt/PV5hbuq1ErsAnKjMur0rh8HrumtnyJ9XTAjfevnWi7t1eBSlju7vaxov4
	fnBFOoeeYGCVcgpXYinOSDTUYi4qTgQA+DDlbuYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQV3NNsdAgzlfhS2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzJjc9Jax4AJ7xZKmL6wNjCvZuhg5OSQETCTu
	7mpkhrDFJC7cWw8WFxKYzihxrKWqi5ELyP7FKHF7yxQmkASbgJrEly+H2bsYOThEBPQl2lo0
	QGqYBXoZJc707gaLCwnYSlz/bwdicgrYSWxYLwbSKSzgKjFjylSw8SwCqhKLWhewg9i8QNVf
	frYwQ9iCEj8m32MBsZkFtCTW7zzOBGHLS2xe85YZZKSEgLrEo7+6IGERASOJT1sWMEOUiEjs
	e/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAhOAc+k
	djCubLA4xCjAwajEw3ug3yFQiDWxrLgy9xCjBAezkgivp5djoBBvSmJlVWpRfnxRaU5q8SHG
	ZKBHJzJLiSbnA9NTXkm8obGJmZGlkZmFkYm5OWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFw
	SjUwdoTPvxuybNXLoh8T53x47Oj46NZ8Q62NG+feifrzr1Liq/rVz8VTT/j8+Kr/6XfAdpW/
	1blrp02tNdv9xDvWy6/d/EtvlElYLqNpjZjvm6O63Ud//edKDxVbrK7A6sYvcZNvD/OsLZJR
	Ygz5P9+Lp3rmGzrtfygsUTtt3goLp8DMM7d8ZO2PKbEUZyQaajEXFScCACq0xOxFAwAA
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
 drivers/rtc/rtc-bq32k.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-bq32k.c b/drivers/rtc/rtc-bq32k.c
index 036cb89..fea78bc 100644
--- a/drivers/rtc/rtc-bq32k.c
+++ b/drivers/rtc/rtc-bq32k.c
@@ -153,7 +153,7 @@ static int bq32k_probe(struct i2c_client *client,
 	if (error)
 		return error;
 
-	rtc = rtc_device_register(bq32k_driver.driver.name, &client->dev,
+	rtc = devm_rtc_device_register(&client->dev, bq32k_driver.driver.name,
 						&bq32k_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
@@ -165,9 +165,6 @@ static int bq32k_probe(struct i2c_client *client,
 
 static int bq32k_remove(struct i2c_client *client)
 {
-	struct rtc_device *rtc = i2c_get_clientdata(client);
-
-	rtc_device_unregister(rtc);
 	return 0;
 }
 
-- 
1.7.2.5


