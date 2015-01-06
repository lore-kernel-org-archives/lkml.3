Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbbAFGkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 01:40:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbbAFGj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 01:39:58 -0500
Date: Tue, 6 Jan 2015 14:37:18 +0800
From: Baoquan He <bhe@redhat.com>
To: "Li, Zhen-Hua" <zhen-hual@hp.com>
Cc: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, joro@8bytes.org,
        vgoyal@redhat.com, dyoung@redhat.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kexec@lists.infradead.org, alex.williamson@redhat.com,
        ddutile@redhat.com, ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com,
        doug.hatch@hp.com, jerry.hoemann@hp.com, tom.vaden@hp.com,
        li.zhang6@hp.com, lisa.mitchell@hp.com, billsumnerlinux@gmail.com
Subject: Re: [PATCH 0/10] iommu/vt-d: Fix intel vt-d faults in kdump kernel
Message-ID: <20150106063718.GA2454@dhcp-16-105.nay.redhat.com>
References: <1419239729-26529-1-git-send-email-zhen-hual@hp.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <1419239729-26529-1-git-send-email-zhen-hual@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Zhenhua,

I just tested your patchset based on 3.19.0-rc2+, and found several dmar
fault and intr-remap fault, it seems not the same as Takao's, please
check the attachment.

Thanks
Baoquan


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iommu.log"


