Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbaAPGe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 01:34:56 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:9673 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaAPGew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 01:34:52 -0500
X-AuditID: cbfee68e-b7f566d000002344-91-52d77d856991
Date: Thu, 16 Jan 2014 06:34:45 +0000 (GMT)
From: Saurabh Singh <saurabh1.s@samsung.com>
Subject: [PATCH] Parse missing regulator constraints from device tree blob
To: lgirdwood@gmail.com, broonie@kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, celinux-dev@tree.celinuxforum.org
Cc: srevatsa@samsung.com, bp.praveen@samsung.com
Reply-to: saurabh1.s@samsung.com
MIME-version: 1.0
X-MTR: 20140116062836384@saurabh1.s
Msgkey: 20140116062836384@saurabh1.s
X-EPLocale: en_US.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140116062836384@saurabh1.s
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <23745449.572421389854083634.JavaMail.weblogic@epml20>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42JZI2JSpdtaez3IYON2S4vLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJVx5PBJpoJnGhW/m+6yNTDeUe9i5OQQElCVmL1nCyOILSFgIvHi
	5DYWCFtM4sK99WxdjFxANUsZJXo6fwM5HGBFJz65QcTnM0osWfEJLM4CNOhDBxdIL5uArsTD
	9XfZQcLCAl4S3094gpSLCLxklOhbeYMNpIZZwEbiTMdCNogbFCTOPe9kArF5BQQlTs58AnWD
	ssTi91fYIeIqEiv3/2KFiMtJLJl6mQnC5pWY0f6UBSY+7esaZghbWuL8rA2MML8s/v4YKs4v
	cez2DiaIV3glntwPhhmze/MXNghbQGLqmYNQrRoSf75OgVrFJ7Fm4VsWmDG7Ti1nhum9v2Uu
	E8RbihJTuh+yQ9gGEkcWzWFF9xavgJPEmg9PWCcwKs9CkpqFpH0WknZkNQsYWVYxiqYWJBcU
	J6UXGekVJ+YWl+al6yXn525iBCaF0/+e9e1gvHnA+hBjMjBGJjJLiSbnA5NKXkm8obGZkYWp
	iamxkbmlGWnCSuK8ix4mBQkJpCeWpGanphakFsUXleakFh9iZOLglGpgzJ+1cmdVbPZum02L
	ZzyVvRi9xKvyxoxnjAH6X8R2V5x5dcr32IPPky7d9DR6G1FtyDltA8dHpZPSbvVvOmckyagw
	Zf+oMPfbXaLgVt2/b+bsS73TbUv2CjSq/Jqj2+Entie2Ky/V+UPIIYWYqU5T5MxsZQpZLYK/
	hcb/1nl2TOAbU72LD5OuEktxRqKhFnNRcSIA4fuc1SADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsVy+t/tGbqttdeDDPpn61pc3jWHzYHR4/Mm
	uQDGqDSbjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWhDcyM9IwM9UyM9Q9NYK0MDAyNToJqEtIwj
	h08yFTzTqPjddJetgfGOehcjJ4eQgKrE7D1bGLsYOTgkBEwkTnxyAwlLCIhJXLi3nq2LkQuo
	ZD6jxJIVn9hAaliA6j90cIHUsAnoSjxcf5cdJCws4CXx/YQnSLmIwEtGib6VN9hAapgFbCTO
	dCxkg1ilIHHueScTiM0rIChxcuYTFohdyhKL319hh4irSKzc/4sVIi4nsWTqZSYIm1diRvtT
	Fpj4tK9rmCFsaYnzszYwwty8+PtjqDi/xLHbO5gg3uKVeHI/GGbM7s1f2CBsAYmpZw5CtWpI
	/Pk6BWoVn8SahW9ZYMbsOrWcGab3/pa5TBBvKUpM6X7IDmEbSBxZNIcV3Vu8Ak4Saz48YZ3A
	KDcLSWoWkvZZSNqR1SxgZFnFKJpakFxQnJReYahXnJhbXJqXrpecn7uJEZyani3cwfjlvPUh
	RgEORiUe3h0PrwUJsSaWFVfmHmKU4GBWEuHlML8eJMSbklhZlVqUH19UmpNafIgxGRh/E5ml
	RJPzgWkzryTe0NjE3NTY1MLA0NzcjDRhJXHeuzeTgoQE0hNLUrNTUwtSi2C2MHFwSjUwXmgP
	3yS/reKyfrO+4Bo7Lua3ipzfnmQKPXnAHL1RRJJtQu2l16Z7j9SV6gWGsqwKE1gdNCfBxb1m
	V9K8H7O/+6Z5l1SdOKumFc6vE39Cqn5RmFZcoq7Jh5DyI91Gi8UXZxit9f2cdMs09Gn6MZnD
	00QndPmtk8qdFWWs+VXB+mqkd86reFUlluKMREMt5qLiRACWyxs2kQMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0G6Z1eC015733

