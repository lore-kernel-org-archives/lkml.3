Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab3CNIMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:12:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:42211 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab3CNIMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:12:39 -0400
X-AuditID: cbfee690-b7f656d0000007e3-4a-514186730ede
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 05/30] rtc: rtc-ds1302: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:12:35 +0900
Message-id: <008801ce208b$af5f3b80$0e1db280$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAAEEvg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t8zQ93iNsdAg4nvtC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGjXMPWAp+s1d8bk5vYDzH1sXIySEhYCJx6MJuKFtM4sK99WC2
	kMAyRokrP7Rgal7fu8ncxcgFFF/EKDGnpQmqaDaTxMQLRSA2m4CaxJcvh9m7GDk4RAT0Jdpa
	NEDqmQV6GSXO9O4GiwsJ2Epc/28HYnIK2ElsWC8G0iks4Cbx485EJpAwi4CqxJkJCiBhXqDi
	3/0XmCBsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nLDNIqIaAu8eivLkhYRMBI4ubuo1DlIhL7
	XrxjBDlGQmAeu8TergWsIAkWAQGJb5MPsUD0ykpsOsAM8aykxMEVN1gmMErMQrJ5FpLNs5Bs
	noVkxQJGllWMoqkFyQXFSelFJnrFibnFpXnpesn5uZsYIfE0YQfjvQPWhxiTgdZPZJYSTc4H
	xmNeSbyhsZmRhamJqbGRuaUZacJK4rzqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhiT
	NlxL2tvAaOud4VHl/m6XpmNPvc2/b09XefKV3u1MCPvUF+O7yoC18I7qhWUOZwNZc+fcUTnq
	eMtq+ryd105cmbgjcXfiteCD/60b3yqFP9X53sYY6h0mKfz04H/GabufPRTTn9fDGzpJeN2J
	b+FTP83cVvda59DReTrK3+6e9TxxNkG3LuKMEktxRqKhFnNRcSIASyiv6L0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+xgG5xm2OgQftNdYvLu+awOTB6fN4k
	F8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQM0
	VUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYcePcA5aC3+wVn5vTGxjP
	sXUxcnJICJhIvL53kxnCFpO4cG89UJyLQ0hgEaPEnJYmsCIhgdlMEhMvFIHYbAJqEl++HGbv
	YuTgEBHQl2hr0QCpZxboZZQ407sbLC4kYCtx/b8diMkpYCexYb0YSKewgJvEjzsTmUDCLAKq
	EmcmKICEeYGKf/dfYIKwBSV+TL7HAmIzC2hJrN95nAnClpfYvOYtM0irhIC6xKO/uiBhEQEj
	iZu7j0KVi0jse/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXSK07MLS7NS9dL
	zs/dxAiO12fSOxhXNVgcYhTgYFTi4Y0QdQwUYk0sK67MPcQowcGsJMLr6QUU4k1JrKxKLcqP
	LyrNSS0+xJgM9OdEZinR5HxgKskriTc0NjEzsjQyszAyMTcnTVhJnPdgq3WgkEB6Yklqdmpq
	QWoRzBYmDk6pBsbm54vvdu12Skvne52hOlPEuWynu+GnAz/OyXxxqj2VF1ZS9efa7wKtpLNi
	7eLLBENb1sSUS3Jeue90/W9ue//rphanT0cLlH68W1sSbaCcN513z6wVHj+Pr8n39kn8Feyr
	HXokMWGNp7oDl1Xf2ajimsQF4hzLvy3NKD0w9bjefR3Va6HNKUosxRmJhlrMRcWJAOjh74Mb	AwAA
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
 drivers/rtc/rtc-ds1302.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-ds1302.c b/drivers/rtc/rtc-ds1302.c
index 7d4c2b4..d139543 100644
--- a/drivers/rtc/rtc-ds1302.c
+++ b/drivers/rtc/rtc-ds1302.c
@@ -224,7 +224,7 @@ static int __init ds1302_rtc_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	rtc = rtc_device_register("ds1302", &pdev->dev,
+	rtc = devm_rtc_device_register(&pdev->dev, "ds1302",
 					   &ds1302_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
@@ -236,9 +236,6 @@ static int __init ds1302_rtc_probe(struct platform_device *pdev)
 
 static int __exit ds1302_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(rtc);
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
-- 
1.7.2.5


