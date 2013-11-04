Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab3KDOOE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 09:14:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:45966 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799Ab3KDOOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 09:14:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,632,1378882800"; 
   d="log'?scan'208";a="422007223"
Date: Mon, 4 Nov 2013 22:13:55 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [crc32] INFO: rcu_sched self-detected stall on CPU { 0}  (t=2101
 jiffies g=4294967081 c=4294967080 q=41)
Message-ID: <20131104141355.GB17177@localhost>
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

Hi Daniel,

Is it expected for this commit to trigger the rcu stall warnings?
The warnings are 100% reproducible with the attached kconfig.

commit efba721f636ee016859d86d15748650119402b10
Author: Daniel Borkmann <dborkman@redhat.com>
Date:   Wed Oct 30 11:50:50 2013 +0100

    lib: crc32: add test cases for crc32{, c}_combine routines
    
    We already have 100 test cases for crcs itself, so split the test
    buffer with a-prio known checksums, and test crc of two blocks
    against crc of the whole block for the same results.
    
    Output/result with CONFIG_CRC32_SELFTEST=y:
    
      [    2.687095] crc32: CRC_LE_BITS = 64, CRC_BE BITS = 64
      [    2.687097] crc32: self tests passed, processed 225944 bytes in 278177 nsec
      [    2.687383] crc32c: CRC_LE_BITS = 64
      [    2.687385] crc32c: self tests passed, processed 225944 bytes in 141708 nsec
      [    7.336771] crc32_combine: 113072 self tests passed
      [   12.050479] crc32c_combine: 113072 self tests passed
      [   17.633089] alg: No test for crc32 (crc32-pclmul)
    
    Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
    Cc: linux-kernel@vger.kernel.org
    Signed-off-by: David S. Miller <davem@davemloft.net>

[    2.364402] crc32c: CRC_LE_BITS = 1
[    2.364953] crc32c: self tests passed, processed 225944 bytes in 5680877 nsec
[   16.143376] crc32_combine: 113072 self tests passed
[   23.340041] INFO: rcu_sched self-detected stall on CPU { 0}  (t=2101 jiffies g=4294967081 c=4294967080 q=41)
[   23.340041] sending NMI to all CPUs:
[   23.340041] NMI backtrace for cpu 0
[   23.340041] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc6-01322-gf421436 #414
[   23.340041] task: 80138000 ti: 80140000 task.ti: 80140000
[   23.340041] EIP: 0060:[<81057de4>] EFLAGS: 00010046 CPU: 0
[   23.340041] EIP is at default_send_IPI_mask_logical+0x164/0x1f0
[   23.340041] EAX: fffff000 EBX: 03000000 ECX: fffff000 EDX: 00000c00
[   23.340041] ESI: 00000046 EDI: 00000002 EBP: 80141ce0 ESP: 80141cd0
[   23.340041]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   23.340041] CR0: 8005003b CR2: 00000000 CR3: 01bed000 CR4: 000006d0
[   23.340041] Stack:
[   23.340041]  00000800 00002710 8dbba1a0 81967b80 80141cec 81057fac 00002710 80141cfc
[   23.340041]  81058691 818908e0 00000029 80141d40 8115cdec 818a7884 00000835 ffffff29
[   23.340041]  ffffff28 00000029 80141d40 810cfe5d 00000001 80140000 8dbba1a0 00000000
[   23.340041] Call Trace:
[   23.340041]  [<81057fac>] default_send_IPI_all+0x2c/0xd0
[   23.340041]  [<81058691>] arch_trigger_all_cpu_backtrace+0x91/0x130
[   23.340041]  [<8115cdec>] rcu_check_callbacks+0x35c/0xa40
[   23.340041]  [<810cfe5d>] ? account_process_tick+0x1ed/0x2e0
[   23.340041]  [<8108eeef>] update_process_times+0x6f/0xe0
[   23.340041]  [<81115d01>] tick_sched_handle.isra.12+0x71/0xa0
[   23.340041]  [<81115d9a>] tick_sched_timer+0x6a/0xc0
[   23.340041]  [<810b57e7>] __run_hrtimer.isra.17+0xc7/0x1b0
[   23.340041]  [<81115d30>] ? tick_sched_handle.isra.12+0xa0/0xa0
[   23.340041]  [<810b6833>] hrtimer_interrupt+0x1b3/0x3d0
[   23.340041]  [<8115bd29>] ? rcu_irq_enter+0x139/0x190
[   23.340041]  [<810548c1>] local_apic_timer_interrupt+0x81/0xa0
[   23.340041]  [<81085b0e>] ? irq_enter+0x1e/0xf0
[   23.340041]  [<81054d28>] smp_apic_timer_interrupt+0x58/0x90
[   23.340041]  [<816ab692>] apic_timer_interrupt+0x36/0x3c
[   23.340041]  [<81a5eeed>] ? crc32test_init+0x11c2/0x1317
[   23.340041]  [<81a5dd2b>] ? debug_objects_mem_init+0x3eb/0x3eb
[   23.340041]  [<81000440>] do_one_initcall+0x100/0x250
[   23.340041]  [<810ac931>] ? parameq+0x21/0xf0
[   23.340041]  [<81a1e700>] ? do_early_param+0x110/0x12b
[   23.340041]  [<810acdf2>] ? parse_args+0x3f2/0x5d0
[   23.340041]  [<81a1f94d>] kernel_init_freeable+0x2e4/0x47a
[   23.340041]  [<81a1e71b>] ? do_early_param+0x12b/0x12b
[   23.340041]  [<8168b8f9>] kernel_init+0x19/0x290
[   23.340041]  [<816abaf7>] ret_from_kernel_thread+0x1b/0x28
[   23.340041]  [<8168b8e0>] ? rest_init+0x190/0x190
[   23.340041] Code: f8 a4 c1 81 01 83 15 fc a4 c1 81 00 eb 12 90 80 ce 04 83 05 00 a5 c1 81 01 83 15 04 a5 c1 81 00 a1 10 87 94 81 89 90 00 c3 ff ff <f7> c6 00 02 00 00 75 3c 83 05 08 a5 c1 81 01 89 f0 83 15 0c a5
[   23.350050] NMI backtrace for cpu 1
[   23.350050] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.12.0-rc6-01322-gf421436 #414
[   23.350050] task: 8015d2c0 ti: 80176000 task.ti: 80176000
[   23.350050] EIP: 0060:[<81064ae3>] EFLAGS: 00200246 CPU: 1
[   23.350050] EIP is at native_safe_halt+0x13/0x30
[   23.350050] EAX: 8015d2c0 EBX: 80176000 ECX: 00000000 EDX: 00000001
[   23.350050] ESI: ffffffff EDI: ffff8ba1 EBP: 80177f60 ESP: 80177f60
[   23.350050]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   23.350050] CR0: 8005003b CR2: ffffffff CR3: 01bed000 CR4: 000006d0
[   23.350050] Stack:
[   23.350050]  80177f68 81014509 80177f70 810156ae 80177f88 810f6cea 46a4dfe6 55086500
[   23.350050]  8f51f76f 8fffc440 80177fb4 810521cb d8d4b9d1 051b2406 a1acbf74 c2cf5d8e
[   23.350050]  ff810013 8f51f76f 01000800 00000000 00000000 00000000 00000000 00000000
[   23.350050] Call Trace:
[   23.350050]  [<81014509>] default_idle+0x29/0x40
[   23.350050]  [<810156ae>] arch_cpu_idle+0x2e/0x80
[   23.350050]  [<810f6cea>] cpu_startup_entry+0x2aa/0x3e0
[   23.350050]  [<810521cb>] start_secondary+0x5eb/0x630
[   23.350050] Code: 01 83 15 a4 50 c2 81 00 5d c3 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 55 83 05 a8 50 c2 81 01 89 e5 83 15 ac 50 c2 81 00 fb f4 <83> 05 b0 50 c2 81 01 83 15 b4 50 c2 81 00 5d c3 8d b6 00 00 00

git bisect start f421436a591d34fa5279b54a96ac07d70250cc8d dcb30e659287a6b40dafed1362532da42ec27229 --
git bisect good 53af53ae83fe960ceb9ef74cac7915e9088f4266  # 20:03     20+      0  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect good db10accfd266a93149cd21cd75026aa03c635e7e  # 20:11     20+      0  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect good 5f258a1552d1a8fd263346635022fdf16aa06d6a  # 20:18     20+      0  net: dl2k: remove unnecessary pci_set_drvdata()
git bisect good b45bd46decd947eaa3497699d450e0851d247534  # 20:25     20+      0  Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
git bisect good 6c7a9a3c7838eab1f17ef00c87925151be06cf1c  # 20:33     20+      0  mvneta: drop redundant mac address check
git bisect good bed6f762123fc53c63efef386531dd877cba2468  # 20:41     20+      0  net: cdc_ncm: remove redundant netdev field
git bisect good 59ede3168a0b3fe02f82a7bed52432f18dbb1070  # 20:50     20+      0  net: cdc_ncm: return proper error if setup fails
git bisect good 296c10639a33941d0090afa17b7535fcbf81d97a  # 20:58     20+      0  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next
git bisect  bad 2817a336d4d533fb8b68719723cd60ea7dd7c09e  # 21:01      0-      5  net: skb_checksum: allow custom update/combine for walking skb
git bisect good 6e95fcaa42e5078ac265964deebed597f9eae07a  # 21:12     20+      0  lib: crc32: add functionality to combine two crc32{, c}s in GF(2)
git bisect  bad efba721f636ee016859d86d15748650119402b10  # 21:16      0-      7  lib: crc32: add test cases for crc32{, c}_combine routines
git bisect good 6e95fcaa42e5078ac265964deebed597f9eae07a  # 21:20     60+      0  lib: crc32: add functionality to combine two crc32{, c}s in GF(2)
git bisect  bad f421436a591d34fa5279b54a96ac07d70250cc8d  # 21:20      0-     19  net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)
git bisect good 1e418d9716d909dd6d2afa89c9066f329b62613c  # 21:30     60+      0  Revert "lib: crc32: add test cases for crc32{, c}_combine routines"
git bisect good 5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52  # 21:30     69+      0  Linux 3.12
git bisect good e3ad71f5e8b6e700a38d5a0da12b29d53600e65e  # 21:34     60+      0  Add linux-next specific files for 20131104

Thanks,
Fengguang

--8P1HSweYDcXXzwPJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-xian-2:20131104143408:i386-randconfig-i000-1104:3.12.0-rc6-01322-gf421436:414"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-rc6-01322-gf421436 (kbuild@inn) (gcc ve=
rsion 4.8.1 (Debian 4.8.1-8) ) #414 SMP Mon Nov 4 14:29:13 CST 2013
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[800fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x02bfffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
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
[    0.000000] BRK [0x02443000, 0x02443fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128048(97%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC=
 00000001)
[    0.000000] ACPI: DSDT 0fffe490 011A9 (v01   BXPC   BXDSDT 00000001 INTL=
 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: APIC 0ffff680 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC=
 00000001)
[    0.000000] ACPI: HPET 0ffff640 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC=
 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] BRK [0x02444000, 0x02444fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   Normal zone: 512 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 65436 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:2 nr_cpu_ids:2 nr_n=
ode_ids:1
[    0.000000] PERCPU: Embedded 332 pages/cpu @8da77000 s1338240 r0 d21632 =
u1359872
[    0.000000] pcpu-alloc: s1338240 r0 d21632 u1359872 alloc=3D332*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr da79840
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64924
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/i386-randconfig-i000-1104/net-next:master/.v=
mlinuz-f421436a591d34fa5279b54a96ac07d70250cc8d-20131104143152-3-xian branc=
h=3Dnet-next/master BOOT_IMAGE=3D/kernel/i386-randconfig-i000-1104/f421436a=
591d34fa5279b54a96ac07d70250cc8d/vmlinuz-3.12.0-rc6-01322-gf421436
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 202316K/261744K available (6833K kernel code, 982K r=
wdata, 2512K rodata, 1824K init, 8504K bss, 59428K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd35000 - 0xfffff000   (2856 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x907fe000 - 0xff7fe000   (1776 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x8fffe000   ( 255 MB)
[    0.000000]       .init : 0x81a1e000 - 0x81be6000   (1824 kB)
[    0.000000]       .data : 0x816acaa7 - 0x81a1cb40   (3520 kB)
[    0.000000]       .text : 0x81000000 - 0x816acaa7   (6834 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D2, =
Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3D80080000 soft=3D80082000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
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
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:  ok  |  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:  ok  |  ok  |  ok  |
[    0.000000]                               try:  ok  |  ok  |  ok  |
[    0.000000]                             block:  ok  |  ok  |  ok  |
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] allocated 524288 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] ODEBUG: 16 of 16 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2893.056 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5786.11 Bogo=
MIPS (lpj=3D28930560)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] Mount-cache hash table entries: 512
[    0.020000] Initializing cgroup subsys debug
[    0.020000] Initializing cgroup subsys memory
[    0.020000] Initializing cgroup subsys devices
[    0.020000] Initializing cgroup subsys freezer
[    0.020069] Initializing cgroup subsys hugetlb
[    0.020991] mce: CPU supports 10 MCE banks
[    0.021769] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.021769] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.021769] tlb_flushall_shift: 6
[    0.025218] Freeing SMP alternatives memory: 16K (81be6000 - 81bea000)
[    0.031307] ACPI: Core revision 20130725
[    0.036683] ACPI: All ACPI Tables successfully acquired
[    0.039469] Getting VERSION: 50014
[    0.040037] Getting VERSION: 50014
[    0.040610] Getting ID: 0
[    0.041059] Getting ID: f000000
[    0.041565] Getting LVT0: 8700
[    0.042081] Getting LVT1: 8400
[    0.042577] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.043552] enabled ExtINT on CPU#0
[    0.045873] ENABLING IO-APIC IRQs
[    0.046447] init IO_APIC IRQs
[    0.046960]  apic 0 pin 0 not connected
[    0.047641] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.048971] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.050072] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.051402] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.052702] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.054004] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.055331] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.056622] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.057906] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.059200] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.060071] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.061367] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.062683] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.063956] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.065228] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.066533]  apic 0 pin 16 not connected
[    0.067166]  apic 0 pin 17 not connected
[    0.067799]  apic 0 pin 18 not connected
[    0.068421]  apic 0 pin 19 not connected
[    0.070026]  apic 0 pin 20 not connected
[    0.070673]  apic 0 pin 21 not connected
[    0.071294]  apic 0 pin 22 not connected
[    0.071924]  apic 0 pin 23 not connected
[    0.072729] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.073991] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.075867] Using local APIC timer interrupts.
[    0.075867] calibrating APIC timer ...
[    0.080000] ... lapic delta =3D 6249442
[    0.080000] ... PM-Timer delta =3D 357929
[    0.080000] ... PM-Timer result ok
[    0.080000] ..... delta 6249442
[    0.080000] ..... mult: 268411490
[    0.080000] ..... calibration result: 9999107
[    0.080000] ..... CPU clock speed is 2892.7941 MHz.
[    0.080000] ..... host bus clock speed is 999.9107 MHz.
[    0.080000] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.080000] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.080000] SMP alternatives: lockdep: fixing up alternatives
[    0.080000] CPU 1 irqstacks, hard=3D8018e000 soft=3D80198000
[    0.080000] smpboot: Booting Node   0, Processors  #   1 OK
[    0.010000] Initializing CPU#1
[    0.020000] kvm-clock: cpu 1, msr 0:fffd021, secondary cpu clock
[    0.020000] masked ExtINT on CPU#1
[    0.110421] Brought up 2 CPUs
[    0.110310] KVM setup async PF for cpu 1
[    0.110310] kvm-stealtime: cpu 1, msr dbc5840
[    0.112288] ----------------
[    0.112767] | NMI testsuite:
[    0.113221] --------------------
[    0.113740]   remote IPI:  ok  |
[    0.140333]    local IPI:  ok  |
[    0.200072] --------------------
[    0.200585] Good, all   2 testcases passed! |
[    0.201149] ---------------------------------
[    0.201776] smpboot: Total of 2 processors activated (11572.22 BogoMIPS)
[    0.203511] CPU0 attaching sched-domain:
[    0.204197]  domain 0: span 0-1 level CPU
[    0.204880]   groups: 0 1
[    0.205384] CPU1 attaching sched-domain:
[    0.205995]  domain 0: span 0-1 level CPU
[    0.206647]   groups: 1 0
[    0.207304] devtmpfs: initialized
[    0.211938] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.214169] regulator-dummy: no parameters
[    0.215574] NET: Registered protocol family 16
[    0.216875] cpuidle: using governor ladder
[    0.217530] cpuidle: using governor menu
[    0.218871] ACPI: bus type PCI registered
[    0.219832] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.220047] PCI: Using configuration type 1 for base access
[    0.225537] bio: create slab <bio-0> at 0
[    0.225537] ACPI: Added _OSI(Module Device)
[    0.225537] ACPI: Added _OSI(Processor Device)
[    0.230032] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.230679] ACPI: Added _OSI(Processor Aggregator Device)
[    0.237491] ACPI: EC: Look up EC in DSDT
[    0.252792] ACPI: Interpreter enabled
[    0.253349] ACPI: (supports S0 S5)
[    0.253828] ACPI: Using IOAPIC for interrupt routing
[    0.254564] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.281194] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.282191] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.284437] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.286620] PCI host bridge to bus 0000:00
[    0.287288] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.288146] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.289074] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.290022] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.291090] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.292295] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.294681] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.297223] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.302670] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.306313] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.307880] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.308980] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.311049] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.314146] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.317171] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.327781] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.330525] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.333237] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.335913] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.344975] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.347081] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.350887] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.353447] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.363905] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.366592] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.369139] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.380278] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.382923] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.385499] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.395440] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.398253] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.400852] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.412094] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.414876] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.417415] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.427903] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.430882] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.433488] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.443742] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.445617] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.453467] pci_bus 0000:00: on NUMA node 0
[    0.457305] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.458818] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.460465] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.461893] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.463122] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.465816] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.466652] ACPI: \_SB_.PCI0: notify handler is installed
[    0.467900] Found 1 acpi root devices
[    0.469456] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.470037] vgaarb: loaded
[    0.470470] vgaarb: bridge control possible 0000:00:02.0
[    0.471584] SCSI subsystem initialized
[    0.472366] pps_core: LinuxPPS API ver. 1 registered
[    0.473139] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.474560] PTP clock support registered
[    0.475551] PCI: Using ACPI for IRQ routing
[    0.475551] PCI: pci_cache_line_size set to 64 bytes
[    0.475551] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.475551] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.481549] Switched to clocksource kvm-clock
[    0.482992] pnp: PnP ACPI init
[    0.483560] ACPI: bus type PNP registered
[    0.484377] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.485848] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.487001] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.488389] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.490000] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.490672] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.491821] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.493085] pnp 00:03: [dma 2]
[    0.493681] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.494859] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.496244] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.497457] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.498824] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.500981] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.502581] pnp: PnP ACPI: found 7 devices
[    0.503233] ACPI: bus type PNP unregistered
[    0.542156] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.542999] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.543872] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.544862] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.545883] NET: Registered protocol family 1
[    0.546628] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.547633] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.548580] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.549606] pci 0000:00:02.0: Boot video device
[    0.550552] PCI: CLS 0 bytes, default 64
[    0.551763] Unpacking initramfs...
[    2.262069] Freeing initrd memory: 25284K (8e73f000 - 8fff0000)
[    2.279534] DMA-API: preallocated 65536 debug entries
[    2.280393] DMA-API: debugging enabled by kernel config
[    2.281783] Machine check injector initialized
[    2.287420] NatSemi SCx200 Driver
[    2.291227] Initializing RT-Tester: OK
[    2.291850] Initialise module verification
[    2.294153] bounce pool size: 64 pages
[    2.294770] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    2.305507] VFS: Disk quotas dquot_6.5.2
[    2.306418] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.312232] NILFS version 2 loaded
[    2.312826] msgmni has been set to 444
[    2.320600] Key type asymmetric registered
[    2.321271] Asymmetric key parser 'x509' registered
[    2.322338] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    2.323506] io scheduler noop registered (default)
[    2.324232] list_sort_test: start testing list_sort()
[    2.351071] crc32: CRC_LE_BITS =3D 1, CRC_BE BITS =3D 1
[    2.351858] crc32: self tests passed, processed 225944 bytes in 12219928=
 nsec
