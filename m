Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaGTFmE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 01:42:04 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41791 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaGTFmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 01:42:01 -0400
From: Igor Bezukh <igbzkh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org, igbzkh@gmail.com
Subject: [PATCH] Staging: vt6655: remove redundant comments
Date: Sun, 20 Jul 2014 08:41:50 +0300
Message-Id: <1405834910-3098-1-git-send-email-igbzkh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean redundant comments in the code.
Since I perform single fix type per patch, I've ignored the 80 line warning
when checking the patch against checkpatch.
I will fix the 80 line warnings on further patches.

Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
---
 drivers/staging/vt6655/wcmd.c |   46 ++++++++++++-----------------------------
 1 file changed, 13 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/vt6655/wcmd.c b/drivers/staging/vt6655/wcmd.c
index a689645..2456b30 100644
--- a/drivers/staging/vt6655/wcmd.c
+++ b/drivers/staging/vt6655/wcmd.c
@@ -54,13 +54,7 @@
 #include "iowpa.h"
 #include "channel.h"
 
-/*---------------------  Static Definitions -------------------------*/
-
-/*---------------------  Static Classes  ----------------------------*/
-
-/*---------------------  Static Variables  --------------------------*/
 static int msglevel = MSG_LEVEL_INFO;
-/*---------------------  Static Functions  --------------------------*/
 
 static
 void
@@ -85,10 +79,6 @@ s_bCommandComplete(
 	PSDevice pDevice
 );
 
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
 /*
  * Description:
  *      Stop AdHoc beacon during scan process
@@ -134,7 +124,7 @@ vAdHocBeaconStop(PSDevice  pDevice)
 
 	if (bStop)
 		MACvRegBitsOff(pDevice->PortOffset, MAC_REG_TCR, TCR_AUTOBCNTX);
-} /* vAdHocBeaconStop */
+}
 
 /*
  * Description:
@@ -167,7 +157,7 @@ vAdHocBeaconRestart(PSDevice pDevice)
 	}
 }
 
-/*+
+/*
  *
  * Routine Description:
  *   Prepare and send probe request management frames.
@@ -176,7 +166,7 @@ vAdHocBeaconRestart(PSDevice pDevice)
  * Return Value:
  *    none.
  *
- -*/
+ */
 
 static
 void
@@ -223,7 +213,7 @@ s_vProbeChannel(
 	}
 }
 
