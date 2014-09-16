Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbaIPQK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:10:56 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:20479 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbaIPQKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:10:52 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-e4-5418610925ca
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH RESEND 2/2] power: max8925: Use of_get_child_by_name
Date: Tue, 16 Sep 2014 18:10:41 +0200
Message-id: <1410883841-8276-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410883841-8276-1-git-send-email-k.kozlowski@samsung.com>
References: <1410883841-8276-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDJMWRmVeSWpSXmKPExsVy+t/xy7qciRIhBt/mmVlMevKe2WLiysnM
	Fq9fGFpc3jWHzeJz7xFGi9O7SxzYPHbOusvusXmFlsemVZ1sHn1bVjF6fN4kF8AaxWWTkpqT
	WZZapG+XwJVxou8qa8EGtoruf9eZGxg3s3YxcnBICJhI3F+o1MXICWSKSVy4t54NxBYSWMoo
	8Wa6UxcjF5DdxyTR2HuKFSTBJmAssXn5EjaQhIjAbkaJCVOXs4AkmAUMJX6++8MOYgsLuEjc
	2v4YzGYRUJX4+PMcmM0r4CZx/9AJNohtchInj00GG8op4C7x5OhfRpCDhIBqZv+Jm8DIu4CR
	YRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSAh92cG4+JjVIUYBDkYlHt6Mf+IhQqyJZcWV
	uYcYJTiYlUR4f/hKhAjxpiRWVqUW5ccXleakFh9iZOLglGpgDLV1vTj7nvytwj/RiR7GSYL8
	tdJmd/Q7ZK1+e5/9/r88sGSz/E2HgO7ak+4XZEIbjWQm17x7tu7ppyOnlObrHmB/U5V9vdrP
	puKx3xfe7PchX2YvzXq7P6SmNbPM4/On1fqTDxjdsfluxzqbgfuQbbOJ0mmVkv7iMw2uzs0W
	1bIMl8//VV6vxFKckWioxVxUnAgAI3jvI/8BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use of_get_child_by_name to obtain reference to charger node instead of
of_find_node_by_name which can walk outside of the parent node.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/power/max8925_power.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
index 0cf237808d47..a6d45eef64dd 100644
--- a/drivers/power/max8925_power.c
+++ b/drivers/power/max8925_power.c
@@ -443,7 +443,7 @@ max8925_power_dt_init(struct platform_device *pdev)
 	if (!nproot)
 		return pdev->dev.platform_data;
 
-	np = of_find_node_by_name(nproot, "charger");
+	np = of_get_child_by_name(nproot, "charger");
 	if (!np) {
 		dev_err(&pdev->dev, "failed to find charger node\n");
 		return NULL;
-- 
1.9.1

