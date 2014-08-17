Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbaHQQRT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 12:17:19 -0400
Received: from smtprelay0232.hostedemail.com ([216.40.44.232]:48744 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751306AbaHQQRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 12:17:15 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:69:355:379:541:960:966:968:973:981:988:989:1042:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1461:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:2194:2196:2198:2199:2200:2201:2393:2559:2562:2729:2828:2892:2895:2898:2899:2900:2901:2902:2909:2922:2923:2924:2925:2926:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:3872:4037:4078:4081:4225:4250:4321:4384:4385:4395:4419:4559:4605:4647:5007:6248:7652:7875:7903:7904:8603:8660:8957:9010:9121:9592:9901:10004:10134:10848:11026:11232:11233:11914:12043:12291:12294:12296:12438:12485:12517:12519:12555:12679:12681:12683:12729:12731:12737:12740:13138:13142:13148:13230:13231:13868:13972:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,
X-HE-Tag: month46_2102961d1d95a
X-Filterd-Recvd-Size: 202746
Message-ID: <1408292224.17489.8.camel@joe-AO725>
Subject: [PATCH V2] staging: vt6655: Convert DBG_PRT to pr_<level>
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Forest Bond <forest@alittletooquiet.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Sun, 17 Aug 2014 09:17:04 -0700
In-Reply-To: <20140817141820.GA14213@kroah.com>
References: <74a25bc8e53f22901ce926c47d3d8eac37fe1c91.1407740390.git.joe@perches.com>
	 <20140817141820.GA14213@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DBG_PRT uses are unnecessarily complex.

Convert DBG_PRT msglevel to pr_<level>.
This changes the KERN_<level> type of several uses.
It also enables dynamic_debug for the pr_debug conversions.

This patch can be a prelude to converting these pr_<level>
uses to dev_<level> as appropriate.

Other changes:

Realign arguments of these conversions.
Remove now unused static int msglevel declarations.
Remove now unused DBG_PRT #define.

Compile tested only.

Signed-off-by: Joe Perches <joe@perches.com>
---
refreshed...

 drivers/staging/vt6655/80211mgr.c    |  33 ++---
 drivers/staging/vt6655/baseband.c    |  62 ++++++----
 drivers/staging/vt6655/bssdb.c       |  57 +++++----
 drivers/staging/vt6655/card.c        |  30 ++---
 drivers/staging/vt6655/channel.c     |   7 +-
 drivers/staging/vt6655/datarate.c    |  11 +-
 drivers/staging/vt6655/device.h      |   6 -
 drivers/staging/vt6655/device_main.c | 231 ++++++++++++++++++-----------------
 drivers/staging/vt6655/dpc.c         | 129 +++++++++----------
 drivers/staging/vt6655/hostap.c      | 107 ++++++++--------
 drivers/staging/vt6655/ioctl.c       |  82 ++++++-------
 drivers/staging/vt6655/iwctl.c       | 102 ++++++++--------
 drivers/staging/vt6655/key.c         | 122 +++++++++---------
 drivers/staging/vt6655/mac.c         |  65 +++++-----
 drivers/staging/vt6655/mib.c         |  54 +++++---
 drivers/staging/vt6655/power.c       |  10 +-
 drivers/staging/vt6655/rxtx.c        |  87 +++++++------
 drivers/staging/vt6655/wcmd.c        |  84 +++++++------
 drivers/staging/vt6655/wmgr.c        | 204 ++++++++++++++++---------------
 drivers/staging/vt6655/wpa.c         |  28 ++---
 drivers/staging/vt6655/wpa2.c        |  20 +--
 drivers/staging/vt6655/wpactl.c      |  70 ++++++-----
 drivers/staging/vt6655/wroute.c      |  12 +-
 23 files changed, 840 insertions(+), 773 deletions(-)

diff --git a/drivers/staging/vt6655/80211mgr.c b/drivers/staging/vt6655/80211mgr.c
index 2c1fd82..7d2c647 100644
--- a/drivers/staging/vt6655/80211mgr.c
+++ b/drivers/staging/vt6655/80211mgr.c
@@ -63,10 +63,6 @@
 
 /*---------------------  Static Classes  ----------------------------*/
 
-/*---------------------  Static Variables  --------------------------*/
-
-static int msglevel = MSG_LEVEL_INFO;
-/* static int          msglevel                =MSG_LEVEL_DEBUG; */
 /*---------------------  Static Functions  --------------------------*/
 
 /*---------------------  Export Variables  --------------------------*/
@@ -218,9 +214,8 @@ vMgrDecodeBeacon(
 			break;
 
 		default:
-			DBG_PRT(MSG_LEVEL_DEBUG,
-				KERN_INFO "Unrecognized EID=%dd in beacon decode.\n",
-				pItem->byElementID);
+			pr_debug("Unrecognized EID=%dd in beacon decode\n",
+				 pItem->byElementID);
 			break;
 
 		}
@@ -406,9 +401,8 @@ vMgrDecodeAssocRequest(
 			break;
 
 		default:
-			DBG_PRT(MSG_LEVEL_DEBUG,
-				KERN_INFO "Unrecognized EID=%dd in assocreq decode.\n",
-				pItem->byElementID);
+			pr_debug("Unrecognized EID=%dd in assocreq decode\n",
+				 pItem->byElementID);
 			break;
 		}
 		pItem = (PWLAN_IE)(((unsigned char *)pItem) + 2 + pItem->len);
@@ -489,9 +483,7 @@ vMgrDecodeAssocResponse(
 	if ((((unsigned char *)pItem) < (pFrame->pBuf + pFrame->len)) &&
 	    (pItem->byElementID == WLAN_EID_EXTSUPP_RATES)) {
 		pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
-		DBG_PRT(MSG_LEVEL_DEBUG,
-			KERN_INFO "pFrame->pExtSuppRates=[%p].\n",
-			pItem);
+		pr_debug("pFrame->pExtSuppRates=[%p]\n", pItem);
 	} else {
 		pFrame->pExtSuppRates = NULL;
 	}
@@ -594,9 +586,8 @@ vMgrDecodeReassocRequest(
 						    (PWLAN_IE_SUPP_RATES)pItem;
 			break;
 		default:
-			DBG_PRT(MSG_LEVEL_DEBUG,
-				KERN_INFO "Unrecognized EID=%dd in reassocreq decode.\n",
-				pItem->byElementID);
+			pr_debug("Unrecognized EID=%dd in reassocreq decode\n",
+				 pItem->byElementID);
 			break;
 		}
 		pItem = (PWLAN_IE)(((unsigned char *)pItem) + 2 + pItem->len);
@@ -666,9 +657,8 @@ vMgrDecodeProbeRequest(
 			break;
 
 		default:
-			DBG_PRT(MSG_LEVEL_DEBUG,
-				KERN_INFO "Bad EID=%dd in probereq\n",
-				pItem->byElementID);
+			pr_debug("Bad EID=%dd in probereq\n",
+				 pItem->byElementID);
 			break;
 		}
 
@@ -819,9 +809,8 @@ vMgrDecodeProbeResponse(
 			break;
 
 		default:
-			DBG_PRT(MSG_LEVEL_DEBUG,
-				KERN_INFO "Bad EID=%dd in proberesp\n",
-				pItem->byElementID);
+			pr_debug("Bad EID=%dd in proberesp\n",
+				 pItem->byElementID);
 			break;
 		}
 
diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index 3d76ed5..c1025ff 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -56,10 +56,6 @@
 #include "srom.h"
 #include "rf.h"
 
-/*---------------------  Static Definitions -------------------------*/
-/* static int          msglevel                =MSG_LEVEL_DEBUG; */
-static int msglevel = MSG_LEVEL_INFO;
-
 /*---------------------  Static Classes  ----------------------------*/
 
 /*---------------------  Static Variables  --------------------------*/
@@ -2009,7 +2005,7 @@ bool BBbReadEmbedded(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned ch
 
 	if (ww == W_MAX_TIMEOUT) {
 		DBG_PORT80(0x30);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " DBG_PORT80(0x30)\n");
+		pr_debug(" DBG_PORT80(0x30)\n");
 		return false;
 	}
 	return true;
@@ -2050,7 +2046,7 @@ bool BBbWriteEmbedded(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned c
 
 	if (ww == W_MAX_TIMEOUT) {
 		DBG_PORT80(0x31);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " DBG_PORT80(0x31)\n");
+		pr_debug(" DBG_PORT80(0x31)\n");
 		return false;
 	}
 	return true;
@@ -2725,18 +2721,22 @@ void BBvAntennaDiversity(struct vnt_private *pDevice,
 
 	if (pDevice->byAntennaState == 0) {
 		if (pDevice->uDiversityCnt > pDevice->ulDiversityNValue) {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ulDiversityNValue=[%d],54M-[%d]\n",
-				(int)pDevice->ulDiversityNValue, (int)pDevice->uNumSQ3[(int)pDevice->wAntDiversityMaxRate]);
+			pr_debug("ulDiversityNValue=[%d],54M-[%d]\n",
+				 (int)pDevice->ulDiversityNValue,
+				 (int)pDevice->uNumSQ3[(int)pDevice->wAntDiversityMaxRate]);
 
 			if (pDevice->uNumSQ3[pDevice->wAntDiversityMaxRate] < pDevice->uDiversityCnt/2) {
 				pDevice->ulRatio_State0 = s_ulGetRatio(pDevice);
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "SQ3_State0, rate = [%08x]\n", (int)pDevice->ulRatio_State0);
+				pr_debug("SQ3_State0, rate = [%08x]\n",
+					 (int)pDevice->ulRatio_State0);
 
 				if (pDevice->byTMax == 0)
 					return;
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "1.[%08x], uNumSQ3[%d]=%d, %d\n",
-					(int)pDevice->ulRatio_State0, (int)pDevice->wAntDiversityMaxRate,
-					(int)pDevice->uNumSQ3[(int)pDevice->wAntDiversityMaxRate], (int)pDevice->uDiversityCnt);
+				pr_debug("1.[%08x], uNumSQ3[%d]=%d, %d\n",
+					 (int)pDevice->ulRatio_State0,
+					 (int)pDevice->wAntDiversityMaxRate,
+					 (int)pDevice->uNumSQ3[(int)pDevice->wAntDiversityMaxRate],
+					 (int)pDevice->uDiversityCnt);
 
 				s_vChangeAntenna(pDevice);
 				pDevice->byAntennaState = 1;
@@ -2758,14 +2758,17 @@ void BBvAntennaDiversity(struct vnt_private *pDevice,
 			del_timer(&pDevice->TimerSQ3Tmax1);
 
 			pDevice->ulRatio_State1 = s_ulGetRatio(pDevice);
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "RX:SQ3_State1, rate0 = %08x,rate1 = %08x\n",
-				(int)pDevice->ulRatio_State0, (int)pDevice->ulRatio_State1);
+			pr_debug("RX:SQ3_State1, rate0 = %08x,rate1 = %08x\n",
+				 (int)pDevice->ulRatio_State0,
+				 (int)pDevice->ulRatio_State1);
 
 			if (pDevice->ulRatio_State1 < pDevice->ulRatio_State0) {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "2.[%08x][%08x], uNumSQ3[%d]=%d, %d\n",
-					(int)pDevice->ulRatio_State0, (int)pDevice->ulRatio_State1,
-					(int)pDevice->wAntDiversityMaxRate,
-					(int)pDevice->uNumSQ3[(int)pDevice->wAntDiversityMaxRate], (int)pDevice->uDiversityCnt);
+				pr_debug("2.[%08x][%08x], uNumSQ3[%d]=%d, %d\n",
+					 (int)pDevice->ulRatio_State0,
+					 (int)pDevice->ulRatio_State1,
+					 (int)pDevice->wAntDiversityMaxRate,
+					 (int)pDevice->uNumSQ3[(int)pDevice->wAntDiversityMaxRate],
+					 (int)pDevice->uDiversityCnt);
 
 				s_vChangeAntenna(pDevice);
 				pDevice->TimerSQ3Tmax3.expires =  RUN_AT(pDevice->byTMax3 * HZ);
@@ -2800,10 +2803,12 @@ TimerSQ3CallBack(
 {
 	struct vnt_private *pDevice = hDeviceContext;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "TimerSQ3CallBack...");
+	pr_debug("TimerSQ3CallBack...\n");
 	spin_lock_irq(&pDevice->lock);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "3.[%08x][%08x], %d\n", (int)pDevice->ulRatio_State0, (int)pDevice->ulRatio_State1, (int)pDevice->uDiversityCnt);
+	pr_debug("3.[%08x][%08x], %d\n",
+		 (int)pDevice->ulRatio_State0, (int)pDevice->ulRatio_State1,
+		 (int)pDevice->uDiversityCnt);
 
 	s_vChangeAntenna(pDevice);
 	pDevice->byAntennaState = 0;
@@ -2842,7 +2847,7 @@ TimerState1CallBack(
 {
 	struct vnt_private *pDevice = hDeviceContext;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "TimerState1CallBack...");
+	pr_debug("TimerState1CallBack...\n");
 
 	spin_lock_irq(&pDevice->lock);
 	if (pDevice->uDiversityCnt < pDevice->ulDiversityMValue/100) {
@@ -2853,14 +2858,17 @@ TimerState1CallBack(
 		add_timer(&pDevice->TimerSQ3Tmax2);
 	} else {
 		pDevice->ulRatio_State1 = s_ulGetRatio(pDevice);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "SQ3_State1, rate0 = %08x,rate1 = %08x\n",
-			(int)pDevice->ulRatio_State0, (int)pDevice->ulRatio_State1);
+		pr_debug("SQ3_State1, rate0 = %08x,rate1 = %08x\n",
+			 (int)pDevice->ulRatio_State0,
+			 (int)pDevice->ulRatio_State1);
 
 		if (pDevice->ulRatio_State1 < pDevice->ulRatio_State0) {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "2.[%08x][%08x], uNumSQ3[%d]=%d, %d\n",
-				(int)pDevice->ulRatio_State0, (int)pDevice->ulRatio_State1,
-				(int)pDevice->wAntDiversityMaxRate,
-				(int)pDevice->uNumSQ3[(int)pDevice->wAntDiversityMaxRate], (int)pDevice->uDiversityCnt);
+			pr_debug("2.[%08x][%08x], uNumSQ3[%d]=%d, %d\n",
+				 (int)pDevice->ulRatio_State0,
+				 (int)pDevice->ulRatio_State1,
+				 (int)pDevice->wAntDiversityMaxRate,
+				 (int)pDevice->uNumSQ3[(int)pDevice->wAntDiversityMaxRate],
+				 (int)pDevice->uDiversityCnt);
 
 			s_vChangeAntenna(pDevice);
 
diff --git a/drivers/staging/vt6655/bssdb.c b/drivers/staging/vt6655/bssdb.c
index bb59b98..996d330 100644
--- a/drivers/staging/vt6655/bssdb.c
+++ b/drivers/staging/vt6655/bssdb.c
@@ -63,8 +63,6 @@
 /*---------------------  Static Classes  ----------------------------*/
 
 /*---------------------  Static Variables  --------------------------*/
-static int msglevel = MSG_LEVEL_INFO;
-
 static const unsigned short awHWRetry0[5][5] = {
 	{RATE_18M, RATE_18M, RATE_12M, RATE_12M, RATE_12M},
 	{RATE_24M, RATE_24M, RATE_18M, RATE_12M, RATE_12M},
@@ -127,8 +125,7 @@ BSSpSearchBSSList(
 	unsigned int ii = 0;
 
 	if (pbyDesireBSSID != NULL) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-			"BSSpSearchBSSList BSSID[%pM]\n", pbyDesireBSSID);
+		pr_debug("BSSpSearchBSSList BSSID[%pM]\n", pbyDesireBSSID);
 		if ((!is_broadcast_ether_addr(pbyDesireBSSID)) &&
 		    (memcmp(pbyDesireBSSID, ZeroBSSID, 6) != 0))
 			pbyBSSID = pbyDesireBSSID;
@@ -194,7 +191,9 @@ BSSpSearchBSSList(
 				    ((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA) && WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo))
 ) {
 					/* Type not match skip this BSS */
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BSS type mismatch.... Config[%d] BSS[0x%04x]\n", pMgmt->eConfigMode, pCurrBSS->wCapInfo);
+					pr_debug("BSS type mismatch.... Config[%d] BSS[0x%04x]\n",
+						 pMgmt->eConfigMode,
+						 pCurrBSS->wCapInfo);
 					continue;
 				}
 
@@ -202,7 +201,9 @@ BSSpSearchBSSList(
 					if (((ePhyType == PHY_TYPE_11A) && (PHY_TYPE_11A != pCurrBSS->eNetworkTypeInUse)) ||
 					    ((ePhyType != PHY_TYPE_11A) && (PHY_TYPE_11A == pCurrBSS->eNetworkTypeInUse))) {
 						/* PhyType not match skip this BSS */
-						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Physical type mismatch.... ePhyType[%d] BSS[%d]\n", ePhyType, pCurrBSS->eNetworkTypeInUse);
+						pr_debug("Physical type mismatch.... ePhyType[%d] BSS[%d]\n",
+							 ePhyType,
+							 pCurrBSS->eNetworkTypeInUse);
 						continue;
 					}
 				}
@@ -350,7 +351,7 @@ BSSbInsertToBSSList(
 	}
 
 	if (ii == MAX_BSS_NUM) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Get free KnowBSS node failed.\n");
+		pr_debug("Get free KnowBSS node failed\n");
 		return false;
 	}
 	/* save the BSS info */
@@ -375,7 +376,8 @@ BSSbInsertToBSSList(
 		if (pExtSuppRates->len > WLAN_RATES_MAXLEN)
 			pExtSuppRates->len = WLAN_RATES_MAXLEN;
 		memcpy(pBSSList->abyExtSuppRates, pExtSuppRates, pExtSuppRates->len + WLAN_IEHDR_LEN);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BSSbInsertToBSSList: pExtSuppRates->len = %d\n", pExtSuppRates->len);
+		pr_debug("BSSbInsertToBSSList: pExtSuppRates->len = %d\n",
+			 pExtSuppRates->len);
 
 	} else {
 		memset(pBSSList->abyExtSuppRates, 0, WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1);
@@ -740,7 +742,7 @@ BSSvCreateOneNode(void *hDeviceContext, unsigned int *puNodeIndex)
 	/* if not found replace uInActiveCount is largest one */
 	if (ii == (MAX_NODE_NUM + 1)) {
 		*puNodeIndex = SelectIndex;
-		DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Replace inactive node = %d\n", SelectIndex);
+		pr_info("Replace inactive node = %d\n", SelectIndex);
 		/* clear ps buffer */
 		if (pMgmt->sNodeDBTable[*puNodeIndex].sTxPSQueue.next != NULL) {
 			while ((skb = skb_dequeue(&pMgmt->sNodeDBTable[*puNodeIndex].sTxPSQueue)) != NULL)
@@ -757,7 +759,7 @@ BSSvCreateOneNode(void *hDeviceContext, unsigned int *puNodeIndex)
 	skb_queue_head_init(&pMgmt->sNodeDBTable[*puNodeIndex].sTxPSQueue);
 	pMgmt->sNodeDBTable[*puNodeIndex].byAuthSequence = 0;
 	pMgmt->sNodeDBTable[*puNodeIndex].wEnQueueCnt = 0;
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Create node index = %d\n", ii);
+	pr_debug("Create node index = %d\n", ii);
 	return;
 };
 
@@ -842,7 +844,8 @@ BSSvUpdateAPNode(
 	netdev_dbg(pDevice->dev, "BSSvUpdateAPNode:MaxSuppRate is %d\n",
 		   pMgmt->sNodeDBTable[0].wMaxSuppRate);
 	/* auto rate fallback function initiation */
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pMgmt->sNodeDBTable[0].wTxDataRate = %d\n", pMgmt->sNodeDBTable[0].wTxDataRate);
+	pr_debug("pMgmt->sNodeDBTable[0].wTxDataRate = %d\n",
+		 pMgmt->sNodeDBTable[0].wTxDataRate);
 };
 
 /*+
@@ -959,8 +962,8 @@ BSSvSecondCallBack(
 			if (ii > 0) {
 				if (pMgmt->sNodeDBTable[ii].uInActiveCount > MAX_INACTIVE_COUNT) {
 					BSSvRemoveOneNode(pDevice, ii);
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-						"Inactive timeout [%d] sec, STA index = [%d] remove\n", MAX_INACTIVE_COUNT, ii);
+					pr_debug("Inactive timeout [%d] sec, STA index = [%d] remove\n",
+						 MAX_INACTIVE_COUNT, ii);
 					continue;
 				}
 
@@ -1010,11 +1013,13 @@ BSSvSecondCallBack(
 
 			/* check if pending PS queue */
 			if (pMgmt->sNodeDBTable[ii].wEnQueueCnt != 0) {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Index= %d, Queue = %d pending\n",
-					ii, pMgmt->sNodeDBTable[ii].wEnQueueCnt);
+				pr_debug("Index= %d, Queue = %d pending\n",
+					 ii,
+					 pMgmt->sNodeDBTable[ii].wEnQueueCnt);
 				if ((ii > 0) && (pMgmt->sNodeDBTable[ii].wEnQueueCnt > 15)) {
 					BSSvRemoveOneNode(pDevice, ii);
-					DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Pending many queues PS STA Index = %d remove\n", ii);
+					pr_info("Pending many queues PS STA Index = %d remove\n",
+						ii);
 					continue;
 				}
 			}
@@ -1098,7 +1103,8 @@ BSSvSecondCallBack(
 				netif_stop_queue(pDevice->dev);
 				pDevice->bLinkPass = false;
 				pDevice->bRoaming = true;
-				DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Lost AP beacon [%d] sec, disconnected !\n", pMgmt->sNodeDBTable[0].uInActiveCount);
+				pr_info("Lost AP beacon [%d] sec, disconnected !\n",
+					pMgmt->sNodeDBTable[0].uInActiveCount);
 				if ((pDevice->bWPADEVUp) && (pDevice->skb != NULL)) {
 					wpahdr = (viawget_wpa_header *)pDevice->skb->data;
 					wpahdr->type = VIAWGET_DISASSOC_MSG;
@@ -1143,7 +1149,7 @@ BSSvSecondCallBack(
 				if (pDevice->bWPADEVUp)
 					pDevice->eEncryptionStatus = pDevice->eOldEncryptionStatus;
 
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Roaming ...\n");
+				pr_debug("Roaming ...\n");
 				BSSvClearBSSList((void *)pDevice, pDevice->bLinkPass);
 				pMgmt->eScanType = WMAC_SCAN_ACTIVE;
 				bScheduleCommand((void *)pDevice, WLAN_CMD_BSSID_SCAN, pMgmt->abyDesireSSID);
@@ -1159,7 +1165,7 @@ BSSvSecondCallBack(
 			if (pDevice->uAutoReConnectTime < 10) {
 				pDevice->uAutoReConnectTime++;
 			} else {
-				DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Adhoc re-scanning ...\n");
+				pr_info("Adhoc re-scanning ...\n");
 				pMgmt->eScanType = WMAC_SCAN_ACTIVE;
 				bScheduleCommand((void *)pDevice, WLAN_CMD_BSSID_SCAN, NULL);
 				bScheduleCommand((void *)pDevice, WLAN_CMD_SSID, NULL);
@@ -1170,7 +1176,8 @@ BSSvSecondCallBack(
 			if (pDevice->bUpdateBBVGA)
 				s_vCheckPreEDThreshold((void *)pDevice);
 			if (pMgmt->sNodeDBTable[0].uInActiveCount >= ADHOC_LOST_BEACON_COUNT) {
-				DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Lost other STA beacon [%d] sec, started !\n", pMgmt->sNodeDBTable[0].uInActiveCount);
+				pr_info("Lost other STA beacon [%d] sec, started !\n",
+					pMgmt->sNodeDBTable[0].uInActiveCount);
 				pMgmt->sNodeDBTable[0].uInActiveCount = 0;
 				pMgmt->eCurrState = WMAC_STATE_STARTED;
 				netif_stop_queue(pDevice->dev);
@@ -1229,7 +1236,8 @@ BSSvUpdateNodeTxCounter(
 
 	/* Only Unicast using support rates */
 	if (pTxBufHead->wFIFOCtl & FIFOCTL_NEEDACK) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wRate %04X, byTsr0 %02X, byTsr1 %02X\n", wRate, byTsr0, byTsr1);
+		pr_debug("wRate %04X, byTsr0 %02X, byTsr1 %02X\n",
+			 wRate, byTsr0, byTsr1);
 		if (pMgmt->eCurrMode == WMAC_MODE_ESS_STA) {
 			pMgmt->sNodeDBTable[0].uTxAttempts += 1;
 			if ((byTsr1 & TSR1_TERR) == 0) {
@@ -1370,7 +1378,7 @@ BSSvClearNodeDBTable(
 			/* check if sTxPSQueue has been initial */
 			if (pMgmt->sNodeDBTable[ii].sTxPSQueue.next != NULL) {
 				while ((skb = skb_dequeue(&pMgmt->sNodeDBTable[ii].sTxPSQueue)) != NULL) {
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "PS skb != NULL %d\n", ii);
+					pr_debug("PS skb != NULL %d\n", ii);
 					dev_kfree_skb(skb);
 				}
 			}
@@ -1412,7 +1420,10 @@ void s_vCheckSensitivity(
 			if (uNumofdBm > 0) {
 				LocalldBmAverage = LocalldBmAverage/uNumofdBm;
 				for (ii = 0; ii < BB_VGA_LEVEL; ii++) {
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "LocalldBmAverage:%ld, %ld %02x\n", LocalldBmAverage, pDevice->ldBmThreshold[ii], pDevice->abyBBVGA[ii]);
+					pr_debug("LocalldBmAverage:%ld, %ld %02x\n",
+						 LocalldBmAverage,
+						 pDevice->ldBmThreshold[ii],
+						 pDevice->abyBBVGA[ii]);
 					if (LocalldBmAverage < pDevice->ldBmThreshold[ii]) {
 						pDevice->byBBVGANew = pDevice->abyBBVGA[ii];
 						break;
diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 633585f..9807374 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -59,8 +59,6 @@
 
 /*---------------------  Static Definitions -------------------------*/
 
-static int msglevel = MSG_LEVEL_INFO;
-
 #define C_SIFS_A        16      // micro sec.
 #define C_SIFS_BG       10
 
@@ -747,14 +745,14 @@ bool CARDbSetBSSID(struct vnt_private *pDevice,
 		MACvRegBitsOff(pDevice->PortOffset, MAC_REG_RCR, RCR_BSSID);
 		pDevice->bBSSIDFilter = false;
 		pDevice->byRxMode &= ~RCR_BSSID;
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wcmd: rx_mode = %x\n", pDevice->byRxMode);
+		pr_debug("wcmd: rx_mode = %x\n", pDevice->byRxMode);
 	} else {
 		if (is_zero_ether_addr(pDevice->abyBSSID) == false) {
 			MACvRegBitsOn(pDevice->PortOffset, MAC_REG_RCR, RCR_BSSID);
 			pDevice->bBSSIDFilter = true;
 			pDevice->byRxMode |= RCR_BSSID;
 		}
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wmgr: rx_mode = %x\n", pDevice->byRxMode);
+		pr_debug("wmgr: rx_mode = %x\n", pDevice->byRxMode);
 	}
 	// Adopt BSS state in Adapter Device Object
 	pDevice->eOPMode = eOPMode;
@@ -838,7 +836,7 @@ CARDbPowerDown(
 	}
 
 	MACvRegBitsOn(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_GO2DOZE);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Go to Doze ZZZZZZZZZZZZZZZ\n");
+	pr_debug("Go to Doze ZZZZZZZZZZZZZZZ\n");
 	return true;
 }
 
@@ -975,17 +973,18 @@ CARDbAdd_PMKID_Candidate(
 	struct pmkid_candidate *pCandidateList;
 	unsigned int ii = 0;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bAdd_PMKID_Candidate START: (%d)\n", (int)pDevice->gsPMKIDCandidate.NumCandidates);
+	pr_debug("bAdd_PMKID_Candidate START: (%d)\n",
+		 (int)pDevice->gsPMKIDCandidate.NumCandidates);
 
 	if (pDevice->gsPMKIDCandidate.NumCandidates >= MAX_PMKIDLIST) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "vFlush_PMKID_Candidate: 3\n");
+		pr_debug("vFlush_PMKID_Candidate: 3\n");
 		memset(&pDevice->gsPMKIDCandidate, 0, sizeof(SPMKIDCandidateEvent));
 	}
 
 	for (ii = 0; ii < 6; ii++)
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%02X ", *(pbyBSSID + ii));
+		pr_debug("%02X ", *(pbyBSSID + ii));
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "\n");
+	pr_debug("\n");
 
 	// Update Old Candidate
 	for (ii = 0; ii < pDevice->gsPMKIDCandidate.NumCandidates; ii++) {
@@ -1009,7 +1008,8 @@ CARDbAdd_PMKID_Candidate(
 
 	memcpy(pCandidateList->BSSID, pbyBSSID, ETH_ALEN);
 	pDevice->gsPMKIDCandidate.NumCandidates++;
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "NumCandidates:%d\n", (int)pDevice->gsPMKIDCandidate.NumCandidates);
+	pr_debug("NumCandidates:%d\n",
+		 (int)pDevice->gsPMKIDCandidate.NumCandidates);
 	return true;
 }
 
@@ -1559,22 +1559,22 @@ static unsigned short CARDwGetOFDMControlRate(struct vnt_private *pDevice,
 {
 	unsigned int ui = (unsigned int) wRateIdx;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BASIC RATE: %X\n", pDevice->wBasicRate);
+	pr_debug("BASIC RATE: %X\n", pDevice->wBasicRate);
 
 	if (!CARDbIsOFDMinBasicRate((void *)pDevice)) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "CARDwGetOFDMControlRate:(NO OFDM) %d\n", wRateIdx);
+		pr_debug("CARDwGetOFDMControlRate:(NO OFDM) %d\n", wRateIdx);
 		if (wRateIdx > RATE_24M)
 			wRateIdx = RATE_24M;
 		return wRateIdx;
 	}
 	while (ui > RATE_11M) {
 		if (pDevice->wBasicRate & ((unsigned short)1 << ui)) {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "CARDwGetOFDMControlRate : %d\n", ui);
+			pr_debug("CARDwGetOFDMControlRate : %d\n", ui);
 			return (unsigned short)ui;
 		}
 		ui--;
 	}
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "CARDwGetOFDMControlRate: 6M\n");
+	pr_debug("CARDwGetOFDMControlRate: 6M\n");
 	return (unsigned short)RATE_24M;
 }
 
@@ -2017,5 +2017,5 @@ void CARDvUpdateNextTBTT(void __iomem *dwIoBase, u64 qwTSF, unsigned short wBeac
 	VNSvOutPortD(dwIoBase + MAC_REG_NEXTTBTT, (u32)qwTSF);
 	VNSvOutPortD(dwIoBase + MAC_REG_NEXTTBTT + 4, (u32)(qwTSF >> 32));
 	MACvRegBitsOn(dwIoBase, MAC_REG_TFTCTL, TFTCTL_TBTTSYNCEN);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Card:Update Next TBTT[%8llx]\n", qwTSF);
+	pr_debug("Card:Update Next TBTT[%8llx]\n", qwTSF);
 }
diff --git a/drivers/staging/vt6655/channel.c b/drivers/staging/vt6655/channel.c
index 753d523..4ce964b 100644
--- a/drivers/staging/vt6655/channel.c
+++ b/drivers/staging/vt6655/channel.c
@@ -30,8 +30,6 @@
 
 #define CARD_MAX_CHANNEL_TBL    56
 
-static int msglevel = MSG_LEVEL_INFO;
-
 /*---------------------  Static Variables  --------------------------*/
 
 static SChannelTblElement sChannelTbl[CARD_MAX_CHANNEL_TBL + 1] =
@@ -480,7 +478,10 @@ void init_channel_table(void *pDeviceHandler)
 		}
 	}
 
-	DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Zone=[%d][%c][%c]!!\n", pDevice->byZoneType, ChannelRuleTab[pDevice->byZoneType].chCountryCode[0], ChannelRuleTab[pDevice->byZoneType].chCountryCode[1]);
+	pr_info("Zone=[%d][%c][%c]!!\n",
+		pDevice->byZoneType,
+		ChannelRuleTab[pDevice->byZoneType].chCountryCode[0],
+		ChannelRuleTab[pDevice->byZoneType].chCountryCode[1]);
 
 	for (ii = 0; ii < CARD_MAX_CHANNEL_TBL; ii++) {
 		if (pDevice->abyRegPwr[ii + 1] == 0)
diff --git a/drivers/staging/vt6655/datarate.c b/drivers/staging/vt6655/datarate.c
index d489fe4..52907a4 100644
--- a/drivers/staging/vt6655/datarate.c
+++ b/drivers/staging/vt6655/datarate.c
@@ -49,7 +49,6 @@
 
 extern unsigned short TxRate_iwconfig; /* 2008-5-8 <add> by chester */
 /*---------------------  Static Variables  --------------------------*/
-static int msglevel = MSG_LEVEL_INFO;
 static const unsigned char acbyIERate[MAX_RATE] = {
 0x02, 0x04, 0x0B, 0x16, 0x0C, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C
 };
@@ -208,7 +207,7 @@ RATEvParseMaxRate(
 	*pwSuppRate = 0;
 	uRateLen = pItemRates->len;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ParseMaxRate Len: %d\n", uRateLen);
+	pr_debug("ParseMaxRate Len: %d\n", uRateLen);
 	if (pDevice->eCurrentPHYType != PHY_TYPE_11B) {
 		if (uRateLen > WLAN_RATES_MAXLEN)
 			uRateLen = WLAN_RATES_MAXLEN;
@@ -222,7 +221,8 @@ RATEvParseMaxRate(
 		if (WLAN_MGMT_IS_BASICRATE(byRate) && bUpdateBasicRate)  {
 			/* Add to basic rate set, update pDevice->byTopCCKBasicRate and pDevice->byTopOFDMBasicRate */
 			CARDbAddBasicRate((void *)pDevice, wGetRateIdx(byRate));
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ParseMaxRate AddBasicRate: %d\n", wGetRateIdx(byRate));
+			pr_debug("ParseMaxRate AddBasicRate: %d\n",
+				 wGetRateIdx(byRate));
 		}
 		byRate = (unsigned char)(pItemRates->abyRates[ii]&0x7F);
 		if (byHighSuppRate == 0)
@@ -244,7 +244,8 @@ RATEvParseMaxRate(
 			if (WLAN_MGMT_IS_BASICRATE(pItemExtRates->abyRates[ii])) {
 				/* Add to basic rate set, update pDevice->byTopCCKBasicRate and pDevice->byTopOFDMBasicRate */
 				CARDbAddBasicRate((void *)pDevice, wGetRateIdx(byRate));
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ParseMaxRate AddBasicRate: %d\n", wGetRateIdx(byRate));
+				pr_debug("ParseMaxRate AddBasicRate: %d\n",
+					 wGetRateIdx(byRate));
 			}
 			byRate = (unsigned char)(pItemExtRates->abyRates[ii]&0x7F);
 			if (byHighSuppRate == 0)
@@ -268,7 +269,7 @@ RATEvParseMaxRate(
 	if (wOldBasicRate != pDevice->wBasicRate)
 		CARDvSetRSPINF((void *)pDevice, pDevice->eCurrentPHYType);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Exit ParseMaxRate\n");
+	pr_debug("Exit ParseMaxRate\n");
 }
 
 /*+
diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index e1a322f..e4c5292 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -148,12 +148,6 @@
 
 /*---------------------  Export Types  ------------------------------*/
 
-#define DBG_PRT(l, p, args...)		\
-do {					\
-	if (l <= msglevel)		\
-		printk(p, ##args);	\
-} while (0)
-
 #define PRINT_K(p, args...)		\
 do {					\
 	if (PRIVATE_Message)		\
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index beab35d..a44233c 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -89,8 +89,6 @@
 #include <linux/slab.h>
 
 /*---------------------  Static Definitions -------------------------*/
-static int          msglevel                =   MSG_LEVEL_INFO;
-
 //
 // Define module options
 //
@@ -400,18 +398,19 @@ device_set_options(struct vnt_private *pDevice)
 	pDevice->wCTSDuration = 0;
 	pDevice->byPreambleType = 0;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " uChannel= %d\n", (int)pDevice->uChannel);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " byOpMode= %d\n", (int)pDevice->byOpMode);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " ePSMode= %d\n", (int)pDevice->ePSMode);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " wRTSThreshold= %d\n", (int)pDevice->wRTSThreshold);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " byShortRetryLimit= %d\n", (int)pDevice->byShortRetryLimit);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " byLongRetryLimit= %d\n", (int)pDevice->byLongRetryLimit);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " byPreambleType= %d\n", (int)pDevice->byPreambleType);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " byShortPreamble= %d\n", (int)pDevice->byShortPreamble);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " uConnectionRate= %d\n", (int)pDevice->uConnectionRate);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " byBBType= %d\n", (int)pDevice->byBBType);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " pDevice->b11hEnable= %d\n", (int)pDevice->b11hEnable);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " pDevice->bDiversityRegCtlON= %d\n", (int)pDevice->bDiversityRegCtlON);
+	pr_debug(" uChannel= %d\n", (int)pDevice->uChannel);
+	pr_debug(" byOpMode= %d\n", (int)pDevice->byOpMode);
+	pr_debug(" ePSMode= %d\n", (int)pDevice->ePSMode);
+	pr_debug(" wRTSThreshold= %d\n", (int)pDevice->wRTSThreshold);
+	pr_debug(" byShortRetryLimit= %d\n", (int)pDevice->byShortRetryLimit);
+	pr_debug(" byLongRetryLimit= %d\n", (int)pDevice->byLongRetryLimit);
+	pr_debug(" byPreambleType= %d\n", (int)pDevice->byPreambleType);
+	pr_debug(" byShortPreamble= %d\n", (int)pDevice->byShortPreamble);
+	pr_debug(" uConnectionRate= %d\n", (int)pDevice->uConnectionRate);
+	pr_debug(" byBBType= %d\n", (int)pDevice->byBBType);
+	pr_debug(" pDevice->b11hEnable= %d\n", (int)pDevice->b11hEnable);
+	pr_debug(" pDevice->bDiversityRegCtlON= %d\n",
+		 (int)pDevice->bDiversityRegCtlON);
 }
 
 static void s_vCompleteCurrentMeasure(struct vnt_private *pDevice,
@@ -565,10 +564,10 @@ static void device_init_registers(struct vnt_private *pDevice)
 		}
 	}
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-		"bDiversityEnable=[%d],NValue=[%d],MValue=[%d],TMax=[%d],TMax2=[%d]\n",
-		pDevice->bDiversityEnable, (int)pDevice->ulDiversityNValue,
-		(int)pDevice->ulDiversityMValue, pDevice->byTMax, pDevice->byTMax2);
+	pr_debug("bDiversityEnable=[%d],NValue=[%d],MValue=[%d],TMax=[%d],TMax2=[%d]\n",
+		 pDevice->bDiversityEnable, (int)pDevice->ulDiversityNValue,
+		 (int)pDevice->ulDiversityMValue, pDevice->byTMax,
+		 pDevice->byTMax2);
 
 	/* zonetype initial */
 	pDevice->byOriginalZonetype = pDevice->abyEEPROM[EEP_OFS_ZONETYPE];
@@ -581,7 +580,7 @@ static void device_init_registers(struct vnt_private *pDevice)
 			pDevice->abyEEPROM[EEP_OFS_ZONETYPE] = 0;
 			pDevice->abyEEPROM[EEP_OFS_MAXCHANNEL] = 0x0B;
 
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Init Zone Type :USA\n");
+			pr_debug("Init Zone Type :USA\n");
 		} else if ((zonetype == 1) &&
 			 (pDevice->abyEEPROM[EEP_OFS_ZONETYPE] != 0x01)) {
 			/* for Japan */
@@ -593,7 +592,7 @@ static void device_init_registers(struct vnt_private *pDevice)
 			pDevice->abyEEPROM[EEP_OFS_ZONETYPE] = 0x02;
 			pDevice->abyEEPROM[EEP_OFS_MAXCHANNEL] = 0x0D;
 
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Init Zone Type :Europe\n");
+			pr_debug("Init Zone Type :Europe\n");
 		} else {
 			if (zonetype != pDevice->abyEEPROM[EEP_OFS_ZONETYPE])
 				pr_debug("zonetype in file[%02x] mismatch with in EEPROM[%02x]\n",
@@ -616,12 +615,12 @@ static void device_init_registers(struct vnt_private *pDevice)
 			pDevice->byRevId = 0x80;
 
 	pDevice->byRFType &= RF_MASK;
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pDevice->byRFType = %x\n", pDevice->byRFType);
+	pr_debug("pDevice->byRFType = %x\n", pDevice->byRFType);
 
 	if (!pDevice->bZoneRegExist)
 		pDevice->byZoneType = pDevice->abyEEPROM[EEP_OFS_ZONETYPE];
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pDevice->byZoneType = %x\n", pDevice->byZoneType);
+	pr_debug("pDevice->byZoneType = %x\n", pDevice->byZoneType);
 
 	/* Init RF module */
 	RFbInit(pDevice);
@@ -744,8 +743,7 @@ static void device_init_registers(struct vnt_private *pDevice)
 
 	/* get Permanent network address */
 	SROMvReadEtherAddress(pDevice->PortOffset, pDevice->abyCurrentNetAddr);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Network address = %pM\n",
-		pDevice->abyCurrentNetAddr);
+	pr_debug("Network address = %pM\n", pDevice->abyCurrentNetAddr);
 
 	/* reset Tx pointer */
 	CARDvSafeResetRx(pDevice);
@@ -985,12 +983,10 @@ static void device_print_info(struct vnt_private *pDevice)
 {
 	struct net_device *dev = pDevice->dev;
 
-	DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "%s: %s\n", dev->name, get_chip_name(pDevice->chip_id));
-	DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "%s: MAC=%pM", dev->name, dev->dev_addr);
-
-	DBG_PRT(MSG_LEVEL_INFO, KERN_INFO " IO=0x%lx Mem=0x%lx ",
-		(unsigned long)pDevice->ioaddr, (unsigned long)pDevice->PortOffset);
-	DBG_PRT(MSG_LEVEL_INFO, KERN_INFO " IRQ=%d\n", pDevice->dev->irq);
+	pr_info("%s: %s\n", dev->name, get_chip_name(pDevice->chip_id));
+	pr_info("%s: MAC=%pM IO=0x%lx Mem=0x%lx IRQ=%d\n",
+		dev->name, dev->dev_addr, (unsigned long)pDevice->ioaddr,
+		(unsigned long)pDevice->PortOffset, pDevice->dev->irq);
 }
 
 static void vt6655_init_info(struct pci_dev *pcid,
@@ -1094,7 +1090,7 @@ static void device_free_info(struct vnt_private *pDevice)
 		else
 			ptr->prev->next = ptr->next;
 	} else {
-		DBG_PRT(MSG_LEVEL_ERR, KERN_ERR "info struct not found\n");
+		pr_err("info struct not found\n");
 		return;
 	}
 #ifdef HOSTAP
