Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbaCGCKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 21:10:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:28273 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbaCGCKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 21:10:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,605,1389772800"; 
   d="log'?scan'208";a="487633451"
Date: Fri, 7 Mar 2014 09:32:35 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [torture] INFO: rcu_sched self-detected stall on CPU
Message-ID: <20140307013235.GB8427@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="aVD9QWMuhilNxW9f"
Content-Disposition: inline
In-Reply-To: <20140307012847.GA8427@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aVD9QWMuhilNxW9f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Paul,

Here is another dmesg for the same first bad commit

commit 1f9c26968e1a501f3a839603c9633f21abca65b3
Commit:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
CommitDate: Wed Mar 5 07:49:28 2014 -0800

    torture: Increase stutter-end intensity
    
+---------------------------------------------------------+------------+------------+------------+
|                                                         | 4c79d7d899 | 1f9c26968e | d478a960ed |
+---------------------------------------------------------+------------+------------+------------+
| boot_successes                                          | 203        | 4          | 2          |
| boot_failures                                           | 3          | 22         | 17         |
| WARNING:CPU:PID:at_arch/x86/kernel/cpu/amd.c:init_amd() | 3          | 2          |            |
| backtrace:init_amd                                      | 3          | 2          |            |
| backtrace:warn_slowpath_fmt                             | 3          | 2          |            |
| INFO:rcu_sched_self-detected_stall_on_CPU               | 0          | 20         | 14         |
| EIP_is_at_native_apic_mem_write                         | 0          | 18         | 14         |
| EIP_is_at_native_safe_halt                              | 0          | 19         | 14         |
| INFO:task_blocked_for_more_than_seconds                 | 0          | 19         | 14         |
| EIP_is_at_stutter_wait                                  | 0          | 20         | 14         |
| Kernel_panic-not_syncing:hung_task:blocked_tasks        | 0          | 19         | 14         |
| backtrace:lock_torture_writer                           | 0          | 20         | 14         |
| backtrace:cpu_startup_entry                             | 0          | 6          | 3          |
| backtrace:SYSC_umount                                   | 0          | 14         | 9          |
| backtrace:SyS_oldumount                                 | 0          | 13         | 6          |
| backtrace:watchdog                                      | 0          | 19         | 14         |
| INFO:rcu_sched_detected_stalls_on_CPUs/tasks            | 0          | 3          | 1          |
| backtrace:lru_add_drain_all                             | 0          | 5          | 5          |
| backtrace:SyS_mlockall                                  | 0          | 3          | 4          |
| backtrace:SyS_umount                                    | 0          | 1          | 3          |
| BUG:kernel_boot_hang                                    | 0          | 1          | 2          |
| BUG:kernel_test_hang                                    | 0          | 2          | 1          |
| EIP_is_at__default_send_IPI_dest_field                  | 0          | 2          |            |
| EIP_is_at_slob_page_alloc                               | 0          | 1          |            |
| INFO:lockdep_is_turned_off                              | 0          | 2          |            |
| backtrace:iterate_dir                                   | 0          | 1          |            |
| backtrace:SyS_getdents64                                | 0          | 1          |            |
| EIP_is_at_slob_alloc                                    | 0          | 1          |            |
| EIP_is_at_page_fault                                    | 0          | 1          |            |
| backtrace:SYSC_socketcall                               | 0          | 1          |            |
| backtrace:SyS_socketcall                                | 0          | 1          |            |
| backtrace:SyS_mlock                                     | 0          | 2          | 1          |
+---------------------------------------------------------+------------+------------+------------+

[   23.969075] init: tty3 main process ended, respawning
[   23.985535] init: tty6 main process (264) terminated with status 1
[   23.986111] init: tty6 main process ended, respawning
[   33.470004] INFO: rcu_sched self-detected stall on CPU
[   33.470004] 
[   33.470004] 
[   33.470004] sending NMI to all CPUs:
[   33.470004] NMI backtrace for cpu 0
[   33.470004] CPU: 0 PID: 45 Comm: lock_torture_wr Not tainted 3.14.0-rc5-03765-gd478a96 #1
[   33.470004] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   33.470004] task: 8d3e8000 ti: 8d3ea000 task.ti: 8d3ea000
[   33.470004] EIP: 0060:[<81014de9>] EFLAGS: 00010046 CPU: 0
[   33.470004] EIP is at native_apic_mem_write+0x12/0x14
[   33.470004] EAX: ffff8300 EBX: 00000002 ECX: fffff000 EDX: 00000c00
[   33.470004] ESI: 00000c00 EDI: 03000000 EBP: 8d3ebda4 ESP: 8d3ebda4
[   33.470004]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   33.470004] CR0: 8005003b CR2: 00000000 CR3: 01abb000 CR4: 000006b0
[   33.470004] Stack:
[   33.470004]  8d3ebdb8 81014e68 00000006 00000003 00000002 8d3ebdcc 8101509b 00002710
[   33.470004]  92255a54 00006e36 8d3ebdd4 8101510c 8d3ebde4 81015241 8176c437 81858040
[   33.470004]  8d3ebe20 8105f0d6 81775e21 00000834 ffffff45 ffffff44 00006e36 81046824
[   33.470004] Call Trace:
[   33.470004]  [<81014e68>] __default_send_IPI_dest_field+0x4c/0x51
[   33.470004]  [<8101509b>] default_send_IPI_mask_logical+0x47/0x53
[   33.470004]  [<8101510c>] default_send_IPI_all+0x21/0x32
[   33.470004]  [<81015241>] arch_trigger_all_cpu_backtrace+0x38/0x60
[   33.470004]  [<8105f0d6>] rcu_check_callbacks+0x1a2/0x444
[   33.470004]  [<81046824>] ? account_process_tick+0xfe/0x154
[   33.470004]  [<8102f6a9>] update_process_times+0x2d/0x50
[   33.470004]  [<81067398>] tick_sched_handle+0x30/0x32
[   33.470004]  [<81067923>] tick_sched_timer+0x2e/0x53
[   33.470004]  [<8103d6a5>] __run_hrtimer.isra.16+0x57/0xab
[   33.470004]  [<810678f5>] ? tick_sched_do_timer+0x28/0x28
[   33.470004]  [<8103e02a>] hrtimer_interrupt+0xf0/0x1ec
[   33.470004]  [<81055459>] ? torture_lock_busted_write_unlock+0x5/0x5
[   33.470004]  [<810140ab>] local_apic_timer_interrupt+0x41/0x46
[   33.470004]  [<810142ae>] smp_apic_timer_interrupt+0x20/0x2f
[   33.470004]  [<8154486d>] apic_timer_interrupt+0x2d/0x34
[   33.470004]  [<81055459>] ? torture_lock_busted_write_unlock+0x5/0x5
[   33.470004]  [<810200d8>] ? aes_dec_blk+0x4c0/0xb6a
[   33.470004]  [<81078ce4>] ? stutter_wait+0x1d/0x5a
[   33.470004]  [<8105550e>] lock_torture_writer+0xb5/0xd9
[   33.470004]  [<8103b78c>] kthread+0x8e/0x93
[   33.470004]  [<81544c37>] ret_from_kernel_thread+0x1b/0x28
[   33.470004]  [<8103b6fe>] ? __kthread_parkme+0x50/0x50
[   33.470004] Code: 00 5d c3 55 89 e5 50 9d 8d 74 26 00 5d c3 55 89 e5 fa 90 8d 74 26 00 5d c3 8b 0d 08 38 85 81 55 89 e5 8d 84 08 00 90 ff ff 89 10 <5d> c3 55 8d 48 01 89 e5 53 89 d3 89 d8 ba 08 00 00 00 e8 e8 ee
[   33.480082] NMI backtrace for cpu 1
[   33.480082] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.14.0-rc5-03765-gd478a96 #1
[   33.480082] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   33.480082] task: 80056000 ti: 80058000 task.ti: 80058000
[   33.480082] EIP: 0060:[<8101973a>] EFLAGS: 00200286 CPU: 1
[   33.480082] EIP is at native_safe_halt+0x5/0x7
[   33.480082] EAX: ffffffed EBX: 80058000 ECX: 00200046 EDX: 00200046
[   33.480082] ESI: 00000000 EDI: 80059fbc EBP: 80059f78 ESP: 80059f78
[   33.480082]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   33.480082] CR0: 8005003b CR2: 775c3680 CR3: 13323000 CR4: 000006b0
[   33.480082] DR0: 74238000 DR1: 74238000 DR2: 00000000 DR3: 00000000
[   33.480082] DR6: ffff0ff0 DR7: 00000600
[   33.480082] Stack:
[   33.480082]  80059f80 810078bc 80059f88 81007dd0 80059f94 8104df1c 01000800 80059fa8
[   33.480082]  81012c77 00000001 00000000 80059fbc 00000000 00000000 00200002 00000000
[   33.480082]  00000000 00000000 00000000 00000000 00000000 00000000 0000007b 0000007b
[   33.480082] Call Trace:
[   33.480082]  [<810078bc>] default_idle+0x8/0xb
[   33.480082]  [<81007dd0>] arch_cpu_idle+0x9/0xb
[   33.480082]  [<8104df1c>] cpu_startup_entry+0xb2/0x134
[   33.480082]  [<81012c77>] start_secondary+0x202/0x20b
[   33.480082] Code: 0f 22 e0 5d c3 55 89 e5 0f 09 5d c3 55 89 e5 9c 58 5d c3 55 89 e5 50 9d 5d c3 55 89 e5 fa 5d c3 55 89 e5 fb 5d c3 55 89 e5 fb f4 <5d> c3 55 89 e5 f4 5d c3 55 89 e5 57 89 c7 56 89 ce 53 53 89 55

git bisect start d478a960edf1ea61ca31a07a48a8771f043dba78 0414855fdc4a40da05221fc6062cccbc0c30f169 --
git bisect good 6c2191ad9b6225860eef70a77d300c3d5ad39182  # 21:36     22+      0  Merge 'digsig/for-mimi' into devel-hourly-2014030618
git bisect  bad 8d06d39b2d95c1c3f10ce3d1969e1e381935bbaf  # 21:43      2-      3  Merge 'rcu/rcu/dev' into devel-hourly-2014030618
git bisect good 6845af00920e6b0d6e252c44784aaca3b0d2f42f  # 21:50     26+      0  Merge 'drm-intel/drm-intel-nightly' into devel-hourly-2014030618
git bisect good e5a16a9dbec8844bbd4b35ba52fef5c5f22e1e6a  # 22:05     26+      5  Merge 'ath6kl/ath-next-test' into devel-hourly-2014030618
git bisect good 5c709b0d8abc5dac4d7323fe6e3fdc8e6c4d0e59  # 22:10     26+      5  Merge 'tip/x86/efi' into devel-hourly-2014030618
git bisect good fbe938e4f6c837ca17c284c001b43bb21d5ca389  # 22:12     26+      0  Merge 'arm-soc/next/drivers' into devel-hourly-2014030618
git bisect good b46f358ae5e3558a9072f0354128d5749a584d01  # 22:18     26+      2  rcutorture: Place kvm-test-1-run.sh output into res directory
git bisect good f5604f67fe8cbd6f2088b20b9463f721aa613d4b  # 22:25     26+      0  Merge branch 'torture.2014.02.23a' into HEAD
git bisect good dd35b81c341c685bafd15bc9a6bfa79584e07b07  # 22:30     26+      7  torture: Rename RCU_BUILDONLY to TORTURE_BUILDONLY
git bisect good 8864f0996e8b7f07a536aa07553c4461cd5f4211  # 22:33     26+      0  torture: Make "--dryrun script" output self-sufficient
git bisect good b2d777a6d9d64929b9701f1905fdeda8fc3cb16d  # 22:37     26+      0  rcutorture: Print negatives for SRCU counter wraparound
git bisect good 4c79d7d89902a2e9c96b3db5115af52b3cf94da9  # 22:43     26+      3  torture: Report diagnostics from qemu
git bisect  bad 1f9c26968e1a501f3a839603c9633f21abca65b3  # 22:49      4-      1  torture: Increase stutter-end intensity
# first bad commit: [1f9c26968e1a501f3a839603c9633f21abca65b3] torture: Increase stutter-end intensity
git bisect good 4c79d7d89902a2e9c96b3db5115af52b3cf94da9  # 02:18    180+      3  torture: Report diagnostics from qemu
git bisect  bad d478a960edf1ea61ca31a07a48a8771f043dba78  # 02:18      0-     17  0day head guard for 'devel-hourly-2014030618'
git bisect good 1fa4881b27aa785f667a3cf833a7b688b6d7066e  # 02:31    180+      0  Revert "torture: Increase stutter-end intensity"
git bisect good c3bebc71c4bcdafa24b506adf0c1de3c1f77e2e0  # 05:41    180+      2  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net

Thanks,
Fengguang

--aVD9QWMuhilNxW9f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-xps-2:20140306205202:i386-randconfig-ba1-03062010:3.14.0-rc5-03765-gd478a96:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Linux version 3.14.0-rc5-03765-gd478a96 (kbuild@bay) (gcc ve=
rsion 4.8.1 (Debian 4.8.1-8) ) #1 SMP Thu Mar 6 20:46:44 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[800fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x029fffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12400000-0x125fffff]
[    0.000000]  [mem 0x12400000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x123fffff]
[    0.000000]  [mem 0x10000000-0x123fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12600000-0x13ffdfff]
[    0.000000]  [mem 0x12600000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x01ff6000, 0x01ff6fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
[    0.000000] ACPI: RSDP 0x000FD930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x13FFFF40 000040
[    0.000000] ACPI: SSDT 0x13FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffff8000 (        fee00000)
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x13ffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   Normal zone: 640 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81820 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffff8000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffff7000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 334 pages/cpu @9210f000 s1353032 r0 d15032 =
u1368064
[    0.000000] pcpu-alloc: s1353032 r0 d15032 u1368064 alloc=3D334*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 12111580
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-ba1-03062010/linux-devel:devel-hourly-2014030618/.vmlinu=
z-d478a960edf1ea61ca31a07a48a8771f043dba78-20140306204706-5-xps branch=3Dli=
nux-devel/devel-hourly-2014030618 BOOT_IMAGE=3D/kernel/i386-randconfig-ba1-=
03062010/d478a960edf1ea61ca31a07a48a8771f043dba78/vmlinuz-3.14.0-rc5-03765-=
gd478a96
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 278792K/327280K available (5397K kernel code, 662K r=
wdata, 3068K rodata, 1824K init, 5284K bss, 48488K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff11000 - 0xfffff000   ( 952 kB)
[    0.000000]     vmalloc : 0x947fe000 - 0xfff0f000   (1719 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x93ffe000   ( 319 MB)
[    0.000000]       .init : 0x818ed000 - 0x81ab5000   (1824 kB)
[    0.000000]       .data : 0x81545a46 - 0x818eb880   (3735 kB)
[    0.000000]       .text : 0x81000000 - 0x81545a46   (5398 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3D80090000 soft=3D80092000
[    0.000000] ACPI: Core revision 20140214
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Linux version 3.14.0-rc5-03765-gd478a96 (kbuild@bay) (gcc ve=
rsion 4.8.1 (Debian 4.8.1-8) ) #1 SMP Thu Mar 6 20:46:44 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[800fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x029fffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12400000-0x125fffff]
[    0.000000]  [mem 0x12400000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x123fffff]
[    0.000000]  [mem 0x10000000-0x123fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12600000-0x13ffdfff]
[    0.000000]  [mem 0x12600000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x01ff6000, 0x01ff6fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
[    0.000000] ACPI: RSDP 0x000FD930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x13FFFF40 000040
[    0.000000] ACPI: SSDT 0x13FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffff8000 (        fee00000)
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x13ffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   Normal zone: 640 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81820 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffff8000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffff7000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 334 pages/cpu @9210f000 s1353032 r0 d15032 =
u1368064
[    0.000000] pcpu-alloc: s1353032 r0 d15032 u1368064 alloc=3D334*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 12111580
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-ba1-03062010/linux-devel:devel-hourly-2014030618/.vmlinu=
z-d478a960edf1ea61ca31a07a48a8771f043dba78-20140306204706-5-xps branch=3Dli=
nux-devel/devel-hourly-2014030618 BOOT_IMAGE=3D/kernel/i386-randconfig-ba1-=
03062010/d478a960edf1ea61ca31a07a48a8771f043dba78/vmlinuz-3.14.0-rc5-03765-=
gd478a96
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 278792K/327280K available (5397K kernel code, 662K r=
wdata, 3068K rodata, 1824K init, 5284K bss, 48488K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff11000 - 0xfffff000   ( 952 kB)
[    0.000000]     vmalloc : 0x947fe000 - 0xfff0f000   (1719 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x93ffe000   ( 319 MB)
[    0.000000]       .init : 0x818ed000 - 0x81ab5000   (1824 kB)
[    0.000000]       .data : 0x81545a46 - 0x818eb880   (3735 kB)
[    0.000000]       .text : 0x81000000 - 0x81545a46   (5398 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3D80090000 soft=3D80092000
[    0.000000] ACPI: Core revision 20140214
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3807 kB
[    0.000000]  memory used by lock dependency info: 3807 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ODEBUG: 12 of 12 active objects replaced
[    0.000000] ODEBUG: 12 of 12 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2925.852 MHz processor
[    0.000000] tsc: Detected 2925.852 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.020000] Calibrating delay loop (skipped) preset value..=20
[    0.020000] Calibrating delay loop (skipped) preset value.. 5851.70 Bogo=
MIPS (lpj=3D29258520)
5851.70 BogoMIPS (lpj=3D29258520)
[    0.020000] pid_max: default: 4096 minimum: 301
[    0.020000] pid_max: default: 4096 minimum: 301
[    0.020000] Mount-cache hash table entries: 512
[    0.020000] Mount-cache hash table entries: 512
[    0.020000] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020000] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.020000] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020000] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.020000] Freeing SMP alternatives memory: 8K (81ab5000 - 81ab7000)
[    0.020000] Freeing SMP alternatives memory: 8K (81ab5000 - 81ab7000)
[    0.020359] Getting VERSION: 50014
[    0.020359] Getting VERSION: 50014
[    0.020954] Getting VERSION: 50014
[    0.020954] Getting VERSION: 50014
[    0.021591] Getting ID: 0
[    0.021591] Getting ID: 0
[    0.022048] Getting ID: f000000
[    0.022048] Getting ID: f000000
[    0.022591] Getting LVT0: 8700
[    0.022591] Getting LVT0: 8700
[    0.023145] Getting LVT1: 8400
[    0.023145] Getting LVT1: 8400
[    0.023733] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.023733] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.024709] enabled ExtINT on CPU#0
[    0.024709] enabled ExtINT on CPU#0
[    0.026105] ENABLING IO-APIC IRQs
[    0.026105] ENABLING IO-APIC IRQs
[    0.026706] init IO_APIC IRQs
[    0.026706] init IO_APIC IRQs
[    0.027198]  apic 0 pin 0 not connected
[    0.027198]  apic 0 pin 0 not connected
[    0.027924] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.027924] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.029269] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.029269] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.030021] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.030021] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.031357] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.031357] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.032676] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.032676] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.034133] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.034133] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.035470] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.035470] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.036890] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.036890] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.038239] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.038239] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.040019] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.040019] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.041418] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.041418] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.042768] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.042768] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.044155] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.044155] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.045583] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.045583] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.046945] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.046945] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.048407]  apic 0 pin 16 not connected
[    0.048407]  apic 0 pin 16 not connected
[    0.049034]  apic 0 pin 17 not connected
[    0.049034]  apic 0 pin 17 not connected
[    0.050004]  apic 0 pin 18 not connected
[    0.050004]  apic 0 pin 18 not connected
[    0.050730]  apic 0 pin 19 not connected
[    0.050730]  apic 0 pin 19 not connected
[    0.051393]  apic 0 pin 20 not connected
[    0.051393]  apic 0 pin 20 not connected
[    0.052030]  apic 0 pin 21 not connected
[    0.052030]  apic 0 pin 21 not connected
[    0.052716]  apic 0 pin 22 not connected
[    0.052716]  apic 0 pin 22 not connected
[    0.053440]  apic 0 pin 23 not connected
[    0.053440]  apic 0 pin 23 not connected
[    0.054199] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.054199] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.055602] smpboot: CPU0:=20
[    0.055602] smpboot: CPU0: GenuineIntel GenuineIntel Common KVM processo=
rCommon KVM processor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.057497] Using local APIC timer interrupts.
[    0.057497] calibrating APIC timer ...
[    0.057497] Using local APIC timer interrupts.
[    0.057497] calibrating APIC timer ...
[    0.060000] ... lapic delta =3D 6247816
[    0.060000] ... lapic delta =3D 6247816
[    0.060000] ... PM-Timer delta =3D 357778
[    0.060000] ... PM-Timer delta =3D 357778
[    0.060000] ... PM-Timer result ok
[    0.060000] ... PM-Timer result ok
[    0.060000] ..... delta 6247816
[    0.060000] ..... delta 6247816
[    0.060000] ..... mult: 268341653
[    0.060000] ..... mult: 268341653
[    0.060000] ..... calibration result: 9996505
[    0.060000] ..... calibration result: 9996505
[    0.060000] ..... CPU clock speed is 2924.4442 MHz.
[    0.060000] ..... CPU clock speed is 2924.4442 MHz.
[    0.060000] ..... host bus clock speed is 999.6505 MHz.
[    0.060000] ..... host bus clock speed is 999.6505 MHz.
[    0.060000] Performance Events:=20
[    0.060000] Performance Events: no PMU driver, software events only.
no PMU driver, software events only.
[    0.060000] CPU 1 irqstacks, hard=3D8006a000 soft=3D8006c000
[    0.060000] CPU 1 irqstacks, hard=3D8006a000 soft=3D8006c000
[    0.060000] x86: Booting SMP configuration:
[    0.060000] x86: Booting SMP configuration:
[    0.060000] .... node  #0, CPUs: =20
[    0.060000] .... node  #0, CPUs:         #1 #1
[    0.010000] Initializing CPU#1
[    0.020000] kvm-clock: cpu 1, msr 0:13ffd041, secondary cpu clock
[    0.020000] masked ExtINT on CPU#1
[    0.067724] x86: Booted up 1 node, 2 CPUs
[    0.067724] x86: Booted up 1 node, 2 CPUs
[    0.067670] KVM setup async PF for cpu 1
[    0.067670] KVM setup async PF for cpu 1
[    0.067670] kvm-stealtime: cpu 1, msr 1225f580
[    0.067670] kvm-stealtime: cpu 1, msr 1225f580
[    0.069796] ----------------
[    0.069796] ----------------
[    0.070003] | NMI testsuite:
[    0.070003] | NMI testsuite:
[    0.070476] --------------------
[    0.070476] --------------------
[    0.071025]   remote IPI:
[    0.071025]   remote IPI:  ok  |  ok  |

[    0.100235]    local IPI:
[    0.100235]    local IPI:  ok  |  ok  |

