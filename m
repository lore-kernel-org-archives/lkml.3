Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab3BCDFF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 22:05:05 -0500
Received: from mout.gmx.net ([212.227.15.18]:59688 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab3BCDFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 22:05:01 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19OPyp9tsVOD30gN87EXW/fV5UcSLUD6s7fTiWjHa
	xhNLabQXu9/dNv
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] staging/xgifb: Remove unused variables and dead assignments
Date: Sun,  3 Feb 2013 04:08:41 +0100
Message-Id: <1359860926-27769-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variables A,HBS and VBS are never read in XGIfb_mode_rate_to_ddata
and the assignment has no side effects -> so we can simply remove them.
Removing them causes VT, HT and cr_data3 to be unused -> remove them as well
and remove the assignmens to cr_data which are shadowed by a different
assignment a few lines later.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/XGI_main_26.c |   35 +++--------------------------------
 1 files changed, 3 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 68a216f..ca9f583 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -91,11 +91,10 @@ static int XGIfb_mode_rate_to_ddata(struct vb_device_info *XGI_Pr,
 	unsigned short ModeIdIndex, index = 0;
 	unsigned short RefreshRateTableIndex = 0;
 
-	unsigned short VRE, VBE, VRS, VBS, VDE, VT;
-	unsigned short HRE, HBE, HRS, HBS, HDE, HT;
+	unsigned short VRE, VBE, VRS, VDE;
+	unsigned short HRE, HBE, HRS, HDE;
 	unsigned char sr_data, cr_data, cr_data2;
-	unsigned long cr_data3;
-	int A, B, C, D, E, F, temp, j;
+	int B, C, D, E, F, temp, j;
 	InitTo330Pointer(HwDeviceExtension->jChipType, XGI_Pr);
 	if (!XGI_SearchModeID(ModeNo, &ModeIdIndex, XGI_Pr))
 		return 0;
@@ -105,12 +104,6 @@ static int XGIfb_mode_rate_to_ddata(struct vb_device_info *XGI_Pr,
 
 	sr_data = XGI_CRT1Table[index].CR[5];
 
-	cr_data = XGI_CRT1Table[index].CR[0];
-
-	/* Horizontal total */
-	HT = (cr_data & 0xff) | ((unsigned short) (sr_data & 0x03) << 8);
-	A = HT + 5;
-
 	HDE = (XGI330_RefIndex[RefreshRateTableIndex].XRes >> 3) - 1;
 	E = HDE + 1;
 
@@ -120,11 +113,6 @@ static int XGIfb_mode_rate_to_ddata(struct vb_device_info *XGI_Pr,
 	HRS = (cr_data & 0xff) | ((unsigned short) (sr_data & 0xC0) << 2);
 	F = HRS - E - 3;
 
-	cr_data = XGI_CRT1Table[index].CR[1];
-
-	/* Horizontal blank start */
-	HBS = (cr_data & 0xff) | ((unsigned short) (sr_data & 0x30) << 4);
-
 	sr_data = XGI_CRT1Table[index].CR[6];
 
 	cr_data = XGI_CRT1Table[index].CR[2];
@@ -152,16 +140,8 @@ static int XGIfb_mode_rate_to_ddata(struct vb_device_info *XGI_Pr,
 
 	sr_data = XGI_CRT1Table[index].CR[14];
 
-	cr_data = XGI_CRT1Table[index].CR[8];
-
 	cr_data2 = XGI_CRT1Table[index].CR[9];
 
-	/* Vertical total */
-	VT = (cr_data & 0xFF) | ((unsigned short) (cr_data2 & 0x01) << 8)
-			| ((unsigned short) (cr_data2 & 0x20) << 4)
-			| ((unsigned short) (sr_data & 0x01) << 10);
-	A = VT + 2;
-
 	VDE = XGI330_RefIndex[RefreshRateTableIndex].YRes - 1;
 	E = VDE + 1;
 
@@ -173,15 +153,6 @@ static int XGIfb_mode_rate_to_ddata(struct vb_device_info *XGI_Pr,
 			| ((unsigned short) (sr_data & 0x08) << 7);
 	F = VRS + 1 - E;
 
-	cr_data = XGI_CRT1Table[index].CR[12];
-
-	cr_data3 = (XGI_CRT1Table[index].CR[14] & 0x80) << 5;
-
-	/* Vertical blank start */
-	VBS = (cr_data & 0xff) | ((unsigned short) (cr_data2 & 0x08) << 5)
-			| ((unsigned short) (cr_data3 & 0x20) << 4)
-			| ((unsigned short) (sr_data & 0x04) << 8);
-
 	cr_data = XGI_CRT1Table[index].CR[13];
 
 	/* Vertical blank end */
-- 
1.7.8.6

