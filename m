Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965052Ab3FTIiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:38:24 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44414 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935345Ab3FTIiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:38:18 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <ldewangan@nvidia.com>, <broonie@kernel.org>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <lgirdwood@gmail.com>, <swarren@nvidia.com>, <gg@slimlogic.co.uk>,
        <sameo@linux.intel.com>, <ian@slimlogic.co.uk>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>
Subject: [PATCH 1/2] regulator: of: Added a property to indicate bypass mode support
Date: Thu, 20 Jun 2013 14:07:37 +0530
Message-ID: <1371717458-10307-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1371717458-10307-1-git-send-email-kishon@ti.com>
References: <1371717458-10307-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a property to indicate if the regulator supports bypass mode.
Also modified of_get_regulation_constraints() to check for that
property and set appropriate constraints.

Cc: Laxman Dewangan <ldewangan@nvidia.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 Documentation/devicetree/bindings/regulator/regulator.txt |    1 +
 drivers/regulator/of_regulator.c                          |    3 +++
 2 files changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
index ecfc6cc..48a3b8e 100644
--- a/Documentation/devicetree/bindings/regulator/regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/regulator.txt
@@ -9,6 +9,7 @@ Optional properties:
 - regulator-max-microamp: largest current consumers may set
 - regulator-always-on: boolean, regulator should never be disabled
 - regulator-boot-on: bootloader/firmware enabled regulator
+- regulator-allow-bypass: allow the regulator to go into bypass mode
 - <name>-supply: phandle to the parent supply/regulator node
 - regulator-ramp-delay: ramp delay for regulator(in uV/uS)
 
diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 66ca769..f3c8f8f 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -61,6 +61,9 @@ static void of_get_regulation_constraints(struct device_node *np,
 	else /* status change should be possible if not always on. */
 		constraints->valid_ops_mask |= REGULATOR_CHANGE_STATUS;
 
+	if (of_property_read_bool(np, "regulator-allow-bypass"))
+		constraints->valid_ops_mask |= REGULATOR_CHANGE_BYPASS;
+
 	ramp_delay = of_get_property(np, "regulator-ramp-delay", NULL);
 	if (ramp_delay)
 		constraints->ramp_delay = be32_to_cpu(*ramp_delay);
-- 
1.7.10.4