[    2.364402] crc32c: CRC_LE_BITS =3D 1
[    2.364953] crc32c: self tests passed, processed 225944 bytes in 5680877=
 nsec
[   16.143376] crc32_combine: 113072 self tests passed
[   23.340041] INFO: rcu_sched self-detected stall on CPU { 0}  (t=3D2101 j=
iffies g=3D4294967081 c=3D4294967080 q=3D41)
[   23.340041] sending NMI to all CPUs:
[   23.340041] NMI backtrace for cpu 0
[   23.340041] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc6-01322-g=
f421436 #414
[   23.340041] task: 80138000 ti: 80140000 task.ti: 80140000
[   23.340041] EIP: 0060:[<81057de4>] EFLAGS: 00010046 CPU: 0
[   23.340041] EIP is at default_send_IPI_mask_logical+0x164/0x1f0
[   23.340041] EAX: fffff000 EBX: 03000000 ECX: fffff000 EDX: 00000c00
[   23.340041] ESI: 00000046 EDI: 00000002 EBP: 80141ce0 ESP: 80141cd0
[   23.340041]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   23.340041] CR0: 8005003b CR2: 00000000 CR3: 01bed000 CR4: 000006d0
[   23.340041] Stack:
[   23.340041]  00000800 00002710 8dbba1a0 81967b80 80141cec 81057fac 00002=
710 80141cfc
[   23.340041]  81058691 818908e0 00000029 80141d40 8115cdec 818a7884 00000=
835 ffffff29
[   23.340041]  ffffff28 00000029 80141d40 810cfe5d 00000001 80140000 8dbba=
1a0 00000000
[   23.340041] Call Trace:
[   23.340041]  [<81057fac>] default_send_IPI_all+0x2c/0xd0
[   23.340041]  [<81058691>] arch_trigger_all_cpu_backtrace+0x91/0x130
[   23.340041]  [<8115cdec>] rcu_check_callbacks+0x35c/0xa40
[   23.340041]  [<810cfe5d>] ? account_process_tick+0x1ed/0x2e0
[   23.340041]  [<8108eeef>] update_process_times+0x6f/0xe0
[   23.340041]  [<81115d01>] tick_sched_handle.isra.12+0x71/0xa0
[   23.340041]  [<81115d9a>] tick_sched_timer+0x6a/0xc0
[   23.340041]  [<810b57e7>] __run_hrtimer.isra.17+0xc7/0x1b0
[   23.340041]  [<81115d30>] ? tick_sched_handle.isra.12+0xa0/0xa0
[   23.340041]  [<810b6833>] hrtimer_interrupt+0x1b3/0x3d0
[   23.340041]  [<8115bd29>] ? rcu_irq_enter+0x139/0x190
[   23.340041]  [<810548c1>] local_apic_timer_interrupt+0x81/0xa0
[   23.340041]  [<81085b0e>] ? irq_enter+0x1e/0xf0
[   23.340041]  [<81054d28>] smp_apic_timer_interrupt+0x58/0x90
[   23.340041]  [<816ab692>] apic_timer_interrupt+0x36/0x3c
[   23.340041]  [<81a5eeed>] ? crc32test_init+0x11c2/0x1317
[   23.340041]  [<81a5dd2b>] ? debug_objects_mem_init+0x3eb/0x3eb
[   23.340041]  [<81000440>] do_one_initcall+0x100/0x250
[   23.340041]  [<810ac931>] ? parameq+0x21/0xf0
[   23.340041]  [<81a1e700>] ? do_early_param+0x110/0x12b
[   23.340041]  [<810acdf2>] ? parse_args+0x3f2/0x5d0
[   23.340041]  [<81a1f94d>] kernel_init_freeable+0x2e4/0x47a
[   23.340041]  [<81a1e71b>] ? do_early_param+0x12b/0x12b
[   23.340041]  [<8168b8f9>] kernel_init+0x19/0x290
[   23.340041]  [<816abaf7>] ret_from_kernel_thread+0x1b/0x28
[   23.340041]  [<8168b8e0>] ? rest_init+0x190/0x190
[   23.340041] Code: f8 a4 c1 81 01 83 15 fc a4 c1 81 00 eb 12 90 80 ce 04 =
83 05 00 a5 c1 81 01 83 15 04 a5 c1 81 00 a1 10 87 94 81 89 90 00 c3 ff ff =
<f7> c6 00 02 00 00 75 3c 83 05 08 a5 c1 81 01 89 f0 83 15 0c a5
[   23.350050] NMI backtrace for cpu 1
[   23.350050] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.12.0-rc6-01322-g=
f421436 #414
[   23.350050] task: 8015d2c0 ti: 80176000 task.ti: 80176000
[   23.350050] EIP: 0060:[<81064ae3>] EFLAGS: 00200246 CPU: 1
[   23.350050] EIP is at native_safe_halt+0x13/0x30
[   23.350050] EAX: 8015d2c0 EBX: 80176000 ECX: 00000000 EDX: 00000001
[   23.350050] ESI: ffffffff EDI: ffff8ba1 EBP: 80177f60 ESP: 80177f60
[   23.350050]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   23.350050] CR0: 8005003b CR2: ffffffff CR3: 01bed000 CR4: 000006d0
[   23.350050] Stack:
[   23.350050]  80177f68 81014509 80177f70 810156ae 80177f88 810f6cea 46a4d=
fe6 55086500
[   23.350050]  8f51f76f 8fffc440 80177fb4 810521cb d8d4b9d1 051b2406 a1acb=
f74 c2cf5d8e
[   23.350050]  ff810013 8f51f76f 01000800 00000000 00000000 00000000 00000=
000 00000000
[   23.350050] Call Trace:
[   23.350050]  [<81014509>] default_idle+0x29/0x40
[   23.350050]  [<810156ae>] arch_cpu_idle+0x2e/0x80
[   23.350050]  [<810f6cea>] cpu_startup_entry+0x2aa/0x3e0
[   23.350050]  [<810521cb>] start_secondary+0x5eb/0x630
[   23.350050] Code: 01 83 15 a4 50 c2 81 00 5d c3 8d b4 26 00 00 00 00 8d =
bc 27 00 00 00 00 55 83 05 a8 50 c2 81 01 89 e5 83 15 ac 50 c2 81 00 fb f4 =
<83> 05 b0 50 c2 81 01 83 15 b4 50 c2 81 00 5d c3 8d b6 00 00 00
[   23.350050] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 7.900 msecs
[   29.218815] crc32c_combine: 113072 self tests passed
[   29.220103] no IO addresses supplied
[   29.220897] hgafb: HGA card not detected.
[   29.221554] hgafb: probe of hgafb.0 failed with error -22
[   29.223128] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   29.224306] ACPI: Power Button [PWRF]
[   29.225784] r3964: Philips r3964 Driver $Revision: 1.10 $
[   29.226577] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   29.251680] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   29.255174] serial: Freescale lpuart driver
[   29.257030] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[   29.258132] platform pc8736x_gpio.0: no device found
[   29.259116] kobject: 'pc8736x_gpio.0' (8fb8f814): kobject_release, paren=
t   (null) (delayed)
[   29.260469] nsc_gpio initializing
[   29.260988] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[   29.262295] Hangcheck: Using getrawmonotonic().
[   29.263099] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[   29.264473] c2port c2port0: C2 port uc added
[   29.265124] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[   29.266390] kobject: 'pasic3' (88fce700): kobject_release, parent 800969=
f0 (delayed)
[   29.267692] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[   29.268639] osst :I: Tape driver with OnStream support version 0.99.4
[   29.268639] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[   29.271012] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   29.273972] serio: i8042 KBD port at 0x60,0x64 irq 1
[   29.274884] serio: i8042 AUX port at 0x60,0x64 irq 12
[   29.277098] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[   29.279023] kobject: 'rtc-msm6242' (88e5d400): kobject_release, parent 8=
00969f0 (delayed)
[   29.280271] pps_ldisc: PPS line discipline registered
[   29.281146] Driver for 1-wire Dallas network protocol.
[   29.282223] applesmc: supported laptop not found!
[   29.282929] applesmc: driver init failed (ret=3D-19)!
[   29.283833] pc87360: PC8736x not detected, module not inserted
[   29.284841] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[   29.287343] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[   29.288490] wafer5823wdt: I/O address 0x0443 already in use
[   29.289332] pc87413_wdt: Version 1.1 at io 0x2E
[   29.290086] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[   29.291067] sbc60xxwdt: I/O address 0x0443 already in use
[   29.291926] w83627hf_wdt: WDT driver for the Winbond(TM) W83627HF/THF/HG=
/DHG Super I/O chip initialising
[   29.293343] w83627hf_wdt: Watchdog already running. Resetting timeout to=
 60 sec
[   29.294458] w83627hf_wdt: cannot register miscdev on minor=3D130 (err=3D=
-16)
[   29.295458] w83877f_wdt: I/O address 0x0443 already in use
[   29.296388] lguest: mapped switcher at ffd2f000
[   29.298931] dgap: dgap-1.3-16, Digi International Part Number 40002347_C
[   29.300454] dgap: For the tools package or updated drivers please visit =
http://www.digi.com
[   29.300911] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   29.301213] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[   29.305441] kobject: '(null)' (8f43421c): kobject_release, parent   (nul=
l) (delayed)
[   29.305948] hdaps: supported laptop not found!
[   29.305951] hdaps: driver init failed (ret=3D-19)!
[   29.307127]=20
[   29.307127] printing PIC contents
[   29.307143] ... PIC  IMR: ffff
[   29.307153] ... PIC  IRR: 1013
[   29.307172] ... PIC  ISR: 0000
[   29.307182] ... PIC ELCR: 0c00
[   29.310612] printing local APIC contents on CPU#0/0:
[   29.311403] ... APIC ID:      00000000 (0)
[   29.312072] ... APIC VERSION: 00050014
[   29.312572] ... APIC TASKPRI: 00000000 (00)
[   29.313183] ... APIC PROCPRI: 00000000
[   29.313743] ... APIC LDR: 01000000
[   29.314247] ... APIC DFR: ffffffff
[   29.314759] ... APIC SPIV: 000001ff
[   29.315184] ... APIC ISR field:
[   29.315184] 000000000000000000000000000000000000000000000000000000000000=
0000
[   29.315184] ... APIC TMR field:
[   29.315184] 000000000200000000000000000000000000000000000000000000000000=
0000
[   29.315184] ... APIC IRR field:
[   29.315184] 000000000000000000000000000000000000000000000000000000000000=
8000
[   29.315184] ... APIC ESR: 00000000
[   29.315184] ... APIC ICR: 000008fd
[   29.315184] ... APIC ICR2: 02000000
[   29.315184] ... APIC LVTT: 000000ef
[   29.315184] ... APIC LVTPC: 00010000
[   29.315184] ... APIC LVT0: 00010700
[   29.315184] ... APIC LVT1: 00000400
[   29.315184] ... APIC LVTERR: 000000fe
[   29.315184] ... APIC TMICT: 00048dfe
[   29.315184] ... APIC TMCCT: 00000000
[   29.315184] ... APIC TDCR: 00000003
[   29.315184]=20
[   29.327071] number of MP IRQ sources: 15.
[   29.327820] number of IO-APIC #0 registers: 24.
[   29.328622] testing the IO APIC.......................
[   29.329572] IO APIC #0......
[   29.330306] .... register #00: 00000000
[   29.330989] .......    : physical APIC id: 00
[   29.331767] .......    : Delivery Type: 0
[   29.332479] .......    : LTS          : 0
[   29.333205] .... register #01: 00170011
[   29.333889] .......     : max redirection entries: 17
[   29.334793] .......     : PRQ implemented: 0
[   29.335546] .......     : IO APIC version: 11
[   29.336319] .... register #02: 00000000
[   29.337047] .......     : arbitration: 00
[   29.337771] .... IRQ redirection table:
[   29.338479] 1    0    0   0   0    0    0    00
[   29.339318] 0    0    0   0   0    1    1    31
[   29.340224] 0    0    0   0   0    1    1    30
[   29.341056] 0    0    0   0   0    1    1    33
[   29.341898] 1    0    0   0   0    1    1    34
[   29.342720] 1    1    0   0   0    1    1    35
[   29.343547] 0    0    0   0   0    1    1    36
[   29.344384] 0    0    0   0   0    1    1    37
[   29.345224] 0    0    0   0   0    1    1    38
[   29.346048] 0    1    0   0   0    1    1    39
[   29.346913] 1    1    0   0   0    1    1    3A
[   29.347752] 1    1    0   0   0    1    1    3B
[   29.348564] 0    0    0   0   0    1    1    3C
[   29.349405] 0    0    0   0   0    1    1    3D
[   29.350474] 0    0    0   0   0    1    1    3E
[   29.351312] 0    0    0   0   0    1    1    3F
[   29.352135] 1    0    0   0   0    0    0    00
[   29.352957] 1    0    0   0   0    0    0    00
[   29.353799] 1    0    0   0   0    0    0    00
[   29.354625] 1    0    0   0   0    0    0    00
[   29.355455] 1    0    0   0   0    0    0    00
[   29.356282] 1    0    0   0   0    0    0    00
[   29.357157] 1    0    0   0   0    0    0    00
[   29.357990] 1    0    0   0   0    0    0    00
[   29.358794] IRQ to pin mappings:
[   29.359379] IRQ0 -> 0:2
[   29.359884] IRQ1 -> 0:1
[   29.360493] IRQ3 -> 0:3
[   29.361002] IRQ4 -> 0:4
[   29.361512] IRQ5 -> 0:5
[   29.362010] IRQ6 -> 0:6
[   29.362518] IRQ7 -> 0:7
[   29.363019] IRQ8 -> 0:8
[   29.363530] IRQ9 -> 0:9
[   29.364028] IRQ10 -> 0:10
[   29.364567] IRQ11 -> 0:11
[   29.365091] IRQ12 -> 0:12
[   29.365628] IRQ13 -> 0:13
[   29.366164] IRQ14 -> 0:14
[   29.366701] IRQ15 -> 0:15
[   29.367259] .................................... done.
[   29.368178] Using IPI Shortcut mode
[   29.369412] Loading module verification certificates
modprobe: FATAL: Could not load /lib/modules/3.12.0-rc6-01322-gf421436/modu=
les.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc6-01322-gf421436/modu=
les.dep: No such file or directory

[   29.391493] MODSIGN: Problem loading in-kernel X.509 certificate (-65)
modprobe: FATAL: Could not load /lib/modules/3.12.0-rc6-01322-gf421436/modu=
les.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc6-01322-gf421436/modu=
les.dep: No such file or directory

[   29.407555] Key type trusted registered
modprobe: FATAL: Could not load /lib/modules/3.12.0-rc6-01322-gf421436/modu=
les.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc6-01322-gf421436/modu=
les.dep: No such file or directory

[   29.423697] Key type encrypted registered
modprobe: FATAL: Could not load /lib/modules/3.12.0-rc6-01322-gf421436/modu=
les.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc6-01322-gf421436/modu=
les.dep: No such file or directory

[   29.440589] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   29.441677] EDD information not available.
[   29.445457] Freeing unused kernel memory: 1824K (81a1e000 - 81be6000)
[   29.447869] Write protecting the kernel text: 6836k
[   29.449622] Write protecting the kernel read-only data: 2536k
modprobe: FATAL: Could not load /lib/modules/3.12.0-rc6-01322-gf421436/modu=
les.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc6-01322-gf421436/modu=
les.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc6-01322-gf421436/modu=
les.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc6-01322-gf421436/modu=
les.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc6-01322-gf421436/modu=
les.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc6-01322-gf421436/modu=
les.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc6-01322-gf421436/modu=
les.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc6-01322-gf421436/modu=
les.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc6-01322-gf421436/modu=
les.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc6-01322-gf421436/modu=
les.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc6-01322-gf421436/modu=
les.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc6-01322-gf421436/modu=
les.dep: No such file or directory

mountall: Event failed
modprobe: FATAL: Could not load /lib/modules/3.12.0-rc6-01322-gf421436/modu=
les.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc6-01322-gf421436/modu=
les.dep: No such file or directory

[   29.757504] init: Failed to create pty - disabling logging for job
[   29.758758] init: Temporary process spawn error: No such file or directo=
ry
modprobe: FATAL: Could not load /lib/modules/3.12.0-rc6-01322-gf421436/modu=
les.dep: No such file or directory

mount: unknown filesystem type 'devpts'
mountall: mount /dev/pts [152] terminated with status 32
mountall: Filesystem could not be mounted: /dev/pts
mountall: Skipping mounting /dev/pts since Plymouth is not available
[   29.793925] init: Failed to create pty - disabling logging for job
[   29.794939] init: Temporary process spawn error: No such file or directo=
ry
[   29.856989] init: Failed to create pty - disabling logging for job
[   29.858166] init: Temporary process spawn error: No such file or directo=
ry
[   29.862722] init: Failed to create pty - disabling logging for job
[   29.863973] init: Temporary process spawn error: No such file or directo=
ry
[   29.982933] init: Failed to create pty - disabling logging for job
[   29.984216] init: Temporary process spawn error: No such file or directo=
ry
[   29.989455] init: Failed to create pty - disabling logging for job
[   29.990880] init: Temporary process spawn error: No such file or directo=
ry
[   30.005971] init: Failed to create pty - disabling logging for job
[   30.007271] init: Temporary process spawn error: No such file or directo=
ry
[   30.016434] init: Failed to create pty - disabling logging for job
[   30.017656] init: Temporary process spawn error: No such file or directo=
ry
[   30.030774] init: plymouth-log main process (191) terminated with status=
 1
