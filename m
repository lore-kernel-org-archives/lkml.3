Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab3LDDbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 22:31:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:55477 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab3LDDbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 22:31:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,822,1378882800"; 
   d="scan'208";a="438128379"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] ACPI: Cleanup <acpi/acpi.h>, <acpi/acpi_bus.h> and
 <acpi/acpi_drivers.h> inclusions.
Thread-Topic: [PATCH v2] ACPI: Cleanup <acpi/acpi.h>, <acpi/acpi_bus.h> and
 <acpi/acpi_drivers.h> inclusions.
Thread-Index: AQHO8IN8tsdUzD/SH0inO/nl6LJY6ZpDYQaA
Date: Wed, 4 Dec 2013 03:31:10 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E880249412B@SHSMSX101.ccr.corp.intel.com>
References: <cover.1385094640.git.lv.zheng@intel.com>
 <2011704.hD86fZ2Qk5@vostro.rjw.lan> <77005542.rPYLivMWph@vostro.rjw.lan>
 <4625444.InXL8HxLal@vostro.rjw.lan>
In-Reply-To: <4625444.InXL8HxLal@vostro.rjw.lan>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rB43Vqfr030249

> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> Sent: Wednesday, December 04, 2013 7:58 AM
> 
> On Thursday, November 28, 2013 03:18:54 PM Rafael J. Wysocki wrote:
> > On Tuesday, November 26, 2013 09:29:33 PM Rafael J. Wysocki wrote:
> > > On Tuesday, November 26, 2013 01:21:15 PM Lv Zheng wrote:
> > > > Replace direct inclusions of <acpi/acpi.h>, <acpi/acpi_bus.h> and
> > > > <acpi/acpi_drivers.h>, which are incorrect, with <linux/acpi.h> inclusions.
> > > >
> > > > First of all, <acpi/acpi.h>, <acpi/acpi_bus.h> and <acpi/acpi_drivers.h>
> > > > should not be included directly from any files that are built for
> > > > CONFIG_ACPI unset, because that generally leads to build warnings about
> > > > undefined symbols in !CONFIG_ACPI builds.  For CONFIG_ACPI set,
> > > > <linux/acpi.h> includes those files and for !CONFIG_ACPI it provides stub
> > > > ACPI symbols to be used in that case.
> > > >
> > > > Second, there are ordering dependencies between those files that always
> > > > have to be met.  Namely, it is required that <acpi/acpi_bus.h> be included
> > > > prior to <acpi/acpi_drivers.h> so that the acpi_pci_root declarations the
> > > > latter depends on are always there.  And <acpi/acpi.h> which provides
> > > > basic ACPICA type declarations should always be included prior to any other
> > > > ACPI headers in CONFIG_ACPI builds.  That also is taken care of including
> > > > <linux/acpi.h> as appropriate.
> > > >
> > > > This patch also includes necessary cleanups in the affected files where
> > > > other ACPI headers is also included but not referenced.
> > > >
> > >
> > > This looks OK to me, but it touches several other subsystems.  It's better to
> > > CC such things to linux-kernel at least.
> > >
> > > Peter, Matthew, Tony, Konrad, Greg, Bjorn, do you have any objections against this?
> >
> > Since no one seems to have problems with this, I've queued it up for the next ACPI
> > pull request, if there are no problems with auto builds.
> 
> I replaced this patch with the following one due to built errors introduced by
> it for exotic combinations of Kconfig options.
> 
> The only difference is the few files where the /* FIXME: ... */ comments have
> been added.

Thanks for the helping.
Please also check if the fixes in the "ACPI: Cleanup direct ACPICA inclusions." series can actually sort the FIXMEs out.

