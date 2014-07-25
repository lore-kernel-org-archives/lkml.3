Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760567AbaGYQSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:18:53 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:65482 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaGYQSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:18:51 -0400
From: Igor Bezukh <igbzkh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org, igbzkh@gmail.com
Subject: [PATCH] Staging: vt6655: removed redundant comments from device.h
Date: Fri, 25 Jul 2014 19:18:37 +0300
Message-Id: <1406305117-31726-1-git-send-email-igbzkh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed redundant comments from device.h header file.

Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
---
 drivers/staging/vt6655/device.h |   82 ++++++++++-----------------------------
 1 file changed, 21 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 45fc8a0..201f5cd 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -49,7 +49,6 @@
 #include <linux/sched.h>
 #include <linux/io.h>
 #include <linux/if.h>
-//#include <linux/config.h>
 #include <linux/uaccess.h>
 #include <linux/proc_fs.h>
 #include <linux/inetdevice.h>
@@ -60,11 +59,9 @@
 #else
 #undef DEVICE_ETHTOOL_IOCTL_SUPPORT
 #endif
-/* Include Wireless Extension definition and check version - Jean II */
 #include <linux/wireless.h>
-#include <net/iw_handler.h>	// New driver API
+#include <net/iw_handler.h>
 
-//2008-0409-07, <Add> by Einsn Liu
 #ifndef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 #define WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 #endif
@@ -86,8 +83,6 @@
 #include "key.h"
 #include "mac.h"
 
-/*---------------------  Export Definitions -------------------------*/
-
 #define MAC_MAX_CONTEXT_REG     (256+128)
 
 #define MAX_MULTICAST_ADDRESS_NUM       32
@@ -136,18 +131,12 @@
 // DMA related
 #define RESERV_AC0DMA                   4
 
-// BUILD OBJ mode
-
 #define	AVAIL_TD(p, q)	((p)->sOpts.nTxDescs[(q)] - ((p)->iTDUsed[(q)]))
 
-//PLICE_DEBUG ->
 #define	NUM				64
-//PLICE_DEUBG <-
 
 #define PRIVATE_Message                 0
 
