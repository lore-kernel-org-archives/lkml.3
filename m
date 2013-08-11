Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab3HKFxp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 01:53:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:57398 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab3HKFxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 01:53:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,855,1367996400"; 
   d="log'?scan'208";a="379147138"
Date: Sun, 11 Aug 2013 13:53:22 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: fengguang.wu@intel.com, Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [cpufreq] BUG: unable to handle kernel NULL pointer dereference at
 (null)
Message-ID: <20130811055322.GA28118@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit 01e3e82efc6742d5cf7ba14fb7a9bea318b386d8
Author: Lukasz Majewski <l.majewski@samsung.com>
Date:   Tue Aug 6 22:53:08 2013 +0530

    cpufreq: Store cpufreq policies in a list
    
    Policies available in the cpufreq framework are now linked together.
    They are accessible via cpufreq_policy_list defined in the cpufreq
    core.
    
    Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
    Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>


[    2.436910] Key type encrypted registered
[    2.438327] RIO: rio_register_scan for mport_id=-1
[    2.439366] BUG: unable to handle kernel NULL pointer dereference at           (null)
[    2.440011] IP: [<ffffffff81af0a18>] __list_del_entry+0x148/0x320
[    2.440011] PGD 0 
[    2.440011] Oops: 0000 [#1] PREEMPT 
[    2.440011] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-rc4-00455-g36b054d #4
[    2.440011] task: ffff88000d848040 ti: ffff88000d84a000 task.ti: ffff88000d84a000
[    2.440011] RIP: 0010:[<ffffffff81af0a18>]  [<ffffffff81af0a18>] __list_del_entry+0x148/0x320
[    2.440011] RSP: 0000:ffff88000d84bd70  EFLAGS: 00010046
[    2.440011] RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000000000000
[    2.440011] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff84aeaaa8
[    2.440011] RBP: ffff88000d84bd98 R08: 0000000000000000 R09: 0000000000000000
[    2.440011] R10: 00000000004ee000 R11: 0000000000000002 R12: ffff88000ea24ab8
[    2.440011] R13: 0000000000000000 R14: 0000000000000000 R15: dead000000200200
[    2.440011] FS:  0000000000000000(0000) GS:ffffffff841dc000(0000) knlGS:0000000000000000
[    2.440011] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    2.440011] CR2: 0000000000000000 CR3: 00000000041bf000 CR4: 00000000000006b0
[    2.440011] Stack:
[    2.440011]  ffff88000ea24ab8 0000000000000206 ffffffff841d1a88 0000000000000000
[    2.440011]  0000000000000000 ffff88000d84bdb0 ffffffff81af0c04 ffff88000ea24a00
[    2.440011]  ffff88000d84bdd0 ffffffff82928991 ffff88000ea24a00 00000000fffffffb
[    2.440011] Call Trace:
[    2.440011]  [<ffffffff81af0c04>] list_del+0x14/0x40
[    2.440011]  [<ffffffff82928991>] cpufreq_policy_free+0x41/0x80
[    2.440011]  [<ffffffff8292a5aa>] cpufreq_add_dev+0x4ba/0x730
[    2.440011]  [<ffffffff81c85380>] subsys_interface_register+0x160/0x1b0
[    2.440011]  [<ffffffff8321398f>] ? _raw_write_unlock_irqrestore+0xcf/0x130
[    2.440011]  [<ffffffff8556c3d4>] ? cpufreq_gov_dbs_init+0x20/0x20
[    2.440011]  [<ffffffff8292c4fb>] cpufreq_register_driver+0x14b/0x2f0
[    2.440011]  [<ffffffff8556c533>] acpi_cpufreq_init+0x15f/0x33f
[    2.440011]  [<ffffffff854dba92>] do_one_initcall+0xdb/0x24e
[    2.440011]  [<ffffffff810f97d5>] ? parse_args+0x4a5/0x710
[    2.440011]  [<ffffffff854dbe32>] kernel_init_freeable+0x22d/0x364
[    2.440011]  [<ffffffff854dac42>] ? do_early_param+0x111/0x111
[    2.440011]  [<ffffffff831ac130>] ? rest_init+0x230/0x230
[    2.440011]  [<ffffffff831ac145>] kernel_init+0x15/0x290
[    2.440011]  [<ffffffff83214eea>] ret_from_fork+0x7a/0xb0
[    2.440011]  [<ffffffff831ac130>] ? rest_init+0x230/0x230
[    2.440011] Code: 5d d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d f8 c9 c3 0f 1f 80 00 00 00 00 48 ff 05 b9 b2 91 04 31 db 48 c7 c7 a8 aa ae 84 <4d> 39 26 0f 95 c3 31 d2 48 ff 05 a9 b2 91 04 89 de e8 f2 71 6e 
[    2.440011] RIP  [<ffffffff81af0a18>] __list_del_entry+0x148/0x320
[    2.440011]  RSP <ffff88000d84bd70>
[    2.440011] CR2: 0000000000000000
[    2.440011] ---[ end trace eb3f9fd956cfd844 ]---

git bisect start 36b054d81c3c6dedf005a0602959820ba9d15d93 c095ba7224d8edc71dcef0d655911399a8bd4a3f --
git bisect good c3bdeb5c7cc073ccf5ff9624642022a8613a956e  # 00:34     21+  net: move zerocopy_sg_from_iovec() to net/core/datagram.c
git bisect good 08ecb79b6612da03d9495df93a72fec1f6aa541f  # 00:50     21+  Merge branch 'fixes-next' into linux-next
git bisect  bad ca3fdce42013ca314bacaf0a943dd26589b86015  # 01:03      0-  cpufreq: exynos5440: Fix to skip when new frequency same as current
git bisect  bad 64e64e40ee2a31314677ff7df499370fa313f155  # 01:14      0-  cpufreq: Use rwsem for protecting critical sections
git bisect good 89261dd1b26fd53882cbf9c24aa6dd2e57b34d83  # 01:26     21+  cpufreq: Pass policy to cpufreq_add_policy_cpu()
git bisect good 8bb2971b29c7d2a2619c100b86105e2fc4c8d4d5  # 01:36     21+  cpufreq: Clean up header files included in the core
git bisect good b41d7a570aad4427ae5eab57f6cc86b89fb99c57  # 01:50     21+  cpufreq: Use sizeof(*ptr) convetion for computing sizes
git bisect  bad a239b157aa89dd451749999de8766bbaa3b5bbef  # 01:58      0-  cpufreq: Use cpufreq_policy_list for iterating over policies
git bisect  bad 01e3e82efc6742d5cf7ba14fb7a9bea318b386d8  # 02:07      0-  cpufreq: Store cpufreq policies in a list
git bisect good b41d7a570aad4427ae5eab57f6cc86b89fb99c57  # 02:30     63+  cpufreq: Use sizeof(*ptr) convetion for computing sizes
git bisect  bad 36b054d81c3c6dedf005a0602959820ba9d15d93  # 02:30      0-  Merge remote-tracking branch 'net-next/master' into devel-snb-x86_64-201308101718
git bisect  bad 828880617293703c5e3d4f9d22fbb68fc0c5692a  # 02:38      0-  Revert "cpufreq: Store cpufreq policies in a list"
git bisect good 8ae3f1d09566038606a18576604ecc957a935c48  # 03:05     63+  Merge tag 'staging-3.11-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging

Thanks,
Fengguang

--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-lkp-snb01-34382-20130810173343-3.11.0-rc4-00455-g36b054d-4"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.11.0-rc4-00455-g36b054d (kbuild@snb) (gcc ve=
rsion 4.8.1 (Debian 4.8.1-8) ) #4 PREEMPT Sat Aug 10 17:28:20 CST 2013
[    0.000000] Command line: hung_task_panic=3D1 rcutree.rcu_cpu_stall_time=
out=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug d=
ynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/ke=
rnel-tests/run-queue/kvm/x86_64-randconfig-s06-0810/devel-snb-x86_64-201308=
101718/.vmlinuz-36b054d81c3c6dedf005a0602959820ba9d15d93-20130810173126-5-l=
kp-snb01 branch=3Dlinux-devel/devel-snb-x86_64-201308101718  BOOT_IMAGE=3D/=
kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/=
vmlinuz-3.11.0-rc4-00455-g36b054d
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at =
[ffff8800000fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x06be1000, 0x06be1fff] PGTABLE
[    0.000000] BRK [0x06be2000, 0x06be2fff] PGTABLE
[    0.000000] BRK [0x06be3000, 0x06be3fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x06be4000, 0x06be4fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127864(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 00034 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 011A9 (v01   BXPC   BXDSDT 00000=
001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 00080 (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f9000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000d40000=
0-ffff88000d7fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 840 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f9000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
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
[    0.000000] mapped IOAPIC to ffffffffff5f8000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 41fd380
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64519
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-s06-0810/devel-snb-x86_64-=
201308101718/.vmlinuz-36b054d81c3c6dedf005a0602959820ba9d15d93-201308101731=
26-5-lkp-snb01 branch=3Dlinux-devel/devel-snb-x86_64-201308101718  BOOT_IMA=
GE=3D/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d=
15d93/vmlinuz-3.11.0-rc4-00455-g36b054d
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 130456K/261744K available (34915K kernel code, 19588=
K rwdata, 15852K rodata, 1784K init, 21796K bss, 131288K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
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
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
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
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.332 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5386.66 Bogo=
MIPS (lpj=3D10773328)
[    0.008000] pid_max: default: 32768 minimum: 301
[    0.008000] Mount-cache hash table entries: 256
[    0.008000] Initializing cgroup subsys hugetlb
[    0.008000] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.008000] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.008000] tlb_flushall_shift: 6
[    0.008008] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.014644] ACPI: Core revision 20130626
[    0.020656] ACPI: All ACPI Tables successfully acquired
[    0.021157] ftrace: allocating 53269 entries in 209 pages
[    0.032238] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.034450] ftrace: Allocated trace_printk buffers
[    0.036700] Getting VERSION: 50014
[    0.037001] Getting VERSION: 50014
[    0.037301] Getting ID: 0
[    0.037538] Getting ID: ff000000
[    0.037821] Getting LVT0: 8700
[    0.038097] Getting LVT1: 8400
[    0.038412] enabled ExtINT on CPU#0
[    0.039477] ENABLING IO-APIC IRQs
[    0.039768] init IO_APIC IRQs
[    0.040017]  apic 0 pin 0 not connected
[    0.040365] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.041056] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.041736] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.042425] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.043100] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.044027] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.044699] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.045372] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.046034] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.046708] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.047393] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.048027] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.048710] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.049401] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.050083] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.050755]  apic 0 pin 16 not connected
[    0.051083]  apic 0 pin 17 not connected
[    0.051410]  apic 0 pin 18 not connected
[    0.051734]  apic 0 pin 19 not connected
[    0.052006]  apic 0 pin 20 not connected
[    0.052334]  apic 0 pin 21 not connected
[    0.052659]  apic 0 pin 22 not connected
[    0.052990]  apic 0 pin 23 not connected
[    0.053457] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.054035] Using local APIC timer interrupts.
[    0.054035] calibrating APIC timer ...
[    0.056000] ... lapic delta =3D 6249994
[    0.056000] ... PM-Timer delta =3D 357951
[    0.056000] ... PM-Timer result ok
[    0.056000] ..... delta 6249994
[    0.056000] ..... mult: 268435198
[    0.056000] ..... calibration result: 3999996
[    0.056000] ..... CPU clock speed is 2693.1920 MHz.
[    0.056000] ..... host bus clock speed is 999.3996 MHz.
[    0.056000] devtmpfs: initialized
[    0.057704] xor: measuring software checksum speed
[    0.096042]    prefetch64-sse: 11792.000 MB/sec
[    0.136004]    generic_sse: 11447.000 MB/sec
[    0.136424] xor: using function: prefetch64-sse (11792.000 MB/sec)
[    0.137568] regulator-dummy: no parameters
[    0.138351] NET: Registered protocol family 16
[    0.139604] cpuidle: using governor menu
[    0.140369] ACPI: bus type PCI registered
[    0.140800] PCI: Using configuration type 1 for base access
[    0.176453] bio: create slab <bio-0> at 0
[    0.244029] raid6: sse2x1    3434 MB/s
[    0.312017] raid6: sse2x2    3933 MB/s
[    0.380009] raid6: sse2x4    3890 MB/s
[    0.380376] raid6: using algorithm sse2x2 (3933 MB/s)
[    0.380849] raid6: using intx1 recovery algorithm
[    0.381378] ACPI: Added _OSI(Module Device)
[    0.381783] ACPI: Added _OSI(Processor Device)
[    0.382211] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.382657] ACPI: Added _OSI(Processor Aggregator Device)
[    0.386724] ACPI: EC: Look up EC in DSDT
[    0.399951] ACPI: Interpreter enabled
[    0.400024] ACPI: (supports S0 S5)
[    0.400357] ACPI: Using IOAPIC for interrupt routing
[    0.400896] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.405117] ACPI: No dock devices found.
[    0.428184] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.429877] PCI host bridge to bus 0000:00
[    0.430295] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.430809] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.431390] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.431965] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.432007] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.432725] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.434200] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.436046] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.439159] pci 0000:00:01.1: reg 0x20: [io  0xc1e0-0xc1ef]
[    0.441199] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.442132] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.442810] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.444440] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.446203] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.447917] pci 0000:00:02.0: reg 0x14: [mem 0xfebe0000-0xfebe0fff]
[    0.453601] pci 0000:00:02.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.454597] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.456007] pci 0000:00:03.0: reg 0x10: [io  0xc1c0-0xc1df]
[    0.457449] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.462741] pci 0000:00:03.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.464523] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.466038] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.467557] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.472476] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.473913] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.475458] pci 0000:00:05.0: reg 0x10: [io  0xc040-0xc07f]
[    0.476939] pci 0000:00:05.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    0.483197] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.484483] pci 0000:00:06.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.485948] pci 0000:00:06.0: reg 0x14: [mem 0xfebe3000-0xfebe3fff]
[    0.492407] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.493952] pci 0000:00:07.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.495418] pci 0000:00:07.0: reg 0x14: [mem 0xfebe4000-0xfebe4fff]
[    0.501678] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.503227] pci 0000:00:08.0: reg 0x10: [io  0xc100-0xc13f]
[    0.504481] pci 0000:00:08.0: reg 0x14: [mem 0xfebe5000-0xfebe5fff]
[    0.510705] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.512485] pci 0000:00:09.0: reg 0x10: [io  0xc140-0xc17f]
[    0.513943] pci 0000:00:09.0: reg 0x14: [mem 0xfebe6000-0xfebe6fff]
[    0.520101] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.521644] pci 0000:00:0a.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.523107] pci 0000:00:0a.0: reg 0x14: [mem 0xfebe7000-0xfebe7fff]
[    0.528856] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.529932] pci 0000:00:0b.0: reg 0x10: [mem 0xfebe8000-0xfebe800f]
[    0.534528] pci_bus 0000:00: on NUMA node 0
[    0.534936] acpi PNP0A03:00: ACPI _OSC support notification failed, disa=
bling PCIe ASPM
[    0.535691] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.538263] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.539331] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.540634] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.541696] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.542540] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.544860] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.545396] ACPI: \_SB_.PCI0: notify handler is installed
[    0.546182] Found 1 acpi root devices
[    0.547091] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.547879] vgaarb: loaded
[    0.548005] vgaarb: bridge control possible 0000:00:02.0
[    0.549163] SCSI subsystem initialized
[    0.549815] Linux video capture interface: v2.00
[    0.550376] pps_core: LinuxPPS API ver. 1 registered
[    0.550852] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.551736] PTP clock support registered
[    0.552236] wmi: Mapper loaded
[    0.552624] PCI: Using ACPI for IRQ routing
[    0.553044] PCI: pci_cache_line_size set to 64 bytes
[    0.553754] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.554348] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.555567] irda_init()
[    0.556064] NET: Registered protocol family 23
[    0.556548] Bluetooth: Core ver 2.16
[    0.556968] NET: Registered protocol family 31
[    0.557412] Bluetooth: HCI device and connection manager initialized
[    0.558041] Bluetooth: HCI socket layer initialized
[    0.558523] Bluetooth: L2CAP socket layer initialized
[    0.559062] Bluetooth: SCO socket layer initialized
[    0.559546] NET: Registered protocol family 8
[    0.560006] NET: Registered protocol family 20
[    0.561225] nfc: nfc_init: NFC Core ver 0.1
[    0.561753] NET: Registered protocol family 39
[    0.562603] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.563317] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.564071] cfg80211: Calling CRDA to update world regulatory domain

