Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab3B0F6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 00:58:24 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:60047 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab3B0F6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 00:58:20 -0500
X-AuditID: cbfee68d-b7f636d0000009be-5b-512da07a6730
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jonghwa Lee'" <jonghwa3.lee@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <008f01ce14af$4283cf90$c78b6eb0$%han@samsung.com>
In-reply-to: <008f01ce14af$4283cf90$c78b6eb0$%han@samsung.com>
Subject: [PATCH 3/5] rtc: max77686: use devm_kzalloc()
Date: Wed, 27 Feb 2013 14:58:17 +0900
Message-id: <009101ce14af$708aa5d0$519ff170$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Ur0Jf3bJm/gOXS5uxDgC3uRXcVgAABnxg
Content-language: ko
x-cr-hashedpuzzle: MDi2 OWeu gIcS gbKq h0vI lZfK nJSF pKp3 vMHf zBaS 0C0f 1/CT
 29y7 3ItA 8tXM
 AAG6XA==;6;YQAuAHoAdQBtAG0AbwBAAHQAbwB3AGUAcgB0AGUAYwBoAC4AaQB0ADsAYQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBqAG8AbgBnAGgAdwBhADMALgBsAGUAZQBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwByAHQAYwAtAGwAaQBuAHUAeABAAGcAbwBvAGcAbABlAGcAcgBvAHUAcABzAC4AYwBvAG0A;Sosha1_v1;7;{3616F6FD-2796-4128-AF86-BD589B5AF9A4};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Wed,
 27 Feb 2013 05:58:07
 GMT;WwBQAEEAVABDAEgAIAAzAC8ANQBdACAAcgB0AGMAOgAgAG0AYQB4ADcANwA2ADgANgA6ACAAdQBzAGUAIABkAGUAdgBtAF8AawB6AGEAbABsAG8AYwAoACkA
x-cr-puzzleid: {3616F6FD-2796-4128-AF86-BD589B5AF9A4}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t8zI92qBbqBBp2NkhZLLl5lt5izfg2b
	xeWFl1gtOs8+Yba4vGsOm8X+zg5GBzaPPRNPsnmcmPGbxaNvyypGj+nzfjJ5fN4kF8AaxWWT
	kpqTWZZapG+XwJXR+useW8F/rorOe21sDYzfOLoYOTkkBEwkTi9axghhi0lcuLeerYuRi0NI
	YBmjxJmeXhaYog/HTkAlpjNKXN42iQXC+cUo8XffVnaQKjYBNYkvXw4D2RwcIgL6Em0tGiA1
	zAI7GSUerr4NtkJIwFZi04+zbCA2p4CdxMKvW8FsYQEzif/rr4NtYxFQlXh8tgUszgtSf7CJ
	BcIWlPgx+R6YzSygJbF+53EmCFteYvOat8wgeyUE1CUe/dUFCYsIGEm0vpnEDFEiIrHvxTuo
	L3+wSvydYgdhm0r82/yDFeROCYG/7BLPV/9mgrhBQOLb5EMsEDNlJTYdYIaol5Q4uOIGywRG
	qVlILpqF5KJZSC6ahWT1AkaWVYyiqQXJBcVJ6UWGesWJucWleel6yfm5mxghUd67g/H2AetD
	jMlA6ycyS4km5wOTRF5JvKGxsYmZiamJuaWpuSlpwkrivHKXZAKFBNITS1KzU1MLUovii0pz
	UosPMTJxcEo1MM5531Df4+Ug8OnVP5fGYxulfdbuKnkrqnr6yeS1pw3rXmolrKtd8SJ9477z
	e44+FpkiPvfz3Vld/rOub43u8w9oClFU2lTuo3zaQ5tHKnbiMn3FwOgIxs26m7ZeLtl4utyd
	2exi7ifZ6xFTjzi2KE2cw5trvXnpNAf1jtjX8o37d5s/iewtCVRiKc5INNRiLipOBAA5C+qu
	CAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsVy+t9jQd2qBbqBBhsvClssuXiV3WLO+jVs
	FpcXXmK16Dz7hNni8q45bBb7OzsYHdg89kw8yeZxYsZvFo++LasYPabP+8nk8XmTXABrVAOj
	TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QCUoKZYk5
	pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjNZf99gK/nNVdN5rY2tg/MbRxcjJ
	ISFgIvHh2Ak2CFtM4sK99UA2F4eQwHRGicvbJrFAOL8YJf7u28oOUsUmoCbx5cthIJuDQ0RA
	X6KtRQOkhllgJ6PEw9W3GUFqhARsJTb9OAs2lVPATmLh161gtrCAmcT/9ddZQGwWAVWJx2db
	wOK8IPUHm1ggbEGJH5PvgdnMAloS63ceZ4Kw5SU2r3nLDLJXQkBd4tFfXZCwiICRROubScwQ
	JSIS+168Y4R45gerxN8pdhC2qcS/zT9YJzCKzEKyYRaSDbOQbJiFZNQCRpZVjKKpBckFxUnp
	uUZ6xYm5xaV56XrJ+bmbGMEp5Jn0DsZVDRaHGAU4GJV4eBdc0gkUYk0sK67MPcQowcGsJML7
	8QBQiDclsbIqtSg/vqg0J7X4EGMyMAAmMkuJJucD01teSbyhsYmZkaWRmYWRibk5acJK4ryM
	p54ECAmkJ5akZqemFqQWwWxh4uCUamCMmGTu8evwC/bO+Wv3TjjZq/T1nYvyIc/9J1alC3tG
	zy/nFEwStq25yl3ey+o2NaF//aMDvgmGzz7XvuU7XPij2FfiyHK9ydUuO9eJRUrqp69RVNi3
	+7H5wkXcAadndOXeOaRpVWF3aO+n7XXMx4690eWu2yB4+8OmiX05XiXhe9clhb34ZaeuxFKc
	kWioxVxUnAgAKqGv5mUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-max77686.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
index 4da2a55..36b1f5c 100644
--- a/drivers/rtc/rtc-max77686.c
+++ b/drivers/rtc/rtc-max77686.c
@@ -505,7 +505,8 @@ static int max77686_rtc_probe(struct platform_device *pdev)
 
 	dev_info(&pdev->dev, "%s\n", __func__);
 
-	info = kzalloc(sizeof(struct max77686_rtc_info), GFP_KERNEL);
+	info = devm_kzalloc(&pdev->dev, sizeof(struct max77686_rtc_info),
+				GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 
@@ -519,7 +520,6 @@ static int max77686_rtc_probe(struct platform_device *pdev)
 		ret = PTR_ERR(info->max77686->rtc_regmap);
 		dev_err(info->max77686->dev, "Failed to allocate register map: %d\n",
 				ret);
-		kfree(info);
 		return ret;
 	}
 	platform_set_drvdata(pdev, info);
@@ -563,11 +563,7 @@ static int max77686_rtc_probe(struct platform_device *pdev)
 		goto err_rtc;
 	}
 
-	goto out;
 err_rtc:
-	kfree(info);
-	return ret;
-out:
 	return ret;
 }
 
@@ -578,7 +574,6 @@ static int max77686_rtc_remove(struct platform_device *pdev)
 	if (info) {
 		free_irq(info->virq, info);
 		rtc_device_unregister(info->rtc_dev);
-		kfree(info);
 	}
 
 	return 0;
-- 
1.7.2.5


