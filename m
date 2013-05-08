Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab3EHKwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 06:52:24 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55862 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab3EHKwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 06:52:21 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/2] regulator: palmas: Fix incorrect condition
Date: Wed,  8 May 2013 16:09:06 +0530
Message-Id: <1368009546-20770-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368009546-20770-1-git-send-email-sachin.kamat@linaro.org>
References: <1368009546-20770-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 'id' cannot take two values at the same time, the condition
should probably be an OR (||) instead of AND (&&).

Introduced by commit 28d1e8cd67 ("regulator: palma: add ramp delay
support through regulator constraints").

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>
---
Compile tested against for-next branch of regulator tree.
---
 drivers/regulator/palmas-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 92ceed0..ced7416 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -840,7 +840,7 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 			break;
 		}
 
-		if ((id == PALMAS_REG_SMPS6) && (id == PALMAS_REG_SMPS8))
+		if ((id == PALMAS_REG_SMPS6) || (id == PALMAS_REG_SMPS8))
 			ramp_delay_support = true;
 
 		if (ramp_delay_support) {
-- 
1.7.9.5

