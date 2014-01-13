Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbaAMTZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:25:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:2008 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbaAMTXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:23:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,654,1384329600"; 
   d="scan'208";a="438183703"
Subject: [PATCH 01/12] x86 Kconfig: create extended platforms menu
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 13 Jan 2014 11:22:46 -0800
References: <20140113192245.3F682C7F@viggo.jf.intel.com>
In-Reply-To: <20140113192245.3F682C7F@viggo.jf.intel.com>
Message-Id: <20140113192246.2637BC0B@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

This takes the relatively obscure (NUMA-Q anyone?) platforms
(both 32 and 64-bit) and sticks them in their own menu.
Virtually nobody needs to set these, and those that do know how
to find them the hard way.

The new menu is also moved to the end of the x86 options.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/arch/x86/Kconfig |  293 +++++++++++++++++-------------------
 1 file changed, 141 insertions(+), 152 deletions(-)

diff -puN arch/x86/Kconfig~x86-extended-platforms arch/x86/Kconfig
--- linux.git/arch/x86/Kconfig~x86-extended-platforms	2014-01-13 11:11:34.511160641 -0800
+++ linux.git-davehans/arch/x86/Kconfig	2014-01-13 11:11:34.514160776 -0800
@@ -331,122 +331,6 @@ config GOLDFISH
        def_bool y
        depends on X86_GOLDFISH
 
-if X86_32
-config X86_EXTENDED_PLATFORM
-	bool "Support for extended (non-PC) x86 platforms"
-	default y
-	---help---
-	  If you disable this option then the kernel will only support
-	  standard PC platforms. (which covers the vast majority of
-	  systems out there.)
-
-	  If you enable this option then you'll be able to select support
-	  for the following (non-PC) 32 bit x86 platforms:
-		Goldfish (Android emulator)
-		AMD Elan
-		NUMAQ (IBM/Sequent)
-		RDC R-321x SoC
-		SGI 320/540 (Visual Workstation)
-		STA2X11-based (e.g. Northville)
-		Summit/EXA (IBM x440)
-		Unisys ES7000 IA32 series
-		Moorestown MID devices
-
-	  If you have one of these systems, or if you want to build a
-	  generic distribution kernel, say Y here - otherwise say N.
-endif
-
-if X86_64
-config X86_EXTENDED_PLATFORM
-	bool "Support for extended (non-PC) x86 platforms"
-	default y
-	---help---
-	  If you disable this option then the kernel will only support
-	  standard PC platforms. (which covers the vast majority of
-	  systems out there.)
-
-	  If you enable this option then you'll be able to select support
-	  for the following (non-PC) 64 bit x86 platforms:
-		Numascale NumaChip
-		ScaleMP vSMP
-		SGI Ultraviolet
-
-	  If you have one of these systems, or if you want to build a
-	  generic distribution kernel, say Y here - otherwise say N.
-endif
-# This is an alphabetically sorted list of 64 bit extended platforms
-# Please maintain the alphabetic order if and when there are additions
-config X86_NUMACHIP
-	bool "Numascale NumaChip"
-	depends on X86_64
-	depends on X86_EXTENDED_PLATFORM
-	depends on NUMA
-	depends on SMP
-	depends on X86_X2APIC
-	depends on PCI_MMCONFIG
-	---help---
-	  Adds support for Numascale NumaChip large-SMP systems. Needed to
-	  enable more than ~168 cores.
-	  If you don't have one of these, you should say N here.
-
-config X86_VSMP
-	bool "ScaleMP vSMP"
-	select HYPERVISOR_GUEST
-	select PARAVIRT
-	depends on X86_64 && PCI
-	depends on X86_EXTENDED_PLATFORM
-	depends on SMP
-	---help---
-	  Support for ScaleMP vSMP systems.  Say 'Y' here if this kernel is
-	  supposed to run on these EM64T-based machines.  Only choose this option
-	  if you have one of these machines.
-
-config X86_UV
-	bool "SGI Ultraviolet"
-	depends on X86_64
-	depends on X86_EXTENDED_PLATFORM
-	depends on NUMA
-	depends on X86_X2APIC
-	---help---
-	  This option is needed in order to support SGI Ultraviolet systems.
-	  If you don't have one of these, you should say N here.
-
-# Following is an alphabetically sorted list of 32 bit extended platforms
-# Please maintain the alphabetic order if and when there are additions
-
-config X86_GOLDFISH
-       bool "Goldfish (Virtual Platform)"
-       depends on X86_32
-       depends on X86_EXTENDED_PLATFORM
-       ---help---
-	 Enable support for the Goldfish virtual platform used primarily
-	 for Android development. Unless you are building for the Android
-	 Goldfish emulator say N here.
-
-config X86_INTEL_CE
-	bool "CE4100 TV platform"
-	depends on PCI
-	depends on PCI_GODIRECT
-	depends on X86_32
-	depends on X86_EXTENDED_PLATFORM
-	select X86_REBOOTFIXUPS
-	select OF
-	select OF_EARLY_FLATTREE
-	select IRQ_DOMAIN
-	---help---
-	  Select for the Intel CE media processor (CE4100) SOC.
-	  This option compiles in support for the CE4100 SOC for settop
-	  boxes and media devices.
-
-config X86_WANT_INTEL_MID
-	bool "Intel MID platform support"
-	depends on X86_32
-	depends on X86_EXTENDED_PLATFORM
-	---help---
-	  Select to build a kernel capable of supporting Intel MID platform
-	  systems which do not have the PCI legacy interfaces (Moorestown,
-	  Medfield). If you are building for a PC class system say N here.
-
 if X86_WANT_INTEL_MID
 
 config X86_INTEL_MID
