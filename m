Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab3JZGPz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 02:15:55 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:33660 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab3JZGP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 02:15:27 -0400
From: Kevin McKinney <klmckinney1@gmail.com>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, Kevin McKinney <klmckinney1@gmail.com>
Subject: [PATCH 02/11] Staging: bcm: Remove typedef for _U_IP_ADDRESS and call directly.
Date: Sat, 26 Oct 2013 02:15:11 -0400
Message-Id: <1382768120-23380-2-git-send-email-klmckinney1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382768120-23380-1-git-send-email-klmckinney1@gmail.com>
References: <1382768120-23380-1-git-send-email-klmckinney1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes typedef for _U_IP_ADDRESS, and
changes the name of the struct to bcm_ip_address. In
addition, any calls to struct "U_IP_ADDRESS" are
changed to call directly.

Signed-off-by: Kevin McKinney <klmckinney1@gmail.com>
---
 drivers/staging/bcm/Adapter.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/bcm/Adapter.h b/drivers/staging/bcm/Adapter.h
index c2c0e6c..cd224f2 100644
--- a/drivers/staging/bcm/Adapter.h
+++ b/drivers/staging/bcm/Adapter.h
@@ -35,7 +35,7 @@ struct bcm_link_request {
 #define MAX_PROTOCOL_LENGTH   32
 #define IPV6_ADDRESS_SIZEINBYTES 0x10
 
-typedef union _U_IP_ADDRESS {
+union bcm_ip_address {
 	struct {
 		ULONG ulIpv4Addr[MAX_IP_RANGE_LENGTH]; /* Source Ip Address Range */
 		ULONG ulIpv4Mask[MAX_IP_RANGE_LENGTH]; /* Source Ip Mask Address Range */
@@ -52,7 +52,7 @@ typedef union _U_IP_ADDRESS {
 		UCHAR ucIpv6Address[MAX_IP_RANGE_LENGTH * IPV6_ADDRESS_SIZEINBYTES];
 		UCHAR ucIpv6Mask[MAX_IP_RANGE_LENGTH * IPV6_ADDRESS_SIZEINBYTES];
 	};
-} U_IP_ADDRESS;
+};
 
 struct bcm_hdr_suppression_contextinfo {
 	UCHAR ucaHdrSuppressionInBuf[MAX_PHS_LENGTHS]; /* Intermediate buffer to accumulate pkt Header for PHS */
@@ -66,10 +66,10 @@ struct bcm_classifier_rule {
 	BOOLEAN		bUsed;
 	USHORT		usVCID_Value;
 	B_UINT8		u8ClassifierRulePriority; /* This field detemines the Classifier Priority */
-	U_IP_ADDRESS	stSrcIpAddress;
+	union bcm_ip_address stSrcIpAddress;
 	UCHAR		ucIPSourceAddressLength; /* Ip Source Address Length */
 
-	U_IP_ADDRESS	stDestIpAddress;
+	union bcm_ip_address stDestIpAddress;
 	UCHAR		ucIPDestinationAddressLength; /* Ip Destination Address Length */
 	UCHAR		ucIPTypeOfServiceLength; /* Type of service Length */
 	UCHAR		ucTosLow; /* Tos Low */
-- 
1.7.9.5

