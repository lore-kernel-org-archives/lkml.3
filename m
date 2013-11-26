Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab3KYXxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 18:53:34 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62904 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752104Ab3KYXxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 18:53:30 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lv Zheng <zetalog@gmail.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/4] ACPI: Cleanup <acpi/acpi_bus.h> and <acpi/acpi_drivers.h> inclusions.
Date: Tue, 26 Nov 2013 01:06:16 +0100
Message-ID: <9115833.KtCKlFnNUO@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <0292f01e89b52e1f6c581fc23684ea2b5f2bb1d8.1385094641.git.lv.zheng@intel.com>
References: <cover.1385094640.git.lv.zheng@intel.com> <0292f01e89b52e1f6c581fc23684ea2b5f2bb1d8.1385094641.git.lv.zheng@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 23, 2013 07:29:08 AM Lv Zheng wrote:
> From: Lv Zheng <lv.zheng@intel.com>
> 
> This patch enfoces <linux/acpi.h> inclusion instead of direct
> <acpi/acpi_drivers.h> and <acpi/acpi_bus.h> inclusions.

First off, please make the changelog shorter.  Here's my version:

"Replace direct inclusions of <acpi/acpi_drivers.h> and <acpi/acpi_bus.h>,
which are incorrect, with <linux/acpi.h> inclusions.

First of all, <acpi/acpi_drivers.h> and <acpi/acpi_bus.h> should not
be included directly from any files that are built for CONFIG_ACPI
unset, because that generally leads to build warnings about undefined
symbols in !CONFIG_ACPI builds.  For CONFIG_ACPI set <linux/acpi.h>
includes those files and for CONFIG_ACPI it provides stub ACPI
symbols to be used in that case.

Second, there are ordering dependencies between those files that
always have to be met.  Namely, it is required that <acpi/acpi_bus.h>
be included prior to <acpi/acpi_drivers.h> so that the acpi_pci_root
declarations the latter depends on are always there.  That also is
taken care of including <linux/acpi.h> as appropriate."

Second, please fold [3/4] into this one.  Keeping them separate is
artificial and pointless in my opinion.  [Of course, the changelog will
have to be modified then.]

[...]

Apart from the above ->

> Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> ---
>  arch/ia64/hp/common/aml_nfw.c                        |    3 +--
>  arch/x86/kernel/apic/apic_flat_64.c                  |    4 +---
>  arch/x86/kernel/apic/io_apic.c                       |    3 ---
>  arch/x86/platform/olpc/olpc-xo15-sci.c               |    3 +--
>  drivers/acpi/ac.c                                    |    3 +--
>  drivers/acpi/acpi_extlog.c                           |    1 -
>  drivers/acpi/acpi_pad.c                              |    3 +--
>  drivers/acpi/battery.c                               |    3 +--
>  drivers/acpi/blacklist.c                             |    1 -
>  drivers/acpi/bus.c                                   |    2 --
>  drivers/acpi/button.c                                |    3 +--
>  drivers/acpi/custom_method.c                         |    2 +-
>  drivers/acpi/debugfs.c                               |    2 +-
>  drivers/acpi/dock.c                                  |    2 --
>  drivers/acpi/ec.c                                    |    3 +--
>  drivers/acpi/event.c                                 |    2 +-
>  drivers/acpi/fan.c                                   |    3 +--
>  drivers/acpi/hed.c                                   |    2 --
>  drivers/acpi/numa.c                                  |    1 -
>  drivers/acpi/osl.c                                   |    1 -
>  drivers/acpi/pci_irq.c                               |    2 --
>  drivers/acpi/pci_link.c                              |    3 +--
>  drivers/acpi/pci_root.c                              |    2 --
>  drivers/acpi/power.c                                 |    3 +--
>  drivers/acpi/proc.c                                  |    3 +--
>  drivers/acpi/processor_core.c                        |    2 +-
>  drivers/acpi/processor_idle.c                        |    1 -
>  drivers/acpi/processor_perflib.c                     |    3 +--
>  drivers/acpi/processor_thermal.c                     |    3 +--
>  drivers/acpi/processor_throttling.c                  |    3 +--
>  drivers/acpi/sbshc.c                                 |    3 +--
>  drivers/acpi/scan.c                                  |    1 -
>  drivers/acpi/sleep.c                                 |    2 --
>  drivers/acpi/sysfs.c                                 |    2 +-
>  drivers/acpi/thermal.c                               |    3 +--
>  drivers/acpi/utils.c                                 |    2 --
>  drivers/acpi/video.c                                 |    3 +--
>  drivers/acpi/wakeup.c                                |    1 -
>  drivers/ata/libata-acpi.c                            |    1 -
>  drivers/ata/pata_acpi.c                              |    2 +-
>  drivers/char/hpet.c                                  |    1 -
>  drivers/char/tpm/tpm_ppi.c                           |    1 -
>  drivers/gpu/drm/i915/intel_acpi.c                    |    1 -
>  drivers/gpu/drm/nouveau/nouveau_acpi.c               |    2 --
>  drivers/gpu/drm/radeon/radeon_acpi.c                 |    2 --
>  drivers/hv/vmbus_drv.c                               |    1 -
>  drivers/hwmon/acpi_power_meter.c                     |    3 +--
>  drivers/hwmon/asus_atk0110.c                         |    3 +--
>  drivers/input/misc/atlas_btns.c                      |    2 +-
>  drivers/pci/hotplug/acpiphp_ibm.c                    |    1 -
>  drivers/pci/hotplug/pciehp.h                         |    1 -
>  drivers/pci/ioapic.c                                 |    1 -
>  drivers/pci/pci-acpi.c                               |    1 -
>  drivers/pci/pci-label.c                              |    1 -
>  drivers/platform/x86/acer-wmi.c                      |    1 -
>  drivers/platform/x86/asus-laptop.c                   |    3 +--
>  drivers/platform/x86/asus-wmi.c                      |    3 +--
>  drivers/platform/x86/classmate-laptop.c              |    2 +-
>  drivers/platform/x86/dell-wmi-aio.c                  |    1 -
>  drivers/platform/x86/dell-wmi.c                      |    1 -
>  drivers/platform/x86/eeepc-laptop.c                  |    3 +--
>  drivers/platform/x86/eeepc-wmi.c                     |    2 +-
>  drivers/platform/x86/hp_accel.c                      |    2 +-
>  drivers/platform/x86/ideapad-laptop.c                |    3 +--
>  drivers/platform/x86/intel-rst.c                     |    2 +-
>  drivers/platform/x86/intel-smartconnect.c            |    2 +-
>  drivers/platform/x86/intel_menlow.c                  |    3 +--
>  drivers/platform/x86/intel_oaktrail.c                |    2 --
>  drivers/platform/x86/mxm-wmi.c                       |    3 +--
>  drivers/platform/x86/panasonic-laptop.c              |    3 +--
>  drivers/platform/x86/pvpanic.c                       |    3 +--
>  drivers/platform/x86/samsung-q10.c                   |    2 +-
>  drivers/platform/x86/sony-laptop.c                   |    2 --
>  drivers/platform/x86/tc1100-wmi.c                    |    3 +--
>  drivers/platform/x86/thinkpad_acpi.c                 |    2 +-
>  drivers/platform/x86/toshiba_acpi.c                  |    2 +-
>  drivers/platform/x86/toshiba_bluetooth.c             |    3 +--
>  drivers/platform/x86/wmi.c                           |    2 --
>  drivers/platform/x86/xo15-ebook.c                    |    3 +--
>  drivers/pnp/pnpacpi/core.c                           |    1 -
>  drivers/pnp/pnpacpi/pnpacpi.h                        |    1 -
>  drivers/staging/quickstart/quickstart.c              |    2 +-
>  drivers/usb/core/usb-acpi.c                          |    1 -
>  drivers/xen/xen-acpi-cpuhotplug.c                    |    2 --
>  drivers/xen/xen-acpi-memhotplug.c                    |    1 -
>  drivers/xen/xen-acpi-pad.c                           |    3 +--
>  drivers/xen/xen-acpi-processor.c                     |    3 +--
>  include/acpi/acpi_bus.h                              |    1 -
>  include/acpi/acpi_drivers.h                          |    2 --
>  include/linux/pci_hotplug.h                          |    2 +-
>  tools/power/cpupower/debug/kernel/cpufreq-test_tsc.c |    3 +--
>  91 files changed, 51 insertions(+), 142 deletions(-)
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
> index bba9b72..cfea1c5 100644
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
> index dcd73cc..9ab9e78 100644
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
> index ba5b56d..1bd3de4 100644
> --- a/drivers/acpi/ec.c
> +++ b/drivers/acpi/ec.c
> @@ -40,8 +40,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/slab.h>
>  #include <asm/io.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>

