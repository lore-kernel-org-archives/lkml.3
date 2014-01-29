Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaA2TKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 14:10:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:9284 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbaA2TKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 14:10:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,743,1384329600"; 
   d="scan'208";a="446597310"
Subject: [PATCH] kconfig: consolidate arch-specific seccomp options
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, Dave Hansen <dave@sr71.net>,
        linux-security-module@vger.kernel.org, linux-arch@vger.kernel.org,
        sfr@canb.auug.org.au, zohar@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        monstr@monstr.eu, ralf@linux-mips.org, benh@kernel.crashing.org,
        paulus@samba.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        lethal@linux-sh.org, x86@kernel.org, james.l.morris@oracle.com
From: Dave Hansen <dave@sr71.net>
Date: Wed, 29 Jan 2014 11:10:11 -0800
Message-Id: <20140129191011.8FB63DFA@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are some minor updates here from last time:
 * added a def_bool instead of separate lines in config
 * clarified that the /proc interface is *GONE*

cc'ing a bunch of folks directly now instead of depending
on linux-arch@ to awaken them.  I think it's most appropriate
for this to go in via the security tree, but I guess it
could also go directly to Linus.

--

From: Dave Hansen <dave.hansen@linux.intel.com>

There are 7 architecures with "config SECCOMP".  They all have
virtually the same help text except for those referencing the
/proc interface.  The /proc interface was removed in 2007.

There is *NOTHING* architecture-specific about SECCOMP except
that the syscalls have per-architecture definitions, like every
other syscall.  It is absurd to have the option in the
arch-specific menus.

Move it to the security menu, consolidate the 7 down to one, and
remove the embarassingly-ancient help text references and
dependencies on /proc.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-security-module@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ralf Baechle <ralf@linux-mips.org> 
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org> 
Cc: x86@kernel.org
Cc: James Morris <james.l.morris@oracle.com>

---

 b/arch/arm/Kconfig        |   15 +--------------
 b/arch/microblaze/Kconfig |   18 +-----------------
 b/arch/mips/Kconfig       |   18 +-----------------
 b/arch/powerpc/Kconfig    |   18 +-----------------
 b/arch/s390/Kconfig       |   18 +-----------------
 b/arch/sh/Kconfig         |   17 +----------------
 b/arch/sparc/Kconfig      |   18 +-----------------
 b/arch/x86/Kconfig        |   17 +----------------
 b/security/Kconfig        |   21 ++++++++++++++++++++-
 9 files changed, 28 insertions(+), 132 deletions(-)

diff -puN arch/arm/Kconfig~consolidate-seccomp-options arch/arm/Kconfig
--- a/arch/arm/Kconfig~consolidate-seccomp-options	2014-01-29 11:02:31.576007335 -0800
+++ b/arch/arm/Kconfig	2014-01-29 11:02:31.611008920 -0800
@@ -27,6 +27,7 @@ config ARM
 	select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_SECCOMP_FILTER if (AEABI && !OABI_COMPAT)
+	select HAVE_ARCH_SECCOMP
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_BPF_JIT
 	select HAVE_CONTEXT_TRACKING
@@ -1874,20 +1875,6 @@ config UACCESS_WITH_MEMCPY
 	  However, if the CPU data cache is using a write-allocate mode,
 	  this option is unlikely to provide any performance gain.
 
-config SECCOMP
-	bool
-	prompt "Enable seccomp to safely compute untrusted bytecode"
-	---help---
-	  This kernel feature is useful for number crunching applications
-	  that may need to compute untrusted bytecode during their
-	  execution. By using pipes or other transports made available to
-	  the process as file descriptors supporting the read/write
-	  syscalls, it's possible to isolate those applications in
-	  their own address space using seccomp. Once seccomp is
-	  enabled via prctl(PR_SET_SECCOMP), it cannot be disabled
-	  and the task is only allowed to execute a few safe syscalls
-	  defined by each seccomp mode.
-
 config SWIOTLB
 	def_bool y
 
