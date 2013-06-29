Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab3GHM74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 08:59:56 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64406 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab3GHM7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 08:59:50 -0400
X-AuditID: cbfee68e-b7f276d000002279-bd-51dab7c47f04
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: sbkim73@samsung.com, broonie@kernel.org, lgirdwood@gmail.com,
        sameo@linux.intel.com, rob.herring@calxeda.com,
        grant.likely@linaro.org, sachin.kamat@linaro.org,
        yadi.brar01@gmail.com, Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [v2 PATCH 1/6] regulator: core: Add support for disabling ramp delay
Date: Sat, 29 Jun 2013 18:21:15 +0530
Message-id: <1372510280-31931-2-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1372510280-31931-1-git-send-email-yadi.brar@samsung.com>
References: <1372510280-31931-1-git-send-email-yadi.brar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42JZI2JSrXtk+61Ag5t/bCymPnzCZnHgzw5G
	i29XOpgsLu+aw2ZxeMUBJouTf3oZLU53s1pcXPGFyWLu70ZWiznT3zE5cHks+HyF3WPnrLvs
	HptWdbJ53Lm2h81j3slAj74tqxg9Pm+SC2CP4rJJSc3JLEst0rdL4Mr4O8G7YIZixby/95gb
	GB9LdzFyckgImEhMmrefEcIWk7hwbz1bFyMXh5DAUkaJeyv7WWCKDky6DGYLCSxilFgyvQCi
	qI1JYv2P8+xdjBwcbAJGEq+O2YHUiAgoSGzufcYKUsMs8JZRYunSG2DNwgK+Ek8eNrGC1LMI
	qEpMbpcFCfMKuEpcm3OaHWKXgkTrskNgNqeAm0TX5OtMEHtdJT7uaWcCmSkhcIhdYn7veVaQ
	BIuAgMS3yYdYQGZKCMhKbDrADDFHUuLgihssExiFFzAyrGIUTS1ILihOSi8y0itOzC0uzUvX
	S87P3cQIjIjT/5717WC8ecD6EGMy0LiJzFKiyfnAiMoriTc0NjOyMDUxNTYytzQjTVhJnFet
	xTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6N1eaRrxb4Nf7+fu8QrUNjzrOvHduN78UYc
	WalPZ8rHfdfsasndPHex1p8XwnmPX53WnRv40WmL5GbpGovWpQUNwm9OsDIE7Tpy7W/J+j/3
	yiMvSDCUHJAu2/jkzfX8Qy8/aVUq+xb9PPFx2ZJEr9bA2W9Y3cI7fhydLtz85N3+toe6O/gr
	LcyUWIozEg21mIuKEwEPo91fngIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t9jAd0j228FGnw4YWQx9eETNosDf3Yw
	Wny70sFkcXnXHDaLwysOMFmc/NPLaHG6m9Xi4oovTBZzfzeyWsyZ/o7Jgctjwecr7B47Z91l
	99i0qpPN4861PWwe804GevRtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7yp
	mYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QeUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC
	4HqMDNBAwhrGjL8TvAtmKFbM+3uPuYHxsXQXIyeHhICJxIFJl1kgbDGJC/fWs4HYQgKLGCWW
	TC/oYuQCstuYJNb/OM/excjBwSZgJPHqmB1IjYiAgsTm3mesIDXMAm8ZJZYuvQE2SFjAV+LJ
	wyZWkHoWAVWJye2yIGFeAVeJa3NOs0PsUpBoXXYIzOYUcJPomnydCWKvq8THPe1MExh5FzAy
	rGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjrdnUjsYVzZYHGIU4GBU4uGVOH0zUIg1say4
	MvcQowQHs5IIrzjrrUAh3pTEyqrUovz4otKc1OJDjMlAR01klhJNzgemgrySeENjE3NTY1NL
	EwsTM0vShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYORULvcNf7Pw++TKJ+2rr980iTmz
	TMOfy+D13J3uPXYztvm9ODn7Vl/2hdRmef22R6cMNvasX/nC1VlOsivq5bwje6u+uh2I+KY1
	IU72c9tNnoX7DRlWL0m36G38deG2da6t+Nzl2dwBi7ZYT3D57iXUqvn5TftUDYsdM8Ozaro9
	0w4aumueeqLEUpyRaKjFXFScCACXHqDR+wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some hardwares support disabling ramp delay, so adding ramp_disable flag to