[   30.047323] init: Failed to create pty - disabling logging for job
[   30.048559] init: Temporary process spawn error: No such file or directo=
ry
udevd[197]: error: runtime directory '/run/udev' not writable, for now fall=
ing back to '/dev/.udev'
[   30.073981] init: Failed to create pty - disabling logging for job
[   30.075053] init: Temporary process spawn error: No such file or directo=
ry
[   30.077836] udevd[199]: starting version 175
[   30.079912] init: Failed to create pty - disabling logging for job
[   30.081248] init: Temporary process spawn error: No such file or directo=
ry
[   30.089168] init: Failed to create pty - disabling logging for job
[   30.090911] init: Temporary process spawn error: No such file or directo=
ry
[   30.640492] init: Failed to create pty - disabling logging for job
[   30.641571] init: Temporary process spawn error: No such file or directo=
ry
[   30.649776] init: Failed to create pty - disabling logging for job
[   30.651030] init: Temporary process spawn error: No such file or directo=
ry
[   30.662374] init: Failed to create pty - disabling logging for job
[   30.663553] init: Temporary process spawn error: No such file or directo=
ry
[   30.673760] init: Failed to create pty - disabling logging for job
[   30.675014] init: Temporary process spawn error: No such file or directo=
ry
[   30.684354] init: Failed to create pty - disabling logging for job
[   30.685515] init: Temporary process spawn error: No such file or directo=
ry
[   30.703628] init: udev-fallback-graphics main process (284) terminated w=
ith status 1
[   30.712558] init: Failed to create pty - disabling logging for job
[   30.713825] init: Temporary process spawn error: No such file or directo=
ry
[   30.730826] init: Failed to create pty - disabling logging for job
[   30.732111] init: Temporary process spawn error: No such file or directo=
ry
[   30.773942] init: Failed to create pty - disabling logging for job
[   30.775257] init: Temporary process spawn error: No such file or directo=
ry
[   30.784870] init: plymouth-splash main process (294) terminated with sta=
tus 1
[   30.841906] init: networking main process (293) terminated with status 1
[   30.925961] init: failsafe main process (299) killed by TERM signal
[   31.045818] init: Failed to create pty - disabling logging for job
[   31.047669] init: Temporary process spawn error: No such file or directo=
ry
[   31.053142] init: Failed to create pty - disabling logging for job
[   31.054445] init: Temporary process spawn error: No such file or directo=
ry
[   31.064593] init: Failed to create pty - disabling logging for job
[   31.065909] init: Temporary process spawn error: No such file or directo=
ry
[   31.072596] init: Failed to create pty - disabling logging for job
[   31.073884] init: Temporary process spawn error: No such file or directo=
ry
[   31.087140] init: Failed to create pty - disabling logging for job
[   31.088448] init: Temporary process spawn error: No such file or directo=
ry
Kernel tests: Boot OK!
Kernel tests: Boot OK!
Trinity v1.0  Dave Jones <davej@redhat.com> 2012
No idea what syscall (get_robust_list) is.
[   41.059420] init: tty4 main process (334) terminated with status 1
[   41.060567] init: tty4 main process ended, respawning
[   41.084609] init: tty5 main process (335) terminated with status 1
[   41.085621] init: tty5 main process ended, respawning
[   41.093781] init: tty3 main process (338) terminated with status 1
[   41.096062] init: tty3 main process ended, respawning
[   41.098530] init: tty2 main process (336) terminated with status 1
[   41.099484] init: tty2 main process ended, respawning
[   41.112730] init: tty6 main process (339) terminated with status 1
[   41.113923] init: tty6 main process ended, respawning
[   51.071903] init: tty4 main process (363) terminated with status 1
[   51.072985] init: tty4 main process ended, respawning
[   51.098818] init: tty5 main process (364) terminated with status 1
[   51.099900] init: tty5 main process ended, respawning
[   51.115514] init: tty3 main process (365) terminated with status 1
[   51.116652] init: tty3 main process ended, respawning
[   51.128873] init: tty2 main process (366) terminated with status 1
[   51.129988] init: tty2 main process ended, respawning
[   51.132257] init: tty6 main process (367) terminated with status 1
[   51.133348] init: tty6 main process ended, respawning
[   61.085010] init: tty4 main process (368) terminated with status 1
[   61.086030] init: tty4 main process ended, respawning
[   61.111993] init: tty5 main process (369) terminated with status 1
[   61.113138] init: tty5 main process ended, respawning
[   61.130231] init: tty3 main process (370) terminated with status 1
[   61.131356] init: tty3 main process ended, respawning
[   61.148874] init: tty2 main process (371) terminated with status 1
[   61.150122] init: tty2 main process ended, respawning
[   61.158418] init: tty6 main process (372) terminated with status 1
[   61.159644] init: tty6 main process ended, respawning
[   71.097156] init: tty4 main process (373) terminated with status 1
[   71.098268] init: tty4 main process ended, respawning
[   71.125392] init: tty5 main process (374) terminated with status 1
[   71.126510] init: tty5 main process ended, respawning
[   71.143461] init: tty3 main process (375) terminated with status 1
[   71.144534] init: tty3 main process ended, respawning
[   71.165546] init: tty2 main process (376) terminated with status 1
[   71.166688] init: tty2 main process ended, respawning
[   71.175986] init: tty6 main process (377) terminated with status 1
[   71.177216] init: tty6 main process ended, respawning
[   81.109987] init: tty4 main process (378) terminated with status 1
[   81.111400] init: tty4 main process ended, respawning
[   81.139555] init: tty5 main process (379) terminated with status 1
[   81.140766] init: tty5 main process ended, respawning
[   81.157305] init: tty3 main process (380) terminated with status 1
[   81.158432] init: tty3 main process ended, respawning
[   81.182623] init: tty2 main process (381) terminated with status 1
[   81.183762] init: tty2 main process ended, respawning
[   81.193527] init: tty6 main process (382) terminated with status 1
[   81.194723] init: tty6 main process ended, respawning
error: 'rc.local' exited outside the expected code flow.
[   89.609340] init: Failed to create pty - disabling logging for job
[   89.610623] init: Temporary process spawn error: No such file or directo=
ry
[   89.642783] init: rc main process (333) killed by TERM signal
[   89.645409] init: tty4 main process (383) killed by TERM signal
[   89.648536] init: tty5 main process (384) killed by TERM signal
[   89.652003] init: tty3 main process (385) killed by TERM signal
[   89.655028] init: tty2 main process (386) killed by TERM signal
[   89.658224] init: tty6 main process (387) killed by TERM signal
[   89.662471] init: hwclock-save main process (390) terminated with status=
 70
[   89.665606] init: plymouth-upstart-bridge main process (391) terminated =
with status 1
 * Asking all remaining processes to terminate...      =20
 * All processes ended within 1 seconds....      =20
 * Deactivating swap...      =20
umount: /run/lock: not mounted
 * Will now restart
[   90.378895] Unregister pv shared memory for cpu 0
[   90.379653] Unregister pv shared memory for cpu 1
[   90.381959] reboot: Restarting system
[   90.382585] reboot: machine restart
Elapsed time: 95
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-i=
000-1104/f421436a591d34fa5279b54a96ac07d70250cc8d/vmlinuz-3.12.0-rc6-01322-=
gf421436 -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeout=3D100 l=
og_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_prin=
tk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,1152=
00 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/ru=
n-queue/kvm/i386-randconfig-i000-1104/net-next:master/.vmlinuz-f421436a591d=
34fa5279b54a96ac07d70250cc8d-20131104143152-3-xian branch=3Dnet-next/master=
 BOOT_IMAGE=3D/kernel/i386-randconfig-i000-1104/f421436a591d34fa5279b54a96a=
c07d70250cc8d/vmlinuz-3.12.0-rc6-01322-gf421436'  -initrd /kernel-tests/ini=
trd/quantal-core-i386.cgz -m 256M -smp 2 -net nic,vlan=3D1,model=3De1000 -n=
et user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -drive file=
=3D/fs/LABEL=3DKVM/disk0-quantal-xian-2,media=3Ddisk,if=3Dvirtio -drive fil=
e=3D/fs/LABEL=3DKVM/disk1-quantal-xian-2,media=3Ddisk,if=3Dvirtio -drive fi=
le=3D/fs/LABEL=3DKVM/disk2-quantal-xian-2,media=3Ddisk,if=3Dvirtio -drive f=
ile=3D/fs/LABEL=3DKVM/disk3-quantal-xian-2,media=3Ddisk,if=3Dvirtio -drive =
file=3D/fs/LABEL=3DKVM/disk4-quantal-xian-2,media=3Ddisk,if=3Dvirtio -drive=
 file=3D/fs/LABEL=3DKVM/disk5-quantal-xian-2,media=3Ddisk,if=3Dvirtio -pidf=
ile /dev/shm/kboot/pid-quantal-xian-2 -serial file:/dev/shm/kboot/serial-qu=
antal-xian-2 -daemonize -display none -monitor null=20

