Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab3CFHrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:47:52 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:45312 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab3CFHrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:47:51 -0500
X-AuditID: cbfee690-b7f6b6d000004563-ac-5136f4a61232
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 02/30] rtc: rtc-coh90133: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:47:49 +0900
Message-id: <007c01ce1a3e$e6847ce0$b38d76a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAAAqyw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zfd1lX8wCDW5MZba4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZVyffZCzYwlnRMmEPWwPjO/YuRk4OCQETibfH7zNC2GISF+6t
	Z+ti5OIQEljGKDG76zgbTNHMvzNZIRKLGCXuL21lgXBmM0nc7Z7GBFLFJqAm8eXLYaCxHBwi
	AvoSbS0aIDXMAr2MEmd6d4PFhQRsJXrm8YCUcwrYSUyZ+BjsCmEBb4lXu7aBLWMRUJVoejMb
	7CJeoPJTE6axQNiCEj8m3wOzmQW0JNbvPM4EYctLbF7zlhlkvISAusSjv7ogYREBI4kt27ew
	QZSISOx78Q7qyWXsEjeWxUKsEpD4NvkQC0SrrMSmA8wQJZISB1fcYJnAKDELyeJZSBbPQrJ4
	FpINCxhZVjGKphYkFxQnpReZ6BUn5haX5qXrJefnbmKExNWEHYz3DlgfYkwGWj+RWUo0OR8Y
	l3kl8YbGxiZmJqYm5pam5qakCSuJ88pfkgkUEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwJjG
	zu+zePP/HclLTeSS1jQLl737qsL67omi0jsz943dFmtcPjs3ZittcFNZkrFH9gHHj3uCvM9b
	Tp/6xX+36K3yc+mCEDVeQVW1r2edLmy09VNPWny2753mh6yTuhv3rX2hqhv4UcsscevaTDb5
	7sJKye/t+R9V+GwWrPpcHO5juEb6VwDfLiWW4oxEQy3mouJEACfNQbzBAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgO7SL2aBBvOXW1tc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjKuTbzIWbOGsaJmwh62B
	8R17FyMnh4SAicTMvzNZIWwxiQv31rN1MXJxCAksYpS4v7SVBcKZzSRxt3saE0gVm4CaxJcv
	h4G6OThEBPQl2lo0QGqYBXoZJc707gaLCwnYSvTM4wEp5xSwk5gy8THYMmEBb4lXu7axgdgs
	AqoSTW9mM4LYvEDlpyZMY4GwBSV+TL4HZjMLaEms33mcCcKWl9i85i0zyHgJAXWJR391QcIi
	AkYSW7ZvYYMoEZHY9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1ya
	l66XnJ+7iREct8+kdjCubLA4xCjAwajEw2uhZBYoxJpYVlyZe4hRgoNZSYSX6wxQiDclsbIq
	tSg/vqg0J7X4EGMy0KMTmaVEk/OBKSWvJN7Q2MTMyNLIzMLIxNycNGElcV7GU08ChATSE0tS
	s1NTC1KLYLYwcXBKNTB2CmZ/Wj3ZnclwU2vjjUAv2X19IbxCm6v7zJLcWjPd5gmESNXej70v
	72ZSuuPk335N13U5z96EdcatON16ZbPruYoC+V+3nQJOph6e1RfazXevI/zK7mhed0/jmHub
	NH9d3qTyd8qPKQ+unmexnOZ49fvehivCit+OH2hw22TaeLVLvkPiWLkSS3FGoqEWc1FxIgDt
	8jk+HwMAAA==
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

 drivers/rtc/rtc-coh901331.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-coh901331.c b/drivers/rtc/rtc-coh901331.c
index 2d28ec1a..78393a2 100644
--- a/drivers/rtc/rtc-coh901331.c
+++ b/drivers/rtc/rtc-coh901331.c
@@ -155,7 +155,6 @@ static int __exit coh901331_remove(struct platform_device *pdev)
 	struct coh901331_port *rtap = dev_get_drvdata(&pdev->dev);
 
 	if (rtap) {
-		rtc_device_unregister(rtap->rtc);
 		clk_unprepare(rtap->clk);
 		platform_set_drvdata(pdev, NULL);
 	}
@@ -211,8 +210,8 @@ static int __init coh901331_probe(struct platform_device *pdev)
 	clk_disable(rtap->clk);
 
 	platform_set_drvdata(pdev, rtap);
-	rtap->rtc = rtc_device_register("coh901331", &pdev->dev, &coh901331_ops,
-					 THIS_MODULE);
+	rtap->rtc = devm_rtc_device_register(&pdev->dev, "coh901331",
+					&coh901331_ops, THIS_MODULE);
 	if (IS_ERR(rtap->rtc)) {
 		ret = PTR_ERR(rtap->rtc);
 		goto out_no_rtc;
-- 
1.7.2.5