-> add the new #include above the <asm/io.h> maybe?

>  #include <linux/dmi.h>
>  
>  #include "internal.h"
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
> index 54a20ff..8507034 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -50,7 +50,6 @@
>  #include <asm/uaccess.h>
>  
>  #include <acpi/acpi.h>
> -#include <acpi/acpi_bus.h>
>  #include <acpi/processor.h>

-> I guess all of these <acpi/...> inclusions may go away from here?

>  #include "internal.h"
>  
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
> index 2652a61..cc5feb9 100644
> --- a/drivers/acpi/pci_link.c
> +++ b/drivers/acpi/pci_link.c
> @@ -40,8 +40,7 @@
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
>  

-> Remove the empty line too.

> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
>  
>  #define PREFIX "ACPI: "
>  
> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
> index 20360e4..dadd0f50 100644
> --- a/drivers/acpi/pci_root.c
> +++ b/drivers/acpi/pci_root.c
> @@ -35,8 +35,6 @@
>  #include <linux/pci-aspm.h>
>  #include <linux/acpi.h>
>  #include <linux/slab.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
>  #include <acpi/apei.h>

Does <acpi/apei.h> have to be included directly here?  If not, please remove
it too.

>  
>  #include "internal.h"
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
> index 6a5b152..56d30fe 100644
> --- a/drivers/acpi/proc.c
> +++ b/drivers/acpi/proc.c
> @@ -5,8 +5,7 @@
>  #include <linux/bcd.h>
>  #include <asm/uaccess.h>
>  
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>

-> Put the new line above the <asm/uaccess.h>

>  
>  #include "sleep.h"
>  
> diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
> index b3171f3..ad88410 100644
> --- a/drivers/acpi/processor_core.c
> +++ b/drivers/acpi/processor_core.c
> @@ -11,7 +11,7 @@
>  #include <linux/dmi.h>
>  #include <linux/slab.h>
>  
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
>  #include <acpi/processor.h>

-> Remove the useless empty line and processor.h inclusion too.

>  
>  #include "internal.h"
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index 644516d..a1087d8 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -46,7 +46,6 @@
>  #include <asm/apic.h>
>  #endif
>  
> -#include <acpi/acpi_bus.h>
>  #include <acpi/processor.h>

Is the processor.h inclusion necessary here?

>  
>  #define PREFIX "ACPI: "
> diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
> index 60a7c28..df63370 100644
> --- a/drivers/acpi/processor_perflib.c
> +++ b/drivers/acpi/processor_perflib.c
> @@ -36,8 +36,7 @@
>  #include <asm/cpufeature.h>
>  #endif
>  
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
>  #include <acpi/processor.h>

And here?  And it's better to add #include <linux/acpi.h> to the other #include
<linux/...> things.

>  #define PREFIX "ACPI: "
> diff --git a/drivers/acpi/processor_thermal.c b/drivers/acpi/processor_thermal.c
> index d1d2e7f..4af89f9 100644
> --- a/drivers/acpi/processor_thermal.c
> +++ b/drivers/acpi/processor_thermal.c
> @@ -33,9 +33,8 @@
>  
>  #include <asm/uaccess.h>
>  
> -#include <acpi/acpi_bus.h>
> +#include <linux/acpi.h>
>  #include <acpi/processor.h>
> -#include <acpi/acpi_drivers.h>

Same comments as above.

>  #define PREFIX "ACPI: "
>  
> diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
> index e7dd2c1..a9de919 100644
> --- a/drivers/acpi/processor_throttling.c
> +++ b/drivers/acpi/processor_throttling.c
> @@ -36,8 +36,7 @@
>  #include <asm/io.h>
>  #include <asm/uaccess.h>
>  
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> +#include <linux/acpi.h>
>  #include <acpi/processor.h>

Same comments as above.

>  #define PREFIX "ACPI: "
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
> index fd39459..8870277 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -12,7 +12,6 @@
>  #include <linux/dmi.h>
>  #include <linux/nls.h>
>  
> -#include <acpi/acpi_drivers.h>
>  

Remove the empty line too.

>  #include "internal.h"
>  
> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> index 721e949..281e5fd 100644
> --- a/drivers/acpi/sleep.c
> +++ b/drivers/acpi/sleep.c
> @@ -21,8 +21,6 @@
>  
>  #include <asm/io.h>
>  
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
>  

Remove the empty line too.

OK, you should get the idea. Please keep things consistent and nice. :-)

Thanks,
Rafael