--8P1HSweYDcXXzwPJ
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-f421436a591d34fa5279b54a96ac07d70250cc8d-i386-randconfig-i000-1104-INFO:-rcu_sched-self-detected-stall-on-CPU--79724.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IGRjYjMwZTY1OTI4N2E2YjQwZGFmZWQxMzYyNTMyZGE0MmVjMjcyMjkK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgZjQyMTQzNi4uLiBuZXQvaHNyOiBBZGQgc3Vw
cG9ydCBmb3IgdGhlIEhpZ2gtYXZhaWxhYmlsaXR5IFNlYW1sZXNzIFJlZHVuZGFuY3kgcHJv
dG9jb2wgKEhTUnYwKQpIRUFEIGlzIG5vdyBhdCBkY2IzMGU2Li4uIE1lcmdlIHRhZyAnYXJt
NjQtc3RhYmxlJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5l
bC9naXQvY21hcmluYXMvbGludXgtYWFyY2g2NApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1x
dWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWkwMDAtMTEwNC9uZXQtbmV4dDptYXN0ZXI6ZGNi
MzBlNjU5Mjg3YTZiNDBkYWZlZDEzNjI1MzJkYTQyZWMyNzIyOTpiaXNlY3QtdXNiCgoyMDEz
LTExLTA0LTE5OjQwOjU5IGRjYjMwZTY1OTI4N2E2YjQwZGFmZWQxMzYyNTMyZGE0MmVjMjcy
MjkgY29tcGlsaW5nCjQxNyByZWFsICAxMjU3IHVzZXIgIDEzMCBzeXMgIDMzMi4zNiUgY3B1
IAlpMzg2LXJhbmRjb25maWctaTAwMC0xMTA0CgoyMDEzLTExLTA0LTE5OjQ4OjM0IGRldGVj
dGluZyBib290IHN0YXRlIDMuMTIuMC1yYzEtMDAyNTUtZ2RjYjMwZTYuLi4JOQkxMy4JMTUJ
MjAgU1VDQ0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCBkY2IzMGU2NTkyODdhNmI0MGRhZmVk
MTM2MjUzMmRhNDJlYzI3MjI5CmdpdCBiaXNlY3Qgc3RhcnQgZjQyMTQzNmE1OTFkMzRmYTUy
NzliNTRhOTZhYzA3ZDcwMjUwY2M4ZCBkY2IzMGU2NTkyODdhNmI0MGRhZmVkMTM2MjUzMmRh
NDJlYzI3MjI5IC0tClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGRjYjMwZTYuLi4gTWVy
Z2UgdGFnICdhcm02NC1zdGFibGUnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20v
bGludXgva2VybmVsL2dpdC9jbWFyaW5hcy9saW51eC1hYXJjaDY0CkhFQUQgaXMgbm93IGF0
IDZlNDY2NDUuLi4gTGludXggMy4xMQpCaXNlY3Rpbmc6IDExODEgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEwIHN0ZXBzKQpbNTNhZjUzYWU4M2ZlOTYw
Y2ViOWVmNzRjYWM3OTE1ZTkwODhmNDI2Nl0gTWVyZ2UgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcv
cHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2RhdmVtL25ldApnaXQgYmlzZWN0IHJ1biAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Iv
b2JqLWJpc2VjdApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaTAwMC0xMTA0L25ldC1uZXh0Om1hc3Rl
cjo1M2FmNTNhZTgzZmU5NjBjZWI5ZWY3NGNhYzc5MTVlOTA4OGY0MjY2OmJpc2VjdC11c2IK
CjIwMTMtMTEtMDQtMTk6NTI6NTAgNTNhZjUzYWU4M2ZlOTYwY2ViOWVmNzRjYWM3OTE1ZTkw
ODhmNDI2NiBjb21waWxpbmcKMjM3IHJlYWwgIDEzNTggdXNlciAgMTIwIHN5cyAgNjIzLjcx
JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1pMDAwLTExMDQKCjIwMTMtMTEtMDQtMTk6NTc6MTQg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLXJjMy0wMDgwMi1nNTNhZjUzYS4uLgkyCTEy
CTE5Li4uLi4uCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogNTM4IHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBzKQpbZGIxMGFjY2ZkMjY2YTkzMTQ5
Y2QyMWNkNzUwMjZhYTAzYzYzNWU3ZV0gTWVyZ2UgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHVi
L3NjbS9saW51eC9rZXJuZWwvZ2l0L2RhdmVtL25ldApydW5uaW5nIC9jL2tlcm5lbC10ZXN0
cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0
CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaTAw
MC0xMTA0L25ldC1uZXh0Om1hc3RlcjpkYjEwYWNjZmQyNjZhOTMxNDljZDIxY2Q3NTAyNmFh
MDNjNjM1ZTdlOmJpc2VjdC11c2IKCjIwMTMtMTEtMDQtMjA6MDM6NDUgZGIxMGFjY2ZkMjY2
YTkzMTQ5Y2QyMWNkNzUwMjZhYTAzYzYzNWU3ZSBjb21waWxpbmcKMjM2IHJlYWwgIDEzODIg
dXNlciAgMTI1IHN5cyAgNjM4Ljg4JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1pMDAwLTExMDQK
CjIwMTMtMTEtMDQtMjA6MDg6MDMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLXJjNi0w
MDIzNy1nZGIxMGFjYy4uCTMJOAkxNAkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDI2OSByZXZp
c2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOCBzdGVwcykKWzVmMjU4
YTE1NTJkMWE4ZmQyNjMzNDY2MzUwMjJmZGYxNmFhMDZkNmFdIG5ldDogZGwyazogcmVtb3Zl
IHVubmVjZXNzYXJ5IHBjaV9zZXRfZHJ2ZGF0YSgpCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pMDAw
LTExMDQvbmV0LW5leHQ6bWFzdGVyOjVmMjU4YTE1NTJkMWE4ZmQyNjMzNDY2MzUwMjJmZGYx
NmFhMDZkNmE6YmlzZWN0LXVzYgoKMjAxMy0xMS0wNC0yMDoxMTowNCA1ZjI1OGExNTUyZDFh
OGZkMjYzMzQ2NjM1MDIyZmRmMTZhYTA2ZDZhIGNvbXBpbGluZwoyMzIgcmVhbCAgMTM5OSB1
c2VyICAxMjMgc3lzICA2NTQuNzglIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWkwMDAtMTEwNAoK
MjAxMy0xMS0wNC0yMDoxNToyMiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmMzLTAx
MDcxLWc1ZjI1OGExLi4JMQk4CTExCTE3CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMTMzIHJl
dmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA3IHN0ZXBzKQpbYjQ1
YmQ0NmRlY2Q5NDdlYWEzNDk3Njk5ZDQ1MGUwODUxZDI0NzUzNF0gTWVyZ2UgdGFnICdiYXRt
YW4tYWR2LWZvci1kYXZlbScgb2YgZ2l0Oi8vZ2l0Lm9wZW4tbWVzaC5vcmcvbGludXgtbWVy
Z2UKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWkwMDAtMTEwNC9uZXQtbmV4dDptYXN0ZXI6YjQ1YmQ0
NmRlY2Q5NDdlYWEzNDk3Njk5ZDQ1MGUwODUxZDI0NzUzNDpiaXNlY3QtdXNiCgoyMDEzLTEx
LTA0LTIwOjE4OjUzIGI0NWJkNDZkZWNkOTQ3ZWFhMzQ5NzY5OWQ0NTBlMDg1MWQyNDc1MzQg
Y29tcGlsaW5nCjIzOSByZWFsICAxMzk2IHVzZXIgIDEyNSBzeXMgIDYzNC42MSUgY3B1IAlp
Mzg2LXJhbmRjb25maWctaTAwMC0xMTA0CgoyMDEzLTExLTA0LTIwOjIzOjIwIGRldGVjdGlu
ZyBib290IHN0YXRlIDMuMTIuMC1yYzYtMDExODgtZ2I0NWJkNDYuLgk2CTIwIFNVQ0NFU1MK
CkJpc2VjdGluZzogNjYgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3Vn
aGx5IDYgc3RlcHMpCls2YzdhOWEzYzc4MzhlYWIxZjE3ZWYwMGM4NzkyNTE1MWJlMDZjZjFj
XSBtdm5ldGE6IGRyb3AgcmVkdW5kYW50IG1hYyBhZGRyZXNzIGNoZWNrCnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNi
L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFu
ZGNvbmZpZy1pMDAwLTExMDQvbmV0LW5leHQ6bWFzdGVyOjZjN2E5YTNjNzgzOGVhYjFmMTdl
ZjAwYzg3OTI1MTUxYmUwNmNmMWM6YmlzZWN0LXVzYgoKMjAxMy0xMS0wNC0yMDoyNToyMSA2
YzdhOWEzYzc4MzhlYWIxZjE3ZWYwMGM4NzkyNTE1MWJlMDZjZjFjIGNvbXBpbGluZwo1MSBy
ZWFsICAyNjcgdXNlciAgMzQgc3lzICA1ODguNDUlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWkw
MDAtMTEwNAoKMjAxMy0xMS0wNC0yMDoyNjozNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEy
LjAtcmM2LTAxMjU1LWc2YzdhOWEzYy4uLgkyCTMJNS4JNy4JOC4JMTIJMTYJMjAgU1VDQ0VT
UwoKQmlzZWN0aW5nOiAzMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgNSBzdGVwcykKW2JlZDZmNzYyMTIzZmM1M2M2M2VmZWYzODY1MzFkZDg3N2NiYTI0
NjhdIG5ldDogY2RjX25jbTogcmVtb3ZlIHJlZHVuZGFudCBuZXRkZXYgZmllbGQKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dm
Zy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4
Ni1yYW5kY29uZmlnLWkwMDAtMTEwNC9uZXQtbmV4dDptYXN0ZXI6YmVkNmY3NjIxMjNmYzUz
YzYzZWZlZjM4NjUzMWRkODc3Y2JhMjQ2ODpiaXNlY3QtdXNiCgoyMDEzLTExLTA0LTIwOjMz
OjM4IGJlZDZmNzYyMTIzZmM1M2M2M2VmZWYzODY1MzFkZDg3N2NiYTI0NjggY29tcGlsaW5n
CjQ1IHJlYWwgIDE2MSB1c2VyICAyOSBzeXMgIDQyMy44NCUgY3B1IAlpMzg2LXJhbmRjb25m
aWctaTAwMC0xMTA0CgoyMDEzLTExLTA0LTIwOjM0OjQ3IGRldGVjdGluZyBib290IHN0YXRl
IDMuMTIuMC1yYzYtMDEyODgtZ2JlZDZmNzYuLi4uLi4uCTEJMgkzCTUJMTIJMTYJMjAgU1VD
Q0VTUwoKQmlzZWN0aW5nOiAxNiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgNCBzdGVwcykKWzU5ZWRlMzE2OGEwYjNmZTAyZjgyYTdiZWQ1MjQzMmYxOGRi
YjEwNzBdIG5ldDogY2RjX25jbTogcmV0dXJuIHByb3BlciBlcnJvciBpZiBzZXR1cCBmYWls
cwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWctaTAwMC0xMTA0L25ldC1uZXh0Om1hc3Rlcjo1OWVkZTMx
NjhhMGIzZmUwMmY4MmE3YmVkNTI0MzJmMThkYmIxMDcwOmJpc2VjdC11c2IKCjIwMTMtMTEt
MDQtMjA6NDE6NDggNTllZGUzMTY4YTBiM2ZlMDJmODJhN2JlZDUyNDMyZjE4ZGJiMTA3MCBj
b21waWxpbmcKNTggcmVhbCAgMTUwIHVzZXIgIDI5IHN5cyAgMzA1LjY2JSBjcHUgCWkzODYt
cmFuZGNvbmZpZy1pMDAwLTExMDQKCjIwMTMtMTEtMDQtMjA6NDM6MTIgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgMy4xMi4wLXJjNi0wMTMwNS1nNTllZGUzMS4uLgk2CTkJMTIuCTE1CTE2Lgkx
OS4uLgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDcgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMpClsyOTZjMTA2MzlhMzM5NDFkMDA5MGFmYTE3
Yjc1MzVmY2JmODFkOTdhXSBNZXJnZSBicmFuY2ggJ21hc3Rlcicgb2YgZ2l0Oi8vZ2l0Lmtl
cm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2tsYXNzZXJ0L2lwc2VjLW5leHQK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9o
b21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0vaTM4Ni1yYW5kY29uZmlnLWkwMDAtMTEwNC9uZXQtbmV4dDptYXN0ZXI6Mjk2YzEwNjM5
YTMzOTQxZDAwOTBhZmExN2I3NTM1ZmNiZjgxZDk3YTpiaXNlY3QtdXNiCgoyMDEzLTExLTA0
LTIwOjUwOjQzIDI5NmMxMDYzOWEzMzk0MWQwMDkwYWZhMTdiNzUzNWZjYmY4MWQ5N2EgY29t
cGlsaW5nCjUyIHJlYWwgIDE0OCB1c2VyICAyNyBzeXMgIDMzOC4zOSUgY3B1IAlpMzg2LXJh
bmRjb25maWctaTAwMC0xMTA0CgoyMDEzLTExLTA0LTIwOjUyOjAwIGRldGVjdGluZyBib290
IHN0YXRlIDMuMTIuMC1yYzYtMDEzMTQtZzI5NmMxMDYuLi4JMwk1Li4JNgk3CTExCTE2CTIw
IFNVQ0NFU1MKCkJpc2VjdGluZzogMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgMiBzdGVwcykKWzI4MTdhMzM2ZDRkNTMzZmI4YjY4NzE5NzIzY2Q2MGVh
N2RkN2MwOWVdIG5ldDogc2tiX2NoZWNrc3VtOiBhbGxvdyBjdXN0b20gdXBkYXRlL2NvbWJp
bmUgZm9yIHdhbGtpbmcgc2tiCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5l
bC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pMDAwLTExMDQvbmV0LW5l
eHQ6bWFzdGVyOjI4MTdhMzM2ZDRkNTMzZmI4YjY4NzE5NzIzY2Q2MGVhN2RkN2MwOWU6Ymlz
ZWN0LXVzYgoKMjAxMy0xMS0wNC0yMDo1ODowMSAyODE3YTMzNmQ0ZDUzM2ZiOGI2ODcxOTcy
M2NkNjBlYTdkZDdjMDllIGNvbXBpbGluZwo2OSByZWFsICAyOTkgdXNlciAgMzUgc3lzICA0
NzguNjIlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWkwMDAtMTEwNAoKMjAxMy0xMS0wNC0yMDo1
OTozMyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmM2LTAxMzE4LWcyODE3YTMzLi4u
LiBURVNUIEZBSUxVUkUKWyAgICAyLjY0MjkwMl0gY3JjMzJjOiBDUkNfTEVfQklUUyA9IDEK
WyAgICAyLjY0MzU2NF0gY3JjMzJjOiBzZWxmIHRlc3RzIHBhc3NlZCwgcHJvY2Vzc2VkIDIy
NTk0NCBieXRlcyBpbiA2NzUzODM5IG5zZWMKWyAgIDE4LjEzNTU1M10gY3JjMzJfY29tYmlu
ZTogMTEzMDcyIHNlbGYgdGVzdHMgcGFzc2VkClsgICAyMy42MDAwMzFdIElORk86IHJjdV9z
Y2hlZCBzZWxmLWRldGVjdGVkIHN0YWxsIG9uIENQVSB7IDB9ICAodD0yMTAxIGppZmZpZXMg
Zz00Mjk0OTY3MDk1IGM9NDI5NDk2NzA5NCBxPTQ4KQpbICAgMjMuNjAwMDMxXSBzZW5kaW5n
IE5NSSB0byBhbGwgQ1BVczoKWyAgIDIzLjYwMDAzMV0gTk1JIGJhY2t0cmFjZSBmb3IgY3B1
IDAKWyAgIDIzLjYwMDAzMV0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRh
aW50ZWQgMy4xMi4wLXJjNi0wMTMxOC1nMjgxN2EzMyAjNzEzClsgICAyMy42MDAwMzFdIHRh
c2s6IDgwMTM4MDAwIHRpOiA4MDE0MDAwMCB0YXNrLnRpOiA4MDE0MDAwMApbICAgMjMuNjAw
MDMxXSBFSVA6IDAwNjA6Wzw4MTA1N2U2ND5dIEVGTEFHUzogMDAwMTAwNDYgQ1BVOiAwClsg
ICAyMy42MDAwMzFdIEVJUCBpcyBhdCBkZWZhdWx0X3NlbmRfSVBJX21hc2tfbG9naWNhbCsw
eDE2NC8weDFmMApbICAgMjMuNjAwMDMxXSBFQVg6IGZmZmZmMDAwIEVCWDogMDMwMDAwMDAg
RUNYOiBmZmZmZjAwMCBFRFg6IDAwMDAwYzAwClsgICAyMy42MDAwMzFdIEVTSTogMDAwMDAw
NDYgRURJOiAwMDAwMDAwMiBFQlA6IDgwMTQxY2UwIEVTUDogODAxNDFjZDAKWyAgIDIzLjYw
MDAzMV0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAwMGUwIFNTOiAwMDY4Clsg
ICAyMy42MDAwMzFdIENSMDogODAwNTAwM2IgQ1IyOiAwMDAwMDAwMCBDUjM6IDAxYmUyMDAw
IENSNDogMDAwMDA2ZDAKWyAgIDIzLjYwMDAzMV0gU3RhY2s6ClsgICAyMy42MDAwMzFdICAw
MDAwMDgwMCAwMDAwMjcxMCA4ZGJiYTFhMCA4MTk1YmI4MCA4MDE0MWNlYyA4MTA1ODAyYyAw
MDAwMjcxMCA4MDE0MWNmYwpbICAgMjMuNjAwMDMxXSAgODEwNTg3MTEgODE4OTA1Y2MgMDAw
MDAwMzAgODAxNDFkNDAgODExNWNlM2MgODE4YTRjODQgMDAwMDA4MzUgZmZmZmZmMzcKWyAg
IDIzLjYwMDAzMV0gIGZmZmZmZjM2IDAwMDAwMDMwIDgwMTQxZDQwIDgxMGNmZWFkIDAwMDAw
MDAxIDgwMTQwMDAwIDhkYmJhMWEwIDAwMDAwMDAwClsgICAyMy42MDAwMzFdIENhbGwgVHJh
Y2U6ClsgICAyMy42MDAwMzFdICBbPDgxMDU4MDJjPl0gZGVmYXVsdF9zZW5kX0lQSV9hbGwr
MHgyYy8weGQwClsgICAyMy42MDAwMzFdICBbPDgxMDU4NzExPl0gYXJjaF90cmlnZ2VyX2Fs
bF9jcHVfYmFja3RyYWNlKzB4OTEvMHgxMzAKWyAgIDIzLjYwMDAzMV0gIFs8ODExNWNlM2M+
XSByY3VfY2hlY2tfY2FsbGJhY2tzKzB4MzVjLzB4YTQwClsgICAyMy42MDAwMzFdICBbPDgx
MGNmZWFkPl0gPyBhY2NvdW50X3Byb2Nlc3NfdGljaysweDFlZC8weDJlMApbICAgMjMuNjAw
MDMxXSAgWzw4MTA4ZWY1Zj5dIHVwZGF0ZV9wcm9jZXNzX3RpbWVzKzB4NmYvMHhlMApbICAg
MjMuNjAwMDMxXSAgWzw4MTExNWQyMT5dIHRpY2tfc2NoZWRfaGFuZGxlLmlzcmEuMTIrMHg3
MS8weGEwClsgICAyMy42MDAwMzFdICBbPDgxMTE1ZGJhPl0gdGlja19zY2hlZF90aW1lcisw
eDZhLzB4YzAKWyAgIDIzLjYwMDAzMV0gIFs8ODEwYjU4NDc+XSBfX3J1bl9ocnRpbWVyLmlz
cmEuMTcrMHhjNy8weDFiMApbICAgMjMuNjAwMDMxXSAgWzw4MTExNWQ1MD5dID8gdGlja19z
Y2hlZF9oYW5kbGUuaXNyYS4xMisweGEwLzB4YTAKWyAgIDIzLjYwMDAzMV0gIFs8ODEwYjY4
ODM+XSBocnRpbWVyX2ludGVycnVwdCsweDFiMy8weDNkMApbICAgMjMuNjAwMDMxXSAgWzw4
MTE1YmQ3OT5dID8gcmN1X2lycV9lbnRlcisweDEzOS8weDE5MApbICAgMjMuNjAwMDMxXSAg
Wzw4MTA1NDk0MT5dIGxvY2FsX2FwaWNfdGltZXJfaW50ZXJydXB0KzB4ODEvMHhhMApbICAg
MjMuNjAwMDMxXSAgWzw4MTA4NWI4ZT5dID8gaXJxX2VudGVyKzB4MWUvMHhmMApbICAgMjMu
NjAwMDMxXSAgWzw4MTA1NGRhOD5dIHNtcF9hcGljX3RpbWVyX2ludGVycnVwdCsweDU4LzB4
OTAKWyAgIDIzLjYwMDAzMV0gIFs8ODE2YWJjODI+XSBhcGljX3RpbWVyX2ludGVycnVwdCsw
eDM2LzB4M2MKWyAgIDIzLjYwMDAzMV0gIFs8ODFhNTJlMjk+XSA/IGNyYzMydGVzdF9pbml0
KzB4MTBmMC8weDEzMTcKWyAgIDIzLjYwMDAzMV0gIFs8ODFhNTFkMzk+XSA/IGRlYnVnX29i
amVjdHNfbWVtX2luaXQrMHgzZWIvMHgzZWIKWyAgIDIzLjYwMDAzMV0gIFs8ODEwMDA0NDA+
XSBkb19vbmVfaW5pdGNhbGwrMHgxMDAvMHgyNTAKWyAgIDIzLjYwMDAzMV0gIFs8ODEwYWM5
OTE+XSA/IHBhcmFtZXErMHgyMS8weGYwClsgICAyMy42MDAwMzFdICBbPDgxYTEyNzAwPl0g
PyBkb19lYXJseV9wYXJhbSsweDExMC8weDEyYgpbICAgMjMuNjAwMDMxXSAgWzw4MTBhY2U1
Mj5dID8gcGFyc2VfYXJncysweDNmMi8weDVkMApbICAgMjMuNjAwMDMxXSAgWzw4MWExMzk0
ZD5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MmU0LzB4NDdhClsgICAyMy42MDAwMzFdICBb
PDgxYTEyNzFiPl0gPyBkb19lYXJseV9wYXJhbSsweDEyYi8weDEyYgpbICAgMjMuNjAwMDMx
XSAgWzw4MTY4YmVjOT5dIGtlcm5lbF9pbml0KzB4MTkvMHgyOTAKWyAgIDIzLjYwMDAzMV0g
IFs8ODE2YWMwZDc+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MWIvMHgyOApbICAgMjMu
NjAwMDMxXSAgWzw4MTY4YmViMD5dID8gcmVzdF9pbml0KzB4MTkwLzB4MTkwClsgICAyMy42
MDAwMzFdICBbPDgxYTU3OTJiPl0gPyBhY3BpX2Jvb3RfZWNfZW5hYmxlKzB4NTUvMHg3Ygpb
ICAgMjMuNjAwMDMxXSBDb2RlOiBmOCBmNCBjMCA4MSAwMSA4MyAxNSBmYyBmNCBjMCA4MSAw
MCBlYiAxMiA5MCA4MCBjZSAwNCA4MyAwNSAwMCBmNSBjMCA4MSAwMSA4MyAxNSAwNCBmNSBj
MCA4MSAwMCBhMSAxMCBjNyA5MyA4MSA4OSA5MCAwMCBjMyBmZiBmZiA8Zjc+IGM2IDAwIDAy
IDAwIDAwIDc1IDNjIDgzIDA1IDA4IGY1IGMwIDgxIDAxIDg5IGYwIDgzIDE1IDBjIGY1Clsg
ICAyMy42MTAwNDddIE5NSSBiYWNrdHJhY2UgZm9yIGNwdSAxClsgICAyMy42MTAwNDddIENQ
VTogMSBQSUQ6IDAgQ29tbTogc3dhcHBlci8xIE5vdCB0YWludGVkIDMuMTIuMC1yYzYtMDEz
MTgtZzI4MTdhMzMgIzcxMwpbICAgMjMuNjEwMDQ3XSB0YXNrOiA4MDE1ZDJjMCB0aTogODAx
NzYwMDAgdGFzay50aTogODAxNzYwMDAKWyAgIDIzLjYxMDA0N10gRUlQOiAwMDYwOls8ODEw
NjRiNTM+XSBFRkxBR1M6IDAwMjAwMjQ2IENQVTogMQpbICAgMjMuNjEwMDQ3XSBFSVAgaXMg
YXQgbmF0aXZlX3NhZmVfaGFsdCsweDEzLzB4MzAKWyAgIDIzLjYxMDA0N10gRUFYOiA4MDE1
ZDJjMCBFQlg6IDgwMTc2MDAwIEVDWDogMDAwMDAwMDAgRURYOiAwMDAwMDAwMQpbICAgMjMu
NjEwMDQ3XSBFU0k6IGZmZmZmZmZmIEVESTogZmZmZjhiYTEgRUJQOiA4MDE3N2Y2MCBFU1A6
IDgwMTc3ZjYwClsgICAyMy42MTAwNDddICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBH
UzogMDBlMCBTUzogMDA2OApbICAgMjMuNjEwMDQ3XSBDUjA6IDgwMDUwMDNiIENSMjogZmZm
ZmZmZmYgQ1IzOiAwMWJlMjAwMCBDUjQ6IDAwMDAwNmQwClsgICAyMy42MTAwNDddIFN0YWNr
OgpbICAgMjMuNjEwMDQ3XSAgODAxNzdmNjggODEwMTQ1MDkgODAxNzdmNzAgODEwMTU2YWUg
ODAxNzdmODggODEwZjZkMGEgY2JhZWI0NjcgZGExMjM5ODAKWyAgIDIzLjYxMDA0N10gIDE0
NWM3YjVkIDhmZmZjM2MwIDgwMTc3ZmI0IDgxMDUyMjRiIDU4NzMyZGQ2IDNkNDlhMDIyIDhj
MThiNGM4IDMyNzAxMGFkClsgICAyMy42MTAwNDddICA4NDhiODQwMSAxNDVjN2I1ZCAwMTAw
MDgwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMApbICAg
MjMuNjEwMDQ3XSBDYWxsIFRyYWNlOgpbICAgMjMuNjEwMDQ3XSAgWzw4MTAxNDUwOT5dIGRl
ZmF1bHRfaWRsZSsweDI5LzB4NDAKWyAgIDIzLjYxMDA0N10gIFs8ODEwMTU2YWU+XSBhcmNo
X2NwdV9pZGxlKzB4MmUvMHg4MApbICAgMjMuNjEwMDQ3XSAgWzw4MTBmNmQwYT5dIGNwdV9z
dGFydHVwX2VudHJ5KzB4MmFhLzB4M2UwClsgICAyMy42MTAwNDddICBbPDgxMDUyMjRiPl0g
c3RhcnRfc2Vjb25kYXJ5KzB4NWViLzB4NjMwClsgICAyMy42MTAwNDddIENvZGU6IDAxIDgz
IDE1IGE0IGEwIGMxIDgxIDAwIDVkIGMzIDhkIGI0IDI2IDAwIDAwIDAwIDAwIDhkIGJjIDI3
IDAwIDAwIDAwIDAwIDU1IDgzIDA1IGE4IGEwIGMxIDgxIDAxIDg5IGU1IDgzIDE1IGFjIGEw
IGMxIDgxIDAwIGZiIGY0IDw4Mz4gMDUgYjAgYTAgYzEgODEgMDEgODMgMTUgYjQgYTAgYzEg
ODEgMDAgNWQgYzMgOGQgYjYgMDAgMDAgMDAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAw
MC0xMTA0LzI4MTdhMzM2ZDRkNTMzZmI4YjY4NzE5NzIzY2Q2MGVhN2RkN2MwOWUvZG1lc2ct
cXVhbnRhbC1zbmItMzI6MjAxMzExMDQyMTAxMjQ6aTM4Ni1yYW5kY29uZmlnLWkwMDAtMTEw
NDozLjEyLjAtcmM2LTAxMzE4LWcyODE3YTMzOjcxMwova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1pMDAwLTExMDQvMjgxN2EzMzZkNGQ1MzNmYjhiNjg3MTk3MjNjZDYwZWE3ZGQ3YzA5ZS9k
bWVzZy15b2N0by1iZW5zLTQ6MjAxMzExMDQyMTAxMjE6aTM4Ni1yYW5kY29uZmlnLWkwMDAt
MTEwNDozLjEyLjAtcmM2LTAxMzE4LWcyODE3YTMzOjcxMwova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1pMDAwLTExMDQvMjgxN2EzMzZkNGQ1MzNmYjhiNjg3MTk3MjNjZDYwZWE3ZGQ3YzA5
ZS9kbWVzZy15b2N0by1sa3Atc3QwMS03OjIwMTMxMTA1MDUwMDA0OmkzODYtcmFuZGNvbmZp
Zy1pMDAwLTExMDQ6My4xMi4wLXJjNi0wMTMxOC1nMjgxN2EzMzo3MTMKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctaTAwMC0xMTA0LzI4MTdhMzM2ZDRkNTMzZmI4YjY4NzE5NzIzY2Q2MGVh
N2RkN2MwOWUvZG1lc2cteW9jdG8tc25iLTEzOjIwMTMxMTA0MjEwMTI4OmkzODYtcmFuZGNv
bmZpZy1pMDAwLTExMDQ6My4xMi4wLXJjNi0wMTMxOC1nMjgxN2EzMzo3MTMKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaTAwMC0xMTA0LzI4MTdhMzM2ZDRkNTMzZmI4YjY4NzE5NzIzY2Q2
MGVhN2RkN2MwOWUvZG1lc2cteW9jdG8tc25iLTI2OjIwMTMxMTA0MjEwMTI5OmkzODYtcmFu
ZGNvbmZpZy1pMDAwLTExMDQ6My4xMi4wLXJjNi0wMTMxOC1nMjgxN2EzMzo3MTMKMDo1OjUg
YWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bVJFUEVBVCBDT1VOVDogMjAgICMg
L2NjL3dmZy91c2ItYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDEgcmV2aXNpb24g
bGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMSBzdGVwKQpbNmU5NWZjYWE0MmU1
MDc4YWMyNjU5NjRkZWViZWQ1OTdmOWVhZTA3YV0gbGliOiBjcmMzMjogYWRkIGZ1bmN0aW9u
YWxpdHkgdG8gY29tYmluZSB0d28gY3JjMzJ7LCBjfXMgaW4gR0YoMikKcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Iv
b2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5k
Y29uZmlnLWkwMDAtMTEwNC9uZXQtbmV4dDptYXN0ZXI6NmU5NWZjYWE0MmU1MDc4YWMyNjU5
NjRkZWViZWQ1OTdmOWVhZTA3YTpiaXNlY3QtdXNiCgoyMDEzLTExLTA0LTIxOjAxOjM2IDZl
OTVmY2FhNDJlNTA3OGFjMjY1OTY0ZGVlYmVkNTk3ZjllYWUwN2EgY29tcGlsaW5nCjYxIHJl
YWwgIDI3NCB1c2VyICAzNSBzeXMgIDUwNy4yNiUgY3B1IAlpMzg2LXJhbmRjb25maWctaTAw
MC0xMTA0CgoyMDEzLTExLTA0LTIxOjAyOjU3IGRldGVjdGluZyBib290IHN0YXRlIDMuMTIu
MC1yYzYtMDEzMTYtZzZlOTVmY2EuLi4JMQkyLgk0CTYuCTgJOQkxMAkxMgkxMy4uCTE0CTE1
CTE3CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgMCBzdGVwcykKW2VmYmE3MjFmNjM2ZWUwMTY4NTlkODZkMTU3
NDg2NTAxMTk0MDJiMTBdIGxpYjogY3JjMzI6IGFkZCB0ZXN0IGNhc2VzIGZvciBjcmMzMnss
IGN9X2NvbWJpbmUgcm91dGluZXMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWkwMDAtMTEwNC9uZXQt
bmV4dDptYXN0ZXI6ZWZiYTcyMWY2MzZlZTAxNjg1OWQ4NmQxNTc0ODY1MDExOTQwMmIxMDpi
aXNlY3QtdXNiCgoyMDEzLTExLTA0LTIxOjEzOjAwIGVmYmE3MjFmNjM2ZWUwMTY4NTlkODZk
MTU3NDg2NTAxMTk0MDJiMTAgY29tcGlsaW5nCjUzIHJlYWwgIDE1NyB1c2VyICAyNyBzeXMg
IDM0NC45NSUgY3B1IAlpMzg2LXJhbmRjb25maWctaTAwMC0xMTA0CgoyMDEzLTExLTA0LTIx
OjE0OjExIGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzYtMDEzMTctZ2VmYmE3MjFm
Li4uLiBURVNUIEZBSUxVUkUKWyAgICAxLjk5NDIyM10gY3JjMzJjOiBDUkNfTEVfQklUUyA9
IDEKWyAgICAxLjk5NDc5M10gY3JjMzJjOiBzZWxmIHRlc3RzIHBhc3NlZCwgcHJvY2Vzc2Vk
IDIyNTk0NCBieXRlcyBpbiA1ODE2MzQwIG5zZWMKWyAgIDE0LjIyMDg1N10gY3JjMzJfY29t
YmluZTogMTEzMDcyIHNlbGYgdGVzdHMgcGFzc2VkClsgICAyMi45ODAwNTZdIElORk86IHJj
dV9zY2hlZCBzZWxmLWRldGVjdGVkIHN0YWxsIG9uIENQVSB7IDF9ICAodD0yMTAwIGppZmZp
ZXMgZz00Mjk0OTY3MDYzIGM9NDI5NDk2NzA2MiBxPTQyKQpbICAgMjIuOTgwMDU2XSBzZW5k
aW5nIE5NSSB0byBhbGwgQ1BVczoKWyAgIDIyLjk4MDA1Nl0gTk1JIGJhY2t0cmFjZSBmb3Ig
Y3B1IDEKWyAgIDIyLjk4MDA1Nl0gQ1BVOiAxIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90
IHRhaW50ZWQgMy4xMi4wLXJjNi0wMTMxNy1nZWZiYTcyMWYgIzcxNQpbICAgMjIuOTgwMDU2
XSB0YXNrOiA4MDEzODAwMCB0aTogODAxNDAwMDAgdGFzay50aTogODAxNDAwMDAKWyAgIDIy
Ljk4MDA1Nl0gRUlQOiAwMDYwOls8ODEwNTdlNjQ+XSBFRkxBR1M6IDAwMDAwMDQ2IENQVTog
MQpbICAgMjIuOTgwMDU2XSBFSVAgaXMgYXQgZGVmYXVsdF9zZW5kX0lQSV9tYXNrX2xvZ2lj
YWwrMHgxNjQvMHgxZjAKWyAgIDIyLjk4MDA1Nl0gRUFYOiBmZmZmZjAwMCBFQlg6IDAzMDAw
MDAwIEVDWDogZmZmZmYwMDAgRURYOiAwMDAwMGMwMApbICAgMjIuOTgwMDU2XSBFU0k6IDAw
MDAwMDQ2IEVESTogMDAwMDAwMDIgRUJQOiA4MDE0MWI5YyBFU1A6IDgwMTQxYjhjClsgICAy
Mi45ODAwNTZdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDBlMCBTUzogMDA2
OApbICAgMjIuOTgwMDU2XSBDUjA6IDgwMDUwMDNiIENSMjogMDAwMDAwMDAgQ1IzOiAwMWJl
MjAwMCBDUjQ6IDAwMDAwNmQwClsgICAyMi45ODAwNTZdIFN0YWNrOgpbICAgMjIuOTgwMDU2
XSAgMDAwMDA4MDAgMDAwMDI3MTAgOGRkMDYxYTAgODE5NWJiODAgODAxNDFiYTggODEwNTgw
MmMgMDAwMDI3MTAgODAxNDFiYjgKWyAgIDIyLjk4MDA1Nl0gIDgxMDU4NzExIDgxODkwNTUw
IDAwMDAwMDJhIDgwMTQxYmZjIDgxMTVjZTNjIDgxOGE0YzA4IDAwMDAwODM0IGZmZmZmZjE3
ClsgICAyMi45ODAwNTZdICBmZmZmZmYxNiAwMDAwMDAyYSA4MDE0MWJmYyA4MTBjZmVhZCAw
MDAwMDAwMSA4MDE0MDAwMCA4ZGQwNjFhMCAwMDAwMDAwMQpbICAgMjIuOTgwMDU2XSBDYWxs
IFRyYWNlOgpbICAgMjIuOTgwMDU2XSAgWzw4MTA1ODAyYz5dIGRlZmF1bHRfc2VuZF9JUElf
YWxsKzB4MmMvMHhkMApbICAgMjIuOTgwMDU2XSAgWzw4MTA1ODcxMT5dIGFyY2hfdHJpZ2dl
cl9hbGxfY3B1X2JhY2t0cmFjZSsweDkxLzB4MTMwClsgICAyMi45ODAwNTZdICBbPDgxMTVj
ZTNjPl0gcmN1X2NoZWNrX2NhbGxiYWNrcysweDM1Yy8weGE0MApbICAgMjIuOTgwMDU2XSAg
Wzw4MTBjZmVhZD5dID8gYWNjb3VudF9wcm9jZXNzX3RpY2srMHgxZWQvMHgyZTAKWyAgIDIy
Ljk4MDA1Nl0gIFs8ODEwOGVmNWY+XSB1cGRhdGVfcHJvY2Vzc190aW1lcysweDZmLzB4ZTAK
WyAgIDIyLjk4MDA1Nl0gIFs8ODExMTVkMjE+XSB0aWNrX3NjaGVkX2hhbmRsZS5pc3JhLjEy
KzB4NzEvMHhhMApbICAgMjIuOTgwMDU2XSAgWzw4MTExNWRiYT5dIHRpY2tfc2NoZWRfdGlt
ZXIrMHg2YS8weGMwClsgICAyMi45ODAwNTZdICBbPDgxMGI1ODQ3Pl0gX19ydW5faHJ0aW1l
ci5pc3JhLjE3KzB4YzcvMHgxYjAKWyAgIDIyLjk4MDA1Nl0gIFs8ODExMTVkNTA+XSA/IHRp
Y2tfc2NoZWRfaGFuZGxlLmlzcmEuMTIrMHhhMC8weGEwClsgICAyMi45ODAwNTZdICBbPDgx
MGI2ODgzPl0gaHJ0aW1lcl9pbnRlcnJ1cHQrMHgxYjMvMHgzZDAKWyAgIDIyLjk4MDA1Nl0g
IFs8ODEwNjQ1NGU+XSA/IGt2bV9jbG9ja19yZWFkKzB4M2UvMHg4MApbICAgMjIuOTgwMDU2
XSAgWzw4MTAxMjc0Nj5dID8gc2NoZWRfY2xvY2srMHgxNi8weDMwClsgICAyMi45ODAwNTZd
ICBbPDgxMTViZDc5Pl0gPyByY3VfaXJxX2VudGVyKzB4MTM5LzB4MTkwClsgICAyMi45ODAw
NTZdICBbPDgxMDU0OTQxPl0gbG9jYWxfYXBpY190aW1lcl9pbnRlcnJ1cHQrMHg4MS8weGEw
ClsgICAyMi45ODAwNTZdICBbPDgxMDg1YjhlPl0gPyBpcnFfZW50ZXIrMHgxZS8weGYwClsg
ICAyMi45ODAwNTZdICBbPDgxMDU0ZGE4Pl0gc21wX2FwaWNfdGltZXJfaW50ZXJydXB0KzB4
NTgvMHg5MApbICAgMjIuOTgwMDU2XSAgWzw4MTZhYmJjMj5dIGFwaWNfdGltZXJfaW50ZXJy
dXB0KzB4MzYvMHgzYwpbICAgMjIuOTgwMDU2XSAgWzw4MTNmMmZkOD5dID8gZ2YyX21hdHJp
eF9zcXVhcmUrMHg1OC8weGEwClsgICAyMi45ODAwNTZdICBbPDgxM2YzMGY5Pl0gY3JjMzJf
Z2VuZXJpY19jb21iaW5lKzB4ZDkvMHgyYzAKWyAgIDIyLjk4MDA1Nl0gIFs8ODFhNTJmNjE+
XSBjcmMzMnRlc3RfaW5pdCsweDEyMjgvMHgxMzE3ClsgICAyMi45ODAwNTZdICBbPDgxYTUx
ZDM5Pl0gPyBkZWJ1Z19vYmplY3RzX21lbV9pbml0KzB4M2ViLzB4M2ViClsgICAyMi45ODAw
NTZdICBbPDgxMDAwNDQwPl0gZG9fb25lX2luaXRjYWxsKzB4MTAwLzB4MjUwClsgICAyMi45
ODAwNTZdICBbPDgxMGFjOTkxPl0gPyBwYXJhbWVxKzB4MjEvMHhmMApbICAgMjIuOTgwMDU2
XSAgWzw4MWExMjcwMD5dID8gZG9fZWFybHlfcGFyYW0rMHgxMTAvMHgxMmIKWyAgIDIyLjk4
MDA1Nl0gIFs8ODEwYWNlNTI+XSA/IHBhcnNlX2FyZ3MrMHgzZjIvMHg1ZDAKWyAgIDIyLjk4
MDA1Nl0gIFs8ODFhMTM5NGQ+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDJlNC8weDQ3YQpb
ICAgMjIuOTgwMDU2XSAgWzw4MWExMjcxYj5dID8gZG9fZWFybHlfcGFyYW0rMHgxMmIvMHgx
MmIKWyAgIDIyLjk4MDA1Nl0gIFs8ODE2OGJlMDk+XSBrZXJuZWxfaW5pdCsweDE5LzB4Mjkw
ClsgICAyMi45ODAwNTZdICBbPDgxNmFjMDE3Pl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsw
eDFiLzB4MjgKWyAgIDIyLjk4MDA1Nl0gIFs8ODE2OGJkZjA+XSA/IHJlc3RfaW5pdCsweDE5
MC8weDE5MApbICAgMjIuOTgwMDU2XSBDb2RlOiBmOCBmNCBjMCA4MSAwMSA4MyAxNSBmYyBm
NCBjMCA4MSAwMCBlYiAxMiA5MCA4MCBjZSAwNCA4MyAwNSAwMCBmNSBjMCA4MSAwMSA4MyAx
NSAwNCBmNSBjMCA4MSAwMCBhMSAxMCBjNyA5MyA4MSA4OSA5MCAwMCBjMyBmZiBmZiA8Zjc+
IGM2IDAwIDAyIDAwIDAwIDc1IDNjIDgzIDA1IDA4IGY1IGMwIDgxIDAxIDg5IGYwIDgzIDE1
IDBjIGY1ClsgICAyMi45OTAwNDddIE5NSSBiYWNrdHJhY2UgZm9yIGNwdSAwClsgICAyMi45
OTAwNDddIENQVTogMCBQSUQ6IDAgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTIu
MC1yYzYtMDEzMTctZ2VmYmE3MjFmICM3MTUKWyAgIDIyLjk5MDA0N10gdGFzazogODE5MWYz
MDAgdGk6IDgxOTFjMDAwIHRhc2sudGk6IDgxOTFjMDAwClsgICAyMi45OTAwNDddIEVJUDog
MDA2MDpbPDgxMDY0YjUzPl0gRUZMQUdTOiAwMDIwMDI0NiBDUFU6IDAKWyAgIDIyLjk5MDA0
N10gRUlQIGlzIGF0IG5hdGl2ZV9zYWZlX2hhbHQrMHgxMy8weDMwClsgICAyMi45OTAwNDdd
IEVBWDogODE5MWYzMDAgRUJYOiA4MTkxYzAwMCBFQ1g6IDAwMDAwMDAwIEVEWDogMDAwMDAw
MDEKWyAgIDIyLjk5MDA0N10gRVNJOiBmZmZmZmZmZiBFREk6IDgxYmUzODAwIEVCUDogODE5
MWRmODQgRVNQOiA4MTkxZGY4NApbICAgMjIuOTkwMDQ3XSAgRFM6IDAwN2IgRVM6IDAwN2Ig
RlM6IDAwZDggR1M6IDAwZTAgU1M6IDAwNjgKWyAgIDIyLjk5MDA0N10gQ1IwOiA4MDA1MDAz
YiBDUjI6IGZmZmZmZmZmIENSMzogMDFiZTIwMDAgQ1I0OiAwMDAwMDZkMApbICAgMjIuOTkw
MDQ3XSBTdGFjazoKWyAgIDIyLjk5MDA0N10gIDgxOTFkZjhjIDgxMDE0NTA5IDgxOTFkZjk0
IDgxMDE1NmFlIDgxOTFkZmFjIDgxMGY2ZDBhIDlmMGZhMGQyIDc5ZDI1YmVhClsgICAyMi45
OTAwNDddICAwMDAwMDAwMiAwMDAyMDgwMCA4MTkxZGZjOCA4MTY4YmRkMSAwMDAwMDAwMiAw
MDAwMDAwMSAwMDAwMDAwMCA4MTY4YmM2MApbICAgMjIuOTkwMDQ3XSAgMDAwMDAwMDAgODE5
MWRmZWMgODFhMTM2NDAgMDAwMDAwYmQgZmZmZmZmZmYgZmZmZmZmZmYgODFhMTI3ZWUgODFh
NzcwZTAKWyAgIDIyLjk5MDA0N10gQ2FsbCBUcmFjZToKWyAgIDIyLjk5MDA0N10gIFs8ODEw
MTQ1MDk+XSBkZWZhdWx0X2lkbGUrMHgyOS8weDQwClsgICAyMi45OTAwNDddICBbPDgxMDE1
NmFlPl0gYXJjaF9jcHVfaWRsZSsweDJlLzB4ODAKWyAgIDIyLjk5MDA0N10gIFs8ODEwZjZk
MGE+XSBjcHVfc3RhcnR1cF9lbnRyeSsweDJhYS8weDNlMApbICAgMjIuOTkwMDQ3XSAgWzw4
MTY4YmRkMT5dIHJlc3RfaW5pdCsweDE3MS8weDE5MApbICAgMjIuOTkwMDQ3XSAgWzw4MTY4
YmM2MD5dID8gX19yZWFkX2xvY2tfZmFpbGVkKzB4MTgvMHgxOApbICAgMjIuOTkwMDQ3XSAg
Wzw4MWExMzY0MD5dIHN0YXJ0X2tlcm5lbCsweGEzZC8weGE2NgpbICAgMjIuOTkwMDQ3XSAg
Wzw4MWExMjdlZT5dID8gcmVwYWlyX2Vudl9zdHJpbmcrMHhkMy8weGQzClsgICAyMi45OTAw
NDddICBbPDgxYTEyM2U4Pl0gaTM4Nl9zdGFydF9rZXJuZWwrMHgxOWUvMHgxYWYKWyAgIDIy
Ljk5MDA0N10gQ29kZTogMDEgODMgMTUgYTQgYTAgYzEgODEgMDAgNWQgYzMgOGQgYjQgMjYg
MDAgMDAgMDAgMDAgOGQgYmMgMjcgMDAgMDAgMDAgMDAgNTUgODMgMDUgYTggYTAgYzEgODEg
MDEgODkgZTUgODMgMTUgYWMgYTAgYzEgODEgMDAgZmIgZjQgPDgzPiAwNSBiMCBhMCBjMSA4
MSAwMSA4MyAxNSBiNCBhMCBjMSA4MSAwMCA1ZCBjMyA4ZCBiNiAwMCAwMCAwMAova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1pMDAwLTExMDQvZWZiYTcyMWY2MzZlZTAxNjg1OWQ4NmQxNTc0
ODY1MDExOTQwMmIxMC9kbWVzZy1xdWFudGFsLWxrcC1zdDAxLTY6MjAxMzExMDUwNTE0MzU6
aTM4Ni1yYW5kY29uZmlnLWkwMDAtMTEwNDozLjEyLjAtcmM2LTAxMzE3LWdlZmJhNzIxZjo3
MTUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwMC0xMTA0L2VmYmE3MjFmNjM2ZWUwMTY4
NTlkODZkMTU3NDg2NTAxMTk0MDJiMTAvZG1lc2ctcXVhbnRhbC1zbmItMjE6MjAxMzExMDQy
MTE1NDg6aTM4Ni1yYW5kY29uZmlnLWkwMDAtMTEwNDozLjEyLjAtcmM2LTAxMzE3LWdlZmJh
NzIxZjo3MTUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwMC0xMTA0L2VmYmE3MjFmNjM2
ZWUwMTY4NTlkODZkMTU3NDg2NTAxMTk0MDJiMTAvZG1lc2cteW9jdG8tc25iLTM6MjAxMzEx
MDQyMTE1NTY6aTM4Ni1yYW5kY29uZmlnLWkwMDAtMTEwNDozLjEyLjAtcmM2LTAxMzE3LWdl
ZmJhNzIxZjo3MTUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwMC0xMTA0L2VmYmE3MjFm
NjM2ZWUwMTY4NTlkODZkMTU3NDg2NTAxMTk0MDJiMTAvZG1lc2ctcXVhbnRhbC1zbmItMTU6
MjAxMzExMDQyMTE1NTc6aTM4Ni1yYW5kY29uZmlnLWkwMDAtMTEwNDozLjEyLjAtcmM2LTAx
MzE3LWdlZmJhNzIxZjo3MTUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwMC0xMTA0L2Vm
YmE3MjFmNjM2ZWUwMTY4NTlkODZkMTU3NDg2NTAxMTk0MDJiMTAvZG1lc2cteW9jdG8tbGtw
LXN0MDEtMToyMDEzMTEwNTA1MTQ0NDppMzg2LXJhbmRjb25maWctaTAwMC0xMTA0OjMuMTIu
MC1yYzYtMDEzMTctZ2VmYmE3MjFmOjcxNQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDAw
LTExMDQvZWZiYTcyMWY2MzZlZTAxNjg1OWQ4NmQxNTc0ODY1MDExOTQwMmIxMC9kbWVzZy15
b2N0by1sa3AtdHQwMi0xODoyMDEzMTEwNDEyMDM1NDppMzg2LXJhbmRjb25maWctaTAwMC0x
MTA0OjMuMTIuMC1yYzYtMDEzMTctZ2VmYmE3MjFmOjcxNQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1pMDAwLTExMDQvZWZiYTcyMWY2MzZlZTAxNjg1OWQ4NmQxNTc0ODY1MDExOTQwMmIx
MC9kbWVzZy15b2N0by1sa3AtdHQwMi0yMDoyMDEzMTEwNDEyMDM1MzppMzg2LXJhbmRjb25m
aWctaTAwMC0xMTA0OjMuMTIuMC1yYzYtMDEzMTctZ2VmYmE3MjFmOjcxNQowOjc6NyBhbGxf
Z29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtUkVQRUFUIENPVU5UOiAyMCAgIyAvY2Mv
d2ZnL3VzYi1iaXNlY3QvLnJlcGVhdBtbMG0KCmVmYmE3MjFmNjM2ZWUwMTY4NTlkODZkMTU3
NDg2NTAxMTk0MDJiMTAgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQKY29tbWl0IGVmYmE3MjFm
NjM2ZWUwMTY4NTlkODZkMTU3NDg2NTAxMTk0MDJiMTAKQXV0aG9yOiBEYW5pZWwgQm9ya21h
bm4gPGRib3JrbWFuQHJlZGhhdC5jb20+CkRhdGU6ICAgV2VkIE9jdCAzMCAxMTo1MDo1MCAy
MDEzICswMTAwCgogICAgbGliOiBjcmMzMjogYWRkIHRlc3QgY2FzZXMgZm9yIGNyYzMyeywg
Y31fY29tYmluZSByb3V0aW5lcwogICAgCiAgICBXZSBhbHJlYWR5IGhhdmUgMTAwIHRlc3Qg
Y2FzZXMgZm9yIGNyY3MgaXRzZWxmLCBzbyBzcGxpdCB0aGUgdGVzdAogICAgYnVmZmVyIHdp
dGggYS1wcmlvIGtub3duIGNoZWNrc3VtcywgYW5kIHRlc3QgY3JjIG9mIHR3byBibG9ja3MK
ICAgIGFnYWluc3QgY3JjIG9mIHRoZSB3aG9sZSBibG9jayBmb3IgdGhlIHNhbWUgcmVzdWx0
cy4KICAgIAogICAgT3V0cHV0L3Jlc3VsdCB3aXRoIENPTkZJR19DUkMzMl9TRUxGVEVTVD15
OgogICAgCiAgICAgIFsgICAgMi42ODcwOTVdIGNyYzMyOiBDUkNfTEVfQklUUyA9IDY0LCBD
UkNfQkUgQklUUyA9IDY0CiAgICAgIFsgICAgMi42ODcwOTddIGNyYzMyOiBzZWxmIHRlc3Rz
IHBhc3NlZCwgcHJvY2Vzc2VkIDIyNTk0NCBieXRlcyBpbiAyNzgxNzcgbnNlYwogICAgICBb
ICAgIDIuNjg3MzgzXSBjcmMzMmM6IENSQ19MRV9CSVRTID0gNjQKICAgICAgWyAgICAyLjY4
NzM4NV0gY3JjMzJjOiBzZWxmIHRlc3RzIHBhc3NlZCwgcHJvY2Vzc2VkIDIyNTk0NCBieXRl
cyBpbiAxNDE3MDggbnNlYwogICAgICBbICAgIDcuMzM2NzcxXSBjcmMzMl9jb21iaW5lOiAx
MTMwNzIgc2VsZiB0ZXN0cyBwYXNzZWQKICAgICAgWyAgIDEyLjA1MDQ3OV0gY3JjMzJjX2Nv
bWJpbmU6IDExMzA3MiBzZWxmIHRlc3RzIHBhc3NlZAogICAgICBbICAgMTcuNjMzMDg5XSBh
bGc6IE5vIHRlc3QgZm9yIGNyYzMyIChjcmMzMi1wY2xtdWwpCiAgICAKICAgIFNpZ25lZC1v
ZmYtYnk6IERhbmllbCBCb3JrbWFubiA8ZGJvcmttYW5AcmVkaGF0LmNvbT4KICAgIENjOiBs
aW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnCiAgICBTaWduZWQtb2ZmLWJ5OiBEYXZpZCBT
LiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+Cgo6MDQwMDAwIDA0MDAwMCBlZGEwMzgy
YTZiNWY1MTM2MWMzMTFlZTA2ZWFjMGI1NzllMDlhN2RiIDU4YjhhNTU1NWZmZjJkOGMwNTdm
NjA5ODE0NThmNzkzOTFiOWRkYWQgTQlsaWIKYmlzZWN0IHJ1biBzdWNjZXNzCmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaTAwMC0xMTA0L25l
dC1uZXh0Om1hc3Rlcjo2ZTk1ZmNhYTQyZTUwNzhhYzI2NTk2NGRlZWJlZDU5N2Y5ZWFlMDdh
OmJpc2VjdC11c2IKCjIwMTMtMTEtMDQtMjE6MTY6MTQgNmU5NWZjYWE0MmU1MDc4YWMyNjU5
NjRkZWViZWQ1OTdmOWVhZTA3YSByZXVzZSAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDAw
LTExMDQvNmU5NWZjYWE0MmU1MDc4YWMyNjU5NjRkZWViZWQ1OTdmOWVhZTA3YS92bWxpbnV6
LTMuMTIuMC1yYzYtMDEzMTYtZzZlOTVmY2EKCjIwMTMtMTEtMDQtMjE6MTY6MTQgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgLi4JMjcJNDgJNTUJNTcJNTkJNjAgU1VDQ0VTUwoKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pMDAwLTExMDQvbmV0
LW5leHQ6bWFzdGVyOmY0MjE0MzZhNTkxZDM0ZmE1Mjc5YjU0YTk2YWMwN2Q3MDI1MGNjOGQ6
YmlzZWN0LXVzYgogVEVTVCBGQUlMVVJFClsgICAgMi40MDY5ODFdIGNyYzMyYzogQ1JDX0xF
X0JJVFMgPSAxClsgICAgMi40MDc1NjNdIGNyYzMyYzogc2VsZiB0ZXN0cyBwYXNzZWQsIHBy
b2Nlc3NlZCAyMjU5NDQgYnl0ZXMgaW4gNTcwMzExNyBuc2VjClsgICAxNi4yMjQ5OTVdIGNy
YzMyX2NvbWJpbmU6IDExMzA3MiBzZWxmIHRlc3RzIHBhc3NlZApbICAgMjMuMzgwMDQ1XSBJ
TkZPOiByY3Vfc2NoZWQgc2VsZi1kZXRlY3RlZCBzdGFsbCBvbiBDUFUgeyAxfSAgKHQ9MjEw
MCBqaWZmaWVzIGc9NDI5NDk2NzA4NCBjPTQyOTQ5NjcwODMgcT00MCkKWyAgIDIzLjM4MDA0
NV0gc2VuZGluZyBOTUkgdG8gYWxsIENQVXM6ClsgICAyMy4zODAwNDVdIE5NSSBiYWNrdHJh
Y2UgZm9yIGNwdSAxClsgICAyMy4zODAwNDVdIENQVTogMSBQSUQ6IDEgQ29tbTogc3dhcHBl
ci8wIE5vdCB0YWludGVkIDMuMTIuMC1yYzYtMDEzMjItZ2Y0MjE0MzYgIzQxNApbICAgMjMu
MzgwMDQ1XSB0YXNrOiA4MDEzODAwMCB0aTogODAxNDAwMDAgdGFzay50aTogODAxNDAwMDAK
WyAgIDIzLjM4MDA0NV0gRUlQOiAwMDYwOls8ODEwNTdkZTQ+XSBFRkxBR1M6IDAwMDEwMDQ2
IENQVTogMQpbICAgMjMuMzgwMDQ1XSBFSVAgaXMgYXQgZGVmYXVsdF9zZW5kX0lQSV9tYXNr
X2xvZ2ljYWwrMHgxNjQvMHgxZjAKWyAgIDIzLjM4MDA0NV0gRUFYOiBmZmZmZjAwMCBFQlg6
IDAzMDAwMDAwIEVDWDogZmZmZmYwMDAgRURYOiAwMDAwMGMwMApbICAgMjMuMzgwMDQ1XSBF
U0k6IDAwMDAwMDQ2IEVESTogMDAwMDAwMDIgRUJQOiA4MDE0MWI5YyBFU1A6IDgwMTQxYjhj
ClsgICAyMy4zODAwNDVdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDBlMCBT
UzogMDA2OApbICAgMjMuMzgwMDQ1XSBDUjA6IDgwMDUwMDNiIENSMjogMDAwMDAwMDAgQ1Iz
OiAwMWJlZDAwMCBDUjQ6IDAwMDAwNmQwClsgICAyMy4zODAwNDVdIFN0YWNrOgpbICAgMjMu
MzgwMDQ1XSAgMDAwMDA4MDAgMDAwMDI3MTAgOGRkMDYxYTAgODE5NjdiODAgODAxNDFiYTgg
ODEwNTdmYWMgMDAwMDI3MTAgODAxNDFiYjgKWyAgIDIzLjM4MDA0NV0gIDgxMDU4NjkxIDgx
ODkwOGUwIDAwMDAwMDI4IDgwMTQxYmZjIDgxMTVjZGVjIDgxOGE3ODg0IDAwMDAwODM0IGZm
ZmZmZjJjClsgICAyMy4zODAwNDVdICBmZmZmZmYyYiAwMDAwMDAyOCA4MDE0MWJmYyA4MTBj
ZmU1ZCAwMDAwMDAwMSA4MDE0MDAwMCA4ZGQwNjFhMCAwMDAwMDAwMQpbICAgMjMuMzgwMDQ1
XSBDYWxsIFRyYWNlOgpbICAgMjMuMzgwMDQ1XSAgWzw4MTA1N2ZhYz5dIGRlZmF1bHRfc2Vu
ZF9JUElfYWxsKzB4MmMvMHhkMApbICAgMjMuMzgwMDQ1XSAgWzw4MTA1ODY5MT5dIGFyY2hf
dHJpZ2dlcl9hbGxfY3B1X2JhY2t0cmFjZSsweDkxLzB4MTMwClsgICAyMy4zODAwNDVdICBb
PDgxMTVjZGVjPl0gcmN1X2NoZWNrX2NhbGxiYWNrcysweDM1Yy8weGE0MApbICAgMjMuMzgw
MDQ1XSAgWzw4MTBjZmU1ZD5dID8gYWNjb3VudF9wcm9jZXNzX3RpY2srMHgxZWQvMHgyZTAK
WyAgIDIzLjM4MDA0NV0gIFs8ODEwOGVlZWY+XSB1cGRhdGVfcHJvY2Vzc190aW1lcysweDZm
LzB4ZTAKWyAgIDIzLjM4MDA0NV0gIFs8ODExMTVkMDE+XSB0aWNrX3NjaGVkX2hhbmRsZS5p
c3JhLjEyKzB4NzEvMHhhMApbICAgMjMuMzgwMDQ1XSAgWzw4MTExNWQ5YT5dIHRpY2tfc2No
ZWRfdGltZXIrMHg2YS8weGMwClsgICAyMy4zODAwNDVdICBbPDgxMGI1N2U3Pl0gX19ydW5f
aHJ0aW1lci5pc3JhLjE3KzB4YzcvMHgxYjAKWyAgIDIzLjM4MDA0NV0gIFs8ODExMTVkMzA+
XSA/IHRpY2tfc2NoZWRfaGFuZGxlLmlzcmEuMTIrMHhhMC8weGEwClsgICAyMy4zODAwNDVd
ICBbPDgxMGI2ODMzPl0gaHJ0aW1lcl9pbnRlcnJ1cHQrMHgxYjMvMHgzZDAKWyAgIDIzLjM4
MDA0NV0gIFs8ODEwNjQ0ZGU+XSA/IGt2bV9jbG9ja19yZWFkKzB4M2UvMHg4MApbICAgMjMu
MzgwMDQ1XSAgWzw4MTAxMjc0Nj5dID8gc2NoZWRfY2xvY2srMHgxNi8weDMwClsgICAyMy4z
ODAwNDVdICBbPDgxMTViZDI5Pl0gPyByY3VfaXJxX2VudGVyKzB4MTM5LzB4MTkwClsgICAy
My4zODAwNDVdICBbPDgxMDU0OGMxPl0gbG9jYWxfYXBpY190aW1lcl9pbnRlcnJ1cHQrMHg4
MS8weGEwClsgICAyMy4zODAwNDVdICBbPDgxMDg1YjBlPl0gPyBpcnFfZW50ZXIrMHgxZS8w
eGYwClsgICAyMy4zODAwNDVdICBbPDgxMDU0ZDI4Pl0gc21wX2FwaWNfdGltZXJfaW50ZXJy
dXB0KzB4NTgvMHg5MApbICAgMjMuMzgwMDQ1XSAgWzw4MTZhYjY5Mj5dIGFwaWNfdGltZXJf
aW50ZXJydXB0KzB4MzYvMHgzYwpbICAgMjMuMzgwMDQ1XSAgWzw4MTNmMmQ0ND5dID8gZ2Yy
X21hdHJpeF9zcXVhcmUrMHg1NC8weGEwClsgICAyMy4zODAwNDVdICBbPDgxM2YyZjRlPl0g
Y3JjMzJfZ2VuZXJpY19jb21iaW5lKzB4MWJlLzB4MmMwClsgICAyMy4zODAwNDVdICBbPDgx
YTVlZjUzPl0gY3JjMzJ0ZXN0X2luaXQrMHgxMjI4LzB4MTMxNwpbICAgMjMuMzgwMDQ1XSAg
Wzw4MWE1ZGQyYj5dID8gZGVidWdfb2JqZWN0c19tZW1faW5pdCsweDNlYi8weDNlYgpbICAg
MjMuMzgwMDQ1XSAgWzw4MTAwMDQ0MD5dIGRvX29uZV9pbml0Y2FsbCsweDEwMC8weDI1MApb
ICAgMjMuMzgwMDQ1XSAgWzw4MTBhYzkzMT5dID8gcGFyYW1lcSsweDIxLzB4ZjAKWyAgIDIz
LjM4MDA0NV0gIFs8ODFhMWU3MDA+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4MTEwLzB4MTJiClsg
ICAyMy4zODAwNDVdICBbPDgxMGFjZGYyPl0gPyBwYXJzZV9hcmdzKzB4M2YyLzB4NWQwClsg
ICAyMy4zODAwNDVdICBbPDgxYTFmOTRkPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgyZTQv
MHg0N2EKWyAgIDIzLjM4MDA0NV0gIFs8ODFhMWU3MWI+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4
MTJiLzB4MTJiClsgICAyMy4zODAwNDVdICBbPDgxNjhiOGY5Pl0ga2VybmVsX2luaXQrMHgx
OS8weDI5MApbICAgMjMuMzgwMDQ1XSAgWzw4MTZhYmFmNz5dIHJldF9mcm9tX2tlcm5lbF90
aHJlYWQrMHgxYi8weDI4ClsgICAyMy4zODAwNDVdICBbPDgxNjhiOGUwPl0gPyByZXN0X2lu
aXQrMHgxOTAvMHgxOTAKWyAgIDIzLjM4MDA0NV0gQ29kZTogZjggYTQgYzEgODEgMDEgODMg
MTUgZmMgYTQgYzEgODEgMDAgZWIgMTIgOTAgODAgY2UgMDQgODMgMDUgMDAgYTUgYzEgODEg
MDEgODMgMTUgMDQgYTUgYzEgODEgMDAgYTEgMTAgODcgOTQgODEgODkgOTAgMDAgYzMgZmYg
ZmYgPGY3PiBjNiAwMCAwMiAwMCAwMCA3NSAzYyA4MyAwNSAwOCBhNSBjMSA4MSAwMSA4OSBm
MCA4MyAxNSAwYyBhNQpbICAgMjMuMzkwMDQ1XSBOTUkgYmFja3RyYWNlIGZvciBjcHUgMApb
ICAgMjMuMzkwMDQ1XSBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRl
ZCAzLjEyLjAtcmM2LTAxMzIyLWdmNDIxNDM2ICM0MTQKWyAgIDIzLjM5MDA0NV0gdGFzazog
ODE5MmIzMDAgdGk6IDgxOTI4MDAwIHRhc2sudGk6IDgxOTI4MDAwClsgICAyMy4zOTAwNDVd
IEVJUDogMDA2MDpbPDgxMDY0YWUzPl0gRUZMQUdTOiAwMDIwMDI0NiBDUFU6IDAKWyAgIDIz
LjM5MDA0NV0gRUlQIGlzIGF0IG5hdGl2ZV9zYWZlX2hhbHQrMHgxMy8weDMwClsgICAyMy4z
OTAwNDVdIEVBWDogODE5MmIzMDAgRUJYOiA4MTkyODAwMCBFQ1g6IDAwMDAwMDAwIEVEWDog
MDAwMDAwMDEKWyAgIDIzLjM5MDA0NV0gRVNJOiBmZmZmZmZmZiBFREk6IDgxYmVlODAwIEVC
UDogODE5MjlmODQgRVNQOiA4MTkyOWY4NApbICAgMjMuMzkwMDQ1XSAgRFM6IDAwN2IgRVM6
IDAwN2IgRlM6IDAwZDggR1M6IDAwZTAgU1M6IDAwNjgKWyAgIDIzLjM5MDA0NV0gQ1IwOiA4
MDA1MDAzYiBDUjI6IGZmZmZmZmZmIENSMzogMDFiZWQwMDAgQ1I0OiAwMDAwMDZkMApbICAg
MjMuMzkwMDQ1XSBTdGFjazoKWyAgIDIzLjM5MDA0NV0gIDgxOTI5ZjhjIDgxMDE0NTA5IDgx
OTI5Zjk0IDgxMDE1NmFlIDgxOTI5ZmFjIDgxMGY2Y2VhIGExMmU4ZGYyIDdiZjE0OTA5Clsg
ICAyMy4zOTAwNDVdICAwMDAwMDAwMiAwMDAyMDgwMCA4MTkyOWZjOCA4MTY4YjhjMSAwMDAw
MDAwMiAwMDAwMDAwMSAwMDAwMDAwMCA4MTY4Yjc1MApbICAgMjMuMzkwMDQ1XSAgMDAwMDAw
MDAgODE5MjlmZWMgODFhMWY2NDAgMDAwMDAwYmQgZmZmZmZmZmYgZmZmZmZmZmYgODFhMWU3
ZWUgODFhODIwZTAKWyAgIDIzLjM5MDA0NV0gQ2FsbCBUcmFjZToKWyAgIDIzLjM5MDA0NV0g
IFs8ODEwMTQ1MDk+XSBkZWZhdWx0X2lkbGUrMHgyOS8weDQwClsgICAyMy4zOTAwNDVdICBb
PDgxMDE1NmFlPl0gYXJjaF9jcHVfaWRsZSsweDJlLzB4ODAKWyAgIDIzLjM5MDA0NV0gIFs8
ODEwZjZjZWE+XSBjcHVfc3RhcnR1cF9lbnRyeSsweDJhYS8weDNlMApbICAgMjMuMzkwMDQ1
XSAgWzw4MTY4YjhjMT5dIHJlc3RfaW5pdCsweDE3MS8weDE5MApbICAgMjMuMzkwMDQ1XSAg
Wzw4MTY4Yjc1MD5dID8gX19yZWFkX2xvY2tfZmFpbGVkKzB4MTgvMHgxOApbICAgMjMuMzkw
MDQ1XSAgWzw4MWExZjY0MD5dIHN0YXJ0X2tlcm5lbCsweGEzZC8weGE2NgpbICAgMjMuMzkw
MDQ1XSAgWzw4MWExZTdlZT5dID8gcmVwYWlyX2Vudl9zdHJpbmcrMHhkMy8weGQzClsgICAy
My4zOTAwNDVdICBbPDgxYTFlM2U4Pl0gaTM4Nl9zdGFydF9rZXJuZWwrMHgxOWUvMHgxYWYK
WyAgIDIzLjM5MDA0NV0gQ29kZTogMDEgODMgMTUgYTQgNTAgYzIgODEgMDAgNWQgYzMgOGQg
YjQgMjYgMDAgMDAgMDAgMDAgOGQgYmMgMjcgMDAgMDAgMDAgMDAgNTUgODMgMDUgYTggNTAg
YzIgODEgMDEgODkgZTUgODMgMTUgYWMgNTAgYzIgODEgMDAgZmIgZjQgPDgzPiAwNSBiMCA1
MCBjMiA4MSAwMSA4MyAxNSBiNCA1MCBjMiA4MSAwMCA1ZCBjMyA4ZCBiNiAwMCAwMCAwMAov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDAwLTExMDQvZjQyMTQzNmE1OTFkMzRmYTUyNzli
NTRhOTZhYzA3ZDcwMjUwY2M4ZC9kbWVzZy1xdWFudGFsLXhpYW4tMjoyMDEzMTEwNDE0MzQw
ODppMzg2LXJhbmRjb25maWctaTAwMC0xMTA0OjMuMTIuMC1yYzYtMDEzMjItZ2Y0MjE0MzY6
NDE0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDAtMTEwNC9mNDIxNDM2YTU5MWQzNGZh
NTI3OWI1NGE5NmFjMDdkNzAyNTBjYzhkL2RtZXNnLXlvY3RvLWxrcC10dDAyLTIwOjIwMTMx
MTA0MTAyOTIxOmkzODYtcmFuZGNvbmZpZy1pMDAwLTExMDQ6My4xMi4wLXJjNi0wMTMyMi1n
ZjQyMTQzNjo0MTQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwMC0xMTA0L2Y0MjE0MzZh
NTkxZDM0ZmE1Mjc5YjU0YTk2YWMwN2Q3MDI1MGNjOGQvZG1lc2cteW9jdG8tcm9hbS0xMzoy
MDEzMTEwNDE0NDgzNjppMzg2LXJhbmRjb25maWctaTAwMC0xMTA0OjMuMTIuMC1yYzYtMDEz
MjItZ2Y0MjE0MzY6NDE0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDAtMTEwNC9mNDIx
NDM2YTU5MWQzNGZhNTI3OWI1NGE5NmFjMDdkNzAyNTBjYzhkL2RtZXNnLXF1YW50YWwtc25i
LTIyOjIwMTMxMTA0MTQ0NDQ5OmkzODYtcmFuZGNvbmZpZy1pMDAwLTExMDQ6My4xMi4wLXJj
Ni0wMTMyMi1nZjQyMTQzNjo0MTQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwMC0xMTA0
L2Y0MjE0MzZhNTkxZDM0ZmE1Mjc5YjU0YTk2YWMwN2Q3MDI1MGNjOGQvZG1lc2ctcXVhbnRh
bC1sa3Atc3QwMS00OjIwMTMxMTA1MDIxMjE1OmkzODYtcmFuZGNvbmZpZy1pMDAwLTExMDQ6
My4xMi4wLXJjNi0wMTMyMi1nZjQyMTQzNjo0MTQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aTAwMC0xMTA0L2Y0MjE0MzZhNTkxZDM0ZmE1Mjc5YjU0YTk2YWMwN2Q3MDI1MGNjOGQvZG1l
c2ctcXVhbnRhbC1sa3AtdHQwMi0xMjoyMDEzMTEwNDEwMjcyNTppMzg2LXJhbmRjb25maWct
aTAwMC0xMTA0OjMuMTIuMC1yYzYtMDEzMjItZ2Y0MjE0MzY6NDE0Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWkwMDAtMTEwNC9mNDIxNDM2YTU5MWQzNGZhNTI3OWI1NGE5NmFjMDdkNzAy
NTBjYzhkL2RtZXNnLXlvY3RvLXNuYi00NjoyMDEzMTEwNDE0NDA1NjppMzg2LXJhbmRjb25m
aWctaTAwMC0xMTA0OjMuMTIuMC1yYzYtMDEzMjItZ2Y0MjE0MzY6NDE0Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWkwMDAtMTEwNC9mNDIxNDM2YTU5MWQzNGZhNTI3OWI1NGE5NmFjMDdk
NzAyNTBjYzhkL2RtZXNnLXlvY3RvLWxrcC1zdDAxLTEyOjIwMTMxMTA1MDM0MDE4OmkzODYt
cmFuZGNvbmZpZy1pMDAwLTExMDQ6My4xMi4wLXJjNi0wMTMyMi1nZjQyMTQzNjo0MTQKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctaTAwMC0xMTA0L2Y0MjE0MzZhNTkxZDM0ZmE1Mjc5YjU0
YTk2YWMwN2Q3MDI1MGNjOGQvZG1lc2ctcXVhbnRhbC1sa3Atc3QwMS0yOjIwMTMxMTA1MDMz
ODUzOmkzODYtcmFuZGNvbmZpZy1pMDAwLTExMDQ6My4xMi4wLXJjNi0wMTMyMi1nZjQyMTQz
Njo0MTQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwMC0xMTA0L2Y0MjE0MzZhNTkxZDM0
ZmE1Mjc5YjU0YTk2YWMwN2Q3MDI1MGNjOGQvZG1lc2ctcXVhbnRhbC1sa3AtdHQwMi0xOToy
MDEzMTEwNDEwMjgwMjppMzg2LXJhbmRjb25maWctaTAwMC0xMTA0OjMuMTIuMC1yYzYtMDEz
MjItZ2Y0MjE0MzY6NDE0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDAtMTEwNC9mNDIx
NDM2YTU5MWQzNGZhNTI3OWI1NGE5NmFjMDdkNzAyNTBjYzhkL2RtZXNnLXF1YW50YWwtYXRo
ZW5zLTE0OjIwMTMxMTA0MTk0MDE2OmkzODYtcmFuZGNvbmZpZy1pMDAwLTExMDQ6My4xMi4w
LXJjNi0wMTMyMi1nZjQyMTQzNjo0MTQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwMC0x
MTA0L2Y0MjE0MzZhNTkxZDM0ZmE1Mjc5YjU0YTk2YWMwN2Q3MDI1MGNjOGQvZG1lc2cteW9j
dG8tcm9hbS00MjoyMDEzMTEwNDE0MzQwNDppMzg2LXJhbmRjb25maWctaTAwMC0xMTA0OjMu
MTIuMC1yYzYtMDEzMjItZ2Y0MjE0MzY6NDE0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkw
MDAtMTEwNC9mNDIxNDM2YTU5MWQzNGZhNTI3OWI1NGE5NmFjMDdkNzAyNTBjYzhkL2RtZXNn
LXlvY3RvLXNuYi0xNDoyMDEzMTEwNDE0NDkyODppMzg2LXJhbmRjb25maWctaTAwMC0xMTA0
OjMuMTIuMC1yYzYtMDEzMjItZ2Y0MjE0MzY6NDE0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWkwMDAtMTEwNC9mNDIxNDM2YTU5MWQzNGZhNTI3OWI1NGE5NmFjMDdkNzAyNTBjYzhkL2Rt
ZXNnLXlvY3RvLWxrcC10dDAyLTE0OjIwMTMxMTA0MTAyNzQxOmkzODYtcmFuZGNvbmZpZy1p
MDAwLTExMDQ6My4xMi4wLXJjNi0wMTMyMi1nZjQyMTQzNjo0MTQKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctaTAwMC0xMTA0L2Y0MjE0MzZhNTkxZDM0ZmE1Mjc5YjU0YTk2YWMwN2Q3MDI1
MGNjOGQvZG1lc2cteW9jdG8tbGtwLXR0MDItNToyMDEzMTEwNDA1MjIxNzppMzg2LXJhbmRj
b25maWctaTAwMC0xMTA0OjMuMTIuMC1yYzYtMDEzMjItZ2Y0MjE0MzY6NDE0Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWkwMDAtMTEwNC9mNDIxNDM2YTU5MWQzNGZhNTI3OWI1NGE5NmFj
MDdkNzAyNTBjYzhkL2RtZXNnLXF1YW50YWwteGlhbi05OjIwMTMxMTA0MTQzMzQ1OmkzODYt
cmFuZGNvbmZpZy1pMDAwLTExMDQ6My4xMi4wLXJjNi0wMTMyMi1nZjQyMTQzNjo0MTQKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctaTAwMC0xMTA0L2Y0MjE0MzZhNTkxZDM0ZmE1Mjc5YjU0
YTk2YWMwN2Q3MDI1MGNjOGQvZG1lc2ctcXVhbnRhbC1jYWlyby00MToyMDEzMTEwNDE5NDAw
NzppMzg2LXJhbmRjb25maWctaTAwMC0xMTA0OjMuMTIuMC1yYzYtMDEzMjItZ2Y0MjE0MzY6
NDE0CjA6MTc6MTkgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCltkZXRhY2hlZCBIRUFE
IDFlNDE4ZDldIFJldmVydCAibGliOiBjcmMzMjogYWRkIHRlc3QgY2FzZXMgZm9yIGNyYzMy
eywgY31fY29tYmluZSByb3V0aW5lcyIKIDEgZmlsZSBjaGFuZ2VkLCA3MiBkZWxldGlvbnMo
LSkKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1p
MDAwLTExMDQvbmV0LW5leHQ6bWFzdGVyOjFlNDE4ZDk3MTZkOTA5ZGQ2ZDJhZmE4OWM5MDY2
ZjMyOWI2MjYxM2M6YmlzZWN0LXVzYgoKMjAxMy0xMS0wNC0yMToyMDoxOSAxZTQxOGQ5NzE2
ZDkwOWRkNmQyYWZhODljOTA2NmYzMjliNjI2MTNjIGNvbXBpbGluZwoKMjAxMy0xMS0wNC0y
MToyMTo1MCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmM2LTAxMzIzLWcxZTQxOGQ5
Li4uCTEuCTQuCTUJNgk3Lgk4CTE1CTI2CTQwCTQ4CTYwIFNVQ0NFU1MKCgo9PT09PT09PT0g
dXBzdHJlYW0gPT09PT09PT09CkZldGNoaW5nIGxpbnVzCmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaTAwMC0xMTA0L25ldC1uZXh0Om1hc3Rl
cjo1ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyOmJpc2VjdC11c2IK
IFNVQ0NFU1MKCgo9PT09PT09PT0gbGludXgtbmV4dCA9PT09PT09PT0KRmV0Y2hpbmcgbmV4
dApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWkw
MDAtMTEwNC9uZXQtbmV4dDptYXN0ZXI6ZTNhZDcxZjVlOGI2ZTcwMGEzOGQ1YTBkYTEyYjI5
ZDUzNjAwZTY1ZTpiaXNlY3QtdXNiCgoyMDEzLTExLTA0LTIxOjMwOjQwIGUzYWQ3MWY1ZThi
NmU3MDBhMzhkNWEwZGExMmIyOWQ1MzYwMGU2NWUgcmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctaTAwMC0xMTA0L2UzYWQ3MWY1ZThiNmU3MDBhMzhkNWEwZGExMmIyOWQ1MzYwMGU2
NWUvdm1saW51ei0zLjEyLjAtcmM3LW5leHQtMjAxMzExMDQtMDk4NTMtZ2UzYWQ3MWYKCjIw
MTMtMTEtMDQtMjE6MzA6NDEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uCTMxCTUwCTUyCTU0
CTYwIFNVQ0NFU1MKCg==

