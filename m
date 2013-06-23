Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640Ab3FXMzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 08:55:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:6042 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232Ab3FXMzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 08:55:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,928,1363158000"; 
   d="log'?scan'208";a="354843022"
Date: Mon, 24 Jun 2013 07:04:49 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: fengguang.wu@intel.com, Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org
Subject: [x86/kaslr] BUG: unable to handle kernel paging request at
 ffff88000e8d6000
Message-ID: <20130623230449.GB12259@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit 57fa4af0635d30b2061377aab87094762fbc3373
Author: Kees Cook <keescook@chromium.org>
Date:   Tue Apr 23 17:18:38 2013 -0700

    x86: kaslr: select random base offset
    
    Select a random location when CONFIG_RANDOMIZE_BASE is used, bounded
    by CONFIG_RANDOMIZE_BASE_MAX_OFFSET. Sources of randomness currently
    include RDRAND, RDTSC, or the i8254.
    
    Signed-off-by: Kees Cook <keescook@chromium.org>
    ---
    v3:
     - fall back to reading the i8254 when no TSC, suggested by HPA.
    v2:
     - use rdtscl from msr.h, thanks to Mathias Krause.

[    1.402214] Initramfs unpacking failed: junk in compressed archive
[    1.405745] Freeing initrd memory: 23656k freed
[    1.407846] BUG: unable to handle kernel paging request at ffff88000e8d6000
[    1.410031] IP: [<ffffffff8e031bf7>] free_init_pages+0xf1/0x14d
[    1.410031] PGD f550067 PUD f551067 PMD c1c6063 PTE 800000000e8d6161
[    1.410031] Oops: 0003 [#1] 
[    1.410031] Modules linked in:
[    1.410031] CPU: 0 PID: 1 Comm: swapper Not tainted 3.10.0-rc7-00012-g728c681 #3
[    1.410031] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.410031] task: ffff88000d0b8000 ti: ffff88000d0b2000 task.ti: ffff88000d0b2000
[    1.410031] RIP: 0010:[<ffffffff8e031bf7>]  [<ffffffff8e031bf7>] free_init_pages+0xf1/0x14d
[    1.410031] RSP: 0000:ffff88000d0b3e78  EFLAGS: 00010202
[    1.410031] RAX: 00000000cccccccc RBX: ffff88000e8d6000 RCX: 0000000000000400
[    1.410031] RDX: ffff88000d0b3fd8 RSI: 0000000000000006 RDI: ffff88000e8d6000
[    1.410031] RBP: ffff88000d0b3ea8 R08: 0000000000000000 R09: ffffffff8e8bd7b0
[    1.410031] R10: ffffffff8e8bd7b0 R11: ffffffff8e8bd7b0 R12: ffff88000fff0000
[    1.410031] R13: ffffea0000000000 R14: ffffffff8eba3398 R15: 000000000000171a
[    1.410031] FS:  0000000000000000(0000) GS:ffffffff8ee28000(0000) knlGS:0000000000000000
[    1.410031] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.410031] CR2: ffff88000e8d6000 CR3: 000000000ee10000 CR4: 00000000000006f0
[    1.410031] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    1.410031] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    1.410031] Stack:
[    1.410031]  0000000000000000 ffffffff8f0e4dde ffffffff8f1b57c0 0000000000000000
[    1.410031]  0000000000000000 0000000000000000 ffff88000d0b3eb8 ffffffff8f0fa870
[    1.410031]  ffff88000d0b3ec8 ffffffff8f0e4eab ffff88000d0b3ef8 ffffffff8e0002c3
[    1.410031] Call Trace:
[    1.410031]  [<ffffffff8f0e4dde>] ? unpack_to_rootfs+0x33b/0x33b
[    1.410031]  [<ffffffff8f0fa870>] free_initrd_mem+0x28/0x31
[    1.410031]  [<ffffffff8f0e4eab>] populate_rootfs+0xcd/0x101
[    1.410031]  [<ffffffff8e0002c3>] do_one_initcall+0xe8/0x1c5
[    1.410031]  [<ffffffff8f0e341a>] kernel_init_freeable+0x1a5/0x2ac
[    1.410031]  [<ffffffff8f0e2862>] ? loglevel+0x46/0x46
[    1.410031]  [<ffffffff8e6c2380>] ? rest_init+0xd4/0xd4
[    1.410031]  [<ffffffff8e6c2395>] kernel_init+0x15/0x176
[    1.410031]  [<ffffffff8e6d8bfa>] ret_from_fork+0x7a/0xb0
[    1.410031]  [<ffffffff8e6c2380>] ? rest_init+0xd4/0xd4
[    1.410031] Code: c0 e8 e0 c6 69 00 48 ff 05 2f aa 1e 01 49 bd 00 00 00 00 00 ea ff ff 48 ff 05 3e aa 1e 01 b9 00 04 00 00 b8 cc cc cc cc 48 89 df <f3> ab 48 89 df e8 c6 66 00 00 48 ff 05 08 aa 1e 01 48 c1 e8 0c 
[    1.410031] RIP  [<ffffffff8e031bf7>] free_init_pages+0xf1/0x14d
[    1.410031]  RSP <ffff88000d0b3e78>
[    1.410031] CR2: ffff88000e8d6000
[    1.410031] ---[ end trace 960e7beaae8e44f3 ]---

git bisect start 728c681783a8e0b8a0dc5df440503c51bbaa9789 9e895ace5d82df8929b16f58e9f515f6d54ab82d --
git bisect  bad 76bf0e2ad9dacf346f861d13764ef4e3ed10e310  # 13:56     27-  x86: kaslr: report kernel offset on panic
git bisect good a6c21a0b3185bcc54996819157735398140a674f  # 14:23    160+  x86: kaslr: return location from decompress_kernel
git bisect  bad c1babe7ec300af293cf2716f037a935e6bb81a94  # 14:29     48-  x86: kaslr: select memory region from e820 maps
git bisect  bad 57fa4af0635d30b2061377aab87094762fbc3373  # 14:33     11-  x86: kaslr: select random base offset
git bisect good a6c21a0b3185bcc54996819157735398140a674f  # 14:49    480+  x86: kaslr: return location from decompress_kernel
git bisect  bad 728c681783a8e0b8a0dc5df440503c51bbaa9789  # 14:49      0-  Merge remote-tracking branch 'kees/strncpy-strlen' into devel-hive-x86_64-201306231236
git bisect good 9e895ace5d82df8929b16f58e9f515f6d54ab82d  # 15:23    480+  Linux 3.10-rc7
git bisect good e1a86578747376f08985627c84df088a5d0d1e92  # 16:13    480+  Add linux-next specific files for 20130621

Thanks,
Fengguang

