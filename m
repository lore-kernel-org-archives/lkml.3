Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbaBUMMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:12:52 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:62759 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbaBUMMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:12:51 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-0d-530742c09772
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH v2] regulator: max14577: Fix invalid return value on DT parse
 success
Date: Fri, 21 Feb 2014 13:12:38 +0100
Message-id: <1392984758-10127-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIJMWRmVeSWpSXmKPExsVy+t/xy7oHnNiDDZ73GlpMffiEzeL1C0OL
	b1c6mCwu75rDZnHyTy+jA6vHzll32T02repk87hzbQ+bR9+WVYwenzfJBbBGcdmkpOZklqUW
	6dslcGUs/LuYveA6R8WK/VkNjHPZuxg5OSQETCQOrNkIZYtJXLi3nq2LkYtDSGApo0Tz8aks
	EE4fk8Shle+YQarYBIwlNi9fwgZiiwhkSGyeN5UVxGYWiJaY/foYWI2wQLjEkbmTWEBsFgFV
	ietf/zCC2LwC7hItX9YBxTmAtilIzJlkM4GRewEjwypG0dTS5ILipPRcQ73ixNzi0rx0veT8
	3E2MkGD4soNx8TGrQ4wCHIxKPLwFEmzBQqyJZcWVuYcYJTiYlUR4D+qzBwvxpiRWVqUW5ccX
	leakFh9iZOLglGpg1ElbmXLDqOVBhVr3XBUHkS+nvr+be+PJUclNwj+P1vLtdZnh+IMhZuov
	wV1TVL+L3w9ctOncyX7vu7vmSKYI8Ic6ysnq7YqVdnL+w/WwUrf+fKGfz0HlC3/uTbvmWDXZ
	PUPWo+th7Y9E0+0O0nxRDEmM7j41k+J12ZKOeigu+XRHtU0hTMROiaU4I9FQi7moOBEAU/mz
	t+QBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes bug introduced in 667a6b7a (regulator: max14577: Add missing
of_node_put). The DTS parsing function returned number of matched
regulators as success status which then was compared against 0 in probe.

Result was a probe fail after successful parsing the DTS:
max14577-regulator: probe of max14577-regulator failed with error 2

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/max14577.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/max14577.c b/drivers/regulator/max14577.c
index 186df8785a91..e0619526708c 100644
--- a/drivers/regulator/max14577.c
+++ b/drivers/regulator/max14577.c
@@ -166,9 +166,10 @@ static int max14577_regulator_dt_parse_pdata(struct platform_device *pdev)
 
 	ret = of_regulator_match(&pdev->dev, np, max14577_regulator_matches,
 			MAX14577_REG_MAX);
-	if (ret < 0) {
+	if (ret < 0)
 		dev_err(&pdev->dev, "Error parsing regulator init data: %d\n", ret);
-	}
+	else
+		ret = 0;
 
 	of_node_put(np);
 
-- 
1.7.9.5

