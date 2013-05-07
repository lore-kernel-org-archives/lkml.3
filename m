Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435Ab3EGUrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 16:47:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:7025 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759403Ab3EGUrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 16:47:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,629,1363158000"; 
   d="scan'208";a="330469275"
Subject: [PATCH 1/7] consolidate per-arch stack overflow debugging options
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Tue, 07 May 2013 13:46:43 -0700
References: <20130507204642.D010DDC1@viggo.jf.intel.com>
In-Reply-To: <20130507204642.D010DDC1@viggo.jf.intel.com>
Message-Id: <20130507204643.3ACA416E@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave@linux.vnet.ibm.com>

Several architectures have similar stack debugging config options.
They all pretty much do the same thing, some with slightly
differing help text.

This patch changes the architectures to instead enable a Kconfig
boolean, and then use that boolean in the generic Kconfig.debug
to present the actual menu option.  This removes a bunch of
duplication and adds consistency across arches.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Reviewed-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: James Hogan <james.hogan@imgtec.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com> [for tile]
Signed-off-by: Dave Hansen <dave.hansen@intel.com>
---

 linux.git-davehans/arch/blackfin/Kconfig       |    1 +
 linux.git-davehans/arch/blackfin/Kconfig.debug |    7 -------
 linux.git-davehans/arch/frv/Kconfig            |    1 +
 linux.git-davehans/arch/frv/Kconfig.debug      |    4 ----
 linux.git-davehans/arch/m32r/Kconfig           |    1 +
 linux.git-davehans/arch/m32r/Kconfig.debug     |    7 -------
 linux.git-davehans/arch/mips/Kconfig           |    1 +
 linux.git-davehans/arch/mips/Kconfig.debug     |    9 ---------
 linux.git-davehans/arch/mn10300/Kconfig        |    1 +
 linux.git-davehans/arch/mn10300/Kconfig.debug  |    4 ----
 linux.git-davehans/arch/powerpc/Kconfig        |    1 +
 linux.git-davehans/arch/powerpc/Kconfig.debug  |    7 -------
 linux.git-davehans/arch/tile/Kconfig           |    1 +
 linux.git-davehans/arch/tile/Kconfig.debug     |    7 -------
 linux.git-davehans/arch/x86/Kconfig            |    1 +
 linux.git-davehans/arch/x86/Kconfig.debug      |   10 ----------
 linux.git-davehans/lib/Kconfig.debug           |   21 +++++++++++++++++++++
 17 files changed, 29 insertions(+), 55 deletions(-)

diff -puN arch/blackfin/Kconfig~consolidat-stack-debugging-configs arch/blackfin/Kconfig
--- linux.git/arch/blackfin/Kconfig~consolidat-stack-debugging-configs	2013-05-07 13:41:36.964469362 -0700
+++ linux.git-davehans/arch/blackfin/Kconfig	2013-05-07 13:41:36.994470697 -0700
@@ -41,6 +41,7 @@ config BLACKFIN
 	select ARCH_USES_GETTIMEOFFSET if !GENERIC_CLOCKEVENTS
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_RELA
+	select HAVE_DEBUG_STACKOVERFLOW
 
 config GENERIC_CSUM
 	def_bool y
diff -puN arch/blackfin/Kconfig.debug~consolidat-stack-debugging-configs arch/blackfin/Kconfig.debug
--- linux.git/arch/blackfin/Kconfig.debug~consolidat-stack-debugging-configs	2013-05-07 13:41:36.966469449 -0700
+++ linux.git-davehans/arch/blackfin/Kconfig.debug	2013-05-07 13:41:36.994470697 -0700
@@ -2,13 +2,6 @@ menu "Kernel hacking"
 
 source "lib/Kconfig.debug"
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
-	help
-	  This option will cause messages to be printed if free stack space
-	  drops below a certain limit.
-
 config DEBUG_VERBOSE
 	bool "Verbose fault messages"
 	default y
diff -puN arch/frv/Kconfig~consolidat-stack-debugging-configs arch/frv/Kconfig
--- linux.git/arch/frv/Kconfig~consolidat-stack-debugging-configs	2013-05-07 13:41:36.968469540 -0700
+++ linux.git-davehans/arch/frv/Kconfig	2013-05-07 13:41:36.995470740 -0700
@@ -14,6 +14,7 @@ config FRV
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select OLD_SIGSUSPEND3
 	select OLD_SIGACTION
+	select HAVE_DEBUG_STACKOVERFLOW
 
 config ZONE_DMA
 	bool
diff -puN arch/frv/Kconfig.debug~consolidat-stack-debugging-configs arch/frv/Kconfig.debug
--- linux.git/arch/frv/Kconfig.debug~consolidat-stack-debugging-configs	2013-05-07 13:41:36.969469585 -0700
+++ linux.git-davehans/arch/frv/Kconfig.debug	2013-05-07 13:41:36.995470740 -0700
@@ -2,10 +2,6 @@ menu "Kernel hacking"
 
 source "lib/Kconfig.debug"
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
-
 config GDBSTUB
 	bool "Remote GDB kernel debugging"
 	depends on DEBUG_KERNEL
