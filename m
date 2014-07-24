Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934772AbaGXXL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:11:29 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:51682 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965AbaGXXHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:07:06 -0400
X-Originating-IP: 109.10.215.15
From: Guillaume Clement <gclement@baobob.org>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Guillaume Clement <gclement@baobob.org>
Subject: [PATCH 01/14] staging: vt6655: remove useless return statements
Date: Fri, 25 Jul 2014 01:06:15 +0200
Message-Id: <1406243188-13413-2-git-send-email-gclement@baobob.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1406243188-13413-1-git-send-email-gclement@baobob.org>
References: <1406243188-13413-1-git-send-email-gclement@baobob.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many return statements in void function were present at the end of
functions, with no effect. They now are removed.

This fixes a bunch of checkpatch warnings.

Signed-off-by: Guillaume Clement <gclement@baobob.org>
---
 drivers/staging/vt6655/80211mgr.c    | 36 -------------------------------
 drivers/staging/vt6655/baseband.c    |  3 ---
 drivers/staging/vt6655/bssdb.c       |  8 -------
 drivers/staging/vt6655/card.c        |  4 ----
 drivers/staging/vt6655/datarate.c    |  2 --
 drivers/staging/vt6655/device_main.c |  2 --
 drivers/staging/vt6655/hostap.c      |  2 --
 drivers/staging/vt6655/key.c         |  1 -
 drivers/staging/vt6655/power.c       |  4 ----
 drivers/staging/vt6655/rxtx.c        |  4 ----
 drivers/staging/vt6655/vntwifi.c     |  3 ---
 drivers/staging/vt6655/wcmd.c        |  2 --
 drivers/staging/vt6655/wmgr.c        | 41 ------------------------------------
 13 files changed, 112 deletions(-)

diff --git a/drivers/staging/vt6655/80211mgr.c b/drivers/staging/vt6655/80211mgr.c
index 9aa2e46..acdbbbd 100644
--- a/drivers/staging/vt6655/80211mgr.c
+++ b/drivers/staging/vt6655/80211mgr.c
@@ -102,8 +102,6 @@ vMgrEncodeBeacon(
 			     WLAN_BEACON_OFF_CAPINFO);
 
 	pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_BEACON_OFF_SSID;
