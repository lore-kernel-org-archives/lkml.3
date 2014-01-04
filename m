Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbaADPZo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 10:25:44 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:49270 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754533AbaADPZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 10:25:38 -0500
From: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
To: sebastian.rachuj@studium.uni-erlangen.de
Cc: linux-kernel@i4.cs.fau.de, linux@rationality.eu,
        forest@alittletooquiet.net, gregkh@linuxfoundation.org,
        more.andres@gmail.com, tvboxspy@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/13] Staging: vt6656: Fix indentation of bssdb.c
Date: Sat,  4 Jan 2014 16:25:06 +0100
Message-Id: <1388849118-11994-2-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1388849118-11994-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
References: <1388849118-11994-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Schuster <linux@rationality.eu>

Corrects indentation by using tabs instead of spaces. This also
includes modification of the alignment of multi-line expressions and
statements.

Signed-off-by: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
Signed-off-by: Simon Schuster <linux@rationality.eu>
---
 drivers/staging/vt6656/bssdb.c | 2027 ++++++++++++++++++++--------------------
 1 file changed, 1016 insertions(+), 1011 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 8d2c43d..a670272 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -21,15 +21,15 @@
  * Purpose: Handles the Basic Service Set & Node Database functions
  *
  * Functions:
- *      BSSpSearchBSSList - Search known BSS list for Desire SSID or BSSID
- *      BSSvClearBSSList - Clear BSS List
- *      BSSbInsertToBSSList - Insert a BSS set into known BSS list
- *      BSSbUpdateToBSSList - Update BSS set in known BSS list
- *      BSSbIsSTAInNodeDB - Search Node DB table to find the index of matched DstAddr
- *      BSSvCreateOneNode - Allocate an Node for Node DB
- *      BSSvUpdateAPNode - Update AP Node content in Index 0 of KnownNodeDB
- *      BSSvSecondCallBack - One second timer callback function to update Node DB info & AP link status
- *      BSSvUpdateNodeTxCounter - Update Tx attemps, Tx failure counter in Node DB for auto-fall back rate control
+ *	BSSpSearchBSSList       - Search known BSS list for Desire SSID or BSSID
+ *	BSSvClearBSSList        - Clear BSS List
+ *	BSSbInsertToBSSList     - Insert a BSS set into known BSS list
+ *	BSSbUpdateToBSSList     - Update BSS set in known BSS list
+ *	BSSbIsSTAInNodeDB       - Search Node DB table to find the index of matched DstAddr
+ *	BSSvCreateOneNode       - Allocate an Node for Node DB
+ *	BSSvUpdateAPNode        - Update AP Node content in Index 0 of KnownNodeDB
+ *	BSSvSecondCallBack      - One second timer callback function to update Node DB info & AP link status
+ *	BSSvUpdateNodeTxCounter - Update Tx attemps, Tx failure counter in Node DB for auto-fallback rate control
  *
  * Revision History:
  *
@@ -59,23 +59,23 @@
 #include "iowpa.h"
 #include "power.h"
 
-static int          msglevel                =MSG_LEVEL_INFO;
-//static int          msglevel                =MSG_LEVEL_DEBUG;
-
-static const u16             awHWRetry0[5][5] = {
-                                            {RATE_18M, RATE_18M, RATE_12M, RATE_12M, RATE_12M},
-                                            {RATE_24M, RATE_24M, RATE_18M, RATE_12M, RATE_12M},
-                                            {RATE_36M, RATE_36M, RATE_24M, RATE_18M, RATE_18M},
-                                            {RATE_48M, RATE_48M, RATE_36M, RATE_24M, RATE_24M},
-                                            {RATE_54M, RATE_54M, RATE_48M, RATE_36M, RATE_36M}
-                                           };
-static const u16             awHWRetry1[5][5] = {
-                                            {RATE_18M, RATE_18M, RATE_12M, RATE_6M, RATE_6M},
-                                            {RATE_24M, RATE_24M, RATE_18M, RATE_6M, RATE_6M},
-                                            {RATE_36M, RATE_36M, RATE_24M, RATE_12M, RATE_12M},
-                                            {RATE_48M, RATE_48M, RATE_24M, RATE_12M, RATE_12M},
-                                            {RATE_54M, RATE_54M, RATE_36M, RATE_18M, RATE_18M}
-                                           };
+static int msglevel =MSG_LEVEL_INFO;
+//static int msglevel =MSG_LEVEL_DEBUG;
+
+static const u16 awHWRetry0[5][5] = {
+			{RATE_18M, RATE_18M, RATE_12M, RATE_12M, RATE_12M},
+			{RATE_24M, RATE_24M, RATE_18M, RATE_12M, RATE_12M},
+			{RATE_36M, RATE_36M, RATE_24M, RATE_18M, RATE_18M},
+			{RATE_48M, RATE_48M, RATE_36M, RATE_24M, RATE_24M},
+			{RATE_54M, RATE_54M, RATE_48M, RATE_36M, RATE_36M}
+		};
+static const u16 awHWRetry1[5][5] = {
+			{RATE_18M, RATE_18M, RATE_12M, RATE_6M, RATE_6M},
+			{RATE_24M, RATE_24M, RATE_18M, RATE_6M, RATE_6M},
+			{RATE_36M, RATE_36M, RATE_24M, RATE_12M, RATE_12M},
+			{RATE_48M, RATE_48M, RATE_24M, RATE_12M, RATE_12M},
+			{RATE_54M, RATE_54M, RATE_36M, RATE_18M, RATE_18M}
+		};
 
 static void s_vCheckSensitivity(struct vnt_private *pDevice);
 static void s_vCheckPreEDThreshold(struct vnt_private *pDevice);
@@ -84,16 +84,16 @@ static void s_uCalculateLinkQual(struct vnt_private *pDevice);
 /*+
  *
  * Routine Description:
- *    Search known BSS list for Desire SSID or BSSID.
+ *	  Search known BSS list for Desire SSID or BSSID.
  *
  * Return Value:
- *    PTR to KnownBSS or NULL
+ *	  PTR to KnownBSS or NULL
  *
 -*/
 
 PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
-		u8 *pbyDesireBSSID, u8 *pbyDesireSSID,
-		CARD_PHY_TYPE ePhyType)
+			    u8 *pbyDesireBSSID, u8 *pbyDesireSSID,
+			    CARD_PHY_TYPE ePhyType)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	u8 *pbyBSSID = NULL;
@@ -104,134 +104,134 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 	int ii = 0;
 	int jj = 0;
 
-    if (pbyDesireBSSID != NULL) {
+	if (pbyDesireBSSID != NULL) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 			"BSSpSearchBSSList BSSID[%pM]\n", pbyDesireBSSID);
-	if ((!is_broadcast_ether_addr(pbyDesireBSSID)) &&
-	     (memcmp(pbyDesireBSSID, ZeroBSSID, 6)!= 0)){
-            pbyBSSID = pbyDesireBSSID;
-        }
-    }
-    if (pbyDesireSSID != NULL) {
-        if (((PWLAN_IE_SSID)pbyDesireSSID)->len != 0) {
-            pSSID = (PWLAN_IE_SSID) pbyDesireSSID;
-        }
-    }
-
-    if ((pbyBSSID != NULL)&&(pDevice->bRoaming == false)) {
-        // match BSSID first
-        for (ii = 0; ii <MAX_BSS_NUM; ii++) {
-            pCurrBSS = &(pMgmt->sBSSList[ii]);
-
-	   pCurrBSS->bSelected = false;
-
-            if ((pCurrBSS->bActive) &&
-                (pCurrBSS->bSelected == false)) {
-		    if (ether_addr_equal(pCurrBSS->abyBSSID, pbyBSSID)) {
-                    if (pSSID != NULL) {
-                        // compare ssid
-                        if ( !memcmp(pSSID->abySSID,
-                            ((PWLAN_IE_SSID)pCurrBSS->abySSID)->abySSID,
-                            pSSID->len)) {
-                            if ((pMgmt->eConfigMode == WMAC_CONFIG_AUTO) ||
-                                ((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) && WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo)) ||
-                                ((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA) && WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo))
-                                ) {
-                                pCurrBSS->bSelected = true;
-                                return(pCurrBSS);
-                            }
-                        }
-                    } else {
-                        if ((pMgmt->eConfigMode == WMAC_CONFIG_AUTO) ||
-                            ((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) && WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo)) ||
-                            ((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA) && WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo))
-                            ) {
-                            pCurrBSS->bSelected = true;
-                            return(pCurrBSS);
-                        }
-                    }
-                }
-            }
-        }
-    } else {
-        // ignore BSSID
-        for (ii = 0; ii <MAX_BSS_NUM; ii++) {
-            pCurrBSS = &(pMgmt->sBSSList[ii]);
-
-           //2007-0721-01<Mark>by MikeLiu
-         //   if ((pCurrBSS->bActive) &&
-         //       (pCurrBSS->bSelected == false)) {
-
-	  pCurrBSS->bSelected = false;
-          if (pCurrBSS->bActive) {
-
-                if (pSSID != NULL) {
-                    // matched SSID
-                    if (memcmp(pSSID->abySSID,
-                        ((PWLAN_IE_SSID)pCurrBSS->abySSID)->abySSID,
-                        pSSID->len) ||
-                        (pSSID->len != ((PWLAN_IE_SSID)pCurrBSS->abySSID)->len)) {
-                        // SSID not match skip this BSS
-                        continue;
-                      }
-                }
-                if (((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) && WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo)) ||
-                    ((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA) && WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo))
-                    ){
-                    // Type not match skip this BSS
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"BSS type mismatch.... Config[%d] BSS[0x%04x]\n", pMgmt->eConfigMode, pCurrBSS->wCapInfo);
-                    continue;
-                }
-
-                if (ePhyType != PHY_TYPE_AUTO) {
-                    if (((ePhyType == PHY_TYPE_11A) && (PHY_TYPE_11A != pCurrBSS->eNetworkTypeInUse)) ||
-                        ((ePhyType != PHY_TYPE_11A) && (PHY_TYPE_11A == pCurrBSS->eNetworkTypeInUse))) {
-                        // PhyType not match skip this BSS
-                        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Physical type mismatch.... ePhyType[%d] BSS[%d]\n", ePhyType, pCurrBSS->eNetworkTypeInUse);
-                        continue;
-                    }
-                }
-
-        pMgmt->pSameBSS[jj].uChannel = pCurrBSS->uChannel;
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-			"BSSpSearchBSSList pSelect1[%pM]\n",
-			pCurrBSS->abyBSSID);
-        jj++;
-
-                if (pSelect == NULL) {
-                    pSelect = pCurrBSS;
-                } else {
-                    // compare RSSI, select the strongest signal 
-                    if (pCurrBSS->uRSSI < pSelect->uRSSI) {
-                        pSelect = pCurrBSS;
-                    }
-                }
-            }
-        }
-
-pDevice->bSameBSSMaxNum = jj;
-
-        if (pSelect != NULL) {
-            pSelect->bSelected = true;
-                        if (pDevice->bRoaming == false)  {
-	//       Einsn Add @20070907
-			memcpy(pbyDesireSSID,pCurrBSS->abySSID,WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1) ;
-                                                }
-
-            return(pSelect);
-        }
-    }
-    return(NULL);
+		if ((!is_broadcast_ether_addr(pbyDesireBSSID)) &&
+			(memcmp(pbyDesireBSSID, ZeroBSSID, 6)!= 0)){
+				pbyBSSID = pbyDesireBSSID;
+		}
+	}
+	if (pbyDesireSSID != NULL) {
+		if (((PWLAN_IE_SSID)pbyDesireSSID)->len != 0) {
+			pSSID = (PWLAN_IE_SSID) pbyDesireSSID;
+		}
+	}
+
+	if ((pbyBSSID != NULL)&&(pDevice->bRoaming == false)) {
+		// match BSSID first
+		for (ii = 0; ii <MAX_BSS_NUM; ii++) {
+			pCurrBSS = &(pMgmt->sBSSList[ii]);
+
+			pCurrBSS->bSelected = false;
+
+			if ((pCurrBSS->bActive) &&
+				(pCurrBSS->bSelected == false)) {
+				if (ether_addr_equal(pCurrBSS->abyBSSID, pbyBSSID)) {
+					if (pSSID != NULL) {
+						// compare ssid
+						if ( !memcmp(pSSID->abySSID,
+							((PWLAN_IE_SSID)pCurrBSS->abySSID)->abySSID,
+							pSSID->len)) {
+							if ((pMgmt->eConfigMode == WMAC_CONFIG_AUTO) ||
+								((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) && WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo)) ||
+								((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA) && WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo))
+								) {
+								pCurrBSS->bSelected = true;
+								return(pCurrBSS);
+							}
+						}
+					} else {
+						if ((pMgmt->eConfigMode == WMAC_CONFIG_AUTO) ||
+							((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) && WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo)) ||
+							((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA) && WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo))
+							) {
+							pCurrBSS->bSelected = true;
+							return(pCurrBSS);
+						}
+					}
+				}
+			}
+		}
+	} else {
+		// ignore BSSID
+		for (ii = 0; ii <MAX_BSS_NUM; ii++) {
+			pCurrBSS = &(pMgmt->sBSSList[ii]);
+
+			//2007-0721-01<Mark>by MikeLiu
+			//   if ((pCurrBSS->bActive) &&
+			//		  (pCurrBSS->bSelected == false)) {
+
+			pCurrBSS->bSelected = false;
+			if (pCurrBSS->bActive) {
+
+				if (pSSID != NULL) {
+					// matched SSID
+					if (memcmp(pSSID->abySSID,
+						((PWLAN_IE_SSID)pCurrBSS->abySSID)->abySSID,
+						pSSID->len) ||
+						(pSSID->len != ((PWLAN_IE_SSID)pCurrBSS->abySSID)->len)) {
+						// SSID not match skip this BSS
+						continue;
+					  }
+				}
+				if (((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) && WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo)) ||
+					((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA) && WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo))
+					){
+					// Type not match skip this BSS
+					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"BSS type mismatch.... Config[%d] BSS[0x%04x]\n", pMgmt->eConfigMode, pCurrBSS->wCapInfo);
+					continue;
+				}
+
+				if (ePhyType != PHY_TYPE_AUTO) {
+					if (((ePhyType == PHY_TYPE_11A) && (PHY_TYPE_11A != pCurrBSS->eNetworkTypeInUse)) ||
+						((ePhyType != PHY_TYPE_11A) && (PHY_TYPE_11A == pCurrBSS->eNetworkTypeInUse))) {
+						// PhyType not match skip this BSS
+						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Physical type mismatch.... ePhyType[%d] BSS[%d]\n", ePhyType, pCurrBSS->eNetworkTypeInUse);
+						continue;
+					}
+				}
+
+				pMgmt->pSameBSS[jj].uChannel = pCurrBSS->uChannel;
+				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+					"BSSpSearchBSSList pSelect1[%pM]\n",
+					pCurrBSS->abyBSSID);
+				jj++;
+
+				if (pSelect == NULL) {
+					pSelect = pCurrBSS;
+				} else {
+					// compare RSSI, select the strongest signal
+					if (pCurrBSS->uRSSI < pSelect->uRSSI) {
+						pSelect = pCurrBSS;
+					}
+				}
+			}
+		}
+
+		pDevice->bSameBSSMaxNum = jj;
+
+		if (pSelect != NULL) {
+			pSelect->bSelected = true;
+			if (pDevice->bRoaming == false)  {
+				// Einsn Add @20070907
+				memcpy(pbyDesireSSID,pCurrBSS->abySSID,WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1) ;
+			}
+
+			return(pSelect);
+		}
+	}
+	return(NULL);
 
 }
 
 /*+
  *
  * Routine Description:
- *    Clear BSS List
+ *	  Clear BSS List
  *
  * Return Value:
- *    None.
+ *	  None.
  *
 -*/
 