[    0.564811] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.569101] Switched to clocksource kvm-clock
[    0.570652] Warning: could not register all branches stats
[    0.571223] Warning: could not register annotated branches stats
[    0.653428] FS-Cache: Loaded
[    0.653877] CacheFiles: Loaded
[    0.654288] pnp: PnP ACPI init
[    0.654634] ACPI: bus type PNP registered
[    0.655143] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.656052] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.656791] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.657671] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.658385] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.659267] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.660066] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.660856] pnp 00:03: [dma 2]
[    0.661237] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.662019] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.662898] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.663684] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.664564] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.666063] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.667250] pnp: PnP ACPI: found 7 devices
[    0.667661] ACPI: bus type PNP unregistered
[    0.674387] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.674934] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.675469] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.676088] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.676795] NET: Registered protocol family 2
[    0.677691] TCP established hash table entries: 2048 (order: 3, 32768 by=
tes)
[    0.678510] TCP bind hash table entries: 2048 (order: 5, 163840 bytes)
[    0.679265] TCP: Hash tables configured (established 2048 bind 2048)
[    0.680165] TCP: reno registered
[    0.680494] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    0.681107] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    0.681945] NET: Registered protocol family 1
[    0.682828] RPC: Registered named UNIX socket transport module.
[    0.683404] RPC: Registered udp transport module.
[    0.683862] RPC: Registered tcp transport module.
[    0.684333] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.684962] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.685542] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.686128] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.686759] pci 0000:00:02.0: Boot video device
[    0.687297] PCI: CLS 0 bytes, default 64
[    0.688480] Unpacking initramfs...
[    1.984526] Freeing initrd memory: 23656K (ffff88000e8d6000 - ffff88000f=
ff0000)
[    1.986002] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    1.986768] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    1.987588] Scanning for low memory corruption every 60 seconds
[    1.988217] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    1.989353] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    1.990279] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.990860] PCLMULQDQ-NI instructions are not detected.
[    1.991350] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.991948] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.992706] AVX or AES-NI instructions are not detected.
[    1.993209] AVX instructions are not detected.
[    1.993627] AVX instructions are not detected.
[    1.994050] AVX instructions are not detected.
[    1.996172] Initializing RT-Tester: OK
[    1.996549] audit: initializing netlink socket (disabled)
[    1.997132] type=3D2000 audit(1376127209.325:1): initialized
[    2.004146] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.005360] VFS: Disk quotas dquot_6.5.2
[    2.005748] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.006619] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    2.007401] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    2.008176] NTFS driver 2.1.30 [Flags: R/W].
[    2.008654] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    2.009143] jffs2: version 2.2.=20
[    2.009995] fuse init (API version 7.22)
[    2.010721] JFS: nTxBlock =3D 1204, nTxLock =3D 9632
[    2.011852] 9p: Installing v9fs 9p2000 file system support
[    2.012422] FS-Cache: Netfs '9p' registered for caching
[    2.012971] NILFS version 2 loaded
[    2.013301] BeFS version: 0.9.3
[    2.013624] OCFS2 1.5.0
[    2.014071] ocfs2 stack glue: unable to register sysctl
[    2.014568] OCFS2 DLMFS 1.5.0
[    2.014976] OCFS2 User DLM kernel interface loaded
[    2.015437] OCFS2 Node Manager 1.5.0
[    2.016528] bio: create slab <bio-1> at 1
[    2.017305] Btrfs loaded, debug=3Don
[    2.017639] btrfs: selftest: Running btrfs free space cache tests
[    2.018216] btrfs: selftest: Running extent only tests
[    2.018746] btrfs: selftest: Running bitmap only tests
[    2.019297] btrfs: selftest: Running bitmap and extent tests
[    2.019940] btrfs: selftest: Free space cache tests finished
[    2.021035] GFS2 installed
[    2.029538] NET: Registered protocol family 38
[    2.030004] Key type asymmetric registered
[    2.030441] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    2.031148] io scheduler noop registered (default)
[    2.031601] io scheduler deadline registered
[    2.032131] io scheduler cfq registered
[    2.032498] test_string_helpers: Running tests...
[    2.034148] crc32: CRC_LE_BITS =3D 8, CRC_BE BITS =3D 8
[    2.034609] crc32: self tests passed, processed 225944 bytes in 565715 n=
sec
[    2.035777] crc32c: CRC_LE_BITS =3D 8
[    2.036385] crc32c: self tests passed, processed 225944 bytes in 264457 =
nsec
[    2.037356] xz_dec_test: module loaded
[    2.037724] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
250 0' and write .xz files to it.
[    2.039429] ipmi message handler version 39.2
[    2.039860] ipmi device interface
[    2.040371] IPMI System Interface driver.
[    2.040894] ipmi_si: Adding default-specified kcs state machine
[    2.041470] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    2.042407] ipmi_si: Interface detection failed
[    2.042857] ipmi_si: Adding default-specified smic state machine
[    2.043439] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    2.044455] ipmi_si: Interface detection failed
[    2.044911] ipmi_si: Adding default-specified bt state machine
[    2.045523] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    2.046475] ipmi_si: Interface detection failed
[    2.047076] ipmi_si: Unable to find any System Interface(s)
[    2.047605] IPMI Watchdog: driver initialized
[    2.048064] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    2.051823] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    2.052405] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    2.053733] virtio-pci 0000:00:03.0: setting latency timer to 64
[    2.056797] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    2.057346] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    2.058706] virtio-pci 0000:00:05.0: setting latency timer to 64
[    2.062202] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    2.063466] virtio-pci 0000:00:06.0: setting latency timer to 64
[    2.067473] virtio-pci 0000:00:07.0: setting latency timer to 64
[    2.071209] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    2.072782] virtio-pci 0000:00:08.0: setting latency timer to 64
[    2.077388] virtio-pci 0000:00:09.0: setting latency timer to 64
[    2.082357] virtio-pci 0000:00:0a.0: setting latency timer to 64
[    2.135637] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.157931] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    2.159993] Non-volatile memory driver v1.3
[    2.160759] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    2.161662] lkdtm: No crash points registered, enable through debugfs
[    2.162416] Phantom Linux Driver, version n0.9.8, init OK
[    2.163032] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    2.163889] c2port c2port0: C2 port uc added
[    2.164309] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    2.166094] Uniform Multi-Platform E-IDE driver
[    2.168310] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[    2.169260] ide-gd driver 1.18
[    2.169596] ide-cd driver 5.00
[    2.170278] Loading iSCSI transport class v2.0-870.
[    2.171832] bnx2fc: Broadcom NetXtreme II FCoE Driver bnx2fc v1.0.14 (Ma=
r 08, 2013)
[    2.172914] iscsi: registered transport (tcp)
[    2.173399] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[    2.173931] Detecting Adaptec I2O RAID controllers...
[    2.174949] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    2.175804] isci: Intel(R) C600 SAS Controller Driver - version 1.1.0
[    2.176696] scsi: <fdomain> Detection failed (no card)
[    2.177177] Brocade BFA FC/FCOE SCSI driver - version: 3.2.21.1
[    2.177841] csiostor: Chelsio FCoE driver 1.0.0
[    2.178664] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)
[    2.179511] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 20=
06)
[    2.180252] mpt2sas version 15.100.00.00 loaded
[    2.181057] 3ware Storage Controller device driver for Linux v1.26.02.00=
3.
[    2.181776] 3ware 9000 Storage Controller device driver for Linux v2.26.=
02.014.
[    2.182522] LSI 3ware SAS/SATA-RAID Controller device driver for Linux v=
3.26.02.000.
[    2.183476] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age =
0xf, 4 bits.
[    2.184220] libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx=
 0.