--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-roam-19428-20130623125605-3.10.0-rc7-00012-g728c681-3"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.10.0-rc7-00012-g728c681 (kbuild@hive) (gcc version 4.7.1 (GCC) ) #3 Sun Jun 23 12:56:56 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-h004-0623/devel-hive-x86_64-201306231236/.vmlinuz-728c681783a8e0b8a0dc5df440503c51bbaa9789-20130623130101-5-roam branch=linux-devel/devel-hive-x86_64-201306231236  BOOT_IMAGE=/kernel/x86_64-randconfig-h004-0623/728c681783a8e0b8a0dc5df440503c51bbaa9789/vmlinuz-3.10.0-rc7-00012-g728c681
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x400000000
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
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at [ffff8800000fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0f550000, 0x0f550fff] PGTABLE
[    0.000000] BRK [0x0f551000, 0x0f551fff] PGTABLE
[    0.000000] BRK [0x0f552000, 0x0f552fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0de00000-0x0dffffff]
[    0.000000]  [mem 0x0de00000-0x0dffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0ddfffff]
[    0.000000]  [mem 0x0c000000-0x0ddfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0fffdfff]
[    0.000000]  [mem 0x0e000000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127360(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 011A9 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000ca00000-ffff88000cdfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 960 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr ee46980
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64391
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-h004-0623/devel-hive-x86_64-201306231236/.vmlinuz-728c681783a8e0b8a0dc5df440503c51bbaa9789-20130623130101-5-roam branch=linux-devel/devel-hive-x86_64-201306231236  BOOT_IMAGE=/kernel/x86_64-randconfig-h004-0623/728c681783a8e0b8a0dc5df440503c51bbaa9789/vmlinuz-3.10.0-rc7-00012-g728c681
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 215892k/262136k available (7018k kernel code, 392k absent, 45852k reserved, 10262k data, 928k init)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
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
[    0.000000]                     double unlock:  ok  |  ok  |failed|failed|failed|failed|
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
[    0.000000] 143 out of 218 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2893.002 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5786.00 BogoMIPS (lpj=28930020)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] Security Framework initialized
[    0.020000] AppArmor: AppArmor disabled by boot time parameter
[    0.020016] Yama: becoming mindful.
[    0.021651] Mount-cache hash table entries: 256
[    0.025109] Initializing cgroup subsys devices
[    0.026661] Initializing cgroup subsys freezer
[    0.028188] Initializing cgroup subsys hugetlb
[    0.030360] mce: CPU supports 10 MCE banks
[    0.031909] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.031909] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.031909] tlb_flushall_shift: 6
[    0.036343] CPU: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.044361] ACPI: Core revision 20130328
[    0.121719] ACPI: All ACPI Tables successfully acquired
[    0.124106] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.133760] Getting VERSION: 50014
[    0.135128] Getting VERSION: 50014
[    0.136474] Getting ID: 0
[    0.137763] Getting ID: ff000000
[    0.139082] Getting LVT0: 8700
[    0.140016] Getting LVT1: 8400
[    0.141385] enabled ExtINT on CPU#0
[    0.143931] ENABLING IO-APIC IRQs
[    0.145266] init IO_APIC IRQs
[    0.146546]  apic 0 pin 0 not connected
[    0.148006] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.150045] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.152850] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.155644] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.160046] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.162810] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.165579] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.168347] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.170044] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.172820] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.175619] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.180043] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.182849] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.185646] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.188438] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.190027]  apic 0 pin 16 not connected
[    0.191447]  apic 0 pin 17 not connected
[    0.192854]  apic 0 pin 18 not connected
[    0.194262]  apic 0 pin 19 not connected
[    0.195679]  apic 0 pin 20 not connected
[    0.197086]  apic 0 pin 21 not connected
[    0.200007]  apic 0 pin 22 not connected
[    0.201490]  apic 0 pin 23 not connected
[    0.203067] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.204990] Using local APIC timer interrupts.
[    0.204990] calibrating APIC timer ...
[    0.210000] ... lapic delta = 6250620
[    0.210000] ... PM-Timer delta = 357997
[    0.210000] ... PM-Timer result ok
[    0.210000] ..... delta 6250620
[    0.210000] ..... mult: 268462084
[    0.210000] ..... calibration result: 10000992
[    0.210000] ..... CPU clock speed is 2893.3747 MHz.
[    0.210000] ..... host bus clock speed is 1000.0992 MHz.
[    0.211051] devtmpfs: initialized
[    0.217336] gcov: version magic: 0x3430372a
[    0.219559] EVM: security.SMACK64
[    0.220007] EVM: security.capability
[    0.244576] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.248460] regulator-dummy: no parameters
[    0.251034] NET: Registered protocol family 16
[    0.255471] ACPI: bus type PCI registered
[    0.257851] PCI: Using configuration type 1 for base access
[    0.285071] bio: create slab <bio-0> at 0
[    0.287758] ACPI: Added _OSI(Module Device)
[    0.289363] ACPI: Added _OSI(Processor Device)
[    0.290027] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.291733] ACPI: Added _OSI(Processor Aggregator Device)
[    0.295374] ACPI: EC: Look up EC in DSDT
[    0.424720] ACPI: Interpreter enabled
[    0.426325] ACPI: (supports S0 S5)
[    0.427764] ACPI: Using IOAPIC for interrupt routing
[    0.429847] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.688659] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.704680] PCI host bridge to bus 0000:00
[    0.706251] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.709137] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.710022] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.712375] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.714919] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
[    0.717572] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.735381] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.742147] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.762780] pci 0000:00:01.1: reg 20: [io  0xc1e0-0xc1ef]
[    0.773153] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.776035] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.779221] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.781105] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.785489] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.790894] pci 0000:00:02.0: reg 14: [mem 0xfebe0000-0xfebe0fff]
[    0.801771] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
[    0.804954] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.808550] pci 0000:00:03.0: reg 10: [io  0xc1c0-0xc1df]
[    0.811522] pci 0000:00:03.0: reg 14: [mem 0xfebe1000-0xfebe1fff]
[    0.821523] pci 0000:00:03.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
[    0.825480] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.829030] pci 0000:00:04.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
[    0.831507] pci 0000:00:04.0: reg 14: [io  0xc000-0xc03f]
[    0.842328] pci 0000:00:04.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
[    0.846398] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.850008] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    0.854037] pci 0000:00:05.0: reg 14: [mem 0xfebe2000-0xfebe2fff]
[    0.867912] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.871797] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    0.875667] pci 0000:00:06.0: reg 14: [mem 0xfebe3000-0xfebe3fff]
[    0.891450] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.895528] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.899416] pci 0000:00:07.0: reg 14: [mem 0xfebe4000-0xfebe4fff]
[    0.913107] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.917655] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    0.921747] pci 0000:00:08.0: reg 14: [mem 0xfebe5000-0xfebe5fff]
[    0.936716] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.940929] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    0.944469] pci 0000:00:09.0: reg 14: [mem 0xfebe6000-0xfebe6fff]
[    0.958583] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.961810] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    0.965975] pci 0000:00:0a.0: reg 14: [mem 0xfebe7000-0xfebe7fff]
[    0.982271] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.985282] pci 0000:00:0b.0: reg 10: [mem 0xfebe8000-0xfebe800f]
[    0.996443] pci_bus 0000:00: on NUMA node 0
[    0.998128] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    1.019331] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.027023] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.035486] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.044153] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.049195] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    1.057045] ACPI: Enabled 16 GPEs in block 00 to 0F
[    1.059348] acpi root: \_SB_.PCI0 notify handler is installed
[    1.060083] Found 1 acpi root devices
[    1.064096] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.067640] vgaarb: loaded
[    1.070004] vgaarb: bridge control possible 0000:00:02.0
[    1.074239] ACPI: bus type USB registered
[    1.076680] usbcore: registered new interface driver usbfs
[    1.080300] usbcore: registered new interface driver hub
[    1.082723] usbcore: registered new device driver usb
[    1.085980] pps_core: LinuxPPS API ver. 1 registered
[    1.088048] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.090169] PTP clock support registered
[    1.092584] PCI: Using ACPI for IRQ routing
[    1.094308] PCI: pci_cache_line_size set to 64 bytes
[    1.096523] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.100029] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    1.104575] NetLabel: Initializing
[    1.106269] NetLabel:  domain hash size = 128
[    1.108044] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.110336] NetLabel:  unlabeled traffic allowed by default
[    1.112644] Switching to clocksource kvm-clock
[    1.246641] pnp: PnP ACPI init
[    1.248470] ACPI: bus type PNP registered
[    1.250951] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    1.254771] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.257724] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    1.261498] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.264426] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    1.268265] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.272091] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    1.275386] pnp 00:03: [dma 2]
[    1.277410] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.281377] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    1.285266] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.289040] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    1.293646] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.304398] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.313439] pnp: PnP ACPI: found 7 devices
[    1.315431] ACPI: bus type PNP unregistered
[    1.356160] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.358588] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.361059] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.363650] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.366550] NET: Registered protocol family 2
[    1.370093] TCP established hash table entries: 2048 (order: 3, 32768 bytes)
[    1.372930] TCP bind hash table entries: 2048 (order: 4, 65536 bytes)
[    1.375582] TCP: Hash tables configured (established 2048 bind 2048)
[    1.378294] TCP: reno registered
[    1.380034] UDP hash table entries: 256 (order: 2, 24576 bytes)
[    1.382554] UDP-Lite hash table entries: 256 (order: 2, 24576 bytes)
[    1.385786] NET: Registered protocol family 1
[    1.387928] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.390451] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.392904] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.395483] pci 0000:00:02.0: Boot video device
[    1.397696] PCI: CLS 0 bytes, default 64
[    1.400362] Unpacking initramfs...
[    1.402214] Initramfs unpacking failed: junk in compressed archive
[    1.405745] Freeing initrd memory: 23656k freed
[    1.407846] BUG: unable to handle kernel paging request at ffff88000e8d6000
[    1.410031] IP: [<ffffffff8e031bf7>] free_init_pages+0xf1/0x14d
[    1.410031] PGD f550067 PUD f551067 PMD c1c6063 PTE 800000000e8d6161
[    1.410031] Oops: 0003 [#1] 
[    1.410031] Modules linked in:
[    1.410031] CPU: 0 PID: 1 Comm: swapper Not tainted 3.10.0-rc7-00012-g728c681 #3
[    1.410031] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.410031] task: ffff88000d0b8000 ti: ffff88000d0b2000 task.ti: ffff88000d0b2000
[    1.410031] RIP: 0010:[<ffffffff8e031bf7>]  [<ffffffff8e031bf7>] free_init_pages+0xf1/0x14d
[    1.410031] RSP: 0000:ffff88000d0b3e78  EFLAGS: 00010202
[    1.410031] RAX: 00000000cccccccc RBX: ffff88000e8d6000 RCX: 0000000000000400
[    1.410031] RDX: ffff88000d0b3fd8 RSI: 0000000000000006 RDI: ffff88000e8d6000
[    1.410031] RBP: ffff88000d0b3ea8 R08: 0000000000000000 R09: ffffffff8e8bd7b0
[    1.410031] R10: ffffffff8e8bd7b0 R11: ffffffff8e8bd7b0 R12: ffff88000fff0000
[    1.410031] R13: ffffea0000000000 R14: ffffffff8eba3398 R15: 000000000000171a
[    1.410031] FS:  0000000000000000(0000) GS:ffffffff8ee28000(0000) knlGS:0000000000000000
[    1.410031] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.410031] CR2: ffff88000e8d6000 CR3: 000000000ee10000 CR4: 00000000000006f0
[    1.410031] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    1.410031] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    1.410031] Stack:
[    1.410031]  0000000000000000 ffffffff8f0e4dde ffffffff8f1b57c0 0000000000000000
[    1.410031]  0000000000000000 0000000000000000 ffff88000d0b3eb8 ffffffff8f0fa870
[    1.410031]  ffff88000d0b3ec8 ffffffff8f0e4eab ffff88000d0b3ef8 ffffffff8e0002c3
[    1.410031] Call Trace:
[    1.410031]  [<ffffffff8f0e4dde>] ? unpack_to_rootfs+0x33b/0x33b
[    1.410031]  [<ffffffff8f0fa870>] free_initrd_mem+0x28/0x31
[    1.410031]  [<ffffffff8f0e4eab>] populate_rootfs+0xcd/0x101
[    1.410031]  [<ffffffff8e0002c3>] do_one_initcall+0xe8/0x1c5
[    1.410031]  [<ffffffff8f0e341a>] kernel_init_freeable+0x1a5/0x2ac
[    1.410031]  [<ffffffff8f0e2862>] ? loglevel+0x46/0x46
[    1.410031]  [<ffffffff8e6c2380>] ? rest_init+0xd4/0xd4
[    1.410031]  [<ffffffff8e6c2395>] kernel_init+0x15/0x176
[    1.410031]  [<ffffffff8e6d8bfa>] ret_from_fork+0x7a/0xb0
[    1.410031]  [<ffffffff8e6c2380>] ? rest_init+0xd4/0xd4
[    1.410031] Code: c0 e8 e0 c6 69 00 48 ff 05 2f aa 1e 01 49 bd 00 00 00 00 00 ea ff ff 48 ff 05 3e aa 1e 01 b9 00 04 00 00 b8 cc cc cc cc 48 89 df <f3> ab 48 89 df e8 c6 66 00 00 48 ff 05 08 aa 1e 01 48 c1 e8 0c 
[    1.410031] RIP  [<ffffffff8e031bf7>] free_init_pages+0xf1/0x14d
[    1.410031]  RSP <ffff88000d0b3e78>
[    1.410031] CR2: ffff88000e8d6000
[    1.410031] ---[ end trace 960e7beaae8e44f3 ]---
[    1.410031] Kernel panic - not syncing: Fatal exception
[    1.410031] Rebooting in 10 seconds..
BUG: kernel boot crashed
Elapsed time: 20