[root@dhcp-16-105 ~]# kdumpctl restart
kexec: failed to unloaded kdump kernel
Stopping kdump: [FAILED]
+ /sbin/kexec -p '--command-line=BOOT_IMAGE=/vmlinuz-3.19.0-rc2+ root=UUID=f170152e-de83-46ee-9546-8ccd53f9753b ro rd.md=0 rd.lvm=0 rd.dm=0 vconsole.keymap=us rd.luk+
+ set +x
kexec: loaded kdump kernel
Starting kdump: [OK]
[root@dhcp-16-105 ~]# echo c >/proc/sysrq-trigger 
[  722.444549] SysRq : Trigger a crash
[  722.448133] BUG: unable to handle kernel NULL pointer dereference at           (null)
[  722.456044] IP: [<ffffffff8145a3d6>] sysrq_handle_crash+0x16/0x20
[  722.462179] PGD 404720067 PUD 41afd6067 PMD 0 
[  722.466719] Oops: 0002 [#1] SMP 
[  722.469999] Modules linked in: fuse ipt_MASQUERADE nf_nat_masquerade_ipv4 xt_CHECKSUM tun ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 cfg80211 xt_conntrack ebtable_nc
[  722.570165] CPU: 0 PID: 1979 Comm: bash Not tainted 3.19.0-rc2+ #93
[  722.576453] Hardware name: Hewlett-Packard HP Z420 Workstation/1589, BIOS J61 v01.02 03/09/2012
[  722.585176] task: ffff88041d6a9b60 ti: ffff88040882c000 task.ti: ffff88040882c000
[  722.592699] RIP: 0010:[<ffffffff8145a3d6>]  [<ffffffff8145a3d6>] sysrq_handle_crash+0x16/0x20
[  722.601292] RSP: 0018:ffff88040882fe58  EFLAGS: 00010246
[  722.606618] RAX: 000000000000000f RBX: ffffffff81cafdc0 RCX: 0000000000000000
[  722.613776] RDX: 0000000000000000 RSI: ffff88042fc0e6f8 RDI: 0000000000000063
[  722.620932] RBP: ffff88040882fe58 R08: 00000000000000c2 R09: ffffffff81eec85c
[  722.628098] R10: 000000000000040f R11: 000000000000040e R12: 0000000000000063
[  722.635249] R13: 0000000000000000 R14: 0000000000000007 R15: 0000000000000000
[  722.642415] FS:  00007f0cca07b740(0000) GS:ffff88042fc00000(0000) knlGS:0000000000000000
[  722.650529] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  722.656294] CR2: 0000000000000000 CR3: 00000004095e4000 CR4: 00000000000407f0
[  722.663444] Stack:
[  722.665471]  ffff88040882fe88 ffffffff8145abc7 0000000000000002 00007f0cca092000
[  722.672960]  0000000000000002 ffff88040882ff48 ffff88040882fea8 ffffffff8145b073
[  722.680440]  0000000000000001 ffff8803ee48b300 ffff88040882fed8 ffffffff8126ebcd
[  722.687927] Call Trace:
[  722.690390]  [<ffffffff8145abc7>] __handle_sysrq+0x107/0x170
[  722.696079]  [<ffffffff8145b073>] write_sysrq_trigger+0x33/0x40
[  722.702029]  [<ffffffff8126ebcd>] proc_reg_write+0x3d/0x80
[  722.707536]  [<ffffffff81205a47>] vfs_write+0xb7/0x1f0
[  722.712697]  [<ffffffff810227ec>] ? do_audit_syscall_entry+0x6c/0x70
[  722.719084]  [<ffffffff812066c5>] SyS_write+0x55/0xd0
[  722.724159]  [<ffffffff81747069>] system_call_fastpath+0x12/0x17
[  722.730176] Code: c1 f7 ff ff eb db 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 66 66 66 66 90 55 c7 05 b4 e9 a8 00 01 00 00 00 48 89 e5 0f ae f8 <c6> 04 25 00 0 
[  722.750274] RIP  [<ffffffff8145a3d6>] sysrq_handle_crash+0x16/0x20
[  722.756509]  RSP <ffff88040882fe58>
[  722.760023] CR2: 0000000000000000
h
 [    0.000000] ERROR: earlyprintk= earlyser already used
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Hewlett-Packard HP Z420 Workstation/1589, BIOS J61 v01.02 03/09/2012
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x38000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DBFFF write-protect
[    0.000000]   DC000-E9FFF uncachable
[    0.000000]   EA000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000CC000000 mask 3FFFFC000000 uncachable
[    0.000000]   1 base 0000D0000000 mask 3FFFF0000000 uncachable
[    0.000000]   2 base 0000E0000000 mask 3FFFE0000000 uncachable
[    0.000000]   3 base 000430000000 mask 3FFFF0000000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] PAT configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- UC  
[    0.000000] x2apic enabled by BIOS, switching to x2apic ops
[    0.000000] found SMP MP-table at [mem 0x000f4bc0-0x000f4bcf] mapped at [ffff8800000f4bc0]
[    0.000000] Base memory trampoline at [ffff880000090000] 90000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x36ffa000, 0x36ffafff] PGTABLE
[    0.000000] BRK [0x36ffb000, 0x36ffbfff] PGTABLE
[    0.000000] BRK [0x36ffc000, 0x36ffcfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x37c00000-0x37dfffff]
[    0.000000]  [mem 0x37c00000-0x37dfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x34000000-0x37bfffff]
[    0.000000]  [mem 0x34000000-0x37bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x28000000-0x33ffffff]
[    0.000000]  [mem 0x28000000-0x33ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x37e00000-0x37f65fff]
[    0.000000]  [mem 0x37e00000-0x37f65fff] page 4k
[    0.000000] BRK [0x36ffd000, 0x36ffdfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x32c65000-0x35ffffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F9810 000024 (v02 HPQOEM)
[    0.000000] ACPI: XSDT 0x00000000CBA28078 00006C (v01 HPQOEM SLIC-WKS 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000CBA304C8 0000F4 (v04 HPQOEM SLIC-WKS 01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x00000000CBA28170 008352 (v02 HPQOEM SLIC-WKS 00000102 INTL 20051117)
[    0.000000] ACPI: FACS 0x00000000CBB5BF80 000040
[    0.000000] ACPI: APIC 0x00000000CBA305C0 00007E (v03 HPQOEM SLIC-WKS 01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x00000000CBA30640 00003C (v01 HPQOEM OEMMCFG. 01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000CBA30680 000038 (v01 HPQOEM SLIC-WKS 01072009 AMI. 00000004)
[    0.000000] ACPI: ASF! 0x00000000CBA306B8 0000A0 (v32 INTEL   HCG     00000001 TFSM 000F4240)
[    0.000000] ACPI: SSDT 0x00000000CBA30758 0058DA (v01 COMPAQ WMI      00000001 MSFT 03000001)
[    0.000000] ACPI: SLIC 0x00000000CBA36038 000176 (v01 HPQOEM SLIC-WKS 00000001      00000000)
[    0.000000] ACPI: SSDT 0x00000000CBA361B0 06E284 (v02 INTEL  CpuPm    00004000 INTL 20051117)
[    0.000000] ACPI: DMAR 0x00000000CBAA4438 0000A0 (v01 A M I  OEMDMAR  00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Setting APIC routing to cluster x2apic.
[    0.000000] NUMA turned off
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000037ffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x37f52000-0x37f65fff]
[    0.000000]  [ffffea0000000000-ffffea0000dfffff] PMD -> [ffff880037000000-ffff8800375fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0x37ffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00095fff]
[    0.000000]   node   0: [mem 0x28000000-0x37f65fff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x37f65fff]
[    0.000000] On node 0 totalpages: 65531
[    0.000000]   DMA zone: 3 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 149 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1022 pages used for memmap
[    0.000000]   DMA32 zone: 65382 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1/0x2 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 2/0x4 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 3/0x6 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 2, version 32, address 0xfec01000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: 4 Processors exceeds NR_CPUS limit of 1
[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x00096000-0x00096fff]
[    0.000000] PM: Registered nosave memory: [mem 0x00097000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x00100000-0x27ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x37f66000-0x37ffffff]
[    0.000000] e820: [mem 0x38000000-0xcb74ffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 31 pages/cpu @ffff880037c00000 s87168 r8192 d31616 u2097152
[    0.000000] pcpu-alloc: s87168 r8192 d31616 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 64485
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.19.0-rc2+ root=UUID=f170152e-de83-46ee-9546-8ccd53f9753b ro rd.md=0 rd.lvm=0 rd.dm=0 vconsole.keymap=us rd.K
[    0.000000] Intel-IOMMU: enabled
[    0.000000] Misrouted IRQ fixup and polling support enabled
[    0.000000] This may significantly impact system performance
[    0.000000] Disabling memory control group subsystem
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
[    0.000000] Memory: 186236K/262124K available (7472K kernel code, 1128K rwdata, 3196K rodata, 1464K init, 1436K bss, 75888K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=1.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=1
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] Spurious LAPIC timer interrupt on cpu 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2793.395 MHz processor
[    0.000062] Calibrating delay loop (skipped), value calculated using timer frequency.. 5586.79 BogoMIPS (lpj=2793395)
[    0.010727] pid_max: default: 32768 minimum: 301
[    0.015366] ACPI: Core revision 20141107
[    0.072637] ACPI: All ACPI Tables successfully acquired
[    0.077975] Security Framework initialized
[    0.082099] SELinux:  Initializing.
[    0.085612] SELinux:  Starting in permissive mode
[    0.090415] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.097498] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.104440] Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
[    0.110984] Mountpoint-cache hash table entries: 512 (order: 0, 4096 bytes)
[    0.118250] Initializing cgroup subsys memory
[    0.122628] Initializing cgroup subsys devices
[    0.127089] Initializing cgroup subsys freezer
[    0.131551] Initializing cgroup subsys net_cls
[    0.136009] Initializing cgroup subsys blkio
[    0.140285] Initializing cgroup subsys perf_event
[    0.144995] Initializing cgroup subsys hugetlb
[    0.149495] CPU: Physical Processor ID: 0
[    0.153520] CPU: Processor Core ID: 0
[    0.157211] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
[    0.157211] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.180149] Freeing SMP alternatives memory: 28K (ffffffff81e8a000 - ffffffff81e91000)
[    0.190750] ftrace: allocating 27288 entries in 107 pages
[    0.221595] dmar: Host address width 46
[    0.225443] dmar: DRHD base: 0x000000dfffc000 flags: 0x1
[    0.230791] dmar: IOMMU 0: reg_base_addr dfffc000 ver 1:0 cap d2078c106f0462 ecap f020fe
[    0.238903] dmar: RMRR base: 0x000000cba11000 end: 0x000000cba27fff
[    0.245193] dmar: ATSR flags: 0x0
[    0.248623] IOAPIC id 0 under DRHD base  0xdfffc000 IOMMU 0
[    0.254211] IOAPIC id 2 under DRHD base  0xdfffc000 IOMMU 0
[    0.259804] HPET id 0 under DRHD base 0xdfffc000
[    0.264440] Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.272697] Enabled IRQ remapping in x2apic mode
[    0.277920] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.293984] smpboot: CPU0: Intel(R) Xeon(R) CPU E5-1603 0 @ 2.80GHz (fam: 06, model: 2d, stepping: 07)
[    0.303410] TSC deadline timer enabled
[    0.307209] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, full-width counters, Broken BIOS detected, complain to your hardware vendor.
[    0.321134] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR 38d is b0)
[    0.328812] Intel PMU driver.
[    0.331801] ... version:                3
[    0.335826] ... bit width:              48
[    0.339936] ... generic registers:      8
[    0.343965] ... value mask:             0000ffffffffffff
[    0.349298] ... max period:             0000ffffffffffff
[    0.354629] ... fixed-purpose events:   3
[    0.358657] ... event mask:             00000007000000ff
[    0.365034] x86: Booted up 1 node, 1 CPUs
[    0.369065] smpboot: Total of 1 processors activated (5586.79 BogoMIPS)
[    0.375727] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.386634] devtmpfs: initialized
[    0.394369] PM: Registering ACPI NVS region [mem 0xcb750000-0xcb7dafff] (569344 bytes)
[    0.402333] PM: Registering ACPI NVS region [mem 0xcbaad000-0xcbaaefff] (8192 bytes)
[    0.410103] PM: Registering ACPI NVS region [mem 0xcbabb000-0xcbacdfff] (77824 bytes)
[    0.417956] PM: Registering ACPI NVS region [mem 0xcbb56000-0xcbb5dfff] (32768 bytes)
[    0.425811] PM: Registering ACPI NVS region [mem 0xcbb71000-0xcbffffff] (4780032 bytes)
[    0.434188] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.441185] pinctrl core: initialized pinctrl subsystem
[    0.446481] RTC time:  6:11:52, date: 01/06/15
[    0.451115] NET: Registered protocol family 16
[    0.455937] cpuidle: using governor menu
[    0.460114] ACPI: bus type PCI registered
[    0.464147] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.470735] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.480070] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.487473] PCI: Using configuration type 1 for base access
[    0.495477] ACPI: Added _OSI(Module Device)
[    0.499682] ACPI: Added _OSI(Processor Device)
[    0.504143] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.508863] ACPI: Added _OSI(Processor Aggregator Device)
[    0.526781] ACPI: Executed 1 blocks of module-level executable AML code
[    0.649090] ACPI: Interpreter enabled
[    0.652776] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20141107/hwxface-580)
[    0.662072] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20141107/hwxface-580)
[    0.671386] ACPI: (supports S0 S3 S4 S5)
[    0.675328] ACPI: Using IOAPIC for interrupt routing
[    0.680361] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.690950] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.712237] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7f])
[    0.718448] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.726873] acpi PNP0A08:00: _OSC: platform does not support [PCIeCapability]
[    0.734139] acpi PNP0A08:00: _OSC: not requesting control; platform does not support [PCIeCapability]
[    0.743387] acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug PME AER PCIeCapability]
[    0.751155] acpi PNP0A08:00: _OSC: platform willing to grant [PCIeHotplug PME AER]
[    0.758747] acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
[    0.766045] PCI host bridge to bus 0000:00
[    0.770164] pci_bus 0000:00: root bus resource [bus 00-7f]
[    0.775675] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
[    0.781875] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
[    0.788077] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df]
[    0.794277] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.800479] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.807376] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    0.814271] pci_bus 0000:00: root bus resource [mem 0xd4000000-0xdfffffff]
[    0.821170] pci_bus 0000:00: root bus resource [mem 0x3c0000000000-0x3c007fffffff]
[    0.828779] pci 0000:00:00.0: [8086:3c00] type 00 class 0x060000
[    0.834900] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.841139] pci 0000:00:01.0: [8086:3c02] type 01 class 0x060400
[    0.847265] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.853447] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.859199] pci 0000:00:02.0: [8086:3c04] type 01 class 0x060400
[    0.865321] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.871492] pci 0000:00:02.0: System wakeup disabled by ACPI
[    0.877244] pci 0000:00:03.0: [8086:3c08] type 01 class 0x060400
[    0.883370] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.889541] pci 0000:00:03.0: System wakeup disabled by ACPI
[    0.895288] pci 0000:00:05.0: [8086:3c28] type 00 class 0x088000
[    0.901487] pci 0000:00:05.2: [8086:3c2a] type 00 class 0x088000
[    0.907671] pci 0000:00:05.4: [8086:3c2c] type 00 class 0x080020
[    0.913717] pci 0000:00:05.4: reg 0x10: [mem 0xd7346000-0xd7346fff]
[    0.920174] pci 0000:00:11.0: [8086:1d3e] type 01 class 0x060400
[    0.926327] pci 0000:00:11.0: PME# supported from D0 D3hot D3cold
[    0.932554] pci 0000:00:16.0: [8086:1d3a] type 00 class 0x078000
[    0.938604] pci 0000:00:16.0: reg 0x10: [mem 0xd7345000-0xd734500f 64bit]
[    0.945506] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.951731] pci 0000:00:16.2: [8086:1d3c] type 00 class 0x010185
[    0.957778] pci 0000:00:16.2: reg 0x10: [io  0xf0b0-0xf0b7]
[    0.963382] pci 0000:00:16.2: reg 0x14: [io  0xf0a0-0xf0a3]
[    0.968983] pci 0000:00:16.2: reg 0x18: [io  0xf090-0xf097]
[    0.974588] pci 0000:00:16.2: reg 0x1c: [io  0xf080-0xf083]
[    0.980191] pci 0000:00:16.2: reg 0x20: [io  0xf070-0xf07f]
[    0.985943] pci 0000:00:16.3: [8086:1d3d] type 00 class 0x070002
[    0.991997] pci 0000:00:16.3: reg 0x10: [io  0xf060-0xf067]
[    0.997605] pci 0000:00:16.3: reg 0x14: [mem 0xd7344000-0xd7344fff]
[    1.004085] pci 0000:00:19.0: [8086:1502] type 00 class 0x020000
[    1.010136] pci 0000:00:19.0: reg 0x10: [mem 0xd7300000-0xd731ffff]
[    1.016435] pci 0000:00:19.0: reg 0x14: [mem 0xd7349000-0xd7349fff]
[    1.022731] pci 0000:00:19.0: reg 0x18: [io  0xf040-0xf05f]
[    1.028404] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    1.034570] pci 0000:00:19.0: System wakeup disabled by ACPI
[    1.040316] pci 0000:00:1a.0: [8086:1d2d] type 00 class 0x0c0320
[    1.046371] pci 0000:00:1a.0: reg 0x10: [mem 0xd734b000-0xd734b3ff]
[    1.052772] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    1.058943] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    1.064683] pci 0000:00:1b.0: [8086:1d20] type 00 class 0x040300
[    1.070728] pci 0000:00:1b.0: reg 0x10: [mem 0xd7340000-0xd7343fff 64bit]
[    1.077630] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.083856] pci 0000:00:1c.0: [8086:1d12] type 01 class 0x060400
[    1.089991] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.096138] pci 0000:00:1c.0: Enabling MPC IRBNCE
[    1.100860] pci 0000:00:1c.0: Intel PCH root port ACS workaround enabled
[    1.107622] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    1.113376] pci 0000:00:1c.5: [8086:1d18] type 01 class 0x060400
[    1.119547] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    1.125692] pci 0000:00:1c.5: Enabling MPC IRBNCE
[    1.130417] pci 0000:00:1c.5: Intel PCH root port ACS workaround enabled
[    1.137181] pci 0000:00:1c.5: System wakeup disabled by ACPI
[    1.142923] pci 0000:00:1c.6: [8086:1d14] type 01 class 0x060400
[    1.149052] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    1.155194] pci 0000:00:1c.6: Enabling MPC IRBNCE
[    1.159917] pci 0000:00:1c.6: Intel PCH root port ACS workaround enabled
[    1.166684] pci 0000:00:1c.6: System wakeup disabled by ACPI
[    1.172422] pci 0000:00:1c.7: [8086:1d16] type 01 class 0x060400
[    1.178553] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    1.184695] pci 0000:00:1c.7: Enabling MPC IRBNCE
[    1.189419] pci 0000:00:1c.7: Intel PCH root port ACS workaround enabled
[    1.196185] pci 0000:00:1c.7: System wakeup disabled by ACPI
[    1.201926] pci 0000:00:1d.0: [8086:1d26] type 00 class 0x0c0320
[    1.207974] pci 0000:00:1d.0: reg 0x10: [mem 0xd734a000-0xd734a3ff]
[    1.214374] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    1.220544] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    1.226281] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    1.232419] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    1.238160] pci 0000:00:1f.0: [8086:1d41] type 00 class 0x060100
[    1.244409] pci 0000:00:1f.2: [8086:2826] type 00 class 0x010400
[    1.250461] pci 0000:00:1f.2: reg 0x10: [io  0xf0f0-0xf0f7]
[    1.256058] pci 0000:00:1f.2: reg 0x14: [io  0xf0e0-0xf0e3]
[    1.261661] pci 0000:00:1f.2: reg 0x18: [io  0xf0d0-0xf0d7]
[    1.267263] pci 0000:00:1f.2: reg 0x1c: [io  0xf0c0-0xf0c3]
[    1.272863] pci 0000:00:1f.2: reg 0x20: [io  0xf020-0xf03f]
[    1.278464] pci 0000:00:1f.2: reg 0x24: [mem 0xd7348000-0xd73487ff]
[    1.284815] pci 0000:00:1f.2: PME# supported from D3hot
[    1.290161] pci 0000:00:1f.3: [8086:1d22] type 00 class 0x0c0500
[    1.296210] pci 0000:00:1f.3: reg 0x10: [mem 0xd7347000-0xd73470ff 64bit]
[    1.303042] pci 0000:00:1f.3: reg 0x20: [io  0xf000-0xf01f]
[    1.308845] pci 0000:00:01.0: PCI bridge to [bus 03]
[    1.313940] pci 0000:05:00.0: [10de:10d8] type 00 class 0x030000
[    1.319981] pci 0000:05:00.0: reg 0x10: [mem 0xd6000000-0xd6ffffff]
[    1.326276] pci 0000:05:00.0: reg 0x14: [mem 0xd8000000-0xdbffffff 64bit pref]
[    1.333527] pci 0000:05:00.0: reg 0x1c: [mem 0xdc000000-0xddffffff 64bit pref]
[    1.340777] pci 0000:05:00.0: reg 0x24: [io  0xd000-0xd07f]
[    1.346378] pci 0000:05:00.0: reg 0x30: [mem 0xd7000000-0xd707ffff pref]
[    1.353232] pci 0000:05:00.1: [10de:0be3] type 00 class 0x040300
[    1.359273] pci 0000:05:00.1: reg 0x10: [mem 0xd7080000-0xd7083fff]
[    1.367597] pci 0000:00:02.0: PCI bridge to [bus 05]
[    1.372586] pci 0000:00:02.0:   bridge window [io  0xd000-0xdfff]
[    1.378700] pci 0000:00:02.0:   bridge window [mem 0xd6000000-0xd70fffff]
[    1.385512] pci 0000:00:02.0:   bridge window [mem 0xd8000000-0xddffffff 64bit pref]
[    1.393372] pci 0000:00:03.0: PCI bridge to [bus 04]
[    1.398480] pci 0000:02:00.0: [8086:1d6b] type 00 class 0x010700
[    1.404538] pci 0000:02:00.0: reg 0x10: [mem 0xde87c000-0xde87ffff 64bit pref]
[    1.411797] pci 0000:02:00.0: reg 0x18: [mem 0xde400000-0xde7fffff 64bit pref]
[    1.419053] pci 0000:02:00.0: reg 0x20: [io  0xe000-0xe0ff]
[    1.424782] pci 0000:02:00.0: reg 0x164: [mem 0xde800000-0xde803fff 64bit pref]
[    1.432235] pci 0000:00:11.0: PCI bridge to [bus 02]
[    1.437224] pci 0000:00:11.0:   bridge window [io  0xe000-0xefff]
[    1.443344] pci 0000:00:11.0:   bridge window [mem 0xde400000-0xde8fffff 64bit pref]
[    1.451199] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    1.456306] pci 0000:00:1c.5: PCI bridge to [bus 06]
[    1.461393] pci 0000:00:1c.6: PCI bridge to [bus 07]
[    1.466494] pci 0000:08:00.0: [104c:8241] type 00 class 0x0c0330
[    1.472555] pci 0000:08:00.0: reg 0x10: [mem 0xd7200000-0xd720ffff 64bit]
[    1.479389] pci 0000:08:00.0: reg 0x18: [mem 0xd7210000-0xd7211fff 64bit]
[    1.486330] pci 0000:08:00.0: supports D1 D2
[    1.490615] pci 0000:08:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.499278] pci 0000:00:1c.7: PCI bridge to [bus 08]
[    1.504269] pci 0000:00:1c.7:   bridge window [mem 0xd7200000-0xd72fffff]
[    1.511177] pci 0000:09:04.0: [1317:0985] type 00 class 0x020000
[    1.517226] pci 0000:09:04.0: reg 0x10: [io  0xc000-0xc0ff]
[    1.522826] pci 0000:09:04.0: reg 0x14: [mem 0xd7121000-0xd71213ff]
[    1.529160] pci 0000:09:04.0: reg 0x30: [mem 0xd7100000-0xd711ffff pref]
[    1.535916] pci 0000:09:04.0: supports D1 D2
[    1.540202] pci 0000:09:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.546916] pci 0000:09:05.0: [11c1:5811] type 00 class 0x0c0010
[    1.552964] pci 0000:09:05.0: reg 0x10: [mem 0xd7120000-0xd7120fff]
[    1.559342] pci 0000:09:05.0: supports D1 D2
[    1.563634] pci 0000:09:05.0: PME# supported from D0 D1 D2 D3hot
[    1.569759] pci 0000:00:1e.0: PCI bridge to [bus 09] (subtractive decode)
[    1.576572] pci 0000:00:1e.0:   bridge window [io  0xc000-0xcfff]
[    1.582686] pci 0000:00:1e.0:   bridge window [mem 0xd7100000-0xd71fffff]
[    1.589499] pci 0000:00:1e.0:   bridge window [io  0x0000-0x03af] (subtractive decode)
[    1.597445] pci 0000:00:1e.0:   bridge window [io  0x03e0-0x0cf7] (subtractive decode)
[    1.605386] pci 0000:00:1e.0:   bridge window [io  0x03b0-0x03df] (subtractive decode)
[    1.613328] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    1.621269] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.629904] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    1.638535] pci 0000:00:1e.0:   bridge window [mem 0xd4000000-0xdfffffff] (subtractive decode)
[    1.647159] pci 0000:00:1e.0:   bridge window [mem 0x3c0000000000-0x3c007fffffff] (subtractive decode)
[    1.657334] ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 80-ff])
[    1.663550] acpi PNP0A08:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    1.671964] acpi PNP0A08:01: _OSC: platform does not support [PCIeCapability]
[    1.679206] acpi PNP0A08:01: _OSC: not requesting control; platform does not support [PCIeCapability]
[    1.688435] acpi PNP0A08:01: _OSC: OS requested [PCIeHotplug PME AER PCIeCapability]
[    1.696190] acpi PNP0A08:01: _OSC: platform willing to grant [PCIeHotplug PME AER]
[    1.703765] acpi PNP0A08:01: _OSC failed (AE_SUPPORT); disabling ASPM
[    1.710589] PCI host bridge to bus 0000:80
[    1.714693] pci_bus 0000:80: root bus resource [bus 80-ff]
[    1.720184] pci_bus 0000:80: root bus resource [io  0x0000-0x03af]
[    1.726370] pci_bus 0000:80: root bus resource [io  0x03e0-0x0cf7]
[    1.732558] pci_bus 0000:80: root bus resource [mem 0x000c0000-0x000dffff]
[    1.739590] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15), disabled.
[    1.747920] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15), disabled.
[    1.756271] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
[    1.764428] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 10 11 12 14 15), disabled.
[    1.772590] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 12 14 15), disabled.
[    1.780940] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    1.789484] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 12 14 15), disabled.
[    1.797828] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15), disabled.
[    1.806426] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 4/0x2 ignored.
[    1.814284] ACPI: Unable to map lapic to logical cpu number
[    1.820027] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 5/0x4 ignored.
[    1.827878] ACPI: Unable to map lapic to logical cpu number
[    1.833616] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 6/0x6 ignored.
[    1.841472] ACPI: Unable to map lapic to logical cpu number
[    1.847715] ACPI: Enabled 2 GPEs in block 00 to 3F
[    1.852759] vgaarb: setting as boot device: PCI:0000:05:00.0
[    1.858441] vgaarb: device added: PCI:0000:05:00.0,decodes=io+mem,owns=io+mem,locks=none
[    1.866561] vgaarb: loaded
[    1.869281] vgaarb: bridge control possible 0000:05:00.0
[    1.874738] SCSI subsystem initialized
[    1.878566] libata version 3.00 loaded.
[    1.882473] ACPI: bus type USB registered
[    1.886518] usbcore: registered new interface driver usbfs
[    1.892024] usbcore: registered new interface driver hub
[    1.897361] usbcore: registered new device driver usb
[    1.902574] PCI: Using ACPI for IRQ routing
[    1.914574] PCI: Discovered peer bus ff
[    1.918422] PCI: root bus ff: using default resources
[    1.923479] PCI: Probing PCI hardware (bus ff)
[    1.927987] PCI host bridge to bus 0000:ff
[    1.932104] pci_bus 0000:ff: root bus resource [io  0x0000-0xffff]
[    1.938304] pci_bus 0000:ff: root bus resource [mem 0x00000000-0x3fffffffffff]
[    1.945537] pci_bus 0000:ff: No busn resource found for root bus, will use [bus ff-ff]
[    1.953461] pci_bus 0000:ff: busn_res: can not insert [bus ff] under domain [bus 00-ff] (conflicts with (null) [bus 80-ff])
[    1.964603] pci 0000:ff:08.0: [8086:3c80] type 00 class 0x088000
[    1.970705] pci 0000:ff:08.3: [8086:3c83] type 00 class 0x088000
[    1.976829] pci 0000:ff:08.4: [8086:3c84] type 00 class 0x088000
[    1.982965] pci 0000:ff:09.0: [8086:3c90] type 00 class 0x088000
[    1.989075] pci 0000:ff:09.3: [8086:3c93] type 00 class 0x088000
[    1.995209] pci 0000:ff:09.4: [8086:3c94] type 00 class 0x088000
[    2.001344] pci 0000:ff:0a.0: [8086:3cc0] type 00 class 0x088000
[    2.007448] pci 0000:ff:0a.1: [8086:3cc1] type 00 class 0x088000
[    2.013551] pci 0000:ff:0a.2: [8086:3cc2] type 00 class 0x088000
[    2.019658] pci 0000:ff:0a.3: [8086:3cd0] type 00 class 0x088000
[    2.025767] pci 0000:ff:0b.0: [8086:3ce0] type 00 class 0x088000
[    2.031872] pci 0000:ff:0b.3: [8086:3ce3] type 00 class 0x088000
[    2.037981] pci 0000:ff:0c.0: [8086:3ce8] type 00 class 0x088000
[    2.044083] pci 0000:ff:0c.1: [8086:3ce8] type 00 class 0x088000
[    2.050172] pci 0000:ff:0c.6: [8086:3cf4] type 00 class 0x088000
[    2.056260] pci 0000:ff:0c.7: [8086:3cf6] type 00 class 0x088000
[    2.062358] pci 0000:ff:0d.0: [8086:3ce8] type 00 class 0x088000
[    2.068462] pci 0000:ff:0d.1: [8086:3ce8] type 00 class 0x088000
[    2.074564] pci 0000:ff:0d.6: [8086:3cf5] type 00 class 0x088000
[    2.080665] pci 0000:ff:0e.0: [8086:3ca0] type 00 class 0x088000
[    2.086768] pci 0000:ff:0e.1: [8086:3c46] type 00 class 0x110100
[    2.092886] pci 0000:ff:0f.0: [8086:3ca8] type 00 class 0x088000
[    2.099006] pci 0000:ff:0f.1: [8086:3c71] type 00 class 0x088000
[    2.105129] pci 0000:ff:0f.2: [8086:3caa] type 00 class 0x088000
[    2.111254] pci 0000:ff:0f.3: [8086:3cab] type 00 class 0x088000
[    2.117380] pci 0000:ff:0f.4: [8086:3cac] type 00 class 0x088000
[    2.123500] pci 0000:ff:0f.5: [8086:3cad] type 00 class 0x088000
[    2.129626] pci 0000:ff:0f.6: [8086:3cae] type 00 class 0x088000
[    2.135737] pci 0000:ff:10.0: [8086:3cb0] type 00 class 0x088000
[    2.141870] pci 0000:ff:10.1: [8086:3cb1] type 00 class 0x088000
[    2.147999] pci 0000:ff:10.2: [8086:3cb2] type 00 class 0x088000
[    2.154122] pci 0000:ff:10.3: [8086:3cb3] type 00 class 0x088000
[    2.160249] pci 0000:ff:10.4: [8086:3cb4] type 00 class 0x088000
[    2.166375] pci 0000:ff:10.5: [8086:3cb5] type 00 class 0x088000
[    2.172499] pci 0000:ff:10.6: [8086:3cb6] type 00 class 0x088000
[    2.178619] pci 0000:ff:10.7: [8086:3cb7] type 00 class 0x088000
[    2.184744] pci 0000:ff:11.0: [8086:3cb8] type 00 class 0x088000
[    2.190864] pci 0000:ff:13.0: [8086:3ce4] type 00 class 0x088000
[    2.196972] pci 0000:ff:13.1: [8086:3c43] type 00 class 0x110100
[    2.203081] pci 0000:ff:13.4: [8086:3ce6] type 00 class 0x110100
[    2.209184] pci 0000:ff:13.5: [8086:3c44] type 00 class 0x110100
[    2.215295] pci 0000:ff:13.6: [8086:3c45] type 00 class 0x088000
[    2.221411] pci_bus 0000:ff: busn_res: [bus ff] end is updated to ff
[    2.227789] pci_bus 0000:ff: busn_res: can not insert [bus ff] under domain [bus 00-ff] (conflicts with (null) [bus 80-ff])
[    2.238954] PCI: pci_cache_line_size set to 64 bytes
[    2.244095] e820: reserve RAM buffer [mem 0x00096400-0x0009ffff]
[    2.250127] e820: reserve RAM buffer [mem 0x37f66000-0x37ffffff]
[    2.256334] NetLabel: Initializing
[    2.259758] NetLabel:  domain hash size = 128
[    2.264128] NetLabel:  protocols = UNLABELED CIPSOv4
[    2.269138] NetLabel:  unlabeled traffic allowed by default
[    2.274959] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    2.281330] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    2.289218] Switched to clocksource hpet
[    2.302446] pnp: PnP ACPI init
[    2.305719] system 00:00: [mem 0xfc000000-0xfcffffff window] has been reserved
[    2.312986] system 00:00: [mem 0xfd000000-0xfdffffff window] has been reserved
[    2.320245] system 00:00: [mem 0xfe000000-0xfeafffff window] has been reserved
[    2.327500] system 00:00: [mem 0xfeb00000-0xfebfffff window] has been reserved
[    2.334752] system 00:00: [mem 0xfed00400-0xfed3ffff window] could not be reserved
[    2.342345] system 00:00: [mem 0xfed45000-0xfedfffff window] has been reserved
[    2.349591] system 00:00: [mem 0xdffff000-0xdfffffff window] has been reserved
[    2.356839] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    2.363885] system 00:01: [io  0x0620-0x063f] has been reserved
[    2.369840] system 00:01: [io  0x0610-0x061f] has been reserved
[    2.375783] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.382667] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    2.389992] pnp 00:03: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
[    2.397276] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.403920] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    2.409851] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.416906] pnp 00:06: [dma 0 disabled]
[    2.420786] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.427663] system 00:07: [io  0x0400-0x0453] could not be reserved
[    2.433947] system 00:07: [io  0x0458-0x047f] has been reserved
[    2.439900] system 00:07: [io  0x1180-0x119f] has been reserved
[    2.445847] system 00:07: [io  0x0500-0x057f] has been reserved
[    2.451790] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    2.458434] system 00:07: [mem 0xfec00000-0xfecfffff] could not be reserved
[    2.465418] system 00:07: [mem 0xfed08000-0xfed08fff] has been reserved
[    2.472056] system 00:07: [mem 0xff000000-0xffffffff] has been reserved
[    2.478697] system 00:07: Plug and Play ACPI device, IDs PNP0c01 (active)
[    2.485629] system 00:08: [io  0x0454-0x0457] has been reserved
[    2.491577] system 00:08: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    2.499647] system 00:09: [mem 0xfed40000-0xfed44fff] has been reserved
[    2.506269] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.513051] pnp: PnP ACPI: found 10 devices
[    2.524317] pci 0000:00:01.0: PCI bridge to [bus 03]
[    2.529309] pci 0000:00:02.0: PCI bridge to [bus 05]
[    2.534268] pci 0000:00:02.0:   bridge window [io  0xd000-0xdfff]
[    2.540368] pci 0000:00:02.0:   bridge window [mem 0xd6000000-0xd70fffff]
[    2.547170] pci 0000:00:02.0:   bridge window [mem 0xd8000000-0xddffffff 64bit pref]
[    2.554928] pci 0000:00:03.0: PCI bridge to [bus 04]
[    2.559916] pci 0000:00:11.0: PCI bridge to [bus 02]
[    2.564886] pci 0000:00:11.0:   bridge window [io  0xe000-0xefff]
[    2.570992] pci 0000:00:11.0:   bridge window [mem 0xde400000-0xde8fffff 64bit pref]
[    2.578746] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    2.583731] pci 0000:00:1c.5: PCI bridge to [bus 06]
[    2.588723] pci 0000:00:1c.6: PCI bridge to [bus 07]
[    2.593707] pci 0000:00:1c.7: PCI bridge to [bus 08]
[    2.598681] pci 0000:00:1c.7:   bridge window [mem 0xd7200000-0xd72fffff]
[    2.605489] pci 0000:00:1e.0: PCI bridge to [bus 09]
[    2.610476] pci 0000:00:1e.0:   bridge window [io  0xc000-0xcfff]
[    2.616594] pci 0000:00:1e.0:   bridge window [mem 0xd7100000-0xd71fffff]
[    2.623420] pci_bus 0000:00: resource 4 [io  0x0000-0x03af]
[    2.629020] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7]
[    2.634612] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df]
[    2.640206] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff]
[    2.645793] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff]
[    2.652065] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff]
[    2.658337] pci_bus 0000:00: resource 10 [mem 0xd4000000-0xdfffffff]
[    2.664697] pci_bus 0000:00: resource 11 [mem 0x3c0000000000-0x3c007fffffff]
[    2.671752] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
[    2.677338] pci_bus 0000:05: resource 1 [mem 0xd6000000-0xd70fffff]
[    2.683607] pci_bus 0000:05: resource 2 [mem 0xd8000000-0xddffffff 64bit pref]
[    2.690849] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    2.696441] pci_bus 0000:02: resource 2 [mem 0xde400000-0xde8fffff 64bit pref]
[    2.703691] pci_bus 0000:08: resource 1 [mem 0xd7200000-0xd72fffff]
[    2.709979] pci_bus 0000:09: resource 0 [io  0xc000-0xcfff]
[    2.715573] pci_bus 0000:09: resource 1 [mem 0xd7100000-0xd71fffff]
[    2.721853] pci_bus 0000:09: resource 4 [io  0x0000-0x03af]
[    2.727439] pci_bus 0000:09: resource 5 [io  0x03e0-0x0cf7]
[    2.733031] pci_bus 0000:09: resource 6 [io  0x03b0-0x03df]
[    2.738625] pci_bus 0000:09: resource 7 [io  0x0d00-0xffff]
[    2.744220] pci_bus 0000:09: resource 8 [mem 0x000a0000-0x000bffff]
[    2.750510] pci_bus 0000:09: resource 9 [mem 0x000c0000-0x000dffff]
[    2.756800] pci_bus 0000:09: resource 10 [mem 0xd4000000-0xdfffffff]
[    2.763178] pci_bus 0000:09: resource 11 [mem 0x3c0000000000-0x3c007fffffff]
[    2.770249] pci_bus 0000:80: resource 4 [io  0x0000-0x03af]
[    2.775851] pci_bus 0000:80: resource 5 [io  0x03e0-0x0cf7]
[    2.781454] pci_bus 0000:80: resource 6 [mem 0x000c0000-0x000dffff]
[    2.787752] pci_bus 0000:ff: resource 4 [io  0x0000-0xffff]
[    2.793347] pci_bus 0000:ff: resource 5 [mem 0x00000000-0x3fffffffffff]
[    2.800034] NET: Registered protocol family 2
[    2.804672] TCP established hash table entries: 2048 (order: 2, 16384 bytes)
[    2.811770] TCP bind hash table entries: 2048 (order: 3, 32768 bytes)
[    2.818230] TCP: Hash tables configured (established 2048 bind 2048)
[    2.824610] TCP: reno registered
[    2.827857] UDP hash table entries: 256 (order: 1, 8192 bytes)
[    2.833708] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
[    2.840046] NET: Registered protocol family 1
[    2.845566] pci 0000:05:00.0: Video device with shadowed ROM
[    2.851666] PCI: CLS 64 bytes, default 64
[    2.855768] Unpacking initramfs...
[    4.447503] Freeing initrd memory: 52844K (ffff880032c65000 - ffff880036000000)
[    4.454872] IOMMU Skip disabling iommu hardware translations
[    4.460761] IOMMU Copying translate tables from panicked kernel
[    4.468304] IOMMU: root_cache:0xffff880031960000 phys:0x0003eeae1000
[    4.474686] IOMMU:0 Domain ids from panicked kernel:
[    4.479673] DID did:4(0x0004)
[    4.482657] DID did:10(0x000a)
[    4.485720] DID did:8(0x0008)
[    4.488692] DID did:6(0x0006)
[    4.491671] DID did:3(0x0003)
[    4.494651] DID did:2(0x0002)
[    4.497629] DID did:7(0x0007)
[    4.500605] DID did:1(0x0001)
[    4.503583] DID did:9(0x0009)
[    4.506558] DID did:0(0x0000)
[    4.509536] DID did:11(0x000b)
[    4.512599] DID did:5(0x0005)
[    4.515576] ----------------------------------------
[    4.520546] IOMMU: dmar0 using Queued invalidation
[    4.525355] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[    4.534191] RAPL PMU detected, hw unit 2^-16 Joules, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
[    4.545218] AVX version of gcm_enc/dec engaged.
[    4.549767] AES CTR mode by8 optimization enabled
[    4.557005] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    4.563932] futex hash table entries: 256 (order: 2, 16384 bytes)
[    4.570069] Initialise system trusted keyring
[    4.574510] audit: initializing netlink subsys (disabled)
[    4.579954] audit: type=2000 audit(1420524713.791:1): initialized
[    4.587459] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.596339] zpool: loaded
[    4.598985] zbud: loaded
[    4.601812] VFS: Disk quotas dquot_6.5.2
[    4.605822] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    4.613374] Key type big_key registered
[    4.617230] SELinux:  Registering netfilter hooks
[    4.622975] alg: No test for stdrng (krng)
[    4.627095] NET: Registered protocol family 38
[    4.631581] Key type asymmetric registered
[    4.635704] Asymmetric key parser 'x509' registered
[    4.640662] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    4.648115] io scheduler noop registered
[    4.652063] io scheduler deadline registered
[    4.656388] io scheduler cfq registered (default)
[    4.662588] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.668203] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    4.674879] intel_idle: MWAIT substates: 0x21120
[    4.679506] intel_idle: v0.4 model 0x2D
[    4.683350] intel_idle: lapic_timer_reliable_states 0xffffffff
[    4.689379] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    4.697749] ACPI: Power Button [PWRB]
[    4.701491] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    4.708894] ACPI: Power Button [PWRF]
[    4.714402] GHES: HEST is not enabled!
[    4.718275] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.745225] serial 00:06: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    4.774137] serial 0000:00:16.3: ttyS1 at I/O 0xf060 (irq = 17, base_baud = 115200) is a 16550A
[    4.783298] Non-volatile memory driver v1.3
[    4.787509] Linux agpgart interface v0.103
[    4.791901] ahci 0000:00:1f.2: version 3.0
[    4.807019] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x5 impl RAID mode
[    4.815128] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio ems sxs apst 
[    4.822491] dmar: DRHD: handling fault status reg 2
[    4.827365] dmar: DMAR:[DMA Write] Request device [00:1f.2] fault addr fffe0000 
[    4.827365] DMAR:[fault reason 10] non-zero reserved fields in RTP
[    4.840966] dmar: DRHD: handling fault status reg 102
[    4.846011] dmar: DMAR:[DMA Write] Request device [00:1f.2] fault addr fffc0000 
[    4.846011] DMAR:[fault reason 10] non-zero reserved fields in RTP
[    4.859567] dmar: DMAR:[DMA Write] Request device [00:1e.0] fault addr fff38000 
[    4.859567] DMAR:[fault reason 10] non-zero reserved fields in RTP
[    4.873136] dmar: DRHD: handling fault status reg 300
[    4.879013] scsi host0: ahci
[    4.882095] scsi host1: ahci
[    4.885105] scsi host2: ahci
[    4.888113] scsi host3: ahci
[    4.891111] scsi host4: ahci
[    4.894115] scsi host5: ahci
[    4.897073] ata1: SATA max UDMA/133 abar m2048@0xd7348000 port 0xd7348100 irq 27
[    4.904480] ata2: DUMMY
[    4.906934] ata3: SATA max UDMA/133 abar m2048@0xd7348000 port 0xd7348200 irq 27
[    4.914327] ata4: DUMMY
[    4.916784] ata5: DUMMY
[    4.919239] ata6: DUMMY
[    4.922035] libphy: Fixed MDIO Bus: probed
[    4.926316] xhci_hcd 0000:08:00.0: xHCI Host Controller
[    4.931617] xhci_hcd 0000:08:00.0: new USB bus registered, assigned bus number 1
[    4.939457] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.946256] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.953493] usb usb1: Product: xHCI Host Controller
[    4.958387] usb usb1: Manufacturer: Linux 3.19.0-rc2+ xhci-hcd
[    4.964232] usb usb1: SerialNumber: 0000:08:00.0
[    4.969025] hub 1-0:1.0: USB hub found
[    4.972805] hub 1-0:1.0: 4 ports detected
[    4.977029] xhci_hcd 0000:08:00.0: xHCI Host Controller
[    4.982320] xhci_hcd 0000:08:00.0: new USB bus registered, assigned bus number 2
[    4.989730] dmar: DRHD: handling fault status reg 302
[    4.994791] dmar: DMAR:[DMA Read] Request device [08:00.0] fault addr ffffc000 
[    4.994791] DMAR:[fault reason 10] non-zero reserved fields in RTP
[    5.008314] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    5.015116] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.022345] usb usb2: Product: xHCI Host Controller
[    5.027240] usb usb2: Manufacturer: Linux 3.19.0-rc2+ xhci-hcd
[    5.033080] usb usb2: SerialNumber: 0000:08:00.0
[    5.037852] hub 2-0:1.0: USB hub found
[    5.041632] hub 2-0:1.0: 4 ports detected
[    5.045862] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.052422] ehci-pci: EHCI PCI platform driver
[    5.057035] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    5.062338] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    5.069755] ehci-pci 0000:00:1a.0: debug port 2
[    5.078282] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    5.085109] ehci-pci 0000:00:1a.0: irq 16, io mem 0xd734b000
[    5.096342] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    5.102099] do_IRQ: 0.35 No irq handler for vector (irq -1)
[    5.107750] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    5.114549] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.121783] usb usb3: Product: EHCI Host Controller
[    5.126669] usb usb3: Manufacturer: Linux 3.19.0-rc2+ ehci_hcd
[    5.132511] usb usb3: SerialNumber: 0000:00:1a.0
[    5.137332] hub 3-0:1.0: USB hub found
[    5.141108] hub 3-0:1.0: 3 ports detected
[    5.145588] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    5.150912] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    5.158328] ehci-pci 0000:00:1d.0: debug port 2
[    5.166876] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    5.173700] ehci-pci 0000:00:1d.0: irq 23, io mem 0xd734a000
[    5.184439] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    5.190210] dmar: DRHD: handling fault status reg 402
[    5.195273] dmar: INTR-REMAP: Request device [[00:1f.7] fault index 20
[    5.195273] INTR-REMAP:[fault reason 38] Blocked an interrupt request due to source-id verification failure
[    5.211603] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    5.218402] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.225636] usb usb4: Product: EHCI Host Controller
[    5.230521] usb usb4: Manufacturer: Linux 3.19.0-rc2+ ehci_hcd
[    5.236362] usb usb4: SerialNumber: 0000:00:1d.0
[    5.240996] dmar: DRHD: handling fault status reg 502
[    5.246052] dmar: DMAR:[DMA Write] Request device [00:1f.2] fault addr fffe0000 
[    5.246052] DMAR:[fault reason 10] non-zero reserved fields in RTP
[    5.259633] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    5.265834] dmar: DRHD: handling fault status reg 602
[    5.270878] dmar: DMAR:[DMA Read] Request device [00:1f.2] fault addr fffe0000 
[    5.270878] DMAR:[fault reason 10] non-zero reserved fields in RTP
[    5.284582] hub 4-0:1.0: USB hub found
[    5.288359] dmar: DRHD: handling fault status reg 702
[    5.293417] dmar: DMAR:[DMA Write] Request device [00:1f.2] fault addr fffc0000 
[    5.293417] DMAR:[fault reason 10] non-zero reserved fields in RTP
[    5.306996] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.313193] dmar: DRHD: handling fault status reg 2
[    5.318075] dmar: DMAR:[DMA Read] Request device [00:1f.2] fault addr fffc0000 
[    5.318075] DMAR:[fault reason 10] non-zero reserved fields in RTP
[    5.331577] hub 4-0:1.0: 3 ports detected
[    5.335807] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.342010] ohci-pci: OHCI PCI platform driver
[    5.346487] uhci_hcd: USB Universal Host Controller Interface driver
[    5.352936] usbcore: registered new interface driver usbserial
[    5.358789] usbcore: registered new interface driver usbserial_generic
[    5.365340] usbserial: USB Serial support registered for generic
[    5.371407] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    5.381157] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x100)
[    5.388819] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.393812] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.398996] mousedev: PS/2 mouse device common for all mice
[    5.404895] rtc_cmos 00:04: RTC can wake from S4
[    5.409704] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    5.415870] rtc_cmos 00:04: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    5.423648] device-mapper: uevent: version 1.0.3
[    5.428783] device-mapper: ioctl: 4.29.0-ioctl (2014-10-28) initialised: dm-devel@redhat.com
[    5.437325] Intel P-state driver initializing.
[    5.443561] hidraw: raw HID events driver (C) Jiri Kosina
[    5.449184] usbcore: registered new interface driver usbhid
[    5.454784] usbhid: USB HID core driver
[    5.458944] drop_monitor: Initializing network drop monitor service
[    5.465401] ip_tables: (C) 2000-2006 Netfilter Core Team
[    5.470755] TCP: cubic registered
[    5.474075] Initializing XFRM netlink socket
[    5.478847] NET: Registered protocol family 10
[    5.483542] mip6: Mobile IPv6
[    5.486536] NET: Registered protocol family 17
[    5.491000] mce: Unable to init device /dev/mcelog (rc: -5)
[    5.496744] usb 3-1: new high-speed USB device number 2 using ehci-pci
[    5.503460] Loading compiled-in X.509 certificates
[    5.508276] dmar: DRHD: handling fault status reg 102
[    5.513331] dmar: DMAR:[DMA Read] Request device [00:1a.0] fault addr fffff000 
[    5.513331] DMAR:[fault reason 10] non-zero reserved fields in RTP
[    5.528003] Loaded X.509 cert 'Magrathea: Glacier signing key: d196e1366cc7c91295775c1e77c548314c3ad291'
[    5.537492] tsc: Refined TSC clocksource calibration: 2793.268 MHz
[    5.543697] registered taskstats version 1
[    5.548416]   Magic number: 15:667:164
[    5.552271] rtc_cmos 00:04: setting system clock to 2015-01-06 06:11:57 UTC (1420524717)
[    5.560455] PM: Hibernation image not present or could not be loaded.
[    5.566997] ehci-pci 0000:00:1a.0: fatal error
[    5.571447] ehci-pci 0000:00:1a.0: HC died; cleaning up
[    5.649981] usb 4-1: new high-speed USB device number 2 using ehci-pci
[    5.656537] dmar: DRHD: handling fault status reg 202
[    5.661590] dmar: DMAR:[DMA Read] Request device [00:1d.0] fault addr fffff000 
[    5.661590] DMAR:[fault reason 10] non-zero reserved fields in RTP
[    5.853075] dmar: DRHD: handling fault status reg 302
[    5.858152] dmar: DMAR:[DMA Write] Request device [00:1e.0] fault addr fffff000 
[    5.858152] DMAR:[fault reason 10] non-zero reserved fields in RTP
[    6.172770] dmar: DRHD: handling fault status reg 402
[    6.177833] dmar: DMAR:[DMA Write] Request device [00:1e.0] fault addr fffff000 
[    6.177833] DMAR:[fault reason 10] non-zero reserved fields in RTP
[    6.548988] Switched to clocksource tsc
[   10.271066] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x100)
[   10.621432] dmar: DRHD: handling fault status reg 502
[   10.626494] dmar: DMAR:[DMA Write] Request device [00:1f.2] fault addr fffe0000 
[   10.626494] DMAR:[fault reason 10] non-zero reserved fields in RTP
[   10.640039] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[   10.646238] dmar: DRHD: handling fault status reg 602
[   10.651293] dmar: DMAR:[DMA Read] Request device [00:1f.2] fault addr fffe0000 
[   10.651293] DMAR:[fault reason 10] non-zero reserved fields in RTP
[   10.664768] dmar: DRHD: handling fault status reg 702
[   10.669809] dmar: DMAR:[DMA Write] Request device [00:1f.2] fault addr fffc0000 
[   10.669809] DMAR:[fault reason 10] non-zero reserved fields in RTP
[   10.683382] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   10.689577] dmar: DRHD: handling fault status reg 2
[   10.694458] dmar: DMAR:[DMA Read] Request device [00:1f.2] fault addr fffc0000 
[   10.694458] DMAR:[fault reason 10] non-zero reserved fields in RTP
[   15.713048] ata3.00: qc timeout (cmd 0xa1)
[   15.717176] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   15.723299] ata3: limiting SATA link speed to 1.5 Gbps
[   15.728474] ata1.00: qc timeout (cmd 0xec)
[   15.732595] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   15.738722] ata1: limiting SATA link speed to 3.0 Gbps
[   16.046415] dmar: DRHD: handling fault status reg 102
[   16.051488] dmar: DMAR:[DMA Write] Request device [00:1f.2] fault addr fffc0000 
[   16.051488] DMAR:[fault reason 10] non-zero reserved fields in RTP
[   16.065103] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   16.071323] dmar: DRHD: handling fault status reg 202
[   16.076394] dmar: DMAR:[DMA Read] Request device [00:1f.2] fault addr fffc0000 
[   16.076394] DMAR:[fault reason 10] non-zero reserved fields in RTP
[   16.089913] dmar: DRHD: handling fault status reg 302
[   16.094983] dmar: DMAR:[DMA Write] Request device [00:1f.2] fault addr fffe0000 
[   16.094983] DMAR:[fault reason 10] non-zero reserved fields in RTP
[   16.108590] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
[   16.114794] dmar: DRHD: handling fault status reg 402
[   16.119857] dmar: DMAR:[DMA Read] Request device [00:1f.2] fault addr fffe0000 
[   16.119857] DMAR:[fault reason 10] non-zero reserved fields in RTP
[   20.834724] ehci-pci 0000:00:1d.0: port 1 reset error -110
[   21.697680] ehci-pci 0000:00:1d.0: port 1 reset error -110
[   22.509576] ehci-pci 0000:00:1d.0: port 1 reset error -110
[   23.321463] ehci-pci 0000:00:1d.0: port 1 reset error -110
[   24.133359] ehci-pci 0000:00:1d.0: port 1 reset error -110
[   24.742006] usb usb4-port1: Cannot enable. Maybe the USB cable is bad?
[   24.801096] ehci-pci 0000:00:1d.0: port 1 reset error -110
[   25.664047] ehci-pci 0000:00:1d.0: port 1 reset error -110
[   26.143538] ata3.00: qc timeout (cmd 0xa1)
[   26.147661] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   26.153799] ata1.00: qc timeout (cmd 0xec)
[   26.157930] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   26.466898] dmar: DRHD: handling fault status reg 502
[   26.471972] dmar: DMAR:[DMA Write] Request device [00:1f.2] fault addr fffc0000 
[   26.471972] DMAR:[fault reason 10] non-zero reserved fields in RTP
[   26.485588] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   26.493772] ehci-pci 0000:00:1d.0: port 1 reset error -110
[   26.499297] dmar: DRHD: handling fault status reg 602
[   26.504366] dmar: DMAR:[DMA Write] Request device [00:1f.2] fault addr fffe0000 
[   26.504366] DMAR:[fault reason 10] non-zero reserved fields in RTP
[   26.517974] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
[   26.524591] Freeing unused kernel memory: 1464K (ffffffff81d1c000 - ffffffff81e8a000)
[   26.532455] Write protecting the kernel read-only data: 12288k
[   26.538662] Freeing unused kernel memory: 708K (ffff88003674f000 - ffff880036800000)
[   26.546676] Freeing unused kernel memory: 900K (ffff880036b1f000 - ffff880036c00000)
[   26.556078] ehci-pci 0000:00:1d.0: fatal error
[   26.560540] ehci-pci 0000:00:1d.0: HC died; cleaning up
[   26.567014] systemd[1]: systemd 208 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[   26.579620] systemd[1]: Running in initial RAM disk.