[    2.184868] Chelsio T3 iSCSI Driver cxgb3i v2.0.0 (Jun. 2010)
[    2.185465] iscsi: registered transport (cxgb3i)
[    2.186176] VMware PVSCSI driver - version 1.0.2.0-k
[    2.186726] hv_vmbus: registering driver hv_storvsc
[    2.187194] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    2.187919] SCSI Media Changer driver v0.25=20
[    2.188502] osd: LOADED open-osd 0.2.1
[    2.191543] scsi_debug: host protection
[    2.191932] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    2.193652] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    2.194984] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    2.196485] scsi 0:0:0:0: Attached scsi generic sg0 type 0
[    2.200141] SSFDC read-only Flash Translation layer
[    2.200714] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    2.201390] platform physmap-flash.0: failed to claim resource 0
[    2.202002] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    2.202751] slram: not enough parameters.
[    2.203134] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel =
Networks.
[    2.203843] pmc551: not detected
[    2.206363] Spectra MTD driver built on Aug 10 2013 @ 17:23:24
[    2.245994] No valid DiskOnChip devices found
[    2.246628] HSI/SSI char device loaded
[    2.248172] libphy: Fixed MDIO Bus: probed
[    2.249013] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.17 (July 2=
8, 2013)
[    2.249820] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ether=
net Driver bnx2x 1.78.17-0 (2013/04/11)
[    2.251003] Brocade 10G Ethernet driver - version: 3.2.21.1
[    2.256414] QLogic/NetXen Network Driver v4.0.81
[    2.257319] tehuti: Tehuti Networks(R) Network Driver, 7.29.3
[    2.257851] tehuti: Options: hw_csum=20
[    2.258330] AX.25: bpqether driver version 004
[    2.258824] PPP generic driver version 2.4.2
[    2.259435] PPP MPPE Compression module registered
[    2.259900] NET: Registered protocol family 24
[    2.260345] PPTP driver version 0.8.5
[    2.260918] ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
[    2.261546] ipw2100: Copyright(c) 2003-2006 Intel Corporation
[    2.262164] libipw: Unable to create ieee80211 proc directory
[    2.262755] airo(): Probing for PCI adapters
[    2.263232] airo(): Finished probing for PCI adapters
[    2.263775] Loaded prism54 driver, version 1.2
[    2.264443] Broadcom 43xx-legacy driver loaded [ Features: PLID ]
[    2.265180] Intel(R) Wireless WiFi driver for Linux, in-tree:
[    2.265726] Copyright(c) 2003-2013 Intel Corporation
[    2.267011] VMware vmxnet3 virtual NIC driver - version 1.1.30.0-k-NAPI
[    2.267813] hv_vmbus: registering driver hv_netvsc
[    2.269268] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    2.270796] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.271531] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.311577] mousedev: PS/2 mouse device common for all mice
[    2.312921] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    2.314019] evbug: Connected device: input0 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    2.315758] mk712: device not present
[    2.316319] I2O subsystem v1.325
[    2.316638] i2o: max drivers =3D 8
[    2.317324] I2O Configuration OSM v1.323
[    2.317753] I2O Bus Adapter OSM v1.317
[    2.318164] I2O Block Device OSM v1.325
[    2.319250] I2O SCSI Peripheral OSM v1.316
[    2.319688] I2O ProcFS OSM v1.316
[    2.320220] lirc_dev: IR Remote Control driver registered, major 241=20
[    2.320832] IR NEC protocol handler initialized
[    2.321267] IR RC5 (streamzap) protocol handler initialized
[    2.321799] IR MCE Keyboard/mouse protocol handler initialized
[    2.322349] IR LIRC bridge handler initialized
[    2.323095] pps pps0: new PPS source ktimer
[    2.323499] pps pps0: ktimer PPS source registered
[    2.323955] Driver for 1-wire Dallas network protocol.
[    2.324599] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    2.325246] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    2.327249] applesmc: supported laptop not found!
[    2.327701] applesmc: driver init failed (ret=3D-19)!
[    2.328728] pc87360: PC8736x not detected, module not inserted
[    2.329506] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[    2.331427] rdma_ucm: couldn't register sysctl paths
[    2.334286] iscsi: registered transport (iser)
[    2.335023] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    2.335748] No iBFT detected.
[    2.337890] vme_user: VME User Space Access Driver
[    2.338346] vme_user: No cards, skipping registration
[    2.339574] zram: Created 1 device(s) ...
[    2.340143] logger: created 256K log 'log_main'
[    2.340750] logger: created 256K log 'log_events'
[    2.341351] logger: created 256K log 'log_radio'
[    2.341954] logger: created 256K log 'log_system'
[    2.342406] dell_wmi_aio: No known WMI GUID found
[    2.342855] acerhdf: error getting hardware information
[    2.343341] hdaps: supported laptop not found!
[    2.343763] hdaps: driver init failed (ret=3D-19)!
[    2.344363] toshiba_acpi: Unable to create proc dir toshiba
[    2.345776] oprofile: using NMI interrupt.
[    2.346243] NET: Registered protocol family 26
[    2.346746] gre: GRE over IPv4 demultiplexor driver
[    2.347226] ip_gre: GRE over IPv4 tunneling driver
[    2.348450] TCP: bic registered
[    2.348771] TCP: cubic registered
[    2.349094] TCP: westwood registered
[    2.349441] TCP: highspeed registered
[    2.349802] TCP: htcp registered
[    2.350118] TCP: vegas registered
[    2.350439] TCP: lp registered
[    2.350743] TCP: yeah registered
[    2.351057] Initializing XFRM netlink socket
[    2.351508] NET: Registered protocol family 17
[    2.356073] NET: Registered protocol family 15
[    2.356629] NET: Registered protocol family 4
[    2.357081] NET: Registered protocol family 5
[    2.357509] NET: Registered protocol family 9
[    2.357927] X.25 for Linux Version 0.2
[    2.359593] NET: Registered protocol family 6
[    2.363345] NET: Registered protocol family 11
[    2.363801] NET: Registered protocol family 3
[    2.368293] Bluetooth: RFCOMM socket layer initialized
[    2.368791] Bluetooth: RFCOMM ver 1.11
[    2.369146] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    2.369699] Bluetooth: HIDP socket layer initialized
[    2.370273] RPC: Registered rdma transport module.
[    2.370945] NET: Registered protocol family 33
[    2.371369] Key type rxrpc registered
[    2.371724] Key type rxrpc_s registered
[    2.372141] lec:lane_module_init: lec.c: initialized
[    2.372613] mpoa:atm_mpoa_init: mpc.c: initialized
[    2.373114] l2tp_core: L2TP core driver, V2.0
[    2.376049] l2tp_ip: L2TP IP encapsulation support (L2TPv3)
[    2.376598] l2tp_netlink: L2TP netlink interface
[    2.380077] 8021q: 802.1Q VLAN Support v1.8
[    2.380857] DCCP: Activated CCID 2 (TCP-like)
[    2.381513] sctp: Hash tables configured (established 910 bind 819)
[    2.384146] rds_page_remainder_cpu_notify(): cpu 0 action 0x7
[    2.384762] rds_rdma_listen_init(): cm ffff88000df27800 listening on por=
t 18634
[    2.385443] rds_rdma_listen_stop(): cm ffff88000df27800
[    2.386144] Registered RDS/tcp transport
[    2.386704] lib80211: common routines for IEEE802.11 drivers
[    2.387245] lib80211_crypt: registered algorithm 'NULL'
[    2.387742] lib80211_crypt: registered algorithm 'WEP'
[    2.388356] lib80211_crypt: registered algorithm 'CCMP'
[    2.388859] lib80211_crypt: registered algorithm 'TKIP'
[    2.389349] tipc: Activated (version 2.0.0)
[    2.390058] NET: Registered protocol family 30
[    2.390823] tipc: Started in single node mode
[    2.391247] 9pnet: Installing 9P2000 support
[    2.391806] NET: Registered protocol family 37
[    2.392325] NET: Registered protocol family 36
[    2.392899] Key type dns_resolver registered
[    2.393328] Key type ceph registered
[    2.393723] libceph: loaded (mon/osd proto 15/24)
[    2.394169] openvswitch: Open vSwitch switching datapath
[    2.394915] mpls_gso: MPLS GSO support
[    2.395629]=20
[    2.395629] printing PIC contents
[    2.396170] ... PIC  IMR: ffff
[    2.396467] ... PIC  IRR: 1013
[    2.396769] ... PIC  ISR: 0000
[    2.397062] ... PIC ELCR: 0c00
[    2.397353] printing local APIC contents on CPU#0/0:
[    2.397823] ... APIC ID:      00000000 (0)
[    2.398210] ... APIC VERSION: 00050014
[    2.398567] ... APIC TASKPRI: 00000000 (00)
[    2.398966] ... APIC PROCPRI: 00000000
[    2.399321] ... APIC LDR: 01000000
[    2.399646] ... APIC DFR: ffffffff
[    2.399973] ... APIC SPIV: 000001ff
[    2.400098] ... APIC ISR field:
[    2.400098] 000000000000000000000000000000000000000000000000000000000000=
0000
[    2.400098] ... APIC TMR field:
[    2.400098] 000000000200000000000000000000000000000000000000000000000000=
0000
[    2.400098] ... APIC IRR field:
[    2.400098] 000000000000000000000000000000000000000000000000000000000000=
8000
[    2.400098] ... APIC ESR: 00000000
[    2.400098] ... APIC ICR: 000400f6
[    2.400098] ... APIC ICR2: 01000000
[    2.400098] ... APIC LVTT: 000000ef
[    2.400098] ... APIC LVTPC: 00010000
[    2.400098] ... APIC LVT0: 00010700
[    2.400098] ... APIC LVT1: 00000400
[    2.400098] ... APIC LVTERR: 000000fe
[    2.400098] ... APIC TMICT: 0003b809
[    2.400098] ... APIC TMCCT: 00000000
[    2.400098] ... APIC TDCR: 00000003
[    2.400098]=20
[    2.407520] number of MP IRQ sources: 15.
[    2.407909] number of IO-APIC #0 registers: 24.
[    2.408354] testing the IO APIC.......................
[    2.408853] IO APIC #0......
[    2.409130] .... register #00: 00000000
[    2.409490] .......    : physical APIC id: 00
[    2.409904] .......    : Delivery Type: 0
[    2.410281] .......    : LTS          : 0
[    2.410657] .... register #01: 00170011
[    2.411074] .......     : max redirection entries: 17
[    2.411544] .......     : PRQ implemented: 0
[    2.411947] .......     : IO APIC version: 11
[    2.412373] .... register #02: 00000000
[    2.412740] .......     : arbitration: 00
[    2.413116] .... IRQ redirection table:
[    2.413487] 1    0    0   0   0    0    0    00
[    2.413926] 0    0    0   0   0    1    1    31
[    2.414359] 0    0    0   0   0    1    1    30
[    2.414797] 0    0    0   0   0    1    1    33
[    2.415230] 1    0    0   0   0    1    1    34
[    2.415665] 1    1    0   0   0    1    1    35
[    2.416122] 0    0    0   0   0    1    1    36
[    2.416558] 0    0    0   0   0    1    1    37
[    2.416997] 0    0    0   0   0    1    1    38
[    2.417435] 0    1    0   0   0    1    1    39
[    2.417871] 1    1    0   0   0    1    1    3A
[    2.418304] 1    1    0   0   0    1    1    3B
[    2.418741] 0    0    0   0   0    1    1    3C
[    2.419174] 0    0    0   0   0    1    1    3D
[    2.419607] 0    0    0   0   0    1    1    3E
[    2.420059] 0    0    0   0   0    1    1    3F
[    2.420494] 1    0    0   0   0    0    0    00
[    2.420932] 1    0    0   0   0    0    0    00
[    2.421363] 1    0    0   0   0    0    0    00
[    2.421799] 1    0    0   0   0    0    0    00
[    2.422230] 1    0    0   0   0    0    0    00
[    2.422660] 1    0    0   0   0    0    0    00
[    2.423095] 1    0    0   0   0    0    0    00
[    2.423526] 1    0    0   0   0    0    0    00
[    2.423956] IRQ to pin mappings:
[    2.424282] IRQ0 -> 0:2
[    2.424553] IRQ1 -> 0:1
[    2.424824] IRQ3 -> 0:3
[    2.425092] IRQ4 -> 0:4
[    2.425359] IRQ5 -> 0:5
[    2.425626] IRQ6 -> 0:6
[    2.425898] IRQ7 -> 0:7
[    2.426165] IRQ8 -> 0:8
[    2.426431] IRQ9 -> 0:9
[    2.426702] IRQ10 -> 0:10
[    2.426989] IRQ11 -> 0:11
[    2.427273] IRQ12 -> 0:12
[    2.427557] IRQ13 -> 0:13
[    2.427846] IRQ14 -> 0:14
[    2.428149] IRQ15 -> 0:15
[    2.428431] .................................... done.
[    2.429291] registered taskstats version 1
[    2.429918] kAFS: Red Hat AFS client v0.1 registering.
[    2.432049] kAFS: failed to register: -12
[    2.436185] Key type trusted registered
[    2.436910] Key type encrypted registered
[    2.438327] RIO: rio_register_scan for mport_id=3D-1
[    2.439366] BUG: unable to handle kernel NULL pointer dereference at    =
       (null)
[    2.440011] IP: [<ffffffff81af0a18>] __list_del_entry+0x148/0x320
[    2.440011] PGD 0=20
[    2.440011] Oops: 0000 [#1] PREEMPT=20
[    2.440011] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-rc4-00455-g36=
b054d #4
[    2.440011] task: ffff88000d848040 ti: ffff88000d84a000 task.ti: ffff880=
00d84a000
[    2.440011] RIP: 0010:[<ffffffff81af0a18>]  [<ffffffff81af0a18>] __list_=
del_entry+0x148/0x320
[    2.440011] RSP: 0000:ffff88000d84bd70  EFLAGS: 00010046
[    2.440011] RAX: 0000000000000002 RBX: 0000000000000000 RCX: 00000000000=
00000
[    2.440011] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff84a=
eaaa8
[    2.440011] RBP: ffff88000d84bd98 R08: 0000000000000000 R09: 00000000000=
00000
[    2.440011] R10: 00000000004ee000 R11: 0000000000000002 R12: ffff88000ea=
24ab8
[    2.440011] R13: 0000000000000000 R14: 0000000000000000 R15: dead0000002=
00200
[    2.440011] FS:  0000000000000000(0000) GS:ffffffff841dc000(0000) knlGS:=
0000000000000000
[    2.440011] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    2.440011] CR2: 0000000000000000 CR3: 00000000041bf000 CR4: 00000000000=
006b0
[    2.440011] Stack:
[    2.440011]  ffff88000ea24ab8 0000000000000206 ffffffff841d1a88 00000000=
00000000
[    2.440011]  0000000000000000 ffff88000d84bdb0 ffffffff81af0c04 ffff8800=
0ea24a00
[    2.440011]  ffff88000d84bdd0 ffffffff82928991 ffff88000ea24a00 00000000=
fffffffb
[    2.440011] Call Trace:
[    2.440011]  [<ffffffff81af0c04>] list_del+0x14/0x40
[    2.440011]  [<ffffffff82928991>] cpufreq_policy_free+0x41/0x80
[    2.440011]  [<ffffffff8292a5aa>] cpufreq_add_dev+0x4ba/0x730
[    2.440011]  [<ffffffff81c85380>] subsys_interface_register+0x160/0x1b0
[    2.440011]  [<ffffffff8321398f>] ? _raw_write_unlock_irqrestore+0xcf/0x=
130
[    2.440011]  [<ffffffff8556c3d4>] ? cpufreq_gov_dbs_init+0x20/0x20
[    2.440011]  [<ffffffff8292c4fb>] cpufreq_register_driver+0x14b/0x2f0
[    2.440011]  [<ffffffff8556c533>] acpi_cpufreq_init+0x15f/0x33f
[    2.440011]  [<ffffffff854dba92>] do_one_initcall+0xdb/0x24e
[    2.440011]  [<ffffffff810f97d5>] ? parse_args+0x4a5/0x710
[    2.440011]  [<ffffffff854dbe32>] kernel_init_freeable+0x22d/0x364
[    2.440011]  [<ffffffff854dac42>] ? do_early_param+0x111/0x111
[    2.440011]  [<ffffffff831ac130>] ? rest_init+0x230/0x230
[    2.440011]  [<ffffffff831ac145>] kernel_init+0x15/0x290
[    2.440011]  [<ffffffff83214eea>] ret_from_fork+0x7a/0xb0
[    2.440011]  [<ffffffff831ac130>] ? rest_init+0x230/0x230
[    2.440011] Code: 5d d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d f8 =
c9 c3 0f 1f 80 00 00 00 00 48 ff 05 b9 b2 91 04 31 db 48 c7 c7 a8 aa ae 84 =
<4d> 39 26 0f 95 c3 31 d2 48 ff 05 a9 b2 91 04 89 de e8 f2 71 6e=20
[    2.440011] RIP  [<ffffffff81af0a18>] __list_del_entry+0x148/0x320
[    2.440011]  RSP <ffff88000d84bd70>
[    2.440011] CR2: 0000000000000000
[    2.440011] ---[ end trace eb3f9fd956cfd844 ]---
[    2.440011] note: swapper[1] exited with preempt_count 1
[    2.465744] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x00000009
[    2.465744]=20
[    2.466592] Rebooting in 10 seconds..
BUG: kernel boot crashed
Elapsed time: 20
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /tmp//kernel/x86_64-randc=
onfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/vmlinuz-3.11.0-rc4-=
00455-g36b054d-34382 -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_tim=
eout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug =
dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/ke=
rnel-tests/run-queue/kvm/x86_64-randconfig-s06-0810/devel-snb-x86_64-201308=
101718/.vmlinuz-36b054d81c3c6dedf005a0602959820ba9d15d93-20130810173126-5-l=
kp-snb01 branch=3Dlinux-devel/devel-snb-x86_64-201308101718  BOOT_IMAGE=3D/=
kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/=
vmlinuz-3.11.0-rc4-00455-g36b054d'  -initrd /kernel-tests/initrd/quantal-co=
re-x86_64.cgz -m 256M -smp 2 -net nic,vlan=3D0,macaddr=3D00:00:00:00:00:00,=
model=3Dvirtio -net user,vlan=3D0,hostfwd=3Dtcp::38478-:22 -net nic,vlan=3D=
1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6=
300esb -drive file=3D/fs/LABEL=3DKVM/disk0-lkp-snb01-34382,media=3Ddisk,if=
=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-lkp-snb01-34382,media=3Ddisk,=
if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-lkp-snb01-34382,media=3Ddis=
k,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-lkp-snb01-34382,media=3Dd=
isk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-lkp-snb01-34382,media=
=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-lkp-snb01-34382,med=
ia=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-lkp-snb01-lkp-34382 -seri=
al file:/dev/shm/kboot/serial-lkp-snb01-lkp-34382 -daemonize -display none =
-monitor null=20

