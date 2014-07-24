Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935187AbaGXXKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:10:00 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:46272 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759756AbaGXXHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:07:06 -0400
X-Originating-IP: 109.10.215.15
From: Guillaume Clement <gclement@baobob.org>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Guillaume Clement <gclement@baobob.org>
Subject: [PATCH 03/14] staging: vt6655: Remove spaces before quoted newlines
Date: Fri, 25 Jul 2014 01:06:17 +0200
Message-Id: <1406243188-13413-4-git-send-email-gclement@baobob.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1406243188-13413-1-git-send-email-gclement@baobob.org>
References: <1406243188-13413-1-git-send-email-gclement@baobob.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes several spaces added just before a newline in debug
strings, reported by checkpatch.

Signed-off-by: Guillaume Clement <gclement@baobob.org>
---
 drivers/staging/vt6655/card.c        |  2 +-
 drivers/staging/vt6655/device_main.c | 53 ++++++++++++-------------
 drivers/staging/vt6655/dpc.c         | 13 ++++---
 drivers/staging/vt6655/hostap.c      | 46 +++++++++++-----------
 drivers/staging/vt6655/iwctl.c       | 75 ++++++++++++++++++------------------
 drivers/staging/vt6655/key.c         | 14 +++----
 drivers/staging/vt6655/power.c       |  2 +-
 drivers/staging/vt6655/rxtx.c        |  2 +-
 drivers/staging/vt6655/wcmd.c        | 18 ++++-----
 drivers/staging/vt6655/wmgr.c        | 22 +++++------
 10 files changed, 125 insertions(+), 122 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index fdeb805..ac49fba 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -2090,6 +2090,6 @@ void CARDvUpdateNextTBTT(void __iomem *dwIoBase, QWORD qwTSF, unsigned short wBe
 	VNSvOutPortD(dwIoBase + MAC_REG_NEXTTBTT, LODWORD(qwTSF));
 	VNSvOutPortD(dwIoBase + MAC_REG_NEXTTBTT + 4, HIDWORD(qwTSF));
 	MACvRegBitsOn(dwIoBase, MAC_REG_TFTCTL, TFTCTL_TBTTSYNCEN);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Card:Update Next TBTT[%8xh:%8xh] \n",
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Card:Update Next TBTT[%8xh:%8xh]\n",
 		(unsigned int) HIDWORD(qwTSF), (unsigned int) LODWORD(qwTSF));
 }
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index b3b2ee6..f1b4d58 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -818,7 +818,7 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 	pDevice = (PSDevice) netdev_priv(dev);
 
 	if (dev == NULL) {
-		printk(KERN_ERR DEVICE_NAME ": allocate net device failed \n");
+		printk(KERN_ERR DEVICE_NAME ": allocate net device failed\n");
 		return -ENOMEM;
 	}
 
@@ -967,11 +967,11 @@ static void device_print_info(PSDevice pDevice)
 	DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "%s: MAC=%pM", dev->name, dev->dev_addr);
 #ifdef IO_MAP
 	DBG_PRT(MSG_LEVEL_INFO, KERN_INFO " IO=0x%lx  ", (unsigned long)pDevice->ioaddr);
-	DBG_PRT(MSG_LEVEL_INFO, KERN_INFO " IRQ=%d \n", pDevice->dev->irq);
+	DBG_PRT(MSG_LEVEL_INFO, KERN_INFO " IRQ=%d\n", pDevice->dev->irq);
 #else
 	DBG_PRT(MSG_LEVEL_INFO, KERN_INFO " IO=0x%lx Mem=0x%lx ",
 		(unsigned long)pDevice->ioaddr, (unsigned long)pDevice->PortOffset);
-	DBG_PRT(MSG_LEVEL_INFO, KERN_INFO " IRQ=%d \n", pDevice->dev->irq);
+	DBG_PRT(MSG_LEVEL_INFO, KERN_INFO " IRQ=%d\n", pDevice->dev->irq);
 #endif
 }
 
@@ -1498,7 +1498,7 @@ static int device_tx_srv(PSDevice pDevice, unsigned int uIdx) {
 
 			if ((pTD->pTDInfo->byFlags & TD_FLAGS_PRIV_SKB) != 0) {
 				if (pDevice->bEnableHostapd) {
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "tx call back netif.. \n");
+					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "tx call back netif..\n");
 					skb = pTD->pTDInfo->skb;
 					skb->dev = pDevice->apdev;
 					skb_reset_mac_header(skb);
@@ -1720,7 +1720,7 @@ static int  device_open(struct net_device *dev) {
 	}
 	pDevice->flags |= DEVICE_FLAGS_OPENED;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "device_open success.. \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "device_open success..\n");
 	return 0;
 }
 
@@ -1772,7 +1772,7 @@ static int  device_close(struct net_device *dev) {
 	//2008-0714-01<Add>by chester
 	device_release_WPADEV(pDevice);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "device_close.. \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "device_close..\n");
 	return 0;
 }
 
@@ -1879,7 +1879,7 @@ bool device_dma0_xmit(PSDevice pDevice, struct sk_buff *skb, unsigned int uNodeI
 	else
 		pDevice->byPreambleType = PREAMBLE_LONG;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dma0: pDevice->wCurrentRate = %d \n", pDevice->wCurrentRate);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dma0: pDevice->wCurrentRate = %d\n", pDevice->wCurrentRate);
 
 	if (pDevice->wCurrentRate <= RATE_11M) {
 		byPktType = PK_TYPE_11B;
@@ -2022,7 +2022,7 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
 		}
 
 		if (!bNodeExist) {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG "Unknown STA not found in node DB \n");
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG "Unknown STA not found in node DB\n");
 			dev_kfree_skb_irq(skb);
 			spin_unlock_irq(&pDevice->lock);
 			return 0;
