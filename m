Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbaCZOlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 10:41:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:45768 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083AbaCZOlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 10:41:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,735,1389772800"; 
   d="scan'208";a="499947883"
Date: Wed, 26 Mar 2014 22:40:53 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [KVM] BUG: unable to handle kernel NULL pointer dereference at
 00000000000002b0
Message-ID: <20140326144053.GC26721@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Paolo,

We noticed the below kernel BUG on

git://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
commit 93c4adc7afedf9b0ec190066d45b6d67db5270da ("KVM: x86: handle missing MPX in nested virtualization")

[   17.665744] Freeing initrd memory: 213444K (ffff880072f82000 - ffff88007fff3000)
[   17.674933] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[   17.682659] software IO TLB [mem 0xb73c7000-0xbb3c7000] (64MB) mapped at [ffff8800b73c7000-ffff8800bb3c6fff]
[   17.695661] BUG: unable to handle kernel NULL pointer dereference at 00000000000002b0
[   17.705465] IP: [<ffffffff81015a9f>] kvm_arch_init+0x12a/0x1ea                       
[   17.712577] PGD 0
[   17.715390] Oops: 0000 [#1] SMP
[   17.719654] Modules linked in:
[   17.723641] CPU: 10 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc7-03020-ga929a7d #1
[   17.733067] Hardware name: Intel Corporation LH Pass/S4600LH...., BIOS SE5C600.86B.99.02.1047.032320122259 03/23/2012
[   17.745821] task: ffff880429cb0000 ti: ffff880429ca4000 task.ti: ffff880429ca4000                                    
[   17.755039] RIP: 0010:[<ffffffff81015a9f>]  [<ffffffff81015a9f>] kvm_arch_init+0x12a/0x1ea
[   17.765228] RSP: 0000:ffff880429ca5e00  EFLAGS: 00010246
[   17.771644] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[   17.780096] RDX: 0000000000000000 RSI: ffff880429ca5e04 RDI: 0000000000000d90
[   17.788549] RBP: ffff880429ca5e30 R08: ffff88082fc55d00 R09: ffff88042f803e00
[   17.796993] R10: 0000000000000004 R11: 0000000000000003 R12: 000000000000000c
[   17.805449] R13: 0000000000000017 R14: ffffffff82018b10 R15: 0000000000000018
[   17.813907] FS:  0000000000000000(0000) GS:ffff88082fc40000(0000) knlGS:0000000000000000
[   17.823808] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   17.830693] CR2: 00000000000002b0 CR3: 000000000200f000 CR4: 00000000000407e0
[   17.839159] Stack:
[   17.841873]  0000000000000000 0000000000000040 0000000000000000 0000000000003f40
[   17.851328]  0000000000000000 0000000000000000 ffff880429ca5e68 ffffffff810039dc
[   17.860790]  00000000000164d8 0000000000000006 0000000000000000 000000000000023c
[   17.870256] Call Trace:
[   17.873468]  [<ffffffff810039dc>] kvm_init+0x1f/0x24a
[   17.879599]  [<ffffffff82154fa4>] vmx_init+0x1df/0x3f6
[   17.885825]  [<ffffffff82154dc5>] ? vmx_check_processor_compat+0x61/0x61
[   17.893782]  [<ffffffff810002d2>] do_one_initcall+0xa4/0x13a
[   17.900604]  [<ffffffff810f9aa9>] ? parse_args+0x25f/0x33d
[   17.907225]  [<ffffffff8214ff94>] kernel_init_freeable+0x1a9/0x22e
[   17.914615]  [<ffffffff8214f78f>] ? do_early_param+0x88/0x88
[   17.921433]  [<ffffffff819af0d5>] ? rest_init+0x89/0x89
[   17.927731]  [<ffffffff819af0e3>] kernel_init+0xe/0xdf

Full dmesg is attached, and more details can be provided on your request.

Thanks,
Fengguang