-
-	return;
 }
 
 /*+
@@ -228,8 +226,6 @@ vMgrDecodeBeacon(
 		}
 		pItem = (PWLAN_IE)(((unsigned char *)pItem) + 2 + pItem->len);
 	}
-
-	return;
 }
 
 /*+
@@ -250,8 +246,6 @@ vMgrEncodeIBSSATIM(
 {
 	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 	pFrame->len = WLAN_HDR_ADDR3_LEN;
-
-	return;
 }
 
 /*+
@@ -271,8 +265,6 @@ vMgrDecodeIBSSATIM(
 )
 {
 	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
-
-	return;
 }
 
 /*+
@@ -299,8 +291,6 @@ vMgrEncodeDisassociation(
 			    WLAN_DISASSOC_OFF_REASON);
 	pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_DISASSOC_OFF_REASON +
 		      sizeof(*(pFrame->pwReason));
-
-	return;
 }
 
 /*+
@@ -325,8 +315,6 @@ vMgrDecodeDisassociation(
 	pFrame->pwReason = (unsigned short *)
 			   (WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3)) +
 			    WLAN_DISASSOC_OFF_REASON);
-
-	return;
 }
 
 /*+
@@ -355,7 +343,6 @@ vMgrEncodeAssocRequest(
 				    WLAN_ASSOCREQ_OFF_LISTEN_INT);
 	pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_ASSOCREQ_OFF_LISTEN_INT +
 		      sizeof(*(pFrame->pwListenInterval));
-	return;
 }
 
 /*+
@@ -426,7 +413,6 @@ vMgrDecodeAssocRequest(
 		}
 		pItem = (PWLAN_IE)(((unsigned char *)pItem) + 2 + pItem->len);
 	}
-	return;
 }
 
 /*+
@@ -459,8 +445,6 @@ vMgrEncodeAssocResponse(
 			 WLAN_ASSOCRESP_OFF_AID);
 	pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_ASSOCRESP_OFF_AID +
 		      sizeof(*(pFrame->pwAid));
-
-	return;
 }
 
 /*+
@@ -511,7 +495,6 @@ vMgrDecodeAssocResponse(
 	} else {
 		pFrame->pExtSuppRates = NULL;
 	}
-	return;
 }
 
 /*+
@@ -544,8 +527,6 @@ vMgrEncodeReassocRequest(
 			       WLAN_REASSOCREQ_OFF_CURR_AP);
 	pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_REASSOCREQ_OFF_CURR_AP +
 		      sizeof(*(pFrame->pAddrCurrAP));
-
-	return;
 }
 
 /*+
@@ -619,7 +600,6 @@ vMgrDecodeReassocRequest(
 		}
 		pItem = (PWLAN_IE)(((unsigned char *)pItem) + 2 + pItem->len);
 	}
-	return;
 }
 
 /*+
@@ -640,7 +620,6 @@ vMgrEncodeProbeRequest(
 {
 	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 	pFrame->len = WLAN_HDR_ADDR3_LEN;
-	return;
 }
 
 /*+
@@ -694,7 +673,6 @@ vMgrDecodeProbeRequest(
 
 		pItem = (PWLAN_IE)(((unsigned char *)pItem) + 2 +  pItem->len);
 	}
-	return;
 }
 
 /*+
@@ -728,8 +706,6 @@ vMgrEncodeProbeResponse(
 
 	pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_PROBERESP_OFF_CAP_INFO +
 		      sizeof(*(pFrame->pwCapInfo));
-
-	return;
 }
 
 /*+
@@ -850,7 +826,6 @@ vMgrDecodeProbeResponse(
 
 		pItem = (PWLAN_IE)(((unsigned char *)pItem) + 2 +  pItem->len);
 	}
-	return;
 }
 
 /*+
@@ -883,8 +858,6 @@ vMgrEncodeAuthen(
 			    WLAN_AUTHEN_OFF_STATUS);
 	pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_AUTHEN_OFF_STATUS +
 		      sizeof(*(pFrame->pwStatus));
-
-	return;
 }
 
 /*+
@@ -925,8 +898,6 @@ vMgrDecodeAuthen(
 	if (((unsigned char *)pItem) < (pFrame->pBuf + pFrame->len) &&
 	    pItem->byElementID == WLAN_EID_CHALLENGE)
 		pFrame->pChallenge = (PWLAN_IE_CHALLENGE)pItem;
-
-	return;
 }
 
 /*+
@@ -953,8 +924,6 @@ vMgrEncodeDeauthen(
 			    WLAN_DEAUTHEN_OFF_REASON);
 	pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_DEAUTHEN_OFF_REASON +
 		      sizeof(*(pFrame->pwReason));
-
-	return;
 }
 
 /*+
@@ -979,8 +948,6 @@ vMgrDecodeDeauthen(
 	pFrame->pwReason = (unsigned short *)
 			   (WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3)) +
 			    WLAN_DEAUTHEN_OFF_REASON);
-
-	return;
 }
 
 /*+
@@ -1014,8 +981,6 @@ vMgrEncodeReassocResponse(
 
 	pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_REASSOCRESP_OFF_AID +
 		      sizeof(*(pFrame->pwAid));
-
-	return;
 }
 
 /*+
@@ -1061,5 +1026,4 @@ vMgrDecodeReassocResponse(
 	    (pItem->byElementID == WLAN_EID_EXTSUPP_RATES)) {
 		pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
 	}
-	return;
 }
diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index 67bc3b4..c96bc7a 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -2814,7 +2814,6 @@ TimerSQ3CallBack(
 	add_timer(&pDevice->TimerSQ3Tmax2);
 
 	spin_unlock_irq(&pDevice->lock);
-	return;
 }
 
 /*+
@@ -2873,6 +2872,4 @@ TimerState1CallBack(
 	pDevice->byAntennaState = 0;
 	BBvClearAntDivSQ3Value(pDevice);
 	spin_unlock_irq(&pDevice->lock);
-
-	return;
 }
diff --git a/drivers/staging/vt6655/bssdb.c b/drivers/staging/vt6655/bssdb.c
index eb3474d..5f9fd2b 100644
--- a/drivers/staging/vt6655/bssdb.c
+++ b/drivers/staging/vt6655/bssdb.c
@@ -262,8 +262,6 @@ BSSvClearBSSList(
 		memset(&pMgmt->sBSSList[ii], 0, sizeof(KnownBSS));
 	}
 	BSSvClearAnyBSSJoinRecord(pDevice);
-
-	return;
 }
 
 /*+
@@ -1235,7 +1233,6 @@ start:
 
 	pMgmt->sTimerSecondCallback.expires = RUN_AT(HZ);
 	add_timer(&pMgmt->sTimerSecondCallback);
-	return;
 }
 
 /*+
@@ -1385,8 +1382,6 @@ BSSvUpdateNodeTxCounter(
 			}
 		}
 	}
-
-	return;
 }
 
 /*+
@@ -1494,7 +1489,6 @@ BSSvClearAnyBSSJoinRecord(
 
 	for (ii = 0; ii < MAX_BSS_NUM; ii++)
 		pMgmt->sBSSList[ii].bSelected = false;
-	return;
 }
 
 #ifdef Calcu_LinkQual
@@ -1535,7 +1529,6 @@ void s_uCalculateLinkQual(
 	pDevice->scStatistic.TxFailCount = 0;
 	pDevice->scStatistic.TxNoRetryOkCount = 0;
 	pDevice->scStatistic.TxRetryOkCount = 0;
-	return;
 }
 #endif
 
@@ -1553,5 +1546,4 @@ void s_vCheckPreEDThreshold(
 		if (pBSSList != NULL)
 			pDevice->byBBPreEDRSSI = (unsigned char) (~(pBSSList->ldBmAverRange) + 1);
 	}
-	return;
 }
diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index e29dcd8..f2674b4 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -2065,8 +2065,6 @@ void CARDvSetFirstNextTBTT(void __iomem *dwIoBase, unsigned short wBeaconInterva
 	VNSvOutPortD(dwIoBase + MAC_REG_NEXTTBTT, LODWORD(qwNextTBTT));
 	VNSvOutPortD(dwIoBase + MAC_REG_NEXTTBTT + 4, HIDWORD(qwNextTBTT));
 	MACvRegBitsOn(dwIoBase, MAC_REG_TFTCTL, TFTCTL_TBTTSYNCEN);
-
-	return;
 }
 
 /*
@@ -2093,6 +2091,4 @@ void CARDvUpdateNextTBTT(void __iomem *dwIoBase, QWORD qwTSF, unsigned short wBe
 	MACvRegBitsOn(dwIoBase, MAC_REG_TFTCTL, TFTCTL_TBTTSYNCEN);
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Card:Update Next TBTT[%8xh:%8xh] \n",
 		(unsigned int) HIDWORD(qwTSF), (unsigned int) LODWORD(qwTSF));
-
-	return;
 }
diff --git a/drivers/staging/vt6655/datarate.c b/drivers/staging/vt6655/datarate.c
index 83ad74c..565028c 100644
--- a/drivers/staging/vt6655/datarate.c
+++ b/drivers/staging/vt6655/datarate.c
@@ -367,8 +367,6 @@ RATEvTxRateFallBack(
 	/* 2008-5-8 <add> by chester */
 	TxRate_iwconfig = psNodeDBTable->wTxDataRate;
 	s_vResetCounter(psNodeDBTable);
