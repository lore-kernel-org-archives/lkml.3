Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab3J2DyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 23:54:22 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:48638 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab3J2Dv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 23:51:59 -0400
From: Kevin McKinney <klmckinney1@gmail.com>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, Kevin McKinney <klmckinney1@gmail.com>
Subject: [PATCH 04/11 V2] Staging: bcm: Replaces UCHAR with u8 in Adapter.h
Date: Mon, 28 Oct 2013 23:51:41 -0400
Message-Id: <1383018708-29615-5-git-send-email-klmckinney1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383018708-29615-1-git-send-email-klmckinney1@gmail.com>
References: <1383018708-29615-1-git-send-email-klmckinney1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replace "UCHAR" with "u8"
in Adapter.h

Signed-off-by: Kevin McKinney <klmckinney1@gmail.com>
---
 drivers/staging/bcm/Adapter.h |   82 ++++++++++++++++++++---------------------
 1 file changed, 41 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/bcm/Adapter.h b/drivers/staging/bcm/Adapter.h
index 08bd9fc..26850bf 100644
--- a/drivers/staging/bcm/Adapter.h
+++ b/drivers/staging/bcm/Adapter.h
@@ -10,13 +10,13 @@
 struct bcm_leader {
 	unsigned short Vcid;
 	unsigned short PLength;
-	UCHAR	Status;
-	UCHAR	Unused[3];
+	u8	Status;
+	u8	Unused[3];
 } __packed;
 
 struct bcm_packettosend {
 	struct bcm_leader Leader;
-	UCHAR	ucPayload;
+	u8	ucPayload;
 } __packed;
 
 struct bcm_control_packet {
@@ -27,7 +27,7 @@ struct bcm_control_packet {
 
 struct bcm_link_request {
 	struct bcm_leader Leader;
-	UCHAR	szData[4];
+	u8	szData[4];
 } __packed;
 
 #define MAX_IP_RANGE_LENGTH 4
@@ -45,46 +45,46 @@ union bcm_ip_address {
 		ULONG ulIpv6Mask[MAX_IP_RANGE_LENGTH * 4]; /* Source Ip Mask Address Range */
 	};
 	struct {
-		UCHAR ucIpv4Address[MAX_IP_RANGE_LENGTH * IP_LENGTH_OF_ADDRESS];
-		UCHAR ucIpv4Mask[MAX_IP_RANGE_LENGTH * IP_LENGTH_OF_ADDRESS];
+		u8 ucIpv4Address[MAX_IP_RANGE_LENGTH * IP_LENGTH_OF_ADDRESS];
+		u8 ucIpv4Mask[MAX_IP_RANGE_LENGTH * IP_LENGTH_OF_ADDRESS];
 	};
 	struct {
-		UCHAR ucIpv6Address[MAX_IP_RANGE_LENGTH * IPV6_ADDRESS_SIZEINBYTES];
-		UCHAR ucIpv6Mask[MAX_IP_RANGE_LENGTH * IPV6_ADDRESS_SIZEINBYTES];
+		u8 ucIpv6Address[MAX_IP_RANGE_LENGTH * IPV6_ADDRESS_SIZEINBYTES];
+		u8 ucIpv6Mask[MAX_IP_RANGE_LENGTH * IPV6_ADDRESS_SIZEINBYTES];
 	};
 };
 
 struct bcm_hdr_suppression_contextinfo {
-	UCHAR ucaHdrSuppressionInBuf[MAX_PHS_LENGTHS]; /* Intermediate buffer to accumulate pkt Header for PHS */
-	UCHAR ucaHdrSuppressionOutBuf[MAX_PHS_LENGTHS + PHSI_LEN]; /* Intermediate buffer containing pkt Header after PHS */
+	u8 ucaHdrSuppressionInBuf[MAX_PHS_LENGTHS]; /* Intermediate buffer to accumulate pkt Header for PHS */
+	u8 ucaHdrSuppressionOutBuf[MAX_PHS_LENGTHS + PHSI_LEN]; /* Intermediate buffer containing pkt Header after PHS */
 };
 
 struct bcm_classifier_rule {
 	ULONG		ulSFID;
-	UCHAR		ucReserved[2];
+	u8	ucReserved[2];
 	B_UINT16	uiClassifierRuleIndex;
 	bool		bUsed;
 	unsigned short	usVCID_Value;
 	B_UINT8		u8ClassifierRulePriority; /* This field detemines the Classifier Priority */
 	union bcm_ip_address stSrcIpAddress;
-	UCHAR		ucIPSourceAddressLength; /* Ip Source Address Length */
+	u8	ucIPSourceAddressLength; /* Ip Source Address Length */
 
 	union bcm_ip_address stDestIpAddress;
-	UCHAR		ucIPDestinationAddressLength; /* Ip Destination Address Length */
-	UCHAR		ucIPTypeOfServiceLength; /* Type of service Length */
-	UCHAR		ucTosLow; /* Tos Low */
-	UCHAR		ucTosHigh; /* Tos High */
-	UCHAR		ucTosMask; /* Tos Mask */
-
-	UCHAR		ucProtocolLength; /* protocol Length */
-	UCHAR		ucProtocol[MAX_PROTOCOL_LENGTH]; /* protocol Length */
+	u8	ucIPDestinationAddressLength; /* Ip Destination Address Length */
+	u8	ucIPTypeOfServiceLength; /* Type of service Length */
+	u8	ucTosLow; /* Tos Low */
+	u8	ucTosHigh; /* Tos High */
+	u8	ucTosMask; /* Tos Mask */
+
+	u8	ucProtocolLength; /* protocol Length */
+	u8	ucProtocol[MAX_PROTOCOL_LENGTH]; /* protocol Length */
 	unsigned short	usSrcPortRangeLo[MAX_PORT_RANGE];
 	unsigned short	usSrcPortRangeHi[MAX_PORT_RANGE];
-	UCHAR		ucSrcPortRangeLength;
+	u8	ucSrcPortRangeLength;
 
 	unsigned short	usDestPortRangeLo[MAX_PORT_RANGE];
 	unsigned short	usDestPortRangeHi[MAX_PORT_RANGE];
-	UCHAR		ucDestPortRangeLength;
+	u8	ucDestPortRangeLength;
 
 	bool		bProtocolValid;
 	bool		bTOSValid;
@@ -92,22 +92,22 @@ struct bcm_classifier_rule {
 	bool		bSrcIpValid;
 
 	/* For IPv6 Addressing */
-	UCHAR		ucDirection;
+	u8	ucDirection;
 	bool		bIpv6Protocol;
 	UINT32		u32PHSRuleID;
 	struct bcm_phs_rule sPhsRule;
-	UCHAR		u8AssociatedPHSI;
+	u8	u8AssociatedPHSI;
 
 	/* Classification fields for ETH CS */
-	UCHAR		ucEthCSSrcMACLen;
-	UCHAR		au8EThCSSrcMAC[MAC_ADDRESS_SIZE];
-	UCHAR		au8EThCSSrcMACMask[MAC_ADDRESS_SIZE];
-	UCHAR		ucEthCSDestMACLen;
-	UCHAR		au8EThCSDestMAC[MAC_ADDRESS_SIZE];
-	UCHAR		au8EThCSDestMACMask[MAC_ADDRESS_SIZE];
-	UCHAR		ucEtherTypeLen;
-	UCHAR		au8EthCSEtherType[NUM_ETHERTYPE_BYTES];
-	UCHAR		usUserPriority[2];
+	u8	ucEthCSSrcMACLen;
+	u8	au8EThCSSrcMAC[MAC_ADDRESS_SIZE];
+	u8	au8EThCSSrcMACMask[MAC_ADDRESS_SIZE];
+	u8	ucEthCSDestMACLen;
+	u8	au8EThCSDestMAC[MAC_ADDRESS_SIZE];
+	u8	au8EThCSDestMACMask[MAC_ADDRESS_SIZE];
+	u8	ucEtherTypeLen;
+	u8	au8EthCSEtherType[NUM_ETHERTYPE_BYTES];
+	u8	usUserPriority[2];
 	unsigned short	usVLANID;
 	unsigned short	usValidityBitMap;
 };
@@ -149,7 +149,7 @@ struct bcm_packet_info {
 	LARGE_INTEGER	liLastUpdateTokenAt;
 	UINT		uiMaxAllowedRate;
 	UINT		NumOfPacketsSent;
-	UCHAR		ucDirection;
+	u8	ucDirection;
 	unsigned short	usCID;
 	struct bcm_mibs_parameters stMibsExtServiceFlowTable;
 	UINT		uiCurrentRxRate;
@@ -157,7 +157,7 @@ struct bcm_packet_info {
 	UINT		uiTotalRxBytes;
 	UINT		uiTotalTxBytes;
 	UINT		uiPendedLast;
-	UCHAR		ucIpVersion;
+	u8	ucIpVersion;
 
 	union {
 		struct {
@@ -179,15 +179,15 @@ struct bcm_packet_info {
 	bool		bAdmittedSet;
 	bool		bAuthorizedSet;
 	bool		bClassifierPriority;
-	UCHAR		ucServiceClassName[MAX_CLASS_NAME_LENGTH];
+	u8	ucServiceClassName[MAX_CLASS_NAME_LENGTH];
 	bool		bHeaderSuppressionEnabled;
 	spinlock_t	SFQueueLock;
 	void		*pstSFIndication;
 	struct timeval	stLastUpdateTokenAt;
 	atomic_t	uiPerSFTxResourceCount;
 	UINT		uiMaxLatency;
-	UCHAR		bIPCSSupport;
-	UCHAR		bEthCSSupport;
+	u8	bIPCSSupport;
+	u8	bEthCSSupport;
 };
 
 struct bcm_tarang_data {
@@ -255,7 +255,7 @@ struct bcm_mini_adapter {
 	bool			bETHCSEnabled;
 	ULONG			BEBucketSize;
 	ULONG			rtPSBucketSize;
-	UCHAR			LinkStatus;
+	u8		LinkStatus;
 	bool			AutoLinkUp;
 	bool			AutoSyncup;
 
@@ -398,8 +398,8 @@ struct bcm_mini_adapter {
 #define GET_BCM_ADAPTER(net_dev) netdev_priv(net_dev)
 
 struct bcm_eth_header {
-	UCHAR	au8DestinationAddress[6];
-	UCHAR	au8SourceAddress[6];
+	u8 au8DestinationAddress[6];
+	u8 au8SourceAddress[6];
 	unsigned short u16Etype;
 } __packed;
 
-- 
1.7.9.5