[    0.160033] --------------------
[    0.160033] --------------------
[    0.160911] Good, all   2 testcases passed! |
[    0.160911] Good, all   2 testcases passed! |
[    0.161989] ---------------------------------
[    0.161989] ---------------------------------
[    0.163162] smpboot: Total of 2 processors activated (11703.40 BogoMIPS)
[    0.163162] smpboot: Total of 2 processors activated (11703.40 BogoMIPS)
[    0.165150] devtmpfs: initialized
[    0.165150] devtmpfs: initialized
[    0.165150] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.165150] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.165150] regulator-dummy: no parameters
[    0.165150] regulator-dummy: no parameters
[    0.165150] NET: Registered protocol family 16
[    0.165150] NET: Registered protocol family 16
[    0.170360] cpuidle: using governor menu
[    0.170360] cpuidle: using governor menu
[    0.171322] ACPI: bus type PCI registered
[    0.171322] ACPI: bus type PCI registered
[    0.172043] dca service started, version 1.12.1
[    0.172043] dca service started, version 1.12.1
[    0.172994] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.172994] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.175014] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.175014] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.176446] PCI: Using configuration type 1 for base access
[    0.176446] PCI: Using configuration type 1 for base access
[    0.178101] ACPI: Added _OSI(Module Device)
[    0.178101] ACPI: Added _OSI(Module Device)
[    0.178101] ACPI: Added _OSI(Processor Device)
[    0.178101] ACPI: Added _OSI(Processor Device)
[    0.180012] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.180012] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.180793] ACPI: Added _OSI(Processor Aggregator Device)
[    0.180793] ACPI: Added _OSI(Processor Aggregator Device)
[    0.193178] ACPI: Interpreter enabled
[    0.193178] ACPI: Interpreter enabled
[    0.194041] ACPI: (supports S0)
[    0.194041] ACPI: (supports S0)
[    0.194709] ACPI: Using IOAPIC for interrupt routing
[    0.194709] ACPI: Using IOAPIC for interrupt routing
[    0.195548] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.195548] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.206387] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.206387] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.207433] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments]
[    0.207433] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments]
[    0.208619] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.208619] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.210244] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.210244] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.212166] PCI host bridge to bus 0000:00
[    0.212166] PCI host bridge to bus 0000:00
[    0.212834] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.212834] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.213736] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.213736] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.214741] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.214741] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.215751] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.215751] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.217274] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.217274] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.218779] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.218779] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.220560] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.220560] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.222321] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.222321] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.225820] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.225820] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.228011] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.228011] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.229331] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.229331] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.230028] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.230028] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.232558] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.232558] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.237103] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.237103] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.241801] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.241801] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.249056] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.249056] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.250538] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.250538] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.252477] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.252477] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.254573] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.254573] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.260922] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.260922] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.262300] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.262300] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.264207] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.264207] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.266015] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.266015] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.272300] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.272300] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.274264] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.274264] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.276106] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.276106] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.282259] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.282259] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.284239] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.284239] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.286200] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.286200] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.292261] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.292261] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.294179] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.294179] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.295972] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.295972] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.301833] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.301833] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.303777] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.303777] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.305613] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.305613] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.311929] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.311929] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.314013] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.314013] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.315989] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.315989] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.322286] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.322286] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.323759] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.323759] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.328095] pci_bus 0000:00: on NUMA node 0
[    0.328095] pci_bus 0000:00: on NUMA node 0
[    0.330471] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.330471] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.331784] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.331784] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.333060] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.333060] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.334424] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.334424] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.335521] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.335521] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.337304] ACPI:=20
[    0.337304] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    0.338675] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.338675] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.339976] vgaarb: loaded
[    0.339976] vgaarb: loaded
[    0.340003] vgaarb: bridge control possible 0000:00:02.0
[    0.340003] vgaarb: bridge control possible 0000:00:02.0
[    0.341077] sta2x11_scr_init
[    0.341077] sta2x11_scr_init
[    0.341077] sta2x11_apb_soc_regs_init
[    0.341077] sta2x11_apb_soc_regs_init
[    0.341235] sta2x11_sctl_init
[    0.341235] sta2x11_sctl_init
[    0.341748] sta2x11_apbreg_init
[    0.341748] sta2x11_apbreg_init
[    0.342515] pps_core: LinuxPPS API ver. 1 registered
[    0.342515] pps_core: LinuxPPS API ver. 1 registered
[    0.343343] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.343343] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.344865] PTP clock support registered
[    0.344865] PTP clock support registered
[    0.345530] EDAC MC: Ver: 3.0.0
[    0.345530] EDAC MC: Ver: 3.0.0
[    0.346264] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[    0.346264] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[    0.347365] Advanced Linux Sound Architecture Driver Initialized.
[    0.347365] Advanced Linux Sound Architecture Driver Initialized.
[    0.350007] PCI: Using ACPI for IRQ routing
[    0.350007] PCI: Using ACPI for IRQ routing
[    0.350709] PCI: pci_cache_line_size set to 64 bytes
[    0.350709] PCI: pci_cache_line_size set to 64 bytes
[    0.351701] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.351701] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.352704] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.352704] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.354377] hpet0: at MMIO 0xfed00000, IRQs
[    0.354377] hpet0: at MMIO 0xfed00000, IRQs 2 2, 8, 8, 0, 0

[    0.355330] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.355330] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.360127] Switched to clocksource kvm-clock
[    0.360127] Switched to clocksource kvm-clock
[    0.361078] pnp: PnP ACPI init
[    0.361078] pnp: PnP ACPI init
[    0.361636] ACPI: bus type PNP registered
[    0.361636] ACPI: bus type PNP registered
[    0.362358] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.362358] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.363715] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.363715] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.364830] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.364830] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.366230] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.366230] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.367343] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.367343] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.368756] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.368756] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.370527] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.370527] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.372187] pnp 00:03: [dma 2]
[    0.372187] pnp 00:03: [dma 2]
[    0.372718] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.372718] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.373879] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.373879] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.375196] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.375196] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.376351] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.376351] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.377668] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.377668] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.379228] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.379228] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.381369] pnp: PnP ACPI: found 7 devices
[    0.381369] pnp: PnP ACPI: found 7 devices
[    0.382096] ACPI: bus type PNP unregistered
[    0.382096] ACPI: bus type PNP unregistered
[    0.382796] INFO_MDMA: LNW DMA Driver Version 1.1.0
[    0.382796] INFO_MDMA: LNW DMA Driver Version 1.1.0
[    0.418710] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.418710] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.419629] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.419629] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.420560] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.420560] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.421642] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.421642] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.423001] NET: Registered protocol family 1
[    0.423001] NET: Registered protocol family 1
[    0.423747] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.423747] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.424721] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.424721] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.425680] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.425680] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.426845] pci 0000:00:02.0: Boot video device
[    0.426845] pci 0000:00:02.0: Boot video device
[    0.428131] PCI: CLS 0 bytes, default 64
[    0.428131] PCI: CLS 0 bytes, default 64
[    0.429219] Unpacking initramfs...
[    0.429219] Unpacking initramfs...
[    1.393241] Freeing initrd memory: 24852K (927ab000 - 93ff0000)
[    1.393241] Freeing initrd memory: 24852K (927ab000 - 93ff0000)
[    1.394669] sta2x11_mfd_init
[    1.394669] sta2x11_mfd_init
[    1.395932] microcode: no support for this CPU vendor
[    1.395932] microcode: no support for this CPU vendor
[    1.397543] Scanning for low memory corruption every 60 seconds
[    1.397543] Scanning for low memory corruption every 60 seconds
[    1.399352] cryptomgr_test (22) used greatest stack depth: 7280 bytes le=
ft
[    1.399352] cryptomgr_test (22) used greatest stack depth: 7280 bytes le=
ft
[    1.401161] cryptomgr_test (24) used greatest stack depth: 7276 bytes le=
ft
[    1.401161] cryptomgr_test (24) used greatest stack depth: 7276 bytes le=
ft
[    1.401783] PCLMULQDQ-NI instructions are not detected.
[    1.401783] PCLMULQDQ-NI instructions are not detected.
[    1.401787] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    1.401787] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    1.402456] Initializing RT-Tester: OK
[    1.402456] Initializing RT-Tester: OK
[    1.402475] spin_lock-torture:--- Start of test: nwriters_stress=3D4 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    1.402475] spin_lock-torture:--- Start of test: nwriters_stress=3D4 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    1.402477] spin_lock-torture: Creating torture_shuffle task
[    1.402477] spin_lock-torture: Creating torture_shuffle task
[    1.402550] spin_lock-torture: Creating torture_stutter task
[    1.402550] spin_lock-torture: Creating torture_stutter task
[    1.402589] spin_lock-torture: torture_shuffle task started
[    1.402589] spin_lock-torture: torture_shuffle task started
[    1.402603] spin_lock-torture: Creating lock_torture_writer task
[    1.402603] spin_lock-torture: Creating lock_torture_writer task
[    1.402648] spin_lock-torture: torture_stutter task started
[    1.402648] spin_lock-torture: torture_stutter task started
[    1.402662] spin_lock-torture: Creating lock_torture_writer task
[    1.402662] spin_lock-torture: Creating lock_torture_writer task
[    1.402700] spin_lock-torture: lock_torture_writer task started
[    1.402700] spin_lock-torture: lock_torture_writer task started
[    1.402800] spin_lock-torture: Creating lock_torture_writer task
[    1.402800] spin_lock-torture: Creating lock_torture_writer task
[    1.402872] spin_lock-torture: lock_torture_writer task started
[    1.402872] spin_lock-torture: lock_torture_writer task started
[    1.402888] spin_lock-torture: Creating lock_torture_writer task
[    1.402888] spin_lock-torture: Creating lock_torture_writer task
[    1.402929] spin_lock-torture: lock_torture_writer task started
[    1.402929] spin_lock-torture: lock_torture_writer task started
[    1.402945] spin_lock-torture: Creating lock_torture_stats task
[    1.402945] spin_lock-torture: Creating lock_torture_stats task
[    1.402989] spin_lock-torture: lock_torture_writer task started
[    1.402989] spin_lock-torture: lock_torture_writer task started
[    1.403245] futex hash table entries: 16 (order: -2, 1024 bytes)
[    1.403245] futex hash table entries: 16 (order: -2, 1024 bytes)
[    1.403355] spin_lock-torture: lock_torture_stats task started
[    1.403355] spin_lock-torture: lock_torture_stats task started
[    1.403861] ROMFS MTD (C) 2007 Red Hat, Inc.
[    1.403861] ROMFS MTD (C) 2007 Red Hat, Inc.
[    1.403923] fuse init (API version 7.22)
[    1.403923] fuse init (API version 7.22)
[    1.407748] test_string_helpers: Running tests...
[    1.407748] test_string_helpers: Running tests...
[    1.408410] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    1.408410] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    1.408412] crc32: self tests passed, processed 225944 bytes in 266080 n=
sec
[    1.408412] crc32: self tests passed, processed 225944 bytes in 266080 n=
sec
[    1.408687] crc32c: CRC_LE_BITS =3D 64
[    1.408687] crc32c: CRC_LE_BITS =3D 64
[    1.408688] crc32c: self tests passed, processed 225944 bytes in 131322 =
nsec
[    1.408688] crc32c: self tests passed, processed 225944 bytes in 131322 =
nsec
[    1.636995] crc32_combine: 8373 self tests passed
[    1.636995] crc32_combine: 8373 self tests passed
[    1.876977] crc32c_combine: 8373 self tests passed
[    1.876977] crc32c_combine: 8373 self tests passed
[    1.879035] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    1.879035] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    1.880329] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    1.880329] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    1.882135] vmlfb: initializing
[    1.882135] vmlfb: initializing
[    1.882914] Could not find Carillo Ranch MCH device.
[    1.882914] Could not find Carillo Ranch MCH device.
[    1.884112] no IO addresses supplied
[    1.884112] no IO addresses supplied
[    1.885064] hgafb: HGA card not detected.
[    1.885064] hgafb: HGA card not detected.
[    1.886004] hgafb: probe of hgafb.0 failed with error -22
[    1.886004] hgafb: probe of hgafb.0 failed with error -22
[    1.887970] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    1.887970] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    1.890508] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    1.890508] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    1.892258] ACPI: Power Button [PWRF]
[    1.892258] ACPI: Power Button [PWRF]
[    1.893620] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    1.893620] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    1.896879] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    1.896879] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    1.898300] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:3)
[    1.898300] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:3)
[    1.903032] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    1.903032] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    1.904205] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:3)
[    1.904205] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:3)
[    1.908880] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    1.908880] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    1.916582] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    1.916582] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    1.958722] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.958722] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.982573] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    1.982573] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    1.985487] STMicroelectronics ASC driver initialized
[    1.985487] STMicroelectronics ASC driver initialized
[    1.987244] serial: Freescale lpuart driver
[    1.987244] serial: Freescale lpuart driver
[    1.988323] Initializing Nozomi driver 2.1d
[    1.988323] Initializing Nozomi driver 2.1d
[    1.989644] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    1.989644] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    1.991405] ac.o: No PCI boards found.
[    1.991405] ac.o: No PCI boards found.
[    1.992328] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    1.992328] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    1.994152] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    1.994152] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    1.995898] Non-volatile memory driver v1.3
[    1.995898] Non-volatile memory driver v1.3
[    1.996939] toshiba: not a supported Toshiba laptop
[    1.996939] toshiba: not a supported Toshiba laptop
[    1.998283] ppdev: user-space parallel port driver
[    1.998283] ppdev: user-space parallel port driver
[    1.999540] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    1.999540] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    2.001318] platform pc8736x_gpio.0: no device found
[    2.001318] platform pc8736x_gpio.0: no device found
[    2.002583] nsc_gpio initializing
[    2.002583] nsc_gpio initializing
[    2.003399] smapi::smapi_init, ERROR invalid usSmapiID
[    2.003399] smapi::smapi_init, ERROR invalid usSmapiID
[    2.004666] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    2.004666] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    2.006929] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    2.006929] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    2.008696] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    2.008696] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    2.010368] Linux agpgart interface v0.103
[    2.010368] Linux agpgart interface v0.103
[    2.012360] [drm] Initialized drm 1.1.0 20060810
[    2.012360] [drm] Initialized drm 1.1.0 20060810
[    2.013844] [drm] radeon kernel modesetting enabled.
[    2.013844] [drm] radeon kernel modesetting enabled.
[    2.015501] parport_pc 00:04: reported by Plug and Play ACPI
[    2.015501] parport_pc 00:04: reported by Plug and Play ACPI
[    2.017001] parport0: PC-style at 0x378
[    2.017001] parport0: PC-style at 0x378, irq 7, irq 7 [ [PCSPPPCSPP(,...=
)(,...)]
]
[    2.019258] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    2.019258] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    2.020969] dummy-irq: no IRQ given.  Use irq=3DN
[    2.020969] dummy-irq: no IRQ given.  Use irq=3DN
[    2.022132] Phantom Linux Driver, version n0.9.8, init OK
[    2.022132] Phantom Linux Driver, version n0.9.8, init OK
[    2.024816] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    2.024816] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    2.026209] Could not find PAR responsible for SC520CDP Flash Bank #1
[    2.026209] Could not find PAR responsible for SC520CDP Flash Bank #1
[    2.027244] Trying default address 0x8c00000
[    2.027244] Trying default address 0x8c00000
[    2.027952] SC520 CDP flash device: 0x800000 at 0x8800000
[    2.027952] SC520 CDP flash device: 0x800000 at 0x8800000
[    2.028836] Failed to ioremap_nocache
[    2.028836] Failed to ioremap_nocache
[    2.029466] slram: not enough parameters.
[    2.029466] slram: not enough parameters.
[    2.030212] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel =
Networks.
[    2.030212] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel =
Networks.
[    2.031543] pmc551: not detected
[    2.031543] pmc551: not detected
[    2.066954] No valid DiskOnChip devices found
[    2.066954] No valid DiskOnChip devices found
[    2.077557] fb1: cfag12864b frame buffer device
[    2.077557] fb1: cfag12864b frame buffer device
[    2.078793] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    2.078793] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    2.081971] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.081971] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.083260] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.083260] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.084618] parport0: no more devices allowed
[    2.084618] parport0: no more devices allowed
[    2.160212] mousedev: PS/2 mouse device common for all mice
[    2.160212] mousedev: PS/2 mouse device common for all mice
[    2.161613] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    2.161613] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    2.164780] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    2.164780] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    2.166904] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    2.166904] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    2.169571] parport0: no more devices allowed
[    2.169571] parport0: no more devices allowed
[    2.170728] walkera0701: failed to register parport device
[    2.170728] walkera0701: failed to register parport device
[    2.172291] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    2.172291] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    2.174150] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    2.174150] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    2.175795] evbug: Connected device: input3 (PC Speaker at isa0061/input=
0)
[    2.175795] evbug: Connected device: input3 (PC Speaker at isa0061/input=
0)
[    2.177810] ideapad_slidebar: DMI does not match
[    2.177810] ideapad_slidebar: DMI does not match
[    2.179167] rtc_cmos 00:00: RTC can wake from S4
[    2.179167] rtc_cmos 00:00: RTC can wake from S4
[    2.180720] rtc (null): alarm rollover: day
[    2.180720] rtc (null): alarm rollover: day
[    2.181871] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    2.181871] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    2.183459] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    2.183459] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    2.186177] i2c /dev entries driver
[    2.186177] i2c /dev entries driver
[    2.187496] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[    2.187496] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[    2.189775] i2c-parport: adapter type unspecified
[    2.189775] i2c-parport: adapter type unspecified
[    2.191376] pps pps0: new PPS source ktimer
[    2.191376] pps pps0: new PPS source ktimer
[    2.192467] pps pps0: ktimer PPS source registered
[    2.192467] pps pps0: ktimer PPS source registered
[    2.193684] pps_ldisc: PPS line discipline registered
[    2.193684] pps_ldisc: PPS line discipline registered
[    2.194832] pps_parport: parallel port PPS client
[    2.194832] pps_parport: parallel port PPS client
[    2.196029] parport0: no more devices allowed
[    2.196029] parport0: no more devices allowed
[    2.197092] pps_parport: couldn't register with parport0
[    2.197092] pps_parport: couldn't register with parport0
[    2.198653] Driver for 1-wire Dallas network protocol.
[    2.198653] Driver for 1-wire Dallas network protocol.
[    2.200331] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    2.200331] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    2.201939] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    2.201939] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    2.560090] w83793: Detection failed at check vendor id
[    2.560090] w83793: Detection failed at check vendor id
[    2.620090] w83793: Detection failed at check vendor id
[    2.620090] w83793: Detection failed at check vendor id
[    2.680108] w83793: Detection failed at check vendor id
[    2.680108] w83793: Detection failed at check vendor id
[    2.740110] w83793: Detection failed at check vendor id
[    2.740110] w83793: Detection failed at check vendor id
[    2.780116] i2c i2c-0: w83795: Detection failed at addr 0x2c, check bank
[    2.780116] i2c i2c-0: w83795: Detection failed at addr 0x2c, check bank
[    2.820123] i2c i2c-0: w83795: Detection failed at addr 0x2d, check bank
[    2.820123] i2c i2c-0: w83795: Detection failed at addr 0x2d, check bank
[    2.860185] i2c i2c-0: w83795: Detection failed at addr 0x2e, check bank
[    2.860185] i2c i2c-0: w83795: Detection failed at addr 0x2e, check bank
[    2.900098] i2c i2c-0: w83795: Detection failed at addr 0x2f, check bank
[    2.900098] i2c i2c-0: w83795: Detection failed at addr 0x2f, check bank
[    3.140126] detect failed, chip not detected!
[    3.140126] detect failed, chip not detected!
[    3.220116] detect failed, chip not detected!
[    3.220116] detect failed, chip not detected!
[    3.300125] detect failed, chip not detected!
[    3.300125] detect failed, chip not detected!
[    3.380083] detect failed, chip not detected!
[    3.380083] detect failed, chip not detected!
[    3.460082] detect failed, chip not detected!
[    3.460082] detect failed, chip not detected!
[    3.540093] detect failed, chip not detected!
[    3.540093] detect failed, chip not detected!
[    3.620083] detect failed, chip not detected!
[    3.620083] detect failed, chip not detected!
[    3.700167] detect failed, chip not detected!
[    3.700167] detect failed, chip not detected!
[    3.780100] detect failed, chip not detected!
[    3.780100] detect failed, chip not detected!
[    3.820161] i2c i2c-0: ADM1025 detection failed at 0x2c
[    3.820161] i2c i2c-0: ADM1025 detection failed at 0x2c
[    3.860072] i2c i2c-0: ADM1025 detection failed at 0x2d
[    3.860072] i2c i2c-0: ADM1025 detection failed at 0x2d
[    3.900186] i2c i2c-0: ADM1025 detection failed at 0x2e
[    3.900186] i2c i2c-0: ADM1025 detection failed at 0x2e
[    3.960068] i2c i2c-0: Detecting device at 0,0x2c with COMPANY: 0xff and=
 VERSTEP: 0xff
[    3.960068] i2c i2c-0: Detecting device at 0,0x2c with COMPANY: 0xff and=
 VERSTEP: 0xff
[    3.961909] i2c i2c-0: Autodetecting device at 0,0x2c...
[    3.961909] i2c i2c-0: Autodetecting device at 0,0x2c...
[    3.963230] i2c i2c-0: Autodetection failed
[    3.963230] i2c i2c-0: Autodetection failed
[    4.020111] i2c i2c-0: Detecting device at 0,0x2d with COMPANY: 0xff and=
 VERSTEP: 0xff
[    4.020111] i2c i2c-0: Detecting device at 0,0x2d with COMPANY: 0xff and=
 VERSTEP: 0xff
[    4.021430] i2c i2c-0: Autodetecting device at 0,0x2d...
[    4.021430] i2c i2c-0: Autodetecting device at 0,0x2d...
[    4.022414] i2c i2c-0: Autodetection failed
[    4.022414] i2c i2c-0: Autodetection failed
[    4.080149] i2c i2c-0: Detecting device at 0,0x2e with COMPANY: 0xff and=
 VERSTEP: 0xff
[    4.080149] i2c i2c-0: Detecting device at 0,0x2e with COMPANY: 0xff and=
 VERSTEP: 0xff
