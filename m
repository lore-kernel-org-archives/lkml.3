Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaAGMNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:13:35 -0500
Received: from mx-rz-1.rrze.uni-erlangen.de ([131.188.11.20]:59820 "EHLO
	mx-rz-1.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751088AbaAGMMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:12:38 -0500
X-RRZE-Submit-IP: 131.188.42.195
From: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
To: michael.gunselmann@studium.uni-erlangen.de
Cc: martin.hofmann@studium.uni-erlangen.de, forest@alittletooquiet.net,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de
Subject: [PATCHv2 6/7] vt6655: fix printk usage in wpactl.c
Date: Tue,  7 Jan 2014 13:11:50 +0100
Message-Id: <1389096711-8595-7-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1389096711-8595-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
References: <1389096711-8595-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>

This patch fixes the usage of printk in wpactl.c concering one missing log level
occurence and some whitespaces before a newline.

Signed-off-by: Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>
Signed-off-by: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
---
 drivers/staging/vt6655/wpactl.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
index ee83704..7bad67a 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -206,7 +206,7 @@ int wpa_set_keys(PSDevice pDevice, void *ctx, bool fcpfkernel)
 	    param->u.wpa_key.seq_len >= MAX_KEY_LEN)
 		return -EINVAL;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "param->u.wpa_key.alg_name = %d \n", param->u.wpa_key.alg_name);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "param->u.wpa_key.alg_name = %d\n", param->u.wpa_key.alg_name);
 	if (param->u.wpa_key.alg_name == WPA_ALG_NONE) {
 		pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 		pDevice->bEncryptionEnable = false;
@@ -415,7 +415,7 @@ int wpa_set_keys(PSDevice pDevice, void *ctx, bool fcpfkernel)
 	//spin_unlock_irq(&pDevice->lock);
 
 /*
-  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " key=%x-%x-%x-%x-%x-xxxxx \n",
+  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " key=%x-%x-%x-%x-%x-xxxxx\n",
   pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[byKeyIndex][0],
   pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[byKeyIndex][1],
   pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[byKeyIndex][2],
@@ -596,7 +596,7 @@ static int wpa_get_scan(PSDevice pDevice,
 	ptempBSS = kmalloc(sizeof(KnownBSS), (int)GFP_ATOMIC);
 
 	if (ptempBSS == NULL) {
-		printk("bubble sort kmalloc memory fail@@@\n");
+		printk(KERN_ERR "bubble sort kmalloc memory fail@@@\n");
 
 		ret = -ENOMEM;
 
@@ -869,18 +869,18 @@ int wpa_ioctl(PSDevice pDevice, struct iw_point *p)
 	switch (param->cmd) {
 	case VIAWGET_SET_WPA:
 		ret = wpa_set_wpa(pDevice, param);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_WPA \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_WPA\n");
 		break;
 
 	case VIAWGET_SET_KEY:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_KEY \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_KEY\n");
 		spin_lock_irq(&pDevice->lock);
 		ret = wpa_set_keys(pDevice, param, false);
 		spin_unlock_irq(&pDevice->lock);
 		break;
 
 	case VIAWGET_SET_SCAN:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_SCAN \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_SCAN\n");
 		ret = wpa_set_scan(pDevice, param);
 		break;
 
@@ -891,33 +891,33 @@ int wpa_ioctl(PSDevice pDevice, struct iw_point *p)
 		break;
 
 	case VIAWGET_GET_SSID:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_GET_SSID \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_GET_SSID\n");
 		ret = wpa_get_ssid(pDevice, param);
 		wpa_ioctl = 1;
 		break;
 
 	case VIAWGET_GET_BSSID:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_GET_BSSID \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_GET_BSSID\n");
 		ret = wpa_get_bssid(pDevice, param);
 		wpa_ioctl = 1;
 		break;
 
 	case VIAWGET_SET_ASSOCIATE:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_ASSOCIATE \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_ASSOCIATE\n");
 		ret = wpa_set_associate(pDevice, param);
 		break;
 
 	case VIAWGET_SET_DISASSOCIATE:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_DISASSOCIATE \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_DISASSOCIATE\n");
 		ret = wpa_set_disassociate(pDevice, param);
 		break;
 
 	case VIAWGET_SET_DROP_UNENCRYPT:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_DROP_UNENCRYPT \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_DROP_UNENCRYPT\n");
 		break;
 
 	case VIAWGET_SET_DEAUTHENTICATE:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_DEAUTHENTICATE \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_DEAUTHENTICATE\n");
 		break;
 
 	default:
-- 
1.8.1.2

