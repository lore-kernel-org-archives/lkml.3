Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab3IYPcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 11:32:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754675Ab3IYPcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 11:32:33 -0400
Date: Wed, 25 Sep 2013 18:34:38 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Dave Airlie <airlied@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: Fwd: linux-next: Tree for Jul 1 [ drm-intel-next: Several
 call-traces ]
Message-ID: <20130925153438.GA2395@redhat.com>
References: <CA+icZUXyizuCR3YDfFXD5hCkgycFYGzMHaJxg=m9UackT7uzGQ@mail.gmail.com>
 <CAKMK7uFzwiztE8H1rvSDWQmw08JGoKdnTs5BYqxdrHwb=pK50A@mail.gmail.com>
 <CA+icZUXnHaT75NhhSx+AhcMEKybHugH9+hV_mS5h5-cimFdz6A@mail.gmail.com>
 <CA+icZUVQ_UO_VnN9+Q7B3hhuFmw4XPEw19rhO+T4jU5hLGWaTQ@mail.gmail.com>
 <CA+icZUW3K7RyUcfdos7aOkrEOd3To0kSns+G3GSfkPqqwo7z=w@mail.gmail.com>
 <20130826130511.GA21082@redhat.com>
 <20130922141410.GA1974@redhat.com>
 <CAPM=9ty_o7VZx+sfDRSwh7U9BC+gOLd7P-cc856+PDBXR-UMEA@mail.gmail.com>
 <20130925075652.GG12663@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130925075652.GG12663@phenom.ffwll.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 25, 2013 at 09:56:52AM +0200, Daniel Vetter wrote:
> On Wed, Sep 25, 2013 at 01:17:52PM +1000, Dave Airlie wrote:
> > On Mon, Sep 23, 2013 at 12:14 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> > > On Mon, Aug 26, 2013 at 04:05:11PM +0300, Michael S. Tsirkin wrote:
> > >> On Wed, Aug 21, 2013 at 11:22:58AM +0200, Sedat Dilek wrote:
> > >> > [ Re: [Intel-gfx] i915 producing warnings with kernel 3.11-rc5 ]
> > >> >
> > >> > Hi,
> > >> >
> > >> > saw your posting in [1]... can you try the patches below?
> > >> > Not sure if they apply.
> > >> > Did you try v3.11-rc6(+)... or drm-intel-nightly?
> > >> >
> > >> > Regards,
> > >> > - Sedat -
> > >> >
> > >> > [1] http://lists.freedesktop.org/archives/intel-gfx/2013-August/032154.html
> > >>
> > >> Same thing observed with v3.11-rc7.
> > >
> > > I still see this with 3.11.
> > > Following this message, my VGA monitor goes blank and
> > > shows an error suggesting a wrong resolution or frequency are set.
> > > Anyone?
> > 
> > Daniel, Jesse?
> > 
> > still ongoing I think.
> 
> Yeah, I've dismissed it since the original issue in this thread is
> resolved. But it's something else.
> 
> Note to bug reporters: Please don't me-too, but start a new thread/report
> - almost every gfx bug is different, even if it superficially looks the
> same.
> 
> Michael, can you please boot with drm.debug=0xe, reproduce the problem and
> then attach the complete dmesg? Please make sure dmesg contains everything
> since boot-up, if not please increase the dmesg buffer size with
> log_buf_len=4M.

Complete dmesg attached.

> Also please test the latest drm-intel-fixes release to check that we
> haven't just forgotten to send the patch to stable (there's at least one
> flags mismatch fix already in-flight to 3.11 stable kernels).
> 
> Thanks, Daniel

Is it included in latest -rc2? It's easier for me to test that.

> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch

