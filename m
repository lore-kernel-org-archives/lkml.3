Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab3BCDFZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 22:05:25 -0500
Received: from mout.gmx.net ([212.227.17.21]:51666 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417Ab3BCDFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 22:05:06 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/D8R4LP3XDkZNoXfKB9tsMfRDKwddevOdRWoLrsx
	p9yaY1JxKc7rwY
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] staging/xgifb: Remove unused variables
Date: Sun,  3 Feb 2013 04:08:44 +0100
Message-Id: <1359860926-27769-4-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1359860926-27769-1-git-send-email-peterhuewe@gmx.de>
References: <1359860926-27769-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pindex and Pdata are unused -> remove
tempbx is unused -> remove

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_setmode.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 10b9cb6..2e7277e 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -4432,10 +4432,6 @@ static void XGINew_EnableCRT2(struct vb_device_info *pVBInfo)
 static void XGI_SetGroup5(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct vb_device_info *pVBInfo)
 {
-	unsigned short Pindex, Pdata;
-
-	Pindex = pVBInfo->Part5Port;
-	Pdata = pVBInfo->Part5Port + 1;
 	if (pVBInfo->ModeType == ModeVGA) {
 		if (!(pVBInfo->VBInfo & (SetInSlaveMode | LoadDACFlag
 				| DisableCRT2Display))) {
@@ -5588,9 +5584,8 @@ static unsigned char XGI_SetCRT2Group301(unsigned short ModeNo,
 		struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
-	unsigned short tempbx, ModeIdIndex, RefreshRateTableIndex;
+	unsigned short ModeIdIndex, RefreshRateTableIndex;
 
-	tempbx = pVBInfo->VBInfo;
 	pVBInfo->SetFlag |= ProgrammingCRT2;
 	XGI_SearchModeID(ModeNo, &ModeIdIndex, pVBInfo);
 	pVBInfo->SelectCRT2Rate = 4;
-- 
1.7.8.6

