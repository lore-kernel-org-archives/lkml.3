Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbaKGFqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 00:46:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:1927 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbaKGFqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 00:46:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="412838258"
Date: Fri, 7 Nov 2014 13:46:55 +0800
From: LKP <lkp@01.org>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [AHCI] genirq: Flags mismatch irq 20. 00002080 (ahci) vs.
  00000080 (i801_smbus)
Message-ID: <20141107054655.GA30507@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

FYI, we noticed the below changes on

git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git fixes-3.18-rc1
commit ef78bbdb4dd6ef84f6d4c670f40ec202fe9807f4 ("AHCI: Fix threaded interrupt setup")

2974a1837592b49d  ef78bbdb4dd6ef84f6d4c670f4  testbox/testcase/testparams
----------------  --------------------------  ---------------------------
       fail:runs  %reproduction    fail:runs
           |             |             |
           :12         100%           5:5     client5/boot/performance-1
           :12         100%           5:5     TOTAL dmesg.genirq:Flags_mismatch_irq##(ahci)vs.#(i801_smbus)


client5: cpu: Core, memory: 12G


[   16.143988] ipmi_si 00:07: Found new BMC (man_id: 0x000157, prod_id: 0x0028, dev_id: 0x20)
[   16.143995] ipmi_si 00:07: IPMI kcs interface initialized
[   16.163607] ahci 0000:00:1f.2: flags: 64bit ncq pm led pmp slum part 
[   16.170555] genirq: Flags mismatch irq 20. 00002080 (ahci) vs. 00000080 (i801_smbus)
[   16.171533] CPU: 1 PID: 369 Comm: modprobe Not tainted 3.18.0-rc2-wl-ga4fb664 #1
[   16.171533] Hardware name: Intel S5000PAL/S5000PAL0, BIOS S5000.86B.10.00.0094.101320081858 10/13/2008
[   16.171533]  ffff88035d539b00 ffff88035d42b988 ffffffff8187741c 00000000000033c0
[   16.171533]  ffff88032efe5400 ffff88035d42b9e8 ffffffff810cbbaf ffff88035d42b9e8
[   16.171533]  0000000000000246 ffffffff810cbd22 ffff880344fa5800 ffff88035ca8a0e0
[   16.171533] Call Trace:
[   16.171533]  [<ffffffff8187741c>] dump_stack+0x4e/0x68
[   16.171533]  [<ffffffff810cbbaf>] __setup_irq+0x57f/0x5d0
[   16.171533]  [<ffffffff810cbd22>] ? request_threaded_irq+0x82/0x190
[   16.171533]  [<ffffffffa008c740>] ? ahci_dev_classify+0x60/0x60 [libahci]
[   16.171533]  [<ffffffff810cbd6c>] request_threaded_irq+0xcc/0x190
[   16.171533]  [<ffffffffa008c740>] ? ahci_dev_classify+0x60/0x60 [libahci]
[   16.171533]  [<ffffffffa008ce50>] ? ahci_port_thread_fn+0x600/0x600 [libahci]
[   16.171533]  [<ffffffff810cdc6f>] devm_request_threaded_irq+0x5f/0xc0
[   16.171533]  [<ffffffffa008d4f0>] ahci_host_activate+0x80/0x220 [libahci]
[   16.171533]  [<ffffffff8143ac1a>] ? pcibios_set_master+0x5a/0x90
[   16.171533]  [<ffffffffa00f5c45>] ahci_init_one+0x8c5/0xb60 [ahci]
[   16.171533]  [<ffffffff8143c365>] local_pci_probe+0x45/0xa0
[   16.171533]  [<ffffffff8143d6d5>] ? pci_match_device+0xe5/0x110
[   16.171533]  [<ffffffff8143d811>] pci_device_probe+0xd1/0x120
[   16.171533]  [<ffffffff81513320>] driver_probe_device+0x90/0x3e0
[   16.171533]  [<ffffffff8151374b>] __driver_attach+0x9b/0xa0
[   16.171533]  [<ffffffff815136b0>] ? __device_attach+0x40/0x40
[   16.171533]  [<ffffffff8151112b>] bus_for_each_dev+0x6b/0xb0
[   16.171533]  [<ffffffff81512d9e>] driver_attach+0x1e/0x20
[   16.171533]  [<ffffffff81512980>] bus_add_driver+0x180/0x250
[   16.171533]  [<ffffffffa002c000>] ? 0xffffffffa002c000
[   16.171533]  [<ffffffff81513f54>] driver_register+0x64/0xf0
[   16.171533]  [<ffffffff8143bbbc>] __pci_register_driver+0x4c/0x50
[   16.171533]  [<ffffffffa002c01e>] ahci_pci_driver_init+0x1e/0x1000 [ahci]
[   16.171533]  [<ffffffff81002130>] do_one_initcall+0xc0/0x1f0
[   16.171533]  [<ffffffff811a44d2>] ? __vunmap+0xa2/0x100
[   16.171533]  [<ffffffff810f6491>] load_module+0x15c1/0x1a60
[   16.171533]  [<ffffffff810f1e20>] ? store_uevent+0x40/0x40
[   16.171533]  [<ffffffff810f6ad6>] SyS_finit_module+0x86/0xb0
[   16.171533]  [<ffffffff8187fb29>] system_call_fastpath+0x12/0x17
[   16.403261] ahci: probe of 0000:00:1f.2 failed with error -16
[   16.409519] EDAC MC0: Giving out device to module i5000_edac.c controller I5000: DEV 0000:00:10.0 (POLLED)
[   16.419702] EDAC PCI0: Giving out device to module i5000_edac controller EDAC PCI controller: DEV 0000:00:10.0 (POLLED)

