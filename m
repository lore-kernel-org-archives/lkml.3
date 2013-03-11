Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab3CKGfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 02:35:18 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:19486 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3CKGfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 02:35:15 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-f4-513d7b22bf36
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
In-reply-to: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
Subject: [PATCH 11/14] power: max8998_charger: use devm_kzalloc()
Date: Mon, 11 Mar 2013 15:35:14 +0900
Message-id: <007b01ce1e22$9689fcf0$c39df6d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4eIfOI6J7YtEddQ/Gjh19YaZUzVAAAJi0g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zQ12lattAg10vNSwObtW0mLhyMrPF
	5YWXWC0u75rD5sDiMaH/E6PH5hVaHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJVx/NV85oKn
	HBXnbn1hbWBcwt7FyMkhIWAiMW/DDmYIW0ziwr31bF2MXBxCAssYJaat/MgKU3Tw5HoWEFtI
	YDqjxPk7aRBFvxglbh7+xgiSYBNQk/jy5TDYVBEBDYm21VPAGpgF8iUOH7oM1WwrsfvnC7B6
	TgE7iRvLLrGB2MICjhI/u+6AXcEioCpxeu4+sBpeoPpjfd0sELagxI/J96Bmakls3tbECmHL
	S2xe8xaolwPoUHWJR391IU4wkthzYgU7RImIxL4X7xhBbpYQOMYuMaPvIxvELgGJb5MPsUD0
	ykpsOgANCEmJgytusExglJiFZPMsJJtnIdk8C8mKBYwsqxhFUwuSC4qT0otM9YoTc4tL89L1
	kvNzNzFCInLiDsb7B6wPMSYDrZ/ILCWanA+M6LySeENjMyMLUxNTYyNzSzPShJXEedVbrAOF
	BNITS1KzU1MLUovii0pzUosPMTJxcEo1MGZdVM0+db+o9fIBvZz/C8x8ki0app+NWvXxm7bE
	gUz1ufI37AW3Nx35xJY9LWiV+L5mhmenUiI7z2z/zNn8r/OvSl7uzCPTfrNOfMs97ci5DYxf
	astu+5+/Ojv71e2NSxZdsFrflpbh31Xz7aHfwVXP1Wy9Kv/UZHTFt5auerXj1+PguQ+2dS5V
	YinOSDTUYi4qTgQAvfhB5d4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jQV2lattAg0ltqhYHt2paTFw5mdni
	8sJLrBaXd81hc2DxmND/idFj8wotj74tqxg9Pm+SC2CJamC0yUhNTEktUkjNS85PycxLt1Xy
	Do53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHaqKRQlphTChQKSCwuVtK3wzQhNMRN1wKm
	MULXNyQIrsfIAA0krGPMOP5qPnPBU46Kc7e+sDYwLmHvYuTkkBAwkTh4cj0LhC0mceHeejYQ
	W0hgOqPE+TtpXYxcQPYvRombh78xgiTYBNQkvnw5DNYsIqAh0bZ6Clgzs0C+xOFDl1kgmm0l
	dv98AVbPKWAncWPZJbChwgKOEj+77jCD2CwCqhKn5+4Dq+EFqj/W180CYQtK/Jh8D2qmlsTm
	bU2sELa8xOY1b4F6OYAOVZd49FcX4gQjiT0nVrBDlIhI7HvxjnECo9AsJJNmIZk0C8mkWUha
	FjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIjvdn0jsYVzVYHGIU4GBU4uGdoGMbKMSa
	WFZcmXuIUYKDWUmEd+Umm0Ah3pTEyqrUovz4otKc1OJDjMlAj05klhJNzgemorySeENjEzMj
	SyMzCyMTc3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRqYHT3fbvzlfmLoGz/8CO/Cqbw
	RTMxd+1k2vW7871W1+Gp/0+zq8y/8PpD/Nai6lXb/2YLPirXq3nVd/FCkGWpovwzjmf39G9/
	z9/YdrhL6mLni3+shrc+z+nw3RD07p7OgsmB2evszI+mbpJR5LJ52KoRce2kl9pjW2HVbfla
	L67USf9PmO72fLUSS3FGoqEWc1FxIgAP2KWkOwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/power/max8998_charger.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/power/max8998_charger.c b/drivers/power/max8998_charger.c
index bf677e3..5017470 100644
--- a/drivers/power/max8998_charger.c
+++ b/drivers/power/max8998_charger.c
@@ -88,7 +88,8 @@ static int max8998_battery_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	max8998 = kzalloc(sizeof(struct max8998_battery_data), GFP_KERNEL);
+	max8998 = devm_kzalloc(&pdev->dev, sizeof(struct max8998_battery_data),
+				GFP_KERNEL);
 	if (!max8998)
 		return -ENOMEM;
 
@@ -174,7 +175,6 @@ static int max8998_battery_probe(struct platform_device *pdev)
 
 	return 0;
 err:
-	kfree(max8998);
 	return ret;
 }
 
@@ -183,7 +183,6 @@ static int max8998_battery_remove(struct platform_device *pdev)
 	struct max8998_battery_data *max8998 = platform_get_drvdata(pdev);
 
 	power_supply_unregister(&max8998->battery);
-	kfree(max8998);
 
 	return 0;
 }
-- 
1.7.2.5


