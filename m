Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab3J2DwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 23:52:13 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:38532 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189Ab3J2DwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 23:52:00 -0400
From: Kevin McKinney <klmckinney1@gmail.com>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, Kevin McKinney <klmckinney1@gmail.com>
Subject: [PATCH 05/11 V2] Staging: bcm: Replace ULONG with unsigned long or u32 in Adapter.h
Date: Mon, 28 Oct 2013 23:51:42 -0400
Message-Id: <1383018708-29615-6-git-send-email-klmckinney1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383018708-29615-1-git-send-email-klmckinney1@gmail.com>
References: <1383018708-29615-1-git-send-email-klmckinney1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces "ULONG" with "unsigned
long", or "u32" for ipv4 addresses, in
Adapter.h. For ipv4 addresses, all
formating is change to match u32 definition.

Signed-off-by: Kevin McKinney <klmckinney1@gmail.com>
---
 drivers/staging/bcm/Adapter.h |   42 ++++++++++++++++++++---------------------
 drivers/staging/bcm/Bcmchar.c |    2 +-
 drivers/staging/bcm/CmHost.c  |    8 ++++----
 drivers/staging/bcm/Misc.c    |    8 ++++----
 4 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/bcm/Adapter.h b/drivers/staging/bcm/Adapter.h