constraints. It will be used to figure out whether ramp_delay in constraints
is explicitly set to zero or its unintialized (zero by default).
And we don't need to call set_voltage_time_sel() for regulators for whom ramp
delay is disabled in constraints.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 .../devicetree/bindings/regulator/regulator.txt    |    2 ++
 drivers/regulator/core.c                           |    6 ++++--
 drivers/regulator/of_regulator.c                   |   12 +++++++++---
 include/linux/regulator/machine.h                  |    1 +
 4 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
index 48a3b8e..2bd8f09 100644
--- a/Documentation/devicetree/bindings/regulator/regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/regulator.txt
@@ -12,6 +12,8 @@ Optional properties:
 - regulator-allow-bypass: allow the regulator to go into bypass mode
 - <name>-supply: phandle to the parent supply/regulator node
 - regulator-ramp-delay: ramp delay for regulator(in uV/uS)
+  For hardwares which support disabling ramp rate, it should be explicitly
+  intialised to zero (regulator-ramp-delay = <0>) for disabling ramp delay.
 
 Deprecated properties:
 - regulator-compatible: If a regulator chip contains multiple
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 288c75a..6e6371c 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -984,7 +984,8 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 		}
 	}
 
-	if (rdev->constraints->ramp_delay && ops->set_ramp_delay) {
+	if ((rdev->constraints->ramp_delay || rdev->constraints->ramp_disable)
+		&& ops->set_ramp_delay) {
 		ret = ops->set_ramp_delay(rdev, rdev->constraints->ramp_delay);
 		if (ret < 0) {
 			rdev_err(rdev, "failed to set ramp_delay\n");
@@ -2438,7 +2439,8 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 	}
 
 	/* Call set_voltage_time_sel if successfully obtained old_selector */
-	if (ret == 0 && _regulator_is_enabled(rdev) && old_selector >= 0 &&
+	if (ret == 0 && !rdev->constraints->ramp_disable &&
+	    _regulator_is_enabled(rdev) && old_selector >= 0 &&
 	    old_selector != selector && rdev->desc->ops->set_voltage_time_sel) {
 
 		delay = rdev->desc->ops->set_voltage_time_sel(rdev,
diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index f3c8f8f..7827384 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -21,6 +21,7 @@ static void of_get_regulation_constraints(struct device_node *np,
 {
 	const __be32 *min_uV, *max_uV, *uV_offset;
 	const __be32 *min_uA, *max_uA, *ramp_delay;
+	struct property *prop;
 	struct regulation_constraints *constraints = &(*init_data)->constraints;
 
 	constraints->name = of_get_property(np, "regulator-name", NULL);
@@ -64,9 +65,14 @@ static void of_get_regulation_constraints(struct device_node *np,
 	if (of_property_read_bool(np, "regulator-allow-bypass"))
 		constraints->valid_ops_mask |= REGULATOR_CHANGE_BYPASS;
 
-	ramp_delay = of_get_property(np, "regulator-ramp-delay", NULL);
-	if (ramp_delay)
-		constraints->ramp_delay = be32_to_cpu(*ramp_delay);
+	prop = of_find_property(np, "regulator-ramp-delay", NULL);
+	if (prop && prop->value) {
+		ramp_delay = prop->value;
+		if (*ramp_delay)
+			constraints->ramp_delay = be32_to_cpu(*ramp_delay);
+		else
+			constraints->ramp_disable = true;
+	}
 }
 
 /**
diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index 36adbc8..999b20c 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -134,6 +134,7 @@ struct regulation_constraints {
 	unsigned always_on:1;	/* regulator never off when system is on */
 	unsigned boot_on:1;	/* bootloader/firmware enabled regulator */
 	unsigned apply_uV:1;	/* apply uV constraint if min == max */
+	unsigned ramp_disable:1; /* disable ramp delay */
 };
 
 /**
-- 
1.7.0.4

