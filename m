Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab3LRJPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:15:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:51262 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696Ab3LRJHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:07:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,506,1384329600"; 
   d="scan'208";a="446200626"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [RFC PATCH 12/15] ACPICA: Linux: Add configuration item to indicate the architecture specific support.
Date: Wed, 18 Dec 2013 17:07:03 +0800
Message-Id: <8bee37bba5b1268482d2e57544078c623923fa68.1387336613.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1387336613.git.lv.zheng@intel.com>
References: <cover.1387336613.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a kernel configuration item to indicate the presense of
the architecture specific support for ACPICA, so that <asm/acenv.h>
inclusion can be configured out.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 arch/ia64/Kconfig               |    1 +
 arch/x86/Kconfig                |    1 +
 drivers/acpi/Kconfig            |    4 ++++
 include/acpi/platform/aclinux.h |    2 ++
 4 files changed, 8 insertions(+)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 4e4119b..c38cc47 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -43,6 +43,7 @@ config IA64
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_RELA
 	select ARCH_USE_CMPXCHG_LOCKREF
+	select ARCH_SUPPORTS_ACPICA
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e903c71..0fd5a4d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -124,6 +124,7 @@ config X86
 	select RTC_LIB
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_IRQ_EXIT_ON_IRQ_STACK if X86_64
+	select ARCH_SUPPORTS_ACPICA
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 5d92485..22e5762 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -2,8 +2,12 @@
 # ACPI Configuration
 #
 
+config ARCH_SUPPORTS_ACPICA
+	bool
+
 menuconfig ACPI
 	bool "ACPI (Advanced Configuration and Power Interface) Support"
+	depends on ARCH_SUPPORTS_ACPICA
 	depends on !IA64_HP_SIM
 	depends on IA64 || X86
 	depends on PCI
diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index 8176181..b754bfa 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -80,7 +80,9 @@
 #ifdef EXPORT_ACPI_INTERFACES
 #include <linux/export.h>
 #endif
+#ifdef CONFIG_ARCH_SUPPORTS_ACPICA
 #include <asm/acenv.h>
+#endif
 #include <asm/acpi.h>
 
 #ifdef CONFIG_ACPI
-- 
1.7.10.4

