Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab3L3O7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 09:59:37 -0500
Received: from mx-rz-3.rrze.uni-erlangen.de ([131.188.11.22]:56558 "EHLO
	mx-rz-3.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755986Ab3L3O6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 09:58:46 -0500
X-RRZE-Submit-IP: 131.188.42.195
From: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
To: michael.gunselmann@studium.uni-erlangen.de
Cc: martin.hofmann@studium.uni-erlangen.de, forest@alittletooquiet.net,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de
Subject: [PATCH 4/7] vt6655: Fixed most of the checkpatch warnings in wpa2
Date: Mon, 30 Dec 2013 15:52:34 +0100
Message-Id: <1388415157-17615-5-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1388415157-17615-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
References: <1388415157-17615-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wpa2.h: Checkpatch does no longer complain about anything

wpa2.c: Checkpatch complains about some lines that are longer than
	80 characters. Breaking them would deteriorate the readability
	so these lines were not touched.

vntwifi.c: Fixing style problems in wpa2.h made it necessary to adjust
	   variable declarations that depended on typedefs in wpa2.h.
	   The checkpatch cleanup of this file still remains.

Signed-off-by: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
Signed-off-by: Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>
---
 drivers/staging/vt6655/vntwifi.c |   4 +-
 drivers/staging/vt6655/wpa2.c    | 186 ++++++++++++++++++++++-----------------
 drivers/staging/vt6655/wpa2.h    |  12 +--
 3 files changed, 114 insertions(+), 88 deletions(-)

diff --git a/drivers/staging/vt6655/vntwifi.c b/drivers/staging/vt6655/vntwifi.c
index e78aedf..d6f63d0 100644
--- a/drivers/staging/vt6655/vntwifi.c
+++ b/drivers/staging/vt6655/vntwifi.c
@@ -644,7 +644,7 @@ VNTWIFIbSetPMKIDCache(
 		return false;
 	}
 	pMgmt->gsPMKIDCache.BSSIDInfoCount = ulCount;
-	memcpy(pMgmt->gsPMKIDCache.BSSIDInfo, pPMKIDInfo, (ulCount*sizeof(PMKIDInfo)));
+	memcpy(pMgmt->gsPMKIDCache.BSSIDInfo, pPMKIDInfo, (ulCount*sizeof(struct PMKIDInfo)));
 	return true;
 }
 