@@ -486,42 +370,6 @@ config X86_INTEL_LPSS
 	  things like clock tree (common clock framework) and pincontrol
 	  which are needed by the LPSS peripheral drivers.
 
-config X86_RDC321X
-	bool "RDC R-321x SoC"
-	depends on X86_32
-	depends on X86_EXTENDED_PLATFORM
-	select M486
-	select X86_REBOOTFIXUPS
-	---help---
-	  This option is needed for RDC R-321x system-on-chip, also known
-	  as R-8610-(G).
-	  If you don't have one of these chips, you should say N here.
-
-config X86_32_NON_STANDARD
-	bool "Support non-standard 32-bit SMP architectures"
-	depends on X86_32 && SMP
-	depends on X86_EXTENDED_PLATFORM
-	---help---
-	  This option compiles in the NUMAQ, Summit, bigsmp, ES7000,
-	  STA2X11, default subarchitectures.  It is intended for a generic
-	  binary kernel. If you select them all, kernel will probe it
-	  one by one and will fallback to default.
-
-# Alphabetically sorted list of Non standard 32 bit platforms
-
-config X86_NUMAQ
-	bool "NUMAQ (IBM/Sequent)"
-	depends on X86_32_NON_STANDARD
-	depends on PCI
-	select NUMA
-	select X86_MPPARSE
-	---help---
-	  This option is used for getting Linux to run on a NUMAQ (IBM/Sequent)
-	  NUMA multiquad box. This changes the way that processors are
-	  bootstrapped, and uses Clustered Logical APIC addressing mode instead
-	  of Flat Logical.  You will need a new lynxer.elf file to flash your
-	  firmware with - send email to <Martin.Bligh@us.ibm.com>.
-
 config X86_SUPPORTS_MEMORY_FAILURE
 	def_bool y
 	# MCE code calls memory_failure():
@@ -1872,6 +1720,147 @@ config CMDLINE_OVERRIDE
 	  This is used to work around broken boot loaders.  This should
 	  be set to 'N' under normal conditions.
 
