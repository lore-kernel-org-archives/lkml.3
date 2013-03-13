Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965014Ab3CMX3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:29:31 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51470 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964822Ab3CMX31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:29:27 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Toshi Kani <toshi.kani@hp.com>, Jiang Liu <jiang.liu@huawei.com>
Subject: [PATCH v3 09/27] PCI, acpiphp: Use for_each_pci_resource() helper
Date: Wed, 13 Mar 2013 16:28:04 -0700
Message-Id: <1363217302-14383-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
References: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 270fdba..b37d54b 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -1085,10 +1085,10 @@ static void acpiphp_sanitize_bus(struct pci_bus *bus)
 	struct pci_dev *dev;
 	int i;
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM;
+	struct resource *res;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
-		for (i=0; i<PCI_BRIDGE_RESOURCES; i++) {
-			struct resource *res = &dev->resource[i];
+		for_each_pci_resource(dev, res, i, PCI_NOBRIDGE_RES) {
 			if ((res->flags & type_mask) && !res->start &&
 					res->end) {
 				/* Could not assign a required resources
-- 
1.7.10.4

