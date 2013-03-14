Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab3CNIKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:10:49 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30926 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab3CNIKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:10:47 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-f1-5141860599fb
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 02/30] rtc: rtc-au1xxx: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:10:45 +0900
Message-id: <008501ce208b$6ded3c10$49c7b430$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAAAWAw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t8zQ13WNsdAgy9PrSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKmH7mLXtBI0fFp/dbGRsYr7F1MXJySAiYSOzrP8gEYYtJXLi3HiwuJLCMUWLhM4su
	Rg6wmiVTKroYuYDC0xklbs+/xwzh/GKU+Dm5nxGkgU1ATeLLl8PsIA0iAvoSbS0aIDXMAr2M
	Emd6d4PFhQRsJa7/twMxOQXsJDasFwPpFBZwk3i3rJMZxGYRUJWY+nUp2Dm8QNWTzx9hg7AF
	JX5MvscCYjMLaEms33mcCcKWl9i85i0zxJnqEo/+6oKERQSMJC4cmcYMUSIise/FO0aQayQE
	7rFLTHr/khFil4DEt8mHWCB6ZSU2HWCGhIKkxMEVN1gmMErMQrJ5FpLNs5BsnoVkxQJGllWM
	oqkFyQXFSelFxnrFibnFpXnpesn5uZsYITHav4Px7gHrQ4zJQOsnMkuJJucDYzyvJN7Q2MzI
	wtTE1NjI3NKMNGElcV61FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxzev933ZQ8El11
	yMS3ervVnTt+86QW1XE8r7S6wuyxfPOUnsnnWdd2mhgYaj1ukXxcHzmn3qGOZ8NG5o08Ty7e
	q99z4X/9nqc/ahn+5gn2dohNUMj55qAvkzhrifyf25d65bN1bip0v5q9NeCl7yGtNV/W3vTc
	dGfF2QAvKY+rBQcXLG2zPXpOiaU4I9FQi7moOBEAluC36ecCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQV3WNsdAgxPXzCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzJh+5i17QSNHxaf3WxkbGK+xdTFycEgImEgs
	mVLRxcgJZIpJXLi3HijMxSEkMJ1R4vb8e8wQzi9GiZ+T+xlBqtgE1CS+fDnMDtIsIqAv0dai
	AVLDLNDLKHGmdzdYXEjAVuL6fzsQk1PATmLDejGQTmEBN4l3yzqZQWwWAVWJqV+XMoHYvEDV
	k88fYYOwBSV+TL7HAmIzC2hJrN95nAnClpfYvOYtM8TJ6hKP/uqChEUEjCQuHJnGDFEiIrHv
	xTvGCYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzgFPJPa
	wbiyweIQowAHoxIP74F+h0Ah1sSy4srcQ4wSHMxKIryeXo6BQrwpiZVVqUX58UWlOanFhxiT
	gR6dyCwlmpwPTE95JfGGxiZmRpZGZhZGJubmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp
	1cBo8lWSOyyDq849rjGUfyH3je9LbV/l/bhj+rKup0JqT/8N7zMnHr4UTdoad3GDxtMpTPc3
	Lp1c7ne5291A7cm0xFffQmMVV7JN4tq2j6sj88XjC/cbtXPco44eNVm3RC0j2k36Qacon82y
	FbqrYsVafy7f/KN+xuGlOfcnX5zhadhsHfU2U6BViaU4I9FQi7moOBEAKehZ3UUDAAA=
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
 drivers/rtc/rtc-au1xxx.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-au1xxx.c b/drivers/rtc/rtc-au1xxx.c
index dfd6d66..7995abc 100644
--- a/drivers/rtc/rtc-au1xxx.c
+++ b/drivers/rtc/rtc-au1xxx.c
@@ -101,7 +101,7 @@ static int au1xtoy_rtc_probe(struct platform_device *pdev)
 	while (au_readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_C0S)
 		msleep(1);
 
-	rtcdev = rtc_device_register("rtc-au1xxx", &pdev->dev,
+	rtcdev = devm_rtc_device_register(&pdev->dev, "rtc-au1xxx",
 				     &au1xtoy_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtcdev)) {
 		ret = PTR_ERR(rtcdev);
@@ -118,9 +118,6 @@ out_err:
 
 static int au1xtoy_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_device *rtcdev = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(rtcdev);
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
-- 
1.7.2.5


