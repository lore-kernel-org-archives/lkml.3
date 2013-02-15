Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab3BOTcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 14:32:51 -0500
Received: from mout.gmx.net ([212.227.15.18]:54267 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab3BOTct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 14:32:49 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/SNPp4CuDS+DUrKON5834e7hDIUyn5mOdh/eGGj5
	NwOLVYq9eHFUhH
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] staging/xgifb: Consolidate if/else if with identical code branches
Date: Fri, 15 Feb 2013 20:37:09 +0100
Message-Id: <1360957033-11876-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both branches of this if statement execute the same code.
Thus we can || them together and remove code duplication

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_setmode.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 3d5c424..0b134af 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -5572,13 +5572,10 @@ static void XGI_EnableBridge(struct xgifb_video_info *xgifb_info,
 	if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B | VB_SIS301LV
 			| VB_SIS302LV | VB_XGI301C)) {
 		if (!(pVBInfo->SetFlag & DisableChA)) {
-			if (pVBInfo->SetFlag & EnableChA) {
+			if ((pVBInfo->SetFlag & EnableChA) ||
+			    (pVBInfo->VBInfo & SetCRT2ToDualEdge)) {
 				/* Power on */
 				xgifb_reg_set(pVBInfo->Part1Port, 0x1E, 0x20);
-			} else if (pVBInfo->VBInfo & SetCRT2ToDualEdge) {
-				/* Power on */
-				xgifb_reg_set(pVBInfo->Part1Port,
-						0x1E, 0x20);
 			}
 		}
 
-- 
1.7.8.6