-/*+
+/*
  *
  * Routine Description:
  *  Constructs an probe request frame
@@ -232,7 +222,7 @@ s_vProbeChannel(
  * Return Value:
  *    A ptr to Tx frame or NULL on allocation failure
  *
- -*/
+ */
 
 PSTxMgmtPacket
 s_MgrMakeProbeRequest(
@@ -292,7 +282,6 @@ vCommandTimerWait(
 	init_timer(&pDevice->sTimerCommand);
 	pDevice->sTimerCommand.data = (unsigned long) pDevice;
 	pDevice->sTimerCommand.function = (TimerFunction)vCommandTimer;
-	// RUN_AT :1 msec ~= (HZ/1024)
 	pDevice->sTimerCommand.expires = (unsigned int)RUN_AT((MSecond * HZ) >> 10);
 	add_timer(&pDevice->sTimerCommand);
 	return;
@@ -366,9 +355,8 @@ vCommandTimer(
 			s_bCommandComplete(pDevice);
 
 		} else {
-//2008-8-4 <add> by chester
 			if (!is_channel_valid(pMgmt->uScanChannel)) {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Invalid channel pMgmt->uScanChannel = %d \n", pMgmt->uScanChannel);
+				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Invalid channel pMgmt->uScanChannel = %d\n", pMgmt->uScanChannel);
 				s_bCommandComplete(pDevice);
 				spin_unlock_irq(&pDevice->lock);
 				return;
@@ -394,7 +382,6 @@ vCommandTimer(
 
 			CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, OP_MODE_UNKNOWN);
 			pMgmt->uScanChannel++;
-//2008-8-4 <modify> by chester
 			if (!is_channel_valid(pMgmt->uScanChannel) &&
 			    pMgmt->uScanChannel <= pDevice->byMaxChannel) {
 				pMgmt->uScanChannel = pDevice->byMaxChannel + 1;
@@ -431,7 +418,6 @@ vCommandTimer(
 
 		pMgmt->eScanState = WMAC_NO_SCANNING;
 		vAdHocBeaconRestart(pDevice);
-//2008-0409-07, <Add> by Einsn Liu
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 		if (pMgmt->eScanType == WMAC_SCAN_PASSIVE)
 		{//send scan event to wpa_Supplicant
@@ -471,7 +457,6 @@ vCommandTimer(
 			return;
 		}
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " CARDbRadioPowerOff\n");
-		//2008-09-02  <mark>	by chester
 		s_bCommandComplete(pDevice);
 		break;
 
@@ -482,7 +467,6 @@ vCommandTimer(
 			spin_unlock_irq(&pDevice->lock);
 			return;
 		}
-//2008-09-02  <mark> by chester
 		s_bCommandComplete(pDevice);
 		break;
 
@@ -615,7 +599,7 @@ vCommandTimer(
 
 		else if (pMgmt->eCurrState < WMAC_STATE_AUTHPENDING) {
 			printk("WLAN_AUTHENTICATE_WAIT:Authen Fail???\n");
-		} else if (pDevice->byLinkWaitCount <= 4) {    //mike add:wait another 2 sec if authenticated_frame delay!
+		} else if (pDevice->byLinkWaitCount <= 4) {
 			pDevice->byLinkWaitCount++;
 			printk("WLAN_AUTHENTICATE_WAIT:wait %d times!!\n", pDevice->byLinkWaitCount);
 			spin_unlock_irq(&pDevice->lock);
@@ -652,7 +636,7 @@ vCommandTimer(
 				init_timer(&pDevice->sTimerTxData);
 				pDevice->sTimerTxData.data = (unsigned long) pDevice;
 				pDevice->sTimerTxData.function = (TimerFunction)BSSvSecondTxData;
-				pDevice->sTimerTxData.expires = RUN_AT(10*HZ);      //10s callback
+				pDevice->sTimerTxData.expires = RUN_AT(10*HZ);
 				pDevice->fTxDataInSleep = false;
 				pDevice->nTxDataTimeCout = 0;
 			}
@@ -662,7 +646,7 @@ vCommandTimer(
 #endif
 		} else if (pMgmt->eCurrState < WMAC_STATE_ASSOCPENDING) {
 			printk("WLAN_ASSOCIATE_WAIT:Association Fail???\n");
-		} else if (pDevice->byLinkWaitCount <= 4) {    //mike add:wait another 2 sec if associated_frame delay!
+		} else if (pDevice->byLinkWaitCount <= 4) {
 			pDevice->byLinkWaitCount++;
 			printk("WLAN_ASSOCIATE_WAIT:wait %d times!!\n", pDevice->byLinkWaitCount);
 			spin_unlock_irq(&pDevice->lock);
@@ -794,7 +778,7 @@ vCommandTimer(
 		s_bCommandComplete(pDevice);
 		break;
 
-	} //switch
+	}
 	spin_unlock_irq(&pDevice->lock);
 	return;
 }
@@ -812,7 +796,6 @@ s_bCommandComplete(
 
 	pDevice->eCommandState = WLAN_CMD_IDLE;
 	if (pDevice->cbFreeCmdQueue == CMD_Q_SIZE) {
-		//Command Queue Empty
 		pDevice->bCmdRunning = false;
 		return true;
 	} else {
@@ -961,7 +944,6 @@ bool bClearBSSID_SCAN(
 	return true;
 }
 
-//mike add:reset command timer
 void
 vResetCommandTimer(
 	void *hDeviceContext
@@ -969,9 +951,7 @@ vResetCommandTimer(
 {
 	PSDevice        pDevice = (PSDevice)hDeviceContext;
 
-	//delete timer
 	del_timer(&pDevice->sTimerCommand);
-	//init timer
 	init_timer(&pDevice->sTimerCommand);
 	pDevice->sTimerCommand.data = (unsigned long) pDevice;
 	pDevice->sTimerCommand.function = (TimerFunction)vCommandTimer;
@@ -996,7 +976,7 @@ BSSvSecondTxData(
 
 	if (pDevice->nTxDataTimeCout < 4)     //don't tx data if timer less than 40s
 	{
-		pDevice->sTimerTxData.expires = RUN_AT(10*HZ);      //10s callback
+		pDevice->sTimerTxData.expires = RUN_AT(10*HZ);
 		add_timer(&pDevice->sTimerTxData);
 		return;
 	}
@@ -1009,12 +989,12 @@ BSSvSecondTxData(
 		if (pDevice->bLinkPass == true) {
 #endif
 			pDevice->fTxDataInSleep = true;
-			PSbSendNullPacket(pDevice);      //send null packet
+			PSbSendNullPacket(pDevice);
 			pDevice->fTxDataInSleep = false;
 		}
 		spin_unlock_irq(&pDevice->lock);
 
-		pDevice->sTimerTxData.expires = RUN_AT(10*HZ);      //10s callback
+		pDevice->sTimerTxData.expires = RUN_AT(10*HZ);
 		add_timer(&pDevice->sTimerTxData);
 		return;
 	}
-- 
1.7.9.5

