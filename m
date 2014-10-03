Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbaJCNZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 09:25:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:48766 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbaJCNZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 09:25:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,647,1406617200"; 
   d="scan'208";a="609240143"
Date: Fri, 3 Oct 2014 21:25:22 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [PCI/MSI] WARNING: CPU: 0 PID: 1 at drivers/pci/msi.c:1034
 pci_enable_msi_range+0x2c1/0x2f0()
Message-ID: <20141003132522.GA32634@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Alexander,

FYI, we noticed the below changes on

git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git pci/msi
commit 4ab2ee7c77875669230a797a3ed2228990f82545 ("PCI/MSI: Rename pci_msi_check_device() to pci_msi_supported()")


+-----------------------------------------------------+------------+------------+
|                                                     | 888215f389 | 4ab2ee7c77 |
+-----------------------------------------------------+------------+------------+
| boot_successes                                      | 15         | 2          |
| early-boot-hang                                     | 1          |            |
| boot_failures                                       | 0          | 13         |
| WARNING:at_drivers/pci/msi.c:pci_enable_msi_range() | 0          | 5          |
| WARNING:at_fs/sysfs/dir.c:sysfs_warn_dup()          | 0          | 5          |
| backtrace:ip_auto_config                            | 0          | 5          |
| backtrace:kernel_init_freeable                      | 0          | 5          |
| BUG:kernel_test_crashed                             | 0          | 8          |
+-----------------------------------------------------+------------+------------+


[    5.410055] evm: HMAC attrs: 0x1
[    5.413893] rtc_cmos 00:01: setting system clock to 2014-09-25 00:13:24 UTC (1411604004)
[    5.447469] ------------[ cut here ]------------
[    5.452212] WARNING: CPU: 0 PID: 1 at drivers/pci/msi.c:1034 pci_enable_msi_range+0x2c1/0x2f0()
[    5.462479] Modules linked in:
[    5.465712] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc2-00011-g4ab2ee7 #1
[    5.473467] Hardware name: Supermicro X7DB8/X7DB8, BIOS 6.00 04/28/2006
[    5.480202]  0000000000000009 ffff880139ab7c00 ffffffff8185b75a 0000000000000000
[    5.488043]  ffff880139ab7c38 ffffffff8107056d 0000000000000001 ffff88007f8ec000
[    5.495879]  ffff88013974e098 ffff88013974e000 ffff88007f8ecdb8 ffff880139ab7c48
[    5.503722] Call Trace:
[    5.506293]  [<ffffffff8185b75a>] dump_stack+0x4d/0x66
[    5.511552]  [<ffffffff8107056d>] warn_slowpath_common+0x7d/0xa0
[    5.517675]  [<ffffffff8107064a>] warn_slowpath_null+0x1a/0x20
[    5.523631]  [<ffffffff81449961>] pci_enable_msi_range+0x2c1/0x2f0
[    5.529932]  [<ffffffff815b490a>] e1000_open+0x22a/0x4b0
[    5.535368]  [<ffffffff8172d466>] __dev_open+0xb6/0x130
[    5.540712]  [<ffffffff8172d77d>] __dev_change_flags+0x9d/0x160
[    5.546754]  [<ffffffff8172d869>] dev_change_flags+0x29/0x70
[    5.552534]  [<ffffffff81e5707e>] ip_auto_config+0x1c4/0xe7f
[    5.558314]  [<ffffffff81e56eba>] ? root_nfs_parse_addr+0xba/0xba
[    5.564529]  [<ffffffff81405f1e>] ? kasprintf+0x3e/0x40
[    5.569876]  [<ffffffff81e56eba>] ? root_nfs_parse_addr+0xba/0xba
[    5.576091]  [<ffffffff81002130>] do_one_initcall+0xc0/0x1f0
[    5.581871]  [<ffffffff81002130>] ? do_one_initcall+0xc0/0x1f0
[    5.587826]  [<ffffffff8108f000>] ? parse_args+0x180/0x4e0
[    5.593436]  [<ffffffff81df511b>] kernel_init_freeable+0x1b3/0x23b
[    5.599735]  [<ffffffff8184ed70>] ? rest_init+0x90/0x90
[    5.605079]  [<ffffffff8184ed7e>] kernel_init+0xe/0xf0
[    5.610341]  [<ffffffff8186437c>] ret_from_fork+0x7c/0xb0
[    5.615861]  [<ffffffff8184ed70>] ? rest_init+0x90/0x90
[    5.621207] ---[ end trace 3e09fff841f00690 ]---
[    5.625958] e1000e 0000:06:00.0: irq 27 for MSI/MSI-X



Thanks,
Fengguang

--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".dmesg"