@@ -2060,9 +2060,9 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
 				}
 			} else if (pDevice->pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) {
 				pbyBSSID = pDevice->sTxEthHeader.abyDstAddr;  //TO_DS = 0 and FROM_DS = 0 --> 802.11 MAC Address1
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG "IBSS Serach Key: \n");
+				DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG "IBSS Serach Key:\n");
 				for (ii = 0; ii < 6; ii++)
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG "%x \n", *(pbyBSSID+ii));
+					DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG "%x\n", *(pbyBSSID+ii));
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG "\n");
 
 				// get pairwise key
@@ -2342,7 +2342,7 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
 		MACvWriteISR(pDevice->PortOffset, pDevice->dwIsr);
 
 		if (pDevice->dwIsr & ISR_FETALERR) {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " ISR_FETALERR \n");
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " ISR_FETALERR\n");
 			VNSvOutPortB(pDevice->PortOffset + MAC_REG_SOFTPWRCTL, 0);
 			VNSvOutPortW(pDevice->PortOffset + MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPECTI);
 			device_error(pDevice, pDevice->dwIsr);
@@ -2768,13 +2768,13 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 
 		// Set desired station name
 	case SIOCSIWNICKN:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWNICKN \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWNICKN\n");
 		rc = -EOPNOTSUPP;
 		break;
 
 		// Get current station name
 	case SIOCGIWNICKN:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWNICKN \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWNICKN\n");
 		rc = -EOPNOTSUPP;
 		break;
 
@@ -2870,12 +2870,12 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 
 		// Get the current Tx-Power
 	case SIOCGIWTXPOW:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWTXPOW \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWTXPOW\n");
 		rc = -EOPNOTSUPP;
 		break;
 
 	case SIOCSIWTXPOW:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWTXPOW \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWTXPOW\n");
 		rc = -EOPNOTSUPP;
 		break;
 
@@ -2918,7 +2918,7 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 		break;
 
 	case SIOCSIWSENS:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWSENS \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWSENS\n");
 		rc = -EOPNOTSUPP;
 		break;
 