--ikeVEW9yuYc//A+q
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-728c681783a8e0b8a0dc5df440503c51bbaa9789-x86_64-randconfig-h004-0623-BUG:-unable-to-handle-kernel-55670.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDllODk1YWNlNWQ4MmRmODkyOWIxNmY1OGU5ZjUxNWY2ZDU0YWI4MmQK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgNzI4YzY4MS4uLiBNZXJnZSByZW1vdGUtdHJh
Y2tpbmcgYnJhbmNoICdrZWVzL3N0cm5jcHktc3RybGVuJyBpbnRvIGRldmVsLWhpdmUteDg2
XzY0LTIwMTMwNjIzMTIzNgpIRUFEIGlzIG5vdyBhdCA5ZTg5NWFjLi4uIExpbnV4IDMuMTAt
cmM3CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZp
Zy1oMDA0LTA2MjMvbGludXgtZGV2ZWw6ZGV2ZWwtaGl2ZS14ODZfNjQtMjAxMzA2MjMxMjM2
OjllODk1YWNlNWQ4MmRmODkyOWIxNmY1OGU5ZjUxNWY2ZDU0YWI4MmQ6YmlzZWN0LXNvdW5k
CgoyMDEzLTA2LTIzLTEzOjM4OjE1IDllODk1YWNlNWQ4MmRmODkyOWIxNmY1OGU5ZjUxNWY2
ZDU0YWI4MmQgcmV1c2UgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oMDA0LTA2MjMvOWU4
OTVhY2U1ZDgyZGY4OTI5YjE2ZjU4ZTlmNTE1ZjZkNTRhYjgyZC92bWxpbnV6LTMuMTAuMC1y
YzcKCjIwMTMtMDYtMjMtMTM6Mzg6MTcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMTUJMjUJ
MzgJNDcJNjEJNzUuCTg1CTkwIFNVQ0NFU1MKCmJpc2VjdDogZ29vZCBjb21taXQgOWU4OTVh
Y2U1ZDgyZGY4OTI5YjE2ZjU4ZTlmNTE1ZjZkNTRhYjgyZApnaXQgYmlzZWN0IHN0YXJ0IDcy
OGM2ODE3ODNhOGUwYjhhMGRjNWRmNDQwNTAzYzUxYmJhYTk3ODkgOWU4OTVhY2U1ZDgyZGY4
OTI5YjE2ZjU4ZTlmNTE1ZjZkNTRhYjgyZCAtLQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdh
cyA5ZTg5NWFjLi4uIExpbnV4IDMuMTAtcmM3CkhFQUQgaXMgbm93IGF0IGMxYmU1YTUuLi4g
TGludXggMy45CkJpc2VjdGluZzogNSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgMyBzdGVwcykKWzc2YmYwZTJhZDlkYWNmMzQ2Zjg2MWQxMzc2NGVmNGUz
ZWQxMGUzMTBdIHg4Njoga2FzbHI6IHJlcG9ydCBrZXJuZWwgb2Zmc2V0IG9uIHBhbmljCmdp
dCBiaXNlY3QgcnVuIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2ggL2hvbWUvd2ZnL3NvdW5kL29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9zb3VuZC9vYmotYmlzZWN0
CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1o
MDA0LTA2MjMvbGludXgtZGV2ZWw6ZGV2ZWwtaGl2ZS14ODZfNjQtMjAxMzA2MjMxMjM2Ojc2
YmYwZTJhZDlkYWNmMzQ2Zjg2MWQxMzc2NGVmNGUzZWQxMGUzMTA6YmlzZWN0LXNvdW5kCgoy
MDEzLTA2LTIzLTEzOjQzOjU1IDc2YmYwZTJhZDlkYWNmMzQ2Zjg2MWQxMzc2NGVmNGUzZWQx
MGUzMTAgY29tcGlsaW5nCjM2NCByZWFsICAyMTg1IHVzZXIgIDE5MCBzeXMgIDY1MS4zMyUg
Y3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1oMDA0LTA2MjMKODAxMjIgYmxvY2tzCgoyMDEzLTA2
LTIzLTEzOjU0OjExIGRldGVjdGluZyBib290IHN0YXRlIDMuMTAuMC1yYzYtMDAxNDItZzc2
YmYwZTIuCTgJMTYJMTkJMjcgVEVTVCBGQUlMVVJFChtbMTszNW1JbmNyZWFzaW5nIHJlcGVh
dCBjb3VudCBmcm9tIDkwIHRvIDE2MBtbMG0KZG1lc2cta3ZtLXZwLTYwMzItMjAxMzA2MjMx
MzU3MzUtMy4xMC4wLXJjNi0wMDE0Mi1nNzZiZjBlMi05MgoKQmlzZWN0aW5nOiAyIHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAyIHN0ZXBzKQpbYTZjMjFh
MGIzMTg1YmNjNTQ5OTY4MTkxNTc3MzUzOTgxNDBhNjc0Zl0geDg2OiBrYXNscjogcmV0dXJu
IGxvY2F0aW9uIGZyb20gZGVjb21wcmVzc19rZXJuZWwKcnVubmluZyAvYy9rZXJuZWwtdGVz
dHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9zb3VuZC9vYmotYmlz
ZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZp
Zy1oMDA0LTA2MjMvbGludXgtZGV2ZWw6ZGV2ZWwtaGl2ZS14ODZfNjQtMjAxMzA2MjMxMjM2
OmE2YzIxYTBiMzE4NWJjYzU0OTk2ODE5MTU3NzM1Mzk4MTQwYTY3NGY6YmlzZWN0LXNvdW5k
CgoyMDEzLTA2LTIzLTEzOjU2OjQ0IGE2YzIxYTBiMzE4NWJjYzU0OTk2ODE5MTU3NzM1Mzk4
MTQwYTY3NGYgY29tcGlsaW5nCjMxIHJlYWwgIDEzOCB1c2VyICAyMiBzeXMgIDUxMS41NSUg
Y3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1oMDA0LTA2MjMKODAxMjIgYmxvY2tzCgoyMDEzLTA2
LTIzLTEzOjU4OjI0IGRldGVjdGluZyBib290IHN0YXRlIDMuMTAuMC1yYzYtMDAxMzktZ2E2
YzIxYTAuLgkxMQkzMAkzNwk0Ngk1Mwk1OAk2Ngk3NQk3OQk4NAk5NgkxMDgJMTE0CTEyNAkx
MjYJMTI3CTEzMQkxMzkJMTQ0CTE0OAkxNTUJMTU4CTE1OS4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLgkxNjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3Qg
YWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0ZXApCltjMWJhYmU3ZWMzMDBhZjI5M2NmMjcxNmYw
MzdhOTM1ZTZiYjgxYTk0XSB4ODY6IGthc2xyOiBzZWxlY3QgbWVtb3J5IHJlZ2lvbiBmcm9t
IGU4MjAgbWFwcwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2hvbWUvd2ZnL3NvdW5kL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWgwMDQtMDYyMy9saW51eC1kZXZl
bDpkZXZlbC1oaXZlLXg4Nl82NC0yMDEzMDYyMzEyMzY6YzFiYWJlN2VjMzAwYWYyOTNjZjI3
MTZmMDM3YTkzNWU2YmI4MWE5NDpiaXNlY3Qtc291bmQKCjIwMTMtMDYtMjMtMTQ6MjM6MjYg
YzFiYWJlN2VjMzAwYWYyOTNjZjI3MTZmMDM3YTkzNWU2YmI4MWE5NCBjb21waWxpbmcKMTg3
IHJlYWwgIDEzNyB1c2VyICAyMSBzeXMgIDg1LjEwJSBjcHUgCXg4Nl82NC1yYW5kY29uZmln
LWgwMDQtMDYyMwo4MDEyMiBibG9ja3MKCjIwMTMtMDYtMjMtMTQ6Mjc6MzggZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgMy4xMC4wLXJjNi0wMDE0MS1nYzFiYWJlNy4JMgkyMgk0OCBURVNUIEZB
SUxVUkUKZG1lc2cta3ZtLXZwLTUxMTItMjAxMzA2MjMxNDI5NDktMy4xMC4wLXJjNi0wMDE0
MS1nYzFiYWJlNy05NApkbWVzZy1rdm0tdnAtMTU2MjItMjAxMzA2MjMxNDMwMzEtMy4xMC4w
LXJjNi0wMDE0MS1nYzFiYWJlNy05NApkbWVzZy1rdm0tbGtwLXNieDA0LTYyNjE5LTIwMTMw
NjIzMTgzMjU2LTMuMTAuMC1yYzYtMDAxNDEtZ2MxYmFiZTctOTQKZG1lc2cta3ZtLWxrcC1u
ZXgwNC0zMzQzNC0yMDEzMDYyMzE0MzAyNC0zLjEwLjAtcmM2LTAwMTQxLWdjMWJhYmU3LTk0
CgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3Vn
aGx5IDAgc3RlcHMpCls1N2ZhNGFmMDYzNWQzMGIyMDYxMzc3YWFiODcwOTQ3NjJmYmMzMzcz
XSB4ODY6IGthc2xyOiBzZWxlY3QgcmFuZG9tIGJhc2Ugb2Zmc2V0CnJ1bm5pbmcgL2Mva2Vy
bmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcvc291bmQv
b2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJh
bmRjb25maWctaDAwNC0wNjIzL2xpbnV4LWRldmVsOmRldmVsLWhpdmUteDg2XzY0LTIwMTMw
NjIzMTIzNjo1N2ZhNGFmMDYzNWQzMGIyMDYxMzc3YWFiODcwOTQ3NjJmYmMzMzczOmJpc2Vj
dC1zb3VuZAoKMjAxMy0wNi0yMy0xNDoyOTozOSA1N2ZhNGFmMDYzNWQzMGIyMDYxMzc3YWFi
ODcwOTQ3NjJmYmMzMzczIGNvbXBpbGluZwoxNDAgcmVhbCAgMTQwIHVzZXIgIDIxIHN5cyAg
MTE1Ljc0JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLWgwMDQtMDYyMwo4MDEyMiBibG9ja3MK
CjIwMTMtMDYtMjMtMTQ6MzI6MjkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMC4wLXJjNi0w
MDE0MC1nNTdmYTRhZi4JMwkxMSBURVNUIEZBSUxVUkUKZG1lc2cta3ZtLWxrcC1uZXgwNC0z
NDAzMS0yMDEzMDYyMzE0MzQzMy0zLjEwLjAtcmM2LTAwMTQwLWc1N2ZhNGFmLTk1Cgo1N2Zh
NGFmMDYzNWQzMGIyMDYxMzc3YWFiODcwOTQ3NjJmYmMzMzczIGlzIHRoZSBmaXJzdCBiYWQg
Y29tbWl0CmNvbW1pdCA1N2ZhNGFmMDYzNWQzMGIyMDYxMzc3YWFiODcwOTQ3NjJmYmMzMzcz
CkF1dGhvcjogS2VlcyBDb29rIDxrZWVzY29va0BjaHJvbWl1bS5vcmc+CkRhdGU6ICAgVHVl
IEFwciAyMyAxNzoxODozOCAyMDEzIC0wNzAwCgogICAgeDg2OiBrYXNscjogc2VsZWN0IHJh
bmRvbSBiYXNlIG9mZnNldAogICAgCiAgICBTZWxlY3QgYSByYW5kb20gbG9jYXRpb24gd2hl
biBDT05GSUdfUkFORE9NSVpFX0JBU0UgaXMgdXNlZCwgYm91bmRlZAogICAgYnkgQ09ORklH
X1JBTkRPTUlaRV9CQVNFX01BWF9PRkZTRVQuIFNvdXJjZXMgb2YgcmFuZG9tbmVzcyBjdXJy
ZW50bHkKICAgIGluY2x1ZGUgUkRSQU5ELCBSRFRTQywgb3IgdGhlIGk4MjU0LgogICAgCiAg
ICBTaWduZWQtb2ZmLWJ5OiBLZWVzIENvb2sgPGtlZXNjb29rQGNocm9taXVtLm9yZz4KICAg
IC0tLQogICAgdjM6CiAgICAgLSBmYWxsIGJhY2sgdG8gcmVhZGluZyB0aGUgaTgyNTQgd2hl
biBubyBUU0MsIHN1Z2dlc3RlZCBieSBIUEEuCiAgICB2MjoKICAgICAtIHVzZSByZHRzY2wg
ZnJvbSBtc3IuaCwgdGhhbmtzIHRvIE1hdGhpYXMgS3JhdXNlLgoKOjA0MDAwMCAwNDAwMDAg
ODZlZmU5YTgyOTAxY2MzOGM1NzNmMDEyOTk3OWQ3ZDg2NTE1Y2I3NCA4NjFkMTJlZDViNDQx
MzFjOWI5Y2NmYjkzOGVmYmEzOWU2MDNkODE1IE0JYXJjaApiaXNlY3QgcnVuIHN1Y2Nlc3MK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWgw
MDQtMDYyMy9saW51eC1kZXZlbDpkZXZlbC1oaXZlLXg4Nl82NC0yMDEzMDYyMzEyMzY6YTZj
MjFhMGIzMTg1YmNjNTQ5OTY4MTkxNTc3MzUzOTgxNDBhNjc0ZjpiaXNlY3Qtc291bmQKCjIw
MTMtMDYtMjMtMTQ6MzQ6MDEgYTZjMjFhMGIzMTg1YmNjNTQ5OTY4MTkxNTc3MzUzOTgxNDBh
Njc0ZiByZXVzZSAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWgwMDQtMDYyMy9hNmMyMWEw
YjMxODViY2M1NDk5NjgxOTE1NzczNTM5ODE0MGE2NzRmL3ZtbGludXotMy4xMC4wLXJjNi0w
MDEzOS1nYTZjMjFhMAoKMjAxMy0wNi0yMy0xNDozNDowMSBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAJMTYxCTE2MwkxNzgJMTg0CTE5NAkyMDMJMjA3CTIyMAkyMzYJMjQ5CTI1MwkyNzcJMjg0
CTI5OAkzMDUJMzE0CTMzMQkzNDIJMzUyCTM1OQkzNzcJMzk2CTQxOAk0MzAJNDQ5CTQ2Mwk0
NzAJNDc4Lgk0NzkJNDgwIFNVQ0NFU1MKCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oMDA0LTA2MjMvbGludXgtZGV2ZWw6ZGV2ZWwtaGl2
ZS14ODZfNjQtMjAxMzA2MjMxMjM2OjcyOGM2ODE3ODNhOGUwYjhhMGRjNWRmNDQwNTAzYzUx
YmJhYTk3ODk6YmlzZWN0LXNvdW5kCiBURVNUIEZBSUxVUkUKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1oMDA0LTA2MjMvNzI4YzY4MTc4M2E4ZTBiOGEwZGM1ZGY0NDA1MDNjNTFiYmFh
OTc4OS9kbWVzZy1rdm0taW5uLTQ2MzItMjAxMzA2MjMxMzM3MTYtMy4xMC4wLXJjNy0wMDAx
Mi1nNzI4YzY4MS0zCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaDAwNC0wNjIzLzcyOGM2
ODE3ODNhOGUwYjhhMGRjNWRmNDQwNTAzYzUxYmJhYTk3ODkvZG1lc2cta3ZtLWxrcC1zYngw
NC02MzI4LTIwMTMwNjIzMTc0NTUzLTMuMTAuMC1yYzctMDAwMTItZzcyOGM2ODEtMwova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWgwMDQtMDYyMy83MjhjNjgxNzgzYThlMGI4YTBkYzVk
ZjQ0MDUwM2M1MWJiYWE5Nzg5L2RtZXNnLWt2bS1yb2FtLTE5NDI4LTIwMTMwNjIzMTI1NjA1
LTMuMTAuMC1yYzctMDAwMTItZzcyOGM2ODEtMwoKSEVBRCBpcyBub3cgYXQgNzI4YzY4MSBN
ZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdrZWVzL3N0cm5jcHktc3RybGVuJyBpbnRv
IGRldmVsLWhpdmUteDg2XzY0LTIwMTMwNjIzMTIzNgoKPT09PT09PT09IHVwc3RyZWFtID09
PT09PT09PQpGZXRjaGluZyBsaW51cwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0veDg2XzY0LXJhbmRjb25maWctaDAwNC0wNjIzL2xpbnV4LWRldmVsOmRldmVsLWhpdmUt
eDg2XzY0LTIwMTMwNjIzMTIzNjo5ZTg5NWFjZTVkODJkZjg5MjliMTZmNThlOWY1MTVmNmQ1
NGFiODJkOmJpc2VjdC1zb3VuZAoKMjAxMy0wNi0yMy0xNDo0OTozNyA5ZTg5NWFjZTVkODJk
Zjg5MjliMTZmNThlOWY1MTVmNmQ1NGFiODJkIHJldXNlIC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaDAwNC0wNjIzLzllODk1YWNlNWQ4MmRmODkyOWIxNmY1OGU5ZjUxNWY2ZDU0YWI4
MmQvdm1saW51ei0zLjEwLjAtcmM3CgoyMDEzLTA2LTIzLTE0OjQ5OjM4IGRldGVjdGluZyBi
b290IHN0YXRlIC4JOTEJOTUJMTA0CTExMwkxMTYJMTE5CTEyMC4JMTIzCTEyNQkxMjYJMTMw
CTEzNAkxNDEJMTQ2CTE1NQkxNjAJMTY0CTE3MAkxNzYJMTg2CTIwMAkyMDMJMjA4CTIxNwky
MzYJMjQ5CTI1MwkyNjMJMjczCTI3OQkyODcJMjkxCTI5OAkzMDUJMzE3CTMyMwkzMjYJMzM0
CTM0MwkzNTAJMzU1CTM1OAkzNjgJMzc1CTM3OAkzODUJMzk0CTM5Nwk0MTIJNDIzCTQzOAk0
NDYJNDU1CTQ2Mwk0NjgJNDc0CTQ3OS4uLi4uLi4JNDgwIFNVQ0NFU1MKCgo9PT09PT09PT0g
bGludXgtbmV4dCA9PT09PT09PT0KRmV0Y2hpbmcgbmV4dApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaDAwNC0wNjIzL2xpbnV4LWRldmVs
OmRldmVsLWhpdmUteDg2XzY0LTIwMTMwNjIzMTIzNjplMWE4NjU3ODc0NzM3NmYwODk4NTYy
N2M4NGRmMDg4YTVkMGQxZTkyOmJpc2VjdC1zb3VuZAoKMjAxMy0wNi0yMy0xNToyMzoxNCBl
MWE4NjU3ODc0NzM3NmYwODk4NTYyN2M4NGRmMDg4YTVkMGQxZTkyIGNvbXBpbGluZwoKMjAx
My0wNi0yMy0xNTozNTozMCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEwLjAtcmM2LW5leHQt
MjAxMzA2MjEtMDgwMjEtZ2UxYTg2NTcuLgkxNAkzMQk0Ngk2MQk3OQk5NwkxMDMJMTE2CTEy
NwkxNDEJMTUzCTE3MQkxODQJMjA1CTIzMAkyNDEJMjU4CTI3MQkyOTUJMzA2CTMxNgkzNDAJ
MzUyCTM3OAkzOTAJNDA2CTQyOQk0NDIJNDU3CTQ2OQk0NzMJNDc4Li4uLgk0NzkuLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JNDgwIFNVQ0NFU1MKCg==

