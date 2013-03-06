Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab3CFHvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:51:16 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:46030 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab3CFHvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:51:10 -0500
X-AuditID: cbfee68d-b7f636d0000009be-20-5136f56dad18
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 11/30] rtc: rtc-lp8788: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:51:09 +0900
Message-id: <008501ce1a3f$5da6fe10$18f4fa30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAAIXQg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zQ93cr2aBBl8PWFpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M4y92sBc84qjYtmU2WwPjCvYuRk4OCQETicX/vzBC2GISF+6t
	Z+ti5OIQEljGKNG9sQWuqGH6VkaIxCJGiabP76Cc2UwSP95cZQOpYhNQk/jy5TBQBweHiIC+
	RFuLBkgNs0Avo8SZ3t1gcSEBW4meeTwg5ZwCdhJTJj4GWyAs4Cmx9t0nZhCbRUBV4uO1b2Aj
	eYHKf399wQ5hC0r8mHyPBcRmFtCSWL/zOBOELS+xec1bZpDxEgLqEo/+6oKERQSMJHoe9EKV
	i0jsewFxsoTAInaJvfvOQO0SkPg2+RALRK+sxKYDzBD/SkocXHGDZQKjxCwkm2ch2TwLyeZZ
	SFYsYGRZxSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iRESWb07GG8fsD7EmAy0fiKzlGhyPjAy
	80riDY2NTcxMTE3MLU3NTUkTVhLnlbskEygkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB8WyE
	HJ/USbVV74xM3KfNW9DhvF7F+HjM9mjxuZGJm/j7RZjFXk+08JPSZ2zydjrAuWvD2wPP/CwO
	HFn0XW7n5HvPbnPNXizZPzdHyMi5rWD/8ZlffeaXHZB6c/ti+Xw5C3kZpnhZPrUdIetUF+5f
	eaFManUBd5tD95nk3D1LOOsvF259fsnRT4mlOCPRUIu5qDgRAIeRW6PCAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgG7uV7NAg/M7jS0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxvEXO9gLHnFUbNsym62B
	cQV7FyMnh4SAiUTD9K2MELaYxIV769m6GLk4hAQWMUo0fX7HCOHMZpL48eYqG0gVm4CaxJcv
	h4G6OThEBPQl2lo0QGqYBXoZJc707gaLCwnYSvTM4wEp5xSwk5gy8THYMmEBT4m17z4xg9gs
	AqoSH699AxvJC1T+++sLdghbUOLH5HssIDazgJbE+p3HmSBseYnNa94yg4yXEFCXePRXFyQs
	ImAk0fOgF6pcRGLfi3eMExiFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWle
	ul5yfu4mRnDcPpPawbiyweIQowAHoxIPr4WSWaAQa2JZcWXuIUYJDmYlEV6uM0Ah3pTEyqrU
	ovz4otKc1OJDjMlAj05klhJNzgemlLySeENjEzMjSyMzCyMTc3PShJXEeRlPPQkQEkhPLEnN
	Tk0tSC2C2cLEwSnVwHjhzu/y0iaLo+v9K85Kh7ZmzG8K38Jm9p9j5qrOJQFi5x29PQLvnf7X
	vtG9bPaWU0InWxIqVj9jrCiOPXhQRdV9z7Jd9ekVeaFVQYtdY41F9/53jg9qsqm+kfpaq4XJ
	iaOc56ah9OrGN/1WRasc9yZI5106mzOtVfTwPcsXW41+diQ7rdtSoMRSnJFoqMVcVJwIAA8c
	9wEfAwAA
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

 drivers/rtc/rtc-lp8788.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-lp8788.c b/drivers/rtc/rtc-lp8788.c
index 9a46312..9853ac1 100644
--- a/drivers/rtc/rtc-lp8788.c
+++ b/drivers/rtc/rtc-lp8788.c
@@ -299,7 +299,7 @@ static int lp8788_rtc_probe(struct platform_device *pdev)
 
 	device_init_wakeup(dev, 1);
 
-	rtc->rdev = rtc_device_register("lp8788_rtc", dev,
+	rtc->rdev = devm_rtc_device_register(dev, "lp8788_rtc",
 					&lp8788_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rdev)) {
 		dev_err(dev, "can not register rtc device\n");
@@ -314,9 +314,6 @@ static int lp8788_rtc_probe(struct platform_device *pdev)
 
 static int lp8788_rtc_remove(struct platform_device *pdev)
 {
-	struct lp8788_rtc *rtc = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(rtc->rdev);
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
-- 
1.7.2.5


