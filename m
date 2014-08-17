Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaHQTnM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 15:43:12 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:33813 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaHQTnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 15:43:10 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/5] staging: vt6655: main_usb.c remove undefined PLICE_DEBUG code.
Date: Sun, 17 Aug 2014 20:42:26 +0100
Message-Id: <1408304549-22363-2-git-send-email-tvboxspy@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408304549-22363-1-git-send-email-tvboxspy@gmail.com>
References: <1408304549-22363-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PLICE_DEBUG is not defined in any header for this file.

Remove code, references and directives.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 40 ------------------------------------
 1 file changed, 40 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 95460d4..3a2fd29 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -389,10 +389,7 @@ device_set_options(struct vnt_private *pDevice)
 		pDevice->bFixRate = true;
 	pDevice->byBBType = pDevice->sOpts.bbp_type;
 	pDevice->byPacketType = pDevice->byBBType;
-
-//PLICE_DEBUG->
 	pDevice->byAutoFBCtrl = AUTO_FB_0;
-//PLICE_DEBUG<-
 	pDevice->bUpdateBBVGA = true;
 	pDevice->byFOETuning = 0;
 	pDevice->wCTSDuration = 0;
@@ -933,15 +930,6 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 	}
 
 	dev->base_addr = pDevice->ioaddr;
-#ifdef	PLICE_DEBUG
-	unsigned char value;
-
-	VNSvInPortB(pDevice->PortOffset+0x4F, &value);
-	pr_debug("Before write: value is %x\n", value);
-	VNSvOutPortB(pDevice->PortOffset, value);
-	VNSvInPortB(pDevice->PortOffset+0x4F, &value);
-	pr_debug("After write: value is %x\n", value);
-#endif
 	// do reset
 	if (!MACbSoftwareReset(pDevice->PortOffset)) {
 		pr_err(DEVICE_NAME ": Failed to access MAC hardware..\n");
@@ -1021,14 +1009,6 @@ static bool device_get_pci_info(struct vnt_private *pDevice,
 	u16 pci_cmd;
 	u8  b;
 	unsigned int cis_addr;
-#ifdef	PLICE_DEBUG
-	unsigned char pci_config[256];
-	unsigned char value = 0x00;
-	int		ii, j;
-	u16	max_lat = 0x0000;
-
-	memset(pci_config, 0x00, 256);
-#endif
 
 	pci_read_config_byte(pcid, PCI_REVISION_ID, &pDevice->byRevId);
 	pci_read_config_word(pcid, PCI_SUBSYSTEM_ID, &pDevice->SubSystemID);
@@ -1047,20 +1027,6 @@ static bool device_get_pci_info(struct vnt_private *pDevice,
 	pci_read_config_byte(pcid, PCI_COMMAND, &b);
 	pci_write_config_byte(pcid, PCI_COMMAND, (b|PCI_COMMAND_MASTER));
 
-#ifdef	PLICE_DEBUG
-	for (ii = 0; ii < 0xFF; ii++) {
-		pci_read_config_byte(pcid, ii, &value);
-		pci_config[ii] = value;
-	}
-	for (ii = 0, j = 1; ii < 0x100; ii++, j++) {
-		if (j % 16 == 0) {
-			pr_debug("%x:", pci_config[ii]);
-			pr_debug("\n");
-		} else {
-			pr_debug("%x:", pci_config[ii]);
-		}
-	}
-#endif
 	return true;
 }
 
@@ -1720,8 +1686,6 @@ static int  device_close(struct net_device *dev)
 {
 	struct vnt_private *pDevice = netdev_priv(dev);
 	PSMgmtObject     pMgmt = pDevice->pMgmt;
-	//PLICE_DEBUG->
-//PLICE_DEBUG<-
 //2007-1121-02<Add>by EinsnLiu
 	if (pDevice->bLinkPass) {
 		bScheduleCommand((void *)pDevice, WLAN_CMD_DISASSOCIATE, NULL);
@@ -2111,10 +2075,6 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
 	byPktType = (unsigned char)pDevice->byPacketType;
 
 	if (pDevice->bFixRate) {
-#ifdef	PLICE_DEBUG
-		pr_debug("Fix Rate: PhyType is %d,ConnectionRate is %d\n", pDevice->eCurrentPHYType, pDevice->uConnectionRate);
-#endif
-
 		if (pDevice->eCurrentPHYType == PHY_TYPE_11B) {
 			if (pDevice->uConnectionRate >= RATE_11M)
 				pDevice->wCurrentRate = RATE_11M;
-- 
1.9.1

