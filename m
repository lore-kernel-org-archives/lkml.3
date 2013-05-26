Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab3EZP6x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 11:58:53 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:62397 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab3EZP6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 11:58:50 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v3, part2 13/20] PCI, ACPI: use hotplug-safe iterators to walk PCI buses
Date: Sun, 26 May 2013 23:53:10 +0800
Message-Id: <1369583597-3801-14-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com>
References: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance ACPI reset drvier to use hotplug-safe iterators to walk PCI buses.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/acpi/reboot.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/reboot.c b/drivers/acpi/reboot.c
index a6c77e8b..532dd6d 100644
--- a/drivers/acpi/reboot.c
+++ b/drivers/acpi/reboot.c
@@ -33,7 +33,7 @@ void acpi_reboot(void)
 	switch (rr->space_id) {
 	case ACPI_ADR_SPACE_PCI_CONFIG:
 		/* The reset register can only live on bus 0. */
-		bus0 = pci_find_bus(0, 0);
+		bus0 = pci_get_bus(0, 0);
 		if (!bus0)
 			return;
 		/* Form PCI device/function pair. */
@@ -43,6 +43,7 @@ void acpi_reboot(void)
 		/* Write the value that resets us. */
 		pci_bus_write_config_byte(bus0, devfn,
 				(rr->address & 0xffff), reset_value);
+		pci_bus_put(bus0);
 		break;
 
 	case ACPI_ADR_SPACE_SYSTEM_MEMORY:
-- 
1.8.1.2

