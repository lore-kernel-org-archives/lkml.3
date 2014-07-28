Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbaG1W1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 18:27:41 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:52753 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbaG1W1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 18:27:25 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/2] staging: vt6655: clean up the tail of function device_init_registers
Date: Mon, 28 Jul 2014 23:26:26 +0100
Message-Id: <1406586386-2789-2-git-send-email-tvboxspy@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406586386-2789-1-git-send-email-tvboxspy@gmail.com>
References: <1406586386-2789-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aligning the code.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 37 ++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 0ecc99b..3f72c34 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -736,30 +736,31 @@ static void device_init_registers(PSDevice pDevice)
 	if (pDevice->bHWRadioOff || pDevice->bRadioControlOff)
 		CARDbRadioPowerOff(pDevice);
 
-pMgmt->eScanType = WMAC_SCAN_PASSIVE;
-// get Permanent network address
-SROMvReadEtherAddress(pDevice->PortOffset, pDevice->abyCurrentNetAddr);
-DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Network address = %pM\n",
-	pDevice->abyCurrentNetAddr);
+	pMgmt->eScanType = WMAC_SCAN_PASSIVE;
 
-// reset Tx pointer
-CARDvSafeResetRx(pDevice);
-// reset Rx pointer
-CARDvSafeResetTx(pDevice);
+	/* get Permanent network address */
+	SROMvReadEtherAddress(pDevice->PortOffset, pDevice->abyCurrentNetAddr);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Network address = %pM\n",
+		pDevice->abyCurrentNetAddr);
 
-if (pDevice->byLocalID <= REV_ID_VT3253_A1)
-	MACvRegBitsOn(pDevice->PortOffset, MAC_REG_RCR, RCR_WPAERR);
+	/* reset Tx pointer */
+	CARDvSafeResetRx(pDevice);
+	/* reset Rx pointer */
+	CARDvSafeResetTx(pDevice);
 
-pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
+	if (pDevice->byLocalID <= REV_ID_VT3253_A1)
+		MACvRegBitsOn(pDevice->PortOffset, MAC_REG_RCR, RCR_WPAERR);
 
-// Turn On Rx DMA
-MACvReceive0(pDevice->PortOffset);
-MACvReceive1(pDevice->PortOffset);
+	pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 
-// start the adapter
-MACvStart(pDevice->PortOffset);
+	/* Turn On Rx DMA */
+	MACvReceive0(pDevice->PortOffset);
+	MACvReceive1(pDevice->PortOffset);
 
-netif_stop_queue(pDevice->dev);
+	/* start the adapter */
+	MACvStart(pDevice->PortOffset);
+
+	netif_stop_queue(pDevice->dev);
 }
 
 static void device_init_diversity_timer(PSDevice pDevice)
-- 
1.9.1

