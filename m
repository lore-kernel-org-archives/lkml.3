Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbaLOJRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 04:17:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbaLOJRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 04:17:21 -0500
Date: Mon, 15 Dec 2014 17:16:23 +0800
From: Baoquan He <bhe@redhat.com>
To: "Li, ZhenHua" <zhen-hual@hp.com>
Cc: alex.williamson@redhat.com, Takao Indoh <indou.takao@jp.fujitsu.com>,
        tom.vaden@hp.com, dyoung@redhat.com, Joerg Roedel <joro@8bytes.org>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        lisa.mitchell@hp.com, jerry.hoemann@hp.com,
        iommu@lists.linux-foundation.org, ddutile@redhat.com,
        doug.hatch@hp.com, ishii.hironobu@jp.fujitsu.com,
        linux-pci@vger.kernel.org, bhelgaas@google.com, li.zhang6@hp.com,
        dwmw2@infradead.org, vgoyal@redhat.com
Subject: Re: [PATCH 0/5] iommu/vt-d: Fix crash dump failure caused by legacy
 DMA/IO
Message-ID: <20141215091623.GB12150@dhcp-16-116.nay.redhat.com>
References: <545ACF66.9050509@jp.fujitsu.com>
 <545AD061.4000102@hp.com>
 <545AD353.8060207@jp.fujitsu.com>
 <545AD8D3.90709@hp.com>
 <545B2885.8070009@jp.fujitsu.com>
 <545B2C07.1070701@hp.com>
 <5465A0E0.4020001@hp.com>
 <20141117133858.GA31920@8bytes.org>
 <20141210084652.GA25091@dhcp-16-105.nay.redhat.com>
 <548A521B.5020705@hp.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <548A521B.5020705@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 12/12/14 at 10:25am, Li, ZhenHua wrote:
> Sorry I have no plan yet.
> Could you send me your logs on your AMD system?

Sure, please check the attachment. AMD iommu seems a little different on
action. On the machine I reserved for testing, it always hang the system
bootup. As Joerg said, we can just know this issue, vt-d is still the
first thing.


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="amd-iommu.log"
Content-Transfer-Encoding: 8bit

[root@hp-sl4545g7-01 ~]# echo c >/proc/sysrq-trigger 
[ 4178.349174] SysRq : Trigger a crash
[ 4178.367887] BUG: unable to handle kernel NULL pointer dereference at           (null)
[ 4178.413933] IP: [<ffffffff813a80b6>] sysrq_handle_crash+0x16/0x20
[ 4178.449637] PGD 8219eb067 PUD 824b4f067 PMD 0 
[ 4178.475360] Oops: 0002 [#1] SMP 
[ 4178.494112] Modules linked in: cfg80211 sg rfkill kvm_amd kvm nfsd igb crct10dif_pclmul crc32_pclmul ptp crc32c_intel ghash_clmulni_intel auth_rpcgss aesni_intel pps_core dca ipmi_si hpwdt sp5100_tco lrw nfs_acl gf128mul hpilo pcspkr ipmi_msghandler serio_raw fam15h_power amd64_edac_mod glue_helper i2c_piix4 edac_mce_amd k10temp lockd edac_core ablk_helper cryptd shpchp sunrpc xfs libcrc32c radeon i2c_algo_bit drm_kms_helper ttm sd_mod ata_generic crc_t10dif pata_acpi ahci drm crct10dif_common libahci pata_atiixp libata hpsa i2c_core dm_mirror dm_region_hash dm_log dm_mod
[ 4178.785689] CPU: 1 PID: 1872 Comm: bash Not tainted 3.14.0+ #44
[ 4178.819575] Hardware name: HP ProLiant SL4545 G7/, BIOS A31 12/08/2012
[ 4178.856427] task: ffff88081ab9b680 ti: ffff880820360000 task.ti: ffff880820360000
[ 4178.899369] RIP: 0010:[<ffffffff813a80b6>]  [<ffffffff813a80b6>] sysrq_handle_crash+0x16/0x20
[ 4178.947941] RSP: 0018:ffff880820361e80  EFLAGS: 00010046
[ 4178.977106] RAX: 000000000000000f RBX: ffffffff81a0b6c0 RCX: 0000000000000000
[ 4179.018848] RDX: 0000000000000000 RSI: ffff88083ea0e708 RDI: 0000000000000063
[ 4179.059550] RBP: ffff880820361e80 R08: 0000000000000092 R09: 000000000000051b
[ 4179.099603] R10: 000000000000051a R11: 0000000000000003 R12: 0000000000000063
[ 4179.140142] R13: 0000000000000246 R14: 0000000000000007 R15: 0000000000000000
[ 4179.179475] FS:  00007f4edd746740(0000) GS:ffff88083ea00000(0000) knlGS:0000000000000000
[ 4179.225437] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4179.256725] CR2: 0000000000000000 CR3: 0000000821b75000 CR4: 00000000000406e0
[ 4179.297414] Stack:
[ 4179.308744]  ffff880820361eb8 ffffffff813a8882 0000000000000002 00007f4edd744000
[ 4179.349142]  ffff880820361f48 0000000000000002 0000000000000000 ffff880820361ed0
[ 4179.390914]  ffffffff813a8d8f ffff88082405fa40 ffff880820361ef0 ffffffff81236d5d
[ 4179.440766] Call Trace:
[ 4179.453918]  [<ffffffff813a8882>] __handle_sysrq+0xa2/0x170
[ 4179.485923]  [<ffffffff813a8d8f>] write_sysrq_trigger+0x2f/0x40
[ 4179.518602]  [<ffffffff81236d5d>] proc_reg_write+0x3d/0x80
[ 4179.548870]  [<ffffffff811ce0ea>] vfs_write+0xba/0x1e0
[ 4179.578130]  [<ffffffff811ceca5>] SyS_write+0x55/0xd0
[ 4179.606615]  [<ffffffff81636829>] system_call_fastpath+0x16/0x1b
[ 4179.640318] Code: 65 34 75 e5 4c 89 ef e8 d9 f7 ff ff eb db 0f 1f 80 00 00 00 00 66 66 66 66 90 55 c7 05 a0 d5 5b 00 01 00 00 00 48 89 e5 0f ae f8 <c6> 04 25 00 00 00 00 01 5d c3 66 66 66 66 90 55 31 c0 c7 05 1e 
[ 4179.748149] RIP  [<ffffffff813a80b6>] sysrq_handle_crash+0x16/0x20
[ 4179.783683]  RSP <ffff880820361e80>
[ 4179.802762] CR2: 0000000000000000
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.14.0+ (bhe@ibm-x3755m3-02.lab.bos.redhat.com) (gcc version 4.8.2 20140120 (Red Hat 4.8.2-13) (GCC) ) #44 SMP Thu Apr 10 22:28:02 EDT 2014
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.14.0+ root=/dev/mapper/rhel_hp--sl4545g7--01-root ro console=ttyS1,115200n81 rd.lvm.lv=rhel_hp-sl4545g7-01/root rd.lvm.lv=rhel_hp-sl4545g7-01/swap vconsole.font=latarcyrheb-sun16 vconsole.keymap=us LANG=en_US.UTF-8 irqpoll nr_cpus=1 reset_devices cgroup_disable=memory mce=off numa=off udev.children-max=2 panic=10 rootflags=nofail acpi_no_memhotplug disable_cpu_apicid=0 memmap=exactmap memmap=592K@4K memmap=523672K@311296K elfcorehdr=834968K memmap=192K#3141752K
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x0000000000094fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000095000-0x0000000000095bff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000098000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bfc1dfff] usable
[                         [mem 0x00000000bfc1e000-0x00000000bfc4dfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bfc4e000-0x00000000bfc4efff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bfc4f000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fee0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000083effefff] usable
[    0.000000] e820: last_pfn = 0x83efff max_arch_pfn = 0x400000000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: user-defined physical RAM map:
[    0.000000] user: [mem 0x0000000000001000-0x0000000000094fff] usable
[    0.000000] user: [mem 0x0000000013000000-0x0000000032f65fff] usable
[    0.000000] user: [mem 0x00000000bfc1e000-0x00000000bfc4dfff] ACPI data
[    0.000000] SMBIOS 2.6 present.
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x32f66 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    000] found SMP MP-table at [mem 0x000f4f60-0x000f4f6f] mapped at [ffff8800000f4f60]
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000] init_memory_mapping: [mem  0.000000] init_memory_mapping: [mem 0x30000000-0x32bfffff]
[    0.000000] init_memory_mapping: [mem 0x13000000-0x2fffffff]
[    0.000000] init_memory_mapping: [mem 0x32e00000-0x32f65fff]
[    0.000000] RAMDISK: [mem 0x2eb1b000-0x30ffefff]
[    0.000000] ACPI: RSDP 0x00000000000F4EE0 000024 (v02 HP    )
[    0.000000] ACPI: XSDT 0x00000000BFC213C0 0000A4 (v01 HP     ProLiant 00000002 �?   0000162E)
[    0.000000] ACPI: FACP 0x00000000BFC214C0 0000F4 (v03 HP     ProLiant 00000002 �?   0000162E)
[    0.000000] ACPI: DSDT 0x00000000BFC215C0 00CB98 (v01 HP     DSDT     00000001 INTL 20061109)
[    0.000000] ACPI: FACS 0x00000000BFC1E140 000040
[    0.000000] ACPI: SPCR 0x00000000BFC1E180 000050 (v01 HP     SPCRRBS00001 �?   0000162E)
[    0.000000] ACPI: MCFG 0x00000000BFC1E200 00003C (v01 HP     ProLiant 00000001      00000000)
[    0.000000] ACPI: HPET 0x00000000BFC1E240 000038 (v01 HP     ProLiant 00000002 �?   0000162E)
[    0.000000] ACPI: SPMI 0x00000000BFC1E280 000040 (v05 HP     ProLiant 00000001 �?   0000162E)
[    0.000000] ACPI: ERST 0x00000000BFC1E2C0 0001D0 (v01 HP     ProLiant 00000001 �? 0162E)
[    0.000000] ACPI: APIC 0x00000000BFC1E4C0 0000DE (v01 HP     ProLiant 00000002      00000000)
[    0.000000] ACPI: SRAT 0x00000000BFC1E7C0 0001D0 (vMD  00000001)
[    0.000000] ACPI: FFFF 0x00000000BFC1EFC0 000176 (v01 HP     ProLiant 00000001 �?   0000162E)
[    0.000000] ACPI: BERT 0x00000000BFC1F140 00(v01 HP     ProLiant 00000001 �?   0000162E)
[    0.000000] ACPI: HEST 0x00000000BFC1F180 00018C (v01 HP     ProLiant 00000001 �?   0000162E)
[    0.000000] ACPI: FFFF 0x00000000BFC1F340 000064 (v02 HP     ProLiant 00000002 �?   0000162E)
[    0.000000] ACPI: IVRS 0x00000000BFC1F3C0 000120 (v01 AMD    RD890S   00202031 AMD  00000000)
[    0.000000] ACPI: SSDT 0x00000000BFC2E180 00032C (v03 HP     Topaz    00000002 INTL 20090625)
[    0.000000] ACPI: SSDT 0x00000000BFC2E40125 (v03 HP     CRSPCI0  00000002 HP   00000001)
[    0.000000] ACPI: SSDT 0x00000000BFC2E600 0005E4 (v02 AMD    POWERNOW 00000001 AMD  00000001)
[    0.000000] NUMA turned off
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000032f65fff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x32f65fff]
[    0.000000]   NODE_DATA [mem 0x32f3f000-0x32f65fff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node   0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00094fff]
[    0.000000]   node   0: [mem 0x13000000-0x32f65fff]
[    0.000000] ACPI: PM-Timer IO Port: 0x920
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x10] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 almost reached. Keeping one slot for boot cpu.  Processor 0/0x10 ignored.


