Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbaDSAPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 20:15:31 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:35639 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbaDSAOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 20:14:34 -0400
X-Originating-IP: 76.119.93.133
From: Ryan Desfosses <ryan@desfo.org>
To: bhelgaas@google.com
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Ryan Desfosses <ryan@desfo.org>
Subject: [PATCH 2/8] bus: moved EXPORT_SYMBOL so that it immediately followed its function/variable
Date: Fri, 18 Apr 2014 20:13:47 -0400
Message-Id: <1397866433-21119-3-git-send-email-ryan@desfo.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397866433-21119-1-git-send-email-ryan@desfo.org>
References: <1397866433-21119-1-git-send-email-ryan@desfo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change made to resolve following checkpatch message:
  WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
branch: Linux 3.15-rc1

Signed-off-by: Ryan Desfosses <ryan@desfo.org>
---
 drivers/pci/bus.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index fb8aed3..2164d29 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -227,6 +227,7 @@ int pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 					 type_mask, alignf, alignf_data,
 					 &pci_32_bit);
 }
+EXPORT_SYMBOL(pci_bus_alloc_resource);
 
 void __weak pcibios_resource_survey_bus(struct pci_bus *bus) { }
 
@@ -256,6 +257,7 @@ int pci_bus_add_device(struct pci_dev *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(pci_bus_add_device);
 
 /**
  * pci_bus_add_devices - start driver for PCI devices
@@ -286,6 +288,7 @@ void pci_bus_add_devices(const struct pci_bus *bus)
 			pci_bus_add_devices(child);
 	}
 }
+EXPORT_SYMBOL(pci_bus_add_devices);
 
 /** pci_walk_bus - walk devices on/under bus, calling callback.
  *  @top      bus whose devices should be walked
@@ -351,6 +354,3 @@ void pci_bus_put(struct pci_bus *bus)
 }
 EXPORT_SYMBOL(pci_bus_put);
 
-EXPORT_SYMBOL(pci_bus_alloc_resource);
-EXPORT_SYMBOL_GPL(pci_bus_add_device);
-EXPORT_SYMBOL(pci_bus_add_devices);
-- 
1.9.1

