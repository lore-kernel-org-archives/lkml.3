Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab3CFFaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:30:17 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:28526 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab3CFFaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:30:14 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-ff-5136d4649162
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 09/30] rtc: rtc-ep93xx: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:30:11 +0900
Message-id: <004b01ce1a2b$ac8de7a0$05a9b6e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAAGcJA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zA92UK2aBBtP+6Vtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6ME6+/Mxe85K64M2k7ewPjT84uRk4OCQETidZLmxghbDGJC/fW
	s3UxcnEICSxjlGjYeYm1i5EDrGjVSRaI+CJGiU8fFjFBOLOZJCZ/3MUM0s0moCbx5cthdpAG
	EQF9ibYWDZAaZoFeRokzvbvZQWqEBGwlrnavAqvnFLCTWP54FguILSzgJnF442smEJtFQFVi
	34FpYDYvUP2jnxsYIWxBiR+T74HVMwtoSazfeZwJwpaX2LzmLTPEoeoSj/7qgoRFBIwk9m97
	AVUiIrHvxTtGkHskBJaxS7yb2MgMsUtA4tvkQywQvbISmw4wQwJCUuLgihssExglZiHZPAvJ
	5llINs9CsmIBI8sqRtHUguSC4qT0IlO94sTc4tK8dL3k/NxNjJDImriD8f4B60OMyUDrJzJL
	iSbnAyMzryTe0NjYxMzE1MTc0tTclDRhJXFe+UsygUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4
	pRoYz6TOdo0vmuphz/zg1fUTwf9aBfmvnAoskZgpvs9h+SomM9tbB+LUnTfnfteKZJz34Uum
	c3P6qWZt01TZjb+NhL8tF679UmGxJ0NXeZlG//RrOhOXv0+3TeHP9e6W+uoyv+mPDfuKq48d
	OTmyjja7ep5jL/A5/fut4AFGsdXqjws2vDnk7CujxFKckWioxVxUnAgA4LJAtsICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgG7KFbNAgzPLdSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxonX35kLXnJX3Jm0nb2B
	8SdnFyMHh4SAicSqkyxdjJxAppjEhXvr2boYuTiEBBYxSnz6sIgJwpnNJDH54y5mkCo2ATWJ
	L18Os4M0iwjoS7S1aIDUMAv0Mkqc6d3NDlIjJGArcbV7FVg9p4CdxPLHs8A2CAu4SRze+JoJ
	xGYRUJXYd2AamM0LVP/o5wZGCFtQ4sfke2D1zAJaEut3HmeCsOUlNq95ywxxtLrEo7+6IGER
	ASOJ/dteQJWISOx78Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L
	10vOz93ECI7bZ9I7GFc1WBxiFOBgVOLhnaBiFijEmlhWXJl7iFGCg1lJhJfrDFCINyWxsiq1
	KD++qDQntfgQYzLQoxOZpUST84EpJa8k3tDYxMzI0sjMwsjE3Jw0YSVxXsZTTwKEBNITS1Kz
	U1MLUotgtjBxcEo1MApfO1z5ZIfjKeMfv+wdl7F8tNaatHzVuxVO8jEHS8tbOftyu+b8PTHb
	b6J84BHGer6vF4rnnv8Z5vMx+FVOwMpm3Tk8O9Y0HOZdxy/IqxyR2z1fvOVi7hI/46OW8ucX
	PThy7fGBCU/56i7oHzi7r/aoWsT/iB2vEo6nTpwaKKf91NYwOuUXV5ESS3FGoqEWc1FxIgAp
	a5yKHwMAAA==
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
 drivers/rtc/rtc-ep93xx.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/rtc/rtc-ep93xx.c b/drivers/rtc/rtc-ep93xx.c
index 1a4e5e4..6d24349 100644
--- a/drivers/rtc/rtc-ep93xx.c
+++ b/drivers/rtc/rtc-ep93xx.c
@@ -153,7 +153,7 @@ static int ep93xx_rtc_probe(struct platform_device *pdev)
 	pdev->dev.platform_data = ep93xx_rtc;
 	platform_set_drvdata(pdev, ep93xx_rtc);
 
-	ep93xx_rtc->rtc = rtc_device_register(pdev->name,
+	ep93xx_rtc->rtc = devm_rtc_device_register(pdev->name,
 				&pdev->dev, &ep93xx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(ep93xx_rtc->rtc)) {
 		err = PTR_ERR(ep93xx_rtc->rtc);
@@ -162,12 +162,10 @@ static int ep93xx_rtc_probe(struct platform_device *pdev)
 
 	err = sysfs_create_group(&pdev->dev.kobj, &ep93xx_rtc_sysfs_files);
 	if (err)
-		goto fail;
+		goto exit;
 
 	return 0;
 
-fail:
-	rtc_device_unregister(ep93xx_rtc->rtc);
 exit:
 	platform_set_drvdata(pdev, NULL);
 	pdev->dev.platform_data = NULL;
@@ -176,11 +174,8 @@ exit:
 
 static int ep93xx_rtc_remove(struct platform_device *pdev)
 {
-	struct ep93xx_rtc *ep93xx_rtc = platform_get_drvdata(pdev);
-
 	sysfs_remove_group(&pdev->dev.kobj, &ep93xx_rtc_sysfs_files);
 	platform_set_drvdata(pdev, NULL);
-	rtc_device_unregister(ep93xx_rtc->rtc);
 	pdev->dev.platform_data = NULL;
 
 	return 0;
-- 
1.7.2.5