--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="bisect-36b054d81c3c6dedf005a0602959820ba9d15d93-x86_64-randconfig-s06-0810-acpi_cpufreq_init+-x-50590.log"

git checkout c095ba7224d8edc71dcef0d655911399a8bd4a3f
Previous HEAD position was 36b054d... Merge remote-tracking branch 'net-next/master' into devel-snb-x86_64-201308101718
HEAD is now at c095ba72... Linux 3.11-rc4
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-s06-0810/linux-devel:devel-snb-x86_64-201308101718:c095ba7224d8edc71dcef0d655911399a8bd4a3f:bisect-usb

2013-08-11-00:06:58 c095ba7224d8edc71dcef0d655911399a8bd4a3f reuse /kernel/x86_64-randconfig-s06-0810/c095ba7224d8edc71dcef0d655911399a8bd4a3f/vmlinuz-3.11.0-rc4

2013-08-11-00:06:58 detecting boot state ...	14	20	21 SUCCESS

bisect: good commit c095ba7224d8edc71dcef0d655911399a8bd4a3f
git bisect start 36b054d81c3c6dedf005a0602959820ba9d15d93 c095ba7224d8edc71dcef0d655911399a8bd4a3f --
Previous HEAD position was c095ba72... Linux 3.11-rc4
HEAD is now at c1be5a5... Linux 3.9
Bisecting: 227 revisions left to test after this (roughly 8 steps)
[c3bdeb5c7cc073ccf5ff9624642022a8613a956e] net: move zerocopy_sg_from_iovec() to net/core/datagram.c
git bisect run /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-s06-0810/linux-devel:devel-snb-x86_64-201308101718:c3bdeb5c7cc073ccf5ff9624642022a8613a956e:bisect-usb

2013-08-11-00:10:16 c3bdeb5c7cc073ccf5ff9624642022a8613a956e compiling
604 real  3935 user  237 sys  690.25% cpu 	x86_64-randconfig-s06-0810

2013-08-11-00:20:46 detecting boot state 3.11.0-rc3-00603-gc3bdeb5..........	3	4..	5	10	13	15.	16	18	20....	21 SUCCESS

Bisecting: 116 revisions left to test after this (roughly 7 steps)
[08ecb79b6612da03d9495df93a72fec1f6aa541f] Merge branch 'fixes-next' into linux-next
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-s06-0810/linux-devel:devel-snb-x86_64-201308101718:08ecb79b6612da03d9495df93a72fec1f6aa541f:bisect-usb

2013-08-11-00:34:18 08ecb79b6612da03d9495df93a72fec1f6aa541f compiling
384 real  3843 user  227 sys  1059.70% cpu 	x86_64-randconfig-s06-0810

2013-08-11-00:40:52 detecting boot state 3.11.0-rc4-00506-g08ecb79..	1	3..	4	5	11	13	14	15	18	19	20....	21 SUCCESS

Bisecting: 64 revisions left to test after this (roughly 6 steps)
[ca3fdce42013ca314bacaf0a943dd26589b86015] cpufreq: exynos5440: Fix to skip when new frequency same as current
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-s06-0810/linux-devel:devel-snb-x86_64-201308101718:ca3fdce42013ca314bacaf0a943dd26589b86015:bisect-usb

2013-08-11-00:50:54 ca3fdce42013ca314bacaf0a943dd26589b86015 compiling
369 real  3862 user  222 sys  1104.48% cpu 	x86_64-randconfig-s06-0810

2013-08-11-00:57:13 detecting boot state 3.11.0-rc4-00558-gca3fdce............. TEST FAILURE
[    2.444929] Key type encrypted registered
[    2.446384] RIO: rio_register_scan for mport_id=-1
[    2.447456] BUG: unable to handle kernel NULL pointer dereference at           (null)
[    2.448010] IP: [<ffffffff81af10f8>] __list_del_entry+0x148/0x320
[    2.448010] PGD 0 
[    2.448010] Oops: 0000 [#1] PREEMPT 
[    2.448010] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-rc4-00558-gca3fdce #258
[    2.448010] task: ffff88000d848040 ti: ffff88000d84a000 task.ti: ffff88000d84a000
[    2.448010] RIP: 0010:[<ffffffff81af10f8>]  [<ffffffff81af10f8>] __list_del_entry+0x148/0x320
[    2.448010] RSP: 0000:ffff88000d84bd70  EFLAGS: 00010046
[    2.448010] RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000000000000
[    2.448010] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff84a86da8
[    2.448010] RBP: ffff88000d84bd98 R08: 0000000000000000 R09: 0000000000000000
[    2.448010] R10: 00000000004ee000 R11: 0000000000000002 R12: ffff88000de698b8
[    2.448010] R13: 0000000000000000 R14: 0000000000000000 R15: dead000000200200
[    2.448010] FS:  0000000000000000(0000) GS:ffffffff8417c000(0000) knlGS:0000000000000000
[    2.448010] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    2.448010] CR2: 0000000000000000 CR3: 000000000415f000 CR4: 00000000000006b0
[    2.448010] Stack:
[    2.448010]  ffff88000de698b8 0000000000000206 ffffffff84171a88 0000000000000000
[    2.448010]  0000000000000000 ffff88000d84bdb0 ffffffff81af12e4 ffff88000de69800
[    2.448010]  ffff88000d84bdd0 ffffffff82906961 ffff88000de69800 00000000fffffffb
[    2.448010] Call Trace:
[    2.448010]  [<ffffffff81af12e4>] list_del+0x14/0x40
[    2.448010]  [<ffffffff82906961>] cpufreq_policy_free+0x41/0x80
[    2.448010]  [<ffffffff8290857a>] cpufreq_add_dev+0x4ba/0x730
[    2.448010]  [<ffffffff81c82310>] subsys_interface_register+0x160/0x1b0
[    2.448010]  [<ffffffff831ee41f>] ? _raw_write_unlock_irqrestore+0xcf/0x130
[    2.448010]  [<ffffffff854fe2f9>] ? cpufreq_gov_dbs_init+0x20/0x20
[    2.448010]  [<ffffffff8290a4cb>] cpufreq_register_driver+0x14b/0x2f0
[    2.448010]  [<ffffffff854fe458>] acpi_cpufreq_init+0x15f/0x33f
[    2.448010]  [<ffffffff8546da92>] do_one_initcall+0xdb/0x24e
[    2.448010]  [<ffffffff810f9815>] ? parse_args+0x4a5/0x710
[    2.448010]  [<ffffffff8546de32>] kernel_init_freeable+0x22d/0x364
[    2.448010]  [<ffffffff8546cc42>] ? do_early_param+0x111/0x111
[    2.448010]  [<ffffffff83186ed0>] ? rest_init+0x230/0x230
[    2.448010]  [<ffffffff83186ee5>] kernel_init+0x15/0x290
[    2.448010]  [<ffffffff831ef96a>] ret_from_fork+0x7a/0xb0
[    2.448010]  [<ffffffff83186ed0>] ? rest_init+0x230/0x230
[    2.448010] Code: 5d d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d f8 c9 c3 0f 1f 80 00 00 00 00 48 ff 05 d9 bb 8a 04 31 db 48 c7 c7 a8 6d a8 84 <4d> 39 26 0f 95 c3 31 d2 48 ff 05 c9 bb 8a 04 89 de e8 e2 6b 6e 
[    2.448010] RIP  [<ffffffff81af10f8>] __list_del_entry+0x148/0x320
[    2.448010]  RSP <ffff88000d84bd70>
[    2.448010] CR2: 0000000000000000
[    2.448010] ---[ end trace aef28f0b16007fc0 ]---
/kernel/x86_64-randconfig-s06-0810/ca3fdce42013ca314bacaf0a943dd26589b86015/dmesg-kvm-lkp-snb01-54661-20130811010315-3.11.0-rc4-00558-gca3fdce-258

Bisecting: 25 revisions left to test after this (roughly 5 steps)
[64e64e40ee2a31314677ff7df499370fa313f155] cpufreq: Use rwsem for protecting critical sections
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-s06-0810/linux-devel:devel-snb-x86_64-201308101718:64e64e40ee2a31314677ff7df499370fa313f155:bisect-usb

2013-08-11-01:03:45 64e64e40ee2a31314677ff7df499370fa313f155 compiling
365 real  3890 user  225 sys  1126.85% cpu 	x86_64-randconfig-s06-0810

2013-08-11-01:09:58 detecting boot state 3.11.0-rc4-00427-g64e64e4.......... TEST FAILURE
[    2.456905] Key type encrypted registered
[    2.458317] RIO: rio_register_scan for mport_id=-1
[    2.459366] BUG: unable to handle kernel NULL pointer dereference at           (null)
[    2.460010] IP: [<ffffffff81af07f8>] __list_del_entry+0x148/0x320
[    2.460010] PGD 0 
[    2.460010] Oops: 0000 [#1] PREEMPT 
[    2.460010] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-rc4-00427-g64e64e4 #259
[    2.460010] task: ffff88000d848040 ti: ffff88000d84a000 task.ti: ffff88000d84a000
[    2.460010] RIP: 0010:[<ffffffff81af07f8>]  [<ffffffff81af07f8>] __list_del_entry+0x148/0x320
[    2.460010] RSP: 0000:ffff88000d84bd70  EFLAGS: 00010046
[    2.460010] RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000000000000
[    2.460010] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff84a84a68
[    2.460010] RBP: ffff88000d84bd98 R08: 0000000000000000 R09: 0000000000000000
[    2.460010] R10: 00000000004ea000 R11: 0000000000000002 R12: ffff88000de668b8
[    2.460010] R13: 0000000000000000 R14: 0000000000000000 R15: dead000000200200
[    2.460010] FS:  0000000000000000(0000) GS:ffffffff8417a000(0000) knlGS:0000000000000000
[    2.460010] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    2.460010] CR2: 0000000000000000 CR3: 000000000415d000 CR4: 00000000000006b0
[    2.460010] Stack:
[    2.460010]  ffff88000de668b8 0000000000000206 ffffffff8416fa88 0000000000000000
[    2.460010]  0000000000000000 ffff88000d84bdb0 ffffffff81af09e4 ffff88000de66800
[    2.460010]  ffff88000d84bdd0 ffffffff82906341 ffff88000de66800 00000000fffffffb
[    2.460010] Call Trace:
[    2.460010]  [<ffffffff81af09e4>] list_del+0x14/0x40
[    2.460010]  [<ffffffff82906341>] cpufreq_policy_free+0x41/0x80
[    2.460010]  [<ffffffff82907e9a>] cpufreq_add_dev+0x4ba/0x730
[    2.460010]  [<ffffffff81c81cf0>] subsys_interface_register+0x160/0x1b0
[    2.460010]  [<ffffffff831edd8f>] ? _raw_write_unlock_irqrestore+0xcf/0x130
[    2.460010]  [<ffffffff854fbfd4>] ? cpufreq_gov_dbs_init+0x20/0x20
[    2.460010]  [<ffffffff82909deb>] cpufreq_register_driver+0x14b/0x2f0
[    2.460010]  [<ffffffff854fc133>] acpi_cpufreq_init+0x15f/0x33f
[    2.460010]  [<ffffffff8546ba92>] do_one_initcall+0xdb/0x24e
[    2.460010]  [<ffffffff810f9815>] ? parse_args+0x4a5/0x710
[    2.460010]  [<ffffffff8546be32>] kernel_init_freeable+0x22d/0x364
[    2.460010]  [<ffffffff8546ac42>] ? do_early_param+0x111/0x111
[    2.460010]  [<ffffffff831866b0>] ? rest_init+0x230/0x230
[    2.460010]  [<ffffffff831866c5>] kernel_init+0x15/0x290
[    2.460010]  [<ffffffff831ef2ea>] ret_from_fork+0x7a/0xb0
[    2.460010]  [<ffffffff831866b0>] ? rest_init+0x230/0x230
[    2.460010] Code: 5d d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d f8 c9 c3 0f 1f 80 00 00 00 00 48 ff 05 d9 a2 8a 04 31 db 48 c7 c7 68 4a a8 84 <4d> 39 26 0f 95 c3 31 d2 48 ff 05 c9 a2 8a 04 89 de e8 e2 74 6e 
[    2.460010] RIP  [<ffffffff81af07f8>] __list_del_entry+0x148/0x320
[    2.460010]  RSP <ffff88000d84bd70>
[    2.460010] CR2: 0000000000000000
[    2.460010] ---[ end trace 215cc7af417275f3 ]---
/kernel/x86_64-randconfig-s06-0810/64e64e40ee2a31314677ff7df499370fa313f155/dmesg-kvm-lkp-snb01-54661-20130811011429-3.11.0-rc4-00427-g64e64e4-259

Bisecting: 12 revisions left to test after this (roughly 4 steps)
[89261dd1b26fd53882cbf9c24aa6dd2e57b34d83] cpufreq: Pass policy to cpufreq_add_policy_cpu()
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-s06-0810/linux-devel:devel-snb-x86_64-201308101718:89261dd1b26fd53882cbf9c24aa6dd2e57b34d83:bisect-usb

2013-08-11-01:15:01 89261dd1b26fd53882cbf9c24aa6dd2e57b34d83 compiling
368 real  3890 user  234 sys  1119.99% cpu 	x86_64-randconfig-s06-0810