-
-	return;
 }
 
 /*+
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index fe9e13c..f46e8d4 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -756,8 +756,6 @@ static void device_init_diversity_timer(PSDevice pDevice) {
 	pDevice->TimerSQ3Tmax3.data = (unsigned long) pDevice;
 	pDevice->TimerSQ3Tmax3.function = (TimerFunction)TimerState1CallBack;
 	pDevice->TimerSQ3Tmax3.expires = RUN_AT(HZ);
-
-	return;
 }
 
 static bool device_release_WPADEV(PSDevice pDevice)
diff --git a/drivers/staging/vt6655/hostap.c b/drivers/staging/vt6655/hostap.c
index 317c2a8..4cf85f3 100644
--- a/drivers/staging/vt6655/hostap.c
+++ b/drivers/staging/vt6655/hostap.c
@@ -394,8 +394,6 @@ static void hostap_flush_sta(PSDevice pDevice)
 	// reserved node index =0 for multicast node.
 	BSSvClearNodeDBTable(pDevice, 1);
 	pDevice->uAssocCount = 0;
-
-	return;
 }
 
 /*
diff --git a/drivers/staging/vt6655/key.c b/drivers/staging/vt6655/key.c
index f5bc4a2..27f97bc 100644
--- a/drivers/staging/vt6655/key.c
+++ b/drivers/staging/vt6655/key.c
@@ -468,7 +468,6 @@ void KeyvRemoveWEPKey(
 		}
 		s_vCheckKeyTableValid(pTable, dwIoBase);
 	}
-	return;
 }
 
 void KeyvRemoveAllWEPKey(
diff --git a/drivers/staging/vt6655/power.c b/drivers/staging/vt6655/power.c
index 5dfa911..a6e48c7 100644
--- a/drivers/staging/vt6655/power.c
+++ b/drivers/staging/vt6655/power.c
@@ -114,7 +114,6 @@ PSvEnablePowerSaving(
 
 	pDevice->bPWBitOn = true;
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "PS:Power Saving Mode Enable... \n");
-	return;
 }
 
 /*+
@@ -149,7 +148,6 @@ PSvDisablePowerSaving(
 		PSbSendNullPacket(pDevice);
 
 	pDevice->bPWBitOn = false;
-	return;
 }
 
 /*+
@@ -253,8 +251,6 @@ PSvSendPSPOLL(
 	if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Send PS-Poll packet failed..\n");
 	}
-
-	return;
 }
 
 /*+
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 60fe6db..52455cd 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -1958,8 +1958,6 @@ vGenerateFIFOHeader(PSDevice pDevice, unsigned char byPktType, unsigned char *pb
 	*pcbHeaderSize = s_cbFillTxBufHead(pDevice, byPktType, pbyTxBufferAddr, cbPayloadSize,
 					   uDMAIdx, pHeadTD, psEthHeader, pPacket, bNeedEncrypt,
 					   pTransmitKey, uNodeIndex, puMACfragNum);
-
-	return;
 }
 
 /*+
@@ -2840,6 +2838,4 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, unsigned char *pbMPDU, un
 
 	// Poll Transmit the adapter
 	MACvTransmit0(pDevice->PortOffset);
-
-	return;
 }
diff --git a/drivers/staging/vt6655/vntwifi.c b/drivers/staging/vt6655/vntwifi.c
index 085878e..8241e6b 100644
--- a/drivers/staging/vt6655/vntwifi.c
+++ b/drivers/staging/vt6655/vntwifi.c
@@ -500,8 +500,6 @@ VNTWIFIvUpdateNodeTxCounter(
 	pMgmt->sNodeDBTable[uNodeIndex].uTxRetry += pbyTxFailCount[MAX_RATE];
 	for (ii = 0; ii < MAX_RATE; ii++)
 		pMgmt->sNodeDBTable[uNodeIndex].uTxFail[ii] += pbyTxFailCount[ii];
-
-	return;
 }
 
 void
@@ -569,7 +567,6 @@ VNTWIFIvGetTxRate(
 	*pbyACKRate = byACKRate;
 	*pbyCCKBasicRate = byCCKBasicRate;
 	*pbyOFDMBasicRate = byOFDMBasicRate;
-	return;
 }
 
 unsigned char
diff --git a/drivers/staging/vt6655/wcmd.c b/drivers/staging/vt6655/wcmd.c
index a379cec..fc605f22 100644
--- a/drivers/staging/vt6655/wcmd.c
+++ b/drivers/staging/vt6655/wcmd.c
@@ -295,7 +295,6 @@ vCommandTimerWait(
 	// RUN_AT :1 msec ~= (HZ/1024)
 	pDevice->sTimerCommand.expires = (unsigned int)RUN_AT((MSecond * HZ) >> 10);
 	add_timer(&pDevice->sTimerCommand);
-	return;
 }
 
 void
@@ -796,7 +795,6 @@ vCommandTimer(
 
 	} //switch
 	spin_unlock_irq(&pDevice->lock);
-	return;
 }
 
 static
diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index 9853a8f..0b6f1e9 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -358,8 +358,6 @@ vMgrObjectInit(
 	pMgmt->byCSSGK = KEY_CTL_NONE;
 	pMgmt->wIBSSBeaconPeriod = DEFAULT_IBSS_BI;
 	BSSvClearBSSList((void *)pDevice, false);
-
-	return;
 }
 
 /*+
@@ -403,8 +401,6 @@ vMgrTimerInit(
 	pDevice->cbFreeCmdQueue = CMD_Q_SIZE;
 	pDevice->uCmdDequeueIdx = 0;
 	pDevice->uCmdEnqueueIdx = 0;
-
-	return;
 }
 
 /*+
@@ -429,8 +425,6 @@ vMgrObjectReset(
 	pMgmt->eCurrState = WMAC_STATE_IDLE;
 	pDevice->bEnablePSMode = false;
 	// TODO: timer
-
-	return;
 }
 
 /*+
@@ -498,8 +492,6 @@ vMgrAssocBeginSta(
 	} else {
 		*pStatus = CMD_STATUS_RESOURCES;
 	}
-
-	return;
 }
 
 /*+
@@ -565,8 +557,6 @@ vMgrReAssocBeginSta(
 		else
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Reassociation tx sending.\n");
 	}
-
-	return;
 }
 
 /*+
@@ -625,8 +615,6 @@ vMgrDisassocBeginSta(
 		pMgmt->eCurrState = WMAC_STATE_IDLE;
 		*pStatus = CMD_STATUS_SUCCESS;
 	}
-
-	return;
 }
 
 /*+
@@ -771,8 +759,6 @@ s_vMgrRxAssocRequest(
 		else
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Assoc response tx sending..\n");
 	}
-
-	return;
 }
 
 /*+
@@ -921,7 +907,6 @@ s_vMgrRxReAssocRequest(
 		else
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:ReAssoc response tx sending..\n");
 	}
-	return;
 }
 
 /*+
@@ -1070,7 +1055,6 @@ s_vMgrRxAssocResponse(
 
 	if (pMgmt->eCurrState == WMAC_STATE_ASSOC)
 		timer_expire(pDevice->sTimerCommand, 0);
-	return;
 }
 
 /*+
@@ -1125,8 +1109,6 @@ vMgrAuthenBeginSta(
 		pMgmt->eCurrState = WMAC_STATE_AUTHPENDING;
 		*pStatus = CMD_STATUS_SUCCESS;
 	}
-
-	return;
 }
 
 /*+
@@ -1178,8 +1160,6 @@ vMgrDeAuthenBeginSta(
 	*pStatus = csMgmt_xmit(pDevice, pTxPacket);
 	if (*pStatus == CMD_STATUS_PENDING)
 		*pStatus = CMD_STATUS_SUCCESS;
-
-	return;
 }
 
 /*+
@@ -1232,7 +1212,6 @@ s_vMgrRxAuthentication(
 			cpu_to_le16((*(sFrame.pwAuthSequence))));
 		break;
 	}
-	return;
 }
 
 /*+
@@ -1332,8 +1311,6 @@ s_vMgrRxAuthenSequence_1(
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Authreq_reply sequence_1 tx.. \n");
 	if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING)
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Authreq_reply sequence_1 tx failed.\n");
-
-	return;
 }
 
 /*+
@@ -1418,7 +1395,6 @@ s_vMgrRxAuthenSequence_2(
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt: rx auth.seq = 2 unknown AuthAlgorithm=%d\n", cpu_to_le16((*(pFrame->pwAuthAlgorithm))));
 		break;
 	}
-	return;
 }
 
 /*+
@@ -1504,8 +1480,6 @@ reply:
 
 	if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING)
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Authreq_reply sequence_4 tx failed.\n");
-
-	return;
 }
 
 /*+
@@ -1604,8 +1578,6 @@ s_vMgrRxDisassociation(
 #endif
 	}
 	/* else, ignore it */