--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="intel-crash-dmesg.txt"
Content-Transfer-Encoding: 8bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.11.0-mst (mst@robin.redhat.com) (gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) ) #258 SMP Sun Sep 22 02:49:15 IDT 2013
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.11.0-mst root=UUID=75d505b0-6e76-4f40-9cbc-0d6e700effd1 ro rd.md=0 rd.lvm=0 rd.dm=0 SYSFONT=True KEYTABLE=us rd.luks=0 LANG=en_US.UTF-8 rhgb quiet drm.debug=0xe
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x000000003fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040000000-0x00000000401fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040200000-0x00000000da99efff] usable
[    0.000000] BIOS-e820: [mem 0x00000000da99f000-0x00000000dae9efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dae9f000-0x00000000daf9efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000daf9f000-0x00000000daffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000dafff000-0x00000000daffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000db000000-0x00000000df9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed08000-0x00000000fed08fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffd20000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000021e5fffff] usable
[    0.000000] BIOS-e820: [mem 0x000000021e600000-0x000000021e7fffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: LENOVO 4243BQ9/4243BQ9, BIOS 8AET57WW (1.37 ) 04/05/2012
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x21e600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 0C0000000 mask FE0000000 write-back
[    0.000000]   4 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   5 base 0DB000000 mask FFF000000 uncachable
[    0.000000]   6 base 100000000 mask F00000000 write-back
[    0.000000]   7 base 200000000 mask FE0000000 write-back
[    0.000000]   8 base 21F000000 mask FFF000000 uncachable
[    0.000000]   9 base 21E800000 mask FFF800000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0xdb000 max_arch_pfn = 0x400000000
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 28672
[    0.000000] reserving inaccessible SNB gfx pages
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01fbf000, 0x01fbffff] PGTABLE
[    0.000000] BRK [0x01fc0000, 0x01fc0fff] PGTABLE
[    0.000000] BRK [0x01fc1000, 0x01fc1fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x21e400000-0x21e5fffff]
[    0.000000]  [mem 0x21e400000-0x21e5fffff] page 2M
[    0.000000] BRK [0x01fc2000, 0x01fc2fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x21c000000-0x21e3fffff]
[    0.000000]  [mem 0x21c000000-0x21e3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x200000000-0x21bffffff]
[    0.000000]  [mem 0x200000000-0x21bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20200000-0x3fffffff]
[    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x40200000-0xda99efff]
[    0.000000]  [mem 0x40200000-0xda7fffff] page 2M
[    0.000000]  [mem 0xda800000-0xda99efff] page 4k
[    0.000000] BRK [0x01fc3000, 0x01fc3fff] PGTABLE
[    0.000000] BRK [0x01fc4000, 0x01fc4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xdafff000-0xdaffffff]
[    0.000000]  [mem 0xdafff000-0xdaffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
[    0.000000]  [mem 0x100000000-0x1ffffffff] page 2M
[    0.000000] RAMDISK: [mem 0x371aa000-0x378ccfff]
[    0.000000] ACPI: RSDP 00000000000f00e0 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000daffe120 000AC (v01 LENOVO TP-8A    00001370 PTEC 00000002)
[    0.000000] ACPI: FACP 00000000dafe8000 000F4 (v04 LENOVO TP-8A    00001370 PTL  00000002)
[    0.000000] ACPI: DSDT 00000000dafeb000 0E48B (v01 LENOVO TP-8A    00001370 INTL 20061109)
[    0.000000] ACPI: FACS 00000000daf2d000 00040
[    0.000000] ACPI: SLIC 00000000daffd000 00176 (v01 LENOVO TP-8A    00001370 PTEC 00000001)
[    0.000000] ACPI: SSDT 00000000daffc000 00249 (v01 LENOVO TP-SSDT2 00000200 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000daffb000 00033 (v01 LENOVO TP-SSDT1 00000100 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000daffa000 00797 (v01 LENOVO SataAhci 00001000 INTL 20061109)
[    0.000000] ACPI: HPET 00000000dafe7000 00038 (v01 LENOVO TP-8A    00001370 PTL  00000002)
[    0.000000] ACPI: APIC 00000000dafe6000 00098 (v01 LENOVO TP-8A    00001370 PTL  00000002)
[    0.000000] ACPI: MCFG 00000000dafe5000 0003C (v01 LENOVO TP-8A    00001370 PTL  00000002)
[    0.000000] ACPI: ECDT 00000000dafe4000 00052 (v01 LENOVO TP-8A    00001370 PTL  00000002)
[    0.000000] ACPI: ASF! 00000000dafea000 000A5 (v32 LENOVO TP-8A    00001370 PTL  00000002)
[    0.000000] ACPI: TCPA 00000000dafe3000 00032 (v02    PTL   LENOVO 06040000 LNVO 00000001)
[    0.000000] ACPI: SSDT 00000000dafe2000 00A69 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000dafe1000 00996 (v01  PmRef    CpuPm 00003000 INTL 20061109)
[    0.000000] ACPI: DMAR 00000000dafe0000 000E8 (v01 INTEL      SNB  00000001 INTL 00000001)
[    0.000000] ACPI: UEFI 00000000dafdf000 0003E (v01 LENOVO TP-8A    00001370 PTL  00000002)
[    0.000000] ACPI: UEFI 00000000dafde000 00042 (v01 PTL      COMBUF 00000001 PTL  00000001)
[    0.000000] ACPI: UEFI 00000000dafdd000 00292 (v01 LENOVO TP-8A    00001370 PTL  00000002)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000021e5fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x21e5fffff]
[    0.000000]   NODE_DATA [mem 0x21e5e5000-0x21e5f8fff]
[    0.000000]  [ffffea0000000000-ffffea00087fffff] PMD -> [ffff880215c00000-ffff88021dbfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x21e5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x3fffffff]
[    0.000000]   node   0: [mem 0x40200000-0xda99efff]
[    0.000000]   node   0: [mem 0xdafff000-0xdaffffff]
[    0.000000]   node   0: [mem 0x100000000-0x21e5fffff]
[    0.000000] On node 0 totalpages: 2067260
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 156 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13911 pages used for memmap
[    0.000000]   DMA32 zone: 890272 pages, LIFO batch:31
[    0.000000]   Normal zone: 18328 pages used for memmap
[    0.000000]   Normal zone: 1172992 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x40000000-0x401fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xda99f000-0xdae9efff]
[    0.000000] PM: Registered nosave memory: [mem 0xdae9f000-0xdaf9efff]
[    0.000000] PM: Registered nosave memory: [mem 0xdaf9f000-0xdaffefff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb000000-0xdf9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfa00000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfed07fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed08000-0xfed08fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed09000-0xfed0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed10000-0xfed19fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xffd1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffd20000-0xffffffff]
[    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88021e200000 s81216 r8192 d21184 u262144
[    0.000000] pcpu-alloc: s81216 r8192 d21184 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2034801
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.11.0-mst root=UUID=75d505b0-6e76-4f40-9cbc-0d6e700effd1 ro rd.md=0 rd.lvm=0 rd.dm=0 SYSFONT=True KEYTABLE=us rd.luks=0 LANG=en_US.UTF-8 rhgb quiet drm.debug=0xe
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 8046708K/8269040K available (6501K kernel code, 933K rwdata, 2768K rodata, 1356K init, 1508K bss, 222332K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=128 to nr_cpu_ids=8.
[    0.000000] NR_IRQS:8448 nr_irqs:744 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.001000] tsc: Detected 2790.991 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 5581.98 BogoMIPS (lpj=2790991)
[    0.000004] pid_max: default: 32768 minimum: 301
[    0.000035] Security Framework initialized
[    0.000043] SELinux:  Initializing.
[    0.000050] SELinux:  Starting in permissive mode
[    0.000508] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.001954] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.002583] Mount-cache hash table entries: 256
[    0.002741] Initializing cgroup subsys devices
[    0.002743] Initializing cgroup subsys freezer
[    0.002744] Initializing cgroup subsys net_cls
[    0.002745] Initializing cgroup subsys blkio
[    0.002746] Initializing cgroup subsys perf_event
[    0.002764] Disabled fast string operations
[    0.002765] CPU: Physical Processor ID: 0
[    0.002766] CPU: Processor Core ID: 0
[    0.002770] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.002772] mce: CPU supports 7 MCE banks
[    0.002782] CPU0: Thermal monitoring enabled (TM1)
[    0.002790] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
tlb_flushall_shift: 5
[    0.002854] Freeing SMP alternatives memory: 24K (ffffffff81e3e000 - ffffffff81e44000)
[    0.002856] ACPI: Core revision 20130517
[    0.008026] ACPI: All ACPI Tables successfully acquired
[    0.008870] ftrace: allocating 23578 entries in 93 pages
[    0.018224] dmar: Host address width 36
[    0.018226] dmar: DRHD base: 0x000000fed90000 flags: 0x0
[    0.018231] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
[    0.018232] dmar: DRHD base: 0x000000fed91000 flags: 0x1
[    0.018236] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
[    0.018237] dmar: RMRR base: 0x000000dacd5000 end: 0x000000dacebfff
[    0.018238] dmar: RMRR base: 0x000000db800000 end: 0x000000df9fffff
[    0.018308] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.018309] HPET id 0 under DRHD base 0xfed91000
[    0.018309] HPET id 0 under DRHD base 0xfed91000
[    0.018310] HPET id 0 under DRHD base 0xfed91000
[    0.018311] HPET id 0 under DRHD base 0xfed91000
[    0.018312] HPET id 0 under DRHD base 0xfed91000
[    0.018312] HPET id 0 under DRHD base 0xfed91000
[    0.018313] HPET id 0 under DRHD base 0xfed91000
[    0.018314] HPET id 0 under DRHD base 0xfed91000
[    0.018510] Enabled IRQ remapping in x2apic mode
[    0.018511] Enabling x2apic
[    0.018511] Enabled x2apic
[    0.018517] Switched APIC routing to cluster x2apic.
[    0.018947] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.028952] smpboot: CPU0: Intel(R) Core(TM) i7-2640M CPU @ 2.80GHz (fam: 06, model: 2a, stepping: 07)
[    0.028960] TSC deadline timer enabled
[    0.028970] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, full-width counters, Intel PMU driver.
[    0.028975] perf_event_intel: PEBS disabled due to CPU errata, please upgrade microcode
[    0.028977] ... version:                3
[    0.028978] ... bit width:              48
[    0.028978] ... generic registers:      4
[    0.028979] ... value mask:             0000ffffffffffff
[    0.028980] ... max period:             0000ffffffffffff
[    0.028981] ... fixed-purpose events:   3
[    0.028981] ... event mask:             000000070000000f
[    0.040977] Disabled fast string operations
[    0.043168] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.054269] Disabled fast string operations
[    0.067480] Disabled fast string operations
[    0.029949] smpboot: Booting Node   0, Processors  #1 #2 #3
[    0.069600] Brought up 4 CPUs
[    0.069603] smpboot: Total of 4 processors activated (22327.92 BogoMIPS)
[    0.072607] devtmpfs: initialized
[    0.072783] PM: Registering ACPI NVS region [mem 0xdae9f000-0xdaf9efff] (1048576 bytes)
[    0.073404] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.073430] RTC time: 18:30:05, date: 09/25/13
[    0.073461] NET: Registered protocol family 16
[    0.073580] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.073582] ACPI: bus type PCI registered
[    0.073584] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.073784] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.073787] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.078706] PCI: Using configuration type 1 for base access
[    0.079362] bio: create slab <bio-0> at 0
[    0.079452] ACPI: Added _OSI(Module Device)
[    0.079453] ACPI: Added _OSI(Processor Device)
[    0.079454] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.079455] ACPI: Added _OSI(Processor Aggregator Device)
[    0.080728] ACPI: EC: EC description table is found, configuring boot EC
[    0.084195] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.097963] ACPI: SSDT 00000000dae8c018 008C0 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.098288] ACPI: Dynamic OEM Table Load:
[    0.098289] ACPI: SSDT           (null) 008C0 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.100796] ACPI: SSDT 00000000dae8da98 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.101142] ACPI: Dynamic OEM Table Load:
[    0.101143] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.103701] ACPI: SSDT 00000000dae8bd98 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.104019] ACPI: Dynamic OEM Table Load:
[    0.104020] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.107090] ACPI: Interpreter enabled
[    0.107094] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130517/hwxface-571)
[    0.107098] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130517/hwxface-571)
[    0.107108] ACPI: (supports S0 S3 S4 S5)
[    0.107109] ACPI: Using IOAPIC for interrupt routing
[    0.107125] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.107803] ACPI: ACPI Dock Station Driver: 2 docks/bays found
[    0.113083] ACPI: Power Resource [PUBS] (on)
[    0.116628] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.116695] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.116760] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.116824] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11)
[    0.116888] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11)
[    0.116938] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.117003] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 9 10 11)
[    0.117066] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 9 10 11)
[    0.117104] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.117194] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
[    0.117255] PCI host bridge to bus 0000:00
[    0.117258] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.117259] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.117261] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.117262] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.117263] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfebfffff]
[    0.117265] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff]
[    0.117272] pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
[    0.117334] pci 0000:00:02.0: [8086:0126] type 00 class 0x030000
[    0.117343] pci 0000:00:02.0: reg 0x10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.117348] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.117352] pci 0000:00:02.0: reg 0x20: [io  0x5000-0x503f]
[    0.117430] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.117453] pci 0000:00:16.0: reg 0x10: [mem 0xf2525000-0xf252500f 64bit]
[    0.117528] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.117586] pci 0000:00:16.3: [8086:1c3d] type 00 class 0x070002
[    0.117607] pci 0000:00:16.3: reg 0x10: [io  0x50b0-0x50b7]
[    0.117617] pci 0000:00:16.3: reg 0x14: [mem 0xf252c000-0xf252cfff]
[    0.117741] pci 0000:00:19.0: [8086:1502] type 00 class 0x020000
[    0.117758] pci 0000:00:19.0: reg 0x10: [mem 0xf2500000-0xf251ffff]
[    0.117766] pci 0000:00:19.0: reg 0x14: [mem 0xf252b000-0xf252bfff]
[    0.117775] pci 0000:00:19.0: reg 0x18: [io  0x5080-0x509f]
[    0.117836] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.117864] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.117896] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    0.117916] pci 0000:00:1a.0: reg 0x10: [mem 0xf252a000-0xf252a3ff]
[    0.118003] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.118032] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.118065] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.118080] pci 0000:00:1b.0: reg 0x10: [mem 0xf2520000-0xf2523fff 64bit]
[    0.118147] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.118179] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.118207] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.118283] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.118340] pci 0000:00:1c.1: [8086:1c12] type 01 class 0x060400
[    0.118416] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.118471] pci 0000:00:1c.3: [8086:1c16] type 01 class 0x060400
[    0.118547] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.118580] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.118615] pci 0000:00:1c.4: [8086:1c18] type 01 class 0x060400
[    0.118743] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.118814] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    0.118834] pci 0000:00:1d.0: reg 0x10: [mem 0xf2529000-0xf25293ff]
[    0.118922] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.118952] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.118980] pci 0000:00:1f.0: [8086:1c4f] type 00 class 0x060100
[    0.119128] pci 0000:00:1f.2: [8086:1c03] type 00 class 0x010601
[    0.119145] pci 0000:00:1f.2: reg 0x10: [io  0x50a8-0x50af]
[    0.119153] pci 0000:00:1f.2: reg 0x14: [io  0x50bc-0x50bf]
[    0.119160] pci 0000:00:1f.2: reg 0x18: [io  0x50a0-0x50a7]
[    0.119168] pci 0000:00:1f.2: reg 0x1c: [io  0x50b8-0x50bb]
[    0.119176] pci 0000:00:1f.2: reg 0x20: [io  0x5060-0x507f]
[    0.119183] pci 0000:00:1f.2: reg 0x24: [mem 0xf2528000-0xf25287ff]
[    0.119227] pci 0000:00:1f.2: PME# supported from D3hot
[    0.119274] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.119288] pci 0000:00:1f.3: reg 0x10: [mem 0xf2524000-0xf25240ff 64bit]
[    0.119309] pci 0000:00:1f.3: reg 0x20: [io  0xefa0-0xefbf]
[    0.119414] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.119510] pci 0000:03:00.0: [8086:4238] type 00 class 0x028000
[    0.119554] pci 0000:03:00.0: reg 0x10: [mem 0xf2400000-0xf2401fff 64bit]
[    0.119774] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.121652] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.121667] pci 0000:00:1c.1:   bridge window [mem 0xf2400000-0xf24fffff]
[    0.121800] acpiphp: Slot [1] registered
[    0.121807] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.121811] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.121815] pci 0000:00:1c.3:   bridge window [mem 0xf1c00000-0xf23fffff]
[    0.121821] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.121973] pci 0000:0d:00.0: [1180:e823] type 00 class 0x088001
[    0.121991] pci 0000:0d:00.0: MMC controller base frequency changed to 50Mhz.
[    0.122017] pci 0000:0d:00.0: reg 0x10: [mem 0xf1401000-0xf14010ff]
[    0.122210] pci 0000:0d:00.0: supports D1 D2
[    0.122211] pci 0000:0d:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.122334] pci 0000:0d:00.3: [1180:e832] type 00 class 0x0c0010
[    0.122359] pci 0000:0d:00.3: reg 0x10: [mem 0xf1400000-0xf14007ff]
[    0.122551] pci 0000:0d:00.3: supports D1 D2
[    0.122553] pci 0000:0d:00.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.124735] pci 0000:00:1c.4: PCI bridge to [bus 0d]
[    0.124745] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.124754] pci 0000:00:1c.4:   bridge window [mem 0xf1400000-0xf1bfffff]
[    0.124769] pci 0000:00:1c.4:   bridge window [mem 0xf0c00000-0xf13fffff 64bit pref]
[    0.124883] acpi PNP0A08:00: Requesting ACPI _OSC control (0x1d)
[    0.125007] acpi PNP0A08:00: ACPI _OSC request failed (AE_SUPPORT), returned control mask: 0x0d
[    0.125009] acpi PNP0A08:00: ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.125830] ACPI: Enabled 4 GPEs in block 00 to 3F
[    0.125840] ACPI: \_SB_.PCI0: notify handler is installed
[    0.125875] Found 1 acpi root devices
[    0.125923] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.125975] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.125978] vgaarb: loaded
[    0.125979] vgaarb: bridge control possible 0000:00:02.0
[    0.126029] SCSI subsystem initialized
[    0.126031] ACPI: bus type ATA registered
[    0.126069] libata version 3.00 loaded.
[    0.126085] ACPI: bus type USB registered
[    0.126098] usbcore: registered new interface driver usbfs
[    0.126104] usbcore: registered new interface driver hub
[    0.126121] usbcore: registered new device driver usb
[    0.126170] PCI: Using ACPI for IRQ routing
[    0.127668] PCI: pci_cache_line_size set to 64 bytes
[    0.127802] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.127804] e820: reserve RAM buffer [mem 0xda99f000-0xdbffffff]
[    0.127805] e820: reserve RAM buffer [mem 0xdb000000-0xdbffffff]
[    0.127806] e820: reserve RAM buffer [mem 0x21e600000-0x21fffffff]
[    0.127869] NetLabel: Initializing
[    0.127870] NetLabel:  domain hash size = 128
[    0.127871] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.127880] NetLabel:  unlabeled traffic allowed by default
[    0.127922] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.127926] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.129951] Switched to clocksource hpet
[    0.133716] pnp: PnP ACPI init
[    0.133729] ACPI: bus type PNP registered
[    0.134057] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.134060] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.134061] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.134063] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.134064] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.134066] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
[    0.134067] system 00:00: [mem 0x000d4000-0x000d7fff] has been reserved
[    0.134068] system 00:00: [mem 0x000d8000-0x000dbfff] has been reserved
[    0.134070] system 00:00: [mem 0x000dc000-0x000dffff] has been reserved
[    0.134071] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.134073] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.134074] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.134076] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.134077] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.134079] system 00:00: [mem 0x00100000-0xdf9fffff] could not be reserved
[    0.134080] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.134082] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.134085] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.134165] system 00:01: [io  0x0400-0x047f] could not be reserved
[    0.134167] system 00:01: [io  0x0500-0x057f] has been reserved
[    0.134168] system 00:01: [io  0x0800-0x080f] has been reserved
[    0.134170] system 00:01: [io  0x15e0-0x15ef] has been reserved
[    0.134171] system 00:01: [io  0x1600-0x167f] has been reserved
[    0.134173] system 00:01: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.134176] system 00:01: [mem 0x00000000-0x00000fff] could not be reserved
[    0.134177] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.134179] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.134180] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.134182] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.134183] system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.134185] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.134228] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.134235] pnp 00:03: [dma 4]
[    0.134250] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.134269] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.134297] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.134319] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.134339] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.134362] pnp 00:08: Plug and Play ACPI device, IDs LEN0015 PNP0f13 (active)
[    0.134398] pnp 00:09: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
[    0.134813] pnp: PnP ACPI: found 10 devices
[    0.134814] ACPI: bus type PNP unregistered
[    0.140891] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.140903] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.140908] pci 0000:00:1c.1:   bridge window [mem 0xf2400000-0xf24fffff]
[    0.140916] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.140919] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.140924] pci 0000:00:1c.3:   bridge window [mem 0xf1c00000-0xf23fffff]
[    0.140928] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.140934] pci 0000:00:1c.4: PCI bridge to [bus 0d]
[    0.140937] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.140944] pci 0000:00:1c.4:   bridge window [mem 0xf1400000-0xf1bfffff]
[    0.140949] pci 0000:00:1c.4:   bridge window [mem 0xf0c00000-0xf13fffff 64bit pref]
[    0.141122] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.141123] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.141125] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.141126] pci_bus 0000:00: resource 7 [mem 0xdfa00000-0xfebfffff]
[    0.141127] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed4bfff]
[    0.141129] pci_bus 0000:03: resource 1 [mem 0xf2400000-0xf24fffff]
[    0.141130] pci_bus 0000:05: resource 0 [io  0x4000-0x4fff]
[    0.141132] pci_bus 0000:05: resource 1 [mem 0xf1c00000-0xf23fffff]
[    0.141133] pci_bus 0000:05: resource 2 [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.141134] pci_bus 0000:0d: resource 0 [io  0x3000-0x3fff]
[    0.141136] pci_bus 0000:0d: resource 1 [mem 0xf1400000-0xf1bfffff]
[    0.141137] pci_bus 0000:0d: resource 2 [mem 0xf0c00000-0xf13fffff 64bit pref]
[    0.141160] NET: Registered protocol family 2
[    0.141320] TCP established hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.141495] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.141607] TCP: Hash tables configured (established 65536 bind 65536)
[    0.141629] TCP: reno registered
[    0.141639] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.141666] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.141730] NET: Registered protocol family 1
[    0.141740] pci 0000:00:02.0: Boot video device
[    0.142014] PCI: CLS 64 bytes, default 64
[    0.142047] Unpacking initramfs...
[    0.252103] Freeing initrd memory: 7308K (ffff8800371aa000 - ffff8800378cd000)
[    0.252112] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.252114] software IO TLB [mem 0xd699f000-0xda99f000] (64MB) mapped at [ffff8800d699f000-ffff8800da99efff]
[    0.254142] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    0.254462] audit: initializing netlink socket (disabled)
[    0.254473] type=2000 audit(1380133805.244:1): initialized
[    0.271432] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.272496] VFS: Disk quotas dquot_6.5.2
[    0.272523] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.272802] msgmni has been set to 15730
[    0.272844] SELinux:  Registering netfilter hooks
[    0.273161] alg: No test for stdrng (krng)
[    0.273168] NET: Registered protocol family 38
[    0.273193] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.273220] io scheduler noop registered
[    0.273222] io scheduler deadline registered
[    0.273240] io scheduler cfq registered (default)
[    0.273485] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.273495] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.273529] vesafb: mode is 1280x1024x32, linelength=5120, pages=0
[    0.273530] vesafb: scrolling: redraw
[    0.273531] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.273952] vesafb: framebuffer at 0xe0000000, mapped to 0xffffc90004f00000, using 5120k, total 5120k
[    0.352872] Console: switching to colour frame buffer device 160x64
[    0.427168] fb0: VESA VGA frame buffer device
[    0.427176] intel_idle: MWAIT substates: 0x21120
[    0.427177] intel_idle: v0.4 model 0x2A
[    0.427178] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.427996] ACPI: AC Adapter [AC] (on-line)
[    0.428122] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    0.428386] ACPI: Lid Switch [LID]
[    0.428426] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    0.428429] ACPI: Sleep Button [SLPB]
[    0.428516] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.428518] ACPI: Power Button [PWRF]
[    0.428592] ACPI: Requesting acpi_cpufreq
[    0.430181] thermal LNXTHERM:00: registered as thermal_zone0
[    0.430182] ACPI: Thermal Zone [THM0] (60 C)
[    0.430199] GHES: HEST is not enabled!
[    0.430259] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.451149] 0000:00:16.3: ttyS0 at I/O 0x50b0 (irq = 19) is a 16550A
[    0.451452] Non-volatile memory driver v1.3
[    0.451453] Linux agpgart interface v0.103
[    0.452161] loop: module loaded
[    0.452199] ahci 0000:00:1f.2: version 3.0
[    0.452266] ahci 0000:00:1f.2: irq 42 for MSI/MSI-X
[    0.452294] ahci: SSS flag set, parallel bus scan disabled
[    0.463069] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x1b impl SATA mode
[    0.463072] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pio slum part ems sxs apst 
[    0.463076] ahci 0000:00:1f.2: setting latency timer to 64
[    0.463704] ACPI: Battery Slot [BAT0] (battery present)
[    0.469332] scsi0 : ahci
[    0.469391] scsi1 : ahci
[    0.469439] scsi2 : ahci
[    0.469487] scsi3 : ahci
[    0.469533] scsi4 : ahci
[    0.469583] scsi5 : ahci
[    0.469643] ata1: SATA max UDMA/133 abar m2048@0xf2528000 port 0xf2528100 irq 42
[    0.469646] ata2: SATA max UDMA/133 abar m2048@0xf2528000 port 0xf2528180 irq 42
[    0.469647] ata3: DUMMY
[    0.469649] ata4: SATA max UDMA/133 abar m2048@0xf2528000 port 0xf2528280 irq 42
[    0.469651] ata5: SATA max UDMA/133 abar m2048@0xf2528000 port 0xf2528300 irq 42
[    0.469652] ata6: DUMMY
[    0.469706] libphy: Fixed MDIO Bus: probed
[    0.469755] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.469757] ehci-pci: EHCI PCI platform driver
[    0.469830] ehci-pci 0000:00:1a.0: setting latency timer to 64
[    0.469838] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    0.469877] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.469890] ehci-pci 0000:00:1a.0: debug port 2
[    0.473802] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    0.473816] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf252a000
[    0.479055] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.479070] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.479071] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.479073] usb usb1: Product: EHCI Host Controller
[    0.479074] usb usb1: Manufacturer: Linux 3.11.0-mst ehci_hcd
[    0.479075] usb usb1: SerialNumber: 0000:00:1a.0
[    0.479156] hub 1-0:1.0: USB hub found
[    0.479159] hub 1-0:1.0: 3 ports detected
[    0.479280] ehci-pci 0000:00:1d.0: setting latency timer to 64
[    0.479285] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    0.479326] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.479337] ehci-pci 0000:00:1d.0: debug port 2
[    0.483236] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    0.483247] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf2529000
[    0.489059] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.489068] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.489069] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.489071] usb usb2: Product: EHCI Host Controller
[    0.489072] usb usb2: Manufacturer: Linux 3.11.0-mst ehci_hcd
[    0.489073] usb usb2: SerialNumber: 0000:00:1d.0
[    0.489144] hub 2-0:1.0: USB hub found
[    0.489147] hub 2-0:1.0: 3 ports detected
[    0.489215] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.489217] ohci-pci: OHCI PCI platform driver
[    0.489223] uhci_hcd: USB Universal Host Controller Interface driver
[    0.489258] usbcore: registered new interface driver usbserial
[    0.489263] usbcore: registered new interface driver usbserial_generic
[    0.489267] usbserial: USB Serial support registered for generic
[    0.489298] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.494993] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.494997] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.495074] mousedev: PS/2 mouse device common for all mice
[    0.495221] rtc_cmos 00:06: RTC can wake from S4
[    0.495337] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    0.495364] rtc_cmos 00:06: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.495404] device-mapper: uevent: version 1.0.3
[    0.495450] device-mapper: ioctl: 4.25.0-ioctl (2013-06-26) initialised: dm-devel@redhat.com
[    0.495529] cpuidle: using governor ladder
[    0.495608] cpuidle: using governor menu
[    0.495884] hidraw: raw HID events driver (C) Jiri Kosina
[    0.495941] usbcore: registered new interface driver usbhid
[    0.495942] usbhid: USB HID core driver
[    0.495957] drop_monitor: Initializing network drop monitor service
[    0.496026] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.496036] TCP: cubic registered
[    0.496037] Initializing XFRM netlink socket
[    0.496118] NET: Registered protocol family 10
[    0.496256] mip6: Mobile IPv6
[    0.496257] NET: Registered protocol family 17
[    0.496264] Key type dns_resolver registered
[    0.496471] PM: Hibernation image not present or could not be loaded.
[    0.496488] registered taskstats version 1
[    0.497176]   Magic number: 13:285:545
[    0.497256] rtc_cmos 00:06: setting system clock to 2013-09-25 18:30:05 UTC (1380133805)
[    0.504215] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    0.774286] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    0.775325] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    0.775336] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    0.775342] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    0.775660] ata1.00: ATA-9: Samsung SSD 840 Series, DXT08B0Q, max UDMA/133
[    0.775669] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    0.780451] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    0.780463] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    0.780470] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    0.780797] ata1.00: configured for UDMA/133
[    0.781206] scsi 0:0:0:0: Direct-Access     ATA      Samsung SSD 840  DXT0 PQ: 0 ANSI: 5
[    0.781239] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    0.781623] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    0.781690] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    0.781920] sd 0:0:0:0: [sda] Write Protect is off
[    0.781929] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.782027] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.785081]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    0.786360] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.895901] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    0.895912] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    0.896504] hub 1-1:1.0: USB hub found
[    0.896660] hub 1-1:1.0: 6 ports detected
[    1.000321] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    1.086373] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.089468] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    1.089902] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    1.089913] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.091651] ata2.00: ATAPI: Optiarc DVD RW AD-7740H, 1.S0, max UDMA/100
[    1.095010] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    1.095446] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    1.095457] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.097249] ata2.00: configured for UDMA/100
[    1.098490] scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7740H  1.S0 PQ: 0 ANSI: 5
[    1.100834] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.100843] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.101241] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.101447] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    1.114951] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    1.114962] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.115560] hub 2-1:1.0: USB hub found
[    1.115724] hub 2-1:1.0: 8 ports detected
[    1.190639] usb 1-1.6: new high-speed USB device number 3 using ehci-pci
[    1.254378] tsc: Refined TSC clocksource calibration: 2790.932 MHz
[    1.282153] usb 1-1.6: New USB device found, idVendor=04f2, idProduct=b217
[    1.282164] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.282169] usb 1-1.6: Product: Integrated Camera
[    1.282174] usb 1-1.6: Manufacturer: Chicony Electronics Co., Ltd.
[    1.391553] usb 2-1.1: new full-speed USB device number 3 using ehci-pci
[    1.406447] ata4: SATA link down (SStatus 0 SControl 300)
[    1.477394] usb 2-1.1: New USB device found, idVendor=0557, idProduct=7000
[    1.477406] usb 2-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.478061] hub 2-1.1:1.0: USB hub found
[    1.478357] hub 2-1.1:1.0: 4 ports detected
[    1.639617] psmouse serio1: synaptics: Touchpad model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd047b3/0xb40000/0xa0000, board id: 71, fw id: 920262
[    1.639635] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
[    1.707448] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input4
[    1.711532] ata5: SATA link down (SStatus 0 SControl 300)
[    1.714633] Freeing unused kernel memory: 1356K (ffffffff81ceb000 - ffffffff81e3e000)
[    1.714640] Write protecting the kernel read-only data: 12288k
[    1.724711] Freeing unused kernel memory: 1680K (ffff88000165c000 - ffff880001800000)
[    1.732923] Freeing unused kernel memory: 1328K (ffff880001ab4000 - ffff880001c00000)
[    1.738644] systemd[1]: RTC configured in localtime, applying delta of 180 minutes to system time.
[    1.741287] systemd[1]: systemd 204 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    1.741585] systemd[1]: Running in initial RAM disk.
[    1.741899] systemd[1]: Set hostname to <robin.redhat.com>.
[    1.742667] usb 2-1.1.1: new low-speed USB device number 4 using ehci-pci
[    1.757235] systemd[1]: Expecting device dev-disk-by\x2duuid-75d505b0\x2d6e76\x2d4f40\x2d9cbc\x2d0d6e700effd1.device...
[    1.757278] systemd[1]: Expecting device dev-disk-by\x2duuid-9a6a5ef2\x2dbee4\x2d4df3\x2dbd74\x2dc9cf2e3628ff.device...
[    1.757308] systemd[1]: Starting Timers.
[    1.757340] systemd[1]: Reached target Timers.
[    1.757539] systemd[1]: Starting udev Kernel Socket.
[    1.757624] systemd[1]: Listening on udev Kernel Socket.
[    1.757760] systemd[1]: Starting udev Control Socket.
[    1.757846] systemd[1]: Listening on udev Control Socket.
[    1.757876] systemd[1]: Starting Journal Socket.
[    1.757996] systemd[1]: Listening on Journal Socket.
[    1.758467] systemd[1]: Started dracut cmdline hook.
[    1.758919] systemd[1]: Starting dracut pre-udev hook...
[    1.760632] systemd[1]: Started Load Kernel Modules.
[    1.760699] systemd[1]: Starting Sockets.
[    1.760751] systemd[1]: Reached target Sockets.
[    1.760800] systemd[1]: Starting Journal Service...
[    1.762053] systemd[1]: Started Journal Service.
[    1.762575] systemd[1]: Starting Setup Virtual Console...
[    1.762895] systemd[1]: Starting Swap.
[    1.762910] systemd[1]: Reached target Swap.
[    1.762923] systemd[1]: Starting Local File Systems.
[    1.762936] systemd[1]: Reached target Local File Systems.
[    1.792945] systemd-udevd[114]: starting version 204
[    1.825377] [drm] Initialized drm 1.1.0 20060810
[    1.827711] [drm:i915_dump_device_info], i915 device info: gen=6, pciid=0x0126 flags=is_mobile,need_gfx_hws,has_force_wake,has_fbc,has_hotplug,has_bsd_ring,has_blt_ring,has_llc,
[    1.827711] [drm] Memory usable by graphics device = 2048M
[    1.827712] [drm:i915_gem_gtt_init], GMADR size = 256M
[    1.827712] [drm:i915_gem_gtt_init], GTT stolen size = 64M
[    1.827713] checking generic (e0000000 500000) vs hw (e0000000 10000000)
[    1.827714] fb: conflicting fb hw usage inteldrmfb vs VESA VGA - removing generic driver
[    1.841963] Console: switching to colour dummy device 80x25
[    1.842081] i915 0000:00:02.0: setting latency timer to 64
[    1.858493] usb 2-1.1.1: New USB device found, idVendor=045e, idProduct=00db
[    1.858504] usb 2-1.1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.858511] usb 2-1.1.1: Product: Natural® Ergonomic Keyboard 4000
[    1.858516] usb 2-1.1.1: Manufacturer: Microsoft
[    1.870126] [drm:intel_detect_pch], Found CougarPoint PCH
[    1.870194] [drm:intel_opregion_setup], graphic opregion physical addr: 0xdaef6018
[    1.870200] [drm:intel_opregion_setup], Public ACPI methods supported
[    1.870201] [drm:intel_opregion_setup], SWSCI supported
[    1.870202] [drm:intel_opregion_setup], ASLE supported
[    1.870227] i915 0000:00:02.0: irq 43 for MSI/MSI-X
[    1.870233] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    1.870234] [drm] Driver supports precise vblank timestamp query.
[    1.870235] [drm:init_vbt_defaults], Set default to SSC at 100MHz
[    1.870236] [drm:intel_parse_bios], Using VBT from OpRegion: $VBT SANDYBRIDGE-M  d
[    1.870238] [drm:parse_general_features], BDB_GENERAL_FEATURES int_tv_support 0 int_crt_support 1 lvds_use_ssc 1 lvds_ssc_freq 120 display_clock_mode 0 fdi_rx_polarity_inverted 0
[    1.870239] [drm:parse_general_definitions], crt_ddc_bus_pin: 2
[    1.870242] [drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
[    1.870243] [drm:drm_mode_debug_printmodeline], Modeline 0:"1920x1080" 0 139000 1920 1980 2028 2050 1080 1090 1100 1130 0x8 0xa
[    1.870245] [drm:parse_lfp_panel_data], VBT initial LVDS value 30033c
[    1.870247] [drm:parse_sdvo_panel_data], Found SDVO panel mode in BIOS VBT tables:
[    1.870248] [drm:drm_mode_debug_printmodeline], Modeline 0:"1600x1200" 0 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x8 0xa
[    1.870249] [drm:parse_sdvo_device_mapping], No SDVO device info is found in VBT
[    1.870255] [drm:intel_dsm_pci_probe], no _DSM method for intel device
[    1.870258] [drm:i915_gem_init_stolen], found 67108864 bytes of stolen memory at dba00000
[    1.870282] [drm:intel_modeset_init], 2 display pipes available.
[    1.870290] [drm:intel_shared_dpll_init], 2 shared PLLs initialized
[    1.870292] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.873247] input: Microsoft Natural® Ergonomic Keyboard 4000 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1.1/2-1.1.1:1.0/input/input5
[    1.873454] microsoft 0003:045E:00DB.0001: input,hidraw0: USB HID v1.11 Keyboard [Microsoft Natural® Ergonomic Keyboard 4000] on usb-0000:00:1d.0-1.1.1/input0
[    1.883527] firewire_ohci 0000:0d:00.3: added OHCI v1.10 device as card 0, 4 IR + 4 IT contexts, quirks 0x11
[    1.884866] [drm:intel_lvds_init], using preferred mode from EDID: 
[    1.884870] [drm:drm_mode_debug_printmodeline], 
[    1.884875] Modeline 10:"1920x1080" 60 139000 1920 1980 2028 2050 1080 1090 1100 1130 0x48 0xa
[    1.884878] [drm:intel_lvds_init], detected dual-link lvds configuration
[    1.884925] [drm:intel_panel_get_backlight], get backlight PWM = 4437
[    1.884928] [drm:intel_panel_get_max_backlight], max backlight PWM = 4437
[    1.884979] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus dpb. force bit now 1
[    1.892458] [drm:intel_sdvo_read_byte], i2c transfer returned -6
[    1.892462] [drm:intel_sdvo_init], No SDVO device found on SDVOB
[    1.892515] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus dpb. force bit now 0
[    1.892555] [drm:intel_dp_init_connector], Adding DP connector on port B
[    1.892582] [drm:intel_dp_i2c_init], i2c_init DPDDC-B
[    1.892654] input: Microsoft Natural® Ergonomic Keyboard 4000 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1.1/2-1.1.1:1.1/input/input6
[    1.892755] microsoft 0003:045E:00DB.0002: input,hidraw1: USB HID v1.11 Device [Microsoft Natural® Ergonomic Keyboard 4000] on usb-0000:00:1d.0-1.1.1/input1
[    1.895042] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7143003f
[    1.895049] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    1.897475] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7143003f
[    1.897482] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    1.897552] [drm:intel_dp_init_connector], Adding DP connector on port C
[    1.897573] [drm:intel_dp_i2c_init], i2c_init DPDDC-C
[    1.900000] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7143003f
[    1.900007] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    1.902448] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7143003f
[    1.902454] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    1.902477] [drm:intel_dp_init_connector], Adding DP connector on port D
[    1.902499] [drm:intel_dp_i2c_init], i2c_init DPDDC-D
[    1.904932] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7143003f
[    1.904939] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    1.907380] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7143003f
[    1.907386] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    1.907407] [drm:ironlake_init_pch_refclk], has_panel 1 has_lvds 1 has_ck505 0
[    1.907411] [drm:ironlake_init_pch_refclk], Using SSC on panel
[    1.907819] [drm:i915_gem_setup_global_gtt], clearing unused GTT space: [0, 7fdff000]
[    1.909741] [drm:init_status_page], render ring hws offset: 0x00000000
[    1.911505] [drm:init_pipe_control], render ring pipe control offset: 0x00021000
[    1.911576] [drm:init_status_page], bsd ring hws offset: 0x00022000
[    1.911918] [drm:init_status_page], blitter ring hws offset: 0x00043000
[    1.912242] [drm:create_default_context], Default HW context loaded
[    1.912243] [drm:i915_gem_context_init], HW context support initialized
[    1.912268] [drm] Wrong MCH_SSKPD value: 0x16040307
[    1.912269] [drm] This can cause pipe underruns and display issues.
[    1.912270] [drm] Please upgrade your BIOS to fix this.
[    1.912279] [drm:intel_modeset_readout_hw_state], [CRTC:3] hw state readout: enabled
[    1.912280] [drm:intel_modeset_readout_hw_state], [CRTC:5] hw state readout: disabled
[    1.912284] [drm:intel_modeset_readout_hw_state], PCH DPLL A hw state readout: refcount 1, on 1
[    1.912288] [drm:intel_modeset_readout_hw_state], PCH DPLL B hw state readout: refcount 0, on 0
[    1.912292] [drm:intel_modeset_readout_hw_state], [ENCODER:8:LVDS-8] hw state readout: enabled, pipe=0
[    1.912295] [drm:intel_modeset_readout_hw_state], [ENCODER:15:DAC-15] hw state readout: disabled, pipe=0
[    1.912298] [drm:intel_modeset_readout_hw_state], [ENCODER:16:TMDS-16] hw state readout: disabled, pipe=0
[    1.912299] [drm:intel_modeset_readout_hw_state], [ENCODER:20:TMDS-20] hw state readout: disabled, pipe=0
[    1.912302] [drm:intel_modeset_readout_hw_state], [ENCODER:22:TMDS-22] hw state readout: disabled, pipe=0
[    1.912304] [drm:intel_modeset_readout_hw_state], [ENCODER:24:TMDS-24] hw state readout: disabled, pipe=0
[    1.912307] [drm:intel_modeset_readout_hw_state], [ENCODER:26:TMDS-26] hw state readout: disabled, pipe=0
[    1.912309] [drm:intel_modeset_readout_hw_state], [ENCODER:28:TMDS-28] hw state readout: disabled, pipe=0
[    1.912312] [drm:intel_modeset_readout_hw_state], [CONNECTOR:7:LVDS-1] hw state readout: enabled
[    1.912314] [drm:intel_modeset_readout_hw_state], [CONNECTOR:14:VGA-1] hw state readout: disabled
[    1.912317] [drm:intel_modeset_readout_hw_state], [CONNECTOR:17:HDMI-A-1] hw state readout: disabled
[    1.912319] [drm:intel_modeset_readout_hw_state], [CONNECTOR:21:DP-1] hw state readout: disabled
[    1.912322] [drm:intel_modeset_readout_hw_state], [CONNECTOR:23:HDMI-A-2] hw state readout: disabled
[    1.912324] [drm:intel_modeset_readout_hw_state], [CONNECTOR:25:HDMI-A-3] hw state readout: disabled
[    1.912326] [drm:intel_modeset_readout_hw_state], [CONNECTOR:27:DP-2] hw state readout: disabled
[    1.912329] [drm:intel_modeset_readout_hw_state], [CONNECTOR:29:DP-3] hw state readout: disabled
[    1.912330] [drm:intel_dump_pipe_config], [CRTC:3][setup_hw_state] config for pipe A
[    1.912331] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    1.912332] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[    1.912333] [drm:intel_dump_pipe_config], fdi/pch: 1, lanes: 4, gmch_m: 2429201, gmch_n: 8388608, link_m: 269911, link_n: 524288, tu: 64
[    1.912334] [drm:intel_dump_pipe_config], requested mode:
[    1.912335] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 1280 0 0 0 1024 0 0 0 0x0 0x0
[    1.912337] [drm:intel_dump_pipe_config], adjusted mode:
[    1.912338] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0xa
[    1.912339] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    1.912340] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x07800438
[    1.912341] [drm:intel_dump_pipe_config], ips: 0
[    1.912342] [drm:intel_dump_pipe_config], [CRTC:5][setup_hw_state] config for pipe B
[    1.912342] [drm:intel_dump_pipe_config], cpu_transcoder: B
[    1.912343] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[    1.912344] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.912345] [drm:intel_dump_pipe_config], requested mode:
[    1.912346] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    1.912347] [drm:intel_dump_pipe_config], adjusted mode:
[    1.912348] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    1.912349] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    1.912350] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[    1.912350] [drm:intel_dump_pipe_config], ips: 0
[    1.912353] [drm:intel_connector_check_state], [CONNECTOR:7:LVDS-1]
[    1.912360] [drm:check_encoder_state], [ENCODER:8:LVDS-8]
[    1.912363] [drm:check_encoder_state], [ENCODER:15:DAC-15]
[    1.912365] [drm:check_encoder_state], [ENCODER:16:TMDS-16]
[    1.912367] [drm:check_encoder_state], [ENCODER:20:TMDS-20]
[    1.912369] [drm:check_encoder_state], [ENCODER:22:TMDS-22]
[    1.912370] [drm:check_encoder_state], [ENCODER:24:TMDS-24]
[    1.912372] [drm:check_encoder_state], [ENCODER:26:TMDS-26]
[    1.912374] [drm:check_encoder_state], [ENCODER:28:TMDS-28]
[    1.912376] [drm:check_crtc_state], [CRTC:3]
[    1.912386] [drm:check_crtc_state], [CRTC:5]
[    1.912387] [drm:check_shared_dpll_state], PCH DPLL A
[    1.912391] [drm:check_shared_dpll_state], PCH DPLL B
[    1.912396] [drm:intel_crt_reset], pch crt adpa set to 0xf40000
[    1.912404] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1]
[    1.912413] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1] probed modes :
[    1.912414] [drm:drm_mode_debug_printmodeline], Modeline 10:"1920x1080" 60 139000 1920 1980 2028 2050 1080 1090 1100 1130 0x48 0xa
[    1.912415] [drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1080" 50 115830 1920 1980 2028 2050 1080 1090 1100 1130 0x40 0xa
[    1.912417] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[    1.912420] [drm:intel_ironlake_crt_detect_hotplug], trigger hotplug detect cycle: adpa=0xf40000
[    1.921476] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[    1.921489] [drm:intel_crt_detect], CRT not detected via hotplug
[    1.921674] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    1.921683] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    1.921687] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    1.921691] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    1.922105] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    1.922106] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    1.922107] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    1.922109] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[    1.922111] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[    1.965897] usb 2-1.1.4: new low-speed USB device number 5 using ehci-pci
[    1.972467] [drm] GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin 5
[    1.980498] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[    1.980504] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[    1.980509] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-1]
[    1.980514] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-1] disconnected
[    1.980518] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:HDMI-A-2]
[    1.980716] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    1.980724] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    1.980729] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:HDMI-A-2] disconnected
[    1.980734] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:HDMI-A-3]
[    1.980901] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[    1.980906] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[    1.980911] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:HDMI-A-3] disconnected
[    1.980915] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:DP-2]
[    1.980922] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:DP-2] disconnected
[    1.980926] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:29:DP-3]
[    1.980931] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:29:DP-3] disconnected
[    1.980935] [drm:drm_setup_crtcs], 
[    1.980939] [drm:drm_enable_connectors], connector 7 enabled? yes
[    1.980943] [drm:drm_enable_connectors], connector 14 enabled? no
[    1.980947] [drm:drm_enable_connectors], connector 17 enabled? no
[    1.980950] [drm:drm_enable_connectors], connector 21 enabled? no
[    1.980953] [drm:drm_enable_connectors], connector 23 enabled? no
[    1.980956] [drm:drm_enable_connectors], connector 25 enabled? no
[    1.980960] [drm:drm_enable_connectors], connector 27 enabled? no
[    1.980963] [drm:drm_enable_connectors], connector 29 enabled? no
[    1.980966] [drm:drm_target_preferred], looking for cmdline mode on connector 7
[    1.980970] [drm:drm_target_preferred], looking for preferred mode on connector 7
[    1.980974] [drm:drm_target_preferred], found mode 1920x1080
[    1.980978] [drm:drm_setup_crtcs], picking CRTCs for 8192x8192 config
[    1.980984] [drm:drm_setup_crtcs], desired mode 1920x1080 set on crtc 3
[    1.980994] [drm:i915_gem_object_create_stolen], creating stolen object: size=7e9000
[    1.981002] [drm:i915_pages_create_for_stolen], offset=0x0, size=8294400
[    1.982540] [drm:intelfb_create], allocated 1920x1080 fb: 0x00072000, bo ffff880211d10c00
[    1.982691] fbcon: inteldrmfb (fb0) is primary device
[    1.982725] [drm:intel_crtc_set_config], [CRTC:3] [FB:31] #connectors=1 (x y) (0 0)
[    1.982726] [drm:intel_set_config_compute_mode_changes], crtc has no fb, full mode set
[    1.982727] [drm:intel_set_config_compute_mode_changes], modes are different, full mode set
[    1.982729] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    1.982731] [drm:drm_mode_debug_printmodeline], Modeline 30:"1920x1080" 60 139000 1920 1980 2028 2050 1080 1090 1100 1130 0x48 0xa
[    1.982732] [drm:intel_modeset_stage_output_state], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[    1.982734] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 1, prepare: 1, disable: 0
[    1.982735] [drm:connected_sink_compute_bpp], [CONNECTOR:7:LVDS-1] checking for sink bpp constrains
[    1.982738] [drm:intel_lvds_compute_config], forcing display bpp (was 24) to LVDS (18)
[    1.982740] [drm:ironlake_check_fdi_lanes], checking fdi config on pipe A, lanes 2
[    1.982741] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 18, dithering: 1
[    1.982743] [drm:intel_dump_pipe_config], [CRTC:3][modeset] config for pipe A
[    1.982743] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    1.982744] [drm:intel_dump_pipe_config], pipe bpp: 18, dithering: 1
[    1.982745] [drm:intel_dump_pipe_config], fdi/pch: 1, lanes: 2, gmch_m: 4858402, gmch_n: 8388608, link_m: 269911, link_n: 524288, tu: 64
[    1.982746] [drm:intel_dump_pipe_config], requested mode:
[    1.982748] [drm:drm_mode_debug_printmodeline], Modeline 0:"1920x1080" 60 139000 1920 1980 2028 2050 1080 1090 1100 1130 0x48 0xa
[    1.982749] [drm:intel_dump_pipe_config], adjusted mode:
[    1.982750] [drm:drm_mode_debug_printmodeline], Modeline 0:"1920x1080" 60 139000 1920 1980 2028 2050 1080 1090 1100 1130 0x48 0xa
[    1.982751] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    1.982752] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[    1.982753] [drm:intel_dump_pipe_config], ips: 0
[    1.982755] [drm:intel_panel_actually_set_backlight], set backlight PWM = 0
[    2.047855] usb 2-1.1.4: New USB device found, idVendor=05bc, idProduct=0102
[    2.047860] usb 2-1.1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.047863] usb 2-1.1.4: Product: USB Optical Mouse
[    2.047866] usb 2-1.1.4: Manufacturer: Forward
[    2.051524] input: Forward USB Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1.4/2-1.1.4:1.0/input/input7
[    2.051896] hid-generic 0003:05BC:0102.0003: input,hidraw2: USB HID v1.10 Mouse [Forward USB Optical Mouse] on usb-0000:00:1d.0-1.1.4/input0
[    2.254882] Switched to clocksource tsc
[    2.351629] [drm:intel_disable_shared_dpll], disable PCH DPLL A (active 1, on? 1) for crtc 3
[    2.351637] [drm:intel_disable_shared_dpll], disabling PCH DPLL A
[    2.352054] [drm:intel_update_fbc], no output, disabling
[    2.352069] [drm:ironlake_get_refclk], using SSC reference clock of 120 MHz
[    2.352123] [drm:intel_get_shared_dpll], CRTC:3 dropping existing PCH DPLL A
[    2.352126] [drm:intel_get_shared_dpll], CRTC:3 allocated PCH DPLL A
[    2.352129] [drm:intel_get_shared_dpll], using PCH DPLL A for pipe A
[    2.352130] [drm:intel_get_shared_dpll], setting up PCH DPLL A
[    2.352460] [drm:ironlake_update_plane], Writing base 00072000 00000000 0 0 7680
[    2.352463] [drm:intel_update_fbc], no output, disabling
[    2.352470] [drm:intel_crtc_mode_set], [ENCODER:8:LVDS-8] set [MODE:0:1920x1080]
[    2.352476] [drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[    2.352482] [drm:ironlake_check_srwm], watermark 1: display plane 16, fbc lines 3, cursor 6
[    2.352486] [drm:ironlake_check_srwm], watermark 2: display plane 20, fbc lines 3, cursor 6
[    2.352490] [drm:ironlake_check_srwm], watermark 3: display plane 98, fbc lines 3, cursor 6
[    2.384981] firewire_core 0000:0d:00.3: created device fw0: GUID f0def1ffea9a6bff, S400
[    2.404696] [drm:ironlake_wait_for_vblank], vblank wait timed out
[    2.456613] [drm:ironlake_wait_for_vblank], vblank wait timed out
[    2.457436] [drm:gen6_fdi_link_train], FDI_RX_IIR 0x700
[    2.457440] [drm:gen6_fdi_link_train], FDI train 1 done.
[    2.458099] [drm:gen6_fdi_link_train], FDI_RX_IIR 0x600
[    2.458102] [drm:gen6_fdi_link_train], FDI train 2 done.
[    2.458104] [drm:gen6_fdi_link_train], FDI train done.
[    2.458108] [drm:ironlake_enable_shared_dpll], enable PCH DPLL A (active 0, on? 0)for crtc 3
[    2.458111] [drm:ironlake_enable_shared_dpll], enabling PCH DPLL A
[    2.459346] [drm:intel_update_fbc], fbc set to per-chip default
[    2.459348] [drm:intel_update_fbc], fbc disabled per module param
[    2.856787] [drm:intel_panel_actually_set_backlight], set backlight PWM = 4437
[    2.862840] [drm:intel_connector_check_state], [CONNECTOR:7:LVDS-1]
[    2.862861] [drm:check_encoder_state], [ENCODER:8:LVDS-8]
[    2.862867] [drm:check_encoder_state], [ENCODER:15:DAC-15]
[    2.862872] [drm:check_encoder_state], [ENCODER:16:TMDS-16]
[    2.862876] [drm:check_encoder_state], [ENCODER:20:TMDS-20]
[    2.862880] [drm:check_encoder_state], [ENCODER:22:TMDS-22]
[    2.862884] [drm:check_encoder_state], [ENCODER:24:TMDS-24]
[    2.862888] [drm:check_encoder_state], [ENCODER:26:TMDS-26]
[    2.862892] [drm:check_encoder_state], [ENCODER:28:TMDS-28]
[    2.862897] [drm:check_crtc_state], [CRTC:3]
[    2.862917] [drm:check_crtc_state], [CRTC:5]
[    2.862920] [drm:check_shared_dpll_state], PCH DPLL A
[    2.862926] [drm:check_shared_dpll_state], PCH DPLL B
[    2.862937] [drm:intel_crtc_set_config], [CRTC:5] [NOFB]
[    2.862945] [drm:intel_modeset_stage_output_state], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[    2.862957] Console: switching to colour frame buffer device 240x67
[    2.862979] [drm:intel_crtc_set_config], [CRTC:3] [FB:31] #connectors=1 (x y) (0 0)
[    2.862984] [drm:intel_modeset_stage_output_state], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[    2.875013] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    2.875017] i915 0000:00:02.0: registered panic notifier
[    2.888552] [drm:asle_set_backlight], bclp = 0x80000005
[    2.888567] [drm:intel_panel_get_max_backlight], max backlight PWM = 4437
[    2.888572] [drm:intel_panel_actually_set_backlight], set backlight PWM = 85
[    2.888577] [drm:asle_set_pwm_freq], PWM freq is not supported
[    2.889176] [drm:asle_set_backlight], bclp = 0x800000ff
[    2.889188] [drm:intel_panel_get_max_backlight], max backlight PWM = 4437
[    2.889194] [drm:intel_panel_actually_set_backlight], set backlight PWM = 4335
[    2.889198] [drm:asle_set_pwm_freq], PWM freq is not supported
[    2.889524] acpi device:01: registered as cooling_device4
[    2.889872] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    2.889918] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input8
[    2.890210] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.892375] [drm:i915_driver_open], 
[    2.892388] [drm:intel_crtc_cursor_set], cursor off
[    2.892390] [drm:intel_crtc_set_config], [CRTC:3] [FB:31] #connectors=1 (x y) (0 0)
[    2.892393] [drm:intel_modeset_stage_output_state], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[    2.892396] [drm:intel_crtc_cursor_set], cursor off
[    2.892396] [drm:intel_crtc_set_config], [CRTC:5] [NOFB]
[    2.892398] [drm:intel_modeset_stage_output_state], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[    2.892404] [drm:i915_driver_open], 
[    2.892408] [drm:intel_crtc_cursor_set], cursor off
[    2.892409] [drm:intel_crtc_set_config], [CRTC:3] [FB:31] #connectors=1 (x y) (0 0)
[    2.892410] [drm:intel_modeset_stage_output_state], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[    2.892411] [drm:intel_crtc_cursor_set], cursor off
[    2.892412] [drm:intel_crtc_set_config], [CRTC:5] [NOFB]
[    2.892413] [drm:intel_modeset_stage_output_state], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[    2.892417] [drm:i915_driver_open], 
[    2.892452] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[8] ENCODERS[8]
[    2.892454] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[8] ENCODERS[8]
[    2.892458] [drm:drm_mode_getconnector], [CONNECTOR:7:?]
[    2.892460] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1]
[    2.892468] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1] probed modes :
[    2.892469] [drm:drm_mode_debug_printmodeline], Modeline 10:"1920x1080" 60 139000 1920 1980 2028 2050 1080 1090 1100 1130 0x48 0xa
[    2.892472] [drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1080" 50 115830 1920 1980 2028 2050 1080 1090 1100 1130 0x40 0xa
[    2.892474] [drm:drm_mode_getconnector], [CONNECTOR:7:?]
[    2.905530] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[    2.905535] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[    2.905539] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[    2.905541] [drm:intel_crt_detect], CRT not detected via hotplug
[    2.905746] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    2.905760] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    2.905766] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    2.905838] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    2.906244] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    2.906245] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    2.906246] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    2.906248] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[    2.906254] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[    2.906255] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[    2.906257] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[    2.906258] [drm:intel_crt_detect], CRT not detected via hotplug
[    2.906424] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    2.906429] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    2.906433] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    2.906436] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    2.906808] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    2.906810] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    2.906811] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    2.906813] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[    2.906818] [drm:drm_mode_getconnector], [CONNECTOR:17:?]
[    2.906820] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[    2.914713] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[    2.914715] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[    2.914723] [drm:drm_mode_getconnector], [CONNECTOR:17:?]
[    2.914724] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[    2.922725] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[    2.922727] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[    2.922734] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[    2.922735] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-1]
[    2.922738] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-1] disconnected
[    2.922739] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[    2.922740] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-1]
[    2.922743] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-1] disconnected
[    2.922744] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[    2.922745] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:HDMI-A-2]
[    2.922901] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    2.922903] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    2.922904] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:HDMI-A-2] disconnected
[    2.922905] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[    2.922906] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:HDMI-A-2]
[    2.923060] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    2.923061] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    2.923062] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:HDMI-A-2] disconnected
[    2.923064] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
[    2.923065] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:HDMI-A-3]
[    2.923215] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[    2.923216] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[    2.923217] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:HDMI-A-3] disconnected
[    2.923218] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
[    2.923219] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:HDMI-A-3]
[    2.923368] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[    2.923369] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[    2.923370] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:HDMI-A-3] disconnected
[    2.923372] [drm:drm_mode_getconnector], [CONNECTOR:27:?]
[    2.923374] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:DP-2]
[    2.923376] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:DP-2] disconnected
[    2.923377] [drm:drm_mode_getconnector], [CONNECTOR:27:?]
[    2.923378] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:DP-2]
[    2.923381] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:DP-2] disconnected
[    2.923382] [drm:drm_mode_getconnector], [CONNECTOR:29:?]
[    2.923383] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:29:DP-3]
[    2.923385] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:29:DP-3] disconnected
[    2.923387] [drm:drm_mode_getconnector], [CONNECTOR:29:?]
[    2.923387] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:29:DP-3]
[    2.923390] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:29:DP-3] disconnected
[    2.923401] [drm:drm_mode_addfb], [FB:32]
[    2.952510] [drm:drm_mode_addfb], [FB:32]
[    2.952528] [drm:drm_mode_setcrtc], [CRTC:3]
[    2.952532] [drm:drm_mode_setcrtc], [CONNECTOR:7:LVDS-1]
[    2.952533] [drm:intel_crtc_set_config], [CRTC:3] [FB:32] #connectors=1 (x y) (0 0)
[    2.952538] [drm:intel_modeset_stage_output_state], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[    2.956869] [drm:ironlake_update_plane], Writing base 0085B000 00000000 0 0 7680
[    2.962715] [drm:intel_update_fbc], fbc set to per-chip default
[    2.962718] [drm:intel_update_fbc], fbc disabled per module param
[    2.971630] [drm:drm_mode_setcrtc], [CRTC:3]
[    2.971645] [drm:drm_mode_setcrtc], [CONNECTOR:7:LVDS-1]
[    2.971651] [drm:intel_crtc_set_config], [CRTC:3] [FB:32] #connectors=1 (x y) (0 0)
[    2.971662] [drm:intel_modeset_stage_output_state], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[    2.986929] EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
[    3.097390] systemd-journald[93]: Received SIGTERM
[    3.717182] [drm:intel_enable_rc6], Sandybridge: deep RC6 disabled
[    3.717186] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[    3.720922] [drm:gen6_enable_rps], Overclocking supported. Max: 1300MHz, Overclock max: 1300MHz
[    3.805418] SELinux: 2048 avtab hash slots, 95514 rules.
[    3.815116] SELinux: 2048 avtab hash slots, 95514 rules.
[    4.019838] SELinux:  8 users, 82 roles, 4543 types, 259 bools, 1 sens, 1024 cats
[    4.019842] SELinux:  83 classes, 95514 rules
[    4.022492] SELinux:  Completing initialization.
[    4.022495] SELinux:  Setting up existing superblocks.
[    4.022499] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    4.022501] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[    4.022508] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    4.022510] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    4.022515] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    4.022538] SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
[    4.023039] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    4.023042] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[    4.023484] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    4.023492] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[    4.023494] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[    4.023506] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    4.023511] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[    4.023517] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[    4.023524] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    4.023707] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
[    4.023709] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    4.023712] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    4.023752] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    4.023771] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    4.023775] SELinux: initialized (dev pstore, type pstore), uses genfs_contexts
[    4.023776] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    4.023780] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    4.023793] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    4.023796] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    4.023798] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    4.023800] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    4.023804] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    4.023809] SELinux: initialized (dev sda6, type ext4), uses xattr
[    4.041270] type=1403 audit(1380123009.042:2): policy loaded auid=4294967295 ses=4294967295
[    4.055557] systemd[1]: Successfully loaded SELinux policy in 401.696ms.
[    4.066502] systemd[1]: RTC configured in localtime, applying delta of 180 minutes to system time.
[    4.081954] systemd[1]: Relabelled /dev and /run in 11.060ms.
[    4.110674] LVM: Logical Volume autoactivation enabled.
[    4.110679] LVM: Activation generator successfully completed.
[    4.181733] systemd-readahead[192]: Failed to mark /: Invalid argument
[    4.181896] systemd-readahead[191]: Bumped block_nr parameter of 8:0 to 20480. This is a temporary hack and should be removed one day.
[    4.182921] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[    4.200445] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    4.200959] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    4.202755] SELinux: initialized (dev configfs, type configfs), uses genfs_contexts
[    4.227484] SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
[    4.244191] systemd-udevd[228]: starting version 204
[    4.439622] EXT4-fs (sda6): re-mounted. Opts: (null)
[    4.480305] wmi: Mapper loaded
[    4.481095] tpm_tis 00:09: 1.2 TPM (device-id 0x0, rev-id 78)
[    4.485577] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \_SB_.PCI0.LPC_.PMIO 1 (20130517/utaddress-251)
[    4.485584] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    4.485588] ACPI Warning: 0x0000000000000540-0x000000000000054f SystemIO conflicts with Region \_SB_.PCI0.LPC_.LPIO 1 (20130517/utaddress-251)
[    4.485591] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    4.485592] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \_SB_.PCI0.LPC_.LPIO 1 (20130517/utaddress-251)
[    4.485595] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    4.485597] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \_SB_.PCI0.LPC_.LPIO 1 (20130517/utaddress-251)
[    4.485599] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    4.485601] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    4.488722] pps_core: LinuxPPS API ver. 1 registered
[    4.488725] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    4.488732] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    4.491855] PTP clock support registered
[    4.495807] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[    4.496953] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[    4.496956] thinkpad_acpi: http://ibm-acpi.sf.net/
[    4.496958] thinkpad_acpi: ThinkPad BIOS 8AET57WW (1.37 ), EC unknown
[    4.496959] thinkpad_acpi: Lenovo ThinkPad T520, model 4243BQ9
[    4.498434] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[    4.498555] thinkpad_acpi: radio switch found; radios are disabled
[    4.498568] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[    4.498569] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[    4.500313] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is blocked
[    4.501526] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
[    4.501694] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[    4.502778] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input9
[    4.517382] sdhci: Secure Digital Host Controller Interface driver
[    4.517386] sdhci: Copyright(c) Pierre Ossman
[    4.517485] tpm_tis 00:09: TPM is disabled/deactivated (0x6)
[    4.525533] input: PC Speaker as /devices/platform/pcspkr/input/input10
[    4.529864] Linux video capture interface: v2.00
[    4.531095] sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e823] (rev 5)
[    4.531411] mmc0: SDHCI controller on PCI [0000:0d:00.0] using DMA
[    4.536862] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    4.536865] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    4.536966] e1000e 0000:00:19.0: setting latency timer to 64
[    4.537021] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    4.537039] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    4.540827] microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x26
[    4.545094] microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x26
[    4.545558] microcode: CPU0 updated to revision 0x29, date = 2013-06-12
[    4.545659] microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x26
[    4.545685] microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x26
[    4.545943] microcode: CPU1 updated to revision 0x29, date = 2013-06-12
[    4.545948] microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x26
[    4.545971] microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x26
[    4.546263] microcode: CPU2 updated to revision 0x29, date = 2013-06-12
[    4.546279] microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x26
[    4.546305] microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x26
[    4.546592] microcode: CPU3 updated to revision 0x29, date = 2013-06-12
[    4.546595] perf_event_intel: PEBS enabled due to microcode update
[    4.546639] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    4.550982] uvcvideo: Found UVC 1.00 device Integrated Camera (04f2:b217)
[    4.552463] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input11
[    4.552580] usbcore: registered new interface driver uvcvideo
[    4.552582] USB Video Class driver (1.1.1)
[    4.555147] cfg80211: Calling CRDA to update world regulatory domain
[    4.571884] Intel(R) Wireless WiFi driver for Linux, in-tree:d
[    4.571888] Copyright(c) 2003-2013 Intel Corporation
[    4.572018] iwlwifi 0000:03:00.0: can't disable ASPM; OS doesn't have ASPM control
[    4.572156] iwlwifi 0000:03:00.0: irq 45 for MSI/MSI-X
[    4.629648] iTCO_vendor_support: vendor-support=0
[    4.630909] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    4.630943] iTCO_wdt: Found a Cougar Point TCO device (Version=2, TCOBASE=0x0460)
[    4.631247] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    4.640444] cfg80211: World regulatory domain updated:
[    4.640448] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    4.640450] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    4.640452] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    4.640454] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    4.640456] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    4.640457] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    4.735089] e1000e 0000:00:19.0 eth0: registered PHC clock
[    4.735104] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) f0:de:f1:ea:9a:6b
[    4.735112] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    4.735173] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: 1000FF-0FF
[    4.735523] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[    4.746267] systemd-udevd[259]: renamed network interface eth0 to em1
[    4.872601] hda_codec: CX20590: BIOS auto-probing.
[    4.873157] ALSA sound/pci/hda/hda_auto_parser.c:393 autoconfig: line_outs=1 (0x1f/0x0/0x0/0x0/0x0) type:speaker
[    4.873166] ALSA sound/pci/hda/hda_auto_parser.c:397    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    4.873172] ALSA sound/pci/hda/hda_auto_parser.c:401    hp_outs=2 (0x1c/0x19/0x0/0x0/0x0)
[    4.873176] ALSA sound/pci/hda/hda_auto_parser.c:402    mono: mono_out=0x0
[    4.873180] ALSA sound/pci/hda/hda_auto_parser.c:406    inputs:
[    4.873186] ALSA sound/pci/hda/hda_auto_parser.c:410      Mic=0x1b
[    4.873190] ALSA sound/pci/hda/hda_auto_parser.c:410      Internal Mic=0x23
[    4.873195] ALSA sound/pci/hda/hda_auto_parser.c:410      Dock Mic=0x1a
[    4.874287] ALSA sound/pci/hda/patch_conexant.c:3414 hda_codec: Enable sync_write for stable communication
[    4.877811] EXT4-fs (sda3): mounting ext3 file system using the ext4 subsystem
[    4.879640] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
[    4.879655] SELinux: initialized (dev sda3, type ext3), uses xattr
[    4.884552] input: HDA Intel PCH HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[    4.884667] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[    4.884754] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[    4.884836] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input15
[    4.884910] input: HDA Intel PCH Dock Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input16
[    4.884987] input: HDA Intel PCH Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input17
[    4.885059] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input18
[    4.900808] type=1305 audit(1380123009.901:3): audit_pid=349 old=0 auid=4294967295 ses=4294967295
 subj=system_u:system_r:auditd_t:s0 res=1
