Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935109AbaGXXJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:09:05 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:53406 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934918AbaGXXHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:07:09 -0400
X-Originating-IP: 109.10.215.15
From: Guillaume Clement <gclement@baobob.org>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Guillaume Clement <gclement@baobob.org>
Subject: [PATCH 11/14] staging: vt6655: remove braces for single statements if
Date: Fri, 25 Jul 2014 01:06:25 +0200
Message-Id: <1406243188-13413-12-git-send-email-gclement@baobob.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1406243188-13413-1-git-send-email-gclement@baobob.org>
References: <1406243188-13413-1-git-send-email-gclement@baobob.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes several "braces {} are not necessary for single statement
blocks" checkpatch warnings.

Signed-off-by: Guillaume Clement <gclement@baobob.org>
---
 drivers/staging/vt6655/power.c   | 3 +--
 drivers/staging/vt6655/vntwifi.c | 3 +--
 drivers/staging/vt6655/wmgr.c    | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6655/power.c b/drivers/staging/vt6655/power.c
index e41d3bc..2a21cbd 100644
--- a/drivers/staging/vt6655/power.c
+++ b/drivers/staging/vt6655/power.c
@@ -248,9 +248,8 @@ PSvSendPSPOLL(
 	pTxPacket->cbMPDULen = WLAN_HDR_ADDR2_LEN;
 	pTxPacket->cbPayloadLen = 0;
 	// send the frame
-	if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING) {
+	if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING)
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Send PS-Poll packet failed..\n");
-	}
 }
 
 /*+
diff --git a/drivers/staging/vt6655/vntwifi.c b/drivers/staging/vt6655/vntwifi.c
index 160707d..4d425e0 100644
--- a/drivers/staging/vt6655/vntwifi.c
+++ b/drivers/staging/vt6655/vntwifi.c
@@ -684,9 +684,8 @@ VNTWIFIbMeasureReport(
 		pMgmt->uLengthOfRepEIDs += (2 + pMgmt->pCurrMeasureEIDRep->len);
 		pMgmt->pCurrMeasureEIDRep = (PWLAN_IE_MEASURE_REP) pbyCurrentEID;
 	}
-	if (bEndOfReport) {
+	if (bEndOfReport)
 		IEEE11hbMSRRepTx(pMgmt);
-	}
 
 	return true;
 }
diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index 57373c9..e88e116 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -4114,9 +4114,8 @@ s_vMgrRxProbeRequest(
 		if (pTxPacket != NULL) {
 			/* send the frame */
 			Status = csMgmt_xmit(pDevice, pTxPacket);
-			if (Status != CMD_STATUS_PENDING) {
+			if (Status != CMD_STATUS_PENDING)
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Probe response tx failed\n");
-			}
 		}
 	}
 }
-- 
1.8.5.5

