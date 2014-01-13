Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaAMTXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:23:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:24364 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbaAMTXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:23:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,654,1384329600"; 
   d="scan'208";a="465999872"
Subject: [PATCH 12/12] x86 Kconfig: move paravirt under "Virtualization"
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Dave Hansen <dave@sr71.net>, bp@suse.de, dtor@vmware.com,
        kys@microsoft.com, haiyangz@microsoft.com, agraf@suse.de,
        gleb@redhat.com, pbonzini@redhat.com
From: Dave Hansen <dave@sr71.net>
Date: Mon, 13 Jan 2014 11:23:01 -0800
References: <20140113192245.3F682C7F@viggo.jf.intel.com>
In-Reply-To: <20140113192245.3F682C7F@viggo.jf.intel.com>
Message-Id: <20140113192301.62F8ADEC@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These options fit in much better in the "Virtualization" than in
the processor features menu.  Move them.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Dmitry Torokhov <dtor@vmware.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Alexander Graf <agraf@suse.de>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
---

 linux.git-davehans/arch/x86/Kconfig        |   83 -----------------------------
 linux.git-davehans/arch/x86/Kconfig.virt   |   83 +++++++++++++++++++++++++++++
 linux.git-davehans/arch/x86/lguest/Kconfig |    1 
 3 files changed, 83 insertions(+), 84 deletions(-)

diff -puN arch/x86/Kconfig~x86-Kconfig-move-paravirt-under-virtualization-really arch/x86/Kconfig
--- linux.git/arch/x86/Kconfig~x86-Kconfig-move-paravirt-under-virtualization-really	2014-01-13 11:11:36.847266252 -0800
+++ linux.git-davehans/arch/x86/Kconfig	2014-01-13 11:11:36.851266433 -0800
@@ -1018,89 +1018,6 @@ config X86_ES7000
 	  Support for Unisys ES7000 systems.  Say 'Y' here if this kernel is
 	  supposed to run on an IA32-based Unisys ES7000 system.
 
-menuconfig HYPERVISOR_GUEST
-	bool "Linux guest support"
-	---help---
-	  Say Y here to enable options for running Linux under various hyper-
-	  visors. This option enables basic hypervisor detection and platform
-	  setup.
-
-	  If you say N, all options in this submenu will be skipped and
-	  disabled, and Linux guest support won't be built in.
-
-if HYPERVISOR_GUEST
-
-config PARAVIRT
-	bool "Enable paravirtualization code"
-	---help---
-	  This changes the kernel so it can modify itself when it is run
-	  under a hypervisor, potentially improving performance significantly
-	  over full virtualization.  However, when run without a hypervisor
-	  the kernel is theoretically slower and slightly larger.
-
-config PARAVIRT_DEBUG
-	bool "paravirt-ops debugging"
-	depends on PARAVIRT && DEBUG_KERNEL
-	---help---
-	  Enable to debug paravirt_ops internals.  Specifically, BUG if
-	  a paravirt_op is missing when it is called.
-
-config PARAVIRT_SPINLOCKS
-	bool "Paravirtualization layer for spinlocks"
-	depends on PARAVIRT && SMP
-	select UNINLINE_SPIN_UNLOCK
-	---help---
-	  Paravirtualized spinlocks allow a pvops backend to replace the
-	  spinlock implementation with something virtualization-friendly
-	  (for example, block the virtual CPU rather than spinning).
-
-	  It has a minimal impact on native kernels and gives a nice performance
-	  benefit on paravirtualized KVM / Xen kernels.
-
-	  If you are unsure how to answer this question, answer Y.
-
-source "arch/x86/xen/Kconfig"
-
-config KVM_GUEST
-	bool "KVM Guest support (including kvmclock)"
-	depends on PARAVIRT
-	select PARAVIRT_CLOCK
-	default y
-	---help---
-	  This option enables various optimizations for running under the KVM
-	  hypervisor. It includes a paravirtualized clock, so that instead
-	  of relying on a PIT (or probably other) emulation by the
-	  underlying device model, the host provides the guest with
-	  timing infrastructure such as time of day, and system time
-
-config KVM_DEBUG_FS
-	bool "Enable debug information for KVM Guests in debugfs"
-	depends on KVM_GUEST && DEBUG_FS
-	default n
-	---help---
-	  This option enables collection of various statistics for KVM guest.
-	  Statistics are displayed in debugfs filesystem. Enabling this option
-	  may incur significant overhead.
-
-source "arch/x86/lguest/Kconfig"
-
-config PARAVIRT_TIME_ACCOUNTING
-	bool "Paravirtual steal time accounting"
-	depends on PARAVIRT
-	default n
-	---help---
-	  Select this option to enable fine granularity task steal time
-	  accounting. Time spent executing other tasks in parallel with
-	  the current vCPU is discounted from the vCPU power. To account for
-	  that, there can be a small performance impact.
-
-	  If in doubt, say N here.
-
-config PARAVIRT_CLOCK
-	bool
-
-endif #HYPERVISOR_GUEST
-
 config NO_BOOTMEM
 	def_bool y
 
