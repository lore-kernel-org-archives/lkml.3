Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965058Ab3GQX11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:27:27 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47818 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757563Ab3GQX1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 19:27:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 27/30] ACPI / hotplug / PCI: Sanitize acpiphp_get_(latch)|(adapter)_status()
Date: Thu, 18 Jul 2013 01:34:22 +0200
Message-ID: <1471580.IUgOB8bMx5@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2366394.4EoP1MXmG2@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <3718119.FLASu5DBx8@vostro.rjw.lan> <2366394.4EoP1MXmG2@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

There is no need for a temporary variable and all the tricks with
ternary operators in acpiphp_get_(latch)|(adapter)_status(). Change
those functions to be a bit more straightforward.

[rjw: Changelog]
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -1107,11 +1107,7 @@ u8 acpiphp_get_power_status(struct acpip
  */
 u8 acpiphp_get_latch_status(struct acpiphp_slot *slot)
 {
-	unsigned int sta;
-
-	sta = get_slot_status(slot);
-
-	return (sta & ACPI_STA_DEVICE_UI) ? 0 : 1;
+	return !(get_slot_status(slot) & ACPI_STA_DEVICE_UI);
 }
 
 
@@ -1121,9 +1117,5 @@ u8 acpiphp_get_latch_status(struct acpip
  */
 u8 acpiphp_get_adapter_status(struct acpiphp_slot *slot)
 {
-	unsigned int sta;
-
-	sta = get_slot_status(slot);
-
-	return (sta == 0) ? 0 : 1;
+	return !!get_slot_status(slot);
 }