@@ -240,65 +240,70 @@ void BSSvClearBSSList(struct vnt_private *pDevice, int bKeepCurrBSSID)
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	int ii;
 
-    for (ii = 0; ii < MAX_BSS_NUM; ii++) {
-        if (bKeepCurrBSSID) {
-            if (pMgmt->sBSSList[ii].bActive &&
-		ether_addr_equal(pMgmt->sBSSList[ii].abyBSSID,
-				 pMgmt->abyCurrBSSID)) {
- //mike mark: there are two BSSID's in list. If that AP is in hidden ssid mode, one SSID is null,
- //                 but other's might not be obvious, so if it associate's with your STA,
- //                 you must keep the two of them!!
-               // bKeepCurrBSSID = false;
-                continue;
-            }
-        }
-
-	pMgmt->sBSSList[ii].bActive = false;
-        memset(&pMgmt->sBSSList[ii], 0, sizeof(KnownBSS));
-    }
-    BSSvClearAnyBSSJoinRecord(pDevice);
+	for (ii = 0; ii < MAX_BSS_NUM; ii++) {
+		if (bKeepCurrBSSID) {
+			if (pMgmt->sBSSList[ii].bActive &&
+				ether_addr_equal(pMgmt->sBSSList[ii].abyBSSID,
+				pMgmt->abyCurrBSSID)) {
+
+				//mike mark:
+				//there are two BSSID's in list. If that AP is
+				//in hidden ssid mode, one SSID is null, but
+				//other's might not be obvious, so if it
+				//associate's with your STA, you must keep the
+				//two of them!!  bKeepCurrBSSID = false;
+
+				continue;
+			}
+		}
+
+		pMgmt->sBSSList[ii].bActive = false;
+		memset(&pMgmt->sBSSList[ii], 0, sizeof(KnownBSS));
+	}
+	BSSvClearAnyBSSJoinRecord(pDevice);
 }
 
 /*+
  *
  * Routine Description:
- *    search BSS list by BSSID & SSID if matched
+ *	  search BSS list by BSSID & SSID if matched
  *
  * Return Value:
- *    true if found.
+ *	  true if found.
  *
 -*/
 PKnownBSS BSSpAddrIsInBSSList(struct vnt_private *pDevice,
-	u8 *abyBSSID, PWLAN_IE_SSID pSSID)
+			      u8 *abyBSSID,
+			      PWLAN_IE_SSID pSSID)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	PKnownBSS pBSSList = NULL;
 	int ii;
 
-    for (ii = 0; ii < MAX_BSS_NUM; ii++) {
-        pBSSList = &(pMgmt->sBSSList[ii]);
-        if (pBSSList->bActive) {
-		if (ether_addr_equal(pBSSList->abyBSSID, abyBSSID)) {
-                if (pSSID->len == ((PWLAN_IE_SSID)pBSSList->abySSID)->len){
-                    if (memcmp(pSSID->abySSID,
-                            ((PWLAN_IE_SSID)pBSSList->abySSID)->abySSID,
-                            pSSID->len) == 0)
-                        return pBSSList;
-                }
-            }
-        }
-    }
-
-    return NULL;
+	for (ii = 0; ii < MAX_BSS_NUM; ii++) {
+		pBSSList = &(pMgmt->sBSSList[ii]);
+		if (pBSSList->bActive) {
+			if (ether_addr_equal(pBSSList->abyBSSID, abyBSSID)) {
+				if (pSSID->len == ((PWLAN_IE_SSID)pBSSList->abySSID)->len){
+					if (memcmp(pSSID->abySSID,
+						((PWLAN_IE_SSID)pBSSList->abySSID)->abySSID,
+						pSSID->len) == 0)
+						return pBSSList;
+				}
+			}
+		}
+	}
+
+	return NULL;
 };
 
 /*+
  *
  * Routine Description:
- *    Insert a BSS set into known BSS list
+ *	  Insert a BSS set into known BSS list
  *
  * Return Value:
- *    true if success.
+ *	  true if success.
  *
 -*/
 
@@ -327,153 +332,153 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 	unsigned int ii;
 	bool bParsingQuiet = false;
 
-    pBSSList = (PKnownBSS)&(pMgmt->sBSSList[0]);
-
-    for (ii = 0; ii < MAX_BSS_NUM; ii++) {
-        pBSSList = (PKnownBSS)&(pMgmt->sBSSList[ii]);
-        if (!pBSSList->bActive)
-                break;
-    }
-
-    if (ii == MAX_BSS_NUM){
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Get free KnowBSS node failed.\n");
-        return false;
-    }
-    // save the BSS info
-    pBSSList->bActive = true;
-    memcpy( pBSSList->abyBSSID, abyBSSIDAddr, WLAN_BSSID_LEN);
+	pBSSList = (PKnownBSS)&(pMgmt->sBSSList[0]);
+
+	for (ii = 0; ii < MAX_BSS_NUM; ii++) {
+		pBSSList = (PKnownBSS)&(pMgmt->sBSSList[ii]);
+		if (!pBSSList->bActive)
+			break;
+	}
+
+	if (ii == MAX_BSS_NUM){
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Get free KnowBSS node failed.\n");
+		return false;
+	}
+	// save the BSS info
+	pBSSList->bActive = true;
+	memcpy( pBSSList->abyBSSID, abyBSSIDAddr, WLAN_BSSID_LEN);
 	pBSSList->qwBSSTimestamp = cpu_to_le64(qwTimestamp);
-    pBSSList->wBeaconInterval = cpu_to_le16(wBeaconInterval);
-    pBSSList->wCapInfo = cpu_to_le16(wCapInfo);
-    pBSSList->uClearCount = 0;
-
-    if (pSSID->len > WLAN_SSID_MAXLEN)
-        pSSID->len = WLAN_SSID_MAXLEN;
-    memcpy( pBSSList->abySSID, pSSID, pSSID->len + WLAN_IEHDR_LEN);
-
-    pBSSList->uChannel = byCurrChannel;
-
-    if (pSuppRates->len > WLAN_RATES_MAXLEN)
-        pSuppRates->len = WLAN_RATES_MAXLEN;
-    memcpy( pBSSList->abySuppRates, pSuppRates, pSuppRates->len + WLAN_IEHDR_LEN);
-
-    if (pExtSuppRates != NULL) {
-        if (pExtSuppRates->len > WLAN_RATES_MAXLEN)
-            pExtSuppRates->len = WLAN_RATES_MAXLEN;
-        memcpy(pBSSList->abyExtSuppRates, pExtSuppRates, pExtSuppRates->len + WLAN_IEHDR_LEN);
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"BSSbInsertToBSSList: pExtSuppRates->len = %d\n", pExtSuppRates->len);
-
-    } else {
-        memset(pBSSList->abyExtSuppRates, 0, WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1);
-    }
-    pBSSList->sERP.byERP = psERP->byERP;
-    pBSSList->sERP.bERPExist = psERP->bERPExist;
-
-    // Check if BSS is 802.11a/b/g
-    if (pBSSList->uChannel > CB_MAX_CHANNEL_24G) {
-        pBSSList->eNetworkTypeInUse = PHY_TYPE_11A;
-    } else {
-        if (pBSSList->sERP.bERPExist == true) {
-            pBSSList->eNetworkTypeInUse = PHY_TYPE_11G;
-        } else {
-            pBSSList->eNetworkTypeInUse = PHY_TYPE_11B;
-        }
-    }
-
-    pBSSList->byRxRate = pRxPacket->byRxRate;
-    pBSSList->qwLocalTSF = pRxPacket->qwLocalTSF;
-    pBSSList->uRSSI = pRxPacket->uRSSI;
-    pBSSList->bySQ = pRxPacket->bySQ;
-
-   if ((pMgmt->eCurrMode == WMAC_MODE_ESS_STA) &&
-        (pMgmt->eCurrState == WMAC_STATE_ASSOC)) {
-        // assoc with BSS
-        if (pBSSList == pMgmt->pCurrBSS) {
-            bParsingQuiet = true;
-        }
-    }
-
-    WPA_ClearRSN(pBSSList);
-
-    if (pRSNWPA != NULL) {
-	unsigned int uLen = pRSNWPA->len + 2;
-
-	if (uLen <= (uIELength -
-		     (unsigned int) (u32) ((u8 *) pRSNWPA - pbyIEs))) {
-		pBSSList->wWPALen = uLen;
-		memcpy(pBSSList->byWPAIE, pRSNWPA, uLen);
-		WPA_ParseRSN(pBSSList, pRSNWPA);
+	pBSSList->wBeaconInterval = cpu_to_le16(wBeaconInterval);
+	pBSSList->wCapInfo = cpu_to_le16(wCapInfo);
+	pBSSList->uClearCount = 0;
+
+	if (pSSID->len > WLAN_SSID_MAXLEN)
+		pSSID->len = WLAN_SSID_MAXLEN;
+	memcpy( pBSSList->abySSID, pSSID, pSSID->len + WLAN_IEHDR_LEN);
+
+	pBSSList->uChannel = byCurrChannel;
+
+	if (pSuppRates->len > WLAN_RATES_MAXLEN)
+		pSuppRates->len = WLAN_RATES_MAXLEN;
+	memcpy( pBSSList->abySuppRates, pSuppRates, pSuppRates->len + WLAN_IEHDR_LEN);
+
+	if (pExtSuppRates != NULL) {
+		if (pExtSuppRates->len > WLAN_RATES_MAXLEN)
+			pExtSuppRates->len = WLAN_RATES_MAXLEN;
+		memcpy(pBSSList->abyExtSuppRates, pExtSuppRates, pExtSuppRates->len + WLAN_IEHDR_LEN);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"BSSbInsertToBSSList: pExtSuppRates->len = %d\n", pExtSuppRates->len);
+
+	} else {
+		memset(pBSSList->abyExtSuppRates, 0, WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1);
 	}
-    }
+	pBSSList->sERP.byERP = psERP->byERP;
+	pBSSList->sERP.bERPExist = psERP->bERPExist;
 
-    WPA2_ClearRSN(pBSSList);
+	// Check if BSS is 802.11a/b/g
+	if (pBSSList->uChannel > CB_MAX_CHANNEL_24G) {
+		pBSSList->eNetworkTypeInUse = PHY_TYPE_11A;
+	} else {
+		if (pBSSList->sERP.bERPExist == true) {
+			pBSSList->eNetworkTypeInUse = PHY_TYPE_11G;
+		} else {
+			pBSSList->eNetworkTypeInUse = PHY_TYPE_11B;
+		}
+	}
 
