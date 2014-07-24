Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935202AbaGXXKD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:10:03 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:57638 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759788AbaGXXHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:07:06 -0400
X-Originating-IP: 109.10.215.15
From: Guillaume Clement <gclement@baobob.org>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Guillaume Clement <gclement@baobob.org>
Subject: [PATCH 04/14] staging: vt6655: fix function braces not on the proper line
Date: Fri, 25 Jul 2014 01:06:18 +0200
Message-Id: <1406243188-13413-5-git-send-email-gclement@baobob.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1406243188-13413-1-git-send-email-gclement@baobob.org>
References: <1406243188-13413-1-git-send-email-gclement@baobob.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function braces should be on a separate line. Reported by checkpatch.

Signed-off-by: Guillaume Clement <gclement@baobob.org>
---
 drivers/staging/vt6655/device_main.c | 90 ++++++++++++++++++++++++------------
 drivers/staging/vt6655/rxtx.c        |  6 ++-
 2 files changed, 64 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index f1b4d58..8c035d5 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -743,7 +743,8 @@ MACvStart(pDevice->PortOffset);
 netif_stop_queue(pDevice->dev);
 }
 
-static void device_init_diversity_timer(PSDevice pDevice) {
+static void device_init_diversity_timer(PSDevice pDevice)
+{
 	init_timer(&pDevice->TimerSQ3Tmax1);
 	pDevice->TimerSQ3Tmax1.data = (unsigned long) pDevice;
 	pDevice->TimerSQ3Tmax1.function = (TimerFunction)TimerSQ3CallBack;
@@ -999,7 +1000,8 @@ static void vt6655_init_info(struct pci_dev *pcid, PSDevice *ppDevice,
 	spin_lock_init(&((*ppDevice)->lock));
 }
 
-static bool device_get_pci_info(PSDevice pDevice, struct pci_dev *pcid) {
+static bool device_get_pci_info(PSDevice pDevice, struct pci_dev *pcid)
+{
 	u16 pci_cmd;
 	u8  b;
 	unsigned int cis_addr;
@@ -1046,7 +1048,8 @@ static bool device_get_pci_info(PSDevice pDevice, struct pci_dev *pcid) {
 	return true;
 }
 
-static void device_free_info(PSDevice pDevice) {
+static void device_free_info(PSDevice pDevice)
+{
 	PSDevice         ptr;
 	struct net_device *dev = pDevice->dev;
 
@@ -1090,7 +1093,8 @@ static void device_free_info(PSDevice pDevice) {
 		free_netdev(dev);
 }
 
-static bool device_init_rings(PSDevice pDevice) {
+static bool device_init_rings(PSDevice pDevice)
+{
 	void *vir_pool;
 
 	/*allocate all RD/TD rings a single pool*/
@@ -1165,7 +1169,8 @@ static bool device_init_rings(PSDevice pDevice) {
 	return true;
 }
 
-static void device_free_rings(PSDevice pDevice) {
+static void device_free_rings(PSDevice pDevice)
+{
 	pci_free_consistent(pDevice->pcid,
 			    pDevice->sOpts.nRxDescs0 * sizeof(SRxDesc) +
 			    pDevice->sOpts.nRxDescs1 * sizeof(SRxDesc) +
@@ -1185,7 +1190,8 @@ static void device_free_rings(PSDevice pDevice) {
 			);
 }
 
-static void device_init_rd0_ring(PSDevice pDevice) {
+static void device_init_rd0_ring(PSDevice pDevice)
+{
 	int i;
 	dma_addr_t      curr = pDevice->rd0_pool_dma;
 	PSRxDesc        pDesc;
@@ -1209,7 +1215,8 @@ static void device_init_rd0_ring(PSDevice pDevice) {
 	pDevice->pCurrRD[0] = &(pDevice->aRD0Ring[0]);
 }
 
-static void device_init_rd1_ring(PSDevice pDevice) {
+static void device_init_rd1_ring(PSDevice pDevice)
+{
 	int i;
 	dma_addr_t      curr = pDevice->rd1_pool_dma;
 	PSRxDesc        pDesc;
@@ -1233,7 +1240,8 @@ static void device_init_rd1_ring(PSDevice pDevice) {
 	pDevice->pCurrRD[1] = &(pDevice->aRD1Ring[0]);
 }
 
-static void device_init_defrag_cb(PSDevice pDevice) {
+static void device_init_defrag_cb(PSDevice pDevice)
+{
 	int i;
 	PSDeFragControlBlock pDeF;
 
@@ -1249,7 +1257,8 @@ static void device_init_defrag_cb(PSDevice pDevice) {
 	pDevice->cbFreeDFCB = pDevice->cbDFCB;
 }
 
-static void device_free_rd0_ring(PSDevice pDevice) {
+static void device_free_rd0_ring(PSDevice pDevice)
+{
 	int i;
 
 	for (i = 0; i < pDevice->sOpts.nRxDescs0; i++) {
@@ -1265,7 +1274,8 @@ static void device_free_rd0_ring(PSDevice pDevice) {
 	}
 }
 
-static void device_free_rd1_ring(PSDevice pDevice) {
+static void device_free_rd1_ring(PSDevice pDevice)
+{
 	int i;
 
 	for (i = 0; i < pDevice->sOpts.nRxDescs1; i++) {
@@ -1281,7 +1291,8 @@ static void device_free_rd1_ring(PSDevice pDevice) {
 	}
 }
 
-static void device_free_frag_buf(PSDevice pDevice) {
+static void device_free_frag_buf(PSDevice pDevice)
+{
 	PSDeFragControlBlock pDeF;
 	int i;
 
@@ -1294,7 +1305,8 @@ static void device_free_frag_buf(PSDevice pDevice) {
 	}
 }
 
-static void device_init_td0_ring(PSDevice pDevice) {
+static void device_init_td0_ring(PSDevice pDevice)
+{
 	int i;
 	dma_addr_t  curr;
 	PSTxDesc        pDesc;
@@ -1318,7 +1330,8 @@ static void device_init_td0_ring(PSDevice pDevice) {
 	pDevice->apTailTD[0] = pDevice->apCurrTD[0] = &(pDevice->apTD0Rings[0]);
 }
 
-static void device_init_td1_ring(PSDevice pDevice) {
+static void device_init_td1_ring(PSDevice pDevice)
+{
 	int i;
 	dma_addr_t  curr;
 	PSTxDesc    pDesc;
@@ -1343,7 +1356,8 @@ static void device_init_td1_ring(PSDevice pDevice) {
 	pDevice->apTailTD[1] = pDevice->apCurrTD[1] = &(pDevice->apTD1Rings[0]);
 }
 
-static void device_free_td0_ring(PSDevice pDevice) {
+static void device_free_td0_ring(PSDevice pDevice)
+{
 	int i;
 
 	for (i = 0; i < pDevice->sOpts.nTxDescs[0]; i++) {
@@ -1361,7 +1375,8 @@ static void device_free_td0_ring(PSDevice pDevice) {
 	}
 }
 
-static void device_free_td1_ring(PSDevice pDevice) {
+static void device_free_td1_ring(PSDevice pDevice)
+{
 	int i;
 
 	for (i = 0; i < pDevice->sOpts.nTxDescs[1]; i++) {
@@ -1381,7 +1396,8 @@ static void device_free_td1_ring(PSDevice pDevice) {
 
 /*-----------------------------------------------------------------*/
 
-static int device_rx_srv(PSDevice pDevice, unsigned int uIdx) {
+static int device_rx_srv(PSDevice pDevice, unsigned int uIdx)
+{
 	PSRxDesc    pRD;
 	int works = 0;
 
@@ -1406,7 +1422,8 @@ static int device_rx_srv(PSDevice pDevice, unsigned int uIdx) {
 	return works;
 }
 
-static bool device_alloc_rx_buf(PSDevice pDevice, PSRxDesc pRD) {
+static bool device_alloc_rx_buf(PSDevice pDevice, PSRxDesc pRD)
+{
 	PDEVICE_RD_INFO pRDInfo = pRD->pRDInfo;
 
 	pRDInfo->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
@@ -1426,7 +1443,8 @@ static bool device_alloc_rx_buf(PSDevice pDevice, PSRxDesc pRD) {
 	return true;
 }
 
-bool device_alloc_frag_buf(PSDevice pDevice, PSDeFragControlBlock pDeF) {
+bool device_alloc_frag_buf(PSDevice pDevice, PSDeFragControlBlock pDeF)
+{
 	pDeF->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
 	if (pDeF->skb == NULL)
 		return false;
@@ -1436,7 +1454,8 @@ bool device_alloc_frag_buf(PSDevice pDevice, PSDeFragControlBlock pDeF) {
 	return true;
 }
 
-static int device_tx_srv(PSDevice pDevice, unsigned int uIdx) {
+static int device_tx_srv(PSDevice pDevice, unsigned int uIdx)
+{
 	PSTxDesc                 pTD;
 	bool bFull = false;
 	int                      works = 0;
@@ -1559,7 +1578,8 @@ static int device_tx_srv(PSDevice pDevice, unsigned int uIdx) {
 	return works;
 }
 
-static void device_error(PSDevice pDevice, unsigned short status) {
+static void device_error(PSDevice pDevice, unsigned short status)
+{
 	if (status & ISR_FETALERR) {
 		DBG_PRT(MSG_LEVEL_ERR, KERN_ERR
 			"%s: Hardware fatal error.\n",
@@ -1573,7 +1593,8 @@ static void device_error(PSDevice pDevice, unsigned short status) {
 	}
 }
 
-static void device_free_tx_buf(PSDevice pDevice, PSTxDesc pDesc) {
+static void device_free_tx_buf(PSDevice pDevice, PSTxDesc pDesc)
+{
 	PDEVICE_TD_INFO  pTDInfo = pDesc->pTDInfo;
 	struct sk_buff *skb = pTDInfo->skb;
 
@@ -1626,7 +1647,8 @@ static int MlmeThread(
 }
 #endif
 
-static int  device_open(struct net_device *dev) {
+static int  device_open(struct net_device *dev)
+{
 	PSDevice pDevice = (PSDevice)netdev_priv(dev);
 	int i;
 #ifdef WPA_SM_Transtatus
@@ -1724,7 +1746,8 @@ static int  device_open(struct net_device *dev) {
 	return 0;
 }
 
-static int  device_close(struct net_device *dev) {
+static int  device_close(struct net_device *dev)
+{
 	PSDevice  pDevice = (PSDevice)netdev_priv(dev);
 	PSMgmtObject     pMgmt = pDevice->pMgmt;
 	//PLICE_DEBUG->
@@ -1776,7 +1799,8 @@ static int  device_close(struct net_device *dev) {
 	return 0;
 }
 
-static int device_dma0_tx_80211(struct sk_buff *skb, struct net_device *dev) {
+static int device_dma0_tx_80211(struct sk_buff *skb, struct net_device *dev)
+{
 	PSDevice pDevice = netdev_priv(dev);
 	unsigned char *pbMPDU;
 	unsigned int cbMPDULen = 0;
@@ -1807,7 +1831,8 @@ static int device_dma0_tx_80211(struct sk_buff *skb, struct net_device *dev) {
 	return 0;
 }
 
-bool device_dma0_xmit(PSDevice pDevice, struct sk_buff *skb, unsigned int uNodeIndex) {
+bool device_dma0_xmit(PSDevice pDevice, struct sk_buff *skb, unsigned int uNodeIndex)
+{
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 	PSTxDesc        pHeadTD, pLastTD;
 	unsigned int cbFrameBodySize;
@@ -1946,7 +1971,8 @@ bool device_dma0_xmit(PSDevice pDevice, struct sk_buff *skb, unsigned int uNodeI
 }
 
 //TYPE_AC0DMA data tx
-static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
+static int  device_xmit(struct sk_buff *skb, struct net_device *dev)
+{
 	PSDevice pDevice = netdev_priv(dev);
 
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
@@ -2298,7 +2324,8 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
 	return 0;
 }
 
-static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
+static  irqreturn_t  device_intr(int irq,  void *dev_instance)
+{
 	struct net_device *dev = dev_instance;
 	PSDevice     pDevice = (PSDevice)netdev_priv(dev);
 
@@ -2637,7 +2664,8 @@ error1:
 	return result;
 }
 
-static void device_set_multi(struct net_device *dev) {
+static void device_set_multi(struct net_device *dev)
+{
 	PSDevice         pDevice = (PSDevice)netdev_priv(dev);
 
 	PSMgmtObject     pMgmt = pDevice->pMgmt;
@@ -2682,13 +2710,15 @@ static void device_set_multi(struct net_device *dev) {
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pDevice->byRxMode = %x\n", pDevice->byRxMode);
 }
 
-static struct net_device_stats *device_get_stats(struct net_device *dev) {
+static struct net_device_stats *device_get_stats(struct net_device *dev)
+{
 	PSDevice pDevice = (PSDevice)netdev_priv(dev);
 
 	return &pDevice->stats;
 }
 
-static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
+static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
+{
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
 
 	struct iwreq *wrq = (struct iwreq *)rq;
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index d94798b..0d45aa0 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -2051,7 +2051,8 @@ vGenerateMACHeader(
 		pMACHeader->wFrameCtl |= FC_MOREFRAG;
 }
 
-CMD_STATUS csMgmt_xmit(PSDevice pDevice, PSTxMgmtPacket pPacket) {
+CMD_STATUS csMgmt_xmit(PSDevice pDevice, PSTxMgmtPacket pPacket)
+{
 	PSTxDesc        pFrstTD;
 	unsigned char byPktType;
 	unsigned char *pbyTxBufferAddr;
@@ -2337,7 +2338,8 @@ CMD_STATUS csMgmt_xmit(PSDevice pDevice, PSTxMgmtPacket pPacket) {
 	return CMD_STATUS_PENDING;
 }
 
-CMD_STATUS csBeacon_xmit(PSDevice pDevice, PSTxMgmtPacket pPacket) {
+CMD_STATUS csBeacon_xmit(PSDevice pDevice, PSTxMgmtPacket pPacket)
+{
 	unsigned char byPktType;
 	unsigned char *pbyBuffer = (unsigned char *)pDevice->tx_beacon_bufs;
 	unsigned int cbFrameSize = pPacket->cbMPDULen + WLAN_FCS_LEN;
-- 
1.8.5.5