--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.10.0-rc7 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
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
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set
CONFIG_AUDIT_LOGINUID_IMMUTABLE=y
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_STALL_COMMON is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
CONFIG_CGROUP_HUGETLB=y
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HOTPLUG=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
# CONFIG_JUMP_LABEL is not set
CONFIG_UPROBES=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_USER_RETURN_NOTIFIER=y
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
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_RELA=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y

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
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
CONFIG_MPSC=y
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=7
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_I8K=m
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
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
CONFIG_RANDOMIZE_BASE=y
CONFIG_RANDOMIZE_BASE_MAX_OFFSET=0x10000000
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_ACPI=y
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
CONFIG_ACPI_I2C=y
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
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
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
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=m
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
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_BINFMT_SCRIPT is not set
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
# CONFIG_IA32_EMULATION is not set
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=m
CONFIG_NET_IPGRE=m
# CONFIG_NET_IPGRE_BROADCAST is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
# CONFIG_INET_UDP_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_ACCT=y
CONFIG_NETFILTER_NETLINK_QUEUE=m
# CONFIG_NETFILTER_NETLINK_LOG is not set
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
# CONFIG_NF_CONNTRACK_PROCFS is not set
# CONFIG_NF_CONNTRACK_EVENTS is not set
# CONFIG_NF_CONNTRACK_TIMEOUT is not set
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CONNTRACK_LABELS=y
# CONFIG_NF_CT_PROTO_DCCP is not set
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
# CONFIG_NF_CONNTRACK_SNMP is not set
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
# CONFIG_NF_CONNTRACK_TFTP is not set
# CONFIG_NF_CT_NETLINK is not set
CONFIG_NF_CT_NETLINK_TIMEOUT=m
CONFIG_NETFILTER_NETLINK_QUEUE_CT=y
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=y
CONFIG_NETFILTER_XT_CONNMARK=m

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_AUDIT is not set
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
# CONFIG_NETFILTER_XT_TARGET_CONNMARK is not set
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_HMARK=y
# CONFIG_NETFILTER_XT_TARGET_IDLETIMER is not set
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_LOG=y
CONFIG_NETFILTER_XT_TARGET_MARK=y
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
# CONFIG_NETFILTER_XT_TARGET_SECMARK is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_BPF=y
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
# CONFIG_NETFILTER_XT_MATCH_CONNLIMIT is not set
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
# CONFIG_NETFILTER_XT_MATCH_CONNTRACK is not set
CONFIG_NETFILTER_XT_MATCH_CPU=y
CONFIG_NETFILTER_XT_MATCH_DCCP=y
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=y
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
CONFIG_NETFILTER_XT_MATCH_ECN=y
CONFIG_NETFILTER_XT_MATCH_ESP=y
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=y
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
# CONFIG_NETFILTER_XT_MATCH_IPVS is not set
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
CONFIG_NETFILTER_XT_MATCH_MAC=y
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_NFACCT=y
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=y
# CONFIG_NETFILTER_XT_MATCH_STATE is not set
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=y
CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_TIME=y
CONFIG_NETFILTER_XT_MATCH_U32=m
# CONFIG_IP_SET is not set
CONFIG_IP_VS=m
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
# CONFIG_IP_VS_PROTO_TCP is not set
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
# CONFIG_IP_VS_PROTO_AH is not set
# CONFIG_IP_VS_PROTO_SCTP is not set

