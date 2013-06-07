Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab3FGWbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 18:31:53 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51360 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757285Ab3FGWbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 18:31:45 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 23/27] x86: Move declaration for mp_register_ioapic()
Date: Fri,  7 Jun 2013 15:31:09 -0700
Message-Id: <1370644273-10495-24-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1370644273-10495-1-git-send-email-yinghai@kernel.org>
References: <1370644273-10495-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Address compiling problem that Fengguang report.

Reported-by: Fengguang Wu <wfg@linux.intel.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/mpspec.h | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index e70b7e5..13439c5 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -95,10 +95,27 @@ static inline void early_reserve_e820_mpc_new(void) { }
 #endif
 
 void __cpuinit generic_processor_info(int apicid, int version);
-#ifdef CONFIG_ACPI
+
+#ifdef CONFIG_X86_IO_APIC
 int __mp_register_ioapic(int id, u32 address, u32 gsi_base, bool hot);
 int mp_unregister_ioapic(u32 gsi_base);
 extern void mp_register_ioapic(int id, u32 address, u32 gsi_base);
+#else
+static inline int __mp_register_ioapic(int id, u32 address, u32 gsi_base,
+					 bool hot)
+{
+	return 0;
+}
+static inline int mp_unregister_ioapic(u32 gsi_base)
+{
+	return 0;
+}
+static inline void mp_register_ioapic(int id, u32 address, u32 gsi_base)
+{
+}
+#endif
+
+#ifdef CONFIG_ACPI
 extern void mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
 				   u32 gsi);
 extern void mp_config_acpi_legacy_irqs(void);
-- 
1.8.1.4

