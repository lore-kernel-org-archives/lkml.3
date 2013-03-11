Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab3CKGdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 02:33:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:59992 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab3CKGdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 02:33:07 -0400
X-AuditID: cbfee68d-b7f786d000005188-4f-513d7aa2db98
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
In-reply-to: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
Subject: [PATCH 06/14] power: ds2780_battery: use devm_kzalloc()
Date: Mon, 11 Mar 2013 15:33:05 +0900
Message-id: <007601ce1e22$4a1032e0$de3098a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4eIfOI6J7YtEddQ/Gjh19YaZUzVAAAEY5w
Content-language: ko
x-cr-hashedpuzzle: GqMH JOro L4JI dV8j dwSQ gQv3 hwr3 ijlY jnIg ldLA loQZ mY87
 pmRl qDFK smSp
 tj+k;4;YQBuAHQAbwBuAEAAZQBuAG8AbQBzAGcALgBvAHIAZwA7AGQAdwBtAHcAMgBAAGkAbgBmAHIAYQBkAGUAYQBkAC4AbwByAGcAOwBqAGcAMQAuAGgAYQBuAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{73BF8927-ECA3-4A97-8E1B-7B4985F4956C};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Mon,
 11 Mar 2013 06:32:59
 GMT;WwBQAEEAVABDAEgAIAAwADYALwAxADQAXQAgAHAAbwB3AGUAcgA6ACAAZABzADIANwA4ADAAXwBiAGEAdAB0AGUAcgB5ADoAIAB1AHMAZQAgAGQAZQB2AG0AXwBrAHoAYQBsAGwAbwBjACgAKQA=
x-cr-puzzleid: {73BF8927-ECA3-4A97-8E1B-7B4985F4956C}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t8zA91FVbaBBsfe8llc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MYw/3shec567YevwcSwPjbc4uRk4OCQETiR8vVzJC2GISF+6t
	Z+ti5OIQEljGKNF//AIjTNH0D0eYQWwhgUWMEvtWu0AUzWaSeLymkw0kwSagJvHly2F2EFtE
	QEOibfUUFhCbWSBf4vChyywQzbYSu3++ABvKKWAncWPZJaBeDg5hAQeJ7t5QEJNFQFXiyvwC
	kApeoOrNE/YzQdiCEj8m34OaqCWxeVsTK4QtL7F5zVtmkFYJAXWJR391IQ4wkrgw9TYbRImI
	xL4X7xhBLpYQeMMi0bfrGSvEW6YSz6Z+hkrsY5eYs2gW2GksAgIS3yYfYoEYKiux6QAzRL2k
	xMEVN1gmMErNQnLSLCQnzUJy0iwkuxcwsqxiFE0tSC4oTkovMtQrTswtLs1L10vOz93ECInD
	3h2Mtw9YH2JMBlo/kVlKNDkfGMd5JfGGxmZGFqYmpsZG5pZmpAkrifOqtVgHCgmkJ5akZqem
	FqQWxReV5qQWH2Jk4uCUamAMT+f7YJHwaZZpVwtfbqnups7De2f5KqzMSj1wZc2ne+/WH+mJ
	jk1nZJt4cUOn46zrPMV93lfrU0+vMhH7cCJzyf4/l1dt9iqIn3HjzaGysCaOZT8L7n1aNHVr
	76No10Xul9ue8/2797jgrrevjd6xzr7Ht+Yu/NG8Z5fU7Jclk5rl/G8fXLdeVYmlOCPRUIu5
	qDgRAI8/0iPZAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t9jAd1FVbaBBks/cVpc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjGMP97IXnOeu2Hr8HEsD
	423OLkZODgkBE4npH44wQ9hiEhfurWcDsYUEFjFK7Fvt0sXIBWTPZpJ4vKYTLMEmoCbx5cth
	dhBbREBDom31FBYQm1kgX+LwocssEM22Ert/vmAEsTkF7CRuLLsE1MvBISzgINHdGwpisgio
	SlyZXwBSwQtUvXnCfiYIW1Dix+R7UBO1JDZva2KFsOUlNq95ywzSKiGgLvHory7EAUYSF6be
	ZoMoEZHY9+IdI8jFEgJvWCT6dj1jhXjLVOLZ1M+MExhFZiFZMQvJillIVsxCMmsBI8sqRtHU
	guSC4qT0XCO94sTc4tK8dL3k/NxNjOAofya9g3FVg8UhRgEORiUe3gk6toFCrIllxZW5hxgl
	OJiVRHhXbrIJFOJNSaysSi3Kjy8qzUktPsSYDAyAicxSosn5wASUVxJvaGxiZmRpZGZhZGJu
	TpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MC1x2F916qPPhntnjq1Ntlsj8W54x0Viy
	cemFnLcPZZ4+Vrj9+e7dGR8tVGauN09XN+9jnb/uv828kLx9ZxZsX7LnPBfr2gU6buc4S6qi
	6s5e+C7uELfSYsMVt5/Lb84Uf7uMkedV7/01J1r8njho33+iI3r7hbpPsY3DJMH+Sye/HFfa
	/ux2/3ElluKMREMt5qLiRAAWxqu3NgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/power/ds2780_battery.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/power/ds2780_battery.c b/drivers/power/ds2780_battery.c
index 8b6c453..9f418fa 100644
--- a/drivers/power/ds2780_battery.c
+++ b/drivers/power/ds2780_battery.c
@@ -760,7 +760,7 @@ static int ds2780_battery_probe(struct platform_device *pdev)
 	int ret = 0;
 	struct ds2780_device_info *dev_info;
 
-	dev_info = kzalloc(sizeof(*dev_info), GFP_KERNEL);
+	dev_info = devm_kzalloc(&pdev->dev, sizeof(*dev_info), GFP_KERNEL);
 	if (!dev_info) {
 		ret = -ENOMEM;
 		goto fail;
@@ -779,7 +779,7 @@ static int ds2780_battery_probe(struct platform_device *pdev)
 	ret = power_supply_register(&pdev->dev, &dev_info->bat);
 	if (ret) {
 		dev_err(dev_info->dev, "failed to register battery\n");
-		goto fail_free_info;
+		goto fail;
 	}
 
 	ret = sysfs_create_group(&dev_info->bat.dev->kobj, &ds2780_attr_group);
@@ -813,8 +813,6 @@ fail_remove_group:
 	sysfs_remove_group(&dev_info->bat.dev->kobj, &ds2780_attr_group);
 fail_unregister:
 	power_supply_unregister(&dev_info->bat);
-fail_free_info:
-	kfree(dev_info);
 fail:
 	return ret;
 }
@@ -828,7 +826,6 @@ static int ds2780_battery_remove(struct platform_device *pdev)
 
 	power_supply_unregister(&dev_info->bat);
 
-	kfree(dev_info);
 	return 0;
 }
 
-- 
1.7.2.5


