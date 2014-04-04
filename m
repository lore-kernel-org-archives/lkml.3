Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbaDDSZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:25:11 -0400
Received: from tex.lwn.net ([70.33.254.29]:44530 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620AbaDDSZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:25:09 -0400
Date: Fri, 4 Apr 2014 12:25:55 -0600
From: Jake Edge <jake@edge2.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jade Bilkey <herself@thefumon.com>, Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCHv3 1/1] staging/bcm fix hostmibs.c checkpatch problems
Message-ID: <20140404122555.0ec33eaf@quetzal.lan>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix 4 checkpatch errors, many warnings in bcm/hostmibs.c

Signed-off-by: Jake Edge <jake@edge2.net>
---

Against next-20140403

v3: fixes suggested by Dan Carpenter
v2: fixes suggested by Joe Perches

There are still some > 80 length lines that require more substantive rework
to fix.

 drivers/staging/bcm/hostmibs.c | 51 +++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/bcm/hostmibs.c b/drivers/staging/bcm/hostmibs.c
index 39ace55..42d9004 100644
--- a/drivers/staging/bcm/hostmibs.c
+++ b/drivers/staging/bcm/hostmibs.c
@@ -9,37 +9,40 @@
 
 #include "headers.h"
 
-INT ProcessGetHostMibs(struct bcm_mini_adapter *Adapter, struct bcm_host_stats_mibs *pstHostMibs)
+INT ProcessGetHostMibs(struct bcm_mini_adapter *Adapter,
+		       struct bcm_host_stats_mibs *pstHostMibs)
 {
 	struct bcm_phs_entry *pstServiceFlowEntry = NULL;
 	struct bcm_phs_rule *pstPhsRule = NULL;
 	struct bcm_phs_classifier_table *pstClassifierTable = NULL;
 	struct bcm_phs_classifier_entry *pstClassifierRule = NULL;
-	struct bcm_phs_extension *pDeviceExtension = (struct bcm_phs_extension *) &Adapter->stBCMPhsContext;
-
-	UINT nClassifierIndex = 0, nPhsTableIndex = 0, nSfIndex = 0, uiIndex = 0;
+	struct bcm_phs_extension *pDeviceExtension = &Adapter->stBCMPhsContext;
+	UINT nClassifierIndex = 0;
+	UINT nPhsTableIndex = 0;
+	UINT nSfIndex = 0;
+	UINT uiIndex = 0;
 
 	if (pDeviceExtension == NULL) {
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, HOST_MIBS, DBG_LVL_ALL, "Invalid Device Extension\n");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, HOST_MIBS,
+				DBG_LVL_ALL, "Invalid Device Extension\n");
 		return STATUS_FAILURE;
 	}
 
 	/* Copy the classifier Table */