diff -puN arch/microblaze/Kconfig~consolidate-seccomp-options arch/microblaze/Kconfig
--- a/arch/microblaze/Kconfig~consolidate-seccomp-options	2014-01-29 11:02:31.578007425 -0800
+++ b/arch/microblaze/Kconfig	2014-01-29 11:02:31.612008965 -0800
@@ -11,6 +11,7 @@ config MICROBLAZE
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_OPROFILE
 	select HAVE_ARCH_KGDB
+	select HAVE_ARCH_SECCOMP
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
 	select TRACING_SUPPORT
@@ -109,23 +110,6 @@ config CMDLINE_FORCE
 	  Set this to have arguments from the default kernel command string
 	  override those passed by the boot loader.
 
-config SECCOMP
-	bool "Enable seccomp to safely compute untrusted bytecode"
-	depends on PROC_FS
-	default y
-	help
-	  This kernel feature is useful for number crunching applications
-	  that may need to compute untrusted bytecode during their
-	  execution. By using pipes or other transports made available to
-	  the process as file descriptors supporting the read/write
-	  syscalls, it's possible to isolate those applications in
-	  their own address space using seccomp. Once seccomp is
-	  enabled via /proc/<pid>/seccomp, it cannot be disabled
-	  and the task is only allowed to execute a few safe syscalls
-	  defined by each seccomp mode.
-
-	  If unsure, say Y. Only embedded should say N here.
-
 endmenu
 
 menu "Advanced setup"
diff -puN arch/mips/Kconfig~consolidate-seccomp-options arch/mips/Kconfig
--- a/arch/mips/Kconfig~consolidate-seccomp-options	2014-01-29 11:02:31.580007516 -0800
+++ b/arch/mips/Kconfig	2014-01-29 11:02:31.613009010 -0800
@@ -11,6 +11,7 @@ config MIPS
 	select PERF_USE_VMALLOC
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_ARCH_SECCOMP
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
@@ -2307,23 +2308,6 @@ config PHYSICAL_START
 	  specified in the "crashkernel=YM@XM" command line boot parameter
 	  passed to the panic-ed kernel).
 
-config SECCOMP
-	bool "Enable seccomp to safely compute untrusted bytecode"
-	depends on PROC_FS
-	default y
-	help
-	  This kernel feature is useful for number crunching applications
-	  that may need to compute untrusted bytecode during their
-	  execution. By using pipes or other transports made available to
-	  the process as file descriptors supporting the read/write
-	  syscalls, it's possible to isolate those applications in
-	  their own address space using seccomp. Once seccomp is
-	  enabled via /proc/<pid>/seccomp, it cannot be disabled
-	  and the task is only allowed to execute a few safe syscalls
-	  defined by each seccomp mode.
-
-	  If unsure, say Y. Only embedded should say N here.
-
 config USE_OF
 	bool
 	select OF
diff -puN arch/powerpc/Kconfig~consolidate-seccomp-options arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~consolidate-seccomp-options	2014-01-29 11:02:31.599008376 -0800
+++ b/arch/powerpc/Kconfig	2014-01-29 11:02:31.613009010 -0800
@@ -102,6 +102,7 @@ config PPC
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS if !CPU_LITTLE_ENDIAN
 	select HAVE_KPROBES
 	select HAVE_ARCH_KGDB
+	select HAVE_ARCH_SECCOMP
 	select HAVE_KRETPROBES
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_MEMBLOCK
@@ -634,23 +635,6 @@ config ARCH_WANTS_FREEZER_CONTROL
 
 source kernel/power/Kconfig
 
-config SECCOMP
-	bool "Enable seccomp to safely compute untrusted bytecode"
-	depends on PROC_FS
-	default y
-	help
-	  This kernel feature is useful for number crunching applications
-	  that may need to compute untrusted bytecode during their
-	  execution. By using pipes or other transports made available to
-	  the process as file descriptors supporting the read/write
-	  syscalls, it's possible to isolate those applications in
-	  their own address space using seccomp. Once seccomp is
-	  enabled via /proc/<pid>/seccomp, it cannot be disabled
-	  and the task is only allowed to execute a few safe syscalls
-	  defined by each seccomp mode.
-
-	  If unsure, say Y. Only embedded should say N here.
-
 endmenu
 
 config ISA_DMA_API
