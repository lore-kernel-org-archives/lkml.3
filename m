Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818AbaJaQE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 12:04:26 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:10461 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289AbaJaQEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:04:25 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-e5-5453b305e9d0
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] regulator: Staticize 'regulator_states' array
Date: Fri, 31 Oct 2014 17:04:14 +0100
Message-id: <1414771454-28260-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBJMWRmVeSWpSXmKPExsVy+t/xK7qsm4NDDPrOyVlMffiEzeL1C0OL
	b1c6mCwu75rD5sDisXPWXXaPTas62Tz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoErY9+n9awF
	vewV/QcPsTUwtrB1MXJySAiYSLxefALKFpO4cG89kM3FISSwlFGib9ZpRginj0ni4JOHLCBV
	bALGEpuXLwHrEBHIkNg8byoriM0sYCjx890fdhBbWMBO4vir3UxdjBwcLAKqEv9/GYOEeQXc
	JZ7OncMCsUxO4uSxyawTGLkXMDKsYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAjx/dcdjEuP
	WR1iFOBgVOLh1fgSFCLEmlhWXJl7iFGCg1lJhHf+uuAQId6UxMqq1KL8+KLSnNTiQ4xMHJxS
	DYyyL/OufQue8q/z+bT3tk+nLu6YLNCQc893+j+LC/qJSSu5Hm6z1Ov5axCV8aBvzqINZZaf
	as9P5tFfOG326itxp1bd2rl7mtH3hnJvhq1H+E8WbTx792X2NangA40LtlxsylNxTnNN4GkS
	UfBbJsF7b+WRvIKFvP1RHPrb3jMy5MhLX71lzsCrxFKckWioxVxUnAgABGcrddsBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'regulator_states' array is used only in this unit and it is not
exported. Make it static.

This also fixes following sparse warning:
drivers/regulator/of_regulator.c:22:12: warning: symbol 'regulator_states' was not declared. Should it be static?

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/of_regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 05b636840d6f..25618fb728a3 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -19,7 +19,7 @@
 
 #include "internal.h"
 
-const char *const regulator_states[PM_SUSPEND_MAX + 1] = {
+static const char *const regulator_states[PM_SUSPEND_MAX + 1] = {
 	[PM_SUSPEND_MEM]	= "regulator-state-mem",
 	[PM_SUSPEND_MAX]	= "regulator-state-disk",
 };
-- 
1.9.1

