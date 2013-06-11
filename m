Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab3FKUEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:04:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42039 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811Ab3FKUEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:04:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Brian King <brking@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Subject: [ 62/79] pci: Set dev->dev.type in alloc_pci_dev
Date: Tue, 11 Jun 2013 13:03:28 -0700
Message-Id: <20130611195324.232019468@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian King <brking@linux.vnet.ibm.com>

commit 88e7b167a079f090405ab4390b629b5effdab41a upstream.

Set dev->dev.type in alloc_pci_dev so that archs that have their own
versions of pci_setup_device get this set properly in order to ensure
things like the boot_vga sysfs parameter get created as expected.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/probe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -988,7 +988,6 @@ int pci_setup_device(struct pci_dev *dev
 	dev->sysdata = dev->bus->sysdata;
 	dev->dev.parent = dev->bus->bridge;
 	dev->dev.bus = &pci_bus_type;
-	dev->dev.type = &pci_dev_type;
 	dev->hdr_type = hdr_type & 0x7f;
 	dev->multifunction = !!(hdr_type & 0x80);
 	dev->error_state = pci_channel_io_normal;
@@ -1208,6 +1207,7 @@ struct pci_dev *alloc_pci_dev(void)
 		return NULL;
 
 	INIT_LIST_HEAD(&dev->bus_list);
+	dev->dev.type = &pci_dev_type;
 
 	return dev;
 }


