Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbaETKeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 06:34:25 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:54573 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaETKeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 06:34:09 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Forest Bond <forest@alittletooquiet.net>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] staging: vt6655: Remove useless return variables
Date: Tue, 20 May 2014 12:33:48 +0200
Message-Id: <1400582028-24990-8-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove variables that are initialized with a constant,
are never updated, and are only used as parameter of return.
Return the constant instead of using a variable.

Verified by compilation only.

The coccinelle script that find and fixes this issue is:
// <smpl>
@@
type T;
constant C;
identifier ret;
@@
- T ret = C;
... when != ret
- return ret;
+ return C;
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/staging/vt6655/hostap.c |   10 ++++------
 drivers/staging/vt6655/wpactl.c |   19 ++++++-------------
 2 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/vt6655/hostap.c b/drivers/staging/vt6655/hostap.c
index f55d0fb..317c2a8 100644
--- a/drivers/staging/vt6655/hostap.c
+++ b/drivers/staging/vt6655/hostap.c
@@ -421,7 +421,6 @@ static int hostap_set_encryption(PSDevice pDevice,
 	unsigned char abySeq[MAX_KEY_LEN];
 	unsigned long long KeyRSC;
 	unsigned char byKeyDecMode = KEY_CTL_WEP;
-	int     ret = 0;
 	int     iNodeIndex = -1;
 	int     ii;
 	bool bKeyTableFull = false;
@@ -475,7 +474,7 @@ static int hostap_set_encryption(PSDevice pDevice,
 		       MAX_KEY_LEN
 );
 
-		return ret;
+		return 0;
 	}
 
 	memcpy(abyKey, param->u.crypt.key, param->u.crypt.key_len);
@@ -531,7 +530,7 @@ static int hostap_set_encryption(PSDevice pDevice,
 		pMgmt->byCSSGK = KEY_CTL_WEP;
 		pMgmt->sNodeDBTable[iNodeIndex].byCipherSuite = KEY_CTL_WEP;
 		pMgmt->sNodeDBTable[iNodeIndex].dwKeyIndex = dwKeyIndex;
-		return ret;
+		return 0;
 	}
 
 	if (param->u.crypt.seq) {
@@ -622,7 +621,7 @@ static int hostap_set_encryption(PSDevice pDevice,
 	pMgmt->sNodeDBTable[iNodeIndex].dwTSC47_16 = 0;
 	pMgmt->sNodeDBTable[iNodeIndex].wTSC15_0 = 0;
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -643,7 +642,6 @@ static int hostap_get_encryption(PSDevice pDevice,
 				 int param_len)
 {
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
-	int     ret = 0;
 	int     ii;
 	int     iNodeIndex = 0;
 
@@ -663,7 +661,7 @@ static int hostap_get_encryption(PSDevice pDevice,
 	for (ii = 0; ii < 8; ii++)
 		param->u.crypt.seq[ii] = (unsigned char)pMgmt->sNodeDBTable[iNodeIndex].KeyRSC >> (ii * 8);
 
-	return ret;
+	return 0;
 }
 
 /*
diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
index 089e8a7..8392d4d 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -411,12 +411,11 @@ static int wpa_set_wpa(PSDevice pDevice,
 		       struct viawget_wpa_param *param)
 {
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
-	int ret = 0;
 
 	pMgmt->eAuthenMode = WMAC_AUTH_OPEN;
 	pMgmt->bShareKeyAlgorithm = false;
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -437,7 +436,6 @@ static int wpa_set_disassociate(PSDevice pDevice,
 				struct viawget_wpa_param *param)
 {
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
-	int ret = 0;
 
 	spin_lock_irq(&pDevice->lock);
 	if (pDevice->bLinkPass) {
@@ -446,7 +444,7 @@ static int wpa_set_disassociate(PSDevice pDevice,
 	}
 	spin_unlock_irq(&pDevice->lock);
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -466,14 +464,12 @@ static int wpa_set_disassociate(PSDevice pDevice,
 static int wpa_set_scan(PSDevice pDevice,
 			struct viawget_wpa_param *param)
 {
-	int ret = 0;
-
 	spin_lock_irq(&pDevice->lock);
 	BSSvClearBSSList((void *)pDevice, pDevice->bLinkPass);
 	bScheduleCommand((void *)pDevice, WLAN_CMD_BSSID_SCAN, NULL);
 	spin_unlock_irq(&pDevice->lock);
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -494,11 +490,10 @@ static int wpa_get_bssid(PSDevice pDevice,
 			 struct viawget_wpa_param *param)
 {
 	PSMgmtObject        pMgmt = pDevice->pMgmt;
-	int ret = 0;
 
 	memcpy(param->u.wpa_associate.bssid, pMgmt->abyCurrBSSID , 6);
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -520,14 +515,13 @@ static int wpa_get_ssid(PSDevice pDevice,
 {
 	PSMgmtObject        pMgmt = pDevice->pMgmt;
 	PWLAN_IE_SSID       pItemSSID;
-	int ret = 0;
 
 	pItemSSID = (PWLAN_IE_SSID)pMgmt->abyCurrSSID;
 
 	memcpy(param->u.wpa_associate.ssid, pItemSSID->abySSID , pItemSSID->len);
 	param->u.wpa_associate.ssid_len = pItemSSID->len;
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -668,7 +662,6 @@ static int wpa_set_associate(PSDevice pDevice,
 	PWLAN_IE_SSID   pItemSSID;
 	unsigned char abyNullAddr[] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
 	unsigned char abyWPAIE[64];
-	int ret = 0;
 	bool bWepEnabled = false;
 
 	// set key type & algorithm
@@ -788,7 +781,7 @@ static int wpa_set_associate(PSDevice pDevice,
 	bScheduleCommand((void *)pDevice, WLAN_CMD_SSID, NULL);
 	spin_unlock_irq(&pDevice->lock);
 
-	return ret;
+	return 0;
 }
 
 /*

