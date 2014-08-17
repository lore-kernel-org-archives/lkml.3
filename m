Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbaHQTn4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 15:43:56 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:60558 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbaHQTnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 15:43:11 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/5] staging: vt6655: remove PLICE_DEBUG where it is defined
Date: Sun, 17 Aug 2014 20:42:27 +0100
Message-Id: <1408304549-22363-3-git-send-email-tvboxspy@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408304549-22363-1-git-send-email-tvboxspy@gmail.com>
References: <1408304549-22363-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove macro and directive leaving the code.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rxtx.c |  4 +---
 drivers/staging/vt6655/wmgr.c | 12 ++++--------
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 869555a..635e88c 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -68,7 +68,6 @@
 /*---------------------  Static Classes  ----------------------------*/
 
 /*---------------------  Static Variables  --------------------------*/
-#define	PLICE_DEBUG
 
 /*---------------------  Static Functions  --------------------------*/
 
@@ -1969,9 +1968,8 @@ vGenerateFIFOHeader(struct vnt_private *pDevice, unsigned char byPktType,
 		}
 	}
 
-#ifdef	PLICE_DEBUG
 	RFbSetPower(pDevice, pDevice->wCurrentRate, pDevice->byCurrentCh);
-#endif
+
 	pTxBufHead->byTxPower = pDevice->byCurPwr;
 
 	*pcbHeaderSize = s_cbFillTxBufHead(pDevice, byPktType, pbyTxBufferAddr, cbPayloadSize,
diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index c998a16..c3de107 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -80,8 +80,6 @@
 #include "rf.h"
 #include "iowpa.h"
 
-#define	PLICE_DEBUG
-
 /*---------------------  Static Definitions -------------------------*/
 
 /*---------------------  Static Classes  ----------------------------*/
@@ -692,9 +690,9 @@ s_vMgrRxAssocRequest(
 		// set max tx rate
 		pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate =
 			pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate;
-#ifdef	PLICE_DEBUG
+
 		pr_debug("RxAssocRequest:wTxDataRate is %d\n", pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate);
-#endif
+
 		// Todo: check sta preamble, if ap can't support, set status code
 		pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble =
 			WLAN_GET_CAP_INFO_SHORTPREAMBLE(*sFrame.pwCapInfo);
@@ -840,9 +838,9 @@ s_vMgrRxReAssocRequest(
 		// set max tx rate
 		pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate =
 			pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate;
-#ifdef	PLICE_DEBUG
+
 		pr_debug("RxReAssocRequest:TxDataRate is %d\n", pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate);
-#endif
+
 		// Todo: check sta preamble, if ap can't support, set status code
 		pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble =
 			WLAN_GET_CAP_INFO_SHORTPREAMBLE(*sFrame.pwCapInfo);
@@ -2097,11 +2095,9 @@ s_vMgrRxBeacon(
 				memcpy(pMgmt->sNodeDBTable[uNodeIndex].abyMACAddr, sFrame.pHdr->sA3.abyAddr2, WLAN_ADDR_LEN);
 				pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble = WLAN_GET_CAP_INFO_SHORTPREAMBLE(*sFrame.pwCapInfo);
 				pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate = pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate;
-#ifdef	PLICE_DEBUG
 				{
 					pr_debug("s_vMgrRxBeacon:TxDataRate is %d,Index is %d\n", pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate, uNodeIndex);
 				}
-#endif
 			}
 
 			// if other stations joined, indicate connection to upper layer..
-- 
1.9.1