diff -puN arch/s390/Kconfig~consolidate-seccomp-options arch/s390/Kconfig
--- a/arch/s390/Kconfig~consolidate-seccomp-options	2014-01-29 11:02:31.601008466 -0800
+++ b/arch/s390/Kconfig	2014-01-29 11:02:31.614009055 -0800
@@ -105,6 +105,7 @@ config S390
 	select HAVE_ALIGNED_STRUCT_PAGE if SLUB
 	select HAVE_ARCH_JUMP_LABEL if !MARCH_G5
 	select HAVE_ARCH_SECCOMP_FILTER
+	select HAVE_ARCH_SECCOMP
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if 64BIT
 	select HAVE_BPF_JIT if 64BIT && PACK_STACK
@@ -607,23 +608,6 @@ menu "Executable file formats / Emulatio
 
 source "fs/Kconfig.binfmt"
 
-config SECCOMP
-	def_bool y
-	prompt "Enable seccomp to safely compute untrusted bytecode"
-	depends on PROC_FS
-	help
-	  This kernel feature is useful for number crunching applications
-	  that may need to compute untrusted bytecode during their
-	  execution. By using pipes or other transports made available to
-	  the process as file descriptors supporting the read/write
-	  syscalls, it's possible to isolate those applications in
-	  their own address space using seccomp. Once seccomp is
-	  enabled via /proc/<pid>/seccomp, it cannot be disabled
-	  and the task is only allowed to execute a few safe syscalls
-	  defined by each seccomp mode.
-
-	  If unsure, say Y.
-
 endmenu
 
 menu "Power Management"
diff -puN arch/sh/Kconfig~consolidate-seccomp-options arch/sh/Kconfig
--- a/arch/sh/Kconfig~consolidate-seccomp-options	2014-01-29 11:02:31.602008512 -0800
+++ b/arch/sh/Kconfig	2014-01-29 11:02:31.614009055 -0800
@@ -10,6 +10,7 @@ config SUPERH
 	select HAVE_OPROFILE
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_ARCH_SECCOMP
 	select HAVE_DMA_API_DEBUG
 	select HAVE_DMA_ATTRS
 	select HAVE_PERF_EVENTS
@@ -680,22 +681,6 @@ config PHYSICAL_START
 	  where the fail safe kernel needs to run at a different address
 	  than the panic-ed kernel.
 
-config SECCOMP
-	bool "Enable seccomp to safely compute untrusted bytecode"
-	depends on PROC_FS
-	help
-	  This kernel feature is useful for number crunching applications
-	  that may need to compute untrusted bytecode during their
-	  execution. By using pipes or other transports made available to
-	  the process as file descriptors supporting the read/write
-	  syscalls, it's possible to isolate those applications in
-	  their own address space using seccomp. Once seccomp is
-	  enabled via prctl, it cannot be disabled and the task is only
-	  allowed to execute a few safe syscalls defined by each seccomp
-	  mode.
-
-	  If unsure, say N.
-
 config SMP
 	bool "Symmetric multi-processing support"
 	depends on SYS_SUPPORTS_SMP
diff -puN arch/sparc/Kconfig~consolidate-seccomp-options arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~consolidate-seccomp-options	2014-01-29 11:02:31.604008603 -0800
+++ b/arch/sparc/Kconfig	2014-01-29 11:02:31.615009101 -0800
@@ -67,6 +67,7 @@ config SPARC64
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_CONTEXT_TRACKING
 	select HAVE_DEBUG_KMEMLEAK
+	select HAVE_ARCH_SECCOMP
 	select RTC_DRV_CMOS
 	select RTC_DRV_BQ4802
 	select RTC_DRV_SUN4V
