Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaHRG1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 02:27:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26492 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaHRG1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 02:27:14 -0400
X-AuditID: cbfee68f-b7fa26d0000039a0-64-53f19cbf8892
From: Chanwoo Choi <cw00.choi@samsung.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        kyungmin.park@samsung.com, k.kozlowski@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv4 1/2] regulator: of: Add support for parsing regulator_state
 for suspend state
Date: Mon, 18 Aug 2014 15:27:02 +0900
Message-id: <1408343223-4043-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1408343223-4043-1-git-send-email-cw00.choi@samsung.com>
References: <1408343223-4043-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkQHf/nI/BBr2tvBZTHz5hs7j+5Tmr
	xfwj51gtDvzZwWjx+oWhxdmmN+wW3650MFlc3jWHzaJ17xF2B06PnbPusntsWtXJ5nHn2h42
	j74tqxg9Pm+SC2CN4rJJSc3JLEst0rdL4Mr4tP0Ca8ES8Yq57T3sDYyzhLsYOTkkBEwkVm3f
	xAphi0lcuLeerYuRi0NIYCmjxIv36xhhiq7s62SFSExnlHj8pB2sQ0igiUmi9RGYzSagJbH/
	xQ02EFsEaNLtOZ3MIA3MAvcYJb6sfsjSxcjBISyQKHHqIR+IySKgKnHncxVIOa+Ai8SkdzeZ
	IHbJSXzY84gdpIRTwFViQp8IxCYXiUUNB1lAJkoIrGKXeLxzCwtIgkVAQOLb5ENg0yUEZCU2
	HWCGGCMpcXDFDZYJjMILGBlWMYqmFiQXFCelFxnrFSfmFpfmpesl5+duYgQG/el/z/p3MN49
	YH2IMRlo3ERmKdHkfGDU5JXEGxqbGVmYmpgaG5lbmpEmrCTOe/9hUpCQQHpiSWp2ampBalF8
	UWlOavEhRiYOTqkGxim33/+yemKw4KRg4YppUbZsG4PTcnkC/WX9Exa8UDjmfMDGrXqqw9VV
	u7m6BH7Uat9VW50qqjl1/le7ZulUnR3dan3fXKbIqAf3PHh9lG/Ftv0z2Xd3dl9zXZB4fX47
	7xtV/9XKK2MX6O4V6f4QOknIouavcMH1YkbLx3YSWo1TNQKajWwWKLEUZyQaajEXFScCAFfM
	pbOQAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t9jQd39cz4GGyzrYbWY+vAJm8X1L89Z
	LeYfOcdqceDPDkaL1y8MLc42vWG3+Halg8ni8q45bBate4+wO3B67Jx1l91j06pONo871/aw
	efRtWcXo8XmTXABrVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqt
	kotPgK5bZg7QQUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjE/bL7AW
	LBGvmNvew97AOEu4i5GTQ0LAROLKvk5WCFtM4sK99WxdjFwcQgLTGSUeP2kHSwgJNDFJtD4C
	s9kEtCT2v7jBBmKLADXcntPJDNLALHCPUeLL6ocsXYwcHMICiRKnHvKBmCwCqhJ3PleBlPMK
	uEhMeneTCWKXnMSHPY/YQUo4BVwlJvSJQGxykVjUcJBlAiPvAkaGVYyiqQXJBcVJ6blGesWJ
	ucWleel6yfm5mxjBMfVMegfjqgaLQ4wCHIxKPLwerz8EC7EmlhVX5h5ilOBgVhLhXdf0MViI
	NyWxsiq1KD++qDQntfgQoynQTROZpUST84HxnlcSb2hsYmZkaWRuaGFkbK4kznuw1TpQSCA9
	sSQ1OzW1ILUIpo+Jg1OqgZG/QDnDIfbD+/iEz7/1bBv26X04VRNzMrXT7d6PfV9Ks2bcaFln
	eLnJvvzkuc06jG/nGOsmabPfvOHw+3munc4xRQn2P8kpLfH2KbNEjisvS5jsvLHvp+C13MSP
	7E9V3xfuDufNlBI/+SRp6Qm3vRPDZvU8Zdv/ZnkHq8tNo/pWy88HFpVPm6TEUpyRaKjFXFSc
	CAAaJlLyvwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulation_constraints structure includes specific field to support
suspend state for global PMIC SUSPEND/HIBERNATE mode. This patch add support
for parsing regulator_state for suspend state.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/regulator/of_regulator.c | 65 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 63 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index ee5e67b..5fe5748 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -16,12 +16,19 @@
 #include <linux/regulator/machine.h>
 #include <linux/regulator/of_regulator.h>
 
+const char *const regulator_states[PM_SUSPEND_MAX + 1] = {
+	[PM_SUSPEND_MEM]	= "regulator-state-mem",
+	[PM_SUSPEND_MAX]	= "regulator-state-disk",
+};
+
 static void of_get_regulation_constraints(struct device_node *np,
 					struct regulator_init_data **init_data)
 {
-	const __be32 *min_uV, *max_uV;
+	const __be32 *min_uV, *max_uV, *suspend_uV;
 	struct regulation_constraints *constraints = &(*init_data)->constraints;
-	int ret;
+	struct regulator_state *suspend_state;
+	struct device_node *suspend_np;
+	int ret, i;
 	u32 pval;
 
 	constraints->name = of_get_property(np, "regulator-name", NULL);
@@ -70,6 +77,60 @@ static void of_get_regulation_constraints(struct device_node *np,
 	ret = of_property_read_u32(np, "regulator-enable-ramp-delay", &pval);
 	if (!ret)
 		constraints->enable_time = pval;
+
+	ret = of_property_read_u32(np, "regulator-initial-state", &pval);
+	if (!ret) {
+		switch (pval) {
+		case PM_SUSPEND_MEM:
+		case PM_SUSPEND_MAX:
+			constraints->initial_state = pval;
+			break;
+		default:
+			break;
+		};
+	}
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
+		suspend_uV = of_get_property(suspend_np, "regulator-volt",
+						NULL);
+		if (suspend_uV) {
+			suspend_state->uV = be32_to_cpu(*suspend_uV);
+
+			if (suspend_state->uV < constraints->min_uV)
+				suspend_state->uV = constraints->min_uV;
+			if (suspend_state->uV > constraints->max_uV)
+				suspend_state->uV = constraints->max_uV;
+		}
+
+		if (of_property_read_bool(suspend_np,
+					"regulator-on-in-suspend"))
+			suspend_state->enabled = true;
+
+		if (of_property_read_bool(suspend_np,
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

