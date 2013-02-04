Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab3BDX0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 18:26:12 -0500
Received: from mout.gmx.net ([212.227.17.21]:58252 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389Ab3BDX0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 18:26:08 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX192HWBlRTN25QenyWH5HJfG0OV8QMXhrmydOsMon2
	HKLk8mJoyOkDIJ
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] staging/xgifb: Consolidate if branches with similar conditions
Date: Tue,  5 Feb 2013 00:29:47 +0100
Message-Id: <1360020587-8399-5-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1360020587-8399-1-git-send-email-peterhuewe@gmx.de>
References: <1360020587-8399-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) The same condition (pVBInfo->IF_DEF_LVDS == 0) was checked in the if
clause directly in front of this one.

2) The same condition pVBInfo->VBType & (VB_SIS301B | VB_SIS302B |
VB_SIS301LV | VB_SIS302LV | VB_XGI301C) was checked in the if
clause directly in front of this one.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_setmode.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 131a267..bd81656 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -2299,9 +2299,7 @@ static unsigned char XGI_GetLCDInfo(unsigned short ModeNo,
 				& VB_XGI301C)) && (tempax & XGI_LCDDualLink)) {
 			tempbx |= SetLCDDualLink;
 		}
-	}
 
-	if (pVBInfo->IF_DEF_LVDS == 0) {
 		if ((pVBInfo->LCDResInfo == Panel_1400x1050) && (pVBInfo->VBInfo
 				& SetCRT2ToLCD) && (resinfo == 9) &&
 				(!(tempbx & EnableScalingLCD)))
@@ -5024,12 +5022,8 @@ static void XGI_SetLCDCap(struct vb_device_info *pVBInfo)
 
 	tempcx = pVBInfo->LCDCapList[XGI_GetLCDCapPtr(pVBInfo)].LCD_Capability;
 
-	if (pVBInfo->VBType &
-	    (VB_SIS301B |
-	     VB_SIS302B |
-	     VB_SIS301LV |
-	     VB_SIS302LV |
-	     VB_XGI301C)) { /* 301LV/302LV only */
+	if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B | VB_SIS301LV |
+		VB_SIS302LV | VB_XGI301C)) {
 		if (pVBInfo->VBType &
 		    (VB_SIS301LV | VB_SIS302LV | VB_XGI301C)) {
 			/* Set 301LV Capability */
@@ -5041,10 +5035,7 @@ static void XGI_SetLCDCap(struct vb_device_info *pVBInfo)
 				~((EnableVBCLKDRVLOW | EnablePLLSPLOW) >> 8),
 				(unsigned short) ((tempcx & (EnableVBCLKDRVLOW
 						| EnablePLLSPLOW)) >> 8));
-	}
 
-	if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B | VB_SIS301LV
-			| VB_SIS302LV | VB_XGI301C)) {
 		if (pVBInfo->VBInfo & SetCRT2ToLCD)
 			XGI_SetLCDCap_B(tempcx, pVBInfo);
 		else if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA)
-- 
1.7.8.6

