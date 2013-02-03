Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab3BCVwC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 16:52:02 -0500
Received: from mout.gmx.net ([212.227.15.18]:61002 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009Ab3BCVvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 16:51:48 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX181nTkY+WE1ReHMKgO0+ulinhJvL3f+fFyzEzbUFO
	fd/yDCkAJBXdZO
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] staging/xgifb: Simplify XGISetModeNew
Date: Sun,  3 Feb 2013 22:54:39 +0100
Message-Id: <1359928479-8484-10-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1359928479-8484-1-git-send-email-peterhuewe@gmx.de>
References: <1359928479-8484-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simplifies the code of XGISetModeNew by reordering the
if/else if/case conditions when both branches are doing exactly the
same.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_setmode.c |   18 +++---------------
 1 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index c5faa89..f44a254 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -5907,7 +5907,8 @@ unsigned char XGISetModeNew(struct xgifb_video_info *xgifb_info,
 		XGI_GetLCDInfo(ModeNo, ModeIdIndex, pVBInfo);
 		XGI_DisableBridge(xgifb_info, HwDeviceExtension, pVBInfo);
 
-		if (pVBInfo->VBInfo & (SetSimuScanMode | XGI_SetCRT2ToLCDA)) {
+		if (pVBInfo->VBInfo & (SetSimuScanMode | XGI_SetCRT2ToLCDA) ||
+			(!(pVBInfo->VBInfo & SwitchCRT2))) {
 			XGI_SetCRT1Group(xgifb_info, HwDeviceExtension, ModeNo,
 					ModeIdIndex, pVBInfo);
 
@@ -5915,24 +5916,11 @@ unsigned char XGISetModeNew(struct xgifb_video_info *xgifb_info,
 				XGI_SetLCDAGroup(ModeNo, ModeIdIndex,
 						HwDeviceExtension, pVBInfo);
 			}
-		} else if (!(pVBInfo->VBInfo & SwitchCRT2)) {
-			XGI_SetCRT1Group(xgifb_info,
-					HwDeviceExtension, ModeNo,
-					ModeIdIndex, pVBInfo);
-			if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA) {
-				XGI_SetLCDAGroup(ModeNo, ModeIdIndex,
-						HwDeviceExtension,
-						pVBInfo);
-			}
 		}
 
 		if (pVBInfo->VBInfo & (SetSimuScanMode | SwitchCRT2)) {
 			switch (HwDeviceExtension->ujVBChipID) {
-			case VB_CHIP_301:
-				XGI_SetCRT2Group301(ModeNo, HwDeviceExtension,
-						pVBInfo); /*add for CRT2 */
-				break;
-
+			case VB_CHIP_301: /* fall through */
 			case VB_CHIP_302:
 				XGI_SetCRT2Group301(ModeNo, HwDeviceExtension,
 						pVBInfo); /*add for CRT2 */
-- 
1.7.8.6

