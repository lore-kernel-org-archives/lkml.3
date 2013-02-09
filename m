Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947522Ab3BIA1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 19:27:23 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:28339 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947333Ab3BIA1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 19:27:21 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 26-2/26] PCI, x86, ACPI: Link acpi ioapic register to ioapic
Date: Fri,  8 Feb 2013 16:26:44 -0800
Message-Id: <1360369606-8416-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360369606-8416-1-git-send-email-yinghai@kernel.org>
References: <CAE9FiQVhmH_TGqEwxGPusKNn-6Q7QkS3UTitEriV3dX8sPbzFA@mail.gmail.com>
 <1360369606-8416-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During ioapic hotplug, acpi_register_ioapic will be called.

Now for x86, that function is blank.

Fill that will update __mp_register_ioapic to use those ioapic.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/acpi/boot.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -696,16 +696,18 @@ EXPORT_SYMBOL(acpi_unmap_lsapic);
 
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
