Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbaAGMNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:13:52 -0500
Received: from mx-rz-3.rrze.uni-erlangen.de ([131.188.11.22]:55416 "EHLO
	mx-rz-3.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843AbaAGMMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:12:38 -0500
X-RRZE-Submit-IP: 131.188.42.195
From: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
To: michael.gunselmann@studium.uni-erlangen.de
Cc: martin.hofmann@studium.uni-erlangen.de, forest@alittletooquiet.net,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de,
        Martin Hofmann <martin.hofmann@studium.uni-erlange.de>,
        Michael Gunselmann <michael.gunselmann@studium.uni-erlange.de>
Subject: [PATCHv2 7/7] vt6655: Remove typedefs in 80211hdr.h
Date: Tue,  7 Jan 2014 13:11:51 +0100
Message-Id: <1389096711-8595-8-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1389096711-8595-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
References: <1389096711-8595-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>

The file 80211hdr.h contained typedefs for 5 types. To satisfy checkpatch,
this commit removes them. In 11 other files, every occurence of a now deleted
type has been substituted with the correct struct ... syntax.

Signed-off-by: Martin Hofmann <martin.hofmann@studium.uni-erlange.de>
Signed-off-by: Michael Gunselmann <michael.gunselmann@studium.uni-erlange.de>
---
 drivers/staging/vt6655/80211hdr.h | 31 ++++++++++++-------------
 drivers/staging/vt6655/80211mgr.c | 48 +++++++++++++++++++--------------------
 drivers/staging/vt6655/80211mgr.h | 26 ++++++++++-----------
 drivers/staging/vt6655/IEEE11h.c  | 14 ++++++------
 drivers/staging/vt6655/dpc.c      |  2 +-
 drivers/staging/vt6655/mib.c      |  4 ++--
 drivers/staging/vt6655/power.c    |  4 ++--
 drivers/staging/vt6655/rxtx.c     |  7 +++---
 drivers/staging/vt6655/vntwifi.c  |  2 +-
 drivers/staging/vt6655/wcmd.c     |  2 +-
 drivers/staging/vt6655/wmgr.c     | 24 ++++++++++----------
 drivers/staging/vt6655/wmgr.h     |  4 ++--
 12 files changed, 83 insertions(+), 85 deletions(-)

diff --git a/drivers/staging/vt6655/80211hdr.h b/drivers/staging/vt6655/80211hdr.h
index ba155cd..b2e2c5b 100644
--- a/drivers/staging/vt6655/80211hdr.h
+++ b/drivers/staging/vt6655/80211hdr.h
@@ -274,31 +274,29 @@
 #define IEEE_ADDR_UNIVERSAL         0x02
 #define IEEE_ADDR_GROUP             0x01
 
-typedef struct {
+struct IEEE_ADDR {
 	unsigned char abyAddr[6];
-} IEEE_ADDR, *PIEEE_ADDR;
+};
 
 /* 802.11 Header Format */
 
-typedef struct tagWLAN_80211HDR_A2 {
+struct WLAN_80211HDR_A2 {
 	unsigned short wFrameCtl;
 	unsigned short wDurationID;
 	unsigned char abyAddr1[WLAN_ADDR_LEN];
 	unsigned char abyAddr2[WLAN_ADDR_LEN];
-} __attribute__ ((__packed__))
-WLAN_80211HDR_A2, *PWLAN_80211HDR_A2;
+} __attribute__((__packed__));
 
-typedef struct tagWLAN_80211HDR_A3 {
+struct WLAN_80211HDR_A3 {
 	unsigned short wFrameCtl;
 	unsigned short wDurationID;
 	unsigned char abyAddr1[WLAN_ADDR_LEN];
 	unsigned char abyAddr2[WLAN_ADDR_LEN];
 	unsigned char abyAddr3[WLAN_ADDR_LEN];
 	unsigned short wSeqCtl;
-} __attribute__ ((__packed__))
-WLAN_80211HDR_A3, *PWLAN_80211HDR_A3;
+} __attribute__((__packed__));
 
-typedef struct tagWLAN_80211HDR_A4 {
+struct WLAN_80211HDR_A4 {
 	unsigned short wFrameCtl;
 	unsigned short wDurationID;
 	unsigned char abyAddr1[WLAN_ADDR_LEN];
@@ -306,14 +304,13 @@ typedef struct tagWLAN_80211HDR_A4 {
 	unsigned char abyAddr3[WLAN_ADDR_LEN];
 	unsigned short wSeqCtl;
 	unsigned char abyAddr4[WLAN_ADDR_LEN];
-} __attribute__ ((__packed__))
-WLAN_80211HDR_A4, *PWLAN_80211HDR_A4;
-
-typedef union tagUWLAN_80211HDR {
-	WLAN_80211HDR_A2        sA2;
-	WLAN_80211HDR_A3        sA3;
-	WLAN_80211HDR_A4        sA4;
-} UWLAN_80211HDR, *PUWLAN_80211HDR;
+} __attribute__((__packed__));
+
+union UWLAN_80211HDR {
+	struct WLAN_80211HDR_A2 sA2;
+	struct WLAN_80211HDR_A3 sA3;
+	struct WLAN_80211HDR_A4 sA4;
+};
 
 /*---------------------  Export Classes  ----------------------------*/
 
diff --git a/drivers/staging/vt6655/80211mgr.c b/drivers/staging/vt6655/80211mgr.c
index 7949d58..e586e51 100644
--- a/drivers/staging/vt6655/80211mgr.c
+++ b/drivers/staging/vt6655/80211mgr.c
@@ -88,7 +88,7 @@ vMgrEncodeBeacon(
 	PWLAN_FR_BEACON  pFrame
 )
 {
-	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
+	pFrame->pHdr = (union UWLAN_80211HDR *)pFrame->pBuf;
 
 	/* Fixed Fields */
 	pFrame->pqwTimestamp = (PQWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -121,7 +121,7 @@ vMgrDecodeBeacon(
 {
 	PWLAN_IE        pItem;
 
-	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
+	pFrame->pHdr = (union UWLAN_80211HDR *)pFrame->pBuf;
 
 	/* Fixed Fields */
 	pFrame->pqwTimestamp = (PQWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -236,7 +236,7 @@ vMgrEncodeIBSSATIM(
 	PWLAN_FR_IBSSATIM   pFrame
 )
 {
-	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
+	pFrame->pHdr = (union UWLAN_80211HDR *)pFrame->pBuf;
 	pFrame->len = WLAN_HDR_ADDR3_LEN;
 
 	return;
@@ -258,7 +258,7 @@ vMgrDecodeIBSSATIM(
 	PWLAN_FR_IBSSATIM   pFrame
 )
 {
-	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
+	pFrame->pHdr = (union UWLAN_80211HDR *)pFrame->pBuf;
 
 	return;
 }
@@ -279,7 +279,7 @@ vMgrEncodeDisassociation(
 	PWLAN_FR_DISASSOC  pFrame
 )
 {
-	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
+	pFrame->pHdr = (union UWLAN_80211HDR *)pFrame->pBuf;
 
 	/* Fixed Fields */
 	pFrame->pwReason = (unsigned short *)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -305,7 +305,7 @@ vMgrDecodeDisassociation(
 	PWLAN_FR_DISASSOC  pFrame
 )
 {
-	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
+	pFrame->pHdr = (union UWLAN_80211HDR *)pFrame->pBuf;
 
 	/* Fixed Fields */
 	pFrame->pwReason = (unsigned short *)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -330,7 +330,7 @@ vMgrEncodeAssocRequest(
 	PWLAN_FR_ASSOCREQ  pFrame
 )
 {
-	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
+	pFrame->pHdr = (union UWLAN_80211HDR *)pFrame->pBuf;
 	/* Fixed Fields */
 	pFrame->pwCapInfo = (unsigned short *)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
 					       + WLAN_ASSOCREQ_OFF_CAP_INFO);
@@ -358,7 +358,7 @@ vMgrDecodeAssocRequest(
 {
 	PWLAN_IE   pItem;
 
-	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
+	pFrame->pHdr = (union UWLAN_80211HDR *)pFrame->pBuf;
 	/* Fixed Fields */
 	pFrame->pwCapInfo = (unsigned short *)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
 					       + WLAN_ASSOCREQ_OFF_CAP_INFO);
@@ -421,7 +421,7 @@ vMgrEncodeAssocResponse(
 	PWLAN_FR_ASSOCRESP  pFrame
 )
 {
-	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
+	pFrame->pHdr = (union UWLAN_80211HDR *)pFrame->pBuf;
 
 	/* Fixed Fields */
 	pFrame->pwCapInfo = (unsigned short *)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -454,7 +454,7 @@ vMgrDecodeAssocResponse(
 {
 	PWLAN_IE   pItem;
 
-	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
+	pFrame->pHdr = (union UWLAN_80211HDR *)pFrame->pBuf;
 
 	/* Fixed Fields */
 	pFrame->pwCapInfo = (unsigned short *)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -497,14 +497,14 @@ vMgrEncodeReassocRequest(
 	PWLAN_FR_REASSOCREQ  pFrame
 )
 {
-	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
+	pFrame->pHdr = (union UWLAN_80211HDR *)pFrame->pBuf;
 
 	/* Fixed Fields */
 	pFrame->pwCapInfo = (unsigned short *)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
 					       + WLAN_REASSOCREQ_OFF_CAP_INFO);
 	pFrame->pwListenInterval = (unsigned short *)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
 						      + WLAN_REASSOCREQ_OFF_LISTEN_INT);
-	pFrame->pAddrCurrAP = (PIEEE_ADDR)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
+	pFrame->pAddrCurrAP = (struct IEEE_ADDR *)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
 					   + WLAN_REASSOCREQ_OFF_CURR_AP);
 	pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_REASSOCREQ_OFF_CURR_AP + sizeof(*(pFrame->pAddrCurrAP));
 
@@ -528,14 +528,14 @@ vMgrDecodeReassocRequest(
 )
 {
 	PWLAN_IE   pItem;
-	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
+	pFrame->pHdr = (union UWLAN_80211HDR *)pFrame->pBuf;
 
 	/* Fixed Fields */
 	pFrame->pwCapInfo = (unsigned short *)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
 					       + WLAN_REASSOCREQ_OFF_CAP_INFO);
 	pFrame->pwListenInterval = (unsigned short *)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
 						      + WLAN_REASSOCREQ_OFF_LISTEN_INT);
-	pFrame->pAddrCurrAP = (PIEEE_ADDR)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
+	pFrame->pAddrCurrAP = (struct IEEE_ADDR *)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
 					   + WLAN_REASSOCREQ_OFF_CURR_AP);
 
 	/* Information elements */
@@ -594,7 +594,7 @@ vMgrEncodeProbeRequest(
 	PWLAN_FR_PROBEREQ  pFrame
 )
 {
-	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
+	pFrame->pHdr = (union UWLAN_80211HDR *)pFrame->pBuf;
 	pFrame->len = WLAN_HDR_ADDR3_LEN;
 	return;
 }
@@ -617,7 +617,7 @@ vMgrDecodeProbeRequest(
 {
 	PWLAN_IE   pItem;
 
-	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
+	pFrame->pHdr = (union UWLAN_80211HDR *)pFrame->pBuf;
 
 	/* Information elements */
 	pItem = (PWLAN_IE)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3)));
@@ -665,7 +665,7 @@ vMgrEncodeProbeResponse(
 	PWLAN_FR_PROBERESP  pFrame
 )
 {
-	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
+	pFrame->pHdr = (union UWLAN_80211HDR *)pFrame->pBuf;
 
 	/* Fixed Fields */
 	pFrame->pqwTimestamp = (PQWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -699,7 +699,7 @@ vMgrDecodeProbeResponse(
 {
 	PWLAN_IE    pItem;
 
-	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
+	pFrame->pHdr = (union UWLAN_80211HDR *)pFrame->pBuf;
 
 	/* Fixed Fields */
 	pFrame->pqwTimestamp = (PQWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -808,7 +808,7 @@ vMgrEncodeAuthen(
 	PWLAN_FR_AUTHEN  pFrame
 )
 {
-	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
+	pFrame->pHdr = (union UWLAN_80211HDR *)pFrame->pBuf;
 
 	/* Fixed Fields */
 	pFrame->pwAuthAlgorithm = (unsigned short *)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -840,7 +840,7 @@ vMgrDecodeAuthen(
 {
 	PWLAN_IE    pItem;
 
-	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
+	pFrame->pHdr = (union UWLAN_80211HDR *)pFrame->pBuf;
 
 	/* Fixed Fields */
 	pFrame->pwAuthAlgorithm = (unsigned short *)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -877,7 +877,7 @@ vMgrEncodeDeauthen(
 	PWLAN_FR_DEAUTHEN  pFrame
 )
 {
-	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
+	pFrame->pHdr = (union UWLAN_80211HDR *)pFrame->pBuf;
 
 	/* Fixed Fields */
 	pFrame->pwReason = (unsigned short *)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -903,7 +903,7 @@ vMgrDecodeDeauthen(
 	PWLAN_FR_DEAUTHEN  pFrame
 )
 {
-	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
+	pFrame->pHdr = (union UWLAN_80211HDR *)pFrame->pBuf;
 
 	/* Fixed Fields */
 	pFrame->pwReason = (unsigned short *)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -928,7 +928,7 @@ vMgrEncodeReassocResponse(
 	PWLAN_FR_REASSOCRESP  pFrame
 )
 {
-	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
+	pFrame->pHdr = (union UWLAN_80211HDR *)pFrame->pBuf;
 
 	/* Fixed Fields */
 	pFrame->pwCapInfo = (unsigned short *)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -961,7 +961,7 @@ vMgrDecodeReassocResponse(
 {
 	PWLAN_IE   pItem;
 
-	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
+	pFrame->pHdr = (union UWLAN_80211HDR *)pFrame->pBuf;
 
 	/* Fixed Fields */
 	pFrame->pwCapInfo = (unsigned short *)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
diff --git a/drivers/staging/vt6655/80211mgr.h b/drivers/staging/vt6655/80211mgr.h
index 065238b..e1114ff 100644
--- a/drivers/staging/vt6655/80211mgr.h
+++ b/drivers/staging/vt6655/80211mgr.h
@@ -463,7 +463,7 @@ typedef struct tagWLAN_FR_MGMT {
 	unsigned int	uType;
 	unsigned int	len;
 	unsigned char *pBuf;
-	PUWLAN_80211HDR       pHdr;
+	union UWLAN_80211HDR *pHdr;
 } WLAN_FR_MGMT,  *PWLAN_FR_MGMT;
 
 /* Beacon frame */
@@ -471,7 +471,7 @@ typedef struct tagWLAN_FR_BEACON {
 	unsigned int	uType;
 	unsigned int	len;
 	unsigned char *pBuf;
-	PUWLAN_80211HDR         pHdr;
+	union UWLAN_80211HDR *pHdr;
 	/* fixed fields */
 	PQWORD                  pqwTimestamp;
 	unsigned short *pwBeaconInterval;
@@ -500,7 +500,7 @@ typedef struct tagWLAN_FR_IBSSATIM {
 	unsigned int	uType;
 	unsigned int	len;
 	unsigned char *pBuf;
-	PUWLAN_80211HDR         pHdr;
+	union UWLAN_80211HDR *pHdr;
 
 	/* fixed fields */
 	/* info elements */
@@ -512,7 +512,7 @@ typedef struct tagWLAN_FR_DISASSOC {
 	unsigned int	uType;
 	unsigned int	len;
 	unsigned char *pBuf;
-	PUWLAN_80211HDR         pHdr;
+	union UWLAN_80211HDR *pHdr;
 	/*-- fixed fields -----------*/
 	unsigned short *pwReason;
 	/*-- info elements ----------*/
@@ -523,7 +523,7 @@ typedef struct tagWLAN_FR_ASSOCREQ {
 	unsigned int	uType;
 	unsigned int	len;
 	unsigned char *pBuf;
-	PUWLAN_80211HDR         pHdr;
+	union UWLAN_80211HDR *pHdr;
 	/*-- fixed fields -----------*/
 	unsigned short *pwCapInfo;
 	unsigned short *pwListenInterval;
@@ -542,7 +542,7 @@ typedef struct tagWLAN_FR_ASSOCRESP {
 	unsigned int	uType;
 	unsigned int	len;
 	unsigned char *pBuf;
-	PUWLAN_80211HDR         pHdr;
+	union UWLAN_80211HDR *pHdr;
 	/*-- fixed fields -----------*/
 	unsigned short *pwCapInfo;
 	unsigned short *pwStatus;
@@ -557,12 +557,12 @@ typedef struct tagWLAN_FR_REASSOCREQ {
 	unsigned int	uType;
 	unsigned int	len;
 	unsigned char *pBuf;
-	PUWLAN_80211HDR         pHdr;
+	union UWLAN_80211HDR *pHdr;
 
 	/*-- fixed fields -----------*/
 	unsigned short *pwCapInfo;
 	unsigned short *pwListenInterval;
-	PIEEE_ADDR              pAddrCurrAP;
+	struct IEEE_ADDR *pAddrCurrAP;
 
 	/*-- info elements ----------*/
 	PWLAN_IE_SSID           pSSID;
@@ -577,7 +577,7 @@ typedef struct tagWLAN_FR_REASSOCRESP {
 	unsigned int	uType;
 	unsigned int	len;
 	unsigned char *pBuf;
-	PUWLAN_80211HDR         pHdr;
+	union UWLAN_80211HDR *pHdr;
 	/*-- fixed fields -----------*/
 	unsigned short *pwCapInfo;
 	unsigned short *pwStatus;
@@ -592,7 +592,7 @@ typedef struct tagWLAN_FR_PROBEREQ {
 	unsigned int	uType;
 	unsigned int	len;
 	unsigned char *pBuf;
-	PUWLAN_80211HDR         pHdr;
+	union UWLAN_80211HDR *pHdr;
 	/*-- fixed fields -----------*/
 	/*-- info elements ----------*/
 	PWLAN_IE_SSID           pSSID;
@@ -605,7 +605,7 @@ typedef struct tagWLAN_FR_PROBERESP {
 	unsigned int	uType;
 	unsigned int	len;
 	unsigned char *pBuf;
-	PUWLAN_80211HDR         pHdr;
+	union UWLAN_80211HDR *pHdr;
 	/*-- fixed fields -----------*/
 	PQWORD                  pqwTimestamp;
 	unsigned short *pwBeaconInterval;
@@ -632,7 +632,7 @@ typedef struct tagWLAN_FR_AUTHEN {
 	unsigned int	uType;
 	unsigned int	len;
 	unsigned char *pBuf;
-	PUWLAN_80211HDR         pHdr;
+	union UWLAN_80211HDR *pHdr;
 	/*-- fixed fields -----------*/
 	unsigned short *pwAuthAlgorithm;
 	unsigned short *pwAuthSequence;
@@ -646,7 +646,7 @@ typedef struct tagWLAN_FR_DEAUTHEN {
 	unsigned int	uType;
 	unsigned int	len;
 	unsigned char *pBuf;
-	PUWLAN_80211HDR         pHdr;
+	union UWLAN_80211HDR *pHdr;
 	/*-- fixed fields -----------*/
 	unsigned short *pwReason;
 
diff --git a/drivers/staging/vt6655/IEEE11h.c b/drivers/staging/vt6655/IEEE11h.c
index dfda3c8..5b3eaf0 100644
--- a/drivers/staging/vt6655/IEEE11h.c
+++ b/drivers/staging/vt6655/IEEE11h.c
@@ -46,14 +46,14 @@ static int          msglevel                = MSG_LEVEL_INFO;
 #pragma pack(1)
 
 typedef struct _WLAN_FRAME_ACTION {
-	WLAN_80211HDR_A3    Header;
+	struct WLAN_80211HDR_A3 Header;
 	unsigned char byCategory;
 	unsigned char byAction;
 	unsigned char abyVars[1];
 } WLAN_FRAME_ACTION, *PWLAN_FRAME_ACTION;
 
 typedef struct _WLAN_FRAME_MSRREQ {
-	WLAN_80211HDR_A3    Header;
+	struct WLAN_80211HDR_A3 Header;
 	unsigned char byCategory;
 	unsigned char byAction;
 	unsigned char byDialogToken;
@@ -61,7 +61,7 @@ typedef struct _WLAN_FRAME_MSRREQ {
 } WLAN_FRAME_MSRREQ, *PWLAN_FRAME_MSRREQ;
 
 typedef struct _WLAN_FRAME_MSRREP {
-	WLAN_80211HDR_A3    Header;
+	struct WLAN_80211HDR_A3 Header;
 	unsigned char byCategory;
 	unsigned char byAction;
 	unsigned char byDialogToken;
@@ -69,7 +69,7 @@ typedef struct _WLAN_FRAME_MSRREP {
 } WLAN_FRAME_MSRREP, *PWLAN_FRAME_MSRREP;
 
 typedef struct _WLAN_FRAME_TPCREQ {
-	WLAN_80211HDR_A3    Header;
+	struct WLAN_80211HDR_A3 Header;
 	unsigned char byCategory;
 	unsigned char byAction;
 	unsigned char byDialogToken;
@@ -77,7 +77,7 @@ typedef struct _WLAN_FRAME_TPCREQ {
 } WLAN_FRAME_TPCREQ, *PWLAN_FRAME_TPCREQ;
 
 typedef struct _WLAN_FRAME_TPCREP {
-	WLAN_80211HDR_A3    Header;
+	struct WLAN_80211HDR_A3 Header;
 	unsigned char byCategory;
 	unsigned char byAction;
 	unsigned char byDialogToken;
@@ -130,7 +130,7 @@ static bool s_bRxTPCReq(PSMgmtObject pMgmt,
 
 	pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
 	memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_A3FR_MAXLEN);
-	pTxPacket->p80211Header = (PUWLAN_80211HDR)((unsigned char *)pTxPacket +
+	pTxPacket->p80211Header = (union UWLAN_80211HDR *)((unsigned char *)pTxPacket +
 						    sizeof(STxMgmtPacket));
 
 	pFrame = (PWLAN_FRAME_TPCREP)((unsigned char *)pTxPacket +
@@ -291,7 +291,7 @@ bool IEEE11hbMSRRepTx(void *pMgmtHandle)
 
 	pTxPacket = (PSTxMgmtPacket)pMgmt->abyCurrentMSRRep;
 	memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_A3FR_MAXLEN);
-	pTxPacket->p80211Header = (PUWLAN_80211HDR)((unsigned char *)pTxPacket +
+	pTxPacket->p80211Header = (union UWLAN_80211HDR *)((unsigned char *)pTxPacket +
 						    sizeof(STxMgmtPacket));
 
 	pMSRRep->Header.wFrameCtl = (WLAN_SET_FC_FTYPE(WLAN_FTYPE_MGMT) |
diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index 0a29c90..6de720b 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -538,7 +538,7 @@ device_receive_frame(
 			unsigned char *pbyData1;
 			unsigned char *pbyData2;
 
-			pRxPacket->p80211Header = (PUWLAN_80211HDR)(skb->data+4);
+			pRxPacket->p80211Header = (union UWLAN_80211HDR *)(skb->data+4);
 			pRxPacket->cbMPDULen = FrameSize;
 			pRxPacket->uRSSI = *pbyRSSI;
 			pRxPacket->bySQ = *pbySQ;
diff --git a/drivers/staging/vt6655/mib.c b/drivers/staging/vt6655/mib.c
index 6a59652..53e223f 100644
--- a/drivers/staging/vt6655/mib.c
+++ b/drivers/staging/vt6655/mib.c
@@ -394,11 +394,11 @@ STAvUpdateTDStatCounter(
 	unsigned int uIdx
 )
 {
-	PWLAN_80211HDR_A4   pHeader;
+	struct WLAN_80211HDR_A4 *pHeader;
 	unsigned char *pbyDestAddr;
 	unsigned char byTSR0_NCR = byTSR0 & TSR0_NCR;
 
-	pHeader = (PWLAN_80211HDR_A4) pbyBuffer;
+	pHeader = (struct WLAN_80211HDR_A4 *)pbyBuffer;
 	if (WLAN_GET_FC_TODS(pHeader->wFrameCtl) == 0) {
 		pbyDestAddr = &(pHeader->abyAddr1[0]);
 	} else {
diff --git a/drivers/staging/vt6655/power.c b/drivers/staging/vt6655/power.c
index 4bd1ccb..12a577d 100644
--- a/drivers/staging/vt6655/power.c
+++ b/drivers/staging/vt6655/power.c
@@ -243,7 +243,7 @@ PSvSendPSPOLL(
 
 	memset(pMgmt->pbyPSPacketPool, 0, sizeof(STxMgmtPacket) + WLAN_HDR_ADDR2_LEN);
 	pTxPacket = (PSTxMgmtPacket)pMgmt->pbyPSPacketPool;
-	pTxPacket->p80211Header = (PUWLAN_80211HDR)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
+	pTxPacket->p80211Header = (union UWLAN_80211HDR *)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
 	pTxPacket->p80211Header->sA2.wFrameCtl = cpu_to_le16(
 		(
 			WLAN_SET_FC_FTYPE(WLAN_TYPE_CTL) |
@@ -305,7 +305,7 @@ PSbSendNullPacket(
 
 	memset(pMgmt->pbyPSPacketPool, 0, sizeof(STxMgmtPacket) + WLAN_NULLDATA_FR_MAXLEN);
 	pTxPacket = (PSTxMgmtPacket)pMgmt->pbyPSPacketPool;
-	pTxPacket->p80211Header = (PUWLAN_80211HDR)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
+	pTxPacket->p80211Header = (union UWLAN_80211HDR *)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
 
 	if (pDevice->bEnablePSMode) {
 		pTxPacket->p80211Header->sA3.wFrameCtl = cpu_to_le16(
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 6affd6e..5f18051 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -2107,7 +2107,8 @@ vGenerateMACHeader(
 	pMACHeader->wDurationID = cpu_to_le16(wDuration);
 
 	if (pDevice->bLongHeader) {
-		PWLAN_80211HDR_A4 pMACA4Header  = (PWLAN_80211HDR_A4) pbyBufferAddr;
+		struct WLAN_80211HDR_A4 *pMACA4Header =
+			(struct WLAN_80211HDR_A4 *)pbyBufferAddr;
 		pMACHeader->wFrameCtl |= (FC_TODS | FC_FROMDS);
 		memcpy(pMACA4Header->abyAddr4, pDevice->abyBSSID, WLAN_ADDR_LEN);
 	}
@@ -2603,7 +2604,7 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, unsigned char *pbMPDU, un
 	void *pMICHDR;
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 	unsigned short wCurrentRate = RATE_1M;
-	PUWLAN_80211HDR  p80211Header;
+	union UWLAN_80211HDR *p80211Header;
 	unsigned int uNodeIndex = 0;
 	bool bNodeExist = false;
 	SKeyItem        STempKey;
@@ -2622,7 +2623,7 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, unsigned char *pbMPDU, un
 	} else {
 		cbFrameBodySize = cbMPDULen - WLAN_HDR_ADDR3_LEN;
 	}
-	p80211Header = (PUWLAN_80211HDR)pbMPDU;
+	p80211Header = (union UWLAN_80211HDR *)pbMPDU;
 
 	pFrstTD = pDevice->apCurrTD[TYPE_TXDMA0];
 	pbyTxBufferAddr = (unsigned char *)pFrstTD->pTDInfo->buf;
diff --git a/drivers/staging/vt6655/vntwifi.c b/drivers/staging/vt6655/vntwifi.c
index e78aedf..39a9b09 100644
--- a/drivers/staging/vt6655/vntwifi.c
+++ b/drivers/staging/vt6655/vntwifi.c
@@ -695,7 +695,7 @@ VNTWIFIbMeasureReport(
 
 	//spin_lock_irq(&pDevice->lock);
 	if ((pvMeasureEID != NULL) &&
-	    (pMgmt->uLengthOfRepEIDs < (WLAN_A3FR_MAXLEN - sizeof(MEASEURE_REP) - sizeof(WLAN_80211HDR_A3) - 3))
+	    (pMgmt->uLengthOfRepEIDs < (WLAN_A3FR_MAXLEN - sizeof(MEASEURE_REP) - sizeof(struct WLAN_80211HDR_A3) - 3))
 ) {
 		pMgmt->pCurrMeasureEIDRep->byElementID = WLAN_EID_MEASURE_REP;
 		pMgmt->pCurrMeasureEIDRep->len = 3;
diff --git a/drivers/staging/vt6655/wcmd.c b/drivers/staging/vt6655/wcmd.c
index 72caaa2..7fe4c0c 100644
--- a/drivers/staging/vt6655/wcmd.c
+++ b/drivers/staging/vt6655/wcmd.c
@@ -253,7 +253,7 @@ s_MgrMakeProbeRequest(
 
 	pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
 	memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_PROBEREQ_FR_MAXLEN);
-	pTxPacket->p80211Header = (PUWLAN_80211HDR)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
+	pTxPacket->p80211Header = (union UWLAN_80211HDR *)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
 	sFrame.pBuf = (unsigned char *)pTxPacket->p80211Header;
 	sFrame.len = WLAN_PROBEREQ_FR_MAXLEN;
 	vMgrEncodeProbeRequest(&sFrame);
diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index 5200a2a..f1bb9c4 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -600,7 +600,7 @@ vMgrDisassocBeginSta(
 
 	pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
 	memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_DISASSOC_FR_MAXLEN);
-	pTxPacket->p80211Header = (PUWLAN_80211HDR)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
+	pTxPacket->p80211Header = (union UWLAN_80211HDR *)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
 
 	// Setup the sFrame structure
 	sFrame.pBuf = (unsigned char *)pTxPacket->p80211Header;
@@ -1110,7 +1110,7 @@ vMgrAuthenBeginSta(
 
 	pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
 	memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_AUTHEN_FR_MAXLEN);
-	pTxPacket->p80211Header = (PUWLAN_80211HDR)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
+	pTxPacket->p80211Header = (union UWLAN_80211HDR *)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
 	sFrame.pBuf = (unsigned char *)pTxPacket->p80211Header;
 	sFrame.len = WLAN_AUTHEN_FR_MAXLEN;
 	vMgrEncodeAuthen(&sFrame);
@@ -1168,7 +1168,7 @@ vMgrDeAuthenBeginSta(
 
 	pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
 	memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_DEAUTHEN_FR_MAXLEN);
-	pTxPacket->p80211Header = (PUWLAN_80211HDR)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
+	pTxPacket->p80211Header = (union UWLAN_80211HDR *)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
 	sFrame.pBuf = (unsigned char *)pTxPacket->p80211Header;
 	sFrame.len = WLAN_DEAUTHEN_FR_MAXLEN;
 	vMgrEncodeDeauthen(&sFrame);
@@ -1291,7 +1291,7 @@ s_vMgrRxAuthenSequence_1(
 	// send auth reply
 	pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
 	memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_AUTHEN_FR_MAXLEN);
-	pTxPacket->p80211Header = (PUWLAN_80211HDR)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
+	pTxPacket->p80211Header = (union UWLAN_80211HDR *)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
 	sFrame.pBuf = (unsigned char *)pTxPacket->p80211Header;
 	sFrame.len = WLAN_AUTHEN_FR_MAXLEN;
 	// format buffer structure
@@ -1397,7 +1397,7 @@ s_vMgrRxAuthenSequence_2(
 		if (cpu_to_le16((*(pFrame->pwStatus))) == WLAN_MGMT_STATUS_SUCCESS) {
 			pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
 			memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_AUTHEN_FR_MAXLEN);
-			pTxPacket->p80211Header = (PUWLAN_80211HDR)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
+			pTxPacket->p80211Header = (union UWLAN_80211HDR *)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
 			sFrame.pBuf = (unsigned char *)pTxPacket->p80211Header;
 			sFrame.len = WLAN_AUTHEN_FR_MAXLEN;
 			// format buffer structure
@@ -1500,7 +1500,7 @@ reply:
 	// send auth reply
 	pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
 	memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_AUTHEN_FR_MAXLEN);
-	pTxPacket->p80211Header = (PUWLAN_80211HDR)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
+	pTxPacket->p80211Header = (union UWLAN_80211HDR *)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
 	sFrame.pBuf = (unsigned char *)pTxPacket->p80211Header;
 	sFrame.len = WLAN_AUTHEN_FR_MAXLEN;
 	// format buffer structure
@@ -3056,7 +3056,7 @@ s_MgrMakeBeacon(
 	// prepare beacon frame
 	pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
 	memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_BEACON_FR_MAXLEN);
-	pTxPacket->p80211Header = (PUWLAN_80211HDR)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
+	pTxPacket->p80211Header = (union UWLAN_80211HDR *)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
 	// Setup the sFrame structure.
 	sFrame.pBuf = (unsigned char *)pTxPacket->p80211Header;
 	sFrame.len = WLAN_BEACON_FR_MAXLEN;
@@ -3276,7 +3276,7 @@ s_MgrMakeProbeResponse(
 
 	pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
 	memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_PROBERESP_FR_MAXLEN);
-	pTxPacket->p80211Header = (PUWLAN_80211HDR)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
+	pTxPacket->p80211Header = (union UWLAN_80211HDR *)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
 	// Setup the sFrame structure.
 	sFrame.pBuf = (unsigned char *)pTxPacket->p80211Header;
 	sFrame.len = WLAN_PROBERESP_FR_MAXLEN;
@@ -3453,7 +3453,7 @@ s_MgrMakeAssocRequest(
 
 	pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
 	memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_ASSOCREQ_FR_MAXLEN);
-	pTxPacket->p80211Header = (PUWLAN_80211HDR)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
+	pTxPacket->p80211Header = (union UWLAN_80211HDR *)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
 	// Setup the sFrame structure.
 	sFrame.pBuf = (unsigned char *)pTxPacket->p80211Header;
 	sFrame.len = WLAN_ASSOCREQ_FR_MAXLEN;
@@ -3716,7 +3716,7 @@ s_MgrMakeReAssocRequest(
 
 	pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
 	memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_REASSOCREQ_FR_MAXLEN);
-	pTxPacket->p80211Header = (PUWLAN_80211HDR)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
+	pTxPacket->p80211Header = (union UWLAN_80211HDR *)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
 	/* Setup the sFrame structure. */
 	sFrame.pBuf = (unsigned char *)pTxPacket->p80211Header;
 	sFrame.len = WLAN_REASSOCREQ_FR_MAXLEN;
@@ -3961,7 +3961,7 @@ s_MgrMakeAssocResponse(
 
 	pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
 	memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_ASSOCREQ_FR_MAXLEN);
-	pTxPacket->p80211Header = (PUWLAN_80211HDR)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
+	pTxPacket->p80211Header = (union UWLAN_80211HDR *)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
 	// Setup the sFrame structure
 	sFrame.pBuf = (unsigned char *)pTxPacket->p80211Header;
 	sFrame.len = WLAN_REASSOCRESP_FR_MAXLEN;
@@ -4032,7 +4032,7 @@ s_MgrMakeReAssocResponse(
 
 	pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
 	memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_ASSOCREQ_FR_MAXLEN);
-	pTxPacket->p80211Header = (PUWLAN_80211HDR)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
+	pTxPacket->p80211Header = (union UWLAN_80211HDR *)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
 	// Setup the sFrame structure
 	sFrame.pBuf = (unsigned char *)pTxPacket->p80211Header;
 	sFrame.len = WLAN_REASSOCRESP_FR_MAXLEN;
diff --git a/drivers/staging/vt6655/wmgr.h b/drivers/staging/vt6655/wmgr.h
index b91f1f8..683b02c 100644
--- a/drivers/staging/vt6655/wmgr.h
+++ b/drivers/staging/vt6655/wmgr.h
@@ -196,14 +196,14 @@ typedef enum tagWMAC_CURRENT_MODE {
 
 // Tx Management Packet descriptor
 typedef struct tagSTxMgmtPacket {
-	PUWLAN_80211HDR     p80211Header;
+	union UWLAN_80211HDR *p80211Header;
 	unsigned int cbMPDULen;
 	unsigned int cbPayloadLen;
 } STxMgmtPacket, *PSTxMgmtPacket;
 
 // Rx Management Packet descriptor
 typedef struct tagSRxMgmtPacket {
-	PUWLAN_80211HDR     p80211Header;
+	union UWLAN_80211HDR *p80211Header;
 	QWORD               qwLocalTSF;
 	unsigned int cbMPDULen;
 	unsigned int cbPayloadLen;
-- 
1.8.1.2

