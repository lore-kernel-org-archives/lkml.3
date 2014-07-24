Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935211AbaGXXLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:11:30 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:44258 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759777AbaGXXHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:07:06 -0400
X-Originating-IP: 109.10.215.15
From: Guillaume Clement <gclement@baobob.org>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Guillaume Clement <gclement@baobob.org>
Subject: [PATCH 02/14] staging: vt6655: Add missing blank lines after declarations
Date: Fri, 25 Jul 2014 01:06:16 +0200
Message-Id: <1406243188-13413-3-git-send-email-gclement@baobob.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1406243188-13413-1-git-send-email-gclement@baobob.org>
References: <1406243188-13413-1-git-send-email-gclement@baobob.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the missing blank lines after declarations in vt6655
reported by checkpatch.

Signed-off-by: Guillaume Clement <gclement@baobob.org>
---
 drivers/staging/vt6655/80211mgr.c    |  1 +
 drivers/staging/vt6655/baseband.c    |  1 +
 drivers/staging/vt6655/bssdb.c       |  7 +++++++
 drivers/staging/vt6655/card.c        |  1 +
 drivers/staging/vt6655/device.h      |  1 +
 drivers/staging/vt6655/device_main.c | 11 +++++++++++
 drivers/staging/vt6655/dpc.c         |  3 +++
 drivers/staging/vt6655/iwctl.c       |  8 ++++++++
 drivers/staging/vt6655/rc4.c         |  1 +
 drivers/staging/vt6655/rf.c          |  2 ++
 drivers/staging/vt6655/rxtx.c        |  8 ++++++++
 drivers/staging/vt6655/vntwifi.c     |  3 +++
 drivers/staging/vt6655/wcmd.c        |  1 +
 drivers/staging/vt6655/wmgr.c        |  2 ++
 drivers/staging/vt6655/wpa.c         |  1 +
 drivers/staging/vt6655/wpactl.c      |  1 +
 16 files changed, 52 insertions(+)