@@ -1125,7 +1121,8 @@ static bool device_init_rings(struct vnt_private *pDevice)
 					 pDevice->sOpts.nTxDescs[1] * sizeof(STxDesc),
 					 &pDevice->pool_dma);
 	if (vir_pool == NULL) {
-		DBG_PRT(MSG_LEVEL_ERR, KERN_ERR "%s : allocate desc dma memory failed\n", pDevice->dev->name);
+		pr_err("%s : allocate desc dma memory failed\n",
+		       pDevice->dev->name);
 		return false;
 	}
 
@@ -1144,7 +1141,8 @@ static bool device_init_rings(struct vnt_private *pDevice)
 						  CB_MAX_BUF_SIZE,
 						  &pDevice->tx_bufs_dma0);
 	if (pDevice->tx0_bufs == NULL) {
-		DBG_PRT(MSG_LEVEL_ERR, KERN_ERR "%s: allocate buf dma memory failed\n", pDevice->dev->name);
+		pr_err("%s: allocate buf dma memory failed\n",
+		       pDevice->dev->name);
 		pci_free_consistent(pDevice->pcid,
 				    pDevice->sOpts.nRxDescs0 * sizeof(SRxDesc) +
 				    pDevice->sOpts.nRxDescs1 * sizeof(SRxDesc) +
@@ -1222,8 +1220,8 @@ static void device_init_rd0_ring(struct vnt_private *pDevice)
 		pDesc->pRDInfo = alloc_rd_info();
 		ASSERT(pDesc->pRDInfo);
 		if (!device_alloc_rx_buf(pDevice, pDesc)) {
-			DBG_PRT(MSG_LEVEL_ERR, KERN_ERR "%s: can not alloc rx bufs\n",
-				pDevice->dev->name);
+			pr_err("%s: can not alloc rx bufs\n",
+			       pDevice->dev->name);
 		}
 		pDesc->next = &(pDevice->aRD0Ring[(i+1) % pDevice->sOpts.nRxDescs0]);
 		pDesc->pRDInfo->curr_desc = cpu_to_le32(curr);
@@ -1247,8 +1245,8 @@ static void device_init_rd1_ring(struct vnt_private *pDevice)
 		pDesc->pRDInfo = alloc_rd_info();
 		ASSERT(pDesc->pRDInfo);
 		if (!device_alloc_rx_buf(pDevice, pDesc)) {
-			DBG_PRT(MSG_LEVEL_ERR, KERN_ERR "%s: can not alloc rx bufs\n",
-				pDevice->dev->name);
+			pr_err("%s: can not alloc rx bufs\n",
+			       pDevice->dev->name);
 		}
 		pDesc->next = &(pDevice->aRD1Ring[(i+1) % pDevice->sOpts.nRxDescs1]);
 		pDesc->pRDInfo->curr_desc = cpu_to_le32(curr);
@@ -1269,8 +1267,8 @@ static void device_init_defrag_cb(struct vnt_private *pDevice)
 	for (i = 0; i < CB_MAX_RX_FRAG; i++) {
 		pDeF = &(pDevice->sRxDFCB[i]);
 		if (!device_alloc_frag_buf(pDevice, pDeF)) {
-			DBG_PRT(MSG_LEVEL_ERR, KERN_ERR "%s: can not alloc frag bufs\n",
-				pDevice->dev->name);
+			pr_err("%s: can not alloc frag bufs\n",
+			       pDevice->dev->name);
 		}
 	}
 	pDevice->cbDFCB = CB_MAX_RX_FRAG;
@@ -1428,8 +1426,8 @@ static int device_rx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 			break;
 		if (device_receive_frame(pDevice, pRD)) {
 			if (!device_alloc_rx_buf(pDevice, pRD)) {
-				DBG_PRT(MSG_LEVEL_ERR, KERN_ERR
-					"%s: can not allocate rx buf\n", pDevice->dev->name);
+				pr_err("%s: can not allocate rx buf\n",
+				       pDevice->dev->name);
 				break;
 			}
 		}
@@ -1520,8 +1518,9 @@ static int device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 
 				if (!(byTsr1 & TSR1_TERR)) {
 					if (byTsr0 != 0) {
-						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " Tx[%d] OK but has error. tsr1[%02X] tsr0[%02X].\n",
-							(int)uIdx, byTsr1, byTsr0);
+						pr_debug(" Tx[%d] OK but has error. tsr1[%02X] tsr0[%02X]\n",
+							 (int)uIdx, byTsr1,
+							 byTsr0);
 					}
 					if ((pTxBufHead->wFragCtl & FRAGCTL_ENDFRAG) != FRAGCTL_NONFRAG)
 						pDevice->s802_11Counter.TransmittedFragmentCount++;
@@ -1529,8 +1528,8 @@ static int device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 					pStats->tx_packets++;
 					pStats->tx_bytes += pTD->pTDInfo->skb->len;
 				} else {
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " Tx[%d] dropped & tsr1[%02X] tsr0[%02X].\n",
-						(int)uIdx, byTsr1, byTsr0);
+					pr_debug(" Tx[%d] dropped & tsr1[%02X] tsr0[%02X]\n",
+						 (int)uIdx, byTsr1, byTsr0);
 					pStats->tx_errors++;
 					pStats->tx_dropped++;
 				}
@@ -1538,7 +1537,7 @@ static int device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 
 			if ((pTD->pTDInfo->byFlags & TD_FLAGS_PRIV_SKB) != 0) {
 				if (pDevice->bEnableHostapd) {
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "tx call back netif..\n");
+					pr_debug("tx call back netif..\n");
 					skb = pTD->pTDInfo->skb;
 					skb->dev = pDevice->apdev;
 					skb_reset_mac_header(skb);
@@ -1550,8 +1549,8 @@ static int device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 
 			if (byTsr1 & TSR1_TERR) {
 				if ((pTD->pTDInfo->byFlags & TD_FLAGS_PRIV_SKB) != 0) {
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " Tx[%d] fail has error. tsr1[%02X] tsr0[%02X].\n",
-						(int)uIdx, byTsr1, byTsr0);
+					pr_debug(" Tx[%d] fail has error. tsr1[%02X] tsr0[%02X]\n",
+						 (int)uIdx, byTsr1, byTsr0);
 				}
 
 
@@ -1569,8 +1568,9 @@ static int device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 							wAID = pMgmt->sNodeDBTable[uNodeIndex].wAID;
 							pMgmt->abyPSTxMap[wAID >> 3] |=  byMask[wAID & 7];
 							pTD->pTDInfo->byFlags &= ~(TD_FLAGS_NETIF_SKB);
-							DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "tx_srv:tx fail re-queue sta index= %d, QueCnt= %d\n"
-								, (int)uNodeIndex, pMgmt->sNodeDBTable[uNodeIndex].wEnQueueCnt);
+							pr_debug("tx_srv:tx fail re-queue sta index= %d, QueCnt= %d\n",
+								 (int)uNodeIndex,
+								 pMgmt->sNodeDBTable[uNodeIndex].wEnQueueCnt);
 							pStats->tx_errors--;
 							pStats->tx_dropped--;
 						}
@@ -1587,7 +1587,8 @@ static int device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 
 		if (AVAIL_TD(pDevice, uIdx) < RESERV_AC0DMA) {
 			bFull = true;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " AC0DMA is Full = %d\n", pDevice->iTDUsed[uIdx]);
+			pr_debug(" AC0DMA is Full = %d\n",
+				 pDevice->iTDUsed[uIdx]);
 		}
 		if (netif_queue_stopped(pDevice->dev) && !bFull)
 			netif_wake_queue(pDevice->dev);
@@ -1602,9 +1603,7 @@ static int device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 static void device_error(struct vnt_private *pDevice, unsigned short status)
 {
 	if (status & ISR_FETALERR) {
-		DBG_PRT(MSG_LEVEL_ERR, KERN_ERR
-			"%s: Hardware fatal error.\n",
-			pDevice->dev->name);
+		pr_err("%s: Hardware fatal error\n", pDevice->dev->name);
 		netif_stop_queue(pDevice->dev);
 		del_timer(&pDevice->sTimerCommand);
 		del_timer(&(pDevice->pMgmt->sTimerSecondCallback));
@@ -1658,7 +1657,7 @@ static int  device_open(struct net_device *dev)
 	wpa_Result.authenticated = false;
 	pDevice->fWPA_Authened = false;
 #endif
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "call device init rd0 ring\n");
+	pr_debug("call device init rd0 ring\n");
 	device_init_rd0_ring(pDevice);
 	device_init_rd1_ring(pDevice);
 	device_init_defrag_cb(pDevice);
@@ -1671,7 +1670,7 @@ static int  device_open(struct net_device *dev)
 	vMgrObjectInit(pDevice);
 	vMgrTimerInit(pDevice);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "call device_init_registers\n");
+	pr_debug("call device_init_registers\n");
 	device_init_registers(pDevice);
 
 	MACvReadEtherAddress(pDevice->PortOffset, pDevice->abyCurrentNetAddr);
@@ -1702,7 +1701,7 @@ static int  device_open(struct net_device *dev)
 		pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
 	}
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "call MACvIntEnable\n");
+	pr_debug("call MACvIntEnable\n");
 	MACvIntEnable(pDevice->PortOffset, IMR_MASK_VALUE);
 
 	if (pDevice->pMgmt->eConfigMode == WMAC_CONFIG_AP) {
@@ -1713,7 +1712,7 @@ static int  device_open(struct net_device *dev)
 	}
 	pDevice->flags |= DEVICE_FLAGS_OPENED;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "device_open success..\n");
+	pr_debug("device_open success..\n");
 	return 0;
 }
 
@@ -1759,7 +1758,7 @@ static int  device_close(struct net_device *dev)
 	//2008-0714-01<Add>by chester
 	device_release_WPADEV(pDevice);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "device_close..\n");
+	pr_debug("device_close..\n");
 	return 0;
 }
 
@@ -1769,11 +1768,11 @@ static int device_dma0_tx_80211(struct sk_buff *skb, struct net_device *dev)
 	unsigned char *pbMPDU;
 	unsigned int cbMPDULen = 0;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "device_dma0_tx_80211\n");
+	pr_debug("device_dma0_tx_80211\n");
 	spin_lock_irq(&pDevice->lock);
 
 	if (AVAIL_TD(pDevice, TYPE_TXDMA0) <= 0) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "device_dma0_tx_80211, td0 <=0\n");
+		pr_debug("device_dma0_tx_80211, td0 <=0\n");
 		dev_kfree_skb_irq(skb);
 		spin_unlock_irq(&pDevice->lock);
 		return 0;
@@ -1816,14 +1815,14 @@ bool device_dma0_xmit(struct vnt_private *pDevice,
 
 	if (AVAIL_TD(pDevice, TYPE_TXDMA0) <= 0) {
 		dev_kfree_skb_irq(skb);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "device_dma0_xmit, td0 <=0\n");
+		pr_debug("device_dma0_xmit, td0 <=0\n");
 		return false;
 	}
 
 	if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
 		if (pDevice->uAssocCount == 0) {
 			dev_kfree_skb_irq(skb);
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "device_dma0_xmit, assocCount = 0\n");
+			pr_debug("device_dma0_xmit, assocCount = 0\n");
 			return false;
 		}
 	}
@@ -1869,7 +1868,7 @@ bool device_dma0_xmit(struct vnt_private *pDevice,
 	else
 		pDevice->byPreambleType = PREAMBLE_LONG;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dma0: pDevice->wCurrentRate = %d\n", pDevice->wCurrentRate);
+	pr_debug("dma0: pDevice->wCurrentRate = %d\n", pDevice->wCurrentRate);
 
 	if (pDevice->wCurrentRate <= RATE_11M) {
 		byPktType = PK_TYPE_11B;
@@ -1994,8 +1993,9 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
 					// set tx map
 					wAID = pMgmt->sNodeDBTable[uNodeIndex].wAID;
 					pMgmt->abyPSTxMap[wAID >> 3] |=  byMask[wAID & 7];
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Set:pMgmt->abyPSTxMap[%d]= %d\n",
-						(wAID >> 3), pMgmt->abyPSTxMap[wAID >> 3]);
+					pr_debug("Set:pMgmt->abyPSTxMap[%d]= %d\n",
+						 (wAID >> 3),
+						 pMgmt->abyPSTxMap[wAID >> 3]);
 					spin_unlock_irq(&pDevice->lock);
 					return 0;
 				}
@@ -2011,7 +2011,7 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
 		}
 
 		if (!bNodeExist) {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG "Unknown STA not found in node DB\n");
+			pr_debug("Unknown STA not found in node DB\n");
 			dev_kfree_skb_irq(skb);
 			spin_unlock_irq(&pDevice->lock);
 			return 0;
@@ -2040,19 +2040,19 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
 					// get group key
 					if (KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, GROUP_KEY, &pTransmitKey) == true) {
 						bTKIP_UseGTK = true;
-						DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG "Get GTK.\n");
+						pr_debug("Get GTK\n");
 						break;
 					}
 				} else {
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG "Get PTK.\n");
+					pr_debug("Get PTK\n");
 					break;
 				}
 			} else if (pDevice->pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) {
 				pbyBSSID = pDevice->sTxEthHeader.abyDstAddr;  //TO_DS = 0 and FROM_DS = 0 --> 802.11 MAC Address1
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG "IBSS Serach Key:\n");
+				pr_debug("IBSS Serach Key:\n");
 				for (ii = 0; ii < 6; ii++)
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG "%x\n", *(pbyBSSID+ii));
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG "\n");
+					pr_debug("%x\n", *(pbyBSSID+ii));
+				pr_debug("\n");
 
 				// get pairwise key
 				if (KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, PAIRWISE_KEY, &pTransmitKey) == true)
@@ -2063,18 +2063,20 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
 			if (KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, GROUP_KEY, &pTransmitKey) == false) {
 				pTransmitKey = NULL;
 				if (pDevice->pMgmt->eCurrMode == WMAC_MODE_IBSS_STA)
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG "IBSS and KEY is NULL. [%d]\n", pDevice->pMgmt->eCurrMode);
+					pr_debug("IBSS and KEY is NULL. [%d]\n",
+						 pDevice->pMgmt->eCurrMode);
 				else
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG "NOT IBSS and KEY is NULL. [%d]\n", pDevice->pMgmt->eCurrMode);
+					pr_debug("NOT IBSS and KEY is NULL. [%d]\n",
+						 pDevice->pMgmt->eCurrMode);
 			} else {
 				bTKIP_UseGTK = true;
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG "Get GTK.\n");
+				pr_debug("Get GTK\n");
 			}
 		} while (false);
 	}
 
 	if (pDevice->bEnableHostWEP) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG "acdma0: STA index %d\n", uNodeIndex);
