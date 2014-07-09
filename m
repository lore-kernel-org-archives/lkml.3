Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbaGIP7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:59:35 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58187 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaGIP7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:59:33 -0400
From: Pawel Lebioda <pawel.lebioda89@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: bcm: add missing blank lines after declarations
Date: Wed,  9 Jul 2014 17:59:29 +0200
Message-Id: <1404921569-5081-1-git-send-email-pawel.lebioda89@gmail.com>
X-Mailer: git-send-email 1.8.3.2
References: <20140704203024.GA11946@ThinkPad>
In-Reply-To: <20140708232319.GA32703@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix "Missing blank line after declaration" warnings reported by
checkpatch.pl.

Signed-off-by: Pawel Lebioda <pawel.lebioda89@gmail.com>
---
 drivers/staging/bcm/CmHost.c        | 1 +
 drivers/staging/bcm/IPv6Protocol.c  | 6 ++++++
 drivers/staging/bcm/InterfaceDld.c  | 1 +
 drivers/staging/bcm/InterfaceInit.c | 1 +
 drivers/staging/bcm/InterfaceMisc.c | 1 +
 drivers/staging/bcm/PHSModule.c     | 1 +
 drivers/staging/bcm/Qos.c           | 9 ++++++++-
 drivers/staging/bcm/Transmit.c      | 1 +
 drivers/staging/bcm/led_control.c   | 4 ++++
 drivers/staging/bcm/nvm.c           | 6 ++++++
 10 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/bcm/CmHost.c b/drivers/staging/bcm/CmHost.c
