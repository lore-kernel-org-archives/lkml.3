Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbaDRMm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 08:42:59 -0400
Received: from mail-bn1bbn0108.outbound.protection.outlook.com ([157.56.111.108]:45286
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751185AbaDRMmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:42:46 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Subject: [PATCH 01/28] nios2: Build infrastructure
Date: Fri, 18 Apr 2014 20:26:48 +0800
Message-ID: <1397824031-4892-2-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397824031-4892-1-git-send-email-lftan@altera.com>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(189002)(199002)(22564002)(575784001)(97736001)(93916002)(46102001)(86362001)(50466002)(4396001)(80022001)(76176999)(80976001)(62966002)(81342001)(50226001)(81542001)(48376002)(50986999)(2009001)(99396002)(87286001)(77156001)(89996001)(83072002)(31966008)(85852003)(87936001)(88136002)(36756003)(77982001)(84676001)(42186004)(76482001)(47776003)(19580395003)(20776003)(19580405001)(44976005)(2201001)(92726001)(83322001)(16796002)(6806004)(74502001)(92566001)(74662001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB014;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:E263FD56.A0FA5D8E.6ECBA587.463A7843.20DD2;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 018577E36E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Makefile and Kconfig files required for building a
nios2 kernel.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/Kconfig                   | 213 +++++++++++++++++++++++++++++++++++
 arch/nios2/Kconfig.debug             |  17 +++
 arch/nios2/Makefile                  |  78 +++++++++++++
 arch/nios2/boot/Makefile             |  51 +++++++++
 arch/nios2/configs/3c120_defconfig   |  77 +++++++++++++
 arch/nios2/include/asm/Kbuild        |  66 +++++++++++
 arch/nios2/include/uapi/asm/Kbuild   |  14 +++
 arch/nios2/kernel/Makefile           |  14 +++
 arch/nios2/kernel/nios2_ksyms.c      |  35 ++++++
 arch/nios2/kernel/vmlinux.lds.S      |  75 ++++++++++++
 arch/nios2/lib/Makefile              |   1 +
 arch/nios2/mm/Makefile               |  12 ++
 arch/nios2/platform/Kconfig.platform | 129 +++++++++++++++++++++
 arch/nios2/platform/Makefile         |   1 +
 14 files changed, 783 insertions(+)
 create mode 100644 arch/nios2/Kconfig
 create mode 100644 arch/nios2/Kconfig.debug
 create mode 100644 arch/nios2/Makefile
 create mode 100644 arch/nios2/boot/Makefile
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
index 0000000..2bd0d0d7160f31a5c5890cf8a059b9f53378be6e
--- /dev/null
+++ b/arch/nios2/Kconfig
@@ -0,0 +1,213 @@
+config NIOS2
+	def_bool y
+	select OF
+	select OF_EARLY_FLATTREE
+	select USB_ARCH_HAS_HCD if USB_SUPPORT
+	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select GENERIC_IRQ_PROBE
+	select GENERIC_IRQ_SHOW
+	select GENERIC_CPU_DEVICES
+	select GENERIC_ATOMIC64
+	select MODULES_USE_ELF_RELA
+	select IRQ_DOMAIN
+	select SOC_BUS
+	select CLKSRC_OF
+
+config GENERIC_CSUM
+	def_bool y
+
+config GENERIC_FIND_NEXT_BIT
+	def_bool y
+
+config GENERIC_HWEIGHT
+	def_bool y
+
+config GENERIC_CALIBRATE_DELAY
+	def_bool y
+
+
+config NO_IOPORT
+	def_bool y
+
+config HAS_DMA
+	def_bool y
+
+config ZONE_DMA
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
+config ALIGNMENT_TRAP
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
+config CMDLINE_IGNORE_DTB
+	bool "Ignore kernel command string from DTB"
+	depends on !CMDLINE_FORCE
+	default y
+	help
+	  Set this to ignore the bootargs property from the devicetree's
+	  chosen node and fall back to CMDLINE if nothing is passed.
+
+config PASS_CMDLINE
+	bool "Passed kernel command line from u-boot"
+	default n
+	help
+	  Use bootargs env variable from u-boot for kernel command line.
+	  will override "Default kernel command string".
+          Say N if you are unsure.
+
+config BOOT_LINK_OFFSET
+	hex "Link address offset for booting"
+	default "0x00500000"
+	help
+	  This option allows you to set the link address offset of the zImage.
+	  This can be useful if you are on a board which has a small amount of
+	  memory.
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
+config KERNEL_MMU_REGION_BASE_BOOL
+	bool "Set custom kernel MMU region base address"
+	depends on ADVANCED_OPTIONS
+	help
+	  This option allows you to set the virtual address of the kernel MMU region.
+
+	  Say N here unless you know what you are doing.
+
+config KERNEL_MMU_REGION_BASE
+	hex "Virtual base address of the kernel MMU region " if KERNEL_MMU_REGION_BASE_BOOL
+	default "0x80000000"
+	help
+	  This option allows you to set the virtual base address of the kernel MMU region.
+
+config KERNEL_REGION_BASE_BOOL
+	bool "Set custom kernel region base address"
+	depends on ADVANCED_OPTIONS
+	help
+	  This option allows you to set the virtual address of the kernel region.
+
+	  Say N here unless you know what you are doing.
+
+config KERNEL_REGION_BASE
+	hex "Virtual base address of the kernel region " if KERNEL_REGION_BASE_BOOL
+	default "0xc0000000"
+
+config IO_REGION_BASE_BOOL
+	bool "Set custom I/O region base address"
+	depends on ADVANCED_OPTIONS
+	help
+	  This option allows you to set the virtual address of the I/O region.
+
+	  Say N here unless you know what you are doing.
+
+config IO_REGION_BASE
+	hex "Virtual base address of the I/O region " if IO_REGION_BASE_BOOL
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
index 0000000..8d4e6bacd997b3f687d1262631830a3c73c1f0f6
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
index 0000000..89840a5763797a26bcbb723d32db64826024689c
--- /dev/null
+++ b/arch/nios2/Makefile
@@ -0,0 +1,78 @@
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
+cflags-y :=
+LDFLAGS		:=
+LDFLAGS_vmlinux	:=
+
+LIBGCC		:= $(shell $(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)
+
+KBUILD_AFLAGS += $(cflags-y)
+KBUILD_CFLAGS += -pipe -D__linux__ -D__ELF__ $(cflags-y)
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
+boot := arch/$(ARCH)/boot
+BOOT_TARGETS = vmImage zImage
+PHONY += $(BOOT_TARGETS) install
+KBUILD_IMAGE := $(boot)/vmImage
+
+ifneq ($(CONFIG_DTB_SOURCE),"")
+	core-y	+= $(boot)/
+endif
+
+all: vmImage
+
+archclean:
+	$(Q)$(MAKE) $(clean)=$(boot)
+
+%.dtb:
+	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
+
+dtbs:
+	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
+
+$(BOOT_TARGETS): vmlinux
+	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
+
+install:
+	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) install
+
+define archhelp
+  echo  '* vmImage         - Kernel-only image for U-Boot (arch/$(ARCH)/boot/vmImage)'
+  echo  '  install         - Install kernel using'
+  echo  '                     (your) ~/bin/$(CROSS_COMPILE)installkernel or'
+  echo  '                     (distribution) PATH: $(CROSS_COMPILE)installkernel or'
+  echo  '                     install to $$(INSTALL_PATH)'
+  echo  '  dtbs            - Build device tree blobs for enabled boards'
+endef
diff --git a/arch/nios2/boot/Makefile b/arch/nios2/boot/Makefile
new file mode 100644
index 0000000..00aef5e266f9cc629f126445535f9aae6ca8962f
--- /dev/null
+++ b/arch/nios2/boot/Makefile
@@ -0,0 +1,51 @@
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
+DTB_SRC := $(subst ",,$(CONFIG_DTB_SOURCE))
+
+# Make sure the generated dtb gets removed during clean
+extra-$(CONFIG_DTB_SOURCE_BOOL) += system.dtb
+
+$(obj)/system.dtb: $(DTB_SRC) FORCE
+	$(call cmd,dtc)
+
+# Ensure system.dtb exists
+$(obj)/linked_dtb.o: $(obj)/system.dtb
+
+#ifneq ($(CONFIG_DTB_SOURCE),"")
+obj-$(CONFIG_DTB_SOURCE_BOOL) += linked_dtb.o
+#endif
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
diff --git a/arch/nios2/configs/3c120_defconfig b/arch/nios2/configs/3c120_defconfig
new file mode 100644
index 0000000..0147082994473779eeb138e2cfd0a17be73242c4
--- /dev/null
+++ b/arch/nios2/configs/3c120_defconfig
@@ -0,0 +1,77 @@
+CONFIG_SYSVIPC=y
+CONFIG_BSD_PROCESS_ACCT=y
+CONFIG_LOG_BUF_SHIFT=14
+CONFIG_SYSCTL_SYSCALL=y
+# CONFIG_ELF_CORE is not set
+# CONFIG_FUTEX is not set
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
+CONFIG_MEM_BASE=0x10000000
+CONFIG_NIOS2_HW_MUL_SUPPORT=y
+CONFIG_NIOS2_HW_DIV_SUPPORT=y
+CONFIG_CUSTOM_CACHE_SETTINGS=y
+CONFIG_NIOS2_DCACHE_SIZE=0x8000
+CONFIG_NIOS2_ICACHE_SIZE=0x8000
+# CONFIG_CMDLINE_IGNORE_DTB is not set
+CONFIG_PASS_CMDLINE=y
+CONFIG_BOOT_LINK_OFFSET=0x00800000
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
+CONFIG_SUNRPC_DEBUG=y
+CONFIG_DEBUG_INFO=y
+# CONFIG_ENABLE_WARN_DEPRECATED is not set
diff --git a/arch/nios2/include/asm/Kbuild b/arch/nios2/include/asm/Kbuild
new file mode 100644
index 0000000..848a67f
--- /dev/null
+++ b/arch/nios2/include/asm/Kbuild
@@ -0,0 +1,66 @@
+include include/asm-generic/Kbuild.asm
+
+header-y += ucontext.h
+header-y += traps.h
+
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
+generic-y += hardirq.h
+generic-y += hash.h
+generic-y += hw_irq.h
+generic-y += ioctl.h
+generic-y += ioctls.h
+generic-y += ipcbuf.h
+generic-y += irq_regs.h
+generic-y += kdebug.h
+generic-y += kmap_types.h
+generic-y += kvm_para.h
+generic-y += local.h
+generic-y += mcs_spinlock.h
+generic-y += mman.h
+generic-y += module.h
+generic-y += msgbuf.h
+generic-y += param.h
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
index 0000000..6d9f2e8e6798d254dee8dd32a8a963ddd70bbe07
--- /dev/null
+++ b/arch/nios2/include/uapi/asm/Kbuild
@@ -0,0 +1,14 @@
+include include/uapi/asm-generic/Kbuild.asm
+
+header-y += byteorder.h
+header-y += elf.h
+header-y += kvm_para.h
+header-y += processor.h
+header-y += ptrace.h
+header-y += setup.h
+header-y += sigcontext.h
+header-y += signal.h
+header-y += stat.h
+header-y += statfs.h
+header-y += swab.h
+header-y += unistd.h
diff --git a/arch/nios2/kernel/Makefile b/arch/nios2/kernel/Makefile
new file mode 100644
index 0000000..c46ddee
--- /dev/null
+++ b/arch/nios2/kernel/Makefile
@@ -0,0 +1,14 @@
+#
+# Makefile for the nios2 linux kernel.
+#
+
+extra-y := head.o vmlinux.lds
+
+obj-y += entry.o
+
+obj-y += cpuinfo.o insnemu.o irq.o nios2_ksyms.o process.o prom.o ptrace.o \
+	 setup.o signal.o sys_nios2.o syscall_table.o time.o traps.o
+
+obj-$(CONFIG_MODULES)		+= module.o
+obj-$(CONFIG_CONSOLE)		+= console.o
+obj-$(CONFIG_ALIGNMENT_TRAP)	+= misaligned.o
diff --git a/arch/nios2/kernel/nios2_ksyms.c b/arch/nios2/kernel/nios2_ksyms.c
new file mode 100644
index 0000000..eaf7f0cee5facf67e9a7f191ecbb8bc34e387b23
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
index 0000000..ec43c9f72b18a6ce79559d0da7ab8483a8aaba45
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
+	. = CONFIG_MEM_BASE | CONFIG_KERNEL_REGION_BASE;
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
index 0000000..f9c5bc02ba357adb37d812f0bd0a30fc76d909b8
--- /dev/null
+++ b/arch/nios2/lib/Makefile
@@ -0,0 +1 @@
+lib-y = memset.o memcpy.o memmove.o
\ No newline at end of file
diff --git a/arch/nios2/mm/Makefile b/arch/nios2/mm/Makefile
new file mode 100644
index 0000000..6ef15aae70ef0937bd53574997fcae82116f9245
--- /dev/null
+++ b/arch/nios2/mm/Makefile
@@ -0,0 +1,12 @@
+#
+# Makefile for the Nios2-specific parts of the memory manager.
+#
+
+obj-y := init.o
+
+obj-y += cacheflush.o
+
+obj-y += pgtable.o tlb.o uaccess.o fault.o
+obj-y += ioremap.o extable.o mmu_context.o
+
+obj-y += dma-mapping.o
\ No newline at end of file
diff --git a/arch/nios2/platform/Kconfig.platform b/arch/nios2/platform/Kconfig.platform
new file mode 100644
index 0000000..e767c51afd9f4b588a256ff2c75ac273fe920fa7
--- /dev/null
+++ b/arch/nios2/platform/Kconfig.platform
@@ -0,0 +1,129 @@
+menu "Platform options"
+
+comment "Memory settings"
+
+config MEM_BASE
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
+config DTB_SOURCE_BOOL
+	bool "Compile and link device tree into kernel image"
+	default n
+	help
+	  This allows you to specify a dts (device tree source) file
+	  which will be compiled and linked into the kernel image.
+
+config DTB_SOURCE
+	string "Device tree source file"
+	depends on DTB_SOURCE_BOOL
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
+	  by Altera and which can be enabled in SOPC builder. This accelerates
+	  endian conversions in the kernel (e.g. ntohs).
+
+config NIOS2_CI_SWAB_NO
+	int "Byteswap custom instruction number" if NIOS2_CI_SWAB_SUPPORT
+	default 0
+	help
+	  Number of the instruction as configured in SOPC Builder.
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
index 0000000..46364f1d9352d97547e8b8fc336c2fea06adb5b8
--- /dev/null
+++ b/arch/nios2/platform/Makefile
@@ -0,0 +1 @@
+obj-y += platform.o
-- 
1.8.3.2

