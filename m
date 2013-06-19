Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab3FSF7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 01:59:05 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50748 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756444Ab3FSF66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 01:58:58 -0400
From: Keerthy <j-keerthy@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <broonie@kernel.org>, <j-keerthy@ti.com>, <ldewangan@nvidia.com>,
        <sameo@linux.intel.com>, <grant.likely@secretlab.ca>,
        <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <gg@slimlogic.co.uk>
Subject: [PATCH v3 3/4] mfd: Palmas: Add TPS659038 PMIC support
Date: Wed, 19 Jun 2013 11:27:49 +0530
Message-ID: <1371621470-22279-4-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1371621470-22279-1-git-send-email-j-keerthy@ti.com>
References: <1371621470-22279-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Keerthy <j-keerthy@ti.com>

The Patch adds TPS659038 PMIC support in the palmas mfd driver.
The TPS659038 has almost the same registers as of the earlier
supported variants of PALMAS family such as the TWL6035.

The critical differences between TPS659038 and TWL6035 being:

1) TPS659038 has nothing related to battery charging and back up battery stuff.
2) TPS659038 does not have does not have SMPS10(Boost) step up convertor.
3) TPS659038 does not have Battery detection and anything related to battery.
4) SD card detection, Battery presence detection, Vibrator, USB OTG are missing
   when compared to TWL6035.

Signed-off-by: J Keerthy <j-keerthy@ti.com>
---
 Documentation/devicetree/bindings/mfd/palmas.txt |    2 ++
 drivers/mfd/palmas.c                             |    5 +++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/palmas.txt b/Documentation/devicetree/bindings/mfd/palmas.txt
index 7bcd59c..89cb773 100644
--- a/Documentation/devicetree/bindings/mfd/palmas.txt
+++ b/Documentation/devicetree/bindings/mfd/palmas.txt
@@ -5,6 +5,7 @@ twl6035 (palmas)
 twl6037 (palmas)
 tps65913 (palmas)
 tps65914 (palmas)
+tps659038
 
 Required properties:
 - compatible : Should be from the list
@@ -14,6 +15,7 @@ Required properties:
   ti,tps65913
   ti,tps65914
   ti,tps80036
+  ti,tps659038
 and also the generic series names
   ti,palmas
 - interrupt-controller : palmas has its own internal IRQs
diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index 1cacc6a..0439edb 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -232,12 +232,17 @@ static void palmas_dt_to_pdata(struct i2c_client *i2c,
 }
 
 static unsigned int palmas_features = PALMAS_PMIC_FEATURE_SMPS10_BOOST;
+static unsigned int tps659038_features;
 
 static const struct of_device_id of_palmas_match_tbl[] = {
 	{
 		.compatible = "ti,palmas",
 		.data = &palmas_features,
 	},
+	{
+		.compatible = "ti,tps659038",
+		.data = &tps659038_features,
+	},
 	{ },
 };
 
-- 
1.7.5.4

