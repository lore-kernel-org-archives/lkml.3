Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaJJLfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 07:35:45 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60622 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbaJJLfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 07:35:41 -0400
X-AuditID: cbfee68f-f791c6d000004834-d5-5437c48a9523
From: Chanwoo Choi <cw00.choi@samsung.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        kyungmin.park@samsung.com, javier@dowhile0.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv5 1/3] regulator: of: Add support for parsing regulator_state
 for suspend state
Date: Fri, 10 Oct 2014 20:35:33 +0900
Message-id: <1412940935-14721-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1412940935-14721-1-git-send-email-cw00.choi@samsung.com>
References: <1412940935-14721-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsWyRsSkWLfriHmIQddTQ4upD5+wWVz/8pzV
	Yv6Rc6wWB/7sYLS49nsGm8XZpjfsFt+udDBZXN41h82ide8RdgdOj7+zW5k9ds66y+6xaVUn
	m8eda3vYPPq2rGL0+LxJLoAtissmJTUnsyy1SN8ugSuj7WYrc8EGoYoLJ/vZGxgX8XcxcnJI
	CJhIrFj/gAnCFpO4cG89WxcjF4eQwFJGiR3vVzDDFJ361csOkVjEKPHm7RSoqiYmiafv+sHa
	2QS0JPa/uMEGYosAjbo9p5MZpIhZ4AajxIHty1hAEsICiRI/TvSB2SwCqhKPVkLYvAKuEi9/
	72CBWCcn8WHPI3YQm1PATWLO1AZGEFsIqGbpx2MsIEMlBNaxS6w9uRxqkIDEt8mHgGwOoISs
	xKYDUGdLShxccYNlAqPwAkaGVYyiqQXJBcVJ6UXGesWJucWleel6yfm5mxiBkXD637P+HYx3
	D1gfYhTgYFTi4dWQNw8RYk0sK67MPcRoCrRhIrOUaHI+MN7ySuINjc2MLExNTI2NzC3NlMR5
	F0r9DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAOM/s343gR/6zLr+Sfc/R7KU8yasvlOEa
	7xQT/5qLrvcmvE18Nv2g3t1v+j3F5m805oolytoWe0QyX15csfvOK3e9nXVep6Kfq9e+SpRZ
	9edZ19nNt4red9xZoTqtxVhyauX1DovblYeYvuxdu7x5Q4952rtQhR+c8+IVgvx4OhJsG1dZ
	dbwzVGIpzkg01GIuKk4EADwxksB/AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t9jAd2uI+YhBhsXaFpMffiEzeL6l+es
	FvOPnGO1OPBnB6PFtd8z2CzONr1ht/h2pYPJ4vKuOWwWrXuPsDtwevyd3crssXPWXXaPTas6
	2TzuXNvD5tG3ZRWjx+dNcgFsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZK
	CnmJuam2Si4+AbpumTlAZykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsY
	M9putjIXbBCquHCyn72BcRF/FyMnh4SAicSpX73sELaYxIV769m6GLk4hAQWMUq8eTsFymli
	knj6rp8JpIpNQEti/4sbbCC2CFDH7TmdzCBFzAI3GCUObF/GApIQFkiU+HGiD8xmEVCVeLQS
	wuYVcJV4+XsHC8Q6OYkPex6BreYUcJOYM7WBEcQWAqpZ+vEYywRG3gWMDKsYRVMLkguKk9Jz
	DfWKE3OLS/PS9ZLzczcxguPsmdQOxpUNFocYBTgYlXh4L8iYhwixJpYVV+YeYpTgYFYS4Z2/
	FyjEm5JYWZValB9fVJqTWnyI0RToqonMUqLJ+cAUkFcSb2hsYmZkaWRuaGFkbK4kznug1TpQ
	SCA9sSQ1OzW1ILUIpo+Jg1OqgdHk1jzRbFGNVz0zri1YVpR9qcXgnAP3eUm133GPrlSfXZRd
	EbZ736oe2/vs79Z62RyQWcdlolhf/YWn7lL18mflV8y2uSnnFSxQ2BAVo/x+K7P1bInl+s0t
	C9dpvbN79Zfnx5SaBxsOPMwIPiXr/O8G4+INpYvfnV4kYztV+Krwa9kt3ELvvmkpsRRnJBpq
	MRcVJwIAYv8jQ8kCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulation_constraints structure includes specific field to support
suspend state for global PMIC SUSPEND/HIBERNATE mode. This patch add support
for parsing regulator_state for suspend state.

Cc: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/regulator/of_regulator.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 7a51814..b375ffe 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -19,12 +19,19 @@
 
 #include "internal.h"
 
+const char *const regulator_states[PM_SUSPEND_MAX + 1] = {
+	[PM_SUSPEND_MEM]	= "regulator-state-mem",
+	[PM_SUSPEND_MAX]	= "regulator-state-disk",
+};
+
 static void of_get_regulation_constraints(struct device_node *np,
 					struct regulator_init_data **init_data)
 {
 	const __be32 *min_uV, *max_uV;
 	struct regulation_constraints *constraints = &(*init_data)->constraints;
-	int ret;
+	struct regulator_state *suspend_state;
+	struct device_node *suspend_np;
+	int ret, i;
 	u32 pval;
 
 	constraints->name = of_get_property(np, "regulator-name", NULL);
@@ -73,6 +80,36 @@ static void of_get_regulation_constraints(struct device_node *np,
 	ret = of_property_read_u32(np, "regulator-enable-ramp-delay", &pval);
 	if (!ret)
 		constraints->enable_time = pval;
+
+	for (i = 0; i < ARRAY_SIZE(regulator_states); i++) {
+		switch (i) {
+		case PM_SUSPEND_MEM:
+			suspend_state = &constraints->state_mem;
+			break;
+		case PM_SUSPEND_MAX:
+			suspend_state = &constraints->state_disk;
+			break;
+		case PM_SUSPEND_ON:
+		case PM_SUSPEND_FREEZE:
+		case PM_SUSPEND_STANDBY:
+		default:
+			continue;
+		};
+
+		suspend_np = of_get_child_by_name(np, regulator_states[i]);
+		if (!suspend_np || !suspend_state)
+			continue;
+
+		if (of_property_read_bool(suspend_np,
+					"regulator-on-in-suspend"))
+			suspend_state->enabled = true;
+		else if (of_property_read_bool(suspend_np,
+					"regulator-off-in-suspend"))
+			suspend_state->disabled = true;
+
+		suspend_state = NULL;
+		suspend_np = NULL;
+	}
 }
 
 /**
-- 
1.8.0

