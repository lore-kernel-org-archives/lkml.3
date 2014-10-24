Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbaJXI1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:27:49 -0400
Received: from mail-bn1on0088.outbound.protection.outlook.com ([157.56.110.88]:38912
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933043AbaJXI1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:27:06 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        <lftan.linux@gmail.com>, <cltang@codesourcery.com>
Subject: [PATCH v5 29/29] nios2: Build infrastructure
Date: Fri, 24 Oct 2014 16:24:31 +0800
Message-ID: <1414139071-3818-30-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1414139071-3818-1-git-send-email-lftan@altera.com>
References: <1414139071-3818-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(979002)(6009001)(22564002)(189002)(199003)(50986999)(36756003)(4396001)(50226001)(21056001)(87936001)(106466001)(76176999)(87286001)(88136002)(575784001)(85852003)(86362001)(95666004)(77096002)(20776003)(85306004)(47776003)(89996001)(92566001)(92726001)(62966002)(64706001)(93916002)(2201001)(77156001)(15202345003)(42186005)(105596002)(48376002)(31966008)(102836001)(50466002)(6806004)(229853001)(97736003)(19580395003)(19580405001)(44976005)(68736004)(15975445006)(107046002)(120916001)(104166001)(80022003)(46102003)(76482002)(33646002)(84676001)(99396003)(2004002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB214;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB214;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0374433C81
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB247;
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Makefile and Kconfig files required for building a
nios2 kernel.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/Kconfig                   | 201 +++++++++++++++++++++++++++++++++++
 arch/nios2/Kconfig.debug             |  17 +++
 arch/nios2/Makefile                  |  73 +++++++++++++
 arch/nios2/boot/Makefile             |  52 +++++++++
 arch/nios2/boot/install.sh           |  52 +++++++++
 arch/nios2/configs/3c120_defconfig   |  77 ++++++++++++++
 arch/nios2/include/asm/Kbuild        |  64 +++++++++++
 arch/nios2/include/uapi/asm/Kbuild   |   6 ++
 arch/nios2/kernel/Makefile           |  24 +++++
 arch/nios2/kernel/nios2_ksyms.c      |  35 ++++++
 arch/nios2/kernel/vmlinux.lds.S      |  75 +++++++++++++
 arch/nios2/lib/Makefile              |   9 ++
 arch/nios2/mm/Makefile               |  14 +++
 arch/nios2/platform/Kconfig.platform | 129 ++++++++++++++++++++++
 arch/nios2/platform/Makefile         |   1 +
 15 files changed, 829 insertions(+)
 create mode 100644 arch/nios2/Kconfig
 create mode 100644 arch/nios2/Kconfig.debug
 create mode 100644 arch/nios2/Makefile
 create mode 100644 arch/nios2/boot/Makefile
 create mode 100644 arch/nios2/boot/install.sh
 create mode 100644 arch/nios2/configs/3c120_defconfig
 create mode 100644 arch/nios2/include/asm/Kbuild
 create mode 100644 arch/nios2/include/uapi/asm/Kbuild
 create mode 100644 arch/nios2/kernel/Makefile
 create mode 100644 arch/nios2/kernel/nios2_ksyms.c
 create mode 100644 arch/nios2/kernel/vmlinux.lds.S
 create mode 100644 arch/nios2/lib/Makefile
 create mode 100644 arch/nios2/mm/Makefile
 create mode 100644 arch/nios2/platform/Kconfig.platform
 create mode 100644 arch/nios2/platform/Makefile

diff --git a/arch/nios2/Kconfig b/arch/nios2/Kconfig
new file mode 100644
index 0000000..8a4889d
--- /dev/null
+++ b/arch/nios2/Kconfig
@@ -0,0 +1,201 @@
+config NIOS2
+	def_bool y
+	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select CLKSRC_OF
+	select GENERIC_ATOMIC64
+	select GENERIC_CLOCKEVENTS
+	select GENERIC_CPU_DEVICES
+	select GENERIC_IRQ_PROBE
+	select GENERIC_IRQ_SHOW
+	select HAVE_ARCH_TRACEHOOK
+	select IRQ_DOMAIN
+	select MODULES_USE_ELF_RELA
+	select OF
+	select OF_EARLY_FLATTREE
+	select SOC_BUS
+	select SPARSE_IRQ
+	select USB_ARCH_HAS_HCD if USB_SUPPORT
+
+config GENERIC_CSUM
+	def_bool y
+
+config GENERIC_HWEIGHT
+	def_bool y
+
+config GENERIC_CALIBRATE_DELAY
+	def_bool y
+
+config NO_IOPORT_MAP
+	def_bool y
+
+config HAS_DMA
+	def_bool y
+
+config FPU
+	def_bool n
+
+config SWAP
+	def_bool n
+
+config RWSEM_GENERIC_SPINLOCK
+	def_bool y
+
+config TRACE_IRQFLAGS_SUPPORT
+	def_bool n
+
+source "init/Kconfig"
+
+menu "Kernel features"
+
+source "kernel/Kconfig.preempt"
+
+source "kernel/Kconfig.freezer"
+
+source "kernel/Kconfig.hz"
+
+source "mm/Kconfig"
+
+config FORCE_MAX_ZONEORDER
+	int "Maximum zone order"
+	range 9 20
+	default "11"
+	help
+	  The kernel memory allocator divides physically contiguous memory
+	  blocks into "zones", where each zone is a power of two number of
+	  pages.  This option selects the largest power of two that the kernel
+	  keeps in the memory allocator.  If you need to allocate very large
+	  blocks of physically contiguous memory, then you may need to
+	  increase this value.
+
+	  This config option is actually maximum order plus one. For example,
+	  a value of 11 means that the largest free memory block is 2^10 pages.
+
+endmenu
+
+source "arch/nios2/platform/Kconfig.platform"
+
+menu "Processor type and features"
+
+config MMU
+	def_bool y
+
+config NIOS2_ALIGNMENT_TRAP
+	bool "Catch alignment trap"
+	default y
+	help
+	  Nios II CPUs cannot fetch/store data which is not bus aligned,
+	  i.e., a 2 or 4 byte fetch must start at an address divisible by
+	  2 or 4. Any non-aligned load/store instructions will be trapped and
+	  emulated in software if you say Y here, which has a performance
+	  impact.
+
+comment "Boot options"
+
+config CMDLINE_BOOL
+	bool "Default bootloader kernel arguments"
+	default y
+
+config CMDLINE
+	string "Default kernel command string"
+	default ""
+	depends on CMDLINE_BOOL
+	help
+	  On some platforms, there is currently no way for the boot loader to
+	  pass arguments to the kernel. For these platforms, you can supply
+	  some command-line options at build time by entering them here.  In
+	  other cases you can specify kernel args so that you don't have
+	  to set them up in board prom initialization routines.
+
+config CMDLINE_FORCE
+	bool "Force default kernel command string"
+	depends on CMDLINE_BOOL
+	help
+	  Set this to have arguments from the default kernel command string
+	  override those passed by the boot loader.
+
+config NIOS2_CMDLINE_IGNORE_DTB
+	bool "Ignore kernel command string from DTB"
+	depends on !CMDLINE_FORCE
+	default y
+	help
+	  Set this to ignore the bootargs property from the devicetree's
+	  chosen node and fall back to CMDLINE if nothing is passed.
+
+config NIOS2_PASS_CMDLINE
+	bool "Passed kernel command line from u-boot"
+	default n
+	help
+	  Use bootargs env variable from u-boot for kernel command line.
+	  will override "Default kernel command string".
+	  Say N if you are unsure.
+
+endmenu
+
+menu "Advanced setup"
+
+config ADVANCED_OPTIONS
+	bool "Prompt for advanced kernel configuration options"
+	help
+
+comment "Default settings for advanced configuration options are used"
+	depends on !ADVANCED_OPTIONS
+
+config NIOS2_KERNEL_MMU_REGION_BASE_BOOL
+	bool "Set custom kernel MMU region base address"
+	depends on ADVANCED_OPTIONS
+	help
+	  This option allows you to set the virtual address of the kernel MMU region.
+
+	  Say N here unless you know what you are doing.
+
+config NIOS2_KERNEL_MMU_REGION_BASE
+	hex "Virtual base address of the kernel MMU region " if NIOS2_KERNEL_MMU_REGION_BASE_BOOL
+	default "0x80000000"
+	help
+	  This option allows you to set the virtual base address of the kernel MMU region.
+
+config NIOS2_KERNEL_REGION_BASE_BOOL
+	bool "Set custom kernel region base address"
+	depends on ADVANCED_OPTIONS
+	help
+	  This option allows you to set the virtual address of the kernel region.
+
+	  Say N here unless you know what you are doing.
+
+config NIOS2_KERNEL_REGION_BASE
+	hex "Virtual base address of the kernel region " if NIOS2_KERNEL_REGION_BASE_BOOL
+	default "0xc0000000"
+
+config NIOS2_IO_REGION_BASE_BOOL
+	bool "Set custom I/O region base address"
+	depends on ADVANCED_OPTIONS
+	help
+	  This option allows you to set the virtual address of the I/O region.
+
+	  Say N here unless you know what you are doing.
+
+config NIOS2_IO_REGION_BASE
+	hex "Virtual base address of the I/O region" if NIOS2_IO_REGION_BASE_BOOL
+	default "0xe0000000"
+
+endmenu
+
+menu "Executable file formats"
+
+source "fs/Kconfig.binfmt"
+
+endmenu
+
+source "net/Kconfig"
+
+source "drivers/Kconfig"
+
+source "fs/Kconfig"
+
+source "arch/nios2/Kconfig.debug"
+
+source "security/Kconfig"
+
+source "crypto/Kconfig"
+
+source "lib/Kconfig"
diff --git a/arch/nios2/Kconfig.debug b/arch/nios2/Kconfig.debug
new file mode 100644
index 0000000..8d4e6ba
--- /dev/null
+++ b/arch/nios2/Kconfig.debug
@@ -0,0 +1,17 @@
+menu "Kernel hacking"
+
+config TRACE_IRQFLAGS_SUPPORT
+	def_bool y
+
+source "lib/Kconfig.debug"
+
+config DEBUG_STACK_USAGE
+	bool "Enable stack utilization instrumentation"
+	depends on DEBUG_KERNEL
+	help
+	  Enables the display of the minimum amount of free stack which each
+	  task has ever had available in the sysrq-T and sysrq-P debug output.
+
+	  This option will slow down process creation somewhat.
+
+endmenu
diff --git a/arch/nios2/Makefile b/arch/nios2/Makefile
new file mode 100644
index 0000000..e142c9ee
--- /dev/null
+++ b/arch/nios2/Makefile
@@ -0,0 +1,73 @@
+#
+# This file is subject to the terms and conditions of the GNU General Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+# Copyright (C) 2013 Altera Corporation
+# Copyright (C) 1994, 95, 96, 2003 by Wind River Systems
+# Written by Fredrik Markstrom
+#
+# This file is included by the global makefile so that you can add your own
+# architecture-specific flags and dependencies. Remember to do have actions
+# for "archclean" cleaning up for this architecture.
+#
+# Nios2 port by Wind River Systems Inc trough:
+#   fredrik.markstrom@gmail.com and ivarholmqvist@gmail.com
+
+UTS_SYSNAME = Linux
+
+export MMU
+
+LIBGCC		:= $(shell $(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)
+
+KBUILD_CFLAGS += -pipe -D__linux__ -D__ELF__
+KBUILD_CFLAGS += $(if $(CONFIG_NIOS2_HW_MUL_SUPPORT),-mhw-mul,-mno-hw-mul)
+KBUILD_CFLAGS += $(if $(CONFIG_NIOS2_HW_MULX_SUPPORT),-mhw-mulx,-mno-hw-mulx)
+KBUILD_CFLAGS += $(if $(CONFIG_NIOS2_HW_DIV_SUPPORT),-mhw-div,-mno-hw-div)
+KBUILD_CFLAGS += $(if $(CONFIG_NIOS2_FPU_SUPPORT),-mcustom-fpu-cfg=60-1,)
+
+KBUILD_CFLAGS += -fno-optimize-sibling-calls
+KBUILD_CFLAGS += -DUTS_SYSNAME=\"$(UTS_SYSNAME)\"
+KBUILD_CFLAGS += -fno-builtin
+KBUILD_CFLAGS += -G 0
+
+head-y		:= arch/nios2/kernel/head.o
+libs-y		+= arch/nios2/lib/ $(LIBGCC)
+core-y		+= arch/nios2/kernel/ arch/nios2/mm/
+core-y		+= arch/nios2/platform/
+
+INSTALL_PATH ?= /tftpboot
+nios2-boot := arch/$(ARCH)/boot
+BOOT_TARGETS = vmImage zImage
+PHONY += $(BOOT_TARGETS) install
+KBUILD_IMAGE := $(nios2-boot)/vmImage
+
+ifneq ($(CONFIG_NIOS2_DTB_SOURCE),"")
+	core-y	+= $(nios2-boot)/
+endif
+
+all: vmImage
+
+archclean:
+	$(Q)$(MAKE) $(clean)=$(nios2-boot)
+
+%.dtb:
+	$(Q)$(MAKE) $(build)=$(nios2-boot) $(nios2-boot)/$@
+
+dtbs:
+	$(Q)$(MAKE) $(build)=$(nios2-boot) $(nios2-boot)/$@
+
+$(BOOT_TARGETS): vmlinux
+	$(Q)$(MAKE) $(build)=$(nios2-boot) $(nios2-boot)/$@
+
+install:
+	$(Q)$(MAKE) $(build)=$(nios2-boot) BOOTIMAGE=$(KBUILD_IMAGE) install
+
+define archhelp
+  echo  '* vmImage         - Kernel-only image for U-Boot ($(KBUILD_IMAGE))'
+  echo  '  install         - Install kernel using'
+  echo  '                     (your) ~/bin/$(INSTALLKERNEL) or'
+  echo  '                     (distribution) /sbin/$(INSTALLKERNEL) or'
+  echo  '                     install to $$(INSTALL_PATH)'
+  echo  '  dtbs            - Build device tree blobs for enabled boards'
+endef
diff --git a/arch/nios2/boot/Makefile b/arch/nios2/boot/Makefile
new file mode 100644
index 0000000..59392dc
--- /dev/null
+++ b/arch/nios2/boot/Makefile
@@ -0,0 +1,52 @@
+#
+# arch/nios2/boot/Makefile
+#
+# This file is subject to the terms and conditions of the GNU General Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+
+UIMAGE_LOADADDR = $(shell $(NM) vmlinux | awk '$$NF == "_stext" {print $$1}')
+UIMAGE_ENTRYADDR = $(shell $(NM) vmlinux | awk '$$NF == "_start" {print $$1}')
+UIMAGE_COMPRESSION = gzip
+
+OBJCOPYFLAGS_vmlinux.bin := -O binary
+
+targets += vmlinux.bin vmlinux.gz vmImage
+
+$(obj)/vmlinux.bin: vmlinux FORCE
+	$(call if_changed,objcopy)
+
+$(obj)/vmlinux.gz: $(obj)/vmlinux.bin FORCE
+	$(call if_changed,gzip)
+
+$(obj)/vmImage: $(obj)/vmlinux.gz
+	$(call if_changed,uimage)
+	@$(kecho) 'Kernel: $@ is ready'
+
+# Rule to build device tree blobs
+DTB_SRC := $(patsubst "%",%,$(CONFIG_NIOS2_DTB_SOURCE))
+
+# Make sure the generated dtb gets removed during clean
+extra-$(CONFIG_NIOS2_DTB_SOURCE_BOOL) += system.dtb
+
+$(obj)/system.dtb: $(DTB_SRC) FORCE
+	$(call cmd,dtc)
+
+# Ensure system.dtb exists
+$(obj)/linked_dtb.o: $(obj)/system.dtb
+
+obj-$(CONFIG_NIOS2_DTB_SOURCE_BOOL) += linked_dtb.o
+
+targets += $(dtb-y)
+
+# Rule to build device tree blobs with make command
+$(obj)/%.dtb: $(src)/dts/%.dts FORCE
+	$(call if_changed_dep,dtc)
+
+$(obj)/dtbs: $(addprefix $(obj)/, $(dtb-y))
+
+clean-files := *.dtb
+
+install:
+	sh $(srctree)/$(src)/install.sh $(KERNELRELEASE) $(BOOTIMAGE) System.map "$(INSTALL_PATH)"
diff --git a/arch/nios2/boot/install.sh b/arch/nios2/boot/install.sh
new file mode 100644
index 0000000..57d640d
--- /dev/null
+++ b/arch/nios2/boot/install.sh
@@ -0,0 +1,52 @@
+#!/bin/sh
+#
+# This file is subject to the terms and conditions of the GNU General Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+# Copyright (C) 1995 by Linus Torvalds
+#
+# Adapted from code in arch/i386/boot/Makefile by H. Peter Anvin
+#
+# "make install" script for m68k architecture
+#
+# Arguments:
+#   $1 - kernel version
+#   $2 - kernel image file
+#   $3 - kernel map file
+#   $4 - default install path (blank if root directory)
+#
+
+verify () {
+	if [ ! -f "$1" ]; then
+		echo ""                                                   1>&2
+		echo " *** Missing file: $1"                              1>&2
+		echo ' *** You need to run "make" before "make install".' 1>&2
+		echo ""                                                   1>&2
+		exit 1
+	fi
+}
+
+# Make sure the files actually exist
+verify "$2"
+verify "$3"
+
+# User may have a custom install script
+
+if [ -x ~/bin/${INSTALLKERNEL} ]; then exec ~/bin/${INSTALLKERNEL} "$@"; fi
+if [ -x /sbin/${INSTALLKERNEL} ]; then exec /sbin/${INSTALLKERNEL} "$@"; fi
+
+# Default install - same as make zlilo
+
+if [ -f $4/vmlinuz ]; then
+	mv $4/vmlinuz $4/vmlinuz.old
+fi
+
+if [ -f $4/System.map ]; then
+	mv $4/System.map $4/System.old
+fi
+
+cat $2 > $4/vmlinuz
+cp $3 $4/System.map
+
+sync
diff --git a/arch/nios2/configs/3c120_defconfig b/arch/nios2/configs/3c120_defconfig
new file mode 100644
index 0000000..87541f0
--- /dev/null
+++ b/arch/nios2/configs/3c120_defconfig
@@ -0,0 +1,77 @@
+CONFIG_SYSVIPC=y
+CONFIG_NO_HZ_IDLE=y
+CONFIG_BSD_PROCESS_ACCT=y
+CONFIG_LOG_BUF_SHIFT=14
+CONFIG_SYSCTL_SYSCALL=y
+# CONFIG_ELF_CORE is not set
+# CONFIG_EPOLL is not set
+# CONFIG_SIGNALFD is not set
+# CONFIG_TIMERFD is not set
+# CONFIG_EVENTFD is not set
+# CONFIG_SHMEM is not set
+# CONFIG_AIO is not set
+CONFIG_EMBEDDED=y
+CONFIG_SLAB=y
+CONFIG_MODULES=y
+CONFIG_MODULE_UNLOAD=y
+CONFIG_NIOS2_MEM_BASE=0x10000000
+CONFIG_NIOS2_HW_MUL_SUPPORT=y
+CONFIG_NIOS2_HW_DIV_SUPPORT=y
+CONFIG_CUSTOM_CACHE_SETTINGS=y
+CONFIG_NIOS2_DCACHE_SIZE=0x8000
+CONFIG_NIOS2_ICACHE_SIZE=0x8000
+# CONFIG_NIOS2_CMDLINE_IGNORE_DTB is not set
+CONFIG_NIOS2_PASS_CMDLINE=y
+CONFIG_NET=y
+CONFIG_PACKET=y
+CONFIG_UNIX=y
+CONFIG_INET=y
+CONFIG_IP_MULTICAST=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_DHCP=y
+CONFIG_IP_PNP_BOOTP=y
+CONFIG_IP_PNP_RARP=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
+# CONFIG_INET_LRO is not set
+# CONFIG_IPV6 is not set
+# CONFIG_WIRELESS is not set
+CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
+CONFIG_DEVTMPFS=y
+CONFIG_DEVTMPFS_MOUNT=y
+# CONFIG_FW_LOADER is not set
+CONFIG_MTD=y
+CONFIG_MTD_CMDLINE_PARTS=y
+CONFIG_MTD_BLOCK=y
+CONFIG_MTD_CFI=y
+CONFIG_MTD_CFI_INTELEXT=y
+CONFIG_MTD_CFI_AMDSTD=y
+CONFIG_MTD_PHYSMAP_OF=y
+CONFIG_BLK_DEV_LOOP=y
+CONFIG_NETDEVICES=y
+CONFIG_ALTERA_TSE=y
+CONFIG_MARVELL_PHY=y
+# CONFIG_WLAN is not set
+# CONFIG_INPUT_MOUSE is not set
+# CONFIG_SERIO_SERPORT is not set
+# CONFIG_VT is not set
+CONFIG_SERIAL_ALTERA_JTAGUART=y
+CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
+CONFIG_SERIAL_ALTERA_UART=y
+# CONFIG_HW_RANDOM is not set
+# CONFIG_HWMON is not set
+# CONFIG_USB_SUPPORT is not set
+CONFIG_NEW_LEDS=y
+CONFIG_LEDS_CLASS=y
+CONFIG_LEDS_TRIGGERS=y
+CONFIG_LEDS_TRIGGER_HEARTBEAT=y
+# CONFIG_DNOTIFY is not set
+# CONFIG_INOTIFY_USER is not set
+CONFIG_JFFS2_FS=y
+CONFIG_NFS_FS=y
+CONFIG_NFS_V3_ACL=y
+CONFIG_ROOT_NFS=y
+CONFIG_SUNRPC_DEBUG=y
+CONFIG_DEBUG_INFO=y
+# CONFIG_ENABLE_WARN_DEPRECATED is not set
diff --git a/arch/nios2/include/asm/Kbuild b/arch/nios2/include/asm/Kbuild
new file mode 100644
index 0000000..7dce0a3
--- /dev/null
+++ b/arch/nios2/include/asm/Kbuild
@@ -0,0 +1,64 @@
+generic-y += atomic.h
+generic-y += auxvec.h
+generic-y += barrier.h
+generic-y += bitops.h
+generic-y += bitsperlong.h
+generic-y += bug.h
+generic-y += bugs.h
+generic-y += cputime.h
+generic-y += current.h
+generic-y += device.h
+generic-y += div64.h
+generic-y += dma.h
+generic-y += emergency-restart.h
+generic-y += errno.h
+generic-y += exec.h
+generic-y += fb.h
+generic-y += fcntl.h
+generic-y += ftrace.h
+generic-y += futex.h
+generic-y += hardirq.h
+generic-y += hash.h
+generic-y += hw_irq.h
+generic-y += ioctl.h
+generic-y += ioctls.h
+generic-y += ipcbuf.h
+generic-y += irq_regs.h
+generic-y += irq_work.h
+generic-y += kdebug.h
+generic-y += kmap_types.h
+generic-y += kvm_para.h
+generic-y += local.h
+generic-y += mcs_spinlock.h
+generic-y += mman.h
+generic-y += module.h
+generic-y += msgbuf.h
+generic-y += param.h
+generic-y += pci.h
+generic-y += percpu.h
+generic-y += poll.h
+generic-y += posix_types.h
+generic-y += preempt.h
+generic-y += resource.h
+generic-y += scatterlist.h
+generic-y += sections.h
+generic-y += segment.h
+generic-y += sembuf.h
+generic-y += serial.h
+generic-y += shmbuf.h
+generic-y += shmparam.h
+generic-y += siginfo.h
+generic-y += signal.h
+generic-y += socket.h
+generic-y += sockios.h
+generic-y += spinlock.h
+generic-y += stat.h
+generic-y += statfs.h
+generic-y += termbits.h
+generic-y += termios.h
+generic-y += topology.h
+generic-y += trace_clock.h
+generic-y += types.h
+generic-y += unaligned.h
+generic-y += user.h
+generic-y += xor.h
diff --git a/arch/nios2/include/uapi/asm/Kbuild b/arch/nios2/include/uapi/asm/Kbuild
new file mode 100644
index 0000000..1a6d0db
--- /dev/null
+++ b/arch/nios2/include/uapi/asm/Kbuild
@@ -0,0 +1,6 @@
+include include/uapi/asm-generic/Kbuild.asm
+
+header-y += elf.h
+header-y += processor.h
+header-y += traps.h
+header-y += ucontext.h
diff --git a/arch/nios2/kernel/Makefile b/arch/nios2/kernel/Makefile
new file mode 100644
index 0000000..8ae7682
--- /dev/null
+++ b/arch/nios2/kernel/Makefile
@@ -0,0 +1,24 @@
+#
+# Makefile for the nios2 linux kernel.
+#
+
+extra-y	+= head.o
+extra-y	+= vmlinux.lds
+
+obj-y	+= cpuinfo.o
+obj-y	+= entry.o
+obj-y	+= insnemu.o
+obj-y	+= irq.o
+obj-y	+= nios2_ksyms.o
+obj-y	+= process.o
+obj-y	+= prom.o
+obj-y	+= ptrace.o
+obj-y	+= setup.o
+obj-y	+= signal.o
+obj-y	+= sys_nios2.o
+obj-y	+= syscall_table.o
+obj-y	+= time.o
+obj-y	+= traps.o
+
+obj-$(CONFIG_MODULES)			+= module.o
+obj-$(CONFIG_NIOS2_ALIGNMENT_TRAP)	+= misaligned.o
diff --git a/arch/nios2/kernel/nios2_ksyms.c b/arch/nios2/kernel/nios2_ksyms.c
new file mode 100644
index 0000000..eaf7f0c
--- /dev/null
+++ b/arch/nios2/kernel/nios2_ksyms.c
@@ -0,0 +1,35 @@
+/*
+ * Copyright (C) 2004 Microtronix Datacom Ltd
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file COPYING in the main directory of this
+ * archive for more details.
+ */
+
+#include <linux/export.h>
+#include <linux/string.h>
+
+/* string functions */
+
+EXPORT_SYMBOL(memcpy);
+EXPORT_SYMBOL(memset);
+EXPORT_SYMBOL(memmove);
+
+/*
+ * libgcc functions - functions that are used internally by the
+ * compiler...  (prototypes are not correct though, but that
+ * doesn't really matter since they're not versioned).
+ */
+#define DECLARE_EXPORT(name)	extern void name(void); EXPORT_SYMBOL(name)
+
+DECLARE_EXPORT(__gcc_bcmp);
+DECLARE_EXPORT(__divdi3);
+DECLARE_EXPORT(__divsi3);
+DECLARE_EXPORT(__moddi3);
+DECLARE_EXPORT(__modsi3);
+DECLARE_EXPORT(__udivdi3);
+DECLARE_EXPORT(__udivmoddi4);
+DECLARE_EXPORT(__udivsi3);
+DECLARE_EXPORT(__umoddi3);
+DECLARE_EXPORT(__umodsi3);
+DECLARE_EXPORT(__muldi3);
diff --git a/arch/nios2/kernel/vmlinux.lds.S b/arch/nios2/kernel/vmlinux.lds.S
new file mode 100644
index 0000000..326fab4
--- /dev/null
+++ b/arch/nios2/kernel/vmlinux.lds.S
@@ -0,0 +1,75 @@
+/*
+ * Copyright (C) 2009 Thomas Chou <thomas@wytron.com.tw>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+#include <asm/page.h>
+#include <asm-generic/vmlinux.lds.h>
+#include <asm/cache.h>
+#include <asm/thread_info.h>
+
+OUTPUT_FORMAT("elf32-littlenios2", "elf32-littlenios2", "elf32-littlenios2")
+
+OUTPUT_ARCH(nios)
+ENTRY(_start)	/* Defined in head.S */
+
+jiffies = jiffies_64;
+
+SECTIONS
+{
+	. = CONFIG_NIOS2_MEM_BASE | CONFIG_NIOS2_KERNEL_REGION_BASE;
+
+	_text = .;
+	_stext = .;
+	HEAD_TEXT_SECTION
+	.text : {
+		TEXT_TEXT
+		SCHED_TEXT
+		LOCK_TEXT
+		IRQENTRY_TEXT
+		KPROBES_TEXT
+	} =0
+	_etext = .;
+
+	.got : {
+		*(.got.plt)
+		*(.igot.plt)
+		*(.got)
+		*(.igot)
+	}
+
+	EXCEPTION_TABLE(L1_CACHE_BYTES)
+
+	. = ALIGN(PAGE_SIZE);
+	__init_begin = .;
+	INIT_TEXT_SECTION(PAGE_SIZE)
+	INIT_DATA_SECTION(PAGE_SIZE)
+	PERCPU_SECTION(L1_CACHE_BYTES)
+	__init_end = .;
+
+	_sdata = .;
+	RO_DATA_SECTION(PAGE_SIZE)
+	RW_DATA_SECTION(L1_CACHE_BYTES, PAGE_SIZE, THREAD_SIZE)
+	_edata = .;
+
+	BSS_SECTION(0, 0, 0)
+	_end = .;
+
+	STABS_DEBUG
+	DWARF_DEBUG
+	NOTES
+
+	DISCARDS
+}
diff --git a/arch/nios2/lib/Makefile b/arch/nios2/lib/Makefile
new file mode 100644
index 0000000..be4c64a
--- /dev/null
+++ b/arch/nios2/lib/Makefile
@@ -0,0 +1,9 @@
+#
+# Makefile for Nios2-specific library files.
+#
+
+lib-y += delay.o
+lib-y += io.o
+lib-y += memcpy.o
+lib-y += memmove.o
+lib-y += memset.o
diff --git a/arch/nios2/mm/Makefile b/arch/nios2/mm/Makefile
new file mode 100644
index 0000000..3cbd084
--- /dev/null
+++ b/arch/nios2/mm/Makefile
@@ -0,0 +1,14 @@
+#
+# Makefile for the Nios2-specific parts of the memory manager.
+#
+
+obj-y	+= cacheflush.o
+obj-y	+= dma-mapping.o
+obj-y	+= extable.o
+obj-y	+= fault.o
+obj-y	+= init.o
+obj-y	+= ioremap.o
+obj-y	+= mmu_context.o
+obj-y	+= pgtable.o
+obj-y	+= tlb.o
+obj-y	+= uaccess.o
diff --git a/arch/nios2/platform/Kconfig.platform b/arch/nios2/platform/Kconfig.platform
new file mode 100644
index 0000000..a2c5cc8
--- /dev/null
+++ b/arch/nios2/platform/Kconfig.platform
@@ -0,0 +1,129 @@
+menu "Platform options"
+
+comment "Memory settings"
+
+config NIOS2_MEM_BASE
+	hex "Memory base address"
+	default "0x00000000"
+	help
+	  This is the physical address of the memory that the kernel will run
+	  from. This address is used to link the kernel and setup initial memory
+	  management. You should take the raw memory address without any MMU
+	  or cache bits set.
+	  Please not that this address is used directly so you have to manually
+	  do address translation if it's connected to a bridge.
+
+comment "Device tree"
+
+config NIOS2_DTB_AT_PHYS_ADDR
+	bool "DTB at physical address"
+	default n
+	help
+	  When enabled you can select a physical address to load the dtb from.
+	  Normally this address is passed by a bootloader such as u-boot but
+	  using this you can use a devicetree without a bootloader.
+	  This way you can store a devicetree in NOR flash or an onchip rom.
+	  Please note that this addres is used directly so you have to manually
+	  do address translation if it's connected to a bridge. Also take into
+	  account that when using an MMU you'd have to ad 0xC0000000 to your
+	  address
+
+config NIOS2_DTB_PHYS_ADDR
+	hex "DTB Address"
+	depends on NIOS2_DTB_AT_PHYS_ADDR
+	default "0xC0000000"
+	help
+	  Physical address of a dtb blob.
+
+config NIOS2_DTB_SOURCE_BOOL
+	bool "Compile and link device tree into kernel image"
+	default n
+	help
+	  This allows you to specify a dts (device tree source) file
+	  which will be compiled and linked into the kernel image.
+
+config NIOS2_DTB_SOURCE
+	string "Device tree source file"
+	depends on NIOS2_DTB_SOURCE_BOOL
+	default ""
+	help
+	  Absolute path to the device tree source (dts) file describing your
+	  system.
+
+comment "Nios II instructions"
+
+config NIOS2_HW_MUL_SUPPORT
+	bool "Enable MUL instruction"
+	default n
+	help
+	  Set to true if you configured the Nios II to include the MUL
+	  instruction.  This will enable the -mhw-mul compiler flag.
+
+config NIOS2_HW_MULX_SUPPORT
+	bool "Enable MULX instruction"
+	default n
+	help
+	  Set to true if you configured the Nios II to include the MULX
+	  instruction.  Enables the -mhw-mulx compiler flag.
+
+config NIOS2_HW_DIV_SUPPORT
+	bool "Enable DIV instruction"
+	default n
+	help
+	  Set to true if you configured the Nios II to include the DIV
+	  instruction.  Enables the -mhw-div compiler flag.
+
+config NIOS2_FPU_SUPPORT
+	bool "Custom floating point instr support"
+	default n
+	help
+	  Enables the -mcustom-fpu-cfg=60-1 compiler flag.
+
+config NIOS2_CI_SWAB_SUPPORT
+	bool "Byteswap custom instruction"
+	default n
+	help
+	  Use the byteswap (endian convertor) Nios II custom instruction provided
+	  by Altera and which can be enabled in QSYS builder. This accelerates
+	  endian conversions in the kernel (e.g. ntohs).
+
+config NIOS2_CI_SWAB_NO
+	int "Byteswap custom instruction number" if NIOS2_CI_SWAB_SUPPORT
+	default 0
+	help
+	  Number of the instruction as configured in QSYS Builder.
+
+comment "Cache settings"
+
+config CUSTOM_CACHE_SETTINGS
+	bool "Custom cache settings"
+	help
+	  This option allows you to tweak the cache settings used during early
+	  boot (where the information from device tree is not yet available).
+	  There should be no reason to change these values. Linux will work
+	  perfectly fine, even if the Nios II is configured with smaller caches.
+
+	  Say N here unless you know what you are doing.
+
+config NIOS2_DCACHE_SIZE
+	hex "D-Cache size" if CUSTOM_CACHE_SETTINGS
+	range 0x200 0x10000
+	default "0x800"
+	help
+	  Maximum possible data cache size.
+
+config NIOS2_DCACHE_LINE_SIZE
+	hex "D-Cache line size" if CUSTOM_CACHE_SETTINGS
+	range 0x10 0x20
+	default "0x20"
+	help
+	  Minimum possible data cache line size.
+
+config NIOS2_ICACHE_SIZE
+	hex "I-Cache size" if CUSTOM_CACHE_SETTINGS
+	range 0x200 0x10000
+	default "0x1000"
+	help
+	  Maximum possible instruction cache size.
+
+endmenu
diff --git a/arch/nios2/platform/Makefile b/arch/nios2/platform/Makefile
new file mode 100644
index 0000000..46364f1
--- /dev/null
+++ b/arch/nios2/platform/Makefile
@@ -0,0 +1 @@
+obj-y += platform.o
-- 
1.8.2.1