2013-08-11-01:21:20 detecting boot state 3.11.0-rc3-00018-g89261dd...	1	4	5	15	19..	21 SUCCESS

Bisecting: 6 revisions left to test after this (roughly 3 steps)
[8bb2971b29c7d2a2619c100b86105e2fc4c8d4d5] cpufreq: Clean up header files included in the core
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-s06-0810/linux-devel:devel-snb-x86_64-201308101718:8bb2971b29c7d2a2619c100b86105e2fc4c8d4d5:bisect-usb

2013-08-11-01:26:51 8bb2971b29c7d2a2619c100b86105e2fc4c8d4d5 compiling
392 real  3824 user  226 sys  1031.04% cpu 	x86_64-randconfig-s06-0810

2013-08-11-01:33:34 detecting boot state 3.11.0-rc4-00420-g8bb2971...	8	21 SUCCESS

Bisecting: 3 revisions left to test after this (roughly 2 steps)
[b41d7a570aad4427ae5eab57f6cc86b89fb99c57] cpufreq: Use sizeof(*ptr) convetion for computing sizes
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-s06-0810/linux-devel:devel-snb-x86_64-201308101718:b41d7a570aad4427ae5eab57f6cc86b89fb99c57:bisect-usb

2013-08-11-01:36:05 b41d7a570aad4427ae5eab57f6cc86b89fb99c57 compiling
370 real  3921 user  218 sys  1118.09% cpu 	x86_64-randconfig-s06-0810

2013-08-11-01:42:26 detecting boot state 3.11.0-rc4-00423-gb41d7a5.....	1	8	12	14.	18	20...	21 SUCCESS

Bisecting: 1 revision left to test after this (roughly 1 step)
[a239b157aa89dd451749999de8766bbaa3b5bbef] cpufreq: Use cpufreq_policy_list for iterating over policies
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-s06-0810/linux-devel:devel-snb-x86_64-201308101718:a239b157aa89dd451749999de8766bbaa3b5bbef:bisect-usb

2013-08-11-01:50:26 a239b157aa89dd451749999de8766bbaa3b5bbef compiling
374 real  3878 user  220 sys  1093.71% cpu 	x86_64-randconfig-s06-0810

2013-08-11-01:56:50 detecting boot state 3.11.0-rc4-00425-ga239b15... TEST FAILURE
[    3.501860] Key type encrypted registered
[    3.504571] RIO: rio_register_scan for mport_id=-1
[    3.506645] BUG: unable to handle kernel NULL pointer dereference at           (null)
[    3.508027] IP: [<ffffffff81af07f8>] __list_del_entry+0x148/0x320
[    3.508027] PGD 0 
[    3.508027] Oops: 0000 [#1] PREEMPT 
[    3.508027] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-rc4-00425-ga239b15 #263
[    3.508027] task: ffff88000d848040 ti: ffff88000d84a000 task.ti: ffff88000d84a000
[    3.508027] RIP: 0010:[<ffffffff81af07f8>]  [<ffffffff81af07f8>] __list_del_entry+0x148/0x320
[    3.508027] RSP: 0000:ffff88000d84bd70  EFLAGS: 00010046
[    3.508027] RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000000000000
[    3.508027] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff84a84a68
[    3.508027] RBP: ffff88000d84bd98 R08: 0000000000000000 R09: 0000000000000000
[    3.508027] R10: 00000000004ea000 R11: 0000000000000002 R12: ffff88000de658b8
[    3.508027] R13: 0000000000000000 R14: 0000000000000000 R15: dead000000200200
[    3.508027] FS:  0000000000000000(0000) GS:ffffffff8417a000(0000) knlGS:0000000000000000
[    3.508027] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    3.508027] CR2: 0000000000000000 CR3: 000000000415d000 CR4: 00000000000006b0
[    3.508027] Stack:
[    3.508027]  ffff88000de658b8 0000000000000206 ffffffff8416fa88 0000000000000000
[    3.508027]  0000000000000000 ffff88000d84bdb0 ffffffff81af09e4 ffff88000de65800
[    3.508027]  ffff88000d84bdd0 ffffffff82906471 ffff88000de65800 00000000fffffffb
[    3.508027] Call Trace:
[    3.508027]  [<ffffffff81af09e4>] list_del+0x14/0x40
[    3.508027]  [<ffffffff82906471>] cpufreq_policy_free+0x41/0x80
[    3.508027]  [<ffffffff82907d1d>] cpufreq_add_dev+0x1fd/0x720
[    3.508027]  [<ffffffff81c81cf0>] subsys_interface_register+0x160/0x1b0
[    3.508027]  [<ffffffff831edd4f>] ? _raw_write_unlock_irqrestore+0xcf/0x130
[    3.508027]  [<ffffffff854fbfd4>] ? cpufreq_gov_dbs_init+0x20/0x20
[    3.508027]  [<ffffffff82909dcb>] cpufreq_register_driver+0x14b/0x2f0
[    3.508027]  [<ffffffff854fc133>] acpi_cpufreq_init+0x15f/0x33f
[    3.508027]  [<ffffffff8546ba92>] do_one_initcall+0xdb/0x24e
[    3.508027]  [<ffffffff810f9815>] ? parse_args+0x4a5/0x710
[    3.508027]  [<ffffffff8546be32>] kernel_init_freeable+0x22d/0x364
[    3.508027]  [<ffffffff8546ac42>] ? do_early_param+0x111/0x111
[    3.508027]  [<ffffffff83186670>] ? rest_init+0x230/0x230
[    3.508027]  [<ffffffff83186685>] kernel_init+0x15/0x290
[    3.508027]  [<ffffffff831ef2aa>] ret_from_fork+0x7a/0xb0
[    3.508027]  [<ffffffff83186670>] ? rest_init+0x230/0x230
[    3.508027] Code: 5d d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d f8 c9 c3 0f 1f 80 00 00 00 00 48 ff 05 d9 a2 8a 04 31 db 48 c7 c7 68 4a a8 84 <4d> 39 26 0f 95 c3 31 d2 48 ff 05 c9 a2 8a 04 89 de e8 e2 74 6e 
[    3.508027] RIP  [<ffffffff81af07f8>] __list_del_entry+0x148/0x320
[    3.508027]  RSP <ffff88000d84bd70>
[    3.508027] CR2: 0000000000000000
[    3.508027] ---[ end trace 950a38c381da1d65 ]---
/kernel/x86_64-randconfig-s06-0810/a239b157aa89dd451749999de8766bbaa3b5bbef/dmesg-kvm-bay-17400-20130811015633-3.11.0-rc4-00425-ga239b15-263

Bisecting: 0 revisions left to test after this (roughly 0 steps)
[01e3e82efc6742d5cf7ba14fb7a9bea318b386d8] cpufreq: Store cpufreq policies in a list
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-s06-0810/linux-devel:devel-snb-x86_64-201308101718:01e3e82efc6742d5cf7ba14fb7a9bea318b386d8:bisect-usb

2013-08-11-01:58:21 01e3e82efc6742d5cf7ba14fb7a9bea318b386d8 compiling
362 real  3840 user  219 sys  1120.75% cpu 	x86_64-randconfig-s06-0810

2013-08-11-02:04:32 detecting boot state 3.11.0-rc4-00424-g01e3e82..... TEST FAILURE
[    3.321157] Key type encrypted registered
[    3.323007] RIO: rio_register_scan for mport_id=-1
[    3.324457] BUG: unable to handle kernel NULL pointer dereference at           (null)
[    3.325344] IP: [<ffffffff81af07f8>] __list_del_entry+0x148/0x320
[    3.326014] PGD 0 
[    3.326267] Oops: 0000 [#1] PREEMPT 
[    3.326674] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-rc4-00424-g01e3e82 #264
[    3.327475] task: ffff88000d848040 ti: ffff88000d84a000 task.ti: ffff88000d84a000
[    3.328012] RIP: 0010:[<ffffffff81af07f8>]  [<ffffffff81af07f8>] __list_del_entry+0x148/0x320
[    3.328012] RSP: 0000:ffff88000d84bd70  EFLAGS: 00010046
[    3.328012] RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000000000000
[    3.328012] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff84a84a68
[    3.328012] RBP: ffff88000d84bd98 R08: 0000000000000000 R09: 0000000000000000
[    3.328012] R10: 00000000004ea000 R11: 0000000000000002 R12: ffff88000de658b8
[    3.328012] R13: 0000000000000000 R14: 0000000000000000 R15: dead000000200200
[    3.328012] FS:  0000000000000000(0000) GS:ffffffff8417a000(0000) knlGS:0000000000000000
[    3.328012] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    3.328012] CR2: 0000000000000000 CR3: 000000000415d000 CR4: 00000000000006b0
[    3.328012] Stack:
[    3.328012]  ffff88000de658b8 0000000000000206 ffffffff8416fa88 0000000000000000
[    3.328012]  0000000000000000 ffff88000d84bdb0 ffffffff81af09e4 ffff88000de65800
[    3.328012]  ffff88000d84bdd0 ffffffff82906471 ffff88000de65800 00000000fffffffb
[    3.328012] Call Trace:
[    3.328012]  [<ffffffff81af09e4>] list_del+0x14/0x40
[    3.328012]  [<ffffffff82906471>] cpufreq_policy_free+0x41/0x80
[    3.328012]  [<ffffffff82907d1d>] cpufreq_add_dev+0x1fd/0x720
[    3.328012]  [<ffffffff81c81cf0>] subsys_interface_register+0x160/0x1b0
[    3.328012]  [<ffffffff831edd4f>] ? _raw_write_unlock_irqrestore+0xcf/0x130
[    3.328012]  [<ffffffff854fbfd4>] ? cpufreq_gov_dbs_init+0x20/0x20
[    3.328012]  [<ffffffff82909dcb>] cpufreq_register_driver+0x14b/0x2f0
[    3.328012]  [<ffffffff854fc133>] acpi_cpufreq_init+0x15f/0x33f
[    3.328012]  [<ffffffff8546ba92>] do_one_initcall+0xdb/0x24e
[    3.328012]  [<ffffffff810f9815>] ? parse_args+0x4a5/0x710
[    3.328012]  [<ffffffff8546be32>] kernel_init_freeable+0x22d/0x364
[    3.328012]  [<ffffffff8546ac42>] ? do_early_param+0x111/0x111
[    3.328012]  [<ffffffff83186670>] ? rest_init+0x230/0x230
[    3.328012]  [<ffffffff83186685>] kernel_init+0x15/0x290
[    3.328012]  [<ffffffff831ef2aa>] ret_from_fork+0x7a/0xb0
[    3.328012]  [<ffffffff83186670>] ? rest_init+0x230/0x230
[    3.328012] Code: 5d d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d f8 c9 c3 0f 1f 80 00 00 00 00 48 ff 05 d9 a2 8a 04 31 db 48 c7 c7 68 4a a8 84 <4d> 39 26 0f 95 c3 31 d2 48 ff 05 c9 a2 8a 04 89 de e8 e2 74 6e 
[    3.328012] RIP  [<ffffffff81af07f8>] __list_del_entry+0x148/0x320
[    3.328012]  RSP <ffff88000d84bd70>
[    3.328012] CR2: 0000000000000000
[    3.328012] ---[ end trace 25f94c56c98bedeb ]---
/kernel/x86_64-randconfig-s06-0810/01e3e82efc6742d5cf7ba14fb7a9bea318b386d8/dmesg-kvm-nhm4-3785-20130810180243-3.11.0-rc4-00424-g01e3e82-264

01e3e82efc6742d5cf7ba14fb7a9bea318b386d8 is the first bad commit
commit 01e3e82efc6742d5cf7ba14fb7a9bea318b386d8
Author: Lukasz Majewski <l.majewski@samsung.com>
Date:   Tue Aug 6 22:53:08 2013 +0530

    cpufreq: Store cpufreq policies in a list
    
    Policies available in the cpufreq framework are now linked together.
    They are accessible via cpufreq_policy_list defined in the cpufreq
    core.
    
    Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
    Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

:040000 040000 08075ce3f979b4cd96274f4aef027d90ccfc45aa 1237c7f80ea3fa791436b6282af5b196884f324f M	drivers
:040000 040000 82ac6721621325b12738880df4ca4d74ae0709c3 e2c89c8e2594707e41c8f9e2c000eb83b44693c2 M	include
bisect run success
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-s06-0810/linux-devel:devel-snb-x86_64-201308101718:b41d7a570aad4427ae5eab57f6cc86b89fb99c57:bisect-usb

2013-08-11-02:07:07 b41d7a570aad4427ae5eab57f6cc86b89fb99c57 reuse /kernel/x86_64-randconfig-s06-0810/b41d7a570aad4427ae5eab57f6cc86b89fb99c57/vmlinuz-3.11.0-rc4-00423-gb41d7a5

2013-08-11-02:07:07 detecting boot state ....	22	23	24.	25..	26.	27.	28....	29...	30.	32.	33..	34......	35	36	37	39	42.	53	63 SUCCESS

ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-s06-0810/linux-devel:devel-snb-x86_64-201308101718:36b054d81c3c6dedf005a0602959820ba9d15d93:bisect-usb
 TEST FAILURE