#
# IPVS scheduler
#
# CONFIG_IP_VS_RR is not set
# CONFIG_IP_VS_WRR is not set
# CONFIG_IP_VS_LC is not set
CONFIG_IP_VS_WLC=m
# CONFIG_IP_VS_LBLC is not set
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
# CONFIG_IP_VS_SED is not set
CONFIG_IP_VS_NQ=m

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
# CONFIG_IP_NF_IPTABLES is not set
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
# CONFIG_IP_NF_ARP_MANGLE is not set

#
# DECnet: Netfilter Configuration
#
# CONFIG_DECNET_NF_GRABULATOR is not set
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration
#
CONFIG_IP_DCCP_CCID2_DEBUG=y
# CONFIG_IP_DCCP_CCID3 is not set

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_MSG=y
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE=y
CONFIG_SCTP_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_COOKIE_HMAC_SHA1 is not set
CONFIG_RDS=m
# CONFIG_RDS_TCP is not set
# CONFIG_RDS_DEBUG is not set
CONFIG_TIPC=m
CONFIG_TIPC_PORTS=8191
# CONFIG_ATM is not set
CONFIG_L2TP=m
# CONFIG_L2TP_DEBUGFS is not set
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=y
# CONFIG_BRIDGE is not set
CONFIG_VLAN_8021Q=m
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_VLAN_8021Q_MVRP is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
CONFIG_X25=y
CONFIG_LAPB=m
# CONFIG_PHONET is not set
CONFIG_IEEE802154=m
# CONFIG_MAC802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_PRIO=y
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=m
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=m
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=y
CONFIG_NET_SCH_CODEL=y
CONFIG_NET_SCH_FQ_CODEL=m
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
CONFIG_NET_CLS_FW=y
# CONFIG_NET_CLS_U32 is not set
CONFIG_NET_CLS_RSVP=m
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_CLS_CGROUP=m
# CONFIG_NET_EMATCH is not set
# CONFIG_NET_CLS_ACT is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=m
CONFIG_BATMAN_ADV=m
CONFIG_BATMAN_ADV_BLA=y
CONFIG_BATMAN_ADV_DAT=y
# CONFIG_BATMAN_ADV_NC is not set
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=y
CONFIG_BPF_JIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
CONFIG_NET_DROP_MONITOR=m
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
# CONFIG_AX25_DAMA_SLAVE is not set
# CONFIG_NETROM is not set
CONFIG_ROSE=m

