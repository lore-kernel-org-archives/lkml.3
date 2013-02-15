Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744Ab3BOTd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 14:33:58 -0500
Received: from mout.gmx.net ([212.227.17.21]:52124 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab3BOTcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 14:32:50 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19QvVQVv5xQeTZHWZCBFKIt84JQQjD2WwuGx0ALTg
	cTL9KhdhhPGi8B
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] staging/xgifb: Remove unnecessary casts
Date: Fri, 15 Feb 2013 20:37:10 +0100
Message-Id: <1360957033-11876-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1360957033-11876-1-git-send-email-peterhuewe@gmx.de>
References: <1360957033-11876-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both functions xgifb_reg_get and inb return an u8 value, so we don't
need to cast their return value to unsigned char.

-> remove the cast

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_init.c    |    2 +-
 drivers/staging/xgifb/vb_setmode.c |   66 +++++++++++++++++-------------------
 2 files changed, 32 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 82170d4..df127e4 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -1341,7 +1341,7 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 		xgifb_reg_and_or(pVBInfo->Part0Port, 0x3F, 0xEF, 0x00);
 		xgifb_reg_set(pVBInfo->Part1Port, 0x00, 0x00);
 		/* chk if BCLK>=100MHz */
-		temp1 = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x7B);
+		temp1 = xgifb_reg_get(pVBInfo->P3d4, 0x7B);
 		temp = (unsigned char) ((temp1 >> 4) & 0x0F);
 
 		xgifb_reg_set(pVBInfo->Part1Port,
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 0b134af..f5a9bb2 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -82,7 +82,7 @@ static void XGI_SetCRTCRegs(struct xgi_hw_device_info *HwDeviceExtension,
 	unsigned char CRTCdata;
 	unsigned short i;
 
-	CRTCdata = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x11);
+	CRTCdata = xgifb_reg_get(pVBInfo->P3d4, 0x11);
 	CRTCdata &= 0x7f;
 	xgifb_reg_set(pVBInfo->P3d4, 0x11, CRTCdata); /* Unlock CRTC */
 
@@ -139,7 +139,7 @@ static void XGI_SetGRCRegs(struct vb_device_info *pVBInfo)
 	}
 
 	if (pVBInfo->ModeType > ModeVGA) {
-		GRdata = (unsigned char) xgifb_reg_get(pVBInfo->P3ce, 0x05);
+		GRdata = xgifb_reg_get(pVBInfo->P3ce, 0x05);
 		GRdata &= 0xBF; /* 256 color disable */
 		xgifb_reg_set(pVBInfo->P3ce, 0x05, GRdata);
 	}
@@ -287,7 +287,7 @@ static void XGI_SetCRT1Timing_H(struct vb_device_info *pVBInfo,
 	unsigned short i, j;
 
 	/* unlock cr0-7 */
-	data = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x11);
+	data = xgifb_reg_get(pVBInfo->P3d4, 0x11);
 	data &= 0x7F;
 	xgifb_reg_set(pVBInfo->P3d4, 0x11, data);
 
@@ -304,7 +304,7 @@ static void XGI_SetCRT1Timing_H(struct vb_device_info *pVBInfo,
 		xgifb_reg_set(pVBInfo->P3c4, (unsigned short) (i + 6), data);
 	}
 
-	j = (unsigned char) xgifb_reg_get(pVBInfo->P3c4, 0x0e);
+	j = xgifb_reg_get(pVBInfo->P3c4, 0x0e);
 	j &= 0x1F;
 	data = pVBInfo->TimingH.data[7];
 	data &= 0xE0;
