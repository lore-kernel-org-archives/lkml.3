Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab3EULam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 07:30:42 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:42766 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897Ab3EULaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 07:30:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Finally eradicate CONFIG_HOTPLUG
Date: Tue, 21 May 2013 13:39:22 +0200
Message-ID: <2876356.8FLyClGTen@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130521134935.d18c3f5c23485fb5ddabc365@canb.auug.org.au>
References: <20130521134935.d18c3f5c23485fb5ddabc365@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 21, 2013 01:49:35 PM Stephen Rothwell wrote:
> Ever since commit 45f035ab9b8f ("CONFIG_HOTPLUG should be always on"),
> it has been basically impossible to build a kernel with CONFIG_HOTPLUG
> turned off.  Remove all the remaining references to it.

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> Cc: linux-arch@vger.kernel.org
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Doug Thompson <dougthompson@xmission.com>
> Cc: linux-edac@vger.kernel.org
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: linux-pci@vger.kernel.org
> Cc: linux-pcmcia@lists.infradead.org
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Steven Whitehouse <swhiteho@redhat.com>
> Cc: cluster-devel@redhat.com
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: linux-pm@vger.kernel.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  Documentation/ABI/testing/sysfs-bus-pci |  5 +----
>  Documentation/SubmitChecklist           |  2 +-
>  Documentation/cpu-hotplug.txt           |  2 +-
>  Documentation/hwmon/submitting-patches  |  3 +--
>  Documentation/kbuild/kconfig.txt        |  2 +-
>  Documentation/usb/hotplug.txt           |  6 +++---
>  arch/arm/Kconfig                        |  2 +-
>  arch/arm/kernel/module.c                |  8 --------
>  arch/arm/kernel/vmlinux.lds.S           |  4 ----
>  arch/arm/mach-ixp4xx/Kconfig            |  1 -
>  arch/blackfin/Kconfig                   |  2 +-
>  arch/cris/arch-v32/drivers/Kconfig      |  1 -
>  arch/ia64/Kconfig                       |  1 -
>  arch/mips/Kconfig                       |  2 +-
>  arch/parisc/Kconfig                     |  1 -
>  arch/powerpc/Kconfig                    |  2 +-
>  arch/powerpc/mm/tlb_hash64.c            |  4 ++--
>  arch/s390/Kconfig                       |  1 -
>  arch/sh/Kconfig                         |  2 +-
>  arch/sparc/Kconfig                      |  1 -
>  arch/x86/Kconfig                        |  2 +-
>  drivers/base/Kconfig                    |  2 --
>  drivers/char/pcmcia/Kconfig             |  2 +-
>  drivers/edac/Kconfig                    |  2 +-
>  drivers/pci/Kconfig                     |  2 --
>  drivers/pci/hotplug/Kconfig             |  2 +-
>  drivers/pcmcia/Kconfig                  |  1 -
>  drivers/staging/media/go7007/go7007.txt |  1 -
>  fs/gfs2/Kconfig                         |  5 ++---
>  include/asm-generic/vmlinux.lds.h       | 20 --------------------
>  init/Kconfig                            |  3 ---
>  kernel/power/Kconfig                    |  1 -
>  mm/Kconfig                              |  2 +-
>  33 files changed, 22 insertions(+), 75 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> index 1ce5ae3..5210a51 100644
> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> @@ -64,7 +64,6 @@ Description:
>  		Writing a non-zero value to this attribute will
>  		force a rescan of all PCI buses in the system, and
>  		re-discover previously removed devices.
> -		Depends on CONFIG_HOTPLUG.
>  
>  What:		/sys/bus/pci/devices/.../msi_irqs/
>  Date:		September, 2011
> @@ -90,7 +89,6 @@ Contact:	Linux PCI developers <linux-pci@vger.kernel.org>
>  Description:
>  		Writing a non-zero value to this attribute will
>  		hot-remove the PCI device and any of its children.
> -		Depends on CONFIG_HOTPLUG.
>  
>  What:		/sys/bus/pci/devices/.../pci_bus/.../rescan
>  Date:		May 2011
> @@ -99,7 +97,7 @@ Description:
>  		Writing a non-zero value to this attribute will
>  		force a rescan of the bus and all child buses,
>  		and re-discover devices removed earlier from this
> -		part of the device tree.  Depends on CONFIG_HOTPLUG.
> +		part of the device tree.
>  
>  What:		/sys/bus/pci/devices/.../rescan
>  Date:		January 2009
> @@ -109,7 +107,6 @@ Description:
>  		force a rescan of the device's parent bus and all
>  		child buses, and re-discover devices removed earlier
>  		from this part of the device tree.
> -		Depends on CONFIG_HOTPLUG.
>  
>  What:		/sys/bus/pci/devices/.../reset
>  Date:		July 2009
> diff --git a/Documentation/SubmitChecklist b/Documentation/SubmitChecklist
> index dc0e332..2b7e32d 100644
> --- a/Documentation/SubmitChecklist
> +++ b/Documentation/SubmitChecklist
> @@ -105,5 +105,5 @@ kernel patches.
>      same time, just various/random combinations of them]:
>  
>      CONFIG_SMP, CONFIG_SYSFS, CONFIG_PROC_FS, CONFIG_INPUT, CONFIG_PCI,
> -    CONFIG_BLOCK, CONFIG_PM, CONFIG_HOTPLUG, CONFIG_MAGIC_SYSRQ,
> +    CONFIG_BLOCK, CONFIG_PM, CONFIG_MAGIC_SYSRQ,
>      CONFIG_NET, CONFIG_INET=n (but latter with CONFIG_NET=y)
> diff --git a/Documentation/cpu-hotplug.txt b/Documentation/cpu-hotplug.txt
> index 9f40135..0efd1b9 100644
> --- a/Documentation/cpu-hotplug.txt
> +++ b/Documentation/cpu-hotplug.txt
> @@ -128,7 +128,7 @@ A: When doing make defconfig, Enable CPU hotplug support
>  
>     "Processor type and Features" -> Support for Hotpluggable CPUs
>  
> -Make sure that you have CONFIG_HOTPLUG, and CONFIG_SMP turned on as well.
> +Make sure that you have CONFIG_SMP turned on as well.
>  
>  You would need to enable CONFIG_HOTPLUG_CPU for SMP suspend/resume support
>  as well.
> diff --git a/Documentation/hwmon/submitting-patches b/Documentation/hwmon/submitting-patches
> index 843751c..4628646 100644
> --- a/Documentation/hwmon/submitting-patches
> +++ b/Documentation/hwmon/submitting-patches
> @@ -27,8 +27,7 @@ increase the chances of your change being accepted.
>    explicitly below the patch header.
>  
>  * If your patch (or the driver) is affected by configuration options such as
> -  CONFIG_SMP or CONFIG_HOTPLUG, make sure it compiles for all configuration
> -  variants.
> +  CONFIG_SMP, make sure it compiles for all configuration variants.
>  
>  
>  2. Adding functionality to existing drivers
> diff --git a/Documentation/kbuild/kconfig.txt b/Documentation/kbuild/kconfig.txt
> index 3f429ed..213859e 100644
> --- a/Documentation/kbuild/kconfig.txt
> +++ b/Documentation/kbuild/kconfig.txt
> @@ -165,7 +165,7 @@ Searching in menuconfig:
>  	Example:
>  		/hotplug
>  		This lists all config symbols that contain "hotplug",
> -		e.g., HOTPLUG, HOTPLUG_CPU, MEMORY_HOTPLUG.
> +		e.g., HOTPLUG_CPU, MEMORY_HOTPLUG.
>  
>  	For search help, enter / followed TAB-TAB-TAB (to highlight
>  	<Help>) and Enter.  This will tell you that you can also use
> diff --git a/Documentation/usb/hotplug.txt b/Documentation/usb/hotplug.txt
> index 4c94571..6424b13 100644
> --- a/Documentation/usb/hotplug.txt
> +++ b/Documentation/usb/hotplug.txt
> @@ -33,9 +33,9 @@ you get the best hotplugging when you configure a highly modular system.
>  
>  KERNEL HOTPLUG HELPER (/sbin/hotplug)
>  
> -When you compile with CONFIG_HOTPLUG, you get a new kernel parameter:
> -/proc/sys/kernel/hotplug, which normally holds the pathname "/sbin/hotplug".
> -That parameter names a program which the kernel may invoke at various times.
> +There is a kernel parameter: /proc/sys/kernel/hotplug, which normally
> +holds the pathname "/sbin/hotplug".  That parameter names a program
> +which the kernel may invoke at various times.
>  
>  The /sbin/hotplug program can be invoked by any subsystem as part of its
>  reaction to a configuration change, from a thread in that subsystem.
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index d423d58..b30db02 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1527,7 +1527,7 @@ config NR_CPUS
>  
>  config HOTPLUG_CPU
>  	bool "Support for hot-pluggable CPUs"
> -	depends on SMP && HOTPLUG
> +	depends on SMP
>  	help
>  	  Say Y here to experiment with turning CPUs off and on.  CPUs
>  	  can be controlled through /sys/devices/system/cpu.
> diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
> index 1e9be5d..85c3fb6 100644
> --- a/arch/arm/kernel/module.c
> +++ b/arch/arm/kernel/module.c
> @@ -288,24 +288,16 @@ int module_finalize(const Elf32_Ehdr *hdr, const Elf_Shdr *sechdrs,
>  
>  		if (strcmp(".ARM.exidx.init.text", secname) == 0)
>  			maps[ARM_SEC_INIT].unw_sec = s;
> -		else if (strcmp(".ARM.exidx.devinit.text", secname) == 0)
> -			maps[ARM_SEC_DEVINIT].unw_sec = s;
>  		else if (strcmp(".ARM.exidx", secname) == 0)
>  			maps[ARM_SEC_CORE].unw_sec = s;
>  		else if (strcmp(".ARM.exidx.exit.text", secname) == 0)
>  			maps[ARM_SEC_EXIT].unw_sec = s;
> -		else if (strcmp(".ARM.exidx.devexit.text", secname) == 0)
> -			maps[ARM_SEC_DEVEXIT].unw_sec = s;
>  		else if (strcmp(".init.text", secname) == 0)
>  			maps[ARM_SEC_INIT].txt_sec = s;
> -		else if (strcmp(".devinit.text", secname) == 0)
> -			maps[ARM_SEC_DEVINIT].txt_sec = s;
>  		else if (strcmp(".text", secname) == 0)
>  			maps[ARM_SEC_CORE].txt_sec = s;
>  		else if (strcmp(".exit.text", secname) == 0)
>  			maps[ARM_SEC_EXIT].txt_sec = s;
> -		else if (strcmp(".devexit.text", secname) == 0)
> -			maps[ARM_SEC_DEVEXIT].txt_sec = s;
>  	}
>  
>  	for (i = 0; i < ARM_SEC_MAX; i++)
> diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
> index a871b8e..fa25e4e 100644
> --- a/arch/arm/kernel/vmlinux.lds.S
> +++ b/arch/arm/kernel/vmlinux.lds.S
> @@ -70,10 +70,6 @@ SECTIONS
>  		ARM_EXIT_DISCARD(EXIT_TEXT)
>  		ARM_EXIT_DISCARD(EXIT_DATA)
>  		EXIT_CALL
> -#ifndef CONFIG_HOTPLUG
> -		*(.ARM.exidx.devexit.text)
> -		*(.ARM.extab.devexit.text)
> -#endif
>  #ifndef CONFIG_MMU
>  		*(.fixup)
>  		*(__ex_table)
> diff --git a/arch/arm/mach-ixp4xx/Kconfig b/arch/arm/mach-ixp4xx/Kconfig
> index 73a2d90..30e1ebe 100644
> --- a/arch/arm/mach-ixp4xx/Kconfig
> +++ b/arch/arm/mach-ixp4xx/Kconfig
> @@ -235,7 +235,6 @@ config IXP4XX_QMGR
>  config IXP4XX_NPE
>  	tristate "IXP4xx Network Processor Engine support"
>  	select FW_LOADER
> -	select HOTPLUG
>  	help
>  	  This driver supports IXP4xx built-in network coprocessors
>  	  and is automatically selected by Ethernet and HSS drivers.
> diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
> index a117652..b573827 100644
> --- a/arch/blackfin/Kconfig
> +++ b/arch/blackfin/Kconfig
> @@ -253,7 +253,7 @@ config NR_CPUS
>  
>  config HOTPLUG_CPU
>  	bool "Support for hot-pluggable CPUs"
> -	depends on SMP && HOTPLUG
> +	depends on SMP
>  	default y
>  
>  config BF_REV_MIN
> diff --git a/arch/cris/arch-v32/drivers/Kconfig b/arch/cris/arch-v32/drivers/Kconfig
> index c55971a..ab725ed 100644
> --- a/arch/cris/arch-v32/drivers/Kconfig
> +++ b/arch/cris/arch-v32/drivers/Kconfig
> @@ -617,7 +617,6 @@ config ETRAX_PV_CHANGEABLE_BITS
>  config ETRAX_CARDBUS
>          bool "Cardbus support"
>          depends on ETRAX_ARCH_V32
> -        select HOTPLUG
>          help
>  	 Enabled the ETRAX Cardbus driver.
>  
> diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
> index 1a2b774..5a768ad 100644
> --- a/arch/ia64/Kconfig
> +++ b/arch/ia64/Kconfig
> @@ -376,7 +376,6 @@ config NR_CPUS
>  config HOTPLUG_CPU
>  	bool "Support for hot-pluggable CPUs"
>  	depends on SMP
> -	select HOTPLUG
>  	default n
>  	---help---
>  	  Say Y here to experiment with turning CPUs off and on.  CPUs
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index 7a58ab9..e433b90 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -962,7 +962,7 @@ config SYS_HAS_EARLY_PRINTK
>  
>  config HOTPLUG_CPU
>  	bool "Support for hot-pluggable CPUs"
> -	depends on SMP && HOTPLUG && SYS_SUPPORTS_HOTPLUG_CPU
> +	depends on SMP && SYS_SUPPORTS_HOTPLUG_CPU
>  	help
>  	  Say Y here to allow turning CPUs off and on. CPUs can be
>  	  controlled through /sys/devices/system/cpu.
> diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
> index cad060f..6d0969a 100644
> --- a/arch/parisc/Kconfig
> +++ b/arch/parisc/Kconfig
> @@ -254,7 +254,6 @@ config IRQSTACKS
>  config HOTPLUG_CPU
>  	bool
>  	default y if SMP
> -	select HOTPLUG
>  
>  config ARCH_SELECT_MEMORY_MODEL
>  	def_bool y
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index c33e3ad..508e3fe 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -341,7 +341,7 @@ config SWIOTLB
>  
>  config HOTPLUG_CPU
>  	bool "Support for enabling/disabling CPUs"
> -	depends on SMP && HOTPLUG && (PPC_PSERIES || \
> +	depends on SMP && (PPC_PSERIES || \
>  	PPC_PMAC || PPC_POWERNV || (PPC_85xx && !PPC_E500MC))
>  	---help---
>  	  Say Y here to be able to disable and re-enable individual
> diff --git a/arch/powerpc/mm/tlb_hash64.c b/arch/powerpc/mm/tlb_hash64.c
> index 023ec8a..7df1c5e 100644
> --- a/arch/powerpc/mm/tlb_hash64.c
> +++ b/arch/powerpc/mm/tlb_hash64.c
> @@ -183,8 +183,8 @@ void tlb_flush(struct mmu_gather *tlb)
>   * since 64K pages may overlap with other bridges when using 64K pages
>   * with 4K HW pages on IO space.
>   *
> - * Because of that usage pattern, it's only available with CONFIG_HOTPLUG
> - * and is implemented for small size rather than speed.
> + * Because of that usage pattern, it is implemented for small size rather
> + * than speed.
>   */
>  void __flush_hash_table_range(struct mm_struct *mm, unsigned long start,
>  			      unsigned long end)
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index 2c9789d..d97868b 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -302,7 +302,6 @@ config HOTPLUG_CPU
>  	def_bool y
>  	prompt "Support for hot-pluggable CPUs"
>  	depends on SMP
> -	select HOTPLUG
>  	help
>  	  Say Y here to be able to turn CPUs off and on. CPUs
>  	  can be controlled through /sys/devices/system/cpu/cpu#.
> diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
> index 8c868cf..1020dd8 100644
> --- a/arch/sh/Kconfig
> +++ b/arch/sh/Kconfig
> @@ -748,7 +748,7 @@ config NR_CPUS
>  
>  config HOTPLUG_CPU
>  	bool "Support for hot-pluggable CPUs (EXPERIMENTAL)"
> -	depends on SMP && HOTPLUG
> +	depends on SMP
>  	help
>  	  Say Y here to experiment with turning CPUs off and on.  CPUs
>  	  can be controlled through /sys/devices/system/cpu.
> diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
> index 9ac9f16..a00cbd3 100644
> --- a/arch/sparc/Kconfig
> +++ b/arch/sparc/Kconfig
> @@ -243,7 +243,6 @@ config SECCOMP
>  config HOTPLUG_CPU
>  	bool "Support for hot-pluggable CPUs"
>  	depends on SPARC64 && SMP
> -	select HOTPLUG
>  	help
>  	  Say Y here to experiment with turning CPUs off and on.  CPUs
>  	  can be controlled through /sys/devices/system/cpu/cpu#.
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 6a154a9..770cf04 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1726,7 +1726,7 @@ config PHYSICAL_ALIGN
>  
>  config HOTPLUG_CPU
>  	bool "Support for hot-pluggable CPUs"
> -	depends on SMP && HOTPLUG
> +	depends on SMP
>  	---help---
>  	  Say Y here to allow turning CPUs off and on. CPUs can be
>  	  controlled through /sys/devices/system/cpu.
> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index 07abd9d..5daa259 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -2,7 +2,6 @@ menu "Generic Driver Options"
>  
>  config UEVENT_HELPER_PATH
>  	string "path to uevent helper"
> -	depends on HOTPLUG
>  	default ""
>  	help
>  	  Path to uevent helper program forked by the kernel for
> @@ -23,7 +22,6 @@ config UEVENT_HELPER_PATH
>  
>  config DEVTMPFS
>  	bool "Maintain a devtmpfs filesystem to mount at /dev"
> -	depends on HOTPLUG
>  	help
>  	  This creates a tmpfs/ramfs filesystem instance early at bootup.
>  	  In this filesystem, the kernel driver core maintains device
> diff --git a/drivers/char/pcmcia/Kconfig b/drivers/char/pcmcia/Kconfig
> index 2a166d5..b27f534 100644
> --- a/drivers/char/pcmcia/Kconfig
> +++ b/drivers/char/pcmcia/Kconfig
> @@ -3,7 +3,7 @@
>  #
>  
>  menu "PCMCIA character devices"
> -	depends on HOTPLUG && PCMCIA!=n
> +	depends on PCMCIA!=n
>  
>  config SYNCLINK_CS
>  	tristate "SyncLink PC Card support"
> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
> index e443f2c1..a697a64 100644
> --- a/drivers/edac/Kconfig
> +++ b/drivers/edac/Kconfig
> @@ -145,7 +145,7 @@ config EDAC_E7XXX
>  
>  config EDAC_E752X
>  	tristate "Intel e752x (e7520, e7525, e7320) and 3100"
> -	depends on EDAC_MM_EDAC && PCI && X86 && HOTPLUG
> +	depends on EDAC_MM_EDAC && PCI && X86
>  	help
>  	  Support for error detection and correction on the Intel
>  	  E7520, E7525, E7320 server chipsets.
> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index 6d51aa6..77497f1 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -55,7 +55,6 @@ config PCI_STUB
>  config XEN_PCIDEV_FRONTEND
>          tristate "Xen PCI Frontend"
>          depends on PCI && X86 && XEN
> -        select HOTPLUG
>          select PCI_XEN
>  	select XEN_XENBUS_FRONTEND
>          default y
> @@ -113,7 +112,6 @@ config PCI_IOAPIC
>  	tristate "PCI IO-APIC hotplug support" if X86
>  	depends on PCI
>  	depends on ACPI
> -	depends on HOTPLUG
>  	default !X86
>  
>  config PCI_LABEL
> diff --git a/drivers/pci/hotplug/Kconfig b/drivers/pci/hotplug/Kconfig
> index 9fcb87f..bb7ebb2 100644
> --- a/drivers/pci/hotplug/Kconfig
> +++ b/drivers/pci/hotplug/Kconfig
> @@ -4,7 +4,7 @@
>  
>  menuconfig HOTPLUG_PCI
>  	tristate "Support for PCI Hotplug"
> -	depends on PCI && HOTPLUG && SYSFS
> +	depends on PCI && SYSFS
>  	---help---
>  	  Say Y here if you have a motherboard with a PCI Hotplug controller.
>  	  This allows you to add and remove PCI cards while the machine is
> diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
> index b90f85b..1c63624 100644
> --- a/drivers/pcmcia/Kconfig
> +++ b/drivers/pcmcia/Kconfig
> @@ -4,7 +4,6 @@
>  
>  menuconfig PCCARD
>  	tristate "PCCard (PCMCIA/CardBus) support"
> -	depends on HOTPLUG
>  	---help---
>  	  Say Y here if you want to attach PCMCIA- or PC-cards to your Linux
>  	  computer.  These are credit-card size devices such as network cards,
> diff --git a/drivers/staging/media/go7007/go7007.txt b/drivers/staging/media/go7007/go7007.txt
> index fcb3e23..dc0026c 100644
> --- a/drivers/staging/media/go7007/go7007.txt
> +++ b/drivers/staging/media/go7007/go7007.txt
> @@ -78,7 +78,6 @@ All vendor-built kernels should already be configured properly.  However,
>  for custom-built kernels, the following options need to be enabled in the
>  kernel as built-in or modules:
>  
> -	CONFIG_HOTPLUG           - Support for hot-pluggable devices
>  	CONFIG_MODULES           - Enable loadable module support
>  	CONFIG_KMOD              - Automatic kernel module loading
>  	CONFIG_FW_LOADER         - Hotplug firmware loading support
> diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
> index eb08c9e..432ea56 100644
> --- a/fs/gfs2/Kconfig
> +++ b/fs/gfs2/Kconfig
> @@ -20,13 +20,12 @@ config GFS2_FS
>  	  be found here: http://sources.redhat.com/cluster
>  
>  	  The "nolock" lock module is now built in to GFS2 by default. If
> -	  you want to use the DLM, be sure to enable HOTPLUG and IPv4/6
> -	  networking.
> +	  you want to use the DLM, be sure to enable IPv4/6 networking.
>  
>  config GFS2_FS_LOCKING_DLM
>  	bool "GFS2 DLM locking"
>  	depends on (GFS2_FS!=n) && NET && INET && (IPV6 || IPV6=n) && \
> -		HOTPLUG && DLM && CONFIGFS_FS && SYSFS
> +		DLM && CONFIGFS_FS && SYSFS
>  	help
>  	  Multiple node locking module for GFS2
>  
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index eb58d2d..4f27372 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -68,14 +68,6 @@
>   * are handled as text/data or they can be discarded (which
>   * often happens at runtime)
>   */
> -#ifdef CONFIG_HOTPLUG
> -#define DEV_KEEP(sec)    *(.dev##sec)
> -#define DEV_DISCARD(sec)
> -#else
> -#define DEV_KEEP(sec)
> -#define DEV_DISCARD(sec) *(.dev##sec)
> -#endif
> -
>  #ifdef CONFIG_HOTPLUG_CPU
>  #define CPU_KEEP(sec)    *(.cpu##sec)
>  #define CPU_DISCARD(sec)
> @@ -182,8 +174,6 @@
>  	*(.data)							\
>  	*(.ref.data)							\
>  	*(.data..shared_aligned) /* percpu related */			\
> -	DEV_KEEP(init.data)						\
> -	DEV_KEEP(exit.data)						\
>  	CPU_KEEP(init.data)						\
>  	CPU_KEEP(exit.data)						\
>  	MEM_KEEP(init.data)						\
> @@ -372,8 +362,6 @@
>  	/* __*init sections */						\
>  	__init_rodata : AT(ADDR(__init_rodata) - LOAD_OFFSET) {		\
>  		*(.ref.rodata)						\
> -		DEV_KEEP(init.rodata)					\
> -		DEV_KEEP(exit.rodata)					\
>  		CPU_KEEP(init.rodata)					\
>  		CPU_KEEP(exit.rodata)					\
>  		MEM_KEEP(init.rodata)					\
> @@ -416,8 +404,6 @@
>  		*(.text.hot)						\
>  		*(.text)						\
>  		*(.ref.text)						\
> -	DEV_KEEP(init.text)						\
> -	DEV_KEEP(exit.text)						\
>  	CPU_KEEP(init.text)						\
>  	CPU_KEEP(exit.text)						\
>  	MEM_KEEP(init.text)						\
> @@ -503,7 +489,6 @@
>  /* init and exit section handling */
>  #define INIT_DATA							\
>  	*(.init.data)							\
> -	DEV_DISCARD(init.data)						\
>  	CPU_DISCARD(init.data)						\
>  	MEM_DISCARD(init.data)						\
>  	KERNEL_CTORS()							\
> @@ -511,7 +496,6 @@
>  	*(.init.rodata)							\
>  	FTRACE_EVENTS()							\
>  	TRACE_SYSCALLS()						\
> -	DEV_DISCARD(init.rodata)					\
>  	CPU_DISCARD(init.rodata)					\
>  	MEM_DISCARD(init.rodata)					\
>  	CLK_OF_TABLES()							\
> @@ -521,14 +505,11 @@
>  
>  #define INIT_TEXT							\
>  	*(.init.text)							\
> -	DEV_DISCARD(init.text)						\
>  	CPU_DISCARD(init.text)						\
>  	MEM_DISCARD(init.text)
>  
>  #define EXIT_DATA							\
>  	*(.exit.data)							\
> -	DEV_DISCARD(exit.data)						\
> -	DEV_DISCARD(exit.rodata)					\
>  	CPU_DISCARD(exit.data)						\
>  	CPU_DISCARD(exit.rodata)					\
>  	MEM_DISCARD(exit.data)						\
> @@ -536,7 +517,6 @@
>  
>  #define EXIT_TEXT							\
>  	*(.exit.text)							\
> -	DEV_DISCARD(exit.text)						\
>  	CPU_DISCARD(exit.text)						\
>  	MEM_DISCARD(exit.text)
>  
> diff --git a/init/Kconfig b/init/Kconfig
> index 9d3a788..a5e0917 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1244,9 +1244,6 @@ config SYSCTL_ARCH_UNALIGN_ALLOW
>  	  the unaligned access emulation.
>  	  see arch/parisc/kernel/unaligned.c for reference
>  
> -config HOTPLUG
> -	def_bool y
> -
>  config HAVE_PCSPKR_PLATFORM
>  	bool
>  
> diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
> index 5dfdc9e..9c39de0 100644
> --- a/kernel/power/Kconfig
> +++ b/kernel/power/Kconfig
> @@ -100,7 +100,6 @@ config PM_SLEEP_SMP
>  	depends on SMP
>  	depends on ARCH_SUSPEND_POSSIBLE || ARCH_HIBERNATION_POSSIBLE
>  	depends on PM_SLEEP
> -	select HOTPLUG
>  	select HOTPLUG_CPU
>  
>  config PM_AUTOSLEEP
> diff --git a/mm/Kconfig b/mm/Kconfig
> index e742d06..f5e698e 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -173,7 +173,7 @@ config HAVE_BOOTMEM_INFO_NODE
>  config MEMORY_HOTPLUG
>  	bool "Allow for memory hot-add"
>  	depends on SPARSEMEM || X86_64_ACPI_NUMA
> -	depends on HOTPLUG && ARCH_ENABLE_MEMORY_HOTPLUG
> +	depends on ARCH_ENABLE_MEMORY_HOTPLUG
>  	depends on (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)
>  
>  config MEMORY_HOTPLUG_SPARSE
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