[    3.613489] Key type encrypted registered
[    3.615927] RIO: rio_register_scan for mport_id=-1
[    3.617750] BUG: unable to handle kernel NULL pointer dereference at           (null)
[    3.619512] IP: [<ffffffff81af0a18>] __list_del_entry+0x148/0x320
[    3.620876] PGD 0 
[    3.620876] Oops: 0000 [#1] PREEMPT 
[    3.620876] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-rc4-00455-g36b054d #4
[    3.620876] task: ffff88000d848040 ti: ffff88000d84a000 task.ti: ffff88000d84a000
[    3.620876] RIP: 0010:[<ffffffff81af0a18>]  [<ffffffff81af0a18>] __list_del_entry+0x148/0x320
[    3.620876] RSP: 0000:ffff88000d84bd70  EFLAGS: 00010046
[    3.620876] RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000000000000
[    3.620876] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff84aeaaa8
[    3.620876] RBP: ffff88000d84bd98 R08: 0000000000000000 R09: 0000000000000000
[    3.620876] R10: 00000000004ec000 R11: 0000000000000002 R12: ffff88000ea19ab8
[    3.620876] R13: 0000000000000000 R14: 0000000000000000 R15: dead000000200200
[    3.620876] FS:  0000000000000000(0000) GS:ffffffff841dc000(0000) knlGS:0000000000000000
[    3.620876] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    3.620876] CR2: 0000000000000000 CR3: 00000000041bf000 CR4: 00000000000006b0
[    3.620876] Stack:
[    3.620876]  ffff88000ea19ab8 0000000000000206 ffffffff841d1a88 0000000000000000
[    3.620876]  0000000000000000 ffff88000d84bdb0 ffffffff81af0c04 ffff88000ea19a00
[    3.620876]  ffff88000d84bdd0 ffffffff82928991 ffff88000ea19a00 00000000fffffffb
[    3.620876] Call Trace:
[    3.620876]  [<ffffffff81af0c04>] list_del+0x14/0x40
[    3.620876]  [<ffffffff82928991>] cpufreq_policy_free+0x41/0x80
[    3.620876]  [<ffffffff8292a5aa>] cpufreq_add_dev+0x4ba/0x730
[    3.620876]  [<ffffffff81c85380>] subsys_interface_register+0x160/0x1b0
[    3.620876]  [<ffffffff8321398f>] ? _raw_write_unlock_irqrestore+0xcf/0x130
[    3.620876]  [<ffffffff8556c3d4>] ? cpufreq_gov_dbs_init+0x20/0x20
[    3.620876]  [<ffffffff8292c4fb>] cpufreq_register_driver+0x14b/0x2f0
[    3.620876]  [<ffffffff8556c533>] acpi_cpufreq_init+0x15f/0x33f
[    3.620876]  [<ffffffff854dba92>] do_one_initcall+0xdb/0x24e
[    3.620876]  [<ffffffff810f97d5>] ? parse_args+0x4a5/0x710
[    3.620876]  [<ffffffff854dbe32>] kernel_init_freeable+0x22d/0x364
[    3.620876]  [<ffffffff854dac42>] ? do_early_param+0x111/0x111
[    3.620876]  [<ffffffff831ac130>] ? rest_init+0x230/0x230
[    3.620876]  [<ffffffff831ac145>] kernel_init+0x15/0x290
[    3.620876]  [<ffffffff83214eea>] ret_from_fork+0x7a/0xb0
[    3.620876]  [<ffffffff831ac130>] ? rest_init+0x230/0x230
[    3.620876] Code: 5d d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d f8 c9 c3 0f 1f 80 00 00 00 00 48 ff 05 b9 b2 91 04 31 db 48 c7 c7 a8 aa ae 84 <4d> 39 26 0f 95 c3 31 d2 48 ff 05 a9 b2 91 04 89 de e8 f2 71 6e 
[    3.620876] RIP  [<ffffffff81af0a18>] __list_del_entry+0x148/0x320
[    3.620876]  RSP <ffff88000d84bd70>
[    3.620876] CR2: 0000000000000000
[    3.620876] ---[ end trace 32552c752a0c8542 ]---
/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/dmesg-kvm-inn-10241-20130811000527-3.11.0-rc4-00162-g14e9419-136
/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/dmesg-kvm-inn-10745-20130811000517-3.11.0-rc4-00455-g36b054d-4
/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/dmesg-kvm-inn-11564-20130811000522-3.11.0-rc4-00220-gd8915fd-79
/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/dmesg-kvm-inn-6770-20130811000520-3.11.0-rc4-00010-gdb62efb-80
/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/dmesg-kvm-inn-7085-20130811000519-3.10.0-rc7-00713-g6716724-57
/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/dmesg-kvm-inn-8093-20130811000522-3.11.0-rc4-01733-g71ccacb-89
/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/dmesg-kvm-inn-8597-20130811000522-3.11.0-rc2-00399-g9ea8ab3-74
/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/dmesg-kvm-inn-9038-20130811000521-3.10.0-rc7-00701-gb89a1d3-72
/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/dmesg-kvm-inn-9731-20130811000520-3.11.0-rc2-00399-g9ea8ab3-47
/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/dmesg-kvm-lkp-snb01-34105-20130811000520-3.11.0-rc4-00010-gdb62efb-121
/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/dmesg-kvm-lkp-snb01-34382-20130810173343-3.11.0-rc4-00455-g36b054d-4
/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/dmesg-kvm-lkp-snb01-34718-20130811000520--
/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/dmesg-kvm-lkp-snb01-34757-20130811000521--
/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/dmesg-kvm-lkp-snb01-34782-20130811000516--
/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/dmesg-kvm-lkp-snb01-35448-20130811000509-3.11.0-rc4-00455-g36b054d-4
/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/dmesg-kvm-lkp-snb01-35678-20130811000525--
/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/dmesg-kvm-lkp-snb01-54645-20130811000525--
/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/dmesg-kvm-lkp-snb01-54661-20130811000520--
/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/dmesg-kvm-lkp-snb01-54802-20130811000526--
/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/dmesg-kvm-nhm4-4415-20130810160147-3.11.0-rc4-00455-g36b054d-4
/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/dmesg-kvm-snb-12229-20130810173342-3.11.0-rc4-00455-g36b054d-4
/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/dmesg-kvm-snb-15088-20130810173347-3.11.0-rc4-00171-gb080082-5
/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/dmesg-kvm-snb-6332-20130810173342-3.11.0-rc4-00455-g36b054d-4
/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/dmesg-kvm-snb-7948-20130810173354-3.11.0-rc4-00416-g93d477a-65
/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/dmesg-kvm-snb-8128-20130810173342-3.11.0-rc4-00455-g36b054d-16
/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/dmesg-kvm-snb-8464-20130810173346-3.11.0-rc3-00413-g6453599-72
/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/dmesg-kvm-snb-9463-20130810173402-3.11.0-rc4-00416-g9d538e7-46
/kernel/x86_64-randconfig-s06-0810/36b054d81c3c6dedf005a0602959820ba9d15d93/dmesg-kvm-xian-9058-20130810173321-3.11.0-rc4-00455-g36b054d-4

[detached HEAD 8288806] Revert "cpufreq: Store cpufreq policies in a list"
 2 files changed, 12 deletions(-)
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-s06-0810/linux-devel:devel-snb-x86_64-201308101718:828880617293703c5e3d4f9d22fbb68fc0c5692a:bisect-usb

2013-08-11-02:30:10 828880617293703c5e3d4f9d22fbb68fc0c5692a compiling

2013-08-11-02:36:40 detecting boot state 3.11.0-rc4-00851-g8288806.... TEST FAILURE
[    2.720011] 3.11.0-rc4-00851-g8288806 #265 Not tainted
[    2.720011] -------------------------------------
[    2.720011] swapper/1 is trying to release lock (cpufreq_rwsem) at:
[    2.720011] [<ffffffff82908ff5>] cpufreq_add_dev+0x475/0x6e0
[    2.720011] but there are no more locks to release!
[    2.720011] 
[    2.720011] other info that might help us debug this:
[    2.720011] 1 lock held by swapper/1:
[    2.720011]  #0:  (subsys mutex#4){+.+.+.}, at: [<ffffffff81c8239f>] subsys_interface_register+0xbf/0x1b0
[    2.720011] 
[    2.720011] stack backtrace:
[    2.720011] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-rc4-00851-g8288806 #265
[    2.720011]  ffffffff82908ff5 ffff88000d84bce0 ffffffff831ca464 ffff88000d84bd08
[    2.720011]  ffffffff81145a97 ffffffff84857a60 ffff88000d848040 ffffffff82908ff5
[    2.720011]  ffff88000d84bd80 ffffffff8114d8be ffff88000d848040 0000000000000006
[    2.720011] Call Trace:
[    2.720011]  [<ffffffff82908ff5>] ? cpufreq_add_dev+0x475/0x6e0
[    2.720011]  [<ffffffff831ca464>] dump_stack+0x2e/0x3e
[    2.720011]  [<ffffffff81145a97>] print_unlock_imbalance_bug+0x177/0x190
[    2.720011]  [<ffffffff82908ff5>] ? cpufreq_add_dev+0x475/0x6e0
[    2.720011]  [<ffffffff8114d8be>] lock_release_non_nested+0x29e/0x440
[    2.720011]  [<ffffffff8114884a>] ? mark_held_locks+0xca/0x1b0
[    2.720011]  [<ffffffff812796a8>] ? kfree+0x3d8/0x5d0
[    2.720011]  [<ffffffff82908ff5>] ? cpufreq_add_dev+0x475/0x6e0
[    2.720011]  [<ffffffff8114f879>] lock_release+0x139/0x560
[    2.720011]  [<ffffffff81105ecd>] up_read+0x2d/0x60
[    2.720011]  [<ffffffff82908ff5>] cpufreq_add_dev+0x475/0x6e0
[    2.720011]  [<ffffffff81c82440>] subsys_interface_register+0x160/0x1b0
[    2.720011]  [<ffffffff831f21ff>] ? _raw_write_unlock_irqrestore+0xcf/0x130
[    2.720011]  [<ffffffff85504337>] ? cpufreq_gov_dbs_init+0x20/0x20
[    2.720011]  [<ffffffff8290b75b>] cpufreq_register_driver+0x14b/0x2f0
[    2.720011]  [<ffffffff85504496>] acpi_cpufreq_init+0x15f/0x33f
[    2.720011]  [<ffffffff85473a92>] do_one_initcall+0xdb/0x24e
[    2.720011]  [<ffffffff810f9815>] ? parse_args+0x4a5/0x710
[    2.720011]  [<ffffffff85473e32>] kernel_init_freeable+0x22d/0x364
[    2.720011]  [<ffffffff85472c42>] ? do_early_param+0x111/0x111
[    2.720011]  [<ffffffff8318ade0>] ? rest_init+0x230/0x230
[    2.720011]  [<ffffffff8318adf5>] kernel_init+0x15/0x290
[    2.720011]  [<ffffffff831f376a>] ret_from_fork+0x7a/0xb0
[    2.720011]  [<ffffffff8318ade0>] ? rest_init+0x230/0x230
[    2.776038] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    2.784053] Freeing unused kernel memory: 1780K (ffffffff85472000 - ffffffff8562f000)
/kernel/x86_64-randconfig-s06-0810/828880617293703c5e3d4f9d22fbb68fc0c5692a/dmesg-kvm-lkp-snb01-45473-20130811023749-3.11.0-rc4-00851-g8288806-265


========= upstream =========
Fetching linus
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-s06-0810/linux-devel:devel-snb-x86_64-201308101718:8ae3f1d09566038606a18576604ecc957a935c48:bisect-usb

2013-08-11-02:38:47 8ae3f1d09566038606a18576604ecc957a935c48 compiling

2013-08-11-02:45:12 detecting boot state 3.11.0-rc4-00567-g8ae3f1d....	4	23	29	31.	33...	34..	35...	36	37	40.	42	43..	44	51	55	58	59....	60	62	63 SUCCESS


========= linux-next =========
Fetching next
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-s06-0810/linux-devel:devel-snb-x86_64-201308101718:4885431d34a1eebd8aee4130b350e339027ab71a:bisect-usb

2013-08-11-03:05:18 4885431d34a1eebd8aee4130b350e339027ab71a compiling
2013-08-11-03:12:10 4885431d34a1eebd8aee4130b350e339027ab71a SKIP BROKEN BUILD
Check erros in /cc/wfg/usb-bisect and /tmp/kernel/x86_64-randconfig-s06-0810/4885431d34a1eebd8aee4130b350e339027ab71a

--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.11.0-rc4-00455-g36b054d"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.11.0-rc4 Kernel Configuration
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
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
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
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
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
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
# CONFIG_RCU_NOCB_CPU_ZERO is not set
CONFIG_RCU_NOCB_CPU_ALL=y
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
CONFIG_CGROUP_HUGETLB=y
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_IPC_NS is not set
CONFIG_USER_NS=y
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
CONFIG_UIDGID_CONVERTED=y
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
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
CONFIG_ELF_CORE=y
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
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
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
CONFIG_HAVE_CLK=y
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
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_AIX_PARTITION=y
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
# CONFIG_MSDOS_PARTITION is not set
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_INTEL_LPSS=y
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
CONFIG_MEMTEST=y
CONFIG_MK8=y
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
# CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
# CONFIG_I8K is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
CONFIG_MICROCODE_INTEL_EARLY=y
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_MICROCODE_EARLY=y
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
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
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_ZBUD is not set
# CONFIG_MEM_SOFT_DIRTY is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
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
CONFIG_ACPI_EC_DEBUGFS=y
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
# CONFIG_ACPI_BUTTON is not set
# CONFIG_ACPI_VIDEO is not set
# CONFIG_ACPI_FAN is not set
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=y
CONFIG_ACPI_BGRT=y
CONFIG_ACPI_APEI=y
# CONFIG_ACPI_APEI_GHES is not set
# CONFIG_ACPI_APEI_PCIEAER is not set
# CONFIG_ACPI_APEI_EINJ is not set
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
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
CONFIG_X86_INTEL_PSTATE=y
CONFIG_X86_PCC_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ_CPB=y
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=y
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
# CONFIG_ISA_DMA_API is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
CONFIG_YENTA=y
# CONFIG_YENTA_O2 is not set
# CONFIG_YENTA_RICOH is not set
# CONFIG_YENTA_TI is not set
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=y
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=y
# CONFIG_RAPIDIO_TSI721 is not set
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
# CONFIG_RAPIDIO_DMA_ENGINE is not set
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_ENUM_BASIC=y

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=y
CONFIG_RAPIDIO_CPS_XX=y
# CONFIG_RAPIDIO_TSI568 is not set
CONFIG_RAPIDIO_CPS_GEN2=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_KEYS_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
CONFIG_NET_IPGRE=y
CONFIG_ARPD=y
# CONFIG_SYN_COOKIES is not set
CONFIG_INET_AH=y
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=y
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
# CONFIG_TCP_CONG_HYBLA is not set
CONFIG_TCP_CONG_VEGAS=y
# CONFIG_TCP_CONG_SCALABLE is not set
CONFIG_TCP_CONG_LP=y
# CONFIG_TCP_CONG_VENO is not set
CONFIG_TCP_CONG_YEAH=y
# CONFIG_TCP_CONG_ILLINOIS is not set
# CONFIG_DEFAULT_BIC is not set
# CONFIG_DEFAULT_CUBIC is not set
CONFIG_DEFAULT_HTCP=y
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="htcp"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETWORK_PHY_TIMESTAMPING=y
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=y

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
# CONFIG_IP_DCCP_CCID3 is not set

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
CONFIG_IP_SCTP=y
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_RDS=y
CONFIG_RDS_RDMA=y
CONFIG_RDS_TCP=y
CONFIG_RDS_DEBUG=y
CONFIG_TIPC=y
CONFIG_TIPC_PORTS=8191
CONFIG_TIPC_MEDIA_IB=y
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=y
CONFIG_ATM_MPOA=y
CONFIG_ATM_BR2684=y
CONFIG_ATM_BR2684_IPFILTER=y
CONFIG_L2TP=y
# CONFIG_L2TP_DEBUGFS is not set
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=y
# CONFIG_L2TP_ETH is not set
CONFIG_STP=y
CONFIG_MRP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
# CONFIG_DEV_APPLETALK is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_PHONET=y
CONFIG_IEEE802154=y
# CONFIG_MAC802154 is not set
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=y
CONFIG_OPENVSWITCH_GRE=y
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_NET_DROP_MONITOR is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
# CONFIG_AX25_DAMA_SLAVE is not set
CONFIG_NETROM=y
CONFIG_ROSE=y

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
# CONFIG_6PACK is not set
CONFIG_BPQETHER=y
# CONFIG_BAYCOM_SER_FDX is not set
# CONFIG_BAYCOM_SER_HDX is not set
# CONFIG_YAM is not set
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
CONFIG_IRNET=y
# CONFIG_IRCOMM is not set
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
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