[    4.081492] i2c i2c-0: Autodetecting device at 0,0x2e...
[    4.081492] i2c i2c-0: Autodetecting device at 0,0x2e...
[    4.082351] i2c i2c-0: Autodetection failed
[    4.082351] i2c i2c-0: Autodetection failed
[    4.300146]  (null): Wrong manufacturer ID. Got 255, expected 65
[    4.300146]  (null): Wrong manufacturer ID. Got 255, expected 65
[    4.340164]  (null): Wrong manufacturer ID. Got 255, expected 65
[    4.340164]  (null): Wrong manufacturer ID. Got 255, expected 65
[    4.380152]  (null): Wrong manufacturer ID. Got 255, expected 65
[    4.380152]  (null): Wrong manufacturer ID. Got 255, expected 65
[    4.760086] applesmc: supported laptop not found!
[    4.760086] applesmc: supported laptop not found!
[    4.761068] applesmc: driver init failed (ret=3D-19)!
[    4.761068] applesmc: driver init failed (ret=3D-19)!
[    5.400066]  (null): Unknown chip type, skipping
[    5.400066]  (null): Unknown chip type, skipping
[    5.440071]  (null): Unknown chip type, skipping
[    5.440071]  (null): Unknown chip type, skipping
[    6.380078] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[    6.380078] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[    6.520067] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[    6.520067] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[    6.660068] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[    6.660068] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[    7.580092] i2c i2c-0: LM83 detection failed at 0x18
[    7.580092] i2c i2c-0: LM83 detection failed at 0x18
[    7.620085] i2c i2c-0: LM83 detection failed at 0x19
[    7.620085] i2c i2c-0: LM83 detection failed at 0x19
[    7.660079] i2c i2c-0: LM83 detection failed at 0x1a
[    7.660079] i2c i2c-0: LM83 detection failed at 0x1a
[    7.700073] i2c i2c-0: LM83 detection failed at 0x29
[    7.700073] i2c i2c-0: LM83 detection failed at 0x29
[    7.740085] i2c i2c-0: LM83 detection failed at 0x2a
[    7.740085] i2c i2c-0: LM83 detection failed at 0x2a
[    7.780081] i2c i2c-0: LM83 detection failed at 0x2b
[    7.780081] i2c i2c-0: LM83 detection failed at 0x2b
[    7.820084] i2c i2c-0: LM83 detection failed at 0x4c
[    7.820084] i2c i2c-0: LM83 detection failed at 0x4c
[    7.860077] i2c i2c-0: LM83 detection failed at 0x4d
[    7.860077] i2c i2c-0: LM83 detection failed at 0x4d
[    7.900070] i2c i2c-0: LM83 detection failed at 0x4e
[    7.900070] i2c i2c-0: LM83 detection failed at 0x4e
[    8.000083] i2c i2c-0: Unsupported chip at 0x18 (man_id=3D0xFF, chip_id=
=3D0xFF)
[    8.000083] i2c i2c-0: Unsupported chip at 0x18 (man_id=3D0xFF, chip_id=
=3D0xFF)
[    8.100070] i2c i2c-0: Unsupported chip at 0x19 (man_id=3D0xFF, chip_id=
=3D0xFF)
[    8.100070] i2c i2c-0: Unsupported chip at 0x19 (man_id=3D0xFF, chip_id=
=3D0xFF)
[    8.200068] i2c i2c-0: Unsupported chip at 0x1a (man_id=3D0xFF, chip_id=
=3D0xFF)
[    8.200068] i2c i2c-0: Unsupported chip at 0x1a (man_id=3D0xFF, chip_id=
=3D0xFF)
[    8.300091] i2c i2c-0: Unsupported chip at 0x29 (man_id=3D0xFF, chip_id=
=3D0xFF)
[    8.300091] i2c i2c-0: Unsupported chip at 0x29 (man_id=3D0xFF, chip_id=
=3D0xFF)
[    8.400076] i2c i2c-0: Unsupported chip at 0x2a (man_id=3D0xFF, chip_id=
=3D0xFF)
[    8.400076] i2c i2c-0: Unsupported chip at 0x2a (man_id=3D0xFF, chip_id=
=3D0xFF)
[    8.500079] i2c i2c-0: Unsupported chip at 0x2b (man_id=3D0xFF, chip_id=
=3D0xFF)
[    8.500079] i2c i2c-0: Unsupported chip at 0x2b (man_id=3D0xFF, chip_id=
=3D0xFF)
[    8.600068] i2c i2c-0: Unsupported chip at 0x48 (man_id=3D0xFF, chip_id=
=3D0xFF)
[    8.600068] i2c i2c-0: Unsupported chip at 0x48 (man_id=3D0xFF, chip_id=
=3D0xFF)
[    8.700064] i2c i2c-0: Unsupported chip at 0x49 (man_id=3D0xFF, chip_id=
=3D0xFF)
[    8.700064] i2c i2c-0: Unsupported chip at 0x49 (man_id=3D0xFF, chip_id=
=3D0xFF)
[    8.800062] i2c i2c-0: Unsupported chip at 0x4a (man_id=3D0xFF, chip_id=
=3D0xFF)
[    8.800062] i2c i2c-0: Unsupported chip at 0x4a (man_id=3D0xFF, chip_id=
=3D0xFF)
[    8.900059] i2c i2c-0: Unsupported chip at 0x4b (man_id=3D0xFF, chip_id=
=3D0xFF)
[    8.900059] i2c i2c-0: Unsupported chip at 0x4b (man_id=3D0xFF, chip_id=
=3D0xFF)
[    9.000071] i2c i2c-0: Unsupported chip at 0x4c (man_id=3D0xFF, chip_id=
=3D0xFF)
[    9.000071] i2c i2c-0: Unsupported chip at 0x4c (man_id=3D0xFF, chip_id=
=3D0xFF)
[    9.100059] i2c i2c-0: Unsupported chip at 0x4d (man_id=3D0xFF, chip_id=
=3D0xFF)
[    9.100059] i2c i2c-0: Unsupported chip at 0x4d (man_id=3D0xFF, chip_id=
=3D0xFF)
[    9.200090] i2c i2c-0: Unsupported chip at 0x4e (man_id=3D0xFF, chip_id=
=3D0xFF)
[    9.200090] i2c i2c-0: Unsupported chip at 0x4e (man_id=3D0xFF, chip_id=
=3D0xFF)
[    9.300063] i2c i2c-0: Unsupported chip at 0x4f (man_id=3D0xFF, chip_id=
=3D0xFF)
[    9.300063] i2c i2c-0: Unsupported chip at 0x4f (man_id=3D0xFF, chip_id=
=3D0xFF)
[    9.900059] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[    9.900059] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[    9.940072] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[    9.940072] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[    9.980088] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[    9.980088] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[   10.500069] i2c i2c-0: MAX1619 detection failed at 0x18
[   10.500069] i2c i2c-0: MAX1619 detection failed at 0x18
[   10.580185] i2c i2c-0: MAX1619 detection failed at 0x19
[   10.580185] i2c i2c-0: MAX1619 detection failed at 0x19
[   10.660120] i2c i2c-0: MAX1619 detection failed at 0x1a
[   10.660120] i2c i2c-0: MAX1619 detection failed at 0x1a
[   10.740080] i2c i2c-0: MAX1619 detection failed at 0x29
[   10.740080] i2c i2c-0: MAX1619 detection failed at 0x29
[   10.820076] i2c i2c-0: MAX1619 detection failed at 0x2a
[   10.820076] i2c i2c-0: MAX1619 detection failed at 0x2a
[   10.900070] i2c i2c-0: MAX1619 detection failed at 0x2b
[   10.900070] i2c i2c-0: MAX1619 detection failed at 0x2b
[   10.980082] i2c i2c-0: MAX1619 detection failed at 0x4c
[   10.980082] i2c i2c-0: MAX1619 detection failed at 0x4c
[   11.060082] i2c i2c-0: MAX1619 detection failed at 0x4d
[   11.060082] i2c i2c-0: MAX1619 detection failed at 0x4d
[   11.140098] i2c i2c-0: MAX1619 detection failed at 0x4e
[   11.140098] i2c i2c-0: MAX1619 detection failed at 0x4e
[   11.820298] pc87360: PC8736x not detected, module not inserted
[   11.820298] pc87360: PC8736x not detected, module not inserted
[   11.880091] i2c i2c-0: SMSC47M192 detection failed at 0x2c
[   11.880091] i2c i2c-0: SMSC47M192 detection failed at 0x2c
[   11.940089] i2c i2c-0: SMSC47M192 detection failed at 0x2d
[   11.940089] i2c i2c-0: SMSC47M192 detection failed at 0x2d
[   12.300099] i2c i2c-0: w83l785ts: Read 0xff from register 0x40.
[   12.300099] i2c i2c-0: w83l785ts: Read 0xff from register 0x40.
[   12.301378] i2c i2c-0: W83L785TS-S detection failed at 0x2e
[   12.301378] i2c i2c-0: W83L785TS-S detection failed at 0x2e
[   12.340108] i2c i2c-0: W83L786NG detection failed at 0x2e
[   12.340108] i2c i2c-0: W83L786NG detection failed at 0x2e
[   12.380093] i2c i2c-0: W83L786NG detection failed at 0x2f
[   12.380093] i2c i2c-0: W83L786NG detection failed at 0x2f
[   12.381416] EDAC DEBUG: i5000_init: MC:
[   12.381416] EDAC DEBUG: i5000_init: MC:
[   12.382322] EDAC DEBUG: i5400_init: MC:
[   12.382322] EDAC DEBUG: i5400_init: MC:
[   12.383138] EDAC DEBUG: i7300_init:=20
[   12.383138] EDAC DEBUG: i7300_init:=20
[   12.383939] EDAC DEBUG: i82875p_init: 875p pci_get_device fail
[   12.383939] EDAC DEBUG: i82875p_init: 875p pci_get_device fail
[   12.385194] EDAC DEBUG: i82975x_init: i82975x pci_get_device fail
[   12.385194] EDAC DEBUG: i82975x_init: i82975x pci_get_device fail
[   12.386313] EDAC DEBUG: i3000_init: i3000 pci_get_device fail
[   12.386313] EDAC DEBUG: i3000_init: i3000 pci_get_device fail
[   12.387331] EDAC DEBUG: i3200_init: i3200 pci_get_device fail
[   12.387331] EDAC DEBUG: i3200_init: i3200 pci_get_device fail
[   12.388442] EDAC DEBUG: x38_init: x38 pci_get_device fail
[   12.388442] EDAC DEBUG: x38_init: x38 pci_get_device fail
[   12.389441] cpufreq-nforce2: No nForce2 chipset.
[   12.389441] cpufreq-nforce2: No nForce2 chipset.
[   12.391090] leds_ss4200: no LED devices found
[   12.391090] leds_ss4200: no LED devices found
[   12.391920] ledtrig-cpu: registered to indicate activity on CPUs
[   12.391920] ledtrig-cpu: registered to indicate activity on CPUs
[   12.393709] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[   12.393709] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[   12.395031] Driver for HIFN 795x crypto accelerator chip has been succes=
sfully registered.
[   12.395031] Driver for HIFN 795x crypto accelerator chip has been succes=
sfully registered.
[   12.397240] acerhdf: Acer Aspire One Fan driver, v.0.5.26
[   12.397240] acerhdf: Acer Aspire One Fan driver, v.0.5.26
[   12.398174] acerhdf: unknown (unsupported) BIOS version Bochs/Bochs/Boch=
s, please report, aborting!
[   12.398174] acerhdf: unknown (unsupported) BIOS version Bochs/Bochs/Boch=
s, please report, aborting!
[   12.399703] Initializing HPQ6001 module
[   12.399703] Initializing HPQ6001 module
[   12.400673] fujitsu_laptop: driver 0.6.0 successfully loaded
[   12.400673] fujitsu_laptop: driver 0.6.0 successfully loaded
[   12.401645] fujitsu_tablet: Unknown (using defaults)
[   12.401645] fujitsu_tablet: Unknown (using defaults)
[   12.403273] pss: mss_io, mss_dma, mss_irq and pss_io must be set.
[   12.403273] pss: mss_io, mss_dma, mss_irq and pss_io must be set.
[   12.404315] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen=
 1993-1996
[   12.404315] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen=
 1993-1996
[   12.405585] ad1848: No ISAPnP cards found, trying standard ones...
[   12.405585] ad1848: No ISAPnP cards found, trying standard ones...
[   12.406667] Pro Audio Spectrum driver Copyright (C) by Hannu Savolainen =
1993-1996
[   12.406667] Pro Audio Spectrum driver Copyright (C) by Hannu Savolainen =
1993-1996
[   12.408012] I/O, IRQ, DMA and type are mandatory
[   12.408012] I/O, IRQ, DMA and type are mandatory
[   12.408777] sb: Init: Starting Probe...
[   12.408777] sb: Init: Starting Probe...
[   12.409431] sb: Init: Done
[   12.409431] sb: Init: Done
[   12.409937] Cyrix Kahlua VSA1 XpressAudio support (c) Copyright 2003 Red=
 Hat Inc
[   12.409937] Cyrix Kahlua VSA1 XpressAudio support (c) Copyright 2003 Red=
 Hat Inc
[   12.411259] YM3812 and OPL-3 driver Copyright (C) by Hannu Savolainen, R=
ob Hooft 1993-1996
[   12.411259] YM3812 and OPL-3 driver Copyright (C) by Hannu Savolainen, R=
ob Hooft 1993-1996
[   12.412719] MIDI Loopback device driver
[   12.412719] MIDI Loopback device driver
[   12.413977] ALSA: seq_oss: can't register device seq
[   12.413977] ALSA: seq_oss: can't register device seq
[   12.416014]=20
[   12.416014] printing PIC contents
[   12.416014]=20
[   12.416014] printing PIC contents
[   12.416896] ... PIC  IMR: ffff
[   12.416896] ... PIC  IMR: ffff
[   12.417388] ... PIC  IRR: 1113
[   12.417388] ... PIC  IRR: 1113
[   12.417934] ... PIC  ISR: 0000
[   12.417934] ... PIC  ISR: 0000
[   12.418431] ... PIC ELCR: 0c00
[   12.418431] ... PIC ELCR: 0c00
[   12.418993] printing local APIC contents on CPU#0/0:
[   12.418993] printing local APIC contents on CPU#0/0:
[   12.419821] ... APIC ID:      00000000 (0)
[   12.419821] ... APIC ID:      00000000 (0)
[   12.420010] ... APIC VERSION: 00050014
[   12.420010] ... APIC VERSION: 00050014
[   12.420010] ... APIC TASKPRI: 00000000 (00)
[   12.420010] ... APIC TASKPRI: 00000000 (00)
[   12.420010] ... APIC PROCPRI: 00000000
[   12.420010] ... APIC PROCPRI: 00000000
[   12.420010] ... APIC LDR: 01000000
[   12.420010] ... APIC LDR: 01000000
[   12.420010] ... APIC DFR: ffffffff
[   12.420010] ... APIC DFR: ffffffff
[   12.420010] ... APIC SPIV: 000001ff
[   12.420010] ... APIC SPIV: 000001ff
[   12.420010] ... APIC ISR field:
[   12.420010] ... APIC ISR field:
[   12.420010] 00000000
[   12.420010] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[   12.420010] ... APIC TMR field:
[   12.420010] ... APIC TMR field:
[   12.420010] 00000000
[   12.420010] 000000000200000002000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[   12.420010] ... APIC IRR field:
[   12.420010] ... APIC IRR field:
[   12.420010] 00000000
[   12.420010] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000800000008000

[   12.420010] ... APIC ESR: 00000000
[   12.420010] ... APIC ESR: 00000000
[   12.420010] ... APIC ICR: 000008fd
[   12.420010] ... APIC ICR: 000008fd
[   12.420010] ... APIC ICR2: 02000000
[   12.420010] ... APIC ICR2: 02000000
[   12.420010] ... APIC LVTT: 000000ef
[   12.420010] ... APIC LVTT: 000000ef
[   12.420010] ... APIC LVTPC: 00010000
[   12.420010] ... APIC LVTPC: 00010000
[   12.420010] ... APIC LVT0: 00010700
[   12.420010] ... APIC LVT0: 00010700
[   12.420010] ... APIC LVT1: 00000400
[   12.420010] ... APIC LVT1: 00000400
[   12.420010] ... APIC LVTERR: 000000fe
[   12.420010] ... APIC LVTERR: 000000fe
[   12.420010] ... APIC TMICT: 00098562
[   12.420010] ... APIC TMICT: 00098562
[   12.420010] ... APIC TMCCT: 00000000
[   12.420010] ... APIC TMCCT: 00000000
[   12.420010] ... APIC TDCR: 00000003
[   12.420010] ... APIC TDCR: 00000003
[   12.420010]=20
[   12.420010]=20
[   12.436379] number of MP IRQ sources: 15.
[   12.436379] number of MP IRQ sources: 15.
[   12.437086] number of IO-APIC #0 registers: 24.
[   12.437086] number of IO-APIC #0 registers: 24.
[   12.438025] testing the IO APIC.......................
[   12.438025] testing the IO APIC.......................
[   12.439014] IO APIC #0......
[   12.439014] IO APIC #0......
[   12.439495] .... register #00: 00000000
[   12.439495] .... register #00: 00000000
[   12.440196] .......    : physical APIC id: 00
[   12.440196] .......    : physical APIC id: 00
[   12.440946] .......    : Delivery Type: 0
[   12.440946] .......    : Delivery Type: 0
[   12.441607] .......    : LTS          : 0
[   12.441607] .......    : LTS          : 0
[   12.442376] .... register #01: 00170011
[   12.442376] .... register #01: 00170011
[   12.443147] .......     : max redirection entries: 17
[   12.443147] .......     : max redirection entries: 17
[   12.444043] .......     : PRQ implemented: 0
[   12.444043] .......     : PRQ implemented: 0
[   12.444743] .......     : IO APIC version: 11
[   12.444743] .......     : IO APIC version: 11
[   12.445472] .... register #02: 00000000
[   12.445472] .... register #02: 00000000
[   12.446130] .......     : arbitration: 00
[   12.446130] .......     : arbitration: 00
[   12.446862] .... IRQ redirection table:
[   12.446862] .... IRQ redirection table:
[   12.447502] 1    0    0   0   0    0    0    00
[   12.447502] 1    0    0   0   0    0    0    00
[   12.448279] 0    0    0   0   0    1    1    31
[   12.448279] 0    0    0   0   0    1    1    31
[   12.449063] 0    0    0   0   0    1    1    30
[   12.449063] 0    0    0   0   0    1    1    30
[   12.449833] 0    0    0   0   0    1    1    33
[   12.449833] 0    0    0   0   0    1    1    33
[   12.450640] 1    0    0   0   0    1    1    34
[   12.450640] 1    0    0   0   0    1    1    34
[   12.451414] 1    1    0   0   0    1    1    35
[   12.451414] 1    1    0   0   0    1    1    35
[   12.452277] 0    0    0   0   0    1    1    36
[   12.452277] 0    0    0   0   0    1    1    36
[   12.453082] 0    0    0   0   0    1    1    37
[   12.453082] 0    0    0   0   0    1    1    37
[   12.453850] 0    0    0   0   0    1    1    38
[   12.453850] 0    0    0   0   0    1    1    38
[   12.454671] 0    1    0   0   0    1    1    39
[   12.454671] 0    1    0   0   0    1    1    39
[   12.455517] 1    1    0   0   0    1    1    3A
[   12.455517] 1    1    0   0   0    1    1    3A
[   12.456328] 1    1    0   0   0    1    1    3B
[   12.456328] 1    1    0   0   0    1    1    3B
[   12.457114] 0    0    0   0   0    1    1    3C
[   12.457114] 0    0    0   0   0    1    1    3C
[   12.457895] 0    0    0   0   0    1    1    3D
[   12.457895] 0    0    0   0   0    1    1    3D
[   12.458657] 0    0    0   0   0    1    1    3E
[   12.458657] 0    0    0   0   0    1    1    3E
[   12.459426] 0    0    0   0   0    1    1    3F
[   12.459426] 0    0    0   0   0    1    1    3F
[   12.460246] 1    0    0   0   0    0    0    00
[   12.460246] 1    0    0   0   0    0    0    00
[   12.461034] 1    0    0   0   0    0    0    00
[   12.461034] 1    0    0   0   0    0    0    00
[   12.461834] 1    0    0   0   0    0    0    00
[   12.461834] 1    0    0   0   0    0    0    00
[   12.462637] 1    0    0   0   0    0    0    00
[   12.462637] 1    0    0   0   0    0    0    00
[   12.463403] 1    0    0   0   0    0    0    00
[   12.463403] 1    0    0   0   0    0    0    00
[   12.464188] 1    0    0   0   0    0    0    00
[   12.464188] 1    0    0   0   0    0    0    00
[   12.464971] 1    0    0   0   0    0    0    00
[   12.464971] 1    0    0   0   0    0    0    00
[   12.465724] 1    0    0   0   0    0    0    00
[   12.465724] 1    0    0   0   0    0    0    00
[   12.466533] IRQ to pin mappings:
[   12.466533] IRQ to pin mappings:
[   12.467090] IRQ0=20
[   12.467090] IRQ0 -> 0:2-> 0:2

[   12.467529] IRQ1=20
[   12.467529] IRQ1 -> 0:1-> 0:1

[   12.467986] IRQ3=20
[   12.467986] IRQ3 -> 0:3-> 0:3

[   12.468407] IRQ4=20
[   12.468407] IRQ4 -> 0:4-> 0:4

[   12.468878] IRQ5=20
[   12.468878] IRQ5 -> 0:5-> 0:5

[   12.469302] IRQ6=20
[   12.469302] IRQ6 -> 0:6-> 0:6

[   12.469741] IRQ7=20
[   12.469741] IRQ7 -> 0:7-> 0:7

[   12.470231] IRQ8=20
[   12.470231] IRQ8 -> 0:8-> 0:8

[   12.470678] IRQ9=20
[   12.470678] IRQ9 -> 0:9-> 0:9

[   12.471207] IRQ10=20
[   12.471207] IRQ10 -> 0:10-> 0:10

[   12.471711] IRQ11=20
[   12.471711] IRQ11 -> 0:11-> 0:11

[   12.472355] IRQ12=20
[   12.472355] IRQ12 -> 0:12-> 0:12

[   12.473130] IRQ13=20
[   12.473130] IRQ13 -> 0:13-> 0:13

[   12.473766] IRQ14=20
[   12.473766] IRQ14 -> 0:14-> 0:14

[   12.474245] IRQ15=20
[   12.474245] IRQ15 -> 0:15-> 0:15

[   12.474715] .................................... done.
[   12.474715] .................................... done.
[   12.475625] Using IPI No-Shortcut mode
[   12.475625] Using IPI No-Shortcut mode
[   12.476508] bootconsole [earlyser0] disabled
[   12.476508] bootconsole [earlyser0] disabled
[   12.478524] rtc_cmos 00:00: setting system clock to 2014-03-06 20:48:05 =
UTC (1394138885)
[   12.479379] ALSA device list:
[   12.479655]   No soundcards found.
[   12.481987] Freeing unused kernel memory: 1824K (818ed000 - 81ab5000)
[   12.537487] random: init urandom read with 0 bits of entropy available
[   12.560843] grep (111) used greatest stack depth: 7004 bytes left
[   12.565655] cut (114) used greatest stack depth: 6964 bytes left
[   12.651171] hwclock (119) used greatest stack depth: 6656 bytes left
mountall: Event failed
mount: unknown filesystem type 'sysfs'
mountall: mount /sys [128] terminated with status 32
mountall: Filesystem could not be mounted: /sys
mountall: Skipping mounting /sys since Plymouth is not available
[   12.853352] init: Failed to create pty - disabling logging for job
[   12.853975] init: Temporary process spawn error: No such file or directo=
ry
[   12.914874] init: Failed to create pty - disabling logging for job
[   12.915444] init: Temporary process spawn error: No such file or directo=
ry
[   13.053288] init: Failed to create pty - disabling logging for job
[   13.054081] init: Temporary process spawn error: No such file or directo=
ry
[   13.070555] init: Failed to create pty - disabling logging for job
[   13.071155] init: Temporary process spawn error: No such file or directo=
ry
[   13.105887] initctl (150) used greatest stack depth: 6524 bytes left
[   13.181905] init: Failed to create pty - disabling logging for job
[   13.182626] init: Temporary process spawn error: No such file or directo=
ry
[   13.184618] init: Failed to create pty - disabling logging for job
[   13.185270] init: Temporary process spawn error: No such file or directo=
ry
[   13.194797] init: Failed to create pty - disabling logging for job
[   13.195437] init: Temporary process spawn error: No such file or directo=
ry
[   13.197594] mountall (124) used greatest stack depth: 6348 bytes left
[   13.198744] init: Failed to create pty - disabling logging for job
[   13.199386] init: Temporary process spawn error: No such file or directo=
ry
[   13.211605] init: plymouth-log main process (161) terminated with status=
 1
[   13.216414] init: Failed to create pty - disabling logging for job
[   13.216986] init: Temporary process spawn error: No such file or directo=
ry
[   13.222947] init: Failed to create pty - disabling logging for job
[   13.223511] init: Temporary process spawn error: No such file or directo=
ry
[   13.225241] udevd[168]: starting version 175
udevd[168]: error creating signalfd

[   13.228067] init: Failed to create pty - disabling logging for job
[   13.228631] init: Temporary process spawn error: No such file or directo=
ry
[   13.232380] init: Failed to create pty - disabling logging for job
[   13.232954] init: Temporary process spawn error: No such file or directo=
ry
[   13.238724] init: udev main process (168) terminated with status 5
[   13.239289] init: udev main process ended, respawning
[   13.305641] udevd[185]: starting version 175
udevd[185]: error creating signalfd

[   13.308833] init: Failed to create pty - disabling logging for job
[   13.309429] init: Temporary process spawn error: No such file or directo=
ry
[   13.331059] init: Failed to create pty - disabling logging for job
[   13.331625] init: Temporary process spawn error: No such file or directo=
ry
[   13.351034] init: udev main process (185) terminated with status 5
[   13.351590] init: udev main process ended, respawning
[   13.352634] init: Failed to create pty - disabling logging for job
[   13.353254] init: Temporary process spawn error: No such file or directo=
ry
[   13.391327] init: udev-fallback-graphics main process (186) terminated w=
ith status 127
[   13.393143] init: Failed to create pty - disabling logging for job
[   13.394216] init: Temporary process spawn error: No such file or directo=
ry
[   13.443074] ip (197) used greatest stack depth: 5960 bytes left
[   13.511012] init: networking main process (194) terminated with status 1
[   13.514039] udevd[193]: starting version 175
udevd[193]: error creating signalfd

[   13.518122] init: udev main process (193) terminated with status 5
[   13.518893] init: udev main process ended, respawning
[   13.536205] udevd[213]: starting version 175
udevd[213]: error creating signalfd

[   13.538309] init: udev main process (213) terminated with status 5
[   13.539172] init: udev main process ended, respawning
[   13.547027] udevd[215]: starting version 175
udevd[215]: error creating signalfd

[   13.548788] init: udev main process (215) terminated with status 5
[   13.549685] init: udev main process ended, respawning
[   13.555310] udevd[217]: starting version 175
udevd[217]: error creating signalfd

[   13.556632] init: udev main process (217) terminated with status 5
[   13.557302] init: udev main process ended, respawning
[   13.562862] udevd[219]: starting version 175
udevd[219]: error creating signalfd

[   13.564142] init: udev main process (219) terminated with status 5
[   13.564719] init: udev main process ended, respawning
[   13.571111] udevd[221]: starting version 175
udevd[221]: error creating signalfd

[   13.572900] init: udev main process (221) terminated with status 5
[   13.573556] init: udev main process ended, respawning
[   13.578304] udevd[223]: starting version 175
udevd[223]: error creating signalfd

[   13.579530] init: udev main process (223) terminated with status 5
[   13.580123] init: udev main process ended, respawning
[   13.585180] udevd[225]: starting version 175
udevd[225]: error creating signalfd