-    if (pRSN != NULL) {
-	unsigned int uLen = pRSN->len + 2;
+	pBSSList->byRxRate = pRxPacket->byRxRate;
+	pBSSList->qwLocalTSF = pRxPacket->qwLocalTSF;
+	pBSSList->uRSSI = pRxPacket->uRSSI;
+	pBSSList->bySQ = pRxPacket->bySQ;
 
-	if (uLen <= (uIELength -
-		     (unsigned int) (u32) ((u8 *) pRSN - pbyIEs))) {
-		pBSSList->wRSNLen = uLen;
-		memcpy(pBSSList->byRSNIE, pRSN, uLen);
-		WPA2vParseRSN(pBSSList, pRSN);
+	if ((pMgmt->eCurrMode == WMAC_MODE_ESS_STA) &&
+		(pMgmt->eCurrState == WMAC_STATE_ASSOC)) {
+		// assoc with BSS
+		if (pBSSList == pMgmt->pCurrBSS) {
+			bParsingQuiet = true;
+		}
 	}
-    }
-
-    if ((pMgmt->eAuthenMode == WMAC_AUTH_WPA2) || (pBSSList->bWPA2Valid == true)) {
-
-        PSKeyItem  pTransmitKey = NULL;
-        bool       bIs802_1x = false;
-
-        for (ii = 0; ii < pBSSList->wAKMSSAuthCount; ii ++) {
-            if (pBSSList->abyAKMSSAuthType[ii] == WLAN_11i_AKMSS_802_1X) {
-                bIs802_1x = true;
-                break;
-            }
-        }
-        if ((bIs802_1x == true) && (pSSID->len == ((PWLAN_IE_SSID)pMgmt->abyDesireSSID)->len) &&
-            ( !memcmp(pSSID->abySSID, ((PWLAN_IE_SSID)pMgmt->abyDesireSSID)->abySSID, pSSID->len))) {
-
-		bAdd_PMKID_Candidate((void *) pDevice,
-				     pBSSList->abyBSSID,
-				     &pBSSList->sRSNCapObj);
-
-            if ((pDevice->bLinkPass == true) && (pMgmt->eCurrState == WMAC_STATE_ASSOC)) {
-                if ((KeybGetTransmitKey(&(pDevice->sKey), pDevice->abyBSSID, PAIRWISE_KEY, &pTransmitKey) == true) ||
-                    (KeybGetTransmitKey(&(pDevice->sKey), pDevice->abyBSSID, GROUP_KEY, &pTransmitKey) == true)) {
-                    pDevice->gsPMKIDCandidate.StatusType = Ndis802_11StatusType_PMKID_CandidateList;
-                    pDevice->gsPMKIDCandidate.Version = 1;
-
-                }
-
-            }
-        }
-    }
-
-    if (pDevice->bUpdateBBVGA) {
-        // Monitor if RSSI is too strong.
-        pBSSList->byRSSIStatCnt = 0;
-        RFvRSSITodBm(pDevice, (u8)(pRxPacket->uRSSI), &pBSSList->ldBmMAX);
-        pBSSList->ldBmAverage[0] = pBSSList->ldBmMAX;
-        pBSSList->ldBmAverRange = pBSSList->ldBmMAX;
-        for (ii = 1; ii < RSSI_STAT_COUNT; ii++)
-            pBSSList->ldBmAverage[ii] = 0;
-    }
-
-    pBSSList->uIELength = uIELength;
-    if (pBSSList->uIELength > WLAN_BEACON_FR_MAXLEN)
-        pBSSList->uIELength = WLAN_BEACON_FR_MAXLEN;
-    memcpy(pBSSList->abyIEs, pbyIEs, pBSSList->uIELength);
-
-    return true;
+
+	WPA_ClearRSN(pBSSList);
+
+	if (pRSNWPA != NULL) {
+		unsigned int uLen = pRSNWPA->len + 2;
+
+		if (uLen <= (uIELength -
+				(unsigned int) (u32) ((u8 *) pRSNWPA - pbyIEs))) {
+			pBSSList->wWPALen = uLen;
+			memcpy(pBSSList->byWPAIE, pRSNWPA, uLen);
+			WPA_ParseRSN(pBSSList, pRSNWPA);
+		}
+	}
+
+	WPA2_ClearRSN(pBSSList);
+
+	if (pRSN != NULL) {
+		unsigned int uLen = pRSN->len + 2;
+
+		if (uLen <= (uIELength -
+				(unsigned int) (u32) ((u8 *) pRSN - pbyIEs))) {
+			pBSSList->wRSNLen = uLen;
+			memcpy(pBSSList->byRSNIE, pRSN, uLen);
+			WPA2vParseRSN(pBSSList, pRSN);
+		}
+	}
+
+	if ((pMgmt->eAuthenMode == WMAC_AUTH_WPA2) || (pBSSList->bWPA2Valid == true)) {
+
+		PSKeyItem  pTransmitKey = NULL;
+		bool	   bIs802_1x = false;
+
+		for (ii = 0; ii < pBSSList->wAKMSSAuthCount; ii ++) {
+			if (pBSSList->abyAKMSSAuthType[ii] == WLAN_11i_AKMSS_802_1X) {
+				bIs802_1x = true;
+				break;
+			}
+		}
+		if ((bIs802_1x == true) && (pSSID->len == ((PWLAN_IE_SSID)pMgmt->abyDesireSSID)->len) &&
+			( !memcmp(pSSID->abySSID, ((PWLAN_IE_SSID)pMgmt->abyDesireSSID)->abySSID, pSSID->len))) {
+
+			bAdd_PMKID_Candidate((void *) pDevice,
+					 pBSSList->abyBSSID,
+					 &pBSSList->sRSNCapObj);
+
+			if ((pDevice->bLinkPass == true) && (pMgmt->eCurrState == WMAC_STATE_ASSOC)) {
+				if ((KeybGetTransmitKey(&(pDevice->sKey), pDevice->abyBSSID, PAIRWISE_KEY, &pTransmitKey) == true) ||
+					(KeybGetTransmitKey(&(pDevice->sKey), pDevice->abyBSSID, GROUP_KEY, &pTransmitKey) == true)) {
+					pDevice->gsPMKIDCandidate.StatusType = Ndis802_11StatusType_PMKID_CandidateList;
+					pDevice->gsPMKIDCandidate.Version = 1;
+
+				}
+
+			}
+		}
+	}
+
+	if (pDevice->bUpdateBBVGA) {
+		// Monitor if RSSI is too strong.
+		pBSSList->byRSSIStatCnt = 0;
+		RFvRSSITodBm(pDevice, (u8)(pRxPacket->uRSSI), &pBSSList->ldBmMAX);
+		pBSSList->ldBmAverage[0] = pBSSList->ldBmMAX;
+		pBSSList->ldBmAverRange = pBSSList->ldBmMAX;
+		for (ii = 1; ii < RSSI_STAT_COUNT; ii++)
+			pBSSList->ldBmAverage[ii] = 0;
+	}
+
+	pBSSList->uIELength = uIELength;
+	if (pBSSList->uIELength > WLAN_BEACON_FR_MAXLEN)
+		pBSSList->uIELength = WLAN_BEACON_FR_MAXLEN;
+	memcpy(pBSSList->abyIEs, pbyIEs, pBSSList->uIELength);
+
+	return true;
 }
 
 /*+
  *
  * Routine Description:
- *    Update BSS set in known BSS list
+ *	  Update BSS set in known BSS list
  *
  * Return Value:
- *    true if success.
+ *	  true if success.
  *
 -*/
 // TODO: input structure modify
