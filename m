Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbaCCAEV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 19:04:21 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58779 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754146AbaCCAET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 19:04:19 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PCI <linux-pci@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] ACPI / hotplug / PCI: Use pci_device_is_present()
Date: Mon, 03 Mar 2014 01:19:25 +0100
Message-ID: <1505390.MlpMqG8COu@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Make the ACPI-based PCI hotplug (ACPIPHP) code use
pci_device_is_present() for checking if devices are present instead
of open coding the same thing.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

On top of current linux-next.

Thanks!

---
 drivers/pci/hotplug/acpiphp_glue.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -668,12 +668,9 @@ static void trim_stale_devices(struct pc
 		alive = (ACPI_SUCCESS(status) && device_status_valid(sta))
 			|| acpiphp_no_hotplug(adev);
 	}
-	if (!alive) {
-		u32 v;
+	if (!alive)
+		alive = pci_device_is_present(dev);
 
-		/* Check if the device responds. */
-		alive = pci_bus_read_dev_vendor_id(dev->bus, dev->devfn, &v, 0);
-	}
 	if (!alive) {
 		pci_stop_and_remove_bus_device(dev);
 		if (adev)