+		pr_debug("acdma0: STA index %d\n", uNodeIndex);
 		if (pDevice->bEncryptionEnable) {
 			pTransmitKey = &STempKey;
 			pTransmitKey->byCipherSuite = pMgmt->sNodeDBTable[uNodeIndex].byCipherSuite;
@@ -2092,7 +2094,8 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
 	uMACfragNum = cbGetFragCount(pDevice, pTransmitKey, cbFrameBodySize, &pDevice->sTxEthHeader);
 
 	if (uMACfragNum > AVAIL_TD(pDevice, TYPE_AC0DMA)) {
-		DBG_PRT(MSG_LEVEL_ERR, KERN_DEBUG "uMACfragNum > AVAIL_TD(TYPE_AC0DMA) = %d\n", uMACfragNum);
+		pr_debug("uMACfragNum > AVAIL_TD(TYPE_AC0DMA) = %d\n",
+			 uMACfragNum);
 		dev_kfree_skb_irq(skb);
 		spin_unlock_irq(&pDevice->lock);
 		return 0;
@@ -2170,18 +2173,21 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
 	}
 
 	if (bNeedEncryption) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ntohs Pkt Type=%04x\n", ntohs(pDevice->sTxEthHeader.wType));
+		pr_debug("ntohs Pkt Type=%04x\n",
+			 ntohs(pDevice->sTxEthHeader.wType));
 		if ((pDevice->sTxEthHeader.wType) == TYPE_PKT_802_1x) {
 			bNeedEncryption = false;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Pkt Type=%04x\n", (pDevice->sTxEthHeader.wType));
+			pr_debug("Pkt Type=%04x\n",
+				 (pDevice->sTxEthHeader.wType));
 			if ((pDevice->pMgmt->eCurrMode == WMAC_MODE_ESS_STA) && (pDevice->pMgmt->eCurrState == WMAC_STATE_ASSOC)) {
 				if (pTransmitKey == NULL) {
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Don't Find TX KEY\n");
+					pr_debug("Don't Find TX KEY\n");
 				} else {
 					if (bTKIP_UseGTK) {
-						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "error: KEY is GTK!!~~\n");
+						pr_debug("error: KEY is GTK!!~~\n");
 					} else {
-						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Find PTK [%lX]\n", pTransmitKey->dwKeyIndex);
+						pr_debug("Find PTK [%lX]\n",
+							 pTransmitKey->dwKeyIndex);
 						bNeedEncryption = true;
 					}
 				}
@@ -2195,13 +2201,14 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
 			if (pDevice->bEnableHostWEP) {
 				if ((uNodeIndex != 0) &&
 				    (pMgmt->sNodeDBTable[uNodeIndex].dwKeyIndex & PAIRWISE_KEY)) {
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Find PTK [%lX]\n", pTransmitKey->dwKeyIndex);
+					pr_debug("Find PTK [%lX]\n",
+						 pTransmitKey->dwKeyIndex);
 					bNeedEncryption = true;
 				}
 			}
 		} else {
 			if (pTransmitKey == NULL) {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "return no tx key\n");
+				pr_debug("return no tx key\n");
 				dev_kfree_skb_irq(skb);
 				spin_unlock_irq(&pDevice->lock);
 				return 0;
@@ -2305,7 +2312,7 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 		return IRQ_RETVAL(handled);
 
 	if (pDevice->dwIsr == 0xffffffff) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dwIsr = 0xffff\n");
+		pr_debug("dwIsr = 0xffff\n");
 		return IRQ_RETVAL(handled);
 	}
 
@@ -2332,7 +2339,7 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 		MACvWriteISR(pDevice->PortOffset, pDevice->dwIsr);
 
 		if (pDevice->dwIsr & ISR_FETALERR) {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " ISR_FETALERR\n");
+			pr_debug(" ISR_FETALERR\n");
 			VNSvOutPortB(pDevice->PortOffset + MAC_REG_SOFTPWRCTL, 0);
 			VNSvOutPortW(pDevice->PortOffset + MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPECTI);
 			device_error(pDevice, pDevice->dwIsr);
@@ -2442,12 +2449,18 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 						if (pDevice->uBBVGADiffCount == 1) {
 							// first VGA diff gain
 							BBvSetVGAGainOffset(pDevice, pDevice->byBBVGANew);
-							DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "First RSSI[%d] NewGain[%d] OldGain[%d] Count[%d]\n",
-								(int)ldBm, pDevice->byBBVGANew, pDevice->byBBVGACurrent, (int)pDevice->uBBVGADiffCount);
+							pr_debug("First RSSI[%d] NewGain[%d] OldGain[%d] Count[%d]\n",
+								 (int)ldBm,
+								 pDevice->byBBVGANew,
+								 pDevice->byBBVGACurrent,
+								 (int)pDevice->uBBVGADiffCount);
 						}
 						if (pDevice->uBBVGADiffCount >= BB_VGA_CHANGE_THRESHOLD) {
-							DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "RSSI[%d] NewGain[%d] OldGain[%d] Count[%d]\n",
-								(int)ldBm, pDevice->byBBVGANew, pDevice->byBBVGACurrent, (int)pDevice->uBBVGADiffCount);
+							pr_debug("RSSI[%d] NewGain[%d] OldGain[%d] Count[%d]\n",
+								 (int)ldBm,
+								 pDevice->byBBVGANew,
+								 pDevice->byBBVGACurrent,
+								 (int)pDevice->uBBVGADiffCount);
 							BBvSetVGAGainOffset(pDevice, pDevice->byBBVGANew);
 						}
 					} else {
@@ -2638,7 +2651,7 @@ static void device_set_multi(struct net_device *dev) {
 	VNSvInPortB(pDevice->PortOffset + MAC_REG_RCR, &(pDevice->byRxMode));
 
 	if (dev->flags & IFF_PROMISC) {         /* Set promiscuous. */
-		DBG_PRT(MSG_LEVEL_ERR, KERN_NOTICE "%s: Promiscuous mode enabled.\n", dev->name);
+		pr_notice("%s: Promiscuous mode enabled\n", dev->name);
 		/* Unconditionally log net taps. */
 		pDevice->byRxMode |= (RCR_MULTICAST|RCR_BROADCAST|RCR_UNICAST);
 	} else if ((netdev_mc_count(dev) > pDevice->multicast_limit)
@@ -2670,7 +2683,7 @@ static void device_set_multi(struct net_device *dev) {
 	}
 
 	VNSvOutPortB(pDevice->PortOffset + MAC_REG_RCR, pDevice->byRxMode);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pDevice->byRxMode = %x\n", pDevice->byRxMode);
+	pr_debug("pDevice->byRxMode = %x\n", pDevice->byRxMode);
 }
 
 static struct net_device_stats *device_get_stats(struct net_device *dev)
@@ -2760,13 +2773,13 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 
 		// Set desired station name
 	case SIOCSIWNICKN:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWNICKN\n");
+		pr_debug(" SIOCSIWNICKN\n");
 		rc = -EOPNOTSUPP;
 		break;
 
 		// Get current station name
 	case SIOCGIWNICKN:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWNICKN\n");
+		pr_debug(" SIOCGIWNICKN\n");
 		rc = -EOPNOTSUPP;
 		break;
 
@@ -2863,12 +2876,12 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 
 		// Get the current Tx-Power
 	case SIOCGIWTXPOW:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWTXPOW\n");
+		pr_debug(" SIOCGIWTXPOW\n");
 		rc = -EOPNOTSUPP;
 		break;
 
 	case SIOCSIWTXPOW:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWTXPOW\n");
+		pr_debug(" SIOCSIWTXPOW\n");
 		rc = -EOPNOTSUPP;
 		break;
 
@@ -2911,7 +2924,7 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 		break;
 
 	case SIOCSIWSENS:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWSENS\n");
+		pr_debug(" SIOCSIWSENS\n");
 		rc = -EOPNOTSUPP;
 		break;
 
@@ -2935,50 +2948,50 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	// Set the spy list
 	case SIOCSIWSPY:
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWSPY\n");
+		pr_debug(" SIOCSIWSPY\n");
 		rc = -EOPNOTSUPP;
 		break;
 
 		// Get the spy list
 	case SIOCGIWSPY:
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWSPY\n");
+		pr_debug(" SIOCGIWSPY\n");
 		rc = -EOPNOTSUPP;
 		break;
 
 #endif // WIRELESS_SPY
 
 	case SIOCGIWPRIV:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWPRIV\n");
+		pr_debug(" SIOCGIWPRIV\n");
 		rc = -EOPNOTSUPP;
 		break;
 
 //2008-0409-07, <Add> by Einsn Liu
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 	case SIOCSIWAUTH:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWAUTH\n");
+		pr_debug(" SIOCSIWAUTH\n");
 		rc = iwctl_siwauth(dev, NULL, &(wrq->u.param), NULL);
 		break;
 
 	case SIOCGIWAUTH:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWAUTH\n");
+		pr_debug(" SIOCGIWAUTH\n");
 		rc = iwctl_giwauth(dev, NULL, &(wrq->u.param), NULL);
 		break;
 
 	case SIOCSIWGENIE:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWGENIE\n");
+		pr_debug(" SIOCSIWGENIE\n");
 		rc = iwctl_siwgenie(dev, NULL, &(wrq->u.data), wrq->u.data.pointer);
 		break;
 
 	case SIOCGIWGENIE:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWGENIE\n");
+		pr_debug(" SIOCGIWGENIE\n");
 		rc = iwctl_giwgenie(dev, NULL, &(wrq->u.data), wrq->u.data.pointer);
 		break;
 
 	case SIOCSIWENCODEEXT: {
 		char extra[sizeof(struct iw_encode_ext)+MAX_KEY_LEN+1];
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWENCODEEXT\n");
+		pr_debug(" SIOCSIWENCODEEXT\n");
 		if (wrq->u.encoding.pointer) {
 			memset(extra, 0, sizeof(struct iw_encode_ext)+MAX_KEY_LEN + 1);
 			if (wrq->u.encoding.length > (sizeof(struct iw_encode_ext) + MAX_KEY_LEN)) {
@@ -2998,12 +3011,12 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	break;
 
 	case SIOCGIWENCODEEXT:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWENCODEEXT\n");
+		pr_debug(" SIOCGIWENCODEEXT\n");
 		rc = iwctl_giwencodeext(dev, NULL, &(wrq->u.encoding), NULL);
 		break;
 
 	case SIOCSIWMLME:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWMLME\n");
+		pr_debug(" SIOCSIWMLME\n");
 		rc = iwctl_siwmlme(dev, NULL, &(wrq->u.data), wrq->u.data.pointer);
 		break;
 
@@ -3061,7 +3074,7 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 
 	default:
 		rc = -EOPNOTSUPP;
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Ioctl command not support..%x\n", cmd);
+		pr_debug("Ioctl command not support..%x\n", cmd);
 
 	}
 
@@ -3072,7 +3085,7 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 			bScheduleCommand((void *)pDevice, WLAN_CMD_RUN_AP, NULL);
 			spin_unlock_irq(&pDevice->lock);
 		} else {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Commit the settings\n");
+			pr_debug("Commit the settings\n");
 			spin_lock_irq(&pDevice->lock);
 			pDevice->bLinkPass = false;
 			memset(pMgmt->abyCurrBSSID, 0, 6);
diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index d26ca96..7589cb4 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -61,8 +61,6 @@
 /*---------------------  Static Classes  ----------------------------*/
 
 /*---------------------  Static Variables  --------------------------*/
-static int msglevel = MSG_LEVEL_INFO;
-
 static const unsigned char acbyRxRate[MAX_RATE] =
 {2, 4, 11, 22, 12, 18, 24, 36, 48, 72, 96, 108};
 
@@ -325,7 +323,7 @@ device_receive_frame(
 	// Min (ACK): 10HD +4CRC + 2Padding + 4Len + 8TSF + 4RSR
 	if ((FrameSize > 2364) || (FrameSize <= 32)) {
 		// Frame Size error drop this packet.
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "---------- WRONG Length 1\n");
+		pr_debug("---------- WRONG Length 1\n");
 		return false;
 	}
 
@@ -343,7 +341,7 @@ device_receive_frame(
 
 	if ((FrameSize > 2346)|(FrameSize < 14)) { // Max: 2312Payload + 30HD +4CRC
 		// Min: 14 bytes ACK
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "---------- WRONG Length 2\n");
+		pr_debug("---------- WRONG Length 2\n");
 		return false;
 	}
 //PLICE_DEBUG->
@@ -421,7 +419,7 @@ device_receive_frame(
 	if (IS_FC_WEP(pbyFrame)) {
 		bool bRxDecryOK = false;
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx WEP pkt\n");
+		pr_debug("rx WEP pkt\n");
 		bIsWEP = true;
 		if ((pDevice->bEnableHostWEP) && (iSANodeIndex >= 0)) {
 			pKey = &STempKey;
@@ -459,7 +457,7 @@ device_receive_frame(
 
 		if (bRxDecryOK) {
 			if ((*pbyNewRsr & NEWRSR_DECRYPTOK) == 0) {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ICV Fail\n");
+				pr_debug("ICV Fail\n");
 				if ((pDevice->pMgmt->eAuthenMode == WMAC_AUTH_WPA) ||
 				    (pDevice->pMgmt->eAuthenMode == WMAC_AUTH_WPAPSK) ||
 				    (pDevice->pMgmt->eAuthenMode == WMAC_AUTH_WPANONE) ||
@@ -473,7 +471,7 @@ device_receive_frame(
 				return false;
 			}
 		} else {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "WEP Func Fail\n");
+			pr_debug("WEP Func Fail\n");
 			return false;
 		}
 		if ((pKey != NULL) && (pKey->byCipherSuite == KEY_CTL_CCMP))
@@ -554,8 +552,8 @@ device_receive_frame(
 			if (!(*pbyRsr & RSR_BSSIDOK)) {
 				if (bDeFragRx) {
 					if (!device_alloc_frag_buf(pDevice, &pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx])) {
-						DBG_PRT(MSG_LEVEL_ERR, KERN_ERR "%s: can not alloc more frag bufs\n",
-							pDevice->dev->name);
+						pr_err("%s: can not alloc more frag bufs\n",
+						       pDevice->dev->name);
 					}
 				}
 				return false;
@@ -565,8 +563,8 @@ device_receive_frame(
 			if (!pDevice->bLinkPass || !(*pbyRsr & RSR_BSSIDOK)) {
 				if (bDeFragRx) {
 					if (!device_alloc_frag_buf(pDevice, &pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx])) {
-						DBG_PRT(MSG_LEVEL_ERR, KERN_ERR "%s: can not alloc more frag bufs\n",
-							pDevice->dev->name);
+						pr_err("%s: can not alloc more frag bufs\n",
+						       pDevice->dev->name);
 					}
 				}
 				return false;
@@ -642,7 +640,7 @@ device_receive_frame(
 		wEtherType = (skb->data[cbIVOffset + 4 + 24 + 6] << 8) |
 			skb->data[cbIVOffset + 4 + 24 + 6 + 1];
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wEtherType = %04x\n", wEtherType);
+		pr_debug("wEtherType = %04x\n", wEtherType);
 		if (wEtherType == ETH_P_PAE) {
 			skb->dev = pDevice->apdev;
 
@@ -717,13 +715,13 @@ device_receive_frame(
 			if ((le32_to_cpu(*pdwMIC_L) != dwLocalMIC_L) ||
 			    (le32_to_cpu(*pdwMIC_R) != dwLocalMIC_R) ||
 			    pDevice->bRxMICFail) {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "MIC comparison is fail!\n");
+				pr_debug("MIC comparison is fail!\n");
 				pDevice->bRxMICFail = false;
 				pDevice->s802_11Counter.TKIPLocalMICFailures++;
 				if (bDeFragRx) {
 					if (!device_alloc_frag_buf(pDevice, &pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx])) {
-						DBG_PRT(MSG_LEVEL_ERR, KERN_ERR "%s: can not alloc more frag bufs\n",
-							pDevice->dev->name);
+						pr_err("%s: can not alloc more frag bufs\n",
+						       pDevice->dev->name);
 					}
 				}
 				//2008-0409-07, <Add> by Einsn Liu
@@ -804,7 +802,7 @@ device_receive_frame(
 				if ((wRxTSC15_0 < wLocalTSC15_0) &&
 				    (dwRxTSC47_16 <= dwLocalTSC47_16) &&
 				    !((dwRxTSC47_16 == 0) && (dwLocalTSC47_16 == 0xFFFFFFFF))) {
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "TSC is illegal~~!\n ");
+					pr_debug("TSC is illegal~~!\n ");
 					if (pKey->byCipherSuite == KEY_CTL_TKIP)
 						pDevice->s802_11Counter.TKIPReplays++;
 					else
@@ -812,8 +810,8 @@ device_receive_frame(
 
 					if (bDeFragRx) {
 						if (!device_alloc_frag_buf(pDevice, &pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx])) {
-							DBG_PRT(MSG_LEVEL_ERR, KERN_ERR "%s: can not alloc more frag bufs\n",
-								pDevice->dev->name);
+							pr_err("%s: can not alloc more frag bufs\n",
+							       pDevice->dev->name);
 						}
 					}
 					return false;
@@ -840,8 +838,8 @@ device_receive_frame(
 )) {
 			if (bDeFragRx) {
 				if (!device_alloc_frag_buf(pDevice, &pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx])) {
-					DBG_PRT(MSG_LEVEL_ERR, KERN_ERR "%s: can not alloc more frag bufs\n",
-						pDevice->dev->name);
+					pr_err("%s: can not alloc more frag bufs\n",
+					       pDevice->dev->name);
 				}
 			}
 			return false;
@@ -862,8 +860,8 @@ device_receive_frame(
 
 	if (bDeFragRx) {
 		if (!device_alloc_frag_buf(pDevice, &pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx])) {
-			DBG_PRT(MSG_LEVEL_ERR, KERN_ERR "%s: can not alloc more frag bufs\n",
-				pDevice->dev->name);
+			pr_err("%s: can not alloc more frag bufs\n",
+			       pDevice->dev->name);
 		}
 		return false;
 	}
@@ -897,7 +895,7 @@ static bool s_bAPModeRxCtl(
 							     (WLAN_MGMT_REASON_CLASS2_NONAUTH),
 							     &Status
 );
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dpc: send vMgrDeAuthenBeginSta 1\n");
+					pr_debug("dpc: send vMgrDeAuthenBeginSta 1\n");
 					return true;
 				}
 				if (pMgmt->sNodeDBTable[iSANodeIndex].eNodeState < NODE_ASSOC) {
@@ -909,7 +907,7 @@ static bool s_bAPModeRxCtl(
 							     (WLAN_MGMT_REASON_CLASS3_NONASSOC),
 							     &Status
 );
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dpc: send vMgrDisassocBeginSta 2\n");
+					pr_debug("dpc: send vMgrDisassocBeginSta 2\n");
 					return true;
 				}
 
@@ -918,7 +916,7 @@ static bool s_bAPModeRxCtl(
 					if (IS_CTL_PSPOLL(pbyFrame)) {
 						pMgmt->sNodeDBTable[iSANodeIndex].bRxPSPoll = true;
 						bScheduleCommand((void *)pDevice, WLAN_CMD_RX_PSPOLL, NULL);
-						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dpc: WLAN_CMD_RX_PSPOLL 1\n");
+						pr_debug("dpc: WLAN_CMD_RX_PSPOLL 1\n");
 					} else {
 						// check Data PS state
 						// if PW bit off, send out all PS bufferring packets.
@@ -926,7 +924,7 @@ static bool s_bAPModeRxCtl(
 							pMgmt->sNodeDBTable[iSANodeIndex].bPSEnable = false;
 							pMgmt->sNodeDBTable[iSANodeIndex].bRxPSPoll = true;
 							bScheduleCommand((void *)pDevice, WLAN_CMD_RX_PSPOLL, NULL);
-							DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dpc: WLAN_CMD_RX_PSPOLL 2\n");
+							pr_debug("dpc: WLAN_CMD_RX_PSPOLL 2\n");
 						}
 					}
 				} else {
@@ -940,7 +938,7 @@ static bool s_bAPModeRxCtl(
 							pMgmt->sNodeDBTable[iSANodeIndex].bPSEnable = false;
 							pMgmt->sNodeDBTable[iSANodeIndex].bRxPSPoll = true;
 							bScheduleCommand((void *)pDevice, WLAN_CMD_RX_PSPOLL, NULL);
-							DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dpc: WLAN_CMD_RX_PSPOLL 3\n");
+							pr_debug("dpc: WLAN_CMD_RX_PSPOLL 3\n");
 
 						}
 					}
@@ -952,16 +950,18 @@ static bool s_bAPModeRxCtl(
 						     (WLAN_MGMT_REASON_CLASS2_NONAUTH),
 						     &Status
 );
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dpc: send vMgrDeAuthenBeginSta 3\n");
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BSSID:%pM\n",
-					p802_11Header->abyAddr3);
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ADDR2:%pM\n",
-					p802_11Header->abyAddr2);
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ADDR1:%pM\n",
-					p802_11Header->abyAddr1);
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dpc: wFrameCtl= %x\n", p802_11Header->wFrameCtl);
+				pr_debug("dpc: send vMgrDeAuthenBeginSta 3\n");
+				pr_debug("BSSID:%pM\n",
+					 p802_11Header->abyAddr3);
+				pr_debug("ADDR2:%pM\n",
+					 p802_11Header->abyAddr2);
+				pr_debug("ADDR1:%pM\n",
+					 p802_11Header->abyAddr1);
+				pr_debug("dpc: wFrameCtl= %x\n",
+					 p802_11Header->wFrameCtl);
 				VNSvInPortB(pDevice->PortOffset + MAC_REG_RCR, &(pDevice->byRxMode));
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dpc:pDevice->byRxMode = %x\n", pDevice->byRxMode);
+				pr_debug("dpc:pDevice->byRxMode = %x\n",
+					 pDevice->byRxMode);
 				return true;
 			}
 		}
@@ -999,7 +999,7 @@ static bool s_bHandleRxEncryption(
 	}
 	byKeyIdx = (*(pbyIV+3) & 0xc0);
 	byKeyIdx >>= 6;
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "\nKeyIdx: %d\n", byKeyIdx);
+	pr_debug("\nKeyIdx: %d\n", byKeyIdx);
 
 	if ((pMgmt->eAuthenMode == WMAC_AUTH_WPA) ||
 	    (pMgmt->eAuthenMode == WMAC_AUTH_WPAPSK) ||
@@ -1009,14 +1009,14 @@ static bool s_bHandleRxEncryption(
 		if (((*pbyRsr & (RSR_ADDRBROAD | RSR_ADDRMULTI)) == 0) &&
 		    (pDevice->pMgmt->byCSSPK != KEY_CTL_NONE)) {
 			// unicast pkt use pairwise key
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "unicast pkt\n");
+			pr_debug("unicast pkt\n");
 			if (KeybGetKey(&(pDevice->sKey), pDevice->abyBSSID, 0xFFFFFFFF, &pKey) == true) {
 				if (pDevice->pMgmt->byCSSPK == KEY_CTL_TKIP)
 					byDecMode = KEY_CTL_TKIP;
 				else if (pDevice->pMgmt->byCSSPK == KEY_CTL_CCMP)
 					byDecMode = KEY_CTL_CCMP;
 			}
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "unicast pkt: %d, %p\n", byDecMode, pKey);
+			pr_debug("unicast pkt: %d, %p\n", byDecMode, pKey);
 		} else {
 			// use group key
 			KeybGetKey(&(pDevice->sKey), pDevice->abyBSSID, byKeyIdx, &pKey);
@@ -1024,7 +1024,8 @@ static bool s_bHandleRxEncryption(
 				byDecMode = KEY_CTL_TKIP;
 			else if (pDevice->pMgmt->byCSSGK == KEY_CTL_CCMP)
 				byDecMode = KEY_CTL_CCMP;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "group pkt: %d, %d, %p\n", byKeyIdx, byDecMode, pKey);
+			pr_debug("group pkt: %d, %d, %p\n",
+				 byKeyIdx, byDecMode, pKey);
 		}
 	}
 	// our WEP only support Default Key
@@ -1038,10 +1039,11 @@ static bool s_bHandleRxEncryption(
 	}
 	*pKeyOut = pKey;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "AES:%d %d %d\n", pDevice->pMgmt->byCSSPK, pDevice->pMgmt->byCSSGK, byDecMode);
+	pr_debug("AES:%d %d %d\n",
+		 pDevice->pMgmt->byCSSPK, pDevice->pMgmt->byCSSGK, byDecMode);
 
 	if (pKey == NULL) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey == NULL\n");
+		pr_debug("pKey == NULL\n");
 
 		return false;
 	}
@@ -1074,13 +1076,13 @@ static bool s_bHandleRxEncryption(
 
 		PayloadLen -= (WLAN_HDR_ADDR3_LEN + 8 + 4); // 24 is 802.11 header, 8 is IV&ExtIV, 4 is crc
 		*pdwRxTSC47_16 = cpu_to_le32(*(unsigned long *)(pbyIV + 4));
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ExtIV: %lx\n", *pdwRxTSC47_16);
+		pr_debug("ExtIV: %lx\n", *pdwRxTSC47_16);
 		if (byDecMode == KEY_CTL_TKIP)
 			*pwRxTSC15_0 = cpu_to_le16(MAKEWORD(*(pbyIV + 2), *pbyIV));
 		else
 			*pwRxTSC15_0 = cpu_to_le16(*(unsigned short *)pbyIV);
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "TSC0_15: %x\n", *pwRxTSC15_0);
+		pr_debug("TSC0_15: %x\n", *pwRxTSC15_0);
 
 		if ((byDecMode == KEY_CTL_TKIP) &&
 		    (pDevice->byLocalID <= REV_ID_VT3253_A1)) {
@@ -1093,10 +1095,10 @@ static bool s_bHandleRxEncryption(
 			rc4_encrypt(&pDevice->SBox, pbyIV+8, pbyIV+8, PayloadLen);
 			if (ETHbIsBufferCrc32Ok(pbyIV+8, PayloadLen)) {
 				*pbyNewRsr |= NEWRSR_DECRYPTOK;
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ICV OK!\n");
+				pr_debug("ICV OK!\n");
 			} else {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ICV FAIL!!!\n");
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "PayloadLen = %d\n", PayloadLen);
+				pr_debug("ICV FAIL!!!\n");
+				pr_debug("PayloadLen = %d\n", PayloadLen);
 			}
 		}
 	}// end of TKIP/AES
@@ -1136,21 +1138,22 @@ static bool s_bHostWepRxEncryption(
 	}
 	byKeyIdx = (*(pbyIV+3) & 0xc0);
 	byKeyIdx >>= 6;
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "\nKeyIdx: %d\n", byKeyIdx);
+	pr_debug("\nKeyIdx: %d\n", byKeyIdx);
 
 	if (pDevice->pMgmt->byCSSGK == KEY_CTL_TKIP)
 		byDecMode = KEY_CTL_TKIP;
 	else if (pDevice->pMgmt->byCSSGK == KEY_CTL_CCMP)
 		byDecMode = KEY_CTL_CCMP;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "AES:%d %d %d\n", pDevice->pMgmt->byCSSPK, pDevice->pMgmt->byCSSGK, byDecMode);
+	pr_debug("AES:%d %d %d\n",
+		 pDevice->pMgmt->byCSSPK, pDevice->pMgmt->byCSSGK, byDecMode);
 
 	if (byDecMode != pKey->byCipherSuite)
 		return false;
 
 	if (byDecMode == KEY_CTL_WEP) {
 		// handle WEP
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "byDecMode == KEY_CTL_WEP\n");
+		pr_debug("byDecMode == KEY_CTL_WEP\n");
 
 		if ((pDevice->byLocalID <= REV_ID_VT3253_A1) ||
 		    (((PSKeyTable)(pKey->pvKeyTable))->bSoftWEP == true) ||
@@ -1176,31 +1179,32 @@ static bool s_bHostWepRxEncryption(
 
 		PayloadLen -= (WLAN_HDR_ADDR3_LEN + 8 + 4); // 24 is 802.11 header, 8 is IV&ExtIV, 4 is crc
 		*pdwRxTSC47_16 = cpu_to_le32(*(unsigned long *)(pbyIV + 4));
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ExtIV: %lx\n", *pdwRxTSC47_16);
+		pr_debug("ExtIV: %lx\n", *pdwRxTSC47_16);
 
 		if (byDecMode == KEY_CTL_TKIP)
 			*pwRxTSC15_0 = cpu_to_le16(MAKEWORD(*(pbyIV+2), *pbyIV));
 		else
 			*pwRxTSC15_0 = cpu_to_le16(*(unsigned short *)pbyIV);
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "TSC0_15: %x\n", *pwRxTSC15_0);
+		pr_debug("TSC0_15: %x\n", *pwRxTSC15_0);
 
 		if (byDecMode == KEY_CTL_TKIP) {
 			if ((pDevice->byLocalID <= REV_ID_VT3253_A1) || !bOnFly) {
 				// Software TKIP
 				// 1. 3253 A
 				// 2. NotOnFly
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "soft KEY_CTL_TKIP\n");
+				pr_debug("soft KEY_CTL_TKIP\n");
 				pMACHeader = (PS802_11Header)(pbyFrame);
 				TKIPvMixKey(pKey->abyKey, pMACHeader->abyAddr2, *pwRxTSC15_0, *pdwRxTSC47_16, pDevice->abyPRNG);
 				rc4_init(&pDevice->SBox, pDevice->abyPRNG, TKIP_KEY_LEN);
 				rc4_encrypt(&pDevice->SBox, pbyIV+8, pbyIV+8, PayloadLen);
 				if (ETHbIsBufferCrc32Ok(pbyIV+8, PayloadLen)) {
 					*pbyNewRsr |= NEWRSR_DECRYPTOK;
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ICV OK!\n");
+					pr_debug("ICV OK!\n");
 				} else {
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ICV FAIL!!!\n");
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "PayloadLen = %d\n", PayloadLen);
+					pr_debug("ICV FAIL!!!\n");
+					pr_debug("PayloadLen = %d\n",
+						 PayloadLen);
 				}
 			}
 		}
@@ -1209,12 +1213,12 @@ static bool s_bHostWepRxEncryption(
 			if (!bOnFly) {
 				// Software CCMP
 				// NotOnFly
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "soft KEY_CTL_CCMP\n");
+				pr_debug("soft KEY_CTL_CCMP\n");
 				if (AESbGenCCMP(pKey->abyKey, pbyFrame, FrameSize)) {
 					*pbyNewRsr |= NEWRSR_DECRYPTOK;
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "CCMP MIC compare OK!\n");
+					pr_debug("CCMP MIC compare OK!\n");
 				} else {
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "CCMP MIC fail!\n");
+					pr_debug("CCMP MIC fail!\n");
 				}
 			}
 		}
@@ -1252,7 +1256,7 @@ static bool s_bAPModeRxData(
 
 			// if any node in PS mode, buffer packet until DTIM.
 			if (skbcpy == NULL) {
-				DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "relay multicast no skb available\n");
+				pr_info("relay multicast no skb available\n");
 			} else {
 				skbcpy->dev = pDevice->dev;
 				skbcpy->len = FrameSize;
@@ -1280,8 +1284,9 @@ static bool s_bAPModeRxData(
 					pMgmt->sNodeDBTable[iDANodeIndex].wEnQueueCnt++;
 					wAID = pMgmt->sNodeDBTable[iDANodeIndex].wAID;
 					pMgmt->abyPSTxMap[wAID >> 3] |=  byMask[wAID & 7];
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "relay: index= %d, pMgmt->abyPSTxMap[%d]= %d\n",
-						iDANodeIndex, (wAID >> 3), pMgmt->abyPSTxMap[wAID >> 3]);
+					pr_debug("relay: index= %d, pMgmt->abyPSTxMap[%d]= %d\n",
+						 iDANodeIndex, (wAID >> 3),
+						 pMgmt->abyPSTxMap[wAID >> 3]);
 					return true;
 				} else {
 					bRelayOnly = true;
diff --git a/drivers/staging/vt6655/hostap.c b/drivers/staging/vt6655/hostap.c
index c10a1b5..0dd87d4 100644
--- a/drivers/staging/vt6655/hostap.c
+++ b/drivers/staging/vt6655/hostap.c
@@ -47,9 +47,6 @@
 
 /*---------------------  Static Classes  ----------------------------*/
 
-/*---------------------  Static Variables  --------------------------*/
-static int msglevel = MSG_LEVEL_INFO;
-
 /*---------------------  Static Functions  --------------------------*/
 
 /*---------------------  Export Variables  --------------------------*/
@@ -77,7 +74,7 @@ static int hostap_enable_hostapd(struct vnt_private *pDevice, int rtnl_locked)
 		.ndo_start_xmit         = pDevice->tx_80211,
 	};
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: Enabling hostapd mode\n", dev->name);
+	pr_debug("%s: Enabling hostapd mode\n", dev->name);
 
 	pDevice->apdev = alloc_etherdev(sizeof(*apdev_priv));
 	if (pDevice->apdev == NULL)
@@ -101,15 +98,15 @@ static int hostap_enable_hostapd(struct vnt_private *pDevice, int rtnl_locked)
 	else
 		ret = register_netdev(pDevice->apdev);
 	if (ret) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: register_netdevice(AP) failed!\n",
-			dev->name);
+		pr_debug("%s: register_netdevice(AP) failed!\n",
+			 dev->name);
 		free_netdev(pDevice->apdev);
 		pDevice->apdev = NULL;
 		return -1;
 	}
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: Registered netdevice %s for AP management\n",
-		dev->name, pDevice->apdev->name);
+	pr_debug("%s: Registered netdevice %s for AP management\n",
+		 dev->name, pDevice->apdev->name);
 
 	KeyvInitTable(&pDevice->sKey, pDevice->PortOffset);
 
@@ -132,15 +129,15 @@ static int hostap_enable_hostapd(struct vnt_private *pDevice, int rtnl_locked)
 
 static int hostap_disable_hostapd(struct vnt_private *pDevice, int rtnl_locked)
 {
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: disabling hostapd mode\n", pDevice->dev->name);
+	pr_debug("%s: disabling hostapd mode\n", pDevice->dev->name);
 
 	if (pDevice->apdev && pDevice->apdev->name && pDevice->apdev->name[0]) {
 		if (rtnl_locked)
 			unregister_netdevice(pDevice->apdev);
 		else
 			unregister_netdev(pDevice->apdev);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: Netdevice %s unregistered\n",
-			pDevice->dev->name, pDevice->apdev->name);
+		pr_debug("%s: Netdevice %s unregistered\n",
+			 pDevice->dev->name, pDevice->apdev->name);
 	}
 	if (pDevice->apdev)
 		free_netdev(pDevice->apdev);