diff -puN arch/m32r/Kconfig~consolidat-stack-debugging-configs arch/m32r/Kconfig
--- linux.git/arch/m32r/Kconfig~consolidat-stack-debugging-configs	2013-05-07 13:41:36.971469672 -0700
+++ linux.git-davehans/arch/m32r/Kconfig	2013-05-07 13:41:36.996470784 -0700
@@ -16,6 +16,7 @@ config M32R
 	select GENERIC_ATOMIC64
 	select ARCH_USES_GETTIMEOFFSET
 	select MODULES_USE_ELF_RELA
+	select HAVE_DEBUG_STACKOVERFLOW
 
 config SBUS
 	bool
diff -puN arch/m32r/Kconfig.debug~consolidat-stack-debugging-configs arch/m32r/Kconfig.debug
--- linux.git/arch/m32r/Kconfig.debug~consolidat-stack-debugging-configs	2013-05-07 13:41:36.972469716 -0700
+++ linux.git-davehans/arch/m32r/Kconfig.debug	2013-05-07 13:41:36.996470784 -0700
@@ -2,13 +2,6 @@ menu "Kernel hacking"
 
 source "lib/Kconfig.debug"
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
-	help
-	  This option will cause messages to be printed if free stack space
-	  drops below a certain limit.
-
 config DEBUG_PAGEALLOC
 	bool "Debug page memory allocations"
 	depends on DEBUG_KERNEL && BROKEN
diff -puN arch/mips/Kconfig~consolidat-stack-debugging-configs arch/mips/Kconfig
--- linux.git/arch/mips/Kconfig~consolidat-stack-debugging-configs	2013-05-07 13:41:36.974469807 -0700
+++ linux.git-davehans/arch/mips/Kconfig	2013-05-07 13:41:36.997470829 -0700
@@ -42,6 +42,7 @@ config MIPS
 	select MODULES_USE_ELF_REL if MODULES
 	select MODULES_USE_ELF_RELA if MODULES && 64BIT
 	select CLONE_BACKWARDS
+	select HAVE_DEBUG_STACKOVERFLOW
 
 menu "Machine selection"
 
diff -puN arch/mips/Kconfig.debug~consolidat-stack-debugging-configs arch/mips/Kconfig.debug
--- linux.git/arch/mips/Kconfig.debug~consolidat-stack-debugging-configs	2013-05-07 13:41:36.976469896 -0700
+++ linux.git-davehans/arch/mips/Kconfig.debug	2013-05-07 13:41:36.997470829 -0700
@@ -67,15 +67,6 @@ config CMDLINE_OVERRIDE
 
 	  Normally, you will choose 'N' here.
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
-	help
-	  This option will cause messages to be printed if free stack space
-	  drops below a certain limit(2GB on MIPS). The debugging option
-	  provides another way to check stack overflow happened on kernel mode
-	  stack usually caused by nested interruption.
-
 config SMTC_IDLE_HOOK_DEBUG
 	bool "Enable additional debug checks before going into CPU idle loop"
 	depends on DEBUG_KERNEL && MIPS_MT_SMTC
diff -puN arch/mn10300/Kconfig~consolidat-stack-debugging-configs arch/mn10300/Kconfig
--- linux.git/arch/mn10300/Kconfig~consolidat-stack-debugging-configs	2013-05-07 13:41:36.977469939 -0700
+++ linux.git-davehans/arch/mn10300/Kconfig	2013-05-07 13:41:36.998470875 -0700
@@ -13,6 +13,7 @@ config MN10300
 	select MODULES_USE_ELF_RELA
 	select OLD_SIGSUSPEND3
 	select OLD_SIGACTION
+	select HAVE_DEBUG_STACKOVERFLOW
 
 config AM33_2
 	def_bool n
diff -puN arch/mn10300/Kconfig.debug~consolidat-stack-debugging-configs arch/mn10300/Kconfig.debug
--- linux.git/arch/mn10300/Kconfig.debug~consolidat-stack-debugging-configs	2013-05-07 13:41:36.979470028 -0700
+++ linux.git-davehans/arch/mn10300/Kconfig.debug	2013-05-07 13:41:36.998470875 -0700
@@ -2,10 +2,6 @@ menu "Kernel hacking"
 
 source "lib/Kconfig.debug"
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
-
 config DEBUG_DECOMPRESS_KERNEL
 	bool "Using serial port during decompressing kernel"
 	depends on DEBUG_KERNEL
diff -puN arch/powerpc/Kconfig~consolidat-stack-debugging-configs arch/powerpc/Kconfig
--- linux.git/arch/powerpc/Kconfig~consolidat-stack-debugging-configs	2013-05-07 13:41:36.980470074 -0700
+++ linux.git-davehans/arch/powerpc/Kconfig	2013-05-07 13:41:36.998470875 -0700
@@ -143,6 +143,7 @@ config PPC
 	select ARCH_USE_BUILTIN_BSWAP
 	select OLD_SIGSUSPEND
 	select OLD_SIGACTION if PPC32
+	select HAVE_DEBUG_STACKOVERFLOW
 
 config EARLY_PRINTK
 	bool