--8P1HSweYDcXXzwPJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.12.0-rc6-01322-gf421436"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.12.0-rc6 Kernel Configuration
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
CONFIG_NEED_DMA_MAP_STATE=y
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
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
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
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_RCU_FAST_NO_HZ=y
CONFIG_TREE_RCU_TRACE=y
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
CONFIG_MEMCG_KMEM=y
CONFIG_CGROUP_HUGETLB=y
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
# CONFIG_SCHED_AUTOGROUP is not set
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
CONFIG_RD_LZMA=y
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
CONFIG_RD_LZ4=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_SLUB_DEBUG is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_PROFILING=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
CONFIG_JUMP_LABEL=y
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
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_MODULE_SIG=y
CONFIG_MODULE_SIG_FORCE=y
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
CONFIG_MODULE_SIG_SHA224=y
# CONFIG_MODULE_SIG_SHA256 is not set
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha224"
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=m
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_BIGSMP=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_32_IRIS=m
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
CONFIG_LGUEST_GUEST=y
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
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
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=32
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_VM86=y
CONFIG_TOSHIBA=m
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=m
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=m
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
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
CONFIG_BOUNCE=y
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_CLEANCACHE is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_MEM_SOFT_DIRTY is not set
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_HOTPLUG_CPU is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

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

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=y
# CONFIG_SCx200HR_TIMER is not set
# CONFIG_OLPC is not set
CONFIG_ALIX=y
CONFIG_NET5501=y
CONFIG_AMD_NB=y
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
# CONFIG_X86_SYSFB is not set

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
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

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
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=m
CONFIG_MTD_TESTS=m
# CONFIG_MTD_REDBOOT_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
CONFIG_MTD_BLOCK_RO=m
CONFIG_FTL=m
CONFIG_NFTL=m
# CONFIG_NFTL_RW is not set
CONFIG_INFTL=m
CONFIG_RFD_FTL=m
CONFIG_SSFDC=m
CONFIG_SM_FTL=m
CONFIG_MTD_OOPS=m

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
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
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
CONFIG_MTD_SC520CDP=m
# CONFIG_MTD_NETSC520 is not set
CONFIG_MTD_TS5500=m
CONFIG_MTD_SCx200_DOCFLASH=m
# CONFIG_MTD_AMD76XROM is not set
CONFIG_MTD_ICHXROM=m
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
CONFIG_MTD_NETtel=m
CONFIG_MTD_L440GX=m
# CONFIG_MTD_PCI is not set
CONFIG_MTD_PCMCIA=m
# CONFIG_MTD_PCMCIA_ANONYMOUS is not set
CONFIG_MTD_GPIO_ADDR=m
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=m
# CONFIG_MTD_LATCH_ADDR is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=m
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=m
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=m
CONFIG_MTD_NAND_BCH=m
CONFIG_MTD_NAND_ECC_BCH=y
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=m
# CONFIG_MTD_NAND_DENALI_PCI is not set
# CONFIG_MTD_NAND_GPIO is not set
CONFIG_MTD_NAND_IDS=m
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=m
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
CONFIG_MTD_NAND_DOCG4=m
# CONFIG_MTD_NAND_CAFE is not set
# CONFIG_MTD_NAND_CS553X is not set
CONFIG_MTD_NAND_NANDSIM=m
CONFIG_MTD_NAND_PLATFORM=m
CONFIG_MTD_ONENAND=m
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
CONFIG_MTD_ONENAND_GENERIC=m
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=m
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_PC_PCMCIA=m
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
CONFIG_PARIDE=m