Welcome to Fedora 20 (Heisenbug) dracut-038-14.git20140724.fc22 (Initramfs)!

[   26.593159] systemd[1]: Set hostname to <dhcp-16-105.nay.redhat.com>.
[   26.600193] random: systemd urandom read with 6 bits of entropy available
[   26.631984] systemd[1]: Expecting device dev-disk-by\x2duuid-3429ef24\x2d72c1\x2d435f\x2da55b\x2d15132ef30516.device...
         Expecting device dev-disk-by\x2duuid-3429ef24\x2d72c...30516.device...
[   26.651165] systemd[1]: Expecting device dev-disk-by\x2duuid-06476532\x2d3675\x2d40ce\x2d98dd\x2df0b6564e5455.device...
         Expecting device dev-disk-by\x2duuid-06476532\x2d367...e5455.device...
[   26.670181] systemd[1]: Expecting device dev-disk-by\x2duuid-f170152e\x2dde83\x2d46ee\x2d9546\x2d8ccd53f9753b.device...
         Expecting device dev-disk-by\x2duuid-f170152e\x2dde8...9753b.device...
[   26.689199] systemd[1]: Starting -.slice.
[  OK  ] Created slice -.slice.
[   26.698214] systemd[1]: Created slice -.slice.
[   26.702693] systemd[1]: Starting System Slice.
[  OK  ] Created slice System Slice.
[   26.713228] systemd[1]: Created slice System Slice.
[   26.718146] systemd[1]: Starting Slices.
[  OK  ] Reached target Slices.
[   26.726239] systemd[1]: Reached target Slices.
[   26.730717] systemd[1]: Starting Timers.
[  OK  ] Reached target Timers.
[   26.739285] systemd[1]: Reached target Timers.
[   26.743773] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
[   26.751844] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[   26.759798] systemd[1]: Starting Paths.
[  OK  ] Reached target Paths.
[   26.768283] systemd[1]: Reached target Paths.
[   26.772672] systemd[1]: Starting Journal Socket.
[  OK  ] Listening on Journal Socket.
[   26.782304] systemd[1]: Listening on Journal Socket.
[   26.787342] systemd[1]: Started dracut ask for additional cmdline parameters.
[   26.794597] systemd[1]: Starting dracut cmdline hook...
         Starting dracut cmdline hook...