@@ -257,17 +254,10 @@ static int hostap_add_sta(struct vnt_private *pDevice,
 
 	pMgmt->sNodeDBTable[uNodeIndex].ulLastRxJiffer = jiffies;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Add STA AID= %d\n", pMgmt->sNodeDBTable[uNodeIndex].wAID);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "MAC=%2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X\n",
-		param->sta_addr[0],
-		param->sta_addr[1],
-		param->sta_addr[2],
-		param->sta_addr[3],
-		param->sta_addr[4],
-		param->sta_addr[5]
-		);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Max Support rate = %d\n",
-		pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate);
+	pr_debug("Add STA AID= %d\n", pMgmt->sNodeDBTable[uNodeIndex].wAID);
+	pr_debug("MAC=%pM\n", param->sta_addr);
+	pr_debug("Max Support rate = %d\n",
+		 pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate);
 
 	return 0;
 }
@@ -324,8 +314,8 @@ static int hostap_set_flags_sta(struct vnt_private *pDevice,
 	if (BSSDBbIsSTAInNodeDB(pMgmt, param->sta_addr, &uNodeIndex)) {
 		pMgmt->sNodeDBTable[uNodeIndex].dwFlags |= param->u.set_flags_sta.flags_or;
 		pMgmt->sNodeDBTable[uNodeIndex].dwFlags &= param->u.set_flags_sta.flags_and;
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " dwFlags = %x\n",
-			(unsigned int)pMgmt->sNodeDBTable[uNodeIndex].dwFlags);
+		pr_debug(" dwFlags = %x\n",
+			 (unsigned int)pMgmt->sNodeDBTable[uNodeIndex].dwFlags);
 	} else {
 		return -ENOENT;
 	}
@@ -358,18 +348,18 @@ static int hostap_set_generic_element(struct vnt_private *pDevice,
 
 	pMgmt->wWPAIELen = param->u.generic_elem.len;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pMgmt->wWPAIELen = %d\n", pMgmt->wWPAIELen);
+	pr_debug("pMgmt->wWPAIELen = %d\n", pMgmt->wWPAIELen);
 
 	// disable wpa
 	if (pMgmt->wWPAIELen == 0) {
 		pMgmt->eAuthenMode = WMAC_AUTH_OPEN;
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " No WPAIE, Disable WPA\n");
+		pr_debug(" No WPAIE, Disable WPA\n");
 	} else  {
 		// enable wpa
 		if ((pMgmt->abyWPAIE[0] == WLAN_EID_RSN_WPA) ||
 		    (pMgmt->abyWPAIE[0] == WLAN_EID_RSN)) {
 			pMgmt->eAuthenMode = WMAC_AUTH_WPANONE;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Set WPAIE enable WPA\n");
+			pr_debug("Set WPAIE enable WPA\n");
 		} else
 			return -EINVAL;
 	}
@@ -432,7 +422,7 @@ static int hostap_set_encryption(struct vnt_private *pDevice,
 
 	if ((param->u.crypt.idx > 3) || (param->u.crypt.key_len > MAX_KEY_LEN)) {
 		param->u.crypt.err = HOSTAP_CRYPT_ERR_KEY_SET_FAILED;
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " HOSTAP_CRYPT_ERR_KEY_SET_FAILED\n");
+		pr_debug(" HOSTAP_CRYPT_ERR_KEY_SET_FAILED\n");
 		return -EINVAL;
 	}
 
@@ -444,12 +434,12 @@ static int hostap_set_encryption(struct vnt_private *pDevice,
 	} else {
 		if (BSSDBbIsSTAInNodeDB(pMgmt, param->sta_addr, &iNodeIndex) == false) {
 			param->u.crypt.err = HOSTAP_CRYPT_ERR_UNKNOWN_ADDR;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " HOSTAP_CRYPT_ERR_UNKNOWN_ADDR\n");
+			pr_debug(" HOSTAP_CRYPT_ERR_UNKNOWN_ADDR\n");
 			return -EINVAL;
 		}
 	}
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " hostap_set_encryption: sta_index %d\n", iNodeIndex);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " hostap_set_encryption: alg %d\n", param->u.crypt.alg);
+	pr_debug(" hostap_set_encryption: sta_index %d\n", iNodeIndex);
+	pr_debug(" hostap_set_encryption: alg %d\n", param->u.crypt.alg);
 
 	if (param->u.crypt.alg == WPA_ALG_NONE) {
 		if (pMgmt->sNodeDBTable[iNodeIndex].bOnFly) {
@@ -457,7 +447,7 @@ static int hostap_set_encryption(struct vnt_private *pDevice,
 					  param->sta_addr,
 					  pMgmt->sNodeDBTable[iNodeIndex].dwKeyIndex,
 					  pDevice->PortOffset)) {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "KeybRemoveKey fail\n");
+				pr_debug("KeybRemoveKey fail\n");
 			}
 			pMgmt->sNodeDBTable[iNodeIndex].bOnFly = false;
 		}
@@ -588,7 +578,7 @@ static int hostap_set_encryption(struct vnt_private *pDevice,
 			// Key Table Full
 			pMgmt->sNodeDBTable[iNodeIndex].bOnFly = false;
 			bKeyTableFull = true;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " Key Table Full\n");
+			pr_debug(" Key Table Full\n");
 		}
 
 	}
@@ -602,16 +592,15 @@ static int hostap_set_encryption(struct vnt_private *pDevice,
 		MACvSetDefaultKeyCtl(pDevice->PortOffset, wKeyCtl, MAX_KEY_TABLE-1, pDevice->byLocalID);
 	}
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " Set key sta_index= %d\n", iNodeIndex);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " tx_index=%d len=%d\n", param->u.crypt.idx,
-		param->u.crypt.key_len);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " key=%x-%x-%x-%x-%x-xxxxx\n",
-		pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[0],
-		pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[1],
-		pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[2],
-		pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[3],
-		pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[4]
-);
+	pr_debug(" Set key sta_index= %d\n", iNodeIndex);
+	pr_debug(" tx_index=%d len=%d\n",
+		 param->u.crypt.idx, param->u.crypt.key_len);
+	pr_debug(" key=%x-%x-%x-%x-%x-xxxxx\n",
+		 pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[0],
+		 pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[1],
+		 pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[2],
+		 pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[3],
+		 pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[4]);
 
 	// set wep key
 	pDevice->bEncryptionEnable = true;
@@ -651,11 +640,11 @@ static int hostap_get_encryption(struct vnt_private *pDevice,
 	} else {
 		if (BSSDBbIsSTAInNodeDB(pMgmt, param->sta_addr, &iNodeIndex) == false) {
 			param->u.crypt.err = HOSTAP_CRYPT_ERR_UNKNOWN_ADDR;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "hostap_get_encryption: HOSTAP_CRYPT_ERR_UNKNOWN_ADDR\n");
+			pr_debug("hostap_get_encryption: HOSTAP_CRYPT_ERR_UNKNOWN_ADDR\n");
 			return -EINVAL;
 		}
 	}
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "hostap_get_encryption: %d\n", iNodeIndex);
+	pr_debug("hostap_get_encryption: %d\n", iNodeIndex);
 	memset(param->u.crypt.seq, 0, 8);
 	for (ii = 0; ii < 8; ii++)
 		param->u.crypt.seq[ii] = (unsigned char)pMgmt->sNodeDBTable[iNodeIndex].KeyRSC >> (ii * 8);
@@ -697,67 +686,67 @@ int vt6655_hostap_ioctl(struct vnt_private *pDevice, struct iw_point *p)
 
 	switch (param->cmd) {
 	case VIAWGET_HOSTAPD_SET_ENCRYPTION:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_SET_ENCRYPTION\n");
+		pr_debug("VIAWGET_HOSTAPD_SET_ENCRYPTION\n");
 		spin_lock_irq(&pDevice->lock);
 		ret = hostap_set_encryption(pDevice, param, p->length);
 		spin_unlock_irq(&pDevice->lock);
 		break;
 	case VIAWGET_HOSTAPD_GET_ENCRYPTION:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_GET_ENCRYPTION\n");
+		pr_debug("VIAWGET_HOSTAPD_GET_ENCRYPTION\n");
 		spin_lock_irq(&pDevice->lock);
 		ret = hostap_get_encryption(pDevice, param, p->length);
 		spin_unlock_irq(&pDevice->lock);
 		break;
 	case VIAWGET_HOSTAPD_SET_ASSOC_AP_ADDR:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_SET_ASSOC_AP_ADDR\n");
+		pr_debug("VIAWGET_HOSTAPD_SET_ASSOC_AP_ADDR\n");
 		ret = -EOPNOTSUPP;
 		goto out;
 	case VIAWGET_HOSTAPD_FLUSH:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_FLUSH\n");
+		pr_debug("VIAWGET_HOSTAPD_FLUSH\n");
 		spin_lock_irq(&pDevice->lock);
 		hostap_flush_sta(pDevice);
 		spin_unlock_irq(&pDevice->lock);
 		break;
 	case VIAWGET_HOSTAPD_ADD_STA:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_ADD_STA\n");
+		pr_debug("VIAWGET_HOSTAPD_ADD_STA\n");
 		spin_lock_irq(&pDevice->lock);
 		ret = hostap_add_sta(pDevice, param);
 		spin_unlock_irq(&pDevice->lock);
 		break;
 	case VIAWGET_HOSTAPD_REMOVE_STA:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_REMOVE_STA\n");
+		pr_debug("VIAWGET_HOSTAPD_REMOVE_STA\n");
 		spin_lock_irq(&pDevice->lock);
 		ret = hostap_remove_sta(pDevice, param);
 		spin_unlock_irq(&pDevice->lock);
 		break;
 	case VIAWGET_HOSTAPD_GET_INFO_STA:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_GET_INFO_STA\n");
+		pr_debug("VIAWGET_HOSTAPD_GET_INFO_STA\n");
 		ret = hostap_get_info_sta(pDevice, param);
 		ap_ioctl = 1;
 		break;
 	case VIAWGET_HOSTAPD_SET_FLAGS_STA:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_SET_FLAGS_STA\n");
+		pr_debug("VIAWGET_HOSTAPD_SET_FLAGS_STA\n");
 		ret = hostap_set_flags_sta(pDevice, param);
 		break;
 	case VIAWGET_HOSTAPD_MLME:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_MLME\n");
+		pr_debug("VIAWGET_HOSTAPD_MLME\n");
 		ret = -EOPNOTSUPP;
 		goto out;
 	case VIAWGET_HOSTAPD_SET_GENERIC_ELEMENT:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_SET_GENERIC_ELEMENT\n");
+		pr_debug("VIAWGET_HOSTAPD_SET_GENERIC_ELEMENT\n");
 		ret = hostap_set_generic_element(pDevice, param);
 		break;
 	case VIAWGET_HOSTAPD_SCAN_REQ:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_SCAN_REQ\n");
+		pr_debug("VIAWGET_HOSTAPD_SCAN_REQ\n");
 		ret = -EOPNOTSUPP;
 		goto out;
 	case VIAWGET_HOSTAPD_STA_CLEAR_STATS:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_STA_CLEAR_STATS\n");
+		pr_debug("VIAWGET_HOSTAPD_STA_CLEAR_STATS\n");
 		ret = -EOPNOTSUPP;
 		goto out;
 	default:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "vt6655_hostap_ioctl: unknown cmd=%d\n",
-			(int)param->cmd);
+		pr_debug("vt6655_hostap_ioctl: unknown cmd=%d\n",
+			 (int)param->cmd);
 		ret = -EOPNOTSUPP;
 		goto out;
 	}
diff --git a/drivers/staging/vt6655/ioctl.c b/drivers/staging/vt6655/ioctl.c
index 306a7db..970e80d 100644
--- a/drivers/staging/vt6655/ioctl.c
+++ b/drivers/staging/vt6655/ioctl.c
@@ -38,8 +38,6 @@
 #include "wpactl.h"
 #include "rf.h"
 
-static int msglevel = MSG_LEVEL_INFO;
-
 #ifdef WPA_SM_Transtatus
 SWPAResult wpa_Result;
 #endif
@@ -74,7 +72,7 @@ int private_ioctl(struct vnt_private *pDevice, struct ifreq *rq)
 
 	switch (pReq->wCmdCode) {
 	case WLAN_CMD_BSS_SCAN:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "WLAN_CMD_BSS_SCAN..begin\n");
+		pr_debug("WLAN_CMD_BSS_SCAN..begin\n");
 		if (copy_from_user(&sScanCmd, pReq->data, sizeof(SCmdScan))) {
 			result = -EFAULT;
 			break;
@@ -175,27 +173,27 @@ int private_ioctl(struct vnt_private *pDevice, struct ifreq *rq)
 		memcpy(pMgmt->abyDesireSSID, pItemSSID, pItemSSID->len + WLAN_IEHDR_LEN);
 		if (sJoinCmd.wBSSType == ADHOC) {
 			pMgmt->eConfigMode = WMAC_CONFIG_IBSS_STA;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ioct set to adhoc mode\n");
+			pr_debug("ioct set to adhoc mode\n");
 		} else {
 			pMgmt->eConfigMode = WMAC_CONFIG_ESS_STA;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ioct set to STA mode\n");
+			pr_debug("ioct set to STA mode\n");
 		}
 		if (sJoinCmd.bPSEnable == true) {
 			pDevice->ePSMode = WMAC_POWER_FAST;
 			pMgmt->wListenInterval = 2;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Power Saving On\n");
+			pr_debug("Power Saving On\n");
 		} else {
 			pDevice->ePSMode = WMAC_POWER_CAM;
 			pMgmt->wListenInterval = 1;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Power Saving Off\n");
+			pr_debug("Power Saving Off\n");
 		}
 
 		if (sJoinCmd.bShareKeyAuth == true) {
 			pMgmt->bShareKeyAlgorithm = true;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Share Key\n");
+			pr_debug("Share Key\n");
 		} else {
 			pMgmt->bShareKeyAlgorithm = false;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Open System\n");
+			pr_debug("Open System\n");
 		}
 		pDevice->uChannel = sJoinCmd.uChannel;
 		netif_stop_queue(pDevice->dev);
@@ -207,7 +205,7 @@ int private_ioctl(struct vnt_private *pDevice, struct ifreq *rq)
 		break;
 
 	case WLAN_CMD_SET_WEP:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "WLAN_CMD_SET_WEP Key.\n");
+		pr_debug("WLAN_CMD_SET_WEP Key\n");
 		memset(&sWEPCmd, 0, sizeof(SCmdSetWEP));
 		if (copy_from_user(&sWEPCmd, pReq->data, sizeof(SCmdSetWEP))) {
 			result = -EFAULT;
@@ -217,7 +215,7 @@ int private_ioctl(struct vnt_private *pDevice, struct ifreq *rq)
 			pDevice->bEncryptionEnable = false;
 			pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 			MACvDisableDefaultKey(pDevice->PortOffset);
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "WEP function disable.\n");
+			pr_debug("WEP function disable\n");
 			break;
 		}
 
@@ -247,7 +245,7 @@ int private_ioctl(struct vnt_private *pDevice, struct ifreq *rq)
 	case WLAN_CMD_GET_LINK: {
 		SCmdLinkStatus sLinkStatus;
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "WLAN_CMD_GET_LINK status.\n");
+		pr_debug("WLAN_CMD_GET_LINK status\n");
 
 		memset(&sLinkStatus, 0, sizeof(sLinkStatus));
 
@@ -268,7 +266,7 @@ int private_ioctl(struct vnt_private *pDevice, struct ifreq *rq)
 			memcpy(sLinkStatus.abySSID, pItemSSID->abySSID, pItemSSID->len);
 			memcpy(sLinkStatus.abyBSSID, pMgmt->abyCurrBSSID, WLAN_BSSID_LEN);
 			sLinkStatus.uLinkRate = pMgmt->sNodeDBTable[0].wTxDataRate;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " Link Success!\n");
+			pr_debug(" Link Success!\n");
 		} else {
 			sLinkStatus.bLink = false;
 			sLinkStatus.uLinkRate = 0;
@@ -364,7 +362,7 @@ int private_ioctl(struct vnt_private *pDevice, struct ifreq *rq)
 		break;
 
 	case WLAN_CMD_STOP_MAC:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "WLAN_CMD_STOP_MAC\n");
+		pr_debug("WLAN_CMD_STOP_MAC\n");
 		netif_stop_queue(pDevice->dev);
 
 		spin_lock_irq(&pDevice->lock);
@@ -383,7 +381,7 @@ int private_ioctl(struct vnt_private *pDevice, struct ifreq *rq)
 		break;
 
 	case WLAN_CMD_START_MAC:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "WLAN_CMD_START_MAC\n");
+		pr_debug("WLAN_CMD_START_MAC\n");
 
 		if (pDevice->bMACSuspend == true) {
 			if (pDevice->bRadioOff == true)
@@ -396,7 +394,7 @@ int private_ioctl(struct vnt_private *pDevice, struct ifreq *rq)
 		break;
 
 	case WLAN_CMD_SET_HOSTAPD:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "WLAN_CMD_SET_HOSTAPD\n");
+		pr_debug("WLAN_CMD_SET_HOSTAPD\n");
 
 		if (copy_from_user(&sValue, pReq->data, sizeof(SCmdValue))) {
 			result = -EFAULT;
@@ -404,23 +402,23 @@ int private_ioctl(struct vnt_private *pDevice, struct ifreq *rq)
 		}
 		if (sValue.dwValue == 1) {
 			if (vt6655_hostap_set_hostapd(pDevice, 1, 1) == 0) {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enable HOSTAP\n");
+				pr_debug("Enable HOSTAP\n");
 			} else {
 				result = -EFAULT;
 				break;
 			}
 		} else {
 			vt6655_hostap_set_hostapd(pDevice, 0, 1);
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Disable HOSTAP\n");
+			pr_debug("Disable HOSTAP\n");
 		}
 		break;
 
 	case WLAN_CMD_SET_HOSTAPD_STA:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "WLAN_CMD_SET_HOSTAPD_STA\n");
+		pr_debug("WLAN_CMD_SET_HOSTAPD_STA\n");
 		break;
 
 	case WLAN_CMD_SET_802_1X:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "WLAN_CMD_SET_802_1X\n");
+		pr_debug("WLAN_CMD_SET_802_1X\n");
 		if (copy_from_user(&sValue, pReq->data, sizeof(SCmdValue))) {
 			result = -EFAULT;
 			break;
@@ -428,15 +426,15 @@ int private_ioctl(struct vnt_private *pDevice, struct ifreq *rq)
 
 		if (sValue.dwValue == 1) {
 			pDevice->bEnable8021x = true;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enable 802.1x\n");
+			pr_debug("Enable 802.1x\n");
 		} else {
 			pDevice->bEnable8021x = false;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Disable 802.1x\n");
+			pr_debug("Disable 802.1x\n");
 		}
 		break;
 
 	case WLAN_CMD_SET_HOST_WEP:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "WLAN_CMD_SET_HOST_WEP\n");
+		pr_debug("WLAN_CMD_SET_HOST_WEP\n");
 		if (copy_from_user(&sValue, pReq->data, sizeof(SCmdValue))) {
 			result = -EFAULT;
 			break;
@@ -444,32 +442,32 @@ int private_ioctl(struct vnt_private *pDevice, struct ifreq *rq)
 
 		if (sValue.dwValue == 1) {
 			pDevice->bEnableHostWEP = true;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enable HostWEP\n");
+			pr_debug("Enable HostWEP\n");
 		} else {
 			pDevice->bEnableHostWEP = false;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Disable HostWEP\n");
+			pr_debug("Disable HostWEP\n");
 		}
 		break;
 
 	case WLAN_CMD_SET_WPA:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "WLAN_CMD_SET_WPA\n");
+		pr_debug("WLAN_CMD_SET_WPA\n");
 
 		if (copy_from_user(&sValue, pReq->data, sizeof(SCmdValue))) {
 			result = -EFAULT;
 			break;
 		}
 		if (sValue.dwValue == 1) {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "up wpadev\n");
+			pr_debug("up wpadev\n");
 			eth_hw_addr_inherit(pDevice->wpadev, pDevice->dev);
 			pDevice->bWPADEVUp = true;
 		} else {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "close wpadev\n");
+			pr_debug("close wpadev\n");
 			pDevice->bWPADEVUp = false;
 		}
 		break;
 
 	case WLAN_CMD_AP_START:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "WLAN_CMD_AP_START\n");
+		pr_debug("WLAN_CMD_AP_START\n");
 		if (pDevice->bRadioOff == true) {
 			CARDbRadioPowerOn(pDevice);
 			vMgrTimerInit(pDevice);
@@ -483,9 +481,9 @@ int private_ioctl(struct vnt_private *pDevice, struct ifreq *rq)
 
 		if (sStartAPCmd.wBSSType == AP) {
 			pMgmt->eConfigMode = WMAC_CONFIG_AP;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ioct set to AP mode\n");
+			pr_debug("ioct set to AP mode\n");
 		} else {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ioct BSS type not set to AP mode\n");
+			pr_debug("ioct BSS type not set to AP mode\n");
 			result = -EFAULT;
 			break;
 		}
@@ -513,10 +511,10 @@ int private_ioctl(struct vnt_private *pDevice, struct ifreq *rq)
 
 		if (sStartAPCmd.bShareKeyAuth == true) {
 			pMgmt->bShareKeyAlgorithm = true;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Share Key\n");
+			pr_debug("Share Key\n");
 		} else {
 			pMgmt->bShareKeyAlgorithm = false;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Open System\n");
+			pr_debug("Open System\n");
 		}
 		memcpy(pMgmt->abyIBSSSuppRates, abySuppRates, 6);
 
@@ -540,8 +538,8 @@ int private_ioctl(struct vnt_private *pDevice, struct ifreq *rq)
 			pMgmt->abyIBSSSuppRates[3] |= BIT7;
 		}
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Support Rate= %*ph\n",
-			4, pMgmt->abyIBSSSuppRates + 2);
+		pr_debug("Support Rate= %*ph\n",
+			 4, pMgmt->abyIBSSSuppRates + 2);
 
 		netif_stop_queue(pDevice->dev);
 		spin_lock_irq(&pDevice->lock);
@@ -597,12 +595,12 @@ int private_ioctl(struct vnt_private *pDevice, struct ifreq *rq)
 				pNodeList->sNodeList[jj].byKeyIndex = pNode->byKeyIndex;
 				pNodeList->sNodeList[jj].wWepKeyLength = pNode->uWepKeyLength;
 				memcpy(&(pNodeList->sNodeList[jj].abyWepKey[0]), &(pNode->abyWepKey[0]), WEP_KEYMAXLEN);
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "key= %2.2X:%2.2X:%2.2X:%2.2X:%2.2X\n",
-					pNodeList->sNodeList[jj].abyWepKey[0],
-					pNodeList->sNodeList[jj].abyWepKey[1],
-					pNodeList->sNodeList[jj].abyWepKey[2],
-					pNodeList->sNodeList[jj].abyWepKey[3],
-					pNodeList->sNodeList[jj].abyWepKey[4]);
+				pr_debug("key= %2.2X:%2.2X:%2.2X:%2.2X:%2.2X\n",
+					 pNodeList->sNodeList[jj].abyWepKey[0],
+					 pNodeList->sNodeList[jj].abyWepKey[1],
+					 pNodeList->sNodeList[jj].abyWepKey[2],
+					 pNodeList->sNodeList[jj].abyWepKey[3],
+					 pNodeList->sNodeList[jj].abyWepKey[4]);
 				pNodeList->sNodeList[jj].bIsInFallback = pNode->bIsInFallback;
 				pNodeList->sNodeList[jj].uTxFailures = pNode->uTxFailures;
 				pNodeList->sNodeList[jj].uTxAttempts = pNode->uTxAttempts;
@@ -653,7 +651,7 @@ int private_ioctl(struct vnt_private *pDevice, struct ifreq *rq)
 #endif
 
 	default:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Private command not support..\n");
+		pr_debug("Private command not support..\n");
 	}
 
 	return result;
diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index 0c73064..6a6bdd3 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -66,9 +66,6 @@ static const long frequency_list[] = {
 };
 
 /*---------------------  Static Classes  ----------------------------*/
-
-static int msglevel = MSG_LEVEL_INFO;
-
 /*---------------------  Static Variables  --------------------------*/
 /*---------------------  Static Functions  --------------------------*/
 
@@ -108,7 +105,7 @@ static int iwctl_commit(struct net_device *dev,
 			void *wrq,
 			char *extra)
 {
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWCOMMIT\n");
+	pr_debug(" SIOCSIWCOMMIT\n");
 
 	return 0;
 }