[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x20] enabled)


[    0.000000] ACPI: LAPIC (ac                             abled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 2/0x11 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x21] enab
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 3/0x21 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x12] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 4/0x12 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x22] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 5/0x22 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x13] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 6/0x13 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x23] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 7/0x23 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x14] enabled)
[         0.0] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 8/0x14 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x24] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 9/0x24 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x15] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 10/0x15 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x25] enabled)
[    0.000000] ACP     _CPUS/possible_cpus limit of 1 reached.  Processor 11/0x25 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x16] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 12/0x16 ignored.
[    0.00000                              lapic_id[0x26] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 13/0x26 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x17] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 14/0x17 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x27] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 15/0x27 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xefffc000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 33, address 0xefffc000, GSI 24-55
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] Using ACPI (MADT) for SMP configuratiformation
[    0.000000] ACPI: HPET id: 0x1166a201 base: 0xfed00000
[    0.000000] smpboot: 16 Processors exceeds NR_CPUS limit of 1
[    0.000000] smpboot: Us
[    0.000000] PM: Registered nosave memory: [mem 0x00095000-0x12ffffff]
[    0.000000] e820: [mem 0x32f66000-0xbfc1dfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:1 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff880032c00000 s87168 r8192 d23424 u2097152
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 128995
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.14.0+ root=/dev/mapper/rhel_hp--sl4545g7--01-root ro console=ttyS1,115200n81 rd.lvm.lv=rhel_hp-sl4545g7-01/root rd.lvm.lv=rhel_hp-sl4545g7-01/swap vconsole.font=latarcyrheb-sun16 vconsole.keymap=us LANG=en_US.UTF-8 irqpoll nr_cpus=1 reset_devices cgroup_disable=memory mce=off numa=off udev.children-max=2 panic=10 rootflags=nofail acpi_no_memhotplug disable_cpu_apicid=0 memxactmap memmap=592K@4K memmap=523672K@311296K elfcorehdr=834968K memmap=192K#3141752K
[    0.000000] Misrouted IRQ fixup and polling support enabled
[    0.000000] This may significantly impact system performance
[    0.000000] Disabling memory control group subsystem
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] xsave: enablex340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ b4000000 size 64 MB
[    0.000000] Node 1: aperture @ b4000000 size 64 MB
[    0.000000] Memory: 458152K/524264K available (6379K kernel code, 1380K rwdata, 2988K rodata, 1676K init, 2944K bss, 66112K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=1.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=1
[    0.000000] NR_IRQS:524544 nr_irqs:256 16
[    0.000000] Spurious LAPIC timer interrupt on cpu 0
[    0.000000] do_IRQ: 0.202 No irq handler for vector (irq -1)
[   0000] do_IRQ: 0.154 No irq handler for vector (irq -1)
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS1] enabled
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2506.394 MHz processor
[    0.000033] Calibrating delay loop (skipped), value calculated using timer frequency.. 5012.78 BogoMIPS (lpj=2506394)
[    0.007148] pid_max: default: 32768 minimum: 301
[    0.010124] ACPI: Core revision 20140214
[    0.025906] A acquired
[    0.627490] Security Framework initialized
[    0.630168] SELinux:  Initializing.
[    0.632593] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.637286] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.642511] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.646650] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.651427] Initializing cgroup subsys memory
[    0.654463] Initializing cgroup subsys devices
[    0.657332] Initializing cgroup subsys freezer
[    0.660106] Initializing cgroup subsys net_cls
[    0.663091] Initializing cgroup subsys blkio
[    0.665651] Initializing cgroup subsys perf_event
[    0.669029] Initializing cgroup subsys hugetlb
[    0.672217] CPU: Physical Processor ID: 1
[    0.674831] CPU: Processor Core ID: 0
[    0.677093] Last level iTLB entries: 4KB 512, 2MB 1024, 4MB 512
[    0.677093] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 512, 1GB 0
[    093] tlb_flushall_shift: 6
[    0.792301] Freeing SMP alternatives memory: 24K (ffffffff81c27000 - ffffffff81c2d000)
[    0.798377] ftrace: allocating 24373 entries in 96 pages
[    0.927896] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.942115] smpboot: CPU0: AMD Opteron(tm) Processor 4274 HE (fam: 151, stepping: 02)
[    1.351672] Performance Events: Fam15h core perfctr, Broken PMU hardware detected, using software events only.
[    1.358393] Failed to access perfctr msr (MSR c0010201 is 1454e2dbae)
[    1.364294] x86: Booted up 1 node, 1 CPUs
[    1.367058] smpboot: Total of 1 processors activated (5012.78 BogoMIPS)
[    1.371466] NMI watchdog: disabled (cpu0): hardware events not enabled
[    1.378076] devtmpfs: initialized
[    1.383473] evm: security.selinux
[    1.385624] evm: security.ima
[    1.387498] evm: security.capability
[    1.391043] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    1.395519] NET: Registered protocol family 16
[    1.398594] cpuidle: using governor menu
[    1.401580] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    1.406934] ACPI: bus type PCI registered
[    1.409386] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.413617] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xc0000000-0xcfffffff] (base 0xc0000000)
[    1.420000] PCI: not using MMCONFIG
[    1.422259] PCI: Using configuration type 1 for base access
[    1.425649] PCI: Un type 1 for extended access
[    1.930531] ACPI: Added _OSI(Module Device)
[    1.933436] ACPI: Added _OSI(Processor Device)
[    1.936325] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.939544] ACPI: Added _OSI(Processor Aggregator Device)
[    1.965513] ACPI: Interpreter enabled
[    1.967974] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140214/hwxface-580)
[    1.974458] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140214/hwxface-580)
[    1.980534] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20140214/hwxface-580)
[    1.986776] ACPI: (supports S0 S4 S5)
[    1.989269] ACPI: Using IOAPIC for interrupt routing
[    1.992497] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xc0000000-0xcfffffff] (base 0xc0000000)
[    1.999678] PCI: MMCONFIG at [mem 0xc0000000-0xcfffffff] reserved in ACPI motherbo resources
[    2.114467] HEST: Table parsing has been initialized.
[    2.118191] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    2.141286] acpi LNXCPU:08: BIOS reported wrong ACPI id 0 for the processor
[    2.147115] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
[    2.151455] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    2.156995] acpi PNP0A08:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    2.161350] acpi PNP0A08:00: host bridge window expanded to [fed44fff]; [mem 0xfed00000-0xfed03fff] ignored
[    2.667996] PCI host bridge to bus 0000:00
[    2.670628] pci_bus 0000:00: root bus resource [bus 00-3f]
[    2.674083] pci_bus 0000:00: root bus resource [mem 0xeff00000-0xfdffffff]
[     .678501] pci_bus 0000:00: root bus resource [io  0x1000-0xffff]
[    2.782315] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
[    2.786399] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
[    2.790547] pci_bus 0000:00: root bus resource [io  0x0d00-0x0fff]
[    2.794493] pci_bus 0000:00: root bus resource [mem 0xfed00000-0xfed44fff]
[    2.799305] pci_bus 0000:00: root bus resource [io  0x03b0-0x03bb]
[    2.803345] pci_bus 0000:00: root bus resource [io  0x03c0-0x03df]
[    2.807310] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    2.812540] pci00:00:04.0: System wakeup disabled by ACPI
[    2.919628] pci 0000:00:0c.0: System wakeup disabled by ACPI
[    2.929249] pci 0000:00:14.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    2.934138] pci 0000:00:14.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    2.938688] pci 0000:00:14.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    2.943285] pci 0000:00:14.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    2.952172] pci 0000:00:04.0: PCI bridge to [bus 03]
[    2.958176] pci 0000:00:09.0: PCI bridge to [bus 02]
[    2.963177] pci 0000:00:0c.0: PCI bridge to [bus 05-07]
[    2.966917] pci 0000:00:14.4: PCI bridgetractive decode)
[    3.471279] ACPI: PCI Interrupt Link [I020] (IRQs *24)
[    3.475389] ACPI: PCI Interrupt Link [I021] (IRQs *25)
[    3.479726] ACPI: PCI Interrupt Link [I022] (IRQs *26)
[    3.484054] ACPI: PCI Interrupt Link [I023] (IRQs *27)
[    3.488439] ACPI: PCI Interrupt Link [I030] (IRQs *28)
[    3.492623] ACPI: PCI Interrupt Link [I031] (IRQs *29)
[    3.496977] ACPI: PCI Interrupt Link [I032] (IRQs *30)
[    3.500988] ACPI: PCI Interrupt Link [I033] (IRQs *31)
[    3.504994] ACPI: PCI Interrupt Link [I040] (IRQs *44)
[    3.509352] ACPI: PCI Interrupt Link [I041] (IRQs *45)
[    3.513203] ACPI: PCI Interrupt Link [I042] (IRQs *46)
[    3.517714] ACPI: PCI Interrupt Link [I043] (IRQs 7)
[    3.621732] ACPI: PCI Interrupt Link [I050] (IRQs *48)
[    3.625696] ACPI: PCI Interrupt Link [I051] (IRQs *49)
[    3.629781] ACPI: PCI Interrupt Link [I052] (IRQs *50)
[    3.633765] ACPI: PCI Interrupt Link [I053] (IRQs *51)
[    3.637955] ACPI: PCI Interrupt Link [I060] (IRQs *47)
[    3.642099] ACPI: PCI Interrupt Link [I061] (IRQs *44)
[    3.645885] ACPI: PCI Interrupt Link [I062] (IRQs *45)
[    3.650283] ACPI: PCI Interrupt Link [I063] (IRQs *46)
[    3.654223] ACPI: PCI Interrupt Link [I070] (IRQs *24)
[    3.658342] ACPI: PCI Interrupt Link [I071] (IRQs *25)
[    3.662] ACPI: PCI Interrupt Link [I072] (IRQs *26)
[    3.766361] ACPI: PCI Interrupt Link [I073] (IRQs *27)
[    3.770121] ACPI: PCI Interrupt Link [I090] (IRQs *24)
[    3.773935] ACPI: PCI Interrupt Link [I091] (IRQs *24)
[    3.777647] AC Link [I092] (IRQs *24)
[    4.280511] ACPI: PCI Interrupt Link [I093] (IRQs *24)
[    4.284446] ACPI: PCI Interrupt Link [I0A0] (IRQs *24)
[    4.288967] ACPI: PCI Interrupt Link [I0A1] (IRQs *25)
[    4.293065] ACPI: PCI Interrupt LinI0A2] (IRQs *26)
[    4.397075] ACPI: PCI Interrupt Link [I0A3] (IRQs *27)
[    4.401209] ACPI: PCI Interrupt Link [I0B0] (IRQs *32)
[    4.405094] ACPI: PCI Interrupt Link [I0B1] (IRQs *33)
[    4.409536] ACPI: PCI Interrupt Link [I0B2] (IRQs *34)
[    4.413522] ACPI: PCI Interrupt Link [I0B3] (IRQs *35)
[    4.417983] ACPI: PCI Interrupt Link [I0C0] (IRQs *36)
[    4.422227] ACPI: PCI Interrupt Link [I0C1] (IRQs *37)
[    4.426460] ACPI: PCI Interrupt Link [I0C2] (IRQs *38)
[    4.430709] ACPI: PCI Interrupt Link [I0C3] (IRQs *39)
[    4.434794] ACPI: PCI Interrupt Link [I0D0] (IRQs *40)
[    4.439055] ACPI: PCI Interrupt Link [I0D1] (IRQs *41)
[    4.443137] ACPI: PCI Interrupt Link [I0D2] (IRQs 2)
[    4.547413] ACPI: PCI Interrupt Link [I0D3] (IRQs *43)
[    4.551066] ACPI: PCI Interrupt Link [BI02] (IRQs *52)
[    4.554707] ACPI: PCI Interrupt Link [BI03] (IRQs *52)
[    4.558469] ACPI: PCI Interrupt Link [BI04] (IRQs *52)
[    4.561824] ACPI: PCI Interrupt Link [BI05] (IRQs *52)
[    4.565736] ACPI: PCI Interrupt Link [BI06] (IRQs *54)
[    4.569260] ACPI: PCI Interrupt Link [BI07] (IRQs *24)
[    4.573042] ACPI: PCI Interrupt Link [BI08] (IRQs *24)
[    4.576989] ACPI: PCI Interrupt Link [BI09] (IRQs *24)
[    4.580534] ACPI: PCI Int] (IRQs *24)
[    5.083418] ACPI: PCI Interrupt Link [BI0B] (IRQs *54)
[    5.087056] ACPI: PCI Interrupt Link [BI0C] (IRQs *54)
[    5.090859] ACPI: PCI Interrupt Link [BI0D] (IRQs *54)
[    5.094518] ACPI: PCI Interrupt Link [PI20] (IRQs 10 11) *0, disabled.
[    5.099246] ACPI: PCI Interrupt Link [PI21] (IRQs 10 11) *0, disabled.
[    5.103746] ACPI: PCI Interrupt Link [PI22] (IRQs 10 11) *0, disabled.
[    5.108479] ACPI: PCI Intept Link [PI23] (IRQs 10 11) *0, disabled.
[    5.212840] ACPI: PCI Interrupt Link [PI30] (IRQs 10 11) *0, disabled.
[    5.217691] ACPI: PCI Interrupt Link [PI31] (IRQs 10 11) *0, disabled.
[    5.222507] ACPI: PCI Interrupt Link [PI32] (IRQs 10 11) *0, disabled.
[    5.227253] ACPI: PCI Interrupt Link [PI33] (IRQs 10 11) *0, disabled.
[    5.231751] ACPI: PCI Interrupt Link [PI40] (IRQs 10 11) *0, disabled.
[    5.236118] ACPI: PCI Interrupt Link [PI41] (IRQs 10 11) *0isabled.
[    5.340898] ACPI: PCI Interrupt Link [PI42] (IRQs 10 11) *0, disabled.
[    5.345402] ACPI: PCI Interrupt Link [PI43] (IRQs 10 11) *0, disabled.
[    5.350108] ACPI: PCI Interrupt Link [PI50] (IRQs 10 11) *0, disabled.
[    5.354753] ACPI: PCI Interrupt Link [PI51] (IRQs 10 11) *0, disabled.
[    5.359250] ACPI: PCI Interrupt Link [PI52] (IRQs 10 11) *0, disabled.
[    5.363485] ACPI: PCI Interrupt Link [PI53] (IRQs 10 11) *0, disabled.
[    5.368310] ACPI:[PI60] (IRQs 10 11) *0, disabled.
[    5.971520] ACPI: PCI Interrupt Link [PI61] (IRQs 10 11) *0, disabled.
[    5.975903] ACPI: PCI Interrupt Link [PI62] (IRQs 10 11) *0, disabled.
[    5.980527] ACPI: PCI Interrupt Link [PI63] (IRQs 10 11) *0, disabled.
[    5.985288] ACPI: PCI Interrupt Link [PI70] (IRQs 10 11) *0, disabled.
[    5.989712] ACPI: PCI Interrupt Link [PI71] (IRQs 10 11) *0, disabled.
[    5.994755] ACPI: PCI Interrupt Link [PI72] (IRQs 10 11) *0, disab.
[    6.099106] ACPI: PCI Interrupt Link [PI73] (IRQs 10 11) *0, disabled.
[    6.103898] ACPI: PCI Interrupt Link [PI90] (IRQs 10 11) *0, disabled.
[    6.108666] ACPI: PCI Interrupt Link [PI91] (IRQs 10 11) *0, disabled.
[    6.113077] ACPI: PCI Interrupt Link [PI92] (IRQs 10 11) *0, disabled.
[    6.117740] ACPI: PCI Interrupt Link [PI93] (IRQs 10 11) *0, diled.
[    6.222014] ACPI: PCI Interrupt Link [PIA0] (IRQs 10 11) *0, disabled.
[    6.226912] ACPI: PCI Interrupt Link [PIA1] (IRQs 10 11) *0, disabled.
[    6.231675] ACPI: PCI Interrupt Link [PIA2] (IRQs 10 11) *0, disabled.
[    6.236323] ACPI: PCI Interrupt Link [PIA3] (IRQs 10 11) *0, disabled.
[    6.240599] ACPI: PCI Interrupt Link [PIB0] (IRQs 10 11) *0, disabled.
[    6.245313] ACPI: PCI Interrupt Link [PIB1] (IRQs 10 11) *0, disabled.
[    6.249996] ACPI: PCI Interrupt Link [PIB2] (IRQs 10 11) *0, disabled.
[    6.254706] ACPI: PCI Interrupt Link [PIB3] (IRQs 10 11) *0, disabled.
[    6.259228] ACPI: PCI Interrupt disabled.
[    7.262024] ACPI: PCI Interrupt Link [PIC1] (IRQs 10 11) *0, disabled.
[    7.266934] ACPI: PCI Interrupt Link [PIC2] (IRQs 10 11) *0, disabled.
[    7.271554] ACPI: PCI Interrupt Link [PIC3] (IRQs 10 11) *0, disabled.
[    7.276061] ACPI: PCI Interrupt Link [PID0] (IRQs 10 11) *0, disabled.
[    7.280750] ACPI: PCI Interrupt Link [PID1] (IRQs 10 11) *0, disabled.
[    7.285684CPI: PCI Interrupt Link [PID2] (IRQs 10 11) *0, disabled.
[    7.390177] ACPI: PCI Interrupt Link [PID3] (IRQs 10 11) *0, disabled.
[    7.397006] ACPI: PCI Interrupt Link [PIR2] (IRQs 10 11) *0, disabled.
[    7.401912] ACPI: PCI Interrupt Link [PIR3] (IRQs 10 11) *0, disabled.
[    7.406146] ACPI: PCI Interrupt Link [PIR4] (IRQs 10 11) *0, disabled.
[    7.410733] ACPI: PCI Interrupt Link [PIR5] (IRQs 10 11) *0, disabled.
[    7.415144] ACPI: PCI Interrupt Link [PIR6] (IRQs 10 11) *0, disabled.
[    7.419885] ACPI: PCI Interrupt Link [PIR7] (IRQs 10 11) *0, disabled.
[    7.424253] ACPI: PCI Interrupt Link [PIR8] (IRQs 10 11) *0, disabled.
[    7.428852] ACPI: PCI Interrupt Link [PIR9] (IRQs 10 11) *0, disabled.
[    7.433706] ACPI: PCI Interrupt Link [PIRA] (IRQs 10 11) *0, dbled.
[    7.537878] ACPI: PCI Interrupt Link [PIRB] (IRQs 10 11) *0, disabled.
[    7.542699] ACPI: PCI Interrupt Link [PIRC] (IRQs 10 11) *0, disabled.
[    7.547492] ACPI: PCI Interrupt Link [PIRD] (IRQs 10 11) *0, disabled.
[    7.552338] ACPI: PCI Interrupt Link [USB1] (IRQs *22) ACPI: PCI Interrupt Link [USB2] (IRQs *23)
[    8.058474] ACPI: PCI Interrupt Link [USB3] (IRQs *23)
[    8.062291] ACPI: PCI Interrupt Link [USB4] (IRQs *22)
[    8.065881] ACPI: Invalid _PRS IRQ 0
[    8.068291] ACPI: PCI Interrupt Link [U1PI] (IRQs) *0
[    8.071798] ACPI: Invalid _PRS IRQ 0
[    8.074335] ACPI: PCI Interrupt Link [U2PI] (IRQs) *0
[    8.077704] ACPI: Invalid _PRS IRQ 0
[    8.080600] ACPI: PCI Interrupt Link [U3PI] (IRQs) *0
[    8.084556] ACPI: Invalid _PRS IRQ 0
[    8.087022] ACPI: PCI Interrupt Link [U4PI] (IRQs) *0
[ 8.090832] ACPI: PCI Interrupt Link [SATA] (IRQs *16)
[    8.194012] ACPI: Invalid _PRS IRQ 0
[    8.196509] ACPI: PCI Interrupt Link [SATP] (IRQs) *0
[    8.200105] ACPI: PCI Interrupt Link [VIDA] (IRQs *16)
[    8.203923] ACPI: Invalid _PRS IRQ 0
[    8.206257] ACPI: PCI Interrupt Link [VIDP] (IRQs) *0
[    8.209994] vgaarb: device added: PCI:0000:01:03.0,decodes=io+mem,owns=io+mem,locks=none
[    8.215626] vgaarb: loaded
[    8.217382] vgaarb: bridge control possible 0000:01:03.0
[    8.220904] SCSI subsystem initialized
[    8.223708] ACPI: bus type USB registered
[    8.226322] usbcore: registered new interface driver usbfs
[    8.230001] usbcore: registered new interface driver hub
[    8.238] usbcore: registered new device driver usb
[    8.336973] PCI: Using ACPI for IRQ routing
[    8.349186] NetLabel: Initializing
[    8.351685] NetLabel:  domain hash size = 128
[    8.354606] NetLabel:  protocols = UNLABELED CIPSOv4
[    8.357709] NetLabel:  unlabeled traffic allowed by default
[    8.361553] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    8.365230] hpet0: 4 comparators, MHz counter
[    8.870464] Switched to clocksource hpet
[    8.873152] Could not create debugfs 'set_ftrace_filter' entry
[    8.876950] Could not create debugfs 'set_ftrace_notrace' entry
[    8.890237] pnp: PnP ACPI init
[    8.892306] ACPI: bus type PNP registered
[    8.898120] system 00:00: [io  0x0379-0x037a] has been reserved
[    8.902239] system 00:00: [io  0x0400-0x043f] has been reserved
[    8.906005] system 00:00: [io  0x04d0-0x04d1] has been reserved
[    8.910015] system 00:00: [io  0x04d6] has been erved
[    9.013459] system 00:00: [io  0x0520] has been reserved
[    9.017006] system 00:00: [io  0x0580-0x059f] has been reserved
[    9.020982] system 00:00: [io  0x0600-0x067f] has been reserved
[    9.024787] system 00:00: [io  0x0700-0x0703] has been reserved
[    9.028653] system 00:00: [io  0x0820-0x082f] has been reserved
[    9.032639] system 00:00: [io  0x0900-0x09fe] has been reserved
[    9.036446] system 00:00: [io  0x0c06-0x0c07] has been reserved
[    9.040408] system 00:00: [io  0x0c14] has been reserved
[    9.043739] system 00:00: [io  0x0c4a] has been reserved
[    9.047079] system 00:00: [io  0x0c50-0x0c52] has been reserved
[    9.051051] system 00:00: [io  0x0c6c] has been reserved
[    9.054652] system 00:00: [io  0x0c6f] has been reserved
[    9.058102] system 00:00: [io  0x0c80-0x0c83] has been reserved
[    9.061914] system 00: [io  0x0c90-0x0c9f] has been reserved
[    9.165662] system 00:00: [io  0x0ca0-0x0ca5] has been reserved
[    9.169510] system 00:00: [io  0x0cd0-0x0cdf] h
                                                  [    9.672354] system 00:00: [io  0x0f50-0x0f58] has been reserved
