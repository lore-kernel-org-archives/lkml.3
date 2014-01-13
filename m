Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbaAMTXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:23:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:3146 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbaAMTXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:23:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,654,1384329600"; 
   d="scan'208";a="458081189"
Subject: [PATCH 05/12] x86 Kconfig: processor drivers
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 13 Jan 2014 11:22:51 -0800
References: <20140113192245.3F682C7F@viggo.jf.intel.com>
In-Reply-To: <20140113192245.3F682C7F@viggo.jf.intel.com>
Message-Id: <20140113192251.9FC5473D@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

These are both drivers to access very cpu and arch-specific
features.  However, they are probably not very commonly changed
in the configuration.  Give them their own menu.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/arch/x86/Kconfig |  169 ++++++++++++++++++------------------
 1 file changed, 86 insertions(+), 83 deletions(-)

diff -puN arch/x86/Kconfig~processor-drivers arch/x86/Kconfig
--- linux.git/arch/x86/Kconfig~processor-drivers	2014-01-13 11:11:35.346198391 -0800
+++ linux.git-davehans/arch/x86/Kconfig	2014-01-13 11:11:35.348198482 -0800
@@ -396,6 +396,92 @@ config X86_SMAP
 
 	  If unsure, say Y.
 
+comment "Processor Feature Drivers"
+
+config MICROCODE
+	tristate "CPU microcode loading support"
+	depends on CPU_SUP_AMD || CPU_SUP_INTEL
+	select FW_LOADER
+	---help---
+
+	  If you say Y here, you will be able to update the microcode on
+	  certain Intel and AMD processors. The Intel support is for the
+	  IA32 family, e.g. Pentium Pro, Pentium II, Pentium III, Pentium 4,
+	  Xeon etc. The AMD support is for families 0x10 and later. You will
+	  obviously need the actual microcode binary data itself which is not
+	  shipped with the Linux kernel.
+
+	  This option selects the general module only, you need to select
+	  at least one vendor specific module as well.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called microcode.
+
+config MICROCODE_INTEL
+	bool "Intel microcode loading support"
+	depends on MICROCODE
+	default MICROCODE
+	select FW_LOADER
+	---help---
+	  This options enables microcode patch loading support for Intel
+	  processors.
+
+	  For latest news and information on obtaining all the required
+	  Intel ingredients for this driver, check:
+	  <http://www.urbanmyth.org/microcode/>.
+
+config MICROCODE_AMD
+	bool "AMD microcode loading support"
+	depends on MICROCODE
+	select FW_LOADER
+	---help---
+	  If you select this option, microcode patch loading support for AMD
+	  processors will be enabled.
+
+config MICROCODE_OLD_INTERFACE
+	def_bool y
+	depends on MICROCODE
+
+config MICROCODE_INTEL_LIB
+	def_bool y
+	depends on MICROCODE_INTEL
+
+config MICROCODE_INTEL_EARLY
+	def_bool n
+
+config MICROCODE_AMD_EARLY
+	def_bool n
+
+config MICROCODE_EARLY
+	bool "Early load microcode"
+	depends on MICROCODE=y && BLK_DEV_INITRD
+	select MICROCODE_INTEL_EARLY if MICROCODE_INTEL
+	select MICROCODE_AMD_EARLY if MICROCODE_AMD
+	default y
+	help
+	  This option provides functionality to read additional microcode data
+	  at the beginning of initrd image. The data tells kernel to load
+	  microcode to CPU's as early as possible. No functional change if no
+	  microcode data is glued to the initrd, therefore it's safe to say Y.
+
+config X86_MSR
+	tristate "/dev/cpu/*/msr - Model-specific register support"
+	---help---
+	  This device gives privileged processes access to the x86
+	  Model-Specific Registers (MSRs).  It is a character device with
+	  major 202 and minors 0 to 31 for /dev/cpu/0/msr to /dev/cpu/31/msr.
+	  MSR accesses are directed to a specific CPU on multi-processor
+	  systems.
+
+config X86_CPUID
+	tristate "/dev/cpu/*/cpuid - CPU information support"
+	---help---
+	  This device gives processes access to the x86 CPUID instruction to
+	  be executed on a specific processor.  It is a character device
+	  with major 203 and minors 0 to 31 for /dev/cpu/0/cpuid to
+	  /dev/cpu/31/cpuid.
+
+
 endmenu # Processor Options
 
 config X86_X2APIC
@@ -1293,89 +1379,6 @@ config X86_REBOOTFIXUPS
 	  enable this option even if you don't need it.
 	  Say N otherwise.
 
-config MICROCODE
-	tristate "CPU microcode loading support"
-	depends on CPU_SUP_AMD || CPU_SUP_INTEL
-	select FW_LOADER
-	---help---
-
-	  If you say Y here, you will be able to update the microcode on
-	  certain Intel and AMD processors. The Intel support is for the
-	  IA32 family, e.g. Pentium Pro, Pentium II, Pentium III, Pentium 4,
-	  Xeon etc. The AMD support is for families 0x10 and later. You will
-	  obviously need the actual microcode binary data itself which is not
-	  shipped with the Linux kernel.
-
-	  This option selects the general module only, you need to select
-	  at least one vendor specific module as well.
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called microcode.
-
-config MICROCODE_INTEL
-	bool "Intel microcode loading support"
-	depends on MICROCODE
-	default MICROCODE
-	select FW_LOADER
-	---help---
-	  This options enables microcode patch loading support for Intel
-	  processors.
-
-	  For latest news and information on obtaining all the required
-	  Intel ingredients for this driver, check:
-	  <http://www.urbanmyth.org/microcode/>.
-
-config MICROCODE_AMD
-	bool "AMD microcode loading support"
-	depends on MICROCODE
-	select FW_LOADER
-	---help---
-	  If you select this option, microcode patch loading support for AMD
-	  processors will be enabled.
-
-config MICROCODE_OLD_INTERFACE
-	def_bool y
-	depends on MICROCODE
-
-config MICROCODE_INTEL_LIB
-	def_bool y
-	depends on MICROCODE_INTEL
-
-config MICROCODE_INTEL_EARLY
-	def_bool n
-
-config MICROCODE_AMD_EARLY
-	def_bool n
-
-config MICROCODE_EARLY
-	bool "Early load microcode"
-	depends on MICROCODE=y && BLK_DEV_INITRD
-	select MICROCODE_INTEL_EARLY if MICROCODE_INTEL
-	select MICROCODE_AMD_EARLY if MICROCODE_AMD
-	default y
-	help
-	  This option provides functionality to read additional microcode data
-	  at the beginning of initrd image. The data tells kernel to load
-	  microcode to CPU's as early as possible. No functional change if no
-	  microcode data is glued to the initrd, therefore it's safe to say Y.
-
-config X86_MSR
-	tristate "/dev/cpu/*/msr - Model-specific register support"
-	---help---
-	  This device gives privileged processes access to the x86
-	  Model-Specific Registers (MSRs).  It is a character device with
-	  major 202 and minors 0 to 31 for /dev/cpu/0/msr to /dev/cpu/31/msr.
-	  MSR accesses are directed to a specific CPU on multi-processor
-	  systems.
-
-config X86_CPUID
-	tristate "/dev/cpu/*/cpuid - CPU information support"
-	---help---
-	  This device gives processes access to the x86 CPUID instruction to
-	  be executed on a specific processor.  It is a character device
-	  with major 203 and minors 0 to 31 for /dev/cpu/0/cpuid to
-	  /dev/cpu/31/cpuid.
-
 config MATH_EMULATION
 	bool
 	prompt "Math emulation" if X86_32
_