[   13.586689] init: udev main process (225) terminated with status 5
[   13.587257] init: udev main process ended, respawning
[   13.592725] udevd[227]: starting version 175
udevd[227]: error creating signalfd

[   13.593965] init: udev main process (227) terminated with status 5
[   13.594519] init: udev respawning too fast, stopped
[   13.810554] init: Failed to create pty - disabling logging for job
[   13.811138] init: Temporary process spawn error: No such file or directo=
ry
Kernel tests: Boot OK!
Kernel tests: Boot OK!
[   13.900559] init: Failed to create pty - disabling logging for job
[   13.901150] init: Temporary process spawn error: No such file or directo=
ry
[   13.921252] init: Failed to create pty - disabling logging for job
[   13.921840] init: Temporary process spawn error: No such file or directo=
ry
[   13.940995] init: Failed to create pty - disabling logging for job
[   13.941644] init: Temporary process spawn error: No such file or directo=
ry
[   13.961319] init: Failed to create pty - disabling logging for job
[   13.962247] init: Temporary process spawn error: No such file or directo=
ry
[   22.595754] sock: process `trinity-main' is using obsolete setsockopt SO=
_BSDCOMPAT
[   22.990247] Bits 55-60 of /proc/PID/pagemap entries are about to stop be=
ing page-shift some time soon. See the linux/Documentation/vm/pagemap.txt f=
or details.
[   23.005171] VFS: Warning: trinity-c1 using old stat() call. Recompile yo=
ur binary.
[   23.906550] init: tty4 main process (238) terminated with status 1
[   23.907352] init: tty4 main process ended, respawning
[   23.926183] init: tty5 main process (261) terminated with status 1
[   23.926800] init: tty5 main process ended, respawning
[   23.946193] init: tty2 main process (262) terminated with status 1
[   23.946770] init: tty2 main process ended, respawning
[   23.968488] init: tty3 main process (263) terminated with status 1
[   23.969075] init: tty3 main process ended, respawning
[   23.985535] init: tty6 main process (264) terminated with status 1
[   23.986111] init: tty6 main process ended, respawning
[   33.470004] INFO: rcu_sched self-detected stall on CPU
[   33.470004]=20
[   33.470004]=20
[   33.470004] sending NMI to all CPUs:
[   33.470004] NMI backtrace for cpu 0
[   33.470004] CPU: 0 PID: 45 Comm: lock_torture_wr Not tainted 3.14.0-rc5-=
03765-gd478a96 #1
[   33.470004] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   33.470004] task: 8d3e8000 ti: 8d3ea000 task.ti: 8d3ea000
[   33.470004] EIP: 0060:[<81014de9>] EFLAGS: 00010046 CPU: 0
[   33.470004] EIP is at native_apic_mem_write+0x12/0x14
[   33.470004] EAX: ffff8300 EBX: 00000002 ECX: fffff000 EDX: 00000c00
[   33.470004] ESI: 00000c00 EDI: 03000000 EBP: 8d3ebda4 ESP: 8d3ebda4
[   33.470004]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   33.470004] CR0: 8005003b CR2: 00000000 CR3: 01abb000 CR4: 000006b0
[   33.470004] Stack:
[   33.470004]  8d3ebdb8 81014e68 00000006 00000003 00000002 8d3ebdcc 81015=
09b 00002710
[   33.470004]  92255a54 00006e36 8d3ebdd4 8101510c 8d3ebde4 81015241 8176c=
437 81858040
[   33.470004]  8d3ebe20 8105f0d6 81775e21 00000834 ffffff45 ffffff44 00006=
e36 81046824
[   33.470004] Call Trace:
[   33.470004]  [<81014e68>] __default_send_IPI_dest_field+0x4c/0x51
[   33.470004]  [<8101509b>] default_send_IPI_mask_logical+0x47/0x53
[   33.470004]  [<8101510c>] default_send_IPI_all+0x21/0x32
[   33.470004]  [<81015241>] arch_trigger_all_cpu_backtrace+0x38/0x60
[   33.470004]  [<8105f0d6>] rcu_check_callbacks+0x1a2/0x444
[   33.470004]  [<81046824>] ? account_process_tick+0xfe/0x154
[   33.470004]  [<8102f6a9>] update_process_times+0x2d/0x50
[   33.470004]  [<81067398>] tick_sched_handle+0x30/0x32
[   33.470004]  [<81067923>] tick_sched_timer+0x2e/0x53
[   33.470004]  [<8103d6a5>] __run_hrtimer.isra.16+0x57/0xab
[   33.470004]  [<810678f5>] ? tick_sched_do_timer+0x28/0x28
[   33.470004]  [<8103e02a>] hrtimer_interrupt+0xf0/0x1ec
[   33.470004]  [<81055459>] ? torture_lock_busted_write_unlock+0x5/0x5
[   33.470004]  [<810140ab>] local_apic_timer_interrupt+0x41/0x46
[   33.470004]  [<810142ae>] smp_apic_timer_interrupt+0x20/0x2f
[   33.470004]  [<8154486d>] apic_timer_interrupt+0x2d/0x34
[   33.470004]  [<81055459>] ? torture_lock_busted_write_unlock+0x5/0x5
[   33.470004]  [<810200d8>] ? aes_dec_blk+0x4c0/0xb6a
[   33.470004]  [<81078ce4>] ? stutter_wait+0x1d/0x5a
[   33.470004]  [<8105550e>] lock_torture_writer+0xb5/0xd9
[   33.470004]  [<8103b78c>] kthread+0x8e/0x93
[   33.470004]  [<81544c37>] ret_from_kernel_thread+0x1b/0x28
[   33.470004]  [<8103b6fe>] ? __kthread_parkme+0x50/0x50
[   33.470004] Code: 00 5d c3 55 89 e5 50 9d 8d 74 26 00 5d c3 55 89 e5 fa =
90 8d 74 26 00 5d c3 8b 0d 08 38 85 81 55 89 e5 8d 84 08 00 90 ff ff 89 10 =
<5d> c3 55 8d 48 01 89 e5 53 89 d3 89 d8 ba 08 00 00 00 e8 e8 ee
[   33.480082] NMI backtrace for cpu 1
[   33.480082] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.14.0-rc5-03765-g=
d478a96 #1
[   33.480082] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   33.480082] task: 80056000 ti: 80058000 task.ti: 80058000
[   33.480082] EIP: 0060:[<8101973a>] EFLAGS: 00200286 CPU: 1
[   33.480082] EIP is at native_safe_halt+0x5/0x7
[   33.480082] EAX: ffffffed EBX: 80058000 ECX: 00200046 EDX: 00200046
[   33.480082] ESI: 00000000 EDI: 80059fbc EBP: 80059f78 ESP: 80059f78
[   33.480082]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   33.480082] CR0: 8005003b CR2: 775c3680 CR3: 13323000 CR4: 000006b0
[   33.480082] DR0: 74238000 DR1: 74238000 DR2: 00000000 DR3: 00000000
[   33.480082] DR6: ffff0ff0 DR7: 00000600
[   33.480082] Stack:
[   33.480082]  80059f80 810078bc 80059f88 81007dd0 80059f94 8104df1c 01000=
800 80059fa8
[   33.480082]  81012c77 00000001 00000000 80059fbc 00000000 00000000 00200=
002 00000000
[   33.480082]  00000000 00000000 00000000 00000000 00000000 00000000 00000=
07b 0000007b
[   33.480082] Call Trace:
[   33.480082]  [<810078bc>] default_idle+0x8/0xb
[   33.480082]  [<81007dd0>] arch_cpu_idle+0x9/0xb
[   33.480082]  [<8104df1c>] cpu_startup_entry+0xb2/0x134
[   33.480082]  [<81012c77>] start_secondary+0x202/0x20b
[   33.480082] Code: 0f 22 e0 5d c3 55 89 e5 0f 09 5d c3 55 89 e5 9c 58 5d =
c3 55 89 e5 50 9d 5d c3 55 89 e5 fa 5d c3 55 89 e5 fb 5d c3 55 89 e5 fb f4 =
<5d> c3 55 89 e5 f4 5d c3 55 89 e5 57 89 c7 56 89 ce 53 53 89 55
[   33.470004] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 33.041 msecs
[   33.912838] init: tty4 main process (269) terminated with status 1
[   33.913468] init: tty4 main process ended, respawning
[   33.932492] init: tty5 main process (270) terminated with status 1
[   33.933082] init: tty5 main process ended, respawning
[   33.952074] init: tty2 main process (271) terminated with status 1
[   33.952664] init: tty2 main process ended, respawning
[   33.974962] init: tty3 main process (272) terminated with status 1
[   33.975564] init: tty3 main process ended, respawning
[   33.992426] init: tty6 main process (273) terminated with status 1
[   33.993564] init: tty6 main process ended, respawning
[   43.921822] init: tty4 main process (274) terminated with status 1
[   43.922397] init: tty4 main process ended, respawning
[   43.939938] init: tty5 main process (275) terminated with status 1
[   43.940544] init: tty5 main process ended, respawning
[   43.959443] init: tty2 main process (276) terminated with status 1
[   43.960308] init: tty2 main process ended, respawning
[   43.982794] init: tty3 main process (277) terminated with status 1
[   43.983367] init: tty3 main process ended, respawning
[   43.999884] init: tty6 main process (278) terminated with status 1
[   44.000478] init: tty6 main process ended, respawning
[   53.929216] init: tty4 main process (279) terminated with status 1
[   53.930102] init: tty4 main process ended, respawning
[   53.946478] init: tty5 main process (280) terminated with status 1
[   53.947360] init: tty5 main process ended, respawning
[   53.966283] init: tty2 main process (281) terminated with status 1
[   53.967610] init: tty2 main process ended, respawning
[   53.990039] init: tty3 main process (282) terminated with status 1
[   53.990738] init: tty3 main process ended, respawning
[   54.007147] init: tty6 main process (283) terminated with status 1
[   54.007971] init: tty6 main process ended, respawning
[   63.939642] init: tty4 main process (285) terminated with status 1
[   63.940797] init: tty4 main process ended, respawning
[   63.956530] init: tty5 main process (286) terminated with status 1
[   63.957505] init: tty5 main process ended, respawning
[   63.976631] init: tty2 main process (287) terminated with status 1
[   63.977225] init: tty2 main process ended, respawning
[   63.999142] init: tty3 main process (288) terminated with status 1
[   63.999709] init: tty3 main process ended, respawning
[   64.018002] init: tty6 main process (289) terminated with status 1
[   64.018586] init: tty6 main process ended, respawning
[   72.588760] init: Failed to create pty - disabling logging for job
[   72.589514] init: Temporary process spawn error: No such file or directo=
ry
error: 'rc.local' exited outside the expected code flow.
[   72.607010] init: rc main process (237) killed by TERM signal
[   72.608335] init: tty4 main process (290) killed by TERM signal
[   72.611850] init: tty5 main process (291) killed by TERM signal
[   72.613203] init: tty2 main process (292) killed by TERM signal
[   72.615962] init: tty3 main process (293) killed by TERM signal
[   72.617415] init: tty6 main process (294) killed by TERM signal
[   72.626123] init: plymouth-upstart-bridge main process (298) terminated =
with status 1
 * Asking all remaining processes to terminate...      =20
[   96.500009] INFO: rcu_sched self-detected stall on CPU
[   96.500009]=20
[   96.500009]=20
[   96.500009] sending NMI to all CPUs:
[   96.500009] NMI backtrace for cpu 0
[   96.500009] CPU: 0 PID: 45 Comm: lock_torture_wr Not tainted 3.14.0-rc5-=
03765-gd478a96 #1
[   96.500009] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   96.500009] task: 8d3e8000 ti: 8d3ea000 task.ti: 8d3ea000
[   96.500009] EIP: 0060:[<81014de9>] EFLAGS: 00010046 CPU: 0
[   96.500009] EIP is at native_apic_mem_write+0x12/0x14
[   96.500009] EAX: ffff8300 EBX: 00000002 ECX: fffff000 EDX: 00000c00
[   96.500009] ESI: 00000c00 EDI: 03000000 EBP: 8d3ebda4 ESP: 8d3ebda4
[   96.500009]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   96.500009] CR0: 8005003b CR2: 00000000 CR3: 01abb000 CR4: 000006b0
[   96.500009] Stack:
[   96.500009]  8d3ebdb8 81014e68 00000006 00000003 00000002 8d3ebdcc 81015=
09b 00002710
[   96.500009]  92255a54 00008735 8d3ebdd4 8101510c 8d3ebde4 81015241 8176c=
437 81858040
[   96.500009]  8d3ebe20 8105f0d6 81775e21 000020d3 ffffff45 ffffff44 00008=
735 81046824
[   96.500009] Call Trace:
[   96.500009]  [<81014e68>] __default_send_IPI_dest_field+0x4c/0x51
[   96.500009]  [<8101509b>] default_send_IPI_mask_logical+0x47/0x53
[   96.500009]  [<8101510c>] default_send_IPI_all+0x21/0x32
[   96.500009]  [<81015241>] arch_trigger_all_cpu_backtrace+0x38/0x60
[   96.500009]  [<8105f0d6>] rcu_check_callbacks+0x1a2/0x444
[   96.500009]  [<81046824>] ? account_process_tick+0xfe/0x154
[   96.500009]  [<8102f6a9>] update_process_times+0x2d/0x50
[   96.500009]  [<81067398>] tick_sched_handle+0x30/0x32
[   96.500009]  [<81067923>] tick_sched_timer+0x2e/0x53
[   96.500009]  [<8103d6a5>] __run_hrtimer.isra.16+0x57/0xab
[   96.500009]  [<810678f5>] ? tick_sched_do_timer+0x28/0x28
[   96.500009]  [<8103e02a>] hrtimer_interrupt+0xf0/0x1ec
[   96.500009]  [<81055459>] ? torture_lock_busted_write_unlock+0x5/0x5
[   96.500009]  [<810140ab>] local_apic_timer_interrupt+0x41/0x46
[   96.500009]  [<810142ae>] smp_apic_timer_interrupt+0x20/0x2f
[   96.500009]  [<8154486d>] apic_timer_interrupt+0x2d/0x34
[   96.500009]  [<81055459>] ? torture_lock_busted_write_unlock+0x5/0x5
[   96.500009]  [<810200d8>] ? aes_dec_blk+0x4c0/0xb6a
[   96.500009]  [<81078ce4>] ? stutter_wait+0x1d/0x5a
[   96.500009]  [<8105550e>] lock_torture_writer+0xb5/0xd9
[   96.500009]  [<8103b78c>] kthread+0x8e/0x93
[   96.500009]  [<81544c37>] ret_from_kernel_thread+0x1b/0x28
[   96.500009]  [<8103b6fe>] ? __kthread_parkme+0x50/0x50
[   96.500009] Code: 00 5d c3 55 89 e5 50 9d 8d 74 26 00 5d c3 55 89 e5 fa =
90 8d 74 26 00 5d c3 8b 0d 08 38 85 81 55 89 e5 8d 84 08 00 90 ff ff 89 10 =
<5d> c3 55 8d 48 01 89 e5 53 89 d3 89 d8 ba 08 00 00 00 e8 e8 ee
[   96.510028] NMI backtrace for cpu 1
[   96.510028] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.14.0-rc5-03765-g=
d478a96 #1
[   96.510028] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   96.510028] task: 80056000 ti: 80058000 task.ti: 80058000
[   96.510028] EIP: 0060:[<8101973a>] EFLAGS: 00200286 CPU: 1
[   96.510028] EIP is at native_safe_halt+0x5/0x7
[   96.510028] EAX: ffffffed EBX: 80058000 ECX: 00200046 EDX: 00200046
[   96.510028] ESI: 00000000 EDI: 80059fbc EBP: 80059f78 ESP: 80059f78
[   96.510028]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   96.510028] CR0: 8005003b CR2: 7758903c CR3: 13323000 CR4: 000006b0
[   96.510028] DR0: 088bb4c0 DR1: 74238000 DR2: 00000000 DR3: 00000000
[   96.510028] DR6: ffff0ff0 DR7: 00000600
[   96.510028] Stack:
[   96.510028]  80059f80 810078bc 80059f88 81007dd0 80059f94 8104df1c 01000=
800 80059fa8
[   96.510028]  81012c77 00000001 00000000 80059fbc 00000000 00000000 00200=
002 00000000
[   96.510028]  00000000 00000000 00000000 00000000 00000000 00000000 00000=
07b 0000007b
[   96.510028] Call Trace:
[   96.510028]  [<810078bc>] default_idle+0x8/0xb
[   96.510028]  [<81007dd0>] arch_cpu_idle+0x9/0xb
[   96.510028]  [<8104df1c>] cpu_startup_entry+0xb2/0x134
[   96.510028]  [<81012c77>] start_secondary+0x202/0x20b
[   96.510028] Code: 0f 22 e0 5d c3 55 89 e5 0f 09 5d c3 55 89 e5 9c 58 5d =
c3 55 89 e5 50 9d 5d c3 55 89 e5 fa 5d c3 55 89 e5 fb 5d c3 55 89 e5 fb f4 =
<5d> c3 55 89 e5 f4 5d c3 55 89 e5 57 89 c7 56 89 ce 53 53 89 55
[   96.539471] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 37.391 msecs
[  159.530004] INFO: rcu_sched self-detected stall on CPU
[  159.530004]=20
[  159.530004]=20
[  159.530004] sending NMI to all CPUs:
[  159.530004] NMI backtrace for cpu 0
[  159.530004] CPU: 0 PID: 45 Comm: lock_torture_wr Not tainted 3.14.0-rc5-=
03765-gd478a96 #1
[  159.530004] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  159.530004] task: 8d3e8000 ti: 8d3ea000 task.ti: 8d3ea000
[  159.530004] EIP: 0060:[<81014de9>] EFLAGS: 00010046 CPU: 0
[  159.530004] EIP is at native_apic_mem_write+0x12/0x14
[  159.530004] EAX: ffff8300 EBX: 00000002 ECX: fffff000 EDX: 00000c00
[  159.530004] ESI: 00000c00 EDI: 03000000 EBP: 8d3ebda4 ESP: 8d3ebda4
[  159.530004]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  159.530004] CR0: 8005003b CR2: 00000000 CR3: 01abb000 CR4: 000006b0
[  159.530004] Stack:
[  159.530004]  8d3ebdb8 81014e68 00000006 00000003 00000002 8d3ebdcc 81015=
09b 00002710
[  159.530004]  92255a54 00008735 8d3ebdd4 8101510c 8d3ebde4 81015241 8176c=
437 81858040
[  159.530004]  8d3ebe20 8105f0d6 81775e21 00003972 ffffff45 ffffff44 00008=
735 81046824
[  159.530004] Call Trace:
[  159.530004]  [<81014e68>] __default_send_IPI_dest_field+0x4c/0x51
[  159.530004]  [<8101509b>] default_send_IPI_mask_logical+0x47/0x53
[  159.530004]  [<8101510c>] default_send_IPI_all+0x21/0x32
[  159.530004]  [<81015241>] arch_trigger_all_cpu_backtrace+0x38/0x60
[  159.530004]  [<8105f0d6>] rcu_check_callbacks+0x1a2/0x444
[  159.530004]  [<81046824>] ? account_process_tick+0xfe/0x154
[  159.530004]  [<8102f6a9>] update_process_times+0x2d/0x50
[  159.530004]  [<81067398>] tick_sched_handle+0x30/0x32
[  159.530004]  [<81067923>] tick_sched_timer+0x2e/0x53
[  159.530004]  [<8103d6a5>] __run_hrtimer.isra.16+0x57/0xab
[  159.530004]  [<810678f5>] ? tick_sched_do_timer+0x28/0x28
[  159.530004]  [<8103e02a>] hrtimer_interrupt+0xf0/0x1ec
[  159.530004]  [<81055459>] ? torture_lock_busted_write_unlock+0x5/0x5
[  159.530004]  [<810140ab>] local_apic_timer_interrupt+0x41/0x46
[  159.530004]  [<810142ae>] smp_apic_timer_interrupt+0x20/0x2f
[  159.530004]  [<8154486d>] apic_timer_interrupt+0x2d/0x34
[  159.530004]  [<81055459>] ? torture_lock_busted_write_unlock+0x5/0x5
[  159.530004]  [<810200d8>] ? aes_dec_blk+0x4c0/0xb6a
[  159.530004]  [<81078ce4>] ? stutter_wait+0x1d/0x5a
[  159.530004]  [<8105550e>] lock_torture_writer+0xb5/0xd9
[  159.530004]  [<8103b78c>] kthread+0x8e/0x93
[  159.530004]  [<81544c37>] ret_from_kernel_thread+0x1b/0x28
[  159.530004]  [<8103b6fe>] ? __kthread_parkme+0x50/0x50
[  159.530004] Code: 00 5d c3 55 89 e5 50 9d 8d 74 26 00 5d c3 55 89 e5 fa =
90 8d 74 26 00 5d c3 8b 0d 08 38 85 81 55 89 e5 8d 84 08 00 90 ff ff 89 10 =
<5d> c3 55 8d 48 01 89 e5 53 89 d3 89 d8 ba 08 00 00 00 e8 e8 ee
[  159.540067] NMI backtrace for cpu 1
[  159.540067] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.14.0-rc5-03765-g=
d478a96 #1
[  159.540067] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  159.540067] task: 80056000 ti: 80058000 task.ti: 80058000
[  159.540067] EIP: 0060:[<8101973a>] EFLAGS: 00200286 CPU: 1
[  159.540067] EIP is at native_safe_halt+0x5/0x7
[  159.540067] EAX: ffffffed EBX: 80058000 ECX: 00200046 EDX: 00200046
[  159.540067] ESI: 00000000 EDI: 80059fbc EBP: 80059f78 ESP: 80059f78
[  159.540067]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  159.540067] CR0: 8005003b CR2: 7758903c CR3: 13323000 CR4: 000006b0
[  159.540067] DR0: 088bb4c0 DR1: 74238000 DR2: 00000000 DR3: 00000000
[  159.540067] DR6: ffff0ff0 DR7: 00000600
[  159.540067] Stack:
[  159.540067]  80059f80 810078bc 80059f88 81007dd0 80059f94 8104df1c 01000=
800 80059fa8
[  159.540067]  81012c77 00000001 00000000 80059fbc 00000000 00000000 00200=
002 00000000
[  159.540067]  00000000 00000000 00000000 00000000 00000000 00000000 00000=
07b 0000007b
[  159.540067] Call Trace:
[  159.540067]  [<810078bc>] default_idle+0x8/0xb
[  159.540067]  [<81007dd0>] arch_cpu_idle+0x9/0xb
[  159.540067]  [<8104df1c>] cpu_startup_entry+0xb2/0x134
[  159.540067]  [<81012c77>] start_secondary+0x202/0x20b
[  159.540067] Code: 0f 22 e0 5d c3 55 89 e5 0f 09 5d c3 55 89 e5 9c 58 5d =
c3 55 89 e5 50 9d 5d c3 55 89 e5 fa 5d c3 55 89 e5 fb 5d c3 55 89 e5 fb f4 =
<5d> c3 55 89 e5 f4 5d c3 55 89 e5 57 89 c7 56 89 ce 53 53 89 55
[  222.560033] INFO: rcu_sched self-detected stall on CPU
[  222.560036]=20
[  222.560036]=20
[  222.560036] sending NMI to all CPUs:
[  222.560036] NMI backtrace for cpu 0
[  222.560036] CPU: 0 PID: 45 Comm: lock_torture_wr Not tainted 3.14.0-rc5-=
03765-gd478a96 #1
[  222.560036] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  222.560036] task: 8d3e8000 ti: 8d3ea000 task.ti: 8d3ea000
[  222.560036] EIP: 0060:[<81014de9>] EFLAGS: 00010046 CPU: 0
[  222.560036] EIP is at native_apic_mem_write+0x12/0x14
[  222.560036] EAX: ffff8300 EBX: 00000002 ECX: fffff000 EDX: 00000c00
[  222.560036] ESI: 00000c00 EDI: 03000000 EBP: 8d3ebda4 ESP: 8d3ebda4
[  222.560036]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  222.560036] CR0: 8005003b CR2: 00000000 CR3: 01abb000 CR4: 000006b0
[  222.560036] Stack:
[  222.560036]  8d3ebdb8 81014e68 00000006 00000003 00000002 8d3ebdcc 81015=
09b 00002710
[  222.560036]  92255a54 00008735 8d3ebdd4 8101510c 8d3ebde4 81015241 8176c=
437 81858040
[  222.560036]  8d3ebe20 8105f0d6 81775e21 00005211 ffffff45 ffffff44 00008=
735 81046824
[  222.560036] Call Trace:
[  222.560036]  [<81014e68>] __default_send_IPI_dest_field+0x4c/0x51
[  222.560036]  [<8101509b>] default_send_IPI_mask_logical+0x47/0x53
[  222.560036]  [<8101510c>] default_send_IPI_all+0x21/0x32
[  222.560036]  [<81015241>] arch_trigger_all_cpu_backtrace+0x38/0x60
[  222.560036]  [<8105f0d6>] rcu_check_callbacks+0x1a2/0x444
[  222.560036]  [<81046824>] ? account_process_tick+0xfe/0x154
[  222.560036]  [<8102f6a9>] update_process_times+0x2d/0x50
[  222.560036]  [<81067398>] tick_sched_handle+0x30/0x32
[  222.560036]  [<81067923>] tick_sched_timer+0x2e/0x53
[  222.560036]  [<8103d6a5>] __run_hrtimer.isra.16+0x57/0xab
[  222.560036]  [<810678f5>] ? tick_sched_do_timer+0x28/0x28
[  222.560036]  [<8103e02a>] hrtimer_interrupt+0xf0/0x1ec
[  222.560036]  [<81055459>] ? torture_lock_busted_write_unlock+0x5/0x5
[  222.560036]  [<810140ab>] local_apic_timer_interrupt+0x41/0x46
[  222.560036]  [<810142ae>] smp_apic_timer_interrupt+0x20/0x2f
[  222.560036]  [<8154486d>] apic_timer_interrupt+0x2d/0x34
[  222.560036]  [<81055459>] ? torture_lock_busted_write_unlock+0x5/0x5
[  222.560036]  [<810200d8>] ? aes_dec_blk+0x4c0/0xb6a
[  222.560036]  [<81078ce9>] ? stutter_wait+0x22/0x5a
[  222.560036]  [<8105550e>] lock_torture_writer+0xb5/0xd9
[  222.560036]  [<8103b78c>] kthread+0x8e/0x93
[  222.560036]  [<81544c37>] ret_from_kernel_thread+0x1b/0x28
[  222.560036]  [<8103b6fe>] ? __kthread_parkme+0x50/0x50
[  222.560036] Code: 00 5d c3 55 89 e5 50 9d 8d 74 26 00 5d c3 55 89 e5 fa =
90 8d 74 26 00 5d c3 8b 0d 08 38 85 81 55 89 e5 8d 84 08 00 90 ff ff 89 10 =
<5d> c3 55 8d 48 01 89 e5 53 89 d3 89 d8 ba 08 00 00 00 e8 e8 ee
[  222.570036] NMI backtrace for cpu 1
[  222.570036] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.14.0-rc5-03765-g=
d478a96 #1
[  222.570036] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  222.570036] task: 80056000 ti: 80058000 task.ti: 80058000
[  222.570036] EIP: 0060:[<8101973a>] EFLAGS: 00200286 CPU: 1
[  222.570036] EIP is at native_safe_halt+0x5/0x7
[  222.570036] EAX: ffffffed EBX: 80058000 ECX: 00200046 EDX: 00200046
[  222.570036] ESI: 00000000 EDI: 80059fbc EBP: 80059f78 ESP: 80059f78
[  222.570036]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  222.570036] CR0: 8005003b CR2: 7758903c CR3: 13323000 CR4: 000006b0
[  222.570036] DR0: 088bb4c0 DR1: 74238000 DR2: 00000000 DR3: 00000000
[  222.570036] DR6: ffff0ff0 DR7: 00000600
[  222.570036] Stack:
[  222.570036]  80059f80 810078bc 80059f88 81007dd0 80059f94 8104df1c 01000=
800 80059fa8
[  222.570036]  81012c77 00000001 00000000 80059fbc 00000000 00000000 00200=
002 00000000
[  222.570036]  00000000 00000000 00000000 00000000 00000000 00000000 00000=
07b 0000007b
[  222.570036] Call Trace:
[  222.570036]  [<810078bc>] default_idle+0x8/0xb
[  222.570036]  [<81007dd0>] arch_cpu_idle+0x9/0xb
[  222.570036]  [<8104df1c>] cpu_startup_entry+0xb2/0x134
[  222.570036]  [<81012c77>] start_secondary+0x202/0x20b
[  222.570036] Code: 0f 22 e0 5d c3 55 89 e5 0f 09 5d c3 55 89 e5 9c 58 5d =
c3 55 89 e5 50 9d 5d c3 55 89 e5 fa 5d c3 55 89 e5 fb 5d c3 55 89 e5 fb f4 =
<5d> c3 55 89 e5 f4 5d c3 55 89 e5 57 89 c7 56 89 ce 53 53 89 55
[  222.617520] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 54.236 msecs
[  241.400154] INFO: task umount:260 blocked for more than 120 seconds.
[  241.401087]       Not tainted 3.14.0-rc5-03765-gd478a96 #1
[  241.401912] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[  241.403012] umount          D 932e0000  6972   260      1 0x00000000
[  241.404004]  932e1e74 00000046 81ab3dc0 932e0000 3b8e308a 00000003 93103=
dc0 00000003
[  241.405267]  932de000 00000000 923a7380 3b8e1fa1 00000003 3b8e1f09 00000=
003 00000001
[  241.406767]  923a7380 00000000 932e1e70 810462ae 932de4e0 00000000 00000=
068 3b8e1fa1
[  241.408079] Call Trace:
[  241.408424]  [<810462ae>] ? sched_clock_cpu+0xc6/0xe7
[  241.409171]  [<81541264>] schedule+0x10/0x12
[  241.409741]  [<815409fd>] schedule_timeout+0x15/0x9c
[  241.410512]  [<81053256>] ? lock_release+0x135/0x16a
[  241.411166]  [<81543ce4>] ? _raw_spin_unlock_irq+0x22/0x2c
[  241.411880]  [<8154183c>] __wait_for_common+0xd8/0xfe
[  241.412645]  [<815409e8>] ? nl_portid_hash_rehash+0x127/0x127
[  241.413388]  [<81044545>] ? wake_up_state+0xc/0xc
[  241.414086]  [<8105f7cf>] ? __call_rcu+0x1e0/0x1e0
[  241.414714]  [<81541876>] wait_for_completion+0x14/0x17
[  241.415395]  [<8105ced1>] wait_rcu_gp+0x34/0x3a
[  241.415982]  [<8105ce26>] ? rcu_panic+0x11/0x11
[  241.417732]  [<81050101>] ? proc_sched_show_task+0x6b1/0xd7c
[  241.418475]  [<81541795>] ? __wait_for_common+0x31/0xfe
[  241.419162]  [<8105f4f0>] synchronize_sched+0x26/0x28
[  241.419842]  [<810b3a8e>] namespace_unlock+0x5d/0x8f
[  241.420539]  [<810b41f3>] SYSC_umount+0x259/0x292
[  241.421155]  [<810322a8>] ? sigprocmask+0x79/0x89
[  241.422070]  [<810b4256>] SyS_oldumount+0x1a/0x1c
[  241.422701]  [<81544cca>] sysenter_do_call+0x12/0x37
[  241.423358] no locks held by umount/260.
[  241.423871] sending NMI to all CPUs:
[  241.424365] NMI backtrace for cpu 1
[  241.424822] CPU: 1 PID: 48 Comm: khungtaskd Not tainted 3.14.0-rc5-03765=
-gd478a96 #1
[  241.425808] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  241.426763] task: 8d3f4000 ti: 8d3f6000 task.ti: 8d3f6000
[  241.427471] EIP: 0060:[<81014de9>] EFLAGS: 00010046 CPU: 1
[  241.428175] EIP is at native_apic_mem_write+0x12/0x14
[  241.428840] EAX: ffff8300 EBX: 00000002 ECX: fffff000 EDX: 00000c00
[  241.429658] ESI: 00000c00 EDI: 03000000 EBP: 8d3f7eb4 ESP: 8d3f7eb4
[  241.430498]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  241.430514] CR0: 8005003b CR2: 7758903c CR3: 13323000 CR4: 000006b0
[  241.430514] DR0: 088bb4c0 DR1: 74238000 DR2: 00000000 DR3: 00000000
[  241.430514] DR6: ffff0ff0 DR7: 00000600
[  241.430514] Stack:
[  241.430514]  8d3f7ec8 81014e68 00000206 00000003 00000002 8d3f7edc 81015=
09b 00002710
[  241.430514]  932de000 932de234 8d3f7ee4 8101510c 8d3f7ef4 81015241 8176c=
437 932de000
[  241.430514]  8d3f7f20 8106dc93 000003cd 00000002 00007fcd 00007fcd 00000=
078 932de234
[  241.430514] Call Trace:
[  241.430514]  [<81014e68>] __default_send_IPI_dest_field+0x4c/0x51
[  241.430514]  [<8101509b>] default_send_IPI_mask_logical+0x47/0x53
[  241.430514]  [<8101510c>] default_send_IPI_all+0x21/0x32
[  241.430514]  [<81015241>] arch_trigger_all_cpu_backtrace+0x38/0x60
[  241.430514]  [<8106dc93>] watchdog+0x1f4/0x27b
[  241.430514]  [<8106da9f>] ? rcu_lock_acquire.constprop.2+0x21/0x21
[  241.430514]  [<8103b78c>] kthread+0x8e/0x93
[  241.430514]  [<81544c37>] ret_from_kernel_thread+0x1b/0x28
[  241.430514]  [<8103b6fe>] ? __kthread_parkme+0x50/0x50
[  241.430514] Code: 00 5d c3 55 89 e5 50 9d 8d 74 26 00 5d c3 55 89 e5 fa =
90 8d 74 26 00 5d c3 8b 0d 08 38 85 81 55 89 e5 8d 84 08 00 90 ff ff 89 10 =
<5d> c3 55 8d 48 01 89 e5 53 89 d3 89 d8 ba 08 00 00 00 e8 e8 ee
[  241.430031] NMI backtrace for cpu 0
[  241.430031] CPU: 0 PID: 45 Comm: lock_torture_wr Not tainted 3.14.0-rc5-=
03765-gd478a96 #1
[  241.430031] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  241.430031] task: 8d3e8000 ti: 8d3ea000 task.ti: 8d3ea000
[  241.430031] EIP: 0060:[<81078ce4>] EFLAGS: 00000202 CPU: 0
[  241.430031] EIP is at stutter_wait+0x1d/0x5a
[  241.430031] EAX: 00000002 EBX: 8177481a ECX: 00000000 EDX: 81adb814
[  241.430031] ESI: 8d6fd220 EDI: 81055459 EBP: 8d3ebf14 ESP: 8d3ebf10
[  241.430031]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  241.430031] CR0: 8005003b CR2: 00000000 CR3: 01abb000 CR4: 000006b0
[  241.430031] Stack:
[  241.430031]  8d6fd220 8d3ebf20 8105550e 8d6fd630 8d3ebfac 8103b78c 8d3eb=
f6c 00000000
[  241.430031]  00000000 8d6fd220 00000000 00000000 dead4ead ffffffff fffff=
fff 81adc4dc
[  241.430031]  00000000 00000000 81770639 00000000 92258dc0 8d3ebf64 8d3eb=
f64 00000000
[  241.430031] Call Trace:
[  241.430031]  [<8105550e>] lock_torture_writer+0xb5/0xd9
[  241.430031]  [<8103b78c>] kthread+0x8e/0x93
[  241.430031]  [<81544c37>] ret_from_kernel_thread+0x1b/0x28
[  241.430031]  [<8103b6fe>] ? __kthread_parkme+0x50/0x50
[  241.430031] Code: 59 a1 50 8f 85 81 48 74 e1 8b 5d fc c9 c3 55 89 e5 53 =
89 c3 eb 36 83 3d 84 b1 f1 81 00 74 17 a1 84 b1 f1 81 83 f8 01 75 02 eb 15 =
<a1> 84 b1 f1 81 85 c0 74 11 eb f5 b8 64 00 00 00 e8 4c 63 fb ff
[  241.466659] Kernel panic - not syncing: hung_task: blocked tasks
[  241.467453] CPU: 1 PID: 48 Comm: khungtaskd Not tainted 3.14.0-rc5-03765=
-gd478a96 #1
[  241.468445] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  241.469177]  00000000 00000000 8d3f7ed8 8153c2b8 932de000 8d3f7ef0 8153b=
12f 8176c437
[  241.470024]  932de000 932de000 932de234 8d3f7f20 8106dc9d 817777c6 00000=
3cd 00000002
[  241.470024]  00007fcd 00007fcd 00000078 932de234 8e796808 00000000 8106d=
a9f 8d3f7fac
[  241.470024] Call Trace:
[  241.470024]  [<8153c2b8>] dump_stack+0x48/0x60
[  241.470024]  [<8153b12f>] panic+0x81/0x171
[  241.470024]  [<8106dc9d>] watchdog+0x1fe/0x27b
[  241.470024]  [<8106da9f>] ? rcu_lock_acquire.constprop.2+0x21/0x21
[  241.470024]  [<8103b78c>] kthread+0x8e/0x93
[  241.470024]  [<81544c37>] ret_from_kernel_thread+0x1b/0x28
[  241.470024]  [<8103b6fe>] ? __kthread_parkme+0x50/0x50
[  241.470024] Kernel Offset: 0x0 from 0x81000000 (relocation range: 0x8000=
0000-0x947fdfff)

Elapsed time: 230
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-b=
a1-03062010/d478a960edf1ea61ca31a07a48a8771f043dba78/vmlinuz-3.14.0-rc5-037=
65-gd478a96 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug a=
pic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=3D1 nmi_watchd=
og=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3D=
normal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/i386-randcon=
fig-ba1-03062010/linux-devel:devel-hourly-2014030618/.vmlinuz-d478a960edf1e=
a61ca31a07a48a8771f043dba78-20140306204706-5-xps branch=3Dlinux-devel/devel=
-hourly-2014030618 BOOT_IMAGE=3D/kernel/i386-randconfig-ba1-03062010/d478a9=
60edf1ea61ca31a07a48a8771f043dba78/vmlinuz-3.14.0-rc5-03765-gd478a96'  -ini=
trd /kernel-tests/initrd/quantal-core-i386.cgz -m 320 -smp 2 -net nic,vlan=
=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::8256-:22 -boot order=
=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs=
/LABEL=3DKVM/disk0-quantal-xps-2,media=3Ddisk,if=3Dvirtio -drive file=3D/fs=
/LABEL=3DKVM/disk1-quantal-xps-2,media=3Ddisk,if=3Dvirtio -drive file=3D/fs=
/LABEL=3DKVM/disk2-quantal-xps-2,media=3Ddisk,if=3Dvirtio -drive file=3D/fs=
/LABEL=3DKVM/disk3-quantal-xps-2,media=3Ddisk,if=3Dvirtio -drive file=3D/fs=
/LABEL=3DKVM/disk4-quantal-xps-2,media=3Ddisk,if=3Dvirtio -drive file=3D/fs=
/LABEL=3DKVM/disk5-quantal-xps-2,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm=
/kboot/pid-quantal-xps-2 -serial file:/dev/shm/kboot/serial-quantal-xps-2 -=
daemonize -display none -monitor null=20

--aVD9QWMuhilNxW9f
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-ba1-03062010-d478a960edf1ea61ca31a07a48a8771f043dba78-EIP-is-at-native_apic_mem_write+-x-16103.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDA0MTQ4NTVmZGM0YTQwZGEwNTIyMWZjNjA2MmNjY2JjMGMzMGYxNjkK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1iYTEt
MDMwNjIwMTAvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzA2MTg6MDQxNDg1NWZk
YzRhNDBkYTA1MjIxZmM2MDYyY2NjYmMwYzMwZjE2OTpiaXNlY3QtbGludXg0CgoyMDE0LTAz
LTA2LTIxOjI2OjExIDA0MTQ4NTVmZGM0YTQwZGEwNTIyMWZjNjA2MmNjY2JjMGMzMGYxNjkg
Y29tcGlsaW5nCjcyIHJlYWwgIDExNTMgdXNlciAgMTA0IHN5cyAgMTcyNi4wNiUgY3B1IAlp
Mzg2LXJhbmRjb25maWctYmExLTAzMDYyMDEwCgoyMDE0LTAzLTA2LTIxOjI3OjQyIGRldGVj
dGluZyBib290IHN0YXRlIDMuMTQuMC1yYzUuLgkxCTMJOQkxNgkyMiBTVUNDRVNTCgpiaXNl
Y3Q6IGdvb2QgY29tbWl0IDA0MTQ4NTVmZGM0YTQwZGEwNTIyMWZjNjA2MmNjY2JjMGMzMGYx
NjkKZ2l0IGJpc2VjdCBzdGFydCBkNDc4YTk2MGVkZjFlYTYxY2EzMWEwN2E0OGE4NzcxZjA0
M2RiYTc4IDA0MTQ4NTVmZGM0YTQwZGEwNTIyMWZjNjA2MmNjY2JjMGMzMGYxNjkgLS0KL2Mv
a2VybmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6IFsiLWIiLCAiZDQ3OGE5NjBlZGYxZWE2MWNh
MzFhMDdhNDhhODc3MWYwNDNkYmE3OCIsICItZyIsICIwNDE0ODU1ZmRjNGE0MGRhMDUyMjFm
YzYwNjJjY2NiYzBjMzBmMTY5IiwgIi9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290
LWZhaWx1cmUuc2giLCAiL2tlcm5lbC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdCJdCkJpc2Vj
dGluZzogMzc2NSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
MTIgc3RlcHMpCls2YzIxOTFhZDliNjIyNTg2MGVlZjcwYTc3ZDMwMGMzZDVhZDM5MTgyXSBN
ZXJnZSAnZGlnc2lnL2Zvci1taW1pJyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDMwNjE4CnJ1
bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2Vy
bmVsLXRlc3RzL2xpbnV4NC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYmExLTAzMDYyMDEwL2xpbnV4LWRldmVsOmRldmVs
LWhvdXJseS0yMDE0MDMwNjE4OjZjMjE5MWFkOWI2MjI1ODYwZWVmNzBhNzdkMzAwYzNkNWFk
MzkxODI6YmlzZWN0LWxpbnV4NAoKMjAxNC0wMy0wNi0yMTozMToxNyA2YzIxOTFhZDliNjIy
NTg2MGVlZjcwYTc3ZDMwMGMzZDVhZDM5MTgyIGNvbXBpbGluZwo3OCByZWFsICAxMTU4IHVz
ZXIgIDEwNiBzeXMgIDE2MDYuMjIlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MjAx
MAoKMjAxNC0wMy0wNi0yMTozMjo0OSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmM1
LTAxNDAwLWc2YzIxOTFhLi4JMQkxMwkxNgkxOQkyMiBTVUNDRVNTCgpCaXNlY3Rpbmc6IDIz
NjUgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEyIHN0ZXBz
KQpbOGQwNmQzOWIyZDk1YzFjM2YxMGNlM2QxOTY5ZTFlMzgxOTM1YmJhZl0gTWVyZ2UgJ3Jj
dS9yY3UvZGV2JyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDMwNjE4CnJ1bm5pbmcgL2Mva2Vy
bmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xp
bnV4NC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWctYmExLTAzMDYyMDEwL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0
MDMwNjE4OjhkMDZkMzliMmQ5NWMxYzNmMTBjZTNkMTk2OWUxZTM4MTkzNWJiYWY6YmlzZWN0
LWxpbnV4NAoKMjAxNC0wMy0wNi0yMTozNjoyMSA4ZDA2ZDM5YjJkOTVjMWMzZjEwY2UzZDE5
NjllMWUzODE5MzViYmFmIGNvbXBpbGluZwo3MiByZWFsICAxMTQwIHVzZXIgIDExNyBzeXMg
IDE3MzAuOTElIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MjAxMAoKMjAxNC0wMy0w
Ni0yMTozNzo0NSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmM1LTAyOTcwLWc4ZDA2
ZDM5Li4uLi4uCTIuLi4uIFRFU1QgRkFJTFVSRQpbICAgMjguNTc2Njg2XSBpbml0OiB0dHkz
IG1haW4gcHJvY2VzcyBlbmRlZCwgcmVzcGF3bmluZwpbICAgMjguNjM5NjY3XSBpbml0OiB0
dHk2IG1haW4gcHJvY2VzcyAoMjYwKSB0ZXJtaW5hdGVkIHdpdGggc3RhdHVzIDEKWyAgIDI4
LjY0MDg2MV0gaW5pdDogdHR5NiBtYWluIHByb2Nlc3MgZW5kZWQsIHJlc3Bhd25pbmcKWyAg
IDM0LjczMDA2NV0gSU5GTzogcmN1X3NjaGVkIHNlbGYtZGV0ZWN0ZWQgc3RhbGwgb24gQ1BV
ClsgICAzNC43MzAwNjVdIApbICAgMzQuNzMwMDY1XSAKWyAgIDM0LjczMDA2NV0gc2VuZGlu
ZyBOTUkgdG8gYWxsIENQVXM6ClsgICAzNC43MzM4MDhdIE5NSSBiYWNrdHJhY2UgZm9yIGNw
dSAxClsgICAzNC43MzQ0MTJdIENQVTogMSBQSUQ6IDAgQ29tbTogc3dhcHBlci8xIE5vdCB0
YWludGVkIDMuMTQuMC1yYzUtMDI5NzAtZzhkMDZkMzkgIzI3ClsgICAzNC43MzU2NzZdIEhh
cmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgIDM0
LjczNjYzMF0gdGFzazogODAwNTYwMDAgdGk6IDgwMDU4MDAwIHRhc2sudGk6IDgwMDU4MDAw
ClsgICAzNC43Mzc1MzBdIEVJUDogMDA2MDpbPDgxMDE5NzUxPl0gRUZMQUdTOiAwMDIwMDI4
NiBDUFU6IDEKWyAgIDM0LjczODQ3OF0gRUlQIGlzIGF0IG5hdGl2ZV9zYWZlX2hhbHQrMHg1
LzB4NwpbICAgMzQuNzM5MjE4XSBFQVg6IGZmZmZmZmVkIEVCWDogODAwNTgwMDAgRUNYOiAw
MDIwMDA0NiBFRFg6IDAwMjAwMDQ2ClsgICAzNC43NDAwMTddIEVTSTogMDAwMDAwMDAgRURJ
OiA4MDA1OWZiYyBFQlA6IDgwMDU5Zjc4IEVTUDogODAwNTlmNzgKWyAgIDM0Ljc0MDAxN10g
IERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAwMDAwIFNTOiAwMDY4ClsgICAzNC43
NDAwMTddIENSMDogODAwNTAwM2IgQ1IyOiA3NzViYjY4MCBDUjM6IDEzMzEwMDAwIENSNDog
MDAwMDA2YjAKWyAgIDM0Ljc0MDAxN10gRFIwOiAwOGUzZTcyOCBEUjE6IDAwMDAwMDAwIERS
MjogMDAwMDAwMDAgRFIzOiAwMDAwMDAwMApbICAgMzQuNzQwMDE3XSBEUjY6IGZmZmYwZmYw
IERSNzogMDAwMDA2MDAKWyAgIDM0Ljc0MDAxN10gU3RhY2s6ClsgICAzNC43NDAwMTddICA4
MDA1OWY4MCA4MTAwNzhiYyA4MDA1OWY4OCA4MTAwN2RkMCA4MDA1OWY5NCA4MTA0ZGY0NCAw
MTAwMDgwMCA4MDA1OWZhOApbICAgMzQuNzQwMDE3XSAgODEwMTJjODggMDAwMDAwMDEgMDAw
MDAwMDAgODAwNTlmYmMgMDAwMDAwMDAgMDAwMDAwMDAgMDAyMDAwMDIgMDAwMDAwMDAKWyAg
IDM0Ljc0MDAxN10gIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAw
MDAwIDAwMDAwMDAwIDAwMDAwMDdiIDAwMDAwMDdiClsgICAzNC43NDAwMTddIENhbGwgVHJh
Y2U6ClsgICAzNC43NDAwMTddICBbPDgxMDA3OGJjPl0gZGVmYXVsdF9pZGxlKzB4OC8weGIK
WyAgIDM0Ljc0MDAxN10gIFs8ODEwMDdkZDA+XSBhcmNoX2NwdV9pZGxlKzB4OS8weGIKWyAg
IDM0Ljc0MDAxN10gIFs8ODEwNGRmNDQ+XSBjcHVfc3RhcnR1cF9lbnRyeSsweGIyLzB4MTM0
ClsgICAzNC43NDAwMTddICBbPDgxMDEyYzg4Pl0gc3RhcnRfc2Vjb25kYXJ5KzB4MjAyLzB4
MjBiClsgICAzNC43NDAwMTddIENvZGU6IDBmIDIyIGUwIDVkIGMzIDU1IDg5IGU1IDBmIDA5
IDVkIGMzIDU1IDg5IGU1IDljIDU4IDVkIGMzIDU1IDg5IGU1IDUwIDlkIDVkIGMzIDU1IDg5
IGU1IGZhIDVkIGMzIDU1IDg5IGU1IGZiIDVkIGMzIDU1IDg5IGU1IGZiIGY0IDw1ZD4gYzMg
NTUgODkgZTUgZjQgNWQgYzMgNTUgODkgZTUgNTcgODkgYzcgNTYgODkgY2UgNTMgNTMgODkg
NTUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMDYyMDEwLzhkMDZkMzliMmQ5NWMx
YzNmMTBjZTNkMTk2OWUxZTM4MTkzNWJiYWYvZG1lc2ctcXVhbnRhbC1iZW5zLTc6MjAxNDAz
MDYyMTQyMzY6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MjAxMDozLjE0LjAtcmM1LTAyOTcw
LWc4ZDA2ZDM5OjI3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MjAxMC84ZDA2
ZDM5YjJkOTVjMWMzZjEwY2UzZDE5NjllMWUzODE5MzViYmFmL2RtZXNnLXlvY3RvLWJlbnMt
NDoyMDE0MDMwNjIxNDIzMzppMzg2LXJhbmRjb25maWctYmExLTAzMDYyMDEwOjMuMTQuMC1y
YzUtMDI5NzAtZzhkMDZkMzk6MjcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMDYy
MDEwLzhkMDZkMzliMmQ5NWMxYzNmMTBjZTNkMTk2OWUxZTM4MTkzNWJiYWYvZG1lc2cteW9j
dG8tYmVucy02OjIwMTQwMzA2MjE0MjUzOmkzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjIwMTA6
My4xNC4wLXJjNS0wMjk3MC1nOGQwNmQzOToyNwoyOjM6MyBhbGxfZ29vZDpiYWQ6YWxsX2Jh
ZCBib290cwobWzE7MzVtMjAxNC0wMy0wNiAyMTo0MzoxNiBSRVBFQVQgQ09VTlQ6IDI2ICAj
IC9rZXJuZWwtdGVzdHMvbGludXg0L29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGlu
ZzogMTU3MCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTEg
c3RlcHMpCls2ODQ1YWYwMDkyMGU2YjBkNmUyNTJjNDQ3ODRhYWNhM2IwZDJmNDJmXSBNZXJn
ZSAnZHJtLWludGVsL2RybS1pbnRlbC1uaWdodGx5JyBpbnRvIGRldmVsLWhvdXJseS0yMDE0
MDMwNjE4CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVy
ZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4NC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVz
dHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYmExLTAzMDYyMDEwL2xpbnV4LWRl
dmVsOmRldmVsLWhvdXJseS0yMDE0MDMwNjE4OjY4NDVhZjAwOTIwZTZiMGQ2ZTI1MmM0NDc4
NGFhY2EzYjBkMmY0MmY6YmlzZWN0LWxpbnV4NAoKMjAxNC0wMy0wNi0yMTo0MzoxNyA2ODQ1
YWYwMDkyMGU2YjBkNmUyNTJjNDQ3ODRhYWNhM2IwZDJmNDJmIGNvbXBpbGluZwo3MiByZWFs
ICAxMTQzIHVzZXIgIDExNCBzeXMgIDE3MzYuMjUlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWJh
MS0wMzA2MjAxMAoKMjAxNC0wMy0wNi0yMTo0NDo0MyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAz
LjE0LjAtcmM1LTAyNTAwLWc2ODQ1YWYwLi4uLi4JNAk2CTgJOQkxNwkyMAkyNiBTVUNDRVNT
CgpCaXNlY3Rpbmc6IDQ3MCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgOSBzdGVwcykKW2U1YTE2YTlkYmVjODg0NGJiZDRiMzViYTUyZmVmNWM1ZjIyZTFl
NmFdIE1lcmdlICdhdGg2a2wvYXRoLW5leHQtdGVzdCcgaW50byBkZXZlbC1ob3VybHktMjAx
NDAzMDYxOApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1
cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MjAxMC9saW51eC1k
ZXZlbDpkZXZlbC1ob3VybHktMjAxNDAzMDYxODplNWExNmE5ZGJlYzg4NDRiYmQ0YjM1YmE1
MmZlZjVjNWYyMmUxZTZhOmJpc2VjdC1saW51eDQKCjIwMTQtMDMtMDYtMjE6NTA6NDMgZTVh
MTZhOWRiZWM4ODQ0YmJkNGIzNWJhNTJmZWY1YzVmMjJlMWU2YSBjb21waWxpbmcKMzcgcmVh
bCAgMzc0IHVzZXIgIDM2IHN5cyAgMTA5MS42OCUgY3B1IAlpMzg2LXJhbmRjb25maWctYmEx
LTAzMDYyMDEwCgoyMDE0LTAzLTA2LTIxOjUxOjM1IGRldGVjdGluZyBib290IHN0YXRlIDMu
MTQuMC1yYzUtMDI3NjgtZ2U1YTE2YTkuLi4JMy4JNgk3CTkJMTQJMTguLi4JMjAuLi4uLi4u
LgkyMS4uLgkyNiBTVUNDRVNTCgpCaXNlY3Rpbmc6IDIwMiByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOCBzdGVwcykKWzVjNzA5YjBkOGFiYzVkYWM0ZDcz
MjNmZTZlM2ZkYzhlNmM0ZDBlNTldIE1lcmdlICd0aXAveDg2L2VmaScgaW50byBkZXZlbC1o
b3VybHktMjAxNDAzMDYxOApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdApscyAtYSAv
a2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MjAx
MC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAzMDYxODo1YzcwOWIwZDhhYmM1ZGFj
NGQ3MzIzZmU2ZTNmZGM4ZTZjNGQwZTU5OmJpc2VjdC1saW51eDQKCjIwMTQtMDMtMDYtMjI6
MDU6MDYgNWM3MDliMGQ4YWJjNWRhYzRkNzMyM2ZlNmUzZmRjOGU2YzRkMGU1OSBjb21waWxp
bmcKNzQgcmVhbCAgMTE1MCB1c2VyICAxMTggc3lzICAxNjk4LjU1JSBjcHUgCWkzODYtcmFu
ZGNvbmZpZy1iYTEtMDMwNjIwMTAKCjIwMTQtMDMtMDYtMjI6MDY6MzMgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgMy4xNC4wLXJjNS0wMjgxNS1nNWM3MDliMC4uLgk5CTE0CTI0CTI2IFNVQ0NF
U1MKCkJpc2VjdGluZzogMTU1IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAo
cm91Z2hseSA4IHN0ZXBzKQpbZmJlOTM4ZTRmNmM4MzdjYTE3YzI4NGMwMDFiNDNiYjIxZDVj
YTM4OV0gTWVyZ2UgJ2FybS1zb2MvbmV4dC9kcml2ZXJzJyBpbnRvIGRldmVsLWhvdXJseS0y
MDE0MDMwNjE4CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4NC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYmExLTAzMDYyMDEwL2xpbnV4
LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMwNjE4OmZiZTkzOGU0ZjZjODM3Y2ExN2MyODRj
MDAxYjQzYmIyMWQ1Y2EzODk6YmlzZWN0LWxpbnV4NAoKMjAxNC0wMy0wNi0yMjoxMDowMyBm
YmU5MzhlNGY2YzgzN2NhMTdjMjg0YzAwMWI0M2JiMjFkNWNhMzg5IGNvbXBpbGluZwoxNiBy
ZWFsICAzMiB1c2VyICA1IHN5cyAgMjE5LjQzJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1iYTEt
MDMwNjIwMTAKCjIwMTQtMDMtMDYtMjI6MTA6MzMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4x
NC4wLXJjNS0wMjg2NS1nZmJlOTM4ZS4uLgkyNiBTVUNDRVNTCgpsaW5lYXItYmlzZWN0OiBi
YWQgYnJhbmNoIG1heSBiZSByY3UvcmN1L2RldgpsaW5lYXItYmlzZWN0OiBoYW5kbGUgb3Zl
ciB0byBnaXQgYmlzZWN0CmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3Qgc3RhcnQgOGQwNmQz
OWIyZDk1YzFjM2YxMGNlM2QxOTY5ZTFlMzgxOTM1YmJhZiBmYmU5MzhlNGY2YzgzN2NhMTdj
Mjg0YzAwMWI0M2JiMjFkNWNhMzg5IC0tCkJpc2VjdGluZzogNTIgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDYgc3RlcHMpCltiNDZmMzU4YWU1ZTM1NThh
OTA3MmYwMzU0MTI4ZDU3NDlhNTg0ZDAxXSByY3V0b3J0dXJlOiBQbGFjZSBrdm0tdGVzdC0x
LXJ1bi5zaCBvdXRwdXQgaW50byByZXMgZGlyZWN0b3J5CmxpbmVhci1iaXNlY3Q6IGdpdCBi
aXNlY3QgcnVuIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2tlcm5lbC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdApydW5uaW5nIC9jL2tlcm5lbC10ZXN0
cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDQvb2Jq
LWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLWJhMS0wMzA2MjAxMC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAzMDYxODpi
NDZmMzU4YWU1ZTM1NThhOTA3MmYwMzU0MTI4ZDU3NDlhNTg0ZDAxOmJpc2VjdC1saW51eDQK
CjIwMTQtMDMtMDYtMjI6MTI6MzUgYjQ2ZjM1OGFlNWUzNTU4YTkwNzJmMDM1NDEyOGQ1NzQ5
YTU4NGQwMSBjb21waWxpbmcKNzQgcmVhbCAgMTE0MSB1c2VyICAxMTIgc3lzICAxNjg1LjMz
JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjIwMTAKCjIwMTQtMDMtMDYtMjI6MTQ6
MDQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjMy0wMDA1Mi1nYjQ2ZjM1OC4uLgkx
MQkxNQkyMAkyNAkyNiBTVUNDRVNTCgpCaXNlY3Rpbmc6IDI2IHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA1IHN0ZXBzKQpbZjU2MDRmNjdmZThjYmQ2ZjIw
ODhiMjBiOTQ2M2Y3MjFhYTYxM2Q0Yl0gTWVyZ2UgYnJhbmNoICd0b3J0dXJlLjIwMTQuMDIu
MjNhJyBpbnRvIEhFQUQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg0L29iai1iaXNlY3QKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjIwMTAv
bGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzA2MTg6ZjU2MDRmNjdmZThjYmQ2ZjIw
ODhiMjBiOTQ2M2Y3MjFhYTYxM2Q0YjpiaXNlY3QtbGludXg0CgoyMDE0LTAzLTA2LTIyOjE4
OjA1IGY1NjA0ZjY3ZmU4Y2JkNmYyMDg4YjIwYjk0NjNmNzIxYWE2MTNkNGIgY29tcGlsaW5n
CjE0NSByZWFsICAxMTMzIHVzZXIgIDExMCBzeXMgIDg1Ni4zNyUgY3B1IAlpMzg2LXJhbmRj
b25maWctYmExLTAzMDYyMDEwCgoyMDE0LTAzLTA2LTIyOjIwOjQzIGRldGVjdGluZyBib290
IHN0YXRlIDMuMTQuMC1yYzMtMDAwNzgtZ2Y1NjA0ZjYuLi4uLi4JMgkxMgkyNiBTVUNDRVNT
CgpCaXNlY3Rpbmc6IDEzIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSA0IHN0ZXBzKQpbZGQzNWI4MWMzNDFjNjg1YmFmZDE1YmM5YTZiZmE3OTU4NGUwN2Iw
N10gdG9ydHVyZTogUmVuYW1lIFJDVV9CVUlMRE9OTFkgdG8gVE9SVFVSRV9CVUlMRE9OTFkK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9r
ZXJuZWwtdGVzdHMvbGludXg0L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjIwMTAvbGludXgtZGV2ZWw6ZGV2
ZWwtaG91cmx5LTIwMTQwMzA2MTg6ZGQzNWI4MWMzNDFjNjg1YmFmZDE1YmM5YTZiZmE3OTU4
NGUwN2IwNzpiaXNlY3QtbGludXg0CgoyMDE0LTAzLTA2LTIyOjI1OjEzIGRkMzViODFjMzQx
YzY4NWJhZmQxNWJjOWE2YmZhNzk1ODRlMDdiMDcgY29tcGlsaW5nCjY4IHJlYWwgIDExMzEg
dXNlciAgMTEzIHN5cyAgMTgyMC43OCUgY3B1IAlpMzg2LXJhbmRjb25maWctYmExLTAzMDYy
MDEwCgoyMDE0LTAzLTA2LTIyOjI2OjM0IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1y
YzMtMDAwOTEtZ2RkMzViODEuLi4uCTUJMjUJMjYgU1VDQ0VTUwoKQmlzZWN0aW5nOiA2IHJl
dmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbODg2
NGYwOTk2ZThiN2YwN2E1MzZhYTA3NTUzYzQ0NjFjZDVmNDIxMV0gdG9ydHVyZTogTWFrZSAi
LS1kcnlydW4gc2NyaXB0IiBvdXRwdXQgc2VsZi1zdWZmaWNpZW50CnJ1bm5pbmcgL2Mva2Vy
bmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xp
bnV4NC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWctYmExLTAzMDYyMDEwL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0
MDMwNjE4Ojg4NjRmMDk5NmU4YjdmMDdhNTM2YWEwNzU1M2M0NDYxY2Q1ZjQyMTE6YmlzZWN0
LWxpbnV4NAoKMjAxNC0wMy0wNi0yMjozMDowNSA4ODY0ZjA5OTZlOGI3ZjA3YTUzNmFhMDc1
NTNjNDQ2MWNkNWY0MjExIGNvbXBpbGluZwoxMyByZWFsICAyNyB1c2VyICA0IHN5cyAgMjQ5
LjEyJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjIwMTAKCjIwMTQtMDMtMDYtMjI6
MzA6MzEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjMy0wMDA5OC1nODg2NGYwOS4u
LgkyCTEzCTI2IFNVQ0NFU1MKCkJpc2VjdGluZzogMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0
IGFmdGVyIHRoaXMgKHJvdWdobHkgMiBzdGVwcykKW2IyZDc3N2E2ZDlkNjQ5MjliOTcwMWYx
OTA1ZmRlZGE4ZmMzY2IxNmRdIHJjdXRvcnR1cmU6IFByaW50IG5lZ2F0aXZlcyBmb3IgU1JD
VSBjb3VudGVyIHdyYXBhcm91bmQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg0L29iai1iaXNlY3QKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMw
NjIwMTAvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzA2MTg6YjJkNzc3YTZkOWQ2
NDkyOWI5NzAxZjE5MDVmZGVkYThmYzNjYjE2ZDpiaXNlY3QtbGludXg0CgoyMDE0LTAzLTA2
LTIyOjMzOjMxIGIyZDc3N2E2ZDlkNjQ5MjliOTcwMWYxOTA1ZmRlZGE4ZmMzY2IxNmQgY29t
cGlsaW5nCjE0IHJlYWwgIDI4IHVzZXIgIDQgc3lzICAyMjMuMTclIGNwdSAJaTM4Ni1yYW5k
Y29uZmlnLWJhMS0wMzA2MjAxMAoKMjAxNC0wMy0wNi0yMjozNDowMSBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAzLjE0LjAtcmMzLTAwMTAxLWdiMmQ3NzdhLi4JMwkxNQkyMwkyNQkyNiBTVUND
RVNTCgpCaXNlY3Rpbmc6IDEgcmV2aXNpb24gbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgMSBzdGVwKQpbNGM3OWQ3ZDg5OTAyYTJlOWM5NmIzZGI1MTE1YWY1MmIzY2Y5NGRh
OV0gdG9ydHVyZTogUmVwb3J0IGRpYWdub3N0aWNzIGZyb20gcWVtdQpydW5uaW5nIC9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9s
aW51eDQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4
Ni1yYW5kY29uZmlnLWJhMS0wMzA2MjAxMC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAx
NDAzMDYxODo0Yzc5ZDdkODk5MDJhMmU5Yzk2YjNkYjUxMTVhZjUyYjNjZjk0ZGE5OmJpc2Vj
dC1saW51eDQKCjIwMTQtMDMtMDYtMjI6Mzc6MzYgNGM3OWQ3ZDg5OTAyYTJlOWM5NmIzZGI1
MTE1YWY1MmIzY2Y5NGRhOSBjb21waWxpbmcKMTUgcmVhbCAgMjkgdXNlciAgNCBzeXMgIDIx
NS44NSUgY3B1IAlpMzg2LXJhbmRjb25maWctYmExLTAzMDYyMDEwCgoyMDE0LTAzLTA2LTIy
OjM4OjIwIGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzMtMDAxMDMtZzRjNzlkN2Qu
Li4JMTQuLi4uLi4JMjYgU1VDQ0VTUwoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAwIHN0ZXBzKQpbMWY5YzI2OTY4ZTFhNTAxZjNh
ODM5NjAzYzk2MzNmMjFhYmNhNjViM10gdG9ydHVyZTogSW5jcmVhc2Ugc3R1dHRlci1lbmQg
aW50ZW5zaXR5CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4NC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYmExLTAzMDYyMDEwL2xpbnV4
LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMwNjE4OjFmOWMyNjk2OGUxYTUwMWYzYTgzOTYw
M2M5NjMzZjIxYWJjYTY1YjM6YmlzZWN0LWxpbnV4NAoKMjAxNC0wMy0wNi0yMjo0Mzo1MCAx
ZjljMjY5NjhlMWE1MDFmM2E4Mzk2MDNjOTYzM2YyMWFiY2E2NWIzIGNvbXBpbGluZwo0MCBy
ZWFsICAyOCB1c2VyICA1IHN5cyAgODIuMjMlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWJhMS0w
MzA2MjAxMAoKMjAxNC0wMy0wNi0yMjo0NDo1NiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0
LjAtcmMzLTAwMTA0LWcxZjljMjY5Li4uCTEuLgkyCTQuIFRFU1QgRkFJTFVSRQoqKiogZ2xp
YmMgZGV0ZWN0ZWQgKioqIC90cmluaXR5OiBkb3VibGUgZnJlZSBvciBjb3JydXB0aW9uIChv
dXQpOiAweDA4Zjk0MDAwICoqKgpbbWFpbl0gUmFuZG9tIHJlc2VlZDogOTI0Mzc3MDExCltj
aGlsZDA6MzIyXSB1aWQgY2hhbmdlZCEgV2FzOiAwLCBub3cgODUyMgpbICAgNDMuMDIwMDE4
XSBJTkZPOiByY3Vfc2NoZWQgc2VsZi1kZXRlY3RlZCBzdGFsbCBvbiBDUFUKWyAgIDQzLjAy
MDAxOF0gClsgICA0My4wMjAwMThdIApbICAgNDMuMDIwMDE4XSBzZW5kaW5nIE5NSSB0byBh
bGwgQ1BVczoKWyAgIDQzLjAyMDAxOF0gTk1JIGJhY2t0cmFjZSBmb3IgY3B1IDEKWyAgIDQz
LjAyMDAxOF0gQ1BVOiAxIFBJRDogNDUgQ29tbTogbG9ja190b3J0dXJlX3dyIE5vdCB0YWlu
dGVkIDMuMTQuMC1yYzMtMDAxMDQtZzFmOWMyNjkgIzM4ClsgICA0My4wMjAwMThdIEhhcmR3
YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgIDQzLjAy
MDAxOF0gdGFzazogODAxNWEwMDAgdGk6IDgwMTVjMDAwIHRhc2sudGk6IDgwMTVjMDAwClsg
ICA0My4wMjAwMThdIEVJUDogMDA2MDpbPDgxMDE0YzVjPl0gRUZMQUdTOiAwMDAxMDA0NiBD
UFU6IDEKWyAgIDQzLjAyMDAxOF0gRUlQIGlzIGF0IG5hdGl2ZV9hcGljX21lbV93cml0ZSsw
eDEyLzB4MTQKWyAgIDQzLjAyMDAxOF0gRUFYOiBmZmZmYTMwMCBFQlg6IDAwMDAwMDAyIEVD
WDogZmZmZmYwMDAgRURYOiAwMDAwMGMwMApbICAgNDMuMDIwMDE4XSBFU0k6IDAwMDAwYzAw
IEVESTogMDMwMDAwMDAgRUJQOiA4MDE1ZGRhNCBFU1A6IDgwMTVkZGE0ClsgICA0My4wMjAw
MThdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDAwMCBTUzogMDA2OApbICAg
NDMuMDIwMDE4XSBDUjA6IDgwMDUwMDNiIENSMjogNDdlZTUzODAgQ1IzOiAwMWE2NDAwMCBD
UjQ6IDAwMDAwNmIwClsgICA0My4wMjAwMThdIFN0YWNrOgpbICAgNDMuMDIwMDE4XSAgODAx
NWRkYjggODEwMTRjZGIgMDAwMDAwMDYgMDAwMDAwMDMgMDAwMDAwMDIgODAxNWRkY2MgODEw
MTRmMGUgMDAwMDI3MTAKWyAgIDQzLjAyMDAxOF0gIDhmOGI1YTU0IDAwMDAzZWE5IDgwMTVk
ZGQ0IDgxMDE0ZjdmIDgwMTVkZGU0IDgxMDE1MGI0IDgxNzJmNzQ1IDgxODEyYjAwClsgICA0
My4wMjAwMThdICA4MDE1ZGUyMCA4MTA1ZTdjZSA4MTczOGUzYiAwMDAwMDgzNCBmZmZmZmYx
NSBmZmZmZmYxNCAwMDAwM2VhOSA4MTA0NjAxMQpbICAgNDMuMDIwMDE4XSBDYWxsIFRyYWNl
OgpbICAgNDMuMDIwMDE4XSAgWzw4MTAxNGNkYj5dIF9fZGVmYXVsdF9zZW5kX0lQSV9kZXN0
X2ZpZWxkKzB4NGMvMHg1MQpbICAgNDMuMDIwMDE4XSAgWzw4MTAxNGYwZT5dIGRlZmF1bHRf
c2VuZF9JUElfbWFza19sb2dpY2FsKzB4NDcvMHg1MwpbICAgNDMuMDIwMDE4XSAgWzw4MTAx
NGY3Zj5dIGRlZmF1bHRfc2VuZF9JUElfYWxsKzB4MjEvMHgzMgpbICAgNDMuMDIwMDE4XSAg
Wzw4MTAxNTBiND5dIGFyY2hfdHJpZ2dlcl9hbGxfY3B1X2JhY2t0cmFjZSsweDM4LzB4NjAK
WyAgIDQzLjAyMDAxOF0gIFs8ODEwNWU3Y2U+XSByY3VfY2hlY2tfY2FsbGJhY2tzKzB4MWEy
LzB4NDQ0ClsgICA0My4wMjAwMThdICBbPDgxMDQ2MDExPl0gPyBhY2NvdW50X3Byb2Nlc3Nf
dGljaysweGZlLzB4MTU0ClsgICA0My4wMjAwMThdICBbPDgxMDJlZjVkPl0gdXBkYXRlX3By
b2Nlc3NfdGltZXMrMHgyZC8weDUwClsgICA0My4wMjAwMThdICBbPDgxMDY2YTdjPl0gdGlj
a19zY2hlZF9oYW5kbGUrMHgzMC8weDMyClsgICA0My4wMjAwMThdICBbPDgxMDY3MDA3Pl0g
dGlja19zY2hlZF90aW1lcisweDJlLzB4NTMKWyAgIDQzLjAyMDAxOF0gIFs8ODEwM2NmM2I+
XSBfX3J1bl9ocnRpbWVyLmlzcmEuMTYrMHg1Ny8weGFiClsgICA0My4wMjAwMThdICBbPDgx
MDY2ZmQ5Pl0gPyB0aWNrX3NjaGVkX2RvX3RpbWVyKzB4MjgvMHgyOApbICAgNDMuMDIwMDE4
XSAgWzw4MTAzZDhjMT5dIGhydGltZXJfaW50ZXJydXB0KzB4ZjAvMHgxZWMKWyAgIDQzLjAy
MDAxOF0gIFs8ODEwNTQ5ZDA+XSA/IHRvcnR1cmVfbG9ja19idXN0ZWRfd3JpdGVfdW5sb2Nr
KzB4NS8weDUKWyAgIDQzLjAyMDAxOF0gIFs8ODEwMTNmMWU+XSBsb2NhbF9hcGljX3RpbWVy
X2ludGVycnVwdCsweDQxLzB4NDYKWyAgIDQzLjAyMDAxOF0gIFs8ODEwMTQxMjE+XSBzbXBf
YXBpY190aW1lcl9pbnRlcnJ1cHQrMHgyMC8weDJmClsgICA0My4wMjAwMThdICBbPDgxNTMy
NWE1Pl0gYXBpY190aW1lcl9pbnRlcnJ1cHQrMHgyZC8weDM0ClsgICA0My4wMjAwMThdICBb
PDgxMDU0OWQwPl0gPyB0b3J0dXJlX2xvY2tfYnVzdGVkX3dyaXRlX3VubG9jaysweDUvMHg1
ClsgICA0My4wMjAwMThdICBbPDgxMDIwMGQ4Pl0gPyBhZXNfZGVjX2JsaysweGI0MC8weGI2
YQpbICAgNDMuMDIwMDE4XSAgWzw4MTA3ODQxNz5dID8gc3R1dHRlcl93YWl0KzB4MjYvMHg1
YQpbICAgNDMuMDIwMDE4XSAgWzw4MTA1NGE4NT5dIGxvY2tfdG9ydHVyZV93cml0ZXIrMHhi
NS8weGQ5ClsgICA0My4wMjAwMThdICBbPDgxMDNiMDIyPl0ga3RocmVhZCsweDhlLzB4OTMK
WyAgIDQzLjAyMDAxOF0gIFs8ODE1MzI5Nzc+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4
MWIvMHgyOApbICAgNDMuMDIwMDE4XSAgWzw4MTAzYWY5ND5dID8gX19rdGhyZWFkX3Bhcmtt
ZSsweDUwLzB4NTAKWyAgIDQzLjAyMDAxOF0gQ29kZTogMDAgNWQgYzMgNTUgODkgZTUgNTAg
OWQgOGQgNzQgMjYgMDAgNWQgYzMgNTUgODkgZTUgZmEgOTAgOGQgNzQgMjYgMDAgNWQgYzMg
OGIgMGQgODQgZjcgODAgODEgNTUgODkgZTUgOGQgODQgMDggMDAgYjAgZmYgZmYgODkgMTAg
PDVkPiBjMyA1NSA4ZCA0OCAwMSA4OSBlNSA1MyA4OSBkMyA4OSBkOCBiYSAwOCAwMCAwMCAw
MCBlOCAwOCBlOAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjIwMTAvMWY5YzI2
OTY4ZTFhNTAxZjNhODM5NjAzYzk2MzNmMjFhYmNhNjViMy9kbWVzZy15b2N0by1hdGhlbnMt
Mzg6MjAxNDAzMDYyMjQ5MDk6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MjAxMDozLjE0LjAt
cmMzLTAwMTA0LWcxZjljMjY5OjM4CjQ6MToxIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3Rz
ChtbMTszNW0yMDE0LTAzLTA2IDIyOjQ5OjI3IFJFUEVBVCBDT1VOVDogNjAgICMgL2tlcm5l
bC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKMWY5YzI2OTY4ZTFhNTAx
ZjNhODM5NjAzYzk2MzNmMjFhYmNhNjViMyBpcyB0aGUgZmlyc3QgYmFkIGNvbW1pdApjb21t
aXQgMWY5YzI2OTY4ZTFhNTAxZjNhODM5NjAzYzk2MzNmMjFhYmNhNjViMwpBdXRob3I6IFBh
dWwgRS4gTWNLZW5uZXkgPHBhdWxtY2tAbGludXgudm5ldC5pYm0uY29tPgpEYXRlOiAgIFR1
ZSBNYXIgNCAxMTowMzoyMSAyMDE0IC0wODAwCgogICAgdG9ydHVyZTogSW5jcmVhc2Ugc3R1
dHRlci1lbmQgaW50ZW5zaXR5CiAgICAKICAgIEN1cnJlbnRseSwgYWxsIHN0dXR0ZXJlZCBr
dGhyZWFkcyBibG9jayBhIGppZmZ5IGF0IGEgdGltZSwgd2hpY2ggY2FuCiAgICByZXN1bHQg
aW4gdGhlbSBzdGFydGluZyBhdCBkaWZmZXJlbnQgdGltZXMuICAoTm90ZTogVGhpcyBpcyBu
b3QgYW4KICAgIGVuZXJneS1lZmZpY2llbmN5IHByb2JsZW0gdW5sZXNzIHlvdSBydW4gdG9y
dHVyZSB0ZXN0cyBpbiBwcm9kdWN0aW9uLAogICAgaW4gd2hpY2ggY2FzZSB5b3UgaGF2ZSBv
dGhlciBwcm9ibGVtcyEpICBUaGlzIGNvbW1pdCBpbmNyZWFzZXMgdGhlCiAgICBpbnRlbnNp
dHkgb2YgdGhlIHJlc3RhcnQgZXZlbnQgYnkgY2F1c2luZyBrdGhyZWFkcyB0byBzcGluIHRo
cm91Z2ggdGhlCiAgICBsYXN0IGppZmZ5LCByZXN0YXJ0aW5nIHdoZW4gdGhleSBzZWUgdGhl
IHZhcmlhYmxlIGNoYW5nZS4KICAgIAogICAgU2lnbmVkLW9mZi1ieTogUGF1bCBFLiBNY0tl
bm5leSA8cGF1bG1ja0BsaW51eC52bmV0LmlibS5jb20+Cgo6MDQwMDAwIDA0MDAwMCA0OGM0
NjM1OGFjNDBhM2ZmOWU0YmViNGVjOWMzMzQzNzIyYzIwZjVlIGRhNTQ2MTkyMzc2YzdkMGNi
ZWIwODYxMGUxNTY2MTFjYWQ4NmNiZjYgTQlrZXJuZWwKYmlzZWN0IHJ1biBzdWNjZXNzCmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYmExLTAz
MDYyMDEwL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMwNjE4OjRjNzlkN2Q4OTkw
MmEyZTljOTZiM2RiNTExNWFmNTJiM2NmOTRkYTk6YmlzZWN0LWxpbnV4NAoKMjAxNC0wMy0w
Ni0yMjo0OToyOSA0Yzc5ZDdkODk5MDJhMmU5Yzk2YjNkYjUxMTVhZjUyYjNjZjk0ZGE5IHJl
dXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MjAxMC80Yzc5ZDdkODk5MDJh
MmU5Yzk2YjNkYjUxMTVhZjUyYjNjZjk0ZGE5L3ZtbGludXotMy4xNC4wLXJjMy0wMDEwMy1n
NGM3OWQ3ZAoKMjAxNC0wMy0wNi0yMjo0OToyOSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4u
Li4uCTEJOAkyMgkzNQk0Mgk1OAk3MQk5MQkxMDcJMTE5CTE0MAkxNTkJMTc1Li4JMTc2Li4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMTc3Li4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLhtbMTszNW0yMDE0LTAzLTA3IDAyOjE2OjQyIGFkZF90b19ydW5fcXVl
dWUgMxtbMG0KLi4uCTE4MCBTVUNDRVNTCgpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MjAxMC9saW51eC1kZXZlbDpkZXZlbC1o
b3VybHktMjAxNDAzMDYxODpkNDc4YTk2MGVkZjFlYTYxY2EzMWEwN2E0OGE4NzcxZjA0M2Ri
YTc4OmJpc2VjdC1saW51eDQKIFRFU1QgRkFJTFVSRQpbICAgIDguOTYwMTE2XSBkZXRlY3Qg
ZmFpbGVkLCBjaGlwIG5vdCBkZXRlY3RlZCEKWyAgICA4Ljk2MDExNl0gZGV0ZWN0IGZhaWxl
ZCwgY2hpcCBub3QgZGV0ZWN0ZWQhCgpCVUc6IGtlcm5lbCBib290IGhhbmcKRWxhcHNlZCB0
aW1lOiA2MjUKcWVtdS1zeXN0ZW0teDg2XzY0IC1jcHUga3ZtNjQgLWVuYWJsZS1rdm0gLWtl
cm5lbCAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjIwMTAvZDQ3OGE5NjBlZGYx
ZWE2MWNhMzFhMDdhNDhhODc3MWYwNDNkYmE3OC92bWxpbnV6LTMuMTQuMC1yYzUtMDM3NjUt
Z2Q0NzhhOTYgLWFwcGVuZCAnaHVuZ190YXNrX3BhbmljPTEgZWFybHlwcmludGs9dHR5UzAs
MTE1MjAwIGRlYnVnIGFwaWM9ZGVidWcgc3lzcnFfYWx3YXlzX2VuYWJsZWQgcGFuaWM9MTAg
c29mdGxvY2t1cF9wYW5pYz0xIG5taV93YXRjaGRvZz1wYW5pYyAgcHJvbXB0X3JhbWRpc2s9
MCBjb25zb2xlPXR0eVMwLDExNTIwMCBjb25zb2xlPXR0eTAgdmdhPW5vcm1hbCAgcm9vdD0v
ZGV2L3JhbTAgcncgbGluaz0va2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5k
Y29uZmlnLWJhMS0wMzA2MjAxMC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAzMDYx
ODpkNDc4YTk2MGVkZjFlYTYxY2EzMWEwN2E0OGE4NzcxZjA0M2RiYTc4OmJpc2VjdC1saW51
eDQvLnZtbGludXotZDQ3OGE5NjBlZGYxZWE2MWNhMzFhMDdhNDhhODc3MWYwNDNkYmE3OC0y
MDE0MDMwNjIxMjAzOC0xMC1iZW5zIGJyYW5jaD1saW51eC1kZXZlbC9kZXZlbC1ob3VybHkt
MjAxNDAzMDYxOCBCT09UX0lNQUdFPS9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2
MjAxMC9kNDc4YTk2MGVkZjFlYTYxY2EzMWEwN2E0OGE4NzcxZjA0M2RiYTc4L3ZtbGludXot
My4xNC4wLXJjNS0wMzc2NS1nZDQ3OGE5NicgIC1pbml0cmQgL2tlcm5lbC10ZXN0cy9pbml0
cmQvcXVhbnRhbC1jb3JlLWkzODYuY2d6IC1tIDMyMCAtc21wIDIgLW5ldCBuaWMsdmxhbj0x
LG1vZGVsPWUxMDAwIC1uZXQgdXNlcix2bGFuPTEsaG9zdGZ3ZD10Y3A6OjU0NTAtOjIyIC1i
b290IG9yZGVyPW5jIC1uby1yZWJvb3QgLXdhdGNoZG9nIGk2MzAwZXNiIC1ydGMgYmFzZT1s
b2NhbHRpbWUgLWRyaXZlIGZpbGU9L2ZzL3NkYTcvZGlzazAtcXVhbnRhbC1iZW5zLTEsbWVk
aWE9ZGlzayxpZj12aXJ0aW8gLWRyaXZlIGZpbGU9L2ZzL3NkYTcvZGlzazEtcXVhbnRhbC1i
ZW5zLTEsbWVkaWE9ZGlzayxpZj12aXJ0aW8gLWRyaXZlIGZpbGU9L2ZzL3NkYTcvZGlzazIt
cXVhbnRhbC1iZW5zLTEsbWVkaWE9ZGlzayxpZj12aXJ0aW8gLWRyaXZlIGZpbGU9L2ZzL3Nk
YTcvZGlzazMtcXVhbnRhbC1iZW5zLTEsbWVkaWE9ZGlzayxpZj12aXJ0aW8gLWRyaXZlIGZp
bGU9L2ZzL3NkYTcvZGlzazQtcXVhbnRhbC1iZW5zLTEsbWVkaWE9ZGlzayxpZj12aXJ0aW8g
LWRyaXZlIGZpbGU9L2ZzL3NkYTcvZGlzazUtcXVhbnRhbC1iZW5zLTEsbWVkaWE9ZGlzayxp
Zj12aXJ0aW8gLXBpZGZpbGUgL2Rldi9zaG0va2Jvb3QvcGlkLXF1YW50YWwtYmVucy0xIC1z
ZXJpYWwgZmlsZTovZGV2L3NobS9rYm9vdC9zZXJpYWwtcXVhbnRhbC1iZW5zLTEgLWRhZW1v
bml6ZSAtZGlzcGxheSBub25lIC1tb25pdG9yIG51bGwgCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWJhMS0wMzA2MjAxMC9kNDc4YTk2MGVkZjFlYTYxY2EzMWEwN2E0OGE4NzcxZjA0M2Ri
YTc4L2RtZXNnLXF1YW50YWwteHBzLTI6MjAxNDAzMDYyMDUyMDI6aTM4Ni1yYW5kY29uZmln
LWJhMS0wMzA2MjAxMDozLjE0LjAtcmM1LTAzNzY1LWdkNDc4YTk2OjEKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYmExLTAzMDYyMDEwL2Q0NzhhOTYwZWRmMWVhNjFjYTMxYTA3YTQ4YTg3
NzFmMDQzZGJhNzgvZG1lc2ctcXVhbnRhbC14aWFuLTU6MjAxNDAzMDYyMDUxMzk6aTM4Ni1y
YW5kY29uZmlnLWJhMS0wMzA2MjAxMDozLjE0LjAtcmM1LTAzNzY1LWdkNDc4YTk2OjEKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMDYyMDEwL2Q0NzhhOTYwZWRmMWVhNjFjYTMx
YTA3YTQ4YTg3NzFmMDQzZGJhNzgvZG1lc2cteW9jdG8teGd3by0zOjIwMTQwMzA2MjA1MTU1
OmkzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjIwMTA6My4xNC4wLXJjNS0wMzc2NS1nZDQ3OGE5
NjoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MjAxMC9kNDc4YTk2MGVkZjFl
YTYxY2EzMWEwN2E0OGE4NzcxZjA0M2RiYTc4L2RtZXNnLXF1YW50YWwtaW5uLTQ6MjAxNDAz
MDYyMTI2MDg6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MjAxMDo6Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWJhMS0wMzA2MjAxMC9kNDc4YTk2MGVkZjFlYTYxY2EzMWEwN2E0OGE4Nzcx
ZjA0M2RiYTc4L2RtZXNnLXlvY3RvLXJvYW0tNDE6MjAxNDAzMDYyMDUyMDI6aTM4Ni1yYW5k
Y29uZmlnLWJhMS0wMzA2MjAxMDozLjE0LjAtcmM1LTAzNzY1LWdkNDc4YTk2OjEKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctYmExLTAzMDYyMDEwL2Q0NzhhOTYwZWRmMWVhNjFjYTMxYTA3
YTQ4YTg3NzFmMDQzZGJhNzgvZG1lc2cteW9jdG8taW5uLTU6MjAxNDAzMDYyMTI2MTE6aTM4
Ni1yYW5kY29uZmlnLWJhMS0wMzA2MjAxMDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJh
MS0wMzA2MjAxMC9kNDc4YTk2MGVkZjFlYTYxY2EzMWEwN2E0OGE4NzcxZjA0M2RiYTc4L2Rt
ZXNnLXF1YW50YWwteHBzLTY6MjAxNDAzMDYyMDUyMDI6aTM4Ni1yYW5kY29uZmlnLWJhMS0w
MzA2MjAxMDozLjE0LjAtcmM1LTAzNzY1LWdkNDc4YTk2OjEKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYmExLTAzMDYyMDEwL2Q0NzhhOTYwZWRmMWVhNjFjYTMxYTA3YTQ4YTg3NzFmMDQz
ZGJhNzgvZG1lc2cteW9jdG8teHBzLTU6MjAxNDAzMDYyMDUyMDI6aTM4Ni1yYW5kY29uZmln
LWJhMS0wMzA2MjAxMDozLjE0LjAtcmM1LTAzNzY1LWdkNDc4YTk2OjEKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYmExLTAzMDYyMDEwL2Q0NzhhOTYwZWRmMWVhNjFjYTMxYTA3YTQ4YTg3
NzFmMDQzZGJhNzgvZG1lc2cteW9jdG8tYmVucy02OjIwMTQwMzA2MjEyNTQ2OmkzODYtcmFu
ZGNvbmZpZy1iYTEtMDMwNjIwMTA6My4xNC4wLXJjNS0wMzc2NS1nZDQ3OGE5NjoxCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MjAxMC9kNDc4YTk2MGVkZjFlYTYxY2EzMWEw
N2E0OGE4NzcxZjA0M2RiYTc4L2RtZXNnLXlvY3RvLXhwcy01OjIwMTQwMzA2MjEyNjM5Omkz
ODYtcmFuZGNvbmZpZy1iYTEtMDMwNjIwMTA6My4xNC4wLXJjNS0wMzc2NS1nZDQ3OGE5Njox
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MjAxMC9kNDc4YTk2MGVkZjFlYTYx
Y2EzMWEwN2E0OGE4NzcxZjA0M2RiYTc4L2RtZXNnLXF1YW50YWwtaW5uLTI3OjIwMTQwMzA2
MjEyNzA4OmkzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjIwMTA6Ogova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1iYTEtMDMwNjIwMTAvZDQ3OGE5NjBlZGYxZWE2MWNhMzFhMDdhNDhhODc3MWYw
NDNkYmE3OC9kbWVzZy1xdWFudGFsLXhnd28tNToyMDE0MDMwNjIwNTEzOTppMzg2LXJhbmRj
b25maWctYmExLTAzMDYyMDEwOjMuMTQuMC1yYzUtMDM3NjUtZ2Q0NzhhOTY6MQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjIwMTAvZDQ3OGE5NjBlZGYxZWE2MWNhMzFhMDdh
NDhhODc3MWYwNDNkYmE3OC9kbWVzZy15b2N0by1iZW5zLTE6MjAxNDAzMDYyMDUxMzQ6aTM4
Ni1yYW5kY29uZmlnLWJhMS0wMzA2MjAxMDozLjE0LjAtcmM1LTAzNzY1LWdkNDc4YTk2OjEK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMDYyMDEwL2Q0NzhhOTYwZWRmMWVhNjFj
YTMxYTA3YTQ4YTg3NzFmMDQzZGJhNzgvZG1lc2cteW9jdG8tcm9hbS0zNDoyMDE0MDMwNjIw
NTIwMjppMzg2LXJhbmRjb25maWctYmExLTAzMDYyMDEwOjMuMTQuMC1yYzUtMDM3NjUtZ2Q0
NzhhOTY6MQoyOjE0OjE3IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpbZGV0YWNoZWQg
SEVBRCAxZmE0ODgxXSBSZXZlcnQgInRvcnR1cmU6IEluY3JlYXNlIHN0dXR0ZXItZW5kIGlu
dGVuc2l0eSIKIENvbW1pdHRlcjogV3UgRmVuZ2d1YW5nIDxrYnVpbGRAYmVlPgpZb3VyIG5h
bWUgYW5kIGVtYWlsIGFkZHJlc3Mgd2VyZSBjb25maWd1cmVkIGF1dG9tYXRpY2FsbHkgYmFz
ZWQKb24geW91ciB1c2VybmFtZSBhbmQgaG9zdG5hbWUuIFBsZWFzZSBjaGVjayB0aGF0IHRo
ZXkgYXJlIGFjY3VyYXRlLgpZb3UgY2FuIHN1cHByZXNzIHRoaXMgbWVzc2FnZSBieSBzZXR0
aW5nIHRoZW0gZXhwbGljaXRseToKCiAgICBnaXQgY29uZmlnIC0tZ2xvYmFsIHVzZXIubmFt
ZSAiWW91ciBOYW1lIgogICAgZ2l0IGNvbmZpZyAtLWdsb2JhbCB1c2VyLmVtYWlsIHlvdUBl
eGFtcGxlLmNvbQoKQWZ0ZXIgZG9pbmcgdGhpcywgeW91IG1heSBmaXggdGhlIGlkZW50aXR5
IHVzZWQgZm9yIHRoaXMgY29tbWl0IHdpdGg6CgogICAgZ2l0IGNvbW1pdCAtLWFtZW5kIC0t
cmVzZXQtYXV0aG9yCgogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMTAgZGVs
ZXRpb25zKC0pCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWctYmExLTAzMDYyMDEwL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMwNjE4
OjFmYTQ4ODFiMjdhYTc4NWY2NjdhM2NmODMzYTdiNjg4YjZkNzA2NmU6YmlzZWN0LWxpbnV4
NAoKMjAxNC0wMy0wNy0wMjoxODo0OCAxZmE0ODgxYjI3YWE3ODVmNjY3YTNjZjgzM2E3YjY4
OGI2ZDcwNjZlIGNvbXBpbGluZwoKMjAxNC0wMy0wNy0wMjoyMDoxOCBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAzLjE0LjAtcmM1LTAzNzY2LWcxZmE0ODgxLi4JMQkxMwkyNAkyOQkzOQk3MQk4
Ngk5NAkxMjIJMTQ5CTE1NQkxNjQuLgkxNjUuLi4JMTY2LgkxODAgU1VDQ0VTUwoKCj09PT09
PT09PSB1cHN0cmVhbSA9PT09PT09PT0KV2FybmluZzogeW91IGFyZSBsZWF2aW5nIDEgY29t
bWl0IGJlaGluZCwgbm90IGNvbm5lY3RlZCB0bwphbnkgb2YgeW91ciBicmFuY2hlczoKCiAg
MWZhNDg4MSBSZXZlcnQgInRvcnR1cmU6IEluY3JlYXNlIHN0dXR0ZXItZW5kIGludGVuc2l0
eSIKCklmIHlvdSB3YW50IHRvIGtlZXAgdGhlbSBieSBjcmVhdGluZyBhIG5ldyBicmFuY2gs
IHRoaXMgbWF5IGJlIGEgZ29vZCB0aW1lCnRvIGRvIHNvIHdpdGg6CgogZ2l0IGJyYW5jaCBu
ZXdfYnJhbmNoX25hbWUgMWZhNDg4MQoKSEVBRCBpcyBub3cgYXQgYzNiZWJjNy4uLiBNZXJn
ZSBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZGF2ZW0v
bmV0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
YmExLTAzMDYyMDEwL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMwNjE4OmMzYmVi
YzcxYzRiY2RhZmEyNGI1MDZhZGYwYzFkZTNjMWY3N2UyZTA6YmlzZWN0LWxpbnV4NAoKMjAx
NC0wMy0wNy0wMjozMTo1MCBjM2JlYmM3MWM0YmNkYWZhMjRiNTA2YWRmMGMxZGUzYzFmNzdl
MmUwIGNvbXBpbGluZwoKMjAxNC0wMy0wNy0wMjozMzoyMiBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAzLjE0LjAtcmM1LTAwMTg1LWdjM2JlYmM3Li4uCTQJMTAJMzAJNTQJODIJMTQxCTE2Mwkx
NjUJMTcyCTE3NQkxNzguLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLgkxNzkuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sx
OzM1bTIwMTQtMDMtMDcgMDU6Mzk6MzQgYWRkX3RvX3J1bl9xdWV1ZSAxG1swbQouLgkxODAg
U1VDQ0VTUwoKCj09PT09PT09PSBsaW51eC1uZXh0ID09PT09PT09PQpGZXRjaGluZyBuZXh0
CkZyb20gZ2l0Oi8vZ2l0bWlycm9yL25leHQKICsgNmU3NmQ4NS4uLmQ0YmIyZWIgYWtwbSAg
ICAgICAtPiBuZXh0L2FrcG0gIChmb3JjZWQgdXBkYXRlKQogKyA1YTM5NzM5Li4uMDlkZTE5
MiBha3BtLWJhc2UgIC0+IG5leHQvYWtwbS1iYXNlICAoZm9yY2VkIHVwZGF0ZSkKICsgMWQ5
ZjM4Yi4uLjBmZmIyZmUgbWFzdGVyICAgICAtPiBuZXh0L21hc3RlciAgKGZvcmNlZCB1cGRh
dGUpCiAgIDBjMGJkMzQuLmMzYmViYzcgIHN0YWJsZSAgICAgLT4gbmV4dC9zdGFibGUKICog
W25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDMwNiAtPiBuZXh0LTIwMTQwMzA2ClByZXZp
b3VzIEhFQUQgcG9zaXRpb24gd2FzIGMzYmViYzcuLi4gTWVyZ2UgZ2l0Oi8vZ2l0Lmtlcm5l
bC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2RhdmVtL25ldApIRUFEIGlzIG5vdyBh
dCAwZmZiMmZlLi4uIEFkZCBsaW51eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0MDMw
NgpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWJh
MS0wMzA2MjAxMC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAzMDYxODowZmZiMmZl
N2I5YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2MzJjZjAzOmJpc2VjdC1saW51eDQKCjIwMTQt
MDMtMDctMDU6NDE6NDIgMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2Yw
MyBjb21waWxpbmcKMjAxNC0wMy0wNy0wNTo0Mjo0OSAwZmZiMmZlN2I5YzMwMDgyODc2ZmEz
YTE3ZGEwMThiZjA2MzJjZjAzIFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9r
ZXJuZWwtdGVzdHMvbGludXg0L29iai1iaXNlY3QgYW5kIC90bXAva2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1iYTEtMDMwNjIwMTAvMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYw
NjMyY2YwMwo=

--aVD9QWMuhilNxW9f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc5-03765-gd478a96"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.14.0-rc5 Kernel Configuration
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
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_COMPILE_TEST=y
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
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
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
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
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_NOCB_CPU=y
CONFIG_RCU_NOCB_CPU_NONE=y
# CONFIG_RCU_NOCB_CPU_ZERO is not set
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_CGROUPS is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
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
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
CONFIG_X86_INTEL_MID=y
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_RDC321X=y
CONFIG_X86_32_NON_STANDARD=y
# CONFIG_X86_NUMAQ is not set
CONFIG_STA2X11=y
# CONFIG_X86_SUMMIT is not set
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
CONFIG_MK8=y
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
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_APB_TIMER=y
CONFIG_DMI=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=y
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
CONFIG_VMSPLIT_2G=y
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x80000000
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
# CONFIG_ZBUD is not set
CONFIG_MEM_SOFT_DIRTY=y
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
# CONFIG_SECCOMP is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
CONFIG_ACPI_EC_DEBUGFS=y
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
# CONFIG_ACPI_FAN is not set
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_DEBUG=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=y
# CONFIG_ACPI_HED is not set
CONFIG_ACPI_CUSTOM_METHOD=y
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
CONFIG_X86_PCC_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K6=y
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K7_ACPI=y
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_GX_SUSPMOD=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=y
CONFIG_X86_P4_CLOCKMOD=y
CONFIG_X86_CPUFREQ_NFORCE2=y
CONFIG_X86_LONGRUN=y
CONFIG_X86_LONGHAUL=y
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

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
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
# CONFIG_PCIEASPM_DEFAULT is not set
# CONFIG_PCIEASPM_POWERSAVE is not set
CONFIG_PCIEASPM_PERFORMANCE=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
CONFIG_PCI_PASID=y
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_SCx200 is not set
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
# CONFIG_GEOS is not set
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_TSI721=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
CONFIG_RAPIDIO_DMA_ENGINE=y
# CONFIG_RAPIDIO_DEBUG is not set
CONFIG_RAPIDIO_ENUM_BASIC=y

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=y
CONFIG_RAPIDIO_CPS_XX=y
# CONFIG_RAPIDIO_TSI568 is not set
CONFIG_RAPIDIO_CPS_GEN2=y
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_X86_DMA_REMAP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
CONFIG_XPS=y
CONFIG_NET_RX_BUSY_POLL=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
# CONFIG_MTD_REDBOOT_PARTS is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
# CONFIG_MTD_OOPS is not set

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
CONFIG_MTD_CFI_GEOMETRY=y
# CONFIG_MTD_MAP_BANK_WIDTH_1 is not set
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
# CONFIG_MTD_CFI_I2 is not set
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_OTP=y
CONFIG_MTD_CFI_INTELEXT=y
# CONFIG_MTD_CFI_AMDSTD is not set
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
CONFIG_MTD_SC520CDP=y
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
CONFIG_MTD_PMC551_BUGFIX=y
CONFIG_MTD_PMC551_DEBUG=y
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
CONFIG_MTD_SM_COMMON=y
CONFIG_MTD_NAND_DENALI=y
# CONFIG_MTD_NAND_DENALI_PCI is not set
CONFIG_MTD_NAND_GPIO=y
CONFIG_MTD_NAND_IDS=y
CONFIG_MTD_NAND_RICOH=y
CONFIG_MTD_NAND_DISKONCHIP=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH is not set
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
CONFIG_MTD_NAND_DOCG4=y
# CONFIG_MTD_NAND_CAFE is not set
# CONFIG_MTD_NAND_CS553X is not set
# CONFIG_MTD_NAND_NANDSIM is not set
# CONFIG_MTD_NAND_PLATFORM is not set
# CONFIG_MTD_NAND_SH_FLCTL is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
# CONFIG_MTD_UBI_GLUEBI is not set
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
CONFIG_INTEL_MID_PTI=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
# CONFIG_ICS932S401 is not set
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
# CONFIG_CS5535_CLOCK_EVENT_SRC is not set
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
CONFIG_ISL29020=y
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
CONFIG_DS1682=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_PCH_PHUB=y
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_SRAM=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_FUSION=y
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
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
CONFIG_KEYBOARD_ADP5520=y
CONFIG_KEYBOARD_ADP5588=y
CONFIG_KEYBOARD_ADP5589=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
CONFIG_KEYBOARD_QT2160=y
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_GPIO=y
CONFIG_KEYBOARD_GPIO_POLLED=y
# CONFIG_KEYBOARD_TCA6416 is not set
CONFIG_KEYBOARD_TCA8418=y
# CONFIG_KEYBOARD_MATRIX is not set
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_LM8333=y
# CONFIG_KEYBOARD_MAX7359 is not set
CONFIG_KEYBOARD_MCS=y
CONFIG_KEYBOARD_MPR121=y
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_SH_KEYSC=y
CONFIG_KEYBOARD_STMPE=y
CONFIG_KEYBOARD_TC3589X=y
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_KEYBOARD_CROS_EC=y
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=y
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_DB9 is not set
CONFIG_JOYSTICK_GAMECON=y
CONFIG_JOYSTICK_TURBOGRAFX=y
CONFIG_JOYSTICK_AS5011=y
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_JOYSTICK_WALKERA0701=y
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM860X_ONKEY=y
CONFIG_INPUT_88PM80X_ONKEY=y
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_ARIZONA_HAPTICS=y
CONFIG_INPUT_BMA150=y
CONFIG_INPUT_PCSPKR=y
CONFIG_INPUT_MAX8925_ONKEY=y
CONFIG_INPUT_MC13783_PWRBUTTON=y
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=y
CONFIG_INPUT_GPIO_TILT_POLLED=y
# CONFIG_INPUT_WISTRON_BTNS is not set
CONFIG_INPUT_ATLAS_BTNS=y
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_RETU_PWRBUTTON is not set
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF8574=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_DA9052_ONKEY=y
CONFIG_INPUT_DA9055_ONKEY=y
CONFIG_INPUT_WM831X_ON=y
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=y
CONFIG_INPUT_CMA3000=y
CONFIG_INPUT_CMA3000_I2C=y
CONFIG_INPUT_IDEAPAD_SLIDEBAR=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=y
# CONFIG_N_GSM is not set
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=y
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_DMA=y
# CONFIG_SERIAL_8250_PCI is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CLPS711X=y
CONFIG_SERIAL_CLPS711X_CONSOLE=y
CONFIG_SERIAL_MFD_HSU=y
CONFIG_SERIAL_MFD_HSU_CONSOLE=y
CONFIG_SERIAL_UARTLITE=y
# CONFIG_SERIAL_UARTLITE_CONSOLE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
CONFIG_SERIAL_PCH_UART=y
CONFIG_SERIAL_PCH_UART_CONSOLE=y
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
CONFIG_SERIAL_FSL_LPUART=y
# CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
CONFIG_SERIAL_ST_ASC=y
# CONFIG_SERIAL_ST_ASC_CONSOLE is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
# CONFIG_HW_RANDOM_INTEL is not set
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
CONFIG_SONYPI=y
CONFIG_MWAVE=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HPET_MMAP_DEFAULT=y
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
CONFIG_TCG_TIS_I2C_INFINEON=y
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
CONFIG_TCG_INFINEON=y
CONFIG_TCG_ST33_I2C=y
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=y
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=y
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_NFORCE2_S4985 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
CONFIG_I2C_SCMI=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
CONFIG_I2C_DESIGNWARE_PCI=y
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_RIIC is not set
CONFIG_I2C_SH_MOBILE=y
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y
CONFIG_I2C_RCAR=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=y
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_SCx200_ACB=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
CONFIG_PPS_CLIENT_LDISC=y
CONFIG_PPS_CLIENT_PARPORT=y
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_ARCH_REQUIRE_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_CLPS711X=y
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_F7188X is not set
CONFIG_GPIO_SCH311X=y
CONFIG_GPIO_STA2X11=y
# CONFIG_GPIO_TS5500 is not set
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_LP3943=y
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_STMPE is not set
CONFIG_GPIO_TC3589X=y
# CONFIG_GPIO_TPS65912 is not set
CONFIG_GPIO_WM831X=y
# CONFIG_GPIO_WM8350 is not set
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5520=y
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_CS5535 is not set
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
# CONFIG_GPIO_INTEL_MID is not set
CONFIG_GPIO_PCH=y
CONFIG_GPIO_ML_IOH=y
# CONFIG_GPIO_TIMBERDALE is not set
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_TPS6586X is not set
CONFIG_GPIO_MSIC=y

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_MAX8925_POWER=y
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
# CONFIG_WM8350_POWER is not set
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_88PM860X is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MANAGER=y
CONFIG_CHARGER_MAX14577=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_SMB347=y
CONFIG_BATTERY_GOLDFISH=y
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_DA9055 is not set
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_HTU21=y
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_LM25066=y
# CONFIG_SENSORS_LTC2978 is not set
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_WM8350=y
CONFIG_SENSORS_APPLESMC=y
# CONFIG_SENSORS_MC13783_ADC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
CONFIG_SENSORS_ATK0110=y
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
# CONFIG_THERMAL_GOV_USER_SPACE is not set
CONFIG_THERMAL_EMULATION=y
CONFIG_RCAR_THERMAL=y
# CONFIG_ACPI_INT3403_THERMAL is not set

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
# CONFIG_SSB_PCIHOST is not set
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
CONFIG_MFD_AS3711=y
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_CROS_EC=y
# CONFIG_MFD_CROS_EC_I2C is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_INTEL_MSIC=y
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_RETU=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
CONFIG_MFD_STA2X11=y
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=y
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_88PM800 is not set
CONFIG_REGULATOR_88PM8607=y
# CONFIG_REGULATOR_ACT8865 is not set
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_ANATOP=y
# CONFIG_REGULATOR_AAT2870 is not set
# CONFIG_REGULATOR_ARIZONA is not set
CONFIG_REGULATOR_AS3711=y
# CONFIG_REGULATOR_DA9052 is not set
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_MAX14577=y
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8907 is not set
CONFIG_REGULATOR_MAX8925=y
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX77686=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=y
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS6586X=y
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8350=y
CONFIG_REGULATOR_WM8994=y
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=y
CONFIG_AGP_ATI=y
CONFIG_AGP_AMD=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_NVIDIA=y
CONFIG_AGP_SIS=y
CONFIG_AGP_SWORKS=y
CONFIG_AGP_VIA=y
# CONFIG_AGP_EFFICEON is not set
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
CONFIG_DRM_I2C_SIL164=y
CONFIG_DRM_I2C_NXP_TDA998X=y
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
# CONFIG_DRM_RADEON_UMS is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I810 is not set
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
CONFIG_DRM_I915_FBDEV=y
# CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT is not set
CONFIG_DRM_I915_UMS=y
# CONFIG_DRM_MGA is not set
CONFIG_DRM_SIS=y
CONFIG_DRM_VIA=y
# CONFIG_DRM_SAVAGE is not set
CONFIG_DRM_VMWGFX=y
CONFIG_DRM_VMWGFX_FBCON=y
CONFIG_DRM_GMA500=y
CONFIG_DRM_GMA600=y
CONFIG_DRM_GMA3600=y
# CONFIG_DRM_MEDFIELD is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
CONFIG_DRM_MGAG200=y
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_QXL=y
CONFIG_DRM_BOCHS=y
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=y
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
CONFIG_FB_ASILIANT=y
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_EFI is not set
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
# CONFIG_FB_OPENCORES is not set
CONFIG_FB_S1D13XXX=y
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_I810 is not set
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
CONFIG_FB_ATY=y
# CONFIG_FB_ATY_CT is not set
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
# CONFIG_FB_SIS_315 is not set
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
# CONFIG_FB_3DFX is not set
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_SM501=y
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
# CONFIG_FB_AUO_K1900 is not set
CONFIG_FB_AUO_K1901=y
# CONFIG_FB_SIMPLE is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_CARILLO_RANCH=y
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_MAX8925=y
CONFIG_BACKLIGHT_APPLE=y
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP5520=y
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_88PM860X=y
CONFIG_BACKLIGHT_AAT2870=y
CONFIG_BACKLIGHT_LM3630A=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_AS3711=y
CONFIG_BACKLIGHT_GPIO=y
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_DMAENGINE_PCM=y
CONFIG_SND_COMPRESS_OFFLOAD=y
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_HRTIMER is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
# CONFIG_SND_DRIVERS is not set
# CONFIG_SND_PCI is not set

#
# HD-Audio
#
CONFIG_SND_SOC=y
CONFIG_SND_SOC_GENERIC_DMAENGINE_PCM=y
CONFIG_SND_SOC_ADI=y
CONFIG_SND_SOC_ADI_AXI_I2S=y
CONFIG_SND_SOC_ADI_AXI_SPDIF=y
# CONFIG_SND_ATMEL_SOC is not set
CONFIG_SND_BCM2835_SOC_I2S=y
CONFIG_SND_EP93XX_SOC=y
CONFIG_SND_SOC_FSL_SPDIF=y
CONFIG_SND_IMX_SOC=y
CONFIG_SND_SOC_IMX_PCM_DMA=y
CONFIG_SND_SOC_IMX_SPDIF=y
CONFIG_SND_KIRKWOOD_SOC=y
# CONFIG_SND_KIRKWOOD_SOC_ARMADA370_DB is not set
CONFIG_SND_KIRKWOOD_SOC_OPENRD=y
CONFIG_SND_KIRKWOOD_SOC_T5325=y
CONFIG_SND_MFLD_MACHINE=y
CONFIG_SND_SST_MFLD_PLATFORM=y
# CONFIG_SND_SOC_INTEL_SST is not set
# CONFIG_SND_SOC_SIRF is not set
CONFIG_SND_SOC_I2C_AND_SPI=y

#
# CODEC drivers
#
# CONFIG_SND_SOC_ALL_CODECS is not set
# CONFIG_SND_SOC_ADAU1701 is not set
# CONFIG_SND_SOC_AK4554 is not set
# CONFIG_SND_SOC_AK4642 is not set
CONFIG_SND_SOC_AK5386=y
CONFIG_SND_SOC_ALC5623=y
CONFIG_SND_SOC_CS42L51=y
# CONFIG_SND_SOC_CS42L52 is not set
CONFIG_SND_SOC_CS42L73=y
CONFIG_SND_SOC_CS4270=y
CONFIG_SND_SOC_CS4271=y
CONFIG_SND_SOC_HDMI_CODEC=y
CONFIG_SND_SOC_PCM1681=y
CONFIG_SND_SOC_PCM512x=y
# CONFIG_SND_SOC_SGTL5000 is not set
# CONFIG_SND_SOC_SIRF_AUDIO_CODEC is not set
CONFIG_SND_SOC_SN95031=y
# CONFIG_SND_SOC_SPDIF is not set
CONFIG_SND_SOC_TAS5086=y
CONFIG_SND_SOC_TLV320AIC3X=y
# CONFIG_SND_SOC_WM8510 is not set
# CONFIG_SND_SOC_WM8523 is not set
CONFIG_SND_SOC_WM8580=y
CONFIG_SND_SOC_WM8711=y
CONFIG_SND_SOC_WM8728=y
# CONFIG_SND_SOC_WM8731 is not set
CONFIG_SND_SOC_WM8737=y
CONFIG_SND_SOC_WM8741=y
CONFIG_SND_SOC_WM8750=y
CONFIG_SND_SOC_WM8753=y
CONFIG_SND_SOC_WM8776=y
CONFIG_SND_SOC_WM8804=y
CONFIG_SND_SOC_WM8903=y
CONFIG_SND_SOC_WM8962=y
CONFIG_SND_SOC_TPA6130A2=y
CONFIG_SND_SIMPLE_CARD=y
CONFIG_SOUND_PRIME=y
CONFIG_SOUND_OSS=y
# CONFIG_SOUND_TRACEINIT is not set
# CONFIG_SOUND_DMAP is not set
CONFIG_SOUND_VMIDI=y
# CONFIG_SOUND_TRIX is not set
CONFIG_SOUND_MSS=y
CONFIG_SOUND_MPU401=y
CONFIG_SOUND_PAS=y
# CONFIG_PAS_JOYSTICK is not set
CONFIG_SOUND_PSS=y
CONFIG_PSS_MIXER=y
# CONFIG_PSS_HAVE_BOOT is not set
CONFIG_SOUND_SB=y
CONFIG_SOUND_YM3812=y
# CONFIG_SOUND_UART6850 is not set
# CONFIG_SOUND_AEDSP16 is not set
CONFIG_SOUND_KAHLUA=y

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
CONFIG_UHID=y
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
# CONFIG_HID_APPLE is not set
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=y
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=y
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
# CONFIG_HID_PICOLCD_LEDS is not set
CONFIG_HID_PRIMAX=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=y
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=y
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=y
# CONFIG_HID_ZEROPLUS is not set
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# I2C HID support
#
CONFIG_I2C_HID=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_KEYSTONE_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_OMAP_CONTROL_USB is not set
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_TAHVO_USB is not set
# CONFIG_USB_RCAR_GEN2_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_MEMSTICK_R592=y
CONFIG_MEMSTICK_REALTEK_PCI=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=y
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_CLEVO_MAIL=y
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_PCA9685=y
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_REGULATOR=y
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=y
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_ADP5520=y
CONFIG_LEDS_MC13783=y
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_ACCESSIBILITY=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_AMD76X=y
# CONFIG_EDAC_E7XXX is not set
CONFIG_EDAC_E752X=y
CONFIG_EDAC_I82875P=y
CONFIG_EDAC_I82975X=y
CONFIG_EDAC_I3000=y
CONFIG_EDAC_I3200=y
CONFIG_EDAC_X38=y
CONFIG_EDAC_I5400=y
# CONFIG_EDAC_I82860 is not set
# CONFIG_EDAC_R82600 is not set
CONFIG_EDAC_I5000=y
CONFIG_EDAC_I5100=y
CONFIG_EDAC_I7300=y
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
# CONFIG_RTC_INTF_PROC is not set
# CONFIG_RTC_INTF_DEV is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=y
CONFIG_RTC_DRV_88PM80X=y
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=y
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8907=y
# CONFIG_RTC_DRV_MAX8925 is not set
CONFIG_RTC_DRV_MAX77686=y
CONFIG_RTC_DRV_RS5C372=y
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_ISL12022=y
CONFIG_RTC_DRV_ISL12057=y
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF2127=y
CONFIG_RTC_DRV_PCF8523=y
# CONFIG_RTC_DRV_PCF8563 is not set
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=y
# CONFIG_RTC_DRV_TPS6586X is not set
CONFIG_RTC_DRV_S35390A=y
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
CONFIG_RTC_DRV_RX8025=y
# CONFIG_RTC_DRV_EM3027 is not set
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_VRTC=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_DA9052=y
CONFIG_RTC_DRV_DA9055=y
CONFIG_RTC_DRV_STK17TA8=y
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=y
# CONFIG_RTC_DRV_DS2404 is not set
# CONFIG_RTC_DRV_WM831X is not set
CONFIG_RTC_DRV_WM8350=y

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MC13XXX is not set
CONFIG_RTC_DRV_MOXART=y

#
# HID Sensor RTC drivers
#
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
CONFIG_INTEL_IOATDMA=y
CONFIG_DW_DMAC_CORE=y
# CONFIG_DW_DMAC is not set
CONFIG_DW_DMAC_PCI=y
CONFIG_TIMB_DMA=y
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=y
CONFIG_DMA_ENGINE_RAID=y
CONFIG_DCA=y
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=y
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=y
CONFIG_CFAG12864B_RATE=20
# CONFIG_UIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACERHDF=y
CONFIG_ASUS_LAPTOP=y
CONFIG_DELL_LAPTOP=y
CONFIG_FUJITSU_LAPTOP=y
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
CONFIG_FUJITSU_TABLET=y
CONFIG_HP_ACCEL=y
CONFIG_HP_WIRELESS=y
CONFIG_PANASONIC_LAPTOP=y
CONFIG_THINKPAD_ACPI=y
# CONFIG_THINKPAD_ACPI_ALSA_SUPPORT is not set
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y
# CONFIG_THINKPAD_ACPI_VIDEO is not set
# CONFIG_THINKPAD_ACPI_HOTKEY_POLL is not set
# CONFIG_SENSORS_HDAPS is not set
CONFIG_INTEL_MENLOW=y
# CONFIG_ACPI_WMI is not set
CONFIG_TOPSTAR_LAPTOP=y
CONFIG_TOSHIBA_BT_RFKILL=y
CONFIG_ACPI_CMPC=y
CONFIG_INTEL_SCU_IPC=y
CONFIG_INTEL_SCU_IPC_UTIL=y
# CONFIG_GPIO_INTEL_PMIC is not set
CONFIG_INTEL_MID_POWER_BUTTON=y
# CONFIG_INTEL_MFLD_THERMAL is not set
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=y
CONFIG_XO15_EBOOK=y
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_SAMSUNG_Q10=y
CONFIG_APPLE_GMUX=y
CONFIG_INTEL_RST=y
CONFIG_INTEL_SMARTCONNECT=y
# CONFIG_PVPANIC is not set
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_LAPTOP=y
CONFIG_CHROMEOS_PSTORE=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_DW_APB_TIMER=y
# CONFIG_MAILBOX is not set
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
CONFIG_EXTCON_MAX14577=y
CONFIG_EXTCON_ARIZONA=y
CONFIG_MEMORY=y
# CONFIG_IIO is not set
CONFIG_NTB=y
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
CONFIG_SERIAL_IPOCTAL=y
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_EXYNOS_MIPI_VIDEO=y
# CONFIG_TI_PIPE3 is not set
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_POWERCAP is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_VARS_PSTORE=y
# CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE is not set
# CONFIG_EFI_RUNTIME_MAP is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
# CONFIG_SYSFS is not set
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_JFFS2_FS is not set
CONFIG_UBIFS_FS=y
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
# CONFIG_UBIFS_FS_LZO is not set
# CONFIG_UBIFS_FS_ZLIB is not set
# CONFIG_LOGFS is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_MTD=y
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_RAM is not set
# CONFIG_EFIVAR_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_INTEL_MID is not set
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_EARLY_PRINTK_EFI is not set
CONFIG_X86_PTDUMP=y
# CONFIG_EFI_PGT_DUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_NMI_SELFTEST=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITYFS=y
CONFIG_EVM_HMAC_ATTRS="fsuuid"
CONFIG_EVM_HMAC_XATTRS="security.selinux security.SMACK64 security.ima security.capability"
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
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
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
# CONFIG_CRYPTO_HMAC is not set
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
# CONFIG_CRYPTO_DEV_GEODE is not set
CONFIG_CRYPTO_DEV_HIFN_795X=y
# CONFIG_CRYPTO_DEV_HIFN_795X_RNG is not set
CONFIG_CRYPTO_DEV_CCP=y
# CONFIG_CRYPTO_DEV_CCP_DD is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_LGUEST is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_CRC8=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
CONFIG_DDR=y
CONFIG_UCS2_STRING=y

--aVD9QWMuhilNxW9f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--aVD9QWMuhilNxW9f--