#
# FIR device drivers
#
CONFIG_VLSI_FIR=y
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
# CONFIG_BT_RFCOMM_TTY is not set
# CONFIG_BT_BNEP is not set
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIDTL1=y
CONFIG_BT_HCIBT3C=y
CONFIG_BT_HCIBLUECARD=y
CONFIG_BT_HCIBTUART=y
# CONFIG_BT_HCIVHCI is not set
# CONFIG_BT_MRVL is not set
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
# CONFIG_RXKAD is not set
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
# CONFIG_CFG80211_REG_DEBUG is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=y
# CONFIG_MAC80211_RC_PID is not set
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT=""

#
# Some wireless drivers require a rate control algorithm
#
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
CONFIG_MAC80211_DEBUG_MENU=y
# CONFIG_MAC80211_NOINLINE is not set
# CONFIG_MAC80211_VERBOSE_DEBUG is not set
CONFIG_MAC80211_MLME_DEBUG=y
# CONFIG_MAC80211_STA_DEBUG is not set
CONFIG_MAC80211_HT_DEBUG=y
# CONFIG_MAC80211_IBSS_DEBUG is not set
CONFIG_MAC80211_PS_DEBUG=y
CONFIG_MAC80211_MPL_DEBUG=y
# CONFIG_MAC80211_MPATH_DEBUG is not set
CONFIG_MAC80211_MHWMP_DEBUG=y
CONFIG_MAC80211_MESH_SYNC_DEBUG=y
CONFIG_MAC80211_MESH_PS_DEBUG=y
# CONFIG_MAC80211_TDLS_DEBUG is not set
CONFIG_MAC80211_DEBUG_COUNTERS=y
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
CONFIG_RFKILL_REGULATOR=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_NET_9P_RDMA=y
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
# CONFIG_CAIF_NETDEV is not set
CONFIG_CAIF_USB=y
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
CONFIG_NFC=y
# CONFIG_NFC_NCI is not set
CONFIG_NFC_HCI=y
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_SIM=y
CONFIG_NFC_PN544=y
CONFIG_NFC_MICROREAD=y
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
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=y
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
# CONFIG_FTL is not set
CONFIG_NFTL=y
# CONFIG_NFTL_RW is not set
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
CONFIG_SSFDC=y
CONFIG_SM_FTL=y
CONFIG_MTD_OOPS=y

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
# CONFIG_MTD_JEDECPROBE is not set
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
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_INTEL_VR_NOR=y
CONFIG_MTD_PLATRAM=y

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
CONFIG_MTD_PMC551_BUGFIX=y
# CONFIG_MTD_PMC551_DEBUG is not set
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
CONFIG_MTD_BLOCK2MTD=y

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
CONFIG_MTD_NAND_DENALI_PCI=y
CONFIG_MTD_NAND_DENALI_DT=y
CONFIG_MTD_NAND_DENALI_SCRATCH_REG_ADDR=0xFF108018
CONFIG_MTD_NAND_IDS=y
CONFIG_MTD_NAND_RICOH=y
CONFIG_MTD_NAND_DISKONCHIP=y
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
CONFIG_MTD_NAND_DOCG4=y
CONFIG_MTD_NAND_CAFE=y
# CONFIG_MTD_NAND_NANDSIM is not set
CONFIG_MTD_NAND_PLATFORM=y
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
# CONFIG_MTD_ONENAND_GENERIC is not set
CONFIG_MTD_ONENAND_OTP=y
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
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
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_ATMEL_PWM=y
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ATMEL_SSC=y
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_HP_ILO=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_PCH_PHUB=y
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_93CX6=y
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#

#
# Altera FPGA firmware download module
#
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=y
# CONFIG_IDE_GD_ATA is not set
CONFIG_IDE_GD_ATAPI=y
CONFIG_BLK_DEV_IDECS=y
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_PLATFORM=y
CONFIG_BLK_DEV_CMD640=y
CONFIG_BLK_DEV_CMD640_ENHANCED=y
CONFIG_BLK_DEV_IDEPNP=y
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=y
CONFIG_BLK_DEV_OPTI621=y
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
CONFIG_BLK_DEV_ALI15X3=y
CONFIG_BLK_DEV_AMD74XX=y
CONFIG_BLK_DEV_ATIIXP=y
CONFIG_BLK_DEV_CMD64X=y
CONFIG_BLK_DEV_TRIFLEX=y
CONFIG_BLK_DEV_CS5520=y
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT366 is not set
CONFIG_BLK_DEV_JMICRON=y
CONFIG_BLK_DEV_SC1200=y
# CONFIG_BLK_DEV_PIIX is not set
CONFIG_BLK_DEV_IT8172=y
CONFIG_BLK_DEV_IT8213=y
CONFIG_BLK_DEV_IT821X=y
CONFIG_BLK_DEV_NS87415=y
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
CONFIG_BLK_DEV_SVWKS=y
# CONFIG_BLK_DEV_SIIMAGE is not set
CONFIG_BLK_DEV_SIS5513=y
CONFIG_BLK_DEV_SLC90E66=y
CONFIG_BLK_DEV_TRM290=y
CONFIG_BLK_DEV_VIA82CXXX=y
CONFIG_BLK_DEV_TC86C001=y
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y

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
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_ISCSI_BOOT_SYSFS=y
CONFIG_SCSI_CXGB3_ISCSI=y
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
CONFIG_SCSI_BNX2X_FCOE=y
# CONFIG_BE2ISCSI is not set
CONFIG_BLK_DEV_3W_XXXX_RAID=y
CONFIG_SCSI_HPSA=y
CONFIG_SCSI_3W_9XXX=y
CONFIG_SCSI_3W_SAS=y
CONFIG_SCSI_ACARD=y
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC7XXX_OLD=y
# CONFIG_SCSI_AIC79XX is not set
CONFIG_SCSI_AIC94XX=y
CONFIG_AIC94XX_DEBUG=y
CONFIG_SCSI_MVSAS=y
# CONFIG_SCSI_MVSAS_DEBUG is not set
CONFIG_SCSI_MVSAS_TASKLET=y
CONFIG_SCSI_MVUMI=y
CONFIG_SCSI_DPT_I2O=y
CONFIG_SCSI_ADVANSYS=y
CONFIG_SCSI_ARCMSR=y
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
CONFIG_MEGARAID_LEGACY=y
# CONFIG_MEGARAID_SAS is not set
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS_LOGGING=y
# CONFIG_SCSI_MPT3SAS is not set
CONFIG_SCSI_UFSHCD=y
CONFIG_SCSI_UFSHCD_PCI=y
CONFIG_SCSI_UFSHCD_PLATFORM=y
# CONFIG_SCSI_HPTIOP is not set
CONFIG_VMWARE_PVSCSI=y
CONFIG_HYPERV_STORAGE=y
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
CONFIG_FCOE=y
# CONFIG_FCOE_FNIC is not set
CONFIG_SCSI_DMX3191D=y
CONFIG_SCSI_FUTURE_DOMAIN=y
CONFIG_SCSI_ISCI=y
CONFIG_SCSI_IPS=y
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_DC395x=y
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_DEBUG=y
CONFIG_SCSI_PMCRAID=y
CONFIG_SCSI_PM8001=y
# CONFIG_SCSI_SRP is not set
CONFIG_SCSI_BFA_FC=y
CONFIG_SCSI_VIRTIO=y
CONFIG_SCSI_CHELSIO_FCOE=y
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
CONFIG_TARGET_CORE=y
# CONFIG_TCM_IBLOCK is not set
CONFIG_TCM_FILEIO=y
# CONFIG_TCM_PSCSI is not set
# CONFIG_LOOPBACK_TARGET is not set
CONFIG_TCM_FC=y
CONFIG_ISCSI_TARGET=y
CONFIG_SBP_TARGET=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_SBP2=y
CONFIG_FIREWIRE_NET=y
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
# CONFIG_I2O_EXT_ADAPTEC is not set
CONFIG_I2O_CONFIG=y
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
CONFIG_I2O_BUS=y
CONFIG_I2O_BLOCK=y
CONFIG_I2O_SCSI=y
CONFIG_I2O_PROC=y
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
# CONFIG_NET_CORE is not set
# CONFIG_ARCNET is not set
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#
# CONFIG_CAIF_TTY is not set
CONFIG_CAIF_SPI_SLAVE=y
CONFIG_CAIF_SPI_SYNC=y
CONFIG_CAIF_HSI=y
CONFIG_CAIF_VIRTIO=y
# CONFIG_VHOST_NET is not set
CONFIG_VHOST_RING=y

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
# CONFIG_NET_DSA_MV88E6060 is not set
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=y
CONFIG_ACENIC_OMIT_TIGON_I=y
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_VENDOR_ARC is not set
# CONFIG_NET_VENDOR_ATHEROS is not set
# CONFIG_NET_CADENCE is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
CONFIG_BNX2=y
CONFIG_CNIC=y
CONFIG_TIGON3=y
CONFIG_BNX2X=y
CONFIG_BNX2X_SRIOV=y
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=y
CONFIG_NET_CALXEDA_XGMAC=y
CONFIG_NET_VENDOR_CHELSIO=y
CONFIG_CHELSIO_T1=y
# CONFIG_CHELSIO_T1_1G is not set
CONFIG_CHELSIO_T3=y
CONFIG_CHELSIO_T4=y
CONFIG_CHELSIO_T4VF=y
# CONFIG_NET_VENDOR_CISCO is not set
# CONFIG_DNET is not set
# CONFIG_NET_VENDOR_DEC is not set
# CONFIG_NET_VENDOR_DLINK is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=y
CONFIG_NET_VENDOR_EXAR=y
CONFIG_S2IO=y
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_FUJITSU=y
# CONFIG_PCMCIA_FMVJ18X is not set
CONFIG_NET_VENDOR_HP=y
CONFIG_HP100=y
# CONFIG_NET_VENDOR_INTEL is not set
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
# CONFIG_NET_VENDOR_MARVELL is not set
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_EN=y
# CONFIG_MLX4_EN_DCB is not set
CONFIG_MLX4_CORE=y
# CONFIG_MLX4_DEBUG is not set
CONFIG_MLX5_CORE=y
CONFIG_MLX5_DEBUG=y
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8851_MLL=y
CONFIG_KSZ884X_PCI=y
# CONFIG_NET_VENDOR_MYRI is not set
CONFIG_FEALNX=y
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
# CONFIG_NET_VENDOR_OKI is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
CONFIG_NETXEN_NIC=y
# CONFIG_NET_VENDOR_REALTEK is not set
CONFIG_SH_ETH=y
# CONFIG_NET_VENDOR_RDC is not set
# CONFIG_NET_VENDOR_SEEQ is not set
CONFIG_NET_VENDOR_SILAN=y
CONFIG_SC92031=y
CONFIG_NET_VENDOR_SIS=y
CONFIG_SIS900=y
# CONFIG_SIS190 is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
CONFIG_PCMCIA_SMC91C92=y
CONFIG_EPIC100=y
CONFIG_SMSC911X=y
# CONFIG_SMSC911X_ARCH_HOOKS is not set
CONFIG_SMSC9420=y
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
# CONFIG_NET_VENDOR_SUN is not set
CONFIG_NET_VENDOR_TEHUTI=y
CONFIG_TEHUTI=y
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
CONFIG_NET_VENDOR_XIRCOM=y
# CONFIG_PCMCIA_XIRC2PS is not set
CONFIG_FDDI=y
CONFIG_DEFXX=y
CONFIG_DEFXX_MMIO=y
# CONFIG_SKFP is not set
# CONFIG_HIPPI is not set
CONFIG_NET_SB1000=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
# CONFIG_AMD_PHY is not set
CONFIG_MARVELL_PHY=y
# CONFIG_DAVICOM_PHY is not set
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=y
# CONFIG_BROADCOM_PHY is not set
CONFIG_BCM87XX_PHY=y
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
CONFIG_LSI_ET1011C_PHY=y
# CONFIG_MICREL_PHY is not set
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
CONFIG_PPP=y
# CONFIG_PPP_BSDCOMP is not set
# CONFIG_PPP_DEFLATE is not set
# CONFIG_PPP_FILTER is not set
CONFIG_PPP_MPPE=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=y
CONFIG_PPPOE=y
CONFIG_PPTP=y
CONFIG_PPPOL2TP=y
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y
CONFIG_WLAN=y
CONFIG_PCMCIA_RAYCS=y
# CONFIG_LIBERTAS_THINFIRM is not set
CONFIG_ATMEL=y
CONFIG_PCI_ATMEL=y
# CONFIG_PCMCIA_ATMEL is not set
CONFIG_AIRO_CS=y
CONFIG_PCMCIA_WL3501=y
CONFIG_PRISM54=y
# CONFIG_RTL8180 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
CONFIG_ATH_COMMON=y
CONFIG_ATH_CARDS=y
# CONFIG_ATH_DEBUG is not set
CONFIG_ATH5K=y
# CONFIG_ATH5K_DEBUG is not set
# CONFIG_ATH5K_TRACER is not set
CONFIG_ATH5K_PCI=y
CONFIG_ATH9K_HW=y
CONFIG_ATH9K_COMMON=y
# CONFIG_ATH9K_BTCOEX_SUPPORT is not set
CONFIG_ATH9K=y
CONFIG_ATH9K_PCI=y
# CONFIG_ATH9K_AHB is not set
# CONFIG_ATH9K_DEBUGFS is not set
CONFIG_ATH9K_LEGACY_RATE_CONTROL=y
# CONFIG_ATH6KL is not set
CONFIG_WIL6210=y
# CONFIG_WIL6210_ISR_COR is not set
CONFIG_WIL6210_TRACING=y
CONFIG_ATH10K=y
# CONFIG_ATH10K_PCI is not set
# CONFIG_ATH10K_DEBUG is not set
CONFIG_ATH10K_DEBUGFS=y
CONFIG_ATH10K_TRACING=y
# CONFIG_B43 is not set
CONFIG_B43LEGACY=y
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_HWRNG=y
CONFIG_B43LEGACY_DEBUG=y
CONFIG_B43LEGACY_DMA=y
CONFIG_B43LEGACY_PIO=y
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
CONFIG_BRCMUTIL=y
CONFIG_BRCMSMAC=y
CONFIG_BRCMFMAC=y
# CONFIG_BRCM_TRACING is not set
CONFIG_BRCMDBG=y
CONFIG_HOSTAP=y
# CONFIG_HOSTAP_FIRMWARE is not set
# CONFIG_HOSTAP_PLX is not set
CONFIG_HOSTAP_PCI=y
CONFIG_HOSTAP_CS=y
CONFIG_IPW2100=y
# CONFIG_IPW2100_MONITOR is not set
CONFIG_IPW2100_DEBUG=y
CONFIG_LIBIPW=y
CONFIG_LIBIPW_DEBUG=y
CONFIG_IWLWIFI=y
CONFIG_IWLDVM=y
# CONFIG_IWLMVM is not set

