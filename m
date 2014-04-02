Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840AbaDBR4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 13:56:45 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:44301 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932811AbaDBR4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 13:56:05 -0400
From: =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, forest@alittletooquiet.net,
        Walter Lozano <walter@vanguardiasur.com.ar>,
        =?UTF-8?q?Ezequiel=20Garc=C3=ADa?= <ezequiel@vanguardiasur.com.ar>,
        driverdev-devel@linuxdriverproject.org,
        =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>
Subject: [PATCH v2 4/4] staging: vt6655: fix checkpatch bracing issues
Date: Wed,  2 Apr 2014 14:53:04 -0300
Message-Id: <1396461184-13231-5-git-send-email-guido@vanguardiasur.com.ar>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396461184-13231-1-git-send-email-guido@vanguardiasur.com.ar>
References: <1396356733-5344-1-git-send-email-guido@vanguardiasur.com.ar>
 <1396461184-13231-1-git-send-email-guido@vanguardiasur.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchs fixes tons of warnings such as:

  WARNING: braces {} are not necessary for single statement blocks
  #354: FILE: drivers/staging/vt6655/wmgr.c:354:
  +       for (ii = 0; ii < WLAN_BSSID_LEN; ii++) {
  +               pMgmt->abyDesireBSSID[ii] = 0xFF;
  +       }

Please note: this patch only fixes bracing issues (and there is still a
lot to do); so if you run checkpatch it _will_ throw a lot of errors.
Use --test-only=braces

Signed-off-by: Guido Martínez <guido@vanguardiasur.com.ar>
---
 drivers/staging/vt6655/baseband.c    |  84 +++++-----
 drivers/staging/vt6655/bssdb.c       |   6 +-
 drivers/staging/vt6655/card.c        | 143 ++++++++--------
 drivers/staging/vt6655/channel.c     |  77 ++++-----
 drivers/staging/vt6655/datarate.c    |  14 +-
 drivers/staging/vt6655/device_main.c | 128 +++++++--------
 drivers/staging/vt6655/dpc.c         |  61 ++++---
 drivers/staging/vt6655/hostap.c      |  16 +-
 drivers/staging/vt6655/iwctl.c       | 138 ++++++++--------
 drivers/staging/vt6655/key.c         |  49 +++---
 drivers/staging/vt6655/mac.c         |  88 +++++-----
 drivers/staging/vt6655/mib.c         |  78 +++++----
 drivers/staging/vt6655/michael.c     |   4 +-
 drivers/staging/vt6655/power.c       |  20 +--
 drivers/staging/vt6655/rf.c          |  51 +++---
 drivers/staging/vt6655/rxtx.c        | 257 +++++++++++++----------------
 drivers/staging/vt6655/tether.c      |   4 +-
 drivers/staging/vt6655/tkip.c        |   6 +-
 drivers/staging/vt6655/vntwifi.c     |  68 ++++----
 drivers/staging/vt6655/wcmd.c        |  97 ++++++-----
 drivers/staging/vt6655/wctl.c        |   3 +-
 drivers/staging/vt6655/wmgr.c        | 307 ++++++++++++++++-------------------
 drivers/staging/vt6655/wpa2.c        |  40 +++--
 drivers/staging/vt6655/wpactl.c      |  17 +-
 24 files changed, 812 insertions(+), 944 deletions(-)

diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index 9c0d8ee..6f95fb6 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -1784,29 +1784,27 @@ BBuGetFrameTime(
 	uRate = (unsigned int)awcFrameTime[uRateIdx];
 
 	if (uRateIdx <= 3) {          //CCK mode
-
-		if (byPreambleType == 1) {//Short
+		if (byPreambleType == 1) //Short
 			uPreamble = 96;
-		} else {
+		else
 			uPreamble = 192;
-		}
+
 		uFrameTime = (cbFrameLength * 80) / uRate;  //?????
 		uTmp = (uFrameTime * uRate) / 80;
-		if (cbFrameLength != uTmp) {
+		if (cbFrameLength != uTmp)
 			uFrameTime++;
-		}
 
 		return uPreamble + uFrameTime;
 	} else {
 		uFrameTime = (cbFrameLength * 8 + 22) / uRate;   //????????
 		uTmp = ((uFrameTime * uRate) - 22) / 8;
-		if (cbFrameLength != uTmp) {
+		if (cbFrameLength != uTmp)
 			uFrameTime++;
-		}
+
 		uFrameTime = uFrameTime * 4;    //???????
-		if (byPktType != PK_TYPE_11A) {
+		if (byPktType != PK_TYPE_11A)
 			uFrameTime += 6;     //??????
-		}
+
 		return 20 + uFrameTime; //??????
 	}
 }
@@ -2127,16 +2125,16 @@ bool BBbVT3253Init(PSDevice pDevice)
 
 	if (byRFType == RF_RFMD2959) {
 		if (byLocalID <= REV_ID_VT3253_A1) {
-			for (ii = 0; ii < CB_VT3253_INIT_FOR_RFMD; ii++) {
+			for (ii = 0; ii < CB_VT3253_INIT_FOR_RFMD; ii++)
 				bResult &= BBbWriteEmbedded(dwIoBase, byVT3253InitTab_RFMD[ii][0], byVT3253InitTab_RFMD[ii][1]);
-			}
+
 		} else {
-			for (ii = 0; ii < CB_VT3253B0_INIT_FOR_RFMD; ii++) {
+			for (ii = 0; ii < CB_VT3253B0_INIT_FOR_RFMD; ii++)
 				bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_RFMD[ii][0], byVT3253B0_RFMD[ii][1]);
-			}
-			for (ii = 0; ii < CB_VT3253B0_AGC_FOR_RFMD2959; ii++) {
+
+			for (ii = 0; ii < CB_VT3253B0_AGC_FOR_RFMD2959; ii++)
 				bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AGC4_RFMD2959[ii][0], byVT3253B0_AGC4_RFMD2959[ii][1]);
-			}
+
 			VNSvOutPortD(dwIoBase + MAC_REG_ITRTMSET, 0x23);
 			MACvRegBitsOn(dwIoBase, MAC_REG_PAPEDELAY, BIT0);
 		}
@@ -2149,12 +2147,12 @@ bool BBbVT3253Init(PSDevice pDevice)
 		pDevice->ldBmThreshold[2] = 0;
 		pDevice->ldBmThreshold[3] = 0;
 	} else if ((byRFType == RF_AIROHA) || (byRFType == RF_AL2230S)) {
-		for (ii = 0; ii < CB_VT3253B0_INIT_FOR_AIROHA2230; ii++) {
+		for (ii = 0; ii < CB_VT3253B0_INIT_FOR_AIROHA2230; ii++)
 			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AIROHA2230[ii][0], byVT3253B0_AIROHA2230[ii][1]);
-		}
-		for (ii = 0; ii < CB_VT3253B0_AGC; ii++) {
+
+		for (ii = 0; ii < CB_VT3253B0_AGC; ii++)
 			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AGC[ii][0], byVT3253B0_AGC[ii][1]);
-		}
+
 		pDevice->abyBBVGA[0] = 0x1C;
 		pDevice->abyBBVGA[1] = 0x10;
 		pDevice->abyBBVGA[2] = 0x0;
@@ -2164,12 +2162,12 @@ bool BBbVT3253Init(PSDevice pDevice)
 		pDevice->ldBmThreshold[2] = 0;
 		pDevice->ldBmThreshold[3] = 0;
 	} else if (byRFType == RF_UW2451) {
-		for (ii = 0; ii < CB_VT3253B0_INIT_FOR_UW2451; ii++) {
+		for (ii = 0; ii < CB_VT3253B0_INIT_FOR_UW2451; ii++)
 			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_UW2451[ii][0], byVT3253B0_UW2451[ii][1]);
-		}
-		for (ii = 0; ii < CB_VT3253B0_AGC; ii++) {
+
+		for (ii = 0; ii < CB_VT3253B0_AGC; ii++)
 			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AGC[ii][0], byVT3253B0_AGC[ii][1]);
-		}
+
 		VNSvOutPortB(dwIoBase + MAC_REG_ITRTMSET, 0x23);
 		MACvRegBitsOn(dwIoBase, MAC_REG_PAPEDELAY, BIT0);
 
@@ -2182,9 +2180,9 @@ bool BBbVT3253Init(PSDevice pDevice)
 		pDevice->ldBmThreshold[2] = 0;
 		pDevice->ldBmThreshold[3] = 0;
 	} else if (byRFType == RF_UW2452) {
-		for (ii = 0; ii < CB_VT3253B0_INIT_FOR_UW2451; ii++) {
+		for (ii = 0; ii < CB_VT3253B0_INIT_FOR_UW2451; ii++)
 			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_UW2451[ii][0], byVT3253B0_UW2451[ii][1]);
-		}
+
 		// Init ANT B select,TX Config CR09 = 0x61->0x45, 0x45->0x41(VC1/VC2 define, make the ANT_A, ANT_B inverted)
 		//bResult &= BBbWriteEmbedded(dwIoBase,0x09,0x41);
 		// Init ANT B select,RX Config CR10 = 0x28->0x2A, 0x2A->0x28(VC1/VC2 define, make the ANT_A, ANT_B inverted)
@@ -2203,9 +2201,8 @@ bool BBbVT3253Init(PSDevice pDevice)
 		//}}
 		bResult &= BBbWriteEmbedded(dwIoBase, 0xb0, 0x58);
 
-		for (ii = 0; ii < CB_VT3253B0_AGC; ii++) {
+		for (ii = 0; ii < CB_VT3253B0_AGC; ii++)
 			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AGC[ii][0], byVT3253B0_AGC[ii][1]);
-		}
 
 		pDevice->abyBBVGA[0] = 0x14;
 		pDevice->abyBBVGA[1] = 0x0A;
@@ -2218,12 +2215,12 @@ bool BBbVT3253Init(PSDevice pDevice)
 		//}} RobertYu
 
 	} else if (byRFType == RF_VT3226) {
-		for (ii = 0; ii < CB_VT3253B0_INIT_FOR_AIROHA2230; ii++) {
+		for (ii = 0; ii < CB_VT3253B0_INIT_FOR_AIROHA2230; ii++)
 			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AIROHA2230[ii][0], byVT3253B0_AIROHA2230[ii][1]);
-		}
-		for (ii = 0; ii < CB_VT3253B0_AGC; ii++) {
+
+		for (ii = 0; ii < CB_VT3253B0_AGC; ii++)
 			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AGC[ii][0], byVT3253B0_AGC[ii][1]);
-		}
+
 		pDevice->abyBBVGA[0] = 0x1C;
 		pDevice->abyBBVGA[1] = 0x10;
 		pDevice->abyBBVGA[2] = 0x0;
@@ -2236,9 +2233,9 @@ bool BBbVT3253Init(PSDevice pDevice)
 		MACvSetRFLE_LatchBase(dwIoBase);
 		//{{ RobertYu: 20050104
 	} else if (byRFType == RF_AIROHA7230) {
-		for (ii = 0; ii < CB_VT3253B0_INIT_FOR_AIROHA2230; ii++) {
+		for (ii = 0; ii < CB_VT3253B0_INIT_FOR_AIROHA2230; ii++)
 			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AIROHA2230[ii][0], byVT3253B0_AIROHA2230[ii][1]);
-		}
+
 
 		//{{ RobertYu:20050223, request by JerryChung
 		// Init ANT B select,TX Config CR09 = 0x61->0x45, 0x45->0x41(VC1/VC2 define, make the ANT_A, ANT_B inverted)
@@ -2249,9 +2246,9 @@ bool BBbVT3253Init(PSDevice pDevice)
 		bResult &= BBbWriteEmbedded(dwIoBase, 0xd7, 0x06);
 		//}}
 
-		for (ii = 0; ii < CB_VT3253B0_AGC; ii++) {
+		for (ii = 0; ii < CB_VT3253B0_AGC; ii++)
 			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AGC[ii][0], byVT3253B0_AGC[ii][1]);
-		}
+
 		pDevice->abyBBVGA[0] = 0x1C;
 		pDevice->abyBBVGA[1] = 0x10;
 		pDevice->abyBBVGA[2] = 0x0;
@@ -2407,17 +2404,15 @@ BBvSetShortSlotTime(PSDevice pDevice)
 
 	BBbReadEmbedded(pDevice->PortOffset, 0x0A, &byBBRxConf);//CR10
 
-	if (pDevice->bShortSlotTime) {
+	if (pDevice->bShortSlotTime)
 		byBBRxConf &= 0xDF;//1101 1111
-	} else {
+	else
 		byBBRxConf |= 0x20;//0010 0000
-	}
 
 	// patch for 3253B0 Baseband with Cardbus module
 	BBbReadEmbedded(pDevice->PortOffset, 0xE7, &byBBVGA);
-	if (byBBVGA == pDevice->abyBBVGA[0]) {
+	if (byBBVGA == pDevice->abyBBVGA[0])
 		byBBRxConf |= 0x20;//0010 0000
-	}
 
 	BBbWriteEmbedded(pDevice->PortOffset, 0x0A, byBBRxConf);//CR10
 }
@@ -2698,9 +2693,8 @@ BBvClearAntDivSQ3Value(PSDevice pDevice)
 	unsigned int ii;
 
 	pDevice->uDiversityCnt = 0;
