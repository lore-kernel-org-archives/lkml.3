Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbaFIK3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 06:29:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63299 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769AbaFIK3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 06:29:47 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-94-53958c99e6fd
From: Chanwoo Choi <cw00.choi@samsung.com>
To: broonie@kernel.org, lgirdwood@gmail.com, grant.likely@linaro.org,
        robh+dt@kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 1/2] regulator: of: Add support for parsing regulator_state for
 suspend state
Date: Mon, 09 Jun 2014 19:29:39 +0900
Message-id: <1402309780-8118-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1402309780-8118-1-git-send-email-cw00.choi@samsung.com>
References: <1402309780-8118-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42JZI2JSojuzZ2qwQf8MYYupD5+wWVz/8pzV
	Yv6Rc6wWB/7sYLQ42/SG3eLblQ4mi8u75rBZ3G5cwWbRuvcIuwOnx85Zd9k9Nq3qZPO4c20P
	m0ffllWMHp83yQWwRnHZpKTmZJalFunbJXBltP7/ylZwVbzi6/eXrA2Mj4S7GDk5JARMJPZf
	nsoCYYtJXLi3nq2LkYtDSGApo0RD5wNWmKIrD0+wQiSmM0ocWvwaymlikvh58DtYO5uAlsT+
	FzeA2jk4RASiJNZ2MIHUMAvMZpRoOd/HDFIjLBAvMf1hJ5jNIqAq8f/xHrB6XgEXidZ+bYhl
	chIf9jxiB7E5BVwlVp/cxwRiCwGVfFu8BGyvhMA6dom3v54yQcwRkPg2+RALyBwJAVmJTQeY
	IeZIShxccYNlAqPwAkaGVYyiqQXJBcVJ6UWGesWJucWleel6yfm5mxiBoX/637PeHYy3D1gf
	YkwGGjeRWUo0OR8YO3kl8YbGZkYWpiamxkbmlmakCSuJ8yY9TAoSEkhPLEnNTk0tSC2KLyrN
	SS0+xMjEwSnVwFjnvZpngv/Tym8HNCxNtskFT1soWPznSdXfPec7BW0mXP8kIJfZmrDh6h9H
	oTjphMIX768/3VT2cfqlNYcbW91XRHbusl5ry2gqkS2y+h9HvnJuQfISDblSFVarnu6OM4lm
	jRZurxe9cTqn8+XGZoUtxtZFFfVOn785rJNzuS62+vq1UzuX6CmxFGckGmoxFxUnAgBKMtY0
	kwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t9jQd2ZPVODDe5M5raY+vAJm8X1L89Z
	LeYfOcdqceDPDkaLs01v2C2+Xelgsri8aw6bxe3GFWwWrXuPsDtweuycdZfdY9OqTjaPO9f2
	sHn0bVnF6PF5k1wAa1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6q
	rZKLT4CuW2YO0EVKCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxozW/1/Z
	Cq6KV3z9/pK1gfGRcBcjJ4eEgInElYcnWCFsMYkL99azdTFycQgJTGeUOLT4NSuE08Qk8fPg
	dxaQKjYBLYn9L24AVXFwiAhESaztYAKpYRaYzSjRcr6PGaRGWCBeYvrDTjCbRUBV4v/jPWD1
	vAIuEq392hDL5CQ+7HnEDmJzCrhKrD65jwnEFgIq+bZ4CesERt4FjAyrGEVTC5ILipPSc430
	ihNzi0vz0vWS83M3MYIj65n0DsZVDRaHGAU4GJV4eCN+TwkWYk0sK67MPcQowcGsJMLrkzM1
	WIg3JbGyKrUoP76oNCe1+BBjMtBRE5mlRJPzgVGfVxJvaGxiZmRpZG5oYWRsTpqwkjjvwVbr
	QCGB9MSS1OzU1ILUIpgtTBycUg2MNaIawawfnqbxMBa7ras7fK/Effdt/Re1otf3RrTr/prr
	e+aRa9r1k7fUNj1PKc/mT5cI6pZrObPWzek3D+8ic6v2prAFd3Us+3K3X32a3ODHuesJ23Lf
	N6rf5qs66p+J+Oc8qytw4qN4Pe501yh+HS3xCxfS1U5efeOl19LFeGXHM4bqTyeVWIozEg21
	mIuKEwGqwh+X8AIAAA==
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
---
 drivers/regulator/of_regulator.c | 61 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 59 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index ee5e67b..f8925a2 100644
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
+	const __be32 *min_uV, *max_uV, *uV_offset, *suspend_uV;
 	struct regulation_constraints *constraints = &(*init_data)->constraints;
-	int ret;
+	struct regulator_state *suspend_state;
+	struct device_node *suspend_np;
+	int ret, i;
 	u32 pval;
 
 	constraints->name = of_get_property(np, "regulator-name", NULL);
@@ -70,6 +78,55 @@ static void of_get_regulation_constraints(struct device_node *np,
 	ret = of_property_read_u32(np, "regulator-enable-ramp-delay", &pval);
 	if (!ret)
 		constraints->enable_time = pval;
+
+	ret = of_property_read_u32(np, "regulator-initial-state", &pval);
+	if (!ret)
+		constraints->initial_state = pval;
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
+		suspend_uV = of_get_property(suspend_np, "regulator-volt", NULL);
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
+		if (!ret)
+			suspend_state->mode = pval;
+
+		if (of_property_read_bool(suspend_np, "regulator-on-in-suspend"))
+			suspend_state->enabled = true;
+
+		if (of_property_read_bool(suspend_np, "regulator-off-in-suspend"))
+			suspend_state->disabled = true;
+
+		suspend_state = NULL;
+		suspend_np = NULL;
+	}
 }
 
 /**
-- 
1.8.0