#
# Debugging Options
#
# CONFIG_IWLWIFI_DEBUG is not set
# CONFIG_IWLWIFI_DEBUGFS is not set
# CONFIG_IWLWIFI_DEVICE_TRACING is not set
CONFIG_IWLWIFI_P2P=y
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
CONFIG_LIBERTAS=y
CONFIG_LIBERTAS_CS=y
# CONFIG_LIBERTAS_DEBUG is not set
CONFIG_LIBERTAS_MESH=y
CONFIG_P54_COMMON=y
CONFIG_P54_PCI=y
CONFIG_P54_LEDS=y
CONFIG_RT2X00=y
CONFIG_RT2400PCI=y
CONFIG_RT2500PCI=y
CONFIG_RT61PCI=y
CONFIG_RT2800PCI=y
CONFIG_RT2800PCI_RT33XX=y
CONFIG_RT2800PCI_RT35XX=y
# CONFIG_RT2800PCI_RT53XX is not set
CONFIG_RT2800PCI_RT3290=y
CONFIG_RT2800_LIB=y
CONFIG_RT2X00_LIB_MMIO=y
CONFIG_RT2X00_LIB_PCI=y
CONFIG_RT2X00_LIB=y
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
CONFIG_RT2X00_LIB_DEBUGFS=y
CONFIG_RT2X00_DEBUG=y
# CONFIG_RTL_CARDS is not set
CONFIG_WL_TI=y
CONFIG_WL1251=y
CONFIG_WL12XX=y
CONFIG_WL18XX=y
CONFIG_WLCORE=y
CONFIG_MWIFIEX=y
# CONFIG_MWIFIEX_PCIE is not set
# CONFIG_CW1200 is not set

#
# WiMAX Wireless Broadband devices
#

#
# Enable USB support to see WiMAX USB drivers
#
# CONFIG_WAN is not set
# CONFIG_IEEE802154_DRIVERS is not set
CONFIG_VMXNET3=y
CONFIG_HYPERV_NET=y
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=y
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=y
# CONFIG_JOYSTICK_IFORCE_232 is not set
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_FUJITSU=y
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_W90X900=y
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
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
# CONFIG_SERIAL_8250_CS is not set
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
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_ATMEL=y
CONFIG_HW_RANDOM_VIA=y
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_HW_RANDOM_EXYNOS=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=y
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
# CONFIG_I2C is not set
# CONFIG_SPI is not set
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
# CONFIG_PPS_DEBUG is not set
CONFIG_NTP_PPS=y

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_DP83640_PHY=y
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS1WM=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
# CONFIG_W1_SLAVE_DS2780 is not set
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_GENERIC_ADC_BATTERY is not set
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_CHARGER_MAX8903=y
# CONFIG_BATTERY_GOLDFISH is not set
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IBMAEM=y
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_APPLESMC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
CONFIG_SENSORS_ATK0110=y
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_CPU_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
CONFIG_INTEL_POWERCLAMP=y

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_CROS_EC=y
CONFIG_HTC_PASIC3=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_SM501=y
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_CONTIG=y
CONFIG_VIDEO_V4L2_INT_DEVICE=y

#
# Media drivers
#
CONFIG_RC_CORE=y
CONFIG_RC_MAP=y
CONFIG_RC_DECODERS=y
CONFIG_LIRC=y
CONFIG_IR_LIRC_CODEC=y
CONFIG_IR_NEC_DECODER=y
# CONFIG_IR_RC5_DECODER is not set
# CONFIG_IR_RC6_DECODER is not set
# CONFIG_IR_JVC_DECODER is not set
# CONFIG_IR_SONY_DECODER is not set
CONFIG_IR_RC5_SZ_DECODER=y
# CONFIG_IR_SANYO_DECODER is not set
CONFIG_IR_MCE_KBD_DECODER=y
CONFIG_RC_DEVICES=y
# CONFIG_RC_ATI_REMOTE is not set
CONFIG_IR_ENE=y
# CONFIG_IR_IMON is not set
# CONFIG_IR_MCEUSB is not set
CONFIG_IR_ITE_CIR=y
CONFIG_IR_FINTEK=y
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
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set

#
# Encoders, decoders, sensors and other helper chips
#

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

#
# Customize TV tuners
#

#
# Customise DVB Frontends
#

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=y

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
# CONFIG_FB is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_ATMEL_PWM=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_APPLE=y
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
CONFIG_HID_AUREAL=y
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MICROSOFT is not set
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
# CONFIG_HID_PICOLCD_LEDS is not set
# CONFIG_HID_PICOLCD_CIR is not set
CONFIG_HID_PRIMAX=y
CONFIG_HID_SAITEK=y
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
# CONFIG_HID_HYPERV_MOUSE is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=y
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_ATMEL_PWM is not set
CONFIG_LEDS_REGULATOR=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_OT200=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_ACCESSIBILITY=y
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=y
CONFIG_INFINIBAND_MTHCA_DEBUG=y
# CONFIG_INFINIBAND_QIB is not set
CONFIG_INFINIBAND_AMSO1100=y
CONFIG_INFINIBAND_AMSO1100_DEBUG=y
CONFIG_INFINIBAND_CXGB3=y
CONFIG_INFINIBAND_CXGB3_DEBUG=y
# CONFIG_INFINIBAND_CXGB4 is not set
CONFIG_MLX4_INFINIBAND=y
CONFIG_MLX5_INFINIBAND=y
CONFIG_INFINIBAND_NES=y
CONFIG_INFINIBAND_NES_DEBUG=y
CONFIG_INFINIBAND_OCRDMA=y
CONFIG_INFINIBAND_IPOIB=y
# CONFIG_INFINIBAND_IPOIB_CM is not set
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=y
CONFIG_INFINIBAND_SRPT=y
CONFIG_INFINIBAND_ISER=y
CONFIG_INFINIBAND_ISERT=y
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV=y
CONFIG_UIO_PDRV_GENIRQ=y
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
# CONFIG_UIO_PCI_GENERIC is not set
CONFIG_UIO_NETX=y
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
CONFIG_HYPERV=y
# CONFIG_HYPERV_BALLOON is not set
CONFIG_STAGING=y
CONFIG_ET131X=y
CONFIG_SLICOSS=y
# CONFIG_ECHO is not set
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

#
# Analog digital bi-direction converters
#

#
# Capacitance to digital converters
#

#
# Direct Digital Synthesis
#

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#

#
# Light sensors
#

#
# Magnetometer sensors
#

#
# Active energy metering IC
#

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
CONFIG_IIO_SIMPLE_DUMMY=y
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
# CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set
CONFIG_ZSMALLOC=y
CONFIG_ZRAM=y
# CONFIG_ZRAM_DEBUG is not set
CONFIG_WLAGS49_H2=y
# CONFIG_WLAGS49_H25 is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_FT1000=y
# CONFIG_FT1000_PCMCIA is not set

#
# Speakup console speech
#
CONFIG_STAGING_MEDIA=y
CONFIG_VIDEO_DT3155=y
# CONFIG_DT3155_CCIR is not set
# CONFIG_DT3155_STREAMING is not set
# CONFIG_LIRC_STAGING is not set

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
CONFIG_ANDROID_LOGGER=y
# CONFIG_ANDROID_TIMED_OUTPUT is not set
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
# CONFIG_SYNC is not set
# CONFIG_NET_VENDOR_SILICOM is not set
# CONFIG_DGRP is not set
# CONFIG_FIREWIRE_SERIAL is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
CONFIG_ACERHDF=y
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_DELL_WMI is not set
CONFIG_DELL_WMI_AIO=y
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
CONFIG_HP_WMI=y
CONFIG_PANASONIC_LAPTOP=y
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
CONFIG_TOPSTAR_LAPTOP=y
CONFIG_ACPI_TOSHIBA=y
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
CONFIG_INTEL_IPS=y
# CONFIG_IBM_RTL is not set
CONFIG_XO15_EBOOK=y
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=y
CONFIG_SAMSUNG_Q10=y
CONFIG_APPLE_GMUX=y
CONFIG_INTEL_RST=y
CONFIG_INTEL_SMARTCONNECT=y
# CONFIG_PVPANIC is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
CONFIG_COMMON_CLK_DEBUG=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set
CONFIG_DMAR_TABLE=y
# CONFIG_INTEL_IOMMU is not set
CONFIG_IRQ_REMAP=y

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
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
# CONFIG_HID_SENSOR_ACCEL_3D is not set

#
# Analog to digital converters
#

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS=y

#
# Digital to analog converters
#

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
# CONFIG_HID_SENSOR_GYRO_3D is not set

#
# Inertial measurement units
#

#
# Light sensors
#
CONFIG_HID_SENSOR_ALS=y

#
# Magnetometer sensors
#
# CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure Sensors
#
# CONFIG_NTB is not set
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
CONFIG_VME_TSI148=y

#
# VME Board Drivers
#
# CONFIG_VMIVME_7805 is not set

#
# VME Device Drivers
#
CONFIG_VME_USER=y
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
CONFIG_FMC_TRIVIAL=y
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_VARS_PSTORE=y
# CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
CONFIG_EXT2_FS_XIP=y
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
CONFIG_FS_XIP=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=y
CONFIG_OCFS2_FS=y
# CONFIG_OCFS2_FS_O2CB is not set
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_OCFS2_DEBUG_FS=y
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
CONFIG_BTRFS_DEBUG=y
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_DEBUG=y
CONFIG_CACHEFILES=y
CONFIG_CACHEFILES_DEBUG=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
# CONFIG_ZISOFS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
CONFIG_ADFS_FS_RW=y
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
CONFIG_BEFS_FS=y
CONFIG_BEFS_DEBUG=y
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
# CONFIG_JFFS2_SUMMARY is not set
CONFIG_JFFS2_FS_XATTR=y
CONFIG_JFFS2_FS_POSIX_ACL=y
# CONFIG_JFFS2_FS_SECURITY is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
CONFIG_JFFS2_RUBIN=y
# CONFIG_JFFS2_CMODE_NONE is not set
# CONFIG_JFFS2_CMODE_PRIORITY is not set
# CONFIG_JFFS2_CMODE_SIZE is not set
CONFIG_JFFS2_CMODE_FAVOURLZO=y
CONFIG_UBIFS_FS=y
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZO is not set
# CONFIG_SQUASHFS_XZ is not set
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=y
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
CONFIG_UFS_DEBUG=y
CONFIG_EXOFS_FS=y
CONFIG_EXOFS_DEBUG=y
# CONFIG_F2FS_FS is not set
CONFIG_EFIVAR_FS=y
CONFIG_ORE=y
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NFS_FS is not set
CONFIG_NFSD=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_SUNRPC_XPRT_RDMA=y
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_CEPH_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
CONFIG_AFS_FS=y
# CONFIG_AFS_DEBUG is not set
# CONFIG_AFS_FSCACHE is not set
CONFIG_9P_FS=y
CONFIG_9P_FSCACHE=y
# CONFIG_9P_FS_POSIX_ACL is not set
# CONFIG_9P_FS_SECURITY is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

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
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_DEBUG_SLAB=y
CONFIG_DEBUG_SLAB_LEAK=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_DEBUG_PREEMPT=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
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
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
# CONFIG_PROVE_RCU_DELAY is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_VERBOSE=y
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_FAULT_INJECTION is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
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
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
# CONFIG_TRACER_SNAPSHOT is not set
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
# CONFIG_STACK_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_FIREWIRE_OHCI_REMOTE_DMA=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
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
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_XOR=y
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
CONFIG_CRYPTO_USER=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
# CONFIG_X509_CERTIFICATE_PARSER is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
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
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y

--4Ckj6UjgE2iN1+kY--
