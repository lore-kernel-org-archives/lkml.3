Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab3C2BRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 21:17:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:1336 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab3C2BRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 21:17:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,370,1363158000"; 
   d="log'?scan'208";a="310071387"
Date: Fri, 29 Mar 2013 09:17:19 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [rcu] BUG: sleeping function called from invalid context at
 kernel/cpu.c:68
Message-ID: <20130329011719.GB7557@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8P1HSweYDcXXzwPJ"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8P1HSweYDcXXzwPJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit 8902eb3ab3e3f63c3f5e85734470941aecfc00e3
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Tue Mar 19 12:27:50 2013 -0700

    rcu: Inline trivial wrapper function rcu_start_gp_per_cpu()
    
    Given the changes that introduce note_gp_change(), rcu_start_gp_per_cpu()
    is now a trivial wrapper function with only one caller.  This commit
    therefore inlines it into its sole call site.
    
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

[    5.438614] Testing CPA: undo 81788000-81ac2000
[    5.439319] Testing CPA: write protecting again
[    5.440085] BUG: sleeping function called from invalid context at /c/kernel-tests/src/linux/kernel/cpu.c:68
[    5.441418] in_atomic(): 1, irqs_disabled(): 1, pid: 10, name: rcu_sched
[    5.442348] Pid: 10, comm: rcu_sched Not tainted 3.9.0-rc4-00255-g7a0861d #330
[    5.443346] Call Trace:
[    5.443725]  [<810767ab>] __might_sleep+0x15b/0x170
[    5.444010]  [<81046c49>] get_online_cpus+0x19/0x50
[    5.444010]  [<810a279f>] rcu_implicit_dynticks_qs+0x5f/0xb0
[    5.444010]  [<810a363c>] force_qs_rnp+0xcc/0x150
[    5.444010]  [<810a2740>] ? force_quiescent_state+0xf0/0xf0
[    5.444010]  [<810a43fa>] rcu_gp_fqs+0x3a/0x90
[    5.444010]  [<810a487a>] rcu_gp_kthread+0x42a/0x720
[    5.444010]  [<81065c50>] ? abort_exclusive_wait+0x80/0x80
[    5.444010]  [<810a4450>] ? rcu_gp_fqs+0x90/0x90
[    5.444010]  [<81064eff>] kthread+0x8f/0xa0
[    5.444010]  [<81070000>] ? perf_trace_sched_wakeup_template+0x60/0xf0
[    5.444010]  [<817860f7>] ret_from_kernel_thread+0x1b/0x28
[    5.444010]  [<81064e70>] ? __kthread_parkme+0x70/0x70
mountall: ply-event-loop.c:497: ply_event_loop_new: Assertion `loop->epoll_fd >= 0' failed.
General error mounting filesystems.

git bisect start 7a0861da273ddc4ba4fdbe3224d5cf1624646691 v3.8 --
git bisect good 8b5628ab83b671f96ac9f174c1bd51c92589fc82  #    36  2013-03-28 20:57:33  Merge tag 'virt' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect good ecc88efbe7adceb3f4bfdbbb1efb669efcaab124  #    35  2013-03-28 21:04:05  Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending
git bisect good b695188dd39162a1a6bff11fdbcc4c0b65b933ab  #    33  2013-03-28 21:09:23  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
git bisect good cad9d5664a74702d3df7a1bf4ab1221428c3ff87  #    37  2013-03-28 21:13:54  Merge tag 'tty-3.9-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
git bisect good d3c926264a92e5ea448add3e883530e1edad3ce2  #    34  2013-03-28 21:19:24  Merge tag 'ext4_for_linue' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
git bisect good 45f66fe90604d67a32b6663189d6201dd63e43c5  #    36  2013-03-28 21:24:44  Merge remote-tracking branch 'drm-intel/drm-intel-next-queued' into devel-roam-i386-2013-03-27-04-47
git bisect good 3d597e98ceced8cb5c4c45ea339ae8af31487477  #    37  2013-03-28 21:29:51  arm64: KVM: Plug the VGIC
git bisect good 73806b1c8e9c079288acaaf3dfdf566dabd2413c  #    35  2013-03-28 21:35:26  Merge remote-tracking branch 'regmap/for-next' into devel-roam-i386-2013-03-27-04-47
git bisect good 910ee45db2f4837c8440e770474758493ab94bf7  #    32  2013-03-28 21:39:59  rcu: Make rcu_accelerate_cbs() note need for future grace periods
git bisect good a46e1ecb936cb209e236d28d7dc1396c736a6c9d  #    32  2013-03-28 21:45:26  rcu: Remove srcu_read_lock_raw() and srcu_read_unlock_raw().
git bisect good 7b48afd55f65960962593e46400e710a04ba7a6c  #    34  2013-03-28 21:50:03  rcu: Switch callers from rcu_process_gp_end() to note_gp_changes()
git bisect  bad 8902eb3ab3e3f63c3f5e85734470941aecfc00e3  #     2  2013-03-28 21:52:19  rcu: Inline trivial wrapper function rcu_start_gp_per_cpu()
git bisect good 0d5522f080c10c35625e7c4c99ced17484cb9bfc  #    31  2013-03-28 21:56:21  rcu: Eliminate check_for_new_grace_period() wrapper function
git bisect good 0d5522f080c10c35625e7c4c99ced17484cb9bfc  #    96  2013-03-28 22:01:19  rcu: Eliminate check_for_new_grace_period() wrapper function
git bisect  bad 7a0861da273ddc4ba4fdbe3224d5cf1624646691  #     1  2013-03-28 22:04:09  Merge remote-tracking branch 'rcu/dev.2013.03.26a' into devel-roam-i386-2013-03-27-04-47
git bisect  bad 0ed9dc7c1351a22c05b3fbddf766e9c1a373d40a  #     2  2013-03-28 22:05:58  Revert "rcu: Inline trivial wrapper function rcu_start_gp_per_cpu()"
git bisect good da17d7bda957ae4697b6abc0793f74fb9b50b58f  #    90  2013-03-28 22:31:54  Add linux-next specific files for 20130328

Thanks,
Fengguang

--8P1HSweYDcXXzwPJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-bay-1249-2013-03-27-12-17-25-3.9.0-rc4-00255-g7a0861d-330"

[    0.000000] Linux version 3.9.0-rc4-00255-g7a0861d (kbuild@roam) (gcc version 4.7.2 (Debian 4.7.2-4) ) #330 SMP Wed Mar 27 04:58:51 CST 2013
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   Centaur CentaurHauls
[    0.000000]   UMC UMC UMC UMC
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x100000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at [800fdab0]
[    0.000000]   mpc: fdac0-fdbec
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x023fffff]
[    0.000000] Base memory trampoline at [8008f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x07ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fbfffff] page 2M
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x01cc0000, 0x01cc0fff] PGTABLE
[    0.000000] BRK [0x01cc1000, 0x01cc2fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128388(97%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 0ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] BRK [0x01cc3000, 0x01cc3fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65424
[    0.000000] free_area_init_node: node 0, pgdat 81b44300, node_mem_map 8dd3f020
[    0.000000]   Normal zone: 512 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 65424 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffff9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 11 pages/cpu @8dd29000 s29920 r0 d15136 u45056
[    0.000000] pcpu-alloc: s29920 r0 d15136 u45056 alloc=11*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr dd2b6c0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64912
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=linux-devel/devel-roam-i386-2013-03-27-04-47 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2013-03-27-04-59-32-devel-roam-i386-2013-03-27-04-47:7a0861da273ddc4ba4fdbe3224d5cf1624646691-7a0861da273ddc4ba4fdbe3224d5cf1624646691-i386-randconfig-r04-0326-2-bay BOOT_IMAGE=/kernel/i386-randconfig-r04-0326/7a0861da273ddc4ba4fdbe3224d5cf1624646691/vmlinuz-3.9.0-rc4-00255-g7a0861d
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 212720k/262136k available (7708k kernel code, 48976k reserved, 4130k data, 532k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffa94000 - 0xfffff000   (5548 kB)
[    0.000000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.000000]     vmalloc : 0x907fe000 - 0xff3fe000   (1772 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x8fffe000   ( 255 MB)
[    0.000000]       .init : 0x81b90000 - 0x81c15000   ( 532 kB)
[    0.000000]       .data : 0x81787040 - 0x81b8fb60   (4130 kB)
[    0.000000]       .text : 0x81000000 - 0x81787040   (7708 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=128, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=80080000 soft=80082000
[    0.000000] console [ttyS0] enabled
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]                  A-B-B-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]                     double unlock:failed|failed|failed|failed|failed|failed|
[    0.000000]                   initialize held:failed|failed|failed|failed|failed|failed|
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |failed|
[    0.000000]            recursive read-lock #2:             |  ok  |             |failed|
[    0.000000]             mixed read-write-lock:             |failed|             |failed|
[    0.000000]             mixed write-read-lock:             |failed|             |failed|
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] --------------------------------------------------------
[    0.000000] 145 out of 218 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2992.362 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5984.72 BogoMIPS (lpj=11969448)
[    0.008000] pid_max: default: 32768 minimum: 301
[    0.008000] Security Framework initialized
[    0.008039] Mount-cache hash table entries: 512
[    0.009269] mce: CPU supports 10 MCE banks
[    0.009919] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.009919] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.009919] tlb_flushall_shift: 6
[    0.013421] Freeing SMP alternatives: 36k freed
[    0.020094] ACPI: Core revision 20130117
[    0.022033] ACPI: All ACPI Tables successfully acquired
[    0.022985] Getting VERSION: 50014
[    0.023489] Getting VERSION: 50014
[    0.024014] Getting ID: 0
[    0.024403] Getting ID: f000000
[    0.025103] Getting LVT0: 8700
[    0.025547] Getting LVT1: 8400
[    0.025995] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.026837] enabled ExtINT on CPU#0
[    0.028736] ENABLING IO-APIC IRQs
[    0.029226] init IO_APIC IRQs
[    0.029658]  apic 2 pin 0 not connected
[    0.030216] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.031344] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.032026] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.033154] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.034506] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.036021] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.037134] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.038456] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.040025] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.041142] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.042486] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.043620] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.044020] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.045385] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.046535] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.048023]  apic 2 pin 16 not connected
[    0.048586]  apic 2 pin 17 not connected
[    0.049142]  apic 2 pin 18 not connected
[    0.049703]  apic 2 pin 19 not connected
[    0.050257]  apic 2 pin 20 not connected
[    0.051043]  apic 2 pin 21 not connected
[    0.052004]  apic 2 pin 22 not connected
[    0.052560]  apic 2 pin 23 not connected
[    0.053276] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.054749] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.056718] Using local APIC timer interrupts.
[    0.056718] calibrating APIC timer ...
[    0.060000] ... lapic delta = 6250570
[    0.060000] ... PM-Timer delta = 358005
[    0.060000] ... PM-Timer result ok
[    0.060000] ..... delta 6250570
[    0.060000] ..... mult: 268459937
[    0.060000] ..... calibration result: 4000364
[    0.060000] ..... CPU clock speed is 2992.3799 MHz.
[    0.060000] ..... host bus clock speed is 1000.0364 MHz.
[    0.060120] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.063484] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.064134] CPU 1 irqstacks, hard=8010e000 soft=80118000
[    0.065256] smpboot: Booting Node   0, Processors  #1 OK
[    0.008000] Initializing CPU#1
[    0.008000] kvm-clock: cpu 1, msr 0:fffd041, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.128010] Brought up 2 CPUs
[    0.132003] smpboot: Total of 2 processors activated (11969.44 BogoMIPS)
[    0.124000] KVM setup async PF for cpu 1
[    0.124000] kvm-stealtime: cpu 1, msr dd366c0
[    0.136025] CPU0 attaching sched-domain:
[    0.136591]  domain 0: span 0-1 level CPU
[    0.137175]   groups: 0 (cpu_power = 1023) 1
[    0.137853] CPU1 attaching sched-domain:
[    0.140003]  domain 0: span 0-1 level CPU
[    0.140587]   groups: 1 0 (cpu_power = 1023)
[    0.148031] device: 'platform': device_add
[    0.152024] PM: Adding info for No Bus:platform
[    0.152674] bus: 'platform': registered
[    0.153220] bus: 'cpu': registered
[    0.153706] device: 'cpu': device_add
[    0.154230] PM: Adding info for No Bus:cpu
[    0.156981] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.157923] bus: 'virtio': registered
[    0.158436] device class 'regulator': registering
[    0.159122] Registering platform device 'reg-dummy'. Parent at platform
[    0.160004] device: 'reg-dummy': device_add
[    0.160598] bus: 'platform': add device reg-dummy
[    0.161267] PM: Adding info for platform:reg-dummy
[    0.162035] bus: 'platform': add driver reg-dummy
[    0.162699] bus: 'platform': driver_probe_device: matched device reg-dummy with driver reg-dummy
[    0.163908] bus: 'platform': really_probe: probing driver reg-dummy with device reg-dummy
[    0.164014] device: 'regulator.0': device_add
[    0.164665] PM: Adding info for No Bus:regulator.0
[    0.165335] regulator-dummy: no parameters
[    0.165927] driver: 'reg-dummy': driver_bound: bound to device 'reg-dummy'
[    0.166876] bus: 'platform': really_probe: bound device reg-dummy to driver reg-dummy
[    0.168106] NET: Registered protocol family 16
[    0.169137] device class 'bdi': registering
[    0.169751] device class 'pci_bus': registering
[    0.170395] bus: 'pci': registered
[    0.170881] device class 'lcd': registering
[    0.172008] device class 'backlight': registering
[    0.172671] device class 'video_output': registering
[    0.173385] device class 'tty': registering
[    0.174006] bus: 'spi': registered
[    0.174488] device class 'spi_master': registering
[    0.175163] bus: 'hsi': registered
[    0.196013] ACPI: bus type PCI registered
[    0.200005] device class 'dma': registering
[    0.200630] device class 'dmi': registering
[    0.201222] device: 'id': device_add
[    0.201776] PM: Adding info for No Bus:id
[    0.202488] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=0
[    0.203378] PCI: Using configuration type 1 for base access
[    0.204387] device: 'cpu0': device_add
[    0.204922] bus: 'cpu': add device cpu0
[    0.205502] PM: Adding info for cpu:cpu0
[    0.206073] device: 'cpu1': device_add
[    0.206612] bus: 'cpu': add device cpu1
[    0.207162] PM: Adding info for cpu:cpu1
[    0.210267] device: 'default': device_add
[    0.210860] PM: Adding info for No Bus:default
[    0.212082] bio: create slab <bio-0> at 0
[    0.212658] device class 'block': registering
[    0.213308] bus: 'spi': add driver max7301
[    0.213308] ACPI: Added _OSI(Module Device)
[    0.216004] ACPI: Added _OSI(Processor Device)
[    0.216631] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.217291] ACPI: Added _OSI(Processor Aggregator Device)
[    0.218861] ACPI: EC: Look up EC in DSDT
[    0.221948] ACPI: Interpreter enabled
[    0.222485] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130117/hwxface-568)
[    0.223811] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130117/hwxface-568)
[    0.224819] ACPI: (supports S0 S3 S5)
[    0.225360] ACPI: Using IOAPIC for interrupt routing
[    0.226069] bus: 'acpi': registered
[    0.226571] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.229186] device: 'LNXSYSTM:00': device_add
[    0.229838] bus: 'acpi': add device LNXSYSTM:00
[    0.230486] PM: Adding info for acpi:LNXSYSTM:00
[    0.231181] device: 'LNXSYBUS:00': device_add
[    0.232006] bus: 'acpi': add device LNXSYBUS:00
[    0.232649] PM: Adding info for acpi:LNXSYBUS:00
[    0.233340] device: 'PNP0A03:00': device_add
[    0.233965] bus: 'acpi': add device PNP0A03:00
[    0.234594] PM: Adding info for acpi:PNP0A03:00
[    0.235304] device: 'device:00': device_add
[    0.235898] bus: 'acpi': add device device:00
[    0.236010] PM: Adding info for acpi:device:00
[    0.236673] device: 'device:01': device_add
[    0.237279] bus: 'acpi': add device device:01
[    0.237888] PM: Adding info for acpi:device:01
[    0.238537] device: 'PNP0B00:00': device_add
[    0.239137] bus: 'acpi': add device PNP0B00:00
[    0.240012] PM: Adding info for acpi:PNP0B00:00
[    0.240691] device: 'PNP0303:00': device_add
[    0.241292] bus: 'acpi': add device PNP0303:00
[    0.241929] PM: Adding info for acpi:PNP0303:00
[    0.242606] device: 'PNP0F13:00': device_add
[    0.243203] bus: 'acpi': add device PNP0F13:00
[    0.244010] PM: Adding info for acpi:PNP0F13:00
[    0.244691] device: 'PNP0700:00': device_add
[    0.245292] bus: 'acpi': add device PNP0700:00
[    0.245944] PM: Adding info for acpi:PNP0700:00
[    0.246688] device: 'PNP0400:00': device_add
[    0.247297] bus: 'acpi': add device PNP0400:00
[    0.248012] PM: Adding info for acpi:PNP0400:00
[    0.248774] device: 'PNP0501:00': device_add
[    0.249377] bus: 'acpi': add device PNP0501:00
[    0.250048] PM: Adding info for acpi:PNP0501:00
[    0.250766] device: 'device:02': device_add
[    0.251357] bus: 'acpi': add device device:02
[    0.252012] PM: Adding info for acpi:device:02
[    0.252677] device: 'device:03': device_add
[    0.253267] bus: 'acpi': add device device:03
[    0.253910] PM: Adding info for acpi:device:03
[    0.254572] device: 'device:04': device_add
[    0.255167] bus: 'acpi': add device device:04
[    0.255789] PM: Adding info for acpi:device:04
[    0.256044] device: 'device:05': device_add
[    0.256634] bus: 'acpi': add device device:05
[    0.257270] PM: Adding info for acpi:device:05
[    0.257922] device: 'device:06': device_add
[    0.258513] bus: 'acpi': add device device:06
[    0.259129] PM: Adding info for acpi:device:06
[    0.260040] device: 'device:07': device_add
[    0.260632] bus: 'acpi': add device device:07
[    0.261246] PM: Adding info for acpi:device:07
[    0.261919] device: 'device:08': device_add
[    0.262509] bus: 'acpi': add device device:08
[    0.263121] PM: Adding info for acpi:device:08
[    0.264055] device: 'device:09': device_add
[    0.264645] bus: 'acpi': add device device:09
[    0.265259] PM: Adding info for acpi:device:09
[    0.265944] device: 'device:0a': device_add
[    0.266535] bus: 'acpi': add device device:0a
[    0.267159] PM: Adding info for acpi:device:0a
[    0.267833] device: 'device:0b': device_add
[    0.268008] bus: 'acpi': add device device:0b
[    0.268626] PM: Adding info for acpi:device:0b
[    0.269315] device: 'device:0c': device_add
[    0.269909] bus: 'acpi': add device device:0c
[    0.270537] PM: Adding info for acpi:device:0c
[    0.271212] device: 'device:0d': device_add
[    0.272006] bus: 'acpi': add device device:0d
[    0.272631] PM: Adding info for acpi:device:0d
[    0.273293] device: 'device:0e': device_add
[    0.273910] bus: 'acpi': add device device:0e
[    0.274547] PM: Adding info for acpi:device:0e
[    0.275208] device: 'device:0f': device_add
[    0.276007] bus: 'acpi': add device device:0f
[    0.276621] PM: Adding info for acpi:device:0f
[    0.277277] device: 'device:10': device_add
[    0.277883] bus: 'acpi': add device device:10
[    0.278494] PM: Adding info for acpi:device:10
[    0.279156] device: 'device:11': device_add
[    0.279746] bus: 'acpi': add device device:11
[    0.280010] PM: Adding info for acpi:device:11
[    0.280670] device: 'device:12': device_add
[    0.281259] bus: 'acpi': add device device:12
[    0.281884] PM: Adding info for acpi:device:12
[    0.282542] device: 'device:13': device_add
[    0.283127] bus: 'acpi': add device device:13
[    0.284010] PM: Adding info for acpi:device:13
[    0.284669] device: 'device:14': device_add
[    0.285253] bus: 'acpi': add device device:14
[    0.285885] PM: Adding info for acpi:device:14
[    0.286544] device: 'device:15': device_add
[    0.287129] bus: 'acpi': add device device:15
[    0.287753] PM: Adding info for acpi:device:15
[    0.288040] device: 'device:16': device_add
[    0.288640] bus: 'acpi': add device device:16
[    0.289279] PM: Adding info for acpi:device:16
[    0.289938] device: 'device:17': device_add
[    0.290529] bus: 'acpi': add device device:17
[    0.291155] PM: Adding info for acpi:device:17
[    0.292041] device: 'device:18': device_add
[    0.292629] bus: 'acpi': add device device:18
[    0.293238] PM: Adding info for acpi:device:18
[    0.293916] device: 'device:19': device_add
[    0.294508] bus: 'acpi': add device device:19
[    0.295123] PM: Adding info for acpi:device:19
[    0.296040] device: 'device:1a': device_add
[    0.296632] bus: 'acpi': add device device:1a
[    0.297240] PM: Adding info for acpi:device:1a
[    0.297913] device: 'device:1b': device_add
[    0.298496] bus: 'acpi': add device device:1b
[    0.299115] PM: Adding info for acpi:device:1b
[    0.299775] device: 'device:1c': device_add
[    0.300005] bus: 'acpi': add device device:1c
[    0.300624] PM: Adding info for acpi:device:1c
[    0.301303] device: 'device:1d': device_add
[    0.301888] bus: 'acpi': add device device:1d
[    0.302503] PM: Adding info for acpi:device:1d
[    0.303158] device: 'device:1e': device_add
[    0.304005] bus: 'acpi': add device device:1e
[    0.304621] PM: Adding info for acpi:device:1e
[    0.305276] device: 'device:1f': device_add
[    0.305903] bus: 'acpi': add device device:1f
[    0.306518] PM: Adding info for acpi:device:1f
[    0.307172] device: 'device:20': device_add
[    0.307763] bus: 'acpi': add device device:20
[    0.308012] PM: Adding info for acpi:device:20
[    0.308680] device: 'device:21': device_add
[    0.309297] bus: 'acpi': add device device:21
[    0.309914] PM: Adding info for acpi:device:21
[    0.310714] device: 'PNP0103:00': device_add
[    0.311322] bus: 'acpi': add device PNP0103:00
[    0.312014] PM: Adding info for acpi:PNP0103:00
[    0.312769] device: 'PNP0C0F:00': device_add
[    0.313406] bus: 'acpi': add device PNP0C0F:00
[    0.314035] PM: Adding info for acpi:PNP0C0F:00
[    0.314783] device: 'PNP0C0F:01': device_add
[    0.315386] bus: 'acpi': add device PNP0C0F:01
[    0.316011] PM: Adding info for acpi:PNP0C0F:01
[    0.316756] device: 'PNP0C0F:02': device_add
[    0.317381] bus: 'acpi': add device PNP0C0F:02
[    0.318010] PM: Adding info for acpi:PNP0C0F:02
[    0.318760] device: 'PNP0C0F:03': device_add
[    0.319365] bus: 'acpi': add device PNP0C0F:03
[    0.320012] PM: Adding info for acpi:PNP0C0F:03
[    0.320755] device: 'PNP0C0F:04': device_add
[    0.321377] bus: 'acpi': add device PNP0C0F:04
[    0.322008] PM: Adding info for acpi:PNP0C0F:04
[    0.322694] device: 'LNXCPU:00': device_add
[    0.323289] bus: 'acpi': add device LNXCPU:00
[    0.324010] PM: Adding info for acpi:LNXCPU:00
[    0.324679] device: 'LNXCPU:01': device_add
[    0.325284] bus: 'acpi': add device LNXCPU:01
[    0.325894] PM: Adding info for acpi:LNXCPU:01
[    0.326551] device: 'LNXSYBUS:01': device_add
[    0.327159] bus: 'acpi': add device LNXSYBUS:01
[    0.328010] PM: Adding info for acpi:LNXSYBUS:01
[    0.328700] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.329579] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.330671] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.331651] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.332003] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.333085] acpi PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    0.334151] PCI: root bus 00: using default resources
[    0.334855] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.336005] device: 'pci0000:00': device_add
[    0.336633] PM: Adding info for No Bus:pci0000:00
[    0.337285] device: '0000:00': device_add
[    0.337869] PM: Adding info for No Bus:0000:00
[    0.338505] PCI host bridge to bus 0000:00
[    0.340006] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.340780] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.341666] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
[    0.342671] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.344188] device: '0000:00:00.0': device_add
[    0.344892] bus: 'pci': add device 0000:00:00.0
[    0.345546] PM: Adding info for pci:0000:00:00.0
[    0.346273] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.347583] device: '0000:00:01.0': device_add
[    0.348020] bus: 'pci': add device 0000:00:01.0
[    0.348676] PM: Adding info for pci:0000:00:01.0
[    0.349369] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.352155] pci 0000:00:01.1: reg 20: [io  0xc1e0-0xc1ef]
[    0.353634] device: '0000:00:01.1': device_add
[    0.354337] bus: 'pci': add device 0000:00:01.1
[    0.354991] PM: Adding info for pci:0000:00:01.1
[    0.355693] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.356464] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.357508] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.358575] device: '0000:00:01.3': device_add
[    0.359228] bus: 'pci': add device 0000:00:01.3
[    0.360023] PM: Adding info for pci:0000:00:01.3
[    0.360768] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.364486] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.366419] pci 0000:00:02.0: reg 14: [mem 0xfebe4000-0xfebe4fff]
[    0.371852] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
[    0.372161] device: '0000:00:02.0': device_add
[    0.372977] bus: 'pci': add device 0000:00:02.0
[    0.373684] PM: Adding info for pci:0000:00:02.0
[    0.374414] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.376649] pci 0000:00:03.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
[    0.378099] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.382078] pci 0000:00:03.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
[    0.383040] device: '0000:00:03.0': device_add
[    0.383693] bus: 'pci': add device 0000:00:03.0
[    0.384022] PM: Adding info for pci:0000:00:03.0
[    0.384756] pci 0000:00:04.0: [1af4:1000] type 00 class 0x020000
[    0.386322] pci 0000:00:04.0: reg 10: [io  0xc1c0-0xc1df]
[    0.388007] pci 0000:00:04.0: reg 14: [mem 0xfebe5000-0xfebe5fff]
[    0.391894] pci 0000:00:04.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
[    0.392183] device: '0000:00:04.0': device_add
[    0.392857] bus: 'pci': add device 0000:00:04.0
[    0.393520] PM: Adding info for pci:0000:00:04.0
[    0.394258] pci 0000:00:05.0: [8086:2668] type 00 class 0x040300
[    0.396373] pci 0000:00:05.0: reg 10: [mem 0xfebe0000-0xfebe3fff]
[    0.399421] device: '0000:00:05.0': device_add
[    0.400039] bus: 'pci': add device 0000:00:05.0
[    0.400691] PM: Adding info for pci:0000:00:05.0
[    0.401406] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.402928] pci 0000:00:06.0: reg 10: [io  0xc040-0xc07f]
[    0.404317] pci 0000:00:06.0: reg 14: [mem 0xfebe6000-0xfebe6fff]
[    0.408180] device: '0000:00:06.0': device_add
[    0.408850] bus: 'pci': add device 0000:00:06.0
[    0.409538] PM: Adding info for pci:0000:00:06.0
[    0.410262] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.412005] pci 0000:00:07.0: reg 10: [io  0xc080-0xc0bf]
[    0.413375] pci 0000:00:07.0: reg 14: [mem 0xfebe7000-0xfebe7fff]
[    0.417383] device: '0000:00:07.0': device_add
[    0.418084] bus: 'pci': add device 0000:00:07.0
[    0.418742] PM: Adding info for pci:0000:00:07.0
[    0.419471] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.420674] pci 0000:00:08.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.422042] pci 0000:00:08.0: reg 14: [mem 0xfebe8000-0xfebe8fff]
[    0.426577] device: '0000:00:08.0': device_add
[    0.427228] bus: 'pci': add device 0000:00:08.0
[    0.427892] PM: Adding info for pci:0000:00:08.0
[    0.428090] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.429641] pci 0000:00:09.0: reg 10: [io  0xc100-0xc13f]
[    0.431024] pci 0000:00:09.0: reg 14: [mem 0xfebe9000-0xfebe9fff]
[    0.435251] device: '0000:00:09.0': device_add
[    0.436045] bus: 'pci': add device 0000:00:09.0
[    0.436706] PM: Adding info for pci:0000:00:09.0
[    0.437465] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.438999] pci 0000:00:0a.0: reg 10: [io  0xc140-0xc17f]
[    0.440616] pci 0000:00:0a.0: reg 14: [mem 0xfebea000-0xfebeafff]
[    0.444791] device: '0000:00:0a.0': device_add
[    0.445463] bus: 'pci': add device 0000:00:0a.0
[    0.446156] PM: Adding info for pci:0000:00:0a.0
[    0.446885] pci 0000:00:0b.0: [1af4:1001] type 00 class 0x010000
[    0.448319] pci 0000:00:0b.0: reg 10: [io  0xc180-0xc1bf]
[    0.449689] pci 0000:00:0b.0: reg 14: [mem 0xfebeb000-0xfebebfff]
[    0.453702] device: '0000:00:0b.0': device_add
[    0.454361] bus: 'pci': add device 0000:00:0b.0
[    0.455016] PM: Adding info for pci:0000:00:0b.0
[    0.455733] pci 0000:00:0c.0: [8086:25ab] type 00 class 0x088000
[    0.456370] pci 0000:00:0c.0: reg 10: [mem 0xfebec000-0xfebec00f]
[    0.460007] device: '0000:00:0c.0': device_add
[    0.460691] bus: 'pci': add device 0000:00:0c.0
[    0.461349] PM: Adding info for pci:0000:00:0c.0
[    0.462221] pci_bus 0000:00: on NUMA node 0
[    0.462818] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.464195] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.465217] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.466253] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.467267] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.468272] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.469221] device: 'LNXPWRBN:00': device_add
[    0.469874] bus: 'acpi': add device LNXPWRBN:00
[    0.470514] PM: Adding info for acpi:LNXPWRBN:00
[    0.471429] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.472013] acpi root: \_SB_.PCI0 notify handler is installed
[    0.472857] Found 1 acpi root devices
[    0.473379] bus: 'acpi': add driver ec
[    0.474122] bus: 'pnp': registered
[    0.474619] bus: 'platform': add driver reg-fixed-voltage
[    0.475394] device class 'misc': registering
[    0.476031] device: 'vga_arbiter': device_add
[    0.476659] PM: Adding info for No Bus:vga_arbiter
[    0.477348] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.478486] vgaarb: loaded
[    0.478870] vgaarb: bridge control possible 0000:00:02.0
[    0.479618] bus: 'spi': add driver tps65912
[    0.480009] bus: 'spi': add driver da9052
[    0.480703] device class 'scsi_host': registering
[    0.481388] bus: 'scsi': registered
[    0.481876] device class 'scsi_device': registering
[    0.482587] SCSI subsystem initialized
[    0.483126] ACPI: bus type ATA registered
[    0.484003] device class 'ata_link': registering
[    0.484651] device class 'ata_port': registering
[    0.485294] device class 'ata_device': registering
[    0.486002] libata version 3.00 loaded.
[    0.486548] device class 'mdio_bus': registering
[    0.487212] bus: 'mdio_bus': registered
[    0.487760] bus: 'mdio_bus': add driver Generic PHY
[    0.488020] device class 'pcmcia_socket': registering
[    0.488757] ACPI: bus type USB registered
[    0.489380] bus: 'usb': registered
[    0.489877] bus: 'usb': add driver usbfs
[    0.490451] usbcore: registered new interface driver usbfs
[    0.491226] bus: 'usb': add driver hub
[    0.492013] usbcore: registered new interface driver hub
[    0.496031] bus: 'usb': add driver usb
[    0.496600] usbcore: registered new device driver usb
[    0.497305] bus: 'platform': add driver omap-control-usb
[    0.498057] bus: 'serio': registered
[    0.498567] device class 'input': registering
[    0.500013] device class 'rtc': registering
[    0.500618] device class 'pps': registering
[    0.501212] pps_core: LinuxPPS API ver. 1 registered
[    0.501919] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.503183] device class 'ptp': registering
[    0.504016] PTP clock support registered
[    0.504576] device class 'power_supply': registering
[    0.505283] device class 'hwmon': registering
[    0.505929] bus: 'mmc': registered
[    0.506414] device class 'mmc_host': registering
[    0.507117] bus: 'sdio': registered
[    0.507614] device class 'leds': registering
[    0.508017] PCI: Using ACPI for IRQ routing
[    0.508614] PCI: pci_cache_line_size set to 64 bytes
[    0.509636] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    0.510478] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.511353] device class 'net': registering
[    0.512065] device: 'lo': device_add
[    0.512626] PM: Adding info for No Bus:lo
[    0.513261] irda_init()
[    0.513682] NET: Registered protocol family 23
[    0.514329] NET: Registered protocol family 8
[    0.514941] NET: Registered protocol family 20
[    0.515573] device class 'atm': registering
[    0.516021] device class 'ieee80211': registering
[    0.516736] Registering platform device 'regulatory.0'. Parent at platform
[    0.517702] device: 'regulatory.0': device_add
[    0.518325] bus: 'platform': add device regulatory.0
[    0.519024] PM: Adding info for platform:regulatory.0
[    0.536501] Switching to clocksource kvm-clock
[    0.562095] cfg80211: Calling CRDA to update world regulatory domain
[    0.563263] Warning: could not register annotated branches stats
[    0.576455] bus: 'pnp': add driver system
[    0.577090] pnp: PnP ACPI init
[    0.577533] device: 'pnp0': device_add
[    0.578079] PM: Adding info for No Bus:pnp0
[    0.578667] ACPI: bus type PNP registered
[    0.579282] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    0.580435] device: '00:00': device_add
[    0.580991] bus: 'pnp': add device 00:00
[    0.581553] PM: Adding info for pnp:00:00
[    0.582130] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.583097] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    0.584230] device: '00:01': device_add
[    0.584775] bus: 'pnp': add device 00:01
[    0.585342] PM: Adding info for pnp:00:01
[    0.585909] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.586854] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    0.588007] device: '00:02': device_add
[    0.588577] bus: 'pnp': add device 00:02
[    0.589141] PM: Adding info for pnp:00:02
[    0.589710] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.590649] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    0.591760] pnp 00:03: [dma 2]
[    0.592219] device: '00:03': device_add
[    0.592760] bus: 'pnp': add device 00:03
[    0.593323] PM: Adding info for pnp:00:03
[    0.593889] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.594860] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    0.595981] device: '00:04': device_add
[    0.596549] bus: 'pnp': add device 00:04
[    0.597116] PM: Adding info for pnp:00:04
[    0.597680] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.598638] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    0.599749] device: '00:05': device_add
[    0.600311] bus: 'pnp': add device 00:05
[    0.600866] PM: Adding info for pnp:00:05
[    0.601434] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.602506] device: '00:06': device_add
[    0.603059] bus: 'pnp': add device 00:06
[    0.603614] PM: Adding info for pnp:00:06
[    0.604194] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.605255] pnp: PnP ACPI: found 7 devices
[    0.605827] ACPI: bus type PNP unregistered
[    0.606429] device class 'mem': registering
[    0.607022] device: 'mem': device_add
[    0.607551] PM: Adding info for No Bus:mem
[    0.608151] device: 'kmem': device_add
[    0.608686] PM: Adding info for No Bus:kmem
[    0.609279] device: 'null': device_add
[    0.609816] PM: Adding info for No Bus:null
[    0.610418] device: 'port': device_add
[    0.610958] PM: Adding info for No Bus:port
[    0.611557] device: 'zero': device_add
[    0.612130] PM: Adding info for No Bus:zero
[    0.612719] device: 'full': device_add
[    0.613263] PM: Adding info for No Bus:full
[    0.613853] device: 'random': device_add
[    0.614420] PM: Adding info for No Bus:random
[    0.615039] device: 'urandom': device_add
[    0.615611] PM: Adding info for No Bus:urandom
[    0.616266] device: 'kmsg': device_add
[    0.616809] PM: Adding info for No Bus:kmsg
[    0.617416] device: 'oldmem': device_add
[    0.617985] PM: Adding info for No Bus:oldmem
[    0.618601] device: 'tty': device_add
[    0.619136] PM: Adding info for No Bus:tty
[    0.619733] device: 'console': device_add
[    0.620335] PM: Adding info for No Bus:console
[    0.620967] bus: 'pcmcia': registered
[    0.621493] device class 'thermal': registering
[    0.656789] bus: 'ssb': registered
[    0.657300] bus: 'pci': add driver b43-pci-bridge
[    0.657978] bus: 'bcma': registered
[    0.658484] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.659255] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    0.660136] NET: Registered protocol family 1
[    0.660753] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.661588] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.662414] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.663300] pci 0000:00:02.0: Boot video device
[    0.664059] PCI: CLS 0 bytes, default 64
[    0.664706] Unpacking initramfs...
[    3.178194] Freeing initrd memory: 25284k freed
[    3.190492] Machine check injector initialized
[    3.191160] device class 'cpuid': registering
[    3.191783] device: 'cpu0': device_add
[    3.202187] PM: Adding info for No Bus:cpu0
[    3.202815] device: 'cpu1': device_add
[    3.203364] PM: Adding info for No Bus:cpu1
[    3.203971] apm: BIOS not found.
[    3.204458] Scanning for low memory corruption every 60 seconds
[    3.205498] cryptomgr_test (27) used greatest stack depth: 7304 bytes left
[    3.206752] cryptomgr_probe (34) used greatest stack depth: 6884 bytes left
[    3.207865] cryptomgr_test (33) used greatest stack depth: 6448 bytes left
[    3.209002] The force parameter has not been set to 1. The Iris poweroff handler will not be installed.
[    3.210349] bus: 'clocksource': registered
[    3.210925] device: 'clocksource': device_add
[    3.211546] PM: Adding info for No Bus:clocksource
[    3.242147] device: 'clocksource0': device_add
[    3.242800] bus: 'clocksource': add device clocksource0
[    3.243601] PM: Adding info for clocksource:clocksource0
[    3.244397] bus: 'platform': add driver alarmtimer
[    3.245075] Registering platform device 'alarmtimer'. Parent at platform
[    3.246008] device: 'alarmtimer': device_add
[    3.246615] bus: 'platform': add device alarmtimer
[    3.247298] PM: Adding info for platform:alarmtimer
[    3.247991] bus: 'platform': driver_probe_device: matched device alarmtimer with driver alarmtimer
[    3.249260] bus: 'platform': really_probe: probing driver alarmtimer with device alarmtimer
[    3.250411] driver: 'alarmtimer': driver_bound: bound to device 'alarmtimer'
[    3.251389] bus: 'platform': really_probe: bound device alarmtimer to driver alarmtimer
[    3.262164] bus: 'rttest': registered
[    3.262679] device: 'rttest': device_add
[    3.263239] PM: Adding info for No Bus:rttest
[    3.263931] device: 'rttest0': device_add
[    3.264518] bus: 'rttest': add device rttest0
[    3.265133] PM: Adding info for rttest:rttest0
[    3.265784] device: 'rttest1': device_add
[    3.266348] bus: 'rttest': add device rttest1
[    3.266957] PM: Adding info for rttest:rttest1
[    3.267611] device: 'rttest2': device_add
[    3.268193] bus: 'rttest': add device rttest2
[    3.268803] PM: Adding info for rttest:rttest2
[    3.269463] device: 'rttest3': device_add
[    3.270025] bus: 'rttest': add device rttest3
[    3.270642] PM: Adding info for rttest:rttest3
[    3.271304] device: 'rttest4': device_add
[    3.271865] bus: 'rttest': add device rttest4
[    3.302158] PM: Adding info for rttest:rttest4
[    3.360163] device: 'rttest5': device_add
[    3.360766] bus: 'rttest': add device rttest5
[    3.361397] PM: Adding info for rttest:rttest5
[    3.362083] device: 'rttest6': device_add
[    3.362662] bus: 'rttest': add device rttest6
[    3.363289] PM: Adding info for rttest:rttest6
[    3.364065] device: 'rttest7': device_add
[    3.364650] bus: 'rttest': add device rttest7
[    3.365278] PM: Adding info for rttest:rttest7
[    3.365908] Initializing RT-Tester: OK
[    3.366523] bus: 'event_source': registered
[    3.367123] device: 'breakpoint': device_add
[    3.367728] bus: 'event_source': add device breakpoint
[    3.368499] PM: Adding info for event_source:breakpoint
[    3.369248] device: 'tracepoint': device_add
[    3.369854] bus: 'event_source': add device tracepoint
[    3.370666] PM: Adding info for event_source:tracepoint
[    3.371428] device: 'software': device_add
[    3.372005] bus: 'event_source': add device software
[    3.372788] PM: Adding info for event_source:software
[    3.408200] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    3.411212] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    3.412636] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    3.413378] jffs2: version 2.2. (NAND) 
[    3.414401] ROMFS MTD (C) 2007 Red Hat, Inc.
[    3.415256] NILFS version 2 loaded
[    3.415735] BeFS version: 0.9.3
[    3.416708] GFS2 installed
[    3.417319] msgmni has been set to 464
[    3.449302] alg: No test for crc32 (crc32-table)
[    3.450045] alg: No test for stdrng (krng)
[    3.487186] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    3.530232] device class 'bsg': registering
[    3.530857] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    3.531880] io scheduler noop registered
[    3.570221] io scheduler cfq registered (default)
[    3.570900] list_sort_test: start testing list_sort()
[    3.572381] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
[    3.573084] crc32: self tests passed, processed 225944 bytes in 215409 nsec
[    3.574268] crc32c: CRC_LE_BITS = 32
[    3.574773] crc32c: self tests passed, processed 225944 bytes in 107647 nsec
[    3.575854] xz_dec_test: module loaded
[    3.576408] xz_dec_test: Create a device node with 'mknod xz_dec_test c 250 0' and write .xz files to it.
[    3.577767] bus: 'platform': add driver basic-mmio-gpio
[    3.578507] bus: 'platform': add driver arizona-gpio
[    3.579283] bus: 'platform': add driver ts5500-dio
[    3.579994] bus: 'spi': add driver ams369fg06
[    3.580675] bus: 'spi': add driver l4f00242t03
[    3.581314] bus: 'spi': add driver lms283gf05
[    3.581926] bus: 'spi': add driver s6e63m0
[    3.582508] bus: 'spi': add driver tdo24m
[    3.583075] bus: 'spi': add driver VGG2432A4
[    3.583682] bus: 'platform': add driver da9052-wled
[    3.584418] bus: 'platform': add driver generic-bl
[    3.585108] bus: 'platform': add driver ipmi
[    3.585713] ipmi message handler version 39.2
[    3.586336] bus: 'platform': add driver ipmi_si
[    3.586971] IPMI System Interface driver.
[    3.587537] bus: 'pci': add driver ipmi_si
[    3.598177] bus: 'pnp': add driver ipmi_si
[    3.598779] ipmi_si: Adding default-specified kcs state machine
[    3.599639] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    3.601065] ipmi_si: Interface detection failed
[    3.620040] ipmi_si: Adding default-specified smic state machine
[    3.620926] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[    3.622331] ipmi_si: Interface detection failed
[    3.640047] ipmi_si: Adding default-specified bt state machine
[    3.640905] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[    3.642270] ipmi_si: Interface detection failed
[    3.660049] bus: 'pci': remove driver ipmi_si
[    3.660697] driver: 'ipmi_si': driver_release
[    3.661313] bus: 'pnp': remove driver ipmi_si
[    3.661922] driver: 'ipmi_si': driver_release
[    3.662537] bus: 'platform': remove driver ipmi_si
[    3.663210] driver: 'ipmi_si': driver_release
[    3.663819] ipmi_si: Unable to find any System Interface(s)
[    3.664614] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    3.665664] IPMI poweroff: Unable to register powercycle sysctl
[    3.666492] bus: 'acpi': add driver ac
[    3.667037] bus: 'acpi': add driver button
[    3.667624] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00 with driver button
[    3.668794] bus: 'acpi': really_probe: probing driver button with device LNXPWRBN:00
[    3.679933] device: 'input0': device_add
[    3.680556] PM: Adding info for No Bus:input0
[    3.681180] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    3.682196] ACPI: Power Button [PWRF]
[    3.682736] driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
[    3.683675] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to driver button
[    3.684721] bus: 'acpi': add driver fan
[    3.685275] bus: 'acpi': add driver processor
[    3.685895] bus: 'acpi': driver_probe_device: matched device LNXCPU:00 with driver processor
[    3.687061] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:00
[    3.688253] device: 'cooling_device0': device_add
[    3.688924] PM: Adding info for No Bus:cooling_device0
[    3.699721] driver: 'LNXCPU:00': driver_bound: bound to device 'processor'
[    3.700690] bus: 'acpi': really_probe: bound device LNXCPU:00 to driver processor
[    3.701720] bus: 'acpi': driver_probe_device: matched device LNXCPU:01 with driver processor
[    3.702879] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:01
[    3.704098] device: 'cooling_device1': device_add
[    3.704777] PM: Adding info for No Bus:cooling_device1
[    3.705519] driver: 'LNXCPU:01': driver_bound: bound to device 'processor'
[    3.706463] bus: 'acpi': really_probe: bound device LNXCPU:01 to driver processor
[    3.708713] bus: 'acpi': add driver thermal
[    3.709332] bus: 'platform': add driver timb-dma
[    3.729180] bus: 'platform': add driver virtio-mmio
[    3.729872] bus: 'virtio': add driver virtio_balloon
[    3.730575] bus: 'platform': add driver reg-virt-consumer
[    3.731334] bus: 'platform': add driver reg-userspace-consumer
[    3.732173] device: 'ptyp0': device_add
[    3.732725] PM: Adding info for No Bus:ptyp0
[    3.733337] device: 'ptyp1': device_add
[    3.733884] PM: Adding info for No Bus:ptyp1
[    3.734489] device: 'ptyp2': device_add
[    3.735054] PM: Adding info for No Bus:ptyp2
[    3.735670] device: 'ptyp3': device_add
[    3.746298] bus: 'acpi': add driver battery
[    3.746976] PM: Adding info for No Bus:ptyp3
[    3.747586] device: 'ptyp4': device_add
[    3.748156] PM: Adding info for No Bus:ptyp4
[    3.748754] device: 'ptyp5': device_add
[    3.749305] PM: Adding info for No Bus:ptyp5
[    3.749902] device: 'ptyp6': device_add
[    3.750467] PM: Adding info for No Bus:ptyp6
[    3.751066] device: 'ptyp7': device_add
[    3.751617] PM: Adding info for No Bus:ptyp7
[    3.752238] device: 'ptyp8': device_add
[    3.752783] PM: Adding info for No Bus:ptyp8
[    3.753390] device: 'ptyp9': device_add
[    3.753937] PM: Adding info for No Bus:ptyp9
[    3.754542] device: 'ptypa': device_add
[    3.755100] PM: Adding info for No Bus:ptypa
[    3.755714] device: 'ptypb': device_add
[    3.766332] PM: Adding info for No Bus:ptypb
[    3.766936] device: 'ptypc': device_add
[    3.767490] PM: Adding info for No Bus:ptypc
[    3.768102] device: 'ptypd': device_add
[    3.768654] PM: Adding info for No Bus:ptypd
[    3.769257] device: 'ptype': device_add
[    3.769815] PM: Adding info for No Bus:ptype
[    3.770420] device: 'ptypf': device_add
[    3.770967] PM: Adding info for No Bus:ptypf
[    3.771576] device: 'ptyq0': device_add
[    3.772145] PM: Adding info for No Bus:ptyq0
[    3.772753] device: 'ptyq1': device_add
[    3.773310] PM: Adding info for No Bus:ptyq1
[    3.773909] device: 'ptyq2': device_add
[    3.774472] PM: Adding info for No Bus:ptyq2
[    3.775072] device: 'ptyq3': device_add
[    3.775623] PM: Adding info for No Bus:ptyq3
[    3.776242] device: 'ptyq4': device_add
[    3.776791] PM: Adding info for No Bus:ptyq4
[    3.777395] device: 'ptyq5': device_add
[    3.777942] PM: Adding info for No Bus:ptyq5
[    3.778545] device: 'ptyq6': device_add
[    3.779103] PM: Adding info for No Bus:ptyq6
[    3.779707] device: 'ptyq7': device_add
[    3.780283] PM: Adding info for No Bus:ptyq7
[    3.780881] device: 'ptyq8': device_add
[    3.781433] PM: Adding info for No Bus:ptyq8
[    3.782030] device: 'ptyq9': device_add
[    3.782583] PM: Adding info for No Bus:ptyq9
[    3.783188] device: 'ptyqa': device_add
[    3.783741] PM: Adding info for No Bus:ptyqa
[    3.784362] device: 'ptyqb': device_add
[    3.784912] PM: Adding info for No Bus:ptyqb
[    3.785518] device: 'ptyqc': device_add
[    3.786068] PM: Adding info for No Bus:ptyqc
[    3.786691] device: 'ptyqd': device_add
[    3.787244] PM: Adding info for No Bus:ptyqd
[    3.787856] device: 'ptyqe': device_add
[    3.788428] PM: Adding info for No Bus:ptyqe
[    3.789032] device: 'ptyqf': device_add
[    3.789585] PM: Adding info for No Bus:ptyqf
[    3.790193] device: 'ptyr0': device_add
[    3.790741] PM: Adding info for No Bus:ptyr0
[    3.791346] device: 'ptyr1': device_add
[    3.791894] PM: Adding info for No Bus:ptyr1
[    3.792517] device: 'ptyr2': device_add
[    3.793074] PM: Adding info for No Bus:ptyr2
[    3.793677] device: 'ptyr3': device_add
[    3.794239] PM: Adding info for No Bus:ptyr3
[    3.794838] device: 'ptyr4': device_add
[    3.795390] PM: Adding info for No Bus:ptyr4
[    3.795988] device: 'ptyr5': device_add
[    3.796557] PM: Adding info for No Bus:ptyr5
[    3.797158] device: 'ptyr6': device_add
[    3.797719] PM: Adding info for No Bus:ptyr6
[    3.798324] device: 'ptyr7': device_add
[    3.798874] PM: Adding info for No Bus:ptyr7
[    3.799478] device: 'ptyr8': device_add
[    3.800040] PM: Adding info for No Bus:ptyr8
[    3.800643] device: 'ptyr9': device_add
[    3.801198] PM: Adding info for No Bus:ptyr9
[    3.801796] device: 'ptyra': device_add
[    3.802358] PM: Adding info for No Bus:ptyra
[    3.802955] device: 'ptyrb': device_add
[    3.803507] PM: Adding info for No Bus:ptyrb
[    3.804118] device: 'ptyrc': device_add
[    3.804668] PM: Adding info for No Bus:ptyrc
[    3.805278] device: 'ptyrd': device_add
[    3.805826] PM: Adding info for No Bus:ptyrd
[    3.806443] device: 'ptyre': device_add
[    3.807002] PM: Adding info for No Bus:ptyre
[    3.807607] device: 'ptyrf': device_add
[    3.808181] PM: Adding info for No Bus:ptyrf
[    3.808782] device: 'ptys0': device_add
[    3.809336] PM: Adding info for No Bus:ptys0
[    3.809934] device: 'ptys1': device_add
[    3.810483] PM: Adding info for No Bus:ptys1
[    3.811081] device: 'ptys2': device_add
[    3.811639] PM: Adding info for No Bus:ptys2
[    3.812261] device: 'ptys3': device_add
[    3.812807] PM: Adding info for No Bus:ptys3
[    3.813409] device: 'ptys4': device_add
[    3.813958] PM: Adding info for No Bus:ptys4
[    3.814560] device: 'ptys5': device_add
[    3.815106] PM: Adding info for No Bus:ptys5
[    3.815707] device: 'ptys6': device_add
[    3.816283] PM: Adding info for No Bus:ptys6
[    3.816880] device: 'ptys7': device_add
[    3.817434] PM: Adding info for No Bus:ptys7
[    3.818030] device: 'ptys8': device_add
[    3.818584] PM: Adding info for No Bus:ptys8
[    3.819186] device: 'ptys9': device_add
[    3.819733] PM: Adding info for No Bus:ptys9
[    3.820350] device: 'ptysa': device_add
[    3.820905] PM: Adding info for No Bus:ptysa
[    3.821510] device: 'ptysb': device_add
[    3.822069] PM: Adding info for No Bus:ptysb
[    3.822675] device: 'ptysc': device_add
[    3.823227] PM: Adding info for No Bus:ptysc
[    3.823830] device: 'ptysd': device_add
[    3.824400] PM: Adding info for No Bus:ptysd
[    3.825011] device: 'ptyse': device_add
[    3.825572] PM: Adding info for No Bus:ptyse
[    3.826174] device: 'ptysf': device_add
[    3.826720] PM: Adding info for No Bus:ptysf
[    3.827322] device: 'ptyt0': device_add
[    3.827868] PM: Adding info for No Bus:ptyt0
[    3.828487] device: 'ptyt1': device_add
[    3.829033] PM: Adding info for No Bus:ptyt1
[    3.829637] device: 'ptyt2': device_add
[    3.830197] PM: Adding info for No Bus:ptyt2
[    3.830795] device: 'ptyt3': device_add
[    3.831346] PM: Adding info for No Bus:ptyt3
[    3.831943] device: 'ptyt4': device_add
[    3.832511] PM: Adding info for No Bus:ptyt4
[    3.833107] device: 'ptyt5': device_add
[    3.833659] PM: Adding info for No Bus:ptyt5
[    3.834261] device: 'ptyt6': device_add
[    3.834815] PM: Adding info for No Bus:ptyt6
[    3.835417] device: 'ptyt7': device_add
[    3.835961] PM: Adding info for No Bus:ptyt7
[    3.836580] device: 'ptyt8': device_add
[    3.837125] PM: Adding info for No Bus:ptyt8
[    3.837729] device: 'ptyt9': device_add
[    3.838283] PM: Adding info for No Bus:ptyt9
[    3.838883] device: 'ptyta': device_add
[    3.839449] PM: Adding info for No Bus:ptyta
[    3.840064] device: 'ptytb': device_add
[    3.840619] PM: Adding info for No Bus:ptytb
[    3.841225] device: 'ptytc': device_add
[    3.841773] PM: Adding info for No Bus:ptytc
[    3.842377] device: 'ptytd': device_add
[    3.842924] PM: Adding info for No Bus:ptytd
[    3.843545] device: 'ptyte': device_add
[    3.844115] PM: Adding info for No Bus:ptyte
[    3.844720] device: 'ptytf': device_add
[    3.845274] PM: Adding info for No Bus:ptytf
[    3.845869] device: 'ptyu0': device_add
[    3.846419] PM: Adding info for No Bus:ptyu0
[    3.847014] device: 'ptyu1': device_add
[    3.847564] PM: Adding info for No Bus:ptyu1
[    3.848181] device: 'ptyu2': device_add
[    3.848735] PM: Adding info for No Bus:ptyu2
[    3.849337] device: 'ptyu3': device_add
[    3.849883] PM: Adding info for No Bus:ptyu3
[    3.850486] device: 'ptyu4': device_add
[    3.851035] PM: Adding info for No Bus:ptyu4
[    3.851638] device: 'ptyu5': device_add
[    3.852203] PM: Adding info for No Bus:ptyu5
[    3.852799] device: 'ptyu6': device_add
[    3.853359] PM: Adding info for No Bus:ptyu6
[    3.853963] device: 'ptyu7': device_add
[    3.854515] PM: Adding info for No Bus:ptyu7
[    3.855111] device: 'ptyu8': device_add
[    3.855662] PM: Adding info for No Bus:ptyu8
[    3.856278] device: 'ptyu9': device_add
[    3.856825] PM: Adding info for No Bus:ptyu9
[    3.857428] device: 'ptyua': device_add
[    3.857983] PM: Adding info for No Bus:ptyua
[    3.858586] device: 'ptyub': device_add
[    3.859139] PM: Adding info for No Bus:ptyub
[    3.859738] device: 'ptyuc': device_add
[    3.860309] PM: Adding info for No Bus:ptyuc
[    3.860907] device: 'ptyud': device_add
[    3.861458] PM: Adding info for No Bus:ptyud
[    3.862067] device: 'ptyue': device_add
[    3.862626] PM: Adding info for No Bus:ptyue
[    3.863230] device: 'ptyuf': device_add
[    3.863775] PM: Adding info for No Bus:ptyuf
[    3.864394] device: 'ptyv0': device_add
[    3.864940] PM: Adding info for No Bus:ptyv0
[    3.865543] device: 'ptyv1': device_add
[    3.866090] PM: Adding info for No Bus:ptyv1
[    3.866701] device: 'ptyv2': device_add
[    3.867264] PM: Adding info for No Bus:ptyv2
[    3.867862] device: 'ptyv3': device_add
[    3.868429] PM: Adding info for No Bus:ptyv3
[    3.869028] device: 'ptyv4': device_add
[    3.869583] PM: Adding info for No Bus:ptyv4
[    3.870185] device: 'ptyv5': device_add
[    3.870730] PM: Adding info for No Bus:ptyv5
[    3.871333] device: 'ptyv6': device_add
[    3.871887] PM: Adding info for No Bus:ptyv6
[    3.872504] device: 'ptyv7': device_add
[    3.873047] PM: Adding info for No Bus:ptyv7
[    3.873655] device: 'ptyv8': device_add
[    3.874208] PM: Adding info for No Bus:ptyv8
[    3.874806] device: 'ptyv9': device_add
[    3.875358] PM: Adding info for No Bus:ptyv9
[    3.875956] device: 'ptyva': device_add
[    3.876531] PM: Adding info for No Bus:ptyva
[    3.877128] device: 'ptyvb': device_add
[    3.877679] PM: Adding info for No Bus:ptyvb
[    3.878282] device: 'ptyvc': device_add
[    3.878828] PM: Adding info for No Bus:ptyvc
[    3.879429] device: 'ptyvd': device_add
[    3.879977] PM: Adding info for No Bus:ptyvd
[    3.880605] device: 'ptyve': device_add
[    3.881163] PM: Adding info for No Bus:ptyve
[    3.881761] device: 'ptyvf': device_add
[    3.882315] PM: Adding info for No Bus:ptyvf
[    3.882913] device: 'ptyw0': device_add
[    3.883465] PM: Adding info for No Bus:ptyw0
[    3.884078] device: 'ptyw1': device_add
[    3.884629] PM: Adding info for No Bus:ptyw1
[    3.885237] device: 'ptyw2': device_add
[    3.885793] PM: Adding info for No Bus:ptyw2
[    3.886398] device: 'ptyw3': device_add
[    3.886952] PM: Adding info for No Bus:ptyw3
[    3.887559] device: 'ptyw4': device_add
[    3.888126] PM: Adding info for No Bus:ptyw4
[    3.888731] device: 'ptyw5': device_add
[    3.889286] PM: Adding info for No Bus:ptyw5
[    3.889888] device: 'ptyw6': device_add
[    3.890448] PM: Adding info for No Bus:ptyw6
[    3.891047] device: 'ptyw7': device_add
[    3.891600] PM: Adding info for No Bus:ptyw7
[    3.892224] device: 'ptyw8': device_add
[    3.892770] PM: Adding info for No Bus:ptyw8
[    3.893373] device: 'ptyw9': device_add
[    3.893919] PM: Adding info for No Bus:ptyw9
[    3.894523] device: 'ptywa': device_add
[    3.895079] PM: Adding info for No Bus:ptywa
[    3.895683] device: 'ptywb': device_add
[    3.896251] PM: Adding info for No Bus:ptywb
[    3.896849] device: 'ptywc': device_add
[    3.897401] PM: Adding info for No Bus:ptywc
[    3.898001] device: 'ptywd': device_add
[    3.898552] PM: Adding info for No Bus:ptywd
[    3.899167] device: 'ptywe': device_add
[    3.899724] PM: Adding info for No Bus:ptywe
[    3.900347] device: 'ptywf': device_add
[    3.900899] PM: Adding info for No Bus:ptywf
[    3.901506] device: 'ptyx0': device_add
[    3.902055] PM: Adding info for No Bus:ptyx0
[    3.902668] device: 'ptyx1': device_add
[    3.903228] PM: Adding info for No Bus:ptyx1
[    3.903830] device: 'ptyx2': device_add
[    3.904413] PM: Adding info for No Bus:ptyx2
[    3.905013] device: 'ptyx3': device_add
[    3.905571] PM: Adding info for No Bus:ptyx3
[    3.906175] device: 'ptyx4': device_add
[    3.906722] PM: Adding info for No Bus:ptyx4
[    3.907326] device: 'ptyx5': device_add
[    3.907872] PM: Adding info for No Bus:ptyx5
[    3.908492] device: 'ptyx6': device_add
[    3.909055] PM: Adding info for No Bus:ptyx6
[    3.909659] device: 'ptyx7': device_add
[    3.910211] PM: Adding info for No Bus:ptyx7
[    3.910808] device: 'ptyx8': device_add
[    3.911361] PM: Adding info for No Bus:ptyx8
[    3.911958] device: 'ptyx9': device_add
[    3.912527] PM: Adding info for No Bus:ptyx9
[    3.913125] device: 'ptyxa': device_add
[    3.913686] PM: Adding info for No Bus:ptyxa
[    3.914290] device: 'ptyxb': device_add
[    3.914840] PM: Adding info for No Bus:ptyxb
[    3.915445] device: 'ptyxc': device_add
[    3.915993] PM: Adding info for No Bus:ptyxc
[    3.916616] device: 'ptyxd': device_add
[    3.917167] PM: Adding info for No Bus:ptyxd
[    3.917778] device: 'ptyxe': device_add
[    3.918339] PM: Adding info for No Bus:ptyxe
[    3.918937] device: 'ptyxf': device_add
[    3.919490] PM: Adding info for No Bus:ptyxf
[    3.920102] device: 'ptyy0': device_add
[    3.920652] PM: Adding info for No Bus:ptyy0
[    3.921255] device: 'ptyy1': device_add
[    3.921803] PM: Adding info for No Bus:ptyy1
[    3.922407] device: 'ptyy2': device_add
[    3.922962] PM: Adding info for No Bus:ptyy2
[    3.923566] device: 'ptyy3': device_add
[    3.924127] PM: Adding info for No Bus:ptyy3
[    3.924738] device: 'ptyy4': device_add
[    3.925293] PM: Adding info for No Bus:ptyy4
[    3.925891] device: 'ptyy5': device_add
[    3.926445] PM: Adding info for No Bus:ptyy5
[    3.927043] device: 'ptyy6': device_add
[    3.927608] PM: Adding info for No Bus:ptyy6
[    3.928228] device: 'ptyy7': device_add
[    3.928774] PM: Adding info for No Bus:ptyy7
[    3.929376] device: 'ptyy8': device_add
[    3.929924] PM: Adding info for No Bus:ptyy8
[    3.930528] device: 'ptyy9': device_add
[    3.931077] PM: Adding info for No Bus:ptyy9
[    3.931683] device: 'ptyya': device_add
[    3.932266] PM: Adding info for No Bus:ptyya
[    3.932868] device: 'ptyyb': device_add
[    3.933427] PM: Adding info for No Bus:ptyyb
[    3.934032] device: 'ptyyc': device_add
[    3.934590] PM: Adding info for No Bus:ptyyc
[    3.935196] device: 'ptyyd': device_add
[    3.935745] PM: Adding info for No Bus:ptyyd
[    3.936378] device: 'ptyye': device_add
[    3.936932] PM: Adding info for No Bus:ptyye
[    3.937539] device: 'ptyyf': device_add
[    3.938085] PM: Adding info for No Bus:ptyyf
[    3.938690] device: 'ptyz0': device_add
[    3.939240] PM: Adding info for No Bus:ptyz0
[    3.939840] device: 'ptyz1': device_add
[    3.940421] PM: Adding info for No Bus:ptyz1
[    3.941020] device: 'ptyz2': device_add
[    3.941584] PM: Adding info for No Bus:ptyz2
[    3.942187] device: 'ptyz3': device_add
[    3.942733] PM: Adding info for No Bus:ptyz3
[    3.943339] device: 'ptyz4': device_add
[    3.943891] PM: Adding info for No Bus:ptyz4
[    3.944514] device: 'ptyz5': device_add
[    3.945063] PM: Adding info for No Bus:ptyz5
[    3.945667] device: 'ptyz6': device_add
[    3.946226] PM: Adding info for No Bus:ptyz6
[    3.946828] device: 'ptyz7': device_add
[    3.947382] PM: Adding info for No Bus:ptyz7
[    3.947981] device: 'ptyz8': device_add
[    3.948553] PM: Adding info for No Bus:ptyz8
[    3.949154] device: 'ptyz9': device_add
[    3.949702] PM: Adding info for No Bus:ptyz9
[    3.950306] device: 'ptyza': device_add
[    3.950860] PM: Adding info for No Bus:ptyza
[    3.951470] device: 'ptyzb': device_add
[    3.952037] PM: Adding info for No Bus:ptyzb
[    3.952640] device: 'ptyzc': device_add
[    3.953190] PM: Adding info for No Bus:ptyzc
[    3.953789] device: 'ptyzd': device_add
[    3.954340] PM: Adding info for No Bus:ptyzd
[    3.954949] device: 'ptyze': device_add
[    3.955508] PM: Adding info for No Bus:ptyze
[    3.956120] device: 'ptyzf': device_add
[    3.956671] PM: Adding info for No Bus:ptyzf
[    3.957275] device: 'ptya0': device_add
[    3.957824] PM: Adding info for No Bus:ptya0
[    3.958428] device: 'ptya1': device_add
[    3.958975] PM: Adding info for No Bus:ptya1
[    3.959578] device: 'ptya2': device_add
[    3.960155] PM: Adding info for No Bus:ptya2
[    3.960754] device: 'ptya3': device_add
[    3.961305] PM: Adding info for No Bus:ptya3
[    3.961904] device: 'ptya4': device_add
[    3.962457] PM: Adding info for No Bus:ptya4
[    3.963056] device: 'ptya5': device_add
[    3.963607] PM: Adding info for No Bus:ptya5
[    3.964224] device: 'ptya6': device_add
[    3.964778] PM: Adding info for No Bus:ptya6
[    3.965381] device: 'ptya7': device_add
[    3.965927] PM: Adding info for No Bus:ptya7
[    3.966534] device: 'ptya8': device_add
[    3.967078] PM: Adding info for No Bus:ptya8
[    3.967682] device: 'ptya9': device_add
[    3.968246] PM: Adding info for No Bus:ptya9
[    3.968842] device: 'ptyaa': device_add
[    3.969404] PM: Adding info for No Bus:ptyaa
[    3.970004] device: 'ptyab': device_add
[    3.970559] PM: Adding info for No Bus:ptyab
[    3.971162] device: 'ptyac': device_add
[    3.971711] PM: Adding info for No Bus:ptyac
[    3.972331] device: 'ptyad': device_add
[    3.972878] PM: Adding info for No Bus:ptyad
[    3.973494] device: 'ptyae': device_add
[    3.974048] PM: Adding info for No Bus:ptyae
[    3.974652] device: 'ptyaf': device_add
[    3.975202] PM: Adding info for No Bus:ptyaf
[    3.975805] device: 'ptyb0': device_add
[    3.976373] PM: Adding info for No Bus:ptyb0
[    3.976969] device: 'ptyb1': device_add
[    3.977524] PM: Adding info for No Bus:ptyb1
[    3.978125] device: 'ptyb2': device_add
[    3.978685] PM: Adding info for No Bus:ptyb2
[    3.979291] device: 'ptyb3': device_add
[    3.979841] PM: Adding info for No Bus:ptyb3
[    3.980460] device: 'ptyb4': device_add
[    3.981006] PM: Adding info for No Bus:ptyb4
[    3.981610] device: 'ptyb5': device_add
[    3.982162] PM: Adding info for No Bus:ptyb5
[    3.982762] device: 'ptyb6': device_add
[    3.983323] PM: Adding info for No Bus:ptyb6
[    3.983922] device: 'ptyb7': device_add
[    3.984490] PM: Adding info for No Bus:ptyb7
[    3.985086] device: 'ptyb8': device_add
[    3.985640] PM: Adding info for No Bus:ptyb8
[    3.986246] device: 'ptyb9': device_add
[    3.986796] PM: Adding info for No Bus:ptyb9
[    3.987401] device: 'ptyba': device_add
[    3.987955] PM: Adding info for No Bus:ptyba
[    3.988576] device: 'ptybb': device_add
[    3.989122] PM: Adding info for No Bus:ptybb
[    3.989727] device: 'ptybc': device_add
[    3.990278] PM: Adding info for No Bus:ptybc
[    3.990879] device: 'ptybd': device_add
[    3.991430] PM: Adding info for No Bus:ptybd
[    3.992055] device: 'ptybe': device_add
[    3.992612] PM: Adding info for No Bus:ptybe
[    3.993216] device: 'ptybf': device_add
[    3.993763] PM: Adding info for No Bus:ptybf
[    3.994371] device: 'ptyc0': device_add
[    3.994918] PM: Adding info for No Bus:ptyc0
[    3.995525] device: 'ptyc1': device_add
[    3.996084] PM: Adding info for No Bus:ptyc1
[    3.996687] device: 'ptyc2': device_add
[    3.997246] PM: Adding info for No Bus:ptyc2
[    3.997848] device: 'ptyc3': device_add
[    3.998403] PM: Adding info for No Bus:ptyc3
[    3.999002] device: 'ptyc4': device_add
[    3.999556] PM: Adding info for No Bus:ptyc4
[    4.000181] device: 'ptyc5': device_add
[    4.000727] PM: Adding info for No Bus:ptyc5
[    4.001331] device: 'ptyc6': device_add
[    4.001884] PM: Adding info for No Bus:ptyc6
[    4.002488] device: 'ptyc7': device_add
[    4.003038] PM: Adding info for No Bus:ptyc7
[    4.003646] device: 'ptyc8': device_add
[    4.004217] PM: Adding info for No Bus:ptyc8
[    4.004811] device: 'ptyc9': device_add
[    4.005363] PM: Adding info for No Bus:ptyc9
[    4.005961] device: 'ptyca': device_add
[    4.006522] PM: Adding info for No Bus:ptyca
[    4.007120] device: 'ptycb': device_add
[    4.007675] PM: Adding info for No Bus:ptycb
[    4.008297] device: 'ptycc': device_add
[    4.008849] PM: Adding info for No Bus:ptycc
[    4.009459] device: 'ptycd': device_add
[    4.010013] PM: Adding info for No Bus:ptycd
[    4.010635] device: 'ptyce': device_add
[    4.011197] PM: Adding info for No Bus:ptyce
[    4.011798] device: 'ptycf': device_add
[    4.012370] PM: Adding info for No Bus:ptycf
[    4.012967] device: 'ptyd0': device_add
[    4.013526] PM: Adding info for No Bus:ptyd0
[    4.014126] device: 'ptyd1': device_add
[    4.014683] PM: Adding info for No Bus:ptyd1
[    4.015288] device: 'ptyd2': device_add
[    4.015847] PM: Adding info for No Bus:ptyd2
[    4.016471] device: 'ptyd3': device_add
[    4.017016] PM: Adding info for No Bus:ptyd3
[    4.017620] device: 'ptyd4': device_add
[    4.018169] PM: Adding info for No Bus:ptyd4
[    4.018768] device: 'ptyd5': device_add
[    4.019320] PM: Adding info for No Bus:ptyd5
[    4.019920] device: 'ptyd6': device_add
[    4.020497] PM: Adding info for No Bus:ptyd6
[    4.021094] device: 'ptyd7': device_add
[    4.021648] PM: Adding info for No Bus:ptyd7
[    4.022250] device: 'ptyd8': device_add
[    4.022795] PM: Adding info for No Bus:ptyd8
[    4.023398] device: 'ptyd9': device_add
[    4.023945] PM: Adding info for No Bus:ptyd9
[    4.024566] device: 'ptyda': device_add
[    4.025124] PM: Adding info for No Bus:ptyda
[    4.025728] device: 'ptydb': device_add
[    4.026280] PM: Adding info for No Bus:ptydb
[    4.026883] device: 'ptydc': device_add
[    4.027445] PM: Adding info for No Bus:ptydc
[    4.028064] device: 'ptydd': device_add
[    4.028616] PM: Adding info for No Bus:ptydd
[    4.029237] device: 'ptyde': device_add
[    4.029794] PM: Adding info for No Bus:ptyde
[    4.030402] device: 'ptydf': device_add
[    4.030958] PM: Adding info for No Bus:ptydf
[    4.031568] device: 'ptye0': device_add
[    4.032136] PM: Adding info for No Bus:ptye0
[    4.032743] device: 'ptye1': device_add
[    4.033303] PM: Adding info for No Bus:ptye1
[    4.033908] device: 'ptye2': device_add
[    4.034473] PM: Adding info for No Bus:ptye2
[    4.035074] device: 'ptye3': device_add
[    4.035630] PM: Adding info for No Bus:ptye3
[    4.036250] device: 'ptye4': device_add
[    4.036798] PM: Adding info for No Bus:ptye4
[    4.037411] device: 'ptye5': device_add
[    4.037960] PM: Adding info for No Bus:ptye5
[    4.038566] device: 'ptye6': device_add
[    4.039125] PM: Adding info for No Bus:ptye6
[    4.039730] device: 'ptye7': device_add
[    4.040298] PM: Adding info for No Bus:ptye7
[    4.040898] device: 'ptye8': device_add
[    4.041453] PM: Adding info for No Bus:ptye8
[    4.042055] device: 'ptye9': device_add
[    4.042610] PM: Adding info for No Bus:ptye9
[    4.043216] device: 'ptyea': device_add
[    4.043774] PM: Adding info for No Bus:ptyea
[    4.044395] device: 'ptyeb': device_add
[    4.044940] PM: Adding info for No Bus:ptyeb
[    4.045545] device: 'ptyec': device_add
[    4.046090] PM: Adding info for No Bus:ptyec
[    4.046695] device: 'ptyed': device_add
[    4.047257] PM: Adding info for No Bus:ptyed
[    4.047871] device: 'ptyee': device_add
[    4.048453] PM: Adding info for No Bus:ptyee
[    4.049062] device: 'ptyef': device_add
[    4.049620] PM: Adding info for No Bus:ptyef
[    4.050247] device: 'ttyp0': device_add
[    4.050795] PM: Adding info for No Bus:ttyp0
[    4.054359] device: 'ttyp1': device_add
[    4.054911] PM: Adding info for No Bus:ttyp1
[    4.055520] device: 'ttyp2': device_add
[    4.056097] PM: Adding info for No Bus:ttyp2
[    4.056706] device: 'ttyp3': device_add
[    4.057260] PM: Adding info for No Bus:ttyp3
[    4.057859] device: 'ttyp4': device_add
[    4.058412] PM: Adding info for No Bus:ttyp4
[    4.059010] device: 'ttyp5': device_add
[    4.059565] PM: Adding info for No Bus:ttyp5
[    4.060186] device: 'ttyp6': device_add
[    4.060740] PM: Adding info for No Bus:ttyp6
[    4.061345] device: 'ttyp7': device_add
[    4.061892] PM: Adding info for No Bus:ttyp7
[    4.062510] device: 'ttyp8': device_add
[    4.063058] PM: Adding info for No Bus:ttyp8
[    4.073793] device: 'ttyp9': device_add
[    4.074362] PM: Adding info for No Bus:ttyp9
[    4.074968] device: 'ttypa': device_add
[    4.075541] PM: Adding info for No Bus:ttypa
[    4.076161] device: 'ttypb': device_add
[    4.076712] PM: Adding info for No Bus:ttypb
[    4.077320] device: 'ttypc': device_add
[    4.077874] PM: Adding info for No Bus:ttypc
[    4.078485] device: 'ttypd': device_add
[    4.079039] PM: Adding info for No Bus:ttypd
[    4.079668] device: 'ttype': device_add
[    4.080245] PM: Adding info for No Bus:ttype
[    4.080842] device: 'ttypf': device_add
[    4.081396] PM: Adding info for No Bus:ttypf
[    4.081993] device: 'ttyq0': device_add
[    4.082545] PM: Adding info for No Bus:ttyq0
[    4.083140] device: 'ttyq1': device_add
[    4.097547] PM: Adding info for No Bus:ttyq1
[    4.098162] device: 'ttyq2': device_add
[    4.098729] PM: Adding info for No Bus:ttyq2
[    4.099332] device: 'ttyq3': device_add
[    4.099879] PM: Adding info for No Bus:ttyq3
[    4.100499] device: 'ttyq4': device_add
[    4.101047] PM: Adding info for No Bus:ttyq4
[    4.101650] device: 'ttyq5': device_add
[    4.102198] PM: Adding info for No Bus:ttyq5
[    4.102795] device: 'ttyq6': device_add
[    4.103355] PM: Adding info for No Bus:ttyq6
[    4.103951] device: 'ttyq7': device_add
[    4.104521] PM: Adding info for No Bus:ttyq7
[    4.105120] device: 'ttyq8': device_add
[    4.105678] PM: Adding info for No Bus:ttyq8
[    4.106281] device: 'ttyq9': device_add
[    4.106828] PM: Adding info for No Bus:ttyq9
[    4.108922] device: 'ttyqa': device_add
[    4.109494] PM: Adding info for No Bus:ttyqa
[    4.110097] device: 'ttyqb': device_add
[    4.110653] PM: Adding info for No Bus:ttyqb
[    4.111259] device: 'ttyqc': device_add
[    4.111807] PM: Adding info for No Bus:ttyqc
[    4.112430] device: 'ttyqd': device_add
[    4.112978] PM: Adding info for No Bus:ttyqd
[    4.113596] device: 'ttyqe': device_add
[    4.114169] PM: Adding info for No Bus:ttyqe
[    4.114770] device: 'ttyqf': device_add
[    4.116941] PM: Adding info for No Bus:ttyqf
[    4.117555] device: 'ttyr0': device_add
[    4.118112] PM: Adding info for No Bus:ttyr0
[    4.118725] device: 'ttyr1': device_add
[    4.119285] PM: Adding info for No Bus:ttyr1
[    4.120028] device: 'ttyr2': device_add
[    4.120602] PM: Adding info for No Bus:ttyr2
[    4.121212] device: 'ttyr3': device_add
[    4.121766] PM: Adding info for No Bus:ttyr3
[    4.122385] device: 'ttyr4': device_add
[    4.122934] PM: Adding info for No Bus:ttyr4
[    4.123582] device: 'ttyr5': device_add
[    4.124156] PM: Adding info for No Bus:ttyr5
[    4.124760] device: 'ttyr6': device_add
[    4.125334] PM: Adding info for No Bus:ttyr6
[    4.125935] device: 'ttyr7': device_add
[    4.126558] PM: Adding info for No Bus:ttyr7
[    4.127164] device: 'ttyr8': device_add
[    4.127711] PM: Adding info for No Bus:ttyr8
[    4.128333] device: 'ttyr9': device_add
[    4.128883] PM: Adding info for No Bus:ttyr9
[    4.129492] device: 'ttyra': device_add
[    4.130081] PM: Adding info for No Bus:ttyra
[    4.130687] device: 'ttyrb': device_add
[    4.131244] PM: Adding info for No Bus:ttyrb
[    4.131843] device: 'ttyrc': device_add
[    4.132414] PM: Adding info for No Bus:ttyrc
[    4.133044] device: 'ttyrd': device_add
[    4.133597] PM: Adding info for No Bus:ttyrd
[    4.134216] device: 'ttyre': device_add
[    4.134773] PM: Adding info for No Bus:ttyre
[    4.135577] device: 'ttyrf': device_add
[    4.145743] PM: Adding info for No Bus:ttyrf
[    4.146355] device: 'ttys0': device_add
[    4.146907] PM: Adding info for No Bus:ttys0
[    4.147515] device: 'ttys1': device_add
[    4.148079] PM: Adding info for No Bus:ttys1
[    4.148684] device: 'ttys2': device_add
[    4.149254] PM: Adding info for No Bus:ttys2
[    4.149852] device: 'ttys3': device_add
[    4.150409] PM: Adding info for No Bus:ttys3
[    4.151011] device: 'ttys4': device_add
[    4.151568] PM: Adding info for No Bus:ttys4
[    4.152190] device: 'ttys5': device_add
[    4.152740] PM: Adding info for No Bus:ttys5
[    4.153348] device: 'ttys6': device_add
[    4.153907] PM: Adding info for No Bus:ttys6
[    4.154512] device: 'ttys7': device_add
[    4.155059] PM: Adding info for No Bus:ttys7
[    4.170443] device: 'ttys8': device_add
[    4.170999] PM: Adding info for No Bus:ttys8
[    4.171606] device: 'ttys9': device_add
[    4.172174] PM: Adding info for No Bus:ttys9
[    4.172770] device: 'ttysa': device_add
[    4.173343] PM: Adding info for No Bus:ttysa
[    4.173940] device: 'ttysb': device_add
[    4.174493] PM: Adding info for No Bus:ttysb
[    4.175091] device: 'ttysc': device_add
[    4.175642] PM: Adding info for No Bus:ttysc
[    4.176261] device: 'ttysd': device_add
[    4.176807] PM: Adding info for No Bus:ttysd
[    4.177425] device: 'ttyse': device_add
[    4.177979] PM: Adding info for No Bus:ttyse
[    4.178586] device: 'ttysf': device_add
[    4.179131] PM: Adding info for No Bus:ttysf
[    4.179734] device: 'ttyt0': device_add
[    4.181633] PM: Adding info for No Bus:ttyt0
[    4.182239] device: 'ttyt1': device_add
[    4.182788] PM: Adding info for No Bus:ttyt1
[    4.183462] device: 'ttyt2': device_add
[    4.194392] tsc: Refined TSC clocksource calibration: 2992.497 MHz
[    4.195294] PM: Adding info for No Bus:ttyt2
[    4.195901] device: 'ttyt3': device_add
[    4.196485] PM: Adding info for No Bus:ttyt3
[    4.197086] device: 'ttyt4': device_add
[    4.197642] PM: Adding info for No Bus:ttyt4
[    4.198245] device: 'ttyt5': device_add
[    4.198794] PM: Adding info for No Bus:ttyt5
[    4.199400] device: 'ttyt6': device_add
[    4.199957] PM: Adding info for No Bus:ttyt6
[    4.200581] device: 'ttyt7': device_add
[    4.201127] PM: Adding info for No Bus:ttyt7
[    4.201731] device: 'ttyt8': device_add
[    4.202284] PM: Adding info for No Bus:ttyt8
[    4.202881] device: 'ttyt9': device_add
[    4.203433] PM: Adding info for No Bus:ttyt9
[    4.204046] device: 'ttyta': device_add
[    4.215542] PM: Adding info for No Bus:ttyta
[    4.216170] device: 'ttytb': device_add
[    4.216720] PM: Adding info for No Bus:ttytb
[    4.217324] device: 'ttytc': device_add
[    4.217870] PM: Adding info for No Bus:ttytc
[    4.218472] device: 'ttytd': device_add
[    4.219018] PM: Adding info for No Bus:ttytd
[    4.219632] device: 'ttyte': device_add
[    4.220207] PM: Adding info for No Bus:ttyte
[    4.220802] device: 'ttytf': device_add
[    4.221354] PM: Adding info for No Bus:ttytf
[    4.221950] device: 'ttyu0': device_add
[    4.222504] PM: Adding info for No Bus:ttyu0
[    4.223102] device: 'ttyu1': device_add
[    4.223656] PM: Adding info for No Bus:ttyu1
[    4.224284] device: 'ttyu2': device_add
[    4.224846] PM: Adding info for No Bus:ttyu2
[    4.229771] device: 'ttyu3': device_add
[    4.230335] PM: Adding info for No Bus:ttyu3
[    4.230936] device: 'ttyu4': device_add
[    4.231490] PM: Adding info for No Bus:ttyu4
[    4.232107] device: 'ttyu5': device_add
[    4.232671] PM: Adding info for No Bus:ttyu5
[    4.233278] device: 'ttyu6': device_add
[    4.233844] PM: Adding info for No Bus:ttyu6
[    4.234450] device: 'ttyu7': device_add
[    4.235001] PM: Adding info for No Bus:ttyu7
[    4.235607] device: 'ttyu8': device_add
[    4.236176] PM: Adding info for No Bus:ttyu8
[    4.236779] device: 'ttyu9': device_add
[    4.237336] PM: Adding info for No Bus:ttyu9
[    4.237936] device: 'ttyua': device_add
[    4.255601] PM: Adding info for No Bus:ttyua
[    4.256230] device: 'ttyub': device_add
[    4.256777] PM: Adding info for No Bus:ttyub
[    4.257383] device: 'ttyuc': device_add
[    4.257934] PM: Adding info for No Bus:ttyuc
[    4.258536] device: 'ttyud': device_add
[    4.259084] PM: Adding info for No Bus:ttyud
[    4.259700] device: 'ttyue': device_add
[    4.260278] PM: Adding info for No Bus:ttyue
[    4.260876] device: 'ttyuf': device_add
[    4.261430] PM: Adding info for No Bus:ttyuf
[    4.262031] device: 'ttyv0': device_add
[    4.262585] PM: Adding info for No Bus:ttyv0
[    4.263191] device: 'ttyv1': device_add
[    4.263738] PM: Adding info for No Bus:ttyv1
[    4.264358] device: 'ttyv2': device_add
[    4.264912] PM: Adding info for No Bus:ttyv2
[    4.269424] device: 'ttyv3': device_add
[    4.269983] PM: Adding info for No Bus:ttyv3
[    4.270591] device: 'ttyv4': device_add
[    4.271146] PM: Adding info for No Bus:ttyv4
[    4.271754] device: 'ttyv5': device_add
[    4.272327] PM: Adding info for No Bus:ttyv5
[    4.272930] device: 'ttyv6': device_add
[    4.273497] PM: Adding info for No Bus:ttyv6
[    4.274100] device: 'ttyv7': device_add
[    4.274659] PM: Adding info for No Bus:ttyv7
[    4.275266] device: 'ttyv8': device_add
[    4.275817] PM: Adding info for No Bus:ttyv8
[    4.276441] device: 'ttyv9': device_add
[    4.276987] PM: Adding info for No Bus:ttyv9
[    4.277592] device: 'ttyva': device_add
[    4.278146] PM: Adding info for No Bus:ttyva
[    4.286856] device: 'ttyvb': device_add
[    4.287429] PM: Adding info for No Bus:ttyvb
[    4.288073] device: 'ttyvc': device_add
[    4.288843] PM: Adding info for No Bus:ttyvc
[    4.289448] device: 'ttyvd': device_add
[    4.290007] PM: Adding info for No Bus:ttyvd
[    4.290627] device: 'ttyve': device_add
[    4.291202] PM: Adding info for No Bus:ttyve
[    4.291803] device: 'ttyvf': device_add
[    4.292383] PM: Adding info for No Bus:ttyvf
[    4.292990] device: 'ttyw0': device_add
[    4.293542] PM: Adding info for No Bus:ttyw0
[    4.294150] device: 'ttyw1': device_add
[    4.294700] PM: Adding info for No Bus:ttyw1
[    4.295306] device: 'ttyw2': device_add
[    4.295864] PM: Adding info for No Bus:ttyw2
[    4.296484] device: 'ttyw3': device_add
[    4.297033] PM: Adding info for No Bus:ttyw3
[    4.297633] device: 'ttyw4': device_add
[    4.298253] PM: Adding info for No Bus:ttyw4
[    4.298852] device: 'ttyw5': device_add
[    4.299410] PM: Adding info for No Bus:ttyw5
[    4.300045] device: 'ttyw6': device_add
[    4.300612] PM: Adding info for No Bus:ttyw6
[    4.301219] device: 'ttyw7': device_add
[    4.301772] PM: Adding info for No Bus:ttyw7
[    4.302382] device: 'ttyw8': device_add
[    4.302940] PM: Adding info for No Bus:ttyw8
[    4.303546] device: 'ttyw9': device_add
[    4.304127] PM: Adding info for No Bus:ttyw9
[    4.304729] device: 'ttywa': device_add
[    4.305297] PM: Adding info for No Bus:ttywa
[    4.305901] device: 'ttywb': device_add
[    4.306561] PM: Adding info for No Bus:ttywb
[    4.307180] device: 'ttywc': device_add
[    4.307966] PM: Adding info for No Bus:ttywc
[    4.308588] device: 'ttywd': device_add
[    4.309139] PM: Adding info for No Bus:ttywd
[    4.309750] device: 'ttywe': device_add
[    4.310321] PM: Adding info for No Bus:ttywe
[    4.310920] device: 'ttywf': device_add
[    4.311473] PM: Adding info for No Bus:ttywf
[    4.312089] device: 'ttyx0': device_add
[    4.312635] PM: Adding info for No Bus:ttyx0
[    4.313239] device: 'ttyx1': device_add
[    4.313787] PM: Adding info for No Bus:ttyx1
[    4.314396] device: 'ttyx2': device_add
[    4.314952] PM: Adding info for No Bus:ttyx2
[    4.315550] device: 'ttyx3': device_add
[    4.316114] PM: Adding info for No Bus:ttyx3
[    4.316711] device: 'ttyx4': device_add
[    4.317325] PM: Adding info for No Bus:ttyx4
[    4.317928] device: 'ttyx5': device_add
[    4.318488] PM: Adding info for No Bus:ttyx5
[    4.319101] device: 'ttyx6': device_add
[    4.319667] PM: Adding info for No Bus:ttyx6
[    4.320299] device: 'ttyx7': device_add
[    4.320851] PM: Adding info for No Bus:ttyx7
[    4.321461] device: 'ttyx8': device_add
[    4.322018] PM: Adding info for No Bus:ttyx8
[    4.322620] device: 'ttyx9': device_add
[    4.323174] PM: Adding info for No Bus:ttyx9
[    4.323776] device: 'ttyxa': device_add
[    4.324362] PM: Adding info for No Bus:ttyxa
[    4.324972] device: 'ttyxb': device_add
[    4.325521] PM: Adding info for No Bus:ttyxb
[    4.326229] device: 'ttyxc': device_add
[    4.326786] PM: Adding info for No Bus:ttyxc
[    4.327400] device: 'ttyxd': device_add
[    4.327953] PM: Adding info for No Bus:ttyxd
[    4.328591] device: 'ttyxe': device_add
[    4.329150] PM: Adding info for No Bus:ttyxe
[    4.329750] device: 'ttyxf': device_add
[    4.330305] PM: Adding info for No Bus:ttyxf
[    4.330903] device: 'ttyy0': device_add
[    4.331459] PM: Adding info for No Bus:ttyy0
[    4.332079] device: 'ttyy1': device_add
[    4.332631] PM: Adding info for No Bus:ttyy1
[    4.333239] device: 'ttyy2': device_add
[    4.333798] PM: Adding info for No Bus:ttyy2
[    4.334404] device: 'ttyy3': device_add
[    4.334959] PM: Adding info for No Bus:ttyy3
[    4.335561] device: 'ttyy4': device_add
[    4.336131] PM: Adding info for No Bus:ttyy4
[    4.336729] device: 'ttyy5': device_add
[    4.337359] PM: Adding info for No Bus:ttyy5
[    4.338209] device: 'ttyy6': device_add
[    4.338779] PM: Adding info for No Bus:ttyy6
[    4.339393] device: 'ttyy7': device_add
[    4.339954] PM: Adding info for No Bus:ttyy7
[    4.340585] device: 'ttyy8': device_add
[    4.341145] PM: Adding info for No Bus:ttyy8
[    4.341748] device: 'ttyy9': device_add
[    4.342305] PM: Adding info for No Bus:ttyy9
[    4.342909] device: 'ttyya': device_add
[    4.343481] PM: Adding info for No Bus:ttyya
[    4.344109] device: 'ttyyb': device_add
[    4.344663] PM: Adding info for No Bus:ttyyb
[    4.345270] device: 'ttyyc': device_add
[    4.345818] PM: Adding info for No Bus:ttyyc
[    4.346589] device: 'ttyyd': device_add
[    4.347148] PM: Adding info for No Bus:ttyyd
[    4.347760] device: 'ttyye': device_add
[    4.348342] PM: Adding info for No Bus:ttyye
[    4.348944] device: 'ttyyf': device_add
[    4.349493] PM: Adding info for No Bus:ttyyf
[    4.350098] device: 'ttyz0': device_add
[    4.350645] PM: Adding info for No Bus:ttyz0
[    4.351248] device: 'ttyz1': device_add
[    4.351794] PM: Adding info for No Bus:ttyz1
[    4.352415] device: 'ttyz2': device_add
[    4.352986] PM: Adding info for No Bus:ttyz2
[    4.353586] device: 'ttyz3': device_add
[    4.354138] PM: Adding info for No Bus:ttyz3
[    4.354736] device: 'ttyz4': device_add
[    4.355287] PM: Adding info for No Bus:ttyz4
[    4.355886] device: 'ttyz5': device_add
[    4.356539] PM: Adding info for No Bus:ttyz5
[    4.357198] device: 'ttyz6': device_add
[    4.357757] PM: Adding info for No Bus:ttyz6
[    4.358877] device: 'ttyz7': device_add
[    4.359442] PM: Adding info for No Bus:ttyz7
[    4.360145] device: 'ttyz8': device_add
[    4.360700] PM: Adding info for No Bus:ttyz8
[    4.361310] device: 'ttyz9': device_add
[    4.361864] PM: Adding info for No Bus:ttyz9
[    4.362481] device: 'ttyza': device_add
[    4.363060] PM: Adding info for No Bus:ttyza
[    4.369784] device: 'ttyzb': device_add
[    4.370353] PM: Adding info for No Bus:ttyzb
[    4.370962] device: 'ttyzc': device_add
[    4.371806] PM: Adding info for No Bus:ttyzc
[    4.372442] device: 'ttyzd': device_add
[    4.373073] PM: Adding info for No Bus:ttyzd
[    4.376469] device: 'ttyze': device_add
[    4.377049] PM: Adding info for No Bus:ttyze
[    4.377656] device: 'ttyzf': device_add
[    4.378228] PM: Adding info for No Bus:ttyzf
[    4.378834] device: 'ttya0': device_add
[    4.379395] PM: Adding info for No Bus:ttya0
[    4.380003] device: 'ttya1': device_add
[    4.380581] PM: Adding info for No Bus:ttya1
[    4.381190] device: 'ttya2': device_add
[    4.381756] PM: Adding info for No Bus:ttya2
[    4.382370] device: 'ttya3': device_add
[    4.382922] PM: Adding info for No Bus:ttya3
[    4.383530] device: 'ttya4': device_add
[    4.384108] PM: Adding info for No Bus:ttya4
[    4.384708] device: 'ttya5': device_add
[    4.385264] PM: Adding info for No Bus:ttya5
[    4.385866] device: 'ttya6': device_add
[    4.396471] PM: Adding info for No Bus:ttya6
[    4.397085] device: 'ttya7': device_add
[    4.397639] PM: Adding info for No Bus:ttya7
[    4.398251] device: 'ttya8': device_add
[    4.398805] PM: Adding info for No Bus:ttya8
[    4.399417] device: 'ttya9': device_add
[    4.399979] PM: Adding info for No Bus:ttya9
[    4.400614] device: 'ttyaa': device_add
[    4.401190] PM: Adding info for No Bus:ttyaa
[    4.401798] device: 'ttyab': device_add
[    4.402355] PM: Adding info for No Bus:ttyab
[    4.402960] device: 'ttyac': device_add
[    4.403512] PM: Adding info for No Bus:ttyac
[    4.404138] device: 'ttyad': device_add
[    4.404688] PM: Adding info for No Bus:ttyad
[    4.405313] device: 'ttyae': device_add
[    4.405879] PM: Adding info for No Bus:ttyae
[    4.416541] device: 'ttyaf': device_add
[    4.417099] PM: Adding info for No Bus:ttyaf
[    4.417703] device: 'ttyb0': device_add
[    4.418269] PM: Adding info for No Bus:ttyb0
[    4.418876] device: 'ttyb1': device_add
[    4.419437] PM: Adding info for No Bus:ttyb1
[    4.420068] device: 'ttyb2': device_add
[    4.420632] PM: Adding info for No Bus:ttyb2
[    4.421250] device: 'ttyb3': device_add
[    4.421803] PM: Adding info for No Bus:ttyb3
[    4.422414] device: 'ttyb4': device_add
[    4.422971] PM: Adding info for No Bus:ttyb4
[    4.423575] device: 'ttyb5': device_add
[    4.424152] PM: Adding info for No Bus:ttyb5
[    4.424756] device: 'ttyb6': device_add
[    4.425324] PM: Adding info for No Bus:ttyb6
[    4.425928] device: 'ttyb7': device_add
[    4.436529] PM: Adding info for No Bus:ttyb7
[    4.437144] device: 'ttyb8': device_add
[    4.437691] PM: Adding info for No Bus:ttyb8
[    4.438294] device: 'ttyb9': device_add
[    4.438841] PM: Adding info for No Bus:ttyb9
[    4.439452] device: 'ttyba': device_add
[    4.440041] PM: Adding info for No Bus:ttyba
[    4.440644] device: 'ttybb': device_add
[    4.441205] PM: Adding info for No Bus:ttybb
[    4.441809] device: 'ttybc': device_add
[    4.442370] PM: Adding info for No Bus:ttybc
[    4.442977] device: 'ttybd': device_add
[    4.443527] PM: Adding info for No Bus:ttybd
[    4.444174] device: 'ttybe': device_add
[    4.444734] PM: Adding info for No Bus:ttybe
[    4.445343] device: 'ttybf': device_add
[    4.445893] PM: Adding info for No Bus:ttybf
[    4.456582] device: 'ttyc0': device_add
[    4.457147] PM: Adding info for No Bus:ttyc0
[    4.457751] device: 'ttyc1': device_add
[    4.458307] PM: Adding info for No Bus:ttyc1
[    4.458906] device: 'ttyc2': device_add
[    4.459466] PM: Adding info for No Bus:ttyc2
[    4.460088] device: 'ttyc3': device_add
[    4.460636] PM: Adding info for No Bus:ttyc3
[    4.461241] device: 'ttyc4': device_add
[    4.461802] PM: Adding info for No Bus:ttyc4
[    4.462409] device: 'ttyc5': device_add
[    4.462963] PM: Adding info for No Bus:ttyc5
[    4.463569] device: 'ttyc6': device_add
[    4.464141] PM: Adding info for No Bus:ttyc6
[    4.464737] device: 'ttyc7': device_add
[    4.465289] PM: Adding info for No Bus:ttyc7
[    4.465888] device: 'ttyc8': device_add
[    4.476536] PM: Adding info for No Bus:ttyc8
[    4.477158] device: 'ttyc9': device_add
[    4.477714] PM: Adding info for No Bus:ttyc9
[    4.478322] device: 'ttyca': device_add
[    4.478892] PM: Adding info for No Bus:ttyca
[    4.479500] device: 'ttycb': device_add
[    4.480067] PM: Adding info for No Bus:ttycb
[    4.480665] device: 'ttycc': device_add
[    4.481215] PM: Adding info for No Bus:ttycc
[    4.481812] device: 'ttycd': device_add
[    4.482364] PM: Adding info for No Bus:ttycd
[    4.482979] device: 'ttyce': device_add
[    4.483531] PM: Adding info for No Bus:ttyce
[    4.484148] device: 'ttycf': device_add
[    4.484692] PM: Adding info for No Bus:ttycf
[    4.485295] device: 'ttyd0': device_add
[    4.485840] PM: Adding info for No Bus:ttyd0
[    4.496517] device: 'ttyd1': device_add
[    4.497086] PM: Adding info for No Bus:ttyd1
[    4.497697] device: 'ttyd2': device_add
[    4.498281] PM: Adding info for No Bus:ttyd2
[    4.498884] device: 'ttyd3': device_add
[    4.499436] PM: Adding info for No Bus:ttyd3
[    4.500060] device: 'ttyd4': device_add
[    4.500608] PM: Adding info for No Bus:ttyd4
[    4.501216] device: 'ttyd5': device_add
[    4.501762] PM: Adding info for No Bus:ttyd5
[    4.502379] device: 'ttyd6': device_add
[    4.502934] PM: Adding info for No Bus:ttyd6
[    4.503534] device: 'ttyd7': device_add
[    4.504100] PM: Adding info for No Bus:ttyd7
[    4.504699] device: 'ttyd8': device_add
[    4.505253] PM: Adding info for No Bus:ttyd8
[    4.505855] device: 'ttyd9': device_add
[    4.516485] PM: Adding info for No Bus:ttyd9
[    4.517100] device: 'ttyda': device_add
[    4.517671] PM: Adding info for No Bus:ttyda
[    4.518291] device: 'ttydb': device_add
[    4.518853] PM: Adding info for No Bus:ttydb
[    4.519471] device: 'ttydc': device_add
[    4.520057] PM: Adding info for No Bus:ttydc
[    4.520664] device: 'ttydd': device_add
[    4.521226] PM: Adding info for No Bus:ttydd
[    4.521846] device: 'ttyde': device_add
[    4.522409] PM: Adding info for No Bus:ttyde
[    4.523019] device: 'ttydf': device_add
[    4.523571] PM: Adding info for No Bus:ttydf
[    4.524196] device: 'ttye0': device_add
[    4.524743] PM: Adding info for No Bus:ttye0
[    4.525347] device: 'ttye1': device_add
[    4.525894] PM: Adding info for No Bus:ttye1
[    4.534566] device: 'ttye2': device_add
[    4.535144] PM: Adding info for No Bus:ttye2
[    4.535748] device: 'ttye3': device_add
[    4.536327] PM: Adding info for No Bus:ttye3
[    4.536935] device: 'ttye4': device_add
[    4.537492] PM: Adding info for No Bus:ttye4
[    4.538098] device: 'ttye5': device_add
[    4.538648] PM: Adding info for No Bus:ttye5
[    4.539256] device: 'ttye6': device_add
[    4.539820] PM: Adding info for No Bus:ttye6
[    4.540456] device: 'ttye7': device_add
[    4.541020] PM: Adding info for No Bus:ttye7
[    4.541625] device: 'ttye8': device_add
[    4.542189] PM: Adding info for No Bus:ttye8
[    4.542790] device: 'ttye9': device_add
[    4.543349] PM: Adding info for No Bus:ttye9
[    4.553994] device: 'ttyea': device_add
[    4.554563] PM: Adding info for No Bus:ttyea
[    4.555176] device: 'ttyeb': device_add
[    4.555747] PM: Adding info for No Bus:ttyeb
[    4.556386] device: 'ttyec': device_add
[    4.556938] PM: Adding info for No Bus:ttyec
[    4.557552] device: 'ttyed': device_add
[    4.558113] PM: Adding info for No Bus:ttyed
[    4.558732] device: 'ttyee': device_add
[    4.559298] PM: Adding info for No Bus:ttyee
[    4.559904] device: 'ttyef': device_add
[    4.560486] PM: Adding info for No Bus:ttyef
[    4.561108] HDLC line discipline maxframe=4096
[    4.561729] N_HDLC line discipline registered.
[    4.562356] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.563249] bus: 'pnp': add driver serial
[    4.563861] bus: 'pnp': driver_probe_device: matched device 00:05 with driver serial
[    4.574984] bus: 'pnp': really_probe: probing driver serial with device 00:05
[    4.631236] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.632077] device: 'ttyS0': device_add
[    4.632672] PM: Adding info for No Bus:ttyS0
[    4.633296] driver: '00:05': driver_bound: bound to device 'serial'
[    4.634169] bus: 'pnp': really_probe: bound device 00:05 to driver serial
[    4.635132] Registering platform device 'serial8250'. Parent at platform
[    4.636080] device: 'serial8250': device_add
[    4.636679] bus: 'platform': add device serial8250
[    4.637365] PM: Adding info for platform:serial8250
[    4.638091] device: 'ttyS1': device_add
[    4.638648] PM: Adding info for No Bus:ttyS1
[    4.639299] device: 'ttyS2': device_add
[    4.639855] PM: Adding info for No Bus:ttyS2
[    4.640514] device: 'ttyS3': device_add
[    4.650151] PM: Adding info for No Bus:ttyS3
[    4.650762] bus: 'platform': add driver serial8250
[    4.651442] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[    4.652700] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[    4.653852] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[    4.654828] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[    4.655946] bus: 'pci': add driver serial
[    4.656578] bus: 'pcmcia': add driver serial_cs
[    4.657219] bus: 'spi': add driver max310x
[    4.657798] bus: 'platform': add driver timb-uart
[    4.658466] bus: 'platform': add driver arc-uart
[    4.659135] device: 'ttyprintk': device_add
[    4.659744] PM: Adding info for No Bus:ttyprintk
[    4.670473] device class 'virtio-ports': registering
[    4.671184] bus: 'virtio': add driver virtio_console
[    4.671883] bus: 'virtio': add driver virtio_rproc_serial
[    4.672675] device class 'raw': registering
[    4.673272] device: 'rawctl': device_add
[    4.673835] PM: Adding info for No Bus:rawctl
[    4.674457] device class 'printer': registering
[    4.675094] lp: driver loaded but no devices found
[    4.675757] device: 'nvram': device_add
[    4.676328] PM: Adding info for No Bus:nvram
[    4.676930] Non-volatile memory driver v1.3
[    4.677525] toshiba: not a supported Toshiba laptop
[    4.678210] device class 'ppdev': registering
[    4.678824] ppdev: user-space parallel port driver
[    4.679497] Registering platform device 'pc8736x_gpio.0'. Parent at platform
[    4.690533] device: 'pc8736x_gpio.0': device_add
[    4.691192] bus: 'platform': add device pc8736x_gpio.0
[    4.691933] PM: Adding info for platform:pc8736x_gpio.0
[    4.692939] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
[    4.693733] platform pc8736x_gpio.0: no device found
[    4.694439] bus: 'platform': remove device pc8736x_gpio.0
[    4.695195] PM: Removing info for platform:pc8736x_gpio.0
[    4.695957] nsc_gpio initializing
[    4.696469] smapi::smapi_init, ERROR invalid usSmapiID
[    4.697182] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[    4.698458] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[    4.699447] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    4.710382] device class 'cardman_4040': registering
[    4.711096] bus: 'pcmcia': add driver cm4040_cs
[    4.711736] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    4.712998] Hangcheck: Using getrawmonotonic().
[    4.713630] bus: 'pnp': add driver tpm_tis
[    4.714257] bus: 'platform': add driver parport_pc
[    4.714947] bus: 'pnp': add driver parport_pc
[    4.715563] bus: 'pnp': driver_probe_device: matched device 00:04 with driver parport_pc
[    4.716698] bus: 'pnp': really_probe: probing driver parport_pc with device 00:04
[    4.717738] parport_pc 00:04: reported by Plug and Play ACPI
[    4.718587] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[    4.719537] device: 'parport0': device_add
[    4.730184] PM: Adding info for No Bus:parport0
[    4.730824] device: 'lp0': device_add
[    4.731357] PM: Adding info for No Bus:lp0
[    4.731934] lp0: using parport0 (interrupt-driven).
[    4.732637] lp0: console ready
[    4.733081] driver: '00:04': driver_bound: bound to device 'parport_pc'
[    4.733994] bus: 'pnp': really_probe: bound device 00:04 to driver parport_pc
[    4.734983] Registering platform device 'parport_pc.956'. Parent at platform
[    4.735967] device: 'parport_pc.956': device_add
[    4.736629] bus: 'platform': add device parport_pc.956
[    4.737361] PM: Adding info for platform:parport_pc.956
[    4.738100] bus: 'platform': driver_probe_device: matched device parport_pc.956 with driver parport_pc
[    4.739375] bus: 'platform': really_probe: probing driver parport_pc with device parport_pc.956
[    4.750642] driver: 'parport_pc.956': driver_bound: bound to device 'parport_pc'
[    4.751669] bus: 'platform': really_probe: bound device parport_pc.956 to driver parport_pc
[    4.752934] bus: 'platform': remove device parport_pc.956
[    4.753690] PM: Removing info for platform:parport_pc.956
[    4.754457] Registering platform device 'parport_pc.888'. Parent at platform
[    4.755438] device: 'parport_pc.888': device_add
[    4.756107] bus: 'platform': add device parport_pc.888
[    4.756829] PM: Adding info for platform:parport_pc.888
[    4.757564] bus: 'platform': driver_probe_device: matched device parport_pc.888 with driver parport_pc
[    4.758848] bus: 'platform': really_probe: probing driver parport_pc with device parport_pc.888
[    4.760068] driver: 'parport_pc.888': driver_bound: bound to device 'parport_pc'
[    4.761084] bus: 'platform': really_probe: bound device parport_pc.888 to driver parport_pc
[    4.762248] bus: 'platform': remove device parport_pc.888
[    4.763005] PM: Removing info for platform:parport_pc.888
[    4.763760] Registering platform device 'parport_pc.632'. Parent at platform
[    4.764752] device: 'parport_pc.632': device_add
[    4.765398] bus: 'platform': add device parport_pc.632
[    4.766118] PM: Adding info for platform:parport_pc.632
[    4.766845] bus: 'platform': driver_probe_device: matched device parport_pc.632 with driver parport_pc
[    4.768134] bus: 'platform': really_probe: probing driver parport_pc with device parport_pc.632
[    4.769323] driver: 'parport_pc.632': driver_bound: bound to device 'parport_pc'
[    4.770342] bus: 'platform': really_probe: bound device parport_pc.632 to driver parport_pc
[    4.771565] bus: 'platform': remove device parport_pc.632
[    4.772329] PM: Removing info for platform:parport_pc.632
[    4.773088] bus: 'pci': add driver parport_pc
[    4.773711] bus: 'pcmcia': add driver parport_cs
[    4.774378] bus: 'spi': add driver ad_dpot
[    4.774960] bus: 'platform': add driver ssc
[    4.775563] bus: 'spi': add driver dac7512
[    4.776174] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    4.777172] device class 'c2port': registering
[    4.777810] device: 'c2port0': device_add
[    4.778393] PM: Adding info for No Bus:c2port0
[    4.779039] c2port c2port0: C2 port uc added
[    4.779636] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
[    4.780702] bus: 'spi': add driver at25
[    4.781301] bus: 'spi': add driver 93xx46
[    4.781877] bus: 'platform': add driver kim
[    4.782470] bus: 'spi': add driver lattice-ecp3
[    4.783107] bus: 'platform': add driver sm501
[    4.783718] bus: 'pci': add driver sm501
[    4.784296] bus: 'platform': add driver pasic3
[    4.784916] bus: 'platform': remove driver pasic3
[    4.785578] driver: 'pasic3': driver_release
[    4.786178] bus: 'spi': add driver arizona
[    4.786755] bus: 'usb': add driver viperboard
[    4.787370] usbcore: registered new interface driver viperboard
[    4.788407] device: 'tgt': device_add
[    4.788933] PM: Adding info for No Bus:tgt
[    4.789512] device class 'raid_devices': registering
[    4.790218] device class 'spi_transport': registering
[    4.790924] device class 'spi_host': registering
[    4.791610] device class 'fc_host': registering
[    4.792269] device class 'fc_vports': registering
[    4.792931] device class 'fc_remote_ports': registering
[    4.793662] device class 'fc_transport': registering
[    4.794377] device class 'sas_host': registering
[    4.795028] device class 'sas_phy': registering
[    4.795660] device class 'sas_port': registering
[    4.796326] device class 'sas_device': registering
[    4.796994] device class 'sas_end_device': registering
[    4.797706] device class 'sas_expander': registering
[    4.798404] device class 'srp_host': registering
[    4.799052] device class 'srp_remote_ports': registering
[    4.799825] bus: 'virtio': add driver virtio_scsi
[    4.800508] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    4.802315] device class 'scsi_tape': registering
[    4.802988] bus: 'scsi': add driver st
[    4.803518] device class 'scsi_generic': registering
[    4.804232] SCSI Media Changer driver v0.25 
[    4.804833] device class 'scsi_changer': registering
[    4.805529] bus: 'scsi': add driver ch
[    4.806064] device class 'scsi_osd': registering
[    4.806709] bus: 'scsi': add driver osd
[    4.807253] osd: LOADED open-osd 0.2.1
[    4.812374] device: 'pseudo_0': device_add
[    4.813144] PM: Adding info for No Bus:pseudo_0
[    4.824288] bus: 'pseudo': registered
[    4.824809] bus: 'pseudo': add driver scsi_debug
[    4.825501] device: 'adapter0': device_add
[    4.826092] bus: 'pseudo': add device adapter0
[    4.826729] PM: Adding info for pseudo:adapter0
[    4.827380] bus: 'pseudo': driver_probe_device: matched device adapter0 with driver scsi_debug
[    4.828607] bus: 'pseudo': really_probe: probing driver scsi_debug with device adapter0
[    4.830059] scsi_debug: host protection
[    4.830418] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=8, opts=0x0
[    4.831454] device: 'host0': device_add
[    4.832022] bus: 'scsi': add device host0
[    4.832591] PM: Adding info for scsi:host0
[    4.833180] device: 'host0': device_add
[    4.833742] PM: Adding info for No Bus:host0
[    4.834484] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       0004 PQ: 0 ANSI: 5
[    4.835610] device: 'target0:0:0': device_add
[    4.836244] bus: 'scsi': add device target0:0:0
[    4.836879] PM: Adding info for scsi:target0:0:0
[    4.837539] device: '0:0:0:0': device_add
[    4.838122] bus: 'scsi': add device 0:0:0:0
[    4.838716] PM: Adding info for scsi:0:0:0:0
[    4.839329] bus: 'scsi': driver_probe_device: matched device 0:0:0:0 with driver st
[    4.840422] bus: 'scsi': really_probe: probing driver st with device 0:0:0:0
[    4.841521] st: probe of 0:0:0:0 rejects match -19
[    4.842200] bus: 'scsi': driver_probe_device: matched device 0:0:0:0 with driver ch
[    4.843266] bus: 'scsi': really_probe: probing driver ch with device 0:0:0:0
[    4.844278] ch: probe of 0:0:0:0 rejects match -19
[    4.844959] bus: 'scsi': driver_probe_device: matched device 0:0:0:0 with driver osd
[    4.846033] bus: 'scsi': really_probe: probing driver osd with device 0:0:0:0
[    4.847022] osd: probe of 0:0:0:0 rejects match -19
[    4.847707] device: '0:0:0:0': device_add
[    4.848323] PM: Adding info for No Bus:0:0:0:0
[    4.848983] device: 'sg0': device_add
[    4.849520] PM: Adding info for No Bus:sg0
[    4.850114] scsi 0:0:0:0: Attached scsi generic sg0 type 0
[    4.850885] device: '0:0:0:0': device_add
[    4.851470] PM: Adding info for No Bus:0:0:0:0
[    4.852163] driver: 'adapter0': driver_bound: bound to device 'scsi_debug'
[    4.853124] bus: 'pseudo': really_probe: bound device adapter0 to driver scsi_debug
[    4.854194] bus: 'platform': add driver ahci
[    4.854808] device class 'mtd': registering
[    4.855428] device: 'mtd-unmap': device_add
[    4.856064] PM: Adding info for No Bus:mtd-unmap
[    4.856760] device: 'mtd-romap': device_add
[    4.857368] PM: Adding info for No Bus:mtd-romap
[    4.858048] device: 'mtd-rwmap': device_add
[    4.858649] PM: Adding info for No Bus:mtd-rwmap
[    4.859344] mtdoops: mtd device (mtddev=name/number) must be supplied
[    4.860269] L440GX flash mapping: failed to find PIIX4 ISA bridge, cannot continue
[    4.861340] bus: 'pcmcia': add driver pcmciamtd
[    4.861993] NetSc520 flash device: 0x100000 at 0x200000
[    4.862723] Failed to ioremap_nocache
[    4.863247] Failed to ioremap_nocache
[    4.863761] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    4.864643] bus: 'platform': add driver mtd-ram
[    4.865299] bus: 'platform': add driver gpio-addr-flash
[    4.866046] bus: 'platform': add driver latch-addr-flash
[    4.866797] bus: 'platform': add driver docg3
[    4.867424] bus: 'platform': remove driver docg3
[    4.868097] driver: 'docg3': driver_release
[    4.868692] slram: not enough parameters.
[    4.869990] device: 'mtd0': device_add
[    4.870548] PM: Adding info for No Bus:mtd0
[    4.871150] device: 'mtd0ro': device_add
[    4.871717] PM: Adding info for No Bus:mtd0ro
[    4.872428] ftl_cs: FTL header not found.
[    4.873047] device: '31:0': device_add
[    4.873592] PM: Adding info for No Bus:31:0
[    4.874200] device: 'mtdblock0': device_add
[    4.874803] PM: Adding info for No Bus:mtdblock0
[    4.877254] bus: 'spi': add driver mtd_dataflash
[    4.877974] bus: 'spi': add driver sst25l
[    4.878553] bus: 'platform': add driver onenand-flash
[    4.912034] onenand_wait: timeout! ctrl=0x0000 intr=0x0000
[    4.912831] OneNAND Manufacturer: Samsung (0xec)
[    4.913487] OneNAND 16MB 1.8V 16-bit (0x04)
[    4.914089] OneNAND version = 0x001e
[    4.914592] Lock scheme is Continuous Lock
[    4.915183] Scanning device for bad blocks
[    4.916044] Creating 1 MTD partitions on "OneNAND simulator":
[    4.916840] 0x000000000000-0x000001000000 : "OneNAND simulator partition"
[    4.917834] device: 'mtd1': device_add
[    4.918394] PM: Adding info for No Bus:mtd1
[    4.918993] device: 'mtd1ro': device_add
[    4.919574] PM: Adding info for No Bus:mtd1ro
[    4.920228] ftl_cs: FTL header not found.
[    4.920829] device: '31:1': device_add
[    4.921376] PM: Adding info for No Bus:31:1
[    4.921986] device: 'mtdblock1': device_add
[    4.922593] PM: Adding info for No Bus:mtdblock1
[    4.923299] parport0: cannot grant exclusive access for device spi-lm70llp
[    4.924282] spi-lm70llp: spi_lm70llp probe fail, status -12
[    4.925059] bus: 'hsi': add driver hsi_char
[    4.925647] HSI/SSI char device loaded
[    4.926180] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
[    4.927428] device: 'eql': device_add
[    4.928007] PM: Adding info for No Bus:eql
[    4.928872] bus: 'mdio_bus': add driver Davicom DM9161E
[    4.929605] bus: 'mdio_bus': add driver Davicom DM9161A
[    4.930337] bus: 'mdio_bus': add driver Davicom DM9131
[    4.931061] bus: 'mdio_bus': add driver LXT970
[    4.931684] bus: 'mdio_bus': add driver LXT971
[    4.932349] bus: 'mdio_bus': add driver LXT973-A2
[    4.933022] bus: 'mdio_bus': add driver LXT973
[    4.933652] bus: 'mdio_bus': add driver Vitesse VSC8244
[    4.934398] bus: 'mdio_bus': add driver Vitesse VSC8221
[    4.935145] bus: 'mdio_bus': add driver Broadcom BCM5411
[    4.935886] bus: 'mdio_bus': add driver Broadcom BCM5421
[    4.936661] bus: 'mdio_bus': add driver Broadcom BCM5461
[    4.937497] bus: 'mdio_bus': add driver Broadcom BCM5464
[    4.938243] bus: 'mdio_bus': add driver Broadcom BCM5481
[    4.938989] bus: 'mdio_bus': add driver Broadcom BCM5482
[    4.939727] bus: 'mdio_bus': add driver Broadcom BCM50610
[    4.940511] bus: 'mdio_bus': add driver Broadcom BCM50610M
[    4.941279] bus: 'mdio_bus': add driver Broadcom BCM57780
[    4.942035] bus: 'mdio_bus': add driver Broadcom BCMAC131
[    4.942787] bus: 'mdio_bus': add driver Broadcom BCM5241
[    4.943535] bus: 'mdio_bus': add driver Broadcom BCM8706
[    4.944301] bus: 'mdio_bus': add driver Broadcom BCM8727
[    4.945046] bus: 'mdio_bus': add driver ICPlus IP175C
[    4.945760] bus: 'mdio_bus': add driver ICPlus IP1001
[    4.946468] bus: 'mdio_bus': add driver ICPlus IP101A/G
[    4.947199] bus: 'mdio_bus': add driver RTL8211B Gigabit Ethernet
[    4.948070] bus: 'mdio_bus': add driver RTL8211E Gigabit Ethernet
[    4.948922] spi_ks8995: Micrel KS8995 Ethernet switch SPI driver version 0.1.1
[    4.949930] bus: 'spi': add driver spi-ks8995
[    4.950574] bus: 'virtio': add driver virtio_net
[    4.951228] arcnet loaded.
[    4.951612] arcnet: RFC1201 "standard" (`a') encapsulation support loaded.
[    4.952581] arcnet: RFC1051 "simple standard" (`s') encapsulation support loaded.
[    4.953620] arcnet: RIM I (entirely mem-mapped) support
[    4.954343] E-mail me if you actually test the RIM I driver, please!
[    4.955214] Given: node 00h, shmem 0h, irq 0
[    4.955802] No autoprobe for RIM I; you must specify the shmem and irq!
[    4.956728] vcan: Virtual CAN interface driver
[    4.957347] slcan: serial line CAN interface driver
[    4.958023] slcan: 10 dynamic interface channels.
[    4.958674] CAN device driver interface
[    4.959214] bus: 'usb': add driver ems_usb
[    4.959792] usbcore: registered new interface driver ems_usb
[    4.960609] bus: 'usb': add driver peak_usb
[    4.961215] usbcore: registered new interface driver peak_usb
[    4.962026] bus: 'platform': add driver softing
[    4.962684] bus: 'spi': add driver mcp251x
[    4.963288] bus: 'pcmcia': add driver 3c589_cs
[    4.963918] bus: 'pcmcia': add driver nmclan_cs
[    4.964596] bus: 'platform': add driver at91_ether
[    4.965281] bus: 'platform': remove driver at91_ether
[    4.965994] driver: 'at91_ether': driver_release
[    4.966639] bus: 'platform': add driver macb
[    4.967248] bus: 'platform': remove driver macb
[    4.967886] driver: 'macb': driver_release
[    4.968491] bus: 'platform': add driver dnet
[    4.969103] bus: 'spi': add driver ks8851
[    4.969672] bus: 'spi': add driver enc28j60
[    4.970270] bus: 'platform': add driver stmmaceth
[    4.970934] bus: 'platform': add driver w5100
[    4.971557] bus: 'platform': add driver w5300
[    4.972223] bus: 'pcmcia': add driver xirc2ps_cs
[    4.972875] bus: 'platform': add driver ali-ircc
[    4.973689] bus: 'platform': remove driver ali-ircc
[    4.974380] driver: 'ali-ircc': driver_release
[    4.975010] bus: 'usb': add driver mcs7780
[    4.975599] usbcore: registered new interface driver mcs7780
[    4.976413] bus: 'usb': add driver kingsun-sir
[    4.977050] usbcore: registered new interface driver kingsun-sir
[    4.977881] bus: 'usb': add driver ksdazzle-sir
[    4.978520] usbcore: registered new interface driver ksdazzle-sir
[    4.979372] hdlc: HDLC support module revision 1.22
[    4.980077] x25_asy: X.25 async: version 0.00 ALPHA (dynamic channels, max=256)
[    4.981085] DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
[    4.981941] Atmel at76x USB Wireless LAN Driver 0.17 loading
[    4.982734] bus: 'usb': add driver at76c50x-usb
[    4.983391] usbcore: registered new interface driver at76c50x-usb
[    4.984277] bus: 'pcmcia': add driver b43-pcmcia
[    4.984930] bus: 'bcma': add driver b43
[    4.985480] bus: 'ssb': add driver b43
[    4.986023] Broadcom 43xx driver loaded [ Features: PMNL ]
[    4.986783] bus: 'ssb': add driver b43legacy
[    4.987396] Broadcom 43xx-legacy driver loaded [ Features: PLI ]
[    4.988257] zd1211rw usb_init()
[    4.998086] bus: 'usb': add driver zd1211rw
[    4.998708] usbcore: registered new interface driver zd1211rw
[    4.999511] zd1211rw initialized
[    4.999977] bus: 'usb': add driver rtl8187
[    5.000620] usbcore: registered new interface driver rtl8187
[    5.001419] bus: 'pcmcia': add driver ray_cs
[    5.002045] bus: 'pcmcia': add driver wl3501_cs
[    5.002687] bus: 'usb': add driver rndis_wlan
[    5.003309] usbcore: registered new interface driver rndis_wlan
[    5.004149] bus: 'usb': add driver zd1201
[    5.004710] usbcore: registered new interface driver zd1201
[    5.014978] bus: 'usb': add driver rt2500usb
[    5.015595] usbcore: registered new interface driver rt2500usb
[    5.016434] bus: 'usb': add driver rt73usb
[    5.017033] usbcore: registered new interface driver rt73usb
[    5.017821] bus: 'usb': add driver rt2800usb
[    5.018443] usbcore: registered new interface driver rt2800usb
[    5.019258] bus: 'spi': add driver wl1271_spi
[    5.019894] bus: 'sdio': add driver brcmfmac
[    5.020541] bus: 'usb': add driver i2400m_usb
[    5.021165] usbcore: registered new interface driver i2400m_usb
[    5.021990] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[    5.023027] bus: 'usb': add driver pegasus
[    5.023605] usbcore: registered new interface driver pegasus
[    5.024413] bus: 'usb': add driver asix
[    5.025011] usbcore: registered new interface driver asix
[    5.025754] bus: 'usb': add driver ax88179_178a
[    5.026390] usbcore: registered new interface driver ax88179_178a
[    5.027230] bus: 'usb': add driver cdc_ether
[    5.027826] usbcore: registered new interface driver cdc_ether
[    5.028653] bus: 'usb': add driver dm9601
[    5.029225] usbcore: registered new interface driver dm9601
[    5.030002] bus: 'usb': add driver smsc75xx
[    5.030592] usbcore: registered new interface driver smsc75xx
[    5.031387] bus: 'usb': add driver gl620a
[    5.031972] usbcore: registered new interface driver gl620a
[    5.032764] bus: 'usb': add driver net1080
[    5.033349] usbcore: registered new interface driver net1080
[    5.034144] bus: 'usb': add driver rndis_host
[    5.034760] usbcore: registered new interface driver rndis_host
[    5.035588] bus: 'usb': add driver cdc_subset
[    5.036237] usbcore: registered new interface driver cdc_subset
[    5.037069] bus: 'usb': add driver int51x1
[    5.037651] usbcore: registered new interface driver int51x1
[    5.038472] bus: 'usb': add driver cdc_phonet
[    5.039093] usbcore: registered new interface driver cdc_phonet
[    5.039917] bus: 'usb': add driver cdc_ncm
[    5.040551] usbcore: registered new interface driver cdc_ncm
[    5.041339] bus: 'usb': add driver lg-vl600
[    5.041929] usbcore: registered new interface driver lg-vl600
[    5.042733] bus: 'usb': add driver qmi_wwan
[    5.043331] usbcore: registered new interface driver qmi_wwan
[    5.044153] bus: 'usb': add driver cdc_mbim
[    5.044746] usbcore: registered new interface driver cdc_mbim
[    5.045557] bus: 'platform': add driver gpio-vbus
[    5.046229] bus: 'platform': remove driver gpio-vbus
[    5.046926] driver: 'gpio-vbus': driver_release
[    5.047573] bus: 'platform': add driver isp1362-hcd
[    5.048281] bus: 'platform': add driver sl811-hcd
[    5.048965] bus: 'pcmcia': add driver sl811_cs
[    5.049608] bus: 'platform': add driver r8a66597_hcd
[    5.050371] bus: 'platform': add driver isp1760
[    5.051013] bus: 'pci': add driver isp1760
[    5.051600] bus: 'bcma': add driver bcma_hcd
[    5.052219] bus: 'platform': add driver c67x00
[    5.052846] bus: 'usb': add driver cdc_acm
[    5.053430] usbcore: registered new interface driver cdc_acm
[    5.054217] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[    5.055316] bus: 'usb': add driver cdc_wdm
[    5.055897] usbcore: registered new interface driver cdc_wdm
[    5.056713] bus: 'usb': add driver microtekX6
[    5.057337] usbcore: registered new interface driver microtekX6
[    5.068096] bus: 'usb': add driver appledisplay
[    5.068757] usbcore: registered new interface driver appledisplay
[    5.069601] bus: 'usb': add driver cytherm
[    5.070180] usbcore: registered new interface driver cytherm
[    5.070964] bus: 'usb': add driver emi62 - firmware loader
[    5.071727] usbcore: registered new interface driver emi62 - firmware loader
[    5.072718] bus: 'usb': add driver isight_firmware
[    5.073406] usbcore: registered new interface driver isight_firmware
[    5.074287] bus: 'usb': add driver usblcd
[    5.074850] usbcore: registered new interface driver usblcd
[    5.075638] bus: 'usb': add driver ldusb
[    5.076231] usbcore: registered new interface driver ldusb
[    5.077003] bus: 'usb': add driver rio500
[    5.077591] usbcore: registered new interface driver rio500
[    5.078417] bus: 'usb': add driver trancevibrator
[    5.079088] usbcore: registered new interface driver trancevibrator
[    5.079961] bus: 'usb': add driver uss720
[    5.080557] usbcore: registered new interface driver uss720
[    5.081355] uss720: v0.6:USB Parport Cable driver for Cables using the Lucent Technologies USS720 Chip
[    5.082634] uss720: NOTE: this is a special purpose driver to allow nonstandard
[    5.083647] uss720: protocols (eg. bitbang) over USS720 usb to parallel cables
[    5.084674] uss720: If you just want to connect to a printer, use usblp instead
[    5.085693] bus: 'platform': add driver omap-usb3
[    5.086370] bus: 'usb': add driver speedtch
[    5.086966] usbcore: registered new interface driver speedtch
[    5.087762] bus: 'platform': add driver ci_hdrc
[    5.088422] bus: 'platform': add driver msm_hsusb
[    5.089086] bus: 'pci': add driver ci13xxx_pci
[    5.089730] bus: 'pnp': add driver i8042 kbd
[    5.090336] bus: 'pnp': driver_probe_device: matched device 00:01 with driver i8042 kbd
[    5.091438] bus: 'pnp': really_probe: probing driver i8042 kbd with device 00:01
[    5.092476] driver: '00:01': driver_bound: bound to device 'i8042 kbd'
[    5.093374] bus: 'pnp': really_probe: bound device 00:01 to driver i8042 kbd
[    5.094356] bus: 'pnp': add driver i8042 aux
[    5.094960] bus: 'pnp': driver_probe_device: matched device 00:02 with driver i8042 aux
[    5.096085] bus: 'pnp': really_probe: probing driver i8042 aux with device 00:02
[    5.097132] driver: '00:02': driver_bound: bound to device 'i8042 aux'
[    5.098049] bus: 'pnp': really_probe: bound device 00:02 to driver i8042 aux
[    5.099053] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    5.100263] Registering platform device 'i8042'. Parent at platform
[    5.101137] device: 'i8042': device_add
[    5.101683] bus: 'platform': add device i8042
[    5.102313] PM: Adding info for platform:i8042
[    5.102967] bus: 'platform': add driver i8042
[    5.103585] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[    5.104732] bus: 'platform': really_probe: probing driver i8042 with device i8042
[    5.110225] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.110225] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.110225] device: 'serio0': device_add
[    5.110225] bus: 'serio': add device serio0
[    5.110225] PM: Adding info for serio:serio0
[    5.110225] driver: 'i8042': driver_bound: bound to device 'i8042'
[    5.120400] device: 'serio1': device_add
[    5.120981] bus: 'serio': add device serio1
[    5.121578] PM: Adding info for serio:serio1
[    5.122194] bus: 'platform': really_probe: bound device i8042 to driver i8042
[    5.123223] bus: 'serio': add driver serio_raw
[    5.123857] bus: 'platform': add driver arc_ps2
[    5.124545] device: 'mice': device_add
[    5.125147] PM: Adding info for No Bus:mice
[    5.125738] device: 'psaux': device_add
[    5.126294] PM: Adding info for No Bus:psaux
[    5.126893] mousedev: PS/2 mouse device common for all mice
[    5.127687] evbug: Connected device: input0 (Power Button at LNXPWRBN/button/input0)
[    5.128805] bus: 'serio': add driver atkbd
[    5.129419] bus: 'platform': add driver matrix-keypad
[    5.130135] bus: 'serio': add driver newtonkbd
[    5.130766] bus: 'serio': add driver stowaway
[    5.131391] bus: 'usb': add driver usb_acecad
[    5.132062] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[    5.133152] bus: 'serio': really_probe: probing driver atkbd with device serio0
[    5.134464] device: 'input1': device_add
[    5.135050] PM: Adding info for No Bus:input1
[    5.135671] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    5.136906] evbug: Connected device: input1 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
[    5.138153] driver: 'serio0': driver_bound: bound to device 'atkbd'
[    5.139021] bus: 'serio': really_probe: bound device serio0 to driver atkbd
[    5.139985] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[    5.141122] bus: 'serio': really_probe: probing driver atkbd with device serio1
[    5.142146] usbcore: registered new interface driver usb_acecad
[    5.142978] bus: 'usb': add driver wacom
[    5.143535] usbcore: registered new interface driver wacom
[    5.144328] bus: 'usb': add driver ati_remote2
[    5.144962] usbcore: registered new interface driver ati_remote2
[    5.145799] cm109: Keymap for Komunikate KIP1000 phone loaded
[    5.146606] bus: 'usb': add driver cm109
[    5.147174] usbcore: registered new interface driver cm109
[    5.147938] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    5.148921] bus: 'platform': add driver da9052-onkey
[    5.149796] atkbd: probe of serio1 rejects match -19
[    5.150518] bus: 'platform': add driver gpio-tilt-polled
[    5.151277] bus: 'usb': add driver keyspan_remote
[    5.151948] usbcore: registered new interface driver keyspan_remote
[    5.152865] wistron_btns: System unknown
[    5.153427] bus: 'usb': add driver yealink
[    5.154017] usbcore: registered new interface driver yealink
[    5.154804] bus: 'platform': add driver rtc-bq4802
[    5.155487] bus: 'platform': add driver da9052-rtc
[    5.156192] bus: 'platform': add driver rtc-ds1286
[    5.156866] bus: 'spi': add driver rtc-ds1305
[    5.157501] bus: 'spi': add driver rtc-ds1390
[    5.158123] bus: 'platform': add driver ds1511
[    5.158751] bus: 'platform': add driver rtc-ds1553
[    5.159433] bus: 'platform': add driver ds2404
[    5.160086] bus: 'spi': add driver ds3234
[    5.160648] bus: 'spi': add driver rtc-m41t93
[    5.161266] bus: 'spi': add driver rtc-m41t94
[    5.161878] bus: 'platform': add driver rtc-m48t35
[    5.162554] bus: 'spi': add driver rtc-max6902
[    5.163183] bus: 'platform': add driver rtc-msm6242
[    5.163866] bus: 'platform': remove driver rtc-msm6242
[    5.164602] driver: 'rtc-msm6242': driver_release
[    5.165257] bus: 'spi': add driver rtc-rx4581
[    5.165865] bus: 'platform': add driver stk17ta8
[    5.166515] bus: 'platform': add driver v3020
[    5.167130] bus: 'pci': add driver ptp_pch
[    5.167714] device: 'test_ac': device_add
[    5.168322] PM: Adding info for No Bus:test_ac
[    5.168938] power_supply test_ac: uevent
[    5.169491] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
[    5.170274] power_supply test_ac: prop ONLINE=1
[    5.170914] power_supply test_ac: power_supply_changed
[    5.171645] power_supply test_ac: power_supply_changed_work
[    5.172479] power_supply test_ac: power_supply_update_gen_leds 1
[    5.173317] power_supply test_ac: uevent
[    5.173869] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
[    5.174654] power_supply test_ac: prop ONLINE=1
[    5.175305] device: 'test_battery': device_add
[    5.175962] PM: Adding info for No Bus:test_battery
[    5.176676] power_supply test_battery: uevent
[    5.177294] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
[    5.178194] power_supply test_battery: prop STATUS=Discharging
[    5.179019] power_supply test_battery: prop CHARGE_TYPE=Fast
[    5.179802] power_supply test_battery: prop HEALTH=Good
[    5.180560] power_supply test_battery: prop PRESENT=1
[    5.181269] power_supply test_battery: prop TECHNOLOGY=Li-ion
[    5.182072] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
[    5.182927] power_supply test_battery: prop CHARGE_FULL=100
[    5.183707] power_supply test_battery: prop CHARGE_NOW=50
[    5.184504] power_supply test_battery: prop CAPACITY=50
[    5.185238] power_supply test_battery: prop CAPACITY_LEVEL=Normal
[    5.186086] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
[    5.186940] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
[    5.187792] power_supply test_battery: prop MODEL_NAME=Test battery
[    5.188687] power_supply test_battery: prop MANUFACTURER=Linux
[    5.189499] power_supply test_battery: prop SERIAL_NUMBER=3.9.0-rc4-00255-g7a0861d
[    5.190543] power_supply test_battery: prop TEMP=26
[    5.191224] power_supply test_battery: prop VOLTAGE_NOW=3300
[    5.201989] device: 'thermal_zone0': device_add
[    5.202647] PM: Adding info for No Bus:thermal_zone0
[    5.203402] device: 'hwmon0': device_add
[    5.203974] PM: Adding info for No Bus:hwmon0
[    5.204626] power_supply test_battery: power_supply_changed
[    5.205417] power_supply test_battery: power_supply_changed_work
[    5.206256] power_supply test_battery: power_supply_update_bat_leds 2
[    5.207154] power_supply test_battery: uevent
[    5.207760] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
[    5.208714] power_supply test_battery: prop STATUS=Discharging
[    5.209533] power_supply test_battery: prop CHARGE_TYPE=Fast
[    5.210317] power_supply test_battery: prop HEALTH=Good
[    5.211043] power_supply test_battery: prop PRESENT=1
[    5.211741] power_supply test_battery: prop TECHNOLOGY=Li-ion
[    5.212018] device: 'test_usb': device_add
[    5.212038] PM: Adding info for No Bus:test_usb
[    5.212042] power_supply test_usb: uevent
[    5.212043] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
[    5.212054] power_supply test_usb: prop ONLINE=1
[    5.212061] power_supply test_usb: power_supply_changed
[    5.212073] bus: 'platform': add driver bq27000-battery
[    5.212076] power_supply test_usb: power_supply_changed_work
[    5.212085] power_supply test_usb: power_supply_update_gen_leds 1
[    5.212088] power_supply test_usb: uevent
[    5.212089] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
[    5.212092] power_supply test_usb: prop ONLINE=1
[    5.212106] bus: 'platform': add driver da9052-bat
[    5.212113] bus: 'platform': add driver isp1704_charger
[    5.212172] bus: 'spi': add driver adcxx
[    5.212180] bus: 'spi': add driver ads7871
[    5.212186] bus: 'platform': add driver da9052-hwmon
[    5.212249] bus: 'platform': add driver gpio-fan
[    5.212259] bus: 'platform': add driver aem
[    5.212333] bus: 'platform': add driver sht15
[    5.212437] lguest: mapping switcher would thwack fixmap
[    5.212444] cpuidle: using governor ladder
[    5.212445] cpuidle: using governor menu
[    5.212446] sdhci: Secure Digital Host Controller Interface driver
[    5.212446] sdhci: Copyright(c) Pierre Ossman
[    5.212451] bus: 'usb': add driver ushc
[    5.212459] usbcore: registered new interface driver ushc
[    5.212461] bus: 'platform': add driver leds-gpio
[    5.212469] bus: 'platform': add driver leds-lt3593
[    5.212476] bus: 'spi': add driver dac124s085
[    5.212484] ledtrig-cpu: registered to indicate activity on CPUs
[    5.212487] Registering platform device 'dell_rbu'. Parent at platform
[    5.212488] device: 'dell_rbu': device_add
[    5.212491] bus: 'platform': add device dell_rbu
[    5.212500] PM: Adding info for platform:dell_rbu
[    5.212539] device: 'vhost-net': device_add
[    5.212553] PM: Adding info for No Bus:vhost-net
[    5.212569] bus: 'platform': add driver ste-modem
[    5.212582] device class 'extcon': registering
[    5.212589] bus: 'platform': add driver extcon-gpio
[    5.212617] pktgen: Packet Generator for packet performance testing. Version: 2.74
[    5.250997] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
[    5.251883] power_supply test_battery: prop CHARGE_FULL=100
[    5.252693] power_supply test_battery: prop CHARGE_NOW=50
[    5.253447] power_supply test_battery: prop CAPACITY=50
[    5.254175] power_supply test_battery: prop CAPACITY_LEVEL=Normal
[    5.255024] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
[    5.255872] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
[    5.256735] power_supply test_battery: prop MODEL_NAME=Test battery
[    5.257598] power_supply test_battery: prop MANUFACTURER=Linux
[    5.258406] power_supply test_battery: prop SERIAL_NUMBER=3.9.0-rc4-00255-g7a0861d
[    5.259446] power_supply test_battery: prop TEMP=26
[    5.260141] power_supply test_battery: prop VOLTAGE_NOW=3300
[    5.261003] NET: Registered protocol family 26
[    5.261633] NET: Registered protocol family 15
[    5.262279] bus: 'platform': add driver dsa
[    5.262880] NET: Registered protocol family 4
[    5.263508] NET: Registered protocol family 9
[    5.264133] X.25 for Linux Version 0.2
[    5.264658] can: controller area network core (rev 20120528 abi 9)
[    5.265586] NET: Registered protocol family 29
[    5.266218] can: broadcast manager protocol (rev 20120528 t)
[    5.267044] device: 'irlan0': device_add
[    5.267639] PM: Adding info for No Bus:irlan0
[    5.268343] lec:lane_module_init: lec.c: initialized
[    5.269053] NET: Registered protocol family 35
[    5.269685] 8021q: 802.1Q VLAN Support v1.8
[    5.270325] 9pnet: Installing 9P2000 support
[    5.270938] openvswitch: Open vSwitch switching datapath
[    5.271772] bus: 'machinecheck': registered
[    5.272390] device: 'machinecheck': device_add
[    5.273025] PM: Adding info for No Bus:machinecheck
[    5.273712] device: 'machinecheck0': device_add
[    5.274354] bus: 'machinecheck': add device machinecheck0
[    5.275124] PM: Adding info for machinecheck:machinecheck0
[    5.275916] device: 'machinecheck1': device_add
[    5.276578] bus: 'machinecheck': add device machinecheck1
[    5.277338] PM: Adding info for machinecheck:machinecheck1
[    5.278129] device: 'mcelog': device_add
[    5.278695] PM: Adding info for No Bus:mcelog
[    5.279712] 
[    5.279712] printing PIC contents
[    5.280414] ... PIC  IMR: ffff
[    5.280848] ... PIC  IRR: 1013
[    5.281293] ... PIC  ISR: 0000
[    5.281726] ... PIC ELCR: 0c00
[    5.282167] printing local APIC contents on CPU#0/0:
[    5.282862] ... APIC ID:      00000000 (0)
[    5.283440] ... APIC VERSION: 00050014
[    5.283970] ... APIC TASKPRI: 00000000 (00)
[    5.284397] ... APIC PROCPRI: 00000000
[    5.284397] ... APIC LDR: 01000000
[    5.284397] ... APIC DFR: ffffffff
[    5.284397] ... APIC SPIV: 000001ff
[    5.284397] ... APIC ISR field:
[    5.284397] 0000000000000000000000000000000000000000000000000000000000000000
[    5.284397] ... APIC TMR field:
[    5.284397] 0000000000000000000000000000000000000000000000000000000000000000
[    5.284397] ... APIC IRR field:
[    5.284397] 0000000000000000000000000000000000000000000000000000000000008000
[    5.284397] ... APIC ESR: 00000000
[    5.284397] ... APIC ICR: 000008fd
[    5.284397] ... APIC ICR2: 02000000
[    5.284397] ... APIC LVTT: 000000ef
[    5.284397] ... APIC LVTPC: 00010000
[    5.284397] ... APIC LVT0: 00010700
[    5.284397] ... APIC LVT1: 00000400
[    5.284397] ... APIC LVTERR: 000000fe
[    5.284397] ... APIC TMICT: 00036eca
[    5.284397] ... APIC TMCCT: 00000000
[    5.284397] ... APIC TDCR: 00000003
[    5.284397] 
[    5.297247] number of MP IRQ sources: 15.
[    5.297806] number of IO-APIC #2 registers: 24.
[    5.298440] testing the IO APIC.......................
[    5.299177] IO APIC #2......
[    5.299585] .... register #00: 00000000
[    5.300145] .......    : physical APIC id: 00
[    5.300748] .......    : Delivery Type: 0
[    5.301310] .......    : LTS          : 0
[    5.301865] .... register #01: 00170011
[    5.302404] .......     : max redirection entries: 17
[    5.303107] .......     : PRQ implemented: 0
[    5.303700] .......     : IO APIC version: 11
[    5.304325] .... register #02: 00000000
[    5.304858] .......     : arbitration: 00
[    5.305424] .... IRQ redirection table:
[    5.305981] 1    0    0   0   0    0    0    00
[    5.306623] 0    0    0   0   0    1    1    31
[    5.307271] 0    0    0   0   0    1    1    30
[    5.307912] 0    0    0   0   0    1    1    33
[    5.308571] 1    0    0   0   0    1    1    34
[    5.309217] 1    1    0   0   0    1    1    35
[    5.309860] 0    0    0   0   0    1    1    36
[    5.310507] 0    0    0   0   0    1    1    37
[    5.311154] 0    0    0   0   0    1    1    38
[    5.311792] 0    1    0   0   0    1    1    39
[    5.312465] 1    1    0   0   0    1    1    3A
[    5.313128] 1    1    0   0   0    1    1    3B
[    5.313768] 0    0    0   0   0    1    1    3C
[    5.314417] 0    0    0   0   0    1    1    3D
[    5.315065] 0    0    0   0   0    1    1    3E
[    5.315707] 0    0    0   0   0    1    1    3F
[    5.316414] 1    0    0   0   0    0    0    00
[    5.317063] 1    0    0   0   0    0    0    00
[    5.317702] 1    0    0   0   0    0    0    00
[    5.318347] 1    0    0   0   0    0    0    00
[    5.318995] 1    0    0   0   0    0    0    00
[    5.319640] 1    0    0   0   0    0    0    00
[    5.320358] 1    0    0   0   0    0    0    00
[    5.321010] 1    0    0   0   0    0    0    00
[    5.321637] IRQ to pin mappings:
[    5.322096] IRQ0 -> 0:2
[    5.322489] IRQ1 -> 0:1
[    5.322878] IRQ3 -> 0:3
[    5.323272] IRQ4 -> 0:4
[    5.323662] IRQ5 -> 0:5
[    5.324097] IRQ6 -> 0:6
[    5.324486] IRQ7 -> 0:7
[    5.324875] IRQ8 -> 0:8
[    5.325270] IRQ9 -> 0:9
[    5.325659] IRQ10 -> 0:10
[    5.326076] IRQ11 -> 0:11
[    5.326489] IRQ12 -> 0:12
[    5.326901] IRQ13 -> 0:13
[    5.327318] IRQ14 -> 0:14
[    5.327731] IRQ15 -> 0:15
[    5.328201] .................................... done.
[    5.328909] Using IPI No-Shortcut mode
[    5.333448] device: 'cpu_dma_latency': device_add
[    5.333448] PM: Adding info for No Bus:cpu_dma_latency
[    5.340524] device: 'network_latency': device_add
[    5.341199] PM: Adding info for No Bus:network_latency
[    5.341919] device: 'network_throughput': device_add
[    5.342626] PM: Adding info for No Bus:network_throughput
[    5.343434] IMA: No TPM chip found, activating TPM-bypass!
[    5.344825] dmaengine: __dma_request_channel: fail ((null))
[    5.355000] bus: 'platform': add driver gpio-keys
[    5.355830] bus: 'platform': add driver charger-manager
[    5.356598] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    5.357432] EDD information not available.
[    5.365122] Unregister pv shared memory for cpu 0
[    5.395213] CPU0 attaching NULL sched-domain.
[    5.395848] CPU1 attaching NULL sched-domain.
[    5.396512] CPU1 attaching NULL sched-domain.
[    5.428793] device: 'cpu0': device_unregister
[    5.429468] PM: Removing info for No Bus:cpu0
[    5.430097] device: 'cpu0': device_create_release
[    5.430784] device: 'machinecheck0': device_unregister
[    5.431513] bus: 'machinecheck': remove device machinecheck0
[    5.432318] PM: Removing info for machinecheck:machinecheck0
[    5.433126] CPU 0 is now offline
[    5.434140] Freeing unused kernel memory: 532k freed
[    5.435351] Write protecting the kernel text: 7712k
[    5.436136] Testing CPA: Reverting 81000000-81788000
[    5.436940] Testing CPA: write protecting again
[    5.437817] Write protecting the kernel read-only data: 3304k
[    5.438614] Testing CPA: undo 81788000-81ac2000
[    5.439319] Testing CPA: write protecting again
[    5.440085] BUG: sleeping function called from invalid context at /c/kernel-tests/src/linux/kernel/cpu.c:68
[    5.441418] in_atomic(): 1, irqs_disabled(): 1, pid: 10, name: rcu_sched
[    5.442348] Pid: 10, comm: rcu_sched Not tainted 3.9.0-rc4-00255-g7a0861d #330
[    5.443346] Call Trace:
[    5.443725]  [<810767ab>] __might_sleep+0x15b/0x170
[    5.444010]  [<81046c49>] get_online_cpus+0x19/0x50
[    5.444010]  [<810a279f>] rcu_implicit_dynticks_qs+0x5f/0xb0
[    5.444010]  [<810a363c>] force_qs_rnp+0xcc/0x150
[    5.444010]  [<810a2740>] ? force_quiescent_state+0xf0/0xf0
[    5.444010]  [<810a43fa>] rcu_gp_fqs+0x3a/0x90
[    5.444010]  [<810a487a>] rcu_gp_kthread+0x42a/0x720
[    5.444010]  [<81065c50>] ? abort_exclusive_wait+0x80/0x80
[    5.444010]  [<810a4450>] ? rcu_gp_fqs+0x90/0x90
[    5.444010]  [<81064eff>] kthread+0x8f/0xa0
[    5.444010]  [<81070000>] ? perf_trace_sched_wakeup_template+0x60/0xf0
[    5.444010]  [<817860f7>] ret_from_kernel_thread+0x1b/0x28
[    5.444010]  [<81064e70>] ? __kthread_parkme+0x70/0x70
mountall: ply-event-loop.c:497: ply_event_loop_new: Assertion `loop->epoll_fd >= 0' failed.
General error mounting filesystems.
A maintenance shell will now be started.
CONTROL-D will terminate this shell and reboot the system.
wfg: rebooting
[    5.558625] Unregister pv shared memory for cpu 1
[    5.560069] Disabling non-boot CPUs ...
[    5.560598] Restarting system.
[    5.561027] reboot: machine restart

--8P1HSweYDcXXzwPJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="7a0861da273ddc4ba4fdbe3224d5cf1624646691-bisect.log"

bisect: skip a12183c62717ac4579319189a00f5883a18dff08: not a good merge base
git checkout v3.8
Previous HEAD position was 7a0861d... Merge remote-tracking branch 'rcu/dev.2013.03.26a' into devel-roam-i386-2013-03-27-04-47
HEAD is now at 19f949f... Linux 3.8

2013-03-28-20:46:37 19f949f52599ba7c3f67a5897ac6be14bfcb1200 compiling
/home/wfg/tip

2013-03-28-20:48:53 detecting boot state 3.8.0-bisect2 #44 	3	11	17	25 SUCCESS
bisect: good commit v3.8
git bisect start 7a0861da273ddc4ba4fdbe3224d5cf1624646691 v3.8 --
Previous HEAD position was 19f949f... Linux 3.8
HEAD is now at 3c0eee3... Linux 2.6.37
Bisecting: 6109 revisions left to test after this (roughly 13 steps)
[8b5628ab83b671f96ac9f174c1bd51c92589fc82] Merge tag 'virt' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect run /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-03-28-20:51:54 8b5628ab83b671f96ac9f174c1bd51c92589fc82 compiling
/home/wfg/tip

2013-03-28-20:54:33 detecting boot state 3.8.0-bisect2-05986-g8b5628a #45 	4	11	16	24	31 SUCCESS
Bisecting: 3053 revisions left to test after this (roughly 12 steps)
[ecc88efbe7adceb3f4bfdbbb1efb669efcaab124] Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-03-28-20:57:36 ecc88efbe7adceb3f4bfdbbb1efb669efcaab124 compiling
/home/wfg/tip

2013-03-28-21:01:04 detecting boot state 3.8.0-bisect2-02655-gecc88ef #46 	3	10	18	22	30 SUCCESS
Bisecting: 1468 revisions left to test after this (roughly 11 steps)
[b695188dd39162a1a6bff11fdbcc4c0b65b933ab] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-03-28-21:04:08 b695188dd39162a1a6bff11fdbcc4c0b65b933ab compiling
/home/wfg/tip

2013-03-28-21:06:52 detecting boot state 3.8.0-bisect2-01305-gb695188 #47 	8	17	23	29 SUCCESS
Bisecting: 738 revisions left to test after this (roughly 10 steps)
[cad9d5664a74702d3df7a1bf4ab1221428c3ff87] Merge tag 'tty-3.9-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-03-28-21:09:25 cad9d5664a74702d3df7a1bf4ab1221428c3ff87 compiling
/home/wfg/tip

2013-03-28-21:11:54 detecting boot state 3.9.0-rc2-bisect2-00216-gcad9d56 #48 	9	18	28 SUCCESS
Bisecting: 370 revisions left to test after this (roughly 9 steps)
[d3c926264a92e5ea448add3e883530e1edad3ce2] Merge tag 'ext4_for_linue' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-03-28-21:13:56 d3c926264a92e5ea448add3e883530e1edad3ce2 compiling
/home/wfg/tip

2013-03-28-21:16:54 detecting boot state 3.9.0-rc3-bisect2-00230-gd3c9262 #49 	11	17	24	31 SUCCESS
Bisecting: 156 revisions left to test after this (roughly 8 steps)
[45f66fe90604d67a32b6663189d6201dd63e43c5] Merge remote-tracking branch 'drm-intel/drm-intel-next-queued' into devel-roam-i386-2013-03-27-04-47
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-03-28-21:19:26 45f66fe90604d67a32b6663189d6201dd63e43c5 compiling
/home/wfg/tip

2013-03-28-21:21:43 detecting boot state 3.9.0-rc4-bisect2-00098-g45f66fe #50 	7	15	19	27	34 SUCCESS
Bisecting: 78 revisions left to test after this (roughly 6 steps)
[3d597e98ceced8cb5c4c45ea339ae8af31487477] arm64: KVM: Plug the VGIC
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-03-28-21:24:45 3d597e98ceced8cb5c4c45ea339ae8af31487477 compiling
/home/wfg/tip

2013-03-28-21:27:21 detecting boot state 3.9.0-rc3-bisect2-00083-g3d597e9 #51 	10	19	28	35 SUCCESS
Bisecting: 37 revisions left to test after this (roughly 5 steps)
[73806b1c8e9c079288acaaf3dfdf566dabd2413c] Merge remote-tracking branch 'regmap/for-next' into devel-roam-i386-2013-03-27-04-47
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-03-28-21:29:52 73806b1c8e9c079288acaaf3dfdf566dabd2413c compiling
/home/wfg/tip

2013-03-28-21:32:25 detecting boot state 3.9.0-rc4-bisect2-00217-g73806b1 #52 	8	12	20	27	33 SUCCESS
Bisecting: 22 revisions left to test after this (roughly 4 steps)
[910ee45db2f4837c8440e770474758493ab94bf7] rcu: Make rcu_accelerate_cbs() note need for future grace periods
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-03-28-21:35:27 910ee45db2f4837c8440e770474758493ab94bf7 compiling
/home/wfg/tip

2013-03-28-21:37:59 detecting boot state 3.9.0-rc2-bisect2-00015-g910ee45 #53 	11	23	30 SUCCESS
Bisecting: 11 revisions left to test after this (roughly 4 steps)
[a46e1ecb936cb209e236d28d7dc1396c736a6c9d] rcu: Remove srcu_read_lock_raw() and srcu_read_unlock_raw().
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-03-28-21:40:00 a46e1ecb936cb209e236d28d7dc1396c736a6c9d compiling
/home/wfg/tip

2013-03-28-21:42:25 detecting boot state 3.9.0-rc2-bisect2-00026-ga46e1ecb #54 	8	15	18	26	33 SUCCESS
Bisecting: 5 revisions left to test after this (roughly 3 steps)
[7b48afd55f65960962593e46400e710a04ba7a6c] rcu: Switch callers from rcu_process_gp_end() to note_gp_changes()
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-03-28-21:45:27 7b48afd55f65960962593e46400e710a04ba7a6c compiling
/home/wfg/tip

2013-03-28-21:47:03 detecting boot state 3.9.0-rc2-bisect2-00032-g7b48afd #55 	4	12	15	22	31 SUCCESS
Bisecting: 2 revisions left to test after this (roughly 2 steps)
[8902eb3ab3e3f63c3f5e85734470941aecfc00e3] rcu: Inline trivial wrapper function rcu_start_gp_per_cpu()
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-03-28-21:50:05 8902eb3ab3e3f63c3f5e85734470941aecfc00e3 compiling
/home/wfg/tip

2013-03-28-21:51:49 detecting boot state 3.9.0-rc2-bisect2-00035-g8902eb3 #56  TEST FAILURE
Bisecting: 0 revisions left to test after this (roughly 1 step)
[0d5522f080c10c35625e7c4c99ced17484cb9bfc] rcu: Eliminate check_for_new_grace_period() wrapper function
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-03-28-21:52:20 0d5522f080c10c35625e7c4c99ced17484cb9bfc compiling
/home/wfg/tip

2013-03-28-21:53:50 detecting boot state 3.9.0-rc2-bisect2-00034-g0d5522f #57 	6	15	21	27 SUCCESS
8902eb3ab3e3f63c3f5e85734470941aecfc00e3 is the first bad commit
commit 8902eb3ab3e3f63c3f5e85734470941aecfc00e3
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Tue Mar 19 12:27:50 2013 -0700

    rcu: Inline trivial wrapper function rcu_start_gp_per_cpu()
    
    Given the changes that introduce note_gp_change(), rcu_start_gp_per_cpu()
    is now a trivial wrapper function with only one caller.  This commit
    therefore inlines it into its sole call site.
    
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

:040000 040000 73723ec021f140947a81d6fb4be32fc3ff8423cb 88db3a31a8ebb308566fe5cd431c7724d95a0729 M	kernel
bisect run success

2013-03-28-21:56:24 0d5522f080c10c35625e7c4c99ced17484cb9bfc compiling
/home/wfg/tip

2013-03-28-21:57:19 detecting boot state 3.9.0-rc2-bisect2-00034-g0d5522f #57 	9	18	29	38	48	58	68 SUCCESS

2013-03-28-22:01:22 7a0861da273ddc4ba4fdbe3224d5cf1624646691 compiling
/home/wfg/tip

2013-03-28-22:03:39 detecting boot state 3.9.0-rc4-bisect2-00255-g7a0861d #58  TEST FAILURE
ERROR# 1: /c/kernel-tests/bisect:58: main: $BISECT_TEST $KBUILD_OUTPUT
[detached HEAD 0ed9dc7] Revert "rcu: Inline trivial wrapper function rcu_start_gp_per_cpu()"
 1 file changed, 13 insertions(+), 1 deletion(-)

2013-03-28-22:04:10 0ed9dc7c1351a22c05b3fbddf766e9c1a373d40a compiling
/home/wfg/tip

2013-03-28-22:05:28 detecting boot state 3.9.0-rc4-bisect2-00256-g0ed9dc7 #59  TEST FAILURE
ERROR# 1: /c/kernel-tests/bisect:61: main: $BISECT_TEST $KBUILD_OUTPUT

========= linux-next =========
Fetching next

2013-03-28-22:19:15 da17d7bda957ae4697b6abc0793f74fb9b50b58f compiling
/home/wfg/tip

2013-03-28-22:21:22 detecting boot state 3.9.0-rc4-bisect2-next-20130328 #60 	7	9	16	22	27	33	36	42	45	51	54	60	63	67	70	76	79	84	88	89 SUCCESS

--8P1HSweYDcXXzwPJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.9.0-rc4 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ALWAYS_USE_PERSISTENT_CLOCK=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_CGROUPS is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_UIDGID_CONVERTED=y
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_HAVE_UID16=y
CONFIG_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
# CONFIG_AIO is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
CONFIG_UPROBES=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
CONFIG_BLK_DEV_INTEGRITY=y

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_BIGSMP=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_WANT_INTEL_MID is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_RDC321X is not set
CONFIG_X86_32_NON_STANDARD=y
# CONFIG_X86_NUMAQ is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_STA2X11 is not set
CONFIG_X86_SUMMIT=y
CONFIG_X86_ES7000=y
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
CONFIG_LGUEST_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_PARAVIRT_DEBUG=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
CONFIG_X86_CYCLONE_TIMER=y
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=5
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_CYRIX_32 is not set
# CONFIG_CPU_SUP_AMD is not set
CONFIG_CPU_SUP_CENTAUR=y
# CONFIG_CPU_SUP_TRANSMETA_32 is not set
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=32
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
CONFIG_X86_ANCIENT_MCE=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_VM86=y
CONFIG_TOSHIBA=y
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
CONFIG_VMSPLIT_2G=y
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x80000000
CONFIG_HIGHMEM=y

#
# NUMA (Summit) requires SMP, 64GB highmem support, ACPI
#
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=y
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
CONFIG_APM_IGNORE_USER_SUSPEND=y
# CONFIG_APM_DO_ENABLE is not set
# CONFIG_APM_CPU_IDLE is not set
CONFIG_APM_DISPLAY_BLANK=y
CONFIG_APM_ALLOW_INTS=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K6=y
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K7_ACPI=y
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=y
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
CONFIG_X86_LONGRUN=y
# CONFIG_X86_LONGHAUL is not set
CONFIG_X86_E_POWERSAVER=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
CONFIG_ALIX=y
CONFIG_NET5501=y
CONFIG_GEOS=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETWORK_PHY_TIMESTAMPING=y
# CONFIG_NETFILTER is not set
CONFIG_ATM=y
CONFIG_ATM_LANE=y
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_VLAN_8021Q_MVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
# CONFIG_ATALK is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_PHONET=y
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=y
# CONFIG_VSOCKETS is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
CONFIG_CAN_BCM=y
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
CONFIG_CAN_SLCAN=y
CONFIG_CAN_DEV=y
# CONFIG_CAN_CALC_BITTIMING is not set
CONFIG_CAN_LEDS=y
CONFIG_CAN_MCP251X=y
# CONFIG_PCH_CAN is not set
# CONFIG_CAN_SJA1000 is not set
# CONFIG_CAN_C_CAN is not set
# CONFIG_CAN_CC770 is not set

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=y
# CONFIG_CAN_ESD_USB2 is not set
# CONFIG_CAN_KVASER_USB is not set
CONFIG_CAN_PEAK_USB=y
# CONFIG_CAN_8DEV_USB is not set
CONFIG_CAN_SOFTING=y
# CONFIG_CAN_SOFTING_CS is not set
CONFIG_CAN_DEBUG_DEVICES=y
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
# CONFIG_IRCOMM is not set
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
# CONFIG_IRDA_FAST_RR is not set
CONFIG_IRDA_DEBUG=y

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#
CONFIG_KINGSUN_DONGLE=y
CONFIG_KSDAZZLE_DONGLE=y
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
# CONFIG_SIGMATEL_FIR is not set
# CONFIG_NSC_FIR is not set
# CONFIG_WINBOND_FIR is not set
# CONFIG_TOSHIBA_FIR is not set
# CONFIG_SMC_IRCC_FIR is not set
CONFIG_ALI_FIR=y
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
CONFIG_MCS_FIR=y
# CONFIG_BT is not set
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
CONFIG_CFG80211_REG_DEBUG=y
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
# CONFIG_MAC80211_RC_PID is not set
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_MINSTREL_HT is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
CONFIG_MAC80211_DEBUG_MENU=y
# CONFIG_MAC80211_NOINLINE is not set
# CONFIG_MAC80211_VERBOSE_DEBUG is not set
# CONFIG_MAC80211_MLME_DEBUG is not set
CONFIG_MAC80211_STA_DEBUG=y
# CONFIG_MAC80211_HT_DEBUG is not set
# CONFIG_MAC80211_IBSS_DEBUG is not set
CONFIG_MAC80211_PS_DEBUG=y
# CONFIG_MAC80211_MPL_DEBUG is not set
CONFIG_MAC80211_MPATH_DEBUG=y
CONFIG_MAC80211_MHWMP_DEBUG=y
# CONFIG_MAC80211_MESH_SYNC_DEBUG is not set
# CONFIG_MAC80211_MESH_PS_DEBUG is not set
CONFIG_MAC80211_TDLS_DEBUG=y
# CONFIG_MAC80211_DEBUG_COUNTERS is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_NET_9P=y
# CONFIG_NET_9P_VIRTIO is not set
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
CONFIG_DEBUG_DRIVER=y
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set
# CONFIG_CMA is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=y
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_CHAR=y
CONFIG_HAVE_MTD_OTP=y
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
CONFIG_FTL=y
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
CONFIG_MTD_OOPS=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
CONFIG_MTD_CFI_LE_BYTE_SWAP=y
# CONFIG_MTD_CFI_GEOMETRY is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_OTP=y
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_SC520CDP is not set
CONFIG_MTD_NETSC520=y
CONFIG_MTD_TS5500=y
# CONFIG_MTD_SBC_GXX is not set
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_PCI is not set
CONFIG_MTD_PCMCIA=y
# CONFIG_MTD_PCMCIA_ANONYMOUS is not set
CONFIG_MTD_GPIO_ADDR=y
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=y
CONFIG_MTD_DATAFLASH_WRITE_VERIFY=y
# CONFIG_MTD_DATAFLASH_OTP is not set
# CONFIG_MTD_M25P80 is not set
CONFIG_MTD_SST25L=y
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
# CONFIG_MTD_NAND is not set
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
CONFIG_MTD_ONENAND_GENERIC=y
# CONFIG_MTD_ONENAND_OTP is not set
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set
CONFIG_MTD_ONENAND_SIM=y

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
# CONFIG_MTD_UBI is not set
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_PC_PCMCIA=y
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_OSD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_SPI=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ATMEL_SSC=y
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
CONFIG_TI_DAC7512=y
CONFIG_VMWARE_BALLOON=y
# CONFIG_BMP085_SPI is not set
# CONFIG_PCH_PHUB is not set
CONFIG_LATTICE_ECP3_CONFIG=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y

#
# Altera FPGA firmware download module
#
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
CONFIG_CHR_DEV_ST=y
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPT3SAS is not set
CONFIG_SCSI_UFSHCD=y
# CONFIG_SCSI_UFSHCD_PCI is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_NSP32 is not set
CONFIG_SCSI_DEBUG=y
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=y
# CONFIG_SCSI_CHELSIO_FCOE is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=y
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_DUMMY is not set
CONFIG_EQUALIZER=y
# CONFIG_NET_FC is not set
CONFIG_MII=y
CONFIG_NET_TEAM=y
CONFIG_NET_TEAM_MODE_BROADCAST=y
CONFIG_NET_TEAM_MODE_ROUNDROBIN=y
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=y
CONFIG_NET_TEAM_MODE_LOADBALANCE=y
# CONFIG_MACVLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_TUN is not set
CONFIG_VETH=y
CONFIG_VIRTIO_NET=y
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=y
# CONFIG_ARCNET_RAW is not set
# CONFIG_ARCNET_CAP is not set
# CONFIG_ARCNET_COM90xx is not set
# CONFIG_ARCNET_COM90xxIO is not set
CONFIG_ARCNET_RIM_I=y
# CONFIG_ARCNET_COM20020 is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_FIRESTREAM is not set
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
# CONFIG_NET_DSA_MV88E6060 is not set
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_ETHERNET=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_PCMCIA_3C574 is not set
CONFIG_PCMCIA_3C589=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
CONFIG_PCMCIA_NMCLAN=y
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
CONFIG_NET_CADENCE=y
CONFIG_ARM_AT91_ETHER=y
CONFIG_MACB=y
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_DNET=y
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
# CONFIG_NET_VENDOR_FUJITSU is not set
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
# CONFIG_IXGBE is not set
CONFIG_NET_VENDOR_I825XX=y
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8842 is not set
CONFIG_KS8851=y
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MICROCHIP=y
CONFIG_ENC28J60=y
CONFIG_ENC28J60_WRITEVERIFY=y
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
# CONFIG_ETHOC is not set
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R8169 is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
# CONFIG_NET_VENDOR_SEEQ is not set
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
# CONFIG_SFC is not set
# CONFIG_NET_VENDOR_SMSC is not set
CONFIG_NET_VENDOR_STMICRO=y
CONFIG_STMMAC_ETH=y
CONFIG_STMMAC_PLATFORM=y
# CONFIG_STMMAC_PCI is not set
# CONFIG_STMMAC_DEBUG_FS is not set
# CONFIG_STMMAC_DA is not set
# CONFIG_STMMAC_RING is not set
CONFIG_STMMAC_CHAINED=y
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
CONFIG_WIZNET_W5100=y
CONFIG_WIZNET_W5300=y
# CONFIG_WIZNET_BUS_DIRECT is not set
CONFIG_WIZNET_BUS_INDIRECT=y
# CONFIG_WIZNET_BUS_ANY is not set
CONFIG_NET_VENDOR_XIRCOM=y
CONFIG_PCMCIA_XIRC2PS=y
# CONFIG_FDDI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
# CONFIG_AMD_PHY is not set
# CONFIG_MARVELL_PHY is not set
CONFIG_DAVICOM_PHY=y
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=y
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=y
# CONFIG_SMSC_PHY is not set
CONFIG_BROADCOM_PHY=y
CONFIG_BCM87XX_PHY=y
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
# CONFIG_MDIO_GPIO is not set
CONFIG_MICREL_KS8995MA=y
# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
CONFIG_USB_PEGASUS=y
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=y
CONFIG_USB_NET_CDCETHER=y
# CONFIG_USB_NET_CDC_EEM is not set
CONFIG_USB_NET_CDC_NCM=y
CONFIG_USB_NET_CDC_MBIM=y
CONFIG_USB_NET_DM9601=y
CONFIG_USB_NET_SMSC75XX=y
# CONFIG_USB_NET_SMSC95XX is not set
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
# CONFIG_USB_EPSON2888 is not set
CONFIG_USB_KC2190=y
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
CONFIG_USB_NET_QMI_WWAN=y
CONFIG_USB_NET_INT51X1=y
CONFIG_USB_CDC_PHONET=y
# CONFIG_USB_IPHETH is not set
# CONFIG_USB_SIERRA_NET is not set
CONFIG_USB_VL600=y
CONFIG_WLAN=y
CONFIG_PCMCIA_RAYCS=y
CONFIG_LIBERTAS_THINFIRM=y
CONFIG_LIBERTAS_THINFIRM_DEBUG=y
# CONFIG_LIBERTAS_THINFIRM_USB is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
CONFIG_AT76C50X_USB=y
# CONFIG_AIRO_CS is not set
CONFIG_PCMCIA_WL3501=y
# CONFIG_PRISM54 is not set
CONFIG_USB_ZD1201=y
CONFIG_USB_NET_RNDIS_WLAN=y
# CONFIG_RTL8180 is not set
CONFIG_RTL8187=y
CONFIG_RTL8187_LEDS=y
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
# CONFIG_ATH_CARDS is not set
CONFIG_B43=y
CONFIG_B43_BCMA=y
CONFIG_B43_BCMA_EXTRA=y
CONFIG_B43_SSB=y
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_PCMCIA=y
# CONFIG_B43_SDIO is not set
CONFIG_B43_BCMA_PIO=y
CONFIG_B43_PIO=y
CONFIG_B43_PHY_N=y
# CONFIG_B43_PHY_LP is not set
CONFIG_B43_PHY_HT=y
CONFIG_B43_LEDS=y
CONFIG_B43_DEBUG=y
CONFIG_B43LEGACY=y
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
# CONFIG_B43LEGACY_DEBUG is not set
CONFIG_B43LEGACY_PIO=y
# CONFIG_B43LEGACY_DMA_AND_PIO_MODE is not set
# CONFIG_B43LEGACY_DMA_MODE is not set
CONFIG_B43LEGACY_PIO_MODE=y
CONFIG_BRCMUTIL=y
# CONFIG_BRCMSMAC is not set
CONFIG_BRCMFMAC=y
CONFIG_BRCMFMAC_SDIO=y
# CONFIG_BRCMFMAC_SDIO_OOB is not set
# CONFIG_BRCMFMAC_USB is not set
CONFIG_BRCM_TRACING=y
# CONFIG_BRCMDBG is not set
# CONFIG_HOSTAP is not set
# CONFIG_IPW2100 is not set
# CONFIG_IWLWIFI is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_LIBERTAS is not set
CONFIG_P54_COMMON=y
# CONFIG_P54_USB is not set
# CONFIG_P54_PCI is not set
# CONFIG_P54_SPI is not set
CONFIG_P54_LEDS=y
CONFIG_RT2X00=y
# CONFIG_RT2400PCI is not set
# CONFIG_RT2500PCI is not set
# CONFIG_RT61PCI is not set
# CONFIG_RT2800PCI is not set
CONFIG_RT2500USB=y
CONFIG_RT73USB=y
CONFIG_RT2800USB=y
# CONFIG_RT2800USB_RT33XX is not set
# CONFIG_RT2800USB_RT35XX is not set
CONFIG_RT2800USB_RT53XX=y
CONFIG_RT2800USB_UNKNOWN=y
CONFIG_RT2800_LIB=y
CONFIG_RT2X00_LIB_USB=y
CONFIG_RT2X00_LIB=y
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
CONFIG_RT2X00_LIB_DEBUGFS=y
# CONFIG_RT2X00_DEBUG is not set
# CONFIG_RTLWIFI is not set
CONFIG_WL_TI=y
# CONFIG_WL1251 is not set
# CONFIG_WL12XX is not set
# CONFIG_WL18XX is not set
CONFIG_WLCORE=y
CONFIG_WLCORE_SPI=y
# CONFIG_WLCORE_SDIO is not set
CONFIG_ZD1211RW=y
CONFIG_ZD1211RW_DEBUG=y
# CONFIG_MWIFIEX is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=y
CONFIG_WIMAX_I2400M_USB=y
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=y
# CONFIG_HDLC_RAW is not set
CONFIG_HDLC_RAW_ETH=y
# CONFIG_HDLC_CISCO is not set
# CONFIG_HDLC_FR is not set
CONFIG_HDLC_PPP=y
# CONFIG_HDLC_X25 is not set
# CONFIG_PCI200SYN is not set
# CONFIG_WANXL is not set
# CONFIG_PC300TOO is not set
# CONFIG_FARSYNC is not set
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
# CONFIG_LAPBETHER is not set
CONFIG_X25_ASY=y
CONFIG_SBNI=y
CONFIG_SBNI_MULTILINE=y
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_GPIO=y
# CONFIG_KEYBOARD_GPIO_POLLED is not set
CONFIG_KEYBOARD_MATRIX=y
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_STOWAWAY=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_GTCO is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
CONFIG_TABLET_USB_WACOM=y
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_GPIO_TILT_POLLED=y
CONFIG_INPUT_WISTRON_BTNS=y
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=y
CONFIG_INPUT_KEYSPAN_REMOTE=y
# CONFIG_INPUT_POWERMATE is not set
CONFIG_INPUT_YEALINK=y
CONFIG_INPUT_CM109=y
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
CONFIG_INPUT_DA9052_ONKEY=y
CONFIG_INPUT_ADXL34X=y
# CONFIG_INPUT_ADXL34X_SPI is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
CONFIG_N_HDLC=y
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y
# CONFIG_STALDRV is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_DMA is not set
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_TIMBERDALE=y
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_TTY_PRINTK=y
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=y
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
CONFIG_CARDMAN_4040=y
# CONFIG_IPWIRELESS is not set
CONFIG_MWAVE=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_LM70_LLP=y
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_TOPCLIFF_PCH is not set
# CONFIG_SPI_XILINX is not set
CONFIG_SPI_DESIGNWARE=y
# CONFIG_SPI_DW_PCI is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=y

#
# PPS support
#
CONFIG_PPS=y
CONFIG_PPS_DEBUG=y

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_PARPORT is not set
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
# CONFIG_DP83640_PHY is not set
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_TS5500=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_TPS65912 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
# CONFIG_GPIO_MCP23S08 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#

#
# USB GPIO expanders:
#
# CONFIG_GPIO_VIPERBOARD is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9052=y
CONFIG_CHARGER_ISP1704=y
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_MANAGER=y
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_ADCXX=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_GPIO_FAN=y
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=y
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_LM70 is not set
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS7871=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_CPU_THERMAL is not set
CONFIG_THERMAL_EMULATION=y
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_BLOCKIO=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_HTC_PASIC3=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_ABX500_CORE=y
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_LPC_SCH is not set
# CONFIG_LPC_ICH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_VIPERBOARD=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_GPIO is not set
# CONFIG_REGULATOR_DA9052 is not set
# CONFIG_REGULATOR_TPS6524X is not set
# CONFIG_REGULATOR_TPS65912 is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
# CONFIG_FB is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_L4F00242T03=y
CONFIG_LCD_LMS283GF05=y
# CONFIG_LCD_LTV350QV is not set
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=y
CONFIG_LCD_VGG2432A4=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_LCD_S6E63M0=y
# CONFIG_LCD_LD9040 is not set
CONFIG_LCD_AMS369FG06=y
# CONFIG_LCD_LMS501KF03 is not set
# CONFIG_LCD_HX8357 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_DA9052=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_SOUND is not set

#
# HID support
#
# CONFIG_HID is not set

#
# USB HID support
#
# CONFIG_USB_HID is not set
CONFIG_HID_PID=y

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=y
# CONFIG_USB_MOUSE is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
CONFIG_USB_OTG_BLACKLIST_HUB=y
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
# CONFIG_USB_XHCI_HCD is not set
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=y
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_SL811_CS=y
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_HCD_BCMA=y
# CONFIG_USB_HCD_SSB is not set
CONFIG_USB_CHIPIDEA=y
# CONFIG_USB_CHIPIDEA_DEBUG is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=y
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
# CONFIG_USB_STORAGE is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
CONFIG_USB_MICROTEK=y

#
# USB port drivers
#
CONFIG_USB_USS720=y
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=y
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=y
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=y
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
CONFIG_USB_ISIGHTFW=y
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set

#
# USB Physical Layer drivers
#
CONFIG_OMAP_USB3=y
CONFIG_OMAP_CONTROL_USB=y
# CONFIG_USB_RCAR_PHY is not set
CONFIG_USB_ATM=y
CONFIG_USB_SPEEDTOUCH=y
# CONFIG_USB_CXACRU is not set
# CONFIG_USB_UEAGLEATM is not set
# CONFIG_USB_XUSBATM is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=y
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
# CONFIG_MMC_SDHCI_PLTFM is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
CONFIG_MMC_USHC=y
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_CLEVO_MAIL=y
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_DAC124S085=y
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
# CONFIG_LEDS_TRIGGER_GPIO is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
# CONFIG_RTC_DRV_TEST is not set

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
CONFIG_RTC_DRV_M41T94=y
CONFIG_RTC_DRV_DS1305=y
CONFIG_RTC_DRV_DS1390=y
CONFIG_RTC_DRV_MAX6902=y
# CONFIG_RTC_DRV_R9701 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
CONFIG_RTC_DRV_DS3234=y
# CONFIG_RTC_DRV_PCF2123 is not set
CONFIG_RTC_DRV_RX4581=y

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_DA9052=y
CONFIG_RTC_DRV_STK17TA8=y
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_DS2404=y

#
# on-CPU RTC drivers
#

#
# HID Sensor RTC drivers
#
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
# CONFIG_DMADEVICES_VDEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_DW_DMAC is not set
CONFIG_TIMB_DMA=y
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
CONFIG_VIRT_DRIVERS=y
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=y
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
# CONFIG_QUOTA is not set
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_VMCORE=y
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=y
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
CONFIG_JFFS2_FS_WBUF_VERIFY=y
# CONFIG_JFFS2_SUMMARY is not set
# CONFIG_JFFS2_FS_XATTR is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
# CONFIG_JFFS2_ZLIB is not set
CONFIG_JFFS2_LZO=y
# CONFIG_JFFS2_RTIME is not set
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_JFFS2_CMODE_NONE is not set
# CONFIG_JFFS2_CMODE_PRIORITY is not set
CONFIG_JFFS2_CMODE_SIZE=y
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_XATTR=y
# CONFIG_SQUASHFS_ZLIB is not set
# CONFIG_SQUASHFS_LZO is not set
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
CONFIG_ROMFS_FS=y
# CONFIG_ROMFS_BACKED_BY_BLOCK is not set
# CONFIG_ROMFS_BACKED_BY_MTD is not set
CONFIG_ROMFS_BACKED_BY_BOTH=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_ROMFS_ON_MTD=y
# CONFIG_PSTORE is not set
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
# CONFIG_EXOFS_FS is not set
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_HIGHMEM=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_LIST=y
CONFIG_TEST_LIST_SORT=y
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set

#
# RCU Debugging
#
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_BLOCK_EXT_DEVT=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_LKDTM is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MAKE_REQUEST is not set
CONFIG_FAIL_IO_TIMEOUT=y
# CONFIG_FAIL_MMC_REQUEST is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_FAULT_INJECTION_STACKTRACE_FILTER=y
CONFIG_LATENCYTOP=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
# CONFIG_FUNCTION_GRAPH_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
# CONFIG_TRACER_SNAPSHOT is not set
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_DYNAMIC_FTRACE is not set
CONFIG_FUNCTION_PROFILER=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DOUBLEFAULT is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
# CONFIG_DEBUG_BOOT_PARAMS is not set
CONFIG_CPA_DEBUG=y
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_APPRAISE=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
# CONFIG_CRYPTO_CBC is not set
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_DES is not set
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=y
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
CONFIG_VHOST_NET=y
CONFIG_LGUEST=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_PERCPU_RWSEM=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
# CONFIG_LIBCRC32C is not set
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
CONFIG_DDR=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_DRM_TTM is not set
# CONFIG_ISDN_DRV_LOOP is not set
# CONFIG_PCI_ATS is not set

--8P1HSweYDcXXzwPJ--
