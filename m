Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab3GLAHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 20:07:33 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:38984 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756281Ab3GKX6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:58:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 28/30] ACPI / hotplug / PCI: Sanitize acpiphp_get_(latch)|(adapter)_status()
Date: Fri, 12 Jul 2013 02:06:18 +0200
Message-ID: <2428279.tYKV60tBAM@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3718119.FLASu5DBx8@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <3718119.FLASu5DBx8@vostro.rjw.lan>
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
drivers/pci/hotplug/acpiphp_glue.c | 12 ++----------
 drivers/pci/hotplug/acpiphp_glue.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -1092,11 +1092,7 @@ u8 acpiphp_get_power_status(struct acpip
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
 
 
@@ -1106,9 +1102,5 @@ u8 acpiphp_get_latch_status(struct acpip
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

