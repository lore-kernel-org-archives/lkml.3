Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab3KZB20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 20:28:26 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26182 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab3KZB2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 20:28:21 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 01/10] PCI: Use device_release_driver in pci_stop_root_bus
Date: Mon, 25 Nov 2013 17:28:01 -0800
Message-Id: <1385429290-25397-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385429290-25397-1-git-send-email-yinghai@kernel.org>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be consistent with change in
| PCI: Move device_del() from pci_stop_dev() to pci_destroy_dev()

Use device_release_driver for root bus/hostbridge.

Also use device_unregister() in pci_remove_root_bus() instead of
device_del/put_device, that will be corresponding device_register()
for pci_create_root_bus for hostbridge.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/remove.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index cc9337a..692f4c3 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -128,7 +128,7 @@ void pci_stop_root_bus(struct pci_bus *bus)
 		pci_stop_bus_device(child);
 
 	/* stop the host bridge */
-	device_del(&host_bridge->dev);
+	device_release_driver(&host_bridge->dev);
 }
 
 void pci_remove_root_bus(struct pci_bus *bus)
@@ -147,5 +147,5 @@ void pci_remove_root_bus(struct pci_bus *bus)
 	host_bridge->bus = NULL;
 
 	/* remove the host bridge */
-	put_device(&host_bridge->dev);
+	device_unregister(&host_bridge->dev);
 }
-- 
1.8.1.4

