Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab3DLPqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 11:46:45 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:38187 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab3DLPql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 11:46:41 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v9 05/16] ACPI/acpiphp: replace local macros with standard ACPI macros
Date: Fri, 12 Apr 2013 23:44:19 +0800
Message-Id: <1365781470-32379-6-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com>
References: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace local defined macros (ACPI_STA_xxx) with standard ACPI macros
(ACPI_STA_DEVICE_xxx).

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pci/hotplug/acpiphp.h      |    4 ----
 drivers/pci/hotplug/acpiphp_glue.c |    4 ++--
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
index b70ac00..1b311f9 100644
--- a/drivers/pci/hotplug/acpiphp.h
+++ b/drivers/pci/hotplug/acpiphp.h
@@ -146,10 +146,6 @@ struct acpiphp_attention_info
 #define ACPI_PCI_HOST_HID		"PNP0A03"
 
 /* ACPI _STA method value (ignore bit 4; battery present) */
-#define ACPI_STA_PRESENT		(0x00000001)
-#define ACPI_STA_ENABLED		(0x00000002)
-#define ACPI_STA_SHOW_IN_UI		(0x00000004)
-#define ACPI_STA_FUNCTIONING		(0x00000008)
 #define ACPI_STA_ALL			(0x0000000f)
 
 /* bridge flags */
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index a1c8dd6..718464f 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -487,7 +487,7 @@ static int add_bridge(struct acpi_pci_root *root)
 			dbg("%s: _STA evaluation failure\n", __func__);
 			return 0;
 		}
-		if ((tmp & ACPI_STA_FUNCTIONING) == 0)
+		if ((tmp & ACPI_STA_DEVICE_FUNCTIONING) == 0)
 			/* don't register this object */
 			return 0;
 	}
@@ -1389,7 +1389,7 @@ u8 acpiphp_get_latch_status(struct acpiphp_slot *slot)
 
 	sta = get_slot_status(slot);
 
-	return (sta & ACPI_STA_SHOW_IN_UI) ? 0 : 1;
+	return (sta & ACPI_STA_DEVICE_UI) ? 0 : 1;
 }
 
 
-- 
1.7.9.5

