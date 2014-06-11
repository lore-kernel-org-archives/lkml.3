Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbaFKAlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 20:41:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58959 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbaFKAlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 20:41:35 -0400
X-AuditID: cbfee68f-b7fef6d000003970-16-5397a5bc4436
From: Chanwoo Choi <cw00.choi@samsung.com>
To: broonie@kernel.org, lgirdwood@gmail.com, grant.likely@linaro.org,
        robh+dt@kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 1/2] regulator: of: Add support for parsing regulator_state
 for suspend state
Date: Wed, 11 Jun 2014 09:41:22 +0900
Message-id: <1402447283-11356-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1402447283-11356-1-git-send-email-cw00.choi@samsung.com>
References: <1402447283-11356-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkUHfP0unBBrtuW1lMffiEzeL6l+es
	FvOPnGO1OPBnB6PF2aY37BbfrnQwWVzeNYfN4nbjCjaL1r1H2B04PXbOusvusWlVJ5vHnWt7
	2Dz6tqxi9Pi8SS6ANYrLJiU1J7MstUjfLoEr48zNlUwFU6Uqjt09zNjAeFK0i5GDQ0LAROLr
	HOEuRk4gU0ziwr31bCC2kMBSRon3+xwh4iYSs7bcZupi5AKKT2eUuH3hPgtEUROTxJpt1iA2
	m4CWxP4XN9hAZooIREms7QCrZxaYzSjRcr6PGaRGWCBRYsGps+wgNouAqsSZrQcZQWxeAVeJ
	j8enM0Isk5P4sOcRWA2ngJvEjemboA5ylVh8qZ0NZKiEwCZ2iWPvX7FADBKQ+Db5EAvEM7IS
	mw4wQ8yRlDi44gbLBEbhBYwMqxhFUwuSC4qT0ouM9YoTc4tL89L1kvNzNzECw/70v2f9Oxjv
	HrA+xJgMNG4is5Rocj4wbvJK4g2NzYwsTE1MjY3MLc1IE1YS573/MClISCA9sSQ1OzW1ILUo
	vqg0J7X4ECMTB6dUA+P8QJ2C6+li7oarhFeGWAl1mjsZLK7bn3YmpELyWP7iV7ZrhJ0Kbe9I
	MMhtZJkhkn56KvuGKztnhP8Ucr1+eElal9f1htc5y5ak1ul/iw4v5s2MMw88uPWLUVeq6Ufd
	simRKcrKRzb13mjPcX5gsup5u3Zd8IReRr7XfxKn3Lq1Q1Qr2+lNnhJLcUaioRZzUXEiAJl1
	3naRAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t9jQd09S6cHG7y+YGIx9eETNovrX56z
	Wsw/co7V4sCfHYwWZ5vesFt8u9LBZHF51xw2i9uNK9gsWvceYXfg9Ng56y67x6ZVnWwed67t
	YfPo27KK0ePzJrkA1qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxU
	WyUXnwBdt8wcoIuUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBlnbq5k
	KpgqVXHs7mHGBsaTol2MnBwSAiYSs7bcZoKwxSQu3FvP1sXIxSEkMJ1R4vaF+ywgCSGBJiaJ
	NdusQWw2AS2J/S9uABVxcIgIREms7WACqWcWmM0o0XK+jxmkRlggUWLBqbPsIDaLgKrEma0H
	GUFsXgFXiY/HpzNCLJOT+LDnEVgNp4CbxI3pm9ggdrlKLL7UzjaBkXcBI8MqRtHUguSC4qT0
	XEO94sTc4tK8dL3k/NxNjODIeia1g3Flg8UhRgEORiUe3gMS04OFWBPLiitzDzFKcDArifDa
	pAGFeFMSK6tSi/Lji0pzUosPMSYDXTWRWUo0OR8Y9Xkl8YbGJmZGlkbmhhZGxuakCSuJ8x5o
	tQ4UEkhPLEnNTk0tSC2C2cLEwSnVwJiZezqtTqhXqybb984x143bzs9hvvs1XnOG1oFHb+b4
	N137t+7l0Y1PVt24YSDjovkxv7lhgmHu/BlygjNeaW9IneM8N+ZY7dW3arMyX9suY5tWrlmu
	OoHtXcAnk54zF+arVgvPWR8rNO+26ketlNlSC05f7b/ldN/UzOXBk9lzRXqtSwxtP7ErsRRn
	JBpqMRcVJwIACsRs6/ACAAA=
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