@@ -140,7 +137,7 @@ static int iwctl_siwscan(struct net_device *dev,
 	unsigned char abyScanSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
 	PWLAN_IE_SSID pItemSSID = NULL;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWSCAN\n");
+	pr_debug(" SIOCSIWSCAN\n");
 
 	if (pDevice->byReAssocCount > 0) {   //reject scan when re-associating!
 //send scan event to wpa_Supplicant
@@ -210,7 +207,7 @@ static int iwctl_giwscan(struct net_device *dev,
 	long ldBm;
 	char buf[MAX_WPA_IE_LEN * 2 + 30];
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWSCAN\n");
+	pr_debug(" SIOCGIWSCAN\n");
 
 	if (pMgmt->eScanState ==  WMAC_IS_SCANNING) {
 		// In scanning..
@@ -353,7 +350,7 @@ int iwctl_siwfreq(struct net_device *dev,
 	struct vnt_private *pDevice = netdev_priv(dev);
 	int rc = 0;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWFREQ\n");
+	pr_debug(" SIOCSIWFREQ\n");
 
 	// If setting by frequency, convert to a channel
 	if ((wrq->e == 1) &&
@@ -374,11 +371,12 @@ int iwctl_siwfreq(struct net_device *dev,
 		int channel = wrq->m;
 
 		if ((channel < 1) || (channel > 14)) {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: New channel value of %d is invalid!\n", dev->name, wrq->m);
+			pr_debug("%s: New channel value of %d is invalid!\n",
+				 dev->name, wrq->m);
 			rc = -EINVAL;
 		} else {
 			// Yes ! We can set it !!!
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " Set to channel = %d\n", channel);
+			pr_debug(" Set to channel = %d\n", channel);
 			pDevice->uChannel = channel;
 			//2007-0207-04,<Add> by EinsnLiu
 			//Make change effect at once
@@ -401,7 +399,7 @@ int iwctl_giwfreq(struct net_device *dev,
 	struct vnt_private *pDevice = netdev_priv(dev);
 	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWFREQ\n");
+	pr_debug(" SIOCGIWFREQ\n");
 
 #ifdef WEXT_USECHANNELS
 	wrq->m = (int)pMgmt->uCurrChannel;
@@ -433,10 +431,10 @@ int iwctl_siwmode(struct net_device *dev,
 	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 	int rc = 0;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWMODE\n");
+	pr_debug(" SIOCSIWMODE\n");
 
 	if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP && pDevice->bEnableHostapd) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Can't set operation mode, hostapd is running\n");
+		pr_debug("Can't set operation mode, hostapd is running\n");
 		return rc;
 	}
 
@@ -448,7 +446,7 @@ int iwctl_siwmode(struct net_device *dev,
 				pDevice->bCommit = true;
 
 		}
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set mode to ad-hoc\n");
+		pr_debug("set mode to ad-hoc\n");
 		break;
 	case IW_MODE_AUTO:
 	case IW_MODE_INFRA:
@@ -458,7 +456,7 @@ int iwctl_siwmode(struct net_device *dev,
 				pDevice->bCommit = true;
 
 		}
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set mode to infrastructure\n");
+		pr_debug("set mode to infrastructure\n");
 		break;
 	case IW_MODE_MASTER:
 
@@ -472,7 +470,7 @@ int iwctl_siwmode(struct net_device *dev,
 				pDevice->bCommit = true;
 
 		}
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set mode to Access Point\n");
+		pr_debug("set mode to Access Point\n");
 		break;
 
 	case IW_MODE_REPEAT:
@@ -498,7 +496,7 @@ int iwctl_giwmode(struct net_device *dev,
 	struct vnt_private *pDevice = netdev_priv(dev);
 	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWMODE\n");
+	pr_debug(" SIOCGIWMODE\n");
 	// If not managed, assume it's ad-hoc
 	switch (pMgmt->eConfigMode) {
 	case WMAC_CONFIG_ESS_STA:
@@ -533,7 +531,7 @@ int iwctl_giwrange(struct net_device *dev,
 	int i, k;
 	unsigned char abySupportedRates[13] = {0x02, 0x04, 0x0B, 0x16, 0x0c, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C, 0x90};
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRANGE\n");
+	pr_debug(" SIOCGIWRANGE\n");
 	if (wrq->pointer) {
 		wrq->length = sizeof(struct iw_range);
 		memset(range, 0, sizeof(struct iw_range));
@@ -640,7 +638,7 @@ int iwctl_siwap(struct net_device *dev,
 	int rc = 0;
 	unsigned char ZeroBSSID[WLAN_BSSID_LEN] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWAP\n");
+	pr_debug(" SIOCSIWAP\n");
 	if (pMgmt->eScanState ==  WMAC_IS_SCANNING) {
 		// In scanning..
 		pr_debug("SIOCSIWAP(??)-->In scanning..\n");
@@ -697,7 +695,7 @@ int iwctl_giwap(struct net_device *dev,
 	struct vnt_private *pDevice = netdev_priv(dev);
 	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWAP\n");
+	pr_debug(" SIOCGIWAP\n");
 
 	memcpy(wrq->sa_data, pMgmt->abyCurrBSSID, 6);
 	//2008-0410,<Modify> by Einsn Liu
@@ -731,7 +729,7 @@ int iwctl_giwaplist(struct net_device *dev,
 	struct vnt_private *pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWAPLIST\n");
+	pr_debug(" SIOCGIWAPLIST\n");
 
 	if (!capable(CAP_NET_ADMIN)) {
 		rc = -EPERM;
@@ -800,7 +798,7 @@ int iwctl_siwessid(struct net_device *dev,
 	//2008-0409-05, <Add> by Einsn Liu
 	unsigned char len;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWESSID\n");
+	pr_debug(" SIOCSIWESSID\n");
 	pDevice->fWPA_Authened = false;
 	if (pMgmt->eScanState ==  WMAC_IS_SCANNING) {
 		// In scanning..
@@ -885,7 +883,7 @@ int iwctl_siwessid(struct net_device *dev,
 		}
 #endif
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set essid = %s\n", pItemSSID->abySSID);
+		pr_debug("set essid = %s\n", pItemSSID->abySSID);
 	}
 
 	if (pDevice->flags & DEVICE_FLAGS_OPENED)
@@ -907,7 +905,7 @@ int iwctl_giwessid(struct net_device *dev,
 	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 	PWLAN_IE_SSID       pItemSSID;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWESSID\n");
+	pr_debug(" SIOCGIWESSID\n");
 
 	// Note : if wrq->u.data.flags != 0, we should
 	// get the relevant SSID from the SSID list...
@@ -939,7 +937,7 @@ int iwctl_siwrate(struct net_device *dev,
 	int	i;
 	unsigned char abySupportedRates[13] = {0x02, 0x04, 0x0B, 0x16, 0x0c, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C, 0x90};
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWRATE\n");
+	pr_debug(" SIOCSIWRATE\n");
 	if (!(pDevice->flags & DEVICE_FLAGS_OPENED)) {
 		rc = -EINVAL;
 		return rc;
@@ -993,7 +991,8 @@ int iwctl_siwrate(struct net_device *dev,
 			pDevice->uConnectionRate = 3;
 		} else {
 			pDevice->uConnectionRate = brate;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Fixed to Rate %d\n", pDevice->uConnectionRate);
+			pr_debug("Fixed to Rate %d\n",
+				 pDevice->uConnectionRate);
 		}
 
 	} else {
@@ -1019,7 +1018,7 @@ int iwctl_giwrate(struct net_device *dev,
 //Mark the unnecessary sentences.
 //    PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRATE\n");
+	pr_debug(" SIOCGIWRATE\n");
 	{
 		unsigned char abySupportedRates[13] = {0x02, 0x04, 0x0B, 0x16, 0x0c, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C, 0x90};
 		int brate = 0;
@@ -1062,7 +1061,7 @@ int iwctl_siwrts(struct net_device *dev,
 	struct vnt_private *pDevice = netdev_priv(dev);
 	int rc = 0;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWRTS\n");
+	pr_debug(" SIOCSIWRTS\n");
 
 	{
 		int rthr = wrq->value;
@@ -1090,7 +1089,7 @@ int iwctl_giwrts(struct net_device *dev,
 {
 	struct vnt_private *pDevice = netdev_priv(dev);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRTS\n");
+	pr_debug(" SIOCGIWRTS\n");
 	wrq->value = pDevice->wRTSThreshold;
 	wrq->disabled = (wrq->value >= 2312);
 	wrq->fixed = 1;
@@ -1111,7 +1110,7 @@ int iwctl_siwfrag(struct net_device *dev,
 	int rc = 0;
 	int fthr = wrq->value;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWFRAG\n");
+	pr_debug(" SIOCSIWFRAG\n");
 
 	if (wrq->disabled)
 		fthr = 2312;
@@ -1136,7 +1135,7 @@ int iwctl_giwfrag(struct net_device *dev,
 {
 	struct vnt_private *pDevice = netdev_priv(dev);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWFRAG\n");
+	pr_debug(" SIOCGIWFRAG\n");
 	wrq->value = pDevice->wFragmentationThreshold;
 	wrq->disabled = (wrq->value >= 2312);
 	wrq->fixed = 1;
@@ -1155,7 +1154,7 @@ int iwctl_siwretry(struct net_device *dev,
 	struct vnt_private *pDevice = netdev_priv(dev);
 	int rc = 0;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWRETRY\n");
+	pr_debug(" SIOCSIWRETRY\n");
 
 	if (wrq->disabled) {
 		rc = -EINVAL;
@@ -1189,7 +1188,7 @@ int iwctl_giwretry(struct net_device *dev,
 {
 	struct vnt_private *pDevice = netdev_priv(dev);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRETRY\n");
+	pr_debug(" SIOCGIWRETRY\n");
 	wrq->disabled = 0;      // Can't be disabled
 
 	// Note : by default, display the min retry number
@@ -1234,7 +1233,7 @@ int iwctl_siwencode(struct net_device *dev,
 
 	PSKeyTable pkeytab;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWENCODE\n");
+	pr_debug(" SIOCSIWENCODE\n");
 
 	if ((wrq->flags & IW_ENCODE_DISABLED) == 0) {
 		//Not disable encryption
@@ -1262,11 +1261,12 @@ int iwctl_siwencode(struct net_device *dev,
 		if (wrq->length > 0) {//have key
 
 			if (wrq->length ==  WLAN_WEP232_KEYLEN) {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Set 232 bit wep key\n");
+				pr_debug("Set 232 bit wep key\n");
 			} else if (wrq->length ==  WLAN_WEP104_KEYLEN) {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Set 104 bit wep key\n");
+				pr_debug("Set 104 bit wep key\n");
 			} else if (wrq->length == WLAN_WEP40_KEYLEN) {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Set 40 bit wep key, index= %d\n", (int)dwKeyIndex);
+				pr_debug("Set 40 bit wep key, index= %d\n",
+					 (int)dwKeyIndex);
 			} else {//no support length
 				rc = -EINVAL;
 				return rc;
@@ -1274,9 +1274,9 @@ int iwctl_siwencode(struct net_device *dev,
 			memset(pDevice->abyKey, 0, WLAN_WEP232_KEYLEN);
 			memcpy(pDevice->abyKey, extra, wrq->length);
 
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "abyKey: ");
+			pr_debug("abyKey: ");
 			for (ii = 0; ii < wrq->length; ii++)
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%02x ", pDevice->abyKey[ii]);
+				pr_debug("%02x ", pDevice->abyKey[ii]);
 
 			if (pDevice->flags & DEVICE_FLAGS_OPENED) {
 				spin_lock_irq(&pDevice->lock);
@@ -1304,10 +1304,10 @@ int iwctl_siwencode(struct net_device *dev,
 				rc = -EINVAL;
 				return rc;
 			}
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Just set Default key Index:\n");
+			pr_debug("Just set Default key Index:\n");
 			pkeytab = &(pDevice->sKey.KeyTable[MAX_KEY_TABLE - 1]);
 			if (pkeytab->GroupKey[(unsigned char)dwKeyIndex].uKeyLength == 0) {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Default key len is 0\n");
+				pr_debug("Default key len is 0\n");
 				rc = -EINVAL;
 				return rc;
 			}
@@ -1317,7 +1317,7 @@ int iwctl_siwencode(struct net_device *dev,
 		}
 
 	} else {//disable the key
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Disable WEP function\n");
+		pr_debug("Disable WEP function\n");
 		if (pDevice->bEncryptionEnable == false)
 			return 0;
 		pMgmt->bShareKeyAlgorithm = false;
@@ -1333,11 +1333,11 @@ int iwctl_siwencode(struct net_device *dev,
 //End Modify,Einsn
 
 	if (wrq->flags & IW_ENCODE_RESTRICTED) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enable WEP & ShareKey System\n");
+		pr_debug("Enable WEP & ShareKey System\n");
 		pMgmt->bShareKeyAlgorithm = true;
 	}
 	if (wrq->flags & IW_ENCODE_OPEN) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enable WEP & Open System\n");
+		pr_debug("Enable WEP & Open System\n");
 		pMgmt->bShareKeyAlgorithm = false;
 	}
 	return rc;
@@ -1355,7 +1355,7 @@ int iwctl_giwencode(struct net_device *dev,
 	unsigned int index = (unsigned int)(wrq->flags & IW_ENCODE_INDEX);
 	PSKeyItem	pKey = NULL;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWENCODE\n");
+	pr_debug(" SIOCGIWENCODE\n");
 
 	if (index > WLAN_WEP_NKEYS)
 		return	-EINVAL;
@@ -1414,7 +1414,7 @@ int iwctl_siwpower(struct net_device *dev,
 	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 	int rc = 0;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER\n");
+	pr_debug(" SIOCSIWPOWER\n");
 
 	if (!(pDevice->flags & DEVICE_FLAGS_OPENED)) {
 		rc = -EINVAL;
@@ -1436,14 +1436,14 @@ int iwctl_siwpower(struct net_device *dev,
 	}
 	switch (wrq->flags & IW_POWER_MODE) {
 	case IW_POWER_UNICAST_R:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER: IW_POWER_UNICAST_R\n");
+		pr_debug(" SIOCSIWPOWER: IW_POWER_UNICAST_R\n");
 		rc = -EINVAL;
 		break;
 	case IW_POWER_ALL_R:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER: IW_POWER_ALL_R\n");
+		pr_debug(" SIOCSIWPOWER: IW_POWER_ALL_R\n");
 		rc = -EINVAL;
 	case IW_POWER_ON:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER: IW_POWER_ON\n");
+		pr_debug(" SIOCSIWPOWER: IW_POWER_ON\n");
 		break;
 	default:
 		rc = -EINVAL;
@@ -1464,7 +1464,7 @@ int iwctl_giwpower(struct net_device *dev,
 	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 	int mode = pDevice->ePSMode;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWPOWER\n");
+	pr_debug(" SIOCGIWPOWER\n");
 
 	wrq->disabled = (mode == WMAC_POWER_CAM);
 	if (wrq->disabled)
@@ -1493,7 +1493,7 @@ int iwctl_giwsens(struct net_device *dev,
 	struct vnt_private *pDevice = netdev_priv(dev);
 	long ldBm;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWSENS\n");
+	pr_debug(" SIOCGIWSENS\n");
 	if (pDevice->bLinkPass == true) {
 		RFvRSSITodBm(pDevice, (unsigned char)(pDevice->uCurrRSSI), &ldBm);
 		wrq->value = ldBm;
@@ -1520,7 +1520,7 @@ int iwctl_siwauth(struct net_device *dev,
 	static int wpa_version = 0;  //must be static to save the last value,einsn liu
 	static int pairwise = 0;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWAUTH\n");
+	pr_debug(" SIOCSIWAUTH\n");
 	switch (wrq->flags & IW_AUTH_INDEX) {
 	case IW_AUTH_WPA_VERSION:
 		wpa_version = wrq->value;
diff --git a/drivers/staging/vt6655/key.c b/drivers/staging/vt6655/key.c
index 1903790..211afae 100644
--- a/drivers/staging/vt6655/key.c
+++ b/drivers/staging/vt6655/key.c
@@ -44,8 +44,6 @@
 
 /*---------------------  Static Classes  ----------------------------*/
 
-/*---------------------  Static Variables  --------------------------*/
-static int msglevel = MSG_LEVEL_INFO;
 /*---------------------  Static Functions  --------------------------*/
 
 /*---------------------  Export Variables  --------------------------*/
@@ -134,7 +132,7 @@ bool KeybGetKey(
 {
 	int i;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "KeybGetKey()\n");
+	pr_debug("KeybGetKey()\n");
 
 	*pKey = NULL;
 	for (i = 0; i < MAX_KEY_TABLE; i++) {
@@ -196,7 +194,7 @@ bool KeybSetKey(
 	PSKeyItem   pKey;
 	unsigned int uKeyIdx;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enter KeybSetKey: %lX\n", dwKeyIndex);
+	pr_debug("Enter KeybSetKey: %lX\n", dwKeyIndex);
 
 	j = (MAX_KEY_TABLE-1);
 	for (i = 0; i < (MAX_KEY_TABLE - 1); i++) {
@@ -221,7 +219,8 @@ bool KeybSetKey(
 				if ((dwKeyIndex & TRANSMIT_KEY) != 0)  {
 					// Group transmit key
 					pTable->KeyTable[i].dwGTKeyIndex = dwKeyIndex;
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Group transmit key(R)[%lX]: %d\n", pTable->KeyTable[i].dwGTKeyIndex, i);
+					pr_debug("Group transmit key(R)[%lX]: %d\n",
+						 pTable->KeyTable[i].dwGTKeyIndex, i);
 				}
 				pTable->KeyTable[i].wKeyCtl &= 0xFF0F;          // clear group key control filed
 				pTable->KeyTable[i].wKeyCtl |= (byKeyDecMode << 4);
@@ -252,17 +251,17 @@ bool KeybSetKey(
 			pKey->dwTSC47_16 = 0;
 			pKey->wTSC15_0 = 0;
 
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "KeybSetKey(R):\n");
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->bKeyValid: %d\n ", pKey->bKeyValid);
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->abyKey: ");
+			pr_debug("KeybSetKey(R):\n");
+			pr_debug("pKey->bKeyValid: %d\n ", pKey->bKeyValid);
+			pr_debug("pKey->abyKey: ");
 			for (ii = 0; ii < pKey->uKeyLength; ii++)
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%02x ", pKey->abyKey[ii]);
+				pr_debug("%02x ", pKey->abyKey[ii]);
 
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "\n");
+			pr_debug("\n");
 
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->dwTSC47_16: %lx\n ", pKey->dwTSC47_16);
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->wTSC15_0: %x\n ", pKey->wTSC15_0);
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->dwKeyIndex: %lx\n ", pKey->dwKeyIndex);
+			pr_debug("pKey->dwTSC47_16: %lx\n ", pKey->dwTSC47_16);
+			pr_debug("pKey->wTSC15_0: %x\n ", pKey->wTSC15_0);
+			pr_debug("pKey->dwKeyIndex: %lx\n ", pKey->dwKeyIndex);
 
 			return true;
 		}
@@ -284,7 +283,8 @@ bool KeybSetKey(
 			if ((dwKeyIndex & TRANSMIT_KEY) != 0)  {
 				// Group transmit key
 				pTable->KeyTable[j].dwGTKeyIndex = dwKeyIndex;
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Group transmit key(N)[%lX]: %d\n", pTable->KeyTable[j].dwGTKeyIndex, j);
+				pr_debug("Group transmit key(N)[%lX]: %d\n",
+					 pTable->KeyTable[j].dwGTKeyIndex, j);
 			}
 			pTable->KeyTable[j].wKeyCtl &= 0xFF0F;          // clear group key control filed
 			pTable->KeyTable[j].wKeyCtl |= (byKeyDecMode << 4);
@@ -315,18 +315,18 @@ bool KeybSetKey(
 		pKey->dwTSC47_16 = 0;
 		pKey->wTSC15_0 = 0;
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "KeybSetKey(N):\n");
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->bKeyValid: %d\n ", pKey->bKeyValid);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->uKeyLength: %d\n ", (int)pKey->uKeyLength);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->abyKey: ");
+		pr_debug("KeybSetKey(N):\n");
+		pr_debug("pKey->bKeyValid: %d\n ", pKey->bKeyValid);
+		pr_debug("pKey->uKeyLength: %d\n ", (int)pKey->uKeyLength);
+		pr_debug("pKey->abyKey: ");
 		for (ii = 0; ii < pKey->uKeyLength; ii++)
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%02x ", pKey->abyKey[ii]);
+			pr_debug("%02x ", pKey->abyKey[ii]);
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "\n");
+		pr_debug("\n");
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->dwTSC47_16: %lx\n ", pKey->dwTSC47_16);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->wTSC15_0: %x\n ", pKey->wTSC15_0);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->dwKeyIndex: %lx\n ", pKey->dwKeyIndex);
+		pr_debug("pKey->dwTSC47_16: %lx\n ", pKey->dwTSC47_16);
+		pr_debug("pKey->wTSC15_0: %x\n ", pKey->wTSC15_0);
+		pr_debug("pKey->dwKeyIndex: %lx\n ", pKey->dwKeyIndex);
 
 		return true;
 	}
@@ -511,48 +511,51 @@ bool KeybGetTransmitKey(
 				if (pTable->KeyTable[i].PairwiseKey.bKeyValid) {
 					*pKey = &(pTable->KeyTable[i].PairwiseKey);
 
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "KeybGetTransmitKey:");
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "PAIRWISE_KEY: KeyTable.abyBSSID: ");
+					pr_debug("KeybGetTransmitKey:");
+					pr_debug("PAIRWISE_KEY: KeyTable.abyBSSID: ");
 					for (ii = 0; ii < 6; ii++)
-						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%x ", pTable->KeyTable[i].abyBSSID[ii]);
+						pr_debug("%x ",
+							 pTable->KeyTable[i].abyBSSID[ii]);
 
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "\n");
+					pr_debug("\n");
 
 					return true;
 				} else {
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "PairwiseKey.bKeyValid == false\n");
+					pr_debug("PairwiseKey.bKeyValid == false\n");
 					return false;
 				}
 			} // End of Type == PAIRWISE
 			else {
 				if (pTable->KeyTable[i].dwGTKeyIndex == 0) {
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ERROR: dwGTKeyIndex == 0 !!!\n");
+					pr_debug("ERROR: dwGTKeyIndex == 0 !!!\n");
 					return false;
 				}
 				if (pTable->KeyTable[i].GroupKey[(pTable->KeyTable[i].dwGTKeyIndex&0x000000FF)].bKeyValid) {
 					*pKey = &(pTable->KeyTable[i].GroupKey[(pTable->KeyTable[i].dwGTKeyIndex&0x000000FF)]);
 
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "KeybGetTransmitKey:");
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "GROUP_KEY: KeyTable.abyBSSID\n");
+					pr_debug("KeybGetTransmitKey:");
+					pr_debug("GROUP_KEY: KeyTable.abyBSSID\n");
 					for (ii = 0; ii < 6; ii++)
-						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%x ", pTable->KeyTable[i].abyBSSID[ii]);
+						pr_debug("%x ",
+							 pTable->KeyTable[i].abyBSSID[ii]);
 
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "\n");
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dwGTKeyIndex: %lX\n", pTable->KeyTable[i].dwGTKeyIndex);
+					pr_debug("\n");
+					pr_debug("dwGTKeyIndex: %lX\n",
+						 pTable->KeyTable[i].dwGTKeyIndex);
 
 					return true;
 				} else {
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "GroupKey.bKeyValid == false\n");
+					pr_debug("GroupKey.bKeyValid == false\n");
 					return false;
 				}
 			} // End of Type = GROUP
 		} // BSSID match
 	}
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ERROR: NO Match BSSID !!! ");
+	pr_debug("ERROR: NO Match BSSID !!! ");
 	for (ii = 0; ii < 6; ii++)
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%02x ", *(pbyBSSID+ii));
+		pr_debug("%02x ", *(pbyBSSID+ii));
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "\n");
+	pr_debug("\n");
 	return false;
 }
 
@@ -617,7 +620,8 @@ bool KeybSetDefaultKey(
 	PSKeyItem   pKey;
 	unsigned int uKeyIdx;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enter KeybSetDefaultKey: %1x, %d\n", (int)dwKeyIndex, (int)uKeyLength);
+	pr_debug("Enter KeybSetDefaultKey: %1x, %d\n",
+		 (int)dwKeyIndex, (int)uKeyLength);
 
 	if ((dwKeyIndex & PAIRWISE_KEY) != 0) // Pairwise key
 		return false;
@@ -636,7 +640,9 @@ bool KeybSetDefaultKey(
 	if ((dwKeyIndex & TRANSMIT_KEY) != 0)  {
 		// Group transmit key
 		pTable->KeyTable[MAX_KEY_TABLE-1].dwGTKeyIndex = dwKeyIndex;
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Group transmit key(R)[%lX]: %d\n", pTable->KeyTable[MAX_KEY_TABLE-1].dwGTKeyIndex, MAX_KEY_TABLE-1);
+		pr_debug("Group transmit key(R)[%lX]: %d\n",
+			 pTable->KeyTable[MAX_KEY_TABLE-1].dwGTKeyIndex,
+			 MAX_KEY_TABLE-1);
 
 	}
 	pTable->KeyTable[MAX_KEY_TABLE-1].wKeyCtl &= 0x7F00;          // clear all key control filed
@@ -676,18 +682,18 @@ bool KeybSetDefaultKey(
 	pKey->dwTSC47_16 = 0;
 	pKey->wTSC15_0 = 0;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "KeybSetKey(R):\n");
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->bKeyValid: %d\n", pKey->bKeyValid);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->uKeyLength: %d\n", (int)pKey->uKeyLength);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->abyKey:\n");
+	pr_debug("KeybSetKey(R):\n");
+	pr_debug("pKey->bKeyValid: %d\n", pKey->bKeyValid);
+	pr_debug("pKey->uKeyLength: %d\n", (int)pKey->uKeyLength);
+	pr_debug("pKey->abyKey:\n");
 	for (ii = 0; ii < pKey->uKeyLength; ii++)
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%x", pKey->abyKey[ii]);
+		pr_debug("%x", pKey->abyKey[ii]);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "\n");
+	pr_debug("\n");
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->dwTSC47_16: %lx\n", pKey->dwTSC47_16);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->wTSC15_0: %x\n", pKey->wTSC15_0);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->dwKeyIndex: %lx\n", pKey->dwKeyIndex);
+	pr_debug("pKey->dwTSC47_16: %lx\n", pKey->dwTSC47_16);
+	pr_debug("pKey->wTSC15_0: %x\n", pKey->wTSC15_0);
+	pr_debug("pKey->dwKeyIndex: %lx\n", pKey->dwKeyIndex);
 
 	return true;
 }
@@ -724,7 +730,7 @@ bool KeybSetAllGroupKey(
 	PSKeyItem   pKey;
 	unsigned int uKeyIdx;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enter KeybSetAllGroupKey: %lX\n", dwKeyIndex);
+	pr_debug("Enter KeybSetAllGroupKey: %lX\n", dwKeyIndex);
 
 	if ((dwKeyIndex & PAIRWISE_KEY) != 0) // Pairwise key
 		return false;
@@ -739,7 +745,8 @@ bool KeybSetAllGroupKey(
 			if ((dwKeyIndex & TRANSMIT_KEY) != 0)  {
 				// Group transmit key
 				pTable->KeyTable[i].dwGTKeyIndex = dwKeyIndex;
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Group transmit key(R)[%lX]: %d\n", pTable->KeyTable[i].dwGTKeyIndex, i);
+				pr_debug("Group transmit key(R)[%lX]: %d\n",
+					 pTable->KeyTable[i].dwGTKeyIndex, i);
 
 			}
 			pTable->KeyTable[i].wKeyCtl &= 0xFF0F;          // clear group key control filed
@@ -771,14 +778,15 @@ bool KeybSetAllGroupKey(
 			pKey->dwTSC47_16 = 0;
 			pKey->wTSC15_0 = 0;
 
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "KeybSetKey(R):\n");
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->bKeyValid: %d\n ", pKey->bKeyValid);
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->uKeyLength: %d\n ", (int)pKey->uKeyLength);
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->abyKey: ");
+			pr_debug("KeybSetKey(R):\n");
+			pr_debug("pKey->bKeyValid: %d\n ", pKey->bKeyValid);
+			pr_debug("pKey->uKeyLength: %d\n ",
+				 (int)pKey->uKeyLength);
+			pr_debug("pKey->abyKey: ");
 			for (ii = 0; ii < pKey->uKeyLength; ii++)
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%02x ", pKey->abyKey[ii]);
+				pr_debug("%02x ", pKey->abyKey[ii]);
 
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "\n");
+			pr_debug("\n");
 
 		} // (pTable->KeyTable[i].bInUse == true)
 	}
diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index 9bbc873..e3b0b7f 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -73,8 +73,6 @@
 #include "mac.h"
 
 unsigned short TxRate_iwconfig;//2008-5-8 <add> by chester
-/*---------------------  Static Definitions -------------------------*/
-static int msglevel = MSG_LEVEL_INFO;
 /*---------------------  Static Classes  ----------------------------*/
 
 /*---------------------  Static Variables  --------------------------*/
@@ -837,7 +835,7 @@ bool MACbSafeRxOff(void __iomem *dwIoBase)
 	}
 	if (ww == W_MAX_TIMEOUT) {
 		DBG_PORT80(0x10);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " DBG_PORT80(0x10)\n");
+		pr_debug(" DBG_PORT80(0x10)\n");
 		return false;
 	}
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
@@ -847,7 +845,7 @@ bool MACbSafeRxOff(void __iomem *dwIoBase)
 	}
 	if (ww == W_MAX_TIMEOUT) {
 		DBG_PORT80(0x11);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " DBG_PORT80(0x11)\n");
+		pr_debug(" DBG_PORT80(0x11)\n");
 		return false;
 	}
 
@@ -861,7 +859,7 @@ bool MACbSafeRxOff(void __iomem *dwIoBase)
 	}
 	if (ww == W_MAX_TIMEOUT) {
 		DBG_PORT80(0x12);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " DBG_PORT80(0x12)\n");
+		pr_debug(" DBG_PORT80(0x12)\n");
 		return false;
 	}
 	return true;
@@ -899,7 +897,7 @@ bool MACbSafeTxOff(void __iomem *dwIoBase)
 	}
 	if (ww == W_MAX_TIMEOUT) {
 		DBG_PORT80(0x20);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " DBG_PORT80(0x20)\n");
+		pr_debug(" DBG_PORT80(0x20)\n");
 		return false;
 	}
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
@@ -909,7 +907,7 @@ bool MACbSafeTxOff(void __iomem *dwIoBase)
 	}
 	if (ww == W_MAX_TIMEOUT) {
 		DBG_PORT80(0x21);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " DBG_PORT80(0x21)\n");
+		pr_debug(" DBG_PORT80(0x21)\n");
 		return false;
 	}
 
@@ -924,7 +922,7 @@ bool MACbSafeTxOff(void __iomem *dwIoBase)
 	}
 	if (ww == W_MAX_TIMEOUT) {
 		DBG_PORT80(0x24);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " DBG_PORT80(0x24)\n");
+		pr_debug(" DBG_PORT80(0x24)\n");
 		return false;
 	}
 	return true;
@@ -949,13 +947,13 @@ bool MACbSafeStop(void __iomem *dwIoBase)
 
 	if (!MACbSafeRxOff(dwIoBase)) {
 		DBG_PORT80(0xA1);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " MACbSafeRxOff == false)\n");
+		pr_debug(" MACbSafeRxOff == false)\n");
 		MACbSafeSoftwareReset(dwIoBase);
 		return false;
 	}
 	if (!MACbSafeTxOff(dwIoBase)) {
 		DBG_PORT80(0xA2);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " MACbSafeTxOff == false)\n");
+		pr_debug(" MACbSafeTxOff == false)\n");
 		MACbSafeSoftwareReset(dwIoBase);
 		return false;
 	}
@@ -1172,7 +1170,7 @@ void MACvSetCurrAC0DescAddrEx(void __iomem *dwIoBase, unsigned long dwCurrDescAd
 	}
 	if (ww == W_MAX_TIMEOUT) {
 		DBG_PORT80(0x26);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " DBG_PORT80(0x26)\n");
+		pr_debug(" DBG_PORT80(0x26)\n");
 	}
 	VNSvOutPortD(dwIoBase + MAC_REG_AC0DMAPTR, dwCurrDescAddr);
 	if (byOrgDMACtl & DMACTL_RUN)
@@ -1295,7 +1293,7 @@ bool MACbTxDMAOff(void __iomem *dwIoBase, unsigned int idx)
 	}
 	if (ww == W_MAX_TIMEOUT) {
 		DBG_PORT80(0x29);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " DBG_PORT80(0x29)\n");
+		pr_debug(" DBG_PORT80(0x29)\n");
 		return false;
 	}
 	return true;
@@ -1319,7 +1317,7 @@ void MACvClearBusSusInd(void __iomem *dwIoBase)
 	}
 	if (ww == W_MAX_TIMEOUT) {
 		DBG_PORT80(0x33);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " DBG_PORT80(0x33)\n");
+		pr_debug(" DBG_PORT80(0x33)\n");
 	}
 }
 
@@ -1341,7 +1339,7 @@ void MACvEnableBusSusEn(void __iomem *dwIoBase)
 	}
 	if (ww == W_MAX_TIMEOUT) {
 		DBG_PORT80(0x34);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " DBG_PORT80(0x34)\n");
+		pr_debug(" DBG_PORT80(0x34)\n");
 	}
 }
 
@@ -1364,7 +1362,7 @@ bool MACbFlushSYNCFifo(void __iomem *dwIoBase)
 	}
 	if (ww == W_MAX_TIMEOUT) {
 		DBG_PORT80(0x35);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " DBG_PORT80(0x33)\n");
+		pr_debug(" DBG_PORT80(0x33)\n");
 	}
 	return true;
 }
@@ -1388,7 +1386,7 @@ bool MACbPSWakeup(void __iomem *dwIoBase)
 	}
 	if (ww == W_MAX_TIMEOUT) {
 		DBG_PORT80(0x36);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " DBG_PORT80(0x33)\n");
+		pr_debug(" DBG_PORT80(0x33)\n");
 		return false;
 	}
 	return true;
@@ -1419,7 +1417,7 @@ void MACvSetKeyEntry(void __iomem *dwIoBase, unsigned short wKeyCtl, unsigned in
 	if (byLocalID <= 1)
 		return;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "MACvSetKeyEntry\n");
+	pr_debug("MACvSetKeyEntry\n");
 	wOffset = MISCFIFO_KEYETRY0;
 	wOffset += (uEntryIdx * MISCFIFO_KEYENTRYSIZE);
 
@@ -1427,7 +1425,8 @@ void MACvSetKeyEntry(void __iomem *dwIoBase, unsigned short wKeyCtl, unsigned in
 	dwData |= wKeyCtl;
 	dwData <<= 16;
 	dwData |= MAKEWORD(*(pbyAddr+4), *(pbyAddr+5));
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "1. wOffset: %d, Data: %X, KeyCtl:%X\n", wOffset, dwData, wKeyCtl);
+	pr_debug("1. wOffset: %d, Data: %X, KeyCtl:%X\n",
+		 wOffset, dwData, wKeyCtl);
 
 	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset);
 	VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, dwData);
@@ -1442,7 +1441,7 @@ void MACvSetKeyEntry(void __iomem *dwIoBase, unsigned short wKeyCtl, unsigned in
 	dwData |= *(pbyAddr+1);
 	dwData <<= 8;
 	dwData |= *(pbyAddr+0);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "2. wOffset: %d, Data: %X\n", wOffset, dwData);
+	pr_debug("2. wOffset: %d, Data: %X\n", wOffset, dwData);
 
 	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset);
 	VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, dwData);
@@ -1452,7 +1451,8 @@ void MACvSetKeyEntry(void __iomem *dwIoBase, unsigned short wKeyCtl, unsigned in
 	wOffset += (uKeyIdx * 4);
 	for (ii = 0; ii < 4; ii++) {
 		// always push 128 bits
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "3.(%d) wOffset: %d, Data: %X\n", ii, wOffset+ii, *pdwKey);
+		pr_debug("3.(%d) wOffset: %d, Data: %X\n",
+			 ii, wOffset+ii, *pdwKey);
 		VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset+ii);
 		VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, *pdwKey++);
 		VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
@@ -1510,7 +1510,7 @@ void MACvSetDefaultKeyEntry(void __iomem *dwIoBase, unsigned int uKeyLen,
 	if (byLocalID <= 1)
 		return;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "MACvSetDefaultKeyEntry\n");
+	pr_debug("MACvSetDefaultKeyEntry\n");
 	wOffset = MISCFIFO_KEYETRY0;
 	wOffset += (10 * MISCFIFO_KEYENTRYSIZE);
 
@@ -1519,7 +1519,8 @@ void MACvSetDefaultKeyEntry(void __iomem *dwIoBase, unsigned int uKeyLen,
 	wOffset += (uKeyIdx * 4);
 	// always push 128 bits
 	for (ii = 0; ii < 3; ii++) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "(%d) wOffset: %d, Data: %lX\n", ii, wOffset+ii, *pdwKey);
+		pr_debug("(%d) wOffset: %d, Data: %lX\n",
+			 ii, wOffset+ii, *pdwKey);
 		VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset+ii);
 		VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, *pdwKey++);
 		VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
@@ -1531,7 +1532,7 @@ void MACvSetDefaultKeyEntry(void __iomem *dwIoBase, unsigned int uKeyLen,
 	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset+3);
 	VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, dwData);
 	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "End. wOffset: %d, Data: %lX\n", wOffset+3, dwData);
