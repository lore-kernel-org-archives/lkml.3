Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab3LAX5N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 18:57:13 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:29405 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab3LAX5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 18:57:11 -0500
X-AuditID: cbfee68f-b7f336d00000481b-50-529bccd5148a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000001ceeef0$d88a7f40$899f7dc0$%han@samsung.com>
In-reply-to: <000001ceeef0$d88a7f40$899f7dc0$%han@samsung.com>
Subject: [PATCH 4/8] backlight: ot200_bl: use devm_backlight_device_register()
Date: Mon, 02 Dec 2013 08:57:09 +0900
Message-id: <000301ceeef1$0c17d2e0$244778a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7u8NgcVnqPK6OFQjq+Xy+HsAignwAACZfg
Content-language: ko
x-cr-hashedpuzzle: A8tL C1bl EpYb FOv3 HrXy Hscc Mn8K QlEs TYJd YmEV Y3ad Z5N4
 dH+O dIRw dZ4e
 f7M4;3;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnAA==;Sosha1_v1;7;{B8146538-4784-4931-8C0A-FB849F207FE1};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Sun,
 01 Dec 2013 23:57:04
 GMT;WwBQAEEAVABDAEgAIAA0AC8AOABdACAAYgBhAGMAawBsAGkAZwBoAHQAOgAgAG8AdAAyADAAMABfAGIAbAA6ACAAdQBzAGUAIABkAGUAdgBtAF8AYgBhAGMAawBsAGkAZwBoAHQAXwBkAGUAdgBpAGMAZQBfAHIAZQBnAGkAcwB0AGUAcgAoACkA
x-cr-puzzleid: {B8146538-4784-4931-8C0A-FB849F207FE1}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t8zA92rZ2YHGbzfYWMxZ/0aNovLCy+x
	WlzeNYfNgdnjxIzfLB59W1YxenzeJBfAHMVlk5Kak1mWWqRvl8CVsWPxQpaC/VwV274cZ2pg
	/MrRxcjJISFgIjF7zkI2CFtM4sK99UA2F4eQwDJGiWUrFrDAFO3/9p4VIjGdUWJ/YzsLhPOL
	UWL1wmZGkCo2ATWJL18Os3cxcnCICOhLtLVogJjMAi4SR6eJgFQICdhKbHh0ngnE5hSwk5hw
	8w+YLSzgJ3Fw2kJWkHIWAVWJRSeTQMK8QOUTWk4zQ9iCEj8m3wM7h1lAS2L9zuNMELa8xOY1
	b5lBWiUE1CUe/dWF2G8k0ffBDKJCRGLfi3eMIPdKCHxhkZh6ajcjxFemEsePfWOHSNxil/h3
	ZgHYLhYBAYlvkw+xQMyUldh0gBmiXlLi4IobLBMYpWYhuWgWkotmIbloFpLdCxhZVjGKphYk
	FxQnpRcZ6xUn5haX5qXrJefnbmKERGv/Dsa7B6wPMSYDrZ/ILCWanA+M9rySeENjMyMLUxNT
	YyNzSzPShJXEee8/TAoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwCiRxNly+98OrXUT+y/t
	uqV6ff6X8K8Ofr7OJaFl9yfJlLNKbm/Ky71xLO2p1zu7N9GnprQv+jvnb475luhwx7AJj5er
	79bbJGz0dAb3psN/90xcFSNi1nNzw8PUNUdPnuuol+D6uNXJKrhgppTtwi3f2Rcp9m3pk8pp
	/6btMe/UNfblu53m1rQosRRnJBpqMRcVJwIADFGeaewCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jQd2rZ2YHGTz4ZGExZ/0aNovLCy+x
	WlzeNYfNgdnjxIzfLB59W1YxenzeJBfAHNXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZg
	qGtoaWGupJCXmJtqq+TiE6DrlpkDtElJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyP
	kQEaSFjHmLFj8UKWgv1cFdu+HGdqYPzK0cXIySEhYCKx/9t7VghbTOLCvfVsXYxcHEIC0xkl
	9je2s0A4vxglVi9sZgSpYhNQk/jy5TB7FyMHh4iAvkRbiwaIySzgInF0mghIhZCArcSGR+eZ
	QGxOATuJCTf/gNnCAn4SB6ctZAUpZxFQlVh0MgkkzAtUPqHlNDOELSjxY/I9FhCbWUBLYv3O
	40wQtrzE5jVvmUFaJQTUJR791YXYbyTR98EMokJEYt+Ld4wg90oIfGGRmHpqNyPEV6YSx499
	Y5/AKDILyYZZSDbMQrJhFpJZCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEp4Jn0jsY
	VzVYHGIU4GBU4uG9cGJ2kBBrYllxZe4hRgkOZiURXouvs4KEeFMSK6tSi/Lji0pzUosPMSYD
	/T+RWUo0OR+YpvJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1Oq
	gbEvcmXQh7Y7LO2rNxp/NfL94s2+/alb8Hv7Sul85Zv26neV+rZXLldKigm7LLUjR2HnS569
	KZ23Viyc6pDAuf1i7/rytBk/8zMTEmZ5/SzXevD6zQxeEbvS79eb38g8V13wS+XTxcRfCWGa
	4qZFyrL60xMWc0ucVDc+WfVX5va7tnNa3WH8f5VYijMSDbWYi4oTAa0uBPlJAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_backlight_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ot200_bl.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/video/backlight/ot200_bl.c b/drivers/video/backlight/ot200_bl.c
index fdbb6ee..f5a5202 100644
--- a/drivers/video/backlight/ot200_bl.c
+++ b/drivers/video/backlight/ot200_bl.c
@@ -118,8 +118,9 @@ static int ot200_backlight_probe(struct platform_device *pdev)
 	props.brightness = 100;
 	props.type = BACKLIGHT_RAW;
 
-	bl = backlight_device_register(dev_name(&pdev->dev), &pdev->dev, data,
-					&ot200_backlight_ops, &props);
+	bl = devm_backlight_device_register(&pdev->dev, dev_name(&pdev->dev),
+					&pdev->dev, data, &ot200_backlight_ops,
+					&props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
 		retval = PTR_ERR(bl);
@@ -137,10 +138,6 @@ error_devm_kzalloc:
 
 static int ot200_backlight_remove(struct platform_device *pdev)
 {
-	struct backlight_device *bl = platform_get_drvdata(pdev);
-
-	backlight_device_unregister(bl);
-
 	/* on module unload set brightness to 100% */
 	cs5535_mfgpt_write(pwm_timer, MFGPT_REG_COUNTER, 0);
 	cs5535_mfgpt_write(pwm_timer, MFGPT_REG_SETUP, MFGPT_SETUP_CNTEN);
-- 
1.7.10.4