#
# Parallel IDE high-level drivers
#
# CONFIG_PARIDE_PD is not set
CONFIG_PARIDE_PCD=m
CONFIG_PARIDE_PF=m
# CONFIG_PARIDE_PT is not set
CONFIG_PARIDE_PG=m

#
# Parallel IDE protocol modules
#
# CONFIG_PARIDE_ATEN is not set
CONFIG_PARIDE_BPCK=m
# CONFIG_PARIDE_BPCK6 is not set
# CONFIG_PARIDE_COMM is not set
CONFIG_PARIDE_DSTR=m
# CONFIG_PARIDE_FIT2 is not set
CONFIG_PARIDE_FIT3=m
CONFIG_PARIDE_EPAT=m
CONFIG_PARIDE_EPATC8=y
CONFIG_PARIDE_EPIA=m
# CONFIG_PARIDE_FRIQ is not set
CONFIG_PARIDE_FRPW=m
CONFIG_PARIDE_KBIC=m
CONFIG_PARIDE_KTTI=m
# CONFIG_PARIDE_ON20 is not set
# CONFIG_PARIDE_ON26 is not set
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
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=m
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
CONFIG_AD525X_DPOT=m
CONFIG_AD525X_DPOT_I2C=m
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=m
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1780=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
CONFIG_DS1682=m
CONFIG_VMWARE_BALLOON=m
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=m
CONFIG_SRAM=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_LEGACY=m
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
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
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_PCMCIA_AHA152X=m
# CONFIG_PCMCIA_FDOMAIN is not set
CONFIG_PCMCIA_NINJA_SCSI=m
CONFIG_PCMCIA_QLOGIC=m
# CONFIG_PCMCIA_SYM53C500 is not set
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=y
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
# CONFIG_ATA_PIIX is not set
CONFIG_SATA_HIGHBANK=m
CONFIG_SATA_MV=m
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_RCAR is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
CONFIG_PATA_PCMCIA=m
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
# CONFIG_MD is not set
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
# CONFIG_TCM_FILEIO is not set
CONFIG_TCM_PSCSI=m
CONFIG_LOOPBACK_TARGET=m
# CONFIG_ISCSI_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set
CONFIG_VHOST_SCSI=m
CONFIG_VHOST_RING=m
CONFIG_VHOST=m

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=m
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=m
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
# CONFIG_JOYSTICK_ZHENHUA is not set
CONFIG_JOYSTICK_DB9=m
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
CONFIG_JOYSTICK_AS5011=m
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_JOYSTICK_WALKERA0701 is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_AD7879=y
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
CONFIG_TOUCHSCREEN_AUO_PIXCIR=m
# CONFIG_TOUCHSCREEN_BU21013 is not set
CONFIG_TOUCHSCREEN_CY8CTMG110=m
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=m
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP4_I2C is not set
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
# CONFIG_TOUCHSCREEN_EETI is not set
CONFIG_TOUCHSCREEN_FUJITSU=y
# CONFIG_TOUCHSCREEN_ILI210X is not set
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=m
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=m
# CONFIG_TOUCHSCREEN_MAX11801 is not set
CONFIG_TOUCHSCREEN_MCS5000=m
CONFIG_TOUCHSCREEN_MMS114=m
CONFIG_TOUCHSCREEN_MTOUCH=y
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=m
CONFIG_TOUCHSCREEN_PENMOUNT=y
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
CONFIG_TOUCHSCREEN_PIXCIR=m
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_MC13783 is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=y
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
CONFIG_TOUCHSCREEN_TSC2007=m
CONFIG_TOUCHSCREEN_ST1232=m
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PARKBD=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=m
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
# CONFIG_LEGACY_PTYS is not set
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
# CONFIG_N_HDLC is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_TIMBERDALE=m
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
CONFIG_SERIAL_ST_ASC=m
CONFIG_TTY_PRINTK=y
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=m
# CONFIG_IPMI_WATCHDOG is not set
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=m
CONFIG_NVRAM=m
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
# CONFIG_CARDMAN_4000 is not set
CONFIG_CARDMAN_4040=m
CONFIG_MWAVE=m
# CONFIG_SCx200_GPIO is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=m
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=m
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=m
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
CONFIG_I2C_MUX_PCA9541=m
CONFIG_I2C_MUX_PCA954x=m
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=m
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=m
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_TAOS_EVM=m

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
CONFIG_PPS_CLIENT_LDISC=y
# CONFIG_PPS_CLIENT_PARPORT is not set
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
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_TS5500=m
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_MAX7300=m
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_ADP5588 is not set

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
CONFIG_GPIO_MCP23S08=m

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#

