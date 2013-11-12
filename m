Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab3KLUBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 15:01:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:43874 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753735Ab3KLUBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 15:01:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="434107371"
From: David Cohen <david.a.cohen@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH] x86: intel-mid: remove deprecated X86_MDFLD and X86_WANT_INTEL_MID configs
Date: Tue, 12 Nov 2013 12:05:34 -0800
Message-Id: <1384286734-23848-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to support all Intel Mid platforms with a single config
selection. This patch removes deprecated CONFIG_X86_MDFLD and
X86_WANT_INTEL_MID options in favor of having CONFIG_X86_INTEL_MID only.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 arch/x86/Kconfig | 30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f67e839f06c8..c5f3414e453d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -440,42 +440,22 @@ config X86_INTEL_CE
 	  This option compiles in support for the CE4100 SOC for settop
 	  boxes and media devices.
 
-config X86_WANT_INTEL_MID
+config X86_INTEL_MID
 	bool "Intel MID platform support"
 	depends on X86_32
 	depends on X86_EXTENDED_PLATFORM
-	---help---
-	  Select to build a kernel capable of supporting Intel MID platform
-	  systems which do not have the PCI legacy interfaces (Moorestown,
-	  Medfield). If you are building for a PC class system say N here.
-
-if X86_WANT_INTEL_MID
-
-config X86_INTEL_MID
-	bool
-
-config X86_MDFLD
-       bool "Medfield MID platform"
 	depends on PCI
 	depends on PCI_GOANY
 	depends on X86_IO_APIC
-	select X86_INTEL_MID
-	select SFI
 	select DW_APB_TIMER
 	select APB_TIMER
-	select I2C
-	select SPI
 	select INTEL_SCU_IPC
-	select X86_PLATFORM_DEVICES
 	select MFD_INTEL_MSIC
-	---help---
-	  Medfield is Intel's Low Power Intel Architecture (LPIA) based Moblin
-	  Internet Device(MID) platform. 
-	  Unlike standard x86 PCs, Medfield does not have many legacy devices
-	  nor standard legacy replacement devices/features. e.g. Medfield does
-	  not contain i8259, i8254, HPET, legacy BIOS, most of the io ports.
 
-endif
+	---help---
+	  Select to build a kernel capable of supporting Intel MID platform
+	  systems which do not have the PCI legacy interfaces (Moorestown,
+	  Medfield). If you are building for a PC class system say N here.
 
 config X86_INTEL_LPSS
 	bool "Intel Low Power Subsystem Support"
-- 
1.8.4.2