Thanks and best regards
-Lv
> 
> Thanks,
> Rafael
> 
> 
> ---
> From: Lv Zheng <lv.zheng@intel.com>
> Subject: ACPI: Clean up inclusions of ACPI header files
> 
> Replace direct inclusions of <acpi/acpi.h>, <acpi/acpi_bus.h> and
> <acpi/acpi_drivers.h>, which are incorrect, with <linux/acpi.h>
> inclusions and remove some inclusions of those files that aren't
> necessary.
> 
> First of all, <acpi/acpi.h>, <acpi/acpi_bus.h> and <acpi/acpi_drivers.h>
> should not be included directly from any files that are built for
> CONFIG_ACPI unset, because that generally leads to build warnings about
> undefined symbols in !CONFIG_ACPI builds.  For CONFIG_ACPI set,
> <linux/acpi.h> includes those files and for CONFIG_ACPI unset it
> provides stub ACPI symbols to be used in that case.
> 
> Second, there are ordering dependencies between those files that always
> have to be met.  Namely, it is required that <acpi/acpi_bus.h> be included
> prior to <acpi/acpi_drivers.h> so that the acpi_pci_root declarations the
> latter depends on are always there.  And <acpi/acpi.h> which provides
> basic ACPICA type declarations should always be included prior to any other
> ACPI headers in CONFIG_ACPI builds.  That also is taken care of including
> <linux/acpi.h> as appropriate.
> 
> Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com> (drivers/pci stuff)
> ---
>  arch/ia64/hp/common/aml_nfw.c                        |    3 +--
>  arch/x86/kernel/apic/apic_flat_64.c                  |    4 +---
>  arch/x86/kernel/apic/io_apic.c                       |    3 ---
>  arch/x86/pci/mmconfig_32.c                           |    1 -
>  arch/x86/platform/olpc/olpc-xo15-sci.c               |    3 +--
>  drivers/acpi/ac.c                                    |    3 +--
>  drivers/acpi/acpi_extlog.c                           |    1 -
>  drivers/acpi/acpi_pad.c                              |    3 +--
>  drivers/acpi/apei/einj.c                             |    1 -
>  drivers/acpi/battery.c                               |    3 +--
>  drivers/acpi/blacklist.c                             |    1 -
>  drivers/acpi/bus.c                                   |    2 --
>  drivers/acpi/button.c                                |    3 +--
>  drivers/acpi/custom_method.c                         |    2 +-
>  drivers/acpi/debugfs.c                               |    2 +-
>  drivers/acpi/dock.c                                  |    2 --
>  drivers/acpi/ec.c                                    |    5 ++---
>  drivers/acpi/event.c                                 |    2 +-
>  drivers/acpi/fan.c                                   |    3 +--
>  drivers/acpi/hed.c                                   |    2 --
>  drivers/acpi/numa.c                                  |    1 -
>  drivers/acpi/osl.c                                   |    3 ---
>  drivers/acpi/pci_irq.c                               |    2 --
>  drivers/acpi/pci_link.c                              |    4 +---
>  drivers/acpi/pci_root.c                              |    4 +---
>  drivers/acpi/power.c                                 |    3 +--
>  drivers/acpi/proc.c                                  |    4 +---
>  drivers/acpi/processor_core.c                        |    3 +--
>  drivers/acpi/processor_idle.c                        |    4 +---
>  drivers/acpi/processor_perflib.c                     |    7 ++-----
>  drivers/acpi/processor_thermal.c                     |    7 ++-----
>  drivers/acpi/processor_throttling.c                  |    7 ++-----
>  drivers/acpi/sbshc.c                                 |    3 +--
>  drivers/acpi/scan.c                                  |    3 ---
>  drivers/acpi/sleep.c                                 |    4 ----
>  drivers/acpi/sysfs.c                                 |    2 +-
>  drivers/acpi/thermal.c                               |    5 ++---
>  drivers/acpi/utils.c                                 |    2 --
>  drivers/acpi/video.c                                 |    5 ++---
>  drivers/acpi/wakeup.c                                |    1 -
>  drivers/ata/libata-acpi.c                            |    2 --
>  drivers/ata/pata_acpi.c                              |    5 ++---
>  drivers/char/hpet.c                                  |    7 ++-----
>  drivers/char/tpm/tpm_acpi.c                          |    2 +-
>  drivers/char/tpm/tpm_ppi.c                           |    1 -
>  drivers/gpu/drm/i915/intel_acpi.c                    |    2 --
>  drivers/gpu/drm/nouveau/nouveau_acpi.c               |    7 +------
>  drivers/gpu/drm/radeon/radeon_acpi.c                 |    6 +-----
>  drivers/hv/vmbus_drv.c                               |    2 --
>  drivers/hwmon/acpi_power_meter.c                     |    3 +--
>  drivers/hwmon/asus_atk0110.c                         |    6 +-----
>  drivers/ide/ide-acpi.c                               |    1 -
>  drivers/input/misc/atlas_btns.c                      |    2 +-
>  drivers/iommu/amd_iommu_init.c                       |    1 -
>  drivers/iommu/intel_irq_remapping.c                  |    4 ++--
>  drivers/pci/hotplug/acpiphp_ibm.c                    |    3 +--
>  drivers/pci/hotplug/pciehp.h                         |    2 --
>  drivers/pci/ioapic.c                                 |    1 -
>  drivers/pci/pci-acpi.c                               |    3 ---
>  drivers/pci/pci-label.c                              |    1 -
>  drivers/platform/x86/acer-wmi.c                      |    2 --
>  drivers/platform/x86/asus-laptop.c                   |    3 +--
>  drivers/platform/x86/asus-wmi.c                      |    3 +--
>  drivers/platform/x86/classmate-laptop.c              |    3 +--
>  drivers/platform/x86/dell-wmi-aio.c                  |    1 -
>  drivers/platform/x86/dell-wmi.c                      |    1 -
>  drivers/platform/x86/eeepc-laptop.c                  |    3 +--
>  drivers/platform/x86/eeepc-wmi.c                     |    2 +-
>  drivers/platform/x86/hp_accel.c                      |    2 +-
>  drivers/platform/x86/ideapad-laptop.c                |    3 +--
>  drivers/platform/x86/intel-rst.c                     |    2 +-
>  drivers/platform/x86/intel-smartconnect.c            |    2 +-
>  drivers/platform/x86/intel_menlow.c                  |    4 +---
>  drivers/platform/x86/intel_oaktrail.c                |    3 ---
>  drivers/platform/x86/mxm-wmi.c                       |    3 +--
>  drivers/platform/x86/panasonic-laptop.c              |    4 +---
>  drivers/platform/x86/pvpanic.c                       |    3 +--
>  drivers/platform/x86/samsung-q10.c                   |    2 +-
>  drivers/platform/x86/sony-laptop.c                   |    4 +---
>  drivers/platform/x86/tc1100-wmi.c                    |    4 +---
>  drivers/platform/x86/thinkpad_acpi.c                 |   14 ++++----------
>  drivers/platform/x86/toshiba_acpi.c                  |    4 +---
>  drivers/platform/x86/toshiba_bluetooth.c             |    4 +---
>  drivers/platform/x86/wmi.c                           |    2 --
>  drivers/platform/x86/xo15-ebook.c                    |    3 +--
>  drivers/pnp/pnpacpi/core.c                           |    1 -
>  drivers/pnp/pnpacpi/pnpacpi.h                        |    1 -
>  drivers/sfi/sfi_acpi.c                               |    2 +-
>  drivers/staging/quickstart/quickstart.c              |    2 +-
>  drivers/usb/core/usb-acpi.c                          |    1 -
>  drivers/xen/xen-acpi-cpuhotplug.c                    |    3 ---
>  drivers/xen/xen-acpi-memhotplug.c                    |    1 -
>  drivers/xen/xen-acpi-pad.c                           |    5 ++---
>  drivers/xen/xen-acpi-processor.c                     |    4 +---
>  include/acpi/acpi_bus.h                              |    2 --
>  include/acpi/acpi_drivers.h                          |    3 ---
>  include/linux/acpi_io.h                              |    2 +-
>  include/linux/ide.h                                  |    8 ++------
>  include/linux/iscsi_ibft.h                           |    2 +-
>  include/linux/pci_hotplug.h                          |    3 +--
>  include/linux/sfi_acpi.h                             |    2 +-
>  include/linux/tboot.h                                |    2 +-
>  tools/power/cpupower/debug/kernel/cpufreq-test_tsc.c |    5 +----
>  103 files changed, 80 insertions(+), 234 deletions(-)
> 
> diff --git a/arch/ia64/hp/common/aml_nfw.c b/arch/ia64/hp/common/aml_nfw.c
> index 916ffe7..84715fc 100644
> --- a/arch/ia64/hp/common/aml_nfw.c
> +++ b/arch/ia64/hp/common/aml_nfw.c
> @@ -23,8 +23,7 @@
>   */
> 
>  #include <linux/module.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
>  #include <asm/sal.h>
> 
>  MODULE_AUTHOR("Bjorn Helgaas <bjorn.helgaas@hp.com>");
> diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
> index 00c77cf..ccbf857 100644
> --- a/arch/x86/kernel/apic/apic_flat_64.c
> +++ b/arch/x86/kernel/apic/apic_flat_64.c
> @@ -21,9 +21,7 @@
>  #include <asm/apic.h>
>  #include <asm/ipi.h>
> 
> -#ifdef CONFIG_ACPI
> -#include <acpi/acpi_bus.h>
> -#endif
> +#include <linux/acpi.h>
> 
>  static struct apic apic_physflat;
>  static struct apic apic_flat;
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index e63a5bd..4d67a75 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -37,9 +37,6 @@
>  #include <linux/kthread.h>
>  #include <linux/jiffies.h>	/* time_after() */
>  #include <linux/slab.h>
> -#ifdef CONFIG_ACPI
> -#include <acpi/acpi_bus.h>
> -#endif
>  #include <linux/bootmem.h>
>  #include <linux/dmar.h>
>  #include <linux/hpet.h>
> diff --git a/arch/x86/pci/mmconfig_32.c b/arch/x86/pci/mmconfig_32.c
> index 5c90975..43984bc 100644
> --- a/arch/x86/pci/mmconfig_32.c
> +++ b/arch/x86/pci/mmconfig_32.c
> @@ -14,7 +14,6 @@
>  #include <linux/rcupdate.h>
>  #include <asm/e820.h>
>  #include <asm/pci_x86.h>
> -#include <acpi/acpi.h>
> 
>  /* Assume systems with more busses have correct MCFG */
>  #define mmcfg_virt_addr ((void __iomem *) fix_to_virt(FIX_PCIE_MCFG))
> diff --git a/arch/x86/platform/olpc/olpc-xo15-sci.c b/arch/x86/platform/olpc/olpc-xo15-sci.c
> index 649a12b..08e350e 100644
> --- a/arch/x86/platform/olpc/olpc-xo15-sci.c
> +++ b/arch/x86/platform/olpc/olpc-xo15-sci.c
> @@ -15,8 +15,7 @@
>  #include <linux/power_supply.h>
>  #include <linux/olpc-ec.h>
> 
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
>  #include <asm/olpc.h>
> 
>  #define DRV_NAME			"olpc-xo15-sci"
> diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
> index 8711e37..8095943 100644
> --- a/drivers/acpi/ac.c
> +++ b/drivers/acpi/ac.c
> @@ -32,8 +32,7 @@
>  #include <linux/delay.h>
>  #include <linux/platform_device.h>
>  #include <linux/power_supply.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
> 
>  #define PREFIX "ACPI: "
> 
> diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
> index a6869e1..2635a01 100644
> --- a/drivers/acpi/acpi_extlog.c
> +++ b/drivers/acpi/acpi_extlog.c
> @@ -9,7 +9,6 @@
> 
>  #include <linux/module.h>
>  #include <linux/acpi.h>
> -#include <acpi/acpi_bus.h>
>  #include <linux/cper.h>
>  #include <linux/ratelimit.h>
>  #include <asm/cpu.h>
> diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
> index fc6008f..65610c0 100644
> --- a/drivers/acpi/acpi_pad.c
> +++ b/drivers/acpi/acpi_pad.c
> @@ -28,8 +28,7 @@
>  #include <linux/cpu.h>
>  #include <linux/clockchips.h>
>  #include <linux/slab.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
>  #include <asm/mwait.h>
> 
>  #define ACPI_PROCESSOR_AGGREGATOR_CLASS	"acpi_pad"
> diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
> index fb57d03..ca0c6d7 100644
> --- a/drivers/acpi/apei/einj.c
> +++ b/drivers/acpi/apei/einj.c
> @@ -33,7 +33,6 @@
>  #include <linux/nmi.h>
>  #include <linux/delay.h>
>  #include <linux/mm.h>
> -#include <acpi/acpi.h>
> 
>  #include "apei-internal.h"
> 
> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> index fbf1ace..e90ef8b 100644
> --- a/drivers/acpi/battery.c
> +++ b/drivers/acpi/battery.c
> @@ -36,8 +36,7 @@
>  #include <linux/suspend.h>
>  #include <asm/unaligned.h>
> 
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
>  #include <linux/power_supply.h>
> 
>  #define PREFIX "ACPI: "
> diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
> index 078c4f7..05ee8f6 100644
> --- a/drivers/acpi/blacklist.c
> +++ b/drivers/acpi/blacklist.c
> @@ -30,7 +30,6 @@
>  #include <linux/kernel.h>
>  #include <linux/init.h>
>  #include <linux/acpi.h>
> -#include <acpi/acpi_bus.h>
>  #include <linux/dmi.h>
> 
>  #include "internal.h"
> diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> index f509019..2c38ae2 100644
> --- a/drivers/acpi/bus.c
> +++ b/drivers/acpi/bus.c
> @@ -37,8 +37,6 @@
>  #include <asm/mpspec.h>
>  #endif
>  #include <linux/pci.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
>  #include <acpi/apei.h>
>  #include <linux/dmi.h>
>  #include <linux/suspend.h>
> diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
> index c971929..9e3a6cb 100644
> --- a/drivers/acpi/button.c
> +++ b/drivers/acpi/button.c
> @@ -31,8 +31,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/input.h>
>  #include <linux/slab.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
>  #include <acpi/button.h>
> 
>  #define PREFIX "ACPI: "
> diff --git a/drivers/acpi/custom_method.c b/drivers/acpi/custom_method.c
> index 12b62f2..c68e724 100644
> --- a/drivers/acpi/custom_method.c
> +++ b/drivers/acpi/custom_method.c
> @@ -7,7 +7,7 @@
>  #include <linux/kernel.h>
>  #include <linux/uaccess.h>
>  #include <linux/debugfs.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
> 
>  #include "internal.h"
> 
> diff --git a/drivers/acpi/debugfs.c b/drivers/acpi/debugfs.c
> index b55d6a2..6b1919f 100644
> --- a/drivers/acpi/debugfs.c
> +++ b/drivers/acpi/debugfs.c
> @@ -5,7 +5,7 @@
>  #include <linux/export.h>
>  #include <linux/init.h>
>  #include <linux/debugfs.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
> 
>  #define _COMPONENT		ACPI_SYSTEM_COMPONENT
>  ACPI_MODULE_NAME("debugfs");
> diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
> index de03201..8da6be9 100644
> --- a/drivers/acpi/dock.c
> +++ b/drivers/acpi/dock.c
> @@ -32,8 +32,6 @@
>  #include <linux/jiffies.h>
>  #include <linux/stddef.h>
>  #include <linux/acpi.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> 
>  #define PREFIX "ACPI: "
> 
> diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
> index ba5b56d..ff40120 100644
> --- a/drivers/acpi/ec.c
> +++ b/drivers/acpi/ec.c
> @@ -39,10 +39,9 @@
>  #include <linux/list.h>
>  #include <linux/spinlock.h>
>  #include <linux/slab.h>
> -#include <asm/io.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
>  #include <linux/dmi.h>
> +#include <asm/io.h>
> 
>  #include "internal.h"
> 
> diff --git a/drivers/acpi/event.c b/drivers/acpi/event.c
> index cae3b38..ef2d730 100644
> --- a/drivers/acpi/event.c
> +++ b/drivers/acpi/event.c
> @@ -12,7 +12,7 @@
>  #include <linux/init.h>
>  #include <linux/poll.h>
>  #include <linux/gfp.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
>  #include <net/netlink.h>
>  #include <net/genetlink.h>
> 
> diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
> index ba3da88..1fb6290 100644
> --- a/drivers/acpi/fan.c
> +++ b/drivers/acpi/fan.c
> @@ -29,8 +29,7 @@
>  #include <linux/types.h>
>  #include <asm/uaccess.h>
>  #include <linux/thermal.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
> 
>  #define PREFIX "ACPI: "
> 
> diff --git a/drivers/acpi/hed.c b/drivers/acpi/hed.c
> index 13b1d39..aafe3ca 100644
> --- a/drivers/acpi/hed.c
> +++ b/drivers/acpi/hed.c
> @@ -25,8 +25,6 @@
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/acpi.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
>  #include <acpi/hed.h>
> 
>  static struct acpi_device_id acpi_hed_ids[] = {
> diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
> index a2343a1..9e6816e 100644
> --- a/drivers/acpi/numa.c
> +++ b/drivers/acpi/numa.c
> @@ -29,7 +29,6 @@
>  #include <linux/errno.h>
>  #include <linux/acpi.h>
>  #include <linux/numa.h>
> -#include <acpi/acpi_bus.h>
> 
>  #define PREFIX "ACPI: "
> 
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 5b9a785..7e2d814 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -49,9 +49,6 @@
>  #include <asm/io.h>
>  #include <asm/uaccess.h>
> 
> -#include <acpi/acpi.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/processor.h>
>  #include "internal.h"
> 
>  #define _COMPONENT		ACPI_OS_SERVICES
> diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
> index 41c5e1b..52d45ea 100644
> --- a/drivers/acpi/pci_irq.c
> +++ b/drivers/acpi/pci_irq.c
> @@ -37,8 +37,6 @@
>  #include <linux/pci.h>
>  #include <linux/acpi.h>
>  #include <linux/slab.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> 
>  #define PREFIX "ACPI: "
> 
> diff --git a/drivers/acpi/pci_link.c b/drivers/acpi/pci_link.c
> index 2652a61..ea6b8d1 100644
> --- a/drivers/acpi/pci_link.c
> +++ b/drivers/acpi/pci_link.c
> @@ -39,9 +39,7 @@
>  #include <linux/pci.h>
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
> -
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
> 
>  #define PREFIX "ACPI: "
> 
> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
> index 2dd11e0..afafee5 100644
> --- a/drivers/acpi/pci_root.c
> +++ b/drivers/acpi/pci_root.c
> @@ -35,9 +35,7 @@
>  #include <linux/pci-aspm.h>
>  #include <linux/acpi.h>
>  #include <linux/slab.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> -#include <acpi/apei.h>
> +#include <acpi/apei.h>	/* for acpi_hest_init() */
> 
>  #include "internal.h"
> 
> diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
> index c2ad391..ad7da68 100644
> --- a/drivers/acpi/power.c
> +++ b/drivers/acpi/power.c
> @@ -42,8 +42,7 @@
>  #include <linux/slab.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/sysfs.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
>  #include "sleep.h"
>  #include "internal.h"
> 
> diff --git a/drivers/acpi/proc.c b/drivers/acpi/proc.c
> index 6a5b152..db061bf 100644
> --- a/drivers/acpi/proc.c
> +++ b/drivers/acpi/proc.c
> @@ -3,11 +3,9 @@
>  #include <linux/export.h>
>  #include <linux/suspend.h>
>  #include <linux/bcd.h>
> +#include <linux/acpi.h>
>  #include <asm/uaccess.h>
> 
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> -
>  #include "sleep.h"
> 
>  #define _COMPONENT		ACPI_SYSTEM_COMPONENT
> diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
> index b3171f3..34e7b3c 100644
> --- a/drivers/acpi/processor_core.c
> +++ b/drivers/acpi/processor_core.c
> @@ -10,8 +10,7 @@
>  #include <linux/export.h>
>  #include <linux/dmi.h>
>  #include <linux/slab.h>
> -
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
>  #include <acpi/processor.h>
> 
>  #include "internal.h"
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index 644516d..d2d44e0 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -35,6 +35,7 @@
>  #include <linux/clockchips.h>
>  #include <linux/cpuidle.h>
>  #include <linux/syscore_ops.h>
> +#include <acpi/processor.h>
> 
>  /*
>   * Include the apic definitions for x86 to have the APIC timer related defines
> @@ -46,9 +47,6 @@
>  #include <asm/apic.h>
>  #endif
> 
> -#include <acpi/acpi_bus.h>
> -#include <acpi/processor.h>
> -
>  #define PREFIX "ACPI: "
> 
>  #define ACPI_PROCESSOR_CLASS            "processor"
> diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
> index 60a7c28..ff90054 100644
> --- a/drivers/acpi/processor_perflib.c
> +++ b/drivers/acpi/processor_perflib.c
> @@ -31,15 +31,12 @@
>  #include <linux/init.h>
>  #include <linux/cpufreq.h>
>  #include <linux/slab.h>
> -
> +#include <linux/acpi.h>
> +#include <acpi/processor.h>
>  #ifdef CONFIG_X86
>  #include <asm/cpufeature.h>
>  #endif
> 
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> -#include <acpi/processor.h>
> -
>  #define PREFIX "ACPI: "
> 
>  #define ACPI_PROCESSOR_CLASS		"processor"
> diff --git a/drivers/acpi/processor_thermal.c b/drivers/acpi/processor_thermal.c
> index d1d2e7f..f95e758 100644
> --- a/drivers/acpi/processor_thermal.c
> +++ b/drivers/acpi/processor_thermal.c
> @@ -30,12 +30,9 @@
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/cpufreq.h>
> -
> -#include <asm/uaccess.h>
> -
> -#include <acpi/acpi_bus.h>
> +#include <linux/acpi.h>
>  #include <acpi/processor.h>
> -#include <acpi/acpi_drivers.h>
> +#include <asm/uaccess.h>
> 
>  #define PREFIX "ACPI: "
> 
> diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
> index e7dd2c1..28baa05 100644
> --- a/drivers/acpi/processor_throttling.c
> +++ b/drivers/acpi/processor_throttling.c
> @@ -32,14 +32,11 @@
>  #include <linux/init.h>
>  #include <linux/sched.h>
>  #include <linux/cpufreq.h>
> -
> +#include <linux/acpi.h>
> +#include <acpi/processor.h>
>  #include <asm/io.h>
>  #include <asm/uaccess.h>
> 
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> -#include <acpi/processor.h>
> -
>  #define PREFIX "ACPI: "
> 
>  #define ACPI_PROCESSOR_CLASS            "processor"
> diff --git a/drivers/acpi/sbshc.c b/drivers/acpi/sbshc.c
> index b78bc60..26e5b50 100644
> --- a/drivers/acpi/sbshc.c
> +++ b/drivers/acpi/sbshc.c
> @@ -8,8 +8,7 @@
>   * the Free Software Foundation version 2.
>   */
> 
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
>  #include <linux/wait.h>
>  #include <linux/slab.h>
>  #include <linux/delay.h>
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 311904c..d564367 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -11,8 +11,6 @@
>  #include <linux/kthread.h>
>  #include <linux/dmi.h>
>  #include <linux/nls.h>
> -
> -#include <acpi/acpi_drivers.h>
> 
>  #include "internal.h"
> 
> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> index 721e949..208ac8c 100644
> --- a/drivers/acpi/sleep.c
> +++ b/drivers/acpi/sleep.c
> @@ -18,12 +18,8 @@
>  #include <linux/reboot.h>
>  #include <linux/acpi.h>
>  #include <linux/module.h>
> -
>  #include <asm/io.h>
> 
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> -
>  #include "internal.h"
>  #include "sleep.h"
> 
> diff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c
> index 6dbc3ca..443dc93 100644
> --- a/drivers/acpi/sysfs.c
> +++ b/drivers/acpi/sysfs.c
> @@ -5,7 +5,7 @@
>  #include <linux/init.h>
>  #include <linux/kernel.h>
>  #include <linux/moduleparam.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
> 
>  #include "internal.h"
> 
> diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
> index 0d9f46b..1fd21ad 100644
> --- a/drivers/acpi/thermal.c
> +++ b/drivers/acpi/thermal.c
> @@ -41,10 +41,9 @@
>  #include <linux/kmod.h>
>  #include <linux/reboot.h>
>  #include <linux/device.h>
> -#include <asm/uaccess.h>
>  #include <linux/thermal.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
> +#include <asm/uaccess.h>
> 
>  #define PREFIX "ACPI: "
> 
> diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
> index 6d408bf..1336b91 100644
> --- a/drivers/acpi/utils.c
> +++ b/drivers/acpi/utils.c
> @@ -30,8 +30,6 @@
>  #include <linux/types.h>
>  #include <linux/hardirq.h>
>  #include <linux/acpi.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> 
>  #include "internal.h"
> 
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index 995e91b..b727d10 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -37,12 +37,11 @@
>  #include <linux/pci.h>
>  #include <linux/pci_ids.h>
>  #include <linux/slab.h>
> -#include <asm/uaccess.h>
>  #include <linux/dmi.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
>  #include <linux/suspend.h>
> +#include <linux/acpi.h>
>  #include <acpi/video.h>
> +#include <asm/uaccess.h>
> 
>  #include "internal.h"
> 
> diff --git a/drivers/acpi/wakeup.c b/drivers/acpi/wakeup.c
> index 7bfbe40..1638401 100644
> --- a/drivers/acpi/wakeup.c
> +++ b/drivers/acpi/wakeup.c
> @@ -5,7 +5,6 @@
> 
>  #include <linux/init.h>
>  #include <linux/acpi.h>
> -#include <acpi/acpi_drivers.h>
>  #include <linux/kernel.h>
>  #include <linux/types.h>
> 
> diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> index 4372cfa..8e22d97 100644
> --- a/drivers/ata/libata-acpi.c
> +++ b/drivers/ata/libata-acpi.c
> @@ -20,8 +20,6 @@
>  #include <scsi/scsi_device.h>
>  #include "libata.h"
> 
> -#include <acpi/acpi_bus.h>
> -
>  unsigned int ata_acpi_gtf_filter = ATA_ACPI_FILTER_DEFAULT;
>  module_param_named(acpi_gtf_filter, ata_acpi_gtf_filter, int, 0644);
>  MODULE_PARM_DESC(acpi_gtf_filter, "filter mask for ACPI _GTF commands, set to filter out (0x1=set xfermode, 0x2=lock/freeze
> lock, 0x4=DIPM, 0x8=FPDMA non-zero offset, 0x10=FPDMA DMA Setup FIS auto-activate)");
> diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
> index 73212c9..62c9ac8 100644
> --- a/drivers/ata/pata_acpi.c
> +++ b/drivers/ata/pata_acpi.c
> @@ -12,11 +12,10 @@
>  #include <linux/delay.h>
>  #include <linux/device.h>
>  #include <linux/gfp.h>
> -#include <scsi/scsi_host.h>
> -#include <acpi/acpi_bus.h>
> -
> +#include <linux/acpi.h>
>  #include <linux/libata.h>
>  #include <linux/ata.h>
> +#include <scsi/scsi_host.h>
> 
>  #define DRV_NAME	"pata_acpi"
>  #define DRV_VERSION	"0.2.3"
> diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
> index 5d9c31d..d5d4cd8 100644
> --- a/drivers/char/hpet.c
> +++ b/drivers/char/hpet.c
> @@ -34,15 +34,12 @@
>  #include <linux/uaccess.h>
>  #include <linux/slab.h>
>  #include <linux/io.h>
> -
> +#include <linux/acpi.h>
> +#include <linux/hpet.h>
>  #include <asm/current.h>
>  #include <asm/irq.h>
>  #include <asm/div64.h>
> 
> -#include <linux/acpi.h>
> -#include <acpi/acpi_bus.h>
> -#include <linux/hpet.h>
> -
>  /*
>   * The High Precision Event Timer driver.
>   * This driver is closely modelled after the rtc.c driver.
> diff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
> index 64420b3..b9a57fa 100644
> --- a/drivers/char/tpm/tpm_acpi.c
> +++ b/drivers/char/tpm/tpm_acpi.c
> @@ -23,7 +23,7 @@
>  #include <linux/security.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
> -#include <acpi/acpi.h>
> +#include <linux/acpi.h>
> 
>  #include "tpm.h"
>  #include "tpm_eventlog.h"
> diff --git a/drivers/char/tpm/tpm_ppi.c b/drivers/char/tpm/tpm_ppi.c
> index 8e562dc..dd60ef3 100644
> --- a/drivers/char/tpm/tpm_ppi.c
> +++ b/drivers/char/tpm/tpm_ppi.c
> @@ -1,5 +1,4 @@
>  #include <linux/acpi.h>
> -#include <acpi/acpi_drivers.h>
>  #include "tpm.h"
> 
>  static const u8 tpm_ppi_uuid[] = {
> diff --git a/drivers/gpu/drm/i915/intel_acpi.c b/drivers/gpu/drm/i915/intel_acpi.c
> index dfff090..5325b25 100644
> --- a/drivers/gpu/drm/i915/intel_acpi.c
> +++ b/drivers/gpu/drm/i915/intel_acpi.c
> @@ -6,8 +6,6 @@
>  #include <linux/pci.h>
>  #include <linux/acpi.h>
>  #include <linux/vga_switcheroo.h>
> -#include <acpi/acpi_drivers.h>
> -
>  #include <drm/drmP.h>
>  #include "i915_drv.h"
> 
> diff --git a/drivers/gpu/drm/nouveau/nouveau_acpi.c b/drivers/gpu/drm/nouveau/nouveau_acpi.c
> index 95c7404..1f0b6d2 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_acpi.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_acpi.c
> @@ -1,15 +1,10 @@
>  #include <linux/pci.h>
>  #include <linux/acpi.h>
>  #include <linux/slab.h>
> -#include <acpi/acpi_drivers.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/video.h>
> -#include <acpi/acpi.h>
>  #include <linux/mxm-wmi.h>
> -
>  #include <linux/vga_switcheroo.h>
> -
>  #include <drm/drm_edid.h>
> +#include <acpi/video.h>
> 
>  #include "nouveau_drm.h"
>  #include "nouveau_acpi.h"
> diff --git a/drivers/gpu/drm/radeon/radeon_acpi.c b/drivers/gpu/drm/radeon/radeon_acpi.c
> index 98a9074..77e9d07 100644
> --- a/drivers/gpu/drm/radeon/radeon_acpi.c
> +++ b/drivers/gpu/drm/radeon/radeon_acpi.c
> @@ -25,18 +25,14 @@
>  #include <linux/acpi.h>
>  #include <linux/slab.h>
>  #include <linux/power_supply.h>
> -#include <acpi/acpi_drivers.h>
> -#include <acpi/acpi_bus.h>
> +#include <linux/vga_switcheroo.h>
>  #include <acpi/video.h>
> -
>  #include <drm/drmP.h>
>  #include <drm/drm_crtc_helper.h>
>  #include "radeon.h"
>  #include "radeon_acpi.h"
>  #include "atom.h"
> 
> -#include <linux/vga_switcheroo.h>
> -
>  #define ACPI_AC_CLASS           "ac_adapter"
> 
>  extern void radeon_pm_acpi_event_handler(struct radeon_device *rdev);
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> index 48aad4f..077bb1b 100644
> --- a/drivers/hv/vmbus_drv.c
> +++ b/drivers/hv/vmbus_drv.c
> @@ -30,7 +30,6 @@
>  #include <linux/sysctl.h>
>  #include <linux/slab.h>
>  #include <linux/acpi.h>
> -#include <acpi/acpi_bus.h>
>  #include <linux/completion.h>
>  #include <linux/hyperv.h>
>  #include <linux/kernel_stat.h>
> @@ -39,7 +38,6 @@
>  #include <asm/mshyperv.h>
>  #include "hyperv_vmbus.h"
> 
> -
>  static struct acpi_device  *hv_acpi_dev;
> 
>  static struct tasklet_struct msg_dpc;
> diff --git a/drivers/hwmon/acpi_power_meter.c b/drivers/hwmon/acpi_power_meter.c
> index 6a34f7f..579bdf9 100644
> --- a/drivers/hwmon/acpi_power_meter.c
> +++ b/drivers/hwmon/acpi_power_meter.c
> @@ -30,8 +30,7 @@
>  #include <linux/sched.h>
>  #include <linux/time.h>
>  #include <linux/err.h>
> -#include <acpi/acpi_drivers.h>
> -#include <acpi/acpi_bus.h>
> +#include <linux/acpi.h>
> 
>  #define ACPI_POWER_METER_NAME		"power_meter"
>  ACPI_MODULE_NAME(ACPI_POWER_METER_NAME);
> diff --git a/drivers/hwmon/asus_atk0110.c b/drivers/hwmon/asus_atk0110.c
> index dafc63c..ae208f6 100644
> --- a/drivers/hwmon/asus_atk0110.c
> +++ b/drivers/hwmon/asus_atk0110.c
> @@ -16,12 +16,7 @@
>  #include <linux/dmi.h>
>  #include <linux/jiffies.h>
>  #include <linux/err.h>
> -
> -#include <acpi/acpi.h>
> -#include <acpi/acpixf.h>
> -#include <acpi/acpi_drivers.h>
> -#include <acpi/acpi_bus.h>
> -
> +#include <linux/acpi.h>
> 
>  #define ATK_HID "ATK0110"
> 
> diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
> index d9e1f7c..333d405 100644
> --- a/drivers/ide/ide-acpi.c
> +++ b/drivers/ide/ide-acpi.c
> @@ -14,7 +14,6 @@
>  #include <linux/errno.h>
>  #include <linux/kernel.h>
>  #include <linux/slab.h>
> -#include <acpi/acpi.h>
>  #include <linux/ide.h>
>  #include <linux/pci.h>
>  #include <linux/dmi.h>
> diff --git a/drivers/input/misc/atlas_btns.c b/drivers/input/misc/atlas_btns.c
> index 5d44023..d781b5e 100644
> --- a/drivers/input/misc/atlas_btns.c
> +++ b/drivers/input/misc/atlas_btns.c
> @@ -28,8 +28,8 @@
>  #include <linux/init.h>
>  #include <linux/input.h>
>  #include <linux/types.h>
> +#include <linux/acpi.h>
>  #include <asm/uaccess.h>
> -#include <acpi/acpi_drivers.h>
> 
>  #define ACPI_ATLAS_NAME		"Atlas ACPI"
>  #define ACPI_ATLAS_CLASS	"Atlas"
> diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
> index 8f798be..28b4bea 100644
> --- a/drivers/iommu/amd_iommu_init.c
> +++ b/drivers/iommu/amd_iommu_init.c
> @@ -26,7 +26,6 @@
>  #include <linux/msi.h>
>  #include <linux/amd-iommu.h>
>  #include <linux/export.h>
> -#include <acpi/acpi.h>
>  #include <asm/pci-direct.h>
>  #include <asm/iommu.h>
>  #include <asm/gart.h>
> diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
> index bab10b1..0cb7528 100644
> --- a/drivers/iommu/intel_irq_remapping.c
> +++ b/drivers/iommu/intel_irq_remapping.c
> @@ -6,11 +6,11 @@
>  #include <linux/hpet.h>
>  #include <linux/pci.h>
>  #include <linux/irq.h>
> +#include <linux/intel-iommu.h>
> +#include <linux/acpi.h>
>  #include <asm/io_apic.h>
>  #include <asm/smp.h>
>  #include <asm/cpu.h>
> -#include <linux/intel-iommu.h>
> -#include <acpi/acpi.h>
>  #include <asm/irq_remapping.h>
>  #include <asm/pci-direct.h>
>  #include <asm/msidef.h>
> diff --git a/drivers/pci/hotplug/acpiphp_ibm.c b/drivers/pci/hotplug/acpiphp_ibm.c
> index ecfac7e..8dcccff 100644
> --- a/drivers/pci/hotplug/acpiphp_ibm.c
> +++ b/drivers/pci/hotplug/acpiphp_ibm.c
> @@ -31,12 +31,11 @@
>  #include <linux/slab.h>
>  #include <linux/module.h>
>  #include <linux/kernel.h>
> -#include <acpi/acpi_bus.h>
>  #include <linux/sysfs.h>
>  #include <linux/kobject.h>
> -#include <asm/uaccess.h>
>  #include <linux/moduleparam.h>
>  #include <linux/pci.h>
> +#include <asm/uaccess.h>
> 
>  #include "acpiphp.h"
>  #include "../pci.h"
> diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
> index 21e865d..24e147c 100644
> --- a/drivers/pci/hotplug/pciehp.h
> +++ b/drivers/pci/hotplug/pciehp.h
> @@ -163,8 +163,6 @@ static inline const char *slot_name(struct slot *slot)
>  }
> 
>  #ifdef CONFIG_ACPI
> -#include <acpi/acpi.h>
> -#include <acpi/acpi_bus.h>
>  #include <linux/pci-acpi.h>
> 
>  void __init pciehp_acpi_slot_detection_init(void);
> diff --git a/drivers/pci/ioapic.c b/drivers/pci/ioapic.c
> index 50ce680..2122b2b 100644
> --- a/drivers/pci/ioapic.c
> +++ b/drivers/pci/ioapic.c
> @@ -20,7 +20,6 @@
>  #include <linux/module.h>
>  #include <linux/acpi.h>
>  #include <linux/slab.h>
> -#include <acpi/acpi_bus.h>
> 
>  struct ioapic {
>  	acpi_handle	handle;
> diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
> index 577074e..43e3179 100644
> --- a/drivers/pci/pci-acpi.c
> +++ b/drivers/pci/pci-acpi.c
> @@ -12,9 +12,6 @@
>  #include <linux/pci.h>
>  #include <linux/module.h>
>  #include <linux/pci-aspm.h>
> -#include <acpi/acpi.h>
> -#include <acpi/acpi_bus.h>
> -
>  #include <linux/pci-acpi.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/pm_qos.h>
> diff --git a/drivers/pci/pci-label.c b/drivers/pci/pci-label.c
> index d51f45a..dbafcc8 100644
> --- a/drivers/pci/pci-label.c
> +++ b/drivers/pci/pci-label.c
> @@ -29,7 +29,6 @@
>  #include <linux/nls.h>
>  #include <linux/acpi.h>
>  #include <linux/pci-acpi.h>
> -#include <acpi/acpi_bus.h>
>  #include "pci.h"
> 
>  #define	DEVICE_LABEL_DSM	0x07
> diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
> index c9076bd..c91f69b3 100644
> --- a/drivers/platform/x86/acer-wmi.c
> +++ b/drivers/platform/x86/acer-wmi.c
> @@ -41,8 +41,6 @@
>  #include <linux/slab.h>
>  #include <linux/input.h>
>  #include <linux/input/sparse-keymap.h>
> -
> -#include <acpi/acpi_drivers.h>
>  #include <acpi/video.h>
> 
>  MODULE_AUTHOR("Carlos Corbacho");
> diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
> index 0e9c169..430b5c3 100644
> --- a/drivers/platform/x86/asus-laptop.c
> +++ b/drivers/platform/x86/asus-laptop.c
> @@ -53,8 +53,7 @@
>  #include <linux/rfkill.h>
>  #include <linux/slab.h>
>  #include <linux/dmi.h>
> -#include <acpi/acpi_drivers.h>
> -#include <acpi/acpi_bus.h>
> +#include <linux/acpi.h>
> 
>  #define ASUS_LAPTOP_VERSION	"0.42"
> 
> diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
> index 19c313b..df7ecb9 100644
> --- a/drivers/platform/x86/asus-wmi.c
> +++ b/drivers/platform/x86/asus-wmi.c
> @@ -45,8 +45,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/platform_device.h>
>  #include <linux/thermal.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
>  #include <acpi/video.h>
> 
>  #include "asus-wmi.h"
> diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platform/x86/classmate-laptop.c
> index 6dfa8d3..70d355a 100644
> --- a/drivers/platform/x86/classmate-laptop.c
> +++ b/drivers/platform/x86/classmate-laptop.c
> @@ -21,14 +21,13 @@
>  #include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/workqueue.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
>  #include <linux/backlight.h>
>  #include <linux/input.h>
>  #include <linux/rfkill.h>
> 
>  MODULE_LICENSE("GPL");
> 
> -
>  struct cmpc_accel {
>  	int sensitivity;
>  	int g_select;
> diff --git a/drivers/platform/x86/dell-wmi-aio.c b/drivers/platform/x86/dell-wmi-aio.c
> index bcf8cc6..dbc97a3 100644
> --- a/drivers/platform/x86/dell-wmi-aio.c
> +++ b/drivers/platform/x86/dell-wmi-aio.c
> @@ -24,7 +24,6 @@
>  #include <linux/types.h>
>  #include <linux/input.h>
>  #include <linux/input/sparse-keymap.h>
> -#include <acpi/acpi_drivers.h>
>  #include <linux/acpi.h>
>  #include <linux/string.h>
> 
> diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
> index fa9a217..bdf483b 100644
> --- a/drivers/platform/x86/dell-wmi.c
> +++ b/drivers/platform/x86/dell-wmi.c
> @@ -32,7 +32,6 @@
>  #include <linux/types.h>
>  #include <linux/input.h>
>  #include <linux/input/sparse-keymap.h>
> -#include <acpi/acpi_drivers.h>
>  #include <linux/acpi.h>
>  #include <linux/string.h>
>  #include <linux/dmi.h>
> diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
> index aefcc32..cabd567 100644
> --- a/drivers/platform/x86/eeepc-laptop.c
> +++ b/drivers/platform/x86/eeepc-laptop.c
> @@ -28,8 +28,7 @@
>  #include <linux/hwmon.h>
>  #include <linux/hwmon-sysfs.h>
>  #include <linux/slab.h>
> -#include <acpi/acpi_drivers.h>
> -#include <acpi/acpi_bus.h>
> +#include <linux/acpi.h>
>  #include <linux/uaccess.h>
>  #include <linux/input.h>
>  #include <linux/input/sparse-keymap.h>
> diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
> index af67e6e..6112933 100644
> --- a/drivers/platform/x86/eeepc-wmi.c
> +++ b/drivers/platform/x86/eeepc-wmi.c
> @@ -33,7 +33,7 @@
>  #include <linux/input/sparse-keymap.h>
>  #include <linux/dmi.h>
>  #include <linux/fb.h>
> -#include <acpi/acpi_bus.h>
> +#include <linux/acpi.h>
> 
>  #include "asus-wmi.h"
> 
> diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp_accel.c
> index a8e43cf..aff4d06 100644
> --- a/drivers/platform/x86/hp_accel.c
> +++ b/drivers/platform/x86/hp_accel.c
> @@ -36,7 +36,7 @@
>  #include <linux/uaccess.h>
>  #include <linux/leds.h>
>  #include <linux/atomic.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
>  #include "../../misc/lis3lv02d/lis3lv02d.h"
> 
>  #define DRIVER_NAME     "hp_accel"
> diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
> index 6788acc..70b5729 100644
> --- a/drivers/platform/x86/ideapad-laptop.c
> +++ b/drivers/platform/x86/ideapad-laptop.c
> @@ -26,8 +26,7 @@
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/types.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
>  #include <linux/rfkill.h>
>  #include <linux/platform_device.h>
>  #include <linux/input.h>
> diff --git a/drivers/platform/x86/intel-rst.c b/drivers/platform/x86/intel-rst.c
> index a2083a9..d45bca3 100644
> --- a/drivers/platform/x86/intel-rst.c
> +++ b/drivers/platform/x86/intel-rst.c
> @@ -20,7 +20,7 @@
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
> 
>  MODULE_LICENSE("GPL");
> 
> diff --git a/drivers/platform/x86/intel-smartconnect.c b/drivers/platform/x86/intel-smartconnect.c
> index 1838400..04cf5df 100644
> --- a/drivers/platform/x86/intel-smartconnect.c
> +++ b/drivers/platform/x86/intel-smartconnect.c
> @@ -19,7 +19,7 @@
> 
>  #include <linux/init.h>
>  #include <linux/module.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
> 
>  MODULE_LICENSE("GPL");
> 
> diff --git a/drivers/platform/x86/intel_menlow.c b/drivers/platform/x86/intel_menlow.c
> index 11244f8..e8b46d2 100644
> --- a/drivers/platform/x86/intel_menlow.c
> +++ b/drivers/platform/x86/intel_menlow.c
> @@ -36,10 +36,8 @@
>  #include <linux/types.h>
>  #include <linux/pci.h>
>  #include <linux/pm.h>
> -
>  #include <linux/thermal.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
> 
>  MODULE_AUTHOR("Thomas Sujith");
>  MODULE_AUTHOR("Zhang Rui");
> diff --git a/drivers/platform/x86/intel_oaktrail.c b/drivers/platform/x86/intel_oaktrail.c
> index f6f18cd..4bc9604 100644
> --- a/drivers/platform/x86/intel_oaktrail.c
> +++ b/drivers/platform/x86/intel_oaktrail.c
> @@ -50,9 +50,6 @@
>  #include <linux/platform_device.h>
>  #include <linux/dmi.h>
>  #include <linux/rfkill.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> -
> 
>  #define DRIVER_NAME	"intel_oaktrail"
>  #define DRIVER_VERSION	"0.4ac1"
> diff --git a/drivers/platform/x86/mxm-wmi.c b/drivers/platform/x86/mxm-wmi.c
> index 0aea63b..3c59c0a 100644
> --- a/drivers/platform/x86/mxm-wmi.c
> +++ b/drivers/platform/x86/mxm-wmi.c
> @@ -20,8 +20,7 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
> 
>  MODULE_AUTHOR("Dave Airlie");
>  MODULE_DESCRIPTION("MXM WMI Driver");
> diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
> index 10d12b2..137d602 100644
> --- a/drivers/platform/x86/panasonic-laptop.c
> +++ b/drivers/platform/x86/panasonic-laptop.c
> @@ -125,12 +125,10 @@
>  #include <linux/seq_file.h>
>  #include <linux/uaccess.h>
>  #include <linux/slab.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
>  #include <linux/input.h>
>  #include <linux/input/sparse-keymap.h>
> 
> -
>  #ifndef ACPI_HOTKEY_COMPONENT
>  #define ACPI_HOTKEY_COMPONENT	0x10000000
>  #endif
> diff --git a/drivers/platform/x86/pvpanic.c b/drivers/platform/x86/pvpanic.c
> index 47ae0c4..c9f6e51 100644
> --- a/drivers/platform/x86/pvpanic.c
> +++ b/drivers/platform/x86/pvpanic.c
> @@ -24,8 +24,7 @@
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/types.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
> 
>  MODULE_AUTHOR("Hu Tao <hutao@cn.fujitsu.com>");
>  MODULE_DESCRIPTION("pvpanic device driver");
> diff --git a/drivers/platform/x86/samsung-q10.c b/drivers/platform/x86/samsung-q10.c
> index cae7098..5413f62 100644
> --- a/drivers/platform/x86/samsung-q10.c
> +++ b/drivers/platform/x86/samsung-q10.c
> @@ -15,7 +15,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/backlight.h>
>  #include <linux/dmi.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
> 
>  #define SAMSUNGQ10_BL_MAX_INTENSITY 7
> 
> diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
> index 47caab0..1d00039 100644
> --- a/drivers/platform/x86/sony-laptop.c
> +++ b/drivers/platform/x86/sony-laptop.c
> @@ -61,9 +61,6 @@
>  #include <linux/workqueue.h>
>  #include <linux/acpi.h>
>  #include <linux/slab.h>
> -#include <acpi/acpi_drivers.h>
> -#include <acpi/acpi_bus.h>
> -#include <asm/uaccess.h>
>  #include <linux/sonypi.h>
>  #include <linux/sony-laptop.h>
>  #include <linux/rfkill.h>
> @@ -71,6 +68,7 @@
>  #include <linux/poll.h>
>  #include <linux/miscdevice.h>
>  #endif
> +#include <asm/uaccess.h>
> 
>  #define dprintk(fmt, ...)			\
>  do {						\
> diff --git a/drivers/platform/x86/tc1100-wmi.c b/drivers/platform/x86/tc1100-wmi.c
> index 9b93fdb..6a6ea28 100644
> --- a/drivers/platform/x86/tc1100-wmi.c
> +++ b/drivers/platform/x86/tc1100-wmi.c
> @@ -32,9 +32,7 @@
>  #include <linux/slab.h>
>  #include <linux/init.h>
>  #include <linux/types.h>
> -#include <acpi/acpi.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
>  #include <linux/platform_device.h>
> 
>  #define GUID "C364AC71-36DB-495A-8494-B439D472A505"
> diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
> index 05e046a..9d7e34b 100644
> --- a/drivers/platform/x86/thinkpad_acpi.c
> +++ b/drivers/platform/x86/thinkpad_acpi.c
> @@ -61,7 +61,6 @@
>  #include <linux/freezer.h>
>  #include <linux/delay.h>
>  #include <linux/slab.h>
> -
>  #include <linux/nvram.h>
>  #include <linux/proc_fs.h>
>  #include <linux/seq_file.h>
> @@ -74,21 +73,16 @@
>  #include <linux/input.h>
>  #include <linux/leds.h>
>  #include <linux/rfkill.h>
> -#include <asm/uaccess.h>
> -
>  #include <linux/dmi.h>
>  #include <linux/jiffies.h>
>  #include <linux/workqueue.h>
> -
> +#include <linux/acpi.h>
> +#include <linux/pci_ids.h>
> +#include <linux/thinkpad_acpi.h>
>  #include <sound/core.h>
>  #include <sound/control.h>
>  #include <sound/initval.h>
> -
> -#include <acpi/acpi_drivers.h>
> -
> -#include <linux/pci_ids.h>
> -
> -#include <linux/thinkpad_acpi.h>
> +#include <asm/uaccess.h>
> 
>  /* ThinkPad CMOS commands */
>  #define TP_CMOS_VOLUME_DOWN	0
> diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
> index 0cfadb6..b5f17eb 100644
> --- a/drivers/platform/x86/toshiba_acpi.c
> +++ b/drivers/platform/x86/toshiba_acpi.c
> @@ -54,11 +54,9 @@
>  #include <linux/slab.h>
>  #include <linux/workqueue.h>
>  #include <linux/i8042.h>
> -
> +#include <linux/acpi.h>
>  #include <asm/uaccess.h>
> 
> -#include <acpi/acpi_drivers.h>
> -
>  MODULE_AUTHOR("John Belmonte");
>  MODULE_DESCRIPTION("Toshiba Laptop ACPI Extras Driver");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/platform/x86/toshiba_bluetooth.c b/drivers/platform/x86/toshiba_bluetooth.c
> index 74dd01a..2cb1ea6 100644
> --- a/drivers/platform/x86/toshiba_bluetooth.c
> +++ b/drivers/platform/x86/toshiba_bluetooth.c
> @@ -23,14 +23,12 @@
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/types.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
> 
>  MODULE_AUTHOR("Jes Sorensen <Jes.Sorensen@gmail.com>");
>  MODULE_DESCRIPTION("Toshiba Laptop ACPI Bluetooth Enable Driver");
>  MODULE_LICENSE("GPL");
> 
> -
>  static int toshiba_bt_rfkill_add(struct acpi_device *device);
>  static int toshiba_bt_rfkill_remove(struct acpi_device *device);
>  static void toshiba_bt_rfkill_notify(struct acpi_device *device, u32 event);
> diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
> index 62e8c22..ba13ade 100644
> --- a/drivers/platform/x86/wmi.c
> +++ b/drivers/platform/x86/wmi.c
> @@ -37,8 +37,6 @@
>  #include <linux/acpi.h>
>  #include <linux/slab.h>
>  #include <linux/module.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> 
>  ACPI_MODULE_NAME("wmi");
>  MODULE_AUTHOR("Carlos Corbacho");
> diff --git a/drivers/platform/x86/xo15-ebook.c b/drivers/platform/x86/xo15-ebook.c
> index 4b1377b..49cbcce 100644
> --- a/drivers/platform/x86/xo15-ebook.c
> +++ b/drivers/platform/x86/xo15-ebook.c
> @@ -18,8 +18,7 @@
>  #include <linux/init.h>
>  #include <linux/types.h>
>  #include <linux/input.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
> 
>  #define MODULE_NAME "xo15-ebook"
> 
> diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
> index 14655a0..e869ba6 100644
> --- a/drivers/pnp/pnpacpi/core.c
> +++ b/drivers/pnp/pnpacpi/core.c
> @@ -24,7 +24,6 @@
>  #include <linux/pnp.h>
>  #include <linux/slab.h>
>  #include <linux/mod_devicetable.h>
> -#include <acpi/acpi_bus.h>
> 
>  #include "../base.h"
>  #include "pnpacpi.h"
> diff --git a/drivers/pnp/pnpacpi/pnpacpi.h b/drivers/pnp/pnpacpi/pnpacpi.h
> index 3e60225..051ef96 100644
> --- a/drivers/pnp/pnpacpi/pnpacpi.h
> +++ b/drivers/pnp/pnpacpi/pnpacpi.h
> @@ -1,7 +1,6 @@
>  #ifndef ACPI_PNP_H
>  #define ACPI_PNP_H
> 
> -#include <acpi/acpi_bus.h>
>  #include <linux/acpi.h>
>  #include <linux/pnp.h>
> 
> diff --git a/drivers/sfi/sfi_acpi.c b/drivers/sfi/sfi_acpi.c
> index f5b4ca5..5e753d7 100644
> --- a/drivers/sfi/sfi_acpi.c
> +++ b/drivers/sfi/sfi_acpi.c
> @@ -60,7 +60,7 @@
>  #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
> 
>  #include <linux/kernel.h>
> -#include <acpi/acpi.h>
> +#include <acpi/acpi.h>	/* FIXME: inclusion should be removed */
> 
>  #include <linux/sfi.h>
>  #include "sfi_core.h"
> diff --git a/drivers/staging/quickstart/quickstart.c b/drivers/staging/quickstart/quickstart.c
> index 9f6ebdb..a85c3d6 100644
> --- a/drivers/staging/quickstart/quickstart.c
> +++ b/drivers/staging/quickstart/quickstart.c
> @@ -31,7 +31,7 @@
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/types.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
>  #include <linux/platform_device.h>
>  #include <linux/input.h>
> 
> diff --git a/drivers/usb/core/usb-acpi.c b/drivers/usb/core/usb-acpi.c
> index 4e243c3..11c6569 100644
> --- a/drivers/usb/core/usb-acpi.c
> +++ b/drivers/usb/core/usb-acpi.c
> @@ -16,7 +16,6 @@
>  #include <linux/acpi.h>
>  #include <linux/pci.h>
>  #include <linux/usb/hcd.h>
> -#include <acpi/acpi_bus.h>
> 
>  #include "usb.h"
> 
> diff --git a/drivers/xen/xen-acpi-cpuhotplug.c b/drivers/xen/xen-acpi-cpuhotplug.c
> index 73496c3..80875fb 100644
> --- a/drivers/xen/xen-acpi-cpuhotplug.c
> +++ b/drivers/xen/xen-acpi-cpuhotplug.c
> @@ -24,10 +24,7 @@
>  #include <linux/cpu.h>
>  #include <linux/acpi.h>
>  #include <linux/uaccess.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
>  #include <acpi/processor.h>
> -
>  #include <xen/acpi.h>
>  #include <xen/interface/platform.h>
>  #include <asm/xen/hypercall.h>
> diff --git a/drivers/xen/xen-acpi-memhotplug.c b/drivers/xen/xen-acpi-memhotplug.c
> index 9b056f0..f8d1862 100644
> --- a/drivers/xen/xen-acpi-memhotplug.c
> +++ b/drivers/xen/xen-acpi-memhotplug.c
> @@ -22,7 +22,6 @@
>  #include <linux/init.h>
>  #include <linux/types.h>
>  #include <linux/acpi.h>
> -#include <acpi/acpi_drivers.h>
>  #include <xen/acpi.h>
>  #include <xen/interface/platform.h>
>  #include <asm/xen/hypercall.h>
> diff --git a/drivers/xen/xen-acpi-pad.c b/drivers/xen/xen-acpi-pad.c
> index 59708fd..40c4bc0 100644
> --- a/drivers/xen/xen-acpi-pad.c
> +++ b/drivers/xen/xen-acpi-pad.c
> @@ -18,11 +18,10 @@
> 
>  #include <linux/kernel.h>
>  #include <linux/types.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> -#include <asm/xen/hypercall.h>
> +#include <linux/acpi.h>
>  #include <xen/interface/version.h>
>  #include <xen/xen-ops.h>
> +#include <asm/xen/hypercall.h>
> 
>  #define ACPI_PROCESSOR_AGGREGATOR_CLASS	"acpi_pad"
>  #define ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME "Processor Aggregator"
> diff --git a/drivers/xen/xen-acpi-processor.c b/drivers/xen/xen-acpi-processor.c
> index 13bc6c3..7231859 100644
> --- a/drivers/xen/xen-acpi-processor.c
> +++ b/drivers/xen/xen-acpi-processor.c
> @@ -28,10 +28,8 @@
>  #include <linux/module.h>
>  #include <linux/types.h>
>  #include <linux/syscore_ops.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
>  #include <acpi/processor.h>
> -
>  #include <xen/xen.h>
>  #include <xen/interface/platform.h>
>  #include <asm/xen/hypercall.h>
> diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> index 95831e7..b241b73 100644
> --- a/include/acpi/acpi_bus.h
> +++ b/include/acpi/acpi_bus.h
> @@ -28,8 +28,6 @@
> 
>  #include <linux/device.h>
> 
> -#include <acpi/acpi.h>
> -
>  /* TBD: Make dynamic */
>  #define ACPI_MAX_HANDLES	10
>  struct acpi_handle_list {
> diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
> index 1cedfcb..b124fdb 100644
> --- a/include/acpi/acpi_drivers.h
> +++ b/include/acpi/acpi_drivers.h
> @@ -26,9 +26,6 @@
>  #ifndef __ACPI_DRIVERS_H__
>  #define __ACPI_DRIVERS_H__
> 
> -#include <linux/acpi.h>
> -#include <acpi/acpi_bus.h>
> -
>  #define ACPI_MAX_STRING			80
> 
>  /*
> diff --git a/include/linux/acpi_io.h b/include/linux/acpi_io.h
> index b0ffa21..2a5a139 100644
> --- a/include/linux/acpi_io.h
> +++ b/include/linux/acpi_io.h
> @@ -2,7 +2,7 @@
>  #define _ACPI_IO_H_
> 
>  #include <linux/io.h>
> -#include <acpi/acpi.h>
> +#include <acpi/acpi.h>	/* FIXME: inclusion should be removed */
> 
>  static inline void __iomem *acpi_os_ioremap(acpi_physical_address phys,
>  					    acpi_size size)
> diff --git a/include/linux/ide.h b/include/linux/ide.h
> index 46a1422..93b5ca7 100644
> --- a/include/linux/ide.h
> +++ b/include/linux/ide.h
> @@ -18,14 +18,10 @@
>  #include <linux/completion.h>
>  #include <linux/pm.h>
>  #include <linux/mutex.h>
> -#ifdef CONFIG_BLK_DEV_IDEACPI
> -#include <acpi/acpi.h>
> -#endif
> -#include <asm/byteorder.h>
> -#include <asm/io.h>
> -
>  /* for request_sense */
>  #include <linux/cdrom.h>
> +#include <asm/byteorder.h>
> +#include <asm/io.h>
> 
>  #if defined(CONFIG_CRIS) || defined(CONFIG_FRV) || defined(CONFIG_MN10300)
>  # define SUPPORT_VLB_SYNC 0
> diff --git a/include/linux/iscsi_ibft.h b/include/linux/iscsi_ibft.h
> index 8ba7e5b..82f9673 100644
> --- a/include/linux/iscsi_ibft.h
> +++ b/include/linux/iscsi_ibft.h
> @@ -21,7 +21,7 @@
>  #ifndef ISCSI_IBFT_H
>  #define ISCSI_IBFT_H
> 
> -#include <acpi/acpi.h>
> +#include <acpi/acpi.h>	/* FIXME: inclusion should be removed */
> 
>  /*
>   * Logical location of iSCSI Boot Format Table.
> diff --git a/include/linux/pci_hotplug.h b/include/linux/pci_hotplug.h
> index a2e2f1d..5f2e559 100644
> --- a/include/linux/pci_hotplug.h
> +++ b/include/linux/pci_hotplug.h
> @@ -175,8 +175,7 @@ struct hotplug_params {
>  };
> 
>  #ifdef CONFIG_ACPI
> -#include <acpi/acpi.h>
> -#include <acpi/acpi_bus.h>
> +#include <linux/acpi.h>
>  int pci_get_hp_params(struct pci_dev *dev, struct hotplug_params *hpp);
>  int acpi_get_hp_hw_control_from_firmware(struct pci_dev *dev, u32 flags);
>  int acpi_pci_check_ejectable(struct pci_bus *pbus, acpi_handle handle);
> diff --git a/include/linux/sfi_acpi.h b/include/linux/sfi_acpi.h
> index 631af63..2cfcb79 100644
> --- a/include/linux/sfi_acpi.h
> +++ b/include/linux/sfi_acpi.h
> @@ -60,7 +60,7 @@
>  #define _LINUX_SFI_ACPI_H
> 
>  #ifdef CONFIG_SFI
> -#include <acpi/acpi.h>		/* struct acpi_table_header */
> +#include <acpi/acpi.h>	/* FIXME: inclusion should be removed */
> 
>  extern int sfi_acpi_table_parse(char *signature, char *oem_id,
>  				char *oem_table_id,
> diff --git a/include/linux/tboot.h b/include/linux/tboot.h
> index c75128b..9a54b33 100644
> --- a/include/linux/tboot.h
> +++ b/include/linux/tboot.h
> @@ -34,7 +34,7 @@ enum {
>  };
> 
>  #ifdef CONFIG_INTEL_TXT
> -#include <acpi/acpi.h>
> +#include <linux/acpi.h>
>  /* used to communicate between tboot and the launched kernel */
> 
>  #define TB_KEY_SIZE             64   /* 512 bits */
> diff --git a/tools/power/cpupower/debug/kernel/cpufreq-test_tsc.c b/tools/power/cpupower/debug/kernel/cpufreq-test_tsc.c
> index 66cace6..0f10b81 100644
> --- a/tools/power/cpupower/debug/kernel/cpufreq-test_tsc.c
> +++ b/tools/power/cpupower/debug/kernel/cpufreq-test_tsc.c
> @@ -25,12 +25,9 @@
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/delay.h>
> -
> +#include <linux/acpi.h>
>  #include <asm/io.h>
> 
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> -
>  static int pm_tmr_ioport = 0;
> 
>  /*helper function to safely read acpi pm timesource*/
> --
> 1.7.10
> 

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
