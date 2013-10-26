Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab3JZGQG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 02:16:06 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:64417 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab3JZGPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 02:15:37 -0400
From: Kevin McKinney <klmckinney1@gmail.com>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, Kevin McKinney <klmckinney1@gmail.com>
Subject: [PATCH 11/11] Staging: bcm: Replace BOOLEAN with bool in Adapter.h
Date: Sat, 26 Oct 2013 02:15:20 -0400
Message-Id: <1382768120-23380-11-git-send-email-klmckinney1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382768120-23380-1-git-send-email-klmckinney1@gmail.com>
References: <1382768120-23380-1-git-send-email-klmckinney1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces "BOOLEAN" with "bool"
in Adapter.h

Signed-off-by: Kevin McKinney <klmckinney1@gmail.com>
---
 drivers/staging/bcm/Adapter.h |  122 ++++++++++++++++++++---------------------
 1 file changed, 61 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/bcm/Adapter.h b/drivers/staging/bcm/Adapter.h
index c5891dd..ac81954 100644
--- a/drivers/staging/bcm/Adapter.h
+++ b/drivers/staging/bcm/Adapter.h
@@ -63,7 +63,7 @@ struct bcm_classifier_rule {
 	unsigned long	ulSFID;
 	unsigned char	ucReserved[2];
 	u16 uiClassifierRuleIndex;
-	BOOLEAN		bUsed;
+	bool		bUsed;
 	unsigned short	usVCID_Value;
 	u8		u8ClassifierRulePriority; /* This field detemines the Classifier Priority */
 	union bcm_ip_address stSrcIpAddress;
@@ -86,14 +86,14 @@ struct bcm_classifier_rule {
 	unsigned short	usDestPortRangeHi[MAX_PORT_RANGE];
 	unsigned char	ucDestPortRangeLength;
 
-	BOOLEAN		bProtocolValid;
-	BOOLEAN		bTOSValid;
-	BOOLEAN		bDestIpValid;
-	BOOLEAN		bSrcIpValid;
+	bool		bProtocolValid;
+	bool		bTOSValid;
+	bool		bDestIpValid;
+	bool		bSrcIpValid;
 
 	/* For IPv6 Addressing */
 	unsigned char	ucDirection;
-	BOOLEAN		bIpv6Protocol;
+	bool		bIpv6Protocol;
 	u32		u32PHSRuleID;
 	struct bcm_phs_rule sPhsRule;
 	unsigned char		u8AssociatedPHSI;
@@ -113,11 +113,11 @@ struct bcm_classifier_rule {
 };
 
 struct bcm_fragmented_packet_info {
-	BOOLEAN			bUsed;
+	bool			bUsed;
 	unsigned long		ulSrcIpAddress;
 	unsigned short usIpIdentification;
 	struct bcm_classifier_rule *pstMatchedClassifierEntry;
-	BOOLEAN			bOutOfOrderFragment;
+	bool			bOutOfOrderFragment;
 };
 
 struct bcm_packet_info {
@@ -128,9 +128,9 @@ struct bcm_packet_info {
 	/* This field determines the priority of the SF Queues */
 	u8		u8TrafficPriority;
 
-	BOOLEAN		bValid;
-	BOOLEAN		bActive;
-	BOOLEAN		bActivateRequestSent;
+	bool		bValid;
+	bool		bActive;
+	bool		bActivateRequestSent;
 
 	u8		u8QueueType; /* BE or rtPS */
 
@@ -170,17 +170,17 @@ struct bcm_packet_info {
 		};
 	};
 
-	BOOLEAN		bProtocolValid;
-	BOOLEAN		bTOSValid;
-	BOOLEAN		bDestIpValid;
-	BOOLEAN		bSrcIpValid;
+	bool		bProtocolValid;
+	bool		bTOSValid;
+	bool		bDestIpValid;
+	bool		bSrcIpValid;
 
-	BOOLEAN		bActiveSet;
-	BOOLEAN		bAdmittedSet;
-	BOOLEAN		bAuthorizedSet;
-	BOOLEAN		bClassifierPriority;
+	bool		bActiveSet;
+	bool		bAdmittedSet;
+	bool		bAuthorizedSet;
+	bool		bClassifierPriority;
 	unsigned char	ucServiceClassName[MAX_CLASS_NAME_LENGTH];
-	BOOLEAN		bHeaderSuppressionEnabled;
+	bool		bHeaderSuppressionEnabled;
 	spinlock_t	SFQueueLock;
 	void		*pstSFIndication;
 	struct timeval	stLastUpdateTokenAt;
@@ -196,8 +196,8 @@ struct bcm_tarang_data {
 	struct sk_buff		*RxAppControlHead;
 	struct sk_buff		*RxAppControlTail;
 	int			AppCtrlQueueLen;
-	BOOLEAN			MacTracingEnabled;
-	BOOLEAN			bApplicationToExit;
+	bool			MacTracingEnabled;
+	bool			bApplicationToExit;
 	struct bcm_mibs_dropped_cntrl_msg stDroppedAppCntrlMsgs;
 	unsigned long		RxCntrlMsgBitMask;
 };
@@ -205,7 +205,7 @@ struct bcm_tarang_data {
 struct bcm_targetdsx_buffer {
 	unsigned long	ulTargetDsxBuffer;
 	u16 tid;
-	BOOLEAN		valid;
+	bool		valid;
 };
 
 typedef int (*FP_FLASH_WRITE)(struct bcm_mini_adapter *, unsigned int, void *);
@@ -221,11 +221,11 @@ struct bcm_mini_adapter {
 	u32			msg_enable;
 	CHAR			*caDsxReqResp;
 	atomic_t		ApplicationRunning;
-	BOOLEAN			AppCtrlQueueOverFlow;
+	bool			AppCtrlQueueOverFlow;
 	atomic_t		CurrentApplicationCount;
 	atomic_t		RegisteredApplicationCount;
-	BOOLEAN			LinkUpStatus;
-	BOOLEAN			TimerActive;
+	bool			LinkUpStatus;
+	bool			TimerActive;
 	u32			StatisticsPointer;
 	struct sk_buff		*RxControlHead;
 	struct sk_buff		*RxControlTail;
@@ -249,22 +249,22 @@ struct bcm_mini_adapter {
 	unsigned int		u32TotalDSD;
 	struct bcm_packet_info	PackInfo[NO_OF_QUEUES];
 	struct bcm_classifier_rule astClassifierTable[MAX_CLASSIFIERS];
-	BOOLEAN			TransferMode;
+	bool			TransferMode;
 
 	/*************** qos ******************/
-	BOOLEAN			bETHCSEnabled;
+	bool			bETHCSEnabled;
 	unsigned long		BEBucketSize;
 	unsigned long		rtPSBucketSize;
 	unsigned char		LinkStatus;
-	BOOLEAN			AutoLinkUp;
-	BOOLEAN			AutoSyncup;
+	bool			AutoLinkUp;
+	bool			AutoSyncup;
 
 	int			major;
 	int			minor;
 	wait_queue_head_t	tx_packet_wait_queue;
 	wait_queue_head_t	process_rx_cntrlpkt;
 	atomic_t		process_waiting;
-	BOOLEAN			fw_download_done;
+	bool			fw_download_done;
 
 	char			*txctlpacket[MAX_CNTRL_PKTS];
 	atomic_t		cntrlpktCnt;
@@ -280,19 +280,19 @@ struct bcm_mini_adapter {
 	unsigned long		ulTotalTargetBuffersAvailable;
 	unsigned long		chip_id;
 	wait_queue_head_t	lowpower_mode_wait_queue;
-	BOOLEAN			bFlashBoot;
-	BOOLEAN			bBinDownloaded;
-	BOOLEAN			bCfgDownloaded;
-	BOOLEAN			bSyncUpRequestSent;
+	bool			bFlashBoot;
+	bool			bBinDownloaded;
+	bool			bCfgDownloaded;
+	bool			bSyncUpRequestSent;
 	unsigned short		usBestEffortQueueIndex;
 	wait_queue_head_t	ioctl_fw_dnld_wait_queue;
-	BOOLEAN			waiting_to_fw_download_done;
+	bool			waiting_to_fw_download_done;
 	pid_t			fw_download_process_pid;
 	struct bcm_target_params *pstargetparams;
-	BOOLEAN			device_removed;
-	BOOLEAN			DeviceAccess;
-	BOOLEAN			bIsAutoCorrectEnabled;
-	BOOLEAN			bDDRInitDone;
+	bool			device_removed;
+	bool			DeviceAccess;
+	bool			bIsAutoCorrectEnabled;
+	bool			bDDRInitDone;
 	int			DDRSetting;
 	unsigned long		ulPowerSaveMode;
 	spinlock_t		txtransmitlock;
@@ -324,22 +324,22 @@ struct bcm_mini_adapter {
 			void *,
 			int);
 	int (*interface_transmit)(void *, void *, unsigned int);
-	BOOLEAN			IdleMode;
-	BOOLEAN			bDregRequestSentInIdleMode;
-	BOOLEAN			bTriedToWakeUpFromlowPowerMode;
-	BOOLEAN			bShutStatus;
-	BOOLEAN			bWakeUpDevice;
+	bool			IdleMode;
+	bool			bDregRequestSentInIdleMode;
+	bool			bTriedToWakeUpFromlowPowerMode;
+	bool			bShutStatus;
+	bool			bWakeUpDevice;
 	unsigned int		usIdleModePattern;
-	/* BOOLEAN			bTriedToWakeUpFromShutdown; */
-	BOOLEAN			bLinkDownRequested;
+	/* bool			bTriedToWakeUpFromShutdown; */
+	bool			bLinkDownRequested;
 	int			downloadDDR;
 	struct bcm_phs_extension stBCMPhsContext;
 	struct bcm_hdr_suppression_contextinfo stPhsTxContextInfo;
 	uint8_t			ucaPHSPktRestoreBuf[2048];
 	uint8_t			bPHSEnabled;
-	BOOLEAN			AutoFirmDld;
-	BOOLEAN			bMipsConfig;
-	BOOLEAN			bDPLLConfig;
+	bool			AutoFirmDld;
+	bool			bMipsConfig;
+	bool			bDPLLConfig;
 	u32			aTxPktSizeHist[MIBS_MAX_HIST_ENTRIES];
 	u32			aRxPktSizeHist[MIBS_MAX_HIST_ENTRIES];
 	struct bcm_fragmented_packet_info astFragmentedPktClassifierTable[MAX_FRAGMENTEDIP_CLASSIFICATION_ENTRIES];
@@ -348,8 +348,8 @@ struct bcm_mini_adapter {
 	enum bcm_nvm_type	eNVMType;
 	unsigned int		uiSectorSize;
 	unsigned int		uiSectorSizeInCFG;
-	BOOLEAN			bSectorSizeOverride;
-	BOOLEAN			bStatusWrite;
+	bool			bSectorSizeOverride;
+	bool			bStatusWrite;
 	unsigned int		uiNVMDSDSize;
 	unsigned int		uiVendorExtnFlag;
 	/* it will always represent chosen DSD at any point of time.
@@ -365,7 +365,7 @@ struct bcm_mini_adapter {
 	struct semaphore	NVMRdmWrmLock;
 	struct device		*pstCreatedClassDevice;
 
-	/*	BOOLEAN				InterfaceUpStatus; */
+	/*	bool				InterfaceUpStatus; */
 	struct bcm_flash2x_cs_info *psFlash2xCSInfo;
 	struct bcm_flash_cs_info *psFlashCSInfo;
 	struct bcm_flash2x_vendor_info *psFlash2xVendorInfo;
@@ -376,18 +376,18 @@ struct bcm_mini_adapter {
 	unsigned int		uiActiveDSDOffsetAtFwDld;  /* For accessing Active DSD chosen before f/w download */
 	unsigned int		uiFlashLayoutMajorVersion;
 	unsigned int		uiFlashLayoutMinorVersion;
-	BOOLEAN			bAllDSDWriteAllow;
-	BOOLEAN			bSigCorrupted;
+	bool			bAllDSDWriteAllow;
+	bool			bSigCorrupted;
 	/* this should be set who so ever want to change the Headers. after Wrtie it should be reset immediately. */
-	BOOLEAN			bHeaderChangeAllowed;
+	bool			bHeaderChangeAllowed;
 	int			SelectedChip;
-	BOOLEAN			bEndPointHalted;
+	bool			bEndPointHalted;
 	/* while bFlashRawRead will be true, Driver  ignore map lay out and consider flash as of without any map. */
-	BOOLEAN			bFlashRawRead;
-	BOOLEAN			bPreparingForLowPowerMode;
-	BOOLEAN			bDoSuspend;
+	bool			bFlashRawRead;
+	bool			bPreparingForLowPowerMode;
+	bool			bDoSuspend;
 	unsigned int		syscfgBefFwDld;
-	BOOLEAN			StopAllXaction;
+	bool			StopAllXaction;
 	u32			liTimeSinceLastNetEntry; /* Used to Support extended CAPI requirements from */
 	struct semaphore	LowPowerModeSync;
 	unsigned long		liDrainCalculated;
-- 
1.7.9.5