[   26.804560] systemd[1]: Starting Apply Kernel Variables...
         Starting Apply Kernel Variables...
[   26.818484] systemd[1]: Starting Journal Service...
         Starting Journal Service...
[  OK  ] Started Journal Service.
[   26.836324] systemd[1]: Started Journal Service.
         Starting Create list of required static device nodes...rrent kernel...
[  OK  ] Listening on udev Kernel Socket.
[  OK  ] Listening on udev Control Socket.
[  OK  ] Reached target Sockets.
[  OK  ] Reached target Swap.
[  OK  ] Reached target Local File Systems.
[  OK  ] Started Apply Kernel Variables.
[  OK  ] Started Create list of required static device nodes ...current kernel.
         Starting Create static device nodes in /dev...
[  OK  ] Started Create static device nodes in /dev.
[  OK  ] Started dracut cmdline hook.
         Starting dracut pre-udev hook...
[  OK  ] Started dracut pre-udev hook.
         Starting udev Kernel Device Manager...
[   26.961900] systemd-udevd[209]: starting version 208
[  OK  ] Started udev Kernel Device Manager.
         Starting udev Coldplug all Devices...
[  OK  ] Started udev Coldplug all Devices.
         Starting dracut initqueue hook...
[  OK  ] Reached target System Initialization.
[  OK  ] Reached target Basic System.
         Mounting Configuration File System...