-	for (ii = 0; ii < MAX_RATE; ii++) {
+	for (ii = 0; ii < MAX_RATE; ii++)
 		pDevice->uNumSQ3[ii] = 0;
-	}
 }
 
 /*
@@ -2721,9 +2715,9 @@ BBvClearAntDivSQ3Value(PSDevice pDevice)
 void
 BBvAntennaDiversity(PSDevice pDevice, unsigned char byRxRate, unsigned char bySQ3)
 {
-	if ((byRxRate >= MAX_RATE) || (pDevice->wAntDiversityMaxRate >= MAX_RATE)) {
+	if ((byRxRate >= MAX_RATE) || (pDevice->wAntDiversityMaxRate >= MAX_RATE))
 		return;
-	}
+
 	pDevice->uDiversityCnt++;
 
 	pDevice->uNumSQ3[byRxRate]++;
diff --git a/drivers/staging/vt6655/bssdb.c b/drivers/staging/vt6655/bssdb.c
index d7efd017..59679cd 100644
--- a/drivers/staging/vt6655/bssdb.c
+++ b/drivers/staging/vt6655/bssdb.c
@@ -497,9 +497,8 @@ BSSbInsertToBSSList(
 		}
 	}
 
-	if (bParsingQuiet && (pQuiet != NULL)) {
+	if (bParsingQuiet && (pQuiet != NULL))
 		CARDbStartQuiet(pMgmt->pAdapter);
-	}
 
 	pBSSList->uIELength = uIELength;
 	if (pBSSList->uIELength > WLAN_BEACON_FR_MAXLEN)
@@ -662,9 +661,8 @@ BSSbUpdateToBSSList(
 		}
 	}
 
-	if (bParsingQuiet && (pQuiet != NULL)) {
+	if (bParsingQuiet && (pQuiet != NULL))
 		CARDbStartQuiet(pMgmt->pAdapter);
-	}
 
 	pBSSList->uIELength = uIELength;
 	if (pBSSList->uIELength > WLAN_BEACON_FR_MAXLEN)
diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 702d4eb1..05bf48a 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -351,9 +351,9 @@ s_vSetRSPINF(PSDevice pDevice, CARD_PHY_TYPE ePHYType, void *pvSupportRateIEs, v
 bool CARDbIsShortPreamble(void *pDeviceHandler)
 {
 	PSDevice    pDevice = (PSDevice) pDeviceHandler;
-	if (pDevice->byPreambleType == 0) {
+	if (pDevice->byPreambleType == 0)
 		return false;
-	}
+
 	return true;
 }
 
@@ -400,9 +400,9 @@ bool CARDbSetPhyParameter(void *pDeviceHandler, CARD_PHY_TYPE ePHYType, unsigned
 
 	//Set SIFS, DIFS, EIFS, SlotTime, CwMin
 	if (ePHYType == PHY_TYPE_11A) {
-		if (pSupportRates == NULL) {
+		if (pSupportRates == NULL)
 			pSupportRates = (PWLAN_IE_SUPP_RATES) abyDefaultSuppRatesA;
-		}
+
 		if (pDevice->byRFType == RF_AIROHA7230) {
 			// AL7230 use single PAPE and connect to PAPE_2.4G
 			MACvSetBBType(pDevice->PortOffset, BB_TYPE_11G);
@@ -410,9 +410,9 @@ bool CARDbSetPhyParameter(void *pDeviceHandler, CARD_PHY_TYPE ePHYType, unsigned
 			pDevice->abyBBVGA[2] = 0x10;
 			pDevice->abyBBVGA[3] = 0x10;
 			BBbReadEmbedded(pDevice->PortOffset, 0xE7, &byData);
-			if (byData == 0x1C) {
+			if (byData == 0x1C)
 				BBbWriteEmbedded(pDevice->PortOffset, 0xE7, pDevice->abyBBVGA[0]);
-			}
+
 		} else if (pDevice->byRFType == RF_UW2452) {
 			MACvSetBBType(pDevice->PortOffset, BB_TYPE_11A);
 			pDevice->abyBBVGA[0] = 0x18;
@@ -430,18 +430,18 @@ bool CARDbSetPhyParameter(void *pDeviceHandler, CARD_PHY_TYPE ePHYType, unsigned
 		byDIFS = C_SIFS_A + 2*C_SLOT_SHORT;
 		byCWMaxMin = 0xA4;
 	} else if (ePHYType == PHY_TYPE_11B) {
-		if (pSupportRates == NULL) {
+		if (pSupportRates == NULL)
 			pSupportRates = (PWLAN_IE_SUPP_RATES) abyDefaultSuppRatesB;
-		}
+
 		MACvSetBBType(pDevice->PortOffset, BB_TYPE_11B);
 		if (pDevice->byRFType == RF_AIROHA7230) {
 			pDevice->abyBBVGA[0] = 0x1C;
 			pDevice->abyBBVGA[2] = 0x00;
 			pDevice->abyBBVGA[3] = 0x00;
 			BBbReadEmbedded(pDevice->PortOffset, 0xE7, &byData);
-			if (byData == 0x20) {
+			if (byData == 0x20)
 				BBbWriteEmbedded(pDevice->PortOffset, 0xE7, pDevice->abyBBVGA[0]);
-			}
+
 		} else if (pDevice->byRFType == RF_UW2452) {
 			pDevice->abyBBVGA[0] = 0x14;
 			BBbReadEmbedded(pDevice->PortOffset, 0xE7, &byData);
@@ -466,9 +466,9 @@ bool CARDbSetPhyParameter(void *pDeviceHandler, CARD_PHY_TYPE ePHYType, unsigned
 			pDevice->abyBBVGA[2] = 0x00;
 			pDevice->abyBBVGA[3] = 0x00;
 			BBbReadEmbedded(pDevice->PortOffset, 0xE7, &byData);
-			if (byData == 0x20) {
+			if (byData == 0x20)
 				BBbWriteEmbedded(pDevice->PortOffset, 0xE7, pDevice->abyBBVGA[0]);
-			}
+
 		} else if (pDevice->byRFType == RF_UW2452) {
 			pDevice->abyBBVGA[0] = 0x14;
 			BBbReadEmbedded(pDevice->PortOffset, 0xE7, &byData);
@@ -486,26 +486,25 @@ bool CARDbSetPhyParameter(void *pDeviceHandler, CARD_PHY_TYPE ePHYType, unsigned
 			bySlot = C_SLOT_LONG;
 			byDIFS = C_SIFS_BG + 2*C_SLOT_LONG;
 		}
-		if (VNTWIFIbyGetMaxSupportRate(pSupportRates, pExtSupportRates) > RATE_11M) {
+		if (VNTWIFIbyGetMaxSupportRate(pSupportRates, pExtSupportRates) > RATE_11M)
 			byCWMaxMin = 0xA4;
-		} else {
+		else
 			byCWMaxMin = 0xA5;
-		}
+
 		if (pDevice->bProtectMode != VNTWIFIbIsProtectMode(byERPField)) {
 			pDevice->bProtectMode = VNTWIFIbIsProtectMode(byERPField);
-			if (pDevice->bProtectMode) {
+			if (pDevice->bProtectMode)
 				MACvEnableProtectMD(pDevice->PortOffset);
-			} else {
+			else
 				MACvDisableProtectMD(pDevice->PortOffset);
-			}
+
 		}
 		if (pDevice->bBarkerPreambleMd != VNTWIFIbIsBarkerMode(byERPField)) {
 			pDevice->bBarkerPreambleMd = VNTWIFIbIsBarkerMode(byERPField);
-			if (pDevice->bBarkerPreambleMd) {
+			if (pDevice->bBarkerPreambleMd)
 				MACvEnableBarkerPreambleMd(pDevice->PortOffset);
-			} else {
+			else
 				MACvDisableBarkerPreambleMd(pDevice->PortOffset);
-			}
 		}
 	}
 
@@ -534,22 +533,22 @@ bool CARDbSetPhyParameter(void *pDeviceHandler, CARD_PHY_TYPE ePHYType, unsigned
 	if (pDevice->bySlot != bySlot) {
 		pDevice->bySlot = bySlot;
 		VNSvOutPortB(pDevice->PortOffset + MAC_REG_SLOT, pDevice->bySlot);
-		if (pDevice->bySlot == C_SLOT_SHORT) {
+		if (pDevice->bySlot == C_SLOT_SHORT)
 			pDevice->bShortSlotTime = true;
-		} else {
+		else
 			pDevice->bShortSlotTime = false;
-		}
+
 		BBvSetShortSlotTime(pDevice);
 	}
 	if (pDevice->byCWMaxMin != byCWMaxMin) {
 		pDevice->byCWMaxMin = byCWMaxMin;
 		VNSvOutPortB(pDevice->PortOffset + MAC_REG_CWMAXMIN0, pDevice->byCWMaxMin);
 	}
-	if (VNTWIFIbIsShortPreamble(wCapInfo)) {
+	if (VNTWIFIbIsShortPreamble(wCapInfo))
 		pDevice->byPreambleType = pDevice->byShortPreamble;
-	} else {
+	else
 		pDevice->byPreambleType = 0;
-	}
+
 	s_vSetRSPINF(pDevice, ePHYType, pSupportRates, pExtSupportRates);
 	pDevice->eCurrentPHYType = ePHYType;
 	// set for NDIS OID_802_11SUPPORTED_RATES
@@ -629,9 +628,9 @@ bool CARDbSetBeaconPeriod(void *pDeviceHandler, unsigned short wBeaconInterval)
 	uLowRemain = uBeaconInterval - uLowRemain;
 
 	// check if carry when add one beacon interval
-	if ((~uLowNextTBTT) < uLowRemain) {
+	if ((~uLowNextTBTT) < uLowRemain)
 		HIDWORD(qwNextTBTT)++;
-	}
+
 	LODWORD(qwNextTBTT) = uLowNextTBTT + uLowRemain;
 
 	// set HW beacon interval
@@ -687,15 +686,13 @@ bool CARDbStopTxPacket(void *pDeviceHandler, CARD_PKT_TYPE ePktType)
 	}
 	// wait all TD0 complete
 	if (pDevice->bStopTx0Pkt == true) {
-		if (pDevice->iTDUsed[TYPE_TXDMA0] != 0) {
+		if (pDevice->iTDUsed[TYPE_TXDMA0] != 0)
 			return false;
-		}
 	}
 	// wait all Data TD complete
 	if (pDevice->bStopDataPkt == true) {
-		if (pDevice->iTDUsed[TYPE_AC0DMA] != 0) {
+		if (pDevice->iTDUsed[TYPE_AC0DMA] != 0)
 			return false;
-		}
 	}
 
 	return true;
@@ -759,16 +756,16 @@ bool CARDbSetBSSID(void *pDeviceHandler, unsigned char *pbyBSSID, CARD_OP_MODE e
 
 	MACvWriteBSSIDAddress(pDevice->PortOffset, pbyBSSID);
 	memcpy(pDevice->abyBSSID, pbyBSSID, WLAN_BSSID_LEN);
-	if (eOPMode == OP_MODE_ADHOC) {
+	if (eOPMode == OP_MODE_ADHOC)
 		MACvRegBitsOn(pDevice->PortOffset, MAC_REG_HOSTCR, HOSTCR_ADHOC);
-	} else {
+	else
 		MACvRegBitsOff(pDevice->PortOffset, MAC_REG_HOSTCR, HOSTCR_ADHOC);
-	}
-	if (eOPMode == OP_MODE_AP) {
+
+	if (eOPMode == OP_MODE_AP)
 		MACvRegBitsOn(pDevice->PortOffset, MAC_REG_HOSTCR, HOSTCR_AP);
-	} else {
+	else
 		MACvRegBitsOff(pDevice->PortOffset, MAC_REG_HOSTCR, HOSTCR_AP);
-	}
+
 	if (eOPMode == OP_MODE_UNKNOWN) {
 		MACvRegBitsOff(pDevice->PortOffset, MAC_REG_RCR, RCR_BSSID);
 		pDevice->bBSSIDFilter = false;
@@ -1011,31 +1008,31 @@ CARDbAdd_PMKID_Candidate(
 		memset(&pDevice->gsPMKIDCandidate, 0, sizeof(SPMKIDCandidateEvent));
 	}
 
-	for (ii = 0; ii < 6; ii++) {
+	for (ii = 0; ii < 6; ii++)
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%02X ", *(pbyBSSID + ii));
-	}
+
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "\n");
 
 	// Update Old Candidate
 	for (ii = 0; ii < pDevice->gsPMKIDCandidate.NumCandidates; ii++) {
 		pCandidateList = &pDevice->gsPMKIDCandidate.CandidateList[ii];
 		if (!memcmp(pCandidateList->BSSID, pbyBSSID, ETH_ALEN)) {
-			if (bRSNCapExist && (wRSNCap & BIT0)) {
+			if (bRSNCapExist && (wRSNCap & BIT0))
 				pCandidateList->Flags |= NDIS_802_11_PMKID_CANDIDATE_PREAUTH_ENABLED;
-			} else {
+			else
 				pCandidateList->Flags &= ~(NDIS_802_11_PMKID_CANDIDATE_PREAUTH_ENABLED);
-			}
+
 			return true;
 		}
 	}
 
 	// New Candidate
 	pCandidateList = &pDevice->gsPMKIDCandidate.CandidateList[pDevice->gsPMKIDCandidate.NumCandidates];
-	if (bRSNCapExist && (wRSNCap & BIT0)) {
+	if (bRSNCapExist && (wRSNCap & BIT0))
 		pCandidateList->Flags |= NDIS_802_11_PMKID_CANDIDATE_PREAUTH_ENABLED;
-	} else {
+	else
 		pCandidateList->Flags &= ~(NDIS_802_11_PMKID_CANDIDATE_PREAUTH_ENABLED);
-	}
+
 	memcpy(pCandidateList->BSSID, pbyBSSID, ETH_ALEN);
 	pDevice->gsPMKIDCandidate.NumCandidates++;
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "NumCandidates:%d\n", (int)pDevice->gsPMKIDCandidate.NumCandidates);
@@ -1116,16 +1113,16 @@ CARDbStartMeasure(
 				// start immediately by setting start TSF == current TSF + 2 TU
 				LODWORD(qwStartTSF) = LODWORD(qwCurrTSF) + 2048;
 				HIDWORD(qwStartTSF) = HIDWORD(qwCurrTSF);
-				if (LODWORD(qwCurrTSF) > LODWORD(qwStartTSF)) {
+				if (LODWORD(qwCurrTSF) > LODWORD(qwStartTSF))
 					HIDWORD(qwStartTSF)++;
-				}
+
 				bExpired = false;
 				break;
 			} else {
 				// start at setting start TSF - 1TU(for channel switching)
-				if (LODWORD(qwStartTSF) < 1024) {
+				if (LODWORD(qwStartTSF) < 1024)
 					HIDWORD(qwStartTSF)--;
-				}
+
 				LODWORD(qwStartTSF) -= 1024;
 			}
 
@@ -1214,9 +1211,9 @@ CARDbChannelSwitch(
 	pDevice->byChannelSwitchCount = byCount;
 	pDevice->byNewChannel = byNewChannel;
 	pDevice->bChannelSwitch = true;
-	if (byMode == 1) {
+	if (byMode == 1)
 		bResult = CARDbStopTxPacket(pDevice, PKT_TYPE_802_11_ALL);
-	}
+
 	return bResult;
 }
 
@@ -1249,9 +1246,9 @@ CARDbSetQuiet(
 
 	if (bResetQuiet) {
 		MACvRegBitsOff(pDevice->PortOffset, MAC_REG_MSRCTL, (MSRCTL_QUIETTXCHK | MSRCTL_QUIETEN));
-		for (ii = 0; ii < MAX_QUIET_COUNT; ii++) {
+		for (ii = 0; ii < MAX_QUIET_COUNT; ii++)
 			pDevice->sQuiet[ii].bEnable = false;
-		}
+
 		pDevice->uQuietEnqueue = 0;
 		pDevice->bEnableFirstQuiet = false;
 		pDevice->bQuietEnable = false;
@@ -1266,9 +1263,8 @@ CARDbSetQuiet(
 		pDevice->sQuiet[pDevice->uQuietEnqueue].dwStartTime += wQuietOffset;
 		pDevice->uQuietEnqueue++;
 		pDevice->uQuietEnqueue %= MAX_QUIET_COUNT;
-		if (pDevice->byQuietStartCount < byQuietCount) {
+		if (pDevice->byQuietStartCount < byQuietCount)
 			pDevice->byQuietStartCount = byQuietCount;
-		}
 	}
 	return true;
 }
@@ -1364,9 +1360,9 @@ CARDbStartQuiet(
 		if (pDevice->dwCurrentQuietEndTime > 0x80010000) {
 			// decreament all time to avoid wrap around
 			for (ii = 0; ii < MAX_QUIET_COUNT; ii++) {
-				if (pDevice->sQuiet[ii].bEnable == true) {
+				if (pDevice->sQuiet[ii].bEnable == true)
 					pDevice->sQuiet[ii].dwStartTime -= 0x80000000;
-				}
+
 			}
 			pDevice->dwCurrentQuietEndTime -= 0x80000000;
 		}
@@ -1398,13 +1394,13 @@ CARDvSetPowerConstraint(
 	PSDevice    pDevice = (PSDevice) pDeviceHandler;
 
 	if (byChannel > CB_MAX_CHANNEL_24G) {
-		if (pDevice->bCountryInfo5G == true) {
+		if (pDevice->bCountryInfo5G == true)
 			pDevice->abyLocalPwr[byChannel] = pDevice->abyRegPwr[byChannel] - byPower;
-		}
+
 	} else {
-		if (pDevice->bCountryInfo24G == true) {
+		if (pDevice->bCountryInfo24G == true)
 			pDevice->abyLocalPwr[byChannel] = pDevice->abyRegPwr[byChannel] - byPower;
-		}
+
 	}
 }
 
@@ -1583,9 +1579,9 @@ unsigned short CARDwGetCCKControlRate(void *pDeviceHandler, unsigned short wRate
 	unsigned int ui = (unsigned int) wRateIdx;
 
 	while (ui > RATE_1M) {
-		if (pDevice->wBasicRate & ((unsigned short)1 << ui)) {
+		if (pDevice->wBasicRate & ((unsigned short)1 << ui))
 			return (unsigned short)ui;
-		}
+
 		ui--;
 	}
 	return (unsigned short)RATE_1M;
@@ -1785,11 +1781,11 @@ void vUpdateIFS(void *pDeviceHandler)
 		byMaxMin = 5;
 	} else { // PK_TYPE_11GA & PK_TYPE_11GB
 		pDevice->uSIFS = C_SIFS_BG;
-		if (pDevice->bShortSlotTime) {
+		if (pDevice->bShortSlotTime)
 			pDevice->uSlot = C_SLOT_SHORT;
-		} else {
+		else
 			pDevice->uSlot = C_SLOT_LONG;
-		}
+
 		pDevice->uDIFS = C_SIFS_BG + 2*pDevice->uSlot;
 		if (pDevice->wBasicRate & 0x0150) { //0000 0001 0101 0000,24M,12M,6M
 			pDevice->uCwMin = C_CWMIN_A;
@@ -1871,13 +1867,12 @@ unsigned char CARDbyGetPktType(void *pDeviceHandler)
 {
 	PSDevice pDevice = (PSDevice) pDeviceHandler;
 
-	if (pDevice->byBBType == BB_TYPE_11A || pDevice->byBBType == BB_TYPE_11B) {
+	if (pDevice->byBBType == BB_TYPE_11A || pDevice->byBBType == BB_TYPE_11B)
 		return (unsigned char)pDevice->byBBType;
-	} else if (CARDbIsOFDMinBasicRate((void *)pDevice)) {
+	else if (CARDbIsOFDMinBasicRate((void *)pDevice))
 		return PK_TYPE_11GA;
-	} else {
+	else
 		return PK_TYPE_11GB;
-	}
 }
 
 /*
@@ -1956,9 +1951,9 @@ QWORD CARDqGetTSFOffset(unsigned char byRxRate, QWORD qwTSF1, QWORD qwTSF2)
 	LODWORD(qwTSFOffset) = 0;
 	wRxBcnTSFOffst = cwRXBCNTSFOff[byRxRate%MAX_RATE];
 	(qwTSF2).u.dwLowDword += (unsigned long)(wRxBcnTSFOffst);
-	if ((qwTSF2).u.dwLowDword < (unsigned long)(wRxBcnTSFOffst)) {
+	if ((qwTSF2).u.dwLowDword < (unsigned long)(wRxBcnTSFOffst))
 		(qwTSF2).u.dwHighDword++;
-	}
+
 	LODWORD(qwTSFOffset) = LODWORD(qwTSF1) - LODWORD(qwTSF2);
 	if (LODWORD(qwTSF1) < LODWORD(qwTSF2)) {
 		// if borrow needed
diff --git a/drivers/staging/vt6655/channel.c b/drivers/staging/vt6655/channel.c
index e69c312..d5b89b7 100644
--- a/drivers/staging/vt6655/channel.c
+++ b/drivers/staging/vt6655/channel.c
@@ -420,9 +420,8 @@ void init_channel_table(void *pDeviceHandler)
 	bool bMultiBand = false;
 	unsigned int ii;
 
-	for (ii = 1; ii <= CARD_MAX_CHANNEL_TBL; ii++) {
+	for (ii = 1; ii <= CARD_MAX_CHANNEL_TBL; ii++)
 		sChannelTbl[ii].bValid = false;
-	}
 
 	switch (pDevice->byRFType) {
 	case RF_RFMD2959:
@@ -525,13 +524,11 @@ bool set_channel(void *pDeviceHandler, unsigned int uConnectionChannel)
 	PSDevice pDevice = (PSDevice) pDeviceHandler;
 	bool bResult = true;
 
-	if (pDevice->byCurrentCh == uConnectionChannel) {
+	if (pDevice->byCurrentCh == uConnectionChannel)
 		return bResult;
-	}
 
-	if (!sChannelTbl[uConnectionChannel].bValid) {
+	if (!sChannelTbl[uConnectionChannel].bValid)
 		return false;
-	}
 
 	if ((uConnectionChannel > CB_MAX_CHANNEL_24G) &&
 	    (pDevice->eCurrentPHYType != PHY_TYPE_11A)) {
@@ -546,9 +543,8 @@ bool set_channel(void *pDeviceHandler, unsigned int uConnectionChannel)
 	//{{ RobertYu: 20041202
 	//// TX_PE will reserve 3 us for MAX2829 A mode only, it is for better TX throughput
 
-	if (pDevice->byRFType == RF_AIROHA7230) {
+	if (pDevice->byRFType == RF_AIROHA7230)
 		RFbAL7230SelectChannelPostProcess(pDevice->PortOffset, pDevice->byCurrentCh, (unsigned char)uConnectionChannel);
-	}
 	//}} RobertYu
 
 	pDevice->byCurrentCh = (unsigned char)uConnectionChannel;
@@ -570,11 +566,10 @@ bool set_channel(void *pDeviceHandler, unsigned int uConnectionChannel)
 		MACvSelectPage0(pDevice->PortOffset);
 	}
 
-	if (pDevice->eCurrentPHYType == PHY_TYPE_11B) {
+	if (pDevice->eCurrentPHYType == PHY_TYPE_11B)
 		RFbSetPower(pDevice, RATE_1M, pDevice->byCurrentCh);
-	} else {
+	else
 		RFbSetPower(pDevice, RATE_6M, pDevice->byCurrentCh);
-	}
 
 	return bResult;
 }
@@ -601,15 +596,15 @@ void set_country_info(void *pDeviceHandler, CARD_PHY_TYPE ePHYType, void *pIE)
 
 	if (ePHYType == PHY_TYPE_11A) {
 		pDevice->bCountryInfo5G = true;
-		for (ii = CB_MAX_CHANNEL_24G + 1; ii <= CARD_MAX_CHANNEL_TBL; ii++) {
+		for (ii = CB_MAX_CHANNEL_24G + 1; ii <= CARD_MAX_CHANNEL_TBL; ii++)
 			sChannelTbl[ii].bValid = false;
-		}
+
 		step = 4;
 	} else {
 		pDevice->bCountryInfo24G = true;
-		for (ii = 1; ii <= CB_MAX_CHANNEL_24G; ii++) {
+		for (ii = 1; ii <= CB_MAX_CHANNEL_24G; ii++)
 			sChannelTbl[ii].bValid = false;
-		}
+
 		step = 1;
 	}
 	pDevice->abyCountryCode[0] = pIE_Country->abyCountryString[0];
@@ -652,19 +647,19 @@ unsigned char set_support_channels(void *pDeviceHandler, unsigned char *pbyIEs)
 	byCount = 0;
 	if (ChannelRuleTab[pDevice->byZoneType].bChannelIdxList[28] == true) {
 		for (ii = 28; ii < 36; ii += 2) {
-			if (ChannelRuleTab[pDevice->byZoneType].bChannelIdxList[ii] == true) {
+			if (ChannelRuleTab[pDevice->byZoneType].bChannelIdxList[ii] == true)
 				byCount++;
-			}
 		}
+
 		*pbyChTupple++ = 34;
 		*pbyChTupple++ = byCount;
 		byLen += 2;
 	} else if (ChannelRuleTab[pDevice->byZoneType].bChannelIdxList[29] == true) {
 		for (ii = 29; ii < 36; ii += 2) {
-			if (ChannelRuleTab[pDevice->byZoneType].bChannelIdxList[ii] == true) {
+			if (ChannelRuleTab[pDevice->byZoneType].bChannelIdxList[ii] == true)
 				byCount++;
-			}
 		}
+
 		*pbyChTupple++ = 36;
 		*pbyChTupple++ = byCount;
 		byLen += 2;
@@ -673,10 +668,10 @@ unsigned char set_support_channels(void *pDeviceHandler, unsigned char *pbyIEs)
 	byCount = 0;
 	if (ChannelRuleTab[pDevice->byZoneType].bChannelIdxList[36] == true) {
 		for (ii = 36; ii < 40; ii++) {
-			if (ChannelRuleTab[pDevice->byZoneType].bChannelIdxList[ii] == true) {
+			if (ChannelRuleTab[pDevice->byZoneType].bChannelIdxList[ii] == true)
 				byCount++;
-			}
 		}
+
 		*pbyChTupple++ = 52;
 		*pbyChTupple++ = byCount;
 		byLen += 2;
@@ -685,19 +680,19 @@ unsigned char set_support_channels(void *pDeviceHandler, unsigned char *pbyIEs)
 	byCount = 0;
 	if (ChannelRuleTab[pDevice->byZoneType].bChannelIdxList[40] == true) {
 		for (ii = 40; ii < 51; ii++) {
-			if (ChannelRuleTab[pDevice->byZoneType].bChannelIdxList[ii] == true) {
+			if (ChannelRuleTab[pDevice->byZoneType].bChannelIdxList[ii] == true)
 				byCount++;
-			}
 		}
+
 		*pbyChTupple++ = 100;
 		*pbyChTupple++ = byCount;
 		byLen += 2;
 	} else if (ChannelRuleTab[pDevice->byZoneType].bChannelIdxList[51] == true) {
 		for (ii = 51; ii < 56; ii++) {
-			if (ChannelRuleTab[pDevice->byZoneType].bChannelIdxList[ii] == true) {
+			if (ChannelRuleTab[pDevice->byZoneType].bChannelIdxList[ii] == true)
 				byCount++;
-			}
 		}
+
 		*pbyChTupple++ = 149;
 		*pbyChTupple++ = byCount;
 		byLen += 2;
@@ -764,14 +759,13 @@ unsigned char auto_channel_select(void *pDeviceHandler, CARD_PHY_TYPE ePHYType)
 	if (ePHYType == PHY_TYPE_11A) {
 		for (ii = CB_MAX_CHANNEL_24G + 1; ii <= CB_MAX_CHANNEL; ii++) {
 			if (sChannelTbl[ii].bValid) {
-				if (byOptionChannel == 0) {
+				if (byOptionChannel == 0)
 					byOptionChannel = (unsigned char) ii;
-				}
-				if (sChannelTbl[ii].byMAP == 0) {
+
+				if (sChannelTbl[ii].byMAP == 0)
 					return (unsigned char) ii;
-				} else if (!(sChannelTbl[ii].byMAP & 0x08)) {
+				else if (!(sChannelTbl[ii].byMAP & 0x08))
 					byOptionChannel = (unsigned char) ii;
-				}
 			}
 		}
 	} else {
@@ -781,25 +775,24 @@ unsigned char auto_channel_select(void *pDeviceHandler, CARD_PHY_TYPE ePHYType)
 				if (sChannelTbl[ii].byMAP == 0) {
 					aiWeight[ii] += 100;
 				} else if (sChannelTbl[ii].byMAP & 0x01) {
-					if (ii > 3) {
+					if (ii > 3)
 						aiWeight[ii - 3] -= 10;
-					}
-					if (ii > 2) {
+
+					if (ii > 2)
 						aiWeight[ii - 2] -= 20;
-					}
-					if (ii > 1) {
+
+					if (ii > 1)
 						aiWeight[ii - 1] -= 40;
-					}
+
 					aiWeight[ii] -= 80;
-					if (ii < CB_MAX_CHANNEL_24G) {
+					if (ii < CB_MAX_CHANNEL_24G)
 						aiWeight[ii + 1] -= 40;
-					}
-					if (ii < (CB_MAX_CHANNEL_24G - 1)) {
+
+					if (ii < (CB_MAX_CHANNEL_24G - 1))
 						aiWeight[ii+2] -= 20;
-					}
-					if (ii < (CB_MAX_CHANNEL_24G - 2)) {
+
+					if (ii < (CB_MAX_CHANNEL_24G - 2))
 						aiWeight[ii+3] -= 10;
-					}
 				}
 			}
 		}
diff --git a/drivers/staging/vt6655/datarate.c b/drivers/staging/vt6655/datarate.c
index d825a07..fd33350 100644
--- a/drivers/staging/vt6655/datarate.c
+++ b/drivers/staging/vt6655/datarate.c
@@ -253,9 +253,8 @@ RATEvParseMaxRate(
 		}
 	}
 
-	if ((pDevice->byPacketType == PK_TYPE_11GB) && CARDbIsOFDMinBasicRate((void *)pDevice)) {
+	if ((pDevice->byPacketType == PK_TYPE_11GB) && CARDbIsOFDMinBasicRate((void *)pDevice))
 		pDevice->byPacketType = PK_TYPE_11GA;
-	}
 
 	*pbyTopCCKRate = pDevice->byTopCCKBasicRate;
 	*pbyTopOFDMRate = pDevice->byTopOFDMBasicRate;
@@ -319,15 +318,14 @@ RATEvTxRateFallBack(
 		return;
 	}
 
-	if (psNodeDBTable->uTimeCount >= AUTORATE_TIMEOUT) {
+	if (psNodeDBTable->uTimeCount >= AUTORATE_TIMEOUT)
 		psNodeDBTable->uTimeCount = 0;
-	}
 
 	for (ii = 0; ii < MAX_RATE; ii++) {
 		if (psNodeDBTable->wSuppRate & (0x0001<<ii)) {
-			if (bAutoRate[ii]) {
+			if (bAutoRate[ii])
 				wIdxUpRate = (unsigned short) ii;
-			}
+
 		} else {
 			bAutoRate[ii] = false;
 		}
@@ -337,9 +335,9 @@ RATEvTxRateFallBack(
 		if ((psNodeDBTable->uTxOk[ii] != 0) ||
 		    (psNodeDBTable->uTxFail[ii] != 0)) {
 			dwThroughputTbl[ii] *= psNodeDBTable->uTxOk[ii];
-			if (ii < RATE_11M) {
+			if (ii < RATE_11M)
 				psNodeDBTable->uTxFail[ii] *= 4;
-			}
+
 			dwThroughputTbl[ii] /= (psNodeDBTable->uTxOk[ii] + psNodeDBTable->uTxFail[ii]);
 		}
 	}
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 024d840..3997d6d 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -593,9 +593,9 @@ static void device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
 		pDevice->byRFType &= RF_MASK;
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pDevice->byRFType = %x\n", pDevice->byRFType);
 
-		if (!pDevice->bZoneRegExist) {
+		if (!pDevice->bZoneRegExist)
 			pDevice->byZoneType = pDevice->abyEEPROM[EEP_OFS_ZONETYPE];
-		}
+
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pDevice->byZoneType = %x\n", pDevice->byZoneType);
 
 		//Init RF module
@@ -610,13 +610,13 @@ static void device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
 
 		for (ii = 0; ii < CB_MAX_CHANNEL_24G; ii++) {
 			pDevice->abyCCKPwrTbl[ii + 1] = SROMbyReadEmbedded(pDevice->PortOffset, (unsigned char)(ii + EEP_OFS_CCK_PWR_TBL));
-			if (pDevice->abyCCKPwrTbl[ii + 1] == 0) {
+			if (pDevice->abyCCKPwrTbl[ii + 1] == 0)
 				pDevice->abyCCKPwrTbl[ii+1] = pDevice->byCCKPwr;
-			}
+
 			pDevice->abyOFDMPwrTbl[ii + 1] = SROMbyReadEmbedded(pDevice->PortOffset, (unsigned char)(ii + EEP_OFS_OFDM_PWR_TBL));
-			if (pDevice->abyOFDMPwrTbl[ii + 1] == 0) {
+			if (pDevice->abyOFDMPwrTbl[ii + 1] == 0)
 				pDevice->abyOFDMPwrTbl[ii + 1] = pDevice->byOFDMPwrG;
-			}
+
 			pDevice->abyCCKDefaultPwr[ii + 1] = byCCKPwrdBm;
 			pDevice->abyOFDMDefaultPwr[ii + 1] = byOFDMPwrdBm;
 		}
@@ -672,11 +672,10 @@ static void device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
 
 		// Set BB and packet type at the same time.
 		// Set Short Slot Time, xIFS, and RSPINF.
-		if (pDevice->uConnectionRate == RATE_AUTO) {
+		if (pDevice->uConnectionRate == RATE_AUTO)
 			pDevice->wCurrentRate = RATE_54M;
-		} else {
+		else
 			pDevice->wCurrentRate = (unsigned short)pDevice->uConnectionRate;
-		}
 
 		// default G Mode
 		VNTWIFIbConfigPhyMode(pDevice->pMgmt, PHY_TYPE_11G);
@@ -692,22 +691,25 @@ static void device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
 			MACvGPIOIn(pDevice->PortOffset, &pDevice->byGPIO);
 //2008-4-14 <add> by chester for led issue
 #ifdef FOR_LED_ON_NOTEBOOK
-			if (pDevice->byGPIO & GPIO0_DATA) { pDevice->bHWRadioOff = true; }
-			if (!(pDevice->byGPIO & GPIO0_DATA)) { pDevice->bHWRadioOff = false; }
+			if (pDevice->byGPIO & GPIO0_DATA)
+				pDevice->bHWRadioOff = true;
 
+			if (!(pDevice->byGPIO & GPIO0_DATA))
+				pDevice->bHWRadioOff = false;
 		}
-		if (pDevice->bRadioControlOff) {
+
+		if (pDevice->bRadioControlOff)
 			CARDbRadioPowerOff(pDevice);
-		} else  CARDbRadioPowerOn(pDevice);
+		else
+			CARDbRadioPowerOn(pDevice);
 #else
 		if (((pDevice->byGPIO & GPIO0_DATA) && !(pDevice->byRadioCtl & EEP_RADIOCTL_INV)) ||
 		    (!(pDevice->byGPIO & GPIO0_DATA) && (pDevice->byRadioCtl & EEP_RADIOCTL_INV))) {
 			pDevice->bHWRadioOff = true;
 		}
 	}
-	if (pDevice->bHWRadioOff || pDevice->bRadioControlOff) {
+	if (pDevice->bHWRadioOff || pDevice->bRadioControlOff)
 		CARDbRadioPowerOff(pDevice);
-	}
 
 #endif
 }
@@ -1494,9 +1496,9 @@ static int device_tx_srv(PSDevice pDevice, unsigned int uIdx) {
 						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " Tx[%d] OK but has error. tsr1[%02X] tsr0[%02X].\n",
 							(int)uIdx, byTsr1, byTsr0);
 					}
-					if ((pTxBufHead->wFragCtl & FRAGCTL_ENDFRAG) != FRAGCTL_NONFRAG) {
+					if ((pTxBufHead->wFragCtl & FRAGCTL_ENDFRAG) != FRAGCTL_NONFRAG)
 						pDevice->s802_11Counter.TransmittedFragmentCount++;
-					}
+
 					pStats->tx_packets++;
 					pStats->tx_bytes += pTD->pTDInfo->skb->len;
 				} else {
@@ -1560,9 +1562,9 @@ static int device_tx_srv(PSDevice pDevice, unsigned int uIdx) {
 			bFull = true;
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " AC0DMA is Full = %d\n", pDevice->iTDUsed[uIdx]);
 		}
-		if (netif_queue_stopped(pDevice->dev) && !bFull) {
+		if (netif_queue_stopped(pDevice->dev) && !bFull)
 			netif_wake_queue(pDevice->dev);
-		}
+
 	}
 
 	pDevice->apTailTD[uIdx] = pTD;
@@ -1643,9 +1645,9 @@ static int  device_open(struct net_device *dev) {
 #endif
 
 	pDevice->rx_buf_sz = PKT_BUF_SZ;
-	if (!device_init_rings(pDevice)) {
+	if (!device_init_rings(pDevice))
 		return -ENOMEM;
-	}
+
 //2008-5-13 <add> by chester
 	i = request_irq(pDevice->pcid->irq, &device_intr, IRQF_SHARED, dev->name, dev);
 	if (i)
@@ -1666,9 +1668,9 @@ static int  device_open(struct net_device *dev) {
 	device_init_td0_ring(pDevice);
 	device_init_td1_ring(pDevice);
 
-	if (pDevice->bDiversityRegCtlON) {
+	if (pDevice->bDiversityRegCtlON)
 		device_init_diversity_timer(pDevice);
-	}
+
 	vMgrObjectInit(pDevice);
 	vMgrTimerInit(pDevice);
 
@@ -1855,9 +1857,9 @@ bool device_dma0_xmit(PSDevice pDevice, struct sk_buff *skb, unsigned int uNodeI
 	cbFrameBodySize = skb->len - ETH_HLEN;
 
 	// 802.1H
-	if (ntohs(pDevice->sTxEthHeader.wType) > ETH_DATA_LEN) {
+	if (ntohs(pDevice->sTxEthHeader.wType) > ETH_DATA_LEN)
 		cbFrameBodySize += 8;
-	}
+
 	uMACfragNum = cbGetFragCount(pDevice, pTransmitKey, cbFrameBodySize, &pDevice->sTxEthHeader);
 
 	if (uMACfragNum > AVAIL_TD(pDevice, TYPE_TXDMA0)) {
@@ -1868,11 +1870,10 @@ bool device_dma0_xmit(PSDevice pDevice, struct sk_buff *skb, unsigned int uNodeI
 
 	if (pDevice->bFixRate) {
 		if (pDevice->eCurrentPHYType == PHY_TYPE_11B) {
-			if (pDevice->uConnectionRate >= RATE_11M) {
+			if (pDevice->uConnectionRate >= RATE_11M)
 				pDevice->wCurrentRate = RATE_11M;
-			} else {
+			else
 				pDevice->wCurrentRate = (unsigned short)pDevice->uConnectionRate;
-			}
 		} else {
 			if (pDevice->uConnectionRate >= RATE_54M)
 				pDevice->wCurrentRate = RATE_54M;
@@ -1884,11 +1885,10 @@ bool device_dma0_xmit(PSDevice pDevice, struct sk_buff *skb, unsigned int uNodeI
 	}
 
 	//preamble type
-	if (pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble) {
+	if (pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble)
 		pDevice->byPreambleType = pDevice->byShortPreamble;
-	} else {
+	else
 		pDevice->byPreambleType = PREAMBLE_LONG;
-	}
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dma0: pDevice->wCurrentRate = %d \n", pDevice->wCurrentRate);
 
@@ -1897,11 +1897,10 @@ bool device_dma0_xmit(PSDevice pDevice, struct sk_buff *skb, unsigned int uNodeI
 	} else if (pDevice->eCurrentPHYType == PHY_TYPE_11A) {
 		byPktType = PK_TYPE_11A;
 	} else {
-		if (pDevice->bProtectMode) {
+		if (pDevice->bProtectMode)
 			byPktType = PK_TYPE_11GB;
-		} else {
+		else
 			byPktType = PK_TYPE_11GA;
-		}
 	}
 
 	if (pDevice->bEncryptionEnable)
@@ -2023,12 +2022,11 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
 					return 0;
 				}
 
-				if (pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble) {
+				if (pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble)
 					pDevice->byPreambleType = pDevice->byShortPreamble;
-
-				} else {
+				else
 					pDevice->byPreambleType = PREAMBLE_LONG;
-				}
+
 				bNodeExist = true;
 
 			}
@@ -2049,9 +2047,8 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
 	memcpy(pDevice->sTxEthHeader.abyDstAddr, (unsigned char *)(skb->data), ETH_HLEN);
 	cbFrameBodySize = skb->len - ETH_HLEN;
 	// 802.1H
-	if (ntohs(pDevice->sTxEthHeader.wType) > ETH_DATA_LEN) {
+	if (ntohs(pDevice->sTxEthHeader.wType) > ETH_DATA_LEN)
 		cbFrameBodySize += 8;
-	}
 
 	if (pDevice->bEncryptionEnable) {
 		bNeedEncryption = true;
@@ -2087,9 +2084,9 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
 			pbyBSSID = pDevice->abyBroadcastAddr;
 			if (KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, GROUP_KEY, &pTransmitKey) == false) {
 				pTransmitKey = NULL;
-				if (pDevice->pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) {
+				if (pDevice->pMgmt->eCurrMode == WMAC_MODE_IBSS_STA)
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG "IBSS and KEY is NULL. [%d]\n", pDevice->pMgmt->eCurrMode);
-				} else
+				else
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG "NOT IBSS and KEY is NULL. [%d]\n", pDevice->pMgmt->eCurrMode);
 			} else {
 				bTKIP_UseGTK = true;
@@ -2138,11 +2135,10 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
 #endif
 
 		if (pDevice->eCurrentPHYType == PHY_TYPE_11B) {
-			if (pDevice->uConnectionRate >= RATE_11M) {
+			if (pDevice->uConnectionRate >= RATE_11M)
 				pDevice->wCurrentRate = RATE_11M;
-			} else {
+			else
 				pDevice->wCurrentRate = (unsigned short)pDevice->uConnectionRate;
-			}
 		} else {
 			if ((pDevice->eCurrentPHYType == PHY_TYPE_11A) &&
 			    (pDevice->uConnectionRate <= RATE_6M)) {
@@ -2189,11 +2185,10 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
 	} else if (pDevice->eCurrentPHYType == PHY_TYPE_11A) {
 		byPktType = PK_TYPE_11A;
 	} else {
-		if (pDevice->bProtectMode) {
+		if (pDevice->bProtectMode)
 			byPktType = PK_TYPE_11GB;
-		} else {
+		else
 			byPktType = PK_TYPE_11GA;
-		}
 	}
 
 	if (bNeedEncryption) {
@@ -2268,9 +2263,8 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
 #ifdef TxInSleep
 	pDevice->nTxDataTimeCout = 0; //2008-8-21 chester <add> for send null packet
 #endif
-	if (AVAIL_TD(pDevice, TYPE_AC0DMA) <= 1) {
+	if (AVAIL_TD(pDevice, TYPE_AC0DMA) <= 1)
 		netif_stop_queue(dev);
-	}
 
 	pDevice->apCurrTD[TYPE_AC0DMA] = pHeadTD;
 
@@ -2343,9 +2337,9 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
 
 	//Make sure current page is 0
 	VNSvInPortB(pDevice->PortOffset + MAC_REG_PAGE1SEL, &byOrgPageSel);
-	if (byOrgPageSel == 1) {
+	if (byOrgPageSel == 1)
 		MACvSelectPage0(pDevice->PortOffset);
-	} else
+	else
 		byOrgPageSel = 0;
 
 	MACvReadMIBCounter(pDevice->PortOffset, &dwMIBCounter);
@@ -2383,9 +2377,9 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
 					MACvSelectPage0(pDevice->PortOffset);
 					pDevice->byBasicMap = 0;
 					pDevice->byCCAFraction = 0;
-					for (ii = 0; ii < 8; ii++) {
+					for (ii = 0; ii < 8; ii++)
 						pDevice->dwRPIs[ii] = 0;
-					}
+
 				} else {
 					// can not measure because set channel fail
 					// clear measure control
@@ -2484,9 +2478,8 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
 			}
 
 			pDevice->bBeaconSent = false;
-			if (pDevice->bEnablePSMode) {
+			if (pDevice->bEnablePSMode)
 				PSbIsNextTBTTWakeUp((void *)pDevice);
-			}
 
 			if ((pDevice->eOPMode == OP_MODE_AP) ||
 			    (pDevice->eOPMode == OP_MODE_ADHOC)) {
@@ -2534,18 +2527,18 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
 
 		}
 
-		if (pDevice->dwIsr & ISR_RXDMA0) {
+		if (pDevice->dwIsr & ISR_RXDMA0)
 			max_count += device_rx_srv(pDevice, TYPE_RXDMA0);
-		}
-		if (pDevice->dwIsr & ISR_RXDMA1) {
+
+		if (pDevice->dwIsr & ISR_RXDMA1)
 			max_count += device_rx_srv(pDevice, TYPE_RXDMA1);
-		}
-		if (pDevice->dwIsr & ISR_TXDMA0) {
+
+		if (pDevice->dwIsr & ISR_TXDMA0)
 			max_count += device_tx_srv(pDevice, TYPE_TXDMA0);
-		}
-		if (pDevice->dwIsr & ISR_AC0DMA) {
+
+		if (pDevice->dwIsr & ISR_AC0DMA)
 			max_count += device_tx_srv(pDevice, TYPE_AC0DMA);
-		}
+
 		if (pDevice->dwIsr & ISR_SOFTTIMER1) {
 			if (pDevice->eOPMode == OP_MODE_AP) {
 				if (pDevice->bShortSlotTime)
@@ -2566,9 +2559,8 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
 			break;
 	}
 
-	if (byOrgPageSel == 1) {
+	if (byOrgPageSel == 1)
 		MACvSelectPage1(pDevice->PortOffset);
-	}
 
 	spin_unlock_irq(&pDevice->lock);
 	MACvIntEnable(pDevice->PortOffset, IMR_MASK_VALUE);
@@ -3059,9 +3051,9 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 				rc = 0;
 			}
 
-		if (test_and_set_bit(0, (void *)&(pMgmt->uCmdBusy))) {
+		if (test_and_set_bit(0, (void *)&(pMgmt->uCmdBusy)))
 			return -EBUSY;
-		}
+
 		rc = private_ioctl(pDevice, rq);
 		clear_bit(0, (void *)&(pMgmt->uCmdBusy));
 		break;
diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index 37fa4af..c560361 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -181,11 +181,11 @@ s_vProcessRxMACHeader(PSDevice pDevice, unsigned char *pbyRxBufferAddr,
 			cbHeaderSize -= 8;
 			pwType = (unsigned short *)(pbyRxBufferAddr + cbHeaderSize);
 			if (bIsWEP) {
-				if (bExtIV) {
+				if (bExtIV)
 					*pwType = htons(cbPacketSize - WLAN_HDR_ADDR3_LEN - 8);    // 8 is IV&ExtIV
-				} else {
+				else
 					*pwType = htons(cbPacketSize - WLAN_HDR_ADDR3_LEN - 4);    // 4 is IV
-				}
+
 			} else {
 				*pwType = htons(cbPacketSize - WLAN_HDR_ADDR3_LEN);
 			}
@@ -194,11 +194,11 @@ s_vProcessRxMACHeader(PSDevice pDevice, unsigned char *pbyRxBufferAddr,
 		cbHeaderSize -= 2;
 		pwType = (unsigned short *)(pbyRxBufferAddr + cbHeaderSize);
 		if (bIsWEP) {
-			if (bExtIV) {
+			if (bExtIV)
 				*pwType = htons(cbPacketSize - WLAN_HDR_ADDR3_LEN - 8);    // 8 is IV&ExtIV
-			} else {
+			else
 				*pwType = htons(cbPacketSize - WLAN_HDR_ADDR3_LEN - 4);    // 4 is IV
-			}
+
 		} else {
 			*pwType = htons(cbPacketSize - WLAN_HDR_ADDR3_LEN);
 		}
@@ -222,6 +222,7 @@ static unsigned char s_byGetRateIdx(unsigned char byRate)
 		if (acbyRxRate[byRateIdx % MAX_RATE] == byRate)
 			return byRateIdx;
 	}
+
 	return 0;
 }
 
@@ -372,9 +373,9 @@ device_receive_frame(
 	pMACHeader = (PS802_11Header)((unsigned char *)(skb->data) + 8);
 //PLICE_DEBUG<-
 	if (pDevice->bMeasureInProgress) {
-		if ((*pbyRsr & RSR_CRCOK) != 0) {
+		if ((*pbyRsr & RSR_CRCOK) != 0)
 			pDevice->byBasicMap |= 0x01;
-		}
+
 		dwDuration = (FrameSize << 4);
 		dwDuration /= acbyRxRate[*pbyRxRate%MAX_RATE];
 		if (*pbyRxRate <= RATE_11M) {
@@ -391,9 +392,9 @@ device_receive_frame(
 		RFvRSSITodBm(pDevice, *pbyRSSI, &ldBm);
 		ldBmThreshold = -57;
 		for (ii = 7; ii > 0;) {
-			if (ldBm > ldBmThreshold) {
+			if (ldBm > ldBmThreshold)
 				break;
-			}
+
 			ldBmThreshold -= 5;
 			ii--;
 		}
@@ -428,9 +429,8 @@ device_receive_frame(
 	}
 
 	if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
-		if (s_bAPModeRxCtl(pDevice, pbyFrame, iSANodeIndex)) {
+		if (s_bAPModeRxCtl(pDevice, pbyFrame, iSANodeIndex))
 			return false;
-		}
 	}
 
 	if (IS_FC_WEP(pbyFrame)) {
@@ -639,9 +639,9 @@ device_receive_frame(
 		BBvAntennaDiversity(pDevice, s_byGetRateIdx(*pbyRxRate), 0);
 	}
 
-	if (pDevice->byLocalID != REV_ID_VT3253_B1) {
+	if (pDevice->byLocalID != REV_ID_VT3253_B1)
 		pDevice->uCurrRSSI = *pbyRSSI;
-	}
+
 	pDevice->byCurrSQ = *pbySQ;
 
 	if ((*pbyRSSI != 0) &&
@@ -651,11 +651,10 @@ device_receive_frame(
 		pMgmt->pCurrBSS->byRSSIStatCnt++;
 		pMgmt->pCurrBSS->byRSSIStatCnt %= RSSI_STAT_COUNT;
 		pMgmt->pCurrBSS->ldBmAverage[pMgmt->pCurrBSS->byRSSIStatCnt] = ldBm;
-		for (ii = 0; ii < RSSI_STAT_COUNT; ii++) {
-			if (pMgmt->pCurrBSS->ldBmAverage[ii] != 0) {
+		for (ii = 0; ii < RSSI_STAT_COUNT; ii++)
+			if (pMgmt->pCurrBSS->ldBmAverage[ii] != 0)
 				pMgmt->pCurrBSS->ldBmMAX = max(pMgmt->pCurrBSS->ldBmAverage[ii], ldBm);
-			}
-		}
+
 	}
 
 	// -----------------------------------------------
@@ -698,9 +697,8 @@ device_receive_frame(
 	}
 
 	if ((pKey != NULL) && (pKey->byCipherSuite == KEY_CTL_TKIP)) {
-		if (bIsWEP) {
+		if (bIsWEP)
 			FrameSize -= 8;  //MIC
-		}
 	}
 
 	//--------------------------------------------------------------------------------
@@ -1093,9 +1091,9 @@ static bool s_bHandleRxEncryption(
 			rc4_init(&pDevice->SBox, pDevice->abyPRNG, pKey->uKeyLength + 3);
 			rc4_encrypt(&pDevice->SBox, pbyIV+4, pbyIV+4, PayloadLen);
 
-			if (ETHbIsBufferCrc32Ok(pbyIV+4, PayloadLen)) {
+			if (ETHbIsBufferCrc32Ok(pbyIV+4, PayloadLen))
 				*pbyNewRsr |= NEWRSR_DECRYPTOK;
-			}
+
 		}
 	} else if ((byDecMode == KEY_CTL_TKIP) ||
 		   (byDecMode == KEY_CTL_CCMP)) {
@@ -1104,11 +1102,11 @@ static bool s_bHandleRxEncryption(
 		PayloadLen -= (WLAN_HDR_ADDR3_LEN + 8 + 4); // 24 is 802.11 header, 8 is IV&ExtIV, 4 is crc
 		*pdwRxTSC47_16 = cpu_to_le32(*(unsigned long *)(pbyIV + 4));
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ExtIV: %lx\n", *pdwRxTSC47_16);
-		if (byDecMode == KEY_CTL_TKIP) {
+		if (byDecMode == KEY_CTL_TKIP)
 			*pwRxTSC15_0 = cpu_to_le16(MAKEWORD(*(pbyIV + 2), *pbyIV));
-		} else {
+		else
 			*pwRxTSC15_0 = cpu_to_le16(*(unsigned short *)pbyIV);
-		}
+
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "TSC0_15: %x\n", *pwRxTSC15_0);
 
 		if ((byDecMode == KEY_CTL_TKIP) &&
@@ -1193,9 +1191,9 @@ static bool s_bHostWepRxEncryption(
 			rc4_init(&pDevice->SBox, pDevice->abyPRNG, pKey->uKeyLength + 3);
 			rc4_encrypt(&pDevice->SBox, pbyIV+4, pbyIV+4, PayloadLen);
 
-			if (ETHbIsBufferCrc32Ok(pbyIV+4, PayloadLen)) {
+			if (ETHbIsBufferCrc32Ok(pbyIV+4, PayloadLen))
 				*pbyNewRsr |= NEWRSR_DECRYPTOK;
-			}
+
 		}
 	} else if ((byDecMode == KEY_CTL_TKIP) ||
 		   (byDecMode == KEY_CTL_CCMP)) {
@@ -1205,11 +1203,11 @@ static bool s_bHostWepRxEncryption(
 		*pdwRxTSC47_16 = cpu_to_le32(*(unsigned long *)(pbyIV + 4));
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ExtIV: %lx\n", *pdwRxTSC47_16);
 
-		if (byDecMode == KEY_CTL_TKIP) {
+		if (byDecMode == KEY_CTL_TKIP)
 			*pwRxTSC15_0 = cpu_to_le16(MAKEWORD(*(pbyIV+2), *pbyIV));
-		} else {
+		else
 			*pwRxTSC15_0 = cpu_to_le16(*(unsigned short *)pbyIV);
-		}
+
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "TSC0_15: %x\n", *pwRxTSC15_0);
 
 		if (byDecMode == KEY_CTL_TKIP) {
@@ -1322,9 +1320,8 @@ static bool s_bAPModeRxData(
 		if (bRelayAndForward)
 			iDANodeIndex = 0;
 
-		if ((pDevice->uAssocCount > 1) && (iDANodeIndex >= 0)) {
+		if ((pDevice->uAssocCount > 1) && (iDANodeIndex >= 0))
 			ROUTEbRelay(pDevice, (unsigned char *)(skb->data + cbHeaderOffset), FrameSize, (unsigned int)iDANodeIndex);
-		}
 
 		if (bRelayOnly)
 			return false;
diff --git a/drivers/staging/vt6655/hostap.c b/drivers/staging/vt6655/hostap.c
index 15c57452..f55d0fb 100644
--- a/drivers/staging/vt6655/hostap.c
+++ b/drivers/staging/vt6655/hostap.c
@@ -206,11 +206,11 @@ static int hostap_remove_sta(PSDevice pDevice,
 {
 	unsigned int uNodeIndex;
 
-	if (BSSDBbIsSTAInNodeDB(pDevice->pMgmt, param->sta_addr, &uNodeIndex)) {
+	if (BSSDBbIsSTAInNodeDB(pDevice->pMgmt, param->sta_addr, &uNodeIndex))
 		BSSvRemoveOneNode(pDevice, uNodeIndex);
-	} else {
+	else
 		return -ENOENT;
-	}
+
 	return 0;
 }
 
@@ -233,9 +233,9 @@ static int hostap_add_sta(PSDevice pDevice,
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 	unsigned int uNodeIndex;
 
-	if (!BSSDBbIsSTAInNodeDB(pMgmt, param->sta_addr, &uNodeIndex)) {
+	if (!BSSDBbIsSTAInNodeDB(pMgmt, param->sta_addr, &uNodeIndex))
 		BSSvCreateOneNode((PSDevice)pDevice, &uNodeIndex);
-	}
+
 	memcpy(pMgmt->sNodeDBTable[uNodeIndex].abyMACAddr, param->sta_addr, WLAN_ADDR_LEN);
 	pMgmt->sNodeDBTable[uNodeIndex].eNodeState = NODE_ASSOC;
 	pMgmt->sNodeDBTable[uNodeIndex].wCapInfo = param->u.add_sta.capability;
@@ -660,9 +660,8 @@ static int hostap_get_encryption(PSDevice pDevice,
 	}
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "hostap_get_encryption: %d\n", iNodeIndex);
 	memset(param->u.crypt.seq, 0, 8);
-	for (ii = 0; ii < 8; ii++) {
+	for (ii = 0; ii < 8; ii++)
 		param->u.crypt.seq[ii] = (unsigned char)pMgmt->sNodeDBTable[iNodeIndex].KeyRSC >> (ii * 8);
-	}
 
 	return ret;
 }
@@ -767,9 +766,8 @@ int vt6655_hostap_ioctl(PSDevice pDevice, struct iw_point *p)
 	}
 
 	if ((ret == 0) && ap_ioctl) {
-		if (copy_to_user(p->pointer, param, p->length)) {
+		if (copy_to_user(p->pointer, param, p->length))
 			ret = -EFAULT;
-		}
 	}
 
 out:
diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index e063913..71c5e08 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -235,11 +235,11 @@ int iwctl_giwscan(struct net_device *dev,
 			//ADD mode
 			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = SIOCGIWMODE;
-			if (WLAN_GET_CAP_INFO_ESS(pBSS->wCapInfo)) {
+			if (WLAN_GET_CAP_INFO_ESS(pBSS->wCapInfo))
 				iwe.u.mode = IW_MODE_INFRA;
-			} else {
+			else
 				iwe.u.mode = IW_MODE_ADHOC;
-			}
+
 			iwe.len = IW_EV_UINT_LEN;
 			current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe, IW_EV_UINT_LEN);
 			//ADD frequency
@@ -266,13 +266,13 @@ int iwctl_giwscan(struct net_device *dev,
 			iwe.u.qual.level = ldBm;
 			iwe.u.qual.noise = 0;
 //2008-0409-01, <Add> by Einsn Liu
-			if (-ldBm < 50) {
+			if (-ldBm < 50)
 				iwe.u.qual.qual = 100;
-			} else if (-ldBm > 90) {
+			else if (-ldBm > 90)
 				iwe.u.qual.qual = 0;
-			} else {
+			else
 				iwe.u.qual.qual = (40 - (-ldBm - 50)) * 100 / 40;
-			}
+
 			iwe.u.qual.updated = 7;
 
 			current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe, IW_EV_QUAL_LEN);
@@ -280,11 +280,11 @@ int iwctl_giwscan(struct net_device *dev,
 			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = SIOCGIWENCODE;
 			iwe.u.data.length = 0;
-			if (WLAN_GET_CAP_INFO_PRIVACY(pBSS->wCapInfo)) {
+			if (WLAN_GET_CAP_INFO_PRIVACY(pBSS->wCapInfo))
 				iwe.u.data.flags = IW_ENCODE_ENABLED | IW_ENCODE_NOKEY;
-			} else {
+			else
 				iwe.u.data.flags = IW_ENCODE_DISABLED;
-			}
+
 			current_ev = iwe_stream_add_point(info, current_ev, end_buf, &iwe, pItemSSID->abySSID);
 
 			memset(&iwe, 0, sizeof(iwe));
@@ -437,9 +437,9 @@ int iwctl_siwmode(struct net_device *dev,
 	case IW_MODE_ADHOC:
 		if (pMgmt->eConfigMode != WMAC_CONFIG_IBSS_STA) {
 			pMgmt->eConfigMode = WMAC_CONFIG_IBSS_STA;
-			if (pDevice->flags & DEVICE_FLAGS_OPENED) {
+			if (pDevice->flags & DEVICE_FLAGS_OPENED)
 				pDevice->bCommit = true;
-			}
+
 		}
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set mode to ad-hoc \n");
 		break;
@@ -447,9 +447,9 @@ int iwctl_siwmode(struct net_device *dev,
 	case IW_MODE_INFRA:
 		if (pMgmt->eConfigMode != WMAC_CONFIG_ESS_STA) {
 			pMgmt->eConfigMode = WMAC_CONFIG_ESS_STA;
-			if (pDevice->flags & DEVICE_FLAGS_OPENED) {
+			if (pDevice->flags & DEVICE_FLAGS_OPENED)
 				pDevice->bCommit = true;
-			}
+
 		}
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set mode to infrastructure \n");
 		break;
@@ -461,9 +461,9 @@ int iwctl_siwmode(struct net_device *dev,
 
 		if (pMgmt->eConfigMode != WMAC_CONFIG_AP) {
 			pMgmt->eConfigMode = WMAC_CONFIG_AP;
-			if (pDevice->flags & DEVICE_FLAGS_OPENED) {
+			if (pDevice->flags & DEVICE_FLAGS_OPENED)
 				pDevice->bCommit = true;
-			}
+
 		}
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set mode to Access Point \n");
 		break;
@@ -670,9 +670,9 @@ int iwctl_siwap(struct net_device *dev,
 			}
 		}
 
-		if (pDevice->flags & DEVICE_FLAGS_OPENED) {
+		if (pDevice->flags & DEVICE_FLAGS_OPENED)
 			pDevice->bCommit = true;
-		}
+
 	}
 	return rc;
 }
@@ -696,9 +696,8 @@ int iwctl_giwap(struct net_device *dev,
 	if ((pDevice->bLinkPass == false) && (pMgmt->eCurrMode != WMAC_MODE_ESS_AP))
 		memset(wrq->sa_data, 0, 6);
 
-	if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
+	if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP)
 		memcpy(wrq->sa_data, pMgmt->abyCurrBSSID, 6);
-	}
 
 	wrq->sa_family = ARPHRD_ETHER;
 
@@ -857,9 +856,8 @@ int iwctl_siwessid(struct net_device *dev,
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set essid = %s \n", pItemSSID->abySSID);
 	}
 
-	if (pDevice->flags & DEVICE_FLAGS_OPENED) {
+	if (pDevice->flags & DEVICE_FLAGS_OPENED)
 		pDevice->bCommit = true;
-	}
 
 	return 0;
 }
@@ -1038,11 +1036,11 @@ int iwctl_siwrts(struct net_device *dev,
 		int rthr = wrq->value;
 		if (wrq->disabled)
 			rthr = 2312;
-		if ((rthr < 0) || (rthr > 2312)) {
+
+		if ((rthr < 0) || (rthr > 2312))
 			rc = -EINVAL;
-		} else {
+		else
 			pDevice->wRTSThreshold = rthr;
-		}
 	}
 
 	return 0;
@@ -1142,9 +1140,8 @@ int iwctl_siwretry(struct net_device *dev,
 			pDevice->byLongRetryLimit = wrq->value;
 		}
 	}
-	if (wrq->flags & IW_RETRY_LIFETIME) {
+	if (wrq->flags & IW_RETRY_LIFETIME)
 		pDevice->wMaxTransmitMSDULifetime = wrq->value;
-	}
 
 	return rc;
 }
@@ -1214,10 +1211,13 @@ int iwctl_siwencode(struct net_device *dev,
 		}
 
 		if (dwKeyIndex < 1 && ((wrq->flags & IW_ENCODE_NOKEY) == 0)) {//set default key
-			if (pDevice->byKeyIndex < WLAN_WEP_NKEYS) {
+			if (pDevice->byKeyIndex < WLAN_WEP_NKEYS)
 				dwKeyIndex = pDevice->byKeyIndex;
-			} else dwKeyIndex = 0;
-		} else dwKeyIndex--;
+			else
+				dwKeyIndex = 0;
+		} else {
+			dwKeyIndex--;
+		}
 
 		// Check the size of the key
 		if (wrq->length > WLAN_WEP232_KEYLEN) {
@@ -1241,9 +1241,8 @@ int iwctl_siwencode(struct net_device *dev,
 			memcpy(pDevice->abyKey, extra, wrq->length);
 
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "abyKey: ");
-			for (ii = 0; ii < wrq->length; ii++) {
+			for (ii = 0; ii < wrq->length; ii++)
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%02x ", pDevice->abyKey[ii]);
-			}
 
 			if (pDevice->flags & DEVICE_FLAGS_OPENED) {
 				spin_lock_irq(&pDevice->lock);
@@ -1324,16 +1323,17 @@ int iwctl_giwencode(struct net_device *dev,
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWENCODE\n");
 
-	if (index > WLAN_WEP_NKEYS) {
+	if (index > WLAN_WEP_NKEYS)
 		return	-EINVAL;
-	}
+
 	if (index < 1) {//get default key
-		if (pDevice->byKeyIndex < WLAN_WEP_NKEYS) {
+		if (pDevice->byKeyIndex < WLAN_WEP_NKEYS)
 			index = pDevice->byKeyIndex;
-		} else
+		else
 			index = 0;
-	} else
+	} else {
 		index--;
+	}
 
 	memset(abyKey, 0, WLAN_WEP232_KEYLEN);
 	// Check encryption mode
@@ -1490,37 +1490,36 @@ int iwctl_siwauth(struct net_device *dev,
 	switch (wrq->flags & IW_AUTH_INDEX) {
 	case IW_AUTH_WPA_VERSION:
 		wpa_version = wrq->value;
-		if (wrq->value == IW_AUTH_WPA_VERSION_DISABLED) {
+		if (wrq->value == IW_AUTH_WPA_VERSION_DISABLED)
 			PRINT_K("iwctl_siwauth:set WPADEV to disable at 1??????\n");
-		} else if (wrq->value == IW_AUTH_WPA_VERSION_WPA) {
+		else if (wrq->value == IW_AUTH_WPA_VERSION_WPA)
 			PRINT_K("iwctl_siwauth:set WPADEV to WPA1******\n");
-		} else {
+		else
 			PRINT_K("iwctl_siwauth:set WPADEV to WPA2******\n");
-		}
 
 		break;
 	case IW_AUTH_CIPHER_PAIRWISE:
 		pairwise = wrq->value;
-		if (pairwise == IW_AUTH_CIPHER_CCMP) {
+		if (pairwise == IW_AUTH_CIPHER_CCMP)
 			pDevice->eEncryptionStatus = Ndis802_11Encryption3Enabled;
-		} else if (pairwise == IW_AUTH_CIPHER_TKIP) {
+		else if (pairwise == IW_AUTH_CIPHER_TKIP)
 			pDevice->eEncryptionStatus = Ndis802_11Encryption2Enabled;
-		} else if (pairwise == IW_AUTH_CIPHER_WEP40 || pairwise == IW_AUTH_CIPHER_WEP104) {
+		else if (pairwise == IW_AUTH_CIPHER_WEP40 || pairwise == IW_AUTH_CIPHER_WEP104)
 			pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
-		} else if (pairwise == IW_AUTH_CIPHER_NONE) {
-			//do nothing,einsn liu
-		} else pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
+		else if (pairwise == IW_AUTH_CIPHER_NONE)
+			; /* do nothing,einsn liu */
+		else
+			pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 
 		break;
 	case IW_AUTH_CIPHER_GROUP:
 		if (wpa_version == IW_AUTH_WPA_VERSION_DISABLED)
 			break;
 		if (pairwise == IW_AUTH_CIPHER_NONE) {
-			if (wrq->value == IW_AUTH_CIPHER_CCMP) {
+			if (wrq->value == IW_AUTH_CIPHER_CCMP)
 				pDevice->eEncryptionStatus = Ndis802_11Encryption3Enabled;
-			} else {
+			else
 				pDevice->eEncryptionStatus = Ndis802_11Encryption2Enabled;
-			}
 		}
 		break;
 	case IW_AUTH_KEY_MGMT:
@@ -1528,13 +1527,15 @@ int iwctl_siwauth(struct net_device *dev,
 		if (wpa_version == IW_AUTH_WPA_VERSION_WPA2) {
 			if (wrq->value == IW_AUTH_KEY_MGMT_PSK)
 				pMgmt->eAuthenMode = WMAC_AUTH_WPA2PSK;
-			else pMgmt->eAuthenMode = WMAC_AUTH_WPA2;
+			else
+				pMgmt->eAuthenMode = WMAC_AUTH_WPA2;
 		} else if (wpa_version == IW_AUTH_WPA_VERSION_WPA) {
-			if (wrq->value == 0) {
+			if (wrq->value == 0)
 				pMgmt->eAuthenMode = WMAC_AUTH_WPANONE;
-			} else if (wrq->value == IW_AUTH_KEY_MGMT_PSK)
+			else if (wrq->value == IW_AUTH_KEY_MGMT_PSK)
 				pMgmt->eAuthenMode = WMAC_AUTH_WPAPSK;
-			else pMgmt->eAuthenMode = WMAC_AUTH_WPA;
+			else
+				pMgmt->eAuthenMode = WMAC_AUTH_WPA;
 		}
 
 		break;
@@ -1543,11 +1544,11 @@ int iwctl_siwauth(struct net_device *dev,
 	case IW_AUTH_DROP_UNENCRYPTED:
 		break;
 	case IW_AUTH_80211_AUTH_ALG:
-		if (wrq->value == IW_AUTH_ALG_OPEN_SYSTEM) {
+		if (wrq->value == IW_AUTH_ALG_OPEN_SYSTEM)
 			pMgmt->bShareKeyAlgorithm = false;
-		} else if (wrq->value == IW_AUTH_ALG_SHARED_KEY) {
+		else if (wrq->value == IW_AUTH_ALG_SHARED_KEY)
 			pMgmt->bShareKeyAlgorithm = true;
-		}
+
 		break;
 	case IW_AUTH_WPA_ENABLED:
 		break;
@@ -1630,11 +1631,12 @@ int iwctl_giwgenie(struct net_device *dev,
 	if (pMgmt->wWPAIELen > 0) {
 		wrq->length = pMgmt->wWPAIELen;
 		if (pMgmt->wWPAIELen <= space) {
-			if (copy_to_user(extra, pMgmt->abyWPAIE, pMgmt->wWPAIELen)) {
+			if (copy_to_user(extra, pMgmt->abyWPAIE, pMgmt->wWPAIELen))
 				ret = -EFAULT;
-			}
-		} else
+
+		} else {
 			ret = -E2BIG;
+		}
 	}
 
 	return ret;
@@ -1730,18 +1732,18 @@ int iwctl_siwencodeext(struct net_device *dev,
 //****set if current action is Network Manager count??
 //****this method is so foolish,but there is no other way???
 	if (param->u.wpa_key.alg_name == WPA_ALG_NONE) {
-		if (param->u.wpa_key.key_index == 0) {
+		if (param->u.wpa_key.key_index == 0)
 			pDevice->bwextcount++;
-		}
-		if ((pDevice->bwextcount == 1) && (param->u.wpa_key.key_index == 1)) {
+
+		if ((pDevice->bwextcount == 1) && (param->u.wpa_key.key_index == 1))
 			pDevice->bwextcount++;
-		}
-		if ((pDevice->bwextcount == 2) && (param->u.wpa_key.key_index == 2)) {
+
+		if ((pDevice->bwextcount == 2) && (param->u.wpa_key.key_index == 2))
 			pDevice->bwextcount++;
-		}
-		if ((pDevice->bwextcount == 3) && (param->u.wpa_key.key_index == 3)) {
+
+		if ((pDevice->bwextcount == 3) && (param->u.wpa_key.key_index == 3))
 			pDevice->bwextcount++;
-		}
+
 	}
 	if (pDevice->bwextcount == 4) {
 		printk("SIOCSIWENCODEEXT:Enable WPA WEXT SUPPORT!!!!!\n");
diff --git a/drivers/staging/vt6655/key.c b/drivers/staging/vt6655/key.c
index 54de7d0..09a8bf5 100644
--- a/drivers/staging/vt6655/key.c
+++ b/drivers/staging/vt6655/key.c
@@ -255,9 +255,9 @@ bool KeybSetKey(
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "KeybSetKey(R): \n");
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->bKeyValid: %d\n ", pKey->bKeyValid);
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->abyKey: ");
-			for (ii = 0; ii < pKey->uKeyLength; ii++) {
+			for (ii = 0; ii < pKey->uKeyLength; ii++)
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%02x ", pKey->abyKey[ii]);
-			}
+
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "\n");
 
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->dwTSC47_16: %lx\n ", pKey->dwTSC47_16);
@@ -319,9 +319,9 @@ bool KeybSetKey(
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->bKeyValid: %d\n ", pKey->bKeyValid);
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->uKeyLength: %d\n ", (int)pKey->uKeyLength);
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->abyKey: ");
-		for (ii = 0; ii < pKey->uKeyLength; ii++) {
+		for (ii = 0; ii < pKey->uKeyLength; ii++)
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%02x ", pKey->abyKey[ii]);
-		}
+
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "\n");
 
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->dwTSC47_16: %lx\n ", pKey->dwTSC47_16);
@@ -359,9 +359,9 @@ bool KeybRemoveKey(
 	if (is_broadcast_ether_addr(pbyBSSID)) {
 		// delete all keys
 		if ((dwKeyIndex & PAIRWISE_KEY) != 0) {
-			for (i = 0; i < MAX_KEY_TABLE; i++) {
+			for (i = 0; i < MAX_KEY_TABLE; i++)
 				pTable->KeyTable[i].PairwiseKey.bKeyValid = false;
-			}
+
 			s_vCheckKeyTableValid(pTable, dwIoBase);
 			return true;
 		} else if ((dwKeyIndex & 0x000000FF) < MAX_GROUP_KEY) {
@@ -427,9 +427,9 @@ bool KeybRemoveAllKey(
 		if (pTable->KeyTable[i].bInUse &&
 		    ether_addr_equal(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
 			pTable->KeyTable[i].PairwiseKey.bKeyValid = false;
-			for (u = 0; u < MAX_GROUP_KEY; u++) {
+			for (u = 0; u < MAX_GROUP_KEY; u++)
 				pTable->KeyTable[i].GroupKey[u].bKeyValid = false;
-			}
+
 			pTable->KeyTable[i].dwGTKeyIndex = 0;
 			s_vCheckKeyTableValid(pTable, dwIoBase);
 			return true;
@@ -478,9 +478,8 @@ void KeyvRemoveAllWEPKey(
 {
 	int i;
 
-	for (i = 0; i < MAX_GROUP_KEY; i++) {
+	for (i = 0; i < MAX_GROUP_KEY; i++)
 		KeyvRemoveWEPKey(pTable, i, dwIoBase);
-	}
 }
 
 /*
@@ -515,9 +514,9 @@ bool KeybGetTransmitKey(
 
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "KeybGetTransmitKey:");
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "PAIRWISE_KEY: KeyTable.abyBSSID: ");
-					for (ii = 0; ii < 6; ii++) {
+					for (ii = 0; ii < 6; ii++)
 						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%x ", pTable->KeyTable[i].abyBSSID[ii]);
-					}
+
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "\n");
 
 					return true;
@@ -536,9 +535,9 @@ bool KeybGetTransmitKey(
 
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "KeybGetTransmitKey:");
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "GROUP_KEY: KeyTable.abyBSSID\n");
-					for (ii = 0; ii < 6; ii++) {
+					for (ii = 0; ii < 6; ii++)
 						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%x ", pTable->KeyTable[i].abyBSSID[ii]);
-					}
+
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "\n");
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dwGTKeyIndex: %lX\n", pTable->KeyTable[i].dwGTKeyIndex);
 
@@ -551,9 +550,9 @@ bool KeybGetTransmitKey(
 		} // BSSID match
 	}
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ERROR: NO Match BSSID !!! ");
-	for (ii = 0; ii < 6; ii++) {
+	for (ii = 0; ii < 6; ii++)
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%02x ", *(pbyBSSID+ii));
-	}
+
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "\n");
 	return false;
 }
@@ -621,11 +620,10 @@ bool KeybSetDefaultKey(
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enter KeybSetDefaultKey: %1x, %d \n", (int)dwKeyIndex, (int)uKeyLength);
 
-	if ((dwKeyIndex & PAIRWISE_KEY) != 0) {                  // Pairwise key
+	if ((dwKeyIndex & PAIRWISE_KEY) != 0) // Pairwise key
 		return false;
-	} else if ((dwKeyIndex & 0x000000FF) >= MAX_GROUP_KEY) {
+	else if ((dwKeyIndex & 0x000000FF) >= MAX_GROUP_KEY)
 		return false;
-	}
 
 	if (uKeyLength > MAX_KEY_LEN)
 		return false;
@@ -683,9 +681,9 @@ bool KeybSetDefaultKey(
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->bKeyValid: %d\n", pKey->bKeyValid);
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->uKeyLength: %d\n", (int)pKey->uKeyLength);
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->abyKey: \n");
-	for (ii = 0; ii < pKey->uKeyLength; ii++) {
+	for (ii = 0; ii < pKey->uKeyLength; ii++)
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%x", pKey->abyKey[ii]);
-	}
+
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "\n");
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->dwTSC47_16: %lx\n", pKey->dwTSC47_16);
@@ -729,11 +727,10 @@ bool KeybSetAllGroupKey(
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enter KeybSetAllGroupKey: %lX\n", dwKeyIndex);
 
-	if ((dwKeyIndex & PAIRWISE_KEY) != 0) {                  // Pairwise key
+	if ((dwKeyIndex & PAIRWISE_KEY) != 0) // Pairwise key
 		return false;
-	} else if ((dwKeyIndex & 0x000000FF) >= MAX_GROUP_KEY) {
+	else if ((dwKeyIndex & 0x000000FF) >= MAX_GROUP_KEY)
 		return false;
-	}
 
 	for (i = 0; i < MAX_KEY_TABLE - 1; i++) {
 		if (pTable->KeyTable[i].bInUse) {
@@ -779,9 +776,9 @@ bool KeybSetAllGroupKey(
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->bKeyValid: %d\n ", pKey->bKeyValid);
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->uKeyLength: %d\n ", (int)pKey->uKeyLength);
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->abyKey: ");
-			for (ii = 0; ii < pKey->uKeyLength; ii++) {
+			for (ii = 0; ii < pKey->uKeyLength; ii++)
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%02x ", pKey->abyKey[ii]);
-			}
+
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "\n");
 
 		} // (pTable->KeyTable[i].bInUse == true)
diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index db53e1a..af6876a 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -641,16 +641,14 @@ void MACvSaveContext(unsigned long dwIoBase, unsigned char *pbyCxtBuf)
 	int         ii;
 
 	// read page0 register
-	for (ii = 0; ii < MAC_MAX_CONTEXT_SIZE_PAGE0; ii++) {
+	for (ii = 0; ii < MAC_MAX_CONTEXT_SIZE_PAGE0; ii++)
 		VNSvInPortB((dwIoBase + ii), (pbyCxtBuf + ii));
-	}
 
 	MACvSelectPage1(dwIoBase);
 
 	// read page1 register
-	for (ii = 0; ii < MAC_MAX_CONTEXT_SIZE_PAGE1; ii++) {
+	for (ii = 0; ii < MAC_MAX_CONTEXT_SIZE_PAGE1; ii++)
 		VNSvInPortB((dwIoBase + ii), (pbyCxtBuf + MAC_MAX_CONTEXT_SIZE_PAGE0 + ii));
-	}
 
 	MACvSelectPage0(dwIoBase);
 }
@@ -675,25 +673,24 @@ void MACvRestoreContext(unsigned long dwIoBase, unsigned char *pbyCxtBuf)
 
 	MACvSelectPage1(dwIoBase);
 	// restore page1
-	for (ii = 0; ii < MAC_MAX_CONTEXT_SIZE_PAGE1; ii++) {
+	for (ii = 0; ii < MAC_MAX_CONTEXT_SIZE_PAGE1; ii++)
 		VNSvOutPortB((dwIoBase + ii), *(pbyCxtBuf + MAC_MAX_CONTEXT_SIZE_PAGE0 + ii));
-	}
+
 	MACvSelectPage0(dwIoBase);
 
 	// restore RCR,TCR,IMR...
-	for (ii = MAC_REG_RCR; ii < MAC_REG_ISR; ii++) {
+	for (ii = MAC_REG_RCR; ii < MAC_REG_ISR; ii++)
 		VNSvOutPortB(dwIoBase + ii, *(pbyCxtBuf + ii));
-	}
+
 	// restore MAC Config.
-	for (ii = MAC_REG_LRT; ii < MAC_REG_PAGE1SEL; ii++) {
+	for (ii = MAC_REG_LRT; ii < MAC_REG_PAGE1SEL; ii++)
 		VNSvOutPortB(dwIoBase + ii, *(pbyCxtBuf + ii));
-	}
+
 	VNSvOutPortB(dwIoBase + MAC_REG_CFG, *(pbyCxtBuf + MAC_REG_CFG));
 
 	// restore PS Config.
-	for (ii = MAC_REG_PSCFG; ii < MAC_REG_BBREGCTL; ii++) {
+	for (ii = MAC_REG_PSCFG; ii < MAC_REG_BBREGCTL; ii++)
 		VNSvOutPortB(dwIoBase + ii, *(pbyCxtBuf + ii));
-	}
 
 	// restore CURR_RX_DESC_ADDR, CURR_TX_DESC_ADDR
 	VNSvOutPortD(dwIoBase + MAC_REG_TXDMAPTR0, *(unsigned long *)(pbyCxtBuf + MAC_REG_TXDMAPTR0));
@@ -728,24 +725,20 @@ bool MACbCompareContext(unsigned long dwIoBase, unsigned char *pbyCxtBuf)
 
 	// compare CURR_RX_DESC_ADDR, CURR_TX_DESC_ADDR
 	VNSvInPortD(dwIoBase + MAC_REG_TXDMAPTR0, &dwData);
-	if (dwData != *(unsigned long *)(pbyCxtBuf + MAC_REG_TXDMAPTR0)) {
+	if (dwData != *(unsigned long *)(pbyCxtBuf + MAC_REG_TXDMAPTR0))
 		return false;
-	}
 
 	VNSvInPortD(dwIoBase + MAC_REG_AC0DMAPTR, &dwData);
-	if (dwData != *(unsigned long *)(pbyCxtBuf + MAC_REG_AC0DMAPTR)) {
+	if (dwData != *(unsigned long *)(pbyCxtBuf + MAC_REG_AC0DMAPTR))
 		return false;
-	}
 
 	VNSvInPortD(dwIoBase + MAC_REG_RXDMAPTR0, &dwData);
-	if (dwData != *(unsigned long *)(pbyCxtBuf + MAC_REG_RXDMAPTR0)) {
+	if (dwData != *(unsigned long *)(pbyCxtBuf + MAC_REG_RXDMAPTR0))
 		return false;
-	}
 
 	VNSvInPortD(dwIoBase + MAC_REG_RXDMAPTR1, &dwData);
-	if (dwData != *(unsigned long *)(pbyCxtBuf + MAC_REG_RXDMAPTR1)) {
+	if (dwData != *(unsigned long *)(pbyCxtBuf + MAC_REG_RXDMAPTR1))
 		return false;
-	}
 
 	return true;
 }
@@ -1055,21 +1048,21 @@ void MACvSetCurrRx0DescAddr(unsigned long dwIoBase, unsigned long dwCurrDescAddr
 	unsigned char byOrgDMACtl;
 
 	VNSvInPortB(dwIoBase + MAC_REG_RXDMACTL0, &byOrgDMACtl);
-	if (byOrgDMACtl & DMACTL_RUN) {
+	if (byOrgDMACtl & DMACTL_RUN)
 		VNSvOutPortB(dwIoBase + MAC_REG_RXDMACTL0+2, DMACTL_RUN);
-	}
+
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
 		VNSvInPortB(dwIoBase + MAC_REG_RXDMACTL0, &byData);
 		if (!(byData & DMACTL_RUN))
 			break;
 	}
-	if (ww == W_MAX_TIMEOUT) {
+
+	if (ww == W_MAX_TIMEOUT)
 		DBG_PORT80(0x13);
-	}
+
 	VNSvOutPortD(dwIoBase + MAC_REG_RXDMAPTR0, dwCurrDescAddr);
-	if (byOrgDMACtl & DMACTL_RUN) {
+	if (byOrgDMACtl & DMACTL_RUN)
 		VNSvOutPortB(dwIoBase + MAC_REG_RXDMACTL0, DMACTL_RUN);
-	}
 }
 
 /*
@@ -1093,21 +1086,21 @@ void MACvSetCurrRx1DescAddr(unsigned long dwIoBase, unsigned long dwCurrDescAddr
 	unsigned char byOrgDMACtl;
 
 	VNSvInPortB(dwIoBase + MAC_REG_RXDMACTL1, &byOrgDMACtl);
-	if (byOrgDMACtl & DMACTL_RUN) {
+	if (byOrgDMACtl & DMACTL_RUN)
 		VNSvOutPortB(dwIoBase + MAC_REG_RXDMACTL1+2, DMACTL_RUN);
-	}
+
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
 		VNSvInPortB(dwIoBase + MAC_REG_RXDMACTL1, &byData);
 		if (!(byData & DMACTL_RUN))
 			break;
 	}
-	if (ww == W_MAX_TIMEOUT) {
+	if (ww == W_MAX_TIMEOUT)
 		DBG_PORT80(0x14);
-	}
+
 	VNSvOutPortD(dwIoBase + MAC_REG_RXDMAPTR1, dwCurrDescAddr);
-	if (byOrgDMACtl & DMACTL_RUN) {
+	if (byOrgDMACtl & DMACTL_RUN)
 		VNSvOutPortB(dwIoBase + MAC_REG_RXDMACTL1, DMACTL_RUN);
-	}
+
 }
 
 /*
@@ -1131,21 +1124,20 @@ void MACvSetCurrTx0DescAddrEx(unsigned long dwIoBase, unsigned long dwCurrDescAd
 	unsigned char byOrgDMACtl;
 
 	VNSvInPortB(dwIoBase + MAC_REG_TXDMACTL0, &byOrgDMACtl);
-	if (byOrgDMACtl & DMACTL_RUN) {
+	if (byOrgDMACtl & DMACTL_RUN)
 		VNSvOutPortB(dwIoBase + MAC_REG_TXDMACTL0+2, DMACTL_RUN);
-	}
+
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
 		VNSvInPortB(dwIoBase + MAC_REG_TXDMACTL0, &byData);
 		if (!(byData & DMACTL_RUN))
 			break;
 	}
-	if (ww == W_MAX_TIMEOUT) {
+	if (ww == W_MAX_TIMEOUT)
 		DBG_PORT80(0x25);
-	}
+
 	VNSvOutPortD(dwIoBase + MAC_REG_TXDMAPTR0, dwCurrDescAddr);
-	if (byOrgDMACtl & DMACTL_RUN) {
+	if (byOrgDMACtl & DMACTL_RUN)
 		VNSvOutPortB(dwIoBase + MAC_REG_TXDMACTL0, DMACTL_RUN);
-	}
 }
 
 /*
@@ -1170,9 +1162,9 @@ void MACvSetCurrAC0DescAddrEx(unsigned long dwIoBase, unsigned long dwCurrDescAd
 	unsigned char byOrgDMACtl;
 
 	VNSvInPortB(dwIoBase + MAC_REG_AC0DMACTL, &byOrgDMACtl);
-	if (byOrgDMACtl & DMACTL_RUN) {
+	if (byOrgDMACtl & DMACTL_RUN)
 		VNSvOutPortB(dwIoBase + MAC_REG_AC0DMACTL+2, DMACTL_RUN);
-	}
+
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
 		VNSvInPortB(dwIoBase + MAC_REG_AC0DMACTL, &byData);
 		if (!(byData & DMACTL_RUN))
@@ -1183,18 +1175,16 @@ void MACvSetCurrAC0DescAddrEx(unsigned long dwIoBase, unsigned long dwCurrDescAd
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " DBG_PORT80(0x26)\n");
 	}
 	VNSvOutPortD(dwIoBase + MAC_REG_AC0DMAPTR, dwCurrDescAddr);
-	if (byOrgDMACtl & DMACTL_RUN) {
+	if (byOrgDMACtl & DMACTL_RUN)
 		VNSvOutPortB(dwIoBase + MAC_REG_AC0DMACTL, DMACTL_RUN);
-	}
 }
 
 void MACvSetCurrTXDescAddr(int iTxType, unsigned long dwIoBase, unsigned long dwCurrDescAddr)
 {
-	if (iTxType == TYPE_AC0DMA) {
+	if (iTxType == TYPE_AC0DMA)
 		MACvSetCurrAC0DescAddrEx(dwIoBase, dwCurrDescAddr);
-	} else if (iTxType == TYPE_TXDMA0) {
+	else if (iTxType == TYPE_TXDMA0)
 		MACvSetCurrTx0DescAddrEx(dwIoBase, dwCurrDescAddr);
-	}
 }
 
 /*
@@ -1384,9 +1374,9 @@ bool MACbPSWakeup(unsigned long dwIoBase)
 	unsigned char byOrgValue;
 	unsigned int ww;
 	// Read PSCTL
-	if (MACbIsRegBitsOff(dwIoBase, MAC_REG_PSCTL, PSCTL_PS)) {
+	if (MACbIsRegBitsOff(dwIoBase, MAC_REG_PSCTL, PSCTL_PS))
 		return true;
-	}
+
 	// Disable PS
 	MACvRegBitsOff(dwIoBase, MAC_REG_PSCTL, PSCTL_PSEN);
 
@@ -1535,9 +1525,9 @@ void MACvSetDefaultKeyEntry(unsigned long dwIoBase, unsigned int uKeyLen,
 		VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
 	}
 	dwData = *pdwKey;
-	if (uKeyLen == WLAN_WEP104_KEYLEN) {
+	if (uKeyLen == WLAN_WEP104_KEYLEN)
 		dwData |= 0x80000000;
-	}
+
 	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset+3);
 	VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, dwData);
 	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
diff --git a/drivers/staging/vt6655/mib.c b/drivers/staging/vt6655/mib.c
index 881c054..3689597 100644
--- a/drivers/staging/vt6655/mib.c
+++ b/drivers/staging/vt6655/mib.c
@@ -187,75 +187,75 @@ void STAvUpdateRDStatCounter(PSStatCounter pStatistic,
 
 	if (byRxRate == 22) {
 		pStatistic->CustomStat.ullRsr11M++;
-		if (byRSR & RSR_CRCOK) {
+		if (byRSR & RSR_CRCOK)
 			pStatistic->CustomStat.ullRsr11MCRCOk++;
-		}
+
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "11M: ALL[%d], OK[%d]:[%02x]\n", (int)pStatistic->CustomStat.ullRsr11M, (int)pStatistic->CustomStat.ullRsr11MCRCOk, byRSR);
 	} else if (byRxRate == 11) {
 		pStatistic->CustomStat.ullRsr5M++;
-		if (byRSR & RSR_CRCOK) {
+		if (byRSR & RSR_CRCOK)
 			pStatistic->CustomStat.ullRsr5MCRCOk++;
-		}
+
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " 5M: ALL[%d], OK[%d]:[%02x]\n", (int)pStatistic->CustomStat.ullRsr5M, (int)pStatistic->CustomStat.ullRsr5MCRCOk, byRSR);
 	} else if (byRxRate == 4) {
 		pStatistic->CustomStat.ullRsr2M++;
-		if (byRSR & RSR_CRCOK) {
+		if (byRSR & RSR_CRCOK)
 			pStatistic->CustomStat.ullRsr2MCRCOk++;
-		}
+
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " 2M: ALL[%d], OK[%d]:[%02x]\n", (int)pStatistic->CustomStat.ullRsr2M, (int)pStatistic->CustomStat.ullRsr2MCRCOk, byRSR);
 	} else if (byRxRate == 2) {
 		pStatistic->CustomStat.ullRsr1M++;
-		if (byRSR & RSR_CRCOK) {
+		if (byRSR & RSR_CRCOK)
 			pStatistic->CustomStat.ullRsr1MCRCOk++;
-		}
+
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " 1M: ALL[%d], OK[%d]:[%02x]\n", (int)pStatistic->CustomStat.ullRsr1M, (int)pStatistic->CustomStat.ullRsr1MCRCOk, byRSR);
 	} else if (byRxRate == 12) {
 		pStatistic->CustomStat.ullRsr6M++;
-		if (byRSR & RSR_CRCOK) {
+		if (byRSR & RSR_CRCOK)
 			pStatistic->CustomStat.ullRsr6MCRCOk++;
-		}
+
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " 6M: ALL[%d], OK[%d]\n", (int)pStatistic->CustomStat.ullRsr6M, (int)pStatistic->CustomStat.ullRsr6MCRCOk);
 	} else if (byRxRate == 18) {
 		pStatistic->CustomStat.ullRsr9M++;
-		if (byRSR & RSR_CRCOK) {
+		if (byRSR & RSR_CRCOK)
 			pStatistic->CustomStat.ullRsr9MCRCOk++;
-		}
+
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " 9M: ALL[%d], OK[%d]\n", (int)pStatistic->CustomStat.ullRsr9M, (int)pStatistic->CustomStat.ullRsr9MCRCOk);
 	} else if (byRxRate == 24) {
 		pStatistic->CustomStat.ullRsr12M++;
-		if (byRSR & RSR_CRCOK) {
+		if (byRSR & RSR_CRCOK)
 			pStatistic->CustomStat.ullRsr12MCRCOk++;
-		}
+
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "12M: ALL[%d], OK[%d]\n", (int)pStatistic->CustomStat.ullRsr12M, (int)pStatistic->CustomStat.ullRsr12MCRCOk);
 	} else if (byRxRate == 36) {
 		pStatistic->CustomStat.ullRsr18M++;
-		if (byRSR & RSR_CRCOK) {
+		if (byRSR & RSR_CRCOK)
 			pStatistic->CustomStat.ullRsr18MCRCOk++;
-		}
+
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "18M: ALL[%d], OK[%d]\n", (int)pStatistic->CustomStat.ullRsr18M, (int)pStatistic->CustomStat.ullRsr18MCRCOk);
 	} else if (byRxRate == 48) {
 		pStatistic->CustomStat.ullRsr24M++;
-		if (byRSR & RSR_CRCOK) {
+		if (byRSR & RSR_CRCOK)
 			pStatistic->CustomStat.ullRsr24MCRCOk++;
-		}
+
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "24M: ALL[%d], OK[%d]\n", (int)pStatistic->CustomStat.ullRsr24M, (int)pStatistic->CustomStat.ullRsr24MCRCOk);
 	} else if (byRxRate == 72) {
 		pStatistic->CustomStat.ullRsr36M++;
-		if (byRSR & RSR_CRCOK) {
+		if (byRSR & RSR_CRCOK)
 			pStatistic->CustomStat.ullRsr36MCRCOk++;
-		}
+
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "36M: ALL[%d], OK[%d]\n", (int)pStatistic->CustomStat.ullRsr36M, (int)pStatistic->CustomStat.ullRsr36MCRCOk);
 	} else if (byRxRate == 96) {
 		pStatistic->CustomStat.ullRsr48M++;
-		if (byRSR & RSR_CRCOK) {
+		if (byRSR & RSR_CRCOK)
 			pStatistic->CustomStat.ullRsr48MCRCOk++;
-		}
+
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "48M: ALL[%d], OK[%d]\n", (int)pStatistic->CustomStat.ullRsr48M, (int)pStatistic->CustomStat.ullRsr48MCRCOk);
 	} else if (byRxRate == 108) {
 		pStatistic->CustomStat.ullRsr54M++;
-		if (byRSR & RSR_CRCOK) {
+		if (byRSR & RSR_CRCOK)
 			pStatistic->CustomStat.ullRsr54MCRCOk++;
-		}
+
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "54M: ALL[%d], OK[%d]\n", (int)pStatistic->CustomStat.ullRsr54M, (int)pStatistic->CustomStat.ullRsr54MCRCOk);
 	} else {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Unknown: Total[%d], CRCOK[%d]\n", (int)pStatistic->dwRsrRxPacket+1, (int)pStatistic->dwRsrCRCOk);
@@ -288,13 +288,12 @@ void STAvUpdateRDStatCounter(PSStatCounter pStatistic,
 	pStatistic->dwRsrRxPacket++;
 	pStatistic->dwRsrRxOctet += cbFrameLength;
 
-	if (IS_TYPE_DATA(pbyBuffer)) {
+	if (IS_TYPE_DATA(pbyBuffer))
 		pStatistic->dwRsrRxData++;
-	} else if (IS_TYPE_MGMT(pbyBuffer)) {
+	else if (IS_TYPE_MGMT(pbyBuffer))
 		pStatistic->dwRsrRxManage++;
-	} else if (IS_TYPE_CONTROL(pbyBuffer)) {
+	else if (IS_TYPE_CONTROL(pbyBuffer))
 		pStatistic->dwRsrRxControl++;
-	}
 
 	if (byRSR & RSR_ADDRBROAD)
 		pStatistic->dwRsrBroadcast++;
@@ -306,23 +305,22 @@ void STAvUpdateRDStatCounter(PSStatCounter pStatistic,
 	if (WLAN_GET_FC_MOREFRAG(pHeader->wFrameCtl))
 		pStatistic->dwRsrRxFragment++;
 
-	if (cbFrameLength < ETH_ZLEN + 4) {
+	if (cbFrameLength < ETH_ZLEN + 4)
 		pStatistic->dwRsrRunt++;
-	} else if (cbFrameLength == ETH_ZLEN + 4) {
+	else if (cbFrameLength == ETH_ZLEN + 4)
 		pStatistic->dwRsrRxFrmLen64++;
-	} else if ((65 <= cbFrameLength) && (cbFrameLength <= 127)) {
+	else if ((65 <= cbFrameLength) && (cbFrameLength <= 127))
 		pStatistic->dwRsrRxFrmLen65_127++;
-	} else if ((128 <= cbFrameLength) && (cbFrameLength <= 255)) {
+	else if ((128 <= cbFrameLength) && (cbFrameLength <= 255))
 		pStatistic->dwRsrRxFrmLen128_255++;
-	} else if ((256 <= cbFrameLength) && (cbFrameLength <= 511)) {
+	else if ((256 <= cbFrameLength) && (cbFrameLength <= 511))
 		pStatistic->dwRsrRxFrmLen256_511++;
-	} else if ((512 <= cbFrameLength) && (cbFrameLength <= 1023)) {
+	else if ((512 <= cbFrameLength) && (cbFrameLength <= 1023))
 		pStatistic->dwRsrRxFrmLen512_1023++;
-	} else if ((1024 <= cbFrameLength) && (cbFrameLength <= ETH_FRAME_LEN + 4)) {
+	else if ((1024 <= cbFrameLength) && (cbFrameLength <= ETH_FRAME_LEN + 4))
 		pStatistic->dwRsrRxFrmLen1024_1518++;
-	} else if (cbFrameLength > ETH_FRAME_LEN + 4) {
+	else if (cbFrameLength > ETH_FRAME_LEN + 4)
 		pStatistic->dwRsrLong++;
-	}
 }
 
 /*
@@ -399,11 +397,11 @@ STAvUpdateTDStatCounter(
 	unsigned char byTSR0_NCR = byTSR0 & TSR0_NCR;
 
 	pHeader = (PWLAN_80211HDR_A4) pbyBuffer;
-	if (WLAN_GET_FC_TODS(pHeader->wFrameCtl) == 0) {
+	if (WLAN_GET_FC_TODS(pHeader->wFrameCtl) == 0)
 		pbyDestAddr = &(pHeader->abyAddr1[0]);
-	} else {
+	else
 		pbyDestAddr = &(pHeader->abyAddr3[0]);
-	}
+
 	// increase tx packet count
 	pStatistic->dwTsrTxPacket[uIdx]++;
 	pStatistic->dwTsrTxOctet[uIdx] += cbFrameLength;
diff --git a/drivers/staging/vt6655/michael.c b/drivers/staging/vt6655/michael.c
index 9486586..edee487 100644
--- a/drivers/staging/vt6655/michael.c
+++ b/drivers/staging/vt6655/michael.c
@@ -137,9 +137,9 @@ void MIC_vGetMIC(u32 *pdwL, u32 *pdwR)
 	s_vAppendByte(0);
 	s_vAppendByte(0);
 	// and then zeroes until the length is a multiple of 4
-	while (nBytesInM != 0) {
+	while (nBytesInM != 0)
 		s_vAppendByte(0);
-	}
+
 	// The s_vAppendByte function has already computed the result.
 	*pdwL = L;
 	*pdwR = R;
diff --git a/drivers/staging/vt6655/power.c b/drivers/staging/vt6655/power.c
index bc6186d..5dfa911 100644
--- a/drivers/staging/vt6655/power.c
+++ b/drivers/staging/vt6655/power.c
@@ -145,9 +145,9 @@ PSvDisablePowerSaving(
 
 	pDevice->bEnablePSMode = false;
 
-	if (pDevice->eOPMode == OP_MODE_INFRASTRUCTURE) {
+	if (pDevice->eOPMode == OP_MODE_INFRASTRUCTURE)
 		PSbSendNullPacket(pDevice);
-	}
+
 	pDevice->bPWBitOn = false;
 	return;
 }
@@ -276,17 +276,15 @@ PSbSendNullPacket(
 	PSMgmtObject        pMgmt = pDevice->pMgmt;
 	unsigned int uIdx;
 
-	if (!pDevice->bLinkPass) {
+	if (!pDevice->bLinkPass)
 		return false;
-	}
+
 #ifdef TxInSleep
-	if (!pDevice->bEnablePSMode && !pDevice->fTxDataInSleep) {
+	if (!pDevice->bEnablePSMode && !pDevice->fTxDataInSleep)
 		return false;
-	}
 #else
-	if (!pDevice->bEnablePSMode) {
+	if (!pDevice->bEnablePSMode)
 		return false;
-	}
 #endif
 	if (pDevice->bEnablePSMode) {
 		for (uIdx = 0; uIdx < TYPE_MAXTD; uIdx++) {
@@ -315,9 +313,8 @@ PSbSendNullPacket(
 ));
 	}
 
-	if (pMgmt->eCurrMode != WMAC_MODE_IBSS_STA) {
+	if (pMgmt->eCurrMode != WMAC_MODE_IBSS_STA)
 		pTxPacket->p80211Header->sA3.wFrameCtl |= cpu_to_le16((unsigned short)WLAN_SET_FC_TODS(1));
-	}
 
 	memcpy(pTxPacket->p80211Header->sA3.abyAddr1, pMgmt->abyCurrBSSID, WLAN_ADDR_LEN);
 	memcpy(pTxPacket->p80211Header->sA3.abyAddr2, pMgmt->abyMACAddr, WLAN_ADDR_LEN);
@@ -353,9 +350,8 @@ PSbIsNextTBTTWakeUp(
 	bool bWakeUp = false;
 
 	if (pMgmt->wListenInterval >= 2) {
-		if (pMgmt->wCountToWakeUp == 0) {
+		if (pMgmt->wCountToWakeUp == 0)
 			pMgmt->wCountToWakeUp = pMgmt->wListenInterval;
-		}
 
 		pMgmt->wCountToWakeUp--;
 
diff --git a/drivers/staging/vt6655/rf.c b/drivers/staging/vt6655/rf.c
index b379f4f..99c89a1 100644
--- a/drivers/staging/vt6655/rf.c
+++ b/drivers/staging/vt6655/rf.c
@@ -834,13 +834,12 @@ bool RFvWriteWakeProgSyn(unsigned long dwIoBase, unsigned char byRFType, unsigne
 
 		byInitCount = CB_AL2230_INIT_SEQ + 2; // Init Reg + Channel Reg (2)
 		bySleepCount = 0;
-		if (byInitCount > (MISCFIFO_SYNDATASIZE - bySleepCount)) {
+		if (byInitCount > (MISCFIFO_SYNDATASIZE - bySleepCount))
 			return false;
-		}
 
-		for (ii = 0; ii < CB_AL2230_INIT_SEQ; ii++) {
+		for (ii = 0; ii < CB_AL2230_INIT_SEQ; ii++)
 			MACvSetMISCFifo(dwIoBase, (unsigned short)(MISCFIFO_SYNDATA_IDX + ii), dwAL2230InitTable[ii]);
-		}
+
 		MACvSetMISCFifo(dwIoBase, (unsigned short)(MISCFIFO_SYNDATA_IDX + ii), dwAL2230ChannelTable0[uChannel-1]);
 		ii++;
 		MACvSetMISCFifo(dwIoBase, (unsigned short)(MISCFIFO_SYNDATA_IDX + ii), dwAL2230ChannelTable1[uChannel-1]);
@@ -851,18 +850,15 @@ bool RFvWriteWakeProgSyn(unsigned long dwIoBase, unsigned char byRFType, unsigne
 	case RF_AIROHA7230:
 		byInitCount = CB_AL7230_INIT_SEQ + 3; // Init Reg + Channel Reg (3)
 		bySleepCount = 0;
-		if (byInitCount > (MISCFIFO_SYNDATASIZE - bySleepCount)) {
+		if (byInitCount > (MISCFIFO_SYNDATASIZE - bySleepCount))
 			return false;
-		}
 
 		if (uChannel <= CB_MAX_CHANNEL_24G) {
-			for (ii = 0; ii < CB_AL7230_INIT_SEQ; ii++) {
+			for (ii = 0; ii < CB_AL7230_INIT_SEQ; ii++)
 				MACvSetMISCFifo(dwIoBase, (unsigned short)(MISCFIFO_SYNDATA_IDX + ii), dwAL7230InitTable[ii]);
-			}
 		} else {
-			for (ii = 0; ii < CB_AL7230_INIT_SEQ; ii++) {
+			for (ii = 0; ii < CB_AL7230_INIT_SEQ; ii++)
 				MACvSetMISCFifo(dwIoBase, (unsigned short)(MISCFIFO_SYNDATA_IDX + ii), dwAL7230InitTableAMode[ii]);
-			}
 		}
 
 		MACvSetMISCFifo(dwIoBase, (unsigned short)(MISCFIFO_SYNDATA_IDX + ii), dwAL7230ChannelTable0[uChannel-1]);
@@ -911,12 +907,11 @@ bool RFbSetPower(
 	unsigned char byDec = 0;
 	unsigned char byPwrdBm = 0;
 
-	if (pDevice->dwDiagRefCount != 0) {
+	if (pDevice->dwDiagRefCount != 0)
 		return true;
-	}
-	if ((uCH < 1) || (uCH > CB_MAX_CHANNEL)) {
+
+	if ((uCH < 1) || (uCH > CB_MAX_CHANNEL))
 		return false;
-	}
 
 	switch (uRATE) {
 	case RATE_1M:
@@ -930,14 +925,14 @@ bool RFbSetPower(
 	case RATE_9M:
 	case RATE_18M:
 		byPwr = pDevice->abyOFDMPwrTbl[uCH];
-		if (pDevice->byRFType == RF_UW2452) {
+		if (pDevice->byRFType == RF_UW2452)
 			byDec = byPwr + 14;
-		} else {
+		else
 			byDec = byPwr + 10;
-		}
-		if (byDec >= pDevice->byMaxPwrLevel) {
+
+		if (byDec >= pDevice->byMaxPwrLevel)
 			byDec = pDevice->byMaxPwrLevel-1;
-		}
+
 		if (pDevice->byRFType == RF_UW2452) {
 			byPwrdBm = byDec - byPwr;
 			byPwrdBm /= 3;
@@ -945,6 +940,7 @@ bool RFbSetPower(
 			byPwrdBm = byDec - byPwr;
 			byPwrdBm >>= 1;
 		}
+
 		byPwrdBm += pDevice->abyOFDMDefaultPwr[uCH];
 		byPwr = byDec;
 		break;
@@ -957,14 +953,13 @@ bool RFbSetPower(
 		break;
 	}
 
-	if (pDevice->byCurPwr == byPwr) {
+	if (pDevice->byCurPwr == byPwr)
 		return true;
-	}
 
 	bResult = RFbRawSetPower(pDevice, byPwr, uRATE);
-	if (bResult) {
+	if (bResult)
 		pDevice->byCurPwr = byPwr;
-	}
+
 	return bResult;
 }
 
@@ -991,17 +986,17 @@ bool RFbRawSetPower(
 	bool bResult = true;
 	unsigned long dwMax7230Pwr = 0;
 
-	if (byPwr >=  pDevice->byMaxPwrLevel) {
+	if (byPwr >=  pDevice->byMaxPwrLevel)
 		return false;
-	}
+
 	switch (pDevice->byRFType) {
 	case RF_AIROHA:
 		bResult &= IFRFbWriteEmbedded(pDevice->PortOffset, dwAL2230PowerTable[byPwr]);
-		if (uRATE <= RATE_11M) {
+		if (uRATE <= RATE_11M)
 			bResult &= IFRFbWriteEmbedded(pDevice->PortOffset, 0x0001B400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
-		} else {
+		else
 			bResult &= IFRFbWriteEmbedded(pDevice->PortOffset, 0x0005A400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
-		}
+
 		break;
 
 	case RF_AL2230S:
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index e964245..2219d71 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -229,14 +229,14 @@ s_vFillTxKey(
 		*pdwIV |= (unsigned long)byKeyIndex << 30;
 		*pdwIV = cpu_to_le32(*pdwIV);
 		pDevice->dwIVCounter++;
-		if (pDevice->dwIVCounter > WEP_IV_MASK) {
+		if (pDevice->dwIVCounter > WEP_IV_MASK)
 			pDevice->dwIVCounter = 0;
-		}
+
 	} else if (pTransmitKey->byCipherSuite == KEY_CTL_TKIP) {
 		pTransmitKey->wTSC15_0++;
-		if (pTransmitKey->wTSC15_0 == 0) {
+		if (pTransmitKey->wTSC15_0 == 0)
 			pTransmitKey->dwTSC47_16++;
-		}
+
 		TKIPvMixKey(pTransmitKey->abyKey, pDevice->abyCurrentNetAddr,
 			    pTransmitKey->wTSC15_0, pTransmitKey->dwTSC47_16, pDevice->abyPRNG);
 		memcpy(pbyBuf, pDevice->abyPRNG, 16);
@@ -250,9 +250,9 @@ s_vFillTxKey(
 
 	} else if (pTransmitKey->byCipherSuite == KEY_CTL_CCMP) {
 		pTransmitKey->wTSC15_0++;
-		if (pTransmitKey->wTSC15_0 == 0) {
+		if (pTransmitKey->wTSC15_0 == 0)
 			pTransmitKey->dwTSC47_16++;
-		}
+
 		memcpy(pbyBuf, pTransmitKey->abyKey, 16);
 
 		// Make IV
@@ -277,11 +277,11 @@ s_vFillTxKey(
 
 		//Fill MICHDR1
 		*((unsigned char *)(pMICHDR+16)) = 0; // HLEN[15:8]
-		if (pDevice->bLongHeader) {
+		if (pDevice->bLongHeader)
 			*((unsigned char *)(pMICHDR+17)) = 28; // HLEN[7:0]
-		} else {
+		else
 			*((unsigned char *)(pMICHDR+17)) = 22; // HLEN[7:0]
-		}
+
 		wValue = cpu_to_le16(pMACHeader->wFrameCtl & 0xC78F);
 		memcpy(pMICHDR+18, (unsigned char *)&wValue, 2); // MSKFRACTL
 		memcpy(pMICHDR+20, &(pMACHeader->abyAddr1[0]), 6);
@@ -293,9 +293,9 @@ s_vFillTxKey(
 		wValue &= 0x000F;
 		wValue = cpu_to_le16(wValue);
 		memcpy(pMICHDR+38, (unsigned char *)&wValue, 2); // MSKSEQCTL
-		if (pDevice->bLongHeader) {
+		if (pDevice->bLongHeader)
 			memcpy(pMICHDR+40, &(pMACHeader->abyAddr4[0]), 6);
-		}
+
 	}
 }
 
@@ -358,17 +358,15 @@ s_uGetTxRsvTime(
 	unsigned int uDataTime, uAckTime;
 
 	uDataTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, cbFrameLength, wRate);
-	if (byPktType == PK_TYPE_11B) {//llb,CCK mode
+	if (byPktType == PK_TYPE_11B) //llb,CCK mode
 		uAckTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, (unsigned short)pDevice->byTopCCKBasicRate);
-	} else {//11g 2.4G OFDM mode & 11a 5G OFDM mode
+	else //11g 2.4G OFDM mode & 11a 5G OFDM mode
 		uAckTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, (unsigned short)pDevice->byTopOFDMBasicRate);
-	}
 
-	if (bNeedAck) {
+	if (bNeedAck)
 		return uDataTime + pDevice->uSIFS + uAckTime;
-	} else {
+	else
 		return uDataTime;
-	}
 }
 
 //byFreqType: 0=>5GHZ 1=>2.4GHZ
@@ -428,9 +426,8 @@ s_uGetDataDuration(
 	bool bLastFrag = 0;
 	unsigned int uAckTime = 0, uNextPktTime = 0;
 
-	if (uFragIdx == (uMACfragNum-1)) {
+	if (uFragIdx == (uMACfragNum-1))
 		bLastFrag = 1;
-	}
 
 	switch (byDurType) {
 	case DATADUR_B:    //DATADUR_B
@@ -442,11 +439,11 @@ s_uGetDataDuration(
 				return 0;
 			}
 		} else {//First Frag or Mid Frag
-			if (uFragIdx == (uMACfragNum-2)) {
+			if (uFragIdx == (uMACfragNum-2))
 				uNextPktTime = s_uGetTxRsvTime(pDevice, byPktType, cbLastFragmentSize, wRate, bNeedAck);
-			} else {
+			else
 				uNextPktTime = s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wRate, bNeedAck);
-			}
+
 			if (bNeedAck) {
 				uAckTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopCCKBasicRate);
 				return pDevice->uSIFS + uAckTime + uNextPktTime;
@@ -465,11 +462,11 @@ s_uGetDataDuration(
 				return 0;
 			}
 		} else {//First Frag or Mid Frag
-			if (uFragIdx == (uMACfragNum-2)) {
+			if (uFragIdx == (uMACfragNum-2))
 				uNextPktTime = s_uGetTxRsvTime(pDevice, byPktType, cbLastFragmentSize, wRate, bNeedAck);
-			} else {
+			else
 				uNextPktTime = s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wRate, bNeedAck);
-			}
+
 			if (bNeedAck) {
 				uAckTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopOFDMBasicRate);
 				return pDevice->uSIFS + uAckTime + uNextPktTime;
@@ -494,22 +491,22 @@ s_uGetDataDuration(
 				else if (wRate > RATE_54M)
 					wRate = RATE_54M;
 
-				if (uFragIdx == (uMACfragNum-2)) {
+				if (uFragIdx == (uMACfragNum-2))
 					uNextPktTime = s_uGetTxRsvTime(pDevice, byPktType, cbLastFragmentSize, wFB_Opt0[FB_RATE0][wRate-RATE_18M], bNeedAck);
-				} else {
+				else
 					uNextPktTime = s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt0[FB_RATE0][wRate-RATE_18M], bNeedAck);
-				}
+
 			} else { // (byFBOption == AUTO_FB_1)
 				if (wRate < RATE_18M)
 					wRate = RATE_18M;
 				else if (wRate > RATE_54M)
 					wRate = RATE_54M;
 
-				if (uFragIdx == (uMACfragNum-2)) {
+				if (uFragIdx == (uMACfragNum-2))
 					uNextPktTime = s_uGetTxRsvTime(pDevice, byPktType, cbLastFragmentSize, wFB_Opt1[FB_RATE0][wRate-RATE_18M], bNeedAck);
-				} else {
+				else
 					uNextPktTime = s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt1[FB_RATE0][wRate-RATE_18M], bNeedAck);
-				}
+
 			}
 
 			if (bNeedAck) {
@@ -536,11 +533,10 @@ s_uGetDataDuration(
 				else if (wRate > RATE_54M)
 					wRate = RATE_54M;
 
-				if (uFragIdx == (uMACfragNum-2)) {
+				if (uFragIdx == (uMACfragNum-2))
 					uNextPktTime = s_uGetTxRsvTime(pDevice, byPktType, cbLastFragmentSize, wFB_Opt0[FB_RATE1][wRate-RATE_18M], bNeedAck);
-				} else {
+				else
 					uNextPktTime = s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt0[FB_RATE1][wRate-RATE_18M], bNeedAck);
-				}
 
 			} else { // (byFBOption == AUTO_FB_1)
 				if (wRate < RATE_18M)
@@ -548,11 +544,10 @@ s_uGetDataDuration(
 				else if (wRate > RATE_54M)
 					wRate = RATE_54M;
 
-				if (uFragIdx == (uMACfragNum-2)) {
+				if (uFragIdx == (uMACfragNum-2))
 					uNextPktTime = s_uGetTxRsvTime(pDevice, byPktType, cbLastFragmentSize, wFB_Opt1[FB_RATE1][wRate-RATE_18M], bNeedAck);
-				} else {
+				else
 					uNextPktTime = s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt1[FB_RATE1][wRate-RATE_18M], bNeedAck);
-				}
 			}
 			if (bNeedAck) {
 				uAckTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopOFDMBasicRate);
@@ -608,54 +603,54 @@ s_uGetRTSCTSDuration(
 
 	case RTSDUR_BA_F0: //RTSDuration_ba_f0
 		uCTSTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopCCKBasicRate);
-		if ((byFBOption == AUTO_FB_0) && (wRate >= RATE_18M) && (wRate <= RATE_54M)) {
+		if ((byFBOption == AUTO_FB_0) && (wRate >= RATE_18M) && (wRate <= RATE_54M))
 			uDurTime = uCTSTime + 2 * pDevice->uSIFS + s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt0[FB_RATE0][wRate-RATE_18M], bNeedAck);
-		} else if ((byFBOption == AUTO_FB_1) && (wRate >= RATE_18M) && (wRate <= RATE_54M)) {
+		else if ((byFBOption == AUTO_FB_1) && (wRate >= RATE_18M) && (wRate <= RATE_54M))
 			uDurTime = uCTSTime + 2 * pDevice->uSIFS + s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt1[FB_RATE0][wRate-RATE_18M], bNeedAck);
-		}
+
 		break;
 
 	case RTSDUR_AA_F0: //RTSDuration_aa_f0
 		uCTSTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopOFDMBasicRate);
-		if ((byFBOption == AUTO_FB_0) && (wRate >= RATE_18M) && (wRate <= RATE_54M)) {
+		if ((byFBOption == AUTO_FB_0) && (wRate >= RATE_18M) && (wRate <= RATE_54M))
 			uDurTime = uCTSTime + 2*pDevice->uSIFS + s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt0[FB_RATE0][wRate-RATE_18M], bNeedAck);
-		} else if ((byFBOption == AUTO_FB_1) && (wRate >= RATE_18M) && (wRate <= RATE_54M)) {
+		else if ((byFBOption == AUTO_FB_1) && (wRate >= RATE_18M) && (wRate <= RATE_54M))
 			uDurTime = uCTSTime + 2*pDevice->uSIFS + s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt1[FB_RATE0][wRate-RATE_18M], bNeedAck);
-		}
+
 		break;
 
 	case RTSDUR_BA_F1: //RTSDuration_ba_f1
 		uCTSTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopCCKBasicRate);
-		if ((byFBOption == AUTO_FB_0) && (wRate >= RATE_18M) && (wRate <= RATE_54M)) {
+		if ((byFBOption == AUTO_FB_0) && (wRate >= RATE_18M) && (wRate <= RATE_54M))
 			uDurTime = uCTSTime + 2*pDevice->uSIFS + s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt0[FB_RATE1][wRate-RATE_18M], bNeedAck);
-		} else if ((byFBOption == AUTO_FB_1) && (wRate >= RATE_18M) && (wRate <= RATE_54M)) {
+		else if ((byFBOption == AUTO_FB_1) && (wRate >= RATE_18M) && (wRate <= RATE_54M))
 			uDurTime = uCTSTime + 2*pDevice->uSIFS + s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt1[FB_RATE1][wRate-RATE_18M], bNeedAck);
-		}
+
 		break;
 
 	case RTSDUR_AA_F1: //RTSDuration_aa_f1
 		uCTSTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopOFDMBasicRate);
-		if ((byFBOption == AUTO_FB_0) && (wRate >= RATE_18M) && (wRate <= RATE_54M)) {
+		if ((byFBOption == AUTO_FB_0) && (wRate >= RATE_18M) && (wRate <= RATE_54M))
 			uDurTime = uCTSTime + 2*pDevice->uSIFS + s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt0[FB_RATE1][wRate-RATE_18M], bNeedAck);
-		} else if ((byFBOption == AUTO_FB_1) && (wRate >= RATE_18M) && (wRate <= RATE_54M)) {
+		else if ((byFBOption == AUTO_FB_1) && (wRate >= RATE_18M) && (wRate <= RATE_54M))
 			uDurTime = uCTSTime + 2*pDevice->uSIFS + s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt1[FB_RATE1][wRate-RATE_18M], bNeedAck);
-		}
+
 		break;
 
 	case CTSDUR_BA_F0: //CTSDuration_ba_f0
-		if ((byFBOption == AUTO_FB_0) && (wRate >= RATE_18M) && (wRate <= RATE_54M)) {
+		if ((byFBOption == AUTO_FB_0) && (wRate >= RATE_18M) && (wRate <= RATE_54M))
 			uDurTime = pDevice->uSIFS + s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt0[FB_RATE0][wRate-RATE_18M], bNeedAck);
-		} else if ((byFBOption == AUTO_FB_1) && (wRate >= RATE_18M) && (wRate <= RATE_54M)) {
+		else if ((byFBOption == AUTO_FB_1) && (wRate >= RATE_18M) && (wRate <= RATE_54M))
 			uDurTime = pDevice->uSIFS + s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt1[FB_RATE0][wRate-RATE_18M], bNeedAck);
-		}
+
 		break;
 
 	case CTSDUR_BA_F1: //CTSDuration_ba_f1
-		if ((byFBOption == AUTO_FB_0) && (wRate >= RATE_18M) && (wRate <= RATE_54M)) {
+		if ((byFBOption == AUTO_FB_0) && (wRate >= RATE_18M) && (wRate <= RATE_54M))
 			uDurTime = pDevice->uSIFS + s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt0[FB_RATE1][wRate-RATE_18M], bNeedAck);
-		} else if ((byFBOption == AUTO_FB_1) && (wRate >= RATE_18M) && (wRate <= RATE_54M)) {
+		else if ((byFBOption == AUTO_FB_1) && (wRate >= RATE_18M) && (wRate <= RATE_54M))
 			uDurTime = pDevice->uSIFS + s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt1[FB_RATE1][wRate-RATE_18M], bNeedAck);
-		}
+
 		break;
 
 	default:
@@ -683,9 +678,9 @@ s_uFillDataHead(
 {
 	unsigned short wLen = 0x0000;
 
-	if (pTxDataHead == NULL) {
+	if (pTxDataHead == NULL)
 		return 0;
-	}
+
 
 	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
 		if (byFBOption == AUTO_FB_NONE) {
@@ -848,11 +843,11 @@ s_vFillRTSHead(
 			} else {
 				memcpy(&(pBuf->Data.abyRA[0]), &(pDevice->abyBSSID[0]), ETH_ALEN);
 			}
-			if (pDevice->eOPMode == OP_MODE_AP) {
+			if (pDevice->eOPMode == OP_MODE_AP)
 				memcpy(&(pBuf->Data.abyTA[0]), &(pDevice->abyBSSID[0]), ETH_ALEN);
-			} else {
+			else
 				memcpy(&(pBuf->Data.abyTA[0]), &(psEthHeader->abySrcAddr[0]), ETH_ALEN);
-			}
+
 		} else {
 			PSRTS_g_FB pBuf = (PSRTS_g_FB)pvRTS;
 			//Get SignalField,ServiceField,Length
@@ -884,11 +879,10 @@ s_vFillRTSHead(
 				memcpy(&(pBuf->Data.abyRA[0]), &(pDevice->abyBSSID[0]), ETH_ALEN);
 			}
 
-			if (pDevice->eOPMode == OP_MODE_AP) {
+			if (pDevice->eOPMode == OP_MODE_AP)
 				memcpy(&(pBuf->Data.abyTA[0]), &(pDevice->abyBSSID[0]), ETH_ALEN);
-			} else {
+			else
 				memcpy(&(pBuf->Data.abyTA[0]), &(psEthHeader->abySrcAddr[0]), ETH_ALEN);
-			}
 
 		} // if (byFBOption == AUTO_FB_NONE)
 	} else if (byPktType == PK_TYPE_11A) {
@@ -912,11 +906,10 @@ s_vFillRTSHead(
 				memcpy(&(pBuf->Data.abyRA[0]), &(pDevice->abyBSSID[0]), ETH_ALEN);
 			}
 
-			if (pDevice->eOPMode == OP_MODE_AP) {
+			if (pDevice->eOPMode == OP_MODE_AP)
 				memcpy(&(pBuf->Data.abyTA[0]), &(pDevice->abyBSSID[0]), ETH_ALEN);
-			} else {
+			else
 				memcpy(&(pBuf->Data.abyTA[0]), &(psEthHeader->abySrcAddr[0]), ETH_ALEN);
-			}
 
 		} else {
 			PSRTS_a_FB pBuf = (PSRTS_a_FB)pvRTS;
@@ -939,11 +932,10 @@ s_vFillRTSHead(
 			} else {
 				memcpy(&(pBuf->Data.abyRA[0]), &(pDevice->abyBSSID[0]), ETH_ALEN);
 			}
-			if (pDevice->eOPMode == OP_MODE_AP) {
+			if (pDevice->eOPMode == OP_MODE_AP)
 				memcpy(&(pBuf->Data.abyTA[0]), &(pDevice->abyBSSID[0]), ETH_ALEN);
-			} else {
+			else
 				memcpy(&(pBuf->Data.abyTA[0]), &(psEthHeader->abySrcAddr[0]), ETH_ALEN);
-			}
 		}
 	} else if (byPktType == PK_TYPE_11B) {
 		PSRTS_ab pBuf = (PSRTS_ab)pvRTS;
@@ -965,11 +957,10 @@ s_vFillRTSHead(
 			memcpy(&(pBuf->Data.abyRA[0]), &(pDevice->abyBSSID[0]), ETH_ALEN);
 		}
 
-		if (pDevice->eOPMode == OP_MODE_AP) {
+		if (pDevice->eOPMode == OP_MODE_AP)
 			memcpy(&(pBuf->Data.abyTA[0]), &(pDevice->abyBSSID[0]), ETH_ALEN);
-		} else {
+		else
 			memcpy(&(pBuf->Data.abyTA[0]), &(psEthHeader->abySrcAddr[0]), ETH_ALEN);
-		}
 	}
 }
 
@@ -990,9 +981,8 @@ s_vFillCTSHead(
 	unsigned int uCTSFrameLen = 14;
 	unsigned short wLen = 0x0000;
 
-	if (pvCTS == NULL) {
+	if (pvCTS == NULL)
 		return;
-	}
 
 	if (bDisCRC) {
 		// When CRCDIS bit is on, H/W forgot to generate FCS for CTS frame,
@@ -1097,15 +1087,13 @@ s_vGenerateTxParameter(
 	pFifoHead->wReserved = wCurrentRate;
 	wFifoCtl = pFifoHead->wFIFOCtl;
 
-	if (wFifoCtl & FIFOCTL_CRCDIS) {
+	if (wFifoCtl & FIFOCTL_CRCDIS)
 		bDisCRC = true;
-	}
 
-	if (wFifoCtl & FIFOCTL_AUTO_FB_0) {
+	if (wFifoCtl & FIFOCTL_AUTO_FB_0)
 		byFBOption = AUTO_FB_0;
-	} else if (wFifoCtl & FIFOCTL_AUTO_FB_1) {
+	else if (wFifoCtl & FIFOCTL_AUTO_FB_1)
 		byFBOption = AUTO_FB_1;
-	}
 
 	if (pDevice->bLongHeader)
 		cbMACHdLen = WLAN_HDR_ADDR3_LEN + 6;
@@ -1194,20 +1182,18 @@ s_vFillFragParameter(
 		ptdCurr->m_wTimeStamp = pTxBufHead->wTimeStamp;
 		//Set TSR1 & ReqCount in TxDescHead
 		ptdCurr->m_td1TD1.wReqCount = cpu_to_le16((unsigned short)(cbReqCount));
-		if (wFragType == FRAGCTL_ENDFRAG) { //Last Fragmentation
+		if (wFragType == FRAGCTL_ENDFRAG) //Last Fragmentation
 			ptdCurr->m_td1TD1.byTCR |= (TCR_STP | TCR_EDP | EDMSDU);
-		} else {
+		else
 			ptdCurr->m_td1TD1.byTCR |= (TCR_STP | TCR_EDP);
-		}
 	} else {
 		PSTxDesc ptdCurr = (PSTxDesc)pvtdCurr;
 		//Set TSR1 & ReqCount in TxDescHead
 		ptdCurr->m_td1TD1.wReqCount = cpu_to_le16((unsigned short)(cbReqCount));
-		if (wFragType == FRAGCTL_ENDFRAG) { //Last Fragmentation
+		if (wFragType == FRAGCTL_ENDFRAG) //Last Fragmentation
 			ptdCurr->m_td1TD1.byTCR |= (TCR_STP | TCR_EDP | EDMSDU);
-		} else {
+		else
 			ptdCurr->m_td1TD1.byTCR |= (TCR_STP | TCR_EDP);
-		}
 	}
 
 	pTxBufHead->wFragCtl |= (unsigned short)wFragType;//0x0001; //0000 0000 0000 0001
@@ -1293,9 +1279,8 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 		if (pTransmitKey->byCipherSuite == KEY_CTL_WEP) {
 			cbIVlen = 4;
 			cbICVlen = 4;
-			if (pTransmitKey->uKeyLength == WLAN_WEP232_KEYLEN) {
+			if (pTransmitKey->uKeyLength == WLAN_WEP232_KEYLEN)
 				bIsWEP256 = true;
-			}
 		}
 		if (pTransmitKey->byCipherSuite == KEY_CTL_TKIP) {
 			cbIVlen = 8;//IV+ExtIV
@@ -1328,11 +1313,10 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 	//
 	// Use for AUTO FALL BACK
 	//
-	if (psTxBufHd->wFIFOCtl & FIFOCTL_AUTO_FB_0) {
+	if (psTxBufHd->wFIFOCtl & FIFOCTL_AUTO_FB_0)
 		byFBOption = AUTO_FB_0;
-	} else if (psTxBufHd->wFIFOCtl & FIFOCTL_AUTO_FB_1) {
+	else if (psTxBufHd->wFIFOCtl & FIFOCTL_AUTO_FB_1)
 		byFBOption = AUTO_FB_1;
-	}
 
 	//////////////////////////////////////////////////////
 	//Set RrvTime/RTS/CTS Buffer
@@ -1446,11 +1430,11 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 		//FragNum = (FrameSize-(Hdr+FCS))/(Fragment Size -(Hrd+FCS)))
 		uMACfragNum = (unsigned short) ((cbFrameBodySize + cbMIClen) / cbFragPayloadSize);
 		cbLastFragPayloadSize = (cbFrameBodySize + cbMIClen) % cbFragPayloadSize;
-		if (cbLastFragPayloadSize == 0) {
+		if (cbLastFragPayloadSize == 0)
 			cbLastFragPayloadSize = cbFragPayloadSize;
-		} else {
+		else
 			uMACfragNum++;
-		}
+
 		//[Hdr+(IV)+last fragment payload+(MIC)+(ICV)+FCS]
 		cbLastFragmentSize = cbMACHdLen + cbLastFragPayloadSize + cbIVlen + cbICVlen + cbFCSlen;
 
@@ -1916,40 +1900,37 @@ vGenerateFIFOHeader(PSDevice pDevice, unsigned char byPktType, unsigned char *pb
 	pTxBufHead->wFIFOCtl |= FIFOCTL_GENINT;
 
 	//Set FIFOCTL_ISDMA0
-	if (TYPE_TXDMA0 == uDMAIdx) {
+	if (TYPE_TXDMA0 == uDMAIdx)
 		pTxBufHead->wFIFOCtl |= FIFOCTL_ISDMA0;
-	}
 
 	//Set FRAGCTL_MACHDCNT
-	if (pDevice->bLongHeader) {
+	if (pDevice->bLongHeader)
 		cbMacHdLen = WLAN_HDR_ADDR3_LEN + 6;
-	} else {
+	else
 		cbMacHdLen = WLAN_HDR_ADDR3_LEN;
-	}
+
 	pTxBufHead->wFragCtl |= cpu_to_le16((unsigned short)(cbMacHdLen << 10));
 
 	//Set packet type
-	if (byPktType == PK_TYPE_11A) {//0000 0000 0000 0000
+	if (byPktType == PK_TYPE_11A) //0000 0000 0000 0000
 		;
-	} else if (byPktType == PK_TYPE_11B) {//0000 0001 0000 0000
+	else if (byPktType == PK_TYPE_11B) //0000 0001 0000 0000
 		pTxBufHead->wFIFOCtl |= FIFOCTL_11B;
-	} else if (byPktType == PK_TYPE_11GB) {//0000 0010 0000 0000
+	else if (byPktType == PK_TYPE_11GB) //0000 0010 0000 0000
 		pTxBufHead->wFIFOCtl |= FIFOCTL_11GB;
-	} else if (byPktType == PK_TYPE_11GA) {//0000 0011 0000 0000
+	else if (byPktType == PK_TYPE_11GA) //0000 0011 0000 0000
 		pTxBufHead->wFIFOCtl |= FIFOCTL_11GA;
-	}
+
 	//Set FIFOCTL_GrpAckPolicy
-	if (pDevice->bGrpAckPolicy == true) {//0000 0100 0000 0000
+	if (pDevice->bGrpAckPolicy == true) //0000 0100 0000 0000
 		pTxBufHead->wFIFOCtl |=	FIFOCTL_GRPACK;
-	}
 
 	//Set Auto Fallback Ctl
 	if (pDevice->wCurrentRate >= RATE_18M) {
-		if (pDevice->byAutoFBCtrl == AUTO_FB_0) {
+		if (pDevice->byAutoFBCtrl == AUTO_FB_0)
 			pTxBufHead->wFIFOCtl |= FIFOCTL_AUTO_FB_0;
-		} else if (pDevice->byAutoFBCtrl == AUTO_FB_1) {
+		else if (pDevice->byAutoFBCtrl == AUTO_FB_1)
 			pTxBufHead->wFIFOCtl |= FIFOCTL_AUTO_FB_1;
-		}
 	}
 
 	//Set FRAGCTL_WEPTYP
@@ -2016,11 +1997,10 @@ vGenerateMACHeader(
 
 	memset(pMACHeader, 0, (sizeof(S802_11Header)));
 
-	if (uDMAIdx == TYPE_ATIMDMA) {
+	if (uDMAIdx == TYPE_ATIMDMA)
 		pMACHeader->wFrameCtl = TYPE_802_11_ATIM;
-	} else {
+	else
 		pMACHeader->wFrameCtl = TYPE_802_11_DATA;
-	}
 
 	if (pDevice->eOPMode == OP_MODE_AP) {
 		memcpy(&(pMACHeader->abyAddr1[0]), &(psEthHeader->abyDstAddr[0]), ETH_ALEN);
@@ -2061,9 +2041,8 @@ vGenerateMACHeader(
 			pDevice->wSeqCounter = 0;
 	}
 
-	if ((wFragType == FRAGCTL_STAFRAG) || (wFragType == FRAGCTL_MIDFRAG)) { //StartFrag or MidFrag
+	if ((wFragType == FRAGCTL_STAFRAG) || (wFragType == FRAGCTL_MIDFRAG)) //StartFrag or MidFrag
 		pMACHeader->wFrameCtl |= FC_MOREFRAG;
-	}
 }
 
 CMD_STATUS csMgmt_xmit(PSDevice pDevice, PSTxMgmtPacket pPacket) {
@@ -2095,9 +2074,8 @@ CMD_STATUS csMgmt_xmit(PSDevice pDevice, PSTxMgmtPacket pPacket) {
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 	unsigned short wCurrentRate = RATE_1M;
 
-	if (AVAIL_TD(pDevice, TYPE_TXDMA0) <= 0) {
+	if (AVAIL_TD(pDevice, TYPE_TXDMA0) <= 0)
 		return CMD_STATUS_RESOURCES;
-	}
 
 	pFrstTD = pDevice->apCurrTD[TYPE_TXDMA0];
 	pbyTxBufferAddr = (unsigned char *)pFrstTD->pTDInfo->buf;
@@ -2118,11 +2096,11 @@ CMD_STATUS csMgmt_xmit(PSDevice pDevice, PSTxMgmtPacket pPacket) {
 	// 2004.11.11 Kyle -- Using OFDM power to tx MngPkt will decrease the connection capability.
 	//                    And cmd timer will wait data pkt TX finish before scanning so it's OK
 	//                    to set power here.
-	if (pDevice->pMgmt->eScanState != WMAC_NO_SCANNING) {
+	if (pDevice->pMgmt->eScanState != WMAC_NO_SCANNING)
 		RFbSetPower(pDevice, wCurrentRate, pDevice->byCurrentCh);
-	} else {
+	else
 		RFbSetPower(pDevice, wCurrentRate, pMgmt->uCurrChannel);
-	}
+
 	pTxBufHead->byTxPower = pDevice->byCurPwr;
 	//+++++++++++++++++++++ Patch VT3253 A1 performance +++++++++++++++++++++++++++
 	if (pDevice->byFOETuning) {
@@ -2200,9 +2178,9 @@ CMD_STATUS csMgmt_xmit(PSDevice pDevice, PSTxMgmtPacket pPacket) {
 	cbFrameSize = cbMacHdLen + cbFrameBodySize + cbIVlen + cbMIClen + cbICVlen + cbFCSlen;
 
 	//Set FIFOCTL_GrpAckPolicy
-	if (pDevice->bGrpAckPolicy == true) {//0000 0100 0000 0000
+	if (pDevice->bGrpAckPolicy == true) //0000 0100 0000 0000
 		pTxBufHead->wFIFOCtl |=	FIFOCTL_GRPACK;
-	}
+
 	//the rest of pTxBufHead->wFragCtl:FragTyp will be set later in s_vFillFragParameter()
 
 	//Set RrvTime/RTS/CTS Buffer
@@ -2338,9 +2316,8 @@ CMD_STATUS csMgmt_xmit(PSDevice pDevice, PSTxMgmtPacket pPacket) {
 
 	pDevice->iTDUsed[TYPE_TXDMA0]++;
 
-	if (AVAIL_TD(pDevice, TYPE_TXDMA0) <= 1) {
+	if (AVAIL_TD(pDevice, TYPE_TXDMA0) <= 1)
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " available td0 <= 1\n");
-	}
 
 	pDevice->apCurrTD[TYPE_TXDMA0] = pFrstTD->next;
 
@@ -2496,11 +2473,10 @@ cbGetFragCount(
 		cbFragPayloadSize = cbFragmentSize - cbMACHdLen - cbIVlen - cbICVlen - cbFCSlen;
 		uMACfragNum = (unsigned short) ((cbFrameBodySize + cbMIClen) / cbFragPayloadSize);
 		cbLastFragPayloadSize = (cbFrameBodySize + cbMIClen) % cbFragPayloadSize;
-		if (cbLastFragPayloadSize == 0) {
+		if (cbLastFragPayloadSize == 0)
 			cbLastFragPayloadSize = cbFragPayloadSize;
-		} else {
+		else
 			uMACfragNum++;
-		}
 	}
 	return uMACfragNum;
 }
@@ -2553,11 +2529,11 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, unsigned char *pbMPDU, un
 
 	pvRrvTime = pMICHDR = pvRTS = pvCTS = pvTxDataHd = NULL;
 
-	if (cbMPDULen <= WLAN_HDR_ADDR3_LEN) {
+	if (cbMPDULen <= WLAN_HDR_ADDR3_LEN)
 		cbFrameBodySize = 0;
-	} else {
+	else
 		cbFrameBodySize = cbMPDULen - WLAN_HDR_ADDR3_LEN;
-	}
+
 	p80211Header = (PUWLAN_80211HDR)pbMPDU;
 
 	pFrstTD = pDevice->apCurrTD[TYPE_TXDMA0];
@@ -2578,11 +2554,11 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, unsigned char *pbMPDU, un
 	// 2004.11.11 Kyle -- Using OFDM power to tx MngPkt will decrease the connection capability.
 	//                    And cmd timer will wait data pkt TX to finish before scanning so it's OK
 	//                    to set power here.
-	if (pDevice->pMgmt->eScanState != WMAC_NO_SCANNING) {
+	if (pDevice->pMgmt->eScanState != WMAC_NO_SCANNING)
 		RFbSetPower(pDevice, wCurrentRate, pDevice->byCurrentCh);
-	} else {
+	else
 		RFbSetPower(pDevice, wCurrentRate, pMgmt->uCurrChannel);
-	}
+
 	pTxBufHead->byTxPower = pDevice->byCurPwr;
 
 	//+++++++++++++++++++++ Patch VT3253 A1 performance +++++++++++++++++++++++++++
@@ -2640,17 +2616,14 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, unsigned char *pbMPDU, un
 
 	// hostapd deamon ext support rate patch
 	if (WLAN_GET_FC_FSTYPE(p80211Header->sA4.wFrameCtl) == WLAN_FSTYPE_ASSOCRESP) {
-		if (((PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates)->len != 0) {
+		if (((PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates)->len != 0)
 			cbExtSuppRate += ((PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates)->len + WLAN_IEHDR_LEN;
-		}
 
-		if (((PWLAN_IE_SUPP_RATES)pMgmt->abyCurrExtSuppRates)->len != 0) {
+		if (((PWLAN_IE_SUPP_RATES)pMgmt->abyCurrExtSuppRates)->len != 0)
 			cbExtSuppRate += ((PWLAN_IE_SUPP_RATES)pMgmt->abyCurrExtSuppRates)->len + WLAN_IEHDR_LEN;
-		}
 
-		if (cbExtSuppRate > 0) {
+		if (cbExtSuppRate > 0)
 			cbFrameBodySize = WLAN_ASSOCRESP_OFF_SUPP_RATES;
-		}
 	}
 
 	//Set FRAGCTL_MACHDCNT
@@ -2687,9 +2660,9 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, unsigned char *pbMPDU, un
 	cbFrameSize = cbMacHdLen + cbFrameBodySize + cbIVlen + cbMIClen + cbICVlen + cbFCSlen + cbExtSuppRate;
 
 	//Set FIFOCTL_GrpAckPolicy
-	if (pDevice->bGrpAckPolicy == true) {//0000 0100 0000 0000
+	if (pDevice->bGrpAckPolicy == true) //0000 0100 0000 0000
 		pTxBufHead->wFIFOCtl |=	FIFOCTL_GRPACK;
-	}
+
 	//the rest of pTxBufHead->wFragCtl:FragTyp will be set later in s_vFillFragParameter()
 
 	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {//802.11g packet
@@ -2815,9 +2788,8 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, unsigned char *pbMPDU, un
 			pMgmt->sNodeDBTable[uNodeIndex].wTSC15_0 = pTransmitKey->wTSC15_0;
 		}
 
-		if ((pDevice->byLocalID <= REV_ID_VT3253_A1)) {
+		if ((pDevice->byLocalID <= REV_ID_VT3253_A1))
 			s_vSWencryption(pDevice, pTransmitKey, pbyPayloadHead, (unsigned short)(cbFrameBodySize + cbMIClen));
-		}
 	}
 
 	pMACHeader->wSeqCtl = cpu_to_le16(pDevice->wSeqCounter << 4);
@@ -2861,9 +2833,8 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, unsigned char *pbMPDU, un
 
 	pDevice->iTDUsed[TYPE_TXDMA0]++;
 
-	if (AVAIL_TD(pDevice, TYPE_TXDMA0) <= 1) {
+	if (AVAIL_TD(pDevice, TYPE_TXDMA0) <= 1)
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " available td0 <= 1\n");
-	}
 
 	pDevice->apCurrTD[TYPE_TXDMA0] = pFrstTD->next;
 
diff --git a/drivers/staging/vt6655/tether.c b/drivers/staging/vt6655/tether.c
index a5dc3c09..1e7d3e2 100644
--- a/drivers/staging/vt6655/tether.c
+++ b/drivers/staging/vt6655/tether.c
@@ -98,8 +98,8 @@ bool ETHbIsBufferCrc32Ok(unsigned char *pbyBuffer, unsigned int cbFrameLength)
 	unsigned long dwCRC;
 
 	dwCRC = CRCdwGetCrc32(pbyBuffer, cbFrameLength - 4);
-	if (cpu_to_le32(*((unsigned long *)(pbyBuffer + cbFrameLength - 4))) != dwCRC) {
+	if (cpu_to_le32(*((unsigned long *)(pbyBuffer + cbFrameLength - 4))) != dwCRC)
 		return false;
-	}
+
 	return true;
 }
diff --git a/drivers/staging/vt6655/tkip.c b/drivers/staging/vt6655/tkip.c
index 078b359..f758d02 100644
--- a/drivers/staging/vt6655/tkip.c
+++ b/drivers/staging/vt6655/tkip.c
@@ -157,11 +157,11 @@ unsigned int rotr1(unsigned int a)
 {
 	unsigned int b;
 
-	if ((a & 0x01) == 0x01) {
+	if ((a & 0x01) == 0x01)
 		b = (a >> 1) | 0x8000;
-	} else {
+	else
 		b = (a >> 1) & 0x7fff;
-	}
+
 	b = b % 65536;
 	return b;
 }
diff --git a/drivers/staging/vt6655/vntwifi.c b/drivers/staging/vt6655/vntwifi.c
index 2ccd070..7d61598 100644
--- a/drivers/staging/vt6655/vntwifi.c
+++ b/drivers/staging/vt6655/vntwifi.c
@@ -151,9 +151,9 @@ VNTWIFIpGetCurrentChannel(
 )
 {
 	PSMgmtObject        pMgmt = (PSMgmtObject)pMgmtHandle;
-	if (pMgmtHandle != NULL) {
+	if (pMgmtHandle != NULL)
 		return pMgmt->uCurrChannel;
-	}
+
 	return 0;
 }
 
@@ -208,17 +208,17 @@ VNTWIFIbyGetMaxSupportRate(
 	if (pSupportRateIEs) {
 		for (ii = 0; ii < pSupportRateIEs->len; ii++) {
 			bySupportRate = DATARATEbyGetRateIdx(pSupportRateIEs->abyRates[ii]);
-			if (bySupportRate > byMaxSupportRate) {
+			if (bySupportRate > byMaxSupportRate)
 				byMaxSupportRate = bySupportRate;
-			}
+
 		}
 	}
 	if (pExtSupportRateIEs) {
 		for (ii = 0; ii < pExtSupportRateIEs->len; ii++) {
 			bySupportRate = DATARATEbyGetRateIdx(pExtSupportRateIEs->abyRates[ii]);
-			if (bySupportRate > byMaxSupportRate) {
+			if (bySupportRate > byMaxSupportRate)
 				byMaxSupportRate = bySupportRate;
-			}
+
 		}
 	}
 
@@ -359,11 +359,10 @@ VNTWIFIbConfigPhyMode(
 
 	if ((ePhyType != PHY_TYPE_AUTO) &&
 	    (ePhyType != pMgmt->eCurrentPHYMode)) {
-		if (CARDbSetPhyParameter(pMgmt->pAdapter, ePhyType, 0, 0, NULL, NULL) == true) {
+		if (CARDbSetPhyParameter(pMgmt->pAdapter, ePhyType, 0, 0, NULL, NULL) == true)
 			pMgmt->eCurrentPHYMode = ePhyType;
-		} else {
+		else
 			return false;
-		}
 	}
 	pMgmt->eConfigPHYMode = ePhyType;
 	return true;
@@ -377,9 +376,8 @@ VNTWIFIbGetConfigPhyMode(
 {
 	PSMgmtObject        pMgmt = (PSMgmtObject)pMgmtHandle;
 
-	if ((pMgmt != NULL) && (pePhyType != NULL)) {
+	if ((pMgmt != NULL) && (pePhyType != NULL))
 		*(PCARD_PHY_TYPE)pePhyType = pMgmt->eConfigPHYMode;
-	}
 }
 
 /*+
@@ -425,12 +423,12 @@ VNTWIFIvQueryBSSList(void *pMgmtHandle, unsigned int *puBSSCount, void **pvFirst
 
 	for (ii = 0; ii < MAX_BSS_NUM; ii++) {
 		pBSS = &(pMgmt->sBSSList[ii]);
-		if (!pBSS->bActive) {
+		if (!pBSS->bActive)
 			continue;
-		}
-		if (*pvFirstBSS == NULL) {
+
+		if (*pvFirstBSS == NULL)
 			*pvFirstBSS = &(pMgmt->sBSSList[ii]);
-		}
+
 		uCount++;
 	}
 	*puBSSCount = uCount;
@@ -450,9 +448,9 @@ VNTWIFIvGetNextBSS(
 
 	while (*pvNextBSS == NULL) {
 		pBSS++;
-		if (pBSS > &(pMgmt->sBSSList[MAX_BSS_NUM])) {
+		if (pBSS > &(pMgmt->sBSSList[MAX_BSS_NUM]))
 			return;
-		}
+
 		if (pBSS->bActive == true) {
 			*pvNextBSS = pBSS;
 			return;
@@ -487,10 +485,10 @@ VNTWIFIvUpdateNodeTxCounter(
 
 	if ((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) ||
 	    (pMgmt->eCurrMode == WMAC_MODE_ESS_AP)) {
-		if (BSSDBbIsSTAInNodeDB(pMgmt, pbyDestAddress, &uNodeIndex) == false) {
+		if (BSSDBbIsSTAInNodeDB(pMgmt, pbyDestAddress, &uNodeIndex) == false)
 			return;
-		}
 	}
+
 	pMgmt->sNodeDBTable[uNodeIndex].uTxAttempts++;
 	if (bTxOk) {
 		// transmit success, TxAttempts at least plus one
@@ -500,9 +498,9 @@ VNTWIFIvUpdateNodeTxCounter(
 		pMgmt->sNodeDBTable[uNodeIndex].uTxFailures++;
 	}
 	pMgmt->sNodeDBTable[uNodeIndex].uTxRetry += pbyTxFailCount[MAX_RATE];
-	for (ii = 0; ii < MAX_RATE; ii++) {
+	for (ii = 0; ii < MAX_RATE; ii++)
 		pMgmt->sNodeDBTable[uNodeIndex].uTxFail[ii] += pbyTxFailCount[ii];
-	}
+
 	return;
 }
 
@@ -533,11 +531,11 @@ VNTWIFIvGetTxRate(
 			pSupportRateIEs = (PWLAN_IE_SUPP_RATES) (pMgmt->sNodeDBTable[uNodeIndex].abyCurrSuppRates);
 			pExtSupportRateIEs = (PWLAN_IE_SUPP_RATES) (pMgmt->sNodeDBTable[uNodeIndex].abyCurrExtSuppRates);
 		} else {
-			if (pMgmt->eCurrentPHYMode != PHY_TYPE_11A) {
+			if (pMgmt->eCurrentPHYMode != PHY_TYPE_11A)
 				wTxDataRate = RATE_2M;
-			} else {
+			else
 				wTxDataRate = RATE_24M;
-			}
+
 			pSupportRateIEs = (PWLAN_IE_SUPP_RATES) pMgmt->abyCurrSuppRates;
 			pExtSupportRateIEs = (PWLAN_IE_SUPP_RATES) pMgmt->abyCurrExtSuppRates;
 		}
@@ -556,9 +554,9 @@ VNTWIFIvGetTxRate(
 					    pSupportRateIEs,
 					    pExtSupportRateIEs
 );
-	if (byACKRate > (unsigned char) wTxDataRate) {
+	if (byACKRate > (unsigned char) wTxDataRate)
 		byACKRate = (unsigned char) wTxDataRate;
-	}
+
 	byCCKBasicRate = VNTWIFIbyGetACKTxRate(RATE_11M,
 						pSupportRateIEs,
 						pExtSupportRateIEs
@@ -582,11 +580,10 @@ VNTWIFIbyGetKeyCypher(
 {
 	PSMgmtObject    pMgmt = (PSMgmtObject)pMgmtHandle;
 
-	if (bGroupKey) {
+	if (bGroupKey)
 		return pMgmt->byCSSGK;
-	} else {
+	else
 		return pMgmt->byCSSPK;
-	}
 }
 
 bool
@@ -598,9 +595,9 @@ VNTWIFIbSetPMKIDCache(
 {
 	PSMgmtObject    pMgmt = (PSMgmtObject) pMgmtObject;
 
-	if (ulCount > MAX_PMKID_CACHE) {
+	if (ulCount > MAX_PMKID_CACHE)
 		return false;
-	}
+
 	pMgmt->gsPMKIDCache.BSSIDInfoCount = ulCount;
 	memcpy(pMgmt->gsPMKIDCache.BSSIDInfo, pPMKIDInfo, (ulCount*sizeof(PMKIDInfo)));
 	return true;
@@ -615,15 +612,14 @@ VNTWIFIwGetMaxSupportRate(
 	PSMgmtObject    pMgmt = (PSMgmtObject) pMgmtObject;
 
 	for (wRate = RATE_54M; wRate > RATE_1M; wRate--) {
-		if (pMgmt->sNodeDBTable[0].wSuppRate & (1<<wRate)) {
+		if (pMgmt->sNodeDBTable[0].wSuppRate & (1<<wRate))
 			return wRate;
-		}
 	}
-	if (pMgmt->eCurrentPHYMode == PHY_TYPE_11A) {
+
+	if (pMgmt->eCurrentPHYMode == PHY_TYPE_11A)
 		return RATE_6M;
-	} else {
+	else
 		return RATE_1M;
-	}
 }
 
 void
diff --git a/drivers/staging/vt6655/wcmd.c b/drivers/staging/vt6655/wcmd.c
index 791b37e..a689645 100644
--- a/drivers/staging/vt6655/wcmd.c
+++ b/drivers/staging/vt6655/wcmd.c
@@ -127,14 +127,13 @@ vAdHocBeaconStop(PSDevice  pDevice)
 		    (pMgmt->uScanChannel > CB_MAX_CHANNEL_24G)) {
 			bStop = true;
 		}
-		if (pMgmt->uIBSSChannel >  CB_MAX_CHANNEL_24G) {
+		if (pMgmt->uIBSSChannel >  CB_MAX_CHANNEL_24G)
 			bStop = true;
-		}
+
 	}
 
-	if (bStop) {
+	if (bStop)
 		MACvRegBitsOff(pDevice->PortOffset, MAC_REG_TCR, TCR_AUTOBCNTX);
-	}
 } /* vAdHocBeaconStop */
 
 /*
@@ -196,13 +195,13 @@ s_vProbeChannel(
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 	unsigned int ii;
 
-	if (pDevice->eCurrentPHYType == PHY_TYPE_11A) {
+	if (pDevice->eCurrentPHYType == PHY_TYPE_11A)
 		pbyRate = &abyCurrSuppRatesA[0];
-	} else if (pDevice->eCurrentPHYType == PHY_TYPE_11B) {
+	else if (pDevice->eCurrentPHYType == PHY_TYPE_11B)
 		pbyRate = &abyCurrSuppRatesB[0];
-	} else {
+	else
 		pbyRate = &abyCurrSuppRatesG[0];
-	}
+
 	// build an assocreq frame and send it
 	pTxPacket = s_MgrMakeProbeRequest
 		(
@@ -216,11 +215,10 @@ s_vProbeChannel(
 
 	if (pTxPacket != NULL) {
 		for (ii = 0; ii < 2; ii++) {
-			if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING) {
+			if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING)
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Probe request sending fail.. \n");
-			} else {
+			else
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Probe request is sending.. \n");
-			}
 		}
 	}
 }
@@ -359,11 +357,11 @@ vCommandTimer(
 			// Set channel back
 			set_channel(pMgmt->pAdapter, pMgmt->uCurrChannel);
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Scanning, set back to channel: [%d]\n", pMgmt->uCurrChannel);
-			if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) {
+			if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA)
 				CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, OP_MODE_ADHOC);
-			} else {
+			else
 				CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, OP_MODE_INFRASTRUCTURE);
-			}
+
 			vAdHocBeaconRestart(pDevice);
 			s_bCommandComplete(pDevice);
 
@@ -389,11 +387,11 @@ vCommandTimer(
 
 			vAdHocBeaconStop(pDevice);
 
-			if (set_channel(pMgmt->pAdapter, pMgmt->uScanChannel)) {
+			if (set_channel(pMgmt->pAdapter, pMgmt->uScanChannel))
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "SCAN Channel: %d\n", pMgmt->uScanChannel);
-			} else {
+			else
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "SET SCAN Channel Fail: %d\n", pMgmt->uScanChannel);
-			}
+
 			CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, OP_MODE_UNKNOWN);
 			pMgmt->uScanChannel++;
 //2008-8-4 <modify> by chester
@@ -426,11 +424,10 @@ vCommandTimer(
 		// Set channel back
 		set_channel(pMgmt->pAdapter, pMgmt->uCurrChannel);
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Scanning, set back to channel: [%d]\n", pMgmt->uCurrChannel);
-		if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) {
+		if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA)
 			CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, OP_MODE_ADHOC);
-		} else {
+		else
 			CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, OP_MODE_INFRASTRUCTURE);
-		}
 
 		pMgmt->eScanState = WMAC_NO_SCANNING;
 		vAdHocBeaconRestart(pDevice);
@@ -534,9 +531,9 @@ vCommandTimer(
 		if ((pMgmt->eCurrMode == WMAC_MODE_ESS_STA) && (pMgmt->eCurrState == WMAC_STATE_JOINTED)) {
 			// Call mgr to begin the deauthentication
 			// reason = (3) because sta has left ESS
-			if (pMgmt->eCurrState >= WMAC_STATE_AUTH) {
+			if (pMgmt->eCurrState >= WMAC_STATE_AUTH)
 				vMgrDeAuthenBeginSta((void *)pDevice, pMgmt, pMgmt->abyCurrBSSID, (3), &Status);
-			}
+
 			// Call mgr to begin the authentication
 			vMgrAuthenBeginSta((void *)pDevice, pMgmt, &Status);
 			if (Status == CMD_STATUS_SUCCESS) {
@@ -551,9 +548,9 @@ vCommandTimer(
 		// if Adhoc mode
 		else if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) {
 			if (pMgmt->eCurrState == WMAC_STATE_JOINTED) {
-				if (netif_queue_stopped(pDevice->dev)) {
+				if (netif_queue_stopped(pDevice->dev))
 					netif_wake_queue(pDevice->dev);
-				}
+
 				pDevice->bLinkPass = true;
 
 				pMgmt->sNodeDBTable[0].bActive = true;
@@ -562,9 +559,9 @@ vCommandTimer(
 			} else {
 				// start own IBSS
 				vMgrCreateOwnIBSS((void *)pDevice, &Status);
-				if (Status != CMD_STATUS_SUCCESS) {
+				if (Status != CMD_STATUS_SUCCESS)
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " WLAN_CMD_IBSS_CREATE fail ! \n");
-				}
+
 				BSSvAddMulticastNode(pDevice);
 			}
 		}
@@ -574,13 +571,13 @@ vCommandTimer(
 			    pMgmt->eConfigMode == WMAC_CONFIG_AUTO) {
 				// start own IBSS
 				vMgrCreateOwnIBSS((void *)pDevice, &Status);
-				if (Status != CMD_STATUS_SUCCESS) {
+				if (Status != CMD_STATUS_SUCCESS)
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " WLAN_CMD_IBSS_CREATE fail ! \n");
-				}
+
 				BSSvAddMulticastNode(pDevice);
-				if (netif_queue_stopped(pDevice->dev)) {
+				if (netif_queue_stopped(pDevice->dev))
 					netif_wake_queue(pDevice->dev);
-				}
+
 				pDevice->bLinkPass = true;
 			} else {
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Disconnect SSID none\n");
@@ -632,12 +629,12 @@ vCommandTimer(
 	case WLAN_ASSOCIATE_WAIT:
 		if (pMgmt->eCurrState == WMAC_STATE_ASSOC) {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "eCurrState == WMAC_STATE_ASSOC\n");
-			if (pDevice->ePSMode != WMAC_POWER_CAM) {
+			if (pDevice->ePSMode != WMAC_POWER_CAM)
 				PSvEnablePowerSaving((void *)pDevice, pMgmt->wListenInterval);
-			}
-			if (pMgmt->eAuthenMode >= WMAC_AUTH_WPA) {
+
+			if (pMgmt->eAuthenMode >= WMAC_AUTH_WPA)
 				KeybRemoveAllKey(&(pDevice->sKey), pDevice->abyBSSID, pDevice->PortOffset);
-			}
+
 			pDevice->bLinkPass = true;
 			pDevice->byLinkWaitCount = 0;
 			pDevice->byReAssocCount = 0;
@@ -646,9 +643,9 @@ vCommandTimer(
 				BBvSetFOE(pDevice->PortOffset);
 				PSbSendNullPacket(pDevice);
 			}
-			if (netif_queue_stopped(pDevice->dev)) {
+			if (netif_queue_stopped(pDevice->dev))
 				netif_wake_queue(pDevice->dev);
-			}
+
 #ifdef TxInSleep
 			if (pDevice->IsTxDataTrigger) {    //TxDataTimer is not triggered at the first time
 				del_timer(&pDevice->sTimerTxData);
@@ -658,8 +655,8 @@ vCommandTimer(
 				pDevice->sTimerTxData.expires = RUN_AT(10*HZ);      //10s callback
 				pDevice->fTxDataInSleep = false;
 				pDevice->nTxDataTimeCout = 0;
-			} else {
 			}
+
 			pDevice->IsTxDataTrigger = true;
 			add_timer(&pDevice->sTimerTxData);
 #endif
@@ -694,17 +691,17 @@ vCommandTimer(
 			pDevice->bFixRate = false;
 
 			vMgrCreateOwnIBSS((void *)pDevice, &Status);
-			if (Status != CMD_STATUS_SUCCESS) {
+			if (Status != CMD_STATUS_SUCCESS)
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " vMgrCreateOwnIBSS fail ! \n");
-			}
+
 			// alway turn off unicast bit
 			MACvRegBitsOff(pDevice->PortOffset, MAC_REG_RCR, RCR_UNICAST);
 			pDevice->byRxMode &= ~RCR_UNICAST;
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wcmd: rx_mode = %x\n", pDevice->byRxMode);
 			BSSvAddMulticastNode(pDevice);
-			if (netif_queue_stopped(pDevice->dev)) {
+			if (netif_queue_stopped(pDevice->dev))
 				netif_wake_queue(pDevice->dev);
-			}
+
 			pDevice->bLinkPass = true;
 			add_timer(&pMgmt->sTimerSecondCallback);
 		}
@@ -721,9 +718,9 @@ vCommandTimer(
 				} else {
 					pDevice->bMoreData = true;
 				}
-				if (!device_dma0_xmit(pDevice, skb, 0)) {
+				if (!device_dma0_xmit(pDevice, skb, 0))
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Multicast ps tx fail \n");
-				}
+
 				pMgmt->sNodeDBTable[0].wEnQueueCnt--;
 			}
 		}
@@ -743,9 +740,9 @@ vCommandTimer(
 					} else {
 						pDevice->bMoreData = true;
 					}
-					if (!device_dma0_xmit(pDevice, skb, ii)) {
+					if (!device_dma0_xmit(pDevice, skb, ii))
 						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "sta ps tx fail \n");
-					}
+
 					pMgmt->sNodeDBTable[ii].wEnQueueCnt--;
 					// check if sta ps enabled, and wait next pspoll.
 					// if sta ps disable, then send all pending buffers.
@@ -831,11 +828,11 @@ s_bCommandComplete(
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "eCommandState= WLAN_CMD_BSSID_SCAN\n");
 			pDevice->eCommandState = WLAN_CMD_SCAN_START;
 			pMgmt->uScanChannel = 0;
-			if (pSSID->len != 0) {
+			if (pSSID->len != 0)
 				memcpy(pMgmt->abyScanSSID, pSSID, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
-			} else {
+			else
 				memset(pMgmt->abyScanSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
-			}
+
 			break;
 		case WLAN_CMD_SSID:
 			pDevice->eCommandState = WLAN_CMD_SSID_START;
@@ -881,9 +878,9 @@ bool bScheduleCommand(
 {
 	PSDevice        pDevice = (PSDevice)hDeviceContext;
 
-	if (pDevice->cbFreeCmdQueue == 0) {
+	if (pDevice->cbFreeCmdQueue == 0)
 		return false;
-	}
+
 	pDevice->eCmdQueue[pDevice->uCmdEnqueueIdx].eCmd = eCommand;
 	pDevice->eCmdQueue[pDevice->uCmdEnqueueIdx].bForceSCAN = true;
 	memset(pDevice->eCmdQueue[pDevice->uCmdEnqueueIdx].abyCmdDesireSSID, 0 , WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
diff --git a/drivers/staging/vt6655/wctl.c b/drivers/staging/vt6655/wctl.c
index 0ae57f1..fddea9f 100644
--- a/drivers/staging/vt6655/wctl.c
+++ b/drivers/staging/vt6655/wctl.c
@@ -191,9 +191,8 @@ bool WCTLbHandleFragment(PSDevice pDevice, PS802_11Header pMACHeader, unsigned i
 			pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].wFragNum = (pMACHeader->wSeqCtl & 0x000F);
 		} else {
 			pDevice->uCurrentDFCBIdx = WCTLuInsertDFCB(pDevice, pMACHeader);
-			if (pDevice->uCurrentDFCBIdx == pDevice->cbDFCB) {
+			if (pDevice->uCurrentDFCBIdx == pDevice->cbDFCB)
 				return false;
-			}
 		}
 		// reserve 4 byte to match MAC RX Buffer
 		pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].pbyRxBuffer = (unsigned char *)(pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].skb->data + 4);
diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index 1d9de1f..6738478 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -350,9 +350,9 @@ vMgrObjectInit(
 	pMgmt->pbyPSPacketPool = &pMgmt->byPSPacketPool[0];
 	pMgmt->pbyMgmtPacketPool = &pMgmt->byMgmtPacketPool[0];
 	pMgmt->uCurrChannel = pDevice->uChannel;
-	for (ii = 0; ii < WLAN_BSSID_LEN; ii++) {
+	for (ii = 0; ii < WLAN_BSSID_LEN; ii++)
 		pMgmt->abyDesireBSSID[ii] = 0xFF;
-	}
+
 	pMgmt->sAssocInfo.AssocInfo.Length = sizeof(NDIS_802_11_ASSOCIATION_INFORMATION);
 	pMgmt->byCSSPK = KEY_CTL_NONE;
 	pMgmt->byCSSGK = KEY_CTL_NONE;
@@ -456,9 +456,9 @@ vMgrAssocBeginSta(
 
 	pMgmt->wCurrCapInfo = 0;
 	pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_ESS(1);
-	if (pDevice->bEncryptionEnable) {
+	if (pDevice->bEncryptionEnable)
 		pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_PRIVACY(1);
-	}
+
 	pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_SHORTPREAMBLE(1);
 	if (pMgmt->wListenInterval == 0)
 		pMgmt->wListenInterval = 1;    // at least one.
@@ -466,13 +466,11 @@ vMgrAssocBeginSta(
 	// ERP Phy (802.11g) should support short preamble.
 	if (pMgmt->eCurrentPHYMode == PHY_TYPE_11G) {
 		pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_SHORTPREAMBLE(1);
-		if (CARDbIsShorSlotTime(pMgmt->pAdapter)) {
+		if (CARDbIsShorSlotTime(pMgmt->pAdapter))
 			pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_SHORTSLOTTIME(1);
-		}
 	} else if (pMgmt->eCurrentPHYMode == PHY_TYPE_11B) {
-		if (CARDbIsShortPreamble(pMgmt->pAdapter)) {
+		if (CARDbIsShortPreamble(pMgmt->pAdapter))
 			pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_SHORTPREAMBLE(1);
-		}
 	}
 	if (pMgmt->b11hEnable)
 		pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_SPECTRUMMNG(1);
@@ -497,8 +495,9 @@ vMgrAssocBeginSta(
 			pMgmt->eCurrState = WMAC_STATE_ASSOCPENDING;
 			*pStatus = CMD_STATUS_SUCCESS;
 		}
-	} else
+	} else {
 		*pStatus = CMD_STATUS_RESOURCES;
+	}
 
 	return;
 }
@@ -525,9 +524,8 @@ vMgrReAssocBeginSta(
 
 	pMgmt->wCurrCapInfo = 0;
 	pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_ESS(1);
-	if (pDevice->bEncryptionEnable) {
+	if (pDevice->bEncryptionEnable)
 		pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_PRIVACY(1);
-	}
 
 	pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_SHORTPREAMBLE(1);
 
@@ -537,14 +535,13 @@ vMgrReAssocBeginSta(
 	// ERP Phy (802.11g) should support short preamble.
 	if (pMgmt->eCurrentPHYMode == PHY_TYPE_11G) {
 		pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_SHORTPREAMBLE(1);
-		if (CARDbIsShorSlotTime(pMgmt->pAdapter)) {
+		if (CARDbIsShorSlotTime(pMgmt->pAdapter))
 			pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_SHORTSLOTTIME(1);
-		}
 	} else if (pMgmt->eCurrentPHYMode == PHY_TYPE_11B) {
-		if (CARDbIsShortPreamble(pMgmt->pAdapter)) {
+		if (CARDbIsShortPreamble(pMgmt->pAdapter))
 			pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_SHORTPREAMBLE(1);
-		}
 	}
+
 	if (pMgmt->b11hEnable)
 		pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_SPECTRUMMNG(1);
 
@@ -563,11 +560,10 @@ vMgrReAssocBeginSta(
 	if (pTxPacket != NULL) {
 		/* send the frame */
 		*pStatus = csMgmt_xmit(pDevice, pTxPacket);
-		if (*pStatus != CMD_STATUS_PENDING) {
+		if (*pStatus != CMD_STATUS_PENDING)
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Reassociation tx failed.\n");
-		} else {
+		else
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Reassociation tx sending.\n");
-		}
 	}
 
 	return;
@@ -684,21 +680,20 @@ s_vMgrRxAssocRequest(
 		pMgmt->sNodeDBTable[uNodeIndex].bPSEnable =
 			WLAN_GET_FC_PWRMGT(sFrame.pHdr->sA3.wFrameCtl) ? true : false;
 		// Todo: check sta basic rate, if ap can't support, set status code
-		if (pDevice->eCurrentPHYType == PHY_TYPE_11B) {
+		if (pDevice->eCurrentPHYType == PHY_TYPE_11B)
 			uRateLen = WLAN_RATES_MAXLEN_11B;
-		}
+
 		abyCurrSuppRates[0] = WLAN_EID_SUPP_RATES;
 		abyCurrSuppRates[1] = RATEuSetIE((PWLAN_IE_SUPP_RATES)sFrame.pSuppRates,
 						 (PWLAN_IE_SUPP_RATES)abyCurrSuppRates,
 						 uRateLen);
 		abyCurrExtSuppRates[0] = WLAN_EID_EXTSUPP_RATES;
-		if (pDevice->eCurrentPHYType == PHY_TYPE_11G) {
+		if (pDevice->eCurrentPHYType == PHY_TYPE_11G)
 			abyCurrExtSuppRates[1] = RATEuSetIE((PWLAN_IE_SUPP_RATES)sFrame.pExtSuppRates,
 							    (PWLAN_IE_SUPP_RATES)abyCurrExtSuppRates,
 							    uRateLen);
-		} else {
+		else
 			abyCurrExtSuppRates[1] = 0;
-		}
 
 		RATEvParseMaxRate((void *)pDevice,
 				  (PWLAN_IE_SUPP_RATES)abyCurrSuppRates,
@@ -734,9 +729,8 @@ s_vMgrRxAssocRequest(
 			pDevice->bProtectMode = true;
 			pDevice->bNonERPPresent = true;
 		}
-		if (!pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble) {
+		if (!pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble)
 			pDevice->bBarkerPreambleMd = true;
-		}
 
 		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Associate AID= %d \n", wAssocAID);
 		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "MAC=%2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X \n",
@@ -749,8 +743,8 @@ s_vMgrRxAssocRequest(
 			);
 		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Max Support rate = %d \n",
 			pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate);
-	}//else { TODO: received STA under state1 handle }
-	else {
+	} else {
+		/* TODO: received STA under state1 handle */
 		return;
 	}
 
@@ -767,17 +761,15 @@ s_vMgrRxAssocRequest(
 			(PWLAN_IE_SUPP_RATES)pMgmt->abyCurrExtSuppRates
 );
 	if (pTxPacket != NULL) {
-		if (pDevice->bEnableHostapd) {
+		if (pDevice->bEnableHostapd)
 			return;
-		}
+
 		/* send the frame */
 		Status = csMgmt_xmit(pDevice, pTxPacket);
-		if (Status != CMD_STATUS_PENDING) {
+		if (Status != CMD_STATUS_PENDING)
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Assoc response tx failed\n");
-		} else {
+		else
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Assoc response tx sending..\n");
-		}
-
 	}
 
 	return;
@@ -837,9 +829,8 @@ s_vMgrRxReAssocRequest(
 			WLAN_GET_FC_PWRMGT(sFrame.pHdr->sA3.wFrameCtl) ? true : false;
 		// Todo: check sta basic rate, if ap can't support, set status code
 
-		if (pDevice->eCurrentPHYType == PHY_TYPE_11B) {
+		if (pDevice->eCurrentPHYType == PHY_TYPE_11B)
 			uRateLen = WLAN_RATES_MAXLEN_11B;
-		}
 
 		abyCurrSuppRates[0] = WLAN_EID_SUPP_RATES;
 		abyCurrSuppRates[1] = RATEuSetIE((PWLAN_IE_SUPP_RATES)sFrame.pSuppRates,
@@ -889,9 +880,8 @@ s_vMgrRxReAssocRequest(
 			pDevice->bProtectMode = true;
 			pDevice->bNonERPPresent = true;
 		}
-		if (!pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble) {
+		if (!pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble)
 			pDevice->bBarkerPreambleMd = true;
-		}
 
 		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Rx ReAssociate AID= %d \n", wAssocAID);
 		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "MAC=%2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X \n",
@@ -922,15 +912,14 @@ s_vMgrRxReAssocRequest(
 
 	if (pTxPacket != NULL) {
 		/* send the frame */
-		if (pDevice->bEnableHostapd) {
+		if (pDevice->bEnableHostapd)
 			return;
-		}
+
 		Status = csMgmt_xmit(pDevice, pTxPacket);
-		if (Status != CMD_STATUS_PENDING) {
+		if (Status != CMD_STATUS_PENDING)
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:ReAssoc response tx failed\n");
-		} else {
+		else
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:ReAssoc response tx sending..\n");
-		}
 	}
 	return;
 }
@@ -988,9 +977,9 @@ s_vMgrRxAssocResponse(
 		if (cpu_to_le16((*(sFrame.pwStatus))) == WLAN_MGMT_STATUS_SUCCESS) {
 			// set AID
 			pMgmt->wCurrAID = cpu_to_le16((*(sFrame.pwAid)));
-			if ((pMgmt->wCurrAID >> 14) != (BIT0 | BIT1)) {
+			if ((pMgmt->wCurrAID >> 14) != (BIT0 | BIT1))
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "AID from AP, has two msb clear.\n");
-			}
+
 			DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Association Successful, AID=%d.\n", pMgmt->wCurrAID & ~(BIT14 | BIT15));
 			pMgmt->eCurrState = WMAC_STATE_ASSOC;
 			BSSvUpdateAPNode((void *)pDevice, sFrame.pwCapInfo, sFrame.pSuppRates, sFrame.pExtSuppRates);
@@ -1187,9 +1176,8 @@ vMgrDeAuthenBeginSta(
 	pTxPacket->cbPayloadLen = sFrame.len - WLAN_HDR_ADDR3_LEN;
 
 	*pStatus = csMgmt_xmit(pDevice, pTxPacket);
-	if (*pStatus == CMD_STATUS_PENDING) {
+	if (*pStatus == CMD_STATUS_PENDING)
 		*pStatus = CMD_STATUS_SUCCESS;
-	}
 
 	return;
 }
@@ -1338,13 +1326,13 @@ s_vMgrRxAuthenSequence_1(
 	pTxPacket->cbMPDULen = sFrame.len;
 	pTxPacket->cbPayloadLen = sFrame.len - WLAN_HDR_ADDR3_LEN;
 	// send the frame
-	if (pDevice->bEnableHostapd) {
+	if (pDevice->bEnableHostapd)
 		return;
-	}
+
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Authreq_reply sequence_1 tx.. \n");
-	if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING) {
+	if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING)
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Authreq_reply sequence_1 tx failed.\n");
-	}
+
 	return;
 }
 
@@ -1417,9 +1405,9 @@ s_vMgrRxAuthenSequence_2(
 			pTxPacket->cbMPDULen = sFrame.len;
 			pTxPacket->cbPayloadLen = sFrame.len - WLAN_HDR_ADDR3_LEN;
 			// send the frame
-			if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING) {
+			if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING)
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Auth_reply sequence_2 tx failed.\n");
-			}
+
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Auth_reply sequence_2 tx ...\n");
 		} else {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:rx Auth_reply sequence_2 status error ...\n");
@@ -1511,12 +1499,12 @@ reply:
 	pTxPacket->cbMPDULen = sFrame.len;
 	pTxPacket->cbPayloadLen = sFrame.len - WLAN_HDR_ADDR3_LEN;
 	// send the frame
-	if (pDevice->bEnableHostapd) {
+	if (pDevice->bEnableHostapd)
 		return;
-	}
-	if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING) {
+
+	if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING)
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Authreq_reply sequence_4 tx failed.\n");
-	}
+
 	return;
 }
 
@@ -1577,11 +1565,11 @@ s_vMgrRxDisassociation(
 		// a STA is leaving this BSS..
 		sFrame.len = pRxPacket->cbMPDULen;
 		sFrame.pBuf = (unsigned char *)pRxPacket->p80211Header;
-		if (BSSDBbIsSTAInNodeDB(pMgmt, pRxPacket->p80211Header->sA3.abyAddr2, &uNodeIndex)) {
+		if (BSSDBbIsSTAInNodeDB(pMgmt, pRxPacket->p80211Header->sA3.abyAddr2, &uNodeIndex))
 			BSSvRemoveOneNode(pDevice, uNodeIndex);
-		} else {
+		else
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Rx disassoc, sta not found\n");
-		}
+
 	} else if (pMgmt->eCurrMode == WMAC_MODE_ESS_STA) {
 		sFrame.len = pRxPacket->cbMPDULen;
 		sFrame.pBuf = (unsigned char *)pRxPacket->p80211Header;
@@ -1649,11 +1637,10 @@ s_vMgrRxDeauthentication(
 		// a STA is leaving this BSS..
 		sFrame.len = pRxPacket->cbMPDULen;
 		sFrame.pBuf = (unsigned char *)pRxPacket->p80211Header;
-		if (BSSDBbIsSTAInNodeDB(pMgmt, pRxPacket->p80211Header->sA3.abyAddr2, &uNodeIndex)) {
+		if (BSSDBbIsSTAInNodeDB(pMgmt, pRxPacket->p80211Header->sA3.abyAddr2, &uNodeIndex))
 			BSSvRemoveOneNode(pDevice, uNodeIndex);
-		} else {
+		else
 			DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Rx deauth, sta not found\n");
-		}
 	} else {
 		if (pMgmt->eCurrMode == WMAC_MODE_ESS_STA) {
 			sFrame.len = pRxPacket->cbMPDULen;
@@ -1874,9 +1861,8 @@ s_vMgrRxBeacon(
 
 	}
 
-	if (bInScan) {
+	if (bInScan)
 		return;
-	}
 
 	if (byCurrChannel == (unsigned char)pMgmt->uCurrChannel)
 		bIsChannelEqual = true;
@@ -1960,9 +1946,9 @@ s_vMgrRxBeacon(
 			//
 			// Basic Rate Set may change dynamically
 			//
-			if (pBSSList->eNetworkTypeInUse == PHY_TYPE_11B) {
+			if (pBSSList->eNetworkTypeInUse == PHY_TYPE_11B)
 				uRateLen = WLAN_RATES_MAXLEN_11B;
-			}
+
 			pMgmt->abyCurrSuppRates[1] = RATEuSetIE((PWLAN_IE_SUPP_RATES)pBSSList->abySuppRates,
 								(PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
 								uRateLen);
@@ -2022,22 +2008,20 @@ s_vMgrRxBeacon(
 
 	// check if beacon TSF larger or small than our local TSF
 	if (HIDWORD(qwTimestamp) == HIDWORD(qwLocalTSF)) {
-		if (LODWORD(qwTimestamp) >= LODWORD(qwLocalTSF)) {
+		if (LODWORD(qwTimestamp) >= LODWORD(qwLocalTSF))
 			bTSFOffsetPostive = true;
-		} else {
+		else
 			bTSFOffsetPostive = false;
-		}
 	} else if (HIDWORD(qwTimestamp) > HIDWORD(qwLocalTSF)) {
 		bTSFOffsetPostive = true;
 	} else if (HIDWORD(qwTimestamp) < HIDWORD(qwLocalTSF)) {
 		bTSFOffsetPostive = false;
 	}
 
-	if (bTSFOffsetPostive) {
+	if (bTSFOffsetPostive)
 		qwTSFOffset = CARDqGetTSFOffset(pRxPacket->byRxRate, (qwTimestamp), (qwLocalTSF));
-	} else {
+	else
 		qwTSFOffset = CARDqGetTSFOffset(pRxPacket->byRxRate, (qwLocalTSF), (qwTimestamp));
-	}
 
 	if (HIDWORD(qwTSFOffset) != 0 ||
 	    (LODWORD(qwTSFOffset) > TRIVIAL_SYNC_DIFFERENCE)) {
@@ -2091,9 +2075,8 @@ s_vMgrRxBeacon(
 					if (PSbSendNullPacket(pDevice))
 						pDevice->bPWBitOn = true;
 				}
-				if (PSbConsiderPowerDown(pDevice, false, false)) {
+				if (PSbConsiderPowerDown(pDevice, false, false))
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BCN: Power down now...\n");
-				}
 			}
 
 		}
@@ -2164,9 +2147,9 @@ s_vMgrRxBeacon(
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Current IBSS State: [Started]........to: [Jointed] \n");
 				pMgmt->eCurrState = WMAC_STATE_JOINTED;
 				pDevice->bLinkPass = true;
-				if (netif_queue_stopped(pDevice->dev)) {
+				if (netif_queue_stopped(pDevice->dev))
 					netif_wake_queue(pDevice->dev);
-				}
+
 				pMgmt->sNodeDBTable[0].bActive = true;
 				pMgmt->sNodeDBTable[0].uInActiveCount = 0;
 
@@ -2332,9 +2315,8 @@ vMgrCreateOwnIBSS(
 			  &wMaxBasicRate, &wMaxSuppRate, &wSuppRate,
 			  &byTopCCKBasicRate, &byTopOFDMBasicRate);
 
-	if (pMgmt->eConfigMode == WMAC_CONFIG_AP) {
+	if (pMgmt->eConfigMode == WMAC_CONFIG_AP)
 		pMgmt->eCurrMode = WMAC_MODE_ESS_AP;
-	}
 
 	if (pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) {
 		memcpy(pMgmt->abyIBSSDFSOwner, pDevice->abyCurrentNetAddr, 6);
@@ -2393,9 +2375,8 @@ vMgrCreateOwnIBSS(
 		pMgmt->byDTIMCount = pMgmt->byDTIMPeriod - 1;
 	}
 
-	if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) {
+	if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA)
 		pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_IBSS(1);
-	}
 
 	if (pDevice->bEncryptionEnable) {
 		pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_PRIVACY(1);
@@ -2437,11 +2418,10 @@ vMgrCreateOwnIBSS(
 	set_channel(pMgmt->pAdapter, pMgmt->uIBSSChannel);
 	pMgmt->uCurrChannel = pMgmt->uIBSSChannel;
 
-	if (CARDbIsShortPreamble(pMgmt->pAdapter)) {
+	if (CARDbIsShortPreamble(pMgmt->pAdapter))
 		pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_SHORTPREAMBLE(1);
-	} else {
+	else
 		pMgmt->wCurrCapInfo &= (~WLAN_SET_CAP_INFO_SHORTPREAMBLE(1));
-	}
 
 	if (pMgmt->b11hEnable &&
 	    (pMgmt->eCurrentPHYMode == PHY_TYPE_11A)) {
@@ -2452,9 +2432,8 @@ vMgrCreateOwnIBSS(
 
 	pMgmt->eCurrState = WMAC_STATE_STARTED;
 	// Prepare beacon to send
-	if (bMgrPrepareBeaconToSend((void *)pDevice, pMgmt)) {
+	if (bMgrPrepareBeaconToSend((void *)pDevice, pMgmt))
 		*pStatus = CMD_STATUS_SUCCESS;
-	}
 
 	return;
 }
@@ -2541,9 +2520,8 @@ vMgrJoinBSSBegin(
 			memset(pMgmt->abyCurrSuppRates, 0 , WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1);
 			memset(pMgmt->abyCurrExtSuppRates, 0 , WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1);
 
-			if (pCurr->eNetworkTypeInUse == PHY_TYPE_11B) {
+			if (pCurr->eNetworkTypeInUse == PHY_TYPE_11B)
 				uRateLen = WLAN_RATES_MAXLEN_11B;
-			}
 
 			pItemRates = (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates;
 			pItemExtRates = (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrExtSuppRates;
@@ -2570,9 +2548,8 @@ vMgrJoinBSSBegin(
 				pItemRates->len += (unsigned char)ii;
 				if (pItemExtRates->len - ii > 0) {
 					pItemExtRates->len -= (unsigned char)ii;
-					for (uu = 0; uu < pItemExtRates->len; uu++) {
+					for (uu = 0; uu < pItemExtRates->len; uu++)
 						pItemExtRates->abyRates[uu] = pItemExtRates->abyRates[uu + ii];
-					}
 				} else {
 					pItemExtRates->len = 0;
 				}
@@ -2799,9 +2776,8 @@ s_vMgrSynchBSS(
 		CARDbSetBSSID(pMgmt->pAdapter, pCurr->abyBSSID, OP_MODE_INFRASTRUCTURE);
 		// Add current BSS to Candidate list
 		// This should only works for WPA2 BSS, and WPA2 BSS check must be done before.
-		if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2) {
+		if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2)
 			CARDbAdd_PMKID_Candidate(pMgmt->pAdapter, pMgmt->abyCurrBSSID, pCurr->sRSNCapObj.bRSNCapExist, pCurr->sRSNCapObj.wRSNCap);
-		}
 	} else {
 		CARDbSetBSSID(pMgmt->pAdapter, pCurr->abyBSSID, OP_MODE_ADHOC);
 	}
@@ -2898,9 +2874,9 @@ s_vMgrFormatTIM(
 		if (!ii) {
 			// Mask out the broadcast bit which is indicated separately.
 			bMulticast = (byMap & byMask[0]) != 0;
-			if (bMulticast) {
+			if (bMulticast)
 				pMgmt->sNodeDBTable[0].bRxPSPoll = true;
-			}
+
 			byMap = 0;
 		}
 		if (byMap) {
@@ -2930,9 +2906,8 @@ s_vMgrFormatTIM(
 
 	// Append variable part of TIM
 
-	for (ii = wStartIndex, jj = 0; ii <= wEndIndex; ii++, jj++) {
+	for (ii = wStartIndex, jj = 0; ii <= wEndIndex; ii++, jj++)
 		pTIM->byVirtBitMap[jj] = pMgmt->abyPSTxMap[ii];
-	}
 
 	// Aid = 0 don't used.
 	pTIM->byVirtBitMap[0]  &= ~BIT0;
@@ -2987,9 +2962,8 @@ s_MgrMakeBeacon(
 			WLAN_SET_FC_FSTYPE(WLAN_FSTYPE_BEACON)
 ));
 
-	if (pDevice->bEnablePSMode) {
+	if (pDevice->bEnablePSMode)
 		sFrame.pHdr->sA3.wFrameCtl |= cpu_to_le16((unsigned short)WLAN_SET_FC_PWRMGT(1));
-	}
 
 	memcpy(sFrame.pHdr->sA3.abyAddr1, abyBroadcastAddr, WLAN_ADDR_LEN);
 	memcpy(sFrame.pHdr->sA3.abyAddr2, pMgmt->abyMACAddr, WLAN_ADDR_LEN);
@@ -3212,9 +3186,8 @@ s_MgrMakeProbeResponse(
 	*sFrame.pwBeaconInterval = cpu_to_le16(wCurrBeaconPeriod);
 	*sFrame.pwCapInfo = cpu_to_le16(wCurrCapInfo);
 
-	if (byPHYType == BB_TYPE_11B) {
+	if (byPHYType == BB_TYPE_11B)
 		*sFrame.pwCapInfo &= cpu_to_le16((unsigned short)~(WLAN_SET_CAP_INFO_SHORTSLOTTIME(1)));
-	}
 
 	// Copy SSID
 	sFrame.pSSID = (PWLAN_IE_SSID)(sFrame.pBuf + sFrame.len);
@@ -3457,27 +3430,27 @@ s_MgrMakeAssocRequest(
 		sFrame.pRSNWPA->abyMulticast[0] = 0x00;
 		sFrame.pRSNWPA->abyMulticast[1] = 0x50;
 		sFrame.pRSNWPA->abyMulticast[2] = 0xf2;
-		if (pMgmt->byCSSGK == KEY_CTL_WEP) {
+		if (pMgmt->byCSSGK == KEY_CTL_WEP)
 			sFrame.pRSNWPA->abyMulticast[3] = pMgmt->pCurrBSS->byGKType;
-		} else if (pMgmt->byCSSGK == KEY_CTL_TKIP) {
+		else if (pMgmt->byCSSGK == KEY_CTL_TKIP)
 			sFrame.pRSNWPA->abyMulticast[3] = WPA_TKIP;
-		} else if (pMgmt->byCSSGK == KEY_CTL_CCMP) {
+		else if (pMgmt->byCSSGK == KEY_CTL_CCMP)
 			sFrame.pRSNWPA->abyMulticast[3] = WPA_AESCCMP;
-		} else {
+		else
 			sFrame.pRSNWPA->abyMulticast[3] = WPA_NONE;
-		}
+
 		// Pairwise Key Cipher Suite
 		sFrame.pRSNWPA->wPKCount = 1;
 		sFrame.pRSNWPA->PKSList[0].abyOUI[0] = 0x00;
 		sFrame.pRSNWPA->PKSList[0].abyOUI[1] = 0x50;
 		sFrame.pRSNWPA->PKSList[0].abyOUI[2] = 0xf2;
-		if (pMgmt->byCSSPK == KEY_CTL_TKIP) {
+		if (pMgmt->byCSSPK == KEY_CTL_TKIP)
 			sFrame.pRSNWPA->PKSList[0].abyOUI[3] = WPA_TKIP;
-		} else if (pMgmt->byCSSPK == KEY_CTL_CCMP) {
+		else if (pMgmt->byCSSPK == KEY_CTL_CCMP)
 			sFrame.pRSNWPA->PKSList[0].abyOUI[3] = WPA_AESCCMP;
-		} else {
+		else
 			sFrame.pRSNWPA->PKSList[0].abyOUI[3] = WPA_NONE;
-		}
+
 		// Auth Key Management Suite
 		pbyRSN = (unsigned char *)(sFrame.pBuf + sFrame.len + 2 + sFrame.pRSNWPA->len);
 		*pbyRSN++ = 0x01;
@@ -3486,13 +3459,12 @@ s_MgrMakeAssocRequest(
 
 		*pbyRSN++ = 0x50;
 		*pbyRSN++ = 0xf2;
-		if (pMgmt->eAuthenMode == WMAC_AUTH_WPAPSK) {
+		if (pMgmt->eAuthenMode == WMAC_AUTH_WPAPSK)
 			*pbyRSN++ = WPA_AUTH_PSK;
-		} else if (pMgmt->eAuthenMode == WMAC_AUTH_WPA) {
+		else if (pMgmt->eAuthenMode == WMAC_AUTH_WPA)
 			*pbyRSN++ = WPA_AUTH_IEEE802_1X;
-		} else {
+		else
 			*pbyRSN++ = WPA_NONE;
-		}
 
 		sFrame.pRSNWPA->len += 6;
 
@@ -3523,15 +3495,14 @@ s_MgrMakeAssocRequest(
 		sFrame.pRSN->abyRSN[0] = 0x00;
 		sFrame.pRSN->abyRSN[1] = 0x0F;
 		sFrame.pRSN->abyRSN[2] = 0xAC;
-		if (pMgmt->byCSSGK == KEY_CTL_WEP) {
+		if (pMgmt->byCSSGK == KEY_CTL_WEP)
 			sFrame.pRSN->abyRSN[3] = pMgmt->pCurrBSS->byCSSGK;
-		} else if (pMgmt->byCSSGK == KEY_CTL_TKIP) {
+		else if (pMgmt->byCSSGK == KEY_CTL_TKIP)
 			sFrame.pRSN->abyRSN[3] = WLAN_11i_CSS_TKIP;
-		} else if (pMgmt->byCSSGK == KEY_CTL_CCMP) {
+		else if (pMgmt->byCSSGK == KEY_CTL_CCMP)
 			sFrame.pRSN->abyRSN[3] = WLAN_11i_CSS_CCMP;
-		} else {
+		else
 			sFrame.pRSN->abyRSN[3] = WLAN_11i_CSS_UNKNOWN;
-		}
 
 		// Pairwise Key Cipher Suite
 		sFrame.pRSN->abyRSN[4] = 1;
@@ -3539,15 +3510,15 @@ s_MgrMakeAssocRequest(
 		sFrame.pRSN->abyRSN[6] = 0x00;
 		sFrame.pRSN->abyRSN[7] = 0x0F;
 		sFrame.pRSN->abyRSN[8] = 0xAC;
-		if (pMgmt->byCSSPK == KEY_CTL_TKIP) {
+		if (pMgmt->byCSSPK == KEY_CTL_TKIP)
 			sFrame.pRSN->abyRSN[9] = WLAN_11i_CSS_TKIP;
-		} else if (pMgmt->byCSSPK == KEY_CTL_CCMP) {
+		else if (pMgmt->byCSSPK == KEY_CTL_CCMP)
 			sFrame.pRSN->abyRSN[9] = WLAN_11i_CSS_CCMP;
-		} else if (pMgmt->byCSSPK == KEY_CTL_NONE) {
+		else if (pMgmt->byCSSPK == KEY_CTL_NONE)
 			sFrame.pRSN->abyRSN[9] = WLAN_11i_CSS_USE_GROUP;
-		} else {
+		else
 			sFrame.pRSN->abyRSN[9] = WLAN_11i_CSS_UNKNOWN;
-		}
+
 		sFrame.pRSN->len += 6;
 
 		// Auth Key Management Suite
@@ -3556,13 +3527,13 @@ s_MgrMakeAssocRequest(
 		sFrame.pRSN->abyRSN[12] = 0x00;
 		sFrame.pRSN->abyRSN[13] = 0x0F;
 		sFrame.pRSN->abyRSN[14] = 0xAC;
-		if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2PSK) {
+		if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2PSK)
 			sFrame.pRSN->abyRSN[15] = WLAN_11i_AKMSS_PSK;
-		} else if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2) {
+		else if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2)
 			sFrame.pRSN->abyRSN[15] = WLAN_11i_AKMSS_802_1X;
-		} else {
+		else
 			sFrame.pRSN->abyRSN[15] = WLAN_11i_AKMSS_UNKNOWN;
-		}
+
 		sFrame.pRSN->len += 6;
 
 		// RSN Capabilities
@@ -3587,9 +3558,8 @@ s_MgrMakeAssocRequest(
 					pbyRSN += 16;
 				}
 			}
-			if (*pwPMKID != 0) {
+			if (*pwPMKID != 0)
 				sFrame.pRSN->len += (2 + (*pwPMKID)*16);
-			}
 		}
 
 		sFrame.len += sFrame.pRSN->len + WLAN_IEHDR_LEN;
@@ -3704,27 +3674,27 @@ s_MgrMakeReAssocRequest(
 		sFrame.pRSNWPA->abyMulticast[0] = 0x00;
 		sFrame.pRSNWPA->abyMulticast[1] = 0x50;
 		sFrame.pRSNWPA->abyMulticast[2] = 0xf2;
-		if (pMgmt->byCSSGK == KEY_CTL_WEP) {
+		if (pMgmt->byCSSGK == KEY_CTL_WEP)
 			sFrame.pRSNWPA->abyMulticast[3] = pMgmt->pCurrBSS->byGKType;
-		} else if (pMgmt->byCSSGK == KEY_CTL_TKIP) {
+		else if (pMgmt->byCSSGK == KEY_CTL_TKIP)
 			sFrame.pRSNWPA->abyMulticast[3] = WPA_TKIP;
-		} else if (pMgmt->byCSSGK == KEY_CTL_CCMP) {
+		else if (pMgmt->byCSSGK == KEY_CTL_CCMP)
 			sFrame.pRSNWPA->abyMulticast[3] = WPA_AESCCMP;
-		} else {
+		else
 			sFrame.pRSNWPA->abyMulticast[3] = WPA_NONE;
-		}
+
 		// Pairwise Key Cipher Suite
 		sFrame.pRSNWPA->wPKCount = 1;
 		sFrame.pRSNWPA->PKSList[0].abyOUI[0] = 0x00;
 		sFrame.pRSNWPA->PKSList[0].abyOUI[1] = 0x50;
 		sFrame.pRSNWPA->PKSList[0].abyOUI[2] = 0xf2;
-		if (pMgmt->byCSSPK == KEY_CTL_TKIP) {
+		if (pMgmt->byCSSPK == KEY_CTL_TKIP)
 			sFrame.pRSNWPA->PKSList[0].abyOUI[3] = WPA_TKIP;
-		} else if (pMgmt->byCSSPK == KEY_CTL_CCMP) {
+		else if (pMgmt->byCSSPK == KEY_CTL_CCMP)
 			sFrame.pRSNWPA->PKSList[0].abyOUI[3] = WPA_AESCCMP;
-		} else {
+		else
 			sFrame.pRSNWPA->PKSList[0].abyOUI[3] = WPA_NONE;
-		}
+
 		// Auth Key Management Suite
 		pbyRSN = (unsigned char *)(sFrame.pBuf + sFrame.len + 2 + sFrame.pRSNWPA->len);
 		*pbyRSN++ = 0x01;
@@ -3733,13 +3703,12 @@ s_MgrMakeReAssocRequest(
 
 		*pbyRSN++ = 0x50;
 		*pbyRSN++ = 0xf2;
-		if (pMgmt->eAuthenMode == WMAC_AUTH_WPAPSK) {
+		if (pMgmt->eAuthenMode == WMAC_AUTH_WPAPSK)
 			*pbyRSN++ = WPA_AUTH_PSK;
-		} else if (pMgmt->eAuthenMode == WMAC_AUTH_WPA) {
+		else if (pMgmt->eAuthenMode == WMAC_AUTH_WPA)
 			*pbyRSN++ = WPA_AUTH_IEEE802_1X;
-		} else {
+		else
 			*pbyRSN++ = WPA_NONE;
-		}
 
 		sFrame.pRSNWPA->len += 6;
 
@@ -3769,15 +3738,14 @@ s_MgrMakeReAssocRequest(
 		sFrame.pRSN->abyRSN[0] = 0x00;
 		sFrame.pRSN->abyRSN[1] = 0x0F;
 		sFrame.pRSN->abyRSN[2] = 0xAC;
-		if (pMgmt->byCSSGK == KEY_CTL_WEP) {
+		if (pMgmt->byCSSGK == KEY_CTL_WEP)
 			sFrame.pRSN->abyRSN[3] = pMgmt->pCurrBSS->byCSSGK;
-		} else if (pMgmt->byCSSGK == KEY_CTL_TKIP) {
+		else if (pMgmt->byCSSGK == KEY_CTL_TKIP)
 			sFrame.pRSN->abyRSN[3] = WLAN_11i_CSS_TKIP;
-		} else if (pMgmt->byCSSGK == KEY_CTL_CCMP) {
+		else if (pMgmt->byCSSGK == KEY_CTL_CCMP)
 			sFrame.pRSN->abyRSN[3] = WLAN_11i_CSS_CCMP;
-		} else {
+		else
 			sFrame.pRSN->abyRSN[3] = WLAN_11i_CSS_UNKNOWN;
-		}
 
 		// Pairwise Key Cipher Suite
 		sFrame.pRSN->abyRSN[4] = 1;
@@ -3785,15 +3753,15 @@ s_MgrMakeReAssocRequest(
 		sFrame.pRSN->abyRSN[6] = 0x00;
 		sFrame.pRSN->abyRSN[7] = 0x0F;
 		sFrame.pRSN->abyRSN[8] = 0xAC;
-		if (pMgmt->byCSSPK == KEY_CTL_TKIP) {
+		if (pMgmt->byCSSPK == KEY_CTL_TKIP)
 			sFrame.pRSN->abyRSN[9] = WLAN_11i_CSS_TKIP;
-		} else if (pMgmt->byCSSPK == KEY_CTL_CCMP) {
+		else if (pMgmt->byCSSPK == KEY_CTL_CCMP)
 			sFrame.pRSN->abyRSN[9] = WLAN_11i_CSS_CCMP;
-		} else if (pMgmt->byCSSPK == KEY_CTL_NONE) {
+		else if (pMgmt->byCSSPK == KEY_CTL_NONE)
 			sFrame.pRSN->abyRSN[9] = WLAN_11i_CSS_USE_GROUP;
-		} else {
+		else
 			sFrame.pRSN->abyRSN[9] = WLAN_11i_CSS_UNKNOWN;
-		}
+
 		sFrame.pRSN->len += 6;
 
 		// Auth Key Management Suite
@@ -3802,13 +3770,13 @@ s_MgrMakeReAssocRequest(
 		sFrame.pRSN->abyRSN[12] = 0x00;
 		sFrame.pRSN->abyRSN[13] = 0x0F;
 		sFrame.pRSN->abyRSN[14] = 0xAC;
-		if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2PSK) {
+		if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2PSK)
 			sFrame.pRSN->abyRSN[15] = WLAN_11i_AKMSS_PSK;
-		} else if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2) {
+		else if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2)
 			sFrame.pRSN->abyRSN[15] = WLAN_11i_AKMSS_802_1X;
-		} else {
+		else
 			sFrame.pRSN->abyRSN[15] = WLAN_11i_AKMSS_UNKNOWN;
-		}
+
 		sFrame.pRSN->len += 6;
 
 		// RSN Capabilities
@@ -3833,9 +3801,9 @@ s_MgrMakeReAssocRequest(
 					pbyRSN += 16;
 				}
 			}
-			if (*pwPMKID != 0) {
+
+			if (*pwPMKID != 0)
 				sFrame.pRSN->len += (2 + (*pwPMKID) * 16);
-			}
 		}
 
 		sFrame.len += sFrame.pRSN->len + WLAN_IEHDR_LEN;
@@ -4158,9 +4126,8 @@ s_vMgrRxProbeRequest(
 			}
 		}
 
-		if ((sFrame.pSuppRates->len > 4) || (sFrame.pExtSuppRates != NULL)) {
+		if ((sFrame.pSuppRates->len > 4) || (sFrame.pExtSuppRates != NULL))
 			byPHYType = BB_TYPE_11G;
-		}
 
 		// Probe response reply..
 		pTxPacket = s_MgrMakeProbeResponse
@@ -4287,9 +4254,9 @@ vMgrRxManagePacket(
 
 	case WLAN_FSTYPE_BEACON:
 		// Frame Clase = 0
-		if (pMgmt->eScanState != WMAC_NO_SCANNING) {
+		if (pMgmt->eScanState != WMAC_NO_SCANNING)
 			bInScan = true;
-		}
+
 		s_vMgrRxBeacon(pDevice, pMgmt, pRxPacket, bInScan);
 		break;
 
@@ -4354,11 +4321,11 @@ bMgrPrepareBeaconToSend(
 	PSDevice            pDevice = (PSDevice)hDeviceContext;
 	PSTxMgmtPacket      pTxPacket;
 
-	if (pDevice->bEncryptionEnable || pDevice->bEnable8021x) {
+	if (pDevice->bEncryptionEnable || pDevice->bEnable8021x)
 		pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_PRIVACY(1);
-	} else {
+	else
 		pMgmt->wCurrCapInfo &= ~WLAN_SET_CAP_INFO_PRIVACY(1);
-	}
+
 	pTxPacket = s_MgrMakeBeacon
 		(
 			pDevice,
@@ -4486,22 +4453,22 @@ bAdd_PMKID_Candidate(
 	for (ii = 0; ii < pDevice->gsPMKIDCandidate.NumCandidates; ii++) {
 		pCandidateList = &pDevice->gsPMKIDCandidate.CandidateList[ii];
 		if (!memcmp(pCandidateList->BSSID, pbyBSSID, ETH_ALEN)) {
-			if (psRSNCapObj->bRSNCapExist && (psRSNCapObj->wRSNCap & BIT0)) {
+			if (psRSNCapObj->bRSNCapExist && (psRSNCapObj->wRSNCap & BIT0))
 				pCandidateList->Flags |= NDIS_802_11_PMKID_CANDIDATE_PREAUTH_ENABLED;
-			} else {
+			else
 				pCandidateList->Flags &= ~(NDIS_802_11_PMKID_CANDIDATE_PREAUTH_ENABLED);
-			}
+
 			return true;
 		}
 	}
 
 	// New Candidate
 	pCandidateList = &pDevice->gsPMKIDCandidate.CandidateList[pDevice->gsPMKIDCandidate.NumCandidates];
-	if (psRSNCapObj->bRSNCapExist && (psRSNCapObj->wRSNCap & BIT0)) {
+	if (psRSNCapObj->bRSNCapExist && (psRSNCapObj->wRSNCap & BIT0))
 		pCandidateList->Flags |= NDIS_802_11_PMKID_CANDIDATE_PREAUTH_ENABLED;
-	} else {
+	else
 		pCandidateList->Flags &= ~(NDIS_802_11_PMKID_CANDIDATE_PREAUTH_ENABLED);
-	}
+
 	memcpy(pCandidateList->BSSID, pbyBSSID, ETH_ALEN);
 	pDevice->gsPMKIDCandidate.NumCandidates++;
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "NumCandidates:%d\n", (int)pDevice->gsPMKIDCandidate.NumCandidates);
diff --git a/drivers/staging/vt6655/wpa2.c b/drivers/staging/vt6655/wpa2.c
index f5be587..4e1b63b 100644
--- a/drivers/staging/vt6655/wpa2.c
+++ b/drivers/staging/vt6655/wpa2.c
@@ -121,9 +121,9 @@ WPA2vParseRSN(
 	WPA2_ClearRSN(pBSSNode);
 
 	if (pRSN->len == 2) { // ver(2)
-		if ((pRSN->byElementID == WLAN_EID_RSN) && (pRSN->wVersion == 1)) {
+		if ((pRSN->byElementID == WLAN_EID_RSN) && (pRSN->wVersion == 1))
 			pBSSNode->bWPA2Valid = true;
-		}
+
 		return;
 	}
 
@@ -267,9 +267,9 @@ WPA2uSetIEs(
 	unsigned int ii = 0;
 	unsigned short *pwPMKID = NULL;
 
-	if (pRSNIEs == NULL) {
+	if (pRSNIEs == NULL)
 		return 0;
-	}
+
 	if (((pMgmt->eAuthenMode == WMAC_AUTH_WPA2) ||
 	     (pMgmt->eAuthenMode == WMAC_AUTH_WPA2PSK)) &&
 	    (pMgmt->pCurrBSS != NULL)) {
@@ -282,15 +282,14 @@ WPA2uSetIEs(
 		pRSNIEs->abyRSN[0] = 0x00;
 		pRSNIEs->abyRSN[1] = 0x0F;
 		pRSNIEs->abyRSN[2] = 0xAC;
-		if (pMgmt->byCSSGK == KEY_CTL_WEP) {
+		if (pMgmt->byCSSGK == KEY_CTL_WEP)
 			pRSNIEs->abyRSN[3] = pMgmt->pCurrBSS->byCSSGK;
-		} else if (pMgmt->byCSSGK == KEY_CTL_TKIP) {
+		else if (pMgmt->byCSSGK == KEY_CTL_TKIP)
 			pRSNIEs->abyRSN[3] = WLAN_11i_CSS_TKIP;
-		} else if (pMgmt->byCSSGK == KEY_CTL_CCMP) {
+		else if (pMgmt->byCSSGK == KEY_CTL_CCMP)
 			pRSNIEs->abyRSN[3] = WLAN_11i_CSS_CCMP;
-		} else {
+		else
 			pRSNIEs->abyRSN[3] = WLAN_11i_CSS_UNKNOWN;
-		}
 
 		// Pairwise Key Cipher Suite
 		pRSNIEs->abyRSN[4] = 1;
@@ -298,15 +297,15 @@ WPA2uSetIEs(
 		pRSNIEs->abyRSN[6] = 0x00;
 		pRSNIEs->abyRSN[7] = 0x0F;
 		pRSNIEs->abyRSN[8] = 0xAC;
-		if (pMgmt->byCSSPK == KEY_CTL_TKIP) {
+		if (pMgmt->byCSSPK == KEY_CTL_TKIP)
 			pRSNIEs->abyRSN[9] = WLAN_11i_CSS_TKIP;
-		} else if (pMgmt->byCSSPK == KEY_CTL_CCMP) {
+		else if (pMgmt->byCSSPK == KEY_CTL_CCMP)
 			pRSNIEs->abyRSN[9] = WLAN_11i_CSS_CCMP;
-		} else if (pMgmt->byCSSPK == KEY_CTL_NONE) {
+		else if (pMgmt->byCSSPK == KEY_CTL_NONE)
 			pRSNIEs->abyRSN[9] = WLAN_11i_CSS_USE_GROUP;
-		} else {
+		else
 			pRSNIEs->abyRSN[9] = WLAN_11i_CSS_UNKNOWN;
-		}
+
 		pRSNIEs->len += 6;
 
 		// Auth Key Management Suite
@@ -315,13 +314,13 @@ WPA2uSetIEs(
 		pRSNIEs->abyRSN[12] = 0x00;
 		pRSNIEs->abyRSN[13] = 0x0F;
 		pRSNIEs->abyRSN[14] = 0xAC;
-		if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2PSK) {
+		if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2PSK)
 			pRSNIEs->abyRSN[15] = WLAN_11i_AKMSS_PSK;
-		} else if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2) {
+		else if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2)
 			pRSNIEs->abyRSN[15] = WLAN_11i_AKMSS_802_1X;
-		} else {
+		else
 			pRSNIEs->abyRSN[15] = WLAN_11i_AKMSS_UNKNOWN;
-		}
+
 		pRSNIEs->len += 6;
 
 		// RSN Capabilities
@@ -347,11 +346,10 @@ WPA2uSetIEs(
 					pbyBuffer += 16;
 				}
 			}
-			if (*pwPMKID != 0) {
+			if (*pwPMKID != 0)
 				pRSNIEs->len += (2 + (*pwPMKID)*16);
-			} else {
+			else
 				pbyBuffer = &pRSNIEs->abyRSN[18];
-			}
 		}
 		return pRSNIEs->len + WLAN_IEHDR_LEN;
 	}
diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
index 0bbb8b1..02811ff 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -211,9 +211,9 @@ int wpa_set_keys(PSDevice pDevice, void *ctx, bool fcpfkernel)
 		pDevice->byKeyIndex = 0;
 		pDevice->bTransmitKey = false;
 		KeyvRemoveAllWEPKey(&(pDevice->sKey), pDevice->PortOffset);
-		for (uu = 0; uu < MAX_KEY_TABLE; uu++) {
+		for (uu = 0; uu < MAX_KEY_TABLE; uu++)
 			MACvDisableKeyEntry(pDevice->PortOffset, uu);
-		}
+
 		return ret;
 	}
 
@@ -282,13 +282,11 @@ int wpa_set_keys(PSDevice pDevice, void *ctx, bool fcpfkernel)
 		return -EINVAL;
 	}
 
-	if (param->u.wpa_key.alg_name == WPA_ALG_TKIP) {
+	if (param->u.wpa_key.alg_name == WPA_ALG_TKIP)
 		pDevice->eEncryptionStatus = Ndis802_11Encryption2Enabled;
-	}
 
-	if (param->u.wpa_key.alg_name == WPA_ALG_CCMP) {
+	if (param->u.wpa_key.alg_name == WPA_ALG_CCMP)
 		pDevice->eEncryptionStatus = Ndis802_11Encryption3Enabled;
-	}
 
 	if (param->u.wpa_key.set_tx)
 		dwKeyIndex |= (1 << 31);
@@ -638,9 +636,9 @@ static int wpa_get_scan(PSDevice pDevice,
 	if (jj < count)
 		count = jj;
 
-	if (copy_to_user(param->u.scan_results.buf, pBuf, sizeof(struct viawget_scan_result) * count)) {
+	if (copy_to_user(param->u.scan_results.buf, pBuf, sizeof(struct viawget_scan_result) * count))
 		ret = -EFAULT;
-	}
+
 	param->u.scan_results.scan_count = count;
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " param->u.scan_results.scan_count = %d\n", count);
 
@@ -702,9 +700,8 @@ static int wpa_set_associate(PSDevice pDevice,
 	// set bssid
 	if (memcmp(param->u.wpa_associate.bssid, &abyNullAddr[0], 6) != 0)
 		memcpy(pMgmt->abyDesireBSSID, param->u.wpa_associate.bssid, 6);
-	else {
+	else
 		bScheduleCommand((void *)pDevice, WLAN_CMD_BSSID_SCAN, pItemSSID->abySSID);
-	}
 
 	if (param->u.wpa_associate.wpa_ie_len == 0) {
 		if (param->u.wpa_associate.auth_alg & AUTH_ALG_SHARED_KEY)
-- 
1.9.0