-
-	return;
 }
 
 /*+
@@ -1688,7 +1660,6 @@ s_vMgrRxDeauthentication(
 		/* else, ignore it.  TODO: IBSS authentication service
 		   would be implemented here */
 	}
-	return;
 }
 
 //2008-8-4 <add> by chester
@@ -2197,8 +2168,6 @@ if (bUpdateTSF) {
 		CARDbGetCurrentTSF(pDevice->PortOffset, &qwCurrTSF);
 		CARDvUpdateNextTBTT(pDevice->PortOffset, qwTimestamp, pMgmt->wCurrBeaconPeriod);
 	}
-
-	return;
 }
 
 /*+
@@ -2434,8 +2403,6 @@ vMgrCreateOwnIBSS(
 	// Prepare beacon to send
 	if (bMgrPrepareBeaconToSend((void *)pDevice, pMgmt))
 		*pStatus = CMD_STATUS_SUCCESS;
-
-	return;
 }
 
 /*+
@@ -2656,7 +2623,6 @@ vMgrJoinBSSBegin(
 			pMgmt->eCurrState = WMAC_STATE_IDLE;
 		}
 	}
-	return;
 }
 
 /*+
@@ -2838,8 +2804,6 @@ static void  Encyption_Rebuild(
 			}
 		}
 	}
-
-	return;
 }
 
 /*+
@@ -4079,7 +4043,6 @@ s_vMgrRxProbeResponse(
 				    (void *)pRxPacket
 );
 	}
-	return;
 }
 
 /*+
@@ -4153,8 +4116,6 @@ s_vMgrRxProbeRequest(
 			}
 		}
 	}
-
-	return;
 }
 
 /*+
@@ -4297,8 +4258,6 @@ vMgrRxManagePacket(
 	default:
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx unknown mgmt\n");
 	}
-
-	return;
 }
 
 /*+
-- 
1.8.5.5

