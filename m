Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbaG3OVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:21:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:34909 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829AbaG3OVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:21:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,764,1400050800"; 
   d="log'?scan'208";a="569467201"
Date: Wed, 30 Jul 2014 22:20:49 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: [fork] BUG: unable to handle kernel paging request at
 ffff88000bb15010
Message-ID: <20140730142049.GQ16537@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="b2ktwntdbf0dPnbx"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b2ktwntdbf0dPnbx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

commit 0a5f047dcd90af4cb72df583e3ee21a8d9262c4f
Author:     Vladimir Davydov <vdavydov@parallels.com>
AuthorDate: Thu Jul 10 10:26:23 2014 +1000
Commit:     Stephen Rothwell <sfr@canb.auug.org.au>
CommitDate: Thu Jul 10 10:26:23 2014 +1000

    fork: reset mm->pinned_vm
    
    mm->pinned_vm counts pages of mm's address space that were permanently
    pinned in memory by increasing their reference counter. The counter was
    introduced by commit bc3e53f682d9 ("mm: distinguish between mlocked and
    pinned pages"), while before it locked_vm had been used for such pages.
    
    Obviously, we should reset the counter on fork if !CLONE_VM, just like
    we do with locked_vm, but currently we don't. Let's fix it.
    
    This patch will fix the contents of /proc/pid/status:VmPin.
    
    ib_umem_get[infiniband] and perf_mmap still check pinned_vm against
    RLIMIT_MEMLOCK.  It's left from the times when pinned pages were accounted
    under locked_vm, but today it looks wrong.  It isn't clear how we should
    deal with it.
    
    We still have some drivers accounting pinned pages under mm->locked_vm -
    this is what commit bc3e53f682d9 was fighting against.  It's
    infiniband/usnic and vfio.
    
    Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
    Cc: Oleg Nesterov <oleg@redhat.com>
    Cc: David Rientjes <rientjes@google.com>
    Cc: Christoph Lameter <cl@linux.com>
    Cc: Roland Dreier <roland@kernel.org>
    Cc: Sean Hefty <sean.hefty@intel.com>
    Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

===================================================
PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
===================================================
Attached dmesg for the parent commit, too, to help confirm whether it is a noise error.

+-------------------------------------------------------+------------+------------+---------------+
|                                                       | 8df59fd2a3 | 0a5f047dcd | next-20140714 |
+-------------------------------------------------------+------------+------------+---------------+
| boot_successes                                        | 94         | 14         | 6             |
| boot_failures                                         | 20         | 21         | 5             |
| BUG:kernel_boot_hang                                  | 20         | 2          |               |
| general_protection_fault                              | 0          | 9          | 2             |
| RIP:lookup_object                                     | 0          | 5          | 1             |
| Kernel_panic-not_syncing:Fatal_exception              | 0          | 12         | 3             |
| backtrace:cryptomgr_test                              | 0          | 11         | 3             |
| BUG:unable_to_handle_kernel_paging_request            | 0          | 9          | 2             |
| Oops                                                  | 0          | 10         | 2             |
| RIP:debug_print_object                                | 0          | 4          |               |
| Kernel_panic-not_syncing:Fatal_exception_in_interrupt | 0          | 7          | 2             |
| backtrace:smpboot_thread_fn                           | 0          | 4          |               |
| RIP:slob_page_alloc                                   | 0          | 3          | 1             |
| RIP:crypto_ahash_setkey                               | 0          | 2          | 1             |
| RIP:__debug_object_init                               | 0          | 2          |               |
| backtrace:__debug_object_init                         | 0          | 2          |               |
| backtrace:debug_object_init                           | 0          | 2          |               |
| backtrace:do_fork                                     | 0          | 2          | 1             |
| RIP:slob_free                                         | 0          | 1          |               |
| RIP:__list_del_entry                                  | 0          | 1          |               |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference  | 0          | 1          |               |
| RIP:debug_check_no_obj_freed                          | 0          | 1          |               |
| kernel_BUG_at_kernel/cred.c                           | 0          | 0          | 1             |
| invalid_opcode                                        | 0          | 0          | 1             |
| RIP:__invalid_creds                                   | 0          | 0          | 1             |
| RIP:kernfs_name_compare                               | 0          | 0          | 1             |
| backtrace:kobject_add_varg                            | 0          | 0          | 1             |
| backtrace:kobject_init_and_add                        | 0          | 0          | 1             |
| backtrace:__platform_driver_register                  | 0          | 0          | 1             |
| backtrace:u132_hcd_init                               | 0          | 0          | 1             |
| backtrace:kernel_init_freeable                        | 0          | 0          | 1             |
+-------------------------------------------------------+------------+------------+---------------+

[    3.304558] sha1_ssse3: Using AVX optimized SHA-1 implementation
[    3.307272] alg: No test for crc32 (crc32-pclmul)
[    3.307987] sha512_ssse3: Using AVX optimized SHA-512 implementation
[    3.314309] BUG: unable to handle kernel paging request at ffff88000bb15010
[    3.316371] IP: [<ffffffff8124c717>] slob_free+0x437/0x750
[    3.316842] PGD 44d2067 PUD 44d3067 PMD 12792067 PTE 800000000bb15060
[    3.316842] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    3.316842] CPU: 1 PID: 14 Comm: ksoftirqd/1 Not tainted 3.16.0-rc4-00340-g0a5f047 #3
[    3.316842] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.316842] task: ffff8800120ec000 ti: ffff8800120f0000 task.ti: ffff8800120f0000
[    3.316842] RIP: 0010:[<ffffffff8124c717>]  [<ffffffff8124c717>] slob_free+0x437/0x750
[    3.316842] RSP: 0000:ffff8800120f3c30  EFLAGS: 00010046
[    3.316842] RAX: 0000000000000028 RBX: ffff88000bb14fc0 RCX: 0000000000000292
[    3.316842] RDX: ffff88000bb15010 RSI: 0000000000000808 RDI: ffff88000bb14fb8
[    3.316842] RBP: ffff8800120f3c60 R08: ffff8800120ec7d0 R09: 0000000000000002
[    3.316842] R10: 0000000000000000 R11: ffffffb97fd5a00f R12: ffff88000bb14fb8
[    3.316842] R13: ffff88000bb15010 R14: 0000000000000028 R15: ffff88000bb14000
[    3.316842] FS:  0000000000000000(0000) GS:ffff880012500000(0000) knlGS:0000000000000000
[    3.316842] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.316842] CR2: ffff88000bb15010 CR3: 0000000002c0b000 CR4: 00000000000406e0
[    3.316842] Stack:
[    3.316842]  0000000000000292 0000000000000000 ffff88000bb14fc0 ffff8800000964b0
[    3.316842]  0000000000000000 ffff88000bb1f888 ffff8800120f3c70 ffffffff8124ca85
[    3.316842]  ffff8800120f3c98 ffffffff8124dcb4 ffffffff82c37220 0000000000000000
[    3.316842] Call Trace:
[    3.316842]  [<ffffffff8124ca85>] __kmem_cache_free+0x55/0x60
[    3.316842]  [<ffffffff8124dcb4>] kmem_cache_free+0x124/0x170
[    3.316842]  [<ffffffff810e8f94>] put_pid+0x64/0x70
[    3.316842]  [<ffffffff810e8fb2>] delayed_put_pid+0x12/0x20
[    3.316842]  [<ffffffff8205e845>] rcu_do_batch.isra.47+0x73a/0xbbc
[    3.316842]  [<ffffffff8205e60a>] ? rcu_do_batch.isra.47+0x4ff/0xbbc
[    3.316842]  [<ffffffff8114de50>] rcu_process_callbacks+0x630/0x640
[    3.316842]  [<ffffffff810c1734>] __do_softirq+0x1f4/0x5a0
[    3.316842]  [<ffffffff810c1b35>] run_ksoftirqd+0x55/0x90
[    3.316842]  [<ffffffff810f9a3b>] smpboot_thread_fn+0x40b/0x4b0
[    3.316842]  [<ffffffff810f9630>] ? in_egroup_p+0x60/0x60
[    3.316842]  [<ffffffff810ee08f>] kthread+0x12f/0x140
[    3.316842]  [<ffffffff810edf60>] ? __kthread_parkme+0x90/0x90
[    3.316842]  [<ffffffff82092f3c>] ret_from_fork+0x7c/0xb0
[    3.316842]  [<ffffffff810edf60>] ? __kthread_parkme+0x90/0x90
[    3.316842] Code: 77 ba 4c 89 e7 48 89 4d d0 e8 d6 f5 ff ff 85 c0 48 8b 4d d0 0f 85 6a 01 00 00 49 0f bf c6 48 8d 14 43 4c 39 ea 0f 85 59 01 00 00 <41> 0f b7 75 00 48 83 05 7c d2 ce 01 01 66 85 f6 0f 9f c0 48 89 
[    3.316842] RIP  [<ffffffff8124c717>] slob_free+0x437/0x750
[    3.316842]  RSP <ffff8800120f3c30>
[    3.316842] CR2: ffff88000bb15010
[    3.316842] ---[ end trace 5a5f8cab8c473caa ]---
[    3.316842] Kernel panic - not syncing: Fatal exception in interrupt

git bisect start a20416c4071010be525f74c70c7a79c5ee6a2a05 64e3245c870e583004f19d989cdf9edcab6133fd --
git bisect  bad c9cb84a9b04de8c162cfd5d1a5d656bfba605100  # 12:21      7-     22  Merge branch 'akpm-current/current'
git bisect good fdb7e2faf0cfcc31540a7c3315a1036ca68fc55e  # 12:28     35+     23  fs.h, drivers/hwmon/asus_atk0110.c: fix DEFINE_SIMPLE_ATTRIBUTE semicolon definition and use
git bisect good 2a1fe6f43ede0e7ce681d403d5b56813316b710a  # 12:32     35+      0  nilfs2: add /sys/fs/nilfs2/<device>/mounted_snapshots group
git bisect  bad 34e7589daf2c48535f87b761f934c0036864c78a  # 12:34      5-     13  kexec-bzimage64: fix the ordering of registers
git bisect  bad 0a5f047dcd90af4cb72df583e3ee21a8d9262c4f  # 12:37     17-     20  fork: reset mm->pinned_vm
git bisect good e18cc0b956df9e73e9715923bb50e85e6bca84ea  # 12:44     38+      0  fs/reiserfs: use linux/uaccess.h
git bisect good b96511231ed78d735de9a83568762956b0747066  # 12:47     38+      0  proc: add and remove /proc entry create checks
git bisect good 8e5b9d83da10c0ba5c40f3f57dd54c68dcc49b18  # 12:51     38+      4  proc: remove proc_tty_ldisc variable
git bisect good 8df59fd2a350161bd39c3c9f8f4213b2a2a61847  # 12:56     38+      0  fork/exec: cleanup mm initialization
# first bad commit: [0a5f047dcd90af4cb72df583e3ee21a8d9262c4f] fork: reset mm->pinned_vm
git bisect good 8df59fd2a350161bd39c3c9f8f4213b2a2a61847  # 12:59    114+     20  fork/exec: cleanup mm initialization
git bisect  bad a20416c4071010be525f74c70c7a79c5ee6a2a05  # 13:00      0-      5  Add linux-next specific files for 20140714
git bisect good 1795cd9b3a91d4b5473c97f491d63892442212ab  # 13:04    114+     22  Linux 3.16-rc5
git bisect  bad a20416c4071010be525f74c70c7a79c5ee6a2a05  # 13:04      0-      5  Add linux-next specific files for 20140714


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=quantal-core-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-enable-kvm
	-cpu Haswell,+smep,+smap
	-kernel $kernel
	-initrd $initrd
	-m 320
	-smp 2
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-rtc base=localtime
	-serial stdio
	-display none
	-monitor null 
)

append=(
	hung_task_panic=1
	earlyprintk=ttyS0,115200
	debug
	apic=debug
	sysrq_always_enabled
	rcupdate.rcu_cpu_stall_timeout=100
	panic=10
	softlockup_panic=1
	nmi_watchdog=panic
	prompt_ramdisk=0
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
	drbd.minor_count=8
)

"${kvm[@]}" --append "${append[*]}"
----------------------------------------------------------------------------

Thanks,
Fengguang

--b2ktwntdbf0dPnbx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-kbuild-21:20140715123401:x86_64-randconfig-iv0-07151152:3.16.0-rc4-00340-g0a5f047:3"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 3.16.0-rc4-00340-g0a5f047 (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #3 SMP PREEMPT Tue Jul 15 12:35:18 CS=
T 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-iv0-07151152/next:master=
:0a5f047dcd90af4cb72df583e3ee21a8d9262c4f:bisect-linux3/.vmlinuz-0a5f047dcd=
90af4cb72df583e3ee21a8d9262c4f-20140715123536-2-kbuild branch=3Dnext/master=
 BOOT_IMAGE=3D/kernel/x86_64-randconfig-iv0-07151152/0a5f047dcd90af4cb72df5=
83e3ee21a8d9262c4f/vmlinuz-3.16.0-rc4-00340-g0a5f047 drbd.minor_count=3D8
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
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
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x044d2000, 0x044d2fff] PGTABLE
[    0.000000] BRK [0x044d3000, 0x044d3fff] PGTABLE
[    0.000000] BRK [0x044d4000, 0x044d4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 4k
[    0.000000] BRK [0x044d5000, 0x044d5fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 4k
[    0.000000] BRK [0x044d6000, 0x044d6fff] PGTABLE
[    0.000000] BRK [0x044d7000, 0x044d7fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
[    0.000000]  [mem 0x12800000-0x13ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE450 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE490 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF680 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF640 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff88001180000=
0-ffff880011dfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA32 zone: 1280 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 81820 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff880012400000 s81792 r0 d2=
0608 u1048576
[    0.000000] pcpu-alloc: s81792 r0 d20608 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1240cf00
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-iv0-07151152/next=
:master:0a5f047dcd90af4cb72df583e3ee21a8d9262c4f:bisect-linux3/.vmlinuz-0a5=
f047dcd90af4cb72df583e3ee21a8d9262c4f-20140715123536-2-kbuild branch=3Dnext=
/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-iv0-07151152/0a5f047dcd90af4=
cb72df583e3ee21a8d9262c4f/vmlinuz-3.16.0-rc4-00340-g0a5f047 drbd.minor_coun=
t=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Memory: 242024K/327280K available (16983K kernel code, 9164K=
 rwdata, 9472K rodata, 1248K init, 14956K bss, 85256K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8159 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.588 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 5389.64 Bogo=
MIPS (lpj=3D8978626)
[    0.006666] pid_max: default: 4096 minimum: 301
[    0.006707] ACPI: Core revision 20140424
[    0.018547] ACPI: All ACPI Tables successfully acquired
[    0.019611] Security Framework initialized
[    0.020038] Smack:  Initializing.
[    0.020594] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.021715] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.025279] Initializing cgroup subsys freezer
[    0.026067] Initializing cgroup subsys blkio
[    0.026666] Initializing cgroup subsys perf_event
[    0.026700] Initializing cgroup subsys debug
[    0.027678] mce: CPU supports 10 MCE banks
[    0.028440] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.028440] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.028440] tlb_flushall_shift: 6
[    0.030748] debug: unmapping init [mem 0xffffffff8362d000-0xffffffff8363=
5fff]
[    0.039683] Getting VERSION: 1050014
[    0.040021] Getting VERSION: 1050014
[    0.040566] Getting ID: 0
[    0.041048] Getting ID: ff000000
[    0.041538] Getting LVT0: 8700
[    0.042069] Getting LVT1: 8400
[    0.042615] enabled ExtINT on CPU#0
[    0.044643] ENABLING IO-APIC IRQs
[    0.045234] init IO_APIC IRQs
[    0.045687]  apic 0 pin 0 not connected
[    0.046387] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.046714] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.048051] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.050040] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.051297] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.052627] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.053374] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.054618] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.056705] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.058025] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.059281] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.060042] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.061382] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.063374] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.064640] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.065972]  apic 0 pin 16 not connected
[    0.066679]  apic 0 pin 17 not connected
[    0.067331]  apic 0 pin 18 not connected
[    0.067981]  apic 0 pin 19 not connected
[    0.068558]  apic 0 pin 20 not connected
[    0.069204]  apic 0 pin 21 not connected
[    0.069774]  apic 0 pin 22 not connected
[    0.070011]  apic 0 pin 23 not connected
[    0.070833] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.071953] smpboot: CPU0: Intel Core Processor (Haswell) (fam: 06, mode=
l: 3c, stepping: 01)
[    0.074085] TSC deadline timer enabled
[    0.074925] Performance Events: unsupported p6 CPU model 60 no PMU drive=
r, software events only.
[    0.083450]=20
[    0.083450] **********************************************************
[    0.086590] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.086688] **                                                      **
[    0.087880] ** trace_printk() being used. Allocating extra memory.  **
[    0.089348] **                                                      **
[    0.090012] ** This means that this is a DEBUG kernel and it is     **
[    0.091204] ** unsafe for produciton use.                           **
[    0.092394] **                                                      **
[    0.093344] ** If you see this message and you are not debugging    **
[    0.094781] ** the kernel, report this immediately to your vendor!  **
[    0.095973] **                                                      **
[    0.096679] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.097875] **********************************************************
[    0.103606] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.113737] x86: Booting SMP configuration:
[    0.114642] .... node  #0, CPUs:      #1
[    0.006666] kvm-clock: cpu 1, msr 0:13ffd041, secondary cpu clock
[    0.006666] masked ExtINT on CPU#1
[    0.130213] x86: Booted up 1 node, 2 CPUs
[    0.130048] KVM setup async PF for cpu 1
[    0.130057] kvm-stealtime: cpu 1, msr 1250cf00
[    0.132287] smpboot: Total of 2 processors activated (10778.28 BogoMIPS)
[    0.144248] xor: automatically using best checksumming function:
[    0.176693]    avx       :  8704.800 MB/sec
[    0.177469] prandom: seed boundary self test passed
[    0.178955] prandom: 100 self tests passed
[    0.181362] regulator-dummy: no parameters
[    0.182950] NET: Registered protocol family 16
[    0.185301] cpuidle: using governor menu
[    0.186533] ACPI: bus type PCI registered
[    0.186781] PCI: Using configuration type 1 for base access
[    0.286707] raid6: sse2x1    4300 MB/s
[    0.343363] raid6: sse2x2    6585 MB/s
[    0.400026] raid6: sse2x4    8711 MB/s
[    0.400654] raid6: using algorithm sse2x4 (8711 MB/s)
[    0.401440] raid6: using ssse3x2 recovery algorithm
[    0.403538] ACPI: Added _OSI(Module Device)
[    0.404208] ACPI: Added _OSI(Processor Device)
[    0.404696] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.405177] ACPI: Added _OSI(Processor Aggregator Device)
[    0.424747] ACPI: Interpreter enabled
[    0.425488] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140424/hwxface-580)
[    0.427092] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140424/hwxface-580)
[    0.428720] ACPI: (supports S0 S3 S5)
[    0.429368] ACPI: Using IOAPIC for interrupt routing
[    0.430296] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.466877] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.467916] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.468907] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.471836] PCI host bridge to bus 0000:00
[    0.472534] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.473267] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.473349] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.474161] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.475255] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.476501] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.478390] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.481380] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.485471] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.487671] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.488781] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.489818] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.490018] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.492334] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.493964] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.495180] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.497757] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.500854] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.503441] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.511807] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.515045] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.516685] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.518733] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.525085] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.527183] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.528642] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.534376] pci_bus 0000:00: on NUMA node 0
[    0.537855] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.539343] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.540835] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.542307] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.543474] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.546666] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.550940] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.552030] vgaarb: loaded
[    0.552404] vgaarb: bridge control possible 0000:00:02.0
[    0.556916] SCSI subsystem initialized
[    0.558003] ACPI: bus type USB registered
[    0.558864] usbcore: registered new interface driver usbfs
[    0.559746] usbcore: registered new interface driver hub
[    0.560393] usbcore: registered new device driver usb
[    0.563562] Linux video capture interface: v2.00
[    0.564463] pps_core: LinuxPPS API ver. 1 registered
[    0.565245] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.566785] PTP clock support registered
[    0.570138] Advanced Linux Sound Architecture Driver Initialized.
[    0.571146] PCI: Using ACPI for IRQ routing
[    0.571853] PCI: pci_cache_line_size set to 64 bytes
[    0.572991] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.573397] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.577491] NetLabel: Initializing
[    0.578078] NetLabel:  domain hash size =3D 128
[    0.578807] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.579754] NetLabel:  unlabeled traffic allowed by default
[    0.582230] Switched to clocksource kvm-clock
[    0.583333] Warning: could not register all branches stats
[    0.584031] Warning: could not register annotated branches stats
[    0.769389] FS-Cache: Loaded
[    0.770342] CacheFiles: Loaded
[    0.770983] pnp: PnP ACPI init
[    0.771610] ACPI: bus type PNP registered
[    0.772484] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.774056] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.775236] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.776994] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.778093] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.779672] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.780878] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.782097] pnp 00:03: [dma 2]
[    0.783079] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.784454] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.785914] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.787113] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.788668] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.790189] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:3)
[    0.791673] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.794369] pnp: PnP ACPI: found 7 devices
[    0.794969] ACPI: bus type PNP unregistered
[    0.803779] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.804650] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.805518] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.806477] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.807607] NET: Registered protocol family 2
[    0.810788] TCP established hash table entries: 4096 (order: 3, 32768 by=
tes)
[    0.811985] TCP bind hash table entries: 4096 (order: 6, 262144 bytes)
[    0.813890] TCP: Hash tables configured (established 4096 bind 4096)
[    0.815032] TCP: reno registered
[    0.815628] UDP hash table entries: 256 (order: 3, 40960 bytes)
[    0.816984] UDP-Lite hash table entries: 256 (order: 3, 40960 bytes)
[    0.818855] NET: Registered protocol family 1
[    0.819647] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.820615] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.821535] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.822766] pci 0000:00:02.0: Boot video device
[    0.823560] PCI: CLS 0 bytes, default 64
[    0.825241] Unpacking initramfs...
[    3.271283] debug: unmapping init [mem 0xffff88001293d000-0xffff880013fe=
ffff]
[    3.304558] sha1_ssse3: Using AVX optimized SHA-1 implementation
[    3.307272] alg: No test for crc32 (crc32-pclmul)
[    3.307987] sha512_ssse3: Using AVX optimized SHA-512 implementation
[    3.314309] BUG: unable to handle kernel paging request at ffff88000bb15=
010
[    3.316371] IP: [<ffffffff8124c717>] slob_free+0x437/0x750
[    3.316842] PGD 44d2067 PUD 44d3067 PMD 12792067 PTE 800000000bb15060
[    3.316842] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    3.316842] CPU: 1 PID: 14 Comm: ksoftirqd/1 Not tainted 3.16.0-rc4-0034=
0-g0a5f047 #3
[    3.316842] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.316842] task: ffff8800120ec000 ti: ffff8800120f0000 task.ti: ffff880=
0120f0000
[    3.316842] RIP: 0010:[<ffffffff8124c717>]  [<ffffffff8124c717>] slob_fr=
ee+0x437/0x750
[    3.316842] RSP: 0000:ffff8800120f3c30  EFLAGS: 00010046
[    3.316842] RAX: 0000000000000028 RBX: ffff88000bb14fc0 RCX: 00000000000=
00292
[    3.316842] RDX: ffff88000bb15010 RSI: 0000000000000808 RDI: ffff88000bb=
14fb8
[    3.316842] RBP: ffff8800120f3c60 R08: ffff8800120ec7d0 R09: 00000000000=
00002
[    3.316842] R10: 0000000000000000 R11: ffffffb97fd5a00f R12: ffff88000bb=
14fb8
[    3.316842] R13: ffff88000bb15010 R14: 0000000000000028 R15: ffff88000bb=
14000
[    3.316842] FS:  0000000000000000(0000) GS:ffff880012500000(0000) knlGS:=
0000000000000000
[    3.316842] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.316842] CR2: ffff88000bb15010 CR3: 0000000002c0b000 CR4: 00000000000=
406e0
[    3.316842] Stack:
[    3.316842]  0000000000000292 0000000000000000 ffff88000bb14fc0 ffff8800=
000964b0
[    3.316842]  0000000000000000 ffff88000bb1f888 ffff8800120f3c70 ffffffff=
8124ca85
[    3.316842]  ffff8800120f3c98 ffffffff8124dcb4 ffffffff82c37220 00000000=
00000000
[    3.316842] Call Trace:
[    3.316842]  [<ffffffff8124ca85>] __kmem_cache_free+0x55/0x60
[    3.316842]  [<ffffffff8124dcb4>] kmem_cache_free+0x124/0x170
[    3.316842]  [<ffffffff810e8f94>] put_pid+0x64/0x70
[    3.316842]  [<ffffffff810e8fb2>] delayed_put_pid+0x12/0x20
[    3.316842]  [<ffffffff8205e845>] rcu_do_batch.isra.47+0x73a/0xbbc
[    3.316842]  [<ffffffff8205e60a>] ? rcu_do_batch.isra.47+0x4ff/0xbbc
[    3.316842]  [<ffffffff8114de50>] rcu_process_callbacks+0x630/0x640
[    3.316842]  [<ffffffff810c1734>] __do_softirq+0x1f4/0x5a0
[    3.316842]  [<ffffffff810c1b35>] run_ksoftirqd+0x55/0x90
[    3.316842]  [<ffffffff810f9a3b>] smpboot_thread_fn+0x40b/0x4b0
[    3.316842]  [<ffffffff810f9630>] ? in_egroup_p+0x60/0x60
[    3.316842]  [<ffffffff810ee08f>] kthread+0x12f/0x140
[    3.316842]  [<ffffffff810edf60>] ? __kthread_parkme+0x90/0x90
[    3.316842]  [<ffffffff82092f3c>] ret_from_fork+0x7c/0xb0
[    3.316842]  [<ffffffff810edf60>] ? __kthread_parkme+0x90/0x90
[    3.316842] Code: 77 ba 4c 89 e7 48 89 4d d0 e8 d6 f5 ff ff 85 c0 48 8b =
4d d0 0f 85 6a 01 00 00 49 0f bf c6 48 8d 14 43 4c 39 ea 0f 85 59 01 00 00 =
<41> 0f b7 75 00 48 83 05 7c d2 ce 01 01 66 85 f6 0f 9f c0 48 89=20
[    3.316842] RIP  [<ffffffff8124c717>] slob_free+0x437/0x750
[    3.316842]  RSP <ffff8800120f3c30>
[    3.316842] CR2: ffff88000bb15010
[    3.316842] ---[ end trace 5a5f8cab8c473caa ]---
[    3.316842] Kernel panic - not syncing: Fatal exception in interrupt
[    3.316842] Shutting down cpus with NMI
[    3.316842] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range=
: 0xffffffff80000000-0xffffffff9fffffff)
[    3.316842] Rebooting in 10 seconds..
Elapsed time: 10
qemu-system-x86_64 -enable-kvm -cpu Haswell,+smep,+smap -kernel /kernel/x86=
_64-randconfig-iv0-07151152/0a5f047dcd90af4cb72df583e3ee21a8d9262c4f/vmlinu=
z-3.16.0-rc4-00340-g0a5f047 -append 'hung_task_panic=3D1 earlyprintk=3DttyS=
0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_tim=
eout=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ram=
disk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ra=
m0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-iv0-07151152/nex=
t:master:0a5f047dcd90af4cb72df583e3ee21a8d9262c4f:bisect-linux3/.vmlinuz-0a=
5f047dcd90af4cb72df583e3ee21a8d9262c4f-20140715123536-2-kbuild branch=3Dnex=
t/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-iv0-07151152/0a5f047dcd90af=
4cb72df583e3ee21a8d9262c4f/vmlinuz-3.16.0-rc4-00340-g0a5f047 drbd.minor_cou=
nt=3D8'  -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 320 -smp 2=
 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-re=
boot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-q=
uantal-kbuild-21 -serial file:/dev/shm/kboot/serial-quantal-kbuild-21 -daem=
onize -display none -monitor null=20

--b2ktwntdbf0dPnbx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-ivb41-101:20140715125811:x86_64-randconfig-iv0-07151152::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 3.16.0-rc4-00339-g8df59fd (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #5 SMP PREEMPT Tue Jul 15 12:52:16 CS=
T 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-iv0-07151152/next:master=
:8df59fd2a350161bd39c3c9f8f4213b2a2a61847:bisect-linux3/.vmlinuz-8df59fd2a3=
50161bd39c3c9f8f4213b2a2a61847-20140715125615-59-ivb41 branch=3Dnext/master=
 BOOT_IMAGE=3D/kernel/x86_64-randconfig-iv0-07151152/8df59fd2a350161bd39c3c=
9f8f4213b2a2a61847/vmlinuz-3.16.0-rc4-00339-g8df59fd drbd.minor_count=3D8
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/0=
1/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
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
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x044d2000, 0x044d2fff] PGTABLE
[    0.000000] BRK [0x044d3000, 0x044d3fff] PGTABLE
[    0.000000] BRK [0x044d4000, 0x044d4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 4k
[    0.000000] BRK [0x044d5000, 0x044d5fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 4k
[    0.000000] BRK [0x044d6000, 0x044d6fff] PGTABLE
[    0.000000] BRK [0x044d7000, 0x044d7fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
[    0.000000]  [mem 0x12800000-0x13ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0D00 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFFC2A 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFF1C0 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE040 001180 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FFE000 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF234 00093E (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFFB72 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFFBF2 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff88001180000=
0-ffff880011dfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA32 zone: 1280 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 81820 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff880012400000 s81792 r0 d2=
0608 u1048576
[    0.000000] pcpu-alloc: s81792 r0 d20608 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1240cf00
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-iv0-07151152/next=
:master:8df59fd2a350161bd39c3c9f8f4213b2a2a61847:bisect-linux3/.vmlinuz-8df=
59fd2a350161bd39c3c9f8f4213b2a2a61847-20140715125615-59-ivb41 branch=3Dnext=
/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-iv0-07151152/8df59fd2a350161=
bd39c3c9f8f4213b2a2a61847/vmlinuz-3.16.0-rc4-00339-g8df59fd drbd.minor_coun=
t=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 242028K/327280K available (16983K kernel code, 9164K=
 rwdata, 9472K rodata, 1248K init, 14956K bss, 85252K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8159 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 5389.47 Bogo=
MIPS (lpj=3D8978360)
[    0.006666] pid_max: default: 4096 minimum: 301
[    0.006731] ACPI: Core revision 20140424
[    0.024756] ACPI: All ACPI Tables successfully acquired
[    0.027456] Security Framework initialized
[    0.030026] Smack:  Initializing.
[    0.033406] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.034392] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.037555] Initializing cgroup subsys freezer
[    0.038284] Initializing cgroup subsys blkio
[    0.039025] Initializing cgroup subsys perf_event
[    0.039821] Initializing cgroup subsys debug
[    0.043351] mce: CPU supports 10 MCE banks
[    0.044107] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.044107] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.044107] tlb_flushall_shift: 6
[    0.046587] debug: unmapping init [mem 0xffffffff8362d000-0xffffffff8363=
5fff]
[    0.052872] Getting VERSION: 1050014
[    0.053362] Getting VERSION: 1050014
[    0.053901] Getting ID: 0
[    0.054356] Getting ID: ff000000
[    0.056686] Getting LVT0: 8700
[    0.057185] Getting LVT1: 8400
[    0.057672] enabled ExtINT on CPU#0
[    0.060031] ENABLING IO-APIC IRQs
[    0.060575] init IO_APIC IRQs
[    0.061039]  apic 0 pin 0 not connected
[    0.061676] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.062959] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.063379] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.064584] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.066730] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.067949] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.070037] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.071236] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.072465] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.073442] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.076707] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.077935] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.079174] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.080047] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.081437] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.083369]  apic 0 pin 16 not connected
[    0.083998]  apic 0 pin 17 not connected
[    0.084577]  apic 0 pin 18 not connected
[    0.085194]  apic 0 pin 19 not connected
[    0.085911]  apic 0 pin 20 not connected
[    0.086691]  apic 0 pin 21 not connected
[    0.087304]  apic 0 pin 22 not connected
[    0.087898]  apic 0 pin 23 not connected
[    0.088661] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.090012] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.091777] Using local APIC timer interrupts.
[    0.091777] calibrating APIC timer ...
[    0.096666] ... lapic delta =3D 7484844
[    0.096666] ... PM-Timer delta =3D 428677
[    0.096666] APIC calibration not consistent with PM-Timer: 119ms instead=
 of 100ms
[    0.096666] APIC delta adjusted to PM-Timer: 6249996 (7484844)
[    0.096666] TSC delta adjusted to PM-Timer: 269351803 (322569165)
[    0.096666] ..... delta 6249996
[    0.096666] ..... mult: 268435311
[    0.096666] ..... calibration result: 3333331
[    0.096666] ..... CPU clock speed is 2693.2624 MHz.
[    0.096666] ..... host bus clock speed is 1000.0331 MHz.
[    0.096831] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.113421]=20
[    0.113421] **********************************************************
[    0.114547] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.115419] **                                                      **
[    0.116628] ** trace_printk() being used. Allocating extra memory.  **
[    0.116678] **                                                      **
[    0.118328] ** This means that this is a DEBUG kernel and it is     **
[    0.120010] ** unsafe for produciton use.                           **
[    0.121839] **                                                      **
[    0.126716] ** If you see this message and you are not debugging    **
[    0.130012] ** the kernel, report this immediately to your vendor!  **
[    0.133341] **                                                      **
[    0.134933] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.136677] **********************************************************
[    0.150267] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.158829] x86: Booting SMP configuration:
[    0.160014] .... node  #0, CPUs:      #1
[    0.006666] kvm-clock: cpu 1, msr 0:13ffd041, secondary cpu clock
[    0.006666] masked ExtINT on CPU#1
[    0.190140] x86: Booted up 1 node, 2 CPUs
[    0.190738] smpboot: Total of 2 processors activated (10778.95 BogoMIPS)
[    0.189999] KVM setup async PF for cpu 1
[    0.189999] kvm-stealtime: cpu 1, msr 1250cf00
[    0.207116] xor: measuring software checksum speed
[    0.240015]    prefetch64-sse:  7368.000 MB/sec
[    0.273355]    generic_sse:  5317.200 MB/sec
[    0.273977] xor: using function: prefetch64-sse (7368.000 MB/sec)
[    0.276711] prandom: seed boundary self test passed
[    0.277985] prandom: 100 self tests passed
[    0.280701] regulator-dummy: no parameters
[    0.281893] NET: Registered protocol family 16
[    0.283858] cpuidle: using governor menu
[    0.284851] ACPI: bus type PCI registered
[    0.285491] PCI: Using configuration type 1 for base access
[    0.290529] mtrr: your CPUs had inconsistent variable MTRR settings
[    0.291393] mtrr: your CPUs had inconsistent MTRRdefType settings
[    0.292213] mtrr: probably your BIOS does not setup all CPUs.
[    0.293188] mtrr: corrected configuration.
[    0.416684] raid6: sse2x1    3153 MB/s
[    0.473355] raid6: sse2x2    3555 MB/s
[    0.530014] raid6: sse2x4    4358 MB/s
[    0.530575] raid6: using algorithm sse2x4 (4358 MB/s)
[    0.533347] raid6: using intx1 recovery algorithm
[    0.540284] ACPI: Added _OSI(Module Device)
[    0.540887] ACPI: Added _OSI(Processor Device)
[    0.541602] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.542236] ACPI: Added _OSI(Processor Aggregator Device)
[    0.581096] ACPI: Interpreter enabled
[    0.581650] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140424/hwxface-580)
[    0.582972] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140424/hwxface-580)
[    0.584189] ACPI: (supports S0 S3 S5)
[    0.584710] ACPI: Using IOAPIC for interrupt routing
[    0.585557] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.633451] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.636693] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.640144] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.643607] PCI host bridge to bus 0000:00
[    0.644216] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.646685] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.647631] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.650019] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.650873] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.651719] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.652585] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.653346] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.656800] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.660995] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.666693] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.675105] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.676990] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.677965] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.678854] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.679839] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.684043] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.686751] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.687765] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.690988] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.693985] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.700028] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.710658] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.714623] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.716529] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.720542] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.730016] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.731949] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.733649] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.742521] pci_bus 0000:00: on NUMA node 0
[    0.750490] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.752079] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.753668] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.755339] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.756501] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.761663] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.768810] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.770016] vgaarb: loaded
[    0.770381] vgaarb: bridge control possible 0000:00:02.0
[    0.777774] SCSI subsystem initialized
[    0.780093] ACPI: bus type USB registered
[    0.781028] usbcore: registered new interface driver usbfs
[    0.781873] usbcore: registered new interface driver hub
[    0.783471] usbcore: registered new device driver usb
[    0.784682] Linux video capture interface: v2.00
[    0.786754] pps_core: LinuxPPS API ver. 1 registered
[    0.787443] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.790065] PTP clock support registered
[    0.793770] Advanced Linux Sound Architecture Driver Initialized.
[    0.794636] PCI: Using ACPI for IRQ routing
[    0.795216] PCI: pci_cache_line_size set to 64 bytes
[    0.796114] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.796704] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.799091] NetLabel: Initializing
[    0.800008] NetLabel:  domain hash size =3D 128
[    0.800646] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.803481] NetLabel:  unlabeled traffic allowed by default
[    0.805047] Switched to clocksource kvm-clock
[    0.808715] Warning: could not register all branches stats
[    0.809685] Warning: could not register annotated branches stats
[    1.078736] FS-Cache: Loaded
[    1.085090] CacheFiles: Loaded
[    1.085673] pnp: PnP ACPI init
[    1.086232] ACPI: bus type PNP registered
[    1.086978] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    1.089575] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.090601] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    1.096532] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.097565] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    1.101364] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.102467] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    1.103647] pnp 00:03: [dma 2]
[    1.104266] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.110107] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    1.111639] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.118488] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.119951] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.122395] pnp: PnP ACPI: found 6 devices
[    1.122967] ACPI: bus type PNP unregistered
[    1.139286] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.140093] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    1.140839] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    1.142793] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    1.143590] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    1.144369] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    1.145238] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    1.149701] NET: Registered protocol family 2
[    1.155102] TCP established hash table entries: 4096 (order: 3, 32768 by=
tes)
[    1.156147] TCP bind hash table entries: 4096 (order: 6, 262144 bytes)
[    1.157539] TCP: Hash tables configured (established 4096 bind 4096)
[    1.158494] TCP: reno registered
[    1.162509] UDP hash table entries: 256 (order: 3, 40960 bytes)
[    1.163439] UDP-Lite hash table entries: 256 (order: 3, 40960 bytes)
[    1.164963] NET: Registered protocol family 1
[    1.165653] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.166494] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.167367] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.168261] pci 0000:00:02.0: Boot video device
[    1.175783] PCI: CLS 0 bytes, default 64
[    1.177095] Unpacking initramfs...
[    5.446726] debug: unmapping init [mem 0xffff88001293d000-0xffff880013fe=
ffff]
[    5.466824] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    5.468162] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    5.470149] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    5.486340] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usab=
le.
[    5.487413] PCLMULQDQ-NI instructions are not detected.
[    5.488195] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    5.489088] AVX or AES-NI instructions are not detected.
[    5.489815] AVX instructions are not detected.
[    5.490491] AVX instructions are not detected.
[    5.491254] AVX instructions are not detected.
[    5.491881] AVX2 instructions are not detected.
[    5.492719] spin_lock-torture:--- Start of test: nwriters_stress=3D4 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    5.495049] spin_lock-torture: Creating torture_shuffle task
[    5.496064] spin_lock-torture: torture_shuffle task started
[    5.496081] spin_lock-torture: Creating torture_stutter task
[    5.503585] spin_lock-torture: Creating lock_torture_writer task
[    5.503593] spin_lock-torture: torture_stutter task started
[    5.505614] spin_lock-torture: Creating lock_torture_writer task
[    5.505625] spin_lock-torture: lock_torture_writer task started
[    5.507595] spin_lock-torture: Creating lock_torture_writer task
[    5.507606] spin_lock-torture: lock_torture_writer task started
[    5.509431] spin_lock-torture: Creating lock_torture_writer task
[    5.509442] spin_lock-torture: lock_torture_writer task started
[    5.511265] spin_lock-torture: Creating lock_torture_stats task
[    5.511275] spin_lock-torture: lock_torture_writer task started
[    5.513166] spin_lock-torture: lock_torture_stats task started
[    5.529445] futex hash table entries: 16 (order: -1, 2048 bytes)
[    5.550805] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    5.552890] zbud: loaded
[    5.553339] zpool: loaded
[    5.554453] VFS: Disk quotas dquot_6.5.2
[    5.555151] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    5.572914] DLM installed
[    5.575251] ntfs: driver 2.1.30 [Flags: R/W].
[    5.577100] ROMFS MTD (C) 2007 Red Hat, Inc.
[    5.577760] QNX6 filesystem 1.0.0 registered.
[    5.578661] fuse init (API version 7.23)
[    5.580860] Key type big_key registered
[    6.133586] alg: No test for lz4 (lz4-generic)
[    6.153572] alg: No test for stdrng (krng)
[    6.200337] NET: Registered protocol family 38
[    6.201073] Key type asymmetric registered
[    6.202791] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    6.240460] io scheduler noop registered (default)
[    6.241175] io scheduler deadline registered
[    6.241726] start plist test
[    6.259875] end plist test
[    6.262629] crc32: CRC_LE_BITS =3D 32, CRC_BE BITS =3D 32
[    6.270241] crc32: self tests passed, processed 225944 bytes in 229157 n=
sec
[    6.271356] crc32c: CRC_LE_BITS =3D 32
[    6.271814] crc32c: self tests passed, processed 225944 bytes in 113238 =
nsec
[    6.453651] tsc: Refined TSC clocksource calibration: 2693.508 MHz
[    7.609952] crc32_combine: 8373 self tests passed
[    9.179419] crc32c_combine: 8373 self tests passed
[    9.183883] rbtree testing -> 52926 cycles
[   11.354867] augmented rbtree testing -> 70080 cycles
[   14.307729] hgafb: HGA card not detected.
[   14.308358] hgafb: probe of hgafb.0 failed with error -22
[   14.309562] usbcore: registered new interface driver smscufx
[   14.311698] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   14.312796] ACPI: Power Button [PWRF]
[   14.561213] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   14.641862] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   14.663845] Non-volatile memory driver v1.3
[   14.664544] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[   14.665836] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[   14.667177] Hangcheck: Using getrawmonotonic().
[   14.668616] dummy-irq: no IRQ given.  Use irq=3DN
[   14.670343] lkdtm: No crash points registered, enable through debugfs
[   14.671778] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[   14.694288] c2port c2port0: C2 port uc added
[   14.694842] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[   14.712217] usbcore: registered new interface driver viperboard
[   14.713231] Uniform Multi-Platform E-IDE driver
[   14.715695] ide-gd driver 1.18
[   14.716913] Loading iSCSI transport class v2.0-870.
[   14.719243] rdac: device handler registered
[   14.719954] emc: device handler registered
[   14.720549] alua: device handler registered
[   14.743320] iscsi: registered transport (tcp)
[   14.744135] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[   14.755406] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[   14.772358] SSFDC read-only Flash Translation layer
[   14.780549] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[   14.782078] slram: not enough parameters.
[   14.787594] ftl_cs: FTL header not found.
[   14.923289] No valid DiskOnChip devices found
[   14.924144] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   14.925524] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   14.927056] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   14.928454] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   14.929687] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   14.931026] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   14.932209] nand: device found, Manufacturer ID: 0x98, Chip ID: 0x39
[   14.933014] nand: Toshiba NAND 128MiB 1,8V 8-bit
[   14.944031] nand: 128MiB, SLC, page size: 512, OOB size: 16
[   14.946242] flash size: 128 MiB
[   14.960320] page size: 512 bytes
[   14.960798] OOB area size: 16 bytes
[   14.961323] sector size: 16 KiB
[   14.961788] pages number: 262144
[   14.962265] pages per sector: 32
[   14.962745] bus width: 8
[   14.972337] bits in sector size: 14
[   14.972794] bits in page size: 9
[   14.973412] bits in OOB size: 4
[   14.973825] flash size with OOB: 135168 KiB
[   14.974363] page address bytes: 4
[   14.974781] sector address bytes: 3
[   14.975233] options: 0x42
[   14.978324] Scanning device for bad blocks
[   15.225514] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[   15.226572] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[   15.247264] ftl_cs: FTL header not found.
[   15.269122] libphy: Fixed MDIO Bus: probed
[   15.272050] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.t=
c.umn.edu>
[   15.275701] ipddp0: Appletalk-IP Encap. mode by Bradford W. Johnson <joh=
ns393@maroon.tc.umn.edu>
[   15.277335] vcan: Virtual CAN interface driver
[   15.278659] YAM driver version 0.8 by F1OAT/F6FBB
[   15.301640] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   15.301640] baycom_ser_fdx: version 0.10
[   15.308112] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[   15.308935] hdlcdrv: version 0.8
[   15.322558] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   15.322558] baycom_ser_hdx: version 0.10
[   15.342977] ieee802154fakelb ieee802154fakelb: added ieee802154 hardware
[   15.344453] usbcore: registered new interface driver catc
[   15.345244] usbcore: registered new interface driver kaweth
[   15.345945] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[   15.347101] usbcore: registered new interface driver pegasus
[   15.347916] usbcore: registered new interface driver r8152
[   15.348803] usbcore: registered new interface driver ax88179_178a
[   15.349679] usbcore: registered new interface driver cdc_ether
[   15.350628] usbcore: registered new interface driver dm9601
[   15.351599] usbcore: registered new interface driver sr9700
[   15.352416] usbcore: registered new interface driver smsc75xx
[   15.353283] usbcore: registered new interface driver net1080
[   15.354296] usbcore: registered new interface driver cdc_subset
[   15.373801] usbcore: registered new interface driver zaurus
[   15.374757] usbcore: registered new interface driver MOSCHIP usb-etherne=
t driver
[   15.375965] usbcore: registered new interface driver cdc_phonet
[   15.377248] usbcore: registered new interface driver kalmia
[   15.392897] usbcore: registered new interface driver ipheth
[   15.397450] usbcore: registered new interface driver cx82310_eth
[   15.398535] usbcore: registered new interface driver cdc_ncm
[   15.399770] usbcore: registered new interface driver cdc_mbim
[   15.402687] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   15.422830] ehci-pci: EHCI PCI platform driver
[   15.423932] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   15.425124] ohci-pci: OHCI PCI platform driver
[   15.425907] driver u132_hcd
[   15.426790] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[   15.442671] usbcore: registered new interface driver usblp
[   15.443603] usbcore: registered new interface driver cdc_wdm
[   15.444543] usbcore: registered new interface driver usbtmc
[   15.445731] usbcore: registered new interface driver uas
[   15.446599] usbcore: registered new interface driver usb-storage
[   15.447600] usbcore: registered new interface driver ums-alauda
[   15.448532] usbcore: registered new interface driver ums-cypress
[   15.449660] usbcore: registered new interface driver ums-datafab
[   15.450633] usbcore: registered new interface driver ums_eneub6250
[   15.451613] usbcore: registered new interface driver ums-freecom
[   15.452543] usbcore: registered new interface driver ums-realtek
[   15.453827] usbcore: registered new interface driver ums-usbat
[   15.454950] usbcore: registered new interface driver mdc800
[   15.455766] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[   15.457000] usbcore: registered new interface driver adutux
[   15.458620] usbcore: registered new interface driver appledisplay
[   15.460657] usbcore: registered new interface driver cypress_cy7c63
[   15.463524] usbcore: registered new interface driver cytherm
[   15.467354] usbcore: registered new interface driver emi62 - firmware lo=
ader
[   15.468275] ftdi_elan: driver ftdi-elan
[   15.477372] usbcore: registered new interface driver ftdi-elan
[   15.478221] usbcore: registered new interface driver idmouse
[   15.479028] usbcore: registered new interface driver isight_firmware
[   15.479956] usbcore: registered new interface driver usblcd
[   15.480944] usbcore: registered new interface driver ldusb
[   15.481736] usbcore: registered new interface driver usbled
[   15.482531] usbcore: registered new interface driver rio500
[   15.487161] usbcore: registered new interface driver usbtest
[   15.500555] usbcore: registered new interface driver usb_ehset_test
[   15.501556] usbcore: registered new interface driver usbsevseg
[   15.502498] usbcore: registered new interface driver yurex
[   15.503997] usbcore: registered new interface driver sisusb
[   15.505843] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   15.508632] serio: i8042 KBD port at 0x60,0x64 irq 1
[   15.528149] serio: i8042 AUX port at 0x60,0x64 irq 12
[   15.684386] mousedev: PS/2 mouse device common for all mice
[   15.708456] rtc (null): invalid alarm value: 1900-1-15 0:0:0
[   15.709596] rtc-test rtc-test.0: rtc core: registered test as rtc0
[   15.710824] rtc (null): invalid alarm value: 1900-1-15 0:0:0
[   15.711997] rtc-test rtc-test.1: rtc core: registered test as rtc1
[   15.714549] usbcore: registered new interface driver i2c-diolan-u2c
[   15.715456] i2c-parport-light: adapter type unspecified
[   15.716317] usbcore: registered new interface driver i2c-tiny-usb
[   15.717897] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   15.718518] pps pps0: new PPS source ktimer
[   15.718528] pps pps0: ktimer PPS source registered
[   15.718637] Driver for 1-wire Dallas network protocol.
[   15.720185] usbcore: registered new interface driver DS9490R
[   15.720426] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[   15.735872] pc87360: PC8736x not detected, module not inserted
[   15.737628] usbcore: registered new interface driver pcwd_usb
[   15.737988] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[   15.738156] wafer5823wdt: initialized. timeout=3D60 sec (nowayout=3D1)
[   15.738252] it87_wdt: no device
[   15.738257] sc1200wdt: build 20020303
[   15.738336] sc1200wdt: io parameter must be specified
[   15.738394] cpu5wdt: misc_register failed
[   15.738464] sbc_epx_c3: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[   15.738935] md: raid1 personality registered for level 1
[   15.738941] md: raid10 personality registered for level 10
[   15.739384] md: raid6 personality registered for level 6
[   15.739386] md: raid5 personality registered for level 5
[   15.739388] md: raid4 personality registered for level 4
[   15.739394] md: faulty personality registered for level -5
[   15.739590] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[   15.740345] device-mapper: multipath: version 1.7.0 loaded
[   15.740373] device-mapper: multipath round-robin: version 1.0.0 loaded
[   15.740379] device-mapper: multipath queue-length: version 0.1.0 loaded
[   15.740385] device-mapper: multipath service-time: version 0.2.0 loaded
[   15.740397] device-mapper: raid: Loading target version 1.5.2
[   15.740448] device-mapper: cache-policy-mq: version 1.2.0 loaded
[   15.740453] device-mapper: cache cleaner: version 1.0.0 loaded
[   15.740540] sdhci: Secure Digital Host Controller Interface driver
[   15.740541] sdhci: Copyright(c) Pierre Ossman
[   15.740546] wbsd: Winbond W83L51xD SD/MMC card interface driver
[   15.740547] wbsd: Copyright(c) Pierre Ossman
[   15.740842] usbcore: registered new interface driver ushc
[   15.740848] sdhci-pltfm: SDHCI platform and OF driver helper
[   15.746523] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[   15.747743] usbcore: registered new interface driver usbhid
[   15.747745] usbhid: USB HID core driver
[   15.803947] usbcore: registered new interface driver snd-usb-audio
[   15.804221] usbcore: registered new interface driver snd-usb-caiaq
[   15.804337] usbcore: registered new interface driver snd-usb-hiface
[   15.824411] drop_monitor: Initializing network drop monitor service
[   15.825716] Netfilter messages via NETLINK v0.30.
[   15.826436] nfnl_acct: registering with nfnetlink.
[   15.852950] nf_conntrack version 0.5.0 (1890 buckets, 7560 max)
[   15.854873] nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>
[   15.855836] nf_tables_compat: (c) 2012 Pablo Neira Ayuso <pablo@netfilte=
r.org>
[   15.860256] xt_time: kernel timezone is -0000
[   15.860969] ip_set: protocol 6
[   15.861578] ipip: IPv4 over IPv4 tunneling driver
[   15.875431] IPv4 over IPSec tunneling driver
[   15.879949] ip_tables: (C) 2000-2006 Netfilter Core Team
[   15.881832] arp_tables: (C) 2002 David S. Miller
[   15.882710] TCP: bic registered
[   15.883189] TCP: cubic registered
[   15.887069] TCP: westwood registered
[   15.887616] TCP: highspeed registered
[   15.888153] TCP: hybla registered
[   15.888630] TCP: htcp registered
[   15.889115] TCP: vegas registered
[   15.889591] TCP: veno registered
[   15.893296] TCP: scalable registered
[   15.894022] TCP: yeah registered
[   15.894512] Initializing XFRM netlink socket
[   15.895271] NET: Registered protocol family 10
[   15.899794] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   15.901511] sit: IPv6 over IPv4 tunneling driver
[   15.903816] NET: Registered protocol family 17
[   15.904461] NET: Registered protocol family 15
[   15.905123] Ebtables v2.0 registered
[   15.933663] NET: Registered protocol family 4
[   15.934484] NET: Registered protocol family 5
[   15.941218] NET: Registered protocol family 6
[   15.953925] NET: Registered protocol family 11
[   15.954832] NET: Registered protocol family 3
[   15.965549] can: controller area network core (rev 20120528 abi 9)
[   15.974122] NET: Registered protocol family 29
[   15.974768] can: broadcast manager protocol (rev 20120528 t)
[   15.975701] NET: Registered protocol family 33
[   15.976372] Key type rxrpc registered
[   15.977702] Key type rxrpc_s registered
[   15.983453] RxRPC: Registered security type 2 'rxkad'
[   15.984265] l2tp_core: L2TP core driver, V2.0
[   15.984895] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[   15.986371] DECnet: Routing cache hash table of 256 buckets, 16Kbytes
[   15.987664] NET: Registered protocol family 12
[   15.989358] NET: Registered protocol family 35
[   15.990753] DCCP: Activated CCID 2 (TCP-like)
[   15.991406] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[   15.993212] sctp: Hash tables configured (established 1024 bind 1024)
[   15.994666] tipc: Activated (version 2.0.0)
[   15.996227] NET: Registered protocol family 30
[   15.998142] tipc: Started in single node mode
[   15.999351] NET: Registered protocol family 37
[   15.999960] NET: Registered protocol family 36
[   16.000981] Key type dns_resolver registered
[   16.002310] batman_adv: B.A.T.M.A.N. advanced 2014.3.0 (compatibility ve=
rsion 15) loaded
[   16.018691]=20
[   16.018691] printing PIC contents
[   16.019414] ... PIC  IMR: ffff
[   16.019860] ... PIC  IRR: 1013
[   16.020372] ... PIC  ISR: 0000
[   16.020856] ... PIC ELCR: 0c00
[   16.021317] printing local APIC contents on CPU#0/0:
[   16.022017] ... APIC ID:      00000000 (0)
[   16.022597] ... APIC VERSION: 01050014
[   16.023136] ... APIC TASKPRI: 00000000 (00)
[   16.023665] ... APIC PROCPRI: 00000000
[   16.023665] ... APIC LDR: 01000000
[   16.023665] ... APIC DFR: ffffffff
[   16.023665] ... APIC SPIV: 000001ff
[   16.023665] ... APIC ISR field:
[   16.023665] 000000000000000000000000000000000000000000000000000000000000=
0000
[   16.023665] ... APIC TMR field:
[   16.023665] 000000000200000000000000000000000000000000000000000000000000=
0000
[   16.023665] ... APIC IRR field:
[   16.023665] 000000000000000000000000000000000000000000000000000000000000=
8000
[   16.023665] ... APIC ESR: 00000000
[   16.023665] ... APIC ICR: 000008fd
[   16.023665] ... APIC ICR2: 02000000
[   16.023665] ... APIC LVTT: 000000ef
[   16.023665] ... APIC LVTPC: 00010000
[   16.023665] ... APIC LVT0: 00010700
[   16.023665] ... APIC LVT1: 00000400
[   16.023665] ... APIC LVTERR: 000000fe
[   16.023665] ... APIC TMICT: 0002db0b
[   16.023665] ... APIC TMCCT: 00000000
[   16.023665] ... APIC TDCR: 00000003
[   16.023665]=20
[   16.050923] number of MP IRQ sources: 15.
[   16.051507] number of IO-APIC #0 registers: 24.
[   16.052156] testing the IO APIC.......................
[   16.052901] IO APIC #0......
[   16.053376] .... register #00: 00000000
[   16.078144] .......    : physical APIC id: 00
[   16.078791] .......    : Delivery Type: 0
[   16.079356] .......    : LTS          : 0
[   16.087285] .... register #01: 00170011
[   16.087845] .......     : max redirection entries: 17
[   16.088547] .......     : PRQ implemented: 0
[   16.089160] .......     : IO APIC version: 11
[   16.089763] .... register #02: 00000000
[   16.090654] .......     : arbitration: 00
[   16.091287] .... IRQ redirection table:
[   16.091851] 1    0    0   0   0    0    0    00
[   16.092434] 0    0    0   0   0    1    1    31
[   16.093007] 0    0    0   0   0    1    1    30
[   16.096475] 0    0    0   0   0    1    1    33
[   16.103387] 1    0    0   0   0    1    1    34
[   16.103972] 1    1    0   0   0    1    1    35
[   16.104553] 0    0    0   0   0    1    1    36
[   16.105132] 0    0    0   0   0    1    1    37
[   16.105703] 0    0    0   0   0    1    1    38
[   16.106286] 0    1    0   0   0    1    1    39
[   16.116692] 1    1    0   0   0    1    1    3A
[   16.117504] 1    1    0   0   0    1    1    3B
[   16.118180] 0    0    0   0   0    1    1    3C
[   16.118825] 0    0    0   0   0    1    1    3D
[   16.119474] 0    0    0   0   0    1    1    3E
[   16.120159] 0    0    0   0   0    1    1    3F
[   16.120834] 1    0    0   0   0    0    0    00
[   16.121485] 1    0    0   0   0    0    0    00
[   16.122131] 1    0    0   0   0    0    0    00
[   16.122771] 1    0    0   0   0    0    0    00
[   16.136830] 1    0    0   0   0    0    0    00
[   16.137563] 1    0    0   0   0    0    0    00
[   16.138229] 1    0    0   0   0    0    0    00
[   16.138877] 1    0    0   0   0    0    0    00
[   16.139525] IRQ to pin mappings:
[   16.139990] IRQ0 -> 0:2
[   16.140445] IRQ1 -> 0:1
[   16.140866] IRQ3 -> 0:3
[   16.141292] IRQ4 -> 0:4
[   16.141691] IRQ5 -> 0:5
[   16.142102] IRQ6 -> 0:6
[   16.142502] IRQ7 -> 0:7
[   16.142912] IRQ8 -> 0:8
[   16.143318] IRQ9 -> 0:9
[   16.143761] IRQ10 -> 0:10
[   16.144213] IRQ11 -> 0:11
[   16.144638] IRQ12 -> 0:12
[   16.164068] IRQ13 -> 0:13
[   16.164532] IRQ14 -> 0:14
[   16.164958] IRQ15 -> 0:15
[   16.165394] .................................... done.
[   16.172289] registered taskstats version 1
[   16.175239] Key type encrypted registered
[   16.176448] raid6test: testing the 4-disk case...
[   16.197240] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[   16.198281] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(P) =
 OK
[   16.199273] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(Q) =
 OK
[   16.200301] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(P) =
 OK
[   16.201256] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(Q) =
 OK
[   16.202120] raid6test: test_disks(2, 3): faila=3D  2(P)  failb=3D  3(Q) =
 OK
[   16.202996] raid6test: testing the 5-disk case...
[   16.203677] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[   16.204563] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[   16.205441] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(P) =
 OK
[   16.230501] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(Q) =
 OK
[   16.231526] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[   16.232521] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(P) =
 OK
[   16.234561] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(Q) =
 OK
[   16.235567] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(P) =
 OK
[   16.236555] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(Q) =
 OK
[   16.237636] raid6test: test_disks(3, 4): faila=3D  3(P)  failb=3D  4(Q) =
 OK
[   16.238735] raid6test: testing the 11-disk case...
[   16.239498] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[   16.242042] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[   16.243071] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[   16.244145] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[   16.245163] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[   16.246178] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[   16.247241] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[   16.256207] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[   16.257298] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(P) =
 OK
[   16.281676] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(Q)=
  OK
[   16.282711] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[   16.283892] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[   16.284922] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[   16.285935] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[   16.286978] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[   16.288025] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[   16.290315] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[   16.293587] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(P) =
 OK
[   16.294619] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(Q)=
  OK
[   16.295639] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[   16.296644] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[   16.301184] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[   16.302195] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[   16.303205] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[   16.317119] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[   16.318020] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(P) =
 OK
[   16.318889] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(Q)=
  OK
[   16.319797] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[   16.331040] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[   16.332050] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[   16.333040] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[   16.346918] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[   16.347942] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(P) =
 OK
[   16.348923] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(Q)=
  OK
[   16.349943] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[   16.351018] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[   16.352026] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[   16.353030] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[   16.354077] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(P) =
 OK
[   16.373171] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(Q)=
  OK
[   16.374135] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[   16.375033] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[   16.375918] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[   16.376831] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(P) =
 OK
[   16.377821] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(Q)=
  OK
[   16.378825] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[   16.379816] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[   16.380826] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(P) =
 OK
[   16.381806] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(Q)=
  OK
[   16.391047] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[   16.392048] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(P) =
 OK
[   16.393033] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(Q)=
  OK
[   16.394214] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(P) =
 OK
[   16.395225] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(Q)=
  OK
[   16.396213] raid6test: test_disks(9, 10): faila=3D  9(P)  failb=3D 10(Q)=
  OK
[   16.414286] raid6test: testing the 12-disk case...
[   16.415046] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[   16.415991] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[   16.416995] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[   16.417946] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[   16.418848] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[   16.419753] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[   16.420671] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[   16.421579] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[   16.422482] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D) =
 OK
[   16.423411] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(P)=
  OK
[   16.424373] raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(Q)=
  OK
[   16.425312] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[   16.426214] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[   16.427138] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[   16.428045] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[   16.428942] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[   16.429846] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[   16.430774] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[   16.431681] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D) =
 OK
[   16.454317] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(P)=
  OK
[   16.455347] raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(Q)=
  OK
[   16.456384] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[   16.457451] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[   16.458464] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[   16.459472] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[   16.460519] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[   16.461552] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[   16.462542] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D) =
 OK
[   16.472687] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(P)=
  OK
[   16.473604] raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(Q)=
  OK
[   16.474506] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[   16.475390] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[   16.476314] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[   16.477268] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[   16.478177] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[   16.479074] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D) =
 OK
[   16.479963] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(P)=
  OK
[   16.480890] raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(Q)=
  OK
[   16.481807] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[   16.482706] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[   16.483676] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[   16.484684] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[   16.499296] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D) =
 OK
[   16.503448] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(P)=
  OK
[   16.504546] raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(Q)=
  OK
[   16.505572] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[   16.506578] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[   16.507650] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[   16.508673] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D) =
 OK
[   16.509666] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(P)=
  OK
[   16.510853] raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(Q)=
  OK
[   16.524991] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[   16.526028] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[   16.527108] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D) =
 OK
[   16.528106] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(P)=
  OK
[   16.529119] raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(Q)=
  OK
[   16.530179] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[   16.531153] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D) =
 OK
[   16.532040] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(P)=
  OK
[   16.532925] raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(Q)=
  OK
[   16.533868] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D) =
 OK
[   16.534760] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(P)=
  OK
[   16.535655] raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(Q)=
  OK
[   16.536577] raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(P)=
  OK
[   16.558759] raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(Q)=
  OK
[   16.559786] raid6test: test_disks(10, 11): faila=3D 10(P)  failb=3D 11(Q=
)  OK
[   16.561160] raid6test: testing the 24-disk case...
[   16.561930] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[   16.562952] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[   16.564006] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[   16.565056] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[   16.566065] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[   16.567152] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[   16.568206] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[   16.569218] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[   16.570261] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D) =
 OK
[   16.584351] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(D)=
  OK
[   16.585273] raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(D)=
  OK
[   16.586188] raid6test: test_disks(0, 12): faila=3D  0(D)  failb=3D 12(D)=
  OK
[   16.587241] raid6test: test_disks(0, 13): faila=3D  0(D)  failb=3D 13(D)=
  OK
[   16.588167] raid6test: test_disks(0, 14): faila=3D  0(D)  failb=3D 14(D)=
  OK
[   16.589081] raid6test: test_disks(0, 15): faila=3D  0(D)  failb=3D 15(D)=
  OK
[   16.589984] raid6test: test_disks(0, 16): faila=3D  0(D)  failb=3D 16(D)=
  OK
[   16.591040] raid6test: test_disks(0, 17): faila=3D  0(D)  failb=3D 17(D)=
  OK
[   16.592061] raid6test: test_disks(0, 18): faila=3D  0(D)  failb=3D 18(D)=
  OK
[   16.593084] raid6test: test_disks(0, 19): faila=3D  0(D)  failb=3D 19(D)=
  OK
[   16.594179] raid6test: test_disks(0, 20): faila=3D  0(D)  failb=3D 20(D)=
  OK
[   16.595210] raid6test: test_disks(0, 21): faila=3D  0(D)  failb=3D 21(D)=
  OK
[   16.596236] raid6test: test_disks(0, 22): faila=3D  0(D)  failb=3D 22(P)=
  OK
[   16.610519] raid6test: test_disks(0, 23): faila=3D  0(D)  failb=3D 23(Q)=
  OK
[   16.611575] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[   16.612603] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[   16.613658] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[   16.614696] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[   16.615726] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[   16.616779] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[   16.617802] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[   16.618829] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D) =
 OK
[   16.619854] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(D)=
  OK
[   16.620931] raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(D)=
  OK
[   16.621953] raid6test: test_disks(1, 12): faila=3D  1(D)  failb=3D 12(D)=
  OK
[   16.622986] raid6test: test_disks(1, 13): faila=3D  1(D)  failb=3D 13(D)=
  OK
[   16.637056] raid6test: test_disks(1, 14): faila=3D  1(D)  failb=3D 14(D)=
  OK
[   16.638083] raid6test: test_disks(1, 15): faila=3D  1(D)  failb=3D 15(D)=
  OK
[   16.639099] raid6test: test_disks(1, 16): faila=3D  1(D)  failb=3D 16(D)=
  OK
[   16.640129] raid6test: test_disks(1, 17): faila=3D  1(D)  failb=3D 17(D)=
  OK
[   16.641247] raid6test: test_disks(1, 18): faila=3D  1(D)  failb=3D 18(D)=
  OK
[   16.642266] raid6test: test_disks(1, 19): faila=3D  1(D)  failb=3D 19(D)=
  OK
[   16.652322] raid6test: test_disks(1, 20): faila=3D  1(D)  failb=3D 20(D)=
  OK
[   16.653406] raid6test: test_disks(1, 21): faila=3D  1(D)  failb=3D 21(D)=
  OK
[   16.654436] raid6test: test_disks(1, 22): faila=3D  1(D)  failb=3D 22(P)=
  OK
[   16.655453] raid6test: test_disks(1, 23): faila=3D  1(D)  failb=3D 23(Q)=
  OK
[   16.656502] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[   16.657592] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[   16.658612] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[   16.659627] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[   16.660709] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[   16.661755] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[   16.662771] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D) =
 OK
[   16.663842] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(D)=
  OK
[   16.664894] raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(D)=
  OK
[   16.674918] raid6test: test_disks(2, 12): faila=3D  2(D)  failb=3D 12(D)=
  OK
[   16.674918] raid6test: test_disks(2, 13): faila=3D  2(D)  failb=3D 13(D)=
  OK
[   16.674918] raid6test: test_disks(2, 14): faila=3D  2(D)  failb=3D 14(D)=
  OK
[   16.693632] raid6test: test_disks(2, 15): faila=3D  2(D)  failb=3D 15(D)=
  OK
[   16.694705] raid6test: test_disks(2, 16): faila=3D  2(D)  failb=3D 16(D)=
  OK
[   16.695741] raid6test: test_disks(2, 17): faila=3D  2(D)  failb=3D 17(D)=
  OK
[   16.727243] raid6test: test_disks(2, 18): faila=3D  2(D)  failb=3D 18(D)=
  OK
[   16.728310] raid6test: test_disks(2, 19): faila=3D  2(D)  failb=3D 19(D)=
  OK
[   16.729350] raid6test: test_disks(2, 20): faila=3D  2(D)  failb=3D 20(D)=
  OK
[   16.734852] raid6test: test_disks(2, 21): faila=3D  2(D)  failb=3D 21(D)=
  OK
[   16.735896] raid6test: test_disks(2, 22): faila=3D  2(D)  failb=3D 22(P)=
  OK
[   16.736957] raid6test: test_disks(2, 23): faila=3D  2(D)  failb=3D 23(Q)=
  OK
[   16.744346] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[   16.745379] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[   16.746407] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[   16.767094] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[   16.768116] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[   16.769119] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D) =
 OK
[   16.784249] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(D)=
  OK
[   16.785303] raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(D)=
  OK
[   16.786339] raid6test: test_disks(3, 12): faila=3D  3(D)  failb=3D 12(D)=
  OK
[   16.787411] raid6test: test_disks(3, 13): faila=3D  3(D)  failb=3D 13(D)=
  OK
[   16.788455] raid6test: test_disks(3, 14): faila=3D  3(D)  failb=3D 14(D)=
  OK
[   16.795147] raid6test: test_disks(3, 15): faila=3D  3(D)  failb=3D 15(D)=
  OK
[   16.796173] raid6test: test_disks(3, 16): faila=3D  3(D)  failb=3D 16(D)=
  OK
[   16.800369] raid6test: test_disks(3, 17): faila=3D  3(D)  failb=3D 17(D)=
  OK
[   16.802766] raid6test: test_disks(3, 18): faila=3D  3(D)  failb=3D 18(D)=
  OK
[   16.805561] raid6test: test_disks(3, 19): faila=3D  3(D)  failb=3D 19(D)=
  OK
[   16.806623] raid6test: test_disks(3, 20): faila=3D  3(D)  failb=3D 20(D)=
  OK
[   16.826205] raid6test: test_disks(3, 21): faila=3D  3(D)  failb=3D 21(D)=
  OK
[   16.841191] raid6test: test_disks(3, 22): faila=3D  3(D)  failb=3D 22(P)=
  OK
[   16.842126] raid6test: test_disks(3, 23): faila=3D  3(D)  failb=3D 23(Q)=
  OK
[   16.843051] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[   16.844069] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[   16.845081] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[   16.846138] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[   16.847238] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D) =
 OK
[   16.848262] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(D)=
  OK
[   16.849281] raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(D)=
  OK
[   16.862588] raid6test: test_disks(4, 12): faila=3D  4(D)  failb=3D 12(D)=
  OK
[   16.865155] raid6test: test_disks(4, 13): faila=3D  4(D)  failb=3D 13(D)=
  OK
[   16.866235] raid6test: test_disks(4, 14): faila=3D  4(D)  failb=3D 14(D)=
  OK
[   16.867881] raid6test: test_disks(4, 15): faila=3D  4(D)  failb=3D 15(D)=
  OK
[   16.870123] raid6test: test_disks(4, 16): faila=3D  4(D)  failb=3D 16(D)=
  OK
[   16.871702] raid6test: test_disks(4, 17): faila=3D  4(D)  failb=3D 17(D)=
  OK
[   16.872783] raid6test: test_disks(4, 18): faila=3D  4(D)  failb=3D 18(D)=
  OK
[   16.873668] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[   16.875910] raid6test: test_disks(4, 19): faila=3D  4(D)  failb=3D 19(D)=
  OK
[   16.880457] raid6test: test_disks(4, 20): faila=3D  4(D)  failb=3D 20(D)=
  OK
[   16.881607] raid6test: test_disks(4, 21): faila=3D  4(D)  failb=3D 21(D)=
  OK
[   16.882645] raid6test: test_disks(4, 22): faila=3D  4(D)  failb=3D 22(P)=
  OK
[   16.903974] raid6test: test_disks(4, 23): faila=3D  4(D)  failb=3D 23(Q)=
  OK
[   16.905031] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[   16.906074] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[   16.907131] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[   16.908184] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D) =
 OK
[   16.909216] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(D)=
  OK
[   16.910284] raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(D)=
  OK
[   16.911357] raid6test: test_disks(5, 12): faila=3D  5(D)  failb=3D 12(D)=
  OK
[   16.924854] raid6test: test_disks(5, 13): faila=3D  5(D)  failb=3D 13(D)=
  OK
[   16.925923] raid6test: test_disks(5, 14): faila=3D  5(D)  failb=3D 14(D)=
  OK
[   16.927055] raid6test: test_disks(5, 15): faila=3D  5(D)  failb=3D 15(D)=
  OK
[   16.928093] raid6test: test_disks(5, 16): faila=3D  5(D)  failb=3D 16(D)=
  OK
[   16.929125] raid6test: test_disks(5, 17): faila=3D  5(D)  failb=3D 17(D)=
  OK
[   16.930183] raid6test: test_disks(5, 18): faila=3D  5(D)  failb=3D 18(D)=
  OK
[   16.936866] raid6test: test_disks(5, 19): faila=3D  5(D)  failb=3D 19(D)=
  OK
[   16.937972] raid6test: test_disks(5, 20): faila=3D  5(D)  failb=3D 20(D)=
  OK
[   16.939020] raid6test: test_disks(5, 21): faila=3D  5(D)  failb=3D 21(D)=
  OK
[   16.940079] raid6test: test_disks(5, 22): faila=3D  5(D)  failb=3D 22(P)=
  OK
[   16.964137] raid6test: test_disks(5, 23): faila=3D  5(D)  failb=3D 23(Q)=
  OK
[   16.965168] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[   16.966175] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[   16.967295] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D) =
 OK
[   16.968305] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(D)=
  OK
[   16.969322] raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(D)=
  OK
[   16.970362] raid6test: test_disks(6, 12): faila=3D  6(D)  failb=3D 12(D)=
  OK
[   16.971425] raid6test: test_disks(6, 13): faila=3D  6(D)  failb=3D 13(D)=
  OK
[   16.972460] raid6test: test_disks(6, 14): faila=3D  6(D)  failb=3D 14(D)=
  OK
[   16.980353] raid6test: test_disks(6, 15): faila=3D  6(D)  failb=3D 15(D)=
  OK
[   16.981435] raid6test: test_disks(6, 16): faila=3D  6(D)  failb=3D 16(D)=
  OK
[   16.982473] raid6test: test_disks(6, 17): faila=3D  6(D)  failb=3D 17(D)=
  OK
[   16.983629] raid6test: test_disks(6, 18): faila=3D  6(D)  failb=3D 18(D)=
  OK
[   16.984681] raid6test: test_disks(6, 19): faila=3D  6(D)  failb=3D 19(D)=
  OK
[   16.985695] raid6test: test_disks(6, 20): faila=3D  6(D)  failb=3D 20(D)=
  OK
[   16.986733] raid6test: test_disks(6, 21): faila=3D  6(D)  failb=3D 21(D)=
  OK
[   16.991306] raid6test: test_disks(6, 22): faila=3D  6(D)  failb=3D 22(P)=
  OK
[   16.992343] raid6test: test_disks(6, 23): faila=3D  6(D)  failb=3D 23(Q)=
  OK
[   17.000340] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[   17.001396] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D) =
 OK
[   17.002424] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(D)=
  OK
[   17.003585] raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(D)=
  OK
[   17.004638] raid6test: test_disks(7, 12): faila=3D  7(D)  failb=3D 12(D)=
  OK
[   17.005676] raid6test: test_disks(7, 13): faila=3D  7(D)  failb=3D 13(D)=
  OK
[   17.006742] raid6test: test_disks(7, 14): faila=3D  7(D)  failb=3D 14(D)=
  OK
[   17.007829] raid6test: test_disks(7, 15): faila=3D  7(D)  failb=3D 15(D)=
  OK
[   17.008844] raid6test: test_disks(7, 16): faila=3D  7(D)  failb=3D 16(D)=
  OK
[   17.009865] raid6test: test_disks(7, 17): faila=3D  7(D)  failb=3D 17(D)=
  OK
[   17.010911] raid6test: test_disks(7, 18): faila=3D  7(D)  failb=3D 18(D)=
  OK
[   17.011934] raid6test: test_disks(7, 19): faila=3D  7(D)  failb=3D 19(D)=
  OK
[   17.012950] raid6test: test_disks(7, 20): faila=3D  7(D)  failb=3D 20(D)=
  OK
[   17.024269] raid6test: test_disks(7, 21): faila=3D  7(D)  failb=3D 21(D)=
  OK
[   17.025310] raid6test: test_disks(7, 22): faila=3D  7(D)  failb=3D 22(P)=
  OK
[   17.026342] raid6test: test_disks(7, 23): faila=3D  7(D)  failb=3D 23(Q)=
  OK
[   17.027425] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D) =
 OK
[   17.028502] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(D)=
  OK
[   17.029572] raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(D)=
  OK
[   17.030649] raid6test: test_disks(8, 12): faila=3D  8(D)  failb=3D 12(D)=
  OK
[   17.031693] raid6test: test_disks(8, 13): faila=3D  8(D)  failb=3D 13(D)=
  OK
[   17.032745] raid6test: test_disks(8, 14): faila=3D  8(D)  failb=3D 14(D)=
  OK
[   17.044058] raid6test: test_disks(8, 15): faila=3D  8(D)  failb=3D 15(D)=
  OK
[   17.045084] raid6test: test_disks(8, 16): faila=3D  8(D)  failb=3D 16(D)=
  OK
[   17.046089] raid6test: test_disks(8, 17): faila=3D  8(D)  failb=3D 17(D)=
  OK
[   17.050602] raid6test: test_disks(8, 18): faila=3D  8(D)  failb=3D 18(D)=
  OK
[   17.051636] raid6test: test_disks(8, 19): faila=3D  8(D)  failb=3D 19(D)=
  OK
[   17.052643] raid6test: test_disks(8, 20): faila=3D  8(D)  failb=3D 20(D)=
  OK
[   17.063975] raid6test: test_disks(8, 21): faila=3D  8(D)  failb=3D 21(D)=
  OK
[   17.065032] raid6test: test_disks(8, 22): faila=3D  8(D)  failb=3D 22(P)=
  OK
[   17.066063] raid6test: test_disks(8, 23): faila=3D  8(D)  failb=3D 23(Q)=
  OK
[   17.067250] raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(D)=
  OK
[   17.068309] raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(D)=
  OK
[   17.069347] raid6test: test_disks(9, 12): faila=3D  9(D)  failb=3D 12(D)=
  OK
[   17.070400] raid6test: test_disks(9, 13): faila=3D  9(D)  failb=3D 13(D)=
  OK
[   17.071460] raid6test: test_disks(9, 14): faila=3D  9(D)  failb=3D 14(D)=
  OK
[   17.072494] raid6test: test_disks(9, 15): faila=3D  9(D)  failb=3D 15(D)=
  OK
[   17.080377] raid6test: test_disks(9, 16): faila=3D  9(D)  failb=3D 16(D)=
  OK
[   17.081416] raid6test: test_disks(9, 17): faila=3D  9(D)  failb=3D 17(D)=
  OK
[   17.082430] raid6test: test_disks(9, 18): faila=3D  9(D)  failb=3D 18(D)=
  OK
[   17.083608] raid6test: test_disks(9, 19): faila=3D  9(D)  failb=3D 19(D)=
  OK
[   17.084630] raid6test: test_disks(9, 20): faila=3D  9(D)  failb=3D 20(D)=
  OK
[   17.085647] raid6test: test_disks(9, 21): faila=3D  9(D)  failb=3D 21(D)=
  OK
[   17.086661] raid6test: test_disks(9, 22): faila=3D  9(D)  failb=3D 22(P)=
  OK
[   17.087758] raid6test: test_disks(9, 23): faila=3D  9(D)  failb=3D 23(Q)=
  OK
[   17.088820] raid6test: test_disks(10, 11): faila=3D 10(D)  failb=3D 11(D=
)  OK
[   17.089902] raid6test: test_disks(10, 12): faila=3D 10(D)  failb=3D 12(D=
)  OK
[   17.091055] raid6test: test_disks(10, 13): faila=3D 10(D)  failb=3D 13(D=
)  OK
[   17.092095] raid6test: test_disks(10, 14): faila=3D 10(D)  failb=3D 14(D=
)  OK
[   17.093124] raid6test: test_disks(10, 15): faila=3D 10(D)  failb=3D 15(D=
)  OK
[   17.104451] raid6test: test_disks(10, 16): faila=3D 10(D)  failb=3D 16(D=
)  OK
[   17.105512] raid6test: test_disks(10, 17): faila=3D 10(D)  failb=3D 17(D=
)  OK
[   17.106571] raid6test: test_disks(10, 18): faila=3D 10(D)  failb=3D 18(D=
)  OK
[   17.107679] raid6test: test_disks(10, 19): faila=3D 10(D)  failb=3D 19(D=
)  OK
[   17.108726] raid6test: test_disks(10, 20): faila=3D 10(D)  failb=3D 20(D=
)  OK
[   17.109752] raid6test: test_disks(10, 21): faila=3D 10(D)  failb=3D 21(D=
)  OK
[   17.110796] raid6test: test_disks(10, 22): faila=3D 10(D)  failb=3D 22(P=
)  OK
[   17.111837] raid6test: test_disks(10, 23): faila=3D 10(D)  failb=3D 23(Q=
)  OK
[   17.112884] raid6test: test_disks(11, 12): faila=3D 11(D)  failb=3D 12(D=
)  OK
[   17.124183] raid6test: test_disks(11, 13): faila=3D 11(D)  failb=3D 13(D=
)  OK
[   17.125247] raid6test: test_disks(11, 14): faila=3D 11(D)  failb=3D 14(D=
)  OK
[   17.126303] raid6test: test_disks(11, 15): faila=3D 11(D)  failb=3D 15(D=
)  OK
[   17.127444] raid6test: test_disks(11, 16): faila=3D 11(D)  failb=3D 16(D=
)  OK
[   17.128502] raid6test: test_disks(11, 17): faila=3D 11(D)  failb=3D 17(D=
)  OK
[   17.129556] raid6test: test_disks(11, 18): faila=3D 11(D)  failb=3D 18(D=
)  OK
[   17.130670] raid6test: test_disks(11, 19): faila=3D 11(D)  failb=3D 19(D=
)  OK
[   17.131736] raid6test: test_disks(11, 20): faila=3D 11(D)  failb=3D 20(D=
)  OK
[   17.132790] raid6test: test_disks(11, 21): faila=3D 11(D)  failb=3D 21(D=
)  OK
[   17.144053] raid6test: test_disks(11, 22): faila=3D 11(D)  failb=3D 22(P=
)  OK
[   17.144969] raid6test: test_disks(11, 23): faila=3D 11(D)  failb=3D 23(Q=
)  OK
[   17.145894] raid6test: test_disks(12, 13): faila=3D 12(D)  failb=3D 13(D=
)  OK
[   17.150321] raid6test: test_disks(12, 14): faila=3D 12(D)  failb=3D 14(D=
)  OK
[   17.151377] raid6test: test_disks(12, 15): faila=3D 12(D)  failb=3D 15(D=
)  OK
[   17.152405] raid6test: test_disks(12, 16): faila=3D 12(D)  failb=3D 16(D=
)  OK
[   17.163717] raid6test: test_disks(12, 17): faila=3D 12(D)  failb=3D 17(D=
)  OK
[   17.164809] raid6test: test_disks(12, 18): faila=3D 12(D)  failb=3D 18(D=
)  OK
[   17.165878] raid6test: test_disks(12, 19): faila=3D 12(D)  failb=3D 19(D=
)  OK
[   17.167127] raid6test: test_disks(12, 20): faila=3D 12(D)  failb=3D 20(D=
)  OK
[   17.168197] raid6test: test_disks(12, 21): faila=3D 12(D)  failb=3D 21(D=
)  OK
[   17.169225] raid6test: test_disks(12, 22): faila=3D 12(D)  failb=3D 22(P=
)  OK
[   17.170291] raid6test: test_disks(12, 23): faila=3D 12(D)  failb=3D 23(Q=
)  OK
[   17.171343] raid6test: test_disks(13, 14): faila=3D 13(D)  failb=3D 14(D=
)  OK
[   17.172382] raid6test: test_disks(13, 15): faila=3D 13(D)  failb=3D 15(D=
)  OK
[   17.180300] raid6test: test_disks(13, 16): faila=3D 13(D)  failb=3D 16(D=
)  OK
[   17.181236] raid6test: test_disks(13, 17): faila=3D 13(D)  failb=3D 17(D=
)  OK
[   17.182162] raid6test: test_disks(13, 18): faila=3D 13(D)  failb=3D 18(D=
)  OK
[   17.183083] raid6test: test_disks(13, 19): faila=3D 13(D)  failb=3D 19(D=
)  OK
[   17.184167] raid6test: test_disks(13, 20): faila=3D 13(D)  failb=3D 20(D=
)  OK
[   17.185093] raid6test: test_disks(13, 21): faila=3D 13(D)  failb=3D 21(D=
)  OK
[   17.186062] raid6test: test_disks(13, 22): faila=3D 13(D)  failb=3D 22(P=
)  OK
[   17.186987] raid6test: test_disks(13, 23): faila=3D 13(D)  failb=3D 23(Q=
)  OK
[   17.187916] raid6test: test_disks(14, 15): faila=3D 14(D)  failb=3D 15(D=
)  OK
[   17.188839] raid6test: test_disks(14, 16): faila=3D 14(D)  failb=3D 16(D=
)  OK
[   17.189763] raid6test: test_disks(14, 17): faila=3D 14(D)  failb=3D 17(D=
)  OK
[   17.190756] raid6test: test_disks(14, 18): faila=3D 14(D)  failb=3D 18(D=
)  OK
[   17.191799] raid6test: test_disks(14, 19): faila=3D 14(D)  failb=3D 19(D=
)  OK
[   17.192823] raid6test: test_disks(14, 20): faila=3D 14(D)  failb=3D 20(D=
)  OK
[   17.204145] raid6test: test_disks(14, 21): faila=3D 14(D)  failb=3D 21(D=
)  OK
[   17.205202] raid6test: test_disks(14, 22): faila=3D 14(D)  failb=3D 22(P=
)  OK
[   17.206251] raid6test: test_disks(14, 23): faila=3D 14(D)  failb=3D 23(Q=
)  OK
[   17.207358] raid6test: test_disks(15, 16): faila=3D 15(D)  failb=3D 16(D=
)  OK
[   17.208396] raid6test: test_disks(15, 17): faila=3D 15(D)  failb=3D 17(D=
)  OK
[   17.209462] raid6test: test_disks(15, 18): faila=3D 15(D)  failb=3D 18(D=
)  OK
[   17.210543] raid6test: test_disks(15, 19): faila=3D 15(D)  failb=3D 19(D=
)  OK
[   17.211589] raid6test: test_disks(15, 20): faila=3D 15(D)  failb=3D 20(D=
)  OK
[   17.212632] raid6test: test_disks(15, 21): faila=3D 15(D)  failb=3D 21(D=
)  OK
[   17.223908] raid6test: test_disks(15, 22): faila=3D 15(D)  failb=3D 22(P=
)  OK
[   17.224974] raid6test: test_disks(15, 23): faila=3D 15(D)  failb=3D 23(Q=
)  OK
[   17.226032] raid6test: test_disks(16, 17): faila=3D 16(D)  failb=3D 17(D=
)  OK
[   17.227114] raid6test: test_disks(16, 18): faila=3D 16(D)  failb=3D 18(D=
)  OK
[   17.228182] raid6test: test_disks(16, 19): faila=3D 16(D)  failb=3D 19(D=
)  OK
[   17.229233] raid6test: test_disks(16, 20): faila=3D 16(D)  failb=3D 20(D=
)  OK
[   17.230305] raid6test: test_disks(16, 21): faila=3D 16(D)  failb=3D 21(D=
)  OK
[   17.231379] raid6test: test_disks(16, 22): faila=3D 16(D)  failb=3D 22(P=
)  OK
[   17.232421] raid6test: test_disks(16, 23): faila=3D 16(D)  failb=3D 23(Q=
)  OK
[   17.243728] raid6test: test_disks(17, 18): faila=3D 17(D)  failb=3D 18(D=
)  OK
[   17.244678] raid6test: test_disks(17, 19): faila=3D 17(D)  failb=3D 19(D=
)  OK
[   17.245619] raid6test: test_disks(17, 20): faila=3D 17(D)  failb=3D 20(D=
)  OK
[   17.246566] raid6test: test_disks(17, 21): faila=3D 17(D)  failb=3D 21(D=
)  OK
[   17.251109] raid6test: test_disks(17, 22): faila=3D 17(D)  failb=3D 22(P=
)  OK
[   17.252142] raid6test: test_disks(17, 23): faila=3D 17(D)  failb=3D 23(Q=
)  OK
[   17.253173] raid6test: test_disks(18, 19): faila=3D 18(D)  failb=3D 19(D=
)  OK
[   17.257779] raid6test: test_disks(18, 20): faila=3D 18(D)  failb=3D 20(D=
)  OK
[   17.258854] raid6test: test_disks(18, 21): faila=3D 18(D)  failb=3D 21(D=
)  OK
[   17.259894] raid6test: test_disks(18, 22): faila=3D 18(D)  failb=3D 22(P=
)  OK
[   17.260988] raid6test: test_disks(18, 23): faila=3D 18(D)  failb=3D 23(Q=
)  OK
[   17.262036] raid6test: test_disks(19, 20): faila=3D 19(D)  failb=3D 20(D=
)  OK
[   17.263072] raid6test: test_disks(19, 21): faila=3D 19(D)  failb=3D 21(D=
)  OK
[   17.274407] raid6test: test_disks(19, 22): faila=3D 19(D)  failb=3D 22(P=
)  OK
[   17.275462] raid6test: test_disks(19, 23): faila=3D 19(D)  failb=3D 23(Q=
)  OK
[   17.276536] raid6test: test_disks(20, 21): faila=3D 20(D)  failb=3D 21(D=
)  OK
[   17.277628] raid6test: test_disks(20, 22): faila=3D 20(D)  failb=3D 22(P=
)  OK
[   17.278694] raid6test: test_disks(20, 23): faila=3D 20(D)  failb=3D 23(Q=
)  OK
[   17.279741] raid6test: test_disks(21, 22): faila=3D 21(D)  failb=3D 22(P=
)  OK
[   17.294315] raid6test: test_disks(21, 23): faila=3D 21(D)  failb=3D 23(Q=
)  OK
[   17.295227] raid6test: test_disks(22, 23): faila=3D 22(P)  failb=3D 23(Q=
)  OK
[   17.296968] raid6test: testing the 64-disk case...
[   17.297767] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[   17.298831] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[   17.299888] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[   17.301121] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[   17.302212] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[   17.303269] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[   17.304546] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[   17.305660] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[   17.306770] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D) =
 OK
[   17.307883] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(D)=
  OK
[   17.308963] raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(D)=
  OK
[   17.318112] raid6test: test_disks(0, 12): faila=3D  0(D)  failb=3D 12(D)=
  OK
[   17.319282] raid6test: test_disks(0, 13): faila=3D  0(D)  failb=3D 13(D)=
  OK
[   17.320408] raid6test: test_disks(0, 14): faila=3D  0(D)  failb=3D 14(D)=
  OK
[   17.326094] raid6test: test_disks(0, 15): faila=3D  0(D)  failb=3D 15(D)=
  OK
[   17.327505] raid6test: test_disks(0, 16): faila=3D  0(D)  failb=3D 16(D)=
  OK
[   17.334884] raid6test: test_disks(0, 17): faila=3D  0(D)  failb=3D 17(D)=
  OK
[   17.336204] raid6test: test_disks(0, 18): faila=3D  0(D)  failb=3D 18(D)=
  OK
[   17.337631] raid6test: test_disks(0, 19): faila=3D  0(D)  failb=3D 19(D)=
  OK
[   17.338958] raid6test: test_disks(0, 20): faila=3D  0(D)  failb=3D 20(D)=
  OK
[   17.344780] raid6test: test_disks(0, 21): faila=3D  0(D)  failb=3D 21(D)=
  OK
[   17.345897] raid6test: test_disks(0, 22): faila=3D  0(D)  failb=3D 22(D)=
  OK
[   17.347182] raid6test: test_disks(0, 23): faila=3D  0(D)  failb=3D 23(D)=
  OK
[   17.348304] raid6test: test_disks(0, 24): faila=3D  0(D)  failb=3D 24(D)=
  OK
[   17.349413] raid6test: test_disks(0, 25): faila=3D  0(D)  failb=3D 25(D)=
  OK
[   17.354700] raid6test: test_disks(0, 26): faila=3D  0(D)  failb=3D 26(D)=
  OK
[   17.356396] raid6test: test_disks(0, 27): faila=3D  0(D)  failb=3D 27(D)=
  OK
[   17.363787] raid6test: test_disks(0, 28): faila=3D  0(D)  failb=3D 28(D)=
  OK
[   17.365158] raid6test: test_disks(0, 29): faila=3D  0(D)  failb=3D 29(D)=
  OK
[   17.366464] raid6test: test_disks(0, 30): faila=3D  0(D)  failb=3D 30(D)=
  OK
[   17.367914] raid6test: test_disks(0, 31): faila=3D  0(D)  failb=3D 31(D)=
  OK
[   17.372469] raid6test: test_disks(0, 32): faila=3D  0(D)  failb=3D 32(D)=
  OK
[   17.373818] raid6test: test_disks(0, 33): faila=3D  0(D)  failb=3D 33(D)=
  OK
[   17.377170] raid6test: test_disks(0, 34): faila=3D  0(D)  failb=3D 34(D)=
  OK
[   17.378594] raid6test: test_disks(0, 35): faila=3D  0(D)  failb=3D 35(D)=
  OK
[   17.380580] raid6test: test_disks(0, 36): faila=3D  0(D)  failb=3D 36(D)=
  OK
[   17.381675] raid6test: test_disks(0, 37): faila=3D  0(D)  failb=3D 37(D)=
  OK
[   17.382775] raid6test: test_disks(0, 38): faila=3D  0(D)  failb=3D 38(D)=
  OK
[   17.388858] raid6test: test_disks(0, 39): faila=3D  0(D)  failb=3D 39(D)=
  OK
[   17.390211] raid6test: test_disks(0, 40): faila=3D  0(D)  failb=3D 40(D)=
  OK
[   17.394581] raid6test: test_disks(0, 41): faila=3D  0(D)  failb=3D 41(D)=
  OK
[   17.395945] raid6test: test_disks(0, 42): faila=3D  0(D)  failb=3D 42(D)=
  OK
[   17.401532] raid6test: test_disks(0, 43): faila=3D  0(D)  failb=3D 43(D)=
  OK
[   17.402850] raid6test: test_disks(0, 44): faila=3D  0(D)  failb=3D 44(D)=
  OK
[   17.404318] raid6test: test_disks(0, 45): faila=3D  0(D)  failb=3D 45(D)=
  OK
[   17.405442] raid6test: test_disks(0, 46): faila=3D  0(D)  failb=3D 46(D)=
  OK
[   17.406549] raid6test: test_disks(0, 47): faila=3D  0(D)  failb=3D 47(D)=
  OK
[   17.407718] raid6test: test_disks(0, 48): faila=3D  0(D)  failb=3D 48(D)=
  OK
[   17.414311] raid6test: test_disks(0, 49): faila=3D  0(D)  failb=3D 49(D)=
  OK
[   17.417981] raid6test: test_disks(0, 50): faila=3D  0(D)  failb=3D 50(D)=
  OK
[   17.419090] raid6test: test_disks(0, 51): faila=3D  0(D)  failb=3D 51(D)=
  OK
[   17.420236] raid6test: test_disks(0, 52): faila=3D  0(D)  failb=3D 52(D)=
  OK
[   17.424819] raid6test: test_disks(0, 53): faila=3D  0(D)  failb=3D 53(D)=
  OK
[   17.428748] raid6test: test_disks(0, 54): faila=3D  0(D)  failb=3D 54(D)=
  OK
[   17.429859] raid6test: test_disks(0, 55): faila=3D  0(D)  failb=3D 55(D)=
  OK
[   17.431019] raid6test: test_disks(0, 56): faila=3D  0(D)  failb=3D 56(D)=
  OK
[   17.437850] raid6test: test_disks(0, 57): faila=3D  0(D)  failb=3D 57(D)=
  OK
[   17.439182] raid6test: test_disks(0, 58): faila=3D  0(D)  failb=3D 58(D)=
  OK
[   17.440506] raid6test: test_disks(0, 59): faila=3D  0(D)  failb=3D 59(D)=
  OK
[   17.441643] raid6test: test_disks(0, 60): faila=3D  0(D)  failb=3D 60(D)=
  OK
[   17.442760] raid6test: test_disks(0, 61): faila=3D  0(D)  failb=3D 61(D)=
  OK
[   17.450746] raid6test: test_disks(0, 62): faila=3D  0(D)  failb=3D 62(P)=
  OK
[   17.452068] raid6test: test_disks(0, 63): faila=3D  0(D)  failb=3D 63(Q)=
  OK
[   17.454733] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[   17.455838] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[   17.456947] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[   17.460945] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[   17.464535] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[   17.465624] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[   17.468596] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[   17.472314] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D) =
 OK
[   17.473989] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(D)=
  OK
[   17.480710] raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(D)=
  OK
[   17.481920] raid6test: test_disks(1, 12): faila=3D  1(D)  failb=3D 12(D)=
  OK
[   17.483026] raid6test: test_disks(1, 13): faila=3D  1(D)  failb=3D 13(D)=
  OK
[   17.484316] raid6test: test_disks(1, 14): faila=3D  1(D)  failb=3D 14(D)=
  OK
[   17.485433] raid6test: test_disks(1, 15): faila=3D  1(D)  failb=3D 15(D)=
  OK
[   17.486535] raid6test: test_disks(1, 16): faila=3D  1(D)  failb=3D 16(D)=
  OK
[   17.487712] raid6test: test_disks(1, 17): faila=3D  1(D)  failb=3D 17(D)=
  OK
[   17.494540] raid6test: test_disks(1, 18): faila=3D  1(D)  failb=3D 18(D)=
  OK
[   17.497634] raid6test: test_disks(1, 19): faila=3D  1(D)  failb=3D 19(D)=
  OK
[   17.500687] raid6test: test_disks(1, 20): faila=3D  1(D)  failb=3D 20(D)=
  OK
[   17.501794] raid6test: test_disks(1, 21): faila=3D  1(D)  failb=3D 21(D)=
  OK
[   17.502913] raid6test: test_disks(1, 22): faila=3D  1(D)  failb=3D 22(D)=
  OK
[   17.510865] raid6test: test_disks(1, 23): faila=3D  1(D)  failb=3D 23(D)=
  OK
[   17.511865] raid6test: test_disks(1, 24): faila=3D  1(D)  failb=3D 24(D)=
  OK
[   17.512974] raid6test: test_disks(1, 25): faila=3D  1(D)  failb=3D 25(D)=
  OK
[   17.514148] raid6test: test_disks(1, 26): faila=3D  1(D)  failb=3D 26(D)=
  OK
[   17.515113] raid6test: test_disks(1, 27): faila=3D  1(D)  failb=3D 27(D)=
  OK
[   17.516072] raid6test: test_disks(1, 28): faila=3D  1(D)  failb=3D 28(D)=
  OK
[   17.523306] raid6test: test_disks(1, 29): faila=3D  1(D)  failb=3D 29(D)=
  OK
[   17.524551] raid6test: test_disks(1, 30): faila=3D  1(D)  failb=3D 30(D)=
  OK
[   17.525634] raid6test: test_disks(1, 31): faila=3D  1(D)  failb=3D 31(D)=
  OK
[   17.526743] raid6test: test_disks(1, 32): faila=3D  1(D)  failb=3D 32(D)=
  OK
[   17.527829] raid6test: test_disks(1, 33): faila=3D  1(D)  failb=3D 33(D)=
  OK
[   17.528915] raid6test: test_disks(1, 34): faila=3D  1(D)  failb=3D 34(D)=
  OK
[   17.530104] raid6test: test_disks(1, 35): faila=3D  1(D)  failb=3D 35(D)=
  OK
[   17.531274] raid6test: test_disks(1, 36): faila=3D  1(D)  failb=3D 36(D)=
  OK
[   17.532381] raid6test: test_disks(1, 37): faila=3D  1(D)  failb=3D 37(D)=
  OK
[   17.543593] raid6test: test_disks(1, 38): faila=3D  1(D)  failb=3D 38(D)=
  OK
[   17.544692] raid6test: test_disks(1, 39): faila=3D  1(D)  failb=3D 39(D)=
  OK
[   17.545804] raid6test: test_disks(1, 40): faila=3D  1(D)  failb=3D 40(D)=
  OK
[   17.563371] raid6test: test_disks(1, 41): faila=3D  1(D)  failb=3D 41(D)=
  OK
[   17.564364] raid6test: test_disks(1, 42): faila=3D  1(D)  failb=3D 42(D)=
  OK
[   17.565329] raid6test: test_disks(1, 43): faila=3D  1(D)  failb=3D 43(D)=
  OK
[   17.566295] raid6test: test_disks(1, 44): faila=3D  1(D)  failb=3D 44(D)=
  OK
[   17.571711] raid6test: test_disks(1, 45): faila=3D  1(D)  failb=3D 45(D)=
  OK
[   17.572791] raid6test: test_disks(1, 46): faila=3D  1(D)  failb=3D 46(D)=
  OK
[   17.577072] raid6test: test_disks(1, 47): faila=3D  1(D)  failb=3D 47(D)=
  OK
[   17.577216] raid6test: test_disks(1, 48): faila=3D  1(D)  failb=3D 48(D)=
  OK
[   17.577216] raid6test: test_disks(1, 49): faila=3D  1(D)  failb=3D 49(D)=
  OK
[   17.584021] raid6test: test_disks(1, 50): faila=3D  1(D)  failb=3D 50(D)=
  OK
[   17.585148] raid6test: test_disks(1, 51): faila=3D  1(D)  failb=3D 51(D)=
  OK
[   17.586270] raid6test: test_disks(1, 52): faila=3D  1(D)  failb=3D 52(D)=
  OK
[   17.594210] raid6test: test_disks(1, 53): faila=3D  1(D)  failb=3D 53(D)=
  OK
[   17.595311] raid6test: test_disks(1, 54): faila=3D  1(D)  failb=3D 54(D)=
  OK
[   17.596416] raid6test: test_disks(1, 55): faila=3D  1(D)  failb=3D 55(D)=
  OK
[   17.597721] raid6test: test_disks(1, 56): faila=3D  1(D)  failb=3D 56(D)=
  OK
[   17.598805] raid6test: test_disks(1, 57): faila=3D  1(D)  failb=3D 57(D)=
  OK
[   17.599889] raid6test: test_disks(1, 58): faila=3D  1(D)  failb=3D 58(D)=
  OK
[   17.617102] raid6test: test_disks(1, 59): faila=3D  1(D)  failb=3D 59(D)=
  OK
[   17.618237] raid6test: test_disks(1, 60): faila=3D  1(D)  failb=3D 60(D)=
  OK
[   17.619349] raid6test: test_disks(1, 61): faila=3D  1(D)  failb=3D 61(D)=
  OK
[   17.627394] raid6test: test_disks(1, 62): faila=3D  1(D)  failb=3D 62(P)=
  OK
[   17.628489] raid6test: test_disks(1, 63): faila=3D  1(D)  failb=3D 63(Q)=
  OK
[   17.629564] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[   17.631050] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[   17.632157] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[   17.633242] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[   17.637776] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[   17.638897] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[   17.639989] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D) =
 OK
[   17.663328] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(D)=
  OK
[   17.664618] raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(D)=
  OK
[   17.665597] raid6test: test_disks(2, 12): faila=3D  2(D)  failb=3D 12(D)=
  OK
[   17.666557] raid6test: test_disks(2, 13): faila=3D  2(D)  failb=3D 13(D)=
  OK
[   17.667552] raid6test: test_disks(2, 14): faila=3D  2(D)  failb=3D 14(D)=
  OK
[   17.668517] raid6test: test_disks(2, 15): faila=3D  2(D)  failb=3D 15(D)=
  OK
[   17.669481] raid6test: test_disks(2, 16): faila=3D  2(D)  failb=3D 16(D)=
  OK
[   17.677291] raid6test: test_disks(2, 17): faila=3D  2(D)  failb=3D 17(D)=
  OK
[   17.678286] raid6test: test_disks(2, 18): faila=3D  2(D)  failb=3D 18(D)=
  OK
[   17.679260] raid6test: test_disks(2, 19): faila=3D  2(D)  failb=3D 19(D)=
  OK
[   17.680263] raid6test: test_disks(2, 20): faila=3D  2(D)  failb=3D 20(D)=
  OK
[   17.681310] raid6test: test_disks(2, 21): faila=3D  2(D)  failb=3D 21(D)=
  OK
[   17.687356] raid6test: test_disks(2, 22): faila=3D  2(D)  failb=3D 22(D)=
  OK
[   17.688469] raid6test: test_disks(2, 23): faila=3D  2(D)  failb=3D 23(D)=
  OK
[   17.689580] raid6test: test_disks(2, 24): faila=3D  2(D)  failb=3D 24(D)=
  OK
[   17.690719] raid6test: test_disks(2, 25): faila=3D  2(D)  failb=3D 25(D)=
  OK
[   17.691826] raid6test: test_disks(2, 26): faila=3D  2(D)  failb=3D 26(D)=
  OK
[   17.692934] raid6test: test_disks(2, 27): faila=3D  2(D)  failb=3D 27(D)=
  OK
[   17.704384] raid6test: test_disks(2, 28): faila=3D  2(D)  failb=3D 28(D)=
  OK
[   17.705501] raid6test: test_disks(2, 29): faila=3D  2(D)  failb=3D 29(D)=
  OK
[   17.706599] raid6test: test_disks(2, 30): faila=3D  2(D)  failb=3D 30(D)=
  OK
[   17.707831] raid6test: test_disks(2, 31): faila=3D  2(D)  failb=3D 31(D)=
  OK
[   17.708939] raid6test: test_disks(2, 32): faila=3D  2(D)  failb=3D 32(D)=
  OK
[   17.710048] raid6test: test_disks(2, 33): faila=3D  2(D)  failb=3D 33(D)=
  OK
[   17.711140] raid6test: test_disks(2, 34): faila=3D  2(D)  failb=3D 34(D)=
  OK
[   17.712260] raid6test: test_disks(2, 35): faila=3D  2(D)  failb=3D 35(D)=
  OK
[   17.733629] raid6test: test_disks(2, 36): faila=3D  2(D)  failb=3D 36(D)=
  OK
[   17.734746] raid6test: test_disks(2, 37): faila=3D  2(D)  failb=3D 37(D)=
  OK
[   17.735821] raid6test: test_disks(2, 38): faila=3D  2(D)  failb=3D 38(D)=
  OK
[   17.736937] raid6test: test_disks(2, 39): faila=3D  2(D)  failb=3D 39(D)=
  OK
[   17.738034] raid6test: test_disks(2, 40): faila=3D  2(D)  failb=3D 40(D)=
  OK
[   17.739114] raid6test: test_disks(2, 41): faila=3D  2(D)  failb=3D 41(D)=
  OK
[   17.753855] raid6test: test_disks(2, 42): faila=3D  2(D)  failb=3D 42(D)=
  OK
[   17.754998] raid6test: test_disks(2, 43): faila=3D  2(D)  failb=3D 43(D)=
  OK
[   17.756105] raid6test: test_disks(2, 44): faila=3D  2(D)  failb=3D 44(D)=
  OK
[   17.772273] raid6test: test_disks(2, 45): faila=3D  2(D)  failb=3D 45(D)=
  OK
[   17.773264] raid6test: test_disks(2, 46): faila=3D  2(D)  failb=3D 46(D)=
  OK
[   17.774442] raid6test: test_disks(2, 47): faila=3D  2(D)  failb=3D 47(D)=
  OK
[   17.775410] raid6test: test_disks(2, 48): faila=3D  2(D)  failb=3D 48(D)=
  OK
[   17.776381] raid6test: test_disks(2, 49): faila=3D  2(D)  failb=3D 49(D)=
  OK
[   17.777377] raid6test: test_disks(2, 50): faila=3D  2(D)  failb=3D 50(D)=
  OK
[   17.778357] raid6test: test_disks(2, 51): faila=3D  2(D)  failb=3D 51(D)=
  OK
[   17.779323] raid6test: test_disks(2, 52): faila=3D  2(D)  failb=3D 52(D)=
  OK
[   17.780321] raid6test: test_disks(2, 53): faila=3D  2(D)  failb=3D 53(D)=
  OK
[   17.781282] raid6test: test_disks(2, 54): faila=3D  2(D)  failb=3D 54(D)=
  OK
[   17.790632] raid6test: test_disks(2, 55): faila=3D  2(D)  failb=3D 55(D)=
  OK
[   17.791738] raid6test: test_disks(2, 56): faila=3D  2(D)  failb=3D 56(D)=
  OK
[   17.792840] raid6test: test_disks(2, 57): faila=3D  2(D)  failb=3D 57(D)=
  OK
[   17.797353] raid6test: test_disks(2, 58): faila=3D  2(D)  failb=3D 58(D)=
  OK
[   17.798441] raid6test: test_disks(2, 59): faila=3D  2(D)  failb=3D 59(D)=
  OK
[   17.799519] raid6test: test_disks(2, 60): faila=3D  2(D)  failb=3D 60(D)=
  OK
[   17.804253] raid6test: test_disks(2, 61): faila=3D  2(D)  failb=3D 61(D)=
  OK
[   17.805363] raid6test: test_disks(2, 62): faila=3D  2(D)  failb=3D 62(P)=
  OK
[   17.806469] raid6test: test_disks(2, 63): faila=3D  2(D)  failb=3D 63(Q)=
  OK
[   17.810981] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[   17.812088] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[   17.813197] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[   17.834335] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[   17.835308] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[   17.836259] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D) =
 OK
[   17.837470] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(D)=
  OK
[   17.838439] raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(D)=
  OK
[   17.839407] raid6test: test_disks(3, 12): faila=3D  3(D)  failb=3D 12(D)=
  OK
[   17.840441] raid6test: test_disks(3, 13): faila=3D  3(D)  failb=3D 13(D)=
  OK
[   17.841525] raid6test: test_disks(3, 14): faila=3D  3(D)  failb=3D 14(D)=
  OK
[   17.842610] raid6test: test_disks(3, 15): faila=3D  3(D)  failb=3D 15(D)=
  OK
[   17.850669] raid6test: test_disks(3, 16): faila=3D  3(D)  failb=3D 16(D)=
  OK
[   17.851789] raid6test: test_disks(3, 17): faila=3D  3(D)  failb=3D 17(D)=
  OK
[   17.852899] raid6test: test_disks(3, 18): faila=3D  3(D)  failb=3D 18(D)=
  OK
[   17.857593] raid6test: test_disks(3, 19): faila=3D  3(D)  failb=3D 19(D)=
  OK
[   17.858713] raid6test: test_disks(3, 20): faila=3D  3(D)  failb=3D 20(D)=
  OK
[   17.859819] raid6test: test_disks(3, 21): faila=3D  3(D)  failb=3D 21(D)=
  OK
[   17.864456] raid6test: test_disks(3, 22): faila=3D  3(D)  failb=3D 22(D)=
  OK
[   17.865581] raid6test: test_disks(3, 23): faila=3D  3(D)  failb=3D 23(D)=
  OK
[   17.866733] raid6test: test_disks(3, 24): faila=3D  3(D)  failb=3D 24(D)=
  OK
[   17.890446] raid6test: test_disks(3, 25): faila=3D  3(D)  failb=3D 25(D)=
  OK
[   17.891547] raid6test: test_disks(3, 26): faila=3D  3(D)  failb=3D 26(D)=
  OK
[   17.892617] raid6test: test_disks(3, 27): faila=3D  3(D)  failb=3D 27(D)=
  OK
[   17.897201] raid6test: test_disks(3, 28): faila=3D  3(D)  failb=3D 28(D)=
  OK
[   17.898326] raid6test: test_disks(3, 29): faila=3D  3(D)  failb=3D 29(D)=
  OK
[   17.899427] raid6test: test_disks(3, 30): faila=3D  3(D)  failb=3D 30(D)=
  OK
[   17.907419] raid6test: test_disks(3, 31): faila=3D  3(D)  failb=3D 31(D)=
  OK
[   17.908538] raid6test: test_disks(3, 32): faila=3D  3(D)  failb=3D 32(D)=
  OK
[   17.909659] raid6test: test_disks(3, 33): faila=3D  3(D)  failb=3D 33(D)=
  OK
[   17.911000] raid6test: test_disks(3, 34): faila=3D  3(D)  failb=3D 34(D)=
  OK
[   17.912026] raid6test: test_disks(3, 35): faila=3D  3(D)  failb=3D 35(D)=
  OK
[   17.913032] raid6test: test_disks(3, 36): faila=3D  3(D)  failb=3D 36(D)=
  OK
[   17.917647] raid6test: test_disks(3, 37): faila=3D  3(D)  failb=3D 37(D)=
  OK
[   17.918756] raid6test: test_disks(3, 38): faila=3D  3(D)  failb=3D 38(D)=
  OK
[   17.919863] raid6test: test_disks(3, 39): faila=3D  3(D)  failb=3D 39(D)=
  OK
[   17.927862] raid6test: test_disks(3, 40): faila=3D  3(D)  failb=3D 40(D)=
  OK
[   17.928891] raid6test: test_disks(3, 41): faila=3D  3(D)  failb=3D 41(D)=
  OK
[   17.929914] raid6test: test_disks(3, 42): faila=3D  3(D)  failb=3D 42(D)=
  OK
[   17.931067] raid6test: test_disks(3, 43): faila=3D  3(D)  failb=3D 43(D)=
  OK
[   17.932091] raid6test: test_disks(3, 44): faila=3D  3(D)  failb=3D 44(D)=
  OK
[   17.933103] raid6test: test_disks(3, 45): faila=3D  3(D)  failb=3D 45(D)=
  OK
[   17.934141] raid6test: test_disks(3, 46): faila=3D  3(D)  failb=3D 46(D)=
  OK
[   17.935148] raid6test: test_disks(3, 47): faila=3D  3(D)  failb=3D 47(D)=
  OK
[   17.936156] raid6test: test_disks(3, 48): faila=3D  3(D)  failb=3D 48(D)=
  OK
[   17.960501] raid6test: test_disks(3, 49): faila=3D  3(D)  failb=3D 49(D)=
  OK
[   17.961595] raid6test: test_disks(3, 50): faila=3D  3(D)  failb=3D 50(D)=
  OK
[   17.962573] raid6test: test_disks(3, 51): faila=3D  3(D)  failb=3D 51(D)=
  OK
[   17.963666] raid6test: test_disks(3, 52): faila=3D  3(D)  failb=3D 52(D)=
  OK
[   17.964638] raid6test: test_disks(3, 53): faila=3D  3(D)  failb=3D 53(D)=
  OK
[   17.965607] raid6test: test_disks(3, 54): faila=3D  3(D)  failb=3D 54(D)=
  OK
[   17.966573] raid6test: test_disks(3, 55): faila=3D  3(D)  failb=3D 55(D)=
  OK
[   17.967574] raid6test: test_disks(3, 56): faila=3D  3(D)  failb=3D 56(D)=
  OK
[   17.968543] raid6test: test_disks(3, 57): faila=3D  3(D)  failb=3D 57(D)=
  OK
[   17.980953] raid6test: test_disks(3, 58): faila=3D  3(D)  failb=3D 58(D)=
  OK
[   17.982046] raid6test: test_disks(3, 59): faila=3D  3(D)  failb=3D 59(D)=
  OK
[   17.983122] raid6test: test_disks(3, 60): faila=3D  3(D)  failb=3D 60(D)=
  OK
[   17.991564] raid6test: test_disks(3, 61): faila=3D  3(D)  failb=3D 61(D)=
  OK
[   17.992661] raid6test: test_disks(3, 62): faila=3D  3(D)  failb=3D 62(P)=
  OK
[   17.997309] raid6test: test_disks(3, 63): faila=3D  3(D)  failb=3D 63(Q)=
  OK
[   17.998406] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[   17.999477] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[   18.027147] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[   18.028267] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[   18.030453] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D) =
 OK
[   18.031557] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(D)=
  OK
[   18.032651] raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(D)=
  OK
[   18.033773] raid6test: test_disks(4, 12): faila=3D  4(D)  failb=3D 12(D)=
  OK
[   18.034885] raid6test: test_disks(4, 13): faila=3D  4(D)  failb=3D 13(D)=
  OK
[   18.035964] raid6test: test_disks(4, 14): faila=3D  4(D)  failb=3D 14(D)=
  OK
[   18.047331] raid6test: test_disks(4, 15): faila=3D  4(D)  failb=3D 15(D)=
  OK
[   18.050142] raid6test: test_disks(4, 16): faila=3D  4(D)  failb=3D 16(D)=
  OK
[   18.051228] raid6test: test_disks(4, 17): faila=3D  4(D)  failb=3D 17(D)=
  OK
[   18.056290] raid6test: test_disks(4, 18): faila=3D  4(D)  failb=3D 18(D)=
  OK
[   18.073114] raid6test: test_disks(4, 19): faila=3D  4(D)  failb=3D 19(D)=
  OK
[   18.074465] raid6test: test_disks(4, 20): faila=3D  4(D)  failb=3D 20(D)=
  OK
[   18.079458] raid6test: test_disks(4, 21): faila=3D  4(D)  failb=3D 21(D)=
  OK
[   18.080950] raid6test: test_disks(4, 22): faila=3D  4(D)  failb=3D 22(D)=
  OK
[   18.082074] raid6test: test_disks(4, 23): faila=3D  4(D)  failb=3D 23(D)=
  OK
[   18.083195] raid6test: test_disks(4, 24): faila=3D  4(D)  failb=3D 24(D)=
  OK
[   18.084347] raid6test: test_disks(4, 25): faila=3D  4(D)  failb=3D 25(D)=
  OK
[   18.085476] raid6test: test_disks(4, 26): faila=3D  4(D)  failb=3D 26(D)=
  OK
[   18.096276] raid6test: test_disks(4, 27): faila=3D  4(D)  failb=3D 27(D)=
  OK
[   18.097556] raid6test: test_disks(4, 28): faila=3D  4(D)  failb=3D 28(D)=
  OK
[   18.100383] raid6test: test_disks(4, 29): faila=3D  4(D)  failb=3D 29(D)=
  OK
[   18.101496] raid6test: test_disks(4, 30): faila=3D  4(D)  failb=3D 30(D)=
  OK
[   18.102607] raid6test: test_disks(4, 31): faila=3D  4(D)  failb=3D 31(D)=
  OK
[   18.127878] raid6test: test_disks(4, 32): faila=3D  4(D)  failb=3D 32(D)=
  OK
[   18.130428] raid6test: test_disks(4, 33): faila=3D  4(D)  failb=3D 33(D)=
  OK
[   18.131560] raid6test: test_disks(4, 34): faila=3D  4(D)  failb=3D 34(D)=
  OK
[   18.132941] raid6test: test_disks(4, 35): faila=3D  4(D)  failb=3D 35(D)=
  OK
[   18.134316] raid6test: test_disks(4, 36): faila=3D  4(D)  failb=3D 36(D)=
  OK
[   18.135428] raid6test: test_disks(4, 37): faila=3D  4(D)  failb=3D 37(D)=
  OK
[   18.136538] raid6test: test_disks(4, 38): faila=3D  4(D)  failb=3D 38(D)=
  OK
[   18.142068] raid6test: test_disks(4, 39): faila=3D  4(D)  failb=3D 39(D)=
  OK
[   18.143398] raid6test: test_disks(4, 40): faila=3D  4(D)  failb=3D 40(D)=
  OK
[   18.144820] raid6test: test_disks(4, 41): faila=3D  4(D)  failb=3D 41(D)=
  OK
[   18.146171] raid6test: test_disks(4, 42): faila=3D  4(D)  failb=3D 42(D)=
  OK
[   18.147767] raid6test: test_disks(4, 43): faila=3D  4(D)  failb=3D 43(D)=
  OK
[   18.149089] raid6test: test_disks(4, 44): faila=3D  4(D)  failb=3D 44(D)=
  OK
[   18.150645] raid6test: test_disks(4, 45): faila=3D  4(D)  failb=3D 45(D)=
  OK
[   18.151762] raid6test: test_disks(4, 46): faila=3D  4(D)  failb=3D 46(D)=
  OK
[   18.152879] raid6test: test_disks(4, 47): faila=3D  4(D)  failb=3D 47(D)=
  OK
[   18.154450] raid6test: test_disks(4, 48): faila=3D  4(D)  failb=3D 48(D)=
  OK
[   18.155601] raid6test: test_disks(4, 49): faila=3D  4(D)  failb=3D 49(D)=
  OK
[   18.157092] raid6test: test_disks(4, 50): faila=3D  4(D)  failb=3D 50(D)=
  OK
[   18.158258] raid6test: test_disks(4, 51): faila=3D  4(D)  failb=3D 51(D)=
  OK
[   18.159364] raid6test: test_disks(4, 52): faila=3D  4(D)  failb=3D 52(D)=
  OK
[   18.161024] raid6test: test_disks(4, 53): faila=3D  4(D)  failb=3D 53(D)=
  OK
[   18.162367] raid6test: test_disks(4, 54): faila=3D  4(D)  failb=3D 54(D)=
  OK
[   18.164347] raid6test: test_disks(4, 55): faila=3D  4(D)  failb=3D 55(D)=
  OK
[   18.165697] raid6test: test_disks(4, 56): faila=3D  4(D)  failb=3D 56(D)=
  OK
[   18.167492] raid6test: test_disks(4, 57): faila=3D  4(D)  failb=3D 57(D)=
  OK
[   18.168900] raid6test: test_disks(4, 58): faila=3D  4(D)  failb=3D 58(D)=
  OK
[   18.185472] raid6test: test_disks(4, 59): faila=3D  4(D)  failb=3D 59(D)=
  OK
[   18.186833] raid6test: test_disks(4, 60): faila=3D  4(D)  failb=3D 60(D)=
  OK
[   18.189181] raid6test: test_disks(4, 61): faila=3D  4(D)  failb=3D 61(D)=
  OK
[   18.190884] raid6test: test_disks(4, 62): faila=3D  4(D)  failb=3D 62(P)=
  OK
[   18.192595] raid6test: test_disks(4, 63): faila=3D  4(D)  failb=3D 63(Q)=
  OK
[   18.194097] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[   18.196225] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[   18.198390] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[   18.199722] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D) =
 OK
[   18.200852] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(D)=
  OK
[   18.201895] raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(D)=
  OK
[   18.202935] raid6test: test_disks(5, 12): faila=3D  5(D)  failb=3D 12(D)=
  OK
[   18.204008] raid6test: test_disks(5, 13): faila=3D  5(D)  failb=3D 13(D)=
  OK
[   18.205086] raid6test: test_disks(5, 14): faila=3D  5(D)  failb=3D 14(D)=
  OK
[   18.206124] raid6test: test_disks(5, 15): faila=3D  5(D)  failb=3D 15(D)=
  OK
[   18.207399] raid6test: test_disks(5, 16): faila=3D  5(D)  failb=3D 16(D)=
  OK
[   18.208559] raid6test: test_disks(5, 17): faila=3D  5(D)  failb=3D 17(D)=
  OK
[   18.209652] raid6test: test_disks(5, 18): faila=3D  5(D)  failb=3D 18(D)=
  OK
[   18.210828] raid6test: test_disks(5, 19): faila=3D  5(D)  failb=3D 19(D)=
  OK
[   18.211992] raid6test: test_disks(5, 20): faila=3D  5(D)  failb=3D 20(D)=
  OK
[   18.213127] raid6test: test_disks(5, 21): faila=3D  5(D)  failb=3D 21(D)=
  OK
[   18.214594] raid6test: test_disks(5, 22): faila=3D  5(D)  failb=3D 22(D)=
  OK
[   18.216373] raid6test: test_disks(5, 23): faila=3D  5(D)  failb=3D 23(D)=
  OK
[   18.233784] raid6test: test_disks(5, 24): faila=3D  5(D)  failb=3D 24(D)=
  OK
[   18.235170] raid6test: test_disks(5, 25): faila=3D  5(D)  failb=3D 25(D)=
  OK
[   18.236280] raid6test: test_disks(5, 26): faila=3D  5(D)  failb=3D 26(D)=
  OK
[   18.240914] raid6test: test_disks(5, 27): faila=3D  5(D)  failb=3D 27(D)=
  OK
[   18.242039] raid6test: test_disks(5, 28): faila=3D  5(D)  failb=3D 28(D)=
  OK
[   18.243144] raid6test: test_disks(5, 29): faila=3D  5(D)  failb=3D 29(D)=
  OK
[   18.248562] raid6test: test_disks(5, 30): faila=3D  5(D)  failb=3D 30(D)=
  OK
[   18.249681] raid6test: test_disks(5, 31): faila=3D  5(D)  failb=3D 31(D)=
  OK
[   18.291915] raid6test: test_disks(5, 32): faila=3D  5(D)  failb=3D 32(D)=
  OK
[   18.293054] raid6test: test_disks(5, 33): faila=3D  5(D)  failb=3D 33(D)=
  OK
[   18.294213] raid6test: test_disks(5, 34): faila=3D  5(D)  failb=3D 34(D)=
  OK
[   18.295341] raid6test: test_disks(5, 35): faila=3D  5(D)  failb=3D 35(D)=
  OK
[   18.296450] raid6test: test_disks(5, 36): faila=3D  5(D)  failb=3D 36(D)=
  OK
[   18.303725] raid6test: test_disks(5, 37): faila=3D  5(D)  failb=3D 37(D)=
  OK
[   18.305798] raid6test: test_disks(5, 38): faila=3D  5(D)  failb=3D 38(D)=
  OK
[   18.308537] raid6test: test_disks(5, 39): faila=3D  5(D)  failb=3D 39(D)=
  OK
[   18.309644] raid6test: test_disks(5, 40): faila=3D  5(D)  failb=3D 40(D)=
  OK
[   18.314060] raid6test: test_disks(5, 41): faila=3D  5(D)  failb=3D 41(D)=
  OK
[   18.315177] raid6test: test_disks(5, 42): faila=3D  5(D)  failb=3D 42(D)=
  OK
[   18.316292] raid6test: test_disks(5, 43): faila=3D  5(D)  failb=3D 43(D)=
  OK
[   18.321620] raid6test: test_disks(5, 44): faila=3D  5(D)  failb=3D 44(D)=
  OK
[   18.322730] raid6test: test_disks(5, 45): faila=3D  5(D)  failb=3D 45(D)=
  OK
[   18.339174] raid6test: test_disks(5, 46): faila=3D  5(D)  failb=3D 46(D)=
  OK
[   18.340300] raid6test: test_disks(5, 47): faila=3D  5(D)  failb=3D 47(D)=
  OK
[   18.341388] raid6test: test_disks(5, 48): faila=3D  5(D)  failb=3D 48(D)=
  OK
[   18.342468] raid6test: test_disks(5, 49): faila=3D  5(D)  failb=3D 49(D)=
  OK
[   18.347497] raid6test: test_disks(5, 50): faila=3D  5(D)  failb=3D 50(D)=
  OK
[   18.348605] raid6test: test_disks(5, 51): faila=3D  5(D)  failb=3D 51(D)=
  OK
[   18.349680] raid6test: test_disks(5, 52): faila=3D  5(D)  failb=3D 52(D)=
  OK
[   18.355492] raid6test: test_disks(5, 53): faila=3D  5(D)  failb=3D 53(D)=
  OK
[   18.359819] raid6test: test_disks(5, 54): faila=3D  5(D)  failb=3D 54(D)=
  OK
[   18.362331] raid6test: test_disks(5, 55): faila=3D  5(D)  failb=3D 55(D)=
  OK
[   18.364940] raid6test: test_disks(5, 56): faila=3D  5(D)  failb=3D 56(D)=
  OK
[   18.367731] raid6test: test_disks(5, 57): faila=3D  5(D)  failb=3D 57(D)=
  OK
[   18.368717] raid6test: test_disks(5, 58): faila=3D  5(D)  failb=3D 58(D)=
  OK
[   18.372056] raid6test: test_disks(5, 59): faila=3D  5(D)  failb=3D 59(D)=
  OK
[   18.373028] raid6test: test_disks(5, 60): faila=3D  5(D)  failb=3D 60(D)=
  OK
[   18.374030] raid6test: test_disks(5, 61): faila=3D  5(D)  failb=3D 61(D)=
  OK
[   18.374989] raid6test: test_disks(5, 62): faila=3D  5(D)  failb=3D 62(P)=
  OK
[   18.375961] raid6test: test_disks(5, 63): faila=3D  5(D)  failb=3D 63(Q)=
  OK
[   18.383805] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[   18.387295] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[   18.389881] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D) =
 OK
[   18.392371] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(D)=
  OK
[   18.393500] raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(D)=
  OK
[   18.398023] raid6test: test_disks(6, 12): faila=3D  6(D)  failb=3D 12(D)=
  OK
[   18.399114] raid6test: test_disks(6, 13): faila=3D  6(D)  failb=3D 13(D)=
  OK
[   18.404943] raid6test: test_disks(6, 14): faila=3D  6(D)  failb=3D 14(D)=
  OK
[   18.406381] raid6test: test_disks(6, 15): faila=3D  6(D)  failb=3D 15(D)=
  OK
[   18.408040] raid6test: test_disks(6, 16): faila=3D  6(D)  failb=3D 16(D)=
  OK
[   18.410953] raid6test: test_disks(6, 17): faila=3D  6(D)  failb=3D 17(D)=
  OK
[   18.413607] raid6test: test_disks(6, 18): faila=3D  6(D)  failb=3D 18(D)=
  OK
[   18.417332] raid6test: test_disks(6, 19): faila=3D  6(D)  failb=3D 19(D)=
  OK
[   18.425408] raid6test: test_disks(6, 20): faila=3D  6(D)  failb=3D 20(D)=
  OK
[   18.426405] raid6test: test_disks(6, 21): faila=3D  6(D)  failb=3D 21(D)=
  OK
[   18.427620] raid6test: test_disks(6, 22): faila=3D  6(D)  failb=3D 22(D)=
  OK
[   18.428592] raid6test: test_disks(6, 23): faila=3D  6(D)  failb=3D 23(D)=
  OK
[   18.429574] raid6test: test_disks(6, 24): faila=3D  6(D)  failb=3D 24(D)=
  OK
[   18.430684] raid6test: test_disks(6, 25): faila=3D  6(D)  failb=3D 25(D)=
  OK
[   18.463839] raid6test: test_disks(6, 26): faila=3D  6(D)  failb=3D 26(D)=
  OK
[   18.464966] raid6test: test_disks(6, 27): faila=3D  6(D)  failb=3D 27(D)=
  OK
[   18.466072] raid6test: test_disks(6, 28): faila=3D  6(D)  failb=3D 28(D)=
  OK
[   18.475565] raid6test: test_disks(6, 29): faila=3D  6(D)  failb=3D 29(D)=
  OK
[   18.476700] raid6test: test_disks(6, 30): faila=3D  6(D)  failb=3D 30(D)=
  OK
[   18.478062] raid6test: test_disks(6, 31): faila=3D  6(D)  failb=3D 31(D)=
  OK
[   18.479161] raid6test: test_disks(6, 32): faila=3D  6(D)  failb=3D 32(D)=
  OK
[   18.480266] raid6test: test_disks(6, 33): faila=3D  6(D)  failb=3D 33(D)=
  OK
[   18.481358] raid6test: test_disks(6, 34): faila=3D  6(D)  failb=3D 34(D)=
  OK
[   18.482453] raid6test: test_disks(6, 35): faila=3D  6(D)  failb=3D 35(D)=
  OK
[   18.487110] raid6test: test_disks(6, 36): faila=3D  6(D)  failb=3D 36(D)=
  OK
[   18.488146] raid6test: test_disks(6, 37): faila=3D  6(D)  failb=3D 37(D)=
  OK
[   18.489126] raid6test: test_disks(6, 38): faila=3D  6(D)  failb=3D 38(D)=
  OK
[   18.493504] raid6test: test_disks(6, 39): faila=3D  6(D)  failb=3D 39(D)=
  OK
[   18.494484] raid6test: test_disks(6, 40): faila=3D  6(D)  failb=3D 40(D)=
  OK
[   18.495458] raid6test: test_disks(6, 41): faila=3D  6(D)  failb=3D 41(D)=
  OK
[   18.496428] raid6test: test_disks(6, 42): faila=3D  6(D)  failb=3D 42(D)=
  OK
[   18.500980] raid6test: test_disks(6, 43): faila=3D  6(D)  failb=3D 43(D)=
  OK
[   18.502067] raid6test: test_disks(6, 44): faila=3D  6(D)  failb=3D 44(D)=
  OK
[   18.503148] raid6test: test_disks(6, 45): faila=3D  6(D)  failb=3D 45(D)=
  OK
[   18.507924] raid6test: test_disks(6, 46): faila=3D  6(D)  failb=3D 46(D)=
  OK
[   18.509007] raid6test: test_disks(6, 47): faila=3D  6(D)  failb=3D 47(D)=
  OK
[   18.510163] raid6test: test_disks(6, 48): faila=3D  6(D)  failb=3D 48(D)=
  OK
[   18.530432] raid6test: test_disks(6, 49): faila=3D  6(D)  failb=3D 49(D)=
  OK
[   18.531559] raid6test: test_disks(6, 50): faila=3D  6(D)  failb=3D 50(D)=
  OK
[   18.532660] raid6test: test_disks(6, 51): faila=3D  6(D)  failb=3D 51(D)=
  OK
[   18.547457] raid6test: test_disks(6, 52): faila=3D  6(D)  failb=3D 52(D)=
  OK
[   18.548578] raid6test: test_disks(6, 53): faila=3D  6(D)  failb=3D 53(D)=
  OK
[   18.549710] raid6test: test_disks(6, 54): faila=3D  6(D)  failb=3D 54(D)=
  OK
[   18.551005] raid6test: test_disks(6, 55): faila=3D  6(D)  failb=3D 55(D)=
  OK
[   18.552124] raid6test: test_disks(6, 56): faila=3D  6(D)  failb=3D 56(D)=
  OK
[   18.553228] raid6test: test_disks(6, 57): faila=3D  6(D)  failb=3D 57(D)=
  OK
[   18.559147] raid6test: test_disks(6, 58): faila=3D  6(D)  failb=3D 58(D)=
  OK
[   18.567297] raid6test: test_disks(6, 59): faila=3D  6(D)  failb=3D 59(D)=
  OK
[   18.568411] raid6test: test_disks(6, 60): faila=3D  6(D)  failb=3D 60(D)=
  OK
[   18.569516] raid6test: test_disks(6, 61): faila=3D  6(D)  failb=3D 61(D)=
  OK
[   18.570655] raid6test: test_disks(6, 62): faila=3D  6(D)  failb=3D 62(P)=
  OK
[   18.571763] raid6test: test_disks(6, 63): faila=3D  6(D)  failb=3D 63(Q)=
  OK
[   18.572864] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[   18.600454] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D) =
 OK
[   18.601585] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(D)=
  OK
[   18.602686] raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(D)=
  OK
[   18.603820] raid6test: test_disks(7, 12): faila=3D  7(D)  failb=3D 12(D)=
  OK
[   18.604945] raid6test: test_disks(7, 13): faila=3D  7(D)  failb=3D 13(D)=
  OK
[   18.606062] raid6test: test_disks(7, 14): faila=3D  7(D)  failb=3D 14(D)=
  OK
[   18.620591] raid6test: test_disks(7, 15): faila=3D  7(D)  failb=3D 15(D)=
  OK
[   18.621689] raid6test: test_disks(7, 16): faila=3D  7(D)  failb=3D 16(D)=
  OK
[   18.622759] raid6test: test_disks(7, 17): faila=3D  7(D)  failb=3D 17(D)=
  OK
[   18.627512] raid6test: test_disks(7, 18): faila=3D  7(D)  failb=3D 18(D)=
  OK
[   18.628628] raid6test: test_disks(7, 19): faila=3D  7(D)  failb=3D 19(D)=
  OK
[   18.629739] raid6test: test_disks(7, 20): faila=3D  7(D)  failb=3D 20(D)=
  OK
[   18.634125] raid6test: test_disks(7, 21): faila=3D  7(D)  failb=3D 21(D)=
  OK
[   18.635252] raid6test: test_disks(7, 22): faila=3D  7(D)  failb=3D 22(D)=
  OK
[   18.636354] raid6test: test_disks(7, 23): faila=3D  7(D)  failb=3D 23(D)=
  OK
[   18.654397] raid6test: test_disks(7, 24): faila=3D  7(D)  failb=3D 24(D)=
  OK
[   18.655383] raid6test: test_disks(7, 25): faila=3D  7(D)  failb=3D 25(D)=
  OK
[   18.656348] raid6test: test_disks(7, 26): faila=3D  7(D)  failb=3D 26(D)=
  OK
[   18.657513] raid6test: test_disks(7, 27): faila=3D  7(D)  failb=3D 27(D)=
  OK
[   18.658603] raid6test: test_disks(7, 28): faila=3D  7(D)  failb=3D 28(D)=
  OK
[   18.659681] raid6test: test_disks(7, 29): faila=3D  7(D)  failb=3D 29(D)=
  OK
[   18.660781] raid6test: test_disks(7, 30): faila=3D  7(D)  failb=3D 30(D)=
  OK
[   18.661895] raid6test: test_disks(7, 31): faila=3D  7(D)  failb=3D 31(D)=
  OK
[   18.662999] raid6test: test_disks(7, 32): faila=3D  7(D)  failb=3D 32(D)=
  OK
[   18.664151] raid6test: test_disks(7, 33): faila=3D  7(D)  failb=3D 33(D)=
  OK
[   18.665276] raid6test: test_disks(7, 34): faila=3D  7(D)  failb=3D 34(D)=
  OK
[   18.666356] raid6test: test_disks(7, 35): faila=3D  7(D)  failb=3D 35(D)=
  OK
[   18.674284] raid6test: test_disks(7, 36): faila=3D  7(D)  failb=3D 36(D)=
  OK
[   18.675389] raid6test: test_disks(7, 37): faila=3D  7(D)  failb=3D 37(D)=
  OK
[   18.676487] raid6test: test_disks(7, 38): faila=3D  7(D)  failb=3D 38(D)=
  OK
[   18.681022] raid6test: test_disks(7, 39): faila=3D  7(D)  failb=3D 39(D)=
  OK
[   18.682123] raid6test: test_disks(7, 40): faila=3D  7(D)  failb=3D 40(D)=
  OK
[   18.683271] raid6test: test_disks(7, 41): faila=3D  7(D)  failb=3D 41(D)=
  OK
[   18.688088] raid6test: test_disks(7, 42): faila=3D  7(D)  failb=3D 42(D)=
  OK
[   18.689204] raid6test: test_disks(7, 43): faila=3D  7(D)  failb=3D 43(D)=
  OK
[   18.690331] raid6test: test_disks(7, 44): faila=3D  7(D)  failb=3D 44(D)=
  OK
[   18.691432] raid6test: test_disks(7, 45): faila=3D  7(D)  failb=3D 45(D)=
  OK
[   18.692407] raid6test: test_disks(7, 46): faila=3D  7(D)  failb=3D 46(D)=
  OK
[   18.693398] raid6test: test_disks(7, 47): faila=3D  7(D)  failb=3D 47(D)=
  OK
[   18.715325] raid6test: test_disks(7, 48): faila=3D  7(D)  failb=3D 48(D)=
  OK
[   18.716461] raid6test: test_disks(7, 49): faila=3D  7(D)  failb=3D 49(D)=
  OK
[   18.721123] raid6test: test_disks(7, 50): faila=3D  7(D)  failb=3D 50(D)=
  OK
[   18.722228] raid6test: test_disks(7, 51): faila=3D  7(D)  failb=3D 51(D)=
  OK
[   18.723326] raid6test: test_disks(7, 52): faila=3D  7(D)  failb=3D 52(D)=
  OK
[   18.724500] raid6test: test_disks(7, 53): faila=3D  7(D)  failb=3D 53(D)=
  OK
[   18.725612] raid6test: test_disks(7, 54): faila=3D  7(D)  failb=3D 54(D)=
  OK
[   18.733532] raid6test: test_disks(7, 55): faila=3D  7(D)  failb=3D 55(D)=
  OK
[   18.734695] raid6test: test_disks(7, 56): faila=3D  7(D)  failb=3D 56(D)=
  OK
[   18.735808] raid6test: test_disks(7, 57): faila=3D  7(D)  failb=3D 57(D)=
  OK
[   18.740344] raid6test: test_disks(7, 58): faila=3D  7(D)  failb=3D 58(D)=
  OK
[   18.741456] raid6test: test_disks(7, 59): faila=3D  7(D)  failb=3D 59(D)=
  OK
[   18.742575] raid6test: test_disks(7, 60): faila=3D  7(D)  failb=3D 60(D)=
  OK
[   18.747359] raid6test: test_disks(7, 61): faila=3D  7(D)  failb=3D 61(D)=
  OK
[   18.748468] raid6test: test_disks(7, 62): faila=3D  7(D)  failb=3D 62(P)=
  OK
[   18.749570] raid6test: test_disks(7, 63): faila=3D  7(D)  failb=3D 63(Q)=
  OK
[   18.750711] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D) =
 OK
[   18.751815] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(D)=
  OK
[   18.752891] raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(D)=
  OK
[   18.785334] raid6test: test_disks(8, 12): faila=3D  8(D)  failb=3D 12(D)=
  OK
[   18.786465] raid6test: test_disks(8, 13): faila=3D  8(D)  failb=3D 13(D)=
  OK
[   18.787731] raid6test: test_disks(8, 14): faila=3D  8(D)  failb=3D 14(D)=
  OK
[   18.788865] raid6test: test_disks(8, 15): faila=3D  8(D)  failb=3D 15(D)=
  OK
[   18.789969] raid6test: test_disks(8, 16): faila=3D  8(D)  failb=3D 16(D)=
  OK
[   18.791224] raid6test: test_disks(8, 17): faila=3D  8(D)  failb=3D 17(D)=
  OK
[   18.792329] raid6test: test_disks(8, 18): faila=3D  8(D)  failb=3D 18(D)=
  OK
[   18.793488] raid6test: test_disks(8, 19): faila=3D  8(D)  failb=3D 19(D)=
  OK
[   18.794616] raid6test: test_disks(8, 20): faila=3D  8(D)  failb=3D 20(D)=
  OK
[   18.795722] raid6test: test_disks(8, 21): faila=3D  8(D)  failb=3D 21(D)=
  OK
[   18.803705] raid6test: test_disks(8, 22): faila=3D  8(D)  failb=3D 22(D)=
  OK
[   18.804809] raid6test: test_disks(8, 23): faila=3D  8(D)  failb=3D 23(D)=
  OK
[   18.805886] raid6test: test_disks(8, 24): faila=3D  8(D)  failb=3D 24(D)=
  OK
[   18.810419] raid6test: test_disks(8, 25): faila=3D  8(D)  failb=3D 25(D)=
  OK
[   18.811538] raid6test: test_disks(8, 26): faila=3D  8(D)  failb=3D 26(D)=
  OK
[   18.812644] raid6test: test_disks(8, 27): faila=3D  8(D)  failb=3D 27(D)=
  OK
[   18.817377] raid6test: test_disks(8, 28): faila=3D  8(D)  failb=3D 28(D)=
  OK
[   18.818461] raid6test: test_disks(8, 29): faila=3D  8(D)  failb=3D 29(D)=
  OK
[   18.819538] raid6test: test_disks(8, 30): faila=3D  8(D)  failb=3D 30(D)=
  OK
[   18.824330] raid6test: test_disks(8, 31): faila=3D  8(D)  failb=3D 31(D)=
  OK
[   18.825447] raid6test: test_disks(8, 32): faila=3D  8(D)  failb=3D 32(D)=
  OK
[   18.826546] raid6test: test_disks(8, 33): faila=3D  8(D)  failb=3D 33(D)=
  OK
[   18.833050] raid6test: test_disks(8, 34): faila=3D  8(D)  failb=3D 34(D)=
  OK
[   18.850469] raid6test: test_disks(8, 35): faila=3D  8(D)  failb=3D 35(D)=
  OK
[   18.851572] raid6test: test_disks(8, 36): faila=3D  8(D)  failb=3D 36(D)=
  OK
[   18.852650] raid6test: test_disks(8, 37): faila=3D  8(D)  failb=3D 37(D)=
  OK
[   18.853759] raid6test: test_disks(8, 38): faila=3D  8(D)  failb=3D 38(D)=
  OK
[   18.854848] raid6test: test_disks(8, 39): faila=3D  8(D)  failb=3D 39(D)=
  OK
[   18.855923] raid6test: test_disks(8, 40): faila=3D  8(D)  failb=3D 40(D)=
  OK
[   18.857032] raid6test: test_disks(8, 41): faila=3D  8(D)  failb=3D 41(D)=
  OK
[   18.858154] raid6test: test_disks(8, 42): faila=3D  8(D)  failb=3D 42(D)=
  OK
[   18.869488] raid6test: test_disks(8, 43): faila=3D  8(D)  failb=3D 43(D)=
  OK
[   18.870813] raid6test: test_disks(8, 44): faila=3D  8(D)  failb=3D 44(D)=
  OK
[   18.871904] raid6test: test_disks(8, 45): faila=3D  8(D)  failb=3D 45(D)=
  OK
[   18.872979] raid6test: test_disks(8, 46): faila=3D  8(D)  failb=3D 46(D)=
  OK
[   18.875638] raid6test: test_disks(8, 47): faila=3D  8(D)  failb=3D 47(D)=
  OK
[   18.881579] raid6test: test_disks(8, 48): faila=3D  8(D)  failb=3D 48(D)=
  OK
[   18.884180] raid6test: test_disks(8, 49): faila=3D  8(D)  failb=3D 49(D)=
  OK
[   18.888234] raid6test: test_disks(8, 50): faila=3D  8(D)  failb=3D 50(D)=
  OK
[   18.889353] raid6test: test_disks(8, 51): faila=3D  8(D)  failb=3D 51(D)=
  OK
[   18.890472] raid6test: test_disks(8, 52): faila=3D  8(D)  failb=3D 52(D)=
  OK
[   18.891572] raid6test: test_disks(8, 53): faila=3D  8(D)  failb=3D 53(D)=
  OK
[   18.892674] raid6test: test_disks(8, 54): faila=3D  8(D)  failb=3D 54(D)=
  OK
[   18.893817] raid6test: test_disks(8, 55): faila=3D  8(D)  failb=3D 55(D)=
  OK
[   18.894892] raid6test: test_disks(8, 56): faila=3D  8(D)  failb=3D 56(D)=
  OK
[   18.895958] raid6test: test_disks(8, 57): faila=3D  8(D)  failb=3D 57(D)=
  OK
[   18.915343] raid6test: test_disks(8, 58): faila=3D  8(D)  failb=3D 58(D)=
  OK
[   18.916465] raid6test: test_disks(8, 59): faila=3D  8(D)  failb=3D 59(D)=
  OK
[   18.917618] raid6test: test_disks(8, 60): faila=3D  8(D)  failb=3D 60(D)=
  OK
[   18.918731] raid6test: test_disks(8, 61): faila=3D  8(D)  failb=3D 61(D)=
  OK
[   18.919825] raid6test: test_disks(8, 62): faila=3D  8(D)  failb=3D 62(P)=
  OK
[   18.920973] raid6test: test_disks(8, 63): faila=3D  8(D)  failb=3D 63(Q)=
  OK
[   18.922088] raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(D)=
  OK
[   18.941349] raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(D)=
  OK
[   18.942326] raid6test: test_disks(9, 12): faila=3D  9(D)  failb=3D 12(D)=
  OK
[   18.943298] raid6test: test_disks(9, 13): faila=3D  9(D)  failb=3D 13(D)=
  OK
[   18.944433] raid6test: test_disks(9, 14): faila=3D  9(D)  failb=3D 14(D)=
  OK
[   18.945518] raid6test: test_disks(9, 15): faila=3D  9(D)  failb=3D 15(D)=
  OK
[   18.946604] raid6test: test_disks(9, 16): faila=3D  9(D)  failb=3D 16(D)=
  OK
[   18.947812] raid6test: test_disks(9, 17): faila=3D  9(D)  failb=3D 17(D)=
  OK
[   18.948912] raid6test: test_disks(9, 18): faila=3D  9(D)  failb=3D 18(D)=
  OK
[   18.968192] raid6test: test_disks(9, 19): faila=3D  9(D)  failb=3D 19(D)=
  OK
[   18.969355] raid6test: test_disks(9, 20): faila=3D  9(D)  failb=3D 20(D)=
  OK
[   18.970491] raid6test: test_disks(9, 21): faila=3D  9(D)  failb=3D 21(D)=
  OK
[   18.971612] raid6test: test_disks(9, 22): faila=3D  9(D)  failb=3D 22(D)=
  OK
[   18.972738] raid6test: test_disks(9, 23): faila=3D  9(D)  failb=3D 23(D)=
  OK
[   18.973863] raid6test: test_disks(9, 24): faila=3D  9(D)  failb=3D 24(D)=
  OK
[   18.988116] raid6test: test_disks(9, 25): faila=3D  9(D)  failb=3D 25(D)=
  OK
[   18.989205] raid6test: test_disks(9, 26): faila=3D  9(D)  failb=3D 26(D)=
  OK
[   18.990342] raid6test: test_disks(9, 27): faila=3D  9(D)  failb=3D 27(D)=
  OK
[   18.991454] raid6test: test_disks(9, 28): faila=3D  9(D)  failb=3D 28(D)=
  OK
[   18.992559] raid6test: test_disks(9, 29): faila=3D  9(D)  failb=3D 29(D)=
  OK
[   18.993713] raid6test: test_disks(9, 30): faila=3D  9(D)  failb=3D 30(D)=
  OK
[   18.994765] raid6test: test_disks(9, 31): faila=3D  9(D)  failb=3D 31(D)=
  OK
[   18.995737] raid6test: test_disks(9, 32): faila=3D  9(D)  failb=3D 32(D)=
  OK
[   18.996757] raid6test: test_disks(9, 33): faila=3D  9(D)  failb=3D 33(D)=
  OK
[   18.997730] raid6test: test_disks(9, 34): faila=3D  9(D)  failb=3D 34(D)=
  OK
[   18.998695] raid6test: test_disks(9, 35): faila=3D  9(D)  failb=3D 35(D)=
  OK
[   18.999669] raid6test: test_disks(9, 36): faila=3D  9(D)  failb=3D 36(D)=
  OK
[   19.026315] raid6test: test_disks(9, 37): faila=3D  9(D)  failb=3D 37(D)=
  OK
[   19.027497] raid6test: test_disks(9, 38): faila=3D  9(D)  failb=3D 38(D)=
  OK
[   19.028587] raid6test: test_disks(9, 39): faila=3D  9(D)  failb=3D 39(D)=
  OK
[   19.029667] raid6test: test_disks(9, 40): faila=3D  9(D)  failb=3D 40(D)=
  OK
[   19.030789] raid6test: test_disks(9, 41): faila=3D  9(D)  failb=3D 41(D)=
  OK
[   19.031890] raid6test: test_disks(9, 42): faila=3D  9(D)  failb=3D 42(D)=
  OK
[   19.032992] raid6test: test_disks(9, 43): faila=3D  9(D)  failb=3D 43(D)=
  OK
[   19.034111] raid6test: test_disks(9, 44): faila=3D  9(D)  failb=3D 44(D)=
  OK
[   19.043770] raid6test: test_disks(9, 45): faila=3D  9(D)  failb=3D 45(D)=
  OK
[   19.044878] raid6test: test_disks(9, 46): faila=3D  9(D)  failb=3D 46(D)=
  OK
[   19.045976] raid6test: test_disks(9, 47): faila=3D  9(D)  failb=3D 47(D)=
  OK
[   19.047110] raid6test: test_disks(9, 48): faila=3D  9(D)  failb=3D 48(D)=
  OK
[   19.048199] raid6test: test_disks(9, 49): faila=3D  9(D)  failb=3D 49(D)=
  OK
[   19.049279] raid6test: test_disks(9, 50): faila=3D  9(D)  failb=3D 50(D)=
  OK
[   19.050490] raid6test: test_disks(9, 51): faila=3D  9(D)  failb=3D 51(D)=
  OK
[   19.051509] raid6test: test_disks(9, 52): faila=3D  9(D)  failb=3D 52(D)=
  OK
[   19.052483] raid6test: test_disks(9, 53): faila=3D  9(D)  failb=3D 53(D)=
  OK
[   19.056892] raid6test: test_disks(9, 54): faila=3D  9(D)  failb=3D 54(D)=
  OK
[   19.057884] raid6test: test_disks(9, 55): faila=3D  9(D)  failb=3D 55(D)=
  OK
[   19.058850] raid6test: test_disks(9, 56): faila=3D  9(D)  failb=3D 56(D)=
  OK
[   19.059822] raid6test: test_disks(9, 57): faila=3D  9(D)  failb=3D 57(D)=
  OK
[   19.067428] raid6test: test_disks(9, 58): faila=3D  9(D)  failb=3D 58(D)=
  OK
[   19.067428] raid6test: test_disks(9, 59): faila=3D  9(D)  failb=3D 59(D)=
  OK
[   19.067428] raid6test: test_disks(9, 60): faila=3D  9(D)  failb=3D 60(D)=
  OK
[   19.080669] raid6test: test_disks(9, 61): faila=3D  9(D)  failb=3D 61(D)=
  OK
[   19.081753] raid6test: test_disks(9, 62): faila=3D  9(D)  failb=3D 62(P)=
  OK
[   19.082836] raid6test: test_disks(9, 63): faila=3D  9(D)  failb=3D 63(Q)=
  OK
[   19.083947] raid6test: test_disks(10, 11): faila=3D 10(D)  failb=3D 11(D=
)  OK
[   19.085048] raid6test: test_disks(10, 12): faila=3D 10(D)  failb=3D 12(D=
)  OK
[   19.086143] raid6test: test_disks(10, 13): faila=3D 10(D)  failb=3D 13(D=
)  OK
[   19.100316] raid6test: test_disks(10, 14): faila=3D 10(D)  failb=3D 14(D=
)  OK
[   19.101466] raid6test: test_disks(10, 15): faila=3D 10(D)  failb=3D 15(D=
)  OK
[   19.102585] raid6test: test_disks(10, 16): faila=3D 10(D)  failb=3D 16(D=
)  OK
[   19.103734] raid6test: test_disks(10, 17): faila=3D 10(D)  failb=3D 17(D=
)  OK
[   19.104842] raid6test: test_disks(10, 18): faila=3D 10(D)  failb=3D 18(D=
)  OK
[   19.105947] raid6test: test_disks(10, 19): faila=3D 10(D)  failb=3D 19(D=
)  OK
[   19.107103] raid6test: test_disks(10, 20): faila=3D 10(D)  failb=3D 20(D=
)  OK
[   19.108226] raid6test: test_disks(10, 21): faila=3D 10(D)  failb=3D 21(D=
)  OK
[   19.117225] raid6test: test_disks(10, 22): faila=3D 10(D)  failb=3D 22(D=
)  OK
[   19.118265] raid6test: test_disks(10, 23): faila=3D 10(D)  failb=3D 23(D=
)  OK
[   19.119250] raid6test: test_disks(10, 24): faila=3D 10(D)  failb=3D 24(D=
)  OK
[   19.123654] raid6test: test_disks(10, 25): faila=3D 10(D)  failb=3D 25(D=
)  OK
[   19.124645] raid6test: test_disks(10, 26): faila=3D 10(D)  failb=3D 26(D=
)  OK
[   19.125634] raid6test: test_disks(10, 27): faila=3D 10(D)  failb=3D 27(D=
)  OK
[   19.126627] raid6test: test_disks(10, 28): faila=3D 10(D)  failb=3D 28(D=
)  OK
[   19.131189] raid6test: test_disks(10, 29): faila=3D 10(D)  failb=3D 29(D=
)  OK
[   19.132295] raid6test: test_disks(10, 30): faila=3D 10(D)  failb=3D 30(D=
)  OK
[   19.146251] raid6test: test_disks(10, 31): faila=3D 10(D)  failb=3D 31(D=
)  OK
[   19.147549] raid6test: test_disks(10, 32): faila=3D 10(D)  failb=3D 32(D=
)  OK
[   19.148650] raid6test: test_disks(10, 33): faila=3D 10(D)  failb=3D 33(D=
)  OK
[   19.149749] raid6test: test_disks(10, 34): faila=3D 10(D)  failb=3D 34(D=
)  OK
[   19.150907] raid6test: test_disks(10, 35): faila=3D 10(D)  failb=3D 35(D=
)  OK
[   19.152043] raid6test: test_disks(10, 36): faila=3D 10(D)  failb=3D 36(D=
)  OK
[   19.153145] raid6test: test_disks(10, 37): faila=3D 10(D)  failb=3D 37(D=
)  OK
[   19.167310] raid6test: test_disks(10, 38): faila=3D 10(D)  failb=3D 38(D=
)  OK
[   19.168418] raid6test: test_disks(10, 39): faila=3D 10(D)  failb=3D 39(D=
)  OK
[   19.169525] raid6test: test_disks(10, 40): faila=3D 10(D)  failb=3D 40(D=
)  OK
[   19.170700] raid6test: test_disks(10, 41): faila=3D 10(D)  failb=3D 41(D=
)  OK
[   19.171826] raid6test: test_disks(10, 42): faila=3D 10(D)  failb=3D 42(D=
)  OK
[   19.172944] raid6test: test_disks(10, 43): faila=3D 10(D)  failb=3D 43(D=
)  OK
[   19.174058] raid6test: test_disks(10, 44): faila=3D 10(D)  failb=3D 44(D=
)  OK
[   19.175047] raid6test: test_disks(10, 45): faila=3D 10(D)  failb=3D 45(D=
)  OK
[   19.176029] raid6test: test_disks(10, 46): faila=3D 10(D)  failb=3D 46(D=
)  OK
[   19.177060] raid6test: test_disks(10, 47): faila=3D 10(D)  failb=3D 47(D=
)  OK
[   19.178061] raid6test: test_disks(10, 48): faila=3D 10(D)  failb=3D 48(D=
)  OK
[   19.179054] raid6test: test_disks(10, 49): faila=3D 10(D)  failb=3D 49(D=
)  OK
[   19.188307] raid6test: test_disks(10, 50): faila=3D 10(D)  failb=3D 50(D=
)  OK
[   19.189352] raid6test: test_disks(10, 51): faila=3D 10(D)  failb=3D 51(D=
)  OK
[   19.190480] raid6test: test_disks(10, 52): faila=3D 10(D)  failb=3D 52(D=
)  OK
[   19.191575] raid6test: test_disks(10, 53): faila=3D 10(D)  failb=3D 53(D=
)  OK
[   19.192663] raid6test: test_disks(10, 54): faila=3D 10(D)  failb=3D 54(D=
)  OK
[   19.193783] raid6test: test_disks(10, 55): faila=3D 10(D)  failb=3D 55(D=
)  OK
[   19.194875] raid6test: test_disks(10, 56): faila=3D 10(D)  failb=3D 56(D=
)  OK
[   19.195964] raid6test: test_disks(10, 57): faila=3D 10(D)  failb=3D 57(D=
)  OK
[   19.197238] raid6test: test_disks(10, 58): faila=3D 10(D)  failb=3D 58(D=
)  OK
[   19.198364] raid6test: test_disks(10, 59): faila=3D 10(D)  failb=3D 59(D=
)  OK
[   19.199489] raid6test: test_disks(10, 60): faila=3D 10(D)  failb=3D 60(D=
)  OK
[   19.200705] raid6test: test_disks(10, 61): faila=3D 10(D)  failb=3D 61(D=
)  OK
[   19.201842] raid6test: test_disks(10, 62): faila=3D 10(D)  failb=3D 62(P=
)  OK
[   19.202961] raid6test: test_disks(10, 63): faila=3D 10(D)  failb=3D 63(Q=
)  OK
[   19.204224] raid6test: test_disks(11, 12): faila=3D 11(D)  failb=3D 12(D=
)  OK
[   19.205346] raid6test: test_disks(11, 13): faila=3D 11(D)  failb=3D 13(D=
)  OK
[   19.206463] raid6test: test_disks(11, 14): faila=3D 11(D)  failb=3D 14(D=
)  OK
[   19.207743] raid6test: test_disks(11, 15): faila=3D 11(D)  failb=3D 15(D=
)  OK
[   19.208861] raid6test: test_disks(11, 16): faila=3D 11(D)  failb=3D 16(D=
)  OK
[   19.209961] raid6test: test_disks(11, 17): faila=3D 11(D)  failb=3D 17(D=
)  OK
[   19.211125] raid6test: test_disks(11, 18): faila=3D 11(D)  failb=3D 18(D=
)  OK
[   19.212219] raid6test: test_disks(11, 19): faila=3D 11(D)  failb=3D 19(D=
)  OK
[   19.213309] raid6test: test_disks(11, 20): faila=3D 11(D)  failb=3D 20(D=
)  OK
[   19.214493] raid6test: test_disks(11, 21): faila=3D 11(D)  failb=3D 21(D=
)  OK
[   19.215589] raid6test: test_disks(11, 22): faila=3D 11(D)  failb=3D 22(D=
)  OK
[   19.216976] raid6test: test_disks(11, 23): faila=3D 11(D)  failb=3D 23(D=
)  OK
[   19.218111] raid6test: test_disks(11, 24): faila=3D 11(D)  failb=3D 24(D=
)  OK
[   19.219231] raid6test: test_disks(11, 25): faila=3D 11(D)  failb=3D 25(D=
)  OK
[   19.220381] raid6test: test_disks(11, 26): faila=3D 11(D)  failb=3D 26(D=
)  OK
[   19.221500] raid6test: test_disks(11, 27): faila=3D 11(D)  failb=3D 27(D=
)  OK
[   19.222611] raid6test: test_disks(11, 28): faila=3D 11(D)  failb=3D 28(D=
)  OK
[   19.223751] raid6test: test_disks(11, 29): faila=3D 11(D)  failb=3D 29(D=
)  OK
[   19.224866] raid6test: test_disks(11, 30): faila=3D 11(D)  failb=3D 30(D=
)  OK
[   19.225955] raid6test: test_disks(11, 31): faila=3D 11(D)  failb=3D 31(D=
)  OK
[   19.240312] raid6test: test_disks(11, 32): faila=3D 11(D)  failb=3D 32(D=
)  OK
[   19.241317] raid6test: test_disks(11, 33): faila=3D 11(D)  failb=3D 33(D=
)  OK
[   19.242299] raid6test: test_disks(11, 34): faila=3D 11(D)  failb=3D 34(D=
)  OK
[   19.243279] raid6test: test_disks(11, 35): faila=3D 11(D)  failb=3D 35(D=
)  OK
[   19.244292] raid6test: test_disks(11, 36): faila=3D 11(D)  failb=3D 36(D=
)  OK
[   19.245275] raid6test: test_disks(11, 37): faila=3D 11(D)  failb=3D 37(D=
)  OK
[   19.246259] raid6test: test_disks(11, 38): faila=3D 11(D)  failb=3D 38(D=
)  OK
[   19.247293] raid6test: test_disks(11, 39): faila=3D 11(D)  failb=3D 39(D=
)  OK
[   19.248273] raid6test: test_disks(11, 40): faila=3D 11(D)  failb=3D 40(D=
)  OK
[   19.249256] raid6test: test_disks(11, 41): faila=3D 11(D)  failb=3D 41(D=
)  OK
[   19.250284] raid6test: test_disks(11, 42): faila=3D 11(D)  failb=3D 42(D=
)  OK
[   19.251270] raid6test: test_disks(11, 43): faila=3D 11(D)  failb=3D 43(D=
)  OK
[   19.252253] raid6test: test_disks(11, 44): faila=3D 11(D)  failb=3D 44(D=
)  OK
[   19.253330] raid6test: test_disks(11, 45): faila=3D 11(D)  failb=3D 45(D=
)  OK
[   19.254416] raid6test: test_disks(11, 46): faila=3D 11(D)  failb=3D 46(D=
)  OK
[   19.255506] raid6test: test_disks(11, 47): faila=3D 11(D)  failb=3D 47(D=
)  OK
[   19.256601] raid6test: test_disks(11, 48): faila=3D 11(D)  failb=3D 48(D=
)  OK
[   19.257821] raid6test: test_disks(11, 49): faila=3D 11(D)  failb=3D 49(D=
)  OK
[   19.258919] raid6test: test_disks(11, 50): faila=3D 11(D)  failb=3D 50(D=
)  OK
[   19.260150] raid6test: test_disks(11, 51): faila=3D 11(D)  failb=3D 51(D=
)  OK
[   19.261303] raid6test: test_disks(11, 52): faila=3D 11(D)  failb=3D 52(D=
)  OK
[   19.262412] raid6test: test_disks(11, 53): faila=3D 11(D)  failb=3D 53(D=
)  OK
[   19.263536] raid6test: test_disks(11, 54): faila=3D 11(D)  failb=3D 54(D=
)  OK
[   19.264651] raid6test: test_disks(11, 55): faila=3D 11(D)  failb=3D 55(D=
)  OK
[   19.265760] raid6test: test_disks(11, 56): faila=3D 11(D)  failb=3D 56(D=
)  OK
[   19.266907] raid6test: test_disks(11, 57): faila=3D 11(D)  failb=3D 57(D=
)  OK
[   19.268031] raid6test: test_disks(11, 58): faila=3D 11(D)  failb=3D 58(D=
)  OK
[   19.269125] raid6test: test_disks(11, 59): faila=3D 11(D)  failb=3D 59(D=
)  OK
[   19.270536] raid6test: test_disks(11, 60): faila=3D 11(D)  failb=3D 60(D=
)  OK
[   19.271663] raid6test: test_disks(11, 61): faila=3D 11(D)  failb=3D 61(D=
)  OK
[   19.272779] raid6test: test_disks(11, 62): faila=3D 11(D)  failb=3D 62(P=
)  OK
[   19.273930] raid6test: test_disks(11, 63): faila=3D 11(D)  failb=3D 63(Q=
)  OK
[   19.275039] raid6test: test_disks(12, 13): faila=3D 12(D)  failb=3D 13(D=
)  OK
[   19.276149] raid6test: test_disks(12, 14): faila=3D 12(D)  failb=3D 14(D=
)  OK
[   19.277283] raid6test: test_disks(12, 15): faila=3D 12(D)  failb=3D 15(D=
)  OK
[   19.278400] raid6test: test_disks(12, 16): faila=3D 12(D)  failb=3D 16(D=
)  OK
[   19.293309] raid6test: test_disks(12, 17): faila=3D 12(D)  failb=3D 17(D=
)  OK
[   19.294333] raid6test: test_disks(12, 18): faila=3D 12(D)  failb=3D 18(D=
)  OK
[   19.295325] raid6test: test_disks(12, 19): faila=3D 12(D)  failb=3D 19(D=
)  OK
[   19.296319] raid6test: test_disks(12, 20): faila=3D 12(D)  failb=3D 20(D=
)  OK
[   19.297350] raid6test: test_disks(12, 21): faila=3D 12(D)  failb=3D 21(D=
)  OK
[   19.298353] raid6test: test_disks(12, 22): faila=3D 12(D)  failb=3D 22(D=
)  OK
[   19.299350] raid6test: test_disks(12, 23): faila=3D 12(D)  failb=3D 23(D=
)  OK
[   19.300413] raid6test: test_disks(12, 24): faila=3D 12(D)  failb=3D 24(D=
)  OK
[   19.301408] raid6test: test_disks(12, 25): faila=3D 12(D)  failb=3D 25(D=
)  OK
[   19.302681] raid6test: test_disks(12, 26): faila=3D 12(D)  failb=3D 26(D=
)  OK
[   19.303742] raid6test: test_disks(12, 27): faila=3D 12(D)  failb=3D 27(D=
)  OK
[   19.304727] raid6test: test_disks(12, 28): faila=3D 12(D)  failb=3D 28(D=
)  OK
[   19.305712] raid6test: test_disks(12, 29): faila=3D 12(D)  failb=3D 29(D=
)  OK
[   19.306797] raid6test: test_disks(12, 30): faila=3D 12(D)  failb=3D 30(D=
)  OK
[   19.307778] raid6test: test_disks(12, 31): faila=3D 12(D)  failb=3D 31(D=
)  OK
[   19.308757] raid6test: test_disks(12, 32): faila=3D 12(D)  failb=3D 32(D=
)  OK
[   19.309820] raid6test: test_disks(12, 33): faila=3D 12(D)  failb=3D 33(D=
)  OK
[   19.311168] raid6test: test_disks(12, 34): faila=3D 12(D)  failb=3D 34(D=
)  OK
[   19.312267] raid6test: test_disks(12, 35): faila=3D 12(D)  failb=3D 35(D=
)  OK
[   19.313389] raid6test: test_disks(12, 36): faila=3D 12(D)  failb=3D 36(D=
)  OK
[   19.314496] raid6test: test_disks(12, 37): faila=3D 12(D)  failb=3D 37(D=
)  OK
[   19.315589] raid6test: test_disks(12, 38): faila=3D 12(D)  failb=3D 38(D=
)  OK
[   19.316711] raid6test: test_disks(12, 39): faila=3D 12(D)  failb=3D 39(D=
)  OK
[   19.317847] raid6test: test_disks(12, 40): faila=3D 12(D)  failb=3D 40(D=
)  OK
[   19.318960] raid6test: test_disks(12, 41): faila=3D 12(D)  failb=3D 41(D=
)  OK
[   19.320357] raid6test: test_disks(12, 42): faila=3D 12(D)  failb=3D 42(D=
)  OK
[   19.321502] raid6test: test_disks(12, 43): faila=3D 12(D)  failb=3D 43(D=
)  OK
[   19.322616] raid6test: test_disks(12, 44): faila=3D 12(D)  failb=3D 44(D=
)  OK
[   19.323774] raid6test: test_disks(12, 45): faila=3D 12(D)  failb=3D 45(D=
)  OK
[   19.324907] raid6test: test_disks(12, 46): faila=3D 12(D)  failb=3D 46(D=
)  OK
[   19.326032] raid6test: test_disks(12, 47): faila=3D 12(D)  failb=3D 47(D=
)  OK
[   19.327197] raid6test: test_disks(12, 48): faila=3D 12(D)  failb=3D 48(D=
)  OK
[   19.328310] raid6test: test_disks(12, 49): faila=3D 12(D)  failb=3D 49(D=
)  OK
[   19.329432] raid6test: test_disks(12, 50): faila=3D 12(D)  failb=3D 50(D=
)  OK
[   19.356389] raid6test: test_disks(12, 51): faila=3D 12(D)  failb=3D 51(D=
)  OK
[   19.357554] raid6test: test_disks(12, 52): faila=3D 12(D)  failb=3D 52(D=
)  OK
[   19.358654] raid6test: test_disks(12, 53): faila=3D 12(D)  failb=3D 53(D=
)  OK
[   19.359803] raid6test: test_disks(12, 54): faila=3D 12(D)  failb=3D 54(D=
)  OK
[   19.360949] raid6test: test_disks(12, 55): faila=3D 12(D)  failb=3D 55(D=
)  OK
[   19.362100] raid6test: test_disks(12, 56): faila=3D 12(D)  failb=3D 56(D=
)  OK
[   19.363216] raid6test: test_disks(12, 57): faila=3D 12(D)  failb=3D 57(D=
)  OK
[   19.364362] raid6test: test_disks(12, 58): faila=3D 12(D)  failb=3D 58(D=
)  OK
[   19.368370] raid6test: test_disks(12, 59): faila=3D 12(D)  failb=3D 59(D=
)  OK
[   19.369359] raid6test: test_disks(12, 60): faila=3D 12(D)  failb=3D 60(D=
)  OK
[   19.370375] raid6test: test_disks(12, 61): faila=3D 12(D)  failb=3D 61(D=
)  OK
[   19.371359] raid6test: test_disks(12, 62): faila=3D 12(D)  failb=3D 62(P=
)  OK
[   19.372342] raid6test: test_disks(12, 63): faila=3D 12(D)  failb=3D 63(Q=
)  OK
[   19.373332] raid6test: test_disks(13, 14): faila=3D 13(D)  failb=3D 14(D=
)  OK
[   19.374356] raid6test: test_disks(13, 15): faila=3D 13(D)  failb=3D 15(D=
)  OK
[   19.375383] raid6test: test_disks(13, 16): faila=3D 13(D)  failb=3D 16(D=
)  OK
[   19.376475] raid6test: test_disks(13, 17): faila=3D 13(D)  failb=3D 17(D=
)  OK
[   19.377601] raid6test: test_disks(13, 18): faila=3D 13(D)  failb=3D 18(D=
)  OK
[   19.378697] raid6test: test_disks(13, 19): faila=3D 13(D)  failb=3D 19(D=
)  OK
[   19.379943] raid6test: test_disks(13, 20): faila=3D 13(D)  failb=3D 20(D=
)  OK
[   19.381074] raid6test: test_disks(13, 21): faila=3D 13(D)  failb=3D 21(D=
)  OK
[   19.382171] raid6test: test_disks(13, 22): faila=3D 13(D)  failb=3D 22(D=
)  OK
[   19.383266] raid6test: test_disks(13, 23): faila=3D 13(D)  failb=3D 23(D=
)  OK
[   19.384412] raid6test: test_disks(13, 24): faila=3D 13(D)  failb=3D 24(D=
)  OK
[   19.385543] raid6test: test_disks(13, 25): faila=3D 13(D)  failb=3D 25(D=
)  OK
[   19.386950] raid6test: test_disks(13, 26): faila=3D 13(D)  failb=3D 26(D=
)  OK
[   19.388105] raid6test: test_disks(13, 27): faila=3D 13(D)  failb=3D 27(D=
)  OK
[   19.389221] raid6test: test_disks(13, 28): faila=3D 13(D)  failb=3D 28(D=
)  OK
[   19.390389] raid6test: test_disks(13, 29): faila=3D 13(D)  failb=3D 29(D=
)  OK
[   19.391514] raid6test: test_disks(13, 30): faila=3D 13(D)  failb=3D 30(D=
)  OK
[   19.392654] raid6test: test_disks(13, 31): faila=3D 13(D)  failb=3D 31(D=
)  OK
[   19.393974] raid6test: test_disks(13, 32): faila=3D 13(D)  failb=3D 32(D=
)  OK
[   19.395086] raid6test: test_disks(13, 33): faila=3D 13(D)  failb=3D 33(D=
)  OK
[   19.396193] raid6test: test_disks(13, 34): faila=3D 13(D)  failb=3D 34(D=
)  OK
[   19.410333] raid6test: test_disks(13, 35): faila=3D 13(D)  failb=3D 35(D=
)  OK
[   19.411508] raid6test: test_disks(13, 36): faila=3D 13(D)  failb=3D 36(D=
)  OK
[   19.412630] raid6test: test_disks(13, 37): faila=3D 13(D)  failb=3D 37(D=
)  OK
[   19.413785] raid6test: test_disks(13, 38): faila=3D 13(D)  failb=3D 38(D=
)  OK
[   19.414904] raid6test: test_disks(13, 39): faila=3D 13(D)  failb=3D 39(D=
)  OK
[   19.416005] raid6test: test_disks(13, 40): faila=3D 13(D)  failb=3D 40(D=
)  OK
[   19.417141] raid6test: test_disks(13, 41): faila=3D 13(D)  failb=3D 41(D=
)  OK
[   19.418262] raid6test: test_disks(13, 42): faila=3D 13(D)  failb=3D 42(D=
)  OK
[   19.422400] raid6test: test_disks(13, 43): faila=3D 13(D)  failb=3D 43(D=
)  OK
[   19.423482] raid6test: test_disks(13, 44): faila=3D 13(D)  failb=3D 44(D=
)  OK
[   19.424480] raid6test: test_disks(13, 45): faila=3D 13(D)  failb=3D 45(D=
)  OK
[   19.425462] raid6test: test_disks(13, 46): faila=3D 13(D)  failb=3D 46(D=
)  OK
[   19.426439] raid6test: test_disks(13, 47): faila=3D 13(D)  failb=3D 47(D=
)  OK
[   19.427559] raid6test: test_disks(13, 48): faila=3D 13(D)  failb=3D 48(D=
)  OK
[   19.428551] raid6test: test_disks(13, 49): faila=3D 13(D)  failb=3D 49(D=
)  OK
[   19.429526] raid6test: test_disks(13, 50): faila=3D 13(D)  failb=3D 50(D=
)  OK
[   19.430540] raid6test: test_disks(13, 51): faila=3D 13(D)  failb=3D 51(D=
)  OK
[   19.431522] raid6test: test_disks(13, 52): faila=3D 13(D)  failb=3D 52(D=
)  OK
[   19.432523] raid6test: test_disks(13, 53): faila=3D 13(D)  failb=3D 53(D=
)  OK
[   19.433528] raid6test: test_disks(13, 54): faila=3D 13(D)  failb=3D 54(D=
)  OK
[   19.434512] raid6test: test_disks(13, 55): faila=3D 13(D)  failb=3D 55(D=
)  OK
[   19.435495] raid6test: test_disks(13, 56): faila=3D 13(D)  failb=3D 56(D=
)  OK
[   19.436531] raid6test: test_disks(13, 57): faila=3D 13(D)  failb=3D 57(D=
)  OK
[   19.437895] raid6test: test_disks(13, 58): faila=3D 13(D)  failb=3D 58(D=
)  OK
[   19.438991] raid6test: test_disks(13, 59): faila=3D 13(D)  failb=3D 59(D=
)  OK
[   19.440122] raid6test: test_disks(13, 60): faila=3D 13(D)  failb=3D 60(D=
)  OK
[   19.441215] raid6test: test_disks(13, 61): faila=3D 13(D)  failb=3D 61(D=
)  OK
[   19.442316] raid6test: test_disks(13, 62): faila=3D 13(D)  failb=3D 62(P=
)  OK
[   19.443479] raid6test: test_disks(13, 63): faila=3D 13(D)  failb=3D 63(Q=
)  OK
[   19.444605] raid6test: test_disks(14, 15): faila=3D 14(D)  failb=3D 15(D=
)  OK
[   19.445743] raid6test: test_disks(14, 16): faila=3D 14(D)  failb=3D 16(D=
)  OK
[   19.459303] raid6test: test_disks(14, 17): faila=3D 14(D)  failb=3D 17(D=
)  OK
[   19.460453] raid6test: test_disks(14, 18): faila=3D 14(D)  failb=3D 18(D=
)  OK
[   19.461593] raid6test: test_disks(14, 19): faila=3D 14(D)  failb=3D 19(D=
)  OK
[   19.462716] raid6test: test_disks(14, 20): faila=3D 14(D)  failb=3D 20(D=
)  OK
[   19.463884] raid6test: test_disks(14, 21): faila=3D 14(D)  failb=3D 21(D=
)  OK
[   19.465031] raid6test: test_disks(14, 22): faila=3D 14(D)  failb=3D 22(D=
)  OK
[   19.469729] raid6test: test_disks(14, 23): faila=3D 14(D)  failb=3D 23(D=
)  OK
[   19.470911] raid6test: test_disks(14, 24): faila=3D 14(D)  failb=3D 24(D=
)  OK
[   19.472003] raid6test: test_disks(14, 25): faila=3D 14(D)  failb=3D 25(D=
)  OK
[   19.473105] raid6test: test_disks(14, 26): faila=3D 14(D)  failb=3D 26(D=
)  OK
[   19.474322] raid6test: test_disks(14, 27): faila=3D 14(D)  failb=3D 27(D=
)  OK
[   19.475412] raid6test: test_disks(14, 28): faila=3D 14(D)  failb=3D 28(D=
)  OK
[   19.476532] raid6test: test_disks(14, 29): faila=3D 14(D)  failb=3D 29(D=
)  OK
[   19.477815] raid6test: test_disks(14, 30): faila=3D 14(D)  failb=3D 30(D=
)  OK
[   19.478947] raid6test: test_disks(14, 31): faila=3D 14(D)  failb=3D 31(D=
)  OK
[   19.480117] raid6test: test_disks(14, 32): faila=3D 14(D)  failb=3D 32(D=
)  OK
[   19.481236] raid6test: test_disks(14, 33): faila=3D 14(D)  failb=3D 33(D=
)  OK
[   19.482351] raid6test: test_disks(14, 34): faila=3D 14(D)  failb=3D 34(D=
)  OK
[   19.483501] raid6test: test_disks(14, 35): faila=3D 14(D)  failb=3D 35(D=
)  OK
[   19.484641] raid6test: test_disks(14, 36): faila=3D 14(D)  failb=3D 36(D=
)  OK
[   19.485785] raid6test: test_disks(14, 37): faila=3D 14(D)  failb=3D 37(D=
)  OK
[   19.487198] raid6test: test_disks(14, 38): faila=3D 14(D)  failb=3D 38(D=
)  OK
[   19.488326] raid6test: test_disks(14, 39): faila=3D 14(D)  failb=3D 39(D=
)  OK
[   19.489436] raid6test: test_disks(14, 40): faila=3D 14(D)  failb=3D 40(D=
)  OK
[   19.490568] raid6test: test_disks(14, 41): faila=3D 14(D)  failb=3D 41(D=
)  OK
[   19.491698] raid6test: test_disks(14, 42): faila=3D 14(D)  failb=3D 42(D=
)  OK
[   19.492813] raid6test: test_disks(14, 43): faila=3D 14(D)  failb=3D 43(D=
)  OK
[   19.493984] raid6test: test_disks(14, 44): faila=3D 14(D)  failb=3D 44(D=
)  OK
[   19.495105] raid6test: test_disks(14, 45): faila=3D 14(D)  failb=3D 45(D=
)  OK
[   19.496223] raid6test: test_disks(14, 46): faila=3D 14(D)  failb=3D 46(D=
)  OK
[   19.510298] raid6test: test_disks(14, 47): faila=3D 14(D)  failb=3D 47(D=
)  OK
[   19.511300] raid6test: test_disks(14, 48): faila=3D 14(D)  failb=3D 48(D=
)  OK
[   19.512280] raid6test: test_disks(14, 49): faila=3D 14(D)  failb=3D 49(D=
)  OK
[   19.513258] raid6test: test_disks(14, 50): faila=3D 14(D)  failb=3D 50(D=
)  OK
[   19.514280] raid6test: test_disks(14, 51): faila=3D 14(D)  failb=3D 51(D=
)  OK
[   19.515256] raid6test: test_disks(14, 52): faila=3D 14(D)  failb=3D 52(D=
)  OK
[   19.516238] raid6test: test_disks(14, 53): faila=3D 14(D)  failb=3D 53(D=
)  OK
[   19.519137] raid6test: test_disks(14, 54): faila=3D 14(D)  failb=3D 54(D=
)  OK
[   19.520189] raid6test: test_disks(14, 55): faila=3D 14(D)  failb=3D 55(D=
)  OK
[   19.521184] raid6test: test_disks(14, 56): faila=3D 14(D)  failb=3D 56(D=
)  OK
[   19.522170] raid6test: test_disks(14, 57): faila=3D 14(D)  failb=3D 57(D=
)  OK
[   19.523152] raid6test: test_disks(14, 58): faila=3D 14(D)  failb=3D 58(D=
)  OK
[   19.524247] raid6test: test_disks(14, 59): faila=3D 14(D)  failb=3D 59(D=
)  OK
[   19.525257] raid6test: test_disks(14, 60): faila=3D 14(D)  failb=3D 60(D=
)  OK
[   19.526351] raid6test: test_disks(14, 61): faila=3D 14(D)  failb=3D 61(D=
)  OK
[   19.527586] raid6test: test_disks(14, 62): faila=3D 14(D)  failb=3D 62(P=
)  OK
[   19.528684] raid6test: test_disks(14, 63): faila=3D 14(D)  failb=3D 63(Q=
)  OK
[   19.529779] raid6test: test_disks(15, 16): faila=3D 15(D)  failb=3D 16(D=
)  OK
[   19.530915] raid6test: test_disks(15, 17): faila=3D 15(D)  failb=3D 17(D=
)  OK
[   19.532008] raid6test: test_disks(15, 18): faila=3D 15(D)  failb=3D 18(D=
)  OK
[   19.533113] raid6test: test_disks(15, 19): faila=3D 15(D)  failb=3D 19(D=
)  OK
[   19.534241] raid6test: test_disks(15, 20): faila=3D 15(D)  failb=3D 20(D=
)  OK
[   19.535387] raid6test: test_disks(15, 21): faila=3D 15(D)  failb=3D 21(D=
)  OK
[   19.536564] raid6test: test_disks(15, 22): faila=3D 15(D)  failb=3D 22(D=
)  OK
[   19.537945] raid6test: test_disks(15, 23): faila=3D 15(D)  failb=3D 23(D=
)  OK
[   19.539079] raid6test: test_disks(15, 24): faila=3D 15(D)  failb=3D 24(D=
)  OK
[   19.540244] raid6test: test_disks(15, 25): faila=3D 15(D)  failb=3D 25(D=
)  OK
[   19.541363] raid6test: test_disks(15, 26): faila=3D 15(D)  failb=3D 26(D=
)  OK
[   19.542502] raid6test: test_disks(15, 27): faila=3D 15(D)  failb=3D 27(D=
)  OK
[   19.543663] raid6test: test_disks(15, 28): faila=3D 15(D)  failb=3D 28(D=
)  OK
[   19.544807] raid6test: test_disks(15, 29): faila=3D 15(D)  failb=3D 29(D=
)  OK
[   19.545909] raid6test: test_disks(15, 30): faila=3D 15(D)  failb=3D 30(D=
)  OK
[   19.559312] raid6test: test_disks(15, 31): faila=3D 15(D)  failb=3D 31(D=
)  OK
[   19.560454] raid6test: test_disks(15, 32): faila=3D 15(D)  failb=3D 32(D=
)  OK
[   19.561579] raid6test: test_disks(15, 33): faila=3D 15(D)  failb=3D 33(D=
)  OK
[   19.562721] raid6test: test_disks(15, 34): faila=3D 15(D)  failb=3D 34(D=
)  OK
[   19.563885] raid6test: test_disks(15, 35): faila=3D 15(D)  failb=3D 35(D=
)  OK
[   19.565022] raid6test: test_disks(15, 36): faila=3D 15(D)  failb=3D 36(D=
)  OK
[   19.566284] raid6test: test_disks(15, 37): faila=3D 15(D)  failb=3D 37(D=
)  OK
[   19.567601] raid6test: test_disks(15, 38): faila=3D 15(D)  failb=3D 38(D=
)  OK
[   19.568726] raid6test: test_disks(15, 39): faila=3D 15(D)  failb=3D 39(D=
)  OK
[   19.569846] raid6test: test_disks(15, 40): faila=3D 15(D)  failb=3D 40(D=
)  OK
[   19.571114] raid6test: test_disks(15, 41): faila=3D 15(D)  failb=3D 41(D=
)  OK
[   19.572240] raid6test: test_disks(15, 42): faila=3D 15(D)  failb=3D 42(D=
)  OK
[   19.573562] raid6test: test_disks(15, 43): faila=3D 15(D)  failb=3D 43(D=
)  OK
[   19.574936] raid6test: test_disks(15, 44): faila=3D 15(D)  failb=3D 44(D=
)  OK
[   19.576265] raid6test: test_disks(15, 45): faila=3D 15(D)  failb=3D 45(D=
)  OK
[   19.577634] raid6test: test_disks(15, 46): faila=3D 15(D)  failb=3D 46(D=
)  OK
[   19.578947] raid6test: test_disks(15, 47): faila=3D 15(D)  failb=3D 47(D=
)  OK
[   19.580528] raid6test: test_disks(15, 48): faila=3D 15(D)  failb=3D 48(D=
)  OK
[   19.581916] raid6test: test_disks(15, 49): faila=3D 15(D)  failb=3D 49(D=
)  OK
[   19.583244] raid6test: test_disks(15, 50): faila=3D 15(D)  failb=3D 50(D=
)  OK
[   19.584810] raid6test: test_disks(15, 51): faila=3D 15(D)  failb=3D 51(D=
)  OK
[   19.586148] raid6test: test_disks(15, 52): faila=3D 15(D)  failb=3D 52(D=
)  OK
[   19.587342] raid6test: test_disks(15, 53): faila=3D 15(D)  failb=3D 53(D=
)  OK
[   19.588467] raid6test: test_disks(15, 54): faila=3D 15(D)  failb=3D 54(D=
)  OK
[   19.589607] raid6test: test_disks(15, 55): faila=3D 15(D)  failb=3D 55(D=
)  OK
[   19.590853] raid6test: test_disks(15, 56): faila=3D 15(D)  failb=3D 56(D=
)  OK
[   19.591998] raid6test: test_disks(15, 57): faila=3D 15(D)  failb=3D 57(D=
)  OK
[   19.593140] raid6test: test_disks(15, 58): faila=3D 15(D)  failb=3D 58(D=
)  OK
[   19.608844] raid6test: test_disks(15, 59): faila=3D 15(D)  failb=3D 59(D=
)  OK
[   19.610318] raid6test: test_disks(15, 60): faila=3D 15(D)  failb=3D 60(D=
)  OK
[   19.611752] raid6test: test_disks(15, 61): faila=3D 15(D)  failb=3D 61(D=
)  OK
[   19.613101] raid6test: test_disks(15, 62): faila=3D 15(D)  failb=3D 62(P=
)  OK
[   19.614259] raid6test: test_disks(15, 63): faila=3D 15(D)  failb=3D 63(Q=
)  OK
[   19.615372] raid6test: test_disks(16, 17): faila=3D 16(D)  failb=3D 17(D=
)  OK
[   19.616495] raid6test: test_disks(16, 18): faila=3D 16(D)  failb=3D 18(D=
)  OK
[   19.617869] raid6test: test_disks(16, 19): faila=3D 16(D)  failb=3D 19(D=
)  OK
[   19.618996] raid6test: test_disks(16, 20): faila=3D 16(D)  failb=3D 20(D=
)  OK
[   19.620146] raid6test: test_disks(16, 21): faila=3D 16(D)  failb=3D 21(D=
)  OK
[   19.621320] raid6test: test_disks(16, 22): faila=3D 16(D)  failb=3D 22(D=
)  OK
[   19.622454] raid6test: test_disks(16, 23): faila=3D 16(D)  failb=3D 23(D=
)  OK
[   19.623610] raid6test: test_disks(16, 24): faila=3D 16(D)  failb=3D 24(D=
)  OK
[   19.624731] raid6test: test_disks(16, 25): faila=3D 16(D)  failb=3D 25(D=
)  OK
[   19.625840] raid6test: test_disks(16, 26): faila=3D 16(D)  failb=3D 26(D=
)  OK
[   19.627762] raid6test: test_disks(16, 27): faila=3D 16(D)  failb=3D 27(D=
)  OK
[   19.629083] raid6test: test_disks(16, 28): faila=3D 16(D)  failb=3D 28(D=
)  OK
[   19.630428] raid6test: test_disks(16, 29): faila=3D 16(D)  failb=3D 29(D=
)  OK
[   19.631766] raid6test: test_disks(16, 30): faila=3D 16(D)  failb=3D 30(D=
)  OK
[   19.633100] raid6test: test_disks(16, 31): faila=3D 16(D)  failb=3D 31(D=
)  OK
[   19.634689] raid6test: test_disks(16, 32): faila=3D 16(D)  failb=3D 32(D=
)  OK
[   19.636024] raid6test: test_disks(16, 33): faila=3D 16(D)  failb=3D 33(D=
)  OK
[   19.651215] raid6test: test_disks(16, 34): faila=3D 16(D)  failb=3D 34(D=
)  OK
[   19.652652] raid6test: test_disks(16, 35): faila=3D 16(D)  failb=3D 35(D=
)  OK
[   19.654008] raid6test: test_disks(16, 36): faila=3D 16(D)  failb=3D 36(D=
)  OK
[   19.655705] raid6test: test_disks(16, 37): faila=3D 16(D)  failb=3D 37(D=
)  OK
[   19.657094] raid6test: test_disks(16, 38): faila=3D 16(D)  failb=3D 38(D=
)  OK
[   19.658421] raid6test: test_disks(16, 39): faila=3D 16(D)  failb=3D 39(D=
)  OK
[   19.659737] raid6test: test_disks(16, 40): faila=3D 16(D)  failb=3D 40(D=
)  OK
[   19.661255] raid6test: test_disks(16, 41): faila=3D 16(D)  failb=3D 41(D=
)  OK
[   19.662806] raid6test: test_disks(16, 42): faila=3D 16(D)  failb=3D 42(D=
)  OK
[   19.664240] raid6test: test_disks(16, 43): faila=3D 16(D)  failb=3D 43(D=
)  OK
[   19.665590] raid6test: test_disks(16, 44): faila=3D 16(D)  failb=3D 44(D=
)  OK
[   19.666743] raid6test: test_disks(16, 45): faila=3D 16(D)  failb=3D 45(D=
)  OK
[   19.667957] raid6test: test_disks(16, 46): faila=3D 16(D)  failb=3D 46(D=
)  OK
[   19.669090] raid6test: test_disks(16, 47): faila=3D 16(D)  failb=3D 47(D=
)  OK
[   19.670477] raid6test: test_disks(16, 48): faila=3D 16(D)  failb=3D 48(D=
)  OK
[   19.671633] raid6test: test_disks(16, 49): faila=3D 16(D)  failb=3D 49(D=
)  OK
[   19.672746] raid6test: test_disks(16, 50): faila=3D 16(D)  failb=3D 50(D=
)  OK
[   19.673910] raid6test: test_disks(16, 51): faila=3D 16(D)  failb=3D 51(D=
)  OK
[   19.675090] raid6test: test_disks(16, 52): faila=3D 16(D)  failb=3D 52(D=
)  OK
[   19.676461] raid6test: test_disks(16, 53): faila=3D 16(D)  failb=3D 53(D=
)  OK
[   19.679570] raid6test: test_disks(16, 54): faila=3D 16(D)  failb=3D 54(D=
)  OK
[   19.695387] raid6test: test_disks(16, 55): faila=3D 16(D)  failb=3D 55(D=
)  OK
[   19.696538] raid6test: test_disks(16, 56): faila=3D 16(D)  failb=3D 56(D=
)  OK
[   19.697874] raid6test: test_disks(16, 57): faila=3D 16(D)  failb=3D 57(D=
)  OK
[   19.699018] raid6test: test_disks(16, 58): faila=3D 16(D)  failb=3D 58(D=
)  OK
[   19.700203] raid6test: test_disks(16, 59): faila=3D 16(D)  failb=3D 59(D=
)  OK
[   19.701387] raid6test: test_disks(16, 60): faila=3D 16(D)  failb=3D 60(D=
)  OK
[   19.702507] raid6test: test_disks(16, 61): faila=3D 16(D)  failb=3D 61(D=
)  OK
[   19.703909] raid6test: test_disks(16, 62): faila=3D 16(D)  failb=3D 62(P=
)  OK
[   19.705394] raid6test: test_disks(16, 63): faila=3D 16(D)  failb=3D 63(Q=
)  OK
[   19.706854] raid6test: test_disks(17, 18): faila=3D 17(D)  failb=3D 18(D=
)  OK
[   19.707973] raid6test: test_disks(17, 19): faila=3D 17(D)  failb=3D 19(D=
)  OK
[   19.709115] raid6test: test_disks(17, 20): faila=3D 17(D)  failb=3D 20(D=
)  OK
[   19.710243] raid6test: test_disks(17, 21): faila=3D 17(D)  failb=3D 21(D=
)  OK
[   19.711382] raid6test: test_disks(17, 22): faila=3D 17(D)  failb=3D 22(D=
)  OK
[   19.712496] raid6test: test_disks(17, 23): faila=3D 17(D)  failb=3D 23(D=
)  OK
[   19.713654] raid6test: test_disks(17, 24): faila=3D 17(D)  failb=3D 24(D=
)  OK
[   19.714739] raid6test: test_disks(17, 25): faila=3D 17(D)  failb=3D 25(D=
)  OK
[   19.715724] raid6test: test_disks(17, 26): faila=3D 17(D)  failb=3D 26(D=
)  OK
[   19.717115] raid6test: test_disks(17, 27): faila=3D 17(D)  failb=3D 27(D=
)  OK
[   19.718103] raid6test: test_disks(17, 28): faila=3D 17(D)  failb=3D 28(D=
)  OK
[   19.719081] raid6test: test_disks(17, 29): faila=3D 17(D)  failb=3D 29(D=
)  OK
[   19.720087] raid6test: test_disks(17, 30): faila=3D 17(D)  failb=3D 30(D=
)  OK
[   19.721068] raid6test: test_disks(17, 31): faila=3D 17(D)  failb=3D 31(D=
)  OK
[   19.722043] raid6test: test_disks(17, 32): faila=3D 17(D)  failb=3D 32(D=
)  OK
[   19.723026] raid6test: test_disks(17, 33): faila=3D 17(D)  failb=3D 33(D=
)  OK
[   19.724049] raid6test: test_disks(17, 34): faila=3D 17(D)  failb=3D 34(D=
)  OK
[   19.725034] raid6test: test_disks(17, 35): faila=3D 17(D)  failb=3D 35(D=
)  OK
[   19.726147] raid6test: test_disks(17, 36): faila=3D 17(D)  failb=3D 36(D=
)  OK
[   19.740471] raid6test: test_disks(17, 37): faila=3D 17(D)  failb=3D 37(D=
)  OK
[   19.741638] raid6test: test_disks(17, 38): faila=3D 17(D)  failb=3D 38(D=
)  OK
[   19.742747] raid6test: test_disks(17, 39): faila=3D 17(D)  failb=3D 39(D=
)  OK
[   19.743877] raid6test: test_disks(17, 40): faila=3D 17(D)  failb=3D 40(D=
)  OK
[   19.744978] raid6test: test_disks(17, 41): faila=3D 17(D)  failb=3D 41(D=
)  OK
[   19.746079] raid6test: test_disks(17, 42): faila=3D 17(D)  failb=3D 42(D=
)  OK
[   19.747197] raid6test: test_disks(17, 43): faila=3D 17(D)  failb=3D 43(D=
)  OK
[   19.748296] raid6test: test_disks(17, 44): faila=3D 17(D)  failb=3D 44(D=
)  OK
[   19.749756] raid6test: test_disks(17, 45): faila=3D 17(D)  failb=3D 45(D=
)  OK
[   19.750932] raid6test: test_disks(17, 46): faila=3D 17(D)  failb=3D 46(D=
)  OK
[   19.752074] raid6test: test_disks(17, 47): faila=3D 17(D)  failb=3D 47(D=
)  OK
[   19.753219] raid6test: test_disks(17, 48): faila=3D 17(D)  failb=3D 48(D=
)  OK
[   19.754490] raid6test: test_disks(17, 49): faila=3D 17(D)  failb=3D 49(D=
)  OK
[   19.755614] raid6test: test_disks(17, 50): faila=3D 17(D)  failb=3D 50(D=
)  OK
[   19.756870] raid6test: test_disks(17, 51): faila=3D 17(D)  failb=3D 51(D=
)  OK
[   19.757992] raid6test: test_disks(17, 52): faila=3D 17(D)  failb=3D 52(D=
)  OK
[   19.759119] raid6test: test_disks(17, 53): faila=3D 17(D)  failb=3D 53(D=
)  OK
[   19.760265] raid6test: test_disks(17, 54): faila=3D 17(D)  failb=3D 54(D=
)  OK
[   19.761362] raid6test: test_disks(17, 55): faila=3D 17(D)  failb=3D 55(D=
)  OK
[   19.762473] raid6test: test_disks(17, 56): faila=3D 17(D)  failb=3D 56(D=
)  OK
[   19.763588] raid6test: test_disks(17, 57): faila=3D 17(D)  failb=3D 57(D=
)  OK
[   19.764688] raid6test: test_disks(17, 58): faila=3D 17(D)  failb=3D 58(D=
)  OK
[   19.765778] raid6test: test_disks(17, 59): faila=3D 17(D)  failb=3D 59(D=
)  OK
[   19.768604] raid6test: test_disks(17, 60): faila=3D 17(D)  failb=3D 60(D=
)  OK
[   19.769777] raid6test: test_disks(17, 61): faila=3D 17(D)  failb=3D 61(D=
)  OK
[   19.770962] raid6test: test_disks(17, 62): faila=3D 17(D)  failb=3D 62(P=
)  OK
[   19.772069] raid6test: test_disks(17, 63): faila=3D 17(D)  failb=3D 63(Q=
)  OK
[   19.773172] raid6test: test_disks(18, 19): faila=3D 18(D)  failb=3D 19(D=
)  OK
[   19.774344] raid6test: test_disks(18, 20): faila=3D 18(D)  failb=3D 20(D=
)  OK
[   19.775463] raid6test: test_disks(18, 21): faila=3D 18(D)  failb=3D 21(D=
)  OK
[   19.776597] raid6test: test_disks(18, 22): faila=3D 18(D)  failb=3D 22(D=
)  OK
[   19.797210] raid6test: test_disks(18, 23): faila=3D 18(D)  failb=3D 23(D=
)  OK
[   19.798215] raid6test: test_disks(18, 24): faila=3D 18(D)  failb=3D 24(D=
)  OK
[   19.799194] raid6test: test_disks(18, 25): faila=3D 18(D)  failb=3D 25(D=
)  OK
[   19.800203] raid6test: test_disks(18, 26): faila=3D 18(D)  failb=3D 26(D=
)  OK
[   19.801193] raid6test: test_disks(18, 27): faila=3D 18(D)  failb=3D 27(D=
)  OK
[   19.802174] raid6test: test_disks(18, 28): faila=3D 18(D)  failb=3D 28(D=
)  OK
[   19.803157] raid6test: test_disks(18, 29): faila=3D 18(D)  failb=3D 29(D=
)  OK
[   19.804318] raid6test: test_disks(18, 30): faila=3D 18(D)  failb=3D 30(D=
)  OK
[   19.805439] raid6test: test_disks(18, 31): faila=3D 18(D)  failb=3D 31(D=
)  OK
[   19.806555] raid6test: test_disks(18, 32): faila=3D 18(D)  failb=3D 32(D=
)  OK
[   19.808462] raid6test: test_disks(18, 33): faila=3D 18(D)  failb=3D 33(D=
)  OK
[   19.809558] raid6test: test_disks(18, 34): faila=3D 18(D)  failb=3D 34(D=
)  OK
[   19.810722] raid6test: test_disks(18, 35): faila=3D 18(D)  failb=3D 35(D=
)  OK
[   19.811872] raid6test: test_disks(18, 36): faila=3D 18(D)  failb=3D 36(D=
)  OK
[   19.812993] raid6test: test_disks(18, 37): faila=3D 18(D)  failb=3D 37(D=
)  OK
[   19.814243] raid6test: test_disks(18, 38): faila=3D 18(D)  failb=3D 38(D=
)  OK
[   19.815359] raid6test: test_disks(18, 39): faila=3D 18(D)  failb=3D 39(D=
)  OK
[   19.816473] raid6test: test_disks(18, 40): faila=3D 18(D)  failb=3D 40(D=
)  OK
[   19.817751] raid6test: test_disks(18, 41): faila=3D 18(D)  failb=3D 41(D=
)  OK
[   19.818870] raid6test: test_disks(18, 42): faila=3D 18(D)  failb=3D 42(D=
)  OK
[   19.819979] raid6test: test_disks(18, 43): faila=3D 18(D)  failb=3D 43(D=
)  OK
[   19.821121] raid6test: test_disks(18, 44): faila=3D 18(D)  failb=3D 44(D=
)  OK
[   19.822214] raid6test: test_disks(18, 45): faila=3D 18(D)  failb=3D 45(D=
)  OK
[   19.823305] raid6test: test_disks(18, 46): faila=3D 18(D)  failb=3D 46(D=
)  OK
[   19.824465] raid6test: test_disks(18, 47): faila=3D 18(D)  failb=3D 47(D=
)  OK
[   19.825603] raid6test: test_disks(18, 48): faila=3D 18(D)  failb=3D 48(D=
)  OK
[   19.826951] raid6test: test_disks(18, 49): faila=3D 18(D)  failb=3D 49(D=
)  OK
[   19.828053] raid6test: test_disks(18, 50): faila=3D 18(D)  failb=3D 50(D=
)  OK
[   19.829142] raid6test: test_disks(18, 51): faila=3D 18(D)  failb=3D 51(D=
)  OK
[   19.830256] raid6test: test_disks(18, 52): faila=3D 18(D)  failb=3D 52(D=
)  OK
[   19.831362] raid6test: test_disks(18, 53): faila=3D 18(D)  failb=3D 53(D=
)  OK
[   19.832522] raid6test: test_disks(18, 54): faila=3D 18(D)  failb=3D 54(D=
)  OK
[   19.833725] raid6test: test_disks(18, 55): faila=3D 18(D)  failb=3D 55(D=
)  OK
[   19.834846] raid6test: test_disks(18, 56): faila=3D 18(D)  failb=3D 56(D=
)  OK
[   19.835982] raid6test: test_disks(18, 57): faila=3D 18(D)  failb=3D 57(D=
)  OK
[   19.850340] raid6test: test_disks(18, 58): faila=3D 18(D)  failb=3D 58(D=
)  OK
[   19.851493] raid6test: test_disks(18, 59): faila=3D 18(D)  failb=3D 59(D=
)  OK
[   19.852612] raid6test: test_disks(18, 60): faila=3D 18(D)  failb=3D 60(D=
)  OK
[   19.853764] raid6test: test_disks(18, 61): faila=3D 18(D)  failb=3D 61(D=
)  OK
[   19.854782] raid6test: test_disks(18, 62): faila=3D 18(D)  failb=3D 62(P=
)  OK
[   19.855766] raid6test: test_disks(18, 63): faila=3D 18(D)  failb=3D 63(Q=
)  OK
[   19.856788] raid6test: test_disks(19, 20): faila=3D 19(D)  failb=3D 20(D=
)  OK
[   19.857786] raid6test: test_disks(19, 21): faila=3D 19(D)  failb=3D 21(D=
)  OK
[   19.858780] raid6test: test_disks(19, 22): faila=3D 19(D)  failb=3D 22(D=
)  OK
[   19.859779] raid6test: test_disks(19, 23): faila=3D 19(D)  failb=3D 23(D=
)  OK
[   19.860805] raid6test: test_disks(19, 24): faila=3D 19(D)  failb=3D 24(D=
)  OK
[   19.861799] raid6test: test_disks(19, 25): faila=3D 19(D)  failb=3D 25(D=
)  OK
[   19.862790] raid6test: test_disks(19, 26): faila=3D 19(D)  failb=3D 26(D=
)  OK
[   19.863969] raid6test: test_disks(19, 27): faila=3D 19(D)  failb=3D 27(D=
)  OK
[   19.864949] raid6test: test_disks(19, 28): faila=3D 19(D)  failb=3D 28(D=
)  OK
[   19.865921] raid6test: test_disks(19, 29): faila=3D 19(D)  failb=3D 29(D=
)  OK
[   19.867006] raid6test: test_disks(19, 30): faila=3D 19(D)  failb=3D 30(D=
)  OK
[   19.867982] raid6test: test_disks(19, 31): faila=3D 19(D)  failb=3D 31(D=
)  OK
[   19.868962] raid6test: test_disks(19, 32): faila=3D 19(D)  failb=3D 32(D=
)  OK
[   19.869940] raid6test: test_disks(19, 33): faila=3D 19(D)  failb=3D 33(D=
)  OK
[   19.871247] raid6test: test_disks(19, 34): faila=3D 19(D)  failb=3D 34(D=
)  OK
[   19.872367] raid6test: test_disks(19, 35): faila=3D 19(D)  failb=3D 35(D=
)  OK
[   19.873537] raid6test: test_disks(19, 36): faila=3D 19(D)  failb=3D 36(D=
)  OK
[   19.874657] raid6test: test_disks(19, 37): faila=3D 19(D)  failb=3D 37(D=
)  OK
[   19.875787] raid6test: test_disks(19, 38): faila=3D 19(D)  failb=3D 38(D=
)  OK
[   19.876948] raid6test: test_disks(19, 39): faila=3D 19(D)  failb=3D 39(D=
)  OK
[   19.878083] raid6test: test_disks(19, 40): faila=3D 19(D)  failb=3D 40(D=
)  OK
[   19.879215] raid6test: test_disks(19, 41): faila=3D 19(D)  failb=3D 41(D=
)  OK
[   19.880555] raid6test: test_disks(19, 42): faila=3D 19(D)  failb=3D 42(D=
)  OK
[   19.881656] raid6test: test_disks(19, 43): faila=3D 19(D)  failb=3D 43(D=
)  OK
[   19.882745] raid6test: test_disks(19, 44): faila=3D 19(D)  failb=3D 44(D=
)  OK
[   19.883859] raid6test: test_disks(19, 45): faila=3D 19(D)  failb=3D 45(D=
)  OK
[   19.884954] raid6test: test_disks(19, 46): faila=3D 19(D)  failb=3D 46(D=
)  OK
[   19.886054] raid6test: test_disks(19, 47): faila=3D 19(D)  failb=3D 47(D=
)  OK
[   19.887179] raid6test: test_disks(19, 48): faila=3D 19(D)  failb=3D 48(D=
)  OK
[   19.888279] raid6test: test_disks(19, 49): faila=3D 19(D)  failb=3D 49(D=
)  OK
[   19.889378] raid6test: test_disks(19, 50): faila=3D 19(D)  failb=3D 50(D=
)  OK
[   19.909674] raid6test: test_disks(19, 51): faila=3D 19(D)  failb=3D 51(D=
)  OK
[   19.910817] raid6test: test_disks(19, 52): faila=3D 19(D)  failb=3D 52(D=
)  OK
[   19.911975] raid6test: test_disks(19, 53): faila=3D 19(D)  failb=3D 53(D=
)  OK
[   19.913106] raid6test: test_disks(19, 54): faila=3D 19(D)  failb=3D 54(D=
)  OK
[   19.914288] raid6test: test_disks(19, 55): faila=3D 19(D)  failb=3D 55(D=
)  OK
[   19.915410] raid6test: test_disks(19, 56): faila=3D 19(D)  failb=3D 56(D=
)  OK
[   19.917093] raid6test: test_disks(19, 57): faila=3D 19(D)  failb=3D 57(D=
)  OK
[   19.918340] raid6test: test_disks(19, 58): faila=3D 19(D)  failb=3D 58(D=
)  OK
[   19.919453] raid6test: test_disks(19, 59): faila=3D 19(D)  failb=3D 59(D=
)  OK
[   19.920845] raid6test: test_disks(19, 60): faila=3D 19(D)  failb=3D 60(D=
)  OK
[   19.922201] raid6test: test_disks(19, 61): faila=3D 19(D)  failb=3D 61(D=
)  OK
[   19.923660] raid6test: test_disks(19, 62): faila=3D 19(D)  failb=3D 62(P=
)  OK
[   19.925070] raid6test: test_disks(19, 63): faila=3D 19(D)  failb=3D 63(Q=
)  OK
[   19.926198] raid6test: test_disks(20, 21): faila=3D 20(D)  failb=3D 21(D=
)  OK
[   19.927394] raid6test: test_disks(20, 22): faila=3D 20(D)  failb=3D 22(D=
)  OK
[   19.928751] raid6test: test_disks(20, 23): faila=3D 20(D)  failb=3D 23(D=
)  OK
[   19.930120] raid6test: test_disks(20, 24): faila=3D 20(D)  failb=3D 24(D=
)  OK
[   19.931464] raid6test: test_disks(20, 25): faila=3D 20(D)  failb=3D 25(D=
)  OK
[   19.932795] raid6test: test_disks(20, 26): faila=3D 20(D)  failb=3D 26(D=
)  OK
[   19.934614] raid6test: test_disks(20, 27): faila=3D 20(D)  failb=3D 27(D=
)  OK
[   19.935738] raid6test: test_disks(20, 28): faila=3D 20(D)  failb=3D 28(D=
)  OK
[   19.936901] raid6test: test_disks(20, 29): faila=3D 20(D)  failb=3D 29(D=
)  OK
[   19.938035] raid6test: test_disks(20, 30): faila=3D 20(D)  failb=3D 30(D=
)  OK
[   19.939155] raid6test: test_disks(20, 31): faila=3D 20(D)  failb=3D 31(D=
)  OK
[   19.940302] raid6test: test_disks(20, 32): faila=3D 20(D)  failb=3D 32(D=
)  OK
[   19.941533] raid6test: test_disks(20, 33): faila=3D 20(D)  failb=3D 33(D=
)  OK
[   19.942654] raid6test: test_disks(20, 34): faila=3D 20(D)  failb=3D 34(D=
)  OK
[   19.961327] raid6test: test_disks(20, 35): faila=3D 20(D)  failb=3D 35(D=
)  OK
[   19.962489] raid6test: test_disks(20, 36): faila=3D 20(D)  failb=3D 36(D=
)  OK
[   19.963638] raid6test: test_disks(20, 37): faila=3D 20(D)  failb=3D 37(D=
)  OK
[   19.964708] raid6test: test_disks(20, 38): faila=3D 20(D)  failb=3D 38(D=
)  OK
[   19.965692] raid6test: test_disks(20, 39): faila=3D 20(D)  failb=3D 39(D=
)  OK
[   19.966715] raid6test: test_disks(20, 40): faila=3D 20(D)  failb=3D 40(D=
)  OK
[   19.967714] raid6test: test_disks(20, 41): faila=3D 20(D)  failb=3D 41(D=
)  OK
[   19.968702] raid6test: test_disks(20, 42): faila=3D 20(D)  failb=3D 42(D=
)  OK
[   19.969693] raid6test: test_disks(20, 43): faila=3D 20(D)  failb=3D 43(D=
)  OK
[   19.972184] raid6test: test_disks(20, 44): faila=3D 20(D)  failb=3D 44(D=
)  OK
[   19.973168] raid6test: test_disks(20, 45): faila=3D 20(D)  failb=3D 45(D=
)  OK
[   19.974225] raid6test: test_disks(20, 46): faila=3D 20(D)  failb=3D 46(D=
)  OK
[   19.975211] raid6test: test_disks(20, 47): faila=3D 20(D)  failb=3D 47(D=
)  OK
[   19.976193] raid6test: test_disks(20, 48): faila=3D 20(D)  failb=3D 48(D=
)  OK
[   19.977298] raid6test: test_disks(20, 49): faila=3D 20(D)  failb=3D 49(D=
)  OK
[   19.978276] raid6test: test_disks(20, 50): faila=3D 20(D)  failb=3D 50(D=
)  OK
[   19.979279] raid6test: test_disks(20, 51): faila=3D 20(D)  failb=3D 51(D=
)  OK
[   19.980526] raid6test: test_disks(20, 52): faila=3D 20(D)  failb=3D 52(D=
)  OK
[   19.981626] raid6test: test_disks(20, 53): faila=3D 20(D)  failb=3D 53(D=
)  OK
[   19.982711] raid6test: test_disks(20, 54): faila=3D 20(D)  failb=3D 54(D=
)  OK
[   19.983829] raid6test: test_disks(20, 55): faila=3D 20(D)  failb=3D 55(D=
)  OK
[   19.984960] raid6test: test_disks(20, 56): faila=3D 20(D)  failb=3D 56(D=
)  OK
[   19.986063] raid6test: test_disks(20, 57): faila=3D 20(D)  failb=3D 57(D=
)  OK
[   19.987194] raid6test: test_disks(20, 58): faila=3D 20(D)  failb=3D 58(D=
)  OK
[   19.988297] raid6test: test_disks(20, 59): faila=3D 20(D)  failb=3D 59(D=
)  OK
[   19.989396] raid6test: test_disks(20, 60): faila=3D 20(D)  failb=3D 60(D=
)  OK
[   19.991051] raid6test: test_disks(20, 61): faila=3D 20(D)  failb=3D 61(D=
)  OK
[   19.992165] raid6test: test_disks(20, 62): faila=3D 20(D)  failb=3D 62(P=
)  OK
[   19.993284] raid6test: test_disks(20, 63): faila=3D 20(D)  failb=3D 63(Q=
)  OK
[   19.994444] raid6test: test_disks(21, 22): faila=3D 21(D)  failb=3D 22(D=
)  OK
[   19.995573] raid6test: test_disks(21, 23): faila=3D 21(D)  failb=3D 23(D=
)  OK
[   19.998001] raid6test: test_disks(21, 24): faila=3D 21(D)  failb=3D 24(D=
)  OK
[   19.999144] raid6test: test_disks(21, 25): faila=3D 21(D)  failb=3D 25(D=
)  OK
[   20.016335] raid6test: test_disks(21, 26): faila=3D 21(D)  failb=3D 26(D=
)  OK
[   20.017537] raid6test: test_disks(21, 27): faila=3D 21(D)  failb=3D 27(D=
)  OK
[   20.018657] raid6test: test_disks(21, 28): faila=3D 21(D)  failb=3D 28(D=
)  OK
[   20.019703] raid6test: test_disks(21, 29): faila=3D 21(D)  failb=3D 29(D=
)  OK
[   20.020711] raid6test: test_disks(21, 30): faila=3D 21(D)  failb=3D 30(D=
)  OK
[   20.021693] raid6test: test_disks(21, 31): faila=3D 21(D)  failb=3D 31(D=
)  OK
[   20.022677] raid6test: test_disks(21, 32): faila=3D 21(D)  failb=3D 32(D=
)  OK
[   20.023696] raid6test: test_disks(21, 33): faila=3D 21(D)  failb=3D 33(D=
)  OK
[   20.024681] raid6test: test_disks(21, 34): faila=3D 21(D)  failb=3D 34(D=
)  OK
[   20.028586] raid6test: test_disks(21, 35): faila=3D 21(D)  failb=3D 35(D=
)  OK
[   20.029576] raid6test: test_disks(21, 36): faila=3D 21(D)  failb=3D 36(D=
)  OK
[   20.030627] raid6test: test_disks(21, 37): faila=3D 21(D)  failb=3D 37(D=
)  OK
[   20.031621] raid6test: test_disks(21, 38): faila=3D 21(D)  failb=3D 38(D=
)  OK
[   20.032600] raid6test: test_disks(21, 39): faila=3D 21(D)  failb=3D 39(D=
)  OK
[   20.033712] raid6test: test_disks(21, 40): faila=3D 21(D)  failb=3D 40(D=
)  OK
[   20.034776] raid6test: test_disks(21, 41): faila=3D 21(D)  failb=3D 41(D=
)  OK
[   20.035877] raid6test: test_disks(21, 42): faila=3D 21(D)  failb=3D 42(D=
)  OK
[   20.037140] raid6test: test_disks(21, 43): faila=3D 21(D)  failb=3D 43(D=
)  OK
[   20.038233] raid6test: test_disks(21, 44): faila=3D 21(D)  failb=3D 44(D=
)  OK
[   20.039362] raid6test: test_disks(21, 45): faila=3D 21(D)  failb=3D 45(D=
)  OK
[   20.040490] raid6test: test_disks(21, 46): faila=3D 21(D)  failb=3D 46(D=
)  OK
[   20.041590] raid6test: test_disks(21, 47): faila=3D 21(D)  failb=3D 47(D=
)  OK
[   20.042684] raid6test: test_disks(21, 48): faila=3D 21(D)  failb=3D 48(D=
)  OK
[   20.043812] raid6test: test_disks(21, 49): faila=3D 21(D)  failb=3D 49(D=
)  OK
[   20.044940] raid6test: test_disks(21, 50): faila=3D 21(D)  failb=3D 50(D=
)  OK
[   20.046102] raid6test: test_disks(21, 51): faila=3D 21(D)  failb=3D 51(D=
)  OK
[   20.047756] raid6test: test_disks(21, 52): faila=3D 21(D)  failb=3D 52(D=
)  OK
[   20.048891] raid6test: test_disks(21, 53): faila=3D 21(D)  failb=3D 53(D=
)  OK
[   20.050055] raid6test: test_disks(21, 54): faila=3D 21(D)  failb=3D 54(D=
)  OK
[   20.051176] raid6test: test_disks(21, 55): faila=3D 21(D)  failb=3D 55(D=
)  OK
[   20.052318] raid6test: test_disks(21, 56): faila=3D 21(D)  failb=3D 56(D=
)  OK
[   20.053476] raid6test: test_disks(21, 57): faila=3D 21(D)  failb=3D 57(D=
)  OK
[   20.054593] raid6test: test_disks(21, 58): faila=3D 21(D)  failb=3D 58(D=
)  OK
[   20.055709] raid6test: test_disks(21, 59): faila=3D 21(D)  failb=3D 59(D=
)  OK
[   20.069341] raid6test: test_disks(21, 60): faila=3D 21(D)  failb=3D 60(D=
)  OK
[   20.070508] raid6test: test_disks(21, 61): faila=3D 21(D)  failb=3D 61(D=
)  OK
[   20.071547] raid6test: test_disks(21, 62): faila=3D 21(D)  failb=3D 62(P=
)  OK
[   20.072544] raid6test: test_disks(21, 63): faila=3D 21(D)  failb=3D 63(Q=
)  OK
[   20.073560] raid6test: test_disks(22, 23): faila=3D 22(D)  failb=3D 23(D=
)  OK
[   20.074551] raid6test: test_disks(22, 24): faila=3D 22(D)  failb=3D 24(D=
)  OK
[   20.075542] raid6test: test_disks(22, 25): faila=3D 22(D)  failb=3D 25(D=
)  OK
[   20.076537] raid6test: test_disks(22, 26): faila=3D 22(D)  failb=3D 26(D=
)  OK
[   20.077577] raid6test: test_disks(22, 27): faila=3D 22(D)  failb=3D 27(D=
)  OK
[   20.078834] raid6test: test_disks(22, 28): faila=3D 22(D)  failb=3D 28(D=
)  OK
[   20.079814] raid6test: test_disks(22, 29): faila=3D 22(D)  failb=3D 29(D=
)  OK
[   20.080878] raid6test: test_disks(22, 30): faila=3D 22(D)  failb=3D 30(D=
)  OK
[   20.081864] raid6test: test_disks(22, 31): faila=3D 22(D)  failb=3D 31(D=
)  OK
[   20.082847] raid6test: test_disks(22, 32): faila=3D 22(D)  failb=3D 32(D=
)  OK
[   20.083949] raid6test: test_disks(22, 33): faila=3D 22(D)  failb=3D 33(D=
)  OK
[   20.084932] raid6test: test_disks(22, 34): faila=3D 22(D)  failb=3D 34(D=
)  OK
[   20.086026] raid6test: test_disks(22, 35): faila=3D 22(D)  failb=3D 35(D=
)  OK
[   20.087287] raid6test: test_disks(22, 36): faila=3D 22(D)  failb=3D 36(D=
)  OK
[   20.088379] raid6test: test_disks(22, 37): faila=3D 22(D)  failb=3D 37(D=
)  OK
[   20.089469] raid6test: test_disks(22, 38): faila=3D 22(D)  failb=3D 38(D=
)  OK
[   20.090593] raid6test: test_disks(22, 39): faila=3D 22(D)  failb=3D 39(D=
)  OK
[   20.091684] raid6test: test_disks(22, 40): faila=3D 22(D)  failb=3D 40(D=
)  OK
[   20.092773] raid6test: test_disks(22, 41): faila=3D 22(D)  failb=3D 41(D=
)  OK
[   20.093900] raid6test: test_disks(22, 42): faila=3D 22(D)  failb=3D 42(D=
)  OK
[   20.094997] raid6test: test_disks(22, 43): faila=3D 22(D)  failb=3D 43(D=
)  OK
[   20.099865] raid6test: test_disks(22, 44): faila=3D 22(D)  failb=3D 44(D=
)  OK
[   20.101070] raid6test: test_disks(22, 45): faila=3D 22(D)  failb=3D 45(D=
)  OK
[   20.102192] raid6test: test_disks(22, 46): faila=3D 22(D)  failb=3D 46(D=
)  OK
[   20.103314] raid6test: test_disks(22, 47): faila=3D 22(D)  failb=3D 47(D=
)  OK
[   20.104561] raid6test: test_disks(22, 48): faila=3D 22(D)  failb=3D 48(D=
)  OK
[   20.105684] raid6test: test_disks(22, 49): faila=3D 22(D)  failb=3D 49(D=
)  OK
[   20.119239] raid6test: test_disks(22, 50): faila=3D 22(D)  failb=3D 50(D=
)  OK
[   20.120412] raid6test: test_disks(22, 51): faila=3D 22(D)  failb=3D 51(D=
)  OK
[   20.121525] raid6test: test_disks(22, 52): faila=3D 22(D)  failb=3D 52(D=
)  OK
[   20.122646] raid6test: test_disks(22, 53): faila=3D 22(D)  failb=3D 53(D=
)  OK
[   20.123803] raid6test: test_disks(22, 54): faila=3D 22(D)  failb=3D 54(D=
)  OK
[   20.124919] raid6test: test_disks(22, 55): faila=3D 22(D)  failb=3D 55(D=
)  OK
[   20.126092] raid6test: test_disks(22, 56): faila=3D 22(D)  failb=3D 56(D=
)  OK
[   20.127274] raid6test: test_disks(22, 57): faila=3D 22(D)  failb=3D 57(D=
)  OK
[   20.129154] raid6test: test_disks(22, 58): faila=3D 22(D)  failb=3D 58(D=
)  OK
[   20.130369] raid6test: test_disks(22, 59): faila=3D 22(D)  failb=3D 59(D=
)  OK
[   20.131352] raid6test: test_disks(22, 60): faila=3D 22(D)  failb=3D 60(D=
)  OK
[   20.132332] raid6test: test_disks(22, 61): faila=3D 22(D)  failb=3D 61(D=
)  OK
[   20.133309] raid6test: test_disks(22, 62): faila=3D 22(D)  failb=3D 62(P=
)  OK
[   20.134417] raid6test: test_disks(22, 63): faila=3D 22(D)  failb=3D 63(Q=
)  OK
[   20.135404] raid6test: test_disks(23, 24): faila=3D 23(D)  failb=3D 24(D=
)  OK
[   20.136400] raid6test: test_disks(23, 25): faila=3D 23(D)  failb=3D 25(D=
)  OK
[   20.137537] raid6test: test_disks(23, 26): faila=3D 23(D)  failb=3D 26(D=
)  OK
[   20.138516] raid6test: test_disks(23, 27): faila=3D 23(D)  failb=3D 27(D=
)  OK
[   20.139507] raid6test: test_disks(23, 28): faila=3D 23(D)  failb=3D 28(D=
)  OK
[   20.140514] raid6test: test_disks(23, 29): faila=3D 23(D)  failb=3D 29(D=
)  OK
[   20.141502] raid6test: test_disks(23, 30): faila=3D 23(D)  failb=3D 30(D=
)  OK
[   20.142483] raid6test: test_disks(23, 31): faila=3D 23(D)  failb=3D 31(D=
)  OK
[   20.143497] raid6test: test_disks(23, 32): faila=3D 23(D)  failb=3D 32(D=
)  OK
[   20.144480] raid6test: test_disks(23, 33): faila=3D 23(D)  failb=3D 33(D=
)  OK
[   20.145522] raid6test: test_disks(23, 34): faila=3D 23(D)  failb=3D 34(D=
)  OK
[   20.146625] raid6test: test_disks(23, 35): faila=3D 23(D)  failb=3D 35(D=
)  OK
[   20.148004] raid6test: test_disks(23, 36): faila=3D 23(D)  failb=3D 36(D=
)  OK
[   20.149109] raid6test: test_disks(23, 37): faila=3D 23(D)  failb=3D 37(D=
)  OK
[   20.150274] raid6test: test_disks(23, 38): faila=3D 23(D)  failb=3D 38(D=
)  OK
[   20.151374] raid6test: test_disks(23, 39): faila=3D 23(D)  failb=3D 39(D=
)  OK
[   20.152470] raid6test: test_disks(23, 40): faila=3D 23(D)  failb=3D 40(D=
)  OK
[   20.153642] raid6test: test_disks(23, 41): faila=3D 23(D)  failb=3D 41(D=
)  OK
[   20.154778] raid6test: test_disks(23, 42): faila=3D 23(D)  failb=3D 42(D=
)  OK
[   20.155913] raid6test: test_disks(23, 43): faila=3D 23(D)  failb=3D 43(D=
)  OK
[   20.173339] raid6test: test_disks(23, 44): faila=3D 23(D)  failb=3D 44(D=
)  OK
[   20.174498] raid6test: test_disks(23, 45): faila=3D 23(D)  failb=3D 45(D=
)  OK
[   20.175607] raid6test: test_disks(23, 46): faila=3D 23(D)  failb=3D 46(D=
)  OK
[   20.176759] raid6test: test_disks(23, 47): faila=3D 23(D)  failb=3D 47(D=
)  OK
[   20.177899] raid6test: test_disks(23, 48): faila=3D 23(D)  failb=3D 48(D=
)  OK
[   20.179026] raid6test: test_disks(23, 49): faila=3D 23(D)  failb=3D 49(D=
)  OK
[   20.180160] raid6test: test_disks(23, 50): faila=3D 23(D)  failb=3D 50(D=
)  OK
[   20.181272] raid6test: test_disks(23, 51): faila=3D 23(D)  failb=3D 51(D=
)  OK
[   20.190568] raid6test: test_disks(23, 52): faila=3D 23(D)  failb=3D 52(D=
)  OK
[   20.191558] raid6test: test_disks(23, 53): faila=3D 23(D)  failb=3D 53(D=
)  OK
[   20.192545] raid6test: test_disks(23, 54): faila=3D 23(D)  failb=3D 54(D=
)  OK
[   20.193550] raid6test: test_disks(23, 55): faila=3D 23(D)  failb=3D 55(D=
)  OK
[   20.194548] raid6test: test_disks(23, 56): faila=3D 23(D)  failb=3D 56(D=
)  OK
[   20.203699] raid6test: test_disks(23, 57): faila=3D 23(D)  failb=3D 57(D=
)  OK
[   20.203810] raid6test: test_disks(23, 58): faila=3D 23(D)  failb=3D 58(D=
)  OK
[   20.203810] raid6test: test_disks(23, 59): faila=3D 23(D)  failb=3D 59(D=
)  OK
[   20.207031] raid6test: test_disks(23, 60): faila=3D 23(D)  failb=3D 60(D=
)  OK
[   20.208132] raid6test: test_disks(23, 61): faila=3D 23(D)  failb=3D 61(D=
)  OK
[   20.209228] raid6test: test_disks(23, 62): faila=3D 23(D)  failb=3D 62(P=
)  OK
[   20.236299] raid6test: test_disks(23, 63): faila=3D 23(D)  failb=3D 63(Q=
)  OK
[   20.237463] raid6test: test_disks(24, 25): faila=3D 24(D)  failb=3D 25(D=
)  OK
[   20.238582] raid6test: test_disks(24, 26): faila=3D 24(D)  failb=3D 26(D=
)  OK
[   20.239691] raid6test: test_disks(24, 27): faila=3D 24(D)  failb=3D 27(D=
)  OK
[   20.240808] raid6test: test_disks(24, 28): faila=3D 24(D)  failb=3D 28(D=
)  OK
[   20.241917] raid6test: test_disks(24, 29): faila=3D 24(D)  failb=3D 29(D=
)  OK
[   20.243051] raid6test: test_disks(24, 30): faila=3D 24(D)  failb=3D 30(D=
)  OK
[   20.244202] raid6test: test_disks(24, 31): faila=3D 24(D)  failb=3D 31(D=
)  OK
[   20.253834] raid6test: test_disks(24, 32): faila=3D 24(D)  failb=3D 32(D=
)  OK
[   20.254825] raid6test: test_disks(24, 33): faila=3D 24(D)  failb=3D 33(D=
)  OK
[   20.255808] raid6test: test_disks(24, 34): faila=3D 24(D)  failb=3D 34(D=
)  OK
[   20.256855] raid6test: test_disks(24, 35): faila=3D 24(D)  failb=3D 35(D=
)  OK
[   20.257841] raid6test: test_disks(24, 36): faila=3D 24(D)  failb=3D 36(D=
)  OK
[   20.258825] raid6test: test_disks(24, 37): faila=3D 24(D)  failb=3D 37(D=
)  OK
[   20.259809] raid6test: test_disks(24, 38): faila=3D 24(D)  failb=3D 38(D=
)  OK
[   20.261029] raid6test: test_disks(24, 39): faila=3D 24(D)  failb=3D 39(D=
)  OK
[   20.262123] raid6test: test_disks(24, 40): faila=3D 24(D)  failb=3D 40(D=
)  OK
[   20.263227] raid6test: test_disks(24, 41): faila=3D 24(D)  failb=3D 41(D=
)  OK
[   20.264410] raid6test: test_disks(24, 42): faila=3D 24(D)  failb=3D 42(D=
)  OK
[   20.265511] raid6test: test_disks(24, 43): faila=3D 24(D)  failb=3D 43(D=
)  OK
[   20.266612] raid6test: test_disks(24, 44): faila=3D 24(D)  failb=3D 44(D=
)  OK
[   20.267938] raid6test: test_disks(24, 45): faila=3D 24(D)  failb=3D 45(D=
)  OK
[   20.269038] raid6test: test_disks(24, 46): faila=3D 24(D)  failb=3D 46(D=
)  OK
[   20.270206] raid6test: test_disks(24, 47): faila=3D 24(D)  failb=3D 47(D=
)  OK
[   20.271364] raid6test: test_disks(24, 48): faila=3D 24(D)  failb=3D 48(D=
)  OK
[   20.272494] raid6test: test_disks(24, 49): faila=3D 24(D)  failb=3D 49(D=
)  OK
[   20.273812] raid6test: test_disks(24, 50): faila=3D 24(D)  failb=3D 50(D=
)  OK
[   20.274917] raid6test: test_disks(24, 51): faila=3D 24(D)  failb=3D 51(D=
)  OK
[   20.276035] raid6test: test_disks(24, 52): faila=3D 24(D)  failb=3D 52(D=
)  OK
[   20.296346] raid6test: test_disks(24, 53): faila=3D 24(D)  failb=3D 53(D=
)  OK
[   20.297525] raid6test: test_disks(24, 54): faila=3D 24(D)  failb=3D 54(D=
)  OK
[   20.298639] raid6test: test_disks(24, 55): faila=3D 24(D)  failb=3D 55(D=
)  OK
[   20.299755] raid6test: test_disks(24, 56): faila=3D 24(D)  failb=3D 56(D=
)  OK
[   20.300932] raid6test: test_disks(24, 57): faila=3D 24(D)  failb=3D 57(D=
)  OK
[   20.302076] raid6test: test_disks(24, 58): faila=3D 24(D)  failb=3D 58(D=
)  OK
[   20.303191] raid6test: test_disks(24, 59): faila=3D 24(D)  failb=3D 59(D=
)  OK
[   20.304389] raid6test: test_disks(24, 60): faila=3D 24(D)  failb=3D 60(D=
)  OK
[   20.305512] raid6test: test_disks(24, 61): faila=3D 24(D)  failb=3D 61(D=
)  OK
[   20.306634] raid6test: test_disks(24, 62): faila=3D 24(D)  failb=3D 62(P=
)  OK
[   20.307739] raid6test: test_disks(24, 63): faila=3D 24(D)  failb=3D 63(Q=
)  OK
[   20.308721] raid6test: test_disks(25, 26): faila=3D 25(D)  failb=3D 26(D=
)  OK
[   20.309791] raid6test: test_disks(25, 27): faila=3D 25(D)  failb=3D 27(D=
)  OK
[   20.310801] raid6test: test_disks(25, 28): faila=3D 25(D)  failb=3D 28(D=
)  OK
[   20.311783] raid6test: test_disks(25, 29): faila=3D 25(D)  failb=3D 29(D=
)  OK
[   20.312763] raid6test: test_disks(25, 30): faila=3D 25(D)  failb=3D 30(D=
)  OK
[   20.313779] raid6test: test_disks(25, 31): faila=3D 25(D)  failb=3D 31(D=
)  OK
[   20.314758] raid6test: test_disks(25, 32): faila=3D 25(D)  failb=3D 32(D=
)  OK
[   20.315734] raid6test: test_disks(25, 33): faila=3D 25(D)  failb=3D 33(D=
)  OK
[   20.316872] raid6test: test_disks(25, 34): faila=3D 25(D)  failb=3D 34(D=
)  OK
[   20.317860] raid6test: test_disks(25, 35): faila=3D 25(D)  failb=3D 35(D=
)  OK
[   20.318837] raid6test: test_disks(25, 36): faila=3D 25(D)  failb=3D 36(D=
)  OK
[   20.319813] raid6test: test_disks(25, 37): faila=3D 25(D)  failb=3D 37(D=
)  OK
[   20.320916] raid6test: test_disks(25, 38): faila=3D 25(D)  failb=3D 38(D=
)  OK
[   20.322004] raid6test: test_disks(25, 39): faila=3D 25(D)  failb=3D 39(D=
)  OK
[   20.323096] raid6test: test_disks(25, 40): faila=3D 25(D)  failb=3D 40(D=
)  OK
[   20.324334] raid6test: test_disks(25, 41): faila=3D 25(D)  failb=3D 41(D=
)  OK
[   20.325423] raid6test: test_disks(25, 42): faila=3D 25(D)  failb=3D 42(D=
)  OK
[   20.326512] raid6test: test_disks(25, 43): faila=3D 25(D)  failb=3D 43(D=
)  OK
[   20.327684] raid6test: test_disks(25, 44): faila=3D 25(D)  failb=3D 44(D=
)  OK
[   20.328774] raid6test: test_disks(25, 45): faila=3D 25(D)  failb=3D 45(D=
)  OK
[   20.329892] raid6test: test_disks(25, 46): faila=3D 25(D)  failb=3D 46(D=
)  OK
[   20.331262] raid6test: test_disks(25, 47): faila=3D 25(D)  failb=3D 47(D=
)  OK
[   20.332358] raid6test: test_disks(25, 48): faila=3D 25(D)  failb=3D 48(D=
)  OK
[   20.333494] raid6test: test_disks(25, 49): faila=3D 25(D)  failb=3D 49(D=
)  OK
[   20.334619] raid6test: test_disks(25, 50): faila=3D 25(D)  failb=3D 50(D=
)  OK
[   20.335757] raid6test: test_disks(25, 51): faila=3D 25(D)  failb=3D 51(D=
)  OK
[   20.337138] raid6test: test_disks(25, 52): faila=3D 25(D)  failb=3D 52(D=
)  OK
[   20.338247] raid6test: test_disks(25, 53): faila=3D 25(D)  failb=3D 53(D=
)  OK
[   20.339357] raid6test: test_disks(25, 54): faila=3D 25(D)  failb=3D 54(D=
)  OK
[   20.353341] raid6test: test_disks(25, 55): faila=3D 25(D)  failb=3D 55(D=
)  OK
[   20.354511] raid6test: test_disks(25, 56): faila=3D 25(D)  failb=3D 56(D=
)  OK
[   20.355630] raid6test: test_disks(25, 57): faila=3D 25(D)  failb=3D 57(D=
)  OK
[   20.356778] raid6test: test_disks(25, 58): faila=3D 25(D)  failb=3D 58(D=
)  OK
[   20.357911] raid6test: test_disks(25, 59): faila=3D 25(D)  failb=3D 59(D=
)  OK
[   20.359044] raid6test: test_disks(25, 60): faila=3D 25(D)  failb=3D 60(D=
)  OK
[   20.360209] raid6test: test_disks(25, 61): faila=3D 25(D)  failb=3D 61(D=
)  OK
[   20.361348] raid6test: test_disks(25, 62): faila=3D 25(D)  failb=3D 62(P=
)  OK
[   20.371810] raid6test: test_disks(25, 63): faila=3D 25(D)  failb=3D 63(Q=
)  OK
[   20.372950] raid6test: test_disks(26, 27): faila=3D 26(D)  failb=3D 27(D=
)  OK
[   20.377551] raid6test: test_disks(26, 28): faila=3D 26(D)  failb=3D 28(D=
)  OK
[   20.378675] raid6test: test_disks(26, 29): faila=3D 26(D)  failb=3D 29(D=
)  OK
[   20.379788] raid6test: test_disks(26, 30): faila=3D 26(D)  failb=3D 30(D=
)  OK
[   20.384395] raid6test: test_disks(26, 31): faila=3D 26(D)  failb=3D 31(D=
)  OK
[   20.385518] raid6test: test_disks(26, 32): faila=3D 26(D)  failb=3D 32(D=
)  OK
[   20.386643] raid6test: test_disks(26, 33): faila=3D 26(D)  failb=3D 33(D=
)  OK
[   20.391277] raid6test: test_disks(26, 34): faila=3D 26(D)  failb=3D 34(D=
)  OK
[   20.392447] raid6test: test_disks(26, 35): faila=3D 26(D)  failb=3D 35(D=
)  OK
[   20.397112] raid6test: test_disks(26, 36): faila=3D 26(D)  failb=3D 36(D=
)  OK
[   20.398249] raid6test: test_disks(26, 37): faila=3D 26(D)  failb=3D 37(D=
)  OK
[   20.399371] raid6test: test_disks(26, 38): faila=3D 26(D)  failb=3D 38(D=
)  OK
[   20.404099] raid6test: test_disks(26, 39): faila=3D 26(D)  failb=3D 39(D=
)  OK
[   20.405218] raid6test: test_disks(26, 40): faila=3D 26(D)  failb=3D 40(D=
)  OK
[   20.406337] raid6test: test_disks(26, 41): faila=3D 26(D)  failb=3D 41(D=
)  OK
[   20.407554] raid6test: test_disks(26, 42): faila=3D 26(D)  failb=3D 42(D=
)  OK
[   20.408670] raid6test: test_disks(26, 43): faila=3D 26(D)  failb=3D 43(D=
)  OK
[   20.409791] raid6test: test_disks(26, 44): faila=3D 26(D)  failb=3D 44(D=
)  OK
[   20.410969] raid6test: test_disks(26, 45): faila=3D 26(D)  failb=3D 45(D=
)  OK
[   20.412103] raid6test: test_disks(26, 46): faila=3D 26(D)  failb=3D 46(D=
)  OK
[   20.413216] raid6test: test_disks(26, 47): faila=3D 26(D)  failb=3D 47(D=
)  OK
[   20.458148] raid6test: test_disks(26, 48): faila=3D 26(D)  failb=3D 48(D=
)  OK
[   20.461055] raid6test: test_disks(26, 49): faila=3D 26(D)  failb=3D 49(D=
)  OK
[   20.463380] raid6test: test_disks(26, 50): faila=3D 26(D)  failb=3D 50(D=
)  OK
[   20.467662] raid6test: test_disks(26, 51): faila=3D 26(D)  failb=3D 51(D=
)  OK
[   20.470398] raid6test: test_disks(26, 52): faila=3D 26(D)  failb=3D 52(D=
)  OK
[   20.471559] raid6test: test_disks(26, 53): faila=3D 26(D)  failb=3D 53(D=
)  OK
[   20.472680] raid6test: test_disks(26, 54): faila=3D 26(D)  failb=3D 54(D=
)  OK
[   20.473855] raid6test: test_disks(26, 55): faila=3D 26(D)  failb=3D 55(D=
)  OK
[   20.474976] raid6test: test_disks(26, 56): faila=3D 26(D)  failb=3D 56(D=
)  OK
[   20.476106] raid6test: test_disks(26, 57): faila=3D 26(D)  failb=3D 57(D=
)  OK
[   20.477297] raid6test: test_disks(26, 58): faila=3D 26(D)  failb=3D 58(D=
)  OK
[   20.478438] raid6test: test_disks(26, 59): faila=3D 26(D)  failb=3D 59(D=
)  OK
[   20.479563] raid6test: test_disks(26, 60): faila=3D 26(D)  failb=3D 60(D=
)  OK
[   20.480738] raid6test: test_disks(26, 61): faila=3D 26(D)  failb=3D 61(D=
)  OK
[   20.481860] raid6test: test_disks(26, 62): faila=3D 26(D)  failb=3D 62(P=
)  OK
[   20.482979] raid6test: test_disks(26, 63): faila=3D 26(D)  failb=3D 63(Q=
)  OK
[   20.497300] raid6test: test_disks(27, 28): faila=3D 27(D)  failb=3D 28(D=
)  OK
[   20.498430] raid6test: test_disks(27, 29): faila=3D 27(D)  failb=3D 29(D=
)  OK
[   20.499554] raid6test: test_disks(27, 30): faila=3D 27(D)  failb=3D 30(D=
)  OK
[   20.500734] raid6test: test_disks(27, 31): faila=3D 27(D)  failb=3D 31(D=
)  OK
[   20.501869] raid6test: test_disks(27, 32): faila=3D 27(D)  failb=3D 32(D=
)  OK
[   20.502983] raid6test: test_disks(27, 33): faila=3D 27(D)  failb=3D 33(D=
)  OK
[   20.504194] raid6test: test_disks(27, 34): faila=3D 27(D)  failb=3D 34(D=
)  OK
[   20.505320] raid6test: test_disks(27, 35): faila=3D 27(D)  failb=3D 35(D=
)  OK
[   20.506437] raid6test: test_disks(27, 36): faila=3D 27(D)  failb=3D 36(D=
)  OK
[   20.507641] raid6test: test_disks(27, 37): faila=3D 27(D)  failb=3D 37(D=
)  OK
[   20.508771] raid6test: test_disks(27, 38): faila=3D 27(D)  failb=3D 38(D=
)  OK
[   20.523072] raid6test: test_disks(27, 39): faila=3D 27(D)  failb=3D 39(D=
)  OK
[   20.524317] raid6test: test_disks(27, 40): faila=3D 27(D)  failb=3D 40(D=
)  OK
[   20.525416] raid6test: test_disks(27, 41): faila=3D 27(D)  failb=3D 41(D=
)  OK
[   20.526505] raid6test: test_disks(27, 42): faila=3D 27(D)  failb=3D 42(D=
)  OK
[   20.527638] raid6test: test_disks(27, 43): faila=3D 27(D)  failb=3D 43(D=
)  OK
[   20.528729] raid6test: test_disks(27, 44): faila=3D 27(D)  failb=3D 44(D=
)  OK
[   20.529819] raid6test: test_disks(27, 45): faila=3D 27(D)  failb=3D 45(D=
)  OK
[   20.530941] raid6test: test_disks(27, 46): faila=3D 27(D)  failb=3D 46(D=
)  OK
[   20.532040] raid6test: test_disks(27, 47): faila=3D 27(D)  failb=3D 47(D=
)  OK
[   20.534987] raid6test: test_disks(27, 48): faila=3D 27(D)  failb=3D 48(D=
)  OK
[   20.536229] raid6test: test_disks(27, 49): faila=3D 27(D)  failb=3D 49(D=
)  OK
[   20.537600] raid6test: test_disks(27, 50): faila=3D 27(D)  failb=3D 50(D=
)  OK
[   20.540523] raid6test: test_disks(27, 51): faila=3D 27(D)  failb=3D 51(D=
)  OK
[   20.543198] raid6test: test_disks(27, 52): faila=3D 27(D)  failb=3D 52(D=
)  OK
[   20.545904] raid6test: test_disks(27, 53): faila=3D 27(D)  failb=3D 53(D=
)  OK
[   20.547095] raid6test: test_disks(27, 54): faila=3D 27(D)  failb=3D 54(D=
)  OK
[   20.548246] raid6test: test_disks(27, 55): faila=3D 27(D)  failb=3D 55(D=
)  OK
[   20.549363] raid6test: test_disks(27, 56): faila=3D 27(D)  failb=3D 56(D=
)  OK
[   20.550529] raid6test: test_disks(27, 57): faila=3D 27(D)  failb=3D 57(D=
)  OK
[   20.551652] raid6test: test_disks(27, 58): faila=3D 27(D)  failb=3D 58(D=
)  OK
[   20.552768] raid6test: test_disks(27, 59): faila=3D 27(D)  failb=3D 59(D=
)  OK
[   20.553935] raid6test: test_disks(27, 60): faila=3D 27(D)  failb=3D 60(D=
)  OK
[   20.555092] raid6test: test_disks(27, 61): faila=3D 27(D)  failb=3D 61(D=
)  OK
[   20.556210] raid6test: test_disks(27, 62): faila=3D 27(D)  failb=3D 62(P=
)  OK
[   20.557409] raid6test: test_disks(27, 63): faila=3D 27(D)  failb=3D 63(Q=
)  OK
[   20.571721] raid6test: test_disks(28, 29): faila=3D 28(D)  failb=3D 29(D=
)  OK
[   20.572849] raid6test: test_disks(28, 30): faila=3D 28(D)  failb=3D 30(D=
)  OK
[   20.574066] raid6test: test_disks(28, 31): faila=3D 28(D)  failb=3D 31(D=
)  OK
[   20.575186] raid6test: test_disks(28, 32): faila=3D 28(D)  failb=3D 32(D=
)  OK
[   20.576304] raid6test: test_disks(28, 33): faila=3D 28(D)  failb=3D 33(D=
)  OK
[   20.577485] raid6test: test_disks(28, 34): faila=3D 28(D)  failb=3D 34(D=
)  OK
[   20.578603] raid6test: test_disks(28, 35): faila=3D 28(D)  failb=3D 35(D=
)  OK
[   20.579719] raid6test: test_disks(28, 36): faila=3D 28(D)  failb=3D 36(D=
)  OK
[   20.593319] raid6test: test_disks(28, 37): faila=3D 28(D)  failb=3D 37(D=
)  OK
[   20.594512] raid6test: test_disks(28, 38): faila=3D 28(D)  failb=3D 38(D=
)  OK
[   20.595638] raid6test: test_disks(28, 39): faila=3D 28(D)  failb=3D 39(D=
)  OK
[   20.596785] raid6test: test_disks(28, 40): faila=3D 28(D)  failb=3D 40(D=
)  OK
[   20.597927] raid6test: test_disks(28, 41): faila=3D 28(D)  failb=3D 41(D=
)  OK
[   20.599052] raid6test: test_disks(28, 42): faila=3D 28(D)  failb=3D 42(D=
)  OK
[   20.600199] raid6test: test_disks(28, 43): faila=3D 28(D)  failb=3D 43(D=
)  OK
[   20.601344] raid6test: test_disks(28, 44): faila=3D 28(D)  failb=3D 44(D=
)  OK
[   20.602467] raid6test: test_disks(28, 45): faila=3D 28(D)  failb=3D 45(D=
)  OK
[   20.603582] raid6test: test_disks(28, 46): faila=3D 28(D)  failb=3D 46(D=
)  OK
[   20.604565] raid6test: test_disks(28, 47): faila=3D 28(D)  failb=3D 47(D=
)  OK
[   20.605543] raid6test: test_disks(28, 48): faila=3D 28(D)  failb=3D 48(D=
)  OK
[   20.606605] raid6test: test_disks(28, 49): faila=3D 28(D)  failb=3D 49(D=
)  OK
[   20.607658] raid6test: test_disks(28, 50): faila=3D 28(D)  failb=3D 50(D=
)  OK
[   20.608640] raid6test: test_disks(28, 51): faila=3D 28(D)  failb=3D 51(D=
)  OK
[   20.609626] raid6test: test_disks(28, 52): faila=3D 28(D)  failb=3D 52(D=
)  OK
[   20.610715] raid6test: test_disks(28, 53): faila=3D 28(D)  failb=3D 53(D=
)  OK
[   20.611699] raid6test: test_disks(28, 54): faila=3D 28(D)  failb=3D 54(D=
)  OK
[   20.612675] raid6test: test_disks(28, 55): faila=3D 28(D)  failb=3D 55(D=
)  OK
[   20.613784] raid6test: test_disks(28, 56): faila=3D 28(D)  failb=3D 56(D=
)  OK
[   20.614763] raid6test: test_disks(28, 57): faila=3D 28(D)  failb=3D 57(D=
)  OK
[   20.615738] raid6test: test_disks(28, 58): faila=3D 28(D)  failb=3D 58(D=
)  OK
[   20.616836] raid6test: test_disks(28, 59): faila=3D 28(D)  failb=3D 59(D=
)  OK
[   20.617935] raid6test: test_disks(28, 60): faila=3D 28(D)  failb=3D 60(D=
)  OK
[   20.619032] raid6test: test_disks(28, 61): faila=3D 28(D)  failb=3D 61(D=
)  OK
[   20.620162] raid6test: test_disks(28, 62): faila=3D 28(D)  failb=3D 62(P=
)  OK
[   20.621262] raid6test: test_disks(28, 63): faila=3D 28(D)  failb=3D 63(Q=
)  OK
[   20.622354] raid6test: test_disks(29, 30): faila=3D 29(D)  failb=3D 30(D=
)  OK
[   20.623681] raid6test: test_disks(29, 31): faila=3D 29(D)  failb=3D 31(D=
)  OK
[   20.624786] raid6test: test_disks(29, 32): faila=3D 29(D)  failb=3D 32(D=
)  OK
[   20.625908] raid6test: test_disks(29, 33): faila=3D 29(D)  failb=3D 33(D=
)  OK
[   20.627085] raid6test: test_disks(29, 34): faila=3D 29(D)  failb=3D 34(D=
)  OK
[   20.628196] raid6test: test_disks(29, 35): faila=3D 29(D)  failb=3D 35(D=
)  OK
[   20.629314] raid6test: test_disks(29, 36): faila=3D 29(D)  failb=3D 36(D=
)  OK
[   20.630476] raid6test: test_disks(29, 37): faila=3D 29(D)  failb=3D 37(D=
)  OK
[   20.631621] raid6test: test_disks(29, 38): faila=3D 29(D)  failb=3D 38(D=
)  OK
[   20.632757] raid6test: test_disks(29, 39): faila=3D 29(D)  failb=3D 39(D=
)  OK
[   20.646310] raid6test: test_disks(29, 40): faila=3D 29(D)  failb=3D 40(D=
)  OK
[   20.647472] raid6test: test_disks(29, 41): faila=3D 29(D)  failb=3D 41(D=
)  OK
[   20.648690] raid6test: test_disks(29, 42): faila=3D 29(D)  failb=3D 42(D=
)  OK
[   20.649831] raid6test: test_disks(29, 43): faila=3D 29(D)  failb=3D 43(D=
)  OK
[   20.650986] raid6test: test_disks(29, 44): faila=3D 29(D)  failb=3D 44(D=
)  OK
[   20.652124] raid6test: test_disks(29, 45): faila=3D 29(D)  failb=3D 45(D=
)  OK
[   20.653249] raid6test: test_disks(29, 46): faila=3D 29(D)  failb=3D 46(D=
)  OK
[   20.654408] raid6test: test_disks(29, 47): faila=3D 29(D)  failb=3D 47(D=
)  OK
[   20.655542] raid6test: test_disks(29, 48): faila=3D 29(D)  failb=3D 48(D=
)  OK
[   20.656698] raid6test: test_disks(29, 49): faila=3D 29(D)  failb=3D 49(D=
)  OK
[   20.657833] raid6test: test_disks(29, 50): faila=3D 29(D)  failb=3D 50(D=
)  OK
[   20.658953] raid6test: test_disks(29, 51): faila=3D 29(D)  failb=3D 51(D=
)  OK
[   20.660286] raid6test: test_disks(29, 52): faila=3D 29(D)  failb=3D 52(D=
)  OK
[   20.661389] raid6test: test_disks(29, 53): faila=3D 29(D)  failb=3D 53(D=
)  OK
[   20.662377] raid6test: test_disks(29, 54): faila=3D 29(D)  failb=3D 54(D=
)  OK
[   20.663390] raid6test: test_disks(29, 55): faila=3D 29(D)  failb=3D 55(D=
)  OK
[   20.664373] raid6test: test_disks(29, 56): faila=3D 29(D)  failb=3D 56(D=
)  OK
[   20.665348] raid6test: test_disks(29, 57): faila=3D 29(D)  failb=3D 57(D=
)  OK
[   20.666337] raid6test: test_disks(29, 58): faila=3D 29(D)  failb=3D 58(D=
)  OK
[   20.674382] raid6test: test_disks(29, 59): faila=3D 29(D)  failb=3D 59(D=
)  OK
[   20.675513] raid6test: test_disks(29, 60): faila=3D 29(D)  failb=3D 60(D=
)  OK
[   20.676639] raid6test: test_disks(29, 61): faila=3D 29(D)  failb=3D 61(D=
)  OK
[   20.677824] raid6test: test_disks(29, 62): faila=3D 29(D)  failb=3D 62(P=
)  OK
[   20.678955] raid6test: test_disks(29, 63): faila=3D 29(D)  failb=3D 63(Q=
)  OK
[   20.706265] raid6test: test_disks(30, 31): faila=3D 30(D)  failb=3D 31(D=
)  OK
[   20.707468] raid6test: test_disks(30, 32): faila=3D 30(D)  failb=3D 32(D=
)  OK
[   20.708592] raid6test: test_disks(30, 33): faila=3D 30(D)  failb=3D 33(D=
)  OK
[   20.709712] raid6test: test_disks(30, 34): faila=3D 30(D)  failb=3D 34(D=
)  OK
[   20.710892] raid6test: test_disks(30, 35): faila=3D 30(D)  failb=3D 35(D=
)  OK
[   20.712007] raid6test: test_disks(30, 36): faila=3D 30(D)  failb=3D 36(D=
)  OK
[   20.713135] raid6test: test_disks(30, 37): faila=3D 30(D)  failb=3D 37(D=
)  OK
[   20.714334] raid6test: test_disks(30, 38): faila=3D 30(D)  failb=3D 38(D=
)  OK
[   20.715547] raid6test: test_disks(30, 39): faila=3D 30(D)  failb=3D 39(D=
)  OK
[   20.716664] raid6test: test_disks(30, 40): faila=3D 30(D)  failb=3D 40(D=
)  OK
[   20.717895] raid6test: test_disks(30, 41): faila=3D 30(D)  failb=3D 41(D=
)  OK
[   20.719022] raid6test: test_disks(30, 42): faila=3D 30(D)  failb=3D 42(D=
)  OK
[   20.723626] raid6test: test_disks(30, 43): faila=3D 30(D)  failb=3D 43(D=
)  OK
[   20.724776] raid6test: test_disks(30, 44): faila=3D 30(D)  failb=3D 44(D=
)  OK
[   20.725903] raid6test: test_disks(30, 45): faila=3D 30(D)  failb=3D 45(D=
)  OK
[   20.727070] raid6test: test_disks(30, 46): faila=3D 30(D)  failb=3D 46(D=
)  OK
[   20.728213] raid6test: test_disks(30, 47): faila=3D 30(D)  failb=3D 47(D=
)  OK
[   20.729332] raid6test: test_disks(30, 48): faila=3D 30(D)  failb=3D 48(D=
)  OK
[   20.730494] raid6test: test_disks(30, 49): faila=3D 30(D)  failb=3D 49(D=
)  OK
[   20.731612] raid6test: test_disks(30, 50): faila=3D 30(D)  failb=3D 50(D=
)  OK
[   20.732725] raid6test: test_disks(30, 51): faila=3D 30(D)  failb=3D 51(D=
)  OK
[   20.746800] raid6test: test_disks(30, 52): faila=3D 30(D)  failb=3D 52(D=
)  OK
[   20.747948] raid6test: test_disks(30, 53): faila=3D 30(D)  failb=3D 53(D=
)  OK
[   20.749077] raid6test: test_disks(30, 54): faila=3D 30(D)  failb=3D 54(D=
)  OK
[   20.750313] raid6test: test_disks(30, 55): faila=3D 30(D)  failb=3D 55(D=
)  OK
[   20.751458] raid6test: test_disks(30, 56): faila=3D 30(D)  failb=3D 56(D=
)  OK
[   20.752575] raid6test: test_disks(30, 57): faila=3D 30(D)  failb=3D 57(D=
)  OK
[   20.770670] raid6test: test_disks(30, 58): faila=3D 30(D)  failb=3D 58(D=
)  OK
[   20.773272] raid6test: test_disks(30, 59): faila=3D 30(D)  failb=3D 59(D=
)  OK
[   20.775899] raid6test: test_disks(30, 60): faila=3D 30(D)  failb=3D 60(D=
)  OK
[   20.778484] raid6test: test_disks(30, 61): faila=3D 30(D)  failb=3D 61(D=
)  OK
[   20.781976] raid6test: test_disks(30, 62): faila=3D 30(D)  failb=3D 62(P=
)  OK
[   20.784766] raid6test: test_disks(30, 63): faila=3D 30(D)  failb=3D 63(Q=
)  OK
[   20.787392] raid6test: test_disks(31, 32): faila=3D 31(D)  failb=3D 32(D=
)  OK
[   20.791518] raid6test: test_disks(31, 33): faila=3D 31(D)  failb=3D 33(D=
)  OK
[   20.794186] raid6test: test_disks(31, 34): faila=3D 31(D)  failb=3D 34(D=
)  OK
[   20.796800] raid6test: test_disks(31, 35): faila=3D 31(D)  failb=3D 35(D=
)  OK
[   20.799529] raid6test: test_disks(31, 36): faila=3D 31(D)  failb=3D 36(D=
)  OK
[   20.802213] raid6test: test_disks(31, 37): faila=3D 31(D)  failb=3D 37(D=
)  OK
[   20.805146] raid6test: test_disks(31, 38): faila=3D 31(D)  failb=3D 38(D=
)  OK
[   20.807782] raid6test: test_disks(31, 39): faila=3D 31(D)  failb=3D 39(D=
)  OK
[   20.810523] raid6test: test_disks(31, 40): faila=3D 31(D)  failb=3D 40(D=
)  OK
[   20.813557] raid6test: test_disks(31, 41): faila=3D 31(D)  failb=3D 41(D=
)  OK
[   20.816708] raid6test: test_disks(31, 42): faila=3D 31(D)  failb=3D 42(D=
)  OK
[   20.819317] raid6test: test_disks(31, 43): faila=3D 31(D)  failb=3D 43(D=
)  OK
[   20.822089] raid6test: test_disks(31, 44): faila=3D 31(D)  failb=3D 44(D=
)  OK
[   20.826226] raid6test: test_disks(31, 45): faila=3D 31(D)  failb=3D 45(D=
)  OK
[   20.828879] raid6test: test_disks(31, 46): faila=3D 31(D)  failb=3D 46(D=
)  OK
[   20.830272] raid6test: test_disks(31, 47): faila=3D 31(D)  failb=3D 47(D=
)  OK
[   20.833114] raid6test: test_disks(31, 48): faila=3D 31(D)  failb=3D 48(D=
)  OK
[   20.835742] raid6test: test_disks(31, 49): faila=3D 31(D)  failb=3D 49(D=
)  OK
[   20.839840] raid6test: test_disks(31, 50): faila=3D 31(D)  failb=3D 50(D=
)  OK
[   20.842559] raid6test: test_disks(31, 51): faila=3D 31(D)  failb=3D 51(D=
)  OK
[   20.846076] raid6test: test_disks(31, 52): faila=3D 31(D)  failb=3D 52(D=
)  OK
[   20.847212] raid6test: test_disks(31, 53): faila=3D 31(D)  failb=3D 53(D=
)  OK
[   20.848316] raid6test: test_disks(31, 54): faila=3D 31(D)  failb=3D 54(D=
)  OK
[   20.849426] raid6test: test_disks(31, 55): faila=3D 31(D)  failb=3D 55(D=
)  OK
[   20.850571] raid6test: test_disks(31, 56): faila=3D 31(D)  failb=3D 56(D=
)  OK
[   20.851696] raid6test: test_disks(31, 57): faila=3D 31(D)  failb=3D 57(D=
)  OK
[   20.852791] raid6test: test_disks(31, 58): faila=3D 31(D)  failb=3D 58(D=
)  OK
[   20.853940] raid6test: test_disks(31, 59): faila=3D 31(D)  failb=3D 59(D=
)  OK
[   20.854935] raid6test: test_disks(31, 60): faila=3D 31(D)  failb=3D 60(D=
)  OK
[   20.855915] raid6test: test_disks(31, 61): faila=3D 31(D)  failb=3D 61(D=
)  OK
[   20.856925] raid6test: test_disks(31, 62): faila=3D 31(D)  failb=3D 62(P=
)  OK
[   20.857919] raid6test: test_disks(31, 63): faila=3D 31(D)  failb=3D 63(Q=
)  OK
[   20.871238] raid6test: test_disks(32, 33): faila=3D 32(D)  failb=3D 33(D=
)  OK
[   20.872338] raid6test: test_disks(32, 34): faila=3D 32(D)  failb=3D 34(D=
)  OK
[   20.873485] raid6test: test_disks(32, 35): faila=3D 32(D)  failb=3D 35(D=
)  OK
[   20.874601] raid6test: test_disks(32, 36): faila=3D 32(D)  failb=3D 36(D=
)  OK
[   20.875701] raid6test: test_disks(32, 37): faila=3D 32(D)  failb=3D 37(D=
)  OK
[   20.876840] raid6test: test_disks(32, 38): faila=3D 32(D)  failb=3D 38(D=
)  OK
[   20.877952] raid6test: test_disks(32, 39): faila=3D 32(D)  failb=3D 39(D=
)  OK
[   20.879066] raid6test: test_disks(32, 40): faila=3D 32(D)  failb=3D 40(D=
)  OK
[   20.880267] raid6test: test_disks(32, 41): faila=3D 32(D)  failb=3D 41(D=
)  OK
[   20.881384] raid6test: test_disks(32, 42): faila=3D 32(D)  failb=3D 42(D=
)  OK
[   20.882492] raid6test: test_disks(32, 43): faila=3D 32(D)  failb=3D 43(D=
)  OK
[   20.896812] raid6test: test_disks(32, 44): faila=3D 32(D)  failb=3D 44(D=
)  OK
[   20.897936] raid6test: test_disks(32, 45): faila=3D 32(D)  failb=3D 45(D=
)  OK
[   20.899071] raid6test: test_disks(32, 46): faila=3D 32(D)  failb=3D 46(D=
)  OK
[   20.900229] raid6test: test_disks(32, 47): faila=3D 32(D)  failb=3D 47(D=
)  OK
[   20.901293] raid6test: test_disks(32, 48): faila=3D 32(D)  failb=3D 48(D=
)  OK
[   20.902281] raid6test: test_disks(32, 49): faila=3D 32(D)  failb=3D 49(D=
)  OK
[   20.903257] raid6test: test_disks(32, 50): faila=3D 32(D)  failb=3D 50(D=
)  OK
[   20.904275] raid6test: test_disks(32, 51): faila=3D 32(D)  failb=3D 51(D=
)  OK
[   20.905260] raid6test: test_disks(32, 52): faila=3D 32(D)  failb=3D 52(D=
)  OK
[   20.906239] raid6test: test_disks(32, 53): faila=3D 32(D)  failb=3D 53(D=
)  OK
[   20.907248] raid6test: test_disks(32, 54): faila=3D 32(D)  failb=3D 54(D=
)  OK
[   20.908242] raid6test: test_disks(32, 55): faila=3D 32(D)  failb=3D 55(D=
)  OK
[   20.922525] raid6test: test_disks(32, 56): faila=3D 32(D)  failb=3D 56(D=
)  OK
[   20.923696] raid6test: test_disks(32, 57): faila=3D 32(D)  failb=3D 57(D=
)  OK
[   20.924849] raid6test: test_disks(32, 58): faila=3D 32(D)  failb=3D 58(D=
)  OK
[   20.925969] raid6test: test_disks(32, 59): faila=3D 32(D)  failb=3D 59(D=
)  OK
[   20.927143] raid6test: test_disks(32, 60): faila=3D 32(D)  failb=3D 60(D=
)  OK
[   20.928273] raid6test: test_disks(32, 61): faila=3D 32(D)  failb=3D 61(D=
)  OK
[   20.929387] raid6test: test_disks(32, 62): faila=3D 32(D)  failb=3D 62(P=
)  OK
[   20.930558] raid6test: test_disks(32, 63): faila=3D 32(D)  failb=3D 63(Q=
)  OK
[   20.931687] raid6test: test_disks(33, 34): faila=3D 33(D)  failb=3D 34(D=
)  OK
[   20.932798] raid6test: test_disks(33, 35): faila=3D 33(D)  failb=3D 35(D=
)  OK
[   20.933936] raid6test: test_disks(33, 36): faila=3D 33(D)  failb=3D 36(D=
)  OK
[   20.935052] raid6test: test_disks(33, 37): faila=3D 33(D)  failb=3D 37(D=
)  OK
[   20.936194] raid6test: test_disks(33, 38): faila=3D 33(D)  failb=3D 38(D=
)  OK
[   20.937340] raid6test: test_disks(33, 39): faila=3D 33(D)  failb=3D 39(D=
)  OK
[   20.938469] raid6test: test_disks(33, 40): faila=3D 33(D)  failb=3D 40(D=
)  OK
[   20.939583] raid6test: test_disks(33, 41): faila=3D 33(D)  failb=3D 41(D=
)  OK
[   20.940718] raid6test: test_disks(33, 42): faila=3D 33(D)  failb=3D 42(D=
)  OK
[   20.941830] raid6test: test_disks(33, 43): faila=3D 33(D)  failb=3D 43(D=
)  OK
[   20.942921] raid6test: test_disks(33, 44): faila=3D 33(D)  failb=3D 44(D=
)  OK
[   20.944173] raid6test: test_disks(33, 45): faila=3D 33(D)  failb=3D 45(D=
)  OK
[   20.945270] raid6test: test_disks(33, 46): faila=3D 33(D)  failb=3D 46(D=
)  OK
[   20.946395] raid6test: test_disks(33, 47): faila=3D 33(D)  failb=3D 47(D=
)  OK
[   20.947567] raid6test: test_disks(33, 48): faila=3D 33(D)  failb=3D 48(D=
)  OK
[   20.948696] raid6test: test_disks(33, 49): faila=3D 33(D)  failb=3D 49(D=
)  OK
[   20.949828] raid6test: test_disks(33, 50): faila=3D 33(D)  failb=3D 50(D=
)  OK
[   20.951026] raid6test: test_disks(33, 51): faila=3D 33(D)  failb=3D 51(D=
)  OK
[   20.952152] raid6test: test_disks(33, 52): faila=3D 33(D)  failb=3D 52(D=
)  OK
[   20.953280] raid6test: test_disks(33, 53): faila=3D 33(D)  failb=3D 53(D=
)  OK
[   20.967338] raid6test: test_disks(33, 54): faila=3D 33(D)  failb=3D 54(D=
)  OK
[   20.968463] raid6test: test_disks(33, 55): faila=3D 33(D)  failb=3D 55(D=
)  OK
[   20.969561] raid6test: test_disks(33, 56): faila=3D 33(D)  failb=3D 56(D=
)  OK
[   20.970688] raid6test: test_disks(33, 57): faila=3D 33(D)  failb=3D 57(D=
)  OK
[   20.971794] raid6test: test_disks(33, 58): faila=3D 33(D)  failb=3D 58(D=
)  OK
[   20.972896] raid6test: test_disks(33, 59): faila=3D 33(D)  failb=3D 59(D=
)  OK
[   20.980391] raid6test: test_disks(33, 60): faila=3D 33(D)  failb=3D 60(D=
)  OK
[   20.981560] raid6test: test_disks(33, 61): faila=3D 33(D)  failb=3D 61(D=
)  OK
[   20.982686] raid6test: test_disks(33, 62): faila=3D 33(D)  failb=3D 62(P=
)  OK
[   20.990748] raid6test: test_disks(33, 63): faila=3D 33(D)  failb=3D 63(Q=
)  OK
[   20.991887] raid6test: test_disks(34, 35): faila=3D 34(D)  failb=3D 35(D=
)  OK
[   20.992992] raid6test: test_disks(34, 36): faila=3D 34(D)  failb=3D 36(D=
)  OK
[   20.994124] raid6test: test_disks(34, 37): faila=3D 34(D)  failb=3D 37(D=
)  OK
[   20.995239] raid6test: test_disks(34, 38): faila=3D 34(D)  failb=3D 38(D=
)  OK
[   20.996344] raid6test: test_disks(34, 39): faila=3D 34(D)  failb=3D 39(D=
)  OK
[   21.013300] raid6test: test_disks(34, 40): faila=3D 34(D)  failb=3D 40(D=
)  OK
[   21.014336] raid6test: test_disks(34, 41): faila=3D 34(D)  failb=3D 41(D=
)  OK
[   21.015317] raid6test: test_disks(34, 42): faila=3D 34(D)  failb=3D 42(D=
)  OK
[   21.016302] raid6test: test_disks(34, 43): faila=3D 34(D)  failb=3D 43(D=
)  OK
[   21.017314] raid6test: test_disks(34, 44): faila=3D 34(D)  failb=3D 44(D=
)  OK
[   21.018302] raid6test: test_disks(34, 45): faila=3D 34(D)  failb=3D 45(D=
)  OK
[   21.019280] raid6test: test_disks(34, 46): faila=3D 34(D)  failb=3D 46(D=
)  OK
[   21.020292] raid6test: test_disks(34, 47): faila=3D 34(D)  failb=3D 47(D=
)  OK
[   21.021272] raid6test: test_disks(34, 48): faila=3D 34(D)  failb=3D 48(D=
)  OK
[   21.029410] raid6test: test_disks(34, 49): faila=3D 34(D)  failb=3D 49(D=
)  OK
[   21.033835] raid6test: test_disks(34, 50): faila=3D 34(D)  failb=3D 50(D=
)  OK
[   21.034819] raid6test: test_disks(34, 51): faila=3D 34(D)  failb=3D 51(D=
)  OK
[   21.035899] raid6test: test_disks(34, 52): faila=3D 34(D)  failb=3D 52(D=
)  OK
[   21.043671] raid6test: test_disks(34, 53): faila=3D 34(D)  failb=3D 53(D=
)  OK
[   21.044780] raid6test: test_disks(34, 54): faila=3D 34(D)  failb=3D 54(D=
)  OK
[   21.045873] raid6test: test_disks(34, 55): faila=3D 34(D)  failb=3D 55(D=
)  OK
[   21.046994] raid6test: test_disks(34, 56): faila=3D 34(D)  failb=3D 56(D=
)  OK
[   21.048107] raid6test: test_disks(34, 57): faila=3D 34(D)  failb=3D 57(D=
)  OK
[   21.049252] raid6test: test_disks(34, 58): faila=3D 34(D)  failb=3D 58(D=
)  OK
[   21.050434] raid6test: test_disks(34, 59): faila=3D 34(D)  failb=3D 59(D=
)  OK
[   21.051543] raid6test: test_disks(34, 60): faila=3D 34(D)  failb=3D 60(D=
)  OK
[   21.052641] raid6test: test_disks(34, 61): faila=3D 34(D)  failb=3D 61(D=
)  OK
[   21.066319] raid6test: test_disks(34, 62): faila=3D 34(D)  failb=3D 62(P=
)  OK
[   21.067527] raid6test: test_disks(34, 63): faila=3D 34(D)  failb=3D 63(Q=
)  OK
[   21.068676] raid6test: test_disks(35, 36): faila=3D 35(D)  failb=3D 36(D=
)  OK
[   21.069827] raid6test: test_disks(35, 37): faila=3D 35(D)  failb=3D 37(D=
)  OK
[   21.070994] raid6test: test_disks(35, 38): faila=3D 35(D)  failb=3D 38(D=
)  OK
[   21.072125] raid6test: test_disks(35, 39): faila=3D 35(D)  failb=3D 39(D=
)  OK
[   21.073244] raid6test: test_disks(35, 40): faila=3D 35(D)  failb=3D 40(D=
)  OK
[   21.074412] raid6test: test_disks(35, 41): faila=3D 35(D)  failb=3D 41(D=
)  OK
[   21.075507] raid6test: test_disks(35, 42): faila=3D 35(D)  failb=3D 42(D=
)  OK
[   21.076602] raid6test: test_disks(35, 43): faila=3D 35(D)  failb=3D 43(D=
)  OK
[   21.077725] raid6test: test_disks(35, 44): faila=3D 35(D)  failb=3D 44(D=
)  OK
[   21.078714] raid6test: test_disks(35, 45): faila=3D 35(D)  failb=3D 45(D=
)  OK
[   21.079823] raid6test: test_disks(35, 46): faila=3D 35(D)  failb=3D 46(D=
)  OK
[   21.080876] raid6test: test_disks(35, 47): faila=3D 35(D)  failb=3D 47(D=
)  OK
[   21.081862] raid6test: test_disks(35, 48): faila=3D 35(D)  failb=3D 48(D=
)  OK
[   21.082842] raid6test: test_disks(35, 49): faila=3D 35(D)  failb=3D 49(D=
)  OK
[   21.083923] raid6test: test_disks(35, 50): faila=3D 35(D)  failb=3D 50(D=
)  OK
[   21.084901] raid6test: test_disks(35, 51): faila=3D 35(D)  failb=3D 51(D=
)  OK
[   21.085875] raid6test: test_disks(35, 52): faila=3D 35(D)  failb=3D 52(D=
)  OK
[   21.086978] raid6test: test_disks(35, 53): faila=3D 35(D)  failb=3D 53(D=
)  OK
[   21.088078] raid6test: test_disks(35, 54): faila=3D 35(D)  failb=3D 54(D=
)  OK
[   21.089161] raid6test: test_disks(35, 55): faila=3D 35(D)  failb=3D 55(D=
)  OK
[   21.090274] raid6test: test_disks(35, 56): faila=3D 35(D)  failb=3D 56(D=
)  OK
[   21.091365] raid6test: test_disks(35, 57): faila=3D 35(D)  failb=3D 57(D=
)  OK
[   21.092448] raid6test: test_disks(35, 58): faila=3D 35(D)  failb=3D 58(D=
)  OK
[   21.093568] raid6test: test_disks(35, 59): faila=3D 35(D)  failb=3D 59(D=
)  OK
[   21.094653] raid6test: test_disks(35, 60): faila=3D 35(D)  failb=3D 60(D=
)  OK
[   21.095741] raid6test: test_disks(35, 61): faila=3D 35(D)  failb=3D 61(D=
)  OK
[   21.097158] raid6test: test_disks(35, 62): faila=3D 35(D)  failb=3D 62(P=
)  OK
[   21.098285] raid6test: test_disks(35, 63): faila=3D 35(D)  failb=3D 63(Q=
)  OK
[   21.099419] raid6test: test_disks(36, 37): faila=3D 36(D)  failb=3D 37(D=
)  OK
[   21.100582] raid6test: test_disks(36, 38): faila=3D 36(D)  failb=3D 38(D=
)  OK
[   21.101707] raid6test: test_disks(36, 39): faila=3D 36(D)  failb=3D 39(D=
)  OK
[   21.102851] raid6test: test_disks(36, 40): faila=3D 36(D)  failb=3D 40(D=
)  OK
[   21.104030] raid6test: test_disks(36, 41): faila=3D 36(D)  failb=3D 41(D=
)  OK
[   21.105148] raid6test: test_disks(36, 42): faila=3D 36(D)  failb=3D 42(D=
)  OK
[   21.106281] raid6test: test_disks(36, 43): faila=3D 36(D)  failb=3D 43(D=
)  OK
[   21.120320] raid6test: test_disks(36, 44): faila=3D 36(D)  failb=3D 44(D=
)  OK
[   21.121464] raid6test: test_disks(36, 45): faila=3D 36(D)  failb=3D 45(D=
)  OK
[   21.122555] raid6test: test_disks(36, 46): faila=3D 36(D)  failb=3D 46(D=
)  OK
[   21.123711] raid6test: test_disks(36, 47): faila=3D 36(D)  failb=3D 47(D=
)  OK
[   21.124827] raid6test: test_disks(36, 48): faila=3D 36(D)  failb=3D 48(D=
)  OK
[   21.125938] raid6test: test_disks(36, 49): faila=3D 36(D)  failb=3D 49(D=
)  OK
[   21.127100] raid6test: test_disks(36, 50): faila=3D 36(D)  failb=3D 50(D=
)  OK
[   21.128237] raid6test: test_disks(36, 51): faila=3D 36(D)  failb=3D 51(D=
)  OK
[   21.129350] raid6test: test_disks(36, 52): faila=3D 36(D)  failb=3D 52(D=
)  OK
[   21.130506] raid6test: test_disks(36, 53): faila=3D 36(D)  failb=3D 53(D=
)  OK
[   21.131597] raid6test: test_disks(36, 54): faila=3D 36(D)  failb=3D 54(D=
)  OK
[   21.132693] raid6test: test_disks(36, 55): faila=3D 36(D)  failb=3D 55(D=
)  OK
[   21.133999] raid6test: test_disks(36, 56): faila=3D 36(D)  failb=3D 56(D=
)  OK
[   21.135118] raid6test: test_disks(36, 57): faila=3D 36(D)  failb=3D 57(D=
)  OK
[   21.136236] raid6test: test_disks(36, 58): faila=3D 36(D)  failb=3D 58(D=
)  OK
[   21.137473] raid6test: test_disks(36, 59): faila=3D 36(D)  failb=3D 59(D=
)  OK
[   21.138593] raid6test: test_disks(36, 60): faila=3D 36(D)  failb=3D 60(D=
)  OK
[   21.139702] raid6test: test_disks(36, 61): faila=3D 36(D)  failb=3D 61(D=
)  OK
[   21.140957] raid6test: test_disks(36, 62): faila=3D 36(D)  failb=3D 62(P=
)  OK
[   21.141947] raid6test: test_disks(36, 63): faila=3D 36(D)  failb=3D 63(Q=
)  OK
[   21.142930] raid6test: test_disks(37, 38): faila=3D 37(D)  failb=3D 38(D=
)  OK
[   21.143942] raid6test: test_disks(37, 39): faila=3D 37(D)  failb=3D 39(D=
)  OK
[   21.144928] raid6test: test_disks(37, 40): faila=3D 37(D)  failb=3D 40(D=
)  OK
[   21.145910] raid6test: test_disks(37, 41): faila=3D 37(D)  failb=3D 41(D=
)  OK
[   21.146917] raid6test: test_disks(37, 42): faila=3D 37(D)  failb=3D 42(D=
)  OK
[   21.147915] raid6test: test_disks(37, 43): faila=3D 37(D)  failb=3D 43(D=
)  OK
[   21.148897] raid6test: test_disks(37, 44): faila=3D 37(D)  failb=3D 44(D=
)  OK
[   21.149889] raid6test: test_disks(37, 45): faila=3D 37(D)  failb=3D 45(D=
)  OK
[   21.151129] raid6test: test_disks(37, 46): faila=3D 37(D)  failb=3D 46(D=
)  OK
[   21.152112] raid6test: test_disks(37, 47): faila=3D 37(D)  failb=3D 47(D=
)  OK
[   21.153089] raid6test: test_disks(37, 48): faila=3D 37(D)  failb=3D 48(D=
)  OK
[   21.154211] raid6test: test_disks(37, 49): faila=3D 37(D)  failb=3D 49(D=
)  OK
[   21.155307] raid6test: test_disks(37, 50): faila=3D 37(D)  failb=3D 50(D=
)  OK
[   21.156395] raid6test: test_disks(37, 51): faila=3D 37(D)  failb=3D 51(D=
)  OK
[   21.157521] raid6test: test_disks(37, 52): faila=3D 37(D)  failb=3D 52(D=
)  OK
[   21.158620] raid6test: test_disks(37, 53): faila=3D 37(D)  failb=3D 53(D=
)  OK
[   21.159744] raid6test: test_disks(37, 54): faila=3D 37(D)  failb=3D 54(D=
)  OK
[   21.191316] raid6test: test_disks(37, 55): faila=3D 37(D)  failb=3D 55(D=
)  OK
[   21.192317] raid6test: test_disks(37, 56): faila=3D 37(D)  failb=3D 56(D=
)  OK
[   21.193296] raid6test: test_disks(37, 57): faila=3D 37(D)  failb=3D 57(D=
)  OK
[   21.194311] raid6test: test_disks(37, 58): faila=3D 37(D)  failb=3D 58(D=
)  OK
[   21.195289] raid6test: test_disks(37, 59): faila=3D 37(D)  failb=3D 59(D=
)  OK
[   21.196266] raid6test: test_disks(37, 60): faila=3D 37(D)  failb=3D 60(D=
)  OK
[   21.197271] raid6test: test_disks(37, 61): faila=3D 37(D)  failb=3D 61(D=
)  OK
[   21.198266] raid6test: test_disks(37, 62): faila=3D 37(D)  failb=3D 62(P=
)  OK
[   21.199264] raid6test: test_disks(37, 63): faila=3D 37(D)  failb=3D 63(Q=
)  OK
[   21.200283] raid6test: test_disks(38, 39): faila=3D 38(D)  failb=3D 39(D=
)  OK
[   21.201273] raid6test: test_disks(38, 40): faila=3D 38(D)  failb=3D 40(D=
)  OK
[   21.202263] raid6test: test_disks(38, 41): faila=3D 38(D)  failb=3D 41(D=
)  OK
[   21.203283] raid6test: test_disks(38, 42): faila=3D 38(D)  failb=3D 42(D=
)  OK
[   21.217556] raid6test: test_disks(38, 43): faila=3D 38(D)  failb=3D 43(D=
)  OK
[   21.218683] raid6test: test_disks(38, 44): faila=3D 38(D)  failb=3D 44(D=
)  OK
[   21.219794] raid6test: test_disks(38, 45): faila=3D 38(D)  failb=3D 45(D=
)  OK
[   21.220937] raid6test: test_disks(38, 46): faila=3D 38(D)  failb=3D 46(D=
)  OK
[   21.222060] raid6test: test_disks(38, 47): faila=3D 38(D)  failb=3D 47(D=
)  OK
[   21.223144] raid6test: test_disks(38, 48): faila=3D 38(D)  failb=3D 48(D=
)  OK
[   21.234130] raid6test: test_disks(38, 49): faila=3D 38(D)  failb=3D 49(D=
)  OK
[   21.235236] raid6test: test_disks(38, 50): faila=3D 38(D)  failb=3D 50(D=
)  OK
[   21.236327] raid6test: test_disks(38, 51): faila=3D 38(D)  failb=3D 51(D=
)  OK
[   21.237481] raid6test: test_disks(38, 52): faila=3D 38(D)  failb=3D 52(D=
)  OK
[   21.238586] raid6test: test_disks(38, 53): faila=3D 38(D)  failb=3D 53(D=
)  OK
[   21.239693] raid6test: test_disks(38, 54): faila=3D 38(D)  failb=3D 54(D=
)  OK
[   21.240807] raid6test: test_disks(38, 55): faila=3D 38(D)  failb=3D 55(D=
)  OK
[   21.241908] raid6test: test_disks(38, 56): faila=3D 38(D)  failb=3D 56(D=
)  OK
[   21.243018] raid6test: test_disks(38, 57): faila=3D 38(D)  failb=3D 57(D=
)  OK
[   21.257126] raid6test: test_disks(38, 58): faila=3D 38(D)  failb=3D 58(D=
)  OK
[   21.258103] raid6test: test_disks(38, 59): faila=3D 38(D)  failb=3D 59(D=
)  OK
[   21.259085] raid6test: test_disks(38, 60): faila=3D 38(D)  failb=3D 60(D=
)  OK
[   21.260086] raid6test: test_disks(38, 61): faila=3D 38(D)  failb=3D 61(D=
)  OK
[   21.261177] raid6test: test_disks(38, 62): faila=3D 38(D)  failb=3D 62(P=
)  OK
[   21.262271] raid6test: test_disks(38, 63): faila=3D 38(D)  failb=3D 63(Q=
)  OK
[   21.263388] raid6test: test_disks(39, 40): faila=3D 39(D)  failb=3D 40(D=
)  OK
[   21.264476] raid6test: test_disks(39, 41): faila=3D 39(D)  failb=3D 41(D=
)  OK
[   21.265562] raid6test: test_disks(39, 42): faila=3D 39(D)  failb=3D 42(D=
)  OK
[   21.266656] raid6test: test_disks(39, 43): faila=3D 39(D)  failb=3D 43(D=
)  OK
[   21.267892] raid6test: test_disks(39, 44): faila=3D 39(D)  failb=3D 44(D=
)  OK
[   21.268985] raid6test: test_disks(39, 45): faila=3D 39(D)  failb=3D 45(D=
)  OK
[   21.274235] raid6test: test_disks(39, 46): faila=3D 39(D)  failb=3D 46(D=
)  OK
[   21.275372] raid6test: test_disks(39, 47): faila=3D 39(D)  failb=3D 47(D=
)  OK
[   21.276487] raid6test: test_disks(39, 48): faila=3D 39(D)  failb=3D 48(D=
)  OK
[   21.277630] raid6test: test_disks(39, 49): faila=3D 39(D)  failb=3D 49(D=
)  OK
[   21.278735] raid6test: test_disks(39, 50): faila=3D 39(D)  failb=3D 50(D=
)  OK
[   21.279844] raid6test: test_disks(39, 51): faila=3D 39(D)  failb=3D 51(D=
)  OK
[   21.280992] raid6test: test_disks(39, 52): faila=3D 39(D)  failb=3D 52(D=
)  OK
[   21.282115] raid6test: test_disks(39, 53): faila=3D 39(D)  failb=3D 53(D=
)  OK
[   21.283210] raid6test: test_disks(39, 54): faila=3D 39(D)  failb=3D 54(D=
)  OK
[   21.284355] raid6test: test_disks(39, 55): faila=3D 39(D)  failb=3D 55(D=
)  OK
[   21.285471] raid6test: test_disks(39, 56): faila=3D 39(D)  failb=3D 56(D=
)  OK
[   21.299752] raid6test: test_disks(39, 57): faila=3D 39(D)  failb=3D 57(D=
)  OK
[   21.300906] raid6test: test_disks(39, 58): faila=3D 39(D)  failb=3D 58(D=
)  OK
[   21.302030] raid6test: test_disks(39, 59): faila=3D 39(D)  failb=3D 59(D=
)  OK
[   21.303140] raid6test: test_disks(39, 60): faila=3D 39(D)  failb=3D 60(D=
)  OK
[   21.304287] raid6test: test_disks(39, 61): faila=3D 39(D)  failb=3D 61(D=
)  OK
[   21.305278] raid6test: test_disks(39, 62): faila=3D 39(D)  failb=3D 62(P=
)  OK
[   21.306259] raid6test: test_disks(39, 63): faila=3D 39(D)  failb=3D 63(Q=
)  OK
[   21.307350] raid6test: test_disks(40, 41): faila=3D 40(D)  failb=3D 41(D=
)  OK
[   21.308342] raid6test: test_disks(40, 42): faila=3D 40(D)  failb=3D 42(D=
)  OK
[   21.309323] raid6test: test_disks(40, 43): faila=3D 40(D)  failb=3D 43(D=
)  OK
[   21.310329] raid6test: test_disks(40, 44): faila=3D 40(D)  failb=3D 44(D=
)  OK
[   21.311304] raid6test: test_disks(40, 45): faila=3D 40(D)  failb=3D 45(D=
)  OK
[   21.312277] raid6test: test_disks(40, 46): faila=3D 40(D)  failb=3D 46(D=
)  OK
[   21.313252] raid6test: test_disks(40, 47): faila=3D 40(D)  failb=3D 47(D=
)  OK
[   21.314281] raid6test: test_disks(40, 48): faila=3D 40(D)  failb=3D 48(D=
)  OK
[   21.315257] raid6test: test_disks(40, 49): faila=3D 40(D)  failb=3D 49(D=
)  OK
[   21.316259] raid6test: test_disks(40, 50): faila=3D 40(D)  failb=3D 50(D=
)  OK
[   21.317383] raid6test: test_disks(40, 51): faila=3D 40(D)  failb=3D 51(D=
)  OK
[   21.318480] raid6test: test_disks(40, 52): faila=3D 40(D)  failb=3D 52(D=
)  OK
[   21.319568] raid6test: test_disks(40, 53): faila=3D 40(D)  failb=3D 53(D=
)  OK
[   21.320680] raid6test: test_disks(40, 54): faila=3D 40(D)  failb=3D 54(D=
)  OK
[   21.321772] raid6test: test_disks(40, 55): faila=3D 40(D)  failb=3D 55(D=
)  OK
[   21.322864] raid6test: test_disks(40, 56): faila=3D 40(D)  failb=3D 56(D=
)  OK
[   21.323989] raid6test: test_disks(40, 57): faila=3D 40(D)  failb=3D 57(D=
)  OK
[   21.325087] raid6test: test_disks(40, 58): faila=3D 40(D)  failb=3D 58(D=
)  OK
[   21.326210] raid6test: test_disks(40, 59): faila=3D 40(D)  failb=3D 59(D=
)  OK
[   21.327401] raid6test: test_disks(40, 60): faila=3D 40(D)  failb=3D 60(D=
)  OK
[   21.328522] raid6test: test_disks(40, 61): faila=3D 40(D)  failb=3D 61(D=
)  OK
[   21.329631] raid6test: test_disks(40, 62): faila=3D 40(D)  failb=3D 62(P=
)  OK
[   21.330780] raid6test: test_disks(40, 63): faila=3D 40(D)  failb=3D 63(Q=
)  OK
[   21.331895] raid6test: test_disks(41, 42): faila=3D 41(D)  failb=3D 42(D=
)  OK
[   21.333019] raid6test: test_disks(41, 43): faila=3D 41(D)  failb=3D 43(D=
)  OK
[   21.334267] raid6test: test_disks(41, 44): faila=3D 41(D)  failb=3D 44(D=
)  OK
[   21.335402] raid6test: test_disks(41, 45): faila=3D 41(D)  failb=3D 45(D=
)  OK
[   21.336530] raid6test: test_disks(41, 46): faila=3D 41(D)  failb=3D 46(D=
)  OK
[   21.337828] raid6test: test_disks(41, 47): faila=3D 41(D)  failb=3D 47(D=
)  OK
[   21.338951] raid6test: test_disks(41, 48): faila=3D 41(D)  failb=3D 48(D=
)  OK
[   21.340102] raid6test: test_disks(41, 49): faila=3D 41(D)  failb=3D 49(D=
)  OK
[   21.341223] raid6test: test_disks(41, 50): faila=3D 41(D)  failb=3D 50(D=
)  OK
[   21.342349] raid6test: test_disks(41, 51): faila=3D 41(D)  failb=3D 51(D=
)  OK
[   21.355677] raid6test: test_disks(41, 52): faila=3D 41(D)  failb=3D 52(D=
)  OK
[   21.356893] raid6test: test_disks(41, 53): faila=3D 41(D)  failb=3D 53(D=
)  OK
[   21.358028] raid6test: test_disks(41, 54): faila=3D 41(D)  failb=3D 54(D=
)  OK
[   21.359143] raid6test: test_disks(41, 55): faila=3D 41(D)  failb=3D 55(D=
)  OK
[   21.360303] raid6test: test_disks(41, 56): faila=3D 41(D)  failb=3D 56(D=
)  OK
[   21.361418] raid6test: test_disks(41, 57): faila=3D 41(D)  failb=3D 57(D=
)  OK
[   21.362538] raid6test: test_disks(41, 58): faila=3D 41(D)  failb=3D 58(D=
)  OK
[   21.363699] raid6test: test_disks(41, 59): faila=3D 41(D)  failb=3D 59(D=
)  OK
[   21.364826] raid6test: test_disks(41, 60): faila=3D 41(D)  failb=3D 60(D=
)  OK
[   21.365938] raid6test: test_disks(41, 61): faila=3D 41(D)  failb=3D 61(D=
)  OK
[   21.367194] raid6test: test_disks(41, 62): faila=3D 41(D)  failb=3D 62(P=
)  OK
[   21.371104] raid6test: test_disks(41, 63): faila=3D 41(D)  failb=3D 63(Q=
)  OK
[   21.372225] raid6test: test_disks(42, 43): faila=3D 42(D)  failb=3D 43(D=
)  OK
[   21.373391] raid6test: test_disks(42, 44): faila=3D 42(D)  failb=3D 44(D=
)  OK
[   21.374517] raid6test: test_disks(42, 45): faila=3D 42(D)  failb=3D 45(D=
)  OK
[   21.375615] raid6test: test_disks(42, 46): faila=3D 42(D)  failb=3D 46(D=
)  OK
[   21.376771] raid6test: test_disks(42, 47): faila=3D 42(D)  failb=3D 47(D=
)  OK
[   21.377901] raid6test: test_disks(42, 48): faila=3D 42(D)  failb=3D 48(D=
)  OK
[   21.379032] raid6test: test_disks(42, 49): faila=3D 42(D)  failb=3D 49(D=
)  OK
[   21.380170] raid6test: test_disks(42, 50): faila=3D 42(D)  failb=3D 50(D=
)  OK
[   21.381281] raid6test: test_disks(42, 51): faila=3D 42(D)  failb=3D 51(D=
)  OK
[   21.382379] raid6test: test_disks(42, 52): faila=3D 42(D)  failb=3D 52(D=
)  OK
[   21.399688] raid6test: test_disks(42, 53): faila=3D 42(D)  failb=3D 53(D=
)  OK
[   21.400845] raid6test: test_disks(42, 54): faila=3D 42(D)  failb=3D 54(D=
)  OK
[   21.401839] raid6test: test_disks(42, 55): faila=3D 42(D)  failb=3D 55(D=
)  OK
[   21.402823] raid6test: test_disks(42, 56): faila=3D 42(D)  failb=3D 56(D=
)  OK
[   21.403832] raid6test: test_disks(42, 57): faila=3D 42(D)  failb=3D 57(D=
)  OK
[   21.404822] raid6test: test_disks(42, 58): faila=3D 42(D)  failb=3D 58(D=
)  OK
[   21.405805] raid6test: test_disks(42, 59): faila=3D 42(D)  failb=3D 59(D=
)  OK
[   21.406932] raid6test: test_disks(42, 60): faila=3D 42(D)  failb=3D 60(D=
)  OK
[   21.407921] raid6test: test_disks(42, 61): faila=3D 42(D)  failb=3D 61(D=
)  OK
[   21.408903] raid6test: test_disks(42, 62): faila=3D 42(D)  failb=3D 62(P=
)  OK
[   21.409890] raid6test: test_disks(42, 63): faila=3D 42(D)  failb=3D 63(Q=
)  OK
[   21.410902] raid6test: test_disks(43, 44): faila=3D 43(D)  failb=3D 44(D=
)  OK
[   21.411888] raid6test: test_disks(43, 45): faila=3D 43(D)  failb=3D 45(D=
)  OK
[   21.412877] raid6test: test_disks(43, 46): faila=3D 43(D)  failb=3D 46(D=
)  OK
[   21.413987] raid6test: test_disks(43, 47): faila=3D 43(D)  failb=3D 47(D=
)  OK
[   21.415093] raid6test: test_disks(43, 48): faila=3D 43(D)  failb=3D 48(D=
)  OK
[   21.416195] raid6test: test_disks(43, 49): faila=3D 43(D)  failb=3D 49(D=
)  OK
[   21.417340] raid6test: test_disks(43, 50): faila=3D 43(D)  failb=3D 50(D=
)  OK
[   21.418441] raid6test: test_disks(43, 51): faila=3D 43(D)  failb=3D 51(D=
)  OK
[   21.419538] raid6test: test_disks(43, 52): faila=3D 43(D)  failb=3D 52(D=
)  OK
[   21.420660] raid6test: test_disks(43, 53): faila=3D 43(D)  failb=3D 53(D=
)  OK
[   21.421758] raid6test: test_disks(43, 54): faila=3D 43(D)  failb=3D 54(D=
)  OK
[   21.422911] raid6test: test_disks(43, 55): faila=3D 43(D)  failb=3D 55(D=
)  OK
[   21.424120] raid6test: test_disks(43, 56): faila=3D 43(D)  failb=3D 56(D=
)  OK
[   21.425296] raid6test: test_disks(43, 57): faila=3D 43(D)  failb=3D 57(D=
)  OK
[   21.426440] raid6test: test_disks(43, 58): faila=3D 43(D)  failb=3D 58(D=
)  OK
[   21.427631] raid6test: test_disks(43, 59): faila=3D 43(D)  failb=3D 59(D=
)  OK
[   21.428764] raid6test: test_disks(43, 60): faila=3D 43(D)  failb=3D 60(D=
)  OK
[   21.429899] raid6test: test_disks(43, 61): faila=3D 43(D)  failb=3D 61(D=
)  OK
[   21.431076] raid6test: test_disks(43, 62): faila=3D 43(D)  failb=3D 62(P=
)  OK
[   21.432219] raid6test: test_disks(43, 63): faila=3D 43(D)  failb=3D 63(Q=
)  OK
[   21.433403] raid6test: test_disks(44, 45): faila=3D 44(D)  failb=3D 45(D=
)  OK
[   21.434547] raid6test: test_disks(44, 46): faila=3D 44(D)  failb=3D 46(D=
)  OK
[   21.435686] raid6test: test_disks(44, 47): faila=3D 44(D)  failb=3D 47(D=
)  OK
[   21.436941] raid6test: test_disks(44, 48): faila=3D 44(D)  failb=3D 48(D=
)  OK
[   21.451250] raid6test: test_disks(44, 49): faila=3D 44(D)  failb=3D 49(D=
)  OK
[   21.452401] raid6test: test_disks(44, 50): faila=3D 44(D)  failb=3D 50(D=
)  OK
[   21.453572] raid6test: test_disks(44, 51): faila=3D 44(D)  failb=3D 51(D=
)  OK
[   21.454718] raid6test: test_disks(44, 52): faila=3D 44(D)  failb=3D 52(D=
)  OK
[   21.455833] raid6test: test_disks(44, 53): faila=3D 44(D)  failb=3D 53(D=
)  OK
[   21.456998] raid6test: test_disks(44, 54): faila=3D 44(D)  failb=3D 54(D=
)  OK
[   21.458154] raid6test: test_disks(44, 55): faila=3D 44(D)  failb=3D 55(D=
)  OK
[   21.459282] raid6test: test_disks(44, 56): faila=3D 44(D)  failb=3D 56(D=
)  OK
[   21.460440] raid6test: test_disks(44, 57): faila=3D 44(D)  failb=3D 57(D=
)  OK
[   21.461572] raid6test: test_disks(44, 58): faila=3D 44(D)  failb=3D 58(D=
)  OK
[   21.462687] raid6test: test_disks(44, 59): faila=3D 44(D)  failb=3D 59(D=
)  OK
[   21.463899] raid6test: test_disks(44, 60): faila=3D 44(D)  failb=3D 60(D=
)  OK
[   21.471229] raid6test: test_disks(44, 61): faila=3D 44(D)  failb=3D 61(D=
)  OK
[   21.472355] raid6test: test_disks(44, 62): faila=3D 44(D)  failb=3D 62(P=
)  OK
[   21.473577] raid6test: test_disks(44, 63): faila=3D 44(D)  failb=3D 63(Q=
)  OK
[   21.474730] raid6test: test_disks(45, 46): faila=3D 45(D)  failb=3D 46(D=
)  OK
[   21.475855] raid6test: test_disks(45, 47): faila=3D 45(D)  failb=3D 47(D=
)  OK
[   21.477036] raid6test: test_disks(45, 48): faila=3D 45(D)  failb=3D 48(D=
)  OK
[   21.478168] raid6test: test_disks(45, 49): faila=3D 45(D)  failb=3D 49(D=
)  OK
[   21.479290] raid6test: test_disks(45, 50): faila=3D 45(D)  failb=3D 50(D=
)  OK
[   21.480466] raid6test: test_disks(45, 51): faila=3D 45(D)  failb=3D 51(D=
)  OK
[   21.481595] raid6test: test_disks(45, 52): faila=3D 45(D)  failb=3D 52(D=
)  OK
[   21.482719] raid6test: test_disks(45, 53): faila=3D 45(D)  failb=3D 53(D=
)  OK
[   21.497088] raid6test: test_disks(45, 54): faila=3D 45(D)  failb=3D 54(D=
)  OK
[   21.498225] raid6test: test_disks(45, 55): faila=3D 45(D)  failb=3D 55(D=
)  OK
[   21.499349] raid6test: test_disks(45, 56): faila=3D 45(D)  failb=3D 56(D=
)  OK
[   21.500515] raid6test: test_disks(45, 57): faila=3D 45(D)  failb=3D 57(D=
)  OK
[   21.501645] raid6test: test_disks(45, 58): faila=3D 45(D)  failb=3D 58(D=
)  OK
[   21.502763] raid6test: test_disks(45, 59): faila=3D 45(D)  failb=3D 59(D=
)  OK
[   21.503936] raid6test: test_disks(45, 60): faila=3D 45(D)  failb=3D 60(D=
)  OK
[   21.505074] raid6test: test_disks(45, 61): faila=3D 45(D)  failb=3D 61(D=
)  OK
[   21.506192] raid6test: test_disks(45, 62): faila=3D 45(D)  failb=3D 62(P=
)  OK
[   21.507477] raid6test: test_disks(45, 63): faila=3D 45(D)  failb=3D 63(Q=
)  OK
[   21.508606] raid6test: test_disks(46, 47): faila=3D 46(D)  failb=3D 47(D=
)  OK
[   21.522909] raid6test: test_disks(46, 48): faila=3D 46(D)  failb=3D 48(D=
)  OK
[   21.524122] raid6test: test_disks(46, 49): faila=3D 46(D)  failb=3D 49(D=
)  OK
[   21.525251] raid6test: test_disks(46, 50): faila=3D 46(D)  failb=3D 50(D=
)  OK
[   21.526384] raid6test: test_disks(46, 51): faila=3D 46(D)  failb=3D 51(D=
)  OK
[   21.527603] raid6test: test_disks(46, 52): faila=3D 46(D)  failb=3D 52(D=
)  OK
[   21.528731] raid6test: test_disks(46, 53): faila=3D 46(D)  failb=3D 53(D=
)  OK
[   21.529858] raid6test: test_disks(46, 54): faila=3D 46(D)  failb=3D 54(D=
)  OK
[   21.531054] raid6test: test_disks(46, 55): faila=3D 46(D)  failb=3D 55(D=
)  OK
[   21.532176] raid6test: test_disks(46, 56): faila=3D 46(D)  failb=3D 56(D=
)  OK
[   21.533299] raid6test: test_disks(46, 57): faila=3D 46(D)  failb=3D 57(D=
)  OK
[   21.534480] raid6test: test_disks(46, 58): faila=3D 46(D)  failb=3D 58(D=
)  OK
[   21.548872] raid6test: test_disks(46, 59): faila=3D 46(D)  failb=3D 59(D=
)  OK
[   21.550038] raid6test: test_disks(46, 60): faila=3D 46(D)  failb=3D 60(D=
)  OK
[   21.551208] raid6test: test_disks(46, 61): faila=3D 46(D)  failb=3D 61(D=
)  OK
[   21.552324] raid6test: test_disks(46, 62): faila=3D 46(D)  failb=3D 62(P=
)  OK
[   21.553472] raid6test: test_disks(46, 63): faila=3D 46(D)  failb=3D 63(Q=
)  OK
[   21.554627] raid6test: test_disks(47, 48): faila=3D 47(D)  failb=3D 48(D=
)  OK
[   21.555753] raid6test: test_disks(47, 49): faila=3D 47(D)  failb=3D 49(D=
)  OK
[   21.556921] raid6test: test_disks(47, 50): faila=3D 47(D)  failb=3D 50(D=
)  OK
[   21.558078] raid6test: test_disks(47, 51): faila=3D 47(D)  failb=3D 51(D=
)  OK
[   21.559204] raid6test: test_disks(47, 52): faila=3D 47(D)  failb=3D 52(D=
)  OK
[   21.560362] raid6test: test_disks(47, 53): faila=3D 47(D)  failb=3D 53(D=
)  OK
[   21.574646] raid6test: test_disks(47, 54): faila=3D 47(D)  failb=3D 54(D=
)  OK
[   21.575772] raid6test: test_disks(47, 55): faila=3D 47(D)  failb=3D 55(D=
)  OK
[   21.576987] raid6test: test_disks(47, 56): faila=3D 47(D)  failb=3D 56(D=
)  OK
[   21.578141] raid6test: test_disks(47, 57): faila=3D 47(D)  failb=3D 57(D=
)  OK
[   21.579268] raid6test: test_disks(47, 58): faila=3D 47(D)  failb=3D 58(D=
)  OK
[   21.580430] raid6test: test_disks(47, 59): faila=3D 47(D)  failb=3D 59(D=
)  OK
[   21.581552] raid6test: test_disks(47, 60): faila=3D 47(D)  failb=3D 60(D=
)  OK
[   21.582669] raid6test: test_disks(47, 61): faila=3D 47(D)  failb=3D 61(D=
)  OK
[   21.583839] raid6test: test_disks(47, 62): faila=3D 47(D)  failb=3D 62(P=
)  OK
[   21.584967] raid6test: test_disks(47, 63): faila=3D 47(D)  failb=3D 63(Q=
)  OK
[   21.586096] raid6test: test_disks(48, 49): faila=3D 48(D)  failb=3D 49(D=
)  OK
[   21.599400] raid6test: test_disks(48, 50): faila=3D 48(D)  failb=3D 50(D=
)  OK
[   21.600552] raid6test: test_disks(48, 51): faila=3D 48(D)  failb=3D 51(D=
)  OK
[   21.601665] raid6test: test_disks(48, 52): faila=3D 48(D)  failb=3D 52(D=
)  OK
[   21.602754] raid6test: test_disks(48, 53): faila=3D 48(D)  failb=3D 53(D=
)  OK
[   21.603884] raid6test: test_disks(48, 54): faila=3D 48(D)  failb=3D 54(D=
)  OK
[   21.605000] raid6test: test_disks(48, 55): faila=3D 48(D)  failb=3D 55(D=
)  OK
[   21.606120] raid6test: test_disks(48, 56): faila=3D 48(D)  failb=3D 56(D=
)  OK
[   21.607253] raid6test: test_disks(48, 57): faila=3D 48(D)  failb=3D 57(D=
)  OK
[   21.608373] raid6test: test_disks(48, 58): faila=3D 48(D)  failb=3D 58(D=
)  OK
[   21.609494] raid6test: test_disks(48, 59): faila=3D 48(D)  failb=3D 59(D=
)  OK
[   21.610690] raid6test: test_disks(48, 60): faila=3D 48(D)  failb=3D 60(D=
)  OK
[   21.624885] raid6test: test_disks(48, 61): faila=3D 48(D)  failb=3D 61(D=
)  OK
[   21.625864] raid6test: test_disks(48, 62): faila=3D 48(D)  failb=3D 62(P=
)  OK
[   21.626947] raid6test: test_disks(48, 63): faila=3D 48(D)  failb=3D 63(Q=
)  OK
[   21.627942] raid6test: test_disks(49, 50): faila=3D 49(D)  failb=3D 50(D=
)  OK
[   21.628934] raid6test: test_disks(49, 51): faila=3D 49(D)  failb=3D 51(D=
)  OK
[   21.629928] raid6test: test_disks(49, 52): faila=3D 49(D)  failb=3D 52(D=
)  OK
[   21.631051] raid6test: test_disks(49, 53): faila=3D 49(D)  failb=3D 53(D=
)  OK
[   21.632135] raid6test: test_disks(49, 54): faila=3D 49(D)  failb=3D 54(D=
)  OK
[   21.633224] raid6test: test_disks(49, 55): faila=3D 49(D)  failb=3D 55(D=
)  OK
[   21.634348] raid6test: test_disks(49, 56): faila=3D 49(D)  failb=3D 56(D=
)  OK
[   21.635442] raid6test: test_disks(49, 57): faila=3D 49(D)  failb=3D 57(D=
)  OK
[   21.636531] raid6test: test_disks(49, 58): faila=3D 49(D)  failb=3D 58(D=
)  OK
[   21.650918] raid6test: test_disks(49, 59): faila=3D 49(D)  failb=3D 59(D=
)  OK
[   21.652050] raid6test: test_disks(49, 60): faila=3D 49(D)  failb=3D 60(D=
)  OK
[   21.653152] raid6test: test_disks(49, 61): faila=3D 49(D)  failb=3D 61(D=
)  OK
[   21.654296] raid6test: test_disks(49, 62): faila=3D 49(D)  failb=3D 62(P=
)  OK
[   21.655383] raid6test: test_disks(49, 63): faila=3D 49(D)  failb=3D 63(Q=
)  OK
[   21.656477] raid6test: test_disks(50, 51): faila=3D 50(D)  failb=3D 51(D=
)  OK
[   21.657620] raid6test: test_disks(50, 52): faila=3D 50(D)  failb=3D 52(D=
)  OK
[   21.658746] raid6test: test_disks(50, 53): faila=3D 50(D)  failb=3D 53(D=
)  OK
[   21.659864] raid6test: test_disks(50, 54): faila=3D 50(D)  failb=3D 54(D=
)  OK
[   21.660995] raid6test: test_disks(50, 55): faila=3D 50(D)  failb=3D 55(D=
)  OK
[   21.662117] raid6test: test_disks(50, 56): faila=3D 50(D)  failb=3D 56(D=
)  OK
[   21.676347] raid6test: test_disks(50, 57): faila=3D 50(D)  failb=3D 57(D=
)  OK
[   21.677397] raid6test: test_disks(50, 58): faila=3D 50(D)  failb=3D 58(D=
)  OK
[   21.678398] raid6test: test_disks(50, 59): faila=3D 50(D)  failb=3D 59(D=
)  OK
[   21.679389] raid6test: test_disks(50, 60): faila=3D 50(D)  failb=3D 60(D=
)  OK
[   21.680431] raid6test: test_disks(50, 61): faila=3D 50(D)  failb=3D 61(D=
)  OK
[   21.681421] raid6test: test_disks(50, 62): faila=3D 50(D)  failb=3D 62(P=
)  OK
[   21.682415] raid6test: test_disks(50, 63): faila=3D 50(D)  failb=3D 63(Q=
)  OK
[   21.683441] raid6test: test_disks(51, 52): faila=3D 51(D)  failb=3D 52(D=
)  OK
[   21.684418] raid6test: test_disks(51, 53): faila=3D 51(D)  failb=3D 53(D=
)  OK
[   21.685390] raid6test: test_disks(51, 54): faila=3D 51(D)  failb=3D 54(D=
)  OK
[   21.686372] raid6test: test_disks(51, 55): faila=3D 51(D)  failb=3D 55(D=
)  OK
[   21.734335] raid6test: test_disks(51, 56): faila=3D 51(D)  failb=3D 56(D=
)  OK
[   21.735344] raid6test: test_disks(51, 57): faila=3D 51(D)  failb=3D 57(D=
)  OK
[   21.736326] raid6test: test_disks(51, 58): faila=3D 51(D)  failb=3D 58(D=
)  OK
[   21.737343] raid6test: test_disks(51, 59): faila=3D 51(D)  failb=3D 59(D=
)  OK
[   21.738322] raid6test: test_disks(51, 60): faila=3D 51(D)  failb=3D 60(D=
)  OK
[   21.739303] raid6test: test_disks(51, 61): faila=3D 51(D)  failb=3D 61(D=
)  OK
[   21.740300] raid6test: test_disks(51, 62): faila=3D 51(D)  failb=3D 62(P=
)  OK
[   21.741286] raid6test: test_disks(51, 63): faila=3D 51(D)  failb=3D 63(Q=
)  OK
[   21.742272] raid6test: test_disks(52, 53): faila=3D 52(D)  failb=3D 53(D=
)  OK
[   21.750520] raid6test: test_disks(52, 54): faila=3D 52(D)  failb=3D 54(D=
)  OK
[   21.751626] raid6test: test_disks(52, 55): faila=3D 52(D)  failb=3D 55(D=
)  OK
[   21.752728] raid6test: test_disks(52, 56): faila=3D 52(D)  failb=3D 56(D=
)  OK
[   21.753894] raid6test: test_disks(52, 57): faila=3D 52(D)  failb=3D 57(D=
)  OK
[   21.755069] raid6test: test_disks(52, 58): faila=3D 52(D)  failb=3D 58(D=
)  OK
[   21.756192] raid6test: test_disks(52, 59): faila=3D 52(D)  failb=3D 59(D=
)  OK
[   21.757453] raid6test: test_disks(52, 60): faila=3D 52(D)  failb=3D 60(D=
)  OK
[   21.758590] raid6test: test_disks(52, 61): faila=3D 52(D)  failb=3D 61(D=
)  OK
[   21.759707] raid6test: test_disks(52, 62): faila=3D 52(D)  failb=3D 62(P=
)  OK
[   21.760962] raid6test: test_disks(52, 63): faila=3D 52(D)  failb=3D 63(Q=
)  OK
[   21.762122] raid6test: test_disks(53, 54): faila=3D 53(D)  failb=3D 54(D=
)  OK
[   21.763250] raid6test: test_disks(53, 55): faila=3D 53(D)  failb=3D 55(D=
)  OK
[   21.764603] raid6test: test_disks(53, 56): faila=3D 53(D)  failb=3D 56(D=
)  OK
[   21.765723] raid6test: test_disks(53, 57): faila=3D 53(D)  failb=3D 57(D=
)  OK
[   21.766862] raid6test: test_disks(53, 58): faila=3D 53(D)  failb=3D 58(D=
)  OK
[   21.768026] raid6test: test_disks(53, 59): faila=3D 53(D)  failb=3D 59(D=
)  OK
[   21.769129] raid6test: test_disks(53, 60): faila=3D 53(D)  failb=3D 60(D=
)  OK
[   21.770259] raid6test: test_disks(53, 61): faila=3D 53(D)  failb=3D 61(D=
)  OK
[   21.771372] raid6test: test_disks(53, 62): faila=3D 53(D)  failb=3D 62(P=
)  OK
[   21.772502] raid6test: test_disks(53, 63): faila=3D 53(D)  failb=3D 63(Q=
)  OK
[   21.786348] raid6test: test_disks(54, 55): faila=3D 54(D)  failb=3D 55(D=
)  OK
[   21.787513] raid6test: test_disks(54, 56): faila=3D 54(D)  failb=3D 56(D=
)  OK
[   21.788508] raid6test: test_disks(54, 57): faila=3D 54(D)  failb=3D 57(D=
)  OK
[   21.789497] raid6test: test_disks(54, 58): faila=3D 54(D)  failb=3D 58(D=
)  OK
[   21.790518] raid6test: test_disks(54, 59): faila=3D 54(D)  failb=3D 59(D=
)  OK
[   21.791512] raid6test: test_disks(54, 60): faila=3D 54(D)  failb=3D 60(D=
)  OK
[   21.792499] raid6test: test_disks(54, 61): faila=3D 54(D)  failb=3D 61(D=
)  OK
[   21.793515] raid6test: test_disks(54, 62): faila=3D 54(D)  failb=3D 62(P=
)  OK
[   21.794498] raid6test: test_disks(54, 63): faila=3D 54(D)  failb=3D 63(Q=
)  OK
[   21.804135] raid6test: test_disks(55, 56): faila=3D 55(D)  failb=3D 56(D=
)  OK
[   21.805230] raid6test: test_disks(55, 57): faila=3D 55(D)  failb=3D 57(D=
)  OK
[   21.806318] raid6test: test_disks(55, 58): faila=3D 55(D)  failb=3D 58(D=
)  OK
[   21.810888] raid6test: test_disks(55, 59): faila=3D 55(D)  failb=3D 59(D=
)  OK
[   21.811987] raid6test: test_disks(55, 60): faila=3D 55(D)  failb=3D 60(D=
)  OK
[   21.813086] raid6test: test_disks(55, 61): faila=3D 55(D)  failb=3D 61(D=
)  OK
[   21.817682] raid6test: test_disks(55, 62): faila=3D 55(D)  failb=3D 62(P=
)  OK
[   21.819282] raid6test: test_disks(55, 63): faila=3D 55(D)  failb=3D 63(Q=
)  OK
[   21.833744] raid6test: test_disks(56, 57): faila=3D 56(D)  failb=3D 57(D=
)  OK
[   21.834858] raid6test: test_disks(56, 58): faila=3D 56(D)  failb=3D 58(D=
)  OK
[   21.835962] raid6test: test_disks(56, 59): faila=3D 56(D)  failb=3D 59(D=
)  OK
[   21.837116] raid6test: test_disks(56, 60): faila=3D 56(D)  failb=3D 60(D=
)  OK
[   21.838235] raid6test: test_disks(56, 61): faila=3D 56(D)  failb=3D 61(D=
)  OK
[   21.839331] raid6test: test_disks(56, 62): faila=3D 56(D)  failb=3D 62(P=
)  OK
[   21.840467] raid6test: test_disks(56, 63): faila=3D 56(D)  failb=3D 63(Q=
)  OK
[   21.841578] raid6test: test_disks(57, 58): faila=3D 57(D)  failb=3D 58(D=
)  OK
[   21.842685] raid6test: test_disks(57, 59): faila=3D 57(D)  failb=3D 59(D=
)  OK
[   21.856323] raid6test: test_disks(57, 60): faila=3D 57(D)  failb=3D 60(D=
)  OK
[   21.857354] raid6test: test_disks(57, 61): faila=3D 57(D)  failb=3D 61(D=
)  OK
[   21.858332] raid6test: test_disks(57, 62): faila=3D 57(D)  failb=3D 62(P=
)  OK
[   21.859311] raid6test: test_disks(57, 63): faila=3D 57(D)  failb=3D 63(Q=
)  OK
[   21.860323] raid6test: test_disks(58, 59): faila=3D 58(D)  failb=3D 59(D=
)  OK
[   21.861300] raid6test: test_disks(58, 60): faila=3D 58(D)  failb=3D 60(D=
)  OK
[   21.862275] raid6test: test_disks(58, 61): faila=3D 58(D)  failb=3D 61(D=
)  OK
[   21.863250] raid6test: test_disks(58, 62): faila=3D 58(D)  failb=3D 62(P=
)  OK
[   21.864274] raid6test: test_disks(58, 63): faila=3D 58(D)  failb=3D 63(Q=
)  OK
[   21.873752] raid6test: test_disks(59, 60): faila=3D 59(D)  failb=3D 60(D=
)  OK
[   21.874859] raid6test: test_disks(59, 61): faila=3D 59(D)  failb=3D 61(D=
)  OK
[   21.875943] raid6test: test_disks(59, 62): faila=3D 59(D)  failb=3D 62(P=
)  OK
[   21.882632] raid6test: test_disks(59, 63): faila=3D 59(D)  failb=3D 63(Q=
)  OK
[   21.883834] raid6test: test_disks(60, 61): faila=3D 60(D)  failb=3D 61(D=
)  OK
[   21.884978] raid6test: test_disks(60, 62): faila=3D 60(D)  failb=3D 62(P=
)  OK
[   21.886115] raid6test: test_disks(60, 63): faila=3D 60(D)  failb=3D 63(Q=
)  OK
[   21.887283] raid6test: test_disks(61, 62): faila=3D 61(D)  failb=3D 62(P=
)  OK
[   21.898624] raid6test: test_disks(61, 63): faila=3D 61(D)  failb=3D 63(Q=
)  OK
[   21.899758] raid6test: test_disks(62, 63): faila=3D 62(P)  failb=3D 63(Q=
)  OK
[   21.900753] raid6test:=20
[   21.901126] raid6test: complete (2429 tests, 0 failures)
[   21.949331] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   21.950257] EDD information not available.
[   21.950882] ALSA device list:
[   21.951316]   No soundcards found.
[   21.961704] debug: unmapping init [mem 0xffffffff834f5000-0xffffffff8362=
cfff]
[   21.974724] Write protecting the kernel read-only data: 28672k
[   21.978523] debug: unmapping init [mem 0xffff880002097000-0xffff8800021f=
ffff]
[   21.979795] debug: unmapping init [mem 0xffff880002b40000-0xffff880002bf=
ffff]
[   22.009899] random: init urandom read with 8 bits of entropy available
mountall: Event failed

BUG: kernel boot hang
Elapsed time: 40
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-iv0-07151152/8df59fd2a350161bd39c3c9f8f4213b2a2a61847/vmlinuz-3.16.0-rc4-0=
0339-g8df59fd -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug=
 apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 pan=
ic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 conso=
le=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/=
kbuild-tests/run-queue/kvm/x86_64-randconfig-iv0-07151152/next:master:8df59=
fd2a350161bd39c3c9f8f4213b2a2a61847:bisect-linux3/.vmlinuz-8df59fd2a350161b=
d39c3c9f8f4213b2a2a61847-20140715125615-59-ivb41 branch=3Dnext/master BOOT_=
IMAGE=3D/kernel/x86_64-randconfig-iv0-07151152/8df59fd2a350161bd39c3c9f8f42=
13b2a2a61847/vmlinuz-3.16.0-rc4-00339-g8df59fd drbd.minor_count=3D8'  -init=
rd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 320 -smp 2 -net nic,vlan=
=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog=
 i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-quantal-ivb41-1=
01 -serial file:/dev/shm/kboot/serial-quantal-ivb41-101 -daemonize -display=
 none -monitor null=20

--b2ktwntdbf0dPnbx
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-iv0-07151152-a20416c4071010be525f74c70c7a79c5ee6a2a05-BUG:-unable-to-handle-kernel-paging-request-95016.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgYTIwNDE2Yy4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxl
cyBmb3IgMjAxNDA3MTQKZ2l0IGNoZWNrb3V0IDY0ZTMyNDVjODcwZTU4MzAwNGYxOWQ5ODlj
ZGY5ZWRjYWI2MTMzZmQKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82
NC1yYW5kY29uZmlnLWl2MC0wNzE1MTE1Mi9uZXh0Om1hc3Rlcjo2NGUzMjQ1Yzg3MGU1ODMw
MDRmMTlkOTg5Y2RmOWVkY2FiNjEzM2ZkOmJpc2VjdC1saW51eDMKCjIwMTQtMDctMTUtMTI6
MDQ6MzAgNjRlMzI0NWM4NzBlNTgzMDA0ZjE5ZDk4OWNkZjllZGNhYjYxMzNmZCBjb21waWxp
bmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZf
NjQtcmFuZGNvbmZpZy1pdjAtMDcxNTExNTItNjRlMzI0NWM4NzBlNTgzMDA0ZjE5ZDk4OWNk
ZjllZGNhYjYxMzNmZApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaXYwLTA3MTUxMTUyLzY0ZTMyNDVjODcwZTU4MzAwNGYxOWQ5ODljZGY5ZWRjYWI2
MTMzZmQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWl2MC0wNzE1MTE1Mi02NGUzMjQ1Yzg3MGU1ODMwMDRm
MTlkOTg5Y2RmOWVkY2FiNjEzM2ZkCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS9qYWtldG93bi1jb25zdW1lci94ODZfNjQtcmFuZGNvbmZp
Zy1pdjAtMDcxNTExNTItNjRlMzI0NWM4NzBlNTgzMDA0ZjE5ZDk4OWNkZjllZGNhYjYxMzNm
ZAprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYwLTA3MTUxMTUyLzY0ZTMy
NDVjODcwZTU4MzAwNGYxOWQ5ODljZGY5ZWRjYWI2MTMzZmQvdm1saW51ei0zLjE2LjAtcmM1
LTA1NjQ5LWc2NGUzMjQ1CgoyMDE0LTA3LTE1LTEyOjExOjMwIGRldGVjdGluZyBib290IHN0
YXRlIC4uCTM1IFNVQ0NFU1MKCmJpc2VjdDogZ29vZCBjb21taXQgNjRlMzI0NWM4NzBlNTgz
MDA0ZjE5ZDk4OWNkZjllZGNhYjYxMzNmZApnaXQgYmlzZWN0IHN0YXJ0IGEyMDQxNmM0MDcx
MDEwYmU1MjVmNzRjNzBjN2E3OWM1ZWU2YTJhMDUgNjRlMzI0NWM4NzBlNTgzMDA0ZjE5ZDk4
OWNkZjllZGNhYjYxMzNmZCAtLQovYy9rZXJuZWwtdGVzdHMvbGluZWFyLWJpc2VjdDogWyIt
YiIsICJhMjA0MTZjNDA3MTAxMGJlNTI1Zjc0YzcwYzdhNzljNWVlNmEyYTA1IiwgIi1nIiwg
IjY0ZTMyNDVjODcwZTU4MzAwNGYxOWQ5ODljZGY5ZWRjYWI2MTMzZmQiLCAiL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCIsICIvYy9ib290LWJpc2VjdC9s
aW51eDMvb2JqLWJpc2VjdCJdCkJpc2VjdGluZzogNDM2IHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBzKQpbYzljYjg0YTliMDRkZThjMTYyY2Zk
NWQxYTVkNjU2YmZiYTYwNTEwMF0gTWVyZ2UgYnJhbmNoICdha3BtLWN1cnJlbnQvY3VycmVu
dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9jL2Jvb3QtYmlzZWN0L2xpbnV4My9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMv
cnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1pdjAtMDcxNTExNTIvbmV4dDptYXN0
ZXI6YzljYjg0YTliMDRkZThjMTYyY2ZkNWQxYTVkNjU2YmZiYTYwNTEwMDpiaXNlY3QtbGlu
dXgzCgoyMDE0LTA3LTE1LTEyOjEzOjAxIGM5Y2I4NGE5YjA0ZGU4YzE2MmNmZDVkMWE1ZDY1
NmJmYmE2MDUxMDAgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaXYwLTA3MTUxMTUyLWM5Y2I4NGE5
YjA0ZGU4YzE2MmNmZDVkMWE1ZDY1NmJmYmE2MDUxMDAKQ2hlY2sgZm9yIGtlcm5lbCBpbiAv
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MC0wNzE1MTE1Mi9jOWNiODRhOWIwNGRlOGMx
NjJjZmQ1ZDFhNWQ2NTZiZmJhNjA1MTAwCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2ti
dWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1pdjAtMDcxNTExNTIt
YzljYjg0YTliMDRkZThjMTYyY2ZkNWQxYTVkNjU2YmZiYTYwNTEwMAp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvamFrZXRvd24tY29uc3Vt
ZXIveDg2XzY0LXJhbmRjb25maWctaXYwLTA3MTUxMTUyLWM5Y2I4NGE5YjA0ZGU4YzE2MmNm
ZDVkMWE1ZDY1NmJmYmE2MDUxMDAKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWl2MC0wNzE1MTE1Mi9jOWNiODRhOWIwNGRlOGMxNjJjZmQ1ZDFhNWQ2NTZiZmJhNjA1MTAw
L3ZtbGludXotMy4xNi4wLXJjNS0wNjAyMC1nYzljYjg0YQoKMjAxNC0wNy0xNS0xMjoyMTow
MSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJNyBURVNUIEZBSUxVUkUKWyAgICAwLjc3MzEzOF0g
Q1JFRDogLT4qZ2lkID0geyAwLC0yMTI5NzQ2NjcyLDI5NjMyNzMwNCw2OCB9ClsgICAgMC43
NzM3MjddIENSRUQ6IC0+c2VjdXJpdHkgaXMgICAgICAgICAgIChudWxsKQpbICAgIDAuNzc0
MTk5XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAwLjc3NDY0
OF0ga2VybmVsIEJVRyBhdCAva2J1aWxkL3NyYy9jb25zdW1lci9rZXJuZWwvY3JlZC5jOjc1
OCEKWyAgICAwLjc3NTI0NV0gaW52YWxpZCBvcGNvZGU6IDAwMDAgWyMxXSBQUkVFTVBUIFNN
UCBERUJVR19QQUdFQUxMT0MKWyAgICAwLjc3NTkxMF0gQ1BVOiAwIFBJRDogODUgQ29tbTog
Y3J5cHRvbWdyX3Rlc3QgTm90IHRhaW50ZWQgMy4xNi4wLXJjNS0wNjAyMC1nYzljYjg0YSAj
MgpbICAgIDAuNzc2Njg1XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2No
cyAwMS8wMS8yMDExClsgICAgMC43NzcwNTJdIHRhc2s6IGZmZmY4ODAwMTFiYzAwMDAgdGk6
IGZmZmY4ODAwMTFiYzQwMDAgdGFzay50aTogZmZmZjg4MDAxMWJjNDAwMApbICAgIDAuNzc3
MDUyXSBSSVA6IDAwMTA6WzxmZmZmZmZmZjgxMGYwMmIxPl0gIFs8ZmZmZmZmZmY4MTBmMDJi
MT5dIF9faW52YWxpZF9jcmVkcysweDUxLzB4NjAKWyAgICAwLjc3NzA1Ml0gUlNQOiAwMDAw
OmZmZmY4ODAwMTM4MDNkYjggIEVGTEFHUzogMDAwMTAyMDIKWyAgICAwLjc3NzA1Ml0gUkFY
OiAwMDAwMDAwMDAwMDAwMDAwIFJCWDogZmZmZjg4MDAxMWE2OGU4MCBSQ1g6IDAwMDAwMDAw
MDAwMDAwMDMKWyAgICAwLjc3NzA1Ml0gUkRYOiAwMDAwMDAwMDAwMDAwMDAzIFJTSTogMDAw
MDAwMDAwMDAwMDAwMSBSREk6IDAwMDAwMDAwMDAwMDAyNDYKWyAgICAwLjc3NzA1Ml0gUkJQ
OiBmZmZmODgwMDEzODAzZGQwIFIwODogMDAwMDAwMDAwMDAwMDAwMCBSMDk6IDAwMDAwMDAw
MDAwMDAwMDEKWyAgICAwLjc3NzA1Ml0gUjEwOiAwMDAwMDAwMDAwMDAwMDMwIFIxMTogZmZm
Zjg4MDAxMzgwM2E5ZSBSMTI6IGZmZmZmZmZmODI5ZmY5ODgKWyAgICAwLjc3NzA1Ml0gUjEz
OiAwMDAwMDAwMDAwMDAwMDllIFIxNDogMDAwMDAwMDAwMDAwMDAwMCBSMTU6IGZmZmY4ODAw
MTFhYTcyYTAKWyAgICAwLjc3NzA1Ml0gRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdT
OmZmZmY4ODAwMTM4MDAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAgIDAu
Nzc3MDUyXSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUw
MDMzClsgICAgMC43NzcwNTJdIENSMjogMDAwMDAwMDBmZmZmZmZmZiBDUjM6IDAwMDAwMDAw
MDJjMGIwMDAgQ1I0OiAwMDAwMDAwMDAwMDQwNmYwClsgICAgMC43NzcwNTJdIFN0YWNrOgpb
ICAgIDAuNzc3MDUyXSAgZmZmZjg4MDAxMWE2OGU4MCBmZmZmODgwMDExYTg4MDAwIDAwMDAw
MDAwMDAwMDAwMDEgZmZmZjg4MDAxMzgwM2RmOApbICAgIDAuNzc3MDUyXSAgZmZmZmZmZmY4
MTBmMDMzMSBmZmZmODgwMDExYTg4MDAwIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAxMWE4
OTBmMApbICAgIDAuNzc3MDUyXSAgZmZmZjg4MDAxMzgwM2UxOCBmZmZmZmZmZjgxMGJkMDdl
IDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAxMWE4ODAwMApbICAgIDAuNzc3MDUyXSBDYWxs
IFRyYWNlOgpbICAgIDAuNzc3MDUyXSAgPElSUT4gClsgICAgMC43NzcwNTJdICBbPGZmZmZm
ZmZmODEwZjAzMzE+XSBleGl0X2NyZWRzKzB4NzEvMHgxYTAKWyAgICAwLjc3NzA1Ml0gIFs8
ZmZmZmZmZmY4MTBiZDA3ZT5dIF9fcHV0X3Rhc2tfc3RydWN0KzB4ZmUvMHgyODAKWyAgICAw
Ljc3NzA1Ml0gIFs8ZmZmZmZmZmY4MTBjMmU4OD5dIGRlbGF5ZWRfcHV0X3Rhc2tfc3RydWN0
KzB4MTE4LzB4MTMwClsgICAgMC43NzcwNTJdICBbPGZmZmZmZmZmODIwNzhiYjY+XSByY3Vf
ZG9fYmF0Y2guaXNyYS40OCsweDczYS8weGJiYwpbICAgIDAuNzc3MDUyXSAgWzxmZmZmZmZm
ZjgyMDc4OTdiPl0gPyByY3VfZG9fYmF0Y2guaXNyYS40OCsweDRmZi8weGJiYwpbICAgIDAu
Nzc3MDUyXSAgWzxmZmZmZmZmZjgxMTQ4MWMwPl0gcmN1X3Byb2Nlc3NfY2FsbGJhY2tzKzB4
NjMwLzB4NjQwClsgICAgMC43NzcwNTJdICBbPGZmZmZmZmZmODEwYzc1YjQ+XSBfX2RvX3Nv
ZnRpcnErMHgxZjQvMHg1YTAKWyAgICAwLjc3NzA1Ml0gIFs8ZmZmZmZmZmY4MTBjN2UzMz5d
IGlycV9leGl0KzB4YjMvMHgxNDAKWyAgICAwLjc3NzA1Ml0gIFs8ZmZmZmZmZmY4MjBhZjlh
NT5dIHNtcF9hcGljX3RpbWVyX2ludGVycnVwdCsweDQ1LzB4NjAKWyAgICAwLjc3NzA1Ml0g
IFs8ZmZmZmZmZmY4MjBhZTNjMj5dIGFwaWNfdGltZXJfaW50ZXJydXB0KzB4NzIvMHg4MApb
ICAgIDAuNzc3MDUyXSAgPEVPST4gClsgICAgMC43NzcwNTJdICBbPGZmZmZmZmZmODEwZmM5
YzQ+XSA/IHByZWVtcHRfY291bnRfYWRkKzB4NzQvMHgxNjAKWyAgICAwLjc3NzA1Ml0gIFs8
ZmZmZmZmZmY4MTA2MThhYj5dIGdsdWVfZWNiX2NyeXB0XzEyOGJpdCsweDFjYi8weDNhMApb
ICAgIDAuNzc3MDUyXSAgWzxmZmZmZmZmZjgxMGExOWMxPl0gZWNiX2VuY3J5cHQrMHgyMS8w
eDMwClsgICAgMC43NzcwNTJdICBbPGZmZmZmZmZmODE1ZjFkYzM+XSBfX2FibGtfZW5jcnlw
dCsweDQzLzB4NTAKWyAgICAwLjc3NzA1Ml0gIFs8ZmZmZmZmZmY4MTVmMWUwNj5dIGFibGtf
ZW5jcnlwdCsweDM2LzB4YzAKWyAgICAwLjc3NzA1Ml0gIFs8ZmZmZmZmZmY4MTViNTU0Yj5d
IF9fdGVzdF9za2NpcGhlcisweDVlYi8weGY1MApbICAgIDAuNzc3MDUyXSAgWzxmZmZmZmZm
ZjgxNWE3YTFiPl0gPyBfX2NyeXB0b19hbGxvY190Zm0rMHg2Yi8weDIwMApbICAgIDAuNzc3
MDUyXSAgWzxmZmZmZmZmZjgxNWE5ZTZmPl0gPyBjcnlwdG9fc3Bhd25fdGZtKzB4ZGYvMHgx
MDAKWyAgICAwLjc3NzA1Ml0gIFs8ZmZmZmZmZmY4MTVjZGZkOT5dID8gY3J5cHRkX2Jsa2Np
cGhlcl9pbml0X3RmbSsweDQ5LzB4OTAKWyAgICAwLjc3NzA1Ml0gIFs8ZmZmZmZmZmY4MTVh
N2I3Nz5dID8gX19jcnlwdG9fYWxsb2NfdGZtKzB4MWM3LzB4MjAwClsgICAgMC43NzcwNTJd
ICBbPGZmZmZmZmZmODE1YTdjYmU+XSA/IGNyeXB0b19hbGxvY19iYXNlKzB4MTBlLzB4MTUw
ClsgICAgMC43NzcwNTJdICBbPGZmZmZmZmZmODE1Y2VmN2U+XSA/IGNyeXB0ZF9hbGxvY19h
YmxrY2lwaGVyKzB4OWUvMHgxMDAKWyAgICAwLjc3NzA1Ml0gIFs8ZmZmZmZmZmY4MTYzZTlm
OT5dID8gc25wcmludGYrMHgzOS8weDQwClsgICAgMC43NzcwNTJdICBbPGZmZmZmZmZmODE1
ZjFmZGI+XSA/IGFibGtfaW5pdF9jb21tb24rMHgzYi8weDgwClsgICAgMC43NzcwNTJdICBb
PGZmZmZmZmZmODE1ZjIwNWM+XSA/IGFibGtfaW5pdCsweDNjLzB4NTAKWyAgICAwLjc3NzA1
Ml0gIFs8ZmZmZmZmZmY4MTVhN2I3Nz5dID8gX19jcnlwdG9fYWxsb2NfdGZtKzB4MWM3LzB4
MjAwClsgICAgMC43NzcwNTJdICBbPGZmZmZmZmZmODE1Yjg3YTc+XSB0ZXN0X3NrY2lwaGVy
KzB4MjcvMHgxMzAKWyAgICAwLjc3NzA1Ml0gIFs8ZmZmZmZmZmY4MTViODk4MT5dIGFsZ190
ZXN0X3NrY2lwaGVyKzB4ZDEvMHgxMzAKWyAgICAwLjc3NzA1Ml0gIFs8ZmZmZmZmZmY4MTVi
OGZlMz5dIGFsZ190ZXN0KzB4M2IzLzB4NDkwClsgICAgMC43NzcwNTJdICBbPGZmZmZmZmZm
ODE1YjM4ZDA+XSA/IGNyeXB0b21ncl9ub3RpZnkrMHg3NDAvMHg3NDAKWyAgICAwLjc3NzA1
Ml0gIFs8ZmZmZmZmZmY4MTViMzkyOT5dIGNyeXB0b21ncl90ZXN0KzB4NTkvMHg2MApbICAg
IDAuNzc3MDUyXSAgWzxmZmZmZmZmZjgxMGVkMGJmPl0ga3RocmVhZCsweDEyZi8weDE0MApb
ICAgIDAuNzc3MDUyXSAgWzxmZmZmZmZmZjgxMGVjZjkwPl0gPyBfX2t0aHJlYWRfcGFya21l
KzB4OTAvMHg5MApbICAgIDAuNzc3MDUyXSAgWzxmZmZmZmZmZjgyMGFkM2JjPl0gcmV0X2Zy
b21fZm9yaysweDdjLzB4YjAKWyAgICAwLjc3NzA1Ml0gIFs8ZmZmZmZmZmY4MTBlY2Y5MD5d
ID8gX19rdGhyZWFkX3BhcmttZSsweDkwLzB4OTAKWyAgICAwLjc3NzA1Ml0gQ29kZTogODkg
ZWEgNGMgODkgZTYgNDggYzcgYzcgNzUgZDggYTAgODIgMzEgYzAgZTggMGUgODAgZjggMDAg
NDggYzcgYzYgODcgZDggYTAgODIgNDggODkgZGYgNjUgNDggOGIgMTQgMjUgYzAgYjggMDAg
MDAgZTggZWYgZjkgZmYgZmYgPDBmPiAwYiA2NiA2NiA2NiA2NiAyZSAwZiAxZiA4NCAwMCAw
MCAwMCAwMCAwMCBlOCBjYiBmMyBmYiAwMCA1NSAKWyAgICAwLjc3NzA1Ml0gUklQICBbPGZm
ZmZmZmZmODEwZjAyYjE+XSBfX2ludmFsaWRfY3JlZHMrMHg1MS8weDYwClsgICAgMC43Nzcw
NTJdICBSU1AgPGZmZmY4ODAwMTM4MDNkYjg+ClsgICAgMC44MTI1MzJdIC0tLVsgZW5kIHRy
YWNlIGIzMzI3OTVhZGM3YTBhMmQgXS0tLQpbICAgIDAuODEyOTg5XSBLZXJuZWwgcGFuaWMg
LSBub3Qgc3luY2luZzogRmF0YWwgZXhjZXB0aW9uIGluIGludGVycnVwdAova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWl2MC0wNzE1MTE1Mi9jOWNiODRhOWIwNGRlOGMxNjJjZmQ1ZDFh
NWQ2NTZiZmJhNjA1MTAwL2RtZXNnLXlvY3RvLWtidWlsZC0xMzoyMDE0MDcxNTEyMTgzNjp4
ODZfNjQtcmFuZGNvbmZpZy1pdjAtMDcxNTExNTI6My4xNi4wLXJjNS0wNjAyMC1nYzljYjg0
YToyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYwLTA3MTUxMTUyL2M5Y2I4NGE5YjA0
ZGU4YzE2MmNmZDVkMWE1ZDY1NmJmYmE2MDUxMDAvZG1lc2cteW9jdG8ta2J1aWxkLTE2OjIw
MTQwNzE1MTIxODM4Ong4Nl82NC1yYW5kY29uZmlnLWl2MC0wNzE1MTE1MjozLjE2LjAtcmM1
LTA2MDIwLWdjOWNiODRhOjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjAtMDcxNTEx
NTIvYzljYjg0YTliMDRkZThjMTYyY2ZkNWQxYTVkNjU2YmZiYTYwNTEwMC9kbWVzZy15b2N0
by1rYnVpbGQtMjI6MjAxNDA3MTUxMjE4Mzg6eDg2XzY0LXJhbmRjb25maWctaXYwLTA3MTUx
MTUyOjMuMTYuMC1yYzUtMDYwMjAtZ2M5Y2I4NGE6Mgova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWl2MC0wNzE1MTE1Mi9jOWNiODRhOWIwNGRlOGMxNjJjZmQ1ZDFhNWQ2NTZiZmJhNjA1
MTAwL2RtZXNnLXlvY3RvLWtidWlsZC0yNDoyMDE0MDcxNTEyMTgzNjp4ODZfNjQtcmFuZGNv
bmZpZy1pdjAtMDcxNTExNTI6My4xNi4wLXJjNS0wNjAyMC1nYzljYjg0YToyCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctaXYwLTA3MTUxMTUyL2M5Y2I4NGE5YjA0ZGU4YzE2MmNmZDVk
MWE1ZDY1NmJmYmE2MDUxMDAvZG1lc2cteW9jdG8ta2J1aWxkLTI4OjIwMTQwNzE1MTIxODM4
Ong4Nl82NC1yYW5kY29uZmlnLWl2MC0wNzE1MTE1MjozLjE2LjAtcmM1LTA2MDIwLWdjOWNi
ODRhOjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjAtMDcxNTExNTIvYzljYjg0YTli
MDRkZThjMTYyY2ZkNWQxYTVkNjU2YmZiYTYwNTEwMC9kbWVzZy15b2N0by1rYnVpbGQtMTI6
MjAxNDA3MTUxMjE4NDE6eDg2XzY0LXJhbmRjb25maWctaXYwLTA3MTUxMTUyOjMuMTYuMC1y
YzUtMDYwMjAtZ2M5Y2I4NGE6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MC0wNzE1
MTE1Mi9jOWNiODRhOWIwNGRlOGMxNjJjZmQ1ZDFhNWQ2NTZiZmJhNjA1MTAwL2RtZXNnLXlv
Y3RvLWtidWlsZC0xNzoyMDE0MDcxNTEyMTg0MDp4ODZfNjQtcmFuZGNvbmZpZy1pdjAtMDcx
NTExNTI6My4xNi4wLXJjNS0wNjAyMC1nYzljYjg0YToyCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaXYwLTA3MTUxMTUyL2M5Y2I4NGE5YjA0ZGU4YzE2MmNmZDVkMWE1ZDY1NmJmYmE2
MDUxMDAvZG1lc2cteW9jdG8ta2J1aWxkLTE6MjAxNDA3MTUxMjE4NDE6eDg2XzY0LXJhbmRj
b25maWctaXYwLTA3MTUxMTUyOjMuMTYuMC1yYzUtMDYwMjAtZ2M5Y2I4NGE6Mgova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWl2MC0wNzE1MTE1Mi9jOWNiODRhOWIwNGRlOGMxNjJjZmQ1
ZDFhNWQ2NTZiZmJhNjA1MTAwL2RtZXNnLXlvY3RvLWtidWlsZC0yMzoyMDE0MDcxNTEyMTg0
MTp4ODZfNjQtcmFuZGNvbmZpZy1pdjAtMDcxNTExNTI6My4xNi4wLXJjNS0wNjAyMC1nYzlj
Yjg0YToyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYwLTA3MTUxMTUyL2M5Y2I4NGE5
YjA0ZGU4YzE2MmNmZDVkMWE1ZDY1NmJmYmE2MDUxMDAvZG1lc2cteW9jdG8ta2J1aWxkLTI1
OjIwMTQwNzE1MTIxODQxOng4Nl82NC1yYW5kY29uZmlnLWl2MC0wNzE1MTE1MjozLjE2LjAt
cmM1LTA2MDIwLWdjOWNiODRhOjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjAtMDcx
NTExNTIvYzljYjg0YTliMDRkZThjMTYyY2ZkNWQxYTVkNjU2YmZiYTYwNTEwMC9kbWVzZy15
b2N0by1rYnVpbGQtMjc6MjAxNDA3MTUxMjE4NDA6eDg2XzY0LXJhbmRjb25maWctaXYwLTA3
MTUxMTUyOjMuMTYuMC1yYzUtMDYwMjAtZ2M5Y2I4NGE6Mgova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWl2MC0wNzE1MTE1Mi9jOWNiODRhOWIwNGRlOGMxNjJjZmQ1ZDFhNWQ2NTZiZmJh
NjA1MTAwL2RtZXNnLXlvY3RvLWtidWlsZC0zMDoyMDE0MDcxNTEyMTg0MTp4ODZfNjQtcmFu
ZGNvbmZpZy1pdjAtMDcxNTExNTI6My4xNi4wLXJjNS0wNjAyMC1nYzljYjg0YToyCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctaXYwLTA3MTUxMTUyL2M5Y2I4NGE5YjA0ZGU4YzE2MmNm
ZDVkMWE1ZDY1NmJmYmE2MDUxMDAvZG1lc2cteW9jdG8ta2J1aWxkLTQ6MjAxNDA3MTUxMjE4
NDE6eDg2XzY0LXJhbmRjb25maWctaXYwLTA3MTUxMTUyOjMuMTYuMC1yYzUtMDYwMjAtZ2M5
Y2I4NGE6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MC0wNzE1MTE1Mi9jOWNiODRh
OWIwNGRlOGMxNjJjZmQ1ZDFhNWQ2NTZiZmJhNjA1MTAwL2RtZXNnLXlvY3RvLWtidWlsZC01
OjIwMTQwNzE1MTIxODQxOng4Nl82NC1yYW5kY29uZmlnLWl2MC0wNzE1MTE1MjozLjE2LjAt
cmM1LTA2MDIwLWdjOWNiODRhOjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjAtMDcx
NTExNTIvYzljYjg0YTliMDRkZThjMTYyY2ZkNWQxYTVkNjU2YmZiYTYwNTEwMC9kbWVzZy15
b2N0by1rYnVpbGQtNzoyMDE0MDcxNTEyMTg0MTp4ODZfNjQtcmFuZGNvbmZpZy1pdjAtMDcx
NTExNTI6My4xNi4wLXJjNS0wNjAyMC1nYzljYjg0YToyCjA6MTU6MjIgYWxsX2dvb2Q6YmFk
OmFsbF9iYWQgYm9vdHMKCmxpbmVhci1iaXNlY3Q6IGJhZCBicmFuY2ggbWF5IGJlIGJyYW5j
aCAnYWtwbS1jdXJyZW50L2N1cnJlbnQnCmxpbmVhci1iaXNlY3Q6IGhhbmRsZSBvdmVyIHRv
IGdpdCBiaXNlY3QKbGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBzdGFydCBjOWNiODRhOWIw
NGRlOGMxNjJjZmQ1ZDFhNWQ2NTZiZmJhNjA1MTAwIDY0ZTMyNDVjODcwZTU4MzAwNGYxOWQ5
ODljZGY5ZWRjYWI2MTMzZmQgLS0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgYzljYjg0
YS4uLiBNZXJnZSBicmFuY2ggJ2FrcG0tY3VycmVudC9jdXJyZW50JwpIRUFEIGlzIG5vdyBh
dCA1NGFmNjFkLi4uIE1lcmdlIGJyYW5jaCAnYWtwbS1jdXJyZW50L2N1cnJlbnQnCkJpc2Vj
dGluZzogMTg1IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4
IHN0ZXBzKQpbZmRiN2UyZmFmMGNmY2MzMTU0MGE3YzMzMTVhMTAzNmNhNjhmYzU1ZV0gZnMu
aCwgZHJpdmVycy9od21vbi9hc3VzX2F0azAxMTAuYzogZml4IERFRklORV9TSU1QTEVfQVRU
UklCVVRFIHNlbWljb2xvbiBkZWZpbml0aW9uIGFuZCB1c2UKbGluZWFyLWJpc2VjdDogZ2l0
IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCAvYy9ib290LWJpc2VjdC9saW51eDMvb2JqLWJpc2VjdApydW5uaW5nIC9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgz
L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1y
YW5kY29uZmlnLWl2MC0wNzE1MTE1Mi9uZXh0Om1hc3RlcjpmZGI3ZTJmYWYwY2ZjYzMxNTQw
YTdjMzMxNWExMDM2Y2E2OGZjNTVlOmJpc2VjdC1saW51eDMKCjIwMTQtMDctMTUtMTI6MjE6
MzggZmRiN2UyZmFmMGNmY2MzMTU0MGE3YzMzMTVhMTAzNmNhNjhmYzU1ZSBjb21waWxpbmcK
UXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQt
cmFuZGNvbmZpZy1pdjAtMDcxNTExNTItZmRiN2UyZmFmMGNmY2MzMTU0MGE3YzMzMTVhMTAz
NmNhNjhmYzU1ZQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaXYwLTA3MTUxMTUyL2ZkYjdlMmZhZjBjZmNjMzE1NDBhN2MzMzE1YTEwMzZjYTY4ZmM1
NWUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
L3g4Nl82NC1yYW5kY29uZmlnLWl2MC0wNzE1MTE1Mi1mZGI3ZTJmYWYwY2ZjYzMxNTQwYTdj
MzMxNWExMDM2Y2E2OGZjNTVlCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS9qYWtldG93bi1jb25zdW1lci94ODZfNjQtcmFuZGNvbmZpZy1p
djAtMDcxNTExNTItZmRiN2UyZmFmMGNmY2MzMTU0MGE3YzMzMTVhMTAzNmNhNjhmYzU1ZQpr
ZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYwLTA3MTUxMTUyL2ZkYjdlMmZh
ZjBjZmNjMzE1NDBhN2MzMzE1YTEwMzZjYTY4ZmM1NWUvdm1saW51ei0zLjE2LjAtcmM0LTAw
MjI0LWdmZGI3ZTJmCgoyMDE0LTA3LTE1LTEyOjI2OjM4IGRldGVjdGluZyBib290IHN0YXRl
IC4JMjMJMzUgU1VDQ0VTUwoKQmlzZWN0aW5nOiA5MiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0
IGFmdGVyIHRoaXMgKHJvdWdobHkgNyBzdGVwcykKWzJhMWZlNmY0M2VkZTBlN2NlNjgxZDQw
M2Q1YjU2ODEzMzE2YjcxMGFdIG5pbGZzMjogYWRkIC9zeXMvZnMvbmlsZnMyLzxkZXZpY2U+
L21vdW50ZWRfc25hcHNob3RzIGdyb3VwCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2Vj
dC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDMvb2JqLWJpc2Vj
dApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWct
aXYwLTA3MTUxMTUyL25leHQ6bWFzdGVyOjJhMWZlNmY0M2VkZTBlN2NlNjgxZDQwM2Q1YjU2
ODEzMzE2YjcxMGE6YmlzZWN0LWxpbnV4MwoKMjAxNC0wNy0xNS0xMjoyODowOSAyYTFmZTZm
NDNlZGUwZTdjZTY4MWQ0MDNkNWI1NjgxMzMxNmI3MTBhIGNvbXBpbGluZwpRdWV1ZWQgYnVp
bGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmln
LWl2MC0wNzE1MTE1Mi0yYTFmZTZmNDNlZGUwZTdjZTY4MWQ0MDNkNWI1NjgxMzMxNmI3MTBh
CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjAtMDcx
NTExNTIvMmExZmU2ZjQzZWRlMGU3Y2U2ODFkNDAzZDViNTY4MTMzMTZiNzEwYQp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJh
bmRjb25maWctaXYwLTA3MTUxMTUyLTJhMWZlNmY0M2VkZTBlN2NlNjgxZDQwM2Q1YjU2ODEz
MzE2YjcxMGEKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MC0wNzE1MTE1
Mi8yYTFmZTZmNDNlZGUwZTdjZTY4MWQ0MDNkNWI1NjgxMzMxNmI3MTBhL3ZtbGludXotMy4x
Ni4wLXJjNC0wMDMxNy1nMmExZmU2ZgoKMjAxNC0wNy0xNS0xMjozMDowOSBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAuLgkzNAkzNSBTVUNDRVNTCgpCaXNlY3Rpbmc6IDQ2IHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA2IHN0ZXBzKQpbMzRlNzU4OWRhZjJj
NDg1MzVmODdiNzYxZjkzNGMwMDM2ODY0Yzc4YV0ga2V4ZWMtYnppbWFnZTY0OiBmaXggdGhl
IG9yZGVyaW5nIG9mIHJlZ2lzdGVycwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgzL29iai1iaXNlY3QK
bHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWl2
MC0wNzE1MTE1Mi9uZXh0Om1hc3RlcjozNGU3NTg5ZGFmMmM0ODUzNWY4N2I3NjFmOTM0YzAw
MzY4NjRjNzhhOmJpc2VjdC1saW51eDMKCjIwMTQtMDctMTUtMTI6MzI6MTAgMzRlNzU4OWRh
ZjJjNDg1MzVmODdiNzYxZjkzNGMwMDM2ODY0Yzc4YSBjb21waWxpbmcKUXVldWVkIGJ1aWxk
IHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1p
djAtMDcxNTExNTItMzRlNzU4OWRhZjJjNDg1MzVmODdiNzYxZjkzNGMwMDM2ODY0Yzc4YQpD
aGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYwLTA3MTUx
MTUyLzM0ZTc1ODlkYWYyYzQ4NTM1Zjg3Yjc2MWY5MzRjMDAzNjg2NGM3OGEKd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5k
Y29uZmlnLWl2MC0wNzE1MTE1Mi0zNGU3NTg5ZGFmMmM0ODUzNWY4N2I3NjFmOTM0YzAwMzY4
NjRjNzhhCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjAtMDcxNTExNTIv
MzRlNzU4OWRhZjJjNDg1MzVmODdiNzYxZjkzNGMwMDM2ODY0Yzc4YS92bWxpbnV6LTMuMTYu
MC1yYzQtMDAzNjMtZzM0ZTc1ODkKCjIwMTQtMDctMTUtMTI6MzQ6MTAgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgCTUgVEVTVCBGQUlMVVJFClsgICAgMi42NjA0NzRdIHNoYTFfc3NzZTM6IFVz
aW5nIEFWWCBvcHRpbWl6ZWQgU0hBLTEgaW1wbGVtZW50YXRpb24KWyAgICAyLjY2MjYwNl0g
YWxnOiBObyB0ZXN0IGZvciBjcmMzMiAoY3JjMzItcGNsbXVsKQpbICAgIDIuNjYzMzEzXSBz
aGE1MTJfc3NzZTM6IFVzaW5nIEFWWCBvcHRpbWl6ZWQgU0hBLTUxMiBpbXBsZW1lbnRhdGlv
bgpbICAgIDIuNjgxNzk3XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIHBhZ2luZyBy
ZXF1ZXN0IGF0IGZmZmY4ODAwMGJiNTAxNTAKWyAgICAyLjY4Mjg3OV0gSVA6IFs8ZmZmZmZm
ZmY4MTI0ZmNjMD5dIHNsb2JfcGFnZV9hbGxvYysweDE0MC8weDU4MApbICAgIDIuNjgzNzg0
XSBQR0QgNDRkNDA2NyBQVUQgNDRkNTA2NyBQTUQgMTI3OTIwNjcgUFRFIDgwMDAwMDAwMGJi
NTAwNjAKWyAgICAyLjY4NDczMV0gT29wczogMDAwMCBbIzFdIFBSRUVNUFQgU01QIERFQlVH
X1BBR0VBTExPQwpbICAgIDIuNjg0NzMxXSBDUFU6IDEgUElEOiAyIENvbW06IGt0aHJlYWRk
IE5vdCB0YWludGVkIDMuMTYuMC1yYzQtMDAzNjMtZzM0ZTc1ODkgIzIKWyAgICAyLjY4NDcz
MV0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpb
ICAgIDIuNjg0NzMxXSB0YXNrOiBmZmZmODgwMDAwMDY4MDAwIHRpOiBmZmZmODgwMDAwMDZj
MDAwIHRhc2sudGk6IGZmZmY4ODAwMDAwNmMwMDAKWyAgICAyLjY4NDczMV0gUklQOiAwMDEw
Ols8ZmZmZmZmZmY4MTI0ZmNjMD5dICBbPGZmZmZmZmZmODEyNGZjYzA+XSBzbG9iX3BhZ2Vf
YWxsb2MrMHgxNDAvMHg1ODAKWyAgICAyLjY4NDczMV0gUlNQOiAwMDAwOmZmZmY4ODAwMDAw
NmZiOTggIEVGTEFHUzogMDAwMTAwMDYKWyAgICAyLjY4NDczMV0gUkFYOiAwMDAwMDAwMDAw
MDAwMDAwIFJCWDogZmZmZjg4MDAwYmI0ZWYwMCBSQ1g6IDAwMDAwMDAwMDAwMDAwMDIKWyAg
ICAyLjY4NDczMV0gUkRYOiAwMDAwMDAwMDAwMDAwMDAyIFJTSTogMDAwMDAwMDAwMDAwMTBh
OCBSREk6IGZmZmY4ODAwMGJiNGVmMDAKWyAgICAyLjY4NDczMV0gUkJQOiBmZmZmODgwMDAw
MDZmYmU4IFIwODogMDAwMDAwMDAwMDc5YTM5NCBSMDk6IGZmZmY4ODAwMGJiNGUwMDAKWyAg
ICAyLjY4NDczMV0gUjEwOiAwMDAwMDAwMDAwMDAwMDAyIFIxMTogZmZmZmZmZmZmZmM0MDAw
ZiBSMTI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAyLjY4NDczMV0gUjEzOiBmZmZmODgwMDBi
YjUwMTUwIFIxNDogMDAwMDAwMDAwMDc5YTM5ZiBSMTU6IDAwMDAwMDAwMDAwMDAwMDEKWyAg
ICAyLjY4NDczMV0gRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmY4ODAwMTI1
MDAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAgIDIuNjg0NzMxXSBDUzog
IDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzClsgICAgMi42
ODQ3MzFdIENSMjogZmZmZjg4MDAwYmI1MDE1MCBDUjM6IDAwMDAwMDAwMDJjMGIwMDAgQ1I0
OiAwMDAwMDAwMDAwMDQwNmUwClsgICAgMi42ODQ3MzFdIFN0YWNrOgpbICAgIDIuNjg0NzMx
XSAgZmZmZmVhMDAwMDJlZDM4MCAwMDAwMDAwMDAwMDAwMDU4IGZmZmZmZmZmZmZmZmZmZjgg
MDAwMDAwMDAwMDAwMDAwNwpbICAgIDIuNjg0NzMxXSAgMDAwMDAwNTgwMTU5NWY5MyAwMDAw
MDAwMDAwMDAwMGIwIDAwMDAwMDAwMDAwMDAwNTggMDAwMDAwMDAwMDAwMDAwMApbICAgIDIu
Njg0NzMxXSAgZmZmZmZmZmY4MmM1Mzg0MCAwMDAwMDAwMDAwMDAwMGIwIGZmZmY4ODAwMDAw
NmZjNDAgZmZmZmZmZmY4MTI1MGE4NApbICAgIDIuNjg0NzMxXSBDYWxsIFRyYWNlOgpbICAg
IDIuNjg0NzMxXSAgWzxmZmZmZmZmZjgxMjUwYTg0Pl0gc2xvYl9hbGxvYy5pc3JhLjcrMHhm
NC8weDM4MApbICAgIDIuNjg0NzMxXSAgWzxmZmZmZmZmZjgxNTk1ZjkzPl0gPyBuZXdfdGFz
a19zbWFjaysweDIzLzB4ODAKWyAgICAyLjY4NDczMV0gIFs8ZmZmZmZmZmY4MTI1MGVmYz5d
IF9fa21hbGxvYysweDFlYy8weDM3MApbICAgIDIuNjg0NzMxXSAgWzxmZmZmZmZmZjgxMjUw
YjkwPl0gPyBzbG9iX2FsbG9jLmlzcmEuNysweDIwMC8weDM4MApbICAgIDIuNjg0NzMxXSAg
WzxmZmZmZmZmZjgxNTk1ZjkzPl0gbmV3X3Rhc2tfc21hY2srMHgyMy8weDgwClsgICAgMi42
ODQ3MzFdICBbPGZmZmZmZmZmODE1OTg1NGY+XSBzbWFja19jcmVkX3ByZXBhcmUrMHgyZi8w
eDE1MApbICAgIDIuNjg0NzMxXSAgWzxmZmZmZmZmZjgxMjUxOWYzPl0gPyBrbWVtX2NhY2hl
X2FsbG9jKzB4MTMvMHgyMApbICAgIDIuNjg0NzMxXSAgWzxmZmZmZmZmZjgxNTkzYzE2Pl0g
c2VjdXJpdHlfcHJlcGFyZV9jcmVkcysweDE2LzB4MjAKWyAgICAyLjY4NDczMV0gIFs8ZmZm
ZmZmZmY4MTBmOTE3ZD5dIHByZXBhcmVfY3JlZHMrMHgxMWQvMHgyMzAKWyAgICAyLjY4NDcz
MV0gIFs8ZmZmZmZmZmY4MTBmOTMyMz5dIGNvcHlfY3JlZHMrMHgzMy8weDMzMApbICAgIDIu
Njg0NzMxXSAgWzxmZmZmZmZmZjgxMGI4MGY0Pl0gY29weV9wcm9jZXNzKzB4NjM0LzB4MmI4
MApbICAgIDIuNjg0NzMxXSAgWzxmZmZmZmZmZjgxMTI2YzRmPl0gPyB2YWxpZGF0ZV9jaGFp
bi5pc3JhLjMyKzB4MTJmLzB4MTIzMApbICAgIDIuNjg0NzMxXSAgWzxmZmZmZmZmZjgyMDk1
ZThjPl0gPyBfcmF3X3NwaW5fdW5sb2NrX2lycSsweDZjLzB4OTAKWyAgICAyLjY4NDczMV0g
IFs8ZmZmZmZmZmY4MTEwNDY1ZD5dID8gZ2V0X3BhcmVudF9pcCsweGQvMHg4MApbICAgIDIu
Njg0NzMxXSAgWzxmZmZmZmZmZjgxMGVmYmEwPl0gPyBfX2t0aHJlYWRfcGFya21lKzB4OTAv
MHg5MApbICAgIDIuNjg0NzMxXSAgWzxmZmZmZmZmZjgxMTJhODM2Pl0gPyBfX2xvY2tfYWNx
dWlyZSsweDQ4Ni8weGNlMApbICAgIDIuNjg0NzMxXSAgWzxmZmZmZmZmZjgxMGVmYmEwPl0g
PyBfX2t0aHJlYWRfcGFya21lKzB4OTAvMHg5MApbICAgIDIuNjg0NzMxXSAgWzxmZmZmZmZm
ZjgxMGJhODgxPl0gZG9fZm9yaysweDEzMS8weDc3MApbICAgIDIuNjg0NzMxXSAgWzxmZmZm
ZmZmZjgxMGYwOTRmPl0gPyBrdGhyZWFkZCsweDFiZi8weDI4MApbICAgIDIuNjg0NzMxXSAg
WzxmZmZmZmZmZjgxMTA0NjVkPl0gPyBnZXRfcGFyZW50X2lwKzB4ZC8weDgwClsgICAgMi42
ODQ3MzFdICBbPGZmZmZmZmZmODEwYmFlZTY+XSBrZXJuZWxfdGhyZWFkKzB4MjYvMHgzMApb
ICAgIDIuNjg0NzMxXSAgWzxmZmZmZmZmZjgxMGYwOTYzPl0ga3RocmVhZGQrMHgxZDMvMHgy
ODAKWyAgICAyLjY4NDczMV0gIFs8ZmZmZmZmZmY4MjA5NmZmYz5dID8gcmV0X2Zyb21fZm9y
aysweDdjLzB4YjAKWyAgICAyLjY4NDczMV0gIFs8ZmZmZmZmZmY4MTBmMDc5MD5dID8ga3Ro
cmVhZF9zdG9wKzB4MjcwLzB4MjcwClsgICAgMi42ODQ3MzFdICBbPGZmZmZmZmZmODIwOTZm
ZmM+XSByZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApbICAgIDIuNjg0NzMxXSAgWzxmZmZmZmZm
ZjgxMGYwNzkwPl0gPyBrdGhyZWFkX3N0b3ArMHgyNzAvMHgyNzAKWyAgICAyLjY4NDczMV0g
Q29kZTogNDggODkgYzEgODMgZTEgMDEgNDggODMgYzEgMDIgNDggODMgMDQgY2QgODggYmUg
ZjMgODIgMDEgODQgYzAgNzUgMDUgNDEgMGYgYjcgNzUgMDIgNDggMGYgYmYgZjYgNGMgODkg
ZWYgNDkgODMgYzYgMDEgNGQgOGQgMmMgNzEgPDQxPiAwZiBiNyA0NSAwMCA2NiA4NSBjMCAw
ZiA5ZiBjMSA0OCA4OSBjZSA4MyBlNiAwMSA0OCA4MyBjNiAwMiAKWyAgICAyLjY4NDczMV0g
UklQICBbPGZmZmZmZmZmODEyNGZjYzA+XSBzbG9iX3BhZ2VfYWxsb2MrMHgxNDAvMHg1ODAK
WyAgICAyLjY4NDczMV0gIFJTUCA8ZmZmZjg4MDAwMDA2ZmI5OD4KWyAgICAyLjY4NDczMV0g
Q1IyOiBmZmZmODgwMDBiYjUwMTUwClsgICAgMi42ODQ3MzFdIC0tLVsgZW5kIHRyYWNlIGFi
ZGMxMTdkODYzMDg5MDAgXS0tLQpbICAgIDIuNjg0NzMxXSBLZXJuZWwgcGFuaWMgLSBub3Qg
c3luY2luZzogRmF0YWwgZXhjZXB0aW9uCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYw
LTA3MTUxMTUyLzM0ZTc1ODlkYWYyYzQ4NTM1Zjg3Yjc2MWY5MzRjMDAzNjg2NGM3OGEvZG1l
c2cteW9jdG8ta2J1aWxkLTEzOjIwMTQwNzE1MTIzMTI3Ong4Nl82NC1yYW5kY29uZmlnLWl2
MC0wNzE1MTE1MjozLjE2LjAtcmM0LTAwMzYzLWczNGU3NTg5OjIKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1pdjAtMDcxNTExNTIvMzRlNzU4OWRhZjJjNDg1MzVmODdiNzYxZjkzNGMw
MDM2ODY0Yzc4YS9kbWVzZy15b2N0by1rYnVpbGQtMzI6MjAxNDA3MTUxMjMxMjk6eDg2XzY0
LXJhbmRjb25maWctaXYwLTA3MTUxMTUyOjMuMTYuMC1yYzQtMDAzNjMtZzM0ZTc1ODk6Mgov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MC0wNzE1MTE1Mi8zNGU3NTg5ZGFmMmM0ODUz
NWY4N2I3NjFmOTM0YzAwMzY4NjRjNzhhL2RtZXNnLXlvY3RvLWtidWlsZC01OjIwMTQwNzE1
MTIzMTI3Ong4Nl82NC1yYW5kY29uZmlnLWl2MC0wNzE1MTE1MjozLjE2LjAtcmM0LTAwMzYz
LWczNGU3NTg5OjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjAtMDcxNTExNTIvMzRl
NzU4OWRhZjJjNDg1MzVmODdiNzYxZjkzNGMwMDM2ODY0Yzc4YS9kbWVzZy15b2N0by1rYnVp
bGQtMTY6MjAxNDA3MTUxMjMxMjk6eDg2XzY0LXJhbmRjb25maWctaXYwLTA3MTUxMTUyOjMu
MTYuMC1yYzQtMDAzNjMtZzM0ZTc1ODk6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2
MC0wNzE1MTE1Mi8zNGU3NTg5ZGFmMmM0ODUzNWY4N2I3NjFmOTM0YzAwMzY4NjRjNzhhL2Rt
ZXNnLXlvY3RvLWtidWlsZC0yOjIwMTQwNzE1MTIzMTI5Ong4Nl82NC1yYW5kY29uZmlnLWl2
MC0wNzE1MTE1MjozLjE2LjAtcmM0LTAwMzYzLWczNGU3NTg5OjIKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1pdjAtMDcxNTExNTIvMzRlNzU4OWRhZjJjNDg1MzVmODdiNzYxZjkzNGMw
MDM2ODY0Yzc4YS9kbWVzZy1xdWFudGFsLWtidWlsZC0xOToyMDE0MDcxNTEyMzEzNTp4ODZf
NjQtcmFuZGNvbmZpZy1pdjAtMDcxNTExNTI6My4xNi4wLXJjNC0wMDM2My1nMzRlNzU4OToy
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYwLTA3MTUxMTUyLzM0ZTc1ODlkYWYyYzQ4
NTM1Zjg3Yjc2MWY5MzRjMDAzNjg2NGM3OGEvZG1lc2cteW9jdG8ta2J1aWxkLTEwOjIwMTQw
NzE1MTIzMTQ3Ong4Nl82NC1yYW5kY29uZmlnLWl2MC0wNzE1MTE1MjozLjE2LjAtcmM0LTAw
MzYzLWczNGU3NTg5OjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjAtMDcxNTExNTIv
MzRlNzU4OWRhZjJjNDg1MzVmODdiNzYxZjkzNGMwMDM2ODY0Yzc4YS9kbWVzZy15b2N0by1r
YnVpbGQtMjg6MjAxNDA3MTUxMjMxNDk6eDg2XzY0LXJhbmRjb25maWctaXYwLTA3MTUxMTUy
OjMuMTYuMC1yYzQtMDAzNjMtZzM0ZTc1ODk6MgozOjg6MTMgYWxsX2dvb2Q6YmFkOmFsbF9i
YWQgYm9vdHMKCkJpc2VjdGluZzogMjIgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0
aGlzIChyb3VnaGx5IDUgc3RlcHMpClswYTVmMDQ3ZGNkOTBhZjRjYjcyZGY1ODNlM2VlMjFh
OGQ5MjYyYzRmXSBmb3JrOiByZXNldCBtbS0+cGlubmVkX3ZtCnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51
eDMvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWctaXYwLTA3MTUxMTUyL25leHQ6bWFzdGVyOjBhNWYwNDdkY2Q5MGFmNGNi
NzJkZjU4M2UzZWUyMWE4ZDkyNjJjNGY6YmlzZWN0LWxpbnV4MwoKMjAxNC0wNy0xNS0xMjoz
NDo0MSAwYTVmMDQ3ZGNkOTBhZjRjYjcyZGY1ODNlM2VlMjFhOGQ5MjYyYzRmIGNvbXBpbGlu
ZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82
NC1yYW5kY29uZmlnLWl2MC0wNzE1MTE1Mi0wYTVmMDQ3ZGNkOTBhZjRjYjcyZGY1ODNlM2Vl
MjFhOGQ5MjYyYzRmCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1pdjAtMDcxNTExNTIvMGE1ZjA0N2RjZDkwYWY0Y2I3MmRmNTgzZTNlZTIxYThkOTI2
MmM0Zgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUveDg2XzY0LXJhbmRjb25maWctaXYwLTA3MTUxMTUyLTBhNWYwNDdkY2Q5MGFmNGNiNzJk
ZjU4M2UzZWUyMWE4ZDkyNjJjNGYKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWl2MC0wNzE1MTE1Mi8wYTVmMDQ3ZGNkOTBhZjRjYjcyZGY1ODNlM2VlMjFhOGQ5MjYyYzRm
L3ZtbGludXotMy4xNi4wLXJjNC0wMDM0MC1nMGE1ZjA0NwoKMjAxNC0wNy0xNS0xMjozNjo0
MSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMTcgVEVTVCBGQUlMVVJFClsgICAgMC43NjEwNTJd
IFBDSTogQ0xTIDAgYnl0ZXMsIGRlZmF1bHQgNjQKWyAgICAwLjc2Mjg5NF0gVW5wYWNraW5n
IGluaXRyYW1mcy4uLgpbICAgIDMuMTQwMDU5XSBkZWJ1ZzogdW5tYXBwaW5nIGluaXQgW21l
bSAweGZmZmY4ODAwMTI5M2QwMDAtMHhmZmZmODgwMDEzZmVmZmZmXQpbICAgIDMuMjA0Mzc4
XSBnZW5lcmFsIHByb3RlY3Rpb24gZmF1bHQ6IDAwMDAgWyMxXSBQUkVFTVBUIFNNUCBERUJV
R19QQUdFQUxMT0MKWyAgICAzLjIwNTY4N10gQ1BVOiAxIFBJRDogNjQgQ29tbTogY3J5cHRv
bWdyX3Rlc3QgTm90IHRhaW50ZWQgMy4xNi4wLXJjNC0wMDM0MC1nMGE1ZjA0NyAjMwpbICAg
IDMuMjA3MDI5XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8w
MS8yMDExClsgICAgMy4yMDczMzZdIHRhc2s6IGZmZmY4ODAwMGJhZmMwMDAgdGk6IGZmZmY4
ODAwMGJiMDAwMDAgdGFzay50aTogZmZmZjg4MDAwYmIwMDAwMApbICAgIDMuMjA3MzM2XSBS
SVA6IDAwMTA6WzxmZmZmZmZmZjgxNjQ1MThiPl0gIFs8ZmZmZmZmZmY4MTY0NTE4Yj5dIGxv
b2t1cF9vYmplY3QuaXNyYS4wKzB4MWIvMHg4MApbICAgIDMuMjA3MzM2XSBSU1A6IDAwMDA6
ZmZmZjg4MDAwYmIwM2MyOCAgRUZMQUdTOiAwMDAxMDAwNgpbICAgIDMuMjExNTg1XSBzaGEx
X3Nzc2UzOiBVc2luZyBBVlggb3B0aW1pemVkIFNIQS0xIGltcGxlbWVudGF0aW9uClsgICAg
My4yMDczMzZdIFJBWDogMDAwMDAwMDAwMDAwMDAwMCBSQlg6IGZmZmY4ODAwMTBkZThkNjAg
UkNYOiAwMDAwMDAwMDAwMDAwMDA1ClsgICAgMy4yMDczMzZdIFJEWDogMDAwMDAwMDAwMDAw
MDAwMiBSU0k6IDY5MmQ2MzMyMzM2MzcyNjMgUkRJOiBmZmZmODgwMDEwZGU4ZDYwClsgICAg
My4yMDczMzZdIFJCUDogZmZmZjg4MDAwYmIwM2MyOCBSMDg6IGZmZmY4ODAwMGJhZmM3Zjgg
UjA5OiAwMDAwMDAwMDAwMDAwMDAzClsgICAgMy4yMDczMzZdIFIxMDogMDAwMDAwMDAwMDAw
MDAwMCBSMTE6IGZmZmE0ZmQxZWJkYmUwMGMgUjEyOiAwMDAwMDAwMDAwMDNhZWMwClsgICAg
My4yMDczMzZdIFIxMzogZmZmZmZmZmY4MmMzZmJlMCBSMTQ6IGZmZmZmZmZmODQzYTFlMjgg
UjE1OiAwMDAwMDAwMDAwMDAwMDgyClsgICAgMy4yMDczMzZdIEZTOiAgMDAwMDAwMDAwMDAw
MDAwMCgwMDAwKSBHUzpmZmZmODgwMDEyNTAwMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAw
MDAwMDAKWyAgICAzLjIwNzMzNl0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDog
MDAwMDAwMDA4MDA1MDAzMwpbICAgIDMuMjA3MzM2XSBDUjI6IDAwMDAwMDAwZmZmZmZmZmYg
Q1IzOiAwMDAwMDAwMDAyYzBiMDAwIENSNDogMDAwMDAwMDAwMDA0MDZlMApbICAgIDMuMjA3
MzM2XSBTdGFjazoKWyAgICAzLjIwNzMzNl0gIGZmZmY4ODAwMGJiMDNjOTggZmZmZmZmZmY4
MTY0NTkzZSAwMDAwMDAwMjAwMDUzYWY4IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAzLjIwNzMz
Nl0gIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwNSBmZmZmODgwMDEwZGU4ZDYw
IGZmZmZmZmZmODJjM2ZiZTAKWyAgICAzLjIwNzMzNl0gIDAwMDAwMDAwMDAwMDAwMDEgZmZm
Zjg4MDAxMGRlOGQ2MCBmZmZmZmZmZjgyYzQwYzQwIGZmZmZmZmZmODEwZThmYTAKWyAgICAz
LjIwNzMzNl0gQ2FsbCBUcmFjZToKWyAgICAzLjIwNzMzNl0gIFs8ZmZmZmZmZmY4MTY0NTkz
ZT5dIGRlYnVnX29iamVjdF9hY3RpdmF0ZSsweGVlLzB4MjgwClsgICAgMy4yMDczMzZdICBb
PGZmZmZmZmZmODEwZThmYTA+XSA/IHB1dF9waWQrMHg3MC8weDcwClsgICAgMy4yMDczMzZd
ICBbPGZmZmZmZmZmODExNGYwMDI+XSBfX2NhbGxfcmN1LmNvbnN0cHJvcC41MisweGQyLzB4
N2EwClsgICAgMy4yMDczMzZdICBbPGZmZmZmZmZmODE2NDQ5MDM+XSA/IF9fdGhpc19jcHVf
cHJlZW1wdF9jaGVjaysweDEzLzB4MjAKWyAgICAzLjIwNzMzNl0gIFs8ZmZmZmZmZmY4MTEy
NmU0OD5dID8gdHJhY2VfaGFyZGlycXNfb2ZmX2NhbGxlcisweGM4LzB4MTYwClsgICAgMy4y
MDczMzZdICBbPGZmZmZmZmZmODExNGY2ZTc+XSBjYWxsX3JjdSsweDE3LzB4MjAKWyAgICAz
LjIwNzMzNl0gIFs8ZmZmZmZmZmY4MTBlOTEzYT5dIGZyZWVfcGlkKzB4MTdhLzB4MWEwClsg
ICAgMy4yMDczMzZdICBbPGZmZmZmZmZmODEwZTkxZTg+XSBfX2NoYW5nZV9waWQrMHg4OC8w
eDkwClsgICAgMy4yMDczMzZdICBbPGZmZmZmZmZmODEwZTlhYzA+XSBkZXRhY2hfcGlkKzB4
MTAvMHgyMApbICAgIDMuMjA3MzM2XSAgWzxmZmZmZmZmZjgxMGJiYTM0Pl0gcmVsZWFzZV90
YXNrKzB4MWM0LzB4NTkwClsgICAgMy4yMDczMzZdICBbPGZmZmZmZmZmODEwYmI4ODk+XSA/
IHJlbGVhc2VfdGFzaysweDE5LzB4NTkwClsgICAgMy4yMDczMzZdICBbPGZmZmZmZmZmODEx
MDJkMzM+XSA/IHByZWVtcHRfY291bnRfc3ViKzB4MTQzLzB4MjEwClsgICAgMy4yMDczMzZd
ICBbPGZmZmZmZmZmODEwYmUxYTA+XSBkb19leGl0KzB4YjkwLzB4MTBhMApbICAgIDMuMjA3
MzM2XSAgWzxmZmZmZmZmZjgxNWE4MjYwPl0gPyBjcnlwdG9tZ3Jfbm90aWZ5KzB4NzQwLzB4
NzQwClsgICAgMy4yMDczMzZdICBbPGZmZmZmZmZmODE1YTgyYWI+XSBjcnlwdG9tZ3JfdGVz
dCsweDRiLzB4NjAKWyAgICAzLjIwNzMzNl0gIFs8ZmZmZmZmZmY4MTBlZTA4Zj5dIGt0aHJl
YWQrMHgxMmYvMHgxNDAKWyAgICAzLjIwNzMzNl0gIFs8ZmZmZmZmZmY4MTBlZGY2MD5dID8g
X19rdGhyZWFkX3BhcmttZSsweDkwLzB4OTAKWyAgICAzLjIwNzMzNl0gIFs8ZmZmZmZmZmY4
MjA5MmYzYz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsgICAgMy4yMDczMzZdICBbPGZm
ZmZmZmZmODEwZWRmNjA+XSA/IF9fa3RocmVhZF9wYXJrbWUrMHg5MC8weDkwClsgICAgMy4y
MDczMzZdIENvZGU6IGMwIGU4IDVhIDBlIGM1IGZmIDViIDMxIGMwIDVkIGMzIDBmIDFmIDQ0
IDAwIDAwIDU1IDQ4IDg1IGY2IDQ4IDg5IGU1IDc0IDVlIDMxIGM5IGViIDBiIDBmIDFmIDAw
IDQ4IDhiIDM2IDQ4IDg1IGY2IDc0IDI4IDgzIGMxIDAxIDw0OD4gMzkgN2UgMTggMGYgOTQg
YzAgNDggODkgYzIgODMgZTIgMDEgNDggODMgYzIgMDIgNDggODMgMDQgZDUgClsgICAgMy4y
MDczMzZdIFJJUCAgWzxmZmZmZmZmZjgxNjQ1MThiPl0gbG9va3VwX29iamVjdC5pc3JhLjAr
MHgxYi8weDgwClsgICAgMy4yMDczMzZdICBSU1AgPGZmZmY4ODAwMGJiMDNjMjg+ClsgICAg
My4yMDczMzZdIC0tLVsgZW5kIHRyYWNlIDYzYzhjNjQ2OTFhNzNmYWUgXS0tLQpbICAgIDMu
MjA3MzM2XSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogRmF0YWwgZXhjZXB0aW9uCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYwLTA3MTUxMTUyLzBhNWYwNDdkY2Q5MGFmNGNi
NzJkZjU4M2UzZWUyMWE4ZDkyNjJjNGYvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMTM6MjAxNDA3
MTUxMjM0MDM6eDg2XzY0LXJhbmRjb25maWctaXYwLTA3MTUxMTUyOjMuMTYuMC1yYzQtMDAz
NDAtZzBhNWYwNDc6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MC0wNzE1MTE1Mi8w
YTVmMDQ3ZGNkOTBhZjRjYjcyZGY1ODNlM2VlMjFhOGQ5MjYyYzRmL2RtZXNnLXF1YW50YWwt
a2J1aWxkLTE0OjIwMTQwNzE1MTIzNDAxOng4Nl82NC1yYW5kY29uZmlnLWl2MC0wNzE1MTE1
MjozLjE2LjAtcmM0LTAwMzQwLWcwYTVmMDQ3OjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1pdjAtMDcxNTExNTIvMGE1ZjA0N2RjZDkwYWY0Y2I3MmRmNTgzZTNlZTIxYThkOTI2MmM0
Zi9kbWVzZy1xdWFudGFsLWtidWlsZC0yMToyMDE0MDcxNTEyMzQwMTp4ODZfNjQtcmFuZGNv
bmZpZy1pdjAtMDcxNTExNTI6My4xNi4wLXJjNC0wMDM0MC1nMGE1ZjA0NzozCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctaXYwLTA3MTUxMTUyLzBhNWYwNDdkY2Q5MGFmNGNiNzJkZjU4
M2UzZWUyMWE4ZDkyNjJjNGYvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjc6MjAxNDA3MTUxMjM0
MDE6eDg2XzY0LXJhbmRjb25maWctaXYwLTA3MTUxMTUyOjMuMTYuMC1yYzQtMDAzNDAtZzBh
NWYwNDc6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MC0wNzE1MTE1Mi8wYTVmMDQ3
ZGNkOTBhZjRjYjcyZGY1ODNlM2VlMjFhOGQ5MjYyYzRmL2RtZXNnLXF1YW50YWwta2J1aWxk
LTI5OjIwMTQwNzE1MTIzNDAyOng4Nl82NC1yYW5kY29uZmlnLWl2MC0wNzE1MTE1MjozLjE2
LjAtcmM0LTAwMzQwLWcwYTVmMDQ3OjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjAt
MDcxNTExNTIvMGE1ZjA0N2RjZDkwYWY0Y2I3MmRmNTgzZTNlZTIxYThkOTI2MmM0Zi9kbWVz
Zy1xdWFudGFsLWtidWlsZC0zMToyMDE0MDcxNTEyMzQwMTp4ODZfNjQtcmFuZGNvbmZpZy1p
djAtMDcxNTExNTI6My4xNi4wLXJjNC0wMDM0MC1nMGE1ZjA0NzozCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaXYwLTA3MTUxMTUyLzBhNWYwNDdkY2Q5MGFmNGNiNzJkZjU4M2UzZWUy
MWE4ZDkyNjJjNGYvZG1lc2ctcXVhbnRhbC1rYnVpbGQtOToyMDE0MDcxNTEyMzQwMTp4ODZf
NjQtcmFuZGNvbmZpZy1pdjAtMDcxNTExNTI6My4xNi4wLXJjNC0wMDM0MC1nMGE1ZjA0Nzoz
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYwLTA3MTUxMTUyLzBhNWYwNDdkY2Q5MGFm
NGNiNzJkZjU4M2UzZWUyMWE4ZDkyNjJjNGYvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMToyMDE0
MDcxNTEyMzQwOTp4ODZfNjQtcmFuZGNvbmZpZy1pdjAtMDcxNTExNTI6My4xNi4wLXJjNC0w
MDM0MC1nMGE1ZjA0NzozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYwLTA3MTUxMTUy
LzBhNWYwNDdkY2Q5MGFmNGNiNzJkZjU4M2UzZWUyMWE4ZDkyNjJjNGYvZG1lc2ctcXVhbnRh
bC1rYnVpbGQtMjM6MjAxNDA3MTUxMjM0MDk6eDg2XzY0LXJhbmRjb25maWctaXYwLTA3MTUx
MTUyOjMuMTYuMC1yYzQtMDAzNDAtZzBhNWYwNDc6Mwo2Ojk6MjAgYWxsX2dvb2Q6YmFkOmFs
bF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDctMTUgMTI6Mzc6MTIgUkVQRUFUIENPVU5UOiAz
OCAgIyAvYy9ib290LWJpc2VjdC9saW51eDMvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlz
ZWN0aW5nOiAxMSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
NCBzdGVwcykKW2UxOGNjMGI5NTZkZjllNzNlOTcxNTkyM2JiNTBlODVlNmJjYTg0ZWFdIGZz
L3JlaXNlcmZzOiB1c2UgbGludXgvdWFjY2Vzcy5oCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDMvb2Jq
LWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRj
b25maWctaXYwLTA3MTUxMTUyL25leHQ6bWFzdGVyOmUxOGNjMGI5NTZkZjllNzNlOTcxNTky
M2JiNTBlODVlNmJjYTg0ZWE6YmlzZWN0LWxpbnV4MwoKMjAxNC0wNy0xNS0xMjozNzoxMyBl
MThjYzBiOTU2ZGY5ZTczZTk3MTU5MjNiYjUwZTg1ZTZiY2E4NGVhIGNvbXBpbGluZwpRdWV1
ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5k
Y29uZmlnLWl2MC0wNzE1MTE1Mi1lMThjYzBiOTU2ZGY5ZTczZTk3MTU5MjNiYjUwZTg1ZTZi
Y2E4NGVhCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1p
djAtMDcxNTExNTIvZTE4Y2MwYjk1NmRmOWU3M2U5NzE1OTIzYmI1MGU4NWU2YmNhODRlYQp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2
XzY0LXJhbmRjb25maWctaXYwLTA3MTUxMTUyLWUxOGNjMGI5NTZkZjllNzNlOTcxNTkyM2Ji
NTBlODVlNmJjYTg0ZWEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL2pha2V0b3duLWNvbnN1bWVyL3g4Nl82NC1yYW5kY29uZmlnLWl2MC0w
NzE1MTE1Mi1lMThjYzBiOTU2ZGY5ZTczZTk3MTU5MjNiYjUwZTg1ZTZiY2E4NGVhCmtlcm5l
bDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjAtMDcxNTExNTIvZTE4Y2MwYjk1NmRm
OWU3M2U5NzE1OTIzYmI1MGU4NWU2YmNhODRlYS92bWxpbnV6LTMuMTYuMC1yYzQtMDAzMjgt
Z2UxOGNjMGIKCjIwMTQtMDctMTUtMTI6NDI6MTMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4J
MzcuCTM4IFNVQ0NFU1MKCkJpc2VjdGluZzogNSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgMyBzdGVwcykKW2I5NjUxMTIzMWVkNzhkNzM1ZGU5YTgzNTY4
NzYyOTU2YjA3NDcwNjZdIHByb2M6IGFkZCBhbmQgcmVtb3ZlIC9wcm9jIGVudHJ5IGNyZWF0
ZSBjaGVja3MKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4My9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQt
dGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1pdjAtMDcxNTExNTIvbmV4
dDptYXN0ZXI6Yjk2NTExMjMxZWQ3OGQ3MzVkZTlhODM1Njg3NjI5NTZiMDc0NzA2NjpiaXNl
Y3QtbGludXgzCgoyMDE0LTA3LTE1LTEyOjQ0OjQzIGI5NjUxMTIzMWVkNzhkNzM1ZGU5YTgz
NTY4NzYyOTU2YjA3NDcwNjYgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaXYwLTA3MTUxMTUyLWI5
NjUxMTIzMWVkNzhkNzM1ZGU5YTgzNTY4NzYyOTU2YjA3NDcwNjYKQ2hlY2sgZm9yIGtlcm5l
bCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MC0wNzE1MTE1Mi9iOTY1MTEyMzFl
ZDc4ZDczNWRlOWE4MzU2ODc2Mjk1NmIwNzQ3MDY2CndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1pdjAtMDcx
NTExNTItYjk2NTExMjMxZWQ3OGQ3MzVkZTlhODM1Njg3NjI5NTZiMDc0NzA2NgprZXJuZWw6
IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYwLTA3MTUxMTUyL2I5NjUxMTIzMWVkNzhk
NzM1ZGU5YTgzNTY4NzYyOTU2YjA3NDcwNjYvdm1saW51ei0zLjE2LjAtcmM0LTAwMzM0LWdi
OTY1MTEyCgoyMDE0LTA3LTE1LTEyOjQ2OjQzIGRldGVjdGluZyBib290IHN0YXRlIAkzOCBT
VUNDRVNTCgpCaXNlY3Rpbmc6IDIgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlz
IChyb3VnaGx5IDIgc3RlcHMpCls4ZTViOWQ4M2RhMTBjMGJhNWM0MGYzZjU3ZGQ1NGM2OGRj
YzQ5YjE4XSBwcm9jOiByZW1vdmUgcHJvY190dHlfbGRpc2MgdmFyaWFibGUKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlz
ZWN0L2xpbnV4My9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2
bS94ODZfNjQtcmFuZGNvbmZpZy1pdjAtMDcxNTExNTIvbmV4dDptYXN0ZXI6OGU1YjlkODNk
YTEwYzBiYTVjNDBmM2Y1N2RkNTRjNjhkY2M0OWIxODpiaXNlY3QtbGludXgzCgoyMDE0LTA3
LTE1LTEyOjQ3OjE0IDhlNWI5ZDgzZGExMGMwYmE1YzQwZjNmNTdkZDU0YzY4ZGNjNDliMTgg
Y29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUveDg2XzY0LXJhbmRjb25maWctaXYwLTA3MTUxMTUyLThlNWI5ZDgzZGExMGMwYmE1YzQw
ZjNmNTdkZDU0YzY4ZGNjNDliMTgKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWl2MC0wNzE1MTE1Mi84ZTViOWQ4M2RhMTBjMGJhNWM0MGYzZjU3ZGQ1
NGM2OGRjYzQ5YjE4CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1pdjAtMDcxNTExNTItOGU1YjlkODNkYTEw
YzBiYTVjNDBmM2Y1N2RkNTRjNjhkY2M0OWIxOAprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctaXYwLTA3MTUxMTUyLzhlNWI5ZDgzZGExMGMwYmE1YzQwZjNmNTdkZDU0YzY4
ZGNjNDliMTgvdm1saW51ei0zLjE2LjAtcmM0LTAwMzM3LWc4ZTViOWQ4CgoyMDE0LTA3LTE1
LTEyOjQ5OjE0IGRldGVjdGluZyBib290IHN0YXRlIAk0CTM3Li4JMzggU1VDQ0VTUwoKQmlz
ZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAx
IHN0ZXApCls4ZGY1OWZkMmEzNTAxNjFiZDM5YzNjOWY4ZjQyMTNiMmEyYTYxODQ3XSBmb3Jr
L2V4ZWM6IGNsZWFudXAgbW0gaW5pdGlhbGl6YXRpb24KcnVubmluZyAvYy9rZXJuZWwtdGVz
dHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4My9v
YmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFu
ZGNvbmZpZy1pdjAtMDcxNTExNTIvbmV4dDptYXN0ZXI6OGRmNTlmZDJhMzUwMTYxYmQzOWMz
YzlmOGY0MjEzYjJhMmE2MTg0NzpiaXNlY3QtbGludXgzCgoyMDE0LTA3LTE1LTEyOjUxOjQ0
IDhkZjU5ZmQyYTM1MDE2MWJkMzljM2M5ZjhmNDIxM2IyYTJhNjE4NDcgY29tcGlsaW5nClF1
ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJh
bmRjb25maWctaXYwLTA3MTUxMTUyLThkZjU5ZmQyYTM1MDE2MWJkMzljM2M5ZjhmNDIxM2Iy
YTJhNjE4NDcKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWl2MC0wNzE1MTE1Mi84ZGY1OWZkMmEzNTAxNjFiZDM5YzNjOWY4ZjQyMTNiMmEyYTYxODQ3
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94
ODZfNjQtcmFuZGNvbmZpZy1pdjAtMDcxNTExNTItOGRmNTlmZDJhMzUwMTYxYmQzOWMzYzlm
OGY0MjEzYjJhMmE2MTg0NwprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYw
LTA3MTUxMTUyLzhkZjU5ZmQyYTM1MDE2MWJkMzljM2M5ZjhmNDIxM2IyYTJhNjE4NDcvdm1s
aW51ei0zLjE2LjAtcmM0LTAwMzM5LWc4ZGY1OWZkCgoyMDE0LTA3LTE1LTEyOjUzOjQ1IGRl
dGVjdGluZyBib290IHN0YXRlIAkzNgkzNy4uCTM4IFNVQ0NFU1MKCjBhNWYwNDdkY2Q5MGFm
NGNiNzJkZjU4M2UzZWUyMWE4ZDkyNjJjNGYgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQKY29t
bWl0IDBhNWYwNDdkY2Q5MGFmNGNiNzJkZjU4M2UzZWUyMWE4ZDkyNjJjNGYKQXV0aG9yOiBW
bGFkaW1pciBEYXZ5ZG92IDx2ZGF2eWRvdkBwYXJhbGxlbHMuY29tPgpEYXRlOiAgIFRodSBK
dWwgMTAgMTA6MjY6MjMgMjAxNCArMTAwMAoKICAgIGZvcms6IHJlc2V0IG1tLT5waW5uZWRf
dm0KICAgIAogICAgbW0tPnBpbm5lZF92bSBjb3VudHMgcGFnZXMgb2YgbW0ncyBhZGRyZXNz
IHNwYWNlIHRoYXQgd2VyZSBwZXJtYW5lbnRseQogICAgcGlubmVkIGluIG1lbW9yeSBieSBp
bmNyZWFzaW5nIHRoZWlyIHJlZmVyZW5jZSBjb3VudGVyLiBUaGUgY291bnRlciB3YXMKICAg
IGludHJvZHVjZWQgYnkgY29tbWl0IGJjM2U1M2Y2ODJkOSAoIm1tOiBkaXN0aW5ndWlzaCBi
ZXR3ZWVuIG1sb2NrZWQgYW5kCiAgICBwaW5uZWQgcGFnZXMiKSwgd2hpbGUgYmVmb3JlIGl0
IGxvY2tlZF92bSBoYWQgYmVlbiB1c2VkIGZvciBzdWNoIHBhZ2VzLgogICAgCiAgICBPYnZp
b3VzbHksIHdlIHNob3VsZCByZXNldCB0aGUgY291bnRlciBvbiBmb3JrIGlmICFDTE9ORV9W
TSwganVzdCBsaWtlCiAgICB3ZSBkbyB3aXRoIGxvY2tlZF92bSwgYnV0IGN1cnJlbnRseSB3
ZSBkb24ndC4gTGV0J3MgZml4IGl0LgogICAgCiAgICBUaGlzIHBhdGNoIHdpbGwgZml4IHRo
ZSBjb250ZW50cyBvZiAvcHJvYy9waWQvc3RhdHVzOlZtUGluLgogICAgCiAgICBpYl91bWVt
X2dldFtpbmZpbmliYW5kXSBhbmQgcGVyZl9tbWFwIHN0aWxsIGNoZWNrIHBpbm5lZF92bSBh
Z2FpbnN0CiAgICBSTElNSVRfTUVNTE9DSy4gIEl0J3MgbGVmdCBmcm9tIHRoZSB0aW1lcyB3
aGVuIHBpbm5lZCBwYWdlcyB3ZXJlIGFjY291bnRlZAogICAgdW5kZXIgbG9ja2VkX3ZtLCBi
dXQgdG9kYXkgaXQgbG9va3Mgd3JvbmcuICBJdCBpc24ndCBjbGVhciBob3cgd2Ugc2hvdWxk
CiAgICBkZWFsIHdpdGggaXQuCiAgICAKICAgIFdlIHN0aWxsIGhhdmUgc29tZSBkcml2ZXJz
IGFjY291bnRpbmcgcGlubmVkIHBhZ2VzIHVuZGVyIG1tLT5sb2NrZWRfdm0gLQogICAgdGhp
cyBpcyB3aGF0IGNvbW1pdCBiYzNlNTNmNjgyZDkgd2FzIGZpZ2h0aW5nIGFnYWluc3QuICBJ
dCdzCiAgICBpbmZpbmliYW5kL3VzbmljIGFuZCB2ZmlvLgogICAgCiAgICBTaWduZWQtb2Zm
LWJ5OiBWbGFkaW1pciBEYXZ5ZG92IDx2ZGF2eWRvdkBwYXJhbGxlbHMuY29tPgogICAgQ2M6
IE9sZWcgTmVzdGVyb3YgPG9sZWdAcmVkaGF0LmNvbT4KICAgIENjOiBEYXZpZCBSaWVudGpl
cyA8cmllbnRqZXNAZ29vZ2xlLmNvbT4KICAgIENjOiBDaHJpc3RvcGggTGFtZXRlciA8Y2xA
bGludXguY29tPgogICAgQ2M6IFJvbGFuZCBEcmVpZXIgPHJvbGFuZEBrZXJuZWwub3JnPgog
ICAgQ2M6IFNlYW4gSGVmdHkgPHNlYW4uaGVmdHlAaW50ZWwuY29tPgogICAgQ2M6IEhhbCBS
b3NlbnN0b2NrIDxoYWwucm9zZW5zdG9ja0BnbWFpbC5jb20+CiAgICBTaWduZWQtb2ZmLWJ5
OiBBbmRyZXcgTW9ydG9uIDxha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnPgoKOjA0MDAwMCAw
NDAwMDAgZDg3ZTZkNWM3NDk1OWM5MWQzM2NmMGE1N2VkYmI0ZTQ0Mjk5MjAyOCBjNDVhZmNk
OTY3ZmI0MmI3MWE1Zjg0ZGU2YWY0NGRjOTRkNDQ3Y2FkIE0Ja2VybmVsCmJpc2VjdCBydW4g
c3VjY2VzcwpIRUFEIGlzIG5vdyBhdCA4ZGY1OWZkLi4uIGZvcmsvZXhlYzogY2xlYW51cCBt
bSBpbml0aWFsaXphdGlvbgpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2
XzY0LXJhbmRjb25maWctaXYwLTA3MTUxMTUyL25leHQ6bWFzdGVyOjhkZjU5ZmQyYTM1MDE2
MWJkMzljM2M5ZjhmNDIxM2IyYTJhNjE4NDc6YmlzZWN0LWxpbnV4MwoKMjAxNC0wNy0xNS0x
Mjo1NjoxNSA4ZGY1OWZkMmEzNTAxNjFiZDM5YzNjOWY4ZjQyMTNiMmEyYTYxODQ3IHJldXNl
IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYwLTA3MTUxMTUyLzhkZjU5ZmQyYTM1MDE2
MWJkMzljM2M5ZjhmNDIxM2IyYTJhNjE4NDcvdm1saW51ei0zLjE2LjAtcmM0LTAwMzM5LWc4
ZGY1OWZkCgoyMDE0LTA3LTE1LTEyOjU2OjE1IGRldGVjdGluZyBib290IHN0YXRlIC4uCTQw
CTczCTk3CTExMgkxMTQgU1VDQ0VTUwoKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgOGRm
NTlmZC4uLiBmb3JrL2V4ZWM6IGNsZWFudXAgbW0gaW5pdGlhbGl6YXRpb24KSEVBRCBpcyBu
b3cgYXQgYTIwNDE2Yy4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAx
NDA3MTQKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29u
ZmlnLWl2MC0wNzE1MTE1Mi9uZXh0Om1hc3RlcjphMjA0MTZjNDA3MTAxMGJlNTI1Zjc0Yzcw
YzdhNzljNWVlNmEyYTA1OmJpc2VjdC1saW51eDMKIFRFU1QgRkFJTFVSRQpbICAgIDIuOTY3
NTk1XSBzaGExX3Nzc2UzOiBVc2luZyBBVlggb3B0aW1pemVkIFNIQS0xIGltcGxlbWVudGF0
aW9uClsgICAgMi45ODQ4OTNdIGFsZzogTm8gdGVzdCBmb3IgY3JjMzIgKGNyYzMyLXBjbG11
bCkKWyAgICAyLjk4NTYxMF0gc2hhNTEyX3Nzc2UzOiBVc2luZyBBVlggb3B0aW1pemVkIFNI
QS01MTIgaW1wbGVtZW50YXRpb24KWyAgICAzLjAwMjIzMl0gQlVHOiB1bmFibGUgdG8gaGFu
ZGxlIGtlcm5lbCBwYWdpbmcgcmVxdWVzdCBhdCBmZmZmODgwMDEwZDYzMDAwClsgICAgMy4w
MDMyOTVdIElQOiBbPGZmZmZmZmZmODEyNTZkYjA+XSBzbG9iX3BhZ2VfYWxsb2MrMHg0ZjAv
MHg1ODAKWyAgICAzLjAwNDIxNl0gUEdEIDQ0ZDkwNjcgUFVEIDQ0ZGEwNjcgUE1EIDEyN2Zi
MDY3IFBURSA4MDAwMDAwMDEwZDYzMDYwClsgICAgMy4wMDUyMjNdIE9vcHM6IDAwMDIgWyMx
XSBQUkVFTVBUIFNNUCBERUJVR19QQUdFQUxMT0MKWyAgICAzLjAwNTQyOF0gQ1BVOiAwIFBJ
RDogMiBDb21tOiBrdGhyZWFkZCBOb3QgdGFpbnRlZCAzLjE2LjAtcmM1LW5leHQtMjAxNDA3
MTQgIzEyNgpbICAgIDMuMDA1NDI4XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklP
UyBCb2NocyAwMS8wMS8yMDExClsgICAgMy4wMDU0MjhdIHRhc2s6IGZmZmY4ODAwMDAwNjgw
MDAgdGk6IGZmZmY4ODAwMDAwNmMwMDAgdGFzay50aTogZmZmZjg4MDAwMDA2YzAwMApbICAg
IDMuMDA1NDI4XSBSSVA6IDAwMTA6WzxmZmZmZmZmZjgxMjU2ZGIwPl0gIFs8ZmZmZmZmZmY4
MTI1NmRiMD5dIHNsb2JfcGFnZV9hbGxvYysweDRmMC8weDU4MApbICAgIDMuMDA1NDI4XSBS
U1A6IDAwMDA6ZmZmZjg4MDAwMDA2ZmJlOCAgRUZMQUdTOiAwMDAxMDAwMgpbICAgIDMuMDA1
NDI4XSBSQVg6IGZmZmZmZmZmZmZmZmZmODAgUkJYOiBmZmZmODgwMDEwZDYzMDAwIFJDWDog
MDAwMDAwMDAwMDAwMDAwMQpbICAgIDMuMDA1NDI4XSBSRFg6IGZmZmY4ODAwMTBkNjIwMDAg
UlNJOiAwMDAwMDAwMDAwMDAwMDAxIFJESTogMDAwMDAwMDAwMDAwMDAwMwpbICAgIDMuMDA1
NDI4XSBSQlA6IGZmZmY4ODAwMDAwNmZjMzggUjA4OiBmZmZmODgwMDEwZDYzMDAwIFIwOTog
MDAwMDAwMDAwMDAwNjlhYwpbICAgIDMuMDA1NDI4XSBSMTA6IDAwMDAwMDAwMDAwMDAwMDMg
UjExOiBmZmZmZmZmZmZmYzQwMDBmIFIxMjogMDAwMDAwMDAwMDAwMDAwOApbICAgIDMuMDA1
NDI4XSBSMTM6IGZmZmY4ODAwMTBkNjJmZjAgUjE0OiAwMDAwMDAwMDAwN2FiMTEzIFIxNTog
ZmZmZjg4MDAxMGQ2MmZmMApbICAgIDMuMDA1NDI4XSBGUzogIDAwMDAwMDAwMDAwMDAwMDAo
MDAwMCkgR1M6ZmZmZjg4MDAxMjQwMDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAw
ClsgICAgMy4wMDU0MjhdIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAw
MDAwODAwNTAwMzMKWyAgICAzLjAwNTQyOF0gQ1IyOiBmZmZmODgwMDEwZDYzMDAwIENSMzog
MDAwMDAwMDAwMmMwYjAwMCBDUjQ6IDAwMDAwMDAwMDAwNDA2ZjAKWyAgICAzLjAwNTQyOF0g
U3RhY2s6ClsgICAgMy4wMDU0MjhdICBmZmZmZWEwMDAwNDM1ODgwIDAwMDAwMDAwMDAwMDAw
MjggZmZmZmZmZmZmZmZmZmZjMCAwMDAwMDAwMDAwMDAwMDNmClsgICAgMy4wMDU0MjhdICAw
MDAwMDAyODAxMDk2NGIwIDAwMDAwMDAwMDAwMDAwNTAgMDAwMDAwMDAwMDAwMDAyOCAwMDAw
MDAwMDAwMDAwMDAwClsgICAgMy4wMDU0MjhdICBmZmZmZmZmZjgyYzU0NzgwIDAwMDAwMDAw
MDAwMDAwMDAgZmZmZjg4MDAwMDA2ZmM5MCBmZmZmZmZmZjgxMjU3N2M0ClsgICAgMy4wMDU0
MjhdIENhbGwgVHJhY2U6ClsgICAgMy4wMDU0MjhdICBbPGZmZmZmZmZmODEyNTc3YzQ+XSBz
bG9iX2FsbG9jLmlzcmEuNysweGY0LzB4MzgwClsgICAgMy4wMDU0MjhdICBbPGZmZmZmZmZm
ODEyNTg2M2U+XSBzbG9iX2FsbG9jX25vZGUrMHgxZWUvMHgyZDAKWyAgICAzLjAwNTQyOF0g
IFs8ZmZmZmZmZmY4MTI1ODczMz5dIGttZW1fY2FjaGVfYWxsb2MrMHgxMy8weDIwClsgICAg
My4wMDU0MjhdICBbPGZmZmZmZmZmODEwZWE3OGI+XSBhbGxvY19waWQrMHgyYi8weDcxMApb
ICAgIDMuMDA1NDI4XSAgWzxmZmZmZmZmZjgxMGVjZjkwPl0gPyBfX2t0aHJlYWRfcGFya21l
KzB4OTAvMHg5MApbICAgIDMuMDA1NDI4XSAgWzxmZmZmZmZmZjgxMGJmMGFlPl0gY29weV9w
cm9jZXNzKzB4MTcwZS8weDJiODAKWyAgICAzLjAwNTQyOF0gIFs8ZmZmZmZmZmY4MjBhYzFk
Yz5dID8gX3Jhd19zcGluX3VubG9ja19pcnErMHg2Yy8weDkwClsgICAgMy4wMDU0MjhdICBb
PGZmZmZmZmZmODEwZmM4ZGQ+XSA/IGdldF9wYXJlbnRfaXArMHhkLzB4ODAKWyAgICAzLjAw
NTQyOF0gIFs8ZmZmZmZmZmY4MTBlY2Y5MD5dID8gX19rdGhyZWFkX3BhcmttZSsweDkwLzB4
OTAKWyAgICAzLjAwNTQyOF0gIFs8ZmZmZmZmZmY4MTBlY2Y5MD5dID8gX19rdGhyZWFkX3Bh
cmttZSsweDkwLzB4OTAKWyAgICAzLjAwNTQyOF0gIFs8ZmZmZmZmZmY4MTBjMDc2MT5dIGRv
X2ZvcmsrMHgxMzEvMHg3NzAKWyAgICAzLjAwNTQyOF0gIFs8ZmZmZmZmZmY4MTBlZGQzZj5d
ID8ga3RocmVhZGQrMHgxYmYvMHgyODAKWyAgICAzLjAwNTQyOF0gIFs8ZmZmZmZmZmY4MTBm
YzhkZD5dID8gZ2V0X3BhcmVudF9pcCsweGQvMHg4MApbICAgIDMuMDA1NDI4XSAgWzxmZmZm
ZmZmZjgxMGMwZGM2Pl0ga2VybmVsX3RocmVhZCsweDI2LzB4MzAKWyAgICAzLjAwNTQyOF0g
IFs8ZmZmZmZmZmY4MTBlZGQ1Mz5dIGt0aHJlYWRkKzB4MWQzLzB4MjgwClsgICAgMy4wMDU0
MjhdICBbPGZmZmZmZmZmODIwYWQzN2M+XSA/IHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsg
ICAgMy4wMDU0MjhdICBbPGZmZmZmZmZmODEwZWRiODA+XSA/IGt0aHJlYWRfc3RvcCsweDI3
MC8weDI3MApbICAgIDMuMDA1NDI4XSAgWzxmZmZmZmZmZjgyMGFkMzdjPl0gcmV0X2Zyb21f
Zm9yaysweDdjLzB4YjAKWyAgICAzLjAwNTQyOF0gIFs8ZmZmZmZmZmY4MTBlZGI4MD5dID8g
a3RocmVhZF9zdG9wKzB4MjcwLzB4MjcwClsgICAgMy4wMDU0MjhdIENvZGU6IDRjIDg5IGRi
IDgzIGUzIDAxIDQ4IDgzIGMzIDAyIDQ4IDgzIDA0IGRkIGUwIGUxIGYzIDgyIDAxIDQ1IDg0
IGRiIDc0IDc5IDY2IDg5IDc3IDAyIGU5IDAyIGZmIGZmIGZmIDY2IDJlIDBmIDFmIDg0IDAw
IDAwIDAwIDAwIDAwIDw2Nj4gNDQgODkgMGIgNjYgODkgNDMgMDIgZTkgMTkgZmUgZmYgZmYg
MGYgMWYgMDAgNDggOGIgNDUgYjAgNGMgClsgICAgMy4wMDU0MjhdIFJJUCAgWzxmZmZmZmZm
ZjgxMjU2ZGIwPl0gc2xvYl9wYWdlX2FsbG9jKzB4NGYwLzB4NTgwClsgICAgMy4wMDU0Mjhd
ICBSU1AgPGZmZmY4ODAwMDAwNmZiZTg+ClsgICAgMy4wMDU0MjhdIENSMjogZmZmZjg4MDAx
MGQ2MzAwMApbICAgIDMuMDA1NDI4XSAtLS1bIGVuZCB0cmFjZSA5NTE3MTkzZTY0YjdmOWNj
IF0tLS0KWyAgICAzLjAwNTQyOF0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEZhdGFs
IGV4Y2VwdGlvbgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MC0wNzE1MTE1Mi9hMjA0
MTZjNDA3MTAxMGJlNTI1Zjc0YzcwYzdhNzljNWVlNmEyYTA1L2RtZXNnLXF1YW50YWwta2J1
aWxkLTEwOjIwMTQwNzE1MTIwMjE4Ong4Nl82NC1yYW5kY29uZmlnLWl2MC0wNzE1MTE1Mjoz
LjE2LjAtcmM1LW5leHQtMjAxNDA3MTQ6MTI2Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
aXYwLTA3MTUxMTUyL2EyMDQxNmM0MDcxMDEwYmU1MjVmNzRjNzBjN2E3OWM1ZWU2YTJhMDUv
ZG1lc2cteW9jdG8ta2J1aWxkLTE6MjAxNDA3MTUxMTU0Mzc6eDg2XzY0LXJhbmRjb25maWct
aXYwLTA3MTUxMTUyOjMuMTYuMC1yYzUtbmV4dC0yMDE0MDcxNDoxMjYKNjoyOjUgYWxsX2dv
b2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkhFQUQgaXMgbm93IGF0IGEyMDQxNmMgQWRkIGxpbnV4
LW5leHQgc3BlY2lmaWMgZmlsZXMgZm9yIDIwMTQwNzE0Cgo9PT09PT09PT0gbGludXMvbWFz
dGVyID09PT09PT09PQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBhMjA0MTZjLi4uIEFk
ZCBsaW51eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0MDcxNApIRUFEIGlzIG5vdyBh
dCAxNzk1Y2Q5Li4uIExpbnV4IDMuMTYtcmM1CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1
ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1pdjAtMDcxNTExNTIvbGludXM6bWFzdGVyOjE3
OTVjZDliM2E5MWQ0YjU0NzNjOTdmNDkxZDYzODkyNDQyMjEyYWI6YmlzZWN0LWxpbnV4MwoK
MjAxNC0wNy0xNS0xMzowMDowNCAxNzk1Y2Q5YjNhOTFkNGI1NDczYzk3ZjQ5MWQ2Mzg5MjQ0
MjIxMmFiIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWl2MC0wNzE1MTE1Mi0xNzk1Y2Q5YjNhOTFk
NGI1NDczYzk3ZjQ5MWQ2Mzg5MjQ0MjIxMmFiCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1pdjAtMDcxNTExNTIvMTc5NWNkOWIzYTkxZDRiNTQ3M2M5
N2Y0OTFkNjM4OTI0NDIyMTJhYgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaXYwLTA3MTUxMTUyLTE3OTVj
ZDliM2E5MWQ0YjU0NzNjOTdmNDkxZDYzODkyNDQyMjEyYWIKa2VybmVsOiAva2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWl2MC0wNzE1MTE1Mi8xNzk1Y2Q5YjNhOTFkNGI1NDczYzk3ZjQ5
MWQ2Mzg5MjQ0MjIxMmFiL3ZtbGludXotMy4xNi4wLXJjNQoKMjAxNC0wNy0xNS0xMzowMjow
NCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMjgJNzIJNzYJMTA4CTExNCBTVUNDRVNTCgoKPT09
PT09PT09IG5leHQvbWFzdGVyID09PT09PT09PQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdh
cyAxNzk1Y2Q5Li4uIExpbnV4IDMuMTYtcmM1CkhFQUQgaXMgbm93IGF0IGEyMDQxNmMuLi4g
QWRkIGxpbnV4LW5leHQgc3BlY2lmaWMgZmlsZXMgZm9yIDIwMTQwNzE0CmxzIC1hIC9rYnVp
bGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1pdjAtMDcxNTExNTIv
bmV4dDptYXN0ZXI6YTIwNDE2YzQwNzEwMTBiZTUyNWY3NGM3MGM3YTc5YzVlZTZhMmEwNTpi
aXNlY3QtbGludXgzCiBURVNUIEZBSUxVUkUKWyAgICAyLjk2NzU5NV0gc2hhMV9zc3NlMzog
VXNpbmcgQVZYIG9wdGltaXplZCBTSEEtMSBpbXBsZW1lbnRhdGlvbgpbICAgIDIuOTg0ODkz
XSBhbGc6IE5vIHRlc3QgZm9yIGNyYzMyIChjcmMzMi1wY2xtdWwpClsgICAgMi45ODU2MTBd
IHNoYTUxMl9zc3NlMzogVXNpbmcgQVZYIG9wdGltaXplZCBTSEEtNTEyIGltcGxlbWVudGF0
aW9uClsgICAgMy4wMDIyMzJdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5n
IHJlcXVlc3QgYXQgZmZmZjg4MDAxMGQ2MzAwMApbICAgIDMuMDAzMjk1XSBJUDogWzxmZmZm
ZmZmZjgxMjU2ZGIwPl0gc2xvYl9wYWdlX2FsbG9jKzB4NGYwLzB4NTgwClsgICAgMy4wMDQy
MTZdIFBHRCA0NGQ5MDY3IFBVRCA0NGRhMDY3IFBNRCAxMjdmYjA2NyBQVEUgODAwMDAwMDAx
MGQ2MzA2MApbICAgIDMuMDA1MjIzXSBPb3BzOiAwMDAyIFsjMV0gUFJFRU1QVCBTTVAgREVC
VUdfUEFHRUFMTE9DClsgICAgMy4wMDU0MjhdIENQVTogMCBQSUQ6IDIgQ29tbToga3RocmVh
ZGQgTm90IHRhaW50ZWQgMy4xNi4wLXJjNS1uZXh0LTIwMTQwNzE0ICMxMjYKWyAgICAzLjAw
NTQyOF0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAx
MQpbICAgIDMuMDA1NDI4XSB0YXNrOiBmZmZmODgwMDAwMDY4MDAwIHRpOiBmZmZmODgwMDAw
MDZjMDAwIHRhc2sudGk6IGZmZmY4ODAwMDAwNmMwMDAKWyAgICAzLjAwNTQyOF0gUklQOiAw
MDEwOls8ZmZmZmZmZmY4MTI1NmRiMD5dICBbPGZmZmZmZmZmODEyNTZkYjA+XSBzbG9iX3Bh
Z2VfYWxsb2MrMHg0ZjAvMHg1ODAKWyAgICAzLjAwNTQyOF0gUlNQOiAwMDAwOmZmZmY4ODAw
MDAwNmZiZTggIEVGTEFHUzogMDAwMTAwMDIKWyAgICAzLjAwNTQyOF0gUkFYOiBmZmZmZmZm
ZmZmZmZmZjgwIFJCWDogZmZmZjg4MDAxMGQ2MzAwMCBSQ1g6IDAwMDAwMDAwMDAwMDAwMDEK
WyAgICAzLjAwNTQyOF0gUkRYOiBmZmZmODgwMDEwZDYyMDAwIFJTSTogMDAwMDAwMDAwMDAw
MDAwMSBSREk6IDAwMDAwMDAwMDAwMDAwMDMKWyAgICAzLjAwNTQyOF0gUkJQOiBmZmZmODgw
MDAwMDZmYzM4IFIwODogZmZmZjg4MDAxMGQ2MzAwMCBSMDk6IDAwMDAwMDAwMDAwMDY5YWMK
WyAgICAzLjAwNTQyOF0gUjEwOiAwMDAwMDAwMDAwMDAwMDAzIFIxMTogZmZmZmZmZmZmZmM0
MDAwZiBSMTI6IDAwMDAwMDAwMDAwMDAwMDgKWyAgICAzLjAwNTQyOF0gUjEzOiBmZmZmODgw
MDEwZDYyZmYwIFIxNDogMDAwMDAwMDAwMDdhYjExMyBSMTU6IGZmZmY4ODAwMTBkNjJmZjAK
WyAgICAzLjAwNTQyOF0gRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmY4ODAw
MTI0MDAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAgIDMuMDA1NDI4XSBD
UzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzClsgICAg
My4wMDU0MjhdIENSMjogZmZmZjg4MDAxMGQ2MzAwMCBDUjM6IDAwMDAwMDAwMDJjMGIwMDAg
Q1I0OiAwMDAwMDAwMDAwMDQwNmYwClsgICAgMy4wMDU0MjhdIFN0YWNrOgpbICAgIDMuMDA1
NDI4XSAgZmZmZmVhMDAwMDQzNTg4MCAwMDAwMDAwMDAwMDAwMDI4IGZmZmZmZmZmZmZmZmZm
YzAgMDAwMDAwMDAwMDAwMDAzZgpbICAgIDMuMDA1NDI4XSAgMDAwMDAwMjgwMTA5NjRiMCAw
MDAwMDAwMDAwMDAwMDUwIDAwMDAwMDAwMDAwMDAwMjggMDAwMDAwMDAwMDAwMDAwMApbICAg
IDMuMDA1NDI4XSAgZmZmZmZmZmY4MmM1NDc4MCAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAw
MDAwNmZjOTAgZmZmZmZmZmY4MTI1NzdjNApbICAgIDMuMDA1NDI4XSBDYWxsIFRyYWNlOgpb
ICAgIDMuMDA1NDI4XSAgWzxmZmZmZmZmZjgxMjU3N2M0Pl0gc2xvYl9hbGxvYy5pc3JhLjcr
MHhmNC8weDM4MApbICAgIDMuMDA1NDI4XSAgWzxmZmZmZmZmZjgxMjU4NjNlPl0gc2xvYl9h
bGxvY19ub2RlKzB4MWVlLzB4MmQwClsgICAgMy4wMDU0MjhdICBbPGZmZmZmZmZmODEyNTg3
MzM+XSBrbWVtX2NhY2hlX2FsbG9jKzB4MTMvMHgyMApbICAgIDMuMDA1NDI4XSAgWzxmZmZm
ZmZmZjgxMGVhNzhiPl0gYWxsb2NfcGlkKzB4MmIvMHg3MTAKWyAgICAzLjAwNTQyOF0gIFs8
ZmZmZmZmZmY4MTBlY2Y5MD5dID8gX19rdGhyZWFkX3BhcmttZSsweDkwLzB4OTAKWyAgICAz
LjAwNTQyOF0gIFs8ZmZmZmZmZmY4MTBiZjBhZT5dIGNvcHlfcHJvY2VzcysweDE3MGUvMHgy
YjgwClsgICAgMy4wMDU0MjhdICBbPGZmZmZmZmZmODIwYWMxZGM+XSA/IF9yYXdfc3Bpbl91
bmxvY2tfaXJxKzB4NmMvMHg5MApbICAgIDMuMDA1NDI4XSAgWzxmZmZmZmZmZjgxMGZjOGRk
Pl0gPyBnZXRfcGFyZW50X2lwKzB4ZC8weDgwClsgICAgMy4wMDU0MjhdICBbPGZmZmZmZmZm
ODEwZWNmOTA+XSA/IF9fa3RocmVhZF9wYXJrbWUrMHg5MC8weDkwClsgICAgMy4wMDU0Mjhd
ICBbPGZmZmZmZmZmODEwZWNmOTA+XSA/IF9fa3RocmVhZF9wYXJrbWUrMHg5MC8weDkwClsg
ICAgMy4wMDU0MjhdICBbPGZmZmZmZmZmODEwYzA3NjE+XSBkb19mb3JrKzB4MTMxLzB4Nzcw
ClsgICAgMy4wMDU0MjhdICBbPGZmZmZmZmZmODEwZWRkM2Y+XSA/IGt0aHJlYWRkKzB4MWJm
LzB4MjgwClsgICAgMy4wMDU0MjhdICBbPGZmZmZmZmZmODEwZmM4ZGQ+XSA/IGdldF9wYXJl
bnRfaXArMHhkLzB4ODAKWyAgICAzLjAwNTQyOF0gIFs8ZmZmZmZmZmY4MTBjMGRjNj5dIGtl
cm5lbF90aHJlYWQrMHgyNi8weDMwClsgICAgMy4wMDU0MjhdICBbPGZmZmZmZmZmODEwZWRk
NTM+XSBrdGhyZWFkZCsweDFkMy8weDI4MApbICAgIDMuMDA1NDI4XSAgWzxmZmZmZmZmZjgy
MGFkMzdjPl0gPyByZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApbICAgIDMuMDA1NDI4XSAgWzxm
ZmZmZmZmZjgxMGVkYjgwPl0gPyBrdGhyZWFkX3N0b3ArMHgyNzAvMHgyNzAKWyAgICAzLjAw
NTQyOF0gIFs8ZmZmZmZmZmY4MjBhZDM3Yz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsg
ICAgMy4wMDU0MjhdICBbPGZmZmZmZmZmODEwZWRiODA+XSA/IGt0aHJlYWRfc3RvcCsweDI3
MC8weDI3MApbICAgIDMuMDA1NDI4XSBDb2RlOiA0YyA4OSBkYiA4MyBlMyAwMSA0OCA4MyBj
MyAwMiA0OCA4MyAwNCBkZCBlMCBlMSBmMyA4MiAwMSA0NSA4NCBkYiA3NCA3OSA2NiA4OSA3
NyAwMiBlOSAwMiBmZiBmZiBmZiA2NiAyZSAwZiAxZiA4NCAwMCAwMCAwMCAwMCAwMCA8NjY+
IDQ0IDg5IDBiIDY2IDg5IDQzIDAyIGU5IDE5IGZlIGZmIGZmIDBmIDFmIDAwIDQ4IDhiIDQ1
IGIwIDRjIApbICAgIDMuMDA1NDI4XSBSSVAgIFs8ZmZmZmZmZmY4MTI1NmRiMD5dIHNsb2Jf
cGFnZV9hbGxvYysweDRmMC8weDU4MApbICAgIDMuMDA1NDI4XSAgUlNQIDxmZmZmODgwMDAw
MDZmYmU4PgpbICAgIDMuMDA1NDI4XSBDUjI6IGZmZmY4ODAwMTBkNjMwMDAKWyAgICAzLjAw
NTQyOF0gLS0tWyBlbmQgdHJhY2UgOTUxNzE5M2U2NGI3ZjljYyBdLS0tClsgICAgMy4wMDU0
MjhdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRpb24KL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1pdjAtMDcxNTExNTIvYTIwNDE2YzQwNzEwMTBiZTUyNWY3
NGM3MGM3YTc5YzVlZTZhMmEwNS9kbWVzZy1xdWFudGFsLWtidWlsZC0xMDoyMDE0MDcxNTEy
MDIxODp4ODZfNjQtcmFuZGNvbmZpZy1pdjAtMDcxNTExNTI6My4xNi4wLXJjNS1uZXh0LTIw
MTQwNzE0OjEyNgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MC0wNzE1MTE1Mi9hMjA0
MTZjNDA3MTAxMGJlNTI1Zjc0YzcwYzdhNzljNWVlNmEyYTA1L2RtZXNnLXlvY3RvLWtidWls
ZC0xOjIwMTQwNzE1MTE1NDM3Ong4Nl82NC1yYW5kY29uZmlnLWl2MC0wNzE1MTE1MjozLjE2
LjAtcmM1LW5leHQtMjAxNDA3MTQ6MTI2CjY6Mjo1IGFsbF9nb29kOmJhZDphbGxfYmFkIGJv
b3RzCgo=

--b2ktwntdbf0dPnbx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.16.0-rc4-00340-g0a5f047"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.16.0-rc4 Kernel Configuration
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
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
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
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_KERNEL_LZ4=y
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_FHANDLE is not set
CONFIG_USELIB=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
CONFIG_GENERIC_PENDING_IRQ=y
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
# CONFIG_NO_HZ_FULL is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
CONFIG_TREE_RCU_TRACE=y
# CONFIG_RCU_BOOST is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
# CONFIG_CGROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
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
# CONFIG_RD_LZ4 is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_SGETMASK_SYSCALL is not set
# CONFIG_SYSFS_SYSCALL is not set
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
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
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
# CONFIG_GCOV_FORMAT_3_4 is not set
CONFIG_GCOV_FORMAT_4_7=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_THROTTLING=y
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
# CONFIG_MSDOS_PARTITION is not set
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_CMDLINE_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
CONFIG_QUEUE_RWLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
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
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
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
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
CONFIG_CMA_AREAS=7
# CONFIG_MEM_SOFT_DIRTY is not set
CONFIG_ZSWAP=y
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
# CONFIG_X86_PAT is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_TEST_SUSPEND=y
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_EXTLOG is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
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
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
# CONFIG_IA32_EMULATION is not set
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_IOSF_MBI=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
# CONFIG_IP_MULTIPLE_TABLES is not set
# CONFIG_IP_ROUTE_MULTIPATH is not set
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
# CONFIG_IP_MROUTE is not set
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=y
CONFIG_INET_AH=y
# CONFIG_INET_ESP is not set
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=y
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=y
CONFIG_TCP_CONG_SCALABLE=y
# CONFIG_TCP_CONG_LP is not set
CONFIG_TCP_CONG_VENO=y
CONFIG_TCP_CONG_YEAH=y
# CONFIG_TCP_CONG_ILLINOIS is not set
# CONFIG_DEFAULT_BIC is not set
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_HYBLA is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_VENO is not set
CONFIG_DEFAULT_WESTWOOD=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="westwood"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
# CONFIG_IPV6_ROUTE_INFO is not set
CONFIG_IPV6_OPTIMISTIC_DAD=y
# CONFIG_INET6_AH is not set
CONFIG_INET6_ESP=y
CONFIG_INET6_IPCOMP=y
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_BEET=y
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
CONFIG_IPV6_SIT=y
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_GRE is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
CONFIG_NETFILTER_ADVANCED=y
# CONFIG_BRIDGE_NETFILTER is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_ACCT=y
CONFIG_NETFILTER_NETLINK_QUEUE=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CONNTRACK_TIMEOUT=y
# CONFIG_NF_CONNTRACK_TIMESTAMP is not set
# CONFIG_NF_CT_PROTO_DCCP is not set
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
# CONFIG_NF_CT_PROTO_UDPLITE is not set
CONFIG_NF_CONNTRACK_AMANDA=y
CONFIG_NF_CONNTRACK_FTP=y
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
CONFIG_NF_CONNTRACK_BROADCAST=y
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
CONFIG_NF_CONNTRACK_SNMP=y
CONFIG_NF_CONNTRACK_PPTP=y
CONFIG_NF_CONNTRACK_SANE=y
# CONFIG_NF_CONNTRACK_SIP is not set
CONFIG_NF_CONNTRACK_TFTP=y
# CONFIG_NF_CT_NETLINK is not set
CONFIG_NF_CT_NETLINK_TIMEOUT=y
# CONFIG_NETFILTER_NETLINK_QUEUE_CT is not set
CONFIG_NETFILTER_SYNPROXY=y
CONFIG_NF_TABLES=y
CONFIG_NF_TABLES_INET=y
CONFIG_NFT_EXTHDR=y
# CONFIG_NFT_META is not set
# CONFIG_NFT_CT is not set
CONFIG_NFT_RBTREE=y
CONFIG_NFT_HASH=y
CONFIG_NFT_COUNTER=y
# CONFIG_NFT_LOG is not set
CONFIG_NFT_LIMIT=y
# CONFIG_NFT_QUEUE is not set
CONFIG_NFT_REJECT=y
CONFIG_NFT_REJECT_INET=y
CONFIG_NFT_COMPAT=y
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=y
CONFIG_NETFILTER_XT_CONNMARK=y
CONFIG_NETFILTER_XT_SET=y

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
# CONFIG_NETFILTER_XT_TARGET_CONNMARK is not set
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=y
CONFIG_NETFILTER_XT_TARGET_CT=y
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
CONFIG_NETFILTER_XT_TARGET_HL=y
# CONFIG_NETFILTER_XT_TARGET_HMARK is not set
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=y
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_LOG=y
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=y
CONFIG_NETFILTER_XT_TARGET_NOTRACK=y
CONFIG_NETFILTER_XT_TARGET_RATEEST=y
CONFIG_NETFILTER_XT_TARGET_TEE=y
CONFIG_NETFILTER_XT_TARGET_TPROXY=y
CONFIG_NETFILTER_XT_TARGET_TRACE=y
CONFIG_NETFILTER_XT_TARGET_SECMARK=y
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=y

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=y
CONFIG_NETFILTER_XT_MATCH_BPF=y
# CONFIG_NETFILTER_XT_MATCH_CGROUP is not set
CONFIG_NETFILTER_XT_MATCH_CLUSTER=y
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=y
# CONFIG_NETFILTER_XT_MATCH_CONNLABEL is not set
# CONFIG_NETFILTER_XT_MATCH_CONNLIMIT is not set
CONFIG_NETFILTER_XT_MATCH_CONNMARK=y
# CONFIG_NETFILTER_XT_MATCH_CONNTRACK is not set
# CONFIG_NETFILTER_XT_MATCH_CPU is not set
CONFIG_NETFILTER_XT_MATCH_DCCP=y
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=y
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
CONFIG_NETFILTER_XT_MATCH_ECN=y
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=y
CONFIG_NETFILTER_XT_MATCH_HELPER=y
CONFIG_NETFILTER_XT_MATCH_HL=y
CONFIG_NETFILTER_XT_MATCH_IPCOMP=y
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
CONFIG_NETFILTER_XT_MATCH_L2TP=y
CONFIG_NETFILTER_XT_MATCH_LENGTH=y
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
CONFIG_NETFILTER_XT_MATCH_MAC=y
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
# CONFIG_NETFILTER_XT_MATCH_OSF is not set
CONFIG_NETFILTER_XT_MATCH_OWNER=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
CONFIG_NETFILTER_XT_MATCH_QUOTA=y
CONFIG_NETFILTER_XT_MATCH_RATEEST=y
CONFIG_NETFILTER_XT_MATCH_REALM=y
CONFIG_NETFILTER_XT_MATCH_RECENT=y
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
# CONFIG_NETFILTER_XT_MATCH_SOCKET is not set
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_NETFILTER_XT_MATCH_STATISTIC=y
CONFIG_NETFILTER_XT_MATCH_STRING=y
CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_TIME=y
CONFIG_NETFILTER_XT_MATCH_U32=y
CONFIG_IP_SET=y
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=y
CONFIG_IP_SET_BITMAP_IPMAC=y
CONFIG_IP_SET_BITMAP_PORT=y
CONFIG_IP_SET_HASH_IP=y
CONFIG_IP_SET_HASH_IPMARK=y
# CONFIG_IP_SET_HASH_IPPORT is not set
CONFIG_IP_SET_HASH_IPPORTIP=y
# CONFIG_IP_SET_HASH_IPPORTNET is not set
CONFIG_IP_SET_HASH_NETPORTNET=y
# CONFIG_IP_SET_HASH_NET is not set
# CONFIG_IP_SET_HASH_NETNET is not set
CONFIG_IP_SET_HASH_NETPORT=y
# CONFIG_IP_SET_HASH_NETIFACE is not set
CONFIG_IP_SET_LIST_SET=y
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_NF_TABLES_IPV4=y
CONFIG_NFT_CHAIN_ROUTE_IPV4=y
CONFIG_NFT_REJECT_IPV4=y
CONFIG_NF_TABLES_ARP=y
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_AH=y
CONFIG_IP_NF_MATCH_ECN=y
CONFIG_IP_NF_MATCH_RPFILTER=y
# CONFIG_IP_NF_MATCH_TTL is not set
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_SYNPROXY=y
CONFIG_IP_NF_TARGET_ULOG=y
# CONFIG_NF_NAT_IPV4 is not set
CONFIG_IP_NF_MANGLE=y
# CONFIG_IP_NF_TARGET_CLUSTERIP is not set
CONFIG_IP_NF_TARGET_ECN=y
CONFIG_IP_NF_TARGET_TTL=y
# CONFIG_IP_NF_RAW is not set
CONFIG_IP_NF_SECURITY=y
CONFIG_IP_NF_ARPTABLES=y
CONFIG_IP_NF_ARPFILTER=y
CONFIG_IP_NF_ARP_MANGLE=y

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=y
CONFIG_NF_CONNTRACK_IPV6=y
CONFIG_NF_TABLES_IPV6=y
CONFIG_NFT_CHAIN_ROUTE_IPV6=y
CONFIG_NFT_REJECT_IPV6=y
CONFIG_IP6_NF_IPTABLES=y
# CONFIG_IP6_NF_MATCH_AH is not set
CONFIG_IP6_NF_MATCH_EUI64=y
# CONFIG_IP6_NF_MATCH_FRAG is not set
# CONFIG_IP6_NF_MATCH_OPTS is not set
CONFIG_IP6_NF_MATCH_HL=y
CONFIG_IP6_NF_MATCH_IPV6HEADER=y
CONFIG_IP6_NF_MATCH_MH=y
CONFIG_IP6_NF_MATCH_RPFILTER=y
# CONFIG_IP6_NF_MATCH_RT is not set
CONFIG_IP6_NF_TARGET_HL=y
CONFIG_IP6_NF_FILTER=y
# CONFIG_IP6_NF_TARGET_REJECT is not set
# CONFIG_IP6_NF_TARGET_SYNPROXY is not set
CONFIG_IP6_NF_MANGLE=y
CONFIG_IP6_NF_RAW=y
# CONFIG_IP6_NF_SECURITY is not set
# CONFIG_NF_NAT_IPV6 is not set

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=y
CONFIG_NF_TABLES_BRIDGE=y
CONFIG_BRIDGE_NF_EBTABLES=y
CONFIG_BRIDGE_EBT_BROUTE=y
CONFIG_BRIDGE_EBT_T_FILTER=y
CONFIG_BRIDGE_EBT_T_NAT=y
CONFIG_BRIDGE_EBT_802_3=y
# CONFIG_BRIDGE_EBT_AMONG is not set
CONFIG_BRIDGE_EBT_ARP=y
# CONFIG_BRIDGE_EBT_IP is not set
# CONFIG_BRIDGE_EBT_IP6 is not set
# CONFIG_BRIDGE_EBT_LIMIT is not set
CONFIG_BRIDGE_EBT_MARK=y
# CONFIG_BRIDGE_EBT_PKTTYPE is not set
# CONFIG_BRIDGE_EBT_STP is not set
CONFIG_BRIDGE_EBT_VLAN=y
CONFIG_BRIDGE_EBT_ARPREPLY=y
CONFIG_BRIDGE_EBT_DNAT=y
CONFIG_BRIDGE_EBT_MARK_T=y
CONFIG_BRIDGE_EBT_REDIRECT=y
CONFIG_BRIDGE_EBT_SNAT=y
CONFIG_BRIDGE_EBT_LOG=y
CONFIG_BRIDGE_EBT_ULOG=y
CONFIG_BRIDGE_EBT_NFLOG=y
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=y

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
CONFIG_IP_DCCP_CCID3_DEBUG=y
CONFIG_IP_DCCP_TFRC_LIB=y
CONFIG_IP_DCCP_TFRC_DEBUG=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
# CONFIG_SCTP_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
# CONFIG_RDS is not set
CONFIG_TIPC=y
CONFIG_TIPC_PORTS=8191
# CONFIG_ATM is not set
CONFIG_L2TP=y
# CONFIG_L2TP_DEBUGFS is not set
# CONFIG_L2TP_V3 is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_IPDDP=y
CONFIG_IPDDP_ENCAP=y
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
CONFIG_PHONET=y
CONFIG_IEEE802154=y
CONFIG_IEEE802154_6LOWPAN=y
CONFIG_6LOWPAN_IPHC=y
CONFIG_MAC802154=y
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_BLA is not set
# CONFIG_BATMAN_ADV_DAT is not set
CONFIG_BATMAN_ADV_NC=y
CONFIG_BATMAN_ADV_MCAST=y
# CONFIG_BATMAN_ADV_DEBUG is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=y
# CONFIG_NET_MPLS_GSO is not set
CONFIG_HSR=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
CONFIG_NET_DROP_MONITOR=y
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
# CONFIG_BPQETHER is not set
CONFIG_BAYCOM_SER_FDX=y
CONFIG_BAYCOM_SER_HDX=y
CONFIG_YAM=y
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
CONFIG_CAN_BCM=y
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
# CONFIG_CAN_SLCAN is not set
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
CONFIG_RFKILL_REGULATOR=y
# CONFIG_RFKILL_GPIO is not set
# CONFIG_NET_9P is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=y
CONFIG_CAIF_USB=y
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
# CONFIG_UEVENT_HELPER is not set
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set
# CONFIG_DMA_CMA is not set

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
CONFIG_FTL=y
CONFIG_NFTL=y
# CONFIG_NFTL_RW is not set
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
CONFIG_SSFDC=y
CONFIG_SM_FTL=y
# CONFIG_MTD_OOPS is not set
CONFIG_MTD_SWAP=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
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
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
# CONFIG_MTD_AMD76XROM is not set
CONFIG_MTD_ICHXROM=y
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=y
CONFIG_MTD_DATAFLASH_WRITE_VERIFY=y
# CONFIG_MTD_DATAFLASH_OTP is not set
# CONFIG_MTD_SST25L is not set
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
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=y
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=y
# CONFIG_MTD_NAND_DENALI_PCI is not set
CONFIG_MTD_NAND_GPIO=y
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH=y
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
# CONFIG_MTD_NAND_DOCG4 is not set
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_NANDSIM=y
# CONFIG_MTD_NAND_PLATFORM is not set
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
CONFIG_MTD_ONENAND_GENERIC=y
CONFIG_MTD_ONENAND_OTP=y
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
# CONFIG_MTD_SPI_NOR is not set
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=y
CONFIG_MTD_UBI_BLOCK=y
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_ZRAM is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SKD is not set
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
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_BMP085_SPI=y
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#
# CONFIG_INTEL_MIC_HOST is not set

#
# Intel MIC Card Driver
#
# CONFIG_INTEL_MIC_CARD is not set
# CONFIG_GENWQE is not set
CONFIG_ECHO=y
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
# CONFIG_IDE_GD_ATA is not set
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECS=y
# CONFIG_BLK_DEV_DELKIN is not set
# CONFIG_BLK_DEV_IDECD is not set
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
CONFIG_BLK_DEV_PLATFORM=y
CONFIG_BLK_DEV_CMD640=y
CONFIG_BLK_DEV_CMD640_ENHANCED=y
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
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=y
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_ISCSI_BOOT_SYSFS=y
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
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
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPT3SAS is not set
CONFIG_SCSI_UFSHCD=y
# CONFIG_SCSI_UFSHCD_PCI is not set
CONFIG_SCSI_UFSHCD_PLATFORM=y
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
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
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_VIRTIO is not set
# CONFIG_SCSI_CHELSIO_FCOE is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
# CONFIG_SCSI_DH_HP_SW is not set
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
# CONFIG_MD_MULTIPATH is not set
CONFIG_MD_FAULTY=y
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=y
CONFIG_DM_BIO_PRISON=y
CONFIG_DM_PERSISTENT_DATA=y
# CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
CONFIG_DM_CRYPT=y
# CONFIG_DM_SNAPSHOT is not set
CONFIG_DM_THIN_PROVISIONING=y
CONFIG_DM_CACHE=y
CONFIG_DM_CACHE_MQ=y
CONFIG_DM_CACHE_CLEANER=y
CONFIG_DM_ERA=y
# CONFIG_DM_MIRROR is not set
CONFIG_DM_RAID=y
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
CONFIG_DM_MULTIPATH_QL=y
CONFIG_DM_MULTIPATH_ST=y
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_DM_FLAKEY is not set
CONFIG_DM_VERITY=y
CONFIG_DM_SWITCH=y
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=y
# CONFIG_TCM_FILEIO is not set
CONFIG_TCM_PSCSI=y
# CONFIG_LOOPBACK_TARGET is not set
# CONFIG_TCM_FC is not set
# CONFIG_ISCSI_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
# CONFIG_NET_CORE is not set
# CONFIG_ARCNET is not set

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
CONFIG_NET_DSA_MV88E6060=y
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_ETHERNET=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
# CONFIG_PCMCIA_NMCLAN is not set
# CONFIG_NET_VENDOR_ARC is not set
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
# CONFIG_NET_VENDOR_BROADCOM is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_CALXEDA_XGMAC=y
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
# CONFIG_CX_ECAT is not set
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
# CONFIG_NET_VENDOR_INTEL is not set
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
# CONFIG_NET_VENDOR_MARVELL is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_MLX5_CORE is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MICROCHIP is not set
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_ETHOC=y
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R8169 is not set
# CONFIG_SH_ETH is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
# CONFIG_NET_VENDOR_SAMSUNG is not set
# CONFIG_NET_VENDOR_SEEQ is not set
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_PCMCIA_SMC91C92 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TLAN is not set
# CONFIG_NET_VENDOR_VIA is not set
CONFIG_NET_VENDOR_WIZNET=y
CONFIG_WIZNET_W5100=y
CONFIG_WIZNET_W5300=y
# CONFIG_WIZNET_BUS_DIRECT is not set
CONFIG_WIZNET_BUS_INDIRECT=y
# CONFIG_WIZNET_BUS_ANY is not set
# CONFIG_NET_VENDOR_XIRCOM is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=y
# CONFIG_DAVICOM_PHY is not set
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
CONFIG_BCM7XXX_PHY=y
CONFIG_BCM87XX_PHY=y
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=y
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
# CONFIG_MDIO_GPIO is not set
CONFIG_MICREL_KS8995MA=y
# CONFIG_PPP is not set
# CONFIG_SLIP is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_RTL8152=y
CONFIG_USB_USBNET=y
# CONFIG_USB_NET_AX8817X is not set
CONFIG_USB_NET_AX88179_178A=y
CONFIG_USB_NET_CDCETHER=y
# CONFIG_USB_NET_CDC_EEM is not set
CONFIG_USB_NET_CDC_NCM=y
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
CONFIG_USB_NET_CDC_MBIM=y
CONFIG_USB_NET_DM9601=y
CONFIG_USB_NET_SR9700=y
# CONFIG_USB_NET_SR9800 is not set
CONFIG_USB_NET_SMSC75XX=y
# CONFIG_USB_NET_SMSC95XX is not set
# CONFIG_USB_NET_GL620A is not set
CONFIG_USB_NET_NET1080=y
# CONFIG_USB_NET_PLUSB is not set
CONFIG_USB_NET_MCS7830=y
# CONFIG_USB_NET_RNDIS_HOST is not set
CONFIG_USB_NET_CDC_SUBSET=y
# CONFIG_USB_ALI_M5632 is not set
# CONFIG_USB_AN2720 is not set
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
# CONFIG_USB_KC2190 is not set
CONFIG_USB_NET_ZAURUS=y
CONFIG_USB_NET_CX82310_ETH=y
CONFIG_USB_NET_KALMIA=y
# CONFIG_USB_NET_QMI_WWAN is not set
# CONFIG_USB_HSO is not set
# CONFIG_USB_NET_INT51X1 is not set
CONFIG_USB_CDC_PHONET=y
CONFIG_USB_IPHETH=y
# CONFIG_USB_SIERRA_NET is not set
# CONFIG_USB_VL600 is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=y
# CONFIG_IEEE802154_FAKEHARD is not set
CONFIG_IEEE802154_FAKELB=y
CONFIG_IEEE802154_AT86RF230=y
CONFIG_IEEE802154_MRF24J40=y
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5520 is not set
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
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

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
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
# CONFIG_TCG_TIS_I2C_ATMEL is not set
CONFIG_TCG_TIS_I2C_INFINEON=y
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_ST33_I2C is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=y

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
# CONFIG_I2C_CBUS_GPIO is not set
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_GPIO=y
CONFIG_I2C_KEMPLD=y
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=y
# CONFIG_I2C_VIPERBOARD is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_CROS_EC_TUNNEL=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=y
CONFIG_SPI_GPIO=y
CONFIG_SPI_OC_TINY=y
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_XCOMM is not set
CONFIG_SPI_XILINX=y
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPMI is not set
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
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_DP83640_PHY=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
# CONFIG_GPIO_DA9052 is not set

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_LP3943=y
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_TC3589X is not set
# CONFIG_GPIO_TPS65912 is not set
# CONFIG_GPIO_TWL6040 is not set
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_WM8350=y
CONFIG_GPIO_WM8994=y
# CONFIG_GPIO_ADP5520 is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
CONFIG_GPIO_MC33880=y

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
# CONFIG_GPIO_KEMPLD is not set

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_TPS6586X is not set
# CONFIG_GPIO_TPS65910 is not set

#
# USB GPIO expanders:
#
# CONFIG_GPIO_VIPERBOARD is not set
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
# CONFIG_W1_SLAVE_DS2781 is not set
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
# CONFIG_WM8350_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_88PM860X is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_PCF50633 is not set
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_LP8788 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_CHARGER_MAX14577 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24190 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_CHARGER_TPS65090 is not set
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
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_MC13783_ADC=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=y
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=y
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4260=y
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=y
# CONFIG_SENSORS_HTU21 is not set
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM70=y
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_NCT6683=y
# CONFIG_SENSORS_NCT6775 is not set
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
# CONFIG_SENSORS_PMBUS is not set
CONFIG_SENSORS_ADM1275=y
# CONFIG_SENSORS_LM25066 is not set
CONFIG_SENSORS_LTC2978=y
# CONFIG_SENSORS_MAX16064 is not set
CONFIG_SENSORS_MAX34440=y
# CONFIG_SENSORS_MAX8688 is not set
CONFIG_SENSORS_UCD9000=y
# CONFIG_SENSORS_UCD9200 is not set
# CONFIG_SENSORS_ZL6100 is not set
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SHTC1=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_ADC128D818=y
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=y
# CONFIG_SENSORS_WM8350 is not set

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
CONFIG_X86_PKG_TEMP_THERMAL=y
# CONFIG_ACPI_INT3403_THERMAL is not set
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_DA9052_WATCHDOG=y
CONFIG_WM831X_WATCHDOG=y
# CONFIG_WM8350_WATCHDOG is not set
CONFIG_XILINX_WATCHDOG=y
CONFIG_DW_WATCHDOG=y
CONFIG_RETU_WATCHDOG=y
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
# CONFIG_KEMPLD_WDT is not set
CONFIG_SC1200_WDT=y
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
CONFIG_CPU5_WDT=y
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
CONFIG_SBC_EPX_C3_WATCHDOG=y
CONFIG_MEN_A21_WDT=y

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
# CONFIG_SSB_DRIVER_GPIO is not set
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
CONFIG_MFD_AS3711=y
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_BCM590XX=y
# CONFIG_MFD_AXP20X is not set
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_EZX_PCAP=y
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RTSX_USB is not set
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_SEC_CORE=y
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=y
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS65218=y
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS65912_SPI=y
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_88PM8607 is not set
CONFIG_REGULATOR_ACT8865=y
# CONFIG_REGULATOR_AD5398 is not set
# CONFIG_REGULATOR_ANATOP is not set
CONFIG_REGULATOR_ARIZONA=y
CONFIG_REGULATOR_AS3711=y
# CONFIG_REGULATOR_BCM590XX is not set
# CONFIG_REGULATOR_DA9052 is not set
CONFIG_REGULATOR_DA9063=y
# CONFIG_REGULATOR_DA9210 is not set
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP8755=y
# CONFIG_REGULATOR_LP8788 is not set
# CONFIG_REGULATOR_LTC3589 is not set
CONFIG_REGULATOR_MAX14577=y
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=y
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8973=y
# CONFIG_REGULATOR_MAX77686 is not set
# CONFIG_REGULATOR_MAX77693 is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_PCAP=y
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_S2MPA01=y
# CONFIG_REGULATOR_S2MPS11 is not set
CONFIG_REGULATOR_S5M8767=y
CONFIG_REGULATOR_TPS51632=y
# CONFIG_REGULATOR_TPS6105X is not set
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65090=y
CONFIG_REGULATOR_TPS65217=y
# CONFIG_REGULATOR_TPS6524X is not set
# CONFIG_REGULATOR_TPS6586X is not set
# CONFIG_REGULATOR_TPS65910 is not set
CONFIG_REGULATOR_TPS65912=y
# CONFIG_REGULATOR_TPS80031 is not set
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8350=y
# CONFIG_REGULATOR_WM8994 is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
CONFIG_V4L_PLATFORM_DRIVERS=y
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_SOC_CAMERA is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_CYPRESS_FIRMWARE is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

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
# Audio/Video compression chips
#

#
# Miscellaneous helper chips
#

#
# Sensors used on soc_camera driver
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

#
# Direct Rendering Manager
#
# CONFIG_DRM is not set

#
# Frame buffer Devices
#
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
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
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
CONFIG_FB_VESA=y
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=y
# CONFIG_FB_OPENCORES is not set
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
# CONFIG_FB_SM501 is not set
CONFIG_FB_SMSCUFX=y
# CONFIG_FB_UDL is not set
CONFIG_FB_VIRTUAL=y
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
CONFIG_FB_SIMPLE=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
CONFIG_LCD_ILI922X=y
CONFIG_LCD_ILI9320=y
# CONFIG_LCD_TDO24M is not set
CONFIG_LCD_VGG2432A4=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_LCD_S6E63M0=y
CONFIG_LCD_LD9040=y
# CONFIG_LCD_AMS369FG06 is not set
CONFIG_LCD_LMS501KF03=y
CONFIG_LCD_HX8357=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_LM3533 is not set
CONFIG_BACKLIGHT_PWM=y
# CONFIG_BACKLIGHT_DA9052 is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_WM831X=y
# CONFIG_BACKLIGHT_ADP5520 is not set
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
# CONFIG_BACKLIGHT_88PM860X is not set
# CONFIG_BACKLIGHT_PCF50633 is not set
CONFIG_BACKLIGHT_LM3630A=y
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_BACKLIGHT_LP8788=y
# CONFIG_BACKLIGHT_TPS65217 is not set
CONFIG_BACKLIGHT_AS3711=y
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
# CONFIG_VGASTATE is not set
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
# CONFIG_LOGO_LINUX_VGA16 is not set
# CONFIG_LOGO_LINUX_CLUT224 is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_DMAENGINE_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=y
CONFIG_SND_JACK=y
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
# CONFIG_SND_PCM_OSS_PLUGINS is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
CONFIG_SND_DEBUG=y
CONFIG_SND_DEBUG_VERBOSE=y
# CONFIG_SND_PCM_XRUN_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_VX_LIB=y
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set

#
# HD-Audio
#
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_SPI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=y
# CONFIG_SND_USB_UA101 is not set
# CONFIG_SND_USB_USX2Y is not set
CONFIG_SND_USB_CAIAQ=y
# CONFIG_SND_USB_CAIAQ_INPUT is not set
# CONFIG_SND_USB_US122L is not set
# CONFIG_SND_USB_6FIRE is not set
CONFIG_SND_USB_HIFACE=y
# CONFIG_SND_BCD2000 is not set
CONFIG_SND_PCMCIA=y
CONFIG_SND_VXPOCKET=y
CONFIG_SND_PDAUDIOCF=y
CONFIG_SND_SOC=y
CONFIG_SND_SOC_GENERIC_DMAENGINE_PCM=y
CONFIG_SND_ATMEL_SOC=y

#
# SoC Audio for Freescale CPUs
#

#
# Common SoC Audio options for Freescale CPUs:
#
CONFIG_SND_SOC_FSL_SAI=y
CONFIG_SND_SOC_FSL_SSI=y
# CONFIG_SND_SOC_FSL_SPDIF is not set
# CONFIG_SND_SOC_FSL_ESAI is not set
# CONFIG_SND_SOC_IMX_AUDMUX is not set
CONFIG_SND_SOC_INTEL_SST=y
CONFIG_SND_SOC_INTEL_SST_ACPI=y
CONFIG_SND_SOC_I2C_AND_SPI=y

#
# CODEC drivers
#
CONFIG_SND_SOC_ADAU1701=y
CONFIG_SND_SOC_AK4104=y
CONFIG_SND_SOC_AK4554=y
CONFIG_SND_SOC_AK4642=y
CONFIG_SND_SOC_AK5386=y
CONFIG_SND_SOC_ALC5623=y
# CONFIG_SND_SOC_CS42L52 is not set
# CONFIG_SND_SOC_CS42L56 is not set
CONFIG_SND_SOC_CS42L73=y
CONFIG_SND_SOC_CS4270=y
CONFIG_SND_SOC_CS4271=y
CONFIG_SND_SOC_CS42XX8=y
CONFIG_SND_SOC_CS42XX8_I2C=y
CONFIG_SND_SOC_HDMI_CODEC=y
CONFIG_SND_SOC_PCM1681=y
CONFIG_SND_SOC_PCM1792A=y
CONFIG_SND_SOC_PCM512x=y
CONFIG_SND_SOC_PCM512x_I2C=y
CONFIG_SND_SOC_PCM512x_SPI=y
CONFIG_SND_SOC_SGTL5000=y
CONFIG_SND_SOC_SIGMADSP=y
CONFIG_SND_SOC_SIGMADSP_I2C=y
CONFIG_SND_SOC_SIRF_AUDIO_CODEC=y
CONFIG_SND_SOC_SPDIF=y
CONFIG_SND_SOC_STA350=y
CONFIG_SND_SOC_TAS5086=y
CONFIG_SND_SOC_TLV320AIC3X=y
CONFIG_SND_SOC_WM8510=y
CONFIG_SND_SOC_WM8523=y
CONFIG_SND_SOC_WM8580=y
CONFIG_SND_SOC_WM8711=y
CONFIG_SND_SOC_WM8728=y
CONFIG_SND_SOC_WM8731=y
CONFIG_SND_SOC_WM8737=y
CONFIG_SND_SOC_WM8741=y
CONFIG_SND_SOC_WM8750=y
CONFIG_SND_SOC_WM8753=y
CONFIG_SND_SOC_WM8770=y
CONFIG_SND_SOC_WM8776=y
CONFIG_SND_SOC_WM8804=y
CONFIG_SND_SOC_WM8903=y
# CONFIG_SND_SOC_WM8962 is not set
CONFIG_SND_SOC_TPA6130A2=y
CONFIG_SND_SIMPLE_CARD=y
CONFIG_SOUND_PRIME=y
# CONFIG_SOUND_OSS is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_APPLEIR is not set
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_PRODIKEYS is not set
# CONFIG_HID_CP2112 is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_ELO is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_HUION is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_RMI is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_XINMO is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG=y
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_OTG_FSM=y
CONFIG_USB_MON=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=y
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_ISP1362_HCD=y
# CONFIG_USB_FUSBH200_HCD is not set
CONFIG_USB_FOTG210_HCD=y
CONFIG_USB_MAX3421_HCD=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_U132_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_SSB is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=y
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_USBAT=y
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
CONFIG_USB_STORAGE_ENE_UB6250=y
CONFIG_USB_UAS=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
# CONFIG_USB_MICROTEK is not set
CONFIG_USB_MUSB_HDRC=y
CONFIG_USB_MUSB_HOST=y
CONFIG_USB_MUSB_TUSB6010=y
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_MUSB_PIO_ONLY=y
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
CONFIG_USB_LD=y
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
CONFIG_USB_EHSET_TEST_FIXTURE=y
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=y

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_USB_GPIO_VBUS=y
CONFIG_TAHVO_USB=y
# CONFIG_TAHVO_USB_HOST_BY_DEFAULT is not set
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
# CONFIG_MMC_BLOCK_BOUNCE is not set
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SPI is not set
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
CONFIG_MMC_USHC=y
# CONFIG_MMC_USDHI6ROL0 is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=y
CONFIG_MS_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_88PM860X is not set
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8501=y
# CONFIG_LEDS_LP8788 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA963X is not set
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_WM8350=y
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_DAC124S085=y
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_ADP5520 is not set
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_LM355x=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
# CONFIG_LEDS_TRIGGER_CAMERA is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_PROC is not set
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=y
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=y
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_LP8788 is not set
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8907=y
CONFIG_RTC_DRV_MAX77686=y
CONFIG_RTC_DRV_RS5C372=y
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_ISL12022=y
CONFIG_RTC_DRV_ISL12057=y
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF2127=y
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=y
CONFIG_RTC_DRV_TPS6586X=y
CONFIG_RTC_DRV_TPS65910=y
# CONFIG_RTC_DRV_TPS80031 is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
CONFIG_RTC_DRV_RX8581=y
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=y
CONFIG_RTC_DRV_RV3029C2=y
CONFIG_RTC_DRV_S5M=y

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
CONFIG_RTC_DRV_M41T94=y
# CONFIG_RTC_DRV_DS1305 is not set
CONFIG_RTC_DRV_DS1343=y
CONFIG_RTC_DRV_DS1347=y
CONFIG_RTC_DRV_DS1390=y
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RS5C348=y
CONFIG_RTC_DRV_DS3234=y
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_RX4581 is not set
# CONFIG_RTC_DRV_MCP795 is not set

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_DS2404=y
# CONFIG_RTC_DRV_DA9052 is not set
# CONFIG_RTC_DRV_DA9063 is not set
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=y
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_WM831X=y
CONFIG_RTC_DRV_WM8350=y
CONFIG_RTC_DRV_PCF50633=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_PCAP=y
# CONFIG_RTC_DRV_MC13XXX is not set
# CONFIG_RTC_DRV_XGENE is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_DELL_SMO8800 is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_AMILO_RFKILL is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
CONFIG_MAILBOX=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
# CONFIG_EXTCON_ADC_JACK is not set
# CONFIG_EXTCON_MAX14577 is not set
# CONFIG_EXTCON_MAX77693 is not set
# CONFIG_EXTCON_ARIZONA is not set
CONFIG_MEMORY=y
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_BUFFER_CB is not set
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
# CONFIG_BMA180 is not set
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y
CONFIG_IIO_ST_ACCEL_SPI_3AXIS=y
CONFIG_KXSD9=y
CONFIG_MMA8452=y

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
CONFIG_AD7266=y
CONFIG_AD7298=y
CONFIG_AD7476=y
CONFIG_AD7791=y
CONFIG_AD7793=y
CONFIG_AD7887=y
# CONFIG_AD7923 is not set
CONFIG_AD799X=y
CONFIG_LP8788_ADC=y
CONFIG_MAX1363=y
CONFIG_MCP320X=y
CONFIG_MCP3422=y
CONFIG_NAU7802=y
CONFIG_TI_ADC081C=y
CONFIG_TI_AM335X_ADC=y
CONFIG_VIPERBOARD_ADC=y

#
# Amplifiers
#
CONFIG_AD8366=y

#
# Hid Sensor IIO Common
#
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
CONFIG_AD5360=y
CONFIG_AD5380=y
CONFIG_AD5421=y
CONFIG_AD5446=y
# CONFIG_AD5449 is not set
CONFIG_AD5504=y
# CONFIG_AD5624R_SPI is not set
CONFIG_AD5686=y
CONFIG_AD5755=y
CONFIG_AD5764=y
CONFIG_AD5791=y
CONFIG_AD7303=y
CONFIG_MAX517=y
# CONFIG_MCP4725 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=y

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=y

#
# Digital gyroscope sensors
#
CONFIG_ADIS16080=y
CONFIG_ADIS16130=y
CONFIG_ADIS16136=y
CONFIG_ADIS16260=y
# CONFIG_ADXRS450 is not set
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_IIO_ST_GYRO_SPI_3AXIS=y
# CONFIG_ITG3200 is not set

#
# Humidity sensors
#
CONFIG_DHT11=y
# CONFIG_SI7005 is not set

#
# Inertial measurement units
#
CONFIG_ADIS16400=y
# CONFIG_ADIS16480 is not set
CONFIG_INV_MPU6050_IIO=y
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
# CONFIG_APDS9300 is not set
CONFIG_CM32181=y
CONFIG_CM36651=y
# CONFIG_GP2AP020A00F is not set
CONFIG_SENSORS_LM3533=y
CONFIG_LTR501=y
CONFIG_TCS3472=y
CONFIG_SENSORS_TSL2563=y
# CONFIG_TSL4531 is not set
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
CONFIG_AK8975=y
CONFIG_MAG3110=y
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
CONFIG_IIO_ST_MAGN_SPI_3AXIS=y

#
# Inclinometer sensors
#

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure sensors
#
# CONFIG_MPL115 is not set
# CONFIG_MPL3115 is not set
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y
CONFIG_IIO_ST_PRESS_SPI=y

#
# Lightning sensors
#
CONFIG_AS3935=y

#
# Temperature sensors
#
CONFIG_MLX90614=y
CONFIG_TMP006=y
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_LP3943=y
# CONFIG_PWM_LPSS is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_PHY_SAMSUNG_USB2=y
# CONFIG_POWERCAP is not set
# CONFIG_MCB is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
# CONFIG_DMIID is not set
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_GOOGLE_MEMCONSOLE=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=y
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set

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
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=y
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
CONFIG_HFSPLUS_FS_POSIX_ACL=y
# CONFIG_BEFS_FS is not set
CONFIG_BFS_FS=y
# CONFIG_EFS_FS is not set
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
# CONFIG_JFFS2_SUMMARY is not set
CONFIG_JFFS2_FS_XATTR=y
# CONFIG_JFFS2_FS_POSIX_ACL is not set
CONFIG_JFFS2_FS_SECURITY=y
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
# CONFIG_JFFS2_RTIME is not set
# CONFIG_JFFS2_RUBIN is not set
CONFIG_JFFS2_CMODE_NONE=y
# CONFIG_JFFS2_CMODE_PRIORITY is not set
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
CONFIG_UBIFS_FS=y
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
# CONFIG_OMFS_FS is not set
CONFIG_HPFS_FS=y
# CONFIG_QNX4FS_FS is not set
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
CONFIG_ROMFS_FS=y
# CONFIG_ROMFS_BACKED_BY_BLOCK is not set
# CONFIG_ROMFS_BACKED_BY_MTD is not set
CONFIG_ROMFS_BACKED_BY_BOTH=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_ROMFS_ON_MTD=y
# CONFIG_PSTORE is not set
CONFIG_SYSV_FS=y
# CONFIG_UFS_FS is not set
# CONFIG_F2FS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
CONFIG_DLM_DEBUG=y

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
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
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
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_PREEMPT=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
# CONFIG_PROVE_RCU_DELAY is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_VERBOSE=y
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
CONFIG_FAIL_IO_TIMEOUT=y
# CONFIG_FAIL_MMC_REQUEST is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
CONFIG_LATENCYTOP=y
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
CONFIG_TRACER_MAX_TRACE=y
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
CONFIG_IRQSOFF_TRACER=y
CONFIG_PREEMPT_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
# CONFIG_BRANCH_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_DYNAMIC_FTRACE is not set
CONFIG_FUNCTION_PROFILER=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_TRACEPOINT_BENCHMARK=y
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_ASYNC_RAID6_TEST=y
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
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
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
CONFIG_BIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_SECURITY_SMACK=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
# CONFIG_IMA is not set
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_SMACK=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="smack"
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
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
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
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
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
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
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
# CONFIG_X509_CERTIFICATE_PARSER is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
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
CONFIG_PERCPU_RWSEM=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
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
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
# CONFIG_CRC64_ECMA is not set
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y

--b2ktwntdbf0dPnbx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--b2ktwntdbf0dPnbx--