+	pr_debug("End. wOffset: %d, Data: %lX\n", wOffset+3, dwData);
 }
 
 /*
@@ -1564,7 +1565,7 @@ void MACvSetDefaultKeyEntry(void __iomem *dwIoBase, unsigned int uKeyLen,
   VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset);
   VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, dwData);
   VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
-  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "MACvEnableDefaultKey: wOffset: %d, Data: %lX\n", wOffset, dwData);
+  pr_debug("MACvEnableDefaultKey: wOffset: %d, Data: %lX\n", wOffset, dwData);
 
   }
 */
@@ -1595,7 +1596,8 @@ void MACvDisableDefaultKey(void __iomem *dwIoBase)
 	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset);
 	VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, dwData);
 	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "MACvDisableDefaultKey: wOffset: %d, Data: %lX\n", wOffset, dwData);
+	pr_debug("MACvDisableDefaultKey: wOffset: %d, Data: %lX\n",
+		 wOffset, dwData);
 }
 
 /*
@@ -1622,7 +1624,7 @@ void MACvSetDefaultTKIPKeyEntry(void __iomem *dwIoBase, unsigned int uKeyLen,
 	if (byLocalID <= 1)
 		return;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "MACvSetDefaultTKIPKeyEntry\n");
+	pr_debug("MACvSetDefaultTKIPKeyEntry\n");
 	wOffset = MISCFIFO_KEYETRY0;
 	// Kyle test : change offset from 10 -> 0
 	wOffset += (10 * MISCFIFO_KEYENTRYSIZE);
@@ -1640,10 +1642,12 @@ void MACvSetDefaultTKIPKeyEntry(void __iomem *dwIoBase, unsigned int uKeyLen,
 	wOffset++;
 
 	wOffset += (uKeyIdx * 4);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "1. wOffset: %d, Data: %lX, idx:%d\n", wOffset, *pdwKey, uKeyIdx);
+	pr_debug("1. wOffset: %d, Data: %lX, idx:%d\n",
+		 wOffset, *pdwKey, uKeyIdx);
 	// always push 128 bits
 	for (ii = 0; ii < 4; ii++) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "2.(%d) wOffset: %d, Data: %lX\n", ii, wOffset+ii, *pdwKey);
+		pr_debug("2.(%d) wOffset: %d, Data: %lX\n",
+			 ii, wOffset+ii, *pdwKey);
 		VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset+ii);
 		VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, *pdwKey++);
 		VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
@@ -1673,7 +1677,7 @@ void MACvSetDefaultKeyCtl(void __iomem *dwIoBase, unsigned short wKeyCtl, unsign
 	if (byLocalID <= 1)
 		return;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "MACvSetKeyEntry\n");
+	pr_debug("MACvSetKeyEntry\n");
 	wOffset = MISCFIFO_KEYETRY0;
 	wOffset += (uEntryIdx * MISCFIFO_KEYENTRYSIZE);
 
@@ -1681,7 +1685,8 @@ void MACvSetDefaultKeyCtl(void __iomem *dwIoBase, unsigned short wKeyCtl, unsign
 	dwData |= wKeyCtl;
 	dwData <<= 16;
 	dwData |= 0xffff;
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "1. wOffset: %d, Data: %lX, KeyCtl:%X\n", wOffset, dwData, wKeyCtl);
+	pr_debug("1. wOffset: %d, Data: %lX, KeyCtl:%X\n",
+		 wOffset, dwData, wKeyCtl);
 
 	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset);
 	VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, dwData);
diff --git a/drivers/staging/vt6655/mib.c b/drivers/staging/vt6655/mib.c
index 3689597..111c018 100644
--- a/drivers/staging/vt6655/mib.c
+++ b/drivers/staging/vt6655/mib.c
@@ -44,8 +44,6 @@
 #include "wctl.h"
 #include "baseband.h"
 
-/*---------------------  Static Definitions -------------------------*/
-static int msglevel = MSG_LEVEL_INFO;
 /*---------------------  Static Classes  ----------------------------*/
 
 /*---------------------  Static Variables  --------------------------*/
@@ -190,75 +188,101 @@ void STAvUpdateRDStatCounter(PSStatCounter pStatistic,
 		if (byRSR & RSR_CRCOK)
 			pStatistic->CustomStat.ullRsr11MCRCOk++;
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "11M: ALL[%d], OK[%d]:[%02x]\n", (int)pStatistic->CustomStat.ullRsr11M, (int)pStatistic->CustomStat.ullRsr11MCRCOk, byRSR);
+		pr_debug("11M: ALL[%d], OK[%d]:[%02x]\n",
+			 (int)pStatistic->CustomStat.ullRsr11M,
+			 (int)pStatistic->CustomStat.ullRsr11MCRCOk, byRSR);
 	} else if (byRxRate == 11) {
 		pStatistic->CustomStat.ullRsr5M++;
 		if (byRSR & RSR_CRCOK)
 			pStatistic->CustomStat.ullRsr5MCRCOk++;
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " 5M: ALL[%d], OK[%d]:[%02x]\n", (int)pStatistic->CustomStat.ullRsr5M, (int)pStatistic->CustomStat.ullRsr5MCRCOk, byRSR);
+		pr_debug(" 5M: ALL[%d], OK[%d]:[%02x]\n",
+			 (int)pStatistic->CustomStat.ullRsr5M,
+			 (int)pStatistic->CustomStat.ullRsr5MCRCOk, byRSR);
 	} else if (byRxRate == 4) {
 		pStatistic->CustomStat.ullRsr2M++;
 		if (byRSR & RSR_CRCOK)
 			pStatistic->CustomStat.ullRsr2MCRCOk++;
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " 2M: ALL[%d], OK[%d]:[%02x]\n", (int)pStatistic->CustomStat.ullRsr2M, (int)pStatistic->CustomStat.ullRsr2MCRCOk, byRSR);
+		pr_debug(" 2M: ALL[%d], OK[%d]:[%02x]\n",
+			 (int)pStatistic->CustomStat.ullRsr2M,
+			 (int)pStatistic->CustomStat.ullRsr2MCRCOk, byRSR);
 	} else if (byRxRate == 2) {
 		pStatistic->CustomStat.ullRsr1M++;
 		if (byRSR & RSR_CRCOK)
 			pStatistic->CustomStat.ullRsr1MCRCOk++;
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " 1M: ALL[%d], OK[%d]:[%02x]\n", (int)pStatistic->CustomStat.ullRsr1M, (int)pStatistic->CustomStat.ullRsr1MCRCOk, byRSR);
+		pr_debug(" 1M: ALL[%d], OK[%d]:[%02x]\n",
+			 (int)pStatistic->CustomStat.ullRsr1M,
+			 (int)pStatistic->CustomStat.ullRsr1MCRCOk, byRSR);
 	} else if (byRxRate == 12) {
 		pStatistic->CustomStat.ullRsr6M++;
 		if (byRSR & RSR_CRCOK)
 			pStatistic->CustomStat.ullRsr6MCRCOk++;
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " 6M: ALL[%d], OK[%d]\n", (int)pStatistic->CustomStat.ullRsr6M, (int)pStatistic->CustomStat.ullRsr6MCRCOk);
+		pr_debug(" 6M: ALL[%d], OK[%d]\n",
+			 (int)pStatistic->CustomStat.ullRsr6M,
+			 (int)pStatistic->CustomStat.ullRsr6MCRCOk);
 	} else if (byRxRate == 18) {
 		pStatistic->CustomStat.ullRsr9M++;
 		if (byRSR & RSR_CRCOK)
 			pStatistic->CustomStat.ullRsr9MCRCOk++;
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " 9M: ALL[%d], OK[%d]\n", (int)pStatistic->CustomStat.ullRsr9M, (int)pStatistic->CustomStat.ullRsr9MCRCOk);
+		pr_debug(" 9M: ALL[%d], OK[%d]\n",
+			 (int)pStatistic->CustomStat.ullRsr9M,
+			 (int)pStatistic->CustomStat.ullRsr9MCRCOk);
 	} else if (byRxRate == 24) {
 		pStatistic->CustomStat.ullRsr12M++;
 		if (byRSR & RSR_CRCOK)
 			pStatistic->CustomStat.ullRsr12MCRCOk++;
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "12M: ALL[%d], OK[%d]\n", (int)pStatistic->CustomStat.ullRsr12M, (int)pStatistic->CustomStat.ullRsr12MCRCOk);
+		pr_debug("12M: ALL[%d], OK[%d]\n",
+			 (int)pStatistic->CustomStat.ullRsr12M,
+			 (int)pStatistic->CustomStat.ullRsr12MCRCOk);
 	} else if (byRxRate == 36) {
 		pStatistic->CustomStat.ullRsr18M++;
 		if (byRSR & RSR_CRCOK)
 			pStatistic->CustomStat.ullRsr18MCRCOk++;
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "18M: ALL[%d], OK[%d]\n", (int)pStatistic->CustomStat.ullRsr18M, (int)pStatistic->CustomStat.ullRsr18MCRCOk);
+		pr_debug("18M: ALL[%d], OK[%d]\n",
+			 (int)pStatistic->CustomStat.ullRsr18M,
+			 (int)pStatistic->CustomStat.ullRsr18MCRCOk);
 	} else if (byRxRate == 48) {
 		pStatistic->CustomStat.ullRsr24M++;
 		if (byRSR & RSR_CRCOK)
 			pStatistic->CustomStat.ullRsr24MCRCOk++;
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "24M: ALL[%d], OK[%d]\n", (int)pStatistic->CustomStat.ullRsr24M, (int)pStatistic->CustomStat.ullRsr24MCRCOk);
+		pr_debug("24M: ALL[%d], OK[%d]\n",
+			 (int)pStatistic->CustomStat.ullRsr24M,
+			 (int)pStatistic->CustomStat.ullRsr24MCRCOk);
 	} else if (byRxRate == 72) {
 		pStatistic->CustomStat.ullRsr36M++;
 		if (byRSR & RSR_CRCOK)
 			pStatistic->CustomStat.ullRsr36MCRCOk++;
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "36M: ALL[%d], OK[%d]\n", (int)pStatistic->CustomStat.ullRsr36M, (int)pStatistic->CustomStat.ullRsr36MCRCOk);
+		pr_debug("36M: ALL[%d], OK[%d]\n",
+			 (int)pStatistic->CustomStat.ullRsr36M,
+			 (int)pStatistic->CustomStat.ullRsr36MCRCOk);
 	} else if (byRxRate == 96) {
 		pStatistic->CustomStat.ullRsr48M++;
 		if (byRSR & RSR_CRCOK)
 			pStatistic->CustomStat.ullRsr48MCRCOk++;
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "48M: ALL[%d], OK[%d]\n", (int)pStatistic->CustomStat.ullRsr48M, (int)pStatistic->CustomStat.ullRsr48MCRCOk);
+		pr_debug("48M: ALL[%d], OK[%d]\n",
+			 (int)pStatistic->CustomStat.ullRsr48M,
+			 (int)pStatistic->CustomStat.ullRsr48MCRCOk);
 	} else if (byRxRate == 108) {
 		pStatistic->CustomStat.ullRsr54M++;
 		if (byRSR & RSR_CRCOK)
 			pStatistic->CustomStat.ullRsr54MCRCOk++;
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "54M: ALL[%d], OK[%d]\n", (int)pStatistic->CustomStat.ullRsr54M, (int)pStatistic->CustomStat.ullRsr54MCRCOk);
+		pr_debug("54M: ALL[%d], OK[%d]\n",
+			 (int)pStatistic->CustomStat.ullRsr54M,
+			 (int)pStatistic->CustomStat.ullRsr54MCRCOk);
 	} else {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Unknown: Total[%d], CRCOK[%d]\n", (int)pStatistic->dwRsrRxPacket+1, (int)pStatistic->dwRsrCRCOk);
+		pr_debug("Unknown: Total[%d], CRCOK[%d]\n",
+			 (int)pStatistic->dwRsrRxPacket+1,
+			 (int)pStatistic->dwRsrCRCOk);
 	}
 
 	if (byRSR & RSR_BSSIDOK)
diff --git a/drivers/staging/vt6655/power.c b/drivers/staging/vt6655/power.c
index de23f2d..93681b3 100644
--- a/drivers/staging/vt6655/power.c
+++ b/drivers/staging/vt6655/power.c
@@ -50,8 +50,6 @@
 
 /*---------------------  Static Classes  ----------------------------*/
 
-/*---------------------  Static Variables  --------------------------*/
-static int msglevel = MSG_LEVEL_INFO;
 /*---------------------  Static Functions  --------------------------*/
 
 /*---------------------  Export Variables  --------------------------*/
@@ -113,7 +111,7 @@ PSvEnablePowerSaving(
 		PSbSendNullPacket(pDevice);
 
 	pDevice->bPWBitOn = true;
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "PS:Power Saving Mode Enable...\n");
+	pr_debug("PS:Power Saving Mode Enable...\n");
 }
 
 /*+
@@ -210,7 +208,7 @@ PSbConsiderPowerDown(
 
 	// no Tx, no Rx isr, now go to Doze
 	MACvRegBitsOn(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_GO2DOZE);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Go to Doze ZZZZZZZZZZZZZZZ\n");
+	pr_debug("Go to Doze ZZZZZZZZZZZZZZZ\n");
 	return true;
 }
 
@@ -249,7 +247,7 @@ PSvSendPSPOLL(
 	pTxPacket->cbPayloadLen = 0;
 	// send the frame
 	if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING)
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Send PS-Poll packet failed..\n");
+		pr_debug("Send PS-Poll packet failed..\n");
 }
 
 /*+
@@ -314,7 +312,7 @@ PSbSendNullPacket(
 	pTxPacket->cbPayloadLen = 0;
 	// send the frame
 	if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Send Null Packet failed !\n");
+		pr_debug("Send Null Packet failed !\n");
 		return false;
 	}
 
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index b625358..869555a 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -68,8 +68,6 @@
 /*---------------------  Static Classes  ----------------------------*/
 
 /*---------------------  Static Variables  --------------------------*/
-static int msglevel = MSG_LEVEL_INFO;
-
 #define	PLICE_DEBUG
 
 /*---------------------  Static Functions  --------------------------*/
@@ -248,7 +246,7 @@ s_vFillTxKey(
 		*(pbyIVHead+3) = (unsigned char)(((byKeyIndex << 6) & 0xc0) | 0x20); // 0x20 is ExtIV
 		// Append IV&ExtIV after Mac Header
 		*pdwExtIV = cpu_to_le32(pTransmitKey->dwTSC47_16);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "vFillTxKey()---- pdwExtIV: %lx\n", *pdwExtIV);
+		pr_debug("vFillTxKey()---- pdwExtIV: %lx\n", *pdwExtIV);
 
 	} else if (pTransmitKey->byCipherSuite == KEY_CTL_CCMP) {
 		pTransmitKey->wTSC15_0++;
@@ -1422,7 +1420,7 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 		MIC_vAppend((unsigned char *)&(psEthHeader->abyDstAddr[0]), 12);
 		dwMIC_Priority = 0;
 		MIC_vAppend((unsigned char *)&dwMIC_Priority, 4);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "MIC KEY: %X, %X\n", dwMICKey0, dwMICKey1);
+		pr_debug("MIC KEY: %X, %X\n", dwMICKey0, dwMICKey1);
 	}
 
 ///////////////////////////////////////////////////////////////////
@@ -1452,7 +1450,7 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 				//=========================
 				//    Start Fragmentation
 				//=========================
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Start Fragmentation...\n");
+				pr_debug("Start Fragmentation...\n");
 				wFragType = FRAGCTL_STAFRAG;
 
 				//Fill FIFO,RrvTime,RTS,and CTS
@@ -1505,7 +1503,8 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 				uTotalCopyLength += cbFragPayloadSize - cb802_1_H_len;
 
 				if ((bNeedEncrypt == true) && (pTransmitKey != NULL) && (pTransmitKey->byCipherSuite == KEY_CTL_TKIP)) {
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Start MIC: %d\n", cbFragPayloadSize);
+					pr_debug("Start MIC: %d\n",
+						 cbFragPayloadSize);
 					MIC_vAppend((pbyBuffer + uLength - cb802_1_H_len), cbFragPayloadSize);
 
 				}
@@ -1540,7 +1539,7 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 				//=========================
 				//    Last Fragmentation
 				//=========================
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Last Fragmentation...\n");
+				pr_debug("Last Fragmentation...\n");
 
 				wFragType = FRAGCTL_ENDFRAG;
 
@@ -1590,8 +1589,10 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 
 				}
 				if ((bNeedEncrypt == true) && (pTransmitKey != NULL) && (pTransmitKey->byCipherSuite == KEY_CTL_TKIP)) {
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "LAST: uMICFragLen:%d, cbLastFragPayloadSize:%d, uTmpLen:%d\n",
-						uMICFragLen, cbLastFragPayloadSize, uTmpLen);
+					pr_debug("LAST: uMICFragLen:%d, cbLastFragPayloadSize:%d, uTmpLen:%d\n",
+						 uMICFragLen,
+						 cbLastFragPayloadSize,
+						 uTmpLen);
 
 					if (bMIC2Frag == false) {
 						if (uTmpLen != 0)
@@ -1599,22 +1600,23 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 						pdwMIC_L = (u32 *)(pbyBuffer + uLength + uTmpLen);
 						pdwMIC_R = (u32 *)(pbyBuffer + uLength + uTmpLen + 4);
 						MIC_vGetMIC(pdwMIC_L, pdwMIC_R);
-						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Last MIC:%X, %X\n", *pdwMIC_L, *pdwMIC_R);
+						pr_debug("Last MIC:%X, %X\n",
+							 *pdwMIC_L, *pdwMIC_R);
 					} else {
 						if (uMICFragLen >= 4) {
 							memcpy((pbyBuffer + uLength), ((unsigned char *)&dwSafeMIC_R + (uMICFragLen - 4)),
 							       (cbMIClen - uMICFragLen));
-							DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "LAST: uMICFragLen >= 4: %X, %d\n",
-								*(unsigned char *)((unsigned char *)&dwSafeMIC_R + (uMICFragLen - 4)),
-								(cbMIClen - uMICFragLen));
+							pr_debug("LAST: uMICFragLen >= 4: %X, %d\n",
+								 *(unsigned char *)((unsigned char *)&dwSafeMIC_R + (uMICFragLen - 4)),
+								 (cbMIClen - uMICFragLen));
 
 						} else {
 							memcpy((pbyBuffer + uLength), ((unsigned char *)&dwSafeMIC_L + uMICFragLen),
 							       (4 - uMICFragLen));
 							memcpy((pbyBuffer + uLength + (4 - uMICFragLen)), &dwSafeMIC_R, 4);
-							DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "LAST: uMICFragLen < 4: %X, %d\n",
-								*(unsigned char *)((unsigned char *)&dwSafeMIC_R + uMICFragLen - 4),
-								(cbMIClen - uMICFragLen));
+							pr_debug("LAST: uMICFragLen < 4: %X, %d\n",
+								 *(unsigned char *)((unsigned char *)&dwSafeMIC_R + uMICFragLen - 4),
+								 (cbMIClen - uMICFragLen));
 						}
 					}
 					MIC_vUnInit();
@@ -1655,7 +1657,7 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 				//=========================
 				//    Middle Fragmentation
 				//=========================
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Middle Fragmentation...\n");
+				pr_debug("Middle Fragmentation...\n");
 
 				wFragType = FRAGCTL_MIDFRAG;
 
@@ -1715,12 +1717,17 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 						dwSafeMIC_L = *pdwMIC_L;
 						dwSafeMIC_R = *pdwMIC_R;
 
-						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "MIDDLE: uMICFragLen:%d, cbFragPayloadSize:%d, uTmpLen:%d\n",
-							uMICFragLen, cbFragPayloadSize, uTmpLen);
-						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Fill MIC in Middle frag [%d]\n", uMICFragLen);
-						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Get MIC:%X, %X\n", *pdwMIC_L, *pdwMIC_R);
+						pr_debug("MIDDLE: uMICFragLen:%d, cbFragPayloadSize:%d, uTmpLen:%d\n",
+							 uMICFragLen,
+							 cbFragPayloadSize,
+							 uTmpLen);
+						pr_debug("Fill MIC in Middle frag [%d]\n",
+							 uMICFragLen);
+						pr_debug("Get MIC:%X, %X\n",
+							 *pdwMIC_L, *pdwMIC_R);
 					}
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Middle frag len: %d\n", uTmpLen);
+					pr_debug("Middle frag len: %d\n",
+						 uTmpLen);
 
 				} else {
 					ASSERT(uTmpLen == (cbFragPayloadSize));
@@ -1814,7 +1821,8 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 );
 
 		if ((bNeedEncrypt == true) && (pTransmitKey != NULL) && (pTransmitKey->byCipherSuite == KEY_CTL_TKIP)) {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Length:%d, %d\n", cbFrameBodySize - cb802_1_H_len, uLength);
+			pr_debug("Length:%d, %d\n",
+				 cbFrameBodySize - cb802_1_H_len, uLength);
 
 			MIC_vAppend((pbyBuffer + uLength - cb802_1_H_len), cbFrameBodySize);
 
@@ -1830,9 +1838,10 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 				pDevice->bTxMICFail = false;
 			}
 
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "uLength: %d, %d\n", uLength, cbFrameBodySize);
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "cbReqCount:%d, %d, %d, %d\n", cbReqCount, cbHeaderLength, uPadding, cbIVlen);
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "MIC:%x, %x\n", *pdwMIC_L, *pdwMIC_R);
+			pr_debug("uLength: %d, %d\n", uLength, cbFrameBodySize);
+			pr_debug("cbReqCount:%d, %d, %d, %d\n",
+				 cbReqCount, cbHeaderLength, uPadding, cbIVlen);
+			pr_debug("MIC:%x, %x\n", *pdwMIC_L, *pdwMIC_R);
 
 		}
 
@@ -2258,11 +2267,11 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice, PSTxMgmtPacket pPacket)
 				if (KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, PAIRWISE_KEY, &pTransmitKey) == false) {
 					// get group key
 					if (KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, GROUP_KEY, &pTransmitKey) == true) {
-						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Get GTK.\n");
+						pr_debug("Get GTK\n");
 						break;
 					}
 				} else {
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Get PTK.\n");
+					pr_debug("Get PTK\n");
 					break;
 				}
 			}
@@ -2270,9 +2279,10 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice, PSTxMgmtPacket pPacket)
 			pbyBSSID = pDevice->abyBroadcastAddr;
 			if (KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, GROUP_KEY, &pTransmitKey) == false) {
 				pTransmitKey = NULL;
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "KEY is NULL. OP Mode[%d]\n", pDevice->eOPMode);
+				pr_debug("KEY is NULL. OP Mode[%d]\n",
+					 pDevice->eOPMode);
 			} else {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Get GTK.\n");
+				pr_debug("Get GTK\n");
 			}
 		} while (false);
 		//Fill TXKEY
@@ -2327,7 +2337,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice, PSTxMgmtPacket pPacket)
 	pDevice->iTDUsed[TYPE_TXDMA0]++;
 
 	if (AVAIL_TD(pDevice, TYPE_TXDMA0) <= 1)
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " available td0 <= 1\n");
+		pr_debug(" available td0 <= 1\n");
 
 	pDevice->apCurrTD[TYPE_TXDMA0] = pFrstTD->next;
 
@@ -2579,7 +2589,8 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb,
 		}
 	}
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "vDMA0_tx_80211: p80211Header->sA3.wFrameCtl = %x\n", p80211Header->sA3.wFrameCtl);
+	pr_debug("vDMA0_tx_80211: p80211Header->sA3.wFrameCtl = %x\n",
+		 p80211Header->sA3.wFrameCtl);
 
 	//Set packet type
 	if (byPktType == PK_TYPE_11A) {//0000 0000 0000 0000
@@ -2766,7 +2777,8 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb,
 			MIC_vAppend((unsigned char *)&(sEthHeader.abyDstAddr[0]), 12);
 			dwMIC_Priority = 0;
 			MIC_vAppend((unsigned char *)&dwMIC_Priority, 4);
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "DMA0_tx_8021:MIC KEY: %X, %X\n", dwMICKey0, dwMICKey1);
+			pr_debug("DMA0_tx_8021:MIC KEY: %X, %X\n",
+				 dwMICKey0, dwMICKey1);
 
 			uLength = cbHeaderSize + cbMacHdLen + uPadding + cbIVlen;
 
@@ -2784,9 +2796,10 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb,
 				pDevice->bTxMICFail = false;
 			}
 
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "uLength: %d, %d\n", uLength, cbFrameBodySize);
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "cbReqCount:%d, %d, %d, %d\n", cbReqCount, cbHeaderSize, uPadding, cbIVlen);
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "MIC:%x, %x\n", *pdwMIC_L, *pdwMIC_R);
+			pr_debug("uLength: %d, %d\n", uLength, cbFrameBodySize);
+			pr_debug("cbReqCount:%d, %d, %d, %d\n",
+				 cbReqCount, cbHeaderSize, uPadding, cbIVlen);
+			pr_debug("MIC:%x, %x\n", *pdwMIC_L, *pdwMIC_R);
 
 		}
 
@@ -2844,7 +2857,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb,
 	pDevice->iTDUsed[TYPE_TXDMA0]++;
 
 	if (AVAIL_TD(pDevice, TYPE_TXDMA0) <= 1)
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " available td0 <= 1\n");
+		pr_debug(" available td0 <= 1\n");
 
 	pDevice->apCurrTD[TYPE_TXDMA0] = pFrstTD->next;
 
diff --git a/drivers/staging/vt6655/wcmd.c b/drivers/staging/vt6655/wcmd.c
index 0045f7f..7565073 100644
--- a/drivers/staging/vt6655/wcmd.c
+++ b/drivers/staging/vt6655/wcmd.c
@@ -58,8 +58,6 @@
 
 /*---------------------  Static Classes  ----------------------------*/
 
-/*---------------------  Static Variables  --------------------------*/
-static int msglevel = MSG_LEVEL_INFO;
 /*---------------------  Static Functions  --------------------------*/
 
 static
@@ -216,9 +214,9 @@ s_vProbeChannel(
 	if (pTxPacket != NULL) {
 		for (ii = 0; ii < 2; ii++) {
 			if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING)
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Probe request sending fail..\n");
+				pr_debug("Probe request sending fail..\n");
 			else
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Probe request is sending..\n");
+				pr_debug("Probe request is sending..\n");
 		}
 	}
 }
@@ -335,7 +333,7 @@ vCommandTimer(
 			return;
 		}
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "eCommandState= WLAN_CMD_SCAN_START\n");
+		pr_debug("eCommandState= WLAN_CMD_SCAN_START\n");
 		pItemSSID = (PWLAN_IE_SSID)pMgmt->abyScanSSID;
 		// wait all Data TD complete
 		if (pDevice->iTDUsed[TYPE_AC0DMA] != 0) {
@@ -355,7 +353,8 @@ vCommandTimer(
 			// Set Baseband's sensitivity back.
 			// Set channel back
 			set_channel(pMgmt->pAdapter, pMgmt->uCurrChannel);
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Scanning, set back to channel: [%d]\n", pMgmt->uCurrChannel);
+			pr_debug("Scanning, set back to channel: [%d]\n",
+				 pMgmt->uCurrChannel);
 			if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA)
 				CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, OP_MODE_ADHOC);
 			else
@@ -367,7 +366,8 @@ vCommandTimer(
 		} else {
 //2008-8-4 <add> by chester
 			if (!is_channel_valid(pMgmt->uScanChannel)) {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Invalid channel pMgmt->uScanChannel = %d\n", pMgmt->uScanChannel);
+				pr_debug("Invalid channel pMgmt->uScanChannel = %d\n",
+					 pMgmt->uScanChannel);
 				s_bCommandComplete(pDevice);
 				spin_unlock_irq(&pDevice->lock);
 				return;
@@ -387,9 +387,11 @@ vCommandTimer(
 			vAdHocBeaconStop(pDevice);
 
 			if (set_channel(pMgmt->pAdapter, pMgmt->uScanChannel))
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "SCAN Channel: %d\n", pMgmt->uScanChannel);
+				pr_debug("SCAN Channel: %d\n",
+					 pMgmt->uScanChannel);
 			else
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "SET SCAN Channel Fail: %d\n", pMgmt->uScanChannel);
+				pr_debug("SET SCAN Channel Fail: %d\n",
+					 pMgmt->uScanChannel);
 
 			CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, OP_MODE_UNKNOWN);
 			pMgmt->uScanChannel++;
@@ -422,7 +424,8 @@ vCommandTimer(
 		// Set Baseband's sensitivity back.
 		// Set channel back
 		set_channel(pMgmt->pAdapter, pMgmt->uCurrChannel);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Scanning, set back to channel: [%d]\n", pMgmt->uCurrChannel);
+		pr_debug("Scanning, set back to channel: [%d]\n",
+			 pMgmt->uCurrChannel);
 		if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA)
 			CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, OP_MODE_ADHOC);
 		else
@@ -451,7 +454,7 @@ vCommandTimer(
 			spin_unlock_irq(&pDevice->lock);
 			return;
 		} else {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Send Disassociation Packet..\n");
+			pr_debug("Send Disassociation Packet..\n");
 			// reason = 8 : disassoc because sta has left
 			vMgrDisassocBeginSta((void *)pDevice, pMgmt, pMgmt->abyCurrBSSID, (8), &Status);
 			pDevice->bLinkPass = false;
@@ -470,7 +473,7 @@ vCommandTimer(
 			spin_unlock_irq(&pDevice->lock);
 			return;
 		}
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " CARDbRadioPowerOff\n");
+		pr_debug(" CARDbRadioPowerOff\n");
 		//2008-09-02  <mark>	by chester
 		s_bCommandComplete(pDevice);
 		break;