early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-rc2-00011-g4ab2ee7 (kbuild@xian) (gcc version 4.9.1 (Debian 4.9.1-11) ) #1 SMP Thu Sep 25 00:06:22 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/bens/bisect_boot-performance-1-x86_64-rhel-4ab2ee7c77875669230a797a3ed2228990f82545-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/4ab2ee7c77875669230a797a3ed2228990f82545/vmlinuz-3.17.0-rc2-00011-g4ab2ee7 kconfig=x86_64-rhel commit=4ab2ee7c77875669230a797a3ed2228990f82545 branch=linux-devel/devel-hourly-2014092408 root=/dev/ram0 max_uptime=18000 RESULT_ROOT=/result/bens/boot/performance-1/debian-x86_64.cgz/x86_64-rhel/4ab2ee7c77875669230a797a3ed2228990f82545/0 ip=::::bens::dhcp hpet=disable pci=nomsi earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009dbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009dc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e4000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bff5ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bff60000-0x00000000bff68fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bff69000-0x00000000bff7ffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bff80000-0x00000000bfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000013fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Supermicro X7DB8/X7DB8, BIOS 6.00 04/28/2006
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x140000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E3FFF uncachable
[    0.000000]   E4000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   1 base 000000000 mask F00000000 write-back
[    0.000000]   2 base 100000000 mask FC0000000 write-back
[    0.000000]   3 base 0BFF80000 mask FFFF80000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: update [mem 0xbff80000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbff60 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f58f0-0x000f58ff] mapped at [ffff8800000f58f0]
[    0.000000]   mpc: 9e171-9e33d
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02184000, 0x02184fff] PGTABLE
[    0.000000] BRK [0x02185000, 0x02185fff] PGTABLE
[    0.000000] BRK [0x02186000, 0x02186fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13fe00000-0x13fffffff]
[    0.000000]  [mem 0x13fe00000-0x13fffffff] page 2M
[    0.000000] BRK [0x02187000, 0x02187fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13c000000-0x13fdfffff]
[    0.000000]  [mem 0x13c000000-0x13fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x13bffffff]
[    0.000000]  [mem 0x100000000-0x13bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbff5ffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xbfdfffff] page 2M
[    0.000000]  [mem 0xbfe00000-0xbff5ffff] page 4k
[    0.000000] RAMDISK: [mem 0x78805000-0x7fff2fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F58C0 000014 (v00 PTLTD )
[    0.000000] ACPI: RSDT 0x00000000BFF64382 00003C (v01 PTLTD    RSDT   06040000  LTP 00000000)
[    0.000000] ACPI: FACP 0x00000000BFF68E48 000074 (v01 INTEL  TUMWATER 06040000 PTL  00000003)
[    0.000000] ACPI: DSDT 0x00000000BFF64A6A 0043DE (v01 Intel  BLAKFORD 06040000 MSFT 0100000E)
[    0.000000] ACPI: FACS 0x00000000BFF69FC0 000040
[    0.000000] ACPI: APIC 0x00000000BFF68EBC 000090 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: MCFG 0x00000000BFF68F4C 00003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 0x00000000BFF68F88 000028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: SPCR 0x00000000BFF68FB0 000050 (v01 PTLTD  $UCRTBL$ 06040000 PTL  00000001)
[    0.000000] ACPI: SSDT 0x00000000BFF643BE 0006AC (v01 DpgPmm CpuPm    00000012 INTL 20030224)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000013fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13fffffff]
[    0.000000]   NODE_DATA [mem 0x13ffd7000-0x13fffcfff]
[    0.000000]  [ffffea0000000000-ffffea0004ffffff] PMD -> [ffff88013b600000-ffff88013f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x13fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0xbff5ffff]
[    0.000000]   node   0: [mem 0x100000000-0x13fffffff]
[    0.000000] On node 0 totalpages: 1048316
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12222 pages used for memmap
[    0.000000]   DMA32 zone: 782176 pages, LIFO batch:31
[    0.000000]   Normal zone: 4096 pages used for memmap
[    0.000000]   Normal zone: 262144 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec80000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 3, version 32, address 0xfec80000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] Int: type 0, pol 1, trig 1, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff57a000 (fec80000)
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000e3fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e4000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbff60000-0xbff68fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbff69000-0xbff7ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbff80000-0xbfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc0000000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec10000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xc0000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88013fc00000 s88960 r8192 d21632 u524288
[    0.000000] pcpu-alloc: s88960 r8192 d21632 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1031913
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/bens/bisect_boot-performance-1-x86_64-rhel-4ab2ee7c77875669230a797a3ed2228990f82545-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/4ab2ee7c77875669230a797a3ed2228990f82545/vmlinuz-3.17.0-rc2-00011-g4ab2ee7 kconfig=x86_64-rhel commit=4ab2ee7c77875669230a797a3ed2228990f82545 branch=linux-devel/devel-hourly-2014092408 root=/dev/ram0 max_uptime=18000 RESULT_ROOT=/result/bens/boot/performance-1/debian-x86_64.cgz/x86_64-rhel/4ab2ee7c77875669230a797a3ed2228990f82545/0 ip=::::bens::dhcp hpet=disable pci=nomsi earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 3919940K/4193264K available (8613K kernel code, 1703K rwdata, 3868K rodata, 1804K init, 1888K bss, 273324K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=4.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-3.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS:524544 nr_irqs:864 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-rc2-00011-g4ab2ee7 (kbuild@xian) (gcc version 4.9.1 (Debian 4.9.1-11) ) #1 SMP Thu Sep 25 00:06:22 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/bens/bisect_boot-performance-1-x86_64-rhel-4ab2ee7c77875669230a797a3ed2228990f82545-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/4ab2ee7c77875669230a797a3ed2228990f82545/vmlinuz-3.17.0-rc2-00011-g4ab2ee7 kconfig=x86_64-rhel commit=4ab2ee7c77875669230a797a3ed2228990f82545 branch=linux-devel/devel-hourly-2014092408 root=/dev/ram0 max_uptime=18000 RESULT_ROOT=/result/bens/boot/performance-1/debian-x86_64.cgz/x86_64-rhel/4ab2ee7c77875669230a797a3ed2228990f82545/0 ip=::::bens::dhcp hpet=disable pci=nomsi earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009dbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009dc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e4000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bff5ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bff60000-0x00000000bff68fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bff69000-0x00000000bff7ffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bff80000-0x00000000bfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000013fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Supermicro X7DB8/X7DB8, BIOS 6.00 04/28/2006
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x140000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E3FFF uncachable
[    0.000000]   E4000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   1 base 000000000 mask F00000000 write-back
[    0.000000]   2 base 100000000 mask FC0000000 write-back
[    0.000000]   3 base 0BFF80000 mask FFFF80000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: update [mem 0xbff80000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbff60 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f58f0-0x000f58ff] mapped at [ffff8800000f58f0]
[    0.000000]   mpc: 9e171-9e33d
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02184000, 0x02184fff] PGTABLE
[    0.000000] BRK [0x02185000, 0x02185fff] PGTABLE
[    0.000000] BRK [0x02186000, 0x02186fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13fe00000-0x13fffffff]
[    0.000000]  [mem 0x13fe00000-0x13fffffff] page 2M
[    0.000000] BRK [0x02187000, 0x02187fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13c000000-0x13fdfffff]
[    0.000000]  [mem 0x13c000000-0x13fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x13bffffff]
[    0.000000]  [mem 0x100000000-0x13bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbff5ffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xbfdfffff] page 2M
[    0.000000]  [mem 0xbfe00000-0xbff5ffff] page 4k
[    0.000000] RAMDISK: [mem 0x78805000-0x7fff2fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F58C0 000014 (v00 PTLTD )
[    0.000000] ACPI: RSDT 0x00000000BFF64382 00003C (v01 PTLTD    RSDT   06040000  LTP 00000000)
[    0.000000] ACPI: FACP 0x00000000BFF68E48 000074 (v01 INTEL  TUMWATER 06040000 PTL  00000003)
[    0.000000] ACPI: DSDT 0x00000000BFF64A6A 0043DE (v01 Intel  BLAKFORD 06040000 MSFT 0100000E)
[    0.000000] ACPI: FACS 0x00000000BFF69FC0 000040
[    0.000000] ACPI: APIC 0x00000000BFF68EBC 000090 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: MCFG 0x00000000BFF68F4C 00003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 0x00000000BFF68F88 000028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: SPCR 0x00000000BFF68FB0 000050 (v01 PTLTD  $UCRTBL$ 06040000 PTL  00000001)
[    0.000000] ACPI: SSDT 0x00000000BFF643BE 0006AC (v01 DpgPmm CpuPm    00000012 INTL 20030224)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000013fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13fffffff]
[    0.000000]   NODE_DATA [mem 0x13ffd7000-0x13fffcfff]
[    0.000000]  [ffffea0000000000-ffffea0004ffffff] PMD -> [ffff88013b600000-ffff88013f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x13fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0xbff5ffff]
[    0.000000]   node   0: [mem 0x100000000-0x13fffffff]
[    0.000000] On node 0 totalpages: 1048316
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12222 pages used for memmap
[    0.000000]   DMA32 zone: 782176 pages, LIFO batch:31
[    0.000000]   Normal zone: 4096 pages used for memmap
[    0.000000]   Normal zone: 262144 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec80000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 3, version 32, address 0xfec80000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] Int: type 0, pol 1, trig 1, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff57a000 (fec80000)
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000e3fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e4000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbff60000-0xbff68fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbff69000-0xbff7ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbff80000-0xbfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc0000000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec10000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xc0000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88013fc00000 s88960 r8192 d21632 u524288
[    0.000000] pcpu-alloc: s88960 r8192 d21632 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1031913
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/bens/bisect_boot-performance-1-x86_64-rhel-4ab2ee7c77875669230a797a3ed2228990f82545-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/4ab2ee7c77875669230a797a3ed2228990f82545/vmlinuz-3.17.0-rc2-00011-g4ab2ee7 kconfig=x86_64-rhel commit=4ab2ee7c77875669230a797a3ed2228990f82545 branch=linux-devel/devel-hourly-2014092408 root=/dev/ram0 max_uptime=18000 RESULT_ROOT=/result/bens/boot/performance-1/debian-x86_64.cgz/x86_64-rhel/4ab2ee7c77875669230a797a3ed2228990f82545/0 ip=::::bens::dhcp hpet=disable pci=nomsi earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 3919940K/4193264K available (8613K kernel code, 1703K rwdata, 3868K rodata, 1804K init, 1888K bss, 273324K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=4.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-3.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS:524544 nr_irqs:864 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 16777216 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2666.409 MHz processor
[    0.000015] Calibrating delay loop (skipped), value calculated using timer frequency.. 5332.81 BogoMIPS (lpj=2666409)
[    0.001000] pid_max: default: 32768 minimum: 301
[    0.001000] ACPI: Core revision 20140724
[    0.001000] ACPI: All ACPI Tables successfully acquired
[    0.001000] Security Framework initialized
[    0.001000] SELinux:  Initializing.
[    0.001000] SELinux:  Starting in permissive mode
[    0.001000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.001000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.001000] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.001000] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.001000] Initializing cgroup subsys memory
[    0.001000] Initializing cgroup subsys devices
[    0.001000] Initializing cgroup subsys freezer
[    0.001000] Initializing cgroup subsys net_cls
[    0.001000] Initializing cgroup subsys blkio
[    0.001000] Initializing cgroup subsys perf_event
[    0.001000] Initializing cgroup subsys hugetlb
[    0.001000] CPU: Physical Processor ID: 0
[    0.001000] CPU: Processor Core ID: 0
[    0.001000] mce: CPU supports 6 MCE banks
[    0.001000] CPU0: Thermal monitoring handled by SMI
[    0.001000] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
[    0.001000] Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32, 1GB 0
[    0.001000] Freeing SMP alternatives memory: 36K (ffffffff81fa1000 - ffffffff81faa000)
[    0.001000] ftrace: allocating 31169 entries in 122 pages
[    0.001000] Getting VERSION: 50014
[    0.001000] Getting VERSION: 50014
[    0.001000] Getting ID: 0
[    0.001000] Getting ID: 0
[    0.001000] masked ExtINT on CPU#0
[    0.001000] ENABLING IO-APIC IRQs
[    0.001000] init IO_APIC IRQs
[    0.001000]  apic 2 pin 0 not connected
[    0.001000] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.001000] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.001000] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.001013] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.002005] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.003005] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.004004] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.005004] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.006005] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.007005] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.008005] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.009005] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.010005] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.011005] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.012005] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.013003]  apic 2 pin 16 not connected
[    0.014001]  apic 2 pin 17 not connected
[    0.015001]  apic 2 pin 18 not connected
[    0.016001]  apic 2 pin 19 not connected
[    0.017001]  apic 2 pin 20 not connected
[    0.018001]  apic 2 pin 21 not connected
[    0.019001]  apic 2 pin 22 not connected
[    0.020001]  apic 2 pin 23 not connected
[    0.021001]  apic 3 pin 0 not connected
[    0.022001]  apic 3 pin 1 not connected
[    0.023001]  apic 3 pin 2 not connected
[    0.024001]  apic 3 pin 3 not connected
[    0.025001]  apic 3 pin 4 not connected
[    0.026001]  apic 3 pin 5 not connected
[    0.027001]  apic 3 pin 6 not connected
[    0.028001]  apic 3 pin 7 not connected
[    0.029001]  apic 3 pin 8 not connected
[    0.030001]  apic 3 pin 9 not connected
[    0.031001]  apic 3 pin 10 not connected
[    0.032001]  apic 3 pin 11 not connected
[    0.033001]  apic 3 pin 12 not connected
[    0.034001]  apic 3 pin 13 not connected
[    0.035001]  apic 3 pin 14 not connected
[    0.036001]  apic 3 pin 15 not connected
[    0.037001]  apic 3 pin 16 not connected
[    0.038001]  apic 3 pin 17 not connected
[    0.039001]  apic 3 pin 18 not connected
[    0.040001]  apic 3 pin 19 not connected
[    0.041001]  apic 3 pin 20 not connected
[    0.042001]  apic 3 pin 21 not connected
[    0.043001]  apic 3 pin 22 not connected
[    0.044001]  apic 3 pin 23 not connected
[    0.045134] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.056782] smpboot: CPU0: Genuine Intel(R) CPU                  @ 2.66GHz (fam: 06, model: 0f, stepping: 04)
[    0.060002] Using local APIC timer interrupts.
[    0.060002] calibrating APIC timer ...
[    0.062000] ... lapic delta = 2083020
[    0.062000] ... PM-Timer delta = 357900
[    0.062000] ... PM-Timer result ok
[    0.062000] ..... delta 2083020
[    0.062000] ..... mult: 89465027
[    0.062000] ..... calibration result: 333283
[    0.062000] ..... CPU clock speed is 2666.0264 MHz.
[    0.062000] ..... host bus clock speed is 333.0283 MHz.
[    0.062041] Performance Events: PEBS fmt0-, 4-deep LBR, Core2 events, Intel PMU driver.
[    0.067001] perf_event_intel: PEBS disabled due to CPU errata
[    0.068003] ... version:                2
[    0.069001] ... bit width:              40
[    0.070001] ... generic registers:      2
[    0.071001] ... value mask:             000000ffffffffff
[    0.072001] ... max period:             000000007fffffff
[    0.073001] ... fixed-purpose events:   3
[    0.074001] ... event mask:             0000000700000003
[    0.077867] x86: Booting SMP configuration:
[    0.078003] .... node  #0, CPUs:      #1
[    0.077746] masked ExtINT on CPU#1
[    0.077746] CPU1: Thermal monitoring handled by SMI
[    0.160140] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.161134]  #2
[    0.161020] masked ExtINT on CPU#2
[    0.161020] CPU2: Thermal monitoring handled by SMI
[    0.183204]  #3
[    0.183042] masked ExtINT on CPU#3
[    0.183042] CPU3: Thermal monitoring handled by SMI
[    0.205013] x86: Booted up 1 node, 4 CPUs
[    0.206003] smpboot: Total of 4 processors activated (21330.84 BogoMIPS)
[    0.209139] devtmpfs: initialized
[    0.214253] evm: security.selinux
[    0.215001] evm: security.ima
[    0.216001] evm: security.capability
[    0.217116] PM: Registering ACPI NVS region [mem 0xbff69000-0xbff7ffff] (94208 bytes)
[    0.220109] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.221130] NET: Registered protocol family 16
[    0.223151] cpuidle: using governor menu
[    0.224139] ACPI: bus type PCI registered
[    0.225002] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.226077] PCI: MMCONFIG for domain 0000 [bus 00-0a] at [mem 0xe0000000-0xe0afffff] (base 0xe0000000)
[    0.227003] PCI: MMCONFIG at [mem 0xe0000000-0xe0afffff] reserved in E820
[    0.228032] PCI: Using configuration type 1 for base access
[    0.232085] ACPI: Added _OSI(Module Device)
[    0.233003] ACPI: Added _OSI(Processor Device)
[    0.234001] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.235002] ACPI: Added _OSI(Processor Aggregator Device)
[    0.237987] ACPI: Interpreter enabled
[    0.238011] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140724/hwxface-580)
[    0.241002] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20140724/hwxface-580)
[    0.244008] ACPI: (supports S0 S1 S4 S5)
[    0.245001] ACPI: Using IOAPIC for interrupt routing
[    0.246022] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.251175] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.252006] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments]
[    0.253005] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.254708] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.255003] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.256002] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.257002] acpi PNP0A03:00: host bridge window [mem 0x000cc000-0x000cffff] (ignored)
[    0.258002] acpi PNP0A03:00: host bridge window [mem 0x000d8000-0x000dbfff] (ignored)
[    0.259002] acpi PNP0A03:00: host bridge window [mem 0x000dc000-0x000dffff] (ignored)
[    0.260002] acpi PNP0A03:00: host bridge window [mem 0x000e0000-0x000e3fff] (ignored)
[    0.261002] acpi PNP0A03:00: host bridge window [mem 0xc0000000-0xfdffffff] (ignored)
[    0.262002] PCI: root bus 00: using default resources
[    0.263003] acpi PNP0A03:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-0a] only partially covers this bridge
[    0.264103] PCI host bridge to bus 0000:00
[    0.265003] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.266002] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.267002] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffffff]
[    0.268013] pci 0000:00:00.0: [8086:25d8] type 00 class 0x060000
[    0.269048] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.270073] pci 0000:00:02.0: [8086:25f7] type 01 class 0x060400
[    0.271042] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.272074] pci 0000:00:04.0: [8086:25f8] type 01 class 0x060400
[    0.273042] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.274030] pci 0000:00:04.0: System wakeup disabled by ACPI
[    0.275050] pci 0000:00:06.0: [8086:25f9] type 01 class 0x060400
[    0.276042] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.277028] pci 0000:00:06.0: System wakeup disabled by ACPI
[    0.278046] pci 0000:00:08.0: [8086:1a38] type 00 class 0x088000
[    0.279011] pci 0000:00:08.0: reg 0x10: [mem 0xfe700000-0xfe7003ff 64bit]
[    0.280038] pci 0000:00:08.0: PME# supported from D0 D3hot D3cold
[    0.281068] pci 0000:00:10.0: [8086:25f0] type 00 class 0x060000
[    0.283065] pci 0000:00:10.1: [8086:25f0] type 00 class 0x060000
[    0.284331] pci 0000:00:10.2: [8086:25f0] type 00 class 0x060000
[    0.285075] pci 0000:00:11.0: [8086:25f1] type 00 class 0x060000
[    0.286068] pci 0000:00:13.0: [8086:25f3] type 00 class 0x060000
[    0.287071] pci 0000:00:15.0: [8086:25f5] type 00 class 0x060000
[    0.288073] pci 0000:00:16.0: [8086:25f6] type 00 class 0x060000
[    0.289080] pci 0000:00:1c.0: [8086:2690] type 01 class 0x060400
[    0.290072] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.291033] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.292051] pci 0000:00:1d.0: [8086:2688] type 00 class 0x0c0300
[    0.293038] pci 0000:00:1d.0: reg 0x20: [io  0x1800-0x181f]
[    0.294057] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.295046] pci 0000:00:1d.1: [8086:2689] type 00 class 0x0c0300
[    0.296038] pci 0000:00:1d.1: reg 0x20: [io  0x1820-0x183f]
[    0.297059] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    0.298046] pci 0000:00:1d.2: [8086:268a] type 00 class 0x0c0300
[    0.299037] pci 0000:00:1d.2: reg 0x20: [io  0x1840-0x185f]
[    0.300058] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    0.301054] pci 0000:00:1d.7: [8086:268c] type 00 class 0x0c0320
[    0.302019] pci 0000:00:1d.7: reg 0x10: [mem 0xc8000000-0xc80003ff]
[    0.303077] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.304031] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    0.305046] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.306069] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.307046] pci 0000:00:1f.0: [8086:2670] type 00 class 0x060100
[    0.308071] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.309072] pci 0000:00:1f.2: [8086:2680] type 00 class 0x010180
[    0.310014] pci 0000:00:1f.2: reg 0x10: [io  0x0000-0x0007]
[    0.311008] pci 0000:00:1f.2: reg 0x14: [io  0x0000-0x0003]
[    0.312007] pci 0000:00:1f.2: reg 0x18: [io  0x0000-0x0007]
[    0.313008] pci 0000:00:1f.2: reg 0x1c: [io  0x0000-0x0003]
[    0.314008] pci 0000:00:1f.2: reg 0x20: [io  0x1870-0x187f]
[    0.315015] pci 0000:00:1f.2: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.316002] pci 0000:00:1f.2: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.317002] pci 0000:00:1f.2: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.318002] pci 0000:00:1f.2: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.319019] pci 0000:00:1f.2: PME# supported from D3hot
[    0.320064] pci 0000:00:1f.3: [8086:269b] type 00 class 0x0c0500
[    0.321048] pci 0000:00:1f.3: reg 0x20: [io  0x1100-0x111f]
[    0.322140] pci 0000:01:00.0: [8086:3500] type 01 class 0x060400
[    0.323061] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.325012] pci 0000:01:00.3: [8086:350c] type 01 class 0x060400
[    0.326056] pci 0000:01:00.3: PME# supported from D0 D3hot D3cold
[    0.327021] pci 0000:01:00.3: System wakeup disabled by ACPI
[    0.328044] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.329009] pci 0000:00:02.0: PCI bridge to [bus 01-07]
[    0.330003] pci 0000:00:02.0:   bridge window [io  0x2000-0x3fff]
[    0.331003] pci 0000:00:02.0:   bridge window [mem 0xc8100000-0xc82fffff]
[    0.332004] pci 0000:00:02.0:   bridge window [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.333069] pci 0000:02:00.0: [8086:3510] type 01 class 0x060400
[    0.335034] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.336057] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.337011] pci 0000:02:02.0: [8086:3518] type 01 class 0x060400
[    0.338063] pci 0000:02:02.0: PME# supported from D0 D3hot D3cold
[    0.339022] pci 0000:02:02.0: System wakeup disabled by ACPI
[    0.340039] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.341024] pci 0000:01:00.0: PCI bridge to [bus 02-06]
[    0.342004] pci 0000:01:00.0:   bridge window [io  0x2000-0x3fff]
[    0.343003] pci 0000:01:00.0:   bridge window [mem 0xc8100000-0xc82fffff]
[    0.344005] pci 0000:01:00.0:   bridge window [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.345068] pci 0000:03:00.0: [8086:0329] type 01 class 0x060400
[    0.346020] pci 0000:03:00.0: PXH quirk detected; SHPC device MSI disabled
[    0.347069] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.348027] pci 0000:03:00.0: System wakeup disabled by ACPI
[    0.349049] pci 0000:03:00.2: [8086:032a] type 01 class 0x060400
[    0.350020] pci 0000:03:00.2: PXH quirk detected; SHPC device MSI disabled
[    0.351069] pci 0000:03:00.2: PME# supported from D0 D3hot D3cold
[    0.352024] pci 0000:03:00.2: System wakeup disabled by ACPI
[    0.353044] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.354009] pci 0000:02:00.0: PCI bridge to [bus 03-05]
[    0.355003] pci 0000:02:00.0:   bridge window [io  0x2000-0x2fff]
[    0.356003] pci 0000:02:00.0:   bridge window [mem 0xc8100000-0xc81fffff]
[    0.357005] pci 0000:02:00.0:   bridge window [mem 0xc0000000-0xc00fffff 64bit pref]
[    0.358066] pci 0000:04:02.0: [9005:801d] type 00 class 0x010000
[    0.359024] pci 0000:04:02.0: reg 0x10: [io  0x2400-0x24ff]
[    0.360014] pci 0000:04:02.0: reg 0x14: [mem 0xc8100000-0xc8101fff 64bit]
[    0.361010] pci 0000:04:02.0: reg 0x1c: [io  0x2000-0x20ff]
[    0.362025] pci 0000:04:02.0: reg 0x30: [mem 0x00000000-0x0007ffff pref]
[    0.363097] pci 0000:04:02.1: [9005:801d] type 00 class 0x010000
[    0.364021] pci 0000:04:02.1: reg 0x10: [io  0x2c00-0x2cff]
[    0.365014] pci 0000:04:02.1: reg 0x14: [mem 0xc8102000-0xc8103fff 64bit]
[    0.366010] pci 0000:04:02.1: reg 0x1c: [io  0x2800-0x28ff]
[    0.367025] pci 0000:04:02.1: reg 0x30: [mem 0x00000000-0x0007ffff pref]
[    0.368123] pci 0000:03:00.0: PCI bridge to [bus 04]
[    0.369004] pci 0000:03:00.0:   bridge window [io  0x2000-0x2fff]
[    0.370004] pci 0000:03:00.0:   bridge window [mem 0xc8100000-0xc81fffff]
[    0.371005] pci 0000:03:00.0:   bridge window [mem 0xc0000000-0xc00fffff 64bit pref]
[    0.372089] pci 0000:03:00.2: PCI bridge to [bus 05]
[    0.373079] pci 0000:06:00.0: [8086:1096] type 00 class 0x020000
[    0.374016] pci 0000:06:00.0: reg 0x10: [mem 0xc8220000-0xc823ffff]
[    0.375010] pci 0000:06:00.0: reg 0x14: [mem 0xc8200000-0xc821ffff]
[    0.376010] pci 0000:06:00.0: reg 0x18: [io  0x3000-0x301f]
[    0.377033] pci 0000:06:00.0: reg 0x30: [mem 0x00000000-0x0000ffff pref]
[    0.378048] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.379068] pci 0000:06:00.1: [8086:1096] type 00 class 0x020000
[    0.380016] pci 0000:06:00.1: reg 0x10: [mem 0xc8260000-0xc827ffff]
[    0.381010] pci 0000:06:00.1: reg 0x14: [mem 0xc8240000-0xc825ffff]
[    0.382010] pci 0000:06:00.1: reg 0x18: [io  0x3020-0x303f]
[    0.384008] pci 0000:06:00.1: reg 0x30: [mem 0x00000000-0x0000ffff pref]
[    0.385048] pci 0000:06:00.1: PME# supported from D0 D3hot D3cold
[    0.386063] pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.387012] pci 0000:02:02.0: PCI bridge to [bus 06]
[    0.388004] pci 0000:02:02.0:   bridge window [io  0x3000-0x3fff]
[    0.389003] pci 0000:02:02.0:   bridge window [mem 0xc8200000-0xc82fffff]
[    0.390005] pci 0000:02:02.0:   bridge window [mem 0xc0100000-0xc01fffff 64bit pref]
[    0.391089] pci 0000:01:00.3: PCI bridge to [bus 07]
[    0.392050] pci 0000:00:04.0: PCI bridge to [bus 08]
[    0.393044] pci 0000:00:06.0: PCI bridge to [bus 09]
[    0.394055] pci 0000:00:1c.0: PCI bridge to [bus 0a]
[    0.395004] pci 0000:00:1c.0:   bridge window [io  0x5000-0x5fff]
[    0.396004] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff]
[    0.397005] pci 0000:00:1c.0:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.398044] pci 0000:0b:01.0: [1002:515e] type 00 class 0x030000
[    0.399017] pci 0000:0b:01.0: reg 0x10: [mem 0xd0000000-0xd7ffffff pref]
[    0.400010] pci 0000:0b:01.0: reg 0x14: [io  0x4000-0x40ff]
[    0.401010] pci 0000:0b:01.0: reg 0x18: [mem 0xc8300000-0xc830ffff]
[    0.402033] pci 0000:0b:01.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    0.403028] pci 0000:0b:01.0: supports D1 D2
[    0.404075] pci 0000:00:1e.0: PCI bridge to [bus 0b] (subtractive decode)
[    0.405004] pci 0000:00:1e.0:   bridge window [io  0x4000-0x4fff]
[    0.406004] pci 0000:00:1e.0:   bridge window [mem 0xc8300000-0xc83fffff]
[    0.407005] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
[    0.408002] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.409002] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xfffffffff] (subtractive decode)
[    0.410019] pci 0000:01:00.0: Max Payload Size 128, but upstream 0000:00:02.0 set to 256; if necessary, use "pci=pcie_bus_safe" and report a bug
[    0.411004] pci 0000:02:00.0: Max Payload Size 256, but upstream 0000:01:00.0 set to 128; if necessary, use "pci=pcie_bus_safe" and report a bug
[    0.412267] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 14 15), disabled.
[    0.417345] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 14 15), disabled.
[    0.422048] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11 14 15), disabled.
[    0.427346] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 14 15), disabled.
[    0.432346] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
[    0.437346] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 6 7 10 11 14 15) *0, disabled.
[    0.441344] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
[    0.447043] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 6 7 10 11 14 15) *0, disabled.
[    0.453338] vgaarb: device added: PCI:0000:0b:01.0,decodes=io+mem,owns=io+mem,locks=none
[    0.454002] vgaarb: loaded
[    0.455001] vgaarb: bridge control possible 0000:0b:01.0
[    0.457008] SCSI subsystem initialized
[    0.458041] ACPI: bus type USB registered
[    0.459031] usbcore: registered new interface driver usbfs
[    0.460013] usbcore: registered new interface driver hub
[    0.461017] usbcore: registered new device driver usb
[    0.462028] pps_core: LinuxPPS API ver. 1 registered
[    0.463001] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.464006] PTP clock support registered
[    0.465039] PCI: Using ACPI for IRQ routing
[    0.466005] PCI: pci_cache_line_size set to 64 bytes
[    0.467063] e820: reserve RAM buffer [mem 0x0009dc00-0x0009ffff]
[    0.468002] e820: reserve RAM buffer [mem 0xbff60000-0xbfffffff]
[    0.469146] NetLabel: Initializing
[    0.470002] NetLabel:  domain hash size = 128
[    0.471001] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.472020] NetLabel:  unlabeled traffic allowed by default
[    0.473151] Switched to clocksource refined-jiffies
[    0.489176] pnp: PnP ACPI init
[    0.490253] pnp 00:00: disabling [mem 0x00000400-0x000004ff] because it overlaps 0000:04:02.0 BAR 6 [mem 0x00000000-0x0007ffff pref]
[    0.491006] pnp 00:00: disabling [mem 0x00000400-0x000004ff disabled] because it overlaps 0000:04:02.1 BAR 6 [mem 0x00000000-0x0007ffff pref]
[    0.492005] pnp 00:00: disabling [mem 0x00000400-0x000004ff disabled] because it overlaps 0000:06:00.0 BAR 6 [mem 0x00000000-0x0000ffff pref]
[    0.493004] pnp 00:00: disabling [mem 0x00000400-0x000004ff disabled] because it overlaps 0000:06:00.1 BAR 6 [mem 0x00000000-0x0000ffff pref]
[    0.494004] pnp 00:00: disabling [mem 0x00000400-0x000004ff disabled] because it overlaps 0000:0b:01.0 BAR 6 [mem 0x00000000-0x0001ffff pref]
[    0.495035] system 00:00: [io  0x04d0-0x04d1] has been reserved
[    0.495999] system 00:00: [io  0x0295-0x0296] has been reserved
[    0.496999] system 00:00: [io  0x0ca2-0x0ca3] has been reserved
[    0.497998] system 00:00: [io  0x0ca8-0x0caf] has been reserved
[    0.498998] system 00:00: [io  0x1000-0x107f] could not be reserved
[    0.499998] system 00:00: [io  0x1180-0x11bf] has been reserved
[    0.500998] system 00:00: [io  0x0800-0x080f] has been reserved
[    0.501998] system 00:00: [io  0xfe00] has been reserved
[    0.502998] system 00:00: [mem 0xe0000000-0xefffffff] has been reserved
[    0.503998] system 00:00: [mem 0xfee00000-0xfee0ffff] could not be reserved
[    0.504997] system 00:00: [mem 0xfec80000-0xfec80fff] could not be reserved
[    0.505997] system 00:00: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.506997] system 00:00: [mem 0xfe000000-0xfe007fff] has been reserved
[    0.507997] system 00:00: [mem 0xfe600000-0xfe6fffff] has been reserved
[    0.508999] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.510068] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.512243] pnp 00:02: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.514079] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.515117] pnp: PnP ACPI: found 4 devices
[    0.522617] Switched to clocksource acpi_pm
[    0.526401] pci 0000:04:02.0: BAR 6: assigned [mem 0xc8180000-0xc81fffff pref]
[    0.533812] pci 0000:04:02.1: BAR 6: assigned [mem 0xc0000000-0xc007ffff pref]
[    0.541214] pci 0000:03:00.0: PCI bridge to [bus 04]
[    0.546295] pci 0000:03:00.0:   bridge window [io  0x2000-0x2fff]
[    0.552511] pci 0000:03:00.0:   bridge window [mem 0xc8100000-0xc81fffff]
[    0.559416] pci 0000:03:00.0:   bridge window [mem 0xc0000000-0xc00fffff 64bit pref]
[    0.567349] pci 0000:03:00.2: PCI bridge to [bus 05]
[    0.572440] pci 0000:02:00.0: PCI bridge to [bus 03-05]
[    0.577788] pci 0000:02:00.0:   bridge window [io  0x2000-0x2fff]
[    0.584010] pci 0000:02:00.0:   bridge window [mem 0xc8100000-0xc81fffff]
[    0.590919] pci 0000:02:00.0:   bridge window [mem 0xc0000000-0xc00fffff 64bit pref]
[    0.598854] pci 0000:06:00.0: BAR 6: assigned [mem 0xc8280000-0xc828ffff pref]
[    0.606259] pci 0000:06:00.1: BAR 6: assigned [mem 0xc8290000-0xc829ffff pref]
[    0.613660] pci 0000:02:02.0: PCI bridge to [bus 06]
[    0.618748] pci 0000:02:02.0:   bridge window [io  0x3000-0x3fff]
[    0.624963] pci 0000:02:02.0:   bridge window [mem 0xc8200000-0xc82fffff]
[    0.631871] pci 0000:02:02.0:   bridge window [mem 0xc0100000-0xc01fffff 64bit pref]
[    0.639800] pci 0000:01:00.0: PCI bridge to [bus 02-06]
[    0.645148] pci 0000:01:00.0:   bridge window [io  0x2000-0x3fff]
[    0.651361] pci 0000:01:00.0:   bridge window [mem 0xc8100000-0xc82fffff]
[    0.658269] pci 0000:01:00.0:   bridge window [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.666199] pci 0000:01:00.3: PCI bridge to [bus 07]
[    0.671291] pci 0000:00:02.0: PCI bridge to [bus 01-07]
[    0.676631] pci 0000:00:02.0:   bridge window [io  0x2000-0x3fff]
[    0.682846] pci 0000:00:02.0:   bridge window [mem 0xc8100000-0xc82fffff]
[    0.689753] pci 0000:00:02.0:   bridge window [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.697677] pci 0000:00:04.0: PCI bridge to [bus 08]
[    0.702766] pci 0000:00:06.0: PCI bridge to [bus 09]
[    0.707853] pci 0000:00:1c.0: PCI bridge to [bus 0a]
[    0.712938] pci 0000:00:1c.0:   bridge window [io  0x5000-0x5fff]
[    0.719153] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff]
[    0.726058] pci 0000:00:1c.0:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.733993] pci 0000:0b:01.0: BAR 6: assigned [mem 0xc8320000-0xc833ffff pref]
[    0.741399] pci 0000:00:1e.0: PCI bridge to [bus 0b]
[    0.746486] pci 0000:00:1e.0:   bridge window [io  0x4000-0x4fff]
[    0.752701] pci 0000:00:1e.0:   bridge window [mem 0xc8300000-0xc83fffff]
[    0.759609] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
[    0.767541] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.773232] pci_bus 0000:00: resource 5 [mem 0x00000000-0xfffffffff]
[    0.779705] pci_bus 0000:01: resource 0 [io  0x2000-0x3fff]
[    0.785399] pci_bus 0000:01: resource 1 [mem 0xc8100000-0xc82fffff]
[    0.791785] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.799186] pci_bus 0000:02: resource 0 [io  0x2000-0x3fff]
[    0.804880] pci_bus 0000:02: resource 1 [mem 0xc8100000-0xc82fffff]
[    0.811269] pci_bus 0000:02: resource 2 [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.818670] pci_bus 0000:03: resource 0 [io  0x2000-0x2fff]
[    0.824364] pci_bus 0000:03: resource 1 [mem 0xc8100000-0xc81fffff]
[    0.830750] pci_bus 0000:03: resource 2 [mem 0xc0000000-0xc00fffff 64bit pref]
[    0.838152] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
[    0.843845] pci_bus 0000:04: resource 1 [mem 0xc8100000-0xc81fffff]
[    0.850234] pci_bus 0000:04: resource 2 [mem 0xc0000000-0xc00fffff 64bit pref]
[    0.857635] pci_bus 0000:06: resource 0 [io  0x3000-0x3fff]
[    0.863329] pci_bus 0000:06: resource 1 [mem 0xc8200000-0xc82fffff]
[    0.869716] pci_bus 0000:06: resource 2 [mem 0xc0100000-0xc01fffff 64bit pref]
[    0.877118] pci_bus 0000:0a: resource 0 [io  0x5000-0x5fff]
[    0.882811] pci_bus 0000:0a: resource 1 [mem 0xc0200000-0xc03fffff]
[    0.889198] pci_bus 0000:0a: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.896601] pci_bus 0000:0b: resource 0 [io  0x4000-0x4fff]
[    0.902296] pci_bus 0000:0b: resource 1 [mem 0xc8300000-0xc83fffff]
[    0.908680] pci_bus 0000:0b: resource 2 [mem 0xd0000000-0xd7ffffff 64bit pref]
[    0.916081] pci_bus 0000:0b: resource 4 [io  0x0000-0xffff]
[    0.921768] pci_bus 0000:0b: resource 5 [mem 0x00000000-0xfffffffff]
[    0.928287] NET: Registered protocol family 2
[    0.933054] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
[    0.940605] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.947528] TCP: Hash tables configured (established 32768 bind 32768)
[    0.954232] TCP: reno registered
[    0.957590] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.963745] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.970393] NET: Registered protocol family 1
[    0.974992] RPC: Registered named UNIX socket transport module.
[    0.981035] RPC: Registered udp transport module.
[    0.985857] RPC: Registered tcp transport module.
[    0.990679] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.997505] IOAPIC[0]: Set routing entry (2-17 -> 0x41 -> IRQ 17 Mode:1 Active:1 Dest:15)
[    1.006184] IOAPIC[0]: Set routing entry (2-19 -> 0x51 -> IRQ 19 Mode:1 Active:1 Dest:15)
[    1.014832] IOAPIC[0]: Set routing entry (2-18 -> 0x61 -> IRQ 18 Mode:1 Active:1 Dest:15)
[    1.023482] IOAPIC[0]: Set routing entry (2-17 -> 0x71 -> IRQ 17 Mode:1 Active:1 Dest:15)
[    1.032020] pci 0000:00:1f.0: rerouting interrupts for [8086:2670]
[    1.038328] PCI: CLS mismatch (32 != 64), using 64 bytes
[    1.043764] pci 0000:03:00.0: rerouting interrupts for [8086:0329]
[    1.050062] pci 0000:03:00.2: rerouting interrupts for [8086:032a]
[    1.056371] pci 0000:0b:01.0: Boot video device
[    1.061112] Unpacking initramfs...
[    3.624894] Freeing initrd memory: 122808K (ffff880078805000 - ffff88007fff3000)
[    3.632525] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    3.639097] software IO TLB [mem 0xbbf60000-0xbff60000] (64MB) mapped at [ffff8800bbf60000-ffff8800bff5ffff]
[    3.649259] Simple Boot Flag at 0x38 set to 0x1
[    3.655085] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    3.661429] Initialise system trusted keyring
[    3.665928] audit: initializing netlink subsys (disabled)
[    3.671472] audit: type=2000 audit(1411603999.671:1): initialized
[    3.678150] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.686786] zpool: loaded
[    3.689531] zbud: loaded
[    3.692348] VFS: Disk quotas dquot_6.5.2
[    3.696444] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.703676] SGI XFS with ACLs, security attributes, no debug enabled
[    3.710657] 9p: Installing v9fs 9p2000 file system support
[    3.716306] msgmni has been set to 7896
[    3.720336] Key type big_key registered
[    3.724292] SELinux:  Registering netfilter hooks
[    3.730158] NET: Registered protocol family 38
[    3.734735] Key type asymmetric registered
[    3.738956] Asymmetric key parser 'x509' registered
[    3.744011] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    3.751652] io scheduler noop registered
[    3.755690] io scheduler deadline registered (default)
[    3.760960] io scheduler cfq registered
[    3.765265] IOAPIC[0]: Set routing entry (2-16 -> 0x81 -> IRQ 16 Mode:1 Active:1 Dest:15)
[    3.774121] IOAPIC[0]: Set routing entry (2-17 -> 0x91 -> IRQ 17 Mode:1 Active:1 Dest:15)
[    3.782505] pcieport 0000:00:1c.0: irq 24 for MSI/MSI-X
[    3.788074] IOAPIC[0]: Set routing entry (2-18 -> 0xb1 -> IRQ 18 Mode:1 Active:1 Dest:15)
[    3.796511] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.802225] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    3.809027] intel_idle: does not run on family 6 model 15
[    3.814653] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/PNP0C0C:00/input/input0
[    3.825704] ACPI: Power Button [PWRB]
[    3.829532] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    3.837107] ACPI: Power Button [PWRF]
[    3.841340] GHES: HEST is not enabled!
[    3.845341] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.872235] 00:02: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    3.900275] 00:03: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    3.908296] hpet_acpi_add: no address or irqs in _CRS
[    3.913522] Non-volatile memory driver v1.3
[    3.917840] Linux agpgart interface v0.103
[    3.922328] rdac: device handler registered
[    3.926695] hp_sw: device handler registered
[    3.931088] emc: device handler registered
[    3.935307] alua: device handler registered
[    3.939648] libphy: Fixed MDIO Bus: probed
[    3.943908] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    3.951079] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    3.956968] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    3.962918] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    3.969076] e1000e 0000:06:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    3.978582] e1000e 0000:06:00.0: irq 25 for MSI/MSI-X
[    4.041715] e1000e 0000:06:00.0 eth0: (PCI Express:2.5GT/s:Width x4) 00:30:48:30:70:e0
[    4.049813] e1000e 0000:06:00.0 eth0: Intel(R) PRO/1000 Network Connection
[    4.056881] e1000e 0000:06:00.0 eth0: MAC: 5, PHY: 5, PBA No: FFFFFF-0FF
[    4.063808] IOAPIC[0]: Set routing entry (2-19 -> 0xd1 -> IRQ 19 Mode:1 Active:1 Dest:15)
[    4.072271] e1000e 0000:06:00.1: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    4.081776] e1000e 0000:06:00.1: irq 26 for MSI/MSI-X
[    4.148209] e1000e 0000:06:00.1 eth1: (PCI Express:2.5GT/s:Width x4) 00:30:48:30:70:e1
[    4.156308] e1000e 0000:06:00.1 eth1: Intel(R) PRO/1000 Network Connection
[    4.163384] e1000e 0000:06:00.1 eth1: MAC: 5, PHY: 5, PBA No: FFFFFF-0FF
[    4.170230] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.2.13-k
[    4.177402] igb: Copyright (c) 2007-2014 Intel Corporation.
[    4.183129] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
[    4.191053] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
[    4.197025] usbcore: registered new interface driver catc
[    4.202552] usbcore: registered new interface driver kaweth
[    4.208249] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[    4.215836] usbcore: registered new interface driver pegasus
[    4.221622] usbcore: registered new interface driver rtl8150
[    4.227412] usbcore: registered new interface driver asix
[    4.232939] usbcore: registered new interface driver cdc_ether
[    4.238900] usbcore: registered new interface driver cdc_eem
[    4.244688] usbcore: registered new interface driver dm9601
[    4.250390] usbcore: registered new interface driver smsc75xx
[    4.256265] usbcore: registered new interface driver smsc95xx
[    4.262137] usbcore: registered new interface driver gl620a
[    4.267838] usbcore: registered new interface driver net1080
[    4.273626] usbcore: registered new interface driver plusb
[    4.279238] usbcore: registered new interface driver rndis_host
[    4.285284] usbcore: registered new interface driver cdc_subset
[    4.291333] usbcore: registered new interface driver zaurus
[    4.297036] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    4.304628] usbcore: registered new interface driver int51x1
[    4.310417] usbcore: registered new interface driver ipheth
[    4.316124] usbcore: registered new interface driver sierra_net
[    4.322252] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.328915] ehci-pci: EHCI PCI platform driver
[    4.333672] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    4.339079] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    4.346674] ehci-pci 0000:00:1d.7: debug port 1
[    4.355227] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
[    4.362150] ehci-pci 0000:00:1d.7: irq 17, io mem 0xc8000000
[    4.373020] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.378955] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.385862] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.393263] usb usb1: Product: EHCI Host Controller
[    4.398262] usb usb1: Manufacturer: Linux 3.17.0-rc2-00011-g4ab2ee7 ehci_hcd
[    4.405429] usb usb1: SerialNumber: 0000:00:1d.7
[    4.410296] hub 1-0:1.0: USB hub found
[    4.414176] hub 1-0:1.0: 6 ports detected
[    4.418469] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.424771] ohci-pci: OHCI PCI platform driver
[    4.429347] uhci_hcd: USB Universal Host Controller Interface driver
[    4.436019] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.441431] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    4.449014] uhci_hcd 0000:00:1d.0: detected 2 ports
[    4.454024] uhci_hcd 0000:00:1d.0: irq 17, io base 0x00001800
[    4.459938] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    4.466843] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.474244] usb usb2: Product: UHCI Host Controller
[    4.479245] usb usb2: Manufacturer: Linux 3.17.0-rc2-00011-g4ab2ee7 uhci_hcd
[    4.486413] usb usb2: SerialNumber: 0000:00:1d.0
[    4.491268] hub 2-0:1.0: USB hub found
[    4.495150] hub 2-0:1.0: 2 ports detected
[    4.499546] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.504945] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    4.512529] uhci_hcd 0000:00:1d.1: detected 2 ports
[    4.517554] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001820
[    4.523466] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    4.530371] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.537779] usb usb3: Product: UHCI Host Controller
[    4.542772] usb usb3: Manufacturer: Linux 3.17.0-rc2-00011-g4ab2ee7 uhci_hcd
[    4.549939] usb usb3: SerialNumber: 0000:00:1d.1
[    4.554790] hub 3-0:1.0: USB hub found
[    4.558664] hub 3-0:1.0: 2 ports detected
[    4.563047] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.568444] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    4.576030] uhci_hcd 0000:00:1d.2: detected 2 ports
[    4.581053] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001840
[    4.586964] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    4.593871] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.601280] usb usb4: Product: UHCI Host Controller
[    4.606271] usb usb4: Manufacturer: Linux 3.17.0-rc2-00011-g4ab2ee7 uhci_hcd
[    4.613438] usb usb4: SerialNumber: 0000:00:1d.2
[    4.618310] hub 4-0:1.0: USB hub found
[    4.622184] hub 4-0:1.0: 2 ports detected
[    4.626491] usbcore: registered new interface driver usbserial
[    4.632455] usbcore: registered new interface driver usbserial_generic
[    4.639110] usbserial: USB Serial support registered for generic
[    4.645264] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    4.654470] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.656027] tsc: Refined TSC clocksource calibration: 2666.669 MHz
[    4.665876] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.671170] mousedev: PS/2 mouse device common for all mice
[    4.677088] rtc_cmos 00:01: RTC can wake from S4
[    4.681978] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    4.688212] rtc_cmos 00:01: alarms up to one month, y3k, 114 bytes nvram
[    4.695061] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    4.700775] iTCO_wdt: Found a 631xESB/632xESB TCO device (Version=2, TCOBASE=0x1060)
[    4.708814] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    4.714955] iTCO_vendor_support: vendor-support=0
[    4.720224] hidraw: raw HID events driver (C) Jiri Kosina
[    4.725887] usbcore: registered new interface driver usbhid
[    4.731582] usbhid: USB HID core driver
[    4.735575] drop_monitor: Initializing network drop monitor service
[    4.742041] TCP: cubic registered
[    4.745480] Initializing XFRM netlink socket
[    4.750057] NET: Registered protocol family 10
[    4.754974] NET: Registered protocol family 17
[    4.759555] 9pnet: Installing 9P2000 support
[    4.764260] 
[    4.764260] printing PIC contents
[    4.769234] ... PIC  IMR: ffff
[    4.770228] ... PIC  IRR: 0c21
[    4.775580] ... PIC  ISR: 0000
[    4.778758] ... PIC ELCR: 0e20
[    4.781933] printing local APIC contents on CPU#0/0:
[    4.782930] ... APIC ID:      00000000 (0)
[    4.782930] ... APIC VERSION: 00050014
[    4.782930] ... APIC TASKPRI: 00000000 (00)
[    4.782930] ... APIC PROCPRI: 00000000
[    4.782930] ... APIC LDR: 01000000
[    4.782930] ... APIC DFR: ffffffff
[    4.782930] ... APIC SPIV: 000001ff
[    4.782930] ... APIC ISR field:
[    4.782930] 0000000000000000000000000000000000000000000000000000000000000000
[    4.782930] ... APIC TMR field:
[    4.782930] 0000000000000000000000000000000000020002000200020000000000000000
[    4.782930] ... APIC IRR field:
[    4.782930] 0000000000000000000000000000000000000000000000000000000020000000
[    4.782930] ... APIC ESR: 00000000
[    4.782930] ... APIC ICR: 000008fd
[    4.782930] ... APIC ICR2: 08000000
[    4.782930] ... APIC LVTT: 000000ef
[    4.782930] ... APIC LVTPC: 00000400
[    4.782930] ... APIC LVT0: 00010700
[    4.782930] ... APIC LVT1: 00000400
[    4.782930] ... APIC LVTERR: 000000fe
[    4.782930] ... APIC TMICT: 0062472c
[    4.782930] ... APIC TMCCT: 003a46b8
[    4.782930] ... APIC TDCR: 00000003
[    4.782930] 
[    4.889518] number of MP IRQ sources: 15.
[    4.893649] number of IO-APIC #2 registers: 24.
[    4.898294] number of IO-APIC #3 registers: 24.
[    4.902939] testing the IO APIC.......................
[    4.908195] IO APIC #2......
[    4.911191] .... register #00: 02000000
[    4.915142] .......    : physical APIC id: 02
[    4.919613] .......    : Delivery Type: 0
[    4.923740] .......    : LTS          : 0
[    4.927867] .... register #01: 00170020
[    4.931817] .......     : max redirection entries: 17
[    4.936981] .......     : PRQ implemented: 0
[    4.941367] .......     : IO APIC version: 20
[    4.945838] .... IRQ redirection table:
[    4.949796] 1    0    0   0   0    0    0    00
[    4.954451] 0    0    0   0   0    1    1    31
[    4.959102] 0    0    0   0   0    1    1    30
[    4.963757] 0    0    0   0   0    1    1    33
[    4.968410] 0    0    0   0   0    1    1    34
[    4.973063] 0    0    0   0   0    1    1    35
[    4.977710] 0    0    0   0   0    1    1    36
[    4.982362] 0    0    0   0   0    1    1    37
[    4.983020] usb 2-2: new low-speed USB device number 2 using uhci_hcd
[    4.993569] 0    0    0   0   0    1    1    38
[    4.998214] 0    1    0   0   0    1    1    39
[    5.002864] 0    0    0   0   0    1    1    3A
[    5.007521] 0    0    0   0   0    1    1    3B
[    5.012179] 0    0    0   0   0    1    1    3C
[    5.016831] 0    0    0   0   0    1    1    3D
[    5.021486] 0    0    0   0   0    1    1    3E
[    5.026146] 0    0    0   0   0    1    1    3F
[    5.030794] 1    1    0   1   0    1    1    81
[    5.035446] 0    1    0   1   0    1    1    91
[    5.040102] 0    1    0   1   0    1    1    B1
[    5.044754] 0    1    0   1   0    1    1    D1
[    5.049399] 1    0    0   0   0    0    0    00
[    5.054044] 1    0    0   0   0    0    0    00
[    5.058690] 1    0    0   0   0    0    0    00
[    5.063336] 1    0    0   0   0    0    0    00
[    5.067993] IO APIC #3......
[    5.070995] .... register #00: 03000000
[    5.074965] .......    : physical APIC id: 03
[    5.079436] .......    : Delivery Type: 0
[    5.083560] .......    : LTS          : 0
[    5.087686] .... register #01: 00178020
[    5.091639] .......     : max redirection entries: 17
[    5.096803] .......     : PRQ implemented: 1
[    5.101189] .......     : IO APIC version: 20
[    5.105662] .... register #02: 03000000
[    5.109614] .......     : arbitration: 03
[    5.113737] .... register #03: 00000001
[    5.117691] .......     : Boot DT    : 1
[    5.121728] .... IRQ redirection table:
[    5.125685] 1    0    0   0   0    0    0    00
[    5.130344] 1    0    0   0   0    0    0    00
[    5.134991] 1    0    0   0   0    0    0    00
[    5.139637] 1    0    0   0   0    0    0    00
[    5.144290] 1    0    0   0   0    0    0    00
[    5.148934] 1    0    0   0   0    0    0    00
[    5.153581] 1    0    0   0   0    0    0    00
[    5.158228] 1    0    0   0   0    0    0    00
[    5.162891] 1    0    0   0   0    0    0    00
[    5.167545] 1    0    0   0   0    0    0    00
[    5.172197] 1    0    0   0   0    0    0    00
[    5.176843] 1    0    0   0   0    0    0    00
[    5.181495] 1    0    0   0   0    0    0    00
[    5.186141] 1    0    0   0   0    0    0    00
[    5.190796] 1    0    0   0   0    0    0    00
[    5.195451] 1    0    0   0   0    0    0    00
[    5.200109] 1    0    0   0   0    0    0    00
[    5.204757] 1    0    0   0   0    0    0    00
[    5.209404] 1    0    0   0   0    0    0    00
[    5.214059] 1    0    0   0   0    0    0    00
[    5.218718] 1    0    0   0   0    0    0    00
[    5.223366] 1    0    0   0   0    0    0    00
[    5.224939] usb 2-2: New USB device found, idVendor=0557, idProduct=2220
[    5.224941] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.224942] usb 2-2: Product: ATEN  CS-1758/54
[    5.224944] usb 2-2: Manufacturer: ATEN
[    5.250641] 1    0    0   0   0    0    0    00
[    5.255293] 1    0    0   0   0    0    0    00
[    5.259949] IRQ to pin mappings:
[    5.263301] IRQ0 -> 0:2
[    5.265996] IRQ1 -> 0:1
[    5.268693] IRQ3 -> 0:3
[    5.271397] IRQ4 -> 0:4
[    5.274097] IRQ5 -> 0:5
[    5.276796] IRQ6 -> 0:6
[    5.279491] IRQ7 -> 0:7
[    5.282210] IRQ8 -> 0:8
[    5.284890] IRQ9 -> 0:9
[    5.287584] IRQ10 -> 0:10
[    5.290447] IRQ11 -> 0:11
[    5.293313] IRQ12 -> 0:12
[    5.296180] IRQ13 -> 0:13
[    5.299040] IRQ14 -> 0:14
[    5.301904] IRQ15 -> 0:15
[    5.304771] IRQ16 -> 0:16
[    5.307630] IRQ17 
[    5.309378] input: ATEN ATEN  CS-1758/54 as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/0003:0557:2220.0001/input/input5
[    5.309489] hid-generic 0003:0557:2220.0001: input,hidraw0: USB HID v1.10 Keyboard [ATEN ATEN  CS-1758/54] on usb-0000:00:1d.0-2/input0

