Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab3JZGPe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 02:15:34 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:46599 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab3JZGP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 02:15:28 -0400
From: Kevin McKinney <klmckinney1@gmail.com>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, Kevin McKinney <klmckinney1@gmail.com>
Subject: [PATCH 03/11] Staging: bcm: Replace USHORT with unsigned short in Adapter.h
Date: Sat, 26 Oct 2013 02:15:12 -0400
Message-Id: <1382768120-23380-3-git-send-email-klmckinney1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382768120-23380-1-git-send-email-klmckinney1@gmail.com>
References: <1382768120-23380-1-git-send-email-klmckinney1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replace "USHORT" with "unsigned
short" in Adapter.h

Signed-off-by: Kevin McKinney <klmckinney1@gmail.com>
---
 drivers/staging/bcm/Adapter.h |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/bcm/Adapter.h b/drivers/staging/bcm/Adapter.h
index cd224f2..8f0033a 100644
--- a/drivers/staging/bcm/Adapter.h
+++ b/drivers/staging/bcm/Adapter.h
@@ -8,8 +8,8 @@
 #include "Debug.h"
 
 struct bcm_leader {
-	USHORT	Vcid;
-	USHORT	PLength;
+	unsigned short Vcid;
+	unsigned short PLength;
 	UCHAR	Status;
 	UCHAR	Unused[3];
 } __packed;
@@ -64,7 +64,7 @@ struct bcm_classifier_rule {
 	UCHAR		ucReserved[2];
 	B_UINT16	uiClassifierRuleIndex;
 	BOOLEAN		bUsed;
-	USHORT		usVCID_Value;
+	unsigned short	usVCID_Value;
 	B_UINT8		u8ClassifierRulePriority; /* This field detemines the Classifier Priority */
 	union bcm_ip_address stSrcIpAddress;
 	UCHAR		ucIPSourceAddressLength; /* Ip Source Address Length */
@@ -78,12 +78,12 @@ struct bcm_classifier_rule {
 
 	UCHAR		ucProtocolLength; /* protocol Length */
 	UCHAR		ucProtocol[MAX_PROTOCOL_LENGTH]; /* protocol Length */
-	USHORT		usSrcPortRangeLo[MAX_PORT_RANGE];
-	USHORT		usSrcPortRangeHi[MAX_PORT_RANGE];
+	unsigned short	usSrcPortRangeLo[MAX_PORT_RANGE];
+	unsigned short	usSrcPortRangeHi[MAX_PORT_RANGE];
 	UCHAR		ucSrcPortRangeLength;
 
-	USHORT		usDestPortRangeLo[MAX_PORT_RANGE];
-	USHORT		usDestPortRangeHi[MAX_PORT_RANGE];
+	unsigned short	usDestPortRangeLo[MAX_PORT_RANGE];
+	unsigned short	usDestPortRangeHi[MAX_PORT_RANGE];
 	UCHAR		ucDestPortRangeLength;
 
 	BOOLEAN		bProtocolValid;
@@ -108,14 +108,14 @@ struct bcm_classifier_rule {
 	UCHAR		ucEtherTypeLen;
 	UCHAR		au8EthCSEtherType[NUM_ETHERTYPE_BYTES];
 	UCHAR		usUserPriority[2];
-	USHORT		usVLANID;
-	USHORT		usValidityBitMap;
+	unsigned short	usVLANID;
+	unsigned short	usValidityBitMap;
 };
 
 struct bcm_fragmented_packet_info {
 	BOOLEAN			bUsed;
 	ULONG			ulSrcIpAddress;
-	USHORT			usIpIdentification;
+	unsigned short usIpIdentification;
 	struct bcm_classifier_rule *pstMatchedClassifierEntry;
 	BOOLEAN			bOutOfOrderFragment;
 };
@@ -123,7 +123,7 @@ struct bcm_fragmented_packet_info {
 struct bcm_packet_info {
 	/* classification extension Rule */
 	ULONG		ulSFID;
-	USHORT		usVCID_Value;
+	unsigned short	usVCID_Value;
 	UINT		uiThreshold;
 	/* This field determines the priority of the SF Queues */
 	B_UINT8		u8TrafficPriority;
@@ -150,7 +150,7 @@ struct bcm_packet_info {
 	UINT		uiMaxAllowedRate;
 	UINT		NumOfPacketsSent;
 	UCHAR		ucDirection;
-	USHORT		usCID;
+	unsigned short	usCID;
 	struct bcm_mibs_parameters stMibsExtServiceFlowTable;
 	UINT		uiCurrentRxRate;
 	UINT		uiThisPeriodRxBytes;
@@ -244,8 +244,8 @@ struct bcm_mini_adapter {
 	/* this to keep track of the Tx and Rx MailBox Registers. */
 	atomic_t		CurrNumFreeTxDesc;
 	/* to keep track the no of byte received */
-	USHORT			PrevNumRecvDescs;
-	USHORT			CurrNumRecvDescs;
+	unsigned short		PrevNumRecvDescs;
+	unsigned short		CurrNumRecvDescs;
 	UINT			u32TotalDSD;
 	struct bcm_packet_info	PackInfo[NO_OF_QUEUES];
 	struct bcm_classifier_rule astClassifierTable[MAX_CLASSIFIERS];
@@ -284,7 +284,7 @@ struct bcm_mini_adapter {
 	BOOLEAN			bBinDownloaded;
 	BOOLEAN			bCfgDownloaded;
 	BOOLEAN			bSyncUpRequestSent;
-	USHORT			usBestEffortQueueIndex;
+	unsigned short		usBestEffortQueueIndex;
 	wait_queue_head_t	ioctl_fw_dnld_wait_queue;
 	BOOLEAN			waiting_to_fw_download_done;
 	pid_t			fw_download_process_pid;
@@ -400,7 +400,7 @@ struct bcm_mini_adapter {
 struct bcm_eth_header {
 	UCHAR	au8DestinationAddress[6];
 	UCHAR	au8SourceAddress[6];
-	USHORT	u16Etype;
+	unsigned short u16Etype;
 } __packed;
 
 struct bcm_firmware_info {
-- 
1.7.9.5