#
# MODULbus GPIO expanders:
#

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2482 is not set
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2408=m
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
# CONFIG_W1_SLAVE_DS2413 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
# CONFIG_W1_SLAVE_DS2760 is not set
# CONFIG_W1_SLAVE_DS2780 is not set
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=m
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_SBS=m
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_MAX17040=m
CONFIG_BATTERY_MAX17042=m
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_CHARGER_MAX8903=m
CONFIG_CHARGER_LP8727=m
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MANAGER=y
CONFIG_CHARGER_BQ2415X=m
# CONFIG_CHARGER_BQ24190 is not set
CONFIG_CHARGER_SMB347=m
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=m
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=m
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_G762=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_GPIO_FAN=m
CONFIG_SENSORS_HIH6130=m
CONFIG_SENSORS_HTU21=m
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=m
CONFIG_SENSORS_LINEAGE=m
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95234=m
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MCP3021=m
CONFIG_SENSORS_NCT6775=m
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
CONFIG_SENSORS_ADM1275=m
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX34440 is not set
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_SHT15=m
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=m
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_MC13783_ADC=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_X86_PKG_TEMP_THERMAL=m

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
# CONFIG_RETU_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
CONFIG_SC520_WDT=m
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_SCx200_WDT is not set
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=m
# CONFIG_SBC7240_WDT is not set
CONFIG_CPU5_WDT=m
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=m
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=m
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=y
# CONFIG_W83977F_WDT is not set
CONFIG_MACHZ_WDT=m
CONFIG_SBC_EPX_C3_WATCHDOG=m
CONFIG_MEN_A21_WDT=y

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
# CONFIG_SSB_PCMCIAHOST is not set
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_HOST_SOC=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DRIVER_GPIO=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_CROS_EC=m
CONFIG_MFD_CROS_EC_I2C=m
CONFIG_MFD_MC13783=m
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_I2C=m
CONFIG_HTC_PASIC3=y
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_RETU=m
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
CONFIG_PCF50633_GPIO=m
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_SI476X_CORE=m
# CONFIG_MFD_SM501 is not set
CONFIG_ABX500_CORE=y
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_TPS6105X=m
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=m
CONFIG_MFD_TPS65217=m
# CONFIG_MFD_TPS65912 is not set
CONFIG_MFD_WL1273_CORE=m
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_DA9210=m
CONFIG_REGULATOR_FAN53555=m
CONFIG_REGULATOR_GPIO=m
CONFIG_REGULATOR_ISL6271A=m
CONFIG_REGULATOR_LP3971=m
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=m
CONFIG_REGULATOR_LP8755=m
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=m
CONFIG_REGULATOR_MAX8660=m
CONFIG_REGULATOR_MAX8952=m
CONFIG_REGULATOR_MAX8973=m
CONFIG_REGULATOR_MC13XXX_CORE=m
CONFIG_REGULATOR_MC13783=m
CONFIG_REGULATOR_MC13892=m
# CONFIG_REGULATOR_PCF50633 is not set
# CONFIG_REGULATOR_PFUZE100 is not set
# CONFIG_REGULATOR_TPS51632 is not set
# CONFIG_REGULATOR_TPS6105X is not set
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
# CONFIG_REGULATOR_TPS6507X is not set
# CONFIG_REGULATOR_TPS65217 is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_V4L2_INT_DEVICE=m
CONFIG_DVB_CORE=m
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y