--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc7-03020-ga929a7d (kbuild@inn) (gcc version 4.8.2 (Debian 4.8.2-16) ) #1 SMP Wed Mar 26 08:53:20 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/lkp-sbx04/bisect_boot-1-x86_64-lkp-a929a7dbfee6e4d1a8d272ac3ba7f20db9893856-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/a929a7dbfee6e4d1a8d272ac3ba7f20db9893856/vmlinuz-3.14.0-rc7-03020-ga929a7d kconfig=x86_64-lkp commit=a929a7dbfee6e4d1a8d272ac3ba7f20db9893856 modules_initrd=/kernel/x86_64-lkp/a929a7dbfee6e4d1a8d272ac3ba7f20db9893856/modules.cgz RESULT_ROOT=/lkp/result/lkp-sbx04/fake/boot/1/x86_64-lkp/a929a7dbfee6e4d1a8d272ac3ba7f20db9893856/0 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 ip=::::lkp-sbx04::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000008f3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000008f400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bb3c6fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bb3c7000-0x00000000bdd2efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bdd2f000-0x00000000bde26fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bde27000-0x00000000bdea0fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bdea1000-0x00000000bdf2efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bdf2f000-0x00000000bdfaffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bdfb0000-0x00000000bdffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000be000000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed19000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffa20000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000103fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: Intel Corporation LH Pass/S4600LH...., BIOS SE5C600.86B.99.02.1047.032320122259 03/23/2012
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x1040000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-through
[    0.000000]   D0000-D3FFF write-protect
[    0.000000]   D4000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask 3FFF80000000 write-back
[    0.000000]   1 base 000080000000 mask 3FFFC0000000 write-back
[    0.000000]   2 base 000100000000 mask 3FFF00000000 write-back
[    0.000000]   3 base 000200000000 mask 3FFE00000000 write-back
[    0.000000]   4 base 000400000000 mask 3FFC00000000 write-back
[    0.000000]   5 base 000800000000 mask 3FF800000000 write-back
[    0.000000]   6 base 001000000000 mask 3FFFC0000000 write-back
[    0.000000]   7 base 0000FF800000 mask 3FFFFF800000 write-protect
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: last_pfn = 0xbe000 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fd0f0-0x000fd0ff] mapped at [ffff8800000fd0f0]
[    0.000000]   mpc: fc870-fcf24
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000089000] 89000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0245f000, 0x0245ffff] PGTABLE
[    0.000000] BRK [0x02460000, 0x02460fff] PGTABLE
[    0.000000] BRK [0x02461000, 0x02461fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x103fe00000-0x103fffffff]
[    0.000000]  [mem 0x103fe00000-0x103fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x103c000000-0x103fdfffff]
[    0.000000]  [mem 0x103c000000-0x103fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x1000000000-0x103bffffff]
[    0.000000]  [mem 0x1000000000-0x103bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbb3c6fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0xbb1fffff] page 2M
[    0.000000]  [mem 0xbb200000-0xbb3c6fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbdfb0000-0xbdffffff]
[    0.000000]  [mem 0xbdfb0000-0xbdffffff] page 4k
[    0.000000] BRK [0x02462000, 0x02462fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0xfffffffff]
[    0.000000]  [mem 0x100000000-0xfffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x72f82000-0x7fff2fff]
[    0.000000] ACPI: RSDP 00000000000f0410 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 00000000bdfadd98 0000B4 (v01 INTEL   S4600LH 06222004 INTL 20090903)
[    0.000000] ACPI: FACP 00000000bdfad918 0000F4 (v04 INTEL   S4600LH 06222004 INTL 20090903)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aControlBlock: 32, using default 16 (20131218/tbfadt-684)
[    0.000000] ACPI: DSDT 00000000bdf97018 014A76 (v02 INTEL   S4600LH 00000002 INTL 20100331)
[    0.000000] ACPI: FACS 00000000bdfadf40 000040
[    0.000000] ACPI: APIC 00000000bdfac718 000682 (v03 INTEL   S4600LH 06222004 INTL 20090903)
[    0.000000] ACPI: SPMI 00000000bdfafc18 000040 (v05 INTEL   S4600LH 06222004 INTL 20090903)
[    0.000000] ACPI: MCFG 00000000bdfafb98 00003C (v01 INTEL   S4600LH 06222004 INTL 20090903)
[    0.000000] ACPI: WDDT 00000000bdfaff18 000040 (v01 INTEL   S4600LH 06222004 INTL 20090903)
[    0.000000] ACPI: SRAT 00000000bdf95598 0004F8 (v03 INTEL   S4600LH 06222004 INTL 20090903)
[    0.000000] ACPI: SLIT 00000000bdfafe98 00003C (v01 INTEL   S4600LH 06222004 INTL 20090903)
[    0.000000] ACPI: MSCT 00000000bdfaed18 000090 (v01 INTEL   S4600LH 06222004 INTL 20090903)
[    0.000000] ACPI: HPET 00000000bdfafe18 000038 (v01 INTEL   S4600LH 06222004 INTL 20090903)
[    0.000000] ACPI: SSDT 00000000bdfafd18 00002B (v02 INTEL   S4600LH 00001000 INTL 20100331)
[    0.000000] ACPI: SSDT 00000000bde27018 0794C4 (v02 INTEL   S4600LH 00004000 INTL 20100331)
[    0.000000] ACPI: HEST 00000000bdf96f18 0000A8 (v01 INTEL   S4600LH 00000001 INTL 00000001)
[    0.000000] ACPI: BERT 00000000bdfafd98 000030 (v01 INTEL   S4600LH 00000001 INTL 00000001)
[    0.000000] ACPI: ERST 00000000bdf96c98 000230 (v01 INTEL   S4600LH 00000001 INTL 00000001)
[    0.000000] ACPI: EINJ 00000000bdfad798 000130 (v01 INTEL   S4600LH 00000001 INTL 00000001)
[    0.000000] ACPI: SSDT 00000000bdf92018 000F41 (v02 INTEL   S4600LH 00000002 INTL 20100331)
[    0.000000] ACPI: SSDT 00000000bdf92f98 000045 (v02 INTEL   S4600LH 00000001 INTL 20100331)
[    0.000000] ACPI: SSDT 00000000bdface18 000181 (v02 INTEL   S4600LH 00000003 INTL 20100331)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x08 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x09 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0a -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0b -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0c -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0d -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0e -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0f -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x26 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x27 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x28 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x29 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2a -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2b -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2c -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2d -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2e -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2f -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 0x40 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x41 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x42 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x43 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x44 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x45 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x46 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x47 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x48 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x49 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4a -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4b -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4c -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4d -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4e -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4f -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x60 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x61 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x62 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x63 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x64 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x65 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x66 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x67 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x68 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x69 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6a -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6b -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6c -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6d -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6e -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6f -> Node 3
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0xbfffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x43fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x440000000-0x83fffffff]
[    0.000000] SRAT: Node 2 PXM 2 [mem 0x840000000-0xc3fffffff]
[    0.000000] SRAT: Node 3 PXM 3 [mem 0xc40000000-0x103fffffff]
[    0.000000] NUMA: Initialized distance table, cnt=4
[    0.000000] NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem 0x100000000-0x43fffffff] -> [mem 0x00000000-0x43fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x43fffffff]
[    0.000000]   NODE_DATA [mem 0x43fffb000-0x43fffffff]
[    0.000000] Initmem setup node 1 [mem 0x440000000-0x83fffffff]
[    0.000000]   NODE_DATA [mem 0x83fffb000-0x83fffffff]
[    0.000000] Initmem setup node 2 [mem 0x840000000-0xc3fffffff]
[    0.000000]   NODE_DATA [mem 0xc3fffb000-0xc3fffffff]
[    0.000000] Initmem setup node 3 [mem 0xc40000000-0x103fffffff]
[    0.000000]   NODE_DATA [mem 0x103fff8000-0x103fffcfff]
[    0.000000]  [ffffea0000000000-ffffea0010ffffff] PMD -> [ffff88042fe00000-ffff88043fdfffff] on node 0
[    0.000000]  [ffffea0011000000-ffffea0020ffffff] PMD -> [ffff88082fe00000-ffff88083fdfffff] on node 1
[    0.000000]  [ffffea0021000000-ffffea0030ffffff] PMD -> [ffff880c2fe00000-ffff880c3fdfffff] on node 2
[    0.000000]  [ffffea0031000000-ffffea0040ffffff] PMD -> [ffff88102f600000-ffff88103f5fffff] on node 3
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x103fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0008efff]
[    0.000000]   node   0: [mem 0x00100000-0xbb3c6fff]
[    0.000000]   node   0: [mem 0xbdfb0000-0xbdffffff]
[    0.000000]   node   0: [mem 0x100000000-0x43fffffff]
[    0.000000]   node   1: [mem 0x440000000-0x83fffffff]
[    0.000000]   node   2: [mem 0x840000000-0xc3fffffff]
[    0.000000]   node   3: [mem 0xc40000000-0x103fffffff]
[    0.000000] On node 0 totalpages: 4174757
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3982 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 11921 pages used for memmap
[    0.000000]   DMA32 zone: 762903 pages, LIFO batch:31
[    0.000000]   Normal zone: 53248 pages used for memmap
[    0.000000]   Normal zone: 3407872 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 4194304
[    0.000000]   Normal zone: 65536 pages used for memmap
[    0.000000]   Normal zone: 4194304 pages, LIFO batch:31
[    0.000000] On node 2 totalpages: 4194304
[    0.000000]   Normal zone: 65536 pages used for memmap
[    0.000000]   Normal zone: 4194304 pages, LIFO batch:31
[    0.000000] On node 3 totalpages: 4194304
[    0.000000]   Normal zone: 65536 pages used for memmap
[    0.000000]   Normal zone: 4194304 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] ACPI: X2APIC (apic_id[0x00] uid[0x00] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x01] uid[0x01] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x02] uid[0x02] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x03] uid[0x03] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x04] uid[0x04] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x05] uid[0x05] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x06] uid[0x06] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x07] uid[0x07] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x08] uid[0x08] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x09] uid[0x09] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x0a] uid[0x0a] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x0b] uid[0x0b] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x0c] uid[0x0c] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x0d] uid[0x0d] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x0e] uid[0x0e] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x0f] uid[0x0f] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x10] uid[0x10] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x11] uid[0x11] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x12] uid[0x12] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x13] uid[0x13] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x14] uid[0x14] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x15] uid[0x15] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x16] uid[0x16] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x17] uid[0x17] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x18] uid[0x18] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x19] uid[0x19] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x1a] uid[0x1a] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x1b] uid[0x1b] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x1c] uid[0x1c] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x1d] uid[0x1d] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x1e] uid[0x1e] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x1f] uid[0x1f] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x20] uid[0x20] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x21] uid[0x21] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x22] uid[0x22] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x23] uid[0x23] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x24] uid[0x24] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x25] uid[0x25] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x26] uid[0x26] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x27] uid[0x27] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x28] uid[0x28] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x29] uid[0x29] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x2a] uid[0x2a] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x2b] uid[0x2b] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x2c] uid[0x2c] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x2d] uid[0x2d] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x2e] uid[0x2e] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x2f] uid[0x2f] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x30] uid[0x30] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x31] uid[0x31] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x32] uid[0x32] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x33] uid[0x33] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x34] uid[0x34] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x35] uid[0x35] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x36] uid[0x36] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x37] uid[0x37] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x38] uid[0x38] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x39] uid[0x39] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x3a] uid[0x3a] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x3b] uid[0x3b] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x3c] uid[0x3c] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x3d] uid[0x3d] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x3e] uid[0x3e] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x3f] uid[0x3f] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x08] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x0a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x0c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x0e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x26] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x28] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x2a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x2c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x2e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x40] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x42] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x44] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x46] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x48] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x4a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x4c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x4e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x60] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x62] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x64] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x66] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x68] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x6a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x6c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x6e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x22] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x23] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x24] lapic_id[0x09] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x25] lapic_id[0x0b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x26] lapic_id[0x0d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0x0f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x28] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x29] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2a] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2b] lapic_id[0x27] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2c] lapic_id[0x29] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2d] lapic_id[0x2b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2e] lapic_id[0x2d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2f] lapic_id[0x2f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x30] lapic_id[0x41] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x31] lapic_id[0x43] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x32] lapic_id[0x45] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x33] lapic_id[0x47] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x34] lapic_id[0x49] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x35] lapic_id[0x4b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x36] lapic_id[0x4d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x37] lapic_id[0x4f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x38] lapic_id[0x61] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x39] lapic_id[0x63] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3a] lapic_id[0x65] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3b] lapic_id[0x67] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3c] lapic_id[0x69] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3d] lapic_id[0x6b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3e] lapic_id[0x6d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3f] lapic_id[0x6f] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec3f000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 1, version 32, address 0xfec3f000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec7f000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 2, version 32, address 0xfec7f000, GSI 48-71
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfecbf000] gsi_base[72])
[    0.000000] IOAPIC[3]: apic_id 3, version 32, address 0xfecbf000, GSI 72-95
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfecff000] gsi_base[96])
[    0.000000] IOAPIC[4]: apic_id 4, version 32, address 0xfecff000, GSI 96-119
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 0, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 64 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff5f1000 (fec3f000)
[    0.000000] mapped IOAPIC to ffffffffff5f0000 (fec7f000)
[    0.000000] mapped IOAPIC to ffffffffff5ef000 (fecbf000)
[    0.000000] mapped IOAPIC to ffffffffff5ee000 (fecff000)
[    0.000000] nr_irqs_gsi: 136
[    0.000000] PM: Registered nosave memory: [mem 0x0008f000-0x0008ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x00090000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbb3c7000-0xbdd2efff]
[    0.000000] PM: Registered nosave memory: [mem 0xbdd2f000-0xbde26fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbde27000-0xbdea0fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbdea1000-0xbdf2efff]
[    0.000000] PM: Registered nosave memory: [mem 0xbdf2f000-0xbdfaffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbe000000-0xcfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfed18fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed19000-0xfed19fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xffa1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffa20000-0xffffffff]
[    0.000000] e820: [mem 0xd0000000-0xfebfffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:64 nr_node_ids:4
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88042fc00000 s81088 r8192 d21312 u131072
[    0.000000] pcpu-alloc: s81088 r8192 d21312 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 32 33 34 35 36 37 38 39 
[    0.000000] pcpu-alloc: [1] 08 09 10 11 12 13 14 15 40 41 42 43 44 45 46 47 
[    0.000000] pcpu-alloc: [2] 16 17 18 19 20 21 22 23 48 49 50 51 52 53 54 55 
[    0.000000] pcpu-alloc: [3] 24 25 26 27 28 29 30 31 56 57 58 59 60 61 62 63 
[    0.000000] Built 4 zonelists in Zone order, mobility grouping on.  Total pages: 16495807
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/lkp-sbx04/bisect_boot-1-x86_64-lkp-a929a7dbfee6e4d1a8d272ac3ba7f20db9893856-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/a929a7dbfee6e4d1a8d272ac3ba7f20db9893856/vmlinuz-3.14.0-rc7-03020-ga929a7d kconfig=x86_64-lkp commit=a929a7dbfee6e4d1a8d272ac3ba7f20db9893856 modules_initrd=/kernel/x86_64-lkp/a929a7dbfee6e4d1a8d272ac3ba7f20db9893856/modules.cgz RESULT_ROOT=/lkp/result/lkp-sbx04/fake/boot/1/x86_64-lkp/a929a7dbfee6e4d1a8d272ac3ba7f20db9893856/0 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 ip=::::lkp-sbx04::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 65674060K/67030676K available (10050K kernel code, 1255K rwdata, 4184K rodata, 1420K init, 1748K bss, 1356616K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=64, Nodes=4
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=64.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=64
[    0.000000] NR_IRQS:33024 nr_irqs:2824 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc7-03020-ga929a7d (kbuild@inn) (gcc version 4.8.2 (Debian 4.8.2-16) ) #1 SMP Wed Mar 26 08:53:20 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/lkp-sbx04/bisect_boot-1-x86_64-lkp-a929a7dbfee6e4d1a8d272ac3ba7f20db9893856-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/a929a7dbfee6e4d1a8d272ac3ba7f20db9893856/vmlinuz-3.14.0-rc7-03020-ga929a7d kconfig=x86_64-lkp commit=a929a7dbfee6e4d1a8d272ac3ba7f20db9893856 modules_initrd=/kernel/x86_64-lkp/a929a7dbfee6e4d1a8d272ac3ba7f20db9893856/modules.cgz RESULT_ROOT=/lkp/result/lkp-sbx04/fake/boot/1/x86_64-lkp/a929a7dbfee6e4d1a8d272ac3ba7f20db9893856/0 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 ip=::::lkp-sbx04::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000008f3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000008f400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bb3c6fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bb3c7000-0x00000000bdd2efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bdd2f000-0x00000000bde26fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bde27000-0x00000000bdea0fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bdea1000-0x00000000bdf2efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bdf2f000-0x00000000bdfaffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bdfb0000-0x00000000bdffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000be000000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed19000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffa20000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000103fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: Intel Corporation LH Pass/S4600LH...., BIOS SE5C600.86B.99.02.1047.032320122259 03/23/2012
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x1040000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-through
[    0.000000]   D0000-D3FFF write-protect
[    0.000000]   D4000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask 3FFF80000000 write-back
[    0.000000]   1 base 000080000000 mask 3FFFC0000000 write-back
[    0.000000]   2 base 000100000000 mask 3FFF00000000 write-back
[    0.000000]   3 base 000200000000 mask 3FFE00000000 write-back
[    0.000000]   4 base 000400000000 mask 3FFC00000000 write-back
[    0.000000]   5 base 000800000000 mask 3FF800000000 write-back
[    0.000000]   6 base 001000000000 mask 3FFFC0000000 write-back
[    0.000000]   7 base 0000FF800000 mask 3FFFFF800000 write-protect
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: last_pfn = 0xbe000 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fd0f0-0x000fd0ff] mapped at [ffff8800000fd0f0]
[    0.000000]   mpc: fc870-fcf24
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000089000] 89000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0245f000, 0x0245ffff] PGTABLE
[    0.000000] BRK [0x02460000, 0x02460fff] PGTABLE
[    0.000000] BRK [0x02461000, 0x02461fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x103fe00000-0x103fffffff]
[    0.000000]  [mem 0x103fe00000-0x103fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x103c000000-0x103fdfffff]
[    0.000000]  [mem 0x103c000000-0x103fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x1000000000-0x103bffffff]
[    0.000000]  [mem 0x1000000000-0x103bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbb3c6fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0xbb1fffff] page 2M
[    0.000000]  [mem 0xbb200000-0xbb3c6fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbdfb0000-0xbdffffff]
[    0.000000]  [mem 0xbdfb0000-0xbdffffff] page 4k
[    0.000000] BRK [0x02462000, 0x02462fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0xfffffffff]
[    0.000000]  [mem 0x100000000-0xfffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x72f82000-0x7fff2fff]
[    0.000000] ACPI: RSDP 00000000000f0410 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 00000000bdfadd98 0000B4 (v01 INTEL   S4600LH 06222004 INTL 20090903)
[    0.000000] ACPI: FACP 00000000bdfad918 0000F4 (v04 INTEL   S4600LH 06222004 INTL 20090903)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aControlBlock: 32, using default 16 (20131218/tbfadt-684)
[    0.000000] ACPI: DSDT 00000000bdf97018 014A76 (v02 INTEL   S4600LH 00000002 INTL 20100331)
[    0.000000] ACPI: FACS 00000000bdfadf40 000040
[    0.000000] ACPI: APIC 00000000bdfac718 000682 (v03 INTEL   S4600LH 06222004 INTL 20090903)
[    0.000000] ACPI: SPMI 00000000bdfafc18 000040 (v05 INTEL   S4600LH 06222004 INTL 20090903)
[    0.000000] ACPI: MCFG 00000000bdfafb98 00003C (v01 INTEL   S4600LH 06222004 INTL 20090903)
[    0.000000] ACPI: WDDT 00000000bdfaff18 000040 (v01 INTEL   S4600LH 06222004 INTL 20090903)
[    0.000000] ACPI: SRAT 00000000bdf95598 0004F8 (v03 INTEL   S4600LH 06222004 INTL 20090903)
[    0.000000] ACPI: SLIT 00000000bdfafe98 00003C (v01 INTEL   S4600LH 06222004 INTL 20090903)
[    0.000000] ACPI: MSCT 00000000bdfaed18 000090 (v01 INTEL   S4600LH 06222004 INTL 20090903)
[    0.000000] ACPI: HPET 00000000bdfafe18 000038 (v01 INTEL   S4600LH 06222004 INTL 20090903)
[    0.000000] ACPI: SSDT 00000000bdfafd18 00002B (v02 INTEL   S4600LH 00001000 INTL 20100331)
[    0.000000] ACPI: SSDT 00000000bde27018 0794C4 (v02 INTEL   S4600LH 00004000 INTL 20100331)
[    0.000000] ACPI: HEST 00000000bdf96f18 0000A8 (v01 INTEL   S4600LH 00000001 INTL 00000001)
[    0.000000] ACPI: BERT 00000000bdfafd98 000030 (v01 INTEL   S4600LH 00000001 INTL 00000001)
[    0.000000] ACPI: ERST 00000000bdf96c98 000230 (v01 INTEL   S4600LH 00000001 INTL 00000001)
[    0.000000] ACPI: EINJ 00000000bdfad798 000130 (v01 INTEL   S4600LH 00000001 INTL 00000001)
[    0.000000] ACPI: SSDT 00000000bdf92018 000F41 (v02 INTEL   S4600LH 00000002 INTL 20100331)
[    0.000000] ACPI: SSDT 00000000bdf92f98 000045 (v02 INTEL   S4600LH 00000001 INTL 20100331)
[    0.000000] ACPI: SSDT 00000000bdface18 000181 (v02 INTEL   S4600LH 00000003 INTL 20100331)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x08 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x09 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0a -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0b -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0c -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0d -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0e -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0f -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x26 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x27 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x28 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x29 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2a -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2b -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2c -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2d -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2e -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2f -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 0x40 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x41 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x42 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x43 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x44 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x45 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x46 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x47 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x48 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x49 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4a -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4b -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4c -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4d -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4e -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4f -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x60 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x61 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x62 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x63 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x64 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x65 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x66 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x67 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x68 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x69 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6a -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6b -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6c -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6d -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6e -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6f -> Node 3
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0xbfffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x43fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x440000000-0x83fffffff]
[    0.000000] SRAT: Node 2 PXM 2 [mem 0x840000000-0xc3fffffff]
[    0.000000] SRAT: Node 3 PXM 3 [mem 0xc40000000-0x103fffffff]
[    0.000000] NUMA: Initialized distance table, cnt=4
[    0.000000] NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem 0x100000000-0x43fffffff] -> [mem 0x00000000-0x43fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x43fffffff]
[    0.000000]   NODE_DATA [mem 0x43fffb000-0x43fffffff]
[    0.000000] Initmem setup node 1 [mem 0x440000000-0x83fffffff]
[    0.000000]   NODE_DATA [mem 0x83fffb000-0x83fffffff]
[    0.000000] Initmem setup node 2 [mem 0x840000000-0xc3fffffff]
[    0.000000]   NODE_DATA [mem 0xc3fffb000-0xc3fffffff]
[    0.000000] Initmem setup node 3 [mem 0xc40000000-0x103fffffff]
[    0.000000]   NODE_DATA [mem 0x103fff8000-0x103fffcfff]
[    0.000000]  [ffffea0000000000-ffffea0010ffffff] PMD -> [ffff88042fe00000-ffff88043fdfffff] on node 0
[    0.000000]  [ffffea0011000000-ffffea0020ffffff] PMD -> [ffff88082fe00000-ffff88083fdfffff] on node 1
[    0.000000]  [ffffea0021000000-ffffea0030ffffff] PMD -> [ffff880c2fe00000-ffff880c3fdfffff] on node 2
[    0.000000]  [ffffea0031000000-ffffea0040ffffff] PMD -> [ffff88102f600000-ffff88103f5fffff] on node 3
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x103fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0008efff]
[    0.000000]   node   0: [mem 0x00100000-0xbb3c6fff]
[    0.000000]   node   0: [mem 0xbdfb0000-0xbdffffff]
[    0.000000]   node   0: [mem 0x100000000-0x43fffffff]
[    0.000000]   node   1: [mem 0x440000000-0x83fffffff]
[    0.000000]   node   2: [mem 0x840000000-0xc3fffffff]
[    0.000000]   node   3: [mem 0xc40000000-0x103fffffff]
[    0.000000] On node 0 totalpages: 4174757
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3982 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 11921 pages used for memmap
[    0.000000]   DMA32 zone: 762903 pages, LIFO batch:31
[    0.000000]   Normal zone: 53248 pages used for memmap
[    0.000000]   Normal zone: 3407872 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 4194304
[    0.000000]   Normal zone: 65536 pages used for memmap
[    0.000000]   Normal zone: 4194304 pages, LIFO batch:31
[    0.000000] On node 2 totalpages: 4194304
[    0.000000]   Normal zone: 65536 pages used for memmap
[    0.000000]   Normal zone: 4194304 pages, LIFO batch:31
[    0.000000] On node 3 totalpages: 4194304
[    0.000000]   Normal zone: 65536 pages used for memmap
[    0.000000]   Normal zone: 4194304 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] ACPI: X2APIC (apic_id[0x00] uid[0x00] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x01] uid[0x01] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x02] uid[0x02] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x03] uid[0x03] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x04] uid[0x04] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x05] uid[0x05] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x06] uid[0x06] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x07] uid[0x07] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x08] uid[0x08] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x09] uid[0x09] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x0a] uid[0x0a] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x0b] uid[0x0b] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x0c] uid[0x0c] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x0d] uid[0x0d] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x0e] uid[0x0e] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x0f] uid[0x0f] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x10] uid[0x10] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x11] uid[0x11] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x12] uid[0x12] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x13] uid[0x13] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x14] uid[0x14] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x15] uid[0x15] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x16] uid[0x16] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x17] uid[0x17] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x18] uid[0x18] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x19] uid[0x19] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x1a] uid[0x1a] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x1b] uid[0x1b] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x1c] uid[0x1c] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x1d] uid[0x1d] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x1e] uid[0x1e] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x1f] uid[0x1f] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x20] uid[0x20] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x21] uid[0x21] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x22] uid[0x22] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x23] uid[0x23] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x24] uid[0x24] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x25] uid[0x25] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x26] uid[0x26] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x27] uid[0x27] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x28] uid[0x28] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x29] uid[0x29] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x2a] uid[0x2a] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x2b] uid[0x2b] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x2c] uid[0x2c] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x2d] uid[0x2d] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x2e] uid[0x2e] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x2f] uid[0x2f] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x30] uid[0x30] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x31] uid[0x31] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x32] uid[0x32] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x33] uid[0x33] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x34] uid[0x34] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x35] uid[0x35] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x36] uid[0x36] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x37] uid[0x37] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x38] uid[0x38] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x39] uid[0x39] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x3a] uid[0x3a] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x3b] uid[0x3b] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x3c] uid[0x3c] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x3d] uid[0x3d] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x3e] uid[0x3e] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x3f] uid[0x3f] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x08] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x0a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x0c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x0e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x26] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x28] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x2a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x2c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x2e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x40] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x42] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x44] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x46] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x48] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x4a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x4c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x4e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x60] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x62] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x64] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x66] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x68] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x6a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x6c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x6e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x22] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x23] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x24] lapic_id[0x09] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x25] lapic_id[0x0b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x26] lapic_id[0x0d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0x0f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x28] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x29] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2a] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2b] lapic_id[0x27] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2c] lapic_id[0x29] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2d] lapic_id[0x2b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2e] lapic_id[0x2d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2f] lapic_id[0x2f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x30] lapic_id[0x41] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x31] lapic_id[0x43] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x32] lapic_id[0x45] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x33] lapic_id[0x47] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x34] lapic_id[0x49] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x35] lapic_id[0x4b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x36] lapic_id[0x4d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x37] lapic_id[0x4f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x38] lapic_id[0x61] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x39] lapic_id[0x63] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3a] lapic_id[0x65] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3b] lapic_id[0x67] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3c] lapic_id[0x69] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3d] lapic_id[0x6b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3e] lapic_id[0x6d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3f] lapic_id[0x6f] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec3f000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 1, version 32, address 0xfec3f000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec7f000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 2, version 32, address 0xfec7f000, GSI 48-71
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfecbf000] gsi_base[72])
[    0.000000] IOAPIC[3]: apic_id 3, version 32, address 0xfecbf000, GSI 72-95
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfecff000] gsi_base[96])
[    0.000000] IOAPIC[4]: apic_id 4, version 32, address 0xfecff000, GSI 96-119
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 0, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 64 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff5f1000 (fec3f000)
[    0.000000] mapped IOAPIC to ffffffffff5f0000 (fec7f000)
[    0.000000] mapped IOAPIC to ffffffffff5ef000 (fecbf000)
[    0.000000] mapped IOAPIC to ffffffffff5ee000 (fecff000)
[    0.000000] nr_irqs_gsi: 136
[    0.000000] PM: Registered nosave memory: [mem 0x0008f000-0x0008ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x00090000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbb3c7000-0xbdd2efff]
[    0.000000] PM: Registered nosave memory: [mem 0xbdd2f000-0xbde26fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbde27000-0xbdea0fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbdea1000-0xbdf2efff]
[    0.000000] PM: Registered nosave memory: [mem 0xbdf2f000-0xbdfaffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbe000000-0xcfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfed18fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed19000-0xfed19fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xffa1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffa20000-0xffffffff]
[    0.000000] e820: [mem 0xd0000000-0xfebfffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:64 nr_node_ids:4
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88042fc00000 s81088 r8192 d21312 u131072
[    0.000000] pcpu-alloc: s81088 r8192 d21312 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 32 33 34 35 36 37 38 39 
[    0.000000] pcpu-alloc: [1] 08 09 10 11 12 13 14 15 40 41 42 43 44 45 46 47 
[    0.000000] pcpu-alloc: [2] 16 17 18 19 20 21 22 23 48 49 50 51 52 53 54 55 
[    0.000000] pcpu-alloc: [3] 24 25 26 27 28 29 30 31 56 57 58 59 60 61 62 63 
[    0.000000] Built 4 zonelists in Zone order, mobility grouping on.  Total pages: 16495807
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/lkp-sbx04/bisect_boot-1-x86_64-lkp-a929a7dbfee6e4d1a8d272ac3ba7f20db9893856-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/a929a7dbfee6e4d1a8d272ac3ba7f20db9893856/vmlinuz-3.14.0-rc7-03020-ga929a7d kconfig=x86_64-lkp commit=a929a7dbfee6e4d1a8d272ac3ba7f20db9893856 modules_initrd=/kernel/x86_64-lkp/a929a7dbfee6e4d1a8d272ac3ba7f20db9893856/modules.cgz RESULT_ROOT=/lkp/result/lkp-sbx04/fake/boot/1/x86_64-lkp/a929a7dbfee6e4d1a8d272ac3ba7f20db9893856/0 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 ip=::::lkp-sbx04::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 65674060K/67030676K available (10050K kernel code, 1255K rwdata, 4184K rodata, 1420K init, 1748K bss, 1356616K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=64, Nodes=4
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=64.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=64
[    0.000000] NR_IRQS:33024 nr_irqs:2824 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 268435456 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Disabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2693.313 MHz processor
[    0.000058] Calibrating delay loop (skipped), value calculated using timer frequency.. 5386.62 BogoMIPS (lpj=10773252)
[    0.012208] pid_max: default: 65536 minimum: 512
[    0.017496] ACPI: Core revision 20131218
[    0.095431] ACPI: All ACPI Tables successfully acquired
[    0.110987] Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
[    0.150020] Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.171128] Mount-cache hash table entries: 256
[    0.177414] Initializing cgroup subsys memory
[    0.182808] Initializing cgroup subsys devices
[    0.188244] Initializing cgroup subsys freezer
[    0.193680] Initializing cgroup subsys blkio
[    0.198908] Initializing cgroup subsys perf_event
[    0.204636] Initializing cgroup subsys hugetlb
[    0.210191] CPU: Physical Processor ID: 0
[    0.215121] CPU: Processor Core ID: 0
[    0.219688] mce: CPU supports 20 MCE banks
[    0.224779] CPU0: Thermal LVT vector (0xfa) already installed
[    0.231687] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
[    0.231687] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.231687] tlb_flushall_shift: 6
[    0.250000] Freeing SMP alternatives memory: 40K (ffffffff8229e000 - ffffffff822a8000)
[    0.263141] ftrace: allocating 39077 entries in 153 pages
[    0.308239] Getting VERSION: 1060015
[    0.312697] Getting VERSION: 1060015
[    0.317159] Getting ID: 0
[    0.320534] Getting ID: 0
[    0.323934] Switched APIC routing to physical flat.
[    0.329852] masked ExtINT on CPU#0
[    0.334916] ENABLING IO-APIC IRQs
[    0.339078] init IO_APIC IRQs
[    0.342852]  apic 0 pin 0 not connected
[    0.347624] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:0)
[    0.357335] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:0)
[    0.367042] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:0)
[    0.376780] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:0)
[    0.386509] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:0)
[    0.396210] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:0)
[    0.405913] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:0)
[    0.415617] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:0)
[    0.425309] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:0)
[    0.435002] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:0)
[    0.444892] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:0)
[    0.454777] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:0)
[    0.464668] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:0)
[    0.474565] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:0)
[    0.484471] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:0)
[    0.494364]  apic 0 pin 16 not connected
[    0.499201]  apic 0 pin 17 not connected
[    0.504040]  apic 0 pin 18 not connected
[    0.508878]  apic 0 pin 19 not connected
[    0.513713]  apic 0 pin 20 not connected
[    0.518559]  apic 0 pin 21 not connected
[    0.523406]  apic 0 pin 22 not connected
[    0.528242]  apic 0 pin 23 not connected
[    0.533088]  apic 1 pin 0 not connected
[    0.537826]  apic 1 pin 1 not connected
[    0.542571]  apic 1 pin 2 not connected
[    0.547309]  apic 1 pin 3 not connected
[    0.552060]  apic 1 pin 4 not connected
[    0.556804]  apic 1 pin 5 not connected
[    0.561548]  apic 1 pin 6 not connected
[    0.566287]  apic 1 pin 7 not connected
[    0.571037]  apic 1 pin 8 not connected
[    0.575777]  apic 1 pin 9 not connected
[    0.580516]  apic 1 pin 10 not connected
[    0.585355]  apic 1 pin 11 not connected
[    0.590199]  apic 1 pin 12 not connected
[    0.595033]  apic 1 pin 13 not connected
[    0.599876]  apic 1 pin 14 not connected
[    0.604717]  apic 1 pin 15 not connected
[    0.609575]  apic 1 pin 16 not connected
[    0.614418]  apic 1 pin 17 not connected
[    0.619256]  apic 1 pin 18 not connected
[    0.624093]  apic 1 pin 19 not connected
[    0.628933]  apic 1 pin 20 not connected
[    0.633772]  apic 1 pin 21 not connected
[    0.638611]  apic 1 pin 22 not connected
[    0.643445]  apic 1 pin 23 not connected
[    0.648290]  apic 2 pin 0 not connected
[    0.653034]  apic 2 pin 1 not connected
[    0.657774]  apic 2 pin 2 not connected
[    0.662514]  apic 2 pin 3 not connected
[    0.667260]  apic 2 pin 4 not connected
[    0.672003]  apic 2 pin 5 not connected
[    0.676745]  apic 2 pin 6 not connected
[    0.681483]  apic 2 pin 7 not connected
[    0.686231]  apic 2 pin 8 not connected
[    0.690970]  apic 2 pin 9 not connected
[    0.695707]  apic 2 pin 10 not connected
[    0.700546]  apic 2 pin 11 not connected
[    0.705391]  apic 2 pin 12 not connected
[    0.710226]  apic 2 pin 13 not connected
[    0.715063]  apic 2 pin 14 not connected
[    0.719911]  apic 2 pin 15 not connected
[    0.724767]  apic 2 pin 16 not connected
[    0.729613]  apic 2 pin 17 not connected
[    0.734466]  apic 2 pin 18 not connected
[    0.739302]  apic 2 pin 19 not connected
[    0.744145]  apic 2 pin 20 not connected
[    0.748985]  apic 2 pin 21 not connected
[    0.753823]  apic 2 pin 22 not connected
[    0.758658]  apic 2 pin 23 not connected
[    0.763504]  apic 3 pin 0 not connected
[    0.768244]  apic 3 pin 1 not connected
[    0.772983]  apic 3 pin 2 not connected
[    0.777726]  apic 3 pin 3 not connected
[    0.782475]  apic 3 pin 4 not connected
[    0.787217]  apic 3 pin 5 not connected
[    0.791962]  apic 3 pin 6 not connected
[    0.796702]  apic 3 pin 7 not connected
[    0.801450]  apic 3 pin 8 not connected
[    0.806184]  apic 3 pin 9 not connected
[    0.810925]  apic 3 pin 10 not connected
[    0.815764]  apic 3 pin 11 not connected
[    0.820609]  apic 3 pin 12 not connected
[    0.825447]  apic 3 pin 13 not connected
[    0.830283]  apic 3 pin 14 not connected
[    0.835123]  apic 3 pin 15 not connected
[    0.839968]  apic 3 pin 16 not connected
[    0.844813]  apic 3 pin 17 not connected
[    0.849666]  apic 3 pin 18 not connected
[    0.854517]  apic 3 pin 19 not connected
[    0.859368]  apic 3 pin 20 not connected
[    0.864207]  apic 3 pin 21 not connected
[    0.869036]  apic 3 pin 22 not connected
[    0.873873]  apic 3 pin 23 not connected
[    0.878719]  apic 4 pin 0 not connected
[    0.883470]  apic 4 pin 1 not connected
[    0.888217]  apic 4 pin 2 not connected
[    0.892960]  apic 4 pin 3 not connected
[    0.897715]  apic 4 pin 4 not connected
[    0.902458]  apic 4 pin 5 not connected
[    0.907202]  apic 4 pin 6 not connected
[    0.911948]  apic 4 pin 7 not connected
[    0.916704]  apic 4 pin 8 not connected
[    0.921449]  apic 4 pin 9 not connected
[    0.926193]  apic 4 pin 10 not connected
[    0.931022]  apic 4 pin 11 not connected
[    0.935877]  apic 4 pin 12 not connected
[    0.940712]  apic 4 pin 13 not connected
[    0.945548]  apic 4 pin 14 not connected
[    0.950387]  apic 4 pin 15 not connected
[    0.955215]  apic 4 pin 16 not connected
[    0.960052]  apic 4 pin 17 not connected
[    0.964893]  apic 4 pin 18 not connected
[    0.969737]  apic 4 pin 19 not connected
[    0.974580]  apic 4 pin 20 not connected
[    0.979423]  apic 4 pin 21 not connected
[    0.984260]  apic 4 pin 22 not connected
[    0.989095]  apic 4 pin 23 not connected
[    0.994086] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    1.040930] smpboot: CPU0: Intel(R) Xeon(R) CPU E5-4650 0 @ 2.70GHz (fam: 06, model: 2d, stepping: 07)
[    1.052459] TSC deadline timer enabled
[    1.057150] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, full-width counters, Intel PMU driver.
[    1.070176] perf_event_intel: PEBS disabled due to CPU errata, please upgrade microcode
[    1.079972] ... version:                3
[    1.084907] ... bit width:              48
[    1.089943] ... generic registers:      4
[    1.094898] ... value mask:             0000ffffffffffff
[    1.101298] ... max period:             0000ffffffffffff
[    1.107704] ... fixed-purpose events:   3
[    1.112640] ... event mask:             000000070000000f
[    1.123669] x86: Booting SMP configuration:
[    1.128811] .... node  #0, CPUs:        #1
[    1.148139] masked ExtINT on CPU#1
[    1.152228] CPU1: Thermal LVT vector (0xfa) already installed
[    1.161021]   #2
[    1.174385] masked ExtINT on CPU#2
[    1.178492] CPU2: Thermal LVT vector (0xfa) already installed
[    1.187347]   #3
[    1.201101] masked ExtINT on CPU#3
[    1.205194] CPU3: Thermal LVT vector (0xfa) already installed
[    1.214044]   #4
[    1.227414] masked ExtINT on CPU#4
[    1.231498] CPU4: Thermal LVT vector (0xfa) already installed
[    1.240285]   #5
[    1.253649] masked ExtINT on CPU#5
[    1.257756] CPU5: Thermal LVT vector (0xfa) already installed
[    1.266604]   #6
[    1.279946] masked ExtINT on CPU#6
[    1.284052] CPU6: Thermal LVT vector (0xfa) already installed
[    1.292845]   #7
[    1.306175] masked ExtINT on CPU#7
[    1.310265] CPU7: Thermal LVT vector (0xfa) already installed
[    1.319123] 
[    1.321626] .... node  #1, CPUs:    #8
[    1.338550] masked ExtINT on CPU#8
[    1.342653] CPU8: Thermal LVT vector (0xfa) already installed
[    1.445775]   #9
[    1.458861] masked ExtINT on CPU#9
[    1.462996] CPU9: Thermal LVT vector (0xfa) already installed
[    1.471814]  #10
[    1.485192] masked ExtINT on CPU#10
[    1.489425] CPU10: Thermal LVT vector (0xfa) already installed
[    1.498272]  #11
[    1.521067] masked ExtINT on CPU#11
[    1.525298] CPU11: Thermal LVT vector (0xfa) already installed
[    1.534199]  #12
[    1.547283] masked ExtINT on CPU#12
[    1.551507] CPU12: Thermal LVT vector (0xfa) already installed
[    1.560346]  #13
[    1.573446] masked ExtINT on CPU#13
[    1.577668] CPU13: Thermal LVT vector (0xfa) already installed
[    1.586504]  #14
[    1.599580] masked ExtINT on CPU#14
[    1.603809] CPU14: Thermal LVT vector (0xfa) already installed
[    1.612722]  #15
[    1.626162] masked ExtINT on CPU#15
[    1.630364] CPU15: Thermal LVT vector (0xfa) already installed
[    1.639298] 
[    1.641413] .... node  #2, CPUs:   #16
[    1.658189] masked ExtINT on CPU#16
[    1.662424] CPU16: Thermal LVT vector (0xfa) already installed
[    1.765684]  #17
[    1.779047] masked ExtINT on CPU#17
[    1.783302] CPU17: Thermal LVT vector (0xfa) already installed
[    1.792239]  #18
[    1.805599] masked ExtINT on CPU#18
[    1.809839] CPU18: Thermal LVT vector (0xfa) already installed
[    1.818819]  #19
[    1.832564] masked ExtINT on CPU#19
[    1.836804] CPU19: Thermal LVT vector (0xfa) already installed
[    1.845718]  #20
[    1.859103] masked ExtINT on CPU#20
[    1.863345] CPU20: Thermal LVT vector (0xfa) already installed
[    1.872317]  #21
[    1.885672] masked ExtINT on CPU#21
[    1.889903] CPU21: Thermal LVT vector (0xfa) already installed
[    1.898746]  #22
[    1.912104] masked ExtINT on CPU#22
[    1.916337] CPU22: Thermal LVT vector (0xfa) already installed
[    1.925227]  #23
[    1.938927] masked ExtINT on CPU#23
[    1.943153] CPU23: Thermal LVT vector (0xfa) already installed
[    1.952106] 
[    1.954249] .... node  #3, CPUs:   #24
[    1.971674] masked ExtINT on CPU#24
[    1.975903] CPU24: Thermal LVT vector (0xfa) already installed
[    2.082948]  #25
[    2.096302] masked ExtINT on CPU#25
[    2.100523] CPU25: Thermal LVT vector (0xfa) already installed
[    2.109368]  #26
[    2.122742] masked ExtINT on CPU#26
[    2.126966] CPU26: Thermal LVT vector (0xfa) already installed
[    2.135822]  #27
[    2.149550] masked ExtINT on CPU#27
[    2.153760] CPU27: Thermal LVT vector (0xfa) already installed
[    2.162597]  #28
[    2.175966] masked ExtINT on CPU#28
[    2.180204] CPU28: Thermal LVT vector (0xfa) already installed
[    2.189136]  #29
[    2.202483] masked ExtINT on CPU#29
[    2.206720] CPU29: Thermal LVT vector (0xfa) already installed
[    2.215549]  #30
[    2.228903] masked ExtINT on CPU#30
[    2.233130] CPU30: Thermal LVT vector (0xfa) already installed
[    2.241987]  #31
[    2.255686] masked ExtINT on CPU#31
[    2.259894] CPU31: Thermal LVT vector (0xfa) already installed
[    2.268794] 
[    2.270930] .... node  #0, CPUs:   #32
[    2.287092] masked ExtINT on CPU#32
[    2.291321] CPU32: Thermal LVT vector (0xfa) already installed
[    2.300377]  #33
[    2.313752] masked ExtINT on CPU#33
[    2.317959] CPU33: Thermal LVT vector (0xfa) already installed
[    2.326948]  #34
[    2.340348] masked ExtINT on CPU#34
[    2.344557] CPU34: Thermal LVT vector (0xfa) already installed
[    2.353498]  #35
[    2.367255] masked ExtINT on CPU#35
[    2.371485] CPU35: Thermal LVT vector (0xfa) already installed
[    2.380395]  #36
[    2.393783] masked ExtINT on CPU#36
[    2.398007] CPU36: Thermal LVT vector (0xfa) already installed
[    2.406933]  #37
[    2.420308] masked ExtINT on CPU#37
[    2.424524] CPU37: Thermal LVT vector (0xfa) already installed
[    2.433488]  #38
[    2.446865] masked ExtINT on CPU#38
[    2.451068] CPU38: Thermal LVT vector (0xfa) already installed
[    2.460063]  #39
[    2.473775] masked ExtINT on CPU#39
[    2.477991] CPU39: Thermal LVT vector (0xfa) already installed
[    2.486975] 
[    2.489110] .... node  #1, CPUs:   #40
[    2.504391] masked ExtINT on CPU#40
[    2.508616] CPU40: Thermal LVT vector (0xfa) already installed
[    2.517539]  #41
[    2.530624] masked ExtINT on CPU#41
[    2.534845] CPU41: Thermal LVT vector (0xfa) already installed
[    2.543810]  #42
[    2.556917] masked ExtINT on CPU#42
[    2.561137] CPU42: Thermal LVT vector (0xfa) already installed
[    2.570062]  #43
[    2.583533] masked ExtINT on CPU#43
[    2.587777] CPU43: Thermal LVT vector (0xfa) already installed
[    2.596662]  #44
[    2.609772] masked ExtINT on CPU#44
[    2.614001] CPU44: Thermal LVT vector (0xfa) already installed
[    2.622925]  #45
[    2.636001] masked ExtINT on CPU#45
[    2.640230] CPU45: Thermal LVT vector (0xfa) already installed
[    2.649143]  #46
[    2.662235] masked ExtINT on CPU#46
[    2.666455] CPU46: Thermal LVT vector (0xfa) already installed
[    2.675387]  #47
[    2.688829] masked ExtINT on CPU#47
[    2.693050] CPU47: Thermal LVT vector (0xfa) already installed
[    2.701946] 
[    2.704089] .... node  #2, CPUs:   #48
[    2.719638] masked ExtINT on CPU#48
[    2.723890] CPU48: Thermal LVT vector (0xfa) already installed
[    2.732841]  #49
[    2.746198] masked ExtINT on CPU#49
[    2.750447] CPU49: Thermal LVT vector (0xfa) already installed
[    2.759396]  #50
[    2.772784] masked ExtINT on CPU#50
[    2.777004] CPU50: Thermal LVT vector (0xfa) already installed
[    2.785966]  #51
[    2.799722] masked ExtINT on CPU#51
[    2.803971] CPU51: Thermal LVT vector (0xfa) already installed
[    2.812862]  #52
[    2.826246] masked ExtINT on CPU#52
[    2.830494] CPU52: Thermal LVT vector (0xfa) already installed
[    2.839444]  #53
[    2.852799] masked ExtINT on CPU#53
[    2.857035] CPU53: Thermal LVT vector (0xfa) already installed
[    2.865966]  #54
[    2.879332] masked ExtINT on CPU#54
[    2.883579] CPU54: Thermal LVT vector (0xfa) already installed
[    2.892457]  #55
[    2.906166] masked ExtINT on CPU#55
[    2.910413] CPU55: Thermal LVT vector (0xfa) already installed
[    2.919378] 
[    2.921526] .... node  #3, CPUs:   #56
[    2.937092] masked ExtINT on CPU#56
[    2.941288] CPU56: Thermal LVT vector (0xfa) already installed
[    2.950196]  #57
[    2.963557] masked ExtINT on CPU#57
[    2.967755] CPU57: Thermal LVT vector (0xfa) already installed
[    2.976665]  #58
[    2.990045] masked ExtINT on CPU#58
[    2.994248] CPU58: Thermal LVT vector (0xfa) already installed
[    3.003110]  #59
[    3.016850] masked ExtINT on CPU#59
[    3.021046] CPU59: Thermal LVT vector (0xfa) already installed
[    3.029890]  #60
[    3.043280] masked ExtINT on CPU#60
[    3.047513] CPU60: Thermal LVT vector (0xfa) already installed
[    3.056459]  #61
[    3.069808] masked ExtINT on CPU#61
[    3.074027] CPU61: Thermal LVT vector (0xfa) already installed
[    3.082880]  #62
[    3.096245] masked ExtINT on CPU#62
[    3.100465] CPU62: Thermal LVT vector (0xfa) already installed
[    3.109330]  #63
[    3.123034] masked ExtINT on CPU#63
[    3.127239] CPU63: Thermal LVT vector (0xfa) already installed
[    3.135993] x86: Booted up 4 nodes, 64 CPUs
[    3.141156] smpboot: Total of 64 processors activated (345427.09 BogoMIPS)
[    3.422135] devtmpfs: initialized
[    3.451546] PM: Registering ACPI NVS region [mem 0xbdd2f000-0xbde26fff] (1015808 bytes)
[    3.461439] PM: Registering ACPI NVS region [mem 0xbdea1000-0xbdf2efff] (581632 bytes)
[    3.474508] xor: automatically using best checksumming function:
[    3.521805]    avx       :  8846.000 MB/sec
[    3.526995] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    3.535449] NET: Registered protocol family 16
[    3.542518] cpuidle: using governor ladder
[    3.547573] cpuidle: using governor menu
[    3.553480] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    3.562796] ACPI: bus type PCI registered
[    3.567742] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    3.575648] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xc0000000-0xcfffffff] (base 0xc0000000)
[    3.586922] PCI: MMCONFIG at [mem 0xc0000000-0xcfffffff] reserved in E820
[    3.617307] PCI: Using configuration type 1 for base access
[    3.656758] bio: create slab <bio-0> at 0
[    3.729908] raid6: sse2x1    2858 MB/s
[    3.802686] raid6: sse2x2    3655 MB/s
[    3.875517] raid6: sse2x4    4515 MB/s
[    3.880176] raid6: using algorithm sse2x4 (4515 MB/s)
[    3.886282] raid6: using ssse3x2 recovery algorithm
[    3.892630] ACPI: Added _OSI(Module Device)
[    3.897776] ACPI: Added _OSI(Processor Device)
[    3.903217] ACPI: Added _OSI(3.0 _SCP Extensions)
[    3.908932] ACPI: Added _OSI(Processor Aggregator Device)
[    3.944879] ACPI: Executed 1 blocks of module-level executable AML code
[    4.173159] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    4.213006] ACPI: Interpreter enabled
[    4.217586] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131218/hwxface-580)
[    4.228954] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20131218/hwxface-580)
[    4.240313] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S4_] (20131218/hwxface-580)
[    4.251674] ACPI: (supports S0 S1 S5)
[    4.256228] ACPI: Using IOAPIC for interrupt routing
[    4.262508] HEST: Table parsing has been initialized.
[    4.268636] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    4.283373] ACPI: No dock devices found.
[    4.366791] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    4.374192] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    4.384777] acpi PNP0A08:00: _OSC: platform does not support [AER]
[    4.392616] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
[    4.402593] acpi PNP0A08:00: ignoring host bridge window [mem 0x000d0000-0x000d3fff] (conflicts with Adapter ROM [mem 0x000c8000-0x000d15ff])
[    4.418208] PCI host bridge to bus 0000:00
[    4.423264] pci_bus 0000:00: root bus resource [bus 00-3e]
[    4.429865] pci_bus 0000:00: root bus resource [io  0x0000-0x5fff]
[    4.437249] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    4.445400] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff]
[    4.453554] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff]
[    4.461711] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff]
[    4.469866] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff]
[    4.478018] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    4.486175] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    4.494329] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    4.502480] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    4.510636] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    4.518793] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff]
[    4.526948] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff]
[    4.535106] pci_bus 0000:00: root bus resource [mem 0x000f0000-0x000fffff]
[    4.543263] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xdfffffff]
[    4.551416] pci_bus 0000:00: root bus resource [mem 0x3c0000000000-0x3c007fffffff]
[    4.560752] pci 0000:00:00.0: [8086:3c00] type 00 class 0x060000
[    4.568027] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    4.575560] pci 0000:00:01.0: [8086:3c02] type 01 class 0x060400
[    4.582850] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    4.590227] pci 0000:00:01.0: System wakeup disabled by ACPI
[    4.597190] pci 0000:00:02.0: [8086:3c04] type 01 class 0x060400
[    4.604474] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    4.611864] pci 0000:00:02.0: System wakeup disabled by ACPI
[    4.618817] pci 0000:00:03.0: [8086:3c08] type 01 class 0x060400
[    4.626097] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    4.633482] pci 0000:00:03.0: System wakeup disabled by ACPI
[    4.640461] pci 0000:00:03.2: [8086:3c0a] type 01 class 0x060400
[    4.647745] pci 0000:00:03.2: PME# supported from D0 D3hot D3cold
[    4.655131] pci 0000:00:03.2: System wakeup disabled by ACPI
[    4.662095] pci 0000:00:04.0: [8086:3c20] type 00 class 0x088000
[    4.669302] pci 0000:00:04.0: reg 0x10: [mem 0xdff90000-0xdff93fff 64bit]
[    4.677684] pci 0000:00:04.1: [8086:3c21] type 00 class 0x088000
[    4.684901] pci 0000:00:04.1: reg 0x10: [mem 0xdff80000-0xdff83fff 64bit]
[    4.693273] pci 0000:00:04.2: [8086:3c22] type 00 class 0x088000
[    4.700486] pci 0000:00:04.2: reg 0x10: [mem 0xdff70000-0xdff73fff 64bit]
[    4.708866] pci 0000:00:04.3: [8086:3c23] type 00 class 0x088000
[    4.716073] pci 0000:00:04.3: reg 0x10: [mem 0xdff60000-0xdff63fff 64bit]
[    4.724424] pci 0000:00:04.4: [8086:3c24] type 00 class 0x088000
[    4.731640] pci 0000:00:04.4: reg 0x10: [mem 0xdff50000-0xdff53fff 64bit]
[    4.740017] pci 0000:00:04.5: [8086:3c25] type 00 class 0x088000
[    4.747232] pci 0000:00:04.5: reg 0x10: [mem 0xdff40000-0xdff43fff 64bit]
[    4.755586] pci 0000:00:04.6: [8086:3c26] type 00 class 0x088000
[    4.762791] pci 0000:00:04.6: reg 0x10: [mem 0xdff30000-0xdff33fff 64bit]
[    4.771157] pci 0000:00:04.7: [8086:3c27] type 00 class 0x088000
[    4.778356] pci 0000:00:04.7: reg 0x10: [mem 0xdff20000-0xdff23fff 64bit]
[    4.786722] pci 0000:00:05.0: [8086:3c28] type 00 class 0x088000
[    4.794176] pci 0000:00:05.2: [8086:3c2a] type 00 class 0x088000
[    4.801642] pci 0000:00:05.4: [8086:3c2c] type 00 class 0x080020
[    4.808842] pci 0000:00:05.4: reg 0x10: [mem 0xd0f60000-0xd0f60fff]
[    4.816630] pci 0000:00:05.6: [8086:3c40] type 00 class 0x110100
[    4.824114] pci 0000:00:06.0: [8086:3c60] type 00 class 0x088000
[    4.831562] pci 0000:00:06.1: [8086:3c61] type 00 class 0x060000
[    4.839016] pci 0000:00:06.2: [8086:3c62] type 00 class 0x060000
[    4.846465] pci 0000:00:06.3: [8086:3c63] type 00 class 0x060000
[    4.853946] pci 0000:00:06.4: [8086:3c64] type 00 class 0x060000
[    4.861396] pci 0000:00:06.5: [8086:3c65] type 00 class 0x060000
[    4.868863] pci 0000:00:06.6: [8086:3c66] type 00 class 0x060000
[    4.876308] pci 0000:00:06.7: [8086:3c67] type 00 class 0x060000
[    4.883766] pci 0000:00:07.0: [8086:3c68] type 00 class 0x060000
[    4.891224] pci 0000:00:07.1: [8086:3c69] type 00 class 0x060000
[    4.898685] pci 0000:00:07.2: [8086:3c6a] type 00 class 0x060000
[    4.906148] pci 0000:00:07.3: [8086:3c6b] type 00 class 0x060000
[    4.913613] pci 0000:00:07.4: [8086:3c6c] type 00 class 0x060000
[    4.921093] pci 0000:00:16.0: [8086:1d3a] type 00 class 0x078000
[    4.928302] pci 0000:00:16.0: reg 0x10: [mem 0xd0f50000-0xd0f5000f 64bit]
[    4.936448] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    4.944006] pci 0000:00:16.1: [8086:1d3b] type 00 class 0x078000
[    4.951211] pci 0000:00:16.1: reg 0x10: [mem 0xd0f40000-0xd0f4000f 64bit]
[    4.959350] pci 0000:00:16.1: PME# supported from D0 D3hot D3cold
[    4.966893] pci 0000:00:1a.0: [8086:1d2d] type 00 class 0x0c0320
[    4.974097] pci 0000:00:1a.0: reg 0x10: [mem 0xd0f20000-0xd0f203ff]
[    4.981691] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    4.989097] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    4.996049] pci 0000:00:1c.0: [8086:1d10] type 01 class 0x060400
[    5.003362] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    5.010744] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    5.017723] pci 0000:00:1c.7: [8086:1d1e] type 01 class 0x060400
[    5.025015] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    5.032404] pci 0000:00:1c.7: System wakeup disabled by ACPI
[    5.039367] pci 0000:00:1d.0: [8086:1d26] type 00 class 0x0c0320
[    5.046587] pci 0000:00:1d.0: reg 0x10: [mem 0xd0f10000-0xd0f103ff]
[    5.054170] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    5.061579] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    5.068541] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    5.075920] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    5.082863] pci 0000:00:1f.0: [8086:1d41] type 00 class 0x060100
[    5.090386] pci 0000:00:1f.2: [8086:1d02] type 00 class 0x010601
[    5.097606] pci 0000:00:1f.2: reg 0x10: [io  0x3070-0x3077]
[    5.104311] pci 0000:00:1f.2: reg 0x14: [io  0x3060-0x3063]
[    5.111010] pci 0000:00:1f.2: reg 0x18: [io  0x3050-0x3057]
[    5.117720] pci 0000:00:1f.2: reg 0x1c: [io  0x3040-0x3043]
[    5.124429] pci 0000:00:1f.2: reg 0x20: [io  0x3020-0x303f]
[    5.131128] pci 0000:00:1f.2: reg 0x24: [mem 0xd0f00000-0xd0f007ff]
[    5.138658] pci 0000:00:1f.2: PME# supported from D3hot
[    5.145250] pci 0000:00:1f.3: [8086:1d22] type 00 class 0x0c0500
[    5.152457] pci 0000:00:1f.3: reg 0x10: [mem 0xdff10000-0xdff100ff 64bit]
[    5.160538] pci 0000:00:1f.3: reg 0x20: [io  0x3000-0x301f]
[    5.167624] pci 0000:01:00.0: [8086:1d74] type 01 class 0x060400
[    5.174827] pci 0000:01:00.0: reg 0x10: [mem 0xd0e00000-0xd0e03fff]
[    5.182379] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    5.196673] pci 0000:00:01.0: PCI bridge to [bus 01-03]
[    5.202992] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    5.210276] pci 0000:00:01.0:   bridge window [mem 0xd0d00000-0xd0efffff]
[    5.227663] pci 0000:00:01.0:   bridge window [mem 0xdc800000-0xdd1fffff 64bit pref]
[    5.237374] pci 0000:02:08.0: [8086:1d3f] type 01 class 0x060400
[    5.244684] pci 0000:02:08.0: PME# supported from D0 D3hot D3cold
[    5.252210] pci 0000:01:00.0: PCI bridge to [bus 02-03]
[    5.258528] pci 0000:01:00.0:   bridge window [io  0x2000-0x2fff]
[    5.265816] pci 0000:01:00.0:   bridge window [mem 0xd0d00000-0xd0dfffff]
[    5.273883] pci 0000:01:00.0:   bridge window [mem 0xdc800000-0xdd1fffff 64bit pref]
[    5.283620] pci 0000:03:00.0: [8086:1d60] type 00 class 0x010700
[    5.290828] pci 0000:03:00.0: reg 0x10: [mem 0xdd000000-0xdd007fff 64bit pref]
[    5.299771] pci 0000:03:00.0: reg 0x18: [mem 0xdc800000-0xdcffffff 64bit pref]
[    5.308711] pci 0000:03:00.0: reg 0x20: [io  0x2100-0x21ff]
[    5.315422] pci 0000:03:00.0: reg 0x24: [io  0x2000-0x20ff]
[    5.322239] pci 0000:03:00.0: reg 0x164: [mem 0xdd010000-0xdd017fff 64bit pref]
[    5.331481] pci 0000:03:00.3: [8086:1d70] type 00 class 0x0c0500
[    5.338691] pci 0000:03:00.3: reg 0x10: [mem 0xd0d20000-0xd0d20fff]
[    5.346208] pci 0000:03:00.3: reg 0x20: [io  0x2240-0x225f]
[    5.352987] pci 0000:03:00.3: PME# supported from D0 D3hot D3cold
[    5.360474] pci 0000:03:00.4: [8086:1d71] type 00 class 0x0c0500
[    5.367679] pci 0000:03:00.4: reg 0x10: [mem 0xd0d10000-0xd0d10fff]
[    5.375198] pci 0000:03:00.4: reg 0x20: [io  0x2220-0x223f]
[    5.381982] pci 0000:03:00.4: PME# supported from D0 D3hot D3cold
[    5.389491] pci 0000:03:00.5: [8086:1d72] type 00 class 0x0c0500
[    5.396692] pci 0000:03:00.5: reg 0x10: [mem 0xd0d00000-0xd0d00fff]
[    5.404212] pci 0000:03:00.5: reg 0x20: [io  0x2200-0x221f]
[    5.410992] pci 0000:03:00.5: PME# supported from D0 D3hot D3cold
[    5.418512] pci 0000:02:08.0: PCI bridge to [bus 03]
[    5.424544] pci 0000:02:08.0:   bridge window [io  0x2000-0x2fff]
[    5.431830] pci 0000:02:08.0:   bridge window [mem 0xd0d00000-0xd0dfffff]
[    5.439896] pci 0000:02:08.0:   bridge window [mem 0xdc800000-0xdd1fffff 64bit pref]
[    5.449747] pci 0000:00:02.0: PCI bridge to [bus 04]
[    5.456057] pci 0000:00:03.0: PCI bridge to [bus 05]
[    5.462405] pci 0000:06:00.0: [8086:1528] type 00 class 0x020000
[    5.469608] pci 0000:06:00.0: reg 0x10: [mem 0xdd600000-0xdd7fffff 64bit pref]
[    5.478554] pci 0000:06:00.0: reg 0x18: [io  0x1020-0x103f]
[    5.485255] pci 0000:06:00.0: reg 0x20: [mem 0xdd810000-0xdd813fff 64bit pref]
[    5.494257] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    5.501570] pci 0000:06:00.0: reg 0x184: [mem 0xd0c00000-0xd0c03fff 64bit]
[    5.509730] pci 0000:06:00.0: reg 0x190: [mem 0xd0b00000-0xd0b03fff 64bit]
[    5.518124] pci 0000:06:00.1: [8086:1528] type 00 class 0x020000
[    5.525326] pci 0000:06:00.1: reg 0x10: [mem 0xdd400000-0xdd5fffff 64bit pref]
[    5.534270] pci 0000:06:00.1: reg 0x18: [io  0x1000-0x101f]
[    5.540982] pci 0000:06:00.1: reg 0x20: [mem 0xdd800000-0xdd803fff 64bit pref]
[    5.549979] pci 0000:06:00.1: PME# supported from D0 D3hot D3cold
[    5.557282] pci 0000:06:00.1: reg 0x184: [mem 0xd0a00000-0xd0a03fff 64bit]
[    5.565451] pci 0000:06:00.1: reg 0x190: [mem 0xd0900000-0xd0903fff 64bit]
[    5.579772] pci 0000:00:03.2: PCI bridge to [bus 06-07]
[    5.586095] pci 0000:00:03.2:   bridge window [io  0x1000-0x1fff]
[    5.593378] pci 0000:00:03.2:   bridge window [mem 0xd0900000-0xd0cfffff]
[    5.601444] pci 0000:00:03.2:   bridge window [mem 0xdd400000-0xdd8fffff 64bit pref]
[    5.611160] pci 0000:00:1c.0: PCI bridge to [bus 08]
[    5.617393] pci 0000:09:00.0: [102b:0522] type 00 class 0x030000
[    5.624605] pci 0000:09:00.0: reg 0x10: [mem 0xde000000-0xdeffffff pref]
[    5.632590] pci 0000:09:00.0: reg 0x14: [mem 0xd0810000-0xd0813fff]
[    5.640085] pci 0000:09:00.0: reg 0x18: [mem 0xd0000000-0xd07fffff]
[    5.647631] pci 0000:09:00.0: reg 0x30: [mem 0xd0800000-0xd080ffff pref]
[    5.655744] pci 0000:09:00.0: System wakeup disabled by ACPI
[    5.670585] pci 0000:00:1c.7: PCI bridge to [bus 09]
[    5.676602] pci 0000:00:1c.7:   bridge window [mem 0xd0000000-0xd08fffff]
[    5.684668] pci 0000:00:1c.7:   bridge window [mem 0xde000000-0xdeffffff 64bit pref]
[    5.694370] pci 0000:00:1e.0: PCI bridge to [bus 0a] (subtractive decode)
[    5.702442] pci 0000:00:1e.0:   bridge window [io  0x0000-0x5fff] (subtractive decode)
[    5.712153] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    5.722635] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000c3fff] (subtractive decode)
[    5.733119] pci 0000:00:1e.0:   bridge window [mem 0x000c4000-0x000c7fff] (subtractive decode)
[    5.743613] pci 0000:00:1e.0:   bridge window [mem 0x000c8000-0x000cbfff] (subtractive decode)
[    5.754108] pci 0000:00:1e.0:   bridge window [mem 0x000cc000-0x000cffff] (subtractive decode)
[    5.764595] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    5.775075] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    5.785552] pci 0000:00:1e.0:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
[    5.796023] pci 0000:00:1e.0:   bridge window [mem 0x000e0000-0x000e3fff] (subtractive decode)
[    5.806516] pci 0000:00:1e.0:   bridge window [mem 0x000e4000-0x000e7fff] (subtractive decode)
[    5.817012] pci 0000:00:1e.0:   bridge window [mem 0x000e8000-0x000ebfff] (subtractive decode)
[    5.827503] pci 0000:00:1e.0:   bridge window [mem 0x000ec000-0x000effff] (subtractive decode)
[    5.837998] pci 0000:00:1e.0:   bridge window [mem 0x000f0000-0x000fffff] (subtractive decode)
[    5.848485] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xdfffffff] (subtractive decode)
[    5.858971] pci 0000:00:1e.0:   bridge window [mem 0x3c0000000000-0x3c007fffffff] (subtractive decode)
[    5.870306] pci_bus 0000:00: on NUMA node 0 (pxm 0)
[    5.876215] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
[    5.886019] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
[    5.896754] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
[    5.907475] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *10 11 12 14 15), disabled.
[    5.918205] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14 15), disabled.
[    5.928911] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 10 11 12 14 15), disabled.
[    5.939648] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
[    5.950343] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *10 11 12 14 15), disabled.
[    5.961068] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14 15), disabled.
[    5.972007] ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 40-7e])
[    5.979395] acpi PNP0A08:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    5.989713] acpi PNP0A08:01: _OSC: platform does not support [AER]
[    5.997383] acpi PNP0A08:01: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
[    6.007572] PCI host bridge to bus 0000:40
[    6.012624] pci_bus 0000:40: root bus resource [bus 40-7e]
[    6.019224] pci_bus 0000:40: root bus resource [io  0x03b0-0x03df]
[    6.026602] pci_bus 0000:40: root bus resource [io  0x6000-0x7fff]
[    6.033983] pci_bus 0000:40: root bus resource [mem 0x000a0000-0x000bffff]
[    6.042140] pci_bus 0000:40: root bus resource [mem 0xe0000000-0xebffffff]
[    6.050296] pci_bus 0000:40: root bus resource [mem 0x3c0080000000-0x3c00ffffffff]
[    6.059643] pci 0000:40:01.0: [8086:3c02] type 01 class 0x060400
[    6.066927] pci 0000:40:01.0: PME# supported from D0 D3hot D3cold
[    6.074280] pci 0000:40:01.0: System wakeup disabled by ACPI
[    6.081225] pci 0000:40:02.0: [8086:3c04] type 01 class 0x060400
[    6.088519] pci 0000:40:02.0: PME# supported from D0 D3hot D3cold
[    6.095870] pci 0000:40:02.0: System wakeup disabled by ACPI
[    6.102852] pci 0000:40:04.0: [8086:3c20] type 00 class 0x088000
[    6.110057] pci 0000:40:04.0: reg 0x10: [mem 0xebf70000-0xebf73fff 64bit]
[    6.118404] pci 0000:40:04.1: [8086:3c21] type 00 class 0x088000
[    6.125615] pci 0000:40:04.1: reg 0x10: [mem 0xebf60000-0xebf63fff 64bit]
[    6.133974] pci 0000:40:04.2: [8086:3c22] type 00 class 0x088000
[    6.141184] pci 0000:40:04.2: reg 0x10: [mem 0xebf50000-0xebf53fff 64bit]
[    6.149507] pci 0000:40:04.3: [8086:3c23] type 00 class 0x088000
[    6.156709] pci 0000:40:04.3: reg 0x10: [mem 0xebf40000-0xebf43fff 64bit]
[    6.165015] pci 0000:40:04.4: [8086:3c24] type 00 class 0x088000
[    6.172223] pci 0000:40:04.4: reg 0x10: [mem 0xebf30000-0xebf33fff 64bit]
[    6.180565] pci 0000:40:04.5: [8086:3c25] type 00 class 0x088000
[    6.187780] pci 0000:40:04.5: reg 0x10: [mem 0xebf20000-0xebf23fff 64bit]
[    6.196137] pci 0000:40:04.6: [8086:3c26] type 00 class 0x088000
[    6.203340] pci 0000:40:04.6: reg 0x10: [mem 0xebf10000-0xebf13fff 64bit]
[    6.211680] pci 0000:40:04.7: [8086:3c27] type 00 class 0x088000
[    6.218896] pci 0000:40:04.7: reg 0x10: [mem 0xebf00000-0xebf03fff 64bit]
[    6.227227] pci 0000:40:05.0: [8086:3c28] type 00 class 0x088000
[    6.234690] pci 0000:40:05.2: [8086:3c2a] type 00 class 0x088000
[    6.242154] pci 0000:40:05.4: [8086:3c2c] type 00 class 0x080020
[    6.249350] pci 0000:40:05.4: reg 0x10: [mem 0xe0000000-0xe0000fff]
[    6.257056] pci 0000:40:05.6: [8086:3c40] type 00 class 0x110100
[    6.264485] pci 0000:40:06.0: [8086:3c60] type 00 class 0x088000
[    6.271945] pci 0000:40:06.1: [8086:3c61] type 00 class 0x060000
[    6.279368] pci 0000:40:06.2: [8086:3c62] type 00 class 0x060000
[    6.286791] pci 0000:40:06.3: [8086:3c63] type 00 class 0x060000
[    6.294228] pci 0000:40:06.4: [8086:3c64] type 00 class 0x060000
[    6.301634] pci 0000:40:06.5: [8086:3c65] type 00 class 0x060000
[    6.309066] pci 0000:40:06.6: [8086:3c66] type 00 class 0x060000
[    6.316545] pci 0000:40:06.7: [8086:3c67] type 00 class 0x060000
[    6.323963] pci 0000:40:07.0: [8086:3c68] type 00 class 0x060000
[    6.331398] pci 0000:40:07.1: [8086:3c69] type 00 class 0x060000
[    6.338816] pci 0000:40:07.2: [8086:3c6a] type 00 class 0x060000
[    6.346255] pci 0000:40:07.3: [8086:3c6b] type 00 class 0x060000
[    6.353672] pci 0000:40:07.4: [8086:3c6c] type 00 class 0x060000
[    6.361251] pci 0000:40:01.0: PCI bridge to [bus 41]
[    6.367450] pci 0000:40:02.0: PCI bridge to [bus 42]
[    6.373485] pci_bus 0000:40: on NUMA node 1 (pxm 1)
[    6.388694] acpi PNP0A08:01: Disabling ASPM (FADT indicates it is unsupported)
[    6.397980] ACPI: PCI Root Bridge [PCI2] (domain 0000 [bus 80-be])
[    6.405358] acpi PNP0A08:02: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    6.415682] acpi PNP0A08:02: _OSC: platform does not support [AER]
[    6.423349] acpi PNP0A08:02: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
[    6.433535] PCI host bridge to bus 0000:80
[    6.438590] pci_bus 0000:80: root bus resource [bus 80-be]
[    6.445198] pci_bus 0000:80: root bus resource [io  0x8000-0xbfff]
[    6.452575] pci_bus 0000:80: root bus resource [mem 0xec000000-0xf7ffffff]
[    6.460732] pci_bus 0000:80: root bus resource [mem 0x3c0100000000-0x3c017fffffff]
[    6.470075] pci 0000:80:02.0: [8086:3c04] type 01 class 0x060400
[    6.477377] pci 0000:80:02.0: PME# supported from D0 D3hot D3cold
[    6.484725] pci 0000:80:02.0: System wakeup disabled by ACPI
[    6.491705] pci 0000:80:03.0: [8086:3c08] type 01 class 0x060400
[    6.499008] pci 0000:80:03.0: PME# supported from D0 D3hot D3cold
[    6.506359] pci 0000:80:03.0: System wakeup disabled by ACPI
[    6.513308] pci 0000:80:04.0: [8086:3c20] type 00 class 0x088000
[    6.520519] pci 0000:80:04.0: reg 0x10: [mem 0xf7f70000-0xf7f73fff 64bit]
[    6.528863] pci 0000:80:04.1: [8086:3c21] type 00 class 0x088000
[    6.536069] pci 0000:80:04.1: reg 0x10: [mem 0xf7f60000-0xf7f63fff 64bit]
[    6.544408] pci 0000:80:04.2: [8086:3c22] type 00 class 0x088000
[    6.551621] pci 0000:80:04.2: reg 0x10: [mem 0xf7f50000-0xf7f53fff 64bit]
[    6.559957] pci 0000:80:04.3: [8086:3c23] type 00 class 0x088000
[    6.567166] pci 0000:80:04.3: reg 0x10: [mem 0xf7f40000-0xf7f43fff 64bit]
[    6.575507] pci 0000:80:04.4: [8086:3c24] type 00 class 0x088000
[    6.582712] pci 0000:80:04.4: reg 0x10: [mem 0xf7f30000-0xf7f33fff 64bit]
[    6.591043] pci 0000:80:04.5: [8086:3c25] type 00 class 0x088000
[    6.598237] pci 0000:80:04.5: reg 0x10: [mem 0xf7f20000-0xf7f23fff 64bit]
[    6.606588] pci 0000:80:04.6: [8086:3c26] type 00 class 0x088000
[    6.613784] pci 0000:80:04.6: reg 0x10: [mem 0xf7f10000-0xf7f13fff 64bit]
[    6.622126] pci 0000:80:04.7: [8086:3c27] type 00 class 0x088000
[    6.629332] pci 0000:80:04.7: reg 0x10: [mem 0xf7f00000-0xf7f03fff 64bit]
[    6.637672] pci 0000:80:05.0: [8086:3c28] type 00 class 0x088000
[    6.645092] pci 0000:80:05.2: [8086:3c2a] type 00 class 0x088000
[    6.652517] pci 0000:80:05.4: [8086:3c2c] type 00 class 0x080020
[    6.659723] pci 0000:80:05.4: reg 0x10: [mem 0xec000000-0xec000fff]
[    6.667468] pci 0000:80:05.6: [8086:3c40] type 00 class 0x110100
[    6.674904] pci 0000:80:06.0: [8086:3c60] type 00 class 0x088000
[    6.682313] pci 0000:80:06.1: [8086:3c61] type 00 class 0x060000
[    6.689732] pci 0000:80:06.2: [8086:3c62] type 00 class 0x060000
[    6.697138] pci 0000:80:06.3: [8086:3c63] type 00 class 0x060000
[    6.704589] pci 0000:80:06.4: [8086:3c64] type 00 class 0x060000
[    6.712104] pci 0000:80:06.5: [8086:3c65] type 00 class 0x060000
[    6.719538] pci 0000:80:06.6: [8086:3c66] type 00 class 0x060000
[    6.726960] pci 0000:80:06.7: [8086:3c67] type 00 class 0x060000
[    6.734390] pci 0000:80:07.0: [8086:3c68] type 00 class 0x060000
[    6.741825] pci 0000:80:07.1: [8086:3c69] type 00 class 0x060000
[    6.749259] pci 0000:80:07.2: [8086:3c6a] type 00 class 0x060000
[    6.756684] pci 0000:80:07.3: [8086:3c6b] type 00 class 0x060000
[    6.764108] pci 0000:80:07.4: [8086:3c6c] type 00 class 0x060000
[    6.771835] acpiphp: Slot [2] registered
[    6.776770] pci 0000:80:02.0: PCI bridge to [bus 81]
[    6.782979] pci 0000:80:03.0: PCI bridge to [bus 82]
[    6.789019] pci_bus 0000:80: on NUMA node 2 (pxm 2)
[    6.794956] acpi PNP0A08:02: Disabling ASPM (FADT indicates it is unsupported)
[    6.804307] ACPI: PCI Root Bridge [PCI3] (domain 0000 [bus c0-fe])
[    6.811695] acpi PNP0A08:03: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    6.822008] acpi PNP0A08:03: _OSC: platform does not support [AER]
[    6.829678] acpi PNP0A08:03: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
[    6.839863] PCI host bridge to bus 0000:c0
[    6.844913] pci_bus 0000:c0: root bus resource [bus c0-fe]
[    6.851511] pci_bus 0000:c0: root bus resource [io  0xc000-0xffff]
[    6.858892] pci_bus 0000:c0: root bus resource [mem 0xf8000000-0xfbffffff]
[    6.867045] pci_bus 0000:c0: root bus resource [mem 0x3c0180000000-0x3c01ffffffff]
[    6.876377] pci 0000:c0:02.0: [8086:3c04] type 01 class 0x060400
[    6.883672] pci 0000:c0:02.0: PME# supported from D0 D3hot D3cold
[    6.891025] pci 0000:c0:02.0: System wakeup disabled by ACPI
[    6.897990] pci 0000:c0:03.0: [8086:3c08] type 01 class 0x060400
[    6.905286] pci 0000:c0:03.0: PME# supported from D0 D3hot D3cold
[    6.912623] pci 0000:c0:03.0: System wakeup disabled by ACPI
[    6.919602] pci 0000:c0:04.0: [8086:3c20] type 00 class 0x088000
[    6.926805] pci 0000:c0:04.0: reg 0x10: [mem 0xfbf70000-0xfbf73fff 64bit]
[    6.935174] pci 0000:c0:04.1: [8086:3c21] type 00 class 0x088000
[    6.942370] pci 0000:c0:04.1: reg 0x10: [mem 0xfbf60000-0xfbf63fff 64bit]
[    6.950711] pci 0000:c0:04.2: [8086:3c22] type 00 class 0x088000
[    6.957916] pci 0000:c0:04.2: reg 0x10: [mem 0xfbf50000-0xfbf53fff 64bit]
[    6.966281] pci 0000:c0:04.3: [8086:3c23] type 00 class 0x088000
[    6.973491] pci 0000:c0:04.3: reg 0x10: [mem 0xfbf40000-0xfbf43fff 64bit]
[    6.981922] pci 0000:c0:04.4: [8086:3c24] type 00 class 0x088000
[    6.989123] pci 0000:c0:04.4: reg 0x10: [mem 0xfbf30000-0xfbf33fff 64bit]
[    6.997465] pci 0000:c0:04.5: [8086:3c25] type 00 class 0x088000
[    7.004664] pci 0000:c0:04.5: reg 0x10: [mem 0xfbf20000-0xfbf23fff 64bit]
[    7.012971] pci 0000:c0:04.6: [8086:3c26] type 00 class 0x088000
[    7.020177] pci 0000:c0:04.6: reg 0x10: [mem 0xfbf10000-0xfbf13fff 64bit]
[    7.028511] pci 0000:c0:04.7: [8086:3c27] type 00 class 0x088000
[    7.035720] pci 0000:c0:04.7: reg 0x10: [mem 0xfbf00000-0xfbf03fff 64bit]
[    7.044068] pci 0000:c0:05.0: [8086:3c28] type 00 class 0x088000
[    7.051534] pci 0000:c0:05.2: [8086:3c2a] type 00 class 0x088000
[    7.058949] pci 0000:c0:05.4: [8086:3c2c] type 00 class 0x080020
[    7.066151] pci 0000:c0:05.4: reg 0x10: [mem 0xf8000000-0xf8000fff]
[    7.073886] pci 0000:c0:05.6: [8086:3c40] type 00 class 0x110100
[    7.081344] pci 0000:c0:06.0: [8086:3c60] type 00 class 0x088000
[    7.088775] pci 0000:c0:06.1: [8086:3c61] type 00 class 0x060000
[    7.096196] pci 0000:c0:06.2: [8086:3c62] type 00 class 0x060000
[    7.103631] pci 0000:c0:06.3: [8086:3c63] type 00 class 0x060000
[    7.111056] pci 0000:c0:06.4: [8086:3c64] type 00 class 0x060000
[    7.118499] pci 0000:c0:06.5: [8086:3c65] type 00 class 0x060000
[    7.125948] pci 0000:c0:06.6: [8086:3c66] type 00 class 0x060000
[    7.133388] pci 0000:c0:06.7: [8086:3c67] type 00 class 0x060000
[    7.140806] pci 0000:c0:07.0: [8086:3c68] type 00 class 0x060000
[    7.148255] pci 0000:c0:07.1: [8086:3c69] type 00 class 0x060000
[    7.155677] pci 0000:c0:07.2: [8086:3c6a] type 00 class 0x060000
[    7.163098] pci 0000:c0:07.3: [8086:3c6b] type 00 class 0x060000
[    7.170548] pci 0000:c0:07.4: [8086:3c6c] type 00 class 0x060000
[    7.178326] acpiphp: Slot [2-2] registered
[    7.183445] pci 0000:c0:02.0: PCI bridge to [bus c1]
[    7.189812] acpiphp: Slot [2-3] registered
[    7.194964] pci 0000:c0:03.0: PCI bridge to [bus c2]
[    7.201001] pci_bus 0000:c0: on NUMA node 3 (pxm 3)
[    7.206913] acpi PNP0A08:03: Disabling ASPM (FADT indicates it is unsupported)
[    7.237064] ACPI: PCI Root Bridge [UCR0] (domain 0000 [bus 3f])
[    7.244165] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    7.254226] acpi PNP0A03:00: _OSC: platform does not support [PCIeHotplug PME AER]
[    7.263599] acpi PNP0A03:00: _OSC: OS now controls [PCIeCapability]
[    7.271298] PCI host bridge to bus 0000:3f
[    7.276348] pci_bus 0000:3f: root bus resource [bus 3f]
[    7.282667] pci 0000:3f:08.0: [8086:3c80] type 00 class 0x088000
[    7.290060] pci 0000:3f:08.2: [8086:3c41] type 00 class 0x110100
[    7.297439] pci 0000:3f:08.3: [8086:3c83] type 00 class 0x088000
[    7.304817] pci 0000:3f:08.4: [8086:3c84] type 00 class 0x088000
[    7.312199] pci 0000:3f:08.5: [8086:3c85] type 00 class 0x088000
[    7.319546] pci 0000:3f:08.6: [8086:3c86] type 00 class 0x088000
[    7.326944] pci 0000:3f:08.7: [8086:3c87] type 00 class 0x088000
[    7.334341] pci 0000:3f:09.0: [8086:3c90] type 00 class 0x088000
[    7.341704] pci 0000:3f:09.2: [8086:3c42] type 00 class 0x110100
[    7.349047] pci 0000:3f:09.3: [8086:3c93] type 00 class 0x088000
[    7.356428] pci 0000:3f:09.4: [8086:3c94] type 00 class 0x088000
[    7.363784] pci 0000:3f:09.5: [8086:3c95] type 00 class 0x088000
[    7.371159] pci 0000:3f:09.6: [8086:3c96] type 00 class 0x088000
[    7.378567] pci 0000:3f:0a.0: [8086:3cc0] type 00 class 0x088000
[    7.386008] pci 0000:3f:0a.1: [8086:3cc1] type 00 class 0x088000
[    7.393389] pci 0000:3f:0a.2: [8086:3cc2] type 00 class 0x088000
[    7.400785] pci 0000:3f:0a.3: [8086:3cd0] type 00 class 0x088000
[    7.408143] pci 0000:3f:0a.4: [8086:3cc4] type 00 class 0x088000
[    7.415511] pci 0000:3f:0a.5: [8086:3cc5] type 00 class 0x088000
[    7.422864] pci 0000:3f:0a.6: [8086:3cc6] type 00 class 0x088000
[    7.430254] pci 0000:3f:0a.7: [8086:3cc7] type 00 class 0x088000
[    7.437634] pci 0000:3f:0b.0: [8086:3ce0] type 00 class 0x088000
[    7.444995] pci 0000:3f:0b.2: [8086:3ce2] type 00 class 0x088000
[    7.452372] pci 0000:3f:0b.3: [8086:3ce3] type 00 class 0x088000
[    7.459745] pci 0000:3f:0c.0: [8086:3ce8] type 00 class 0x088000
[    7.467121] pci 0000:3f:0c.1: [8086:3ce8] type 00 class 0x088000
[    7.474478] pci 0000:3f:0c.2: [8086:3ce8] type 00 class 0x088000
[    7.481883] pci 0000:3f:0c.3: [8086:3ce8] type 00 class 0x088000
[    7.489233] pci 0000:3f:0c.6: [8086:3cf4] type 00 class 0x088000
[    7.496594] pci 0000:3f:0c.7: [8086:3cf6] type 00 class 0x088000
[    7.503946] pci 0000:3f:0d.0: [8086:3ce8] type 00 class 0x088000
[    7.511317] pci 0000:3f:0d.1: [8086:3ce8] type 00 class 0x088000
[    7.518689] pci 0000:3f:0d.2: [8086:3ce8] type 00 class 0x088000
[    7.526061] pci 0000:3f:0d.3: [8086:3ce8] type 00 class 0x088000
[    7.533411] pci 0000:3f:0d.6: [8086:3cf5] type 00 class 0x088000
[    7.540798] pci 0000:3f:0e.0: [8086:3ca0] type 00 class 0x088000
[    7.548161] pci 0000:3f:0e.1: [8086:3c46] type 00 class 0x110100
[    7.555514] pci 0000:3f:0e.2: [8086:3c70] type 00 class 0x088000
[    7.562901] pci 0000:3f:0f.0: [8086:3ca8] type 00 class 0x088000
[    7.570288] pci 0000:3f:0f.1: [8086:3c71] type 00 class 0x088000
[    7.577680] pci 0000:3f:0f.2: [8086:3caa] type 00 class 0x088000
[    7.585060] pci 0000:3f:0f.3: [8086:3cab] type 00 class 0x088000
[    7.592463] pci 0000:3f:0f.4: [8086:3cac] type 00 class 0x088000
[    7.599875] pci 0000:3f:0f.5: [8086:3cad] type 00 class 0x088000
[    7.607264] pci 0000:3f:0f.6: [8086:3cae] type 00 class 0x088000
[    7.614663] pci 0000:3f:0f.7: [8086:3caf] type 00 class 0x088000
[    7.622068] pci 0000:3f:10.0: [8086:3cb0] type 00 class 0x088000
[    7.629483] pci 0000:3f:10.1: [8086:3cb1] type 00 class 0x088000
[    7.636896] pci 0000:3f:10.2: [8086:3cb2] type 00 class 0x088000
[    7.644268] pci 0000:3f:10.3: [8086:3cb3] type 00 class 0x088000
[    7.651669] pci 0000:3f:10.4: [8086:3cb4] type 00 class 0x088000
[    7.659083] pci 0000:3f:10.5: [8086:3cb5] type 00 class 0x088000
[    7.666484] pci 0000:3f:10.6: [8086:3cb6] type 00 class 0x088000
[    7.683206] pci 0000:3f:10.7: [8086:3cb7] type 00 class 0x088000
[    7.690576] pci 0000:3f:11.0: [8086:3cb8] type 00 class 0x088000
[    7.697933] pci 0000:3f:11.1: [8086:3cb9] type 00 class 0x088000
[    7.705320] pci 0000:3f:11.2: [8086:3cba] type 00 class 0x088000
[    7.712688] pci 0000:3f:11.3: [8086:3cbb] type 00 class 0x088000
[    7.720067] pci 0000:3f:11.4: [8086:3cbc] type 00 class 0x088000
[    7.727444] pci 0000:3f:11.5: [8086:3cbd] type 00 class 0x088000
[    7.734814] pci 0000:3f:11.6: [8086:3cbe] type 00 class 0x088000
[    7.742197] pci 0000:3f:11.7: [8086:3cbf] type 00 class 0x088000
[    7.749562] pci 0000:3f:13.0: [8086:3ce4] type 00 class 0x088000
[    7.756945] pci 0000:3f:13.1: [8086:3c43] type 00 class 0x110100
[    7.764292] pci 0000:3f:13.4: [8086:3ce6] type 00 class 0x110100
[    7.771675] pci 0000:3f:13.5: [8086:3c44] type 00 class 0x110100
[    7.779061] pci 0000:3f:13.6: [8086:3c45] type 00 class 0x088000
[    7.786500] acpi PNP0A03:00: Disabling ASPM (FADT indicates it is unsupported)
[    7.795529] ACPI: PCI Root Bridge [UCR1] (domain 0000 [bus 7f])
[    7.802619] acpi PNP0A03:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    7.812683] acpi PNP0A03:01: _OSC: platform does not support [PCIeHotplug PME AER]
[    7.822047] acpi PNP0A03:01: _OSC: OS now controls [PCIeCapability]
[    7.829714] PCI host bridge to bus 0000:7f
[    7.834774] pci_bus 0000:7f: root bus resource [bus 7f]
[    7.841097] pci 0000:7f:08.0: [8086:3c80] type 00 class 0x088000
[    7.848487] pci 0000:7f:08.2: [8086:3c41] type 00 class 0x110100
[    7.855868] pci 0000:7f:08.3: [8086:3c83] type 00 class 0x088000
[    7.863275] pci 0000:7f:08.4: [8086:3c84] type 00 class 0x088000
[    7.870678] pci 0000:7f:08.5: [8086:3c85] type 00 class 0x088000
[    7.878078] pci 0000:7f:08.6: [8086:3c86] type 00 class 0x088000
[    7.885447] pci 0000:7f:08.7: [8086:3c87] type 00 class 0x088000
[    7.892832] pci 0000:7f:09.0: [8086:3c90] type 00 class 0x088000
[    7.900214] pci 0000:7f:09.2: [8086:3c42] type 00 class 0x110100
[    7.907610] pci 0000:7f:09.3: [8086:3c93] type 00 class 0x088000
[    7.915023] pci 0000:7f:09.4: [8086:3c94] type 00 class 0x088000
[    7.922431] pci 0000:7f:09.5: [8086:3c95] type 00 class 0x088000
[    7.929854] pci 0000:7f:09.6: [8086:3c96] type 00 class 0x088000
[    7.937243] pci 0000:7f:0a.0: [8086:3cc0] type 00 class 0x088000
[    7.944607] pci 0000:7f:0a.1: [8086:3cc1] type 00 class 0x088000
[    7.952008] pci 0000:7f:0a.2: [8086:3cc2] type 00 class 0x088000
[    7.959394] pci 0000:7f:0a.3: [8086:3cd0] type 00 class 0x088000
[    7.966778] pci 0000:7f:0a.4: [8086:3cc4] type 00 class 0x088000
[    7.974173] pci 0000:7f:0a.5: [8086:3cc5] type 00 class 0x088000
[    7.981539] pci 0000:7f:0a.6: [8086:3cc6] type 00 class 0x088000
[    7.988883] pci 0000:7f:0a.7: [8086:3cc7] type 00 class 0x088000
[    7.996252] pci 0000:7f:0b.0: [8086:3ce0] type 00 class 0x088000
[    8.003643] pci 0000:7f:0b.2: [8086:3ce2] type 00 class 0x088000
[    8.011024] pci 0000:7f:0b.3: [8086:3ce3] type 00 class 0x088000
[    8.018409] pci 0000:7f:0c.0: [8086:3ce8] type 00 class 0x088000
[    8.025785] pci 0000:7f:0c.1: [8086:3ce8] type 00 class 0x088000
[    8.033146] pci 0000:7f:0c.2: [8086:3ce8] type 00 class 0x088000
[    8.040514] pci 0000:7f:0c.3: [8086:3ce8] type 00 class 0x088000
[    8.047892] pci 0000:7f:0c.6: [8086:3cf4] type 00 class 0x088000
[    8.055274] pci 0000:7f:0c.7: [8086:3cf6] type 00 class 0x088000
[    8.062665] pci 0000:7f:0d.0: [8086:3ce8] type 00 class 0x088000
[    8.070059] pci 0000:7f:0d.1: [8086:3ce8] type 00 class 0x088000
[    8.077409] pci 0000:7f:0d.2: [8086:3ce8] type 00 class 0x088000
[    8.084792] pci 0000:7f:0d.3: [8086:3ce8] type 00 class 0x088000
[    8.092163] pci 0000:7f:0d.6: [8086:3cf5] type 00 class 0x088000
[    8.099549] pci 0000:7f:0e.0: [8086:3ca0] type 00 class 0x088000
[    8.106912] pci 0000:7f:0e.1: [8086:3c46] type 00 class 0x110100
[    8.114307] pci 0000:7f:0e.2: [8086:3c70] type 00 class 0x088000
[    8.121683] pci 0000:7f:0f.0: [8086:3ca8] type 00 class 0x088000
[    8.129064] pci 0000:7f:0f.1: [8086:3c71] type 00 class 0x088000
[    8.136449] pci 0000:7f:0f.2: [8086:3caa] type 00 class 0x088000
[    8.143858] pci 0000:7f:0f.3: [8086:3cab] type 00 class 0x088000
[    8.151261] pci 0000:7f:0f.4: [8086:3cac] type 00 class 0x088000
[    8.158661] pci 0000:7f:0f.5: [8086:3cad] type 00 class 0x088000
[    8.166058] pci 0000:7f:0f.6: [8086:3cae] type 00 class 0x088000
[    8.173411] pci 0000:7f:0f.7: [8086:3caf] type 00 class 0x088000
[    8.180783] pci 0000:7f:10.0: [8086:3cb0] type 00 class 0x088000
[    8.188177] pci 0000:7f:10.1: [8086:3cb1] type 00 class 0x088000
[    8.195576] pci 0000:7f:10.2: [8086:3cb2] type 00 class 0x088000
[    8.203002] pci 0000:7f:10.3: [8086:3cb3] type 00 class 0x088000
[    8.210406] pci 0000:7f:10.4: [8086:3cb4] type 00 class 0x088000
[    8.217820] pci 0000:7f:10.5: [8086:3cb5] type 00 class 0x088000
[    8.225224] pci 0000:7f:10.6: [8086:3cb6] type 00 class 0x088000
[    8.232623] pci 0000:7f:10.7: [8086:3cb7] type 00 class 0x088000
[    8.240036] pci 0000:7f:11.0: [8086:3cb8] type 00 class 0x088000
[    8.247418] pci 0000:7f:11.1: [8086:3cb9] type 00 class 0x088000
[    8.254816] pci 0000:7f:11.2: [8086:3cba] type 00 class 0x088000
[    8.262214] pci 0000:7f:11.3: [8086:3cbb] type 00 class 0x088000
[    8.269579] pci 0000:7f:11.4: [8086:3cbc] type 00 class 0x088000
[    8.276949] pci 0000:7f:11.5: [8086:3cbd] type 00 class 0x088000
[    8.284328] pci 0000:7f:11.6: [8086:3cbe] type 00 class 0x088000
[    8.291715] pci 0000:7f:11.7: [8086:3cbf] type 00 class 0x088000
[    8.299114] pci 0000:7f:13.0: [8086:3ce4] type 00 class 0x088000
[    8.306501] pci 0000:7f:13.1: [8086:3c43] type 00 class 0x110100
[    8.313871] pci 0000:7f:13.4: [8086:3ce6] type 00 class 0x110100
[    8.321233] pci 0000:7f:13.5: [8086:3c44] type 00 class 0x110100
[    8.328596] pci 0000:7f:13.6: [8086:3c45] type 00 class 0x088000
[    8.336013] acpi PNP0A03:01: Disabling ASPM (FADT indicates it is unsupported)
[    8.345064] ACPI: PCI Root Bridge [UCR2] (domain 0000 [bus bf])
[    8.352159] acpi PNP0A03:02: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    8.362217] acpi PNP0A03:02: _OSC: platform does not support [PCIeHotplug PME AER]
[    8.371584] acpi PNP0A03:02: _OSC: OS now controls [PCIeCapability]
[    8.379285] PCI host bridge to bus 0000:bf
[    8.384339] pci_bus 0000:bf: root bus resource [bus bf]
[    8.390663] pci 0000:bf:08.0: [8086:3c80] type 00 class 0x088000
[    8.398032] pci 0000:bf:08.2: [8086:3c41] type 00 class 0x110100
[    8.405396] pci 0000:bf:08.3: [8086:3c83] type 00 class 0x088000
[    8.412805] pci 0000:bf:08.4: [8086:3c84] type 00 class 0x088000
[    8.420220] pci 0000:bf:08.5: [8086:3c85] type 00 class 0x088000
[    8.427606] pci 0000:bf:08.6: [8086:3c86] type 00 class 0x088000
[    8.435015] pci 0000:bf:08.7: [8086:3c87] type 00 class 0x088000
[    8.442404] pci 0000:bf:09.0: [8086:3c90] type 00 class 0x088000
[    8.449768] pci 0000:bf:09.2: [8086:3c42] type 00 class 0x110100
[    8.457169] pci 0000:bf:09.3: [8086:3c93] type 00 class 0x088000
[    8.464575] pci 0000:bf:09.4: [8086:3c94] type 00 class 0x088000
[    8.471978] pci 0000:bf:09.5: [8086:3c95] type 00 class 0x088000
[    8.479353] pci 0000:bf:09.6: [8086:3c96] type 00 class 0x088000
[    8.486745] pci 0000:bf:0a.0: [8086:3cc0] type 00 class 0x088000
[    8.494094] pci 0000:bf:0a.1: [8086:3cc1] type 00 class 0x088000
[    8.501414] pci 0000:bf:0a.2: [8086:3cc2] type 00 class 0x088000
[    8.508772] pci 0000:bf:0a.3: [8086:3cd0] type 00 class 0x088000
[    8.516126] pci 0000:bf:0a.4: [8086:3cc4] type 00 class 0x088000
[    8.523492] pci 0000:bf:0a.5: [8086:3cc5] type 00 class 0x088000
[    8.530853] pci 0000:bf:0a.6: [8086:3cc6] type 00 class 0x088000
[    8.538252] pci 0000:bf:0a.7: [8086:3cc7] type 00 class 0x088000
[    8.545598] pci 0000:bf:0b.0: [8086:3ce0] type 00 class 0x088000
[    8.552978] pci 0000:bf:0b.2: [8086:3ce2] type 00 class 0x088000
[    8.560341] pci 0000:bf:0b.3: [8086:3ce3] type 00 class 0x088000
[    8.567724] pci 0000:bf:0c.0: [8086:3ce8] type 00 class 0x088000
[    8.575083] pci 0000:bf:0c.1: [8086:3ce8] type 00 class 0x088000
[    8.582445] pci 0000:bf:0c.2: [8086:3ce8] type 00 class 0x088000
[    8.589807] pci 0000:bf:0c.3: [8086:3ce8] type 00 class 0x088000
[    8.597175] pci 0000:bf:0c.6: [8086:3cf4] type 00 class 0x088000
[    8.604552] pci 0000:bf:0c.7: [8086:3cf6] type 00 class 0x088000
[    8.611895] pci 0000:bf:0d.0: [8086:3ce8] type 00 class 0x088000
[    8.619260] pci 0000:bf:0d.1: [8086:3ce8] type 00 class 0x088000
[    8.626602] pci 0000:bf:0d.2: [8086:3ce8] type 00 class 0x088000
[    8.633958] pci 0000:bf:0d.3: [8086:3ce8] type 00 class 0x088000
[    8.641311] pci 0000:bf:0d.6: [8086:3cf5] type 00 class 0x088000
[    8.648674] pci 0000:bf:0e.0: [8086:3ca0] type 00 class 0x088000
[    8.656018] pci 0000:bf:0e.1: [8086:3c46] type 00 class 0x110100
[    8.663375] pci 0000:bf:0e.2: [8086:3c70] type 00 class 0x088000
[    8.670761] pci 0000:bf:0f.0: [8086:3ca8] type 00 class 0x088000
[    8.678128] pci 0000:bf:0f.1: [8086:3c71] type 00 class 0x088000
[    8.685484] pci 0000:bf:0f.2: [8086:3caa] type 00 class 0x088000
[    8.692889] pci 0000:bf:0f.3: [8086:3cab] type 00 class 0x088000
[    8.700256] pci 0000:bf:0f.4: [8086:3cac] type 00 class 0x088000
[    8.707631] pci 0000:bf:0f.5: [8086:3cad] type 00 class 0x088000
[    8.715018] pci 0000:bf:0f.6: [8086:3cae] type 00 class 0x088000
[    8.722394] pci 0000:bf:0f.7: [8086:3caf] type 00 class 0x088000
[    8.729737] pci 0000:bf:10.0: [8086:3cb0] type 00 class 0x088000
[    8.737138] pci 0000:bf:10.1: [8086:3cb1] type 00 class 0x088000
[    8.744515] pci 0000:bf:10.2: [8086:3cb2] type 00 class 0x088000
[    8.751909] pci 0000:bf:10.3: [8086:3cb3] type 00 class 0x088000
[    8.759312] pci 0000:bf:10.4: [8086:3cb4] type 00 class 0x088000
[    8.766702] pci 0000:bf:10.5: [8086:3cb5] type 00 class 0x088000
[    8.774106] pci 0000:bf:10.6: [8086:3cb6] type 00 class 0x088000
[    8.781504] pci 0000:bf:10.7: [8086:3cb7] type 00 class 0x088000
[    8.788911] pci 0000:bf:11.0: [8086:3cb8] type 00 class 0x088000
[    8.796265] pci 0000:bf:11.1: [8086:3cb9] type 00 class 0x088000
[    8.803648] pci 0000:bf:11.2: [8086:3cba] type 00 class 0x088000
[    8.810998] pci 0000:bf:11.3: [8086:3cbb] type 00 class 0x088000
[    8.818355] pci 0000:bf:11.4: [8086:3cbc] type 00 class 0x088000
[    8.825692] pci 0000:bf:11.5: [8086:3cbd] type 00 class 0x088000
[    8.833079] pci 0000:bf:11.6: [8086:3cbe] type 00 class 0x088000
[    8.840432] pci 0000:bf:11.7: [8086:3cbf] type 00 class 0x088000
[    8.847785] pci 0000:bf:13.0: [8086:3ce4] type 00 class 0x088000
[    8.855156] pci 0000:bf:13.1: [8086:3c43] type 00 class 0x110100
[    8.862505] pci 0000:bf:13.4: [8086:3ce6] type 00 class 0x110100
[    8.869838] pci 0000:bf:13.5: [8086:3c44] type 00 class 0x110100
[    8.877218] pci 0000:bf:13.6: [8086:3c45] type 00 class 0x088000
[    8.884604] acpi PNP0A03:02: Disabling ASPM (FADT indicates it is unsupported)
[    8.893714] ACPI: PCI Root Bridge [UCR3] (domain 0000 [bus ff])
[    8.900816] acpi PNP0A03:03: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    8.910866] acpi PNP0A03:03: _OSC: platform does not support [PCIeHotplug PME AER]
[    8.920236] acpi PNP0A03:03: _OSC: OS now controls [PCIeCapability]
[    8.927893] PCI host bridge to bus 0000:ff
[    8.932953] pci_bus 0000:ff: root bus resource [bus ff]
[    8.939267] pci 0000:ff:08.0: [8086:3c80] type 00 class 0x088000
[    8.946631] pci 0000:ff:08.2: [8086:3c41] type 00 class 0x110100
[    8.963326] pci 0000:ff:08.3: [8086:3c83] type 00 class 0x088000
[    8.970688] pci 0000:ff:08.4: [8086:3c84] type 00 class 0x088000
[    8.978042] pci 0000:ff:08.5: [8086:3c85] type 00 class 0x088000
[    8.985457] pci 0000:ff:08.6: [8086:3c86] type 00 class 0x088000
[    8.992853] pci 0000:ff:08.7: [8086:3c87] type 00 class 0x088000
[    9.000230] pci 0000:ff:09.0: [8086:3c90] type 00 class 0x088000
[    9.007595] pci 0000:ff:09.2: [8086:3c42] type 00 class 0x110100
[    9.014966] pci 0000:ff:09.3: [8086:3c93] type 00 class 0x088000
[    9.022357] pci 0000:ff:09.4: [8086:3c94] type 00 class 0x088000
[    9.029738] pci 0000:ff:09.5: [8086:3c95] type 00 class 0x088000
[    9.037147] pci 0000:ff:09.6: [8086:3c96] type 00 class 0x088000
[    9.044498] pci 0000:ff:0a.0: [8086:3cc0] type 00 class 0x088000
[    9.051862] pci 0000:ff:0a.1: [8086:3cc1] type 00 class 0x088000
[    9.059211] pci 0000:ff:0a.2: [8086:3cc2] type 00 class 0x088000
[    9.066554] pci 0000:ff:0a.3: [8086:3cd0] type 00 class 0x088000
[    9.073921] pci 0000:ff:0a.4: [8086:3cc4] type 00 class 0x088000
[    9.081304] pci 0000:ff:0a.5: [8086:3cc5] type 00 class 0x088000
[    9.088639] pci 0000:ff:0a.6: [8086:3cc6] type 00 class 0x088000
[    9.095986] pci 0000:ff:0a.7: [8086:3cc7] type 00 class 0x088000
[    9.103348] pci 0000:ff:0b.0: [8086:3ce0] type 00 class 0x088000
[    9.110708] pci 0000:ff:0b.2: [8086:3ce2] type 00 class 0x088000
[    9.118056] pci 0000:ff:0b.3: [8086:3ce3] type 00 class 0x088000
[    9.125452] pci 0000:ff:0c.0: [8086:3ce8] type 00 class 0x088000
[    9.132846] pci 0000:ff:0c.1: [8086:3ce8] type 00 class 0x088000
[    9.140209] pci 0000:ff:0c.2: [8086:3ce8] type 00 class 0x088000
[    9.147571] pci 0000:ff:0c.3: [8086:3ce8] type 00 class 0x088000
[    9.154915] pci 0000:ff:0c.6: [8086:3cf4] type 00 class 0x088000
[    9.162245] pci 0000:ff:0c.7: [8086:3cf6] type 00 class 0x088000
[    9.169622] pci 0000:ff:0d.0: [8086:3ce8] type 00 class 0x088000
[    9.176951] pci 0000:ff:0d.1: [8086:3ce8] type 00 class 0x088000
[    9.184307] pci 0000:ff:0d.2: [8086:3ce8] type 00 class 0x088000
[    9.191664] pci 0000:ff:0d.3: [8086:3ce8] type 00 class 0x088000
[    9.199009] pci 0000:ff:0d.6: [8086:3cf5] type 00 class 0x088000
[    9.206341] pci 0000:ff:0e.0: [8086:3ca0] type 00 class 0x088000
[    9.213708] pci 0000:ff:0e.1: [8086:3c46] type 00 class 0x110100
[    9.221063] pci 0000:ff:0e.2: [8086:3c70] type 00 class 0x088000
[    9.228423] pci 0000:ff:0f.0: [8086:3ca8] type 00 class 0x088000
[    9.235796] pci 0000:ff:0f.1: [8086:3c71] type 00 class 0x088000
[    9.243168] pci 0000:ff:0f.2: [8086:3caa] type 00 class 0x088000
[    9.250519] pci 0000:ff:0f.3: [8086:3cab] type 00 class 0x088000
[    9.257916] pci 0000:ff:0f.4: [8086:3cac] type 00 class 0x088000
[    9.265289] pci 0000:ff:0f.5: [8086:3cad] type 00 class 0x088000
[    9.272644] pci 0000:ff:0f.6: [8086:3cae] type 00 class 0x088000
[    9.279984] pci 0000:ff:0f.7: [8086:3caf] type 00 class 0x088000
[    9.287333] pci 0000:ff:10.0: [8086:3cb0] type 00 class 0x088000
[    9.294692] pci 0000:ff:10.1: [8086:3cb1] type 00 class 0x088000
[    9.302117] pci 0000:ff:10.2: [8086:3cb2] type 00 class 0x088000
[    9.309492] pci 0000:ff:10.3: [8086:3cb3] type 00 class 0x088000
[    9.316873] pci 0000:ff:10.4: [8086:3cb4] type 00 class 0x088000
[    9.324275] pci 0000:ff:10.5: [8086:3cb5] type 00 class 0x088000
[    9.331682] pci 0000:ff:10.6: [8086:3cb6] type 00 class 0x088000
[    9.339091] pci 0000:ff:10.7: [8086:3cb7] type 00 class 0x088000
[    9.346505] pci 0000:ff:11.0: [8086:3cb8] type 00 class 0x088000
[    9.353887] pci 0000:ff:11.1: [8086:3cb9] type 00 class 0x088000
[    9.361247] pci 0000:ff:11.2: [8086:3cba] type 00 class 0x088000
[    9.368627] pci 0000:ff:11.3: [8086:3cbb] type 00 class 0x088000
[    9.376004] pci 0000:ff:11.4: [8086:3cbc] type 00 class 0x088000
[    9.383374] pci 0000:ff:11.5: [8086:3cbd] type 00 class 0x088000
[    9.390731] pci 0000:ff:11.6: [8086:3cbe] type 00 class 0x088000
[    9.398087] pci 0000:ff:11.7: [8086:3cbf] type 00 class 0x088000
[    9.405469] pci 0000:ff:13.0: [8086:3ce4] type 00 class 0x088000
[    9.412843] pci 0000:ff:13.1: [8086:3c43] type 00 class 0x110100
[    9.420198] pci 0000:ff:13.4: [8086:3ce6] type 00 class 0x110100
[    9.427567] pci 0000:ff:13.5: [8086:3c44] type 00 class 0x110100
[    9.434923] pci 0000:ff:13.6: [8086:3c45] type 00 class 0x088000
[    9.442322] acpi PNP0A03:03: Disabling ASPM (FADT indicates it is unsupported)
[    9.451519] ACPI: Enabled 6 GPEs in block 00 to 3F
[    9.458384] vgaarb: device added: PCI:0000:09:00.0,decodes=io+mem,owns=io+mem,locks=none
[    9.468675] vgaarb: loaded
[    9.472163] vgaarb: bridge control possible 0000:09:00.0
[    9.478935] SCSI subsystem initialized
[    9.484034] libata version 3.00 loaded.
[    9.489124] ACPI: bus type USB registered
[    9.494217] usbcore: registered new interface driver usbfs
[    9.500927] usbcore: registered new interface driver hub
[    9.507539] usbcore: registered new device driver usb
[    9.513880] pps_core: LinuxPPS API ver. 1 registered
[    9.519919] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    9.531073] PTP clock support registered
[    9.536628] EDAC MC: Ver: 3.0.0
[    9.541698] PCI: Using ACPI for IRQ routing
[    9.551946] PCI: pci_cache_line_size set to 64 bytes
[    9.558955] e820: reserve RAM buffer [mem 0x0008f400-0x0008ffff]
[    9.566139] e820: reserve RAM buffer [mem 0xbb3c7000-0xbbffffff]
[    9.573335] e820: reserve RAM buffer [mem 0xbe000000-0xbfffffff]
[    9.581839] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    9.590008] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    9.599365] Switched to clocksource hpet
[    9.628854] pnp: PnP ACPI init
[    9.632868] ACPI: bus type PNP registered
[    9.638103] pnp 00:00: [dma 4]
[    9.642198] pnp 00:00: Plug and Play ACPI device, IDs PNP0200 (active)
[    9.650175] pnp 00:01: Plug and Play ACPI device, IDs INT0800 (active)
[    9.658295] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
[    9.666164] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:0)
[    9.676325] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    9.684873] system 00:04: [io  0x0680-0x069f] has been reserved
[    9.692022] system 00:04: [io  0xffff] has been reserved
[    9.698457] system 00:04: [io  0xffff] has been reserved
[    9.704887] system 00:04: [io  0xffff] has been reserved
[    9.711316] system 00:04: [io  0x0400-0x0453] could not be reserved
[    9.718841] system 00:04: [io  0x0458-0x047f] has been reserved
[    9.725965] system 00:04: [io  0x0500-0x057f] has been reserved
[    9.733071] system 00:04: [io  0x0600-0x061f] has been reserved
[    9.740181] system 00:04: [io  0x0ca2-0x0ca5] has been reserved
[    9.747295] system 00:04: [io  0x0cf9] could not be reserved
[    9.754132] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    9.762245] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:0)
[    9.772146] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    9.780396] system 00:06: [io  0x0454-0x0457] has been reserved
[    9.787511] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    9.797255] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:0)
[    9.807031] pnp 00:07: [dma 0 disabled]
[    9.812043] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    9.820152] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:0)
[    9.829935] pnp 00:08: [dma 0 disabled]
[    9.834949] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    9.843770] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    9.851674] system 00:09: [mem 0xdffff000-0xdfffffff] has been reserved
[    9.859574] system 00:09: [mem 0xc0000000-0xcfffffff] has been reserved
[    9.867468] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
[    9.875369] system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
[    9.883275] system 00:09: [mem 0xff000000-0xffffffff] could not be reserved
[    9.891555] system 00:09: [mem 0xfee00000-0xfeefffff] could not be reserved
[    9.899835] system 00:09: [mem 0xfec00000-0xfecfffff] could not be reserved
[    9.908114] system 00:09: [mem 0xd0f70000-0xd0f70fff] has been reserved
[    9.916001] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    9.925481] system 00:0a: [mem 0x00000000-0x0009cfff] could not be reserved
[    9.933766] system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
[    9.942498] pnp: PnP ACPI: found 11 devices
[    9.947667] ACPI: bus type PNP unregistered
[    9.965255] pci 0000:02:08.0: PCI bridge to [bus 03]
[    9.971313] pci 0000:02:08.0:   bridge window [io  0x2000-0x2fff]
[    9.978625] pci 0000:02:08.0:   bridge window [mem 0xd0d00000-0xd0dfffff]
[    9.986711] pci 0000:02:08.0:   bridge window [mem 0xdc800000-0xdd1fffff 64bit pref]
[    9.996277] pci 0000:01:00.0: PCI bridge to [bus 02-03]
[   10.002606] pci 0000:01:00.0:   bridge window [io  0x2000-0x2fff]
[   10.009921] pci 0000:01:00.0:   bridge window [mem 0xd0d00000-0xd0dfffff]
[   10.018006] pci 0000:01:00.0:   bridge window [mem 0xdc800000-0xdd1fffff 64bit pref]
[   10.027560] pci 0000:00:01.0: PCI bridge to [bus 01-03]
[   10.033889] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[   10.041206] pci 0000:00:01.0:   bridge window [mem 0xd0d00000-0xd0efffff]
[   10.049287] pci 0000:00:01.0:   bridge window [mem 0xdc800000-0xdd1fffff 64bit pref]
[   10.058832] pci 0000:00:02.0: PCI bridge to [bus 04]
[   10.064883] pci 0000:00:03.0: PCI bridge to [bus 05]
[   10.070938] pci 0000:00:03.2: PCI bridge to [bus 06-07]
[   10.077273] pci 0000:00:03.2:   bridge window [io  0x1000-0x1fff]
[   10.084588] pci 0000:00:03.2:   bridge window [mem 0xd0900000-0xd0cfffff]
[   10.092676] pci 0000:00:03.2:   bridge window [mem 0xdd400000-0xdd8fffff 64bit pref]
[   10.102226] pci 0000:00:1c.0: PCI bridge to [bus 08]
[   10.108287] pci 0000:00:1c.7: PCI bridge to [bus 09]
[   10.114325] pci 0000:00:1c.7:   bridge window [mem 0xd0000000-0xd08fffff]
[   10.122413] pci 0000:00:1c.7:   bridge window [mem 0xde000000-0xdeffffff 64bit pref]
[   10.131981] pci 0000:00:1e.0: PCI bridge to [bus 0a]
[   10.138040] pci_bus 0000:00: resource 4 [io  0x0000-0x5fff]
[   10.144760] pci_bus 0000:00: resource 5 [mem 0x000a0000-0x000bffff]
[   10.152262] pci_bus 0000:00: resource 6 [mem 0x000c0000-0x000c3fff]
[   10.159750] pci_bus 0000:00: resource 7 [mem 0x000c4000-0x000c7fff]
[   10.167252] pci_bus 0000:00: resource 8 [mem 0x000c8000-0x000cbfff]
[   10.174756] pci_bus 0000:00: resource 9 [mem 0x000cc000-0x000cffff]
[   10.182269] pci_bus 0000:00: resource 10 [mem 0x000d4000-0x000d7fff]
[   10.189867] pci_bus 0000:00: resource 11 [mem 0x000d8000-0x000dbfff]
[   10.197472] pci_bus 0000:00: resource 12 [mem 0x000dc000-0x000dffff]
[   10.205071] pci_bus 0000:00: resource 13 [mem 0x000e0000-0x000e3fff]
[   10.212674] pci_bus 0000:00: resource 14 [mem 0x000e4000-0x000e7fff]
[   10.220277] pci_bus 0000:00: resource 15 [mem 0x000e8000-0x000ebfff]
[   10.227877] pci_bus 0000:00: resource 16 [mem 0x000ec000-0x000effff]
[   10.245000] pci_bus 0000:00: resource 17 [mem 0x000f0000-0x000fffff]
[   10.252599] pci_bus 0000:00: resource 18 [mem 0xd0000000-0xdfffffff]
[   10.260201] pci_bus 0000:00: resource 19 [mem 0x3c0000000000-0x3c007fffffff]
[   10.268579] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[   10.275297] pci_bus 0000:01: resource 1 [mem 0xd0d00000-0xd0efffff]
[   10.282798] pci_bus 0000:01: resource 2 [mem 0xdc800000-0xdd1fffff 64bit pref]
[   10.291759] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[   10.298485] pci_bus 0000:02: resource 1 [mem 0xd0d00000-0xd0dfffff]
[   10.305975] pci_bus 0000:02: resource 2 [mem 0xdc800000-0xdd1fffff 64bit pref]
[   10.314934] pci_bus 0000:03: resource 0 [io  0x2000-0x2fff]
[   10.321648] pci_bus 0000:03: resource 1 [mem 0xd0d00000-0xd0dfffff]
[   10.329152] pci_bus 0000:03: resource 2 [mem 0xdc800000-0xdd1fffff 64bit pref]
[   10.338103] pci_bus 0000:06: resource 0 [io  0x1000-0x1fff]
[   10.344830] pci_bus 0000:06: resource 1 [mem 0xd0900000-0xd0cfffff]
[   10.352314] pci_bus 0000:06: resource 2 [mem 0xdd400000-0xdd8fffff 64bit pref]
[   10.361276] pci_bus 0000:09: resource 1 [mem 0xd0000000-0xd08fffff]
[   10.368758] pci_bus 0000:09: resource 2 [mem 0xde000000-0xdeffffff 64bit pref]
[   10.377735] pci_bus 0000:0a: resource 4 [io  0x0000-0x5fff]
[   10.384447] pci_bus 0000:0a: resource 5 [mem 0x000a0000-0x000bffff]
[   10.391951] pci_bus 0000:0a: resource 6 [mem 0x000c0000-0x000c3fff]
[   10.399448] pci_bus 0000:0a: resource 7 [mem 0x000c4000-0x000c7fff]
[   10.406949] pci_bus 0000:0a: resource 8 [mem 0x000c8000-0x000cbfff]
[   10.414453] pci_bus 0000:0a: resource 9 [mem 0x000cc000-0x000cffff]
[   10.421959] pci_bus 0000:0a: resource 10 [mem 0x000d4000-0x000d7fff]
[   10.429559] pci_bus 0000:0a: resource 11 [mem 0x000d8000-0x000dbfff]
[   10.437159] pci_bus 0000:0a: resource 12 [mem 0x000dc000-0x000dffff]
[   10.444761] pci_bus 0000:0a: resource 13 [mem 0x000e0000-0x000e3fff]
[   10.452360] pci_bus 0000:0a: resource 14 [mem 0x000e4000-0x000e7fff]
[   10.459959] pci_bus 0000:0a: resource 15 [mem 0x000e8000-0x000ebfff]
[   10.467559] pci_bus 0000:0a: resource 16 [mem 0x000ec000-0x000effff]
[   10.475159] pci_bus 0000:0a: resource 17 [mem 0x000f0000-0x000fffff]
[   10.482755] pci_bus 0000:0a: resource 18 [mem 0xd0000000-0xdfffffff]
[   10.490360] pci_bus 0000:0a: resource 19 [mem 0x3c0000000000-0x3c007fffffff]
[   10.498767] pci 0000:40:01.0: PCI bridge to [bus 41]
[   10.504823] pci 0000:40:02.0: PCI bridge to [bus 42]
[   10.510882] pci_bus 0000:40: resource 4 [io  0x03b0-0x03df]
[   10.517605] pci_bus 0000:40: resource 5 [io  0x6000-0x7fff]
[   10.524331] pci_bus 0000:40: resource 6 [mem 0x000a0000-0x000bffff]
[   10.531834] pci_bus 0000:40: resource 7 [mem 0xe0000000-0xebffffff]
[   10.539340] pci_bus 0000:40: resource 8 [mem 0x3c0080000000-0x3c00ffffffff]
[   10.547660] pci 0000:80:02.0: PCI bridge to [bus 81]
[   10.553725] pci 0000:80:03.0: PCI bridge to [bus 82]
[   10.559782] pci_bus 0000:80: resource 4 [io  0x8000-0xbfff]
[   10.566510] pci_bus 0000:80: resource 5 [mem 0xec000000-0xf7ffffff]
[   10.574013] pci_bus 0000:80: resource 6 [mem 0x3c0100000000-0x3c017fffffff]
[   10.582341] pci 0000:c0:02.0: PCI bridge to [bus c1]
[   10.588408] pci 0000:c0:03.0: PCI bridge to [bus c2]
[   10.594464] pci_bus 0000:c0: resource 4 [io  0xc000-0xffff]
[   10.601188] pci_bus 0000:c0: resource 5 [mem 0xf8000000-0xfbffffff]
[   10.608682] pci_bus 0000:c0: resource 6 [mem 0x3c0180000000-0x3c01ffffffff]
[   10.617275] NET: Registered protocol family 2
[   10.623808] TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
[   10.634592] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   10.642905] TCP: Hash tables configured (established 524288 bind 65536)
[   10.650906] TCP: reno registered
[   10.655158] UDP hash table entries: 32768 (order: 8, 1048576 bytes)
[   10.663154] UDP-Lite hash table entries: 32768 (order: 8, 1048576 bytes)
[   10.671939] NET: Registered protocol family 1
[   10.677770] RPC: Registered named UNIX socket transport module.
[   10.684888] RPC: Registered udp transport module.
[   10.690635] RPC: Registered tcp transport module.
[   10.696392] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   10.704570] IOAPIC[0]: Set routing entry (0-22 -> 0x41 -> IRQ 22 Mode:1 Active:1 Dest:0)
[   10.714912] IOAPIC[0]: Set routing entry (0-20 -> 0x51 -> IRQ 20 Mode:1 Active:1 Dest:0)
[   10.725058] pci 0000:09:00.0: Boot video device
[   10.731383] PCI: CLS 64 bytes, default 64
[   10.736457] Trying to unpack rootfs image as initramfs...
[   17.665744] Freeing initrd memory: 213444K (ffff880072f82000 - ffff88007fff3000)
[   17.674933] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[   17.682659] software IO TLB [mem 0xb73c7000-0xbb3c7000] (64MB) mapped at [ffff8800b73c7000-ffff8800bb3c6fff]
[   17.695661] BUG: unable to handle kernel NULL pointer dereference at 00000000000002b0
[   17.705465] IP: [<ffffffff81015a9f>] kvm_arch_init+0x12a/0x1ea
[   17.712577] PGD 0 
[   17.715390] Oops: 0000 [#1] SMP 
[   17.719654] Modules linked in:
[   17.723641] CPU: 10 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc7-03020-ga929a7d #1
[   17.733067] Hardware name: Intel Corporation LH Pass/S4600LH...., BIOS SE5C600.86B.99.02.1047.032320122259 03/23/2012
[   17.745821] task: ffff880429cb0000 ti: ffff880429ca4000 task.ti: ffff880429ca4000
[   17.755039] RIP: 0010:[<ffffffff81015a9f>]  [<ffffffff81015a9f>] kvm_arch_init+0x12a/0x1ea
[   17.765228] RSP: 0000:ffff880429ca5e00  EFLAGS: 00010246
[   17.771644] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[   17.780096] RDX: 0000000000000000 RSI: ffff880429ca5e04 RDI: 0000000000000d90
[   17.788549] RBP: ffff880429ca5e30 R08: ffff88082fc55d00 R09: ffff88042f803e00
[   17.796993] R10: 0000000000000004 R11: 0000000000000003 R12: 000000000000000c
[   17.805449] R13: 0000000000000017 R14: ffffffff82018b10 R15: 0000000000000018
[   17.813907] FS:  0000000000000000(0000) GS:ffff88082fc40000(0000) knlGS:0000000000000000
[   17.823808] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   17.830693] CR2: 00000000000002b0 CR3: 000000000200f000 CR4: 00000000000407e0
[   17.839159] Stack:
[   17.841873]  0000000000000000 0000000000000040 0000000000000000 0000000000003f40
[   17.851328]  0000000000000000 0000000000000000 ffff880429ca5e68 ffffffff810039dc
[   17.860790]  00000000000164d8 0000000000000006 0000000000000000 000000000000023c
[   17.870256] Call Trace:
[   17.873468]  [<ffffffff810039dc>] kvm_init+0x1f/0x24a
[   17.879599]  [<ffffffff82154fa4>] vmx_init+0x1df/0x3f6
[   17.885825]  [<ffffffff82154dc5>] ? vmx_check_processor_compat+0x61/0x61
[   17.893782]  [<ffffffff810002d2>] do_one_initcall+0xa4/0x13a
[   17.900604]  [<ffffffff810f9aa9>] ? parse_args+0x25f/0x33d
[   17.907225]  [<ffffffff8214ff94>] kernel_init_freeable+0x1a9/0x22e
[   17.914615]  [<ffffffff8214f78f>] ? do_early_param+0x88/0x88
[   17.921433]  [<ffffffff819af0d5>] ? rest_init+0x89/0x89
[   17.927731]  [<ffffffff819af0e3>] kernel_init+0xe/0xdf
[   17.933948]  [<ffffffff819cb47c>] ret_from_fork+0x7c/0xb0
[   17.940449]  [<ffffffff819af0d5>] ? rest_init+0x89/0x89
[   17.946767] Code: a5 d0 68 01 82 48 8d 75 d4 e8 1a 30 05 00 66 90 83 7d d4 00 78 39 42 81 3c a5 d0 68 01 82 90 0d 00 00 75 11 48 8b 05 a1 86 29 01 <ff> 90 b0 02 00 00 84 c0 74 1a 45 39 fd 73 12 42 8b 14 a5 d0 68 
[   17.974746] RIP  [<ffffffff81015a9f>] kvm_arch_init+0x12a/0x1ea
[   17.981917]  RSP <ffff880429ca5e00>
[   17.986267] CR2: 00000000000002b0
[   17.990466] ---[ end trace de424db0279a1666 ]---
[   17.996105] Kernel panic - not syncing: Fatal exception
[   18.002478] Rebooting in 10 seconds..
[   27.945996] ACPI MEMORY or I/O RESET_REG.

--zhXaljGHf11kAtnf--