@@ -312,17 +312,16 @@ static void XGI_SetCRT1Timing_H(struct vb_device_info *pVBInfo,
 	xgifb_reg_set(pVBInfo->P3c4, 0x0e, data);
 
 	if (HwDeviceExtension->jChipType >= XG20) {
-		data = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x04);
+		data = xgifb_reg_get(pVBInfo->P3d4, 0x04);
 		data = data - 1;
 		xgifb_reg_set(pVBInfo->P3d4, 0x04, data);
-		data = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x05);
+		data = xgifb_reg_get(pVBInfo->P3d4, 0x05);
 		data1 = data;
 		data1 &= 0xE0;
 		data &= 0x1F;
 		if (data == 0) {
 			pushax = data;
-			data = (unsigned char) xgifb_reg_get(pVBInfo->P3c4,
-					0x0c);
+			data = xgifb_reg_get(pVBInfo->P3c4, 0x0c);
 			data &= 0xFB;
 			xgifb_reg_set(pVBInfo->P3c4, 0x0c, data);
 			data = pushax;
@@ -330,7 +329,7 @@ static void XGI_SetCRT1Timing_H(struct vb_device_info *pVBInfo,
 		data = data - 1;
 		data |= data1;
 		xgifb_reg_set(pVBInfo->P3d4, 0x05, data);
-		data = (unsigned char) xgifb_reg_get(pVBInfo->P3c4, 0x0e);
+		data = xgifb_reg_get(pVBInfo->P3c4, 0x0e);
 		data = data >> 5;
 		data = data + 3;
 		if (data > 7)
@@ -362,7 +361,7 @@ static void XGI_SetCRT1Timing_V(unsigned short ModeIdIndex,
 		xgifb_reg_set(pVBInfo->P3d4, (unsigned short) (i + 0x11), data);
 	}
 
-	j = (unsigned char) xgifb_reg_get(pVBInfo->P3c4, 0x0a);
+	j = xgifb_reg_get(pVBInfo->P3c4, 0x0a);
 	j &= 0xC0;
 	data = pVBInfo->TimingV.data[6];
 	data &= 0x3F;
@@ -378,7 +377,7 @@ static void XGI_SetCRT1Timing_V(unsigned short ModeIdIndex,
 	if (i)
 		data |= 0x80;
 
-	j = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x09);
+	j = xgifb_reg_get(pVBInfo->P3d4, 0x09);
 	j &= 0x5F;
 	data |= j;
 	xgifb_reg_set(pVBInfo->P3d4, 0x09, data);
@@ -396,7 +395,7 @@ static void XGI_SetCRT1CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 	index = XGI330_RefIndex[RefreshRateTableIndex].Ext_CRT1CRTC;
 	index = index & IndexMask;
 
-	data = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x11);
+	data = xgifb_reg_get(pVBInfo->P3d4, 0x11);
 	data &= 0x7F;
 	xgifb_reg_set(pVBInfo->P3d4, 0x11, data); /* Unlock CRTC */
 
@@ -741,8 +740,8 @@ static void XGI_SetCRT1DE(struct xgi_hw_device_info *HwDeviceExtension,
 	tempax -= 1;
 	tempbx -= 1;
 	tempcx = tempax;
-	temp = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x11);
-	data = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x11);
+	temp = xgifb_reg_get(pVBInfo->P3d4, 0x11);
+	data = xgifb_reg_get(pVBInfo->P3d4, 0x11);
 	data &= 0x7F;
 	xgifb_reg_set(pVBInfo->P3d4, 0x11, data); /* Unlock CRTC */
 	xgifb_reg_set(pVBInfo->P3d4, 0x01, (unsigned short) (tempcx & 0xff));
@@ -759,7 +758,7 @@ static void XGI_SetCRT1DE(struct xgi_hw_device_info *HwDeviceExtension,
 		tempax |= 0x40;
 
 	xgifb_reg_and_or(pVBInfo->P3d4, 0x07, ~0x42, tempax);
-	data = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x07);
+	data = xgifb_reg_get(pVBInfo->P3d4, 0x07);
 	data &= 0xFF;
 	tempax = 0;
 
@@ -1779,7 +1778,7 @@ static unsigned char XGI_GetVCLKPtr(unsigned short RefreshRateTableIndex,
 		}
 	} /* {End of VB} */
 
-	tempal = (unsigned char) inb((pVBInfo->P3ca + 0x02));
+	tempal = inb((pVBInfo->P3ca + 0x02));
 	tempal = tempal >> 2;
 	tempal &= 0x03;
 