index 3dbdf0e..adca0ce 100644
--- a/drivers/staging/bcm/CmHost.c
+++ b/drivers/staging/bcm/CmHost.c
@@ -972,6 +972,7 @@ static VOID DumpCmControlPacket(PVOID pvBuffer)
 		pstAddIndication->sfAuthorizedSet.bValid = 1;
 	for (nIndex = 0; nIndex < nCurClassifierCnt; nIndex++) {
 		struct bcm_convergence_types *psfCSType = NULL;
+
 		psfCSType =  &pstAddIndication->sfAuthorizedSet.cConvergenceSLTypes[nIndex];
 
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL, "psfCSType = %p", psfCSType);
diff --git a/drivers/staging/bcm/IPv6Protocol.c b/drivers/staging/bcm/IPv6Protocol.c
index cd16067..e013c5a 100644
--- a/drivers/staging/bcm/IPv6Protocol.c
+++ b/drivers/staging/bcm/IPv6Protocol.c
@@ -45,6 +45,7 @@ static UCHAR *GetNextIPV6ChainedHeader(UCHAR **ppucPayload,
 	case IPV6HDR_TYPE_ROUTING:
 		{
 			struct bcm_ipv6_routing_hdr *pstIpv6RoutingHeader;
+
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG,
 					DBG_LVL_ALL, "\nIPv6 Routing Header");
 			pstIpv6RoutingHeader = (struct bcm_ipv6_routing_hdr *)pucPayloadPtr;
@@ -66,6 +67,7 @@ static UCHAR *GetNextIPV6ChainedHeader(UCHAR **ppucPayload,
 		{
 			struct bcm_ipv6_dest_options_hdr *pstIpv6DestOptsHdr = (struct bcm_ipv6_dest_options_hdr *)pucPayloadPtr;
 			int nTotalOptions = pstIpv6DestOptsHdr->ucHdrExtLen;
+
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG,
 					DBG_LVL_ALL,
 					"\nIPv6 DestOpts Header Header");
@@ -78,6 +80,7 @@ static UCHAR *GetNextIPV6ChainedHeader(UCHAR **ppucPayload,
 		{
 			struct bcm_ipv6_authentication_hdr *pstIpv6AuthHdr = (struct bcm_ipv6_authentication_hdr *)pucPayloadPtr;
 			int nHdrLen = pstIpv6AuthHdr->ucLength;
+
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG,
 					DBG_LVL_ALL,
 					"\nIPv6 Authentication Header");
@@ -275,6 +278,7 @@ USHORT	IpVersion6(struct bcm_mini_adapter *Adapter, PVOID pcIpHeader,
 
 	if (bClassificationSucceed == TRUE) {
 		INT iMatchedSFQueueIndex = 0;
+
 		iMatchedSFQueueIndex = SearchSfid(Adapter, pstClassifierRule->ulSFID);
 		if (iMatchedSFQueueIndex >= NO_OF_QUEUES) {
 			bClassificationSucceed = false;
@@ -407,6 +411,7 @@ VOID DumpIpv6Address(ULONG *puIpv6Address)
 	UINT uiIpv6AddrNoLongWords = 4;
 	UINT uiIpv6AddIndex = 0;
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
+
 	for (uiIpv6AddIndex = 0; uiIpv6AddIndex < uiIpv6AddrNoLongWords; uiIpv6AddIndex++) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL,
 				":%lx", puIpv6Address[uiIpv6AddIndex]);
@@ -419,6 +424,7 @@ static VOID DumpIpv6Header(struct bcm_ipv6_hdr *pstIpv6Header)
 	UCHAR ucVersion;
 	UCHAR ucPrio;
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
+
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL,
 			"----Ipv6 Header---");
 	ucVersion = pstIpv6Header->ucVersionPrio & 0xf0;
diff --git a/drivers/staging/bcm/InterfaceDld.c b/drivers/staging/bcm/InterfaceDld.c
index e1925bd..abc7a7a 100644
--- a/drivers/staging/bcm/InterfaceDld.c
+++ b/drivers/staging/bcm/InterfaceDld.c
@@ -244,6 +244,7 @@ static INT buffDnld(struct bcm_mini_adapter *Adapter,
 {
 	unsigned int len = 0;
 	int retval = STATUS_SUCCESS;
+
 	len = u32FirmwareLength;
 
 	while (u32FirmwareLength) {
diff --git a/drivers/staging/bcm/InterfaceInit.c b/drivers/staging/bcm/InterfaceInit.c
index bef13a6..bb61d34 100644
--- a/drivers/staging/bcm/InterfaceInit.c
+++ b/drivers/staging/bcm/InterfaceInit.c
@@ -440,6 +440,7 @@ static int select_alternate_setting_for_highspeed_modem(
 			 * Else USB_IF will fail.
 			 */
 			UINT _uiData = ntohl(EP2_CFG_INT);
+
 			BCM_DEBUG_PRINT(psAd, DBG_TYPE_INITEXIT, DRV_ENTRY,
 					DBG_LVL_ALL,
 					"Reverting Bulk to INT as it is in Full Speed mode.\n");
diff --git a/drivers/staging/bcm/InterfaceMisc.c b/drivers/staging/bcm/InterfaceMisc.c
index a0f159e..e5bcfec 100644
--- a/drivers/staging/bcm/InterfaceMisc.c
+++ b/drivers/staging/bcm/InterfaceMisc.c
@@ -236,6 +236,7 @@ void putUsbSuspend(struct work_struct *work)
 {
 	struct bcm_interface_adapter *psIntfAdapter = NULL;
 	struct usb_interface *intf = NULL;
+
 	psIntfAdapter = container_of(work, struct bcm_interface_adapter,
 				     usbSuspendWork);
 	intf = psIntfAdapter->interface;
diff --git a/drivers/staging/bcm/PHSModule.c b/drivers/staging/bcm/PHSModule.c
index bd68c6f..4b6de76 100644
--- a/drivers/staging/bcm/PHSModule.c
+++ b/drivers/staging/bcm/PHSModule.c
@@ -287,6 +287,7 @@ int phs_init(struct bcm_phs_extension *pPhsdeviceExtension, struct bcm_mini_adap
 	pstServiceFlowTable = pPhsdeviceExtension->pstServiceFlowPhsRulesTable;
 	for (i = 0; i < MAX_SERVICEFLOWS; i++) {
 		struct bcm_phs_entry sServiceFlow = pstServiceFlowTable->stSFList[i];
+
 		sServiceFlow.pstClassifierTable = kzalloc(sizeof(struct bcm_phs_classifier_table), GFP_KERNEL);
 		if (!sServiceFlow.pstClassifierTable) {
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, PHS_DISPATCH, DBG_LVL_ALL, "\nAllocation failed");
diff --git a/drivers/staging/bcm/Qos.c b/drivers/staging/bcm/Qos.c
index 42c1351..c5213b3 100644
--- a/drivers/staging/bcm/Qos.c
+++ b/drivers/staging/bcm/Qos.c
@@ -94,8 +94,8 @@ static bool MatchDestIpAddress(struct bcm_classifier_rule *pstClassifierRule, UL
 **************************************************************************/
 static bool MatchTos(struct bcm_classifier_rule *pstClassifierRule, UCHAR ucTypeOfService)
 {
-
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
+
 	if (3 != pstClassifierRule->ucIPTypeOfServiceLength)
 		return TRUE;
 
@@ -121,6 +121,7 @@ bool MatchProtocol(struct bcm_classifier_rule *pstClassifierRule, UCHAR ucProtoc
 {
 	UCHAR ucLoopIndex = 0;
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
+
 	if (0 == pstClassifierRule->ucProtocolLength)
 		return TRUE;
 	for (ucLoopIndex = 0; ucLoopIndex < pstClassifierRule->ucProtocolLength; ucLoopIndex++) {
@@ -269,6 +270,7 @@ static USHORT	IpVersion4(struct bcm_mini_adapter *Adapter,
 
 	if (TRUE == bClassificationSucceed) {
 		INT iMatchedSFQueueIndex = 0;
+
 		iMatchedSFQueueIndex = SearchSfid(Adapter, pstClassifierRule->ulSFID);
 		if (iMatchedSFQueueIndex >= NO_OF_QUEUES)
 			bClassificationSucceed = false;
@@ -580,6 +582,7 @@ USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter, struct sk_buff *skb)
 			 * Create Frag CLS Entry
 			 */
 			struct bcm_fragmented_packet_info stFragPktInfo;
+
 			stFragPktInfo.bUsed = TRUE;
 			stFragPktInfo.ulSrcIpAddress = pIpHeader->saddr;
 			stFragPktInfo.usIpIdentification = pIpHeader->id;
@@ -601,6 +604,7 @@ static bool EthCSMatchSrcMACAddress(struct bcm_classifier_rule *pstClassifierRul
 {
 	UINT i = 0;
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
+
 	if (pstClassifierRule->ucEthCSSrcMACLen == 0)
 		return TRUE;
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s\n", __func__);
@@ -617,6 +621,7 @@ static bool EthCSMatchDestMACAddress(struct bcm_classifier_rule *pstClassifierRu
 {
 	UINT i = 0;
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
+
 	if (pstClassifierRule->ucEthCSDestMACLen == 0)
 		return TRUE;
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "%s\n", __func__);
@@ -632,6 +637,7 @@ static bool EthCSMatchDestMACAddress(struct bcm_classifier_rule *pstClassifierRu
 static bool EthCSMatchEThTypeSAP(struct bcm_classifier_rule *pstClassifierRule, struct sk_buff *skb, struct bcm_eth_packet_info *pstEthCsPktInfo)
 {
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
+
 	if ((pstClassifierRule->ucEtherTypeLen == 0) ||
 		(pstClassifierRule->au8EthCSEtherType[0] == 0))
 		return TRUE;
@@ -719,6 +725,7 @@ static bool EThCSClassifyPkt(struct bcm_mini_adapter *Adapter, struct sk_buff *s
 				B_UINT8 EthCSCupport)
 {
 	bool bClassificationSucceed = false;
+
 	bClassificationSucceed = EthCSMatchSrcMACAddress(pstClassifierRule, ((struct bcm_eth_header *)(skb->data))->au8SourceAddress);
 	if (!bClassificationSucceed)
 		return false;
diff --git a/drivers/staging/bcm/Transmit.c b/drivers/staging/bcm/Transmit.c
index 4976746..cd27bd8 100644
--- a/drivers/staging/bcm/Transmit.c
+++ b/drivers/staging/bcm/Transmit.c
@@ -148,6 +148,7 @@ int SetupNextSend(struct bcm_mini_adapter *Adapter,  struct sk_buff *Packet, USH
 				status);
 	} else {
 		struct net_device_stats *netstats = &Adapter->dev->stats;
+
 		Adapter->PackInfo[QueueIndex].uiTotalTxBytes += Leader.PLength;
 
 		netstats->tx_bytes += Leader.PLength;
diff --git a/drivers/staging/bcm/led_control.c b/drivers/staging/bcm/led_control.c
index 8353677..074fc39 100644
--- a/drivers/staging/bcm/led_control.c
+++ b/drivers/staging/bcm/led_control.c
@@ -6,6 +6,7 @@
 static B_UINT16 CFG_CalculateChecksum(B_UINT8 *pu8Buffer, B_UINT32 u32Size)
 {
 	B_UINT16 u16CheckSum = 0;
+
 	while (u32Size--) {
 		u16CheckSum += (B_UINT8)~(*pu8Buffer);
 		pu8Buffer++;
@@ -16,6 +17,7 @@ static B_UINT16 CFG_CalculateChecksum(B_UINT8 *pu8Buffer, B_UINT32 u32Size)
 bool IsReqGpioIsLedInNVM(struct bcm_mini_adapter *Adapter, UINT gpios)
 {
 	INT Status;
+
 	Status = (Adapter->gpioBitMap & gpios) ^ gpios;
 	if (Status)
 		return false;
@@ -489,6 +491,7 @@ static int ReadConfigFileStructure(struct bcm_mini_adapter *Adapter,
 	PUCHAR puCFGData	= NULL;
 	UCHAR bData = 0;
 	struct bcm_led_state_info *curr_led_state;
+
 	memset(GPIO_Array, DISABLE_GPIO_NUM, NUM_OF_LEDS+1);
 
 	if (!Adapter->pstargetparams || IS_ERR(Adapter->pstargetparams)) {
@@ -715,6 +718,7 @@ static void handle_adapter_driver_state(struct bcm_mini_adapter *ad,
 			UCHAR GPIO_num_rx = DISABLE_GPIO_NUM;
 			UCHAR uiLEDTx = 0;
 			UCHAR uiLEDRx = 0;
+
 			currdriverstate = NORMAL_OPERATION;
 			ad->LEDInfo.bIdle_led_off = false;
 
diff --git a/drivers/staging/bcm/nvm.c b/drivers/staging/bcm/nvm.c
index 99b82d8..8ce4d41 100644
--- a/drivers/staging/bcm/nvm.c
+++ b/drivers/staging/bcm/nvm.c
@@ -361,6 +361,7 @@ int BeceemEEPROMBulkRead(struct bcm_mini_adapter *Adapter,
 		} else {
 			/* Handle the reads less than 4 bytes... */
 			PUCHAR pCharBuff = (PUCHAR)pBuffer;
+
 			pCharBuff += uiIndex;
 			if (ReadBeceemEEPROM(Adapter, uiOffset, &uiData[0]) == 0) {
 				memcpy(pCharBuff, &uiData[0], uiBytesRemaining); /* copy only bytes requested. */
@@ -914,6 +915,7 @@ static int flashWriteStatus(struct bcm_mini_adapter *Adapter,
 static VOID BcmRestoreBlockProtectStatus(struct bcm_mini_adapter *Adapter, ULONG ulWriteStatus)
 {
 	unsigned int value;
+
 	value = (FLASH_CMD_WRITE_ENABLE << 24);
 	wrmalt(Adapter, FLASH_SPI_CMDQ_REG, &value, sizeof(value));
 
@@ -1154,6 +1156,7 @@ static int BeceemFlashBulkWrite(struct bcm_mini_adapter *Adapter,
 			if (STATUS_SUCCESS == BeceemFlashBulkRead(Adapter, (PUINT)ucReadBk, uiOffsetFromSectStart + uiIndex, MAX_RW_SIZE)) {
 				if (Adapter->ulFlashWriteSize == 1) {
 					unsigned int uiReadIndex = 0;
+
 					for (uiReadIndex = 0; uiReadIndex < 16; uiReadIndex++) {
 						if (ucReadBk[uiReadIndex] != pTempBuff[uiIndex + uiReadIndex]) {
 							if (STATUS_SUCCESS != (*Adapter->fpFlashWriteWithStatusCheck)(Adapter, uiPartOffset + uiIndex + uiReadIndex, &pTempBuff[uiIndex+uiReadIndex])) {
@@ -1868,6 +1871,7 @@ int BeceemNVMWrite(struct bcm_mini_adapter *Adapter,
 			if ((uiOffset + uiNumBytes) > EEPROM_CALPARAM_START) {
 				ULONG ulBytesTobeSkipped = 0;
 				PUCHAR pcBuffer = (PUCHAR)pBuffer; /* char pointer to take care of odd byte cases. */
+
 				uiNumBytes -= (EEPROM_CALPARAM_START - uiOffset);
 				ulBytesTobeSkipped += (EEPROM_CALPARAM_START - uiOffset);
 				uiOffset += (EEPROM_CALPARAM_START - uiOffset);
@@ -2455,6 +2459,7 @@ static int BcmGetFlashCSInfo(struct bcm_mini_adapter *Adapter)
 	#endif
 
 	unsigned int uiFlashLayoutMajorVersion;
+
 	Adapter->uiFlashLayoutMinorVersion = 0;
 	Adapter->uiFlashLayoutMajorVersion = 0;
 	Adapter->ulFlashControlSectionStart = FLASH_CS_INFO_START_ADDR;
@@ -4319,6 +4324,7 @@ static int ReadISOSignature(struct bcm_mini_adapter *Adapter, enum bcm_flash2x_s
 static int ReadISOPriority(struct bcm_mini_adapter *Adapter, enum bcm_flash2x_section_val iso)
 {
 	unsigned int ISOPri = STATUS_FAILURE;
+
 	if (IsSectionWritable(Adapter, iso)) {
 		if (ReadISOSignature(Adapter, iso) == ISO_IMAGE_MAGIC_NUMBER) {
 			BcmFlash2xBulkRead(Adapter,
-- 
1.8.3.2