diff -puN arch/powerpc/Kconfig.debug~consolidat-stack-debugging-configs arch/powerpc/Kconfig.debug
--- linux.git/arch/powerpc/Kconfig.debug~consolidat-stack-debugging-configs	2013-05-07 13:41:36.982470163 -0700
+++ linux.git-davehans/arch/powerpc/Kconfig.debug	2013-05-07 13:41:36.999470920 -0700
@@ -28,13 +28,6 @@ config PRINT_STACK_DEPTH
 	  too small and stack traces cause important information to
 	  scroll off the screen.
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
-	help
-	  This option will cause messages to be printed if free stack space
-	  drops below a certain limit.
-
 config HCALL_STATS
 	bool "Hypervisor call instrumentation"
 	depends on PPC_PSERIES && DEBUG_FS && TRACEPOINTS
diff -puN arch/tile/Kconfig~consolidat-stack-debugging-configs arch/tile/Kconfig
--- linux.git/arch/tile/Kconfig~consolidat-stack-debugging-configs	2013-05-07 13:41:36.984470250 -0700
+++ linux.git-davehans/arch/tile/Kconfig	2013-05-07 13:41:36.999470920 -0700
@@ -25,6 +25,7 @@ config TILE
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_SYSCALL_TRACEPOINTS
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
+	select HAVE_DEBUG_STACKOVERFLOW
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
diff -puN arch/tile/Kconfig.debug~consolidat-stack-debugging-configs arch/tile/Kconfig.debug
--- linux.git/arch/tile/Kconfig.debug~consolidat-stack-debugging-configs	2013-05-07 13:41:36.985470295 -0700
+++ linux.git-davehans/arch/tile/Kconfig.debug	2013-05-07 13:41:37.000470964 -0700
@@ -14,13 +14,6 @@ config EARLY_PRINTK
 	  with klogd/syslogd. You should normally N here,
 	  unless you want to debug such a crash.
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
-	help
-	  This option will cause messages to be printed if free stack space
-	  drops below a certain limit.
-
 config DEBUG_EXTRA_FLAGS
 	string "Additional compiler arguments when building with '-g'"
 	depends on DEBUG_INFO
diff -puN arch/x86/Kconfig~consolidat-stack-debugging-configs arch/x86/Kconfig
--- linux.git/arch/x86/Kconfig~consolidat-stack-debugging-configs	2013-05-07 13:41:36.987470386 -0700
+++ linux.git-davehans/arch/x86/Kconfig	2013-05-07 13:41:37.001471007 -0700
@@ -122,6 +122,7 @@ config X86
 	select OLD_SIGACTION if X86_32
 	select COMPAT_OLD_SIGACTION if IA32_EMULATION
 	select RTC_LIB
+	select HAVE_DEBUG_STACKOVERFLOW
 
 config INSTRUCTION_DECODER
 	def_bool y
diff -puN arch/x86/Kconfig.debug~consolidat-stack-debugging-configs arch/x86/Kconfig.debug
--- linux.git/arch/x86/Kconfig.debug~consolidat-stack-debugging-configs	2013-05-07 13:41:36.989470473 -0700
+++ linux.git-davehans/arch/x86/Kconfig.debug	2013-05-07 13:41:37.001471007 -0700
@@ -59,16 +59,6 @@ config EARLY_PRINTK_DBGP
 	  with klogd/syslogd or the X server. You should normally N here,
 	  unless you want to debug such a crash. You need usb debug device.
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
-	---help---
-	  Say Y here if you want to check the overflows of kernel, IRQ
-	  and exception stacks. This option will cause messages of the
-	  stacks in detail when free stack space drops below a certain
-	  limit.
-	  If in doubt, say "N".
-
 config X86_PTDUMP
 	bool "Export kernel pagetable layout to userspace via debugfs"
 	depends on DEBUG_KERNEL
diff -puN lib/Kconfig.debug~consolidat-stack-debugging-configs lib/Kconfig.debug
--- linux.git/lib/Kconfig.debug~consolidat-stack-debugging-configs	2013-05-07 13:41:36.991470562 -0700
+++ linux.git-davehans/lib/Kconfig.debug	2013-05-07 13:41:37.002471051 -0700
@@ -1475,6 +1475,27 @@ config ASYNC_RAID6_TEST
 
 	  If unsure, say N.
 
+config HAVE_DEBUG_STACKOVERFLOW
+	bool
+
+config DEBUG_STACKOVERFLOW
+	bool "Check for stack overflows"
+	depends on DEBUG_KERNEL && HAVE_DEBUG_STACKOVERFLOW
+	---help---
+	  Say Y here if you want to check for overflows of kernel, IRQ
+	  and exception stacks (if your archicture uses them). This
+	  option will show detailed messages if free stack space drops
+	  below a certain limit.
+
+	  These kinds of bugs usually occur when call-chains in the
+	  kernel get too deep, especially when interrupts are
+	  involved.
+
+	  Use this in cases where you see apparently random memory
+	  corruption, especially if it appears in 'struct thread_info'
+
+	  If in doubt, say "N".
+
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
_