index 26850bf..a5dab86 100644
--- a/drivers/staging/bcm/Adapter.h
+++ b/drivers/staging/bcm/Adapter.h
@@ -37,12 +37,12 @@ struct bcm_link_request {
 
 union bcm_ip_address {
 	struct {
-		ULONG ulIpv4Addr[MAX_IP_RANGE_LENGTH]; /* Source Ip Address Range */
-		ULONG ulIpv4Mask[MAX_IP_RANGE_LENGTH]; /* Source Ip Mask Address Range */
+		u32 ulIpv4Addr[MAX_IP_RANGE_LENGTH]; /* Source Ip Address Range */
+		u32 ulIpv4Mask[MAX_IP_RANGE_LENGTH]; /* Source Ip Mask Address Range */
 	};
 	struct {
-		ULONG ulIpv6Addr[MAX_IP_RANGE_LENGTH * 4]; /* Source Ip Address Range */
-		ULONG ulIpv6Mask[MAX_IP_RANGE_LENGTH * 4]; /* Source Ip Mask Address Range */
+		unsigned long ulIpv6Addr[MAX_IP_RANGE_LENGTH * 4]; /* Source Ip Address Range */
+		unsigned long ulIpv6Mask[MAX_IP_RANGE_LENGTH * 4]; /* Source Ip Mask Address Range */
 	};
 	struct {
 		u8 ucIpv4Address[MAX_IP_RANGE_LENGTH * IP_LENGTH_OF_ADDRESS];
@@ -60,7 +60,7 @@ struct bcm_hdr_suppression_contextinfo {
 };
 
 struct bcm_classifier_rule {
-	ULONG		ulSFID;
+	unsigned long ulSFID;
 	u8	ucReserved[2];
 	B_UINT16	uiClassifierRuleIndex;
 	bool		bUsed;
@@ -114,7 +114,7 @@ struct bcm_classifier_rule {
 
 struct bcm_fragmented_packet_info {
 	bool			bUsed;
-	ULONG			ulSrcIpAddress;
+	unsigned long		ulSrcIpAddress;
 	unsigned short		usIpIdentification;
 	struct bcm_classifier_rule *pstMatchedClassifierEntry;
 	bool			bOutOfOrderFragment;
@@ -122,7 +122,7 @@ struct bcm_fragmented_packet_info {
 
 struct bcm_packet_info {
 	/* classification extension Rule */
-	ULONG		ulSFID;
+	unsigned long	ulSFID;
 	unsigned short	usVCID_Value;
 	UINT		uiThreshold;
 	/* This field determines the priority of the SF Queues */
@@ -199,11 +199,11 @@ struct bcm_tarang_data {
 	bool			MacTracingEnabled;
 	bool			bApplicationToExit;
 	struct bcm_mibs_dropped_cntrl_msg stDroppedAppCntrlMsgs;
-	ULONG			RxCntrlMsgBitMask;
+	unsigned long		RxCntrlMsgBitMask;
 };
 
 struct bcm_targetdsx_buffer {
-	ULONG		ulTargetDsxBuffer;
+	unsigned long	ulTargetDsxBuffer;
 	B_UINT16	tid;
 	bool		valid;
 };
@@ -253,8 +253,8 @@ struct bcm_mini_adapter {
 
 	/*************** qos ******************/
 	bool			bETHCSEnabled;
-	ULONG			BEBucketSize;
-	ULONG			rtPSBucketSize;
+	unsigned long		BEBucketSize;
+	unsigned long		rtPSBucketSize;
 	u8		LinkStatus;
 	bool			AutoLinkUp;
 	bool			AutoSyncup;
@@ -275,9 +275,9 @@ struct bcm_mini_adapter {
 	struct semaphore	rdmwrmsync;
 
 	struct bcm_targetdsx_buffer	astTargetDsxBuffer[MAX_TARGET_DSX_BUFFERS];
-	ULONG			ulFreeTargetBufferCnt;
-	ULONG			ulCurrentTargetBuffer;
-	ULONG			ulTotalTargetBuffersAvailable;
+	unsigned long		ulFreeTargetBufferCnt;
+	unsigned long		ulCurrentTargetBuffer;
+	unsigned long		ulTotalTargetBuffersAvailable;
 	unsigned long		chip_id;
 	wait_queue_head_t	lowpower_mode_wait_queue;
 	bool			bFlashBoot;
@@ -294,7 +294,7 @@ struct bcm_mini_adapter {
 	bool			bIsAutoCorrectEnabled;
 	bool			bDDRInitDone;
 	int			DDRSetting;
-	ULONG			ulPowerSaveMode;
+	unsigned long		ulPowerSaveMode;
 	spinlock_t		txtransmitlock;
 	B_UINT8			txtransmit_running;
 	/* Thread for control packet handling */
@@ -356,9 +356,9 @@ struct bcm_mini_adapter {
 	 * Generally it is Active DSD but in case of NVM RD/WR it might be different.
 	 */
 	UINT			ulFlashCalStart;
-	ULONG			ulFlashControlSectionStart;
-	ULONG			ulFlashWriteSize;
-	ULONG			ulFlashID;
+	unsigned long		ulFlashControlSectionStart;
+	unsigned long		ulFlashWriteSize;
+	unsigned long		ulFlashID;
 	FP_FLASH_WRITE		fpFlashWrite;
 	FP_FLASH_WRITE_STATUS	fpFlashWriteWithStatusCheck;
 
@@ -390,7 +390,7 @@ struct bcm_mini_adapter {
 	bool			StopAllXaction;
 	UINT32			liTimeSinceLastNetEntry; /* Used to Support extended CAPI requirements from */
 	struct semaphore	LowPowerModeSync;
-	ULONG			liDrainCalculated;
+	unsigned long		liDrainCalculated;
 	UINT			gpioBitMap;
 	struct bcm_debug_state	stDebugState;
 };
@@ -405,8 +405,8 @@ struct bcm_eth_header {
 
 struct bcm_firmware_info {
 	void	__user *pvMappedFirmwareAddress;
-	ULONG	u32FirmwareLength;
-	ULONG	u32StartingAddress;
+	u32	u32FirmwareLength;
+	u32	u32StartingAddress;
 } __packed;
 
 /* holds the value of net_device structure.. */
diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 9d57d04..147f669 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -828,7 +828,7 @@ cntrlEnd:
 		if (!psFwInfo->pvMappedFirmwareAddress ||
 			(psFwInfo->u32FirmwareLength == 0)) {
 
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Something else is wrong %lu\n",
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Something else is wrong %u\n",
 					psFwInfo->u32FirmwareLength);
 			up(&Adapter->fw_download_sema);
 			kfree(psFwInfo);
diff --git a/drivers/staging/bcm/CmHost.c b/drivers/staging/bcm/CmHost.c
index 8ec1dd1..d12f413 100644
--- a/drivers/staging/bcm/CmHost.c
+++ b/drivers/staging/bcm/CmHost.c
@@ -162,11 +162,11 @@ CopyIpAddrToClassifier(struct bcm_classifier_rule *pstClassifierEntry,
 			if (!bIpVersion6) {
 				if (eIpAddrContext == eSrcIpAddress) {
 					pstClassifierEntry->stSrcIpAddress.ulIpv4Addr[i] = ntohl(pstClassifierEntry->stSrcIpAddress.ulIpv4Addr[i]);
-					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL, "Src Ip Address:0x%luX ",
+					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL, "Src Ip Address:0x%uX ",
 							pstClassifierEntry->stSrcIpAddress.ulIpv4Addr[i]);
 				} else if (eIpAddrContext == eDestIpAddress) {
 					pstClassifierEntry->stDestIpAddress.ulIpv4Addr[i] = ntohl(pstClassifierEntry->stDestIpAddress.ulIpv4Addr[i]);
-					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL, "Dest Ip Address:0x%luX ",
+					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL, "Dest Ip Address:0x%uX ",
 							pstClassifierEntry->stDestIpAddress.ulIpv4Addr[i]);
 				}
 			}
@@ -182,12 +182,12 @@ CopyIpAddrToClassifier(struct bcm_classifier_rule *pstClassifierEntry,
 					if (eIpAddrContext == eSrcIpAddress) {
 						pstClassifierEntry->stSrcIpAddress.ulIpv4Mask[i] =
 							ntohl(pstClassifierEntry->stSrcIpAddress.ulIpv4Mask[i]);
-						BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL, "Src Ip Mask Address:0x%luX ",
+						BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL, "Src Ip Mask Address:0x%uX ",
 								pstClassifierEntry->stSrcIpAddress.ulIpv4Mask[i]);
 					} else if (eIpAddrContext == eDestIpAddress) {
 						pstClassifierEntry->stDestIpAddress.ulIpv4Mask[i] =
 							ntohl(pstClassifierEntry->stDestIpAddress.ulIpv4Mask[i]);
-						BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL, "Dest Ip Mask Address:0x%luX ",
+						BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL, "Dest Ip Mask Address:0x%uX ",
 								pstClassifierEntry->stDestIpAddress.ulIpv4Mask[i]);
 					}
 				}
diff --git a/drivers/staging/bcm/Misc.c b/drivers/staging/bcm/Misc.c
index 7b2fa0f..276e268 100644
--- a/drivers/staging/bcm/Misc.c
+++ b/drivers/staging/bcm/Misc.c
@@ -697,8 +697,8 @@ void DumpPackInfo(struct bcm_mini_adapter *Adapter)
 					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_INFO, DBG_LVL_ALL, "\tIpv6 ulSrcIpMask :\n");
 					DumpIpv6Address(pstClassifierEntry->stSrcIpAddress.ulIpv6Mask);
 				} else {
-					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_INFO, DBG_LVL_ALL, "\tulSrcIpAddr:%lX\n", pstClassifierEntry->stSrcIpAddress.ulIpv4Addr[uiIndex]);
-					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_INFO, DBG_LVL_ALL, "\tulSrcIpMask:%lX\n", pstClassifierEntry->stSrcIpAddress.ulIpv4Mask[uiIndex]);
+					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_INFO, DBG_LVL_ALL, "\tulSrcIpAddr:%uX\n", pstClassifierEntry->stSrcIpAddress.ulIpv4Addr[uiIndex]);
+					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_INFO, DBG_LVL_ALL, "\tulSrcIpMask:%uX\n", pstClassifierEntry->stSrcIpAddress.ulIpv4Mask[uiIndex]);
 				}
 			}
 
@@ -709,8 +709,8 @@ void DumpPackInfo(struct bcm_mini_adapter *Adapter)
 					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_INFO, DBG_LVL_ALL, "\tIpv6 ulDestIpMask :\n");
 					DumpIpv6Address(pstClassifierEntry->stDestIpAddress.ulIpv6Mask);
 				} else {
-					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_INFO, DBG_LVL_ALL, "\tulDestIpAddr:%lX\n", pstClassifierEntry->stDestIpAddress.ulIpv4Addr[uiIndex]);
-					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_INFO, DBG_LVL_ALL, "\tulDestIpMask:%lX\n", pstClassifierEntry->stDestIpAddress.ulIpv4Mask[uiIndex]);
+					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_INFO, DBG_LVL_ALL, "\tulDestIpAddr:%uX\n", pstClassifierEntry->stDestIpAddress.ulIpv4Addr[uiIndex]);
+					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_INFO, DBG_LVL_ALL, "\tulDestIpMask:%uX\n", pstClassifierEntry->stDestIpAddress.ulIpv4Mask[uiIndex]);
 				}
 			}
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_INFO, DBG_LVL_ALL, "\tucProtocol:0x%X\n", pstClassifierEntry->ucProtocol[0]);
-- 
1.7.9.5