[    9.676229] system 00:00: [io  0x0b00-0x0b3f] has been reserved
[    9.680245] system 00:00: [io  0x02f8-0x02ff] has been reserved
[    9.684017] system 00:00: [mem 0xc0000000-0xcfffffff] has been reserved
[    9.689054] pnp: PnP ACPI: found 9 devices
[    9.691855] ACPI: bus type PNP unregistered
[    9.700989] pci 0000:03:00.0: BAR 6: assigned [mem 0xf8000000-0xf801ffff pref]
[    9.705799] pci 0000:03:00.1: BAR 6: assigned [mem 0xf8020000-0xf803ffff pref]
[    9.710731] pci00:00:04.0: PCI bridge to [bus 03]
[    9.813997] pci 0000:00:04.0:   bridge window [io  0x4000-0x4fff]
[    9.818083] pci 0000:00:04.0:   bridge window [mem 0xfdd00000-0xfddfffff]
[    9.822289] pci 0000:00:04.0:   bridge window [mem 0xf8000000-0xf80fffff 64bit pref]
[    9.827099] pci 0000:02:00.2: BAR 6: assigned [mem 0xf8100000-0xf810ffff pref]
[    9.831732ci 0000:00:09.0: PCI bridge to [bus 02]
[    9.937039] pci 0000:00:09.0:   bridge window [io  0x3000-0x3fff]
[    9.944205] pci 0000:00:09.0:   bridge window [mem 0xfda00000-0xfdcfffff]
[    9.948598] pci 0000:00:09.0:   bridge window [mem 0xf8100000-0xf81fffff 64bit pref]
[    9.953857] pci 0000:05:00.0: BAR 6: assigned [mem 0xf8200000-0xf827ffff pref]
[    9.958558] pci 0000:00:0c.0: PCI bridge to [bus 05-07]
[    9.961974] pci 0000:00:0c.0:   bridge window [io  0x500x5fff]
[   10.065896] pci 0000:00:0c.0:   bridge window [mem 0xfde00000-0xfdffffff]
[   10.070386] pci 0000:00:0c.0:   bridge window [mem 0xf8200000-0xf82fffff 64bit pref]
[   10.075435] pci 0000:01:03.0: BAR 6: assigned [mem 0xfd900000[   10.623476] pci 0000:00:14.4: PCI bridge to [bus 01]
[   10.682050] pci 0000:00:14.4:   bridge window [io  0x2000-0x2fff]
[   10.686038] pci 0000:00:14.4:   bridge window [mem 0xfd900000-0xfd9fffff]
[   10.690572] pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xf7ffffff pref]
[   10.695581] NET: Registered protocol family 2
[   10.698756] TCP established hash table entries: 4096 (order: 3, 32768 bytes)
[   10.703612] TCP bind hash table entries: 4096 (order: 4, 65536 bytes)
[   10.707852] TCP: Hash tables configured (established 4096 bind 4096)
[   10.711713] TCP: reno registered
[   10.713678] UDP hash table entries: 256 (order: 1, 8192 bytes)
[   10.717419] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
[   10.721428] NET: Registered protocol family 1
[   10.749] ACPI: PCI Interrupt Link [USB1] enabled at IRQ 22
[   10.929970] ACPI: PCI Interrupt Link [USB2] enabled at IRQ 23
[   10.934183] ACPI: PCI Interrupt Link [USB3] enabled at IRQ 23
[   11.040233] ACPI: PCI Interrupt Link [USB4] enabled at IRQ 22
[   11.044666] ACPI: PCI Interrupt Link [BI09] enabled at IRQ 24
[   11.049131] ACPI: PCI Interrupt Link [I051] enabled at IRQ 49
[   11.052982] Unpacking initramfs...
[   11.972263] Freeing initrd memory: 37776K (ffff88002eb1b000 - ffff880030fff000)
[   11.977704] pci 0000:00:00.2: can't derive routing for PCI INT A
[   11.981810] pci 0000:00:00.2: PCI INT A: no GSI
[   11.984956] AMD-Vi: Found IOMMU at 0000:00:00.2 cap 0x40
[   11.988564] AMD-Vi: Interrupt remapping enabled
[   12.003601] AMD-Vi: Lazy IO/TLB flushing enabled
[   12.120720] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0xf8e8565064c083f0 flags=0x0030]
[   12.128038] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0xf8e8565064c08420 flags=0x0030]
[   12.134941] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0xf8e8565064c08400 flags=0x0030]
[   12.141531] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x00000000000092e0 flags=0x0020]
[   12.148287] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x0604c600003a99e0 flags=0x0030]
[   12.155299] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x0604c600003a99f0 flags=0x0030]
[   12.161947] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x0604c600003a9a20 flags=0x0030]
[   12.168775] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x0604c600003a9a00 flags=0x0030]
[   12.175475] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x00000000000092f0 flags=0x0020]
[   12.182097] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x890010fbd4b855c0 flags=0x0030]
[   12.189011] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x890010fbd4b855d0 flags=0x0030]
[   12.195961] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x890010fbd4b855f0 flags=0x0030]
[   12.203214] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x890010fbd4b855e0 flags=0x0030]
[   12.210661] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x0000000000009300 flags=0x0020]
[   12.217956] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x011178a31cec8350 flags=0x0030]
[   12.225440] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x011178a31cec8360 flags=0x0030]
[   12.232421] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x011171cec8380 flags=0x0030]
[   12.339505] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x0000000000009310 flags=0x0020]
[   12.346535]D-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x018be800009164b0 flags=0x0030]
[   12.453330] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x018be800009164f0 flags=0x0030]
[   12.460642] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x018be800009164c0 flags=0x0030]
[   12.467656] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x018be800009164e0 flags=0x0030]
[   12.47nt logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x0000000000009320 flags=0x0020]
[   12.980420] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x588d0000fbdca1c0 flags=0x0030]
[   12.987240] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x588d0000fbdca1e0 flags=0x0030]
[   12.994614] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x588d0000fbdca1d0 flags=0x0030]
[   13.001562] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x588d0000fbdca200 flags=0x0030]
[   13.008847] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x0000000000009330 flags=0x0020]
[   13.015929] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0xe04589410000fbe0 flags=0x0030]
[   13.022474] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x1 address=0xe04589410000fc10 flags=0x0030]
[   13.129150] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0xe04589410000fc00 flags=0x0030]
[   13.135994] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0lags=0x0020]
[   13.543695] NMI: PCI system error (SERR) for reason b1 on CPU 0.
[   13.543696] Dazed and confused, but trying to continue
[   14.147540] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x7a8b1976183bf850 flags=0x0030]
[   14.154396] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x7a8b1976183bf890 flags=0x0030]
[   14.161117] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x7a8b1976183bf860 flags=0x0030]
[   14.167816] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x7a8b1976183bf880 flags=0x0030]
[   14.174552] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x0000000000009350 flags=0x0020]
[   14.181092] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain0011 address=0x8bfc7a89f8728900 flags=0x0030]
[   14.287803] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x8bfc7a89f8728910 flags=0x0030]
[   14.294624] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x8bfc7a89f8728920 flags=0x0030]
[   14.301468] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x0000000000009360 flags=0x0020]
[   14.308430] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 dess=0x000000000000ded0 flags=0x0020]
[   14.814443] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x00000000011a6000 flags=0x0020]
[   14.821707] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x00000000011a6040 flags=0x0020]
[   14.828354] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x00000000011a6070 flags=0x0020]
[   14.835271] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x00000000011a6060 flags=0x0020]
[   14.842086] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0xeb08c283d6eb08c0 flags=0x0030]
[   14.848535] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0xeb08c283d6eb08e0 flags=0x0030]
[   14.855342] AMD-Vi: Event logged [IO_PAGE_FAULT dee=03:00.0 domain=0x0011 address=0xeb08c283d6eb08f0 flags=0x0030]
[   14.962002] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x0000000000009370 flags=0x0020]
[   14.968587] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x5c7dc339ff418d00 flags=0x0030]
[   14.975E_FAULT device=03:00.0 domain=0x0011 address=0x5c7dc339ff418d20 flags=0x0030]
[   15.980586] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x5c7dc339ff418d30 flags=0x0030]
[   15.987340] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x0000000000009380 flags=0x0020]
[   15.994556] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x00fbe4dd3c8b0150 flags=0x0030]
[   16.001741] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x00fbe4dd3c8b0160 flags=0x0030]
[   16.008421] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x00fbe4dd3c8b0180 flags=0x0030]
[   16.015075] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x0000000000009390 flagx0020]
[   16.121867] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x00000000011a7000 flags=0x0020]
[   16.129426] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x000000000000dee0 flags=0x0020]
[   16.136099] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x00000000011a7040 flags=0x0020]
[   16.142764] AMD-Vi: Event logged [IO_PAGE_FAULTomain=0x0011 address=0x00000000011a7050 flags=0x0020]
[   16.648593] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x34033b72f739c700 flags=0x0030]
[   16.655172] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x34033b72f739c720 flags=0x0030]
[   16.661912] AMD-Vi: Event logged [IO_PAGE_FT device=03:00.0 domain=0x0011 address=0x34033b72f739c730 flags=0x0030]
[   16.768639] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x34033b72f739c710 flags=0x0030]
[   16.775296] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x00000000000093a0 flags=0x0020]
[   16.782052] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0xfbe4dd3489c62900 flags=0x0030]
[   16.788777] AMD-Vi: Event logged [IO_P_FAULT device=03:00.0 domain=0x0011 address=0xfbe4dd3489c62920 flags=0x0030]
[   16.895348] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0xfbe4dd3489c62910 flags=0x0030]
[   16.902139] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0xfbe4dd3489c62940 flags=0x0030]
[   16.908974] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x0000000000009440 flags=0x0000]
[   16.915537] AMD-Vi: Event logged evice=03:00.0 domain=0x0011 address=0x0000000000009480 flags=0x0000]
[   17.421968] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x0000000000009500 flags=0x0000]
[   17.428958] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x00000000000094c0 flags=0x0000]
[   17.436412] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 addr=0x00000000000093b0 flags=0x0020]
[   17.543604] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0xfff8cd0c8dd12900 flags=0x0030]
[   17.550876] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0xfff8cd0c8dd12920 flags=0x0030]
[   17.558138] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0xfff8cd0c8dd12930 flags=0x0030]
[   17.565007] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x00000000000093c0 flags=0x0020]
[   17.913] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x1de80000fbd80500 flags=0x0030]
[   17.678614] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x1de80000fbd80530 flags=0x0030]
[   17.685222] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 addres
[   18.690938] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x00000000000093d0 flags=0x0020]
[   18.698287] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x003321e897eb4300 flags=0x0030]
[   18.705297] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x003321e897eb4330 flags=0x0030]
[   18.712078] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x003321e897eb4320 flags=0x0030]
[   18.718850] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x00000000000093e0 flags=0x0020]
[   18.726053] AMD-Vi: Eventgged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0xdd048b287d0000f0 flags=0x0030]
[   18.832675] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0xdd048b287d000100 flags=0x0030]
[   18.840048] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0xdd048b287d000130 flags=0x0030]
[   18.846845] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0xdd048b287d000120 flags=0x0030]
[   18.853790] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x000000000000]
[   19.360315] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x73f039c2010000f0 flags=0x0030]
[   19.367309] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x73f039c201000130 flags=0x0030]
[   19.374740] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x73f039c201000100 flags=0x0030]
[   19.381361] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x73f039c201000120 flags=0x0030]
[   19.388602] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x0000000000009400 flags=0x0020]
[   19.395386] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x0ad9e8c2290773d0 flags=0x0030]
[   19.402142] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x0ad9e8c2290773e0 flags=0x0030]
[   19.409371] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x0ad9e8c229077400 flags=0x0030]
[   19.416133] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x0000000000009410 fla: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x000656e95d5f5e50 flags=0x0030]
[   20.427874] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x000656e95d5f5e80 flags=0x0030]
[   20.434689] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x000656e95d5f5e90 flags=0x0030]
[   20.441566] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x000656e95d5f5e60 flags=0x0030]
[   20.448327] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x0000000000009420 flags=0x0020]
[   20.455096] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x0000051ae8057400 flags=0x0030]
[   20.461869] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=000051ae8057410 flags=0x0030]
[   20.568478] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x0000051ae8057420 flags=0x0030]
[   20.575253] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x0000051ae8057430 flags=0x0030]
[   20.582351] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0011 address=0x0000000000009430 flags=0x0020]
[   20.589399] perf: AMD NB counters detected
[   20.592257] [sched_delayed] schedctivated
[   21.095112] microcode: CPU0: patch_level=0x06000626
[   21.098429] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   21.104450] LVT offset 0 assigned for vector 0x400
[   21.107478] perf: AMD IBS detected (0x000000ff)
[   21.110747] futex hash table entries: 256 (order: 2, 16384 bytes)
[   21.115114] Initialisestem trusted keyring
[   21.217852] audit: initializing netlink subsys (disabled)
[   21.221492] audit: type=2000 audit(1397195215.806:1): initialized
[   21.250774] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   21.257809] zbud: loaded
[   21.259702] VFS: Disk quotas dquot_6.5.2
[   21.262619] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   21.267010] msgmni has been set to 968
[   21.269574] Key type big_key registered
[   21.272783] alg: No test for stdrng (krng)
[   21.275571] NET: Registered protocol family 38
[   21.278442] Key type asymmetric registered
[   21.281120] Asymmetric key parser 'x509' registered
[   21.284681] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[   21.289596] io scheduler noop registered
[   21.292425] io scheduler deadline registered (default)
[   21.295727] io scheduler cfq registered
[   21.298529] ACPI: PCI Interrupt Link [BI04] enabled at IRQ 5] ACPI: PCI Interrupt Link [BI0C] enabled at IRQ 54
[   21.805383] tsc: Refined TSC clocksource calibration: 2506.294 MHz
[   21.809511] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   21.813326] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[   21.817796] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[   21.822685] ACPI: Power Button [PWRF]
[   21.825149] ERST: Failed to get Error Log Address Range.
[   21.828585] GHES: APEI firmware first mode is enabled by APEI bit and WHEA _OSC.
[   21.833809] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   21.858481] 00:07: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[   21.884203] serial8250: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[   21.890700] Non-volatile memory driver v1.3
[   21.893578] Linux agpgart interface v0.103
[   21.896222] rdac: device handler registered
[   21.898935] hp_sw: device handler registered
[   21.901799] emc: device handler istered
[   22.004492] alua: device handler registered
[   22.007286] libphy: Fixed MDIO Bus: probed
[   22.009988] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   22.014315] ehci-pci: EHCI PCI platform driver
[   22.01Host Controller
[   23.019627] ehci-pci 0000:00:12.2: new USB bus registered, assigned bus number 1
[   23.024386] Switched to clocksource tsc
[   23.026843] ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[   23.032592] ehci-pci 0000:00:12.2: debug port 1
[   23.035552] ehci-pci 0000:00:12.2: irq 23, io mem 0xfd8c0000
[   23.044330] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[   23.048286] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   23.053000] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   23.057579] usb usb1: Product: EHCI Host Controller
[   23.060878] usb usb1: Manufacturer: Linux 3.14.0+ ehci_hcd
[   23.0643 usb usb1: SerialNumber: 0000:00:12.2
[   23.169445] hub 1-0:1.0: USB hub found
[   23.173914] hub 1-0:1.0: 6 ports detected
[   23.177678] ehci-pci 0000:00:13.2: EHCI Host Controller
[   23.181914] ehci-pci 0000:00:13.2: new USB bus registered, assigned bus number 2
[   23.186731] ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[   23.192491] ehci-pci 0000:00:13.2: debug port 1
[   23.195359] ehci-pci 0000:00:13.2: irq 22, io mem 0xfd890000
[   23.204498] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[   23.208510] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   23: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   23.716741] usb usb2: Product: EHCI Host Controller
[   23.720025] usb usb2: Manufacturer: Linux 3.14.0+ ehci_hcd
[   23.723720] usb usb2: SerialNumber: 0000:00:13.2
[   23.726702] hub 2-0:1.0: USB hub found
[   23.729407] hub 2-0:1.0: 6 ports detected
[   23.732036] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   23.737025] ohci-pci: OHCI PCI platform driver
[   23.740251] ohci-pci 0000:00:12.0: OHCI PCI host controller
[   23.744241] ohci-pci 0000:00:12.0: new USB bus registered, assigned bus number 3
[   23.749398] ohci-pci 0000:00:12.0: irq 22, io mem 0xfd8e0000
[   23.807192] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   23.811722] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   23.816135] usb usb3: Product: OHCI PCI host controller
[   23.819577] usb usb3: Manufacturer: Linux 3.14.0+ ohci_hcd
[   23.823063] usb usb3: SerialNumber: 0000:00:12.0
[   23.826059] hub 3-0:1.0: USB hub found
[   23.828791] hub 3-0:1.0: 3 ports detected
[   23.832614] ohci-pci 0000:00:12.1: OHCI PCI host controller
[   23.836461] ohci-pci 0000:00:12.1: new USB bus registered, assigned bus number 4
[   23.841307] ohci-pci 0000:00:12.1: irq 22, io mem 0xfd8d0000
[   23.899288] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   23.903791] usb usb4: New USB fr=3, Product=2, SerialNumber=1
[   24.407911] usb usb4: Product: OHCI PCI host controller
[   24.411530] usb usb4: Manufacturer: Linux 3.14.0+ ohci_hcd
[   415226] usb usb4: SerialNumber: 0000:00:12.1
[   24.518382] hub 4-0:1.0: USB hub found
[   24.520942] hub 4-0:1.0: 3 ports detected
[   24.524418] ohci-pci 0000:00:13.0: OHCI PCI host controller
[   24.528336] ohci-pci 0000:00:13.0: new USB bus registered, assigned bus number 5
[   24.533259] ohci-pci 0000:00:13.0: irq 23, io mem 0xfd8b0000
[   24.592013] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   24.597403] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   24.602001] usb usb5: Product: OHCI PCI host controller
[   24.605525] usb usb5: Manufacturer: Linux 3.14.0+ ohci_hcd
[   24.609200] usb usb5: SerialNumber: 0000:00:13.0
[   24.612307] hub 5-0:1.0: USB hub found
[   24.614840] hub 5-0:1.0: 3 ports detected
[   24.618092] ohci-pci 0000:00:13.1: OHCI PCI host controller
[   24.621694] ohci-pci 0000:00:13.1: new USB bus registered, assigned bus number 6
[   24.626500] ohci-pci 0000:00:13.1: irq 23, io mem 0xfd8a0000
[   24.685111] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[   24.689631] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   24.694414] usb : OHCI PCI host controller
[   25.097329] usb usb6: Manufacturer: Linux 3.14.0+ ohci_hcd
[   25.100963] usb usb6: SerialNumber: 0000:00:13.1
[   25.104081] h6-0:1.0: USB hub found
[   25.206680] hub 6-0:1.0: 3 ports detected
[   25.209403] uhci_hcd: USB Universal Host Controller Interface driver
[   25.213455] uhci_hcd 0000:02:00.4: UHCI Host Controller
[   25.217210] uhci_hcd 0000:02:00.4: new USB bus registered, assigned bus number 7
[   25.222024] uhci_hcd 0000:02:00.4: detected 8 ports
[   25.225141] uhci_hcd 0000:02:00.4: port count misdetected? forcing to 2 ports
[   25.230109] uhci_hcd 0000:02:00.4: irq 49, io base 0x00003c00
[   25.233888] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[   25.239304] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   25.244574] usb usb7: Product: UHCI Host Controller
[   25.248144] usb usb7: Manufacturer: Linux 3.14.0+ uhci_hcd
[   25.252069] usb usb7: SerialNumber: 0000:02:00.4
[   25.255602] hub 7-0:1.0: USB hub found
[   25.258892] hub 7-0:1.0: 2 ports detected
[   25.262072] usbcore: registered new interface driver usbserial
[   25.266945] usbcore: registered new interface driver usbserial_generic
[   25.271833] usbserial: USB Serial support registered for generic
[   25.276283] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at ] serio: i8042 KBD port at 0x60,0x64 irq 1
[   26.283522] serio: i8042 AUX port at 0x60,0x64 irq 12
[   26.286953] mousedev: PS/2 mouse device common for all mice
[   26.290707] rtc_cmos 00:08: RTC can wake from S4
[   26.293991] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
[   26.298215] rtc_cmos 00:08: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[   26.304219] hidraw: raw HID events driver (C) Jiri Kosina
[   26.308327] usbcore: registered new interface driver usbhid
[   26.312143] usbhid: USB HID core driver
[   26.314867] drop_monitor: Initializing network drop monitor service
[   26.318885] TCP: cubic registered
[   26.320991] Initializing XFRM netlink socket
[   26.324173] NET: Registered protocol family 10
[   26.327494ET: Registered protocol family 17
[   26.431238] Loading compiled-in X.509 certificates
[   26.435909] Loaded X.509 cert 'Magrathea: Glacier signing key: 0f3c8e0b2dcfed8b5b67f5ae666b05984e42148f'
[   26.442454] registered taskstats version 1
[   26.447787] Key type trusted registered
[   26.452063] Key type encrypted registered
[   26.456382] ima: No TPM chip found, activating TPM-bypass!
[   26.460632] rtc_cmos 00:08: setting system clock to 2014-04-11 05:47:14 UTC (1397195234)
[   26.468062] Freeing unused kernel memory: 1676K (ffffffff81a84000 - ffffffff81c27000)
[   26.514928] systemd[1]: systemd 208 running in system IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[   27.621382] systemd[1]: Running in initial RAM disk.

Welcome to Red Hat Enterprise Linux Workstation 7.0 (Maipo) dracut-033-160.el7 (Initramfs)!

[   27.628243] systemd[1]: Set hostname to <hp-sl4545g7-01.rhts.eng.bos.redhat.com>.
[   27.633817] random: systemd urandom read with 71 bits of entropy available
[   27.665587] systemd[1]: Expecting device dev-disk-by\x2duuid-65568449\x2d9575\x2d488f\x2dae24\x2ddf2d9ade6340.device...
         Expecting device dev-disk-by\x2duuid-65568449\x2d957...e6340.device...
[   27.675241] systemd[1]: Expecting device dev-mapper-rhel_hp\x2d\x2dsl4545g7\x2d\x2d01\x2dswap.device...
         Expecting device dev-mapper-rhel_hp\x2d\x2dsl4545g7\...dswap.device...
[   27.683244] systemd[1]: Expecting device dev-mapper-rhel_hp\x2d\x2dsl4545g7\x2d\x2d01\x2droot.device...
         Expecting device dev-mapper-rhel_hp\x2d\x2dsl4545g7\...droot.device...
[   27.792354] systemd[1]: Starting -.slice.
[  OK  ] Created slice -.slice.
[   27.797386] systemd[1]: Created slice -.slice.
[   27.800300] systemd[1]: Starting System Slice.
[  OK  ] Created slice System Slice.
[   27.806370] systemd[1]: Created slice System Slice.
[   27.809596] systemd[1]: Starting Slices.
[  OK  ] Reached target Slices.
[   28.313901] systemd[1]: Reached target Slices.
[   28.316788] systemd[1]: Starting Timers.
[  OK  ] Reached target Timers.
[   28.321908] systemd[1]: Reached target Timers.
[   28.324928] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
[   28.330029] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[   28.335221] systemd[1]: Starting Paths.
[  OK  ] Reached target Paths.
[   28.339931] systemd[1]: Reached target Paths.
[   28.343013] systemd[1]: Starting Journal Socket.
[  OK  ] Listening on Journal Socket.
[   28.347938] syst[1]: Listening on Journal Socket.
[   28.451222] systemd[1]: Starting dracut cmdline hook...
         Starting dracut cmdline hook...
[   28.457532] systemd[1]: Started Load Kernel Modules.
[   28.464366] systemd[1]: Starting Journal Service...
         Starting Journal Service...
[  OK  ] Started Journal Service.
[   28.476092] systemd[1]: Started Journal Service.
[   28.480358] systemd-journald[89]: Vacuuming done, freed 0 bytes
[  OK  ] Listening on udev Kernel Socket.
[  OK  ] Listening on udev Control Socket.
[  OK  ] Reached target Sockets.
         Starting Create list of required static device nodes...rrent kernel...
         Starting Apply Kernel Variables...
[  OK  ] Reached target Swap.
[  OK  ] Reached target Local File Systems.
[  OK  ] Started dracut cmdline hook.
[  OK  ] Started Apply Kernel Variables.
         Starting Create static device nodes in /dev...nodes ...current kernel.
         Starting dracut pre-udev hook...
[  OK  ] Started Create static device nodes in /dev.
[   29.167042] device-mapper: uevent: version 1.0.3
[   29.170276] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[  OK  ] Started dracut pre-udev hook.
         Starting udev Kernel Device Manager...
[   29.224279] systemd-udevd[203]: starting version 208
[  OK  ] Started udev Kernel Device Manager.
         Starting udev Coldplug all Devices...
[  OK  ] Started udev Coldplug all Devices.
         Starting dracut initqueue hook...
[  OK  ] Reached target System Initialization.
[  OK  ] Reached target Basic System.
         Mounting Configuration File System...
[  OK  ] Mounted Configuration File System.
         Starting File System Check on /dev/mapper/rhel_hp--s...5g7--01-root...
systemd-fsck[236]: fsck: error 2 (No such file or directory) while executing fsck.ext2 for /dev/mapper/rhel_hp--sl4545g7--01-root
[  OK  ] Started File System Check on /dev/mapper/rhel_hp--sl4545g7--01-root.
[   29.403824] ACPI: PCt Link [I050] enabled at IRQ 48
[   29.725393] HP HPSA Driver (v 3.4.4-1)
[   29.727940] ------------[ cut here ]------------
[   29.731115] WARNING: CPU: 0 PID: 205 at drivers/pci/pci.c:1517 pci_disable_device+0x9c/0xb0()
[   29.737027] hpsa 0000:05:00.0: disabling already-disabled device
[   29.741188] Modules linked in: hpsa(+) hpwdt(+) dm_mirror dm_region_hash dm_log dm_mod
[   29.746642] CPU: 0 PID: 205 Comm: systemd-udevd Not tainted 3.14.0+ #44
[   29.751206] Hardware name: HP ProLiant SL4545 G7/, BIOS A31 12/08/2012
[   29.755125]  0000000000000 00000000d593d9a1 ffff880030c31a08 ffffffff816259f8
[   29.860007]  ffff880030c31a50 ffff880030c31a40 ffffffff8106d80d ffff88002d512000
[   29.864551]  ffff88002d4eb0f0 ffffffffa004a000 ffff88002d512000 ffffffffa004a660
[   29.869191] Call Trace:
[   29.870889]  [<ffffffff816259f8>] dump_stack+0x45/0x56
[   29.874096]  [<ffffffff8106d80d>] warn_slowpath_common+0x7d/0xa0
[   29.877896]  [<ffffffff8106d88c>] warn_slowpath_fmt+0x5c/0x80
[   29.881589]  [<ffffffff8131268c>] pci_disable_device+0x9c/0xb0
[   29.885326]  [<ffffffffa0042bb5>] hpsa_init_one+0x445/0x1b30 [hpsa]
[   29.889231]  [<ffffffff812dd768>] ? ida_simple_get+0x98/0x110
[   29.893108]  [<ffffffff81245c98>] ? kernfs_next_descendant_post+0x48/0x60
[   29.897669]  [<ffffffff81314285>] local_pci_probe+0x45/0xa0
[   29.901283]  [<ffffffff81315535>] ? pci_match_d  30.391337]  [<ffffffff81315679>] pci_device_probe+0xf9/0x150
[   30.508052]  [<ffffffff813e4d67>] driver_probe_device+0x87/0x390
[   30.512037]  [<ffffffff813e5143>] __driver_attach+0x93/0xa0
[   30.515425]  [<ffffffff813e50b0>] ? __device_attach+0x40/0x40
[   30.519168]  [<ffffffff813e2c33>] bus_for_each_dev+0x73/0xc0
[   30.522642]  [<ffffffff813e47be>] driver_attach+0x1e/0x20
[   30.526060]  [<ffffffff813e4370>] bus_add_driver+0x180/0x250
[   30.529671]  [<ffffffffa004e000>] ? 0xffffffffa004dfff
[   30.532884]  [<ffffffff813e57c4>] driver_register+0x64/0xf0
[   30.536304]  [<ffffffffa004e000>] ? 0xffffffffa004dfff
[   30.539647]  [<ffffffff81313c1c>] __pci_register_driver+0x4c/0x50
[   30.543429]  [<ffffffffa004e01e>] hpsa_init+0x1e/0x1000 [hpsa]
[   30.547065]  [<ffffffff8100216a>] do_one_initcall+0xfa/0x1b0
[   30.551075]  [<ffffffff8105c8a3>] ? set_memory_nx+0x43/0x50
[   30.554505]  [<ffffffff810eb0e5>] load_module+0x1395/050
[   30.657851]  [<ffffffff810e6a10>] ? store_uevent+0x70/0x70
[   30.661389]  [<ffffffff810e7669>] ? copy_module_from_fd.isra.45+0x129/0x180
[   30.665834]  [<ffffffff810eb956>] SyS_finit_module+0xa6/0xd0
[   30.669475]  [<ffffffff81636829>] system_call_fastpath+0x16/0x1b
[   30.673446] ---[ end trace feb521b6b18d9310 ]---
[   30.681352] hpsa 0000:05:00.0: using doorbell to reset controller
[   30.709987] hpwdt 0000:02:00.0: HP Watchdog Timer Driver: NMI decoding w kernel dump: ON (default = 0/OFF)
[   31.217415] hpwdt 0000:02:00.0: HP Watchdog Timer Driver: 1.3.3, timer margin: 30 seconds (nowayout=0).
[   31.279218] ACPI: PCI Interrupt Link [SATA] enabled at IRQ 16
[   31.283181] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[   31.288640] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
[   31.302989] scsi0 : ahci
[   31.306497] scsi1 : ahci
[   31.309548] scsi2 : ahci
[   31.312363] scsi3 : ahci
[   31.315192] scsi4 : ahci
[   31.318158] scsi5 : ahci
[   31.321012] ata1: SATA max UDMA/133 abar m1024@0xfd8f0000 port 0xfd8f0100 irq 16
[   31.326099] ata2: SATA max UDMA/133 abar m1024@0xfd8f0000 port 0xfd8f0180 irq 16
[   31.330862] ata3: SATA max UDMA/133 abar m1024@0xfd8f0000 port 0xfd8f0200 irq 16
[   31.335375] ata4: SATA max UDMA/133 abar m1024@0xfd8f0000 port 0xfd8f0280 irq 16
[   31.340129] ata5: SATA max UDMA/133 abar m1024@0xfd8f0000 port 0xfd8f0300 irq 16
[   31.345073] ata6: SATA max UDMA/133 abar m1024@0xfd8f0000 port 0xfd8f0380 irq 16
[   31.654404] ata2: SATA link down (SStatus 0 SControl 300)
[   31.658378] ata1: SATA link down (SStatus 0 SControl 300)
[   31.661861] ata3: SATA link down (SStatus 0 SControl 300)
[   31.666264] ata6: SATA link down (SStatus 0 SControl 300)
[   31.823542] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   31.827713] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   31.831946] 4.00: ATA-8: MM0500GBKAK, HPGC, max UDMA/133
[   31.935395] ata4.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[   31.940521] ata5.00: ATA-8: MM0500GBKAK, HPGC, max UDMA/133
[   31.944243] ata5.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[   31.949091] ata4.00: configured for UDMA/133
[   31.951961] scsi 3:0:0:0: Direct-Access     ATA      MM0500GBKAK      HPGC PQ: 0 ANSI: 5
[   31.957434] ata5.00: configured for UDMA/133
[   31.962551] s 4:0:0:0: Direct-Access     ATA      MM0500GBKAK      HPGC PQ: 0 ANSI: 5
[   32.096479] pata_atiixp 0000:00:14.1: can't derive routing for PCI INT A
[   32.107027] scsi6 : pata_atiixp
[   32.110606] scsi7 : pata_atiixp
[   32.114169] ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x500 irq 14
[   32.118903] ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x508 irq 15
[   32.408745] [drm] Initialized drm 1.1.0 20060810
[   32.862688] [drm] radeon kernel modesetting enabled.
[   32.866507] ACPI: PCI Interrupt Link [VIDA] enabled at IRQ 16
[   32.872249] [drm] initializing kernel modesetting (RV100 0x1002:0x515E 0x103C:0x31FB).
[   32.877678] [drm] register mmio base: 0xFD9F0000
[   32.880598] [drm] register mmio size: 65536
[   32.883511] radeon 0000:01:03.0: VRAM: 128M 0x00000000F0000000 - 0x00000000F7FFFFFF (64M used)
[   32.889099] radeon 0000:01:03.0: GTT: 512M 0x00000000D0000000 - 0x00000000EFFFFFFF
[   32.894075] [drm] Detected VRAM RAM=128M, BAR=128M
[   32.897733] [drm] RAM width 16bits DDR
[   32.900425] [TTM] Zone  kernel: Available graphics memory: 248814 kiB
[   32.904741] [TTM] Initializing pool allocator
[   32.907866] [TTM] Initializing DMA pool allocator
[   32.910990] [drm] radeon: 64M of VRAM memory ready
[   32.914150] [drm] radeon: 512M of GTT memory ready.
[   32.918043] [drm] GART: num cpu pages 131072, num gpu pages 131072
[   32.944858] [drm] PCI GART of 512M enabled (table at 0x0000000000100000).
[   32.949474] radeon 0000:01:03.0: WB disabled
[   32.952452] radeon 0000:01:03.0: fence driver on ring 0 use gpu addr 0x00000000d0000000 and cpu addr 0xffff88002fc8c000
[   32.959540] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[   32.964069] [drm] Driver supports precise vblank timestamp query.
[   32.968152] [drm] radeon: irq initialized.
[   32.970886] [drm] Loading R100 Microcode
[   32.973805] [drm] radeon: ring at 0x00000000D0001000
[   32.977264] [drm] ring test succeeded in 1 usecs
[   33.481270] [drm] ib test succeeded in 0 usecs
[   33.486594] [drm] No TV DAC info found in BIOS
[   33.492239] [drm] Radeon Displaectors
[   33.694776] [drm] Connector 0:
[   33.697223] [drm]   VGA-1
[   33.699150] [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[   33.703571] [drm]   Encoders:
[   33.705603] [drm]     CRT1: INTERNAL_DAC1
[   33.708191] [drm] Connector 1:
[   33.710107] [drm]   VGA-2
[   33.712031] [drm]   DDC: 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c
[   33.715880] [drm]   Encoders:
[   33.717738] [drm]     CRT2: INTERNAL_DAC2
[   33.771462] [drm] fb mappable at 0xF0040000
[   33.774456] [drm] vram apper at 0xF0000000
[   33.777108] [drm] size 786432
[   33.779142] [drm] fb depth is 8
[   33.781384] [drm]    pitch is 1024
[   33.784453] fbcon: radeondrmfb (fb0) is primary device
[   33.953931] Console: switching to colour frame buffer device 128x48
[   33.983351] radeon 0000:01:03.0: fb0: radeondrmfb frame buffer device
[   33.987660] radeon 0000:01:03.0: registered panic notifier
[   33.991153] [drm] Initialized radeon 2.38.0 20080528 for 0000:01:03.0 on minor 0
[   34.102570] sd 3:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[   34.107821] sd 4:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 G
[   34.412429] sd 3:0:0:0: [sda] Write Protect is off
[   34.416397] sd 3:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   34.422722] sd 4:0:0:0: [sdb] Write Protect is off
[   34.426764] sd 4:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   34.436227]  sda: sda1 sda2
[   34.438814] sd 3:0:0:0: [sda] Attached SCSI disk
[   34.450145]  sdb: sdb1
[   34.452195] sd 4:0:0:0: [sdb] Attached SCSI disk
[   34.568254] random: nonblocking pool is initialized
[   35.692023] ACPI: PCI Interrupt Link [I0C0] enabled at IRQ 36
[   38.699761] hpsa 0000:05:00.0: board ready after hard reset.
[   38.703516] hpsa 0000:05:00.0: Waiting for controller to respond to no-op
[   68.742253] hpsa 0000:05:00.0: controller message 03:00 succeeded
[   68.746522] hpsa 0000:05:00.0: can't disable ASPM; OS doesn't have ASPM control
[   68.751675] hpsa 0000:05:00.0: MSIX
[   68.754343] hpsa 0000:05:00.0: Logical aborts not supported
[   68.778334] hpsa 0000:05:00.0: hpsa0: <0x323b> at IRQ 73 using DAC
[   68.822788] scsi8: error handler thread failed to spawn, error = -12
[   68.827123] hpsa 0000:05:00.0: hpsa_register_scsi: scsi_host_alloc failed for controller 0


--pf9I7BMVVzbSWLtt--
