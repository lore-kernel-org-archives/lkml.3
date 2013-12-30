Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab3L3PDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 10:03:52 -0500
Received: from mx-rz-1.rrze.uni-erlangen.de ([131.188.11.20]:50840 "EHLO
	mx-rz-1.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755951Ab3L3PDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 10:03:48 -0500
X-RRZE-Submit-IP: 131.188.42.195
From: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
To: michael.gunselmann@studium.uni-erlangen.de
Cc: martin.hofmann@studium.uni-erlangen.de, forest@alittletooquiet.net,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de,
        Michael Gunselmann <michael.gunselmann@studium.uni-erlange.de>,
        Martin Hofmann <martin.hofmann@studium.uni-erlange.de>
Subject: [PATCH 7/7] vt6655: Fixed most of the checkpatch warnings in wmgr
Date: Mon, 30 Dec 2013 15:52:37 +0100
Message-Id: <1388415157-17615-8-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1388415157-17615-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
References: <1388415157-17615-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wmgr.h: Fixed checkpatch errors.
	Four typedef warnings remain.
		line 85: This typedef increases understandability
			 so this warning is not touched.
		line 196, 203 and 214:
			 These typedef-errors might be fixed in a
			 later commit. Fixing them makes it necessary
			 to touch many other files of the driver
			 using this typedef.

wmgr.c: Fixed checkpatch errors (mostly comments and braces)
	Long lines were ignored and will be fixed in a later commit.
	Seven warnings remain:
		line 562, 770 and 921:
			When removing the braces checkpatch complains
			about the compiler is running into trouble.
			So these lines are not touched.
		line 713, 865, 1618 and 2163:
			Checkpatch complains about not using netdev_dbg
			instead of printk.
			These warnings will be fixed in a later commit.

Signed-off-by: Michael Gunselmann <michael.gunselmann@studium.uni-erlange.de>
Signed-off-by: Martin Hofmann <martin.hofmann@studium.uni-erlange.de>
---
 drivers/staging/vt6655/wmgr.c | 1177 ++++++++++++++++++++---------------------
 drivers/staging/vt6655/wmgr.h |  197 +++----
 2 files changed, 681 insertions(+), 693 deletions(-)

diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index f1bb9c4..be9e043 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -88,16 +88,16 @@
 
 /*---------------------  Static Variables  --------------------------*/
 static int msglevel = MSG_LEVEL_INFO;
-//static int          msglevel                =MSG_LEVEL_DEBUG;
+/* static int          msglevel                =MSG_LEVEL_DEBUG; */
 
 /*---------------------  Static Functions  --------------------------*/
-//2008-8-4 <add> by chester
+/* 2008-8-4 <add> by chester */
 static bool ChannelExceedZoneType(
 	PSDevice pDevice,
 	unsigned char byCurrChannel
 );
 
-// Association/diassociation functions
+/* Association/diassociation functions */
 static
 PSTxMgmtPacket
 s_MgrMakeAssocRequest(
@@ -150,7 +150,7 @@ s_vMgrRxDisassociation(
 	PSRxMgmtPacket pRxPacket
 );
 
-// Authentication/deauthen functions
+/* Authentication/deauthen functions */
 static
 void
 s_vMgrRxAuthenSequence_1(
@@ -199,8 +199,9 @@ s_vMgrRxDeauthentication(
 	PSRxMgmtPacket pRxPacket
 );
 
-// Scan functions
-// probe request/response functions
+/* Scan functions
+ * probe request/response functions
+ */
 static
 void
 s_vMgrRxProbeRequest(
@@ -217,7 +218,7 @@ s_vMgrRxProbeResponse(
 	PSRxMgmtPacket pRxPacket
 );
 
-// beacon functions
+/* beacon functions */
 static
 void
 s_vMgrRxBeacon(
@@ -249,7 +250,7 @@ s_MgrMakeBeacon(
 	PWLAN_IE_SUPP_RATES pCurrExtSuppRates
 );
 
-// Association response
+/* Association response */
 static
 PSTxMgmtPacket
 s_MgrMakeAssocResponse(
@@ -263,7 +264,7 @@ s_MgrMakeAssocResponse(
 	PWLAN_IE_SUPP_RATES pCurrExtSuppRates
 );
 
-// ReAssociation response
+/* ReAssociation response */
 static
 PSTxMgmtPacket
 s_MgrMakeReAssocResponse(
@@ -277,7 +278,7 @@ s_MgrMakeReAssocResponse(
 	PWLAN_IE_SUPP_RATES pCurrExtSuppRates
 );
 
-// Probe response
+/* Probe response */
 static
 PSTxMgmtPacket
 s_MgrMakeProbeResponse(
@@ -295,7 +296,7 @@ s_MgrMakeProbeResponse(
 	unsigned char byPHYType
 );
 
-// received status
+/* received status */
 static
 void
 s_vMgrLogStatus(
@@ -351,11 +352,10 @@ vMgrObjectInit(
 	pMgmt->pbyPSPacketPool = &pMgmt->byPSPacketPool[0];
 	pMgmt->pbyMgmtPacketPool = &pMgmt->byMgmtPacketPool[0];
 	pMgmt->uCurrChannel = pDevice->uChannel;
-	for (ii = 0; ii < WLAN_BSSID_LEN; ii++) {
+	for (ii = 0; ii < WLAN_BSSID_LEN; ii++)
 		pMgmt->abyDesireBSSID[ii] = 0xFF;
-	}
-	pMgmt->sAssocInfo.AssocInfo.Length = sizeof(NDIS_802_11_ASSOCIATION_INFORMATION);
-	//memset(pMgmt->abyDesireSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN +1);
+	pMgmt->sAssocInfo.AssocInfo.Length = sizeof(struct NDIS_802_11_ASSOCIATION_INFORMATION);
+	/* memset(pMgmt->abyDesireSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN +1); */
 	pMgmt->byCSSPK = KEY_CTL_NONE;
 	pMgmt->byCSSGK = KEY_CTL_NONE;
 	pMgmt->wIBSSBeaconPeriod = DEFAULT_IBSS_BI;
@@ -396,7 +396,7 @@ vMgrTimerInit(
 	init_timer(&pDevice->sTimerTxData);
 	pDevice->sTimerTxData.data = (unsigned long) pDevice;
 	pDevice->sTimerTxData.function = (TimerFunction)BSSvSecondTxData;
-	pDevice->sTimerTxData.expires = RUN_AT(10*HZ);      //10s callback
+	pDevice->sTimerTxData.expires = RUN_AT(10*HZ);      /* 10s callback */
 	pDevice->fTxDataInSleep = false;
 	pDevice->IsTxDataTrigger = false;
 	pDevice->nTxDataTimeCout = 0;
@@ -430,7 +430,7 @@ vMgrObjectReset(
 	pMgmt->eCurrMode = WMAC_MODE_STANDBY;
 	pMgmt->eCurrState = WMAC_STATE_IDLE;
 	pDevice->bEnablePSMode = false;
-	// TODO: timer
+	/* TODO: timer */
 
 	return;
 }
@@ -458,23 +458,20 @@ vMgrAssocBeginSta(
 
 	pMgmt->wCurrCapInfo = 0;
 	pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_ESS(1);
-	if (pDevice->bEncryptionEnable) {
+	if (pDevice->bEncryptionEnable)
 		pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_PRIVACY(1);
-	}
 	pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_SHORTPREAMBLE(1);
 	if (pMgmt->wListenInterval == 0)
-		pMgmt->wListenInterval = 1;    // at least one.
+		pMgmt->wListenInterval = 1;    /* at least one. */
 
-	// ERP Phy (802.11g) should support short preamble.
+	/* ERP Phy (802.11g) should support short preamble. */
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
@@ -527,25 +524,22 @@ vMgrReAssocBeginSta(
 
 	pMgmt->wCurrCapInfo = 0;
 	pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_ESS(1);
-	if (pDevice->bEncryptionEnable) {
+	if (pDevice->bEncryptionEnable)
 		pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_PRIVACY(1);
-	}
 
 	pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_SHORTPREAMBLE(1);
 
 	if (pMgmt->wListenInterval == 0)
-		pMgmt->wListenInterval = 1;    // at least one.
+		pMgmt->wListenInterval = 1;    /* at least one. */
 
-	// ERP Phy (802.11g) should support short preamble.
+	/* ERP Phy (802.11g) should support short preamble. */
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
@@ -560,16 +554,15 @@ vMgrReAssocBeginSta(
 			(PWLAN_IE_SSID)pMgmt->abyCurrSSID,
 			(PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
 			(PWLAN_IE_SUPP_RATES)pMgmt->abyCurrExtSuppRates
-);
+	);
 
 	if (pTxPacket != NULL) {
 		/* send the frame */
 		*pStatus = csMgmt_xmit(pDevice, pTxPacket);
 		if (*pStatus != CMD_STATUS_PENDING) {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Reassociation tx failed.\n");
-		} else {
+		} else
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Reassociation tx sending.\n");
-		}
 	}
 
 	return;
@@ -602,14 +595,14 @@ vMgrDisassocBeginSta(
 	memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_DISASSOC_FR_MAXLEN);
 	pTxPacket->p80211Header = (union UWLAN_80211HDR *)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
 
-	// Setup the sFrame structure
+	/* Setup the sFrame structure */
 	sFrame.pBuf = (unsigned char *)pTxPacket->p80211Header;
 	sFrame.len = WLAN_DISASSOC_FR_MAXLEN;
 
-	// format fixed field frame structure
+	/* format fixed field frame structure */
 	vMgrEncodeDisassociation(&sFrame);
 
-	// Setup the header
+	/* Setup the header */
 	sFrame.pHdr->sA3.wFrameCtl = cpu_to_le16(
 		(
 			WLAN_SET_FC_FTYPE(WLAN_TYPE_MGR) |
@@ -620,12 +613,12 @@ vMgrDisassocBeginSta(
 	memcpy(sFrame.pHdr->sA3.abyAddr2, pMgmt->abyMACAddr, WLAN_ADDR_LEN);
 	memcpy(sFrame.pHdr->sA3.abyAddr3, pMgmt->abyCurrBSSID, WLAN_BSSID_LEN);
 
-	// Set reason code
+	/* Set reason code */
 	*(sFrame.pwReason) = cpu_to_le16(wReason);
 	pTxPacket->cbMPDULen = sFrame.len;
 	pTxPacket->cbPayloadLen = sFrame.len - WLAN_HDR_ADDR3_LEN;
 
-	// send the frame
+	/* send the frame */
 	*pStatus = csMgmt_xmit(pDevice, pTxPacket);
 	if (*pStatus == CMD_STATUS_PENDING) {
 		pMgmt->eCurrState = WMAC_STATE_IDLE;
@@ -665,12 +658,13 @@ s_vMgrRxAssocRequest(
 
 	if (pMgmt->eCurrMode != WMAC_MODE_ESS_AP)
 		return;
-	//  node index not found
+	/*  node index not found */
 	if (!uNodeIndex)
 		return;
 
-	//check if node is authenticated
-	//decode the frame
+	/* check if node is authenticated
+	 * decode the frame
+	 */
 	memset(&sFrame, 0, sizeof(WLAN_FR_ASSOCREQ));
 	memset(abyCurrSuppRates, 0, WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1);
 	memset(abyCurrExtSuppRates, 0, WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1);
@@ -685,10 +679,9 @@ s_vMgrRxAssocRequest(
 		pMgmt->sNodeDBTable[uNodeIndex].wListenInterval = cpu_to_le16(*sFrame.pwListenInterval);
 		pMgmt->sNodeDBTable[uNodeIndex].bPSEnable =
 			WLAN_GET_FC_PWRMGT(sFrame.pHdr->sA3.wFrameCtl) ? true : false;
-		// Todo: check sta basic rate, if ap can't support, set status code
-		if (pDevice->eCurrentPHYType == PHY_TYPE_11B) {
+		/* Todo: check sta basic rate, if ap can't support, set status code */
+		if (pDevice->eCurrentPHYType == PHY_TYPE_11B)
 			uRateLen = WLAN_RATES_MAXLEN_11B;
-		}
 		abyCurrSuppRates[0] = WLAN_EID_SUPP_RATES;
 		abyCurrSuppRates[1] = RATEuSetIE((PWLAN_IE_SUPP_RATES)sFrame.pSuppRates,
 						 (PWLAN_IE_SUPP_RATES)abyCurrSuppRates,
@@ -705,7 +698,7 @@ s_vMgrRxAssocRequest(
 		RATEvParseMaxRate((void *)pDevice,
 				  (PWLAN_IE_SUPP_RATES)abyCurrSuppRates,
 				  (PWLAN_IE_SUPP_RATES)abyCurrExtSuppRates,
-				  false, // do not change our basic rate
+				  false, /* do not change our basic rate */
 				  &(pMgmt->sNodeDBTable[uNodeIndex].wMaxBasicRate),
 				  &(pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate),
 				  &(pMgmt->sNodeDBTable[uNodeIndex].wSuppRate),
@@ -713,13 +706,15 @@ s_vMgrRxAssocRequest(
 				  &(pMgmt->sNodeDBTable[uNodeIndex].byTopOFDMBasicRate)
 );
 
-		// set max tx rate
+		/* set max tx rate */
 		pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate =
 			pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate;
 #ifdef	PLICE_DEBUG
-		printk("RxAssocRequest:wTxDataRate is %d\n", pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate);
+		printk(KERN_DEBUG
+		       "RxAssocRequest:wTxDataRate is %d\n",
+		       pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate);
 #endif
-		// Todo: check sta preamble, if ap can't support, set status code
+		/* Todo: check sta preamble, if ap can't support, set status code */
 		pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble =
 			WLAN_GET_CAP_INFO_SHORTPREAMBLE(*sFrame.pwCapInfo);
 		pMgmt->sNodeDBTable[uNodeIndex].bShortSlotTime =
@@ -727,21 +722,20 @@ s_vMgrRxAssocRequest(
 		pMgmt->sNodeDBTable[uNodeIndex].wAID = (unsigned short)uNodeIndex;
 		wAssocStatus = WLAN_MGMT_STATUS_SUCCESS;
 		wAssocAID = (unsigned short)uNodeIndex;
-		// check if ERP support
+		/* check if ERP support */
 		if (pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate > RATE_11M)
 			pMgmt->sNodeDBTable[uNodeIndex].bERPExist = true;
 
 		if (pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate <= RATE_11M) {
-			// B only STA join
+			/* B only STA join */
 			pDevice->bProtectMode = true;
 			pDevice->bNonERPPresent = true;
 		}
-		if (!pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble) {
+		if (!pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble)
 			pDevice->bBarkerPreambleMd = true;
-		}
 
-		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Associate AID= %d \n", wAssocAID);
-		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "MAC=%2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X \n",
+		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Associate AID= %d\n", wAssocAID);
+		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "MAC=%2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X\n",
 			sFrame.pHdr->sA3.abyAddr2[0],
 			sFrame.pHdr->sA3.abyAddr2[1],
 			sFrame.pHdr->sA3.abyAddr2[2],
@@ -749,14 +743,14 @@ s_vMgrRxAssocRequest(
 			sFrame.pHdr->sA3.abyAddr2[4],
 			sFrame.pHdr->sA3.abyAddr2[5]
 			);
-		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Max Support rate = %d \n",
+		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Max Support rate = %d\n",
 			pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate);
-	}//else { TODO: received STA under state1 handle }
-	else {
-		return;
 	}
+	/* else { TODO: received STA under state1 handle } */
+	else
+		return;
 
-	// assoc response reply..
+	/* assoc response reply.. */
 	pTxPacket = s_MgrMakeAssocResponse
 		(
 			pDevice,
@@ -769,17 +763,14 @@ s_vMgrRxAssocRequest(
 			(PWLAN_IE_SUPP_RATES)pMgmt->abyCurrExtSuppRates
 );
 	if (pTxPacket != NULL) {
-		if (pDevice->bEnableHostapd) {
+		if (pDevice->bEnableHostapd)
 			return;
-		}
 		/* send the frame */
 		Status = csMgmt_xmit(pDevice, pTxPacket);
 		if (Status != CMD_STATUS_PENDING) {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Assoc response tx failed\n");
-		} else {
+		} else
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Assoc response tx sending..\n");
-		}
-
 	}
 
 	return;
@@ -821,11 +812,12 @@ s_vMgrRxReAssocRequest(
 
 	if (pMgmt->eCurrMode != WMAC_MODE_ESS_AP)
 		return;
-	//  node index not found
+	/*  node index not found */
 	if (!uNodeIndex)
 		return;
-	//check if node is authenticated
-	//decode the frame
+	/* check if node is authenticated
+	 * decode the frame
+	 */
 	memset(&sFrame, 0, sizeof(WLAN_FR_REASSOCREQ));
 	sFrame.len = pRxPacket->cbMPDULen;
 	sFrame.pBuf = (unsigned char *)pRxPacket->p80211Header;
@@ -837,11 +829,10 @@ s_vMgrRxReAssocRequest(
 		pMgmt->sNodeDBTable[uNodeIndex].wListenInterval = cpu_to_le16(*sFrame.pwListenInterval);
 		pMgmt->sNodeDBTable[uNodeIndex].bPSEnable =
 			WLAN_GET_FC_PWRMGT(sFrame.pHdr->sA3.wFrameCtl) ? true : false;
-		// Todo: check sta basic rate, if ap can't support, set status code
+		/* Todo: check sta basic rate, if ap can't support, set status code */
 
-		if (pDevice->eCurrentPHYType == PHY_TYPE_11B) {
+		if (pDevice->eCurrentPHYType == PHY_TYPE_11B)
 			uRateLen = WLAN_RATES_MAXLEN_11B;
-		}
 
 		abyCurrSuppRates[0] = WLAN_EID_SUPP_RATES;
 		abyCurrSuppRates[1] = RATEuSetIE((PWLAN_IE_SUPP_RATES)sFrame.pSuppRates,
@@ -859,7 +850,7 @@ s_vMgrRxReAssocRequest(
 		RATEvParseMaxRate((void *)pDevice,
 				  (PWLAN_IE_SUPP_RATES)abyCurrSuppRates,
 				  (PWLAN_IE_SUPP_RATES)abyCurrExtSuppRates,
-				  false, // do not change our basic rate
+				  false, /* do not change our basic rate */
 				  &(pMgmt->sNodeDBTable[uNodeIndex].wMaxBasicRate),
 				  &(pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate),
 				  &(pMgmt->sNodeDBTable[uNodeIndex].wSuppRate),
@@ -867,13 +858,14 @@ s_vMgrRxReAssocRequest(
 				  &(pMgmt->sNodeDBTable[uNodeIndex].byTopOFDMBasicRate)
 );
 
-		// set max tx rate
+		/* set max tx rate */
 		pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate =
 			pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate;
 #ifdef	PLICE_DEBUG
-		printk("RxReAssocRequest:TxDataRate is %d\n", pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate);
+		printk(KERN_DEBUG
+		       "RxReAssocRequest:TxDataRate is %d\n", pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate);
 #endif
-		// Todo: check sta preamble, if ap can't support, set status code
+		/* Todo: check sta preamble, if ap can't support, set status code */
 		pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble =
 			WLAN_GET_CAP_INFO_SHORTPREAMBLE(*sFrame.pwCapInfo);
 		pMgmt->sNodeDBTable[uNodeIndex].bShortSlotTime =
@@ -882,21 +874,20 @@ s_vMgrRxReAssocRequest(
 		wAssocStatus = WLAN_MGMT_STATUS_SUCCESS;
 		wAssocAID = (unsigned short)uNodeIndex;
 
-		// if suppurt ERP
+		/* if suppurt ERP */
 		if (pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate > RATE_11M)
 			pMgmt->sNodeDBTable[uNodeIndex].bERPExist = true;
 
 		if (pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate <= RATE_11M) {
-			// B only STA join
+			/* B only STA join */
 			pDevice->bProtectMode = true;
 			pDevice->bNonERPPresent = true;
 		}
-		if (!pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble) {
+		if (!pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble)
 			pDevice->bBarkerPreambleMd = true;
-		}
 
-		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Rx ReAssociate AID= %d \n", wAssocAID);
-		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "MAC=%2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X \n",
+		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Rx ReAssociate AID= %d\n", wAssocAID);
+		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "MAC=%2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X\n",
 			sFrame.pHdr->sA3.abyAddr2[0],
 			sFrame.pHdr->sA3.abyAddr2[1],
 			sFrame.pHdr->sA3.abyAddr2[2],
@@ -904,12 +895,12 @@ s_vMgrRxReAssocRequest(
 			sFrame.pHdr->sA3.abyAddr2[4],
 			sFrame.pHdr->sA3.abyAddr2[5]
 			);
-		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Max Support rate = %d \n",
+		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Max Support rate = %d\n",
 			pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate);
 
 	}
 
-	// assoc response reply..
+	/* assoc response reply.. */
 	pTxPacket = s_MgrMakeReAssocResponse
 		(
 			pDevice,
@@ -924,15 +915,13 @@ s_vMgrRxReAssocRequest(
 
 	if (pTxPacket != NULL) {
 		/* send the frame */
-		if (pDevice->bEnableHostapd) {
+		if (pDevice->bEnableHostapd)
 			return;
-		}
 		Status = csMgmt_xmit(pDevice, pTxPacket);
 		if (Status != CMD_STATUS_PENDING) {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:ReAssoc response tx failed\n");
-		} else {
+		} else
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:ReAssoc response tx sending..\n");
-		}
 	}
 	return;
 }
@@ -965,7 +954,7 @@ s_vMgrRxAssocResponse(
 	    pMgmt->eCurrState == WMAC_STATE_ASSOC) {
 		sFrame.len = pRxPacket->cbMPDULen;
 		sFrame.pBuf = (unsigned char *)pRxPacket->p80211Header;
-		// decode the frame
+		/* decode the frame */
 		vMgrDecodeAssocResponse(&sFrame);
 		if ((sFrame.pwCapInfo == 0) ||
 		    (sFrame.pwStatus == 0) ||
@@ -986,13 +975,12 @@ s_vMgrRxAssocResponse(
 		pbyIEs += pMgmt->sAssocInfo.AssocInfo.RequestIELength;
 		memcpy(pbyIEs, (sFrame.pBuf + 24 + 6), pMgmt->sAssocInfo.AssocInfo.ResponseIELength);
 
-		// save values and set current BSS state
+		/* save values and set current BSS state */
 		if (cpu_to_le16((*(sFrame.pwStatus))) == WLAN_MGMT_STATUS_SUCCESS) {
-			// set AID
+			/* set AID */
 			pMgmt->wCurrAID = cpu_to_le16((*(sFrame.pwAid)));
-			if ((pMgmt->wCurrAID >> 14) != (BIT0 | BIT1)) {
+			if ((pMgmt->wCurrAID >> 14) != (BIT0 | BIT1))
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "AID from AP, has two msb clear.\n");
-			}
 			DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Association Successful, AID=%d.\n", pMgmt->wCurrAID & ~(BIT14 | BIT15));
 			pMgmt->eCurrState = WMAC_STATE_ASSOC;
 			BSSvUpdateAPNode((void *)pDevice, sFrame.pwCapInfo, sFrame.pSuppRates, sFrame.pExtSuppRates);
@@ -1001,8 +989,8 @@ s_vMgrRxAssocResponse(
 			pDevice->bLinkPass = true;
 			pDevice->uBBVGADiffCount = 0;
 			if ((pDevice->bWPADEVUp) && (pDevice->skb != NULL)) {
-				if (skb_tailroom(pDevice->skb) < (sizeof(viawget_wpa_header) + pMgmt->sAssocInfo.AssocInfo.ResponseIELength +
-								  pMgmt->sAssocInfo.AssocInfo.RequestIELength)) {    //data room not enough
+				if (skb_tailroom(pDevice->skb) < (sizeof(viawget_wpa_header) + pMgmt->sAssocInfo.AssocInfo.ResponseIELength
+								  + pMgmt->sAssocInfo.AssocInfo.RequestIELength)) {    /* data room not enough */
 					dev_kfree_skb(pDevice->skb);
 					pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
 				}
@@ -1025,7 +1013,7 @@ s_vMgrRxAssocResponse(
 				pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
 			}
 
-//2008-0409-07, <Add> by Einsn Liu
+/* 2008-0409-07, <Add> by Einsn Liu */
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 			{
 				unsigned char buf[512];
@@ -1060,13 +1048,13 @@ s_vMgrRxAssocResponse(
 				wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 				wireless_send_event(pDevice->dev, SIOCGIWAP, &wrqu, NULL);
 			}
-#endif //#ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-//End Add -- //2008-0409-07, <Add> by Einsn Liu
+#endif /*#ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT */
+/* End Add -- //2008-0409-07, <Add> by Einsn Liu */
 		} else {
 			if (bReAssocType) {
 				pMgmt->eCurrState = WMAC_STATE_IDLE;
 			} else {
-				// jump back to the auth state and indicate the error
+				/* jump back to the auth state and indicate the error */
 				pMgmt->eCurrState = WMAC_STATE_AUTH;
 			}
 			s_vMgrLogStatus(pMgmt, cpu_to_le16((*(sFrame.pwStatus))));
@@ -1075,7 +1063,7 @@ s_vMgrRxAssocResponse(
 	}
 
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-//need clear flags related to Networkmanager
+/* need clear flags related to Networkmanager */
 
 	pDevice->bwextcount = 0;
 	pDevice->bWPASuppWextEnabled = false;
@@ -1183,15 +1171,14 @@ vMgrDeAuthenBeginSta(
 	memcpy(sFrame.pHdr->sA3.abyAddr2, pMgmt->abyMACAddr, WLAN_ADDR_LEN);
 	memcpy(sFrame.pHdr->sA3.abyAddr3, pMgmt->abyCurrBSSID, WLAN_BSSID_LEN);
 
-	*(sFrame.pwReason) = cpu_to_le16(wReason);       // deauthen. bcs left BSS
+	*(sFrame.pwReason) = cpu_to_le16(wReason);       /* deauthen. bcs left BSS */
 	/* Adjust the length fields */
 	pTxPacket->cbMPDULen = sFrame.len;
 	pTxPacket->cbPayloadLen = sFrame.len - WLAN_HDR_ADDR3_LEN;
 
 	*pStatus = csMgmt_xmit(pDevice, pTxPacket);
-	if (*pStatus == CMD_STATUS_PENDING) {
+	if (*pStatus == CMD_STATUS_PENDING)
 		*pStatus = CMD_STATUS_SUCCESS;
-	}
 
 	return;
 }
@@ -1216,26 +1203,26 @@ s_vMgrRxAuthentication(
 {
 	WLAN_FR_AUTHEN  sFrame;
 
-	// we better be an AP or a STA in AUTHPENDING otherwise ignore
+	/* we better be an AP or a STA in AUTHPENDING otherwise ignore */
 	if (!(pMgmt->eCurrMode == WMAC_MODE_ESS_AP ||
 	      pMgmt->eCurrState == WMAC_STATE_AUTHPENDING)) {
 		return;
 	}
 
-	// decode the frame
+	/* decode the frame */
 	sFrame.len = pRxPacket->cbMPDULen;
 	sFrame.pBuf = (unsigned char *)pRxPacket->p80211Header;
 	vMgrDecodeAuthen(&sFrame);
 	switch (cpu_to_le16((*(sFrame.pwAuthSequence)))) {
 	case 1:
-		//AP function
+		/* AP function */
 		s_vMgrRxAuthenSequence_1(pDevice, pMgmt, &sFrame);
 		break;
 	case 2:
 		s_vMgrRxAuthenSequence_2(pDevice, pMgmt, &sFrame);
 		break;
 	case 3:
-		//AP function
+		/* AP function */
 		s_vMgrRxAuthenSequence_3(pDevice, pMgmt, &sFrame);
 		break;
 	case 4:
@@ -1274,7 +1261,7 @@ s_vMgrRxAuthenSequence_1(
 	WLAN_FR_AUTHEN      sFrame;
 	PSKeyItem           pTransmitKey;
 
-	// Insert a Node entry
+	/* Insert a Node entry */
 	if (!BSSDBbIsSTAInNodeDB(pMgmt, pFrame->pHdr->sA3.abyAddr2, &uNodeIndex)) {
 		BSSvCreateOneNode((PSDevice)pDevice, &uNodeIndex);
 		memcpy(pMgmt->sNodeDBTable[uNodeIndex].abyMACAddr, pFrame->pHdr->sA3.abyAddr2,
@@ -1288,15 +1275,15 @@ s_vMgrRxAuthenSequence_1(
 		pMgmt->sNodeDBTable[uNodeIndex].eNodeState = NODE_AUTH;
 	}
 
-	// send auth reply
+	/* send auth reply */
 	pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
 	memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_AUTHEN_FR_MAXLEN);
 	pTxPacket->p80211Header = (union UWLAN_80211HDR *)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
 	sFrame.pBuf = (unsigned char *)pTxPacket->p80211Header;
 	sFrame.len = WLAN_AUTHEN_FR_MAXLEN;
-	// format buffer structure
+	/* format buffer structure */
 	vMgrEncodeAuthen(&sFrame);
-	// insert values
+	/* insert values */
 	sFrame.pHdr->sA3.wFrameCtl = cpu_to_le16(
 		(
 			WLAN_SET_FC_FTYPE(WLAN_TYPE_MGR) |
@@ -1328,7 +1315,7 @@ s_vMgrRxAuthenSequence_1(
 		sFrame.pChallenge->byElementID = WLAN_EID_CHALLENGE;
 		sFrame.pChallenge->len = WLAN_CHALLENGE_LEN;
 		memset(pMgmt->abyChallenge, 0, WLAN_CHALLENGE_LEN);
-		// get group key
+		/* get group key */
 		if (KeybGetTransmitKey(&(pDevice->sKey), pDevice->abyBroadcastAddr, GROUP_KEY, &pTransmitKey) == true) {
 			rc4_init(&pDevice->SBox, pDevice->abyPRNG, pTransmitKey->uKeyLength+3);
 			rc4_encrypt(&pDevice->SBox, pMgmt->abyChallenge, pMgmt->abyChallenge, WLAN_CHALLENGE_LEN);
@@ -1339,14 +1326,12 @@ s_vMgrRxAuthenSequence_1(
 	/* Adjust the length fields */
 	pTxPacket->cbMPDULen = sFrame.len;
 	pTxPacket->cbPayloadLen = sFrame.len - WLAN_HDR_ADDR3_LEN;
-	// send the frame
-	if (pDevice->bEnableHostapd) {
+	/* send the frame */
+	if (pDevice->bEnableHostapd)
 		return;
-	}
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Authreq_reply sequence_1 tx.. \n");
-	if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING) {
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Authreq_reply sequence_1 tx..\n");
+	if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING)
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Authreq_reply sequence_1 tx failed.\n");
-	}
 	return;
 }
 
@@ -1384,11 +1369,12 @@ s_vMgrRxAuthenSequence_2(
 			s_vMgrLogStatus(pMgmt, cpu_to_le16((*(pFrame->pwStatus))));
 			pMgmt->eCurrState = WMAC_STATE_IDLE;
 		}
-		if (pDevice->eCommandState == WLAN_AUTHENTICATE_WAIT) {
-//                spin_unlock_irq(&pDevice->lock);
-//                vCommandTimerWait((void *)pDevice, 0);
-//                spin_lock_irq(&pDevice->lock);
-		}
+/*		if (pDevice->eCommandState == WLAN_AUTHENTICATE_WAIT) {
+ *                spin_unlock_irq(&pDevice->lock);
+ *                vCommandTimerWait((void *)pDevice, 0);
+ *                spin_lock_irq(&pDevice->lock);
+ *		}
+ */
 
 		break;
 
@@ -1400,9 +1386,9 @@ s_vMgrRxAuthenSequence_2(
 			pTxPacket->p80211Header = (union UWLAN_80211HDR *)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
 			sFrame.pBuf = (unsigned char *)pTxPacket->p80211Header;
 			sFrame.len = WLAN_AUTHEN_FR_MAXLEN;
-			// format buffer structure
+			/* format buffer structure */
 			vMgrEncodeAuthen(&sFrame);
-			// insert values
+			/* insert values */
 			sFrame.pHdr->sA3.wFrameCtl = cpu_to_le16(
 				(
 					WLAN_SET_FC_FTYPE(WLAN_TYPE_MGR) |
@@ -1420,21 +1406,21 @@ s_vMgrRxAuthenSequence_2(
 			sFrame.pChallenge->byElementID = WLAN_EID_CHALLENGE;
 			sFrame.pChallenge->len = WLAN_CHALLENGE_LEN;
 			memcpy(sFrame.pChallenge->abyChallenge, pFrame->pChallenge->abyChallenge, WLAN_CHALLENGE_LEN);
-			// Adjust the length fields
+			/* Adjust the length fields */
 			pTxPacket->cbMPDULen = sFrame.len;
 			pTxPacket->cbPayloadLen = sFrame.len - WLAN_HDR_ADDR3_LEN;
-			// send the frame
-			if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING) {
+			/* send the frame */
+			if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING)
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Auth_reply sequence_2 tx failed.\n");
-			}
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Auth_reply sequence_2 tx ...\n");
 		} else {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:rx Auth_reply sequence_2 status error ...\n");
-			if (pDevice->eCommandState == WLAN_AUTHENTICATE_WAIT) {
-//                    spin_unlock_irq(&pDevice->lock);
-//                    vCommandTimerWait((void *)pDevice, 0);
-//                    spin_lock_irq(&pDevice->lock);
-			}
+/*			if (pDevice->eCommandState == WLAN_AUTHENTICATE_WAIT) {
+ *                    spin_unlock_irq(&pDevice->lock);
+ *                    vCommandTimerWait((void *)pDevice, 0);
+ *                    spin_lock_irq(&pDevice->lock);
+ *			}
+ */
 			s_vMgrLogStatus(pMgmt, cpu_to_le16((*(pFrame->pwStatus))));
 		}
 		break;
@@ -1497,13 +1483,13 @@ s_vMgrRxAuthenSequence_3(
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Challenge text check ok..\n");
 
 reply:
-	// send auth reply
+	/* send auth reply */
 	pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
 	memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_AUTHEN_FR_MAXLEN);
 	pTxPacket->p80211Header = (union UWLAN_80211HDR *)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
 	sFrame.pBuf = (unsigned char *)pTxPacket->p80211Header;
 	sFrame.len = WLAN_AUTHEN_FR_MAXLEN;
-	// format buffer structure
+	/* format buffer structure */
 	vMgrEncodeAuthen(&sFrame);
 	/* insert values */
 	sFrame.pHdr->sA3.wFrameCtl = cpu_to_le16(
@@ -1522,13 +1508,11 @@ reply:
 	/* Adjust the length fields */
 	pTxPacket->cbMPDULen = sFrame.len;
 	pTxPacket->cbPayloadLen = sFrame.len - WLAN_HDR_ADDR3_LEN;
-	// send the frame
-	if (pDevice->bEnableHostapd) {
+	/* send the frame */
+	if (pDevice->bEnableHostapd)
 		return;
-	}
-	if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING) {
+	if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING)
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Authreq_reply sequence_4 tx failed.\n");
-	}
 	return;
 }
 
@@ -1560,11 +1544,13 @@ s_vMgrRxAuthenSequence_4(
 		pMgmt->eCurrState = WMAC_STATE_IDLE;
 	}
 
-	if (pDevice->eCommandState == WLAN_AUTHENTICATE_WAIT) {
-//        spin_unlock_irq(&pDevice->lock);
-//        vCommandTimerWait((void *)pDevice, 0);
-//        spin_lock_irq(&pDevice->lock);
-	}
+/*	if (pDevice->eCommandState == WLAN_AUTHENTICATE_WAIT) {
+ *        spin_unlock_irq(&pDevice->lock);
+ *        vCommandTimerWait((void *)pDevice, 0);
+ *        spin_lock_irq(&pDevice->lock);
+ *
+ *	}
+ */
 }
 
 /*+
@@ -1588,26 +1574,26 @@ s_vMgrRxDisassociation(
 {
 	WLAN_FR_DISASSOC    sFrame;
 	unsigned int uNodeIndex = 0;
-//    CMD_STATUS          CmdStatus;
+/*    CMD_STATUS          CmdStatus; */
 	viawget_wpa_header *wpahdr;
 
 	if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
-		// if is acting an AP..
-		// a STA is leaving this BSS..
+		/* if is acting an AP.. */
+		/* a STA is leaving this BSS.. */
 		sFrame.len = pRxPacket->cbMPDULen;
 		sFrame.pBuf = (unsigned char *)pRxPacket->p80211Header;
-		if (BSSDBbIsSTAInNodeDB(pMgmt, pRxPacket->p80211Header->sA3.abyAddr2, &uNodeIndex)) {
+		if (BSSDBbIsSTAInNodeDB(pMgmt, pRxPacket->p80211Header->sA3.abyAddr2, &uNodeIndex))
 			BSSvRemoveOneNode(pDevice, uNodeIndex);
-		} else {
+		else
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Rx disassoc, sta not found\n");
-		}
 	} else if (pMgmt->eCurrMode == WMAC_MODE_ESS_STA) {
 		sFrame.len = pRxPacket->cbMPDULen;
 		sFrame.pBuf = (unsigned char *)pRxPacket->p80211Header;
 		vMgrDecodeDisassociation(&sFrame);
 		DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "AP disassociated me, reason=%d.\n", cpu_to_le16(*(sFrame.pwReason)));
-		//TODO: do something let upper layer know or
-		//try to send associate packet again because of inactivity timeout
+		/* TODO: do something let upper layer know or
+		 * try to send associate packet again because of inactivity timeout
+		 */
 		if ((pDevice->bWPADEVUp) && (pDevice->skb != NULL)) {
 			wpahdr = (viawget_wpa_header *)pDevice->skb->data;
 			wpahdr->type = VIAWGET_DISASSOC_MSG;
@@ -1629,7 +1615,8 @@ s_vMgrRxDisassociation(
 			union iwreq_data  wrqu;
 			memset(&wrqu, 0, sizeof(wrqu));
 			wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-			printk("wireless_send_event--->SIOCGIWAP(disassociated)\n");
+			printk(KERN_DEBUG
+			       "wireless_send_event--->SIOCGIWAP(disassociated)\n");
 			wireless_send_event(pDevice->dev, SIOCGIWAP, &wrqu, NULL);
 		}
 #endif
@@ -1663,23 +1650,23 @@ s_vMgrRxDeauthentication(
 	viawget_wpa_header *wpahdr;
 
 	if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
-		//Todo:
-		// if is acting an AP..
-		// a STA is leaving this BSS..
+		/* Todo:
+		 * if is acting an AP..
+		 * a STA is leaving this BSS..
+		 */
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
 			sFrame.pBuf = (unsigned char *)pRxPacket->p80211Header;
 			vMgrDecodeDeauthen(&sFrame);
 			DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO  "AP deauthed me, reason=%d.\n", cpu_to_le16((*(sFrame.pwReason))));
-			// TODO: update BSS list for specific BSSID if pre-authentication case
+			/* TODO: update BSS list for specific BSSID if pre-authentication case */
 			if (ether_addr_equal(sFrame.pHdr->sA3.abyAddr3,
 					     pMgmt->abyCurrBSSID)) {
 				if (pMgmt->eCurrState >= WMAC_STATE_AUTHPENDING) {
@@ -1717,13 +1704,15 @@ s_vMgrRxDeauthentication(
 #endif
 
 		}
-		/* else, ignore it.  TODO: IBSS authentication service
-		   would be implemented here */
+		/* else, ignore it.
+		 * TODO: IBSS authentication service
+		 * would be implemented here
+		 */
 	}
 	return;
 }
 
-//2008-8-4 <add> by chester
+/* 2008-8-4 <add> by chester */
 /*+
  *
  * Routine Description:
@@ -1744,16 +1733,16 @@ ChannelExceedZoneType(
 	bool exceed = false;
 
 	switch (pDevice->byZoneType) {
-	case 0x00:                  //USA:1~11
+	case 0x00:                  /* USA:1~11 */
 		if ((byCurrChannel < 1) || (byCurrChannel > 11))
 			exceed = true;
 		break;
-	case 0x01:                  //Japan:1~13
-	case 0x02:                  //Europe:1~13
+	case 0x01:                  /* Japan:1~13 */
+	case 0x02:                  /* Europe:1~13 */
 		if ((byCurrChannel < 1) || (byCurrChannel > 13))
 			exceed = true;
 		break;
-	default:                    //reserve for other zonetype
+	default:                    /* reserve for other zonetype */
 		break;
 	}
 
@@ -1809,7 +1798,7 @@ s_vMgrRxBeacon(
 	sFrame.len = pRxPacket->cbMPDULen;
 	sFrame.pBuf = (unsigned char *)pRxPacket->p80211Header;
 
-	// decode the beacon frame
+	/* decode the beacon frame */
 	vMgrDecodeBeacon(&sFrame);
 
 	if ((sFrame.pwBeaconInterval == 0) ||
@@ -1822,21 +1811,21 @@ s_vMgrRxBeacon(
 
 	if (sFrame.pDSParms != NULL) {
 		if (byCurrChannel > CB_MAX_CHANNEL_24G) {
-			// channel remapping to
+			/* channel remapping to */
 			byIEChannel = get_channel_mapping(pDevice, sFrame.pDSParms->byCurrChannel, PHY_TYPE_11A);
 		} else {
 			byIEChannel = sFrame.pDSParms->byCurrChannel;
 		}
 		if (byCurrChannel != byIEChannel) {
-			// adjust channel info. bcs we rcv adjacent channel packets
+			/* adjust channel info. bcs we rcv adjacent channel packets */
 			bChannelHit = false;
 			byCurrChannel = byIEChannel;
 		}
 	} else {
-		// no DS channel info
+		/* no DS channel info */
 		bChannelHit = true;
 	}
-//2008-0730-01<Add>by MikeLiu
+/* 2008-0730-01<Add>by MikeLiu */
 	if (ChannelExceedZoneType(pDevice, byCurrChannel))
 		return;
 
@@ -1867,11 +1856,11 @@ s_vMgrRxBeacon(
 				    sFrame.pIE_Country,
 				    sFrame.pIE_Quiet,
 				    sFrame.len - WLAN_HDR_ADDR3_LEN,
-				    sFrame.pHdr->sA4.abyAddr4,   // payload of beacon
+				    sFrame.pHdr->sA4.abyAddr4,   /* payload of beacon */
 				    (void *)pRxPacket
 );
 	} else {
-//        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "update bcn: RxChannel = : %d\n", byCurrChannel);
+/*        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "update bcn: RxChannel = : %d\n", byCurrChannel); */
 		BSSbUpdateToBSSList((void *)pDevice,
 				    *sFrame.pqwTimestamp,
 				    *sFrame.pwBeaconInterval,
@@ -1888,21 +1877,20 @@ s_vMgrRxBeacon(
 				    sFrame.pIE_Quiet,
 				    pBSSList,
 				    sFrame.len - WLAN_HDR_ADDR3_LEN,
-				    sFrame.pHdr->sA4.abyAddr4,   // payload of probresponse
+				    sFrame.pHdr->sA4.abyAddr4,   /* payload of probresponse */
 				    (void *)pRxPacket
 );
 
 	}
 
-	if (bInScan) {
+	if (bInScan)
 		return;
-	}
 
 	if (byCurrChannel == (unsigned char)pMgmt->uCurrChannel)
 		bIsChannelEqual = true;
 
 	if (bIsChannelEqual && (pMgmt->eCurrMode == WMAC_MODE_ESS_AP)) {
-		// if rx beacon without ERP field
+		/* if rx beacon without ERP field */
 		if (sERP.bERPExist) {
 			if (WLAN_GET_ERP_USE_PROTECTION(sERP.byERP)) {
 				pDevice->byERPFlag |= WLAN_SET_ERP_USE_PROTECTION(1);
@@ -1920,7 +1908,7 @@ s_vMgrRxBeacon(
 				pDevice->byERPFlag |= WLAN_SET_ERP_NONERP_PRESENT(1);
 		}
 
-		// set to MAC&BBP
+		/* set to MAC&BBP */
 		if (WLAN_GET_ERP_USE_PROTECTION(pDevice->byERPFlag)) {
 			if (!pDevice->bProtectMode) {
 				MACvEnableProtectMD(pDevice->PortOffset);
@@ -1932,22 +1920,22 @@ s_vMgrRxBeacon(
 	if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP)
 		return;
 
-	// check if BSSID the same
+	/* check if BSSID the same */
 	if (memcmp(sFrame.pHdr->sA3.abyAddr3,
 		   pMgmt->abyCurrBSSID,
 		   WLAN_BSSID_LEN) == 0) {
 		bIsBSSIDEqual = true;
 
-// 2008-05-21 <add> by Richardtai
+/* 2008-05-21 <add> by Richardtai */
 		pDevice->uCurrRSSI = pRxPacket->uRSSI;
 		pDevice->byCurrSQ = pRxPacket->bySQ;
 
 		if (pMgmt->sNodeDBTable[0].uInActiveCount != 0) {
 			pMgmt->sNodeDBTable[0].uInActiveCount = 0;
-			//DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BCN:Wake Count= [%d]\n", pMgmt->wCountToWakeUp);
+			/* DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BCN:Wake Count= [%d]\n", pMgmt->wCountToWakeUp); */
 		}
 	}
-	// check if SSID the same
+	/* check if SSID the same */
 	if (sFrame.pSSID->len == ((PWLAN_IE_SSID)pMgmt->abyCurrSSID)->len) {
 		if (memcmp(sFrame.pSSID->abySSID,
 			   ((PWLAN_IE_SSID)pMgmt->abyCurrSSID)->abySSID,
@@ -1962,12 +1950,12 @@ s_vMgrRxBeacon(
 	    bIsSSIDEqual &&
 	    (pMgmt->eCurrMode == WMAC_MODE_ESS_STA) &&
 	    (pMgmt->eCurrState == WMAC_STATE_ASSOC)) {
-		// add state check to prevent reconnect fail since we'll receive Beacon
+		/* add state check to prevent reconnect fail since we'll receive Beacon */
 
 		bIsAPBeacon = true;
 
 		if (pBSSList != NULL) {
-			// Compare PHY parameter setting
+			/* Compare PHY parameter setting */
 			if (pMgmt->wCurrCapInfo != pBSSList->wCapInfo) {
 				bUpdatePhyParameter = true;
 				pMgmt->wCurrCapInfo = pBSSList->wCapInfo;
@@ -1979,12 +1967,9 @@ s_vMgrRxBeacon(
 					pMgmt->byERPContext = sFrame.pERP->byContext;
 				}
 			}
-			//
-			// Basic Rate Set may change dynamically
-			//
-			if (pBSSList->eNetworkTypeInUse == PHY_TYPE_11B) {
+			/* Basic Rate Set may change dynamically */
+			if (pBSSList->eNetworkTypeInUse == PHY_TYPE_11B)
 				uRateLen = WLAN_RATES_MAXLEN_11B;
-			}
 			pMgmt->abyCurrSuppRates[1] = RATEuSetIE((PWLAN_IE_SUPP_RATES)pBSSList->abySuppRates,
 								(PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
 								uRateLen);
@@ -2029,12 +2014,12 @@ s_vMgrRxBeacon(
 		}
 	}
 
-//    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Beacon 2 \n");
-	// check if CF field exists
+/*    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Beacon 2\n"); */
+	/* check if CF field exists */
 	if (WLAN_GET_CAP_INFO_ESS(*sFrame.pwCapInfo)) {
-		if (sFrame.pCFParms->wCFPDurRemaining > 0) {
-			// TODO: deal with CFP period to set NAV
-		}
+		if (sFrame.pCFParms->wCFPDurRemaining > 0)
+			/* TODO: deal with CFP period to set NAV */
+			;
 	}
 
 	HIDWORD(qwTimestamp) = cpu_to_le32(HIDWORD(*sFrame.pqwTimestamp));
@@ -2042,51 +2027,48 @@ s_vMgrRxBeacon(
 	HIDWORD(qwLocalTSF) = HIDWORD(pRxPacket->qwLocalTSF);
 	LODWORD(qwLocalTSF) = LODWORD(pRxPacket->qwLocalTSF);
 
-	// check if beacon TSF larger or small than our local TSF
+	/* check if beacon TSF larger or small than our local TSF */
 	if (HIDWORD(qwTimestamp) == HIDWORD(qwLocalTSF)) {
-		if (LODWORD(qwTimestamp) >= LODWORD(qwLocalTSF)) {
+		if (LODWORD(qwTimestamp) >= LODWORD(qwLocalTSF))
 			bTSFOffsetPostive = true;
-		} else {
+		else
 			bTSFOffsetPostive = false;
-		}
-	} else if (HIDWORD(qwTimestamp) > HIDWORD(qwLocalTSF)) {
+	} else if (HIDWORD(qwTimestamp) > HIDWORD(qwLocalTSF))
 		bTSFOffsetPostive = true;
-	} else if (HIDWORD(qwTimestamp) < HIDWORD(qwLocalTSF)) {
+	else if (HIDWORD(qwTimestamp) < HIDWORD(qwLocalTSF))
 		bTSFOffsetPostive = false;
-	}
 
-	if (bTSFOffsetPostive) {
+	if (bTSFOffsetPostive)
 		qwTSFOffset = CARDqGetTSFOffset(pRxPacket->byRxRate, (qwTimestamp), (qwLocalTSF));
-	} else {
+	else
 		qwTSFOffset = CARDqGetTSFOffset(pRxPacket->byRxRate, (qwLocalTSF), (qwTimestamp));
-	}
 
 	if (HIDWORD(qwTSFOffset) != 0 ||
 	    (LODWORD(qwTSFOffset) > TRIVIAL_SYNC_DIFFERENCE)) {
 		bTSFLargeDiff = true;
 	}
 
-	// if infra mode
+	/* if infra mode */
 	if (bIsAPBeacon) {
-		// Infra mode: Local TSF always follow AP's TSF if Difference huge.
+		/* Infra mode: Local TSF always follow AP's TSF if Difference huge. */
 		if (bTSFLargeDiff)
 			bUpdateTSF = true;
 
 		if (pDevice->bEnablePSMode && (sFrame.pTIM != 0)) {
-			// deal with DTIM, analysis TIM
+			/* deal with DTIM, analysis TIM */
 			pMgmt->bMulticastTIM = WLAN_MGMT_IS_MULTICAST_TIM(sFrame.pTIM->byBitMapCtl) ? true : false;
 			pMgmt->byDTIMCount = sFrame.pTIM->byDTIMCount;
 			pMgmt->byDTIMPeriod = sFrame.pTIM->byDTIMPeriod;
 			wAIDNumber = pMgmt->wCurrAID & ~(BIT14|BIT15);
 
-			// check if AID in TIM field bit on
-			// wStartIndex = N1
+			/* check if AID in TIM field bit on */
+			/* wStartIndex = N1 */
 			wStartIndex = WLAN_MGMT_GET_TIM_OFFSET(sFrame.pTIM->byBitMapCtl) << 1;
-			// AIDIndex = N2
+			/* AIDIndex = N2 */
 			wAIDIndex = (wAIDNumber >> 3);
 			if ((wAIDNumber > 0) && (wAIDIndex >= wStartIndex)) {
 				uLocateByteIndex = wAIDIndex - wStartIndex;
-				// len = byDTIMCount + byDTIMPeriod + byDTIMPeriod + byVirtBitMap[0~250]
+				/* len = byDTIMCount + byDTIMPeriod + byDTIMPeriod + byVirtBitMap[0~250] */
 				if (sFrame.pTIM->len >= (uLocateByteIndex + 4)) {
 					byTIMBitOn  = (0x01) << ((wAIDNumber) % 8);
 					pMgmt->bInTIM = sFrame.pTIM->byVirtBitMap[uLocateByteIndex] & byTIMBitOn ? true : false;
@@ -2100,11 +2082,11 @@ s_vMgrRxBeacon(
 			if (pMgmt->bInTIM ||
 			    (pMgmt->bMulticastTIM && (pMgmt->byDTIMCount == 0))) {
 				pMgmt->bInTIMWake = true;
-				// send out ps-poll packet
-//                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BCN:In TIM\n");
+				/* send out ps-poll packet */
+/*                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BCN:In TIM\n"); */
 				if (pMgmt->bInTIM) {
 					PSvSendPSPOLL((PSDevice)pDevice);
-//                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BCN:PS-POLL sent..\n");
+/*                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BCN:PS-POLL sent..\n"); */
 				}
 
 			} else {
@@ -2115,30 +2097,30 @@ s_vMgrRxBeacon(
 					if (PSbSendNullPacket(pDevice))
 						pDevice->bPWBitOn = true;
 				}
-				if (PSbConsiderPowerDown(pDevice, false, false)) {
+				if (PSbConsiderPowerDown(pDevice, false, false))
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BCN: Power down now...\n");
-				}
 			}
 
 		}
 
 	}
-	// if adhoc mode
+	/* if adhoc mode */
 	if ((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) && !bIsAPBeacon && bIsChannelEqual) {
 		if (bIsBSSIDEqual) {
-			// Use sNodeDBTable[0].uInActiveCount as IBSS beacons received count.
+			/* Use sNodeDBTable[0].uInActiveCount as IBSS beacons received count. */
 			if (pMgmt->sNodeDBTable[0].uInActiveCount != 0)
 				pMgmt->sNodeDBTable[0].uInActiveCount = 0;
 
-			// adhoc mode:TSF updated only when beacon larger than local TSF
+			/* adhoc mode:TSF updated only when beacon larger than local TSF */
 			if (bTSFLargeDiff && bTSFOffsetPostive &&
 			    (pMgmt->eCurrState == WMAC_STATE_JOINTED))
 				bUpdateTSF = true;
 
-			// During dpc, already in spinlocked.
+			/* During dpc, already in spinlocked. */
 			if (BSSDBbIsSTAInNodeDB(pMgmt, sFrame.pHdr->sA3.abyAddr2, &uNodeIndex)) {
-				// Update the STA, (Technically the Beacons of all the IBSS nodes
-				// should be identical, but that's not happening in practice.
+				/* Update the STA, (Technically the Beacons of all the IBSS nodes
+				 * should be identical, but that's not happening in practice.
+				 */
 				pMgmt->abyCurrSuppRates[1] = RATEuSetIE((PWLAN_IE_SUPP_RATES)sFrame.pSuppRates,
 									(PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
 									WLAN_RATES_MAXLEN_11B);
@@ -2156,7 +2138,7 @@ s_vMgrRxBeacon(
 				pMgmt->sNodeDBTable[uNodeIndex].bShortSlotTime = WLAN_GET_CAP_INFO_SHORTSLOTTIME(*sFrame.pwCapInfo);
 				pMgmt->sNodeDBTable[uNodeIndex].uInActiveCount = 0;
 			} else {
-				// Todo, initial Node content
+				/* Todo, initial Node content */
 				BSSvCreateOneNode((PSDevice)pDevice, &uNodeIndex);
 
 				pMgmt->abyCurrSuppRates[1] = RATEuSetIE((PWLAN_IE_SUPP_RATES)sFrame.pSuppRates,
@@ -2178,7 +2160,10 @@ s_vMgrRxBeacon(
 				pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate = pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate;
 #ifdef	PLICE_DEBUG
 				{
-					printk("s_vMgrRxBeacon:TxDataRate is %d,Index is %d\n", pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate, uNodeIndex);
+					printk(KERN_DEBUG
+					       "s_vMgrRxBeacon:TxDataRate is %d,Index is %d\n",
+					       pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate,
+					       uNodeIndex);
 				}
 #endif
 /*
@@ -2188,26 +2173,28 @@ s_vMgrRxBeacon(
 */
 			}
 
-			// if other stations joined, indicate connection to upper layer..
+			/* if other stations joined, indicate connection to upper layer.. */
 			if (pMgmt->eCurrState == WMAC_STATE_STARTED) {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Current IBSS State: [Started]........to: [Jointed] \n");
+				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+					"Current IBSS State: [Started]........to: [Jointed]\n");
 				pMgmt->eCurrState = WMAC_STATE_JOINTED;
 				pDevice->bLinkPass = true;
-				if (netif_queue_stopped(pDevice->dev)) {
+				if (netif_queue_stopped(pDevice->dev))
 					netif_wake_queue(pDevice->dev);
-				}
 				pMgmt->sNodeDBTable[0].bActive = true;
 				pMgmt->sNodeDBTable[0].uInActiveCount = 0;
 
 			}
 		} else if (bIsSSIDEqual) {
-			// See other adhoc sta with the same SSID but BSSID is different.
-			// adpot this vars only when TSF larger then us.
+			/* See other adhoc sta with the same SSID but BSSID is different.
+			 * adpot this vars only when TSF larger then us.
+			 */
 			if (bTSFLargeDiff && bTSFOffsetPostive) {
-				// we don't support ATIM under adhoc mode
-				// if (sFrame.pIBSSParms->wATIMWindow == 0) {
-				// adpot this vars
-				// TODO: check sFrame cap if privacy on, and support rate syn
+				/* we don't support ATIM under adhoc mode
+				 * if (sFrame.pIBSSParms->wATIMWindow == 0) {
+				 * adpot this vars
+				 * TODO: check sFrame cap if privacy on, and support rate syn
+				 */
 				memcpy(pMgmt->abyCurrBSSID, sFrame.pHdr->sA3.abyAddr3, WLAN_BSSID_LEN);
 				memcpy(pDevice->abyBSSID, pMgmt->abyCurrBSSID, WLAN_BSSID_LEN);
 				pMgmt->wCurrATIMWindow = cpu_to_le16(sFrame.pIBSSParms->wATIMWindow);
@@ -2215,12 +2202,12 @@ s_vMgrRxBeacon(
 				pMgmt->abyCurrSuppRates[1] = RATEuSetIE((PWLAN_IE_SUPP_RATES)sFrame.pSuppRates,
 									(PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
 									WLAN_RATES_MAXLEN_11B);
-				// set HW beacon interval and re-synchronizing....
+				/* set HW beacon interval and re-synchronizing.... */
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Rejoining to Other Adhoc group with same SSID........\n");
 				VNSvOutPortW(pDevice->PortOffset + MAC_REG_BI, pMgmt->wCurrBeaconPeriod);
 				CARDbUpdateTSF(pDevice, pRxPacket->byRxRate, qwTimestamp, qwLocalTSF);
 				CARDvUpdateNextTBTT(pDevice->PortOffset, qwTimestamp, pMgmt->wCurrBeaconPeriod);
-				// Turn off bssid filter to avoid filter others adhoc station which bssid is different.
+				/* Turn off bssid filter to avoid filter others adhoc station which bssid is different. */
 				MACvWriteBSSIDAddress(pDevice->PortOffset, pMgmt->abyCurrBSSID);
 
 				CARDbSetPhyParameter(pMgmt->pAdapter,
@@ -2230,17 +2217,19 @@ s_vMgrRxBeacon(
 						     pMgmt->abyCurrSuppRates,
 						     pMgmt->abyCurrExtSuppRates);
 
-				// MACvRegBitsOff(pDevice->PortOffset, MAC_REG_RCR, RCR_BSSID);
-				// set highest basic rate
-				// s_vSetHighestBasicRate(pDevice, (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates);
-				// Prepare beacon frame
+				/* MACvRegBitsOff(pDevice->PortOffset, MAC_REG_RCR, RCR_BSSID); */
+				/* set highest basic rate
+				 * s_vSetHighestBasicRate(pDevice, (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates);
+				 * Prepare beacon frame
+				 */
 				bMgrPrepareBeaconToSend((void *)pDevice, pMgmt);
-				//  }
+				/*  } */
 			}
 		}
 	}
-	// endian issue ???
-	// Update TSF
+	/* endian issue ???
+	 * Update TSF
+	 */
 if (bUpdateTSF) {
 		CARDbGetCurrentTSF(pDevice->PortOffset, &qwCurrTSF);
 		CARDbUpdateTSF(pDevice, pRxPacket->byRxRate, qwTimestamp, pRxPacket->qwLocalTSF);
@@ -2288,7 +2277,7 @@ vMgrCreateOwnIBSS(
 		if ((pMgmt->eAuthenMode == WMAC_AUTH_WPANONE) &&
 		    (pDevice->eEncryptionStatus != Ndis802_11Encryption2Enabled) &&
 		    (pDevice->eEncryptionStatus != Ndis802_11Encryption3Enabled)) {
-			// encryption mode error
+			/* encryption mode error */
 			*pStatus = CMD_STATUS_FAILURE;
 			return;
 		}
@@ -2331,26 +2320,26 @@ vMgrCreateOwnIBSS(
 			pMgmt->abyCurrExtSuppRates[2+ii] =  abyOFDM_RATE[ii+4];
 	}
 
-	// Disable Protect Mode
+	/* Disable Protect Mode */
 	pDevice->bProtectMode = false;
 	MACvDisableProtectMD(pDevice->PortOffset);
 
 	pDevice->bBarkerPreambleMd = false;
 	MACvDisableBarkerPreambleMd(pDevice->PortOffset);
 
-	// Kyle Test 2003.11.04
+	/* Kyle Test 2003.11.04 */
 
-	// set HW beacon interval
+	/* set HW beacon interval */
 	if (pMgmt->wIBSSBeaconPeriod == 0)
 		pMgmt->wIBSSBeaconPeriod = DEFAULT_IBSS_BI;
 
 	CARDbGetCurrentTSF(pDevice->PortOffset, &qwCurrTSF);
-	// clear TSF counter
+	/* clear TSF counter */
 	VNSvOutPortB(pDevice->PortOffset + MAC_REG_TFTCTL, TFTCTL_TSFCNTRST);
-	// enable TSF counter
+	/* enable TSF counter */
 	VNSvOutPortB(pDevice->PortOffset + MAC_REG_TFTCTL, TFTCTL_TSFCNTREN);
 
-	// set Next TBTT
+	/* set Next TBTT */
 	CARDvSetFirstNextTBTT(pDevice->PortOffset, pMgmt->wIBSSBeaconPeriod);
 
 	pMgmt->uIBSSChannel = pDevice->uChannel;
@@ -2358,16 +2347,15 @@ vMgrCreateOwnIBSS(
 	if (pMgmt->uIBSSChannel == 0)
 		pMgmt->uIBSSChannel = DEFAULT_IBSS_CHANNEL;
 
-	// set basic rate
+	/* set basic rate */
 
 	RATEvParseMaxRate((void *)pDevice, (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
 			  (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrExtSuppRates, true,
 			  &wMaxBasicRate, &wMaxSuppRate, &wSuppRate,
 			  &byTopCCKBasicRate, &byTopOFDMBasicRate);
 
-	if (pMgmt->eConfigMode == WMAC_CONFIG_AP) {
+	if (pMgmt->eConfigMode == WMAC_CONFIG_AP)
 		pMgmt->eCurrMode = WMAC_MODE_ESS_AP;
-	}
 
 	if (pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) {
 		memcpy(pMgmt->abyIBSSDFSOwner, pDevice->abyCurrentNetAddr, 6);
@@ -2375,7 +2363,7 @@ vMgrCreateOwnIBSS(
 		pMgmt->eCurrMode = WMAC_MODE_IBSS_STA;
 	}
 
-	// Adopt pre-configured IBSS vars to current vars
+	/* Adopt pre-configured IBSS vars to current vars */
 	pMgmt->eCurrState = WMAC_STATE_STARTED;
 	pMgmt->wCurrBeaconPeriod = pMgmt->wIBSSBeaconPeriod;
 	pMgmt->uCurrChannel = pMgmt->uIBSSChannel;
@@ -2383,8 +2371,9 @@ vMgrCreateOwnIBSS(
 	MACvWriteATIMW(pDevice->PortOffset, pMgmt->wCurrATIMWindow);
 	pDevice->uCurrRSSI = 0;
 	pDevice->byCurrSQ = 0;
-	//memcpy(pMgmt->abyDesireSSID,pMgmt->abyAdHocSSID,
-	// ((PWLAN_IE_SSID)pMgmt->abyAdHocSSID)->len + WLAN_IEHDR_LEN);
+	/* memcpy(pMgmt->abyDesireSSID,pMgmt->abyAdHocSSID,
+	 * ((PWLAN_IE_SSID)pMgmt->abyAdHocSSID)->len + WLAN_IEHDR_LEN);
+	 */
 	memset(pMgmt->abyCurrSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
 	memcpy(pMgmt->abyCurrSSID,
 	       pMgmt->abyDesireSSID,
@@ -2392,14 +2381,14 @@ vMgrCreateOwnIBSS(
 );
 
 	if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
-		// AP mode BSSID = MAC addr
+		/* AP mode BSSID = MAC addr */
 		memcpy(pMgmt->abyCurrBSSID, pMgmt->abyMACAddr, WLAN_ADDR_LEN);
 		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "AP beacon created BSSID:%pM\n",
 			pMgmt->abyCurrBSSID);
 	}
 
 	if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) {
-		// BSSID selected must be randomized as spec 11.1.3
+		/* BSSID selected must be randomized as spec 11.1.3 */
 		pMgmt->abyCurrBSSID[5] = (unsigned char) (LODWORD(qwCurrTSF) & 0x000000ff);
 		pMgmt->abyCurrBSSID[4] = (unsigned char)((LODWORD(qwCurrTSF) & 0x0000ff00) >> 8);
 		pMgmt->abyCurrBSSID[3] = (unsigned char)((LODWORD(qwCurrTSF) & 0x00ff0000) >> 16);
@@ -2419,7 +2408,7 @@ vMgrCreateOwnIBSS(
 			pMgmt->abyCurrBSSID);
 	}
 
-	// Set Capability Info
+	/* Set Capability Info */
 	pMgmt->wCurrCapInfo = 0;
 
 	if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
@@ -2428,9 +2417,8 @@ vMgrCreateOwnIBSS(
 		pMgmt->byDTIMCount = pMgmt->byDTIMPeriod - 1;
 	}
 
-	if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) {
+	if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA)
 		pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_IBSS(1);
-	}
 
 	if (pDevice->bEncryptionEnable) {
 		pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_PRIVACY(1);
@@ -2453,13 +2441,12 @@ vMgrCreateOwnIBSS(
 
 	pMgmt->byERPContext = 0;
 
-//    memcpy(pDevice->abyBSSID, pMgmt->abyCurrBSSID, WLAN_BSSID_LEN);
+/*    memcpy(pDevice->abyBSSID, pMgmt->abyCurrBSSID, WLAN_BSSID_LEN); */
 
-	if (pMgmt->eConfigMode == WMAC_CONFIG_AP) {
+	if (pMgmt->eConfigMode == WMAC_CONFIG_AP)
 		CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, OP_MODE_AP);
-	} else {
+	else
 		CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, OP_MODE_ADHOC);
-	}
 
 	CARDbSetPhyParameter(pMgmt->pAdapter,
 			     pMgmt->eCurrentPHYMode,
@@ -2470,28 +2457,25 @@ vMgrCreateOwnIBSS(
 		);
 
 	CARDbSetBeaconPeriod(pMgmt->pAdapter, pMgmt->wIBSSBeaconPeriod);
-	// set channel and clear NAV
+	/* set channel and clear NAV */
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
-	    (pMgmt->eCurrentPHYMode == PHY_TYPE_11A)) {
+	    (pMgmt->eCurrentPHYMode == PHY_TYPE_11A))
 		pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_SPECTRUMMNG(1);
-	} else {
+	else
 		pMgmt->wCurrCapInfo &= (~WLAN_SET_CAP_INFO_SPECTRUMMNG(1));
-	}
 
 	pMgmt->eCurrState = WMAC_STATE_STARTED;
-	// Prepare beacon to send
-	if (bMgrPrepareBeaconToSend((void *)pDevice, pMgmt)) {
+	/* Prepare beacon to send */
+	if (bMgrPrepareBeaconToSend((void *)pDevice, pMgmt))
 		*pStatus = CMD_STATUS_SUCCESS;
-	}
 
 	return;
 }
@@ -2540,8 +2524,8 @@ vMgrJoinBSSBegin(
 		return;
 	}
 
-	// memset(pMgmt->abyDesireBSSID, 0,  WLAN_BSSID_LEN);
-	// Search known BSS list for prefer BSSID or SSID
+	/* memset(pMgmt->abyDesireBSSID, 0,  WLAN_BSSID_LEN); */
+	/* Search known BSS list for prefer BSSID or SSID */
 
 	pCurr = BSSpSearchBSSList(pDevice,
 				  pMgmt->abyDesireBSSID,
@@ -2559,30 +2543,30 @@ vMgrJoinBSSBegin(
 	DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "AP(BSS) finding:Found a AP(BSS)..\n");
 	if (WLAN_GET_CAP_INFO_ESS(cpu_to_le16(pCurr->wCapInfo))) {
 		if ((pMgmt->eAuthenMode == WMAC_AUTH_WPA) || (pMgmt->eAuthenMode == WMAC_AUTH_WPAPSK)) {
-			// patch for CISCO migration mode
+			/* patch for CISCO migration mode */
 /*
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
+ *  if (pDevice->eEncryptionStatus == Ndis802_11Encryption2Enabled) {
+ *  if (WPA_SearchRSN(0, WPA_TKIP, pCurr) == false) {
+ *  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "No match RSN info. ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n");
+ *  // encryption mode error
+ *  pMgmt->eCurrState = WMAC_STATE_IDLE;
+ *  return;
+ *  }
+ *  } else if (pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled) {
+ *  if (WPA_SearchRSN(0, WPA_AESCCMP, pCurr) == false) {
+ *  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "No match RSN info. ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n");
+ *  // encryption mode error
+ *  pMgmt->eCurrState = WMAC_STATE_IDLE;
+ *  return;
+ *  }
+ *  }
+ */
 		}
 
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 		Encyption_Rebuild(pDevice, pCurr);
 #endif
-		// Infrastructure BSS
+		/* Infrastructure BSS */
 		s_vMgrSynchBSS(pDevice,
 			       WMAC_MODE_ESS_STA,
 			       pCurr,
@@ -2590,31 +2574,30 @@ vMgrJoinBSSBegin(
 );
 
 		if (*pStatus == CMD_STATUS_SUCCESS) {
-			// Adopt this BSS state vars in Mgmt Object
+			/* Adopt this BSS state vars in Mgmt Object */
 			pMgmt->uCurrChannel = pCurr->uChannel;
 
 			memset(pMgmt->abyCurrSuppRates, 0 , WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1);
 			memset(pMgmt->abyCurrExtSuppRates, 0 , WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1);
 
-			if (pCurr->eNetworkTypeInUse == PHY_TYPE_11B) {
+			if (pCurr->eNetworkTypeInUse == PHY_TYPE_11B)
 				uRateLen = WLAN_RATES_MAXLEN_11B;
-			}
 
 			pItemRates = (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates;
 			pItemExtRates = (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrExtSuppRates;
 
-			// Parse Support Rate IE
+			/* Parse Support Rate IE */
 			pItemRates->byElementID = WLAN_EID_SUPP_RATES;
 			pItemRates->len = RATEuSetIE((PWLAN_IE_SUPP_RATES)pCurr->abySuppRates,
 						     pItemRates,
 						     uRateLen);
 
-			// Parse Extension Support Rate IE
+			/* Parse Extension Support Rate IE */
 			pItemExtRates->byElementID = WLAN_EID_EXTSUPP_RATES;
 			pItemExtRates->len = RATEuSetIE((PWLAN_IE_SUPP_RATES)pCurr->abyExtSuppRates,
 							pItemExtRates,
 							uRateLen);
-			// Stuffing Rate IE
+			/* Stuffing Rate IE */
 			if ((pItemExtRates->len > 0) && (pItemRates->len < 8)) {
 				for (ii = 0; ii < (unsigned int)(8 - pItemRates->len);) {
 					pItemRates->abyRates[pItemRates->len + ii] = pItemExtRates->abyRates[ii];
@@ -2625,9 +2608,8 @@ vMgrJoinBSSBegin(
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
@@ -2637,8 +2619,8 @@ vMgrJoinBSSBegin(
 					  &wMaxBasicRate, &wMaxSuppRate, &wSuppRate,
 					  &byTopCCKBasicRate, &byTopOFDMBasicRate);
 
-			// TODO: deal with if wCapInfo the privacy is on, but station WEP is off
-			// TODO: deal with if wCapInfo the PS-Pollable is on.
+			/* TODO: deal with if wCapInfo the privacy is on, but station WEP is off */
+			/* TODO: deal with if wCapInfo the PS-Pollable is on. */
 			pMgmt->wCurrBeaconPeriod = pCurr->wBeaconInterval;
 			memset(pMgmt->abyCurrSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
 			memcpy(pMgmt->abyCurrBSSID, pCurr->abyBSSID, WLAN_BSSID_LEN);
@@ -2647,12 +2629,14 @@ vMgrJoinBSSBegin(
 			pMgmt->eCurrMode = WMAC_MODE_ESS_STA;
 
 			pMgmt->eCurrState = WMAC_STATE_JOINTED;
-			// Adopt BSS state in Adapter Device Object
-			//pDevice->byOpMode = OP_MODE_INFRASTRUCTURE;
-//            memcpy(pDevice->abyBSSID, pCurr->abyBSSID, WLAN_BSSID_LEN);
-
-			// Add current BSS to Candidate list
-			// This should only works for WPA2 BSS, and WPA2 BSS check must be done before.
+			/* Adopt BSS state in Adapter Device Object
+			 * pDevice->byOpMode = OP_MODE_INFRASTRUCTURE;
+			 * memcpy(pDevice->abyBSSID, pCurr->abyBSSID, WLAN_BSSID_LEN);
+			 */
+
+			/* Add current BSS to Candidate list
+			 * This should only works for WPA2 BSS, and WPA2 BSS check must be done before.
+			 */
 			if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2) {
 				bool bResult = bAdd_PMKID_Candidate((void *)pDevice, pMgmt->abyCurrBSSID, &pCurr->sRSNCapObj);
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bAdd_PMKID_Candidate: 1(%d)\n", bResult);
@@ -2663,8 +2647,9 @@ vMgrJoinBSSBegin(
 				}
 			}
 
-			// Preamble type auto-switch: if AP can receive short-preamble cap,
-			// we can turn on too.
+			/* Preamble type auto-switch: if AP can receive short-preamble cap,
+			 * we can turn on too.
+			 */
 
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Join ESS\n");
 
@@ -2674,22 +2659,22 @@ vMgrJoinBSSBegin(
 		}
 
 	} else {
-		// ad-hoc mode BSS
+		/* ad-hoc mode BSS */
 		if (pMgmt->eAuthenMode == WMAC_AUTH_WPANONE) {
 			if (pDevice->eEncryptionStatus == Ndis802_11Encryption2Enabled) {
 				if (!WPA_SearchRSN(0, WPA_TKIP, pCurr)) {
-					// encryption mode error
+					/* encryption mode error */
 					pMgmt->eCurrState = WMAC_STATE_IDLE;
 					return;
 				}
 			} else if (pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled) {
 				if (!WPA_SearchRSN(0, WPA_AESCCMP, pCurr)) {
-					// encryption mode error
+					/* encryption mode error */
 					pMgmt->eCurrState = WMAC_STATE_IDLE;
 					return;
 				}
 			} else {
-				// encryption mode error
+				/* encryption mode error */
 				pMgmt->eCurrState = WMAC_STATE_IDLE;
 				return;
 			}
@@ -2702,16 +2687,16 @@ vMgrJoinBSSBegin(
 );
 
 		if (*pStatus == CMD_STATUS_SUCCESS) {
-			// Adopt this BSS state vars in Mgmt Object
-			// TODO: check if CapInfo privacy on, but we don't..
+			/* Adopt this BSS state vars in Mgmt Object */
+			/* TODO: check if CapInfo privacy on, but we don't.. */
 			pMgmt->uCurrChannel = pCurr->uChannel;
 
-			// Parse Support Rate IE
+			/* Parse Support Rate IE */
 			pMgmt->abyCurrSuppRates[0] = WLAN_EID_SUPP_RATES;
 			pMgmt->abyCurrSuppRates[1] = RATEuSetIE((PWLAN_IE_SUPP_RATES)pCurr->abySuppRates,
 								(PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
 								WLAN_RATES_MAXLEN_11B);
-			// set basic rate
+			/* set basic rate */
 			RATEvParseMaxRate((void *)pDevice, (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
 					  NULL, true, &wMaxBasicRate, &wMaxSuppRate, &wSuppRate,
 					  &byTopCCKBasicRate, &byTopOFDMBasicRate);
@@ -2721,22 +2706,24 @@ vMgrJoinBSSBegin(
 			memset(pMgmt->abyCurrSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN);
 			memcpy(pMgmt->abyCurrBSSID, pCurr->abyBSSID, WLAN_BSSID_LEN);
 			memcpy(pMgmt->abyCurrSSID, pCurr->abySSID, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN);
-//          pMgmt->wCurrATIMWindow = pCurr->wATIMWindow;
+/*          pMgmt->wCurrATIMWindow = pCurr->wATIMWindow; */
 			MACvWriteATIMW(pDevice->PortOffset, pMgmt->wCurrATIMWindow);
 			pMgmt->eCurrMode = WMAC_MODE_IBSS_STA;
 
 			pMgmt->eCurrState = WMAC_STATE_STARTED;
-			// Adopt BSS state in Adapter Device Object
-			//pDevice->byOpMode = OP_MODE_ADHOC;
-//            pDevice->bLinkPass = true;
-//            memcpy(pDevice->abyBSSID, pCurr->abyBSSID, WLAN_BSSID_LEN);
+			/* Adopt BSS state in Adapter Device Object
+			 * pDevice->byOpMode = OP_MODE_ADHOC;
+			 * pDevice->bLinkPass = true;
+			 * memcpy(pDevice->abyBSSID, pCurr->abyBSSID, WLAN_BSSID_LEN);
+			 */
 
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Join IBSS ok:%pM\n",
 				pMgmt->abyCurrBSSID);
-			// Preamble type auto-switch: if AP can receive short-preamble cap,
-			// and if registry setting is short preamble we can turn on too.
+			/* Preamble type auto-switch: if AP can receive short-preamble cap,
+			 * and if registry setting is short preamble we can turn on too.
+			 */
 
-			// Prepare beacon
+			/* Prepare beacon */
 			bMgrPrepareBeaconToSend((void *)pDevice, pMgmt);
 		} else {
 			pMgmt->eCurrState = WMAC_STATE_IDLE;
@@ -2766,11 +2753,11 @@ s_vMgrSynchBSS(
 {
 	CARD_PHY_TYPE   ePhyType = PHY_TYPE_11B;
 	PSMgmtObject  pMgmt = pDevice->pMgmt;
-//    int     ii;
-	//1M,   2M,   5M,   11M,  18M,  24M,  36M,  54M
+/*    int     ii; */
+	/* 1M,   2M,   5M,   11M,  18M,  24M,  36M,  54M */
 	unsigned char abyCurrSuppRatesG[] = {WLAN_EID_SUPP_RATES, 8, 0x02, 0x04, 0x0B, 0x16, 0x24, 0x30, 0x48, 0x6C};
 	unsigned char abyCurrExtSuppRatesG[] = {WLAN_EID_EXTSUPP_RATES, 4, 0x0C, 0x12, 0x18, 0x60};
-	//6M,   9M,   12M,  48M
+	/* 6M,   9M,   12M,  48M */
 	unsigned char abyCurrSuppRatesA[] = {WLAN_EID_SUPP_RATES, 8, 0x0C, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C};
 	unsigned char abyCurrSuppRatesB[] = {WLAN_EID_SUPP_RATES, 4, 0x02, 0x04, 0x0B, 0x16};
 
@@ -2786,13 +2773,13 @@ s_vMgrSynchBSS(
 
 	pMgmt->pCurrBSS = pCurr;
 
-	// if previous mode is IBSS.
+	/* if previous mode is IBSS. */
 	if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) {
 		MACvRegBitsOff(pDevice->PortOffset, MAC_REG_BCNDMACTL, BEACON_READY);
 		MACvRegBitsOff(pDevice->PortOffset, MAC_REG_TCR, TCR_AUTOBCNTX);
 	}
 
-	// Init the BSS informations
+	/* Init the BSS informations */
 	pDevice->bCCK = true;
 	pDevice->bProtectMode = false;
 	MACvDisableProtectMD(pDevice->PortOffset);
@@ -2801,25 +2788,26 @@ s_vMgrSynchBSS(
 	pDevice->bNonERPPresent = false;
 	pDevice->byPreambleType = 0;
 	pDevice->wBasicRate = 0;
-	// Set Basic Rate
+	/* Set Basic Rate */
 	CARDbAddBasicRate((void *)pDevice, RATE_1M);
-	// calculate TSF offset
-	// TSF Offset = Received Timestamp TSF - Marked Local's TSF
+	/* calculate TSF offset */
+	/* TSF Offset = Received Timestamp TSF - Marked Local's TSF */
 	CARDbUpdateTSF(pDevice, pCurr->byRxRate, pCurr->qwBSSTimestamp, pCurr->qwLocalTSF);
 
 	CARDbSetBeaconPeriod(pDevice, pCurr->wBeaconInterval);
 
-	// set Next TBTT
-	// Next TBTT = ((local_current_TSF / beacon_interval) + 1) * beacon_interval
+	/* set Next TBTT */
+	/* Next TBTT = ((local_current_TSF / beacon_interval) + 1) * beacon_interval */
 	CARDvSetFirstNextTBTT(pDevice->PortOffset, pCurr->wBeaconInterval);
 
-	// set BSSID
+	/* set BSSID */
 	MACvWriteBSSIDAddress(pDevice->PortOffset, pCurr->abyBSSID);
 
 	MACvReadBSSIDAddress(pDevice->PortOffset, pMgmt->abyCurrBSSID);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Sync:set CurrBSSID address = "
-		"%pM\n", pMgmt->abyCurrBSSID);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+		"Sync:set CurrBSSID address = %pM\n",
+		pMgmt->abyCurrBSSID);
 
 	if (pCurr->eNetworkTypeInUse == PHY_TYPE_11A) {
 		if ((pMgmt->eConfigPHYMode == PHY_TYPE_11A) ||
@@ -2860,11 +2848,11 @@ s_vMgrSynchBSS(
 
 	if (WLAN_GET_CAP_INFO_ESS(pCurr->wCapInfo)) {
 		CARDbSetBSSID(pMgmt->pAdapter, pCurr->abyBSSID, OP_MODE_INFRASTRUCTURE);
-		// Add current BSS to Candidate list
-		// This should only works for WPA2 BSS, and WPA2 BSS check must be done before.
-		if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2) {
+		/* Add current BSS to Candidate list
+		 * This should only works for WPA2 BSS, and WPA2 BSS check must be done before.
+		 */
+		if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2)
 			CARDbAdd_PMKID_Candidate(pMgmt->pAdapter, pMgmt->abyCurrBSSID, pCurr->sRSNCapObj.bRSNCapExist, pCurr->sRSNCapObj.wRSNCap);
-		}
 	} else {
 		CARDbSetBSSID(pMgmt->pAdapter, pCurr->abyBSSID, OP_MODE_ADHOC);
 	}
@@ -2878,7 +2866,7 @@ s_vMgrSynchBSS(
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "<----s_bSynchBSS Set Phy Mode Fail [%d]\n", ePhyType);
 		return;
 	}
-	// set channel and clear NAV
+	/* set channel and clear NAV */
 	if (!set_channel(pMgmt->pAdapter, pCurr->uChannel)) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "<----s_bSynchBSS Set Channel [%d]\n", pCurr->uChannel);
 		return;
@@ -2893,13 +2881,13 @@ s_vMgrSynchBSS(
   }
 
   if (pDevice->byBBVGANew != pDevice->byBBVGACurrent) {
-  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "RSSI[%d] NewGain[%d] OldGain[%d] \n",
+  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "RSSI[%d] NewGain[%d] OldGain[%d]\n",
   (int)pCurr->ldBmMAX, pDevice->byBBVGANew, pDevice->byBBVGACurrent);
-  printk("RSSI[%d] NewGain[%d] OldGain[%d] \n",
+  printk("RSSI[%d] NewGain[%d] OldGain[%d]\n",
   (int)pCurr->ldBmMAX, pDevice->byBBVGANew, pDevice->byBBVGACurrent);
   BBvSetVGAGainOffset(pDevice, pDevice->byBBVGANew);
   }
-  printk("ldBmMAX[%d] NewGain[%d] OldGain[%d] \n",
+  printk("ldBmMAX[%d] NewGain[%d] OldGain[%d]\n",
   (int)pCurr->ldBmMAX, pDevice->byBBVGANew, pDevice->byBBVGACurrent);
 */
 	pMgmt->uCurrChannel = pCurr->uChannel;
@@ -2912,8 +2900,9 @@ s_vMgrSynchBSS(
 	return;
 };
 
-//mike add: fix NetworkManager 0.7.0 hidden ssid mode in WPA encryption
-//                   ,need reset eAuthenMode and eEncryptionStatus
+/* mike add: fix NetworkManager 0.7.0 hidden ssid mode in WPA encryption
+ *                   ,need reset eAuthenMode and eEncryptionStatus
+ */
 static void  Encyption_Rebuild(
 	PSDevice pDevice,
 	PKnownBSS pCurr
@@ -2921,29 +2910,36 @@ static void  Encyption_Rebuild(
 {
 	PSMgmtObject  pMgmt = &(pDevice->sMgmtObj);
 
-	if ((pMgmt->eAuthenMode == WMAC_AUTH_WPAPSK) ||           //networkmanager 0.7.0 does not give the pairwise-key selection,
-	    (pMgmt->eAuthenMode == WMAC_AUTH_WPA2PSK)) {         // so we need re-select it according to real pairwise-key info.
-		if (pCurr->bWPAValid)  {   //WPA-PSK
+	/* networkmanager 0.7.0 does not give the pairwise-key selection,
+	 * so we need re-select it according to real pairwise-key info.
+	 */
+	if ((pMgmt->eAuthenMode == WMAC_AUTH_WPAPSK) ||
+	    (pMgmt->eAuthenMode == WMAC_AUTH_WPA2PSK)) {
+		if (pCurr->bWPAValid)  {   /*WPA-PSK */
 			pMgmt->eAuthenMode = WMAC_AUTH_WPAPSK;
 			if (pCurr->abyPKType[0] == WPA_TKIP) {
-				pDevice->eEncryptionStatus = Ndis802_11Encryption2Enabled;    //TKIP
+				/* TKIP */
+				pDevice->eEncryptionStatus = Ndis802_11Encryption2Enabled;
 				PRINT_K("Encyption_Rebuild--->ssid reset config to [WPAPSK-TKIP]\n");
 			} else if (pCurr->abyPKType[0] == WPA_AESCCMP) {
-				pDevice->eEncryptionStatus = Ndis802_11Encryption3Enabled;    //AES
+				/* AES */
+				pDevice->eEncryptionStatus = Ndis802_11Encryption3Enabled;
 				PRINT_K("Encyption_Rebuild--->ssid reset config to [WPAPSK-AES]\n");
 			}
-		} else if (pCurr->bWPA2Valid) {  //WPA2-PSK
+		} else if (pCurr->bWPA2Valid) {  /*WPA2-PSK */
 			pMgmt->eAuthenMode = WMAC_AUTH_WPA2PSK;
 			if (pCurr->abyCSSPK[0] == WLAN_11i_CSS_TKIP) {
-				pDevice->eEncryptionStatus = Ndis802_11Encryption2Enabled;     //TKIP
+				/* TKIP */
+				pDevice->eEncryptionStatus = Ndis802_11Encryption2Enabled;
 				PRINT_K("Encyption_Rebuild--->ssid reset config to [WPA2PSK-TKIP]\n");
 			} else if (pCurr->abyCSSPK[0] == WLAN_11i_CSS_CCMP) {
-				pDevice->eEncryptionStatus = Ndis802_11Encryption3Enabled;    //AES
+				/* AES */
+				pDevice->eEncryptionStatus = Ndis802_11Encryption3Enabled;
 				PRINT_K("Encyption_Rebuild--->ssid reset config to [WPA2PSK-AES]\n");
 			}
 		}
 	}
-	//  }
+	/*  } */
 	return;
 }
 
@@ -2973,15 +2969,14 @@ s_vMgrFormatTIM(
 	unsigned short wStartIndex = 0;
 	unsigned short wEndIndex = 0;
 
-	// Find size of partial virtual bitmap
+	/* Find size of partial virtual bitmap */
 	for (ii = 0; ii < (MAX_NODE_NUM + 1); ii++) {
 		byMap = pMgmt->abyPSTxMap[ii];
 		if (!ii) {
-			// Mask out the broadcast bit which is indicated separately.
+			/* Mask out the broadcast bit which is indicated separately. */
 			bMulticast = (byMap & byMask[0]) != 0;
-			if (bMulticast) {
+			if (bMulticast)
 				pMgmt->sNodeDBTable[0].bRxPSPoll = true;
-			}
 			byMap = 0;
 		}
 		if (byMap) {
@@ -2993,29 +2988,28 @@ s_vMgrFormatTIM(
 		}
 	}
 
-	// Round start index down to nearest even number
+	/* Round start index down to nearest even number */
 	wStartIndex &=  ~BIT0;
 
-	// Round end index up to nearest even number
+	/* Round end index up to nearest even number */
 	wEndIndex = ((wEndIndex + 1) & ~BIT0);
 
-	// Size of element payload
+	/* Size of element payload */
 
 	pTIM->len =  3 + (wEndIndex - wStartIndex) + 1;
 
-	// Fill in the Fixed parts of the TIM
+	/* Fill in the Fixed parts of the TIM */
 	pTIM->byDTIMCount = pMgmt->byDTIMCount;
 	pTIM->byDTIMPeriod = pMgmt->byDTIMPeriod;
 	pTIM->byBitMapCtl = (bMulticast ? TIM_MULTICAST_MASK : 0) |
 		(((wStartIndex >> 1) << 1) & TIM_BITMAPOFFSET_MASK);
 
-	// Append variable part of TIM
+	/* Append variable part of TIM */
 
-	for (ii = wStartIndex, jj = 0; ii <= wEndIndex; ii++, jj++) {
+	for (ii = wStartIndex, jj = 0; ii <= wEndIndex; ii++, jj++)
 		pTIM->byVirtBitMap[jj] = pMgmt->abyPSTxMap[ii];
-	}
 
-	// Aid = 0 don't used.
+	/* Aid = 0 don't used. */
 	pTIM->byVirtBitMap[0]  &= ~BIT0;
 }
 
@@ -3053,45 +3047,44 @@ s_MgrMakeBeacon(
 	PWLAN_IE_IBSS_DFS   pIBSSDFS = NULL;
 	unsigned int ii;
 
-	// prepare beacon frame
+	/* prepare beacon frame */
 	pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
 	memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_BEACON_FR_MAXLEN);
 	pTxPacket->p80211Header = (union UWLAN_80211HDR *)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
-	// Setup the sFrame structure.
+	/* Setup the sFrame structure. */
 	sFrame.pBuf = (unsigned char *)pTxPacket->p80211Header;
 	sFrame.len = WLAN_BEACON_FR_MAXLEN;
 	vMgrEncodeBeacon(&sFrame);
-	// Setup the header
+	/* Setup the header */
 	sFrame.pHdr->sA3.wFrameCtl = cpu_to_le16(
 		(
 			WLAN_SET_FC_FTYPE(WLAN_TYPE_MGR) |
 			WLAN_SET_FC_FSTYPE(WLAN_FSTYPE_BEACON)
 ));
 
-	if (pDevice->bEnablePSMode) {
+	if (pDevice->bEnablePSMode)
 		sFrame.pHdr->sA3.wFrameCtl |= cpu_to_le16((unsigned short)WLAN_SET_FC_PWRMGT(1));
-	}
 
 	memcpy(sFrame.pHdr->sA3.abyAddr1, abyBroadcastAddr, WLAN_ADDR_LEN);
 	memcpy(sFrame.pHdr->sA3.abyAddr2, pMgmt->abyMACAddr, WLAN_ADDR_LEN);
 	memcpy(sFrame.pHdr->sA3.abyAddr3, pCurrBSSID, WLAN_BSSID_LEN);
 	*sFrame.pwBeaconInterval = cpu_to_le16(wCurrBeaconPeriod);
 	*sFrame.pwCapInfo = cpu_to_le16(wCurrCapInfo);
-	// Copy SSID
+	/* Copy SSID */
 	sFrame.pSSID = (PWLAN_IE_SSID)(sFrame.pBuf + sFrame.len);
 	sFrame.len += ((PWLAN_IE_SSID)pMgmt->abyCurrSSID)->len + WLAN_IEHDR_LEN;
 	memcpy(sFrame.pSSID,
 	       pCurrSSID,
 	       ((PWLAN_IE_SSID)pCurrSSID)->len + WLAN_IEHDR_LEN
 );
-	// Copy the rate set
+	/* Copy the rate set */
 	sFrame.pSuppRates = (PWLAN_IE_SUPP_RATES)(sFrame.pBuf + sFrame.len);
 	sFrame.len += ((PWLAN_IE_SUPP_RATES)pCurrSuppRates)->len + WLAN_IEHDR_LEN;
 	memcpy(sFrame.pSuppRates,
 	       pCurrSuppRates,
 	       ((PWLAN_IE_SUPP_RATES)pCurrSuppRates)->len + WLAN_IEHDR_LEN
 );
-	// DS parameter
+	/* DS parameter */
 	if (pDevice->eCurrentPHYType != PHY_TYPE_11A) {
 		sFrame.pDSParms = (PWLAN_IE_DS_PARMS)(sFrame.pBuf + sFrame.len);
 		sFrame.len += (1) + WLAN_IEHDR_LEN;
@@ -3099,7 +3092,7 @@ s_MgrMakeBeacon(
 		sFrame.pDSParms->len = 1;
 		sFrame.pDSParms->byCurrChannel = (unsigned char)uCurrChannel;
 	}
-	// TIM field
+	/* TIM field */
 	if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
 		sFrame.pTIM = (PWLAN_IE_TIM)(sFrame.pBuf + sFrame.len);
 		sFrame.pTIM->byElementID = WLAN_EID_TIM;
@@ -3108,7 +3101,7 @@ s_MgrMakeBeacon(
 	}
 
 	if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) {
-		// IBSS parameter
+		/* IBSS parameter */
 		sFrame.pIBSSParms = (PWLAN_IE_IBSS_PARMS)(sFrame.pBuf + sFrame.len);
 		sFrame.len += (2) + WLAN_IEHDR_LEN;
 		sFrame.pIBSSParms->byElementID = WLAN_EID_IBSS_PARMS;
@@ -3128,21 +3121,25 @@ s_MgrMakeBeacon(
 			sFrame.pRSNWPA->abyMulticast[1] = 0x50;
 			sFrame.pRSNWPA->abyMulticast[2] = 0xf2;
 			if (pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled)
-				sFrame.pRSNWPA->abyMulticast[3] = 0x04;//AES
+				/* AES */
+				sFrame.pRSNWPA->abyMulticast[3] = 0x04;
 			else if (pDevice->eEncryptionStatus == Ndis802_11Encryption2Enabled)
-				sFrame.pRSNWPA->abyMulticast[3] = 0x02;//TKIP
+				/* TKIP */
+				sFrame.pRSNWPA->abyMulticast[3] = 0x02;
 			else if (pDevice->eEncryptionStatus == Ndis802_11Encryption1Enabled)
-				sFrame.pRSNWPA->abyMulticast[3] = 0x01;//WEP40
+				/* WEP40 */
+				sFrame.pRSNWPA->abyMulticast[3] = 0x01;
 			else
-				sFrame.pRSNWPA->abyMulticast[3] = 0x00;//NONE
+				/* NONE */
+				sFrame.pRSNWPA->abyMulticast[3] = 0x00;
 
-			// Pairwise Key Cipher Suite
+			/* Pairwise Key Cipher Suite */
 			sFrame.pRSNWPA->wPKCount = 0;
-			// Auth Key Management Suite
+			/* Auth Key Management Suite */
 			*((unsigned short *)(sFrame.pBuf + sFrame.len + sFrame.pRSNWPA->len)) = 0;
 			sFrame.pRSNWPA->len += 2;
 
-			// RSN Capabilities
+			/* RSN Capabilities */
 			*((unsigned short *)(sFrame.pBuf + sFrame.len + sFrame.pRSNWPA->len)) = 0;
 			sFrame.pRSNWPA->len += 2;
 			sFrame.len += sFrame.pRSNWPA->len + WLAN_IEHDR_LEN;
@@ -3150,20 +3147,20 @@ s_MgrMakeBeacon(
 	}
 
 	if (pMgmt->b11hEnable && (pMgmt->eCurrentPHYMode == PHY_TYPE_11A)) {
-		// Country IE
+		/* Country IE */
 		pbyBuffer = (unsigned char *)(sFrame.pBuf + sFrame.len);
 		set_country_IE(pMgmt->pAdapter, pbyBuffer);
 		set_country_info(pMgmt->pAdapter, PHY_TYPE_11A, pbyBuffer);
 		uLength += ((PWLAN_IE_COUNTRY) pbyBuffer)->len + WLAN_IEHDR_LEN;
 		pbyBuffer += (((PWLAN_IE_COUNTRY) pbyBuffer)->len + WLAN_IEHDR_LEN);
-		// Power Constrain IE
+		/* Power Constrain IE */
 		((PWLAN_IE_PW_CONST) pbyBuffer)->byElementID = WLAN_EID_PWR_CONSTRAINT;
 		((PWLAN_IE_PW_CONST) pbyBuffer)->len = 1;
 		((PWLAN_IE_PW_CONST) pbyBuffer)->byPower = 0;
 		pbyBuffer += (1) + WLAN_IEHDR_LEN;
 		uLength += (1) + WLAN_IEHDR_LEN;
 		if (pMgmt->bSwitchChannel) {
-			// Channel Switch IE
+			/* Channel Switch IE */
 			((PWLAN_IE_CH_SW) pbyBuffer)->byElementID = WLAN_EID_CH_SWITCH;
 			((PWLAN_IE_CH_SW) pbyBuffer)->len = 3;
 			((PWLAN_IE_CH_SW) pbyBuffer)->byMode = 1;
@@ -3172,14 +3169,14 @@ s_MgrMakeBeacon(
 			pbyBuffer += (3) + WLAN_IEHDR_LEN;
 			uLength += (3) + WLAN_IEHDR_LEN;
 		}
-		// TPC report
+		/* TPC report */
 		((PWLAN_IE_TPC_REP) pbyBuffer)->byElementID = WLAN_EID_TPC_REP;
 		((PWLAN_IE_TPC_REP) pbyBuffer)->len = 2;
 		((PWLAN_IE_TPC_REP) pbyBuffer)->byTxPower = CARDbyGetTransmitPower(pMgmt->pAdapter);
 		((PWLAN_IE_TPC_REP) pbyBuffer)->byLinkMargin = 0;
 		pbyBuffer += (2) + WLAN_IEHDR_LEN;
 		uLength += (2) + WLAN_IEHDR_LEN;
-		// IBSS DFS
+		/* IBSS DFS */
 		if (pMgmt->eCurrMode != WMAC_MODE_ESS_AP) {
 			pIBSSDFS = (PWLAN_IE_IBSS_DFS) pbyBuffer;
 			pIBSSDFS->byElementID = WLAN_EID_IBSS_DFS;
@@ -3222,7 +3219,7 @@ s_MgrMakeBeacon(
 		       ((PWLAN_IE_SUPP_RATES)pCurrExtSuppRates)->len + WLAN_IEHDR_LEN
 );
 	}
-	// hostapd wpa/wpa2 IE
+	/* hostapd wpa/wpa2 IE */
 	if ((pMgmt->eCurrMode == WMAC_MODE_ESS_AP) && pDevice->bEnableHostapd) {
 		if (pMgmt->eAuthenMode == WMAC_AUTH_WPANONE) {
 			if (pMgmt->wWPAIELen != 0) {
@@ -3277,11 +3274,11 @@ s_MgrMakeProbeResponse(
 	pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
 	memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_PROBERESP_FR_MAXLEN);
 	pTxPacket->p80211Header = (union UWLAN_80211HDR *)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
-	// Setup the sFrame structure.
+	/* Setup the sFrame structure. */
 	sFrame.pBuf = (unsigned char *)pTxPacket->p80211Header;
 	sFrame.len = WLAN_PROBERESP_FR_MAXLEN;
 	vMgrEncodeProbeResponse(&sFrame);
-	// Setup the header
+	/* Setup the header */
 	sFrame.pHdr->sA3.wFrameCtl = cpu_to_le16(
 		(
 			WLAN_SET_FC_FTYPE(WLAN_TYPE_MGR) |
@@ -3293,18 +3290,17 @@ s_MgrMakeProbeResponse(
 	*sFrame.pwBeaconInterval = cpu_to_le16(wCurrBeaconPeriod);
 	*sFrame.pwCapInfo = cpu_to_le16(wCurrCapInfo);
 
-	if (byPHYType == BB_TYPE_11B) {
+	if (byPHYType == BB_TYPE_11B)
 		*sFrame.pwCapInfo &= cpu_to_le16((unsigned short)~(WLAN_SET_CAP_INFO_SHORTSLOTTIME(1)));
-	}
 
-	// Copy SSID
+	/* Copy SSID */
 	sFrame.pSSID = (PWLAN_IE_SSID)(sFrame.pBuf + sFrame.len);
 	sFrame.len += ((PWLAN_IE_SSID)pMgmt->abyCurrSSID)->len + WLAN_IEHDR_LEN;
 	memcpy(sFrame.pSSID,
 	       pCurrSSID,
 	       ((PWLAN_IE_SSID)pCurrSSID)->len + WLAN_IEHDR_LEN
 );
-	// Copy the rate set
+	/* Copy the rate set */
 	sFrame.pSuppRates = (PWLAN_IE_SUPP_RATES)(sFrame.pBuf + sFrame.len);
 
 	sFrame.len += ((PWLAN_IE_SUPP_RATES)pCurrSuppRates)->len + WLAN_IEHDR_LEN;
@@ -3313,7 +3309,7 @@ s_MgrMakeProbeResponse(
 	       ((PWLAN_IE_SUPP_RATES)pCurrSuppRates)->len + WLAN_IEHDR_LEN
 );
 
-	// DS parameter
+	/* DS parameter */
 	if (pDevice->eCurrentPHYType != PHY_TYPE_11A) {
 		sFrame.pDSParms = (PWLAN_IE_DS_PARMS)(sFrame.pBuf + sFrame.len);
 		sFrame.len += (1) + WLAN_IEHDR_LEN;
@@ -3323,7 +3319,7 @@ s_MgrMakeProbeResponse(
 	}
 
 	if (pMgmt->eCurrMode != WMAC_MODE_ESS_AP) {
-		// IBSS parameter
+		/* IBSS parameter */
 		sFrame.pIBSSParms = (PWLAN_IE_IBSS_PARMS)(sFrame.pBuf + sFrame.len);
 		sFrame.len += (2) + WLAN_IEHDR_LEN;
 		sFrame.pIBSSParms->byElementID = WLAN_EID_IBSS_PARMS;
@@ -3345,20 +3341,20 @@ s_MgrMakeProbeResponse(
 	}
 
 	if (pMgmt->b11hEnable && (pMgmt->eCurrentPHYMode == PHY_TYPE_11A)) {
-		// Country IE
+		/* Country IE */
 		pbyBuffer = (unsigned char *)(sFrame.pBuf + sFrame.len);
 		set_country_IE(pMgmt->pAdapter, pbyBuffer);
 		set_country_info(pMgmt->pAdapter, PHY_TYPE_11A, pbyBuffer);
 		uLength += ((PWLAN_IE_COUNTRY) pbyBuffer)->len + WLAN_IEHDR_LEN;
 		pbyBuffer += (((PWLAN_IE_COUNTRY) pbyBuffer)->len + WLAN_IEHDR_LEN);
-		// Power Constrain IE
+		/* Power Constrain IE */
 		((PWLAN_IE_PW_CONST) pbyBuffer)->byElementID = WLAN_EID_PWR_CONSTRAINT;
 		((PWLAN_IE_PW_CONST) pbyBuffer)->len = 1;
 		((PWLAN_IE_PW_CONST) pbyBuffer)->byPower = 0;
 		pbyBuffer += (1) + WLAN_IEHDR_LEN;
 		uLength += (1) + WLAN_IEHDR_LEN;
 		if (pMgmt->bSwitchChannel) {
-			// Channel Switch IE
+			/* Channel Switch IE */
 			((PWLAN_IE_CH_SW) pbyBuffer)->byElementID = WLAN_EID_CH_SWITCH;
 			((PWLAN_IE_CH_SW) pbyBuffer)->len = 3;
 			((PWLAN_IE_CH_SW) pbyBuffer)->byMode = 1;
@@ -3367,14 +3363,14 @@ s_MgrMakeProbeResponse(
 			pbyBuffer += (3) + WLAN_IEHDR_LEN;
 			uLength += (3) + WLAN_IEHDR_LEN;
 		}
-		// TPC report
+		/* TPC report */
 		((PWLAN_IE_TPC_REP) pbyBuffer)->byElementID = WLAN_EID_TPC_REP;
 		((PWLAN_IE_TPC_REP) pbyBuffer)->len = 2;
 		((PWLAN_IE_TPC_REP) pbyBuffer)->byTxPower = CARDbyGetTransmitPower(pMgmt->pAdapter);
 		((PWLAN_IE_TPC_REP) pbyBuffer)->byLinkMargin = 0;
 		pbyBuffer += (2) + WLAN_IEHDR_LEN;
 		uLength += (2) + WLAN_IEHDR_LEN;
-		// IBSS DFS
+		/* IBSS DFS */
 		if (pMgmt->eCurrMode != WMAC_MODE_ESS_AP) {
 			pIBSSDFS = (PWLAN_IE_IBSS_DFS) pbyBuffer;
 			pIBSSDFS->byElementID = WLAN_EID_IBSS_DFS;
@@ -3405,7 +3401,7 @@ s_MgrMakeProbeResponse(
 );
 	}
 
-	// hostapd wpa/wpa2 IE
+	/* hostapd wpa/wpa2 IE */
 	if ((pMgmt->eCurrMode == WMAC_MODE_ESS_AP) && pDevice->bEnableHostapd) {
 		if (pMgmt->eAuthenMode == WMAC_AUTH_WPANONE) {
 			if (pMgmt->wWPAIELen != 0) {
@@ -3416,7 +3412,7 @@ s_MgrMakeProbeResponse(
 		}
 	}
 
-	// Adjust the length fields
+	/* Adjust the length fields */
 	pTxPacket->cbMPDULen = sFrame.len;
 	pTxPacket->cbPayloadLen = sFrame.len - WLAN_HDR_ADDR3_LEN;
 
@@ -3454,12 +3450,12 @@ s_MgrMakeAssocRequest(
 	pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
 	memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_ASSOCREQ_FR_MAXLEN);
 	pTxPacket->p80211Header = (union UWLAN_80211HDR *)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
-	// Setup the sFrame structure.
+	/* Setup the sFrame structure. */
 	sFrame.pBuf = (unsigned char *)pTxPacket->p80211Header;
 	sFrame.len = WLAN_ASSOCREQ_FR_MAXLEN;
-	// format fixed field frame structure
+	/* format fixed field frame structure */
 	vMgrEncodeAssocRequest(&sFrame);
-	// Setup the header
+	/* Setup the header */
 	sFrame.pHdr->sA3.wFrameCtl = cpu_to_le16(
 		(
 			WLAN_SET_FC_FTYPE(WLAN_TYPE_MGR) |
@@ -3469,22 +3465,22 @@ s_MgrMakeAssocRequest(
 	memcpy(sFrame.pHdr->sA3.abyAddr2, pMgmt->abyMACAddr, WLAN_ADDR_LEN);
 	memcpy(sFrame.pHdr->sA3.abyAddr3, pMgmt->abyCurrBSSID, WLAN_BSSID_LEN);
 
-	// Set the capability and listen interval
+	/* Set the capability and listen interval */
 	*(sFrame.pwCapInfo) = cpu_to_le16(wCurrCapInfo);
 	*(sFrame.pwListenInterval) = cpu_to_le16(wListenInterval);
 
-	// sFrame.len point to end of fixed field
+	/* sFrame.len point to end of fixed field */
 	sFrame.pSSID = (PWLAN_IE_SSID)(sFrame.pBuf + sFrame.len);
 	sFrame.len += pCurrSSID->len + WLAN_IEHDR_LEN;
 	memcpy(sFrame.pSSID, pCurrSSID, pCurrSSID->len + WLAN_IEHDR_LEN);
 
 	pMgmt->sAssocInfo.AssocInfo.RequestIELength = pCurrSSID->len + WLAN_IEHDR_LEN;
-	pMgmt->sAssocInfo.AssocInfo.OffsetRequestIEs = sizeof(NDIS_802_11_ASSOCIATION_INFORMATION);
+	pMgmt->sAssocInfo.AssocInfo.OffsetRequestIEs = sizeof(struct NDIS_802_11_ASSOCIATION_INFORMATION);
 	pbyIEs = pMgmt->sAssocInfo.abyIEs;
 	memcpy(pbyIEs, pCurrSSID, pCurrSSID->len + WLAN_IEHDR_LEN);
 	pbyIEs += pCurrSSID->len + WLAN_IEHDR_LEN;
 
-	// Copy the rate set
+	/* Copy the rate set */
 	sFrame.pSuppRates = (PWLAN_IE_SUPP_RATES)(sFrame.pBuf + sFrame.len);
 	if ((pDevice->eCurrentPHYType == PHY_TYPE_11B) && (pCurrRates->len > 4))
 		sFrame.len += 4 + WLAN_IEHDR_LEN;
@@ -3492,7 +3488,7 @@ s_MgrMakeAssocRequest(
 		sFrame.len += pCurrRates->len + WLAN_IEHDR_LEN;
 	memcpy(sFrame.pSuppRates, pCurrRates, pCurrRates->len + WLAN_IEHDR_LEN);
 
-	// Copy the extension rate set
+	/* Copy the extension rate set */
 	if ((pDevice->eCurrentPHYType == PHY_TYPE_11G) && (pCurrExtSuppRates->len > 0)) {
 		sFrame.pExtSuppRates = (PWLAN_IE_SUPP_RATES)(sFrame.pBuf + sFrame.len);
 		sFrame.len += pCurrExtSuppRates->len + WLAN_IEHDR_LEN;
@@ -3503,7 +3499,7 @@ s_MgrMakeAssocRequest(
 	memcpy(pbyIEs, pCurrRates, pCurrRates->len + WLAN_IEHDR_LEN);
 	pbyIEs += pCurrRates->len + WLAN_IEHDR_LEN;
 
-	// for 802.11h
+	/* for 802.11h */
 	if (pMgmt->b11hEnable) {
 		if (sFrame.pCurrPowerCap == NULL) {
 			sFrame.pCurrPowerCap = (PWLAN_IE_PW_CAP)(sFrame.pBuf + sFrame.len);
@@ -3534,32 +3530,30 @@ s_MgrMakeAssocRequest(
 		sFrame.pRSNWPA->abyOUI[2] = 0xf2;
 		sFrame.pRSNWPA->abyOUI[3] = 0x01;
 		sFrame.pRSNWPA->wVersion = 1;
-		//Group Key Cipher Suite
+		/* Group Key Cipher Suite */
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
-		// Pairwise Key Cipher Suite
+		/* Pairwise Key Cipher Suite */
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
-		// Auth Key Management Suite
+		/* Auth Key Management Suite */
 		pbyRSN = (unsigned char *)(sFrame.pBuf + sFrame.len + 2 + sFrame.pRSNWPA->len);
 		*pbyRSN++ = 0x01;
 		*pbyRSN++ = 0x00;
@@ -3567,24 +3561,23 @@ s_MgrMakeAssocRequest(
 
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
 
-		// RSN Capabilities
+		/* RSN Capabilities */
 
 		*pbyRSN++ = 0x00;
 		*pbyRSN++ = 0x00;
 		sFrame.pRSNWPA->len += 2;
 
 		sFrame.len += sFrame.pRSNWPA->len + WLAN_IEHDR_LEN;
-		// copy to AssocInfo. for OID_802_11_ASSOCIATION_INFORMATION
+		/* copy to AssocInfo. for OID_802_11_ASSOCIATION_INFORMATION */
 		pMgmt->sAssocInfo.AssocInfo.RequestIELength += sFrame.pRSNWPA->len + WLAN_IEHDR_LEN;
 		memcpy(pbyIEs, sFrame.pRSNWPA, sFrame.pRSNWPA->len + WLAN_IEHDR_LEN);
 		pbyIEs += sFrame.pRSNWPA->len + WLAN_IEHDR_LEN;
@@ -3595,72 +3588,69 @@ s_MgrMakeAssocRequest(
 		unsigned int ii;
 		unsigned short *pwPMKID;
 
-		// WPA IE
+		/* WPA IE */
 		sFrame.pRSN = (PWLAN_IE_RSN)(sFrame.pBuf + sFrame.len);
 		sFrame.pRSN->byElementID = WLAN_EID_RSN;
-		sFrame.pRSN->len = 6; //Version(2)+GK(4)
+		sFrame.pRSN->len = 6; /*Version(2)+GK(4) */
 		sFrame.pRSN->wVersion = 1;
-		//Group Key Cipher Suite
+		/* Group Key Cipher Suite */
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
 
-		// Pairwise Key Cipher Suite
+		/* Pairwise Key Cipher Suite */
 		sFrame.pRSN->abyRSN[4] = 1;
 		sFrame.pRSN->abyRSN[5] = 0;
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
 		sFrame.pRSN->len += 6;
 
-		// Auth Key Management Suite
+		/* Auth Key Management Suite */
 		sFrame.pRSN->abyRSN[10] = 1;
 		sFrame.pRSN->abyRSN[11] = 0;
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
 		sFrame.pRSN->len += 6;
 
-		// RSN Capabilities
-		if (pMgmt->pCurrBSS->sRSNCapObj.bRSNCapExist) {
+		/* RSN Capabilities */
+		if (pMgmt->pCurrBSS->sRSNCapObj.bRSNCapExist)
 			memcpy(&sFrame.pRSN->abyRSN[16], &pMgmt->pCurrBSS->sRSNCapObj.wRSNCap, 2);
-		} else {
+		else {
 			sFrame.pRSN->abyRSN[16] = 0;
 			sFrame.pRSN->abyRSN[17] = 0;
 		}
 		sFrame.pRSN->len += 2;
 
 		if ((pDevice->gsPMKID.BSSIDInfoCount > 0) && pDevice->bRoaming && (pMgmt->eAuthenMode == WMAC_AUTH_WPA2)) {
-			// RSN PMKID
+			/* RSN PMKID */
 			pbyRSN = &sFrame.pRSN->abyRSN[18];
-			pwPMKID = (unsigned short *)pbyRSN; // Point to PMKID count
-			*pwPMKID = 0;            // Initialize PMKID count
-			pbyRSN += 2;             // Point to PMKID list
+			pwPMKID = (unsigned short *)pbyRSN; /* Point to PMKID count */
+			*pwPMKID = 0;            /* Initialize PMKID count */
+			pbyRSN += 2;             /* Point to PMKID list */
 			for (ii = 0; ii < pDevice->gsPMKID.BSSIDInfoCount; ii++) {
 				if (!memcmp(&pDevice->gsPMKID.BSSIDInfo[ii].BSSID[0], pMgmt->abyCurrBSSID, ETH_ALEN)) {
 					(*pwPMKID)++;
@@ -3668,19 +3658,18 @@ s_MgrMakeAssocRequest(
 					pbyRSN += 16;
 				}
 			}
-			if (*pwPMKID != 0) {
+			if (*pwPMKID != 0)
 				sFrame.pRSN->len += (2 + (*pwPMKID)*16);
-			}
 		}
 
 		sFrame.len += sFrame.pRSN->len + WLAN_IEHDR_LEN;
-		// copy to AssocInfo. for OID_802_11_ASSOCIATION_INFORMATION
+		/* copy to AssocInfo. for OID_802_11_ASSOCIATION_INFORMATION */
 		pMgmt->sAssocInfo.AssocInfo.RequestIELength += sFrame.pRSN->len + WLAN_IEHDR_LEN;
 		memcpy(pbyIEs, sFrame.pRSN, sFrame.pRSN->len + WLAN_IEHDR_LEN);
 		pbyIEs += sFrame.pRSN->len + WLAN_IEHDR_LEN;
 	}
 
-	// Adjust the length fields
+	/* Adjust the length fields */
 	pTxPacket->cbMPDULen = sFrame.len;
 	pTxPacket->cbPayloadLen = sFrame.len - WLAN_HDR_ADDR3_LEN;
 	return pTxPacket;
@@ -3721,7 +3710,7 @@ s_MgrMakeReAssocRequest(
 	sFrame.pBuf = (unsigned char *)pTxPacket->p80211Header;
 	sFrame.len = WLAN_REASSOCREQ_FR_MAXLEN;
 
-	// format fixed field frame structure
+	/* format fixed field frame structure */
 	vMgrEncodeReassocRequest(&sFrame);
 
 	/* Setup the header */
@@ -3746,7 +3735,7 @@ s_MgrMakeReAssocRequest(
 	memcpy(sFrame.pSSID, pCurrSSID, pCurrSSID->len + WLAN_IEHDR_LEN);
 
 	pMgmt->sAssocInfo.AssocInfo.RequestIELength = pCurrSSID->len + WLAN_IEHDR_LEN;
-	pMgmt->sAssocInfo.AssocInfo.OffsetRequestIEs = sizeof(NDIS_802_11_ASSOCIATION_INFORMATION);
+	pMgmt->sAssocInfo.AssocInfo.OffsetRequestIEs = sizeof(struct NDIS_802_11_ASSOCIATION_INFORMATION);
 	pbyIEs = pMgmt->sAssocInfo.abyIEs;
 	memcpy(pbyIEs, pCurrSSID, pCurrSSID->len + WLAN_IEHDR_LEN);
 	pbyIEs += pCurrSSID->len + WLAN_IEHDR_LEN;
@@ -3757,7 +3746,7 @@ s_MgrMakeReAssocRequest(
 	sFrame.len += pCurrRates->len + WLAN_IEHDR_LEN;
 	memcpy(sFrame.pSuppRates, pCurrRates, pCurrRates->len + WLAN_IEHDR_LEN);
 
-	// Copy the extension rate set
+	/* Copy the extension rate set */
 	if ((pMgmt->eCurrentPHYMode == PHY_TYPE_11G) && (pCurrExtSuppRates->len > 0)) {
 		sFrame.pExtSuppRates = (PWLAN_IE_SUPP_RATES)(sFrame.pBuf + sFrame.len);
 		sFrame.len += pCurrExtSuppRates->len + WLAN_IEHDR_LEN;
@@ -3781,32 +3770,30 @@ s_MgrMakeReAssocRequest(
 		sFrame.pRSNWPA->abyOUI[2] = 0xf2;
 		sFrame.pRSNWPA->abyOUI[3] = 0x01;
 		sFrame.pRSNWPA->wVersion = 1;
-		//Group Key Cipher Suite
+		/* Group Key Cipher Suite */
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
-		// Pairwise Key Cipher Suite
+		/* Pairwise Key Cipher Suite */
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
-		// Auth Key Management Suite
+		/* Auth Key Management Suite */
 		pbyRSN = (unsigned char *)(sFrame.pBuf + sFrame.len + 2 + sFrame.pRSNWPA->len);
 		*pbyRSN++ = 0x01;
 		*pbyRSN++ = 0x00;
@@ -3814,23 +3801,22 @@ s_MgrMakeReAssocRequest(
 
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
 
-		// RSN Capabilities
+		/* RSN Capabilities */
 		*pbyRSN++ = 0x00;
 		*pbyRSN++ = 0x00;
 		sFrame.pRSNWPA->len += 2;
 
 		sFrame.len += sFrame.pRSNWPA->len + WLAN_IEHDR_LEN;
-		// copy to AssocInfo. for OID_802_11_ASSOCIATION_INFORMATION
+		/* copy to AssocInfo. for OID_802_11_ASSOCIATION_INFORMATION */
 		pMgmt->sAssocInfo.AssocInfo.RequestIELength += sFrame.pRSNWPA->len + WLAN_IEHDR_LEN;
 		memcpy(pbyIEs, sFrame.pRSNWPA, sFrame.pRSNWPA->len + WLAN_IEHDR_LEN);
 		pbyIEs += sFrame.pRSNWPA->len + WLAN_IEHDR_LEN;
@@ -3844,55 +3830,52 @@ s_MgrMakeReAssocRequest(
 		/* WPA IE */
 		sFrame.pRSN = (PWLAN_IE_RSN)(sFrame.pBuf + sFrame.len);
 		sFrame.pRSN->byElementID = WLAN_EID_RSN;
-		sFrame.pRSN->len = 6; //Version(2)+GK(4)
+		sFrame.pRSN->len = 6; /* Version(2)+GK(4) */
 		sFrame.pRSN->wVersion = 1;
-		//Group Key Cipher Suite
+		/* Group Key Cipher Suite */
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
 
-		// Pairwise Key Cipher Suite
+		/* Pairwise Key Cipher Suite */
 		sFrame.pRSN->abyRSN[4] = 1;
 		sFrame.pRSN->abyRSN[5] = 0;
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
 		sFrame.pRSN->len += 6;
 
-		// Auth Key Management Suite
+		/* Auth Key Management Suite */
 		sFrame.pRSN->abyRSN[10] = 1;
 		sFrame.pRSN->abyRSN[11] = 0;
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
 		sFrame.pRSN->len += 6;
 
-		// RSN Capabilities
+		/* RSN Capabilities */
 		if (pMgmt->pCurrBSS->sRSNCapObj.bRSNCapExist) {
 			memcpy(&sFrame.pRSN->abyRSN[16], &pMgmt->pCurrBSS->sRSNCapObj.wRSNCap, 2);
 		} else {
@@ -3902,11 +3885,11 @@ s_MgrMakeReAssocRequest(
 		sFrame.pRSN->len += 2;
 
 		if ((pDevice->gsPMKID.BSSIDInfoCount > 0) && pDevice->bRoaming && (pMgmt->eAuthenMode == WMAC_AUTH_WPA2)) {
-			// RSN PMKID
+			/* RSN PMKID */
 			pbyRSN = &sFrame.pRSN->abyRSN[18];
-			pwPMKID = (unsigned short *)pbyRSN; // Point to PMKID count
-			*pwPMKID = 0;            // Initialize PMKID count
-			pbyRSN += 2;             // Point to PMKID list
+			pwPMKID = (unsigned short *)pbyRSN; /* Point to PMKID count */
+			*pwPMKID = 0;            /* Initialize PMKID count */
+			pbyRSN += 2;             /* Point to PMKID list */
 			for (ii = 0; ii < pDevice->gsPMKID.BSSIDInfoCount; ii++) {
 				if (!memcmp(&pDevice->gsPMKID.BSSIDInfo[ii].BSSID[0], pMgmt->abyCurrBSSID, ETH_ALEN)) {
 					(*pwPMKID)++;
@@ -3914,13 +3897,12 @@ s_MgrMakeReAssocRequest(
 					pbyRSN += 16;
 				}
 			}
-			if (*pwPMKID != 0) {
+			if (*pwPMKID != 0)
 				sFrame.pRSN->len += (2 + (*pwPMKID) * 16);
-			}
 		}
 
 		sFrame.len += sFrame.pRSN->len + WLAN_IEHDR_LEN;
-		// copy to AssocInfo. for OID_802_11_ASSOCIATION_INFORMATION
+		/* copy to AssocInfo. for OID_802_11_ASSOCIATION_INFORMATION */
 		pMgmt->sAssocInfo.AssocInfo.RequestIELength += sFrame.pRSN->len + WLAN_IEHDR_LEN;
 		memcpy(pbyIEs, sFrame.pRSN, sFrame.pRSN->len + WLAN_IEHDR_LEN);
 		pbyIEs += sFrame.pRSN->len + WLAN_IEHDR_LEN;
@@ -3962,11 +3944,11 @@ s_MgrMakeAssocResponse(
 	pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
 	memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_ASSOCREQ_FR_MAXLEN);
 	pTxPacket->p80211Header = (union UWLAN_80211HDR *)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
-	// Setup the sFrame structure
+	/* Setup the sFrame structure */
 	sFrame.pBuf = (unsigned char *)pTxPacket->p80211Header;
 	sFrame.len = WLAN_REASSOCRESP_FR_MAXLEN;
 	vMgrEncodeAssocResponse(&sFrame);
-	// Setup the header
+	/* Setup the header */
 	sFrame.pHdr->sA3.wFrameCtl = cpu_to_le16(
 		(
 			WLAN_SET_FC_FTYPE(WLAN_TYPE_MGR) |
@@ -3980,7 +3962,7 @@ s_MgrMakeAssocResponse(
 	*sFrame.pwStatus = cpu_to_le16(wAssocStatus);
 	*sFrame.pwAid = cpu_to_le16((unsigned short)(wAssocAID | BIT14 | BIT15));
 
-	// Copy the rate set
+	/* Copy the rate set */
 	sFrame.pSuppRates = (PWLAN_IE_SUPP_RATES)(sFrame.pBuf + sFrame.len);
 	sFrame.len += ((PWLAN_IE_SUPP_RATES)pCurrSuppRates)->len + WLAN_IEHDR_LEN;
 	memcpy(sFrame.pSuppRates,
@@ -3997,7 +3979,7 @@ s_MgrMakeAssocResponse(
 );
 	}
 
-	// Adjust the length fields
+	/* Adjust the length fields */
 	pTxPacket->cbMPDULen = sFrame.len;
 	pTxPacket->cbPayloadLen = sFrame.len - WLAN_HDR_ADDR3_LEN;
 
@@ -4033,11 +4015,11 @@ s_MgrMakeReAssocResponse(
 	pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
 	memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_ASSOCREQ_FR_MAXLEN);
 	pTxPacket->p80211Header = (union UWLAN_80211HDR *)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
-	// Setup the sFrame structure
+	/* Setup the sFrame structure */
 	sFrame.pBuf = (unsigned char *)pTxPacket->p80211Header;
 	sFrame.len = WLAN_REASSOCRESP_FR_MAXLEN;
 	vMgrEncodeReassocResponse(&sFrame);
-	// Setup the header
+	/* Setup the header */
 	sFrame.pHdr->sA3.wFrameCtl = cpu_to_le16(
 		(
 			WLAN_SET_FC_FTYPE(WLAN_TYPE_MGR) |
@@ -4051,7 +4033,7 @@ s_MgrMakeReAssocResponse(
 	*sFrame.pwStatus = cpu_to_le16(wAssocStatus);
 	*sFrame.pwAid = cpu_to_le16((unsigned short)(wAssocAID | BIT14 | BIT15));
 
-	// Copy the rate set
+	/* Copy the rate set */
 	sFrame.pSuppRates = (PWLAN_IE_SUPP_RATES)(sFrame.pBuf + sFrame.len);
 	sFrame.len += ((PWLAN_IE_SUPP_RATES)pCurrSuppRates)->len + WLAN_IEHDR_LEN;
 	memcpy(sFrame.pSuppRates,
@@ -4068,7 +4050,7 @@ s_MgrMakeReAssocResponse(
 );
 	}
 
-	// Adjust the length fields
+	/* Adjust the length fields */
 	pTxPacket->cbMPDULen = sFrame.len;
 	pTxPacket->cbPayloadLen = sFrame.len - WLAN_HDR_ADDR3_LEN;
 
@@ -4102,7 +4084,7 @@ s_vMgrRxProbeResponse(
 	bool bChannelHit = true;
 
 	memset(&sFrame, 0, sizeof(WLAN_FR_PROBERESP));
-	// decode the frame
+	/* decode the frame */
 	sFrame.len = pRxPacket->cbMPDULen;
 	sFrame.pBuf = (unsigned char *)pRxPacket->p80211Header;
 	vMgrDecodeProbeResponse(&sFrame);
@@ -4112,32 +4094,32 @@ s_vMgrRxProbeResponse(
 	    (sFrame.pwCapInfo == 0) ||
 	    (sFrame.pSSID == 0) ||
 	    (sFrame.pSuppRates == 0)) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Probe resp:Fail addr:[%p] \n", pRxPacket->p80211Header);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Probe resp:Fail addr:[%p]\n", pRxPacket->p80211Header);
 		DBG_PORT80(0xCC);
 		return;
 	}
 
 	if (sFrame.pSSID->len == 0)
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Rx Probe resp: SSID len = 0 \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Rx Probe resp: SSID len = 0\n");
 
 	if (sFrame.pDSParms != 0) {
 		if (byCurrChannel > CB_MAX_CHANNEL_24G) {
-			// channel remapping to
+			/* channel remapping to */
 			byIEChannel = get_channel_mapping(pMgmt->pAdapter, sFrame.pDSParms->byCurrChannel, PHY_TYPE_11A);
 		} else {
 			byIEChannel = sFrame.pDSParms->byCurrChannel;
 		}
 		if (byCurrChannel != byIEChannel) {
-			// adjust channel info. bcs we rcv adjacent channel packets
+			/* adjust channel info. bcs we rcv adjacent channel packets */
 			bChannelHit = false;
 			byCurrChannel = byIEChannel;
 		}
 	} else {
-		// no DS channel info
+		/* no DS channel info */
 		bChannelHit = true;
 	}
 
-//2008-0730-01<Add>by MikeLiu
+/* 2008-0730-01<Add>by MikeLiu */
 	if (ChannelExceedZoneType(pDevice, byCurrChannel))
 		return;
 
@@ -4149,7 +4131,7 @@ s_vMgrRxProbeResponse(
 		sERP.byERP = 0;
 	}
 
-	// update or insert the bss
+	/* update or insert the bss */
 	pBSSList = BSSpAddrIsInBSSList((void *)pDevice, sFrame.pHdr->sA3.abyAddr3, sFrame.pSSID);
 	if (pBSSList) {
 		BSSbUpdateToBSSList((void *)pDevice,
@@ -4168,7 +4150,7 @@ s_vMgrRxProbeResponse(
 				    sFrame.pIE_Quiet,
 				    pBSSList,
 				    sFrame.len - WLAN_HDR_ADDR3_LEN,
-				    sFrame.pHdr->sA4.abyAddr4,   // payload of probresponse
+				    sFrame.pHdr->sA4.abyAddr4,   /* payload of probresponse */
 				    (void *)pRxPacket
 );
 	} else {
@@ -4188,7 +4170,7 @@ s_vMgrRxProbeResponse(
 				    sFrame.pIE_Country,
 				    sFrame.pIE_Quiet,
 				    sFrame.len - WLAN_HDR_ADDR3_LEN,
-				    sFrame.pHdr->sA4.abyAddr4,   // payload of beacon
+				    sFrame.pHdr->sA4.abyAddr4,   /* payload of beacon */
 				    (void *)pRxPacket
 );
 	}
@@ -4219,12 +4201,13 @@ s_vMgrRxProbeRequest(
 	PSTxMgmtPacket      pTxPacket;
 	unsigned char byPHYType = BB_TYPE_11B;
 
-	// STA in Ad-hoc mode: when latest TBTT beacon transmit success,
-	// STA have to response this request.
+	/* STA in Ad-hoc mode: when latest TBTT beacon transmit success,
+	 * STA have to response this request.
+	 */
 	if ((pMgmt->eCurrMode == WMAC_MODE_ESS_AP) ||
 	    ((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) && pDevice->bBeaconSent)) {
 		memset(&sFrame, 0, sizeof(WLAN_FR_PROBEREQ));
-		// decode the frame
+		/* decode the frame */
 		sFrame.len = pRxPacket->cbMPDULen;
 		sFrame.pBuf = (unsigned char *)pRxPacket->p80211Header;
 		vMgrDecodeProbeRequest(&sFrame);
@@ -4242,11 +4225,10 @@ s_vMgrRxProbeRequest(
 			}
 		}
 
-		if ((sFrame.pSuppRates->len > 4) || (sFrame.pExtSuppRates != NULL)) {
+		if ((sFrame.pSuppRates->len > 4) || (sFrame.pExtSuppRates != NULL))
 			byPHYType = BB_TYPE_11G;
-		}
 
-		// Probe response reply..
+		/* Probe response reply.. */
 		pTxPacket = s_MgrMakeProbeResponse
 			(
 				pDevice,
@@ -4265,11 +4247,12 @@ s_vMgrRxProbeRequest(
 		if (pTxPacket != NULL) {
 			/* send the frame */
 			Status = csMgmt_xmit(pDevice, pTxPacket);
-			if (Status != CMD_STATUS_PENDING) {
+			if (Status != CMD_STATUS_PENDING)
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Probe response tx failed\n");
-			} else {
-//                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Probe response tx sending..\n");
-			}
+/*			else
+				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Probe response tx sending..\n");
+			;
+*/
 		}
 	}
 
@@ -4310,11 +4293,12 @@ vMgrRxManagePacket(
 
 	switch (WLAN_GET_FC_FSTYPE((pRxPacket->p80211Header->sA3.wFrameCtl))) {
 	case WLAN_FSTYPE_ASSOCREQ:
-		// Frame Clase = 2
+		/* Frame Clase = 2 */
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx assocreq\n");
 		if (eNodeState < NODE_AUTH) {
-			// send deauth notification
-			// reason = (6) class 2 received from nonauth sta
+			/* send deauth notification
+			 * reason = (6) class 2 received from nonauth sta
+			 */
 			vMgrDeAuthenBeginSta(pDevice,
 					     pMgmt,
 					     pRxPacket->p80211Header->sA3.abyAddr2,
@@ -4328,19 +4312,19 @@ vMgrRxManagePacket(
 		break;
 
 	case WLAN_FSTYPE_ASSOCRESP:
-		// Frame Clase = 2
+		/* Frame Clase = 2 */
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx assocresp1\n");
 		s_vMgrRxAssocResponse(pDevice, pMgmt, pRxPacket, false);
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx assocresp2\n");
 		break;
 
 	case WLAN_FSTYPE_REASSOCREQ:
-		// Frame Clase = 2
+		/* Frame Clase = 2 */
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx reassocreq\n");
-		// Todo: reassoc
+		/* Todo: reassoc */
 		if (eNodeState < NODE_AUTH) {
-			// send deauth notification
-			// reason = (6) class 2 received from nonauth sta
+			/* send deauth notification */
+			/* reason = (6) class 2 received from nonauth sta */
 			vMgrDeAuthenBeginSta(pDevice,
 					     pMgmt,
 					     pRxPacket->p80211Header->sA3.abyAddr2,
@@ -4354,44 +4338,44 @@ vMgrRxManagePacket(
 		break;
 
 	case WLAN_FSTYPE_REASSOCRESP:
-		// Frame Clase = 2
+		/* Frame Clase = 2 */
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx reassocresp\n");
 		s_vMgrRxAssocResponse(pDevice, pMgmt, pRxPacket, true);
 		break;
 
 	case WLAN_FSTYPE_PROBEREQ:
-		// Frame Clase = 0
-		//DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx probereq\n");
+		/* Frame Clase = 0 */
+		/* DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx probereq\n"); */
 		s_vMgrRxProbeRequest(pDevice, pMgmt, pRxPacket);
 		break;
 
 	case WLAN_FSTYPE_PROBERESP:
-		// Frame Clase = 0
+		/* Frame Clase = 0 */
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx proberesp\n");
 
 		s_vMgrRxProbeResponse(pDevice, pMgmt, pRxPacket);
 		break;
 
 	case WLAN_FSTYPE_BEACON:
-		// Frame Clase = 0
-		//DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx beacon\n");
-		if (pMgmt->eScanState != WMAC_NO_SCANNING) {
+		/* Frame Clase = 0 */
+		/* DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx beacon\n"); */
+		if (pMgmt->eScanState != WMAC_NO_SCANNING)
 			bInScan = true;
-		}
 		s_vMgrRxBeacon(pDevice, pMgmt, pRxPacket, bInScan);
 		break;
 
 	case WLAN_FSTYPE_ATIM:
-		// Frame Clase = 1
+		/* Frame Clase = 1 */
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx atim\n");
 		break;
 
 	case WLAN_FSTYPE_DISASSOC:
-		// Frame Clase = 2
+		/* Frame Clase = 2 */
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx disassoc\n");
 		if (eNodeState < NODE_AUTH) {
-			// send deauth notification
-			// reason = (6) class 2 received from nonauth sta
+			/* send deauth notification
+			 * reason = (6) class 2 received from nonauth sta
+			 */
 			vMgrDeAuthenBeginSta(pDevice,
 					     pMgmt,
 					     pRxPacket->p80211Header->sA3.abyAddr2,
@@ -4404,13 +4388,13 @@ vMgrRxManagePacket(
 		break;
 
 	case WLAN_FSTYPE_AUTHEN:
-		// Frame Clase = 1
+		/* Frame Clase = 1 */
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO  "rx authen\n");
 		s_vMgrRxAuthentication(pDevice, pMgmt, pRxPacket);
 		break;
 
 	case WLAN_FSTYPE_DEAUTHEN:
-		// Frame Clase = 1
+		/* Frame Clase = 1 */
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx deauthen\n");
 		s_vMgrRxDeauthentication(pDevice, pMgmt, pRxPacket);
 		break;
@@ -4442,12 +4426,11 @@ bMgrPrepareBeaconToSend(
 	PSDevice            pDevice = (PSDevice)hDeviceContext;
 	PSTxMgmtPacket      pTxPacket;
 
-//    pDevice->bBeaconBufReady = false;
-	if (pDevice->bEncryptionEnable || pDevice->bEnable8021x) {
+/*    pDevice->bBeaconBufReady = false; */
+	if (pDevice->bEncryptionEnable || pDevice->bEnable8021x)
 		pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_PRIVACY(1);
-	} else {
+	else
 		pMgmt->wCurrCapInfo &= ~WLAN_SET_CAP_INFO_PRIVACY(1);
-	}
 	pTxPacket = s_MgrMakeBeacon
 		(
 			pDevice,
@@ -4455,7 +4438,7 @@ bMgrPrepareBeaconToSend(
 			pMgmt->wCurrCapInfo,
 			pMgmt->wCurrBeaconPeriod,
 			pMgmt->uCurrChannel,
-			pMgmt->wCurrATIMWindow, //0,
+			pMgmt->wCurrATIMWindow, /* 0, */
 			(PWLAN_IE_SSID)pMgmt->abyCurrSSID,
 			(unsigned char *)pMgmt->abyCurrBSSID,
 			(PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
@@ -4571,26 +4554,24 @@ bAdd_PMKID_Candidate(
 	if (pDevice->gsPMKIDCandidate.NumCandidates >= MAX_PMKIDLIST)
 		return false;
 
-	// Update Old Candidate
+	/* Update Old Candidate */
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
 			return true;
 		}
 	}
 
-	// New Candidate
+	/* New Candidate */
 	pCandidateList = &pDevice->gsPMKIDCandidate.CandidateList[pDevice->gsPMKIDCandidate.NumCandidates];
-	if (psRSNCapObj->bRSNCapExist && (psRSNCapObj->wRSNCap & BIT0)) {
+	if (psRSNCapObj->bRSNCapExist && (psRSNCapObj->wRSNCap & BIT0))
 		pCandidateList->Flags |= NDIS_802_11_PMKID_CANDIDATE_PREAUTH_ENABLED;
-	} else {
+	else
 		pCandidateList->Flags &= ~(NDIS_802_11_PMKID_CANDIDATE_PREAUTH_ENABLED);
-	}
 	memcpy(pCandidateList->BSSID, pbyBSSID, ETH_ALEN);
 	pDevice->gsPMKIDCandidate.NumCandidates++;
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "NumCandidates:%d\n", (int)pDevice->gsPMKIDCandidate.NumCandidates);
@@ -4639,19 +4620,20 @@ s_bCipherMatch(
 	if (pBSSNode == NULL)
 		return false;
 
-	// check cap. of BSS
+	/* check cap. of BSS */
 	if ((WLAN_GET_CAP_INFO_PRIVACY(pBSSNode->wCapInfo) != 0) &&
 	    (EncStatus == Ndis802_11Encryption1Enabled)) {
-		// default is WEP only
+		/* default is WEP only */
 		byMulticastCipher = KEY_CTL_WEP;
 	}
 
 	if ((WLAN_GET_CAP_INFO_PRIVACY(pBSSNode->wCapInfo) != 0) &&
 	    pBSSNode->bWPA2Valid &&
-	    //20080123-01,<Add> by Einsn Liu
+	    /* 20080123-01,<Add> by Einsn Liu */
 	    ((EncStatus == Ndis802_11Encryption3Enabled) || (EncStatus == Ndis802_11Encryption2Enabled))) {
-		//WPA2
-		// check Group Key Cipher
+		/* WPA2
+		 * check Group Key Cipher
+		 */
 		if ((pBSSNode->byCSSGK == WLAN_11i_CSS_WEP40) ||
 		    (pBSSNode->byCSSGK == WLAN_11i_CSS_WEP104)) {
 			byMulticastCipher = KEY_CTL_WEP;
@@ -4663,18 +4645,18 @@ s_bCipherMatch(
 			byMulticastCipher = KEY_CTL_INVALID;
 		}
 
-		// check Pairwise Key Cipher
+		/* check Pairwise Key Cipher */
 		for (i = 0; i < pBSSNode->wCSSPKCount; i++) {
 			if ((pBSSNode->abyCSSPK[i] == WLAN_11i_CSS_WEP40) ||
 			    (pBSSNode->abyCSSPK[i] == WLAN_11i_CSS_WEP104)) {
-				// this should not happen as defined 802.11i
+				/* this should not happen as defined 802.11i */
 				byCipherMask |= 0x01;
 			} else if (pBSSNode->abyCSSPK[i] == WLAN_11i_CSS_TKIP) {
 				byCipherMask |= 0x02;
 			} else if (pBSSNode->abyCSSPK[i] == WLAN_11i_CSS_CCMP) {
 				byCipherMask |= 0x04;
 			} else if (pBSSNode->abyCSSPK[i] == WLAN_11i_CSS_USE_GROUP) {
-				// use group key only ignore all others
+				/* use group key only ignore all others */
 				byCipherMask = 0;
 				i = pBSSNode->wCSSPKCount;
 			}
@@ -4683,8 +4665,9 @@ s_bCipherMatch(
 	} else if ((WLAN_GET_CAP_INFO_PRIVACY(pBSSNode->wCapInfo) != 0) &&
 		   pBSSNode->bWPAValid &&
 		   ((EncStatus == Ndis802_11Encryption3Enabled) || (EncStatus == Ndis802_11Encryption2Enabled))) {
-		//WPA
-		// check Group Key Cipher
+		/* WPA
+		 * check Group Key Cipher
+		 */
 		if ((pBSSNode->byGKType == WPA_WEP40) ||
 		    (pBSSNode->byGKType == WPA_WEP104)) {
 			byMulticastCipher = KEY_CTL_WEP;
@@ -4696,14 +4679,14 @@ s_bCipherMatch(
 			byMulticastCipher = KEY_CTL_INVALID;
 		}
 
-		// check Pairwise Key Cipher
+		/* check Pairwise Key Cipher */
 		for (i = 0; i < pBSSNode->wPKCount; i++) {
 			if (pBSSNode->abyPKType[i] == WPA_TKIP) {
 				byCipherMask |= 0x02;
 			} else if (pBSSNode->abyPKType[i] == WPA_AESCCMP) {
 				byCipherMask |= 0x04;
 			} else if (pBSSNode->abyPKType[i] == WPA_NONE) {
-				// use group key only ignore all others
+				/* use group key only ignore all others */
 				byCipherMask = 0;
 				i = pBSSNode->wPKCount;
 			}
@@ -4713,9 +4696,9 @@ s_bCipherMatch(
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%d, %d, %d, %d, EncStatus:%d\n",
 		byMulticastCipher, byCipherMask, pBSSNode->bWPAValid, pBSSNode->bWPA2Valid, EncStatus);
 
-	// mask our cap. with BSS
+	/* mask our cap. with BSS */
 	if (EncStatus == Ndis802_11Encryption1Enabled) {
-		// For supporting Cisco migration mode, don't care pairwise key cipher
+		/* For supporting Cisco migration mode, don't care pairwise key cipher */
 		if ((byMulticastCipher == KEY_CTL_WEP) &&
 		    (byCipherMask == 0)) {
 			*pbyCCSGK = KEY_CTL_WEP;
@@ -4747,7 +4730,7 @@ s_bCipherMatch(
 	} else if (EncStatus == Ndis802_11Encryption3Enabled) {
 		if ((byMulticastCipher == KEY_CTL_CCMP) &&
 		    (byCipherMask == 0)) {
-			// When CCMP is enable, "Use group cipher suite" shall not be a valid option.
+			/* When CCMP is enable, "Use group cipher suite" shall not be a valid option. */
 			return false;
 		} else if ((byMulticastCipher == KEY_CTL_WEP) &&
 			   ((byCipherMask & 0x04) != 0)) {
diff --git a/drivers/staging/vt6655/wmgr.h b/drivers/staging/vt6655/wmgr.h
index 4026843..e0c9e4c 100644
--- a/drivers/staging/vt6655/wmgr.h
+++ b/drivers/staging/vt6655/wmgr.h
@@ -45,24 +45,24 @@
 
 /*---------------------  Export Definitions -------------------------*/
 
-// Scan time
-#define PROBE_DELAY                  100  // (us)
-#define SWITCH_CHANNEL_DELAY         200 // (us)
-#define WLAN_SCAN_MINITIME           25   // (ms)
-#define WLAN_SCAN_MAXTIME            100  // (ms)
-#define TRIVIAL_SYNC_DIFFERENCE      0    // (us)
-#define DEFAULT_IBSS_BI              100  // (ms)
+/* Scan time */
+#define PROBE_DELAY                  100  /* (us) */
+#define SWITCH_CHANNEL_DELAY         200  /* (us) */
+#define WLAN_SCAN_MINITIME           25   /* (ms) */
+#define WLAN_SCAN_MAXTIME            100  /* (ms) */
+#define TRIVIAL_SYNC_DIFFERENCE      0    /* (us) */
+#define DEFAULT_IBSS_BI              100  /* (ms) */
 
-#define WCMD_ACTIVE_SCAN_TIME   50 //(ms)
-#define WCMD_PASSIVE_SCAN_TIME  100 //(ms)
+#define WCMD_ACTIVE_SCAN_TIME   50  /* (ms) */
+#define WCMD_PASSIVE_SCAN_TIME  100 /* (ms) */
 
-#define DEFAULT_MSDU_LIFETIME           512  // ms
-#define DEFAULT_MSDU_LIFETIME_RES_64us  8000 // 64us
+#define DEFAULT_MSDU_LIFETIME           512  /* ms */
+#define DEFAULT_MSDU_LIFETIME_RES_64us  8000 /* 64us */
 
-#define DEFAULT_MGN_LIFETIME            8    // ms
-#define DEFAULT_MGN_LIFETIME_RES_64us   125  // 64us
+#define DEFAULT_MGN_LIFETIME            8    /* ms */
+#define DEFAULT_MGN_LIFETIME_RES_64us   125  /* 64us */
 
-#define MAKE_BEACON_RESERVED            10  //(us)
+#define MAKE_BEACON_RESERVED            10  /* (us) */
 
 #define TIM_MULTICAST_MASK           0x01
 #define TIM_BITMAPOFFSET_MASK        0xFE
@@ -70,7 +70,7 @@
 
 #define AP_LONG_RETRY_LIMIT             4
 
-#define DEFAULT_IBSS_CHANNEL            6  //2.4G
+#define DEFAULT_IBSS_CHANNEL            6  /* 2.4G */
 
 /*---------------------  Export Classes  ----------------------------*/
 
@@ -80,44 +80,41 @@
 #define timer_expire(timer, next_tick)   mod_timer(&timer, RUN_AT(next_tick))
 typedef void (*TimerFunction)(unsigned long);
 
-//+++ NDIS related
+/* +++ NDIS related */
 
 typedef unsigned char NDIS_802_11_MAC_ADDRESS[6];
-typedef struct _NDIS_802_11_AI_REQFI
-{
+struct NDIS_802_11_AI_REQFI {
 	unsigned short Capabilities;
 	unsigned short ListenInterval;
 	NDIS_802_11_MAC_ADDRESS  CurrentAPAddress;
-} NDIS_802_11_AI_REQFI, *PNDIS_802_11_AI_REQFI;
+};
 
-typedef struct _NDIS_802_11_AI_RESFI
-{
+struct NDIS_802_11_AI_RESFI {
 	unsigned short Capabilities;
 	unsigned short StatusCode;
 	unsigned short AssociationId;
-} NDIS_802_11_AI_RESFI, *PNDIS_802_11_AI_RESFI;
+};
 
-typedef struct _NDIS_802_11_ASSOCIATION_INFORMATION
-{
+struct NDIS_802_11_ASSOCIATION_INFORMATION {
 	unsigned long Length;
 	unsigned short          AvailableRequestFixedIEs;
-	NDIS_802_11_AI_REQFI    RequestFixedIEs;
+	struct NDIS_802_11_AI_REQFI    RequestFixedIEs;
 	unsigned long RequestIELength;
 	unsigned long OffsetRequestIEs;
 	unsigned short          AvailableResponseFixedIEs;
-	NDIS_802_11_AI_RESFI    ResponseFixedIEs;
+	struct NDIS_802_11_AI_RESFI    ResponseFixedIEs;
 	unsigned long ResponseIELength;
 	unsigned long OffsetResponseIEs;
-} NDIS_802_11_ASSOCIATION_INFORMATION, *PNDIS_802_11_ASSOCIATION_INFORMATION;
+};
 
-typedef struct tagSAssocInfo {
-	NDIS_802_11_ASSOCIATION_INFORMATION     AssocInfo;
+struct SAssocInfo {
+	struct NDIS_802_11_ASSOCIATION_INFORMATION     AssocInfo;
 	unsigned char abyIEs[WLAN_BEACON_FR_MAXLEN+WLAN_BEACON_FR_MAXLEN];
-	// store ReqIEs set by OID_802_11_ASSOCIATION_INFORMATION
+	/* store ReqIEs set by OID_802_11_ASSOCIATION_INFORMATION */
 	unsigned long RequestIELength;
 	unsigned char abyReqIEs[WLAN_BEACON_FR_MAXLEN];
-} SAssocInfo, *PSAssocInfo;
-//---
+};
+/*--- */
 
 /*
   typedef enum tagWMAC_AUTHENTICATION_MODE {
@@ -134,7 +131,7 @@ typedef struct tagSAssocInfo {
   } WMAC_AUTHENTICATION_MODE, *PWMAC_AUTHENTICATION_MODE;
 */
 
-// Pre-configured Mode (from XP)
+/* Pre-configured Mode (from XP) */
 /*
   typedef enum tagWMAC_CONFIG_MODE {
   WMAC_CONFIG_ESS_STA,
@@ -145,29 +142,30 @@ typedef struct tagSAssocInfo {
   } WMAC_CONFIG_MODE, *PWMAC_CONFIG_MODE;
 */
 
-typedef enum tagWMAC_SCAN_TYPE {
+enum WMAC_SCAN_TYPE {
 	WMAC_SCAN_ACTIVE,
 	WMAC_SCAN_PASSIVE,
 	WMAC_SCAN_HYBRID
-} WMAC_SCAN_TYPE, *PWMAC_SCAN_TYPE;
+};
 
-typedef enum tagWMAC_SCAN_STATE {
+enum WMAC_SCAN_STATE {
 	WMAC_NO_SCANNING,
 	WMAC_IS_SCANNING,
 	WMAC_IS_PROBEPENDING
-} WMAC_SCAN_STATE, *PWMAC_SCAN_STATE;
-
-// Notes:
-// Basic Service Set state explained as following:
-// WMAC_STATE_IDLE          : no BSS is selected (Adhoc or Infra)
-// WMAC_STATE_STARTED       : no BSS is selected, start own IBSS (Adhoc only)
-// WMAC_STATE_JOINTED       : BSS is selected and synchronized (Adhoc or Infra)
-// WMAC_STATE_AUTHPENDING   : Authentication pending (Infra)
-// WMAC_STATE_AUTH          : Authenticated (Infra)
-// WMAC_STATE_ASSOCPENDING  : Association pending (Infra)
-// WMAC_STATE_ASSOC         : Associated (Infra)
-
-typedef enum tagWMAC_BSS_STATE {
+};
+
+/* Notes:
+ * Basic Service Set state explained as following:
+ * WMAC_STATE_IDLE          : no BSS is selected (Adhoc or Infra)
+ * WMAC_STATE_STARTED       : no BSS is selected, start own IBSS (Adhoc only)
+ * WMAC_STATE_JOINTED       : BSS is selected and synchronized (Adhoc or Infra)
+ * WMAC_STATE_AUTHPENDING   : Authentication pending (Infra)
+ * WMAC_STATE_AUTH          : Authenticated (Infra)
+ * WMAC_STATE_ASSOCPENDING  : Association pending (Infra)
+ * WMAC_STATE_ASSOC         : Associated (Infra)
+ */
+
+enum WMAC_BSS_STATE {
 	WMAC_STATE_IDLE,
 	WMAC_STATE_STARTED,
 	WMAC_STATE_JOINTED,
@@ -175,15 +173,15 @@ typedef enum tagWMAC_BSS_STATE {
 	WMAC_STATE_AUTH,
 	WMAC_STATE_ASSOCPENDING,
 	WMAC_STATE_ASSOC
-} WMAC_BSS_STATE, *PWMAC_BSS_STATE;
+};
 
-// WMAC selected running mode
-typedef enum tagWMAC_CURRENT_MODE {
+/* WMAC selected running mode */
+enum WMAC_CURRENT_MODE {
 	WMAC_MODE_STANDBY,
 	WMAC_MODE_ESS_STA,
 	WMAC_MODE_IBSS_STA,
 	WMAC_MODE_ESS_AP
-} WMAC_CURRENT_MODE, *PWMAC_CURRENT_MODE;
+};
 
 /*
   typedef enum tagWMAC_POWER_MODE {
@@ -194,14 +192,14 @@ typedef enum tagWMAC_CURRENT_MODE {
   } WMAC_POWER_MODE, *PWMAC_POWER_MODE;
 */
 
-// Tx Management Packet descriptor
+/* Tx Management Packet descriptor */
 typedef struct tagSTxMgmtPacket {
 	union UWLAN_80211HDR *p80211Header;
 	unsigned int cbMPDULen;
 	unsigned int cbPayloadLen;
 } STxMgmtPacket, *PSTxMgmtPacket;
 
-// Rx Management Packet descriptor
+/* Rx Management Packet descriptor */
 typedef struct tagSRxMgmtPacket {
 	union UWLAN_80211HDR *p80211Header;
 	QWORD               qwLocalTSF;
@@ -213,32 +211,32 @@ typedef struct tagSRxMgmtPacket {
 	unsigned char byRxChannel;
 } SRxMgmtPacket, *PSRxMgmtPacket;
 
-typedef struct tagSMgmtObject
-{
+typedef struct tagSMgmtObject {
 	void *pAdapter;
-	// MAC address
+	/* MAC address */
 	unsigned char abyMACAddr[WLAN_ADDR_LEN];
 
-	// Configuration Mode
-	WMAC_CONFIG_MODE        eConfigMode; // MAC pre-configed mode
+	/* Configuration Mode */
+	WMAC_CONFIG_MODE        eConfigMode; /* MAC pre-configed mode */
 	CARD_PHY_TYPE           eCurrentPHYMode;
 	CARD_PHY_TYPE           eConfigPHYMode;
 
-	// Operation state variables
-	WMAC_CURRENT_MODE       eCurrMode;   // MAC current connection mode
-	WMAC_BSS_STATE          eCurrState;  // MAC current BSS state
+	/* Operation state variables */
+	enum WMAC_CURRENT_MODE  eCurrMode;   /* MAC current connection mode */
+	enum WMAC_BSS_STATE     eCurrState;  /* MAC current BSS state */
 
 	PKnownBSS               pCurrBSS;
 	unsigned char byCSSGK;
 	unsigned char byCSSPK;
 
-//    unsigned char abyNewSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN];
-//    unsigned char abyNewExtSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN];
+/*    unsigned char abyNewSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN]; */
+/*    unsigned char abyNewExtSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN]; */
 
-	// Current state vars
+	/* Current state vars */
 	unsigned int	uCurrChannel;
 	unsigned char abyCurrSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1];
-	unsigned char abyCurrExtSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1];
+	unsigned char abyCurrExtSuppRates[WLAN_IEHDR_LEN
+					  + WLAN_RATES_MAXLEN + 1];
 	unsigned char abyCurrSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
 	unsigned char abyCurrBSSID[WLAN_BSSID_LEN];
 	unsigned short wCurrCapInfo;
@@ -251,12 +249,13 @@ typedef struct tagSMgmtObject
 	CMD_STATE               eCommandState;
 	unsigned int	uScanChannel;
 
-	// Desire joining BSS vars
+	/* Desire joining BSS vars */
 	unsigned char abyDesireSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
 	unsigned char abyDesireBSSID[WLAN_BSSID_LEN];
 
-	// Adhoc or AP configuration vars
-	//unsigned char abyAdHocSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
+	/* Adhoc or AP configuration vars
+	 * unsigned char abyAdHocSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
+	 */
 	unsigned short wIBSSBeaconPeriod;
 	unsigned short wIBSSATIMWindow;
 	unsigned int	uIBSSChannel;
@@ -268,79 +267,85 @@ typedef struct tagSMgmtObject
 	unsigned int	uAssocCount;
 	bool bMoreData;
 
-	// Scan state vars
-	WMAC_SCAN_STATE         eScanState;
-	WMAC_SCAN_TYPE          eScanType;
+	/* Scan state vars */
+	enum WMAC_SCAN_STATE         eScanState;
+	enum WMAC_SCAN_TYPE          eScanType;
 	unsigned int	uScanStartCh;
 	unsigned int	uScanEndCh;
 	unsigned short wScanSteps;
 	unsigned int	uScanBSSType;
-	// Desire scanning vars
-	unsigned char abyScanSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
+	/* Desire scanning vars */
+	unsigned char abyScanSSID[WLAN_IEHDR_LEN
+				  + WLAN_SSID_MAXLEN + 1];
 	unsigned char abyScanBSSID[WLAN_BSSID_LEN];
 
-	// Privacy
+	/* Privacy */
 	WMAC_AUTHENTICATION_MODE eAuthenMode;
 	WMAC_ENCRYPTION_MODE    eEncryptionMode;
 	bool bShareKeyAlgorithm;
 	unsigned char abyChallenge[WLAN_CHALLENGE_LEN];
 	bool bPrivacyInvoked;
 
-	// Received beacon state vars
+	/* Received beacon state vars */
 	bool bInTIM;
 	bool bMulticastTIM;
 	unsigned char byDTIMCount;
 	unsigned char byDTIMPeriod;
 
-	// Power saving state vars
+	/* Power saving state vars */
 	WMAC_POWER_MODE         ePSMode;
 	unsigned short wListenInterval;
 	unsigned short wCountToWakeUp;
 	bool bInTIMWake;
 	unsigned char *pbyPSPacketPool;
-	unsigned char byPSPacketPool[sizeof(STxMgmtPacket) + WLAN_NULLDATA_FR_MAXLEN];
+	unsigned char byPSPacketPool[sizeof(STxMgmtPacket)
+				     + WLAN_NULLDATA_FR_MAXLEN];
 	bool bRxBeaconInTBTTWake;
 	unsigned char abyPSTxMap[MAX_NODE_NUM + 1];
 
-	// management command related
+	/* management command related */
 	unsigned int	uCmdBusy;
 	unsigned int	uCmdHostAPBusy;
 
-	// management packet pool
+	/* management packet pool */
 	unsigned char *pbyMgmtPacketPool;
-	unsigned char byMgmtPacketPool[sizeof(STxMgmtPacket) + WLAN_A3FR_MAXLEN];
+	unsigned char byMgmtPacketPool[sizeof(STxMgmtPacket)
+				       + WLAN_A3FR_MAXLEN];
 
-	// One second callback timer
+	/* One second callback timer */
 	struct timer_list	    sTimerSecondCallback;
 
-	// Temporarily Rx Mgmt Packet Descriptor
+	/* Temporarily Rx Mgmt Packet Descriptor */
 	SRxMgmtPacket           sRxPacket;
 
-	// link list of known bss's (scan results)
+	/* link list of known bss's (scan results) */
 	KnownBSS                sBSSList[MAX_BSS_NUM];
 
-	// table list of known node
-	// sNodeDBList[0] is reserved for AP under Infra mode
-	// sNodeDBList[0] is reserved for Multicast under adhoc/AP mode
+	/* table list of known node
+	 * sNodeDBList[0] is reserved for AP under Infra mode
+	 * sNodeDBList[0] is reserved for Multicast under adhoc/AP mode
+	 */
 	KnownNodeDB             sNodeDBTable[MAX_NODE_NUM + 1];
 
-	// WPA2 PMKID Cache
+	/* WPA2 PMKID Cache */
 	struct SPMKIDCache      gsPMKIDCache;
 	bool bRoaming;
 
-	// rate fall back vars
+	/* rate fall back vars */
 
-	// associate info
-	SAssocInfo              sAssocInfo;
+	/* associate info */
+	struct SAssocInfo              sAssocInfo;
 
-	// for 802.11h
+	/* for 802.11h */
 	bool b11hEnable;
 	bool bSwitchChannel;
 	unsigned char byNewChannel;
 	PWLAN_IE_MEASURE_REP    pCurrMeasureEIDRep;
 	unsigned int	uLengthOfRepEIDs;
-	unsigned char abyCurrentMSRReq[sizeof(STxMgmtPacket) + WLAN_A3FR_MAXLEN];
-	unsigned char abyCurrentMSRRep[sizeof(STxMgmtPacket) + WLAN_A3FR_MAXLEN];
+	unsigned char abyCurrentMSRReq[sizeof(STxMgmtPacket)
+				       + WLAN_A3FR_MAXLEN];
+	unsigned char abyCurrentMSRRep[sizeof(STxMgmtPacket)
+				       + WLAN_A3FR_MAXLEN];
 	unsigned char abyIECountry[WLAN_A3FR_MAXLEN];
 	unsigned char abyIBSSDFSOwner[6];
 	unsigned char byIBSSDFSRecovery;
@@ -451,4 +456,4 @@ vFlush_PMKID_Candidate(
 	void *hDeviceContext
 );
 
-#endif // __WMGR_H__
+#endif /* __WMGR_H__ */
-- 
1.8.1.2

