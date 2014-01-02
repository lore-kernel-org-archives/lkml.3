Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaABVOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 16:14:15 -0500
Received: from www.sr71.net ([198.145.64.142]:52102 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbaABVOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 16:14:12 -0500
Message-ID: <52C5D69C.2030104@sr71.net>
Date: Thu, 02 Jan 2014 13:14:04 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/3] kconfig: consolidate arch-specific seccomp options
References: <20140102202014.CA206E9B@viggo.jf.intel.com> <1388696934.27100.13.camel@dhcp-9-2-203-236.watson.ibm.com>
In-Reply-To: <1388696934.27100.13.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------080100000200040803090703"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080100000200040803090703
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 01/02/2014 01:08 PM, Mimi Zohar wrote:
>> > +config HAVE_ARCH_SECCOMP
>> > +	bool
>> > +
>> > +config SECCOMP
>> > +	bool
> 
> I haven't looked at the other 'CONFIG_HAVE' options, but shouldn't
> 'HAVE_ARCH_SECCOMP' be dependent on 'SECCOMP'?

Ahh, you're backwards, but right. :)

I forgot to make sure that SECCOMP depends on the architecture option
being set.  Fixed patch is attached.

--------------080100000200040803090703
Content-Type: text/x-patch;
 name="consolidate-seccomp-options.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="consolidate-seccomp-options.patch"


From: Dave Hansen <dave.hansen@linux.intel.com>

There are 7 architecures with "config SECCOMP".  They all have
virtually the same help text except for those referencing the
/proc interface which was removed in 2007.

There is *NOTHING* architecture-specific about SECCOMP except
that the syscalls have per-architecture definitions, like every
other syscall.  It is absurd to have the option in the
arch-specific menus.

Move it to the security menu, consolidate the 7 down to one,
and remove the embarassingly-ancient references to the /proc
interface.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-security-module@vger.kernel.org
Cc: linux-arch@vger.kernel.org
---

 linux.git-davehans/arch/arm/Kconfig        |   15 +--------------
 linux.git-davehans/arch/microblaze/Kconfig |   18 +-----------------
 linux.git-davehans/arch/mips/Kconfig       |   18 +-----------------
 linux.git-davehans/arch/powerpc/Kconfig    |   18 +-----------------
 linux.git-davehans/arch/s390/Kconfig       |   18 +-----------------
 linux.git-davehans/arch/sh/Kconfig         |   17 +----------------
 linux.git-davehans/arch/sparc/Kconfig      |   18 +-----------------
 linux.git-davehans/arch/x86/Kconfig        |   17 +----------------
 linux.git-davehans/security/Kconfig        |   21 ++++++++++++++++++++-
 9 files changed, 28 insertions(+), 132 deletions(-)

diff -puN arch/arm/Kconfig~consolidate-seccomp-options arch/arm/Kconfig
--- linux.git/arch/arm/Kconfig~consolidate-seccomp-options	2014-01-02 11:23:58.590785275 -0800
+++ linux.git-davehans/arch/arm/Kconfig	2014-01-02 11:23:58.609786130 -0800
@@ -26,6 +26,7 @@ config ARM
 	select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_SECCOMP_FILTER if (AEABI && !OABI_COMPAT)
+	select HAVE_ARCH_SECCOMP
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_BPF_JIT
 	select HAVE_CONTEXT_TRACKING
@@ -1842,20 +1843,6 @@ config UACCESS_WITH_MEMCPY
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
 config CC_STACKPROTECTOR
 	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
 	help
diff -puN arch/microblaze/Kconfig~consolidate-seccomp-options arch/microblaze/Kconfig
--- linux.git/arch/microblaze/Kconfig~consolidate-seccomp-options	2014-01-02 11:23:58.592785365 -0800
+++ linux.git-davehans/arch/microblaze/Kconfig	2014-01-02 11:23:58.609786130 -0800
@@ -11,6 +11,7 @@ config MICROBLAZE
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_OPROFILE
 	select HAVE_ARCH_KGDB
+	select HAVE_ARCH_SECCOMP
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
 	select TRACING_SUPPORT
@@ -106,23 +107,6 @@ config CMDLINE_FORCE
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
--- linux.git/arch/mips/Kconfig~consolidate-seccomp-options	2014-01-02 11:23:58.594785455 -0800
+++ linux.git-davehans/arch/mips/Kconfig	2014-01-02 11:23:58.610786175 -0800
@@ -10,6 +10,7 @@ config MIPS
 	select PERF_USE_VMALLOC
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_ARCH_SECCOMP
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
@@ -2305,23 +2306,6 @@ config PHYSICAL_START
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
 config CC_STACKPROTECTOR
 	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
 	help
