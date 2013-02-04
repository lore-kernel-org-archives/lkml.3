Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab3BDX0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 18:26:09 -0500
Received: from mout.gmx.net ([212.227.17.21]:55255 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501Ab3BDX0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 18:26:05 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX196CJss27l65IQUY8rJlwez8BszpvZbs6e+gkxzg9
	A0FRxkg+UXeeGp
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] staging/xgifb: Consolidate if/else for 'identical' branches
Date: Tue,  5 Feb 2013 00:29:46 +0100
Message-Id: <1360020587-8399-4-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1360020587-8399-1-git-send-email-peterhuewe@gmx.de>
References: <1360020587-8399-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since XGI_LCDDesStruct is fully contained in XGI330_LCDDataDesStruct2
and the offsets for the first members is identical we can consolidate
the if/else branches here and use XGI330_LCDDataDesStruct2 for
everything.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_setmode.c |   31 ++++++-------------------------
 1 files changed, 6 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index f44a254..131a267 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -1470,18 +1470,11 @@ static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 {
 	unsigned short tempbx, tempax, tempcx, tempdx, push1, push2, modeflag;
 	unsigned long temp, temp1, temp2, temp3, push3;
-	struct XGI_LCDDesStruct const *LCDPtr = NULL;
 	struct XGI330_LCDDataDesStruct2 const *LCDPtr1 = NULL;
 
 	modeflag = XGI330_EModeIDTable[ModeIdIndex].Ext_ModeFlag;
-	if (pVBInfo->LCDInfo & EnableScalingLCD)
-		LCDPtr1 = XGI_GetLcdPtr(XGI_EPLLCDDesDataPtr, ModeNo,
-					ModeIdIndex, RefreshRateTableIndex,
-					pVBInfo);
-	else
-		LCDPtr = XGI_GetLcdPtr(XGI_EPLLCDDesDataPtr, ModeNo,
-				       ModeIdIndex, RefreshRateTableIndex,
-				       pVBInfo);
+	LCDPtr1 = XGI_GetLcdPtr(XGI_EPLLCDDesDataPtr, ModeNo, ModeIdIndex,
+					RefreshRateTableIndex, pVBInfo);
 
 	XGI_GetLCDSync(&tempax, &tempbx, pVBInfo);
 	push1 = tempbx;
@@ -1513,10 +1506,7 @@ static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	tempax = pVBInfo->HT;
 
-	if (pVBInfo->LCDInfo & EnableScalingLCD)
-		tempbx = LCDPtr1->LCDHDES;
-	else
-		tempbx = LCDPtr->LCDHDES;
+	tempbx = LCDPtr1->LCDHDES;
 
 	tempcx = pVBInfo->HDE;
 	tempbx = tempbx & 0x0fff;
@@ -1537,10 +1527,7 @@ static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	tempax = pVBInfo->HT;
 
-	if (pVBInfo->LCDInfo & EnableScalingLCD)
-		tempbx = LCDPtr1->LCDHRS;
-	else
-		tempbx = LCDPtr->LCDHRS;
+	tempbx = LCDPtr1->LCDHRS;
 
 	tempcx = push2;
 
@@ -1565,10 +1552,7 @@ static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 			(unsigned short) (tempbx & 0xff));
 
 	tempax = pVBInfo->VT;
-	if (pVBInfo->LCDInfo & EnableScalingLCD)
-		tempbx = LCDPtr1->LCDVDES;
-	else
-		tempbx = LCDPtr->LCDVDES;
+	tempbx = LCDPtr1->LCDVDES;
 	tempcx = pVBInfo->VDE;
 
 	tempbx = tempbx & 0x0fff;
@@ -1589,10 +1573,7 @@ static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 					| tempbx));
 
 	tempax = pVBInfo->VT;
-	if (pVBInfo->LCDInfo & EnableScalingLCD)
-		tempbx = LCDPtr1->LCDVRS;
-	else
-		tempbx = LCDPtr->LCDVRS;
+	tempbx = LCDPtr1->LCDVRS;
 
 	tempcx = push1;
 
-- 
1.7.8.6