+menuconfig X86_EXTENDED_PLATFORM
+	bool "Support for extended (non-PC) x86 platforms"
+	default y
+	---help---
+	  If you disable this option then the kernel will only support
+	  standard PC platforms. (which covers the vast majority of
+	  systems out there.)
+
+	  If you enable this option then you'll be able to select support
+	  for the following (non-PC) 64 bit x86 platforms:
+		Numascale NumaChip
+		ScaleMP vSMP
+		SGI Ultraviolet
+
+	  and these (non-PC) 32 bit x86 platforms:
+		Goldfish (Android emulator)
+		AMD Elan
+		NUMAQ (IBM/Sequent)
+		RDC R-321x SoC
+		SGI 320/540 (Visual Workstation)
+		STA2X11-based (e.g. Northville)
+		Summit/EXA (IBM x440)
+		Unisys ES7000 IA32 series
+		Moorestown MID devices
+
+	  If you have one of these systems, or if you want to build a
+	  generic distribution kernel, say Y here - otherwise say N.
+
+if X86_EXTENDED_PLATFORM
+
+# This is an alphabetically sorted list of 64 bit extended platforms
+# Please maintain the alphabetic order if and when there are additions
+config X86_NUMACHIP
+	bool "Numascale NumaChip"
+	depends on X86_64
+	depends on X86_EXTENDED_PLATFORM
+	depends on NUMA
+	depends on SMP
+	depends on X86_X2APIC
+	depends on PCI_MMCONFIG
+	---help---
+	  Adds support for Numascale NumaChip large-SMP systems. Needed to
+	  enable more than ~168 cores.
+	  If you don't have one of these, you should say N here.
+
+config X86_VSMP
+	bool "ScaleMP vSMP"
+	select HYPERVISOR_GUEST
+	select PARAVIRT
+	depends on X86_64 && PCI
+	depends on X86_EXTENDED_PLATFORM
+	depends on SMP
+	---help---
+	  Support for ScaleMP vSMP systems.  Say 'Y' here if this kernel is
+	  supposed to run on these EM64T-based machines.  Only choose this option
+	  if you have one of these machines.
+
+config X86_UV
+	bool "SGI Ultraviolet"
+	depends on X86_64
+	depends on X86_EXTENDED_PLATFORM
+	depends on NUMA
+	depends on X86_X2APIC
+	---help---
+	  This option is needed in order to support SGI Ultraviolet systems.
+	  If you don't have one of these, you should say N here.
+
+# Following is an alphabetically sorted list of 32 bit extended platforms
+# Please maintain the alphabetic order if and when there are additions
+
+config X86_GOLDFISH
+       bool "Goldfish (Virtual Platform)"
+       depends on X86_32
+       depends on X86_EXTENDED_PLATFORM
+       ---help---
+	 Enable support for the Goldfish virtual platform used primarily
+	 for Android development. Unless you are building for the Android
+	 Goldfish emulator say N here.
+
+config X86_INTEL_CE
+	bool "CE4100 TV platform"
+	depends on PCI
+	depends on PCI_GODIRECT
+	depends on X86_32
+	depends on X86_EXTENDED_PLATFORM
+	select X86_REBOOTFIXUPS
+	select OF
+	select OF_EARLY_FLATTREE
+	select IRQ_DOMAIN
+	---help---
+	  Select for the Intel CE media processor (CE4100) SOC.
+	  This option compiles in support for the CE4100 SOC for settop
+	  boxes and media devices.
+
+config X86_WANT_INTEL_MID
+	bool "Intel MID platform support"
+	depends on X86_32
+	depends on X86_EXTENDED_PLATFORM
+	---help---
+	  Select to build a kernel capable of supporting Intel MID platform
+	  systems which do not have the PCI legacy interfaces (Moorestown,
+	  Medfield). If you are building for a PC class system say N here.
+
+config X86_RDC321X
+	bool "RDC R-321x SoC"
+	depends on X86_32
+	depends on X86_EXTENDED_PLATFORM
+	select M486
+	select X86_REBOOTFIXUPS
+	---help---
+	  This option is needed for RDC R-321x system-on-chip, also known
+	  as R-8610-(G).
+	  If you don't have one of these chips, you should say N here.
+
+config X86_32_NON_STANDARD
+	bool "Support non-standard 32-bit SMP architectures"
+	depends on X86_32 && SMP
+	depends on X86_EXTENDED_PLATFORM
+	---help---
+	  This option compiles in the NUMAQ, Summit, bigsmp, ES7000,
+	  STA2X11, default subarchitectures.  It is intended for a generic
+	  binary kernel. If you select them all, kernel will probe it
+	  one by one and will fallback to default.
+
+# Alphabetically sorted list of Non standard 32 bit platforms
+
+config X86_NUMAQ
+	bool "NUMAQ (IBM/Sequent)"
+	depends on X86_32_NON_STANDARD
+	depends on PCI
+	select NUMA
+	select X86_MPPARSE
+	---help---
+	  This option is used for getting Linux to run on a NUMAQ (IBM/Sequent)
+	  NUMA multiquad box. This changes the way that processors are
+	  bootstrapped, and uses Clustered Logical APIC addressing mode instead
+	  of Flat Logical.  You will need a new lynxer.elf file to flash your
+	  firmware with - send email to <Martin.Bligh@us.ibm.com>.
+
+endif # X86_EXTENDED_PLATFORM
+
 endmenu
 
 config ARCH_ENABLE_MEMORY_HOTPLUG
_
