Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbaG1Uoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 16:44:30 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:41327 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbaG1UoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 16:44:20 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/4] staging: vt6655: dead code remove undefined macro FOR_LED_ON_NOTEBOOK code.
Date: Mon, 28 Jul 2014 21:43:29 +0100
Message-Id: <1406580210-2794-3-git-send-email-tvboxspy@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406580210-2794-1-git-send-email-tvboxspy@gmail.com>
References: <1406580210-2794-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing all variables associated with the code.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/bssdb.c       | 53 ------------------------------------
 drivers/staging/vt6655/device_main.c | 15 ----------
 2 files changed, 68 deletions(-)

diff --git a/drivers/staging/vt6655/bssdb.c b/drivers/staging/vt6655/bssdb.c
index 58f85e8..6367684 100644
--- a/drivers/staging/vt6655/bssdb.c
+++ b/drivers/staging/vt6655/bssdb.c
@@ -901,11 +901,6 @@ BSSvAddMulticastNode(
  *    none.
  *
  -*/
-/* 2008-4-14 <add> by chester for led issue */
-#ifdef FOR_LED_ON_NOTEBOOK
-bool cc = false;
-unsigned int status;
-#endif
 void
 BSSvSecondCallBack(
 	void *hDeviceContext
@@ -926,54 +921,6 @@ BSSvSecondCallBack(
 
 	pDevice->byERPFlag &=
 		~(WLAN_SET_ERP_BARKER_MODE(1) | WLAN_SET_ERP_NONERP_PRESENT(1));
-	/* 2008-4-14 <add> by chester for led issue */
-#ifdef FOR_LED_ON_NOTEBOOK
-	MACvGPIOIn(pDevice->PortOffset, &pDevice->byGPIO);
-	if (((!(pDevice->byGPIO & GPIO0_DATA) && (!pDevice->bHWRadioOff)) ||
-	     ((pDevice->byGPIO & GPIO0_DATA) && pDevice->bHWRadioOff)) &&
-	    (!cc)) {
-		cc = true;
-	} else if (cc) {
-		if (pDevice->bHWRadioOff) {
-			if (!(pDevice->byGPIO & GPIO0_DATA)) {
-				if (status == 1)
-					goto start;
-				status = 1;
-				CARDbRadioPowerOff(pDevice);
-				pMgmt->sNodeDBTable[0].bActive = false;
-				pMgmt->eCurrMode = WMAC_MODE_STANDBY;
-				pMgmt->eCurrState = WMAC_STATE_IDLE;
-				pDevice->bLinkPass = false;
-
-			}
-			if (pDevice->byGPIO & GPIO0_DATA) {
-				if (status == 2)
-					goto start;
-				status = 2;
-				CARDbRadioPowerOn(pDevice);
-			}
-		} else {
-			if (pDevice->byGPIO & GPIO0_DATA) {
-				if (status == 3)
-					goto start;
-				status = 3;
-				CARDbRadioPowerOff(pDevice);
-				pMgmt->sNodeDBTable[0].bActive = false;
-				pMgmt->eCurrMode = WMAC_MODE_STANDBY;
-				pMgmt->eCurrState = WMAC_STATE_IDLE;
-				pDevice->bLinkPass = false;
-
-			}
-			if (!(pDevice->byGPIO & GPIO0_DATA)) {
-				if (status == 4)
-					goto start;
-				status = 4;
-				CARDbRadioPowerOn(pDevice);
-			}
-		}
-	}
-start:
-#endif
 
 	if (pDevice->wUseProtectCntDown > 0) {
 		pDevice->wUseProtectCntDown--;
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index fe6de98..e8584fd 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -691,19 +691,6 @@ static void device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
 			// Get GPIO
 			MACvGPIOIn(pDevice->PortOffset, &pDevice->byGPIO);
 //2008-4-14 <add> by chester for led issue
-#ifdef FOR_LED_ON_NOTEBOOK
-			if (pDevice->byGPIO & GPIO0_DATA)
-				pDevice->bHWRadioOff = true;
-
-			if (!(pDevice->byGPIO & GPIO0_DATA))
-				pDevice->bHWRadioOff = false;
-		}
-
-		if (pDevice->bRadioControlOff)
-			CARDbRadioPowerOff(pDevice);
-		else
-			CARDbRadioPowerOn(pDevice);
-#else
 		if (((pDevice->byGPIO & GPIO0_DATA) && !(pDevice->byRadioCtl & EEP_RADIOCTL_INV)) ||
 		    (!(pDevice->byGPIO & GPIO0_DATA) && (pDevice->byRadioCtl & EEP_RADIOCTL_INV))) {
 			pDevice->bHWRadioOff = true;
@@ -711,8 +698,6 @@ static void device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
 	}
 	if (pDevice->bHWRadioOff || pDevice->bRadioControlOff)
 		CARDbRadioPowerOff(pDevice);
-
-#endif
 }
 pMgmt->eScanType = WMAC_SCAN_PASSIVE;
 // get Permanent network address
-- 
1.9.1

