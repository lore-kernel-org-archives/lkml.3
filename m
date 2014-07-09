Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbaGIEsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 00:48:45 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64243 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaGIEsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 00:48:24 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-3e-53bcc995a56e
From: Chanwoo Choi <cw00.choi@samsung.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        geunsik.lim@samsung.com, kyungmin.park@samsung.com,
        k.kozlowski@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [RESEND PATCHv2 1/2] regulator: of: Add support for parsing
 regulator_state for suspend state
Date: Wed, 09 Jul 2014 13:48:10 +0900
Message-id: <1404881291-7949-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1404881291-7949-1-git-send-email-cw00.choi@samsung.com>
References: <1404881291-7949-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42JZI2JSrDv15J5gg3XftSymPnzCZnH9y3NW
	i/lHzrFa/JnQymZx4M8ORovXLwwtzja9Ybf4dqWDyeLyrjlsFq17j7A7cHnsnHWX3WPTqk42
	jzvX9rB59G1ZxejxeZNcAGsUl01Kak5mWWqRvl0CV8aZmyuZCqZKVRy7e5ixgfGkaBcjJ4eE
	gInErH1PWCFsMYkL99azgdhCAksZJRZfiYKpObBpJ3sXIxdQfDqjxPnLT5ggnCYmiZn/ILrZ
	BLQk9r+4AdYtAjTp9pxOZpAiZoHvjBJvnh5jB0kIC2RI9LXdZ+xi5OBgEVCVOL20AiTMK+Ai
	sWjuPKgr5CQ+7HkEVs4p4Cqx/OYTdoiLXCQOHLwPNlNCYBO7xIv3P1lAEiwCAhLfJh9iAZkp
	ISArsekAM8QcSYmDK26wTGAUXsDIsIpRNLUguaA4Kb3ISK84Mbe4NC9dLzk/dxMjMAZO/3vW
	t4Px5gHrQ4zJQOMmMkuJJucDYyivJN7Q2MzIwtTE1NjI3NKMNGElcd5FD5OChATSE0tSs1NT
	C1KL4otKc1KLDzEycXBKNTAG3V6jGatQk8mhLZ/6Qu/ORfZF8Z/zbPdUyLiyBc599kKvVkxL
	R2ZNU1CcQ/C8XR3Zi39v2/YyMeOZqaaZlvinhW9P2M5bnvie7/3Z5mt8WvzbJro5X1b68ubo
	g70rhaKcFW2e18Y/+vJjrvS8XdNPSMZe8DFfVGW8V3v5Ef+0MzoJu30dL5UosRRnJBpqMRcV
	JwIASMUnI5cCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t9jQd2pJ/cEG3ybpmQx9eETNovrX56z
	Wsw/co7V4s+EVjaLA392MFq8fmFocbbpDbvFtysdTBaXd81hs2jde4Tdgctj56y77B6bVnWy
	edy5tofNo2/LKkaPz5vkAlijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU
	8hJzU22VXHwCdN0yc4CuUlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBm
	nLm5kqlgqlTFsbuHGRsYT4p2MXJySAiYSBzYtJMdwhaTuHBvPVsXIxeHkMB0Ronzl58wQThN
	TBIz/z1hBaliE9CS2P/iBhuILQLUcXtOJzNIEbPAd0aJN0+PgY0SFsiQ6Gu7z9jFyMHBIqAq
	cXppBUiYV8BFYtHceawQ2+QkPux5BFbOKeAqsfzmEzBbCKjmwMH7zBMYeRcwMqxiFE0tSC4o
	TkrPNdQrTswtLs1L10vOz93ECI6xZ1I7GFc2WBxiFOBgVOLhVeDZEyzEmlhWXJl7iFGCg1lJ
	hPebG1CINyWxsiq1KD++qDQntfgQoynQUROZpUST84Hxn1cSb2hsYmZkaWRuaGFkbK4kznug
	1TpQSCA9sSQ1OzW1ILUIpo+Jg1OqgXHyo38rX885cOWIR9enGBWHtfYLJ+ybvfh1wMpjaUf4
	D/qedU/f+82UwX6il0qfefeOVWsEZ20UmefHN9u/So9l+dG4K19ZI+5sVAzgC9TKd5o32eZA
	u+7MBfcOdhceYi887OuusYg572THD8feO78z+uUuS8pNTn22wdinRntvp8SJebUTv/QrsRRn
	JBpqMRcVJwIA4okFEMcCAAA=
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
 drivers/regulator/of_regulator.c | 76 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 74 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index ee5e67b..cf280ab 100644
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
@@ -70,6 +78,70 @@ static void of_get_regulation_constraints(struct device_node *np,
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
+		if (!ret) {
+			u32 regulator_mode = REGULATOR_MODE_FAST
+					| REGULATOR_MODE_NORMAL
+					| REGULATOR_MODE_IDLE
+					| REGULATOR_MODE_STANDBY;
+			if (pval <= regulator_mode)
+				suspend_state->mode = pval;
+		}
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

