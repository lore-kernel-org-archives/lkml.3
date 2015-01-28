Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbbA1U4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:56:03 -0500
Received: from outbound-smtp03.blacknight.com ([81.17.249.16]:48247 "EHLO
	outbound-smtp03.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754416AbbA1Uz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:55:59 -0500
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        dvhart@infradead.org, andy.shevchenko@gmail.com,
        boon.leong.ong@intel.com, linux-kernel@vger.kernel.org
Cc: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Subject: [PATCH v5 2/2] x86, quark: Add Intel Quark platform support
Date: Wed, 28 Jan 2015 15:00:42 +0000
Message-Id: <1422457242-18095-3-git-send-email-pure.logic@nexus-software.ie>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422457242-18095-1-git-send-email-pure.logic@nexus-software.ie>
References: <1422457242-18095-1-git-send-email-pure.logic@nexus-software.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Intel Quark platform support. Quark needs to pull down all unlocked IMRs
to ensure agreement with the EFI memory map post boot.

This patch adds an entry in Kconfig for Quark as a platform and makes IMR
support mandatory if selected.

Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 arch/x86/Kconfig           | 16 ++++++++++++++++
 arch/x86/platform/Makefile |  1 +
 2 files changed, 17 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0dc9d01..36d50cd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -485,6 +485,22 @@ config X86_INTEL_MID
 	  Intel MID platforms are based on an Intel processor and chipset which
 	  consume less power than most of the x86 derivatives.
 
+config X86_INTEL_QUARK
+	bool "Intel Quark platform support"
+	depends on X86_32
+	depends on X86_EXTENDED_PLATFORM
+	depends on X86_PLATFORM_DEVICES
+	depends on X86_TSC
+	depends on PCI
+	depends on PCI_GOANY
+	depends on X86_IO_APIC
+	select IOSF_MBI
+	select INTEL_IMR
+	---help---
+	  Select to include support for Quark X1000 SoC.
+	  Say Y here if you have a Quark based system such as the Arduino
+	  compatible Intel Galileo.
+
 config X86_INTEL_LPSS
 	bool "Intel Low Power Subsystem Support"
 	depends on ACPI
diff --git a/arch/x86/platform/Makefile b/arch/x86/platform/Makefile
index 85afde1..a62e0be 100644
--- a/arch/x86/platform/Makefile
+++ b/arch/x86/platform/Makefile
@@ -5,6 +5,7 @@ obj-y	+= geode/
 obj-y	+= goldfish/
 obj-y	+= iris/
 obj-y	+= intel-mid/
+obj-y	+= intel-quark/
 obj-y	+= olpc/
 obj-y	+= scx200/
 obj-y	+= sfi/
-- 
1.9.1

