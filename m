Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbaACATk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:19:40 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21568 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbaACAGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:06:21 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiang Liu <jiang.liu@huawei.com>
Subject: [PATCH v5 24/33] x86: Move declaration for mp_register_ioapic()
Date: Thu,  2 Jan 2014 16:05:56 -0800
Message-Id: <1388707565-16535-25-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
References: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Address compiling problem that Fengguang report.

Reported-by: Fengguang Wu <wfg@linux.intel.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
---
 arch/x86/include/asm/mpspec.h | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index b98665f..e9d850e 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -95,10 +95,26 @@ static inline void early_reserve_e820_mpc_new(void) { }
 #endif
 
 int generic_processor_info(int apicid, int version);
-#ifdef CONFIG_ACPI
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
1.8.4

