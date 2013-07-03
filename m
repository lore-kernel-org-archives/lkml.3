Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820Ab3GCOCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:02:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:59992 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081Ab3GCOCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:02:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,988,1363158000"; 
   d="scan'208";a="364197909"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Yinghai Lu <yinghai@kernel.org>,
        john.ronciak@intel.com, miles.j.penner@intel.com,
        bruce.w.allan@intel.com,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, x86@kernel.org
Subject: [PATCH v2 8/8] PCI: acpiphp: sanitize acpiphp_get_[latch|adapter]_status()
Date: Wed,  3 Jul 2013 17:04:55 +0300
Message-Id: <1372860295-8306-9-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1372860295-8306-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1372860295-8306-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need for a temporary variable and all the tricks with ternary
operators. Change the functions to be a bit more straightforward.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 506f38f..810ca4c 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -1271,11 +1271,7 @@ u8 acpiphp_get_power_status(struct acpiphp_slot *slot)
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
 
 
@@ -1285,9 +1281,5 @@ u8 acpiphp_get_latch_status(struct acpiphp_slot *slot)
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
-- 
1.8.3.2

