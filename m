Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaDAMyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:54:44 -0400
Received: from mail-yk0-f176.google.com ([209.85.160.176]:55486 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaDAMyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 08:54:33 -0400
From: =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>
To: linux-kernel@vger.kernel.org
Cc: driverdev-devel@linuxdriverproject.org,
        =?UTF-8?q?Ezequiel=20Garc=C3=ADa?= <ezequiel@vanguardiasur.com.ar>,
        Walter Lozano <walter@vanguardiasur.com.ar>,
        Forest Bond <forest@alittletooquiet.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>
Subject: [PATCH 2/3] staging: vt6655: remove dead code
Date: Tue,  1 Apr 2014 09:52:12 -0300
Message-Id: <1396356733-5344-3-git-send-email-guido@vanguardiasur.com.ar>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396356733-5344-1-git-send-email-guido@vanguardiasur.com.ar>
References: <1396356733-5344-1-git-send-email-guido@vanguardiasur.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove dead code (in comments) in many places on this driver.

Signed-off-by: Guido Martínez <guido@vanguardiasur.com.ar>
---
 drivers/staging/vt6655/IEEE11h.c     |   6 -
 drivers/staging/vt6655/baseband.c    |  20 +--
 drivers/staging/vt6655/bssdb.h       |   2 -
 drivers/staging/vt6655/card.c        |  55 +-------
 drivers/staging/vt6655/card.h        |   1 -
 drivers/staging/vt6655/channel.c     |   3 -
 drivers/staging/vt6655/datarate.c    |   7 +-
 drivers/staging/vt6655/desc.h        |  47 -------
 drivers/staging/vt6655/device.h      |   6 -
 drivers/staging/vt6655/device_main.c | 223 ++++++-----------------------
 drivers/staging/vt6655/dpc.c         |  80 ++---------
 drivers/staging/vt6655/hostap.c      |  47 -------
 drivers/staging/vt6655/ioctl.c       |   1 -
 drivers/staging/vt6655/ioctl.h       |   9 --
 drivers/staging/vt6655/iowpa.h       |   7 -
 drivers/staging/vt6655/iwctl.c       | 264 ++---------------------------------
 drivers/staging/vt6655/key.c         |   6 -
 drivers/staging/vt6655/key.h         |   2 -
 drivers/staging/vt6655/mac.c         |   8 --
 drivers/staging/vt6655/mac.h         |   1 -
 drivers/staging/vt6655/mib.c         |   3 -
 drivers/staging/vt6655/mib.h         |   8 --
 drivers/staging/vt6655/michael.c     |  29 +---
 drivers/staging/vt6655/power.c       |  14 +-
 drivers/staging/vt6655/power.h       |   3 -
 drivers/staging/vt6655/rf.c          |  18 +--
 drivers/staging/vt6655/rxtx.c        |  72 +---------
 drivers/staging/vt6655/rxtx.h        |  11 --
 drivers/staging/vt6655/tkip.c        |   1 -
 drivers/staging/vt6655/vntwifi.c     |  50 +------
 drivers/staging/vt6655/vntwifi.h     |  14 --
 drivers/staging/vt6655/wcmd.c        |  29 +---
 drivers/staging/vt6655/wctl.c        |   6 +-
 drivers/staging/vt6655/wmgr.c        | 117 +++-------------
 drivers/staging/vt6655/wmgr.h        |  30 ----
 drivers/staging/vt6655/wpa.c         |   9 +-
 drivers/staging/vt6655/wpa2.c        |   4 +-
 drivers/staging/vt6655/wpactl.c      |  49 +------
 drivers/staging/vt6655/wroute.c      |   1 -
 39 files changed, 107 insertions(+), 1156 deletions(-)

diff --git a/drivers/staging/vt6655/IEEE11h.c b/drivers/staging/vt6655/IEEE11h.c
index dfda3c8..6cfad1c 100644
--- a/drivers/staging/vt6655/IEEE11h.c
+++ b/drivers/staging/vt6655/IEEE11h.c
@@ -192,8 +192,6 @@ static bool s_bRxTPCReq(PSMgmtObject pMgmt,
 	if (csMgmt_xmit(pMgmt->pAdapter, pTxPacket) != CMD_STATUS_PENDING)
 		return false;
 	return true;
-/*    return CARDbSendPacket(pMgmt->pAdapter, pFrame, PKT_TYPE_802_11_MNG,
-      sizeof(WLAN_FRAME_TPCREP)); */
 }
 
 /*---------------------  Export Variables  --------------------------*/
@@ -274,8 +272,6 @@ IEEE11hbMgrRxAction(void *pMgmtHandle, void *pRxPacket)
 			pAction->byCategory);
 		pAction->byCategory |= 0x80;
 
-		/*return CARDbSendPacket(pMgmt->pAdapter, pAction, PKT_TYPE_802_11_MNG,
-		  uLength);*/
 		return true;
 	}
 	return true;
@@ -317,6 +313,4 @@ bool IEEE11hbMSRRepTx(void *pMgmtHandle)
 	if (csMgmt_xmit(pMgmt->pAdapter, pTxPacket) != CMD_STATUS_PENDING)
 		return false;
 	return true;
-/*    return CARDbSendPacket(pMgmt->pAdapter, pMSRRep, PKT_TYPE_802_11_MNG,
-      uLength); */
 }
diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index fa14659..8c9852d 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -1095,7 +1095,6 @@ unsigned char byVT3253B0_AIROHA2230[CB_VT3253B0_INIT_FOR_AIROHA2230][2] = {
 	{0x69, 0x00},
 	{0x6a, 0x00},
 	{0x6b, 0x00},
-	//{0x6c, 0x80},
 	{0x6c, 0x00}, //RobertYu:20050125, request by JJSue
 	{0x6d, 0x03},
 	{0x6e, 0x01},
@@ -1357,7 +1356,6 @@ unsigned char byVT3253B0_UW2451[CB_VT3253B0_INIT_FOR_UW2451][2] = {
 	{0x69, 0x00},
 	{0x6a, 0x00},
 	{0x6b, 0x00},
-	//{0x6c, 0x80},
 	{0x6c, 0x00}, //RobertYu:20050125, request by JJSue
 	{0x6d, 0x03},
 	{0x6e, 0x01},
@@ -2205,11 +2203,8 @@ bool BBbVT3253Init(PSDevice pDevice)
 		//}}
 		bResult &= BBbWriteEmbedded(dwIoBase, 0xb0, 0x58);
 
-		for (ii = 0; ii < CB_VT3253B0_AGC; ii++) {
+		for (ii = 0; ii < CB_VT3253B0_AGC; ii++)
 			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AGC[ii][0], byVT3253B0_AGC[ii][1]);
-		}
-		//VNSvOutPortB(dwIoBase + MAC_REG_ITRTMSET, 0x23); // RobertYu: 20050104, 20050131 disable PA_Delay
-		//MACvRegBitsOn(dwIoBase, MAC_REG_PAPEDELAY, BIT0); // RobertYu: 20050104, 20050131 disable PA_Delay
 
 		pDevice->abyBBVGA[0] = 0x14;
 		pDevice->abyBBVGA[1] = 0x0A;
@@ -2613,13 +2608,11 @@ s_ulGetRatio(PSDevice pDevice)
 	if (pDevice->uNumSQ3[RATE_54M] != 0) {
 		ulPacketNum = pDevice->uNumSQ3[RATE_54M];
 		ulRatio = (ulPacketNum * 1000 / pDevice->uDiversityCnt);
-		//ulRatio = (pDevice->uNumSQ3[RATE_54M] * 1000 / pDevice->uDiversityCnt);
 		ulRatio += TOP_RATE_54M;
 	}
 	if (pDevice->uNumSQ3[RATE_48M] > ulMaxPacket) {
 		ulPacketNum = pDevice->uNumSQ3[RATE_54M] + pDevice->uNumSQ3[RATE_48M];
 		ulRatio = (ulPacketNum * 1000 / pDevice->uDiversityCnt);
-		//ulRatio = (pDevice->uNumSQ3[RATE_48M] * 1000 / pDevice->uDiversityCnt);
 		ulRatio += TOP_RATE_48M;
 		ulMaxPacket = pDevice->uNumSQ3[RATE_48M];
 	}
@@ -2627,7 +2620,6 @@ s_ulGetRatio(PSDevice pDevice)
 		ulPacketNum = pDevice->uNumSQ3[RATE_54M] + pDevice->uNumSQ3[RATE_48M] +
 			pDevice->uNumSQ3[RATE_36M];
 		ulRatio = (ulPacketNum * 1000 / pDevice->uDiversityCnt);
-		//ulRatio = (pDevice->uNumSQ3[RATE_36M] * 1000 / pDevice->uDiversityCnt);
 		ulRatio += TOP_RATE_36M;
 		ulMaxPacket = pDevice->uNumSQ3[RATE_36M];
 	}
@@ -2635,7 +2627,6 @@ s_ulGetRatio(PSDevice pDevice)
 		ulPacketNum = pDevice->uNumSQ3[RATE_54M] + pDevice->uNumSQ3[RATE_48M] +
 			pDevice->uNumSQ3[RATE_36M] + pDevice->uNumSQ3[RATE_24M];
 		ulRatio = (ulPacketNum * 1000 / pDevice->uDiversityCnt);
-		//ulRatio = (pDevice->uNumSQ3[RATE_24M] * 1000 / pDevice->uDiversityCnt);
 		ulRatio += TOP_RATE_24M;
 		ulMaxPacket = pDevice->uNumSQ3[RATE_24M];
 	}
@@ -2644,7 +2635,6 @@ s_ulGetRatio(PSDevice pDevice)
 			pDevice->uNumSQ3[RATE_36M] + pDevice->uNumSQ3[RATE_24M] +
 			pDevice->uNumSQ3[RATE_18M];
 		ulRatio = (ulPacketNum * 1000 / pDevice->uDiversityCnt);
-		//ulRatio = (pDevice->uNumSQ3[RATE_18M] * 1000 / pDevice->uDiversityCnt);
 		ulRatio += TOP_RATE_18M;
 		ulMaxPacket = pDevice->uNumSQ3[RATE_18M];
 	}
@@ -2653,7 +2643,6 @@ s_ulGetRatio(PSDevice pDevice)
 			pDevice->uNumSQ3[RATE_36M] + pDevice->uNumSQ3[RATE_24M] +
 			pDevice->uNumSQ3[RATE_18M] + pDevice->uNumSQ3[RATE_12M];
 		ulRatio = (ulPacketNum * 1000 / pDevice->uDiversityCnt);
-		//ulRatio = (pDevice->uNumSQ3[RATE_12M] * 1000 / pDevice->uDiversityCnt);
 		ulRatio += TOP_RATE_12M;
 		ulMaxPacket = pDevice->uNumSQ3[RATE_12M];
 	}
@@ -2662,7 +2651,6 @@ s_ulGetRatio(PSDevice pDevice)
 			pDevice->uNumSQ3[RATE_2M] - pDevice->uNumSQ3[RATE_5M] -
 			pDevice->uNumSQ3[RATE_6M] - pDevice->uNumSQ3[RATE_9M];
 		ulRatio = (ulPacketNum * 1000 / pDevice->uDiversityCnt);
-		//ulRatio = (pDevice->uNumSQ3[RATE_11M] * 1000 / pDevice->uDiversityCnt);
 		ulRatio += TOP_RATE_11M;
 		ulMaxPacket = pDevice->uNumSQ3[RATE_11M];
 	}
@@ -2671,7 +2659,6 @@ s_ulGetRatio(PSDevice pDevice)
 			pDevice->uNumSQ3[RATE_2M] - pDevice->uNumSQ3[RATE_5M] -
 			pDevice->uNumSQ3[RATE_6M];
 		ulRatio = (ulPacketNum * 1000 / pDevice->uDiversityCnt);
-		//ulRatio = (pDevice->uNumSQ3[RATE_9M] * 1000 / pDevice->uDiversityCnt);
 		ulRatio += TOP_RATE_9M;
 		ulMaxPacket = pDevice->uNumSQ3[RATE_9M];
 	}
@@ -2679,7 +2666,6 @@ s_ulGetRatio(PSDevice pDevice)
 		ulPacketNum = pDevice->uDiversityCnt - pDevice->uNumSQ3[RATE_1M] -
 			pDevice->uNumSQ3[RATE_2M] - pDevice->uNumSQ3[RATE_5M];
 		ulRatio = (ulPacketNum * 1000 / pDevice->uDiversityCnt);
-		//ulRatio = (pDevice->uNumSQ3[RATE_6M] * 1000 / pDevice->uDiversityCnt);
 		ulRatio += TOP_RATE_6M;
 		ulMaxPacket = pDevice->uNumSQ3[RATE_6M];
 	}
@@ -2687,21 +2673,18 @@ s_ulGetRatio(PSDevice pDevice)
 		ulPacketNum = pDevice->uDiversityCnt - pDevice->uNumSQ3[RATE_1M] -
 			pDevice->uNumSQ3[RATE_2M];
 		ulRatio = (ulPacketNum * 1000 / pDevice->uDiversityCnt);
-		//ulRatio = (pDevice->uNumSQ3[RATE_5M] * 1000 / pDevice->uDiversityCnt);
 		ulRatio += TOP_RATE_55M;
 		ulMaxPacket = pDevice->uNumSQ3[RATE_5M];
 	}
 	if (pDevice->uNumSQ3[RATE_2M] > ulMaxPacket) {
 		ulPacketNum = pDevice->uDiversityCnt - pDevice->uNumSQ3[RATE_1M];
 		ulRatio = (ulPacketNum * 1000 / pDevice->uDiversityCnt);
-		//ulRatio = (pDevice->uNumSQ3[RATE_2M]  * 1000 / pDevice->uDiversityCnt);
 		ulRatio += TOP_RATE_2M;
 		ulMaxPacket = pDevice->uNumSQ3[RATE_2M];
 	}
 	if (pDevice->uNumSQ3[RATE_1M] > ulMaxPacket) {
 		ulPacketNum = pDevice->uDiversityCnt;
 		ulRatio = (ulPacketNum * 1000 / pDevice->uDiversityCnt);
-		//ulRatio = (pDevice->uNumSQ3[RATE_1M]  * 1000 / pDevice->uDiversityCnt);
 		ulRatio += TOP_RATE_1M;
 	}
 
@@ -2741,7 +2724,6 @@ BBvAntennaDiversity(PSDevice pDevice, unsigned char byRxRate, unsigned char bySQ
 		return;
 	}
 	pDevice->uDiversityCnt++;
-	// DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pDevice->uDiversityCnt = %d\n", (int)pDevice->uDiversityCnt);
 
 	pDevice->uNumSQ3[byRxRate]++;
 