[    5.735143] systemd-logind[379]: Watching system buttons on /dev/input/event2 (Power Button)
[    5.735280] systemd-logind[379]: Watching system buttons on /dev/input/event8 (Video Bus)
[    5.735347] systemd-logind[379]: Watching system buttons on /dev/input/event0 (Lid Switch)
[    5.735403] systemd-logind[379]: Watching system buttons on /dev/input/event1 (Sleep Button)
[    5.735481] systemd-logind[379]: Watching system buttons on /dev/input/event9 (ThinkPad Extra Buttons)
[    5.920803] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    5.933896] Ebtables v2.0 registered
[    5.986358] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    6.042192] Bluetooth: Core ver 2.16
[    6.042253] NET: Registered protocol family 31
[    6.042255] Bluetooth: HCI device and connection manager initialized
[    6.042263] Bluetooth: HCI socket layer initialized
[    6.042265] Bluetooth: L2CAP socket layer initialized
[    6.042270] Bluetooth: SCO socket layer initialized
[    6.057566] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    6.057569] Bluetooth: BNEP filters: protocol multicast
[    6.057583] Bluetooth: BNEP socket layer initialized
[    6.148298] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    6.171436] Bridge firewalling registered
[    6.248722] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    6.248982] IPv6: ADDRCONF(NETDEV_UP): em1: link is not ready
[    6.265639] tun: Universal TUN/TAP device driver, 1.6
[    6.265643] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    6.295982] device virbr0-nic entered promiscuous mode
[    6.393556] [drm:i915_driver_open], 
[    6.400057] [drm:i915_driver_open], 
[    6.400067] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[8] ENCODERS[8]
[    6.400346] [drm:i915_driver_open], 
[    6.400603] [drm:i915_driver_open], 
[    6.400616] [drm:i915_driver_open], 
[    6.400886] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[8] ENCODERS[8]
[    6.400890] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[8] ENCODERS[8]
[    6.400933] [drm:drm_mode_getconnector], [CONNECTOR:7:?]
[    6.400936] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1]
[    6.400947] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1] probed modes :
[    6.400949] [drm:drm_mode_debug_printmodeline], Modeline 10:"1920x1080" 60 139000 1920 1980 2028 2050 1080 1090 1100 1130 0x48 0xa
[    6.400952] [drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1080" 50 115830 1920 1980 2028 2050 1080 1090 1100 1130 0x40 0xa
[    6.400957] [drm:drm_mode_getconnector], [CONNECTOR:7:?]
[    6.401174] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[    6.401177] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[    6.401182] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[    6.401183] [drm:intel_crt_detect], CRT not detected via hotplug
[    6.401340] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    6.401343] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    6.401345] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    6.401346] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    6.401722] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    6.401724] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    6.401726] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    6.401728] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[    6.401733] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[    6.401735] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[    6.401738] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[    6.401739] [drm:intel_crt_detect], CRT not detected via hotplug
[    6.401897] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    6.401899] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    6.401901] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    6.401902] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    6.402265] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    6.402267] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    6.402268] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    6.402269] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[    6.402289] [drm:drm_mode_getconnector], [CONNECTOR:17:?]
[    6.402290] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[    6.409646] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[    6.409650] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[    6.409665] [drm:drm_mode_getconnector], [CONNECTOR:17:?]
[    6.409671] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[    6.417648] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[    6.417651] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[    6.417694] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[    6.417695] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-1]
[    6.417699] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-1] disconnected
[    6.417700] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[    6.417701] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-1]
[    6.417704] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-1] disconnected
[    6.417714] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[    6.417716] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:HDMI-A-2]
[    6.417895] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    6.417899] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    6.417900] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:HDMI-A-2] disconnected
[    6.417905] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[    6.417906] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:HDMI-A-2]
[    6.418074] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    6.418075] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    6.418076] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:HDMI-A-2] disconnected
[    6.418102] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
[    6.418104] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:HDMI-A-3]
[    6.418261] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[    6.418262] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[    6.418263] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:HDMI-A-3] disconnected
[    6.418265] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
[    6.418266] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:HDMI-A-3]
[    6.418423] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[    6.418424] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[    6.418425] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:HDMI-A-3] disconnected
[    6.418439] [drm:drm_mode_getconnector], [CONNECTOR:27:?]
[    6.418440] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:DP-2]
[    6.418443] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:DP-2] disconnected
[    6.418445] [drm:drm_mode_getconnector], [CONNECTOR:27:?]
[    6.418446] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:DP-2]
[    6.418448] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:DP-2] disconnected
[    6.418458] [drm:drm_mode_getconnector], [CONNECTOR:29:?]
[    6.418459] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:29:DP-3]
[    6.418462] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:29:DP-3] disconnected
[    6.418463] [drm:drm_mode_getconnector], [CONNECTOR:29:?]
[    6.418464] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:29:DP-3]
[    6.418466] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:29:DP-3] disconnected
[    6.418492] [drm:drm_mode_getconnector], [CONNECTOR:7:?]
[    6.418494] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1]
[    6.418503] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1] probed modes :
[    6.418504] [drm:drm_mode_debug_printmodeline], Modeline 10:"1920x1080" 60 139000 1920 1980 2028 2050 1080 1090 1100 1130 0x48 0xa
[    6.418506] [drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1080" 50 115830 1920 1980 2028 2050 1080 1090 1100 1130 0x40 0xa
[    6.418508] [drm:drm_mode_getconnector], [CONNECTOR:7:?]
[    6.419211] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[    6.419214] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[    6.419218] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[    6.419219] [drm:intel_crt_detect], CRT not detected via hotplug
[    6.419378] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    6.419381] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    6.419382] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    6.419384] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    6.419762] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    6.419764] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    6.419766] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    6.419767] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[    6.419988] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[    6.419991] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[    6.419994] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[    6.419995] [drm:intel_crt_detect], CRT not detected via hotplug
[    6.420152] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    6.420155] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    6.420157] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    6.420158] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    6.420523] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    6.420525] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    6.420527] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    6.420529] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[    6.420552] [drm:drm_mode_getconnector], [CONNECTOR:17:?]
[    6.420555] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[    6.427650] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[    6.427654] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[    6.427669] [drm:drm_mode_getconnector], [CONNECTOR:17:?]
[    6.427671] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[    6.435654] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[    6.435659] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[    6.435715] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[    6.435719] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-1]
[    6.435723] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-1] disconnected
[    6.435726] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[    6.435728] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-1]
[    6.435731] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-1] disconnected
[    6.435749] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[    6.435751] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:HDMI-A-2]
[    6.435908] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    6.435910] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    6.435911] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:HDMI-A-2] disconnected
[    6.435914] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[    6.435915] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:HDMI-A-2]
[    6.436072] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    6.436073] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    6.436074] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:HDMI-A-2] disconnected
[    6.436091] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
[    6.436094] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:HDMI-A-3]
[    6.436257] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[    6.436260] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[    6.436263] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:HDMI-A-3] disconnected
[    6.436268] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
[    6.436270] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:HDMI-A-3]
[    6.436432] psmouse serio2: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
[    6.436436] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[    6.436438] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[    6.436440] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:HDMI-A-3] disconnected
[    6.436468] [drm:drm_mode_getconnector], [CONNECTOR:27:?]
[    6.436470] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:DP-2]
[    6.436474] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:DP-2] disconnected
[    6.436477] [drm:drm_mode_getconnector], [CONNECTOR:27:?]
[    6.436478] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:DP-2]
[    6.436481] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:DP-2] disconnected
[    6.436496] [drm:drm_mode_getconnector], [CONNECTOR:29:?]
[    6.436498] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:29:DP-3]
[    6.436501] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:29:DP-3] disconnected
[    6.436503] [drm:drm_mode_getconnector], [CONNECTOR:29:?]
[    6.436505] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:29:DP-3]
[    6.436508] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:29:DP-3] disconnected
[    6.439518] [drm:asle_set_backlight], bclp = 0x800000ff
[    6.439525] [drm:intel_panel_get_max_backlight], max backlight PWM = 4437
[    6.439527] [drm:intel_panel_actually_set_backlight], set backlight PWM = 4335
[    6.439529] [drm:asle_set_pwm_freq], PWM freq is not supported
[    6.440077] [drm:asle_set_backlight], bclp = 0x800000ff
[    6.440081] [drm:intel_panel_get_max_backlight], max backlight PWM = 4437
[    6.440083] [drm:intel_panel_actually_set_backlight], set backlight PWM = 4335
[    6.440084] [drm:asle_set_pwm_freq], PWM freq is not supported
[    6.441311] [drm:drm_mode_addfb], [FB:33]
[    6.441353] [drm:drm_mode_setcrtc], [CRTC:3]
[    6.441355] [drm:drm_mode_setcrtc], [CONNECTOR:7:LVDS-1]
[    6.441357] [drm:intel_crtc_set_config], [CRTC:3] [FB:33] #connectors=1 (x y) (0 0)
[    6.441360] [drm:intel_modeset_stage_output_state], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[    6.445333] [drm:ironlake_update_plane], Writing base 01044000 00000000 0 0 7680
[    6.448640] [drm:intel_update_fbc], fbc set to per-chip default
[    6.448644] [drm:intel_update_fbc], fbc disabled per module param
[    6.448684] [drm:drm_mode_setcrtc], [CRTC:5]
[    6.448686] [drm:intel_crtc_set_config], [CRTC:5] [NOFB]
[    6.448688] [drm:intel_modeset_stage_output_state], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[    8.031174] e1000e: em1 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
[    8.031189] e1000e 0000:00:19.0 em1: 10/100 speed: disabling TSO
[    8.031250] IPv6: ADDRCONF(NETDEV_CHANGE): em1: link becomes ready
[    8.421083] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    8.757041] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input19
[    8.925160] virbr0: topology change detected, propagating
[    8.925173] virbr0: port 1(virbr0-nic) entered forwarding state
[    8.925202] virbr0: port 1(virbr0-nic) entered forwarding state
[    8.962042] virbr0: port 1(virbr0-nic) entered disabled state
[   10.242281] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[   10.242325] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[   10.275116] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[   10.278068] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[   27.729447] [drm:i915_hotplug_work_func], running encoder hotplug functions
[   27.729462] [drm:i915_hotplug_work_func], Connector VGA-1 (pin 1) received hotplug event.
[   27.729472] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0x3f40000, result 1
[   27.729477] [drm:intel_crt_detect], CRT detected via hotplug
[   27.729481] [drm:intel_hpd_irq_event], [CONNECTOR:14:VGA-1] status updated from 2 to 1
[   27.736261] [drm:drm_mode_getconnector], [CONNECTOR:7:?]
[   27.736274] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1]
[   27.736643] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1] probed modes :
[   27.736651] [drm:drm_mode_debug_printmodeline], Modeline 10:"1920x1080" 60 139000 1920 1980 2028 2050 1080 1090 1100 1130 0x48 0xa
[   27.736659] [drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1080" 50 115830 1920 1980 2028 2050 1080 1090 1100 1130 0x40 0xa
[   27.736676] [drm:drm_mode_getconnector], [CONNECTOR:7:?]
[   27.737201] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   27.737208] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[   27.737216] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0x3f40000, result 1
[   27.737220] [drm:intel_crt_detect], CRT detected via hotplug
[   27.750371] [drm:drm_edid_to_eld], ELD: no CEA Extension found
[   27.750401] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] probed modes :
[   27.750406] [drm:drm_mode_debug_printmodeline], Modeline 34:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   27.750415] [drm:drm_mode_debug_printmodeline], Modeline 43:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   27.750421] [drm:drm_mode_debug_printmodeline], Modeline 35:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   27.750428] [drm:drm_mode_debug_printmodeline], Modeline 44:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   27.750434] [drm:drm_mode_debug_printmodeline], Modeline 45:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   27.750440] [drm:drm_mode_debug_printmodeline], Modeline 46:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   27.750446] [drm:drm_mode_debug_printmodeline], Modeline 47:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   27.750452] [drm:drm_mode_debug_printmodeline], Modeline 48:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   27.750458] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   27.750464] [drm:drm_mode_debug_printmodeline], Modeline 36:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   27.750470] [drm:drm_mode_debug_printmodeline], Modeline 37:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   27.750476] [drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   27.750482] [drm:drm_mode_debug_printmodeline], Modeline 39:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   27.750488] [drm:drm_mode_debug_printmodeline], Modeline 40:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   27.750494] [drm:drm_mode_debug_printmodeline], Modeline 41:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   27.750499] [drm:drm_mode_debug_printmodeline], Modeline 42:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   27.750522] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   27.750612] [drm:drm_mode_getconnector], [CONNECTOR:17:?]
[   27.750617] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[   27.758319] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[   27.758326] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[   27.758337] [drm:drm_mode_getconnector], [CONNECTOR:17:?]
[   27.758341] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[   27.766324] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[   27.766333] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[   27.766391] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[   27.766399] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-1]
[   27.766406] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-1] disconnected
[   27.766413] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[   27.766416] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-1]
[   27.766422] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-1] disconnected
[   27.766431] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[   27.766435] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:HDMI-A-2]
[   27.766677] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   27.766690] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   27.766696] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:HDMI-A-2] disconnected
[   27.766713] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[   27.766718] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:HDMI-A-2]
[   27.766916] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   27.766922] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   27.766927] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:HDMI-A-2] disconnected
[   27.766948] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
[   27.766952] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:HDMI-A-3]
[   27.767120] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[   27.767125] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[   27.767129] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:HDMI-A-3] disconnected
[   27.767138] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
[   27.767141] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:HDMI-A-3]
[   27.767339] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[   27.767346] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[   27.767353] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:HDMI-A-3] disconnected
[   27.767374] [drm:drm_mode_getconnector], [CONNECTOR:27:?]
[   27.767409] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:DP-2]
[   27.767433] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:DP-2] disconnected
[   27.767460] [drm:drm_mode_getconnector], [CONNECTOR:27:?]
[   27.767479] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:DP-2]
[   27.767487] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:DP-2] disconnected
[   27.767499] [drm:drm_mode_getconnector], [CONNECTOR:29:?]
[   27.767505] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:29:DP-3]
[   27.767513] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:29:DP-3] disconnected
[   27.767524] [drm:drm_mode_getconnector], [CONNECTOR:29:?]
[   27.767531] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:29:DP-3]
[   27.767540] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:29:DP-3] disconnected
[   33.091303] [drm:drm_mode_getconnector], [CONNECTOR:7:?]
[   33.091318] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1]
[   33.091347] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1] probed modes :
[   33.091352] [drm:drm_mode_debug_printmodeline], Modeline 10:"1920x1080" 60 139000 1920 1980 2028 2050 1080 1090 1100 1130 0x48 0xa
[   33.091361] [drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1080" 50 115830 1920 1980 2028 2050 1080 1090 1100 1130 0x40 0xa
[   33.091374] [drm:drm_mode_getconnector], [CONNECTOR:7:?]
[   33.091933] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   33.091937] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[   33.091942] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0x3f40000, result 1
[   33.091944] [drm:intel_crt_detect], CRT detected via hotplug
[   33.105079] [drm:drm_edid_to_eld], ELD: no CEA Extension found
[   33.105116] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] probed modes :
[   33.105122] [drm:drm_mode_debug_printmodeline], Modeline 34:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   33.105130] [drm:drm_mode_debug_printmodeline], Modeline 43:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   33.105136] [drm:drm_mode_debug_printmodeline], Modeline 35:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   33.105143] [drm:drm_mode_debug_printmodeline], Modeline 44:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   33.105149] [drm:drm_mode_debug_printmodeline], Modeline 45:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   33.105155] [drm:drm_mode_debug_printmodeline], Modeline 46:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   33.105161] [drm:drm_mode_debug_printmodeline], Modeline 47:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   33.105167] [drm:drm_mode_debug_printmodeline], Modeline 48:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   33.105173] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   33.105179] [drm:drm_mode_debug_printmodeline], Modeline 36:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   33.105185] [drm:drm_mode_debug_printmodeline], Modeline 37:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   33.105191] [drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   33.105197] [drm:drm_mode_debug_printmodeline], Modeline 39:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   33.105202] [drm:drm_mode_debug_printmodeline], Modeline 40:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   33.105208] [drm:drm_mode_debug_printmodeline], Modeline 41:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   33.105214] [drm:drm_mode_debug_printmodeline], Modeline 42:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   33.105247] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   33.105344] [drm:drm_mode_getconnector], [CONNECTOR:17:?]
[   33.105350] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[   33.112744] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[   33.112754] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[   33.112798] [drm:drm_mode_getconnector], [CONNECTOR:17:?]
[   33.112803] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[   33.120747] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[   33.120753] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[   33.120789] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[   33.120794] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-1]
[   33.120801] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-1] disconnected
[   33.120808] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[   33.120811] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-1]
[   33.120817] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-1] disconnected
[   33.120826] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[   33.120830] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:HDMI-A-2]
[   33.121026] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   33.121034] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   33.121038] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:HDMI-A-2] disconnected
[   33.121049] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[   33.121053] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:HDMI-A-2]
[   33.121262] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   33.121269] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   33.121273] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:HDMI-A-2] disconnected
[   33.121289] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
[   33.121294] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:HDMI-A-3]
[   33.121466] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[   33.121471] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[   33.121475] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:HDMI-A-3] disconnected
[   33.121484] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
[   33.121488] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:HDMI-A-3]
[   33.121657] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[   33.121662] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[   33.121666] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:HDMI-A-3] disconnected
[   33.121678] [drm:drm_mode_getconnector], [CONNECTOR:27:?]
[   33.121682] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:DP-2]
[   33.121688] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:DP-2] disconnected
[   33.121693] [drm:drm_mode_getconnector], [CONNECTOR:27:?]
[   33.121697] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:DP-2]
[   33.121702] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:DP-2] disconnected
[   33.121710] [drm:drm_mode_getconnector], [CONNECTOR:29:?]
[   33.121714] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:29:DP-3]
[   33.121740] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:29:DP-3] disconnected
[   33.121747] [drm:drm_mode_getconnector], [CONNECTOR:29:?]
[   33.121751] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:29:DP-3]
[   33.121756] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:29:DP-3] disconnected
[   33.640251] [drm:drm_mode_getconnector], [CONNECTOR:7:?]
[   33.640258] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1]
[   33.640269] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1] probed modes :
[   33.640271] [drm:drm_mode_debug_printmodeline], Modeline 10:"1920x1080" 60 139000 1920 1980 2028 2050 1080 1090 1100 1130 0x48 0xa
[   33.640274] [drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1080" 50 115830 1920 1980 2028 2050 1080 1090 1100 1130 0x40 0xa
[   33.640279] [drm:drm_mode_getconnector], [CONNECTOR:7:?]
[   33.640474] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   33.640477] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[   33.640481] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0x3f40000, result 1
[   33.640483] [drm:intel_crt_detect], CRT detected via hotplug
[   33.654037] [drm:drm_edid_to_eld], ELD: no CEA Extension found
[   33.654049] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] probed modes :
[   33.654050] [drm:drm_mode_debug_printmodeline], Modeline 34:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   33.654052] [drm:drm_mode_debug_printmodeline], Modeline 43:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   33.654054] [drm:drm_mode_debug_printmodeline], Modeline 35:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   33.654056] [drm:drm_mode_debug_printmodeline], Modeline 44:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   33.654057] [drm:drm_mode_debug_printmodeline], Modeline 45:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   33.654059] [drm:drm_mode_debug_printmodeline], Modeline 46:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   33.654060] [drm:drm_mode_debug_printmodeline], Modeline 47:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   33.654062] [drm:drm_mode_debug_printmodeline], Modeline 48:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   33.654063] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   33.654065] [drm:drm_mode_debug_printmodeline], Modeline 36:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   33.654066] [drm:drm_mode_debug_printmodeline], Modeline 37:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   33.654068] [drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   33.654069] [drm:drm_mode_debug_printmodeline], Modeline 39:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   33.654071] [drm:drm_mode_debug_printmodeline], Modeline 40:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   33.654072] [drm:drm_mode_debug_printmodeline], Modeline 41:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   33.654074] [drm:drm_mode_debug_printmodeline], Modeline 42:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   33.654089] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   33.654123] [drm:drm_mode_getconnector], [CONNECTOR:17:?]
[   33.654124] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[   33.661890] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[   33.661895] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[   33.661917] [drm:drm_mode_getconnector], [CONNECTOR:17:?]
[   33.661920] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[   33.669885] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[   33.669890] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[   33.669904] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[   33.669906] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-1]
[   33.669910] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-1] disconnected
[   33.669911] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[   33.669912] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-1]
[   33.669915] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-1] disconnected
[   33.669917] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[   33.669918] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:HDMI-A-2]
[   33.670152] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   33.670161] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   33.670166] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:HDMI-A-2] disconnected
[   33.670176] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[   33.670180] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:HDMI-A-2]
[   33.670356] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   33.670397] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   33.670398] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:HDMI-A-2] disconnected
[   33.670403] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
[   33.670404] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:HDMI-A-3]
[   33.670553] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[   33.670556] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[   33.670558] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:HDMI-A-3] disconnected
[   33.670562] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
[   33.670564] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:HDMI-A-3]
[   33.670716] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[   33.670717] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[   33.670718] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:HDMI-A-3] disconnected
[   33.670723] [drm:drm_mode_getconnector], [CONNECTOR:27:?]
[   33.670724] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:DP-2]
[   33.670727] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:DP-2] disconnected
[   33.670729] [drm:drm_mode_getconnector], [CONNECTOR:27:?]
[   33.670730] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:DP-2]
[   33.670732] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:DP-2] disconnected
[   33.670735] [drm:drm_mode_getconnector], [CONNECTOR:29:?]
[   33.670736] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:29:DP-3]
[   33.670737] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:29:DP-3] disconnected
[   33.670739] [drm:drm_mode_getconnector], [CONNECTOR:29:?]
[   33.670739] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:29:DP-3]
[   33.670742] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:29:DP-3] disconnected
[   33.677531] [drm:asle_set_backlight], bclp = 0x800000ff
[   33.677537] [drm:intel_panel_get_max_backlight], max backlight PWM = 4437
[   33.677538] [drm:intel_panel_actually_set_backlight], set backlight PWM = 4335
[   33.677539] [drm:asle_set_pwm_freq], PWM freq is not supported
[   33.726901] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[   33.727110] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   33.727113] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   33.727289] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[   33.727290] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[   33.727321] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0x3f40000, result 1
[   33.727323] [drm:intel_crt_detect], CRT detected via hotplug
[   33.733627] [drm:asle_set_backlight], bclp = 0x800000ff
[   33.733632] [drm:intel_panel_get_max_backlight], max backlight PWM = 4437
[   33.733633] [drm:intel_panel_actually_set_backlight], set backlight PWM = 4335
[   33.733635] [drm:asle_set_pwm_freq], PWM freq is not supported
[   33.735261] [drm:asle_set_backlight], bclp = 0x800000ff
[   33.735267] [drm:intel_panel_get_max_backlight], max backlight PWM = 4437
[   33.735269] [drm:intel_panel_actually_set_backlight], set backlight PWM = 4335
[   33.735270] [drm:asle_set_pwm_freq], PWM freq is not supported
[   34.118911] [drm:asle_set_backlight], bclp = 0x80000003
[   34.118929] [drm:intel_panel_get_max_backlight], max backlight PWM = 4437
[   34.118938] [drm:intel_panel_actually_set_backlight], set backlight PWM = 51
[   34.118946] [drm:asle_set_pwm_freq], PWM freq is not supported
[   34.120083] [drm:intel_panel_actually_set_backlight], set backlight PWM = 0
[   34.490192] [drm:intel_disable_shared_dpll], disable PCH DPLL A (active 1, on? 1) for crtc 3
[   34.490211] [drm:intel_disable_shared_dpll], disabling PCH DPLL A
[   34.490631] [drm:intel_update_fbc], no output, disabling
[   34.490657] [drm:check_encoder_state], [ENCODER:8:LVDS-8]
[   34.490664] [drm:check_encoder_state], [ENCODER:15:DAC-15]
[   34.490670] [drm:check_encoder_state], [ENCODER:16:TMDS-16]
[   34.490675] [drm:check_encoder_state], [ENCODER:20:TMDS-20]
[   34.490681] [drm:check_encoder_state], [ENCODER:22:TMDS-22]
[   34.490686] [drm:check_encoder_state], [ENCODER:24:TMDS-24]
[   34.490691] [drm:check_encoder_state], [ENCODER:26:TMDS-26]
[   34.490697] [drm:check_encoder_state], [ENCODER:28:TMDS-28]
[   34.490702] [drm:check_crtc_state], [CRTC:3]
[   34.490709] [drm:check_crtc_state], [CRTC:5]
[   34.490713] [drm:check_shared_dpll_state], PCH DPLL A
[   34.490721] [drm:check_shared_dpll_state], PCH DPLL B
[   34.494256] [drm:drm_mode_addfb], [FB:50]
[   34.494311] [drm:intel_crtc_set_config], [CRTC:3] [NOFB]
[   34.494321] [drm:intel_modeset_stage_output_state], [CONNECTOR:7:LVDS-1] to [NOCRTC]
[   34.494326] [drm:intel_modeset_stage_output_state], encoder changed, full mode switch
[   34.494330] [drm:intel_modeset_stage_output_state], crtc changed, full mode switch
[   34.494336] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 0, prepare: 0, disable: 1
[   34.494359] [drm:check_encoder_state], [ENCODER:8:LVDS-8]
[   34.494365] [drm:check_encoder_state], [ENCODER:15:DAC-15]
[   34.494371] [drm:check_encoder_state], [ENCODER:16:TMDS-16]
[   34.494377] [drm:check_encoder_state], [ENCODER:20:TMDS-20]
[   34.494382] [drm:check_encoder_state], [ENCODER:22:TMDS-22]
[   34.494387] [drm:check_encoder_state], [ENCODER:24:TMDS-24]
[   34.494393] [drm:check_encoder_state], [ENCODER:26:TMDS-26]
[   34.494398] [drm:check_encoder_state], [ENCODER:28:TMDS-28]
[   34.494403] [drm:check_crtc_state], [CRTC:3]
[   34.494408] [drm:check_crtc_state], [CRTC:5]
[   34.494412] [drm:check_shared_dpll_state], PCH DPLL A
[   34.494420] [drm:check_shared_dpll_state], PCH DPLL B
[   34.505438] [drm:drm_mode_setcrtc], [CRTC:3]
[   34.505447] [drm:drm_mode_setcrtc], [CONNECTOR:7:LVDS-1]
[   34.505449] [drm:intel_crtc_set_config], [CRTC:3] [FB:50] #connectors=1 (x y) (0 0)
[   34.505451] [drm:intel_set_config_compute_mode_changes], crtc has no fb, full mode set
[   34.505464] [drm:intel_set_config_compute_mode_changes], modes are different, full mode set
[   34.505465] [drm:drm_mode_debug_printmodeline], Modeline 30:"1920x1080" 60 139000 1920 1980 2028 2050 1080 1090 1100 1130 0x48 0xa
[   34.505467] [drm:drm_mode_debug_printmodeline], Modeline 33:"" 0 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x0 0x5
[   34.505468] [drm:intel_modeset_stage_output_state], encoder changed, full mode switch
[   34.505470] [drm:intel_modeset_stage_output_state], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[   34.505471] [drm:intel_modeset_stage_output_state], crtc changed, full mode switch
[   34.505472] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 1, prepare: 1, disable: 0
[   34.505474] [drm:connected_sink_compute_bpp], [CONNECTOR:7:LVDS-1] checking for sink bpp constrains
[   34.505477] [drm:intel_lvds_compute_config], forcing display bpp (was 24) to LVDS (18)
[   34.505479] [drm:ironlake_check_fdi_lanes], checking fdi config on pipe A, lanes 2
[   34.505480] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 18, dithering: 1
[   34.505482] [drm:intel_dump_pipe_config], [CRTC:3][modeset] config for pipe A
[   34.505483] [drm:intel_dump_pipe_config], cpu_transcoder: A
[   34.505484] [drm:intel_dump_pipe_config], pipe bpp: 18, dithering: 1
[   34.505485] [drm:intel_dump_pipe_config], fdi/pch: 1, lanes: 2, gmch_m: 4858402, gmch_n: 8388608, link_m: 269911, link_n: 524288, tu: 64
[   34.505486] [drm:intel_dump_pipe_config], requested mode:
[   34.505487] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x0 0x5
[   34.505488] [drm:intel_dump_pipe_config], adjusted mode:
[   34.505489] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 139000 1920 1980 2028 2050 1080 1090 1100 1130 0x0 0x5
[   34.505490] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[   34.505491] [drm:intel_dump_pipe_config], pch pfit: pos: 0x011d0000, size: 0x05460438
[   34.505492] [drm:intel_dump_pipe_config], ips: 0
[   34.505495] [drm:ironlake_get_refclk], using SSC reference clock of 120 MHz
[   34.505510] [drm:intel_get_shared_dpll], CRTC:3 allocated PCH DPLL A
[   34.505511] [drm:intel_get_shared_dpll], using PCH DPLL A for pipe A
[   34.505512] [drm:intel_get_shared_dpll], setting up PCH DPLL A
[   34.512154] [drm:ironlake_update_plane], Writing base 02057000 00000000 0 0 5120
[   34.512181] [drm:intel_update_fbc], no output, disabling
[   34.512197] [drm:intel_crtc_mode_set], [ENCODER:8:LVDS-8] set [MODE:0:]
[   34.512207] [drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 7, cursor: 6
[   34.512214] [drm:ironlake_check_srwm], watermark 1: display plane 13, fbc lines 3, cursor 6
[   34.512220] [drm:ironlake_check_srwm], watermark 2: display plane 16, fbc lines 3, cursor 6
[   34.512225] [drm:ironlake_check_srwm], watermark 3: display plane 77, fbc lines 3, cursor 6
[   34.564244] [drm:ironlake_wait_for_vblank], vblank wait timed out
[   34.616207] [drm:ironlake_wait_for_vblank], vblank wait timed out
[   34.617038] [drm:gen6_fdi_link_train], FDI_RX_IIR 0x100
[   34.617045] [drm:gen6_fdi_link_train], FDI train 1 done.
[   34.617707] [drm:gen6_fdi_link_train], FDI_RX_IIR 0x600
[   34.617714] [drm:gen6_fdi_link_train], FDI train 2 done.
[   34.617716] [drm:gen6_fdi_link_train], FDI train done.
[   34.617720] [drm:ironlake_enable_shared_dpll], enable PCH DPLL A (active 0, on? 0)for crtc 3
[   34.617726] [drm:ironlake_enable_shared_dpll], enabling PCH DPLL A
[   34.618965] [drm:intel_update_fbc], fbc set to per-chip default
[   34.618969] [drm:intel_update_fbc], fbc disabled per module param
[   35.038327] [drm:intel_panel_actually_set_backlight], set backlight PWM = 51
[   35.056348] [drm:intel_connector_check_state], [CONNECTOR:7:LVDS-1]
[   35.056375] [drm:check_encoder_state], [ENCODER:8:LVDS-8]
[   35.056382] [drm:check_encoder_state], [ENCODER:15:DAC-15]
[   35.056388] [drm:check_encoder_state], [ENCODER:16:TMDS-16]
[   35.056393] [drm:check_encoder_state], [ENCODER:20:TMDS-20]
[   35.056399] [drm:check_encoder_state], [ENCODER:22:TMDS-22]
[   35.056404] [drm:check_encoder_state], [ENCODER:24:TMDS-24]
[   35.056409] [drm:check_encoder_state], [ENCODER:26:TMDS-26]
[   35.056414] [drm:check_encoder_state], [ENCODER:28:TMDS-28]
[   35.056420] [drm:check_crtc_state], [CRTC:3]
[   35.056444] [drm:intel_pipe_config_compare] *ERROR* mismatch in adjusted_mode.flags (expected 1, found 0)
[   35.056451] ------------[ cut here ]------------
[   35.056515] WARNING: CPU: 0 PID: 605 at drivers/gpu/drm/i915/intel_display.c:8286 check_crtc_state+0x5cf/0xa50 [i915]()
[   35.056518] pipe state doesn't match!
[   35.056521] Modules linked in: ebtable_nat xt_CHECKSUM nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 tun nf_defrag_ipv6 bridge stp llc iptable_nat nf_nat_ipv4 nf_nat iptable_mangle bnep bluetooth nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables snd_hda_codec_hdmi snd_hda_codec_conexant iTCO_wdt iTCO_vendor_support x86_pkg_temp_thermal coretemp kvm_intel kvm snd_hda_intel snd_hda_codec snd_hwdep snd_seq iwlwifi crc32c_intel snd_seq_device ghash_clmulni_intel snd_pcm cfg80211 uvcvideo videobuf2_vmalloc microcode videobuf2_memops videobuf2_core e1000e sdhci_pci videodev pcspkr serio_raw sdhci mmc_core thinkpad_acpi snd_page_alloc i2c_i801 snd_timer ptp snd
[   35.056597]  pps_core shpchp lpc_ich mfd_core tpm_tis wmi soundcore tpm rfkill tpm_bios uinput binfmt_misc firewire_ohci firewire_core crc_itu_t i915 i2c_algo_bit drm_kms_helper drm i2c_core video
[   35.056627] CPU: 0 PID: 605 Comm: X Not tainted 3.11.0-mst #258
[   35.056631] Hardware name: LENOVO 4243BQ9/4243BQ9, BIOS 8AET57WW (1.37 ) 04/05/2012
[   35.056635]  000000000000205e ffff8801fede7728 ffffffff81647c9b ffff8801fede7768
[   35.056644]  ffffffff81056d6c ffff880212201478 0000000000000002 ffff8802144d5000
[   35.056650]  0000000000000001 ffff880212201478 ffff880212201000 ffff8801fede7848
[   35.056657] Call Trace:
[   35.056671]  [<ffffffff81647c9b>] dump_stack+0x6a/0x77
[   35.056683]  [<ffffffff81056d6c>] warn_slowpath_common+0x8c/0xc0
[   35.056691]  [<ffffffff81056e9e>] warn_slowpath_fmt+0x6e/0x70
[   35.056724]  [<ffffffffa0084385>] ? i915_read32+0x75/0x130 [i915]
[   35.056750]  [<ffffffffa0084385>] ? i915_read32+0x75/0x130 [i915]
[   35.056788]  [<ffffffffa00bf275>] ? intel_lvds_get_config+0x45/0xb0 [i915]
[   35.056820]  [<ffffffffa00ae6ef>] check_crtc_state+0x5cf/0xa50 [i915]
[   35.056856]  [<ffffffffa00b59e5>] intel_modeset_check_state+0x2e5/0x7c0 [i915]
[   35.056887]  [<ffffffffa00bc54d>] intel_set_mode+0x2d/0x40 [i915]
[   35.056917]  [<ffffffffa00bd338>] intel_crtc_set_config+0x878/0x990 [i915]
[   35.056952]  [<ffffffffa003189b>] drm_mode_set_config_internal+0x5b/0xf0 [drm]
[   35.056978]  [<ffffffffa0032efe>] drm_mode_setcrtc+0x31e/0x5e0 [drm]
[   35.057003]  [<ffffffffa002163a>] drm_ioctl+0x3da/0x660 [drm]
[   35.057033]  [<ffffffffa0032be0>] ? drm_mode_create+0x70/0x70 [drm]
[   35.057042]  [<ffffffff812963aa>] ? file_has_perm+0xaa/0xb0
[   35.057084]  [<ffffffffa00ebbc5>] i915_compat_ioctl+0x45/0x50 [i915]
[   35.057094]  [<ffffffff811e6336>] compat_sys_ioctl+0x106/0x13a0
[   35.057104]  [<ffffffff811930d8>] ? fsnotify_access+0x68/0x80
[   35.057112]  [<ffffffff81193958>] ? vfs_read+0xd8/0x130
[   35.057119]  [<ffffffff810dd9bb>] ? __audit_syscall_exit+0x23b/0x2e0
[   35.057129]  [<ffffffff81656875>] sysenter_dispatch+0x7/0x1a
[   35.057134] ---[ end trace da13b750719727e1 ]---
[   35.057137] [drm:intel_dump_pipe_config], [CRTC:3][hw state] config for pipe A
[   35.057142] [drm:intel_dump_pipe_config], cpu_transcoder: A
[   35.057146] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[   35.057150] [drm:intel_dump_pipe_config], fdi/pch: 1, lanes: 2, gmch_m: 4858402, gmch_n: 8388608, link_m: 269911, link_n: 524288, tu: 64
[   35.057155] [drm:intel_dump_pipe_config], requested mode:
[   35.057159] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 1280 0 0 0 1024 0 0 0 0x0 0x0
[   35.057166] [drm:intel_dump_pipe_config], adjusted mode:
[   35.057169] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0xa
[   35.057175] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[   35.057179] [drm:intel_dump_pipe_config], pch pfit: pos: 0x011d0000, size: 0x05460438
[   35.057183] [drm:intel_dump_pipe_config], ips: 0
[   35.057187] [drm:intel_dump_pipe_config], [CRTC:3][sw state] config for pipe A
[   35.057190] [drm:intel_dump_pipe_config], cpu_transcoder: A
[   35.057194] [drm:intel_dump_pipe_config], pipe bpp: 18, dithering: 1
[   35.057197] [drm:intel_dump_pipe_config], fdi/pch: 1, lanes: 2, gmch_m: 4858402, gmch_n: 8388608, link_m: 269911, link_n: 524288, tu: 64
[   35.057202] [drm:intel_dump_pipe_config], requested mode:
[   35.057206] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x0 0x5
[   35.057212] [drm:intel_dump_pipe_config], adjusted mode:
[   35.057215] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 139000 1920 1980 2028 2050 1080 1090 1100 1130 0x0 0x5
[   35.057221] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[   35.057224] [drm:intel_dump_pipe_config], pch pfit: pos: 0x011d0000, size: 0x05460438
[   35.057272] [drm:intel_dump_pipe_config], ips: 0
[   35.057277] [drm:check_crtc_state], [CRTC:5]
[   35.057282] [drm:check_shared_dpll_state], PCH DPLL A
[   35.057290] [drm:check_shared_dpll_state], PCH DPLL B
[   35.058635] [drm:asle_set_backlight], bclp = 0x800000ff
[   35.058644] [drm:intel_panel_get_max_backlight], max backlight PWM = 4437
[   35.058648] [drm:intel_panel_actually_set_backlight], set backlight PWM = 4335
[   35.058653] [drm:asle_set_pwm_freq], PWM freq is not supported
[   35.061950] [drm:drm_mode_setcrtc], [CRTC:5]
[   35.061964] [drm:drm_mode_setcrtc], [CONNECTOR:14:VGA-1]
[   35.061967] [drm:intel_crtc_set_config], [CRTC:5] [FB:50] #connectors=1 (x y) (0 0)
[   35.061973] [drm:intel_set_config_compute_mode_changes], crtc has no fb, full mode set
[   35.061975] [drm:intel_set_config_compute_mode_changes], modes are different, full mode set
[   35.061976] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[   35.061978] [drm:drm_mode_debug_printmodeline], Modeline 33:"" 0 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x0 0x5
[   35.061980] [drm:intel_modeset_stage_output_state], encoder changed, full mode switch
[   35.061982] [drm:intel_modeset_stage_output_state], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[   35.061984] [drm:intel_modeset_stage_output_state], [CONNECTOR:14:VGA-1] to [CRTC:5]
[   35.061985] [drm:intel_modeset_stage_output_state], crtc changed, full mode switch
[   35.061987] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 2, prepare: 2, disable: 0
[   35.061989] [drm:connected_sink_compute_bpp], [CONNECTOR:14:VGA-1] checking for sink bpp constrains
[   35.061992] [drm:ironlake_check_fdi_lanes], checking fdi config on pipe B, lanes 2
[   35.061993] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 24, dithering: 0
[   35.061994] [drm:intel_dump_pipe_config], [CRTC:5][modeset] config for pipe B
[   35.061996] [drm:intel_dump_pipe_config], cpu_transcoder: B
[   35.061996] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[   35.061997] [drm:intel_dump_pipe_config], fdi/pch: 1, lanes: 2, gmch_m: 5033164, gmch_n: 8388608, link_m: 209715, link_n: 524288, tu: 64
[   35.061999] [drm:intel_dump_pipe_config], requested mode:
[   35.061999] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x0 0x5
[   35.062001] [drm:intel_dump_pipe_config], adjusted mode:
[   35.062002] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x0 0x5
[   35.062003] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[   35.062004] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[   35.062005] [drm:intel_dump_pipe_config], ips: 0
[   35.062023] [drm:intel_get_shared_dpll], CRTC:5 allocated PCH DPLL B
[   35.062024] [drm:intel_get_shared_dpll], using PCH DPLL B for pipe B
[   35.062024] [drm:intel_get_shared_dpll], setting up PCH DPLL B
[   35.062355] [drm:ironlake_update_plane], Writing base 02057000 00000000 0 0 5120
[   35.062360] [drm:intel_update_fbc], fbc set to per-chip default
[   35.062361] [drm:intel_update_fbc], fbc disabled per module param
[   35.062365] [drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 7, cursor: 6
[   35.062367] [drm:ironlake_check_srwm], watermark 1: display plane 13, fbc lines 3, cursor 6
[   35.062369] [drm:ironlake_check_srwm], watermark 2: display plane 16, fbc lines 3, cursor 6
[   35.062371] [drm:ironlake_check_srwm], watermark 3: display plane 77, fbc lines 3, cursor 6
[   35.062372] [drm:intel_crtc_mode_set], [ENCODER:15:DAC-15] set [MODE:0:]
[   35.062378] [drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 7, cursor: 6
[   35.062379] [drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
[   35.114395] [drm:ironlake_wait_for_vblank], vblank wait timed out
[   35.166363] [drm:ironlake_wait_for_vblank], vblank wait timed out
[   35.167193] [drm:gen6_fdi_link_train], FDI_RX_IIR 0x100
[   35.167200] [drm:gen6_fdi_link_train], FDI train 1 done.
[   35.167862] [drm:gen6_fdi_link_train], FDI_RX_IIR 0x600
[   35.167870] [drm:gen6_fdi_link_train], FDI train 2 done.
[   35.167873] [drm:gen6_fdi_link_train], FDI train done.
[   35.167877] [drm:ironlake_enable_shared_dpll], enable PCH DPLL B (active 0, on? 0)for crtc 5
[   35.167883] [drm:ironlake_enable_shared_dpll], enabling PCH DPLL B
[   35.169123] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   35.187376] [drm:intel_connector_check_state], [CONNECTOR:7:LVDS-1]
[   35.187393] [drm:intel_connector_check_state], [CONNECTOR:14:VGA-1]
[   35.187412] [drm:check_encoder_state], [ENCODER:8:LVDS-8]
[   35.187419] [drm:check_encoder_state], [ENCODER:15:DAC-15]
[   35.187424] [drm:check_encoder_state], [ENCODER:16:TMDS-16]
[   35.187430] [drm:check_encoder_state], [ENCODER:20:TMDS-20]
[   35.187436] [drm:check_encoder_state], [ENCODER:22:TMDS-22]
[   35.187440] [drm:check_encoder_state], [ENCODER:24:TMDS-24]
[   35.187446] [drm:check_encoder_state], [ENCODER:26:TMDS-26]
[   35.187451] [drm:check_encoder_state], [ENCODER:28:TMDS-28]
[   35.187457] [drm:check_crtc_state], [CRTC:3]
[   35.187481] [drm:intel_pipe_config_compare] *ERROR* mismatch in adjusted_mode.flags (expected 1, found 0)
[   35.187489] ------------[ cut here ]------------
[   35.187552] WARNING: CPU: 0 PID: 605 at drivers/gpu/drm/i915/intel_display.c:8286 check_crtc_state+0x5cf/0xa50 [i915]()
[   35.187556] pipe state doesn't match!
[   35.187558] Modules linked in: ebtable_nat xt_CHECKSUM nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 tun nf_defrag_ipv6 bridge stp llc iptable_nat nf_nat_ipv4 nf_nat iptable_mangle bnep bluetooth nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables snd_hda_codec_hdmi snd_hda_codec_conexant iTCO_wdt iTCO_vendor_support x86_pkg_temp_thermal coretemp kvm_intel kvm snd_hda_intel snd_hda_codec snd_hwdep snd_seq iwlwifi crc32c_intel snd_seq_device ghash_clmulni_intel snd_pcm cfg80211 uvcvideo videobuf2_vmalloc microcode videobuf2_memops videobuf2_core e1000e sdhci_pci videodev pcspkr serio_raw sdhci mmc_core thinkpad_acpi snd_page_alloc i2c_i801 snd_timer ptp snd
[   35.187636]  pps_core shpchp lpc_ich mfd_core tpm_tis wmi soundcore tpm rfkill tpm_bios uinput binfmt_misc firewire_ohci firewire_core crc_itu_t i915 i2c_algo_bit drm_kms_helper drm i2c_core video
[   35.187666] CPU: 0 PID: 605 Comm: X Tainted: G        W    3.11.0-mst #258
[   35.187670] Hardware name: LENOVO 4243BQ9/4243BQ9, BIOS 8AET57WW (1.37 ) 04/05/2012
[   35.187675]  000000000000205e ffff8801fede7728 ffffffff81647c9b ffff8801fede7768
[   35.187683]  ffffffff81056d6c ffff880212201478 0000000000000002 ffff8802144d5000
[   35.187690]  0000000000000001 ffff880212201478 ffff880212201000 ffff8801fede7848
[   35.187697] Call Trace:
[   35.187711]  [<ffffffff81647c9b>] dump_stack+0x6a/0x77
[   35.187723]  [<ffffffff81056d6c>] warn_slowpath_common+0x8c/0xc0
[   35.187732]  [<ffffffff81056e9e>] warn_slowpath_fmt+0x6e/0x70
[   35.187764]  [<ffffffffa0084385>] ? i915_read32+0x75/0x130 [i915]
[   35.187789]  [<ffffffffa0084385>] ? i915_read32+0x75/0x130 [i915]
[   35.187828]  [<ffffffffa00bf275>] ? intel_lvds_get_config+0x45/0xb0 [i915]
[   35.187861]  [<ffffffffa00ae6ef>] check_crtc_state+0x5cf/0xa50 [i915]
[   35.187897]  [<ffffffffa00b59e5>] intel_modeset_check_state+0x2e5/0x7c0 [i915]
[   35.187929]  [<ffffffffa00bc54d>] intel_set_mode+0x2d/0x40 [i915]
[   35.187959]  [<ffffffffa00bd338>] intel_crtc_set_config+0x878/0x990 [i915]
[   35.187993]  [<ffffffffa003189b>] drm_mode_set_config_internal+0x5b/0xf0 [drm]
[   35.188020]  [<ffffffffa0032efe>] drm_mode_setcrtc+0x31e/0x5e0 [drm]
[   35.188044]  [<ffffffffa002163a>] drm_ioctl+0x3da/0x660 [drm]
[   35.188075]  [<ffffffffa0032be0>] ? drm_mode_create+0x70/0x70 [drm]
[   35.188084]  [<ffffffff812963aa>] ? file_has_perm+0xaa/0xb0
[   35.188147]  [<ffffffffa00ebbc5>] i915_compat_ioctl+0x45/0x50 [i915]
[   35.188158]  [<ffffffff811e6336>] compat_sys_ioctl+0x106/0x13a0
[   35.188168]  [<ffffffff811930d8>] ? fsnotify_access+0x68/0x80
[   35.188176]  [<ffffffff81193958>] ? vfs_read+0xd8/0x130
[   35.188183]  [<ffffffff810dd9bb>] ? __audit_syscall_exit+0x23b/0x2e0
[   35.188193]  [<ffffffff81656875>] sysenter_dispatch+0x7/0x1a
[   35.188198] ---[ end trace da13b750719727e2 ]---
[   35.188202] [drm:intel_dump_pipe_config], [CRTC:3][hw state] config for pipe A
[   35.188207] [drm:intel_dump_pipe_config], cpu_transcoder: A
[   35.188210] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[   35.188214] [drm:intel_dump_pipe_config], fdi/pch: 1, lanes: 2, gmch_m: 4858402, gmch_n: 8388608, link_m: 269911, link_n: 524288, tu: 64
[   35.188220] [drm:intel_dump_pipe_config], requested mode:
[   35.188224] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 1280 0 0 0 1024 0 0 0 0x0 0x0
[   35.188231] [drm:intel_dump_pipe_config], adjusted mode:
[   35.188234] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0xa
[   35.188239] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[   35.188244] [drm:intel_dump_pipe_config], pch pfit: pos: 0x011d0000, size: 0x05460438
[   35.188248] [drm:intel_dump_pipe_config], ips: 0
[   35.188251] [drm:intel_dump_pipe_config], [CRTC:3][sw state] config for pipe A
[   35.188255] [drm:intel_dump_pipe_config], cpu_transcoder: A
[   35.188258] [drm:intel_dump_pipe_config], pipe bpp: 18, dithering: 1
[   35.188262] [drm:intel_dump_pipe_config], fdi/pch: 1, lanes: 2, gmch_m: 4858402, gmch_n: 8388608, link_m: 269911, link_n: 524288, tu: 64
[   35.188311] [drm:intel_dump_pipe_config], requested mode:
[   35.188314] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x0 0x5
[   35.188320] [drm:intel_dump_pipe_config], adjusted mode:
[   35.188323] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 139000 1920 1980 2028 2050 1080 1090 1100 1130 0x0 0x5
[   35.188329] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[   35.188333] [drm:intel_dump_pipe_config], pch pfit: pos: 0x011d0000, size: 0x05460438
[   35.188337] [drm:intel_dump_pipe_config], ips: 0
[   35.188340] [drm:check_crtc_state], [CRTC:5]
[   35.188363] [drm:check_shared_dpll_state], PCH DPLL A
[   35.188395] [drm:check_shared_dpll_state], PCH DPLL B
[   36.913619] [drm:asle_set_backlight], bclp = 0x800000ff
[   36.913625] [drm:intel_panel_get_max_backlight], max backlight PWM = 4437
[   36.913627] [drm:intel_panel_actually_set_backlight], set backlight PWM = 4335
[   36.913629] [drm:asle_set_pwm_freq], PWM freq is not supported
[   36.914907] [drm:asle_set_backlight], bclp = 0x800000ff
[   36.914911] [drm:intel_panel_get_max_backlight], max backlight PWM = 4437
[   36.914913] [drm:intel_panel_actually_set_backlight], set backlight PWM = 4335
[   36.914915] [drm:asle_set_pwm_freq], PWM freq is not supported
[   42.123964] systemd-journald[213]: File /var/log/journal/2b6e810f801e4f458fa97f9a3b9c8a3e/user-1000.journal corrupted or uncleanly shut down, renaming and replacing.
[   44.837333] [drm:intel_crtc_cursor_set], cursor off
[   44.837350] [drm:intel_crtc_cursor_set], cursor off
[   45.027988] [drm:intel_crtc_cursor_set], cursor off
[   45.027998] [drm:intel_crtc_cursor_set], cursor off
[   45.073569] [drm:intel_crtc_cursor_set], cursor off
[   45.073577] [drm:intel_crtc_cursor_set], cursor off
[   45.278491] [drm:intel_crtc_cursor_set], cursor off
[   45.278504] [drm:intel_crtc_cursor_set], cursor off
[   45.542351] [drm:intel_crtc_cursor_set], cursor off
[   45.542369] [drm:intel_crtc_cursor_set], cursor off
[   57.431075] [drm:intel_crtc_cursor_set], cursor off
[   57.431092] [drm:intel_crtc_cursor_set], cursor off
[   58.313538] [drm:intel_crtc_cursor_set], cursor off
[   58.313555] [drm:intel_crtc_cursor_set], cursor off
[   59.545153] [drm:intel_crtc_cursor_set], cursor off
[   59.545171] [drm:intel_crtc_cursor_set], cursor off
[   67.663884] [drm:intel_crtc_cursor_set], cursor off
[   67.663983] [drm:intel_crtc_cursor_set], cursor off
[   74.810144] [drm:intel_crtc_cursor_set], cursor off
[   74.810159] [drm:intel_crtc_cursor_set], cursor off
[   78.400204] [drm:intel_crtc_cursor_set], cursor off
[   78.400225] [drm:intel_crtc_cursor_set], cursor off
[   79.914106] [drm:intel_crtc_cursor_set], cursor off
[   79.914123] [drm:intel_crtc_cursor_set], cursor off
[   80.753957] [drm:intel_crtc_cursor_set], cursor off
[   80.753975] [drm:intel_crtc_cursor_set], cursor off
[   82.211369] [drm:intel_crtc_cursor_set], cursor off
[   82.211386] [drm:intel_crtc_cursor_set], cursor off

--envbJBWh7q8WU6mo--
