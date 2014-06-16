Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507AbaFPLBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 07:01:54 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:55162 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaFPLBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 07:01:53 -0400
From: Robin Schroer <sulamiification@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Robin Schroer <sulamiification@gmail.com>
Subject: [PATCH 1/3] drivers/staging/bcm/Misc: style: added blank lines after declarations
Date: Mon, 16 Jun 2014 13:01:46 +0200
Message-Id: <1402916508-9846-1-git-send-email-sulamiification@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robin Schroer <sulamiification@gmail.com>
---
 drivers/staging/bcm/Misc.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/staging/bcm/Misc.c b/drivers/staging/bcm/Misc.c
index 7b2fa0f..f2bc699 100644
--- a/drivers/staging/bcm/Misc.c
+++ b/drivers/staging/bcm/Misc.c
@@ -28,6 +28,7 @@ int InitAdapter(struct bcm_mini_adapter *psAdapter)
 {
 	int i = 0;
 	int Status = STATUS_SUCCESS;
+
 	BCM_DEBUG_PRINT(psAdapter, DBG_TYPE_INITEXIT, MP_INIT, DBG_LVL_ALL, "Initialising Adapter = %p", psAdapter);
 
 	if (psAdapter == NULL) {
@@ -96,6 +97,7 @@ int InitAdapter(struct bcm_mini_adapter *psAdapter)
 void AdapterFree(struct bcm_mini_adapter *Adapter)
 {
 	int count;
+
 	beceem_protocol_reset(Adapter);
 	vendorextnExit(Adapter);
 
@@ -158,6 +160,7 @@ static int create_worker_threads(struct bcm_mini_adapter *psAdapter)
 static struct file *open_firmware_file(struct bcm_mini_adapter *Adapter, const char *path)
 {
 	struct file *flp = filp_open(path, O_RDONLY, S_IRWXU);
+
 	if (IS_ERR(flp)) {
 		pr_err(DRV_NAME "Unable To Open File %s, err %ld", path, PTR_ERR(flp));
 		flp = NULL;
@@ -402,6 +405,7 @@ int CopyBufferToControlPacket(struct bcm_mini_adapter *Adapter, void *ioBuffer)
 void LinkMessage(struct bcm_mini_adapter *Adapter)
 {
 	struct bcm_link_request *pstLinkRequest = NULL;
+
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, LINK_UP_MSG, DBG_LVL_ALL, "=====>");
 	if (Adapter->LinkStatus == SYNC_UP_REQUEST && Adapter->AutoSyncup) {
 		pstLinkRequest = kzalloc(sizeof(struct bcm_link_request), GFP_ATOMIC);
@@ -534,6 +538,7 @@ void LinkControlResponseMessage(struct bcm_mini_adapter *Adapter, PUCHAR pucBuff
 		}
 	} else if (SET_MAC_ADDRESS_RESPONSE == *pucBuffer) {
 		PUCHAR puMacAddr = (pucBuffer + 1);
+
 		Adapter->LinkStatus = SYNC_UP_REQUEST;
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "MAC address response, sending SYNC_UP");
 		LinkMessage(Adapter);
@@ -548,6 +553,7 @@ void SendIdleModeResponse(struct bcm_mini_adapter *Adapter)
 	int status = 0, NVMAccess = 0, lowPwrAbortMsg = 0;
 	struct timeval tv;
 	struct bcm_link_request stIdleResponse = {{0} };
+
 	memset(&tv, 0, sizeof(tv));
 	stIdleResponse.Leader.Status = IDLE_MESSAGE;
 	stIdleResponse.Leader.PLength = IDLE_MODE_PAYLOAD_LENGTH;
@@ -1224,6 +1230,7 @@ int rdmalt(struct bcm_mini_adapter *Adapter, unsigned int uiAddress, unsigned in
 int wrmWithLock(struct bcm_mini_adapter *Adapter, unsigned int uiAddress, PCHAR pucBuff, size_t sSize)
 {
 	int status = STATUS_SUCCESS;
+
 	down(&Adapter->rdmwrmsync);
 
 	if ((Adapter->IdleMode == TRUE) ||
@@ -1282,6 +1289,7 @@ exit:
 static void HandleShutDownModeWakeup(struct bcm_mini_adapter *Adapter)
 {
 	int clear_abort_pattern = 0, Status = 0;
+
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, MP_SHUTDOWN, DBG_LVL_ALL, "====>\n");
 	/* target has woken up From Shut Down */
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, MP_SHUTDOWN, DBG_LVL_ALL, "Clearing Shut Down Software abort pattern\n");
@@ -1440,6 +1448,7 @@ void ResetCounters(struct bcm_mini_adapter *Adapter)
 struct bcm_classifier_rule *GetFragIPClsEntry(struct bcm_mini_adapter *Adapter, USHORT usIpIdentification, ULONG SrcIP)
 {
 	unsigned int uiIndex = 0;
+
 	for (uiIndex = 0; uiIndex < MAX_FRAGMENTEDIP_CLASSIFICATION_ENTRIES; uiIndex++) {
 		if ((Adapter->astFragmentedPktClassifierTable[uiIndex].bUsed) &&
 			(Adapter->astFragmentedPktClassifierTable[uiIndex].usIpIdentification == usIpIdentification) &&
@@ -1454,6 +1463,7 @@ struct bcm_classifier_rule *GetFragIPClsEntry(struct bcm_mini_adapter *Adapter,
 void AddFragIPClsEntry(struct bcm_mini_adapter *Adapter, struct bcm_fragmented_packet_info *psFragPktInfo)
 {
 	unsigned int uiIndex = 0;
+
 	for (uiIndex = 0; uiIndex < MAX_FRAGMENTEDIP_CLASSIFICATION_ENTRIES; uiIndex++) {
 		if (!Adapter->astFragmentedPktClassifierTable[uiIndex].bUsed) {
 			memcpy(&Adapter->astFragmentedPktClassifierTable[uiIndex], psFragPktInfo, sizeof(struct bcm_fragmented_packet_info));
@@ -1465,6 +1475,7 @@ void AddFragIPClsEntry(struct bcm_mini_adapter *Adapter, struct bcm_fragmented_p
 void DelFragIPClsEntry(struct bcm_mini_adapter *Adapter, USHORT usIpIdentification, ULONG SrcIp)
 {
 	unsigned int uiIndex = 0;
+
 	for (uiIndex = 0; uiIndex < MAX_FRAGMENTEDIP_CLASSIFICATION_ENTRIES; uiIndex++) {
 		if ((Adapter->astFragmentedPktClassifierTable[uiIndex].bUsed) &&
 			(Adapter->astFragmentedPktClassifierTable[uiIndex].usIpIdentification == usIpIdentification) &&
@@ -1528,6 +1539,7 @@ void flush_queue(struct bcm_mini_adapter *Adapter, unsigned int iQIndex)
 {
 	struct sk_buff *PacketToDrop = NULL;
 	struct net_device_stats *netstats = &Adapter->dev->stats;
+
 	spin_lock_bh(&Adapter->PackInfo[iQIndex].SFQueueLock);
 
 	while (Adapter->PackInfo[iQIndex].FirstTxQueue && atomic_read(&Adapter->TotalPacketCount)) {
@@ -1551,6 +1563,7 @@ void flush_queue(struct bcm_mini_adapter *Adapter, unsigned int iQIndex)
 static void beceem_protocol_reset(struct bcm_mini_adapter *Adapter)
 {
 	int i;
+
 	if (netif_msg_link(Adapter))
 		pr_notice(PFX "%s: protocol reset\n", Adapter->dev->name);
 
-- 
2.0.0

