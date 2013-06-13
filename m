Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759136Ab3FMSc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:32:56 -0400
Received: from etezian.org ([198.101.225.253]:56457 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758944Ab3FMS3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:29:00 -0400
From: Andi Shyti <andi@etezian.org>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, pc@asdf.org, oatilla@gmail.com,
        andi@etezian.org
Subject: [PATCH 16/19] bh1770glc: Added sanity check for scf
Date: Thu, 13 Jun 2013 20:20:50 +0200
Message-Id: <5c2e83453a69f5e8a2bd1df3bd22bbfcbdd24f1a.1371145891.git.andi@etezian.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Onur Atilla <oatilla@gmail.com>

Sensor compensation factor input from the platform
is being checked now before use.

Signed-off-by: Onur Atilla <oatilla@gmail.com>
Signed-off-by: Andi Shyti <andi@etezian.org>
---
 drivers/misc/bh1770glc.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/bh1770glc.c b/drivers/misc/bh1770glc.c
index cb63c25..383cefe 100644
--- a/drivers/misc/bh1770glc.c
+++ b/drivers/misc/bh1770glc.c
@@ -123,6 +123,7 @@
 #define BH1770_LUX_GA_SCALE		8192
 #define BH1770_LUX_CF_SCALE		8192 /* CF ChipFactor */
 #define BH1770_NEUTRAL_CF		BH1770_LUX_CF_SCALE
+#define BH1770_LUX_MAX_CF		(10 * BH1770_NEUTRAL_CF)
 #define BH1770_LUX_CORR_SCALE		4096
 
 #define PROX_ABOVE_THRESHOLD	1
@@ -550,7 +551,11 @@ static int bh1770_detect(struct bh1770_chip *chip)
 	if ((manu == BH1770_MANUFACT_ROHM) &&
 	    ((part & BH1770_PART_MASK) == BH1770_PART)) {
 		snprintf(chip->chipname, sizeof(chip->chipname), "BH1770GLC");
-		chip->lux_cf = chip->pdata->als_scf_BH1770;
+
+		/* apply sensor compensation factor only after verifying it */
+		if ((chip->pdata->als_scf_BH1770 > 0) &&
+			(chip->pdata->als_scf_BH1770 < BH1770_LUX_MAX_CF))
+			chip->lux_cf = chip->pdata->als_scf_BH1770;
 
 		/* apply minimum threshold value only after verifying it */
 		if ((chip->pdata->prox_min_thresh_BH1770 > 0) &&
@@ -565,7 +570,11 @@ static int bh1770_detect(struct bh1770_chip *chip)
 	if ((manu == BH1770_MANUFACT_OSRAM) &&
 	    ((part & BH1770_PART_MASK) == BH1770_PART)) {
 		snprintf(chip->chipname, sizeof(chip->chipname), "SFH7770");
-		chip->lux_cf = chip->pdata->als_scf_SFH7770;
+
+		/* apply sensor compensation factor only after verifying it */
+		if ((chip->pdata->als_scf_SFH7770 > 0) &&
+			(chip->pdata->als_scf_SFH7770 < BH1770_LUX_MAX_CF))
+			chip->lux_cf = chip->pdata->als_scf_SFH7770;
 
 		/* apply minimum threshold value only after verifying it */
 		if ((chip->pdata->prox_min_thresh_SFH7770 > 0) &&
-- 
1.7.10.4

