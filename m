Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab3CKGe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 02:34:58 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:19416 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3CKGe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 02:34:57 -0400
X-AuditID: cbfee690-b7f656d0000007e3-bf-513d7b10b778
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
In-reply-to: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
Subject: [PATCH 10/14] power: max8997_charger: use devm_kzalloc()
Date: Mon, 11 Mar 2013 15:34:55 +0900
Message-id: <007a01ce1e22$8b9f7e50$a2de7af0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4eIfOI6J7YtEddQ/Gjh19YaZUzVAAAIyFA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zfV2BattAgwW3eCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGi8997AW/uSoezzrC1sDYydnFyMEhIWAisep2YBcjJ5ApJnHh
	3nq2LkYuDiGBZYwStz5PZoJImEjseXaQGSKxCCixdwsrhDObSWLn+05WkCo2ATWJL18Os4PY
	IgIaEm2rp7CA2MwC+RKHD10Gs4UEbCV2/3zBCGJzCthJ3Fh2iQ3EFhZwlLi8qwWsl0VAVWLj
	1tNgNi9QfevC28wQtqDEj8n3oGZqSWze1sQKYctLbF7zlhniG3WJR391IU4wkrjzbiojRImI
	xL4X7xhBbpYQWMQu8XnJMzaIXQIS3yYfYoHolZXYdIAZ4mFJiYMrbrBMYJSYhWTzLCSbZyHZ
	PAvJigWMLKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLzczcxQiJrwg7GewesDzEmA62fyCwlmpwP
	jMy8knhDYzMjC1MTU2Mjc0sz0oSVxHnVW6wDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTB2
	p2ny8zm+yft+4e6qhz+DVNI/6djeOXFrptaRl7wmXr+LnYxabyzfU9DDsqe09WBP4ZcPNZf3
	+GvdVpBgKOTSWvx//YsK5YXfv3d5Kx/5/1Cu+WbUQ79/FSWJ8VVLctaknxO3kny519D2rsKO
	0i1fC/3/biu12LElWcKpT7ww/u3Z4/4/hfmUWIozEg21mIuKEwGFfPcbwgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xgK5AtW2gwaUODovLu+awOTB6fN4k
	F8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQM0
	VUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8eJzH3vBb66Kx7OOsDUw
	dnJ2MXJySAiYSOx5dpAZwhaTuHBvPVsXIxeHkMAiRolbe7ewQjizmSR2vu9kBaliE1CT+PLl
	MDuILSKgIdG2egoLiM0skC9x+NBlMFtIwFZi988XjCA2p4CdxI1ll9hAbGEBR4nLu1rAelkE
	VCU2bj0NZvMC1bcuvM0MYQtK/Jh8D2qmlsTmbU2sELa8xOY1b4FqOIAuVZd49FcX4gQjiTvv
	pjJClIhI7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P
	3cQIjtxnUjsYVzZYHGIU4GBU4uGdoGMbKMSaWFZcmXuIUYKDWUmEd+Umm0Ah3pTEyqrUovz4
	otKc1OJDjMlAj05klhJNzgcmlbySeENjEzMjSyMzCyMTc3PShJXEeQ+0WgcKCaQnlqRmp6YW
	pBbBbGHi4JRqYMxy2vpUZe6lM18WtT7fHv7F/ZjI2S0PTqbLLfspNPGgUInZ4ceqIazV2+/H
	zfnicUj69n3dQ0sjX82Zefu2jPXyq3WPl9+d41RlLWV8TT8rsO5R36uXGnXy4bwtgqZvklKf
	RdSFGVauOv/87vtkJ5fA1Pbl8huYDu3dE/lSufN86slGZq7HcZeVWIozEg21mIuKEwEfJ2b1
	IAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/power/max8997_charger.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/power/max8997_charger.c b/drivers/power/max8997_charger.c
index e757885..4bdedfe 100644
--- a/drivers/power/max8997_charger.c
+++ b/drivers/power/max8997_charger.c
@@ -138,7 +138,8 @@ static int max8997_battery_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	charger = kzalloc(sizeof(struct charger_data), GFP_KERNEL);
+	charger = devm_kzalloc(&pdev->dev, sizeof(struct charger_data),
+				GFP_KERNEL);
 	if (charger == NULL) {
 		dev_err(&pdev->dev, "Cannot allocate memory.\n");
 		return -ENOMEM;
@@ -158,13 +159,10 @@ static int max8997_battery_probe(struct platform_device *pdev)
 	ret = power_supply_register(&pdev->dev, &charger->battery);
 	if (ret) {
 		dev_err(&pdev->dev, "failed: power supply register\n");
-		goto err;
+		return ret;
 	}
 
 	return 0;
-err:
-	kfree(charger);
-	return ret;
 }
 
 static int max8997_battery_remove(struct platform_device *pdev)
@@ -172,7 +170,6 @@ static int max8997_battery_remove(struct platform_device *pdev)
 	struct charger_data *charger = platform_get_drvdata(pdev);
 
 	power_supply_unregister(&charger->battery);
-	kfree(charger);
 	return 0;
 }
 
-- 
1.7.2.5


