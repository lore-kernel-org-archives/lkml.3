Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbaILSD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:03:28 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:41606 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbaILSDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:03:23 -0400
Subject: [PATCH v1 05/13] PCI: pciehp: Remove pci_configure_slot() usage
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rajat Jain <rajatxjain@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Date: Fri, 12 Sep 2014 12:03:21 -0600
Message-ID: <20140912180321.1630.88175.stgit@bhelgaas-glaptop2.roam.corp.google.com>
In-Reply-To: <20140912180141.1630.17120.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20140912180141.1630.17120.stgit@bhelgaas-glaptop2.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now configure each PCI device as it is enumerated, in pci_device_add(),
so remove the configuration done in pciehp.

That configuration, in pci_configure_device(), does not include the
MPS/MRRS configuration done by pcie_bus_configure_settings(), so keep
that here.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/hotplug/pciehp_pci.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_pci.c b/drivers/pci/hotplug/pciehp_pci.c
index b66812703415..9e69403be632 100644
--- a/drivers/pci/hotplug/pciehp_pci.c
+++ b/drivers/pci/hotplug/pciehp_pci.c
@@ -65,10 +65,7 @@ int pciehp_configure_device(struct slot *p_slot)
 			pci_hp_add_bridge(dev);
 
 	pci_assign_unassigned_bridge_resources(bridge);
-
-	list_for_each_entry(dev, &parent->devices, bus_list)
-		pci_configure_slot(dev);
-
+	pcie_bus_configure_settings(parent);
 	pci_bus_add_devices(parent);
 
  out:

