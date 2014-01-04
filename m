Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbaADPZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 10:25:59 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:49320 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754826AbaADPZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 10:25:56 -0500
From: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
To: sebastian.rachuj@studium.uni-erlangen.de
Cc: linux-kernel@i4.cs.fau.de, linux@rationality.eu,
        forest@alittletooquiet.net, gregkh@linuxfoundation.org,
        more.andres@gmail.com, tvboxspy@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/13] Staging: vt6656: Remove line feeds before else
Date: Sat,  4 Jan 2014 16:25:11 +0100
Message-Id: <1388849118-11994-7-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1388849118-11994-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
References: <1388849118-11994-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Schuster <linux@rationality.eu>

An else belongs in the same line as the closing curly brace of the
previous block. Hence, this patch removes line feeds separating a
curly brace from the corresponding else.

Signed-off-by: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
Signed-off-by: Simon Schuster <linux@rationality.eu>
---
 drivers/staging/vt6656/bssdb.c | 39 +++++++++++++--------------------------
 1 file changed, 13 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 38c267b..815324a 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -649,8 +649,7 @@ void BSSvCreateOneNode(struct vnt_private *pDevice, u32 *puNodeIndex)
 				BigestCount = pMgmt->sNodeDBTable[ii].uInActiveCount;
 				SelectIndex = ii;
 			}
-		}
-		else {
+		} else {
 			break;
 		}
 	}
@@ -664,8 +663,7 @@ void BSSvCreateOneNode(struct vnt_private *pDevice, u32 *puNodeIndex)
 			while ((skb = skb_dequeue(&pMgmt->sNodeDBTable[*puNodeIndex].sTxPSQueue)) != NULL)
 				dev_kfree_skb(skb);
 		}
-	}
-	else {
+	} else {
 		*puNodeIndex = ii;
 	}
 
@@ -822,8 +820,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 
 	if (pDevice->wUseProtectCntDown > 0) {
 		pDevice->wUseProtectCntDown--;
-	}
-	else {
+	} else {
 		/* disable protect mode */
 		pDevice->byERPFlag &= ~(WLAN_SET_ERP_USE_PROTECTION(1));
 	}
@@ -841,8 +838,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 				PRINT_K("wireless_send_event--->SIOCGIWAP(disassociated)\n");
 				wireless_send_event(pDevice->dev, SIOCGIWAP, &wrqu, NULL);
 			}
-		}
-		else if (pDevice->bLinkPass == true)
+		} else if (pDevice->bLinkPass == true)
 			pDevice->byReAssocCount = 0;
 	}
 
@@ -895,8 +891,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 					/* ii = 0 for multicast node (AP & Adhoc) */
 					RATEvTxRateFallBack((void *) pDevice,
 						&(pMgmt->sNodeDBTable[ii]));
-				}
-				else {
+				} else {
 					/* ii = 0 reserved for unicast AP node (Infra STA) */
 					if (pMgmt->eCurrMode == WMAC_MODE_ESS_STA)
 						RATEvTxRateFallBack((void *) pDevice,
@@ -927,8 +922,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 				MACvEnableProtectMD(pDevice);
 				pDevice->bProtectMode = true;
 			}
-		}
-		else {
+		} else {
 			if (pDevice->bProtectMode) {
 				MACvDisableProtectMD(pDevice);
 				pDevice->bProtectMode = false;
@@ -942,8 +936,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 				BBvSetShortSlotTime(pDevice);
 				vUpdateIFS((void *) pDevice);
 			}
-		}
-		else {
+		} else {
 			if (!pDevice->bShortSlotTime) {
 				pDevice->bShortSlotTime = true;
 				BBvSetShortSlotTime(pDevice);
@@ -958,8 +951,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 				MACvEnableBarkerPreambleMd(pDevice);
 				pDevice->bBarkerPreambleMd = true;
 			}
-		}
-		else {
+		} else {
 			if (pDevice->bBarkerPreambleMd) {
 				MACvDisableBarkerPreambleMd(pDevice);
 				pDevice->bBarkerPreambleMd = false;
@@ -1017,8 +1009,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 					wireless_send_event(pDevice->dev, SIOCGIWAP, &wrqu, NULL);
 				}
 			}
-		}
-		else if (pItemSSID->len != 0) {
+		} else if (pItemSSID->len != 0) {
 			/* Davidwang */
 			if ((pDevice->bEnableRoaming == true)&&(!(pMgmt->Cisco_cckm))) {
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bRoaming %d, !\n", pDevice->bRoaming);
@@ -1035,21 +1026,18 @@ void BSSvSecondCallBack(struct work_struct *work)
 					pDevice->uAutoReConnectTime = 0;
 					pDevice->uIsroamingTime = 0;
 					pDevice->bRoaming = false;
-				}
-				else if ((pDevice->bRoaming == false) && (pDevice->bIsRoaming == true)) {
+				} else if ((pDevice->bRoaming == false) && (pDevice->bIsRoaming == true)) {
 					pDevice->uIsroamingTime++;
 					if (pDevice->uIsroamingTime >= 20)
 						pDevice->bIsRoaming = false;
 				}
-			}
-			else {
+			} else {
 				if (pDevice->uAutoReConnectTime < 10) {
 					pDevice->uAutoReConnectTime++;
 					/* network manager support need not do Roaming scan??? */
 					if (pDevice->bWPASuppWextEnabled == true)
 						pDevice->uAutoReConnectTime = 0;
-				}
-				else {
+				} else {
 					/* mike use old encryption status for wpa reauthen */
 					if (pDevice->bWPADEVUp)
 						pDevice->eEncryptionStatus = pDevice->eOldEncryptionStatus;
@@ -1074,8 +1062,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 		if ((pMgmt->eCurrState == WMAC_STATE_STARTED) && (pCurrSSID->len == 0)) {
 			if (pDevice->uAutoReConnectTime < 10) {
 				pDevice->uAutoReConnectTime++;
-			}
-			else {
+			} else {
 				DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Adhoc re-scanning ...\n");
 				pMgmt->eScanType = WMAC_SCAN_ACTIVE;
 				bScheduleCommand((void *) pDevice, WLAN_CMD_BSSID_SCAN, NULL);
-- 
1.8.1.2

