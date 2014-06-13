Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaFMKYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 06:24:15 -0400
Received: from mx02.posteo.de ([89.146.194.165]:58834 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751300AbaFMKYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 06:24:14 -0400
From: Martin Kepplinger <martink@posteo.de>
To: gregkh@linuxfoundation.org
Cc: forest@alittletooquiet.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] staging: vt6655: remove unnecessary typedef struct.
Date: Fri, 13 Jun 2014 12:23:43 +0200
Message-Id: <1402655023-23190-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a totally unnecessary typedef. This is more readable now.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
applies to next-20140611

 drivers/staging/vt6655/card.c   |    2 +-
 drivers/staging/vt6655/device.h |    6 +++---
 drivers/staging/vt6655/wmgr.c   |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 05bf48a..765b5eb 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -998,7 +998,7 @@ CARDbAdd_PMKID_Candidate(
 )
 {
 	PSDevice            pDevice = (PSDevice) pDeviceHandler;
-	PPMKID_CANDIDATE    pCandidateList;
+	struct PMKID_CANDIDATE *pCandidateList;
 	unsigned int ii = 0;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bAdd_PMKID_Candidate START: (%d)\n", (int)pDevice->gsPMKIDCandidate.NumCandidates);
diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 45fc8a0..5651e51 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -227,10 +227,10 @@ typedef enum _NDIS_802_11_STATUS_TYPE
 } NDIS_802_11_STATUS_TYPE, *PNDIS_802_11_STATUS_TYPE;
 
 //Added new types for PMKID Candidate lists.
-typedef struct _PMKID_CANDIDATE {
+struct PMKID_CANDIDATE {
 	NDIS_802_11_MAC_ADDRESS BSSID;
 	unsigned long Flags;
-} PMKID_CANDIDATE, *PPMKID_CANDIDATE;
+};
 
 typedef struct _BSSID_INFO
 {
@@ -248,7 +248,7 @@ typedef struct tagSPMKIDCandidateEvent {
 	NDIS_802_11_STATUS_TYPE     StatusType;
 	unsigned long Version;       // Version of the structure
 	unsigned long NumCandidates; // No. of pmkid candidates
-	PMKID_CANDIDATE CandidateList[MAX_PMKIDLIST];
+	struct PMKID_CANDIDATE CandidateList[MAX_PMKIDLIST];
 } SPMKIDCandidateEvent, *PSPMKIDCandidateEvent;
 
 //--
diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index 6738478..370ef26 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -4438,7 +4438,7 @@ bAdd_PMKID_Candidate(
 )
 {
 	PSDevice         pDevice = (PSDevice)hDeviceContext;
-	PPMKID_CANDIDATE pCandidateList;
+	struct PMKID_CANDIDATE *pCandidateList;
 	unsigned int ii = 0;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bAdd_PMKID_Candidate START: (%d)\n", (int)pDevice->gsPMKIDCandidate.NumCandidates);
-- 
1.7.10.4

