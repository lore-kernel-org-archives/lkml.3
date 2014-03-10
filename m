Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbaCJIeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 04:34:25 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:22261 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbaCJIdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 04:33:03 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-be-531d78bc4b71
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 6/8] regulator: max8925: Remove unused state container fields
Date: Mon, 10 Mar 2014 09:32:49 +0100
Message-id: <1394440371-29588-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1394440371-29588-1-git-send-email-k.kozlowski@samsung.com>
References: <1394440371-29588-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAJMWRmVeSWpSXmKPExsVy+t/xK7p7KmSDDdqmqFlMffiEzeL1C0OL
	b1c6mCwu75rD5sDisXPWXXaPTas62Tz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoErY/exZUwF
	U9krjm8/zt7A+J21i5GTQ0LAROLRqWYmCFtM4sK99WxdjFwcQgJLGSV2TLzODOH0MUn03QZx
	ODnYBIwlNi9fwgZiiwhkSGyeNxVsErOAocTPd3/YQWxhAV+JLwc/gE1lEVCVuPl1EiOIzSvg
	LrFibQ9LFyMH0DYFiTmTbEDCnAIeEov23AJrFQIq2d25g2UCI+8CRoZVjKKppckFxUnpuUZ6
	xYm5xaV56XrJ+bmbGCGh8nUH49JjVocYBTgYlXh4D7yVCRZiTSwrrsw9xCjBwawkwpsRJxss
	xJuSWFmVWpQfX1Sak1p8iJGJg1OqgdHp4h3Xb8wMs77M2myprDG3oOr6gcu70tvOLbW9WHrl
	x8uTz9xtloYuWnhbyqGrm3WtyKS7IdJy719P1d/87swrvxu/A3oWvyxJjWY5t0G1YUrIRZGs
	94dFeld5L1tfple6zqUyMnVLSP17jduHjT+uVbVoCz7pHGKzOiBFc/HNjxfZlzT85v6hxFKc
	kWioxVxUnAgAPvrGIPMBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove fields from 'struct max8907_regulator' which are not used
anywhere in the driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max8925-regulator.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index 759510789e71..17c16266c03f 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -36,9 +36,7 @@
 
 struct max8925_regulator_info {
 	struct regulator_desc	desc;
-	struct regulator_dev	*regulator;
 	struct i2c_client	*i2c;
-	struct max8925_chip	*chip;
 
 	int	vol_reg;
 	int	enable_reg;
@@ -303,7 +301,6 @@ static int max8925_regulator_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 	ri->i2c = chip->i2c;
-	ri->chip = chip;
 
 	config.dev = &pdev->dev;
 	config.driver_data = ri;
-- 
1.7.9.5