[  OK  ] Mounted Configuration File System.
[   27.047418] wmi: Mapper loaded
[   27.145121] [drm] Initialized drm 1.1.0 20060810
[   27.304098] isci: Intel(R) C600 SAS Controller Driver - version 1.2.0
[   27.322844] systemd-udevd invoked oom-killer: gfp_mask=0x280da, order=0, oom_score_adj=-1000
[   27.331312] systemd-udevd cpuset=/ mems_allowed=0
[   27.336086] CPU: 0 PID: 209 Comm: systemd-udevd Not tainted 3.19.0-rc2+ #93
[   27.343072] Hardware name: Hewlett-Packard HP Z420 Workstation/1589, BIOS J61 v01.02 03/09/2012
[   27.351798]  0000000000000000 0000000061818f1a ffff880035c0f9f8 ffffffff8173f728
[   27.359300]  0000000000000000 ffff880035c3db40 ffff880035c0fa98 ffffffff8173c406
[   27.366776]  0000000000001c02 0000000035c0fb58 0000000000001c02 0000000000000292
[   27.374271] Call Trace:
[   27.376744]  [<ffffffff8173f728>] dump_stack+0x45/0x57
[   27.381913]  [<ffffffff8173c406>] dump_header+0x89/0x20a
[   27.387239]  [<ffffffff8118fb80>] oom_kill_process+0x240/0x390
[   27.393075]  [<ffffffff811903f2>] out_of_memory+0x502/0x540
[   27.398657]  [<ffffffff81195cc8>] __alloc_pages_nodemask+0x868/0xa30
[   27.405018]  [<ffffffff811df9d7>] alloc_pages_vma+0x97/0x160
[   27.410686]  [<ffffffff811be1d6>] handle_mm_fault+0xcf6/0x1120
[   27.416524]  [<ffffffff8105d32c>] __do_page_fault+0x1dc/0x5b0
[   27.422279]  [<ffffffff8124b3d8>] ? ep_poll+0x128/0x380
[   27.427510]  [<ffffffff810cefc0>] ? pick_next_task_fair+0x610/0x870
[   27.433785]  [<ffffffff81612891>] ? __sys_recvmsg+0x51/0x90
[   27.439360]  [<ffffffff8105d722>] do_page_fault+0x22/0x30
[   27.444769]  [<ffffffff81749028>] page_fault+0x28/0x30
[   27.449911] Mem-Info:
[   27.452194] Node 0 DMA per-cpu:
[   27.455368] CPU    0: hi:    0, btch:   1 usd:   0
[   27.460164] Node 0 DMA32 per-cpu:
[   27.463505] CPU    0: hi:   90, btch:  15 usd:  27
[   27.468308] active_anon:800 inactive_anon:1025 isolated_anon:0
[   27.468308]  active_file:16 inactive_file:36 isolated_file:0
[   27.468308]  unevictable:39595 dirty:0 writeback:0 unstable:0
[   27.468308]  free:613 slab_reclaimable:2165 slab_unreclaimable:3423
[   27.468308]  mapped:1596 shmem:1036 pagetables:140 bounce:0
[   27.468308]  free_cma:0
[   27.499745] Node 0 DMA free:512kB min:4kB low:4kB high:4kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB s
[   27.537985] lowmem_reserve[]: 0 233 233 233
[   27.542288] Node 0 DMA32 free:1940kB min:1944kB low:2428kB high:2916kB active_anon:3200kB inactive_anon:4100kB active_file:64kB inactive_file:144kB unevictable:15s
[   27.585391] lowmem_reserve[]: 0 0 0 0
[   27.589164] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 512kB
[   27.601030] Node 0 DMA32: 1*4kB (R) 0*8kB 1*16kB (R) 0*32kB 0*64kB 1*128kB (R) 1*256kB (R) 1*512kB (R) 1*1024kB (R) 0*2048kB 0*4096kB = 1940kB
[   27.614272] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[   27.622733] 40680 total pagecache pages
[   27.626588] 0 pages in swap cache
[   27.629916] Swap cache stats: add 0, delete 0, find 0/0
[   27.635160] Free swap  = 0kB
[   27.638054] Total swap = 0kB
[   27.640949] 65531 pages RAM
[   27.643758] 0 pages HighMem/MovableOnly
[   27.647612] 4986 pages reserved
[   27.650767] 0 pages hwpoisoned
[   27.653840] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
[   27.661699] [  126]     0   126     9732      841      23        0             0 systemd-journal
[   27.670513] [  209]     0   209     8857      920      20        0         -1000 systemd-udevd
[   27.679147] [  213]     0   213    28751      617      19        0             0 systemd-udevd
[   27.687780] [  214]     0   214     9769      616      19        0             0 systemd-udevd
[   27.696416] [  216]     0   216     3010      751      14        0             0 dracut-initqueu
[   27.705225] [  225]     0   225     8160      652      19        0             0 udevadm
[   27.713341] Out of memory: Kill process 126 (systemd-journal) score 13 or sacrifice child
[   27.721539] Killed process 126 (systemd-journal) total-vm:38928kB, anon-rss:292kB, file-rss:3072kB
[   27.731134] systemd[1]: systemd-journald.service holdoff time over, scheduling restart.
[   27.740866] systemd[1]: Stopping Journal Service...
[   27.745800] isci 0000:02:00.0: driver configured for rev: 5 silicon
         Stoppin[   27.752726] systemd-udevd invoked oom-killer: gfp_mask=0x280da, order=0, oom_score_adj=-1000
