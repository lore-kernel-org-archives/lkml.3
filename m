Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935092AbaGXXIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:08:40 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:57100 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934927AbaGXXHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:07:10 -0400
X-Originating-IP: 109.10.215.15
From: Guillaume Clement <gclement@baobob.org>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Guillaume Clement <gclement@baobob.org>
Subject: [PATCH 12/14] staging: vt6655: fix braces at newline in if statements
Date: Fri, 25 Jul 2014 01:06:26 +0200
Message-Id: <1406243188-13413-13-git-send-email-gclement@baobob.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1406243188-13413-1-git-send-email-gclement@baobob.org>
References: <1406243188-13413-1-git-send-email-gclement@baobob.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Braces should not be in a separate line for multi-line if
statements. This fixes warnings reported by checkpatch.

Signed-off-by: Guillaume Clement <gclement@baobob.org>
---
 drivers/staging/vt6655/wcmd.c | 5 +++--
 drivers/staging/vt6655/wpa.c  | 8 ++++----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6655/wcmd.c b/drivers/staging/vt6655/wcmd.c
index 0c38fcf..f12eef0 100644
--- a/drivers/staging/vt6655/wcmd.c
+++ b/drivers/staging/vt6655/wcmd.c
@@ -432,9 +432,10 @@ vCommandTimer(
 		vAdHocBeaconRestart(pDevice);
 //2008-0409-07, <Add> by Einsn Liu
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-		if (pMgmt->eScanType == WMAC_SCAN_PASSIVE)
-		{//send scan event to wpa_Supplicant
+		if (pMgmt->eScanType == WMAC_SCAN_PASSIVE) {
+			//send scan event to wpa_Supplicant
 			union iwreq_data wrqu;
+
 			memset(&wrqu, 0, sizeof(wrqu));
 			wireless_send_event(pDevice->dev, SIOCGIWSCAN, &wrqu, NULL);
 		}
diff --git a/drivers/staging/vt6655/wpa.c b/drivers/staging/vt6655/wpa.c
index 2bd9e1f..7b1bab9 100644
--- a/drivers/staging/vt6655/wpa.c
+++ b/drivers/staging/vt6655/wpa.c
@@ -123,8 +123,8 @@ WPA_ParseRSN(
 	    && (pRSN->wVersion == 1)) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Legal RSN\n");
 		// update each variable if pRSN is long enough to contain the variable
-		if (pRSN->len >= 10) //oui1(4)+ver(2)+GKSuite(4)
-		{
+		if (pRSN->len >= 10) {
+			//OUI1(4)+ver(2)+GKSuite(4)
 			if (!memcmp(pRSN->abyMulticast, abyOUI01, 4))
 				pBSSList->byGKType = WPA_WEP40;
 			else if (!memcmp(pRSN->abyMulticast, abyOUI02, 4))
@@ -142,8 +142,8 @@ WPA_ParseRSN(
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "byGKType: %x\n", pBSSList->byGKType);
 		}
 
-		if (pRSN->len >= 12) //oui1(4)+ver(2)+GKS(4)+PKSCnt(2)
-		{
+		if (pRSN->len >= 12) {
+			//oui1(4)+ver(2)+GKS(4)+PKSCnt(2)
 			j = 0;
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wPKCount: %d, sizeof(pBSSList->abyPKType): %zu\n", pRSN->wPKCount, sizeof(pBSSList->abyPKType));
 			for (i = 0; (i < pRSN->wPKCount) && (j < ARRAY_SIZE(pBSSList->abyPKType)); i++) {
-- 
1.8.5.5