@@ -3796,8 +3795,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 	}
 
 	if (pVBInfo->TVInfo & TVSetPALM) {
-		tempax = (unsigned char) xgifb_reg_get(pVBInfo->Part2Port,
-				0x01);
+		tempax = xgifb_reg_get(pVBInfo->Part2Port, 0x01);
 		tempax--;
 		xgifb_reg_and(pVBInfo->Part2Port, 0x01, tempax);
 
@@ -4405,7 +4403,7 @@ static void xgifb_set_lvds(struct xgifb_video_info *xgifb_info,
 	temp = (unsigned char) ((xgifb_info->lvds_data.LVDS_Capability &
 				(LCDPolarity << 8)) >> 8);
 	temp &= LCDPolarity;
-	Miscdata = (unsigned char) inb(pVBInfo->P3cc);
+	Miscdata = inb(pVBInfo->P3cc);
 
 	outb((Miscdata & 0x3F) | temp, pVBInfo->P3c2);
 
@@ -4465,7 +4463,7 @@ static void xgifb_set_lvds(struct xgifb_video_info *xgifb_info,
 
 	LVDSVBE = LVDSVBS + LVDSVT - xgifb_info->lvds_data.LVDSVDE;
 
-	temp = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x11);
+	temp = xgifb_reg_get(pVBInfo->P3d4, 0x11);
 	xgifb_reg_set(pVBInfo->P3d4, 0x11, temp & 0x7f); /* Unlock CRTC */
 
 	if (!(modeflag & Charx8Dot))
@@ -5482,25 +5480,25 @@ void XGI_SenseCRT1(struct vb_device_info *pVBInfo)
 
 	/* to fix XG42 single LCD sense to CRT+LCD */
 	xgifb_reg_set(pVBInfo->P3d4, 0x57, 0x4A);
-	xgifb_reg_set(pVBInfo->P3d4, 0x53, (unsigned char) (xgifb_reg_get(
+	xgifb_reg_set(pVBInfo->P3d4, 0x53, (xgifb_reg_get(
 			pVBInfo->P3d4, 0x53) | 0x02));
 
-	SR31 = (unsigned char) xgifb_reg_get(pVBInfo->P3c4, 0x31);
-	CR63 = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x63);
-	SR01 = (unsigned char) xgifb_reg_get(pVBInfo->P3c4, 0x01);
+	SR31 = xgifb_reg_get(pVBInfo->P3c4, 0x31);
+	CR63 = xgifb_reg_get(pVBInfo->P3d4, 0x63);
+	SR01 = xgifb_reg_get(pVBInfo->P3c4, 0x01);
 
 	xgifb_reg_set(pVBInfo->P3c4, 0x01, (unsigned char) (SR01 & 0xDF));
 	xgifb_reg_set(pVBInfo->P3d4, 0x63, (unsigned char) (CR63 & 0xBF));
 
-	CR17 = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x17);
+	CR17 = xgifb_reg_get(pVBInfo->P3d4, 0x17);
 	xgifb_reg_set(pVBInfo->P3d4, 0x17, (unsigned char) (CR17 | 0x80));
 
-	SR1F = (unsigned char) xgifb_reg_get(pVBInfo->P3c4, 0x1F);
+	SR1F = xgifb_reg_get(pVBInfo->P3c4, 0x1F);
 	xgifb_reg_set(pVBInfo->P3c4, 0x1F, (unsigned char) (SR1F | 0x04));
 
-	SR07 = (unsigned char) xgifb_reg_get(pVBInfo->P3c4, 0x07);
+	SR07 = xgifb_reg_get(pVBInfo->P3c4, 0x07);
 	xgifb_reg_set(pVBInfo->P3c4, 0x07, (unsigned char) (SR07 & 0xFB));
-	SR06 = (unsigned char) xgifb_reg_get(pVBInfo->P3c4, 0x06);
+	SR06 = xgifb_reg_get(pVBInfo->P3c4, 0x06);
 	xgifb_reg_set(pVBInfo->P3c4, 0x06, (unsigned char) (SR06 & 0xC3));
 
 	xgifb_reg_set(pVBInfo->P3d4, 0x11, 0x00);
@@ -5558,7 +5556,7 @@ void XGI_SenseCRT1(struct vb_device_info *pVBInfo)
 	xgifb_reg_set(pVBInfo->P3d4, 0x63, CR63);
 	xgifb_reg_set(pVBInfo->P3c4, 0x31, SR31);
 
-	xgifb_reg_set(pVBInfo->P3d4, 0x53, (unsigned char) (xgifb_reg_get(
+	xgifb_reg_set(pVBInfo->P3d4, 0x53, (xgifb_reg_get(
 			pVBInfo->P3d4, 0x53) & 0xFD));
 	xgifb_reg_set(pVBInfo->P3c4, 0x1F, (unsigned char) SR1F);
 }
@@ -5583,8 +5581,7 @@ static void XGI_EnableBridge(struct xgifb_video_info *xgifb_info,
 			if ((pVBInfo->SetFlag & EnableChB) || (pVBInfo->VBInfo
 					& (SetCRT2ToLCD | SetCRT2ToTV
 							| SetCRT2ToRAMDAC))) {
-				tempah = (unsigned char) xgifb_reg_get(
-						pVBInfo->P3c4, 0x32);
+				tempah = xgifb_reg_get(pVBInfo->P3c4, 0x32);
 				tempah &= 0xDF;
 				if (pVBInfo->VBInfo & SetInSlaveMode) {
 					if (!(pVBInfo->VBInfo &
@@ -5594,8 +5591,8 @@ static void XGI_EnableBridge(struct xgifb_video_info *xgifb_info,
 				xgifb_reg_set(pVBInfo->P3c4, 0x32, tempah);
 				xgifb_reg_or(pVBInfo->P3c4, 0x1E, 0x20);
 
-				tempah = (unsigned char) xgifb_reg_get(
-						pVBInfo->Part1Port, 0x2E);
+				tempah = xgifb_reg_get(pVBInfo->Part1Port,
+						       0x2E);
 
 				if (!(tempah & 0x80))
 					xgifb_reg_or(pVBInfo->Part1Port,
@@ -5668,8 +5665,7 @@ static void XGI_EnableBridge(struct xgifb_video_info *xgifb_info,
 			/* enable CRT2 */
 			xgifb_reg_or(pVBInfo->Part1Port, 0x1E, 0x20);
 
-		tempah = (unsigned char) xgifb_reg_get(pVBInfo->Part1Port,
-				0x2E);
+		tempah = xgifb_reg_get(pVBInfo->Part1Port, 0x2E);
 		if (!(tempah & 0x80))
 			xgifb_reg_or(pVBInfo->Part1Port, 0x2E, 0x80);
 
-- 
1.7.8.6