diff -puN arch/x86/Kconfig.virt~x86-Kconfig-move-paravirt-under-virtualization-really arch/x86/Kconfig.virt
--- linux.git/arch/x86/Kconfig.virt~x86-Kconfig-move-paravirt-under-virtualization-really	2014-01-13 11:11:36.848266297 -0800
+++ linux.git-davehans/arch/x86/Kconfig.virt	2014-01-13 11:11:36.851266433 -0800
@@ -15,4 +15,87 @@ source arch/x86/kvm/Kconfig
 source drivers/vhost/Kconfig
 source drivers/lguest/Kconfig
 
+menuconfig HYPERVISOR_GUEST
+	bool "Linux guest support"
+	---help---
+	  Say Y here to enable options for running Linux under various hyper-
+	  visors. This option enables basic hypervisor detection and platform
+	  setup.
+
+	  If you say N, all options in this submenu will be skipped and
+	  disabled, and Linux guest support won't be built in.
+
+if HYPERVISOR_GUEST
+
+config PARAVIRT
+	bool "Enable paravirtualization code"
+	---help---
+	  This changes the kernel so it can modify itself when it is run
+	  under a hypervisor, potentially improving performance significantly
+	  over full virtualization.  However, when run without a hypervisor
+	  the kernel is theoretically slower and slightly larger.
+
+config PARAVIRT_DEBUG
+	bool "paravirt-ops debugging"
+	depends on PARAVIRT && DEBUG_KERNEL
+	---help---
+	  Enable to debug paravirt_ops internals.  Specifically, BUG if
+	  a paravirt_op is missing when it is called.
+
+config PARAVIRT_SPINLOCKS
+	bool "Paravirtualization layer for spinlocks"
+	depends on PARAVIRT && SMP
+	select UNINLINE_SPIN_UNLOCK
+	---help---
+	  Paravirtualized spinlocks allow a pvops backend to replace the
+	  spinlock implementation with something virtualization-friendly
+	  (for example, block the virtual CPU rather than spinning).
+
+	  It has a minimal impact on native kernels and gives a nice performance
+	  benefit on paravirtualized KVM / Xen kernels.
+
+	  If you are unsure how to answer this question, answer Y.
+
+source "arch/x86/xen/Kconfig"
+
+config KVM_GUEST
+	bool "KVM Guest support (including kvmclock)"
+	depends on PARAVIRT
+	select PARAVIRT_CLOCK
+	default y
+	---help---
+	  This option enables various optimizations for running under the KVM
+	  hypervisor. It includes a paravirtualized clock, so that instead
+	  of relying on a PIT (or probably other) emulation by the
+	  underlying device model, the host provides the guest with
+	  timing infrastructure such as time of day, and system time
+
+config KVM_DEBUG_FS
+	bool "Enable debug information for KVM Guests in debugfs"
+	depends on KVM_GUEST && DEBUG_FS
+	default n
+	---help---
+	  This option enables collection of various statistics for KVM guest.
+	  Statistics are displayed in debugfs filesystem. Enabling this option
+	  may incur significant overhead.
+
+source "arch/x86/lguest/Kconfig"
+
+config PARAVIRT_TIME_ACCOUNTING
+	bool "Paravirtual steal time accounting"
+	depends on PARAVIRT
+	default n
+	---help---
+	  Select this option to enable fine granularity task steal time
+	  accounting. Time spent executing other tasks in parallel with
+	  the current vCPU is discounted from the vCPU power. To account for
+	  that, there can be a small performance impact.
+
+	  If in doubt, say N here.
+
+config PARAVIRT_CLOCK
+	bool
+
+endif #HYPERVISOR_GUEST
+
 endif # VIRTUALIZATION
diff -puN arch/x86/lguest/Kconfig~x86-Kconfig-move-paravirt-under-virtualization-really arch/x86/lguest/Kconfig
--- linux.git/arch/x86/lguest/Kconfig~x86-Kconfig-move-paravirt-under-virtualization-really	2014-01-13 11:11:36.849266343 -0800
+++ linux.git-davehans/arch/x86/lguest/Kconfig	2014-01-13 11:11:36.851266433 -0800
@@ -2,7 +2,6 @@ config LGUEST_GUEST
 	bool "Lguest guest support"
 	depends on X86_32 && PARAVIRT
 	select TTY
-	select VIRTUALIZATION
 	select VIRTIO
 	select VIRTIO_CONSOLE
 	help
_