diff -puN arch/powerpc/Kconfig~consolidate-seccomp-options arch/powerpc/Kconfig
--- linux.git/arch/powerpc/Kconfig~consolidate-seccomp-options	2014-01-02 11:23:58.596785545 -0800
+++ linux.git-davehans/arch/powerpc/Kconfig	2014-01-02 11:23:58.611786220 -0800
@@ -101,6 +101,7 @@ config PPC
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS if !CPU_LITTLE_ENDIAN
 	select HAVE_KPROBES
 	select HAVE_ARCH_KGDB
+	select HAVE_ARCH_SECCOMP
 	select HAVE_KRETPROBES
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_MEMBLOCK
@@ -626,23 +627,6 @@ config ARCH_WANTS_FREEZER_CONTROL
 
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
--- linux.git/arch/s390/Kconfig~consolidate-seccomp-options	2014-01-02 11:23:58.597785590 -0800
+++ linux.git-davehans/arch/s390/Kconfig	2014-01-02 13:11:34.356272712 -0800
@@ -105,6 +105,7 @@ config S390
 	select HAVE_ALIGNED_STRUCT_PAGE if SLUB
 	select HAVE_ARCH_JUMP_LABEL if !MARCH_G5
 	select HAVE_ARCH_SECCOMP_FILTER
+	select HAVE_ARCH_SECCOMP
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if 64BIT
 	select HAVE_BPF_JIT if 64BIT && PACK_STACK
@@ -608,23 +609,6 @@ menu "Executable file formats / Emulatio
 
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
--- linux.git/arch/sh/Kconfig~consolidate-seccomp-options	2014-01-02 11:23:58.599785680 -0800
+++ linux.git-davehans/arch/sh/Kconfig	2014-01-02 11:23:58.612786265 -0800
@@ -10,6 +10,7 @@ config SUPERH
 	select HAVE_OPROFILE
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_ARCH_SECCOMP
 	select HAVE_DMA_API_DEBUG
 	select HAVE_DMA_ATTRS
 	select HAVE_PERF_EVENTS
@@ -679,22 +680,6 @@ config PHYSICAL_START
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
 config CC_STACKPROTECTOR
 	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
 	depends on SUPERH32
diff -puN arch/sparc/Kconfig~consolidate-seccomp-options arch/sparc/Kconfig
--- linux.git/arch/sparc/Kconfig~consolidate-seccomp-options	2014-01-02 11:23:58.601785770 -0800
+++ linux.git-davehans/arch/sparc/Kconfig	2014-01-02 11:23:58.612786265 -0800
@@ -66,6 +66,7 @@ config SPARC64
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_CONTEXT_TRACKING
 	select HAVE_DEBUG_KMEMLEAK
+	select HAVE_ARCH_SECCOMP if PROC_FS
 	select RTC_DRV_CMOS
 	select RTC_DRV_BQ4802
 	select RTC_DRV_SUN4V
@@ -222,23 +223,6 @@ config EARLYFB
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
--- linux.git/arch/x86/Kconfig~consolidate-seccomp-options	2014-01-02 11:23:58.603785860 -0800
+++ linux.git-davehans/arch/x86/Kconfig	2014-01-02 13:11:35.571327321 -0800
@@ -101,6 +101,7 @@ config X86
 	select GENERIC_SMP_IDLE_THREAD
 	select ARCH_WANT_IPC_PARSE_VERSION if X86_32
 	select HAVE_ARCH_SECCOMP_FILTER
+	select HAVE_ARCH_SECCOMP
 	select BUILDTIME_EXTABLE_SORT
 	select GENERIC_CMOS_UPDATE
 	select HAVE_ARCH_SOFT_DIRTY
@@ -1601,22 +1602,6 @@ config EFI_STUB
 
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
 config CC_STACKPROTECTOR
 	bool "Enable -fstack-protector buffer overflow detection"
 	---help---
diff -puN security/Kconfig~consolidate-seccomp-options security/Kconfig
--- linux.git/security/Kconfig~consolidate-seccomp-options	2014-01-02 11:23:58.604785905 -0800
+++ linux.git-davehans/security/Kconfig	2014-01-02 13:13:27.883375139 -0800
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

--------------080100000200040803090703--