This patch adds support for parsing following regulator contraints from device tree blob.
1. valid modes mask (valid_modes_mask)
2. input microvolt(input_uV)
3. initial mode (initial_mode)
4. initial state (initial_state)
5. state mem (state_mem)
6. state disk (state_disk)
7. state standby (state_standby)

This patch is currently against a linux 3.12.6 kernel.

diffstat for this patch is:
 of_regulator.c |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

To apply the patch, in the root of a kernel tree use:
patch -p1 < of_regulator.patch

Please let me know any feedback you have on this patch or the approach used.

Regards,
=====================
Saurabh Singh Sengar
Lead Engineer
Samsung R&D Institute
India
Samsung
=====================
Signed-off-by: Saurabh Singh Sengar <saurabh1.s@samsung.com>

--------------------------------------------------------------------------------
--- linux-3.12.6/drivers/regulator/of_regulator.c.orig	2014-01-08 17:19:43.085903573 +0530
+++ linux-3.12.6/drivers/regulator/of_regulator.c	2014-01-15 20:12:22.146543128 +0530
@@ -16,11 +16,40 @@
 #include <linux/regulator/machine.h>
 #include <linux/regulator/of_regulator.h>
 
+/**
+ * set_regulator_state_constraints - set regulator state for low power system states
+ * @np: device node for the low power regulator state
+ * @regulator_state: regulator_state structure need to be filled
+ */
+static void set_regulator_state_constraints(struct device_node *np,
+		struct regulator_state *regulator_state)
+{
+	const __be32 *uV, *mode;
+
+	uV = of_get_property(np, "regulator-state-uV", NULL);
+	if (uV)
+		regulator_state->uV = be32_to_cpu(*uV);
+
+	mode = of_get_property(np, "regulator-state-mode", NULL);
+	if (mode)
+		regulator_state->mode = be32_to_cpu(*mode);
+
+	if (of_find_property(np, "regulator-state-enabled", NULL))
+		regulator_state->enabled = true;
+
+	if (of_find_property(np, "regulator-state-disabled", NULL))
+		regulator_state->disabled = true;
+}
+
+
 static void of_get_regulation_constraints(struct device_node *np,
 					struct regulator_init_data **init_data)
 {
 	const __be32 *min_uV, *max_uV, *uV_offset;
 	const __be32 *min_uA, *max_uA, *ramp_delay;
+	const __be32  *initial_mode, *initial_state;
+	const __be32  *input_uV, *valid_modes_mask;
+	struct device_node *state;
 	struct property *prop;
 	struct regulation_constraints *constraints = &(*init_data)->constraints;
 
@@ -73,6 +102,40 @@ static void of_get_regulation_constraint
 		else
 			constraints->ramp_disable = true;
 	}
+
+	valid_modes_mask = of_get_property(np,
+			"regulator-valid-modes-mask", NULL);
+	if (valid_modes_mask)
+		constraints->valid_modes_mask = be32_to_cpu(*valid_modes_mask);
+
+	input_uV = of_get_property(np, "regulator-input-microvolt", NULL);
+	if (input_uV)
+		constraints->input_uV = be32_to_cpu(*input_uV);
+
+	initial_mode = of_get_property(np, "regulator-initial-mode", NULL);
+	if (initial_mode)
+		constraints->initial_mode = be32_to_cpu(*initial_mode);
+
+	initial_state = of_get_property(np, "regulator-initial-state", NULL);
+	if (initial_state)
+		constraints->initial_state = be32_to_cpu(*initial_state);
+
+	/* regulator state during low power system states */
+	state = of_find_node_by_name(np, "regulator-state-mem");
+	if (state)
+		set_regulator_state_constraints(state,
+				&constraints->state_mem);
+
+	state = of_find_node_by_name(np, "regulator-state-disk");
+	if (state)
+		set_regulator_state_constraints(state,
+				&constraints->state_disk);
+
+	state = of_find_node_by_name(np, "regulator-state-standby");
+	if (state)
+		set_regulator_state_constraints(state,
+				&constraints->state_standby);
+
 }
 
 /**ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