@@ -504,202 +509,203 @@ int BSSbUpdateToBSSList(struct vnt_private *pDevice,
 	signed long ldBm, ldBmSum;
 	bool bParsingQuiet = false;
 
-    if (pBSSList == NULL)
-        return false;
+	if (pBSSList == NULL)
+		return false;
 
 	pBSSList->qwBSSTimestamp = cpu_to_le64(qwTimestamp);
 
-    pBSSList->wBeaconInterval = cpu_to_le16(wBeaconInterval);
-    pBSSList->wCapInfo = cpu_to_le16(wCapInfo);
-    pBSSList->uClearCount = 0;
-    pBSSList->uChannel = byCurrChannel;
-
-    if (pSSID->len > WLAN_SSID_MAXLEN)
-        pSSID->len = WLAN_SSID_MAXLEN;
-
-    if ((pSSID->len != 0) && (pSSID->abySSID[0] != 0))
-        memcpy(pBSSList->abySSID, pSSID, pSSID->len + WLAN_IEHDR_LEN);
-    memcpy(pBSSList->abySuppRates, pSuppRates,pSuppRates->len + WLAN_IEHDR_LEN);
-
-    if (pExtSuppRates != NULL) {
-        memcpy(pBSSList->abyExtSuppRates, pExtSuppRates,pExtSuppRates->len + WLAN_IEHDR_LEN);
-    } else {
-        memset(pBSSList->abyExtSuppRates, 0, WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1);
-    }
-    pBSSList->sERP.byERP = psERP->byERP;
-    pBSSList->sERP.bERPExist = psERP->bERPExist;
-
-    // Check if BSS is 802.11a/b/g
-    if (pBSSList->uChannel > CB_MAX_CHANNEL_24G) {
-        pBSSList->eNetworkTypeInUse = PHY_TYPE_11A;
-    } else {
-        if (pBSSList->sERP.bERPExist == true) {
-            pBSSList->eNetworkTypeInUse = PHY_TYPE_11G;
-        } else {
-            pBSSList->eNetworkTypeInUse = PHY_TYPE_11B;
-        }
-    }
-
-    pBSSList->byRxRate = pRxPacket->byRxRate;
-    pBSSList->qwLocalTSF = pRxPacket->qwLocalTSF;
-    if(bChannelHit)
-        pBSSList->uRSSI = pRxPacket->uRSSI;
-    pBSSList->bySQ = pRxPacket->bySQ;
-
-   if ((pMgmt->eCurrMode == WMAC_MODE_ESS_STA) &&
-        (pMgmt->eCurrState == WMAC_STATE_ASSOC)) {
-        // assoc with BSS
-        if (pBSSList == pMgmt->pCurrBSS) {
-            bParsingQuiet = true;
-        }
-    }
-
-   WPA_ClearRSN(pBSSList);         //mike update
-
-   if (pRSNWPA != NULL) {
-	unsigned int uLen = pRSNWPA->len + 2;
-	if (uLen <= (uIELength -
-		     (unsigned int) (u32) ((u8 *) pRSNWPA - pbyIEs))) {
-		pBSSList->wWPALen = uLen;
-		memcpy(pBSSList->byWPAIE, pRSNWPA, uLen);
-		WPA_ParseRSN(pBSSList, pRSNWPA);
+	pBSSList->wBeaconInterval = cpu_to_le16(wBeaconInterval);
+	pBSSList->wCapInfo = cpu_to_le16(wCapInfo);
+	pBSSList->uClearCount = 0;
+	pBSSList->uChannel = byCurrChannel;
+
+	if (pSSID->len > WLAN_SSID_MAXLEN)
+		pSSID->len = WLAN_SSID_MAXLEN;
+
+	if ((pSSID->len != 0) && (pSSID->abySSID[0] != 0))
+		memcpy(pBSSList->abySSID, pSSID, pSSID->len + WLAN_IEHDR_LEN);
+	memcpy(pBSSList->abySuppRates, pSuppRates,pSuppRates->len + WLAN_IEHDR_LEN);
+
+	if (pExtSuppRates != NULL) {
+		memcpy(pBSSList->abyExtSuppRates, pExtSuppRates,pExtSuppRates->len + WLAN_IEHDR_LEN);
+	} else {
+		memset(pBSSList->abyExtSuppRates, 0, WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1);
 	}
-   }
+	pBSSList->sERP.byERP = psERP->byERP;
+	pBSSList->sERP.bERPExist = psERP->bERPExist;
 
-   WPA2_ClearRSN(pBSSList);  //mike update
+	// Check if BSS is 802.11a/b/g
+	if (pBSSList->uChannel > CB_MAX_CHANNEL_24G) {
+		pBSSList->eNetworkTypeInUse = PHY_TYPE_11A;
+	} else {
+		if (pBSSList->sERP.bERPExist == true) {
+			pBSSList->eNetworkTypeInUse = PHY_TYPE_11G;
+		} else {
+			pBSSList->eNetworkTypeInUse = PHY_TYPE_11B;
+		}
+	}
 
-    if (pRSN != NULL) {
-	unsigned int uLen = pRSN->len + 2;
-	if (uLen <= (uIELength -
-			(unsigned int) (u32) ((u8 *) pRSN - pbyIEs))) {
-		pBSSList->wRSNLen = uLen;
-		memcpy(pBSSList->byRSNIE, pRSN, uLen);
-		WPA2vParseRSN(pBSSList, pRSN);
+	pBSSList->byRxRate = pRxPacket->byRxRate;
+	pBSSList->qwLocalTSF = pRxPacket->qwLocalTSF;
+	if(bChannelHit)
+		pBSSList->uRSSI = pRxPacket->uRSSI;
+	pBSSList->bySQ = pRxPacket->bySQ;
+
+	if ((pMgmt->eCurrMode == WMAC_MODE_ESS_STA) &&
+		(pMgmt->eCurrState == WMAC_STATE_ASSOC)) {
+		// assoc with BSS
+		if (pBSSList == pMgmt->pCurrBSS) {
+			bParsingQuiet = true;
+		}
 	}
-    }
-
-    if (pRxPacket->uRSSI != 0) {
-        RFvRSSITodBm(pDevice, (u8)(pRxPacket->uRSSI), &ldBm);
-        // Monitor if RSSI is too strong.
-        pBSSList->byRSSIStatCnt++;
-        pBSSList->byRSSIStatCnt %= RSSI_STAT_COUNT;
-        pBSSList->ldBmAverage[pBSSList->byRSSIStatCnt] = ldBm;
-        ldBmSum = 0;
-	for (ii = 0, jj = 0; ii < RSSI_STAT_COUNT; ii++) {
-		if (pBSSList->ldBmAverage[ii] != 0) {
-			pBSSList->ldBmMAX =
-				max(pBSSList->ldBmAverage[ii], ldBm);
-			ldBmSum +=
-				pBSSList->ldBmAverage[ii];
-			jj++;
+
+	WPA_ClearRSN(pBSSList); //mike update
+
+	if (pRSNWPA != NULL) {
+		unsigned int uLen = pRSNWPA->len + 2;
+		if (uLen <= (uIELength -
+				(unsigned int) (u32) ((u8 *) pRSNWPA - pbyIEs))) {
+			pBSSList->wWPALen = uLen;
+			memcpy(pBSSList->byWPAIE, pRSNWPA, uLen);
+			WPA_ParseRSN(pBSSList, pRSNWPA);
 		}
-        }
-        pBSSList->ldBmAverRange = ldBmSum /jj;
-    }
+	}
+
+	WPA2_ClearRSN(pBSSList); //mike update
 
-    pBSSList->uIELength = uIELength;
-    if (pBSSList->uIELength > WLAN_BEACON_FR_MAXLEN)
-        pBSSList->uIELength = WLAN_BEACON_FR_MAXLEN;
-    memcpy(pBSSList->abyIEs, pbyIEs, pBSSList->uIELength);
+	if (pRSN != NULL) {
+		unsigned int uLen = pRSN->len + 2;
+		if (uLen <= (uIELength -
+				(unsigned int) (u32) ((u8 *) pRSN - pbyIEs))) {
+			pBSSList->wRSNLen = uLen;
+			memcpy(pBSSList->byRSNIE, pRSN, uLen);
+			WPA2vParseRSN(pBSSList, pRSN);
+		}
+	}
 
-    return true;
+	if (pRxPacket->uRSSI != 0) {
+		RFvRSSITodBm(pDevice, (u8)(pRxPacket->uRSSI), &ldBm);
+		// Monitor if RSSI is too strong.
+		pBSSList->byRSSIStatCnt++;
+		pBSSList->byRSSIStatCnt %= RSSI_STAT_COUNT;
+		pBSSList->ldBmAverage[pBSSList->byRSSIStatCnt] = ldBm;
+		ldBmSum = 0;
+		for (ii = 0, jj = 0; ii < RSSI_STAT_COUNT; ii++) {
+			if (pBSSList->ldBmAverage[ii] != 0) {
+				pBSSList->ldBmMAX =
+					max(pBSSList->ldBmAverage[ii], ldBm);
+				ldBmSum +=
+					pBSSList->ldBmAverage[ii];
+				jj++;
+			}
+		}
+		pBSSList->ldBmAverRange = ldBmSum /jj;
+	}
+
+	pBSSList->uIELength = uIELength;
+	if (pBSSList->uIELength > WLAN_BEACON_FR_MAXLEN)
+		pBSSList->uIELength = WLAN_BEACON_FR_MAXLEN;
+	memcpy(pBSSList->abyIEs, pbyIEs, pBSSList->uIELength);
+
+	return true;
 }
 
 /*+
  *
  * Routine Description:
- *    Search Node DB table to find the index of matched DstAddr
+ *	  Search Node DB table to find the index of matched DstAddr
  *
  * Return Value:
- *    None
+ *	  None
  *
 -*/
 
 int BSSbIsSTAInNodeDB(struct vnt_private *pDevice,
-		u8 *abyDstAddr, u32 *puNodeIndex)
+		      u8 *abyDstAddr,
+		      u32 *puNodeIndex)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	unsigned int ii;
 
-    // Index = 0 reserved for AP Node
-    for (ii = 1; ii < (MAX_NODE_NUM + 1); ii++) {
-        if (pMgmt->sNodeDBTable[ii].bActive) {
-		if (ether_addr_equal(abyDstAddr,
-				     pMgmt->sNodeDBTable[ii].abyMACAddr)) {
-                *puNodeIndex = ii;
-                return true;
-            }
-        }
-    }
-
-   return false;
+	// Index = 0 reserved for AP Node
+	for (ii = 1; ii < (MAX_NODE_NUM + 1); ii++) {
+		if (pMgmt->sNodeDBTable[ii].bActive) {
+			if (ether_addr_equal(abyDstAddr,
+				pMgmt->sNodeDBTable[ii].abyMACAddr)) {
+				*puNodeIndex = ii;
+				return true;
+			}
+		}
+	}
+
+	return false;
 };
 
 /*+
  *
  * Routine Description:
- *    Find an empty node and allocate it; if no empty node
- *    is found, then use the most inactive one.
+ *	  Find an empty node and allocate it; if no empty node
+ *	  is found, then use the most inactive one.
  *
  * Return Value:
- *    None
+ *	  None
  *
 -*/
 void BSSvCreateOneNode(struct vnt_private *pDevice, u32 *puNodeIndex)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
-	int            ii;
+	int ii;
 	u32 BigestCount = 0;
 	u32 SelectIndex;
-	struct sk_buff  *skb;
-
-    // Index = 0 reserved for AP Node (In STA mode)
-    // Index = 0 reserved for Broadcast/MultiCast (In AP mode)
-    SelectIndex = 1;
-    for (ii = 1; ii < (MAX_NODE_NUM + 1); ii++) {
-        if (pMgmt->sNodeDBTable[ii].bActive) {
-            if (pMgmt->sNodeDBTable[ii].uInActiveCount > BigestCount) {
-                BigestCount = pMgmt->sNodeDBTable[ii].uInActiveCount;
-                SelectIndex = ii;
-            }
-        }
-        else {
-            break;
-        }
-    }
-
-    // if not found replace uInActiveCount with the largest one.
-    if ( ii == (MAX_NODE_NUM + 1)) {
-        *puNodeIndex = SelectIndex;
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Replace inactive node = %d\n", SelectIndex);
-        // clear ps buffer
-        if (pMgmt->sNodeDBTable[*puNodeIndex].sTxPSQueue.next != NULL) {
-      	    while ((skb = skb_dequeue(&pMgmt->sNodeDBTable[*puNodeIndex].sTxPSQueue)) != NULL)
-            dev_kfree_skb(skb);
-        }
-    }
-    else {
-        *puNodeIndex = ii;
-    }
-
-    memset(&pMgmt->sNodeDBTable[*puNodeIndex], 0, sizeof(KnownNodeDB));
-    pMgmt->sNodeDBTable[*puNodeIndex].bActive = true;
-    pMgmt->sNodeDBTable[*puNodeIndex].uRatePollTimeout = FALLBACK_POLL_SECOND;
-    // for AP mode PS queue
-    skb_queue_head_init(&pMgmt->sNodeDBTable[*puNodeIndex].sTxPSQueue);
-    pMgmt->sNodeDBTable[*puNodeIndex].byAuthSequence = 0;
-    pMgmt->sNodeDBTable[*puNodeIndex].wEnQueueCnt = 0;
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Create node index = %d\n", ii);
+	struct sk_buff *skb;
+
+	// Index = 0 reserved for AP Node (In STA mode)
+	// Index = 0 reserved for Broadcast/MultiCast (In AP mode)
+	SelectIndex = 1;
+	for (ii = 1; ii < (MAX_NODE_NUM + 1); ii++) {
+		if (pMgmt->sNodeDBTable[ii].bActive) {
+			if (pMgmt->sNodeDBTable[ii].uInActiveCount > BigestCount) {
+				BigestCount = pMgmt->sNodeDBTable[ii].uInActiveCount;
+				SelectIndex = ii;
+			}
+		}
+		else {
+			break;
+		}
+	}
+
+	// if not found replace uInActiveCount with the largest one.
+	if ( ii == (MAX_NODE_NUM + 1)) {
+		*puNodeIndex = SelectIndex;
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Replace inactive node = %d\n", SelectIndex);
+		// clear ps buffer
+		if (pMgmt->sNodeDBTable[*puNodeIndex].sTxPSQueue.next != NULL) {
+			while ((skb = skb_dequeue(&pMgmt->sNodeDBTable[*puNodeIndex].sTxPSQueue)) != NULL)
+				dev_kfree_skb(skb);
+		}
+	}
+	else {
+		*puNodeIndex = ii;
+	}
+
+	memset(&pMgmt->sNodeDBTable[*puNodeIndex], 0, sizeof(KnownNodeDB));
+	pMgmt->sNodeDBTable[*puNodeIndex].bActive = true;
+	pMgmt->sNodeDBTable[*puNodeIndex].uRatePollTimeout = FALLBACK_POLL_SECOND;
+	// for AP mode PS queue
+	skb_queue_head_init(&pMgmt->sNodeDBTable[*puNodeIndex].sTxPSQueue);
+	pMgmt->sNodeDBTable[*puNodeIndex].byAuthSequence = 0;
+	pMgmt->sNodeDBTable[*puNodeIndex].wEnQueueCnt = 0;
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Create node index = %d\n", ii);
 };
 
 /*+
  *
  * Routine Description:
- *    Remove Node by NodeIndex
+ *	  Remove Node by NodeIndex
  *
  *
  * Return Value:
- *    None
+ *	  None
  *
 -*/
 
@@ -707,72 +713,73 @@ void BSSvRemoveOneNode(struct vnt_private *pDevice, u32 uNodeIndex)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	u8 byMask[8] = {1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80};
-	struct sk_buff  *skb;
-
-    while ((skb = skb_dequeue(&pMgmt->sNodeDBTable[uNodeIndex].sTxPSQueue)) != NULL)
-            dev_kfree_skb(skb);
-    // clear context
-    memset(&pMgmt->sNodeDBTable[uNodeIndex], 0, sizeof(KnownNodeDB));
-    // clear tx bit map
-    pMgmt->abyPSTxMap[pMgmt->sNodeDBTable[uNodeIndex].wAID >> 3] &=  ~byMask[pMgmt->sNodeDBTable[uNodeIndex].wAID & 7];
+	struct sk_buff *skb;
+
+	while ((skb = skb_dequeue(&pMgmt->sNodeDBTable[uNodeIndex].sTxPSQueue)) != NULL)
+		dev_kfree_skb(skb);
+	// clear context
+	memset(&pMgmt->sNodeDBTable[uNodeIndex], 0, sizeof(KnownNodeDB));
+	// clear tx bit map
+	pMgmt->abyPSTxMap[pMgmt->sNodeDBTable[uNodeIndex].wAID >> 3] &=  ~byMask[pMgmt->sNodeDBTable[uNodeIndex].wAID & 7];
 };
 /*+
  *
  * Routine Description:
- *    Update AP Node content in Index 0 of KnownNodeDB
+ *	  Update AP Node content in Index 0 of KnownNodeDB
  *
  *
  * Return Value:
- *    None
+ *	  None
  *
 -*/
 
-void BSSvUpdateAPNode(struct vnt_private *pDevice, u16 *pwCapInfo,
-	PWLAN_IE_SUPP_RATES pSuppRates, PWLAN_IE_SUPP_RATES pExtSuppRates)
+void BSSvUpdateAPNode(struct vnt_private *pDevice,
+		      u16 *pwCapInfo,
+		      PWLAN_IE_SUPP_RATES pSuppRates,
+		      PWLAN_IE_SUPP_RATES pExtSuppRates)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	u32 uRateLen = WLAN_RATES_MAXLEN;
 