@@ -496,15 +499,16 @@ vCommandTimer(
 		pr_debug("chester-abyDesireSSID=%s\n", ((PWLAN_IE_SSID)pMgmt->abyDesireSSID)->abySSID);
 		pItemSSID = (PWLAN_IE_SSID)pMgmt->abyDesireSSID;
 		pItemSSIDCurr = (PWLAN_IE_SSID)pMgmt->abyCurrSSID;
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " cmd: desire ssid = %s\n", pItemSSID->abySSID);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " cmd: curr ssid = %s\n", pItemSSIDCurr->abySSID);
+		pr_debug(" cmd: desire ssid = %s\n", pItemSSID->abySSID);
+		pr_debug(" cmd: curr ssid = %s\n", pItemSSIDCurr->abySSID);
 
 		if (pMgmt->eCurrState == WMAC_STATE_ASSOC) {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " Cmd pMgmt->eCurrState == WMAC_STATE_ASSOC\n");
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " pItemSSID->len =%d\n", pItemSSID->len);
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " pItemSSIDCurr->len = %d\n", pItemSSIDCurr->len);
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " desire ssid = %s\n", pItemSSID->abySSID);
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " curr ssid = %s\n", pItemSSIDCurr->abySSID);
+			pr_debug(" Cmd pMgmt->eCurrState == WMAC_STATE_ASSOC\n");
+			pr_debug(" pItemSSID->len =%d\n", pItemSSID->len);
+			pr_debug(" pItemSSIDCurr->len = %d\n",
+				 pItemSSIDCurr->len);
+			pr_debug(" desire ssid = %s\n", pItemSSID->abySSID);
+			pr_debug(" curr ssid = %s\n", pItemSSIDCurr->abySSID);
 		}
 
 		if ((pMgmt->eCurrState == WMAC_STATE_ASSOC) ||
@@ -541,7 +545,7 @@ vCommandTimer(
 				pDevice->eCommandState = WLAN_AUTHENTICATE_WAIT;
 				vCommandTimerWait((void *)pDevice, AUTHENTICATE_TIMEOUT);
 				spin_unlock_irq(&pDevice->lock);
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " Set eCommandState = WLAN_AUTHENTICATE_WAIT\n");
+				pr_debug(" Set eCommandState = WLAN_AUTHENTICATE_WAIT\n");
 				return;
 			}
 		}
@@ -560,7 +564,7 @@ vCommandTimer(
 				// start own IBSS
 				vMgrCreateOwnIBSS((void *)pDevice, &Status);
 				if (Status != CMD_STATUS_SUCCESS)
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " WLAN_CMD_IBSS_CREATE fail !\n");
+					pr_debug(" WLAN_CMD_IBSS_CREATE fail !\n");
 
 				BSSvAddMulticastNode(pDevice);
 			}
@@ -572,7 +576,7 @@ vCommandTimer(
 				// start own IBSS
 				vMgrCreateOwnIBSS((void *)pDevice, &Status);
 				if (Status != CMD_STATUS_SUCCESS)
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " WLAN_CMD_IBSS_CREATE fail !\n");
+					pr_debug(" WLAN_CMD_IBSS_CREATE fail !\n");
 
 				BSSvAddMulticastNode(pDevice);
 				if (netif_queue_stopped(pDevice->dev))
@@ -580,7 +584,7 @@ vCommandTimer(
 
 				pDevice->bLinkPass = true;
 			} else {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Disconnect SSID none\n");
+				pr_debug("Disconnect SSID none\n");
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 				{
 					union iwreq_data  wrqu;
@@ -598,15 +602,15 @@ vCommandTimer(
 		break;
 
 	case WLAN_AUTHENTICATE_WAIT:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "eCommandState == WLAN_AUTHENTICATE_WAIT\n");
+		pr_debug("eCommandState == WLAN_AUTHENTICATE_WAIT\n");
 		if (pMgmt->eCurrState == WMAC_STATE_AUTH) {
 			// Call mgr to begin the association
 			pDevice->byLinkWaitCount = 0;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "eCurrState == WMAC_STATE_AUTH\n");
+			pr_debug("eCurrState == WMAC_STATE_AUTH\n");
 			vMgrAssocBeginSta((void *)pDevice, pMgmt, &Status);
 			if (Status == CMD_STATUS_SUCCESS) {
 				pDevice->byLinkWaitCount = 0;
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "eCommandState = WLAN_ASSOCIATE_WAIT\n");
+				pr_debug("eCommandState = WLAN_ASSOCIATE_WAIT\n");
 				pDevice->eCommandState = WLAN_ASSOCIATE_WAIT;
 				vCommandTimerWait((void *)pDevice, ASSOCIATE_TIMEOUT);
 				spin_unlock_irq(&pDevice->lock);
@@ -629,7 +633,7 @@ vCommandTimer(
 
 	case WLAN_ASSOCIATE_WAIT:
 		if (pMgmt->eCurrState == WMAC_STATE_ASSOC) {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "eCurrState == WMAC_STATE_ASSOC\n");
+			pr_debug("eCurrState == WMAC_STATE_ASSOC\n");
 			if (pDevice->ePSMode != WMAC_POWER_CAM)
 				PSvEnablePowerSaving((void *)pDevice, pMgmt->wListenInterval);
 
@@ -675,7 +679,7 @@ vCommandTimer(
 		break;
 
 	case WLAN_CMD_AP_MODE_START:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "eCommandState == WLAN_CMD_AP_MODE_START\n");
+		pr_debug("eCommandState == WLAN_CMD_AP_MODE_START\n");
 
 		if (pMgmt->eConfigMode == WMAC_CONFIG_AP) {
 			del_timer(&pMgmt->sTimerSecondCallback);
@@ -692,12 +696,12 @@ vCommandTimer(
 
 			vMgrCreateOwnIBSS((void *)pDevice, &Status);
 			if (Status != CMD_STATUS_SUCCESS)
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " vMgrCreateOwnIBSS fail !\n");
+				pr_debug(" vMgrCreateOwnIBSS fail !\n");
 
 			// alway turn off unicast bit
 			MACvRegBitsOff(pDevice->PortOffset, MAC_REG_RCR, RCR_UNICAST);
 			pDevice->byRxMode &= ~RCR_UNICAST;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wcmd: rx_mode = %x\n", pDevice->byRxMode);
+			pr_debug("wcmd: rx_mode = %x\n", pDevice->byRxMode);
 			BSSvAddMulticastNode(pDevice);
 			if (netif_queue_stopped(pDevice->dev))
 				netif_wake_queue(pDevice->dev);
@@ -719,7 +723,7 @@ vCommandTimer(
 					pDevice->bMoreData = true;
 				}
 				if (!device_dma0_xmit(pDevice, skb, 0))
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Multicast ps tx fail\n");
+					pr_debug("Multicast ps tx fail\n");
 
 				pMgmt->sNodeDBTable[0].wEnQueueCnt--;
 			}
@@ -729,8 +733,9 @@ vCommandTimer(
 		for (ii = 1; ii < (MAX_NODE_NUM + 1); ii++) {
 			if (pMgmt->sNodeDBTable[ii].bActive &&
 			    pMgmt->sNodeDBTable[ii].bRxPSPoll) {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Index=%d Enqueu Cnt= %d\n",
-					ii, pMgmt->sNodeDBTable[ii].wEnQueueCnt);
+				pr_debug("Index=%d Enqueu Cnt= %d\n",
+					 ii,
+					 pMgmt->sNodeDBTable[ii].wEnQueueCnt);
 				while ((skb = skb_dequeue(&pMgmt->sNodeDBTable[ii].sTxPSQueue)) != NULL) {
 					if (skb_queue_empty(&pMgmt->sNodeDBTable[ii].sTxPSQueue)) {
 						// clear tx map
@@ -741,7 +746,7 @@ vCommandTimer(
 						pDevice->bMoreData = true;
 					}
 					if (!device_dma0_xmit(pDevice, skb, ii))
-						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "sta ps tx fail\n");
+						pr_debug("sta ps tx fail\n");
 
 					pMgmt->sNodeDBTable[ii].wEnQueueCnt--;
 					// check if sta ps enabled, and wait next pspoll.
@@ -753,7 +758,8 @@ vCommandTimer(
 					// clear tx map
 					pMgmt->abyPSTxMap[pMgmt->sNodeDBTable[ii].wAID >> 3] &=
 						~byMask[pMgmt->sNodeDBTable[ii].wAID & 7];
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Index=%d PS queue clear\n", ii);
+					pr_debug("Index=%d PS queue clear\n",
+						 ii);
 				}
 				pMgmt->sNodeDBTable[ii].bRxPSPoll = false;
 			}
@@ -763,7 +769,7 @@ vCommandTimer(
 		break;
 
 	case WLAN_CMD_RADIO_START:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "eCommandState == WLAN_CMD_RADIO_START\n");
+		pr_debug("eCommandState == WLAN_CMD_RADIO_START\n");
 		if (pDevice->bRadioCmd)
 			CARDbRadioPowerOn(pDevice);
 		else
@@ -786,7 +792,7 @@ vCommandTimer(
 		}
 		pDevice->byBBVGACurrent = pDevice->byBBVGANew;
 		BBvSetVGAGainOffset(pDevice, pDevice->byBBVGACurrent);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "SetVGAGainOffset %02X\n", pDevice->byBBVGACurrent);
+		pr_debug("SetVGAGainOffset %02X\n", pDevice->byBBVGACurrent);
 		s_bCommandComplete(pDevice);
 		break;
 
@@ -824,7 +830,7 @@ s_bCommandComplete(
 		pDevice->bCmdRunning = true;
 		switch (pDevice->eCommand) {
 		case WLAN_CMD_BSSID_SCAN:
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "eCommandState= WLAN_CMD_BSSID_SCAN\n");
+			pr_debug("eCommandState= WLAN_CMD_BSSID_SCAN\n");
 			pDevice->eCommandState = WLAN_CMD_SCAN_START;
 			pMgmt->uScanChannel = 0;
 			if (pSSID->len != 0)
@@ -839,7 +845,7 @@ s_bCommandComplete(
 				pSSID->len = WLAN_SSID_MAXLEN;
 			if (pSSID->len != 0)
 				memcpy(pDevice->pMgmt->abyDesireSSID, pSSID, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "eCommandState= WLAN_CMD_SSID_START\n");
+			pr_debug("eCommandState= WLAN_CMD_SSID_START\n");
 			break;
 		case WLAN_CMD_DISASSOCIATE:
 			pDevice->eCommandState = WLAN_CMD_DISASSOCIATE_START;
diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index d696f5b..c998a16 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -86,9 +86,6 @@
 
 /*---------------------  Static Classes  ----------------------------*/
 
-/*---------------------  Static Variables  --------------------------*/
-static int msglevel = MSG_LEVEL_INFO;
-
 /*---------------------  Static Functions  --------------------------*/
 //2008-8-4 <add> by chester
 static bool ChannelExceedZoneType(
@@ -551,9 +548,9 @@ vMgrReAssocBeginSta(
 		/* send the frame */
 		*pStatus = csMgmt_xmit(pDevice, pTxPacket);
 		if (*pStatus != CMD_STATUS_PENDING)
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Reassociation tx failed.\n");
+			pr_debug("Mgt:Reassociation tx failed\n");
 		else
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Reassociation tx sending.\n");
+			pr_debug("Mgt:Reassociation tx sending\n");
 	}
 }
 
@@ -718,8 +715,8 @@ s_vMgrRxAssocRequest(
 		if (!pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble)
 			pDevice->bBarkerPreambleMd = true;
 
-		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Associate AID= %d\n", wAssocAID);
-		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "MAC=%2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X\n",
+		pr_info("Associate AID= %d\n", wAssocAID);
+		pr_info("MAC=%2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X\n",
 			sFrame.pHdr->sA3.abyAddr2[0],
 			sFrame.pHdr->sA3.abyAddr2[1],
 			sFrame.pHdr->sA3.abyAddr2[2],
@@ -727,7 +724,7 @@ s_vMgrRxAssocRequest(
 			sFrame.pHdr->sA3.abyAddr2[4],
 			sFrame.pHdr->sA3.abyAddr2[5]
 			);
-		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Max Support rate = %d\n",
+		pr_info("Max Support rate = %d\n",
 			pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate);
 	} else {
 		/* TODO: received STA under state1 handle */
@@ -753,9 +750,9 @@ s_vMgrRxAssocRequest(
 		/* send the frame */
 		Status = csMgmt_xmit(pDevice, pTxPacket);
 		if (Status != CMD_STATUS_PENDING)
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Assoc response tx failed\n");
+			pr_debug("Mgt:Assoc response tx failed\n");
 		else
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Assoc response tx sending..\n");
+			pr_debug("Mgt:Assoc response tx sending..\n");
 	}
 }
 
@@ -867,8 +864,8 @@ s_vMgrRxReAssocRequest(
 		if (!pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble)
 			pDevice->bBarkerPreambleMd = true;
 
-		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Rx ReAssociate AID= %d\n", wAssocAID);
-		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "MAC=%2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X\n",
+		pr_info("Rx ReAssociate AID= %d\n", wAssocAID);
+		pr_info("MAC=%2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X\n",
 			sFrame.pHdr->sA3.abyAddr2[0],
 			sFrame.pHdr->sA3.abyAddr2[1],
 			sFrame.pHdr->sA3.abyAddr2[2],
@@ -876,7 +873,7 @@ s_vMgrRxReAssocRequest(
 			sFrame.pHdr->sA3.abyAddr2[4],
 			sFrame.pHdr->sA3.abyAddr2[5]
 			);
-		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Max Support rate = %d\n",
+		pr_info("Max Support rate = %d\n",
 			pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate);
 
 	}
@@ -901,9 +898,9 @@ s_vMgrRxReAssocRequest(
 
 		Status = csMgmt_xmit(pDevice, pTxPacket);
 		if (Status != CMD_STATUS_PENDING)
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:ReAssoc response tx failed\n");
+			pr_debug("Mgt:ReAssoc response tx failed\n");
 		else
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:ReAssoc response tx sending..\n");
+			pr_debug("Mgt:ReAssoc response tx sending..\n");
 	}
 }
 
@@ -961,13 +958,14 @@ s_vMgrRxAssocResponse(
 			// set AID
 			pMgmt->wCurrAID = cpu_to_le16((*(sFrame.pwAid)));
 			if ((pMgmt->wCurrAID >> 14) != (BIT0 | BIT1))
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "AID from AP, has two msb clear.\n");
+				pr_debug("AID from AP, has two msb clear\n");
 
-			DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Association Successful, AID=%d.\n", pMgmt->wCurrAID & ~(BIT14 | BIT15));
+			pr_info("Association Successful, AID=%d\n",
+				pMgmt->wCurrAID & ~(BIT14 | BIT15));
 			pMgmt->eCurrState = WMAC_STATE_ASSOC;
 			BSSvUpdateAPNode((void *)pDevice, sFrame.pwCapInfo, sFrame.pSuppRates, sFrame.pExtSuppRates);
 			pItemSSID = (PWLAN_IE_SSID)pMgmt->abyCurrSSID;
-			DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Link with AP(SSID): %s\n", pItemSSID->abySSID);
+			pr_info("Link with AP(SSID): %s\n", pItemSSID->abySSID);
 			pDevice->bLinkPass = true;
 			pDevice->uBBVGADiffCount = 0;
 			if ((pDevice->bWPADEVUp) && (pDevice->skb != NULL)) {
@@ -1206,8 +1204,8 @@ s_vMgrRxAuthentication(
 		s_vMgrRxAuthenSequence_4(pDevice, pMgmt, &sFrame);
 		break;
 	default:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Auth Sequence error, seq = %d\n",
-			cpu_to_le16((*(sFrame.pwAuthSequence))));
+		pr_debug("Auth Sequence error, seq = %d\n",
+			 cpu_to_le16((*(sFrame.pwAuthSequence))));
 		break;
 	}
 }
@@ -1306,9 +1304,9 @@ s_vMgrRxAuthenSequence_1(
 	if (pDevice->bEnableHostapd)
 		return;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Authreq_reply sequence_1 tx..\n");
+	pr_debug("Mgt:Authreq_reply sequence_1 tx..\n");
 	if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING)
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Authreq_reply sequence_1 tx failed.\n");
+		pr_debug("Mgt:Authreq_reply sequence_1 tx failed\n");
 }
 
 /*+
@@ -1337,11 +1335,11 @@ s_vMgrRxAuthenSequence_2(
 	switch (cpu_to_le16((*(pFrame->pwAuthAlgorithm)))) {
 	case WLAN_AUTH_ALG_OPENSYSTEM:
 		if (cpu_to_le16((*(pFrame->pwStatus))) == WLAN_MGMT_STATUS_SUCCESS) {
-			DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "802.11 Authen (OPEN) Successful.\n");
+			pr_info("802.11 Authen (OPEN) Successful\n");
 			pMgmt->eCurrState = WMAC_STATE_AUTH;
 			timer_expire(pDevice->sTimerCommand, 0);
 		} else {
-			DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "802.11 Authen (OPEN) Failed.\n");
+			pr_info("802.11 Authen (OPEN) Failed\n");
 			s_vMgrLogStatus(pMgmt, cpu_to_le16((*(pFrame->pwStatus))));
 			pMgmt->eCurrState = WMAC_STATE_IDLE;
 		}
@@ -1381,16 +1379,17 @@ s_vMgrRxAuthenSequence_2(
 			pTxPacket->cbPayloadLen = sFrame.len - WLAN_HDR_ADDR3_LEN;
 			// send the frame
 			if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING)
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Auth_reply sequence_2 tx failed.\n");
+				pr_debug("Mgt:Auth_reply sequence_2 tx failed\n");
 
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Auth_reply sequence_2 tx ...\n");
+			pr_debug("Mgt:Auth_reply sequence_2 tx ...\n");
 		} else {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:rx Auth_reply sequence_2 status error ...\n");
+			pr_debug("Mgt:rx Auth_reply sequence_2 status error ...\n");
 			s_vMgrLogStatus(pMgmt, cpu_to_le16((*(pFrame->pwStatus))));
 		}
 		break;
 	default:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt: rx auth.seq = 2 unknown AuthAlgorithm=%d\n", cpu_to_le16((*(pFrame->pwAuthAlgorithm))));
+		pr_debug("Mgt: rx auth.seq = 2 unknown AuthAlgorithm=%d\n",
+			 cpu_to_le16((*(pFrame->pwAuthAlgorithm))));
 		break;
 	}
 }
@@ -1444,7 +1443,7 @@ s_vMgrRxAuthenSequence_3(
 		pMgmt->sNodeDBTable[uNodeIndex].byAuthSequence = 0;
 	}
 	uStatusCode = WLAN_MGMT_STATUS_SUCCESS;
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Challenge text check ok..\n");
+	pr_debug("Challenge text check ok..\n");
 
 reply:
 	// send auth reply
@@ -1477,7 +1476,7 @@ reply:
 		return;
 
 	if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING)
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Authreq_reply sequence_4 tx failed.\n");
+		pr_debug("Mgt:Authreq_reply sequence_4 tx failed\n");
 }
 
 /*+
@@ -1499,11 +1498,11 @@ s_vMgrRxAuthenSequence_4(
 )
 {
 	if (cpu_to_le16((*(pFrame->pwStatus))) == WLAN_MGMT_STATUS_SUCCESS) {
-		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "802.11 Authen (SHAREDKEY) Successful.\n");
+		pr_info("802.11 Authen (SHAREDKEY) Successful\n");
 		pMgmt->eCurrState = WMAC_STATE_AUTH;
 		timer_expire(pDevice->sTimerCommand, 0);
 	} else{
-		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "802.11 Authen (SHAREDKEY) Failed.\n");
+		pr_info("802.11 Authen (SHAREDKEY) Failed\n");
 		s_vMgrLogStatus(pMgmt, cpu_to_le16((*(pFrame->pwStatus))));
 		pMgmt->eCurrState = WMAC_STATE_IDLE;
 	}
@@ -1540,13 +1539,14 @@ s_vMgrRxDisassociation(
 		if (BSSDBbIsSTAInNodeDB(pMgmt, pRxPacket->p80211Header->sA3.abyAddr2, &uNodeIndex))
 			BSSvRemoveOneNode(pDevice, uNodeIndex);
 		else
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Rx disassoc, sta not found\n");
+			pr_debug("Rx disassoc, sta not found\n");
 
 	} else if (pMgmt->eCurrMode == WMAC_MODE_ESS_STA) {
 		sFrame.len = pRxPacket->cbMPDULen;
 		sFrame.pBuf = (unsigned char *)pRxPacket->p80211Header;
 		vMgrDecodeDisassociation(&sFrame);
-		DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "AP disassociated me, reason=%d.\n", cpu_to_le16(*(sFrame.pwReason)));
+		pr_info("AP disassociated me, reason=%d\n",
+			cpu_to_le16(*(sFrame.pwReason)));
 		//TODO: do something let upper layer know or
 		//try to send associate packet again because of inactivity timeout
 		if ((pDevice->bWPADEVUp) && (pDevice->skb != NULL)) {
@@ -1611,13 +1611,14 @@ s_vMgrRxDeauthentication(
 		if (BSSDBbIsSTAInNodeDB(pMgmt, pRxPacket->p80211Header->sA3.abyAddr2, &uNodeIndex))
 			BSSvRemoveOneNode(pDevice, uNodeIndex);
 		else
-			DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Rx deauth, sta not found\n");
+			pr_info("Rx deauth, sta not found\n");
 	} else {
 		if (pMgmt->eCurrMode == WMAC_MODE_ESS_STA) {
 			sFrame.len = pRxPacket->cbMPDULen;
 			sFrame.pBuf = (unsigned char *)pRxPacket->p80211Header;
 			vMgrDecodeDeauthen(&sFrame);
-			DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO  "AP deauthed me, reason=%d.\n", cpu_to_le16((*(sFrame.pwReason))));
+			pr_info("AP deauthed me, reason=%d\n",
+				cpu_to_le16((*(sFrame.pwReason))));
 			// TODO: update BSS list for specific BSSID if pre-authentication case
 			if (ether_addr_equal(sFrame.pHdr->sA3.abyAddr3,
 					     pMgmt->abyCurrBSSID)) {
@@ -1755,7 +1756,7 @@ s_vMgrRxBeacon(
 	    (sFrame.pwCapInfo == NULL) ||
 	    (sFrame.pSSID == NULL) ||
 	    (sFrame.pSuppRates == NULL)) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Rx beacon frame error\n");
+		pr_debug("Rx beacon frame error\n");
 		return;
 	}
 
@@ -1790,7 +1791,7 @@ s_vMgrRxBeacon(
 
 	pBSSList = BSSpAddrIsInBSSList((void *)pDevice, sFrame.pHdr->sA3.abyAddr3, sFrame.pSSID);
 	if (pBSSList == NULL) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Beacon/insert: RxChannel = : %d\n", byCurrChannel);
+		pr_debug("Beacon/insert: RxChannel = : %d\n", byCurrChannel);
 		BSSbInsertToBSSList((void *)pDevice,
 				    sFrame.pHdr->sA3.abyAddr3,
 				    *sFrame.pqwTimestamp,
@@ -1964,7 +1965,7 @@ s_vMgrRxBeacon(
 		}
 	}
 
-//    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Beacon 2\n");
+//    pr_debug("Beacon 2\n");
 	// check if CF field exists
 	if (WLAN_GET_CAP_INFO_ESS(*sFrame.pwCapInfo)) {
 		if (sFrame.pCFParms->wCFPDurRemaining > 0) {
@@ -2030,14 +2031,14 @@ s_vMgrRxBeacon(
 
 			} else {
 				pMgmt->bInTIMWake = false;
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BCN: Not In TIM..\n");
+				pr_debug("BCN: Not In TIM..\n");
 				if (!pDevice->bPWBitOn) {
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BCN: Send Null Packet\n");
+					pr_debug("BCN: Send Null Packet\n");
 					if (PSbSendNullPacket(pDevice))
 						pDevice->bPWBitOn = true;
 				}
 				if (PSbConsiderPowerDown(pDevice, false, false))
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BCN: Power down now...\n");
+					pr_debug("BCN: Power down now...\n");
 			}
 
 		}
@@ -2105,7 +2106,7 @@ s_vMgrRxBeacon(
 
 			// if other stations joined, indicate connection to upper layer..
 			if (pMgmt->eCurrState == WMAC_STATE_STARTED) {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Current IBSS State: [Started]........to: [Jointed]\n");
+				pr_debug("Current IBSS State: [Started]........to: [Jointed]\n");
 				pMgmt->eCurrState = WMAC_STATE_JOINTED;
 				pDevice->bLinkPass = true;
 				if (netif_queue_stopped(pDevice->dev))
@@ -2131,7 +2132,7 @@ s_vMgrRxBeacon(
 									(PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
 									WLAN_RATES_MAXLEN_11B);
 				// set HW beacon interval and re-synchronizing....
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Rejoining to Other Adhoc group with same SSID........\n");
+				pr_debug("Rejoining to Other Adhoc group with same SSID........\n");
 				VNSvOutPortW(pDevice->PortOffset + MAC_REG_BI, pMgmt->wCurrBeaconPeriod);
 				CARDbUpdateTSF(pDevice, pRxPacket->byRxRate, qwTimestamp, qwLocalTSF);
 				CARDvUpdateNextTBTT(pDevice->PortOffset, qwTimestamp, pMgmt->wCurrBeaconPeriod);
@@ -2191,7 +2192,7 @@ vMgrCreateOwnIBSS(
 	unsigned char abyOFDM_RATE[] = {0x0C, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C};
 	unsigned short wSuppRate;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Create Basic Service Set .......\n");
+	pr_debug("Create Basic Service Set .......\n");
 
 	if (pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) {
 		if ((pMgmt->eAuthenMode == WMAC_AUTH_WPANONE) &&
@@ -2300,7 +2301,7 @@ vMgrCreateOwnIBSS(
 	if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
 		// AP mode BSSID = MAC addr
 		memcpy(pMgmt->abyCurrBSSID, pMgmt->abyMACAddr, WLAN_ADDR_LEN);
-		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "AP beacon created BSSID:%pM\n",
+		pr_info("AP beacon created BSSID:%pM\n",
 			pMgmt->abyCurrBSSID);
 	}
 
@@ -2321,7 +2322,7 @@ vMgrCreateOwnIBSS(
 		pMgmt->abyCurrBSSID[0] &= ~IEEE_ADDR_GROUP;
 		pMgmt->abyCurrBSSID[0] |= IEEE_ADDR_UNIVERSAL;
 
-		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Adhoc beacon created bssid:%pM\n",
+		pr_info("Adhoc beacon created bssid:%pM\n",
 			pMgmt->abyCurrBSSID);
 	}
 
@@ -2435,7 +2436,7 @@ vMgrJoinBSSBegin(
 
 	if (ii == MAX_BSS_NUM) {
 		*pStatus = CMD_STATUS_RESOURCES;
-		DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "BSS finding:BSS list is empty.\n");
+		pr_info("BSS finding:BSS list is empty\n");
 		return;
 	}
 
@@ -2450,11 +2451,12 @@ vMgrJoinBSSBegin(
 	if (pCurr == NULL) {
 		*pStatus = CMD_STATUS_RESOURCES;
 		pItemSSID = (PWLAN_IE_SSID)pMgmt->abyDesireSSID;
-		DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Scanning [%s] not found, disconnected !\n", pItemSSID->abySSID);
+		pr_info("Scanning [%s] not found, disconnected !\n",
+			pItemSSID->abySSID);
 		return;
 	}
 
-	DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "AP(BSS) finding:Found a AP(BSS)..\n");
+	pr_info("AP(BSS) finding:Found a AP(BSS)..\n");
 	if (WLAN_GET_CAP_INFO_ESS(cpu_to_le16(pCurr->wCapInfo))) {
 		if ((pMgmt->eAuthenMode == WMAC_AUTH_WPA) || (pMgmt->eAuthenMode == WMAC_AUTH_WPAPSK)) {
 			// patch for CISCO migration mode
@@ -2532,10 +2534,11 @@ vMgrJoinBSSBegin(
 			if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2) {
 				bool bResult = bAdd_PMKID_Candidate((void *)pDevice, pMgmt->abyCurrBSSID, &pCurr->sRSNCapObj);
 
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bAdd_PMKID_Candidate: 1(%d)\n", bResult);
+				pr_debug("bAdd_PMKID_Candidate: 1(%d)\n",
+					 bResult);
 				if (!bResult) {
 					vFlush_PMKID_Candidate((void *)pDevice);
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "vFlush_PMKID_Candidate: 4\n");
+					pr_debug("vFlush_PMKID_Candidate: 4\n");
 					bAdd_PMKID_Candidate((void *)pDevice, pMgmt->abyCurrBSSID, &pCurr->sRSNCapObj);
 				}
 			}
@@ -2543,9 +2546,9 @@ vMgrJoinBSSBegin(
 			// Preamble type auto-switch: if AP can receive short-preamble cap,
 			// we can turn on too.
 
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Join ESS\n");
+			pr_debug("Join ESS\n");
 
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "End of Join AP -- A/B/G Action\n");
+			pr_debug("End of Join AP -- A/B/G Action\n");
 		} else {
 			pMgmt->eCurrState = WMAC_STATE_IDLE;
 		}
@@ -2603,8 +2606,8 @@ vMgrJoinBSSBegin(
 
 			pMgmt->eCurrState = WMAC_STATE_STARTED;
 
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Join IBSS ok:%pM\n",
-				pMgmt->abyCurrBSSID);
+			pr_debug("Join IBSS ok:%pM\n",
+				 pMgmt->abyCurrBSSID);
 			// Preamble type auto-switch: if AP can receive short-preamble cap,
 			// and if registry setting is short preamble we can turn on too.
 
@@ -2651,7 +2654,7 @@ s_vMgrSynchBSS(
 			   pDevice->eEncryptionStatus,
 			   &(pMgmt->byCSSPK),
 			   &(pMgmt->byCSSGK))) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "s_bCipherMatch Fail .......\n");
+		pr_debug("s_bCipherMatch Fail .......\n");
 		return;
 	}
 
@@ -2689,8 +2692,7 @@ s_vMgrSynchBSS(
 
 	MACvReadBSSIDAddress(pDevice->PortOffset, pMgmt->abyCurrBSSID);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Sync:set CurrBSSID address = "
-		"%pM\n", pMgmt->abyCurrBSSID);
+	pr_debug("Sync:set CurrBSSID address = %pM\n", pMgmt->abyCurrBSSID);
 
 	if (pCurr->eNetworkTypeInUse == PHY_TYPE_11A) {
 		if ((pMgmt->eConfigPHYMode == PHY_TYPE_11A) ||
@@ -2745,19 +2747,20 @@ s_vMgrSynchBSS(
 				 pCurr->sERP.byERP,
 				 pMgmt->abyCurrSuppRates,
 				 pMgmt->abyCurrExtSuppRates)) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "<----s_bSynchBSS Set Phy Mode Fail [%d]\n", ePhyType);
+		pr_debug("<----s_bSynchBSS Set Phy Mode Fail [%d]\n", ePhyType);
 		return;
 	}
 	// set channel and clear NAV
 	if (!set_channel(pMgmt->pAdapter, pCurr->uChannel)) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "<----s_bSynchBSS Set Channel [%d]\n", pCurr->uChannel);
+		pr_debug("<----s_bSynchBSS Set Channel [%d]\n",
+			 pCurr->uChannel);
 		return;
 	}
 
 	pMgmt->uCurrChannel = pCurr->uChannel;
 	pMgmt->eCurrentPHYMode = ePhyType;
 	pMgmt->byERPContext = pCurr->sERP.byERP;
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Sync:Set to channel = [%d]\n", (int)pCurr->uChannel);
+	pr_debug("Sync:Set to channel = [%d]\n", (int)pCurr->uChannel);
 
 	*pStatus = CMD_STATUS_SUCCESS;
 
@@ -3954,13 +3957,14 @@ s_vMgrRxProbeResponse(
 	    (sFrame.pwCapInfo == NULL) ||
 	    (sFrame.pSSID == NULL) ||
 	    (sFrame.pSuppRates == NULL)) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Probe resp:Fail addr:[%p]\n", pRxPacket->p80211Header);
+		pr_debug("Probe resp:Fail addr:[%p]\n",
+			 pRxPacket->p80211Header);
 		DBG_PORT80(0xCC);
 		return;
 	}
 
 	if (sFrame.pSSID->len == 0)
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Rx Probe resp: SSID len = 0\n");
+		pr_debug("Rx Probe resp: SSID len = 0\n");
 
 	if (sFrame.pDSParms != NULL) {
 		if (byCurrChannel > CB_MAX_CHANNEL_24G) {
@@ -4014,7 +4018,8 @@ s_vMgrRxProbeResponse(
 				    (void *)pRxPacket
 );
 	} else {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Probe resp/insert: RxChannel = : %d\n", byCurrChannel);
+		pr_debug("Probe resp/insert: RxChannel = : %d\n",
+			 byCurrChannel);
 		BSSbInsertToBSSList((void *)pDevice,
 				    sFrame.pHdr->sA3.abyAddr3,
 				    *sFrame.pqwTimestamp,
@@ -4103,7 +4108,7 @@ s_vMgrRxProbeRequest(
 			/* send the frame */
 			Status = csMgmt_xmit(pDevice, pTxPacket);
 			if (Status != CMD_STATUS_PENDING)
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Probe response tx failed\n");
+				pr_debug("Mgt:Probe response tx failed\n");
 		}
 	}
 }
@@ -4143,7 +4148,7 @@ vMgrRxManagePacket(
 	switch (WLAN_GET_FC_FSTYPE((pRxPacket->p80211Header->sA3.wFrameCtl))) {
 	case WLAN_FSTYPE_ASSOCREQ:
 		// Frame Clase = 2
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx assocreq\n");
+		pr_debug("rx assocreq\n");
 		if (eNodeState < NODE_AUTH) {
 			// send deauth notification
 			// reason = (6) class 2 received from nonauth sta
@@ -4153,7 +4158,7 @@ vMgrRxManagePacket(
 					     (6),
 					     &Status
 );
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wmgr: send vMgrDeAuthenBeginSta 1\n");
+			pr_debug("wmgr: send vMgrDeAuthenBeginSta 1\n");
 		} else {
 			s_vMgrRxAssocRequest(pDevice, pMgmt, pRxPacket, uNodeIndex);
 		}
@@ -4161,14 +4166,14 @@ vMgrRxManagePacket(
 
 	case WLAN_FSTYPE_ASSOCRESP:
 		// Frame Clase = 2
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx assocresp1\n");
+		pr_debug("rx assocresp1\n");
 		s_vMgrRxAssocResponse(pDevice, pMgmt, pRxPacket, false);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx assocresp2\n");
+		pr_debug("rx assocresp2\n");
 		break;
 
 	case WLAN_FSTYPE_REASSOCREQ:
 		// Frame Clase = 2
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx reassocreq\n");
+		pr_debug("rx reassocreq\n");
 		// Todo: reassoc
 		if (eNodeState < NODE_AUTH) {
 			// send deauth notification
@@ -4179,7 +4184,7 @@ vMgrRxManagePacket(
 					     (6),
 					     &Status
 );
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wmgr: send vMgrDeAuthenBeginSta 2\n");
+			pr_debug("wmgr: send vMgrDeAuthenBeginSta 2\n");
 
 		}
 		s_vMgrRxReAssocRequest(pDevice, pMgmt, pRxPacket, uNodeIndex);
@@ -4187,7 +4192,7 @@ vMgrRxManagePacket(
 
 	case WLAN_FSTYPE_REASSOCRESP:
 		// Frame Clase = 2
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx reassocresp\n");
+		pr_debug("rx reassocresp\n");
 		s_vMgrRxAssocResponse(pDevice, pMgmt, pRxPacket, true);
 		break;
 
@@ -4198,7 +4203,7 @@ vMgrRxManagePacket(
 
 	case WLAN_FSTYPE_PROBERESP:
 		// Frame Clase = 0
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx proberesp\n");
+		pr_debug("rx proberesp\n");
 
 		s_vMgrRxProbeResponse(pDevice, pMgmt, pRxPacket);
 		break;
@@ -4213,12 +4218,12 @@ vMgrRxManagePacket(
 
 	case WLAN_FSTYPE_ATIM:
 		// Frame Clase = 1
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx atim\n");
+		pr_debug("rx atim\n");
 		break;
 
 	case WLAN_FSTYPE_DISASSOC:
 		// Frame Clase = 2
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx disassoc\n");
+		pr_debug("rx disassoc\n");
 		if (eNodeState < NODE_AUTH) {
 			// send deauth notification
 			// reason = (6) class 2 received from nonauth sta
@@ -4228,25 +4233,25 @@ vMgrRxManagePacket(
 					     (6),
 					     &Status
 );
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wmgr: send vMgrDeAuthenBeginSta 3\n");
+			pr_debug("wmgr: send vMgrDeAuthenBeginSta 3\n");
 		}
 		s_vMgrRxDisassociation(pDevice, pMgmt, pRxPacket);
 		break;
 
 	case WLAN_FSTYPE_AUTHEN:
 		// Frame Clase = 1
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO  "rx authen\n");
+		pr_debug("rx authen\n");
 		s_vMgrRxAuthentication(pDevice, pMgmt, pRxPacket);
 		break;
 
 	case WLAN_FSTYPE_DEAUTHEN:
 		// Frame Clase = 1
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx deauthen\n");
+		pr_debug("rx deauthen\n");
 		s_vMgrRxDeauthentication(pDevice, pMgmt, pRxPacket);
 		break;
 
 	default:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx unknown mgmt\n");
+		pr_debug("rx unknown mgmt\n");
 	}
 }
 
@@ -4319,46 +4324,46 @@ s_vMgrLogStatus(
 {
 	switch (wStatus) {
 	case WLAN_MGMT_STATUS_UNSPEC_FAILURE:
-		DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Status code == Unspecified error.\n");
+		pr_info("Status code == Unspecified error\n");
 		break;
 	case WLAN_MGMT_STATUS_CAPS_UNSUPPORTED:
-		DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Status code == Can't support all requested capabilities.\n");
+		pr_info("Status code == Can't support all requested capabilities\n");
 		break;
 	case WLAN_MGMT_STATUS_REASSOC_NO_ASSOC:
-		DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Status code == Reassoc denied, can't confirm original Association.\n");
+		pr_info("Status code == Reassoc denied, can't confirm original Association\n");
 		break;
 	case WLAN_MGMT_STATUS_ASSOC_DENIED_UNSPEC:
-		DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Status code == Assoc denied, undefine in spec\n");
+		pr_info("Status code == Assoc denied, undefine in spec\n");
 		break;
 	case WLAN_MGMT_STATUS_UNSUPPORTED_AUTHALG:
-		DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Status code == Peer doesn't support authen algorithm.\n");
+		pr_info("Status code == Peer doesn't support authen algorithm\n");
 		break;
 	case WLAN_MGMT_STATUS_RX_AUTH_NOSEQ:
-		DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Status code == Authen frame received out of sequence.\n");
+		pr_info("Status code == Authen frame received out of sequence\n");
 		break;
 	case WLAN_MGMT_STATUS_CHALLENGE_FAIL:
-		DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Status code == Authen rejected, challenge  failure.\n");
+		pr_info("Status code == Authen rejected, challenge  failure\n");
 		break;
 	case WLAN_MGMT_STATUS_AUTH_TIMEOUT:
-		DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Status code == Authen rejected, timeout waiting for next frame.\n");
+		pr_info("Status code == Authen rejected, timeout waiting for next frame\n");
 		break;
 	case WLAN_MGMT_STATUS_ASSOC_DENIED_BUSY:
-		DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Status code == Assoc denied, AP too busy.\n");
+		pr_info("Status code == Assoc denied, AP too busy\n");
 		break;
 	case WLAN_MGMT_STATUS_ASSOC_DENIED_RATES:
-		DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Status code == Assoc denied, we haven't enough basic rates.\n");
+		pr_info("Status code == Assoc denied, we haven't enough basic rates\n");
 		break;
 	case WLAN_MGMT_STATUS_ASSOC_DENIED_SHORTPREAMBLE:
-		DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Status code == Assoc denied, we do not support short preamble.\n");
+		pr_info("Status code == Assoc denied, we do not support short preamble\n");
 		break;
 	case WLAN_MGMT_STATUS_ASSOC_DENIED_PBCC:
-		DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Status code == Assoc denied, we do not support PBCC.\n");
+		pr_info("Status code == Assoc denied, we do not support PBCC\n");
 		break;
 	case WLAN_MGMT_STATUS_ASSOC_DENIED_AGILITY:
-		DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Status code == Assoc denied, we do not support channel agility.\n");
+		pr_info("Status code == Assoc denied, we do not support channel agility\n");
 		break;
 	default:
-		DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Unknown status code %d.\n", wStatus);
+		pr_info("Unknown status code %d\n", wStatus);
 		break;
 	}
 }
@@ -4390,7 +4395,8 @@ bAdd_PMKID_Candidate(
 	struct pmkid_candidate *pCandidateList;
 	unsigned int ii = 0;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bAdd_PMKID_Candidate START: (%d)\n", (int)pDevice->gsPMKIDCandidate.NumCandidates);
+	pr_debug("bAdd_PMKID_Candidate START: (%d)\n",
+		 (int)pDevice->gsPMKIDCandidate.NumCandidates);
 
 	if ((pDevice == NULL) || (pbyBSSID == NULL) || (psRSNCapObj == NULL))
 		return false;
@@ -4420,7 +4426,8 @@ bAdd_PMKID_Candidate(
 
 	memcpy(pCandidateList->BSSID, pbyBSSID, ETH_ALEN);
 	pDevice->gsPMKIDCandidate.NumCandidates++;
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "NumCandidates:%d\n", (int)pDevice->gsPMKIDCandidate.NumCandidates);
+	pr_debug("NumCandidates:%d\n",
+		 (int)pDevice->gsPMKIDCandidate.NumCandidates);
 	return true;
 }
 
@@ -4537,8 +4544,9 @@ s_bCipherMatch(
 		}
 	}
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%d, %d, %d, %d, EncStatus:%d\n",
-		byMulticastCipher, byCipherMask, pBSSNode->bWPAValid, pBSSNode->bWPA2Valid, EncStatus);
+	pr_debug("%d, %d, %d, %d, EncStatus:%d\n",
+		 byMulticastCipher, byCipherMask,
+		 pBSSNode->bWPAValid, pBSSNode->bWPA2Valid, EncStatus);
 
 	// mask our cap. with BSS
 	if (EncStatus == Ndis802_11Encryption1Enabled) {
diff --git a/drivers/staging/vt6655/wpa.c b/drivers/staging/vt6655/wpa.c
index 7b1bab9..5d4eca8 100644
--- a/drivers/staging/vt6655/wpa.c
+++ b/drivers/staging/vt6655/wpa.c
@@ -43,8 +43,6 @@
 #include "80211mgr.h"
 
 /*---------------------  Static Variables  --------------------------*/
-static int msglevel = MSG_LEVEL_INFO;
-
 static const unsigned char abyOUI00[4] = { 0x00, 0x50, 0xf2, 0x00 };
 static const unsigned char abyOUI01[4] = { 0x00, 0x50, 0xf2, 0x01 };
 static const unsigned char abyOUI02[4] = { 0x00, 0x50, 0xf2, 0x02 };
@@ -115,13 +113,13 @@ WPA_ParseRSN(
 
 	WPA_ClearRSN(pBSSList);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "WPA_ParseRSN: [%d]\n", pRSN->len);
+	pr_debug("WPA_ParseRSN: [%d]\n", pRSN->len);
 
 	// information element header makes sense
 	if ((pRSN->len >= 6) // oui1(4)+ver(2)
 	    && (pRSN->byElementID == WLAN_EID_RSN_WPA) && !memcmp(pRSN->abyOUI, abyOUI01, 4)
 	    && (pRSN->wVersion == 1)) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Legal RSN\n");
+		pr_debug("Legal RSN\n");
 		// update each variable if pRSN is long enough to contain the variable
 		if (pRSN->len >= 10) {
 			//OUI1(4)+ver(2)+GKSuite(4)
@@ -139,13 +137,14 @@ WPA_ParseRSN(
 				// any vendor checks here
 				pBSSList->byGKType = WPA_NONE;
 
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "byGKType: %x\n", pBSSList->byGKType);
+			pr_debug("byGKType: %x\n", pBSSList->byGKType);
 		}
 
 		if (pRSN->len >= 12) {
 			//oui1(4)+ver(2)+GKS(4)+PKSCnt(2)
 			j = 0;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wPKCount: %d, sizeof(pBSSList->abyPKType): %zu\n", pRSN->wPKCount, sizeof(pBSSList->abyPKType));
+			pr_debug("wPKCount: %d, sizeof(pBSSList->abyPKType): %zu\n",
+				 pRSN->wPKCount, sizeof(pBSSList->abyPKType));
 			for (i = 0; (i < pRSN->wPKCount) && (j < ARRAY_SIZE(pBSSList->abyPKType)); i++) {
 				if (pRSN->len >= 12+i*4+4) { //oui1(4)+ver(2)+GKS(4)+PKSCnt(2)+PKS(4*i)
 					if (!memcmp(pRSN->PKSList[i].abyOUI, abyOUI00, 4))
@@ -163,19 +162,20 @@ WPA_ParseRSN(
 					break;
 			}
 			pBSSList->wPKCount = (unsigned short)j;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wPKCount: %d\n", pBSSList->wPKCount);
+			pr_debug("wPKCount: %d\n", pBSSList->wPKCount);
 		}
 
 		m = pRSN->wPKCount;
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "m: %d\n", m);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "14+m*4: %d\n", 14+m*4);
+		pr_debug("m: %d\n", m);
+		pr_debug("14+m*4: %d\n", 14+m*4);
 
 		if (pRSN->len >= 14+m*4) { //oui1(4)+ver(2)+GKS(4)+PKSCnt(2)+PKS(4*m)+AKC(2)
 			// overlay IE_RSN_Auth structure into correct place
 			pIE_RSN_Auth = (PWLAN_IE_RSN_AUTH) pRSN->PKSList[m].abyOUI;
 			j = 0;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wAuthCount: %d, sizeof(pBSSList->abyAuthType): %zu\n",
-				pIE_RSN_Auth->wAuthCount, sizeof(pBSSList->abyAuthType));
+			pr_debug("wAuthCount: %d, sizeof(pBSSList->abyAuthType): %zu\n",
+				 pIE_RSN_Auth->wAuthCount,
+				 sizeof(pBSSList->abyAuthType));
 			for (i = 0; (i < pIE_RSN_Auth->wAuthCount) && (j < ARRAY_SIZE(pBSSList->abyAuthType)); i++) {
 				if (pRSN->len >= 14+4+(m+i)*4) { //oui1(4)+ver(2)+GKS(4)+PKSCnt(2)+PKS(4*m)+AKC(2)+AKS(4*i)
 					if (!memcmp(pIE_RSN_Auth->AuthKSList[i].abyOUI, abyOUI01, 4))
@@ -191,14 +191,14 @@ WPA_ParseRSN(
 			}
 			if (j > 0)
 				pBSSList->wAuthCount = (unsigned short)j;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wAuthCount: %d\n", pBSSList->wAuthCount);
+			pr_debug("wAuthCount: %d\n", pBSSList->wAuthCount);
 		}
 
 		if (pIE_RSN_Auth != NULL) {
 			n = pIE_RSN_Auth->wAuthCount;
 
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "n: %d\n", n);
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "14+4+(m+n)*4: %d\n", 14+4+(m+n)*4);
+			pr_debug("n: %d\n", n);
+			pr_debug("14+4+(m+n)*4: %d\n", 14+4+(m+n)*4);
 
 			if (pRSN->len+2 >= 14+4+(m+n)*4) { //oui1(4)+ver(2)+GKS(4)+PKSCnt(2)+PKS(4*m)+AKC(2)+AKS(4*n)+Cap(2)
 				pbyCaps = (unsigned char *)pIE_RSN_Auth->AuthKSList[n].abyOUI;
diff --git a/drivers/staging/vt6655/wpa2.c b/drivers/staging/vt6655/wpa2.c
index 4e1b63b..bb335ef 100644
--- a/drivers/staging/vt6655/wpa2.c
+++ b/drivers/staging/vt6655/wpa2.c
@@ -35,8 +35,6 @@
 #include "device.h"
 #include "wmgr.h"
 
-/*---------------------  Static Definitions -------------------------*/
-static int msglevel = MSG_LEVEL_INFO;
 /*---------------------  Static Classes  ----------------------------*/
 
 /*---------------------  Static Variables  --------------------------*/
@@ -116,7 +114,7 @@ WPA2vParseRSN(
 	unsigned char *pbyOUI;
 	bool bUseGK = false;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "WPA2_ParseRSN: [%d]\n", pRSN->len);
+	pr_debug("WPA2_ParseRSN: [%d]\n", pRSN->len);
 
 	WPA2_ClearRSN(pBSSNode);
 
@@ -135,7 +133,7 @@ WPA2vParseRSN(
 	// information element header makes sense
 	if ((pRSN->byElementID == WLAN_EID_RSN) &&
 	    (pRSN->wVersion == 1)) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Legal 802.11i RSN\n");
+		pr_debug("Legal 802.11i RSN\n");
 
 		pbyOUI = &(pRSN->abyRSN[0]);
 		if (!memcmp(pbyOUI, abyOUIWEP40, 4))
@@ -153,7 +151,7 @@ WPA2vParseRSN(
 			// any vendor checks here
 			pBSSNode->byCSSGK = WLAN_11i_CSS_UNKNOWN;
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "802.11i CSS: %X\n", pBSSNode->byCSSGK);
+		pr_debug("802.11i CSS: %X\n", pBSSNode->byCSSGK);
 
 		if (pRSN->len == 6) {
 			pBSSNode->bWPA2Valid = true;
@@ -186,7 +184,8 @@ WPA2vParseRSN(
 						pBSSNode->abyCSSPK[j++] = WLAN_11i_CSS_UNKNOWN;
 					}
 					pbyOUI += 4;
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "abyCSSPK[%d]: %X\n", j-1, pBSSNode->abyCSSPK[j-1]);
+					pr_debug("abyCSSPK[%d]: %X\n",
+						 j-1, pBSSNode->abyCSSPK[j-1]);
 				} else
 					break;
 			} //for
@@ -206,7 +205,7 @@ WPA2vParseRSN(
 				return;
 			}
 			pBSSNode->wCSSPKCount = (unsigned short)j;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wCSSPKCount: %d\n", pBSSNode->wCSSPKCount);
+			pr_debug("wCSSPKCount: %d\n", pBSSNode->wCSSPKCount);
 		}
 
 		m = *((unsigned short *)&(pRSN->abyRSN[4]));
@@ -224,12 +223,15 @@ WPA2vParseRSN(
 					else
 						// any vendor checks here
 						pBSSNode->abyAKMSSAuthType[j++] = WLAN_11i_AKMSS_UNKNOWN;
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "abyAKMSSAuthType[%d]: %X\n", j-1, pBSSNode->abyAKMSSAuthType[j-1]);
+					pr_debug("abyAKMSSAuthType[%d]: %X\n",
+						 j-1,
+						 pBSSNode->abyAKMSSAuthType[j-1]);
 				} else
 					break;
 			}
 			pBSSNode->wAKMSSAuthCount = (unsigned short)j;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wAKMSSAuthCount: %d\n", pBSSNode->wAKMSSAuthCount);
+			pr_debug("wAKMSSAuthCount: %d\n",
+				 pBSSNode->wAKMSSAuthCount);
 
 			n = *((unsigned short *)&(pRSN->abyRSN[6+4*m]));
 			if (pRSN->len >= 12 + 4 * m + 4 * n) { // ver(2)+GK(4)+PKCnt(2)+PKS(4*m)+AKMSSCnt(2)+AKMSS(4*n)+Cap(2)
diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
index 5a1bfe9..37d98f7 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -50,9 +50,6 @@ static const int frequency_list[] = {
 };
 /*---------------------  Static Classes  ----------------------------*/
 
-/*---------------------  Static Variables  --------------------------*/
-static int msglevel = MSG_LEVEL_INFO;
-
 /*---------------------  Static Functions  --------------------------*/
 
 /*---------------------  Export Variables  --------------------------*/
@@ -103,8 +100,7 @@ static int wpa_init_wpadev(struct vnt_private *pDevice)
 	pDevice->wpadev->mem_end = dev->mem_end;
 	ret = register_netdev(pDevice->wpadev);
 	if (ret) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: register_netdev(WPA) failed!\n",
-			dev->name);
+		pr_debug("%s: register_netdev(WPA) failed!\n", dev->name);
 		free_netdev(pDevice->wpadev);
 		return -1;
 	}
@@ -115,8 +111,8 @@ static int wpa_init_wpadev(struct vnt_private *pDevice)
 			return -ENOMEM;
 	}
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: Registered netdev %s for WPA management\n",
-		dev->name, pDevice->wpadev->name);
+	pr_debug("%s: Registered netdev %s for WPA management\n",
+		 dev->name, pDevice->wpadev->name);
 
 	return 0;
 }
