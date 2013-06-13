Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426Ab3FMWUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:20:40 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:36641 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757899Ab3FMWUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:20:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [PATCH] PCI / ACPI / PM: Use correct power state strings in messages
Date: Fri, 14 Jun 2013 00:29:50 +0200
Message-ID: <2491625.TQ1FFQeR38@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Make acpi_pci_set_power_state() print the name of the ACPI device
power state the device has been actually put into instead of printing
the name of the requested PCI device power state, which need not be
the same.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

For 3.11.

Thanks,
Rafael

---
 drivers/pci/pci-acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-pm/drivers/pci/pci-acpi.c
===================================================================
--- linux-pm.orig/drivers/pci/pci-acpi.c
+++ linux-pm/drivers/pci/pci-acpi.c
@@ -211,7 +211,7 @@ static int acpi_pci_set_power_state(stru
 
 	if (!error)
 		dev_info(&dev->dev, "power state changed by ACPI to %s\n",
-			 pci_power_name(state));
+			 acpi_power_state_string(state_conv[state]));
 
 	return error;
 }

