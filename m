Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab3BEV3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 16:29:11 -0500
Received: from mout.gmx.net ([212.227.15.19]:60929 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756877Ab3BEV3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 16:29:07 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19OTWQwtGJOsfAWpKwxtKerOcufUiL6gGSbZ2HlBT
	wuFOf/ybwklOtP
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] staging/xgifb: Remove always false if statement
Date: Tue,  5 Feb 2013 22:32:34 +0100
Message-Id: <1360099954-8612-6-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1360099954-8612-1-git-send-email-peterhuewe@gmx.de>
References: <1360099954-8612-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MCLKData does not contain any 0x1C value for its field SR28 nor does
XGI340_ECLKData contain any 0x1C or 0x22 value for its field SR2E.

-> the statement always evaluates to false.
-> remove

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_init.c |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index e19a714..82170d4 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -131,22 +131,6 @@ static void XGINew_SetMemoryClock(struct xgi_hw_device_info *HwDeviceExtension,
 	xgifb_reg_set(pVBInfo->P3c4,
 		      0x30,
 		      XGI340_ECLKData[pVBInfo->ram_type].SR30);
-
-	/* When XG42 ECLK = MCLK = 207MHz, Set SR32 D[1:0] = 10b */
-	/* Modify SR32 value, when MCLK=207MHZ, ELCK=250MHz,
-	 * Set SR32 D[1:0] = 10b */
-	if (HwDeviceExtension->jChipType == XG42) {
-		if ((pVBInfo->MCLKData[pVBInfo->ram_type].SR28 == 0x1C) &&
-		    (pVBInfo->MCLKData[pVBInfo->ram_type].SR29 == 0x01) &&
-		    (((XGI340_ECLKData[pVBInfo->ram_type].SR2E == 0x1C) &&
-		      (XGI340_ECLKData[pVBInfo->ram_type].SR2F == 0x01)) ||
-		     ((XGI340_ECLKData[pVBInfo->ram_type].SR2E == 0x22) &&
-		      (XGI340_ECLKData[pVBInfo->ram_type].SR2F == 0x01))))
-			xgifb_reg_set(pVBInfo->P3c4,
-				      0x32,
-				      ((unsigned char) xgifb_reg_get(
-					  pVBInfo->P3c4, 0x32) & 0xFC) | 0x02);
-	}
 }
 
 static void XGINew_DDRII_Bootup_XG27(
-- 
1.7.8.6