#
# Media drivers
#
CONFIG_RC_CORE=m
CONFIG_RC_MAP=m
# CONFIG_RC_DECODERS is not set
CONFIG_RC_DEVICES=y
# CONFIG_RC_ATI_REMOTE is not set
# CONFIG_IR_ENE is not set
# CONFIG_IR_IMON is not set
# CONFIG_IR_MCEUSB is not set
# CONFIG_IR_ITE_CIR is not set
# CONFIG_IR_FINTEK is not set
# CONFIG_IR_NUVOTON is not set
# CONFIG_IR_REDRAT3 is not set
# CONFIG_IR_STREAMZAP is not set
# CONFIG_IR_WINBOND_CIR is not set
# CONFIG_IR_IGUANA is not set
# CONFIG_IR_TTUSBIR is not set
# CONFIG_RC_LOOPBACK is not set
# CONFIG_IR_GPIO_CIR is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=m

#
# Audio decoders, processors and mixers
#

#
# RDS decoders
#

#
# Video decoders
#

#
# Video and audio decoders
#

#
# Video encoders
#

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#

#
# Miscelaneous helper chips
#

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MC44S803=m

#
# Multistandard (satellite) frontends
#

#
# Multistandard (cable + terrestrial) frontends
#

#
# DVB-S (satellite) frontends
#

#
# DVB-T (terrestrial) frontends
#

#
# DVB-C (cable) frontends
#

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#

#
# ISDB-T (terrestrial) frontends
#

#
# Digital terrestrial only tuners/PLL
#

#
# SEC control devices for DVB-S
#

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_HDMI=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=m
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=m
CONFIG_FB_TMIO_ACCELL=y
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=m
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
# CONFIG_FB_AUO_K1901 is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_PLATFORM=m
# CONFIG_BACKLIGHT_CLASS_DEVICE is not set
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set

#
# HID support
#
# CONFIG_HID is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
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
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=m
CONFIG_LEDS_LM3642=m
CONFIG_LEDS_PCA9532=m
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8501=m
CONFIG_LEDS_PCA955X=m
CONFIG_LEDS_PCA963X=m
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_MC13783=m
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_LM355x=m
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_PROC=y
# CONFIG_RTC_INTF_DEV is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_MAX6900=m
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_ISL12022=m
# CONFIG_RTC_DRV_X1205 is not set
CONFIG_RTC_DRV_PCF2127=m
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
CONFIG_RTC_DRV_PCF8583=m
# CONFIG_RTC_DRV_M41T80 is not set
CONFIG_RTC_DRV_BQ32K=m
CONFIG_RTC_DRV_S35390A=m
CONFIG_RTC_DRV_FM3130=m
# CONFIG_RTC_DRV_RX8581 is not set
CONFIG_RTC_DRV_RX8025=m
# CONFIG_RTC_DRV_EM3027 is not set
CONFIG_RTC_DRV_RV3029C2=m

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=m
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set
CONFIG_RTC_DRV_DS2404=m
CONFIG_RTC_DRV_PCF50633=m

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MC13XXX is not set
# CONFIG_RTC_DRV_MOXART is not set

#
# HID Sensor RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=m
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=m
CONFIG_UIO_DMEM_GENIRQ=m
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_ECHO is not set
CONFIG_COMEDI=m
CONFIG_COMEDI_DEBUG=y
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
# CONFIG_COMEDI_MISC_DRIVERS is not set
CONFIG_COMEDI_ISA_DRIVERS=y
# CONFIG_COMEDI_PCL711 is not set
CONFIG_COMEDI_PCL724=m
CONFIG_COMEDI_PCL726=m
# CONFIG_COMEDI_PCL730 is not set
CONFIG_COMEDI_PCL812=m
CONFIG_COMEDI_PCL816=m
CONFIG_COMEDI_PCL818=m
# CONFIG_COMEDI_PCM3724 is not set
CONFIG_COMEDI_AMPLC_DIO200_ISA=m
CONFIG_COMEDI_AMPLC_PC236_ISA=m
CONFIG_COMEDI_AMPLC_PC263_ISA=m
CONFIG_COMEDI_RTI800=m
# CONFIG_COMEDI_RTI802 is not set
CONFIG_COMEDI_DAS16M1=m
CONFIG_COMEDI_DAS08_ISA=m
CONFIG_COMEDI_DAS16=m
CONFIG_COMEDI_DAS800=m
CONFIG_COMEDI_DAS1800=m
CONFIG_COMEDI_DAS6402=m
CONFIG_COMEDI_DT2801=m
CONFIG_COMEDI_DT2811=m
CONFIG_COMEDI_DT2814=m
CONFIG_COMEDI_DT2815=m
CONFIG_COMEDI_DT2817=m
CONFIG_COMEDI_DT282X=m
# CONFIG_COMEDI_DMM32AT is not set
CONFIG_COMEDI_UNIOXX5=m
# CONFIG_COMEDI_FL512 is not set
CONFIG_COMEDI_AIO_AIO12_8=m
CONFIG_COMEDI_AIO_IIRO_16=m
CONFIG_COMEDI_II_PCI20KC=m
CONFIG_COMEDI_C6XDIGIO=m
CONFIG_COMEDI_MPC624=m
CONFIG_COMEDI_ADQ12B=m
# CONFIG_COMEDI_NI_AT_A2150 is not set
CONFIG_COMEDI_NI_AT_AO=m
CONFIG_COMEDI_NI_ATMIO=m
CONFIG_COMEDI_NI_ATMIO16D=m
CONFIG_COMEDI_NI_LABPC_ISA=m
CONFIG_COMEDI_PCMAD=m
CONFIG_COMEDI_PCMDA12=m
CONFIG_COMEDI_PCMMIO=m
CONFIG_COMEDI_PCMUIO=m
CONFIG_COMEDI_MULTIQ3=m
# CONFIG_COMEDI_POC is not set
CONFIG_COMEDI_S526=m
# CONFIG_COMEDI_PCI_DRIVERS is not set
# CONFIG_COMEDI_PCMCIA_DRIVERS is not set
CONFIG_COMEDI_8255=m
CONFIG_COMEDI_FC=m
CONFIG_COMEDI_AMPLC_DIO200=m
CONFIG_COMEDI_AMPLC_PC236=m
CONFIG_COMEDI_DAS08=m
CONFIG_COMEDI_NI_LABPC=m
CONFIG_COMEDI_NI_LABPC_ISADMA=m
CONFIG_COMEDI_NI_TIO=m
CONFIG_PANEL=m
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
CONFIG_PANEL_CHANGE_MESSAGE=y
CONFIG_PANEL_BOOT_MESSAGE=""
# CONFIG_IDE_PHISON is not set
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#

#
# Accelerometers
#

#
# Analog to digital converters
#
# CONFIG_AD7291 is not set
CONFIG_AD7606=y
# CONFIG_AD7606_IFACE_PARALLEL is not set
CONFIG_AD799X=m
CONFIG_AD799X_RING_BUFFER=y

#
# Analog digital bi-direction converters
#
# CONFIG_ADT7316 is not set

#
# Capacitance to digital converters
#
CONFIG_AD7150=m
# CONFIG_AD7152 is not set
CONFIG_AD7746=m

#
# Direct Digital Synthesis
#

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=m

#
# Light sensors
#
# CONFIG_SENSORS_ISL29018 is not set
# CONFIG_SENSORS_ISL29028 is not set
CONFIG_TSL2583=m
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=m

#
# Active energy metering IC
#
CONFIG_ADE7854=m
CONFIG_ADE7854_I2C=m

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
CONFIG_IIO_PERIODIC_RTC_TRIGGER=y
CONFIG_IIO_SIMPLE_DUMMY=m
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
CONFIG_ZSMALLOC=y
CONFIG_ZRAM=m
CONFIG_ZRAM_DEBUG=y
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=m
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=m
CONFIG_STAGING_MEDIA=y
# CONFIG_DVB_CXD2099 is not set
# CONFIG_VIDEO_DT3155 is not set

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
# CONFIG_ANDROID_LOGGER is not set
CONFIG_ANDROID_TIMED_OUTPUT=y
CONFIG_ANDROID_TIMED_GPIO=m
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
CONFIG_ANDROID_INTF_ALARM_DEV=y
# CONFIG_SYNC is not set
CONFIG_DGRP=m
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
CONFIG_DGAP=y
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=m
CONFIG_STE_MODEM_RPROC=m

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=m
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
CONFIG_DEVFREQ_GOV_USERSPACE=m

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
CONFIG_EXTCON_ADC_JACK=m
CONFIG_MEMORY=y
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
CONFIG_BMA180=m
CONFIG_IIO_ST_ACCEL_3AXIS=m
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=m

#
# Analog to digital converters
#
# CONFIG_MAX1363 is not set
CONFIG_NAU7802=m
CONFIG_TI_ADC081C=m
CONFIG_TI_AM335X_ADC=y

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Digital to analog converters
#
CONFIG_AD5064=m
CONFIG_AD5380=m
# CONFIG_AD5446 is not set
CONFIG_MAX517=m
CONFIG_MCP4725=m

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital gyroscope sensors
#
CONFIG_IIO_ST_GYRO_3AXIS=m
CONFIG_IIO_ST_GYRO_I2C_3AXIS=m
CONFIG_ITG3200=m

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=m

#
# Light sensors
#
CONFIG_ADJD_S311=m
# CONFIG_APDS9300 is not set
CONFIG_SENSORS_TSL2563=m
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
CONFIG_AK8975=m
CONFIG_IIO_ST_MAGN_3AXIS=m
CONFIG_IIO_ST_MAGN_I2C_3AXIS=m

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
# CONFIG_IIO_ST_PRESS is not set

#
# Temperature sensors
#
CONFIG_TMP006=m
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y
# CONFIG_FMC is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=m
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_EXT4_DEBUG=y
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
# CONFIG_REISERFS_FS_SECURITY is not set
CONFIG_JFS_FS=m
# CONFIG_JFS_POSIX_ACL is not set
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=m
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
CONFIG_CACHEFILES_HISTOGRAM=y

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
CONFIG_NTFS_FS=m
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
# CONFIG_PROC_SYSCTL is not set
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=m
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=m
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=y
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=m
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
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
CONFIG_DEBUG_PER_CPU_MAPS=y
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
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
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_KOBJECT_RELEASE=y
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_FAULT_INJECTION_STACKTRACE_FILTER=y
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
CONFIG_LKDTM=m
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=m
CONFIG_INTERVAL_TREE_TEST=m
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=m
CONFIG_TEST_KSTRTOX=m
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
# CONFIG_DOUBLEFAULT is not set
# CONFIG_DEBUG_TLBFLUSH is not set
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
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
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
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=m
# CONFIG_CRYPTO_GHASH is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_DES is not set
CONFIG_CRYPTO_FCRYPT=m
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=m
CONFIG_CRYPTO_LZ4=y
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
CONFIG_LGUEST=y
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
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=m
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=m
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y

--8P1HSweYDcXXzwPJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--8P1HSweYDcXXzwPJ--