-    memset(&pMgmt->sNodeDBTable[0], 0, sizeof(KnownNodeDB));
-
-    pMgmt->sNodeDBTable[0].bActive = true;
-    if (pDevice->byBBType == BB_TYPE_11B) {
-        uRateLen = WLAN_RATES_MAXLEN_11B;
-    }
-    pMgmt->abyCurrSuppRates[1] = RATEuSetIE((PWLAN_IE_SUPP_RATES)pSuppRates,
-                                            (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
-                                            uRateLen);
-    pMgmt->abyCurrExtSuppRates[1] = RATEuSetIE((PWLAN_IE_SUPP_RATES)pExtSuppRates,
-                                            (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrExtSuppRates,
-                                            uRateLen);
-    RATEvParseMaxRate((void *) pDevice,
-                       (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
-                       (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrExtSuppRates,
-                       true,
-                       &(pMgmt->sNodeDBTable[0].wMaxBasicRate),
-                       &(pMgmt->sNodeDBTable[0].wMaxSuppRate),
-                       &(pMgmt->sNodeDBTable[0].wSuppRate),
-                       &(pMgmt->sNodeDBTable[0].byTopCCKBasicRate),
-                       &(pMgmt->sNodeDBTable[0].byTopOFDMBasicRate)
-                      );
-    memcpy(pMgmt->sNodeDBTable[0].abyMACAddr, pMgmt->abyCurrBSSID, WLAN_ADDR_LEN);
-    pMgmt->sNodeDBTable[0].wTxDataRate = pMgmt->sNodeDBTable[0].wMaxSuppRate;
-    pMgmt->sNodeDBTable[0].bShortPreamble = WLAN_GET_CAP_INFO_SHORTPREAMBLE(*pwCapInfo);
-    pMgmt->sNodeDBTable[0].uRatePollTimeout = FALLBACK_POLL_SECOND;
-    // Auto rate fallback function initiation.
-    // RATEbInit(pDevice);
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pMgmt->sNodeDBTable[0].wTxDataRate = %d \n", pMgmt->sNodeDBTable[0].wTxDataRate);
+	memset(&pMgmt->sNodeDBTable[0], 0, sizeof(KnownNodeDB));
+
+	pMgmt->sNodeDBTable[0].bActive = true;
+	if (pDevice->byBBType == BB_TYPE_11B) {
+		uRateLen = WLAN_RATES_MAXLEN_11B;
+	}
+	pMgmt->abyCurrSuppRates[1] = RATEuSetIE((PWLAN_IE_SUPP_RATES)pSuppRates,
+						(PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
+						uRateLen);
+	pMgmt->abyCurrExtSuppRates[1] = RATEuSetIE((PWLAN_IE_SUPP_RATES)pExtSuppRates,
+						(PWLAN_IE_SUPP_RATES)pMgmt->abyCurrExtSuppRates,
+						uRateLen);
+	RATEvParseMaxRate((void *) pDevice,
+			  (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
+			  (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrExtSuppRates,
+			  true,
+			  &(pMgmt->sNodeDBTable[0].wMaxBasicRate),
+			  &(pMgmt->sNodeDBTable[0].wMaxSuppRate),
+			  &(pMgmt->sNodeDBTable[0].wSuppRate),
+			  &(pMgmt->sNodeDBTable[0].byTopCCKBasicRate),
+			  &(pMgmt->sNodeDBTable[0].byTopOFDMBasicRate));
+	memcpy(pMgmt->sNodeDBTable[0].abyMACAddr, pMgmt->abyCurrBSSID, WLAN_ADDR_LEN);
+	pMgmt->sNodeDBTable[0].wTxDataRate = pMgmt->sNodeDBTable[0].wMaxSuppRate;
+	pMgmt->sNodeDBTable[0].bShortPreamble = WLAN_GET_CAP_INFO_SHORTPREAMBLE(*pwCapInfo);
+	pMgmt->sNodeDBTable[0].uRatePollTimeout = FALLBACK_POLL_SECOND;
+	// Auto rate fallback function initiation.
+	// RATEbInit(pDevice);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pMgmt->sNodeDBTable[0].wTxDataRate = %d \n", pMgmt->sNodeDBTable[0].wTxDataRate);
 
 };
 
 /*+
  *
  * Routine Description:
- *    Add Multicast Node content in Index 0 of KnownNodeDB
+ *	  Add Multicast Node content in Index 0 of KnownNodeDB
  *
  *
  * Return Value:
- *    None
+ *	  None
  *
 -*/
 
@@ -780,24 +787,23 @@ void BSSvAddMulticastNode(struct vnt_private *pDevice)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 
-    if (!pDevice->bEnableHostWEP)
-        memset(&pMgmt->sNodeDBTable[0], 0, sizeof(KnownNodeDB));
-    memset(pMgmt->sNodeDBTable[0].abyMACAddr, 0xff, WLAN_ADDR_LEN);
-    pMgmt->sNodeDBTable[0].bActive = true;
-    pMgmt->sNodeDBTable[0].bPSEnable = false;
-    skb_queue_head_init(&pMgmt->sNodeDBTable[0].sTxPSQueue);
-    RATEvParseMaxRate((void *) pDevice,
-                      (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
-                      (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrExtSuppRates,
-                      true,
-                      &(pMgmt->sNodeDBTable[0].wMaxBasicRate),
-                      &(pMgmt->sNodeDBTable[0].wMaxSuppRate),
-                       &(pMgmt->sNodeDBTable[0].wSuppRate),
-                      &(pMgmt->sNodeDBTable[0].byTopCCKBasicRate),
-                      &(pMgmt->sNodeDBTable[0].byTopOFDMBasicRate)
-                     );
-    pMgmt->sNodeDBTable[0].wTxDataRate = pMgmt->sNodeDBTable[0].wMaxBasicRate;
-    pMgmt->sNodeDBTable[0].uRatePollTimeout = FALLBACK_POLL_SECOND;
+	if (!pDevice->bEnableHostWEP)
+		memset(&pMgmt->sNodeDBTable[0], 0, sizeof(KnownNodeDB));
+	memset(pMgmt->sNodeDBTable[0].abyMACAddr, 0xff, WLAN_ADDR_LEN);
+	pMgmt->sNodeDBTable[0].bActive = true;
+	pMgmt->sNodeDBTable[0].bPSEnable = false;
+	skb_queue_head_init(&pMgmt->sNodeDBTable[0].sTxPSQueue);
+	RATEvParseMaxRate((void *) pDevice,
+			  (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
+			  (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrExtSuppRates,
+			  true,
+			  &(pMgmt->sNodeDBTable[0].wMaxBasicRate),
+			  &(pMgmt->sNodeDBTable[0].wMaxSuppRate),
+			  &(pMgmt->sNodeDBTable[0].wSuppRate),
+			  &(pMgmt->sNodeDBTable[0].byTopCCKBasicRate),
+			  &(pMgmt->sNodeDBTable[0].byTopOFDMBasicRate));
+	pMgmt->sNodeDBTable[0].wTxDataRate = pMgmt->sNodeDBTable[0].wMaxBasicRate;
+	pMgmt->sNodeDBTable[0].uRatePollTimeout = FALLBACK_POLL_SECOND;
 
 };
 
@@ -806,11 +812,11 @@ void BSSvAddMulticastNode(struct vnt_private *pDevice)
  * Routine Description:
  *
  *
- *  Second call back function to update Node DB info & AP link status
+ *	Second call back function to update Node DB info & AP link status
  *
  *
  * Return Value:
- *    none.
+ *	  none.
  *
 -*/
 
@@ -828,302 +834,301 @@ void BSSvSecondCallBack(struct work_struct *work)
 	if (pDevice->Flags & fMP_DISCONNECTED)
 		return;
 
-    spin_lock_irq(&pDevice->lock);
-
-    pDevice->uAssocCount = 0;
-
-    //Power Saving Mode Tx Burst
-    if ( pDevice->bEnablePSMode == true ) {
-        pDevice->ulPSModeWaitTx++;
-        if ( pDevice->ulPSModeWaitTx >= 2 ) {
-            pDevice->ulPSModeWaitTx = 0;
-            pDevice->bPSModeTxBurst = false;
-        }
-    }
-
-    pDevice->byERPFlag &=
-        ~(WLAN_SET_ERP_BARKER_MODE(1) | WLAN_SET_ERP_NONERP_PRESENT(1));
-
-    if (pDevice->wUseProtectCntDown > 0) {
-        pDevice->wUseProtectCntDown --;
-    }
-    else {
-        // disable protect mode
-        pDevice->byERPFlag &= ~(WLAN_SET_ERP_USE_PROTECTION(1));
-    }
-
-if(pDevice->byReAssocCount > 0) {
-       pDevice->byReAssocCount++;
-   if((pDevice->byReAssocCount > 10) && (pDevice->bLinkPass != true)) {  //10 sec timeout
-                     printk("Re-association timeout!!!\n");
-		   pDevice->byReAssocCount = 0;
-                    // if(pDevice->bWPASuppWextEnabled == true)
-                        {
-                  	union iwreq_data  wrqu;
-                  	memset(&wrqu, 0, sizeof (wrqu));
-                          wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-                  	PRINT_K("wireless_send_event--->SIOCGIWAP(disassociated)\n");
-                  	wireless_send_event(pDevice->dev, SIOCGIWAP, &wrqu, NULL);
-                       }
-     }
-   else if(pDevice->bLinkPass == true)
-   	pDevice->byReAssocCount = 0;
-}
+	spin_lock_irq(&pDevice->lock);
+
+	pDevice->uAssocCount = 0;
+
+	//Power Saving Mode Tx Burst
+	if ( pDevice->bEnablePSMode == true ) {
+		pDevice->ulPSModeWaitTx++;
+		if ( pDevice->ulPSModeWaitTx >= 2 ) {
+			pDevice->ulPSModeWaitTx = 0;
+			pDevice->bPSModeTxBurst = false;
+		}
+	}
+
+	pDevice->byERPFlag &=
+		~(WLAN_SET_ERP_BARKER_MODE(1) | WLAN_SET_ERP_NONERP_PRESENT(1));
+
+	if (pDevice->wUseProtectCntDown > 0) {
+		pDevice->wUseProtectCntDown --;
+	}
+	else {
+		// disable protect mode
+		pDevice->byERPFlag &= ~(WLAN_SET_ERP_USE_PROTECTION(1));
+	}
 
- pMgmt->eLastState = pMgmt->eCurrState ;
+	if(pDevice->byReAssocCount > 0) {
+		pDevice->byReAssocCount++;
+		if((pDevice->byReAssocCount > 10) && (pDevice->bLinkPass != true)) {  //10 sec timeout
+			printk("Re-association timeout!!!\n");
+			pDevice->byReAssocCount = 0;
+			// if(pDevice->bWPASuppWextEnabled == true)
+			{
+				union iwreq_data  wrqu;
+				memset(&wrqu, 0, sizeof (wrqu));
+				wrqu.ap_addr.sa_family = ARPHRD_ETHER;
+				PRINT_K("wireless_send_event--->SIOCGIWAP(disassociated)\n");
+				wireless_send_event(pDevice->dev, SIOCGIWAP, &wrqu, NULL);
+			}
+		}
+		else if(pDevice->bLinkPass == true)
+			pDevice->byReAssocCount = 0;
+	}
+
+	pMgmt->eLastState = pMgmt->eCurrState ;
 
 	s_uCalculateLinkQual(pDevice);
 
-    for (ii = 0; ii < (MAX_NODE_NUM + 1); ii++) {
-
-        if (pMgmt->sNodeDBTable[ii].bActive) {
-            // Increase in-activity counter
-            pMgmt->sNodeDBTable[ii].uInActiveCount++;
-
-            if (ii > 0) {
-                if (pMgmt->sNodeDBTable[ii].uInActiveCount > MAX_INACTIVE_COUNT) {
-                    BSSvRemoveOneNode(pDevice, ii);
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-                        "Inactive timeout [%d] sec, STA index = [%d] remove\n", MAX_INACTIVE_COUNT, ii);
-                    continue;
-                }
-
-                if (pMgmt->sNodeDBTable[ii].eNodeState >= NODE_ASSOC) {
-
-                    pDevice->uAssocCount++;
-
-                    // check if Non ERP exist
-                    if (pMgmt->sNodeDBTable[ii].uInActiveCount < ERP_RECOVER_COUNT) {
-                        if (!pMgmt->sNodeDBTable[ii].bShortPreamble) {
-                            pDevice->byERPFlag |= WLAN_SET_ERP_BARKER_MODE(1);
-                            uLongPreambleSTACnt ++;
-                        }
-                        if (!pMgmt->sNodeDBTable[ii].bERPExist) {
-                            pDevice->byERPFlag |= WLAN_SET_ERP_NONERP_PRESENT(1);
-                            pDevice->byERPFlag |= WLAN_SET_ERP_USE_PROTECTION(1);
-                        }
-                        if (!pMgmt->sNodeDBTable[ii].bShortSlotTime)
-                            uNonShortSlotSTACnt++;
-                    }
-                }
-
-                // check if any STA in PS mode
-                if (pMgmt->sNodeDBTable[ii].bPSEnable)
-                    uSleepySTACnt++;
-
-            }
-
-            // Rate fallback check
-            if (!pDevice->bFixRate) {
-                if (ii > 0) {
-                    // ii = 0 for multicast node (AP & Adhoc)
-			RATEvTxRateFallBack((void *)pDevice,
-					    &(pMgmt->sNodeDBTable[ii]));
-                }
-                else {
-                    // ii = 0 reserved for unicast AP node (Infra STA)
-			if (pMgmt->eCurrMode == WMAC_MODE_ESS_STA)
-				RATEvTxRateFallBack((void *)pDevice,
-						    &(pMgmt->sNodeDBTable[ii]));
-                }
-
-            }
-
-            // check if pending PS queue
-            if (pMgmt->sNodeDBTable[ii].wEnQueueCnt != 0) {
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Index= %d, Queue = %d pending \n",
-                           ii, pMgmt->sNodeDBTable[ii].wEnQueueCnt);
-                if ((ii >0) && (pMgmt->sNodeDBTable[ii].wEnQueueCnt > 15)) {
-                    BSSvRemoveOneNode(pDevice, ii);
-                    DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Pending many queues PS STA Index = %d remove \n", ii);
-                    continue;
-                }
-            }
-        }
-
-    }
-
-    if ((pMgmt->eCurrMode == WMAC_MODE_ESS_AP) && (pDevice->byBBType == BB_TYPE_11G)) {
-
-        // on/off protect mode
-        if (WLAN_GET_ERP_USE_PROTECTION(pDevice->byERPFlag)) {
-            if (!pDevice->bProtectMode) {
-                MACvEnableProtectMD(pDevice);
-                pDevice->bProtectMode = true;
-            }
-        }
-        else {
-            if (pDevice->bProtectMode) {
-                MACvDisableProtectMD(pDevice);
-                pDevice->bProtectMode = false;
-            }
-        }
-        // on/off short slot time
-
-        if (uNonShortSlotSTACnt > 0) {
-            if (pDevice->bShortSlotTime) {
-                pDevice->bShortSlotTime = false;
-                BBvSetShortSlotTime(pDevice);
-		vUpdateIFS((void *)pDevice);
-            }
-        }
-        else {
-            if (!pDevice->bShortSlotTime) {
-                pDevice->bShortSlotTime = true;
-                BBvSetShortSlotTime(pDevice);
-		vUpdateIFS((void *)pDevice);
-            }
-        }
-
-        // on/off barker long preamble mode
-
-        if (uLongPreambleSTACnt > 0) {
-            if (!pDevice->bBarkerPreambleMd) {
-                MACvEnableBarkerPreambleMd(pDevice);
-                pDevice->bBarkerPreambleMd = true;
-            }
-        }
-        else {
-            if (pDevice->bBarkerPreambleMd) {
-                MACvDisableBarkerPreambleMd(pDevice);
-                pDevice->bBarkerPreambleMd = false;
-            }
-        }
-
-    }
-
-    // Check if any STA in PS mode, enable DTIM multicast deliver
-    if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
-        if (uSleepySTACnt > 0)
-            pMgmt->sNodeDBTable[0].bPSEnable = true;
-        else
-            pMgmt->sNodeDBTable[0].bPSEnable = false;
-    }
-
-    pItemSSID = (PWLAN_IE_SSID)pMgmt->abyDesireSSID;
-    pCurrSSID = (PWLAN_IE_SSID)pMgmt->abyCurrSSID;
-
-    if ((pMgmt->eCurrMode == WMAC_MODE_STANDBY) ||
-        (pMgmt->eCurrMode == WMAC_MODE_ESS_STA)) {
-
-        if (pMgmt->sNodeDBTable[0].bActive) { // Assoc with BSS
-
-            if (pDevice->bUpdateBBVGA) {
-		s_vCheckSensitivity(pDevice);
-		s_vCheckPreEDThreshold(pDevice);
-            }
-
-    	    if ((pMgmt->sNodeDBTable[0].uInActiveCount >= (LOST_BEACON_COUNT/2)) &&
-    	        (pDevice->byBBVGACurrent != pDevice->abyBBVGA[0]) ) {
-    	        pDevice->byBBVGANew = pDevice->abyBBVGA[0];
-		bScheduleCommand((void *) pDevice,
-				 WLAN_CMD_CHANGE_BBSENSITIVITY,
-				 NULL);
-    	    }
-
-        	if (pMgmt->sNodeDBTable[0].uInActiveCount >= LOST_BEACON_COUNT) {
-                pMgmt->sNodeDBTable[0].bActive = false;
-                pMgmt->eCurrMode = WMAC_MODE_STANDBY;
-                pMgmt->eCurrState = WMAC_STATE_IDLE;
-                netif_stop_queue(pDevice->dev);
-                pDevice->bLinkPass = false;
-                ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_SLOW);
-                pDevice->bRoaming = true;
-                pDevice->bIsRoaming = false;
-
-                DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Lost AP beacon [%d] sec, disconnected !\n", pMgmt->sNodeDBTable[0].uInActiveCount);
-		/* let wpa supplicant know AP may disconnect */
-      {
-	union iwreq_data  wrqu;
-	memset(&wrqu, 0, sizeof (wrqu));
-        wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-	PRINT_K("wireless_send_event--->SIOCGIWAP(disassociated)\n");
-	wireless_send_event(pDevice->dev, SIOCGIWAP, &wrqu, NULL);
-     }
-            }
-        }
-        else if (pItemSSID->len != 0) {
-//Davidwang
-      if ((pDevice->bEnableRoaming == true)&&(!(pMgmt->Cisco_cckm))) {
-DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bRoaming %d, !\n", pDevice->bRoaming );
-DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bIsRoaming %d, !\n", pDevice->bIsRoaming );
-          if ((pDevice->bRoaming == true)&&(pDevice->bIsRoaming == true)){
-	    	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Fast   Roaming ...\n");
-		BSSvClearBSSList((void *) pDevice, pDevice->bLinkPass);
-		bScheduleCommand((void *) pDevice,
-				 WLAN_CMD_BSSID_SCAN,
-				 pMgmt->abyDesireSSID);
-		bScheduleCommand((void *) pDevice,
-				 WLAN_CMD_SSID,
-				 pMgmt->abyDesireSSID);
-                pDevice->uAutoReConnectTime = 0;
-                pDevice->uIsroamingTime = 0;
-                pDevice->bRoaming = false;
-          }
-      else if ((pDevice->bRoaming == false)&&(pDevice->bIsRoaming == true)) {
-                            pDevice->uIsroamingTime++;
-       if (pDevice->uIsroamingTime >= 20)
-            pDevice->bIsRoaming = false;
-         }
-
-   }
-else {
-            if (pDevice->uAutoReConnectTime < 10) {
-                pDevice->uAutoReConnectTime++;
-                //network manager support need not do Roaming scan???
-                if(pDevice->bWPASuppWextEnabled ==true)
-		 pDevice->uAutoReConnectTime = 0;
-            }
-            else {
-	    //mike use old encryption status for wpa reauthen
-	      if(pDevice->bWPADEVUp)
-	          pDevice->eEncryptionStatus = pDevice->eOldEncryptionStatus;
-
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Roaming ...\n");
-		BSSvClearBSSList((void *) pDevice, pDevice->bLinkPass);
-		pMgmt->eScanType = WMAC_SCAN_ACTIVE;
-		bScheduleCommand((void *) pDevice,
-				 WLAN_CMD_BSSID_SCAN,
-				 pMgmt->abyDesireSSID);
-		bScheduleCommand((void *) pDevice,
-				 WLAN_CMD_SSID,
-				 pMgmt->abyDesireSSID);
-                pDevice->uAutoReConnectTime = 0;
-            }
-        }
-    }
-    }
-
-    if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) {
-        // if adhoc started which essid is NULL string, rescanning.
-        if ((pMgmt->eCurrState == WMAC_STATE_STARTED) && (pCurrSSID->len == 0)) {
-            if (pDevice->uAutoReConnectTime < 10) {
-                pDevice->uAutoReConnectTime++;
-            }
-            else {
-                DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Adhoc re-scanning ...\n");
-	       pMgmt->eScanType = WMAC_SCAN_ACTIVE;
-		bScheduleCommand((void *) pDevice, WLAN_CMD_BSSID_SCAN, NULL);
-		bScheduleCommand((void *) pDevice, WLAN_CMD_SSID, NULL);
-                pDevice->uAutoReConnectTime = 0;
-            };
-        }
-        if (pMgmt->eCurrState == WMAC_STATE_JOINTED) {
-
-		if (pDevice->bUpdateBBVGA) {
-			s_vCheckSensitivity(pDevice);
-			s_vCheckPreEDThreshold(pDevice);
+	for (ii = 0; ii < (MAX_NODE_NUM + 1); ii++) {
+
+		if (pMgmt->sNodeDBTable[ii].bActive) {
+			// Increase in-activity counter
+			pMgmt->sNodeDBTable[ii].uInActiveCount++;
+
+			if (ii > 0) {
+				if (pMgmt->sNodeDBTable[ii].uInActiveCount > MAX_INACTIVE_COUNT) {
+					BSSvRemoveOneNode(pDevice, ii);
+					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+						"Inactive timeout [%d] sec, STA index = [%d] remove\n", MAX_INACTIVE_COUNT, ii);
+					continue;
+				}
+
+				if (pMgmt->sNodeDBTable[ii].eNodeState >= NODE_ASSOC) {
+
+					pDevice->uAssocCount++;
+
+					// check if Non ERP exist
+					if (pMgmt->sNodeDBTable[ii].uInActiveCount < ERP_RECOVER_COUNT) {
+						if (!pMgmt->sNodeDBTable[ii].bShortPreamble) {
+							pDevice->byERPFlag |= WLAN_SET_ERP_BARKER_MODE(1);
+							uLongPreambleSTACnt ++;
+						}
+						if (!pMgmt->sNodeDBTable[ii].bERPExist) {
+							pDevice->byERPFlag |= WLAN_SET_ERP_NONERP_PRESENT(1);
+							pDevice->byERPFlag |= WLAN_SET_ERP_USE_PROTECTION(1);
+						}
+						if (!pMgmt->sNodeDBTable[ii].bShortSlotTime)
+							uNonShortSlotSTACnt++;
+					}
+				}
+
+				// check if any STA in PS mode
+				if (pMgmt->sNodeDBTable[ii].bPSEnable)
+					uSleepySTACnt++;
+
+			}
+
+			// Rate fallback check
+			if (!pDevice->bFixRate) {
+				if (ii > 0) {
+					// ii = 0 for multicast node (AP & Adhoc)
+					RATEvTxRateFallBack((void *)pDevice,
+						&(pMgmt->sNodeDBTable[ii]));
+				}
+				else {
+					// ii = 0 reserved for unicast AP node (Infra STA)
+					if (pMgmt->eCurrMode == WMAC_MODE_ESS_STA)
+						RATEvTxRateFallBack((void *)pDevice,
+							&(pMgmt->sNodeDBTable[ii]));
+				}
+
+			}
+
+			// check if pending PS queue
+			if (pMgmt->sNodeDBTable[ii].wEnQueueCnt != 0) {
+				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Index= %d, Queue = %d pending \n",
+						   ii, pMgmt->sNodeDBTable[ii].wEnQueueCnt);
+				if ((ii >0) && (pMgmt->sNodeDBTable[ii].wEnQueueCnt > 15)) {
+					BSSvRemoveOneNode(pDevice, ii);
+					DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Pending many queues PS STA Index = %d remove \n", ii);
+					continue;
+				}
+			}
 		}
-        	if (pMgmt->sNodeDBTable[0].uInActiveCount >=ADHOC_LOST_BEACON_COUNT) {
-        	    DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Lost other STA beacon [%d] sec, started !\n", pMgmt->sNodeDBTable[0].uInActiveCount);
-                pMgmt->sNodeDBTable[0].uInActiveCount = 0;
-                pMgmt->eCurrState = WMAC_STATE_STARTED;
-                netif_stop_queue(pDevice->dev);
-                pDevice->bLinkPass = false;
-                ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_SLOW);
-            }
-        }
-    }
+
+	}
+
+	if ((pMgmt->eCurrMode == WMAC_MODE_ESS_AP) && (pDevice->byBBType == BB_TYPE_11G)) {
+
+		// on/off protect mode
+		if (WLAN_GET_ERP_USE_PROTECTION(pDevice->byERPFlag)) {
+			if (!pDevice->bProtectMode) {
+				MACvEnableProtectMD(pDevice);
+				pDevice->bProtectMode = true;
+			}
+		}
+		else {
+			if (pDevice->bProtectMode) {
+				MACvDisableProtectMD(pDevice);
+				pDevice->bProtectMode = false;
+			}
+		}
+		// on/off short slot time
+
+		if (uNonShortSlotSTACnt > 0) {
+			if (pDevice->bShortSlotTime) {
+				pDevice->bShortSlotTime = false;
+				BBvSetShortSlotTime(pDevice);
+				vUpdateIFS((void *)pDevice);
+			}
+		}
+		else {
+			if (!pDevice->bShortSlotTime) {
+				pDevice->bShortSlotTime = true;
+				BBvSetShortSlotTime(pDevice);
+				vUpdateIFS((void *)pDevice);
+			}
+		}
+
+		// on/off barker long preamble mode
+
+		if (uLongPreambleSTACnt > 0) {
+			if (!pDevice->bBarkerPreambleMd) {
+				MACvEnableBarkerPreambleMd(pDevice);
+				pDevice->bBarkerPreambleMd = true;
+			}
+		}
+		else {
+			if (pDevice->bBarkerPreambleMd) {
+				MACvDisableBarkerPreambleMd(pDevice);
+				pDevice->bBarkerPreambleMd = false;
+			}
+		}
+
+	}
+
+	// Check if any STA in PS mode, enable DTIM multicast deliver
+	if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
+		if (uSleepySTACnt > 0)
+			pMgmt->sNodeDBTable[0].bPSEnable = true;
+		else
+			pMgmt->sNodeDBTable[0].bPSEnable = false;
+	}
+
+	pItemSSID = (PWLAN_IE_SSID)pMgmt->abyDesireSSID;
+	pCurrSSID = (PWLAN_IE_SSID)pMgmt->abyCurrSSID;
+
+	if ((pMgmt->eCurrMode == WMAC_MODE_STANDBY) ||
+		(pMgmt->eCurrMode == WMAC_MODE_ESS_STA)) {
+
+		if (pMgmt->sNodeDBTable[0].bActive) { // Assoc with BSS
+
+			if (pDevice->bUpdateBBVGA) {
+				s_vCheckSensitivity(pDevice);
+				s_vCheckPreEDThreshold(pDevice);
+			}
+
+			if ((pMgmt->sNodeDBTable[0].uInActiveCount >= (LOST_BEACON_COUNT/2)) &&
+				(pDevice->byBBVGACurrent != pDevice->abyBBVGA[0]) ) {
+				pDevice->byBBVGANew = pDevice->abyBBVGA[0];
+				bScheduleCommand((void *) pDevice,
+					WLAN_CMD_CHANGE_BBSENSITIVITY,
+					NULL);
+			}
+
+			if (pMgmt->sNodeDBTable[0].uInActiveCount >= LOST_BEACON_COUNT) {
+				pMgmt->sNodeDBTable[0].bActive = false;
+				pMgmt->eCurrMode = WMAC_MODE_STANDBY;
+				pMgmt->eCurrState = WMAC_STATE_IDLE;
+				netif_stop_queue(pDevice->dev);
+				pDevice->bLinkPass = false;
+				ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_SLOW);
+				pDevice->bRoaming = true;
+				pDevice->bIsRoaming = false;
+
+				DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Lost AP beacon [%d] sec, disconnected !\n", pMgmt->sNodeDBTable[0].uInActiveCount);
+				/* let wpa supplicant know AP may disconnect */
+				{
+					union iwreq_data  wrqu;
+					memset(&wrqu, 0, sizeof (wrqu));
+						wrqu.ap_addr.sa_family = ARPHRD_ETHER;
+					PRINT_K("wireless_send_event--->SIOCGIWAP(disassociated)\n");
+					wireless_send_event(pDevice->dev, SIOCGIWAP, &wrqu, NULL);
+				}
+			}
+		}
+		else if (pItemSSID->len != 0) {
+			//Davidwang
+			if ((pDevice->bEnableRoaming == true)&&(!(pMgmt->Cisco_cckm))) {
+				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bRoaming %d, !\n", pDevice->bRoaming );
+				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bIsRoaming %d, !\n", pDevice->bIsRoaming );
+				if ((pDevice->bRoaming == true)&&(pDevice->bIsRoaming == true)){
+					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Fast   Roaming ...\n");
+					BSSvClearBSSList((void *) pDevice, pDevice->bLinkPass);
+					bScheduleCommand((void *) pDevice,
+						WLAN_CMD_BSSID_SCAN,
+						pMgmt->abyDesireSSID);
+					bScheduleCommand((void *) pDevice,
+						WLAN_CMD_SSID,
+						pMgmt->abyDesireSSID);
+					pDevice->uAutoReConnectTime = 0;
+					pDevice->uIsroamingTime = 0;
+					pDevice->bRoaming = false;
+				}
+				else if ((pDevice->bRoaming == false)&&(pDevice->bIsRoaming == true)) {
+					pDevice->uIsroamingTime++;
+					if (pDevice->uIsroamingTime >= 20)
+						pDevice->bIsRoaming = false;
+				}
+			}
+			else {
+				if (pDevice->uAutoReConnectTime < 10) {
+					pDevice->uAutoReConnectTime++;
+					//network manager support need not do Roaming scan???
+					if(pDevice->bWPASuppWextEnabled ==true)
+						pDevice->uAutoReConnectTime = 0;
+				}
+				else {
+					//mike use old encryption status for wpa reauthen
+					if(pDevice->bWPADEVUp)
+						pDevice->eEncryptionStatus = pDevice->eOldEncryptionStatus;
+
+					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Roaming ...\n");
+					BSSvClearBSSList((void *) pDevice, pDevice->bLinkPass);
+					pMgmt->eScanType = WMAC_SCAN_ACTIVE;
+					bScheduleCommand((void *) pDevice,
+							 WLAN_CMD_BSSID_SCAN,
+							 pMgmt->abyDesireSSID);
+					bScheduleCommand((void *) pDevice,
+							 WLAN_CMD_SSID,
+							 pMgmt->abyDesireSSID);
+					pDevice->uAutoReConnectTime = 0;
+				}
+			}
+		}
+	}
+
+	if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) {
+		// if adhoc started which essid is NULL string, rescanning.
+		if ((pMgmt->eCurrState == WMAC_STATE_STARTED) && (pCurrSSID->len == 0)) {
+			if (pDevice->uAutoReConnectTime < 10) {
+				pDevice->uAutoReConnectTime++;
+			}
+			else {
+				DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Adhoc re-scanning ...\n");
+				pMgmt->eScanType = WMAC_SCAN_ACTIVE;
+				bScheduleCommand((void *) pDevice, WLAN_CMD_BSSID_SCAN, NULL);
+				bScheduleCommand((void *) pDevice, WLAN_CMD_SSID, NULL);
+				pDevice->uAutoReConnectTime = 0;
+			};
+		}
+		if (pMgmt->eCurrState == WMAC_STATE_JOINTED) {
+
+			if (pDevice->bUpdateBBVGA) {
+				s_vCheckSensitivity(pDevice);
+				s_vCheckPreEDThreshold(pDevice);
+			}
+			if (pMgmt->sNodeDBTable[0].uInActiveCount >=ADHOC_LOST_BEACON_COUNT) {
+				DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Lost other STA beacon [%d] sec, started !\n", pMgmt->sNodeDBTable[0].uInActiveCount);
+				pMgmt->sNodeDBTable[0].uInActiveCount = 0;
+				pMgmt->eCurrState = WMAC_STATE_STARTED;
+				netif_stop_queue(pDevice->dev);
+				pDevice->bLinkPass = false;
+				ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_SLOW);
+			}
+		}
+	}
 
 	if (pDevice->bLinkPass == true) {
 		if (pMgmt->eAuthenMode < WMAC_AUTH_WPA ||
@@ -1142,7 +1147,7 @@ else {
 			netif_wake_queue(pDevice->dev);
 	}
 
-    spin_unlock_irq(&pDevice->lock);
+	spin_unlock_irq(&pDevice->lock);
 
 	schedule_delayed_work(&pDevice->second_callback_work, HZ);
 }
@@ -1152,11 +1157,11 @@ else {
  * Routine Description:
  *
  *
- *  Update Tx attemps, Tx failure counter in Node DB
+ *	Update Tx attemps, Tx failure counter in Node DB
  *
  *
  * Return Value:
- *    none.
+ *	  none.
  *
 -*/
 
@@ -1174,170 +1179,170 @@ void BSSvUpdateNodeTxCounter(struct vnt_private *pDevice, u8 byTSR, u8 byPktNO)
 	u8 byPktNum;
 	u16 wFIFOCtl;
 
-    byPktNum = (byPktNO & 0x0F) >> 4;
-    byTxRetry = (byTSR & 0xF0) >> 4;
-    wRate = (u16) (byPktNO & 0xF0) >> 4;
-    wFIFOCtl = pkt_info[byPktNum].fifo_ctl;
-    pbyDestAddr = pkt_info[byPktNum].dest_addr;
-
-    if (wFIFOCtl & FIFOCTL_AUTO_FB_0) {
-        byFallBack = AUTO_FB_0;
-    } else if (wFIFOCtl & FIFOCTL_AUTO_FB_1) {
-        byFallBack = AUTO_FB_1;
-    } else {
-        byFallBack = AUTO_FB_NONE;
-    }
-
-    // Only Unicast using support rates
-    if (wFIFOCtl & FIFOCTL_NEEDACK) {
-        if (pMgmt->eCurrMode == WMAC_MODE_ESS_STA) {
-            pMgmt->sNodeDBTable[0].uTxAttempts += 1;
-            if ( !(byTSR & (TSR_TMO | TSR_RETRYTMO))) {
-                // transmit success, TxAttempts at least plus one
-                pMgmt->sNodeDBTable[0].uTxOk[MAX_RATE]++;
-                if ( (byFallBack == AUTO_FB_NONE) ||
-                     (wRate < RATE_18M) ) {
-                    wFallBackRate = wRate;
-                } else if (byFallBack == AUTO_FB_0) {
-                    if (byTxRetry < 5)
-                        wFallBackRate = awHWRetry0[wRate-RATE_18M][byTxRetry];
-                    else
-                        wFallBackRate = awHWRetry0[wRate-RATE_18M][4];
-                } else if (byFallBack == AUTO_FB_1) {
-                    if (byTxRetry < 5)
-                        wFallBackRate = awHWRetry1[wRate-RATE_18M][byTxRetry];
-                    else
-                        wFallBackRate = awHWRetry1[wRate-RATE_18M][4];
-                }
-                pMgmt->sNodeDBTable[0].uTxOk[wFallBackRate]++;
-            } else {
-                pMgmt->sNodeDBTable[0].uTxFailures ++;
-            }
-            pMgmt->sNodeDBTable[0].uTxRetry += byTxRetry;
-            if (byTxRetry != 0) {
-                pMgmt->sNodeDBTable[0].uTxFail[MAX_RATE]+=byTxRetry;
-                if ( (byFallBack == AUTO_FB_NONE) ||
-                     (wRate < RATE_18M) ) {
-                    pMgmt->sNodeDBTable[0].uTxFail[wRate]+=byTxRetry;
-                } else if (byFallBack == AUTO_FB_0) {
-			for (ii = 0; ii < byTxRetry; ii++) {
-				if (ii < 5)
-					wFallBackRate =
-						awHWRetry0[wRate-RATE_18M][ii];
-				else
-					wFallBackRate =
-						awHWRetry0[wRate-RATE_18M][4];
-				pMgmt->sNodeDBTable[0].uTxFail[wFallBackRate]++;
+	byPktNum = (byPktNO & 0x0F) >> 4;
+	byTxRetry = (byTSR & 0xF0) >> 4;
+	wRate = (u16) (byPktNO & 0xF0) >> 4;
+	wFIFOCtl = pkt_info[byPktNum].fifo_ctl;
+	pbyDestAddr = pkt_info[byPktNum].dest_addr;
+
+	if (wFIFOCtl & FIFOCTL_AUTO_FB_0) {
+		byFallBack = AUTO_FB_0;
+	} else if (wFIFOCtl & FIFOCTL_AUTO_FB_1) {
+		byFallBack = AUTO_FB_1;
+	} else {
+		byFallBack = AUTO_FB_NONE;
+	}
+
+	// Only Unicast using support rates
+	if (wFIFOCtl & FIFOCTL_NEEDACK) {
+		if (pMgmt->eCurrMode == WMAC_MODE_ESS_STA) {
+			pMgmt->sNodeDBTable[0].uTxAttempts += 1;
+			if ( !(byTSR & (TSR_TMO | TSR_RETRYTMO))) {
+				// transmit success, TxAttempts at least plus one
+				pMgmt->sNodeDBTable[0].uTxOk[MAX_RATE]++;
+				if ( (byFallBack == AUTO_FB_NONE) ||
+					 (wRate < RATE_18M) ) {
+					wFallBackRate = wRate;
+				} else if (byFallBack == AUTO_FB_0) {
+					if (byTxRetry < 5)
+						wFallBackRate = awHWRetry0[wRate-RATE_18M][byTxRetry];
+					else
+						wFallBackRate = awHWRetry0[wRate-RATE_18M][4];
+				} else if (byFallBack == AUTO_FB_1) {
+					if (byTxRetry < 5)
+						wFallBackRate = awHWRetry1[wRate-RATE_18M][byTxRetry];
+					else
+						wFallBackRate = awHWRetry1[wRate-RATE_18M][4];
+				}
+				pMgmt->sNodeDBTable[0].uTxOk[wFallBackRate]++;
+			} else {
+				pMgmt->sNodeDBTable[0].uTxFailures ++;
 			}
-                } else if (byFallBack == AUTO_FB_1) {
-			for (ii = 0; ii < byTxRetry; ii++) {
-				if (ii < 5)
-					wFallBackRate =
-						awHWRetry1[wRate-RATE_18M][ii];
-				else
-					wFallBackRate =
-						awHWRetry1[wRate-RATE_18M][4];
-				pMgmt->sNodeDBTable[0].uTxFail[wFallBackRate]++;
+			pMgmt->sNodeDBTable[0].uTxRetry += byTxRetry;
+			if (byTxRetry != 0) {
+				pMgmt->sNodeDBTable[0].uTxFail[MAX_RATE]+=byTxRetry;
+				if ( (byFallBack == AUTO_FB_NONE) ||
+					(wRate < RATE_18M) ) {
+					pMgmt->sNodeDBTable[0].uTxFail[wRate]+=byTxRetry;
+				} else if (byFallBack == AUTO_FB_0) {
+					for (ii = 0; ii < byTxRetry; ii++) {
+						if (ii < 5)
+							wFallBackRate =
+								awHWRetry0[wRate-RATE_18M][ii];
+						else
+							wFallBackRate =
+								awHWRetry0[wRate-RATE_18M][4];
+						pMgmt->sNodeDBTable[0].uTxFail[wFallBackRate]++;
+					}
+				} else if (byFallBack == AUTO_FB_1) {
+					for (ii = 0; ii < byTxRetry; ii++) {
+						if (ii < 5)
+							wFallBackRate =
+								awHWRetry1[wRate-RATE_18M][ii];
+						else
+							wFallBackRate =
+								awHWRetry1[wRate-RATE_18M][4];
+						pMgmt->sNodeDBTable[0].uTxFail[wFallBackRate]++;
+					}
+				}
+			}
+		}
+
+		if ((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) ||
+			(pMgmt->eCurrMode == WMAC_MODE_ESS_AP)) {
+
+			if (BSSbIsSTAInNodeDB((void *) pDevice,
+						  pbyDestAddr,
+						  &uNodeIndex)) {
+				pMgmt->sNodeDBTable[uNodeIndex].uTxAttempts += 1;
+				if ( !(byTSR & (TSR_TMO | TSR_RETRYTMO))) {
+					// transmit success, TxAttempts at least plus one
+					pMgmt->sNodeDBTable[uNodeIndex].uTxOk[MAX_RATE]++;
+					if ( (byFallBack == AUTO_FB_NONE) ||
+						(wRate < RATE_18M) ) {
+						wFallBackRate = wRate;
+					} else if (byFallBack == AUTO_FB_0) {
+						if (byTxRetry < 5)
+							wFallBackRate = awHWRetry0[wRate-RATE_18M][byTxRetry];
+						else
+							wFallBackRate = awHWRetry0[wRate-RATE_18M][4];
+					} else if (byFallBack == AUTO_FB_1) {
+						if (byTxRetry < 5)
+							wFallBackRate = awHWRetry1[wRate-RATE_18M][byTxRetry];
+						else
+							wFallBackRate = awHWRetry1[wRate-RATE_18M][4];
+					}
+					pMgmt->sNodeDBTable[uNodeIndex].uTxOk[wFallBackRate]++;
+				} else {
+					pMgmt->sNodeDBTable[uNodeIndex].uTxFailures ++;
+				}
+				pMgmt->sNodeDBTable[uNodeIndex].uTxRetry += byTxRetry;
+				if (byTxRetry != 0) {
+					pMgmt->sNodeDBTable[uNodeIndex].uTxFail[MAX_RATE]+=byTxRetry;
+					if ( (byFallBack == AUTO_FB_NONE) ||
+						(wRate < RATE_18M) ) {
+						pMgmt->sNodeDBTable[uNodeIndex].uTxFail[wRate]+=byTxRetry;
+					} else if (byFallBack == AUTO_FB_0) {
+						for (ii = 0; ii < byTxRetry; ii++) {
+							if (ii < 5)
+								wFallBackRate =
+									awHWRetry0[wRate-RATE_18M][ii];
+							else
+								wFallBackRate =
+									awHWRetry0[wRate-RATE_18M][4];
+							pMgmt->sNodeDBTable[uNodeIndex].uTxFail[wFallBackRate]++;
+						}
+					} else if (byFallBack == AUTO_FB_1) {
+						for (ii = 0; ii < byTxRetry; ii++) {
+							if (ii < 5)
+								wFallBackRate = awHWRetry1[wRate-RATE_18M][ii];
+							else
+								wFallBackRate = awHWRetry1[wRate-RATE_18M][4];
+							pMgmt->sNodeDBTable[uNodeIndex].uTxFail[wFallBackRate]++;
+						}
+					}
+				}
 			}
-                }
-            }
-        }
-
-	if ((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) ||
-            (pMgmt->eCurrMode == WMAC_MODE_ESS_AP)) {
-
-		if (BSSbIsSTAInNodeDB((void *) pDevice,
-				      pbyDestAddr,
-				      &uNodeIndex)) {
-			pMgmt->sNodeDBTable[uNodeIndex].uTxAttempts += 1;
-                if ( !(byTSR & (TSR_TMO | TSR_RETRYTMO))) {
-                    // transmit success, TxAttempts at least plus one
-                    pMgmt->sNodeDBTable[uNodeIndex].uTxOk[MAX_RATE]++;
-                    if ( (byFallBack == AUTO_FB_NONE) ||
-                         (wRate < RATE_18M) ) {
-                        wFallBackRate = wRate;
-                    } else if (byFallBack == AUTO_FB_0) {
-                        if (byTxRetry < 5)
-                            wFallBackRate = awHWRetry0[wRate-RATE_18M][byTxRetry];
-                        else
-                            wFallBackRate = awHWRetry0[wRate-RATE_18M][4];
-                    } else if (byFallBack == AUTO_FB_1) {
-                        if (byTxRetry < 5)
-                            wFallBackRate = awHWRetry1[wRate-RATE_18M][byTxRetry];
-                        else
-                            wFallBackRate = awHWRetry1[wRate-RATE_18M][4];
-                    }
-                    pMgmt->sNodeDBTable[uNodeIndex].uTxOk[wFallBackRate]++;
-                } else {
-                    pMgmt->sNodeDBTable[uNodeIndex].uTxFailures ++;
-                }
-                pMgmt->sNodeDBTable[uNodeIndex].uTxRetry += byTxRetry;
-                if (byTxRetry != 0) {
-                    pMgmt->sNodeDBTable[uNodeIndex].uTxFail[MAX_RATE]+=byTxRetry;
-                    if ( (byFallBack == AUTO_FB_NONE) ||
-                         (wRate < RATE_18M) ) {
-                        pMgmt->sNodeDBTable[uNodeIndex].uTxFail[wRate]+=byTxRetry;
-                    } else if (byFallBack == AUTO_FB_0) {
-			for (ii = 0; ii < byTxRetry; ii++) {
-				if (ii < 5)
-					wFallBackRate =
-						awHWRetry0[wRate-RATE_18M][ii];
-				else
-					wFallBackRate =
-						awHWRetry0[wRate-RATE_18M][4];
-				pMgmt->sNodeDBTable[uNodeIndex].uTxFail[wFallBackRate]++;
-                        }
-                    } else if (byFallBack == AUTO_FB_1) {
-		      for (ii = 0; ii < byTxRetry; ii++) {
-			if (ii < 5)
-                                wFallBackRate = awHWRetry1[wRate-RATE_18M][ii];
-			else
-                                wFallBackRate = awHWRetry1[wRate-RATE_18M][4];
-			pMgmt->sNodeDBTable[uNodeIndex].uTxFail[wFallBackRate]++;
-		      }
-                    }
-                }
-            }
-        }
-    }
+		}
+	}
 }
 
 /*+
  *
  * Routine Description:
- *    Clear Nodes & skb in DB Table
+ *	  Clear Nodes & skb in DB Table
  *
  *
  * Parameters:
- *  In:
- *      hDeviceContext        - The adapter context.
- *      uStartIndex           - starting index
- *  Out:
- *      none
+ *	In:
+ *		hDeviceContext	- The adapter context.
+ *		uStartIndex	- starting index
+ *	Out:
+ *		none
  *
  * Return Value:
- *    None.
+ *	  None.
  *
 -*/
 
 void BSSvClearNodeDBTable(struct vnt_private *pDevice, u32 uStartIndex)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
-	struct sk_buff  *skb;
+	struct sk_buff	*skb;
 	int ii;
 
-    for (ii = uStartIndex; ii < (MAX_NODE_NUM + 1); ii++) {
-        if (pMgmt->sNodeDBTable[ii].bActive) {
-            // check if sTxPSQueue has been initial
-            if (pMgmt->sNodeDBTable[ii].sTxPSQueue.next != NULL) {
-                while ((skb = skb_dequeue(&pMgmt->sNodeDBTable[ii].sTxPSQueue)) != NULL){
-                        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "PS skb != NULL %d\n", ii);
-                        dev_kfree_skb(skb);
-                }
-            }
-            memset(&pMgmt->sNodeDBTable[ii], 0, sizeof(KnownNodeDB));
-        }
-    }
+	for (ii = uStartIndex; ii < (MAX_NODE_NUM + 1); ii++) {
+		if (pMgmt->sNodeDBTable[ii].bActive) {
+			// check if sTxPSQueue has been initial
+			if (pMgmt->sNodeDBTable[ii].sTxPSQueue.next != NULL) {
+				while ((skb = skb_dequeue(&pMgmt->sNodeDBTable[ii].sTxPSQueue)) != NULL){
+					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "PS skb != NULL %d\n", ii);
+					dev_kfree_skb(skb);
+				}
+			}
+			memset(&pMgmt->sNodeDBTable[ii], 0, sizeof(KnownNodeDB));
+		}
+	}
 };
 
 static void s_vCheckSensitivity(struct vnt_private *pDevice)
