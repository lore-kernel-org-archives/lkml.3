Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbaDVI3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:29:20 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:60870 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349AbaDVI2l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:28:41 -0400
Date: Tue, 22 Apr 2014 10:28:34 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Thomas Glanzmann <thomas@glanzmann.de>, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>, alexander.deucher@amd.com,
        christian.koenig@amd.com, daniel.vetter@ffwll.ch,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: REGRESSION: OOPS: Intel Corporation Core Processor Integrated
 Graphics Controller, Linux HEAD when powering off internal Laptop display on
 t410s and extending and rotating external screen
Message-ID: <20140422082834.GL10722@phenom.ffwll.local>
Mail-Followup-To: Jani Nikula <jani.nikula@linux.intel.com>,
	Thomas Glanzmann <thomas@glanzmann.de>,
	dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
	alexander.deucher@amd.com, christian.koenig@amd.com,
	LKML <linux-kernel@vger.kernel.org>
References: <20140417065811.GA9319@glanzmann.de>
 <877g6ogie7.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <877g6ogie7.fsf@intel.com>
X-Operating-System: Linux phenom 3.14.0+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 05:06:24PM +0300, Jani Nikula wrote:
> On Thu, 17 Apr 2014, Thomas Glanzmann <thomas@glanzmann.de> wrote:
> > Hello,
> > I have t410s with an internal Intel graphic card. I have the
> > Laptop display (LVDS1) and an external HP ZR2440W Monitor connected to
> > the Display port. I pulled yesterday git head which probably contains a
> > DRI changes which lead to PANIC. Before that even with a 3.15.0-rc1+ it
> > was working.
> 
> Hi Thomas, please bisect, it's likely the quickest way to root cause
> this. (Google for "git bisect kernel" for a bunch of guides on the topic
> if you're not familiar with bisect.)

We'd also need a dmesg with drm.debug=0xe added to your kernel cmdline
line to debug these pipe config mismatch issues. The dmesg should cover
everything from boot up to the very first WARNING.
-Daniel

> 
> BR,
> Jani.
> 
> 
> >
> > The internal display is at 1440x900, the external as well, both are not
> > rotated. I want to disable the internal display, change the resolution
> > of the external display to 1920x1200 and rotate it. So I execute the
> > commands:
> >
> > xrandr --output DP1 --mode 1920x1200
> > xrandr --output LVDS1 --off
> > xrandr -o 1
> >
> > If I do that I get:
> >
> > [    0.000000] Initializing cgroup subsys cpuset
> > [    0.000000] Initializing cgroup subsys cpu
> > [    0.000000] Initializing cgroup subsys cpuacct
> > [    0.000000] Linux version 3.15.0-rc1+ (sithglan@lenovo) (gcc version 4.7.2 (Debian 4.7.2-5) ) #66 SMP Wed Apr 16 17:16:33 CEST 2014
> > [    0.000000] Command line: BOOT_IMAGE=/home/sithglan/work/linux-2.6/arch/x86/boot/bzImage root=UUID=e79cc073-026a-4671-a065-63e2391ff974 ro nomodeset intel.modeset=0
> > [    0.000000] e820: BIOS-provided physical RAM map:
> > [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009e7ff] usable
> > [    0.000000] BIOS-e820: [mem 0x000000000009e800-0x000000000009ffff] reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000000dc000-0x00000000000fffff] reserved
> > [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bb27bfff] usable
> > [    0.000000] BIOS-e820: [mem 0x00000000bb27c000-0x00000000bb281fff] reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000bb282000-0x00000000bb35efff] usable
> > [    0.000000] BIOS-e820: [mem 0x00000000bb35f000-0x00000000bb370fff] reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000bb371000-0x00000000bb3f1fff] ACPI NVS
> > [    0.000000] BIOS-e820: [mem 0x00000000bb3f2000-0x00000000bb40efff] reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000bb40f000-0x00000000bb46efff] usable
> > [    0.000000] BIOS-e820: [mem 0x00000000bb46f000-0x00000000bb667fff] reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000bb668000-0x00000000bb6e7fff] ACPI NVS
> > [    0.000000] BIOS-e820: [mem 0x00000000bb6e8000-0x00000000bb70efff] reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000bb70f000-0x00000000bb716fff] usable
> > [    0.000000] BIOS-e820: [mem 0x00000000bb717000-0x00000000bb71efff] reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000bb71f000-0x00000000bb76afff] usable
> > [    0.000000] BIOS-e820: [mem 0x00000000bb76b000-0x00000000bb776fff] ACPI NVS
> > [    0.000000] BIOS-e820: [mem 0x00000000bb777000-0x00000000bb779fff] ACPI data
> > [    0.000000] BIOS-e820: [mem 0x00000000bb77a000-0x00000000bb780fff] ACPI NVS
> > [    0.000000] BIOS-e820: [mem 0x00000000bb781000-0x00000000bb781fff] ACPI data
> > [    0.000000] BIOS-e820: [mem 0x00000000bb782000-0x00000000bb78afff] ACPI NVS
> > [    0.000000] BIOS-e820: [mem 0x00000000bb78b000-0x00000000bb78bfff] ACPI data
> > [    0.000000] BIOS-e820: [mem 0x00000000bb78c000-0x00000000bb79efff] ACPI NVS
> > [    0.000000] BIOS-e820: [mem 0x00000000bb79f000-0x00000000bb7fefff] ACPI data
> > [    0.000000] BIOS-e820: [mem 0x00000000bb7ff000-0x00000000bb7fffff] usable
> > [    0.000000] BIOS-e820: [mem 0x00000000bb800000-0x00000000bfffffff] reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000feaff000-0x00000000feafffff] reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed003ff] reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed8ffff] reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
> > [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x0000000137ffffff] usable
> > [    0.000000] NX (Execute Disable) protection: active
> > [    0.000000] SMBIOS 2.6 present.
> > [    0.000000] DMI: LENOVO 2912W1C/2912W1C, BIOS 6UET70WW (1.50 ) 10/11/2012
> > [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> > [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> > [    0.000000] No AGP bridge found
> > [    0.000000] e820: last_pfn = 0x138000 max_arch_pfn = 0x400000000
> > [    0.000000] MTRR default type: uncachable
> > [    0.000000] MTRR fixed ranges enabled:
> > [    0.000000]   00000-9FFFF write-back
> > [    0.000000]   A0000-BFFFF uncachable
> > [    0.000000]   C0000-FFFFF write-protect
> > [    0.000000] MTRR variable ranges enabled:
> > [    0.000000]   0 disabled
> > [    0.000000]   1 base 000000000 mask F80000000 write-back
> > [    0.000000]   2 base 080000000 mask FC0000000 write-back
> > [    0.000000]   3 base 100000000 mask FC0000000 write-back
> > [    0.000000]   4 base 138000000 mask FF8000000 uncachable
> > [    0.000000]   5 base 0BC000000 mask FFC000000 uncachable
> > [    0.000000]   6 disabled
> > [    0.000000]   7 disabled
> > [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> > [    0.000000] e820: update [mem 0xbc000000-0xffffffff] usable ==> reserved
> > [    0.000000] e820: last_pfn = 0xbb800 max_arch_pfn = 0x400000000
> > [    0.000000] found SMP MP-table at [mem 0x000f68e0-0x000f68ef] mapped at [ffff8800000f68e0]
> > [    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
> > [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> > [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> > [    0.000000] BRK [0x01861000, 0x01861fff] PGTABLE
> > [    0.000000] BRK [0x01862000, 0x01862fff] PGTABLE
> > [    0.000000] BRK [0x01863000, 0x01863fff] PGTABLE
> > [    0.000000] init_memory_mapping: [mem 0x137e00000-0x137ffffff]
> > [    0.000000]  [mem 0x137e00000-0x137ffffff] page 2M
> > [    0.000000] BRK [0x01864000, 0x01864fff] PGTABLE
> > [    0.000000] init_memory_mapping: [mem 0x134000000-0x137dfffff]
> > [    0.000000]  [mem 0x134000000-0x137dfffff] page 2M
> > [    0.000000] init_memory_mapping: [mem 0x100000000-0x133ffffff]
> > [    0.000000]  [mem 0x100000000-0x133ffffff] page 2M
> > [    0.000000] init_memory_mapping: [mem 0x00100000-0xbb27bfff]
> > [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> > [    0.000000]  [mem 0x00200000-0xbb1fffff] page 2M
> > [    0.000000]  [mem 0xbb200000-0xbb27bfff] page 4k
> > [    0.000000] init_memory_mapping: [mem 0xbb282000-0xbb35efff]
> > [    0.000000]  [mem 0xbb282000-0xbb35efff] page 4k
> > [    0.000000] init_memory_mapping: [mem 0xbb40f000-0xbb46efff]
> > [    0.000000]  [mem 0xbb40f000-0xbb46efff] page 4k
> > [    0.000000] BRK [0x01865000, 0x01865fff] PGTABLE
> > [    0.000000] init_memory_mapping: [mem 0xbb70f000-0xbb716fff]
> > [    0.000000]  [mem 0xbb70f000-0xbb716fff] page 4k
> > [    0.000000] BRK [0x01866000, 0x01866fff] PGTABLE
> > [    0.000000] init_memory_mapping: [mem 0xbb71f000-0xbb76afff]
> > [    0.000000]  [mem 0xbb71f000-0xbb76afff] page 4k
> > [    0.000000] init_memory_mapping: [mem 0xbb7ff000-0xbb7fffff]
> > [    0.000000]  [mem 0xbb7ff000-0xbb7fffff] page 4k
> > [    0.000000] RAMDISK: [mem 0x36992000-0x374c0fff]
> > [    0.000000] ACPI: RSDP 0x00000000000F68A0 000024 (v02 LENOVO)
> > [    0.000000] ACPI: XSDT 0x00000000BB7EF1FE 00009C (v01 LENOVO TP-6U    00001500  LTP 00000000)
> > [    0.000000] ACPI: FACP 0x00000000BB7EF300 0000F4 (v04 LENOVO TP-6U    00001500 LNVO 00000001)
> > [    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Pm1aControlBlock: 16/32 (20140214/tbfadt-603)
> > [    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aControlBlock: 32, using default 16 (20140214/tbfadt-684)
> > [    0.000000] ACPI: DSDT 0x00000000BB7EF6D1 00F432 (v01 LENOVO TP-6U    00001500 MSFT 03000001)
> > [    0.000000] ACPI: FACS 0x00000000BB6E7000 000040
> > [    0.000000] ACPI: SSDT 0x00000000BB7EF4B4 00021D (v01 LENOVO TP-6U    00001500 MSFT 03000001)
> > [    0.000000] ACPI: ECDT 0x00000000BB7FEB03 000052 (v01 LENOVO TP-6U    00001500 LNVO 00000001)
> > [    0.000000] ACPI: APIC 0x00000000BB7FEB55 000084 (v01 LENOVO TP-6U    00001500 LNVO 00000001)
> > [    0.000000] ACPI: MCFG 0x00000000BB7FEC11 00003C (v01 LENOVO TP-6U    00001500 LNVO 00000001)
> > [    0.000000] ACPI: HPET 0x00000000BB7FEC4D 000038 (v01 LENOVO TP-6U    00001500 LNVO 00000001)
> > [    0.000000] ACPI: ASF! 0x00000000BB7FEDBE 0000A4 (v16 LENOVO TP-6U    00001500 PTL  00000001)
> > [    0.000000] ACPI: SLIC 0x00000000BB7FEE62 000176 (v01 LENOVO TP-6U    00001500  LTP 00000000)
> > [    0.000000] ACPI: BOOT 0x00000000BB7FEFD8 000028 (v01 LENOVO TP-6U    00001500  LTP 00000001)
> > [    0.000000] ACPI: SSDT 0x00000000BB6E591A 00084B (v01 LENOVO TP-6U    00001500 INTL 20050513)
> > [    0.000000] ACPI: TCPA 0x00000000BB78B000 000032 (v02 PTL     CRESTLN 06040000      00005A52)
> > [    0.000000] ACPI: DMAR 0x00000000BB781000 0000B8 (v01 INTEL  CP_DALE  00000001 INTL 00000001)
> > [    0.000000] ACPI: SSDT 0x00000000BB779000 0009F1 (v01 PmRef  CpuPm    00003000 INTL 20060912)
> > [    0.000000] ACPI: SSDT 0x00000000BB778000 000259 (v01 PmRef  Cpu0Tst  00003000 INTL 20060912)
> > [    0.000000] ACPI: SSDT 0x00000000BB777000 00049F (v01 PmRef  ApTst    00003000 INTL 20060912)
> > [    0.000000] ACPI: Local APIC address 0xfee00000
> > [    0.000000] No NUMA configuration found
> > [    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000137ffffff]
> > [    0.000000] Initmem setup node 0 [mem 0x00000000-0x137ffffff]
> > [    0.000000]   NODE_DATA [mem 0x137ff8000-0x137ffcfff]
> > [    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880133800000-ffff880136ffffff] on node 0
> > [    0.000000] Zone ranges:
> > [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> > [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> > [    0.000000]   Normal   [mem 0x100000000-0x137ffffff]
> > [    0.000000] Movable zone start for each node
> > [    0.000000] Early memory node ranges
> > [    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
> > [    0.000000]   node   0: [mem 0x00100000-0xbb27bfff]
> > [    0.000000]   node   0: [mem 0xbb282000-0xbb35efff]
> > [    0.000000]   node   0: [mem 0xbb40f000-0xbb46efff]
> > [    0.000000]   node   0: [mem 0xbb70f000-0xbb716fff]
> > [    0.000000]   node   0: [mem 0xbb71f000-0xbb76afff]
> > [    0.000000]   node   0: [mem 0xbb7ff000-0xbb7fffff]
> > [    0.000000]   node   0: [mem 0x100000000-0x137ffffff]
> > [    0.000000] On node 0 totalpages: 996267
> > [    0.000000]   DMA zone: 56 pages used for memmap
> > [    0.000000]   DMA zone: 21 pages reserved
> > [    0.000000]   DMA zone: 3997 pages, LIFO batch:0
> > [    0.000000]   DMA32 zone: 10431 pages used for memmap
> > [    0.000000]   DMA32 zone: 762894 pages, LIFO batch:31
> > [    0.000000]   Normal zone: 3136 pages used for memmap
> > [    0.000000]   Normal zone: 229376 pages, LIFO batch:31
> > [    0.000000] Reserving Intel graphics stolen memory at 0xbe000000-0xbfffffff
> > [    0.000000] ACPI: PM-Timer IO Port: 0x1008
> > [    0.000000] ACPI: Local APIC address 0xfee00000
> > [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> > [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> > [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
> > [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
> > [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> > [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> > [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
> > [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
> > [    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
> > [    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
> > [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> > [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> > [    0.000000] ACPI: IRQ0 used by override.
> > [    0.000000] ACPI: IRQ2 used by override.
> > [    0.000000] ACPI: IRQ9 used by override.
> > [    0.000000] Using ACPI (MADT) for SMP configuration information
> > [    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
> > [    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
> > [    0.000000] nr_irqs_gsi: 40
> > [    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
> > [    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
> > [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dbfff]
> > [    0.000000] PM: Registered nosave memory: [mem 0x000dc000-0x000fffff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xbb27c000-0xbb281fff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xbb35f000-0xbb370fff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xbb371000-0xbb3f1fff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xbb3f2000-0xbb40efff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xbb46f000-0xbb667fff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xbb668000-0xbb6e7fff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xbb6e8000-0xbb70efff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xbb717000-0xbb71efff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xbb76b000-0xbb776fff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xbb777000-0xbb779fff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xbb77a000-0xbb780fff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xbb781000-0xbb781fff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xbb782000-0xbb78afff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xbb78b000-0xbb78bfff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xbb78c000-0xbb79efff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xbb79f000-0xbb7fefff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xbb800000-0xbfffffff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xc0000000-0xdfffffff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfeafefff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xfeaff000-0xfeafffff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xfeb00000-0xfebfffff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec0ffff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xfec10000-0xfecfffff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed1bfff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed8ffff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xfed90000-0xfedfffff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
> > [    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
> > [    0.000000] e820: [mem 0xc0000000-0xdfffffff] available for PCI devices
> > [    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
> > [    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880137c00000 s80768 r8192 d21632 u524288
> > [    0.000000] pcpu-alloc: s80768 r8192 d21632 u524288 alloc=1*2097152
> > [    0.000000] pcpu-alloc: [0] 0 1 2 3 
> > [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 982623
> > [    0.000000] Policy zone: Normal
> > [    0.000000] Kernel command line: BOOT_IMAGE=/home/sithglan/work/linux-2.6/arch/x86/boot/bzImage root=UUID=e79cc073-026a-4671-a065-63e2391ff974 ro nomodeset intel.modeset=0
> > [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> > [    0.000000] Checking aperture...
> > [    0.000000] No AGP bridge found
> > [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
> > [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
> > [    0.000000] Memory: 3840812K/3985068K available (3687K kernel code, 643K rwdata, 1560K rodata, 880K init, 888K bss, 144256K reserved)
> > [    0.000000] Hierarchical RCU implementation.
> > [    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
> > [    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=4.
> > [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
> > [    0.000000] NR_IRQS:33024 nr_irqs:712 16
> > [    0.000000] Console: colour VGA+ 80x25
> > [    0.000000] console [tty0] enabled
> > [    0.000000] hpet clockevent registered
> > [    0.000000] tsc: Fast TSC calibration using PIT
> > [    0.000000] tsc: Detected 2394.025 MHz processor
> > [    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 4788.05 BogoMIPS (lpj=9576100)
> > [    0.000150] pid_max: default: 32768 minimum: 301
> > [    0.000228] ACPI: Core revision 20140214
> > [    0.014498] ACPI: All ACPI Tables successfully acquired
> > [    0.021911] Security Framework initialized
> > [    0.021996] AppArmor: AppArmor disabled by boot time parameter
> > [    0.022312] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> > [    0.023356] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> > [    0.023853] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
> > [    0.023947] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
> > [    0.024264] Initializing cgroup subsys devices
> > [    0.024370] Initializing cgroup subsys freezer
> > [    0.024452] Initializing cgroup subsys net_cls
> > [    0.024534] Initializing cgroup subsys blkio
> > [    0.024615] Initializing cgroup subsys perf_event
> > [    0.024717] CPU: Physical Processor ID: 0
> > [    0.024797] CPU: Processor Core ID: 0
> > [    0.024879] mce: CPU supports 9 MCE banks
> > [    0.024968] CPU0: Thermal monitoring enabled (TM1)
> > [    0.025060] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
> > [    0.025060] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
> > [    0.025060] tlb_flushall_shift: 6
> > [    0.025297] Freeing SMP alternatives memory: 12K (ffffffff8177e000 - ffffffff81781000)
> > [    0.025489] dmar: Host address width 36
> > [    0.025569] dmar: DRHD base: 0x000000fed90000 flags: 0x0
> > [    0.025659] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c9008020e30272 ecap 1000
> > [    0.025777] dmar: DRHD base: 0x000000fed91000 flags: 0x0
> > [    0.025865] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c0000020230272 ecap 1000
> > [    0.025983] dmar: DRHD base: 0x000000fed93000 flags: 0x1
> > [    0.026071] dmar: IOMMU 2: reg_base_addr fed93000 ver 1:0 cap c9008020630272 ecap 1000
> > [    0.026190] dmar: RMRR base: 0x000000bb6e9000 end: 0x000000bb6fffff
> > [    0.026278] dmar: RMRR base: 0x000000bdc00000 end: 0x000000bfffffff
> > [    0.026983] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> > [    0.066777] smpboot: CPU0: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz (fam: 06, model: 25, stepping: 02)
> > [    0.172396] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
> > [    0.172684] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
> > [    0.172775] ... version:                3
> > [    0.172854] ... bit width:              48
> > [    0.172934] ... generic registers:      4
> > [    0.173013] ... value mask:             0000ffffffffffff
> > [    0.173097] ... max period:             000000007fffffff
> > [    0.173181] ... fixed-purpose events:   3
> > [    0.173261] ... event mask:             000000070000000f
> > [    0.173651] x86: Booting SMP configuration:
> > [    0.173733] .... node  #0, CPUs:      #1
> > [    0.187151] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
> > [    0.187456]  #2 #3
> > [    0.214017] x86: Booted up 1 node, 4 CPUs
> > [    0.214168] smpboot: Total of 4 processors activated (19152.20 BogoMIPS)
> > [    0.216133] devtmpfs: initialized
> > [    0.221192] PM: Registering ACPI NVS region [mem 0xbb371000-0xbb3f1fff] (528384 bytes)
> > [    0.221329] PM: Registering ACPI NVS region [mem 0xbb668000-0xbb6e7fff] (524288 bytes)
> > [    0.221462] PM: Registering ACPI NVS region [mem 0xbb76b000-0xbb776fff] (49152 bytes)
> > [    0.221581] PM: Registering ACPI NVS region [mem 0xbb77a000-0xbb780fff] (28672 bytes)
> > [    0.221699] PM: Registering ACPI NVS region [mem 0xbb782000-0xbb78afff] (36864 bytes)
> > [    0.221819] PM: Registering ACPI NVS region [mem 0xbb78c000-0xbb79efff] (77824 bytes)
> > [    0.222179] regulator-dummy: no parameters
> > [    0.222335] NET: Registered protocol family 16
> > [    0.222538] cpuidle: using governor ladder
> > [    0.222619] cpuidle: using governor menu
> > [    0.222727] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
> > [    0.222843] ACPI: bus type PCI registered
> > [    0.222923] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> > [    0.223094] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
> > [    0.223218] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
> > [    0.244300] PCI: Using configuration type 1 for base access
> > [    0.245583] ACPI: Added _OSI(Module Device)
> > [    0.245665] ACPI: Added _OSI(Processor Device)
> > [    0.245746] ACPI: Added _OSI(3.0 _SCP Extensions)
> > [    0.245828] ACPI: Added _OSI(Processor Aggregator Device)
> > [    0.247117] ACPI : EC: EC description table is found, configuring boot EC
> > [    0.252015] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> > [    0.334937] ACPI: SSDT 0x00000000BB71AA18 00046F (v01 PmRef  Cpu0Ist  00003000 INTL 20060912)
> > [    0.335481] ACPI: Dynamic OEM Table Load:
> > [    0.335643] ACPI: SSDT 0x0000000000000000 00046F (v01 PmRef  Cpu0Ist  00003000 INTL 20060912)
> > [    0.335951] ACPI: SSDT 0x00000000BB718718 0006B2 (v01 PmRef  Cpu0Cst  00003001 INTL 20060912)
> > [    0.336576] ACPI: Dynamic OEM Table Load:
> > [    0.336739] ACPI: SSDT 0x0000000000000000 0006B2 (v01 PmRef  Cpu0Cst  00003001 INTL 20060912)
> > [    0.360788] ACPI: SSDT 0x00000000BB719A98 000303 (v01 PmRef  ApIst    00003000 INTL 20060912)
> > [    0.361393] ACPI: Dynamic OEM Table Load:
> > [    0.361555] ACPI: SSDT 0x0000000000000000 000303 (v01 PmRef  ApIst    00003000 INTL 20060912)
> > [    0.372636] ACPI: SSDT 0x00000000BB717D98 000119 (v01 PmRef  ApCst    00003000 INTL 20060912)
> > [    0.373149] ACPI: Dynamic OEM Table Load:
> > [    0.373311] ACPI: SSDT 0x0000000000000000 000119 (v01 PmRef  ApCst    00003000 INTL 20060912)
> > [    0.386210] ACPI: Interpreter enabled
> > [    0.386294] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140214/hwxface-580)
> > [    0.386501] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140214/hwxface-580)
> > [    0.386717] ACPI: (supports S0 S3 S4 S5)
> > [    0.386797] ACPI: Using IOAPIC for interrupt routing
> > [    0.386907] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> > [    0.393326] ACPI: Power Resource [PUBS] (on)
> > [    0.394182] acpi PNP0C0A:01: ACPI dock station (docks/bays count: 1)
> > [    0.396656] acpi LNXIOBAY:00: ACPI dock station (docks/bays count: 2)
> > [    0.398960] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
> > [    0.399552] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
> > [    0.400118] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
> > [    0.400823] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
> > [    0.401413] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
> > [    0.402003] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
> > [    0.402571] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
> > [    0.403271] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
> > [    0.403791] ACPI: PCI Root Bridge [UNCR] (domain 0000 [bus ff])
> > [    0.403882] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> > [    0.404004] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
> > [    0.404148] PCI host bridge to bus 0000:ff
> > [    0.404229] pci_bus 0000:ff: root bus resource [bus ff]
> > [    0.404318] pci 0000:ff:00.0: [8086:2c62] type 00 class 0x060000
> > [    0.404376] pci 0000:ff:00.1: [8086:2d01] type 00 class 0x060000
> > [    0.404431] pci 0000:ff:02.0: [8086:2d10] type 00 class 0x060000
> > [    0.404481] pci 0000:ff:02.1: [8086:2d11] type 00 class 0x060000
> > [    0.404530] pci 0000:ff:02.2: [8086:2d12] type 00 class 0x060000
> > [    0.404579] pci 0000:ff:02.3: [8086:2d13] type 00 class 0x060000
> > [    0.404651] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
> > [    0.404741] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> > [    0.405070] acpi PNP0A08:00: _OSC: platform does not support [PCIeCapability]
> > [    0.405257] acpi PNP0A08:00: _OSC: not requesting control; platform does not support [PCIeCapability]
> > [    0.405381] acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug PME AER PCIeCapability]
> > [    0.405499] acpi PNP0A08:00: _OSC: platform willing to grant [PCIeHotplug PME AER]
> > [    0.405615] acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
> > [    0.405863] PCI host bridge to bus 0000:00
> > [    0.405945] pci_bus 0000:00: root bus resource [bus 00-fe]
> > [    0.406030] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> > [    0.406119] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> > [    0.406207] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> > [    0.406298] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
> > [    0.406389] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
> > [    0.406478] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
> > [    0.406570] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfebfffff]
> > [    0.406665] pci 0000:00:00.0: [8086:0044] type 00 class 0x060000
> > [    0.406679] DMAR: Disabling batched IOTLB flush on Ironlake
> > [    0.406838] pci 0000:00:02.0: [8086:0046] type 00 class 0x030000
> > [    0.406848] pci 0000:00:02.0: reg 0x10: [mem 0xf2000000-0xf23fffff 64bit]
> > [    0.406854] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff 64bit pref]
> > [    0.406859] pci 0000:00:02.0: reg 0x20: [io  0x1800-0x1807]
> > [    0.406975] pci 0000:00:16.0: [8086:3b64] type 00 class 0x078000
> > [    0.407004] pci 0000:00:16.0: reg 0x10: [mem 0xf2727800-0xf272780f 64bit]
> > [    0.407100] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
> > [    0.407200] pci 0000:00:19.0: [8086:10ea] type 00 class 0x020000
> > [    0.407225] pci 0000:00:19.0: reg 0x10: [mem 0xf2500000-0xf251ffff]
> > [    0.407236] pci 0000:00:19.0: reg 0x14: [mem 0xf2525000-0xf2525fff]
> > [    0.407248] pci 0000:00:19.0: reg 0x18: [io  0x1820-0x183f]
> > [    0.407334] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
> > [    0.407375] pci 0000:00:19.0: System wakeup disabled by ACPI
> > [    0.407516] pci 0000:00:1a.0: [8086:3b3c] type 00 class 0x0c0320
> > [    0.407541] pci 0000:00:1a.0: reg 0x10: [mem 0xf2728000-0xf27283ff]
> > [    0.407650] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
> > [    0.407691] pci 0000:00:1a.0: System wakeup disabled by ACPI
> > [    0.407833] pci 0000:00:1b.0: [8086:3b57] type 00 class 0x040300
> > [    0.407855] pci 0000:00:1b.0: reg 0x10: [mem 0xf2520000-0xf2523fff 64bit]
> > [    0.407962] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> > [    0.408015] pci 0000:00:1b.0: System wakeup disabled by ACPI
> > [    0.408152] pci 0000:00:1c.0: [8086:3b42] type 01 class 0x060400
> > [    0.408254] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> > [    0.408299] pci 0000:00:1c.0: System wakeup disabled by ACPI
> > [    0.408435] pci 0000:00:1c.1: [8086:3b44] type 01 class 0x060400
> > [    0.408537] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> > [    0.408582] pci 0000:00:1c.1: System wakeup disabled by ACPI
> > [    0.408720] pci 0000:00:1c.3: [8086:3b48] type 01 class 0x060400
> > [    0.408826] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
> > [    0.408872] pci 0000:00:1c.3: System wakeup disabled by ACPI
> > [    0.409017] pci 0000:00:1d.0: [8086:3b34] type 00 class 0x0c0320
> > [    0.409042] pci 0000:00:1d.0: reg 0x10: [mem 0xf2728400-0xf27287ff]
> > [    0.409150] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
> > [    0.409191] pci 0000:00:1d.0: System wakeup disabled by ACPI
> > [    0.409327] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
> > [    0.409465] pci 0000:00:1f.0: [8086:3b0f] type 00 class 0x060100
> > [    0.409643] pci 0000:00:1f.2: [8086:3b2f] type 00 class 0x010601
> > [    0.409670] pci 0000:00:1f.2: reg 0x10: [io  0x1860-0x1867]
> > [    0.409681] pci 0000:00:1f.2: reg 0x14: [io  0x1814-0x1817]
> > [    0.409692] pci 0000:00:1f.2: reg 0x18: [io  0x1818-0x181f]
> > [    0.409703] pci 0000:00:1f.2: reg 0x1c: [io  0x1810-0x1813]
> > [    0.409714] pci 0000:00:1f.2: reg 0x20: [io  0x1840-0x185f]
> > [    0.409725] pci 0000:00:1f.2: reg 0x24: [mem 0xf2727000-0xf27277ff]
> > [    0.409792] pci 0000:00:1f.2: PME# supported from D3hot
> > [    0.409878] pci 0000:00:1f.3: [8086:3b30] type 00 class 0x0c0500
> > [    0.409899] pci 0000:00:1f.3: reg 0x10: [mem 0xf2728800-0xf27288ff 64bit]
> > [    0.409928] pci 0000:00:1f.3: reg 0x20: [io  0x1880-0x189f]
> > [    0.410031] pci 0000:00:1f.6: [8086:3b32] type 00 class 0x118000
> > [    0.410059] pci 0000:00:1f.6: reg 0x10: [mem 0xf2526000-0xf2526fff 64bit]
> > [    0.410281] pci 0000:00:1c.0: PCI bridge to [bus 02]
> > [    0.410477] pci 0000:03:00.0: [8086:4238] type 00 class 0x028000
> > [    0.410517] pci 0000:03:00.0: reg 0x10: [mem 0xf2400000-0xf2401fff 64bit]
> > [    0.410719] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
> > [    0.416808] pci 0000:00:1c.1: PCI bridge to [bus 03]
> > [    0.416902] pci 0000:00:1c.1:   bridge window [mem 0xf2400000-0xf24fffff]
> > [    0.418109] pci 0000:05:00.0: [1180:e822] type 00 class 0x080500
> > [    0.418127] pci 0000:05:00.0: MMC controller base frequency changed to 50Mhz.
> > [    0.418287] pci 0000:05:00.0: reg 0x10: [mem 0xf1f00000-0xf1f000ff]
> > [    0.418466] pci 0000:05:00.0: supports D1 D2
> > [    0.418468] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> > [    0.418618] pci 0000:05:00.1: [1180:e230] type 00 class 0x088000
> > [    0.418641] pci 0000:05:00.1: reg 0x10: [mem 0xf1f00400-0xf1f004ff]
> > [    0.418809] pci 0000:05:00.1: supports D1 D2
> > [    0.418810] pci 0000:05:00.1: PME# supported from D0 D1 D2 D3hot D3cold
> > [    0.424862] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
> > [    0.424957] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
> > [    0.424962] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
> > [    0.424970] pci 0000:00:1c.3:   bridge window [mem 0xf2800000-0xf28fffff 64bit pref]
> > [    0.425060] pci 0000:00:1e.0: PCI bridge to [bus 0e] (subtractive decode)
> > [    0.425161] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
> > [    0.425163] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
> > [    0.425165] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
> > [    0.425168] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
> > [    0.425170] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
> > [    0.425172] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
> > [    0.425174] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
> > [    0.426657] ACPI: Enabled 3 GPEs in block 00 to 3F
> > [    0.426887] ACPI : EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
> > [    0.427069] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> > [    0.427189] vgaarb: loaded
> > [    0.427264] vgaarb: bridge control possible 0000:00:02.0
> > [    0.427397] PCI: Using ACPI for IRQ routing
> > [    0.437523] PCI: pci_cache_line_size set to 64 bytes
> > [    0.437682] e820: reserve RAM buffer [mem 0x0009e800-0x0009ffff]
> > [    0.437685] e820: reserve RAM buffer [mem 0xbb27c000-0xbbffffff]
> > [    0.437687] e820: reserve RAM buffer [mem 0xbb35f000-0xbbffffff]
> > [    0.437690] e820: reserve RAM buffer [mem 0xbb46f000-0xbbffffff]
> > [    0.437692] e820: reserve RAM buffer [mem 0xbb717000-0xbbffffff]
> > [    0.437695] e820: reserve RAM buffer [mem 0xbb76b000-0xbbffffff]
> > [    0.437697] e820: reserve RAM buffer [mem 0xbb800000-0xbbffffff]
> > [    0.437856] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
> > [    0.438314] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
> > [    0.440426] Switched to clocksource hpet
> > [    0.442639] pnp: PnP ACPI init
> > [    0.442736] ACPI: bus type PNP registered
> > [    0.444030] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
> > [    0.444122] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
> > [    0.446695] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
> > [    0.446787] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
> > [    0.446876] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
> > [    0.446966] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
> > [    0.447057] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
> > [    0.447148] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
> > [    0.447240] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
> > [    0.447331] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
> > [    0.447421] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
> > [    0.447513] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
> > [    0.447604] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
> > [    0.447695] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
> > [    0.447787] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
> > [    0.448137] system 00:01: [io  0x164e-0x164f] has been reserved
> > [    0.448226] system 00:01: [io  0x1000-0x107f] could not be reserved
> > [    0.448315] system 00:01: [io  0x1180-0x11ff] has been reserved
> > [    0.448403] system 00:01: [io  0x0800-0x080f] has been reserved
> > [    0.448499] system 00:01: [io  0x15e0-0x15ef] has been reserved
> > [    0.448587] system 00:01: [io  0x1600-0x1641] has been reserved
> > [    0.448674] system 00:01: [io  0x1644-0x167f] could not be reserved
> > [    0.448763] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
> > [    0.448853] system 00:01: [mem 0xfeaff000-0xfeafffff] has been reserved
> > [    0.448943] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
> > [    0.449032] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
> > [    0.449122] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
> > [    0.449213] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
> > [    0.449303] system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
> > [    0.449393] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
> > [    0.449453] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
> > [    0.449464] pnp 00:03: [dma 4]
> > [    0.449489] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
> > [    0.449521] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
> > [    0.449565] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
> > [    0.449602] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
> > [    0.449640] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
> > [    0.449676] pnp 00:08: Plug and Play ACPI device, IDs LEN0015 PNP0f13 (active)
> > [    0.449999] pnp 00:09: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
> > [    0.450883] pnp: PnP ACPI: found 10 devices
> > [    0.450964] ACPI: bus type PNP unregistered
> > [    0.458318] pci 0000:00:1c.0: PCI bridge to [bus 02]
> > [    0.458416] pci 0000:00:1c.1: PCI bridge to [bus 03]
> > [    0.458503] pci 0000:00:1c.1:   bridge window [mem 0xf2400000-0xf24fffff]
> > [    0.458602] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
> > [    0.458687] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
> > [    0.458779] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
> > [    0.458872] pci 0000:00:1c.3:   bridge window [mem 0xf2800000-0xf28fffff 64bit pref]
> > [    0.458995] pci 0000:00:1e.0: PCI bridge to [bus 0e]
> > [    0.459091] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> > [    0.459093] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> > [    0.459096] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> > [    0.459098] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
> > [    0.459100] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
> > [    0.459101] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
> > [    0.459104] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xfebfffff]
> > [    0.459106] pci_bus 0000:03: resource 1 [mem 0xf2400000-0xf24fffff]
> > [    0.459108] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
> > [    0.459110] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
> > [    0.459112] pci_bus 0000:05: resource 2 [mem 0xf2800000-0xf28fffff 64bit pref]
> > [    0.459115] pci_bus 0000:0e: resource 4 [io  0x0000-0x0cf7]
> > [    0.459117] pci_bus 0000:0e: resource 5 [io  0x0d00-0xffff]
> > [    0.459119] pci_bus 0000:0e: resource 6 [mem 0x000a0000-0x000bffff]
> > [    0.459121] pci_bus 0000:0e: resource 7 [mem 0x000d0000-0x000d3fff]
> > [    0.459123] pci_bus 0000:0e: resource 8 [mem 0x000d4000-0x000d7fff]
> > [    0.459125] pci_bus 0000:0e: resource 9 [mem 0x000d8000-0x000dbfff]
> > [    0.459127] pci_bus 0000:0e: resource 10 [mem 0xc0000000-0xfebfffff]
> > [    0.459202] NET: Registered protocol family 2
> > [    0.459527] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
> > [    0.459757] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
> > [    0.459989] TCP: Hash tables configured (established 32768 bind 32768)
> > [    0.460107] TCP: reno registered
> > [    0.460192] UDP hash table entries: 2048 (order: 4, 65536 bytes)
> > [    0.460308] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
> > [    0.460516] NET: Registered protocol family 1
> > [    0.460618] pci 0000:00:02.0: Boot video device
> > [    0.460970] PCI: CLS 64 bytes, default 64
> > [    0.461019] Unpacking initramfs...
> > [    0.672088] Freeing initrd memory: 11452K (ffff880036992000 - ffff8800374c1000)
> > [    0.672304] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> > [    0.672394] software IO TLB [mem 0xb727c000-0xbb27c000] (64MB) mapped at [ffff8800b727c000-ffff8800bb27bfff]
> > [    0.672558] Simple Boot Flag at 0x35 set to 0x1
> > [    0.673220] futex hash table entries: 1024 (order: 4, 65536 bytes)
> > [    0.673339] audit: initializing netlink subsys (disabled)
> > [    0.673444] audit: type=2000 audit(1397721355.500:1): initialized
> > [    0.689119] bounce pool size: 64 pages
> > [    0.689203] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> > [    0.689502] VFS: Disk quotas dquot_6.5.2
> > [    0.689600] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> > [    0.689750] msgmni has been set to 7523
> > [    0.690130] alg: No test for stdrng (krng)
> > [    0.690245] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
> > [    0.690363] io scheduler noop registered
> > [    0.690443] io scheduler deadline registered
> > [    0.690542] io scheduler cfq registered (default)
> > [    0.691097] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> > [    0.691199] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> > [    0.691323] intel_idle: MWAIT substates: 0x1120
> > [    0.691324] intel_idle: v0.4 model 0x25
> > [    0.691325] intel_idle: lapic_timer_reliable_states 0xffffffff
> > [    0.691559] GHES: HEST is not enabled!
> > [    0.691701] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> > [    0.692341] Linux agpgart interface v0.103
> > [    0.692486] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
> > [    0.692652] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
> > [    0.693441] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
> > [    0.693769] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
> > [    0.694098] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> > [    0.697272] serio: i8042 KBD port at 0x60,0x64 irq 1
> > [    0.697370] serio: i8042 AUX port at 0x60,0x64 irq 12
> > [    0.697805] mousedev: PS/2 mouse device common for all mice
> > [    0.697948] rtc_cmos 00:06: RTC can wake from S4
> > [    0.698314] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
> > [    0.698446] rtc_cmos 00:06: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
> > [    0.698580] drop_monitor: Initializing network drop monitor service
> > [    0.698731] TCP: cubic registered
> > [    0.698919] NET: Registered protocol family 10
> > [    0.699265] mip6: Mobile IPv6
> > [    0.699343] NET: Registered protocol family 17
> > [    0.699446] Key type dns_resolver registered
> > [    0.699963] registered taskstats version 1
> > [    0.700909] rtc_cmos 00:06: setting system clock to 2014-04-17 07:55:56 UTC (1397721356)
> > [    0.701162] PM: Hibernation image not present or could not be loaded.
> > [    0.702192] Freeing unused kernel memory: 880K (ffffffff816a2000 - ffffffff8177e000)
> > [    0.702311] Write protecting the kernel read-only data: 6144k
> > [    0.703557] Freeing unused kernel memory: 400K (ffff88000139c000 - ffff880001400000)
> > [    0.706366] Freeing unused kernel memory: 488K (ffff880001586000 - ffff880001600000)
> > [    0.706972] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
> > [    0.724045] udevd[67]: starting version 175
> > [    0.746676] sdhci: Secure Digital Host Controller Interface driver
> > [    0.746760] sdhci: Copyright(c) Pierre Ossman
> > [    0.747132] sdhci-pci 0000:05:00.0: SDHCI controller found [1180:e822] (rev 1)
> > [    0.747498] sdhci-pci 0000:05:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
> > [    0.747655] mmc0: no vqmmc regulator found
> > [    0.747730] mmc0: no vmmc regulator found
> > [    0.747982] mmc0: SDHCI controller on PCI [0000:05:00.0] using DMA
> > [    0.750016] SCSI subsystem initialized
> > [    0.758195] libata version 3.00 loaded.
> > [    0.759056] ahci 0000:00:1f.2: version 3.0
> > [    0.759240] ahci 0000:00:1f.2: irq 40 for MSI/MSI-X
> > [    0.759285] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
> > [    0.759420] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x33 impl SATA mode
> > [    0.759532] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pmp pio slum part ems sxs apst 
> > [    0.765378] thermal LNXTHERM:00: registered as thermal_zone0
> > [    0.765470] ACPI: Thermal Zone [THM0] (48 C)
> > [    0.767682] pps_core: LinuxPPS API ver. 1 registered
> > [    0.767762] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> > [    0.767949] microcode: CPU0 sig=0x20652, pf=0x10, revision=0xd
> > [    0.768067] microcode: CPU0 sig=0x20652, pf=0x10, revision=0xd
> > [    0.768476] microcode: CPU0 updated to revision 0xe, date = 2013-06-26
> > [    0.768570] microcode: CPU1 sig=0x20652, pf=0x10, revision=0xd
> > [    0.768689] PTP clock support registered
> > [    0.769500] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
> > [    0.769583] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
> > [    0.770801] microcode: CPU1 sig=0x20652, pf=0x10, revision=0xd
> > [    0.771154] microcode: CPU1 updated to revision 0xe, date = 2013-06-26
> > [    0.771257] microcode: CPU2 sig=0x20652, pf=0x10, revision=0xd
> > [    0.771371] microcode: CPU2 sig=0x20652, pf=0x10, revision=0xd
> > [    0.771716] microcode: CPU2 updated to revision 0xe, date = 2013-06-26
> > [    0.771810] microcode: CPU3 sig=0x20652, pf=0x10, revision=0xd
> > [    0.771924] microcode: CPU3 sig=0x20652, pf=0x10, revision=0xd
> > [    0.772281] microcode: CPU3 updated to revision 0xe, date = 2013-06-26
> > [    0.773907] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> > [    0.782691] scsi0 : ahci
> > [    0.783155] scsi1 : ahci
> > [    0.783538] scsi2 : ahci
> > [    0.783912] scsi3 : ahci
> > [    0.784319] scsi4 : ahci
> > [    0.785341] scsi5 : ahci
> > [    0.785640] ata1: SATA max UDMA/133 abar m2048@0xf2727000 port 0xf2727100 irq 40
> > [    0.785763] ata2: SATA max UDMA/133 abar m2048@0xf2727000 port 0xf2727180 irq 40
> > [    0.785882] ata3: DUMMY
> > [    0.785962] ata4: DUMMY
> > [    0.786046] ata5: SATA max UDMA/133 abar m2048@0xf2727000 port 0xf2727300 irq 40
> > [    0.786166] ata6: SATA max UDMA/133 abar m2048@0xf2727000 port 0xf2727380 irq 40
> > [    0.786975] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
> > [    0.787127] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
> > [    0.971516] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:26:2d:fc:e4:1e
> > [    0.971642] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
> > [    0.971800] e1000e 0000:00:19.0 eth0: MAC: 9, PHY: 10, PBA No: A002FF-0FF
> > [    1.277048] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > [    1.277578] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> > [    1.277585] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> > [    1.277787] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
> > [    1.277792] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> > [    1.278163] ata1.00: ATA-8: TOSHIBA THNS128GG4BAAA-NonFDE, AGLA0203, max UDMA/100
> > [    1.278279] ata1.00: 250069680 sectors, multi 16: LBA48 
> > [    1.278840] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> > [    1.278846] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> > [    1.279083] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
> > [    1.279088] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> > [    1.279446] ata1.00: configured for UDMA/100
> > [    1.279806] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA THNS128G AGLA PQ: 0 ANSI: 5
> > [    1.673280] tsc: Refined TSC clocksource calibration: 2393.999 MHz
> > [    1.773352] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> > [    1.779127] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
> > [    1.780020] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
> > [    1.783787] ata2.00: ATAPI: HL-DT-ST DVDRAM GU10N, MX05, max UDMA/133
> > [    1.790207] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
> > [    1.791104] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
> > [    1.794931] ata2.00: configured for UDMA/133
> > [    1.800488] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GU10N     MX05 PQ: 0 ANSI: 5
> > [    2.125573] ata5: SATA link down (SStatus 0 SControl 300)
> > [    2.445770] ata6: SATA link down (SStatus 0 SControl 300)
> > [    2.455364] sd 0:0:0:0: [sda] 250069680 512-byte logical blocks: (128 GB/119 GiB)
> > [    2.455680] sd 0:0:0:0: [sda] Write Protect is off
> > [    2.455770] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> > [    2.455836] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> > [    2.456633]  sda: sda1 sda2 sda3
> > [    2.457121] sd 0:0:0:0: [sda] Attached SCSI disk
> > [    2.464896] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
> > [    2.465015] cdrom: Uniform CD-ROM driver Revision: 3.20
> > [    2.465351] sr 1:0:0:0: Attached scsi CD-ROM sr0
> > [    2.467593] sd 0:0:0:0: Attached scsi generic sg0 type 0
> > [    2.467798] sr 1:0:0:0: Attached scsi generic sg1 type 5
> > [    2.601823] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
> > [    2.674019] Switched to clocksource tsc
> > [    2.848686] udevd[405]: starting version 175
> > [    2.913420] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input2
> > [    2.914533] ACPI: Lid Switch [LID]
> > [    2.914779] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input3
> > [    2.914886] ACPI: Sleep Button [SLPB]
> > [    2.915122] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
> > [    2.915223] ACPI: Power Button [PWRF]
> > [    2.920487] ACPI: bus type USB registered
> > [    2.920610] usbcore: registered new interface driver usbfs
> > [    2.920703] usbcore: registered new interface driver hub
> > [    2.922668] usbcore: registered new device driver usb
> > [    2.927255] cfg80211: Calling CRDA to update world regulatory domain
> > [    2.927379] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> > [    2.928002] ehci-pci: EHCI PCI platform driver
> > [    2.928273] ehci-pci 0000:00:1a.0: EHCI Host Controller
> > [    2.928358] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
> > [    2.928479] ehci-pci 0000:00:1a.0: debug port 2
> > [    2.932483] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
> > [    2.936391] wmi: Mapper loaded
> > [    2.937702] Intel(R) Wireless WiFi driver for Linux, in-tree:
> > [    2.937781] Copyright(c) 2003- 2014 Intel Corporation
> > [    2.938023] iwlwifi 0000:03:00.0: can't disable ASPM; OS doesn't have ASPM control
> > [    2.938188] iwlwifi 0000:03:00.0: irq 42 for MSI/MSI-X
> > [    2.939573] ehci-pci 0000:00:1a.0: irq 23, io mem 0xf2728000
> > [    2.940311] iwlwifi 0000:03:00.0: Direct firmware load failed with error -2
> > [    2.940395] iwlwifi 0000:03:00.0: Falling back to user helper
> > [    2.949999] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
> > [    2.950142] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> > [    2.950226] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> > [    2.950329] usb usb1: Product: EHCI Host Controller
> > [    2.950406] usb usb1: Manufacturer: Linux 3.15.0-rc1+ ehci_hcd
> > [    2.950484] usb usb1: SerialNumber: 0000:00:1a.0
> > [    2.953452] [drm] Initialized drm 1.1.0 20060810
> > [    2.954178] hub 1-0:1.0: USB hub found
> > [    2.954303] hub 1-0:1.0: 3 ports detected
> > [    2.954783] ehci-pci 0000:00:1d.0: EHCI Host Controller
> > [    2.954896] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
> > [    2.955165] ehci-pci 0000:00:1d.0: debug port 2
> > [    2.959229] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
> > [    2.959441] ehci-pci 0000:00:1d.0: irq 19, io mem 0xf2728400
> > [    2.964701] tpm_tis 00:09: 1.2 TPM (device-id 0x0, rev-id 78)
> > [    2.970074] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
> > [    2.970308] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> > [    2.970411] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> > [    2.970525] usb usb2: Product: EHCI Host Controller
> > [    2.970650] usb usb2: Manufacturer: Linux 3.15.0-rc1+ ehci_hcd
> > [    2.970763] usb usb2: SerialNumber: 0000:00:1d.0
> > [    2.971159] hub 2-0:1.0: USB hub found
> > [    2.971280] hub 2-0:1.0: 3 ports detected
> > [    2.971677] ACPI Warning: SystemIO range 0x0000000000001028-0x000000000000102f conflicts with OpRegion 0x0000000000001000-0x000000000000107f (\_SB_.PCI0.LPC_.PMIO) (20140214/utaddress-258)
> > [    2.971927] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> > [    2.972251] ACPI Warning: SystemIO range 0x00000000000011c0-0x00000000000011cf conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20140214/utaddress-258)
> > [    2.972502] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> > [    2.972694] ACPI Warning: SystemIO range 0x00000000000011b0-0x00000000000011bf conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20140214/utaddress-258)
> > [    2.972961] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> > [    2.973086] ACPI Warning: SystemIO range 0x0000000000001180-0x00000000000011af conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20140214/utaddress-258)
> > [    2.973345] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> > [    2.973454] lpc_ich: Resource conflict(s) found affecting gpio_ich
> > [    2.974097] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
> > [    2.974739] ACPI: Battery Slot [BAT0] (battery present)
> > [    2.975226] intel ips 0000:00:1f.6: CPU TDP doesn't match expected value (found 25, expected 29)
> > [    2.975481] intel ips 0000:00:1f.6: failed to get i915 symbols, graphics turbo disabled until i915 loads
> > [    2.976709] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 90
> > [    2.978828] ACPI: AC Adapter [AC] (on-line)
> > [    2.978960] [drm] Memory usable by graphics device = 2048M
> > [    2.994069] input: PC Speaker as /devices/platform/pcspkr/input/input6
> > [    3.001094] SSE version of gcm_enc/dec engaged.
> > [    3.017300] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
> > [    3.026084] tpm_tis 00:09: TPM is disabled/deactivated (0x6)
> > [    3.034186] i915 0000:00:02.0: irq 43 for MSI/MSI-X
> > [    3.034202] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
> > [    3.034283] [drm] Driver supports precise vblank timestamp query.
> > [    3.034453] Non-volatile memory driver v1.3
> > [    3.034818] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> > [    3.038943] thinkpad_acpi: ThinkPad ACPI Extras v0.25
> > [    3.039022] thinkpad_acpi: http://ibm-acpi.sf.net/
> > [    3.039095] thinkpad_acpi: ThinkPad BIOS 6UET70WW (1.50 ), EC 6UHT33WW-1.14
> > [    3.039211] thinkpad_acpi: Lenovo ThinkPad T410s, model 2912W1C
> > [    3.041463] iTCO_vendor_support: vendor-support=0
> > [    3.042266] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
> > [    3.042380] iTCO_wdt: Found a QS57 TCO device (Version=2, TCOBASE=0x1060)
> > [    3.042664] thinkpad_acpi: detected a 16-level brightness capable ThinkPad
> > [    3.043524] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> > [    3.050347] thinkpad_acpi: radio switch found; radios are enabled
> > [    3.050368] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
> > [    3.051031] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
> > [    3.051156] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
> > [    3.054394] iwlwifi 0000:03:00.0: Direct firmware load failed with error -2
> > [    3.054510] iwlwifi 0000:03:00.0: Falling back to user helper
> > [    3.058274] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
> > [    3.061468] thinkpad_acpi: rfkill switch tpacpi_wwan_sw: radio is unblocked
> > [    3.065291] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
> > [    3.065661] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
> > [    3.068324] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input7
> > [    3.111309] iwlwifi 0000:03:00.0: loaded firmware version 9.221.4.1 build 25532 op_mode iwldvm
> > [    3.112654] cfg80211: World regulatory domain updated:
> > [    3.112739] cfg80211:  DFS Master region: unset
> > [    3.112800] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
> > [    3.112994] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
> > [    3.113091] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm), (N/A)
> > [    3.113187] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm), (N/A)
> > [    3.113287] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
> > [    3.113385] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
> > [    3.128909] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
> > [    3.128991] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
> > [    3.129068] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
> > [    3.129156] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Ultimate-N 6300 AGN, REV=0x74
> > [    3.129320] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> > [    3.143169] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
> > [    3.150112] [drm] GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin 5
> > [    3.263018] fbcon: inteldrmfb (fb0) is primary device
> > [    3.266230] usb 1-1: new high-speed USB device number 2 using ehci-pci
> > [    3.398672] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
> > [    3.398676] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> > [    3.399096] hub 1-1:1.0: USB hub found
> > [    3.399247] hub 1-1:1.0: 6 ports detected
> > [    3.446632] psmouse serio1: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
> > [    3.510410] usb 2-1: new high-speed USB device number 2 using ehci-pci
> > [    3.643289] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
> > [    3.643292] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> > [    3.643779] hub 2-1:1.0: USB hub found
> > [    3.643953] hub 2-1:1.0: 8 ports detected
> > [    3.718836] usb 1-1.2: new full-speed USB device number 3 using ehci-pci
> > [    3.799535] [drm:ilk_display_irq_handler] *ERROR* Pipe A FIFO underrun
> > [    3.799541] [drm:ibx_irq_handler] *ERROR* PCH transcoder A FIFO underrun
> > [    3.809243] psmouse serio1: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
> > [    3.817580] usb 1-1.2: New USB device found, idVendor=17ef, idProduct=6047
> > [    3.817584] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> > [    3.817587] usb 1-1.2: Product: ThinkPad Compact USB Keyboard with TrackPoint
> > [    3.817590] usb 1-1.2: Manufacturer: Lenovo
> > [    3.826720] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input5
> > [    3.890895] usb 1-1.3: new full-speed USB device number 4 using ehci-pci
> > [    3.962586] [drm:intel_dp_start_link_train] *ERROR* failed to enable link training
> > [    3.965253] [drm:intel_dp_complete_link_train] *ERROR* failed to start channel equalization
> > [    3.984419] usb 1-1.3: New USB device found, idVendor=147e, idProduct=2016
> > [    3.984423] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> > [    3.984426] usb 1-1.3: Product: Biometric Coprocessor
> > [    3.984429] usb 1-1.3: Manufacturer: UPEK
> > [    4.030699] ------------[ cut here ]------------
> > [    4.030769] WARNING: CPU: 1 PID: 484 at drivers/gpu/drm/i915/intel_display.c:9755 intel_modeset_check_state+0x308/0x5f3 [i915]()
> > [    4.030771] encoder's hw state doesn't match sw tracking (expected 1, found 0)
> > [    4.030826] Modules linked in: arc4 iwldvm mac80211 snd_hda_intel(+) snd_hda_controller snd_hda_codec snd_hwdep coretemp snd_pcm_oss snd_mixer_oss mxm_wmi snd_pcm kvm_intel iTCO_wdt iTCO_vendor_support kvm thinkpad_acpi nvram snd_seq_midi snd_seq_midi_event snd_rawmidi ghash_clmulni_intel snd_seq snd_timer snd_seq_device aesni_intel aes_x86_64 ablk_helper cryptd lrw evdev gf128mul pcspkr glue_helper psmouse serio_raw snd i915(+) tpm_tis i2c_i801 tpm soundcore drm_kms_helper intel_ips ac battery parport_pc drm parport i2c_algo_bit i2c_core video lpc_ich iwlwifi mfd_core wmi ehci_pci ehci_hcd cfg80211 usbcore rfkill usb_common acpi_cpufreq button processor ext4 crc16 jbd2 mbcache sg sd_mod sr_mod crc_t10dif cdrom crct10dif_common crc32c_intel e1000e ptp microcode pps_core ahci libahci thermal thermal_sys libata scsi_mod sdhci_pci sdhci mmc_core
> > [    4.030834] CPU: 1 PID: 484 Comm: modprobe Not tainted 3.15.0-rc1+ #66
> > [    4.030835] Hardware name: LENOVO 2912W1C/2912W1C, BIOS 6UET70WW (1.50 ) 10/11/2012
> > [    4.030840]  0000000000000000 0000000000000009 ffffffff8138d427 ffff880036c69558
> > [    4.030843]  ffffffff810395e7 0000000000000246 ffffffffa0343ad6 ffff8800b5e0c000
> > [    4.030845]  ffff8800b5222000 ffff8800b6ddf000 0000000000000000 ffff8800b6ddf320
> > [    4.030846] Call Trace:
> > [    4.030855]  [<ffffffff8138d427>] ? dump_stack+0x41/0x51
> > [    4.030861]  [<ffffffff810395e7>] ? warn_slowpath_common+0x78/0x90
> > [    4.030917]  [<ffffffffa0343ad6>] ? intel_modeset_check_state+0x308/0x5f3 [i915]
> > [    4.030920]  [<ffffffff81039697>] ? warn_slowpath_fmt+0x45/0x4a
> > [    4.030976]  [<ffffffffa0343ad6>] ? intel_modeset_check_state+0x308/0x5f3 [i915]
> > [    4.031032]  [<ffffffffa0343dde>] ? intel_set_mode+0x1d/0x27 [i915]
> > [    4.031087]  [<ffffffffa034497f>] ? intel_crtc_set_config+0x717/0xa19 [i915]
> > [    4.031092]  [<ffffffff811cb0d5>] ? ida_get_new_above+0x174/0x18e
> > [    4.031108]  [<ffffffffa02a6b62>] ? drm_mode_set_config_internal+0x48/0xc0 [drm]
> > [    4.031115]  [<ffffffffa0238c92>] ? drm_fb_helper_restore_fbdev_mode+0x8f/0xa8 [drm_kms_helper]
> > [    4.031121]  [<ffffffffa0239f48>] ? drm_fb_helper_set_par+0x44/0xfc [drm_kms_helper]
> > [    4.031125]  [<ffffffff81213913>] ? fbcon_init+0x2ff/0x408
> > [    4.031129]  [<ffffffff81262206>] ? visual_init+0xaf/0x102
> > [    4.031133]  [<ffffffff812638cd>] ? do_bind_con_driver+0x171/0x286
> > [    4.031136]  [<ffffffff81263b14>] ? do_take_over_console+0x132/0x162
> > [    4.031139]  [<ffffffff81210248>] ? do_fbcon_takeover+0x54/0x97
> > [    4.031143]  [<ffffffff81394365>] ? notifier_call_chain+0x2e/0x59
> > [    4.031148]  [<ffffffff810553af>] ? __blocking_notifier_call_chain+0x43/0x5d
> > [    4.031152]  [<ffffffff81209932>] ? register_framebuffer+0x23a/0x296
> > [    4.031159]  [<ffffffffa0239da0>] ? drm_fb_helper_initial_config+0x3ad/0x464 [drm_kms_helper]
> > [    4.031217]  [<ffffffffa033111a>] ? gen5_write32+0x39/0x60 [i915]
> > [    4.031284]  [<ffffffffa0330fb5>] ? gen5_read32+0x55/0x5f [i915]
> > [    4.031352]  [<ffffffffa033111a>] ? gen5_write32+0x39/0x60 [i915]
> > [    4.031437]  [<ffffffffa0367866>] ? i915_driver_load+0xb70/0xded [i915]
> > [    4.031446]  [<ffffffff811cc9cf>] ? kobject_uevent_env+0x486/0x4c8
> > [    4.031457]  [<ffffffff811cc9cf>] ? kobject_uevent_env+0x486/0x4c8
> > [    4.031464]  [<ffffffff8127dfe4>] ? get_device+0x10/0x1c
> > [    4.031469]  [<ffffffff8138216a>] ? klist_add_tail+0x1d/0x44
> > [    4.031474]  [<ffffffff8127f896>] ? device_add+0x4f5/0x506
> > [    4.031495]  [<ffffffffa02a50e7>] ? drm_sysfs_device_add+0xcd/0x105 [drm]
> > [    4.031497] hidraw: raw HID events driver (C) Jiri Kosina
> > [    4.031515]  [<ffffffffa02a23e6>] ? drm_dev_register+0x74/0xe6 [drm]
> > [    4.031537]  [<ffffffffa02a453e>] ? drm_get_pci_dev+0xfc/0x1b9 [drm]
> > [    4.031547]  [<ffffffff81288568>] ? __pm_runtime_resume+0x60/0x6f
> > [    4.031554]  [<ffffffff811f29e1>] ? local_pci_probe+0x35/0x7a
> > [    4.031561]  [<ffffffff81281a9c>] ? driver_probe_device+0x1b3/0x1b3
> > [    4.031565]  [<ffffffff811f2af7>] ? pci_device_probe+0xd1/0xf5
> > [    4.031573]  [<ffffffff8128197b>] ? driver_probe_device+0x92/0x1b3
> > [    4.031578]  [<ffffffff81281aef>] ? __driver_attach+0x53/0x73
> > [    4.031583]  [<ffffffff81280246>] ? bus_for_each_dev+0x4e/0x7f
> > [    4.031589]  [<ffffffff812811fc>] ? bus_add_driver+0xe7/0x1cb
> > [    4.031594]  [<ffffffff81282036>] ? driver_register+0x82/0xb5
> > [    4.031604]  [<ffffffffa03a4000>] ? 0xffffffffa03a3fff
> > [    4.031609]  [<ffffffff81000296>] ? do_one_initcall+0x78/0xfa
> > [    4.031616]  [<ffffffffa03a4000>] ? 0xffffffffa03a3fff
> > [    4.031622]  [<ffffffff81030306>] ? change_page_attr_set+0x23/0x28
> > [    4.031627]  [<ffffffff810553bb>] ? __blocking_notifier_call_chain+0x4f/0x5d
> > [    4.031636]  [<ffffffffa03a4000>] ? 0xffffffffa03a3fff
> > [    4.031642]  [<ffffffff8108cfd6>] ? load_module+0x1a7d/0x1d63
> > [    4.031646]  [<ffffffff8108a252>] ? show_initstate+0x41/0x41
> > [    4.031654]  [<ffffffff81391862>] ? page_fault+0x22/0x30
> > [    4.031660]  [<ffffffff8108d34c>] ? SyS_init_module+0x90/0x9b
> > [    4.031667]  [<ffffffff81397af5>] ? sysenter_dispatch+0x7/0x1a
> > [    4.031670] ---[ end trace 458fdb8d9de23a07 ]---
> > [    4.031727] [drm:intel_pipe_config_compare] *ERROR* mismatch in has_dp_encoder (expected 1, found 0)
> > [    4.031729] ------------[ cut here ]------------
> > [    4.031798] WARNING: CPU: 1 PID: 484 at drivers/gpu/drm/i915/intel_display.c:9828 check_crtc_state+0x7ef/0x827 [i915]()
> > [    4.031799] pipe state doesn't match!
> > [    4.031870] Modules linked in: hid arc4 iwldvm mac80211 snd_hda_intel(+) snd_hda_controller snd_hda_codec snd_hwdep coretemp snd_pcm_oss snd_mixer_oss mxm_wmi snd_pcm kvm_intel iTCO_wdt iTCO_vendor_support kvm thinkpad_acpi nvram snd_seq_midi snd_seq_midi_event snd_rawmidi ghash_clmulni_intel snd_seq snd_timer snd_seq_device aesni_intel aes_x86_64 ablk_helper cryptd lrw evdev gf128mul pcspkr glue_helper psmouse serio_raw snd i915(+) tpm_tis i2c_i801 tpm soundcore drm_kms_helper intel_ips ac battery parport_pc drm parport i2c_algo_bit i2c_core video lpc_ich iwlwifi mfd_core wmi ehci_pci ehci_hcd cfg80211 usbcore rfkill usb_common acpi_cpufreq button processor ext4 crc16 jbd2 mbcache sg sd_mod sr_mod crc_t10dif cdrom crct10dif_common crc32c_intel e1000e ptp microcode pps_core ahci libahci thermal thermal_sys libata scsi_mod sdhci_pci sdhci mmc_core
> > [    4.031881] CPU: 1 PID: 484 Comm: modprobe Tainted: G        W     3.15.0-rc1+ #66
> > [    4.031883] Hardware name: LENOVO 2912W1C/2912W1C, BIOS 6UET70WW (1.50 ) 10/11/2012
> > [    4.031888]  0000000000000000 0000000000000009 ffffffff8138d427 ffff880036c69298
> > [    4.031893]  ffffffff810395e7 ffff880036c69290 ffffffffa0338160 0000000000000000
> > [    4.031896]  ffff88003733b000 ffff8800b6ddf000 ffff880036c69328 ffff88003733b6e0
> > [    4.031897] Call Trace:
> > [    4.031904]  [<ffffffff8138d427>] ? dump_stack+0x41/0x51
> > [    4.031909]  [<ffffffff810395e7>] ? warn_slowpath_common+0x78/0x90
> > [    4.031983]  [<ffffffffa0338160>] ? check_crtc_state+0x7ef/0x827 [i915]
> > [    4.031989]  [<ffffffff81039697>] ? warn_slowpath_fmt+0x45/0x4a
> > [    4.032059]  [<ffffffffa0338160>] ? check_crtc_state+0x7ef/0x827 [i915]
> > [    4.032139]  [<ffffffffa0343b1f>] ? intel_modeset_check_state+0x351/0x5f3 [i915]
> > [    4.032211]  [<ffffffffa0343dde>] ? intel_set_mode+0x1d/0x27 [i915]
> > [    4.032268]  [<ffffffffa034497f>] ? intel_crtc_set_config+0x717/0xa19 [i915]
> > [    4.032272]  [<ffffffff811cb0d5>] ? ida_get_new_above+0x174/0x18e
> > [    4.032287]  [<ffffffffa02a6b62>] ? drm_mode_set_config_internal+0x48/0xc0 [drm]
> > [    4.032294]  [<ffffffffa0238c92>] ? drm_fb_helper_restore_fbdev_mode+0x8f/0xa8 [drm_kms_helper]
> > [    4.032300]  [<ffffffffa0239f48>] ? drm_fb_helper_set_par+0x44/0xfc [drm_kms_helper]
> > [    4.032303]  [<ffffffff81213913>] ? fbcon_init+0x2ff/0x408
> > [    4.032307]  [<ffffffff81262206>] ? visual_init+0xaf/0x102
> > [    4.032310]  [<ffffffff812638cd>] ? do_bind_con_driver+0x171/0x286
> > [    4.032313]  [<ffffffff81263b14>] ? do_take_over_console+0x132/0x162
> > [    4.032316]  [<ffffffff81210248>] ? do_fbcon_takeover+0x54/0x97
> > [    4.032319]  [<ffffffff81394365>] ? notifier_call_chain+0x2e/0x59
> > [    4.032323]  [<ffffffff810553af>] ? __blocking_notifier_call_chain+0x43/0x5d
> > [    4.032327]  [<ffffffff81209932>] ? register_framebuffer+0x23a/0x296
> > [    4.032333]  [<ffffffffa0239da0>] ? drm_fb_helper_initial_config+0x3ad/0x464 [drm_kms_helper]
> > [    4.032385]  [<ffffffffa033111a>] ? gen5_write32+0x39/0x60 [i915]
> > [    4.032436]  [<ffffffffa0330fb5>] ? gen5_read32+0x55/0x5f [i915]
> > [    4.032487]  [<ffffffffa033111a>] ? gen5_write32+0x39/0x60 [i915]
> > [    4.032549]  [<ffffffffa0367866>] ? i915_driver_load+0xb70/0xded [i915]
> > [    4.032553]  [<ffffffff811cc9cf>] ? kobject_uevent_env+0x486/0x4c8
> > [    4.032558]  [<ffffffff811cc9cf>] ? kobject_uevent_env+0x486/0x4c8
> > [    4.032563]  [<ffffffff8127dfe4>] ? get_device+0x10/0x1c
> > [    4.032566]  [<ffffffff8138216a>] ? klist_add_tail+0x1d/0x44
> > [    4.032569]  [<ffffffff8127f896>] ? device_add+0x4f5/0x506
> > [    4.032585]  [<ffffffffa02a50e7>] ? drm_sysfs_device_add+0xcd/0x105 [drm]
> > [    4.032599]  [<ffffffffa02a23e6>] ? drm_dev_register+0x74/0xe6 [drm]
> > [    4.032612]  [<ffffffffa02a453e>] ? drm_get_pci_dev+0xfc/0x1b9 [drm]
> > [    4.032616]  [<ffffffff81288568>] ? __pm_runtime_resume+0x60/0x6f
> > [    4.032620]  [<ffffffff811f29e1>] ? local_pci_probe+0x35/0x7a
> > [    4.032625]  [<ffffffff81281a9c>] ? driver_probe_device+0x1b3/0x1b3
> > [    4.032627]  [<ffffffff811f2af7>] ? pci_device_probe+0xd1/0xf5
> > [    4.032633]  [<ffffffff8128197b>] ? driver_probe_device+0x92/0x1b3
> > [    4.032637]  [<ffffffff81281aef>] ? __driver_attach+0x53/0x73
> > [    4.032641]  [<ffffffff81280246>] ? bus_for_each_dev+0x4e/0x7f
> > [    4.032645]  [<ffffffff812811fc>] ? bus_add_driver+0xe7/0x1cb
> > [    4.032650]  [<ffffffff81282036>] ? driver_register+0x82/0xb5
> > [    4.032656]  [<ffffffffa03a4000>] ? 0xffffffffa03a3fff
> > [    4.032659]  [<ffffffff81000296>] ? do_one_initcall+0x78/0xfa
> > [    4.032664]  [<ffffffffa03a4000>] ? 0xffffffffa03a3fff
> > [    4.032667]  [<ffffffff81030306>] ? change_page_attr_set+0x23/0x28
> > [    4.032670]  [<ffffffff810553bb>] ? __blocking_notifier_call_chain+0x4f/0x5d
> > [    4.032676]  [<ffffffffa03a4000>] ? 0xffffffffa03a3fff
> > [    4.032680]  [<ffffffff8108cfd6>] ? load_module+0x1a7d/0x1d63
> > [    4.032682]  [<ffffffff8108a252>] ? show_initstate+0x41/0x41
> > [    4.032688]  [<ffffffff81391862>] ? page_fault+0x22/0x30
> > [    4.032692]  [<ffffffff8108d34c>] ? SyS_init_module+0x90/0x9b
> > [    4.032697]  [<ffffffff81397af5>] ? sysenter_dispatch+0x7/0x1a
> > [    4.032699] ---[ end trace 458fdb8d9de23a08 ]---
> > [    4.040425] usbcore: registered new interface driver usbhid
> > [    4.040426] usbhid: USB HID core driver
> > [    4.042942] Console: switching to colour frame buffer device 180x56
> > [    4.045676] input: Lenovo ThinkPad Compact USB Keyboard with TrackPoint as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/0003:17EF:6047.0001/input/input8
> > [    4.045931] hid-generic 0003:17EF:6047.0001: input,hidraw0: USB HID v1.00 Keyboard [Lenovo ThinkPad Compact USB Keyboard with TrackPoint] on usb-0000:00:1a.0-1.2/input0
> > [    4.046369] input: Lenovo ThinkPad Compact USB Keyboard with TrackPoint as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.1/0003:17EF:6047.0002/input/input9
> > [    4.046641] hid-generic 0003:17EF:6047.0002: input,hiddev0,hidraw1: USB HID v1.00 Mouse [Lenovo ThinkPad Compact USB Keyboard with TrackPoint] on usb-0000:00:1a.0-1.2/input1
> > [    4.058775] usb 1-1.4: new full-speed USB device number 5 using ehci-pci
> > [    4.176862] usb 1-1.4: New USB device found, idVendor=0a5c, idProduct=217f
> > [    4.176864] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> > [    4.176866] usb 1-1.4: Product: Broadcom Bluetooth Device
> > [    4.176867] usb 1-1.4: Manufacturer: Broadcom Corp
> > [    4.176869] usb 1-1.4: SerialNumber: 78DD08B375C7
> > [    4.250898] usb 1-1.6: new high-speed USB device number 6 using ehci-pci
> > [    4.368990] usb 1-1.6: New USB device found, idVendor=17ef, idProduct=480d
> > [    4.368993] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> > [    4.368994] usb 1-1.6: Product: Integrated Camera
> > [    4.368996] usb 1-1.6: Manufacturer: Chicony Electronics Co., Ltd.
> > [    4.386499] random: nonblocking pool is initialized
> > [    4.391691] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
> > [    4.391693] i915 0000:00:02.0: registered panic notifier
> > [    4.400434] Bluetooth: Core ver 2.19
> > [    4.401884] NET: Registered protocol family 31
> > [    4.403352] Bluetooth: HCI device and connection manager initialized
> > [    4.404770] Bluetooth: HCI socket layer initialized
> > [    4.406610] Bluetooth: L2CAP socket layer initialized
> > [    4.408459] Bluetooth: SCO socket layer initialized
> > [    4.413267] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
> > [    4.420520] usbcore: registered new interface driver btusb
> > [    4.435897] acpi device:01: registered as cooling_device4
> > [    4.438496] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input10
> > [    4.441007] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> > [    4.443411] snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
> > [    4.451068] usb 2-1.4: new high-speed USB device number 3 using ehci-pci
> > [    4.458196] sound hdaudioC0D0: CX20585: BIOS auto-probing.
> > [    4.461103] sound hdaudioC0D0: autoconfig: line_outs=1 (0x1f/0x0/0x0/0x0/0x0) type:speaker
> > [    4.463346] sound hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
> > [    4.465529] sound hdaudioC0D0:    hp_outs=2 (0x1c/0x19/0x0/0x0/0x0)
> > [    4.467755] sound hdaudioC0D0:    mono: mono_out=0x0
> > [    4.469841] sound hdaudioC0D0:    inputs:
> > [    4.471911] sound hdaudioC0D0:      Mic=0x1b
> > [    4.474029] sound hdaudioC0D0:      Internal Mic=0x23
> > [    4.476248] sound hdaudioC0D0:      Dock Mic=0x1a
> > [    4.479524] sound hdaudioC0D0: Enable sync_write for stable communication
> > [    4.490952] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/sound/card0/hdaudioC0D0/input11
> > [    4.493522] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
> > [    4.496122] input: HDA Intel Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
> > [    4.498946] input: HDA Intel Dock Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
> > [    4.501598] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input15
> > [    4.504305] input: HDA Intel HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input16
> > [    4.506522] input: HDA Intel HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input17
> > [    4.508522] input: HDA Intel HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input18
> > [    4.545309] usb 2-1.4: config 1 has an invalid interface number: 1 but max is 0
> > [    4.548355] usb 2-1.4: config 1 has no interface number 0
> > [    4.553718] usb 2-1.4: New USB device found, idVendor=05c6, idProduct=9204
> > [    4.556846] usb 2-1.4: New USB device strings: Mfr=3, Product=2, SerialNumber=0
> > [    4.559960] usb 2-1.4: Product: Qualcomm Gobi 2000
> > [    4.563057] usb 2-1.4: Manufacturer: Qualcomm Incorporated
> > [    4.778813] usbcore: registered new interface driver usbserial
> > [    4.782379] usbcore: registered new interface driver usbserial_generic
> > [    4.785739] usbserial: USB Serial support registered for generic
> > [    4.791257] usbcore: registered new interface driver qcserial
> > [    4.794453] usbserial: USB Serial support registered for Qualcomm USB modem
> > [    4.797433] qcserial 2-1.4:1.1: Qualcomm USB modem converter detected
> > [    4.800431] usb 2-1.4: Qualcomm USB modem converter now attached to ttyUSB0
> > [    6.117297] EXT4-fs (sda3): re-mounted. Opts: (null)
> > [    6.174936] EXT4-fs (sda3): re-mounted. Opts: (null)
> > [    6.203362] loop: module loaded
> > [    6.678975] fuse init (API version 7.23)
> > [    7.233038] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
> > [    7.242806] [drm:intel_dp_start_link_train] *ERROR* too many full retries, give up
> > [    7.336718] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
> > [    7.336821] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> > [    7.338569] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> > [    7.341068] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1
> > [    7.562838] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> > [    7.565806] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1
> > [    7.684752] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> > [    7.944370] RPC: Registered named UNIX socket transport module.
> > [    7.947321] RPC: Registered udp transport module.
> > [    7.950316] RPC: Registered tcp transport module.
> > [    7.953303] RPC: Registered tcp NFSv4.1 backchannel transport module.
> > [    7.961347] FS-Cache: Loaded
> > [    7.975900] FS-Cache: Netfs 'nfs' registered for caching
> > [    7.989129] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> > [    8.177354] intel ips 0000:00:1f.6: i915 driver attached, reenabling gpu turbo
> > [    8.362065] NET: Registered protocol family 15
> > [    8.872718] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
> > [    8.875552] NFSD: starting 90-second grace period (net ffffffff8167f000)
> > [    9.096132] gre: GRE over IPv4 demultiplexor driver
> > [    9.099914] openvswitch: Open vSwitch switching datapath
> > [    9.308261] ip_tables: (C) 2000-2006 Netfilter Core Team
> > [   10.084042] postgres (4460): /proc/4460/oom_adj is deprecated, please use /proc/4460/oom_score_adj instead.
> > [   10.525199] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
> > [   10.528759] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> > [   13.448574] ------------[ cut here ]------------
> > [   13.448631] WARNING: CPU: 0 PID: 5212 at drivers/gpu/drm/i915/intel_display.c:860 ironlake_crtc_disable+0xd1/0x83a [i915]()
> > [   13.448633] pipe_off wait timed out
> > [   13.448635] Modules linked in: xt_tcpudp iptable_mangle xt_mark ip_tables x_tables openvswitch gre libcrc32c autofs4 deflate ctr twofish_generic twofish_x86_64_3way xts twofish_x86_64 twofish_common camellia_generic serpent_generic blowfish_generic blowfish_x86_64 blowfish_common cast5_generic cast_common des_generic cbc cmac xcbc rmd160 sha512_generic sha256_generic hmac crypto_null af_key xfrm_algo nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc fuse loop qcserial usb_wwan usbserial snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic ecb btusb bluetooth hid_generic usbhid hid arc4 iwldvm mac80211 snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep coretemp snd_pcm_oss snd_mixer_oss mxm_wmi snd_pcm kvm_intel iTCO_wdt iTCO_vendor_support kvm thinkpad_acpi nvram snd_seq_midi snd_seq_midi_event snd_rawmidi ghash_clmulni_intel snd_seq snd_timer snd_seq_device aesni_intel aes_x86_64 ablk_helper cryptd lrw evdev gf128mul pcspkr glue_helper psmouse serio_raw snd i915 tpm_tis i2c_i801 tpm soundcore drm_kms_helper intel_ips ac battery parport_pc drm parport i2c_algo_bit i2c_core video lpc_ich iwlwifi mfd_core wmi ehci_pci ehci_hcd cfg80211 usbcore rfkill usb_common acpi_cpufreq button processor ext4 crc16 jbd2 mbcache sg sd_mod sr_mod crc_t10dif cdrom crct10dif_common crc32c_intel e1000e ptp microcode pps_core ahci libahci thermal thermal_sys libata scsi_mod sdhci_pci sdhci mmc_core
> > [   13.448765] CPU: 0 PID: 5212 Comm: Xorg Tainted: G        W     3.15.0-rc1+ #66
> > [   13.448767] Hardware name: LENOVO 2912W1C/2912W1C, BIOS 6UET70WW (1.50 ) 10/11/2012
> > [   13.448770]  0000000000000000 0000000000000009 ffffffff8138d427 ffff880132b25ad8
> > [   13.448774]  ffffffff810395e7 00000000fffee7fd ffffffffa033b439 0000000000000000
> > [   13.448779]  ffff8800b5e0c000 0000000000000001 ffff88003733b000 ffff8800b6ddf000
> > [   13.448783] Call Trace:
> > [   13.448793]  [<ffffffff8138d427>] ? dump_stack+0x41/0x51
> > [   13.448800]  [<ffffffff810395e7>] ? warn_slowpath_common+0x78/0x90
> > [   13.448826]  [<ffffffffa033b439>] ? ironlake_crtc_disable+0xd1/0x83a [i915]
> > [   13.448831]  [<ffffffff81039697>] ? warn_slowpath_fmt+0x45/0x4a
> > [   13.448858]  [<ffffffffa033b439>] ? ironlake_crtc_disable+0xd1/0x83a [i915]
> > [   13.448881]  [<ffffffffa0335583>] ? intel_dump_pipe_config+0x17d/0x311 [i915]
> > [   13.448905]  [<ffffffffa0330fb5>] ? gen5_read32+0x55/0x5f [i915]
> > [   13.448930]  [<ffffffffa0341c7c>] ? __intel_set_mode+0xcfc/0x1193 [i915]
> > [   13.448955]  [<ffffffffa0343dce>] ? intel_set_mode+0xd/0x27 [i915]
> > [   13.448979]  [<ffffffffa034497f>] ? intel_crtc_set_config+0x717/0xa19 [i915]
> > [   13.448997]  [<ffffffffa02a6b62>] ? drm_mode_set_config_internal+0x48/0xc0 [drm]
> > [   13.449011]  [<ffffffffa02a97c7>] ? drm_mode_setcrtc+0x3f2/0x490 [drm]
> > [   13.449025]  [<ffffffffa029dfaa>] ? drm_ioctl+0x25c/0x3a7 [drm]
> > [   13.449039]  [<ffffffffa02a93d5>] ? drm_mode_setplane+0x329/0x329 [drm]
> > [   13.449045]  [<ffffffff812c7059>] ? sock_setsockopt+0x5c5/0x5e8
> > [   13.449062]  [<ffffffffa030e361>] ? i915_compat_ioctl+0x2d/0x34 [i915]
> > [   13.449069]  [<ffffffff81147566>] ? compat_SyS_ioctl+0x1c2/0xedc
> > [   13.449076]  [<ffffffff81397af5>] ? sysenter_dispatch+0x7/0x1a
> > [   13.449079] ---[ end trace 458fdb8d9de23a09 ]---
> > [   13.594913] [drm:ibx_irq_handler] *ERROR* PCH transcoder B FIFO underrun
> > [   16.981255] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
> > [   20.509650] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
> > [   20.509672] pci 0000:00:1e.0: PCI bridge to [bus 0e]
> > [   20.509705] agpgart-intel 0000:00:00.0: no hotplug settings from platform
> > [   20.509709] agpgart-intel 0000:00:00.0: using default PCI settings
> > [   20.509719] i915 0000:00:02.0: no hotplug settings from platform
> > [   20.509723] i915 0000:00:02.0: using default PCI settings
> > [   20.509732] pci 0000:00:16.0: no hotplug settings from platform
> > [   20.509736] pci 0000:00:16.0: using default PCI settings
> > [   20.509750] e1000e 0000:00:19.0: no hotplug settings from platform
> > [   20.509754] e1000e 0000:00:19.0: using default PCI settings
> > [   20.509768] ehci-pci 0000:00:1a.0: no hotplug settings from platform
> > [   20.509771] ehci-pci 0000:00:1a.0: using default PCI settings
> > [   20.509785] snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
> > [   20.509792] pcieport 0000:00:1c.0: no hotplug settings from platform
> > [   20.509799] pcieport 0000:00:1c.1: no hotplug settings from platform
> > [   20.509838] iwlwifi 0000:03:00.0: no hotplug settings from platform
> > [   20.509845] pcieport 0000:00:1c.3: no hotplug settings from platform
> > [   20.509910] sdhci-pci 0000:05:00.0: no hotplug settings from platform
> > [   20.509973] pci 0000:05:00.1: no hotplug settings from platform
> > [   20.509981] ehci-pci 0000:00:1d.0: no hotplug settings from platform
> > [   20.509984] ehci-pci 0000:00:1d.0: using default PCI settings
> > [   20.509998] pci 0000:00:1e.0: no hotplug settings from platform
> > [   20.510001] pci 0000:00:1e.0: using default PCI settings
> > [   20.510020] lpc_ich 0000:00:1f.0: no hotplug settings from platform
> > [   20.510023] lpc_ich 0000:00:1f.0: using default PCI settings
> > [   20.510038] ahci 0000:00:1f.2: no hotplug settings from platform
> > [   20.510041] ahci 0000:00:1f.2: using default PCI settings
> > [   20.510055] i801_smbus 0000:00:1f.3: no hotplug settings from platform
> > [   20.510059] i801_smbus 0000:00:1f.3: using default PCI settings
> > [   20.510073] intel ips 0000:00:1f.6: no hotplug settings from platform
> > [   20.510077] intel ips 0000:00:1f.6: using default PCI settings
> > [   21.889749] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
> > [   21.889771] pci 0000:00:1e.0: PCI bridge to [bus 0e]
> > [   21.889811] agpgart-intel 0000:00:00.0: no hotplug settings from platform
> > [   21.889818] agpgart-intel 0000:00:00.0: using default PCI settings
> > [   21.889833] i915 0000:00:02.0: no hotplug settings from platform
> > [   21.889838] i915 0000:00:02.0: using default PCI settings
> > [   21.889852] pci 0000:00:16.0: no hotplug settings from platform
> > [   21.889857] pci 0000:00:16.0: using default PCI settings
> > [   21.889876] e1000e 0000:00:19.0: no hotplug settings from platform
> > [   21.889882] e1000e 0000:00:19.0: using default PCI settings
> > [   21.889899] ehci-pci 0000:00:1a.0: no hotplug settings from platform
> > [   21.889905] ehci-pci 0000:00:1a.0: using default PCI settings
> > [   21.889924] snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
> > [   21.889935] pcieport 0000:00:1c.0: no hotplug settings from platform
> > [   21.889946] pcieport 0000:00:1c.1: no hotplug settings from platform
> > [   21.889990] iwlwifi 0000:03:00.0: no hotplug settings from platform
> > [   21.890001] pcieport 0000:00:1c.3: no hotplug settings from platform
> > [   21.890072] sdhci-pci 0000:05:00.0: no hotplug settings from platform
> > [   21.890141] pci 0000:05:00.1: no hotplug settings from platform
> > [   21.890152] ehci-pci 0000:00:1d.0: no hotplug settings from platform
> > [   21.890157] ehci-pci 0000:00:1d.0: using default PCI settings
> > [   21.890176] pci 0000:00:1e.0: no hotplug settings from platform
> > [   21.890182] pci 0000:00:1e.0: using default PCI settings
> > [   21.890208] lpc_ich 0000:00:1f.0: no hotplug settings from platform
> > [   21.890214] lpc_ich 0000:00:1f.0: using default PCI settings
> > [   21.890235] ahci 0000:00:1f.2: no hotplug settings from platform
> > [   21.890241] ahci 0000:00:1f.2: using default PCI settings
> > [   21.890260] i801_smbus 0000:00:1f.3: no hotplug settings from platform
> > [   21.890266] i801_smbus 0000:00:1f.3: using default PCI settings
> > [   21.890285] intel ips 0000:00:1f.6: no hotplug settings from platform
> > [   21.890291] intel ips 0000:00:1f.6: using default PCI settings
> > [   40.524035] ------------[ cut here ]------------
> > [   40.524100] WARNING: CPU: 3 PID: 5212 at drivers/gpu/drm/i915/intel_display.c:860 ironlake_crtc_disable+0xd1/0x83a [i915]()
> > [   40.524104] pipe_off wait timed out
> > [   40.524106] Modules linked in: xt_tcpudp iptable_mangle xt_mark ip_tables x_tables openvswitch gre libcrc32c autofs4 deflate ctr twofish_generic twofish_x86_64_3way xts twofish_x86_64 twofish_common camellia_generic serpent_generic blowfish_generic blowfish_x86_64 blowfish_common cast5_generic cast_common des_generic cbc cmac xcbc rmd160 sha512_generic sha256_generic hmac crypto_null af_key xfrm_algo nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc fuse loop qcserial usb_wwan usbserial snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic ecb btusb bluetooth hid_generic usbhid hid arc4 iwldvm mac80211 snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep coretemp snd_pcm_oss snd_mixer_oss mxm_wmi snd_pcm kvm_intel iTCO_wdt iTCO_vendor_support kvm thinkpad_acpi nvram snd_seq_midi snd_seq_midi_event snd_rawmidi ghash_clmulni_intel snd_seq snd_timer snd_seq_device aesni_intel aes_x86_64 ablk_helper cryptd lrw evdev gf128mul pcspkr glue_helper psmouse serio_raw snd i915 tpm_tis i2c_i801 tpm soundcore drm_kms_helper intel_ips ac battery parport_pc drm parport i2c_algo_bit i2c_core video lpc_ich iwlwifi mfd_core wmi ehci_pci ehci_hcd cfg80211 usbcore rfkill usb_common acpi_cpufreq button processor ext4 crc16 jbd2 mbcache sg sd_mod sr_mod crc_t10dif cdrom crct10dif_common crc32c_intel e1000e ptp microcode pps_core ahci libahci thermal thermal_sys libata scsi_mod sdhci_pci sdhci mmc_core
> > [   40.524258] CPU: 3 PID: 5212 Comm: Xorg Tainted: G        W     3.15.0-rc1+ #66
> > [   40.524261] Hardware name: LENOVO 2912W1C/2912W1C, BIOS 6UET70WW (1.50 ) 10/11/2012
> > [   40.524264]  0000000000000000 0000000000000009 ffffffff8138d427 ffff880132b25ad8
> > [   40.524270]  ffffffff810395e7 00000000ffff026a ffffffffa033b439 0000000000000000
> > [   40.524275]  ffff8800b5e0c000 0000000000000001 ffff88003733b000 ffff8800b6ddf000
> > [   40.524280] Call Trace:
> > [   40.524290]  [<ffffffff8138d427>] ? dump_stack+0x41/0x51
> > [   40.524298]  [<ffffffff810395e7>] ? warn_slowpath_common+0x78/0x90
> > [   40.524331]  [<ffffffffa033b439>] ? ironlake_crtc_disable+0xd1/0x83a [i915]
> > [   40.524336]  [<ffffffff81039697>] ? warn_slowpath_fmt+0x45/0x4a
> > [   40.524369]  [<ffffffffa033b439>] ? ironlake_crtc_disable+0xd1/0x83a [i915]
> > [   40.524398]  [<ffffffffa0335583>] ? intel_dump_pipe_config+0x17d/0x311 [i915]
> > [   40.524426]  [<ffffffffa0330fb5>] ? gen5_read32+0x55/0x5f [i915]
> > [   40.524457]  [<ffffffffa0341c7c>] ? __intel_set_mode+0xcfc/0x1193 [i915]
> > [   40.524487]  [<ffffffffa0343dce>] ? intel_set_mode+0xd/0x27 [i915]
> > [   40.524517]  [<ffffffffa034497f>] ? intel_crtc_set_config+0x717/0xa19 [i915]
> > [   40.524537]  [<ffffffffa02a6b62>] ? drm_mode_set_config_internal+0x48/0xc0 [drm]
> > [   40.524555]  [<ffffffffa02a97c7>] ? drm_mode_setcrtc+0x3f2/0x490 [drm]
> > [   40.524572]  [<ffffffffa029dfaa>] ? drm_ioctl+0x25c/0x3a7 [drm]
> > [   40.524590]  [<ffffffffa02a93d5>] ? drm_mode_setplane+0x329/0x329 [drm]
> > [   40.524596]  [<ffffffff81053f74>] ? enqueue_hrtimer+0x36/0x6d
> > [   40.524617]  [<ffffffffa030e361>] ? i915_compat_ioctl+0x2d/0x34 [i915]
> > [   40.524624]  [<ffffffff81147566>] ? compat_SyS_ioctl+0x1c2/0xedc
> > [   40.524630]  [<ffffffff81007e37>] ? read_tsc+0x5/0x14
> > [   40.524636]  [<ffffffff81051055>] ? posix_ktime_get_ts+0x9/0xd
> > [   40.524641]  [<ffffffff81051cb5>] ? SyS_clock_gettime+0x34/0x52
> > [   40.524646]  [<ffffffff81002797>] ? math_state_restore+0xc3/0xe2
> > [   40.524653]  [<ffffffff81397af5>] ? sysenter_dispatch+0x7/0x1a
> > [   40.524656] ---[ end trace 458fdb8d9de23a0a ]---
> > [   40.662236] [drm:ibx_irq_handler] *ERROR* PCH transcoder B FIFO underrun
> > [   72.155793] ------------[ cut here ]------------
> > [   72.155847] WARNING: CPU: 0 PID: 5212 at drivers/gpu/drm/i915/intel_display.c:860 ironlake_crtc_disable+0xd1/0x83a [i915]()
> > [   72.155849] pipe_off wait timed out
> > [   72.155852] Modules linked in: xt_tcpudp iptable_mangle xt_mark ip_tables x_tables openvswitch gre libcrc32c autofs4 deflate ctr twofish_generic twofish_x86_64_3way xts twofish_x86_64 twofish_common camellia_generic serpent_generic blowfish_generic blowfish_x86_64 blowfish_common cast5_generic cast_common des_generic cbc cmac xcbc rmd160 sha512_generic sha256_generic hmac crypto_null af_key xfrm_algo nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc fuse loop qcserial usb_wwan usbserial snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic ecb btusb bluetooth hid_generic usbhid hid arc4 iwldvm mac80211 snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep coretemp snd_pcm_oss snd_mixer_oss mxm_wmi snd_pcm kvm_intel iTCO_wdt iTCO_vendor_support kvm thinkpad_acpi nvram snd_seq_midi snd_seq_midi_event snd_rawmidi ghash_clmulni_intel snd_seq snd_timer snd_seq_device aesni_intel aes_x86_64 ablk_helper cryptd lrw evdev gf128mul pcspkr glue_helper psmouse serio_raw snd i915 tpm_tis i2c_i801 tpm soundcore drm_kms_helper intel_ips ac battery parport_pc drm parport i2c_algo_bit i2c_core video lpc_ich iwlwifi mfd_core wmi ehci_pci ehci_hcd cfg80211 usbcore rfkill usb_common acpi_cpufreq button processor ext4 crc16 jbd2 mbcache sg sd_mod sr_mod crc_t10dif cdrom crct10dif_common crc32c_intel e1000e ptp microcode pps_core ahci libahci thermal thermal_sys libata scsi_mod sdhci_pci sdhci mmc_core
> > [   72.155978] CPU: 0 PID: 5212 Comm: Xorg Tainted: G        W     3.15.0-rc1+ #66
> > [   72.155981] Hardware name: LENOVO 2912W1C/2912W1C, BIOS 6UET70WW (1.50 ) 10/11/2012
> > [   72.155983]  0000000000000000 0000000000000009 ffffffff8138d427 ffff880132b25c78
> > [   72.155988]  ffffffff810395e7 00000000ffff214d ffffffffa033b439 0000000000000000
> > [   72.155992]  ffff8800b5e0c000 0000000000000001 ffff88003733b000 ffff8800b6ddf000
> > [   72.155997] Call Trace:
> > [   72.156006]  [<ffffffff8138d427>] ? dump_stack+0x41/0x51
> > [   72.156013]  [<ffffffff810395e7>] ? warn_slowpath_common+0x78/0x90
> > [   72.156040]  [<ffffffffa033b439>] ? ironlake_crtc_disable+0xd1/0x83a [i915]
> > [   72.156044]  [<ffffffff81039697>] ? warn_slowpath_fmt+0x45/0x4a
> > [   72.156071]  [<ffffffffa033b439>] ? ironlake_crtc_disable+0xd1/0x83a [i915]
> > [   72.156096]  [<ffffffffa0340b66>] ? intel_crtc_update_dpms+0x53/0x62 [i915]
> > [   72.156120]  [<ffffffffa0344cc0>] ? intel_connector_dpms+0x3f/0x4a [i915]
> > [   72.156136]  [<ffffffffa02aa8da>] ? drm_mode_obj_set_property_ioctl+0x159/0x1e3 [drm]
> > [   72.156152]  [<ffffffffa02aa990>] ? drm_mode_connector_property_set_ioctl+0x2c/0x31 [drm]
> > [   72.156164]  [<ffffffffa029dfaa>] ? drm_ioctl+0x25c/0x3a7 [drm]
> > [   72.156178]  [<ffffffffa02aa964>] ? drm_mode_obj_set_property_ioctl+0x1e3/0x1e3 [drm]
> > [   72.156184]  [<ffffffff8110c671>] ? do_sync_read+0x4b/0x6e
> > [   72.156201]  [<ffffffffa030e361>] ? i915_compat_ioctl+0x2d/0x34 [i915]
> > [   72.156207]  [<ffffffff81147566>] ? compat_SyS_ioctl+0x1c2/0xedc
> > [   72.156212]  [<ffffffff81007e37>] ? read_tsc+0x5/0x14
> > [   72.156217]  [<ffffffff81051055>] ? posix_ktime_get_ts+0x9/0xd
> > [   72.156222]  [<ffffffff81051cb5>] ? SyS_clock_gettime+0x34/0x52
> > [   72.156226]  [<ffffffff81002797>] ? math_state_restore+0xc3/0xe2
> > [   72.156231]  [<ffffffff81397af5>] ? sysenter_dispatch+0x7/0x1a
> > [   72.156234] ---[ end trace 458fdb8d9de23a0b ]---
> > [   78.094586] [drm:ibx_irq_handler] *ERROR* PCH transcoder B FIFO underrun
> >
> > Here are some more informations about the system:
> >
> > (lenovo) [~] lspci
> > 00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller (rev 02)
> > 00:02.0 VGA compatible controller: Intel Corporation Core Processor Integrated Graphics Controller (rev 02)
> > 00:16.0 Communication controller: Intel Corporation 5 Series/3400 Series Chipset HECI Controller (rev 06)
> > 00:19.0 Ethernet controller: Intel Corporation 82577LM Gigabit Network Connection (rev 06)
> > 00:1a.0 USB controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 06)
> > 00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset High Definition Audio (rev 06)
> > 00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 1 (rev 06)
> > 00:1c.1 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 2 (rev 06)
> > 00:1c.3 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 4 (rev 06)
> > 00:1d.0 USB controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 06)
> > 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a6)
> > 00:1f.0 ISA bridge: Intel Corporation 5 Series/3400 Series Chipset LPC Interface Controller (rev 06)
> > 00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series Chipset 6 port SATA AHCI Controller (rev 06)
> > 00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus Controller (rev 06)
> > 00:1f.6 Signal processing controller: Intel Corporation 5 Series/3400 Series Chipset Thermal Subsystem (rev 06)
> > 03:00.0 Network controller: Intel Corporation Centrino Ultimate-N 6300 (rev 35)
> > 05:00.0 SD Host controller: Ricoh Co Ltd MMC/SD Host Controller (rev 01)
> > 05:00.1 System peripheral: Ricoh Co Ltd R5U2xx (R5U230 / R5U231 / R5U241) [Memory Stick Host Controller] (rev 01)
> > ff:00.0 Host bridge: Intel Corporation Core Processor QuickPath Architecture Generic Non-core Registers (rev 02)
> > ff:00.1 Host bridge: Intel Corporation Core Processor QuickPath Architecture System Address Decoder (rev 02)
> > ff:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 02)
> > ff:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0 (rev 02)
> > ff:02.2 Host bridge: Intel Corporation Core Processor Reserved (rev 02)
> > ff:02.3 Host bridge: Intel Corporation Core Processor Reserved (rev 02)
> > (lenovo) [~] lspci -n
> > 00:00.0 0600: 8086:0044 (rev 02)
> > 00:02.0 0300: 8086:0046 (rev 02)
> > 00:16.0 0780: 8086:3b64 (rev 06)
> > 00:19.0 0200: 8086:10ea (rev 06)
> > 00:1a.0 0c03: 8086:3b3c (rev 06)
> > 00:1b.0 0403: 8086:3b57 (rev 06)
> > 00:1c.0 0604: 8086:3b42 (rev 06)
> > 00:1c.1 0604: 8086:3b44 (rev 06)
> > 00:1c.3 0604: 8086:3b48 (rev 06)
> > 00:1d.0 0c03: 8086:3b34 (rev 06)
> > 00:1e.0 0604: 8086:2448 (rev a6)
> > 00:1f.0 0601: 8086:3b0f (rev 06)
> > 00:1f.2 0106: 8086:3b2f (rev 06)
> > 00:1f.3 0c05: 8086:3b30 (rev 06)
> > 00:1f.6 1180: 8086:3b32 (rev 06)
> > 03:00.0 0280: 8086:4238 (rev 35)
> > 05:00.0 0805: 1180:e822 (rev 01)
> > 05:00.1 0880: 1180:e230 (rev 01)
> > ff:00.0 0600: 8086:2c62 (rev 02)
> > ff:00.1 0600: 8086:2d01 (rev 02)
> > ff:02.0 0600: 8086:2d10 (rev 02)
> > ff:02.1 0600: 8086:2d11 (rev 02)
> > ff:02.2 0600: 8086:2d12 (rev 02)
> > ff:02.3 0600: 8086:2d13 (rev 02)
> >
> > This is where I wanted to get (and get with an older kernel):
> >
> > (lenovo) [~] xrandr
> > Screen 0: minimum 320 x 200, current 1200 x 1920, maximum 8192 x 8192
> > LVDS1 connected (normal left inverted right x axis y axis)
> >    1440x900       60.0 +   59.9     50.0
> >    1360x768       59.8     60.0
> >    1152x864       60.0
> >    1024x768       60.0
> >    800x600        60.3     56.2
> >    640x480        59.9
> > VGA1 disconnected (normal left inverted right x axis y axis)
> > HDMI1 disconnected (normal left inverted right x axis y axis)
> > DP1 connected 1200x1920+0+0 left (normal left inverted right x axis y axis) 518mm x 324mm
> >    1920x1200      60.0*+
> >    1920x1080      50.0     60.0     25.0     30.0
> >    1600x1200      60.0
> >    1680x1050      60.0
> >    1400x1050      60.0
> >    1280x1024      60.0
> >    1440x900       59.9
> >    1280x960       60.0
> >    1360x768       60.0
> >    1280x800       59.8
> >    1280x768       59.9
> >    1280x720       50.0     60.0
> >    1024x768       60.0
> >    1440x480       30.0
> >    800x600        60.3     56.2
> >    720x576        50.0
> >    848x480        60.0
> >    720x480        59.9
> >    640x480        60.0     59.9     59.9
> > HDMI2 disconnected (normal left inverted right x axis y axis)
> > HDMI3 disconnected (normal left inverted right x axis y axis)
> > DP2 disconnected (normal left inverted right x axis y axis)
> > DP3 disconnected (normal left inverted right x axis y axis)
> >
> > Cheers,
> >         Thomas
> 
> -- 
> Jani Nikula, Intel Open Source Technology Center

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