g Journal Servic[   27.762130] systemd-udevd cpuset=e...
/ mems_allowed=0
[   27.768777] CPU: 0 PID: 209 Comm: systemd-udevd Not tainted 3.19.0-rc2+ #93
[   27.775760] Hardware name: Hewlett-Packard HP Z420 Workstation/1589, BIOS J61 v01.02 03/09/2012
[   27.784481]  0000000000000000 0000000061818f1a ffff880035c0f9f8 ffffffff8173f728
[   27.791998]  0000000000000000 ffff880035c3db40 ffff880035c0fa98 ffffffff8173c406
[   27.799479]  0000000000000000 0000000035c0fb58 0000000000000000 0000000000000292
[   27.806963] Call Trace:
[   27.809419]  [<ffffffff8173f728>] dump_stack+0x45/0x57
[   27.814575]  [<ffffffff8173c406>] dump_header+0x89/0x20a
[   27.819907]  [<ffffffff8118fb80>] oom_kill_process+0x240/0x390
[   27.825756]  [<ffffffff811903f2>] out_of_memory+0x502/0x540
[   27.831351]  [<ffffffff81195cc8>] __alloc_pages_nodemask+0x868/0xa30
[   27.837722]  [<ffffffff811df9d7>] alloc_pages_vma+0x97/0x160
[   27.843399]  [<ffffffff811be1d6>] handle_mm_fault+0xcf6/0x1120
[   27.849253]  [<ffffffff8105d32c>] __do_page_fault+0x1dc/0x5b0
[   27.855020]  [<ffffffff8124b3d8>] ? ep_poll+0x128/0x380
[   27.860263]  [<ffffffff810cefc0>] ? pick_next_task_fair+0x610/0x870
[   27.866549]  [<ffffffff81612891>] ? __sys_recvmsg+0x51/0x90
[   27.872139]  [<ffffffff8105d722>] do_page_fault+0x22/0x30
[   27.877559]  [<ffffffff81749028>] page_fault+0x28/0x30
[   27.882714] Mem-Info:
[   27.884999] Node 0 DMA per-cpu:
[   27.888166] CPU    0: hi:    0, btch:   1 usd:   0
[   27.892975] Node 0 DMA32 per-cpu:
[   27.896327] CPU    0: hi:   90, btch:  15 usd:  41
[   27.901137] active_anon:758 inactive_anon:1027 isolated_anon:0
[   27.901137]  active_file:3 inactive_file:2 isolated_file:0
[   27.901137]  unevictable:39644 dirty:0 writeback:0 unstable:0
[   27.901137]  free:610 slab_reclaimable:2087 slab_unreclaimable:3423
[   27.901137]  mapped:1377 shmem:1037 pagetables:124 bounce:0
[   27.901137]  free_cma:0
[   27.932472] Node 0 DMA free:512kB min:4kB low:4kB high:4kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB s
[   27.970798] lowmem_reserve[]: 0 233 233 233
[   27.975102] Node 0 DMA32 free:1928kB min:1944kB low:2428kB high:2916kB active_anon:3032kB inactive_anon:4108kB active_file:12kB inactive_file:8kB unevictable:1585s
[   28.017660] lowmem_reserve[]: 0 0 0 0
[   28.021443] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 512kB
[   28.033320] Node 0 DMA32: 0*4kB 1*8kB (R) 0*16kB 0*32kB 0*64kB 1*128kB (R) 1*256kB (R) 1*512kB (R) 1*1024kB (R) 0*2048kB 0*4096kB = 1928kB
[   28.046165] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[   28.054633] 40684 total pagecache pages
[   28.058481] 0 pages in swap cache
[   28.061812] Swap cache stats: add 0, delete 0, find 0/0
[   28.067061] Free swap  = 0kB
[   28.069954] Total swap = 0kB
[   28.072853] 65531 pages RAM
[   28.075660] 0 pages HighMem/MovableOnly
[   28.079517] 4986 pages reserved
[   28.082671] 0 pages hwpoisoned
[   28.085743] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
[   28.093602] [  209]     0   209     8857      920      20        0         -1000 systemd-udevd
[   28.102233] [  213]     0   213    28751      617      19        0             0 systemd-udevd
[   28.110871] [  214]     0   214     9769      616      19        0             0 systemd-udevd
[   28.119508] [  216]     0   216     3010      751      14        0             0 dracut-initqueu
[   28.128320] [  225]     0   225     8160      652      19        0             0 udevadm
[   28.136434] [  226]     0   226     3257      241      10        0             0 systemd-cgroups
[   28.145245] Out of memory: Kill process 216 (dracut-initqueu) score 12 or sacrifice child
[   28.153444] Killed process 225 (udevadm) total-vm:32640kB, anon-rss:256kB, file-rss:2352kB
[   28.520126] dracut-initqueu invoked oom-killer: gfp_mask=0x2000d0, order=2, oom_score_adj=0
[   28.528504] dracut-initqueu cpuset=/ mems_allowed=0
[   28.533442] CPU: 0 PID: 216 Comm: dracut-initqueu Not tainted 3.19.0-rc2+ #93
[   28.540600] Hardware name: Hewlett-Packard HP Z420 Workstation/1589, BIOS J61 v01.02 03/09/2012
[   28.549324]  0000000000000000 000000000a9a4636 ffff880035bcba80 ffffffff8173f728
[   28.556830]  0000000000000000 ffff880035c3ed80 ffff880035bcbb20 ffffffff8173c406
[   28.564320]  0000000000000005 0000000035bcbbe0 0000000000000005 0000000000000282
[   28.571807] Call Trace:
[   28.574267]  [<ffffffff8173f728>] dump_stack+0x45/0x57
[   28.579422]  [<ffffffff8173c406>] dump_header+0x89/0x20a
[   28.584754]  [<ffffffff8118fb80>] oom_kill_process+0x240/0x390
[   28.590609]  [<ffffffff811903f2>] out_of_memory+0x502/0x540
[   28.596203]  [<ffffffff81195cc8>] __alloc_pages_nodemask+0x868/0xa30
[   28.602577]  [<ffffffff81195efd>] alloc_kmem_pages_node+0x6d/0x130
[   28.608786]  [<ffffffff81092753>] ? copy_process.part.26+0x113/0x1b70
[   28.615250]  [<ffffffff81092773>] copy_process.part.26+0x133/0x1b70
[   28.621540]  [<ffffffff8105d352>] ? __do_page_fault+0x202/0x5b0
[   28.627488]  [<ffffffff8130a77f>] ? selinux_inode_permission+0xaf/0x170
[   28.634125]  [<ffffffff81094371>] do_fork+0xe1/0x360
[   28.639116]  [<ffffffff810a3db6>] ? __set_current_blocked+0x36/0x50
[   28.645400]  [<ffffffff81094676>] SyS_clone+0x16/0x20
[   28.650472]  [<ffffffff817473a9>] stub_clone+0x69/0x90
[   28.655633]  [<ffffffff81747069>] ? system_call_fastpath+0x12/0x17
[   28.661827] Mem-Info:
[   28.664115] Node 0 DMA per-cpu:
[   28.667298] CPU    0: hi:    0, btch:   1 usd:   0
[   28.672106] Node 0 DMA32 per-cpu:
[   28.675449] CPU    0: hi:   90, btch:  15 usd:   0
[   28.680259] active_anon:697 inactive_anon:1027 isolated_anon:0
[   28.680259]  active_file:0 inactive_file:0 isolated_file:0
[   28.680259]  unevictable:39647 dirty:0 writeback:0 unstable:0
[   28.680259]  free:618 slab_reclaimable:2083 slab_unreclaimable:3424
[   28.680259]  mapped:1313 shmem:1037 pagetables:108 bounce:0
[   28.680259]  free_cma:0
[   28.711600] Node 0 DMA free:512kB min:4kB low:4kB high:4kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB s
[   28.749918] lowmem_reserve[]: 0 233 233 233
[   28.754205] Node 0 DMA32 free:1960kB min:1944kB low:2428kB high:2916kB active_anon:2788kB inactive_anon:4108kB active_file:0kB inactive_file:0kB unevictable:15858s
[   28.796590] lowmem_reserve[]: 0 0 0 0
[   28.800368] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 512kB
[   28.812229] Node 0 DMA32: 0*4kB 1*8kB (R) 0*16kB 1*32kB (R) 0*64kB 1*128kB (R) 1*256kB (R) 1*512kB (R) 1*1024kB (R) 0*2048kB 0*4096kB = 1960kB
[   28.825466] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[   28.833931] 40684 total pagecache pages
[   28.837781] 0 pages in swap cache
[   28.841115] Swap cache stats: add 0, delete 0, find 0/0
[   28.846359] Free swap  = 0kB
[   28.849254] Total swap = 0kB
[   28.852151] 65531 pages RAM
[   28.854959] 0 pages HighMem/MovableOnly
[   28.858813] 4986 pages reserved
[   28.861971] 0 pages hwpoisoned
[   28.865039] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
[   28.872893] [  209]     0   209     8857      920      20        0         -1000 systemd-udevd
[   28.881532] [  213]     0   213    28751      617      19        0             0 systemd-udevd
[   28.890168] [  214]     0   214     9769      616      19        0             0 systemd-udevd
[   28.898802] [  216]     0   216     3010      751      14        0             0 dracut-initqueu
[   28.907614] [  226]     0   226     3257      241      10        0             0 systemd-cgroups
[   28.916423] Out of memory: Kill process 216 (dracut-initqueu) score 12 or sacrifice child
[   28.924627] Killed process 216 (dracut-initqueu) total-vm:12040kB, anon-rss:564kB, file-rss:2440kB
[   28.934627] systemd-udevd invoked oom-killer: gfp_mask=0x2d2, order=0, oom_score_adj=0
[   28.942570] systemd-udevd cpuset=/ mems_allowed=0
[   28.947339] CPU: 0 PID: 213 Comm: systemd-udevd Not tainted 3.19.0-rc2+ #93
[   28.954321] Hardware name: Hewlett-Packard HP Z420 Workstation/1589, BIOS J61 v01.02 03/09/2012
[   28.963045]  0000000000000000 0000000040da54f4 ffff880035cdfa38 ffffffff8173f728
[   28.970550]  0000000000000000 ffff880035c3ada0 ffff880035cdfad8 ffffffff8173c406
[   28.978065]  0000000000000000 0000000035cdfb98 0000000000000000 0000000000000292
[   28.985534] Call Trace:
[   28.987984]  [<ffffffff8173f728>] dump_stack+0x45/0x57
[   28.993129]  [<ffffffff8173c406>] dump_header+0x89/0x20a
[   28.998451]  [<ffffffff8101de03>] ? check_tsc_unstable+0x3/0x10
[   29.004372]  [<ffffffff8118fb80>] oom_kill_process+0x240/0x390
[   29.010211]  [<ffffffff811903f2>] out_of_memory+0x502/0x540
[   29.015791]  [<ffffffff81195cc8>] __alloc_pages_nodemask+0x868/0xa30
[   29.022156]  [<ffffffff811dd161>] alloc_pages_current+0x91/0x100
[   29.028163]  [<ffffffff811cce52>] __vmalloc_node_range+0x1a2/0x280
[   29.034352]  [<ffffffff81110085>] ? copy_module_from_fd.isra.48+0xe5/0x180
[   29.041229]  [<ffffffff811cd19b>] vmalloc+0x4b/0x50
[   29.046110]  [<ffffffff81110085>] ? copy_module_from_fd.isra.48+0xe5/0x180
[   29.052998]  [<ffffffff81110085>] copy_module_from_fd.isra.48+0xe5/0x180
[   29.059714]  [<ffffffff811140df>] SyS_finit_module+0x6f/0xd0
[   29.065397]  [<ffffffff81747069>] system_call_fastpath+0x12/0x17
[   29.071421] Mem-Info:
[   29.073701] Node 0 DMA per-cpu:
[   29.076884] CPU    0: hi:    0, btch:   1 usd:   0
[   29.081696] Node 0 DMA32 per-cpu:
[   29.085044] CPU    0: hi:   90, btch:  15 usd:  63
[   29.089849] active_anon:582 inactive_anon:1027 isolated_anon:0
[   29.089849]  active_file:0 inactive_file:0 isolated_file:0
[   29.089849]  unevictable:39647 dirty:0 writeback:0 unstable:0
[   29.089849]  free:614 slab_reclaimable:2083 slab_unreclaimable:3424
[   29.089849]  mapped:1089 shmem:1037 pagetables:108 bounce:0
[   29.089849]  free_cma:0
[   29.121124] Node 0 DMA free:512kB min:4kB low:4kB high:4kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB s
[   29.159363] lowmem_reserve[]: 0 233 233 233
[   29.163652] Node 0 DMA32 free:1944kB min:1944kB low:2428kB high:2916kB active_anon:2328kB inactive_anon:4108kB active_file:0kB inactive_file:0kB unevictable:15858s
[   29.205958] lowmem_reserve[]: 0 0 0 0
[   29.209727] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 512kB
[   29.221567] Node 0 DMA32: 20*4kB (MR) 1*8kB (R) 0*16kB 0*32kB 1*64kB (R) 0*128kB 1*256kB (R) 1*512kB (R) 1*1024kB (R) 0*2048kB 0*4096kB = 1944kB
[   29.234944] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[   29.243391] 40684 total pagecache pages
[   29.247229] 0 pages in swap cache
[   29.250552] Swap cache stats: add 0, delete 0, find 0/0
[   29.255786] Free swap  = 0kB
[   29.258674] Total swap = 0kB
[   29.261563] 65531 pages RAM
[   29.264364] 0 pages HighMem/MovableOnly
[   29.268208] 4986 pages reserved
[   29.271355] 0 pages hwpoisoned
[   29.274418] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
[   29.282259] [  209]     0   209     8857      920      20        0         -1000 systemd-udevd
[   29.290873] [  213]     0   213    28751      617      19        0             0 systemd-udevd
[   29.299512] [  214]     0   214     9769      616      19        0             0 systemd-udevd
[   29.308149] [  226]     0   226     3257      241      10        0             0 systemd-cgroups
[   29.316962] [  231]     0   231     3257      235      12        0             0 systemd-cgroups
[   29.325773] Out of memory: Kill process 213 (systemd-udevd) score 10 or sacrifice child
[   29.333807] Killed process 213 (systemd-udevd) total-vm:115004kB, anon-rss:380kB, file-rss:2088kB
[  OK  ] Stopped Journa[   29.347845] isci 0000:02:00.0: OEM SAS parameters (version: 1.3) loaded (firmware)
l Service.
[   29.358130] systemd[1]: Starting Journal Service...
         Starting Journal Servic[   29.367713] vmalloc: allocation failure, allocated 49369088 of 82141184 bytes