@@ -1346,40 +1351,40 @@ static void s_vCheckSensitivity(struct vnt_private *pDevice)
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	int ii;
 
-    if ((pMgmt->eCurrState == WMAC_STATE_ASSOC) ||
-        ((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) && (pMgmt->eCurrState == WMAC_STATE_JOINTED))) {
-        pBSSList = BSSpAddrIsInBSSList(pDevice, pMgmt->abyCurrBSSID, (PWLAN_IE_SSID)pMgmt->abyCurrSSID);
-        if (pBSSList != NULL) {
-		/* Update BB register if RSSI is too strong */
-		signed long    LocalldBmAverage = 0;
-		signed long    uNumofdBm = 0;
-            for (ii = 0; ii < RSSI_STAT_COUNT; ii++) {
-                if (pBSSList->ldBmAverage[ii] != 0) {
-                    uNumofdBm ++;
-                    LocalldBmAverage += pBSSList->ldBmAverage[ii];
-                }
-            }
-            if (uNumofdBm > 0) {
-                LocalldBmAverage = LocalldBmAverage/uNumofdBm;
-                for (ii=0;ii<BB_VGA_LEVEL;ii++) {
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"LocalldBmAverage:%ld, %ld %02x\n", LocalldBmAverage, pDevice->ldBmThreshold[ii], pDevice->abyBBVGA[ii]);
-                    if (LocalldBmAverage < pDevice->ldBmThreshold[ii]) {
-                	    pDevice->byBBVGANew = pDevice->abyBBVGA[ii];
-                        break;
-                    }
-                }
-                if (pDevice->byBBVGANew != pDevice->byBBVGACurrent) {
-                    pDevice->uBBVGADiffCount++;
-                    if (pDevice->uBBVGADiffCount >= BB_VGA_CHANGE_THRESHOLD)
-			bScheduleCommand(pDevice,
-					 WLAN_CMD_CHANGE_BBSENSITIVITY,
-					 NULL);
-                } else {
-                    pDevice->uBBVGADiffCount = 0;
-                }
-            }
-        }
-    }
+	if ((pMgmt->eCurrState == WMAC_STATE_ASSOC) ||
+		((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) && (pMgmt->eCurrState == WMAC_STATE_JOINTED))) {
+		pBSSList = BSSpAddrIsInBSSList(pDevice, pMgmt->abyCurrBSSID, (PWLAN_IE_SSID)pMgmt->abyCurrSSID);
+		if (pBSSList != NULL) {
+			/* Update BB register if RSSI is too strong */
+			signed long    LocalldBmAverage = 0;
+			signed long    uNumofdBm = 0;
+			for (ii = 0; ii < RSSI_STAT_COUNT; ii++) {
+				if (pBSSList->ldBmAverage[ii] != 0) {
+					uNumofdBm ++;
+					LocalldBmAverage += pBSSList->ldBmAverage[ii];
+				}
+			}
+			if (uNumofdBm > 0) {
+				LocalldBmAverage = LocalldBmAverage/uNumofdBm;
+				for (ii=0;ii<BB_VGA_LEVEL;ii++) {
+					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"LocalldBmAverage:%ld, %ld %02x\n", LocalldBmAverage, pDevice->ldBmThreshold[ii], pDevice->abyBBVGA[ii]);
+					if (LocalldBmAverage < pDevice->ldBmThreshold[ii]) {
+						pDevice->byBBVGANew = pDevice->abyBBVGA[ii];
+						break;
+					}
+				}
+				if (pDevice->byBBVGANew != pDevice->byBBVGACurrent) {
+					pDevice->uBBVGADiffCount++;
+					if (pDevice->uBBVGADiffCount >= BB_VGA_CHANGE_THRESHOLD)
+						bScheduleCommand(pDevice,
+							WLAN_CMD_CHANGE_BBSENSITIVITY,
+							NULL);
+				} else {
+					pDevice->uBBVGADiffCount = 0;
+				}
+			}
+		}
+	}
 }
 
 static void s_uCalculateLinkQual(struct vnt_private *pDevice)
