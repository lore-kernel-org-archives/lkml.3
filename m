Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbaBEQ4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 11:56:40 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25191 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbaBEQ4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 11:56:39 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-0d-52f26d446792
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] regulator: max14577: Add missing of_node_put
Date: Wed, 05 Feb 2014 17:56:27 +0100
Message-id: <1391619387-18043-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGJMWRmVeSWpSXmKPExsVy+t/xy7ouuZ+CDC7tlrWY+vAJm8XrF4YW
	3650MFlc3jWHzYHFY+esu+wem1Z1snn0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxpktf5gK
	9rNVPD+zkrmBcStrFyMnh4SAicT/zXehbDGJC/fWs3UxcnEICSxllJh58B0zhNPHJPHv7yx2
	kCo2AWOJzcuXsIHYIgIZEpvnTQXrZhYwlPj57g9YjbCArcS9VeuBbA4OFgFVibtTQ0BMXgF3
	iYeTy0BMCQEFiTmTbCYwci9gZFjFKJpamlxQnJSea6hXnJhbXJqXrpecn7uJEeL3LzsYFx+z
	OsQowMGoxMPbIfoxSIg1say4MvcQowQHs5II7+6MT0FCvCmJlVWpRfnxRaU5qcWHGJk4OKUa
	GKd9XM5QsG2aW/d6M90Q3sXqa26r3QvrqHq+w1fGtNH5zI/0G0+Sq10OBMqG3feZUL2q1nFB
	0FoW1Zkpfo3X71yLT9LicOurPG3/YbXWT/3zD9QC1lQnZWf1Rp7qsNyW1r0jQ/C0QYJ2vCzT
	kcIHxza5RkhMYX//9o2+vO/lybusqxgZP92MVWIpzkg01GIuKk4EAFgzRTbZAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Decrease the reference count for 'regulators' device_node, obtained by
of_get_child_by_name().

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max14577.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/max14577.c b/drivers/regulator/max14577.c
index 38821458d413..dc40c5ca4b75 100644
--- a/drivers/regulator/max14577.c
+++ b/drivers/regulator/max14577.c
@@ -162,10 +162,11 @@ static int max14577_regulator_dt_parse_pdata(struct platform_device *pdev)
 			MAX14577_REG_MAX);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Error parsing regulator init data: %d\n", ret);
-		return ret;
 	}
 
-	return 0;
+	of_node_put(np);
+
+	return ret;
 }
 
 static inline struct regulator_init_data *match_init_data(int index)
-- 
1.7.9.5