e...
[   29.375098] systemd-udevd: page allocation failure: order:0, mode:0xd2
[   29.382169] CPU: 0 PID: 213 Comm: systemd-udevd Not tainted 3.19.0-rc2+ #93
[   29.389151] Hardware name: Hewlett-Packard HP Z420 Workstation/1589, BIOS J61 v01.02 03/09/2012
[   29.397874]  0000000000000000 0000000040da54f4 ffff880035cdfcf8 ffffffff8173f728
[   29.405367]  0000000000000000 00000000000000d2 ffff880035cdfd88 ffffffff81191ef9
[   29.412884]  ffffffff81a42ed0 ffff880035cdfd18 0000000000000018 ffff880035cdfd98
[   29.420383] Call Trace:
[   29.422842]  [<ffffffff8173f728>] dump_stack+0x45/0x57
[   29.428000]  [<ffffffff81191ef9>] warn_alloc_failed+0xf9/0x160
[   29.433858]  [<ffffffff811dd161>] ? alloc_pages_current+0x91/0x100
[   29.440054]  [<ffffffff811ccef8>] __vmalloc_node_range+0x248/0x280
[   29.446256]  [<ffffffff81110085>] ? copy_module_from_fd.isra.48+0xe5/0x180
[   29.453155]  [<ffffffff811cd19b>] vmalloc+0x4b/0x50
[   29.458054]  [<ffffffff81110085>] ? copy_module_from_fd.isra.48+0xe5/0x180
[   29.464950]  [<ffffffff81110085>] copy_module_from_fd.isra.48+0xe5/0x180
[   29.471674]  [<ffffffff811140df>] SyS_finit_module+0x6f/0xd0
[   29.477356]  [<ffffffff81747069>] system_call_fastpath+0x12/0x17
[   29.483380] Mem-Info:
[   29.485667] Node 0 DMA per-cpu:
[   29.488834] CPU    0: hi:    0, btch:   1 usd:   0
[   29.493642] Node 0 DMA32 per-cpu:
[   29.496982] CPU    0: hi:   90, btch:  15 usd:  53
[   29.501785] active_anon:582 inactive_anon:1027 isolated_anon:0
[   29.501785]  active_file:0 inactive_file:0 isolated_file:0
[   29.501785]  unevictable:39647 dirty:0 writeback:0 unstable:0
[   29.501785]  free:0 slab_reclaimable:1835 slab_unreclaimable:3404
[   29.501785]  mapped:1089 shmem:1037 pagetables:108 bounce:0
[   29.501785]  free_cma:0
[   29.532945] Node 0 DMA free:0kB min:4kB low:4kB high:4kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB iss
[   29.571086] lowmem_reserve[]: 0 233 233 233
[   29.575389] Node 0 DMA32 free:0kB min:1944kB low:2428kB high:2916kB active_anon:2328kB inactive_anon:4108kB active_file:0kB inactive_file:0kB unevictable:158588kBs
[   29.617544] lowmem_reserve[]: 0 0 0 0
[   29.621324] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 0kB
[   29.631920] Node 0 DMA32: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 0kB
[   29.642688] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[   29.651152] 40684 total pagecache pages
[   29.655003] 0 pages in swap cache
[   29.658334] Swap cache stats: add 0, delete 0, find 0/0
[   29.663583] Free swap  = 0kB
[   29.666476] Total swap = 0kB
[   29.669373] 65531 pages RAM
[   29.672182] 0 pages HighMem/MovableOnly
[   29.676039] 4986 pages reserved
[   29.679194] 0 pages hwpoisoned
[  OK  ] Started Journa[   29.686692] systemd-journald[232]: File /run/log/journal/5504ea9d96a745d3bfa88caececd2740/system.journal corrupted or uncleanly shut down, .
l Service.
[   29.703496] systemd[1]: Started Journal Service.
[  OK  ] Started dracut initqueue hook.
[  OK  ] Reached target Initrd Root File System.
         Starting Reload Configu[   29.726403] isci 0000:02:00.0: SCU controller 0: phy 3-0 cables: {short, short, short, short}
