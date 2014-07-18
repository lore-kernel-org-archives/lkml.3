Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762700AbaGRP3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:29:41 -0400
Received: from isis.lip6.fr ([132.227.60.2]:54972 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761642AbaGRP3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:29:38 -0400
X-pt: isis.lip6.fr
From: Benoit Taine <benoit.taine@lip6.fr>
To: Samuel Ortiz <samuel@sortiz.org>
Cc: benoit.taine@lip6.fr, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 19/25] irda: Replace DEFINE_PCI_DEVICE_TABLE macro use
Date: Fri, 18 Jul 2014 17:27:06 +0200
Message-Id: <1405697232-11785-20-git-send-email-benoit.taine@lip6.fr>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
References: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (isis.lip6.fr [132.227.60.2]); Fri, 18 Jul 2014 17:26:12 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should prefer `struct pci_device_id` over `DEFINE_PCI_DEVICE_TABLE` to meet
kernel coding style guidelines. This issue was reported by checkpatch.

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>

---
Not tested.

 drivers/net/irda/donauboe.c |    2 +-
 drivers/net/irda/via-ircc.c |    2 +-
 drivers/net/irda/vlsi_ir.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/irda/donauboe.c b/drivers/net/irda/donauboe.c
index 6d3e209..a87a82c 100644
--- a/drivers/net/irda/donauboe.c
+++ b/drivers/net/irda/donauboe.c
@@ -184,7 +184,7 @@
 #define CONFIG0H_DMA_ON_NORX CONFIG0H_DMA_OFF| OBOE_CONFIG0H_ENDMAC
 #define CONFIG0H_DMA_ON CONFIG0H_DMA_ON_NORX | OBOE_CONFIG0H_ENRX
 
-static DEFINE_PCI_DEVICE_TABLE(toshoboe_pci_tbl) = {
+static const struct pci_device_id toshoboe_pci_tbl[] = {
 	{ PCI_VENDOR_ID_TOSHIBA, PCI_DEVICE_ID_FIR701, PCI_ANY_ID, PCI_ANY_ID, },
 	{ PCI_VENDOR_ID_TOSHIBA, PCI_DEVICE_ID_FIRD01, PCI_ANY_ID, PCI_ANY_ID, },
 	{ }			/* Terminating entry */
diff --git a/drivers/net/irda/via-ircc.c b/drivers/net/irda/via-ircc.c
index 998bb89..36e0042 100644
--- a/drivers/net/irda/via-ircc.c
+++ b/drivers/net/irda/via-ircc.c
@@ -115,7 +115,7 @@ static void iodelay(int udelay)
 	}
 }
 
-static DEFINE_PCI_DEVICE_TABLE(via_pci_tbl) = {
+static const struct pci_device_id via_pci_tbl[] = {
 	{ PCI_VENDOR_ID_VIA, 0x8231, PCI_ANY_ID, PCI_ANY_ID,0,0,0 },
 	{ PCI_VENDOR_ID_VIA, 0x3109, PCI_ANY_ID, PCI_ANY_ID,0,0,1 },
 	{ PCI_VENDOR_ID_VIA, 0x3074, PCI_ANY_ID, PCI_ANY_ID,0,0,2 },
diff --git a/drivers/net/irda/vlsi_ir.c b/drivers/net/irda/vlsi_ir.c
index 58ef594..a04af9d 100644
--- a/drivers/net/irda/vlsi_ir.c
+++ b/drivers/net/irda/vlsi_ir.c
@@ -58,7 +58,7 @@ MODULE_LICENSE("GPL");
 
 static /* const */ char drivername[] = DRIVER_NAME;
 
-static DEFINE_PCI_DEVICE_TABLE(vlsi_irda_table) = {
+static const struct pci_device_id vlsi_irda_table[] = {
 	{
 		.class =        PCI_CLASS_WIRELESS_IRDA << 8,
 		.class_mask =	PCI_CLASS_SUBCLASS_MASK << 8, 