@@ -695,7 +695,7 @@ VNTWIFIbMeasureReport(
 
 	//spin_lock_irq(&pDevice->lock);
 	if ((pvMeasureEID != NULL) &&
-	    (pMgmt->uLengthOfRepEIDs < (WLAN_A3FR_MAXLEN - sizeof(MEASEURE_REP) - sizeof(WLAN_80211HDR_A3) - 3))
+	    (pMgmt->uLengthOfRepEIDs < (WLAN_A3FR_MAXLEN - sizeof(MEASEURE_REP) - sizeof(struct WLAN_80211HDR_A3) - 3))
 ) {
 		pMgmt->pCurrMeasureEIDRep->byElementID = WLAN_EID_MEASURE_REP;
 		pMgmt->pCurrMeasureEIDRep->len = 3;
diff --git a/drivers/staging/vt6655/wpa2.c b/drivers/staging/vt6655/wpa2.c
index 2013122..3443556 100644
--- a/drivers/staging/vt6655/wpa2.c
+++ b/drivers/staging/vt6655/wpa2.c
@@ -37,7 +37,7 @@
 
 /*---------------------  Static Definitions -------------------------*/
 static int msglevel = MSG_LEVEL_INFO;
-//static int          msglevel                =MSG_LEVEL_DEBUG;
+/* static int          msglevel                =MSG_LEVEL_DEBUG; */
 /*---------------------  Static Classes  ----------------------------*/
 
 /*---------------------  Static Variables  --------------------------*/
@@ -121,19 +121,19 @@ WPA2vParseRSN(
 
 	WPA2_ClearRSN(pBSSNode);
 
-	if (pRSN->len == 2) { // ver(2)
-		if ((pRSN->byElementID == WLAN_EID_RSN) && (pRSN->wVersion == 1)) {
+	if (pRSN->len == 2) { /* ver(2) */
+		if ((pRSN->byElementID == WLAN_EID_RSN)
+		    && (pRSN->wVersion == 1))
 			pBSSNode->bWPA2Valid = true;
-		}
 		return;
 	}
 
-	if (pRSN->len < 6) { // ver(2) + GK(4)
-		// invalid CSS, P802.11i/D10.0, p31
+	if (pRSN->len < 6) { /* ver(2) + GK(4) */
+		/* invalid CSS, P802.11i/D10.0, p31 */
 		return;
 	}
 
-	// information element header makes sense
+	/* information element header makes sense */
 	if ((pRSN->byElementID == WLAN_EID_RSN) &&
 	    (pRSN->wVersion == 1)) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Legal 802.11i RSN\n");
@@ -148,97 +148,121 @@ WPA2vParseRSN(
 		else if (!memcmp(pbyOUI, abyOUIWEP104, 4))
 			pBSSNode->byCSSGK = WLAN_11i_CSS_WEP104;
 		else if (!memcmp(pbyOUI, abyOUIGK, 4)) {
-			// invalid CSS, P802.11i/D10.0, p32
+			/* invalid CSS, P802.11i/D10.0, p32 */
 			return;
 		} else
-			// any vendor checks here
+			/* any vendor checks here */
 			pBSSNode->byCSSGK = WLAN_11i_CSS_UNKNOWN;
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "802.11i CSS: %X\n", pBSSNode->byCSSGK);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"802.11i CSS: %X\n", pBSSNode->byCSSGK);
 
 		if (pRSN->len == 6) {
 			pBSSNode->bWPA2Valid = true;
 			return;
 		}
 
-		if (pRSN->len >= 8) { // ver(2) + GK(4) + PK count(2)
-			pBSSNode->wCSSPKCount = *((unsigned short *)&(pRSN->abyRSN[4]));
+		if (pRSN->len >= 8) { /* ver(2) + GK(4) + PK count(2) */
+			pBSSNode->wCSSPKCount =
+				*((unsigned short *)&(pRSN->abyRSN[4]));
 			j = 0;
 			pbyOUI = &(pRSN->abyRSN[6]);
 
-			for (i = 0; (i < pBSSNode->wCSSPKCount) && (j < sizeof(pBSSNode->abyCSSPK)/sizeof(unsigned char)); i++) {
-				if (pRSN->len >= 8+i*4+4) { // ver(2)+GK(4)+PKCnt(2)+PKS(4*i)
+			for (i = 0; (i < pBSSNode->wCSSPKCount)
+				     && (j < sizeof(pBSSNode->abyCSSPK)/sizeof(unsigned char));
+			     i++) {
+				/* ver(2)+GK(4)+PKCnt(2)+PKS(4*i) */
+				if (pRSN->len >= 8+i*4+4) {
 					if (!memcmp(pbyOUI, abyOUIGK, 4)) {
-						pBSSNode->abyCSSPK[j++] = WLAN_11i_CSS_USE_GROUP;
+						pBSSNode->abyCSSPK[j++] =
+							WLAN_11i_CSS_USE_GROUP;
 						bUseGK = true;
-					} else if (!memcmp(pbyOUI, abyOUIWEP40, 4)) {
-						// Invalid CSS, continue to parsing
-					} else if (!memcmp(pbyOUI, abyOUITKIP, 4)) {
-						if (pBSSNode->byCSSGK != WLAN_11i_CSS_CCMP)
-							pBSSNode->abyCSSPK[j++] = WLAN_11i_CSS_TKIP;
-						else
-							; // Invalid CSS, continue to parsing
-					} else if (!memcmp(pbyOUI, abyOUICCMP, 4)) {
-						pBSSNode->abyCSSPK[j++] = WLAN_11i_CSS_CCMP;
-					} else if (!memcmp(pbyOUI, abyOUIWEP104, 4)) {
-						// Invalid CSS, continue to parsing
-					} else {
-						// any vendor checks here
-						pBSSNode->abyCSSPK[j++] = WLAN_11i_CSS_UNKNOWN;
-					}
+					} else if (!memcmp(pbyOUI, abyOUIWEP40, 4))
+						; /* Invalid CSS, continue to parsing */
+					else if ((!memcmp(pbyOUI, abyOUITKIP, 4))
+						 && (pBSSNode->byCSSGK != WLAN_11i_CSS_CCMP))
+						pBSSNode->abyCSSPK[j++] =
+							WLAN_11i_CSS_TKIP;
+					else if (!memcmp(pbyOUI, abyOUICCMP, 4))
+						pBSSNode->abyCSSPK[j++] =
+							WLAN_11i_CSS_CCMP;
+					else if (!memcmp(pbyOUI, abyOUIWEP104, 4))
+						; /* Invalid CSS, continue to parsing */
+					else
+						/* any vendor checks here */
+						pBSSNode->abyCSSPK[j++] =
+							WLAN_11i_CSS_UNKNOWN;
 					pbyOUI += 4;
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "abyCSSPK[%d]: %X\n", j-1, pBSSNode->abyCSSPK[j-1]);
+					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+						"abyCSSPK[%d]: %X\n", j-1,
+						pBSSNode->abyCSSPK[j-1]);
 				} else
 					break;
-			} //for
+			} /* for */
 
 			if (bUseGK) {
 				if (j != 1) {
-					// invalid CSS, This should be only PK CSS.
+					/* invalid CSS, This should be only PK CSS. */
 					return;
 				}
 				if (pBSSNode->byCSSGK == WLAN_11i_CSS_CCMP) {
-					// invalid CSS, If CCMP is enable , PK can't be CSSGK.
+					/* invalid CSS, If CCMP is enable , PK can't be CSSGK. */
 					return;
 				}
 			}
 			if ((pBSSNode->wCSSPKCount != 0) && (j == 0)) {
-				// invalid CSS, No valid PK.
+				/* invalid CSS, No valid PK. */
 				return;
 			}
 			pBSSNode->wCSSPKCount = (unsigned short)j;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wCSSPKCount: %d\n", pBSSNode->wCSSPKCount);
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				"wCSSPKCount: %d\n", pBSSNode->wCSSPKCount);
 		}
 
 		m = *((unsigned short *)&(pRSN->abyRSN[4]));
 
-		if (pRSN->len >= 10+m*4) { // ver(2) + GK(4) + PK count(2) + PKS(4*m) + AKMSS count(2)
-			pBSSNode->wAKMSSAuthCount = *((unsigned short *)&(pRSN->abyRSN[6+4*m]));
+		/* ver(2) + GK(4) + PK count(2) + PKS(4*m) + AKMSS count(2) */
+		if (pRSN->len >= 10+m*4) {
+			pBSSNode->wAKMSSAuthCount =
+				*((unsigned short *)&(pRSN->abyRSN[6+4*m]));
 			j = 0;
 			pbyOUI = &(pRSN->abyRSN[8+4*m]);
-			for (i = 0; (i < pBSSNode->wAKMSSAuthCount) && (j < sizeof(pBSSNode->abyAKMSSAuthType)/sizeof(unsigned char)); i++) {
-				if (pRSN->len >= 10+(m+i)*4+4) { // ver(2)+GK(4)+PKCnt(2)+PKS(4*m)+AKMSS(2)+AKS(4*i)
+			for (i = 0; (i < pBSSNode->wAKMSSAuthCount)
+				     && (j < sizeof(pBSSNode->abyAKMSSAuthType)/sizeof(unsigned char));
+			     i++) {
+				/* ver(2)+GK(4)+PKCnt(2)+PKS(4*m)+AKMSS(2)+AKS(4*i) */
+				if (pRSN->len >= 10+(m+i)*4+4) {
 					if (!memcmp(pbyOUI, abyOUI8021X, 4))
-						pBSSNode->abyAKMSSAuthType[j++] = WLAN_11i_AKMSS_802_1X;
+						pBSSNode->abyAKMSSAuthType[j++] =
+							WLAN_11i_AKMSS_802_1X;
 					else if (!memcmp(pbyOUI, abyOUIPSK, 4))
-						pBSSNode->abyAKMSSAuthType[j++] = WLAN_11i_AKMSS_PSK;
+						pBSSNode->abyAKMSSAuthType[j++] =
+							WLAN_11i_AKMSS_PSK;
 					else
-						// any vendor checks here
-						pBSSNode->abyAKMSSAuthType[j++] = WLAN_11i_AKMSS_UNKNOWN;
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "abyAKMSSAuthType[%d]: %X\n", j-1, pBSSNode->abyAKMSSAuthType[j-1]);
+						/* any vendor checks here */
+						pBSSNode->abyAKMSSAuthType[j++] =
+							WLAN_11i_AKMSS_UNKNOWN;
+					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+						"abyAKMSSAuthType[%d]: %X\n",
+						j-1, pBSSNode->abyAKMSSAuthType[j-1]);
 				} else
 					break;
 			}
 			pBSSNode->wAKMSSAuthCount = (unsigned short)j;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wAKMSSAuthCount: %d\n", pBSSNode->wAKMSSAuthCount);
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				"wAKMSSAuthCount: %d\n", pBSSNode->wAKMSSAuthCount);
 
 			n = *((unsigned short *)&(pRSN->abyRSN[6+4*m]));
-			if (pRSN->len >= 12 + 4 * m + 4 * n) { // ver(2)+GK(4)+PKCnt(2)+PKS(4*m)+AKMSSCnt(2)+AKMSS(4*n)+Cap(2)
+			/* ver(2)+GK(4)+PKCnt(2)+PKS(4*m)+AKMSSCnt(2)+AKMSS(4*n)+Cap(2) */
+			if (pRSN->len >= 12 + 4 * m + 4 * n) {
 				pBSSNode->sRSNCapObj.bRSNCapExist = true;
-				pBSSNode->sRSNCapObj.wRSNCap = *((unsigned short *)&(pRSN->abyRSN[8+4*m+4*n]));
+				pBSSNode->sRSNCapObj.wRSNCap =
+					*((unsigned short *)&(pRSN->abyRSN[8+4*m+4*n]));
 			}
 		}
-		//ignore PMKID lists bcs only (Re)Assocrequest has this field
+		/* ignore PMKID lists bcs only
+		 * (Re)Assocrequest has this field
+		 */
 		pBSSNode->bWPA2Valid = true;
 	}
 }
@@ -268,66 +292,63 @@ WPA2uSetIEs(
 	unsigned int ii = 0;
 	unsigned short *pwPMKID = NULL;
 
-	if (pRSNIEs == NULL) {
+	if (pRSNIEs == NULL)
 		return 0;
-	}
 	if (((pMgmt->eAuthenMode == WMAC_AUTH_WPA2) ||
 	     (pMgmt->eAuthenMode == WMAC_AUTH_WPA2PSK)) &&
 	    (pMgmt->pCurrBSS != NULL)) {
 		/* WPA2 IE */
 		pbyBuffer = (unsigned char *)pRSNIEs;
 		pRSNIEs->byElementID = WLAN_EID_RSN;
-		pRSNIEs->len = 6; //Version(2)+GK(4)
+		pRSNIEs->len = 6; /* Version(2)+GK(4) */
 		pRSNIEs->wVersion = 1;
-		//Group Key Cipher Suite
+		/* Group Key Cipher Suite */
 		pRSNIEs->abyRSN[0] = 0x00;
 		pRSNIEs->abyRSN[1] = 0x0F;
 		pRSNIEs->abyRSN[2] = 0xAC;
-		if (pMgmt->byCSSGK == KEY_CTL_WEP) {
+		if (pMgmt->byCSSGK == KEY_CTL_WEP)
 			pRSNIEs->abyRSN[3] = pMgmt->pCurrBSS->byCSSGK;
-		} else if (pMgmt->byCSSGK == KEY_CTL_TKIP) {
+		else if (pMgmt->byCSSGK == KEY_CTL_TKIP)
 			pRSNIEs->abyRSN[3] = WLAN_11i_CSS_TKIP;
-		} else if (pMgmt->byCSSGK == KEY_CTL_CCMP) {
+		else if (pMgmt->byCSSGK == KEY_CTL_CCMP)
 			pRSNIEs->abyRSN[3] = WLAN_11i_CSS_CCMP;
-		} else {
+		else
 			pRSNIEs->abyRSN[3] = WLAN_11i_CSS_UNKNOWN;
-		}
 
-		// Pairwise Key Cipher Suite
+		/* Pairwise Key Cipher Suite */
 		pRSNIEs->abyRSN[4] = 1;
 		pRSNIEs->abyRSN[5] = 0;
 		pRSNIEs->abyRSN[6] = 0x00;
 		pRSNIEs->abyRSN[7] = 0x0F;
 		pRSNIEs->abyRSN[8] = 0xAC;
-		if (pMgmt->byCSSPK == KEY_CTL_TKIP) {
+		if (pMgmt->byCSSPK == KEY_CTL_TKIP)
 			pRSNIEs->abyRSN[9] = WLAN_11i_CSS_TKIP;
-		} else if (pMgmt->byCSSPK == KEY_CTL_CCMP) {
+		else if (pMgmt->byCSSPK == KEY_CTL_CCMP)
 			pRSNIEs->abyRSN[9] = WLAN_11i_CSS_CCMP;
-		} else if (pMgmt->byCSSPK == KEY_CTL_NONE) {
+		else if (pMgmt->byCSSPK == KEY_CTL_NONE)
 			pRSNIEs->abyRSN[9] = WLAN_11i_CSS_USE_GROUP;
-		} else {
+		else
 			pRSNIEs->abyRSN[9] = WLAN_11i_CSS_UNKNOWN;
-		}
 		pRSNIEs->len += 6;
 
-		// Auth Key Management Suite
+		/* Auth Key Management Suite */
 		pRSNIEs->abyRSN[10] = 1;
 		pRSNIEs->abyRSN[11] = 0;
 		pRSNIEs->abyRSN[12] = 0x00;
 		pRSNIEs->abyRSN[13] = 0x0F;
 		pRSNIEs->abyRSN[14] = 0xAC;
-		if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2PSK) {
+		if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2PSK)
 			pRSNIEs->abyRSN[15] = WLAN_11i_AKMSS_PSK;
-		} else if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2) {
+		else if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2)
 			pRSNIEs->abyRSN[15] = WLAN_11i_AKMSS_802_1X;
