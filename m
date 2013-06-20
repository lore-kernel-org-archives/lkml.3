Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965411Ab3FTLG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:06:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60870 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965190Ab3FTLGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:06:55 -0400
From: J Keerthy <j-keerthy@ti.com>
To: <linux-omap@vger.kernel.org>, <sameo@linux.intel.com>
CC: <broonie@kernel.org>, <j-keerthy@ti.com>, <ldewangan@nvidia.com>,
        <grant.likely@secretlab.ca>, <swarren@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <gg@slimlogic.co.uk>
Subject: [PATCH 2/4] MFD: Palmas: Add TPS659038 PMIC support
Date: Thu, 20 Jun 2013 16:35:16 +0530
Message-ID: <1371726316-10078-1-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/palmas.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index ad2edd6..8b20055 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -233,12 +233,17 @@ static void palmas_dt_to_pdata(struct i2c_client *i2c,
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

