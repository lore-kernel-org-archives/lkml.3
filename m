Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749Ab3EGNJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:09:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59501 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758306Ab3EGNJZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:09:25 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "broonie@kernel.org" <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] regulator: support operating mode in the device tree
 structure
Thread-Topic: [PATCH 1/2] regulator: support operating mode in the device
 tree structure
Thread-Index: Ac5LJBJM/oddlFLaRlaDBPM6ywYW8w==
Date: Tue, 7 May 2013 13:09:14 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E5C95D@DQHE06.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For better power efficiency, regulator subsystem provides operating mode.
(fast, normal, idle and standby)
The operating mode is selective by a regulator consumer.

With this patch, regulator operating mode can be set in the DT structure.
If any operating mode is configured, then 'valid_ops_mask' should be set with
REGULATOR_CHANGE_MODE.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 .../devicetree/bindings/regulator/regulator.txt    |    4 ++++
 drivers/regulator/of_regulator.c                   |   13 +++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
index ecfc6cc..2b89616 100644
--- a/Documentation/devicetree/bindings/regulator/regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/regulator.txt
@@ -11,6 +11,10 @@ Optional properties:
 - regulator-boot-on: bootloader/firmware enabled regulator
 - <name>-supply: phandle to the parent supply/regulator node
 - regulator-ramp-delay: ramp delay for regulator(in uV/uS)
+- regulator-mode-fast: fast operating mode
+- regulator-mode-normal: normal operating mode
+- regulator-mode-idle: idle operating mode
+- regulator-mode-standby: standby operating mode
 
 Deprecated properties:
 - regulator-compatible: If a regulator chip contains multiple
diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 66ca769..aebe9a4 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -64,6 +64,19 @@ static void of_get_regulation_constraints(struct device_node *np,
 	ramp_delay = of_get_property(np, "regulator-ramp-delay", NULL);
 	if (ramp_delay)
 		constraints->ramp_delay = be32_to_cpu(*ramp_delay);
+
+	/* Operation mode configuration */
+	if (of_find_property(np, "regulator-mode-fast", NULL))
+		constraints->valid_modes_mask |= REGULATOR_MODE_FAST;
+	if (of_find_property(np, "regulator-mode-normal", NULL))
+		constraints->valid_modes_mask |= REGULATOR_MODE_NORMAL;
+	if (of_find_property(np, "regulator-mode-idle", NULL))
+		constraints->valid_modes_mask |= REGULATOR_MODE_IDLE;
+	if (of_find_property(np, "regulator-mode-standby", NULL))
+		constraints->valid_modes_mask |= REGULATOR_MODE_STANDBY;
+
+	if (constraints->valid_modes_mask)
+		constraints->valid_ops_mask |= REGULATOR_CHANGE_MODE;
 }
 
 /**
-- 
1.7.9.5


Best Regards,
Milo


