Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223Ab3FMSeD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:34:03 -0400
Received: from etezian.org ([198.101.225.253]:56456 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758942Ab3FMS27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:28:59 -0400
From: Andi Shyti <andi@etezian.org>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, pc@asdf.org, oatilla@gmail.com,
        andi@etezian.org
Subject: [PATCH 05/19] bh1770glc: Removed obsolete offset settings from SFH7770 code
Date: Thu, 13 Jun 2013 20:20:39 +0200
Message-Id: <957f59d00ccecf07127a6c729fc513992fc745c8.1371145891.git.andi@etezian.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Onur Atilla <oatilla@gmail.com>

Some obsolete version-dependent coefficient and constant settings
were removed out of the sensor detection functions. These values
cause unwanted offset between different sensor types.

Signed-off-by: Onur Atilla <oatilla@gmail.com>
Signed-off-by: Andi Shyti <andi@etezian.org>
---
 drivers/misc/bh1770glc.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/misc/bh1770glc.c b/drivers/misc/bh1770glc.c
index d8d6526..53f3c17 100644
--- a/drivers/misc/bh1770glc.c
+++ b/drivers/misc/bh1770glc.c
@@ -565,9 +565,6 @@ static int bh1770_detect(struct bh1770_chip *chip)
 	if ((manu == BH1770_MANUFACT_OSRAM) &&
 	    ((part & BH1770_PART_MASK) == BH1770_PART)) {
 		snprintf(chip->chipname, sizeof(chip->chipname), "SFH7770");
-		/* Values selected by comparing different versions */
-		chip->prox_coef = 819; /* 0.8 * BH1770_COEF_SCALER */
-		chip->prox_const = 40;
 		chip->lux_cf = chip->pdata->als_scf_SFH7770;
 		return 0;
 	}
-- 
1.7.10.4