#
# AX.25 network device drivers
#
CONFIG_MKISS=y
CONFIG_6PACK=m
CONFIG_BPQETHER=y
# CONFIG_BAYCOM_SER_FDX is not set
CONFIG_BAYCOM_SER_HDX=y
CONFIG_BAYCOM_PAR=y
CONFIG_YAM=y
CONFIG_CAN=m
CONFIG_CAN_RAW=m
# CONFIG_CAN_BCM is not set
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
CONFIG_CAN_SLCAN=m
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
# CONFIG_BT_RFCOMM is not set
# CONFIG_BT_BNEP is not set
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
# CONFIG_BT_HCIUART_BCSP is not set
# CONFIG_BT_HCIUART_ATH3K is not set
CONFIG_BT_HCIUART_LL=y
# CONFIG_BT_HCIUART_3WIRE is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
CONFIG_BT_HCIBFUSB=m
# CONFIG_BT_HCIDTL1 is not set
CONFIG_BT_HCIBT3C=m
# CONFIG_BT_HCIBLUECARD is not set
# CONFIG_BT_HCIBTUART is not set
# CONFIG_BT_HCIVHCI is not set
CONFIG_BT_MRVL=m
CONFIG_AF_RXRPC=m
# CONFIG_AF_RXRPC_DEBUG is not set
# CONFIG_RXKAD is not set
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_REGULATOR=m
# CONFIG_NET_9P is not set
CONFIG_CAIF=m
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=m
# CONFIG_CAIF_USB is not set
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
CONFIG_NFC=m
# CONFIG_NFC_NCI is not set
# CONFIG_NFC_HCI is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN533=m
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
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
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
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
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
CONFIG_BLK_DEV_DRBD=m
CONFIG_DRBD_FAULT_INJECTION=y
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_NVME is not set
CONFIG_BLK_DEV_OSD=m
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=m
CONFIG_BLK_DEV_HD=y
CONFIG_BLK_DEV_RBD=y
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
CONFIG_AD525X_DPOT=m
# CONFIG_AD525X_DPOT_I2C is not set
CONFIG_AD525X_DPOT_SPI=m
CONFIG_DUMMY_IRQ=m
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
CONFIG_ATMEL_SSC=m
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=m
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
CONFIG_DS1682=m
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
CONFIG_BMP085_SPI=y
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=m
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=m
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
# CONFIG_IDE_GD is not set
CONFIG_BLK_DEV_IDECS=m
# CONFIG_BLK_DEV_DELKIN is not set
# CONFIG_BLK_DEV_IDECD is not set
CONFIG_BLK_DEV_IDETAPE=m
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set

#
# PCI IDE chipsets support
#
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
# CONFIG_BLK_DEV_IDEDMA is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=m
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
CONFIG_SCSI_FC_ATTRS=m
# CONFIG_SCSI_FC_TGT_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
CONFIG_SCSI_DH=m
# CONFIG_SCSI_DH_RDAC is not set
CONFIG_SCSI_DH_HP_SW=m
CONFIG_SCSI_DH_EMC=m
# CONFIG_SCSI_DH_ALUA is not set
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
# CONFIG_MD_MULTIPATH is not set
CONFIG_MD_FAULTY=m
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
# CONFIG_DM_CRYPT is not set
CONFIG_DM_SNAPSHOT=m
# CONFIG_DM_THIN_PROVISIONING is not set
CONFIG_DM_CACHE=m
# CONFIG_DM_CACHE_MQ is not set
CONFIG_DM_CACHE_CLEANER=m
# CONFIG_DM_MIRROR is not set
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
# CONFIG_DM_FLAKEY is not set
# CONFIG_DM_VERITY is not set
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
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
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
# CONFIG_NETDEVICES is not set
CONFIG_VHOST_NET=m
CONFIG_VHOST_SCSI=m
CONFIG_VHOST_RING=m

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
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=y
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
CONFIG_KEYBOARD_QT2160=y
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_TCA6416=m
CONFIG_KEYBOARD_TCA8418=m
# CONFIG_KEYBOARD_LM8323 is not set
CONFIG_KEYBOARD_LM8333=m
CONFIG_KEYBOARD_MAX7359=y
CONFIG_KEYBOARD_MCS=m
CONFIG_KEYBOARD_MPR121=y
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_STMPE=y
CONFIG_KEYBOARD_TC3589X=y
CONFIG_KEYBOARD_XTKBD=m
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=m
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
CONFIG_JOYSTICK_SIDEWINDER=m
CONFIG_JOYSTICK_TMDC=m
CONFIG_JOYSTICK_IFORCE=y
# CONFIG_JOYSTICK_IFORCE_USB is not set
# CONFIG_JOYSTICK_IFORCE_232 is not set
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=y
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=y
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=y
# CONFIG_JOYSTICK_GAMECON is not set
CONFIG_JOYSTICK_TURBOGRAFX=y
CONFIG_JOYSTICK_AS5011=y
# CONFIG_JOYSTICK_JOYDUMP is not set
CONFIG_JOYSTICK_XPAD=m
# CONFIG_JOYSTICK_XPAD_FF is not set
# CONFIG_JOYSTICK_XPAD_LEDS is not set
CONFIG_JOYSTICK_WALKERA0701=m
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=y
CONFIG_TABLET_USB_GTCO=y
# CONFIG_TABLET_USB_HANWANG is not set
CONFIG_TABLET_USB_KBTAB=m
CONFIG_TABLET_USB_WACOM=m
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=m
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=m
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
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
CONFIG_N_HDLC=m
CONFIG_N_GSM=y
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set
# CONFIG_STALDRV is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DW=m

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=m
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=m
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=m
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
# CONFIG_IPMI_WATCHDOG is not set
# CONFIG_IPMI_POWEROFF is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_R3964=m
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
# CONFIG_CARDMAN_4000 is not set
CONFIG_CARDMAN_4040=m
CONFIG_MWAVE=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
# CONFIG_I2C_MUX is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
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
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
CONFIG_I2C_PARPORT=y
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=m
CONFIG_I2C_VIPERBOARD=m

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
CONFIG_SPI_LM70_LLP=y
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=y
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_XCOMM=y
CONFIG_SPI_XILINX=y
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=m
CONFIG_SPI_TLE62X0=m

