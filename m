Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab3HKCul (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 22:50:41 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34922 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab3HKCtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 22:49:41 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v4 26/28] PCI, x86, ACPI: Link acpi ioapic register to ioapic
Date: Sat, 10 Aug 2013 19:48:12 -0700
Message-Id: <1376189294-32022-27-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
References: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During ioapic hotplug, acpi_register_ioapic will be called.
Now for x86, that function is blank.
Fill that will update __mp_register_ioapic to use those ioapic.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/acpi/boot.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 5be15d1..4a5336d 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -707,16 +707,18 @@ EXPORT_SYMBOL(acpi_unmap_lsapic);
 
 int acpi_register_ioapic(acpi_handle handle, u64 phys_addr, u32 gsi_base)
 {
-	/* TBD */
-	return -EINVAL;
+	unsigned long long id = 0;
+
+	acpi_evaluate_integer(handle, "_UID", NULL, &id);
+
+	return	__mp_register_ioapic(id, phys_addr, gsi_base, true);
 }
 
 EXPORT_SYMBOL(acpi_register_ioapic);
 
 int acpi_unregister_ioapic(acpi_handle handle, u32 gsi_base)
 {
-	/* TBD */
-	return -EINVAL;
+	return mp_unregister_ioapic(gsi_base);
 }
 
 EXPORT_SYMBOL(acpi_unregister_ioapic);
-- 
1.8.1.4

