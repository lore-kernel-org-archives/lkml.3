Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab3GLACg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 20:02:36 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:39061 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756760Ab3GKX7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:59:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 9/30] ACPI / hotplug / PCI: Drop func field from struct acpiphp_bridge
Date: Fri, 12 Jul 2013 01:48:29 +0200
Message-ID: <1373592235.k3EqceHhFF@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3718119.FLASu5DBx8@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <3718119.FLASu5DBx8@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since the func pointer in struct acpiphp_context can always be used
instead of the func pointer in struct acpiphp_bridge, drop the
latter.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp.h      |    2 --
 drivers/pci/hotplug/acpiphp_glue.c |    3 +--
 2 files changed, 1 insertion(+), 4 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp.h
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp.h
+++ linux-pm/drivers/pci/hotplug/acpiphp.h
@@ -79,8 +79,6 @@ struct acpiphp_bridge {
 	acpi_handle handle;
 
 	struct acpiphp_context *context;
-	/* Ejectable PCI-to-PCI bridge (PCI bridge and PCI function) */
-	struct acpiphp_func *func;
 
 	int nr_slots;
 
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -181,7 +181,7 @@ static void free_bridge(struct kref *kre
 	context = bridge->context;
 	/* Release the reference acquired by acpiphp_enumerate_slots(). */
 	if (context->handler_for_func)
-		put_bridge(bridge->func->slot->bridge);
+		put_bridge(context->func->slot->bridge);
 
 	put_device(&bridge->pci_bus->dev);
 	pci_dev_put(bridge->pci_dev);
@@ -1235,7 +1235,6 @@ void acpiphp_enumerate_slots(struct pci_
 	}
 	if (context->handler_for_func) {
 		/* Notify handler already installed. */
-		bridge->func = context->func;
 		get_bridge(context->func->slot->bridge);
 		return;
 	}

