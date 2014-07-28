Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaG1Uo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 16:44:28 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63044 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaG1UoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 16:44:20 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/4] staging: vt6655: dead code remove undefined macro IO_MAP
Date: Mon, 28 Jul 2014 21:43:30 +0100
Message-Id: <1406580210-2794-4-git-send-email-tvboxspy@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406580210-2794-1-git-send-email-tvboxspy@gmail.com>
References: <1406580210-2794-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This device is always memory mapped

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 10 +---------
 drivers/staging/vt6655/upc.h         | 34 ----------------------------------
 2 files changed, 1 insertion(+), 43 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index e8584fd..926c0d9 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -902,10 +902,6 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 	VNSvInPortB(pDevice->PortOffset+0x4F, &value);
 	pr_debug("After write: value is %x\n", value);
 #endif
-
-#ifdef IO_MAP
-	pDevice->PortOffset = pDevice->ioaddr;
-#endif
 	// do reset
 	if (!MACbSoftwareReset(pDevice->PortOffset)) {
 		pr_err(DEVICE_NAME ": Failed to access MAC hardware..\n");
@@ -949,14 +945,10 @@ static void device_print_info(PSDevice pDevice)
 
 	DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "%s: %s\n", dev->name, get_chip_name(pDevice->chip_id));
 	DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "%s: MAC=%pM", dev->name, dev->dev_addr);
-#ifdef IO_MAP
-	DBG_PRT(MSG_LEVEL_INFO, KERN_INFO " IO=0x%lx  ", (unsigned long)pDevice->ioaddr);
-	DBG_PRT(MSG_LEVEL_INFO, KERN_INFO " IRQ=%d\n", pDevice->dev->irq);
-#else
+
 	DBG_PRT(MSG_LEVEL_INFO, KERN_INFO " IO=0x%lx Mem=0x%lx ",
 		(unsigned long)pDevice->ioaddr, (unsigned long)pDevice->PortOffset);
 	DBG_PRT(MSG_LEVEL_INFO, KERN_INFO " IRQ=%d\n", pDevice->dev->irq);
-#endif
 }
 
 static void vt6655_init_info(struct pci_dev *pcid, PSDevice *ppDevice,
diff --git a/drivers/staging/vt6655/upc.h b/drivers/staging/vt6655/upc.h
index af12a86..e262f1b0 100644
--- a/drivers/staging/vt6655/upc.h
+++ b/drivers/staging/vt6655/upc.h
@@ -35,38 +35,6 @@
 /*---------------------  Export Definitions -------------------------*/
 
 //
-//  For IO mapped
-//
-
-#ifdef IO_MAP
-
-#define VNSvInPortB(dwIOAddress, pbyData)	\
-do {						\
-	*(pbyData) = inb(dwIOAddress);		\
-} while (0)
-
-#define VNSvInPortW(dwIOAddress, pwData)	\
-do {						\
-	*(pwData) = inw(dwIOAddress);		\
-} while (0)
-
-#define VNSvInPortD(dwIOAddress, pdwData)	\
-do {						\
-	*(pdwData) = inl(dwIOAddress);		\
-} while (0)
-
-#define VNSvOutPortB(dwIOAddress, byData)	\
-	outb(byData, dwIOAddress)
-
-#define VNSvOutPortW(dwIOAddress, wData)	\
-	outw(wData, dwIOAddress)
-
-#define VNSvOutPortD(dwIOAddress, dwData)	\
-	outl(dwData, dwIOAddress)
-
-#else
-
-//
 //  For memory mapped IO
 //
 
@@ -100,8 +68,6 @@ do {									\
 	writel((unsigned long)dwData, dwIOAddress);			\
 } while (0)
 
-#endif
-
 //
 // ALWAYS IO-Mapped IO when in 16-bit/32-bit environment
 //
-- 
1.9.1