@@ -223,23 +224,6 @@ config EARLYFB
 	help
 	  Say Y here to enable a faster early framebuffer boot console.
 
-config SECCOMP
-	bool "Enable seccomp to safely compute untrusted bytecode"
-	depends on SPARC64 && PROC_FS
-	default y
-	help
-	  This kernel feature is useful for number crunching applications
-	  that may need to compute untrusted bytecode during their
-	  execution. By using pipes or other transports made available to
-	  the process as file descriptors supporting the read/write
-	  syscalls, it's possible to isolate those applications in
-	  their own address space using seccomp. Once seccomp is
-	  enabled via /proc/<pid>/seccomp, it cannot be disabled
-	  and the task is only allowed to execute a few safe syscalls
-	  defined by each seccomp mode.
-
-	  If unsure, say Y. Only embedded should say N here.
-
 config HOTPLUG_CPU
 	bool "Support for hot-pluggable CPUs"
 	depends on SPARC64 && SMP
diff -puN arch/x86/Kconfig~consolidate-seccomp-options arch/x86/Kconfig
--- a/arch/x86/Kconfig~consolidate-seccomp-options	2014-01-29 11:02:31.606008693 -0800
+++ b/arch/x86/Kconfig	2014-01-29 11:02:31.616009147 -0800
@@ -102,6 +102,7 @@ config X86
 	select GENERIC_SMP_IDLE_THREAD
 	select ARCH_WANT_IPC_PARSE_VERSION if X86_32
 	select HAVE_ARCH_SECCOMP_FILTER
+	select HAVE_ARCH_SECCOMP
 	select BUILDTIME_EXTABLE_SORT
 	select GENERIC_CMOS_UPDATE
 	select HAVE_ARCH_SOFT_DIRTY
@@ -1584,22 +1585,6 @@ config EFI_STUB
 
 	  See Documentation/efi-stub.txt for more information.
 
-config SECCOMP
-	def_bool y
-	prompt "Enable seccomp to safely compute untrusted bytecode"
-	---help---
-	  This kernel feature is useful for number crunching applications
-	  that may need to compute untrusted bytecode during their
-	  execution. By using pipes or other transports made available to
-	  the process as file descriptors supporting the read/write
-	  syscalls, it's possible to isolate those applications in
-	  their own address space using seccomp. Once seccomp is
-	  enabled via prctl(PR_SET_SECCOMP), it cannot be disabled
-	  and the task is only allowed to execute a few safe syscalls
-	  defined by each seccomp mode.
-
-	  If unsure, say Y. Only embedded should say N here.
-
 source kernel/Kconfig.hz
 
 config KEXEC
diff -puN security/Kconfig~consolidate-seccomp-options security/Kconfig
--- a/security/Kconfig~consolidate-seccomp-options	2014-01-29 11:02:31.607008738 -0800
+++ b/security/Kconfig	2014-01-29 11:02:31.616009147 -0800
@@ -167,5 +167,24 @@ config DEFAULT_SECURITY
 	default "yama" if DEFAULT_SECURITY_YAMA
 	default "" if DEFAULT_SECURITY_DAC
 
-endmenu
+config HAVE_ARCH_SECCOMP
+	bool
+
+config SECCOMP
+	def_bool y
+	depends on HAVE_ARCH_SECCOMP
+	prompt "Enable seccomp to safely compute untrusted bytecode"
+	---help---
+	  This kernel feature is useful for number crunching applications
+	  that may need to compute untrusted bytecode during their
+	  execution. By using pipes or other transports made available to
+	  the process as file descriptors supporting the read/write
+	  syscalls, it's possible to isolate those applications in
+	  their own address space using seccomp. Once seccomp is
+	  enabled via prctl(PR_SET_SECCOMP), it cannot be disabled
+	  and the task is only allowed to execute a few safe syscalls
+	  defined by each seccomp mode.
 
+	  If unsure, say Y. Only embedded should say N here.
+
+endmenu
_