ration from the Real Root...
[  OK  ] Reached target Remote File Systems (Pre).
[  OK  ] Reached target Remote File Systems.
[   29.760493] scsi host7: ata_generic
[   29.771845] scsi host6: isci
[   29.780869] scsi host8: ata_generic
[   29.791001] ata7: PATA max UDMA/100 cmd 0xf0b0 ctl 0xf0a0 bmdma 0xf070 irq 18
[   29.798170] ata8: PATA max UDMA/100 cmd 0xf090 ctl 0xf080 bmdma 0xf078 irq 18
[  OK  ] Started Reload Configuration f[   29.817718] dmar: DRHD: handling fault status reg 702
[   29.823891] dmar: INTR-REMAP: Request device [[02:00.0] fault index 22
[   29.823891] INTR-REMAP:[fault reason 38] Blocked an interrupt request due to source-id verification failure
rom the Real Root.
[  OK  ] Reached target Initrd File Systems.
[  OK  ] Reached target Initrd Default Target.
[   30.249111] pps_core: LinuxPPS API ver. 1 registered
[   30.254100] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[   30.288618] PTP clock support registered
[   30.349920] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[   30.355764] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[   30.383553] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[   30.394670] tulip: Linux Tulip driver version 1.1.15 (Feb 27, 2007)
[   30.401642] tulip: tulip_init_one: Enabled WOL support for AN983B
[   30.407754] dmar: DRHD: handling fault status reg 2
[   30.412634] dmar: DMAR:[DMA Write] Request device [00:1e.0] fault addr 0 
[   30.412634] DMAR:[fault reason 05] PTE Write access is not set
[   30.426642] tulip 0000:09:04.0 (unnamed net_device) (uninitialized): tulip_stop_rxtx() failed (CSR5 0xfc0dc0d2 CSR6 0xff970111)
[   30.438566] tulip0:  MII transceiver #1 config 1000 status 786d advertising 05e1
[   30.462753] net eth0: ADMtek Comet rev 17 at MMIO 0xd7121000, 00:b0:c0:06:70:90, IRQ 20
[   30.548322] firewire_ohci 0000:09:05.0: added OHCI v1.0 device as card 0, 8 IR + 8 IT contexts, quirks 0x0
[   30.689459] e1000e 0000:00:19.0 eth1: registered PHC clock
[   30.694975] e1000e 0000:00:19.0 eth1: (PCI Express:2.5GT/s:Width x1) 80:c1:6e:f8:9f:92
[   30.702925] e1000e 0000:00:19.0 eth1: Intel(R) PRO/1000 Network Connection
[   30.711299] e1000e 0000:00:19.0 eth1: MAC: 10, PHY: 11, PBA No: 0100FF-0FF
[   30.822844] e1000e 0000:00:19.0 em1: renamed from eth1
[   30.828497] tulip 0000:09:04.0 p6p1: renamed from eth0
[   30.833799] systemd-udevd[233]: renamed network interface eth1 to em1
[   30.840351] systemd-udevd[214]: renamed network interface eth0 to p6p1
[   30.850352] iTCO_vendor_support: vendor-support=0
[   30.860111] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   30.865760] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
[   31.068066] firewire_core 0000:09:05.0: created device fw0: GUID 0060b000008cec98, S400

--qMm9M+Fa2AknHoGS--
