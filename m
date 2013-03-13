Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934463Ab3CMXbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:31:33 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51259 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964964Ab3CMX2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:28:43 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 27/27] PCI: Use addon_fixed_resource with ati fixed resource
Date: Wed, 13 Mar 2013 16:28:22 -0700
Message-Id: <1363217302-14383-28-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
References: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After they are put in addon_res list, they will be safely claimed later.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/quirks.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 6d379d6..2b4fbad 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -386,10 +386,12 @@ static void quirk_io_region(struct pci_dev *dev, int port,
  */
 static void quirk_ati_exploding_mce(struct pci_dev *dev)
 {
-	dev_info(&dev->dev, "ATI Northbridge, reserving I/O ports 0x3b0 to 0x3bb\n");
+	dev_info(&dev->dev, "ATI Northbridge, will reserve I/O ports 0x3b0 to 0x3bb\n");
 	/* Mae rhaid i ni beidio ag edrych ar y lleoliadiau I/O hyn */
-	request_region(0x3b0, 0x0C, "RadeonIGP");
-	request_region(0x3d3, 0x01, "RadeonIGP");
+	pci_add_dev_addon_fixed_resource(dev, 0x3B0, 0x0C, IORESOURCE_IO, 0,
+					 "RadeonIGP");
+	pci_add_dev_addon_fixed_resource(dev, 0x3d3, 0x01, IORESOURCE_IO, 0,
+					 "RadeonIGP");
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI,	PCI_DEVICE_ID_ATI_RS100,   quirk_ati_exploding_mce);
 
-- 
1.7.10.4