@@ -2942,49 +2942,50 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 	// Set the spy list
 	case SIOCSIWSPY:
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWSPY \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWSPY\n");
 		rc = -EOPNOTSUPP;
 		break;
 
 		// Get the spy list
 	case SIOCGIWSPY:
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWSPY \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWSPY\n");
 		rc = -EOPNOTSUPP;
 		break;
 
 #endif // WIRELESS_SPY
 
 	case SIOCGIWPRIV:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWPRIV \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWPRIV\n");
 		rc = -EOPNOTSUPP;
 		break;
 
 //2008-0409-07, <Add> by Einsn Liu
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 	case SIOCSIWAUTH:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWAUTH \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWAUTH\n");
 		rc = iwctl_siwauth(dev, NULL, &(wrq->u.param), NULL);
 		break;
 
 	case SIOCGIWAUTH:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWAUTH \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWAUTH\n");
 		rc = iwctl_giwauth(dev, NULL, &(wrq->u.param), NULL);
 		break;
 
 	case SIOCSIWGENIE:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWGENIE \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWGENIE\n");
 		rc = iwctl_siwgenie(dev, NULL, &(wrq->u.data), wrq->u.data.pointer);
 		break;
 
 	case SIOCGIWGENIE:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWGENIE \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWGENIE\n");
 		rc = iwctl_giwgenie(dev, NULL, &(wrq->u.data), wrq->u.data.pointer);
 		break;
 
 	case SIOCSIWENCODEEXT: {
 		char extra[sizeof(struct iw_encode_ext)+MAX_KEY_LEN+1];
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWENCODEEXT \n");
+
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWENCODEEXT\n");
 		if (wrq->u.encoding.pointer) {
 			memset(extra, 0, sizeof(struct iw_encode_ext)+MAX_KEY_LEN + 1);
 			if (wrq->u.encoding.length > (sizeof(struct iw_encode_ext) + MAX_KEY_LEN)) {
@@ -3004,12 +3005,12 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 	break;
 
 	case SIOCGIWENCODEEXT:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWENCODEEXT \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWENCODEEXT\n");
 		rc = iwctl_giwencodeext(dev, NULL, &(wrq->u.encoding), NULL);
 		break;
 
 	case SIOCSIWMLME:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWMLME \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWMLME\n");
 		rc = iwctl_siwmlme(dev, NULL, &(wrq->u.data), wrq->u.data.pointer);
 		break;
 
diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index 5b2ace2..ac588cb 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -341,7 +341,7 @@ device_receive_frame(
 	// Min (ACK): 10HD +4CRC + 2Padding + 4Len + 8TSF + 4RSR
 	if ((FrameSize > 2364) || (FrameSize <= 32)) {
 		// Frame Size error drop this packet.
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "---------- WRONG Length 1 \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "---------- WRONG Length 1\n");
 		return false;
 	}
 
@@ -359,7 +359,7 @@ device_receive_frame(
 
 	if ((FrameSize > 2346)|(FrameSize < 14)) { // Max: 2312Payload + 30HD +4CRC
 		// Min: 14 bytes ACK
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "---------- WRONG Length 2 \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "---------- WRONG Length 2\n");
 		return false;
 	}
 //PLICE_DEBUG->
@@ -671,7 +671,7 @@ device_receive_frame(
 		wEtherType = (skb->data[cbIVOffset + 4 + 24 + 6] << 8) |
 			skb->data[cbIVOffset + 4 + 24 + 6 + 1];
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wEtherType = %04x \n", wEtherType);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wEtherType = %04x\n", wEtherType);
 		if (wEtherType == ETH_P_PAE) {
 			skb->dev = pDevice->apdev;
 
@@ -1179,7 +1179,8 @@ static bool s_bHostWepRxEncryption(
 
 	if (byDecMode == KEY_CTL_WEP) {
 		// handle WEP
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "byDecMode == KEY_CTL_WEP \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "byDecMode == KEY_CTL_WEP\n");
+
 		if ((pDevice->byLocalID <= REV_ID_VT3253_A1) ||
 		    (((PSKeyTable)(pKey->pvKeyTable))->bSoftWEP == true) ||
 		    !bOnFly) {
@@ -1218,7 +1219,7 @@ static bool s_bHostWepRxEncryption(
 				// Software TKIP
 				// 1. 3253 A
 				// 2. NotOnFly
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "soft KEY_CTL_TKIP \n");
+				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "soft KEY_CTL_TKIP\n");
 				pMACHeader = (PS802_11Header)(pbyFrame);
 				TKIPvMixKey(pKey->abyKey, pMACHeader->abyAddr2, *pwRxTSC15_0, *pdwRxTSC47_16, pDevice->abyPRNG);
 				rc4_init(&pDevice->SBox, pDevice->abyPRNG, TKIP_KEY_LEN);
@@ -1280,7 +1281,7 @@ static bool s_bAPModeRxData(
 
 			// if any node in PS mode, buffer packet until DTIM.
 			if (skbcpy == NULL) {
-				DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "relay multicast no skb available \n");
+				DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "relay multicast no skb available\n");
 			} else {
 				skbcpy->dev = pDevice->dev;
 				skbcpy->len = FrameSize;
diff --git a/drivers/staging/vt6655/hostap.c b/drivers/staging/vt6655/hostap.c
index 4cf85f3..f105c2a 100644
--- a/drivers/staging/vt6655/hostap.c
+++ b/drivers/staging/vt6655/hostap.c
@@ -256,8 +256,8 @@ static int hostap_add_sta(PSDevice pDevice,
 
 	pMgmt->sNodeDBTable[uNodeIndex].ulLastRxJiffer = jiffies;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Add STA AID= %d \n", pMgmt->sNodeDBTable[uNodeIndex].wAID);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "MAC=%2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X \n",
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Add STA AID= %d\n", pMgmt->sNodeDBTable[uNodeIndex].wAID);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "MAC=%2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X\n",
 		param->sta_addr[0],
 		param->sta_addr[1],
 		param->sta_addr[2],
@@ -265,7 +265,7 @@ static int hostap_add_sta(PSDevice pDevice,
 		param->sta_addr[4],
 		param->sta_addr[5]
 		);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Max Support rate = %d \n",
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Max Support rate = %d\n",
 		pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate);
 
 	return 0;
@@ -323,7 +323,7 @@ static int hostap_set_flags_sta(PSDevice pDevice,
 	if (BSSDBbIsSTAInNodeDB(pMgmt, param->sta_addr, &uNodeIndex)) {
 		pMgmt->sNodeDBTable[uNodeIndex].dwFlags |= param->u.set_flags_sta.flags_or;
 		pMgmt->sNodeDBTable[uNodeIndex].dwFlags &= param->u.set_flags_sta.flags_and;
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " dwFlags = %x \n",
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " dwFlags = %x\n",
 			(unsigned int)pMgmt->sNodeDBTable[uNodeIndex].dwFlags);
 	} else {
 		return -ENOENT;
@@ -362,7 +362,7 @@ static int hostap_set_generic_element(PSDevice pDevice,
 	// disable wpa
 	if (pMgmt->wWPAIELen == 0) {
 		pMgmt->eAuthenMode = WMAC_AUTH_OPEN;
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " No WPAIE, Disable WPA \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " No WPAIE, Disable WPA\n");
 	} else  {
 		// enable wpa
 		if ((pMgmt->abyWPAIE[0] == WLAN_EID_RSN_WPA) ||
@@ -447,8 +447,8 @@ static int hostap_set_encryption(PSDevice pDevice,
 			return -EINVAL;
 		}
 	}
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " hostap_set_encryption: sta_index %d \n", iNodeIndex);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " hostap_set_encryption: alg %d \n", param->u.crypt.alg);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " hostap_set_encryption: sta_index %d\n", iNodeIndex);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " hostap_set_encryption: alg %d\n", param->u.crypt.alg);
 
 	if (param->u.crypt.alg == WPA_ALG_NONE) {
 		if (pMgmt->sNodeDBTable[iNodeIndex].bOnFly) {
@@ -456,7 +456,7 @@ static int hostap_set_encryption(PSDevice pDevice,
 					  param->sta_addr,
 					  pMgmt->sNodeDBTable[iNodeIndex].dwKeyIndex,
 					  pDevice->PortOffset)) {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "KeybRemoveKey fail \n");
+				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "KeybRemoveKey fail\n");
 			}
 			pMgmt->sNodeDBTable[iNodeIndex].bOnFly = false;
 		}
@@ -601,10 +601,10 @@ static int hostap_set_encryption(PSDevice pDevice,
 		MACvSetDefaultKeyCtl(pDevice->PortOffset, wKeyCtl, MAX_KEY_TABLE-1, pDevice->byLocalID);
 	}
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " Set key sta_index= %d \n", iNodeIndex);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " tx_index=%d len=%d \n", param->u.crypt.idx,
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " Set key sta_index= %d\n", iNodeIndex);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " tx_index=%d len=%d\n", param->u.crypt.idx,
 		param->u.crypt.key_len);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " key=%x-%x-%x-%x-%x-xxxxx \n",
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " key=%x-%x-%x-%x-%x-xxxxx\n",
 		pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[0],
 		pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[1],
 		pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[2],
@@ -696,62 +696,62 @@ int vt6655_hostap_ioctl(PSDevice pDevice, struct iw_point *p)
 
 	switch (param->cmd) {
 	case VIAWGET_HOSTAPD_SET_ENCRYPTION:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_SET_ENCRYPTION \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_SET_ENCRYPTION\n");
 		spin_lock_irq(&pDevice->lock);
 		ret = hostap_set_encryption(pDevice, param, p->length);
 		spin_unlock_irq(&pDevice->lock);
 		break;
 	case VIAWGET_HOSTAPD_GET_ENCRYPTION:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_GET_ENCRYPTION \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_GET_ENCRYPTION\n");
 		spin_lock_irq(&pDevice->lock);
 		ret = hostap_get_encryption(pDevice, param, p->length);
 		spin_unlock_irq(&pDevice->lock);
 		break;
 	case VIAWGET_HOSTAPD_SET_ASSOC_AP_ADDR:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_SET_ASSOC_AP_ADDR \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_SET_ASSOC_AP_ADDR\n");
 		ret = -EOPNOTSUPP;
 		goto out;
 	case VIAWGET_HOSTAPD_FLUSH:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_FLUSH \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_FLUSH\n");
 		spin_lock_irq(&pDevice->lock);
 		hostap_flush_sta(pDevice);
 		spin_unlock_irq(&pDevice->lock);
 		break;
 	case VIAWGET_HOSTAPD_ADD_STA:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_ADD_STA \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_ADD_STA\n");
 		spin_lock_irq(&pDevice->lock);
 		ret = hostap_add_sta(pDevice, param);
 		spin_unlock_irq(&pDevice->lock);
 		break;
 	case VIAWGET_HOSTAPD_REMOVE_STA:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_REMOVE_STA \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_REMOVE_STA\n");
 		spin_lock_irq(&pDevice->lock);
 		ret = hostap_remove_sta(pDevice, param);
 		spin_unlock_irq(&pDevice->lock);
 		break;
 	case VIAWGET_HOSTAPD_GET_INFO_STA:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_GET_INFO_STA \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_GET_INFO_STA\n");
 		ret = hostap_get_info_sta(pDevice, param);
 		ap_ioctl = 1;
 		break;
 	case VIAWGET_HOSTAPD_SET_FLAGS_STA:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_SET_FLAGS_STA \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_SET_FLAGS_STA\n");
 		ret = hostap_set_flags_sta(pDevice, param);
 		break;
 	case VIAWGET_HOSTAPD_MLME:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_MLME \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_MLME\n");
 		ret = -EOPNOTSUPP;
 		goto out;
 	case VIAWGET_HOSTAPD_SET_GENERIC_ELEMENT:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_SET_GENERIC_ELEMENT \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_SET_GENERIC_ELEMENT\n");
 		ret = hostap_set_generic_element(pDevice, param);
 		break;
 	case VIAWGET_HOSTAPD_SCAN_REQ:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_SCAN_REQ \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_SCAN_REQ\n");
 		ret = -EOPNOTSUPP;
 		goto out;
 	case VIAWGET_HOSTAPD_STA_CLEAR_STATS:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_STA_CLEAR_STATS \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_STA_CLEAR_STATS\n");
 		ret = -EOPNOTSUPP;
 		goto out;
 	default:
diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index d449fcb1..06ddb85 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -108,7 +108,7 @@ static int iwctl_commit(struct net_device *dev,
 			void *wrq,
 			char *extra)
 {
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWCOMMIT \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWCOMMIT\n");
 
 	return 0;
 }
@@ -140,7 +140,7 @@ static int iwctl_siwscan(struct net_device *dev,
 	unsigned char abyScanSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
 	PWLAN_IE_SSID pItemSSID = NULL;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWSCAN \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWSCAN\n");
 
 	if (pDevice->byReAssocCount > 0) {   //reject scan when re-associating!
 //send scan event to wpa_Supplicant
@@ -210,7 +210,7 @@ static int iwctl_giwscan(struct net_device *dev,
 	long ldBm;
 	char buf[MAX_WPA_IE_LEN * 2 + 30];
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWSCAN \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWSCAN\n");
 
 	if (pMgmt->eScanState ==  WMAC_IS_SCANNING) {
 		// In scanning..
@@ -353,7 +353,7 @@ int iwctl_siwfreq(struct net_device *dev,
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
 	int rc = 0;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWFREQ \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWFREQ\n");
 
 	// If setting by frequency, convert to a channel
 	if ((wrq->e == 1) &&
@@ -401,7 +401,7 @@ int iwctl_giwfreq(struct net_device *dev,
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
 	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWFREQ \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWFREQ\n");
 
 #ifdef WEXT_USECHANNELS
 	wrq->m = (int)pMgmt->uCurrChannel;
@@ -433,10 +433,10 @@ int iwctl_siwmode(struct net_device *dev,
 	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 	int rc = 0;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWMODE \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWMODE\n");
 
 	if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP && pDevice->bEnableHostapd) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Can't set operation mode, hostapd is running \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Can't set operation mode, hostapd is running\n");
 		return rc;
 	}
 
@@ -448,7 +448,7 @@ int iwctl_siwmode(struct net_device *dev,
 				pDevice->bCommit = true;
 
 		}
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set mode to ad-hoc \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set mode to ad-hoc\n");
 		break;
 	case IW_MODE_AUTO:
 	case IW_MODE_INFRA:
@@ -458,7 +458,7 @@ int iwctl_siwmode(struct net_device *dev,
 				pDevice->bCommit = true;
 
 		}
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set mode to infrastructure \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set mode to infrastructure\n");
 		break;
 	case IW_MODE_MASTER:
 
@@ -472,7 +472,7 @@ int iwctl_siwmode(struct net_device *dev,
 				pDevice->bCommit = true;
 
 		}
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set mode to Access Point \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set mode to Access Point\n");
 		break;
 
 	case IW_MODE_REPEAT:
@@ -498,7 +498,7 @@ int iwctl_giwmode(struct net_device *dev,
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
 	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWMODE \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWMODE\n");
 	// If not managed, assume it's ad-hoc
 	switch (pMgmt->eConfigMode) {
 	case WMAC_CONFIG_ESS_STA:
@@ -533,7 +533,7 @@ int iwctl_giwrange(struct net_device *dev,
 	int i, k;
 	unsigned char abySupportedRates[13] = {0x02, 0x04, 0x0B, 0x16, 0x0c, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C, 0x90};
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRANGE \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRANGE\n");
 	if (wrq->pointer) {
 		wrq->length = sizeof(struct iw_range);
 		memset(range, 0, sizeof(struct iw_range));
@@ -640,7 +640,7 @@ int iwctl_siwap(struct net_device *dev,
 	int rc = 0;
 	unsigned char ZeroBSSID[WLAN_BSSID_LEN] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWAP \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWAP\n");
 	if (pMgmt->eScanState ==  WMAC_IS_SCANNING) {
 		// In scanning..
 		printk("SIOCSIWAP(??)-->In scanning...\n");
@@ -697,7 +697,7 @@ int iwctl_giwap(struct net_device *dev,
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
 	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWAP \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWAP\n");
 
 	memcpy(wrq->sa_data, pMgmt->abyCurrBSSID, 6);
 	//2008-0410,<Modify> by Einsn Liu
@@ -800,7 +800,7 @@ int iwctl_siwessid(struct net_device *dev,
 	//2008-0409-05, <Add> by Einsn Liu
 	unsigned char len;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWESSID \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWESSID\n");
 	pDevice->fWPA_Authened = false;
 	if (pMgmt->eScanState ==  WMAC_IS_SCANNING) {
 		// In scanning..
@@ -811,7 +811,7 @@ int iwctl_siwessid(struct net_device *dev,
 		// Just send an empty SSID list
 		memset(pMgmt->abyDesireSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
 		memset(pMgmt->abyDesireBSSID, 0xFF, 6);
-		PRINT_K("set essid to 'any' \n");
+		PRINT_K("set essid to 'any'\n");
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 		return 0;
 #endif
@@ -827,7 +827,7 @@ int iwctl_siwessid(struct net_device *dev,
 				pItemSSID->len = wrq->length - 1;
 		} else
 			pItemSSID->len = wrq->length;
-		printk("set essid to %s \n", pItemSSID->abySSID);
+		printk("set essid to %s\n", pItemSSID->abySSID);
 		//2008-0409-05, <Add> by Einsn Liu
 		len = (pItemSSID->len > ((PWLAN_IE_SSID)pMgmt->abyCurrSSID)->len) ? pItemSSID->len : ((PWLAN_IE_SSID)pMgmt->abyCurrSSID)->len;
 		if ((pDevice->bLinkPass == true) &&
@@ -885,7 +885,7 @@ int iwctl_siwessid(struct net_device *dev,
 		}
 #endif
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set essid = %s \n", pItemSSID->abySSID);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set essid = %s\n", pItemSSID->abySSID);
 	}
 
 	if (pDevice->flags & DEVICE_FLAGS_OPENED)
@@ -907,7 +907,7 @@ int iwctl_giwessid(struct net_device *dev,
 	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 	PWLAN_IE_SSID       pItemSSID;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWESSID \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWESSID\n");
 
 	// Note : if wrq->u.data.flags != 0, we should
 	// get the relevant SSID from the SSID list...
@@ -939,7 +939,7 @@ int iwctl_siwrate(struct net_device *dev,
 	int	i;
 	unsigned char abySupportedRates[13] = {0x02, 0x04, 0x0B, 0x16, 0x0c, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C, 0x90};
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWRATE \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWRATE\n");
 	if (!(pDevice->flags & DEVICE_FLAGS_OPENED)) {
 		rc = -EINVAL;
 		return rc;
@@ -993,7 +993,7 @@ int iwctl_siwrate(struct net_device *dev,
 			pDevice->uConnectionRate = 3;
 		} else {
 			pDevice->uConnectionRate = brate;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Fixed to Rate %d \n", pDevice->uConnectionRate);
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Fixed to Rate %d\n", pDevice->uConnectionRate);
 		}
 
 	} else {
@@ -1019,7 +1019,7 @@ int iwctl_giwrate(struct net_device *dev,
 //Mark the unnecessary sentences.
 //    PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRATE \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRATE\n");
 	{
 		unsigned char abySupportedRates[13] = {0x02, 0x04, 0x0B, 0x16, 0x0c, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C, 0x90};
 		int brate = 0;
@@ -1062,7 +1062,7 @@ int iwctl_siwrts(struct net_device *dev,
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
 	int rc = 0;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWRTS \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWRTS\n");
 
 	{
 		int rthr = wrq->value;
@@ -1090,7 +1090,7 @@ int iwctl_giwrts(struct net_device *dev,
 {
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRTS \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRTS\n");
 	wrq->value = pDevice->wRTSThreshold;
 	wrq->disabled = (wrq->value >= 2312);
 	wrq->fixed = 1;
@@ -1111,7 +1111,7 @@ int iwctl_siwfrag(struct net_device *dev,
 	int rc = 0;
 	int fthr = wrq->value;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWFRAG \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWFRAG\n");
 
 	if (wrq->disabled)
 		fthr = 2312;
@@ -1136,7 +1136,7 @@ int iwctl_giwfrag(struct net_device *dev,
 {
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWFRAG \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWFRAG\n");
 	wrq->value = pDevice->wFragmentationThreshold;
 	wrq->disabled = (wrq->value >= 2312);
 	wrq->fixed = 1;
@@ -1155,7 +1155,7 @@ int iwctl_siwretry(struct net_device *dev,
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
 	int rc = 0;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWRETRY \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWRETRY\n");
 
 	if (wrq->disabled) {
 		rc = -EINVAL;
@@ -1188,7 +1188,8 @@ int iwctl_giwretry(struct net_device *dev,
 		   char *extra)
 {
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRETRY \n");
+
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRETRY\n");
 	wrq->disabled = 0;      // Can't be disabled
 
 	// Note : by default, display the min retry number
@@ -1233,7 +1234,7 @@ int iwctl_siwencode(struct net_device *dev,
 
 	PSKeyTable pkeytab;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWENCODE \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWENCODE\n");
 
 	if ((wrq->flags & IW_ENCODE_DISABLED) == 0) {
 		//Not disable encryption
@@ -1413,7 +1414,7 @@ int iwctl_siwpower(struct net_device *dev,
 	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 	int rc = 0;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER\n");
 
 	if (!(pDevice->flags & DEVICE_FLAGS_OPENED)) {
 		rc = -EINVAL;
@@ -1435,14 +1436,14 @@ int iwctl_siwpower(struct net_device *dev,
 	}
 	switch (wrq->flags & IW_POWER_MODE) {
 	case IW_POWER_UNICAST_R:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER: IW_POWER_UNICAST_R \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER: IW_POWER_UNICAST_R\n");
 		rc = -EINVAL;
 		break;
 	case IW_POWER_ALL_R:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER: IW_POWER_ALL_R \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER: IW_POWER_ALL_R\n");
 		rc = -EINVAL;
 	case IW_POWER_ON:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER: IW_POWER_ON \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER: IW_POWER_ON\n");
 		break;
 	default:
 		rc = -EINVAL;
@@ -1463,7 +1464,7 @@ int iwctl_giwpower(struct net_device *dev,
 	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 	int mode = pDevice->ePSMode;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWPOWER \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWPOWER\n");
 
 	wrq->disabled = (mode == WMAC_POWER_CAM);
 	if (wrq->disabled)
@@ -1492,7 +1493,7 @@ int iwctl_giwsens(struct net_device *dev,
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
 	long ldBm;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWSENS \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWSENS\n");
 	if (pDevice->bLinkPass == true) {
 		RFvRSSITodBm(pDevice, (unsigned char)(pDevice->uCurrRSSI), &ldBm);
 		wrq->value = ldBm;
@@ -1519,7 +1520,7 @@ int iwctl_siwauth(struct net_device *dev,
 	static int wpa_version = 0;  //must be static to save the last value,einsn liu
 	static int pairwise = 0;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWAUTH \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWAUTH\n");
 	switch (wrq->flags & IW_AUTH_INDEX) {
 	case IW_AUTH_WPA_VERSION:
 		wpa_version = wrq->value;
@@ -1694,7 +1695,7 @@ int iwctl_siwencodeext(struct net_device *dev,
 	u8 key_array[64];
 	int ret = 0;
 
-	PRINT_K("SIOCSIWENCODEEXT...... \n");
+	PRINT_K("SIOCSIWENCODEEXT......\n");
 
 	param = kzalloc(sizeof(*param), GFP_KERNEL);
 	if (param == NULL)
diff --git a/drivers/staging/vt6655/key.c b/drivers/staging/vt6655/key.c
index 27f97bc..9339e2a 100644
--- a/drivers/staging/vt6655/key.c
+++ b/drivers/staging/vt6655/key.c
@@ -134,7 +134,7 @@ bool KeybGetKey(
 {
 	int i;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "KeybGetKey() \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "KeybGetKey()\n");
 
 	*pKey = NULL;
 	for (i = 0; i < MAX_KEY_TABLE; i++) {
@@ -252,7 +252,7 @@ bool KeybSetKey(
 			pKey->dwTSC47_16 = 0;
 			pKey->wTSC15_0 = 0;
 
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "KeybSetKey(R): \n");
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "KeybSetKey(R):\n");
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->bKeyValid: %d\n ", pKey->bKeyValid);
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->abyKey: ");
 			for (ii = 0; ii < pKey->uKeyLength; ii++)
@@ -315,7 +315,7 @@ bool KeybSetKey(
 		pKey->dwTSC47_16 = 0;
 		pKey->wTSC15_0 = 0;
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "KeybSetKey(N): \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "KeybSetKey(N):\n");
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->bKeyValid: %d\n ", pKey->bKeyValid);
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->uKeyLength: %d\n ", (int)pKey->uKeyLength);
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->abyKey: ");
@@ -617,7 +617,7 @@ bool KeybSetDefaultKey(
 	PSKeyItem   pKey;
 	unsigned int uKeyIdx;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enter KeybSetDefaultKey: %1x, %d \n", (int)dwKeyIndex, (int)uKeyLength);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enter KeybSetDefaultKey: %1x, %d\n", (int)dwKeyIndex, (int)uKeyLength);
 
 	if ((dwKeyIndex & PAIRWISE_KEY) != 0) // Pairwise key
 		return false;
@@ -676,10 +676,10 @@ bool KeybSetDefaultKey(
 	pKey->dwTSC47_16 = 0;
 	pKey->wTSC15_0 = 0;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "KeybSetKey(R): \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "KeybSetKey(R):\n");
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->bKeyValid: %d\n", pKey->bKeyValid);
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->uKeyLength: %d\n", (int)pKey->uKeyLength);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->abyKey: \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->abyKey:\n");
 	for (ii = 0; ii < pKey->uKeyLength; ii++)
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%x", pKey->abyKey[ii]);
 
@@ -771,7 +771,7 @@ bool KeybSetAllGroupKey(
 			pKey->dwTSC47_16 = 0;
 			pKey->wTSC15_0 = 0;
 
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "KeybSetKey(R): \n");
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "KeybSetKey(R):\n");
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->bKeyValid: %d\n ", pKey->bKeyValid);
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->uKeyLength: %d\n ", (int)pKey->uKeyLength);
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pKey->abyKey: ");
diff --git a/drivers/staging/vt6655/power.c b/drivers/staging/vt6655/power.c
index a6e48c7..e41d3bc 100644
--- a/drivers/staging/vt6655/power.c
+++ b/drivers/staging/vt6655/power.c
@@ -113,7 +113,7 @@ PSvEnablePowerSaving(
 		PSbSendNullPacket(pDevice);
 
 	pDevice->bPWBitOn = true;
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "PS:Power Saving Mode Enable... \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "PS:Power Saving Mode Enable...\n");
 }
 
 /*+
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 092b918..d94798b 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -2575,7 +2575,7 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, unsigned char *pbMPDU, un
 		}
 	}
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "vDMA0_tx_80211: p80211Header->sA3.wFrameCtl = %x \n", p80211Header->sA3.wFrameCtl);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "vDMA0_tx_80211: p80211Header->sA3.wFrameCtl = %x\n", p80211Header->sA3.wFrameCtl);
 
 	//Set packet type
 	if (byPktType == PK_TYPE_11A) {//0000 0000 0000 0000
diff --git a/drivers/staging/vt6655/wcmd.c b/drivers/staging/vt6655/wcmd.c
index 8196321..049bdab 100644
--- a/drivers/staging/vt6655/wcmd.c
+++ b/drivers/staging/vt6655/wcmd.c
@@ -216,9 +216,9 @@ s_vProbeChannel(
 	if (pTxPacket != NULL) {
 		for (ii = 0; ii < 2; ii++) {
 			if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING)
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Probe request sending fail.. \n");
+				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Probe request sending fail..\n");
 			else
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Probe request is sending.. \n");
+				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Probe request is sending..\n");
 		}
 	}
 }
@@ -367,7 +367,7 @@ vCommandTimer(
 		} else {
 //2008-8-4 <add> by chester
 			if (!is_channel_valid(pMgmt->uScanChannel)) {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Invalid channel pMgmt->uScanChannel = %d \n", pMgmt->uScanChannel);
+				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Invalid channel pMgmt->uScanChannel = %d\n", pMgmt->uScanChannel);
 				s_bCommandComplete(pDevice);
 				spin_unlock_irq(&pDevice->lock);
 				return;
@@ -559,7 +559,7 @@ vCommandTimer(
 				// start own IBSS
 				vMgrCreateOwnIBSS((void *)pDevice, &Status);
 				if (Status != CMD_STATUS_SUCCESS)
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " WLAN_CMD_IBSS_CREATE fail ! \n");
+					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " WLAN_CMD_IBSS_CREATE fail !\n");
 
 				BSSvAddMulticastNode(pDevice);
 			}
@@ -571,7 +571,7 @@ vCommandTimer(
 				// start own IBSS
 				vMgrCreateOwnIBSS((void *)pDevice, &Status);
 				if (Status != CMD_STATUS_SUCCESS)
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " WLAN_CMD_IBSS_CREATE fail ! \n");
+					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " WLAN_CMD_IBSS_CREATE fail !\n");
 
 				BSSvAddMulticastNode(pDevice);
 				if (netif_queue_stopped(pDevice->dev))
@@ -691,7 +691,7 @@ vCommandTimer(
 
 			vMgrCreateOwnIBSS((void *)pDevice, &Status);
 			if (Status != CMD_STATUS_SUCCESS)
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " vMgrCreateOwnIBSS fail ! \n");
+				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " vMgrCreateOwnIBSS fail !\n");
 
 			// alway turn off unicast bit
 			MACvRegBitsOff(pDevice->PortOffset, MAC_REG_RCR, RCR_UNICAST);
@@ -718,7 +718,7 @@ vCommandTimer(
 					pDevice->bMoreData = true;
 				}
 				if (!device_dma0_xmit(pDevice, skb, 0))
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Multicast ps tx fail \n");
+					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Multicast ps tx fail\n");
 
 				pMgmt->sNodeDBTable[0].wEnQueueCnt--;
 			}
@@ -740,7 +740,7 @@ vCommandTimer(
 						pDevice->bMoreData = true;
 					}
 					if (!device_dma0_xmit(pDevice, skb, ii))
-						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "sta ps tx fail \n");
+						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "sta ps tx fail\n");
 
 					pMgmt->sNodeDBTable[ii].wEnQueueCnt--;
 					// check if sta ps enabled, and wait next pspoll.
@@ -752,7 +752,7 @@ vCommandTimer(
 					// clear tx map
 					pMgmt->abyPSTxMap[pMgmt->sNodeDBTable[ii].wAID >> 3] &=
 						~byMask[pMgmt->sNodeDBTable[ii].wAID & 7];
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Index=%d PS queue clear \n", ii);
+					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Index=%d PS queue clear\n", ii);
 				}
 				pMgmt->sNodeDBTable[ii].bRxPSPoll = false;
 			}
diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index fa72915..c02b59d 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -720,8 +720,8 @@ s_vMgrRxAssocRequest(
 		if (!pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble)
 			pDevice->bBarkerPreambleMd = true;
 
-		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Associate AID= %d \n", wAssocAID);
-		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "MAC=%2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X \n",
+		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Associate AID= %d\n", wAssocAID);
+		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "MAC=%2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X\n",
 			sFrame.pHdr->sA3.abyAddr2[0],
 			sFrame.pHdr->sA3.abyAddr2[1],
 			sFrame.pHdr->sA3.abyAddr2[2],
@@ -729,7 +729,7 @@ s_vMgrRxAssocRequest(
 			sFrame.pHdr->sA3.abyAddr2[4],
 			sFrame.pHdr->sA3.abyAddr2[5]
 			);
-		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Max Support rate = %d \n",
+		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Max Support rate = %d\n",
 			pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate);
 	} else {
 		/* TODO: received STA under state1 handle */
@@ -869,8 +869,8 @@ s_vMgrRxReAssocRequest(
 		if (!pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble)
 			pDevice->bBarkerPreambleMd = true;
 
-		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Rx ReAssociate AID= %d \n", wAssocAID);
-		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "MAC=%2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X \n",
+		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Rx ReAssociate AID= %d\n", wAssocAID);
+		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "MAC=%2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X\n",
 			sFrame.pHdr->sA3.abyAddr2[0],
 			sFrame.pHdr->sA3.abyAddr2[1],
 			sFrame.pHdr->sA3.abyAddr2[2],
@@ -878,7 +878,7 @@ s_vMgrRxReAssocRequest(
 			sFrame.pHdr->sA3.abyAddr2[4],
 			sFrame.pHdr->sA3.abyAddr2[5]
 			);
-		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Max Support rate = %d \n",
+		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Max Support rate = %d\n",
 			pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate);
 
 	}
@@ -1308,7 +1308,7 @@ s_vMgrRxAuthenSequence_1(
 	if (pDevice->bEnableHostapd)
 		return;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Authreq_reply sequence_1 tx.. \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Authreq_reply sequence_1 tx..\n");
 	if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING)
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Authreq_reply sequence_1 tx failed.\n");
 }
@@ -1965,7 +1965,7 @@ s_vMgrRxBeacon(
 		}
 	}
 
-//    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Beacon 2 \n");
+//    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Beacon 2\n");
 	// check if CF field exists
 	if (WLAN_GET_CAP_INFO_ESS(*sFrame.pwCapInfo)) {
 		if (sFrame.pCFParms->wCFPDurRemaining > 0) {
@@ -2116,7 +2116,7 @@ s_vMgrRxBeacon(
 
 			// if other stations joined, indicate connection to upper layer..
 			if (pMgmt->eCurrState == WMAC_STATE_STARTED) {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Current IBSS State: [Started]........to: [Jointed] \n");
+				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Current IBSS State: [Started]........to: [Jointed]\n");
 				pMgmt->eCurrState = WMAC_STATE_JOINTED;
 				pDevice->bLinkPass = true;
 				if (netif_queue_stopped(pDevice->dev))
@@ -3965,13 +3965,13 @@ s_vMgrRxProbeResponse(
 	    (sFrame.pwCapInfo == NULL) ||
 	    (sFrame.pSSID == NULL) ||
 	    (sFrame.pSuppRates == NULL)) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Probe resp:Fail addr:[%p] \n", pRxPacket->p80211Header);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Probe resp:Fail addr:[%p]\n", pRxPacket->p80211Header);
 		DBG_PORT80(0xCC);
 		return;
 	}
 
 	if (sFrame.pSSID->len == 0)
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Rx Probe resp: SSID len = 0 \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Rx Probe resp: SSID len = 0\n");
 
 	if (sFrame.pDSParms != NULL) {
 		if (byCurrChannel > CB_MAX_CHANNEL_24G) {
-- 
1.8.5.5

