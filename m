Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934449AbaGXSpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 14:45:32 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:47419 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933154AbaGXSpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 14:45:31 -0400
From: Igor Bezukh <igbzkh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org, igbzkh@gmail.com
Subject: [PATCH] Staging: vt6655: remove redundant comments from bssdb.h
Date: Thu, 24 Jul 2014 21:45:03 +0300
Message-Id: <1406227503-12309-1-git-send-email-igbzkh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed redundant comments from bssdb.h header file.

Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
---
 drivers/staging/vt6655/bssdb.h |   25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/vt6655/bssdb.h b/drivers/staging/vt6655/bssdb.h
index a0938b7..9337afe 100644
--- a/drivers/staging/vt6655/bssdb.h
+++ b/drivers/staging/vt6655/bssdb.h
@@ -35,8 +35,6 @@
 #include "80211mgr.h"
 #include "card.h"
 
-/*---------------------  Export Definitions -------------------------*/
-
 #define MAX_NODE_NUM             64
 #define MAX_BSS_NUM              42
 #define LOST_BEACON_COUNT        10   // 10 sec, XP defined
@@ -67,12 +65,6 @@
 
 #define MAX_WPA_IE_LEN      64
 
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Types  ------------------------------*/
-
 //
 // IEEE 802.11 Structures and definitions
 //
@@ -99,7 +91,6 @@ typedef struct tagSRSNCapObject {
 // BSS info(AP)
 #pragma pack(1)
 typedef struct tagKnownBSS {
-	// BSS info
 	bool bActive;
 	unsigned char abyBSSID[WLAN_BSSID_LEN];
 	unsigned int	uChannel;
@@ -116,10 +107,8 @@ typedef struct tagKnownBSS {
 	long            ldBmMAX;
 	long            ldBmAverage[RSSI_STAT_COUNT];
 	long            ldBmAverRange;
-	//For any BSSID selection improvment
 	bool bSelected;
 
-	//++ WPA informations
 	bool bWPAValid;
 	unsigned char byGKType;
 	unsigned char abyPKType[4];
@@ -128,9 +117,7 @@ typedef struct tagKnownBSS {
 	unsigned short wAuthCount;
 	unsigned char byDefaultK_as_PK;
 	unsigned char byReplayIdx;
-	//--
 
-	//++ WPA2 informations
 	bool bWPA2Valid;
 	unsigned char byCSSGK;
 	unsigned short wCSSPKCount;
@@ -138,28 +125,24 @@ typedef struct tagKnownBSS {
 	unsigned short wAKMSSAuthCount;
 	unsigned char abyAKMSSAuthType[4];
 
-	//++  wpactl
 	unsigned char byWPAIE[MAX_WPA_IE_LEN];
 	unsigned char byRSNIE[MAX_WPA_IE_LEN];
 	unsigned short wWPALen;
 	unsigned short wRSNLen;
 
-	// Clear count
 	unsigned int	uClearCount;
 	unsigned int	uIELength;
 	QWORD           qwBSSTimestamp;
-	QWORD           qwLocalTSF;     // local TSF timer
+	QWORD           qwLocalTSF;
 
-//    NDIS_802_11_NETWORK_TYPE    NetworkTypeInUse;
 	CARD_PHY_TYPE   eNetworkTypeInUse;
 
 	ERPObject       sERP;
 	SRSNCapObject   sRSNCapObj;
-	unsigned char abyIEs[1024];   // don't move this field !!
+	unsigned char abyIEs[1024];
 } __attribute__ ((__packed__))
 KnownBSS , *PKnownBSS;
 
-//2006-1116-01,<Add> by NomadZhao
 #pragma pack()
 
 typedef enum tagNODE_STATE {
@@ -172,7 +155,6 @@ typedef enum tagNODE_STATE {
 
 // STA node info
 typedef struct tagKnownNodeDB {
-	// STA info
 	bool bActive;
 	unsigned char abyMACAddr[WLAN_ADDR_LEN];
 	unsigned char abyCurrSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN];
@@ -211,7 +193,6 @@ typedef struct tagKnownNodeDB {
 	unsigned short wTSC15_0;
 	unsigned int	uWepKeyLength;
 	unsigned char abyWepKey[WLAN_WEPMAX_KEYLEN];
-	//
 	// Auto rate fallback vars
 	bool bIsInFallback;
 	unsigned int	uAverageRSSI;
@@ -228,8 +209,6 @@ typedef struct tagKnownNodeDB {
 	unsigned int	uTimeCount;
 } KnownNodeDB, *PKnownNodeDB;
 
-/*---------------------  Export Functions  --------------------------*/
-
 PKnownBSS
 BSSpSearchBSSList(
 	void *hDeviceContext,
-- 
1.7.9.5

