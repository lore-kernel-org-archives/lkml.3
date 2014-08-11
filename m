Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbaHKGDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 02:03:25 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:49366 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaHKGDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 02:03:23 -0400
From: Avinash kumar <avi.kp.137@gmail.com>
To: forest@alittletooquiet.net
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Avinash kumar <avi.kp.137@gmail.com>
Subject: [PATCH] drivers: staging: vt6655: wpactl.c  checkpatch clean-up
Date: Mon, 11 Aug 2014 11:32:58 +0530
Message-Id: <1407736978-15814-1-git-send-email-avi.kp.137@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaned all C99 comments related warnings

Signed-off-by: Avinash kumar <avi.kp.137@gmail.com>

---
 drivers/staging/vt6655/wpactl.c |   40 +++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
index 8392d4d..96d2562 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -299,7 +299,7 @@ int wpa_set_keys(PSDevice pDevice, void *ctx,
 	else
 		byKeyDecMode = KEY_CTL_WEP;
 
-	// Fix HCT test that set 256 bits KEY and Ndis802_11Encryption3Enabled
+	/* Fix HCT test that set 256 bits KEY and Ndis802_11Encryption3Enabled*/
 	if (pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled) {
 		if (param->u.wpa_key.key_len == MAX_KEY_LEN)
 			byKeyDecMode = KEY_CTL_TKIP;
@@ -314,23 +314,23 @@ int wpa_set_keys(PSDevice pDevice, void *ctx,
 			byKeyDecMode = KEY_CTL_WEP;
 	}
 
-	// Check TKIP key length
+	/* Check TKIP key length*/
 	if ((byKeyDecMode == KEY_CTL_TKIP) &&
 	    (param->u.wpa_key.key_len != MAX_KEY_LEN)) {
-		// TKIP Key must be 256 bits
+		/* TKIP Key must be 256 bits*/
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "return- TKIP Key must be 256 bits!\n");
 		return -EINVAL;
 	}
-	// Check AES key length
+	/* Check AES key length*/
 	if ((byKeyDecMode == KEY_CTL_CCMP) &&
 	    (param->u.wpa_key.key_len != AES_KEY_LEN)) {
-		// AES Key must be 128 bits
+		/* AES Key must be 128 bits*/
 		return -EINVAL;
 	}
 
-	// spin_lock_irq(&pDevice->lock);
+	/* spin_lock_irq(&pDevice->lock);*/
 	if (is_broadcast_ether_addr(&param->addr[0]) || (param->addr == NULL)) {
-		// If is_broadcast_ether_addr, set the key as every key entry's group key.
+		/* If is_broadcast_ether_addr, set the key as every key entry's group key.*/
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Groupe Key Assign.\n");
 
 		if (KeybSetAllGroupKey(&(pDevice->sKey),
@@ -357,14 +357,14 @@ int wpa_set_keys(PSDevice pDevice, void *ctx,
 
 	} else {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Pairwise Key Assign.\n");
-		// BSSID not 0xffffffffffff
-		// Pairwise Key can't be WEP
+		/* BSSID not 0xffffffffffff*/
+		/* Pairwise Key can't be WEP*/
 		if (byKeyDecMode == KEY_CTL_WEP) {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Pairwise Key can't be WEP\n");
 			return -EINVAL;
 		}
 
-		dwKeyIndex |= (1 << 30); // set pairwise key
+		dwKeyIndex |= (1 << 30); /* set pairwise key*/
 		if (pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA)
 			return -EINVAL;
 
@@ -380,10 +380,10 @@ int wpa_set_keys(PSDevice pDevice, void *ctx,
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Pairwise Key Set\n");
 
 		} else {
-			// Key Table Full
+			/* Key Table Full*/
 			return -EINVAL;
 		}
-	} // BSSID not 0xffffffffffff
+	} /* BSSID not 0xffffffffffff*/
 	if ((ret == 0) && ((param->u.wpa_key.set_tx) != 0)) {
 		pDevice->byKeyIndex = (unsigned char)param->u.wpa_key.key_index;
 		pDevice->bTransmitKey = true;
@@ -584,7 +584,7 @@ static int wpa_get_scan(PSDevice pDevice,
 	kfree(ptempBSS);
 #endif
 
-//******mike:bubble sort by stronger RSSI*****//
+/*******mike:bubble sort by stronger RSSI*/
 
 	count = 0;
 	pBSS = &(pMgmt->sBSSList[0]);
@@ -664,7 +664,7 @@ static int wpa_set_associate(PSDevice pDevice,
 	unsigned char abyWPAIE[64];
 	bool bWepEnabled = false;
 
-	// set key type & algorithm
+	/* set key type & algorithm*/
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pairwise_suite = %d\n", param->u.wpa_associate.pairwise_suite);
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "group_suite = %d\n", param->u.wpa_associate.group_suite);
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "key_mgmt_suite = %d\n", param->u.wpa_associate.key_mgmt_suite);
@@ -685,13 +685,13 @@ static int wpa_set_associate(PSDevice pDevice,
 		pMgmt->eConfigMode = WMAC_CONFIG_IBSS_STA;
 	else
 		pMgmt->eConfigMode = WMAC_CONFIG_ESS_STA;
-	// set ssid
+	/* set ssid*/
 	memset(pMgmt->abyDesireSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
 	pItemSSID = (PWLAN_IE_SSID)pMgmt->abyDesireSSID;
 	pItemSSID->byElementID = WLAN_EID_SSID;
 	pItemSSID->len = param->u.wpa_associate.ssid_len;
 	memcpy(pItemSSID->abySSID, param->u.wpa_associate.ssid, pItemSSID->len);
-	// set bssid
+	/* set bssid*/
 	if (memcmp(param->u.wpa_associate.bssid, &abyNullAddr[0], 6) != 0)
 		memcpy(pMgmt->abyDesireBSSID, param->u.wpa_associate.bssid, 6);
 	else
@@ -738,7 +738,7 @@ static int wpa_set_associate(PSDevice pDevice,
 		pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 	}
 
-//DavidWang add for WPA_supplicant support open/share mode
+/*DavidWang add for WPA_supplicant support open/share mode*/
 
 	if (pMgmt->eAuthenMode == WMAC_AUTH_SHAREKEY) {
 		pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
@@ -747,7 +747,7 @@ static int wpa_set_associate(PSDevice pDevice,
 		if (!bWepEnabled)  pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 		else pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
 	}
-//mike save old encryption status
+/*mike save old encryption status*/
 	pDevice->eOldEncryptionStatus = pDevice->eEncryptionStatus;
 
 	if (pDevice->eEncryptionStatus !=  Ndis802_11EncryptionDisabled)
@@ -755,14 +755,14 @@ static int wpa_set_associate(PSDevice pDevice,
 	else
 		pDevice->bEncryptionEnable = false;
 	if (!((pMgmt->eAuthenMode == WMAC_AUTH_SHAREKEY) ||
-	      ((pMgmt->eAuthenMode == WMAC_AUTH_OPEN) && bWepEnabled)))  //DavidWang  //20080717-06,<Modify> by chester//Not to initial WEP
+	      ((pMgmt->eAuthenMode == WMAC_AUTH_OPEN) && bWepEnabled)))  /*DavidWang  //20080717-06,<Modify> by chester//Not to initial WEP*/
 		KeyvInitTable(&pDevice->sKey, pDevice->PortOffset);
 	spin_lock_irq(&pDevice->lock);
 	pDevice->bLinkPass = false;
 	memset(pMgmt->abyCurrBSSID, 0, 6);
 	pMgmt->eCurrState = WMAC_STATE_IDLE;
 	netif_stop_queue(pDevice->dev);
-	//20080701-02,<Add> by Mike Liu
+	/*20080701-02,<Add> by Mike Liu*/
 /*******search if ap_scan=2 ,which is associating request in hidden ssid mode ****/
 	{
 		PKnownBSS       pCurr = NULL;
-- 
1.7.9.5