@@ -1436,13 +1441,13 @@ static void s_vCheckPreEDThreshold(struct vnt_private *pDevice)
 	PKnownBSS pBSSList = NULL;
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 
-    if ((pMgmt->eCurrState == WMAC_STATE_ASSOC) ||
-        ((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) && (pMgmt->eCurrState == WMAC_STATE_JOINTED))) {
-        pBSSList = BSSpAddrIsInBSSList(pDevice, pMgmt->abyCurrBSSID, (PWLAN_IE_SSID)pMgmt->abyCurrSSID);
-        if (pBSSList != NULL) {
-            pDevice->byBBPreEDRSSI = (u8) (~(pBSSList->ldBmAverRange) + 1);
-            BBvUpdatePreEDThreshold(pDevice, false);
-        }
-    }
+	if ((pMgmt->eCurrState == WMAC_STATE_ASSOC) ||
+		((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) && (pMgmt->eCurrState == WMAC_STATE_JOINTED))) {
+		pBSSList = BSSpAddrIsInBSSList(pDevice, pMgmt->abyCurrBSSID, (PWLAN_IE_SSID)pMgmt->abyCurrSSID);
+		if (pBSSList != NULL) {
+			pDevice->byBBPreEDRSSI = (u8) (~(pBSSList->ldBmAverRange) + 1);
+			BBvUpdatePreEDThreshold(pDevice, false);
+		}
+	}
 }
 
-- 
1.8.1.2

