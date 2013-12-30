Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab3L3LzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 06:55:00 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:41044 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab3L3Ly7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 06:54:59 -0500
From: Arthur Schwalbenberg <arthurs578@gmail.com>
To: gregkh@linuxfoundation.org
Cc: klmckinney1@gmail.com, lisa@xenapiadmin.com, arthurs578@gmail.com,
        himangi774@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] 	Staging: bcm: Fixed excessive line lengths cleaned up some code
Date: Mon, 30 Dec 2013 06:54:54 -0500
Message-Id: <1388404494-27647-1-git-send-email-arthurs578@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	This is a patch to the Adapter.h file that fixes up excesssive
	line length warnings found by the checkpatch.pl tool

	Signed off by: Arthur Schwalbenberg <arthurs578@gmail.com>
---
 drivers/staging/bcm/Adapter.h | 228 ++++++++++++++++++++++++------------------
 1 file changed, 133 insertions(+), 95 deletions(-)

diff --git a/drivers/staging/bcm/Adapter.h b/drivers/staging/bcm/Adapter.h
index 9cd5987..d131bc7 100644
--- a/drivers/staging/bcm/Adapter.h
+++ b/drivers/staging/bcm/Adapter.h
@@ -37,12 +37,18 @@ struct bcm_link_request {
 
 union u_ip_address {
 	struct {
-		ULONG ulIpv4Addr[MAX_IP_RANGE_LENGTH]; /* Source Ip Address Range */
-		ULONG ulIpv4Mask[MAX_IP_RANGE_LENGTH]; /* Source Ip Mask Address Range */
+		/* Source Ip Address Range */
+		ULONG ulIpv4Addr[MAX_IP_RANGE_LENGTH];
+
+		/* Source Ip Mask Address Range */
+		ULONG ulIpv4Mask[MAX_IP_RANGE_LENGTH];
 	};
 	struct {
-		ULONG ulIpv6Addr[MAX_IP_RANGE_LENGTH * 4]; /* Source Ip Address Range */
-		ULONG ulIpv6Mask[MAX_IP_RANGE_LENGTH * 4]; /* Source Ip Mask Address Range */
+		/* Source Ip Address Range */
+		ULONG ulIpv6Addr[MAX_IP_RANGE_LENGTH * 4];
+
+		/* Source Ip Mask Address Range */
+		ULONG ulIpv6Mask[MAX_IP_RANGE_LENGTH * 4];
 	};
 	struct {
 		UCHAR ucIpv4Address[MAX_IP_RANGE_LENGTH * IP_LENGTH_OF_ADDRESS];
@@ -55,41 +61,48 @@ union u_ip_address {
 };
 
 struct bcm_hdr_suppression_contextinfo {
-	UCHAR ucaHdrSuppressionInBuf[MAX_PHS_LENGTHS]; /* Intermediate buffer to accumulate pkt Header for PHS */
-	UCHAR ucaHdrSuppressionOutBuf[MAX_PHS_LENGTHS + PHSI_LEN]; /* Intermediate buffer containing pkt Header after PHS */
+	/* Intermediate buffer to accumulate pkt Header for PHS */
+	UCHAR ucaHdrSuppressionInBuf[MAX_PHS_LENGTHS];
+
+	/* Intermediate buffer containing pkt Header after PHS */
+	UCHAR ucaHdrSuppressionOutBuf[MAX_PHS_LENGTHS + PHSI_LEN];
 };
 
 struct bcm_classifier_rule {
-	ULONG		ulSFID;
-	UCHAR		ucReserved[2];
-	B_UINT16	uiClassifierRuleIndex;
-	bool		bUsed;
-	USHORT		usVCID_Value;
-	B_UINT8		u8ClassifierRulePriority; /* This field detemines the Classifier Priority */
-	union u_ip_address	stSrcIpAddress;
-	UCHAR		ucIPSourceAddressLength; /* Ip Source Address Length */
-
-	union u_ip_address	stDestIpAddress;
-	UCHAR		ucIPDestinationAddressLength; /* Ip Destination Address Length */
-	UCHAR		ucIPTypeOfServiceLength; /* Type of service Length */
-	UCHAR		ucTosLow; /* Tos Low */
-	UCHAR		ucTosHigh; /* Tos High */
-	UCHAR		ucTosMask; /* Tos Mask */
-
-	UCHAR		ucProtocolLength; /* protocol Length */
-	UCHAR		ucProtocol[MAX_PROTOCOL_LENGTH]; /* protocol Length */
-	USHORT		usSrcPortRangeLo[MAX_PORT_RANGE];
-	USHORT		usSrcPortRangeHi[MAX_PORT_RANGE];
-	UCHAR		ucSrcPortRangeLength;
-
-	USHORT		usDestPortRangeLo[MAX_PORT_RANGE];
-	USHORT		usDestPortRangeHi[MAX_PORT_RANGE];
-	UCHAR		ucDestPortRangeLength;
+	ULONG	 ulSFID;
+	UCHAR	 ucReserved[2];
+	B_UINT16 uiClassifierRuleIndex;
+	bool	 bUsed;
+	USHORT	 usVCID_Value;
 
-	bool		bProtocolValid;
-	bool		bTOSValid;
-	bool		bDestIpValid;
-	bool		bSrcIpValid;
+	/* This field detemines the Classifier Priority */
+	B_UINT8	u8ClassifierRulePriority;
+	union u_ip_address stSrcIpAddress;
+
+	UCHAR ucIPSourceAddressLength;      /* Ip Source Address Length */
+	union u_ip_address stDestIpAddress;
+
+
+	UCHAR ucIPDestinationAddressLength; /* Ip Destination Address Length */
+	UCHAR ucIPTypeOfServiceLength;      /* Type of service Length */
+	UCHAR ucTosLow;                     /* Tos Low */
+	UCHAR ucTosHigh;                    /* Tos High */
+	UCHAR ucTosMask;                    /* Tos Mask */
+
+	UCHAR  ucProtocolLength;                /* protocol Length */
+	UCHAR  ucProtocol[MAX_PROTOCOL_LENGTH]; /* protocol Length */
+	USHORT usSrcPortRangeLo[MAX_PORT_RANGE];
+	USHORT usSrcPortRangeHi[MAX_PORT_RANGE];
+	UCHAR  ucSrcPortRangeLength;
+
+	USHORT usDestPortRangeLo[MAX_PORT_RANGE];
+	USHORT usDestPortRangeHi[MAX_PORT_RANGE];
+	UCHAR  ucDestPortRangeLength;
+
+	bool bProtocolValid;
+	bool bTOSValid;
+	bool bDestIpValid;
+	bool bSrcIpValid;
 
 	/* For IPv6 Addressing */
 	UCHAR		ucDirection;
@@ -122,42 +135,47 @@ struct bcm_fragmented_packet_info {
 
 struct bcm_packet_info {
 	/* classification extension Rule */
-	ULONG		ulSFID;
-	USHORT		usVCID_Value;
-	UINT		uiThreshold;
+	ULONG  ulSFID;
+	USHORT usVCID_Value;
+	UINT    uiThreshold;
+
 	/* This field determines the priority of the SF Queues */
-	B_UINT8		u8TrafficPriority;
-
-	bool		bValid;
-	bool		bActive;
-	bool		bActivateRequestSent;
-
-	B_UINT8		u8QueueType; /* BE or rtPS */
-
-	UINT		uiMaxBucketSize; /* maximum size of the bucket for the queue */
-	UINT		uiCurrentQueueDepthOnTarget;
-	UINT		uiCurrentBytesOnHost;
-	UINT		uiCurrentPacketsOnHost;
-	UINT		uiDroppedCountBytes;
-	UINT		uiDroppedCountPackets;
-	UINT		uiSentBytes;
-	UINT		uiSentPackets;
-	UINT		uiCurrentDrainRate;
-	UINT		uiThisPeriodSentBytes;
-	LARGE_INTEGER	liDrainCalculated;
-	UINT		uiCurrentTokenCount;
-	LARGE_INTEGER	liLastUpdateTokenAt;
-	UINT		uiMaxAllowedRate;
-	UINT		NumOfPacketsSent;
-	UCHAR		ucDirection;
-	USHORT		usCID;
+	B_UINT8	u8TrafficPriority;
+
+	bool	bValid;
+	bool	bActive;
+	bool	bActivateRequestSent;
+
+	B_UINT8	u8QueueType; /* BE or rtPS */
+
+	UINT uiMaxBucketSize; /* maximum size of the bucket for the queue */
+	UINT uiCurrentQueueDepthOnTarget;
+	UINT uiCurrentBytesOnHost;
+	UINT uiCurrentPacketsOnHost;
+	UINT uiDroppedCountBytes;
+	UINT uiDroppedCountPackets;
+	UINT uiSentBytes;
+	UINT uiSentPackets;
+	UINT uiCurrentDrainRate;
+	UINT uiThisPeriodSentBytes;
+	UINT uiCurrentTokenCount;
+	UINT uiMaxAllowedRate;
+	UINT NumOfPacketsSent;
+	UINT uiCurrentRxRate;
+	UINT uiThisPeriodRxBytes;
+	UINT uiTotalRxBytes;
+	UINT uiTotalTxBytes;
+	UINT uiPendedLast;
+
+	UCHAR ucIpVersion;
+	UCHAR ucDirection;
+
+	USHORT usCID;
+
+	LARGE_INTEGER liLastUpdateTokenAt;
+	LARGE_INTEGER liDrainCalculated;
+
 	struct bcm_mibs_parameters stMibsExtServiceFlowTable;
-	UINT		uiCurrentRxRate;
-	UINT		uiThisPeriodRxBytes;
-	UINT		uiTotalRxBytes;
-	UINT		uiTotalTxBytes;
-	UINT		uiPendedLast;
-	UCHAR		ucIpVersion;
 
 	union {
 		struct {
@@ -274,7 +292,7 @@ struct bcm_mini_adapter {
 	UINT			index_datpkt;
 	struct semaphore	rdmwrmsync;
 
-	struct bcm_targetdsx_buffer	astTargetDsxBuffer[MAX_TARGET_DSX_BUFFERS];
+	struct bcm_targetdsx_buffer astTargetDsxBuffer[MAX_TARGET_DSX_BUFFERS];
 	ULONG			ulFreeTargetBufferCnt;
 	ULONG			ulCurrentTargetBuffer;
 	ULONG			ulTotalTargetBuffersAvailable;
@@ -342,7 +360,10 @@ struct bcm_mini_adapter {
 	bool			bDPLLConfig;
 	UINT32			aTxPktSizeHist[MIBS_MAX_HIST_ENTRIES];
 	UINT32			aRxPktSizeHist[MIBS_MAX_HIST_ENTRIES];
-	struct bcm_fragmented_packet_info astFragmentedPktClassifierTable[MAX_FRAGMENTEDIP_CLASSIFICATION_ENTRIES];
+
+	struct bcm_fragmented_packet_info
+	astFragmentedPktClassifierTable[MAX_FRAGMENTEDIP_CLASSIFICATION_ENTRIES];
+
 	atomic_t		uiMBupdate;
 	UINT32			PmuMode;
 	enum bcm_nvm_type	eNVMType;
@@ -353,7 +374,8 @@ struct bcm_mini_adapter {
 	UINT			uiNVMDSDSize;
 	UINT			uiVendorExtnFlag;
 	/* it will always represent chosen DSD at any point of time.
-	 * Generally it is Active DSD but in case of NVM RD/WR it might be different.
+	 * Generally it is Active DSD but in case of
+	 * NVM RD/WR it might be different.
 	 */
 	UINT			ulFlashCalStart;
 	ULONG			ulFlashControlSectionStart;
@@ -369,30 +391,46 @@ struct bcm_mini_adapter {
 	struct bcm_flash2x_cs_info *psFlash2xCSInfo;
 	struct bcm_flash_cs_info *psFlashCSInfo;
 	struct bcm_flash2x_vendor_info *psFlash2xVendorInfo;
-	UINT			uiFlashBaseAdd; /* Flash start address */
-	UINT			uiActiveISOOffset; /* Active ISO offset chosen before f/w download */
 	enum bcm_flash2x_section_val eActiveISO; /* Active ISO section val */
-	enum bcm_flash2x_section_val eActiveDSD; /* Active DSD val chosen before f/w download */
-	UINT			uiActiveDSDOffsetAtFwDld;  /* For accessing Active DSD chosen before f/w download */
-	UINT			uiFlashLayoutMajorVersion;
-	UINT			uiFlashLayoutMinorVersion;
-	bool			bAllDSDWriteAllow;
-	bool			bSigCorrupted;
-	/* this should be set who so ever want to change the Headers. after Wrtie it should be reset immediately. */
-	bool			bHeaderChangeAllowed;
-	int			SelectedChip;
-	bool			bEndPointHalted;
-	/* while bFlashRawRead will be true, Driver  ignore map lay out and consider flash as of without any map. */
-	bool			bFlashRawRead;
-	bool			bPreparingForLowPowerMode;
-	bool			bDoSuspend;
-	UINT			syscfgBefFwDld;
-	bool			StopAllXaction;
-	UINT32			liTimeSinceLastNetEntry; /* Used to Support extended CAPI requirements from */
-	struct semaphore	LowPowerModeSync;
-	ULONG			liDrainCalculated;
-	UINT			gpioBitMap;
-	struct bcm_debug_state	stDebugState;
+
+	/* Active DSD val chosen before f/w download */
+	enum bcm_flash2x_section_val eActiveDSD;
+
+	UINT uiFlashBaseAdd; /* Flash start address */
+
+	/* Active ISO offset chosen before f/w download */
+	UINT uiActiveISOOffset;
+
+	/* For accessing Active DSD chosen before f/w download */
+	UINT uiActiveDSDOffsetAtFwDld;
+	UINT uiFlashLayoutMajorVersion;
+	UINT uiFlashLayoutMinorVersion;
+	UINT syscfgBefFwDld;
+	UINT gpioBitMap;
+
+	bool bAllDSDWriteAllow;
+	bool bSigCorrupted;
+
+	/* this should be set who so ever want to change the Headers.
+	 * after Wrtie it should be reset immediately. */
+	bool bHeaderChangeAllowed;
+	int  SelectedChip;
+	bool bEndPointHalted;
+
+	/* while bFlashRawRead will be true, Driver ignore map lay out
+	 * and consider flash as of without any map. */
+	bool bFlashRawRead;
+	bool bPreparingForLowPowerMode;
+	bool bDoSuspend;
+	bool StopAllXaction;
+
+	/* Used to Support extended CAPI requirements from */
+	UINT32 liTimeSinceLastNetEntry;
+
+	ULONG  liDrainCalculated;
+
+	struct semaphore       LowPowerModeSync;
+	struct bcm_debug_state stDebugState;
 };
 
 #define GET_BCM_ADAPTER(net_dev) netdev_priv(net_dev)
-- 
1.8.3.2

