Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbaHNAks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 20:40:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:55000 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaHNAkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 20:40:18 -0400
X-AuditID: cbfee68e-b7fab6d000004d4a-8b-53ec057093b5
From: Chanwoo Choi <cw00.choi@samsung.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        kyungmin.park@samsung.com, k.kozlowski@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3 1/2] regulator: of: Add support for parsing regulator_state
 for suspend state
Date: Thu, 14 Aug 2014 09:40:13 +0900
Message-id: <1407976814-21882-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1407976814-21882-1-git-send-email-cw00.choi@samsung.com>
References: <1407976814-21882-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42JZI2JSolvA+ibYYMJyJYupD5+wWVz/8pzV
	Yv6Rc6wWB/7sYLR4/cLQ4mzTG3aLb1c6mCwu75rDZtG69wi7A6fHzll32T02repk87hzbQ+b
	R9+WVYwenzfJBbBGcdmkpOZklqUW6dslcGVsWvKcteCBVMWh/WfYGhj/iHYxcnJICJhIrNy0
	lwnCFpO4cG89WxcjF4eQwFJGiQt7l7LBFL2e/48ZIrGIUeLx3m9QVU1MEneerWUFqWIT0JLY
	/+IGWIcI0KjbczrBOpgF7jFKfFn9kAUkISyQKHH++kOwIhYBVYmuy1vZQWxeAVeJH8dnsEOs
	k5P4sOcRmM0p4CZx6/5DsPuEgGrOtT1hBxkqIbCKXWLT34vsEIMEJL5NPgS0gAMoISux6QAz
	xBxJiYMrbrBMYBRewMiwilE0tSC5oDgpvchIrzgxt7g0L10vOT93EyMw+E//e9a3g/HmAetD
	jMlA4yYyS4km5wOjJ68k3tDYzMjC1MTU2Mjc0ow0YSVx3kUPk4KEBNITS1KzU1MLUovii0pz
	UosPMTJxcEo1MK4K1FSayyqx7f6y7ebbPgQvlZuu2XCu6Y3qztzV3uX/WSQ2ztx97Yzry9ub
	ve7MOq649q8DV5yshUPeatmHay12P95/z/kSe3ZcyrdJHT09SyevlvUNEvKex///ifKer6XH
	V+S8+/7G/Nime6dEp53YF+d+/MrblmupcxVcXm/ZO+/O8Sgx61VrlViKMxINtZiLihMBfvOq
	zpQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t9jAd0C1jfBBl8OS1pMffiEzeL6l+es
	FvOPnGO1OPBnB6PF6xeGFmeb3rBbfLvSwWRxedccNovWvUfYHTg9ds66y+6xaVUnm8eda3vY
	PPq2rGL0+LxJLoA1qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxqYlz1kL
	HkhVHNp/hq2B8Y9oFyMnh4SAicTr+f+YIWwxiQv31rN1MXJxCAksYpR4vPcblNPEJHHn2VpW
	kCo2AS2J/S9usIHYIkAdt+d0MoMUMQvcY5T4svohC0hCWCBR4vz1h2BFLAKqEl2Xt7KD2LwC
	rhI/js9gh1gnJ/FhzyMwm1PATeLW/YdMILYQUM25tifsExh5FzAyrGIUTS1ILihOSs810itO
	zC0uzUvXS87P3cQIjq1n0jsYVzVYHGIU4GBU4uH1iHodLMSaWFZcmXuIUYKDWUmEV5n5TbAQ
	b0piZVVqUX58UWlOavEhRlOgqyYyS4km5wPjPq8k3tDYxMzI0sjc0MLI2FxJnPdgq3WgkEB6
	YklqdmpqQWoRTB8TB6dUA2NL8kL2v3uOhvgH7Z55bKHPlEojdQOGSNYLO29MqmGdcuJjx6un
	ppuSb7hqru73/rLD+ubsF/NC81a8OCBrm7f10ZGVi9010nRCjkmrzr5lanZ/DmOGfTbfR9W4
	gu063+LfB/N0s+fueyNqd8G6IX/eyVVH74juucgVfZTpn/engFLbJYfWSW9WYinOSDTUYi4q
	TgQA0HVx+sMCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulation_constraints structure includes specific field to support
suspend state for global PMIC STANDBY/HIBERNATE mode. This patch add support
for parsing regulator_state for suspend state.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/regulator/of_regulator.c | 79 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 77 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index ee5e67b..24d5952 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -16,12 +16,20 @@
 #include <linux/regulator/machine.h>
 #include <linux/regulator/of_regulator.h>
 
+const char *const regulator_states[PM_SUSPEND_MAX + 1] = {
+	[PM_SUSPEND_STANDBY]	= "regulator-state-standby",
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
@@ -70,6 +78,73 @@ static void of_get_regulation_constraints(struct device_node *np,
 	ret = of_property_read_u32(np, "regulator-enable-ramp-delay", &pval);
 	if (!ret)
 		constraints->enable_time = pval;
+
+	ret = of_property_read_u32(np, "regulator-initial-state", &pval);
+	if (!ret) {
+		switch (pval) {
+		case PM_SUSPEND_STANDBY:
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
+		case PM_SUSPEND_STANDBY:
+			suspend_state = &constraints->state_standby;
+			break;
+		case PM_SUSPEND_MEM:
+			suspend_state = &constraints->state_mem;
+			break;
+		case PM_SUSPEND_MAX:
+			suspend_state = &constraints->state_disk;
+			break;
+		case PM_SUSPEND_ON:
+		case PM_SUSPEND_FREEZE:
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
+		ret = of_property_read_u32(suspend_np, "regulator-mode", &pval);
+		if (!ret) {
+			u32 regulator_mode = REGULATOR_MODE_FAST
+					| REGULATOR_MODE_NORMAL
+					| REGULATOR_MODE_IDLE
+					| REGULATOR_MODE_STANDBY;
+			if (pval <= regulator_mode)
+				suspend_state->mode = pval;
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