[    5.333470] -> 0:17
[    5.336064] IRQ18 -> 0:18
[    5.338927] IRQ19 -> 0:19
[    5.341796] .................................... done.
[    5.347217] Loading compiled-in X.509 certificates
[    5.353229] Loaded X.509 cert 'Magrathea: Glacier signing key: 147c3461adf97819cd11ff63674270cbc5962740'
[    5.362931] registered taskstats version 1
[    5.363295] input: ATEN ATEN  CS-1758/54 as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/0003:0557:2220.0002/input/input6
[    5.363378] hid-generic 0003:0557:2220.0002: input,hidraw1: USB HID v1.10 Mouse [ATEN ATEN  CS-1758/54] on usb-0000:00:1d.0-2/input1
[    5.393109] Key type trusted registered
[    5.398660] Key type encrypted registered
[    5.404405] ima: No TPM chip found, activating TPM-bypass!
[    5.410055] evm: HMAC attrs: 0x1
[    5.413893] rtc_cmos 00:01: setting system clock to 2014-09-25 00:13:24 UTC (1411604004)
[    5.447469] ------------[ cut here ]------------
[    5.452212] WARNING: CPU: 0 PID: 1 at drivers/pci/msi.c:1034 pci_enable_msi_range+0x2c1/0x2f0()
[    5.462479] Modules linked in:
[    5.465712] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc2-00011-g4ab2ee7 #1
[    5.473467] Hardware name: Supermicro X7DB8/X7DB8, BIOS 6.00 04/28/2006
[    5.480202]  0000000000000009 ffff880139ab7c00 ffffffff8185b75a 0000000000000000
[    5.488043]  ffff880139ab7c38 ffffffff8107056d 0000000000000001 ffff88007f8ec000
[    5.495879]  ffff88013974e098 ffff88013974e000 ffff88007f8ecdb8 ffff880139ab7c48
[    5.503722] Call Trace:
[    5.506293]  [<ffffffff8185b75a>] dump_stack+0x4d/0x66
[    5.511552]  [<ffffffff8107056d>] warn_slowpath_common+0x7d/0xa0
[    5.517675]  [<ffffffff8107064a>] warn_slowpath_null+0x1a/0x20
[    5.523631]  [<ffffffff81449961>] pci_enable_msi_range+0x2c1/0x2f0
[    5.529932]  [<ffffffff815b490a>] e1000_open+0x22a/0x4b0
[    5.535368]  [<ffffffff8172d466>] __dev_open+0xb6/0x130
[    5.540712]  [<ffffffff8172d77d>] __dev_change_flags+0x9d/0x160
[    5.546754]  [<ffffffff8172d869>] dev_change_flags+0x29/0x70
[    5.552534]  [<ffffffff81e5707e>] ip_auto_config+0x1c4/0xe7f
[    5.558314]  [<ffffffff81e56eba>] ? root_nfs_parse_addr+0xba/0xba
[    5.564529]  [<ffffffff81405f1e>] ? kasprintf+0x3e/0x40
[    5.569876]  [<ffffffff81e56eba>] ? root_nfs_parse_addr+0xba/0xba
[    5.576091]  [<ffffffff81002130>] do_one_initcall+0xc0/0x1f0
[    5.581871]  [<ffffffff81002130>] ? do_one_initcall+0xc0/0x1f0
[    5.587826]  [<ffffffff8108f000>] ? parse_args+0x180/0x4e0
[    5.593436]  [<ffffffff81df511b>] kernel_init_freeable+0x1b3/0x23b
[    5.599735]  [<ffffffff8184ed70>] ? rest_init+0x90/0x90
[    5.605079]  [<ffffffff8184ed7e>] kernel_init+0xe/0xf0
[    5.610341]  [<ffffffff8186437c>] ret_from_fork+0x7c/0xb0
[    5.615861]  [<ffffffff8184ed70>] ? rest_init+0x90/0x90
[    5.621207] ---[ end trace 3e09fff841f00690 ]---
[    5.625958] e1000e 0000:06:00.0: irq 27 for MSI/MSI-X
[    5.631145] e1000e 0000:06:00.0: irq 28 for MSI/MSI-X
[    5.636319] ------------[ cut here ]------------
[    5.641057] WARNING: CPU: 0 PID: 1 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x64/0x80()
[    5.650197] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:02.0/0000:01:00.0/0000:02:02.0/0000:06:00.0/msi_irqs'
[    5.662464] Modules linked in:
[    5.665695] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W      3.17.0-rc2-00011-g4ab2ee7 #1
[    5.674576] Hardware name: Supermicro X7DB8/X7DB8, BIOS 6.00 04/28/2006
[    5.681311]  0000000000000009 ffff880139ab7ad8 ffffffff8185b75a ffff880139ab7b20
[    5.689154]  ffff880139ab7b10 ffffffff8107056d ffff880139757000 ffffffff81b63eab
[    5.697019]  ffff880139735780 ffff88013975ae00 ffff88013974e000 ffff880139ab7b70
[    5.704869] Call Trace:
[    5.707434]  [<ffffffff8185b75a>] dump_stack+0x4d/0x66
[    5.712693]  [<ffffffff8107056d>] warn_slowpath_common+0x7d/0xa0
[    5.718822]  [<ffffffff810705dc>] warn_slowpath_fmt+0x4c/0x50
[    5.726258]  [<ffffffff812530a8>] ? kernfs_path+0x48/0x60
[    5.731778]  [<ffffffff81256a64>] sysfs_warn_dup+0x64/0x80
[    5.737385]  [<ffffffff812574d7>] internal_create_group+0x277/0x280
[    5.743773]  [<ffffffff81257609>] sysfs_create_groups+0x49/0xa0
[    5.749813]  [<ffffffff814492ad>] populate_msi_sysfs+0x1bd/0x200
[    5.755939]  [<ffffffff8144985f>] pci_enable_msi_range+0x1bf/0x2f0
[    5.762250]  [<ffffffff815b490a>] e1000_open+0x22a/0x4b0
[    5.767685]  [<ffffffff8172d466>] __dev_open+0xb6/0x130
[    5.773030]  [<ffffffff8172d77d>] __dev_change_flags+0x9d/0x160
[    5.779072]  [<ffffffff8172d869>] dev_change_flags+0x29/0x70
[    5.784853]  [<ffffffff81e5707e>] ip_auto_config+0x1c4/0xe7f
[    5.790632]  [<ffffffff81e56eba>] ? root_nfs_parse_addr+0xba/0xba
[    5.796846]  [<ffffffff81405f1e>] ? kasprintf+0x3e/0x40
[    5.802186]  [<ffffffff81e56eba>] ? root_nfs_parse_addr+0xba/0xba
[    5.808401]  [<ffffffff81002130>] do_one_initcall+0xc0/0x1f0
[    5.814181]  [<ffffffff81002130>] ? do_one_initcall+0xc0/0x1f0
[    5.820135]  [<ffffffff8108f000>] ? parse_args+0x180/0x4e0
[    5.825742]  [<ffffffff81df511b>] kernel_init_freeable+0x1b3/0x23b
[    5.832042]  [<ffffffff8184ed70>] ? rest_init+0x90/0x90
[    5.837391]  [<ffffffff8184ed7e>] kernel_init+0xe/0xf0
[    5.842649]  [<ffffffff8186437c>] ret_from_fork+0x7c/0xb0
[    5.848170]  [<ffffffff8184ed70>] ? rest_init+0x90/0x90
[    5.853509] ---[ end trace 3e09fff841f00691 ]---
[    5.858259] ------------[ cut here ]------------
[    5.858262] Switched to clocksource tsc
[    5.866941] WARNING: CPU: 0 PID: 1 at drivers/pci/msi.c:1034 pci_enable_msi_range+0x2c1/0x2f0()
[    5.877208] Modules linked in:
[    5.880438] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W      3.17.0-rc2-00011-g4ab2ee7 #1
[    5.889317] Hardware name: Supermicro X7DB8/X7DB8, BIOS 6.00 04/28/2006
[    5.896040]  0000000000000009 ffff880139ab7be8 ffffffff8185b75a 0000000000000000
[    5.903871]  ffff880139ab7c20 ffffffff8107056d 0000000000000001 ffff88007f8ec000
[    5.911707]  ffff88013974e098 ffff88013974e000 ffff88007f8ecdb8 ffff880139ab7c30
[    5.919540] Call Trace:
[    5.922103]  [<ffffffff8185b75a>] dump_stack+0x4d/0x66
[    5.927355]  [<ffffffff8107056d>] warn_slowpath_common+0x7d/0xa0
[    5.933473]  [<ffffffff8107064a>] warn_slowpath_null+0x1a/0x20
[    5.939417]  [<ffffffff81449961>] pci_enable_msi_range+0x2c1/0x2f0
[    5.945709]  [<ffffffff814498c7>] ? pci_enable_msi_range+0x227/0x2f0
[    5.952177]  [<ffffffff815afa56>] e1000e_set_interrupt_capability+0x46/0x130
[    5.959343]  [<ffffffff815b49d1>] e1000_open+0x2f1/0x4b0
[    5.964770]  [<ffffffff8172d466>] __dev_open+0xb6/0x130
[    5.970108]  [<ffffffff8172d77d>] __dev_change_flags+0x9d/0x160
[    5.976140]  [<ffffffff8172d869>] dev_change_flags+0x29/0x70
[    5.981910]  [<ffffffff81e5707e>] ip_auto_config+0x1c4/0xe7f
[    5.987683]  [<ffffffff81e56eba>] ? root_nfs_parse_addr+0xba/0xba
[    5.993887]  [<ffffffff81405f1e>] ? kasprintf+0x3e/0x40
[    5.999227]  [<ffffffff81e56eba>] ? root_nfs_parse_addr+0xba/0xba
[    6.005431]  [<ffffffff81002130>] do_one_initcall+0xc0/0x1f0
[    6.011203]  [<ffffffff81002130>] ? do_one_initcall+0xc0/0x1f0
[    6.017148]  [<ffffffff8108f000>] ? parse_args+0x180/0x4e0
[    6.022749]  [<ffffffff81df511b>] kernel_init_freeable+0x1b3/0x23b
[    6.029039]  [<ffffffff8184ed70>] ? rest_init+0x90/0x90
[    6.034380]  [<ffffffff8184ed7e>] kernel_init+0xe/0xf0
[    6.039631]  [<ffffffff8186437c>] ret_from_fork+0x7c/0xb0
[    6.045143]  [<ffffffff8184ed70>] ? rest_init+0x90/0x90
[    6.050480] ---[ end trace 3e09fff841f00692 ]---
[    6.055229] e1000e 0000:06:00.0: irq 27 for MSI/MSI-X
[    6.060517] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    6.091833] ------------[ cut here ]------------
[    6.096564] WARNING: CPU: 0 PID: 1 at drivers/pci/msi.c:1034 pci_enable_msi_range+0x2c1/0x2f0()
[    6.106829] Modules linked in:
[    6.110063] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W      3.17.0-rc2-00011-g4ab2ee7 #1
[    6.118939] Hardware name: Supermicro X7DB8/X7DB8, BIOS 6.00 04/28/2006
[    6.125663]  0000000000000009 ffff880139ab7c00 ffffffff8185b75a 0000000000000000
[    6.133495]  ffff880139ab7c38 ffffffff8107056d 0000000000000001 ffff88007f8f8000
[    6.141329]  ffff88013974f098 ffff88013974f000 ffff88007f8f8db8 ffff880139ab7c48
[    6.149165] Call Trace:
[    6.151726]  [<ffffffff8185b75a>] dump_stack+0x4d/0x66
[    6.156978]  [<ffffffff8107056d>] warn_slowpath_common+0x7d/0xa0
[    6.163095]  [<ffffffff8107064a>] warn_slowpath_null+0x1a/0x20
[    6.169039]  [<ffffffff81449961>] pci_enable_msi_range+0x2c1/0x2f0
[    6.175333]  [<ffffffff815b490a>] e1000_open+0x22a/0x4b0
[    6.180758]  [<ffffffff8172d466>] __dev_open+0xb6/0x130
[    6.186097]  [<ffffffff8172d77d>] __dev_change_flags+0x9d/0x160
[    6.192127]  [<ffffffff8172d869>] dev_change_flags+0x29/0x70
[    6.197900]  [<ffffffff81e5707e>] ip_auto_config+0x1c4/0xe7f
[    6.203672]  [<ffffffff81e56eba>] ? root_nfs_parse_addr+0xba/0xba
[    6.209880]  [<ffffffff81405f1e>] ? kasprintf+0x3e/0x40
[    6.215217]  [<ffffffff81e56eba>] ? root_nfs_parse_addr+0xba/0xba
[    6.221422]  [<ffffffff81002130>] do_one_initcall+0xc0/0x1f0
[    6.227194]  [<ffffffff81002130>] ? do_one_initcall+0xc0/0x1f0
[    6.233140]  [<ffffffff8108f000>] ? parse_args+0x180/0x4e0
[    6.238737]  [<ffffffff81df511b>] kernel_init_freeable+0x1b3/0x23b
[    6.245029]  [<ffffffff8184ed70>] ? rest_init+0x90/0x90
[    6.250369]  [<ffffffff8184ed7e>] kernel_init+0xe/0xf0
[    6.255620]  [<ffffffff8186437c>] ret_from_fork+0x7c/0xb0
[    6.261132]  [<ffffffff8184ed70>] ? rest_init+0x90/0x90
[    6.266471] ---[ end trace 3e09fff841f00693 ]---
[    6.271218] e1000e 0000:06:00.1: irq 28 for MSI/MSI-X
[    6.276397] e1000e 0000:06:00.1: irq 29 for MSI/MSI-X
[    6.281563] ------------[ cut here ]------------
[    6.286292] WARNING: CPU: 0 PID: 1 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x64/0x80()
[    6.295425] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:02.0/0000:01:00.0/0000:02:02.0/0000:06:00.1/msi_irqs'
[    6.307687] Modules linked in:
[    6.310920] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W      3.17.0-rc2-00011-g4ab2ee7 #1
[    6.319794] Hardware name: Supermicro X7DB8/X7DB8, BIOS 6.00 04/28/2006
[    6.326520]  0000000000000009 ffff880139ab7ad8 ffffffff8185b75a ffff880139ab7b20
[    6.334354]  ffff880139ab7b10 ffffffff8107056d ffff880139757000 ffffffff81b63eab
[    6.342188]  ffff8801397369d8 ffff88013975aea0 ffff88013974f000 ffff880139ab7b70
[    6.350023] Call Trace:
[    6.352582]  [<ffffffff8185b75a>] dump_stack+0x4d/0x66
[    6.357836]  [<ffffffff8107056d>] warn_slowpath_common+0x7d/0xa0
[    6.363955]  [<ffffffff810705dc>] warn_slowpath_fmt+0x4c/0x50
[    6.369813]  [<ffffffff812530a8>] ? kernfs_path+0x48/0x60
[    6.375323]  [<ffffffff81256a64>] sysfs_warn_dup+0x64/0x80
[    6.380924]  [<ffffffff812574d7>] internal_create_group+0x277/0x280
[    6.387302]  [<ffffffff81257609>] sysfs_create_groups+0x49/0xa0
[    6.393334]  [<ffffffff814492ad>] populate_msi_sysfs+0x1bd/0x200
[    6.399452]  [<ffffffff8144985f>] pci_enable_msi_range+0x1bf/0x2f0
[    6.405743]  [<ffffffff815b490a>] e1000_open+0x22a/0x4b0
[    6.411169]  [<ffffffff8172d466>] __dev_open+0xb6/0x130
[    6.416508]  [<ffffffff8172d77d>] __dev_change_flags+0x9d/0x160
[    6.422540]  [<ffffffff8172d869>] dev_change_flags+0x29/0x70
[    6.428313]  [<ffffffff81e5707e>] ip_auto_config+0x1c4/0xe7f
[    6.434084]  [<ffffffff81e56eba>] ? root_nfs_parse_addr+0xba/0xba
[    6.440290]  [<ffffffff81405f1e>] ? kasprintf+0x3e/0x40
[    6.445628]  [<ffffffff81e56eba>] ? root_nfs_parse_addr+0xba/0xba
[    6.451832]  [<ffffffff81002130>] do_one_initcall+0xc0/0x1f0
[    6.457607]  [<ffffffff81002130>] ? do_one_initcall+0xc0/0x1f0
[    6.463552]  [<ffffffff8108f000>] ? parse_args+0x180/0x4e0
[    6.469149]  [<ffffffff81df511b>] kernel_init_freeable+0x1b3/0x23b
[    6.475440]  [<ffffffff8184ed70>] ? rest_init+0x90/0x90
[    6.480779]  [<ffffffff8184ed7e>] kernel_init+0xe/0xf0
[    6.486031]  [<ffffffff8186437c>] ret_from_fork+0x7c/0xb0
[    6.491544]  [<ffffffff8184ed70>] ? rest_init+0x90/0x90
[    6.496882] ---[ end trace 3e09fff841f00694 ]---
[    6.501618] ------------[ cut here ]------------
[    6.506347] WARNING: CPU: 0 PID: 1 at drivers/pci/msi.c:1034 pci_enable_msi_range+0x2c1/0x2f0()
[    6.516615] Modules linked in:
[    6.519846] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W      3.17.0-rc2-00011-g4ab2ee7 #1
[    6.528723] Hardware name: Supermicro X7DB8/X7DB8, BIOS 6.00 04/28/2006
[    6.535448]  0000000000000009 ffff880139ab7be8 ffffffff8185b75a 0000000000000000
[    6.543273]  ffff880139ab7c20 ffffffff8107056d 0000000000000001 ffff88007f8f8000
[    6.551108]  ffff88013974f098 ffff88013974f000 ffff88007f8f8db8 ffff880139ab7c30
[    6.558942] Call Trace:
[    6.561501]  [<ffffffff8185b75a>] dump_stack+0x4d/0x66
[    6.566753]  [<ffffffff8107056d>] warn_slowpath_common+0x7d/0xa0
[    6.572870]  [<ffffffff8107064a>] warn_slowpath_null+0x1a/0x20
[    6.578817]  [<ffffffff81449961>] pci_enable_msi_range+0x2c1/0x2f0
[    6.585109]  [<ffffffff814498c7>] ? pci_enable_msi_range+0x227/0x2f0
[    6.591575]  [<ffffffff815afa56>] e1000e_set_interrupt_capability+0x46/0x130
[    6.598741]  [<ffffffff815b49d1>] e1000_open+0x2f1/0x4b0
[    6.604166]  [<ffffffff8172d466>] __dev_open+0xb6/0x130
[    6.609505]  [<ffffffff8172d77d>] __dev_change_flags+0x9d/0x160
[    6.615538]  [<ffffffff8172d869>] dev_change_flags+0x29/0x70
[    6.621309]  [<ffffffff81e5707e>] ip_auto_config+0x1c4/0xe7f
[    6.627082]  [<ffffffff81e56eba>] ? root_nfs_parse_addr+0xba/0xba
[    6.633288]  [<ffffffff81405f1e>] ? kasprintf+0x3e/0x40
[    6.638625]  [<ffffffff81e56eba>] ? root_nfs_parse_addr+0xba/0xba
[    6.644832]  [<ffffffff81002130>] do_one_initcall+0xc0/0x1f0
[    6.650602]  [<ffffffff81002130>] ? do_one_initcall+0xc0/0x1f0
[    6.656549]  [<ffffffff8108f000>] ? parse_args+0x180/0x4e0
[    6.662150]  [<ffffffff81df511b>] kernel_init_freeable+0x1b3/0x23b
[    6.668447]  [<ffffffff8184ed70>] ? rest_init+0x90/0x90
[    6.673786]  [<ffffffff8184ed7e>] kernel_init+0xe/0xf0
[    6.679040]  [<ffffffff8186437c>] ret_from_fork+0x7c/0xb0
[    6.684550]  [<ffffffff8184ed70>] ? rest_init+0x90/0x90
[    6.689889] ---[ end trace 3e09fff841f00695 ]---
[    6.694635] e1000e 0000:06:00.1: irq 28 for MSI/MSI-X
[    6.701485] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[    8.195378] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[    8.209012] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    8.220006] Sending DHCP requests .., OK
[   11.553017] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.134
[   11.618083] e1000e: eth1 NIC Link is Down
[   11.622301] IP-Config: Complete:
[   11.625648]      device=eth0, hwaddr=00:30:48:30:70:e0, ipaddr=192.168.1.134, mask=255.255.255.0, gw=192.168.1.1
[   11.636005]      host=bens, domain=lkp.intel.com, nis-domain=(none)
[   11.642384]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
[   11.649132]      nameserver0=192.168.1.1
[   11.653548] PM: Hibernation image not present or could not be loaded.
[   11.661752] Freeing unused kernel memory: 1804K (ffffffff81dde000 - ffffffff81fa1000)
[   11.847955] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   11.876783] i5k_amb: probe of i5k_amb.0 failed with error -16
[   11.887143] EDAC MC: Ver: 3.0.0
[   11.890564] aic79xx 0000:04:02.0: enabling device (0152 -> 0153)
[   11.896805] aic79xx 0000:04:02.0: PCI IRQ 16 -> rerouted to legacy IRQ 16
[   11.906404] EDAC MC0: Giving out device to module i5000_edac.c controller I5000: DEV 0000:00:10.0 (POLLED)
[   11.916285] EDAC PCI0: Giving out device to module i5000_edac controller EDAC PCI controller: DEV 0000:00:10.0 (POLLED)
[   12.089956] input: PC Speaker as /devices/platform/pcspkr/input/input7
[   12.101511] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[   12.107965] libata version 3.00 loaded.
[   12.113737] ata_piix 0000:00:1f.2: version 2.13
[   12.118577] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[   12.124448] scsi host1: ata_piix
[   12.127992] scsi host2: ata_piix
[   12.131441] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x1870 irq 14
[   12.131460] Error: Driver 'pcspkr' is already registered, aborting...
[   12.145085] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1878 irq 15
[   12.306291] ata1.00: ATA-6: ST3120026AS, 3.00, max UDMA/133
[   12.311991] ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   12.324264] ata1.00: configured for UDMA/133
[   12.328800] scsi 1:0:0:0: Direct-Access     ATA      ST3120026AS      3.00 PQ: 0 ANSI: 5
[   12.475293] ata2.01: ATAPI: LITE-ON COMBO SOHC-5236V, R$0C, max UDMA/44
[   12.482043] ata2.01: limited to UDMA/33 due to 40-wire cable
[   12.509174] ata2.01: configured for UDMA/33
[   12.515364] scsi 2:0:1:0: CD-ROM            LITE-ON  COMBO SOHC-5236V R$0C PQ: 0 ANSI: 5
[   12.559324] sr 2:0:1:0: [sr0] scsi3-mmc drive: 0x/52x writer cd/rw xa/form2 cdda tray
[   12.567348] cdrom: Uniform CD-ROM driver Revision: 3.20
[   12.573046] sr 2:0:1:0: Attached scsi CD-ROM sr0
[   12.575070] sd 1:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
[   12.575137] sd 1:0:0:0: [sda] Write Protect is off
[   12.575139] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   12.575167] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   12.608401] sd 1:0:0:0: Attached scsi generic sg0 type 0
[   12.613881] sr 2:0:1:0: Attached scsi generic sg1 type 5
[   12.648736]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
[   12.654820] sd 1:0:0:0: [sda] Attached SCSI disk
[   12.966888] random: nonblocking pool is initialized
[   15.120033] floppy0: no floppy controllers found
[   27.020029] scsi host0: Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
[   27.020029]         <Adaptec AIC7902 Ultra320 SCSI adapter>
[   27.020029]         aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 67-100MHz, 512 SCBs
[   27.040829] aic79xx 0000:04:02.1: enabling device (0152 -> 0153)
[   27.047034] aic79xx 0000:04:02.1: PCI IRQ 17 -> rerouted to legacy IRQ 17
[   28.846321] scsi 0:0:8:0: Processor         SUPER    GEM359 REV001    1.09 PQ: 0 ANSI: 2
[   28.854622] scsi target0:0:8: asynchronous
[   28.858844] scsi target0:0:8: Beginning Domain Validation
[   28.876294] scsi target0:0:8: Ending Domain Validation
[   30.687208] scsi 0:0:8:0: Attached scsi generic sg2 type 3
[   42.170020] scsi host3: Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
[   42.170020]         <Adaptec AIC7902 Ultra320 SCSI adapter>
[   42.170020]         aic7902: Ultra320 Wide Channel B, SCSI Id=7, PCI-X 67-100MHz, 512 SCBs
[   46.081511] fuse init (API version 7.23)
[   46.190555] device-mapper: uevent: version 1.0.3
[   46.195482] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[   47.125508] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).

==> /lkp/lkp/src/tmp/run_log <==

==> /lkp/lkp/src/tmp/err_log <==

==> /lkp/lkp/src/tmp/run_log <==
25 Sep 00:14:13 ntpdate[1648]: step time server 192.168.1.1 offset 0.247349 sec
Kernel tests: Boot OK!
LKP: HOSTNAME bens, MAC 00:30:48:30:70:e0, kernel 3.17.0-rc2-00011-g4ab2ee7 1, serial console /dev/ttyS0
/lkp/lkp/src/bin/run-lkp
[   53.967340] ipmi message handler version 39.2
[   53.973425] IPMI Watchdog: driver initialized
Stopping watchdog keepalive daemon....
Starting watchdog daemon...RESULT_ROOT=/result/bens/boot/performance-1/debian-x86_64.cgz/x86_64-rhel/4ab2ee7c77875669230
[   54.001783] bmc-watchdog:1700 map pfn expected mapping type uncached-minus for [mem 0x00000000-0x00000fff], got write-back
a797a3ed2228990f82545/0
job=/lkp/scheduled/bens/bisect_boot-performance-1-x86_64-rhel-4ab2ee7c77875669230a797a3ed2228990f82545-0.yaml

--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--LZvS9be/3tNcYl/X--
