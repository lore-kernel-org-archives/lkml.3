Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbaC1Ssc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 14:48:32 -0400
Received: from tex.lwn.net ([70.33.254.29]:35524 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428AbaC1Ss2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 14:48:28 -0400
Date: Fri, 28 Mar 2014 12:49:08 -0600
From: Jake Edge <jake@edge2.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jade Bilkey <herself@thefumon.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: [PATCH v2 1/1] staging/bcm: fix hostmibs.c checkpatch problems
Message-ID: <20140328124908.372f80b1@quetzal.lan>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jake Edge <jake@edge2.net>

Fix 4 checkpatch errors, many warnings in bcm/hostmibs.c

Against next-20140328 tree

Signed-off-by: Jake Edge <jake@edge2.net>
---

There were two > 80 lines that I couldn't find a sensible way to split
up, otherwise it is checkpatch clean

v2: fixes suggested by Joe Perches

diff --git a/drivers/staging/bcm/hostmibs.c b/drivers/staging/bcm/hostmibs.c
index 39ace55..d3b9adb 100644
--- a/drivers/staging/bcm/hostmibs.c
+++ b/drivers/staging/bcm/hostmibs.c
@@ -9,37 +9,42 @@
 
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
+	struct bcm_phs_extension *pDeviceExtension = &Adapter->stBCMPhsContext;
 
-	UINT nClassifierIndex = 0, nPhsTableIndex = 0, nSfIndex = 0, uiIndex = 0;
+	UINT nClassifierIndex = 0, 
+	     nPhsTableIndex = 0, 
+	     nSfIndex = 0, 
+	     uiIndex = 0;
 
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
+			memcpy(&pstHostMibs->
+					astClassifierTable[nClassifierIndex],
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
@@ -70,7 +75,8 @@ INT ProcessGetHostMibs(struct bcm_mini_adapter *Adapter, struct bcm_host_stats_m
 
 				memcpy(&pstHostMibs->
 				       astPhsRulesTable[nPhsTableIndex].u8PHSI,
-				       &pstPhsRule->u8PHSI, sizeof(struct bcm_phs_rule));
+				       &pstPhsRule->u8PHSI,
+				       sizeof(struct bcm_phs_rule));
 				nPhsTableIndex++;
 
 			}
@@ -82,53 +88,70 @@ INT ProcessGetHostMibs(struct bcm_mini_adapter *Adapter, struct bcm_host_stats_m
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
+				sizeof(UINT32) * MIBS_MAX_HIST_ENTRIES);
+	memcpy(pstHostMibs->stHostInfo.aRxPktSizeHist, Adapter->aRxPktSizeHist,
+				sizeof(UINT32) * MIBS_MAX_HIST_ENTRIES);
 
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
+	struct bcm_connect_mgr_params *psfLocalSet, UINT uiSearchRuleIndex)
 {
 	struct bcm_mibs_parameters *t = &Adapter->PackInfo[uiSearchRuleIndex].stMibsExtServiceFlowTable;
 
 	t->wmanIfSfid = psfLocalSet->u32SFID;
-	t->wmanIfCmnCpsMaxSustainedRate = psfLocalSet->u32MaxSustainedTrafficRate;
+	t->wmanIfCmnCpsMaxSustainedRate =
+				psfLocalSet->u32MaxSustainedTrafficRate;
 	t->wmanIfCmnCpsMaxTrafficBurst = psfLocalSet->u32MaxTrafficBurst;
 	t->wmanIfCmnCpsMinReservedRate = psfLocalSet->u32MinReservedTrafficRate;
 	t->wmanIfCmnCpsToleratedJitter = psfLocalSet->u32ToleratedJitter;
 	t->wmanIfCmnCpsMaxLatency = psfLocalSet->u32MaximumLatency;
-	t->wmanIfCmnCpsFixedVsVariableSduInd = psfLocalSet->u8FixedLengthVSVariableLengthSDUIndicator;
-	t->wmanIfCmnCpsFixedVsVariableSduInd = ntohl(t->wmanIfCmnCpsFixedVsVariableSduInd);
+	t->wmanIfCmnCpsFixedVsVariableSduInd =
+			psfLocalSet->u8FixedLengthVSVariableLengthSDUIndicator;
+	t->wmanIfCmnCpsFixedVsVariableSduInd =
+				ntohl(t->wmanIfCmnCpsFixedVsVariableSduInd);
 	t->wmanIfCmnCpsSduSize = psfLocalSet->u8SDUSize;
 	t->wmanIfCmnCpsSduSize = ntohl(t->wmanIfCmnCpsSduSize);
-	t->wmanIfCmnCpsSfSchedulingType = psfLocalSet->u8ServiceFlowSchedulingType;
-	t->wmanIfCmnCpsSfSchedulingType = ntohl(t->wmanIfCmnCpsSfSchedulingType);
+	t->wmanIfCmnCpsSfSchedulingType =
+				psfLocalSet->u8ServiceFlowSchedulingType;
+	t->wmanIfCmnCpsSfSchedulingType =
+				ntohl(t->wmanIfCmnCpsSfSchedulingType);
 	t->wmanIfCmnCpsArqEnable = psfLocalSet->u8ARQEnable;
 	t->wmanIfCmnCpsArqEnable = ntohl(t->wmanIfCmnCpsArqEnable);
 	t->wmanIfCmnCpsArqWindowSize = ntohs(psfLocalSet->u16ARQWindowSize);
 	t->wmanIfCmnCpsArqWindowSize = ntohl(t->wmanIfCmnCpsArqWindowSize);
-	t->wmanIfCmnCpsArqBlockLifetime = ntohs(psfLocalSet->u16ARQBlockLifeTime);
-	t->wmanIfCmnCpsArqBlockLifetime = ntohl(t->wmanIfCmnCpsArqBlockLifetime);
-	t->wmanIfCmnCpsArqSyncLossTimeout = ntohs(psfLocalSet->u16ARQSyncLossTimeOut);
-	t->wmanIfCmnCpsArqSyncLossTimeout = ntohl(t->wmanIfCmnCpsArqSyncLossTimeout);
+	t->wmanIfCmnCpsArqBlockLifetime =
+				ntohs(psfLocalSet->u16ARQBlockLifeTime);
+	t->wmanIfCmnCpsArqBlockLifetime =
+				ntohl(t->wmanIfCmnCpsArqBlockLifetime);
+	t->wmanIfCmnCpsArqSyncLossTimeout =
+				ntohs(psfLocalSet->u16ARQSyncLossTimeOut);
+	t->wmanIfCmnCpsArqSyncLossTimeout =
+				ntohl(t->wmanIfCmnCpsArqSyncLossTimeout);
 	t->wmanIfCmnCpsArqDeliverInOrder = psfLocalSet->u8ARQDeliverInOrder;
-	t->wmanIfCmnCpsArqDeliverInOrder = ntohl(t->wmanIfCmnCpsArqDeliverInOrder);
-	t->wmanIfCmnCpsArqRxPurgeTimeout = ntohs(psfLocalSet->u16ARQRxPurgeTimeOut);
-	t->wmanIfCmnCpsArqRxPurgeTimeout = ntohl(t->wmanIfCmnCpsArqRxPurgeTimeout);
+	t->wmanIfCmnCpsArqDeliverInOrder =
+				ntohl(t->wmanIfCmnCpsArqDeliverInOrder);
+	t->wmanIfCmnCpsArqRxPurgeTimeout =
+				ntohs(psfLocalSet->u16ARQRxPurgeTimeOut);
+	t->wmanIfCmnCpsArqRxPurgeTimeout =
+				ntohl(t->wmanIfCmnCpsArqRxPurgeTimeout);
 	t->wmanIfCmnCpsArqBlockSize = ntohs(psfLocalSet->u16ARQBlockSize);
 	t->wmanIfCmnCpsArqBlockSize = ntohl(t->wmanIfCmnCpsArqBlockSize);
 	t->wmanIfCmnCpsReqTxPolicy = psfLocalSet->u8RequesttransmissionPolicy;


-- 
Jake Edge - jake@edge2.net - http://www.edge2.net
