Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab3CRJce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 05:32:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41729 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab3CRJca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 05:32:30 -0400
X-AuditID: cbfee690-b7f656d0000007e3-11-5146df2d4ca4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <01b701ce23bb$1b79b2a0$526d17e0$%han@samsung.com>
In-reply-to: <01b701ce23bb$1b79b2a0$526d17e0$%han@samsung.com>
Subject: [PATCH 09/10] rtc: rtc-tps65910: switch to using SIMPLE_DEV_PM_OPS
Date: Mon, 18 Mar 2013 18:32:29 +0900
Message-id: <01bf01ce23bb$827252f0$8756f8d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4juxtMJTZWEDnPSfOGR4wzonE6SAAAFzvA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zY13d+26BBre7tCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG2kMvmArOsFWcWLWWqYHxFGsXIyeHhICJxOQZ9xghbDGJC/fW
	s3UxcnEICSxjlJi06zd7FyMHWFHfB1eI+CJGifM/mhghnNlMElfOz2QB6WYTUJP48uUwWIOI
	gL5EW4sGSA2zQC+jxJne3ewgNUICthLzri0G28YpYCextX8S2BXCAt4Sl3fMYgKxWQRUJU5P
	XQ5WzwtUv/fHDShbUOLH5Htgu5gFtCTW7zzOBGHLS2xe85YZ4lB1iUd/dSFOMJI4vb4GokJE
	Yt+Ld2AnSwgsYpd4dmkPI8QqAYlvkw+xQLTKSmw6wAwJB0mJgytusExglJiFZPEsJItnIVk8
	C8mKBYwsqxhFUwuSC4qT0otM9IoTc4tL89L1kvNzNzFC4mrCDsZ7B6wPMSYDrZ/ILCWanA+M
	y7ySeENjMyMLUxNTYyNzSzPShJXEedVbrAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MCo8
	yG2MMpWWUtnxqchrY/61K61PgiZGHM1dn8Qo5zjB8+S3zs+i0mlf9n/d/sWu9ce2Gyw3Z3Ie
	CVnL8jynhNNs/rxKre9T2a4GnrJ7XCrudSo85L0kP5t/NjP3Q8m4nxn+mZb5M3LdvFTD+q7u
	0kj0v2gU1NvrGmyl7/0r0LvidGNfYsNeJZbijERDLeai4kQAJJIR68ECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgK7ufbdAgxt/VSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxtpDL5gKzrBVnFi1lqmB
	8RRrFyMHh4SAiUTfB9cuRk4gU0ziwr31bF2MXBxCAosYJc7/aGKEcGYzSVw5P5MFpIpNQE3i
	y5fD7CDNIgL6Em0tGiA1zAK9jBJnenezg9QICdhKzLu2mBHE5hSwk9jaP4kVxBYW8Ja4vGMW
	E4jNIqAqcXrqcrB6XqD6vT9uQNmCEj8m3wPbxSygJbF+53EmCFteYvOat8wQR6tLPPqrC3GC
	kcTp9TUQFSIS+168Y5zAKDQLyaBZSAbNQjJoFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1
	kvNzNzGCo/aZ1A7GlQ0WhxgFOBiVeHh3rHcLFGJNLCuuzD3EKMHBrCTC63gbKMSbklhZlVqU
	H19UmpNafIgxGejPicxSosn5wISSVxJvaGxiZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU
	1ILUIpgtTBycUg2M+6pyr0UqM/JViUautf7+ZnrAmrkfD6bo3q4KWHlzT2KHo8qyGsuEhrqH
	rtZ11589evdR4Om+Xe82BnGo/JxtV3frad7He9WaCovbX0pVlLil326fJc//NerPD/H+gkf7
	s//O4gqfIs7IGWab4Zbuq2MqVeYYmfsudeL1pNfN7l9rWh1K17cosRRnJBpqMRcVJwIAo0Vt
	zR4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to using SIMPLE_DEV_PM_OPS  macro to declare the driver's
pm_ops. It reduces code size.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-tps65910.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-tps65910.c b/drivers/rtc/rtc-tps65910.c
index ef5d199..26b8bd2 100644
--- a/drivers/rtc/rtc-tps65910.c
+++ b/drivers/rtc/rtc-tps65910.c
@@ -320,9 +320,8 @@ static int tps65910_rtc_resume(struct device *dev)
 }
 #endif
 
-static const struct dev_pm_ops tps65910_rtc_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(tps65910_rtc_suspend, tps65910_rtc_resume)
-};
+static SIMPLE_DEV_PM_OPS(tps65910_rtc_pm_ops, tps65910_rtc_suspend,
+			tps65910_rtc_resume);
 
 static struct platform_driver tps65910_rtc_driver = {
 	.probe		= tps65910_rtc_probe,
-- 
1.7.2.5