#
# Qualcomm MSM SSBI bus support
#
CONFIG_SSBI=m
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=m

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
CONFIG_PPS_CLIENT_LDISC=m
# CONFIG_PPS_CLIENT_PARPORT is not set
# CONFIG_PPS_CLIENT_GPIO is not set

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
# CONFIG_GPIOLIB is not set
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_DS1WM=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=m
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=m
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
CONFIG_GENERIC_ADC_BATTERY=m
CONFIG_WM8350_POWER=y
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_88PM860X is not set
CONFIG_BATTERY_DS2760=m
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=m
CONFIG_BATTERY_DS2782=m
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=m
CONFIG_BATTERY_BQ27X00_I2C=y
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
CONFIG_BATTERY_DA9030=m
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_CHARGER_PCF50633=m
# CONFIG_CHARGER_ISP1704 is not set
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_LP8727=y
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_BQ2415X=m
CONFIG_CHARGER_SMB347=y
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7314=m
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADCXX=m
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=y
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IIO_HWMON=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=m
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=m
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=m
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=m
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_MAX1111=m
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=y
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX34440 is not set
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_ADS7871=m
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP401=m
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=m
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM8350=m
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=m
# CONFIG_WATCHDOG is not set
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
CONFIG_SSB_PCMCIAHOST=y
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_88PM800=m
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=m
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
CONFIG_STMPE_SPI=y
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=m
CONFIG_TPS6507X=m
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=m
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=m
# CONFIG_MFD_LM3533 is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_AD5398=m
CONFIG_REGULATOR_DA903X=m
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_FAN53555=m
CONFIG_REGULATOR_MC13XXX_CORE=m
CONFIG_REGULATOR_MC13783=m
CONFIG_REGULATOR_MC13892=m
CONFIG_REGULATOR_ISL6271A=m
# CONFIG_REGULATOR_88PM8607 is not set
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=m
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_LP3971=m
CONFIG_REGULATOR_LP3972=m
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=m
CONFIG_REGULATOR_PCF50633=m
CONFIG_REGULATOR_PALMAS=y
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS6105X=m
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65217=m
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_TPS80031=m
CONFIG_REGULATOR_WM8350=y
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=m
CONFIG_DRM_USB=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_LOAD_EDID_FIRMWARE=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=m
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
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
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
CONFIG_FB_HGA=m
CONFIG_FB_S1D13XXX=y
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
CONFIG_FB_SMSCUFX=m
CONFIG_FB_UDL=m
# CONFIG_FB_GOLDFISH is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=m
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
# CONFIG_FB_AUO_K1900 is not set
CONFIG_FB_AUO_K1901=y
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI922X is not set
CONFIG_LCD_ILI9320=m
CONFIG_LCD_TDO24M=m
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=m
# CONFIG_LCD_S6E63M0 is not set
CONFIG_LCD_LD9040=m
CONFIG_LCD_AMS369FG06=m
# CONFIG_LCD_LMS501KF03 is not set
# CONFIG_LCD_HX8357 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_PWM=y
# CONFIG_BACKLIGHT_DA903X is not set
CONFIG_BACKLIGHT_DA9052=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=m
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
# CONFIG_BACKLIGHT_88PM860X is not set
# CONFIG_BACKLIGHT_PCF50633 is not set
# CONFIG_BACKLIGHT_LM3630 is not set
CONFIG_BACKLIGHT_LM3639=m
CONFIG_BACKLIGHT_LP855X=m
# CONFIG_BACKLIGHT_TPS65217 is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=m
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_FONTS=y
# CONFIG_FONT_8x8 is not set
CONFIG_FONT_8x16=y
# CONFIG_FONT_6x11 is not set
CONFIG_FONT_7x14=y
CONFIG_FONT_PEARL_8x8=y
CONFIG_FONT_ACORN_8x8=y
# CONFIG_FONT_MINI_4x6 is not set
# CONFIG_FONT_SUN8x16 is not set
CONFIG_FONT_SUN12x22=y
CONFIG_FONT_10x18=y
# CONFIG_LOGO is not set
CONFIG_SOUND=m
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
# CONFIG_HID_APPLEIR is not set
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=m
CONFIG_HID_ELECOM=m
CONFIG_HID_EZKEY=y
CONFIG_HID_HOLTEK=m
# CONFIG_HOLTEK_FF is not set
CONFIG_HID_KEYTOUCH=y
# CONFIG_HID_KYE is not set
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LENOVO_TPKBD=m
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=m
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=m
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_NTRIG=m
CONFIG_HID_ORTEK=y
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=y
CONFIG_HID_PS3REMOTE=m
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SONY=m
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=y
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_HID_SENSOR_HUB=m