-/*---------------------  Export Types  ------------------------------*/
-
 #define DBG_PRT(l, p, args...)		\
 do {					\
 	if (l <= msglevel)		\
@@ -160,7 +149,6 @@ do {					\
 		printk(p, ##args);	\
 } while (0)
 
-//0:11A 1:11B 2:11G
 typedef enum _VIA_BB_TYPE
 {
 	BB_TYPE_11A = 0,
@@ -168,7 +156,6 @@ typedef enum _VIA_BB_TYPE
 	BB_TYPE_11G
 } VIA_BB_TYPE, *PVIA_BB_TYPE;
 
-//0:11a,1:11b,2:11gb(only CCK in BasicRate),3:11ga(OFDM in Basic Rate)
 typedef enum _VIA_PKT_TYPE
 {
 	PK_TYPE_11A = 0,
@@ -178,21 +165,19 @@ typedef enum _VIA_PKT_TYPE
 } VIA_PKT_TYPE, *PVIA_PKT_TYPE;
 
 typedef enum __device_msg_level {
-	MSG_LEVEL_ERR = 0,            //Errors that will cause abnormal operation.
-	MSG_LEVEL_NOTICE = 1,         //Some errors need users to be notified.
-	MSG_LEVEL_INFO = 2,           //Normal message.
-	MSG_LEVEL_VERBOSE = 3,        //Will report all trival errors.
-	MSG_LEVEL_DEBUG = 4           //Only for debug purpose.
+	MSG_LEVEL_ERR = 0,
+	MSG_LEVEL_NOTICE = 1,
+	MSG_LEVEL_INFO = 2,
+	MSG_LEVEL_VERBOSE = 3,
+	MSG_LEVEL_DEBUG = 4
 } DEVICE_MSG_LEVEL, *PDEVICE_MSG_LEVEL;
 
 typedef enum __device_init_type {
-	DEVICE_INIT_COLD = 0,         // cold init
-	DEVICE_INIT_RESET,          // reset init or Dx to D0 power remain init
-	DEVICE_INIT_DXPL            // Dx to D0 power lost init
+	DEVICE_INIT_COLD = 0,
+	DEVICE_INIT_RESET,
+	DEVICE_INIT_DXPL
 } DEVICE_INIT_TYPE, *PDEVICE_INIT_TYPE;
 
-//++ NDIS related
-
 #define MAX_BSSIDINFO_4_PMKID   16
 #define MAX_PMKIDLIST           5
 //Flags for PMKID Candidate list structure
@@ -246,14 +231,11 @@ typedef struct tagSPMKID {
 
 typedef struct tagSPMKIDCandidateEvent {
 	NDIS_802_11_STATUS_TYPE     StatusType;
-	unsigned long Version;       // Version of the structure
-	unsigned long NumCandidates; // No. of pmkid candidates
+	unsigned long Version;
+	unsigned long NumCandidates;
 	PMKID_CANDIDATE CandidateList[MAX_PMKIDLIST];
 } SPMKIDCandidateEvent, *PSPMKIDCandidateEvent;
 
-//--
-
-//++ 802.11h related
 #define MAX_QUIET_COUNT     8
 
 typedef struct tagSQuietControl {
@@ -263,7 +245,6 @@ typedef struct tagSQuietControl {
 	unsigned short wDuration;
 } SQuietControl, *PSQuietControl;
 
-//--
 typedef struct __chip_info_tbl {
 	CHIP_TYPE   chip_id;
 	char *name;
@@ -287,7 +268,7 @@ typedef struct tagSCache {
 /* The receive cache is updated circularly.  The next entry to be written is
  * indexed by the "InPtr".
  */
-	unsigned int uInPtr;         // Place to use next
+	unsigned int uInPtr;
 	SCacheEntry     asCacheEntry[DUPLICATE_RX_CACHE_LENGTH];
 } SCache, *PSCache;
 
@@ -332,8 +313,6 @@ typedef struct tagSDeFragControlBlock
 //for device_set_media_duplex
 #define     DEVICE_LINK_CHANGE           0x00000001UL
 
-//PLICE_DEBUG->
-
 typedef	struct _RxManagementQueue
 {
 	int	packet_num;
@@ -341,14 +320,12 @@ typedef	struct _RxManagementQueue
 	PSRxMgmtPacket	Q[NUM];
 } RxManagementQueue, *PSRxManagementQueue;
 
-//PLICE_DEBUG<-
-
 typedef struct __device_opt {
-	int         nRxDescs0;    //Number of RX descriptors0
-	int         nRxDescs1;    //Number of RX descriptors1
-	int         nTxDescs[2];  //Number of TX descriptors 0, 1
-	int         int_works;    //interrupt limits
-	int         rts_thresh;   //rts threshold
+	int         nRxDescs0;
+	int         nRxDescs1;
+	int         nTxDescs[2];
+	int         int_works;
+	int         rts_thresh;
 	int         frag_thresh;
 	int         data_rate;
 	int         channel_num;
@@ -368,12 +345,10 @@ typedef struct __device_info {
 	u32                         pci_state[16];
 #endif
 
-// netdev
 	struct net_device *dev;
 	struct net_device *next_module;
 	struct net_device_stats     stats;
 
-//dma addr, rx/tx pool
 	dma_addr_t                  pool_dma;
 	dma_addr_t                  rd0_pool_dma;
 	dma_addr_t                  rd1_pool_dma;
@@ -429,15 +404,11 @@ typedef struct __device_info {
 	unsigned char byRxMode;
 
 	spinlock_t                  lock;
-//PLICE_DEBUG->
 	struct	tasklet_struct	RxMngWorkItem;
 	RxManagementQueue	rxManeQueue;
-//PLICE_DEBUG<-
-//PLICE_DEBUG ->
 	pid_t			MLMEThr_pid;
 	struct completion	notify;
 	struct semaphore	mlme_semaphore;
-//PLICE_DEBUG <-
 
 	u32                         rx_bytes;
 
@@ -577,14 +548,11 @@ typedef struct __device_info {
 	bool bCmdClear;
 
 	bool bRoaming;
-	//WOW
 	unsigned char abyIPAddr[4];
 
 	unsigned long ulTxPower;
 	NDIS_802_11_WEP_STATUS  eEncryptionStatus;
 	bool bTransmitKey;
-//2007-0925-01<Add>by MikeLiu
-//mike add :save old Encryption
 	NDIS_802_11_WEP_STATUS  eOldEncryptionStatus;
 
 	SKeyManagement          sKey;
@@ -675,9 +643,9 @@ typedef struct __device_info {
 #endif
 
 #ifdef WPA_SM_Transtatus
-	bool fWPA_Authened;           //is WPA/WPA-PSK or WPA2/WPA2-PSK authen??
+	bool fWPA_Authened;
 #endif
-	unsigned char byReAssocCount;   //mike add:re-association retry times!
+	unsigned char byReAssocCount;
 	unsigned char byLinkWaitCount;
 
 	unsigned char abyNodeName[17];
@@ -710,7 +678,7 @@ typedef struct __device_info {
 	unsigned char abyBroadcastAddr[ETH_ALEN];
 	unsigned char abySNAP_RFC1042[ETH_ALEN];
 	unsigned char abySNAP_Bridgetunnel[ETH_ALEN];
-	unsigned char abyEEPROM[EEP_MAX_CONTEXT_SIZE];  //unsigned long alignment
+	unsigned char abyEEPROM[EEP_MAX_CONTEXT_SIZE];
 	// Pre-Authentication & PMK cache
 	SPMKID                  gsPMKID;
 	SPMKIDCandidateEvent    gsPMKIDCandidate;
@@ -754,7 +722,6 @@ typedef struct __device_info {
 	bool bWPASuppWextEnabled;
 #endif
 
-	//--
 #ifdef HOSTAP
 	// user space daemon: hostapd, is used for HOSTAP
 	bool bEnableHostapd;
@@ -766,12 +733,10 @@ typedef struct __device_info {
 	unsigned int	uChannel;
 	bool bMACSuspend;
 
-	struct iw_statistics	wstats;		// wireless stats
+	struct iw_statistics	wstats;
 	bool bCommit;
 } DEVICE_INFO, *PSDevice;
 
-//PLICE_DEBUG->
-
 inline  static	void   EnQueue(PSDevice pDevice, PSRxMgmtPacket  pRxMgmtPacket)
 {
 	if ((pDevice->rxManeQueue.tail+1) % NUM == pDevice->rxManeQueue.head) {
@@ -791,7 +756,6 @@ inline  static  PSRxMgmtPacket DeQueue(PSDevice pDevice)
 		return NULL;
 	} else {
 		int	x;
-		//x=pDevice->rxManeQueue.head = (pDevice->rxManeQueue.head+1)%NUM;
 		pDevice->rxManeQueue.head = (pDevice->rxManeQueue.head+1)%NUM;
 		x = pDevice->rxManeQueue.head;
 		pRxMgmtPacket = pDevice->rxManeQueue.Q[x];
@@ -802,8 +766,6 @@ inline  static  PSRxMgmtPacket DeQueue(PSDevice pDevice)
 
 void	InitRxManagementQueue(PSDevice   pDevice);
 
-//PLICE_DEBUG<-
-
 inline static bool device_get_ip(PSDevice pInfo) {
 	struct in_device *in_dev = (struct in_device *)pInfo->dev->ip_ptr;
 	struct in_ifaddr *ifa;
@@ -828,8 +790,6 @@ static inline PDEVICE_TD_INFO alloc_td_info(void)
 	return kzalloc(sizeof(DEVICE_TD_INFO), GFP_ATOMIC);
 }
 
-/*---------------------  Export Functions  --------------------------*/
-
 bool device_dma0_xmit(PSDevice pDevice, struct sk_buff *skb, unsigned int uNodeIndex);
 bool device_alloc_frag_buf(PSDevice pDevice, PSDeFragControlBlock pDeF);
 int Config_FileOperation(PSDevice pDevice, bool fwrite, unsigned char *Parameter);
-- 
1.7.9.5