-		} else {
+		else
 			pRSNIEs->abyRSN[15] = WLAN_11i_AKMSS_UNKNOWN;
-		}
 		pRSNIEs->len += 6;
 
-		// RSN Capabilities
+		/* RSN Capabilities */
 		if (pMgmt->pCurrBSS->sRSNCapObj.bRSNCapExist == true) {
-			memcpy(&pRSNIEs->abyRSN[16], &pMgmt->pCurrBSS->sRSNCapObj.wRSNCap, 2);
+			memcpy(&pRSNIEs->abyRSN[16],
+			       &pMgmt->pCurrBSS->sRSNCapObj.wRSNCap, 2);
 		} else {
 			pRSNIEs->abyRSN[16] = 0;
 			pRSNIEs->abyRSN[17] = 0;
@@ -337,22 +358,27 @@ WPA2uSetIEs(
 		if ((pMgmt->gsPMKIDCache.BSSIDInfoCount > 0) &&
 		    pMgmt->bRoaming &&
 		    (pMgmt->eAuthenMode == WMAC_AUTH_WPA2)) {
-			// RSN PMKID
-			pwPMKID = (unsigned short *)(&pRSNIEs->abyRSN[18]);  // Point to PMKID count
-			*pwPMKID = 0;                               // Initialize PMKID count
-			pbyBuffer = &pRSNIEs->abyRSN[20];           // Point to PMKID list
+			/* RSN PMKID */
+			/* Point to PMKID count */
+			pwPMKID = (unsigned short *)(&pRSNIEs->abyRSN[18]);
+			/* Initialize PMKID count */
+			*pwPMKID = 0;
+			/* Point to PMKID list */
+			pbyBuffer = &pRSNIEs->abyRSN[20];
 			for (ii = 0; ii < pMgmt->gsPMKIDCache.BSSIDInfoCount; ii++) {
-				if (!memcmp(&pMgmt->gsPMKIDCache.BSSIDInfo[ii].abyBSSID[0], pMgmt->abyCurrBSSID, ETH_ALEN)) {
+				if (!memcmp(&pMgmt->gsPMKIDCache.BSSIDInfo[ii].abyBSSID[0],
+					    pMgmt->abyCurrBSSID, ETH_ALEN)) {
 					(*pwPMKID)++;
-					memcpy(pbyBuffer, pMgmt->gsPMKIDCache.BSSIDInfo[ii].abyPMKID, 16);
+					memcpy(pbyBuffer,
+					       pMgmt->gsPMKIDCache.BSSIDInfo[ii].abyPMKID,
+					       16);
 					pbyBuffer += 16;
 				}
 			}
-			if (*pwPMKID != 0) {
+			if (*pwPMKID != 0)
 				pRSNIEs->len += (2 + (*pwPMKID)*16);
-			} else {
+			else
 				pbyBuffer = &pRSNIEs->abyRSN[18];
-			}
 		}
 		return pRSNIEs->len + WLAN_IEHDR_LEN;
 	}
diff --git a/drivers/staging/vt6655/wpa2.h b/drivers/staging/vt6655/wpa2.h
index 2d0bd2e..73e29d3 100644
--- a/drivers/staging/vt6655/wpa2.h
+++ b/drivers/staging/vt6655/wpa2.h
@@ -39,15 +39,15 @@
 /*---------------------  Export Definitions -------------------------*/
 #define MAX_PMKID_CACHE         16
 
-typedef struct tagsPMKIDInfo {
+struct PMKIDInfo {
 	unsigned char abyBSSID[6];
 	unsigned char abyPMKID[16];
-} PMKIDInfo, *PPMKIDInfo;
+};
 
-typedef struct tagSPMKIDCache {
+struct SPMKIDCache {
 	unsigned long BSSIDInfoCount;
-	PMKIDInfo   BSSIDInfo[MAX_PMKID_CACHE];
-} SPMKIDCache, *PSPMKIDCache;
+	struct PMKIDInfo   BSSIDInfo[MAX_PMKID_CACHE];
+};
 
 /*---------------------  Export Classes  ----------------------------*/
 
@@ -74,4 +74,4 @@ WPA2uSetIEs(
 	PWLAN_IE_RSN pRSNIEs
 );
 
-#endif // __WPA2_H__
+#endif /* __WPA2_H__ */
-- 
1.8.1.2