-	for (nClassifierIndex = 0; nClassifierIndex < MAX_CLASSIFIERS; nClassifierIndex++) {
+	for (nClassifierIndex = 0; nClassifierIndex < MAX_CLASSIFIERS;
+							nClassifierIndex++) {
 		if (Adapter->astClassifierTable[nClassifierIndex].bUsed == TRUE)
-			memcpy((PVOID) &pstHostMibs->
-			       astClassifierTable[nClassifierIndex],
-			       (PVOID) &Adapter->
-			       astClassifierTable[nClassifierIndex],
+			memcpy(&pstHostMibs->astClassifierTable[nClassifierIndex],
+			       &Adapter->astClassifierTable[nClassifierIndex],
 			       sizeof(struct bcm_mibs_classifier_rule));
 	}
 
 	/* Copy the SF Table */
 	for (nSfIndex = 0; nSfIndex < NO_OF_QUEUES; nSfIndex++) {
 		if (Adapter->PackInfo[nSfIndex].bValid) {
-			memcpy((PVOID) &pstHostMibs->astSFtable[nSfIndex],
-			       (PVOID) &Adapter->PackInfo[nSfIndex],
-				sizeof(struct bcm_mibs_table));
+			memcpy(&pstHostMibs->astSFtable[nSfIndex],
+			       &Adapter->PackInfo[nSfIndex],
+			       sizeof(struct bcm_mibs_table));
 		} else {
 			/* If index in not valid,
 			 * don't process this for the PHS table.
@@ -68,9 +71,9 @@ INT ProcessGetHostMibs(struct bcm_mini_adapter *Adapter, struct bcm_host_stats_m
 				pstHostMibs->astPhsRulesTable[nPhsTableIndex].
 				    ulSFID = Adapter->PackInfo[nSfIndex].ulSFID;
 
-				memcpy(&pstHostMibs->
-				       astPhsRulesTable[nPhsTableIndex].u8PHSI,
-				       &pstPhsRule->u8PHSI, sizeof(struct bcm_phs_rule));
+				memcpy(&pstHostMibs->astPhsRulesTable[nPhsTableIndex].u8PHSI,
+				       &pstPhsRule->u8PHSI,
+				       sizeof(struct bcm_phs_rule));
 				nPhsTableIndex++;
 
 			}
@@ -82,26 +85,32 @@ INT ProcessGetHostMibs(struct bcm_mini_adapter *Adapter, struct bcm_host_stats_m
 	/* Copy other Host Statistics parameters */
 	pstHostMibs->stHostInfo.GoodTransmits = Adapter->dev->stats.tx_packets;
 	pstHostMibs->stHostInfo.GoodReceives = Adapter->dev->stats.rx_packets;
-	pstHostMibs->stHostInfo.CurrNumFreeDesc = atomic_read(&Adapter->CurrNumFreeTxDesc);
+	pstHostMibs->stHostInfo.CurrNumFreeDesc =
+				atomic_read(&Adapter->CurrNumFreeTxDesc);
 	pstHostMibs->stHostInfo.BEBucketSize = Adapter->BEBucketSize;
 	pstHostMibs->stHostInfo.rtPSBucketSize = Adapter->rtPSBucketSize;
 	pstHostMibs->stHostInfo.TimerActive = Adapter->TimerActive;
 	pstHostMibs->stHostInfo.u32TotalDSD = Adapter->u32TotalDSD;
 
-	memcpy(pstHostMibs->stHostInfo.aTxPktSizeHist, Adapter->aTxPktSizeHist, sizeof(UINT32) * MIBS_MAX_HIST_ENTRIES);
-	memcpy(pstHostMibs->stHostInfo.aRxPktSizeHist, Adapter->aRxPktSizeHist, sizeof(UINT32) * MIBS_MAX_HIST_ENTRIES);
+	memcpy(pstHostMibs->stHostInfo.aTxPktSizeHist, Adapter->aTxPktSizeHist,
+	       sizeof(UINT32) * MIBS_MAX_HIST_ENTRIES);
+	memcpy(pstHostMibs->stHostInfo.aRxPktSizeHist, Adapter->aRxPktSizeHist,
+	       sizeof(UINT32) * MIBS_MAX_HIST_ENTRIES);
 
 	return STATUS_SUCCESS;
 }
 
-VOID GetDroppedAppCntrlPktMibs(struct bcm_host_stats_mibs *pstHostMibs, struct bcm_tarang_data *pTarang)
+VOID GetDroppedAppCntrlPktMibs(struct bcm_host_stats_mibs *pstHostMibs,
+			       struct bcm_tarang_data *pTarang)
 {
 	memcpy(&(pstHostMibs->stDroppedAppCntrlMsgs),
 	       &(pTarang->stDroppedAppCntrlMsgs),
 	       sizeof(struct bcm_mibs_dropped_cntrl_msg));
 }
 
-VOID CopyMIBSExtendedSFParameters(struct bcm_mini_adapter *Adapter, struct bcm_connect_mgr_params *psfLocalSet, UINT uiSearchRuleIndex)
+VOID CopyMIBSExtendedSFParameters(struct bcm_mini_adapter *Adapter,
+				  struct bcm_connect_mgr_params *psfLocalSet,
+				  UINT uiSearchRuleIndex)
 {
 	struct bcm_mibs_parameters *t = &Adapter->PackInfo[uiSearchRuleIndex].stMibsExtServiceFlowTable;
 
-- 
1.8.4.5


-- 
Jake Edge - jake@edge2.net - http://www.edge2.net