diff --git a/drivers/staging/vt6655/80211mgr.c b/drivers/staging/vt6655/80211mgr.c
index acdbbbd..96b0d61 100644
--- a/drivers/staging/vt6655/80211mgr.c
+++ b/drivers/staging/vt6655/80211mgr.c
@@ -546,6 +546,7 @@ vMgrDecodeReassocRequest(
 )
 {
 	PWLAN_IE   pItem;
+
 	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 
 	/* Fixed Fields */
diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index c96bc7a..f212b88 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -2289,6 +2289,7 @@ void BBvReadAllRegs(void __iomem *dwIoBase, unsigned char *pbyBBRegs)
 {
 	int  ii;
 	unsigned char byBase = 1;
+
 	for (ii = 0; ii < BB_MAX_CONTEXT_SIZE; ii++) {
 		BBbReadEmbedded(dwIoBase, (unsigned char)(ii*byBase), pbyBBRegs);
 		pbyBBRegs += byBase;
diff --git a/drivers/staging/vt6655/bssdb.c b/drivers/staging/vt6655/bssdb.c
index 5f9fd2b..58f85e8 100644
--- a/drivers/staging/vt6655/bssdb.c
+++ b/drivers/staging/vt6655/bssdb.c
@@ -422,6 +422,7 @@ BSSbInsertToBSSList(
 
 	if (pRSN != NULL) {
 		unsigned int uLen = pRSN->len + 2;
+
 		if (uLen <= (uIELength - (unsigned int)((unsigned char *)pRSN - pbyIEs))) {
 			pBSSList->wRSNLen = uLen;
 			memcpy(pBSSList->byRSNIE, pRSN, uLen);
@@ -598,6 +599,7 @@ BSSbUpdateToBSSList(
 
 	if (pRSNWPA != NULL) {
 		unsigned int uLen = pRSNWPA->len + 2;
+
 		if (uLen <= (uIELength - (unsigned int)((unsigned char *)pRSNWPA - pbyIEs))) {
 			pBSSList->wWPALen = uLen;
 			memcpy(pBSSList->byWPAIE, pRSNWPA, uLen);
@@ -609,6 +611,7 @@ BSSbUpdateToBSSList(
 
 	if (pRSN != NULL) {
 		unsigned int uLen = pRSN->len + 2;
+
 		if (uLen <= (uIELength - (unsigned int)((unsigned char *)pRSN - pbyIEs))) {
 			pBSSList->wRSNLen = uLen;
 			memcpy(pBSSList->byRSNIE, pRSN, uLen);
@@ -988,6 +991,7 @@ start:
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 			{
 				union iwreq_data  wrqu;
+
 				memset(&wrqu, 0, sizeof(wrqu));
 				wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 				PRINT_K("wireless_send_event--->SIOCGIWAP(disassociated)\n");
@@ -1167,6 +1171,7 @@ start:
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 				{
 					union iwreq_data  wrqu;
+
 					memset(&wrqu, 0, sizeof(wrqu));
 					wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 					PRINT_K("wireless_send_event--->SIOCGIWAP(disassociated)\n");
@@ -1267,6 +1272,7 @@ BSSvUpdateNodeTxCounter(
 	unsigned short wFallBackRate = RATE_1M;
 	unsigned char byFallBack;
 	unsigned int ii;
+
 	pTxBufHead = (PSTxBufHead) pbyBuffer;
 	if (pTxBufHead->wFIFOCtl & FIFOCTL_AUTO_FB_0)
 		byFallBack = AUTO_FB_0;
@@ -1451,6 +1457,7 @@ void s_vCheckSensitivity(
 			/* Update BB Reg if RSSI is too strong */
 			long    LocalldBmAverage = 0;
 			long    uNumofdBm = 0;
+
 			for (ii = 0; ii < RSSI_STAT_COUNT; ii++) {
 				if (pBSSList->ldBmAverage[ii] != 0) {
 					uNumofdBm++;
diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index f2674b4..fdeb805 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -1770,6 +1770,7 @@ void vUpdateIFS(void *pDeviceHandler)
 	PSDevice pDevice = (PSDevice) pDeviceHandler;
 
 	unsigned char byMaxMin = 0;
+
 	if (pDevice->byPacketType == PK_TYPE_11A) {//0000 0000 0000 0000,11a
 		pDevice->uSlot = C_SLOT_SHORT;
 		pDevice->uSIFS = C_SIFS_A;
diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 647e36fe..f33ecf0 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -786,6 +786,7 @@ inline  static	void   EnQueue(PSDevice pDevice, PSRxMgmtPacket  pRxMgmtPacket)
 inline  static  PSRxMgmtPacket DeQueue(PSDevice pDevice)
 {
 	PSRxMgmtPacket  pRxMgmtPacket;
+
 	if (pDevice->rxManeQueue.tail == pDevice->rxManeQueue.head) {
 		printk("Queue is Empty\n");
 		return NULL;
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index f46e8d4..b3b2ee6 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -326,6 +326,7 @@ static int Config_FileGetParameter(unsigned char *string,
 static char *get_chip_name(int chip_id)
 {
 	int i;
+
 	for (i = 0; chip_info_table[i].name != NULL; i++)
 		if (chip_info_table[i].chip_id == chip_id)
 			break;
@@ -464,6 +465,7 @@ static void device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
 	unsigned char byOFDMPwrdBm = 0;
 	int zonetype = 0;
 	PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
+
 	MACbShutdown(pDevice->PortOffset);
 	BBvSoftwareReset(pDevice->PortOffset);
 
@@ -1006,6 +1008,7 @@ static bool device_get_pci_info(PSDevice pDevice, struct pci_dev *pcid) {
 	unsigned char value = 0x00;
 	int		ii, j;
 	u16	max_lat = 0x0000;
+
 	memset(pci_config, 0x00, 256);
 #endif
 
@@ -1342,6 +1345,7 @@ static void device_init_td1_ring(PSDevice pDevice) {
 
 static void device_free_td0_ring(PSDevice pDevice) {
 	int i;
+
 	for (i = 0; i < pDevice->sOpts.nTxDescs[0]; i++) {
 		PSTxDesc        pDesc = &(pDevice->apTD0Rings[i]);
 		PDEVICE_TD_INFO  pTDInfo = pDesc->pTDInfo;
@@ -2262,6 +2266,7 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
 		unsigned char Descriptor_type;
 		unsigned short Key_info;
 		bool bTxeapol_key = false;
+
 		Protocol_Version = skb->data[ETH_HLEN];
 		Packet_Type = skb->data[ETH_HLEN+1];
 		Descriptor_type = skb->data[ETH_HLEN+1+1+2];
@@ -2560,6 +2565,7 @@ static inline u32 ether_crc(int length, unsigned char *data)
 	while (--length >= 0) {
 		unsigned char current_octet = *data++;
 		int bit;
+
 		for (bit = 0; bit < 8; bit++, current_octet >>= 1) {
 			crc = (crc << 1) ^
 				((crc < 0) ^ (current_octet & 1) ? ethernet_polynomial : 0);
@@ -2655,6 +2661,7 @@ static void device_set_multi(struct net_device *dev) {
 		memset(mc_filter, 0, sizeof(mc_filter));
 		netdev_for_each_mc_addr(ha, dev) {
 			int bit_nr = ether_crc(ETH_ALEN, ha->addr) >> 26;
+
 			mc_filter[bit_nr >> 5] |= cpu_to_le32(1 << (bit_nr & 31));
 		}
 		MACvSelectPage1(pDevice->PortOffset);
@@ -2718,6 +2725,7 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 
 	{
 		char essid[IW_ESSID_MAX_SIZE+1];
+
 		if (wrq->u.essid.length > IW_ESSID_MAX_SIZE) {
 			rc = -E2BIG;
 			break;
@@ -2737,6 +2745,7 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 
 	{
 		char essid[IW_ESSID_MAX_SIZE+1];
+
 		if (wrq->u.essid.pointer)
 			rc = iwctl_giwessid(dev, NULL,
 					    &(wrq->u.essid), essid);
@@ -3099,6 +3108,7 @@ static int ethtool_ioctl(struct net_device *dev, void __user *useraddr)
 	switch (ethcmd) {
 	case ETHTOOL_GDRVINFO: {
 		struct ethtool_drvinfo info = {ETHTOOL_GDRVINFO};
+
 		strncpy(info.driver, DEVICE_NAME, sizeof(info.driver)-1);
 		strncpy(info.version, DEVICE_VERSION, sizeof(info.version)-1);
 		if (copy_to_user(useraddr, &info, sizeof(info)))
@@ -3155,6 +3165,7 @@ static int
 device_notify_reboot(struct notifier_block *nb, unsigned long event, void *p)
 {
 	struct pci_dev *pdev = NULL;
+
 	switch (event) {
 	case SYS_DOWN:
 	case SYS_HALT:
diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index 696564b..5b2ace2 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -604,6 +604,7 @@ device_receive_frame(
 			{
 				unsigned char Protocol_Version;    //802.1x Authentication
 				unsigned char Packet_Type;           //802.1x Authentication
+
 				if (bIsWEP)
 					cbIVOffset = 8;
 				else
@@ -761,6 +762,7 @@ device_receive_frame(
 					union iwreq_data wrqu;
 					struct iw_michaelmicfailure ev;
 					int keyidx = pbyFrame[cbHeaderSize+3] >> 6; //top two-bits
+
 					memset(&ev, 0, sizeof(ev));
 					ev.flags = keyidx & IW_MICFAILURE_KEY_ID;
 					if ((pMgmt->eCurrMode == WMAC_MODE_ESS_STA) &&
@@ -1114,6 +1116,7 @@ static bool s_bHandleRxEncryption(
 			// Software TKIP
 			// 1. 3253 A
 			PS802_11Header  pMACHeader = (PS802_11Header)(pbyFrame);
+
 			TKIPvMixKey(pKey->abyKey, pMACHeader->abyAddr2, *pwRxTSC15_0, *pdwRxTSC47_16, pDevice->abyPRNG);
 			rc4_init(&pDevice->SBox, pDevice->abyPRNG, TKIP_KEY_LEN);
 			rc4_encrypt(&pDevice->SBox, pbyIV+8, pbyIV+8, PayloadLen);
diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index 747d723..d449fcb1 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -139,11 +139,13 @@ static int iwctl_siwscan(struct net_device *dev,
 	struct iw_scan_req  *req = (struct iw_scan_req *)extra;
 	unsigned char abyScanSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
 	PWLAN_IE_SSID pItemSSID = NULL;
+
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWSCAN \n");
 
 	if (pDevice->byReAssocCount > 0) {   //reject scan when re-associating!
 //send scan event to wpa_Supplicant
 		union iwreq_data wrqu;
+
 		PRINT_K("wireless_send_event--->SIOCGIWSCAN(scan done)\n");
 		memset(&wrqu, 0, sizeof(wrqu));
 		wireless_send_event(pDevice->dev, SIOCGIWSCAN, &wrqu, NULL);
@@ -255,6 +257,7 @@ static int iwctl_giwscan(struct net_device *dev,
 			//2008-0409-04, <Add> by Einsn Liu
 			{
 				int f = (int)pBSS->uChannel - 1;
+
 				if (f < 0)f = 0;
 				iwe.u.freq.m = frequency_list[f] * 100000;
 				iwe.u.freq.e = 1;
@@ -358,6 +361,7 @@ int iwctl_siwfreq(struct net_device *dev,
 	    (wrq->m <= (int) 2.487e8)) {
 		int f = wrq->m / 100000;
 		int c = 0;
+
 		while ((c < 14) && (f != frequency_list[c]))
 			c++;
 		wrq->e = 0;
@@ -368,6 +372,7 @@ int iwctl_siwfreq(struct net_device *dev,
 		rc = -EOPNOTSUPP;
 	else {
 		int channel = wrq->m;
+
 		if ((channel < 1) || (channel > 14)) {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: New channel value of %d is invalid!\n", dev->name, wrq->m);
 			rc = -EINVAL;
@@ -404,6 +409,7 @@ int iwctl_giwfreq(struct net_device *dev,
 #else
 	{
 		int f = (int)pMgmt->uCurrChannel - 1;
+
 		if (f < 0)
 			f = 0;
 		wrq->m = frequency_list[f] * 100000;
@@ -658,6 +664,7 @@ int iwctl_siwap(struct net_device *dev,
 		//                  then ignore,because you don't known which one to be connect with??
 		{
 			unsigned int ii, uSameBssidNum = 0;
+
 			for (ii = 0; ii < MAX_BSS_NUM; ii++) {
 				if (pMgmt->sBSSList[ii].bActive &&
 				    ether_addr_equal(pMgmt->sBSSList[ii].abyBSSID,
@@ -1059,6 +1066,7 @@ int iwctl_siwrts(struct net_device *dev,
 
 	{
 		int rthr = wrq->value;
+
 		if (wrq->disabled)
 			rthr = 2312;
 
diff --git a/drivers/staging/vt6655/rc4.c b/drivers/staging/vt6655/rc4.c
index 343b815..b7819bc 100644
--- a/drivers/staging/vt6655/rc4.c
+++ b/drivers/staging/vt6655/rc4.c
@@ -82,6 +82,7 @@ void rc4_encrypt(PRC4Ext pRC4, unsigned char *pbyDest,
 		 unsigned char *pbySrc, unsigned int cbData_len)
 {
 	unsigned int ii;
+
 	for (ii = 0; ii < cbData_len; ii++)
 		pbyDest[ii] = (unsigned char)(pbySrc[ii] ^ rc4_byte(pRC4));
 }
diff --git a/drivers/staging/vt6655/rf.c b/drivers/staging/vt6655/rf.c
index 33913e5..d2d7dff 100644
--- a/drivers/staging/vt6655/rf.c
+++ b/drivers/staging/vt6655/rf.c
@@ -750,6 +750,7 @@ bool RFbInit(
 )
 {
 	bool bResult = true;
+
 	switch (pDevice->byRFType) {
 	case RF_AIROHA:
 	case RF_AL2230S:
@@ -786,6 +787,7 @@ bool RFbInit(
 bool RFbSelectChannel(void __iomem *dwIoBase, unsigned char byRFType, unsigned char byChannel)
 {
 	bool bResult = true;
+
 	switch (byRFType) {
 	case RF_AIROHA:
 	case RF_AL2230S:
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 52455cd..092b918 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -1084,6 +1084,7 @@ s_vGenerateTxParameter(
 	unsigned char byFBOption = AUTO_FB_NONE;
 
 	PSTxBufHead pFifoHead = (PSTxBufHead)pTxBufHead;
+
 	pFifoHead->wReserved = wCurrentRate;
 	wFifoCtl = pFifoHead->wFIFOCtl;
 
@@ -1103,6 +1104,7 @@ s_vGenerateTxParameter(
 			//Fill RsvTime
 			if (pvRrvTime) {
 				PSRrvTime_gRTS pBuf = (PSRrvTime_gRTS)pvRrvTime;
+
 				pBuf->wRTSTxRrvTime_aa = cpu_to_le16((unsigned short)s_uGetRTSCTSRsvTime(pDevice, 2, byPktType, cbFrameSize, wCurrentRate));//2:RTSTxRrvTime_aa, 1:2.4GHz
 				pBuf->wRTSTxRrvTime_ba = cpu_to_le16((unsigned short)s_uGetRTSCTSRsvTime(pDevice, 1, byPktType, cbFrameSize, wCurrentRate));//1:RTSTxRrvTime_ba, 1:2.4GHz
 				pBuf->wRTSTxRrvTime_bb = cpu_to_le16((unsigned short)s_uGetRTSCTSRsvTime(pDevice, 0, byPktType, cbFrameSize, wCurrentRate));//0:RTSTxRrvTime_bb, 1:2.4GHz
@@ -1116,6 +1118,7 @@ s_vGenerateTxParameter(
 			//Fill RsvTime
 			if (pvRrvTime) {
 				PSRrvTime_gCTS pBuf = (PSRrvTime_gCTS)pvRrvTime;
+
 				pBuf->wTxRrvTime_a = cpu_to_le16((unsigned short)s_uGetTxRsvTime(pDevice, byPktType, cbFrameSize, wCurrentRate, bNeedACK));//2.4G OFDM
 				pBuf->wTxRrvTime_b = cpu_to_le16((unsigned short)s_uGetTxRsvTime(pDevice, PK_TYPE_11B, cbFrameSize, pDevice->byTopCCKBasicRate, bNeedACK));//1:CCK
 				pBuf->wCTSTxRrvTime_ba = cpu_to_le16((unsigned short)s_uGetRTSCTSRsvTime(pDevice, 3, byPktType, cbFrameSize, wCurrentRate));//3:CTSTxRrvTime_Ba, 1:2.4GHz
@@ -1129,6 +1132,7 @@ s_vGenerateTxParameter(
 			//Fill RsvTime
 			if (pvRrvTime) {
 				PSRrvTime_ab pBuf = (PSRrvTime_ab)pvRrvTime;
+
 				pBuf->wRTSTxRrvTime = cpu_to_le16((unsigned short)s_uGetRTSCTSRsvTime(pDevice, 2, byPktType, cbFrameSize, wCurrentRate));//2:RTSTxRrvTime_aa, 0:5GHz
 				pBuf->wTxRrvTime = cpu_to_le16((unsigned short)s_uGetTxRsvTime(pDevice, byPktType, cbFrameSize, wCurrentRate, bNeedACK));//0:OFDM
 			}
@@ -1138,6 +1142,7 @@ s_vGenerateTxParameter(
 			//Fill RsvTime
 			if (pvRrvTime) {
 				PSRrvTime_ab pBuf = (PSRrvTime_ab)pvRrvTime;
+
 				pBuf->wTxRrvTime = cpu_to_le16((unsigned short)s_uGetTxRsvTime(pDevice, PK_TYPE_11A, cbFrameSize, wCurrentRate, bNeedACK)); //0:OFDM
 			}
 		}
@@ -1146,6 +1151,7 @@ s_vGenerateTxParameter(
 			//Fill RsvTime
 			if (pvRrvTime) {
 				PSRrvTime_ab pBuf = (PSRrvTime_ab)pvRrvTime;
+
 				pBuf->wRTSTxRrvTime = cpu_to_le16((unsigned short)s_uGetRTSCTSRsvTime(pDevice, 0, byPktType, cbFrameSize, wCurrentRate));//0:RTSTxRrvTime_bb, 1:2.4GHz
 				pBuf->wTxRrvTime = cpu_to_le16((unsigned short)s_uGetTxRsvTime(pDevice, PK_TYPE_11B, cbFrameSize, wCurrentRate, bNeedACK));//1:CCK
 			}
@@ -1155,6 +1161,7 @@ s_vGenerateTxParameter(
 			//Fill RsvTime
 			if (pvRrvTime) {
 				PSRrvTime_ab pBuf = (PSRrvTime_ab)pvRrvTime;
+
 				pBuf->wTxRrvTime = cpu_to_le16((unsigned short)s_uGetTxRsvTime(pDevice, PK_TYPE_11B, cbFrameSize, wCurrentRate, bNeedACK)); //1:CCK
 			}
 		}
@@ -2025,6 +2032,7 @@ vGenerateMACHeader(
 
 	if (pDevice->bLongHeader) {
 		PWLAN_80211HDR_A4 pMACA4Header  = (PWLAN_80211HDR_A4) pbyBufferAddr;
+
 		pMACHeader->wFrameCtl |= (FC_TODS | FC_FROMDS);
 		memcpy(pMACA4Header->abyAddr4, pDevice->abyBSSID, WLAN_ADDR_LEN);
 	}
diff --git a/drivers/staging/vt6655/vntwifi.c b/drivers/staging/vt6655/vntwifi.c
index 8241e6b..0ee1e8a 100644
--- a/drivers/staging/vt6655/vntwifi.c
+++ b/drivers/staging/vt6655/vntwifi.c
@@ -128,6 +128,7 @@ VNTWIFIpGetCurrentSSID(
 )
 {
 	PSMgmtObject        pMgmt = (PSMgmtObject)pMgmtHandle;
+
 	return (PWLAN_IE_SSID) pMgmt->abyCurrSSID;
 }
 
@@ -151,6 +152,7 @@ VNTWIFIpGetCurrentChannel(
 )
 {
 	PSMgmtObject        pMgmt = (PSMgmtObject)pMgmtHandle;
+
 	if (pMgmtHandle != NULL)
 		return pMgmt->uCurrChannel;
 
@@ -177,6 +179,7 @@ VNTWIFIwGetAssocID(
 )
 {
 	PSMgmtObject        pMgmt = (PSMgmtObject)pMgmtHandle;
+
 	return pMgmt->wCurrAID;
 }
 
diff --git a/drivers/staging/vt6655/wcmd.c b/drivers/staging/vt6655/wcmd.c
index fc605f22..8196321 100644
--- a/drivers/staging/vt6655/wcmd.c
+++ b/drivers/staging/vt6655/wcmd.c
@@ -990,6 +990,7 @@ BSSvSecondTxData(
 {
 	PSDevice        pDevice = (PSDevice)hDeviceContext;
 	PSMgmtObject  pMgmt = &(pDevice->sMgmtObj);
+
 	pDevice->nTxDataTimeCout++;
 
 	if (pDevice->nTxDataTimeCout < 4)     //don't tx data if timer less than 40s
diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index 0b6f1e9..fa72915 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -1649,6 +1649,7 @@ s_vMgrRxDeauthentication(
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 			{
 				union iwreq_data  wrqu;
+
 				memset(&wrqu, 0, sizeof(wrqu));
 				wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 				PRINT_K("wireless_send_event--->SIOCGIWAP(disauthen)\n");
@@ -2541,6 +2542,7 @@ vMgrJoinBSSBegin(
 			// This should only works for WPA2 BSS, and WPA2 BSS check must be done before.
 			if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2) {
 				bool bResult = bAdd_PMKID_Candidate((void *)pDevice, pMgmt->abyCurrBSSID, &pCurr->sRSNCapObj);
+
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bAdd_PMKID_Candidate: 1(%d)\n", bResult);
 				if (!bResult) {
 					vFlush_PMKID_Candidate((void *)pDevice);
diff --git a/drivers/staging/vt6655/wpa.c b/drivers/staging/vt6655/wpa.c
index 9be59c2..505c895 100644
--- a/drivers/staging/vt6655/wpa.c
+++ b/drivers/staging/vt6655/wpa.c
@@ -73,6 +73,7 @@ WPA_ClearRSN(
 )
 {
 	int ii;
+
 	pBSSList->byGKType = WPA_TKIP;
 	for (ii = 0; ii < 4; ii++)
 		pBSSList->abyPKType[ii] = WPA_TKIP;
diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
index 0814bfd..fe45f2b 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -767,6 +767,7 @@ static int wpa_set_associate(PSDevice pDevice,
 /*******search if ap_scan=2 ,which is associating request in hidden ssid mode ****/
 	{
 		PKnownBSS       pCurr = NULL;
+
 		pCurr = BSSpSearchBSSList(pDevice,
 					  pMgmt->abyDesireBSSID,
 					  pMgmt->abyDesireSSID,
-- 
1.8.5.5

