Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab3CNITP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:19:15 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15733 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab3CNITN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:19:13 -0400
X-AuditID: cbfee68d-b7f786d000005188-03-514187ff56a0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 15/30] rtc: rtc-m48t86: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:19:11 +0900
Message-id: <009201ce208c$9b5b8660$d2129320$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAANIkg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zQ93/7Y6BBm3rbCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKWPjhH1vBf46K3h1XmRoY97B3MXJySAiYSEz+8xTKFpO4cG89WxcjF4eQwDJGicfT
	VzDCFL3818gCkZjOKHGs9wo7hPOLUWL/th4WkCo2ATWJL18OAyU4OEQE9CXaWjRAapgFehkl
	zvTuBosLCdhKXP9vB2JyCthJbFgvBtIpLOAm0XSxC2wKi4CqxO4pm9lAbF6g6t0vHrNC2IIS
	PybfA6thFtCSWL/zOBOELS+xec1bZpCREgLqEo/+6oKERQSMJF6sngZVIiKx78U7RpBrJATu
	sUtMW7WFEWKXgMS3yYdYIHplJTYdYIZ4V1Li4IobLBMYJWYh2TwLyeZZSDbPQrJiASPLKkbR
	1ILkguKk9CJDveLE3OLSvHS95PzcTYyQOO3dwXj7gPUhxmSg9ROZpUST84FxnlcSb2hsZmRh
	amJqbGRuaUaasJI4r1qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRvbJynwCt5+vzlpe
	c5mN0b+sabOE0eei3MxVMjl2xjecGv1nOCwR0tvw5u6PP+dbm/Yps7BmyDI9leqdI8r7QD/3
	39mfGrUJ06f/FlGbsOf35E/OXeYL2YQEuEp6C4wq8rZlm/1fk6I4/XrSy1lPL0yWmXRI5kWT
	zXUpxhV79Y93WFo8O9zWqcRSnJFoqMVcVJwIANsrD0bpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd3/7Y6BBgf+mFssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLHwwz+2gv8cFb07rjI1MO5h72Lk5JAQMJF4
	+a+RBcIWk7hwbz1bFyMXh5DAdEaJY71X2CGcX4wS+7f1gFWxCahJfPlyGCjBwSEioC/R1qIB
	UsMs0MsocaZ3N1hcSMBW4vp/OxCTU8BOYsN6MZBOYQE3iaaLXWBTWARUJXZP2cwGYvMCVe9+
	8ZgVwhaU+DH5HlgNs4CWxPqdx5kgbHmJzWveMoOMlBBQl3j0VxckLCJgJPFi9TSoEhGJfS/e
	MU5gFJqFZNIsJJNmIZk0C0nLAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBSeCZ1A7G
	lQ0WhxgFOBiVeHgP9DsECrEmlhVX5h5ilOBgVhLh9fRyDBTiTUmsrEotyo8vKs1JLT7EmAz0
	6ERmKdHkfGCCyiuJNzQ2MTOyNDKzMDIxNydNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkG
	xmNbN5kJJV5cy13AHjT7Uu/DiFCJqxNPzz75sWzT3FcKNxIdVyYITq/3rgzh4fl6VDf626eZ
	jBL5szvYou8t1VwwLb84KlFAhJFPt1g4Zf95tZAJ52SbDwg9rr3nsbr34OotfxX0i9/OO7J4
	4s5/+Vu63vxgaHb/0sduHRe68eehu369266JBSqxFGckGmoxFxUnAgDy36G/RgMAAA==
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
 drivers/rtc/rtc-m48t86.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/rtc/rtc-m48t86.c b/drivers/rtc/rtc-m48t86.c
index 2ffbcac..33a91c4 100644
--- a/drivers/rtc/rtc-m48t86.c
+++ b/drivers/rtc/rtc-m48t86.c
@@ -148,8 +148,10 @@ static int m48t86_rtc_probe(struct platform_device *dev)
 {
 	unsigned char reg;
 	struct m48t86_ops *ops = dev->dev.platform_data;
-	struct rtc_device *rtc = rtc_device_register("m48t86",
-				&dev->dev, &m48t86_rtc_ops, THIS_MODULE);
+	struct rtc_device *rtc;
+
+	rtc = devm_rtc_device_register(&dev->dev, "m48t86",
+				&m48t86_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
@@ -166,11 +168,6 @@ static int m48t86_rtc_probe(struct platform_device *dev)
 
 static int m48t86_rtc_remove(struct platform_device *dev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(dev);
-
- 	if (rtc)
-		rtc_device_unregister(rtc);
-
 	platform_set_drvdata(dev, NULL);
 
 	return 0;
-- 
1.7.2.5


