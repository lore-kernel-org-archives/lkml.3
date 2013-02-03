Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab3BCDFd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 22:05:33 -0500
Received: from mout.gmx.net ([212.227.17.21]:59219 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639Ab3BCDFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 22:05:10 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+6H6l8E2i6k/cnTyIv5YmWENQ3pDx3Eqzm4FhEV5
	ZjmxgrH/UOGBOL
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] staging/xgifb: remove unused variables
Date: Sun,  3 Feb 2013 04:08:46 +0100
Message-Id: <1359860926-27769-6-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1359860926-27769-1-git-send-email-peterhuewe@gmx.de>
References: <1359860926-27769-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XGI_P3cc is unused and the assignment without side effects -> remove;
Data can be simply replaced by the Temp variable, which was changed to
temp in order to make checkpatch happy.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_setmode.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 93f5d46..8eb23a4 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -638,10 +638,7 @@ static void xgifb_set_lcd(int chip_id,
 			  unsigned short RefreshRateTableIndex,
 			  unsigned short ModeNo)
 {
-	unsigned short Data, Temp;
-	unsigned short XGI_P3cc;
-
-	XGI_P3cc = pVBInfo->P3cc;
+	unsigned short temp;
 
 	xgifb_reg_set(pVBInfo->P3d4, 0x2E, 0x00);
 	xgifb_reg_set(pVBInfo->P3d4, 0x2F, 0x00);
@@ -649,8 +646,8 @@ static void xgifb_set_lcd(int chip_id,
 	xgifb_reg_set(pVBInfo->P3d4, 0x47, 0x00);
 
 	if (chip_id == XG27) {
-		Temp = xgifb_reg_get(pVBInfo->P3d4, 0x37);
-		if ((Temp & 0x03) == 0) { /* dual 12 */
+		temp = xgifb_reg_get(pVBInfo->P3d4, 0x37);
+		if ((temp & 0x03) == 0) { /* dual 12 */
 			xgifb_reg_set(pVBInfo->P3d4, 0x46, 0x13);
 			xgifb_reg_set(pVBInfo->P3d4, 0x47, 0x13);
 		}
@@ -659,8 +656,8 @@ static void xgifb_set_lcd(int chip_id,
 	if (chip_id == XG27) {
 		XGI_SetXG27FPBits(pVBInfo);
 	} else {
-		Temp = xgifb_reg_get(pVBInfo->P3d4, 0x37);
-		if (Temp & 0x01) {
+		temp = xgifb_reg_get(pVBInfo->P3d4, 0x37);
+		if (temp & 0x01) {
 			/* 18 bits FP */
 			xgifb_reg_or(pVBInfo->P3c4, 0x06, 0x40);
 			xgifb_reg_or(pVBInfo->P3c4, 0x09, 0x40);
@@ -672,11 +669,11 @@ static void xgifb_set_lcd(int chip_id,
 	xgifb_reg_and(pVBInfo->P3c4, 0x30, ~0x20); /* Hsync polarity */
 	xgifb_reg_and(pVBInfo->P3c4, 0x35, ~0x80); /* Vsync polarity */
 
-	Data = XGI330_RefIndex[RefreshRateTableIndex].Ext_InfoFlag;
-	if (Data & 0x4000)
+	temp = XGI330_RefIndex[RefreshRateTableIndex].Ext_InfoFlag;
+	if (temp & 0x4000)
 		/* Hsync polarity */
 		xgifb_reg_or(pVBInfo->P3c4, 0x30, 0x20);
-	if (Data & 0x8000)
+	if (temp & 0x8000)
 		/* Vsync polarity */
 		xgifb_reg_or(pVBInfo->P3c4, 0x35, 0x80);
 }
-- 
1.7.8.6