#
# USB HID support
#
CONFIG_USB_HID=m
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
CONFIG_I2C_HID=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_MON=m
CONFIG_USB_WUSB_CBAF=m
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
# CONFIG_USB_XHCI_HCD is not set
# CONFIG_USB_EHCI_HCD is not set
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_ISP1362_HCD=y
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_SL811_HCD=y
CONFIG_USB_SL811_HCD_ISO=y
CONFIG_USB_SL811_CS=m
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_RENESAS_USBHS_HCD=m
CONFIG_USB_HCD_SSB=m
# CONFIG_USB_MUSB_HDRC is not set
CONFIG_USB_RENESAS_USBHS=m

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=m
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
CONFIG_USB_STORAGE_DEBUG=y
CONFIG_USB_STORAGE_REALTEK=m
CONFIG_REALTEK_AUTOPM=y
# CONFIG_USB_STORAGE_DATAFAB is not set
CONFIG_USB_STORAGE_FREECOM=m
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
# CONFIG_USB_STORAGE_SDDR55 is not set
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
# CONFIG_USB_STORAGE_ENE_UB6250 is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
CONFIG_USB_MICROTEK=m
# CONFIG_USB_DWC3 is not set
CONFIG_USB_CHIPIDEA=y
CONFIG_USB_CHIPIDEA_DEBUG=y

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_LED=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=m
CONFIG_USB_IDMOUSE=m
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_LD=m
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=m
CONFIG_USB_ISIGHTFW=m
CONFIG_USB_YUREX=m
CONFIG_USB_EZUSB_FX2=m
# CONFIG_USB_HSIC_USB3503 is not set
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=m
CONFIG_OMAP_CONTROL_USB=y
CONFIG_OMAP_USB3=y
CONFIG_SAMSUNG_USBPHY=m
CONFIG_SAMSUNG_USB2PHY=m
# CONFIG_SAMSUNG_USB3PHY is not set
CONFIG_USB_ISP1301=y
# CONFIG_USB_RCAR_PHY is not set
CONFIG_USB_GADGET=m
CONFIG_USB_GADGET_DEBUG=y
CONFIG_USB_GADGET_DEBUG_FILES=y
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_R8A66597=m
CONFIG_USB_RENESAS_USBHS_UDC=m
# CONFIG_USB_PXA27X is not set
# CONFIG_USB_MV_UDC is not set
# CONFIG_USB_MV_U3D is not set
CONFIG_USB_M66592=m
# CONFIG_USB_AMD5536UDC is not set
CONFIG_USB_NET2272=m
# CONFIG_USB_NET2272_DMA is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
CONFIG_USB_DUMMY_HCD=m
CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_F_ACM=m
CONFIG_USB_U_SERIAL=m
# CONFIG_USB_ZERO is not set
# CONFIG_USB_ETH is not set
CONFIG_USB_G_NCM=m
CONFIG_USB_GADGETFS=m
CONFIG_USB_FUNCTIONFS=m
# CONFIG_USB_FUNCTIONFS_ETH is not set
CONFIG_USB_FUNCTIONFS_RNDIS=y
CONFIG_USB_FUNCTIONFS_GENERIC=y
CONFIG_USB_MASS_STORAGE=m
CONFIG_USB_GADGET_TARGET=m
# CONFIG_USB_G_SERIAL is not set
CONFIG_USB_G_PRINTER=m
# CONFIG_USB_CDC_COMPOSITE is not set
CONFIG_USB_G_ACM_MS=m
# CONFIG_USB_G_MULTI is not set
CONFIG_USB_G_HID=m
# CONFIG_USB_G_DBGP is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_88PM860X is not set
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=m
CONFIG_LEDS_CLEVO_MAIL=y
CONFIG_LEDS_PCA955X=m
# CONFIG_LEDS_PCA9633 is not set
# CONFIG_LEDS_WM8350 is not set
CONFIG_LEDS_DA903X=m
CONFIG_LEDS_DA9052=m
# CONFIG_LEDS_DAC124S085 is not set
CONFIG_LEDS_PWM=y
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=m
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_LM355x=m
CONFIG_LEDS_OT200=y
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_MM_EDAC=m
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I7CORE is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_88PM860X is not set
CONFIG_RTC_DRV_88PM80X=m
CONFIG_RTC_DRV_DS1307=y
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_MAX6900=y
# CONFIG_RTC_DRV_MAX8907 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=m
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
CONFIG_RTC_DRV_PALMAS=y
CONFIG_RTC_DRV_PCF8523=m
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=y
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_TPS80031=y
CONFIG_RTC_DRV_S35390A=y
# CONFIG_RTC_DRV_FM3130 is not set
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=m
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
CONFIG_RTC_DRV_M41T94=m
CONFIG_RTC_DRV_DS1305=y
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
CONFIG_RTC_DRV_R9701=m
CONFIG_RTC_DRV_RS5C348=m
CONFIG_RTC_DRV_DS3234=m
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_RX4581 is not set

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DA9052=m
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=m
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=m
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_DS2404=y
CONFIG_RTC_DRV_WM8350=y
CONFIG_RTC_DRV_PCF50633=m

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MC13XXX is not set

#
# HID Sensor RTC drivers
#
CONFIG_RTC_DRV_HID_SENSOR_TIME=m
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV is not set
CONFIG_UIO_PDRV_GENIRQ=m
CONFIG_UIO_DMEM_GENIRQ=m
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=m

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MMIO=m
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set

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
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_POWERSAVE=y
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_BUFFER_CB is not set
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
# CONFIG_HID_SENSOR_ACCEL_3D is not set
CONFIG_KXSD9=m
CONFIG_IIO_ST_ACCEL_3AXIS=m
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=m
CONFIG_IIO_ST_ACCEL_SPI_3AXIS=m

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=m
CONFIG_AD7266=m
# CONFIG_AD7298 is not set
CONFIG_AD7923=m
CONFIG_AD7791=m
# CONFIG_AD7793 is not set
CONFIG_AD7476=m
# CONFIG_AD7887 is not set
CONFIG_MAX1363=m
# CONFIG_TI_ADC081C is not set
CONFIG_TI_AM335X_ADC=m
# CONFIG_VIPERBOARD_ADC is not set

#
# Amplifiers
#
CONFIG_AD8366=m

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
# CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS is not set
CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_SPI=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Digital to analog converters
#
CONFIG_AD5064=m
# CONFIG_AD5360 is not set
# CONFIG_AD5380 is not set
# CONFIG_AD5421 is not set
# CONFIG_AD5624R_SPI is not set
# CONFIG_AD5446 is not set
CONFIG_AD5449=m
# CONFIG_AD5504 is not set
CONFIG_AD5755=m
CONFIG_AD5764=m
# CONFIG_AD5791 is not set
# CONFIG_AD5686 is not set
# CONFIG_MAX517 is not set
CONFIG_MCP4725=m

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=m

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=m

#
# Digital gyroscope sensors
#
CONFIG_ADIS16080=m
# CONFIG_ADIS16136 is not set
CONFIG_ADXRS450=m
CONFIG_HID_SENSOR_GYRO_3D=m
CONFIG_IIO_ST_GYRO_3AXIS=m
CONFIG_IIO_ST_GYRO_I2C_3AXIS=m
CONFIG_IIO_ST_GYRO_SPI_3AXIS=m
CONFIG_ITG3200=m

#
# Inertial measurement units
#
CONFIG_ADIS16400=m
# CONFIG_ADIS16480 is not set
CONFIG_IIO_ADIS_LIB=m
CONFIG_IIO_ADIS_LIB_BUFFER=y
# CONFIG_INV_MPU6050_IIO is not set

#
# Light sensors
#
CONFIG_ADJD_S311=m
CONFIG_SENSORS_TSL2563=m
CONFIG_VCNL4000=m
CONFIG_HID_SENSOR_ALS=m

#
# Magnetometer sensors
#
CONFIG_HID_SENSOR_MAGNETOMETER_3D=m
CONFIG_IIO_ST_MAGN_3AXIS=m
CONFIG_IIO_ST_MAGN_I2C_3AXIS=m
CONFIG_IIO_ST_MAGN_SPI_3AXIS=m
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_IPACK_BUS=m
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=m
CONFIG_RESET_CONTROLLER=y

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=m
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
# CONFIG_GOOGLE_SMI is not set
CONFIG_GOOGLE_MEMCONSOLE=m

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=m
# CONFIG_EXT4_FS_POSIX_ACL is not set
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
# CONFIG_FSNOTIFY is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=m
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V2=m
# CONFIG_NFS_V3 is not set
# CONFIG_NFS_V4 is not set
CONFIG_NFS_SWAP=y
CONFIG_NFS_DEBUG=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
# CONFIG_NFSD_V4 is not set
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_SWAP=y
# CONFIG_RPCSEC_GSS_KRB5 is not set
CONFIG_SUNRPC_DEBUG=y
# CONFIG_CEPH_FS is not set
# CONFIG_CIFS is not set
CONFIG_NCP_FS=y
CONFIG_NCPFS_PACKET_SIGNING=y
# CONFIG_NCPFS_IOCTL_LOCKING is not set
# CONFIG_NCPFS_STRONG is not set
# CONFIG_NCPFS_NFS_NS is not set
CONFIG_NCPFS_OS2_NS=y
# CONFIG_NCPFS_SMALLDOS is not set
# CONFIG_NCPFS_NLS is not set
# CONFIG_NCPFS_EXTRAS is not set
CONFIG_CODA_FS=y
CONFIG_AFS_FS=m
CONFIG_AFS_DEBUG=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=m
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
# CONFIG_NLS_UTF8 is not set
CONFIG_DLM=m
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
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
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_LKDTM is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
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
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
# CONFIG_TRACER_SNAPSHOT is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_DYNAMIC_FTRACE is not set
# CONFIG_FUNCTION_PROFILER is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
CONFIG_DYNAMIC_DEBUG=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_ASYNC_RAID6_TEST=m
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=m
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_SELINUX is not set
CONFIG_SECURITY_SMACK=y
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_YAMA_STACKED is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
# CONFIG_IMA is not set
CONFIG_EVM=y
CONFIG_EVM_HMAC_VERSION=2
# CONFIG_DEFAULT_SECURITY_SMACK is not set
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
CONFIG_DEFAULT_SECURITY_YAMA=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="yama"
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
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
CONFIG_CRYPTO_USER=m
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256_SSSE3=m
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=m
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=m
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=m
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=m
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
CONFIG_KVM_MMU_AUDIT=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
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
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_LRU_CACHE=m
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=m
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_OID_REGISTRY=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_DRM_TTM is not set
# CONFIG_ISDN_DRV_LOOP is not set
# CONFIG_PCI_ATS is not set

--ikeVEW9yuYc//A+q--
