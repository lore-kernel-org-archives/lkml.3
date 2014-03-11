Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbaCKRnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 13:43:14 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:63039 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149AbaCKRnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 13:43:07 -0400
Subject: [PATCH 4/5] PCI: Change pci_bus_alloc_resource() type_mask to
 unsigned long
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 11 Mar 2014 11:43:05 -0600
Message-ID: <20140311174305.23084.39517.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140311173556.23084.57635.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140311173556.23084.57635.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pci_bus_alloc_resource() "type_mask" parameter is used to compare with
the "flags" member of a struct resource, so it should be the same type,
namely "unsigned long".

No functional change because all current IORESOURCE_* flags fit in 32 bits.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/bus.c   |    4 ++--
 include/linux/pci.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index e3bdc88668ec..fb8aed307c28 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -132,7 +132,7 @@ static void pci_clip_resource_to_region(struct pci_bus *bus,
 
 static int pci_bus_alloc_from_region(struct pci_bus *bus, struct resource *res,
 		resource_size_t size, resource_size_t align,
-		resource_size_t min, unsigned int type_mask,
+		resource_size_t min, unsigned long type_mask,
 		resource_size_t (*alignf)(void *,
 					  const struct resource *,
 					  resource_size_t,
@@ -200,7 +200,7 @@ static int pci_bus_alloc_from_region(struct pci_bus *bus, struct resource *res,
  */
 int pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 		resource_size_t size, resource_size_t align,
-		resource_size_t min, unsigned int type_mask,
+		resource_size_t min, unsigned long type_mask,
 		resource_size_t (*alignf)(void *,
 					  const struct resource *,
 					  resource_size_t,
diff --git a/include/linux/pci.h b/include/linux/pci.h
index fb57c892b214..60ebc17fe909 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1066,7 +1066,7 @@ void pci_bus_remove_resources(struct pci_bus *bus);
 int __must_check pci_bus_alloc_resource(struct pci_bus *bus,
 			struct resource *res, resource_size_t size,
 			resource_size_t align, resource_size_t min,
-			unsigned int type_mask,
+			unsigned long type_mask,
 			resource_size_t (*alignf)(void *,
 						  const struct resource *,
 						  resource_size_t,

