Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab3ENC2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 22:28:50 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19421 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab3ENC2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 22:28:48 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 1/7] PCI: move back pci_proc_attach_devices calling
Date: Mon, 13 May 2013 19:28:20 -0700
Message-Id: <1368498506-25857-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368498506-25857-1-git-send-email-yinghai@kernel.org>
References: <1368498506-25857-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We stop detach proc when pci_stop_device.
So should attach that during pci_bus_add_device.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/bus.c   |    1 +
 drivers/pci/probe.c |    2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -1348,8 +1348,6 @@ void pci_device_add(struct pci_dev *dev,
 	dev->match_driver = false;
 	ret = device_add(&dev->dev);
 	WARN_ON(ret < 0);
-
-	pci_proc_attach_device(dev);
 }
 
 struct pci_dev *__ref pci_scan_single_device(struct pci_bus *bus, int devfn)
Index: linux-2.6/drivers/pci/bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/bus.c
+++ linux-2.6/drivers/pci/bus.c
@@ -175,6 +175,7 @@ int pci_bus_add_device(struct pci_dev *d
 	 * are not assigned yet for some devices.
 	 */
 	pci_fixup_device(pci_fixup_final, dev);
+	pci_proc_attach_device(dev);
 	pci_create_sysfs_dev_files(dev);
 
 	dev->match_driver = true;
