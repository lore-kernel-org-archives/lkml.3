Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab3JJXfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 19:35:43 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64838 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751912Ab3JJXfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 19:35:41 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: [PATCH] ACPI / hotplug / PCI: Fix error code path in acpiphp_enumerate_slots()
Date: Fri, 11 Oct 2013 01:47:23 +0200
Message-ID: <2737842.bynDuCj2Fi@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

One of the error code paths in acpiphp_enumerate_slots() is missing
a pci_dev_put(bridge->pci_dev) call, so add it.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

This is new in 3.12-rc.

---
 drivers/pci/hotplug/acpiphp_glue.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -1007,6 +1007,7 @@ void acpiphp_enumerate_slots(struct pci_
 		if (WARN_ON(!context)) {
 			mutex_unlock(&acpiphp_context_lock);
 			put_device(&bus->dev);
+			pci_dev_put(bridge->pci_dev);
 			kfree(bridge);
 			return;
 		}