@@ -142,8 +138,8 @@ static int wpa_release_wpadev(struct vnt_private *pDevice)
 	}
 
 	if (pDevice->wpadev) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: Netdevice %s unregistered\n",
-			pDevice->dev->name, pDevice->wpadev->name);
+		pr_debug("%s: Netdevice %s unregistered\n",
+			 pDevice->dev->name, pDevice->wpadev->name);
 		unregister_netdev(pDevice->wpadev);
 		free_netdev(pDevice->wpadev);
 		pDevice->wpadev = NULL;
@@ -206,7 +202,7 @@ int wpa_set_keys(struct vnt_private *pDevice, void *ctx,
 	    param->u.wpa_key.seq_len > MAX_KEY_LEN)
 		return -EINVAL;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "param->u.wpa_key.alg_name = %d\n", param->u.wpa_key.alg_name);
+	pr_debug("param->u.wpa_key.alg_name = %d\n", param->u.wpa_key.alg_name);
 	if (param->u.wpa_key.alg_name == WPA_ALG_NONE) {
 		pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 		pDevice->bEncryptionEnable = false;
@@ -284,7 +280,7 @@ int wpa_set_keys(struct vnt_private *pDevice, void *ctx,
 	}
 
 	if (param->u.wpa_key.key_index >= MAX_GROUP_KEY) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "return  dwKeyIndex > 3\n");
+		pr_debug("return  dwKeyIndex > 3\n");
 		return -EINVAL;
 	}
 
@@ -323,7 +319,7 @@ int wpa_set_keys(struct vnt_private *pDevice, void *ctx,
 	if ((byKeyDecMode == KEY_CTL_TKIP) &&
 	    (param->u.wpa_key.key_len != MAX_KEY_LEN)) {
 		// TKIP Key must be 256 bits
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "return- TKIP Key must be 256 bits!\n");
+		pr_debug("return- TKIP Key must be 256 bits!\n");
 		return -EINVAL;
 	}
 	// Check AES key length
@@ -336,7 +332,7 @@ int wpa_set_keys(struct vnt_private *pDevice, void *ctx,
 	// spin_lock_irq(&pDevice->lock);
 	if (is_broadcast_ether_addr(&param->addr[0]) || (param->addr == NULL)) {
 		// If is_broadcast_ether_addr, set the key as every key entry's group key.
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Groupe Key Assign.\n");
+		pr_debug("Groupe Key Assign\n");
 
 		if (KeybSetAllGroupKey(&(pDevice->sKey),
 					dwKeyIndex,
@@ -354,18 +350,18 @@ int wpa_set_keys(struct vnt_private *pDevice, void *ctx,
 				       byKeyDecMode,
 				       pDevice->PortOffset,
 				       pDevice->byLocalID)) {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "GROUP Key Assign.\n");
+			pr_debug("GROUP Key Assign\n");
 
 		} else {
 			return -EINVAL;
 		}
 
 	} else {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Pairwise Key Assign.\n");
+		pr_debug("Pairwise Key Assign\n");
 		// BSSID not 0xffffffffffff
 		// Pairwise Key can't be WEP
 		if (byKeyDecMode == KEY_CTL_WEP) {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Pairwise Key can't be WEP\n");
+			pr_debug("Pairwise Key can't be WEP\n");
 			return -EINVAL;
 		}
 
@@ -382,7 +378,7 @@ int wpa_set_keys(struct vnt_private *pDevice, void *ctx,
 			       byKeyDecMode,
 			       pDevice->PortOffset,
 			       pDevice->byLocalID)) {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Pairwise Key Set\n");
+			pr_debug("Pairwise Key Set\n");
 
 		} else {
 			// Key Table Full
@@ -640,7 +636,7 @@ static int wpa_get_scan(struct vnt_private *pDevice,
 		ret = -EFAULT;
 
 	param->u.scan_results.scan_count = count;
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " param->u.scan_results.scan_count = %d\n", count);
+	pr_debug(" param->u.scan_results.scan_count = %d\n", count);
 
 		kfree(pBuf);
 	return ret;
@@ -670,12 +666,14 @@ static int wpa_set_associate(struct vnt_private *pDevice,
 	bool bWepEnabled = false;
 
 	// set key type & algorithm
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pairwise_suite = %d\n", param->u.wpa_associate.pairwise_suite);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "group_suite = %d\n", param->u.wpa_associate.group_suite);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "key_mgmt_suite = %d\n", param->u.wpa_associate.key_mgmt_suite);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "auth_alg = %d\n", param->u.wpa_associate.auth_alg);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "mode = %d\n", param->u.wpa_associate.mode);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wpa_ie_len = %d\n", param->u.wpa_associate.wpa_ie_len);
+	pr_debug("pairwise_suite = %d\n",
+		 param->u.wpa_associate.pairwise_suite);
+	pr_debug("group_suite = %d\n", param->u.wpa_associate.group_suite);
+	pr_debug("key_mgmt_suite = %d\n",
+		 param->u.wpa_associate.key_mgmt_suite);
+	pr_debug("auth_alg = %d\n", param->u.wpa_associate.auth_alg);
+	pr_debug("mode = %d\n", param->u.wpa_associate.mode);
+	pr_debug("wpa_ie_len = %d\n", param->u.wpa_associate.wpa_ie_len);
 
 	if (param->u.wpa_associate.wpa_ie_len) {
 		if (!param->u.wpa_associate.wpa_ie)
@@ -826,60 +824,60 @@ int wpa_ioctl(struct vnt_private *pDevice, struct iw_point *p)
 	switch (param->cmd) {
 	case VIAWGET_SET_WPA:
 		ret = wpa_set_wpa(pDevice, param);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_WPA\n");
+		pr_debug("VIAWGET_SET_WPA\n");
 		break;
 
 	case VIAWGET_SET_KEY:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_KEY\n");
+		pr_debug("VIAWGET_SET_KEY\n");
 		spin_lock_irq(&pDevice->lock);
 		ret = wpa_set_keys(pDevice, param, false);
 		spin_unlock_irq(&pDevice->lock);
 		break;
 
 	case VIAWGET_SET_SCAN:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_SCAN\n");
+		pr_debug("VIAWGET_SET_SCAN\n");
 		ret = wpa_set_scan(pDevice, param);
 		break;
 
 	case VIAWGET_GET_SCAN:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_GET_SCAN\n");
+		pr_debug("VIAWGET_GET_SCAN\n");
 		ret = wpa_get_scan(pDevice, param);
 		wpa_ioctl = 1;
 		break;
 
 	case VIAWGET_GET_SSID:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_GET_SSID\n");
+		pr_debug("VIAWGET_GET_SSID\n");
 		ret = wpa_get_ssid(pDevice, param);
 		wpa_ioctl = 1;
 		break;
 
 	case VIAWGET_GET_BSSID:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_GET_BSSID\n");
+		pr_debug("VIAWGET_GET_BSSID\n");
 		ret = wpa_get_bssid(pDevice, param);
 		wpa_ioctl = 1;
 		break;
 
 	case VIAWGET_SET_ASSOCIATE:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_ASSOCIATE\n");
+		pr_debug("VIAWGET_SET_ASSOCIATE\n");
 		ret = wpa_set_associate(pDevice, param);
 		break;
 
 	case VIAWGET_SET_DISASSOCIATE:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_DISASSOCIATE\n");
+		pr_debug("VIAWGET_SET_DISASSOCIATE\n");
 		ret = wpa_set_disassociate(pDevice, param);
 		break;
 
 	case VIAWGET_SET_DROP_UNENCRYPT:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_DROP_UNENCRYPT\n");
+		pr_debug("VIAWGET_SET_DROP_UNENCRYPT\n");
 		break;
 
 	case VIAWGET_SET_DEAUTHENTICATE:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_DEAUTHENTICATE\n");
+		pr_debug("VIAWGET_SET_DEAUTHENTICATE\n");
 		break;
 
 	default:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wpa_ioctl: unknown cmd=%d\n",
-			param->cmd);
+		pr_debug("wpa_ioctl: unknown cmd=%d\n",
+			 param->cmd);
 		ret = -EOPNOTSUPP;
 		goto out;
 	}
diff --git a/drivers/staging/vt6655/wroute.c b/drivers/staging/vt6655/wroute.c
index 44ce6e2..d1171fa 100644
--- a/drivers/staging/vt6655/wroute.c
+++ b/drivers/staging/vt6655/wroute.c
@@ -42,8 +42,6 @@
 
 /*---------------------  Static Classes  ----------------------------*/
 
-/*---------------------  Static Variables  --------------------------*/
-static int msglevel = MSG_LEVEL_INFO;
 /*---------------------  Static Functions  --------------------------*/
 
 /*---------------------  Export Variables  --------------------------*/
@@ -78,8 +76,7 @@ bool ROUTEbRelay(struct vnt_private *pDevice, unsigned char *pbySkbData,
 	unsigned char *pbyBSSID;
 
 	if (AVAIL_TD(pDevice, TYPE_AC0DMA) <= 0) {
-		DBG_PRT(MSG_LEVEL_DEBUG,
-			KERN_INFO "Relay can't allocate TD1..\n");
+		pr_debug("Relay can't allocate TD1..\n");
 		return false;
 	}
 
@@ -102,11 +99,10 @@ bool ROUTEbRelay(struct vnt_private *pDevice, unsigned char *pbySkbData,
 		if (KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID,
 		    GROUP_KEY, &pTransmitKey) == false) {
 			pTransmitKey = NULL;
-			DBG_PRT(MSG_LEVEL_DEBUG,
-				KERN_DEBUG "KEY is NULL. [%d]\n",
-				pDevice->pMgmt->eCurrMode);
+			pr_debug("KEY is NULL. [%d]\n",
+				 pDevice->pMgmt->eCurrMode);
 		} else {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG "Get GTK.\n");
+			pr_debug("Get GTK\n");
 		}
 	}
 