diff --git a/drivers/staging/vt6655/bssdb.h b/drivers/staging/vt6655/bssdb.h
index 5c77677..a0938b7 100644
--- a/drivers/staging/vt6655/bssdb.h
+++ b/drivers/staging/vt6655/bssdb.h
@@ -112,7 +112,6 @@ typedef struct tagKnownBSS {
 	unsigned char abySSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
 	unsigned char byRxRate;
 
-//    unsigned short wATIMWindow;
 	unsigned char byRSSIStatCnt;
 	long            ldBmMAX;
 	long            ldBmAverage[RSSI_STAT_COUNT];
@@ -147,7 +146,6 @@ typedef struct tagKnownBSS {
 
 	// Clear count
 	unsigned int	uClearCount;
-//    unsigned char abyIEs[WLAN_BEACON_FR_MAXLEN];
 	unsigned int	uIELength;
 	QWORD           qwBSSTimestamp;
 	QWORD           qwLocalTSF;     // local TSF timer
diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index db38ca0..e842634 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -60,7 +60,6 @@
 
 /*---------------------  Static Definitions -------------------------*/
 
-//static int          msglevel                =MSG_LEVEL_DEBUG;
 static int msglevel = MSG_LEVEL_INFO;
 
 #define C_SIFS_A        16      // micro sec.
@@ -339,36 +338,6 @@ s_vSetRSPINF(PSDevice pDevice, CARD_PHY_TYPE ePHYType, void *pvSupportRateIEs, v
 /*---------------------  Export Functions  --------------------------*/
 
 /*
- * Description: Card Send packet function
- *
- * Parameters:
- *  In:
- *      pDeviceHandler      - The adapter to be set
- *      pPacket             - Packet buffer pointer
- *      ePktType            - Packet type
- *      uLength             - Packet length
- *  Out:
- *      none
- *
- * Return Value: true if succeeded; false if failed.
- *
- */
-/*
-  bool CARDbSendPacket (void *pDeviceHandler, void *pPacket, CARD_PKT_TYPE ePktType, unsigned int uLength) {
-  PSDevice    pDevice = (PSDevice) pDeviceHandler;
-  if (ePktType == PKT_TYPE_802_11_MNG) {
-  return TXbTD0Send(pDevice, pPacket, uLength);
-  } else if (ePktType == PKT_TYPE_802_11_BCN) {
-  return TXbBeaconSend(pDevice, pPacket, uLength);
-  } if (ePktType == PKT_TYPE_802_11_DATA) {
-  return TXbTD1Send(pDevice, pPacket, uLength);
-  }
-
-  return true;
-  }
-*/
-
-/*
  * Description: Get Card short preamble option value
  *
  * Parameters:
@@ -427,7 +396,6 @@ bool CARDbSetPhyParameter(void *pDeviceHandler, CARD_PHY_TYPE ePHYType, unsigned
 	unsigned char bySIFS = 0;
 	unsigned char byDIFS = 0;
 	unsigned char byData;
-//    PWLAN_IE_SUPP_RATES pRates = NULL;
 	PWLAN_IE_SUPP_RATES pSupportRates = (PWLAN_IE_SUPP_RATES) pvSupportRateIEs;
 	PWLAN_IE_SUPP_RATES pExtSupportRates = (PWLAN_IE_SUPP_RATES) pvExtSupportRateIEs;
 
@@ -1299,12 +1267,10 @@ CARDbSetQuiet(
 		pDevice->sQuiet[pDevice->uQuietEnqueue].dwStartTime += wQuietOffset;
 		pDevice->uQuietEnqueue++;
 		pDevice->uQuietEnqueue %= MAX_QUIET_COUNT;
-		if (pDevice->byQuietStartCount < byQuietCount) {
+		if (pDevice->byQuietStartCount < byQuietCount)
 			pDevice->byQuietStartCount = byQuietCount;
-		}
-	} else {
-		// we can not handle Quiet EID more
 	}
+
 	return true;
 }
 
@@ -1877,19 +1843,6 @@ void CARDvUpdateBasicTopRate(void *pDeviceHandler)
 	pDevice->byTopCCKBasicRate = byTopCCK;
 }
 
-/*
- * Description: Set NIC Tx Basic Rate
- *
- * Parameters:
- *  In:
- *      pDevice         - The adapter to be set
- *      wBasicRate      - Basic Rate to be set
- *  Out:
- *      none
- *
- * Return Value: true if succeeded; false if failed.
- *
- */
 bool CARDbAddBasicRate(void *pDeviceHandler, unsigned short wRateIdx)
 {
 	PSDevice pDevice = (PSDevice) pDeviceHandler;
@@ -2074,8 +2027,6 @@ QWORD CARDqGetNextTBTT(QWORD qwTSF, unsigned short wBeaconInterval)
 	uLowNextTBTT = (LODWORD(qwTSF) >> 10) << 10;
 	// low dword (mod) bcn
 	uLowRemain = (uLowNextTBTT) % uBeaconInterval;
-//    uHighRemain = ((0x80000000 % uBeaconInterval)* 2 * HIDWORD(qwTSF))
-//                  % uBeaconInterval;
 	// high dword (mod) bcn
 	uHighRemain = (((0xffffffff % uBeaconInterval) + 1) * HIDWORD(qwTSF))
 		% uBeaconInterval;
@@ -2117,7 +2068,7 @@ void CARDvSetFirstNextTBTT(unsigned long dwIoBase, unsigned short wBeaconInterva
 	VNSvOutPortD(dwIoBase + MAC_REG_NEXTTBTT, LODWORD(qwNextTBTT));
 	VNSvOutPortD(dwIoBase + MAC_REG_NEXTTBTT + 4, HIDWORD(qwNextTBTT));
 	MACvRegBitsOn(dwIoBase, MAC_REG_TFTCTL, TFTCTL_TBTTSYNCEN);
-	//DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Card:First Next TBTT[%8xh:%8xh] \n", HIDWORD(qwNextTBTT), LODWORD(qwNextTBTT));
+
 	return;
 }
 
diff --git a/drivers/staging/vt6655/card.h b/drivers/staging/vt6655/card.h
index ac6e2b4..829be92 100644
--- a/drivers/staging/vt6655/card.h
+++ b/drivers/staging/vt6655/card.h
@@ -104,7 +104,6 @@ void CARDvSafeResetRx(void *pDeviceHandler);
 //xxx
 bool CARDbRadioPowerOff(void *pDeviceHandler);
 bool CARDbRadioPowerOn(void *pDeviceHandler);
-//bool CARDbSendPacket(void *pDeviceHandler, void *pPacket, CARD_PKT_TYPE ePktType, unsigned int uLength);
 bool CARDbIsShortPreamble(void *pDeviceHandler);
 bool CARDbIsShorSlotTime(void *pDeviceHandler);
 bool CARDbSetPhyParameter(void *pDeviceHandler, CARD_PHY_TYPE ePHYType, unsigned short wCapInfo, unsigned char byERPField, void *pvSupportRateIEs, void *pvExtSupportRateIEs);
diff --git a/drivers/staging/vt6655/channel.c b/drivers/staging/vt6655/channel.c
index 3198a31..e69c312 100644
--- a/drivers/staging/vt6655/channel.c
+++ b/drivers/staging/vt6655/channel.c
@@ -30,7 +30,6 @@
 
 #define CARD_MAX_CHANNEL_TBL    56
 
-//static int msglevel = MSG_LEVEL_DEBUG;
 static int msglevel = MSG_LEVEL_INFO;
 
 /*---------------------  Static Variables  --------------------------*/
@@ -509,7 +508,6 @@ unsigned char get_channel_mapping(void *pDeviceHandler, unsigned char byChannelN
 
 unsigned char get_channel_number(void *pDeviceHandler, unsigned char byChannelIndex)
 {
-	//PSDevice    pDevice = (PSDevice) pDeviceHandler;
 	return sChannelTbl[byChannelIndex].byChannelNumber;
 }
 
@@ -560,7 +558,6 @@ bool set_channel(void *pDeviceHandler, unsigned int uConnectionChannel)
 	if (pDevice->bEnablePSMode)
 		RFvWriteWakeProgSyn(pDevice->PortOffset, pDevice->byRFType, uConnectionChannel);
 
-	//DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "CARDbSetMediaChannel: %d\n", (unsigned char)uConnectionChannel);
 	BBvSoftwareReset(pDevice->PortOffset);
 
 	if (pDevice->byLocalID > REV_ID_VT3253_B1) {
diff --git a/drivers/staging/vt6655/datarate.c b/drivers/staging/vt6655/datarate.c
index c9a89cd..2d77cc2 100644
--- a/drivers/staging/vt6655/datarate.c
+++ b/drivers/staging/vt6655/datarate.c
@@ -49,7 +49,6 @@
 
 extern unsigned short TxRate_iwconfig; //2008-5-8 <add> by chester
 /*---------------------  Static Variables  --------------------------*/
-//static int          msglevel                =MSG_LEVEL_DEBUG;
 static int msglevel = MSG_LEVEL_INFO;
 const unsigned char acbyIERate[MAX_RATE] =
 {0x02, 0x04, 0x0B, 0x16, 0x0C, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C};
@@ -253,7 +252,7 @@ RATEvParseMaxRate(
 			*pwSuppRate |= (1<<wGetRateIdx(byRate));
 			//DBG_PRN_GRP09(("ParseMaxRate : HighSuppRate: %d, %X\n", wGetRateIdx(byRate), byRate));
 		}
-	} //if (pItemExtRates != NULL)
+	}
 
 	if ((pDevice->byPacketType == PK_TYPE_11GB) && CARDbIsOFDMinBasicRate((void *)pDevice)) {
 		pDevice->byPacketType = PK_TYPE_11GA;
@@ -299,7 +298,6 @@ RATEvTxRateFallBack(
 	PSDevice        pDevice = (PSDevice) pDeviceHandler;
 	unsigned short wIdxDownRate = 0;
 	unsigned int ii;
-//unsigned long dwRateTable[MAX_RATE]  = {1,   2,   5,   11,  6,    9,    12,   18,  24,  36,  48,  54};
 	bool bAutoRate[MAX_RATE]    = {true, true, true, true, false, false, true, true, true, true, true, true};
 	unsigned long dwThroughputTbl[MAX_RATE] = {10, 20, 55, 110, 60, 90, 120, 180, 240, 360, 480, 540};
 	unsigned long dwThroughput = 0;
@@ -345,8 +343,6 @@ RATEvTxRateFallBack(
 			}
 			dwThroughputTbl[ii] /= (psNodeDBTable->uTxOk[ii] + psNodeDBTable->uTxFail[ii]);
 		}
-//        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Rate %d,Ok: %d, Fail:%d, Throughput:%d\n",
-//                       ii, psNodeDBTable->uTxOk[ii], psNodeDBTable->uTxFail[ii], dwThroughputTbl[ii]);
 	}
 	dwThroughput = dwThroughputTbl[psNodeDBTable->wTxDataRate];
 
@@ -371,7 +367,6 @@ RATEvTxRateFallBack(
 //2008-5-8 <add> by chester
 	TxRate_iwconfig = psNodeDBTable->wTxDataRate;
 	s_vResetCounter(psNodeDBTable);
-//    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Rate: %d, U:%d, D:%d\n", psNodeDBTable->wTxDataRate, wIdxUpRate, wIdxDownRate);
 
 	return;
 }
diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index f8e4148..c620cbfb 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -213,29 +213,6 @@ typedef struct tagDEVICE_RD_INFO {
 	dma_addr_t  curr_desc;
 } DEVICE_RD_INFO,   *PDEVICE_RD_INFO;
 
-/*
-  static inline PDEVICE_RD_INFO alloc_rd_info(void) {
-  PDEVICE_RD_INFO  ptr;
-  ptr = kmalloc(sizeof(DEVICE_RD_INFO), GFP_ATOMIC);
-  if (ptr == NULL)
-  return NULL;
-  else {
-  memset(ptr,0,sizeof(DEVICE_RD_INFO));
-  return ptr;
-  }
-  }
-*/
-
-/*
-  typedef struct tagRDES0 {
-  unsigned short wResCount;
-  unsigned short wf1Owner;
-//    unsigned short f15Reserved : 15;
-//    unsigned short f1Owner : 1;
-} __attribute__ ((__packed__))
-SRDES0;
-*/
-
 #ifdef __BIG_ENDIAN
 
 typedef struct tagRDES0 {
@@ -284,17 +261,6 @@ typedef const SRxDesc *PCSRxDesc;
 
 #ifdef __BIG_ENDIAN
 
-/*
-  typedef struct tagTDES0 {
-  volatile    unsigned char byTSR0;
-  volatile    unsigned char byTSR1;
-  volatile    unsigned short wOwner_Txtime;
-//    volatile    unsigned short f15Txtime : 15;
-//    volatile    unsigned short f1Owner:1;
-} __attribute__ ((__packed__))
-STDES0;
-*/
-
 typedef struct tagTDES0 {
 	volatile    unsigned char byTSR0;
 	volatile    unsigned char byTSR1;
@@ -339,19 +305,6 @@ typedef struct tagDEVICE_TD_INFO {
 	unsigned char byFlags;
 } DEVICE_TD_INFO,    *PDEVICE_TD_INFO;
 
-/*
-  static inline PDEVICE_TD_INFO alloc_td_info(void) {
-  PDEVICE_TD_INFO  ptr;
-  ptr = kmalloc(sizeof(DEVICE_TD_INFO),GFP_ATOMIC);
-  if (ptr == NULL)
-  return NULL;
-  else {
-  memset(ptr,0,sizeof(DEVICE_TD_INFO));
-  return ptr;
-  }
-  }
-*/
-
 //
 // transmit descriptor
 //
diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 483b017..1d45ea8 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -741,12 +741,6 @@ typedef struct __device_info {
 	bool bWPADEVUp;
 	struct sk_buff          *skb;
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-/*
-  bool bwextstep0;
-  bool bwextstep1;
-  bool bwextstep2;
-  bool bwextstep3;
-*/
 	unsigned int	bwextcount;
 	bool bWPASuppWextEnabled;
 #endif
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index a952df1..0def20b 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -89,7 +89,6 @@
 #include <linux/slab.h>
 
 /*---------------------  Static Definitions -------------------------*/
-//static int          msglevel                =MSG_LEVEL_DEBUG;
 static int          msglevel                =   MSG_LEVEL_INFO;
 
 //
@@ -100,14 +99,8 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("VIA Networking Solomon-A/B/G Wireless LAN Adapter Driver");
 
 static int mlme_kill;
-//static  struct task_struct * mlme_task;
 
 #define DEVICE_PARAM(N, D)
-/*
-  static const int N[MAX_UINTS]=OPTION_DEFAULT;\
-  MODULE_PARM(N, "1-" __MODULE_STRING(MAX_UINTS) "i");\
-  MODULE_PARM_DESC(N, D);
-*/
 
 #define RX_DESC_MIN0     16
 #define RX_DESC_MAX0     128
@@ -346,38 +339,6 @@ static void vt6655_remove(struct pci_dev *pcid)
 	device_free_info(pDevice);
 }
 
-/*
-  static void
-  device_set_int_opt(int *opt, int val, int min, int max, int def,char* name,char* devname) {
-  if (val==-1)
-  *opt=def;
-  else if (val<min || val>max) {
-  DBG_PRT(MSG_LEVEL_INFO, KERN_NOTICE "%s: the value of parameter %s is invalid, the valid range is (%d-%d)\n" ,
-  devname,name, min,max);
-  *opt=def;
-  } else {
-  DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "%s: set value of parameter %s to %d\n",
-  devname, name, val);
-  *opt=val;
-  }
-  }
-
-  static void
-  device_set_bool_opt(unsigned int *opt, int val,bool def,u32 flag, char* name,char* devname) {
-  (*opt)&=(~flag);
-  if (val==-1)
-  *opt|=(def ? flag : 0);
-  else if (val<0 || val>1) {
-  DBG_PRT(MSG_LEVEL_INFO, KERN_NOTICE
-  "%s: the value of parameter %s is invalid, the valid range is (0-1)\n",devname,name);
-  *opt|=(def ? flag : 0);
-  } else {
-  DBG_PRT(MSG_LEVEL_INFO, KERN_NOTICE "%s: set parameter %s to %s\n",
-  devname,name , val ? "true" : "false");
-  *opt|=(val ? flag : 0);
-  }
-  }
-*/
 static void device_get_options(PSDevice pDevice, int index, char *devname)
 {
 	POPTIONS pOpts = &(pDevice->sOpts);
@@ -395,7 +356,6 @@ static void device_get_options(PSDevice pDevice, int index, char *devname)
 
 	pOpts->flags |= DEVICE_FLAGS_PREAMBLE_TYPE;
 	pOpts->flags |= DEVICE_FLAGS_OP_MODE;
-	//pOpts->flags|=DEVICE_FLAGS_PS_MODE;
 	pOpts->short_retry = SHORT_RETRY_DEF;
 	pOpts->long_retry = LONG_RETRY_DEF;
 	pOpts->bbp_type = BBP_TYPE_DEF;
@@ -431,7 +391,6 @@ device_set_options(PSDevice pDevice) {
 
 //PLICE_DEBUG->
 	pDevice->byAutoFBCtrl = AUTO_FB_0;
-	//pDevice->byAutoFBCtrl = AUTO_FB_1;
 //PLICE_DEBUG<-
 	pDevice->bUpdateBBVGA = true;
 	pDevice->byFOETuning = 0;
@@ -549,12 +508,12 @@ static void device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
 		if (byValue == 0) // if not set default is All
 			byValue = (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN);
 
-		pDevice->ulDiversityNValue = 100*260;//100*SROMbyReadEmbedded(pDevice->PortOffset, 0x51);
-		pDevice->ulDiversityMValue = 100*16;//SROMbyReadEmbedded(pDevice->PortOffset, 0x52);
-		pDevice->byTMax = 1;//SROMbyReadEmbedded(pDevice->PortOffset, 0x53);
-		pDevice->byTMax2 = 4;//SROMbyReadEmbedded(pDevice->PortOffset, 0x54);
-		pDevice->ulSQ3TH = 0;//(unsigned long) SROMbyReadEmbedded(pDevice->PortOffset, 0x55);
-		pDevice->byTMax3 = 64;//SROMbyReadEmbedded(pDevice->PortOffset, 0x56);
+		pDevice->ulDiversityNValue = 100*260;
+		pDevice->ulDiversityMValue = 100*16;
+		pDevice->byTMax = 1;
+		pDevice->byTMax2 = 4;
+		pDevice->ulSQ3TH = 0;
+		pDevice->byTMax3 = 64;
 
 		if (byValue == (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN)) {
 			pDevice->byAntennaCount = 2;
@@ -568,7 +527,7 @@ static void device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
 			// chester for antenna
 			byValue1 = SROMbyReadEmbedded(pDevice->PortOffset, EEP_OFS_ANTENNA);
 			if ((byValue1 & 0x08) == 0)
-				pDevice->bDiversityEnable = false;//SROMbyReadEmbedded(pDevice->PortOffset, 0x50);
+				pDevice->bDiversityEnable = false;
 			else
 				pDevice->bDiversityEnable = true;
 		} else  {
@@ -593,7 +552,6 @@ static void device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bDiversityEnable=[%d],NValue=[%d],MValue=[%d],TMax=[%d],TMax2=[%d]\n",
 			pDevice->bDiversityEnable, (int)pDevice->ulDiversityNValue, (int)pDevice->ulDiversityMValue, pDevice->byTMax, pDevice->byTMax2);
 
-//#ifdef ZoneType_DefaultSetting
 //2008-8-4 <add> by chester
 //zonetype initial
 		pDevice->byOriginalZonetype = pDevice->abyEEPROM[EEP_OFS_ZONETYPE];
@@ -647,9 +605,6 @@ static void device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
 		pDevice->byCurPwr = 0xFF;
 		pDevice->byCCKPwr = SROMbyReadEmbedded(pDevice->PortOffset, EEP_OFS_PWR_CCK);
 		pDevice->byOFDMPwrG = SROMbyReadEmbedded(pDevice->PortOffset, EEP_OFS_PWR_OFDMG);
-		//byCCKPwrdBm = SROMbyReadEmbedded(pDevice->PortOffset, EEP_OFS_CCK_PWR_dBm);
-
-		//byOFDMPwrdBm = SROMbyReadEmbedded(pDevice->PortOffset, EEP_OFS_OFDM_PWR_dBm);
 
 		// Load power Table
 
@@ -715,7 +670,6 @@ static void device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
 
 		pDevice->byCurrentCh = 0;
 
-		//pDevice->NetworkType = Ndis802_11Automode;
 		// Set BB and packet type at the same time.
 		// Set Short Slot Time, xIFS, and RSPINF.
 		if (pDevice->uConnectionRate == RATE_AUTO) {
@@ -746,42 +700,41 @@ static void device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
 			CARDbRadioPowerOff(pDevice);
 		} else  CARDbRadioPowerOn(pDevice);
 #else
-		if (((pDevice->byGPIO & GPIO0_DATA) && !(pDevice->byRadioCtl & EEP_RADIOCTL_INV)) ||
-		    (!(pDevice->byGPIO & GPIO0_DATA) && (pDevice->byRadioCtl & EEP_RADIOCTL_INV))) {
-			pDevice->bHWRadioOff = true;
+			if (((pDevice->byGPIO & GPIO0_DATA) && !(pDevice->byRadioCtl & EEP_RADIOCTL_INV)) ||
+			    (!(pDevice->byGPIO & GPIO0_DATA) && (pDevice->byRadioCtl & EEP_RADIOCTL_INV))) {
+				pDevice->bHWRadioOff = true;
+			}
 		}
-	}
-	if (pDevice->bHWRadioOff || pDevice->bRadioControlOff) {
+	if (pDevice->bHWRadioOff || pDevice->bRadioControlOff)
 		CARDbRadioPowerOff(pDevice);
-	}
 
 #endif
-}
-pMgmt->eScanType = WMAC_SCAN_PASSIVE;
-// get Permanent network address
-SROMvReadEtherAddress(pDevice->PortOffset, pDevice->abyCurrentNetAddr);
-DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Network address = %pM\n",
-	pDevice->abyCurrentNetAddr);
-
-// reset Tx pointer
-CARDvSafeResetRx(pDevice);
-// reset Rx pointer
-CARDvSafeResetTx(pDevice);
-
-if (pDevice->byLocalID <= REV_ID_VT3253_A1) {
-	MACvRegBitsOn(pDevice->PortOffset, MAC_REG_RCR, RCR_WPAERR);
-}
+	}
+
+	pMgmt->eScanType = WMAC_SCAN_PASSIVE;
+	// get Permanent network address
+	SROMvReadEtherAddress(pDevice->PortOffset, pDevice->abyCurrentNetAddr);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Network address = %pM\n",
+		pDevice->abyCurrentNetAddr);
 
-pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
+	// reset Tx pointer
+	CARDvSafeResetRx(pDevice);
+	// reset Rx pointer
+	CARDvSafeResetTx(pDevice);
 
-// Turn On Rx DMA
-MACvReceive0(pDevice->PortOffset);
-MACvReceive1(pDevice->PortOffset);
+	if (pDevice->byLocalID <= REV_ID_VT3253_A1)
+		MACvRegBitsOn(pDevice->PortOffset, MAC_REG_RCR, RCR_WPAERR);
 
-// start the adapter
-MACvStart(pDevice->PortOffset);
+	pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 
-netif_stop_queue(pDevice->dev);
+	// Turn On Rx DMA
+	MACvReceive0(pDevice->PortOffset);
+	MACvReceive1(pDevice->PortOffset);
+
+	// start the adapter
+	MACvStart(pDevice->PortOffset);
+
+	netif_stop_queue(pDevice->dev);
 }
 
 static void device_init_diversity_timer(PSDevice pDevice) {
@@ -807,7 +760,7 @@ static bool device_release_WPADEV(PSDevice pDevice)
 {
 	viawget_wpa_header *wpahdr;
 	int ii = 0;
-	// wait_queue_head_t	Set_wait;
+
 	//send device close to wpa_supplicnat layer
 	if (pDevice->bWPADEVUp) {
 		wpahdr = (viawget_wpa_header *)pDevice->skb->data;
@@ -823,9 +776,6 @@ static bool device_release_WPADEV(PSDevice pDevice)
 		netif_rx(pDevice->skb);
 		pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
 
-		//wait release WPADEV
-		//    init_waitqueue_head(&Set_wait);
-		//    wait_event_timeout(Set_wait, ((pDevice->wpadev==NULL)&&(pDevice->skb == NULL)),5*HZ);    //1s wait
 		while (pDevice->bWPADEVUp) {
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			schedule_timeout(HZ / 20);          //wait 50ms
@@ -869,7 +819,6 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 	}
 
 	// Chain it all together
-	// SET_MODULE_OWNER(dev);
 	SET_NETDEV_DEV(dev, &pcid->dev);
 
 	if (bFirst) {
@@ -902,7 +851,6 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 
 #ifdef	DEBUG
 
-	//pci_read_config_byte(pcid, PCI_BASE_ADDRESS_0, &pDevice->byRevId);
 	printk("after get pci_info memaddr is %x, io addr is %x,io_size is %d\n", pDevice->memaddr, pDevice->ioaddr, pDevice->io_size);
 	{
 		int i;
@@ -916,7 +864,6 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 			PCI_BASE_ADDRESS_5,
 			0};
 		for (i = 0; address[i]; i++) {
-			//pci_write_config_dword(pcid,address[i], 0xFFFFFFFF);
 			pci_read_config_dword(pcid, address[i], &bar);
 			printk("bar %d is %x\n", i, bar);
 			if (!bar) {
@@ -942,11 +889,7 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 
 #endif
 
-#ifdef	DEBUG
-	//return  0;
-#endif
 	pDevice->PortOffset = (unsigned long)ioremap(pDevice->memaddr & PCI_BASE_ADDRESS_MEM_MASK, pDevice->io_size);
-	//pDevice->PortOffset = (unsigned long)ioremap(pDevice->ioaddr & PCI_BASE_ADDRESS_IO_MASK, pDevice->io_size);
 
 	if (pDevice->PortOffset == 0) {
 		printk(KERN_ERR DEVICE_NAME ": Failed to IO remapping ..\n");
@@ -967,7 +910,6 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 
 	VNSvInPortB(pDevice->PortOffset+0x4F, &value);
 	printk("Before write: value is %x\n", value);
-	//VNSvInPortB(pDevice->PortOffset+0x3F, 0x00);
 	VNSvOutPortB(pDevice->PortOffset, value);
 	VNSvInPortB(pDevice->PortOffset+0x4F, &value);
 	printk("After write: value is %x\n", value);
@@ -1075,11 +1017,6 @@ static bool device_get_pci_info(PSDevice pDevice, struct pci_dev *pcid) {
 	pDevice->memaddr = pci_resource_start(pcid, 0);
 	pDevice->ioaddr = pci_resource_start(pcid, 1);
 
-#ifdef	DEBUG
-//	pDevice->ioaddr = pci_resource_start(pcid, 0);
-//	pDevice->memaddr = pci_resource_start(pcid,1);
-#endif
-
 	cis_addr = pci_resource_start(pcid, 2);
 
 	pDevice->pcid = pcid;
@@ -1088,13 +1025,6 @@ static bool device_get_pci_info(PSDevice pDevice, struct pci_dev *pcid) {
 	pci_write_config_byte(pcid, PCI_COMMAND, (b|PCI_COMMAND_MASTER));
 
 #ifdef	PLICE_DEBUG
-	//pci_read_config_word(pcid,PCI_MAX_LAT,&max_lat);
-	//for (ii=0;ii<0xFF;ii++)
-	//pci_read_config_word(pcid,PCI_MAX_LAT,&max_lat);
-	//max_lat  = 0x20;
-	//pci_write_config_word(pcid,PCI_MAX_LAT,max_lat);
-	//pci_read_config_word(pcid,PCI_MAX_LAT,&max_lat);
-
 	for (ii = 0; ii < 0xFF; ii++) {
 		pci_read_config_byte(pcid, ii, &value);
 		pci_config[ii] = value;
@@ -1468,7 +1398,6 @@ static int device_rx_srv(PSDevice pDevice, unsigned int uIdx) {
 	for (pRD = pDevice->pCurrRD[uIdx];
 	     pRD->m_rd0RD0.f1Owner == OWNED_BY_HOST;
 	     pRD = pRD->next) {
-//        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pDevice->pCurrRD = %x, works = %d\n", pRD, works);
 		if (works++ > 15)
 			break;
 		if (device_receive_frame(pDevice, pRD)) {
@@ -1584,7 +1513,6 @@ static int device_tx_srv(PSDevice pDevice, unsigned int uIdx) {
 					skb->dev = pDevice->apdev;
 					skb_reset_mac_header(skb);
 					skb->pkt_type = PACKET_OTHERHOST;
-					//skb->protocol = htons(ETH_P_802_2);
 					memset(skb->cb, 0, sizeof(skb->cb));
 					netif_rx(skb);
 				}
@@ -1596,8 +1524,6 @@ static int device_tx_srv(PSDevice pDevice, unsigned int uIdx) {
 						(int)uIdx, byTsr1, byTsr0);
 				}
 
-//                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " Tx[%d] fail has error. tsr1[%02X] tsr0[%02X].\n",
-//                          (int)uIdx, byTsr1, byTsr0);
 
 				if ((pMgmt->eCurrMode == WMAC_MODE_ESS_AP) &&
 				    (pTD->pTDInfo->byFlags & TD_FLAGS_NETIF_SKB)) {
@@ -1689,33 +1615,24 @@ int MlmeThread(
 {
 	PSDevice	pDevice =  (PSDevice) Context;
 	PSRxMgmtPacket			pRxMgmtPacket;
-	// int i;
-	//complete(&pDevice->notify);
 
-	//i = 0;
-#if 1
 	while (1) {
-		//down(&pDevice->mlme_semaphore);
-		// pRxMgmtPacket =  DeQueue(pDevice);
-#if 1
 		spin_lock_irq(&pDevice->lock);
+
 		while (pDevice->rxManeQueue.packet_num != 0) {
 			pRxMgmtPacket = DeQueue(pDevice);
-			//pDevice;
-			//DequeueManageObject(pDevice->FirstRecvMngList, pDevice->LastRecvMngList);
 			vMgrRxManagePacket(pDevice, pDevice->pMgmt, pRxMgmtPacket);
 		}
 		spin_unlock_irq(&pDevice->lock);
+
 		if (mlme_kill == 0)
 			break;
-		//udelay(200);
-#endif
+
 		schedule();
 		if (mlme_kill == 0)
 			break;
 	}
 
-#endif
 	return 0;
 }
 
@@ -1749,7 +1666,6 @@ static int  device_open(struct net_device *dev) {
 	device_init_defrag_cb(pDevice);
 	device_init_td0_ring(pDevice);
 	device_init_td1_ring(pDevice);
-//    VNTWIFIvSet11h(pDevice->pMgmt, pDevice->b11hEnable);
 
 	if (pDevice->bDiversityRegCtlON) {
 		device_init_diversity_timer(pDevice);
@@ -1773,8 +1689,6 @@ static int  device_open(struct net_device *dev) {
 	mlme_kill = 1;
 #endif
 
-	//wait_for_completion(&pDevice->notify);
-
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "call device_init_registers\n");
 	device_init_registers(pDevice, DEVICE_INIT_COLD);
 	MACvReadEtherAddress(pDevice->PortOffset, pDevice->abyCurrentNetAddr);
@@ -1786,12 +1700,6 @@ static int  device_open(struct net_device *dev) {
 	add_timer(&(pDevice->pMgmt->sTimerSecondCallback));
 
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-	/*
-	  pDevice->bwextstep0 = false;
-	  pDevice->bwextstep1 = false;
-	  pDevice->bwextstep2 = false;
-	  pDevice->bwextstep3 = false;
-	*/
 	pDevice->bwextcount = 0;
 	pDevice->bWPASuppWextEnabled = false;
 #endif
@@ -1873,9 +1781,7 @@ static int  device_close(struct net_device *dev) {
 	pDevice->flags &= (~DEVICE_FLAGS_OPENED);
 	//2008-0714-01<Add>by chester
 	device_release_WPADEV(pDevice);
-//PLICE_DEBUG->
-	//tasklet_kill(&pDevice->RxMngWorkItem);
-//PLICE_DEBUG<-
+
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "device_close.. \n");
 	return 0;
 }
@@ -1922,7 +1828,6 @@ bool device_dma0_xmit(PSDevice pDevice, struct sk_buff *skb, unsigned int uNodeI
 	unsigned int cbHeaderSize;
 	unsigned int ii;
 	SKeyItem        STempKey;
-//    unsigned char byKeyIndex = 0;
 
 	if (pDevice->bStopTx0Pkt) {
 		dev_kfree_skb_irq(skb);
@@ -2279,7 +2184,6 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
 		}
 	}
 
-//    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "acdma0: pDevice->wCurrentRate = %d \n", pDevice->wCurrentRate);
 
 	if (pDevice->wCurrentRate <= RATE_11M) {
 		byPktType = PK_TYPE_11B;
@@ -2293,10 +2197,6 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
 		}
 	}
 
-//#ifdef	PLICE_DEBUG
-//	printk("FIX RATE:CurrentRate is %d");
-//#endif
-
 	if (bNeedEncryption) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ntohs Pkt Type=%04x\n", ntohs(pDevice->sTxEthHeader.wType));
 		if ((pDevice->sTxEthHeader.wType) == TYPE_PKT_802_1x) {
@@ -2374,12 +2274,9 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
 	}
 
 	pDevice->apCurrTD[TYPE_AC0DMA] = pHeadTD;
-//#ifdef	PLICE_DEBUG
-	if (pDevice->bFixRate) {
+
+	if (pDevice->bFixRate)
 		printk("FixRate:Rate is %d,TxPower is %d\n", pDevice->wCurrentRate, pDevice->byCurPwr);
-	} else {
-	}
-//#endif
 
 	{
 		unsigned char Protocol_Version;    //802.1x Authentication
@@ -2411,7 +2308,6 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
 	}
 
 	MACvTransmitAC0(pDevice->PortOffset);
-//    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "acdma0:pDevice->apCurrTD= %p\n", pHeadTD);
 
 	dev->trans_start = jiffies;
 
@@ -2430,7 +2326,6 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
 	int             handled = 0;
 	unsigned char byData = 0;
 	int             ii = 0;
-//    unsigned char byRSSI;
 
 	MACvReadISR(pDevice->PortOffset, &pDevice->dwIsr);
 
@@ -2441,17 +2336,6 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dwIsr = 0xffff\n");
 		return IRQ_RETVAL(handled);
 	}
-	/*
-	// 2008-05-21 <mark> by Richardtai, we can't read RSSI here, because no packet bound with RSSI
-
-	if ((pDevice->dwIsr & ISR_RXDMA0) &&
-	(pDevice->byLocalID != REV_ID_VT3253_B0) &&
-	(pDevice->bBSSIDFilter == true)) {
-	// update RSSI
-	//BBbReadEmbedded(pDevice->PortOffset, 0x3E, &byRSSI);
-	//pDevice->uCurrRSSI = byRSSI;
-	}
-	*/
 
 	handled = 1;
 	MACvIntDisable(pDevice->PortOffset);
@@ -2491,8 +2375,8 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
 				VNSvInPortD(pDevice->PortOffset + MAC_REG_MAR0, &(pDevice->dwOrgMAR0));
 				VNSvInPortD(pDevice->PortOffset + MAC_REG_MAR4, &(pDevice->dwOrgMAR4));
 				MACvSelectPage0(pDevice->PortOffset);
+
 				//xxxx
-				// WCMDbFlushCommandQueue(pDevice->pMgmt, true);
 				if (set_channel(pDevice, pDevice->pCurrMeasureEID->sReq.byChannel)) {
 					pDevice->bMeasureInProgress = true;
 					MACvSelectPage1(pDevice->PortOffset);
@@ -2505,7 +2389,6 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
 					}
 				} else {
 					// can not measure because set channel fail
-					// WCMDbResetCommandQueue(pDevice->pMgmt);
 					// clear measure control
 					MACvRegBitsOff(pDevice->PortOffset, MAC_REG_MSRCTL, MSRCTL_EN);
 					s_vCompleteCurrentMeasure(pDevice, MEASURE_MODE_INCAPABLE);
@@ -2529,7 +2412,6 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
 				MACvRegBitsOff(pDevice->PortOffset, MAC_REG_MSRCTL, MSRCTL_EN);
 				MACvSelectPage0(pDevice->PortOffset);
 				set_channel(pDevice, pDevice->byOrgChannel);
-				// WCMDbResetCommandQueue(pDevice->pMgmt);
 				MACvSelectPage1(pDevice->PortOffset);
 				MACvRegBitsOn(pDevice->PortOffset, MAC_REG_MSRCTL+1, MSRCTL1_TXPAUSE);
 				MACvSelectPage0(pDevice->PortOffset);
@@ -2572,9 +2454,7 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
 
 				}
 			}
-			if (pDevice->eOPMode == OP_MODE_ADHOC) {
-				//pDevice->bBeaconSent = false;
-			} else {
+			if (pDevice->eOPMode != OP_MODE_ADHOC) {
 				if ((pDevice->bUpdateBBVGA) && pDevice->bLinkPass && (pDevice->uCurrRSSI != 0)) {
 					long            ldBm;
 
@@ -2615,9 +2495,7 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
 							  (pMgmt->wIBSSBeaconPeriod - MAKE_BEACON_RESERVED) << 10);
 			}
 
-			if (pDevice->eOPMode == OP_MODE_ADHOC && pDevice->pMgmt->wCurrATIMWindow > 0) {
-				// todo adhoc PS mode
-			}
+			/* TODO: adhoc PS mode */
 
 		}
 
@@ -2651,7 +2529,6 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
 					MACvSelectPage1(pDevice->PortOffset);
 					MACvRegBitsOn(pDevice->PortOffset, MAC_REG_MSRCTL+1, MSRCTL1_TXPAUSE);
 					MACvSelectPage0(pDevice->PortOffset);
-					//VNTWIFIbSendBeacon(pDevice->pMgmt);
 					CARDbStartTxPacket(pDevice, PKT_TYPE_802_11_ALL);
 				}
 			}
@@ -3099,16 +2976,6 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 	case SIOCGIWPRIV:
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWPRIV \n");
 		rc = -EOPNOTSUPP;
-/*
-  if (wrq->u.data.pointer) {
-  wrq->u.data.length = sizeof(iwctl_private_args) / sizeof(iwctl_private_args[0]);
-
-  if (copy_to_user(wrq->u.data.pointer,
-  (u_char *) iwctl_private_args,
-  sizeof(iwctl_private_args)))
-  rc = -EFAULT;
-  }
-*/
 		break;
 
 //2008-0409-07, <Add> by Einsn Liu
@@ -3290,8 +3157,6 @@ static int __init vt6655_init_module(void)
 {
 	int ret;
 
-//    ret=pci_module_init(&device_driver);
-	//ret = pcie_port_service_register(&device_driver);
 	ret = pci_register_driver(&device_driver);
 #ifdef CONFIG_PM
 	if (ret >= 0)
diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index 771bf35..ce06458 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -60,7 +60,6 @@
 /*---------------------  Static Classes  ----------------------------*/
 
 /*---------------------  Static Variables  --------------------------*/
-//static int          msglevel                =MSG_LEVEL_DEBUG;
 static int msglevel = MSG_LEVEL_INFO;
 
 const unsigned char acbyRxRate[MAX_RATE] =
@@ -327,15 +326,11 @@ device_receive_frame(
 	PS802_11Header pMACHeader;
 	bool bRxeapol_key = false;
 
-//    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "---------- device_receive_frame---\n");
-
 	skb = pRDInfo->skb;
 
 //PLICE_DEBUG->
-#if 1
 	pci_unmap_single(pDevice->pcid, pRDInfo->skb_dma,
 			 pDevice->rx_buf_sz, PCI_DMA_FROMDEVICE);
-#endif
 //PLICE_DEBUG<-
 	pwFrameSize = (unsigned short *)(skb->data + 2);
 	FrameSize = cpu_to_le16(pCurrRD->m_rd1RD1.wReqCount) - cpu_to_le16(pCurrRD->m_rd0RD0.wResCount);
@@ -366,7 +361,6 @@ device_receive_frame(
 		return false;
 	}
 //PLICE_DEBUG->
-#if 1
 	// update receive statistic counter
 	STAvUpdateRDStatCounter(&pDevice->scStatistic,
 				*pbyRsr,
@@ -375,8 +369,6 @@ device_receive_frame(
 				pbyFrame,
 				FrameSize);
 
-#endif
-
 	pMACHeader = (PS802_11Header)((unsigned char *)(skb->data) + 8);
 //PLICE_DEBUG<-
 	if (pDevice->bMeasureInProgress) {
@@ -488,13 +480,10 @@ device_receive_frame(
 				    (pDevice->pMgmt->eAuthenMode == WMAC_AUTH_WPANONE) ||
 				    (pDevice->pMgmt->eAuthenMode == WMAC_AUTH_WPA2) ||
 				    (pDevice->pMgmt->eAuthenMode == WMAC_AUTH_WPA2PSK)) {
-					if ((pKey != NULL) && (pKey->byCipherSuite == KEY_CTL_TKIP)) {
+					if ((pKey != NULL) && (pKey->byCipherSuite == KEY_CTL_TKIP))
 						pDevice->s802_11Counter.TKIPICVErrors++;
-					} else if ((pKey != NULL) && (pKey->byCipherSuite == KEY_CTL_CCMP)) {
+					else if ((pKey != NULL) && (pKey->byCipherSuite == KEY_CTL_CCMP))
 						pDevice->s802_11Counter.CCMPDecryptErrors++;
-					} else if ((pKey != NULL) && (pKey->byCipherSuite == KEY_CTL_WEP)) {
-//                      pDevice->s802_11Counter.WEPICVErrorCount.QuadPart++;
-					}
 				}
 				return false;
 			}
@@ -557,13 +546,9 @@ device_receive_frame(
 			pRxPacket->byRxRate = s_byGetRateIdx(*pbyRxRate);
 			pRxPacket->byRxChannel = (*pbyRxSts) >> 2;
 //PLICE_DEBUG->
-//EnQueue(pDevice,pRxPacket);
 
 #ifdef	THREAD
 			EnQueue(pDevice, pRxPacket);
-
-			//up(&pDevice->mlme_semaphore);
-			//Enque (pDevice->FirstRecvMngList,pDevice->LastRecvMngList,pMgmt);
 #else
 
 #ifdef	TASK_LET
@@ -571,12 +556,10 @@ device_receive_frame(
 			tasklet_schedule(&pDevice->RxMngWorkItem);
 #else
 			vMgrRxManagePacket((void *)pDevice, pDevice->pMgmt, pRxPacket);
-			//tasklet_schedule(&pDevice->RxMngWorkItem);
 #endif
 
 #endif
 //PLICE_DEBUG<-
-			//vMgrRxManagePacket((void *)pDevice, pDevice->pMgmt, pRxPacket);
 			// hostap Deamon handle 802.11 management
 			if (pDevice->bEnableHostapd) {
 				skb->dev = pDevice->apdev;
@@ -590,9 +573,8 @@ device_receive_frame(
 				netif_rx(skb);
 				return true;
 			}
-		} else {
-			// Control Frame
 		}
+
 		return false;
 	} else {
 		if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
@@ -643,12 +625,8 @@ device_receive_frame(
 // Data frame Handle
 
 	if (pDevice->bEnablePSMode) {
-		if (IS_FC_MOREDATA((skb->data+4))) {
-			if (*pbyRsr & RSR_ADDROK) {
-				//PSbSendPSPOLL((PSDevice)pDevice);
-			}
-		} else {
-			if (pDevice->pMgmt->bInTIMWake == true) {
+		if (!IS_FC_MOREDATA((skb->data+4))) {
+			if (pDevice->pMgmt->bInTIMWake == true)
 				pDevice->pMgmt->bInTIMWake = false;
 			}
 		}
@@ -765,16 +743,12 @@ device_receive_frame(
 
 			pdwMIC_L = (__le32 *)(skb->data + 4 + FrameSize);
 			pdwMIC_R = (__le32 *)(skb->data + 4 + FrameSize + 4);
-			//DBG_PRN_GRP12(("RxL: %lx, RxR: %lx\n", *pdwMIC_L, *pdwMIC_R));
-			//DBG_PRN_GRP12(("LocalL: %lx, LocalR: %lx\n", dwLocalMIC_L, dwLocalMIC_R));
-			//DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dwMICKey0= %lx,dwMICKey1= %lx \n", dwMICKey0, dwMICKey1);
 
 			if ((le32_to_cpu(*pdwMIC_L) != dwLocalMIC_L) ||
 			    (le32_to_cpu(*pdwMIC_R) != dwLocalMIC_R) ||
 			    pDevice->bRxMICFail) {
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "MIC comparison is fail!\n");
 				pDevice->bRxMICFail = false;
-				//pDevice->s802_11Counter.TKIPLocalMICFailures.QuadPart++;
 				pDevice->s802_11Counter.TKIPLocalMICFailures++;
 				if (bDeFragRx) {
 					if (!device_alloc_frag_buf(pDevice, &pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx])) {
@@ -813,10 +787,8 @@ device_receive_frame(
 					if ((pDevice->pMgmt->eCurrMode == WMAC_MODE_ESS_STA) &&
 					    (pDevice->pMgmt->eCurrState == WMAC_STATE_ASSOC) &&
 					    (*pbyRsr & (RSR_ADDRBROAD | RSR_ADDRMULTI)) == 0) {
-						//s802_11_Status.Flags = NDIS_802_11_AUTH_REQUEST_PAIRWISE_ERROR;
 						wpahdr->type = VIAWGET_PTK_MIC_MSG;
 					} else {
-						//s802_11_Status.Flags = NDIS_802_11_AUTH_REQUEST_GROUP_ERROR;
 						wpahdr->type = VIAWGET_GTK_MIC_MSG;
 					}
 					wpahdr->resp_ie_len = 0;
@@ -863,10 +835,8 @@ device_receive_frame(
 				    !((dwRxTSC47_16 == 0) && (dwLocalTSC47_16 == 0xFFFFFFFF))) {
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "TSC is illegal~~!\n ");
 					if (pKey->byCipherSuite == KEY_CTL_TKIP)
-						//pDevice->s802_11Counter.TKIPReplays.QuadPart++;
 						pDevice->s802_11Counter.TKIPReplays++;
 					else
-						//pDevice->s802_11Counter.CCMPReplays.QuadPart++;
 						pDevice->s802_11Counter.CCMPReplays++;
 
 					if (bDeFragRx) {
@@ -881,10 +851,6 @@ device_receive_frame(
 		}
 	} // ----- End of Reply Counter Check --------------------------
 
-	if ((pKey != NULL) && (bIsWEP)) {
-//      pDevice->s802_11Counter.DecryptSuccessCount.QuadPart++;
-	}
-
 	s_vProcessRxMACHeader(pDevice, (unsigned char *)(skb->data+4), FrameSize, bIsWEP, bExtIV, &cbHeaderOffset);
 	FrameSize -= cbHeaderOffset;
 	cbHeaderOffset += 4;        // 4 is Rcv buffer header
@@ -917,22 +883,6 @@ device_receive_frame(
 	skb->protocol = eth_type_trans(skb, skb->dev);
 
 	//drop frame not met IEEE 802.3
-/*
-  if (pDevice->flags & DEVICE_FLAGS_VAL_PKT_LEN) {
-  if ((skb->protocol==htons(ETH_P_802_3)) &&
-  (skb->len!=htons(skb->mac.ethernet->h_proto))) {
-  pStats->rx_length_errors++;
-  pStats->rx_dropped++;
-  if (bDeFragRx) {
-  if (!device_alloc_frag_buf(pDevice, &pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx])) {
-  DBG_PRT(MSG_LEVEL_ERR,KERN_ERR "%s: can not alloc more frag bufs\n",
-  pDevice->dev->name);
-  }
-  }
-  return false;
-  }
-  }
-*/
 
 	skb->ip_summed = CHECKSUM_NONE;
 	pStats->rx_bytes += skb->len;
@@ -1121,19 +1071,11 @@ static bool s_bHandleRxEncryption(
 
 	if (pKey == NULL) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey == NULL\n");
-		if (byDecMode == KEY_CTL_WEP) {
-//            pDevice->s802_11Counter.WEPUndecryptableCount.QuadPart++;
-		} else if (pDevice->bLinkPass) {
-//            pDevice->s802_11Counter.DecryptFailureCount.QuadPart++;
-		}
+
 		return false;
 	}
 	if (byDecMode != pKey->byCipherSuite) {
-		if (byDecMode == KEY_CTL_WEP) {
-//            pDevice->s802_11Counter.WEPUndecryptableCount.QuadPart++;
-		} else if (pDevice->bLinkPass) {
-//            pDevice->s802_11Counter.DecryptFailureCount.QuadPart++;
-		}
+
 		*pKeyOut = NULL;
 		return false;
 	}
@@ -1231,14 +1173,8 @@ static bool s_bHostWepRxEncryption(
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "AES:%d %d %d\n", pDevice->pMgmt->byCSSPK, pDevice->pMgmt->byCSSGK, byDecMode);
 
-	if (byDecMode != pKey->byCipherSuite) {
-		if (byDecMode == KEY_CTL_WEP) {
-//            pDevice->s802_11Counter.WEPUndecryptableCount.QuadPart++;
-		} else if (pDevice->bLinkPass) {
-//            pDevice->s802_11Counter.DecryptFailureCount.QuadPart++;
-		}
+	if (byDecMode != pKey->byCipherSuite)
 		return false;
-	}
 
 	if (byDecMode == KEY_CTL_WEP) {
 		// handle WEP
diff --git a/drivers/staging/vt6655/hostap.c b/drivers/staging/vt6655/hostap.c
index 6eecd53..15c57452 100644
--- a/drivers/staging/vt6655/hostap.c
+++ b/drivers/staging/vt6655/hostap.c
@@ -48,7 +48,6 @@
 /*---------------------  Static Classes  ----------------------------*/
 
 /*---------------------  Static Variables  --------------------------*/
-//static int          msglevel                =MSG_LEVEL_DEBUG;
 static int msglevel = MSG_LEVEL_INFO;
 
 /*---------------------  Static Functions  --------------------------*/
@@ -241,7 +240,6 @@ static int hostap_add_sta(PSDevice pDevice,
 	pMgmt->sNodeDBTable[uNodeIndex].eNodeState = NODE_ASSOC;
 	pMgmt->sNodeDBTable[uNodeIndex].wCapInfo = param->u.add_sta.capability;
 // TODO listenInterval
-//    pMgmt->sNodeDBTable[uNodeIndex].wListenInterval = 1;
 	pMgmt->sNodeDBTable[uNodeIndex].bPSEnable = false;
 	pMgmt->sNodeDBTable[uNodeIndex].bySuppRate = param->u.add_sta.tx_supp_rates;
 
@@ -296,8 +294,6 @@ static int hostap_get_info_sta(PSDevice pDevice,
 	if (BSSDBbIsSTAInNodeDB(pMgmt, param->sta_addr, &uNodeIndex)) {
 		param->u.get_info_sta.inactive_sec =
 			(jiffies - pMgmt->sNodeDBTable[uNodeIndex].ulLastRxJiffer) / HZ;
-
-		//param->u.get_info_sta.txexc = pMgmt->sNodeDBTable[uNodeIndex].uTxAttempts;
 	} else {
 		return -ENOENT;
 	}
@@ -307,37 +303,6 @@ static int hostap_get_info_sta(PSDevice pDevice,
 
 /*
  * Description:
- *      reset txexec
- *
- * Parameters:
- *  In:
- *      pDevice   -
- *      param     -
- *  Out:
- *      true, false
- *
- * Return Value:
- *
- */
-/*
-  static int hostap_reset_txexc_sta(PSDevice pDevice,
-  struct viawget_hostapd_param *param)
-  {
-  PSMgmtObject    pMgmt = pDevice->pMgmt;
-  unsigned int uNodeIndex;
-
-  if (BSSDBbIsSTAInNodeDB(pMgmt, param->sta_addr, &uNodeIndex)) {
-  pMgmt->sNodeDBTable[uNodeIndex].uTxAttempts = 0;
-  } else {
-  return -ENOENT;
-  }
-
-  return 0;
-  }
-*/
-
-/*
- * Description:
  *      set station flag
  *
  * Parameters:
@@ -463,12 +428,6 @@ static int hostap_set_encryption(PSDevice pDevice,
 	unsigned short wKeyCtl = 0;
 
 	param->u.crypt.err = 0;
-/*
-  if (param_len !=
-  (int) ((char *) param->u.crypt.key - (char *) param) +
-  param->u.crypt.key_len)
-  return -EINVAL;
-*/
 
 	if (param->u.crypt.alg > WPA_ALG_CCMP)
 		return -EINVAL;
@@ -780,12 +739,6 @@ int vt6655_hostap_ioctl(PSDevice pDevice, struct iw_point *p)
 		ret = hostap_get_info_sta(pDevice, param);
 		ap_ioctl = 1;
 		break;
-/*
-	case VIAWGET_HOSTAPD_RESET_TXEXC_STA:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_RESET_TXEXC_STA \n");
-		ret = hostap_reset_txexc_sta(pDevice, param);
-		break;
-*/
 	case VIAWGET_HOSTAPD_SET_FLAGS_STA:
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_SET_FLAGS_STA \n");
 		ret = hostap_set_flags_sta(pDevice, param);
diff --git a/drivers/staging/vt6655/ioctl.c b/drivers/staging/vt6655/ioctl.c
index b5cd2e4..35752f5 100644
--- a/drivers/staging/vt6655/ioctl.c
+++ b/drivers/staging/vt6655/ioctl.c
@@ -318,7 +318,6 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 				pList->sBSSIDList[ii].uChannel = pBSS->uChannel;
 				pList->sBSSIDList[ii].wBeaconInterval = pBSS->wBeaconInterval;
 				pList->sBSSIDList[ii].wCapInfo = pBSS->wCapInfo;
-				/* pList->sBSSIDList[ii].uRSSI = pBSS->uRSSI; */
 				RFvRSSITodBm(pDevice, (unsigned char)(pBSS->uRSSI), &ldBm);
 				pList->sBSSIDList[ii].uRSSI = (unsigned int)ldBm;
 				memcpy(pList->sBSSIDList[ii].abyBSSID, pBSS->abyBSSID, WLAN_BSSID_LEN);
diff --git a/drivers/staging/vt6655/ioctl.h b/drivers/staging/vt6655/ioctl.h
index ae240fd..2f0db92 100644
--- a/drivers/staging/vt6655/ioctl.h
+++ b/drivers/staging/vt6655/ioctl.h
@@ -41,13 +41,4 @@
 
 int private_ioctl(PSDevice pDevice, struct ifreq *rq);
 
-/*
-  void vConfigWEPKey(
-  PSDevice pDevice,
-  unsigned long dwKeyIndex,
-  unsigned char *pbyKey,
-  unsigned long uKeyLength
-);
-*/
-
 #endif // __IOCTL_H__
diff --git a/drivers/staging/vt6655/iowpa.h b/drivers/staging/vt6655/iowpa.h
index bfea01f..b7bd190 100644
--- a/drivers/staging/vt6655/iowpa.h
+++ b/drivers/staging/vt6655/iowpa.h
@@ -34,13 +34,6 @@
 #define WPA_IE_LEN 64
 
 //WPA related
-/*
-  typedef enum { WPA_ALG_NONE, WPA_ALG_WEP, WPA_ALG_TKIP, WPA_ALG_CCMP } wpa_alg;
-  typedef enum { CIPHER_NONE, CIPHER_WEP40, CIPHER_TKIP, CIPHER_CCMP,
-  CIPHER_WEP104 } wpa_cipher;
-  typedef enum { KEY_MGMT_802_1X, KEY_MGMT_PSK, KEY_MGMT_NONE,
-  KEY_MGMT_802_1X_NO_WPA, KEY_MGMT_WPA_NONE } wpa_key_mgmt;
-*/
 
 enum {
 	VIAWGET_SET_WPA = 1,
diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index ac3fc16..a3ea574 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -66,7 +66,6 @@ static const long frequency_list[] = {
 
 /*---------------------  Static Classes  ----------------------------*/
 
-//static int          msglevel                =MSG_LEVEL_DEBUG;
 static int msglevel = MSG_LEVEL_INFO;
 
 /*---------------------  Static Variables  --------------------------*/
@@ -89,7 +88,6 @@ struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
 #endif
 	RFvRSSITodBm(pDevice, (unsigned char)(pDevice->uCurrRSSI), &ldBm);
 	pDevice->wstats.qual.level = ldBm;
-	//pDevice->wstats.qual.level = 0x100 - pDevice->uCurrRSSI;
 	pDevice->wstats.qual.noise = 0;
 	pDevice->wstats.qual.updated = 1;
 	pDevice->wstats.discard.nwid = 0;
@@ -277,7 +275,6 @@ int iwctl_giwscan(struct net_device *dev,
 			}
 			iwe.u.qual.updated = 7;
 
-			//  iwe.u.qual.qual = 0;
 			current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe, IW_EV_QUAL_LEN);
 
 			memset(&iwe, 0, sizeof(iwe));
@@ -640,8 +637,8 @@ int iwctl_siwap(struct net_device *dev,
 	if (pMgmt->eScanState ==  WMAC_IS_SCANNING) {
 		// In scanning..
 		printk("SIOCSIWAP(??)-->In scanning...\n");
-		//  return -EAGAIN;
 	}
+
 	if (wrq->sa_family != ARPHRD_ETHER)
 		rc = -EINVAL;
 	else {
@@ -778,8 +775,8 @@ int iwctl_siwessid(struct net_device *dev,
 	if (pMgmt->eScanState ==  WMAC_IS_SCANNING) {
 		// In scanning..
 		printk("SIOCSIWESSID(??)-->In scanning...\n");
-		//  return -EAGAIN;
 	}
+
 	// Check if we asked for `any'
 	if (wrq->flags == 0) {
 		// Just send an empty SSID list
@@ -889,7 +886,6 @@ int iwctl_giwessid(struct net_device *dev,
 
 	// Get the current SSID
 	pItemSSID = (PWLAN_IE_SSID)pMgmt->abyCurrSSID;
-	//pItemSSID = (PWLAN_IE_SSID)pMgmt->abyDesireSSID;
 	memcpy(extra, pItemSSID->abySSID , pItemSSID->len);
 	extra[pItemSSID->len] = '\0';
 	wrq->length = pItemSSID->len + 1;
@@ -1016,21 +1012,7 @@ int iwctl_giwrate(struct net_device *dev,
 				brate = abySupportedRates[TxRate_iwconfig];
 			}
 		} else brate = 0;
-//2007-0118-05,<Mark> by EinsnLiu
-//Mark the unnecessary sentences.
-/*
-  if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
-  if (pDevice->byBBType == BB_TYPE_11B)
-  brate = 0x16;
-  if (pDevice->byBBType == BB_TYPE_11G)
-  brate = 0x6C;
-  if (pDevice->byBBType == BB_TYPE_11A)
-  brate = 0x6C;
-  }
-*/
-
-//		if (pDevice->uConnectionRate == 13)
-//                brate = abySupportedRates[pDevice->wCurrentRate];
+
 		wrq->value = brate * 500000;
 		// If more than one rate, set auto
 		if (pDevice->bFixRate == true)
@@ -1319,82 +1301,6 @@ int iwctl_siwencode(struct net_device *dev,
 	}
 //End Modify,Einsn
 
-/*
-  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWENCODE \n");
-
-  // Check the size of the key
-  if (wrq->length > WLAN_WEP232_KEYLEN) {
-  rc = -EINVAL;
-  return rc;
-  }
-
-  if (dwKeyIndex > WLAN_WEP_NKEYS) {
-  rc = -EINVAL;
-  return rc;
-  }
-
-  if (dwKeyIndex > 0)
-  dwKeyIndex--;
-
-  // Send the key to the card
-  if (wrq->length > 0) {
-  if (wrq->length ==  WLAN_WEP232_KEYLEN) {
-  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Set 232 bit wep key\n");
-  } else if (wrq->length ==  WLAN_WEP104_KEYLEN) {
-  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Set 104 bit wep key\n");
-  } else if (wrq->length == WLAN_WEP40_KEYLEN) {
-  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Set 40 bit wep key, index= %d\n", (int)dwKeyIndex);
-  }
-  memset(pDevice->abyKey, 0, WLAN_WEP232_KEYLEN);
-  memcpy(pDevice->abyKey, extra, wrq->length);
-
-  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "abyKey: ");
-  for (ii = 0; ii < wrq->length; ii++) {
-  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%02x ", pDevice->abyKey[ii]);
-  }
-
-  if (pDevice->flags & DEVICE_FLAGS_OPENED) {
-  spin_lock_irq(&pDevice->lock);
-  KeybSetDefaultKey(&(pDevice->sKey),
-  (unsigned long)(pDevice->byKeyIndex | (1 << 31)),
-  pDevice->uKeyLength,
-  NULL,
-  pDevice->abyKey,
-  KEY_CTL_WEP,
-  pDevice->PortOffset,
-  pDevice->byLocalID
-);
-  spin_unlock_irq(&pDevice->lock);
-  }
-  pDevice->byKeyIndex = (unsigned char)dwKeyIndex;
-  pDevice->uKeyLength = wrq->length;
-  pDevice->bTransmitKey = true;
-  pDevice->bEncryptionEnable = true;
-  pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
-
-  // Do we want to just set the transmit key index ?
-  if (index < 4) {
-  pDevice->byKeyIndex = index;
-  } else if (!(wrq->flags & IW_ENCODE_MODE)) {
-  rc = -EINVAL;
-  return rc;
-  }
-  }
-  // Read the flags
-  if (wrq->flags & IW_ENCODE_DISABLED) {
-  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Disable WEP function\n");
-  pMgmt->bShareKeyAlgorithm = false;
-  pDevice->bEncryptionEnable = false;
-  pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
-  if (pDevice->flags & DEVICE_FLAGS_OPENED) {
-  spin_lock_irq(&pDevice->lock);
-  for (uu=0; uu<MAX_KEY_TABLE; uu++)
-  MACvDisableKeyEntry(pDevice->PortOffset, uu);
-  spin_unlock_irq(&pDevice->lock);
-  }
-  }
-*/
-
 	if (wrq->flags & IW_ENCODE_RESTRICTED) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enable WEP & ShareKey System\n");
 		pMgmt->bShareKeyAlgorithm = true;
@@ -1406,77 +1312,6 @@ int iwctl_siwencode(struct net_device *dev,
 	return rc;
 }
 
-/*
- * Wireless Handler : get encode mode
- */
-/*
-  int iwctl_giwencode(struct net_device *dev,
-  struct iw_request_info *info,
-  struct iw_point *wrq,
-  char *extra) {
-  PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-  PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
-  int rc = 0;
-  char abyKey[WLAN_WEP232_KEYLEN];
-  unsigned int index = (unsigned int)(wrq->flags & IW_ENCODE_INDEX);
-  PSKeyItem   pKey = NULL;
-
-  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWENCODE\n");
-//2007-0207-06,<Add> by EinsnLiu
-//the key index in iwconfig is 1-4 when our driver is 0-3
-//so it can't be used directly.
-//if the index is 0,we should used the index set by driver.
-if (index > WLAN_WEP_NKEYS) {
-rc = -EINVAL;
-return rc;
-}
-if (index<1) {//set default key
-if (pDevice->byKeyIndex<WLAN_WEP_NKEYS) {
-index=pDevice->byKeyIndex;
-}
-else index=0;
-} else index--;
-//End Add,Einsn
-
-memset(abyKey, 0, sizeof(abyKey));
-// Check encryption mode
-wrq->flags = IW_ENCODE_NOKEY;
-// Is WEP enabled ???
-if (pDevice->bEncryptionEnable)
-wrq->flags |=  IW_ENCODE_ENABLED;
-else
-wrq->flags |=  IW_ENCODE_DISABLED;
-
-if (pMgmt->bShareKeyAlgorithm)
-wrq->flags |=  IW_ENCODE_RESTRICTED;
-else
-wrq->flags |=  IW_ENCODE_OPEN;
-
-if (KeybGetKey(&(pDevice->sKey), pDevice->abyBroadcastAddr, (unsigned char)index , &pKey)) {
-wrq->length = pKey->uKeyLength;
-memcpy(abyKey, pKey->abyKey,  pKey->uKeyLength);
-//2007-0207-06,<Modify> by EinsnLiu
-//only get key success need to  copy data
-//index should +1.
-//there is not necessary to return -EINVAL when get key failed
-//if return -EINVAL,the encryption item can't be display by the command "iwconfig".
-wrq->flags |= index+1;
-memcpy(extra,  abyKey, WLAN_WEP232_KEYLEN);
-}
-
-//else {
-//    rc = -EINVAL;
-//     return rc;
-//  }
-
-//End Modify,Einsn
-
-return 0;
-}
-*/
-
-//2008-0409-06, <Add> by Einsn Liu
-
 int iwctl_giwencode(struct net_device *dev,
 		    struct iw_request_info *info,
 		    struct iw_point *wrq,
@@ -1657,15 +1492,13 @@ int iwctl_siwauth(struct net_device *dev,
 	switch (wrq->flags & IW_AUTH_INDEX) {
 	case IW_AUTH_WPA_VERSION:
 		wpa_version = wrq->value;
-		if (wrq->value == IW_AUTH_WPA_VERSION_DISABLED) {
+		if (wrq->value == IW_AUTH_WPA_VERSION_DISABLED)
 			PRINT_K("iwctl_siwauth:set WPADEV to disable at 1??????\n");
-			//pDevice->bWPADevEnable = false;
-		} else if (wrq->value == IW_AUTH_WPA_VERSION_WPA) {
+		else if (wrq->value == IW_AUTH_WPA_VERSION_WPA)
 			PRINT_K("iwctl_siwauth:set WPADEV to WPA1******\n");
-		} else {
+		else
 			PRINT_K("iwctl_siwauth:set WPADEV to WPA2******\n");
-		}
-		//pDevice->bWPASuppWextEnabled =true;
+
 		break;
 	case IW_AUTH_CIPHER_PAIRWISE:
 		pairwise = wrq->value;
@@ -1718,7 +1551,6 @@ int iwctl_siwauth(struct net_device *dev,
 		}
 		break;
 	case IW_AUTH_WPA_ENABLED:
-		//pDevice->bWPADevEnable = !! wrq->value;
 		break;
 	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
 		break;
@@ -1733,7 +1565,6 @@ int iwctl_siwauth(struct net_device *dev,
 			pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 			pMgmt->bShareKeyAlgorithm = false;
 			pMgmt->eAuthenMode = false;
-			//pDevice->bWPADevEnable = false;
 		}
 
 		break;
@@ -1741,15 +1572,7 @@ int iwctl_siwauth(struct net_device *dev,
 		ret = -EOPNOTSUPP;
 		break;
 	}
-/*
-  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wpa_version = %d\n",wpa_version);
-  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pairwise = %d\n",pairwise);
-  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pDevice->eEncryptionStatus = %d\n",pDevice->eEncryptionStatus);
-  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pMgmt->eAuthenMode  = %d\n",pMgmt->eAuthenMode);
-  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pMgmt->bShareKeyAlgorithm = %s\n",pMgmt->bShareKeyAlgorithm?"true":"false");
-  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pDevice->bEncryptionEnable = %s\n",pDevice->bEncryptionEnable?"true":"false");
-  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pDevice->bWPADevEnable = %s\n",pDevice->bWPADevEnable?"true":"false");
-*/
+
 	return ret;
 }
 
@@ -1833,8 +1656,7 @@ int iwctl_siwencodeext(struct net_device *dev,
 	u8  seq[IW_ENCODE_SEQ_MAX_SIZE];
 	u8 key[64];
 	size_t seq_len = 0, key_len = 0;
-//
-	// int ii;
+
 	u8 *buf;
 	size_t blen;
 	u8 key_array[64];
@@ -1954,7 +1776,6 @@ int iwctl_siwmlme(struct net_device *dev,
 	PSDevice			pDevice = (PSDevice)netdev_priv(dev);
 	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
 	struct iw_mlme *mlme = (struct iw_mlme *)extra;
-	//u16 reason = cpu_to_le16(mlme->reason_code);
 	int ret = 0;
 
 	if (memcmp(pMgmt->abyCurrBSSID, mlme->addr.sa_data, ETH_ALEN)) {
@@ -1989,69 +1810,6 @@ int iwctl_siwmlme(struct net_device *dev,
  * Structures to export the Wireless Handlers
  */
 
-/*
-  static const iw_handler		iwctl_handler[] =
-  {
-  (iw_handler) iwctl_commit,      // SIOCSIWCOMMIT
-  (iw_handler) iwctl_giwname,     // SIOCGIWNAME
-  (iw_handler) NULL,				// SIOCSIWNWID
-  (iw_handler) NULL,				// SIOCGIWNWID
-  (iw_handler) iwctl_siwfreq,		// SIOCSIWFREQ
-  (iw_handler) iwctl_giwfreq,		// SIOCGIWFREQ
-  (iw_handler) iwctl_siwmode,		// SIOCSIWMODE
-  (iw_handler) iwctl_giwmode,		// SIOCGIWMODE
-  (iw_handler) NULL,		        // SIOCSIWSENS
-  (iw_handler) iwctl_giwsens,		        // SIOCGIWSENS
-  (iw_handler) NULL,		        // SIOCSIWRANGE
-  (iw_handler) iwctl_giwrange,		// SIOCGIWRANGE
-  (iw_handler) NULL,			// SIOCSIWPRIV
-  (iw_handler) NULL,			// SIOCGIWPRIV
-  (iw_handler) NULL,			// SIOCSIWSTATS
-  (iw_handler) NULL,                  // SIOCGIWSTATS
-  (iw_handler) NULL,                  // SIOCSIWSPY
-  (iw_handler) NULL,		            // SIOCGIWSPY
-  (iw_handler) NULL,				    // -- hole --
-  (iw_handler) NULL,				    // -- hole --
-  (iw_handler) iwctl_siwap,		    // SIOCSIWAP
-  (iw_handler) iwctl_giwap,		    // SIOCGIWAP
-  (iw_handler) NULL,				    // -- hole -- 0x16
-  (iw_handler) iwctl_giwaplist,       // SIOCGIWAPLIST
-  (iw_handler) iwctl_siwscan,         // SIOCSIWSCAN
-  (iw_handler) iwctl_giwscan,         // SIOCGIWSCAN
-  (iw_handler) iwctl_siwessid,		// SIOCSIWESSID
-  (iw_handler) iwctl_giwessid,		// SIOCGIWESSID
-  (iw_handler) NULL,		// SIOCSIWNICKN
-  (iw_handler) NULL,		// SIOCGIWNICKN
-  (iw_handler) NULL,				    // -- hole --
-  (iw_handler) NULL,				    // -- hole --
-  (iw_handler) iwctl_siwrate,		// SIOCSIWRATE 0x20
-  (iw_handler) iwctl_giwrate,		// SIOCGIWRATE
-  (iw_handler) iwctl_siwrts,		// SIOCSIWRTS
-  (iw_handler) iwctl_giwrts,		// SIOCGIWRTS
-  (iw_handler) iwctl_siwfrag,		// SIOCSIWFRAG
-  (iw_handler) iwctl_giwfrag,		// SIOCGIWFRAG
-  (iw_handler) NULL,		// SIOCSIWTXPOW
-  (iw_handler) NULL,		// SIOCGIWTXPOW
-  (iw_handler) iwctl_siwretry,		// SIOCSIWRETRY
-  (iw_handler) iwctl_giwretry,		// SIOCGIWRETRY
-  (iw_handler) iwctl_siwencode,		// SIOCSIWENCODE
-  (iw_handler) iwctl_giwencode,		// SIOCGIWENCODE
-  (iw_handler) iwctl_siwpower,		// SIOCSIWPOWER
-  (iw_handler) iwctl_giwpower,		// SIOCGIWPOWER
-  (iw_handler) NULL,			// -- hole --
-  (iw_handler) NULL,			// -- hole --
-  (iw_handler) iwctl_siwgenie,    // SIOCSIWGENIE
-  (iw_handler) iwctl_giwgenie,    // SIOCGIWGENIE
-  (iw_handler) iwctl_siwauth,		// SIOCSIWAUTH
-  (iw_handler) iwctl_giwauth,		// SIOCGIWAUTH
-  (iw_handler) iwctl_siwencodeext,		// SIOCSIWENCODEEXT
-  (iw_handler) iwctl_giwencodeext,		// SIOCGIWENCODEEXT
-  (iw_handler) NULL,				// SIOCSIWPMKSA
-  (iw_handler) NULL,				// -- hole --
-
-  };
-*/
-
 static const iw_handler		iwctl_handler[] =
 {
 	(iw_handler) iwctl_commit,      // SIOCSIWCOMMIT
@@ -2129,13 +1887,9 @@ const struct iw_handler_def	iwctl_handler_def =
 {
 	.get_wireless_stats = &iwctl_get_wireless_stats,
 	.num_standard	= sizeof(iwctl_handler)/sizeof(iw_handler),
-//	.num_private	= sizeof(iwctl_private_handler)/sizeof(iw_handler),
-//	.num_private_args = sizeof(iwctl_private_args)/sizeof(struct iw_priv_args),
 	.num_private	= 0,
 	.num_private_args = 0,
 	.standard	= (iw_handler *)iwctl_handler,
-//	.private	= (iw_handler *) iwctl_private_handler,
-//	.private_args	= (struct iw_priv_args *)iwctl_private_args,
 	.private	= NULL,
 	.private_args	= NULL,
 };
diff --git a/drivers/staging/vt6655/key.c b/drivers/staging/vt6655/key.c
index 78b5809..54de7d0 100644
--- a/drivers/staging/vt6655/key.c
+++ b/drivers/staging/vt6655/key.c
@@ -46,7 +46,6 @@
 
 /*---------------------  Static Variables  --------------------------*/
 static int msglevel = MSG_LEVEL_INFO;
-//static int          msglevel                =MSG_LEVEL_DEBUG;
 /*---------------------  Static Functions  --------------------------*/
 
 /*---------------------  Export Variables  --------------------------*/
@@ -255,7 +254,6 @@ bool KeybSetKey(
 
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "KeybSetKey(R): \n");
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->bKeyValid: %d\n ", pKey->bKeyValid);
-			//DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->uKeyLength: %d\n ", pKey->uKeyLength);
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->abyKey: ");
 			for (ii = 0; ii < pKey->uKeyLength; ii++) {
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%02x ", pKey->abyKey[ii]);
@@ -786,10 +784,6 @@ bool KeybSetAllGroupKey(
 			}
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "\n");
 
-			//DBG_PRN_GRP12(("pKey->dwTSC47_16: %lX\n ", pKey->dwTSC47_16));
-			//DBG_PRN_GRP12(("pKey->wTSC15_0: %X\n ", pKey->wTSC15_0));
-			//DBG_PRN_GRP12(("pKey->dwKeyIndex: %lX\n ", pKey->dwKeyIndex));
-
 		} // (pTable->KeyTable[i].bInUse == true)
 	}
 	return true;
diff --git a/drivers/staging/vt6655/key.h b/drivers/staging/vt6655/key.h
index 356e6de..4b8b4b6 100644
--- a/drivers/staging/vt6655/key.h
+++ b/drivers/staging/vt6655/key.h
@@ -76,8 +76,6 @@ typedef struct tagSKeyTable
 	unsigned long dwGTKeyIndex;            // GroupTransmitKey Index
 	bool bInUse;
 	//2006-1116-01,<Modify> by NomadZhao
-	//unsigned short wKeyCtl;
-	//bool bSoftWEP;
 	bool bSoftWEP;
 	unsigned short wKeyCtl;      // for address of wKeyCtl at align 4
 
diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index 0ec079f..db53e1a 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -74,7 +74,6 @@
 
 unsigned short TxRate_iwconfig;//2008-5-8 <add> by chester
 /*---------------------  Static Definitions -------------------------*/
-//static int          msglevel                =MSG_LEVEL_DEBUG;
 static int msglevel = MSG_LEVEL_INFO;
 /*---------------------  Static Classes  ----------------------------*/
 
@@ -770,7 +769,6 @@ bool MACbSoftwareReset(unsigned long dwIoBase)
 	unsigned short ww;
 
 	// turn on HOSTCR_SOFTRST, just write 0x01 to reset
-	//MACvRegBitsOn(dwIoBase, MAC_REG_HOSTCR, HOSTCR_SOFTRST);
 	VNSvOutPortB(dwIoBase + MAC_REG_HOSTCR, 0x01);
 
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
@@ -809,7 +807,6 @@ bool MACbSafeSoftwareReset(unsigned long dwIoBase)
 	MACvSaveContext(dwIoBase, abyTmpRegData);
 	// do reset
 	bRetVal = MACbSoftwareReset(dwIoBase);
-	//BBvSoftwareReset(pDevice->PortOffset);
 	// restore MAC context, except CR0
 	MACvRestoreContext(dwIoBase, abyTmpRegData);
 
@@ -1022,11 +1019,6 @@ void MACvInitialize(unsigned long dwIoBase)
 	// disable force PME-enable
 	VNSvOutPortB(dwIoBase + MAC_REG_PMC1, PME_OVR);
 	// only 3253 A
-	/*
-	  MACvPwrEvntDisable(dwIoBase);
-	  // clear power status
-	  VNSvOutPortW(dwIoBase + MAC_REG_WAKEUPSR0, 0x0F0F);
-	*/
 
 	// do reset
 	MACbSoftwareReset(dwIoBase);
diff --git a/drivers/staging/vt6655/mac.h b/drivers/staging/vt6655/mac.h
index 4615db0..7333b8b 100644
--- a/drivers/staging/vt6655/mac.h
+++ b/drivers/staging/vt6655/mac.h
@@ -1042,7 +1042,6 @@ void MACvSetKeyEntry(unsigned long dwIoBase, unsigned short wKeyCtl, unsigned in
 void MACvDisableKeyEntry(unsigned long dwIoBase, unsigned int uEntryIdx);
 void MACvSetDefaultKeyEntry(unsigned long dwIoBase, unsigned int uKeyLen,
 			    unsigned int uKeyIdx, unsigned long *pdwKey, unsigned char byLocalID);
-//void MACvEnableDefaultKey(unsigned long dwIoBase, unsigned char byLocalID);
 void MACvDisableDefaultKey(unsigned long dwIoBase);
 void MACvSetDefaultTKIPKeyEntry(unsigned long dwIoBase, unsigned int uKeyLen,
 				unsigned int uKeyIdx, unsigned long *pdwKey, unsigned char byLocalID);
diff --git a/drivers/staging/vt6655/mib.c b/drivers/staging/vt6655/mib.c
index 6a59652..881c054 100644
--- a/drivers/staging/vt6655/mib.c
+++ b/drivers/staging/vt6655/mib.c
@@ -504,7 +504,6 @@ STAvUpdate802_11Counter(
 	unsigned long dwCounter
 )
 {
-	//p802_11Counter->TransmittedFragmentCount
 	p802_11Counter->MulticastTransmittedFrameCount = (unsigned long long) (pStatistic->dwTsrBroadcast[TYPE_AC0DMA] +
 									       pStatistic->dwTsrBroadcast[TYPE_TXDMA0] +
 									       pStatistic->dwTsrMulticast[TYPE_AC0DMA] +
@@ -513,12 +512,10 @@ STAvUpdate802_11Counter(
 	p802_11Counter->RetryCount = (unsigned long long) (pStatistic->dwTsrRetry[TYPE_AC0DMA] + pStatistic->dwTsrRetry[TYPE_TXDMA0]);
 	p802_11Counter->MultipleRetryCount = (unsigned long long) (pStatistic->dwTsrMoreThanOnceRetry[TYPE_AC0DMA] +
 								   pStatistic->dwTsrMoreThanOnceRetry[TYPE_TXDMA0]);
-	//p802_11Counter->FrameDuplicateCount
 	p802_11Counter->RTSSuccessCount += (unsigned long long)  (dwCounter & 0x000000ff);
 	p802_11Counter->RTSFailureCount += (unsigned long long) ((dwCounter & 0x0000ff00) >> 8);
 	p802_11Counter->ACKFailureCount += (unsigned long long) ((dwCounter & 0x00ff0000) >> 16);
 	p802_11Counter->FCSErrorCount +=   (unsigned long long) ((dwCounter & 0xff000000) >> 24);
-	//p802_11Counter->ReceivedFragmentCount
 	p802_11Counter->MulticastReceivedFrameCount = (unsigned long long) (pStatistic->dwRsrBroadcast +
 									    pStatistic->dwRsrMulticast);
 }
diff --git a/drivers/staging/vt6655/mib.h b/drivers/staging/vt6655/mib.h
index 6b99c11..c0a5948 100644
--- a/drivers/staging/vt6655/mib.h
+++ b/drivers/staging/vt6655/mib.h
@@ -61,10 +61,6 @@ typedef struct tagSDot11Counters {
 	unsigned long long   CCMPReplays;
 	unsigned long long   CCMPDecryptErrors;
 	unsigned long long   FourWayHandshakeFailures;
-//    unsigned long long   WEPUndecryptableCount;
-//    unsigned long long   WEPICVErrorCount;
-//    unsigned long long   DecryptSuccessCount;
-//    unsigned long long   DecryptFailureCount;
 } SDot11Counters, *PSDot11Counters;
 
 //
@@ -304,10 +300,6 @@ typedef struct tagSStatCounter {
 	unsigned long long   ullTxMulticastBytes[TYPE_MAXTD];
 	unsigned long long   ullTxDirectedBytes[TYPE_MAXTD];
 
-//    unsigned long dwTxRetryCount[8];
-	//
-	// ISR status count
-	//
 	SISRCounters ISRStat;
 
 	SCustomCounters CustomStat;
diff --git a/drivers/staging/vt6655/michael.c b/drivers/staging/vt6655/michael.c
index ade4c85..9486586 100644
--- a/drivers/staging/vt6655/michael.c
+++ b/drivers/staging/vt6655/michael.c
@@ -47,10 +47,7 @@
 /*---------------------  Static Variables  --------------------------*/
 
 /*---------------------  Static Functions  --------------------------*/
-/*
-  static unsigned long s_dwGetUINT32(unsigned char *p);         // Get unsigned long from 4 bytes LSByte first
-  static void s_vPutUINT32(unsigned char *p, unsigned long val); // Put unsigned long into 4 bytes LSByte first
-*/
+
 static void s_vClear(void);                       // Clear the internal message,
 // resets the object to the state just after construction.
 static void s_vSetKey(u32  dwK0, u32  dwK1);
@@ -65,30 +62,6 @@ static unsigned int nBytesInM;      // # bytes in M
 
 /*---------------------  Export Functions  --------------------------*/
 
-/*
-  static unsigned long s_dwGetUINT32 (unsigned char *p)
-// Convert from unsigned char [] to unsigned long in a portable way
-{
-unsigned long res = 0;
-unsigned int i;
-for (i=0; i<4; i++)
-{
-	res |= (*p++) << (8 * i);
-}
-return res;
-}
-
-static void s_vPutUINT32 (unsigned char *p, unsigned long val)
-// Convert from unsigned long to unsigned char [] in a portable way
-{
-	unsigned int i;
-	for (i=0; i<4; i++) {
-		*p++ = (unsigned char) (val & 0xff);
-		val >>= 8;
-	}
-}
-*/
-
 static void s_vClear(void)
 {
 	// Reset the state to the empty message.
diff --git a/drivers/staging/vt6655/power.c b/drivers/staging/vt6655/power.c
index 4bd1ccb..3864dd6 100644
--- a/drivers/staging/vt6655/power.c
+++ b/drivers/staging/vt6655/power.c
@@ -95,14 +95,12 @@ PSvEnablePowerSaving(
 	if (wListenInterval >= 2) {
 		// clear always listen beacon
 		MACvRegBitsOff(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_ALBCN);
-		//pDevice->wCFG &= ~CFG_ALB;
 		// first time set listen next beacon
 		MACvRegBitsOn(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_LNBCN);
 		pMgmt->wCountToWakeUp = wListenInterval;
 	} else {
 		// always listen beacon
 		MACvRegBitsOn(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_ALBCN);
-		//pDevice->wCFG |= CFG_ALB;
 		pMgmt->wCountToWakeUp = 0;
 	}
 
@@ -110,11 +108,8 @@ PSvEnablePowerSaving(
 	MACvRegBitsOn(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_PSEN);
 	pDevice->bEnablePSMode = true;
 
-	if (pDevice->eOPMode == OP_MODE_ADHOC) {
-//        bMgrPrepareBeaconToSend((void *)pDevice, pMgmt);
-	}
-	// We don't send null pkt in ad hoc mode since beacon will handle this.
-	else if (pDevice->eOPMode == OP_MODE_INFRASTRUCTURE) {
+	/* We don't send null pkt in ad hoc mode since beacon will handle this. */
+	if (pDevice->eOPMode != OP_MODE_ADHOC && pDevice->eOPMode == OP_MODE_INFRASTRUCTURE) {
 		PSbSendNullPacket(pDevice);
 	}
 	pDevice->bPWBitOn = true;
@@ -138,7 +133,6 @@ PSvDisablePowerSaving(
 )
 {
 	PSDevice        pDevice = (PSDevice)hDeviceContext;
-//    PSMgmtObject    pMgmt = pDevice->pMgmt;
 
 	// disable power saving hw function
 	MACbPSWakeup(pDevice->PortOffset);
@@ -258,8 +252,6 @@ PSvSendPSPOLL(
 	// send the frame
 	if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Send PS-Poll packet failed..\n");
-	} else {
-//        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Send PS-Poll packet success..\n");
 	}
 
 	return;
@@ -336,8 +328,6 @@ PSbSendNullPacket(
 	if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Send Null Packet failed !\n");
 		return false;
-	} else {
-//            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Send Null Packet success....\n");
 	}
 
 	return true;
diff --git a/drivers/staging/vt6655/power.h b/drivers/staging/vt6655/power.h
index 337dd65..ce56124 100644
--- a/drivers/staging/vt6655/power.h
+++ b/drivers/staging/vt6655/power.h
@@ -42,9 +42,6 @@
 
 /*---------------------  Export Functions  --------------------------*/
 
-// PSDevice pDevice
-// PSDevice hDeviceContext
-
 bool
 PSbConsiderPowerDown(
 	void *hDeviceContext,
diff --git a/drivers/staging/vt6655/rf.c b/drivers/staging/vt6655/rf.c
index edb1b27..b379f4f 100644
--- a/drivers/staging/vt6655/rf.c
+++ b/drivers/staging/vt6655/rf.c
@@ -39,8 +39,6 @@
 
 /*---------------------  Static Definitions -------------------------*/
 
-//static int          msglevel                =MSG_LEVEL_INFO;
-
 #define BY_AL2230_REG_LEN     23 //24bit
 #define CB_AL2230_INIT_SEQ    15
 #define SWITCH_CHANNEL_DELAY_AL2230 200 //us
@@ -183,7 +181,6 @@ static const unsigned long dwAL7230InitTable[CB_AL7230_INIT_SEQ] = {
 	0x841FF200+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW, // Need modify for 11a: 451FE2
 	0x3FDFA300+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW, // Need modify for 11a: 5FDFA3
 	0x7FD78400+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW, // 11b/g    // Need modify for 11a
-	//0x802B4500+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW, // Need modify for 11a: 8D1B45
 	// RoberYu:20050113, Rev0.47 Regsiter Setting Guide
 	0x802B5500+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW, // Need modify for 11a: 8D1B55
 	0x56AF3600+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW,
@@ -192,7 +189,6 @@ static const unsigned long dwAL7230InitTable[CB_AL7230_INIT_SEQ] = {
 	0x221BB900+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW,
 	0xE0000A00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW, // Need modify for 11a: E0600A
 	0x08031B00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW, // init 0x080B1B00 => 0x080F1B00 for 3 wire control TxGain(D10)
-	//0x00093C00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW, // Need modify for 11a: 00143C
 	// RoberYu:20050113, Rev0.47 Regsiter Setting Guide
 	0x000A3C00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW, // Need modify for 11a: 00143C
 	0xFFFFFD00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW,
@@ -585,10 +581,9 @@ bool IFRFbWriteEmbedded(unsigned long dwIoBase, unsigned long dwData)
 			break;
 	}
 
-	if (ww == W_MAX_TIMEOUT) {
-//        DBG_PORT80_ALWAYS(0x32);
+	if (ww == W_MAX_TIMEOUT)
 		return false;
-	}
+
 	return true;
 }
 
@@ -930,9 +925,6 @@ bool RFbSetPower(
 	case RATE_11M:
 		byPwr = pDevice->abyCCKPwrTbl[uCH];
 		byPwrdBm = pDevice->abyCCKDefaultPwr[uCH];
-//PLICE_DEBUG->
-		//byPwr+=5;
-//PLICE_DEBUG <-
 		break;
 	case RATE_6M:
 	case RATE_9M:
@@ -955,9 +947,6 @@ bool RFbSetPower(
 		}
 		byPwrdBm += pDevice->abyOFDMDefaultPwr[uCH];
 		byPwr = byDec;
-//PLICE_DEBUG->
-		//byPwr+=5;
-//PLICE_DEBUG<-
 		break;
 	case RATE_24M:
 	case RATE_36M:
@@ -965,9 +954,6 @@ bool RFbSetPower(
 	case RATE_54M:
 		byPwr = pDevice->abyOFDMPwrTbl[uCH];
 		byPwrdBm = pDevice->abyOFDMDefaultPwr[uCH];
-//PLICE_DEBUG->
-		//byPwr+=5;
-//PLICE_DEBUG<-
 		break;
 	}
 
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index c2653eb..e964245 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -68,7 +68,6 @@
 /*---------------------  Static Classes  ----------------------------*/
 
 /*---------------------  Static Variables  --------------------------*/
-//static int          msglevel                =MSG_LEVEL_DEBUG;
 static int msglevel = MSG_LEVEL_INFO;
 
 #define	PLICE_DEBUG
@@ -1093,9 +1092,7 @@ s_vGenerateTxParameter(
 	unsigned short wFifoCtl;
 	bool bDisCRC = false;
 	unsigned char byFBOption = AUTO_FB_NONE;
-//    unsigned short wCurrentRate = pDevice->wCurrentRate;
 
-	//DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "s_vGenerateTxParameter...\n");
 	PSTxBufHead pFifoHead = (PSTxBufHead)pTxBufHead;
 	pFifoHead->wReserved = wCurrentRate;
 	wFifoCtl = pFifoHead->wFIFOCtl;
@@ -1174,13 +1171,8 @@ s_vGenerateTxParameter(
 			}
 		}
 	}
-	//DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "s_vGenerateTxParameter END.\n");
 }
-/*
-  unsigned char *pbyBuffer,//point to pTxBufHead
-  unsigned short wFragType,//00:Non-Frag, 01:Start, 02:Mid, 03:Last
-  unsigned int cbFragmentSize,//Hdr+payoad+FCS
-*/
+
 static
 void
 s_vFillFragParameter(
@@ -1193,10 +1185,8 @@ s_vFillFragParameter(
 )
 {
 	PSTxBufHead pTxBufHead = (PSTxBufHead) pbyBuffer;
-	//DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "s_vFillFragParameter...\n");
 
 	if (uTxType == TYPE_SYNCDMA) {
-		//PSTxSyncDesc ptdCurr = (PSTxSyncDesc)s_pvGetTxDescHead(pDevice, uTxType, uCurIdx);
 		PSTxSyncDesc ptdCurr = (PSTxSyncDesc)pvtdCurr;
 
 		//Set FIFOCtl & TimeStamp in TxSyncDesc
@@ -1210,7 +1200,6 @@ s_vFillFragParameter(
 			ptdCurr->m_td1TD1.byTCR |= (TCR_STP | TCR_EDP);
 		}
 	} else {
-		//PSTxDesc ptdCurr = (PSTxDesc)s_pvGetTxDescHead(pDevice, uTxType, uCurIdx);
 		PSTxDesc ptdCurr = (PSTxDesc)pvtdCurr;
 		//Set TSR1 & ReqCount in TxDescHead
 		ptdCurr->m_td1TD1.wReqCount = cpu_to_le16((unsigned short)(cbReqCount));
@@ -1222,8 +1211,6 @@ s_vFillFragParameter(
 	}
 
 	pTxBufHead->wFragCtl |= (unsigned short)wFragType;//0x0001; //0000 0000 0000 0001
-
-	//DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "s_vFillFragParameter END\n");
 }
 
 static unsigned int
@@ -1245,8 +1232,6 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 	unsigned short wFragType; //00:Non-Frag, 01:Start, 10:Mid, 11:Last
 	unsigned int uDuration;
 	unsigned char *pbyBuffer;
-//    unsigned int uKeyEntryIdx = NUM_KEY_ENTRY+1;
-//    unsigned char byKeySel = 0xFF;
 	unsigned int cbIVlen = 0;
 	unsigned int cbICVlen = 0;
 	unsigned int cbMIClen = 0;
@@ -1254,8 +1239,6 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 	unsigned int cb802_1_H_len = 0;
 	unsigned int uLength = 0;
 	unsigned int uTmpLen = 0;
-//    unsigned char abyTmp[8];
-//    unsigned long dwCRC;
 	unsigned int cbMICHDR = 0;
 	u32 dwMICKey0, dwMICKey1;
 	u32 dwMIC_Priority;
@@ -1274,7 +1257,6 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 	unsigned char *pbyType;
 	PSTxDesc       ptdCurr;
 	PSTxBufHead    psTxBufHd = (PSTxBufHead) pbyTxBufferAddr;
-//    unsigned int tmpDescIdx;
 	unsigned int cbHeaderLength = 0;
 	void *pvRrvTime;
 	PSMICHDRHead   pMICHDR;
@@ -1289,7 +1271,6 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 
 	pvRrvTime = pMICHDR = pvRTS = pvCTS = pvTxDataHd = NULL;
 
-	//DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "s_cbFillTxBufHead...\n");
 	if ((pDevice->eOPMode == OP_MODE_ADHOC) ||
 	    (pDevice->eOPMode == OP_MODE_AP)) {
 		if (is_multicast_ether_addr(&(psEthHeader->abyDstAddr[0])))
@@ -1567,7 +1548,6 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 				//    Last Fragmentation
 				//=========================
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Last Fragmentation...\n");
-				//tmpDescIdx = (uDescIdx + uFragIdx) % pDevice->cbTD[uDMAIdx];
 
 				wFragType = FRAGCTL_ENDFRAG;
 
@@ -1600,7 +1580,6 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 				//---------------------------
 
 				pbyBuffer = (unsigned char *)pHeadTD->pTDInfo->buf;
-				//pbyBuffer = (unsigned char *)pDevice->aamTxBuf[uDMAIdx][tmpDescIdx].pbyVAddr;
 
 				uLength = cbHeaderLength + cbMACHdLen + uPadding + cbIVlen;
 
@@ -1644,12 +1623,6 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 								*(unsigned char *)((unsigned char *)&dwSafeMIC_R + uMICFragLen - 4),
 								(cbMIClen - uMICFragLen));
 						}
-						/*
-						  for (ii = 0; ii < cbLastFragPayloadSize + 8 + 24; ii++) {
-						  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%02x ", *((unsigned char *)((pbyBuffer + uLength) + ii - 8 - 24)));
-						  }
-						  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "\n\n");
-						*/
 					}
 					MIC_vUnInit();
 				} else {
@@ -1690,7 +1663,6 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 				//    Middle Fragmentation
 				//=========================
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Middle Fragmentation...\n");
-				//tmpDescIdx = (uDescIdx + uFragIdx) % pDevice->cbTD[uDMAIdx];
 
 				wFragType = FRAGCTL_MIDFRAG;
 
@@ -1753,21 +1725,9 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "MIDDLE: uMICFragLen:%d, cbFragPayloadSize:%d, uTmpLen:%d\n",
 							uMICFragLen, cbFragPayloadSize, uTmpLen);
 						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Fill MIC in Middle frag [%d]\n", uMICFragLen);
-						/*
-						  for (ii = 0; ii < uMICFragLen; ii++) {
-						  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%02x ", *((unsigned char *)((pbyBuffer + uLength + uTmpLen) + ii)));
-						  }
-						  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "\n");
-						*/
 						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Get MIC:%X, %X\n", *pdwMIC_L, *pdwMIC_R);
 					}
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Middle frag len: %d\n", uTmpLen);
-					/*
-					  for (ii = 0; ii < uTmpLen; ii++) {
-					  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%02x ", *((unsigned char *)((pbyBuffer + uLength) + ii)));
-					  }
-					  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "\n\n");
-					*/
 
 				} else {
 					ASSERT(uTmpLen == (cbFragPayloadSize));
@@ -1804,8 +1764,6 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 		//=========================
 		//    No Fragmentation
 		//=========================
-		//DBG_PRTGRP03(("No Fragmentation...\n"));
-		//DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "No Fragmentation...\n");
 		wFragType = FRAGCTL_NONFRAG;
 
 		//Set FragCtl in TxBufferHead
@@ -1864,12 +1822,6 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 
 		if ((bNeedEncrypt == true) && (pTransmitKey != NULL) && (pTransmitKey->byCipherSuite == KEY_CTL_TKIP)) {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Length:%d, %d\n", cbFrameBodySize - cb802_1_H_len, uLength);
-			/*
-			  for (ii = 0; ii < (cbFrameBodySize - cb802_1_H_len); ii++) {
-			  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%02x ", *((unsigned char *)((pbyBuffer + uLength) + ii)));
-			  }
-			  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "\n");
-			*/
 
 			MIC_vAppend((pbyBuffer + uLength - cb802_1_H_len), cbFrameBodySize);
 
@@ -1888,12 +1840,6 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "uLength: %d, %d\n", uLength, cbFrameBodySize);
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "cbReqCount:%d, %d, %d, %d\n", cbReqCount, cbHeaderLength, uPadding, cbIVlen);
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "MIC:%x, %x\n", *pdwMIC_L, *pdwMIC_R);
-/*
-  for (ii = 0; ii < 8; ii++) {
-  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%02x ", *(((unsigned char *)(pdwMIC_L) + ii)));
-  }
-  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "\n");
-*/
 
 		}
 
@@ -1917,12 +1863,9 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 
 		pDevice->iTDUsed[uDMAIdx]++;
 
-//   DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " ptdCurr->m_dwReserved0[%d] ptdCurr->m_dwReserved1[%d].\n", ptdCurr->pTDInfo->dwReqCount, ptdCurr->pTDInfo->dwHeaderLength);
-//   DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " cbHeaderLength[%d]\n", cbHeaderLength);
-
 	}
 	*puMACfragNum = uMACfragNum;
-	//DBG_PRTGRP03(("s_cbFillTxBufHead END\n"));
+
 	return cbHeaderLength;
 }
 
@@ -2031,10 +1974,6 @@ vGenerateFIFOHeader(PSDevice pDevice, unsigned char byPktType, unsigned char *pb
 #endif
 	pTxBufHead->byTxPower = pDevice->byCurPwr;
 
-/*
-  if (pDevice->bEnableHostWEP)
-  pTxBufHead->wFragCtl &=  ~(FRAGCTL_TKIP | FRAGCTL_LEGACY |FRAGCTL_AES);
-*/
 	*pcbHeaderSize = s_cbFillTxBufHead(pDevice, byPktType, pbyTxBufferAddr, cbPayloadSize,
 					   uDMAIdx, pHeadTD, psEthHeader, pPacket, bNeedEncrypt,
 					   pTransmitKey, uNodeIndex, puMACfragNum);
@@ -2075,7 +2014,7 @@ vGenerateMACHeader(
 {
 	PS802_11Header  pMACHeader = (PS802_11Header)pbyBufferAddr;
 
-	memset(pMACHeader, 0, (sizeof(S802_11Header)));  //- sizeof(pMACHeader->dwIV)));
+	memset(pMACHeader, 0, (sizeof(S802_11Header)));
 
 	if (uDMAIdx == TYPE_ATIMDMA) {
 		pMACHeader->wFrameCtl = TYPE_802_11_ATIM;
@@ -2247,8 +2186,6 @@ CMD_STATUS csMgmt_xmit(PSDevice pDevice, PSTxMgmtPacket pPacket) {
 			cbICVlen = 4;
 			pTxBufHead->wFragCtl |= FRAGCTL_TKIP;
 			//We need to get seed here for filling TxKey entry.
-			//TKIPvMixKey(pTransmitKey->abyKey, pDevice->abyCurrentNetAddr,
-			//            pTransmitKey->wTSC15_0, pTransmitKey->dwTSC47_16, pDevice->abyPRNG);
 		} else if (pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled) {
 			cbIVlen = 8;//RSN Header
 			cbICVlen = 8;//MIC
@@ -2613,7 +2550,6 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, unsigned char *pbMPDU, un
 	unsigned char *pbyMacHdr;
 
 	unsigned int cbExtSuppRate = 0;
-//    PWLAN_IE        pItem;
 
 	pvRrvTime = pMICHDR = pvRTS = pvCTS = pvTxDataHd = NULL;
 
@@ -2736,8 +2672,6 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, unsigned char *pbMPDU, un
 			cbICVlen = 4;
 			pTxBufHead->wFragCtl |= FRAGCTL_TKIP;
 			//We need to get seed here for filling TxKey entry.
-			//TKIPvMixKey(pTransmitKey->abyKey, pDevice->abyCurrentNetAddr,
-			//            pTransmitKey->wTSC15_0, pTransmitKey->dwTSC47_16, pDevice->abyPRNG);
 		} else if (pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled) {
 			cbIVlen = 8;//RSN Header
 			cbICVlen = 8;//MIC
diff --git a/drivers/staging/vt6655/rxtx.h b/drivers/staging/vt6655/rxtx.h
index 4f2cf34..601bedb 100644
--- a/drivers/staging/vt6655/rxtx.h
+++ b/drivers/staging/vt6655/rxtx.h
@@ -39,17 +39,6 @@
 
 /*---------------------  Export Functions  --------------------------*/
 
-/*
-  void
-  vGenerateMACHeader(PSDevice pDevice, unsigned long dwTxBufferAddr, unsigned char *pbySkbData,
-  unsigned int cbPacketSize, bool bDMA0Used, unsigned int *pcbHeadSize,
-  unsigned int *pcbAppendPayload);
-
-  void
-  vProcessRxMACHeader(PSDevice pDevice, unsigned long dwRxBufferAddr, unsigned int cbPacketSize,
-  bool bIsWEP, unsigned int *pcbHeadSize);
-*/
-
 void
 vGenerateMACHeader(
 	PSDevice         pDevice,
diff --git a/drivers/staging/vt6655/tkip.c b/drivers/staging/vt6655/tkip.c
index e7c17c6..078b359 100644
--- a/drivers/staging/vt6655/tkip.c
+++ b/drivers/staging/vt6655/tkip.c
@@ -189,7 +189,6 @@ void TKIPvMixKey(
 )
 {
 	unsigned int p1k[5];
-//    unsigned int ttak0, ttak1, ttak2, ttak3, ttak4;
 	unsigned int tsc0, tsc1, tsc2;
 	unsigned int ppk0, ppk1, ppk2, ppk3, ppk4, ppk5;
 	unsigned long int pnl, pnh;
diff --git a/drivers/staging/vt6655/vntwifi.c b/drivers/staging/vt6655/vntwifi.c
index e78aedf..e6734e3 100644
--- a/drivers/staging/vt6655/vntwifi.c
+++ b/drivers/staging/vt6655/vntwifi.c
@@ -39,8 +39,6 @@
 #include "datarate.h"
 
 /*---------------------  Static Definitions -------------------------*/
-//static int          msglevel                =MSG_LEVEL_DEBUG;
-//static int          msglevel                =MSG_LEVEL_INFO;
 
 /*---------------------  Static Classes  ----------------------------*/
 
@@ -591,46 +589,6 @@ VNTWIFIbyGetKeyCypher(
 	}
 }
 
-/*
-  bool
-  VNTWIFIbInit(
-  void *pAdapterHandler,
-  void **pMgmtHandler
-) {
-  PSMgmtObject        pMgmt = NULL;
-  unsigned int ii;
-
-  pMgmt = (PSMgmtObject)kmalloc(sizeof(SMgmtObject), (int)GFP_ATOMIC);
-  if (pMgmt == NULL) {
-  *pMgmtHandler = NULL;
-  return false;
-  }
-
-  memset(pMgmt, 0, sizeof(SMgmtObject));
-  pMgmt->pAdapter = (void *) pAdapterHandler;
-
-  // should initial MAC address abyMACAddr
-  for (ii=0; ii<WLAN_BSSID_LEN; ii++) {
-  pMgmt->abyDesireBSSID[ii] = 0xFF;
-  }
-  pMgmt->pbyPSPacketPool = &pMgmt->byPSPacketPool[0];
-  pMgmt->pbyMgmtPacketPool = &pMgmt->byMgmtPacketPool[0];
-  pMgmt->byCSSPK = KEY_CTL_NONE;
-  pMgmt->byCSSGK = KEY_CTL_NONE;
-  pMgmt->wIBSSBeaconPeriod = DEFAULT_IBSS_BI;
-
-  pMgmt->cbFreeCmdQueue = CMD_Q_SIZE;
-  pMgmt->uCmdDequeueIdx = 0;
-  pMgmt->uCmdEnqueueIdx = 0;
-  pMgmt->eCommandState = WLAN_CMD_STATE_IDLE;
-  pMgmt->bCmdStop = false;
-  pMgmt->bCmdRunning = false;
-
-  *pMgmtHandler = pMgmt;
-  return true;
-  }
-*/
-
 bool
 VNTWIFIbSetPMKIDCache(
 	void *pMgmtObject,
@@ -693,7 +651,6 @@ VNTWIFIbMeasureReport(
 	PSMgmtObject    pMgmt = (PSMgmtObject) pMgmtObject;
 	unsigned char *pbyCurrentEID = (unsigned char *)(pMgmt->pCurrMeasureEIDRep);
 
-	//spin_lock_irq(&pDevice->lock);
 	if ((pvMeasureEID != NULL) &&
 	    (pMgmt->uLengthOfRepEIDs < (WLAN_A3FR_MAXLEN - sizeof(MEASEURE_REP) - sizeof(WLAN_80211HDR_A3) - 3))
 ) {
@@ -731,10 +688,9 @@ VNTWIFIbMeasureReport(
 		pMgmt->uLengthOfRepEIDs += (2 + pMgmt->pCurrMeasureEIDRep->len);
 		pMgmt->pCurrMeasureEIDRep = (PWLAN_IE_MEASURE_REP) pbyCurrentEID;
 	}
-	if (bEndOfReport) {
+	if (bEndOfReport)
 		IEEE11hbMSRRepTx(pMgmt);
-	}
-	//spin_unlock_irq(&pDevice->lock);
+
 	return true;
 }
 
@@ -746,9 +702,7 @@ VNTWIFIbChannelSwitch(
 {
 	PSMgmtObject    pMgmt = (PSMgmtObject) pMgmtObject;
 
-	//spin_lock_irq(&pDevice->lock);
 	pMgmt->uCurrChannel = byNewChannel;
 	pMgmt->bSwitchChannel = false;
-	//spin_unlock_irq(&pDevice->lock);
 	return true;
 }
diff --git a/drivers/staging/vt6655/vntwifi.h b/drivers/staging/vt6655/vntwifi.h
index 4b01ebd..880b8ab 100644
--- a/drivers/staging/vt6655/vntwifi.h
+++ b/drivers/staging/vt6655/vntwifi.h
@@ -222,13 +222,6 @@ VNTWIFIvGetTxRate(
 	unsigned char *pbyCCKBasicRate,
 	unsigned char *pbyOFDMBasicRate
 );
-/*
-  bool
-  VNTWIFIbInit(
-  void *pAdapterHandler,
-  void **pMgmtHandler
-);
-*/
 
 unsigned char
 VNTWIFIbyGetKeyCypher(
@@ -276,12 +269,5 @@ VNTWIFIbChannelSwitch(
 	void *pMgmtObject,
 	unsigned char byNewChannel
 );
-/*
-  bool
-  VNTWIFIbRadarPresent(
-  void *pMgmtObject,
-  unsigned char byChannel
-);
-*/
 
 #endif //__VNTWIFI_H__
diff --git a/drivers/staging/vt6655/wcmd.c b/drivers/staging/vt6655/wcmd.c
index 72caaa2..83b595c 100644
--- a/drivers/staging/vt6655/wcmd.c
+++ b/drivers/staging/vt6655/wcmd.c
@@ -60,7 +60,6 @@
 
 /*---------------------  Static Variables  --------------------------*/
 static int msglevel = MSG_LEVEL_INFO;
-//static int          msglevel                =MSG_LEVEL_DEBUG;
 /*---------------------  Static Functions  --------------------------*/
 
 static
@@ -377,7 +376,6 @@ vCommandTimer(
 				return;
 			}
 			if (pMgmt->uScanChannel == pDevice->byMinChannel) {
-				//pMgmt->eScanType = WMAC_SCAN_ACTIVE;
 				pMgmt->abyScanBSSID[0] = 0xFF;
 				pMgmt->abyScanBSSID[1] = 0xFF;
 				pMgmt->abyScanBSSID[2] = 0xFF;
@@ -385,8 +383,6 @@ vCommandTimer(
 				pMgmt->abyScanBSSID[4] = 0xFF;
 				pMgmt->abyScanBSSID[5] = 0xFF;
 				pItemSSID->byElementID = WLAN_EID_SSID;
-				// clear bssid list
-				// BSSvClearBSSList((void *)pDevice, pDevice->bLinkPass);
 				pMgmt->eScanState = WMAC_IS_SCANNING;
 
 			}
@@ -468,7 +464,6 @@ vCommandTimer(
 			memset(pItemSSID->abySSID, 0, WLAN_SSID_MAXLEN);
 			pMgmt->eCurrState = WMAC_STATE_IDLE;
 			pMgmt->sNodeDBTable[0].bActive = false;
-//                pDevice->bBeaconBufReady = false;
 		}
 		netif_stop_queue(pDevice->dev);
 		pDevice->eCommandState = WLAN_DISASSOCIATE_WAIT;
@@ -480,7 +475,6 @@ vCommandTimer(
 		}
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " CARDbRadioPowerOff\n");
 		//2008-09-02  <mark>	by chester
-		// CARDbRadioPowerOff(pDevice);
 		s_bCommandComplete(pDevice);
 		break;
 
@@ -492,7 +486,6 @@ vCommandTimer(
 			return;
 		}
 //2008-09-02  <mark> by chester
-		// CARDbRadioPowerOff(pDevice);
 		s_bCommandComplete(pDevice);
 		break;
 
@@ -504,8 +497,6 @@ vCommandTimer(
 			return;
 		}
 		printk("chester-abyDesireSSID=%s\n", ((PWLAN_IE_SSID)pMgmt->abyDesireSSID)->abySSID);
-		//memcpy(pMgmt->abyAdHocSSID,pMgmt->abyDesireSSID,
-		//((PWLAN_IE_SSID)pMgmt->abyDesireSSID)->len + WLAN_IEHDR_LEN);
 		pItemSSID = (PWLAN_IE_SSID)pMgmt->abyDesireSSID;
 		pItemSSIDCurr = (PWLAN_IE_SSID)pMgmt->abyCurrSSID;
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " cmd: desire ssid = %s\n", pItemSSID->abySSID);
@@ -785,7 +776,6 @@ vCommandTimer(
 		break;
 
 	case WLAN_CMD_CHECK_BBSENSITIVITY_CHANGE:
-		//DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "eCommandState == WLAN_CMD_CHECK_BBSENSITIVITY_START\n");
 		// wait all TD complete
 		if (pDevice->iTDUsed[TYPE_AC0DMA] != 0) {
 			vCommandTimerWait((void *)pDevice, 10);
@@ -820,7 +810,6 @@ s_bCommandComplete(
 {
 	PWLAN_IE_SSID pSSID;
 	bool bRadioCmd = false;
-	//unsigned short wDeAuthenReason = 0;
 	bool bForceSCAN = true;
 	PSMgmtObject  pMgmt = pDevice->pMgmt;
 
@@ -842,19 +831,10 @@ s_bCommandComplete(
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
-/*
-  if ((bForceSCAN == false) && (pDevice->bLinkPass == true)) {
-  if ((pSSID->len == ((PWLAN_IE_SSID)pMgmt->abyCurrSSID)->len) &&
-  (!memcmp(pSSID->abySSID, ((PWLAN_IE_SSID)pMgmt->abyCurrSSID)->abySSID, pSSID->len))) {
-  pDevice->eCommandState = WLAN_CMD_IDLE;
-  }
-  }
-*/
 			break;
 		case WLAN_CMD_SSID:
 			pDevice->eCommandState = WLAN_CMD_SSID_START;
@@ -923,11 +903,6 @@ bool bScheduleCommand(
 		case WLAN_CMD_DISASSOCIATE:
 			pDevice->eCmdQueue[pDevice->uCmdEnqueueIdx].bNeedRadioOFF = *((int *)pbyItem0);
 			break;
-/*
-  case WLAN_CMD_DEAUTH:
-  pDevice->eCmdQueue[pDevice->uCmdEnqueueIdx].wDeAuthenReason = *((unsigned short *)pbyItem0);
-  break;
-*/
 
 		case WLAN_CMD_RX_PSPOLL:
 			break;
diff --git a/drivers/staging/vt6655/wctl.c b/drivers/staging/vt6655/wctl.c
index 950039f..0ae57f1 100644
--- a/drivers/staging/vt6655/wctl.c
+++ b/drivers/staging/vt6655/wctl.c
@@ -43,7 +43,7 @@
 /*---------------------  Static Classes  ----------------------------*/
 
 /*---------------------  Static Variables  --------------------------*/
-// static int          msglevel                =MSG_LEVEL_INFO;
+
 /*---------------------  Static Functions  --------------------------*/
 
 /*---------------------  Export Variables  --------------------------*/
@@ -113,7 +113,6 @@ unsigned int WCTLuSearchDFCB(PSDevice pDevice, PS802_11Header pMACHeader)
 		if (pDevice->sRxDFCB[ii].bInUse &&
 		    ether_addr_equal(pDevice->sRxDFCB[ii].abyAddr2,
 				     pMACHeader->abyAddr2)) {
-			//
 			return ii;
 		}
 	}
@@ -202,7 +201,6 @@ bool WCTLbHandleFragment(PSDevice pDevice, PS802_11Header pMACHeader, unsigned i
 		pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].cbFrameLength = cbFrameLength;
 		pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].pbyRxBuffer += cbFrameLength;
 		pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].wFragNum++;
-		//DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "First pDevice->uCurrentDFCBIdx= %d\n", pDevice->uCurrentDFCBIdx);
 		return false;
 	} else {
 		pDevice->uCurrentDFCBIdx = WCTLuSearchDFCB(pDevice, pMACHeader);
@@ -214,7 +212,6 @@ bool WCTLbHandleFragment(PSDevice pDevice, PS802_11Header pMACHeader, unsigned i
 				pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].cbFrameLength += (cbFrameLength - uHeaderSize);
 				pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].pbyRxBuffer += (cbFrameLength - uHeaderSize);
 				pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].wFragNum++;
-				//DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Second pDevice->uCurrentDFCBIdx= %d\n", pDevice->uCurrentDFCBIdx);
 			} else {
 				// seq error or frag # error flush DFCB
 				pDevice->cbFreeDFCB++;
@@ -228,7 +225,6 @@ bool WCTLbHandleFragment(PSDevice pDevice, PS802_11Header pMACHeader, unsigned i
 			//enq defragcontrolblock
 			pDevice->cbFreeDFCB++;
 			pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].bInUse = false;
-			//DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Last pDevice->uCurrentDFCBIdx= %d\n", pDevice->uCurrentDFCBIdx);
 			return true;
 		}
 		return false;
diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index b673bc9..7945094 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -88,7 +88,6 @@
 
 /*---------------------  Static Variables  --------------------------*/
 static int msglevel = MSG_LEVEL_INFO;
-//static int          msglevel                =MSG_LEVEL_DEBUG;
 
 /*---------------------  Static Functions  --------------------------*/
 //2008-8-4 <add> by chester
@@ -355,7 +354,6 @@ vMgrObjectInit(
 		pMgmt->abyDesireBSSID[ii] = 0xFF;
 	}
 	pMgmt->sAssocInfo.AssocInfo.Length = sizeof(NDIS_802_11_ASSOCIATION_INFORMATION);
-	//memset(pMgmt->abyDesireSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN +1);
 	pMgmt->byCSSPK = KEY_CTL_NONE;
 	pMgmt->byCSSGK = KEY_CTL_NONE;
 	pMgmt->wIBSSBeaconPeriod = DEFAULT_IBSS_BI;
@@ -1384,11 +1382,6 @@ s_vMgrRxAuthenSequence_2(
 			s_vMgrLogStatus(pMgmt, cpu_to_le16((*(pFrame->pwStatus))));
 			pMgmt->eCurrState = WMAC_STATE_IDLE;
 		}
-		if (pDevice->eCommandState == WLAN_AUTHENTICATE_WAIT) {
-//                spin_unlock_irq(&pDevice->lock);
-//                vCommandTimerWait((void *)pDevice, 0);
-//                spin_lock_irq(&pDevice->lock);
-		}
 
 		break;
 
@@ -1430,11 +1423,6 @@ s_vMgrRxAuthenSequence_2(
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Auth_reply sequence_2 tx ...\n");
 		} else {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:rx Auth_reply sequence_2 status error ...\n");
-			if (pDevice->eCommandState == WLAN_AUTHENTICATE_WAIT) {
-//                    spin_unlock_irq(&pDevice->lock);
-//                    vCommandTimerWait((void *)pDevice, 0);
-//                    spin_lock_irq(&pDevice->lock);
-			}
 			s_vMgrLogStatus(pMgmt, cpu_to_le16((*(pFrame->pwStatus))));
 		}
 		break;
@@ -1559,12 +1547,6 @@ s_vMgrRxAuthenSequence_4(
 		s_vMgrLogStatus(pMgmt, cpu_to_le16((*(pFrame->pwStatus))));
 		pMgmt->eCurrState = WMAC_STATE_IDLE;
 	}
-
-	if (pDevice->eCommandState == WLAN_AUTHENTICATE_WAIT) {
-//        spin_unlock_irq(&pDevice->lock);
-//        vCommandTimerWait((void *)pDevice, 0);
-//        spin_lock_irq(&pDevice->lock);
-	}
 }
 
 /*+
@@ -1588,7 +1570,6 @@ s_vMgrRxDisassociation(
 {
 	WLAN_FR_DISASSOC    sFrame;
 	unsigned int uNodeIndex = 0;
-//    CMD_STATUS          CmdStatus;
 	viawget_wpa_header *wpahdr;
 
 	if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
@@ -1871,7 +1852,6 @@ s_vMgrRxBeacon(
 				    (void *)pRxPacket
 );
 	} else {
-//        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "update bcn: RxChannel = : %d\n", byCurrChannel);
 		BSSbUpdateToBSSList((void *)pDevice,
 				    *sFrame.pqwTimestamp,
 				    *sFrame.pwBeaconInterval,
@@ -1942,10 +1922,8 @@ s_vMgrRxBeacon(
 		pDevice->uCurrRSSI = pRxPacket->uRSSI;
 		pDevice->byCurrSQ = pRxPacket->bySQ;
 
-		if (pMgmt->sNodeDBTable[0].uInActiveCount != 0) {
+		if (pMgmt->sNodeDBTable[0].uInActiveCount != 0)
 			pMgmt->sNodeDBTable[0].uInActiveCount = 0;
-			//DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BCN:Wake Count= [%d]\n", pMgmt->wCountToWakeUp);
-		}
 	}
 	// check if SSID the same
 	if (sFrame.pSSID->len == ((PWLAN_IE_SSID)pMgmt->abyCurrSSID)->len) {
@@ -2101,11 +2079,9 @@ s_vMgrRxBeacon(
 			    (pMgmt->bMulticastTIM && (pMgmt->byDTIMCount == 0))) {
 				pMgmt->bInTIMWake = true;
 				// send out ps-poll packet
-//                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BCN:In TIM\n");
-				if (pMgmt->bInTIM) {
+
+				if (pMgmt->bInTIM)
 					PSvSendPSPOLL((PSDevice)pDevice);
-//                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BCN:PS-POLL sent..\n");
-				}
 
 			} else {
 				pMgmt->bInTIMWake = false;
@@ -2181,11 +2157,6 @@ s_vMgrRxBeacon(
 					printk("s_vMgrRxBeacon:TxDataRate is %d,Index is %d\n", pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate, uNodeIndex);
 				}
 #endif
-/*
-  pMgmt->sNodeDBTable[uNodeIndex].bShortSlotTime = WLAN_GET_CAP_INFO_SHORTSLOTTIME(*sFrame.pwCapInfo);
-  if (pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate > RATE_11M)
-  pMgmt->sNodeDBTable[uNodeIndex].bERPExist = true;
-*/
 			}
 
 			// if other stations joined, indicate connection to upper layer..
@@ -2230,12 +2201,8 @@ s_vMgrRxBeacon(
 						     pMgmt->abyCurrSuppRates,
 						     pMgmt->abyCurrExtSuppRates);
 
-				// MACvRegBitsOff(pDevice->PortOffset, MAC_REG_RCR, RCR_BSSID);
-				// set highest basic rate
-				// s_vSetHighestBasicRate(pDevice, (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates);
 				// Prepare beacon frame
 				bMgrPrepareBeaconToSend((void *)pDevice, pMgmt);
-				//  }
 			}
 		}
 	}
@@ -2383,8 +2350,6 @@ vMgrCreateOwnIBSS(
 	MACvWriteATIMW(pDevice->PortOffset, pMgmt->wCurrATIMWindow);
 	pDevice->uCurrRSSI = 0;
 	pDevice->byCurrSQ = 0;
-	//memcpy(pMgmt->abyDesireSSID,pMgmt->abyAdHocSSID,
-	// ((PWLAN_IE_SSID)pMgmt->abyAdHocSSID)->len + WLAN_IEHDR_LEN);
 	memset(pMgmt->abyCurrSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
 	memcpy(pMgmt->abyCurrSSID,
 	       pMgmt->abyDesireSSID,
@@ -2453,13 +2418,10 @@ vMgrCreateOwnIBSS(
 
 	pMgmt->byERPContext = 0;
 
-//    memcpy(pDevice->abyBSSID, pMgmt->abyCurrBSSID, WLAN_BSSID_LEN);
-
-	if (pMgmt->eConfigMode == WMAC_CONFIG_AP) {
+	if (pMgmt->eConfigMode == WMAC_CONFIG_AP)
 		CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, OP_MODE_AP);
-	} else {
+	else
 		CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, OP_MODE_ADHOC);
-	}
 
 	CARDbSetPhyParameter(pMgmt->pAdapter,
 			     pMgmt->eCurrentPHYMode,
@@ -2540,7 +2502,6 @@ vMgrJoinBSSBegin(
 		return;
 	}
 
-	// memset(pMgmt->abyDesireBSSID, 0,  WLAN_BSSID_LEN);
 	// Search known BSS list for prefer BSSID or SSID
 
 	pCurr = BSSpSearchBSSList(pDevice,
@@ -2560,23 +2521,6 @@ vMgrJoinBSSBegin(
 	if (WLAN_GET_CAP_INFO_ESS(cpu_to_le16(pCurr->wCapInfo))) {
 		if ((pMgmt->eAuthenMode == WMAC_AUTH_WPA) || (pMgmt->eAuthenMode == WMAC_AUTH_WPAPSK)) {
 			// patch for CISCO migration mode
-/*
-  if (pDevice->eEncryptionStatus == Ndis802_11Encryption2Enabled) {
-  if (WPA_SearchRSN(0, WPA_TKIP, pCurr) == false) {
-  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "No match RSN info. ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n");
-  // encryption mode error
-  pMgmt->eCurrState = WMAC_STATE_IDLE;
-  return;
-  }
-  } else if (pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled) {
-  if (WPA_SearchRSN(0, WPA_AESCCMP, pCurr) == false) {
-  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "No match RSN info. ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n");
-  // encryption mode error
-  pMgmt->eCurrState = WMAC_STATE_IDLE;
-  return;
-  }
-  }
-*/
 		}
 
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
@@ -2647,9 +2591,6 @@ vMgrJoinBSSBegin(
 			pMgmt->eCurrMode = WMAC_MODE_ESS_STA;
 
 			pMgmt->eCurrState = WMAC_STATE_JOINTED;
-			// Adopt BSS state in Adapter Device Object
-			//pDevice->byOpMode = OP_MODE_INFRASTRUCTURE;
-//            memcpy(pDevice->abyBSSID, pCurr->abyBSSID, WLAN_BSSID_LEN);
 
 			// Add current BSS to Candidate list
 			// This should only works for WPA2 BSS, and WPA2 BSS check must be done before.
@@ -2721,15 +2662,10 @@ vMgrJoinBSSBegin(
 			memset(pMgmt->abyCurrSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN);
 			memcpy(pMgmt->abyCurrBSSID, pCurr->abyBSSID, WLAN_BSSID_LEN);
 			memcpy(pMgmt->abyCurrSSID, pCurr->abySSID, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN);
-//          pMgmt->wCurrATIMWindow = pCurr->wATIMWindow;
 			MACvWriteATIMW(pDevice->PortOffset, pMgmt->wCurrATIMWindow);
 			pMgmt->eCurrMode = WMAC_MODE_IBSS_STA;
 
 			pMgmt->eCurrState = WMAC_STATE_STARTED;
-			// Adopt BSS state in Adapter Device Object
-			//pDevice->byOpMode = OP_MODE_ADHOC;
-//            pDevice->bLinkPass = true;
-//            memcpy(pDevice->abyBSSID, pCurr->abyBSSID, WLAN_BSSID_LEN);
 
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Join IBSS ok:%pM\n",
 				pMgmt->abyCurrBSSID);
@@ -2766,7 +2702,7 @@ s_vMgrSynchBSS(
 {
 	CARD_PHY_TYPE   ePhyType = PHY_TYPE_11B;
 	PSMgmtObject  pMgmt = pDevice->pMgmt;
-//    int     ii;
+
 	//1M,   2M,   5M,   11M,  18M,  24M,  36M,  54M
 	unsigned char abyCurrSuppRatesG[] = {WLAN_EID_SUPP_RATES, 8, 0x02, 0x04, 0x0B, 0x16, 0x24, 0x30, 0x48, 0x6C};
 	unsigned char abyCurrExtSuppRatesG[] = {WLAN_EID_EXTSUPP_RATES, 4, 0x0C, 0x12, 0x18, 0x60};
@@ -2884,24 +2820,6 @@ s_vMgrSynchBSS(
 		return;
 	}
 
-/*
-  for (ii=0; ii<BB_VGA_LEVEL; ii++) {
-  if (pCurr->ldBmMAX< pDevice->ldBmThreshold[ii]) {
-  pDevice->byBBVGANew = pDevice->abyBBVGA[ii];
-  break;
-  }
-  }
-
-  if (pDevice->byBBVGANew != pDevice->byBBVGACurrent) {
-  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "RSSI[%d] NewGain[%d] OldGain[%d] \n",
-  (int)pCurr->ldBmMAX, pDevice->byBBVGANew, pDevice->byBBVGACurrent);
-  printk("RSSI[%d] NewGain[%d] OldGain[%d] \n",
-  (int)pCurr->ldBmMAX, pDevice->byBBVGANew, pDevice->byBBVGACurrent);
-  BBvSetVGAGainOffset(pDevice, pDevice->byBBVGANew);
-  }
-  printk("ldBmMAX[%d] NewGain[%d] OldGain[%d] \n",
-  (int)pCurr->ldBmMAX, pDevice->byBBVGANew, pDevice->byBBVGACurrent);
-*/
 	pMgmt->uCurrChannel = pCurr->uChannel;
 	pMgmt->eCurrentPHYMode = ePhyType;
 	pMgmt->byERPContext = pCurr->sERP.byERP;
@@ -2943,7 +2861,7 @@ static void  Encyption_Rebuild(
 			}
 		}
 	}
-	//  }
+
 	return;
 }
 
@@ -4228,10 +4146,7 @@ s_vMgrRxProbeRequest(
 		sFrame.len = pRxPacket->cbMPDULen;
 		sFrame.pBuf = (unsigned char *)pRxPacket->p80211Header;
 		vMgrDecodeProbeRequest(&sFrame);
-/*
-  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Probe request rx:MAC addr:%pM\n",
-  sFrame.pHdr->sA3.abyAddr2);
-*/
+
 		if (sFrame.pSSID->len != 0) {
 			if (sFrame.pSSID->len != ((PWLAN_IE_SSID)pMgmt->abyCurrSSID)->len)
 				return;
@@ -4265,11 +4180,8 @@ s_vMgrRxProbeRequest(
 		if (pTxPacket != NULL) {
 			/* send the frame */
 			Status = csMgmt_xmit(pDevice, pTxPacket);
-			if (Status != CMD_STATUS_PENDING) {
+			if (Status != CMD_STATUS_PENDING)
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Probe response tx failed\n");
-			} else {
-//                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Probe response tx sending..\n");
-			}
 		}
 	}
 
@@ -4361,7 +4273,6 @@ vMgrRxManagePacket(
 
 	case WLAN_FSTYPE_PROBEREQ:
 		// Frame Clase = 0
-		//DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx probereq\n");
 		s_vMgrRxProbeRequest(pDevice, pMgmt, pRxPacket);
 		break;
 
@@ -4374,8 +4285,12 @@ vMgrRxManagePacket(
 
 	case WLAN_FSTYPE_BEACON:
 		// Frame Clase = 0
+<<<<<<< HEAD
 		//DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx beacon\n");
 		if (pMgmt->eScanState != WMAC_NO_SCANNING) {
+=======
+		if (pMgmt->eScanState != WMAC_NO_SCANNING)
+>>>>>>> f3c59ed... staging: vt6655: remove dead code
 			bInScan = true;
 		}
 		s_vMgrRxBeacon(pDevice, pMgmt, pRxPacket, bInScan);
@@ -4442,8 +4357,12 @@ bMgrPrepareBeaconToSend(
 	PSDevice            pDevice = (PSDevice)hDeviceContext;
 	PSTxMgmtPacket      pTxPacket;
 
+<<<<<<< HEAD
 //    pDevice->bBeaconBufReady = false;
 	if (pDevice->bEncryptionEnable || pDevice->bEnable8021x) {
+=======
+	if (pDevice->bEncryptionEnable || pDevice->bEnable8021x)
+>>>>>>> f3c59ed... staging: vt6655: remove dead code
 		pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_PRIVACY(1);
 	} else {
 		pMgmt->wCurrCapInfo &= ~WLAN_SET_CAP_INFO_PRIVACY(1);
@@ -4455,7 +4374,7 @@ bMgrPrepareBeaconToSend(
 			pMgmt->wCurrCapInfo,
 			pMgmt->wCurrBeaconPeriod,
 			pMgmt->uCurrChannel,
-			pMgmt->wCurrATIMWindow, //0,
+			pMgmt->wCurrATIMWindow,
 			(PWLAN_IE_SSID)pMgmt->abyCurrSSID,
 			(unsigned char *)pMgmt->abyCurrBSSID,
 			(PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
diff --git a/drivers/staging/vt6655/wmgr.h b/drivers/staging/vt6655/wmgr.h
index b91f1f8..2312d71 100644
--- a/drivers/staging/vt6655/wmgr.h
+++ b/drivers/staging/vt6655/wmgr.h
@@ -119,32 +119,6 @@ typedef struct tagSAssocInfo {
 } SAssocInfo, *PSAssocInfo;
 //---
 
-/*
-  typedef enum tagWMAC_AUTHENTICATION_MODE {
-  WMAC_AUTH_OPEN,
-  WMAC_AUTH_SHAREKEY,
-  WMAC_AUTH_AUTO,
-  WMAC_AUTH_WPA,
-  WMAC_AUTH_WPAPSK,
-  WMAC_AUTH_WPANONE,
-  WMAC_AUTH_WPA2,
-  WMAC_AUTH_WPA2PSK,
-  WMAC_AUTH_MAX       // Not a real mode, defined as upper bound
-
-  } WMAC_AUTHENTICATION_MODE, *PWMAC_AUTHENTICATION_MODE;
-*/
-
-// Pre-configured Mode (from XP)
-/*
-  typedef enum tagWMAC_CONFIG_MODE {
-  WMAC_CONFIG_ESS_STA,
-  WMAC_CONFIG_IBSS_STA,
-  WMAC_CONFIG_AUTO,
-  WMAC_CONFIG_AP
-
-  } WMAC_CONFIG_MODE, *PWMAC_CONFIG_MODE;
-*/
-
 typedef enum tagWMAC_SCAN_TYPE {
 	WMAC_SCAN_ACTIVE,
 	WMAC_SCAN_PASSIVE,
@@ -232,9 +206,6 @@ typedef struct tagSMgmtObject
 	unsigned char byCSSGK;
 	unsigned char byCSSPK;
 
-//    unsigned char abyNewSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN];
-//    unsigned char abyNewExtSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN];
-
 	// Current state vars
 	unsigned int	uCurrChannel;
 	unsigned char abyCurrSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1];
@@ -256,7 +227,6 @@ typedef struct tagSMgmtObject
 	unsigned char abyDesireBSSID[WLAN_BSSID_LEN];
 
 	// Adhoc or AP configuration vars
-	//unsigned char abyAdHocSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
 	unsigned short wIBSSBeaconPeriod;
 	unsigned short wIBSSATIMWindow;
 	unsigned int	uIBSSChannel;
diff --git a/drivers/staging/vt6655/wpa.c b/drivers/staging/vt6655/wpa.c
index 990ea0f..554e55e 100644
--- a/drivers/staging/vt6655/wpa.c
+++ b/drivers/staging/vt6655/wpa.c
@@ -160,8 +160,8 @@ WPA_ParseRSN(
 						;
 				} else
 					break;
-				//DBG_PRN_GRP14(("abyPKType[%d]: %X\n", j-1, pBSSList->abyPKType[j-1]));
-			} //for
+
+			}
 			pBSSList->wPKCount = (unsigned short)j;
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wPKCount: %d\n", pBSSList->wPKCount);
 		}
@@ -187,7 +187,7 @@ WPA_ParseRSN(
 						;
 				} else
 					break;
-				//DBG_PRN_GRP14(("abyAuthType[%d]: %X\n", j-1, pBSSList->abyAuthType[j-1]));
+
 			}
 			if (j > 0)
 				pBSSList->wAuthCount = (unsigned short)j;
@@ -206,9 +206,6 @@ WPA_ParseRSN(
 				pBSSList->byReplayIdx = 2 << ((*pbyCaps >> WPA_REPLAYBITSSHIFT) & WPA_REPLAYBITS);
 				pBSSList->sRSNCapObj.bRSNCapExist = true;
 				pBSSList->sRSNCapObj.wRSNCap = *(unsigned short *)pbyCaps;
-				//DBG_PRN_GRP14(("pbyCaps: %X\n", *pbyCaps));
-				//DBG_PRN_GRP14(("byDefaultK_as_PK: %X\n", pBSSList->byDefaultK_as_PK));
-				//DBG_PRN_GRP14(("byReplayIdx: %X\n", pBSSList->byReplayIdx));
 			}
 		}
 		pBSSList->bWPAValid = true;
diff --git a/drivers/staging/vt6655/wpa2.c b/drivers/staging/vt6655/wpa2.c
index 2013122..3832c7c 100644
--- a/drivers/staging/vt6655/wpa2.c
+++ b/drivers/staging/vt6655/wpa2.c
@@ -37,7 +37,6 @@
 
 /*---------------------  Static Definitions -------------------------*/
 static int msglevel = MSG_LEVEL_INFO;
-//static int          msglevel                =MSG_LEVEL_DEBUG;
 /*---------------------  Static Classes  ----------------------------*/
 
 /*---------------------  Static Variables  --------------------------*/
@@ -150,9 +149,10 @@ WPA2vParseRSN(
 		else if (!memcmp(pbyOUI, abyOUIGK, 4)) {
 			// invalid CSS, P802.11i/D10.0, p32
 			return;
-		} else
+		} else {
 			// any vendor checks here
 			pBSSNode->byCSSGK = WLAN_11i_CSS_UNKNOWN;
+		}
 
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "802.11i CSS: %X\n", pBSSNode->byCSSGK);
 
diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
index bdfb528..e319e26 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -51,7 +51,6 @@ static const int frequency_list[] = {
 /*---------------------  Static Classes  ----------------------------*/
 
 /*---------------------  Static Variables  --------------------------*/
-//static int          msglevel                =MSG_LEVEL_DEBUG;
 static int msglevel = MSG_LEVEL_INFO;
 
 /*---------------------  Static Functions  --------------------------*/
@@ -196,7 +195,6 @@ int wpa_set_keys(PSDevice pDevice, void *ctx, bool fcpfkernel)
 	unsigned char abyKey[MAX_KEY_LEN];
 	unsigned char abySeq[MAX_KEY_LEN];
 	QWORD   KeyRSC;
-//    NDIS_802_11_KEY_RSC KeyRSC;
 	unsigned char byKeyDecMode = KEY_CTL_WEP;
 	int ret = 0;
 	int uu, ii;
@@ -219,7 +217,6 @@ int wpa_set_keys(PSDevice pDevice, void *ctx, bool fcpfkernel)
 		return ret;
 	}
 
-	//spin_unlock_irq(&pDevice->lock);
 	if (param->u.wpa_key.key && fcpfkernel) {
 		memcpy(&abyKey[0], param->u.wpa_key.key, param->u.wpa_key.key_len);
 	} else {
@@ -258,7 +255,6 @@ int wpa_set_keys(PSDevice pDevice, void *ctx, bool fcpfkernel)
 		return ret;
 	}
 
-	//spin_unlock_irq(&pDevice->lock);
 	if (param->u.wpa_key.seq && fcpfkernel) {
 		memcpy(&abySeq[0], param->u.wpa_key.seq, param->u.wpa_key.seq_len);
 	} else {
@@ -277,7 +273,6 @@ int wpa_set_keys(PSDevice pDevice, void *ctx, bool fcpfkernel)
 				LODWORD(KeyRSC) |= (abySeq[ii] << (ii * 8));
 			else
 				HIDWORD(KeyRSC) |= (abySeq[ii] << ((ii-4) * 8));
-			//KeyRSC |= (abySeq[ii] << (ii * 8));
 		}
 		dwKeyIndex |= 1 << 29;
 	}
@@ -324,7 +319,6 @@ int wpa_set_keys(PSDevice pDevice, void *ctx, bool fcpfkernel)
 	if ((byKeyDecMode == KEY_CTL_TKIP) &&
 	    (param->u.wpa_key.key_len != MAX_KEY_LEN)) {
 		// TKIP Key must be 256 bits
-		//DBG_PRN_WLAN03(("return NDIS_STATUS_INVALID_DATA - TKIP Key must be 256 bits\n"));
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "return- TKIP Key must be 256 bits!\n");
 		return -EINVAL;
 	}
@@ -332,7 +326,6 @@ int wpa_set_keys(PSDevice pDevice, void *ctx, bool fcpfkernel)
 	if ((byKeyDecMode == KEY_CTL_CCMP) &&
 	    (param->u.wpa_key.key_len != AES_KEY_LEN)) {
 		// AES Key must be 128 bits
-		//DBG_PRN_WLAN03(("return NDIS_STATUS_INVALID_DATA - AES Key must be 128 bits\n"));
 		return -EINVAL;
 	}
 
@@ -360,8 +353,6 @@ int wpa_set_keys(PSDevice pDevice, void *ctx, bool fcpfkernel)
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "GROUP Key Assign.\n");
 
 		} else {
-			//DBG_PRN_WLAN03(("return NDIS_STATUS_INVALID_DATA -KeybSetDefaultKey Fail.0\n"));
-			// spin_unlock_irq(&pDevice->lock);
 			return -EINVAL;
 		}
 
@@ -371,16 +362,13 @@ int wpa_set_keys(PSDevice pDevice, void *ctx, bool fcpfkernel)
 		// Pairwise Key can't be WEP
 		if (byKeyDecMode == KEY_CTL_WEP) {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Pairwise Key can't be WEP\n");
-			//spin_unlock_irq(&pDevice->lock);
 			return -EINVAL;
 		}
 
 		dwKeyIndex |= (1 << 30); // set pairwise key
-		if (pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) {
-			//DBG_PRN_WLAN03(("return NDIS_STATUS_INVALID_DATA - WMAC_CONFIG_IBSS_STA\n"));
-			//spin_unlock_irq(&pDevice->lock);
+		if (pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA)
 			return -EINVAL;
-		}
+
 		if (KeybSetKey(&(pDevice->sKey),
 			       &param->addr[0],
 			       dwKeyIndex,
@@ -394,17 +382,7 @@ int wpa_set_keys(PSDevice pDevice, void *ctx, bool fcpfkernel)
 
 		} else {
 			// Key Table Full
-			if (ether_addr_equal(param->addr, pDevice->abyBSSID)) {
-				//DBG_PRN_WLAN03(("return NDIS_STATUS_INVALID_DATA -Key Table Full.2\n"));
-				//spin_unlock_irq(&pDevice->lock);
-				return -EINVAL;
-
-			} else {
-				// Save Key and configure just before associate/reassociate to BSSID
-				// we do not implement now
-				//spin_unlock_irq(&pDevice->lock);
-				return -EINVAL;
-			}
+			return -EINVAL;
 		}
 	} // BSSID not 0xffffffffffff
 	if ((ret == 0) && ((param->u.wpa_key.set_tx) != 0)) {
@@ -412,17 +390,6 @@ int wpa_set_keys(PSDevice pDevice, void *ctx, bool fcpfkernel)
 		pDevice->bTransmitKey = true;
 	}
 	pDevice->bEncryptionEnable = true;
-	//spin_unlock_irq(&pDevice->lock);
-
-/*
-  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " key=%x-%x-%x-%x-%x-xxxxx\n",
-  pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[byKeyIndex][0],
-  pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[byKeyIndex][1],
-  pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[byKeyIndex][2],
-  pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[byKeyIndex][3],
-  pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[byKeyIndex][4]
-);
-*/
 
 	return ret;
 }
@@ -654,15 +621,12 @@ static int wpa_get_scan(PSDevice pDevice,
 			scan_buf->ssid_len = pItemSSID->len;
 			scan_buf->freq = frequency_list[pBSS->uChannel-1];
 			scan_buf->caps = pBSS->wCapInfo;
-			//scan_buf->caps = pBSS->wCapInfo;
-			//scan_buf->qual =
-			//scan_buf->noise =
-			//scan_buf->level =
-			//scan_buf->maxrate =
+
 			if (pBSS->wWPALen != 0) {
 				scan_buf->wpa_ie_len = pBSS->wWPALen;
 				memcpy(scan_buf->wpa_ie, pBSS->byWPAIE, pBSS->wWPALen);
 			}
+
 			if (pBSS->wRSNLen != 0) {
 				scan_buf->rsn_ie_len = pBSS->wRSNLen;
 				memcpy(scan_buf->rsn_ie, pBSS->byRSNIE, pBSS->wRSNLen);
@@ -788,13 +752,10 @@ static int wpa_set_associate(PSDevice pDevice,
 
 	if (pMgmt->eAuthenMode == WMAC_AUTH_SHAREKEY) {
 		pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
-		//pMgmt->eAuthenMode = WMAC_AUTH_SHAREKEY;
 		pMgmt->bShareKeyAlgorithm = true;
 	} else if (pMgmt->eAuthenMode == WMAC_AUTH_OPEN) {
 		if (!bWepEnabled)  pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 		else pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
-		//pMgmt->eAuthenMode = WMAC_AUTH_OPEN;
-		//pMgmt->bShareKeyAlgorithm = false; //20080717-06,<Modify> by chester//Fix Open mode, WEP encryption
 	}
 //mike save old encryption status
 	pDevice->eOldEncryptionStatus = pDevice->eEncryptionStatus;
diff --git a/drivers/staging/vt6655/wroute.c b/drivers/staging/vt6655/wroute.c
index c39d5ed..4da3fef 100644
--- a/drivers/staging/vt6655/wroute.c
+++ b/drivers/staging/vt6655/wroute.c
@@ -44,7 +44,6 @@
 
 /*---------------------  Static Variables  --------------------------*/
 static int msglevel = MSG_LEVEL_INFO;
-//static int          msglevel                =MSG_LEVEL_DEBUG;
 /*---------------------  Static Functions  --------------------------*/
 
 /*---------------------  Export Variables  --------------------------*/
-- 
1.9.0

