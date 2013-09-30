Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab3I3A7e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 20:59:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18603 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab3I3A7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 20:59:32 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-cf-5248ccf33a4b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Pawel Moll'" <pawel.moll@arm.com>
References: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
In-reply-to: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
Subject: [PATCH V4 14/14] regulator: vexpress: use devm_regulator_register()
Date: Mon, 30 Sep 2013 09:59:31 +0900
Message-id: <008101cebd78$5219c9b0$f64d5d10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac69dwY7qCw/SuPGSmKRawAumfnevwAAT0Uw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zfd3PZzyCDFZOEbeY+vAJm8XlhZdY
	Lb5d6WCyuLxrDpvFhOlrWRxYPdbMW8PosXPWXXaPTas62Tz6tqxi9Pi8SS6ANYrLJiU1J7Ms
	tUjfLoErY97HeSwFBzkqVr54zNrAOJ+9i5GTQ0LAROLmoTusELaYxIV769m6GLk4hASWMUo8
	eLODDabo4upmJojEIkaJvx9Xs0M4vxglDl7fAdbOJqAm8eXLYaAEB4eIgKrE/1fuIGFmgQmM
	Ei+eWILYQgK2EnPOn2UEsTkF7CTubGgFs4UFfCQWnF8MNoYFqHXV06+sIGN4geqvT7AHCfMK
	CEr8mHyPBWKklsT6nceZIGx5ic1r3jKDlEsIqEs8+qsLEhYRMJI4tXMqO0SJiMS+F+8YQS6W
	ELjHLtG2Yg87xCoBiW+TD7FA9MpKbDrADPGupMTBFTdYgO6ehWTzLCSbZyHZPAvJigWMLKsY
	RVMLkguKk9KLTPWKE3OLS/PS9ZLzczcxQuJ04g7G+wesDzEmA62fyCwlmpwPjPO8knhDYzMj
	C1MTU2Mjc0sz0oSVxHnVW6wDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTCWe63M9Arjn9K2
	5HkNT8q0PRP2+G+uiai5V8H0SpzHe3ngFIZb+uW8dt/cDtvP+fU7cduaPscc8TWrHt2ffVZ8
	TsjiqAnczz8xVn29KllU4Brc1WhTsPr95dqt06zmXGmW4VlU/T9v7XP3Zwbbrvswz0mumHlw
	otCTBPlZHXXnM91vzWsPfvVfiaU4I9FQi7moOBEAy5JR5ukCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jAd3PZzyCDI5tF7aY+vAJm8XlhZdY
	Lb5d6WCyuLxrDpvFhOlrWRxYPdbMW8PosXPWXXaPTas62Tz6tqxi9Pi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWPex3ksBQc5Kla+eMzawDifvYuRk0NCwETi
	4upmJghbTOLCvfVsXYxcHEICixgl/n5czQ7h/GKUOHh9BytIFZuAmsSXL4eBEhwcIgKqEv9f
	uYOEmQUmMEq8eGIJYgsJ2ErMOX+WEcTmFLCTuLOhFcwWFvCRWHB+MdgYFqDWVU+/soKM4QWq
	vz7BHiTMKyAo8WPyPRaIkVoS63ceZ4Kw5SU2r3nLDFIuIaAu8eivLkhYRMBI4tTOqewQJSIS
	+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCk8Az
	6R2MqxosDjEKcDAq8fBaLPUIEmJNLCuuzD3EKMHBrCTCuzwJKMSbklhZlVqUH19UmpNafIgx
	GejPicxSosn5wASVVxJvaGxiZmRpZGZhZGJuTpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTByc
	Ug2Mc5UMYx9d+rx+zvTI8O4M5U0bPrbluOc9Ot/KmOXem1oezHUoV3I+f6ik+FelWQf7mc4z
	hjTeyCrWm7fT5uIT/T2nF97jOhYR5rE8KS1LYc3xjnspF/VOiR7WlHeKEPXLWfawSShft/+h
	6zvrOedk/kaVfnu/YMveKOGz2+1Z3Ode0gmT93JXYinOSDTUYi4qTgQAqK5jhkYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/regulator/vexpress.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/regulator/vexpress.c b/drivers/regulator/vexpress.c
index 4668c7f..f3ae28a 100644
--- a/drivers/regulator/vexpress.c
+++ b/drivers/regulator/vexpress.c
@@ -96,7 +96,7 @@ static int vexpress_regulator_probe(struct platform_device *pdev)
 	config.driver_data = reg;
 	config.of_node = pdev->dev.of_node;
 
-	reg->regdev = regulator_register(&reg->desc, &config);
+	reg->regdev = devm_regulator_register(&pdev->dev, &reg->desc, &config);
 	if (IS_ERR(reg->regdev)) {
 		err = PTR_ERR(reg->regdev);
 		goto error_regulator_register;
@@ -119,7 +119,6 @@ static int vexpress_regulator_remove(struct platform_device *pdev)
 	struct vexpress_regulator *reg = platform_get_drvdata(pdev);
 
 	vexpress_config_func_put(reg->func);
-	regulator_unregister(reg->regdev);
 
 	return 0;
 }
-- 
1.7.10.4