--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc2-wl-ga4fb664 (kbuild@xian) (gcc version 4.9.1 (Debian 4.9.1-19) ) #1 SMP Fri Oct 31 23:24:12 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/client5/boot_boot-performance-1-x86_64-rhel-a4fb6646dd55a6ba18df37134e9a22088da0a0db-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/a4fb6646dd55a6ba18df37134e9a22088da0a0db/vmlinuz-3.18.0-rc2-wl-ga4fb664 kconfig=x86_64-rhel commit=a4fb6646dd55a6ba18df37134e9a22088da0a0db branch=linux-devel/devel-hourly-2014103123 root=/dev/ram0 max_uptime=3600 RESULT_ROOT=/result/client5/boot/performance-1/debian-x86_64.cgz/x86_64-rhel/a4fb6646dd55a6ba18df37134e9a22088da0a0db/0 LKP_SERVER=10.239.97.14 ip=::::client5::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009ebff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009ec00-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000009e259fff] usable
[    0.000000] BIOS-e820: [mem 0x000000009e25a000-0x000000009e320fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000009e321000-0x000000009fa31fff] usable
[    0.000000] BIOS-e820: [mem 0x000000009fa32000-0x000000009fa99fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000009fa9a000-0x000000009faa8fff] usable
[    0.000000] BIOS-e820: [mem 0x000000009faa9000-0x000000009fb19fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000009fb1a000-0x000000009fb24fff] usable
[    0.000000] BIOS-e820: [mem 0x000000009fb25000-0x000000009fb39fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000009fb3a000-0x000000009fbfffff] usable
[    0.000000] BIOS-e820: [mem 0x000000009fc00000-0x00000000afffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffc0bfff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000035fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: Intel S5000PAL/S5000PAL0, BIOS S5000.86B.10.00.0094.101320081858 10/13/2008
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x360000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask 3F80000000 write-back
[    0.000000]   1 base 0080000000 mask 3FE0000000 write-back
[    0.000000]   2 base 009FC00000 mask 3FFFC00000 uncachable
[    0.000000]   3 base 0100000000 mask 3F00000000 write-back
[    0.000000]   4 base 0200000000 mask 3E00000000 write-back
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: update [mem 0x9fc00000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0x9fc00 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fd960-0x000fd96f] mapped at [ffff8800000fd960]
[    0.000000]   mpc: ef020-ef22c
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x35f1a2000, 0x35f1a2fff] PGTABLE
[    0.000000] BRK [0x35f1a3000, 0x35f1a3fff] PGTABLE
[    0.000000] BRK [0x35f1a4000, 0x35f1a4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x35fe00000-0x35fffffff]
[    0.000000]  [mem 0x35fe00000-0x35fffffff] page 2M
[    0.000000] BRK [0x35f1a5000, 0x35f1a5fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x35c000000-0x35fdfffff]
[    0.000000]  [mem 0x35c000000-0x35fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x300000000-0x35bffffff]
[    0.000000]  [mem 0x300000000-0x35bffffff] page 2M
[    0.000000] BRK [0x35f1a6000, 0x35f1a6fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x9e259fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x9e1fffff] page 2M
[    0.000000]  [mem 0x9e200000-0x9e259fff] page 4k
[    0.000000] BRK [0x35f1a7000, 0x35f1a7fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x9e321000-0x9fa31fff]
[    0.000000]  [mem 0x9e321000-0x9e3fffff] page 4k
[    0.000000]  [mem 0x9e400000-0x9f9fffff] page 2M
[    0.000000]  [mem 0x9fa00000-0x9fa31fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x9fa9a000-0x9faa8fff]
[    0.000000]  [mem 0x9fa9a000-0x9faa8fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x9fb1a000-0x9fb24fff]
[    0.000000]  [mem 0x9fb1a000-0x9fb24fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x9fb3a000-0x9fbfffff]
[    0.000000]  [mem 0x9fb3a000-0x9fbfffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x2ffffffff]
[    0.000000]  [mem 0x100000000-0x2ffffffff] page 2M
[    0.000000] RAMDISK: [mem 0x356687000-0x35dffffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F03F0 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 0x000000009FB39120 00008C (v01 INTEL  S5000PAL 00000000 INTL 01000013)
[    0.000000] ACPI: SLIC 0x000000009FB38000 000176 (v01 INTEL  S5000PAL 00000002 INTL 01000013)
[    0.000000] ACPI: FACP 0x000000009FB36000 0000F4 (v03 INTEL  S5000PAL 00000000 INTL 01000013)
[    0.000000] ACPI: DSDT 0x000000009FB2F000 005DC3 (v02 INTEL  S5000PAL 00000008 INTL 01000013)
[    0.000000] ACPI: FACS 0x000000009FAA9000 000040
[    0.000000] ACPI: APIC 0x000000009FB35000 0000C8 (v01 INTEL  S5000PAL 00000000 INTL 01000013)
[    0.000000] ACPI: SPCR 0x000000009FB2E000 000050 (v01 INTEL  S5000PAL 00000000 INTL 01000013)
[    0.000000] ACPI: HPET 0x000000009FB2D000 000038 (v01 INTEL  S5000PAL 00000001 INTL 01000013)
[    0.000000] ACPI: MCFG 0x000000009FB2C000 00003C (v01 INTEL  S5000PAL 00000001 INTL 01000013)
[    0.000000] ACPI: SSDT 0x000000009FB2B000 000A14 (v02 INTEL  EIST     00004000 INTL 20060317)
[    0.000000] ACPI: SSDT 0x000000009FB2A000 000193 (v02 INTEL  IPMI     00004000 INTL 20060317)
[    0.000000] ACPI: SSDT 0x000000009FB29000 0002D4 (v02 INTEL  CST      00004000 INTL 20060317)
[    0.000000] ACPI: HEST 0x000000009FB28000 0000A8 (v01 INTEL  S5000PAL 00000001 INTL 00000001)
[    0.000000] ACPI: BERT 0x000000009FB27000 000030 (v01 INTEL  S5000PAL 00000001 INTL 00000001)
[    0.000000] ACPI: ERST 0x000000009FB26000 000230 (v01 INTEL  S5000PAL 00000001 INTL 00000001)
[    0.000000] ACPI: EINJ 0x000000009FB25000 000130 (v01 INTEL  S5000PAL 00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000035fffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x35ffcf000-0x35fff4fff]
[    0.000000]  [ffffea0000000000-ffffea000d7fffff] PMD -> [ffff88034a600000-ffff8803565fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x35fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x9e259fff]
[    0.000000]   node   0: [mem 0x9e321000-0x9fa31fff]
[    0.000000]   node   0: [mem 0x9fa9a000-0x9faa8fff]
[    0.000000]   node   0: [mem 0x9fb1a000-0x9fb24fff]
[    0.000000]   node   0: [mem 0x9fb3a000-0x9fbfffff]
[    0.000000]   node   0: [mem 0x100000000-0x35fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x35fffffff]
[    0.000000] On node 0 totalpages: 3144168
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 10154 pages used for memmap
[    0.000000]   DMA32 zone: 649803 pages, LIFO batch:31
[    0.000000]   Normal zone: 38912 pages used for memmap
[    0.000000]   Normal zone: 2490368 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec80000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec80000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 8, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 8, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 8, APIC INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 8, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 8, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 8, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 8, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 8, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 8, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 8, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 8, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 8, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 8, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 8, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 8, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff57a000 (fec80000)
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x9e25a000-0x9e320fff]
[    0.000000] PM: Registered nosave memory: [mem 0x9fa32000-0x9fa99fff]
[    0.000000] PM: Registered nosave memory: [mem 0x9faa9000-0x9fb19fff]
[    0.000000] PM: Registered nosave memory: [mem 0x9fb25000-0x9fb39fff]
[    0.000000] PM: Registered nosave memory: [mem 0x9fc00000-0xafffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xb0000000-0xffbfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffc00000-0xffc0bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xffc0c000-0xffffffff]
[    0.000000] e820: [mem 0xb0000000-0xffbfffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 31 pages/cpu @ffff88035fc00000 s89152 r8192 d29632 u262144
[    0.000000] pcpu-alloc: s89152 r8192 d29632 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 3095017
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/client5/boot_boot-performance-1-x86_64-rhel-a4fb6646dd55a6ba18df37134e9a22088da0a0db-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/a4fb6646dd55a6ba18df37134e9a22088da0a0db/vmlinuz-3.18.0-rc2-wl-ga4fb664 kconfig=x86_64-rhel commit=a4fb6646dd55a6ba18df37134e9a22088da0a0db branch=linux-devel/devel-hourly-2014103123 root=/dev/ram0 max_uptime=3600 RESULT_ROOT=/result/client5/boot/performance-1/debian-x86_64.cgz/x86_64-rhel/a4fb6646dd55a6ba18df37134e9a22088da0a0db/0 LKP_SERVER=10.239.97.14 ip=::::client5::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 12170016K/12576672K available (8723K kernel code, 1696K rwdata, 3856K rodata, 1828K init, 1888K bss, 406656K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=8.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
[    0.000000] NR_IRQS:524544 nr_irqs:896 0
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 50331648 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2992.395 MHz processor
[    0.000015] Calibrating delay loop (skipped), value calculated using timer frequency.. lpj=2992395
[    0.001000] pid_max: default: 32768 minimum: 301
[    0.001000] ACPI: Core revision 20140926
[    0.001000] ACPI: All ACPI Tables successfully acquired
[    0.001000] Security Framework initialized
[    0.001000] SELinux:  Initializing.
[    0.001000] SELinux:  Starting in permissive mode
[    0.001000] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.001000] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.001000] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.001000] Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)
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
[    0.001000] CPU0: Thermal LVT vector (0xfa) already installed
[    0.001000] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
[    0.001000] Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32, 1GB 0
[    0.001000] Freeing SMP alternatives memory: 36K (ffffffff81fbf000 - ffffffff81fc8000)
[    0.001000] ftrace: allocating 31375 entries in 123 pages
[    0.001000] Getting VERSION: 50014
[    0.001000] Getting VERSION: 50014
[    0.001000] Getting ID: 0
[    0.001000] Getting ID: 0
[    0.001000] masked ExtINT on CPU#0
[    0.001000] ENABLING IO-APIC IRQs
[    0.001000] init IO_APIC IRQs
[    0.001000]  apic 8 pin 0 not connected
[    0.001000] IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.001000] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.001000] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.001009] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.002005] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.003004] IOAPIC[0]: Set routing entry (8-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.004004] IOAPIC[0]: Set routing entry (8-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.005004] IOAPIC[0]: Set routing entry (8-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.006004] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.007004] IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.008004] IOAPIC[0]: Set routing entry (8-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.009004] IOAPIC[0]: Set routing entry (8-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.010004] IOAPIC[0]: Set routing entry (8-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.011004] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.012005] IOAPIC[0]: Set routing entry (8-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.013004] IOAPIC[0]: Set routing entry (8-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.014003]  apic 8 pin 16 not connected
[    0.015001]  apic 8 pin 17 not connected
[    0.016001]  apic 8 pin 18 not connected
[    0.017001]  apic 8 pin 19 not connected
[    0.018001]  apic 8 pin 20 not connected
[    0.019001]  apic 8 pin 21 not connected
[    0.020001]  apic 8 pin 22 not connected
[    0.021001]  apic 8 pin 23 not connected
[    0.022001]  apic 9 pin 0 not connected
[    0.023001]  apic 9 pin 1 not connected
[    0.024001]  apic 9 pin 2 not connected
[    0.025001]  apic 9 pin 3 not connected
[    0.026001]  apic 9 pin 4 not connected
[    0.027001]  apic 9 pin 5 not connected
[    0.028001]  apic 9 pin 6 not connected
[    0.029001]  apic 9 pin 7 not connected
[    0.030001]  apic 9 pin 8 not connected
[    0.031001]  apic 9 pin 9 not connected
[    0.032001]  apic 9 pin 10 not connected
[    0.033001]  apic 9 pin 11 not connected
[    0.034001]  apic 9 pin 12 not connected
[    0.035001]  apic 9 pin 13 not connected
[    0.036001]  apic 9 pin 14 not connected
[    0.037001]  apic 9 pin 15 not connected
[    0.038001]  apic 9 pin 16 not connected
[    0.039001]  apic 9 pin 17 not connected
[    0.040001]  apic 9 pin 18 not connected
[    0.041001]  apic 9 pin 19 not connected
[    0.042001]  apic 9 pin 20 not connected
[    0.043001]  apic 9 pin 21 not connected
[    0.044001]  apic 9 pin 22 not connected
[    0.045001]  apic 9 pin 23 not connected
[    0.046133] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.057834] smpboot: CPU0: Intel(R) Xeon(R) CPU           E5450  @ 3.00GHz (fam: 06, model: 17, stepping: 06)
[    0.061001] Using local APIC timer interrupts.
[    0.061001] calibrating APIC timer ...
[    0.063000] ... lapic delta = 2078100
[    0.063000] ... PM-Timer delta = 357951
[    0.063000] ... PM-Timer result ok
[    0.063000] ..... delta 2078100
[    0.063000] ..... mult: 89253715
[    0.063000] ..... calibration result: 332496
[    0.063000] ..... CPU clock speed is 2992.0464 MHz.
[    0.063000] ..... host bus clock speed is 332.0496 MHz.
[    0.063027] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
[    0.068002] ... version:                2
[    0.069001] ... bit width:              40
[    0.070000] ... generic registers:      2
[    0.071001] ... value mask:             000000ffffffffff
[    0.072001] ... max period:             000000007fffffff
[    0.073000] ... fixed-purpose events:   3
[    0.074001] ... event mask:             0000000700000003
[    0.077428] x86: Booting SMP configuration:
[    0.078002] .... node  #0, CPUs:      #1
[    0.077304] masked ExtINT on CPU#1
[    0.077304] CPU1: Thermal LVT vector (0xfa) already installed
[    0.102243] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.103142]  #2
[    0.103015] masked ExtINT on CPU#2
[    0.103015] CPU2: Thermal LVT vector (0xfa) already installed
[    0.185139]  #3
[    0.185010] masked ExtINT on CPU#3
[    0.185010] CPU3: Thermal LVT vector (0xfa) already installed
[    0.208145]  #4
[    0.208011] masked ExtINT on CPU#4
[    0.208011] CPU4: Thermal LVT vector (0xfa) already installed
[    0.231045]  #5
[    0.230037] masked ExtINT on CPU#5
[    0.230037] CPU5: Thermal LVT vector (0xfa) already installed
[    0.254165]  #6
[    0.254012] masked ExtINT on CPU#6
[    0.254012] CPU6: Thermal LVT vector (0xfa) already installed
[    0.277136]  #7
[    0.277012] masked ExtINT on CPU#7
[    0.277012] CPU7: Thermal LVT vector (0xfa) already installed
[    0.299012] x86: Booted up 1 node, 8 CPUs
[    0.300003] smpboot: Total of 8 processors activated (47879.39 BogoMIPS)
[    0.302402] devtmpfs: initialized
[    0.307391] evm: security.selinux
[    0.308001] evm: security.ima
[    0.309001] evm: security.capability
[    0.310127] PM: Registering ACPI NVS region [mem 0x9e25a000-0x9e320fff] (815104 bytes)
[    0.311017] PM: Registering ACPI NVS region [mem 0x9faa9000-0x9fb19fff] (462848 bytes)
[    0.314395] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.315179] NET: Registered protocol family 16
[    0.319007] cpuidle: using governor menu
[    0.320139] ACPI: bus type PCI registered
[    0.321002] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.322077] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xa0000000-0xafffffff] (base 0xa0000000)
[    0.323003] PCI: MMCONFIG at [mem 0xa0000000-0xafffffff] reserved in E820
[    0.324475] PCI: Using configuration type 1 for base access
[    0.330125] ACPI: Added _OSI(Module Device)
[    0.331003] ACPI: Added _OSI(Processor Device)
[    0.332001] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.333001] ACPI: Added _OSI(Processor Aggregator Device)
[    0.334608] IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:255)
[    0.338234] ACPI Error: Field [CPB3] at 96 exceeds Buffer [NULL] size 64 (bits) (20140926/dsopcode-236)
[    0.341002] ACPI Error: Method parse/execution failed [\_SB_._OSC] (Node ffff88034a060de8), AE_AML_BUFFER_LIMIT (20140926/psparse-536)
[    0.347160] ACPI: Interpreter enabled
[    0.348008] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140926/hwxface-580)
[    0.351002] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20140926/hwxface-580)
[    0.354008] ACPI: (supports S0 S1 S4 S5)
[    0.355001] ACPI: Using IOAPIC for interrupt routing
[    0.356047] HEST: Table parsing has been initialized.
[    0.357003] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.362887] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.363006] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.364004] acpi PNP0A08:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.367770] PCI host bridge to bus 0000:00
[    0.368003] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.369002] pci_bus 0000:00: root bus resource [io  0x0000-0x0ca1]
[    0.370002] pci_bus 0000:00: root bus resource [io  0x0ca4-0x0cf7]
[    0.371002] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.372001] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.373002] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000fffff]
[    0.374002] pci_bus 0000:00: root bus resource [mem 0xb0000000-0xfdffffff]
[    0.375001] pci_bus 0000:00: root bus resource [mem 0xfe700000-0xfe7003ff]
[    0.376011] pci 0000:00:00.0: [8086:25d8] type 00 class 0x060000
[    0.377050] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.378081] pci 0000:00:02.0: [8086:25f7] type 01 class 0x060400
[    0.380008] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.381089] pci 0000:00:03.0: [8086:25e3] type 01 class 0x060400
[    0.382039] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.383066] pci 0000:00:04.0: [8086:25f8] type 01 class 0x060400
[    0.384039] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.385036] pci 0000:00:04.0: System wakeup disabled by ACPI
[    0.386040] pci 0000:00:05.0: [8086:25e5] type 01 class 0x060400
[    0.387038] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.388031] pci 0000:00:05.0: System wakeup disabled by ACPI
[    0.389040] pci 0000:00:06.0: [8086:25f9] type 01 class 0x060400
[    0.390039] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.391031] pci 0000:00:06.0: System wakeup disabled by ACPI
[    0.392042] pci 0000:00:07.0: [8086:25e7] type 01 class 0x060400
[    0.393038] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.394041] pci 0000:00:07.0: System wakeup disabled by ACPI
[    0.395041] pci 0000:00:08.0: [8086:1a38] type 00 class 0x088000
[    0.396009] pci 0000:00:08.0: reg 0x10: [mem 0xfe700000-0xfe7003ff 64bit]
[    0.397035] pci 0000:00:08.0: PME# supported from D0 D3hot D3cold
[    0.398068] pci 0000:00:10.0: [8086:25f0] type 00 class 0x060000
[    0.399076] pci 0000:00:10.1: [8086:25f0] type 00 class 0x060000
[    0.401137] pci 0000:00:10.2: [8086:25f0] type 00 class 0x060000
[    0.402091] pci 0000:00:11.0: [8086:25f1] type 00 class 0x060000
[    0.403071] pci 0000:00:13.0: [8086:25f3] type 00 class 0x060000
[    0.404073] pci 0000:00:15.0: [8086:25f5] type 00 class 0x060000
[    0.405069] pci 0000:00:16.0: [8086:25f6] type 00 class 0x060000
[    0.406077] pci 0000:00:1d.0: [8086:2688] type 00 class 0x0c0300
[    0.407035] pci 0000:00:1d.0: reg 0x20: [io  0x30a0-0x30bf]
[    0.409008] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.410041] pci 0000:00:1d.1: [8086:2689] type 00 class 0x0c0300
[    0.411035] pci 0000:00:1d.1: reg 0x20: [io  0x3080-0x309f]
[    0.412060] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    0.413039] pci 0000:00:1d.2: [8086:268a] type 00 class 0x0c0300
[    0.414035] pci 0000:00:1d.2: reg 0x20: [io  0x3060-0x307f]
[    0.415067] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    0.416040] pci 0000:00:1d.3: [8086:268b] type 00 class 0x0c0300
[    0.417035] pci 0000:00:1d.3: reg 0x20: [io  0x3040-0x305f]
[    0.418059] pci 0000:00:1d.3: System wakeup disabled by ACPI
[    0.419051] pci 0000:00:1d.7: [8086:268c] type 00 class 0x0c0320
[    0.420017] pci 0000:00:1d.7: reg 0x10: [mem 0xb8b00400-0xb8b007ff]
[    0.421075] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.422034] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    0.423041] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.424102] pci 0000:00:1f.0: [8086:2670] type 00 class 0x060100
[    0.426028] pci 0000:00:1f.0: System wakeup disabled by ACPI
[    0.427039] pci 0000:00:1f.1: [8086:269e] type 00 class 0x01018a
[    0.428011] pci 0000:00:1f.1: reg 0x10: [io  0x30e8-0x30ef]
[    0.429008] pci 0000:00:1f.1: reg 0x14: [io  0x30fc-0x30ff]
[    0.430008] pci 0000:00:1f.1: reg 0x18: [io  0x30e0-0x30e7]
[    0.431008] pci 0000:00:1f.1: reg 0x1c: [io  0x30f8-0x30fb]
[    0.432008] pci 0000:00:1f.1: reg 0x20: [io  0x30c0-0x30cf]
[    0.433017] pci 0000:00:1f.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.434001] pci 0000:00:1f.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.435001] pci 0000:00:1f.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.436001] pci 0000:00:1f.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.437066] pci 0000:00:1f.2: [8086:2681] type 00 class 0x010601
[    0.438014] pci 0000:00:1f.2: reg 0x10: [io  0x30d8-0x30df]
[    0.439007] pci 0000:00:1f.2: reg 0x14: [io  0x30f4-0x30f7]
[    0.440007] pci 0000:00:1f.2: reg 0x18: [io  0x30d0-0x30d7]
[    0.441007] pci 0000:00:1f.2: reg 0x1c: [io  0x30f0-0x30f3]
[    0.442007] pci 0000:00:1f.2: reg 0x20: [io  0x3020-0x303f]
[    0.443007] pci 0000:00:1f.2: reg 0x24: [mem 0xb8b00000-0xb8b003ff]
[    0.444032] pci 0000:00:1f.2: PME# supported from D3hot
[    0.445082] pci 0000:00:1f.3: [8086:269b] type 00 class 0x0c0500
[    0.446046] pci 0000:00:1f.3: reg 0x20: [io  0x3000-0x301f]
[    0.447403] pci 0000:01:00.0: [8086:3500] type 01 class 0x060400
[    0.449781] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.451459] pci 0000:01:00.3: [8086:350c] type 01 class 0x060400
[    0.454367] pci 0000:01:00.3: PME# supported from D0 D3hot D3cold
[    0.455287] pci 0000:01:00.3: System wakeup disabled by ACPI
[    0.456127] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.458048] pci 0000:00:02.0: PCI bridge to [bus 01-06]
[    0.459003] pci 0000:00:02.0:   bridge window [io  0x2000-0x2fff]
[    0.460003] pci 0000:00:02.0:   bridge window [mem 0xb8000000-0xb89fffff]
[    0.461003] pci 0000:00:02.0:   bridge window [mem 0xb8c00000-0xb8dfffff 64bit pref]
[    0.463505] pci 0000:02:00.0: [8086:3510] type 01 class 0x060400
[    0.466459] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.467287] pci 0000:02:00.0: System wakeup disabled by ACPI
[    0.468035] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.470184] pci 0000:02:01.0: [8086:3514] type 01 class 0x060400
[    0.473178] pci 0000:02:01.0: PME# supported from D0 D3hot D3cold
[    0.474287] pci 0000:02:01.0: System wakeup disabled by ACPI
[    0.475064] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.476187] pci 0000:02:02.0: [8086:3518] type 01 class 0x060400
[    0.479826] pci 0000:02:02.0: PME# supported from D0 D3hot D3cold
[    0.480288] pci 0000:02:02.0: System wakeup disabled by ACPI
[    0.481034] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.482645] pci 0000:01:00.0: PCI bridge to [bus 02-05]
[    0.483003] pci 0000:01:00.0:   bridge window [io  0x2000-0x2fff]
[    0.484003] pci 0000:01:00.0:   bridge window [mem 0xb8000000-0xb88fffff]
[    0.485049] pci 0000:01:00.0:   bridge window [mem 0xb8c00000-0xb8dfffff 64bit pref]
[    0.487275] pci 0000:02:00.0: PCI bridge to [bus 03]
[    0.488141] pci 0000:02:00.0:   bridge window [mem 0xb8c00000-0xb8dfffff 64bit pref]
[    0.490275] pci 0000:02:01.0: PCI bridge to [bus 04]
[    0.492964] pci 0000:05:00.0: [8086:1096] type 00 class 0x020000
[    0.493508] pci 0000:05:00.0: reg 0x10: [mem 0xb8820000-0xb883ffff]
[    0.495230] pci 0000:05:00.0: reg 0x14: [mem 0xb8400000-0xb87fffff]
[    0.496278] pci 0000:05:00.0: reg 0x18: [io  0x2020-0x203f]
[    0.500688] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    0.502963] pci 0000:05:00.1: [8086:1096] type 00 class 0x020000
[    0.503508] pci 0000:05:00.1: reg 0x10: [mem 0xb8800000-0xb881ffff]
[    0.505278] pci 0000:05:00.1: reg 0x14: [mem 0xb8000000-0xb83fffff]
[    0.506278] pci 0000:05:00.1: reg 0x18: [io  0x2000-0x201f]
[    0.510688] pci 0000:05:00.1: PME# supported from D0 D3hot D3cold
[    0.512642] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.514046] pci 0000:02:02.0: PCI bridge to [bus 05]
[    0.515003] pci 0000:02:02.0:   bridge window [io  0x2000-0x2fff]
[    0.516003] pci 0000:02:02.0:   bridge window [mem 0xb8000000-0xb88fffff]
[    0.519917] pci 0000:01:00.3: PCI bridge to [bus 06]
[    0.520401] pci 0000:00:03.0: PCI bridge to [bus 07]
[    0.521040] pci 0000:00:04.0: PCI bridge to [bus 08]
[    0.522037] pci 0000:00:05.0: PCI bridge to [bus 09]
[    0.523198] pci 0000:00:06.0: PCI bridge to [bus 0a]
[    0.525184] pci 0000:00:07.0: PCI bridge to [bus 0b]
[    0.526059] pci 0000:0c:0c.0: [1002:515e] type 00 class 0x030000
[    0.527017] pci 0000:0c:0c.0: reg 0x10: [mem 0xb0000000-0xb7ffffff pref]
[    0.528009] pci 0000:0c:0c.0: reg 0x14: [io  0x1000-0x10ff]
[    0.529010] pci 0000:0c:0c.0: reg 0x18: [mem 0xb8a00000-0xb8a0ffff]
[    0.530031] pci 0000:0c:0c.0: reg 0x30: [mem 0xfffe0000-0xffffffff pref]
[    0.531031] pci 0000:0c:0c.0: supports D1 D2
[    0.532054] pci 0000:00:1e.0: PCI bridge to [bus 0c] (subtractive decode)
[    0.533007] pci 0000:00:1e.0:   bridge window [io  0x1000-0x1fff]
[    0.534003] pci 0000:00:1e.0:   bridge window [mem 0xb8a00000-0xb8afffff]
[    0.535005] pci 0000:00:1e.0:   bridge window [mem 0xb0000000-0xb7ffffff 64bit pref]
[    0.536007] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0ca1] (subtractive decode)
[    0.537001] pci 0000:00:1e.0:   bridge window [io  0x0ca4-0x0cf7] (subtractive decode)
[    0.538001] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.539002] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.540001] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000fffff] (subtractive decode)
[    0.541002] pci 0000:00:1e.0:   bridge window [mem 0xb0000000-0xfdffffff] (subtractive decode)
[    0.542001] pci 0000:00:1e.0:   bridge window [mem 0xfe700000-0xfe7003ff] (subtractive decode)
[    0.543361] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 7 10 11) *0, disabled.
[    0.547360] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7 10 11) *0, disabled.
[    0.551347] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 7 10 11) *0, disabled.
[    0.554348] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 10 11) *0, disabled.
[    0.558349] ACPI: PCI Interrupt Link [LNKE] (IRQs 5 7 10 11) *0, disabled.
[    0.562045] ACPI: PCI Interrupt Link [LNKF] (IRQs 5 7 10 11) *0, disabled.
[    0.566348] ACPI: PCI Interrupt Link [LNKG] (IRQs 5 7 10 11) *0, disabled.
[    0.570048] ACPI: PCI Interrupt Link [LNKH] (IRQs 5 7 10 11) *0, disabled.
[    0.574350] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:255)
[    0.575318] ACPI: Enabled 1 GPEs in block 00 to 1F
[    0.576072] vgaarb: setting as boot device: PCI:0000:0c:0c.0
[    0.577000] vgaarb: device added: PCI:0000:0c:0c.0,decodes=io+mem,owns=io+mem,locks=none
[    0.577001] vgaarb: loaded
[    0.578001] vgaarb: bridge control possible 0000:0c:0c.0
[    0.579091] SCSI subsystem initialized
[    0.580034] ACPI: bus type USB registered
[    0.581022] usbcore: registered new interface driver usbfs
[    0.582010] usbcore: registered new interface driver hub
[    0.583053] usbcore: registered new device driver usb
[    0.584026] pps_core: LinuxPPS API ver. 1 registered
[    0.585001] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.586010] PTP clock support registered
[    0.587084] PCI: Using ACPI for IRQ routing
[    0.593520] PCI: pci_cache_line_size set to 64 bytes
[    0.595063] e820: reserve RAM buffer [mem 0x0009ec00-0x0009ffff]
[    0.596001] e820: reserve RAM buffer [mem 0x9e25a000-0x9fffffff]
[    0.597001] e820: reserve RAM buffer [mem 0x9fa32000-0x9fffffff]
[    0.598001] e820: reserve RAM buffer [mem 0x9faa9000-0x9fffffff]
[    0.599001] e820: reserve RAM buffer [mem 0x9fb25000-0x9fffffff]
[    0.600001] e820: reserve RAM buffer [mem 0x9fc00000-0x9fffffff]
[    0.601120] NetLabel: Initializing
[    0.602001] NetLabel:  domain hash size = 128
[    0.603001] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.604018] NetLabel:  unlabeled traffic allowed by default
[    0.605118] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.606003] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.608001] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.612034] Switched to clocksource hpet
[    0.630789] pnp: PnP ACPI init
[    0.634180] system 00:00: [mem 0xa0000000-0xafffffff] has been reserved
[    0.640910] system 00:00: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.647648] system 00:00: [mem 0xffc00000-0xffffffff] could not be reserved
[    0.654727] system 00:00: [mem 0xfec00000-0xfecfffff] could not be reserved
[    0.661802] system 00:00: [mem 0xfee00000-0xfeefffff] has been reserved
[    0.668532] system 00:00: [mem 0xfe600000-0xfe6fffff] has been reserved
[    0.675262] system 00:00: [mem 0xfe000000-0xfe01ffff] has been reserved
[    0.681994] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.688997] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:255)
[    0.697281] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.703976] system 00:02: [io  0x0500-0x053f] has been reserved
[    0.710012] system 00:02: [io  0x0400-0x047f] could not be reserved
[    0.716387] system 00:02: [io  0x0800-0x087f] has been reserved
[    0.722417] system 00:02: [io  0x0ca2-0x0ca7] could not be reserved
[    0.728791] system 00:02: [io  0x0ca8-0x0caf] has been reserved
[    0.734818] system 00:02: [io  0x0161] has been reserved
[    0.740242] system 00:02: [io  0x0162] has been reserved
[    0.745664] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.752682] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:255)
[    0.760997] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.767756] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:255)
[    0.776067] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.782717] IOAPIC[0]: Set routing entry (8-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:255)
[    0.791174] pnp 00:05: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
[    0.798601] IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:255)
[    0.806887] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.814372] pnp 00:07: Plug and Play ACPI device, IDs IPI0001 (active)
[    0.821022] pnp: PnP ACPI: found 8 devices
[    0.831993] pci 0000:0c:0c.0: can't claim BAR 6 [mem 0xfffe0000-0xffffffff pref]: no compatible bridge window
[    0.842232] pci 0000:02:00.0: bridge window [io  0x1000-0x0fff] to [bus 03] add_size 1000
[    0.850585] pci 0000:02:00.0: bridge window [mem 0x00100000-0x000fffff] to [bus 03] add_size 400000
[    0.860399] pci 0000:02:00.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 400000
[    0.869536] pci 0000:02:00.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.877803] pci 0000:02:00.0: BAR 14: no space for [mem size 0x00400000]
[    0.884618] pci 0000:02:00.0: BAR 14: failed to assign [mem size 0x00400000]
[    0.891780] pci 0000:02:00.0: BAR 13: no space for [io  size 0x1000]
[    0.898243] pci 0000:02:00.0: BAR 13: failed to assign [io  size 0x1000]
[    0.905057] pci 0000:02:00.0: BAR 14: no space for [mem size 0x00400000]
[    0.911864] pci 0000:02:00.0: BAR 14: failed to assign [mem size 0x00400000]
[    0.919019] pci 0000:02:00.0: BAR 13: no space for [io  size 0x1000]
[    0.925489] pci 0000:02:00.0: BAR 13: failed to assign [io  size 0x1000]
[    0.932305] pci 0000:02:00.0: PCI bridge to [bus 03]
[    0.937474] pci 0000:02:00.0:   bridge window [mem 0xb8c00000-0xb8dfffff 64bit pref]
[    0.945439] pci 0000:02:01.0: PCI bridge to [bus 04]
[    0.950705] pci 0000:02:02.0: PCI bridge to [bus 05]
[    0.955780] pci 0000:02:02.0:   bridge window [io  0x2000-0x2fff]
[    0.962038] pci 0000:02:02.0:   bridge window [mem 0xb8000000-0xb88fffff]
[    0.969072] pci 0000:01:00.0: PCI bridge to [bus 02-05]
[    0.974409] pci 0000:01:00.0:   bridge window [io  0x2000-0x2fff]
[    0.980658] pci 0000:01:00.0:   bridge window [mem 0xb8000000-0xb88fffff]
[    0.987559] pci 0000:01:00.0:   bridge window [mem 0xb8c00000-0xb8dfffff 64bit pref]
[    0.995523] pci 0000:01:00.3: PCI bridge to [bus 06]
[    1.000787] pci 0000:00:02.0: PCI bridge to [bus 01-06]
[    1.006130] pci 0000:00:02.0:   bridge window [io  0x2000-0x2fff]
[    1.012333] pci 0000:00:02.0:   bridge window [mem 0xb8000000-0xb89fffff]
[    1.019236] pci 0000:00:02.0:   bridge window [mem 0xb8c00000-0xb8dfffff 64bit pref]
[    1.027154] pci 0000:00:03.0: PCI bridge to [bus 07]
[    1.032233] pci 0000:00:04.0: PCI bridge to [bus 08]
[    1.037317] pci 0000:00:05.0: PCI bridge to [bus 09]
[    1.042403] pci 0000:00:06.0: PCI bridge to [bus 0a]
[    1.047486] pci 0000:00:07.0: PCI bridge to [bus 0b]
[    1.052573] pci 0000:0c:0c.0: BAR 6: assigned [mem 0xb8a20000-0xb8a3ffff pref]
[    1.059974] pci 0000:00:1e.0: PCI bridge to [bus 0c]
[    1.065049] pci 0000:00:1e.0:   bridge window [io  0x1000-0x1fff]
[    1.071253] pci 0000:00:1e.0:   bridge window [mem 0xb8a00000-0xb8afffff]
[    1.078155] pci 0000:00:1e.0:   bridge window [mem 0xb0000000-0xb7ffffff 64bit pref]
[    1.086076] pci_bus 0000:00: resource 4 [io  0x0000-0x0ca1]
[    1.091763] pci_bus 0000:00: resource 5 [io  0x0ca4-0x0cf7]
[    1.097446] pci_bus 0000:00: resource 6 [io  0x0d00-0xffff]
[    1.103127] pci_bus 0000:00: resource 7 [mem 0x000a0000-0x000bffff]
[    1.109502] pci_bus 0000:00: resource 8 [mem 0x000c0000-0x000fffff]
[    1.115885] pci_bus 0000:00: resource 9 [mem 0xb0000000-0xfdffffff]
[    1.122259] pci_bus 0000:00: resource 10 [mem 0xfe700000-0xfe7003ff]
[    1.128722] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    1.134406] pci_bus 0000:01: resource 1 [mem 0xb8000000-0xb89fffff]
[    1.140780] pci_bus 0000:01: resource 2 [mem 0xb8c00000-0xb8dfffff 64bit pref]
[    1.148180] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    1.153861] pci_bus 0000:02: resource 1 [mem 0xb8000000-0xb88fffff]
[    1.160237] pci_bus 0000:02: resource 2 [mem 0xb8c00000-0xb8dfffff 64bit pref]
[    1.167634] pci_bus 0000:03: resource 2 [mem 0xb8c00000-0xb8dfffff 64bit pref]
[    1.175032] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    1.180714] pci_bus 0000:05: resource 1 [mem 0xb8000000-0xb88fffff]
[    1.187091] pci_bus 0000:0c: resource 0 [io  0x1000-0x1fff]
[    1.192772] pci_bus 0000:0c: resource 1 [mem 0xb8a00000-0xb8afffff]
[    1.199146] pci_bus 0000:0c: resource 2 [mem 0xb0000000-0xb7ffffff 64bit pref]
[    1.206544] pci_bus 0000:0c: resource 4 [io  0x0000-0x0ca1]
[    1.212226] pci_bus 0000:0c: resource 5 [io  0x0ca4-0x0cf7]
[    1.217907] pci_bus 0000:0c: resource 6 [io  0x0d00-0xffff]
[    1.223591] pci_bus 0000:0c: resource 7 [mem 0x000a0000-0x000bffff]
[    1.229967] pci_bus 0000:0c: resource 8 [mem 0x000c0000-0x000fffff]
[    1.236341] pci_bus 0000:0c: resource 9 [mem 0xb0000000-0xfdffffff]
[    1.242717] pci_bus 0000:0c: resource 10 [mem 0xfe700000-0xfe7003ff]
[    1.249219] NET: Registered protocol family 2
[    1.253974] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.261977] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.269140] TCP: Hash tables configured (established 131072 bind 65536)
[    1.275910] TCP: reno registered
[    1.279277] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    1.285596] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    1.292391] NET: Registered protocol family 1
[    1.297046] RPC: Registered named UNIX socket transport module.
[    1.303082] RPC: Registered udp transport module.
[    1.307902] RPC: Registered tcp transport module.
[    1.312729] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.319553] IOAPIC[0]: Set routing entry (8-23 -> 0x41 -> IRQ 23 Mode:1 Active:1 Dest:255)
[    1.328297] IOAPIC[0]: Set routing entry (8-22 -> 0x51 -> IRQ 22 Mode:1 Active:1 Dest:255)
[    1.337032] IOAPIC[0]: Set routing entry (8-23 -> 0x61 -> IRQ 23 Mode:1 Active:1 Dest:255)
[    1.345757] IOAPIC[0]: Set routing entry (8-22 -> 0x71 -> IRQ 22 Mode:1 Active:1 Dest:255)
[    1.354479] IOAPIC[0]: Set routing entry (8-23 -> 0x81 -> IRQ 23 Mode:1 Active:1 Dest:255)
[    1.363083] pci 0000:00:1f.0: rerouting interrupts for [8086:2670]
[    1.369669] pci 0000:0c:0c.0: Video device with shadowed ROM
[    1.375444] PCI: CLS 64 bytes, default 64
[    1.379644] Unpacking initramfs...
[    3.645737] Freeing initrd memory: 124388K (ffff880356687000 - ffff88035e000000)
[    3.653337] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    3.659896] software IO TLB [mem 0x9a25a000-0x9e25a000] (64MB) mapped at [ffff88009a25a000-ffff88009e259fff]
[    3.671544] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    3.677996] Initialise system trusted keyring
[    3.682488] audit: initializing netlink subsys (disabled)
[    3.688036] audit: type=2000 audit(3156566885.687:1): initialized
[    3.694620] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.702926] zpool: loaded
[    3.705661] zbud: loaded
[    3.708556] VFS: Disk quotas dquot_6.5.2
[    3.712635] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.719847] SGI XFS with ACLs, security attributes, no debug enabled
[    3.727020] 9p: Installing v9fs 9p2000 file system support
[    3.732653] msgmni has been set to 24012
[    3.736770] Key type big_key registered
[    3.740720] SELinux:  Registering netfilter hooks
[    3.746991] NET: Registered protocol family 38
[    3.751559] Key type asymmetric registered
[    3.755772] Asymmetric key parser 'x509' registered
[    3.760801] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    3.768462] io scheduler noop registered
[    3.772503] io scheduler deadline registered (default)
[    3.777766] io scheduler cfq registered
[    3.782044] IOAPIC[0]: Set routing entry (8-16 -> 0x91 -> IRQ 16 Mode:1 Active:1 Dest:255)
[    3.795151] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.800848] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    3.807621] intel_idle: does not run on family 6 model 23
[    3.813225] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    3.821756] ACPI: Power Button [PWRB]
[    3.825583] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    3.833158] ACPI: Power Button [PWRF]
[    3.837037] tsc: Marking TSC unstable due to TSC halts in idle
[    3.844580] ACPI: acpi_idle registered with cpuidle
[    3.850872] ERST: Error Record Serialization Table (ERST) support is initialized.
[    3.858575] pstore: Registered erst as persistent store backend
[    3.868255] GHES: APEI firmware first mode is enabled by WHEA _OSC.
[    3.874782] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.901680] serial 00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    3.930318] serial 00:04: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    3.938957] Non-volatile memory driver v1.3
[    3.943270] Linux agpgart interface v0.103
[    3.947748] ACPI Warning: SystemIO range 0x0000000000000428-0x000000000000042f conflicts with OpRegion 0x0000000000000400-0x000000000000045f (\PMS0) (20140926/utaddress-258)
[    3.963593] ACPI Warning: SystemIO range 0x0000000000000428-0x000000000000042f conflicts with OpRegion 0x0000000000000428-0x000000000000042f (\_SB_.PCI0.LPC_.ICH1) (20140926/utaddress-258)
[    3.980738] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.991090] ACPI Warning: SystemIO range 0x0000000000000530-0x000000000000053f conflicts with OpRegion 0x0000000000000500-0x000000000000053b (\_SI_.GPUS) (20140926/utaddress-258)
[    4.007355] ACPI Warning: SystemIO range 0x0000000000000530-0x000000000000053f conflicts with OpRegion 0x0000000000000500-0x000000000000053b (\_SB_.GPUS) (20140926/utaddress-258)
[    4.023624] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    4.033975] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x0000000000000500-0x000000000000053b (\_SI_.GPUS) (20140926/utaddress-258)
[    4.050241] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x000000000000052c-0x000000000000052f (\_SB_.PCI0.LPC_.GPIV) (20140926/utaddress-258)
[    4.067374] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x0000000000000500-0x000000000000053b (\_SB_.GPUS) (20140926/utaddress-258)
[    4.083642] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    4.093996] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    4.100303] rdac: device handler registered
[    4.104681] hp_sw: device handler registered
[    4.109071] emc: device handler registered
[    4.113277] alua: device handler registered
[    4.117612] libphy: Fixed MDIO Bus: probed
[    4.121864] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    4.129027] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    4.134896] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    4.140839] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    4.147058] IOAPIC[0]: Set routing entry (8-18 -> 0xa1 -> IRQ 18 Mode:1 Active:1 Dest:255)
[    4.157258] e1000e 0000:05:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    4.167106] e1000e 0000:05:00.0: irq 24 for MSI/MSI-X
[    4.225670] e1000e 0000:05:00.0 eth0: (PCI Express:2.5GT/s:Width x4) 00:15:17:8c:73:3c
[    4.233774] e1000e 0000:05:00.0 eth0: Intel(R) PRO/1000 Network Connection
[    4.240842] e1000e 0000:05:00.0 eth0: MAC: 5, PHY: 5, PBA No: 400000-000
[    4.247753] IOAPIC[0]: Set routing entry (8-19 -> 0xc1 -> IRQ 19 Mode:1 Active:1 Dest:255)
[    4.257955] e1000e 0000:05:00.1: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    4.267809] e1000e 0000:05:00.1: irq 25 for MSI/MSI-X
[    4.327631] e1000e 0000:05:00.1 eth1: (PCI Express:2.5GT/s:Width x4) 00:15:17:8c:73:3d
[    4.335724] e1000e 0000:05:00.1 eth1: Intel(R) PRO/1000 Network Connection
[    4.342787] e1000e 0000:05:00.1 eth1: MAC: 5, PHY: 5, PBA No: 400000-000
[    4.349612] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.2.15-k
[    4.356768] igb: Copyright (c) 2007-2014 Intel Corporation.
[    4.362466] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
[    4.370385] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
[    4.376329] usbcore: registered new interface driver catc
[    4.381848] usbcore: registered new interface driver kaweth
[    4.387532] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[    4.395108] usbcore: registered new interface driver pegasus
[    4.400886] usbcore: registered new interface driver rtl8150
[    4.406666] usbcore: registered new interface driver asix
[    4.412188] usbcore: registered new interface driver cdc_ether
[    4.418137] usbcore: registered new interface driver cdc_eem
[    4.423920] usbcore: registered new interface driver dm9601
[    4.429619] usbcore: registered new interface driver smsc75xx
[    4.435490] usbcore: registered new interface driver smsc95xx
[    4.441351] usbcore: registered new interface driver gl620a
[    4.447040] usbcore: registered new interface driver net1080
[    4.452823] usbcore: registered new interface driver plusb
[    4.458426] usbcore: registered new interface driver rndis_host
[    4.464465] usbcore: registered new interface driver cdc_subset
[    4.470498] usbcore: registered new interface driver zaurus
[    4.476191] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    4.483774] usbcore: registered new interface driver int51x1
[    4.489559] usbcore: registered new interface driver ipheth
[    4.495250] usbcore: registered new interface driver sierra_net
[    4.501347] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.507989] ehci-pci: EHCI PCI platform driver
[    4.512711] IOAPIC[0]: Set routing entry (8-23 -> 0xe1 -> IRQ 23 Mode:1 Active:1 Dest:255)
[    4.521175] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    4.526564] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    4.534149] ehci-pci 0000:00:1d.7: debug port 1
[    4.542682] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
[    4.549598] ehci-pci 0000:00:1d.7: irq 23, io mem 0xb8b00400
[    4.561033] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.566956] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.573854] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.581252] usb usb1: Product: EHCI Host Controller
[    4.586240] usb usb1: Manufacturer: Linux 3.18.0-rc2-wl-ga4fb664 ehci_hcd
[    4.593144] usb usb1: SerialNumber: 0000:00:1d.7
[    4.597992] hub 1-0:1.0: USB hub found
[    4.601866] hub 1-0:1.0: 8 ports detected
[    4.606172] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.612465] ohci-pci: OHCI PCI platform driver
[    4.617041] uhci_hcd: USB Universal Host Controller Interface driver
[    4.623670] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.629056] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    4.636635] uhci_hcd 0000:00:1d.0: detected 2 ports
[    4.641645] uhci_hcd 0000:00:1d.0: irq 23, io base 0x000030a0
[    4.647545] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    4.654442] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.661839] usb usb2: Product: UHCI Host Controller
[    4.666830] usb usb2: Manufacturer: Linux 3.18.0-rc2-wl-ga4fb664 uhci_hcd
[    4.673734] usb usb2: SerialNumber: 0000:00:1d.0
[    4.678566] hub 2-0:1.0: USB hub found
[    4.682441] hub 2-0:1.0: 2 ports detected
[    4.686797] IOAPIC[0]: Set routing entry (8-22 -> 0x22 -> IRQ 22 Mode:1 Active:1 Dest:255)
[    4.695244] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.700632] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    4.708235] uhci_hcd 0000:00:1d.1: detected 2 ports
[    4.713272] uhci_hcd 0000:00:1d.1: irq 22, io base 0x00003080
[    4.719173] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    4.726074] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.733471] usb usb3: Product: UHCI Host Controller
[    4.738462] usb usb3: Manufacturer: Linux 3.18.0-rc2-wl-ga4fb664 uhci_hcd
[    4.745364] usb usb3: SerialNumber: 0000:00:1d.1
[    4.750191] hub 3-0:1.0: USB hub found
[    4.754058] hub 3-0:1.0: 2 ports detected
[    4.758413] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.763805] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    4.771386] uhci_hcd 0000:00:1d.2: detected 2 ports
[    4.776393] uhci_hcd 0000:00:1d.2: irq 23, io base 0x00003060
[    4.782291] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    4.789192] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.796587] usb usb4: Product: UHCI Host Controller
[    4.801578] usb usb4: Manufacturer: Linux 3.18.0-rc2-wl-ga4fb664 uhci_hcd
[    4.808475] usb usb4: SerialNumber: 0000:00:1d.2
[    4.813304] hub 4-0:1.0: USB hub found
[    4.817181] hub 4-0:1.0: 2 ports detected
[    4.821530] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    4.826917] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    4.834492] uhci_hcd 0000:00:1d.3: detected 2 ports
[    4.839498] uhci_hcd 0000:00:1d.3: irq 22, io base 0x00003040
[    4.845395] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    4.852296] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.859690] usb usb5: Product: UHCI Host Controller
[    4.864679] usb usb5: Manufacturer: Linux 3.18.0-rc2-wl-ga4fb664 uhci_hcd
[    4.871573] usb usb5: SerialNumber: 0000:00:1d.3
[    4.876399] hub 5-0:1.0: USB hub found
[    4.880267] hub 5-0:1.0: 2 ports detected
[    4.884524] usbcore: registered new interface driver usbserial
[    4.890482] usbcore: registered new interface driver usbserial_generic
[    4.897128] usbserial: USB Serial support registered for generic
[    4.903283] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    4.914241] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.919341] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.924655] mousedev: PS/2 mouse device common for all mice
[    4.930588] rtc_cmos 00:01: RTC can wake from S4
[    4.937077] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    4.943312] rtc_cmos 00:01: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    4.951172] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    4.956891] iTCO_wdt: Found a 631xESB/632xESB TCO device (Version=2, TCOBASE=0x0460)
[    4.964907] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    4.971038] iTCO_vendor_support: vendor-support=0
[    4.976521] hidraw: raw HID events driver (C) Jiri Kosina
[    4.982146] usbcore: registered new interface driver usbhid
[    4.987838] usbhid: USB HID core driver
[    4.991845] drop_monitor: Initializing network drop monitor service
[    4.998297] TCP: cubic registered
[    5.001740] Initializing XFRM netlink socket
[    5.006269] NET: Registered protocol family 10
[    5.011197] NET: Registered protocol family 17
[    5.015774] 9pnet: Installing 9P2000 support
[    5.020507] 
[    5.020507] printing PIC contents
[    5.025480] ... PIC  IMR: ffff
[    5.026475] ... PIC  IRR: 0c21
[    5.031812] ... PIC  ISR: 0000
[    5.034978] ... PIC ELCR: 0c20
[    5.038163] printing local APIC contents on CPU#0/0:
[    5.039161] ... APIC ID:      00000000 (0)
[    5.039161] ... APIC VERSION: 00050014
[    5.039161] ... APIC TASKPRI: 00000000 (00)
[    5.039161] ... APIC PROCPRI: 00000000
[    5.039161] ... APIC LDR: 01000000
[    5.039161] ... APIC DFR: ffffffff
[    5.039161] ... APIC SPIV: 000001ff
[    5.039161] ... APIC ISR field:
[    5.039161] 0000000000000000000000000000000000000000000000000000000000000000
[    5.039161] ... APIC TMR field:
[    5.039161] 0000000000000000000000000000000200020002000000020002000000000000
[    5.039161] ... APIC IRR field:
[    5.039161] 0000000000000000000000000000000000000000000000000000000020000000
[    5.039161] ... APIC ESR: 00000000
[    5.039161] ... APIC ICR: 000008fd
[    5.039161] ... APIC ICR2: 02000000
[    5.039161] ... APIC LVTT: 000000ef
[    5.039161] ... APIC LVTPC: 00000400
[    5.039161] ... APIC LVT0: 00010700
[    5.039161] ... APIC LVT1: 00000400
[    5.039161] ... APIC LVTERR: 000000fe
[    5.039161] ... APIC TMICT: 002a1f67
[    5.039161] ... APIC TMCCT: 000b570b
[    5.039161] ... APIC TDCR: 00000003
[    5.039161] 
[    5.144118] number of MP IRQ sources: 15.
[    5.148245] number of IO-APIC #8 registers: 24.
[    5.152904] number of IO-APIC #9 registers: 24.
[    5.157556] testing the IO APIC.......................
[    5.162834] IO APIC #8......
[    5.165839] .... register #00: 08000000
[    5.169800] .......    : physical APIC id: 08
[    5.174285] .......    : Delivery Type: 0
[    5.178421] .......    : LTS          : 0
[    5.182560] .... register #01: 00170020
[    5.186516] .......     : max redirection entries: 17
[    5.191688] .......     : PRQ implemented: 0
[    5.196084] .......     : IO APIC version: 20
[    5.200568] .... IRQ redirection table:
[    5.204535] 1    0    0   0   0    0    0    00
[    5.209196] 0    0    0   0   0    1    1    31
[    5.213853] 0    0    0   0   0    1    1    30
[    5.218506] 0    0    0   0   0    1    1    33
[    5.223167] 0    0    0   0   0    1    1    34
[    5.227829] 0    0    0   0   0    1    1    35
[    5.232490] 0    0    0   0   0    1    1    36
[    5.237149] 0    0    0   0   0    1    1    37
[    5.241804] 0    0    0   0   0    1    1    38
[    5.246463] 0    1    0   0   0    1    1    39
[    5.251119] 0    0    0   0   0    1    1    3A
[    5.255774] 0    0    0   0   0    1    1    3B
[    5.260429] 0    0    0   0   0    1    1    3C
[    5.265087] 0    0    0   0   0    1    1    3D
[    5.269744] 0    0    0   0   0    1    1    3E
[    5.274404] 0    0    0   0   0    1    1    3F
[    5.279063] 1    1    0   1   0    1    1    91
[    5.283726] 1    0    0   0   0    0    0    00
[    5.288383] 1    1    0   1   0    1    1    A1
[    5.293043] 1    1    0   1   0    1    1    C1
[    5.297702] 1    0    0   0   0    0    0    00
[    5.302356] 1    0    0   0   0    0    0    00
[    5.307016] 0    1    0   1   0    1    1    22
[    5.311676] 0    1    0   1   0    1    1    E1
[    5.316336] IO APIC #9......
[    5.319333] .... register #00: 09000000
[    5.323294] .......    : physical APIC id: 09
[    5.327780] .......    : Delivery Type: 0
[    5.331915] .......    : LTS          : 0
[    5.336053] .... register #01: 00178020
[    5.340014] .......     : max redirection entries: 17
[    5.345192] .......     : PRQ implemented: 1
[    5.349589] .......     : IO APIC version: 20
[    5.354074] .... register #02: 09000000
[    5.358034] .......     : arbitration: 09
[    5.362167] .... register #03: 00000001
[    5.366123] .......     : Boot DT    : 1
[    5.370169] .... IRQ redirection table:
[    5.374128] 1    0    0   0   0    0    0    00
[    5.378785] 1    0    0   0   0    0    0    00
[    5.383446] 1    0    0   0   0    0    0    00
[    5.388099] 1    0    0   0   0    0    0    00
[    5.392760] 1    0    0   0   0    0    0    00
[    5.397421] 1    0    0   0   0    0    0    00
[    5.402084] 1    0    0   0   0    0    0    00
[    5.406733] 1    0    0   0   0    0    0    00
[    5.411392] 1    0    0   0   0    0    0    00
[    5.416047] 1    0    0   0   0    0    0    00
[    5.420705] 1    0    0   0   0    0    0    00
[    5.425359] 1    0    0   0   0    0    0    00
[    5.430018] 1    0    0   0   0    0    0    00
[    5.434678] 1    0    0   0   0    0    0    00
[    5.439337] 1    0    0   0   0    0    0    00
[    5.443999] 1    0    0   0   0    0    0    00
[    5.448660] 1    0    0   0   0    0    0    00
[    5.453317] 1    0    0   0   0    0    0    00
[    5.457971] 1    0    0   0   0    0    0    00
[    5.462628] 1    0    0   0   0    0    0    00
[    5.467283] 1    0    0   0   0    0    0    00
[    5.471942] 1    0    0   0   0    0    0    00
[    5.476601] 1    0    0   0   0    0    0    00
[    5.481264] 1    0    0   0   0    0    0    00
[    5.485923] IRQ to pin mappings:
[    5.489282] IRQ0 -> 0:2
[    5.491981] IRQ1 -> 0:1
[    5.494682] IRQ3 -> 0:3
[    5.497387] IRQ4 -> 0:4
[    5.500093] IRQ5 -> 0:5
[    5.502790] IRQ6 -> 0:6
[    5.505494] IRQ7 -> 0:7
[    5.508194] IRQ8 -> 0:8
[    5.510891] IRQ9 -> 0:9
[    5.513594] IRQ10 -> 0:10
[    5.516463] IRQ11 -> 0:11
[    5.519346] IRQ12 -> 0:12
[    5.522219] IRQ13 -> 0:13
[    5.525086] IRQ14 -> 0:14
[    5.527958] IRQ15 -> 0:15
[    5.530833] IRQ16 -> 0:16
[    5.533709] IRQ18 -> 0:18
[    5.536594] IRQ19 -> 0:19
[    5.539461] IRQ22 -> 0:22
[    5.542339] IRQ23 -> 0:23
[    5.545203] .................................... done.
[    5.550618] Loading compiled-in X.509 certificates
[    5.556487] Loaded X.509 cert 'Magrathea: Glacier signing key: 655fb4d5d7cebbf515cdb1c11f96c46ead2df1e4'
[    5.566161] registered taskstats version 1
[    5.572407] Key type trusted registered
[    5.577814] Key type encrypted registered
[    5.583405] ima: No TPM chip found, activating TPM-bypass!
[    5.589047] evm: HMAC attrs: 0x1
[    5.595044] rtc_cmos 00:01: setting system clock to 1970-01-10 08:08:11 UTC (806891)
[    5.628862] e1000e 0000:05:00.0: irq 24 for MSI/MSI-X
[    5.735584] e1000e 0000:05:00.0: irq 24 for MSI/MSI-X
[    5.741735] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    5.773664] e1000e 0000:05:00.1: irq 25 for MSI/MSI-X
[    5.880585] e1000e 0000:05:00.1: irq 25 for MSI/MSI-X
[    5.886735] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[    8.163567] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[    8.172052] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    8.183028] Sending DHCP requests ..
[   13.335038] random: nonblocking pool is initialized
[   15.744025] ., OK
[   15.782075] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.35
[   15.838832] e1000e: eth1 NIC Link is Down
[   15.843109] IP-Config: Complete:
[   15.846449]      device=eth0, hwaddr=00:15:17:8c:73:3c, ipaddr=192.168.1.35, mask=255.255.255.0, gw=192.168.1.1
[   15.856712]      host=client5, domain=lkp.intel.com, nis-domain=(none)
[   15.863353]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
[   15.870099]      nameserver0=192.168.1.1
[   15.874502] PM: Hibernation image not present or could not be loaded.
[   15.882755] Freeing unused kernel memory: 1828K (ffffffff81df6000 - ffffffff81fbf000)
[   16.017049] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   16.017136] ipmi message handler version 39.2
[   16.030472] IPMI System Interface driver.
[   16.034668] ipmi_si: probing via ACPI
[   16.034701] ipmi_si 00:07: [io  0x0ca2] regsize 1 spacing 1 irq 0
[   16.034704] ipmi_si: Adding ACPI-specified kcs state machine
[   16.034721] ipmi_si: probing via SMBIOS
[   16.034722] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
[   16.034723] ipmi_si: Adding SMBIOS-specified kcs state machine duplicate interface
[   16.034725] ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[   16.078877] IOAPIC[0]: Set routing entry (8-20 -> 0x82 -> IRQ 20 Mode:1 Active:1 Dest:255)
[   16.087380] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[   16.093941] input: PC Speaker as /devices/platform/pcspkr/input/input5
[   16.100921] libata version 3.00 loaded.
[   16.106929] ata_piix 0000:00:1f.1: version 2.13
[   16.111755] EDAC MC: Ver: 3.0.0
[   16.112961] scsi host0: ata_piix
[   16.113239] scsi host1: ata_piix
[   16.113286] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x30c0 irq 14
[   16.113287] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x30c8 irq 15
[   16.136506] ahci 0000:00:1f.2: version 3.0
[   16.141171] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[   16.143988] ipmi_si 00:07: Found new BMC (man_id: 0x000157, prod_id: 0x0028, dev_id: 0x20)
[   16.143995] ipmi_si 00:07: IPMI kcs interface initialized
[   16.163607] ahci 0000:00:1f.2: flags: 64bit ncq pm led pmp slum part 
[   16.170555] genirq: Flags mismatch irq 20. 00002080 (ahci) vs. 00000080 (i801_smbus)
[   16.171533] CPU: 1 PID: 369 Comm: modprobe Not tainted 3.18.0-rc2-wl-ga4fb664 #1
[   16.171533] Hardware name: Intel S5000PAL/S5000PAL0, BIOS S5000.86B.10.00.0094.101320081858 10/13/2008
[   16.171533]  ffff88035d539b00 ffff88035d42b988 ffffffff8187741c 00000000000033c0
[   16.171533]  ffff88032efe5400 ffff88035d42b9e8 ffffffff810cbbaf ffff88035d42b9e8
[   16.171533]  0000000000000246 ffffffff810cbd22 ffff880344fa5800 ffff88035ca8a0e0
[   16.171533] Call Trace:
[   16.171533]  [<ffffffff8187741c>] dump_stack+0x4e/0x68
[   16.171533]  [<ffffffff810cbbaf>] __setup_irq+0x57f/0x5d0
[   16.171533]  [<ffffffff810cbd22>] ? request_threaded_irq+0x82/0x190
[   16.171533]  [<ffffffffa008c740>] ? ahci_dev_classify+0x60/0x60 [libahci]
[   16.171533]  [<ffffffff810cbd6c>] request_threaded_irq+0xcc/0x190
[   16.171533]  [<ffffffffa008c740>] ? ahci_dev_classify+0x60/0x60 [libahci]
[   16.171533]  [<ffffffffa008ce50>] ? ahci_port_thread_fn+0x600/0x600 [libahci]
[   16.171533]  [<ffffffff810cdc6f>] devm_request_threaded_irq+0x5f/0xc0
[   16.171533]  [<ffffffffa008d4f0>] ahci_host_activate+0x80/0x220 [libahci]
[   16.171533]  [<ffffffff8143ac1a>] ? pcibios_set_master+0x5a/0x90
[   16.171533]  [<ffffffffa00f5c45>] ahci_init_one+0x8c5/0xb60 [ahci]
[   16.171533]  [<ffffffff8143c365>] local_pci_probe+0x45/0xa0
[   16.171533]  [<ffffffff8143d6d5>] ? pci_match_device+0xe5/0x110
[   16.171533]  [<ffffffff8143d811>] pci_device_probe+0xd1/0x120
[   16.171533]  [<ffffffff81513320>] driver_probe_device+0x90/0x3e0
[   16.171533]  [<ffffffff8151374b>] __driver_attach+0x9b/0xa0
[   16.171533]  [<ffffffff815136b0>] ? __device_attach+0x40/0x40
[   16.171533]  [<ffffffff8151112b>] bus_for_each_dev+0x6b/0xb0
[   16.171533]  [<ffffffff81512d9e>] driver_attach+0x1e/0x20
[   16.171533]  [<ffffffff81512980>] bus_add_driver+0x180/0x250
[   16.171533]  [<ffffffffa002c000>] ? 0xffffffffa002c000
[   16.171533]  [<ffffffff81513f54>] driver_register+0x64/0xf0
[   16.171533]  [<ffffffff8143bbbc>] __pci_register_driver+0x4c/0x50
[   16.171533]  [<ffffffffa002c01e>] ahci_pci_driver_init+0x1e/0x1000 [ahci]
[   16.171533]  [<ffffffff81002130>] do_one_initcall+0xc0/0x1f0
[   16.171533]  [<ffffffff811a44d2>] ? __vunmap+0xa2/0x100
[   16.171533]  [<ffffffff810f6491>] load_module+0x15c1/0x1a60
[   16.171533]  [<ffffffff810f1e20>] ? store_uevent+0x40/0x40
[   16.171533]  [<ffffffff810f6ad6>] SyS_finit_module+0x86/0xb0
[   16.171533]  [<ffffffff8187fb29>] system_call_fastpath+0x12/0x17
[   16.403261] ahci: probe of 0000:00:1f.2 failed with error -16
[   16.409519] EDAC MC0: Giving out device to module i5000_edac.c controller I5000: DEV 0000:00:10.0 (POLLED)
[   16.419702] EDAC PCI0: Giving out device to module i5000_edac controller EDAC PCI controller: DEV 0000:00:10.0 (POLLED)
[   16.432200] Error: Driver 'pcspkr' is already registered, aborting...
[   18.372575] Key type dns_resolver registered
[   18.385624] Key type cifs.spnego registered
[   18.389935] Key type cifs.idmap registered
<6>[    0.000000] Initializing cgroup subsys cpuset
<6>[    0.000000] Initializing cgroup subsys cpu
<5>[    0.000000] Linux version 3.18.0-rc2-wl-ga4fb664 (kbuild@xian) (gcc version 4.9.1 (Debian 4.9.1-19) ) #1 SMP Fri Oct 31 23:24:12 CST 2014
<6>[    0.000000] Command line: user=lkp job=/lkp/scheduled/client5/boot_boot-performance-1-x86_64-rhel-a4fb6646dd55a6ba18df37134e9a22088da0a0db-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/a4fb6646dd55a6ba18df37134e9a22088da0a0db/vmlinuz-3.18.0-rc2-wl-ga4fb664 kconfig=x86_64-rhel commit=a4fb6646dd55a6ba18df37134e9a22088da0a0db branch=linux-devel/devel-hourly-2014103123 root=/dev/ram0 max_uptime=3600 RESULT_ROOT=/result/client5/boot/performance-1/debian-x86_64.cgz/x86_64-rhel/a4fb6646dd55a6ba18df37134e9a22088da0a0db/0 LKP_SERVER=10.239.97.14 ip=::::client5::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
<6>[    0.000000] e820: BIOS-provided physical RAM map:
<6>[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009ebff] usable
<6>[    0.000000] BIOS-e820: [mem 0x000000000009ec00-0x00000000000fffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000009e259fff] usable
<6>[    0.000000] BIOS-e820: [mem 0x000000009e25a000-0x000000009e320fff] ACPI NVS
<6>[    0.000000] BIOS-e820: [mem 0x000000009e321000-0x000000009fa31fff] usable
<6>[    0.000000] BIOS-e820: [mem 0x000000009fa32000-0x000000009fa99fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x000000009fa9a000-0x000000009faa8fff] usable
<6>[    0.000000] BIOS-e820: [mem 0x000000009faa9000-0x000000009fb19fff] ACPI NVS
<6>[    0.000000] BIOS-e820: [mem 0x000000009fb1a000-0x000000009fb24fff] usable
<6>[    0.000000] BIOS-e820: [mem 0x000000009fb25000-0x000000009fb39fff] ACPI data
<6>[    0.000000] BIOS-e820: [mem 0x000000009fb3a000-0x000000009fbfffff] usable
<6>[    0.000000] BIOS-e820: [mem 0x000000009fc00000-0x00000000afffffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffc0bfff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000035fffffff] usable
<6>[    0.000000] bootconsole [earlyser0] enabled
<6>[    0.000000] NX (Execute Disable) protection: active
<6>[    0.000000] SMBIOS 2.5 present.
<7>[    0.000000] DMI: Intel S5000PAL/S5000PAL0, BIOS S5000.86B.10.00.0094.101320081858 10/13/2008
<7>[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
<7>[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
<6>[    0.000000] AGP: No AGP bridge found
<6>[    0.000000] e820: last_pfn = 0x360000 max_arch_pfn = 0x400000000
<7>[    0.000000] MTRR default type: uncachable
<7>[    0.000000] MTRR fixed ranges enabled:
<7>[    0.000000]   00000-9FFFF write-back
<7>[    0.000000]   A0000-FFFFF uncachable
<7>[    0.000000] MTRR variable ranges enabled:
<7>[    0.000000]   0 base 0000000000 mask 3F80000000 write-back
<7>[    0.000000]   1 base 0080000000 mask 3FE0000000 write-back
<7>[    0.000000]   2 base 009FC00000 mask 3FFFC00000 uncachable
<7>[    0.000000]   3 base 0100000000 mask 3F00000000 write-back
<7>[    0.000000]   4 base 0200000000 mask 3E00000000 write-back
<7>[    0.000000]   5 disabled
<7>[    0.000000]   6 disabled
<7>[    0.000000]   7 disabled
<6>[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
<7>[    0.000000] e820: update [mem 0x9fc00000-0xffffffff] usable ==> reserved
<6>[    0.000000] e820: last_pfn = 0x9fc00 max_arch_pfn = 0x400000000
<4>[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
<4>[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
<4>[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
<6>[    0.000000] found SMP MP-table at [mem 0x000fd960-0x000fd96f] mapped at [ffff8800000fd960]
<4>[    0.000000]   mpc: ef020-ef22c
<7>[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
<6>[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
<7>[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
<7>[    0.000000] BRK [0x35f1a2000, 0x35f1a2fff] PGTABLE
<7>[    0.000000] BRK [0x35f1a3000, 0x35f1a3fff] PGTABLE
<7>[    0.000000] BRK [0x35f1a4000, 0x35f1a4fff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0x35fe00000-0x35fffffff]
<7>[    0.000000]  [mem 0x35fe00000-0x35fffffff] page 2M
<7>[    0.000000] BRK [0x35f1a5000, 0x35f1a5fff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0x35c000000-0x35fdfffff]
<7>[    0.000000]  [mem 0x35c000000-0x35fdfffff] page 2M
<6>[    0.000000] init_memory_mapping: [mem 0x300000000-0x35bffffff]
<7>[    0.000000]  [mem 0x300000000-0x35bffffff] page 2M
<7>[    0.000000] BRK [0x35f1a6000, 0x35f1a6fff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0x00100000-0x9e259fff]
<7>[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
<7>[    0.000000]  [mem 0x00200000-0x9e1fffff] page 2M
<7>[    0.000000]  [mem 0x9e200000-0x9e259fff] page 4k
<7>[    0.000000] BRK [0x35f1a7000, 0x35f1a7fff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0x9e321000-0x9fa31fff]
<7>[    0.000000]  [mem 0x9e321000-0x9e3fffff] page 4k
<7>[    0.000000]  [mem 0x9e400000-0x9f9fffff] page 2M
<7>[    0.000000]  [mem 0x9fa00000-0x9fa31fff] page 4k
<6>[    0.000000] init_memory_mapping: [mem 0x9fa9a000-0x9faa8fff]
<7>[    0.000000]  [mem 0x9fa9a000-0x9faa8fff] page 4k
<6>[    0.000000] init_memory_mapping: [mem 0x9fb1a000-0x9fb24fff]
<7>[    0.000000]  [mem 0x9fb1a000-0x9fb24fff] page 4k
<6>[    0.000000] init_memory_mapping: [mem 0x9fb3a000-0x9fbfffff]
<7>[    0.000000]  [mem 0x9fb3a000-0x9fbfffff] page 4k
<6>[    0.000000] init_memory_mapping: [mem 0x100000000-0x2ffffffff]
<7>[    0.000000]  [mem 0x100000000-0x2ffffffff] page 2M
<6>[    0.000000] RAMDISK: [mem 0x356687000-0x35dffffff]
<6>[    0.000000] ACPI: Early table checksum verification disabled
<4>[    0.000000] ACPI: RSDP 0x00000000000F03F0 000024 (v02 INTEL )
<4>[    0.000000] ACPI: XSDT 0x000000009FB39120 00008C (v01 INTEL  S5000PAL 00000000 INTL 01000013)
<4>[    0.000000] ACPI: SLIC 0x000000009FB38000 000176 (v01 INTEL  S5000PAL 00000002 INTL 01000013)
<4>[    0.000000] ACPI: FACP 0x000000009FB36000 0000F4 (v03 INTEL  S5000PAL 00000000 INTL 01000013)
<4>[    0.000000] ACPI: DSDT 0x000000009FB2F000 005DC3 (v02 INTEL  S5000PAL 00000008 INTL 01000013)
<4>[    0.000000] ACPI: FACS 0x000000009FAA9000 000040
<4>[    0.000000] ACPI: APIC 0x000000009FB35000 0000C8 (v01 INTEL  S5000PAL 00000000 INTL 01000013)
<4>[    0.000000] ACPI: SPCR 0x000000009FB2E000 000050 (v01 INTEL  S5000PAL 00000000 INTL 01000013)
<4>[    0.000000] ACPI: HPET 0x000000009FB2D000 000038 (v01 INTEL  S5000PAL 00000001 INTL 01000013)
<4>[    0.000000] ACPI: MCFG 0x000000009FB2C000 00003C (v01 INTEL  S5000PAL 00000001 INTL 01000013)
<4>[    0.000000] ACPI: SSDT 0x000000009FB2B000 000A14 (v02 INTEL  EIST     00004000 INTL 20060317)
<4>[    0.000000] ACPI: SSDT 0x000000009FB2A000 000193 (v02 INTEL  IPMI     00004000 INTL 20060317)
<4>[    0.000000] ACPI: SSDT 0x000000009FB29000 0002D4 (v02 INTEL  CST      00004000 INTL 20060317)
<4>[    0.000000] ACPI: HEST 0x000000009FB28000 0000A8 (v01 INTEL  S5000PAL 00000001 INTL 00000001)
<4>[    0.000000] ACPI: BERT 0x000000009FB27000 000030 (v01 INTEL  S5000PAL 00000001 INTL 00000001)
<4>[    0.000000] ACPI: ERST 0x000000009FB26000 000230 (v01 INTEL  S5000PAL 00000001 INTL 00000001)
<4>[    0.000000] ACPI: EINJ 0x000000009FB25000 000130 (v01 INTEL  S5000PAL 00000001 INTL 00000001)
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<4>[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
<6>[    0.000000] No NUMA configuration found
<6>[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000035fffffff]
<6>[    0.000000] NODE_DATA(0) allocated [mem 0x35ffcf000-0x35fff4fff]
<7>[    0.000000]  [ffffea0000000000-ffffea000d7fffff] PMD -> [ffff88034a600000-ffff8803565fffff] on node 0
<4>[    0.000000] Zone ranges:
<4>[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
<4>[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
<4>[    0.000000]   Normal   [mem 0x100000000-0x35fffffff]
<4>[    0.000000] Movable zone start for each node
<4>[    0.000000] Early memory node ranges
<4>[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
<4>[    0.000000]   node   0: [mem 0x00100000-0x9e259fff]
<4>[    0.000000]   node   0: [mem 0x9e321000-0x9fa31fff]
<4>[    0.000000]   node   0: [mem 0x9fa9a000-0x9faa8fff]
<4>[    0.000000]   node   0: [mem 0x9fb1a000-0x9fb24fff]
<4>[    0.000000]   node   0: [mem 0x9fb3a000-0x9fbfffff]
<4>[    0.000000]   node   0: [mem 0x100000000-0x35fffffff]
<6>[    0.000000] Initmem setup node 0 [mem 0x00001000-0x35fffffff]
<7>[    0.000000] On node 0 totalpages: 3144168
<7>[    0.000000]   DMA zone: 64 pages used for memmap
<7>[    0.000000]   DMA zone: 21 pages reserved
<7>[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
<7>[    0.000000]   DMA32 zone: 10154 pages used for memmap
<7>[    0.000000]   DMA32 zone: 649803 pages, LIFO batch:31
<7>[    0.000000]   Normal zone: 38912 pages used for memmap
<7>[    0.000000]   Normal zone: 2490368 pages, LIFO batch:31
<6>[    0.000000] ACPI: PM-Timer IO Port: 0x408
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<4>[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x01] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x03] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
<6>[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
<6>[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
<6>[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec80000] gsi_base[24])
<6>[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec80000, GSI 24-47
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 8, APIC INT 02
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
<4>[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 8, APIC INT 09
<7>[    0.000000] ACPI: IRQ0 used by override.
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 8, APIC INT 01
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 8, APIC INT 03
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 8, APIC INT 04
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 8, APIC INT 05
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 8, APIC INT 06
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 8, APIC INT 07
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 8, APIC INT 08
<7>[    0.000000] ACPI: IRQ9 used by override.
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 8, APIC INT 0a
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 8, APIC INT 0b
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 8, APIC INT 0c
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 8, APIC INT 0d
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 8, APIC INT 0e
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 8, APIC INT 0f
<6>[    0.000000] Using ACPI (MADT) for SMP configuration information
<6>[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
<6>[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
<4>[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
<4>[    0.000000] mapped IOAPIC to ffffffffff57a000 (fec80000)
<6>[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x000fffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x9e25a000-0x9e320fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x9fa32000-0x9fa99fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x9faa9000-0x9fb19fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x9fb25000-0x9fb39fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x9fc00000-0xafffffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xb0000000-0xffbfffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xffc00000-0xffc0bfff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xffc0c000-0xffffffff]
<6>[    0.000000] e820: [mem 0xb0000000-0xffbfffff] available for PCI devices
<6>[    0.000000] Booting paravirtualized kernel on bare hardware
<6>[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
<6>[    0.000000] PERCPU: Embedded 31 pages/cpu @ffff88035fc00000 s89152 r8192 d29632 u262144
<7>[    0.000000] pcpu-alloc: s89152 r8192 d29632 u262144 alloc=1*2097152
<7>[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
<4>[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 3095017
<4>[    0.000000] Policy zone: Normal
<5>[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/client5/boot_boot-performance-1-x86_64-rhel-a4fb6646dd55a6ba18df37134e9a22088da0a0db-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/a4fb6646dd55a6ba18df37134e9a22088da0a0db/vmlinuz-3.18.0-rc2-wl-ga4fb664 kconfig=x86_64-rhel commit=a4fb6646dd55a6ba18df37134e9a22088da0a0db branch=linux-devel/devel-hourly-2014103123 root=/dev/ram0 max_uptime=3600 RESULT_ROOT=/result/client5/boot/performance-1/debian-x86_64.cgz/x86_64-rhel/a4fb6646dd55a6ba18df37134e9a22088da0a0db/0 LKP_SERVER=10.239.97.14 ip=::::client5::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
<6>[    0.000000] sysrq: sysrq always enabled.
<6>[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
<6>[    0.000000] AGP: Checking aperture...
<6>[    0.000000] AGP: No AGP bridge found
<4>[    0.000000] Memory: 12170016K/12576672K available (8723K kernel code, 1696K rwdata, 3856K rodata, 1828K init, 1888K bss, 406656K reserved)
<6>[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
<6>[    0.000000] Hierarchical RCU implementation.
<6>[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=8.
<6>[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
<6>[    0.000000] NR_IRQS:524544 nr_irqs:896 0
<6>[    0.000000] 	Offload RCU callbacks from all CPUs
<6>[    0.000000] 	Offload RCU callbacks from CPUs: 0-7.
<6>[    0.000000] Console: colour VGA+ 80x25
<6>[    0.000000] console [tty0] enabled
<6>[    0.000000] bootconsole [earlyser0] disabled
<6>[    0.000000] console [ttyS0] enabled
<6>[    0.000000] allocated 50331648 bytes of page_cgroup
<6>[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
<7>[    0.000000] hpet clockevent registered
<6>[    0.000000] tsc: Fast TSC calibration using PIT
<6>[    0.000000] tsc: Detected 2992.395 MHz processor
<6>[    0.000015] Calibrating delay loop (skipped), value calculated using timer frequency.. lpj=2992395
<6>[    0.001000] pid_max: default: 32768 minimum: 301
<6>[    0.001000] ACPI: Core revision 20140926
<4>[    0.001000] ACPI: All ACPI Tables successfully acquired
<6>[    0.001000] Security Framework initialized
<6>[    0.001000] SELinux:  Initializing.
<7>[    0.001000] SELinux:  Starting in permissive mode
<6>[    0.001000] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
<6>[    0.001000] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
<6>[    0.001000] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
<6>[    0.001000] Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)
<6>[    0.001000] Initializing cgroup subsys memory
<6>[    0.001000] Initializing cgroup subsys devices
<6>[    0.001000] Initializing cgroup subsys freezer
<6>[    0.001000] Initializing cgroup subsys net_cls
<6>[    0.001000] Initializing cgroup subsys blkio
<6>[    0.001000] Initializing cgroup subsys perf_event
<6>[    0.001000] Initializing cgroup subsys hugetlb
<6>[    0.001000] CPU: Physical Processor ID: 0
<6>[    0.001000] CPU: Processor Core ID: 0
<6>[    0.001000] mce: CPU supports 6 MCE banks
<7>[    0.001000] CPU0: Thermal LVT vector (0xfa) already installed
<6>[    0.001000] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
<6>[    0.001000] Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32, 1GB 0
<6>[    0.001000] Freeing SMP alternatives memory: 36K (ffffffff81fbf000 - ffffffff81fc8000)
<6>[    0.001000] ftrace: allocating 31375 entries in 123 pages
<4>[    0.001000] Getting VERSION: 50014
<4>[    0.001000] Getting VERSION: 50014
<4>[    0.001000] Getting ID: 0
<4>[    0.001000] Getting ID: 0
<4>[    0.001000] masked ExtINT on CPU#0
<4>[    0.001000] ENABLING IO-APIC IRQs
<7>[    0.001000] init IO_APIC IRQs
<7>[    0.001000]  apic 8 pin 0 not connected
<7>[    0.001000] IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
<7>[    0.001000] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
<7>[    0.001000] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
<7>[    0.001009] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
<7>[    0.002005] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
<7>[    0.003004] IOAPIC[0]: Set routing entry (8-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
<7>[    0.004004] IOAPIC[0]: Set routing entry (8-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
<7>[    0.005004] IOAPIC[0]: Set routing entry (8-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
<7>[    0.006004] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
<7>[    0.007004] IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
<7>[    0.008004] IOAPIC[0]: Set routing entry (8-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
<7>[    0.009004] IOAPIC[0]: Set routing entry (8-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
<7>[    0.010004] IOAPIC[0]: Set routing entry (8-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
<7>[    0.011004] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
<7>[    0.012005] IOAPIC[0]: Set routing entry (8-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
<7>[    0.013004] IOAPIC[0]: Set routing entry (8-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
<7>[    0.014003]  apic 8 pin 16 not connected
<7>[    0.015001]  apic 8 pin 17 not connected
<7>[    0.016001]  apic 8 pin 18 not connected
<7>[    0.017001]  apic 8 pin 19 not connected
<7>[    0.018001]  apic 8 pin 20 not connected
<7>[    0.019001]  apic 8 pin 21 not connected
<7>[    0.020001]  apic 8 pin 22 not connected
<7>[    0.021001]  apic 8 pin 23 not connected
<7>[    0.022001]  apic 9 pin 0 not connected
<7>[    0.023001]  apic 9 pin 1 not connected
<7>[    0.024001]  apic 9 pin 2 not connected
<7>[    0.025001]  apic 9 pin 3 not connected
<7>[    0.026001]  apic 9 pin 4 not connected
<7>[    0.027001]  apic 9 pin 5 not connected
<7>[    0.028001]  apic 9 pin 6 not connected
<7>[    0.029001]  apic 9 pin 7 not connected
<7>[    0.030001]  apic 9 pin 8 not connected
<7>[    0.031001]  apic 9 pin 9 not connected
<7>[    0.032001]  apic 9 pin 10 not connected
<7>[    0.033001]  apic 9 pin 11 not connected
<7>[    0.034001]  apic 9 pin 12 not connected
<7>[    0.035001]  apic 9 pin 13 not connected
<7>[    0.036001]  apic 9 pin 14 not connected
<7>[    0.037001]  apic 9 pin 15 not connected
<7>[    0.038001]  apic 9 pin 16 not connected
<7>[    0.039001]  apic 9 pin 17 not connected
<7>[    0.040001]  apic 9 pin 18 not connected
<7>[    0.041001]  apic 9 pin 19 not connected
<7>[    0.042001]  apic 9 pin 20 not connected
<7>[    0.043001]  apic 9 pin 21 not connected
<7>[    0.044001]  apic 9 pin 22 not connected
<7>[    0.045001]  apic 9 pin 23 not connected
<6>[    0.046133] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
<6>[    0.057834] smpboot: CPU0: Intel(R) Xeon(R) CPU           E5450  @ 3.00GHz (fam: 06, model: 17, stepping: 06)
<4>[    0.061001] Using local APIC timer interrupts.
<4>[    0.061001] calibrating APIC timer ...
<4>[    0.063000] ... lapic delta = 2078100
<4>[    0.063000] ... PM-Timer delta = 357951
<4>[    0.063000] ... PM-Timer result ok
<4>[    0.063000] ..... delta 2078100
<4>[    0.063000] ..... mult: 89253715
<4>[    0.063000] ..... calibration result: 332496
<4>[    0.063000] ..... CPU clock speed is 2992.0464 MHz.
<4>[    0.063000] ..... host bus clock speed is 332.0496 MHz.
<6>[    0.063027] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
<6>[    0.068002] ... version:                2
<6>[    0.069001] ... bit width:              40
<6>[    0.070000] ... generic registers:      2
<6>[    0.071001] ... value mask:             000000ffffffffff
<6>[    0.072001] ... max period:             000000007fffffff
<6>[    0.073000] ... fixed-purpose events:   3
<6>[    0.074001] ... event mask:             0000000700000003
<6>[    0.077428] x86: Booting SMP configuration:
<6>[    0.078002] .... node  #0, CPUs:      #1
<4>[    0.077304] masked ExtINT on CPU#1
<7>[    0.077304] CPU1: Thermal LVT vector (0xfa) already installed
<6>[    0.102243] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
<4>[    0.103142]  #2
<4>[    0.103015] masked ExtINT on CPU#2
<7>[    0.103015] CPU2: Thermal LVT vector (0xfa) already installed
<4>[    0.185139]  #3
<4>[    0.185010] masked ExtINT on CPU#3
<7>[    0.185010] CPU3: Thermal LVT vector (0xfa) already installed
<4>[    0.208145]  #4
<4>[    0.208011] masked ExtINT on CPU#4
<7>[    0.208011] CPU4: Thermal LVT vector (0xfa) already installed
<4>[    0.231045]  #5
<4>[    0.230037] masked ExtINT on CPU#5
<7>[    0.230037] CPU5: Thermal LVT vector (0xfa) already installed
<4>[    0.254165]  #6
<4>[    0.254012] masked ExtINT on CPU#6
<7>[    0.254012] CPU6: Thermal LVT vector (0xfa) already installed
<4>[    0.277136]  #7
<4>[    0.277012] masked ExtINT on CPU#7
<7>[    0.277012] CPU7: Thermal LVT vector (0xfa) already installed
<6>[    0.299012] x86: Booted up 1 node, 8 CPUs
<6>[    0.300003] smpboot: Total of 8 processors activated (47879.39 BogoMIPS)
<6>[    0.302402] devtmpfs: initialized
<6>[    0.307391] evm: security.selinux
<6>[    0.308001] evm: security.ima
<6>[    0.309001] evm: security.capability
<6>[    0.310127] PM: Registering ACPI NVS region [mem 0x9e25a000-0x9e320fff] (815104 bytes)
<6>[    0.311017] PM: Registering ACPI NVS region [mem 0x9faa9000-0x9fb19fff] (462848 bytes)
<6>[    0.314395] atomic64_test: passed for x86-64 platform with CX8 and with SSE
<6>[    0.315179] NET: Registered protocol family 16
<6>[    0.319007] cpuidle: using governor menu
<6>[    0.320139] ACPI: bus type PCI registered
<6>[    0.321002] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
<6>[    0.322077] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xa0000000-0xafffffff] (base 0xa0000000)
<6>[    0.323003] PCI: MMCONFIG at [mem 0xa0000000-0xafffffff] reserved in E820
<6>[    0.324475] PCI: Using configuration type 1 for base access
<6>[    0.330125] ACPI: Added _OSI(Module Device)
<6>[    0.331003] ACPI: Added _OSI(Processor Device)
<6>[    0.332001] ACPI: Added _OSI(3.0 _SCP Extensions)
<6>[    0.333001] ACPI: Added _OSI(Processor Aggregator Device)
<7>[    0.334608] IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:255)
<4>[    0.338234] ACPI Error: Field [CPB3] at 96 exceeds Buffer [NULL] size 64 (bits) (20140926/dsopcode-236)
<4>[    0.341002] ACPI Error: Method parse/execution failed [\_SB_._OSC] (Node ffff88034a060de8), AE_AML_BUFFER_LIMIT (20140926/psparse-536)
<6>[    0.347160] ACPI: Interpreter enabled
<4>[    0.348008] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140926/hwxface-580)
<4>[    0.351002] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20140926/hwxface-580)
<6>[    0.354008] ACPI: (supports S0 S1 S4 S5)
<6>[    0.355001] ACPI: Using IOAPIC for interrupt routing
<6>[    0.356047] HEST: Table parsing has been initialized.
<6>[    0.357003] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
<6>[    0.362887] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
<6>[    0.363006] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
<6>[    0.364004] acpi PNP0A08:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
<6>[    0.367770] PCI host bridge to bus 0000:00
<6>[    0.368003] pci_bus 0000:00: root bus resource [bus 00-ff]
<6>[    0.369002] pci_bus 0000:00: root bus resource [io  0x0000-0x0ca1]
<6>[    0.370002] pci_bus 0000:00: root bus resource [io  0x0ca4-0x0cf7]
<6>[    0.371002] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
<6>[    0.372001] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
<6>[    0.373002] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000fffff]
<6>[    0.374002] pci_bus 0000:00: root bus resource [mem 0xb0000000-0xfdffffff]
<6>[    0.375001] pci_bus 0000:00: root bus resource [mem 0xfe700000-0xfe7003ff]
<7>[    0.376011] pci 0000:00:00.0: [8086:25d8] type 00 class 0x060000
<7>[    0.377050] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
<7>[    0.378081] pci 0000:00:02.0: [8086:25f7] type 01 class 0x060400
<7>[    0.380008] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
<7>[    0.381089] pci 0000:00:03.0: [8086:25e3] type 01 class 0x060400
<7>[    0.382039] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
<7>[    0.383066] pci 0000:00:04.0: [8086:25f8] type 01 class 0x060400
<7>[    0.384039] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
<6>[    0.385036] pci 0000:00:04.0: System wakeup disabled by ACPI
<7>[    0.386040] pci 0000:00:05.0: [8086:25e5] type 01 class 0x060400
<7>[    0.387038] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
<6>[    0.388031] pci 0000:00:05.0: System wakeup disabled by ACPI
<7>[    0.389040] pci 0000:00:06.0: [8086:25f9] type 01 class 0x060400
<7>[    0.390039] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
<6>[    0.391031] pci 0000:00:06.0: System wakeup disabled by ACPI
<7>[    0.392042] pci 0000:00:07.0: [8086:25e7] type 01 class 0x060400
<7>[    0.393038] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
<6>[    0.394041] pci 0000:00:07.0: System wakeup disabled by ACPI
<7>[    0.395041] pci 0000:00:08.0: [8086:1a38] type 00 class 0x088000
<7>[    0.396009] pci 0000:00:08.0: reg 0x10: [mem 0xfe700000-0xfe7003ff 64bit]
<7>[    0.397035] pci 0000:00:08.0: PME# supported from D0 D3hot D3cold
<7>[    0.398068] pci 0000:00:10.0: [8086:25f0] type 00 class 0x060000
<7>[    0.399076] pci 0000:00:10.1: [8086:25f0] type 00 class 0x060000
<7>[    0.401137] pci 0000:00:10.2: [8086:25f0] type 00 class 0x060000
<7>[    0.402091] pci 0000:00:11.0: [8086:25f1] type 00 class 0x060000
<7>[    0.403071] pci 0000:00:13.0: [8086:25f3] type 00 class 0x060000
<7>[    0.404073] pci 0000:00:15.0: [8086:25f5] type 00 class 0x060000
<7>[    0.405069] pci 0000:00:16.0: [8086:25f6] type 00 class 0x060000
<7>[    0.406077] pci 0000:00:1d.0: [8086:2688] type 00 class 0x0c0300
<7>[    0.407035] pci 0000:00:1d.0: reg 0x20: [io  0x30a0-0x30bf]
<6>[    0.409008] pci 0000:00:1d.0: System wakeup disabled by ACPI
<7>[    0.410041] pci 0000:00:1d.1: [8086:2689] type 00 class 0x0c0300
<7>[    0.411035] pci 0000:00:1d.1: reg 0x20: [io  0x3080-0x309f]
<6>[    0.412060] pci 0000:00:1d.1: System wakeup disabled by ACPI
<7>[    0.413039] pci 0000:00:1d.2: [8086:268a] type 00 class 0x0c0300
<7>[    0.414035] pci 0000:00:1d.2: reg 0x20: [io  0x3060-0x307f]
<6>[    0.415067] pci 0000:00:1d.2: System wakeup disabled by ACPI
<7>[    0.416040] pci 0000:00:1d.3: [8086:268b] type 00 class 0x0c0300
<7>[    0.417035] pci 0000:00:1d.3: reg 0x20: [io  0x3040-0x305f]
<6>[    0.418059] pci 0000:00:1d.3: System wakeup disabled by ACPI
<7>[    0.419051] pci 0000:00:1d.7: [8086:268c] type 00 class 0x0c0320
<7>[    0.420017] pci 0000:00:1d.7: reg 0x10: [mem 0xb8b00400-0xb8b007ff]
<7>[    0.421075] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
<6>[    0.422034] pci 0000:00:1d.7: System wakeup disabled by ACPI
<7>[    0.423041] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
<7>[    0.424102] pci 0000:00:1f.0: [8086:2670] type 00 class 0x060100
<6>[    0.426028] pci 0000:00:1f.0: System wakeup disabled by ACPI
<7>[    0.427039] pci 0000:00:1f.1: [8086:269e] type 00 class 0x01018a
<7>[    0.428011] pci 0000:00:1f.1: reg 0x10: [io  0x30e8-0x30ef]
<7>[    0.429008] pci 0000:00:1f.1: reg 0x14: [io  0x30fc-0x30ff]
<7>[    0.430008] pci 0000:00:1f.1: reg 0x18: [io  0x30e0-0x30e7]
<7>[    0.431008] pci 0000:00:1f.1: reg 0x1c: [io  0x30f8-0x30fb]
<7>[    0.432008] pci 0000:00:1f.1: reg 0x20: [io  0x30c0-0x30cf]
<6>[    0.433017] pci 0000:00:1f.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
<6>[    0.434001] pci 0000:00:1f.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
<6>[    0.435001] pci 0000:00:1f.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
<6>[    0.436001] pci 0000:00:1f.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
<7>[    0.437066] pci 0000:00:1f.2: [8086:2681] type 00 class 0x010601
<7>[    0.438014] pci 0000:00:1f.2: reg 0x10: [io  0x30d8-0x30df]
<7>[    0.439007] pci 0000:00:1f.2: reg 0x14: [io  0x30f4-0x30f7]
<7>[    0.440007] pci 0000:00:1f.2: reg 0x18: [io  0x30d0-0x30d7]
<7>[    0.441007] pci 0000:00:1f.2: reg 0x1c: [io  0x30f0-0x30f3]
<7>[    0.442007] pci 0000:00:1f.2: reg 0x20: [io  0x3020-0x303f]
<7>[    0.443007] pci 0000:00:1f.2: reg 0x24: [mem 0xb8b00000-0xb8b003ff]
<7>[    0.444032] pci 0000:00:1f.2: PME# supported from D3hot
<7>[    0.445082] pci 0000:00:1f.3: [8086:269b] type 00 class 0x0c0500
<7>[    0.446046] pci 0000:00:1f.3: reg 0x20: [io  0x3000-0x301f]
<7>[    0.447403] pci 0000:01:00.0: [8086:3500] type 01 class 0x060400
<7>[    0.449781] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
<7>[    0.451459] pci 0000:01:00.3: [8086:350c] type 01 class 0x060400
<7>[    0.454367] pci 0000:01:00.3: PME# supported from D0 D3hot D3cold
<6>[    0.455287] pci 0000:01:00.3: System wakeup disabled by ACPI
<6>[    0.456127] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
<6>[    0.458048] pci 0000:00:02.0: PCI bridge to [bus 01-06]
<7>[    0.459003] pci 0000:00:02.0:   bridge window [io  0x2000-0x2fff]
<7>[    0.460003] pci 0000:00:02.0:   bridge window [mem 0xb8000000-0xb89fffff]
<7>[    0.461003] pci 0000:00:02.0:   bridge window [mem 0xb8c00000-0xb8dfffff 64bit pref]
<7>[    0.463505] pci 0000:02:00.0: [8086:3510] type 01 class 0x060400
<7>[    0.466459] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
<6>[    0.467287] pci 0000:02:00.0: System wakeup disabled by ACPI
<6>[    0.468035] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
<7>[    0.470184] pci 0000:02:01.0: [8086:3514] type 01 class 0x060400
<7>[    0.473178] pci 0000:02:01.0: PME# supported from D0 D3hot D3cold
<6>[    0.474287] pci 0000:02:01.0: System wakeup disabled by ACPI
<6>[    0.475064] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
<7>[    0.476187] pci 0000:02:02.0: [8086:3518] type 01 class 0x060400
<7>[    0.479826] pci 0000:02:02.0: PME# supported from D0 D3hot D3cold
<6>[    0.480288] pci 0000:02:02.0: System wakeup disabled by ACPI
<6>[    0.481034] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
<6>[    0.482645] pci 0000:01:00.0: PCI bridge to [bus 02-05]
<7>[    0.483003] pci 0000:01:00.0:   bridge window [io  0x2000-0x2fff]
<7>[    0.484003] pci 0000:01:00.0:   bridge window [mem 0xb8000000-0xb88fffff]
<7>[    0.485049] pci 0000:01:00.0:   bridge window [mem 0xb8c00000-0xb8dfffff 64bit pref]
<6>[    0.487275] pci 0000:02:00.0: PCI bridge to [bus 03]
<7>[    0.488141] pci 0000:02:00.0:   bridge window [mem 0xb8c00000-0xb8dfffff 64bit pref]
<6>[    0.490275] pci 0000:02:01.0: PCI bridge to [bus 04]
<7>[    0.492964] pci 0000:05:00.0: [8086:1096] type 00 class 0x020000
<7>[    0.493508] pci 0000:05:00.0: reg 0x10: [mem 0xb8820000-0xb883ffff]
<7>[    0.495230] pci 0000:05:00.0: reg 0x14: [mem 0xb8400000-0xb87fffff]
<7>[    0.496278] pci 0000:05:00.0: reg 0x18: [io  0x2020-0x203f]
<7>[    0.500688] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
<7>[    0.502963] pci 0000:05:00.1: [8086:1096] type 00 class 0x020000
<7>[    0.503508] pci 0000:05:00.1: reg 0x10: [mem 0xb8800000-0xb881ffff]
<7>[    0.505278] pci 0000:05:00.1: reg 0x14: [mem 0xb8000000-0xb83fffff]
<7>[    0.506278] pci 0000:05:00.1: reg 0x18: [io  0x2000-0x201f]
<7>[    0.510688] pci 0000:05:00.1: PME# supported from D0 D3hot D3cold
<6>[    0.512642] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
<6>[    0.514046] pci 0000:02:02.0: PCI bridge to [bus 05]
<7>[    0.515003] pci 0000:02:02.0:   bridge window [io  0x2000-0x2fff]
<7>[    0.516003] pci 0000:02:02.0:   bridge window [mem 0xb8000000-0xb88fffff]
<6>[    0.519917] pci 0000:01:00.3: PCI bridge to [bus 06]
<6>[    0.520401] pci 0000:00:03.0: PCI bridge to [bus 07]
<6>[    0.521040] pci 0000:00:04.0: PCI bridge to [bus 08]
<6>[    0.522037] pci 0000:00:05.0: PCI bridge to [bus 09]
<6>[    0.523198] pci 0000:00:06.0: PCI bridge to [bus 0a]
<6>[    0.525184] pci 0000:00:07.0: PCI bridge to [bus 0b]
<7>[    0.526059] pci 0000:0c:0c.0: [1002:515e] type 00 class 0x030000
<7>[    0.527017] pci 0000:0c:0c.0: reg 0x10: [mem 0xb0000000-0xb7ffffff pref]
<7>[    0.528009] pci 0000:0c:0c.0: reg 0x14: [io  0x1000-0x10ff]
<7>[    0.529010] pci 0000:0c:0c.0: reg 0x18: [mem 0xb8a00000-0xb8a0ffff]
<7>[    0.530031] pci 0000:0c:0c.0: reg 0x30: [mem 0xfffe0000-0xffffffff pref]
<7>[    0.531031] pci 0000:0c:0c.0: supports D1 D2
<6>[    0.532054] pci 0000:00:1e.0: PCI bridge to [bus 0c] (subtractive decode)
<7>[    0.533007] pci 0000:00:1e.0:   bridge window [io  0x1000-0x1fff]
<7>[    0.534003] pci 0000:00:1e.0:   bridge window [mem 0xb8a00000-0xb8afffff]
<7>[    0.535005] pci 0000:00:1e.0:   bridge window [mem 0xb0000000-0xb7ffffff 64bit pref]
<7>[    0.536007] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0ca1] (subtractive decode)
<7>[    0.537001] pci 0000:00:1e.0:   bridge window [io  0x0ca4-0x0cf7] (subtractive decode)
<7>[    0.538001] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
<7>[    0.539002] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
<7>[    0.540001] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000fffff] (subtractive decode)
<7>[    0.541002] pci 0000:00:1e.0:   bridge window [mem 0xb0000000-0xfdffffff] (subtractive decode)
<7>[    0.542001] pci 0000:00:1e.0:   bridge window [mem 0xfe700000-0xfe7003ff] (subtractive decode)
<6>[    0.543361] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 7 10 11) *0, disabled.
<6>[    0.547360] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7 10 11) *0, disabled.
<6>[    0.551347] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 7 10 11) *0, disabled.
<6>[    0.554348] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 10 11) *0, disabled.
<6>[    0.558349] ACPI: PCI Interrupt Link [LNKE] (IRQs 5 7 10 11) *0, disabled.
<6>[    0.562045] ACPI: PCI Interrupt Link [LNKF] (IRQs 5 7 10 11) *0, disabled.
<6>[    0.566348] ACPI: PCI Interrupt Link [LNKG] (IRQs 5 7 10 11) *0, disabled.
<6>[    0.570048] ACPI: PCI Interrupt Link [LNKH] (IRQs 5 7 10 11) *0, disabled.
<7>[    0.574350] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:255)
<4>[    0.575318] ACPI: Enabled 1 GPEs in block 00 to 1F
<6>[    0.576072] vgaarb: setting as boot device: PCI:0000:0c:0c.0
<6>[    0.577000] vgaarb: device added: PCI:0000:0c:0c.0,decodes=io+mem,owns=io+mem,locks=none
<6>[    0.577001] vgaarb: loaded
<6>[    0.578001] vgaarb: bridge control possible 0000:0c:0c.0
<5>[    0.579091] SCSI subsystem initialized
<6>[    0.580034] ACPI: bus type USB registered
<6>[    0.581022] usbcore: registered new interface driver usbfs
<6>[    0.582010] usbcore: registered new interface driver hub
<6>[    0.583053] usbcore: registered new device driver usb
<6>[    0.584026] pps_core: LinuxPPS API ver. 1 registered
<6>[    0.585001] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
<6>[    0.586010] PTP clock support registered
<6>[    0.587084] PCI: Using ACPI for IRQ routing
<7>[    0.593520] PCI: pci_cache_line_size set to 64 bytes
<7>[    0.595063] e820: reserve RAM buffer [mem 0x0009ec00-0x0009ffff]
<7>[    0.596001] e820: reserve RAM buffer [mem 0x9e25a000-0x9fffffff]
<7>[    0.597001] e820: reserve RAM buffer [mem 0x9fa32000-0x9fffffff]
<7>[    0.598001] e820: reserve RAM buffer [mem 0x9faa9000-0x9fffffff]
<7>[    0.599001] e820: reserve RAM buffer [mem 0x9fb25000-0x9fffffff]
<7>[    0.600001] e820: reserve RAM buffer [mem 0x9fc00000-0x9fffffff]
<6>[    0.601120] NetLabel: Initializing
<6>[    0.602001] NetLabel:  domain hash size = 128
<6>[    0.603001] NetLabel:  protocols = UNLABELED CIPSOv4
<6>[    0.604018] NetLabel:  unlabeled traffic allowed by default
<6>[    0.605118] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
<6>[    0.606003] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
<6>[    0.608001] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
<6>[    0.612034] Switched to clocksource hpet
<6>[    0.630789] pnp: PnP ACPI init
<6>[    0.634180] system 00:00: [mem 0xa0000000-0xafffffff] has been reserved
<6>[    0.640910] system 00:00: [mem 0xfed1c000-0xfed1ffff] has been reserved
<6>[    0.647648] system 00:00: [mem 0xffc00000-0xffffffff] could not be reserved
<6>[    0.654727] system 00:00: [mem 0xfec00000-0xfecfffff] could not be reserved
<6>[    0.661802] system 00:00: [mem 0xfee00000-0xfeefffff] has been reserved
<6>[    0.668532] system 00:00: [mem 0xfe600000-0xfe6fffff] has been reserved
<6>[    0.675262] system 00:00: [mem 0xfe000000-0xfe01ffff] has been reserved
<7>[    0.681994] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
<7>[    0.688997] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:255)
<7>[    0.697281] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
<6>[    0.703976] system 00:02: [io  0x0500-0x053f] has been reserved
<6>[    0.710012] system 00:02: [io  0x0400-0x047f] could not be reserved
<6>[    0.716387] system 00:02: [io  0x0800-0x087f] has been reserved
<6>[    0.722417] system 00:02: [io  0x0ca2-0x0ca7] could not be reserved
<6>[    0.728791] system 00:02: [io  0x0ca8-0x0caf] has been reserved
<6>[    0.734818] system 00:02: [io  0x0161] has been reserved
<6>[    0.740242] system 00:02: [io  0x0162] has been reserved
<7>[    0.745664] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
<7>[    0.752682] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:255)
<7>[    0.760997] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
<7>[    0.767756] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:255)
<7>[    0.776067] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
<7>[    0.782717] IOAPIC[0]: Set routing entry (8-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:255)
<7>[    0.791174] pnp 00:05: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
<7>[    0.798601] IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:255)
<7>[    0.806887] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
<7>[    0.814372] pnp 00:07: Plug and Play ACPI device, IDs IPI0001 (active)
<6>[    0.821022] pnp: PnP ACPI: found 8 devices
<6>[    0.831993] pci 0000:0c:0c.0: can't claim BAR 6 [mem 0xfffe0000-0xffffffff pref]: no compatible bridge window
<7>[    0.842232] pci 0000:02:00.0: bridge window [io  0x1000-0x0fff] to [bus 03] add_size 1000
<7>[    0.850585] pci 0000:02:00.0: bridge window [mem 0x00100000-0x000fffff] to [bus 03] add_size 400000
<7>[    0.860399] pci 0000:02:00.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 400000
<7>[    0.869536] pci 0000:02:00.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
<6>[    0.877803] pci 0000:02:00.0: BAR 14: no space for [mem size 0x00400000]
<6>[    0.884618] pci 0000:02:00.0: BAR 14: failed to assign [mem size 0x00400000]
<6>[    0.891780] pci 0000:02:00.0: BAR 13: no space for [io  size 0x1000]
<6>[    0.898243] pci 0000:02:00.0: BAR 13: failed to assign [io  size 0x1000]
<6>[    0.905057] pci 0000:02:00.0: BAR 14: no space for [mem size 0x00400000]
<6>[    0.911864] pci 0000:02:00.0: BAR 14: failed to assign [mem size 0x00400000]
<6>[    0.919019] pci 0000:02:00.0: BAR 13: no space for [io  size 0x1000]
<6>[    0.925489] pci 0000:02:00.0: BAR 13: failed to assign [io  size 0x1000]
<6>[    0.932305] pci 0000:02:00.0: PCI bridge to [bus 03]
<6>[    0.937474] pci 0000:02:00.0:   bridge window [mem 0xb8c00000-0xb8dfffff 64bit pref]
<6>[    0.945439] pci 0000:02:01.0: PCI bridge to [bus 04]
<6>[    0.950705] pci 0000:02:02.0: PCI bridge to [bus 05]
<6>[    0.955780] pci 0000:02:02.0:   bridge window [io  0x2000-0x2fff]
<6>[    0.962038] pci 0000:02:02.0:   bridge window [mem 0xb8000000-0xb88fffff]
<6>[    0.969072] pci 0000:01:00.0: PCI bridge to [bus 02-05]
<6>[    0.974409] pci 0000:01:00.0:   bridge window [io  0x2000-0x2fff]
<6>[    0.980658] pci 0000:01:00.0:   bridge window [mem 0xb8000000-0xb88fffff]
<6>[    0.987559] pci 0000:01:00.0:   bridge window [mem 0xb8c00000-0xb8dfffff 64bit pref]
<6>[    0.995523] pci 0000:01:00.3: PCI bridge to [bus 06]
<6>[    1.000787] pci 0000:00:02.0: PCI bridge to [bus 01-06]
<6>[    1.006130] pci 0000:00:02.0:   bridge window [io  0x2000-0x2fff]
<6>[    1.012333] pci 0000:00:02.0:   bridge window [mem 0xb8000000-0xb89fffff]
<6>[    1.019236] pci 0000:00:02.0:   bridge window [mem 0xb8c00000-0xb8dfffff 64bit pref]
<6>[    1.027154] pci 0000:00:03.0: PCI bridge to [bus 07]
<6>[    1.032233] pci 0000:00:04.0: PCI bridge to [bus 08]
<6>[    1.037317] pci 0000:00:05.0: PCI bridge to [bus 09]
<6>[    1.042403] pci 0000:00:06.0: PCI bridge to [bus 0a]
<6>[    1.047486] pci 0000:00:07.0: PCI bridge to [bus 0b]
<6>[    1.052573] pci 0000:0c:0c.0: BAR 6: assigned [mem 0xb8a20000-0xb8a3ffff pref]
<6>[    1.059974] pci 0000:00:1e.0: PCI bridge to [bus 0c]
<6>[    1.065049] pci 0000:00:1e.0:   bridge window [io  0x1000-0x1fff]
<6>[    1.071253] pci 0000:00:1e.0:   bridge window [mem 0xb8a00000-0xb8afffff]
<6>[    1.078155] pci 0000:00:1e.0:   bridge window [mem 0xb0000000-0xb7ffffff 64bit pref]
<7>[    1.086076] pci_bus 0000:00: resource 4 [io  0x0000-0x0ca1]
<7>[    1.091763] pci_bus 0000:00: resource 5 [io  0x0ca4-0x0cf7]
<7>[    1.097446] pci_bus 0000:00: resource 6 [io  0x0d00-0xffff]
<7>[    1.103127] pci_bus 0000:00: resource 7 [mem 0x000a0000-0x000bffff]
<7>[    1.109502] pci_bus 0000:00: resource 8 [mem 0x000c0000-0x000fffff]
<7>[    1.115885] pci_bus 0000:00: resource 9 [mem 0xb0000000-0xfdffffff]
<7>[    1.122259] pci_bus 0000:00: resource 10 [mem 0xfe700000-0xfe7003ff]
<7>[    1.128722] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
<7>[    1.134406] pci_bus 0000:01: resource 1 [mem 0xb8000000-0xb89fffff]
<7>[    1.140780] pci_bus 0000:01: resource 2 [mem 0xb8c00000-0xb8dfffff 64bit pref]
<7>[    1.148180] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
<7>[    1.153861] pci_bus 0000:02: resource 1 [mem 0xb8000000-0xb88fffff]
<7>[    1.160237] pci_bus 0000:02: resource 2 [mem 0xb8c00000-0xb8dfffff 64bit pref]
<7>[    1.167634] pci_bus 0000:03: resource 2 [mem 0xb8c00000-0xb8dfffff 64bit pref]
<7>[    1.175032] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
<7>[    1.180714] pci_bus 0000:05: resource 1 [mem 0xb8000000-0xb88fffff]
<7>[    1.187091] pci_bus 0000:0c: resource 0 [io  0x1000-0x1fff]
<7>[    1.192772] pci_bus 0000:0c: resource 1 [mem 0xb8a00000-0xb8afffff]
<7>[    1.199146] pci_bus 0000:0c: resource 2 [mem 0xb0000000-0xb7ffffff 64bit pref]
<7>[    1.206544] pci_bus 0000:0c: resource 4 [io  0x0000-0x0ca1]
<7>[    1.212226] pci_bus 0000:0c: resource 5 [io  0x0ca4-0x0cf7]
<7>[    1.217907] pci_bus 0000:0c: resource 6 [io  0x0d00-0xffff]
<7>[    1.223591] pci_bus 0000:0c: resource 7 [mem 0x000a0000-0x000bffff]
<7>[    1.229967] pci_bus 0000:0c: resource 8 [mem 0x000c0000-0x000fffff]
<7>[    1.236341] pci_bus 0000:0c: resource 9 [mem 0xb0000000-0xfdffffff]
<7>[    1.242717] pci_bus 0000:0c: resource 10 [mem 0xfe700000-0xfe7003ff]
<6>[    1.249219] NET: Registered protocol family 2
<6>[    1.253974] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
<6>[    1.261977] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
<6>[    1.269140] TCP: Hash tables configured (established 131072 bind 65536)
<6>[    1.275910] TCP: reno registered
<6>[    1.279277] UDP hash table entries: 8192 (order: 6, 262144 bytes)
<6>[    1.285596] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
<6>[    1.292391] NET: Registered protocol family 1
<6>[    1.297046] RPC: Registered named UNIX socket transport module.
<6>[    1.303082] RPC: Registered udp transport module.
<6>[    1.307902] RPC: Registered tcp transport module.
<6>[    1.312729] RPC: Registered tcp NFSv4.1 backchannel transport module.
<7>[    1.319553] IOAPIC[0]: Set routing entry (8-23 -> 0x41 -> IRQ 23 Mode:1 Active:1 Dest:255)
<7>[    1.328297] IOAPIC[0]: Set routing entry (8-22 -> 0x51 -> IRQ 22 Mode:1 Active:1 Dest:255)
<7>[    1.337032] IOAPIC[0]: Set routing entry (8-23 -> 0x61 -> IRQ 23 Mode:1 Active:1 Dest:255)
<7>[    1.345757] IOAPIC[0]: Set routing entry (8-22 -> 0x71 -> IRQ 22 Mode:1 Active:1 Dest:255)
<7>[    1.354479] IOAPIC[0]: Set routing entry (8-23 -> 0x81 -> IRQ 23 Mode:1 Active:1 Dest:255)
<6>[    1.363083] pci 0000:00:1f.0: rerouting interrupts for [8086:2670]
<7>[    1.369669] pci 0000:0c:0c.0: Video device with shadowed ROM
<7>[    1.375444] PCI: CLS 64 bytes, default 64
<6>[    1.379644] Unpacking initramfs...
<6>[    3.645737] Freeing initrd memory: 124388K (ffff880356687000 - ffff88035e000000)
<6>[    3.653337] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
<6>[    3.659896] software IO TLB [mem 0x9a25a000-0x9e25a000] (64MB) mapped at [ffff88009a25a000-ffff88009e259fff]
<6>[    3.671544] futex hash table entries: 2048 (order: 5, 131072 bytes)
<5>[    3.677996] Initialise system trusted keyring
<6>[    3.682488] audit: initializing netlink subsys (disabled)
<5>[    3.688036] audit: type=2000 audit(3156566885.687:1): initialized
<6>[    3.694620] HugeTLB registered 2 MB page size, pre-allocated 0 pages
<6>[    3.702926] zpool: loaded
<6>[    3.705661] zbud: loaded
<5>[    3.708556] VFS: Disk quotas dquot_6.5.2
<4>[    3.712635] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
<6>[    3.719847] SGI XFS with ACLs, security attributes, no debug enabled
<6>[    3.727020] 9p: Installing v9fs 9p2000 file system support
<6>[    3.732653] msgmni has been set to 24012
<5>[    3.736770] Key type big_key registered
<7>[    3.740720] SELinux:  Registering netfilter hooks
<6>[    3.746991] NET: Registered protocol family 38
<5>[    3.751559] Key type asymmetric registered
<5>[    3.755772] Asymmetric key parser 'x509' registered
<6>[    3.760801] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
<6>[    3.768462] io scheduler noop registered
<6>[    3.772503] io scheduler deadline registered (default)
<6>[    3.777766] io scheduler cfq registered
<7>[    3.782044] IOAPIC[0]: Set routing entry (8-16 -> 0x91 -> IRQ 16 Mode:1 Active:1 Dest:255)
<6>[    3.795151] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
<6>[    3.800848] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
<7>[    3.807621] intel_idle: does not run on family 6 model 23
<6>[    3.813225] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
<6>[    3.821756] ACPI: Power Button [PWRB]
<6>[    3.825583] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
<6>[    3.833158] ACPI: Power Button [PWRF]
<6>[    3.837037] tsc: Marking TSC unstable due to TSC halts in idle
<7>[    3.844580] ACPI: acpi_idle registered with cpuidle
<6>[    3.850872] ERST: Error Record Serialization Table (ERST) support is initialized.
<6>[    3.858575] pstore: Registered erst as persistent store backend
<6>[    3.868255] GHES: APEI firmware first mode is enabled by WHEA _OSC.
<6>[    3.874782] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
<6>[    3.901680] serial 00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
<6>[    3.930318] serial 00:04: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
<6>[    3.938957] Non-volatile memory driver v1.3
<6>[    3.943270] Linux agpgart interface v0.103
<4>[    3.947748] ACPI Warning: SystemIO range 0x0000000000000428-0x000000000000042f conflicts with OpRegion 0x0000000000000400-0x000000000000045f (\PMS0) (20140926/utaddress-258)
<4>[    3.963593] ACPI Warning: SystemIO range 0x0000000000000428-0x000000000000042f conflicts with OpRegion 0x0000000000000428-0x000000000000042f (\_SB_.PCI0.LPC_.ICH1) (20140926/utaddress-258)
<6>[    3.980738] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>[    3.991090] ACPI Warning: SystemIO range 0x0000000000000530-0x000000000000053f conflicts with OpRegion 0x0000000000000500-0x000000000000053b (\_SI_.GPUS) (20140926/utaddress-258)
<4>[    4.007355] ACPI Warning: SystemIO range 0x0000000000000530-0x000000000000053f conflicts with OpRegion 0x0000000000000500-0x000000000000053b (\_SB_.GPUS) (20140926/utaddress-258)
<6>[    4.023624] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>[    4.033975] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x0000000000000500-0x000000000000053b (\_SI_.GPUS) (20140926/utaddress-258)
<4>[    4.050241] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x000000000000052c-0x000000000000052f (\_SB_.PCI0.LPC_.GPIV) (20140926/utaddress-258)
<4>[    4.067374] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x0000000000000500-0x000000000000053b (\_SB_.GPUS) (20140926/utaddress-258)
<6>[    4.083642] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>[    4.093996] lpc_ich: Resource conflict(s) found affecting gpio_ich
<6>[    4.100303] rdac: device handler registered
<6>[    4.104681] hp_sw: device handler registered
<6>[    4.109071] emc: device handler registered
<6>[    4.113277] alua: device handler registered
<6>[    4.117612] libphy: Fixed MDIO Bus: probed
<6>[    4.121864] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
<6>[    4.129027] e1000: Copyright (c) 1999-2006 Intel Corporation.
<6>[    4.134896] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
<6>[    4.140839] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
<7>[    4.147058] IOAPIC[0]: Set routing entry (8-18 -> 0xa1 -> IRQ 18 Mode:1 Active:1 Dest:255)
<6>[    4.157258] e1000e 0000:05:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
<7>[    4.167106] e1000e 0000:05:00.0: irq 24 for MSI/MSI-X
<6>[    4.225670] e1000e 0000:05:00.0 eth0: (PCI Express:2.5GT/s:Width x4) 00:15:17:8c:73:3c
<6>[    4.233774] e1000e 0000:05:00.0 eth0: Intel(R) PRO/1000 Network Connection
<6>[    4.240842] e1000e 0000:05:00.0 eth0: MAC: 5, PHY: 5, PBA No: 400000-000
<7>[    4.247753] IOAPIC[0]: Set routing entry (8-19 -> 0xc1 -> IRQ 19 Mode:1 Active:1 Dest:255)
<6>[    4.257955] e1000e 0000:05:00.1: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
<7>[    4.267809] e1000e 0000:05:00.1: irq 25 for MSI/MSI-X
<6>[    4.327631] e1000e 0000:05:00.1 eth1: (PCI Express:2.5GT/s:Width x4) 00:15:17:8c:73:3d
<6>[    4.335724] e1000e 0000:05:00.1 eth1: Intel(R) PRO/1000 Network Connection
<6>[    4.342787] e1000e 0000:05:00.1 eth1: MAC: 5, PHY: 5, PBA No: 400000-000
<6>[    4.349612] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.2.15-k
<6>[    4.356768] igb: Copyright (c) 2007-2014 Intel Corporation.
<6>[    4.362466] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
<6>[    4.370385] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
<6>[    4.376329] usbcore: registered new interface driver catc
<6>[    4.381848] usbcore: registered new interface driver kaweth
<6>[    4.387532] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
<6>[    4.395108] usbcore: registered new interface driver pegasus
<6>[    4.400886] usbcore: registered new interface driver rtl8150
<6>[    4.406666] usbcore: registered new interface driver asix
<6>[    4.412188] usbcore: registered new interface driver cdc_ether
<6>[    4.418137] usbcore: registered new interface driver cdc_eem
<6>[    4.423920] usbcore: registered new interface driver dm9601
<6>[    4.429619] usbcore: registered new interface driver smsc75xx
<6>[    4.435490] usbcore: registered new interface driver smsc95xx
<6>[    4.441351] usbcore: registered new interface driver gl620a
<6>[    4.447040] usbcore: registered new interface driver net1080
<6>[    4.452823] usbcore: registered new interface driver plusb
<6>[    4.458426] usbcore: registered new interface driver rndis_host
<6>[    4.464465] usbcore: registered new interface driver cdc_subset
<6>[    4.470498] usbcore: registered new interface driver zaurus
<6>[    4.476191] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
<6>[    4.483774] usbcore: registered new interface driver int51x1
<6>[    4.489559] usbcore: registered new interface driver ipheth
<6>[    4.495250] usbcore: registered new interface driver sierra_net
<6>[    4.501347] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
<6>[    4.507989] ehci-pci: EHCI PCI platform driver
<7>[    4.512711] IOAPIC[0]: Set routing entry (8-23 -> 0xe1 -> IRQ 23 Mode:1 Active:1 Dest:255)
<6>[    4.521175] ehci-pci 0000:00:1d.7: EHCI Host Controller
<6>[    4.526564] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 1
<6>[    4.534149] ehci-pci 0000:00:1d.7: debug port 1
<7>[    4.542682] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
<6>[    4.549598] ehci-pci 0000:00:1d.7: irq 23, io mem 0xb8b00400
<6>[    4.561033] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
<6>[    4.566956] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
<6>[    4.573854] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    4.581252] usb usb1: Product: EHCI Host Controller
<6>[    4.586240] usb usb1: Manufacturer: Linux 3.18.0-rc2-wl-ga4fb664 ehci_hcd
<6>[    4.593144] usb usb1: SerialNumber: 0000:00:1d.7
<6>[    4.597992] hub 1-0:1.0: USB hub found
<6>[    4.601866] hub 1-0:1.0: 8 ports detected
<6>[    4.606172] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
<6>[    4.612465] ohci-pci: OHCI PCI platform driver
<6>[    4.617041] uhci_hcd: USB Universal Host Controller Interface driver
<6>[    4.623670] uhci_hcd 0000:00:1d.0: UHCI Host Controller
<6>[    4.629056] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
<6>[    4.636635] uhci_hcd 0000:00:1d.0: detected 2 ports
<6>[    4.641645] uhci_hcd 0000:00:1d.0: irq 23, io base 0x000030a0
<6>[    4.647545] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
<6>[    4.654442] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    4.661839] usb usb2: Product: UHCI Host Controller
<6>[    4.666830] usb usb2: Manufacturer: Linux 3.18.0-rc2-wl-ga4fb664 uhci_hcd
<6>[    4.673734] usb usb2: SerialNumber: 0000:00:1d.0
<6>[    4.678566] hub 2-0:1.0: USB hub found
<6>[    4.682441] hub 2-0:1.0: 2 ports detected
<7>[    4.686797] IOAPIC[0]: Set routing entry (8-22 -> 0x22 -> IRQ 22 Mode:1 Active:1 Dest:255)
<6>[    4.695244] uhci_hcd 0000:00:1d.1: UHCI Host Controller
<6>[    4.700632] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
<6>[    4.708235] uhci_hcd 0000:00:1d.1: detected 2 ports
<6>[    4.713272] uhci_hcd 0000:00:1d.1: irq 22, io base 0x00003080
<6>[    4.719173] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
<6>[    4.726074] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    4.733471] usb usb3: Product: UHCI Host Controller
<6>[    4.738462] usb usb3: Manufacturer: Linux 3.18.0-rc2-wl-ga4fb664 uhci_hcd
<6>[    4.745364] usb usb3: SerialNumber: 0000:00:1d.1
<6>[    4.750191] hub 3-0:1.0: USB hub found
<6>[    4.754058] hub 3-0:1.0: 2 ports detected
<6>[    4.758413] uhci_hcd 0000:00:1d.2: UHCI Host Controller
<6>[    4.763805] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
<6>[    4.771386] uhci_hcd 0000:00:1d.2: detected 2 ports
<6>[    4.776393] uhci_hcd 0000:00:1d.2: irq 23, io base 0x00003060
<6>[    4.782291] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
<6>[    4.789192] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    4.796587] usb usb4: Product: UHCI Host Controller
<6>[    4.801578] usb usb4: Manufacturer: Linux 3.18.0-rc2-wl-ga4fb664 uhci_hcd
<6>[    4.808475] usb usb4: SerialNumber: 0000:00:1d.2
<6>[    4.813304] hub 4-0:1.0: USB hub found
<6>[    4.817181] hub 4-0:1.0: 2 ports detected
<6>[    4.821530] uhci_hcd 0000:00:1d.3: UHCI Host Controller
<6>[    4.826917] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
<6>[    4.834492] uhci_hcd 0000:00:1d.3: detected 2 ports
<6>[    4.839498] uhci_hcd 0000:00:1d.3: irq 22, io base 0x00003040
<6>[    4.845395] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
<6>[    4.852296] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    4.859690] usb usb5: Product: UHCI Host Controller
<6>[    4.864679] usb usb5: Manufacturer: Linux 3.18.0-rc2-wl-ga4fb664 uhci_hcd
<6>[    4.871573] usb usb5: SerialNumber: 0000:00:1d.3
<6>[    4.876399] hub 5-0:1.0: USB hub found
<6>[    4.880267] hub 5-0:1.0: 2 ports detected
<6>[    4.884524] usbcore: registered new interface driver usbserial
<6>[    4.890482] usbcore: registered new interface driver usbserial_generic
<6>[    4.897128] usbserial: USB Serial support registered for generic
<6>[    4.903283] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
<6>[    4.914241] serio: i8042 KBD port at 0x60,0x64 irq 1
<6>[    4.919341] serio: i8042 AUX port at 0x60,0x64 irq 12
<6>[    4.924655] mousedev: PS/2 mouse device common for all mice
<6>[    4.930588] rtc_cmos 00:01: RTC can wake from S4
<6>[    4.937077] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
<6>[    4.943312] rtc_cmos 00:01: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
<6>[    4.951172] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
<6>[    4.956891] iTCO_wdt: Found a 631xESB/632xESB TCO device (Version=2, TCOBASE=0x0460)
<6>[    4.964907] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
<6>[    4.971038] iTCO_vendor_support: vendor-support=0
<6>[    4.976521] hidraw: raw HID events driver (C) Jiri Kosina
<6>[    4.982146] usbcore: registered new interface driver usbhid
<6>[    4.987838] usbhid: USB HID core driver
<6>[    4.991845] drop_monitor: Initializing network drop monitor service
<6>[    4.998297] TCP: cubic registered
<6>[    5.001740] Initializing XFRM netlink socket
<6>[    5.006269] NET: Registered protocol family 10
<6>[    5.011197] NET: Registered protocol family 17
<6>[    5.015774] 9pnet: Installing 9P2000 support
<7>[    5.020507] 
<7>[    5.020507] printing PIC contents
<7>[    5.025480] ... PIC  IMR: ffff
<7>[    5.026475] ... PIC  IRR: 0c21
<7>[    5.031812] ... PIC  ISR: 0000
<7>[    5.034978] ... PIC ELCR: 0c20
<7>[    5.038163] printing local APIC contents on CPU#0/0:
<6>[    5.039161] ... APIC ID:      00000000 (0)
<6>[    5.039161] ... APIC VERSION: 00050014
<7>[    5.039161] ... APIC TASKPRI: 00000000 (00)
<7>[    5.039161] ... APIC PROCPRI: 00000000
<7>[    5.039161] ... APIC LDR: 01000000
<7>[    5.039161] ... APIC DFR: ffffffff
<7>[    5.039161] ... APIC SPIV: 000001ff
<7>[    5.039161] ... APIC ISR field:
<4>[    5.039161] 0000000000000000000000000000000000000000000000000000000000000000
<7>[    5.039161] ... APIC TMR field:
<4>[    5.039161] 0000000000000000000000000000000200020002000000020002000000000000
<7>[    5.039161] ... APIC IRR field:
<4>[    5.039161] 0000000000000000000000000000000000000000000000000000000020000000
<7>[    5.039161] ... APIC ESR: 00000000
<7>[    5.039161] ... APIC ICR: 000008fd
<7>[    5.039161] ... APIC ICR2: 02000000
<7>[    5.039161] ... APIC LVTT: 000000ef
<7>[    5.039161] ... APIC LVTPC: 00000400
<7>[    5.039161] ... APIC LVT0: 00010700
<7>[    5.039161] ... APIC LVT1: 00000400
<7>[    5.039161] ... APIC LVTERR: 000000fe
<7>[    5.039161] ... APIC TMICT: 002a1f67
<7>[    5.039161] ... APIC TMCCT: 000b570b
<7>[    5.039161] ... APIC TDCR: 00000003
<4>[    5.039161] 
<7>[    5.144118] number of MP IRQ sources: 15.
<7>[    5.148245] number of IO-APIC #8 registers: 24.
<7>[    5.152904] number of IO-APIC #9 registers: 24.
<6>[    5.157556] testing the IO APIC.......................
<7>[    5.162834] IO APIC #8......
<7>[    5.165839] .... register #00: 08000000
<7>[    5.169800] .......    : physical APIC id: 08
<7>[    5.174285] .......    : Delivery Type: 0
<7>[    5.178421] .......    : LTS          : 0
<7>[    5.182560] .... register #01: 00170020
<7>[    5.186516] .......     : max redirection entries: 17
<7>[    5.191688] .......     : PRQ implemented: 0
<7>[    5.196084] .......     : IO APIC version: 20
<7>[    5.200568] .... IRQ redirection table:
<4>[    5.204535] 1    0    0   0   0    0    0    00
<4>[    5.209196] 0    0    0   0   0    1    1    31
<4>[    5.213853] 0    0    0   0   0    1    1    30
<4>[    5.218506] 0    0    0   0   0    1    1    33
<4>[    5.223167] 0    0    0   0   0    1    1    34
<4>[    5.227829] 0    0    0   0   0    1    1    35
<4>[    5.232490] 0    0    0   0   0    1    1    36
<4>[    5.237149] 0    0    0   0   0    1    1    37
<4>[    5.241804] 0    0    0   0   0    1    1    38
<4>[    5.246463] 0    1    0   0   0    1    1    39
<4>[    5.251119] 0    0    0   0   0    1    1    3A
<4>[    5.255774] 0    0    0   0   0    1    1    3B
<4>[    5.260429] 0    0    0   0   0    1    1    3C
<4>[    5.265087] 0    0    0   0   0    1    1    3D
<4>[    5.269744] 0    0    0   0   0    1    1    3E
<4>[    5.274404] 0    0    0   0   0    1    1    3F
<4>[    5.279063] 1    1    0   1   0    1    1    91
<4>[    5.283726] 1    0    0   0   0    0    0    00
<4>[    5.288383] 1    1    0   1   0    1    1    A1
<4>[    5.293043] 1    1    0   1   0    1    1    C1
<4>[    5.297702] 1    0    0   0   0    0    0    00
<4>[    5.302356] 1    0    0   0   0    0    0    00
<4>[    5.307016] 0    1    0   1   0    1    1    22
<4>[    5.311676] 0    1    0   1   0    1    1    E1
<7>[    5.316336] IO APIC #9......
<7>[    5.319333] .... register #00: 09000000
<7>[    5.323294] .......    : physical APIC id: 09
<7>[    5.327780] .......    : Delivery Type: 0
<7>[    5.331915] .......    : LTS          : 0
<7>[    5.336053] .... register #01: 00178020
<7>[    5.340014] .......     : max redirection entries: 17
<7>[    5.345192] .......     : PRQ implemented: 1
<7>[    5.349589] .......     : IO APIC version: 20
<7>[    5.354074] .... register #02: 09000000
<7>[    5.358034] .......     : arbitration: 09
<7>[    5.362167] .... register #03: 00000001
<7>[    5.366123] .......     : Boot DT    : 1
<7>[    5.370169] .... IRQ redirection table:
<4>[    5.374128] 1    0    0   0   0    0    0    00
<4>[    5.378785] 1    0    0   0   0    0    0    00
<4>[    5.383446] 1    0    0   0   0    0    0    00
<4>[    5.388099] 1    0    0   0   0    0    0    00
<4>[    5.392760] 1    0    0   0   0    0    0    00
<4>[    5.397421] 1    0    0   0   0    0    0    00
<4>[    5.402084] 1    0    0   0   0    0    0    00
<4>[    5.406733] 1    0    0   0   0    0    0    00
<4>[    5.411392] 1    0    0   0   0    0    0    00
<4>[    5.416047] 1    0    0   0   0    0    0    00
<4>[    5.420705] 1    0    0   0   0    0    0    00
<4>[    5.425359] 1    0    0   0   0    0    0    00
<4>[    5.430018] 1    0    0   0   0    0    0    00
<4>[    5.434678] 1    0    0   0   0    0    0    00
<4>[    5.439337] 1    0    0   0   0    0    0    00
<4>[    5.443999] 1    0    0   0   0    0    0    00
<4>[    5.448660] 1    0    0   0   0    0    0    00
<4>[    5.453317] 1    0    0   0   0    0    0    00
<4>[    5.457971] 1    0    0   0   0    0    0    00
<4>[    5.462628] 1    0    0   0   0    0    0    00
<4>[    5.467283] 1    0    0   0   0    0    0    00
<4>[    5.471942] 1    0    0   0   0    0    0    00
<4>[    5.476601] 1    0    0   0   0    0    0    00
<4>[    5.481264] 1    0    0   0   0    0    0    00
<7>[    5.485923] IRQ to pin mappings:
<7>[    5.489282] IRQ0 -> 0:2
<7>[    5.491981] IRQ1 -> 0:1
<7>[    5.494682] IRQ3 -> 0:3
<7>[    5.497387] IRQ4 -> 0:4
<7>[    5.500093] IRQ5 -> 0:5
<7>[    5.502790] IRQ6 -> 0:6
<7>[    5.505494] IRQ7 -> 0:7
<7>[    5.508194] IRQ8 -> 0:8
<7>[    5.510891] IRQ9 -> 0:9
<7>[    5.513594] IRQ10 -> 0:10
<7>[    5.516463] IRQ11 -> 0:11
<7>[    5.519346] IRQ12 -> 0:12
<7>[    5.522219] IRQ13 -> 0:13
<7>[    5.525086] IRQ14 -> 0:14
<7>[    5.527958] IRQ15 -> 0:15
<7>[    5.530833] IRQ16 -> 0:16
<7>[    5.533709] IRQ18 -> 0:18
<7>[    5.536594] IRQ19 -> 0:19
<7>[    5.539461] IRQ22 -> 0:22
<7>[    5.542339] IRQ23 -> 0:23
<6>[    5.545203] .................................... done.
<5>[    5.550618] Loading compiled-in X.509 certificates
<5>[    5.556487] Loaded X.509 cert 'Magrathea: Glacier signing key: 655fb4d5d7cebbf515cdb1c11f96c46ead2df1e4'
<6>[    5.566161] registered taskstats version 1
<5>[    5.572407] Key type trusted registered
<5>[    5.577814] Key type encrypted registered
<6>[    5.583405] ima: No TPM chip found, activating TPM-bypass!
<6>[    5.589047] evm: HMAC attrs: 0x1
<6>[    5.595044] rtc_cmos 00:01: setting system clock to 1970-01-10 08:08:11 UTC (806891)
<7>[    5.628862] e1000e 0000:05:00.0: irq 24 for MSI/MSI-X
<7>[    5.735584] e1000e 0000:05:00.0: irq 24 for MSI/MSI-X
<6>[    5.741735] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
<7>[    5.773664] e1000e 0000:05:00.1: irq 25 for MSI/MSI-X
<7>[    5.880585] e1000e 0000:05:00.1: irq 25 for MSI/MSI-X
<6>[    5.886735] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>[    8.163567] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
<6>[    8.172052] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<5>[    8.183028] Sending DHCP requests ..
<5>[   13.335038] random: nonblocking pool is initialized
<4>[   15.744025] ., OK
<4>[   15.782075] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.35
<6>[   15.838832] e1000e: eth1 NIC Link is Down
<6>[   15.843109] IP-Config: Complete:
<6>[   15.846449]      device=eth0, hwaddr=00:15:17:8c:73:3c, ipaddr=192.168.1.35, mask=255.255.255.0, gw=192.168.1.1
<6>[   15.856712]      host=client5, domain=lkp.intel.com, nis-domain=(none)
<6>[   15.863353]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
<6>[   15.870099]      nameserver0=192.168.1

--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--5mCyUwZo2JvN/JJP--
