Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab3B1QYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 11:24:07 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:53792 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab3B1QX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 11:23:58 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Feb 2013 11:23:56 EST
Date: Thu, 28 Feb 2013 17:17:14 +0100
From: Nico Schottelius <nico-lkml-20130225@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [BUG] bcm5974: Mouse disappears after suspend/resume
Message-ID: <20130228161714.GV4007@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-lkml-20130225@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.7.9-1-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

for some kernel versions (probably starting around 3.5) I see that
after some amount of suspend & resume cycles, the mouse is not
visible anymore.  partly [0] and full dmesg output attached.

Hardware is the MacBook Air 4.2.

Last tested kernel is 3.7.9-1-ARCH. Now the interesting bits:

Unloading and reloading the module SEVERAL times, makes it work again:

    [15:48] brief:~# while true; do rmmod bcm5974; sleep 0.3; modprobe bcm5974; sleep 0.5; done

I need to let the loop run until I see

    [101637.155073] usbcore: registered new interface driver bcm5974

in dmesg. Afterwards I reset the mouse sensitivity using

    xinput --set-prop bcm5974 "Trackpad Sensitivity" 0.3

Does anyone spot the source of the problem / is anyone aware of a working
version?

Cheers,

Nico

[0] 

[101585.841496] X: page allocation failure: order:4, mode:0xc0d0
[101585.841500] Pid: 692, comm: X Tainted: G        W    3.7.9-1-ARCH #1
[101585.841502] Call Trace:
[101585.841509]  [<ffffffff811266d9>] warn_alloc_failed+0xe9/0x140
[101585.841513]  [<ffffffff814b3d72>] ? __alloc_pages_direct_compact+0x1b8/0x1ca
[101585.841516]  [<ffffffff8112a17f>] __alloc_pages_nodemask+0x6ef/0x960
[101585.841519]  [<ffffffff81165fd0>] alloc_pages_current+0xb0/0x120
[101585.841522]  [<ffffffff8112598e>] __get_free_pages+0xe/0x50
[101585.841526]  [<ffffffff8116cf49>] kmalloc_order_trace+0x39/0xf0
[101585.841529]  [<ffffffff8116fd8a>] __kmalloc+0x17a/0x190
[101585.841541]  [<ffffffffa04420d5>] evdev_open+0x85/0x1e0 [evdev]
[101585.841545]  [<ffffffff81188d2b>] chrdev_open+0x9b/0x1c0
[101585.841548]  [<ffffffff81182b43>] do_dentry_open+0x203/0x290
[101585.841550]  [<ffffffff81188c90>] ? cdev_put+0x30/0x30
[101585.841553]  [<ffffffff81182e85>] finish_open+0x35/0x50
[101585.841555]  [<ffffffff81192c1e>] do_last+0x31e/0xeb0
[101585.841558]  [<ffffffff8118fba8>] ? link_path_walk+0x78/0x950
[101585.841561]  [<ffffffff81122589>] ? __generic_file_aio_write+0x1b9/0x3b0
[101585.841563]  [<ffffffff8119386c>] path_openat+0xbc/0x530
[101585.841565]  [<ffffffff81194051>] do_filp_open+0x41/0xa0
[101585.841567]  [<ffffffff811a0f59>] ? __alloc_fd+0xe9/0x140
[101585.841570]  [<ffffffff81183d94>] do_sys_open+0xf4/0x1e0
[101585.841573]  [<ffffffff81183ea1>] sys_open+0x21/0x30
[101585.841577]  [<ffffffff814c365d>] system_call_fastpath+0x1a/0x1f
[101585.841578] Mem-Info:
[101585.841579] Node 0 DMA per-cpu:
[101585.841581] CPU    0: hi:    0, btch:   1 usd:   0
[101585.841582] CPU    1: hi:    0, btch:   1 usd:   0
[101585.841584] CPU    2: hi:    0, btch:   1 usd:   0
[101585.841585] CPU    3: hi:    0, btch:   1 usd:   0
[101585.841586] Node 0 DMA32 per-cpu:
[101585.841588] CPU    0: hi:  186, btch:  31 usd:   0
[101585.841589] CPU    1: hi:  186, btch:  31 usd:   0
[101585.841590] CPU    2: hi:  186, btch:  31 usd:   0
[101585.841591] CPU    3: hi:  186, btch:  31 usd:   0
[101585.841592] Node 0 Normal per-cpu:
[101585.841593] CPU    0: hi:  186, btch:  31 usd:   0
[101585.841595] CPU    1: hi:  186, btch:  31 usd:  42
[101585.841596] CPU    2: hi:  186, btch:  31 usd:   0
[101585.841597] CPU    3: hi:  186, btch:  31 usd:   0
[101585.841600] active_anon:177056 inactive_anon:185005 isolated_anon:0
 active_file:209006 inactive_file:216379 isolated_file:0
 unevictable:3185 dirty:242 writeback:0 unstable:0
 free:98036 slab_reclaimable:63082 slab_unreclaimable:8364
 mapped:38372 shmem:75471 pagetables:8538 bounce:0
 free_cma:0
[101585.841603] Node 0 DMA free:15360kB min:252kB low:312kB high:376kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15104kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[101585.841607] lowmem_reserve[]: 0 2137 3899 3899
[101585.841610] Node 0 DMA32 free:324604kB min:36904kB low:46128kB high:55356kB active_anon:210168kB inactive_anon:238856kB active_file:575428kB inactive_file:604712kB unevictable:1692kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:1692kB dirty:724kB writeback:0kB mapped:71080kB shmem:118084kB slab_reclaimable:206552kB slab_unreclaimable:7012kB kernel_stack:1824kB pagetables:6576kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[101585.841614] lowmem_reserve[]: 0 0 1762 1762
[101585.841616] Node 0 Normal free:52180kB min:30420kB low:38024kB high:45628kB active_anon:498056kB inactive_anon:501164kB active_file:260596kB inactive_file:260804kB unevictable:11048kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:11048kB dirty:244kB writeback:0kB mapped:82408kB shmem:183800kB slab_reclaimable:45776kB slab_unreclaimable:26444kB kernel_stack:1632kB pagetables:27576kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:28 all_unreclaimable? no
[101585.841620] lowmem_reserve[]: 0 0 0 0
[101585.841623] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15360kB
[101585.841629] Node 0 DMA32: 16067*4kB 19303*8kB 5883*16kB 365*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 324564kB
[101585.841634] Node 0 Normal: 11027*4kB 497*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 52180kB
[101585.841640] 522097 total pagecache pages
[101585.841641] 20384 pages in swap cache
[101585.841643] Swap cache stats: add 6262319, delete 6241935, find 2616629/3353715
[101585.841644] Free swap  = 8055800kB
[101585.841645] Total swap = 8386556kB
[101585.851330] 1048048 pages RAM
[101585.851339] 57808 pages reserved
[101585.851345] 1273115 pages shared
[101585.851350] 790534 pages non-shared



-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0

--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.mouse-does-not-work-3.7.5-1-ARCH"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.7.5-1-ARCH (tobias@T-POWA-LX) (gcc version 4.7.2 (GCC) ) #1 SMP PREEMPT Mon Jan 28 10:03:32 CET 2013
[    0.000000] Command line: root=/dev/mapper/root cryptdevice=/dev/sda5:root ro i915.i915_enable_rc6=1 initrd=../initramfs-linux.img BOOT_IMAGE=../vmlinuz-linux 
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000008dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000008e000-0x000000000008ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000090000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x000000003fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040000000-0x00000000401fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040200000-0x000000008ad23fff] usable
[    0.000000] BIOS-e820: [mem 0x000000008ad24000-0x000000008ad5efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000008ad5f000-0x000000008afa1fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000008afa2000-0x000000008affefff] reserved
[    0.000000] BIOS-e820: [mem 0x000000008afff000-0x000000008affffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000008b000000-0x000000008f9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed18000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000016fdfffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Apple Inc. MacBookAir4,2/Mac-742912EFDBEE19B3, BIOS MBA41.88Z.0077.B0E.1110141154 10/14/2011
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x16fe00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   1 base 0A0000000 mask FE0000000 uncachable
[    0.000000]   2 base 090000000 mask FF0000000 uncachable
[    0.000000]   3 base 08C000000 mask FFC000000 uncachable
[    0.000000]   4 base 08B800000 mask FFF800000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0x8ad24 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] reserving inaccessible SNB gfx pages
[    0.000000] init_memory_mapping: [mem 0x00000000-0x8ad23fff]
[    0.000000]  [mem 0x00000000-0x8abfffff] page 2M
[    0.000000]  [mem 0x8ac00000-0x8ad23fff] page 4k
[    0.000000] kernel direct mapping tables up to 0x8ad23fff @ [mem 0x1fc8f000-0x1fc93fff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x16fdfffff]
[    0.000000]  [mem 0x100000000-0x16fdfffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x16fdfffff @ [mem 0x8ad21000-0x8ad23fff]
[    0.000000] RAMDISK: [mem 0x1fc94000-0x1fffefff]
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 APPLE )
[    0.000000] ACPI: XSDT 000000008ad8e1c0 000AC (v01 APPLE   Apple00 00000060      01000013)
[    0.000000] ACPI: FACP 000000008ad8c000 000F4 (v04 APPLE   Apple00 00000060 Loki 0000005F)
[    0.000000] ACPI: DSDT 000000008ad81000 05050 (v01 APPLE  MacBookA 00040001 INTL 20100915)
[    0.000000] ACPI: FACS 000000008ad3e000 00040
[    0.000000] ACPI: HPET 000000008ad8b000 00038 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: APIC 000000008ad8a000 000BC (v02 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SBST 000000008ad88000 00030 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: ECDT 000000008ad87000 00053 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SSDT 000000008ad7d000 00024 (v01 APPLE   SmcDppt 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad7b000 006CA (v01 APPLE     UsbSD 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad77000 00159 (v02 APPLE     IGHda 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad73000 015EB (v02 APPLE  SsdtIGPU 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad72000 00569 (v01  PmRef  Cpu0Ist 00003000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad71000 009B1 (v01  PmRef    CpuPm 00003000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad70000 00315 (v01  PmRef  Cpu0Tst 00003000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad6f000 0037A (v01  PmRef    ApTst 00003000 INTL 20100915)
[    0.000000] ACPI: MCFG 000000008ad89000 0003C (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SSDT 000000008ad80000 000FA (v01 SataRe  SataPri 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad7f000 000D0 (v01 SataRe  SataSec 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad7e000 00032 (v01  Apple   SsdtS3 00001000 INTL 20100915)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000016fdfffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x16fdfffff]
[    0.000000]   NODE_DATA [mem 0x16fdfc000-0x16fdfffff]
[    0.000000]  [ffffea0000000000-ffffea0005bfffff] PMD -> [ffff88016b400000-ffff88016f3fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x16fdfffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0008dfff]
[    0.000000]   node   0: [mem 0x00090000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x3fffffff]
[    0.000000]   node   0: [mem 0x40200000-0x8ad23fff]
[    0.000000]   node   0: [mem 0x100000000-0x16fdfffff]
[    0.000000] On node 0 totalpages: 1025713
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 141 pages reserved
[    0.000000]   DMA zone: 3776 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 547172 pages, LIFO batch:31
[    0.000000]   Normal zone: 7160 pages used for memmap
[    0.000000]   Normal zone: 451080 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000008e000 - 0000000000090000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] PM: Registered nosave memory: 0000000040000000 - 0000000040200000
[    0.000000] PM: Registered nosave memory: 000000008ad24000 - 000000008ad5f000
[    0.000000] PM: Registered nosave memory: 000000008ad5f000 - 000000008afa2000
[    0.000000] PM: Registered nosave memory: 000000008afa2000 - 000000008afff000
[    0.000000] PM: Registered nosave memory: 000000008afff000 - 000000008b000000
[    0.000000] PM: Registered nosave memory: 000000008b000000 - 000000008fa00000
[    0.000000] PM: Registered nosave memory: 000000008fa00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed04000
[    0.000000] PM: Registered nosave memory: 00000000fed04000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff800000
[    0.000000] PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
[    0.000000] e820: [mem 0x8fa00000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88016fa00000 s84608 r8192 d21888 u262144
[    0.000000] pcpu-alloc: s84608 r8192 d21888 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1002028
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/mapper/root cryptdevice=/dev/sda5:root ro i915.i915_enable_rc6=1 initrd=../initramfs-linux.img BOOT_IMAGE=../vmlinuz-linux 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 3954856k/6027264k available (4883k kernel code, 1924412k absent, 147996k reserved, 4030k data, 812k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=8.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 16777216 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.003333] tsc: Detected 1800.048 MHz processor
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 3601.10 BogoMIPS (lpj=6000160)
[    0.000006] pid_max: default: 32768 minimum: 301
[    0.000043] Security Framework initialized
[    0.000051] AppArmor: AppArmor disabled by boot time parameter
[    0.000381] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.001464] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.001918] Mount-cache hash table entries: 256
[    0.002137] Initializing cgroup subsys cpuacct
[    0.002140] Initializing cgroup subsys memory
[    0.002148] Initializing cgroup subsys devices
[    0.002150] Initializing cgroup subsys freezer
[    0.002151] Initializing cgroup subsys net_cls
[    0.002153] Initializing cgroup subsys blkio
[    0.002182] CPU: Physical Processor ID: 0
[    0.002183] CPU: Processor Core ID: 0
[    0.002189] mce: CPU supports 7 MCE banks
[    0.002204] CPU0: Thermal monitoring enabled (TM1)
[    0.002213] process: using mwait in idle threads
[    0.002217] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
tlb_flushall_shift: 5
[    0.002399] Freeing SMP alternatives: 16k freed
[    0.003940] ACPI: Core revision 20120913
[    0.011958] ftrace: allocating 18793 entries in 74 pages
[    0.024492] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.057447] smpboot: CPU0: Intel(R) Core(TM) i7-2677M CPU @ 1.80GHz (fam: 06, model: 2a, stepping: 07)
[    0.162561] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
[    0.162568] perf_event_intel: PEBS disabled due to CPU errata, please upgrade microcode
[    0.162570] ... version:                3
[    0.162571] ... bit width:              48
[    0.162573] ... generic registers:      4
[    0.162574] ... value mask:             0000ffffffffffff
[    0.162576] ... max period:             000000007fffffff
[    0.162577] ... fixed-purpose events:   3
[    0.162578] ... event mask:             000000070000000f
[    0.202464] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.189264] smpboot: Booting Node   0, Processors  #1 #2 #3
[    0.242425] Brought up 4 CPUs
[    0.242429] smpboot: Total of 4 processors activated (14406.40 BogoMIPS)
[    0.247354] devtmpfs: initialized
[    0.248518] PM: Registering ACPI NVS region [mem 0x8ad24000-0x8ad5efff] (241664 bytes)
[    0.249372] RTC time: 16:54:07, date: 02/11/13
[    0.249420] NET: Registered protocol family 16
[    0.249574] ACPI: bus type pci registered
[    0.249654] PCI: MMCONFIG for domain 0000 [bus 00-97] at [mem 0xe0000000-0xe97fffff] (base 0xe0000000)
[    0.249658] PCI: MMCONFIG at [mem 0xe0000000-0xe97fffff] reserved in E820
[    0.270604] PCI: Using configuration type 1 for base access
[    0.271244] bio: create slab <bio-0> at 0
[    0.271306] ACPI: Added _OSI(Module Device)
[    0.271308] ACPI: Added _OSI(Processor Device)
[    0.271309] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.271311] ACPI: Added _OSI(Processor Aggregator Device)
[    0.272812] ACPI: EC: EC description table is found, configuring boot EC
[    0.278848] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.279379] ACPI: SSDT 000000008ad39190 00781 (v01  PmRef  Cpu0Cst 00003001 INTL 20100915)
[    0.279773] ACPI: Dynamic OEM Table Load:
[    0.279776] ACPI: SSDT           (null) 00781 (v01  PmRef  Cpu0Cst 00003001 INTL 20100915)
[    0.280118] ACPI: SSDT 000000008ad3a710 003A4 (v01  PmRef    ApIst 00003000 INTL 20100915)
[    0.280563] ACPI: Dynamic OEM Table Load:
[    0.280566] ACPI: SSDT           (null) 003A4 (v01  PmRef    ApIst 00003000 INTL 20100915)
[    0.289044] ACPI: SSDT 000000008ad38d90 00119 (v01  PmRef    ApCst 00003000 INTL 20100915)
[    0.289432] ACPI: Dynamic OEM Table Load:
[    0.289434] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20100915)
[    0.306118] ACPI: Interpreter enabled
[    0.306123] ACPI: (supports S0 S3 S4 S5)
[    0.306143] ACPI: Using IOAPIC for interrupt routing
[    0.348836] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.349022] ACPI: No dock devices found.
[    0.349026] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.349380] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.349906] pci_root PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-97] only partially covers this bridge
[    0.349940] PCI host bridge to bus 0000:00
[    0.349943] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.349946] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.349948] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.349951] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.349953] pci_bus 0000:00: root bus resource [mem 0x8fa00000-0xfeafffff]
[    0.349955] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    0.349965] pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
[    0.350010] pci 0000:00:01.0: [8086:0101] type 01 class 0x060400
[    0.350049] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.350078] pci 0000:00:02.0: [8086:0116] type 00 class 0x030000
[    0.350091] pci 0000:00:02.0: reg 10: [mem 0xa0000000-0xa03fffff 64bit]
[    0.350099] pci 0000:00:02.0: reg 18: [mem 0x90000000-0x9fffffff 64bit pref]
[    0.350105] pci 0000:00:02.0: reg 20: [io  0x2000-0x203f]
[    0.350185] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.350210] pci 0000:00:16.0: reg 10: [mem 0xa0607100-0xa060710f 64bit]
[    0.350295] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.350338] pci 0000:00:1a.0: [8086:1c2c] type 00 class 0x0c0300
[    0.350387] pci 0000:00:1a.0: reg 20: [io  0x2140-0x215f]
[    0.350462] pci 0000:00:1a.7: [8086:1c2d] type 00 class 0x0c0320
[    0.350487] pci 0000:00:1a.7: reg 10: [mem 0xa0606c00-0xa0606fff]
[    0.350587] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.350617] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.350637] pci 0000:00:1b.0: reg 10: [mem 0xa0600000-0xa0603fff 64bit]
[    0.350714] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.350744] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.350875] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.350918] pci 0000:00:1c.1: [8086:1c12] type 01 class 0x060400
[    0.351050] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.351097] pci 0000:00:1d.0: [8086:1c27] type 00 class 0x0c0300
[    0.351146] pci 0000:00:1d.0: reg 20: [io  0x20e0-0x20ff]
[    0.351222] pci 0000:00:1d.7: [8086:1c26] type 00 class 0x0c0320
[    0.351246] pci 0000:00:1d.7: reg 10: [mem 0xa0606800-0xa0606bff]
[    0.351347] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.351376] pci 0000:00:1f.0: [8086:1c4d] type 00 class 0x060100
[    0.351511] pci 0000:00:1f.2: [8086:1c01] type 00 class 0x01018f
[    0.351529] pci 0000:00:1f.2: reg 10: [io  0x2168-0x216f]
[    0.351540] pci 0000:00:1f.2: reg 14: [io  0x217c-0x217f]
[    0.351551] pci 0000:00:1f.2: reg 18: [io  0x2160-0x2167]
[    0.351561] pci 0000:00:1f.2: reg 1c: [io  0x2178-0x217b]
[    0.351572] pci 0000:00:1f.2: reg 20: [io  0x2060-0x206f]
[    0.351581] pci 0000:00:1f.2: reg 24: [io  0xffe0-0xffef]
[    0.351635] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.351654] pci 0000:00:1f.3: reg 10: [mem 0xa0607000-0xa06070ff 64bit]
[    0.351678] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    0.351749] pci 0000:03:00.0: [8086:151a] type 01 class 0x060400
[    0.351815] pci 0000:03:00.0: supports D1 D2
[    0.351817] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.355613] pci 0000:00:01.0: PCI bridge to [bus 03-97]
[    0.355621] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    0.355628] pci 0000:00:01.0:   bridge window [mem 0xa0700000-0xa49fffff]
[    0.355638] pci 0000:00:01.0:   bridge window [mem 0xa4a00000-0xa89fffff 64bit pref]
[    0.355696] pci 0000:04:00.0: [8086:151a] type 01 class 0x060400
[    0.355764] pci 0000:04:00.0: supports D1 D2
[    0.355766] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.355803] pci 0000:04:03.0: [8086:151a] type 01 class 0x060400
[    0.355870] pci 0000:04:03.0: supports D1 D2
[    0.355872] pci 0000:04:03.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.355902] pci 0000:04:04.0: [8086:151a] type 01 class 0x060400
[    0.355969] pci 0000:04:04.0: supports D1 D2
[    0.355971] pci 0000:04:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.356016] pci 0000:03:00.0: PCI bridge to [bus 04-67]
[    0.356024] pci 0000:03:00.0:   bridge window [mem 0xa0700000-0xa09fffff]
[    0.356084] pci 0000:05:00.0: [8086:151a] type 00 class 0x088000
[    0.356099] pci 0000:05:00.0: reg 10: [mem 0xa0700000-0xa073ffff]
[    0.356111] pci 0000:05:00.0: reg 14: [mem 0xa0740000-0xa0740fff]
[    0.356213] pci 0000:05:00.0: supports D1 D2
[    0.356215] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.362270] pci 0000:04:00.0: PCI bridge to [bus 05]
[    0.362285] pci 0000:04:00.0:   bridge window [mem 0xa0700000-0xa07fffff]
[    0.362343] pci 0000:04:03.0: PCI bridge to [bus 06-36]
[    0.362351] pci 0000:04:03.0:   bridge window [mem 0xa0800000-0xa08fffff]
[    0.362395] pci 0000:04:04.0: PCI bridge to [bus 37-67]
[    0.362403] pci 0000:04:04.0:   bridge window [mem 0xa0900000-0xa09fffff]
[    0.362496] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.362506] pci 0000:00:1c.0:   bridge window [mem 0xa0500000-0xa05fffff]
[    0.362663] pci 0000:02:00.0: [14e4:4353] type 00 class 0x028000
[    0.362714] pci 0000:02:00.0: reg 10: [mem 0xa0400000-0xa0403fff 64bit]
[    0.362981] pci 0000:02:00.0: supports D1 D2
[    0.362983] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.368975] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.368982] pci 0000:00:1c.1:   bridge window [mem 0xa0400000-0xa04fffff]
[    0.369006] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.369109] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    0.369203] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.369310]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.369446]  pci0000:00: ACPI _OSC control (0x19) granted
[    0.372631] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.372682] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.372728] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.372774] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.372819] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.372865] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.372910] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.372955] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.373051] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.373056] vgaarb: loaded
[    0.373058] vgaarb: bridge control possible 0000:00:02.0
[    0.373100] PCI: Using ACPI for IRQ routing
[    0.377174] PCI: pci_cache_line_size set to 64 bytes
[    0.377314] e820: reserve RAM buffer [mem 0x0008e000-0x0008ffff]
[    0.377317] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.377318] e820: reserve RAM buffer [mem 0x8ad24000-0x8bffffff]
[    0.377320] e820: reserve RAM buffer [mem 0x16fe00000-0x16fffffff]
[    0.377418] NetLabel: Initializing
[    0.377419] NetLabel:  domain hash size = 128
[    0.377420] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.377434] NetLabel:  unlabeled traffic allowed by default
[    0.377456] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.377462] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.379475] Switching to clocksource hpet
[    0.384603] pnp: PnP ACPI init
[    0.384620] ACPI: bus type pnp registered
[    0.384927] pnp 00:00: [bus 00-ff]
[    0.384930] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.384933] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.384935] pnp 00:00: [io  0x0d00-0xffff window]
[    0.384938] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.384940] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.384942] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.384944] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.384947] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.384949] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.384951] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.384953] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.384955] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.384958] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.384960] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.384962] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.384964] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.384966] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.384969] pnp 00:00: [mem 0x8fa00000-0xfeafffff window]
[    0.384971] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.385009] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.385096] pnp 00:01: [io  0x0000-0x001f]
[    0.385098] pnp 00:01: [io  0x0081-0x0091]
[    0.385100] pnp 00:01: [io  0x0093-0x009f]
[    0.385103] pnp 00:01: [io  0x00c0-0x00df]
[    0.385105] pnp 00:01: [dma 4]
[    0.385127] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.385136] pnp 00:02: [mem 0xff000000-0xffffffff]
[    0.385158] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.385235] pnp 00:03: [irq 0 disabled]
[    0.385245] pnp 00:03: [irq 8]
[    0.385247] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.385284] system 00:03: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.385288] system 00:03: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    0.385299] pnp 00:04: [io  0x00f0]
[    0.385305] pnp 00:04: [irq 13]
[    0.385327] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.385337] pnp 00:05: [io  0x002e-0x002f]
[    0.385339] pnp 00:05: [io  0x004e-0x004f]
[    0.385341] pnp 00:05: [io  0x0061]
[    0.385343] pnp 00:05: [io  0x0063]
[    0.385345] pnp 00:05: [io  0x0065]
[    0.385347] pnp 00:05: [io  0x0067]
[    0.385349] pnp 00:05: [io  0x0080]
[    0.385351] pnp 00:05: [io  0x0092]
[    0.385353] pnp 00:05: [io  0x00b2-0x00b3]
[    0.385355] pnp 00:05: [io  0x1000-0x100f]
[    0.385359] pnp 00:05: [io  0x0400-0x047f]
[    0.385361] pnp 00:05: [io  0x0500-0x057f]
[    0.385393] system 00:05: [io  0x1000-0x100f] has been reserved
[    0.385396] system 00:05: [io  0x0400-0x047f] has been reserved
[    0.385399] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.385402] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.385410] pnp 00:06: [io  0x0070-0x0077]
[    0.385432] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.385443] pnp 00:07: [io  0x0300-0x031f]
[    0.385449] pnp 00:07: [irq 6]
[    0.385470] pnp 00:07: Plug and Play ACPI device, IDs APP0001 (active)
[    0.385629] pnp 00:08: [mem 0xfed1c000-0xfed1ffff]
[    0.385632] pnp 00:08: [mem 0xfed10000-0xfed17fff]
[    0.385634] pnp 00:08: [mem 0xfed18000-0xfed18fff]
[    0.385636] pnp 00:08: [mem 0xfed19000-0xfed19fff]
[    0.385638] pnp 00:08: [mem 0xe0000000-0xefffffff]
[    0.385640] pnp 00:08: [mem 0xfed20000-0xfed3ffff]
[    0.385642] pnp 00:08: [mem 0xfed90000-0xfed93fff]
[    0.385644] pnp 00:08: [mem 0xfed45000-0xfed8ffff]
[    0.385646] pnp 00:08: [mem 0xff000000-0xffffffff]
[    0.385648] pnp 00:08: [mem 0xfee00000-0xfeefffff]
[    0.385651] pnp 00:08: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.385689] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.385692] system 00:08: [mem 0xfed10000-0xfed17fff] could not be reserved
[    0.385694] system 00:08: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.385697] system 00:08: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.385699] system 00:08: [mem 0xe0000000-0xefffffff] has been reserved
[    0.385702] system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.385704] system 00:08: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.385707] system 00:08: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.385709] system 00:08: [mem 0xff000000-0xffffffff] could not be reserved
[    0.385712] system 00:08: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.385716] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.391279] pnp 00:09: [mem 0x20000000-0x201fffff]
[    0.391282] pnp 00:09: [mem 0x40000000-0x401fffff]
[    0.391323] system 00:09: [mem 0x20000000-0x201fffff] has been reserved
[    0.391326] system 00:09: [mem 0x40000000-0x401fffff] has been reserved
[    0.391329] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.391339] pnp: PnP ACPI: found 10 devices
[    0.391341] ACPI: ACPI bus type pnp unregistered
[    0.398215] pci 0000:04:03.0: bridge window [io  0x1000-0x0fff] to [bus 06-36] add_size 1000
[    0.398219] pci 0000:04:03.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 06-36] add_size 200000
[    0.398229] pci 0000:04:04.0: bridge window [io  0x1000-0x0fff] to [bus 37-67] add_size 1000
[    0.398231] pci 0000:04:04.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 37-67] add_size 200000
[    0.398240] pci 0000:04:03.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.398243] pci 0000:04:04.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.398246] pci 0000:03:00.0: bridge window [io  0x1000-0x0fff] to [bus 04-67] add_size 2000
[    0.398249] pci 0000:04:03.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.398251] pci 0000:04:04.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.398254] pci 0000:03:00.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 04-67] add_size 400000
[    0.398287] pci 0000:03:00.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 400000
[    0.398290] pci 0000:03:00.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 2000
[    0.398294] pci 0000:03:00.0: BAR 15: assigned [mem 0xa4a00000-0xa4dfffff 64bit pref]
[    0.398297] pci 0000:03:00.0: BAR 13: can't assign io (size 0x2000)
[    0.398301] pci 0000:03:00.0: BAR 15: assigned [mem 0xa4a00000-0xa4dfffff 64bit pref]
[    0.398303] pci 0000:03:00.0: BAR 13: can't assign io (size 0x2000)
[    0.398307] pci 0000:04:03.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.398310] pci 0000:04:04.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.398312] pci 0000:04:03.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.398315] pci 0000:04:04.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.398317] pci 0000:04:03.0: BAR 15: assigned [mem 0xa4a00000-0xa4bfffff 64bit pref]
[    0.398320] pci 0000:04:04.0: BAR 15: assigned [mem 0xa4c00000-0xa4dfffff 64bit pref]
[    0.398323] pci 0000:04:03.0: BAR 13: can't assign io (size 0x1000)
[    0.398325] pci 0000:04:04.0: BAR 13: can't assign io (size 0x1000)
[    0.398328] pci 0000:04:04.0: BAR 15: assigned [mem 0xa4a00000-0xa4bfffff 64bit pref]
[    0.398331] pci 0000:04:04.0: BAR 13: can't assign io (size 0x1000)
[    0.398333] pci 0000:04:03.0: BAR 15: assigned [mem 0xa4c00000-0xa4dfffff 64bit pref]
[    0.398336] pci 0000:04:03.0: BAR 13: can't assign io (size 0x1000)
[    0.398338] pci 0000:04:00.0: PCI bridge to [bus 05]
[    0.398344] pci 0000:04:00.0:   bridge window [mem 0xa0700000-0xa07fffff]
[    0.398352] pci 0000:04:03.0: PCI bridge to [bus 06-36]
[    0.398357] pci 0000:04:03.0:   bridge window [mem 0xa0800000-0xa08fffff]
[    0.398361] pci 0000:04:03.0:   bridge window [mem 0xa4c00000-0xa4dfffff 64bit pref]
[    0.398367] pci 0000:04:04.0: PCI bridge to [bus 37-67]
[    0.398372] pci 0000:04:04.0:   bridge window [mem 0xa0900000-0xa09fffff]
[    0.398376] pci 0000:04:04.0:   bridge window [mem 0xa4a00000-0xa4bfffff 64bit pref]
[    0.398382] pci 0000:03:00.0: PCI bridge to [bus 04-67]
[    0.398387] pci 0000:03:00.0:   bridge window [mem 0xa0700000-0xa09fffff]
[    0.398391] pci 0000:03:00.0:   bridge window [mem 0xa4a00000-0xa4dfffff 64bit pref]
[    0.398397] pci 0000:00:01.0: PCI bridge to [bus 03-97]
[    0.398400] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    0.398403] pci 0000:00:01.0:   bridge window [mem 0xa0700000-0xa49fffff]
[    0.398407] pci 0000:00:01.0:   bridge window [mem 0xa4a00000-0xa89fffff 64bit pref]
[    0.398411] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.398419] pci 0000:00:1c.0:   bridge window [mem 0xa0500000-0xa05fffff]
[    0.398432] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.398439] pci 0000:00:1c.1:   bridge window [mem 0xa0400000-0xa04fffff]
[    0.398475] pci 0000:04:03.0: enabling device (0000 -> 0002)
[    0.398486] pci 0000:04:04.0: enabling device (0000 -> 0002)
[    0.398496] pci 0000:00:1c.0: enabling device (0000 -> 0002)
[    0.398514] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.398516] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.398519] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.398521] pci_bus 0000:00: resource 7 [mem 0x8fa00000-0xfeafffff]
[    0.398523] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
[    0.398526] pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
[    0.398528] pci_bus 0000:03: resource 1 [mem 0xa0700000-0xa49fffff]
[    0.398530] pci_bus 0000:03: resource 2 [mem 0xa4a00000-0xa89fffff 64bit pref]
[    0.398532] pci_bus 0000:04: resource 1 [mem 0xa0700000-0xa09fffff]
[    0.398535] pci_bus 0000:04: resource 2 [mem 0xa4a00000-0xa4dfffff 64bit pref]
[    0.398537] pci_bus 0000:05: resource 1 [mem 0xa0700000-0xa07fffff]
[    0.398540] pci_bus 0000:06: resource 1 [mem 0xa0800000-0xa08fffff]
[    0.398542] pci_bus 0000:06: resource 2 [mem 0xa4c00000-0xa4dfffff 64bit pref]
[    0.398544] pci_bus 0000:37: resource 1 [mem 0xa0900000-0xa09fffff]
[    0.398546] pci_bus 0000:37: resource 2 [mem 0xa4a00000-0xa4bfffff 64bit pref]
[    0.398549] pci_bus 0000:01: resource 1 [mem 0xa0500000-0xa05fffff]
[    0.398551] pci_bus 0000:02: resource 1 [mem 0xa0400000-0xa04fffff]
[    0.398585] NET: Registered protocol family 2
[    0.399294] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.400814] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.400969] TCP: Hash tables configured (established 524288 bind 65536)
[    0.400995] TCP: reno registered
[    0.401006] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.401025] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.401114] NET: Registered protocol family 1
[    0.401130] pci 0000:00:02.0: Boot video device
[    0.401542] PCI: CLS 256 bytes, default 64
[    0.401589] Unpacking initramfs...
[    0.482429] Freeing initrd memory: 3500k freed
[    0.482952] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.482958] software IO TLB [mem 0x86d21000-0x8ad20fff] (64MB) mapped at [ffff880086d21000-ffff88008ad20fff]
[    0.483393] audit: initializing netlink socket (disabled)
[    0.483410] type=2000 audit(1360601647.376:1): initialized
[    0.498742] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.500427] VFS: Disk quotas dquot_6.5.2
[    0.500478] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.500658] msgmni has been set to 7731
[    0.500915] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.500949] io scheduler noop registered
[    0.500953] io scheduler deadline registered
[    0.500992] io scheduler cfq registered (default)
[    0.501103] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.501323] pcieport 0000:03:00.0: irq 41 for MSI/MSI-X
[    0.501431] pcieport 0000:04:00.0: irq 42 for MSI/MSI-X
[    0.501539] pcieport 0000:04:03.0: irq 43 for MSI/MSI-X
[    0.501646] pcieport 0000:04:04.0: irq 44 for MSI/MSI-X
[    0.501807] intel_idle: MWAIT substates: 0x21120
[    0.501809] intel_idle: v0.4 model 0x2A
[    0.501811] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.501847] GHES: HEST is not enabled!
[    0.501903] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.502372] Linux agpgart interface v0.103
[    0.502445] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.548038] tsc: Refined TSC clocksource calibration: 1800.015 MHz
[    1.548044] Switching to clocksource tsc
[    1.548940] i8042: No controller found
[    1.549078] mousedev: PS/2 mouse device common for all mice
[    1.549124] rtc_cmos 00:06: RTC can wake from S4
[    1.549253] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    1.549285] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    1.549378] cpuidle: using governor ladder
[    1.549497] cpuidle: using governor menu
[    1.549546] drop_monitor: Initializing network drop monitor service
[    1.549625] TCP: cubic registered
[    1.549734] NET: Registered protocol family 10
[    1.549894] NET: Registered protocol family 17
[    1.549904] Key type dns_resolver registered
[    1.550163] PM: Hibernation image not present or could not be loaded.
[    1.550173] registered taskstats version 1
[    1.550850]   Magic number: 1:389:944
[    1.550862] tty tty1: hash matches
[    1.550916] rtc_cmos 00:06: setting system clock to 2013-02-11 16:54:08 UTC (1360601648)
[    1.552756] Freeing unused kernel memory: 812k freed
[    1.552871] Write protecting the kernel read-only data: 8192k
[    1.557206] Freeing unused kernel memory: 1248k freed
[    1.559006] Freeing unused kernel memory: 476k freed
[    1.567308] systemd-udevd[57]: starting version 197
[    1.595551] ACPI: bus type usb registered
[    1.595592] usbcore: registered new interface driver usbfs
[    1.595609] usbcore: registered new interface driver hub
[    1.596169] usbcore: registered new device driver usb
[    1.596631] SCSI subsystem initialized
[    1.597919] ACPI: bus type scsi registered
[    1.597957] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.598028] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.598035] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.598047] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.598072] ehci_hcd 0000:00:1a.7: debug port 2
[    1.598188] libata version 3.00 loaded.
[    1.601969] ehci_hcd 0000:00:1a.7: cache line size of 256 is not supported
[    1.601990] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xa0606c00
[    1.610937] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.611887] hub 1-0:1.0: USB hub found
[    1.611897] hub 1-0:1.0: 6 ports detected
[    1.612778] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.612783] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.612791] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    1.612806] ehci_hcd 0000:00:1d.7: debug port 2
[    1.616716] ehci_hcd 0000:00:1d.7: cache line size of 256 is not supported
[    1.616735] ehci_hcd 0000:00:1d.7: irq 22, io mem 0xa0606800
[    1.624235] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.624478] hub 2-0:1.0: USB hub found
[    1.624483] hub 2-0:1.0: 8 ports detected
[    1.624954] ata_piix 0000:00:1f.2: version 2.13
[    1.624972] ata_piix 0000:00:1f.2: MAP [
[    1.624974]  P0 P2 P1 P3 ]
[    1.625515] uhci_hcd: USB Universal Host Controller Interface driver
[    1.777428] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.777864] scsi0 : ata_piix
[    1.778104] scsi1 : ata_piix
[    1.778234] ata1: SATA max UDMA/133 cmd 0x2168 ctl 0x217c bmdma 0x2060 irq 19
[    1.778240] ata2: SATA max UDMA/133 cmd 0x2160 ctl 0x2178 bmdma 0x2068 irq 19
[    1.778296] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.778302] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.778313] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.778360] uhci_hcd 0000:00:1a.0: irq 21, io base 0x00002140
[    1.778584] hub 3-0:1.0: USB hub found
[    1.778591] hub 3-0:1.0: 2 ports detected
[    1.778699] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.778704] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.778709] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    1.778736] uhci_hcd 0000:00:1d.0: irq 19, io base 0x000020e0
[    1.778956] hub 4-0:1.0: USB hub found
[    1.778961] hub 4-0:1.0: 2 ports detected
[    1.917197] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    2.040902] hub 1-1:1.0: USB hub found
[    2.041005] hub 1-1:1.0: 3 ports detected
[    2.146842] usb 1-2: new high-speed USB device number 3 using ehci_hcd
[    2.389790] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    2.513943] hub 2-1:1.0: USB hub found
[    2.513987] hub 2-1:1.0: 2 ports detected
[    2.592937] usb 1-1.1: new full-speed USB device number 4 using ehci_hcd
[    2.691963] hub 1-1.1:1.0: USB hub found
[    2.692110] hub 1-1.1:1.0: 3 ports detected
[    2.772661] usb 1-1.2: new full-speed USB device number 5 using ehci_hcd
[    2.799153] ata2.00: failed to resume link (SControl 0)
[    2.955759] usb 2-1.1: new high-speed USB device number 3 using ehci_hcd
[    3.058989] Initializing USB Mass Storage driver...
[    3.059156] scsi2 : usb-storage 2-1.1:1.0
[    3.059245] usbcore: registered new interface driver usb-storage
[    3.059247] USB Mass Storage support registered.
[    3.118652] ata1.01: failed to resume link (SControl 0)
[    3.122281] usb 1-1.1.1: new full-speed USB device number 6 using ehci_hcd
[    3.216064] usbcore: registered new interface driver usbhid
[    3.216069] usbhid: USB HID core driver
[    3.271816] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.271831] ata1.01: SATA link down (SStatus 0 SControl 0)
[    3.275260] usb 1-1.1.2: new full-speed USB device number 7 using ehci_hcd
[    3.278773] ata1.00: ATA-8: APPLE SSD SM256C, AXM09A1Q, max UDMA/133
[    3.278778] ata1.00: 490234752 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.285476] ata1.00: configured for UDMA/133
[    3.285711] scsi 0:0:0:0: Direct-Access     ATA      APPLE SSD SM256C AXM0 PQ: 0 ANSI: 5
[    3.428396] usb 1-1.1.3: new full-speed USB device number 8 using ehci_hcd
[    3.820891] ata2.01: failed to resume link (SControl 0)
[    3.832493] ata2.00: SATA link down (SStatus 0 SControl 0)
[    3.832509] ata2.01: SATA link down (SStatus 0 SControl 0)
[    3.833871] input: Apple Inc. Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.0/input/input0
[    3.833982] apple 0003:05AC:024D.0001: input,hidraw0: USB HID v1.11 Keyboard [Apple Inc. Apple Internal Keyboard / Trackpad] on usb-0000:00:1a.7-1.2/input0
[    3.835546] apple 0003:05AC:024D.0002: hidraw1: USB HID v1.11 Device [Apple Inc. Apple Internal Keyboard / Trackpad] on usb-0000:00:1a.7-1.2/input1
[    3.837255] sd 0:0:0:0: [sda] 490234752 512-byte logical blocks: (251 GB/233 GiB)
[    3.837372] sd 0:0:0:0: [sda] Write Protect is off
[    3.837376] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.837402] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.841598]  sda: sda1 sda2 sda3 sda4 sda5
[    3.842334] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.937545] device-mapper: uevent: version 1.0.3
[    3.937775] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
[    4.082926] scsi 2:0:0:0: Direct-Access     APPLE    SD Card Reader   2.00 PQ: 0 ANSI: 0
[    4.084660] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[    9.346204] bio: create slab <bio-1> at 1
[    9.521653] bio: create slab <bio-1> at 1
[    9.573192] JFS: nTxBlock = 8192, nTxLock = 65536
[    9.695237] systemd[1]: systemd 197 running in system mode. (+PAM -LIBWRAP -AUDIT -SELINUX -IMA -SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    9.699809] systemd[1]: Set hostname to <brief>.
[    9.708595] systemd-fstab-generator[160]: Failed to create mount unit file /run/systemd/generator/home-services-nfs-bibliothek.mount, as it already exists. Duplicate entry in /etc/fstab?
[    9.708723] systemd-fstab-generator[160]: Failed to create mount unit file /run/systemd/generator/home-services-nfs-buch.mount, as it already exists. Duplicate entry in /etc/fstab?
[    9.709014] systemd[1]: /usr/lib/systemd/system-generators/systemd-fstab-generator exited with exit status 1.
[    9.767569] systemd[1]: Cannot add dependency job for unit display-manager.service, ignoring: Unit display-manager.service failed to load: No such file or directory. See system logs and 'systemctl status display-manager.service' for details.
[    9.767820] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
[    9.767875] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[    9.767890] systemd[1]: Starting Syslog Socket.
[    9.768268] systemd[1]: Listening on Syslog Socket.
[    9.768282] systemd[1]: Starting Remote File Systems.
[    9.768594] systemd[1]: Reached target Remote File Systems.
[    9.768605] systemd[1]: Starting Delayed Shutdown Socket.
[    9.768930] systemd[1]: Listening on Delayed Shutdown Socket.
[    9.768941] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[    9.769265] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    9.769333] systemd[1]: Starting udev Kernel Socket.
[    9.769658] systemd[1]: Listening on udev Kernel Socket.
[    9.769711] systemd[1]: Starting udev Control Socket.
[    9.770039] systemd[1]: Listening on udev Control Socket.
[    9.770057] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
[    9.770095] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[    9.770127] systemd[1]: Starting Arbitrary Executable File Formats File System Automount Point.
[    9.770540] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[    9.770552] systemd[1]: Expecting device dev-mapper-root.device...
[    9.770775] systemd[1]: Expecting device dev-sda5.device...
[    9.770996] systemd[1]: Expecting device dev-sda2.device...
[    9.771216] systemd[1]: Expecting device dev-mapper-swap.device...
[    9.771437] systemd[1]: Expecting device dev-sda4.device...
[    9.771673] systemd[1]: Starting Journal Socket.
[    9.772015] systemd[1]: Listening on Journal Socket.
[    9.772036] systemd[1]: Starting File System Check on Root Device...
[    9.782136] systemd[1]: Mounting Huge Pages File System...
[    9.794957] systemd[1]: Mounting POSIX Message Queue File System...
[    9.808305] systemd[1]: Mounting Debug File System...
[    9.825901] systemd[1]: Started Set Up Additional Binary Formats.
[    9.827621] systemd[1]: Starting Load Kernel Modules...
[    9.839681] systemd[1]: Starting Apply Kernel Variables...
[    9.848260] systemd[1]: Starting udev Coldplug all Devices...
[    9.864957] systemd[1]: Starting udev Kernel Device Manager...
[    9.870476] FS-Cache: Loaded
[    9.871581] systemd[1]: Starting Setup Virtual Console...
[    9.877535] RPC: Registered named UNIX socket transport module.
[    9.877538] RPC: Registered udp transport module.
[    9.877540] RPC: Registered tcp transport module.
[    9.877541] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    9.888112] systemd[1]: Starting Journal Service...
[    9.888131] FS-Cache: Netfs 'nfs' registered for caching
[    9.905048] systemd-udevd[175]: starting version 197
[    9.905294] systemd[1]: Started Journal Service.
[    9.905340] systemd[1]: Starting Syslog.
[    9.905722] systemd[1]: Reached target Syslog.
[    9.906365] systemd[1]: Started udev Kernel Device Manager.
[    9.906736] systemd[1]: Mounted Huge Pages File System.
[    9.907106] systemd[1]: Mounted POSIX Message Queue File System.
[    9.907501] systemd[1]: Mounted Debug File System.
[    9.908920] systemd[1]: Started Apply Kernel Variables.
[   10.081961] microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x1a
[   10.094100] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[   10.094147] ACPI: Lid Switch [LID0]
[   10.094228] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input2
[   10.094236] ACPI: Power Button [PWRB]
[   10.094313] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input3
[   10.094318] ACPI: Sleep Button [SLPB]
[   10.096621] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[   10.096631] ACPI: Power Button [PWRF]
[   10.124666] ACPI: Requesting acpi_cpufreq
[   10.141595] microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x1a
[   10.146078] microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x1a
[   10.147165] microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x1a
[   10.147950] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   10.184012] bcma: bus0: Found chip with id 0xA8D8, rev 0x01 and package 0x08
[   10.184059] bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x22, class 0x0)
[   10.184091] bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x17, class 0x0)
[   10.184162] bcma: bus0: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x0F, class 0x0)
[   10.187815] input: PC Speaker as /devices/platform/pcspkr/input/input5
[   10.192754] mei 0000:00:16.0: setting latency timer to 64
[   10.192841] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[   10.234649] bcma: bus0: Bus registered
[    3.286001] ACPI: Invalid Power Resource to register!
[   10.245303] ACPI Warning: 
[   10.245311] 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PMIO 1 (20120913/utaddress-251)
[   10.245316] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   10.245321] ACPI Warning: 0x0000000000000540-0x000000000000054f SystemIO conflicts with Region \GPIO 1 (20120913/utaddress-251)
[   10.245328] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   10.245331] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \GPIO 1 (20120913/utaddress-251)
[   10.245337] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   10.245339] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \GPIO 1 (20120913/utaddress-251)
[   10.245344] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   10.245346] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   10.246179] ACPI: Battery Slot [BAT0] (battery present)
[   10.246324] ACPI: AC Adapter [ADP1] (off-line)
[   10.272403] iTCO_vendor_support: vendor-support=0
[   10.272852] ACPI Warning: 0x000000000000efa0-0x000000000000efbf SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120913/utaddress-251)
[   10.272857] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   10.278772] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   10.278819] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
[   10.280468] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[   10.314310] mei 0000:00:16.0: wd: failed to find the client
[   10.332599] [drm] Initialized drm 1.1.0 20060810
[   10.391580] applesmc: key=349 fan=1 temp=25 index=24 acc=0 lux=2 kbd=1
[   10.391693] Registered led device: smc::kbd_backlight
[   10.461868] input: HDA Intel PCH HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[   10.461951] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[   10.462024] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   10.462092] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   10.462964] pci 0000:00:00.0: Intel Sandybridge Chipset
[   10.463047] pci 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[   10.464118] pci 0000:00:00.0: detected 65536K stolen memory
[   10.464167] i915 0000:00:02.0: setting latency timer to 64
[   10.472559] media: Linux media interface: v0.10
[   10.474889] input: HID 05ac:820a as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.0/input/input11
[   10.474962] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input10
[   10.475138] hid-generic 0003:05AC:820A.0003: input,hidraw2: USB HID v1.11 Keyboard [HID 05ac:820a] on usb-0000:00:1a.7-1.1.1/input0
[   10.475311] usbcore: registered new interface driver bcm5974
[   10.475846] input: HID 05ac:820b as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.1/1-1.1.2/1-1.1.2:1.0/input/input12
[   10.479007] Linux video capture interface: v2.00
[   10.479110] hid-generic 0003:05AC:820B.0004: input,hidraw3: USB HID v1.11 Mouse [HID 05ac:820b] on usb-0000:00:1a.7-1.1.2/input0
[   10.497976] i915 0000:00:02.0: irq 47 for MSI/MSI-X
[   10.497984] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   10.497985] [drm] Driver supports precise vblank timestamp query.
[   10.498047] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   10.499020] cfg80211: Calling CRDA to update world regulatory domain
[   10.503788] Bluetooth: Core ver 2.16
[   10.503804] NET: Registered protocol family 31
[   10.503805] Bluetooth: HCI device and connection manager initialized
[   10.503813] Bluetooth: HCI socket layer initialized
[   10.503816] Bluetooth: L2CAP socket layer initialized
[   10.503822] Bluetooth: SCO socket layer initialized
[   10.513658] usbcore: registered new interface driver btusb
[   10.515516] uvcvideo: Found UVC 1.00 device FaceTime Camera (Built-in) (05ac:850a)
[   10.522308] input: FaceTime Camera (Built-in) as /devices/pci0000:00/0000:00:1a.7/usb1/1-2/1-2:1.0/input/input13
[   10.522557] usbcore: registered new interface driver uvcvideo
[   10.522559] USB Video Class driver (1.1.1)
[   10.540622] brcmsmac bcma0:0: mfg 4bf core 812 rev 23 class 0 irq 17
[   10.550528] usb 1-1.1.1: USB disconnect, device number 6
[   10.557921] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[   10.573026] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[   10.697192] usb 1-1.1.2: USB disconnect, device number 7
[   10.763367] [drm] GMBUS [i915 gmbus vga] timed out, falling back to bit banging on pin 2
[   10.857689] fbcon: inteldrmfb (fb0) is primary device
[   12.653965] Console: switching to colour frame buffer device 180x56
[   12.656834] fb0: inteldrmfb frame buffer device
[   12.656835] drm: registered panic notifier
[   12.662811] acpi device:0c: registered as cooling_device4
[   12.663161] ACPI: Video Device [IGPU] (multi-head: yes  rom: no  post: no)
[   12.663223] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input14
[   12.663373] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   12.673335] Adding 8386556k swap on /dev/mapper/swap.  Priority:-1 extents:1 across:8386556k SS
[   12.786007] EXT4-fs (sda4): mounted filesystem with ordered data mode. Opts: (null)
[   12.837615] systemd-journald[181]: Received SIGUSR1
[   12.846091] systemd-journald[181]: File /var/log/journal/430f5d56a9288edc7eca1b05000004e3/system.journal corrupted or uncleanly shut down, renaming and replacing.
[   13.692876] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[   13.693699] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[   13.695648] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   23.454216] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[   23.454348] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[   23.455545] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   23.531378] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[   23.531513] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[   23.532725] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   29.492562] wlan0: authenticate with 5c:ff:35:75:05:89
[   29.494479] wlan0: send auth to 5c:ff:35:75:05:89 (try 1/3)
[   29.498422] wlan0: authenticated
[   29.500854] wlan0: associate with 5c:ff:35:75:05:89 (try 1/3)
[   29.513960] wlan0: RX AssocResp from 5c:ff:35:75:05:89 (capab=0x431 status=0 aid=2)
[   29.514624] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[   29.514737] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[   29.514865] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[   29.514982] wlan0: associated
[   29.515029] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   34.513638] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[  405.875025] hda-intel: Unstable LPIB (130816 >= 8192); disabling LPIB delay counting
[  436.575117] PM: Syncing filesystems ... done.
[  436.635836] PM: Preparing system for mem sleep
[  436.726581] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  436.740357] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  436.753692] PM: Entering mem sleep
[  436.753760] Suspending console(s) (use no_console_suspend to debug)
[  436.802630] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  436.802736] sd 0:0:0:0: [sda] Stopping disk
[  438.414348] PM: suspend of devices complete after 1622.808 msecs
[  438.414826] PM: late suspend of devices complete after 0.473 msecs
[  438.427943] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[  438.441089] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[  438.467598] PM: noirq suspend of devices complete after 52.850 msecs
[  438.468474] ACPI: Preparing to enter system sleep state S3
[  438.494233] PM: Saving platform NVS memory
[  438.495223] Disabling non-boot CPUs ...
[  438.496862] smpboot: CPU 1 is now offline
[  438.600610] smpboot: CPU 2 is now offline
[  438.703783] smpboot: CPU 3 is now offline
[  438.704316] Extended CMOS year: 2000
[  438.706422] ACPI: Low-level resume complete
[  438.706464] PM: Restoring platform NVS memory
[  438.706776] Extended CMOS year: 2000
[  438.706839] Enabling non-boot CPUs ...
[  438.710279] smpboot: Booting Node 0 Processor 1 APIC 0x2
[  438.724648] CPU1 is up
[  438.728041] smpboot: Booting Node 0 Processor 2 APIC 0x1
[  438.741619] CPU2 is up
[  438.742076] smpboot: Booting Node 0 Processor 3 APIC 0x3
[  438.756286] CPU3 is up
[  438.761216] ACPI: Waking up from system sleep state S3
[  439.302067] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[  439.315593] pcieport 0000:00:1c.1: power state changed by ACPI to D0
[  439.328687] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[  439.355675] PM: noirq resume of devices complete after 93.668 msecs
[  439.356105] PM: early resume of devices complete after 0.345 msecs
[  439.356170] i915 0000:00:02.0: setting latency timer to 64
[  439.356199] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[  439.356221] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[  439.356245] usb usb3: root hub lost power or was reset
[  439.356255] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[  439.356282] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[  439.356303] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[  439.356316] usb usb4: root hub lost power or was reset
[  439.356328] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[  439.356338] ata_piix 0000:00:1f.2: setting latency timer to 64
[  439.358006] mei 0000:00:16.0: wd: failed to find the client
[  439.411798] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake old ack to clear.
[  439.413037] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[  439.428530] bcm5974: bad trackpad package, length: 8
[  439.445545] bcm5974: bad trackpad package, length: 8
[  439.447519] bcm5974: bad trackpad package, length: 8
[  439.448514] bcm5974: bad trackpad package, length: 8
[  439.477606] Extended CMOS year: 2000
[  440.377106] ata2.00: failed to resume link (SControl 0)
[  440.696605] ata1.01: failed to resume link (SControl 0)
[  440.849790] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  440.849808] ata1.01: SATA link down (SStatus 0 SControl 0)
[  440.856702] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[  440.863464] ata1.00: configured for UDMA/133
[  440.897084] sd 0:0:0:0: [sda] Starting disk
[  441.398841] ata2.01: failed to resume link (SControl 0)
[  441.410730] ata2.00: SATA link down (SStatus 4 SControl 0)
[  441.410752] ata2.01: SATA link down (SStatus 0 SControl 0)
[  441.427755] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[  441.428841] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[  441.428848] ieee80211 phy0: changing basic rates failed: -22
[  441.428852] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: threshold 0, hys 0  (implement)
[  441.428856] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[  441.428859] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[  441.429101] PM: resume of devices complete after 2076.221 msecs
[  441.429569] PM: Finishing wakeup.
[  441.429570] Restarting tasks ... done.
[  441.453668] video LNXVIDEO:00: Restoring backlight state
[  441.561795] ------------[ cut here ]------------
[  441.561809] WARNING: at drivers/net/wireless/brcm80211/brcmsmac/main.c:7993 brcms_c_wait_for_tx_completion+0x99/0xb0 [brcmsmac]()
[  441.561811] Hardware name: MacBookAir4,2
[  441.561813] Modules linked in: ext4 jbd2 mbcache sha256_generic arc4 brcmsmac cordic brcmutil uvcvideo btusb mac80211 videobuf2_vmalloc bluetooth cfg80211 videobuf2_memops joydev rfkill crc16 videobuf2_core videodev hid_generic bcm5974 media snd_hda_codec_hdmi snd_hda_codec_cirrus i915 intel_agp intel_gtt drm_kms_helper drm i2c_algo_bit snd_hda_intel iTCO_wdt snd_hda_codec i2c_i801 iTCO_vendor_support coretemp applesmc acpi_cpufreq mperf lpc_ich mei pcspkr snd_hwdep bcma i2c_core evdev processor apple_bl input_polldev ac battery video button microcode snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_timer snd soundcore kvm_intel kvm nfs lockd sunrpc fscache jfs dm_crypt dm_mod sd_mod hid_apple ata_generic pata_acpi usbhid usb_storage hid uhci_hcd crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64
[  441.561856]  ablk_helper cryptd xts lrw gf128mul ata_piix libata ehci_hcd scsi_mod usbcore usb_common
[  441.561864] Pid: 2476, comm: kworker/u:12 Not tainted 3.7.5-1-ARCH #1
[  441.561866] Call Trace:
[  441.561870]  [<ffffffff8105750f>] warn_slowpath_common+0x7f/0xc0
[  441.561872]  [<ffffffff8105756a>] warn_slowpath_null+0x1a/0x20
[  441.561877]  [<ffffffffa071fce9>] brcms_c_wait_for_tx_completion+0x99/0xb0 [brcmsmac]
[  441.561880]  [<ffffffffa07121ab>] brcms_ops_flush+0x3b/0x60 [brcmsmac]
[  441.561888]  [<ffffffffa06b5069>] ieee80211_mgd_probe_ap_send+0xc9/0x240 [mac80211]
[  441.561893]  [<ffffffffa06b57fc>] ieee80211_mgd_probe_ap.part.23+0x12c/0x150 [mac80211]
[  441.561898]  [<ffffffffa06b584a>] ieee80211_sta_monitor_work+0x2a/0x30 [mac80211]
[  441.561901]  [<ffffffff81075df2>] process_one_work+0x132/0x4f0
[  441.561903]  [<ffffffff8107520a>] ? manage_workers+0x1ea/0x290
[  441.561908]  [<ffffffffa06b5820>] ? ieee80211_mgd_probe_ap.part.23+0x150/0x150 [mac80211]
[  441.561910]  [<ffffffff8107658d>] worker_thread+0x15d/0x400
[  441.561912]  [<ffffffff81076430>] ? rescuer_thread+0x240/0x240
[  441.561915]  [<ffffffff8107b150>] kthread+0xc0/0xd0
[  441.561918]  [<ffffffff81010000>] ? perf_trace_xen_mmu_set_pte_at+0xb0/0x100
[  441.561920]  [<ffffffff8107b090>] ? kthread_freezable_should_stop+0x70/0x70
[  441.561923]  [<ffffffff814c106c>] ret_from_fork+0x7c/0xb0
[  441.561926]  [<ffffffff8107b090>] ? kthread_freezable_should_stop+0x70/0x70
[  441.561928] ---[ end trace fc0a823385ed692d ]---
[  441.710952] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[  441.710959] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[  441.710972] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[  441.711506] cfg80211: Calling CRDA for country: US
[  443.101264] EXT4-fs (sda4): re-mounted. Opts: commit=600
[  446.612337] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[  446.612348] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[  446.613487] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  451.445727] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[  451.445748] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[  451.446899] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  465.510410] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[  465.510431] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[  465.511609] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  465.559095] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[  465.559116] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[  465.560204] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  467.675414] wlan0: authenticate with 5c:ff:35:75:05:89
[  467.675455] wlan0: send auth to 5c:ff:35:75:05:89 (try 1/3)
[  467.679298] wlan0: authenticated
[  467.681234] wlan0: associate with 5c:ff:35:75:05:89 (try 1/3)
[  467.693669] wlan0: RX AssocResp from 5c:ff:35:75:05:89 (capab=0x431 status=0 aid=1)
[  467.694178] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[  467.694188] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[  467.694194] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[  467.694224] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  467.694334] wlan0: associated
[  474.411244] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[ 1201.706082] PM: Syncing filesystems ... done.
[ 1201.787587] PM: Preparing system for mem sleep
[ 1201.842389] Freezing user space processes ... (elapsed 0.01 seconds) done.
[ 1201.855112] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[ 1201.868356] PM: Entering mem sleep
[ 1201.868409] Suspending console(s) (use no_console_suspend to debug)
[ 1201.917773] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 1201.919083] sd 0:0:0:0: [sda] Stopping disk
[ 1203.565621] PM: suspend of devices complete after 1659.474 msecs
[ 1203.566101] PM: late suspend of devices complete after 0.474 msecs
[ 1203.579303] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[ 1203.592439] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[ 1203.618905] PM: noirq suspend of devices complete after 52.882 msecs
[ 1203.619780] ACPI: Preparing to enter system sleep state S3
[ 1203.645508] PM: Saving platform NVS memory
[ 1203.646488] Disabling non-boot CPUs ...
[ 1203.748559] smpboot: CPU 1 is now offline
[ 1203.851726] smpboot: CPU 2 is now offline
[ 1203.954900] smpboot: CPU 3 is now offline
[ 1203.955386] Extended CMOS year: 2000
[ 1203.957496] ACPI: Low-level resume complete
[ 1203.957537] PM: Restoring platform NVS memory
[ 1203.957849] Extended CMOS year: 2000
[ 1203.957912] Enabling non-boot CPUs ...
[ 1203.961352] smpboot: Booting Node 0 Processor 1 APIC 0x2
[ 1203.975716] CPU1 is up
[ 1203.979108] smpboot: Booting Node 0 Processor 2 APIC 0x1
[ 1203.992700] CPU2 is up
[ 1203.993185] smpboot: Booting Node 0 Processor 3 APIC 0x3
[ 1204.007382] CPU3 is up
[ 1204.012368] ACPI: Waking up from system sleep state S3
[ 1204.556517] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[ 1204.569937] pcieport 0000:00:1c.1: power state changed by ACPI to D0
[ 1204.583136] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[ 1204.610132] PM: noirq resume of devices complete after 93.666 msecs
[ 1204.610532] PM: early resume of devices complete after 0.356 msecs
[ 1204.610588] i915 0000:00:02.0: setting latency timer to 64
[ 1204.610637] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[ 1204.610645] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[ 1204.610672] usb usb3: root hub lost power or was reset
[ 1204.610695] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[ 1204.610699] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[ 1204.610730] usb usb4: root hub lost power or was reset
[ 1204.610732] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[ 1204.610753] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[ 1204.610779] ata_piix 0000:00:1f.2: setting latency timer to 64
[ 1204.611419] mei 0000:00:16.0: wd: failed to find the client
[ 1204.666245] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake old ack to clear.
[ 1204.667570] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[ 1204.682996] bcm5974: bad trackpad package, length: 8
[ 1204.683978] bcm5974: bad trackpad package, length: 8
[ 1204.701955] bcm5974: bad trackpad package, length: 8
[ 1204.702948] bcm5974: bad trackpad package, length: 8
[ 1204.704013] bcm5974: bad trackpad package, length: 8
[ 1204.704944] bcm5974: bad trackpad package, length: 8
[ 1204.706976] bcm5974: bad trackpad package, length: 8
[ 1204.707965] bcm5974: bad trackpad package, length: 8
[ 1204.708937] bcm5974: bad trackpad package, length: 8
[ 1205.631550] ata2.00: failed to resume link (SControl 0)
[ 1205.951056] ata1.01: failed to resume link (SControl 0)
[ 1206.104237] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 1206.104255] ata1.01: SATA link down (SStatus 0 SControl 0)
[ 1206.111152] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[ 1206.117901] ata1.00: configured for UDMA/133
[ 1206.152462] sd 0:0:0:0: [sda] Starting disk
[ 1206.653294] ata2.01: failed to resume link (SControl 0)
[ 1206.665179] ata2.00: SATA link down (SStatus 4 SControl 0)
[ 1206.665201] ata2.01: SATA link down (SStatus 0 SControl 0)
[ 1206.682049] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[ 1206.683090] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[ 1206.683096] ieee80211 phy0: changing basic rates failed: -22
[ 1206.683101] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: threshold 0, hys 0  (implement)
[ 1206.683147] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[ 1206.683150] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[ 1206.683416] PM: resume of devices complete after 2076.103 msecs
[ 1206.697872] PM: Finishing wakeup.
[ 1206.697877] Restarting tasks ... done.
[ 1206.751524] video LNXVIDEO:00: Restoring backlight state
[ 1206.966143] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[ 1206.966162] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[ 1206.966168] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[ 1206.967094] cfg80211: Calling CRDA to update world regulatory domain
[ 1212.418466] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[ 1212.418477] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[ 1212.419492] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 1217.256023] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[ 1217.256044] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[ 1217.257978] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 1231.268571] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[ 1231.268582] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[ 1231.269604] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 1231.309471] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[ 1231.309492] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[ 1231.310584] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 1233.428527] wlan0: authenticate with 5c:ff:35:75:05:89
[ 1233.428543] wlan0: send auth to 5c:ff:35:75:05:89 (try 1/3)
[ 1233.432097] wlan0: authenticated
[ 1233.434827] wlan0: associate with 5c:ff:35:75:05:89 (try 1/3)
[ 1233.446982] wlan0: RX AssocResp from 5c:ff:35:75:05:89 (capab=0x431 status=0 aid=1)
[ 1233.447490] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[ 1233.447494] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[ 1233.447495] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[ 1233.447502] wlan0: associated
[ 1233.447528] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[ 1239.822060] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[ 3165.359968] PM: Syncing filesystems ... done.
[ 3165.445585] PM: Preparing system for mem sleep
[ 3166.529074] Freezing user space processes ... (elapsed 0.01 seconds) done.
[ 3166.542103] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[ 3166.555387] PM: Entering mem sleep
[ 3166.555446] Suspending console(s) (use no_console_suspend to debug)
[ 3166.604854] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 3166.606165] sd 0:0:0:0: [sda] Stopping disk
[ 3168.256138] PM: suspend of devices complete after 1662.971 msecs
[ 3168.256614] PM: late suspend of devices complete after 0.472 msecs
[ 3168.269791] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[ 3168.282923] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[ 3168.309386] PM: noirq suspend of devices complete after 52.850 msecs
[ 3168.310262] ACPI: Preparing to enter system sleep state S3
[ 3168.335994] PM: Saving platform NVS memory
[ 3168.336970] Disabling non-boot CPUs ...
[ 3168.439072] smpboot: CPU 1 is now offline
[ 3168.542210] smpboot: CPU 2 is now offline
[ 3168.645384] smpboot: CPU 3 is now offline
[ 3168.645923] Extended CMOS year: 2000
[ 3168.648027] ACPI: Low-level resume complete
[ 3168.648069] PM: Restoring platform NVS memory
[ 3168.648380] Extended CMOS year: 2000
[ 3168.648443] Enabling non-boot CPUs ...
[ 3168.651883] smpboot: Booting Node 0 Processor 1 APIC 0x2
[ 3168.666258] CPU1 is up
[ 3168.669649] smpboot: Booting Node 0 Processor 2 APIC 0x1
[ 3168.683149] CPU2 is up
[ 3168.683618] smpboot: Booting Node 0 Processor 3 APIC 0x3
[ 3168.697914] CPU3 is up
[ 3168.702830] ACPI: Waking up from system sleep state S3
[ 3169.603116] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[ 3169.616548] pcieport 0000:00:1c.1: power state changed by ACPI to D0
[ 3169.629734] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[ 3169.656724] PM: noirq resume of devices complete after 93.658 msecs
[ 3169.657164] PM: early resume of devices complete after 0.353 msecs
[ 3169.657219] i915 0000:00:02.0: setting latency timer to 64
[ 3169.657301] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[ 3169.657495] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[ 3169.657535] usb usb3: root hub lost power or was reset
[ 3169.657577] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[ 3169.657612] usb usb4: root hub lost power or was reset
[ 3169.657644] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[ 3169.657686] ata_piix 0000:00:1f.2: setting latency timer to 64
[ 3169.657893] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[ 3169.657985] mei 0000:00:16.0: wd: failed to find the client
[ 3169.658072] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[ 3169.712836] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake old ack to clear.
[ 3169.713981] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[ 3170.678148] ata2.00: failed to resume link (SControl 0)
[ 3170.997578] ata1.01: failed to resume link (SControl 0)
[ 3171.150807] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 3171.150825] ata1.01: SATA link down (SStatus 0 SControl 0)
[ 3171.157750] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[ 3171.164515] ata1.00: configured for UDMA/133
[ 3171.198884] sd 0:0:0:0: [sda] Starting disk
[ 3171.699888] ata2.01: failed to resume link (SControl 0)
[ 3171.711772] ata2.00: SATA link down (SStatus 4 SControl 0)
[ 3171.711794] ata2.01: SATA link down (SStatus 0 SControl 0)
[ 3171.728872] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[ 3171.729933] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[ 3171.729939] ieee80211 phy0: changing basic rates failed: -22
[ 3171.729944] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: threshold 0, hys 0  (implement)
[ 3171.729948] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[ 3171.729951] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[ 3171.730196] PM: resume of devices complete after 2076.252 msecs
[ 3171.744478] PM: Finishing wakeup.
[ 3171.744483] Restarting tasks ... done.
[ 3171.776506] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[ 3171.776631] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[ 3171.776760] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[ 3171.777525] cfg80211: Calling CRDA to update world regulatory domain
[ 3171.831707] video LNXVIDEO:00: Restoring backlight state
[ 3171.895493] EXT4-fs (sda4): re-mounted. Opts: commit=0
[ 3177.353125] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[ 3177.353146] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[ 3177.354233] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 3182.197457] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[ 3182.197468] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[ 3182.198482] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 3186.304118] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[ 3186.304129] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[ 3186.305137] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 3186.344588] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[ 3186.344608] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[ 3186.345707] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 3188.508025] wlan0: authenticate with 0e:b0:5d:9c:37:13
[ 3188.510953] wlan0: send auth to 0e:b0:5d:9c:37:13 (try 1/3)
[ 3188.512820] wlan0: authenticated
[ 3188.513649] wlan0: associate with 0e:b0:5d:9c:37:13 (try 1/3)
[ 3188.516825] wlan0: RX AssocResp from 0e:b0:5d:9c:37:13 (capab=0x411 status=0 aid=2)
[ 3188.517455] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[ 3188.517467] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[ 3188.517473] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[ 3188.517500] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[ 3188.517618] wlan0: associated
[ 3191.619418] wlan0: deauthenticated from 0e:b0:5d:9c:37:13 (Reason: 2)
[ 3191.625565] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[ 3191.625581] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[ 3191.625587] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[ 3191.626197] cfg80211: Calling CRDA for country: US
[ 3204.396509] wlan0: authenticate with 0e:b0:5d:9c:37:13
[ 3204.406102] wlan0: send auth to 0e:b0:5d:9c:37:13 (try 1/3)
[ 3204.409409] wlan0: authenticated
[ 3204.412307] wlan0: associate with 0e:b0:5d:9c:37:13 (try 1/3)
[ 3204.415593] wlan0: RX AssocResp from 0e:b0:5d:9c:37:13 (capab=0x411 status=0 aid=2)
[ 3204.416154] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[ 3204.416165] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[ 3204.416171] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[ 3204.416247] wlan0: associated
[ 3207.518159] wlan0: deauthenticated from 0e:b0:5d:9c:37:13 (Reason: 2)
[ 3207.521210] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[ 3207.521228] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[ 3207.521234] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[ 3207.521857] cfg80211: Calling CRDA to update world regulatory domain
[ 3227.194600] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[ 3227.194611] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[ 3227.195669] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 3232.118028] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[ 3232.118048] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[ 3232.119241] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 3236.213272] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[ 3236.213283] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[ 3236.214293] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 3236.256239] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[ 3236.256260] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[ 3236.257355] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 3238.377150] wlan0: authenticate with 0e:b0:5d:9c:37:13
[ 3238.377191] wlan0: send auth to 0e:b0:5d:9c:37:13 (try 1/3)
[ 3238.381051] wlan0: authenticated
[ 3238.382707] wlan0: associate with 0e:b0:5d:9c:37:13 (try 1/3)
[ 3238.386054] wlan0: RX AssocResp from 0e:b0:5d:9c:37:13 (capab=0x411 status=0 aid=2)
[ 3238.386684] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[ 3238.386697] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[ 3238.386703] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[ 3238.386734] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[ 3238.386843] wlan0: associated
[ 3241.489873] wlan0: deauthenticated from 0e:b0:5d:9c:37:13 (Reason: 2)
[ 3241.494735] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[ 3241.494755] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[ 3241.494761] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[ 3241.495362] cfg80211: Calling CRDA for country: CH
[ 3254.268883] wlan0: authenticate with 0e:b0:5d:9c:37:13
[ 3254.278489] wlan0: send auth to 0e:b0:5d:9c:37:13 (try 1/3)
[ 3254.280407] wlan0: authenticated
[ 3254.281219] wlan0: associate with 0e:b0:5d:9c:37:13 (try 1/3)
[ 3254.284602] wlan0: RX AssocResp from 0e:b0:5d:9c:37:13 (capab=0x411 status=0 aid=2)
[ 3254.285195] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[ 3254.285207] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[ 3254.285213] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[ 3254.285289] wlan0: associated
[ 3257.387130] wlan0: deauthenticated from 0e:b0:5d:9c:37:13 (Reason: 2)
[ 3257.396571] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[ 3257.396592] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[ 3257.396597] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[ 3257.397852] cfg80211: Calling CRDA to update world regulatory domain
[ 3277.102811] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[ 3277.102831] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[ 3277.103967] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 3448.534139] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[ 3448.534150] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[ 3448.535163] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 3452.450454] wlan0: authenticate with 0c:b0:5d:9c:37:12
[ 3452.459865] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[ 3452.462320] wlan0: authenticated
[ 3452.462695] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[ 3452.466091] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=0x411 status=0 aid=2)
[ 3452.466666] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[ 3452.466677] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[ 3452.466683] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[ 3452.466714] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[ 3452.466824] wlan0: associated
[ 3458.623715] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[ 4469.582682] usb 2-1.2: new high-speed USB device number 4 using ehci_hcd
[ 4469.682509] scsi3 : usb-storage 2-1.2:1.0
[ 4470.685561] scsi 3:0:0:0: Direct-Access     WD       Elements 1023    2005 PQ: 0 ANSI: 4
[ 4470.686798] sd 3:0:0:0: [sdc] 976769024 512-byte logical blocks: (500 GB/465 GiB)
[ 4470.687734] sd 3:0:0:0: [sdc] Test WP failed, assume Write Enabled
[ 4470.688712] sd 3:0:0:0: [sdc] Asking for cache data failed
[ 4470.688725] sd 3:0:0:0: [sdc] Assuming drive cache: write through
[ 4470.690599] sd 3:0:0:0: [sdc] Test WP failed, assume Write Enabled
[ 4470.691471] sd 3:0:0:0: [sdc] Asking for cache data failed
[ 4470.691484] sd 3:0:0:0: [sdc] Assuming drive cache: write through
[ 4470.730078]  sdc: unknown partition table
[ 4470.732351] sd 3:0:0:0: [sdc] Test WP failed, assume Write Enabled
[ 4470.733320] sd 3:0:0:0: [sdc] Asking for cache data failed
[ 4470.733323] sd 3:0:0:0: [sdc] Assuming drive cache: write through
[ 4470.733326] sd 3:0:0:0: [sdc] Attached SCSI disk
[ 4483.060753] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[ 4483.063790] XFS (dm-2): Mounting Filesystem
[ 4483.455917] XFS (dm-2): Ending clean mount
[39645.823932] usb 2-1.2: USB disconnect, device number 4
[39646.982021] EXT4-fs (sda4): re-mounted. Opts: commit=600
[39649.588365] PM: Syncing filesystems ... done.
[39649.660410] PM: Preparing system for mem sleep
[39649.744725] ------------[ cut here ]------------
[39649.744765] WARNING: at drivers/gpu/drm/i915/intel_display.c:6976 intel_modeset_check_state+0x4bb/0x610 [i915]()
[39649.744769] Hardware name: MacBookAir4,2
[39649.744773] encoder's hw state doesn't match sw tracking (expected 1, found 0)
[39649.744776] Modules linked in: xfs ext4 jbd2 mbcache sha256_generic arc4 brcmsmac cordic brcmutil uvcvideo btusb mac80211 videobuf2_vmalloc bluetooth cfg80211 videobuf2_memops joydev rfkill crc16 videobuf2_core videodev hid_generic bcm5974 media snd_hda_codec_hdmi snd_hda_codec_cirrus i915 intel_agp intel_gtt drm_kms_helper drm i2c_algo_bit snd_hda_intel iTCO_wdt snd_hda_codec i2c_i801 iTCO_vendor_support coretemp applesmc acpi_cpufreq mperf lpc_ich mei pcspkr snd_hwdep bcma i2c_core evdev processor apple_bl input_polldev ac battery video button microcode snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_timer snd soundcore kvm_intel kvm nfs lockd sunrpc fscache jfs dm_crypt dm_mod sd_mod hid_apple ata_generic pata_acpi usbhid usb_storage hid uhci_hcd crc32c_intel ghash_clmulni_intel aesni_intel
[39649.744897]  aes_x86_64 ablk_helper cryptd xts lrw gf128mul ata_piix libata ehci_hcd scsi_mod usbcore usb_common
[39649.744920] Pid: 732, comm: X Tainted: G        W    3.7.5-1-ARCH #1
[39649.744924] Call Trace:
[39649.744937]  [<ffffffff8105750f>] warn_slowpath_common+0x7f/0xc0
[39649.744944]  [<ffffffff81057606>] warn_slowpath_fmt+0x46/0x50
[39649.744964]  [<ffffffffa04968cb>] intel_modeset_check_state+0x4bb/0x610 [i915]
[39649.744981]  [<ffffffffa0496a64>] intel_connector_dpms+0x44/0x70 [i915]
[39649.744998]  [<ffffffffa0400d3d>] drm_mode_obj_set_property_ioctl+0x32d/0x340 [drm]
[39649.745011]  [<ffffffffa0400d80>] drm_mode_connector_property_set_ioctl+0x30/0x40 [drm]
[39649.745025]  [<ffffffffa03ef3f3>] drm_ioctl+0x4c3/0x570 [drm]
[39649.745039]  [<ffffffffa0400d50>] ? drm_mode_obj_set_property_ioctl+0x340/0x340 [drm]
[39649.745050]  [<ffffffff8112a5b7>] ? __free_pages+0x57/0x70
[39649.745059]  [<ffffffff8116f60c>] ? kfree+0x2c/0x160
[39649.745068]  [<ffffffff81195e07>] do_vfs_ioctl+0x97/0x530
[39649.745075]  [<ffffffff81185b8e>] ? ____fput+0xe/0x10
[39649.745081]  [<ffffffff81196331>] sys_ioctl+0x91/0xb0
[39649.745092]  [<ffffffff81015dbc>] ? do_notify_resume+0x9c/0xb0
[39649.745102]  [<ffffffff814c111d>] system_call_fastpath+0x1a/0x1f
[39649.745107] ---[ end trace fc0a823385ed692e ]---
[39649.767407] ------------[ cut here ]------------
[39649.767461] WARNING: at drivers/gpu/drm/i915/intel_dp.c:1908 intel_dp_link_down+0x1d2/0x1e0 [i915]()
[39649.767465] Hardware name: MacBookAir4,2
[39649.767469] Modules linked in: xfs ext4 jbd2 mbcache sha256_generic arc4 brcmsmac cordic brcmutil uvcvideo btusb mac80211 videobuf2_vmalloc bluetooth cfg80211 videobuf2_memops joydev rfkill crc16 videobuf2_core videodev hid_generic bcm5974 media snd_hda_codec_hdmi snd_hda_codec_cirrus i915 intel_agp intel_gtt drm_kms_helper drm i2c_algo_bit snd_hda_intel iTCO_wdt snd_hda_codec i2c_i801 iTCO_vendor_support coretemp applesmc acpi_cpufreq mperf lpc_ich mei pcspkr snd_hwdep bcma i2c_core evdev processor apple_bl input_polldev ac battery video button microcode snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_timer snd soundcore kvm_intel kvm nfs lockd sunrpc fscache jfs dm_crypt dm_mod sd_mod hid_apple ata_generic pata_acpi usbhid usb_storage hid uhci_hcd crc32c_intel ghash_clmulni_intel aesni_intel
[39649.767593]  aes_x86_64 ablk_helper cryptd xts lrw gf128mul ata_piix libata ehci_hcd scsi_mod usbcore usb_common
[39649.767616] Pid: 732, comm: X Tainted: G        W    3.7.5-1-ARCH #1
[39649.767620] Call Trace:
[39649.767633]  [<ffffffff8105750f>] warn_slowpath_common+0x7f/0xc0
[39649.767640]  [<ffffffff8105756a>] warn_slowpath_null+0x1a/0x20
[39649.767660]  [<ffffffffa049f3e2>] intel_dp_link_down+0x1d2/0x1e0 [i915]
[39649.767677]  [<ffffffffa04a1584>] intel_disable_dp+0x44/0x170 [i915]
[39649.767696]  [<ffffffffa049026e>] ironlake_crtc_disable+0x68e/0x820 [i915]
[39649.767715]  [<ffffffffa04952f7>] intel_crtc_update_dpms+0x77/0xb0 [i915]
[39649.767732]  [<ffffffffa04953ea>] intel_encoder_dpms+0x1a/0x30 [i915]
[39649.767750]  [<ffffffffa0496a5c>] intel_connector_dpms+0x3c/0x70 [i915]
[39649.767766]  [<ffffffffa0400d3d>] drm_mode_obj_set_property_ioctl+0x32d/0x340 [drm]
[39649.767780]  [<ffffffffa0400d80>] drm_mode_connector_property_set_ioctl+0x30/0x40 [drm]
[39649.767794]  [<ffffffffa03ef3f3>] drm_ioctl+0x4c3/0x570 [drm]
[39649.767808]  [<ffffffffa0400d50>] ? drm_mode_obj_set_property_ioctl+0x340/0x340 [drm]
[39649.767818]  [<ffffffff81020365>] ? __restore_xstate_sig+0x95/0x600
[39649.767827]  [<ffffffff81195e07>] do_vfs_ioctl+0x97/0x530
[39649.767836]  [<ffffffff8101525a>] ? restore_sigcontext+0x12a/0x140
[39649.767842]  [<ffffffff81196331>] sys_ioctl+0x91/0xb0
[39649.767852]  [<ffffffff814c111d>] system_call_fastpath+0x1a/0x1f
[39649.767857] ---[ end trace fc0a823385ed692f ]---
[39651.081932] Freezing user space processes ... (elapsed 0.01 seconds) done.
[39651.095429] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[39651.108809] PM: Entering mem sleep
[39651.108869] Suspending console(s) (use no_console_suspend to debug)
[39651.158577] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[39651.159877] sd 0:0:0:0: [sda] Stopping disk
[39652.636358] PM: suspend of devices complete after 1489.544 msecs
[39652.636834] PM: late suspend of devices complete after 0.472 msecs
[39652.649975] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[39652.663106] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[39652.689570] PM: noirq suspend of devices complete after 52.812 msecs
[39652.690445] ACPI: Preparing to enter system sleep state S3
[39652.716172] PM: Saving platform NVS memory
[39652.717162] Disabling non-boot CPUs ...
[39652.718888] smpboot: CPU 1 is now offline
[39652.721354] smpboot: CPU 2 is now offline
[39652.723863] smpboot: CPU 3 is now offline
[39652.724344] Extended CMOS year: 2000
[39652.726453] ACPI: Low-level resume complete
[39652.726495] PM: Restoring platform NVS memory
[39652.726809] Extended CMOS year: 2000
[39652.726872] Enabling non-boot CPUs ...
[39652.730324] smpboot: Booting Node 0 Processor 1 APIC 0x2
[39652.745091] CPU1 is up
[39652.748492] smpboot: Booting Node 0 Processor 2 APIC 0x1
[39652.762131] CPU2 is up
[39652.762919] smpboot: Booting Node 0 Processor 3 APIC 0x3
[39652.777317] CPU3 is up
[39652.782231] ACPI: Waking up from system sleep state S3
[39653.324326] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[39653.337745] pcieport 0000:00:1c.1: power state changed by ACPI to D0
[39653.350941] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[39653.377939] PM: noirq resume of devices complete after 93.668 msecs
[39653.378336] PM: early resume of devices complete after 0.353 msecs
[39653.378387] i915 0000:00:02.0: setting latency timer to 64
[39653.378485] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[39653.378645] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[39653.378687] usb usb3: root hub lost power or was reset
[39653.378724] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[39653.378776] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[39653.378818] usb usb4: root hub lost power or was reset
[39653.378852] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[39653.378855] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[39653.378903] ata_piix 0000:00:1f.2: setting latency timer to 64
[39653.381370] mei 0000:00:16.0: wd: failed to find the client
[39653.447367] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake old ack to clear.
[39653.448784] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[39653.517053] Extended CMOS year: 2000
[39654.402682] ata2.00: failed to resume link (SControl 0)
[39654.722189] ata1.01: failed to resume link (SControl 0)
[39654.875378] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[39654.875395] ata1.01: SATA link down (SStatus 0 SControl 0)
[39654.882288] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[39654.889040] ata1.00: configured for UDMA/133
[39654.923417] sd 0:0:0:0: [sda] Starting disk
[39655.424426] ata2.01: failed to resume link (SControl 0)
[39655.436316] ata2.00: SATA link down (SStatus 4 SControl 0)
[39655.436337] ata2.01: SATA link down (SStatus 0 SControl 0)
[39655.453437] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[39655.454498] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[39655.454505] ieee80211 phy0: changing basic rates failed: -22
[39655.454509] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: threshold 0, hys 0  (implement)
[39655.454513] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[39655.454516] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[39655.454767] PM: resume of devices complete after 2079.657 msecs
[39655.456247] PM: Finishing wakeup.
[39655.456251] Restarting tasks ... done.
[39655.491057] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[39655.491134] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[39655.491209] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[39655.503752] cfg80211: Calling CRDA to update world regulatory domain
[39655.526272] video LNXVIDEO:00: Restoring backlight state
[39678.525830] wlan0: authenticate with 5c:ff:35:75:05:89
[39678.527738] wlan0: send auth to 5c:ff:35:75:05:89 (try 1/3)
[39678.531968] wlan0: authenticated
[39678.535092] wlan0: associate with 5c:ff:35:75:05:89 (try 1/3)
[39678.547265] wlan0: RX AssocResp from 5c:ff:35:75:05:89 (capab=0x431 status=0 aid=1)
[39678.547805] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[39678.547815] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[39678.547820] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[39678.547903] wlan0: associated
[39685.983831] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[40276.753897] PM: Syncing filesystems ... done.
[40276.845050] PM: Preparing system for mem sleep
[40276.904825] Freezing user space processes ... (elapsed 0.01 seconds) done.
[40276.916846] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[40276.930339] PM: Entering mem sleep
[40276.930393] Suspending console(s) (use no_console_suspend to debug)
[40276.979591] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[40276.980875] sd 0:0:0:0: [sda] Stopping disk
[40278.630907] PM: suspend of devices complete after 1662.830 msecs
[40278.631388] PM: late suspend of devices complete after 0.476 msecs
[40278.644559] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[40278.657686] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[40278.684154] PM: noirq suspend of devices complete after 52.842 msecs
[40278.685030] ACPI: Preparing to enter system sleep state S3
[40278.714084] PM: Saving platform NVS memory
[40278.715067] Disabling non-boot CPUs ...
[40278.817135] smpboot: CPU 1 is now offline
[40278.819318] smpboot: CPU 2 is now offline
[40278.923635] smpboot: CPU 3 is now offline
[40278.924202] Extended CMOS year: 2000
[40278.926308] ACPI: Low-level resume complete
[40278.926351] PM: Restoring platform NVS memory
[40278.926665] Extended CMOS year: 2000
[40278.926728] Enabling non-boot CPUs ...
[40278.930172] smpboot: Booting Node 0 Processor 1 APIC 0x2
[40278.944653] CPU1 is up
[40278.948044] smpboot: Booting Node 0 Processor 2 APIC 0x1
[40278.961589] CPU2 is up
[40278.962053] smpboot: Booting Node 0 Processor 3 APIC 0x3
[40278.976494] CPU3 is up
[40278.981510] ACPI: Waking up from system sleep state S3
[40279.521926] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[40279.535344] pcieport 0000:00:1c.1: power state changed by ACPI to D0
[40279.548540] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[40279.575537] PM: noirq resume of devices complete after 93.661 msecs
[40279.575934] PM: early resume of devices complete after 0.353 msecs
[40279.575990] i915 0000:00:02.0: setting latency timer to 64
[40279.576017] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[40279.576066] usb usb3: root hub lost power or was reset
[40279.576099] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[40279.576120] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[40279.576232] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[40279.576373] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[40279.576391] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[40279.576399] ata_piix 0000:00:1f.2: setting latency timer to 64
[40279.576419] usb usb4: root hub lost power or was reset
[40279.577008] mei 0000:00:16.0: wd: failed to find the client
[40279.644965] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake old ack to clear.
[40279.646195] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[40279.700168] Extended CMOS year: 2000
[40280.600284] ata2.00: failed to resume link (SControl 0)
[40280.919792] ata1.01: failed to resume link (SControl 0)
[40281.072969] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[40281.072987] ata1.01: SATA link down (SStatus 0 SControl 0)
[40281.079885] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[40281.086638] ata1.00: configured for UDMA/133
[40281.121149] sd 0:0:0:0: [sda] Starting disk
[40281.622030] ata2.01: failed to resume link (SControl 0)
[40281.633935] ata2.00: SATA link down (SStatus 4 SControl 0)
[40281.633957] ata2.01: SATA link down (SStatus 0 SControl 0)
[40281.651035] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[40281.652099] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[40281.652105] ieee80211 phy0: changing basic rates failed: -22
[40281.652110] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: threshold 0, hys 0  (implement)
[40281.652113] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[40281.652116] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[40281.652331] PM: resume of devices complete after 2079.624 msecs
[40281.652799] PM: Finishing wakeup.
[40281.652800] Restarting tasks ... done.
[40281.708538] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[40281.708660] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[40281.708789] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[40281.709506] cfg80211: Calling CRDA for country: CH
[40281.738988] video LNXVIDEO:00: Restoring backlight state
[40281.825260] EXT4-fs (sda4): re-mounted. Opts: commit=0
[40285.718023] wlan0: authenticate with d4:a0:2a:98:a6:af
[40285.730403] wlan0: direct probe to d4:a0:2a:98:a6:af (try 1/3)
[40285.931876] wlan0: send auth to d4:a0:2a:98:a6:af (try 2/3)
[40285.932661] wlan0: authenticated
[40285.935259] wlan0: associate with d4:a0:2a:98:a6:af (try 1/3)
[40285.937305] wlan0: RX AssocResp from d4:a0:2a:98:a6:af (capab=0x11 status=0 aid=18)
[40285.937833] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[40285.937844] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[40285.937849] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[40285.937867] wlan0: associated
[40291.110862] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[40355.726616] ieee80211 phy0: START: tid 1 is not agg'able
[40363.870789] usb 2-1.2: new high-speed USB device number 5 using ehci_hcd
[40364.153051] scsi4 : usb-storage 2-1.2:1.0
[40371.581135] scsi 4:0:0:0: Direct-Access     Samsung  STORY Station 3  1AJ1 PQ: 0 ANSI: 0
[40371.584138] sd 4:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[40371.585219] sd 4:0:0:0: [sdc] Write Protect is off
[40371.585238] sd 4:0:0:0: [sdc] Mode Sense: 23 00 00 00
[40371.586045] sd 4:0:0:0: [sdc] No Caching mode page present
[40371.586054] sd 4:0:0:0: [sdc] Assuming drive cache: write through
[40371.592261] sd 4:0:0:0: [sdc] No Caching mode page present
[40371.592271] sd 4:0:0:0: [sdc] Assuming drive cache: write through
[40371.631042]  sdc: sdc1 sdc2 sdc3 sdc4
[40371.634332] sd 4:0:0:0: [sdc] No Caching mode page present
[40371.634342] sd 4:0:0:0: [sdc] Assuming drive cache: write through
[40371.634348] sd 4:0:0:0: [sdc] Attached SCSI disk
[40377.781777] XFS (dm-2): Mounting Filesystem
[40378.010679] XFS (dm-2): Ending clean mount
[40504.820544] CPU1: Core temperature above threshold, cpu clock throttled (total events = 1)
[40504.820546] CPU3: Core temperature above threshold, cpu clock throttled (total events = 1)
[40504.820548] CPU2: Package temperature above threshold, cpu clock throttled (total events = 1)
[40504.820549] CPU0: Package temperature above threshold, cpu clock throttled (total events = 1)
[40504.820550] CPU3: Package temperature above threshold, cpu clock throttled (total events = 1)
[40504.820559] CPU1: Package temperature above threshold, cpu clock throttled (total events = 1)
[40504.822575] CPU1: Core temperature/speed normal
[40504.822576] CPU3: Core temperature/speed normal
[40504.822578] CPU0: Package temperature/speed normal
[40504.822579] CPU2: Package temperature/speed normal
[40504.822580] CPU3: Package temperature/speed normal
[40504.822586] CPU1: Package temperature/speed normal
[40578.290045] mce: [Hardware Error]: Machine check events logged
[41875.939814] CPU2: Core temperature above threshold, cpu clock throttled (total events = 1603)
[41875.939816] CPU1: Package temperature above threshold, cpu clock throttled (total events = 1919)
[41875.939818] CPU0: Core temperature above threshold, cpu clock throttled (total events = 1603)
[41875.939819] CPU3: Package temperature above threshold, cpu clock throttled (total events = 1919)
[41875.939820] CPU0: Package temperature above threshold, cpu clock throttled (total events = 1919)
[41875.939828] CPU2: Package temperature above threshold, cpu clock throttled (total events = 1919)
[41875.940826] CPU2: Core temperature/speed normal
[41875.940827] CPU1: Package temperature/speed normal
[41875.940828] CPU0: Core temperature/speed normal
[41875.940830] CPU3: Package temperature/speed normal
[41875.940832] CPU0: Package temperature/speed normal
[41875.940837] CPU2: Package temperature/speed normal
[41926.253009] mce: [Hardware Error]: Machine check events logged
[45905.828273] CPU2: Core temperature above threshold, cpu clock throttled (total events = 4602)
[45905.828275] CPU0: Core temperature above threshold, cpu clock throttled (total events = 4602)
[45905.828278] CPU0: Package temperature above threshold, cpu clock throttled (total events = 6451)
[45905.828289] CPU2: Package temperature above threshold, cpu clock throttled (total events = 6451)
[45905.828301] CPU3: Package temperature above threshold, cpu clock throttled (total events = 6451)
[45905.828303] CPU1: Package temperature above threshold, cpu clock throttled (total events = 6451)
[45905.829262] CPU2: Core temperature/speed normal
[45905.829264] CPU1: Package temperature/speed normal
[45905.829265] CPU3: Package temperature/speed normal
[45905.829266] CPU0: Core temperature/speed normal
[45905.829268] CPU0: Package temperature/speed normal
[45905.829274] CPU2: Package temperature/speed normal
[45946.742088] usb 2-1.2: USB disconnect, device number 5
[45968.216562] EXT4-fs (sda4): re-mounted. Opts: commit=600
[45968.701302] ------------[ cut here ]------------
[45968.701317] WARNING: at drivers/gpu/drm/i915/intel_display.c:6976 intel_modeset_check_state+0x4bb/0x610 [i915]()
[45968.701318] Hardware name: MacBookAir4,2
[45968.701319] encoder's hw state doesn't match sw tracking (expected 1, found 0)
[45968.701320] Modules linked in: xfs ext4 jbd2 mbcache sha256_generic arc4 brcmsmac cordic brcmutil uvcvideo btusb mac80211 videobuf2_vmalloc bluetooth cfg80211 videobuf2_memops joydev rfkill crc16 videobuf2_core videodev hid_generic bcm5974 media snd_hda_codec_hdmi snd_hda_codec_cirrus i915 intel_agp intel_gtt drm_kms_helper drm i2c_algo_bit snd_hda_intel iTCO_wdt snd_hda_codec i2c_i801 iTCO_vendor_support coretemp applesmc acpi_cpufreq mperf lpc_ich mei pcspkr snd_hwdep bcma i2c_core evdev processor apple_bl input_polldev ac battery video button microcode snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_timer snd soundcore kvm_intel kvm nfs lockd sunrpc fscache jfs dm_crypt dm_mod sd_mod hid_apple ata_generic pata_acpi usbhid usb_storage hid uhci_hcd crc32c_intel ghash_clmulni_intel aesni_intel
[45968.701362]  aes_x86_64 ablk_helper cryptd xts lrw gf128mul ata_piix libata ehci_hcd scsi_mod usbcore usb_common
[45968.701370] Pid: 732, comm: X Tainted: G        W    3.7.5-1-ARCH #1
[45968.701371] Call Trace:
[45968.701376]  [<ffffffff8105750f>] warn_slowpath_common+0x7f/0xc0
[45968.701378]  [<ffffffff81057606>] warn_slowpath_fmt+0x46/0x50
[45968.701385]  [<ffffffffa04968cb>] intel_modeset_check_state+0x4bb/0x610 [i915]
[45968.701390]  [<ffffffffa0496a64>] intel_connector_dpms+0x44/0x70 [i915]
[45968.701396]  [<ffffffffa0400d3d>] drm_mode_obj_set_property_ioctl+0x32d/0x340 [drm]
[45968.701400]  [<ffffffffa0400d80>] drm_mode_connector_property_set_ioctl+0x30/0x40 [drm]
[45968.701404]  [<ffffffffa03ef3f3>] drm_ioctl+0x4c3/0x570 [drm]
[45968.701408]  [<ffffffffa0400d50>] ? drm_mode_obj_set_property_ioctl+0x340/0x340 [drm]
[45968.701412]  [<ffffffff8112a5b7>] ? __free_pages+0x57/0x70
[45968.701415]  [<ffffffff8116f60c>] ? kfree+0x2c/0x160
[45968.701418]  [<ffffffff81195e07>] do_vfs_ioctl+0x97/0x530
[45968.701421]  [<ffffffff81185b8e>] ? ____fput+0xe/0x10
[45968.701423]  [<ffffffff81196331>] sys_ioctl+0x91/0xb0
[45968.701426]  [<ffffffff81015dbc>] ? do_notify_resume+0x9c/0xb0
[45968.701429]  [<ffffffff814c111d>] system_call_fastpath+0x1a/0x1f
[45968.701430] ---[ end trace fc0a823385ed6930 ]---
[45968.723954] ------------[ cut here ]------------
[45968.723972] WARNING: at drivers/gpu/drm/i915/intel_dp.c:1908 intel_dp_link_down+0x1d2/0x1e0 [i915]()
[45968.723974] Hardware name: MacBookAir4,2
[45968.723975] Modules linked in: xfs ext4 jbd2 mbcache sha256_generic arc4 brcmsmac cordic brcmutil uvcvideo btusb mac80211 videobuf2_vmalloc bluetooth cfg80211 videobuf2_memops joydev rfkill crc16 videobuf2_core videodev hid_generic bcm5974 media snd_hda_codec_hdmi snd_hda_codec_cirrus i915 intel_agp intel_gtt drm_kms_helper drm i2c_algo_bit snd_hda_intel iTCO_wdt snd_hda_codec i2c_i801 iTCO_vendor_support coretemp applesmc acpi_cpufreq mperf lpc_ich mei pcspkr snd_hwdep bcma i2c_core evdev processor apple_bl input_polldev ac battery video button microcode snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_timer snd soundcore kvm_intel kvm nfs lockd sunrpc fscache jfs dm_crypt dm_mod sd_mod hid_apple ata_generic pata_acpi usbhid usb_storage hid uhci_hcd crc32c_intel ghash_clmulni_intel aesni_intel
[45968.724017]  aes_x86_64 ablk_helper cryptd xts lrw gf128mul ata_piix libata ehci_hcd scsi_mod usbcore usb_common
[45968.724025] Pid: 732, comm: X Tainted: G        W    3.7.5-1-ARCH #1
[45968.724026] Call Trace:
[45968.724031]  [<ffffffff8105750f>] warn_slowpath_common+0x7f/0xc0
[45968.724033]  [<ffffffff8105756a>] warn_slowpath_null+0x1a/0x20
[45968.724039]  [<ffffffffa049f3e2>] intel_dp_link_down+0x1d2/0x1e0 [i915]
[45968.724045]  [<ffffffffa04a1584>] intel_disable_dp+0x44/0x170 [i915]
[45968.724051]  [<ffffffffa049026e>] ironlake_crtc_disable+0x68e/0x820 [i915]
[45968.724057]  [<ffffffffa04952f7>] intel_crtc_update_dpms+0x77/0xb0 [i915]
[45968.724062]  [<ffffffffa04953ea>] intel_encoder_dpms+0x1a/0x30 [i915]
[45968.724068]  [<ffffffffa0496a5c>] intel_connector_dpms+0x3c/0x70 [i915]
[45968.724073]  [<ffffffffa0400d3d>] drm_mode_obj_set_property_ioctl+0x32d/0x340 [drm]
[45968.724077]  [<ffffffffa0400d80>] drm_mode_connector_property_set_ioctl+0x30/0x40 [drm]
[45968.724081]  [<ffffffffa03ef3f3>] drm_ioctl+0x4c3/0x570 [drm]
[45968.724086]  [<ffffffffa0400d50>] ? drm_mode_obj_set_property_ioctl+0x340/0x340 [drm]
[45968.724089]  [<ffffffff8112a5b7>] ? __free_pages+0x57/0x70
[45968.724092]  [<ffffffff8116f60c>] ? kfree+0x2c/0x160
[45968.724095]  [<ffffffff81195e07>] do_vfs_ioctl+0x97/0x530
[45968.724097]  [<ffffffff81185b8e>] ? ____fput+0xe/0x10
[45968.724099]  [<ffffffff81196331>] sys_ioctl+0x91/0xb0
[45968.724102]  [<ffffffff81015dbc>] ? do_notify_resume+0x9c/0xb0
[45968.724105]  [<ffffffff814c111d>] system_call_fastpath+0x1a/0x1f
[45968.724107] ---[ end trace fc0a823385ed6931 ]---
[45970.088488] mce: [Hardware Error]: Machine check events logged
[46033.040921] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[46033.040939] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[46033.040945] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[46033.047246] cfg80211: Calling CRDA to update world regulatory domain
[46037.043652] wlan0: authenticate with d4:a0:2a:9a:fa:4f
[46037.045575] wlan0: direct probe to d4:a0:2a:9a:fa:4f (try 1/3)
[46037.247339] wlan0: direct probe to d4:a0:2a:9a:fa:4f (try 2/3)
[46037.450310] wlan0: send auth to d4:a0:2a:9a:fa:4f (try 3/3)
[46037.451019] wlan0: authenticated
[46037.453854] wlan0: associate with d4:a0:2a:9a:fa:4f (try 1/3)
[46037.455602] wlan0: RX AssocResp from d4:a0:2a:9a:fa:4f (capab=0x11 status=0 aid=4)
[46037.456199] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[46037.456210] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[46037.456216] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[46037.456233] wlan0: associated
[46042.685934] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[49370.259152] PM: Syncing filesystems ... done.
[49370.380006] PM: Preparing system for mem sleep
[49370.559104] Freezing user space processes ... (elapsed 0.02 seconds) done.
[49370.585190] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[49370.598477] PM: Entering mem sleep
[49370.598540] Suspending console(s) (use no_console_suspend to debug)
[49370.647656] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[49370.648947] sd 0:0:0:0: [sda] Stopping disk
[49372.122655] PM: suspend of devices complete after 1486.177 msecs
[49372.123133] PM: late suspend of devices complete after 0.473 msecs
[49372.136299] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[49372.149432] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[49372.175899] PM: noirq suspend of devices complete after 52.843 msecs
[49372.176774] ACPI: Preparing to enter system sleep state S3
[49372.202504] PM: Saving platform NVS memory
[49372.203523] Disabling non-boot CPUs ...
[49372.305551] smpboot: CPU 1 is now offline
[49372.408721] smpboot: CPU 2 is now offline
[49372.511897] smpboot: CPU 3 is now offline
[49372.512558] Extended CMOS year: 2000
[49372.514659] ACPI: Low-level resume complete
[49372.514701] PM: Restoring platform NVS memory
[49372.515013] Extended CMOS year: 2000
[49372.515076] Enabling non-boot CPUs ...
[49372.518517] smpboot: Booting Node 0 Processor 1 APIC 0x2
[49372.532856] CPU1 is up
[49372.536247] smpboot: Booting Node 0 Processor 2 APIC 0x1
[49372.549890] CPU2 is up
[49372.550622] smpboot: Booting Node 0 Processor 3 APIC 0x3
[49372.564926] CPU3 is up
[49372.569841] ACPI: Waking up from system sleep state S3
[49373.110180] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[49373.123599] pcieport 0000:00:1c.1: power state changed by ACPI to D0
[49373.136794] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[49373.163791] PM: noirq resume of devices complete after 93.662 msecs
[49373.164188] PM: early resume of devices complete after 0.354 msecs
[49373.164259] i915 0000:00:02.0: setting latency timer to 64
[49373.164338] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[49373.164461] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[49373.164499] usb usb3: root hub lost power or was reset
[49373.164542] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[49373.164601] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[49373.164624] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[49373.164653] usb usb4: root hub lost power or was reset
[49373.164686] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[49373.164730] ata_piix 0000:00:1f.2: setting latency timer to 64
[49373.165367] mei 0000:00:16.0: wd: failed to find the client
[49373.193993] bcm5974: bad trackpad package, length: 8
[49373.194990] bcm5974: bad trackpad package, length: 8
[49373.195995] bcm5974: bad trackpad package, length: 8
[49373.209968] bcm5974: bad trackpad package, length: 8
[49373.210965] bcm5974: bad trackpad package, length: 8
[49373.211963] bcm5974: bad trackpad package, length: 8
[49373.219905] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake old ack to clear.
[49373.219916] bcm5974: bad trackpad package, length: 8
[49373.220978] bcm5974: bad trackpad package, length: 8
[49373.221365] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[49373.221956] bcm5974: bad trackpad package, length: 8
[49373.247930] bcm5974: bad trackpad package, length: 8
[49374.185128] ata2.00: failed to resume link (SControl 0)
[49374.504625] ata1.01: failed to resume link (SControl 0)
[49374.657777] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[49374.657789] ata1.01: SATA link down (SStatus 0 SControl 0)
[49374.687914] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[49374.694668] ata1.00: configured for UDMA/133
[49374.730523] sd 0:0:0:0: [sda] Starting disk
[49375.206865] ata2.01: failed to resume link (SControl 0)
[49375.218487] ata2.00: SATA link down (SStatus 4 SControl 0)
[49375.218502] ata2.01: SATA link down (SStatus 0 SControl 0)
[49375.234833] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[49375.235832] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[49375.235835] ieee80211 phy0: changing basic rates failed: -22
[49375.235837] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: threshold 0, hys 0  (implement)
[49375.235838] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[49375.235840] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[49375.235995] PM: resume of devices complete after 2075.029 msecs
[49375.236445] PM: Finishing wakeup.
[49375.236446] Restarting tasks ... done.
[49375.261010] video LNXVIDEO:00: Restoring backlight state
[49375.286723] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[49375.286729] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[49375.286731] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[49375.287277] cfg80211: Calling CRDA to update world regulatory domain
[49379.267714] wlan0: authenticate with d4:a0:2a:9a:fa:4f
[49379.269051] wlan0: send auth to d4:a0:2a:9a:fa:4f (try 1/3)
[49379.269663] wlan0: authenticated
[49379.270520] wlan0: associate with d4:a0:2a:9a:fa:4f (try 1/3)
[49379.272207] wlan0: RX AssocResp from d4:a0:2a:9a:fa:4f (capab=0x11 status=0 aid=14)
[49379.272686] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[49379.272692] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[49379.272696] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[49379.272705] wlan0: associated
[49384.327525] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[49689.178267] CPU1: Core temperature above threshold, cpu clock throttled (total events = 1998)
[49689.178269] CPU3: Core temperature above threshold, cpu clock throttled (total events = 1998)
[49689.178272] CPU3: Package temperature above threshold, cpu clock throttled (total events = 6705)
[49689.178286] CPU1: Package temperature above threshold, cpu clock throttled (total events = 6705)
[49689.178300] CPU0: Package temperature above threshold, cpu clock throttled (total events = 6705)
[49689.178301] CPU2: Package temperature above threshold, cpu clock throttled (total events = 6705)
[49689.179246] CPU1: Core temperature/speed normal
[49689.179247] CPU3: Core temperature/speed normal
[49689.179249] CPU3: Package temperature/speed normal
[49689.179252] CPU0: Package temperature/speed normal
[49689.179253] CPU1: Package temperature/speed normal
[49689.179254] CPU2: Package temperature/speed normal
[49723.351496] mce: [Hardware Error]: Machine check events logged
[49750.534721] PM: Syncing filesystems ... done.
[49750.653370] PM: Preparing system for mem sleep
[49750.720460] Freezing user space processes ... (elapsed 0.01 seconds) done.
[49750.732265] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[49750.745588] PM: Entering mem sleep
[49750.745613] Suspending console(s) (use no_console_suspend to debug)
[49750.794401] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[49750.795652] sd 0:0:0:0: [sda] Stopping disk
[49752.433034] PM: suspend of devices complete after 1649.849 msecs
[49752.433429] PM: late suspend of devices complete after 0.391 msecs
[49752.446688] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[49752.459827] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[49752.486291] PM: noirq suspend of devices complete after 52.939 msecs
[49752.487166] ACPI: Preparing to enter system sleep state S3
[49752.512894] PM: Saving platform NVS memory
[49752.513892] Disabling non-boot CPUs ...
[49752.515728] smpboot: CPU 1 is now offline
[49752.619269] smpboot: CPU 2 is now offline
[49752.722437] smpboot: CPU 3 is now offline
[49752.723086] Extended CMOS year: 2000
[49752.725193] ACPI: Low-level resume complete
[49752.725235] PM: Restoring platform NVS memory
[49752.725549] Extended CMOS year: 2000
[49752.725612] Enabling non-boot CPUs ...
[49752.725758] smpboot: Booting Node 0 Processor 1 APIC 0x2
[49752.739954] CPU1 is up
[49752.740012] smpboot: Booting Node 0 Processor 2 APIC 0x1
[49752.753537] CPU2 is up
[49752.754257] smpboot: Booting Node 0 Processor 3 APIC 0x3
[49752.768576] CPU3 is up
[49752.773480] ACPI: Waking up from system sleep state S3
[49753.314075] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[49753.327498] pcieport 0000:00:1c.1: power state changed by ACPI to D0
[49753.340699] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[49753.367690] PM: noirq resume of devices complete after 93.671 msecs
[49753.368077] PM: early resume of devices complete after 0.344 msecs
[49753.368142] i915 0000:00:02.0: setting latency timer to 64
[49753.368171] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[49753.368203] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[49753.368222] usb usb3: root hub lost power or was reset
[49753.368236] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[49753.368259] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[49753.368286] usb usb4: root hub lost power or was reset
[49753.368297] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[49753.368303] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[49753.368327] ata_piix 0000:00:1f.2: setting latency timer to 64
[49753.368951] mei 0000:00:16.0: wd: failed to find the client
[49753.423805] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake old ack to clear.
[49753.425009] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[49753.519944] Extended CMOS year: 2000
[49754.389086] ata2.00: failed to resume link (SControl 0)
[49754.708615] ata1.01: failed to resume link (SControl 0)
[49754.861804] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[49754.861822] ata1.01: SATA link down (SStatus 0 SControl 0)
[49754.868709] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[49754.875471] ata1.00: configured for UDMA/133
[49754.909032] sd 0:0:0:0: [sda] Starting disk
[49755.410853] ata2.01: failed to resume link (SControl 0)
[49755.422758] ata2.00: SATA link down (SStatus 4 SControl 0)
[49755.422780] ata2.01: SATA link down (SStatus 0 SControl 0)
[49755.439766] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[49755.440782] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[49755.440784] ieee80211 phy0: changing basic rates failed: -22
[49755.440785] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: threshold 0, hys 0  (implement)
[49755.440786] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[49755.440787] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[49755.441064] PM: resume of devices complete after 2076.210 msecs
[49755.467570] PM: Finishing wakeup.
[49755.467574] Restarting tasks ... done.
[49755.507254] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[49755.509184] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[49755.511210] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[49755.537235] cfg80211: Calling CRDA for country: CH
[49755.546370] video LNXVIDEO:00: Restoring backlight state
[49755.633723] EXT4-fs (sda4): re-mounted. Opts: commit=0
[49759.525662] wlan0: authenticate with d4:a0:2a:98:a6:af
[49759.528229] wlan0: direct probe to d4:a0:2a:98:a6:af (try 1/3)
[49759.730683] wlan0: send auth to d4:a0:2a:98:a6:af (try 2/3)
[49759.731397] wlan0: authenticated
[49759.734087] wlan0: associate with d4:a0:2a:98:a6:af (try 1/3)
[49759.736004] wlan0: RX AssocResp from d4:a0:2a:98:a6:af (capab=0x11 status=0 aid=50)
[49759.736532] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[49759.736542] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[49759.736547] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[49759.736564] wlan0: associated
[49765.059475] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[54024.408661] EXT4-fs (sda4): re-mounted. Opts: commit=600
[54069.245673] ------------[ cut here ]------------
[54069.245714] WARNING: at drivers/gpu/drm/i915/intel_display.c:6976 intel_modeset_check_state+0x4bb/0x610 [i915]()
[54069.245718] Hardware name: MacBookAir4,2
[54069.245722] encoder's hw state doesn't match sw tracking (expected 1, found 0)
[54069.245725] Modules linked in: xfs ext4 jbd2 mbcache sha256_generic arc4 brcmsmac cordic brcmutil uvcvideo btusb mac80211 videobuf2_vmalloc bluetooth cfg80211 videobuf2_memops joydev rfkill crc16 videobuf2_core videodev hid_generic bcm5974 media snd_hda_codec_hdmi snd_hda_codec_cirrus i915 intel_agp intel_gtt drm_kms_helper drm i2c_algo_bit snd_hda_intel iTCO_wdt snd_hda_codec i2c_i801 iTCO_vendor_support coretemp applesmc acpi_cpufreq mperf lpc_ich mei pcspkr snd_hwdep bcma i2c_core evdev processor apple_bl input_polldev ac battery video button microcode snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_timer snd soundcore kvm_intel kvm nfs lockd sunrpc fscache jfs dm_crypt dm_mod sd_mod hid_apple ata_generic pata_acpi usbhid usb_storage hid uhci_hcd crc32c_intel ghash_clmulni_intel aesni_intel
[54069.245845]  aes_x86_64 ablk_helper cryptd xts lrw gf128mul ata_piix libata ehci_hcd scsi_mod usbcore usb_common
[54069.245868] Pid: 732, comm: X Tainted: G        W    3.7.5-1-ARCH #1
[54069.245872] Call Trace:
[54069.245885]  [<ffffffff8105750f>] warn_slowpath_common+0x7f/0xc0
[54069.245893]  [<ffffffff81057606>] warn_slowpath_fmt+0x46/0x50
[54069.245914]  [<ffffffffa04968cb>] intel_modeset_check_state+0x4bb/0x610 [i915]
[54069.245931]  [<ffffffffa0496a64>] intel_connector_dpms+0x44/0x70 [i915]
[54069.245947]  [<ffffffffa0400d3d>] drm_mode_obj_set_property_ioctl+0x32d/0x340 [drm]
[54069.245961]  [<ffffffffa0400d80>] drm_mode_connector_property_set_ioctl+0x30/0x40 [drm]
[54069.245974]  [<ffffffffa03ef3f3>] drm_ioctl+0x4c3/0x570 [drm]
[54069.245988]  [<ffffffffa0400d50>] ? drm_mode_obj_set_property_ioctl+0x340/0x340 [drm]
[54069.246000]  [<ffffffff8112a5b7>] ? __free_pages+0x57/0x70
[54069.246009]  [<ffffffff8116f60c>] ? kfree+0x2c/0x160
[54069.246017]  [<ffffffff81195e07>] do_vfs_ioctl+0x97/0x530
[54069.246025]  [<ffffffff81185b8e>] ? ____fput+0xe/0x10
[54069.246031]  [<ffffffff81196331>] sys_ioctl+0x91/0xb0
[54069.246041]  [<ffffffff81015dbc>] ? do_notify_resume+0x9c/0xb0
[54069.246052]  [<ffffffff814c111d>] system_call_fastpath+0x1a/0x1f
[54069.246057] ---[ end trace fc0a823385ed6932 ]---
[54069.268260] ------------[ cut here ]------------
[54069.268302] WARNING: at drivers/gpu/drm/i915/intel_dp.c:1908 intel_dp_link_down+0x1d2/0x1e0 [i915]()
[54069.268307] Hardware name: MacBookAir4,2
[54069.268310] Modules linked in: xfs ext4 jbd2 mbcache sha256_generic arc4 brcmsmac cordic brcmutil uvcvideo btusb mac80211 videobuf2_vmalloc bluetooth cfg80211 videobuf2_memops joydev rfkill crc16 videobuf2_core videodev hid_generic bcm5974 media snd_hda_codec_hdmi snd_hda_codec_cirrus i915 intel_agp intel_gtt drm_kms_helper drm i2c_algo_bit snd_hda_intel iTCO_wdt snd_hda_codec i2c_i801 iTCO_vendor_support coretemp applesmc acpi_cpufreq mperf lpc_ich mei pcspkr snd_hwdep bcma i2c_core evdev processor apple_bl input_polldev ac battery video button microcode snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_timer snd soundcore kvm_intel kvm nfs lockd sunrpc fscache jfs dm_crypt dm_mod sd_mod hid_apple ata_generic pata_acpi usbhid usb_storage hid uhci_hcd crc32c_intel ghash_clmulni_intel aesni_intel
[54069.268432]  aes_x86_64 ablk_helper cryptd xts lrw gf128mul ata_piix libata ehci_hcd scsi_mod usbcore usb_common
[54069.268454] Pid: 732, comm: X Tainted: G        W    3.7.5-1-ARCH #1
[54069.268458] Call Trace:
[54069.268472]  [<ffffffff8105750f>] warn_slowpath_common+0x7f/0xc0
[54069.268478]  [<ffffffff8105756a>] warn_slowpath_null+0x1a/0x20
[54069.268497]  [<ffffffffa049f3e2>] intel_dp_link_down+0x1d2/0x1e0 [i915]
[54069.268514]  [<ffffffffa04a1584>] intel_disable_dp+0x44/0x170 [i915]
[54069.268534]  [<ffffffffa049026e>] ironlake_crtc_disable+0x68e/0x820 [i915]
[54069.268553]  [<ffffffffa04952f7>] intel_crtc_update_dpms+0x77/0xb0 [i915]
[54069.268570]  [<ffffffffa04953ea>] intel_encoder_dpms+0x1a/0x30 [i915]
[54069.268588]  [<ffffffffa0496a5c>] intel_connector_dpms+0x3c/0x70 [i915]
[54069.268605]  [<ffffffffa0400d3d>] drm_mode_obj_set_property_ioctl+0x32d/0x340 [drm]
[54069.268619]  [<ffffffffa0400d80>] drm_mode_connector_property_set_ioctl+0x30/0x40 [drm]
[54069.268633]  [<ffffffffa03ef3f3>] drm_ioctl+0x4c3/0x570 [drm]
[54069.268647]  [<ffffffffa0400d50>] ? drm_mode_obj_set_property_ioctl+0x340/0x340 [drm]
[54069.268657]  [<ffffffff8112a5b7>] ? __free_pages+0x57/0x70
[54069.268666]  [<ffffffff8116f60c>] ? kfree+0x2c/0x160
[54069.268674]  [<ffffffff81195e07>] do_vfs_ioctl+0x97/0x530
[54069.268681]  [<ffffffff81185b8e>] ? ____fput+0xe/0x10
[54069.268687]  [<ffffffff81196331>] sys_ioctl+0x91/0xb0
[54069.268696]  [<ffffffff81015dbc>] ? do_notify_resume+0x9c/0xb0
[54069.268706]  [<ffffffff814c111d>] system_call_fastpath+0x1a/0x1f
[54069.268711] ---[ end trace fc0a823385ed6933 ]---
[55189.979694] PM: Syncing filesystems ... done.
[55190.124812] PM: Preparing system for mem sleep
[55190.273446] Freezing user space processes ... (elapsed 0.01 seconds) done.
[55190.286447] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[55190.299870] PM: Entering mem sleep
[55190.299889] Suspending console(s) (use no_console_suspend to debug)
[55190.349162] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[55190.350450] sd 0:0:0:0: [sda] Stopping disk
[55191.933876] PM: suspend of devices complete after 1596.147 msecs
[55191.934353] PM: late suspend of devices complete after 0.473 msecs
[55191.947552] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[55191.960685] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[55191.987150] PM: noirq suspend of devices complete after 52.876 msecs
[55191.988025] ACPI: Preparing to enter system sleep state S3
[55192.013754] PM: Saving platform NVS memory
[55192.014775] Disabling non-boot CPUs ...
[55192.116802] smpboot: CPU 1 is now offline
[55192.219972] smpboot: CPU 2 is now offline
[55192.323147] smpboot: CPU 3 is now offline
[55192.323766] Extended CMOS year: 2000
[55192.325869] ACPI: Low-level resume complete
[55192.325912] PM: Restoring platform NVS memory
[55192.326226] Extended CMOS year: 2000
[55192.326289] Enabling non-boot CPUs ...
[55192.329732] smpboot: Booting Node 0 Processor 1 APIC 0x2
[55192.344339] CPU1 is up
[55192.347730] smpboot: Booting Node 0 Processor 2 APIC 0x1
[55192.361277] CPU2 is up
[55192.361721] smpboot: Booting Node 0 Processor 3 APIC 0x3
[55192.376257] CPU3 is up
[55192.381250] ACPI: Waking up from system sleep state S3
[55192.921434] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[55192.934856] pcieport 0000:00:1c.1: power state changed by ACPI to D0
[55192.948051] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[55192.975049] PM: noirq resume of devices complete after 93.661 msecs
[55192.975445] PM: early resume of devices complete after 0.354 msecs
[55192.975500] i915 0000:00:02.0: setting latency timer to 64
[55192.975586] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[55192.975657] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[55192.975694] usb usb3: root hub lost power or was reset
[55192.975732] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[55192.975763] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[55192.975778] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[55192.975798] usb usb4: root hub lost power or was reset
[55192.975819] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[55192.975836] ata_piix 0000:00:1f.2: setting latency timer to 64
[55192.976448] mei 0000:00:16.0: wd: failed to find the client
[55193.031162] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake old ack to clear.
[55193.032658] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[55193.111522] Extended CMOS year: 2000
[55193.996452] ata2.00: failed to resume link (SControl 0)
[55194.315970] ata1.01: failed to resume link (SControl 0)
[55194.469131] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[55194.469142] ata1.01: SATA link down (SStatus 0 SControl 0)
[55194.476024] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[55194.482825] ata1.00: configured for UDMA/133
[55194.517183] sd 0:0:0:0: [sda] Starting disk
[55195.018207] ata2.01: failed to resume link (SControl 0)
[55195.030125] ata2.00: SATA link down (SStatus 4 SControl 0)
[55195.030148] ata2.01: SATA link down (SStatus 0 SControl 0)
[55195.046896] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[55195.047920] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[55195.047926] ieee80211 phy0: changing basic rates failed: -22
[55195.047931] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: threshold 0, hys 0  (implement)
[55195.047934] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[55195.047937] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[55195.048257] PM: resume of devices complete after 2076.032 msecs
[55195.076507] PM: Finishing wakeup.
[55195.076508] Restarting tasks ... done.
[55195.100862] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[55195.102196] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[55195.103508] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[55195.111298] cfg80211: Calling CRDA to update world regulatory domain
[55195.124334] video LNXVIDEO:00: Restoring backlight state
[55199.092790] wlan0: authenticate with d4:a0:2a:98:a6:af
[55199.093739] wlan0: send auth to d4:a0:2a:98:a6:af (try 1/3)
[55199.114409] wlan0: authenticated
[55199.115081] wlan0: associate with d4:a0:2a:98:a6:af (try 1/3)
[55199.116895] wlan0: RX AssocResp from d4:a0:2a:98:a6:af (capab=0x11 status=0 aid=66)
[55199.117402] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[55199.117412] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[55199.117417] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[55199.117435] wlan0: associated
[55204.626900] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[55506.215717] EXT4-fs (sda4): re-mounted. Opts: commit=0
[55923.201305] ieee80211 phy0: START: tid 1 is not agg'able
[56454.732581] ieee80211 phy0: START: tid 1 is not agg'able
[56580.408155] ieee80211 phy0: START: tid 1 is not agg'able
[56732.974053] ieee80211 phy0: START: tid 1 is not agg'able
[56881.891997] ieee80211 phy0: START: tid 2 is not agg'able
[56912.102292] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[57930.452159] ieee80211 phy0: START: tid 1 is not agg'able
[58023.185017] EXT4-fs (sda4): re-mounted. Opts: commit=600
[58023.726956] PM: Syncing filesystems ... done.
[58023.823396] PM: Preparing system for mem sleep
[58023.964564] Freezing user space processes ... (elapsed 0.01 seconds) done.
[58023.977546] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[58023.990738] PM: Entering mem sleep
[58023.990805] Suspending console(s) (use no_console_suspend to debug)
[58024.040161] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[58024.041489] sd 0:0:0:0: [sda] Stopping disk
[58025.654850] PM: suspend of devices complete after 1626.194 msecs
[58025.655331] PM: late suspend of devices complete after 0.477 msecs
[58025.668478] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[58025.681600] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[58025.708064] PM: noirq suspend of devices complete after 52.811 msecs
[58025.708939] ACPI: Preparing to enter system sleep state S3
[58025.734668] PM: Saving platform NVS memory
[58025.735661] Disabling non-boot CPUs ...
[58025.737401] smpboot: CPU 1 is now offline
[58025.841041] smpboot: CPU 2 is now offline
[58025.944222] smpboot: CPU 3 is now offline
[58025.944893] Extended CMOS year: 2000
[58025.946997] ACPI: Low-level resume complete
[58025.947040] PM: Restoring platform NVS memory
[58025.947357] Extended CMOS year: 2000
[58025.947428] Enabling non-boot CPUs ...
[58025.950888] smpboot: Booting Node 0 Processor 1 APIC 0x2
[58025.965347] CPU1 is up
[58025.968757] smpboot: Booting Node 0 Processor 2 APIC 0x1
[58025.982368] CPU2 is up
[58025.982851] smpboot: Booting Node 0 Processor 3 APIC 0x3
[58025.997029] CPU3 is up
[58026.001959] ACPI: Waking up from system sleep state S3
[58026.542497] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[58026.555927] pcieport 0000:00:1c.1: power state changed by ACPI to D0
[58026.569116] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[58026.596114] PM: noirq resume of devices complete after 93.668 msecs
[58026.596587] PM: early resume of devices complete after 0.359 msecs
[58026.596668] i915 0000:00:02.0: setting latency timer to 64
[58026.596691] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[58026.596717] usb usb3: root hub lost power or was reset
[58026.596727] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[58026.596734] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[58026.596794] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[58026.596805] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[58026.596833] usb usb4: root hub lost power or was reset
[58026.596852] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[58026.596865] ata_piix 0000:00:1f.2: setting latency timer to 64
[58026.597401] mei 0000:00:16.0: wd: failed to find the client
[58026.652222] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake old ack to clear.
[58026.653529] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[58026.721961] Extended CMOS year: 2000
[58027.617515] ata2.00: failed to resume link (SControl 0)
[58027.937024] ata1.01: failed to resume link (SControl 0)
[58028.090250] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[58028.090267] ata1.01: SATA link down (SStatus 0 SControl 0)
[58028.097151] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[58028.103933] ata1.00: configured for UDMA/133
[58028.138476] sd 0:0:0:0: [sda] Starting disk
[58028.639284] ata2.01: failed to resume link (SControl 0)
[58028.651206] ata2.00: SATA link down (SStatus 4 SControl 0)
[58028.651229] ata2.01: SATA link down (SStatus 0 SControl 0)
[58028.667739] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[58028.668764] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[58028.668771] ieee80211 phy0: changing basic rates failed: -22
[58028.668775] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: threshold 0, hys 0  (implement)
[58028.668779] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[58028.668782] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[58028.669255] PM: resume of devices complete after 2075.883 msecs
[58028.703209] PM: Finishing wakeup.
[58028.703210] Restarting tasks ... done.
[58028.764745] video LNXVIDEO:00: Restoring backlight state
[58209.061584] PM: Syncing filesystems ... done.
[58209.188748] PM: Preparing system for mem sleep
[58209.251184] Freezing user space processes ... (elapsed 0.01 seconds) done.
[58209.267648] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[58209.280930] PM: Entering mem sleep
[58209.280981] Suspending console(s) (use no_console_suspend to debug)
[58209.324508] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[58209.325830] sd 0:0:0:0: [sda] Stopping disk
[58210.979171] PM: suspend of devices complete after 1659.590 msecs
[58210.979650] PM: late suspend of devices complete after 0.474 msecs
[58210.992800] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[58211.005930] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[58211.032406] PM: noirq suspend of devices complete after 52.807 msecs
[58211.033281] ACPI: Preparing to enter system sleep state S3
[58211.059026] PM: Saving platform NVS memory
[58211.060033] Disabling non-boot CPUs ...
[58211.061746] smpboot: CPU 1 is now offline
[58211.165446] smpboot: CPU 2 is now offline
[58211.167527] smpboot: CPU 3 is now offline
[58211.168014] Extended CMOS year: 2000
[58211.170125] ACPI: Low-level resume complete
[58211.170168] PM: Restoring platform NVS memory
[58211.170487] Extended CMOS year: 2000
[58211.170558] Enabling non-boot CPUs ...
[58211.174067] smpboot: Booting Node 0 Processor 1 APIC 0x2
[58211.188794] CPU1 is up
[58211.192203] smpboot: Booting Node 0 Processor 2 APIC 0x1
[58211.205814] CPU2 is up
[58211.206486] smpboot: Booting Node 0 Processor 3 APIC 0x3
[58211.220703] CPU3 is up
[58211.225631] ACPI: Waking up from system sleep state S3
[58211.767371] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[58211.780807] pcieport 0000:00:1c.1: power state changed by ACPI to D0
[58211.794003] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[58211.821014] PM: noirq resume of devices complete after 93.672 msecs
[58211.821400] PM: early resume of devices complete after 0.342 msecs
[58211.821468] i915 0000:00:02.0: setting latency timer to 64
[58211.821524] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[58211.821623] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[58211.821647] usb usb3: root hub lost power or was reset
[58211.821674] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[58211.821683] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[58211.821703] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[58211.821723] ata_piix 0000:00:1f.2: setting latency timer to 64
[58211.821735] usb usb4: root hub lost power or was reset
[58211.821736] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[58211.822267] mei 0000:00:16.0: wd: failed to find the client
[58211.877136] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake old ack to clear.
[58211.878321] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[58211.974796] Extended CMOS year: 2000
[58212.846249] ata2.00: failed to resume link (SControl 0)
[58213.166160] ata1.01: failed to resume link (SControl 0)
[58213.319328] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[58213.319347] ata1.01: SATA link down (SStatus 0 SControl 0)
[58213.326151] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[58213.332909] ata1.00: configured for UDMA/133
[58213.367389] sd 0:0:0:0: [sda] Starting disk
[58213.868503] ata2.01: failed to resume link (SControl 0)
[58213.880477] ata2.00: SATA link down (SStatus 4 SControl 0)
[58213.880500] ata2.01: SATA link down (SStatus 0 SControl 0)
[58213.897401] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[58213.898463] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[58213.898469] ieee80211 phy0: changing basic rates failed: -22
[58213.898474] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: threshold 0, hys 0  (implement)
[58213.898477] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[58213.898480] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[58213.898693] PM: resume of devices complete after 2079.479 msecs
[58213.917504] PM: Finishing wakeup.
[58213.918530] usb 1-1.2: USB disconnect, device number 5
[58213.919777] bcm5974 1-1.2:1.2: trackpad urb failed: -19
[58213.917505] Restarting tasks ... done.
[58213.948353] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[58213.950206] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[58213.952131] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[58213.952514] bcm5974 1-1.2:1.2: could not read from device
[58213.971012] video LNXVIDEO:00: Restoring backlight state
[58213.975834] cfg80211: Calling CRDA for country: US
[58214.027285] EXT4-fs (sda4): re-mounted. Opts: commit=0
[58214.194880] usb 1-1.2: new full-speed USB device number 9 using ehci_hcd
[58214.302737] input: Apple Inc. Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.0/input/input15
[58214.302944] apple 0003:05AC:024D.0005: input,hidraw0: USB HID v1.11 Keyboard [Apple Inc. Apple Internal Keyboard / Trackpad] on usb-0000:00:1a.7-1.2/input0
[58214.306019] apple 0003:05AC:024D.0006: hidraw1: USB HID v1.11 Device [Apple Inc. Apple Internal Keyboard / Trackpad] on usb-0000:00:1a.7-1.2/input1
[58214.306684] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input16
[58217.959365] wlan0: authenticate with d4:a0:2a:9a:f8:3f
[58217.961384] wlan0: direct probe to d4:a0:2a:9a:f8:3f (try 1/3)
[58218.163921] wlan0: send auth to d4:a0:2a:9a:f8:3f (try 2/3)
[58218.164641] wlan0: authenticated
[58218.167298] wlan0: associate with d4:a0:2a:9a:f8:3f (try 1/3)
[58218.169126] wlan0: RX AssocResp from d4:a0:2a:9a:f8:3f (capab=0x11 status=0 aid=2)
[58218.169634] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[58218.169644] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[58218.169649] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[58218.169665] wlan0: associated
[58222.825279] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 113
[58223.295257] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[61535.498609] ieee80211 phy0: START: tid 2 is not agg'able
[65069.116005] PM: Syncing filesystems ... done.
[65069.190799] PM: Preparing system for mem sleep
[65069.235568] Freezing user space processes ... (elapsed 0.01 seconds) done.
[65069.247632] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[65069.261098] PM: Entering mem sleep
[65069.261162] Suspending console(s) (use no_console_suspend to debug)
[65069.310138] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[65069.311446] sd 0:0:0:0: [sda] Stopping disk
[65070.492333] ------------[ cut here ]------------
[65070.492371] WARNING: at drivers/gpu/drm/i915/intel_dp.c:1908 intel_dp_link_down+0x1d2/0x1e0 [i915]()
[65070.492373] Hardware name: MacBookAir4,2
[65070.492463] Modules linked in: msr cpufreq_stats xfs ext4 jbd2 mbcache sha256_generic arc4 brcmsmac cordic brcmutil uvcvideo btusb mac80211 videobuf2_vmalloc bluetooth cfg80211 videobuf2_memops joydev rfkill crc16 videobuf2_core videodev hid_generic bcm5974 media snd_hda_codec_hdmi snd_hda_codec_cirrus i915 intel_agp intel_gtt drm_kms_helper drm i2c_algo_bit snd_hda_intel iTCO_wdt snd_hda_codec i2c_i801 iTCO_vendor_support coretemp applesmc acpi_cpufreq mperf lpc_ich mei pcspkr snd_hwdep bcma i2c_core evdev processor apple_bl input_polldev ac battery video button microcode snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_timer snd soundcore kvm_intel kvm nfs lockd sunrpc fscache jfs dm_crypt dm_mod sd_mod hid_apple ata_generic pata_acpi usbhid usb_storage hid uhci_hcd crc32c_intel ghash_clmulni_intel
[65070.492480]  aesni_intel aes_x86_64 ablk_helper cryptd xts lrw gf128mul ata_piix libata ehci_hcd scsi_mod usbcore usb_common
[65070.492485] Pid: 25605, comm: kworker/u:20 Tainted: G        W    3.7.5-1-ARCH #1
[65070.492487] Call Trace:
[65070.492499]  [<ffffffff8105750f>] warn_slowpath_common+0x7f/0xc0
[65070.492504]  [<ffffffff8105756a>] warn_slowpath_null+0x1a/0x20
[65070.492522]  [<ffffffffa049f3e2>] intel_dp_link_down+0x1d2/0x1e0 [i915]
[65070.492536]  [<ffffffffa04a1584>] intel_disable_dp+0x44/0x170 [i915]
[65070.492554]  [<ffffffffa049026e>] ironlake_crtc_disable+0x68e/0x820 [i915]
[65070.492570]  [<ffffffffa0494074>] intel_crtc_disable+0x34/0x130 [i915]
[65070.492586]  [<ffffffffa0495373>] intel_modeset_disable+0x43/0x60 [i915]
[65070.492598]  [<ffffffffa046805b>] i915_drm_freeze+0x5b/0xd0 [i915]
[65070.492609]  [<ffffffffa04682e6>] i915_pm_suspend+0x46/0xa0 [i915]
[65070.492620]  [<ffffffff81295a30>] pci_pm_suspend+0x70/0x140
[65070.492626]  [<ffffffff814905f5>] ? klist_next+0x85/0x100
[65070.492632]  [<ffffffff812959c0>] ? pci_pm_poweroff+0xe0/0xe0
[65070.492640]  [<ffffffff8134bd38>] dpm_run_callback+0x58/0x90
[65070.492646]  [<ffffffff8134be5b>] __device_suspend+0xeb/0x280
[65070.492653]  [<ffffffff8108d66d>] ? try_to_wake_up+0x1dd/0x2e0
[65070.492660]  [<ffffffff8134c00f>] async_suspend+0x1f/0xa0
[65070.492667]  [<ffffffff8108317a>] async_run_entry_fn+0xaa/0x1c0
[65070.492674]  [<ffffffff81075df2>] process_one_work+0x132/0x4f0
[65070.492678]  [<ffffffff8107520a>] ? manage_workers+0x1ea/0x290
[65070.492684]  [<ffffffff810830d0>] ? async_schedule+0x20/0x20
[65070.492689]  [<ffffffff8107658d>] worker_thread+0x15d/0x400
[65070.492695]  [<ffffffff81076430>] ? rescuer_thread+0x240/0x240
[65070.492701]  [<ffffffff8107b150>] kthread+0xc0/0xd0
[65070.492708]  [<ffffffff81010000>] ? perf_trace_xen_mmu_set_pte_at+0xb0/0x100
[65070.492715]  [<ffffffff8107b090>] ? kthread_freezable_should_stop+0x70/0x70
[65070.492721]  [<ffffffff814c106c>] ret_from_fork+0x7c/0xb0
[65070.492728]  [<ffffffff8107b090>] ? kthread_freezable_should_stop+0x70/0x70
[65070.492731] ---[ end trace fc0a823385ed6934 ]---
[65070.855154] PM: suspend of devices complete after 1556.172 msecs
[65070.855637] PM: late suspend of devices complete after 0.478 msecs
[65070.868788] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[65070.881920] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[65070.908387] PM: noirq suspend of devices complete after 52.827 msecs
[65070.909261] ACPI: Preparing to enter system sleep state S3
[65070.934995] PM: Saving platform NVS memory
[65070.935998] Disabling non-boot CPUs ...
[65071.038036] smpboot: CPU 1 is now offline
[65071.040383] smpboot: CPU 2 is now offline
[65071.144536] smpboot: CPU 3 is now offline
[65071.145130] Extended CMOS year: 2000
[65071.147233] ACPI: Low-level resume complete
[65071.147275] PM: Restoring platform NVS memory
[65071.147589] Extended CMOS year: 2000
[65071.147653] Enabling non-boot CPUs ...
[65071.151096] smpboot: Booting Node 0 Processor 1 APIC 0x2
[65071.165602] CPU1 is up
[65071.168993] smpboot: Booting Node 0 Processor 2 APIC 0x1
[65071.182650] CPU2 is up
[65071.183042] smpboot: Booting Node 0 Processor 3 APIC 0x3
[65071.197290] CPU3 is up
[65071.202206] ACPI: Waking up from system sleep state S3
[65071.742824] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[65071.756247] pcieport 0000:00:1c.1: power state changed by ACPI to D0
[65071.769443] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[65071.796445] PM: noirq resume of devices complete after 93.685 msecs
[65071.796985] PM: early resume of devices complete after 0.436 msecs
[65071.797044] i915 0000:00:02.0: setting latency timer to 64
[65071.797077] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[65071.797120] usb usb3: root hub lost power or was reset
[65071.797158] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[65071.797161] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[65071.797243] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[65071.797297] usb usb4: root hub lost power or was reset
[65071.797308] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[65071.797315] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[65071.797339] ata_piix 0000:00:1f.2: setting latency timer to 64
[65071.798013] mei 0000:00:16.0: wd: failed to find the client
[65071.855883] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake old ack to clear.
[65071.857090] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[65071.945339] Extended CMOS year: 2000
[65072.821181] ata2.00: failed to resume link (SControl 0)
[65073.140685] ata1.01: failed to resume link (SControl 0)
[65073.293876] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[65073.293894] ata1.01: SATA link down (SStatus 0 SControl 0)
[65073.300785] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[65073.307550] ata1.00: configured for UDMA/133
[65073.342097] sd 0:0:0:0: [sda] Starting disk
[65073.842928] ata2.01: failed to resume link (SControl 0)
[65073.854855] ata2.00: SATA link down (SStatus 4 SControl 0)
[65073.854877] ata2.01: SATA link down (SStatus 0 SControl 0)
[65073.871512] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[65073.872507] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[65073.872509] ieee80211 phy0: changing basic rates failed: -22
[65073.872510] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: threshold 0, hys 0  (implement)
[65073.872511] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[65073.872512] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[65073.872751] PM: resume of devices complete after 2078.994 msecs
[65073.907125] PM: Finishing wakeup.
[65073.907126] Restarting tasks ... done.
[65073.915363] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[65073.917152] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[65073.918537] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[65073.929502] cfg80211: Calling CRDA to update world regulatory domain
[65073.942153] video LNXVIDEO:00: Restoring backlight state
[65077.911361] wlan0: authenticate with d4:a0:2a:98:a6:af
[65077.913844] wlan0: direct probe to d4:a0:2a:98:a6:af (try 1/3)
[65078.116206] wlan0: send auth to d4:a0:2a:98:a6:af (try 2/3)
[65078.116857] wlan0: authenticated
[65078.119557] wlan0: associate with d4:a0:2a:98:a6:af (try 1/3)
[65078.121446] wlan0: RX AssocResp from d4:a0:2a:98:a6:af (capab=0x11 status=0 aid=81)
[65078.121958] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[65078.121968] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[65078.121974] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[65078.121992] wlan0: associated
[65083.391844] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[65135.490372] ieee80211 phy0: START: tid 2 is not agg'able
[65723.021485] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[65723.021621] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[65723.023482] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[65723.023601] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[65723.026720] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[65723.026839] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[65723.029793] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[65723.029901] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[65723.031526] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[65723.031636] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[65723.034550] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[65723.034666] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[65723.038303] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[65723.040394] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[65723.040492] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[65723.043146] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[65723.043263] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[65723.045947] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[65723.046081] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[65723.048629] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[65723.048724] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[65723.051660] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[65723.051769] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[65723.054021] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[65723.054174] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[65723.056698] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[65723.056807] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[66706.346756] PM: Syncing filesystems ... done.
[66706.435651] PM: Preparing system for mem sleep
[66706.782860] EXT4-fs (sda4): re-mounted. Opts: commit=600
[66707.534635] Freezing user space processes ... (elapsed 0.02 seconds) done.
[66707.559575] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[66707.572967] PM: Entering mem sleep
[66707.572990] Suspending console(s) (use no_console_suspend to debug)
[66707.622145] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[66707.623480] sd 0:0:0:0: [sda] Stopping disk
[66709.167030] PM: suspend of devices complete after 1556.139 msecs
[66709.167516] PM: late suspend of devices complete after 0.480 msecs
[66709.180717] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[66709.193848] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[66709.220322] PM: noirq suspend of devices complete after 52.881 msecs
[66709.221198] ACPI: Preparing to enter system sleep state S3
[66709.246958] PM: Saving platform NVS memory
[66709.247959] Disabling non-boot CPUs ...
[66709.349965] smpboot: CPU 1 is now offline
[66709.453134] smpboot: CPU 2 is now offline
[66709.556305] smpboot: CPU 3 is now offline
[66709.556928] Extended CMOS year: 2000
[66709.559036] ACPI: Low-level resume complete
[66709.559078] PM: Restoring platform NVS memory
[66709.559386] Extended CMOS year: 2000
[66709.559426] Enabling non-boot CPUs ...
[66709.562896] smpboot: Booting Node 0 Processor 1 APIC 0x2
[66709.577182] CPU1 is up
[66709.580572] smpboot: Booting Node 0 Processor 2 APIC 0x1
[66709.594204] CPU2 is up
[66709.594608] smpboot: Booting Node 0 Processor 3 APIC 0x3
[66709.608917] CPU3 is up
[66709.613847] ACPI: Waking up from system sleep state S3
[66710.154591] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[66710.168017] pcieport 0000:00:1c.1: power state changed by ACPI to D0
[66710.181210] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[66710.208212] PM: noirq resume of devices complete after 93.677 msecs
[66710.208600] PM: early resume of devices complete after 0.345 msecs
[66710.208670] i915 0000:00:02.0: setting latency timer to 64
[66710.208702] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[66710.208715] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[66710.208733] usb usb3: root hub lost power or was reset
[66710.208750] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[66710.208754] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[66710.208768] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[66710.208785] usb usb4: root hub lost power or was reset
[66710.208808] ata_piix 0000:00:1f.2: setting latency timer to 64
[66710.208831] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[66710.209491] mei 0000:00:16.0: wd: failed to find the client
[66710.264322] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake old ack to clear.
[66710.265499] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[66710.281142] bcm5974: bad trackpad package, length: 8
[66710.283119] bcm5974: bad trackpad package, length: 8
[66710.299104] bcm5974: bad trackpad package, length: 8
[66710.300091] bcm5974: bad trackpad package, length: 8
[66710.301128] bcm5974: bad trackpad package, length: 8
[66710.302089] bcm5974: bad trackpad package, length: 8
[66710.304087] bcm5974: bad trackpad package, length: 8
[66710.305088] bcm5974: bad trackpad package, length: 8
[66710.307081] bcm5974: bad trackpad package, length: 8
[66710.342084] Extended CMOS year: 2000
[66711.232957] ata2.00: failed to resume link (SControl 0)
[66711.552462] ata1.01: failed to resume link (SControl 0)
[66711.705642] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[66711.705660] ata1.01: SATA link down (SStatus 0 SControl 0)
[66711.712560] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[66711.719306] ata1.00: configured for UDMA/133
[66711.753698] sd 0:0:0:0: [sda] Starting disk
[66712.254702] ata2.01: failed to resume link (SControl 0)
[66712.266586] ata2.00: SATA link down (SStatus 4 SControl 0)
[66712.266609] ata2.01: SATA link down (SStatus 0 SControl 0)
[66712.283730] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[66712.284747] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[66712.284749] ieee80211 phy0: changing basic rates failed: -22
[66712.284750] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: threshold 0, hys 0  (implement)
[66712.284751] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[66712.284752] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[66712.284992] PM: resume of devices complete after 2079.617 msecs
[66712.318938] PM: Finishing wakeup.
[66712.318940] Restarting tasks ... done.
[66712.323405] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[66712.324762] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[66712.326098] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[66712.328026] cfg80211: Calling CRDA to update world regulatory domain
[66712.373322] video LNXVIDEO:00: Restoring backlight state
[66713.532757] X: page allocation failure: order:4, mode:0xc0d0
[66713.532765] Pid: 732, comm: X Tainted: G        W    3.7.5-1-ARCH #1
[66713.532767] Call Trace:
[66713.532778]  [<ffffffff81126679>] warn_alloc_failed+0xe9/0x140
[66713.532784]  [<ffffffff814b1809>] ? __alloc_pages_direct_compact+0x1b8/0x1ca
[66713.532789]  [<ffffffff8112a11f>] __alloc_pages_nodemask+0x6ef/0x960
[66713.532796]  [<ffffffff81165f60>] alloc_pages_current+0xb0/0x120
[66713.532801]  [<ffffffff8112592e>] __get_free_pages+0xe/0x50
[66713.532806]  [<ffffffff8116ced9>] kmalloc_order_trace+0x39/0xf0
[66713.532811]  [<ffffffff8116fd1a>] __kmalloc+0x17a/0x190
[66713.532828]  [<ffffffffa044c0d5>] evdev_open+0x85/0x1e0 [evdev]
[66713.532833]  [<ffffffff81188cbb>] chrdev_open+0x9b/0x1c0
[66713.532839]  [<ffffffff81182ad3>] do_dentry_open+0x203/0x290
[66713.532843]  [<ffffffff81188c20>] ? cdev_put+0x30/0x30
[66713.532848]  [<ffffffff81182e15>] finish_open+0x35/0x50
[66713.532852]  [<ffffffff81192bae>] do_last+0x31e/0xeb0
[66713.532857]  [<ffffffff8118fb38>] ? link_path_walk+0x78/0x950
[66713.532864]  [<ffffffff8114a105>] ? handle_pte_fault+0x95/0xaa0
[66713.532868]  [<ffffffff811937fc>] path_openat+0xbc/0x530
[66713.532872]  [<ffffffff8114c181>] ? handle_mm_fault+0x261/0x330
[66713.532876]  [<ffffffff81193fe1>] do_filp_open+0x41/0xa0
[66713.532881]  [<ffffffff811a0ee9>] ? __alloc_fd+0xe9/0x140
[66713.532886]  [<ffffffff81183d24>] do_sys_open+0xf4/0x1e0
[66713.532891]  [<ffffffff81183e31>] sys_open+0x21/0x30
[66713.532897]  [<ffffffff814c111d>] system_call_fastpath+0x1a/0x1f
[66713.532900] Mem-Info:
[66713.532902] Node 0 DMA per-cpu:
[66713.532906] CPU    0: hi:    0, btch:   1 usd:   0
[66713.532909] CPU    1: hi:    0, btch:   1 usd:   0
[66713.532911] CPU    2: hi:    0, btch:   1 usd:   0
[66713.532913] CPU    3: hi:    0, btch:   1 usd:   0
[66713.532915] Node 0 DMA32 per-cpu:
[66713.532919] CPU    0: hi:  186, btch:  31 usd:   0
[66713.532921] CPU    1: hi:  186, btch:  31 usd:   0
[66713.532924] CPU    2: hi:  186, btch:  31 usd:   0
[66713.532926] CPU    3: hi:  186, btch:  31 usd:   0
[66713.532928] Node 0 Normal per-cpu:
[66713.532931] CPU    0: hi:  186, btch:  31 usd:   0
[66713.532933] CPU    1: hi:  186, btch:  31 usd:   0
[66713.532935] CPU    2: hi:  186, btch:  31 usd:   0
[66713.532938] CPU    3: hi:  186, btch:  31 usd:   0
[66713.532944] active_anon:314627 inactive_anon:165244 isolated_anon:0
 active_file:21462 inactive_file:23674 isolated_file:0
 unevictable:2206 dirty:39 writeback:0 unstable:0
 free:228221 slab_reclaimable:193804 slab_unreclaimable:8245
 mapped:22989 shmem:72868 pagetables:10444 bounce:0
 free_cma:0
[66713.532950] Node 0 DMA free:15360kB min:252kB low:312kB high:376kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15104kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[66713.532958] lowmem_reserve[]: 0 2137 3899 3899
[66713.532963] Node 0 DMA32 free:815828kB min:36904kB low:46128kB high:55356kB active_anon:341512kB inactive_anon:343484kB active_file:10428kB inactive_file:9328kB unevictable:648kB isolated(anon):0kB isolated(file):0kB present:2188688kB mlocked:648kB dirty:4kB writeback:0kB mapped:26036kB shmem:76612kB slab_reclaimable:635448kB slab_unreclaimable:8256kB kernel_stack:784kB pagetables:10480kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[66713.532972] lowmem_reserve[]: 0 0 1762 1762
[66713.532976] Node 0 Normal free:81696kB min:30424kB low:38028kB high:45636kB active_anon:916996kB inactive_anon:317492kB active_file:75420kB inactive_file:85368kB unevictable:8176kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:8176kB dirty:152kB writeback:0kB mapped:65920kB shmem:214860kB slab_reclaimable:139768kB slab_unreclaimable:24724kB kernel_stack:3112kB pagetables:31296kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[66713.532983] lowmem_reserve[]: 0 0 0 0
[66713.532988] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15360kB
[66713.533000] Node 0 DMA32: 51263*4kB 36927*8kB 19329*16kB 123*32kB 16*64kB 7*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 815844kB
[66713.533012] Node 0 Normal: 7662*4kB 5863*8kB 133*16kB 1*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 81696kB
[66713.533023] 138946 total pagecache pages
[66713.533025] 20024 pages in swap cache
[66713.533027] Swap cache stats: add 749071, delete 729047, find 291669/342319
[66713.533029] Free swap  = 7880500kB
[66713.533031] Total swap = 8386556kB
[66713.546160] 1048048 pages RAM
[66713.546164] 57821 pages reserved
[66713.546165] 1260728 pages shared
[66713.546166] 671948 pages non-shared
[66717.562741] wlan0: authenticate with 5c:ff:35:75:05:89
[66717.574346] wlan0: send auth to 5c:ff:35:75:05:89 (try 1/3)
[66717.578026] wlan0: authenticated
[66717.579704] wlan0: associate with 5c:ff:35:75:05:89 (try 1/3)
[66717.591940] wlan0: RX AssocResp from 5c:ff:35:75:05:89 (capab=0x431 status=0 aid=1)
[66717.592481] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[66717.592490] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[66717.592496] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[66717.592513] wlan0: associated
[66725.396227] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)

--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.mouse-does-not-work-3.7.9-1-ARCH"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.7.9-1-ARCH (nobody@foutrelis) (gcc version 4.7.2 (GCC) ) #1 SMP PREEMPT Mon Feb 18 02:13:30 EET 2013
[    0.000000] Command line: root=/dev/mapper/root cryptdevice=/dev/sda5:root ro i915.i915_enable_rc6=1 initrd=../initramfs-linux.img BOOT_IMAGE=../vmlinuz-linux 
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000008dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000008e000-0x000000000008ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000090000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x000000003fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040000000-0x00000000401fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040200000-0x000000008ad33fff] usable
[    0.000000] BIOS-e820: [mem 0x000000008ad34000-0x000000008ad5efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000008ad5f000-0x000000008afa1fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000008afa2000-0x000000008affefff] reserved
[    0.000000] BIOS-e820: [mem 0x000000008afff000-0x000000008affffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000008b000000-0x000000008f9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed18000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000016fdfffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Apple Inc. MacBookAir4,2/Mac-742912EFDBEE19B3, BIOS MBA41.88Z.0077.B0E.1110141154 10/14/2011
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x16fe00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   1 base 0A0000000 mask FE0000000 uncachable
[    0.000000]   2 base 090000000 mask FF0000000 uncachable
[    0.000000]   3 base 08C000000 mask FFC000000 uncachable
[    0.000000]   4 base 08B800000 mask FFF800000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0x8ad34 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] reserving inaccessible SNB gfx pages
[    0.000000] init_memory_mapping: [mem 0x00000000-0x8ad33fff]
[    0.000000]  [mem 0x00000000-0x8abfffff] page 2M
[    0.000000]  [mem 0x8ac00000-0x8ad33fff] page 4k
[    0.000000] kernel direct mapping tables up to 0x8ad33fff @ [mem 0x1fc8c000-0x1fc90fff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x16fdfffff]
[    0.000000]  [mem 0x100000000-0x16fdfffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x16fdfffff @ [mem 0x8ad31000-0x8ad33fff]
[    0.000000] RAMDISK: [mem 0x1fc91000-0x1fffefff]
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 APPLE )
[    0.000000] ACPI: XSDT 000000008ad8e1c0 000AC (v01 APPLE   Apple00 00000060      01000013)
[    0.000000] ACPI: FACP 000000008ad8c000 000F4 (v04 APPLE   Apple00 00000060 Loki 0000005F)
[    0.000000] ACPI: DSDT 000000008ad81000 05050 (v01 APPLE  MacBookA 00040001 INTL 20100915)
[    0.000000] ACPI: FACS 000000008ad3e000 00040
[    0.000000] ACPI: HPET 000000008ad8b000 00038 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: APIC 000000008ad8a000 000BC (v02 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SBST 000000008ad88000 00030 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: ECDT 000000008ad87000 00053 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SSDT 000000008ad7d000 00024 (v01 APPLE   SmcDppt 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad7b000 006CA (v01 APPLE     UsbSD 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad77000 00159 (v02 APPLE     IGHda 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad73000 015EB (v02 APPLE  SsdtIGPU 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad72000 00569 (v01  PmRef  Cpu0Ist 00003000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad71000 009B1 (v01  PmRef    CpuPm 00003000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad70000 00315 (v01  PmRef  Cpu0Tst 00003000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad6f000 0037A (v01  PmRef    ApTst 00003000 INTL 20100915)
[    0.000000] ACPI: MCFG 000000008ad89000 0003C (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SSDT 000000008ad80000 000FA (v01 SataRe  SataPri 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad7f000 000D0 (v01 SataRe  SataSec 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad7e000 00032 (v01  Apple   SsdtS3 00001000 INTL 20100915)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000016fdfffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x16fdfffff]
[    0.000000]   NODE_DATA [mem 0x16fdfc000-0x16fdfffff]
[    0.000000]  [ffffea0000000000-ffffea0005bfffff] PMD -> [ffff88016b400000-ffff88016f3fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x16fdfffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0008dfff]
[    0.000000]   node   0: [mem 0x00090000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x3fffffff]
[    0.000000]   node   0: [mem 0x40200000-0x8ad33fff]
[    0.000000]   node   0: [mem 0x100000000-0x16fdfffff]
[    0.000000] On node 0 totalpages: 1025729
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 141 pages reserved
[    0.000000]   DMA zone: 3776 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 547188 pages, LIFO batch:31
[    0.000000]   Normal zone: 7160 pages used for memmap
[    0.000000]   Normal zone: 451080 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000008e000 - 0000000000090000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] PM: Registered nosave memory: 0000000040000000 - 0000000040200000
[    0.000000] PM: Registered nosave memory: 000000008ad34000 - 000000008ad5f000
[    0.000000] PM: Registered nosave memory: 000000008ad5f000 - 000000008afa2000
[    0.000000] PM: Registered nosave memory: 000000008afa2000 - 000000008afff000
[    0.000000] PM: Registered nosave memory: 000000008afff000 - 000000008b000000
[    0.000000] PM: Registered nosave memory: 000000008b000000 - 000000008fa00000
[    0.000000] PM: Registered nosave memory: 000000008fa00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed04000
[    0.000000] PM: Registered nosave memory: 00000000fed04000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff800000
[    0.000000] PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
[    0.000000] e820: [mem 0x8fa00000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88016fa00000 s84608 r8192 d21888 u262144
[    0.000000] pcpu-alloc: s84608 r8192 d21888 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1002044
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/mapper/root cryptdevice=/dev/sda5:root ro i915.i915_enable_rc6=1 initrd=../initramfs-linux.img BOOT_IMAGE=../vmlinuz-linux 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 3954908k/6027264k available (4893k kernel code, 1924348k absent, 148008k reserved, 4021k data, 812k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=8.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 16777216 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.003333] tsc: Detected 1799.962 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 3601.92 BogoMIPS (lpj=5999873)
[    0.000005] pid_max: default: 32768 minimum: 301
[    0.000043] Security Framework initialized
[    0.000051] AppArmor: AppArmor disabled by boot time parameter
[    0.000376] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.001461] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.001914] Mount-cache hash table entries: 256
[    0.002130] Initializing cgroup subsys cpuacct
[    0.002133] Initializing cgroup subsys memory
[    0.002141] Initializing cgroup subsys devices
[    0.002143] Initializing cgroup subsys freezer
[    0.002144] Initializing cgroup subsys net_cls
[    0.002146] Initializing cgroup subsys blkio
[    0.002175] CPU: Physical Processor ID: 0
[    0.002176] CPU: Processor Core ID: 0
[    0.002181] mce: CPU supports 7 MCE banks
[    0.002195] CPU0: Thermal monitoring enabled (TM1)
[    0.002204] process: using mwait in idle threads
[    0.002208] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
tlb_flushall_shift: 5
[    0.002385] Freeing SMP alternatives: 16k freed
[    0.003914] ACPI: Core revision 20120913
[    0.011914] ftrace: allocating 18828 entries in 74 pages
[    0.024318] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.057272] smpboot: CPU0: Intel(R) Core(TM) i7-2677M CPU @ 1.80GHz (fam: 06, model: 2a, stepping: 07)
[    0.162564] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
[    0.162571] perf_event_intel: PEBS disabled due to CPU errata, please upgrade microcode
[    0.162574] ... version:                3
[    0.162575] ... bit width:              48
[    0.162576] ... generic registers:      4
[    0.162578] ... value mask:             0000ffffffffffff
[    0.162579] ... max period:             000000007fffffff
[    0.162580] ... fixed-purpose events:   3
[    0.162582] ... event mask:             000000070000000f
[    0.202573] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.189269] smpboot: Booting Node   0, Processors  #1 #2 #3
[    0.242427] Brought up 4 CPUs
[    0.242431] smpboot: Total of 4 processors activated (14405.68 BogoMIPS)
[    0.247336] devtmpfs: initialized
[    0.248501] PM: Registering ACPI NVS region [mem 0x8ad34000-0x8ad5efff] (176128 bytes)
[    0.249378] RTC time: 21:34:43, date: 02/26/13
[    0.249427] NET: Registered protocol family 16
[    0.249580] ACPI: bus type pci registered
[    0.249660] PCI: MMCONFIG for domain 0000 [bus 00-97] at [mem 0xe0000000-0xe97fffff] (base 0xe0000000)
[    0.249664] PCI: MMCONFIG at [mem 0xe0000000-0xe97fffff] reserved in E820
[    0.270510] PCI: Using configuration type 1 for base access
[    0.271160] bio: create slab <bio-0> at 0
[    0.271221] ACPI: Added _OSI(Module Device)
[    0.271223] ACPI: Added _OSI(Processor Device)
[    0.271225] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.271226] ACPI: Added _OSI(Processor Aggregator Device)
[    0.272733] ACPI: EC: EC description table is found, configuring boot EC
[    0.279433] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.279960] ACPI: SSDT 000000008ad39190 00781 (v01  PmRef  Cpu0Cst 00003001 INTL 20100915)
[    0.280357] ACPI: Dynamic OEM Table Load:
[    0.280360] ACPI: SSDT           (null) 00781 (v01  PmRef  Cpu0Cst 00003001 INTL 20100915)
[    0.280712] ACPI: SSDT 000000008ad3a710 003A4 (v01  PmRef    ApIst 00003000 INTL 20100915)
[    0.281153] ACPI: Dynamic OEM Table Load:
[    0.281156] ACPI: SSDT           (null) 003A4 (v01  PmRef    ApIst 00003000 INTL 20100915)
[    0.289147] ACPI: SSDT 000000008ad38d90 00119 (v01  PmRef    ApCst 00003000 INTL 20100915)
[    0.289537] ACPI: Dynamic OEM Table Load:
[    0.289539] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20100915)
[    0.309549] ACPI: Interpreter enabled
[    0.309554] ACPI: (supports S0 S3 S4 S5)
[    0.309575] ACPI: Using IOAPIC for interrupt routing
[    0.342937] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.343116] ACPI: No dock devices found.
[    0.343120] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.343474] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.343997] pci_root PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-97] only partially covers this bridge
[    0.344031] PCI host bridge to bus 0000:00
[    0.344034] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.344036] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.344039] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.344041] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.344044] pci_bus 0000:00: root bus resource [mem 0x8fa00000-0xfeafffff]
[    0.344046] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    0.344056] pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
[    0.344101] pci 0000:00:01.0: [8086:0101] type 01 class 0x060400
[    0.344140] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.344169] pci 0000:00:02.0: [8086:0116] type 00 class 0x030000
[    0.344182] pci 0000:00:02.0: reg 10: [mem 0xa0000000-0xa03fffff 64bit]
[    0.344190] pci 0000:00:02.0: reg 18: [mem 0x90000000-0x9fffffff 64bit pref]
[    0.344196] pci 0000:00:02.0: reg 20: [io  0x2000-0x203f]
[    0.344275] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.344301] pci 0000:00:16.0: reg 10: [mem 0xa0607100-0xa060710f 64bit]
[    0.344385] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.344426] pci 0000:00:1a.0: [8086:1c2c] type 00 class 0x0c0300
[    0.344475] pci 0000:00:1a.0: reg 20: [io  0x2140-0x215f]
[    0.344551] pci 0000:00:1a.7: [8086:1c2d] type 00 class 0x0c0320
[    0.344576] pci 0000:00:1a.7: reg 10: [mem 0xa0606c00-0xa0606fff]
[    0.344676] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.344706] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.344726] pci 0000:00:1b.0: reg 10: [mem 0xa0600000-0xa0603fff 64bit]
[    0.344804] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.344835] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.344966] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.345008] pci 0000:00:1c.1: [8086:1c12] type 01 class 0x060400
[    0.345138] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.345185] pci 0000:00:1d.0: [8086:1c27] type 00 class 0x0c0300
[    0.345234] pci 0000:00:1d.0: reg 20: [io  0x20e0-0x20ff]
[    0.345311] pci 0000:00:1d.7: [8086:1c26] type 00 class 0x0c0320
[    0.345334] pci 0000:00:1d.7: reg 10: [mem 0xa0606800-0xa0606bff]
[    0.345435] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.345464] pci 0000:00:1f.0: [8086:1c4d] type 00 class 0x060100
[    0.345598] pci 0000:00:1f.2: [8086:1c01] type 00 class 0x01018f
[    0.345622] pci 0000:00:1f.2: reg 10: [io  0x2168-0x216f]
[    0.345633] pci 0000:00:1f.2: reg 14: [io  0x217c-0x217f]
[    0.345643] pci 0000:00:1f.2: reg 18: [io  0x2160-0x2167]
[    0.345653] pci 0000:00:1f.2: reg 1c: [io  0x2178-0x217b]
[    0.345663] pci 0000:00:1f.2: reg 20: [io  0x2060-0x206f]
[    0.345673] pci 0000:00:1f.2: reg 24: [io  0xffe0-0xffef]
[    0.345733] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.345752] pci 0000:00:1f.3: reg 10: [mem 0xa0607000-0xa06070ff 64bit]
[    0.345776] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    0.345848] pci 0000:03:00.0: [8086:151a] type 01 class 0x060400
[    0.345913] pci 0000:03:00.0: supports D1 D2
[    0.345915] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.352289] pci 0000:00:01.0: PCI bridge to [bus 03-97]
[    0.352304] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    0.352307] pci 0000:00:01.0:   bridge window [mem 0xa0700000-0xa49fffff]
[    0.352311] pci 0000:00:01.0:   bridge window [mem 0xa4a00000-0xa89fffff 64bit pref]
[    0.352362] pci 0000:04:00.0: [8086:151a] type 01 class 0x060400
[    0.352430] pci 0000:04:00.0: supports D1 D2
[    0.352432] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.352468] pci 0000:04:03.0: [8086:151a] type 01 class 0x060400
[    0.352536] pci 0000:04:03.0: supports D1 D2
[    0.352538] pci 0000:04:03.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.352568] pci 0000:04:04.0: [8086:151a] type 01 class 0x060400
[    0.352635] pci 0000:04:04.0: supports D1 D2
[    0.352637] pci 0000:04:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.352683] pci 0000:03:00.0: PCI bridge to [bus 04-67]
[    0.352690] pci 0000:03:00.0:   bridge window [mem 0xa0700000-0xa09fffff]
[    0.352751] pci 0000:05:00.0: [8086:151a] type 00 class 0x088000
[    0.352766] pci 0000:05:00.0: reg 10: [mem 0xa0700000-0xa073ffff]
[    0.352778] pci 0000:05:00.0: reg 14: [mem 0xa0740000-0xa0740fff]
[    0.352881] pci 0000:05:00.0: supports D1 D2
[    0.352883] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.358946] pci 0000:04:00.0: PCI bridge to [bus 05]
[    0.358960] pci 0000:04:00.0:   bridge window [mem 0xa0700000-0xa07fffff]
[    0.359020] pci 0000:04:03.0: PCI bridge to [bus 06-36]
[    0.359028] pci 0000:04:03.0:   bridge window [mem 0xa0800000-0xa08fffff]
[    0.359072] pci 0000:04:04.0: PCI bridge to [bus 37-67]
[    0.359080] pci 0000:04:04.0:   bridge window [mem 0xa0900000-0xa09fffff]
[    0.359173] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.359183] pci 0000:00:1c.0:   bridge window [mem 0xa0500000-0xa05fffff]
[    0.359341] pci 0000:02:00.0: [14e4:4353] type 00 class 0x028000
[    0.359391] pci 0000:02:00.0: reg 10: [mem 0xa0400000-0xa0403fff 64bit]
[    0.359656] pci 0000:02:00.0: supports D1 D2
[    0.359658] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.365652] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.365660] pci 0000:00:1c.1:   bridge window [mem 0xa0400000-0xa04fffff]
[    0.365685] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.365789] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    0.365883] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.365991]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.366126]  pci0000:00: ACPI _OSC control (0x19) granted
[    0.369331] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.369381] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.369427] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.369473] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.369518] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.369564] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.369609] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.369654] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.369750] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.369755] vgaarb: loaded
[    0.369756] vgaarb: bridge control possible 0000:00:02.0
[    0.369798] PCI: Using ACPI for IRQ routing
[    0.373876] PCI: pci_cache_line_size set to 64 bytes
[    0.374015] e820: reserve RAM buffer [mem 0x0008e000-0x0008ffff]
[    0.374017] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.374019] e820: reserve RAM buffer [mem 0x8ad34000-0x8bffffff]
[    0.374021] e820: reserve RAM buffer [mem 0x16fe00000-0x16fffffff]
[    0.374118] NetLabel: Initializing
[    0.374120] NetLabel:  domain hash size = 128
[    0.374121] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.374134] NetLabel:  unlabeled traffic allowed by default
[    0.374156] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.374162] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.376175] Switching to clocksource hpet
[    0.381313] pnp: PnP ACPI init
[    0.381330] ACPI: bus type pnp registered
[    0.381636] pnp 00:00: [bus 00-ff]
[    0.381639] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.381642] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.381644] pnp 00:00: [io  0x0d00-0xffff window]
[    0.381647] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.381649] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.381651] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.381653] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.381656] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.381658] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.381660] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.381662] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.381665] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.381667] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.381669] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.381671] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.381674] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.381676] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.381678] pnp 00:00: [mem 0x8fa00000-0xfeafffff window]
[    0.381680] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.381719] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.381806] pnp 00:01: [io  0x0000-0x001f]
[    0.381808] pnp 00:01: [io  0x0081-0x0091]
[    0.381810] pnp 00:01: [io  0x0093-0x009f]
[    0.381812] pnp 00:01: [io  0x00c0-0x00df]
[    0.381815] pnp 00:01: [dma 4]
[    0.381837] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.381845] pnp 00:02: [mem 0xff000000-0xffffffff]
[    0.381867] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.381945] pnp 00:03: [irq 0 disabled]
[    0.381954] pnp 00:03: [irq 8]
[    0.381957] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.381994] system 00:03: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.381998] system 00:03: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    0.382009] pnp 00:04: [io  0x00f0]
[    0.382015] pnp 00:04: [irq 13]
[    0.382037] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.382047] pnp 00:05: [io  0x002e-0x002f]
[    0.382050] pnp 00:05: [io  0x004e-0x004f]
[    0.382052] pnp 00:05: [io  0x0061]
[    0.382054] pnp 00:05: [io  0x0063]
[    0.382055] pnp 00:05: [io  0x0065]
[    0.382058] pnp 00:05: [io  0x0067]
[    0.382059] pnp 00:05: [io  0x0080]
[    0.382061] pnp 00:05: [io  0x0092]
[    0.382063] pnp 00:05: [io  0x00b2-0x00b3]
[    0.382067] pnp 00:05: [io  0x1000-0x100f]
[    0.382069] pnp 00:05: [io  0x0400-0x047f]
[    0.382071] pnp 00:05: [io  0x0500-0x057f]
[    0.382103] system 00:05: [io  0x1000-0x100f] has been reserved
[    0.382106] system 00:05: [io  0x0400-0x047f] has been reserved
[    0.382109] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.382112] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.382120] pnp 00:06: [io  0x0070-0x0077]
[    0.382142] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.382154] pnp 00:07: [io  0x0300-0x031f]
[    0.382160] pnp 00:07: [irq 6]
[    0.382180] pnp 00:07: Plug and Play ACPI device, IDs APP0001 (active)
[    0.382339] pnp 00:08: [mem 0xfed1c000-0xfed1ffff]
[    0.382341] pnp 00:08: [mem 0xfed10000-0xfed17fff]
[    0.382343] pnp 00:08: [mem 0xfed18000-0xfed18fff]
[    0.382346] pnp 00:08: [mem 0xfed19000-0xfed19fff]
[    0.382348] pnp 00:08: [mem 0xe0000000-0xefffffff]
[    0.382350] pnp 00:08: [mem 0xfed20000-0xfed3ffff]
[    0.382352] pnp 00:08: [mem 0xfed90000-0xfed93fff]
[    0.382354] pnp 00:08: [mem 0xfed45000-0xfed8ffff]
[    0.382356] pnp 00:08: [mem 0xff000000-0xffffffff]
[    0.382358] pnp 00:08: [mem 0xfee00000-0xfeefffff]
[    0.382361] pnp 00:08: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.382400] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.382403] system 00:08: [mem 0xfed10000-0xfed17fff] could not be reserved
[    0.382406] system 00:08: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.382408] system 00:08: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.382411] system 00:08: [mem 0xe0000000-0xefffffff] has been reserved
[    0.382413] system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.382416] system 00:08: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.382418] system 00:08: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.382421] system 00:08: [mem 0xff000000-0xffffffff] could not be reserved
[    0.382424] system 00:08: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.382427] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.388673] pnp 00:09: [mem 0x20000000-0x201fffff]
[    0.388676] pnp 00:09: [mem 0x40000000-0x401fffff]
[    0.388716] system 00:09: [mem 0x20000000-0x201fffff] has been reserved
[    0.388718] system 00:09: [mem 0x40000000-0x401fffff] has been reserved
[    0.388722] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.388732] pnp: PnP ACPI: found 10 devices
[    0.388733] ACPI: ACPI bus type pnp unregistered
[    0.395696] pci 0000:04:03.0: bridge window [io  0x1000-0x0fff] to [bus 06-36] add_size 1000
[    0.395701] pci 0000:04:03.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 06-36] add_size 200000
[    0.395710] pci 0000:04:04.0: bridge window [io  0x1000-0x0fff] to [bus 37-67] add_size 1000
[    0.395713] pci 0000:04:04.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 37-67] add_size 200000
[    0.395722] pci 0000:04:03.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.395725] pci 0000:04:04.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.395727] pci 0000:03:00.0: bridge window [io  0x1000-0x0fff] to [bus 04-67] add_size 2000
[    0.395730] pci 0000:04:03.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.395733] pci 0000:04:04.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.395736] pci 0000:03:00.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 04-67] add_size 400000
[    0.395768] pci 0000:03:00.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 400000
[    0.395770] pci 0000:03:00.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 2000
[    0.395775] pci 0000:03:00.0: BAR 15: assigned [mem 0xa4a00000-0xa4dfffff 64bit pref]
[    0.395778] pci 0000:03:00.0: BAR 13: can't assign io (size 0x2000)
[    0.395782] pci 0000:03:00.0: BAR 15: assigned [mem 0xa4a00000-0xa4dfffff 64bit pref]
[    0.395785] pci 0000:03:00.0: BAR 13: can't assign io (size 0x2000)
[    0.395789] pci 0000:04:03.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.395792] pci 0000:04:04.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.395794] pci 0000:04:03.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.395797] pci 0000:04:04.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.395799] pci 0000:04:03.0: BAR 15: assigned [mem 0xa4a00000-0xa4bfffff 64bit pref]
[    0.395802] pci 0000:04:04.0: BAR 15: assigned [mem 0xa4c00000-0xa4dfffff 64bit pref]
[    0.395805] pci 0000:04:03.0: BAR 13: can't assign io (size 0x1000)
[    0.395807] pci 0000:04:04.0: BAR 13: can't assign io (size 0x1000)
[    0.395811] pci 0000:04:04.0: BAR 15: assigned [mem 0xa4a00000-0xa4bfffff 64bit pref]
[    0.395813] pci 0000:04:04.0: BAR 13: can't assign io (size 0x1000)
[    0.395816] pci 0000:04:03.0: BAR 15: assigned [mem 0xa4c00000-0xa4dfffff 64bit pref]
[    0.395819] pci 0000:04:03.0: BAR 13: can't assign io (size 0x1000)
[    0.395822] pci 0000:04:00.0: PCI bridge to [bus 05]
[    0.395827] pci 0000:04:00.0:   bridge window [mem 0xa0700000-0xa07fffff]
[    0.395835] pci 0000:04:03.0: PCI bridge to [bus 06-36]
[    0.395841] pci 0000:04:03.0:   bridge window [mem 0xa0800000-0xa08fffff]
[    0.395845] pci 0000:04:03.0:   bridge window [mem 0xa4c00000-0xa4dfffff 64bit pref]
[    0.395851] pci 0000:04:04.0: PCI bridge to [bus 37-67]
[    0.395856] pci 0000:04:04.0:   bridge window [mem 0xa0900000-0xa09fffff]
[    0.395860] pci 0000:04:04.0:   bridge window [mem 0xa4a00000-0xa4bfffff 64bit pref]
[    0.395866] pci 0000:03:00.0: PCI bridge to [bus 04-67]
[    0.395871] pci 0000:03:00.0:   bridge window [mem 0xa0700000-0xa09fffff]
[    0.395875] pci 0000:03:00.0:   bridge window [mem 0xa4a00000-0xa4dfffff 64bit pref]
[    0.395881] pci 0000:00:01.0: PCI bridge to [bus 03-97]
[    0.395884] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    0.395888] pci 0000:00:01.0:   bridge window [mem 0xa0700000-0xa49fffff]
[    0.395891] pci 0000:00:01.0:   bridge window [mem 0xa4a00000-0xa89fffff 64bit pref]
[    0.395895] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.395903] pci 0000:00:1c.0:   bridge window [mem 0xa0500000-0xa05fffff]
[    0.395916] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.395924] pci 0000:00:1c.1:   bridge window [mem 0xa0400000-0xa04fffff]
[    0.395964] pci 0000:04:03.0: enabling device (0000 -> 0002)
[    0.395976] pci 0000:04:04.0: enabling device (0000 -> 0002)
[    0.395986] pci 0000:00:1c.0: enabling device (0000 -> 0002)
[    0.396004] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.396006] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.396009] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.396011] pci_bus 0000:00: resource 7 [mem 0x8fa00000-0xfeafffff]
[    0.396013] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
[    0.396016] pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
[    0.396018] pci_bus 0000:03: resource 1 [mem 0xa0700000-0xa49fffff]
[    0.396020] pci_bus 0000:03: resource 2 [mem 0xa4a00000-0xa89fffff 64bit pref]
[    0.396023] pci_bus 0000:04: resource 1 [mem 0xa0700000-0xa09fffff]
[    0.396025] pci_bus 0000:04: resource 2 [mem 0xa4a00000-0xa4dfffff 64bit pref]
[    0.396028] pci_bus 0000:05: resource 1 [mem 0xa0700000-0xa07fffff]
[    0.396030] pci_bus 0000:06: resource 1 [mem 0xa0800000-0xa08fffff]
[    0.396033] pci_bus 0000:06: resource 2 [mem 0xa4c00000-0xa4dfffff 64bit pref]
[    0.396035] pci_bus 0000:37: resource 1 [mem 0xa0900000-0xa09fffff]
[    0.396038] pci_bus 0000:37: resource 2 [mem 0xa4a00000-0xa4bfffff 64bit pref]
[    0.396040] pci_bus 0000:01: resource 1 [mem 0xa0500000-0xa05fffff]
[    0.396043] pci_bus 0000:02: resource 1 [mem 0xa0400000-0xa04fffff]
[    0.396077] NET: Registered protocol family 2
[    0.396787] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.398280] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.398438] TCP: Hash tables configured (established 524288 bind 65536)
[    0.398464] TCP: reno registered
[    0.398475] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.398495] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.398585] NET: Registered protocol family 1
[    0.398601] pci 0000:00:02.0: Boot video device
[    0.399011] PCI: CLS 256 bytes, default 64
[    0.399059] Unpacking initramfs...
[    0.476176] Freeing initrd memory: 3512k freed
[    0.476682] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.476688] software IO TLB [mem 0x86d31000-0x8ad30fff] (64MB) mapped at [ffff880086d31000-ffff88008ad30fff]
[    0.477134] audit: initializing netlink socket (disabled)
[    0.477151] type=2000 audit(1361914483.369:1): initialized
[    0.492602] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.494293] VFS: Disk quotas dquot_6.5.2
[    0.494344] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.494525] msgmni has been set to 7731
[    0.494786] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.494816] io scheduler noop registered
[    0.494818] io scheduler deadline registered
[    0.494855] io scheduler cfq registered (default)
[    0.494968] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.495188] pcieport 0000:03:00.0: irq 41 for MSI/MSI-X
[    0.495296] pcieport 0000:04:00.0: irq 42 for MSI/MSI-X
[    0.495404] pcieport 0000:04:03.0: irq 43 for MSI/MSI-X
[    0.495512] pcieport 0000:04:04.0: irq 44 for MSI/MSI-X
[    0.495674] intel_idle: MWAIT substates: 0x21120
[    0.495676] intel_idle: v0.4 model 0x2A
[    0.495678] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.495714] GHES: HEST is not enabled!
[    0.495777] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.496273] Linux agpgart interface v0.103
[    0.496349] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.477818] tsc: Refined TSC clocksource calibration: 1800.013 MHz
[    1.477822] Switching to clocksource tsc
[    1.543289] i8042: No controller found
[    1.543468] mousedev: PS/2 mouse device common for all mice
[    1.543514] rtc_cmos 00:06: RTC can wake from S4
[    1.543649] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    1.543681] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    1.543775] cpuidle: using governor ladder
[    1.543894] cpuidle: using governor menu
[    1.543896] EFI Variables Facility v0.08 2004-May-17
[    1.543951] drop_monitor: Initializing network drop monitor service
[    1.544029] TCP: cubic registered
[    1.544140] NET: Registered protocol family 10
[    1.544294] NET: Registered protocol family 17
[    1.544307] Key type dns_resolver registered
[    1.544813] PM: Hibernation image not present or could not be loaded.
[    1.544826] registered taskstats version 1
[    1.545583]   Magic number: 1:188:602
[    1.545651] rtc_cmos 00:06: setting system clock to 2013-02-26 21:34:44 UTC (1361914484)
[    1.547366] Freeing unused kernel memory: 812k freed
[    1.547481] Write protecting the kernel read-only data: 8192k
[    1.551378] Freeing unused kernel memory: 1240k freed
[    1.553049] Freeing unused kernel memory: 472k freed
[    1.561304] systemd-udevd[57]: starting version 197
[    1.586854] ACPI: bus type usb registered
[    1.586903] usbcore: registered new interface driver usbfs
[    1.586930] usbcore: registered new interface driver hub
[    1.586996] usbcore: registered new device driver usb
[    1.588093] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.588156] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.588163] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.588173] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.588194] ehci_hcd 0000:00:1a.7: debug port 2
[    1.588869] SCSI subsystem initialized
[    1.590281] ACPI: bus type scsi registered
[    1.590603] libata version 3.00 loaded.
[    1.592111] ehci_hcd 0000:00:1a.7: cache line size of 256 is not supported
[    1.592139] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xa0606c00
[    1.600993] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.601452] hub 1-0:1.0: USB hub found
[    1.601460] hub 1-0:1.0: 6 ports detected
[    1.602046] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.602051] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.602058] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    1.602074] ehci_hcd 0000:00:1d.7: debug port 2
[    1.605964] ehci_hcd 0000:00:1d.7: cache line size of 256 is not supported
[    1.605985] ehci_hcd 0000:00:1d.7: irq 22, io mem 0xa0606800
[    1.614301] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.614495] hub 2-0:1.0: USB hub found
[    1.614500] hub 2-0:1.0: 8 ports detected
[    1.614750] ata_piix 0000:00:1f.2: version 2.13
[    1.614768] ata_piix 0000:00:1f.2: MAP [
[    1.614771]  P0 P2 P1 P3 ]
[    1.615176] uhci_hcd: USB Universal Host Controller Interface driver
[    1.767469] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.767866] scsi0 : ata_piix
[    1.768111] scsi1 : ata_piix
[    1.768268] ata1: SATA max UDMA/133 cmd 0x2168 ctl 0x217c bmdma 0x2060 irq 19
[    1.768275] ata2: SATA max UDMA/133 cmd 0x2160 ctl 0x2178 bmdma 0x2068 irq 19
[    1.768324] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.768332] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.768342] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.768383] uhci_hcd 0000:00:1a.0: irq 21, io base 0x00002140
[    1.768576] hub 3-0:1.0: USB hub found
[    1.768581] hub 3-0:1.0: 2 ports detected
[    1.768670] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.768674] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.768679] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    1.768704] uhci_hcd 0000:00:1d.0: irq 19, io base 0x000020e0
[    1.768837] hub 4-0:1.0: USB hub found
[    1.768842] hub 4-0:1.0: 2 ports detected
[    1.907237] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    2.031330] hub 1-1:1.0: USB hub found
[    2.031532] hub 1-1:1.0: 3 ports detected
[    2.136883] usb 1-2: new high-speed USB device number 3 using ehci_hcd
[    2.383186] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    2.507214] hub 2-1:1.0: USB hub found
[    2.507413] hub 2-1:1.0: 2 ports detected
[    2.586334] usb 1-1.1: new full-speed USB device number 4 using ehci_hcd
[    2.685441] hub 1-1.1:1.0: USB hub found
[    2.685694] hub 1-1.1:1.0: 3 ports detected
[    2.766052] usb 1-1.2: new full-speed USB device number 5 using ehci_hcd
[    2.789170] ata2.00: failed to resume link (SControl 0)
[    2.878870] usbcore: registered new interface driver usbhid
[    2.878875] usbhid: USB HID core driver
[    2.952325] usb 2-1.1: new high-speed USB device number 3 using ehci_hcd
[    3.055705] Initializing USB Mass Storage driver...
[    3.055850] scsi2 : usb-storage 2-1.1:1.0
[    3.055940] usbcore: registered new interface driver usb-storage
[    3.055942] USB Mass Storage support registered.
[    3.108691] ata1.01: failed to resume link (SControl 0)
[    3.118894] usb 1-1.1.1: new full-speed USB device number 6 using ehci_hcd
[    3.261848] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.261864] ata1.01: SATA link down (SStatus 0 SControl 0)
[    3.268870] ata1.00: ATA-8: APPLE SSD SM256C, AXM09A1Q, max UDMA/133
[    3.268875] ata1.00: 490234752 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.272042] usb 1-1.1.2: new full-speed USB device number 7 using ehci_hcd
[    3.275468] ata1.00: configured for UDMA/133
[    3.275702] scsi 0:0:0:0: Direct-Access     ATA      APPLE SSD SM256C AXM0 PQ: 0 ANSI: 5
[    3.425023] usb 1-1.1.3: new full-speed USB device number 8 using ehci_hcd
[    3.810931] ata2.01: failed to resume link (SControl 0)
[    3.822573] ata2.00: SATA link down (SStatus 0 SControl 0)
[    3.822589] ata2.01: SATA link down (SStatus 0 SControl 0)
[    3.824463] input: Apple Inc. Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.0/input/input0
[    3.824566] apple 0003:05AC:024D.0001: input,hidraw0: USB HID v1.11 Keyboard [Apple Inc. Apple Internal Keyboard / Trackpad] on usb-0000:00:1a.7-1.2/input0
[    3.826123] apple 0003:05AC:024D.0002: hidraw1: USB HID v1.11 Device [Apple Inc. Apple Internal Keyboard / Trackpad] on usb-0000:00:1a.7-1.2/input1
[    3.827042] sd 0:0:0:0: [sda] 490234752 512-byte logical blocks: (251 GB/233 GiB)
[    3.827146] sd 0:0:0:0: [sda] Write Protect is off
[    3.827150] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.827177] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.831543]  sda: sda1 sda2 sda3 sda4 sda5
[    3.832048] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.924801] device-mapper: uevent: version 1.0.3
[    3.924908] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
[    4.079544] scsi 2:0:0:0: Direct-Access     APPLE    SD Card Reader   2.00 PQ: 0 ANSI: 0
[    4.081545] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[    9.253356] bio: create slab <bio-1> at 1
[    9.437239] bio: create slab <bio-1> at 1
[    9.489322] JFS: nTxBlock = 8192, nTxLock = 65536
[    9.618721] systemd[1]: systemd 197 running in system mode. (+PAM -LIBWRAP -AUDIT -SELINUX -IMA -SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    9.623295] systemd[1]: Set hostname to <brief>.
[    9.632124] systemd-fstab-generator[157]: Failed to create mount unit file /run/systemd/generator/home-services-nfs-bibliothek.mount, as it already exists. Duplicate entry in /etc/fstab?
[    9.632251] systemd-fstab-generator[157]: Failed to create mount unit file /run/systemd/generator/home-services-nfs-buch.mount, as it already exists. Duplicate entry in /etc/fstab?
[    9.632544] systemd[1]: /usr/lib/systemd/system-generators/systemd-fstab-generator exited with exit status 1.
[    9.694899] systemd[1]: Cannot add dependency job for unit display-manager.service, ignoring: Unit display-manager.service failed to load: No such file or directory. See system logs and 'systemctl status display-manager.service' for details.
[    9.695171] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
[    9.695229] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[    9.695244] systemd[1]: Starting Syslog Socket.
[    9.695615] systemd[1]: Listening on Syslog Socket.
[    9.695628] systemd[1]: Starting Remote File Systems.
[    9.695938] systemd[1]: Reached target Remote File Systems.
[    9.695949] systemd[1]: Starting Delayed Shutdown Socket.
[    9.696275] systemd[1]: Listening on Delayed Shutdown Socket.
[    9.696286] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[    9.696612] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    9.696622] systemd[1]: Starting LVM2 metadata daemon socket.
[    9.696951] systemd[1]: Listening on LVM2 metadata daemon socket.
[    9.696961] systemd[1]: Starting Device-mapper event daemon FIFOs.
[    9.697288] systemd[1]: Listening on Device-mapper event daemon FIFOs.
[    9.697355] systemd[1]: Starting udev Kernel Socket.
[    9.697680] systemd[1]: Listening on udev Kernel Socket.
[    9.697732] systemd[1]: Starting udev Control Socket.
[    9.698057] systemd[1]: Listening on udev Control Socket.
[    9.698074] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
[    9.698114] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[    9.698146] systemd[1]: Starting Arbitrary Executable File Formats File System Automount Point.
[    9.698567] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[    9.698579] systemd[1]: Expecting device dev-mapper-root.device...
[    9.698802] systemd[1]: Expecting device dev-sda5.device...
[    9.699022] systemd[1]: Expecting device dev-sda2.device...
[    9.699241] systemd[1]: Expecting device dev-mapper-swap.device...
[    9.699461] systemd[1]: Expecting device dev-sda4.device...
[    9.699682] systemd[1]: Starting Journal Socket.
[    9.700022] systemd[1]: Listening on Journal Socket.
[    9.700043] systemd[1]: Starting File System Check on Root Device...
[    9.708906] systemd[1]: Mounting Huge Pages File System...
[    9.715237] systemd[1]: Mounting POSIX Message Queue File System...
[    9.725091] systemd[1]: Mounting Debug File System...
[    9.748342] systemd[1]: Started Set Up Additional Binary Formats.
[    9.750079] systemd[1]: Starting Load Kernel Modules...
[    9.788225] systemd[1]: Starting Apply Kernel Variables...
[    9.798546] systemd[1]: Starting udev Coldplug all Devices...
[    9.808369] systemd[1]: Starting udev Kernel Device Manager...
[    9.821743] systemd[1]: Starting Setup Virtual Console...
[    9.823424] FS-Cache: Loaded
[    9.831683] systemd[1]: Starting Journal Service...
[    9.845419] systemd[1]: Started Journal Service.
[    9.845454] systemd[1]: Starting Syslog.
[    9.845768] systemd[1]: Reached target Syslog.
[    9.846362] systemd[1]: Mounted Huge Pages File System.
[    9.846743] systemd[1]: Mounted POSIX Message Queue File System.
[    9.847109] systemd[1]: Mounted Debug File System.
[    9.851276] systemd[1]: Started Apply Kernel Variables.
[    9.855016] systemd-udevd[173]: starting version 197
[    9.882776] RPC: Registered named UNIX socket transport module.
[    9.882780] RPC: Registered udp transport module.
[    9.882781] RPC: Registered tcp transport module.
[    9.882783] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    9.916682] FS-Cache: Netfs 'nfs' registered for caching
[   10.086305] ACPI: Requesting acpi_cpufreq
[   10.087217] microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x1a
[   10.095607] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[   10.095654] ACPI: Lid Switch [LID0]
[   10.095728] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input2
[   10.095735] ACPI: Power Button [PWRB]
[   10.095810] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input3
[   10.095816] ACPI: Sleep Button [SLPB]
[   10.095907] ACPI: AC Adapter [ADP1] (on-line)
[   10.102794] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[   10.102802] ACPI: Power Button [PWRF]
[   10.109045] input: PC Speaker as /devices/platform/pcspkr/input/input5
[   10.143913] microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x1a
[   10.144744] microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x1a
[   10.145616] microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x1a
[   10.146458] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   10.206747] bcma: bus0: Found chip with id 0xA8D8, rev 0x01 and package 0x08
[   10.206791] bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x22, class 0x0)
[   10.206825] bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x17, class 0x0)
[   10.206883] bcma: bus0: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x0F, class 0x0)
[   10.217632] ACPI: Battery Slot [BAT0] (battery present)
[    3.275953] ACPI: Invalid Power Resource to register!
[   10.248250] ACPI Warning: 
[   10.248258] 0x000000000000efa0-0x000000000000efbf SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120913/utaddress-251)
[   10.248262] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   10.251654] mei 0000:00:16.0: setting latency timer to 64
[   10.254505] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[   10.260859] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PMIO 1 (20120913/utaddress-251)
[   10.260869] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   10.260875] ACPI Warning: 0x0000000000000540-0x000000000000054f SystemIO conflicts with Region \GPIO 1 (20120913/utaddress-251)
[   10.260882] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   10.260885] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \GPIO 1 (20120913/utaddress-251)
[   10.260891] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   10.260894] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \GPIO 1 (20120913/utaddress-251)
[   10.260900] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   10.260902] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   10.265055] mei 0000:00:16.0: wd: failed to find the client
[   10.266437] bcma: bus0: Bus registered
[   10.274674] [drm] Initialized drm 1.1.0 20060810
[   10.322790] pci 0000:00:00.0: Intel Sandybridge Chipset
[   10.322908] pci 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[   10.325108] pci 0000:00:00.0: detected 65536K stolen memory
[   10.325156] i915 0000:00:02.0: setting latency timer to 64
[   10.357656] i915 0000:00:02.0: irq 46 for MSI/MSI-X
[   10.357664] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   10.357665] [drm] Driver supports precise vblank timestamp query.
[   10.357730] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   10.363392] iTCO_vendor_support: vendor-support=0
[   10.363409] media: Linux media interface: v0.10
[   10.364856] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input6
[   10.365062] usbcore: registered new interface driver bcm5974
[   10.368891] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   10.368927] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
[   10.371554] Linux video capture interface: v2.00
[   10.381113] input: HID 05ac:820a as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.0/input/input7
[   10.381206] hid-generic 0003:05AC:820A.0003: input,hidraw2: USB HID v1.11 Keyboard [HID 05ac:820a] on usb-0000:00:1a.7-1.1.1/input0
[   10.381339] input: HID 05ac:820b as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.1/1-1.1.2/1-1.1.2:1.0/input/input8
[   10.381434] hid-generic 0003:05AC:820B.0004: input,hidraw3: USB HID v1.11 Mouse [HID 05ac:820b] on usb-0000:00:1a.7-1.1.2/input0
[   10.391872] uvcvideo: Found UVC 1.00 device FaceTime Camera (Built-in) (05ac:850a)
[   10.400384] input: FaceTime Camera (Built-in) as /devices/pci0000:00/0000:00:1a.7/usb1/1-2/1-2:1.0/input/input9
[   10.400559] usbcore: registered new interface driver uvcvideo
[   10.400561] USB Video Class driver (1.1.1)
[   10.436573] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[   10.486761] Bluetooth: Core ver 2.16
[   10.486785] NET: Registered protocol family 31
[   10.486787] Bluetooth: HCI device and connection manager initialized
[   10.486794] Bluetooth: HCI socket layer initialized
[   10.486797] Bluetooth: L2CAP socket layer initialized
[   10.486802] Bluetooth: SCO socket layer initialized
[   10.492153] cfg80211: Calling CRDA to update world regulatory domain
[   10.494029] usbcore: registered new interface driver btusb
[   10.500546] applesmc: key=349 fan=1 temp=25 index=24 acc=0 lux=2 kbd=1
[   10.501225] Registered led device: smc::kbd_backlight
[   10.540678] usb 1-1.1.1: USB disconnect, device number 6
[   10.544777] brcmsmac bcma0:0: mfg 4bf core 812 rev 23 class 0 irq 17
[   10.626905] [drm] GMBUS [i915 gmbus vga] timed out, falling back to bit banging on pin 2
[   10.638790] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[   10.677267] usb 1-1.1.2: USB disconnect, device number 7
[   10.718177] fbcon: inteldrmfb (fb0) is primary device
[   12.520576] Console: switching to colour frame buffer device 180x56
[   12.523788] fb0: inteldrmfb frame buffer device
[   12.523789] drm: registered panic notifier
[   12.531377] acpi device:0c: registered as cooling_device4
[   12.531523] ACPI: Video Device [IGPU] (multi-head: yes  rom: no  post: no)
[   12.531596] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input10
[   12.531811] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   12.531950] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[   12.732899] input: HDA Intel PCH HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   12.732969] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   12.733026] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[   12.733075] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[   12.888624] EXT4-fs (sda4): mounted filesystem with ordered data mode. Opts: (null)
[   12.968754] Adding 8386556k swap on /dev/mapper/swap.  Priority:-1 extents:1 across:8386556k SS
[   13.007710] systemd-journald[176]: Received SIGUSR1
[   13.016591] systemd-journald[176]: File /var/log/journal/430f5d56a9288edc7eca1b05000004e3/system.journal corrupted or uncleanly shut down, renaming and replacing.
[   14.255420] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[   14.256639] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[   14.261286] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   23.302658] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[   23.302669] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[   23.303691] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   23.445603] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[   23.445614] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[   23.446628] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   29.462223] wlan0: authenticate with 0e:b0:5d:9c:37:13
[   29.464937] wlan0: send auth to 0e:b0:5d:9c:37:13 (try 1/3)
[   29.468163] wlan0: authenticated
[   29.470992] wlan0: associate with 0e:b0:5d:9c:37:13 (try 1/3)
[   29.474879] wlan0: RX AssocResp from 0e:b0:5d:9c:37:13 (capab=0x411 status=0 aid=1)
[   29.475453] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[   29.475463] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[   29.475469] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[   29.475499] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   29.475616] wlan0: associated
[   34.646676] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[  390.781494] ieee80211 phy0: START: tid 1 is not agg'able
[  511.989362] ieee80211 phy0: START: tid 1 is not agg'able
[  878.867312] ieee80211 phy0: START: tid 1 is not agg'able
[ 3165.260365] PM: Syncing filesystems ... done.
[ 3165.316556] PM: Preparing system for mem sleep
[ 3165.426953] Freezing user space processes ... (elapsed 0.01 seconds) done.
[ 3165.438856] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[ 3165.452301] PM: Entering mem sleep
[ 3165.452352] Suspending console(s) (use no_console_suspend to debug)
[ 3165.501364] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 3165.502676] sd 0:0:0:0: [sda] Stopping disk
[ 3167.099633] PM: suspend of devices complete after 1609.511 msecs
[ 3167.100108] PM: late suspend of devices complete after 0.470 msecs
[ 3167.113190] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[ 3167.126328] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[ 3167.152841] PM: noirq suspend of devices complete after 52.811 msecs
[ 3167.153716] ACPI: Preparing to enter system sleep state S3
[ 3167.179483] PM: Saving platform NVS memory
[ 3167.180187] Disabling non-boot CPUs ...
[ 3167.282532] smpboot: CPU 1 is now offline
[ 3167.385697] smpboot: CPU 2 is now offline
[ 3167.488872] smpboot: CPU 3 is now offline
[ 3167.489483] Extended CMOS year: 2000
[ 3167.491589] ACPI: Low-level resume complete
[ 3167.491632] PM: Restoring platform NVS memory
[ 3167.491931] Extended CMOS year: 2000
[ 3167.491994] Enabling non-boot CPUs ...
[ 3167.495437] smpboot: Booting Node 0 Processor 1 APIC 0x2
[ 3167.509660] CPU1 is up
[ 3167.513054] smpboot: Booting Node 0 Processor 2 APIC 0x1
[ 3167.526533] CPU2 is up
[ 3167.526998] smpboot: Booting Node 0 Processor 3 APIC 0x3
[ 3167.541252] CPU3 is up
[ 3167.546191] ACPI: Waking up from system sleep state S3
[ 3168.110441] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[ 3168.123963] pcieport 0000:00:1c.1: power state changed by ACPI to D0
[ 3168.137061] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[ 3168.164061] PM: noirq resume of devices complete after 93.620 msecs
[ 3168.164513] PM: early resume of devices complete after 0.351 msecs
[ 3168.164573] i915 0000:00:02.0: setting latency timer to 64
[ 3168.164601] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[ 3168.164648] usb usb3: root hub lost power or was reset
[ 3168.164660] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[ 3168.164667] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[ 3168.164735] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[ 3168.164768] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[ 3168.164797] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[ 3168.164798] usb usb4: root hub lost power or was reset
[ 3168.164823] ata_piix 0000:00:1f.2: setting latency timer to 64
[ 3168.167548] mei 0000:00:16.0: wd: failed to find the client
[ 3168.220171] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake old ack to clear.
[ 3168.221423] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[ 3168.238025] bcm5974: bad trackpad package, length: 8
[ 3168.239018] bcm5974: bad trackpad package, length: 8
[ 3168.285947] Extended CMOS year: 2000
[ 3169.185479] ata2.00: failed to resume link (SControl 0)
[ 3169.504951] ata1.01: failed to resume link (SControl 0)
[ 3169.658134] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 3169.658152] ata1.01: SATA link down (SStatus 0 SControl 0)
[ 3169.665487] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[ 3169.671820] ata1.00: configured for UDMA/133
[ 3169.706377] sd 0:0:0:0: [sda] Starting disk
[ 3170.207219] ata2.01: failed to resume link (SControl 0)
[ 3170.219102] ata2.00: SATA link down (SStatus 4 SControl 0)
[ 3170.219123] ata2.01: SATA link down (SStatus 0 SControl 0)
[ 3170.236170] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[ 3170.248085] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[ 3170.248088] ieee80211 phy0: changing basic rates failed: -22
[ 3170.248090] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: threshold 0, hys 0  (implement)
[ 3170.248099] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[ 3170.248100] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[ 3170.248187] PM: resume of devices complete after 2086.917 msecs
[ 3170.248679] PM: Finishing wakeup.
[ 3170.253727] wlan0: deauthenticated from 0e:b0:5d:9c:37:13 (Reason: 7)
[ 3170.248680] Restarting tasks ... done.
[ 3170.270472] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[ 3170.270521] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[ 3170.270558] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[ 3170.281548] cfg80211: Calling CRDA for country: CH
[ 3170.308904] video LNXVIDEO:00: Restoring backlight state
[ 3170.447566] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[ 3170.447578] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[ 3170.448688] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 3172.127642] EXT4-fs (sda4): re-mounted. Opts: commit=0
[ 3175.196216] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[ 3175.196241] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[ 3175.197450] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 3179.445348] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[ 3179.445359] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[ 3179.446468] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 3179.498483] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[ 3179.498495] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[ 3179.499539] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 3181.603741] wlan0: authenticate with 0e:b0:5d:9c:37:13
[ 3181.603782] wlan0: send auth to 0e:b0:5d:9c:37:13 (try 1/3)
[ 3181.605625] wlan0: authenticated
[ 3181.606039] wlan0: associate with 0e:b0:5d:9c:37:13 (try 1/3)
[ 3181.611665] wlan0: RX AssocResp from 0e:b0:5d:9c:37:13 (capab=0x411 status=0 aid=1)
[ 3181.612736] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[ 3181.612748] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[ 3181.612754] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[ 3181.612783] wlan0: associated
[ 3181.612835] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[ 3187.721885] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[ 5576.322238] ieee80211 phy0: START: tid 1 is not agg'able
[ 5626.843489] ieee80211 phy0: START: tid 1 is not agg'able
[ 5685.898145] ieee80211 phy0: START: tid 1 is not agg'able
[ 6604.799808] ieee80211 phy0: START: tid 1 is not agg'able
[ 6646.306431] ieee80211 phy0: START: tid 1 is not agg'able
[ 7373.182826] ieee80211 phy0: START: tid 2 is not agg'able
[ 7801.116155] ieee80211 phy0: START: tid 1 is not agg'able
[ 8496.392965] ieee80211 phy0: START: tid 2 is not agg'able
[ 9155.472843] ieee80211 phy0: START: tid 1 is not agg'able
[ 9455.119374] ieee80211 phy0: START: tid 2 is not agg'able
[ 9935.417910] ieee80211 phy0: START: tid 1 is not agg'able
[11702.488995] ieee80211 phy0: START: tid 1 is not agg'able
[14397.830898] CPU1: Package power limit notification (total events = 1)
[14397.830901] CPU3: Package power limit notification (total events = 1)
[14397.830904] CPU0: Package power limit notification (total events = 1)
[14397.830906] CPU2: Package power limit notification (total events = 1)
[14397.841871] CPU0: Package power limit normal
[14397.841875] CPU1: Package power limit normal
[14397.841877] CPU3: Package power limit normal
[14397.841878] CPU2: Package power limit normal
[19015.195083] ieee80211 phy0: START: tid 1 is not agg'able
[19374.646994] ieee80211 phy0: START: tid 1 is not agg'able
[19540.848868] ieee80211 phy0: START: tid 1 is not agg'able
[19586.309967] EXT4-fs (sda4): re-mounted. Opts: commit=600
[19587.617066] PM: Syncing filesystems ... done.
[19587.716772] PM: Preparing system for mem sleep
[19588.128425] ------------[ cut here ]------------
[19588.128466] WARNING: at drivers/gpu/drm/i915/intel_display.c:6976 intel_modeset_check_state+0x4bb/0x610 [i915]()
[19588.128470] Hardware name: MacBookAir4,2
[19588.128474] encoder's hw state doesn't match sw tracking (expected 1, found 0)
[19588.128477] Modules linked in: ext4 jbd2 mbcache snd_hda_codec_hdmi snd_hda_codec_cirrus sha256_generic arc4 brcmsmac cordic brcmutil mac80211 btusb cfg80211 bluetooth rfkill uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core hid_generic snd_hda_intel crc16 joydev applesmc videodev iTCO_wdt bcm5974 coretemp iTCO_vendor_support media snd_hda_codec i915 acpi_cpufreq intel_agp intel_gtt drm_kms_helper drm i2c_algo_bit lpc_ich mei i2c_i801 i2c_core bcma mperf apple_bl input_polldev snd_hwdep evdev pcspkr video battery ac button microcode processor snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_timer snd soundcore kvm_intel kvm nfs lockd sunrpc fscache jfs dm_crypt dm_mod sd_mod hid_apple ata_generic pata_acpi usb_storage usbhid hid uhci_hcd crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64
[19588.128598]  ablk_helper cryptd xts lrw gf128mul ata_piix libata scsi_mod ehci_hcd usbcore usb_common
[19588.128619] Pid: 692, comm: X Not tainted 3.7.9-1-ARCH #1
[19588.128623] Call Trace:
[19588.128636]  [<ffffffff8105756f>] warn_slowpath_common+0x7f/0xc0
[19588.128644]  [<ffffffff81057666>] warn_slowpath_fmt+0x46/0x50
[19588.128665]  [<ffffffffa04ab8db>] intel_modeset_check_state+0x4bb/0x610 [i915]
[19588.128682]  [<ffffffffa04aba74>] intel_connector_dpms+0x44/0x70 [i915]
[19588.128700]  [<ffffffffa03ced3d>] drm_mode_obj_set_property_ioctl+0x32d/0x340 [drm]
[19588.128714]  [<ffffffffa03ced80>] drm_mode_connector_property_set_ioctl+0x30/0x40 [drm]
[19588.128728]  [<ffffffffa03bd3f3>] drm_ioctl+0x4c3/0x570 [drm]
[19588.128743]  [<ffffffffa03ced50>] ? drm_mode_obj_set_property_ioctl+0x340/0x340 [drm]
[19588.128754]  [<ffffffff8112a617>] ? __free_pages+0x57/0x70
[19588.128763]  [<ffffffff8116f67c>] ? kfree+0x2c/0x160
[19588.128772]  [<ffffffff81195e77>] do_vfs_ioctl+0x97/0x530
[19588.128780]  [<ffffffff81185bfe>] ? ____fput+0xe/0x10
[19588.128787]  [<ffffffff811963a1>] sys_ioctl+0x91/0xb0
[19588.128797]  [<ffffffff81015dbc>] ? do_notify_resume+0x9c/0xb0
[19588.128808]  [<ffffffff814c365d>] system_call_fastpath+0x1a/0x1f
[19588.128813] ---[ end trace 062d4264ec211134 ]---
[19588.150986] ------------[ cut here ]------------
[19588.151036] WARNING: at drivers/gpu/drm/i915/intel_dp.c:1908 intel_dp_link_down+0x1d2/0x1e0 [i915]()
[19588.151040] Hardware name: MacBookAir4,2
[19588.151053] Modules linked in: ext4 jbd2 mbcache snd_hda_codec_hdmi snd_hda_codec_cirrus sha256_generic arc4 brcmsmac cordic brcmutil mac80211 btusb cfg80211 bluetooth rfkill uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core hid_generic snd_hda_intel crc16 joydev applesmc videodev iTCO_wdt bcm5974 coretemp iTCO_vendor_support media snd_hda_codec i915 acpi_cpufreq intel_agp intel_gtt drm_kms_helper drm i2c_algo_bit lpc_ich mei i2c_i801 i2c_core bcma mperf apple_bl input_polldev snd_hwdep evdev pcspkr video battery ac button microcode processor snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_timer snd soundcore kvm_intel kvm nfs lockd sunrpc fscache jfs dm_crypt dm_mod sd_mod hid_apple ata_generic pata_acpi usb_storage usbhid hid uhci_hcd crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64
[19588.151096]  ablk_helper cryptd xts lrw gf128mul ata_piix libata scsi_mod ehci_hcd usbcore usb_common
[19588.151104] Pid: 692, comm: X Tainted: G        W    3.7.9-1-ARCH #1
[19588.151106] Call Trace:
[19588.151111]  [<ffffffff8105756f>] warn_slowpath_common+0x7f/0xc0
[19588.151113]  [<ffffffff810575ca>] warn_slowpath_null+0x1a/0x20
[19588.151119]  [<ffffffffa04b43f2>] intel_dp_link_down+0x1d2/0x1e0 [i915]
[19588.151125]  [<ffffffffa04b6594>] intel_disable_dp+0x44/0x170 [i915]
[19588.151131]  [<ffffffffa04a527e>] ironlake_crtc_disable+0x68e/0x820 [i915]
[19588.151137]  [<ffffffffa04aa307>] intel_crtc_update_dpms+0x77/0xb0 [i915]
[19588.151142]  [<ffffffffa04aa3fa>] intel_encoder_dpms+0x1a/0x30 [i915]
[19588.151148]  [<ffffffffa04aba6c>] intel_connector_dpms+0x3c/0x70 [i915]
[19588.151154]  [<ffffffffa03ced3d>] drm_mode_obj_set_property_ioctl+0x32d/0x340 [drm]
[19588.151159]  [<ffffffffa03ced80>] drm_mode_connector_property_set_ioctl+0x30/0x40 [drm]
[19588.151163]  [<ffffffffa03bd3f3>] drm_ioctl+0x4c3/0x570 [drm]
[19588.151168]  [<ffffffffa03ced50>] ? drm_mode_obj_set_property_ioctl+0x340/0x340 [drm]
[19588.151172]  [<ffffffff81020365>] ? __restore_xstate_sig+0x95/0x600
[19588.151175]  [<ffffffff81195e77>] do_vfs_ioctl+0x97/0x530
[19588.151178]  [<ffffffff8101525a>] ? restore_sigcontext+0x12a/0x140
[19588.151180]  [<ffffffff811963a1>] sys_ioctl+0x91/0xb0
[19588.151184]  [<ffffffff814c365d>] system_call_fastpath+0x1a/0x1f
[19588.151186] ---[ end trace 062d4264ec211135 ]---
[19589.497141] Freezing user space processes ... (elapsed 0.05 seconds) done.
[19589.548973] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[19589.562360] PM: Entering mem sleep
[19589.562417] Suspending console(s) (use no_console_suspend to debug)
[19589.611517] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[19589.612798] sd 0:0:0:0: [sda] Stopping disk
[19590.950083] PM: suspend of devices complete after 1349.498 msecs
[19590.950559] PM: late suspend of devices complete after 0.472 msecs
[19590.963747] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[19590.976875] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[19591.003341] PM: noirq suspend of devices complete after 52.859 msecs
[19591.004216] ACPI: Preparing to enter system sleep state S3
[19591.029948] PM: Saving platform NVS memory
[19591.030658] Disabling non-boot CPUs ...
[19591.032366] smpboot: CPU 1 is now offline
[19591.136319] smpboot: CPU 2 is now offline
[19591.239493] smpboot: CPU 3 is now offline
[19591.240088] Extended CMOS year: 2000
[19591.242197] ACPI: Low-level resume complete
[19591.242242] PM: Restoring platform NVS memory
[19591.242542] Extended CMOS year: 2000
[19591.242605] Enabling non-boot CPUs ...
[19591.246046] smpboot: Booting Node 0 Processor 1 APIC 0x2
[19591.260453] CPU1 is up
[19591.263844] smpboot: Booting Node 0 Processor 2 APIC 0x1
[19591.277433] CPU2 is up
[19591.277883] smpboot: Booting Node 0 Processor 3 APIC 0x3
[19591.292139] CPU3 is up
[19591.297024] ACPI: Waking up from system sleep state S3
[19591.837775] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[19591.851194] pcieport 0000:00:1c.1: power state changed by ACPI to D0
[19591.864390] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[19591.891399] PM: noirq resume of devices complete after 93.675 msecs
[19591.891842] PM: early resume of devices complete after 0.343 msecs
[19591.891912] i915 0000:00:02.0: setting latency timer to 64
[19591.891925] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[19591.891970] usb usb3: root hub lost power or was reset
[19591.891994] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[19591.892004] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[19591.892119] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[19591.892124] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[19591.892151] usb usb4: root hub lost power or was reset
[19591.892155] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[19591.892176] ata_piix 0000:00:1f.2: setting latency timer to 64
[19591.892773] mei 0000:00:16.0: wd: failed to find the client
[19591.960816] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake old ack to clear.
[19591.962082] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[19592.020026] Extended CMOS year: 2000
[19592.916136] ata2.00: failed to resume link (SControl 0)
[19593.235641] ata1.01: failed to resume link (SControl 0)
[19593.388821] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[19593.388839] ata1.01: SATA link down (SStatus 0 SControl 0)
[19593.395738] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[19593.402485] ata1.00: configured for UDMA/133
[19593.438860] sd 0:0:0:0: [sda] Starting disk
[19593.937882] ata2.01: failed to resume link (SControl 0)
[19593.949763] ata2.00: SATA link down (SStatus 4 SControl 0)
[19593.949785] ata2.01: SATA link down (SStatus 0 SControl 0)
[19593.966704] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[19593.967748] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[19593.967754] ieee80211 phy0: changing basic rates failed: -22
[19593.967759] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: threshold 0, hys 0  (implement)
[19593.967762] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[19593.967766] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[19593.968083] PM: resume of devices complete after 2079.466 msecs
[19593.969562] PM: Finishing wakeup.
[19593.969565] Restarting tasks ... done.
[19594.034336] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[19594.034403] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[19594.034491] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[19594.035283] cfg80211: Calling CRDA to update world regulatory domain
[19594.038082] video LNXVIDEO:00: Restoring backlight state
[19599.929574] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[19599.929587] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[19599.930606] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[19604.771149] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[19604.771161] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[19604.772180] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[19608.948641] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[19608.948662] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[19608.949751] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[19609.006165] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[19609.006179] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[19609.007222] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[19611.225542] wlan0: authenticate with 5c:ff:35:75:05:89
[19611.229361] wlan0: send auth to 5c:ff:35:75:05:89 (try 1/3)
[19611.233702] wlan0: authenticated
[19611.234163] wlan0: associate with 5c:ff:35:75:05:89 (try 1/3)
[19611.247308] wlan0: RX AssocResp from 5c:ff:35:75:05:89 (capab=0x431 status=0 aid=1)
[19611.247915] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[19611.247931] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[19611.247940] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[19611.247956] wlan0: associated
[19611.248030] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[19620.523569] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[21387.493236] PM: Syncing filesystems ... done.
[21387.625087] PM: Preparing system for mem sleep
[21387.759638] Freezing user space processes ... (elapsed 0.01 seconds) done.
[21387.773147] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[21387.786474] PM: Entering mem sleep
[21387.786531] Suspending console(s) (use no_console_suspend to debug)
[21387.836875] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[21387.838158] sd 0:0:0:0: [sda] Stopping disk
[21389.323965] PM: suspend of devices complete after 1499.572 msecs
[21389.324445] PM: late suspend of devices complete after 0.476 msecs
[21389.337610] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[21389.350739] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[21389.377211] PM: noirq suspend of devices complete after 52.844 msecs
[21389.378086] ACPI: Preparing to enter system sleep state S3
[21389.403816] PM: Saving platform NVS memory
[21389.404526] Disabling non-boot CPUs ...
[21389.506870] smpboot: CPU 1 is now offline
[21389.610033] smpboot: CPU 2 is now offline
[21389.713204] smpboot: CPU 3 is now offline
[21389.713821] Extended CMOS year: 2000
[21389.715924] ACPI: Low-level resume complete
[21389.715964] PM: Restoring platform NVS memory
[21389.716262] Extended CMOS year: 2000
[21389.716302] Enabling non-boot CPUs ...
[21389.719772] smpboot: Booting Node 0 Processor 1 APIC 0x2
[21389.734117] CPU1 is up
[21389.737512] smpboot: Booting Node 0 Processor 2 APIC 0x1
[21389.751113] CPU2 is up
[21389.751546] smpboot: Booting Node 0 Processor 3 APIC 0x3
[21389.765776] CPU3 is up
[21389.770720] ACPI: Waking up from system sleep state S3
[21390.311476] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[21390.324898] pcieport 0000:00:1c.1: power state changed by ACPI to D0
[21390.338094] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[21390.365092] PM: noirq resume of devices complete after 93.670 msecs
[21390.365538] PM: early resume of devices complete after 0.344 msecs
[21390.365611] i915 0000:00:02.0: setting latency timer to 64
[21390.365640] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[21390.365644] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[21390.365669] usb usb3: root hub lost power or was reset
[21390.365681] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[21390.365705] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[21390.365732] usb usb4: root hub lost power or was reset
[21390.365740] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[21390.365757] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[21390.365783] ata_piix 0000:00:1f.2: setting latency timer to 64
[21390.368460] mei 0000:00:16.0: wd: failed to find the client
[21390.421204] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake old ack to clear.
[21390.422462] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[21390.497037] Extended CMOS year: 2000
[21391.386509] ata2.00: failed to resume link (SControl 0)
[21391.705985] ata1.01: failed to resume link (SControl 0)
[21391.859196] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[21391.859214] ata1.01: SATA link down (SStatus 0 SControl 0)
[21391.866104] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[21391.872852] ata1.00: configured for UDMA/133
[21391.907333] sd 0:0:0:0: [sda] Starting disk
[21392.408249] ata2.01: failed to resume link (SControl 0)
[21392.420131] ata2.00: SATA link down (SStatus 4 SControl 0)
[21392.420153] ata2.01: SATA link down (SStatus 0 SControl 0)
[21392.436725] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[21392.437716] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[21392.437718] ieee80211 phy0: changing basic rates failed: -22
[21392.437719] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: threshold 0, hys 0  (implement)
[21392.437720] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[21392.437721] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[21392.437978] PM: resume of devices complete after 2075.661 msecs
[21392.439507] PM: Finishing wakeup.
[21392.439510] Restarting tasks ... done.
[21392.462923] video LNXVIDEO:00: Restoring backlight state
[21392.509663] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[21392.509670] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[21392.509672] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[21392.521440] cfg80211: Calling CRDA to update world regulatory domain
[21394.236610] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[21394.236623] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[21394.237831] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[21397.636488] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[21397.636499] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[21397.637557] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23570.124760] PM: Syncing filesystems ... done.
[23570.144077] PM: Preparing system for mem sleep
[23570.263161] Freezing user space processes ... (elapsed 0.01 seconds) done.
[23570.275341] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[23570.288835] PM: Entering mem sleep
[23570.288884] Suspending console(s) (use no_console_suspend to debug)
[23570.331810] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[23570.333144] sd 0:0:0:0: [sda] Stopping disk
[23571.566695] PM: suspend of devices complete after 1239.470 msecs
[23571.567170] PM: late suspend of devices complete after 0.470 msecs
[23571.580376] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[23571.593505] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[23571.619974] PM: noirq suspend of devices complete after 52.881 msecs
[23571.620849] ACPI: Preparing to enter system sleep state S3
[23571.646578] PM: Saving platform NVS memory
[23571.647290] Disabling non-boot CPUs ...
[23571.649011] smpboot: CPU 1 is now offline
[23571.752952] smpboot: CPU 2 is now offline
[23571.856126] smpboot: CPU 3 is now offline
[23571.856707] Extended CMOS year: 2000
[23571.858816] ACPI: Low-level resume complete
[23571.858858] PM: Restoring platform NVS memory
[23571.859158] Extended CMOS year: 2000
[23571.859221] Enabling non-boot CPUs ...
[23571.862660] smpboot: Booting Node 0 Processor 1 APIC 0x2
[23571.876788] CPU1 is up
[23571.880180] smpboot: Booting Node 0 Processor 2 APIC 0x1
[23571.893794] CPU2 is up
[23571.894232] smpboot: Booting Node 0 Processor 3 APIC 0x3
[23571.908426] CPU3 is up
[23571.913477] ACPI: Waking up from system sleep state S3
[23572.454404] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[23572.467826] pcieport 0000:00:1c.1: power state changed by ACPI to D0
[23572.481020] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[23572.508020] PM: noirq resume of devices complete after 93.670 msecs
[23572.508420] PM: early resume of devices complete after 0.356 msecs
[23572.508480] i915 0000:00:02.0: setting latency timer to 64
[23572.508545] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[23572.508594] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[23572.508605] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[23572.508622] usb usb3: root hub lost power or was reset
[23572.508683] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[23572.508684] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[23572.508710] usb usb4: root hub lost power or was reset
[23572.508724] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[23572.508735] ata_piix 0000:00:1f.2: setting latency timer to 64
[23572.509373] mei 0000:00:16.0: wd: failed to find the client
[23572.564132] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake old ack to clear.
[23572.565524] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[23572.580942] bcm5974: bad trackpad package, length: 8
[23572.582936] bcm5974: bad trackpad package, length: 8
[23572.583931] bcm5974: bad trackpad package, length: 8
[23572.596920] bcm5974: bad trackpad package, length: 8
[23572.597943] bcm5974: bad trackpad package, length: 8
[23572.599925] bcm5974: bad trackpad package, length: 8
[23572.647143] Extended CMOS year: 2000
[23573.529431] ata2.00: failed to resume link (SControl 0)
[23573.848939] ata1.01: failed to resume link (SControl 0)
[23574.002116] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[23574.002134] ata1.01: SATA link down (SStatus 0 SControl 0)
[23574.009031] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[23574.015784] ata1.00: configured for UDMA/133
[23574.050258] sd 0:0:0:0: [sda] Starting disk
[23574.551182] ata2.01: failed to resume link (SControl 0)
[23574.563121] ata2.00: SATA link down (SStatus 4 SControl 0)
[23574.563143] ata2.01: SATA link down (SStatus 0 SControl 0)
[23574.580018] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23574.581021] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[23574.581024] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: threshold 0, hys 0  (implement)
[23574.581025] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[23574.581026] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23574.581063] PM: resume of devices complete after 2075.871 msecs
[23574.595656] PM: Finishing wakeup.
[23574.595660] Restarting tasks ... done.
[23574.643960] video LNXVIDEO:00: Restoring backlight state
[23610.999298] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23610.999325] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23611.000586] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23611.071476] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23611.071487] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23611.072503] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23613.381360] wlan0: authenticate with 28:cf:da:ba:6a:10
[23613.403314] wlan0: direct probe to 28:cf:da:ba:6a:10 (try 1/3)
[23613.603544] wlan0: send auth to 28:cf:da:ba:6a:10 (try 2/3)
[23613.604044] wlan0: authenticated
[23613.606950] wlan0: associate with 28:cf:da:ba:6a:10 (try 1/3)
[23613.607696] wlan0: RX AssocResp from 28:cf:da:ba:6a:10 (capab=0x511 status=0 aid=8)
[23613.608204] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[23613.608214] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[23613.608219] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[23613.608246] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[23613.608381] wlan0: associated
[23613.688393] wlan0: Limiting TX power to 30 (30 - 0) dBm as advertised by 28:cf:da:ba:6a:10
[23616.390806] wlan0: deauthenticating from 28:cf:da:ba:6a:10 by local choice (reason=3)
[23616.416028] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[23616.416048] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[23616.416054] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23616.416785] cfg80211: Calling CRDA for country: US
[23616.439671] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23616.439682] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23616.440711] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23629.057886] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23629.057906] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23629.059001] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23629.104621] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23629.104642] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23629.105729] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23629.174267] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23629.174278] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23629.175316] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23631.486290] wlan0: authenticate with 28:cf:da:ba:6a:10
[23631.486306] wlan0: send auth to 28:cf:da:ba:6a:10 (try 1/3)
[23631.486708] wlan0: authenticated
[23631.489035] wlan0: associate with 28:cf:da:ba:6a:10 (try 1/3)
[23631.489746] wlan0: RX AssocResp from 28:cf:da:ba:6a:10 (capab=0x511 status=0 aid=8)
[23631.490215] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[23631.490219] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[23631.490220] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[23631.490226] wlan0: associated
[23631.490243] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[23631.580945] wlan0: Limiting TX power to 30 (30 - 0) dBm as advertised by 28:cf:da:ba:6a:10
[23634.358468] wlan0: deauthenticating from 28:cf:da:ba:6a:10 by local choice (reason=3)
[23634.394712] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[23634.394731] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[23634.394737] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23634.395393] cfg80211: Calling CRDA to update world regulatory domain
[23634.426499] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23634.426510] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23634.427535] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23667.890808] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23667.890828] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23667.891909] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23667.929450] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23667.929461] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23667.930477] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23667.993855] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23667.993865] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23667.994890] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23670.298952] wlan0: authenticate with 28:cf:da:ba:6a:10
[23670.298967] wlan0: send auth to 28:cf:da:ba:6a:10 (try 1/3)
[23670.299459] wlan0: authenticated
[23670.301943] wlan0: associate with 28:cf:da:ba:6a:10 (try 1/3)
[23670.302735] wlan0: RX AssocResp from 28:cf:da:ba:6a:10 (capab=0x511 status=0 aid=8)
[23670.303345] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[23670.303359] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[23670.303368] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[23670.303387] wlan0: associated
[23670.303448] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[23670.331214] wlan0: Limiting TX power to 30 (30 - 0) dBm as advertised by 28:cf:da:ba:6a:10
[23673.306189] wlan0: deauthenticating from 28:cf:da:ba:6a:10 by local choice (reason=3)
[23673.320715] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[23673.320736] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[23673.320742] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23673.321412] cfg80211: Calling CRDA for country: CH
[23673.350206] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23673.350217] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23673.351278] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23695.334269] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23695.334281] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23695.335305] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23720.773823] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23720.773844] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23720.774944] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23720.899020] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23720.899042] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23720.900158] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23731.065566] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23731.065580] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23731.066620] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23743.539571] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23743.539593] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23743.540677] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23743.617517] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23743.617528] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23743.619564] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23745.938858] wlan0: authenticate with 28:cf:da:ba:6a:10
[23745.938909] wlan0: send auth to 28:cf:da:ba:6a:10 (try 1/3)
[23745.939361] wlan0: authenticated
[23745.941164] wlan0: associate with 28:cf:da:ba:6a:10 (try 1/3)
[23745.941888] wlan0: RX AssocResp from 28:cf:da:ba:6a:10 (capab=0x511 status=0 aid=8)
[23745.942426] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[23745.942440] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[23745.942449] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[23745.942466] wlan0: associated
[23745.942523] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[23745.990988] wlan0: Limiting TX power to 30 (30 - 0) dBm as advertised by 28:cf:da:ba:6a:10
[23749.180446] wlan0: deauthenticating from 28:cf:da:ba:6a:10 by local choice (reason=3)
[23749.195944] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[23749.195965] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[23749.195971] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23749.196651] cfg80211: Calling CRDA to update world regulatory domain
[23749.219746] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23749.219757] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23749.220780] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23771.132237] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23771.132249] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23771.133272] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23781.201091] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23781.201119] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23781.202305] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23781.254499] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23781.254519] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23781.255602] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23783.563422] wlan0: authenticate with 28:cf:da:ba:6a:10
[23783.563461] wlan0: send auth to 28:cf:da:ba:6a:10 (try 1/3)
[23783.563946] wlan0: authenticated
[23783.565549] wlan0: associate with 28:cf:da:ba:6a:10 (try 1/3)
[23783.566392] wlan0: RX AssocResp from 28:cf:da:ba:6a:10 (capab=0x511 status=0 aid=8)
[23783.566899] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[23783.566908] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[23783.566914] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[23783.566930] wlan0: associated
[23783.566979] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[23783.616529] wlan0: Limiting TX power to 30 (30 - 0) dBm as advertised by 28:cf:da:ba:6a:10
[23789.533188] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[23794.565442] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[23794.763096] wlan0: deauthenticating from 28:cf:da:ba:6a:10 by local choice (reason=3)
[23794.781332] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[23794.781350] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[23794.781356] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23794.782006] cfg80211: Calling CRDA to update world regulatory domain
[23794.804493] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23794.804506] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23794.805681] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23794.896295] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23794.896306] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23794.897355] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23795.871072] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23795.871093] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23795.872187] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23797.214748] wlan0: authenticate with 28:cf:da:ba:6a:10
[23797.214762] wlan0: send auth to 28:cf:da:ba:6a:10 (try 1/3)
[23797.215193] wlan0: authenticated
[23797.217633] wlan0: associate with 28:cf:da:ba:6a:10 (try 1/3)
[23797.218400] wlan0: RX AssocResp from 28:cf:da:ba:6a:10 (capab=0x511 status=0 aid=8)
[23797.219009] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[23797.219023] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[23797.219033] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[23797.219052] wlan0: associated
[23797.219107] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[23797.317145] wlan0: Limiting TX power to 30 (30 - 0) dBm as advertised by 28:cf:da:ba:6a:10
[23807.650816] wlan0: deauthenticating from 28:cf:da:ba:6a:10 by local choice (reason=3)
[23807.667965] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[23807.667989] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[23807.667999] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23807.668701] cfg80211: Calling CRDA for country: CH
[23807.712235] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23807.712263] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23807.713534] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23807.785208] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23807.785219] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23807.786245] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23808.780361] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23808.780387] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23808.781518] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23810.108592] wlan0: authenticate with 28:cf:da:ba:6a:10
[23810.108633] wlan0: send auth to 28:cf:da:ba:6a:10 (try 1/3)
[23810.109111] wlan0: authenticated
[23810.110842] wlan0: associate with 28:cf:da:ba:6a:10 (try 1/3)
[23810.111634] wlan0: RX AssocResp from 28:cf:da:ba:6a:10 (capab=0x511 status=0 aid=8)
[23810.112150] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[23810.112161] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[23810.112167] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[23810.112185] wlan0: associated
[23810.112237] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[23810.199779] wlan0: Limiting TX power to 30 (30 - 0) dBm as advertised by 28:cf:da:ba:6a:10
[23816.418228] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[23820.565098] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[23820.760319] wlan0: deauthenticating from 28:cf:da:ba:6a:10 by local choice (reason=3)
[23820.800887] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[23820.800913] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[23820.800919] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23820.801656] cfg80211: Calling CRDA to update world regulatory domain
[23820.833170] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23820.833190] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23820.834560] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23820.906460] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23820.906479] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23820.907641] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23821.911474] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23821.911495] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23821.912689] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23823.221713] wlan0: authenticate with 28:cf:da:ba:6a:10
[23823.221753] wlan0: send auth to 28:cf:da:ba:6a:10 (try 1/3)
[23823.222196] wlan0: authenticated
[23823.223671] wlan0: associate with 28:cf:da:ba:6a:10 (try 1/3)
[23823.224342] wlan0: RX AssocResp from 28:cf:da:ba:6a:10 (capab=0x511 status=0 aid=8)
[23823.224951] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[23823.224965] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[23823.224974] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[23823.224994] wlan0: associated
[23823.225046] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[23823.287070] wlan0: Limiting TX power to 30 (30 - 0) dBm as advertised by 28:cf:da:ba:6a:10
[23829.155121] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[23830.241155] wlan0: deauthenticating from 28:cf:da:ba:6a:10 by local choice (reason=3)
[23830.256137] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[23830.256146] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[23830.256147] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23830.256746] cfg80211: Calling CRDA to update world regulatory domain
[23834.152305] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23834.152316] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[23834.153362] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23838.165254] wlan0: authenticate with 28:cf:da:ba:6a:10
[23838.165779] wlan0: send auth to 28:cf:da:ba:6a:10 (try 1/3)
[23838.215573] wlan0: authenticated
[23838.217053] wlan0: associate with 28:cf:da:ba:6a:10 (try 1/3)
[23838.217880] wlan0: RX AssocResp from 28:cf:da:ba:6a:10 (capab=0x511 status=0 aid=8)
[23838.218415] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[23838.218425] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[23838.218431] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[23838.218446] wlan0: associated
[23838.218499] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[23838.316650] wlan0: Limiting TX power to 30 (30 - 0) dBm as advertised by 28:cf:da:ba:6a:10
[23844.913474] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[24374.644759] ieee80211 phy0: START: tid 1 is not agg'able
[24824.703559] ieee80211 phy0: START: tid 2 is not agg'able
[25304.262037] PM: Syncing filesystems ... done.
[25304.639172] PM: Preparing system for mem sleep
[25304.722882] Freezing user space processes ... (elapsed 0.01 seconds) done.
[25304.735862] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[25304.749174] PM: Entering mem sleep
[25304.749241] Suspending console(s) (use no_console_suspend to debug)
[25304.798216] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[25304.798335] sd 0:0:0:0: [sda] Stopping disk
[25306.433105] PM: suspend of devices complete after 1646.187 msecs
[25306.433580] PM: late suspend of devices complete after 0.470 msecs
[25306.446744] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[25306.459884] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[25306.486347] PM: noirq suspend of devices complete after 52.841 msecs
[25306.487222] ACPI: Preparing to enter system sleep state S3
[25306.512955] PM: Saving platform NVS memory
[25306.513671] Disabling non-boot CPUs ...
[25306.616010] smpboot: CPU 1 is now offline
[25306.719169] smpboot: CPU 2 is now offline
[25306.822349] smpboot: CPU 3 is now offline
[25306.822908] Extended CMOS year: 2000
[25306.825016] ACPI: Low-level resume complete
[25306.825058] PM: Restoring platform NVS memory
[25306.825357] Extended CMOS year: 2000
[25306.825420] Enabling non-boot CPUs ...
[25306.828861] smpboot: Booting Node 0 Processor 1 APIC 0x2
[25306.843244] CPU1 is up
[25306.846636] smpboot: Booting Node 0 Processor 2 APIC 0x1
[25306.860286] CPU2 is up
[25306.860743] smpboot: Booting Node 0 Processor 3 APIC 0x3
[25306.875115] CPU3 is up
[25306.879992] ACPI: Waking up from system sleep state S3
[25307.420618] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[25307.434041] pcieport 0000:00:1c.1: power state changed by ACPI to D0
[25307.447235] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[25307.474231] PM: noirq resume of devices complete after 93.675 msecs
[25307.474614] PM: early resume of devices complete after 0.341 msecs
[25307.474683] i915 0000:00:02.0: setting latency timer to 64
[25307.474758] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[25307.474827] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[25307.474852] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[25307.474879] usb usb3: root hub lost power or was reset
[25307.474914] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[25307.474945] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[25307.474946] usb usb4: root hub lost power or was reset
[25307.474973] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[25307.474979] ata_piix 0000:00:1f.2: setting latency timer to 64
[25307.475633] mei 0000:00:16.0: wd: failed to find the client
[25307.527019] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake old ack to clear.
[25307.528256] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[25308.495658] ata2.00: failed to resume link (SControl 0)
[25308.815129] ata1.01: failed to resume link (SControl 0)
[25308.968335] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[25308.968353] ata1.01: SATA link down (SStatus 0 SControl 0)
[25308.975247] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[25308.982014] ata1.00: configured for UDMA/133
[25309.016545] sd 0:0:0:0: [sda] Starting disk
[25309.517360] ata2.01: failed to resume link (SControl 0)
[25309.529248] ata2.00: SATA link down (SStatus 4 SControl 0)
[25309.529270] ata2.01: SATA link down (SStatus 0 SControl 0)
[25309.546499] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[25309.547503] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[25309.547505] ieee80211 phy0: changing basic rates failed: -22
[25309.547507] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: threshold 0, hys 0  (implement)
[25309.547508] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[25309.547508] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[25309.547737] PM: resume of devices complete after 2076.345 msecs
[25309.549222] PM: Finishing wakeup.
[25309.549226] Restarting tasks ... done.
[25309.579724] video LNXVIDEO:00: Restoring backlight state
[25309.597205] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[25309.597214] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[25309.597216] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[25309.627145] cfg80211: Calling CRDA for country: CH
[25313.615285] wlan0: authenticate with 28:cf:da:ba:6a:10
[25313.616344] wlan0: send auth to 28:cf:da:ba:6a:10 (try 1/3)
[25313.666001] wlan0: authenticated
[25313.667674] wlan0: associate with 28:cf:da:ba:6a:10 (try 1/3)
[25313.668433] wlan0: RX AssocResp from 28:cf:da:ba:6a:10 (capab=0x511 status=0 aid=8)
[25313.668943] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[25313.668952] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[25313.668958] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[25313.668973] wlan0: associated
[25313.767975] wlan0: Limiting TX power to 30 (30 - 0) dBm as advertised by 28:cf:da:ba:6a:10
[25318.886422] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[27105.979948] PM: Syncing filesystems ... done.
[27108.050987] PM: Preparing system for mem sleep
[27108.116639] Freezing user space processes ... (elapsed 0.01 seconds) done.
[27108.128686] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[27108.142148] PM: Entering mem sleep
[27108.142197] Suspending console(s) (use no_console_suspend to debug)
[27108.191278] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[27108.191425] sd 0:0:0:0: [sda] Stopping disk
[27109.692913] PM: suspend of devices complete after 1512.860 msecs
[27109.693392] PM: late suspend of devices complete after 0.474 msecs
[27109.706592] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[27109.719732] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[27109.746198] PM: noirq suspend of devices complete after 52.881 msecs
[27109.747073] ACPI: Preparing to enter system sleep state S3
[27109.772803] PM: Saving platform NVS memory
[27109.773515] Disabling non-boot CPUs ...
[27109.875881] smpboot: CPU 1 is now offline
[27109.979020] smpboot: CPU 2 is now offline
[27110.082195] smpboot: CPU 3 is now offline
[27110.082806] Extended CMOS year: 2000
[27110.084908] ACPI: Low-level resume complete
[27110.084949] PM: Restoring platform NVS memory
[27110.085251] Extended CMOS year: 2000
[27110.085314] Enabling non-boot CPUs ...
[27110.088755] smpboot: Booting Node 0 Processor 1 APIC 0x2
[27110.103128] CPU1 is up
[27110.106520] smpboot: Booting Node 0 Processor 2 APIC 0x1
[27110.120165] CPU2 is up
[27110.120619] smpboot: Booting Node 0 Processor 3 APIC 0x3
[27110.134941] CPU3 is up
[27110.139815] ACPI: Waking up from system sleep state S3
[27110.680467] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[27110.693890] pcieport 0000:00:1c.1: power state changed by ACPI to D0
[27110.707081] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[27110.734082] PM: noirq resume of devices complete after 93.669 msecs
[27110.734480] PM: early resume of devices complete after 0.355 msecs
[27110.734539] i915 0000:00:02.0: setting latency timer to 64
[27110.734620] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[27110.734697] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[27110.734703] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[27110.734752] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[27110.734757] usb usb3: root hub lost power or was reset
[27110.734776] ata_piix 0000:00:1f.2: setting latency timer to 64
[27110.734787] usb usb4: root hub lost power or was reset
[27110.734820] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[27110.736859] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[27110.737577] mei 0000:00:16.0: wd: failed to find the client
[27110.790194] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake old ack to clear.
[27110.791651] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[27110.807021] bcm5974: bad trackpad package, length: 8
[27110.809015] bcm5974: bad trackpad package, length: 8
[27110.810010] bcm5974: bad trackpad package, length: 8
[27111.755500] ata2.00: failed to resume link (SControl 0)
[27112.075007] ata1.01: failed to resume link (SControl 0)
[27112.228181] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[27112.228199] ata1.01: SATA link down (SStatus 0 SControl 0)
[27112.235082] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[27112.241853] ata1.00: configured for UDMA/133
[27112.310445] sd 0:0:0:0: [sda] Starting disk
[27112.777243] ata2.01: failed to resume link (SControl 0)
[27112.789123] ata2.00: SATA link down (SStatus 4 SControl 0)
[27112.789145] ata2.01: SATA link down (SStatus 0 SControl 0)
[27112.805589] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[27112.806626] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[27112.806632] ieee80211 phy0: changing basic rates failed: -22
[27112.806637] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: threshold 0, hys 0  (implement)
[27112.806641] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[27112.806644] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[27112.807014] PM: resume of devices complete after 2075.754 msecs
[27112.808529] PM: Finishing wakeup.
[27112.808533] Restarting tasks ... done.
[27112.863448] video LNXVIDEO:00: Restoring backlight state
[27112.873636] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[27112.873646] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[27112.873649] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[27112.923581] cfg80211: Calling CRDA to update world regulatory domain
[27116.906125] wlan0: authenticate with 0c:b0:5d:9c:37:12
[27116.917556] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[27116.919429] wlan0: authenticated
[27116.920688] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[27116.924294] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=0x411 status=0 aid=1)
[27116.924976] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[27116.924993] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[27116.925003] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[27116.925024] wlan0: associated
[27122.016632] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[27714.482569] wlan0: deauthenticated from 0c:b0:5d:9c:37:12 (Reason: 2)
[27714.493247] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[27714.493265] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[27714.493271] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[27714.496426] cfg80211: Calling CRDA for country: CH
[27718.467235] wlan0: authenticate with 0c:b0:5d:9c:37:12
[27718.477519] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[27718.480567] wlan0: authenticated
[27718.483922] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[27718.488742] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=0x411 status=0 aid=1)
[27718.489433] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[27718.489443] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[27718.489449] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[27718.489527] wlan0: associated
[27723.938669] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[27830.435797] wlan0: deauthenticating from 0c:b0:5d:9c:37:12 by local choice (reason=3)
[27830.455786] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[27830.455808] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[27830.455817] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[27830.456370] cfg80211: Calling CRDA to update world regulatory domain
[27830.456648] wlan0: authenticate with 0c:b0:5d:9c:37:12
[27830.456662] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[27830.458486] wlan0: authenticated
[27830.459062] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[27830.462579] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=0x411 status=0 aid=1)
[27830.463081] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[27830.463087] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[27830.463090] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[27830.463097] wlan0: associated
[27835.355279] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[28159.216857] fuse init (API version 7.20)
[28611.845710] EXT4-fs (sda4): re-mounted. Opts: commit=0
[29550.385092] hda-intel: Unstable LPIB (131064 >= 8192); disabling LPIB delay counting
[34023.488176] ------------[ cut here ]------------
[34023.488189] WARNING: at drivers/net/wireless/brcm80211/brcmsmac/main.c:7997 brcms_c_wait_for_tx_completion+0x99/0xb0 [brcmsmac]()
[34023.488191] Hardware name: MacBookAir4,2
[34023.488192] Modules linked in: fuse ext4 jbd2 mbcache snd_hda_codec_hdmi snd_hda_codec_cirrus sha256_generic arc4 brcmsmac cordic brcmutil mac80211 btusb cfg80211 bluetooth rfkill uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core hid_generic snd_hda_intel crc16 joydev applesmc videodev iTCO_wdt bcm5974 coretemp iTCO_vendor_support media snd_hda_codec i915 acpi_cpufreq intel_agp intel_gtt drm_kms_helper drm i2c_algo_bit lpc_ich mei i2c_i801 i2c_core bcma mperf apple_bl input_polldev snd_hwdep evdev pcspkr video battery ac button microcode processor snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_timer snd soundcore kvm_intel kvm nfs lockd sunrpc fscache jfs dm_crypt dm_mod sd_mod hid_apple ata_generic pata_acpi usb_storage usbhid hid uhci_hcd crc32c_intel ghash_clmulni_intel aesni_intel
[34023.488241]  aes_x86_64 ablk_helper cryptd xts lrw gf128mul ata_piix libata scsi_mod ehci_hcd usbcore usb_common
[34023.488249] Pid: 27380, comm: kworker/u:1 Tainted: G        W    3.7.9-1-ARCH #1
[34023.488251] Call Trace:
[34023.488255]  [<ffffffff8105756f>] warn_slowpath_common+0x7f/0xc0
[34023.488257]  [<ffffffff810575ca>] warn_slowpath_null+0x1a/0x20
[34023.488262]  [<ffffffffa06f7d19>] brcms_c_wait_for_tx_completion+0x99/0xb0 [brcmsmac]
[34023.488264]  [<ffffffffa06ea1ab>] brcms_ops_flush+0x3b/0x60 [brcmsmac]
[34023.488271]  [<ffffffffa066b528>] ieee80211_scan_work+0x318/0x610 [mac80211]
[34023.488274]  [<ffffffff81075e52>] process_one_work+0x132/0x4f0
[34023.488279]  [<ffffffffa066b210>] ? ieee80211_run_deferred_scan+0x90/0x90 [mac80211]
[34023.488281]  [<ffffffff810765ed>] worker_thread+0x15d/0x400
[34023.488283]  [<ffffffff81076490>] ? rescuer_thread+0x240/0x240
[34023.488285]  [<ffffffff8107b1b0>] kthread+0xc0/0xd0
[34023.488288]  [<ffffffff81010000>] ? perf_trace_xen_mmu_set_pte_at+0xb0/0x100
[34023.488290]  [<ffffffff8107b0f0>] ? kthread_freezable_should_stop+0x70/0x70
[34023.488293]  [<ffffffff814c35ac>] ret_from_fork+0x7c/0xb0
[34023.488296]  [<ffffffff8107b0f0>] ? kthread_freezable_should_stop+0x70/0x70
[34023.488297] ---[ end trace 062d4264ec211136 ]---
[34034.138445] wlan0: deauthenticating from 0c:b0:5d:9c:37:12 by local choice (reason=3)
[34034.148192] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[34034.148202] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[34034.148205] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[34034.149933] cfg80211: Calling CRDA to update world regulatory domain
[34034.150337] wlan0: authenticate with 0c:b0:5d:9c:37:12
[34034.150353] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[34034.152362] wlan0: authenticated
[34034.154802] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[34034.158077] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=0x411 status=0 aid=1)
[34034.158860] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[34034.158865] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[34034.158867] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[34034.158872] wlan0: associated
[34039.829661] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[46967.780399] ieee80211 phy0: START: tid 2 is not agg'able
[47088.339236] ieee80211 phy0: START: tid 1 is not agg'able
[47105.246427] usb 2-1.2: new high-speed USB device number 4 using ehci_hcd
[47105.345629] scsi3 : usb-storage 2-1.2:1.0
[47106.345669] scsi 3:0:0:0: Direct-Access     WD       Elements 1023    2005 PQ: 0 ANSI: 4
[47106.347081] sd 3:0:0:0: [sdc] 976769024 512-byte logical blocks: (500 GB/465 GiB)
[47106.348509] sd 3:0:0:0: [sdc] Test WP failed, assume Write Enabled
[47106.350275] sd 3:0:0:0: [sdc] Asking for cache data failed
[47106.350288] sd 3:0:0:0: [sdc] Assuming drive cache: write through
[47106.358749] sd 3:0:0:0: [sdc] Test WP failed, assume Write Enabled
[47106.359656] sd 3:0:0:0: [sdc] Asking for cache data failed
[47106.359667] sd 3:0:0:0: [sdc] Assuming drive cache: write through
[47106.396745]  sdc: unknown partition table
[47106.399196] sd 3:0:0:0: [sdc] Test WP failed, assume Write Enabled
[47106.400294] sd 3:0:0:0: [sdc] Asking for cache data failed
[47106.400303] sd 3:0:0:0: [sdc] Assuming drive cache: write through
[47106.400310] sd 3:0:0:0: [sdc] Attached SCSI disk
[47128.361135] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[47128.363326] XFS (dm-2): Mounting Filesystem
[47128.752075] XFS (dm-2): Ending clean mount
[66954.212561] ieee80211 phy0: START: tid 1 is not agg'able
[72946.821277] ieee80211 phy0: START: tid 1 is not agg'able
[75343.841724] ieee80211 phy0: START: tid 1 is not agg'able
[76514.973958] ieee80211 phy0: START: tid 1 is not agg'able
[76583.893217] ieee80211 phy0: START: tid 1 is not agg'able
[76744.299854] ieee80211 phy0: START: tid 1 is not agg'able
[77062.084973] ieee80211 phy0: START: tid 1 is not agg'able
[77088.462993] usb 2-1.2: USB disconnect, device number 4
[77089.666343] EXT4-fs (sda4): re-mounted. Opts: commit=600
[77090.153063] PM: Syncing filesystems ... done.
[77090.226861] PM: Preparing system for mem sleep
[77090.326520] Freezing user space processes ... (elapsed 0.02 seconds) done.
[77090.350947] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[77090.364224] PM: Entering mem sleep
[77090.364286] Suspending console(s) (use no_console_suspend to debug)
[77090.413135] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[77090.414398] sd 0:0:0:0: [sda] Stopping disk
[77091.515636] ------------[ cut here ]------------
[77091.515674] WARNING: at drivers/gpu/drm/i915/intel_dp.c:1908 intel_dp_link_down+0x1d2/0x1e0 [i915]()
[77091.515675] Hardware name: MacBookAir4,2
[77091.515764] Modules linked in: xfs fuse ext4 jbd2 mbcache snd_hda_codec_hdmi snd_hda_codec_cirrus sha256_generic arc4 brcmsmac cordic brcmutil mac80211 btusb cfg80211 bluetooth rfkill uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core hid_generic snd_hda_intel crc16 joydev applesmc videodev iTCO_wdt bcm5974 coretemp iTCO_vendor_support media snd_hda_codec i915 acpi_cpufreq intel_agp intel_gtt drm_kms_helper drm i2c_algo_bit lpc_ich mei i2c_i801 i2c_core bcma mperf apple_bl input_polldev snd_hwdep evdev pcspkr video battery ac button microcode processor snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_timer snd soundcore kvm_intel kvm nfs lockd sunrpc fscache jfs dm_crypt dm_mod sd_mod hid_apple ata_generic pata_acpi usb_storage usbhid hid uhci_hcd crc32c_intel ghash_clmulni_intel aesni_intel
[77091.515779]  aes_x86_64 ablk_helper cryptd xts lrw gf128mul ata_piix libata scsi_mod ehci_hcd usbcore usb_common
[77091.515784] Pid: 3875, comm: kworker/u:19 Tainted: G        W    3.7.9-1-ARCH #1
[77091.515786] Call Trace:
[77091.515796]  [<ffffffff8105756f>] warn_slowpath_common+0x7f/0xc0
[77091.515801]  [<ffffffff810575ca>] warn_slowpath_null+0x1a/0x20
[77091.515819]  [<ffffffffa04b43f2>] intel_dp_link_down+0x1d2/0x1e0 [i915]
[77091.515835]  [<ffffffffa04b6594>] intel_disable_dp+0x44/0x170 [i915]
[77091.515853]  [<ffffffffa04a527e>] ironlake_crtc_disable+0x68e/0x820 [i915]
[77091.515869]  [<ffffffffa04a9084>] intel_crtc_disable+0x34/0x130 [i915]
[77091.515885]  [<ffffffffa04aa383>] intel_modeset_disable+0x43/0x60 [i915]
[77091.515897]  [<ffffffffa047d05b>] i915_drm_freeze+0x5b/0xd0 [i915]
[77091.515909]  [<ffffffffa047d2e6>] i915_pm_suspend+0x46/0xa0 [i915]
[77091.515920]  [<ffffffff81295ab0>] pci_pm_suspend+0x70/0x140
[77091.515926]  [<ffffffff81492b65>] ? klist_next+0x85/0x100
[77091.515933]  [<ffffffff81295a40>] ? pci_pm_poweroff+0xe0/0xe0
[77091.515940]  [<ffffffff8134bdb8>] dpm_run_callback+0x58/0x90
[77091.515947]  [<ffffffff8134bedb>] __device_suspend+0xeb/0x280
[77091.515953]  [<ffffffff8134c08f>] async_suspend+0x1f/0xa0
[77091.515961]  [<ffffffff810831da>] async_run_entry_fn+0xaa/0x1c0
[77091.515967]  [<ffffffff81075e52>] process_one_work+0x132/0x4f0
[77091.515971]  [<ffffffff8107526a>] ? manage_workers+0x1ea/0x290
[77091.515977]  [<ffffffff81083130>] ? async_schedule+0x20/0x20
[77091.515982]  [<ffffffff810765ed>] worker_thread+0x15d/0x400
[77091.515987]  [<ffffffff81076490>] ? rescuer_thread+0x240/0x240
[77091.515994]  [<ffffffff8107b1b0>] kthread+0xc0/0xd0
[77091.516000]  [<ffffffff81010000>] ? perf_trace_xen_mmu_set_pte_at+0xb0/0x100
[77091.516007]  [<ffffffff8107b0f0>] ? kthread_freezable_should_stop+0x70/0x70
[77091.516014]  [<ffffffff814c35ac>] ret_from_fork+0x7c/0xb0
[77091.516020]  [<ffffffff8107b0f0>] ? kthread_freezable_should_stop+0x70/0x70
[77091.516024] ---[ end trace 062d4264ec211137 ]---
[77091.798549] PM: suspend of devices complete after 1396.153 msecs
[77091.799029] PM: late suspend of devices complete after 0.475 msecs
[77091.812210] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[77091.825344] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[77091.851808] PM: noirq suspend of devices complete after 52.857 msecs
[77091.852683] ACPI: Preparing to enter system sleep state S3
[77091.878409] PM: Saving platform NVS memory
[77091.879149] Disabling non-boot CPUs ...
[77091.981461] smpboot: CPU 1 is now offline
[77092.084631] smpboot: CPU 2 is now offline
[77092.187806] smpboot: CPU 3 is now offline
[77092.188591] Extended CMOS year: 2000
[77092.190698] ACPI: Low-level resume complete
[77092.190740] PM: Restoring platform NVS memory
[77092.191040] Extended CMOS year: 2000
[77092.191103] Enabling non-boot CPUs ...
[77092.194544] smpboot: Booting Node 0 Processor 1 APIC 0x2
[77092.208775] CPU1 is up
[77092.212166] smpboot: Booting Node 0 Processor 2 APIC 0x1
[77092.225785] CPU2 is up
[77092.226255] smpboot: Booting Node 0 Processor 3 APIC 0x3
[77092.240495] CPU3 is up
[77092.245373] ACPI: Waking up from system sleep state S3
[77092.789411] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[77092.802827] pcieport 0000:00:1c.1: power state changed by ACPI to D0
[77092.816028] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[77092.843025] PM: noirq resume of devices complete after 93.673 msecs
[77092.843424] PM: early resume of devices complete after 0.355 msecs
[77092.843480] i915 0000:00:02.0: setting latency timer to 64
[77092.843517] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[77092.843566] usb usb3: root hub lost power or was reset
[77092.843569] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[77092.843588] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[77092.843622] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[77092.843652] usb usb4: root hub lost power or was reset
[77092.843673] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[77092.843675] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[77092.843701] ata_piix 0000:00:1f.2: setting latency timer to 64
[77092.844392] mei 0000:00:16.0: wd: failed to find the client
[77092.899138] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake old ack to clear.
[77092.900433] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[77092.917914] bcm5974: bad trackpad package, length: 8
[77092.967864] Extended CMOS year: 2000
[77093.864442] ata2.00: failed to resume link (SControl 0)
[77094.183944] ata1.01: failed to resume link (SControl 0)
[77094.337053] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[77094.337063] ata1.01: SATA link down (SStatus 0 SControl 0)
[77094.343942] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[77094.350794] ata1.00: configured for UDMA/133
[77094.386813] sd 0:0:0:0: [sda] Starting disk
[77094.886154] ata2.01: failed to resume link (SControl 0)
[77094.899403] ata2.00: SATA link down (SStatus 4 SControl 0)
[77094.899417] ata2.01: SATA link down (SStatus 0 SControl 0)
[77094.915803] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[77094.916834] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[77094.916836] ieee80211 phy0: changing basic rates failed: -22
[77094.916837] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: threshold 0, hys 0  (implement)
[77094.916838] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[77094.916839] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[77094.917066] PM: resume of devices complete after 2076.855 msecs
[77094.918599] PM: Finishing wakeup.
[77094.918603] Restarting tasks ... done.
[77094.974068] video LNXVIDEO:00: Restoring backlight state
[77095.059240] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[77095.059246] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[77095.059248] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[77095.059714] cfg80211: Calling CRDA for country: CH
[77098.633144] EXT4-fs (sda4): re-mounted. Opts: commit=0
[77100.379661] wlan0: authenticate with d4:a0:2a:98:a6:af
[77100.396854] wlan0: direct probe to d4:a0:2a:98:a6:af (try 1/3)
[77100.597220] wlan0: direct probe to d4:a0:2a:98:a6:af (try 2/3)
[77100.800236] wlan0: send auth to d4:a0:2a:98:a6:af (try 3/3)
[77100.801252] wlan0: authenticated
[77100.803621] wlan0: associate with d4:a0:2a:98:a6:af (try 1/3)
[77100.805508] wlan0: RX AssocResp from d4:a0:2a:98:a6:af (capab=0x11 status=0 aid=68)
[77100.806130] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[77100.806145] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[77100.806154] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[77100.806325] wlan0: associated
[77105.929405] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[77120.726229] wlan0: deauthenticated from d4:a0:2a:98:a6:af (Reason: 2)
[77120.755920] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[77120.755942] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[77120.755948] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[77120.756659] cfg80211: Calling CRDA to update world regulatory domain
[77124.737775] wlan0: authenticate with d4:a0:2a:98:b8:cf
[77124.742324] wlan0: direct probe to d4:a0:2a:98:b8:cf (try 1/3)
[77124.942623] wlan0: send auth to d4:a0:2a:98:b8:cf (try 2/3)
[77124.943349] wlan0: authenticated
[77124.945989] wlan0: associate with d4:a0:2a:98:b8:cf (try 1/3)
[77124.947852] wlan0: RX AssocResp from d4:a0:2a:98:b8:cf (capab=0x11 status=0 aid=7)
[77124.948359] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[77124.948369] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[77124.948377] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[77124.948497] wlan0: associated
[77130.501150] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[77210.173374] ieee80211 phy0: START: tid 1 is not agg'able
[77846.295668] ieee80211 phy0: START: tid 2 is not agg'able
[77929.469445] ieee80211 phy0: START: tid 1 is not agg'able
[80202.150694] wlan0: deauthenticating from d4:a0:2a:98:b8:cf by local choice (reason=3)
[80202.161141] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[80202.161161] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[80202.161167] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[80202.162353] cfg80211: Calling CRDA for country: CH
[80205.694496] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[80205.694518] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[80205.695731] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[80205.739074] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[80205.739085] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[80205.740107] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[80214.875488] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[80214.875510] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[80214.876672] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[80214.922912] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[80214.922933] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[80214.924059] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[80217.202417] wlan0: authenticate with d4:a0:2a:98:a6:af
[80217.204786] wlan0: send auth to d4:a0:2a:98:a6:af (try 1/3)
[80217.205401] wlan0: authenticated
[80217.207420] wlan0: associate with d4:a0:2a:98:a6:af (try 1/3)
[80217.209222] wlan0: RX AssocResp from d4:a0:2a:98:a6:af (capab=0x11 status=0 aid=72)
[80217.209831] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[80217.209844] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[80217.209854] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[80217.209884] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[80217.210027] wlan0: associated
[80223.384899] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[80606.580910] ieee80211 phy0: START: tid 1 is not agg'able
[80802.938436] ieee80211 phy0: START: tid 2 is not agg'able
[81508.525894] ieee80211 phy0: START: tid 1 is not agg'able
[81566.758508] ieee80211 phy0: START: tid 1 is not agg'able
[81613.913551] ieee80211 phy0: START: tid 1 is not agg'able
[81807.104105] ieee80211 phy0: START: tid 2 is not agg'able
[81909.635303] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[81909.719045] wlan0: deauthenticating from d4:a0:2a:98:a6:af by local choice (reason=3)
[81909.743965] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[81909.743976] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[81909.743979] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[81909.747999] cfg80211: Calling CRDA to update world regulatory domain
[81909.779213] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[81909.779225] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[81909.780254] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[81909.859353] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[81909.859367] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[81909.860408] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[81912.071282] wlan0: authenticate with d4:a0:2a:98:a6:af
[81912.071336] wlan0: send auth to d4:a0:2a:98:a6:af (try 1/3)
[81912.075994] wlan0: authenticated
[81912.077028] wlan0: associate with d4:a0:2a:98:a6:af (try 1/3)
[81912.078681] wlan0: RX AssocResp from d4:a0:2a:98:a6:af (capab=0x11 status=0 aid=72)
[81912.079218] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[81912.079230] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[81912.079236] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[81912.079252] wlan0: associated
[81912.079297] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[81918.893655] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[81921.838776] usb 2-1.2: new high-speed USB device number 5 using ehci_hcd
[81922.008513] scsi4 : usb-storage 2-1.2:1.0
[81929.509670] scsi 4:0:0:0: Direct-Access     Samsung  STORY Station 3  1AJ1 PQ: 0 ANSI: 0
[81929.510950] sd 4:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[81929.511875] sd 4:0:0:0: [sdc] Write Protect is off
[81929.511887] sd 4:0:0:0: [sdc] Mode Sense: 23 00 00 00
[81929.512706] sd 4:0:0:0: [sdc] No Caching mode page present
[81929.512718] sd 4:0:0:0: [sdc] Assuming drive cache: write through
[81929.517284] sd 4:0:0:0: [sdc] No Caching mode page present
[81929.517289] sd 4:0:0:0: [sdc] Assuming drive cache: write through
[81929.560074]  sdc: sdc1 sdc2 sdc3 sdc4
[81929.563237] sd 4:0:0:0: [sdc] No Caching mode page present
[81929.563246] sd 4:0:0:0: [sdc] Assuming drive cache: write through
[81929.563253] sd 4:0:0:0: [sdc] Attached SCSI disk
[81948.420561] ieee80211 phy0: START: tid 1 is not agg'able
[82362.602064] ieee80211 phy0: START: tid 1 is not agg'able
[82676.150189] ieee80211 phy0: START: tid 1 is not agg'able
[82960.939379] ieee80211 phy0: START: tid 1 is not agg'able
[83481.717950] ieee80211 phy0: START: tid 1 is not agg'able
[83528.272166] ieee80211 phy0: START: tid 1 is not agg'able
[83718.326046] ieee80211 phy0: START: tid 2 is not agg'able
[83765.043228] ieee80211 phy0: START: tid 2 is not agg'able
[84006.181035] ieee80211 phy0: START: tid 2 is not agg'able
[85160.348873] usb 2-1.2: USB disconnect, device number 5
[85183.085158] EXT4-fs (sda4): re-mounted. Opts: commit=600
[85214.065878] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[85214.065904] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[85214.065910] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[85214.072508] cfg80211: Calling CRDA to update world regulatory domain
[85216.622516] ------------[ cut here ]------------
[85216.622557] WARNING: at drivers/gpu/drm/i915/intel_display.c:6976 intel_modeset_check_state+0x4bb/0x610 [i915]()
[85216.622562] Hardware name: MacBookAir4,2
[85216.622565] encoder's hw state doesn't match sw tracking (expected 1, found 0)
[85216.622568] Modules linked in: xfs fuse ext4 jbd2 mbcache snd_hda_codec_hdmi snd_hda_codec_cirrus sha256_generic arc4 brcmsmac cordic brcmutil mac80211 btusb cfg80211 bluetooth rfkill uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core hid_generic snd_hda_intel crc16 joydev applesmc videodev iTCO_wdt bcm5974 coretemp iTCO_vendor_support media snd_hda_codec i915 acpi_cpufreq intel_agp intel_gtt drm_kms_helper drm i2c_algo_bit lpc_ich mei i2c_i801 i2c_core bcma mperf apple_bl input_polldev snd_hwdep evdev pcspkr video battery ac button microcode processor snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_timer snd soundcore kvm_intel kvm nfs lockd sunrpc fscache jfs dm_crypt dm_mod sd_mod hid_apple ata_generic pata_acpi usb_storage usbhid hid uhci_hcd crc32c_intel ghash_clmulni_intel aesni_intel
[85216.622689]  aes_x86_64 ablk_helper cryptd xts lrw gf128mul ata_piix libata scsi_mod ehci_hcd usbcore usb_common
[85216.622713] Pid: 692, comm: X Tainted: G        W    3.7.9-1-ARCH #1
[85216.622717] Call Trace:
[85216.622730]  [<ffffffff8105756f>] warn_slowpath_common+0x7f/0xc0
[85216.622737]  [<ffffffff81057666>] warn_slowpath_fmt+0x46/0x50
[85216.622759]  [<ffffffffa04ab8db>] intel_modeset_check_state+0x4bb/0x610 [i915]
[85216.622776]  [<ffffffffa04aba74>] intel_connector_dpms+0x44/0x70 [i915]
[85216.622794]  [<ffffffffa03ced3d>] drm_mode_obj_set_property_ioctl+0x32d/0x340 [drm]
[85216.622808]  [<ffffffffa03ced80>] drm_mode_connector_property_set_ioctl+0x30/0x40 [drm]
[85216.622823]  [<ffffffffa03bd3f3>] drm_ioctl+0x4c3/0x570 [drm]
[85216.622838]  [<ffffffffa03ced50>] ? drm_mode_obj_set_property_ioctl+0x340/0x340 [drm]
[85216.622849]  [<ffffffff8112a617>] ? __free_pages+0x57/0x70
[85216.622859]  [<ffffffff8116f67c>] ? kfree+0x2c/0x160
[85216.622867]  [<ffffffff81195e77>] do_vfs_ioctl+0x97/0x530
[85216.622875]  [<ffffffff81185bfe>] ? ____fput+0xe/0x10
[85216.622882]  [<ffffffff811963a1>] sys_ioctl+0x91/0xb0
[85216.622892]  [<ffffffff81015dbc>] ? do_notify_resume+0x9c/0xb0
[85216.622904]  [<ffffffff814c365d>] system_call_fastpath+0x1a/0x1f
[85216.622909] ---[ end trace 062d4264ec211138 ]---
[85216.645069] ------------[ cut here ]------------
[85216.645105] WARNING: at drivers/gpu/drm/i915/intel_dp.c:1908 intel_dp_link_down+0x1d2/0x1e0 [i915]()
[85216.645109] Hardware name: MacBookAir4,2
[85216.645112] Modules linked in: xfs fuse ext4 jbd2 mbcache snd_hda_codec_hdmi snd_hda_codec_cirrus sha256_generic arc4 brcmsmac cordic brcmutil mac80211 btusb cfg80211 bluetooth rfkill uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core hid_generic snd_hda_intel crc16 joydev applesmc videodev iTCO_wdt bcm5974 coretemp iTCO_vendor_support media snd_hda_codec i915 acpi_cpufreq intel_agp intel_gtt drm_kms_helper drm i2c_algo_bit lpc_ich mei i2c_i801 i2c_core bcma mperf apple_bl input_polldev snd_hwdep evdev pcspkr video battery ac button microcode processor snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_timer snd soundcore kvm_intel kvm nfs lockd sunrpc fscache jfs dm_crypt dm_mod sd_mod hid_apple ata_generic pata_acpi usb_storage usbhid hid uhci_hcd crc32c_intel ghash_clmulni_intel aesni_intel
[85216.645230]  aes_x86_64 ablk_helper cryptd xts lrw gf128mul ata_piix libata scsi_mod ehci_hcd usbcore usb_common
[85216.645252] Pid: 692, comm: X Tainted: G        W    3.7.9-1-ARCH #1
[85216.645256] Call Trace:
[85216.645266]  [<ffffffff8105756f>] warn_slowpath_common+0x7f/0xc0
[85216.645274]  [<ffffffff810575ca>] warn_slowpath_null+0x1a/0x20
[85216.645293]  [<ffffffffa04b43f2>] intel_dp_link_down+0x1d2/0x1e0 [i915]
[85216.645311]  [<ffffffffa04b6594>] intel_disable_dp+0x44/0x170 [i915]
[85216.645330]  [<ffffffffa04a527e>] ironlake_crtc_disable+0x68e/0x820 [i915]
[85216.645350]  [<ffffffffa04aa307>] intel_crtc_update_dpms+0x77/0xb0 [i915]
[85216.645368]  [<ffffffffa04aa3fa>] intel_encoder_dpms+0x1a/0x30 [i915]
[85216.645386]  [<ffffffffa04aba6c>] intel_connector_dpms+0x3c/0x70 [i915]
[85216.645403]  [<ffffffffa03ced3d>] drm_mode_obj_set_property_ioctl+0x32d/0x340 [drm]
[85216.645418]  [<ffffffffa03ced80>] drm_mode_connector_property_set_ioctl+0x30/0x40 [drm]
[85216.645432]  [<ffffffffa03bd3f3>] drm_ioctl+0x4c3/0x570 [drm]
[85216.645447]  [<ffffffffa03ced50>] ? drm_mode_obj_set_property_ioctl+0x340/0x340 [drm]
[85216.645457]  [<ffffffff8112a617>] ? __free_pages+0x57/0x70
[85216.645466]  [<ffffffff8116f67c>] ? kfree+0x2c/0x160
[85216.645473]  [<ffffffff81195e77>] do_vfs_ioctl+0x97/0x530
[85216.645480]  [<ffffffff81185bfe>] ? ____fput+0xe/0x10
[85216.645487]  [<ffffffff811963a1>] sys_ioctl+0x91/0xb0
[85216.645496]  [<ffffffff81015dbc>] ? do_notify_resume+0x9c/0xb0
[85216.645506]  [<ffffffff814c365d>] system_call_fastpath+0x1a/0x1f
[85216.645511] ---[ end trace 062d4264ec211139 ]---
[85218.053552] wlan0: authenticate with d4:a0:2a:9a:e7:9f
[85218.054745] wlan0: direct probe to d4:a0:2a:9a:e7:9f (try 1/3)
[85218.255879] wlan0: direct probe to d4:a0:2a:9a:e7:9f (try 2/3)
[85218.458873] wlan0: direct probe to d4:a0:2a:9a:e7:9f (try 3/3)
[85218.661952] wlan0: authentication with d4:a0:2a:9a:e7:9f timed out
[85219.894728] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[85219.894748] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[85219.895914] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[85224.708966] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[85224.708978] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[85224.710071] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[85448.504586] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[85448.504597] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[85448.505636] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[85448.562248] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[85448.562269] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[85448.563366] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[85450.705068] wlan0: authenticate with d4:a0:2a:98:b8:cf
[85450.706963] wlan0: direct probe to d4:a0:2a:98:b8:cf (try 1/3)
[85450.906762] wlan0: send auth to d4:a0:2a:98:b8:cf (try 2/3)
[85450.907462] wlan0: authenticated
[85450.910201] wlan0: associate with d4:a0:2a:98:b8:cf (try 1/3)
[85450.911935] wlan0: RX AssocResp from d4:a0:2a:98:b8:cf (capab=0x11 status=0 aid=3)
[85450.912560] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[85450.912571] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[85450.912577] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[85450.912588] wlan0: associated
[85450.912699] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[85457.330584] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[85925.611458] PM: Syncing filesystems ... done.
[85925.728372] PM: Preparing system for mem sleep
[85926.093717] Freezing user space processes ... (elapsed 0.01 seconds) done.
[85926.106725] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[85926.119995] PM: Entering mem sleep
[85926.120014] Suspending console(s) (use no_console_suspend to debug)
[85926.169246] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[85926.170554] sd 0:0:0:0: [sda] Stopping disk
[85927.674126] PM: suspend of devices complete after 1516.136 msecs
[85927.674601] PM: late suspend of devices complete after 0.470 msecs
[85927.687806] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[85927.700922] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[85927.727395] PM: noirq suspend of devices complete after 52.871 msecs
[85927.728270] ACPI: Preparing to enter system sleep state S3
[85927.754003] PM: Saving platform NVS memory
[85927.754720] Disabling non-boot CPUs ...
[85927.857081] smpboot: CPU 1 is now offline
[85927.960219] smpboot: CPU 2 is now offline
[85928.063394] smpboot: CPU 3 is now offline
[85928.064001] Extended CMOS year: 2000
[85928.066104] ACPI: Low-level resume complete
[85928.066146] PM: Restoring platform NVS memory
[85928.066448] Extended CMOS year: 2000
[85928.066510] Enabling non-boot CPUs ...
[85928.069951] smpboot: Booting Node 0 Processor 1 APIC 0x2
[85928.084344] CPU1 is up
[85928.087733] smpboot: Booting Node 0 Processor 2 APIC 0x1
[85928.101344] CPU2 is up
[85928.101783] smpboot: Booting Node 0 Processor 3 APIC 0x3
[85928.116006] CPU3 is up
[85928.120871] ACPI: Waking up from system sleep state S3
[85928.661665] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[85928.675088] pcieport 0000:00:1c.1: power state changed by ACPI to D0
[85928.688290] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[85928.715286] PM: noirq resume of devices complete after 93.681 msecs
[85928.715672] PM: early resume of devices complete after 0.342 msecs
[85928.715733] i915 0000:00:02.0: setting latency timer to 64
[85928.715810] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[85928.715906] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[85928.715948] usb usb3: root hub lost power or was reset
[85928.715973] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[85928.715999] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[85928.716012] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[85928.716025] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[85928.716034] usb usb4: root hub lost power or was reset
[85928.716047] ata_piix 0000:00:1f.2: setting latency timer to 64
[85928.718856] mei 0000:00:16.0: wd: failed to find the client
[85928.771397] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake old ack to clear.
[85928.772652] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[85928.837590] Extended CMOS year: 2000
[85929.736684] ata2.00: failed to resume link (SControl 0)
[85930.056199] ata1.01: failed to resume link (SControl 0)
[85930.209382] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[85930.209399] ata1.01: SATA link down (SStatus 0 SControl 0)
[85930.216300] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[85930.223068] ata1.00: configured for UDMA/133
[85930.263897] sd 0:0:0:0: [sda] Starting disk
[85930.758447] ata2.01: failed to resume link (SControl 0)
[85930.770327] ata2.00: SATA link down (SStatus 4 SControl 0)
[85930.770349] ata2.01: SATA link down (SStatus 0 SControl 0)
[85930.787274] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[85930.788340] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[85930.788346] ieee80211 phy0: changing basic rates failed: -22
[85930.788351] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: threshold 0, hys 0  (implement)
[85930.788355] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[85930.788358] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[85930.788582] PM: resume of devices complete after 2076.134 msecs
[85930.805973] PM: Finishing wakeup.
[85930.805974] Restarting tasks ... done.
[85930.838210] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[85930.839575] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[85930.840926] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[85930.842877] cfg80211: Calling CRDA for country: CH
[85930.867000] video LNXVIDEO:00: Restoring backlight state
[85930.997615] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[85930.997626] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[85930.998671] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[85935.613985] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[85935.613997] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[85935.615098] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[85939.801038] EXT4-fs (sda4): re-mounted. Opts: commit=0
[85939.951321] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[85939.951331] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[85939.952355] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[85940.010281] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[85940.010302] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[85940.011559] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[85942.282141] wlan0: authenticate with d4:a0:2a:98:a6:af
[85942.283966] wlan0: send auth to d4:a0:2a:98:a6:af (try 1/3)
[85942.284855] wlan0: authenticated
[85942.287027] wlan0: associate with d4:a0:2a:98:a6:af (try 1/3)
[85942.288715] wlan0: RX AssocResp from d4:a0:2a:98:a6:af (capab=0x11 status=0 aid=78)
[85942.289196] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[85942.289199] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[85942.289201] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[85942.289206] wlan0: associated
[85942.289222] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[85948.191590] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[86202.709675] EXT4-fs (sda4): re-mounted. Opts: commit=600
[86886.923309] EXT4-fs (sda4): re-mounted. Opts: commit=0
[87977.007421] ieee80211 phy0: START: tid 2 is not agg'able
[88067.757823] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[88067.956075] wlan0: deauthenticating from d4:a0:2a:98:a6:af by local choice (reason=3)
[88067.965710] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[88067.965731] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[88067.965737] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[88067.970009] cfg80211: Calling CRDA to update world regulatory domain
[88067.988156] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[88067.988167] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[88067.989297] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[88068.055540] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[88068.055561] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[88068.056653] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[88070.286086] wlan0: authenticate with d4:a0:2a:98:a6:af
[88070.286128] wlan0: send auth to d4:a0:2a:98:a6:af (try 1/3)
[88070.290449] wlan0: authenticated
[88070.291883] wlan0: associate with d4:a0:2a:98:a6:af (try 1/3)
[88070.300615] wlan0: RX AssocResp from d4:a0:2a:98:a6:af (capab=0x11 status=0 aid=78)
[88070.301126] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[88070.301137] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[88070.301143] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[88070.301162] wlan0: associated
[88070.301220] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[88077.045201] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[88126.720836] ieee80211 phy0: START: tid 1 is not agg'able
[88307.419093] ieee80211 phy0: START: tid 1 is not agg'able
[88366.840115] ieee80211 phy0: START: tid 1 is not agg'able
[88546.623198] ieee80211 phy0: START: tid 2 is not agg'able
[88906.353853] ieee80211 phy0: START: tid 1 is not agg'able
[89385.679484] ieee80211 phy0: START: tid 1 is not agg'able
[89505.411902] ieee80211 phy0: START: tid 2 is not agg'able
[89565.419534] ieee80211 phy0: START: tid 1 is not agg'able
[89625.276250] ieee80211 phy0: START: tid 2 is not agg'able
[89685.192894] ieee80211 phy0: START: tid 2 is not agg'able
[89745.189444] ieee80211 phy0: START: tid 1 is not agg'able
[90044.869637] ieee80211 phy0: START: tid 1 is not agg'able
[90164.719648] ieee80211 phy0: START: tid 1 is not agg'able
[90344.472771] ieee80211 phy0: START: tid 1 is not agg'able
[90404.372877] ieee80211 phy0: START: tid 1 is not agg'able
[90524.415860] ieee80211 phy0: START: tid 2 is not agg'able
[90584.161818] ieee80211 phy0: START: tid 1 is not agg'able
[90704.159166] ieee80211 phy0: START: tid 2 is not agg'able
[90763.945985] ieee80211 phy0: START: tid 1 is not agg'able
[90823.892619] ieee80211 phy0: START: tid 1 is not agg'able
[90883.376635] ieee80211 phy0: START: tid 1 is not agg'able
[91003.669151] ieee80211 phy0: START: tid 1 is not agg'able
[91063.622160] ieee80211 phy0: START: tid 1 is not agg'able
[91123.522400] ieee80211 phy0: START: tid 2 is not agg'able
[91183.009882] ieee80211 phy0: START: tid 1 is not agg'able
[91303.289544] ieee80211 phy0: START: tid 1 is not agg'able
[91423.175653] ieee80211 phy0: START: tid 1 is not agg'able
[91483.072404] ieee80211 phy0: START: tid 2 is not agg'able
[91602.968838] ieee80211 phy0: START: tid 1 is not agg'able
[91663.793896] ieee80211 phy0: START: tid 1 is not agg'able
[91722.818413] ieee80211 phy0: START: tid 1 is not agg'able
[91902.552192] ieee80211 phy0: START: tid 1 is not agg'able
[91962.585327] ieee80211 phy0: START: tid 2 is not agg'able
[92082.345316] ieee80211 phy0: START: tid 1 is not agg'able
[92262.118656] ieee80211 phy0: START: tid 1 is not agg'able
[92502.098228] ieee80211 phy0: START: tid 2 is not agg'able
[92506.042910] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[92506.343786] wlan0: deauthenticating from d4:a0:2a:98:a6:af by local choice (reason=3)
[92506.358264] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[92506.358284] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[92506.358290] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[92506.359073] cfg80211: Calling CRDA to update world regulatory domain
[92506.382554] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[92506.382568] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[92506.383705] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[92506.448767] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[92506.448783] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[92506.449843] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[92508.725187] wlan0: authenticate with d4:a0:2a:98:a6:af
[92508.725231] wlan0: send auth to d4:a0:2a:98:a6:af (try 1/3)
[92508.726241] wlan0: authenticated
[92508.727681] wlan0: associate with d4:a0:2a:98:a6:af (try 1/3)
[92508.729385] wlan0: RX AssocResp from d4:a0:2a:98:a6:af (capab=0x11 status=0 aid=78)
[92508.730028] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[92508.730038] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[92508.730044] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[92508.730056] wlan0: associated
[92508.730401] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[92514.848494] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[92630.844141] ieee80211 phy0: START: tid 1 is not agg'able
[92741.664943] ieee80211 phy0: START: tid 2 is not agg'able
[92801.559647] ieee80211 phy0: START: tid 2 is not agg'able
[93101.144956] ieee80211 phy0: START: tid 2 is not agg'able
[93280.904931] ieee80211 phy0: START: tid 2 is not agg'able
[93580.554442] ieee80211 phy0: START: tid 2 is not agg'able
[93740.336774] ieee80211 phy0: START: tid 2 is not agg'able
[93850.162277] ieee80211 phy0: START: tid 1 is not agg'able
[94328.300526] CPU1: Core temperature above threshold, cpu clock throttled (total events = 1215)
[94328.300527] CPU3: Core temperature above threshold, cpu clock throttled (total events = 1215)
[94328.300530] CPU2: Package temperature above threshold, cpu clock throttled (total events = 1696)
[94328.300532] CPU0: Package temperature above threshold, cpu clock throttled (total events = 1696)
[94328.300533] CPU3: Package temperature above threshold, cpu clock throttled (total events = 1696)
[94328.300542] CPU1: Package temperature above threshold, cpu clock throttled (total events = 1696)
[94328.301496] CPU3: Core temperature/speed normal
[94328.301497] CPU1: Core temperature/speed normal
[94328.301498] CPU2: Package temperature/speed normal
[94328.301500] CPU0: Package temperature/speed normal
[94328.301500] CPU1: Package temperature/speed normal
[94328.301507] CPU3: Package temperature/speed normal
[94353.880734] mce: [Hardware Error]: Machine check events logged
[94467.797154] ieee80211 phy0: START: tid 1 is not agg'able
[94627.949592] CPU1: Core temperature above threshold, cpu clock throttled (total events = 14975)
[94627.949593] CPU3: Core temperature above threshold, cpu clock throttled (total events = 14975)
[94627.949596] CPU0: Package temperature above threshold, cpu clock throttled (total events = 17744)
[94627.949597] CPU2: Package temperature above threshold, cpu clock throttled (total events = 17744)
[94627.949599] CPU3: Package temperature above threshold, cpu clock throttled (total events = 17744)
[94627.949607] CPU1: Package temperature above threshold, cpu clock throttled (total events = 17744)
[94627.950567] CPU3: Core temperature/speed normal
[94627.950568] CPU1: Core temperature/speed normal
[94627.950570] CPU0: Package temperature/speed normal
[94627.950571] CPU2: Package temperature/speed normal
[94627.950572] CPU1: Package temperature/speed normal
[94627.950578] CPU3: Package temperature/speed normal
[94632.216899] systemd-journald[176]: File /var/log/journal/430f5d56a9288edc7eca1b05000004e3/user-1000.journal corrupted or uncleanly shut down, renaming and replacing.
[94757.891355] ieee80211 phy0: START: tid 2 is not agg'able
[94803.180779] mce: [Hardware Error]: Machine check events logged
[94932.567883] CPU0: Package temperature above threshold, cpu clock throttled (total events = 25297)
[94932.567886] CPU1: Core temperature above threshold, cpu clock throttled (total events = 21230)
[94932.567887] CPU3: Core temperature above threshold, cpu clock throttled (total events = 21230)
[94932.567889] CPU2: Package temperature above threshold, cpu clock throttled (total events = 25297)
[94932.567890] CPU1: Package temperature above threshold, cpu clock throttled (total events = 25297)
[94932.567891] CPU3: Package temperature above threshold, cpu clock throttled (total events = 25297)
[94932.568839] CPU1: Core temperature/speed normal
[94932.568840] CPU2: Package temperature/speed normal
[94932.568841] CPU0: Package temperature/speed normal
[94932.568843] CPU3: Core temperature/speed normal
[94932.568845] CPU3: Package temperature/speed normal
[94932.568849] CPU1: Package temperature/speed normal
[94952.947461] mce: [Hardware Error]: Machine check events logged
[95036.880052] ieee80211 phy0: START: tid 1 is not agg'able
[95131.349634] ieee80211 phy0: START: tid 1 is not agg'able
[95192.158147] ieee80211 phy0: START: tid 1 is not agg'able
[95311.039619] ieee80211 phy0: START: tid 1 is not agg'able
[95432.923060] ieee80211 phy0: START: tid 1 is not agg'able
[95621.789146] ieee80211 phy0: START: tid 1 is not agg'able
[95670.684611] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[95670.883790] wlan0: deauthenticating from d4:a0:2a:98:a6:af by local choice (reason=3)
[95670.925622] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[95670.925631] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[95670.925635] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[95670.926209] cfg80211: Calling CRDA for country: CH
[95671.016421] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[95671.016435] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[95671.017499] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[95671.243303] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[95671.243317] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[95671.244422] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[95673.525861] wlan0: authenticate with d4:a0:2a:98:a6:af
[95673.525907] wlan0: send auth to d4:a0:2a:98:a6:af (try 1/3)
[95673.530641] wlan0: authenticated
[95673.531746] wlan0: associate with d4:a0:2a:98:a6:af (try 1/3)
[95673.533415] wlan0: RX AssocResp from d4:a0:2a:98:a6:af (capab=0x11 status=0 aid=78)
[95673.533984] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[95673.533998] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[95673.534006] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[95673.534024] wlan0: associated
[95673.534078] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[95680.115307] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[95727.817001] ieee80211 phy0: START: tid 2 is not agg'able
[96428.755016] ieee80211 phy0: START: tid 1 is not agg'able
[96594.746414] ieee80211 phy0: START: tid 1 is not agg'able
[96964.187548] ieee80211 phy0: START: tid 1 is not agg'able
[97023.704808] ieee80211 phy0: START: tid 1 is not agg'able
[97215.595781] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[97215.713127] wlan0: deauthenticating from d4:a0:2a:98:a6:af by local choice (reason=3)
[97215.725409] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[97215.725433] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[97215.725444] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[97215.726130] cfg80211: Calling CRDA to update world regulatory domain
[97215.760569] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[97215.760581] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[97215.761607] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[97215.829447] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[97215.829460] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[97215.830560] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[97218.039195] wlan0: authenticate with d4:a0:2a:98:a6:af
[97218.039249] wlan0: send auth to d4:a0:2a:98:a6:af (try 1/3)
[97218.241418] wlan0: send auth to d4:a0:2a:98:a6:af (try 2/3)
[97218.247136] wlan0: authenticated
[97218.248146] wlan0: associate with d4:a0:2a:98:a6:af (try 1/3)
[97218.251665] wlan0: RX AssocResp from d4:a0:2a:98:a6:af (capab=0x11 status=0 aid=78)
[97218.252276] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[97218.252292] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[97218.252302] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[97218.252322] wlan0: associated
[97218.252384] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[97224.595480] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[97474.525728] ieee80211 phy0: START: tid 1 is not agg'able
[97685.460640] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[97685.554082] wlan0: deauthenticating from d4:a0:2a:98:a6:af by local choice (reason=3)
[97685.570137] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[97685.570156] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[97685.570163] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[97685.570779] cfg80211: Calling CRDA for country: CH
[97685.606534] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[97685.606546] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[97685.607701] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[97685.671952] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[97685.671964] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[97685.673028] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[97687.887123] wlan0: authenticate with d4:a0:2a:98:a6:af
[97687.887163] wlan0: send auth to d4:a0:2a:98:a6:af (try 1/3)
[97687.891751] wlan0: authenticated
[97687.893149] wlan0: associate with d4:a0:2a:98:a6:af (try 1/3)
[97687.894799] wlan0: RX AssocResp from d4:a0:2a:98:a6:af (capab=0x11 status=0 aid=78)
[97687.895315] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[97687.895326] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[97687.895331] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[97687.895349] wlan0: associated
[97687.895395] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[97695.205608] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[97998.533061] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[97998.622328] wlan0: deauthenticating from d4:a0:2a:98:a6:af by local choice (reason=3)
[97998.635718] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[97998.635739] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[97998.635741] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[97998.636301] cfg80211: Calling CRDA to update world regulatory domain
[97998.661443] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[97998.661453] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[97998.662496] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[97998.716264] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[97998.716276] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[97998.717298] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[98000.936237] wlan0: authenticate with d4:a0:2a:98:a6:af
[98000.936281] wlan0: send auth to d4:a0:2a:98:a6:af (try 1/3)
[98000.940848] wlan0: authenticated
[98000.942085] wlan0: associate with d4:a0:2a:98:a6:af (try 1/3)
[98000.943771] wlan0: RX AssocResp from d4:a0:2a:98:a6:af (capab=0x11 status=0 aid=78)
[98000.944387] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[98000.944403] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[98000.944413] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[98000.944433] wlan0: associated
[98000.944494] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[98007.329351] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[98103.898564] ieee80211 phy0: START: tid 1 is not agg'able
[98365.231461] EXT4-fs (sda4): re-mounted. Opts: commit=600
[98367.641500] ------------[ cut here ]------------
[98367.641543] WARNING: at drivers/gpu/drm/i915/intel_display.c:6976 intel_modeset_check_state+0x4bb/0x610 [i915]()
[98367.641548] Hardware name: MacBookAir4,2
[98367.641552] encoder's hw state doesn't match sw tracking (expected 1, found 0)
[98367.641555] Modules linked in: xfs fuse ext4 jbd2 mbcache snd_hda_codec_hdmi snd_hda_codec_cirrus sha256_generic arc4 brcmsmac cordic brcmutil mac80211 btusb cfg80211 bluetooth rfkill uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core hid_generic snd_hda_intel crc16 joydev applesmc videodev iTCO_wdt bcm5974 coretemp iTCO_vendor_support media snd_hda_codec i915 acpi_cpufreq intel_agp intel_gtt drm_kms_helper drm i2c_algo_bit lpc_ich mei i2c_i801 i2c_core bcma mperf apple_bl input_polldev snd_hwdep evdev pcspkr video battery ac button microcode processor snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_timer snd soundcore kvm_intel kvm nfs lockd sunrpc fscache jfs dm_crypt dm_mod sd_mod hid_apple ata_generic pata_acpi usb_storage usbhid hid uhci_hcd crc32c_intel ghash_clmulni_intel aesni_intel
[98367.641678]  aes_x86_64 ablk_helper cryptd xts lrw gf128mul ata_piix libata scsi_mod ehci_hcd usbcore usb_common
[98367.641702] Pid: 692, comm: X Tainted: G        W    3.7.9-1-ARCH #1
[98367.641706] Call Trace:
[98367.641720]  [<ffffffff8105756f>] warn_slowpath_common+0x7f/0xc0
[98367.641727]  [<ffffffff81057666>] warn_slowpath_fmt+0x46/0x50
[98367.641749]  [<ffffffffa04ab8db>] intel_modeset_check_state+0x4bb/0x610 [i915]
[98367.641768]  [<ffffffffa04aba74>] intel_connector_dpms+0x44/0x70 [i915]
[98367.641786]  [<ffffffffa03ced3d>] drm_mode_obj_set_property_ioctl+0x32d/0x340 [drm]
[98367.641800]  [<ffffffffa03ced80>] drm_mode_connector_property_set_ioctl+0x30/0x40 [drm]
[98367.641815]  [<ffffffffa03bd3f3>] drm_ioctl+0x4c3/0x570 [drm]
[98367.641830]  [<ffffffffa03ced50>] ? drm_mode_obj_set_property_ioctl+0x340/0x340 [drm]
[98367.641843]  [<ffffffff8112a617>] ? __free_pages+0x57/0x70
[98367.641852]  [<ffffffff8116f67c>] ? kfree+0x2c/0x160
[98367.641861]  [<ffffffff81195e77>] do_vfs_ioctl+0x97/0x530
[98367.641869]  [<ffffffff81185bfe>] ? ____fput+0xe/0x10
[98367.641875]  [<ffffffff811963a1>] sys_ioctl+0x91/0xb0
[98367.641885]  [<ffffffff81015dbc>] ? do_notify_resume+0x9c/0xb0
[98367.641897]  [<ffffffff814c365d>] system_call_fastpath+0x1a/0x1f
[98367.641903] ---[ end trace 062d4264ec21113a ]---
[98367.664108] ------------[ cut here ]------------
[98367.664151] WARNING: at drivers/gpu/drm/i915/intel_dp.c:1908 intel_dp_link_down+0x1d2/0x1e0 [i915]()
[98367.664158] Hardware name: MacBookAir4,2
[98367.664163] Modules linked in: xfs fuse ext4 jbd2 mbcache snd_hda_codec_hdmi snd_hda_codec_cirrus sha256_generic arc4 brcmsmac cordic brcmutil mac80211 btusb cfg80211 bluetooth rfkill uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core hid_generic snd_hda_intel crc16 joydev applesmc videodev iTCO_wdt bcm5974 coretemp iTCO_vendor_support media snd_hda_codec i915 acpi_cpufreq intel_agp intel_gtt drm_kms_helper drm i2c_algo_bit lpc_ich mei i2c_i801 i2c_core bcma mperf apple_bl input_polldev snd_hwdep evdev pcspkr video battery ac button microcode processor snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_timer snd soundcore kvm_intel kvm nfs lockd sunrpc fscache jfs dm_crypt dm_mod sd_mod hid_apple ata_generic pata_acpi usb_storage usbhid hid uhci_hcd crc32c_intel ghash_clmulni_intel aesni_intel
[98367.664234]  aes_x86_64 ablk_helper cryptd xts lrw gf128mul ata_piix libata scsi_mod ehci_hcd usbcore usb_common
[98367.664242] Pid: 692, comm: X Tainted: G        W    3.7.9-1-ARCH #1
[98367.664244] Call Trace:
[98367.664248]  [<ffffffff8105756f>] warn_slowpath_common+0x7f/0xc0
[98367.664251]  [<ffffffff810575ca>] warn_slowpath_null+0x1a/0x20
[98367.664260]  [<ffffffffa04b43f2>] intel_dp_link_down+0x1d2/0x1e0 [i915]
[98367.664267]  [<ffffffffa04b6594>] intel_disable_dp+0x44/0x170 [i915]
[98367.664275]  [<ffffffffa04a527e>] ironlake_crtc_disable+0x68e/0x820 [i915]
[98367.664284]  [<ffffffffa04aa307>] intel_crtc_update_dpms+0x77/0xb0 [i915]
[98367.664292]  [<ffffffffa04aa3fa>] intel_encoder_dpms+0x1a/0x30 [i915]
[98367.664299]  [<ffffffffa04aba6c>] intel_connector_dpms+0x3c/0x70 [i915]
[98367.664306]  [<ffffffffa03ced3d>] drm_mode_obj_set_property_ioctl+0x32d/0x340 [drm]
[98367.664313]  [<ffffffffa03ced80>] drm_mode_connector_property_set_ioctl+0x30/0x40 [drm]
[98367.664318]  [<ffffffffa03bd3f3>] drm_ioctl+0x4c3/0x570 [drm]
[98367.664324]  [<ffffffffa03ced50>] ? drm_mode_obj_set_property_ioctl+0x340/0x340 [drm]
[98367.664328]  [<ffffffff8112a617>] ? __free_pages+0x57/0x70
[98367.664332]  [<ffffffff8116f67c>] ? kfree+0x2c/0x160
[98367.664335]  [<ffffffff81195e77>] do_vfs_ioctl+0x97/0x530
[98367.664338]  [<ffffffff81185bfe>] ? ____fput+0xe/0x10
[98367.664340]  [<ffffffff811963a1>] sys_ioctl+0x91/0xb0
[98367.664345]  [<ffffffff81015dbc>] ? do_notify_resume+0x9c/0xb0
[98367.664348]  [<ffffffff814c365d>] system_call_fastpath+0x1a/0x1f
[98367.664350] ---[ end trace 062d4264ec21113b ]---
[98382.441296] ieee80211 phy0: START: tid 1 is not agg'able
[99447.079395] ieee80211 phy0: START: tid 1 is not agg'able
[99533.293944] PM: Syncing filesystems ... done.
[99533.430061] PM: Preparing system for mem sleep
[99533.608560] Freezing user space processes ... (elapsed 0.01 seconds) done.
[99533.621238] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[99533.634554] PM: Entering mem sleep
[99533.634604] Suspending console(s) (use no_console_suspend to debug)
[99533.683817] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[99533.685101] sd 0:0:0:0: [sda] Stopping disk
[99534.979020] PM: suspend of devices complete after 1306.186 msecs
[99534.979496] PM: late suspend of devices complete after 0.471 msecs
[99534.992663] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[99535.005796] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[99535.032264] PM: noirq suspend of devices complete after 52.845 msecs
[99535.033139] ACPI: Preparing to enter system sleep state S3
[99535.058872] PM: Saving platform NVS memory
[99535.059572] Disabling non-boot CPUs ...
[99535.161945] smpboot: CPU 1 is now offline
[99535.265085] smpboot: CPU 2 is now offline
[99535.368259] smpboot: CPU 3 is now offline
[99535.368852] Extended CMOS year: 2000
[99535.370956] ACPI: Low-level resume complete
[99535.370997] PM: Restoring platform NVS memory
[99535.371296] Extended CMOS year: 2000
[99535.371359] Enabling non-boot CPUs ...
[99535.374800] smpboot: Booting Node 0 Processor 1 APIC 0x2
[99535.389039] CPU1 is up
[99535.392433] smpboot: Booting Node 0 Processor 2 APIC 0x1
[99535.406051] CPU2 is up
[99535.406504] smpboot: Booting Node 0 Processor 3 APIC 0x3
[99535.420772] CPU3 is up
[99535.425669] ACPI: Waking up from system sleep state S3
[99535.966527] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[99535.979951] pcieport 0000:00:1c.1: power state changed by ACPI to D0
[99535.993144] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[99536.020146] PM: noirq resume of devices complete after 93.681 msecs
[99536.020533] PM: early resume of devices complete after 0.343 msecs
[99536.020592] i915 0000:00:02.0: setting latency timer to 64
[99536.020672] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[99536.020771] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[99536.020800] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[99536.020814] usb usb3: root hub lost power or was reset
[99536.020855] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[99536.020881] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[99536.020886] usb usb4: root hub lost power or was reset
[99536.020904] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[99536.020921] ata_piix 0000:00:1f.2: setting latency timer to 64
[99536.021537] mei 0000:00:16.0: wd: failed to find the client
[99536.076258] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake old ack to clear.
[99536.077554] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[99536.093140] bcm5974: bad trackpad package, length: 8
[99536.094135] bcm5974: bad trackpad package, length: 8
[99536.139245] Extended CMOS year: 2000
[99537.041560] ata2.00: failed to resume link (SControl 0)
[99537.361066] ata1.01: failed to resume link (SControl 0)
[99537.514243] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[99537.514261] ata1.01: SATA link down (SStatus 0 SControl 0)
[99537.521166] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[99537.527910] ata1.00: configured for UDMA/133
[99537.562360] sd 0:0:0:0: [sda] Starting disk
[99538.063305] ata2.01: failed to resume link (SControl 0)
[99538.075194] ata2.00: SATA link down (SStatus 4 SControl 0)
[99538.075215] ata2.01: SATA link down (SStatus 0 SControl 0)
[99538.091762] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[99538.092788] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[99538.092794] ieee80211 phy0: changing basic rates failed: -22
[99538.092799] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: threshold 0, hys 0  (implement)
[99538.092803] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[99538.092806] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[99538.093255] PM: resume of devices complete after 2075.943 msecs
[99538.115654] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[99538.115665] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[99538.115668] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[99538.130654] cfg80211: Calling CRDA to update world regulatory domain
[99538.133011] PM: Finishing wakeup.
[99538.133012] Restarting tasks ... done.
[99538.184216] video LNXVIDEO:00: Restoring backlight state
[99538.325688] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[99538.325709] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[99538.326915] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[99543.543718] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[99543.543740] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[99543.544919] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[99547.862019] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[99547.862029] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[99547.863046] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[99547.915994] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[99547.916014] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[99547.917104] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[99550.172594] wlan0: authenticate with 5c:ff:35:75:05:89
[99550.192645] wlan0: send auth to 5c:ff:35:75:05:89 (try 1/3)
[99550.196940] wlan0: authenticated
[99550.197724] wlan0: associate with 5c:ff:35:75:05:89 (try 1/3)
[99550.214180] wlan0: RX AssocResp from 5c:ff:35:75:05:89 (capab=0x431 status=0 aid=1)
[99550.214824] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[99550.214836] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[99550.214842] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[99550.214868] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[99550.215062] wlan0: associated
[99558.195766] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[100474.756978] ieee80211 phy0: START: tid 1 is not agg'able
[100475.187684] ieee80211 phy0: START: tid 1 is not agg'able
[100558.604465] PM: Syncing filesystems ... done.
[100558.761090] PM: Preparing system for mem sleep
[100558.816359] Freezing user space processes ... (elapsed 0.01 seconds) done.
[100558.829334] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[100558.842607] PM: Entering mem sleep
[100558.842661] Suspending console(s) (use no_console_suspend to debug)
[100558.891817] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[100558.893103] sd 0:0:0:0: [sda] Stopping disk
[100560.543196] PM: suspend of devices complete after 1662.803 msecs
[100560.543672] PM: late suspend of devices complete after 0.471 msecs
[100560.556885] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[100560.570016] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[100560.596477] PM: noirq suspend of devices complete after 52.882 msecs
[100560.597352] ACPI: Preparing to enter system sleep state S3
[100560.623124] PM: Saving platform NVS memory
[100560.623823] Disabling non-boot CPUs ...
[100560.726149] smpboot: CPU 1 is now offline
[100560.829298] smpboot: CPU 2 is now offline
[100560.932474] smpboot: CPU 3 is now offline
[100560.933064] Extended CMOS year: 2000
[100560.935169] ACPI: Low-level resume complete
[100560.935210] PM: Restoring platform NVS memory
[100560.935510] Extended CMOS year: 2000
[100560.935572] Enabling non-boot CPUs ...
[100560.939014] smpboot: Booting Node 0 Processor 1 APIC 0x2
[100560.953258] CPU1 is up
[100560.956651] smpboot: Booting Node 0 Processor 2 APIC 0x1
[100560.970267] CPU2 is up
[100560.970710] smpboot: Booting Node 0 Processor 3 APIC 0x3
[100560.985026] CPU3 is up
[100560.989886] ACPI: Waking up from system sleep state S3
[100561.530742] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[100561.544169] pcieport 0000:00:1c.1: power state changed by ACPI to D0
[100561.557361] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[100561.584364] PM: noirq resume of devices complete after 93.680 msecs
[100561.584822] PM: early resume of devices complete after 0.357 msecs
[100561.584892] i915 0000:00:02.0: setting latency timer to 64
[100561.584926] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[100561.584956] usb usb3: root hub lost power or was reset
[100561.584961] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[100561.584979] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[100561.585007] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[100561.585012] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[100561.585038] usb usb4: root hub lost power or was reset
[100561.585049] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[100561.585057] ata_piix 0000:00:1f.2: setting latency timer to 64
[100561.585708] mei 0000:00:16.0: wd: failed to find the client
[100561.640473] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake old ack to clear.
[100561.641742] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[100561.657362] bcm5974: bad trackpad package, length: 8
[100561.720183] Extended CMOS year: 2000
[100562.605777] ata2.00: failed to resume link (SControl 0)
[100562.925277] ata1.01: failed to resume link (SControl 0)
[100563.078464] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[100563.078482] ata1.01: SATA link down (SStatus 0 SControl 0)
[100563.085379] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[100563.092130] ata1.00: configured for UDMA/133
[100563.126515] sd 0:0:0:0: [sda] Starting disk
[100563.627524] ata2.01: failed to resume link (SControl 0)
[100563.639411] ata2.00: SATA link down (SStatus 4 SControl 0)
[100563.639433] ata2.01: SATA link down (SStatus 0 SControl 0)
[100563.656673] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[100563.657685] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[100563.657687] ieee80211 phy0: changing basic rates failed: -22
[100563.657688] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: threshold 0, hys 0  (implement)
[100563.657689] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[100563.657690] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[100563.657944] PM: resume of devices complete after 2076.343 msecs
[100563.676334] PM: Finishing wakeup.
[100563.676335] Restarting tasks ... done.
[100563.750723] video LNXVIDEO:00: Restoring backlight state
[100563.823065] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[100563.823096] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[100563.823100] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[100563.823577] cfg80211: Calling CRDA for country: CH
[100563.958075] X: page allocation failure: order:4, mode:0xc0d0
[100563.958080] Pid: 692, comm: X Tainted: G        W    3.7.9-1-ARCH #1
[100563.958082] Call Trace:
[100563.958090]  [<ffffffff811266d9>] warn_alloc_failed+0xe9/0x140
[100563.958094]  [<ffffffff814b3d72>] ? __alloc_pages_direct_compact+0x1b8/0x1ca
[100563.958098]  [<ffffffff8112a17f>] __alloc_pages_nodemask+0x6ef/0x960
[100563.958102]  [<ffffffff81165fd0>] alloc_pages_current+0xb0/0x120
[100563.958106]  [<ffffffff8112598e>] __get_free_pages+0xe/0x50
[100563.958109]  [<ffffffff8116cf49>] kmalloc_order_trace+0x39/0xf0
[100563.958113]  [<ffffffff8116fd8a>] __kmalloc+0x17a/0x190
[100563.958124]  [<ffffffffa04420d5>] evdev_open+0x85/0x1e0 [evdev]
[100563.958128]  [<ffffffff81188d2b>] chrdev_open+0x9b/0x1c0
[100563.958132]  [<ffffffff81182b43>] do_dentry_open+0x203/0x290
[100563.958135]  [<ffffffff81188c90>] ? cdev_put+0x30/0x30
[100563.958138]  [<ffffffff81182e85>] finish_open+0x35/0x50
[100563.958141]  [<ffffffff81192c1e>] do_last+0x31e/0xeb0
[100563.958144]  [<ffffffff8118fba8>] ? link_path_walk+0x78/0x950
[100563.958147]  [<ffffffff8119386c>] path_openat+0xbc/0x530
[100563.958150]  [<ffffffff81194051>] do_filp_open+0x41/0xa0
[100563.958154]  [<ffffffff811a0f59>] ? __alloc_fd+0xe9/0x140
[100563.958157]  [<ffffffff81183d94>] do_sys_open+0xf4/0x1e0
[100563.958160]  [<ffffffff81183ea1>] sys_open+0x21/0x30
[100563.958165]  [<ffffffff814c365d>] system_call_fastpath+0x1a/0x1f
[100563.958167] Mem-Info:
[100563.958168] Node 0 DMA per-cpu:
[100563.958171] CPU    0: hi:    0, btch:   1 usd:   0
[100563.958172] CPU    1: hi:    0, btch:   1 usd:   0
[100563.958174] CPU    2: hi:    0, btch:   1 usd:   0
[100563.958175] CPU    3: hi:    0, btch:   1 usd:   0
[100563.958177] Node 0 DMA32 per-cpu:
[100563.958179] CPU    0: hi:  186, btch:  31 usd:   0
[100563.958181] CPU    1: hi:  186, btch:  31 usd:   0
[100563.958182] CPU    2: hi:  186, btch:  31 usd:   0
[100563.958184] CPU    3: hi:  186, btch:  31 usd:   0
[100563.958185] Node 0 Normal per-cpu:
[100563.958187] CPU    0: hi:  186, btch:  31 usd:   0
[100563.958188] CPU    1: hi:  186, btch:  31 usd:   0
[100563.958190] CPU    2: hi:  186, btch:  31 usd:   0
[100563.958192] CPU    3: hi:  186, btch:  31 usd:   0
[100563.958196] active_anon:152882 inactive_anon:153965 isolated_anon:0
 active_file:219887 inactive_file:208047 isolated_file:0
 unevictable:5214 dirty:232 writeback:0 unstable:0
 free:137444 slab_reclaimable:74552 slab_unreclaimable:8241
 mapped:20743 shmem:54142 pagetables:8521 bounce:0
 free_cma:0
[100563.958201] Node 0 DMA free:15360kB min:252kB low:312kB high:376kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15104kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[100563.958205] lowmem_reserve[]: 0 2137 3899 3899
[100563.958209] Node 0 DMA32 free:484168kB min:36904kB low:46128kB high:55356kB active_anon:211348kB inactive_anon:176888kB active_file:541476kB inactive_file:493392kB unevictable:3388kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:3388kB dirty:720kB writeback:0kB mapped:30440kB shmem:70236kB slab_reclaimable:251440kB slab_unreclaimable:6740kB kernel_stack:2232kB pagetables:6568kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[100563.958214] lowmem_reserve[]: 0 0 1762 1762
[100563.958218] Node 0 Normal free:50248kB min:30420kB low:38024kB high:45628kB active_anon:400180kB inactive_anon:438972kB active_file:338072kB inactive_file:338796kB unevictable:17468kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:17468kB dirty:208kB writeback:0kB mapped:52532kB shmem:146332kB slab_reclaimable:46768kB slab_unreclaimable:26224kB kernel_stack:1592kB pagetables:27516kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[100563.958223] lowmem_reserve[]: 0 0 0 0
[100563.958226] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15360kB
[100563.958234] Node 0 DMA32: 24388*4kB 18840*8kB 9104*16kB 2768*32kB 23*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 484112kB
[100563.958241] Node 0 Normal: 11402*4kB 68*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 50248kB
[100563.958249] 502925 total pagecache pages
[100563.958250] 19914 pages in swap cache
[100563.958252] Swap cache stats: add 6260393, delete 6240479, find 2612634/3349323
[100563.958253] Free swap  = 8052220kB
[100563.958254] Total swap = 8386556kB
[100563.967662] 1048048 pages RAM
[100563.967664] 57808 pages reserved
[100563.967666] 1235410 pages shared
[100563.967667] 773606 pages non-shared
[100567.798471] wlan0: authenticate with 5c:ff:35:75:05:89
[100567.808216] wlan0: send auth to 5c:ff:35:75:05:89 (try 1/3)
[100567.810289] wlan0: authenticated
[100567.810903] wlan0: associate with 5c:ff:35:75:05:89 (try 1/3)
[100567.822169] wlan0: RX AssocResp from 5c:ff:35:75:05:89 (capab=0x431 status=0 aid=2)
[100567.822782] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[100567.822793] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[100567.822799] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[100567.822817] wlan0: associated
[100568.811611] wlan0: deauthenticating from 5c:ff:35:75:05:89 by local choice (reason=3)
[100568.819578] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[100568.819598] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[100568.819604] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[100568.820289] cfg80211: Calling CRDA to update world regulatory domain
[100568.849697] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[100568.849710] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[100568.850791] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[100573.689118] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[100573.689138] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[100573.690247] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[100577.812766] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[100577.812777] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[100577.813824] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[100577.871784] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[100577.871805] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[100577.873036] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[100579.999620] wlan0: authenticate with 5c:ff:35:75:05:89
[100579.999661] wlan0: send auth to 5c:ff:35:75:05:89 (try 1/3)
[100580.005965] wlan0: authenticated
[100580.008634] wlan0: associate with 5c:ff:35:75:05:89 (try 1/3)
[100580.021823] wlan0: RX AssocResp from 5c:ff:35:75:05:89 (capab=0x431 status=0 aid=3)
[100580.022474] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[100580.022486] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[100580.022492] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[100580.022506] wlan0: associated
[100580.022567] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[100585.923081] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[100588.305646] usbcore: deregistering interface driver bcm5974
[100604.723409] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input15
[100604.723747] usbcore: registered new interface driver bcm5974
[100604.744539] X: page allocation failure: order:4, mode:0xc0d0
[100604.744550] Pid: 692, comm: X Tainted: G        W    3.7.9-1-ARCH #1
[100604.744554] Call Trace:
[100604.744571]  [<ffffffff811266d9>] warn_alloc_failed+0xe9/0x140
[100604.744582]  [<ffffffff81129a36>] ? drain_local_pages+0x16/0x20
[100604.744591]  [<ffffffff8112a17f>] __alloc_pages_nodemask+0x6ef/0x960
[100604.744602]  [<ffffffff81165fd0>] alloc_pages_current+0xb0/0x120
[100604.744610]  [<ffffffff8112598e>] __get_free_pages+0xe/0x50
[100604.744618]  [<ffffffff8116cf49>] kmalloc_order_trace+0x39/0xf0
[100604.744627]  [<ffffffff8116fd8a>] __kmalloc+0x17a/0x190
[100604.744652]  [<ffffffffa04420d5>] evdev_open+0x85/0x1e0 [evdev]
[100604.744661]  [<ffffffff81188340>] ? mount_fs+0x1b0/0x1b0
[100604.744668]  [<ffffffff81188d2b>] chrdev_open+0x9b/0x1c0
[100604.744677]  [<ffffffff81182b43>] do_dentry_open+0x203/0x290
[100604.744684]  [<ffffffff81188c90>] ? cdev_put+0x30/0x30
[100604.744693]  [<ffffffff81182e85>] finish_open+0x35/0x50
[100604.744699]  [<ffffffff81192c1e>] do_last+0x31e/0xeb0
[100604.744708]  [<ffffffff8118fba8>] ? link_path_walk+0x78/0x950
[100604.744714]  [<ffffffff8119386c>] path_openat+0xbc/0x530
[100604.744721]  [<ffffffff81194051>] do_filp_open+0x41/0xa0
[100604.744729]  [<ffffffff811a0f59>] ? __alloc_fd+0xe9/0x140
[100604.744738]  [<ffffffff81183d94>] do_sys_open+0xf4/0x1e0
[100604.744746]  [<ffffffff81183ea1>] sys_open+0x21/0x30
[100604.744757]  [<ffffffff814c365d>] system_call_fastpath+0x1a/0x1f
[100604.744760] Mem-Info:
[100604.744764] Node 0 DMA per-cpu:
[100604.744770] CPU    0: hi:    0, btch:   1 usd:   0
[100604.744774] CPU    1: hi:    0, btch:   1 usd:   0
[100604.744778] CPU    2: hi:    0, btch:   1 usd:   0
[100604.744782] CPU    3: hi:    0, btch:   1 usd:   0
[100604.744785] Node 0 DMA32 per-cpu:
[100604.744791] CPU    0: hi:  186, btch:  31 usd:   0
[100604.744795] CPU    1: hi:  186, btch:  31 usd:   0
[100604.744799] CPU    2: hi:  186, btch:  31 usd:   0
[100604.744803] CPU    3: hi:  186, btch:  31 usd:   0
[100604.744806] Node 0 Normal per-cpu:
[100604.744811] CPU    0: hi:  186, btch:  31 usd:   0
[100604.744814] CPU    1: hi:  186, btch:  31 usd:   0
[100604.744818] CPU    2: hi:  186, btch:  31 usd:  91
[100604.744822] CPU    3: hi:  186, btch:  31 usd:   0
[100604.744832] active_anon:156974 inactive_anon:150253 isolated_anon:0
 active_file:220017 inactive_file:208009 isolated_file:0
 unevictable:5214 dirty:689 writeback:0 unstable:0
 free:136962 slab_reclaimable:74548 slab_unreclaimable:8254
 mapped:19659 shmem:53008 pagetables:8446 bounce:0
 free_cma:0
[100604.744842] Node 0 DMA free:15360kB min:252kB low:312kB high:376kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15104kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[100604.744855] lowmem_reserve[]: 0 2137 3899 3899
[100604.744863] Node 0 DMA32 free:489712kB min:36904kB low:46128kB high:55356kB active_anon:205592kB inactive_anon:176908kB active_file:541484kB inactive_file:493420kB unevictable:3388kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:3388kB dirty:1752kB writeback:0kB mapped:30476kB shmem:70140kB slab_reclaimable:251424kB slab_unreclaimable:6796kB kernel_stack:2240kB pagetables:6480kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[100604.744877] lowmem_reserve[]: 0 0 1762 1762
[100604.744885] Node 0 Normal free:42776kB min:30420kB low:38024kB high:45628kB active_anon:422304kB inactive_anon:424104kB active_file:338584kB inactive_file:338396kB unevictable:17468kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:17468kB dirty:1004kB writeback:0kB mapped:48160kB shmem:141892kB slab_reclaimable:46768kB slab_unreclaimable:26220kB kernel_stack:1592kB pagetables:27304kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:149 all_unreclaimable? no
[100604.744898] lowmem_reserve[]: 0 0 0 0
[100604.744905] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15360kB
[100604.744925] Node 0 DMA32: 24210*4kB 19095*8kB 9335*16kB 2784*32kB 24*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 489712kB
[100604.744944] Node 0 Normal: 9598*4kB 49*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 42880kB
[100604.744963] 501867 total pagecache pages
[100604.744966] 19997 pages in swap cache
[100604.744971] Swap cache stats: add 6260528, delete 6240531, find 2613076/3349796
[100604.744974] Free swap  = 8052428kB
[100604.744977] Total swap = 8386556kB
[100604.774989] 1048048 pages RAM
[100604.775006] 57808 pages reserved
[100604.775022] 1234340 pages shared
[100604.775045] 774251 pages non-shared
[100610.364718] usbcore: deregistering interface driver bcm5974
[100619.207928] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input16
[100619.208283] usbcore: registered new interface driver bcm5974
[100619.219272] X: page allocation failure: order:4, mode:0xc0d0
[100619.219276] Pid: 692, comm: X Tainted: G        W    3.7.9-1-ARCH #1
[100619.219278] Call Trace:
[100619.219287]  [<ffffffff811266d9>] warn_alloc_failed+0xe9/0x140
[100619.219291]  [<ffffffff81129a36>] ? drain_local_pages+0x16/0x20
[100619.219295]  [<ffffffff8112a17f>] __alloc_pages_nodemask+0x6ef/0x960
[100619.219300]  [<ffffffff81165fd0>] alloc_pages_current+0xb0/0x120
[100619.219304]  [<ffffffff8112598e>] __get_free_pages+0xe/0x50
[100619.219309]  [<ffffffff8116cf49>] kmalloc_order_trace+0x39/0xf0
[100619.219313]  [<ffffffff8116fd8a>] __kmalloc+0x17a/0x190
[100619.219325]  [<ffffffffa04420d5>] evdev_open+0x85/0x1e0 [evdev]
[100619.219328]  [<ffffffff81188340>] ? mount_fs+0x1b0/0x1b0
[100619.219331]  [<ffffffff81188d2b>] chrdev_open+0x9b/0x1c0
[100619.219334]  [<ffffffff81182b43>] do_dentry_open+0x203/0x290
[100619.219337]  [<ffffffff81188c90>] ? cdev_put+0x30/0x30
[100619.219339]  [<ffffffff81182e85>] finish_open+0x35/0x50
[100619.219341]  [<ffffffff81192c1e>] do_last+0x31e/0xeb0
[100619.219344]  [<ffffffff8118fba8>] ? link_path_walk+0x78/0x950
[100619.219347]  [<ffffffff81122589>] ? __generic_file_aio_write+0x1b9/0x3b0
[100619.219349]  [<ffffffff8119386c>] path_openat+0xbc/0x530
[100619.219351]  [<ffffffff81194051>] do_filp_open+0x41/0xa0
[100619.219354]  [<ffffffff811a0f59>] ? __alloc_fd+0xe9/0x140
[100619.219356]  [<ffffffff81183d94>] do_sys_open+0xf4/0x1e0
[100619.219359]  [<ffffffff81183ea1>] sys_open+0x21/0x30
[100619.219364]  [<ffffffff814c365d>] system_call_fastpath+0x1a/0x1f
[100619.219365] Mem-Info:
[100619.219366] Node 0 DMA per-cpu:
[100619.219368] CPU    0: hi:    0, btch:   1 usd:   0
[100619.219370] CPU    1: hi:    0, btch:   1 usd:   0
[100619.219371] CPU    2: hi:    0, btch:   1 usd:   0
[100619.219372] CPU    3: hi:    0, btch:   1 usd:   0
[100619.219373] Node 0 DMA32 per-cpu:
[100619.219375] CPU    0: hi:  186, btch:  31 usd:   0
[100619.219376] CPU    1: hi:  186, btch:  31 usd:   0
[100619.219378] CPU    2: hi:  186, btch:  31 usd:   0
[100619.219379] CPU    3: hi:  186, btch:  31 usd:   0
[100619.219380] Node 0 Normal per-cpu:
[100619.219381] CPU    0: hi:  186, btch:  31 usd:  31
[100619.219382] CPU    1: hi:  186, btch:  31 usd:  55
[100619.219384] CPU    2: hi:  186, btch:  31 usd:   0
[100619.219385] CPU    3: hi:  186, btch:  31 usd:   0
[100619.219388] active_anon:158910 inactive_anon:150552 isolated_anon:0
 active_file:219420 inactive_file:207442 isolated_file:0
 unevictable:5214 dirty:864 writeback:0 unstable:0
 free:136096 slab_reclaimable:74406 slab_unreclaimable:8254
 mapped:19309 shmem:53019 pagetables:8354 bounce:0
 free_cma:0
[100619.219391] Node 0 DMA free:15360kB min:252kB low:312kB high:376kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15104kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[100619.219395] lowmem_reserve[]: 0 2137 3899 3899
[100619.219398] Node 0 DMA32 free:486884kB min:36904kB low:46128kB high:55356kB active_anon:208980kB inactive_anon:176908kB active_file:541496kB inactive_file:493396kB unevictable:3388kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:3388kB dirty:2260kB writeback:0kB mapped:29736kB shmem:70140kB slab_reclaimable:250872kB slab_unreclaimable:6796kB kernel_stack:2184kB pagetables:6460kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[100619.219402] lowmem_reserve[]: 0 0 1762 1762
[100619.219405] Node 0 Normal free:42140kB min:30420kB low:38024kB high:45628kB active_anon:426532kB inactive_anon:425428kB active_file:336184kB inactive_file:336372kB unevictable:17468kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:17468kB dirty:1196kB writeback:0kB mapped:47500kB shmem:141936kB slab_reclaimable:46752kB slab_unreclaimable:26220kB kernel_stack:1592kB pagetables:26956kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:259 all_unreclaimable? no
[100619.219409] lowmem_reserve[]: 0 0 0 0
[100619.219411] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15360kB
[100619.219417] Node 0 DMA32: 24198*4kB 18689*8kB 9334*16kB 2800*32kB 25*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 486976kB
[100619.219423] Node 0 Normal: 9401*4kB 55*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 42140kB
[100619.219430] 500763 total pagecache pages
[100619.219431] 19997 pages in swap cache
[100619.219432] Swap cache stats: add 6260528, delete 6240531, find 2613453/3350173
[100619.219433] Free swap  = 8052428kB
[100619.219434] Total swap = 8386556kB
[100619.246815] 1048048 pages RAM
[100619.246823] 57808 pages reserved
[100619.246827] 1233180 pages shared
[100619.246831] 775258 pages non-shared
[100621.500801] usbcore: deregistering interface driver bcm5974
[100625.006827] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input17
[100625.007272] usbcore: registered new interface driver bcm5974
[100625.021644] X: page allocation failure: order:4, mode:0xc0d0
[100625.021655] Pid: 692, comm: X Tainted: G        W    3.7.9-1-ARCH #1
[100625.021659] Call Trace:
[100625.021677]  [<ffffffff811266d9>] warn_alloc_failed+0xe9/0x140
[100625.021687]  [<ffffffff81129a36>] ? drain_local_pages+0x16/0x20
[100625.021696]  [<ffffffff8112a17f>] __alloc_pages_nodemask+0x6ef/0x960
[100625.021706]  [<ffffffff81165fd0>] alloc_pages_current+0xb0/0x120
[100625.021714]  [<ffffffff8112598e>] __get_free_pages+0xe/0x50
[100625.021723]  [<ffffffff8116cf49>] kmalloc_order_trace+0x39/0xf0
[100625.021732]  [<ffffffff8116fd8a>] __kmalloc+0x17a/0x190
[100625.021844]  [<ffffffffa04420d5>] evdev_open+0x85/0x1e0 [evdev]
[100625.021857]  [<ffffffff81188340>] ? mount_fs+0x1b0/0x1b0
[100625.021898]  [<ffffffff81188d2b>] chrdev_open+0x9b/0x1c0
[100625.021932]  [<ffffffff81182b43>] do_dentry_open+0x203/0x290
[100625.021946]  [<ffffffff81188c90>] ? cdev_put+0x30/0x30
[100625.021958]  [<ffffffff81182e85>] finish_open+0x35/0x50
[100625.021967]  [<ffffffff81192c1e>] do_last+0x31e/0xeb0
[100625.021979]  [<ffffffff8118fba8>] ? link_path_walk+0x78/0x950
[100625.021990]  [<ffffffff81122589>] ? __generic_file_aio_write+0x1b9/0x3b0
[100625.022002]  [<ffffffff8119386c>] path_openat+0xbc/0x530
[100625.022013]  [<ffffffff81194051>] do_filp_open+0x41/0xa0
[100625.022024]  [<ffffffff811a0f59>] ? __alloc_fd+0xe9/0x140
[100625.022041]  [<ffffffff81183d94>] do_sys_open+0xf4/0x1e0
[100625.022052]  [<ffffffff81183ea1>] sys_open+0x21/0x30
[100625.022067]  [<ffffffff814c365d>] system_call_fastpath+0x1a/0x1f
[100625.022073] Mem-Info:
[100625.022079] Node 0 DMA per-cpu:
[100625.022089] CPU    0: hi:    0, btch:   1 usd:   0
[100625.022096] CPU    1: hi:    0, btch:   1 usd:   0
[100625.022102] CPU    2: hi:    0, btch:   1 usd:   0
[100625.022108] CPU    3: hi:    0, btch:   1 usd:   0
[100625.022113] Node 0 DMA32 per-cpu:
[100625.022122] CPU    0: hi:  186, btch:  31 usd:   0
[100625.022133] CPU    1: hi:  186, btch:  31 usd:   0
[100625.022140] CPU    2: hi:  186, btch:  31 usd:   0
[100625.022146] CPU    3: hi:  186, btch:  31 usd:   0
[100625.022151] Node 0 Normal per-cpu:
[100625.022159] CPU    0: hi:  186, btch:  31 usd:   0
[100625.022166] CPU    1: hi:  186, btch:  31 usd:   0
[100625.022173] CPU    2: hi:  186, btch:  31 usd:   1
[100625.022178] CPU    3: hi:  186, btch:  31 usd:   0
[100625.022194] active_anon:158164 inactive_anon:150747 isolated_anon:0
 active_file:218806 inactive_file:206735 isolated_file:0
 unevictable:5214 dirty:908 writeback:0 unstable:0
 free:138166 slab_reclaimable:74237 slab_unreclaimable:8253
 mapped:19324 shmem:53019 pagetables:8354 bounce:0
 free_cma:0
[100625.022210] Node 0 DMA free:15360kB min:252kB low:312kB high:376kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15104kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[100625.022232] lowmem_reserve[]: 0 2137 3899 3899
[100625.022250] Node 0 DMA32 free:488176kB min:36904kB low:46128kB high:55356kB active_anon:208488kB inactive_anon:176908kB active_file:541504kB inactive_file:493368kB unevictable:3388kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:3388kB dirty:2416kB writeback:0kB mapped:29768kB shmem:70140kB slab_reclaimable:250200kB slab_unreclaimable:6792kB kernel_stack:2192kB pagetables:6448kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:32 all_unreclaimable? no
[100625.022272] lowmem_reserve[]: 0 0 1762 1762
[100625.022283] Node 0 Normal free:49128kB min:30420kB low:38024kB high:45628kB active_anon:424168kB inactive_anon:426080kB active_file:333720kB inactive_file:333572kB unevictable:17468kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:17468kB dirty:1216kB writeback:0kB mapped:47528kB shmem:141936kB slab_reclaimable:46748kB slab_unreclaimable:26220kB kernel_stack:1592kB pagetables:26968kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[100625.022304] lowmem_reserve[]: 0 0 0 0
[100625.022315] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15360kB
[100625.022349] Node 0 DMA32: 24252*4kB 18729*8kB 9334*16kB 2821*32kB 25*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 488184kB
[100625.022376] Node 0 Normal: 10966*4kB 146*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 49128kB
[100625.022406] 499438 total pagecache pages
[100625.022411] 19997 pages in swap cache
[100625.022422] Swap cache stats: add 6260528, delete 6240531, find 2613622/3350342
[100625.022427] Free swap  = 8052428kB
[100625.022432] Total swap = 8386556kB
[100625.046802] 1048048 pages RAM
[100625.046804] 57808 pages reserved
[100625.046805] 1233310 pages shared
[100625.046806] 774258 pages non-shared
[100627.618021] usbcore: deregistering interface driver bcm5974
[100632.131634] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input18
[100632.131999] usbcore: registered new interface driver bcm5974
[100632.148079] X: page allocation failure: order:4, mode:0xc0d0
[100632.148094] Pid: 692, comm: X Tainted: G        W    3.7.9-1-ARCH #1
[100632.148098] Call Trace:
[100632.148116]  [<ffffffff811266d9>] warn_alloc_failed+0xe9/0x140
[100632.148126]  [<ffffffff81129a36>] ? drain_local_pages+0x16/0x20
[100632.148136]  [<ffffffff8112a17f>] __alloc_pages_nodemask+0x6ef/0x960
[100632.148145]  [<ffffffff81165fd0>] alloc_pages_current+0xb0/0x120
[100632.148154]  [<ffffffff8112598e>] __get_free_pages+0xe/0x50
[100632.148162]  [<ffffffff8116cf49>] kmalloc_order_trace+0x39/0xf0
[100632.148171]  [<ffffffff8116fd8a>] __kmalloc+0x17a/0x190
[100632.148195]  [<ffffffffa04420d5>] evdev_open+0x85/0x1e0 [evdev]
[100632.148204]  [<ffffffff81188340>] ? mount_fs+0x1b0/0x1b0
[100632.148212]  [<ffffffff81188d2b>] chrdev_open+0x9b/0x1c0
[100632.148221]  [<ffffffff81182b43>] do_dentry_open+0x203/0x290
[100632.148228]  [<ffffffff81188c90>] ? cdev_put+0x30/0x30
[100632.148236]  [<ffffffff81182e85>] finish_open+0x35/0x50
[100632.148243]  [<ffffffff81192c1e>] do_last+0x31e/0xeb0
[100632.148252]  [<ffffffff8118fba8>] ? link_path_walk+0x78/0x950
[100632.148260]  [<ffffffff81122589>] ? __generic_file_aio_write+0x1b9/0x3b0
[100632.148266]  [<ffffffff8119386c>] path_openat+0xbc/0x530
[100632.148273]  [<ffffffff81194051>] do_filp_open+0x41/0xa0
[100632.148281]  [<ffffffff811a0f59>] ? __alloc_fd+0xe9/0x140
[100632.148290]  [<ffffffff81183d94>] do_sys_open+0xf4/0x1e0
[100632.148298]  [<ffffffff81183ea1>] sys_open+0x21/0x30
[100632.148309]  [<ffffffff814c365d>] system_call_fastpath+0x1a/0x1f
[100632.148313] Mem-Info:
[100632.148317] Node 0 DMA per-cpu:
[100632.148323] CPU    0: hi:    0, btch:   1 usd:   0
[100632.148328] CPU    1: hi:    0, btch:   1 usd:   0
[100632.148331] CPU    2: hi:    0, btch:   1 usd:   0
[100632.148335] CPU    3: hi:    0, btch:   1 usd:   0
[100632.148338] Node 0 DMA32 per-cpu:
[100632.148344] CPU    0: hi:  186, btch:  31 usd:   0
[100632.148348] CPU    1: hi:  186, btch:  31 usd:   0
[100632.148352] CPU    2: hi:  186, btch:  31 usd:   0
[100632.148355] CPU    3: hi:  186, btch:  31 usd:   0
[100632.148358] Node 0 Normal per-cpu:
[100632.148363] CPU    0: hi:  186, btch:  31 usd:   0
[100632.148367] CPU    1: hi:  186, btch:  31 usd:  18
[100632.148371] CPU    2: hi:  186, btch:  31 usd:   0
[100632.148374] CPU    3: hi:  186, btch:  31 usd:   0
[100632.148385] active_anon:155555 inactive_anon:150779 isolated_anon:0
 active_file:218782 inactive_file:206754 isolated_file:0
 unevictable:5214 dirty:963 writeback:0 unstable:0
 free:140875 slab_reclaimable:74237 slab_unreclaimable:8253
 mapped:19343 shmem:53019 pagetables:8344 bounce:0
 free_cma:0
[100632.148395] Node 0 DMA free:15360kB min:252kB low:312kB high:376kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15104kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[100632.148407] lowmem_reserve[]: 0 2137 3899 3899
[100632.148416] Node 0 DMA32 free:489288kB min:36904kB low:46128kB high:55356kB active_anon:207280kB inactive_anon:177036kB active_file:541508kB inactive_file:493364kB unevictable:3388kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:3388kB dirty:2560kB writeback:0kB mapped:29812kB shmem:70140kB slab_reclaimable:250200kB slab_unreclaimable:6792kB kernel_stack:2184kB pagetables:6448kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:32 all_unreclaimable? no
[100632.148430] lowmem_reserve[]: 0 0 1762 1762
[100632.148437] Node 0 Normal free:58852kB min:30420kB low:38024kB high:45628kB active_anon:414940kB inactive_anon:426080kB active_file:333620kB inactive_file:333652kB unevictable:17468kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:17468kB dirty:1292kB writeback:0kB mapped:47560kB shmem:141936kB slab_reclaimable:46748kB slab_unreclaimable:26220kB kernel_stack:1592kB pagetables:26928kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[100632.148450] lowmem_reserve[]: 0 0 0 0
[100632.148457] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15360kB
[100632.148478] Node 0 DMA32: 24516*4kB 18732*8kB 9334*16kB 2821*32kB 25*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 489264kB
[100632.148497] Node 0 Normal: 12457*4kB 612*8kB 2*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 58852kB
[100632.148516] 499397 total pagecache pages
[100632.148519] 19997 pages in swap cache
[100632.148523] Swap cache stats: add 6260528, delete 6240531, find 2613818/3350538
[100632.148527] Free swap  = 8052428kB
[100632.148530] Total swap = 8386556kB
[100632.179050] 1048048 pages RAM
[100632.179059] 57808 pages reserved
[100632.179064] 1233332 pages shared
[100632.179072] 771544 pages non-shared
[100637.242844] usbcore: deregistering interface driver bcm5974
[100639.360498] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input19
[100639.360976] usbcore: registered new interface driver bcm5974
[100639.371328] X: page allocation failure: order:4, mode:0xc0d0
[100639.371339] Pid: 692, comm: X Tainted: G        W    3.7.9-1-ARCH #1
[100639.371343] Call Trace:
[100639.371360]  [<ffffffff811266d9>] warn_alloc_failed+0xe9/0x140
[100639.371370]  [<ffffffff81129a36>] ? drain_local_pages+0x16/0x20
[100639.371379]  [<ffffffff8112a17f>] __alloc_pages_nodemask+0x6ef/0x960
[100639.371389]  [<ffffffff81165fd0>] alloc_pages_current+0xb0/0x120
[100639.371397]  [<ffffffff8112598e>] __get_free_pages+0xe/0x50
[100639.371406]  [<ffffffff8116cf49>] kmalloc_order_trace+0x39/0xf0
[100639.371415]  [<ffffffff8116fd8a>] __kmalloc+0x17a/0x190
[100639.371436]  [<ffffffffa04420d5>] evdev_open+0x85/0x1e0 [evdev]
[100639.371445]  [<ffffffff81188340>] ? mount_fs+0x1b0/0x1b0
[100639.371452]  [<ffffffff81188d2b>] chrdev_open+0x9b/0x1c0
[100639.371462]  [<ffffffff81182b43>] do_dentry_open+0x203/0x290
[100639.371469]  [<ffffffff81188c90>] ? cdev_put+0x30/0x30
[100639.371477]  [<ffffffff81182e85>] finish_open+0x35/0x50
[100639.371483]  [<ffffffff81192c1e>] do_last+0x31e/0xeb0
[100639.371492]  [<ffffffff8118fba8>] ? link_path_walk+0x78/0x950
[100639.371500]  [<ffffffff81122589>] ? __generic_file_aio_write+0x1b9/0x3b0
[100639.371507]  [<ffffffff8119386c>] path_openat+0xbc/0x530
[100639.371514]  [<ffffffff81194051>] do_filp_open+0x41/0xa0
[100639.371522]  [<ffffffff811a0f59>] ? __alloc_fd+0xe9/0x140
[100639.371530]  [<ffffffff81183d94>] do_sys_open+0xf4/0x1e0
[100639.371539]  [<ffffffff81183ea1>] sys_open+0x21/0x30
[100639.371550]  [<ffffffff814c365d>] system_call_fastpath+0x1a/0x1f
[100639.371554] Mem-Info:
[100639.371558] Node 0 DMA per-cpu:
[100639.371565] CPU    0: hi:    0, btch:   1 usd:   0
[100639.371569] CPU    1: hi:    0, btch:   1 usd:   0
[100639.371573] CPU    2: hi:    0, btch:   1 usd:   0
[100639.371576] CPU    3: hi:    0, btch:   1 usd:   0
[100639.371579] Node 0 DMA32 per-cpu:
[100639.371585] CPU    0: hi:  186, btch:  31 usd:   0
[100639.371589] CPU    1: hi:  186, btch:  31 usd:   0
[100639.371593] CPU    2: hi:  186, btch:  31 usd:   0
[100639.371597] CPU    3: hi:  186, btch:  31 usd:   0
[100639.371599] Node 0 Normal per-cpu:
[100639.371604] CPU    0: hi:  186, btch:  31 usd:   0
[100639.371608] CPU    1: hi:  186, btch:  31 usd:   0
[100639.371612] CPU    2: hi:  186, btch:  31 usd:   0
[100639.371616] CPU    3: hi:  186, btch:  31 usd:   0
[100639.371626] active_anon:146394 inactive_anon:150811 isolated_anon:0
 active_file:218781 inactive_file:206735 isolated_file:0
 unevictable:5214 dirty:1017 writeback:0 unstable:0
 free:150022 slab_reclaimable:74237 slab_unreclaimable:8253
 mapped:19393 shmem:53019 pagetables:8330 bounce:0
 free_cma:0
[100639.371636] Node 0 DMA free:15360kB min:252kB low:312kB high:376kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15104kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[100639.371648] lowmem_reserve[]: 0 2137 3899 3899
[100639.371658] Node 0 DMA32 free:489564kB min:36904kB low:46128kB high:55356kB active_anon:206816kB inactive_anon:177164kB active_file:541536kB inactive_file:493336kB unevictable:3388kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:3388kB dirty:2704kB writeback:0kB mapped:29904kB shmem:70140kB slab_reclaimable:250200kB slab_unreclaimable:6792kB kernel_stack:2208kB pagetables:6448kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[100639.371671] lowmem_reserve[]: 0 0 1762 1762
[100639.371679] Node 0 Normal free:95164kB min:30420kB low:38024kB high:45628kB active_anon:378760kB inactive_anon:426080kB active_file:333588kB inactive_file:333604kB unevictable:17468kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:17468kB dirty:1364kB writeback:0kB mapped:47668kB shmem:141936kB slab_reclaimable:46748kB slab_unreclaimable:26220kB kernel_stack:1592kB pagetables:26872kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[100639.371692] lowmem_reserve[]: 0 0 0 0
[100639.371699] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15360kB
[100639.371720] Node 0 DMA32: 24592*4kB 18736*8kB 9334*16kB 2821*32kB 25*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 489600kB
[100639.371739] Node 0 Normal: 18231*4kB 2186*8kB 41*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 95164kB
[100639.371759] 499433 total pagecache pages
[100639.371762] 19997 pages in swap cache
[100639.371766] Swap cache stats: add 6260528, delete 6240531, find 2613984/3350704
[100639.371770] Free swap  = 8052428kB
[100639.371773] Total swap = 8386556kB
[100639.402654] 1048048 pages RAM
[100639.402708] 57808 pages reserved
[100639.402725] 1233371 pages shared
[100639.402737] 762389 pages non-shared
[100644.024993] usbcore: deregistering interface driver bcm5974
[100646.932686] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input20
[100646.933137] usbcore: registered new interface driver bcm5974
[100646.948266] X: page allocation failure: order:4, mode:0xc0d0
[100646.948278] Pid: 692, comm: X Tainted: G        W    3.7.9-1-ARCH #1
[100646.948282] Call Trace:
[100646.948301]  [<ffffffff811266d9>] warn_alloc_failed+0xe9/0x140
[100646.948311]  [<ffffffff814b3d72>] ? __alloc_pages_direct_compact+0x1b8/0x1ca
[100646.948321]  [<ffffffff8112a17f>] __alloc_pages_nodemask+0x6ef/0x960
[100646.948331]  [<ffffffff81165fd0>] alloc_pages_current+0xb0/0x120
[100646.948339]  [<ffffffff8112598e>] __get_free_pages+0xe/0x50
[100646.948348]  [<ffffffff8116cf49>] kmalloc_order_trace+0x39/0xf0
[100646.948356]  [<ffffffff8116fd8a>] __kmalloc+0x17a/0x190
[100646.948383]  [<ffffffffa04420d5>] evdev_open+0x85/0x1e0 [evdev]
[100646.948391]  [<ffffffff81188340>] ? mount_fs+0x1b0/0x1b0
[100646.948399]  [<ffffffff81188d2b>] chrdev_open+0x9b/0x1c0
[100646.948408]  [<ffffffff81182b43>] do_dentry_open+0x203/0x290
[100646.948415]  [<ffffffff81188c90>] ? cdev_put+0x30/0x30
[100646.948423]  [<ffffffff81182e85>] finish_open+0x35/0x50
[100646.948430]  [<ffffffff81192c1e>] do_last+0x31e/0xeb0
[100646.948439]  [<ffffffff8118fba8>] ? link_path_walk+0x78/0x950
[100646.948446]  [<ffffffff8119386c>] path_openat+0xbc/0x530
[100646.948453]  [<ffffffff81194051>] do_filp_open+0x41/0xa0
[100646.948460]  [<ffffffff811a0f59>] ? __alloc_fd+0xe9/0x140
[100646.948469]  [<ffffffff81183d94>] do_sys_open+0xf4/0x1e0
[100646.948477]  [<ffffffff81183ea1>] sys_open+0x21/0x30
[100646.948488]  [<ffffffff814c365d>] system_call_fastpath+0x1a/0x1f
[100646.948492] Mem-Info:
[100646.948495] Node 0 DMA per-cpu:
[100646.948502] CPU    0: hi:    0, btch:   1 usd:   0
[100646.948506] CPU    1: hi:    0, btch:   1 usd:   0
[100646.948510] CPU    2: hi:    0, btch:   1 usd:   0
[100646.948514] CPU    3: hi:    0, btch:   1 usd:   0
[100646.948517] Node 0 DMA32 per-cpu:
[100646.948523] CPU    0: hi:  186, btch:  31 usd:   0
[100646.948527] CPU    1: hi:  186, btch:  31 usd:   0
[100646.948531] CPU    2: hi:  186, btch:  31 usd:   0
[100646.948535] CPU    3: hi:  186, btch:  31 usd:   0
[100646.948537] Node 0 Normal per-cpu:
[100646.948542] CPU    0: hi:  186, btch:  31 usd:   0
[100646.948546] CPU    1: hi:  186, btch:  31 usd:   0
[100646.948550] CPU    2: hi:  186, btch:  31 usd:   0
[100646.948554] CPU    3: hi:  186, btch:  31 usd:  31
[100646.948564] active_anon:149533 inactive_anon:150843 isolated_anon:0
 active_file:218798 inactive_file:206730 isolated_file:0
 unevictable:5214 dirty:1077 writeback:0 unstable:0
 free:146794 slab_reclaimable:74237 slab_unreclaimable:8253
 mapped:19408 shmem:53019 pagetables:8344 bounce:0
 free_cma:0
[100646.948574] Node 0 DMA free:15360kB min:252kB low:312kB high:376kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15104kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[100646.948586] lowmem_reserve[]: 0 2137 3899 3899
[100646.948595] Node 0 DMA32 free:490696kB min:36904kB low:46128kB high:55356kB active_anon:205512kB inactive_anon:177292kB active_file:541564kB inactive_file:493308kB unevictable:3388kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:3388kB dirty:2844kB writeback:0kB mapped:29936kB shmem:70140kB slab_reclaimable:250200kB slab_unreclaimable:6792kB kernel_stack:2208kB pagetables:6448kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[100646.948609] lowmem_reserve[]: 0 0 1762 1762
[100646.948616] Node 0 Normal free:81120kB min:30420kB low:38024kB high:45628kB active_anon:392620kB inactive_anon:426080kB active_file:333628kB inactive_file:333612kB unevictable:17468kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:17468kB dirty:1464kB writeback:0kB mapped:47696kB shmem:141936kB slab_reclaimable:46748kB slab_unreclaimable:26220kB kernel_stack:1592kB pagetables:26928kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[100646.948629] lowmem_reserve[]: 0 0 0 0
[100646.948637] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15360kB
[100646.948658] Node 0 DMA32: 24806*4kB 18775*8kB 9333*16kB 2822*32kB 25*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 490784kB
[100646.948677] Node 0 Normal: 16486*4kB 1375*8kB 3*16kB 1*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 81120kB
[100646.948696] 499445 total pagecache pages
[100646.948700] 19997 pages in swap cache
[100646.948704] Swap cache stats: add 6260528, delete 6240531, find 2614153/3350873
[100646.948707] Free swap  = 8052428kB
[100646.948710] Total swap = 8386556kB
[100646.979916] 1048048 pages RAM
[100646.979923] 57808 pages reserved
[100646.979927] 1233392 pages shared
[100646.979931] 765543 pages non-shared
[100661.603547] usbcore: deregistering interface driver bcm5974
[100681.829751] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input21
[100681.831308] usbcore: registered new interface driver bcm5974
[100681.840264] X: page allocation failure: order:4, mode:0xc0d0
[100681.840267] Pid: 692, comm: X Tainted: G        W    3.7.9-1-ARCH #1
[100681.840269] Call Trace:
[100681.840275]  [<ffffffff811266d9>] warn_alloc_failed+0xe9/0x140
[100681.840279]  [<ffffffff81129a36>] ? drain_local_pages+0x16/0x20
[100681.840281]  [<ffffffff8112a17f>] __alloc_pages_nodemask+0x6ef/0x960
[100681.840285]  [<ffffffff81165fd0>] alloc_pages_current+0xb0/0x120
[100681.840287]  [<ffffffff8112598e>] __get_free_pages+0xe/0x50
[100681.840290]  [<ffffffff8116cf49>] kmalloc_order_trace+0x39/0xf0
[100681.840293]  [<ffffffff8116fd8a>] __kmalloc+0x17a/0x190
[100681.840302]  [<ffffffffa04420d5>] evdev_open+0x85/0x1e0 [evdev]
[100681.840305]  [<ffffffff81188340>] ? mount_fs+0x1b0/0x1b0
[100681.840308]  [<ffffffff81188d2b>] chrdev_open+0x9b/0x1c0
[100681.840311]  [<ffffffff81182b43>] do_dentry_open+0x203/0x290
[100681.840313]  [<ffffffff81188c90>] ? cdev_put+0x30/0x30
[100681.840315]  [<ffffffff81182e85>] finish_open+0x35/0x50
[100681.840318]  [<ffffffff81192c1e>] do_last+0x31e/0xeb0
[100681.840321]  [<ffffffff8118fba8>] ? link_path_walk+0x78/0x950
[100681.840323]  [<ffffffff8119386c>] path_openat+0xbc/0x530
[100681.840325]  [<ffffffff81194051>] do_filp_open+0x41/0xa0
[100681.840327]  [<ffffffff811a0f59>] ? __alloc_fd+0xe9/0x140
[100681.840330]  [<ffffffff81183d94>] do_sys_open+0xf4/0x1e0
[100681.840333]  [<ffffffff81183ea1>] sys_open+0x21/0x30
[100681.840337]  [<ffffffff814c365d>] system_call_fastpath+0x1a/0x1f
[100681.840338] Mem-Info:
[100681.840339] Node 0 DMA per-cpu:
[100681.840341] CPU    0: hi:    0, btch:   1 usd:   0
[100681.840343] CPU    1: hi:    0, btch:   1 usd:   0
[100681.840344] CPU    2: hi:    0, btch:   1 usd:   0
[100681.840345] CPU    3: hi:    0, btch:   1 usd:   0
[100681.840346] Node 0 DMA32 per-cpu:
[100681.840348] CPU    0: hi:  186, btch:  31 usd:   0
[100681.840349] CPU    1: hi:  186, btch:  31 usd:   0
[100681.840350] CPU    2: hi:  186, btch:  31 usd:   0
[100681.840351] CPU    3: hi:  186, btch:  31 usd:   0
[100681.840352] Node 0 Normal per-cpu:
[100681.840354] CPU    0: hi:  186, btch:  31 usd:   0
[100681.840355] CPU    1: hi:  186, btch:  31 usd: 115
[100681.840356] CPU    2: hi:  186, btch:  31 usd:   0
[100681.840357] CPU    3: hi:  186, btch:  31 usd:   0
[100681.840360] active_anon:148441 inactive_anon:150872 isolated_anon:0
 active_file:221460 inactive_file:214332 isolated_file:0
 unevictable:5214 dirty:4615 writeback:0 unstable:0
 free:137070 slab_reclaimable:74546 slab_unreclaimable:8288
 mapped:19728 shmem:53024 pagetables:8362 bounce:0
 free_cma:0
[100681.840407] Node 0 DMA free:15360kB min:252kB low:312kB high:376kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15104kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[100681.840411] lowmem_reserve[]: 0 2137 3899 3899
[100681.840414] Node 0 DMA32 free:487888kB min:36904kB low:46128kB high:55356kB active_anon:194856kB inactive_anon:177408kB active_file:545980kB inactive_file:500996kB unevictable:3388kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:3388kB dirty:3380kB writeback:0kB mapped:30148kB shmem:70140kB slab_reclaimable:251448kB slab_unreclaimable:6932kB kernel_stack:2176kB pagetables:6416kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[100681.840418] lowmem_reserve[]: 0 0 1762 1762
[100681.840421] Node 0 Normal free:45156kB min:30420kB low:38024kB high:45628kB active_anon:398908kB inactive_anon:426080kB active_file:339860kB inactive_file:356100kB unevictable:17468kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:17468kB dirty:15080kB writeback:0kB mapped:48764kB shmem:141956kB slab_reclaimable:46736kB slab_unreclaimable:26220kB kernel_stack:1608kB pagetables:27032kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:28 all_unreclaimable? no
[100681.840425] lowmem_reserve[]: 0 0 0 0
[100681.840427] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15360kB
[100681.840434] Node 0 DMA32: 24570*4kB 18658*8kB 9346*16kB 2784*32kB 25*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 487896kB
[100681.840439] Node 0 Normal: 10268*4kB 14*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 45280kB
[100681.840445] 509625 total pagecache pages
[100681.840446] 19996 pages in swap cache
[100681.840448] Swap cache stats: add 6260529, delete 6240533, find 2614458/3351179
[100681.840449] Free swap  = 8052436kB
[100681.840450] Total swap = 8386556kB
[100681.851091] 1048048 pages RAM
[100681.851094] 57808 pages reserved
[100681.851095] 1234821 pages shared
[100681.851097] 774689 pages non-shared
[100706.373311] usbcore: deregistering interface driver bcm5974
[100709.227086] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input22
[100709.229182] usbcore: registered new interface driver bcm5974
[100709.239293] X: page allocation failure: order:4, mode:0xc0d0
[100709.239303] Pid: 692, comm: X Tainted: G        W    3.7.9-1-ARCH #1
[100709.239307] Call Trace:
[100709.239323]  [<ffffffff811266d9>] warn_alloc_failed+0xe9/0x140
[100709.239333]  [<ffffffff81129a36>] ? drain_local_pages+0x16/0x20
[100709.239342]  [<ffffffff8112a17f>] __alloc_pages_nodemask+0x6ef/0x960
[100709.239351]  [<ffffffff81165fd0>] alloc_pages_current+0xb0/0x120
[100709.239359]  [<ffffffff8112598e>] __get_free_pages+0xe/0x50
[100709.239368]  [<ffffffff8116cf49>] kmalloc_order_trace+0x39/0xf0
[100709.239376]  [<ffffffff8116fd8a>] __kmalloc+0x17a/0x190
[100709.239398]  [<ffffffffa04420d5>] evdev_open+0x85/0x1e0 [evdev]
[100709.239407]  [<ffffffff81188340>] ? mount_fs+0x1b0/0x1b0
[100709.239414]  [<ffffffff81188d2b>] chrdev_open+0x9b/0x1c0
[100709.239424]  [<ffffffff81182b43>] do_dentry_open+0x203/0x290
[100709.239430]  [<ffffffff81188c90>] ? cdev_put+0x30/0x30
[100709.239439]  [<ffffffff81182e85>] finish_open+0x35/0x50
[100709.239445]  [<ffffffff81192c1e>] do_last+0x31e/0xeb0
[100709.239454]  [<ffffffff8118fba8>] ? link_path_walk+0x78/0x950
[100709.239462]  [<ffffffff81122589>] ? __generic_file_aio_write+0x1b9/0x3b0
[100709.239469]  [<ffffffff8119386c>] path_openat+0xbc/0x530
[100709.239476]  [<ffffffff81194051>] do_filp_open+0x41/0xa0
[100709.239483]  [<ffffffff811a0f59>] ? __alloc_fd+0xe9/0x140
[100709.239492]  [<ffffffff81183d94>] do_sys_open+0xf4/0x1e0
[100709.239501]  [<ffffffff81183ea1>] sys_open+0x21/0x30
[100709.239512]  [<ffffffff814c365d>] system_call_fastpath+0x1a/0x1f
[100709.239516] Mem-Info:
[100709.239519] Node 0 DMA per-cpu:
[100709.239527] CPU    0: hi:    0, btch:   1 usd:   0
[100709.239531] CPU    1: hi:    0, btch:   1 usd:   0
[100709.239535] CPU    2: hi:    0, btch:   1 usd:   0
[100709.239539] CPU    3: hi:    0, btch:   1 usd:   0
[100709.239542] Node 0 DMA32 per-cpu:
[100709.239548] CPU    0: hi:  186, btch:  31 usd:   0
[100709.239552] CPU    1: hi:  186, btch:  31 usd:   0
[100709.239556] CPU    2: hi:  186, btch:  31 usd:   0
[100709.239560] CPU    3: hi:  186, btch:  31 usd:   0
[100709.239563] Node 0 Normal per-cpu:
[100709.239568] CPU    0: hi:  186, btch:  31 usd:  42
[100709.239573] CPU    1: hi:  186, btch:  31 usd:   0
[100709.239577] CPU    2: hi:  186, btch:  31 usd:  30
[100709.239581] CPU    3: hi:  186, btch:  31 usd:   0
[100709.239592] active_anon:148149 inactive_anon:148694 isolated_anon:0
 active_file:221491 inactive_file:223298 isolated_file:32
 unevictable:5214 dirty:14372 writeback:0 unstable:0
 free:130645 slab_reclaimable:74546 slab_unreclaimable:8286
 mapped:19708 shmem:51488 pagetables:8361 bounce:0
 free_cma:0
[100709.239602] Node 0 DMA free:15360kB min:252kB low:312kB high:376kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15104kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[100709.239615] lowmem_reserve[]: 0 2137 3899 3899
[100709.239624] Node 0 DMA32 free:466464kB min:36904kB low:46128kB high:55356kB active_anon:201924kB inactive_anon:177408kB active_file:546020kB inactive_file:515004kB unevictable:3388kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:3388kB dirty:17492kB writeback:0kB mapped:30100kB shmem:70140kB slab_reclaimable:251448kB slab_unreclaimable:6932kB kernel_stack:2176kB pagetables:6424kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[100709.239638] lowmem_reserve[]: 0 0 1762 1762
[100709.239646] Node 0 Normal free:40756kB min:30420kB low:38024kB high:45628kB active_anon:390672kB inactive_anon:417368kB active_file:339944kB inactive_file:378188kB unevictable:17468kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:17468kB dirty:39996kB writeback:0kB mapped:48732kB shmem:135812kB slab_reclaimable:46736kB slab_unreclaimable:26212kB kernel_stack:1608kB pagetables:27020kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:67 all_unreclaimable? no
[100709.239659] lowmem_reserve[]: 0 0 0 0
[100709.239667] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15360kB
[100709.239687] Node 0 DMA32: 23740*4kB 18312*8kB 8887*16kB 2586*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 466464kB
[100709.239707] Node 0 Normal: 8953*4kB 104*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 40756kB
[100709.239726] 517104 total pagecache pages
[100709.239729] 19996 pages in swap cache
[100709.239734] Swap cache stats: add 6260529, delete 6240533, find 2614596/3351317
[100709.239737] Free swap  = 8052436kB
[100709.239740] Total swap = 8386556kB
[100709.269794] 1048048 pages RAM
[100709.269821] 57808 pages reserved
[100709.269841] 1494665 pages shared
[100709.269859] 781393 pages non-shared
[100710.239459] usbcore: deregistering interface driver bcm5974
[100711.032226] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input23
[100711.032756] usbcore: registered new interface driver bcm5974
[100711.041191] X: page allocation failure: order:4, mode:0xc0d0
[100711.041206] Pid: 692, comm: X Tainted: G        W    3.7.9-1-ARCH #1
[100711.041212] Call Trace:
[100711.041235]  [<ffffffff811266d9>] warn_alloc_failed+0xe9/0x140
[100711.041251]  [<ffffffff81129a36>] ? drain_local_pages+0x16/0x20
[100711.041266]  [<ffffffff8112a17f>] __alloc_pages_nodemask+0x6ef/0x960
[100711.041281]  [<ffffffff81165fd0>] alloc_pages_current+0xb0/0x120
[100711.041294]  [<ffffffff8112598e>] __get_free_pages+0xe/0x50
[100711.041307]  [<ffffffff8116cf49>] kmalloc_order_trace+0x39/0xf0
[100711.041319]  [<ffffffff8116fd8a>] __kmalloc+0x17a/0x190
[100711.041347]  [<ffffffffa04420d5>] evdev_open+0x85/0x1e0 [evdev]
[100711.041359]  [<ffffffff81188340>] ? mount_fs+0x1b0/0x1b0
[100711.041371]  [<ffffffff81188d2b>] chrdev_open+0x9b/0x1c0
[100711.041386]  [<ffffffff81182b43>] do_dentry_open+0x203/0x290
[100711.041396]  [<ffffffff81188c90>] ? cdev_put+0x30/0x30
[100711.041408]  [<ffffffff81182e85>] finish_open+0x35/0x50
[100711.041418]  [<ffffffff81192c1e>] do_last+0x31e/0xeb0
[100711.041431]  [<ffffffff8118fba8>] ? link_path_walk+0x78/0x950
[100711.041443]  [<ffffffff81122589>] ? __generic_file_aio_write+0x1b9/0x3b0
[100711.041454]  [<ffffffff8119386c>] path_openat+0xbc/0x530
[100711.041465]  [<ffffffff81194051>] do_filp_open+0x41/0xa0
[100711.041477]  [<ffffffff811a0f59>] ? __alloc_fd+0xe9/0x140
[100711.041490]  [<ffffffff81183d94>] do_sys_open+0xf4/0x1e0
[100711.041502]  [<ffffffff81183ea1>] sys_open+0x21/0x30
[100711.041517]  [<ffffffff814c365d>] system_call_fastpath+0x1a/0x1f
[100711.041524] Mem-Info:
[100711.041529] Node 0 DMA per-cpu:
[100711.041540] CPU    0: hi:    0, btch:   1 usd:   0
[100711.041547] CPU    1: hi:    0, btch:   1 usd:   0
[100711.041553] CPU    2: hi:    0, btch:   1 usd:   0
[100711.041559] CPU    3: hi:    0, btch:   1 usd:   0
[100711.041564] Node 0 DMA32 per-cpu:
[100711.041574] CPU    0: hi:  186, btch:  31 usd:   0
[100711.041582] CPU    1: hi:  186, btch:  31 usd:   0
[100711.041588] CPU    2: hi:  186, btch:  31 usd:   0
[100711.041595] CPU    3: hi:  186, btch:  31 usd:   0
[100711.041600] Node 0 Normal per-cpu:
[100711.041609] CPU    0: hi:  186, btch:  31 usd:   0
[100711.041616] CPU    1: hi:  186, btch:  31 usd:   0
[100711.041624] CPU    2: hi:  186, btch:  31 usd:  31
[100711.041632] CPU    3: hi:  186, btch:  31 usd:  30
[100711.041650] active_anon:148188 inactive_anon:148696 isolated_anon:0
 active_file:221501 inactive_file:222188 isolated_file:0
 unevictable:5214 dirty:15122 writeback:0 unstable:0
 free:132036 slab_reclaimable:74303 slab_unreclaimable:8286
 mapped:19754 shmem:51489 pagetables:8361 bounce:0
 free_cma:0
[100711.041665] Node 0 DMA free:15360kB min:252kB low:312kB high:376kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15104kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[100711.041678] lowmem_reserve[]: 0 2137 3899 3899
[100711.041687] Node 0 DMA32 free:467392kB min:36904kB low:46128kB high:55356kB active_anon:202064kB inactive_anon:177412kB active_file:546032kB inactive_file:515056kB unevictable:3388kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:3388kB dirty:17760kB writeback:0kB mapped:30196kB shmem:70144kB slab_reclaimable:250488kB slab_unreclaimable:6932kB kernel_stack:2176kB pagetables:6428kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:32 all_unreclaimable? no
[100711.041701] lowmem_reserve[]: 0 0 1762 1762
[100711.041709] Node 0 Normal free:45268kB min:30420kB low:38024kB high:45628kB active_anon:390688kB inactive_anon:417372kB active_file:339972kB inactive_file:373696kB unevictable:17468kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:17468kB dirty:42728kB writeback:0kB mapped:48820kB shmem:135812kB slab_reclaimable:46724kB slab_unreclaimable:26212kB kernel_stack:1608kB pagetables:27016kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[100711.041722] lowmem_reserve[]: 0 0 0 0
[100711.041729] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15360kB
[100711.041750] Node 0 DMA32: 23765*4kB 18313*8kB 8886*16kB 2614*32kB 2*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 467516kB
[100711.041768] Node 0 Normal: 9973*4kB 158*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 45268kB
[100711.041788] 516034 total pagecache pages
[100711.041791] 19996 pages in swap cache
[100711.041795] Swap cache stats: add 6260529, delete 6240533, find 2614596/3351317
[100711.041798] Free swap  = 8052436kB
[100711.041801] Total swap = 8386556kB
[100711.072569] 1048048 pages RAM
[100711.072576] 57808 pages reserved
[100711.072580] 1232517 pages shared
[100711.072584] 781479 pages non-shared
[100712.604025] usbcore: deregistering interface driver bcm5974
[100715.377490] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input24
[100715.378423] usbcore: registered new interface driver bcm5974
[100715.390439] X: page allocation failure: order:4, mode:0xc0d0
[100715.390450] Pid: 692, comm: X Tainted: G        W    3.7.9-1-ARCH #1
[100715.390454] Call Trace:
[100715.390472]  [<ffffffff811266d9>] warn_alloc_failed+0xe9/0x140
[100715.390482]  [<ffffffff81129a36>] ? drain_local_pages+0x16/0x20
[100715.390491]  [<ffffffff8112a17f>] __alloc_pages_nodemask+0x6ef/0x960
[100715.390501]  [<ffffffff81165fd0>] alloc_pages_current+0xb0/0x120
[100715.390510]  [<ffffffff8112598e>] __get_free_pages+0xe/0x50
[100715.390518]  [<ffffffff8116cf49>] kmalloc_order_trace+0x39/0xf0
[100715.390527]  [<ffffffff8116fd8a>] __kmalloc+0x17a/0x190
[100715.390551]  [<ffffffffa04420d5>] evdev_open+0x85/0x1e0 [evdev]
[100715.390560]  [<ffffffff81188340>] ? mount_fs+0x1b0/0x1b0
[100715.390568]  [<ffffffff81188d2b>] chrdev_open+0x9b/0x1c0
[100715.390577]  [<ffffffff81182b43>] do_dentry_open+0x203/0x290
[100715.390584]  [<ffffffff81188c90>] ? cdev_put+0x30/0x30
[100715.390592]  [<ffffffff81182e85>] finish_open+0x35/0x50
[100715.390599]  [<ffffffff81192c1e>] do_last+0x31e/0xeb0
[100715.390608]  [<ffffffff8118fba8>] ? link_path_walk+0x78/0x950
[100715.390616]  [<ffffffff81122589>] ? __generic_file_aio_write+0x1b9/0x3b0
[100715.390623]  [<ffffffff8119386c>] path_openat+0xbc/0x530
[100715.390630]  [<ffffffff81194051>] do_filp_open+0x41/0xa0
[100715.390638]  [<ffffffff811a0f59>] ? __alloc_fd+0xe9/0x140
[100715.390647]  [<ffffffff81183d94>] do_sys_open+0xf4/0x1e0
[100715.390655]  [<ffffffff81183ea1>] sys_open+0x21/0x30
[100715.390667]  [<ffffffff814c365d>] system_call_fastpath+0x1a/0x1f
[100715.390671] Mem-Info:
[100715.390675] Node 0 DMA per-cpu:
[100715.390681] CPU    0: hi:    0, btch:   1 usd:   0
[100715.390686] CPU    1: hi:    0, btch:   1 usd:   0
[100715.390689] CPU    2: hi:    0, btch:   1 usd:   0
[100715.390693] CPU    3: hi:    0, btch:   1 usd:   0
[100715.390879] Node 0 DMA32 per-cpu:
[100715.390887] CPU    0: hi:  186, btch:  31 usd:   0
[100715.390893] CPU    1: hi:  186, btch:  31 usd:   0
[100715.390899] CPU    2: hi:  186, btch:  31 usd:   0
[100715.390905] CPU    3: hi:  186, btch:  31 usd:   0
[100715.390909] Node 0 Normal per-cpu:
[100715.390916] CPU    0: hi:  186, btch:  31 usd:   0
[100715.390923] CPU    1: hi:  186, btch:  31 usd: 159
[100715.390929] CPU    2: hi:  186, btch:  31 usd:   0
[100715.390935] CPU    3: hi:  186, btch:  31 usd:   0
[100715.390950] active_anon:148205 inactive_anon:148726 isolated_anon:0
 active_file:221516 inactive_file:223327 isolated_file:0
 unevictable:5214 dirty:16901 writeback:6 unstable:0
 free:130704 slab_reclaimable:74303 slab_unreclaimable:8286
 mapped:19731 shmem:51488 pagetables:8350 bounce:0
 free_cma:0
[100715.390993] Node 0 DMA free:15360kB min:252kB low:312kB high:376kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15104kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[100715.391014] lowmem_reserve[]: 0 2137 3899 3899
[100715.391196] Node 0 DMA32 free:466112kB min:36904kB low:46128kB high:55356kB active_anon:201948kB inactive_anon:177536kB active_file:546040kB inactive_file:516116kB unevictable:3388kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:3388kB dirty:18976kB writeback:16kB mapped:30144kB shmem:70140kB slab_reclaimable:250488kB slab_unreclaimable:6932kB kernel_stack:2168kB pagetables:6432kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[100715.391222] lowmem_reserve[]: 0 0 1762 1762
[100715.391236] Node 0 Normal free:41592kB min:30420kB low:38024kB high:45628kB active_anon:390872kB inactive_anon:417368kB active_file:340024kB inactive_file:376940kB unevictable:17468kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:17468kB dirty:48628kB writeback:8kB mapped:48780kB shmem:135812kB slab_reclaimable:46724kB slab_unreclaimable:26212kB kernel_stack:1608kB pagetables:26968kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[100715.391259] lowmem_reserve[]: 0 0 0 0
[100715.391272] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15360kB
[100715.391292] Node 0 DMA32: 23655*4kB 18259*8kB 8872*16kB 2610*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 466164kB
[100715.391311] Node 0 Normal: 9180*4kB 97*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 41592kB
[100715.391331] 517153 total pagecache pages
[100715.391334] 19996 pages in swap cache
[100715.391339] Swap cache stats: add 6260529, delete 6240533, find 2614598/3351319
[100715.391396] Free swap  = 8052436kB
[100715.391399] Total swap = 8386556kB
[100715.411950] 1048048 pages RAM
[100715.411952] 57808 pages reserved
[100715.411953] 1232529 pages shared
[100715.411954] 781571 pages non-shared
[100728.400746] usbcore: deregistering interface driver bcm5974
[100728.743272] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input25
[100728.743429] usbcore: registered new interface driver bcm5974
[100728.744568] usbcore: deregistering interface driver bcm5974
[100729.079482] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input26
[100729.079603] usbcore: registered new interface driver bcm5974
[100729.080850] usbcore: deregistering interface driver bcm5974
[100729.425588] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input27
[100729.425724] usbcore: registered new interface driver bcm5974
[100729.428035] usbcore: deregistering interface driver bcm5974
[100729.774876] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input28
[100729.775001] usbcore: registered new interface driver bcm5974
[100729.776146] usbcore: deregistering interface driver bcm5974
[100730.127752] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input29
[100730.127886] usbcore: registered new interface driver bcm5974
[100730.128994] usbcore: deregistering interface driver bcm5974
[100730.467047] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input30
[100730.467210] usbcore: registered new interface driver bcm5974
[100730.469140] usbcore: deregistering interface driver bcm5974
[100730.823347] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input31
[100730.823475] usbcore: registered new interface driver bcm5974
[100730.825882] usbcore: deregistering interface driver bcm5974
[100730.827710] X: page allocation failure: order:4, mode:0xc0d0
[100730.827714] Pid: 692, comm: X Tainted: G        W    3.7.9-1-ARCH #1
[100730.827716] Call Trace:
[100730.827724]  [<ffffffff811266d9>] warn_alloc_failed+0xe9/0x140
[100730.827728]  [<ffffffff81129a36>] ? drain_local_pages+0x16/0x20
[100730.827732]  [<ffffffff8112a17f>] __alloc_pages_nodemask+0x6ef/0x960
[100730.827737]  [<ffffffff81165fd0>] alloc_pages_current+0xb0/0x120
[100730.827740]  [<ffffffff8112598e>] __get_free_pages+0xe/0x50
[100730.827745]  [<ffffffff8116cf49>] kmalloc_order_trace+0x39/0xf0
[100730.827748]  [<ffffffff8116fd8a>] __kmalloc+0x17a/0x190
[100730.827761]  [<ffffffffa04420d5>] evdev_open+0x85/0x1e0 [evdev]
[100730.827764]  [<ffffffff81188340>] ? mount_fs+0x1b0/0x1b0
[100730.827768]  [<ffffffff81188d2b>] chrdev_open+0x9b/0x1c0
[100730.827773]  [<ffffffff81182b43>] do_dentry_open+0x203/0x290
[100730.827776]  [<ffffffff81188c90>] ? cdev_put+0x30/0x30
[100730.827780]  [<ffffffff81182e85>] finish_open+0x35/0x50
[100730.827783]  [<ffffffff81192c1e>] do_last+0x31e/0xeb0
[100730.827787]  [<ffffffff8118fba8>] ? link_path_walk+0x78/0x950
[100730.827790]  [<ffffffff81122589>] ? __generic_file_aio_write+0x1b9/0x3b0
[100730.827793]  [<ffffffff8119386c>] path_openat+0xbc/0x530
[100730.827796]  [<ffffffff81194051>] do_filp_open+0x41/0xa0
[100730.827800]  [<ffffffff811a0f59>] ? __alloc_fd+0xe9/0x140
[100730.827803]  [<ffffffff81183d94>] do_sys_open+0xf4/0x1e0
[100730.827807]  [<ffffffff81183ea1>] sys_open+0x21/0x30
[100730.827812]  [<ffffffff814c365d>] system_call_fastpath+0x1a/0x1f
[100730.827814] Mem-Info:
[100730.827816] Node 0 DMA per-cpu:
[100730.827819] CPU    0: hi:    0, btch:   1 usd:   0
[100730.827821] CPU    1: hi:    0, btch:   1 usd:   0
[100730.827823] CPU    2: hi:    0, btch:   1 usd:   0
[100730.827824] CPU    3: hi:    0, btch:   1 usd:   0
[100730.827825] Node 0 DMA32 per-cpu:
[100730.827828] CPU    0: hi:  186, btch:  31 usd:   0
[100730.827830] CPU    1: hi:  186, btch:  31 usd:   0
[100730.827832] CPU    2: hi:  186, btch:  31 usd:   0
[100730.827833] CPU    3: hi:  186, btch:  31 usd:   0
[100730.827835] Node 0 Normal per-cpu:
[100730.827838] CPU    0: hi:  186, btch:  31 usd: 112
[100730.827839] CPU    1: hi:  186, btch:  31 usd:   0
[100730.827841] CPU    2: hi:  186, btch:  31 usd:   0
[100730.827844] CPU    3: hi:  186, btch:  31 usd:   0
[100730.827848] active_anon:149704 inactive_anon:148725 isolated_anon:0
 active_file:240324 inactive_file:207097 isolated_file:0
 unevictable:5214 dirty:21447 writeback:0 unstable:0
 free:126943 slab_reclaimable:73981 slab_unreclaimable:8298
 mapped:19752 shmem:51488 pagetables:8393 bounce:0
 free_cma:0
[100730.827853] Node 0 DMA free:15360kB min:252kB low:312kB high:376kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15104kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[100730.827859] lowmem_reserve[]: 0 2137 3899 3899
[100730.827863] Node 0 DMA32 free:452128kB min:36904kB low:46128kB high:55356kB active_anon:208364kB inactive_anon:177536kB active_file:570376kB inactive_file:500672kB unevictable:3388kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:3388kB dirty:27936kB writeback:0kB mapped:30188kB shmem:70144kB slab_reclaimable:249208kB slab_unreclaimable:6972kB kernel_stack:2192kB pagetables:6568kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[100730.827868] lowmem_reserve[]: 0 0 1762 1762
[100730.827872] Node 0 Normal free:40284kB min:30420kB low:38024kB high:45628kB active_anon:390452kB inactive_anon:417364kB active_file:390696kB inactive_file:327848kB unevictable:17468kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:17468kB dirty:57852kB writeback:0kB mapped:48820kB shmem:135808kB slab_reclaimable:46716kB slab_unreclaimable:26220kB kernel_stack:1608kB pagetables:27004kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:331 all_unreclaimable? no
[100730.827878] lowmem_reserve[]: 0 0 0 0
[100730.827882] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15360kB
[100730.827891] Node 0 DMA32: 23694*4kB 18319*8kB 8903*16kB 2134*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 452128kB
[100730.827900] Node 0 Normal: 9015*4kB 16*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 40284kB
[100730.827909] 519770 total pagecache pages
[100730.827910] 19996 pages in swap cache
[100730.827912] Swap cache stats: add 6260529, delete 6240533, find 2614790/3351511
[100730.827914] Free swap  = 8052436kB
[100730.827915] Total swap = 8386556kB
[100730.839066] 1048048 pages RAM
[100730.839072] 57808 pages reserved
[100730.839079] 1232930 pages shared
[100730.839086] 785087 pages non-shared
[100731.165755] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input32
[100731.165886] usbcore: registered new interface driver bcm5974
[100731.168746] usbcore: deregistering interface driver bcm5974
[100731.506247] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input33
[100731.506667] usbcore: registered new interface driver bcm5974
[100731.509264] usbcore: deregistering interface driver bcm5974
[100731.510447] X: page allocation failure: order:4, mode:0xc0d0
[100731.510452] Pid: 692, comm: X Tainted: G        W    3.7.9-1-ARCH #1
[100731.510453] Call Trace:
[100731.510461]  [<ffffffff811266d9>] warn_alloc_failed+0xe9/0x140
[100731.510465]  [<ffffffff81129a36>] ? drain_local_pages+0x16/0x20
[100731.510470]  [<ffffffff8112a17f>] __alloc_pages_nodemask+0x6ef/0x960
[100731.510474]  [<ffffffff81165fd0>] alloc_pages_current+0xb0/0x120
[100731.510477]  [<ffffffff8112598e>] __get_free_pages+0xe/0x50
[100731.510481]  [<ffffffff8116cf49>] kmalloc_order_trace+0x39/0xf0
[100731.510485]  [<ffffffff8116fd8a>] __kmalloc+0x17a/0x190
[100731.510495]  [<ffffffffa04420d5>] evdev_open+0x85/0x1e0 [evdev]
[100731.510498]  [<ffffffff81188340>] ? mount_fs+0x1b0/0x1b0
[100731.510501]  [<ffffffff81188d2b>] chrdev_open+0x9b/0x1c0
[100731.510504]  [<ffffffff81182b43>] do_dentry_open+0x203/0x290
[100731.510506]  [<ffffffff81188c90>] ? cdev_put+0x30/0x30
[100731.510508]  [<ffffffff81182e85>] finish_open+0x35/0x50
[100731.510510]  [<ffffffff81192c1e>] do_last+0x31e/0xeb0
[100731.510513]  [<ffffffff8118fba8>] ? link_path_walk+0x78/0x950
[100731.510516]  [<ffffffff81122589>] ? __generic_file_aio_write+0x1b9/0x3b0
[100731.510518]  [<ffffffff8119386c>] path_openat+0xbc/0x530
[100731.510520]  [<ffffffff81194051>] do_filp_open+0x41/0xa0
[100731.510523]  [<ffffffff811a0f59>] ? __alloc_fd+0xe9/0x140
[100731.510525]  [<ffffffff81183d94>] do_sys_open+0xf4/0x1e0
[100731.510528]  [<ffffffff81183ea1>] sys_open+0x21/0x30
[100731.510532]  [<ffffffff814c365d>] system_call_fastpath+0x1a/0x1f
[100731.510533] Mem-Info:
[100731.510535] Node 0 DMA per-cpu:
[100731.510537] CPU    0: hi:    0, btch:   1 usd:   0
[100731.510538] CPU    1: hi:    0, btch:   1 usd:   0
[100731.510539] CPU    2: hi:    0, btch:   1 usd:   0
[100731.510540] CPU    3: hi:    0, btch:   1 usd:   0
[100731.510541] Node 0 DMA32 per-cpu:
[100731.510543] CPU    0: hi:  186, btch:  31 usd:   0
[100731.510544] CPU    1: hi:  186, btch:  31 usd:   0
[100731.510546] CPU    2: hi:  186, btch:  31 usd:   0
[100731.510547] CPU    3: hi:  186, btch:  31 usd:   0
[100731.510548] Node 0 Normal per-cpu:
[100731.510549] CPU    0: hi:  186, btch:  31 usd:   0
[100731.510550] CPU    1: hi:  186, btch:  31 usd:  27
[100731.510551] CPU    2: hi:  186, btch:  31 usd:  32
[100731.510553] CPU    3: hi:  186, btch:  31 usd:   0
[100731.510556] active_anon:149171 inactive_anon:148725 isolated_anon:0
 active_file:238467 inactive_file:207353 isolated_file:0
 unevictable:5214 dirty:21447 writeback:0 unstable:0
 free:129460 slab_reclaimable:73621 slab_unreclaimable:8298
 mapped:19752 shmem:51488 pagetables:8393 bounce:0
 free_cma:0
[100731.510559] Node 0 DMA free:15360kB min:252kB low:312kB high:376kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15104kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[100731.510563] lowmem_reserve[]: 0 2137 3899 3899
[100731.510565] Node 0 DMA32 free:453868kB min:36904kB low:46128kB high:55356kB active_anon:208216kB inactive_anon:177536kB active_file:570376kB inactive_file:500672kB unevictable:3388kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:3388kB dirty:27936kB writeback:0kB mapped:30188kB shmem:70144kB slab_reclaimable:247768kB slab_unreclaimable:6972kB kernel_stack:2192kB pagetables:6568kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:32 all_unreclaimable? no
[100731.510570] lowmem_reserve[]: 0 0 1762 1762
[100731.510572] Node 0 Normal free:48612kB min:30420kB low:38024kB high:45628kB active_anon:388468kB inactive_anon:417364kB active_file:383492kB inactive_file:328740kB unevictable:17468kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:17468kB dirty:57852kB writeback:0kB mapped:48820kB shmem:135808kB slab_reclaimable:46716kB slab_unreclaimable:26220kB kernel_stack:1608kB pagetables:27004kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:18 all_unreclaimable? no
[100731.510576] lowmem_reserve[]: 0 0 0 0
[100731.510578] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15360kB
[100731.510585] Node 0 DMA32: 23726*4kB 18314*8kB 8901*16kB 2186*32kB 2*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 453912kB
[100731.510590] Node 0 Normal: 10947*4kB 87*8kB 2*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 48612kB
[100731.510596] 518252 total pagecache pages
[100731.510597] 19996 pages in swap cache
[100731.510599] Swap cache stats: add 6260529, delete 6240533, find 2614790/3351511
[100731.510600] Free swap  = 8052436kB
[100731.510601] Total swap = 8386556kB
[100731.521571] 1048048 pages RAM
[100731.521574] 57808 pages reserved
[100731.521575] 1232965 pages shared
[100731.521576] 784039 pages non-shared
[100731.851528] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input34
[100731.851922] usbcore: registered new interface driver bcm5974
[100731.854095] usbcore: deregistering interface driver bcm5974
[100731.854456] X: page allocation failure: order:4, mode:0xc0d0
[100731.854460] Pid: 692, comm: X Tainted: G        W    3.7.9-1-ARCH #1
[100731.854462] Call Trace:
[100731.854469]  [<ffffffff811266d9>] warn_alloc_failed+0xe9/0x140
[100731.854474]  [<ffffffff81129a36>] ? drain_local_pages+0x16/0x20
[100731.854478]  [<ffffffff8112a17f>] __alloc_pages_nodemask+0x6ef/0x960
[100731.854482]  [<ffffffff81165fd0>] alloc_pages_current+0xb0/0x120
[100731.854486]  [<ffffffff8112598e>] __get_free_pages+0xe/0x50
[100731.854490]  [<ffffffff8116cf49>] kmalloc_order_trace+0x39/0xf0
[100731.854494]  [<ffffffff8116fd8a>] __kmalloc+0x17a/0x190
[100731.854504]  [<ffffffffa04420d5>] evdev_open+0x85/0x1e0 [evdev]
[100731.854508]  [<ffffffff81188340>] ? mount_fs+0x1b0/0x1b0
[100731.854512]  [<ffffffff81188d2b>] chrdev_open+0x9b/0x1c0
[100731.854516]  [<ffffffff81182b43>] do_dentry_open+0x203/0x290
[100731.854519]  [<ffffffff81188c90>] ? cdev_put+0x30/0x30
[100731.854521]  [<ffffffff81182e85>] finish_open+0x35/0x50
[100731.854524]  [<ffffffff81192c1e>] do_last+0x31e/0xeb0
[100731.854527]  [<ffffffff8118fba8>] ? link_path_walk+0x78/0x950
[100731.854529]  [<ffffffff81122589>] ? __generic_file_aio_write+0x1b9/0x3b0
[100731.854531]  [<ffffffff8119386c>] path_openat+0xbc/0x530
[100731.854533]  [<ffffffff81194051>] do_filp_open+0x41/0xa0
[100731.854536]  [<ffffffff811a0f59>] ? __alloc_fd+0xe9/0x140
[100731.854539]  [<ffffffff81183d94>] do_sys_open+0xf4/0x1e0
[100731.854541]  [<ffffffff81183ea1>] sys_open+0x21/0x30
[100731.854546]  [<ffffffff814c365d>] system_call_fastpath+0x1a/0x1f
[100731.854547] Mem-Info:
[100731.854548] Node 0 DMA per-cpu:
[100731.854551] CPU    0: hi:    0, btch:   1 usd:   0
[100731.854552] CPU    1: hi:    0, btch:   1 usd:   0
[100731.854553] CPU    2: hi:    0, btch:   1 usd:   0
[100731.854554] CPU    3: hi:    0, btch:   1 usd:   0
[100731.854555] Node 0 DMA32 per-cpu:
[100731.854557] CPU    0: hi:  186, btch:  31 usd:   0
[100731.854558] CPU    1: hi:  186, btch:  31 usd:   0
[100731.854560] CPU    2: hi:  186, btch:  31 usd:   0
[100731.854561] CPU    3: hi:  186, btch:  31 usd:   0
[100731.854562] Node 0 Normal per-cpu:
[100731.854563] CPU    0: hi:  186, btch:  31 usd:   0
[100731.854564] CPU    1: hi:  186, btch:  31 usd:   0
[100731.854565] CPU    2: hi:  186, btch:  31 usd:  32
[100731.854567] CPU    3: hi:  186, btch:  31 usd:   0
[100731.854570] active_anon:149134 inactive_anon:148759 isolated_anon:0
 active_file:238414 inactive_file:207395 isolated_file:0
 unevictable:5214 dirty:21535 writeback:0 unstable:0
 free:129546 slab_reclaimable:73610 slab_unreclaimable:8294
 mapped:19790 shmem:51490 pagetables:8394 bounce:0
 free_cma:0
[100731.854573] Node 0 DMA free:15360kB min:252kB low:312kB high:376kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15104kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[100731.854577] lowmem_reserve[]: 0 2137 3899 3899
[100731.854579] Node 0 DMA32 free:453888kB min:36904kB low:46128kB high:55356kB active_anon:208096kB inactive_anon:177664kB active_file:570400kB inactive_file:500656kB unevictable:3388kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:3388kB dirty:28168kB writeback:0kB mapped:30304kB shmem:70140kB slab_reclaimable:247736kB slab_unreclaimable:6964kB kernel_stack:2192kB pagetables:6440kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:32 all_unreclaimable? no
[100731.854584] lowmem_reserve[]: 0 0 1762 1762
[100731.854586] Node 0 Normal free:48936kB min:30420kB low:38024kB high:45628kB active_anon:388440kB inactive_anon:417372kB active_file:383256kB inactive_file:328924kB unevictable:17468kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:17468kB dirty:57972kB writeback:0kB mapped:48856kB shmem:135820kB slab_reclaimable:46704kB slab_unreclaimable:26212kB kernel_stack:1608kB pagetables:27136kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:38 all_unreclaimable? no
[100731.854590] lowmem_reserve[]: 0 0 0 0
[100731.854592] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15360kB
[100731.854599] Node 0 DMA32: 23726*4kB 18314*8kB 8901*16kB 2185*32kB 2*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 453880kB
[100731.854604] Node 0 Normal: 11026*4kB 88*8kB 2*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 48936kB
[100731.854610] 518176 total pagecache pages
[100731.854612] 19996 pages in swap cache
[100731.854613] Swap cache stats: add 6260529, delete 6240533, find 2614790/3351511
[100731.854614] Free swap  = 8052436kB
[100731.854615] Total swap = 8386556kB
[100731.865369] 1048048 pages RAM
[100731.865372] 57808 pages reserved
[100731.865374] 1233084 pages shared
[100731.865375] 783980 pages non-shared
[100732.187950] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input35
[100732.188077] usbcore: registered new interface driver bcm5974
[100732.189370] usbcore: deregistering interface driver bcm5974
[100732.533884] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input36
[100732.534006] usbcore: registered new interface driver bcm5974
[100732.535174] usbcore: deregistering interface driver bcm5974
[100745.804990] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input37
[100745.805900] usbcore: registered new interface driver bcm5974
[100745.812062] X: page allocation failure: order:4, mode:0xc0d0
[100745.812066] Pid: 692, comm: X Tainted: G        W    3.7.9-1-ARCH #1
[100745.812067] Call Trace:
[100745.812074]  [<ffffffff811266d9>] warn_alloc_failed+0xe9/0x140
[100745.812077]  [<ffffffff8112a17f>] __alloc_pages_nodemask+0x6ef/0x960
[100745.812081]  [<ffffffff81165fd0>] alloc_pages_current+0xb0/0x120
[100745.812083]  [<ffffffff8112598e>] __get_free_pages+0xe/0x50
[100745.812086]  [<ffffffff8116cf49>] kmalloc_order_trace+0x39/0xf0
[100745.812089]  [<ffffffff8116fd8a>] __kmalloc+0x17a/0x190
[100745.812099]  [<ffffffffa04420d5>] evdev_open+0x85/0x1e0 [evdev]
[100745.812102]  [<ffffffff81188340>] ? mount_fs+0x1b0/0x1b0
[100745.812104]  [<ffffffff81188d2b>] chrdev_open+0x9b/0x1c0
[100745.812107]  [<ffffffff81182b43>] do_dentry_open+0x203/0x290
[100745.812110]  [<ffffffff81188c90>] ? cdev_put+0x30/0x30
[100745.812112]  [<ffffffff81182e85>] finish_open+0x35/0x50
[100745.812114]  [<ffffffff81192c1e>] do_last+0x31e/0xeb0
[100745.812117]  [<ffffffff8118fba8>] ? link_path_walk+0x78/0x950
[100745.812120]  [<ffffffff81122589>] ? __generic_file_aio_write+0x1b9/0x3b0
[100745.812122]  [<ffffffff8119386c>] path_openat+0xbc/0x530
[100745.812124]  [<ffffffff81194051>] do_filp_open+0x41/0xa0
[100745.812126]  [<ffffffff811a0f59>] ? __alloc_fd+0xe9/0x140
[100745.812129]  [<ffffffff81183d94>] do_sys_open+0xf4/0x1e0
[100745.812132]  [<ffffffff81183ea1>] sys_open+0x21/0x30
[100745.812136]  [<ffffffff814c365d>] system_call_fastpath+0x1a/0x1f
[100745.812137] Mem-Info:
[100745.812138] Node 0 DMA per-cpu:
[100745.812140] CPU    0: hi:    0, btch:   1 usd:   0
[100745.812141] CPU    1: hi:    0, btch:   1 usd:   0
[100745.812143] CPU    2: hi:    0, btch:   1 usd:   0
[100745.812208] CPU    3: hi:    0, btch:   1 usd:   0
[100745.812209] Node 0 DMA32 per-cpu:
[100745.812210] CPU    0: hi:  186, btch:  31 usd:   0
[100745.812212] CPU    1: hi:  186, btch:  31 usd:   0
[100745.812213] CPU    2: hi:  186, btch:  31 usd:   0
[100745.812214] CPU    3: hi:  186, btch:  31 usd:   0
[100745.812215] Node 0 Normal per-cpu:
[100745.812216] CPU    0: hi:  186, btch:  31 usd:   2
[100745.812218] CPU    1: hi:  186, btch:  31 usd:   0
[100745.812219] CPU    2: hi:  186, btch:  31 usd:   0
[100745.812220] CPU    3: hi:  186, btch:  31 usd:  15
[100745.812223] active_anon:168700 inactive_anon:155495 isolated_anon:0
 active_file:219300 inactive_file:227947 isolated_file:0
 unevictable:5214 dirty:64250 writeback:6256 unstable:0
 free:102763 slab_reclaimable:65566 slab_unreclaimable:13295
 mapped:20078 shmem:51490 pagetables:8470 bounce:0
 free_cma:0
[100745.812226] Node 0 DMA free:15360kB min:252kB low:312kB high:376kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15104kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[100745.812230] lowmem_reserve[]: 0 2137 3899 3899
[100745.812233] Node 0 DMA32 free:328264kB min:36904kB low:46128kB high:55356kB active_anon:244224kB inactive_anon:190984kB active_file:571276kB inactive_file:605808kB unevictable:3388kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:3388kB dirty:57012kB writeback:25024kB mapped:30828kB shmem:70140kB slab_reclaimable:216080kB slab_unreclaimable:8772kB kernel_stack:2152kB pagetables:6520kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[100745.812237] lowmem_reserve[]: 0 0 1762 1762
[100745.812240] Node 0 Normal free:67428kB min:30420kB low:38024kB high:45628kB active_anon:430576kB inactive_anon:430996kB active_file:305924kB inactive_file:305980kB unevictable:17468kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:17468kB dirty:199988kB writeback:0kB mapped:49484kB shmem:135820kB slab_reclaimable:46184kB slab_unreclaimable:44408kB kernel_stack:1608kB pagetables:27360kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[100745.812307] lowmem_reserve[]: 0 0 0 0
[100745.812310] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15360kB
[100745.812316] Node 0 DMA32: 23919*4kB 18454*8kB 4831*16kB 239*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 328252kB
[100745.812322] Node 0 Normal: 14237*4kB 792*8kB 21*16kB 1*32kB 1*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 67428kB
[100745.812328] 519087 total pagecache pages
[100745.812329] 19449 pages in swap cache
[100745.812330] Swap cache stats: add 6260542, delete 6241093, find 2614968/3351692
[100745.812331] Free swap  = 8052440kB
[100745.812332] Total swap = 8386556kB
[100745.822130] 1048048 pages RAM
[100745.822133] 57808 pages reserved
[100745.822135] 1232516 pages shared
[100745.822136] 812256 pages non-shared
[100746.311376] usbcore: deregistering interface driver bcm5974
[100746.630153] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input38
[100746.630357] usbcore: registered new interface driver bcm5974
[100746.632810] X: page allocation failure: order:4, mode:0xc0d0
[100746.632812] Pid: 692, comm: X Tainted: G        W    3.7.9-1-ARCH #1
[100746.632814] Call Trace:
[100746.632820]  [<ffffffff811266d9>] warn_alloc_failed+0xe9/0x140
[100746.632823]  [<ffffffff81129a36>] ? drain_local_pages+0x16/0x20
[100746.632826]  [<ffffffff8112a17f>] __alloc_pages_nodemask+0x6ef/0x960
[100746.632830]  [<ffffffff81165fd0>] alloc_pages_current+0xb0/0x120
[100746.632832]  [<ffffffff8112598e>] __get_free_pages+0xe/0x50
[100746.632835]  [<ffffffff8116cf49>] kmalloc_order_trace+0x39/0xf0
[100746.632838]  [<ffffffff8116fd8a>] __kmalloc+0x17a/0x190
[100746.632846]  [<ffffffffa04420d5>] evdev_open+0x85/0x1e0 [evdev]
[100746.632849]  [<ffffffff81188340>] ? mount_fs+0x1b0/0x1b0
[100746.632852]  [<ffffffff81188d2b>] chrdev_open+0x9b/0x1c0
[100746.632855]  [<ffffffff81182b43>] do_dentry_open+0x203/0x290
[100746.632857]  [<ffffffff81188c90>] ? cdev_put+0x30/0x30
[100746.632859]  [<ffffffff81182e85>] finish_open+0x35/0x50
[100746.632862]  [<ffffffff81192c1e>] do_last+0x31e/0xeb0
[100746.632865]  [<ffffffff8118fba8>] ? link_path_walk+0x78/0x950
[100746.632867]  [<ffffffff81122589>] ? __generic_file_aio_write+0x1b9/0x3b0
[100746.632869]  [<ffffffff8119386c>] path_openat+0xbc/0x530
[100746.632872]  [<ffffffff81194051>] do_filp_open+0x41/0xa0
[100746.632874]  [<ffffffff811a0f59>] ? __alloc_fd+0xe9/0x140
[100746.632877]  [<ffffffff81183d94>] do_sys_open+0xf4/0x1e0
[100746.632880]  [<ffffffff81183ea1>] sys_open+0x21/0x30
[100746.632885]  [<ffffffff814c365d>] system_call_fastpath+0x1a/0x1f
[100746.632886] Mem-Info:
[100746.632888] Node 0 DMA per-cpu:
[100746.632890] CPU    0: hi:    0, btch:   1 usd:   0
[100746.632891] CPU    1: hi:    0, btch:   1 usd:   0
[100746.632892] CPU    2: hi:    0, btch:   1 usd:   0
[100746.632894] CPU    3: hi:    0, btch:   1 usd:   0
[100746.632895] Node 0 DMA32 per-cpu:
[100746.632896] CPU    0: hi:  186, btch:  31 usd:   0
[100746.632898] CPU    1: hi:  186, btch:  31 usd:   0
[100746.632899] CPU    2: hi:  186, btch:  31 usd:   0
[100746.632900] CPU    3: hi:  186, btch:  31 usd:   0
[100746.632901] Node 0 Normal per-cpu:
[100746.632902] CPU    0: hi:  186, btch:  31 usd:  62
[100746.632904] CPU    1: hi:  186, btch:  31 usd:   0
[100746.632905] CPU    2: hi:  186, btch:  31 usd:   0
[100746.632906] CPU    3: hi:  186, btch:  31 usd:   0
[100746.632910] active_anon:151680 inactive_anon:155590 isolated_anon:0
 active_file:219862 inactive_file:228160 isolated_file:0
 unevictable:5214 dirty:64673 writeback:0 unstable:0
 free:125730 slab_reclaimable:65566 slab_unreclaimable:8434
 mapped:20133 shmem:51490 pagetables:8470 bounce:0
 free_cma:0
[100746.632913] Node 0 DMA free:15360kB min:252kB low:312kB high:376kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15104kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[100746.632917] lowmem_reserve[]: 0 2137 3899 3899
[100746.632919] Node 0 DMA32 free:352140kB min:36904kB low:46128kB high:55356kB active_anon:222024kB inactive_anon:191240kB active_file:572904kB inactive_file:604180kB unevictable:3388kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:3388kB dirty:57232kB writeback:0kB mapped:31048kB shmem:70140kB slab_reclaimable:216080kB slab_unreclaimable:7072kB kernel_stack:2152kB pagetables:6520kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[100746.632924] lowmem_reserve[]: 0 0 1762 1762
[100746.632926] Node 0 Normal free:135420kB min:30420kB low:38024kB high:45628kB active_anon:384696kB inactive_anon:431120kB active_file:306544kB inactive_file:308460kB unevictable:17468kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:17468kB dirty:201460kB writeback:0kB mapped:49484kB shmem:135820kB slab_reclaimable:46184kB slab_unreclaimable:26664kB kernel_stack:1608kB pagetables:27360kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[100746.632930] lowmem_reserve[]: 0 0 0 0
[100746.632932] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15360kB
[100746.632939] Node 0 DMA32: 23990*4kB 18649*8kB 5480*16kB 597*32kB 4*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 352192kB
[100746.632945] Node 0 Normal: 25559*4kB 3322*8kB 155*16kB 1*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 135420kB
[100746.632951] 519915 total pagecache pages
[100746.632952] 19500 pages in swap cache
[100746.632953] Swap cache stats: add 6260613, delete 6241113, find 2615017/3351756
[100746.632954] Free swap  = 8052520kB
[100746.632955] Total swap = 8386556kB
[100746.643282] 1048048 pages RAM
[100746.643287] 57808 pages reserved
[100746.643295] 1232253 pages shared
[100746.643299] 789365 pages non-shared
[100747.131783] usbcore: deregistering interface driver bcm5974
[100747.452241] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input39
[100747.452351] usbcore: registered new interface driver bcm5974
[100747.456689] X: page allocation failure: order:4, mode:0xc0d0
[100747.456693] Pid: 692, comm: X Tainted: G        W    3.7.9-1-ARCH #1
[100747.456694] Call Trace:
[100747.456700]  [<ffffffff811266d9>] warn_alloc_failed+0xe9/0x140
[100747.456703]  [<ffffffff81129a36>] ? drain_local_pages+0x16/0x20
[100747.456706]  [<ffffffff8112a17f>] __alloc_pages_nodemask+0x6ef/0x960
[100747.456710]  [<ffffffff81165fd0>] alloc_pages_current+0xb0/0x120
[100747.456712]  [<ffffffff8112598e>] __get_free_pages+0xe/0x50
[100747.456715]  [<ffffffff8116cf49>] kmalloc_order_trace+0x39/0xf0
[100747.456718]  [<ffffffff8116fd8a>] __kmalloc+0x17a/0x190
[100747.456728]  [<ffffffffa04420d5>] evdev_open+0x85/0x1e0 [evdev]
[100747.456731]  [<ffffffff81188340>] ? mount_fs+0x1b0/0x1b0
[100747.456733]  [<ffffffff81188d2b>] chrdev_open+0x9b/0x1c0
[100747.456737]  [<ffffffff81182b43>] do_dentry_open+0x203/0x290
[100747.456739]  [<ffffffff81188c90>] ? cdev_put+0x30/0x30
[100747.456741]  [<ffffffff81182e85>] finish_open+0x35/0x50
[100747.456743]  [<ffffffff81192c1e>] do_last+0x31e/0xeb0
[100747.456746]  [<ffffffff8118fba8>] ? link_path_walk+0x78/0x950
[100747.456749]  [<ffffffff81122589>] ? __generic_file_aio_write+0x1b9/0x3b0
[100747.456751]  [<ffffffff8119386c>] path_openat+0xbc/0x530
[100747.456753]  [<ffffffff81194051>] do_filp_open+0x41/0xa0
[100747.456756]  [<ffffffff811a0f59>] ? __alloc_fd+0xe9/0x140
[100747.456758]  [<ffffffff81183d94>] do_sys_open+0xf4/0x1e0
[100747.456761]  [<ffffffff81183ea1>] sys_open+0x21/0x30
[100747.456765]  [<ffffffff814c365d>] system_call_fastpath+0x1a/0x1f
[100747.456766] Mem-Info:
[100747.456767] Node 0 DMA per-cpu:
[100747.456769] CPU    0: hi:    0, btch:   1 usd:   0
[100747.456771] CPU    1: hi:    0, btch:   1 usd:   0
[100747.456772] CPU    2: hi:    0, btch:   1 usd:   0
[100747.456773] CPU    3: hi:    0, btch:   1 usd:   0
[100747.456774] Node 0 DMA32 per-cpu:
[100747.456776] CPU    0: hi:  186, btch:  31 usd:   0
[100747.456777] CPU    1: hi:  186, btch:  31 usd:   0
[100747.456778] CPU    2: hi:  186, btch:  31 usd:   0
[100747.456779] CPU    3: hi:  186, btch:  31 usd:   0
[100747.456780] Node 0 Normal per-cpu:
[100747.456782] CPU    0: hi:  186, btch:  31 usd:   0
[100747.456783] CPU    1: hi:  186, btch:  31 usd:   0
[100747.456784] CPU    2: hi:  186, btch:  31 usd:   0
[100747.456785] CPU    3: hi:  186, btch:  31 usd:   0
[100747.456788] active_anon:152955 inactive_anon:155540 isolated_anon:0
 active_file:221544 inactive_file:229672 isolated_file:0
 unevictable:5214 dirty:64706 writeback:15 unstable:0
 free:120795 slab_reclaimable:66142 slab_unreclaimable:8405
 mapped:22535 shmem:51493 pagetables:8539 bounce:0
 free_cma:0
[100747.456791] Node 0 DMA free:15360kB min:252kB low:312kB high:376kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15104kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[100747.456796] lowmem_reserve[]: 0 2137 3899 3899
[100747.456798] Node 0 DMA32 free:351288kB min:36904kB low:46128kB high:55356kB active_anon:220660kB inactive_anon:191224kB active_file:575024kB inactive_file:602060kB unevictable:3388kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:3388kB dirty:57372kB writeback:20kB mapped:37624kB shmem:70140kB slab_reclaimable:218384kB slab_unreclaimable:7024kB kernel_stack:2144kB pagetables:6488kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[100747.456803] lowmem_reserve[]: 0 0 1762 1762
[100747.456805] Node 0 Normal free:116408kB min:30420kB low:38024kB high:45628kB active_anon:391160kB inactive_anon:430936kB active_file:311152kB inactive_file:316628kB unevictable:17468kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:17468kB dirty:201452kB writeback:40kB mapped:52516kB shmem:135832kB slab_reclaimable:46184kB slab_unreclaimable:26596kB kernel_stack:1640kB pagetables:27668kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[100747.456809] lowmem_reserve[]: 0 0 0 0
[100747.456811] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15360kB
[100747.456817] Node 0 DMA32: 24130*4kB 18709*8kB 5478*16kB 541*32kB 4*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 351408kB
[100747.456823] Node 0 Normal: 20680*4kB 3383*8kB 156*16kB 1*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 116408kB
[100747.456829] 523198 total pagecache pages
[100747.456830] 19498 pages in swap cache
[100747.456832] Swap cache stats: add 6260628, delete 6241130, find 2615078/3351824
[100747.456833] Free swap  = 8052588kB
[100747.456834] Total swap = 8386556kB
[100747.468782] 1048048 pages RAM
[100747.468786] 57808 pages reserved
[100747.468791] 1235589 pages shared
[100747.468796] 792310 pages non-shared
[100747.955865] usbcore: deregistering interface driver bcm5974
[100748.285249] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input40
[100748.285717] usbcore: registered new interface driver bcm5974
[100748.790829] usbcore: deregistering interface driver bcm5974
[100751.905448] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input41
[100751.905811] usbcore: registered new interface driver bcm5974
[100752.411275] usbcore: deregistering interface driver bcm5974
[100752.734428] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input42
[100752.734780] usbcore: registered new interface driver bcm5974
[101580.791664] PM: Syncing filesystems ... done.
[101580.959470] PM: Preparing system for mem sleep
[101581.037006] Freezing user space processes ... (elapsed 0.01 seconds) done.
[101581.049142] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[101581.062608] PM: Entering mem sleep
[101581.062663] Suspending console(s) (use no_console_suspend to debug)
[101581.111809] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[101581.111954] sd 0:0:0:0: [sda] Stopping disk
[101582.669961] PM: suspend of devices complete after 1569.536 msecs
[101582.670437] PM: late suspend of devices complete after 0.471 msecs
[101582.683647] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[101582.696775] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[101582.723239] PM: noirq suspend of devices complete after 52.881 msecs
[101582.724114] ACPI: Preparing to enter system sleep state S3
[101582.749843] PM: Saving platform NVS memory
[101582.750594] Disabling non-boot CPUs ...
[101582.752283] smpboot: CPU 1 is now offline
[101582.754592] smpboot: CPU 2 is now offline
[101582.757502] smpboot: CPU 3 is now offline
[101582.757914] Extended CMOS year: 2000
[101582.760017] ACPI: Low-level resume complete
[101582.760059] PM: Restoring platform NVS memory
[101582.760360] Extended CMOS year: 2000
[101582.760423] Enabling non-boot CPUs ...
[101582.763867] smpboot: Booting Node 0 Processor 1 APIC 0x2
[101582.778232] CPU1 is up
[101582.781626] smpboot: Booting Node 0 Processor 2 APIC 0x1
[101582.795220] CPU2 is up
[101582.795896] smpboot: Booting Node 0 Processor 3 APIC 0x3
[101582.810218] CPU3 is up
[101582.815081] ACPI: Waking up from system sleep state S3
[101583.354645] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[101583.368073] pcieport 0000:00:1c.1: power state changed by ACPI to D0
[101583.381263] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[101583.408266] PM: noirq resume of devices complete after 93.681 msecs
[101583.408727] PM: early resume of devices complete after 0.360 msecs
[101583.408788] i915 0000:00:02.0: setting latency timer to 64
[101583.408815] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[101583.408863] usb usb3: root hub lost power or was reset
[101583.408874] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[101583.408883] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[101583.408951] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[101583.408980] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[101583.409002] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[101583.409014] usb usb4: root hub lost power or was reset
[101583.409019] ata_piix 0000:00:1f.2: setting latency timer to 64
[101583.409646] mei 0000:00:16.0: wd: failed to find the client
[101583.464376] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake old ack to clear.
[101583.465639] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[101583.481246] bcm5974: bad trackpad package, length: 8
[101584.429685] ata2.00: failed to resume link (SControl 0)
[101584.749188] ata1.01: failed to resume link (SControl 0)
[101584.902363] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[101584.902381] ata1.01: SATA link down (SStatus 0 SControl 0)
[101584.909283] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[101584.916032] ata1.00: configured for UDMA/133
[101584.950346] sd 0:0:0:0: [sda] Starting disk
[101585.451419] ata2.01: failed to resume link (SControl 0)
[101585.463296] ata2.00: SATA link down (SStatus 4 SControl 0)
[101585.463318] ata2.01: SATA link down (SStatus 0 SControl 0)
[101585.480135] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[101585.481169] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[101585.481176] ieee80211 phy0: changing basic rates failed: -22
[101585.481180] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: threshold 0, hys 0  (implement)
[101585.481184] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[101585.481188] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[101585.481422] PM: resume of devices complete after 2075.914 msecs
[101585.515534] PM: Finishing wakeup.
[101585.515536] Restarting tasks ... done.
[101585.553990] video LNXVIDEO:00: Restoring backlight state
[101585.561135] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[101585.561145] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[101585.561148] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[101585.562835] cfg80211: Calling CRDA to update world regulatory domain
[101585.841496] X: page allocation failure: order:4, mode:0xc0d0
[101585.841500] Pid: 692, comm: X Tainted: G        W    3.7.9-1-ARCH #1
[101585.841502] Call Trace:
[101585.841509]  [<ffffffff811266d9>] warn_alloc_failed+0xe9/0x140
[101585.841513]  [<ffffffff814b3d72>] ? __alloc_pages_direct_compact+0x1b8/0x1ca
[101585.841516]  [<ffffffff8112a17f>] __alloc_pages_nodemask+0x6ef/0x960
[101585.841519]  [<ffffffff81165fd0>] alloc_pages_current+0xb0/0x120
[101585.841522]  [<ffffffff8112598e>] __get_free_pages+0xe/0x50
[101585.841526]  [<ffffffff8116cf49>] kmalloc_order_trace+0x39/0xf0
[101585.841529]  [<ffffffff8116fd8a>] __kmalloc+0x17a/0x190
[101585.841541]  [<ffffffffa04420d5>] evdev_open+0x85/0x1e0 [evdev]
[101585.841545]  [<ffffffff81188d2b>] chrdev_open+0x9b/0x1c0
[101585.841548]  [<ffffffff81182b43>] do_dentry_open+0x203/0x290
[101585.841550]  [<ffffffff81188c90>] ? cdev_put+0x30/0x30
[101585.841553]  [<ffffffff81182e85>] finish_open+0x35/0x50
[101585.841555]  [<ffffffff81192c1e>] do_last+0x31e/0xeb0
[101585.841558]  [<ffffffff8118fba8>] ? link_path_walk+0x78/0x950
[101585.841561]  [<ffffffff81122589>] ? __generic_file_aio_write+0x1b9/0x3b0
[101585.841563]  [<ffffffff8119386c>] path_openat+0xbc/0x530
[101585.841565]  [<ffffffff81194051>] do_filp_open+0x41/0xa0
[101585.841567]  [<ffffffff811a0f59>] ? __alloc_fd+0xe9/0x140
[101585.841570]  [<ffffffff81183d94>] do_sys_open+0xf4/0x1e0
[101585.841573]  [<ffffffff81183ea1>] sys_open+0x21/0x30
[101585.841577]  [<ffffffff814c365d>] system_call_fastpath+0x1a/0x1f
[101585.841578] Mem-Info:
[101585.841579] Node 0 DMA per-cpu:
[101585.841581] CPU    0: hi:    0, btch:   1 usd:   0
[101585.841582] CPU    1: hi:    0, btch:   1 usd:   0
[101585.841584] CPU    2: hi:    0, btch:   1 usd:   0
[101585.841585] CPU    3: hi:    0, btch:   1 usd:   0
[101585.841586] Node 0 DMA32 per-cpu:
[101585.841588] CPU    0: hi:  186, btch:  31 usd:   0
[101585.841589] CPU    1: hi:  186, btch:  31 usd:   0
[101585.841590] CPU    2: hi:  186, btch:  31 usd:   0
[101585.841591] CPU    3: hi:  186, btch:  31 usd:   0
[101585.841592] Node 0 Normal per-cpu:
[101585.841593] CPU    0: hi:  186, btch:  31 usd:   0
[101585.841595] CPU    1: hi:  186, btch:  31 usd:  42
[101585.841596] CPU    2: hi:  186, btch:  31 usd:   0
[101585.841597] CPU    3: hi:  186, btch:  31 usd:   0
[101585.841600] active_anon:177056 inactive_anon:185005 isolated_anon:0
 active_file:209006 inactive_file:216379 isolated_file:0
 unevictable:3185 dirty:242 writeback:0 unstable:0
 free:98036 slab_reclaimable:63082 slab_unreclaimable:8364
 mapped:38372 shmem:75471 pagetables:8538 bounce:0
 free_cma:0
[101585.841603] Node 0 DMA free:15360kB min:252kB low:312kB high:376kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15104kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[101585.841607] lowmem_reserve[]: 0 2137 3899 3899
[101585.841610] Node 0 DMA32 free:324604kB min:36904kB low:46128kB high:55356kB active_anon:210168kB inactive_anon:238856kB active_file:575428kB inactive_file:604712kB unevictable:1692kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:1692kB dirty:724kB writeback:0kB mapped:71080kB shmem:118084kB slab_reclaimable:206552kB slab_unreclaimable:7012kB kernel_stack:1824kB pagetables:6576kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[101585.841614] lowmem_reserve[]: 0 0 1762 1762
[101585.841616] Node 0 Normal free:52180kB min:30420kB low:38024kB high:45628kB active_anon:498056kB inactive_anon:501164kB active_file:260596kB inactive_file:260804kB unevictable:11048kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:11048kB dirty:244kB writeback:0kB mapped:82408kB shmem:183800kB slab_reclaimable:45776kB slab_unreclaimable:26444kB kernel_stack:1632kB pagetables:27576kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:28 all_unreclaimable? no
[101585.841620] lowmem_reserve[]: 0 0 0 0
[101585.841623] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15360kB
[101585.841629] Node 0 DMA32: 16067*4kB 19303*8kB 5883*16kB 365*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 324564kB
[101585.841634] Node 0 Normal: 11027*4kB 497*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 52180kB
[101585.841640] 522097 total pagecache pages
[101585.841641] 20384 pages in swap cache
[101585.841643] Swap cache stats: add 6262319, delete 6241935, find 2616629/3353715
[101585.841644] Free swap  = 8055800kB
[101585.841645] Total swap = 8386556kB
[101585.851330] 1048048 pages RAM
[101585.851339] 57808 pages reserved
[101585.851345] 1273115 pages shared
[101585.851350] 790534 pages non-shared
[101586.373384] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[101586.373394] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[101586.374415] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[101591.115861] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[101591.115882] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[101591.116999] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[101595.463130] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[101595.463151] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[101595.464310] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[101595.527521] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[101595.527532] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[101595.528576] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[101597.700375] wlan0: authenticate with 5c:ff:35:75:05:89
[101597.700417] wlan0: send auth to 5c:ff:35:75:05:89 (try 1/3)
[101597.703973] wlan0: authenticated
[101597.705565] wlan0: associate with 5c:ff:35:75:05:89 (try 1/3)
[101597.716682] wlan0: RX AssocResp from 5c:ff:35:75:05:89 (capab=0x431 status=0 aid=1)
[101597.717197] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[101597.717207] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[101597.717213] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[101597.717231] wlan0: associated
[101597.717289] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[101606.698704] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[101635.175021] usbcore: deregistering interface driver bcm5974
[101635.492562] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input43
[101635.493037] usbcore: registered new interface driver bcm5974
[101636.001506] usbcore: deregistering interface driver bcm5974
[101636.320713] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input44
[101636.321181] usbcore: registered new interface driver bcm5974
[101636.826162] usbcore: deregistering interface driver bcm5974
[101637.154562] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input45
[101637.155073] usbcore: registered new interface driver bcm5974
[101684.474505] wlan0: deauthenticated from 5c:ff:35:75:05:89 (Reason: 1)
[101684.513687] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[101684.513695] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[101684.513697] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[101684.536975] cfg80211: Calling CRDA for country: CH
[101687.117830] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[101687.117852] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[101687.118969] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[101691.958276] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[101691.958297] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[101691.959543] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[101696.317287] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[101696.317308] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[101696.318406] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[101696.367557] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[101696.367578] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[101696.368792] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[101698.515723] wlan0: authenticate with 0e:b0:5d:9c:37:13
[101698.520325] wlan0: send auth to 0e:b0:5d:9c:37:13 (try 1/3)
[101698.525381] wlan0: authenticated
[101698.528512] wlan0: associate with 0e:b0:5d:9c:37:13 (try 1/3)
[101698.539223] wlan0: RX AssocResp from 0e:b0:5d:9c:37:13 (capab=0x411 status=0 aid=1)
[101698.542313] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[101698.542328] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[101698.542337] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[101698.542374] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[101698.542529] wlan0: associated
[101704.067185] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)

--J/dobhs11T7y2rNN--
