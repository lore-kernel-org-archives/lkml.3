Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab3CNIMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:12:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23951 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab3CNIMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:12:08 -0400
X-AuditID: cbfee68d-b7f786d000005188-17-51418654cdea
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 04/30] rtc: rtc-dm355evm: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:12:04 +0900
Message-id: <008701ce208b$9d0904c0$d71b0e40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAADB4w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t8zQ92QNsdAg8dnrSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DK6NvzgLHgBUfFx75zLA2M69i7GDk4JARMJG68qe1i5AQyxSQu3FvPBmILCSxjlOh7
	XwIRN5HYuuc9UxcjF1B8OqPEu+YPrBDOL0aJTVt2gnWwCahJfPlyGGyoiIC+RFuLBkgNs0Av
	o8SZ3t1gcSEBW4nr/+1ATE4BO4kN68VATGEBD4lJK2tAhrAIqEr86D4ONpAXqHjmxr1MELag
	xI/J91hAbGYBLYn1O48zQdjyEpvXvGWG+ERd4tFfXZCwiICRRM/jWWwQJSIS+168YwQ5RkLg
	HrvEn2fP2SF2CUh8m3yIBaJXVmLTAWaIbyUlDq64wTKBUWIWks2zkGyehWTzLCQrFjCyrGIU
	TS1ILihOSi8y1CtOzC0uzUvXS87P3cQIidDeHYy3D1gfYkwGWj+RWUo0OR8Y4Xkl8YbGZkYW
	piamxkbmlmakCSuJ86q1WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYOzgKt5wYP1Nd7/P
	rcUPf1/v+v2rID5p5qzur6mXBL8+bpI9JfEp6fHag/EXujYYfEzQ49zK6Mmfca617bR8RPFN
	7/UB4oZX4i3n1jf6bmD7k80wt+/YWWa5OSIHXM49mhNvpvx0u4jpRM15U8WnFfeY16h9+jKn
	/Lva0krBXP57bzPkhZcruyqxFGckGmoxFxUnAgCkjXn45gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQd2QNsdAg2N9ZhZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRjUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZvTtecBY8IKj4mPfOZYGxnXsXYycHBICJhJb
	97xngrDFJC7cW8/WxcjFISQwnVHiXfMHVgjnF6PEpi072UCq2ATUJL58OQzUzcEhIqAv0dai
	AVLDLNDLKHGmdzdYXEjAVuL6fzsQk1PATmLDejEQU1jAQ2LSyhqQISwCqhI/uo+DDeQFKp65
	cS8ThC0o8WPyPRYQm1lAS2L9zuNMELa8xOY1b5lBxkgIqEs8+qsLEhYRMJLoeTyLDaJERGLf
	i3eMExiFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnAKeCa1
	g3Flg8UhRgEORiUe3gP9DoFCrIllxZW5hxglOJiVRHg9vRwDhXhTEiurUovy44tKc1KLDzEm
	Az06kVlKNDkfmJ7ySuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNT
	qoFx5+5f8btu7n20LMng5acNkRVXWq7W8DhWMnAYrnq2SO5C7J6+6u+azzp7pF8efx3jfGjX
	ngk7+HiZXpxc9uL2hS+z+4KeP3I7s4QzQOfkhDTXyo2vGI62n6kLUYnetPXGOvdLZ0qNuDbs
	L5j4o4Z50vMviXVP87Pm80jK2hUbaroXyW1dNC+3VImlOCPRUIu5qDgRAF9nPgxFAwAA
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
 drivers/rtc/rtc-dm355evm.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-dm355evm.c b/drivers/rtc/rtc-dm355evm.c
index b2ed2c9..1e1ca63 100644
--- a/drivers/rtc/rtc-dm355evm.c
+++ b/drivers/rtc/rtc-dm355evm.c
@@ -127,8 +127,8 @@ static int dm355evm_rtc_probe(struct platform_device *pdev)
 {
 	struct rtc_device *rtc;
 
-	rtc = rtc_device_register(pdev->name,
-				  &pdev->dev, &dm355evm_rtc_ops, THIS_MODULE);
+	rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
+					&dm355evm_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		dev_err(&pdev->dev, "can't register RTC device, err %ld\n",
 			PTR_ERR(rtc));
@@ -141,9 +141,6 @@ static int dm355evm_rtc_probe(struct platform_device *pdev)
 
 static int dm355evm_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(rtc);
 	platform_set_drvdata(pdev, NULL);
 	return 0;
 }
-- 
1.7.2.5


