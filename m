Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaBSMnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 07:43:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:54597 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbaBSMnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 07:43:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,505,1389772800"; 
   d="log'?scan'208";a="477627929"
Date: Wed, 19 Feb 2014 20:42:41 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [workqueue] WARNING: CPU: 0 PID: 1 at kernel/locking/lockdep.c:710
 __lock_acquire()
Message-ID: <20140219124241.GI7735@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qOrJKOH36bD5yhNe"
Content-Disposition: inline
In-Reply-To: <20140219124122.GH7735@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qOrJKOH36bD5yhNe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

commit 84604340d034a074036e86e85c4055a1c7ea5529
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue Feb 11 12:00:36 2014 +0100
Commit:     Tejun Heo <tj@kernel.org>
CommitDate: Tue Feb 11 10:25:17 2014 -0500

    workqueue: Fix workqueue lockdep name
    
    Tommi noticed a 'funny' lock class name: "%s#5" from a lock acquired
    in process_one_work(). It turns out that commit b196be89cdc14 forgot
    to change the lockdep_init_map() when it changed the @lock_name
    argument from a string to a format.
    
    Fixes: b196be89cdc14 ("workqueue: make alloc_workqueue() take printf
    fmt and args for name")
    
    Reported-by: Tommi Rantala <tt.rantala@gmail.com>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Signed-off-by: Tejun Heo <tj@kernel.org>
    Cc: stable@vger.kernel.org

[    7.150365] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[    7.151212] Detecting Adaptec I2O RAID controllers...
[    7.153240] ------------[ cut here ]------------
[    7.153979] WARNING: CPU: 0 PID: 1 at kernel/locking/lockdep.c:710 __lock_acquire+0x1d5/0x8c6()
[    7.154489] CPU: 0 PID: 1 Comm: swapper Not tainted 3.14.0-rc2-next-20140212-02309-g4602175 #3
[    7.154489] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    7.154489]  00000001 00000000 bf445cec b29f23f5 bf445d04 b10a95f9 b10fa388 b4544b80
[    7.154489]  b02b60b0 bf42e000 bf445d14 b10a96a1 00000009 00000000 bf445d48 b10fa388
[    7.154489]  00000006 bf42e000 00000000 bf445e14 bf445d3c b10f92d0 00000000 bf42e4e0
[    7.154489] Call Trace:
[    7.154489]  [<b29f23f5>] dump_stack+0x16/0x18
[    7.154489]  [<b10a95f9>] warn_slowpath_common+0x72/0x89
[    7.154489]  [<b10fa388>] ? __lock_acquire+0x1d5/0x8c6
[    7.154489]  [<b10a96a1>] warn_slowpath_null+0x14/0x18
[    7.154489]  [<b10fa388>] __lock_acquire+0x1d5/0x8c6
[    7.154489]  [<b10f92d0>] ? trace_hardirqs_on_caller+0x155/0x16f
[    7.154489]  [<b10fbaf6>] lock_acquire+0x9e/0x157
[    7.154489]  [<b10cb8f3>] ? flush_workqueue+0x6b/0x98b
[    7.154489]  [<b10cb913>] flush_workqueue+0x8b/0x98b
[    7.154489]  [<b10cb8f3>] ? flush_workqueue+0x6b/0x98b
[    7.154489]  [<b10cc286>] drain_workqueue+0x73/0x333
[    7.154489]  [<b10f92f5>] ? trace_hardirqs_on+0xb/0xd
[    7.154489]  [<b10cdaa2>] destroy_workqueue+0x15/0x4c8
[    7.154489]  [<b1a58172>] scsi_host_dev_release+0x73/0x15b
[    7.154489]  [<b198ae57>] device_release+0x6f/0xf0
[    7.154489]  [<b17cffd5>] kobject_cleanup+0xa9/0xd1
[    7.154489]  [<b17cfe7b>] kobject_put+0xb2/0xb7
[    7.154489]  [<b198bbe5>] put_device+0x2a/0x2c
[    7.154489]  [<b1a58d87>] scsi_unregister+0x37/0x39
[    7.154489]  [<b41c85c1>] aha1542_detect+0xc2a/0xc42
[    7.154489]  [<b18f16d8>] ? pnp_find_dev+0xb4/0x185
[    7.154489]  [<b41c7890>] ? aha1542_in+0xaf/0xaf
[    7.154489]  [<b41c78fb>] init_this_scsi_driver+0x6b/0x107
[    7.154489]  [<b41c7890>] ? aha1542_in+0xaf/0xaf
[    7.154489]  [<b415fea3>] do_one_initcall+0x81/0x176
[    7.154489]  [<b415f500>] ? repair_env_string+0x3/0x9d
[    7.154489]  [<b10d1cb3>] ? parse_args+0x2e8/0x3a1
[    7.154489]  [<b416013f>] kernel_init_freeable+0x1a7/0x26d
[    7.154489]  [<b29be100>] kernel_init+0xe/0x13e
[    7.154489]  [<b2a1d63b>] ret_from_kernel_thread+0x1b/0x30
[    7.154489]  [<b29be0f2>] ? rest_init+0x131/0x131
[    7.154489] ---[ end trace 77d6546bd913b153 ]---
[    7.181862] NCR53c406a: no available ports found

git bisect start d80813ed6679ea0be2d054f2e2085699d1493978 v3.13 --
git bisect good aa2e7100e38880db7907cb2b7ec6267b2b243771  # 12:53     21+     61  Merge branch 'akpm' (patches from Andrew Morton)
git bisect good dd178a56e226296988cd5a6f3499f07f259b4631  # 14:30     21+     61  Merge remote-tracking branch 'char-misc.current/char-misc-linus'
git bisect good b19abf9906eda1d49591a117d2315b02a8a58fa8  # 15:25     21+     61  Merge remote-tracking branch 'slave-dma/next'
git bisect good 9341660bd894be14c9dd67cbd36588aa25dd377e  # 18:23     21+     61  Merge remote-tracking branch 'devicetree/devicetree/next'
git bisect  bad 522e2050f3a977119a1865b18052351c224bf171  # 18:23      0-     39  Merge remote-tracking branch 'leds/for-next'
git bisect good e2cc5d720204e37334aeb329cb7a739d0f235498  # 19:03     31+     71  Merge remote-tracking branch 'rcu/rcu/next'
git bisect good d66402d9b6333251a1f5f7f7fff3319ba99b6038  # 19:31     31+     70  Merge remote-tracking branch 'percpu/for-next'
git bisect  bad aa6ce92d60439f2d2af8879350e4cae414b7f23b  # 19:31      0-     38  Merge remote-tracking branch 'workqueues/for-next'
git bisect  bad 84604340d034a074036e86e85c4055a1c7ea5529  # 19:32      0-     39  workqueue: Fix workqueue lockdep name
# first bad commit: [84604340d034a074036e86e85c4055a1c7ea5529] workqueue: Fix workqueue lockdep name
git bisect good 38dbfb59d1175ef458d006556061adeaa8751b72  # 20:35     93+    243  Linus 3.14-rc1
git bisect  bad 460217583c934110865a2f5dce5e1b5c98835a46  # 20:35      0-     29  Add linux-next specific files for 20140212
git bisect good 5af25fcc4384df9e5558f46bb93fca3e0d760a97  # 21:03     93+     93  Revert "workqueue: Fix workqueue lockdep name"
git bisect  bad ca033390a537dacdc2127c66d62e7862ad15ffdb  # 22:00     92-     93  Merge tag 'usb-3.14-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb
git bisect good da8d308fbdb8360078786b3e125238122c4fc611  # 03:19    940+    940  Add linux-next specific files for 20140214

Thanks,
Fengguang

--qOrJKOH36bD5yhNe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-cairo-7:20140212143146:i386-randconfig-c1-02121350:3.14.0-rc2-next-20140212-02309-g4602175:3"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc2-next-20140212-02309-g4602175 (kbuil=
d@cairo) (gcc version 4.8.1 (Debian 4.8.1-8) ) #3 Wed Feb 12 13:57:48 CST 2=
014
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
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
[    0.000000] initial memory mapped: [mem 0x00000000-0x04ffffff]
[    0.000000] Base memory trampoline at [b009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0f800000-0x0fbfffff]
[    0.000000]  [mem 0x0f800000-0x0fbfffff] page 4k
[    0.000000] BRK [0x0499f000, 0x0499ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0f7fffff]
[    0.000000]  [mem 0x08000000-0x0f7fffff] page 4k
[    0.000000] BRK [0x049a0000, 0x049a0fff] PGTABLE
[    0.000000] BRK [0x049a1000, 0x049a1fff] PGTABLE
[    0.000000] BRK [0x049a2000, 0x049a2fff] PGTABLE
[    0.000000] BRK [0x049a3000, 0x049a3fff] PGTABLE
[    0.000000] BRK [0x049a4000, 0x049a4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x07ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x0fcbd000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACP 0fffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXP=
C 00000001)
[    0.000000] ACPI: DSDT 0fffe490 0011A9 (v01   BXPC   BXDSDT 00000001 INT=
L 20100528)
[    0.000000] ACPI: FACS 0fffff40 000040
[    0.000000] ACPI: SSDT 0ffff7a0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: APIC 0ffff680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXP=
C 00000001)
[    0.000000] ACPI: HPET 0ffff640 000038 (v01 BOCHS  BXPCHPET 00000001 BXP=
C 00000001)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 540 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 3809a00
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64860
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-c1-02121350/next:master/.vmlinuz-460217583c934110865a2f5=
dce5e1b5c98835a46-20140212135831-3-cairo branch=3Dnext/master BOOT_IMAGE=3D=
/kernel/i386-randconfig-c1-02121350/460217583c934110865a2f5dce5e1b5c98835a4=
6/vmlinuz-3.14.0-rc2-next-20140212-02309-g4602175
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 196276K/261744K available (26750K kernel code, 9666K=
 rwdata, 14128K rodata, 1468K init, 6896K bss, 65468K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffce000 - 0xfffff000   ( 196 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xc07fe000 - 0xff7fe000   (1008 MB)
[    0.000000]     lowmem  : 0xb0000000 - 0xbfffe000   ( 255 MB)
[    0.000000]       .init : 0xb415f000 - 0xb42ce000   (1468 kB)
[    0.000000]       .data : 0xb2a1fddf - 0xb415eb60   (23803 kB)
[    0.000000]       .text : 0xb1000000 - 0xb2a1fddf   (26751 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3Dbf402000 soft=3Dbf404000
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] ACPI: setting ELCR to 0200 (from 0c00)
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
[    0.000000] ODEBUG: 12 of 12 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2893.000 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 5788.08 Bogo=
MIPS (lpj=3D9643333)
[    0.006666] pid_max: default: 32768 minimum: 301
[    0.006666] Security Framework initialized
[    0.006666] Smack:  Initializing.
[    0.006666] Yama: becoming mindful.
[    0.006666] Mount-cache hash table entries: 512
[    0.007243] Initializing cgroup subsys freezer
[    0.007632] Initializing cgroup subsys blkio
[    0.007981] Initializing cgroup subsys perf_event
[    0.008365] Initializing cgroup subsys hugetlb
[    0.008822] mce: CPU supports 10 MCE banks
[    0.009209] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.009209] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.009209] tlb_flushall_shift: 6
[    0.010017] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.021297] ftrace: allocating 75385 entries in 148 pages
[    0.044033] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.048834] ftrace: Allocated trace_printk buffers
[    0.056002] devtmpfs: initialized
[    0.060881] EVM: security.SMACK64
[    0.061455] EVM: security.capability
[    0.068450] xor: measuring software checksum speed
[    0.100041]    pIII_sse  :   157.200 MB/sec
[    0.133378]    prefetch64-sse:   153.600 MB/sec
[    0.134191] xor: using function: pIII_sse (157.200 MB/sec)
[    0.136474] regulator-dummy: no parameters
[    0.137284] NET: Registered protocol family 16
[    0.144368] ACPI: bus type PCI registered
[    0.145076] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.146279] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.300323] bio: create slab <bio-0> at 0
[    0.356709] raid6: mmxx1     2724 MB/s
[    0.413365] raid6: mmxx2     3123 MB/s
[    0.470052] raid6: sse1x1    2275 MB/s
[    0.526705] raid6: sse1x2    2917 MB/s
[    0.583365] raid6: sse2x1    4572 MB/s
[    0.640035] raid6: sse2x2    5689 MB/s
[    0.640649] raid6: using algorithm sse2x2 (5689 MB/s)
[    0.641427] raid6: using intx1 recovery algorithm
[    0.644579] ACPI: Added _OSI(Module Device)
[    0.645281] ACPI: Added _OSI(Processor Device)
[    0.645948] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.646683] ACPI: Added _OSI(Processor Aggregator Device)
[    0.679303] ACPI: Interpreter enabled
[    0.679876] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20131218/hwxface-580)
[    0.680818] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20131218/hwxface-580)
[    0.682244] ACPI: (supports S0 S3 S5)
[    0.683348] ACPI: Using PIC for interrupt routing
[    0.684619] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.691450] ACPI: No dock devices found.
[    0.736596] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.736709] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments]
[    0.737834] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.745365] acpiphp: Slot [3] registered
[    0.746505] acpiphp: Slot [4] registered
[    0.746886] acpiphp: Slot [5] registered
[    0.747683] acpiphp: Slot [6] registered
[    0.748581] acpiphp: Slot [7] registered
[    0.750400] acpiphp: Slot [8] registered
[    0.751217] acpiphp: Slot [9] registered
[    0.752023] acpiphp: Slot [10] registered
[    0.753109] acpiphp: Slot [11] registered
[    0.753565] acpiphp: Slot [12] registered
[    0.754398] acpiphp: Slot [13] registered
[    0.755227] acpiphp: Slot [14] registered
[    0.756814] acpiphp: Slot [15] registered
[    0.757638] acpiphp: Slot [16] registered
[    0.758492] acpiphp: Slot [17] registered
[    0.759335] acpiphp: Slot [18] registered
[    0.760502] acpiphp: Slot [19] registered
[    0.761365] acpiphp: Slot [20] registered
[    0.762232] acpiphp: Slot [21] registered
[    0.763403] acpiphp: Slot [22] registered
[    0.764285] acpiphp: Slot [23] registered
[    0.765180] acpiphp: Slot [24] registered
[    0.766078] acpiphp: Slot [25] registered
[    0.767190] acpiphp: Slot [26] registered
[    0.768001] acpiphp: Slot [27] registered
[    0.768788] acpiphp: Slot [28] registered
[    0.769623] acpiphp: Slot [29] registered
[    0.770614] acpiphp: Slot [30] registered
[    0.771422] acpiphp: Slot [31] registered
[    0.772032] PCI host bridge to bus 0000:00
[    0.772713] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.773355] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.774257] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.775140] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.776688] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.777841] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.780899] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.784189] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.788263] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.791393] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.792964] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.793374] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.797131] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.801305] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.804209] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.815107] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.819535] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.821235] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.823919] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.829954] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.831382] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.833983] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.840459] pci_bus 0000:00: on NUMA node 0
[    0.843840] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.845553] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.847239] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.848994] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.850270] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.861177] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.862318] vgaarb: loaded
[    0.862697] vgaarb: bridge control possible 0000:00:02.0
[    0.868030] SCSI subsystem initialized
[    0.869248] libata version 3.00 loaded.
[    0.872407] pps_core: LinuxPPS API ver. 1 registered
[    0.873159] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.873442] PTP clock support registered
[    0.874583] wmi: Mapper loaded
[    0.877547] Advanced Linux Sound Architecture Driver Initialized.
[    0.878705] PCI: Using ACPI for IRQ routing
[    0.879413] PCI: pci_cache_line_size set to 64 bytes
[    0.880251] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.881256] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.884777] NET: Registered protocol family 23
[    0.885853] Bluetooth: Core ver 2.18
[    0.886486] NET: Registered protocol family 31
[    0.886682] Bluetooth: HCI device and connection manager initialized
[    0.887644] Bluetooth: HCI socket layer initialized
[    0.888369] Bluetooth: L2CAP socket layer initialized
[    0.889214] Bluetooth: SCO socket layer initialized
[    0.890061] NET: Registered protocol family 8
[    0.890683] NET: Registered protocol family 20
[    0.894817] NetLabel: Initializing
[    0.895351] NetLabel:  domain hash size =3D 128
[    0.895991] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.896872] NetLabel:  unlabeled traffic allowed by default
[    0.898142] cfg80211: Calling CRDA to update world regulatory domain
[    0.902599] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.903555] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.906582] Switched to clocksource kvm-clock
[    0.907179] Warning: could not register all branches stats
[    0.908083] Warning: could not register annotated branches stats
[    1.307164] pnp: PnP ACPI init
[    1.308190] ACPI: bus type PNP registered
[    1.309495] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.311085] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.312557] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.313905] pnp 00:03: [dma 2]
[    1.314800] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.316636] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.317898] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.319621] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.320822] pnp: PnP ACPI: found 7 devices
[    1.321168] ACPI: bus type PNP unregistered
[    1.321537] PnPBIOS: Disabled
[    1.360535] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.361000] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.361449] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.361944] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.362518] NET: Registered protocol family 2
[    1.363735] TCP established hash table entries: 2048 (order: 1, 8192 byt=
es)
[    1.364372] TCP bind hash table entries: 2048 (order: 4, 90112 bytes)
[    1.365043] TCP: Hash tables configured (established 2048 bind 2048)
[    1.365633] TCP: reno registered
[    1.365915] UDP hash table entries: 256 (order: 2, 24576 bytes)
[    1.366449] UDP-Lite hash table entries: 256 (order: 2, 24576 bytes)
[    1.367600] NET: Registered protocol family 1
[    1.367989] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.368491] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.368965] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.369486] pci 0000:00:02.0: Boot video device
[    1.369875] PCI: CLS 0 bytes, default 64
[    1.370813] Trying to unpack rootfs image as initramfs...
[    1.526417] debug: unmapping init [mem 0xbfcbd000-0xbffeffff]
[    3.173301] DMA-API: preallocated 65536 debug entries
[    3.174164] DMA-API: debugging enabled by kernel config
[    3.176503] kvm: no hardware support
[    3.177190] has_svm: not amd
[    3.177589] kvm: no hardware support
[    3.180882] Machine check injector initialized
[    3.184357] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    3.185672] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    3.190421] apm: BIOS not found.
[    3.197764] PCLMULQDQ-NI instructions are not detected.
[    3.198499] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    3.199744] NatSemi SCx200 Driver
[    3.215391] Initializing RT-Tester: OK
[    3.221866] futex hash table entries: 256 (order: 1, 12288 bytes)
[    3.222763] Initialise system trusted keyring
[    3.253557] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    3.274839] VFS: Disk quotas dquot_6.5.2
[    3.275426] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    3.282673] DLM installed
[    3.283253] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    3.293373] NTFS driver 2.1.30 [Flags: R/W DEBUG].
[    3.294159] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    3.294825] jffs2: version 2.2. (NAND)=20
[    3.296322] ROMFS MTD (C) 2007 Red Hat, Inc.
[    3.297150] QNX4 filesystem 0.2.3 registered.
[    3.300623] fuse init (API version 7.22)
[    3.304259] JFS: nTxBlock =3D 1533, nTxLock =3D 12267
[    3.309946] SGI XFS with security attributes, debug enabled
[    3.316250] NILFS version 2 loaded
[    3.316898] BeFS version: 0.9.3
[    3.317679] ocfs2 stack glue: unable to register sysctl
[    3.318353] ocfs2: Registered cluster interface o2cb
[    3.321809] ocfs2: Registered cluster interface user
[    3.322717] OCFS2 User DLM kernel interface loaded
[    3.337526] ceph: loaded (mds proto 32)
[    3.338088] msgmni has been set to 383
[    3.360345] alg: No test for lz4 (lz4-generic)
[    3.361169] alg: No test for lz4hc (lz4hc-generic)
[    3.361994] alg: No test for stdrng (krng)
[    3.362589] NET: Registered protocol family 38
[    3.363257] Key type asymmetric registered
[    3.364074] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 249)
[    3.365058] io scheduler noop registered (default)
[    3.365763] io scheduler cfq registered
[    3.366262] test_string_helpers: Running tests...
[    3.384480] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.385266] cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
[    3.386387] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.432127] acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
[    3.441301] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    3.442072] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    3.448834] vmlfb: initializing
[    3.449431] Could not find Carillo Ranch MCH device.
[    3.450586] no IO addresses supplied
[    3.454008] hgafb: HGA card not detected.
[    3.454619] hgafb: probe of hgafb.0 failed with error -22
[    3.464474] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    3.465435] ACPI: Power Button [PWRF]
[    3.467112] button: probe of LNXPWRBN:00 failed with error -22
[    3.471184] isapnp: Scanning for PnP cards...
[    3.843630] isapnp: No Plug & Play device found
[    3.853636] r3964: Philips r3964 Driver $Revision: 1.10 $
[    3.854553] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.877886] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    3.958873] STMicroelectronics ASC driver initialized
[    3.968060] serial: Freescale lpuart driver
[    3.968933] MOXA Intellio family driver version 6.0k
[    3.972463] MOXA Smartio/Industio family driver version 2.0.5
[    3.973379] Initializing Nozomi driver 2.1d
[    3.974063] RocketPort device driver module, version 2.09, 12-June-2003
[    3.975102] No rocketport ports found; unloading driver
[    3.975837] SyncLink GT
[    3.976220] SyncLink GT, tty major#241
[    3.976844] SyncLink GT no devices found
[    3.977350] SyncLink serial driver $Revision: 4.38 $
[    4.157391] SyncLink serial driver $Revision: 4.38 $, tty major#240
[    4.161747] DoubleTalk PC - not found
[    4.162303] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    4.163292] ac.o: No PCI boards found.
[    4.163820] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    4.164940] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    4.169485] Non-volatile memory driver v1.3
[    4.170243] toshiba: not a supported Toshiba laptop
[    4.171219] ppdev: user-space parallel port driver
[    4.171880] scx200_gpio: no SCx200 gpio present
[    4.172508] nsc_gpio initializing
[    4.173008] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    4.173516] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    4.175091] Hangcheck: Using getrawmonotonic().
[    4.180335] tsc: Refined TSC clocksource calibration: 2891.737 MHz
[    4.181307] parport_pc 00:04: reported by Plug and Play ACPI
[    4.182290] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    4.302090] Floppy drive(s): fd0 is 1.44M
[    4.327729] FDC 0 is a S82078B
[    4.410419] brd: module loaded
[    4.460712] loop: module loaded
[    4.482162] nbd: registered device at major 43
[    4.589780] rbd: loaded
[    4.590137] mtip32xx Version 1.3.0
[    4.590901] null_blk: softirq completions not available.
[    4.591738] null_blk: using direct completions.
[    4.592424] blk-mq: CPU -> queue map
[    4.592908]   CPU 0 -> Queue 0
[    4.600523]  nullb0: unknown partition table
[    4.605819] blk-mq: CPU -> queue map
[    4.606313]   CPU 0 -> Queue 0
[    4.608965]  nullb1: unknown partition table
[    4.612863] null: module loaded
[    4.616313] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    4.617612] Phantom Linux Driver, version n0.9.8, init OK
[    4.624724] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    4.626178] c2port c2port0: C2 port uc added
[    4.626735] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    4.651144] Uniform Multi-Platform E-IDE driver
[    4.661819] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[    4.662901] piix 0000:00:01.1: not 100% native mode: will probe irqs lat=
er
[    4.664547]     ide0: BM-DMA at 0xc040-0xc047
[    4.665315]     ide1: BM-DMA at 0xc048-0xc04f
[    4.665884] Probing IDE interface ide0...
[    5.356980] Probing IDE interface ide1...
[    6.253031] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[    7.115490] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[    7.116503] hdc: MWDMA2 mode selected
[    7.121080] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    7.121799] ide1 at 0x170-0x177,0x376 on irq 15
[    7.127296] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[    7.128670] ide-gd driver 1.18
[    7.136022] Loading iSCSI transport class v2.0-870.
[    7.137691] hp_sw: device handler registered
[    7.144824] bnx2fc: Broadcom NetXtreme II FCoE Driver bnx2fc v2.4.1 (Sep=
 17, 2013)
[    7.149528] iscsi: registered transport (tcp)
[    7.150365] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[    7.151212] Detecting Adaptec I2O RAID controllers...
[    7.153240] ------------[ cut here ]------------
[    7.153979] WARNING: CPU: 0 PID: 1 at kernel/locking/lockdep.c:710 __loc=
k_acquire+0x1d5/0x8c6()
[    7.154489] CPU: 0 PID: 1 Comm: swapper Not tainted 3.14.0-rc2-next-2014=
0212-02309-g4602175 #3
[    7.154489] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    7.154489]  00000001 00000000 bf445cec b29f23f5 bf445d04 b10a95f9 b10fa=
388 b4544b80
[    7.154489]  b02b60b0 bf42e000 bf445d14 b10a96a1 00000009 00000000 bf445=
d48 b10fa388
[    7.154489]  00000006 bf42e000 00000000 bf445e14 bf445d3c b10f92d0 00000=
000 bf42e4e0
[    7.154489] Call Trace:
[    7.154489]  [<b29f23f5>] dump_stack+0x16/0x18
[    7.154489]  [<b10a95f9>] warn_slowpath_common+0x72/0x89
[    7.154489]  [<b10fa388>] ? __lock_acquire+0x1d5/0x8c6
[    7.154489]  [<b10a96a1>] warn_slowpath_null+0x14/0x18
[    7.154489]  [<b10fa388>] __lock_acquire+0x1d5/0x8c6
[    7.154489]  [<b10f92d0>] ? trace_hardirqs_on_caller+0x155/0x16f
[    7.154489]  [<b10fbaf6>] lock_acquire+0x9e/0x157
[    7.154489]  [<b10cb8f3>] ? flush_workqueue+0x6b/0x98b
[    7.154489]  [<b10cb913>] flush_workqueue+0x8b/0x98b
[    7.154489]  [<b10cb8f3>] ? flush_workqueue+0x6b/0x98b
[    7.154489]  [<b10cc286>] drain_workqueue+0x73/0x333
[    7.154489]  [<b10f92f5>] ? trace_hardirqs_on+0xb/0xd
[    7.154489]  [<b10cdaa2>] destroy_workqueue+0x15/0x4c8
[    7.154489]  [<b1a58172>] scsi_host_dev_release+0x73/0x15b
[    7.154489]  [<b198ae57>] device_release+0x6f/0xf0
[    7.154489]  [<b17cffd5>] kobject_cleanup+0xa9/0xd1
[    7.154489]  [<b17cfe7b>] kobject_put+0xb2/0xb7
[    7.154489]  [<b198bbe5>] put_device+0x2a/0x2c
[    7.154489]  [<b1a58d87>] scsi_unregister+0x37/0x39
[    7.154489]  [<b41c85c1>] aha1542_detect+0xc2a/0xc42
[    7.154489]  [<b18f16d8>] ? pnp_find_dev+0xb4/0x185
[    7.154489]  [<b41c7890>] ? aha1542_in+0xaf/0xaf
[    7.154489]  [<b41c78fb>] init_this_scsi_driver+0x6b/0x107
[    7.154489]  [<b41c7890>] ? aha1542_in+0xaf/0xaf
[    7.154489]  [<b415fea3>] do_one_initcall+0x81/0x176
[    7.154489]  [<b415f500>] ? repair_env_string+0x3/0x9d
[    7.154489]  [<b10d1cb3>] ? parse_args+0x2e8/0x3a1
[    7.154489]  [<b416013f>] kernel_init_freeable+0x1a7/0x26d
[    7.154489]  [<b29be100>] kernel_init+0xe/0x13e
[    7.154489]  [<b2a1d63b>] ret_from_kernel_thread+0x1b/0x30
[    7.154489]  [<b29be0f2>] ? rest_init+0x131/0x131
[    7.154489] ---[ end trace 77d6546bd913b153 ]---
[    7.181862] NCR53c406a: no available ports found
[    7.182495] sym53c416.c: Version 1.0.0-ac
[    7.183124] qlogicfas: no cards were found, please specify I/O address a=
nd IRQ using iobase=3D and irq=3D options
[    7.187626] iscsi: registered transport (qla4xxx)
[    7.188466] QLogic iSCSI HBA Driver
[    7.188951] Brocade BFA FC/FCOE SCSI driver - version: 3.2.23.0
[    7.301769] megasas: 06.700.06.00-rc1 Sat. Aug. 31 17:00:00 PDT 2013
[    7.302868] mpt2sas version 16.100.00.00 loaded
[    7.306927] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    7.307919] 3ware Storage Controller device driver for Linux v1.26.02.00=
3.
[    7.308976] LSI 3ware SAS/SATA-RAID Controller device driver for Linux v=
3.26.02.000.
[    7.313055] ppa: Version 2.07 (for Linux 2.4.x)
[    7.316259] imm: Version 2.05 (for Linux 2.4.0)
[    7.317710] RocketRAID 3xxx/4xxx Controller driver v1.8
[    7.318891] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age =
0xf, 4 bits.
[    7.319978] libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx=
 0.
[    7.321072] Chelsio T3 iSCSI Driver cxgb3i v2.0.0 (Jun. 2010)
[    7.322083] iscsi: registered transport (cxgb3i)
[    7.322813] Chelsio T4/T5 iSCSI Driver cxgb4i v0.9.4
[    7.326540] iscsi: registered transport (cxgb4i)
[    7.327400] Broadcom NetXtreme II iSCSI Driver bnx2i v2.7.6.2 (Jun 06, 2=
013)
[    7.328542] iscsi: registered transport (bnx2i)
[    7.332361] iscsi: registered transport (be2iscsi)
[    7.333064] In beiscsi_module_init, tt=3Db39ce160
[    7.334188] esas2r: driver will not be loaded because no ATTO esas2r dev=
ices were found
[    7.343661] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    7.344708] osst :I: Tape driver with OnStream support version 0.99.4
[    7.344708] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    7.374099] scsi_debug: host protection
[    7.374668] scsi2 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    7.380482] scsi 2:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    7.399004] sd 2:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[    7.400834] sd 2:0:0:0: [sda] Write Protect is off
[    7.401521] sd 2:0:0:0: [sda] Mode Sense: 73 00 10 08
[    7.412720] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[    7.414569] sd 2:0:0:0: Attached scsi generic sg0 type 0
[    7.450086] SSFDC read-only Flash Translation layer
[    7.450904] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    7.452038] platform physmap-flash.0: failed to claim resource 0
[    7.452939] Failed to ioremap_nocache
[    7.459475] slram: not enough parameters.
[    7.460063] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel =
Networks.
[    7.461045] pmc551: not detected
[    7.473959]  sda: unknown partition table
[    7.508158] sd 2:0:0:0: [sda] Attached SCSI disk
[    7.619977] parport0: AVR Butterfly
[    7.620786] parport0: cannot grant exclusive access for device spi-lm70l=
lp
[    7.621749] spi-lm70llp: spi_lm70llp probe fail, status -12
[    7.626256] HSI/SSI char device loaded
[    7.656626] libphy: Fixed MDIO Bus: probed
[    7.660819] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.t=
c.umn.edu>
[    7.668452] ipddp0: Appletalk-IP Encap. mode by Bradford W. Johnson <joh=
ns393@maroon.tc.umn.edu>
[    7.669970] vcan: Virtual CAN interface driver
[    7.670757] CAN device driver interface
[    7.674399] cc770: CAN netdevice driver
[    7.674913] cc770_isa: insufficient parameters supplied
[    7.679195] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    7.679971] Copyright (c) 2007 Atheros Corporation.
[    7.684301] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.19 (Decemb=
er 19, 2013)
[    7.685760] Brocade 10G Ethernet driver - version: 3.2.23.0
[    7.693378] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[    7.694434] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.=
com>
[    7.694434]   http://www.scyld.com/network/drivers.html
[    7.696495] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-2=
9)
[    7.700686] vxge: Copyright(c) 2002-2010 Exar Corp.
[    7.701321] vxge: Driver version: 2.5.3.22640-k
[    7.702087] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    7.702858] e100: Copyright(c) 1999-2006 Intel Corporation
[    7.706632] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-=
NAPI
[    7.707570] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    7.713925] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    7.715020] PCI: setting IRQ 11 as level-triggered
[    8.221761] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
[    8.223022] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[    8.224425] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    8.225422] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    8.226516] igbvf: Intel(R) Gigabit Virtual Function Network Driver - ve=
rsion 2.0.2-k
[    8.227877] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[    8.228935] i40e: Intel(R) Ethernet Connection XL710 Network Driver - ve=
rsion 0.3.30-k
[    8.230398] i40e: Copyright (c) 2013 - 2014 Intel Corporation.
[    8.231522] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2=
-NAPI
[    8.232664] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    8.242033] myri10ge: Version 1.5.3-1.534
[    8.246449] Solarflare NET driver v4.0
[    8.247637] tehuti: Tehuti Networks(R) Network Driver, 7.29.3
[    8.248545] tehuti: Options: hw_csum=20
[    8.266903] NET3 PLIP version 2.4-parport gniibe@mri.co.jp
[    8.267829] plip0: Parallel port at 0x378, using IRQ 7.
[    8.268679] PPP generic driver version 2.4.2
[    8.270190] PPP BSD Compression module registered
[    8.270973] PPP Deflate Compression module registered
[    8.271805] PPP MPPE Compression module registered
[    8.272590] NET: Registered protocol family 24
[    8.273615] PPTP driver version 0.8.5
[    8.274991] hdlc: HDLC support module revision 1.22
[    8.275906] DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
[    8.277050] SDLA driver v0.30, 12 Sep 1996, mike.mclagan@linux.org.
[    8.286232] ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
[    8.287532] ipw2100: Copyright(c) 2003-2006 Intel Corporation
[    8.292384] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2=
=2E2kq
[    8.293778] ipw2200: Copyright(c) 2003-2006 Intel Corporation
[    8.294939] libipw: 802.11 data/management/control stack, git-1.1.13
[    8.296007] libipw: Copyright (C) 2004-2005 Intel Corporation <jketreno@=
linux.intel.com>
[    8.297560] orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, P=
avel Roskin <proski@gnu.org>, et al)
[    8.299189] orinoco_pci 0.15 (Pavel Roskin <proski@gnu.org>, David Gibso=
n <hermes@gibson.dropbear.id.au> & Jean Tourrilhes <jt@hpl.hp.com>)
[    8.301652] airo(): Probing for PCI adapters
[    8.302490] airo(): Finished probing for PCI adapters
[    8.307464] Broadcom 43xx driver loaded [ Features: PL ]
[    8.308471] Broadcom 43xx-legacy driver loaded [ Features: PLI ]
[    8.313852] Intel(R) Wireless WiFi driver for Linux, in-tree:
[    8.314777] Copyright(c) 2003- 2014 Intel Corporation
[    8.315897] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection=
 driver for Linux, in-tree:s
[    8.317556] iwl3945: Copyright(c) 2003-2011 Intel Corporation
[    8.333032] ieee80211 phy0: Selected rate control algorithm 'minstrel'
[    8.346226] ieee80211 phy0: hwaddr 02:00:00:00:00:00 registered
[    8.356759] ieee80211 phy1: Selected rate control algorithm 'minstrel'
[    8.373622] ieee80211 phy1: hwaddr 02:00:00:00:01:00 registered
[    8.385166] mac80211_hwsim: initializing netlink
[    8.386641] VMware vmxnet3 virtual NIC driver - version 1.2.0.0-k-NAPI
[    8.391378] I2O subsystem v1.325
[    8.391941] i2o: max drivers =3D 8
[    8.393106] I2O Bus Adapter OSM v1.317
[    8.393813] I2O SCSI Peripheral OSM v1.316
[    8.394487] I2O ProcFS OSM v1.316
[    8.398619] Fusion MPT base driver 3.04.20
[    8.399320] Copyright (c) 1999-2008 LSI Corporation
[    8.400149] Fusion MPT FC Host driver 3.04.20
[    8.401222] Fusion MPT misc device (ioctl) driver 3.04.20
[    8.402684] mptctl: Registered with Fusion MPT base driver
[    8.403586] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[    8.412382] paride: aten registered as protocol 0
[    8.413171] paride: bpck registered as protocol 1
[    8.413939] paride: dstr registered as protocol 2
[    8.414698] paride: epat registered as protocol 3
[    8.415592] paride: epia registered as protocol 4
[    8.416354] paride: frpw registered as protocol 5
[    8.417107] paride: friq registered as protocol 6
[    8.419964] paride: fit2 registered as protocol 7
[    8.422849] paride: fit3 registered as protocol 8
[    8.423622] paride: ktti registered as protocol 9
[    8.424551] pd: pd version 1.05, major 45, cluster 64, nice 0
[   29.824145] random: nonblocking pool is initialized
[  240.323407] INFO: task swapper:1 blocked for more than 120 seconds.
[  240.323890]       Tainted: G        W    3.14.0-rc2-next-20140212-02309-=
g4602175 #3
[  240.324458] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[  240.325026] swapper         D f52a9301     0     1      0 0x00000000
[  240.325512]  bf445e24 00000046 bf42e000 f52a9301 00000001 bd918000 bf42e=
000 00000007
[  240.326164]  00000006 bf42e000 b2a1c8d9 b0180574 bf445df8 b10f92d0 00000=
246 b018059c
[  240.326880]  bf445e00 b10f92f5 bf445e10 00000246 bdb34b28 b0180438 bf445=
e2c b1981d72
[  240.327533] Call Trace:
[  240.327725]  [<b2a1c8d9>] ? _raw_write_unlock_irqrestore+0x57/0x69
[  240.328181]  [<b10f92d0>] ? trace_hardirqs_on_caller+0x155/0x16f
[  240.328611]  [<b10f92f5>] ? trace_hardirqs_on+0xb/0xd
[  240.328986]  [<b1981d72>] ? parport_claim+0x30c/0x319
[  240.329356]  [<b2a16f8b>] schedule+0x9f/0xa1
[  240.329680]  [<b21ce7a1>] pi_claim+0xc1/0xd4
[  240.330074]  [<b10f0dff>] ? __wake_up_common+0x77/0x77
[  240.330451]  [<b21ce7f7>] pi_test_proto+0x1b/0x14d
[  240.330796]  [<b21cea45>] pi_probe_mode+0x11c/0x16a
[  240.331159]  [<b21ceca6>] pi_probe_unit+0x213/0x23f
[  240.331510]  [<b21cf174>] pi_init+0x24c/0x341
[  240.331833]  [<b41dcdf4>] pd_init+0x18b/0x34d
[  240.332160]  [<b41dcc69>] ? ktti_init+0xf/0xf
[  240.332481]  [<b415fea3>] do_one_initcall+0x81/0x176
[  240.332844]  [<b415f500>] ? repair_env_string+0x3/0x9d
[  240.333221]  [<b10d1cb3>] ? parse_args+0x2e8/0x3a1
[  240.333633]  [<b416013f>] kernel_init_freeable+0x1a7/0x26d
[  240.334041]  [<b29be100>] kernel_init+0xe/0x13e
[  240.334370]  [<b2a1d63b>] ret_from_kernel_thread+0x1b/0x30
[  240.334767]  [<b29be0f2>] ? rest_init+0x131/0x131
[  240.335114] no locks held by swapper/1.
[  240.335435] Kernel panic - not syncing: hung_task: blocked tasks
[  240.335874] CPU: 0 PID: 9 Comm: khungtaskd Tainted: G        W    3.14.0=
-rc2-next-20140212-02309-g4602175 #3
[  240.336587] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  240.336943]  00000001 00000002 bf6d3ec4 b29f23f5 bf6d3edc b29c89af 00000=
001 00000002
[  240.336943]  bf42e000 bf42e000 bf6d3f10 b1136b93 b356afa8 00000078 00000=
1ab 0000028d
[  240.336943]  000003ff 00007fff bf42e218 bf42e218 00000078 b1136c7c 00000=
007 bf6d3f1c
[  240.336943] Call Trace:
[  240.336943]  [<b29f23f5>] dump_stack+0x16/0x18
[  240.336943]  [<b29c89af>] panic+0xd5/0x23c
[  240.336943]  [<b1136b93>] check_hung_uninterruptible_tasks+0x617/0x700
[  240.336943]  [<b1136c7c>] ? check_hung_uninterruptible_tasks+0x700/0x700
[  240.336943]  [<b1136cdb>] watchdog+0x5f/0x61
[  240.336943]  [<b10d3ec8>] kthread+0xf5/0xfa
[  240.336943]  [<b1136c7c>] ? check_hung_uninterruptible_tasks+0x700/0x700
[  240.336943]  [<b10e8ffa>] ? local_clock+0x2d/0x37
[  240.336943]  [<b2a1d63b>] ret_from_kernel_thread+0x1b/0x30
[  240.336943]  [<b10d3dd3>] ? insert_kthread_work+0xb9/0xb9
[  240.336943] Kernel Offset: 0x0 from 0xb1000000 (relocation range: 0xb000=
0000-0xc07fdfff)

Elapsed time: 20
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-c=
1-02121350/460217583c934110865a2f5dce5e1b5c98835a46/vmlinuz-3.14.0-rc2-next=
-20140212-02309-g4602175 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,1=
15200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-c1-02121350/next:master/.vmlinuz-460217583c934110865a2f5=
dce5e1b5c98835a46-20140212135831-3-cairo branch=3Dnext/master BOOT_IMAGE=3D=
/kernel/i386-randconfig-c1-02121350/460217583c934110865a2f5dce5e1b5c98835a4=
6/vmlinuz-3.14.0-rc2-next-20140212-02309-g4602175'  -initrd /kernel-tests/i=
nitrd/yocto-minimal-i386.cgz -m 256M -smp 2 -net nic,vlan=3D1,model=3De1000=
 -net user,vlan=3D1,hostfwd=3Dtcp::18572-:22 -boot order=3Dnc -no-reboot -w=
atchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-yocto-ca=
iro-7 -serial file:/dev/shm/kboot/serial-yocto-cairo-7 -daemonize -display =
none -monitor null=20

--qOrJKOH36bD5yhNe
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-c1-02121350-460217583c934110865a2f5dce5e1b5c98835a46-init_this_scsi_driver+-x-71493.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IGQ4MDgxM2VkNjY3OWVhMGJlMmQwNTRmMmUyMDg1Njk5ZDE0OTM5NzgK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jMS0w
MjEyMTM1MC9uZXh0Om1hc3RlcjpkODA4MTNlZDY2NzllYTBiZTJkMDU0ZjJlMjA4NTY5OWQx
NDkzOTc4OmJpc2VjdC1tbQogVEVTVCBGQUlMVVJFClsgICAxNy4yNzUwODVdIExvYWRpbmcg
QWRhcHRlYyBJMk8gUkFJRDogVmVyc2lvbiAyLjQgQnVpbGQgNWdvClsgICAxNy4yNzYwNDBd
IERldGVjdGluZyBBZGFwdGVjIEkyTyBSQUlEIGNvbnRyb2xsZXJzLi4uClsgICAxNy4yNzk2
MDJdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgMTcuMjgwMjg3
XSBXQVJOSU5HOiBDUFU6IDAgUElEOiAxIGF0IGtlcm5lbC9sb2NraW5nL2xvY2tkZXAuYzo3
MTAgX19sb2NrX2FjcXVpcmUrMHgxZDUvMHg4Y2QoKQpbICAgMTcuMjgwMjg3XSBDUFU6IDAg
UElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xNC4wLXJjMi0wMjE4MS1nZDgw
ODEzZSAjMjEKWyAgIDE3LjI4MDI4N10gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJ
T1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgMTcuMjgwMjg3XSAgMDAwMDAwMDEgMDAwMDAwMDAg
YmRjMjljZWMgYjI5ZDcyODUgYmRjMjlkMDQgYjEwYTk3NzkgYjEwZmE1MDIgYjQ0ZWViODAK
WyAgIDE3LjI4MDI4N10gIGIwMjdiMGIwIGJkYzI2MDAwIGJkYzI5ZDE0IGIxMGE5ODIxIDAw
MDAwMDA5IDAwMDAwMDAwIGJkYzI5ZDQ4IGIxMGZhNTAyClsgICAxNy4yODAyODddICAwMDAw
MDAwNiBiZGMyNjAwMCAwMDAwMDAwMCBiZGMyOWUxNCBiZGMyOWQzYyBiMTBmOTQ0YSAwMDAw
MDAwMCBiZGMyNjRlMApbICAgMTcuMjgwMjg3XSBDYWxsIFRyYWNlOgpbICAgMTcuMjgwMjg3
XSAgWzxiMjlkNzI4NT5dIGR1bXBfc3RhY2srMHgxNi8weDE4ClsgICAxNy4yODAyODddICBb
PGIxMGE5Nzc5Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg3Mi8weDg5ClsgICAxNy4yODAy
ODddICBbPGIxMGZhNTAyPl0gPyBfX2xvY2tfYWNxdWlyZSsweDFkNS8weDhjZApbICAgMTcu
MjgwMjg3XSAgWzxiMTBhOTgyMT5dIHdhcm5fc2xvd3BhdGhfbnVsbCsweDE0LzB4MTgKWyAg
IDE3LjI4MDI4N10gIFs8YjEwZmE1MDI+XSBfX2xvY2tfYWNxdWlyZSsweDFkNS8weDhjZApb
ICAgMTcuMjgwMjg3XSAgWzxiMTBmOTQ0YT5dID8gdHJhY2VfaGFyZGlycXNfb25fY2FsbGVy
KzB4MTU1LzB4MTZmClsgICAxNy4yODAyODddICBbPGIxMGZiYzc3Pl0gbG9ja19hY3F1aXJl
KzB4OWUvMHgxNTcKWyAgIDE3LjI4MDI4N10gIFs8YjEwY2JhOTU+XSA/IGZsdXNoX3dvcmtx
dWV1ZSsweDZiLzB4OThiClsgICAxNy4yODAyODddICBbPGIxMGNiYWI1Pl0gZmx1c2hfd29y
a3F1ZXVlKzB4OGIvMHg5OGIKWyAgIDE3LjI4MDI4N10gIFs8YjEwY2JhOTU+XSA/IGZsdXNo
X3dvcmtxdWV1ZSsweDZiLzB4OThiClsgICAxNy4yODAyODddICBbPGIxMGNjNDI4Pl0gZHJh
aW5fd29ya3F1ZXVlKzB4NzMvMHgzMzMKWyAgIDE3LjI4MDI4N10gIFs8YjEwZjk0NmY+XSA/
IHRyYWNlX2hhcmRpcnFzX29uKzB4Yi8weGQKWyAgIDE3LjI4MDI4N10gIFs8YjEwY2RjNDQ+
XSBkZXN0cm95X3dvcmtxdWV1ZSsweDE1LzB4NGM4ClsgICAxNy4yODAyODddICBbPGIxYTU2
OTk5Pl0gc2NzaV9ob3N0X2Rldl9yZWxlYXNlKzB4NzMvMHgxNWIKWyAgIDE3LjI4MDI4N10g
IFs8YjE5ODk0NzM+XSBkZXZpY2VfcmVsZWFzZSsweDZmLzB4ZjAKWyAgIDE3LjI4MDI4N10g
IFs8YjE3Y2ViODI+XSBrb2JqZWN0X2NsZWFudXArMHhhOS8weGQxClsgICAxNy4yODAyODdd
ICBbPGIxN2NlYTI4Pl0ga29iamVjdF9wdXQrMHhiMi8weGI3ClsgICAxNy4yODAyODddICBb
PGIxOThhMjAxPl0gcHV0X2RldmljZSsweDJhLzB4MmMKWyAgIDE3LjI4MDI4N10gIFs8YjFh
NTc1YWU+XSBzY3NpX3VucmVnaXN0ZXIrMHgzNy8weDM5ClsgICAxNy4yODAyODddICBbPGI0
MTc1NTE3Pl0gYWhhMTU0Ml9kZXRlY3QrMHhjMmEvMHhjNDIKWyAgIDE3LjI4MDI4N10gIFs8
YjE4ZWZjNjc+XSA/IHBucF9maW5kX2RldisweGI0LzB4MTg1ClsgICAxNy4yODAyODddICBb
PGI0MTc0N2U2Pl0gPyBhaGExNTQyX2luKzB4YWYvMHhhZgpbICAgMTcuMjgwMjg3XSAgWzxi
NDE3NDg1MT5dIGluaXRfdGhpc19zY3NpX2RyaXZlcisweDZiLzB4MTA3ClsgICAxNy4yODAy
ODddICBbPGI0MTc0N2U2Pl0gPyBhaGExNTQyX2luKzB4YWYvMHhhZgpbICAgMTcuMjgwMjg3
XSAgWzxiNDEwY2VhMz5dIGRvX29uZV9pbml0Y2FsbCsweDgxLzB4MTc2ClsgICAxNy4yODAy
ODddICBbPGI0MTBjNTAwPl0gPyByZXBhaXJfZW52X3N0cmluZysweDMvMHg5ZApbICAgMTcu
MjgwMjg3XSAgWzxiMTBkMWU1NT5dID8gcGFyc2VfYXJncysweDJlOC8weDNhMQpbICAgMTcu
MjgwMjg3XSAgWzxiNDEwZDEzZj5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MWE3LzB4MjZk
ClsgICAxNy4yODAyODddICBbPGIyOWEyZjg3Pl0ga2VybmVsX2luaXQrMHhlLzB4MTNlClsg
ICAxNy4yODAyODddICBbPGIyYTAyNDViPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFi
LzB4MzAKWyAgIDE3LjI4MDI4N10gIFs8YjI5YTJmNzk+XSA/IHJlc3RfaW5pdCsweDEzMS8w
eDEzMQpbICAgMTcuMjgwMjg3XSAtLS1bIGVuZCB0cmFjZSA2Mjk5ZTlmODUxNDQ3NDhiIF0t
LS0KWyAgIDE3LjMyMjI4NV0gTkNSNTNjNDA2YTogbm8gYXZhaWxhYmxlIHBvcnRzIGZvdW5k
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwL2Q4MDgxM2VkNjY3OWVhMGJl
MmQwNTRmMmUyMDg1Njk5ZDE0OTM5NzgvZG1lc2ctcXVhbnRhbC14aWFuLTE3OjIwMTQwMjEz
MDgzODE5OmkzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MDozLjE0LjAtcmMyLTAyMTgxLWdk
ODA4MTNlOjIxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwL2Q4MDgxM2Vk
NjY3OWVhMGJlMmQwNTRmMmUyMDg1Njk5ZDE0OTM5NzgvZG1lc2cteW9jdG8tYXRoZW5zLTE6
MjAxNDAyMTMwODMzMDc6aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwOjMuMTQuMC1yYzIt
MDIxODEtZ2Q4MDgxM2U6MjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTAv
ZDgwODEzZWQ2Njc5ZWEwYmUyZDA1NGYyZTIwODU2OTlkMTQ5Mzk3OC9kbWVzZy1xdWFudGFs
LWNhaXJvLTUyOjIwMTQwMjEzMDg0NDQzOmkzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MDoz
LjE0LjAtcmMyLTAyMTgxLWdkODA4MTNlOjIxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMx
LTAyMTIxMzUwL2Q4MDgxM2VkNjY3OWVhMGJlMmQwNTRmMmUyMDg1Njk5ZDE0OTM5NzgvZG1l
c2cteW9jdG8teGlhbi01NjoyMDE0MDIxMzA4MzcwNTppMzg2LXJhbmRjb25maWctYzEtMDIx
MjEzNTA6My4xNC4wLXJjMi0wMjE4MS1nZDgwODEzZToyMQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1jMS0wMjEyMTM1MC9kODA4MTNlZDY2NzllYTBiZTJkMDU0ZjJlMjA4NTY5OWQxNDkz
OTc4L2RtZXNnLXlvY3RvLXhpYW4tMjA6MjAxNDAyMTMwODM4MTY6aTM4Ni1yYW5kY29uZmln
LWMxLTAyMTIxMzUwOjMuMTQuMC1yYzItMDIxODEtZ2Q4MDgxM2U6MjEKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYzEtMDIxMjEzNTAvZDgwODEzZWQ2Njc5ZWEwYmUyZDA1NGYyZTIwODU2
OTlkMTQ5Mzk3OC9kbWVzZy1xdWFudGFsLXhpYW4tMzI6MjAxNDAyMTMwODM3MTY6aTM4Ni1y
YW5kY29uZmlnLWMxLTAyMTIxMzUwOjMuMTQuMC1yYzItMDIxODEtZ2Q4MDgxM2U6MjEKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTAvZDgwODEzZWQ2Njc5ZWEwYmUyZDA1
NGYyZTIwODU2OTlkMTQ5Mzk3OC9kbWVzZy1xdWFudGFsLWJlbnMtNToyMDE0MDIxMzA4MzMw
MDppMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTA6My4xNC4wLXJjMi0wMjE4MS1nZDgwODEz
ZToyMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC9kODA4MTNlZDY2Nzll
YTBiZTJkMDU0ZjJlMjA4NTY5OWQxNDkzOTc4L2RtZXNnLXlvY3RvLXhpYW4tNTQ6MjAxNDAy
MTMwODI3NTk6aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwOjMuMTQuMC1yYzItMDIxODEt
Z2Q4MDgxM2U6MjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTAvZDgwODEz
ZWQ2Njc5ZWEwYmUyZDA1NGYyZTIwODU2OTlkMTQ5Mzk3OC9kbWVzZy15b2N0by1pbm4tOToy
MDE0MDIxMzA4Mzc0MTppMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTA6My4xNC4wLXJjMi0w
MjE4MS1nZDgwODEzZToyMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC9k
ODA4MTNlZDY2NzllYTBiZTJkMDU0ZjJlMjA4NTY5OWQxNDkzOTc4L2RtZXNnLXF1YW50YWwt
amFrZXRvd24tMzI6MjAxNDAyMTMwOTMwMDY6aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUw
OjMuMTQuMC1yYzItMDIxODEtZ2Q4MDgxM2U6MjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YzEtMDIxMjEzNTAvZDgwODEzZWQ2Njc5ZWEwYmUyZDA1NGYyZTIwODU2OTlkMTQ5Mzk3OC9k
bWVzZy15b2N0by1pbm4tMjA6MjAxNDAyMTMwODI5MTM6aTM4Ni1yYW5kY29uZmlnLWMxLTAy
MTIxMzUwOjMuMTQuMC1yYzItMDIxODEtZ2Q4MDgxM2U6MjEKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYzEtMDIxMjEzNTAvZDgwODEzZWQ2Njc5ZWEwYmUyZDA1NGYyZTIwODU2OTlkMTQ5
Mzk3OC9kbWVzZy15b2N0by1qYWtldG93bi0xMDoyMDE0MDIxMzA5MzcyNzppMzg2LXJhbmRj
b25maWctYzEtMDIxMjEzNTA6My4xNC4wLXJjMi0wMjE4MS1nZDgwODEzZToyMQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC9kODA4MTNlZDY2NzllYTBiZTJkMDU0ZjJl
MjA4NTY5OWQxNDkzOTc4L2RtZXNnLXF1YW50YWwtamFrZXRvd24tNDY6MjAxNDAyMTMwOTM3
Mjc6aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwOjMuMTQuMC1yYzItMDIxODEtZ2Q4MDgx
M2U6MjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTAvZDgwODEzZWQ2Njc5
ZWEwYmUyZDA1NGYyZTIwODU2OTlkMTQ5Mzk3OC9kbWVzZy1xdWFudGFsLWJlbnMtMjoyMDE0
MDIxMzA4MjY1MzppMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTA6My4xNC4wLXJjMi0wMjE4
MS1nZDgwODEzZToyMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC9kODA4
MTNlZDY2NzllYTBiZTJkMDU0ZjJlMjA4NTY5OWQxNDkzOTc4L2RtZXNnLXlvY3RvLXhpYW4t
MTc6MjAxNDAyMTMwODM2NTA6aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwOjMuMTQuMC1y
YzItMDIxODEtZ2Q4MDgxM2U6MjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDIxMjEz
NTAvZDgwODEzZWQ2Njc5ZWEwYmUyZDA1NGYyZTIwODU2OTlkMTQ5Mzk3OC9kbWVzZy15b2N0
by14aWFuLTMxOjIwMTQwMjEzMDgzNDEwOmkzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MDoz
LjE0LjAtcmMyLTAyMTgxLWdkODA4MTNlOjIxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMx
LTAyMTIxMzUwL2Q4MDgxM2VkNjY3OWVhMGJlMmQwNTRmMmUyMDg1Njk5ZDE0OTM5NzgvZG1l
c2ctcXVhbnRhbC1yb2FtLTIxOjIwMTQwMjEzMDgyODE5OmkzODYtcmFuZGNvbmZpZy1jMS0w
MjEyMTM1MDozLjE0LjAtcmMyLTAyMTgxLWdkODA4MTNlOjIxCjA6MTc6MjAgYWxsX2dvb2Q6
YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDItMTUgMTI6MjM6MTAgUkVQRUFUIENP
VU5UOiAyMSAgIyAvY2Mvd2ZnL21tLWJpc2VjdC8ucmVwZWF0G1swbQoKYmlzZWN0OiBiYWQg
Y29tbWl0IGQ4MDgxM2VkNjY3OWVhMGJlMmQwNTRmMmUyMDg1Njk5ZDE0OTM5NzgKZ2l0IGNo
ZWNrb3V0IHYzLjEzCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJh
bmRjb25maWctYzEtMDIxMjEzNTAvbmV4dDptYXN0ZXI6ZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5
NGY1NmU4ODE0MjEwZjBlNjRiZTpiaXNlY3QtbW0KCjIwMTQtMDItMTUtMTI6MjM6MTIgZDhl
YzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZSByZXVzZSAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4
MTQyMTBmMGU2NGJlL3ZtbGludXotMy4xMy4wCgoyMDE0LTAyLTE1LTEyOjIzOjEyIGRldGVj
dGluZyBib290IHN0YXRlIC4uLi4uLi4uLi4uLi4uLi4uLi4uCTEuLgkzCTQJNS4uCTkJMTIJ
MTgJMjEgU1VDQ0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCB2My4xMwpnaXQgYmlzZWN0IHN0
YXJ0IGQ4MDgxM2VkNjY3OWVhMGJlMmQwNTRmMmUyMDg1Njk5ZDE0OTM5NzggdjMuMTMgLS0K
L2Mva2VybmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6IFsiLWIiLCAiZDgwODEzZWQ2Njc5ZWEw
YmUyZDA1NGYyZTIwODU2OTlkMTQ5Mzk3OCIsICItZyIsICJ2My4xMyIsICIvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIiwgIi9ob21lL3dmZy9tbS9vYmot
YmlzZWN0Il0KQmlzZWN0aW5nOiAxMzc2MCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgMTQgc3RlcHMpClthYTJlNzEwMGUzODg4MGRiNzkwN2NiMmI3ZWM2
MjY3YjJiMjQzNzcxXSBNZXJnZSBicmFuY2ggJ2FrcG0nIChwYXRjaGVzIGZyb20gQW5kcmV3
IE1vcnRvbikKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9ob21lL3dmZy9tbS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVu
LXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTAvbmV4dDptYXN0ZXI6YWEy
ZTcxMDBlMzg4ODBkYjc5MDdjYjJiN2VjNjI2N2IyYjI0Mzc3MTpiaXNlY3QtbW0KCjIwMTQt
MDItMTUtMTI6Mzk6MTYgYWEyZTcxMDBlMzg4ODBkYjc5MDdjYjJiN2VjNjI2N2IyYjI0Mzc3
MSByZXVzZSAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC9hYTJlNzEwMGUz
ODg4MGRiNzkwN2NiMmI3ZWM2MjY3YjJiMjQzNzcxL3ZtbGludXotMy4xMy4wLTEwNDgwLWdh
YTJlNzEwCgoyMDE0LTAyLTE1LTEyOjM5OjE2IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4u
Li4uCTMJNQk4LgkxMC4uLgkxMQkxNgkxOC4JMTkuLi4uLi4uCTIxIFNVQ0NFU1MKCkJpc2Vj
dGluZzogMzI4MCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
MTIgc3RlcHMpCltkZDE3OGE1NmUyMjYyOTY5ODhjZDVhNmYzNDk5ZjA3ZjI1OWI0NjMxXSBN
ZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdjaGFyLW1pc2MuY3VycmVudC9jaGFyLW1p
c2MtbGludXMnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwL25leHQ6bWFzdGVyOmRk
MTc4YTU2ZTIyNjI5Njk4OGNkNWE2ZjM0OTlmMDdmMjU5YjQ2MzE6YmlzZWN0LW1tCgoyMDE0
LTAyLTE1LTEyOjUzOjQ5IGRkMTc4YTU2ZTIyNjI5Njk4OGNkNWE2ZjM0OTlmMDdmMjU5YjQ2
MzEgcmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTAvZGQxNzhhNTZl
MjI2Mjk2OTg4Y2Q1YTZmMzQ5OWYwN2YyNTliNDYzMS92bWxpbnV6LTMuMTQuMC1yYzItMDAz
MDAtZ2RkMTc4YTUKCjIwMTQtMDItMTUtMTI6NTM6NDkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uCTEJMi4uLi4uLgkzCTQJNgk5CTEzCTE2CTE3Li4uLi4uLi4JMTgJMjAu
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMjEgU1VD
Q0VTUwoKQmlzZWN0aW5nOiAxODgxIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSAxMSBzdGVwcykKW2IxOWFiZjk5MDZlZGExZDQ5NTkxYTExN2QyMzE1YjAy
YThhNThmYThdIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ3NsYXZlLWRtYS9uZXh0
JwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2hvbWUvd2ZnL21tL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUv
a3ZtL2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC9uZXh0Om1hc3RlcjpiMTlhYmY5OTA2
ZWRhMWQ0OTU5MWExMTdkMjMxNWIwMmE4YTU4ZmE4OmJpc2VjdC1tbQoKMjAxNC0wMi0xNS0x
NDozMDo1MiBiMTlhYmY5OTA2ZWRhMWQ0OTU5MWExMTdkMjMxNWIwMmE4YTU4ZmE4IHJldXNl
IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwL2IxOWFiZjk5MDZlZGExZDQ5
NTkxYTExN2QyMzE1YjAyYThhNThmYTgvdm1saW51ei0zLjE0LjAtcmMyLTAxMTE3LWdiMTlh
YmY5CgoyMDE0LTAyLTE1LTE0OjMwOjUyIGRldGVjdGluZyBib290IHN0YXRlIC4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uCTIuLi4uLi4uCTMuLi4uCTUJOS4JMTAuLi4uLi4JMTUuLi4uLi4u
Li4uLi4uLi4JMTYuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4JMjEgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxMDY0IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3Qg
YWZ0ZXIgdGhpcyAocm91Z2hseSAxMSBzdGVwcykKWzkzNDE2NjBiZDg5NGJlMTRjOWRkNjdj
YmQzNjU4OGFhMjVkZDM3N2VdIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ2Rldmlj
ZXRyZWUvZGV2aWNldHJlZS9uZXh0JwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tL29iai1iaXNlY3QKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC9u
ZXh0Om1hc3Rlcjo5MzQxNjYwYmQ4OTRiZTE0YzlkZDY3Y2JkMzY1ODhhYTI1ZGQzNzdlOmJp
c2VjdC1tbQoKMjAxNC0wMi0xNS0xNToyNToyNSA5MzQxNjYwYmQ4OTRiZTE0YzlkZDY3Y2Jk
MzY1ODhhYTI1ZGQzNzdlIHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIx
MzUwLzkzNDE2NjBiZDg5NGJlMTRjOWRkNjdjYmQzNjU4OGFhMjVkZDM3N2Uvdm1saW51ei0z
LjE0LjAtcmMyLTAxNjg0LWc5MzQxNjYwCgoyMDE0LTAyLTE1LTE1OjI1OjI1IGRldGVjdGlu
ZyBib290IHN0YXRlIC4uLi4uLi4uLgkyCTMuCTUJNgk3Lgk5CTEwCTEyCTEzLi4JMTQuCTE1
LgkxNwkxOC4uLgkxOS4uLi4uLi4uCTIwLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
LhtbMTszNW0yMDE0LTAyLTE1IDE4OjE3OjM5IGFkZF90b19ydW5fcXVldWUgMRtbMG0KLi4u
Li4uLi4uLgkyMSBTVUNDRVNTCgpCaXNlY3Rpbmc6IDQ5NyByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOSBzdGVwcykKWzUyMmUyMDUwZjNhOTc3MTE5YTE4
NjViMTgwNTIzNTFjMjI0YmYxNzFdIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ2xl
ZHMvZm9yLW5leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwL25leHQ6bWFzdGVy
OjUyMmUyMDUwZjNhOTc3MTE5YTE4NjViMTgwNTIzNTFjMjI0YmYxNzE6YmlzZWN0LW1tCiBU
RVNUIEZBSUxVUkUKWyAgIDE1LjMxOTQ5NF0gcGFyaWRlOiBrdHRpIHJlZ2lzdGVyZWQgYXMg
cHJvdG9jb2wgOQpbICAgMTUuMzIwNzQyXSBwZDogcGQgdmVyc2lvbiAxLjA1LCBtYWpvciA0
NSwgY2x1c3RlciA2NCwgbmljZSAwClsgICAzMC44OTAyOTFdIHJhbmRvbTogbm9uYmxvY2tp
bmcgcG9vbCBpcyBpbml0aWFsaXplZApbICAyNDguMTc2ODg4XSBJTkZPOiB0YXNrIHN3YXBw
ZXI6MSBibG9ja2VkIGZvciBtb3JlIHRoYW4gMTIwIHNlY29uZHMuClsgIDI0OC4xNzc3MzRd
ICAgICAgIE5vdCB0YWludGVkIDMuMTQuMC1yYzItMDE5MTAtZzUyMmUyMDUgIzI3ClsgIDI0
OC4xNzg0MTJdICJlY2hvIDAgPiAvcHJvYy9zeXMva2VybmVsL2h1bmdfdGFza190aW1lb3V0
X3NlY3MiIGRpc2FibGVzIHRoaXMgbWVzc2FnZS4KWyAgMjQ4LjE3OTM1NF0gc3dhcHBlciAg
ICAgICAgIEQgOGZmZDFmMDEgICAgIDAgICAgIDEgICAgICAwIDB4MDAwMDAwMDAKWyAgMjQ4
LjE4MDM1MF0gIGJkYzI5ZTI0IDAwMDAwMDQ2IGJkYzI2MDAwIDhmZmQxZjAxIDAwMDAwMDAz
IGI3YTFhMDAwIGJkYzI2MDAwIDAwMDAwMDA3ClsgIDI0OC4xODE0ODRdICAwMDAwMDAwNiBi
ZGMyNjAwMCBiMjlmZmQ0MSBiMDE0NTU3NCBiZGMyOWRmOCBiMTBmOTQ0ZSAwMDAwMDI0NiBi
MDE0NTU5YwpbICAyNDguMTgyNTQ1XSAgYmRjMjllMDAgYjEwZjk0NzMgYmRjMjllMTAgMDAw
MDAyNDYgYjdiZjQyMzggYjAxNDU0MzggYmRjMjllMmMgYjE5ODE0NGMKWyAgMjQ4LjE4Mzgx
Nl0gQ2FsbCBUcmFjZToKWyAgMjQ4LjE4NDI1M10gIFs8YjI5ZmZkNDE+XSA/IF9yYXdfd3Jp
dGVfdW5sb2NrX2lycXJlc3RvcmUrMHg1Ny8weDY5ClsgIDI0OC4xODUwMzFdICBbPGIxMGY5
NDRlPl0gPyB0cmFjZV9oYXJkaXJxc19vbl9jYWxsZXIrMHgxNTUvMHgxNmYKWyAgMjQ4LjE4
NTc5NF0gIFs8YjEwZjk0NzM+XSA/IHRyYWNlX2hhcmRpcnFzX29uKzB4Yi8weGQKWyAgMjQ4
LjE4NjQyOV0gIFs8YjE5ODE0NGM+XSA/IHBhcnBvcnRfY2xhaW0rMHgzMGMvMHgzMTkKWyAg
MjQ4LjE4NzE5N10gIFs8YjI5ZmEzZjA+XSBzY2hlZHVsZSsweDlmLzB4YTEKWyAgMjQ4LjE4
Nzc4Ml0gIFs8YjIxYjIyOGY+XSBwaV9jbGFpbSsweGMxLzB4ZDQKWyAgMjQ4LjE4ODMwOV0g
IFs8YjEwZjBmN2Q+XSA/IF9fd2FrZV91cF9jb21tb24rMHg3Ny8weDc3ClsgIDI0OC4xODg5
MTNdICBbPGIyMWIyMmU1Pl0gcGlfdGVzdF9wcm90bysweDFiLzB4MTRkClsgIDI0OC4xODk0
NzhdICBbPGIyMWIyNTMzPl0gcGlfcHJvYmVfbW9kZSsweDExYy8weDE2YQpbICAyNDguMTkw
MjIxXSAgWzxiMjFiMjc5ND5dIHBpX3Byb2JlX3VuaXQrMHgyMTMvMHgyM2YKWyAgMjQ4LjE5
MDg2Ml0gIFs8YjIxYjJjNjI+XSBwaV9pbml0KzB4MjRjLzB4MzQxClsgIDI0OC4xOTE0MTRd
ICBbPGI0MTg0ZjEwPl0gcGRfaW5pdCsweDE4Yi8weDM0ZApbICAyNDguMTkxOTQwXSAgWzxi
NDE4NGQ4NT5dID8ga3R0aV9pbml0KzB4Zi8weGYKWyAgMjQ4LjE5MjQ3N10gIFs8YjQxMDhl
YTM+XSBkb19vbmVfaW5pdGNhbGwrMHg4MS8weDE3NgpbICAyNDguMTkzMDU4XSAgWzxiNDEw
ODUwMD5dID8gcmVwYWlyX2Vudl9zdHJpbmcrMHgzLzB4OWQKWyAgMjQ4LjE5MzgzNF0gIFs8
YjEwZDFlNTU+XSA/IHBhcnNlX2FyZ3MrMHgyZTgvMHgzYTEKWyAgMjQ4LjE5NDQ3MF0gIFs8
YjQxMDkxM2Y+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDFhNy8weDI2ZApbICAyNDguMTk1
MTQ3XSAgWzxiMjlhMTVkYj5dIGtlcm5lbF9pbml0KzB4ZS8weDEzZQpbICAyNDguMTk1Njg4
XSAgWzxiMmEwMGFiYj5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDMwClsgIDI0
OC4xOTYzNDRdICBbPGIyOWExNWNkPl0gPyByZXN0X2luaXQrMHgxMzEvMHgxMzEKWyAgMjQ4
LjE5NzA3Nl0gbm8gbG9ja3MgaGVsZCBieSBzd2FwcGVyLzEuCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWMxLTAyMTIxMzUwLzUyMmUyMDUwZjNhOTc3MTE5YTE4NjViMTgwNTIzNTFjMjI0
YmYxNzEvZG1lc2cteW9jdG8teGd3by01OjIwMTQwMjEzMTM0MzEzOmkzODYtcmFuZGNvbmZp
Zy1jMS0wMjEyMTM1MDozLjE0LjAtcmMyLTAxOTEwLWc1MjJlMjA1OjI3Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwLzUyMmUyMDUwZjNhOTc3MTE5YTE4NjViMTgwNTIz
NTFjMjI0YmYxNzEvZG1lc2ctcXVhbnRhbC1hdGhlbnMtMjE6MjAxNDAyMTMxNDE0NTg6aTM4
Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwOjMuMTQuMC1yYzItMDE5MTAtZzUyMmUyMDU6MjcK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTAvNTIyZTIwNTBmM2E5NzcxMTlh
MTg2NWIxODA1MjM1MWMyMjRiZjE3MS9kbWVzZy15b2N0by1jYWlyby0zNDoyMDE0MDIxMzE0
MTQzMzppMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTA6My4xNC4wLXJjMi0wMTkxMC1nNTIy
ZTIwNToyNwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC81MjJlMjA1MGYz
YTk3NzExOWExODY1YjE4MDUyMzUxYzIyNGJmMTcxL2RtZXNnLXF1YW50YWwtaW5uLTIzOjIw
MTQwMjEzMTQxNDA0OmkzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MDozLjE0LjAtcmMyLTAx
OTEwLWc1MjJlMjA1OjI3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwLzUy
MmUyMDUwZjNhOTc3MTE5YTE4NjViMTgwNTIzNTFjMjI0YmYxNzEvZG1lc2ctcXVhbnRhbC1h
dGhlbnMtNzoyMDE0MDIxMzE0MTI0NTppMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTA6My4x
NC4wLXJjMi0wMTkxMC1nNTIyZTIwNToyNwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0w
MjEyMTM1MC81MjJlMjA1MGYzYTk3NzExOWExODY1YjE4MDUyMzUxYzIyNGJmMTcxL2RtZXNn
LXlvY3RvLXhpYW4tNjQ6MjAxNDAyMTMxNDEzNDM6aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIx
MzUwOjMuMTQuMC1yYzItMDE5MTAtZzUyMmUyMDU6MjcKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctYzEtMDIxMjEzNTAvNTIyZTIwNTBmM2E5NzcxMTlhMTg2NWIxODA1MjM1MWMyMjRiZjE3
MS9kbWVzZy1xdWFudGFsLXhpYW4tMTI6MjAxNDAyMTMxNDE1Mjc6aTM4Ni1yYW5kY29uZmln
LWMxLTAyMTIxMzUwOjMuMTQuMC1yYzItMDE5MTAtZzUyMmUyMDU6MjcKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYzEtMDIxMjEzNTAvNTIyZTIwNTBmM2E5NzcxMTlhMTg2NWIxODA1MjM1
MWMyMjRiZjE3MS9kbWVzZy1xdWFudGFsLWNhaXJvLTI6MjAxNDAyMTMxNDE0Mjk6aTM4Ni1y
YW5kY29uZmlnLWMxLTAyMTIxMzUwOjMuMTQuMC1yYzItMDE5MTAtZzUyMmUyMDU6MjcKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTAvNTIyZTIwNTBmM2E5NzcxMTlhMTg2
NWIxODA1MjM1MWMyMjRiZjE3MS9kbWVzZy1xdWFudGFsLXhnd28tMToyMDE0MDIxMzEzNDM0
NTppMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTA6My4xNC4wLXJjMi0wMTkxMC1nNTIyZTIw
NToyNwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC81MjJlMjA1MGYzYTk3
NzExOWExODY1YjE4MDUyMzUxYzIyNGJmMTcxL2RtZXNnLXF1YW50YWwtaW5uLTMwOjIwMTQw
MjEzMTQxNDA0OmkzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MDozLjE0LjAtcmMyLTAxOTEw
LWc1MjJlMjA1OjI3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwLzUyMmUy
MDUwZjNhOTc3MTE5YTE4NjViMTgwNTIzNTFjMjI0YmYxNzEvZG1lc2cteW9jdG8teGd3by0y
OjIwMTQwMjEzMTM0MzI0OmkzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MDozLjE0LjAtcmMy
LTAxOTEwLWc1MjJlMjA1OjI3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUw
LzUyMmUyMDUwZjNhOTc3MTE5YTE4NjViMTgwNTIzNTFjMjI0YmYxNzEvZG1lc2ctcXVhbnRh
bC14aWFuLTg6MjAxNDAyMTMxMzQwMzk6aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwOjMu
MTQuMC1yYzItMDE5MTAtZzUyMmUyMDU6MjcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEt
MDIxMjEzNTAvNTIyZTIwNTBmM2E5NzcxMTlhMTg2NWIxODA1MjM1MWMyMjRiZjE3MS9kbWVz
Zy15b2N0by1zbmItNDM6MjAxNDAyMTMxNDE1MTY6aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIx
MzUwOjMuMTQuMC1yYzItMDE5MTAtZzUyMmUyMDU6MjcKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctYzEtMDIxMjEzNTAvNTIyZTIwNTBmM2E5NzcxMTlhMTg2NWIxODA1MjM1MWMyMjRiZjE3
MS9kbWVzZy15b2N0by1jYWlyby0xNzoyMDE0MDIxMzE0MTQxMzppMzg2LXJhbmRjb25maWct
YzEtMDIxMjEzNTA6My4xNC4wLXJjMi0wMTkxMC1nNTIyZTIwNToyNwova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1jMS0wMjEyMTM1MC81MjJlMjA1MGYzYTk3NzExOWExODY1YjE4MDUyMzUx
YzIyNGJmMTcxL2RtZXNnLXlvY3RvLXhnd28tNzoyMDE0MDIxMzE0MTU0MTppMzg2LXJhbmRj
b25maWctYzEtMDIxMjEzNTA6My4xNC4wLXJjMi0wMTkxMC1nNTIyZTIwNToyNwova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC81MjJlMjA1MGYzYTk3NzExOWExODY1YjE4
MDUyMzUxYzIyNGJmMTcxL2RtZXNnLXlvY3RvLXN0b2FrbGV5LTI6MjAxNDAyMTMxNDEzNDE6
aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwOjMuMTQuMC1yYzItMDE5MTAtZzUyMmUyMDU6
MjcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTAvNTIyZTIwNTBmM2E5Nzcx
MTlhMTg2NWIxODA1MjM1MWMyMjRiZjE3MS9kbWVzZy15b2N0by1pbm4tMzg6MjAxNDAyMTMx
NDE0MjQ6aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwOjMuMTQuMC1yYzItMDE5MTAtZzUy
MmUyMDU6MjcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTAvNTIyZTIwNTBm
M2E5NzcxMTlhMTg2NWIxODA1MjM1MWMyMjRiZjE3MS9kbWVzZy15b2N0by1pbm4tNDE6MjAx
NDAyMTMxNDEzMjg6aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwOjMuMTQuMC1yYzItMDE5
MTAtZzUyMmUyMDU6MjcKMDoxODozOSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7
MzVtMjAxNC0wMi0xNSAxODoyMzoyNSBSRVBFQVQgQ09VTlQ6IDMxICAjIC9jYy93ZmcvbW0t
YmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDIyNiByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOCBzdGVwcykKW2UyY2M1ZDcyMDIwNGUzNzMzNGFl
YjMyOWNiN2E3MzlkMGYyMzU0OThdIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ3Jj
dS9yY3UvbmV4dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9ob21lL3dmZy9tbS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTAvbmV4dDptYXN0ZXI6
ZTJjYzVkNzIwMjA0ZTM3MzM0YWViMzI5Y2I3YTczOWQwZjIzNTQ5ODpiaXNlY3QtbW0KCjIw
MTQtMDItMTUtMTg6MjM6MzAgZTJjYzVkNzIwMjA0ZTM3MzM0YWViMzI5Y2I3YTczOWQwZjIz
NTQ5OCByZXVzZSAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC9lMmNjNWQ3
MjAyMDRlMzczMzRhZWIzMjljYjdhNzM5ZDBmMjM1NDk4L3ZtbGludXotMy4xNC4wLXJjMi0w
MTg2Ni1nZTJjYzVkNwoKMjAxNC0wMi0xNS0xODoyMzozMCBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uCTMJOQkxNwkyNwkyOS4uLi4uLi4uCTMwCTMxIFNVQ0NFU1MKCkJpc2Vj
dGluZzogNDQgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDYg
c3RlcHMpCltkNjY0MDJkOWI2MzMzMjUxYTFmNWY3ZjdmZmYzMzE5YmE5OWI2MDM4XSBNZXJn
ZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdwZXJjcHUvZm9yLW5leHQnCnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0v
b2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5k
Y29uZmlnLWMxLTAyMTIxMzUwL25leHQ6bWFzdGVyOmQ2NjQwMmQ5YjYzMzMyNTFhMWY1Zjdm
N2ZmZjMzMTliYTk5YjYwMzg6YmlzZWN0LW1tCgoyMDE0LTAyLTE1LTE5OjAzOjMyIGQ2NjQw
MmQ5YjYzMzMyNTFhMWY1ZjdmN2ZmZjMzMTliYTk5YjYwMzggcmV1c2UgL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYzEtMDIxMjEzNTAvZDY2NDAyZDliNjMzMzI1MWExZjVmN2Y3ZmZmMzMx
OWJhOTliNjAzOC92bWxpbnV6LTMuMTQuMC1yYzItMDE4OTAtZ2Q2NjQwMmQKCjIwMTQtMDIt
MTUtMTk6MDM6MzIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4uLgkzLi4uCTQJNQk2
Lgk4Li4uLgk5CTEwCTExCTEyCTE4CTIwLi4uCTIxCTIzLi4JMjYuLgkyNy4uLi4JMjguLi4u
Li4uCTMwLi4JMzEgU1VDQ0VTUwoKQmlzZWN0aW5nOiAyMCByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNSBzdGVwcykKW2FhNmNlOTJkNjA0MzlmMmQyYWY4
ODc5MzUwZTRjYWU0MTRiN2YyM2JdIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ3dv
cmtxdWV1ZXMvZm9yLW5leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwL25leHQ6
bWFzdGVyOmFhNmNlOTJkNjA0MzlmMmQyYWY4ODc5MzUwZTRjYWU0MTRiN2YyM2I6YmlzZWN0
LW1tCiBURVNUIEZBSUxVUkUKWyAgIDExLjg4NDAyN10gTG9hZGluZyBBZGFwdGVjIEkyTyBS
QUlEOiBWZXJzaW9uIDIuNCBCdWlsZCA1Z28KWyAgIDExLjg4NDg1NV0gRGV0ZWN0aW5nIEFk
YXB0ZWMgSTJPIFJBSUQgY29udHJvbGxlcnMuLi4KWyAgIDExLjg4NzAxMF0gLS0tLS0tLS0t
LS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAxMS44ODc3NTBdIFdBUk5JTkc6IENQ
VTogMCBQSUQ6IDEgYXQga2VybmVsL2xvY2tpbmcvbG9ja2RlcC5jOjcxMCBfX2xvY2tfYWNx
dWlyZSsweDFkNS8weDhjZCgpClsgICAxMS44ODkxMjNdIENQVTogMCBQSUQ6IDEgQ29tbTog
c3dhcHBlciBOb3QgdGFpbnRlZCAzLjE0LjAtcmMyLTAxODkyLWdhYTZjZTkyICMzMApbICAg
MTEuODkwMDg2XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8w
MS8yMDExClsgICAxMS44OTAwODZdICAwMDAwMDAwMSAwMDAwMDAwMCBiZGMyOWNlYyBiMjlk
NTg0MCBiZGMyOWQwNCBiMTBhOTc3OSBiMTBmYTUwNiBiNDRlYmE1MApbICAgMTEuODkwMDg2
XSAgYjAyN2EwYjAgYmRjMjYwMDAgYmRjMjlkMTQgYjEwYTk4MjEgMDAwMDAwMDkgMDAwMDAw
MDAgYmRjMjlkNDggYjEwZmE1MDYKWyAgIDExLjg5MDA4Nl0gIDAwMDAwMDA2IGJkYzI2MDAw
IDAwMDAwMDAwIGJkYzI5ZTE0IGJkYzI5ZDNjIGIxMGY5NDRlIDAwMDAwMDAwIGJkYzI2NGUw
ClsgICAxMS44OTAwODZdIENhbGwgVHJhY2U6ClsgICAxMS44OTAwODZdICBbPGIyOWQ1ODQw
Pl0gZHVtcF9zdGFjaysweDE2LzB4MTgKWyAgIDExLjg5MDA4Nl0gIFs8YjEwYTk3Nzk+XSB3
YXJuX3Nsb3dwYXRoX2NvbW1vbisweDcyLzB4ODkKWyAgIDExLjg5MDA4Nl0gIFs8YjEwZmE1
MDY+XSA/IF9fbG9ja19hY3F1aXJlKzB4MWQ1LzB4OGNkClsgICAxMS44OTAwODZdICBbPGIx
MGE5ODIxPl0gd2Fybl9zbG93cGF0aF9udWxsKzB4MTQvMHgxOApbICAgMTEuODkwMDg2XSAg
WzxiMTBmYTUwNj5dIF9fbG9ja19hY3F1aXJlKzB4MWQ1LzB4OGNkClsgICAxMS44OTAwODZd
ICBbPGIxMGY5NDRlPl0gPyB0cmFjZV9oYXJkaXJxc19vbl9jYWxsZXIrMHgxNTUvMHgxNmYK
WyAgIDExLjg5MDA4Nl0gIFs8YjEwZmJjN2I+XSBsb2NrX2FjcXVpcmUrMHg5ZS8weDE1Nwpb
ICAgMTEuODkwMDg2XSAgWzxiMTBjYmE5NT5dID8gZmx1c2hfd29ya3F1ZXVlKzB4NmIvMHg5
OGIKWyAgIDExLjg5MDA4Nl0gIFs8YjEwY2JhYjU+XSBmbHVzaF93b3JrcXVldWUrMHg4Yi8w
eDk4YgpbICAgMTEuODkwMDg2XSAgWzxiMTBjYmE5NT5dID8gZmx1c2hfd29ya3F1ZXVlKzB4
NmIvMHg5OGIKWyAgIDExLjg5MDA4Nl0gIFs8YjEwY2M0Mjg+XSBkcmFpbl93b3JrcXVldWUr
MHg3My8weDMzMwpbICAgMTEuODkwMDg2XSAgWzxiMTBmOTQ3Mz5dID8gdHJhY2VfaGFyZGly
cXNfb24rMHhiLzB4ZApbICAgMTEuODkwMDg2XSAgWzxiMTBjZGM0ND5dIGRlc3Ryb3lfd29y
a3F1ZXVlKzB4MTUvMHg0YzgKWyAgIDExLjg5MDA4Nl0gIFs8YjFhNTYwZTU+XSBzY3NpX2hv
c3RfZGV2X3JlbGVhc2UrMHg3My8weDE1YgpbICAgMTEuODkwMDg2XSAgWzxiMTk4YTUzNT5d
IGRldmljZV9yZWxlYXNlKzB4NmYvMHhmMApbICAgMTEuODkwMDg2XSAgWzxiMTdjZmI4Mj5d
IGtvYmplY3RfY2xlYW51cCsweGE5LzB4ZDEKWyAgIDExLjg5MDA4Nl0gIFs8YjE3Y2ZhMjg+
XSBrb2JqZWN0X3B1dCsweGIyLzB4YjcKWyAgIDExLjg5MDA4Nl0gIFs8YjE5OGIyYWM+XSBw
dXRfZGV2aWNlKzB4MmEvMHgyYwpbICAgMTEuODkwMDg2XSAgWzxiMWE1NmNmYT5dIHNjc2lf
dW5yZWdpc3RlcisweDM3LzB4MzkKWyAgIDExLjg5MDA4Nl0gIFs8YjQxNzE4ODE+XSBhaGEx
NTQyX2RldGVjdCsweGMyYS8weGM0MgpbICAgMTEuODkwMDg2XSAgWzxiMThmMGM5Zj5dID8g
cG5wX2ZpbmRfZGV2KzB4YjQvMHgxODUKWyAgIDExLjg5MDA4Nl0gIFs8YjQxNzBiNTA+XSA/
IGFoYTE1NDJfaW4rMHhhZi8weGFmClsgICAxMS44OTAwODZdICBbPGI0MTcwYmJiPl0gaW5p
dF90aGlzX3Njc2lfZHJpdmVyKzB4NmIvMHgxMDcKWyAgIDExLjg5MDA4Nl0gIFs8YjQxNzBi
NTA+XSA/IGFoYTE1NDJfaW4rMHhhZi8weGFmClsgICAxMS44OTAwODZdICBbPGI0MTA4ZWEz
Pl0gZG9fb25lX2luaXRjYWxsKzB4ODEvMHgxNzYKWyAgIDExLjg5MDA4Nl0gIFs8YjQxMDg1
MDA+XSA/IHJlcGFpcl9lbnZfc3RyaW5nKzB4My8weDlkClsgICAxMS44OTAwODZdICBbPGIx
MGQxZTU1Pl0gPyBwYXJzZV9hcmdzKzB4MmU4LzB4M2ExClsgICAxMS44OTAwODZdICBbPGI0
MTA5MTNmPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgxYTcvMHgyNmQKWyAgIDExLjg5MDA4
Nl0gIFs8YjI5YTE1NDI+XSBrZXJuZWxfaW5pdCsweGUvMHgxM2UKWyAgIDExLjg5MDA4Nl0g
IFs8YjJhMDBhMWI+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MWIvMHgzMApbICAgMTEu
ODkwMDg2XSAgWzxiMjlhMTUzND5dID8gcmVzdF9pbml0KzB4MTMxLzB4MTMxClsgICAxMS44
OTAwODZdIC0tLVsgZW5kIHRyYWNlIGQ1MWU3ZTBiZjFiY2RjYzcgXS0tLQpbICAgMTEuOTE3
NzE3XSBOQ1I1M2M0MDZhOiBubyBhdmFpbGFibGUgcG9ydHMgZm91bmQKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYzEtMDIxMjEzNTAvYWE2Y2U5MmQ2MDQzOWYyZDJhZjg4NzkzNTBlNGNh
ZTQxNGI3ZjIzYi9kbWVzZy15b2N0by14aWFuLTM3OjIwMTQwMjEzMTgxNjEyOmkzODYtcmFu
ZGNvbmZpZy1jMS0wMjEyMTM1MDozLjE0LjAtcmMyLTAxODkyLWdhYTZjZTkyOjMwCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwL2FhNmNlOTJkNjA0MzlmMmQyYWY4ODc5
MzUwZTRjYWU0MTRiN2YyM2IvZG1lc2cteW9jdG8tYXRoZW5zLTQ6MjAxNDAyMTMxODE3MDI6
aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwOjMuMTQuMC1yYzItMDE4OTItZ2FhNmNlOTI6
MzAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTAvYWE2Y2U5MmQ2MDQzOWYy
ZDJhZjg4NzkzNTBlNGNhZTQxNGI3ZjIzYi9kbWVzZy1xdWFudGFsLWF0aGVucy0yNToyMDE0
MDIxMzE4MTYzMTppMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTA6My4xNC4wLXJjMi0wMTg5
Mi1nYWE2Y2U5MjozMAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC9hYTZj
ZTkyZDYwNDM5ZjJkMmFmODg3OTM1MGU0Y2FlNDE0YjdmMjNiL2RtZXNnLXF1YW50YWwtYXRo
ZW5zLTM0OjIwMTQwMjEzMTgxNjQxOmkzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MDozLjE0
LjAtcmMyLTAxODkyLWdhYTZjZTkyOjMwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTAy
MTIxMzUwL2FhNmNlOTJkNjA0MzlmMmQyYWY4ODc5MzUwZTRjYWU0MTRiN2YyM2IvZG1lc2ct
eW9jdG8tYmVucy02OjIwMTQwMjEzMTgxNzQ5OmkzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1
MDozLjE0LjAtcmMyLTAxODkyLWdhYTZjZTkyOjMwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWMxLTAyMTIxMzUwL2FhNmNlOTJkNjA0MzlmMmQyYWY4ODc5MzUwZTRjYWU0MTRiN2YyM2Iv
ZG1lc2ctcXVhbnRhbC1qYWtldG93bi0zMjoyMDE0MDIxMzE4MzU1NDppMzg2LXJhbmRjb25m
aWctYzEtMDIxMjEzNTA6My4xNC4wLXJjMi0wMTg5Mi1nYWE2Y2U5MjozMAova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC9hYTZjZTkyZDYwNDM5ZjJkMmFmODg3OTM1MGU0
Y2FlNDE0YjdmMjNiL2RtZXNnLXF1YW50YWwtYXRoZW5zLTU4OjIwMTQwMjEzMTgxNjI3Omkz
ODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MDozLjE0LjAtcmMyLTAxODkyLWdhYTZjZTkyOjMw
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwL2FhNmNlOTJkNjA0MzlmMmQy
YWY4ODc5MzUwZTRjYWU0MTRiN2YyM2IvZG1lc2cteW9jdG8tYXRoZW5zLTIyOjIwMTQwMjEz
MTgxNTU3OmkzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MDozLjE0LjAtcmMyLTAxODkyLWdh
YTZjZTkyOjMwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwL2FhNmNlOTJk
NjA0MzlmMmQyYWY4ODc5MzUwZTRjYWU0MTRiN2YyM2IvZG1lc2cteW9jdG8tYXRoZW5zLTI2
OjIwMTQwMjEzMTgxNjMxOmkzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MDozLjE0LjAtcmMy
LTAxODkyLWdhYTZjZTkyOjMwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUw
L2FhNmNlOTJkNjA0MzlmMmQyYWY4ODc5MzUwZTRjYWU0MTRiN2YyM2IvZG1lc2cteW9jdG8t
YXRoZW5zLTQxOjIwMTQwMjEzMTgxODQzOmkzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MDoz
LjE0LjAtcmMyLTAxODkyLWdhYTZjZTkyOjMwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMx
LTAyMTIxMzUwL2FhNmNlOTJkNjA0MzlmMmQyYWY4ODc5MzUwZTRjYWU0MTRiN2YyM2IvZG1l
c2ctcXVhbnRhbC1hdGhlbnMtNDg6MjAxNDAyMTMxODM3MTg6aTM4Ni1yYW5kY29uZmlnLWMx
LTAyMTIxMzUwOjMuMTQuMC1yYzItMDE4OTItZ2FhNmNlOTI6MzAKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctYzEtMDIxMjEzNTAvYWE2Y2U5MmQ2MDQzOWYyZDJhZjg4NzkzNTBlNGNhZTQx
NGI3ZjIzYi9kbWVzZy15b2N0by1hdGhlbnMtNDU6MjAxNDAyMTMxODE2Mjc6aTM4Ni1yYW5k
Y29uZmlnLWMxLTAyMTIxMzUwOjMuMTQuMC1yYzItMDE4OTItZ2FhNmNlOTI6MzAKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTAvYWE2Y2U5MmQ2MDQzOWYyZDJhZjg4Nzkz
NTBlNGNhZTQxNGI3ZjIzYi9kbWVzZy1xdWFudGFsLXhpYW4tMToyMDE0MDIxMzE4MTcwNDpp
Mzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTA6My4xNC4wLXJjMi0wMTg5Mi1nYWE2Y2U5Mjoz
MAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC9hYTZjZTkyZDYwNDM5ZjJk
MmFmODg3OTM1MGU0Y2FlNDE0YjdmMjNiL2RtZXNnLXlvY3RvLXhnd28tMzoyMDE0MDIxMzE4
MTczODppMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTA6My4xNC4wLXJjMi0wMTg5Mi1nYWE2
Y2U5MjozMAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC9hYTZjZTkyZDYw
NDM5ZjJkMmFmODg3OTM1MGU0Y2FlNDE0YjdmMjNiL2RtZXNnLXlvY3RvLWF0aGVucy00NToy
MDE0MDIxMzE4MzcxODppMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTA6My4xNC4wLXJjMi0w
MTg5Mi1nYWE2Y2U5MjozMAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC9h
YTZjZTkyZDYwNDM5ZjJkMmFmODg3OTM1MGU0Y2FlNDE0YjdmMjNiL2RtZXNnLXlvY3RvLWF0
aGVucy0xMDoyMDE0MDIxMzE4MTYyNzppMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTA6My4x
NC4wLXJjMi0wMTg5Mi1nYWE2Y2U5MjozMAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0w
MjEyMTM1MC9hYTZjZTkyZDYwNDM5ZjJkMmFmODg3OTM1MGU0Y2FlNDE0YjdmMjNiL2RtZXNn
LXlvY3RvLXhpYW4tNTc6MjAxNDAyMTMxODE3MjE6aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIx
MzUwOjMuMTQuMC1yYzItMDE4OTItZ2FhNmNlOTI6MzAKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctYzEtMDIxMjEzNTAvYWE2Y2U5MmQ2MDQzOWYyZDJhZjg4NzkzNTBlNGNhZTQxNGI3ZjIz
Yi9kbWVzZy1xdWFudGFsLW5obTQtNDoyMDE0MDIxMzE4MTk0NjppMzg2LXJhbmRjb25maWct
YzEtMDIxMjEzNTA6My4xNC4wLXJjMi0wMTg5Mi1nYWE2Y2U5MjozMAova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1jMS0wMjEyMTM1MC9hYTZjZTkyZDYwNDM5ZjJkMmFmODg3OTM1MGU0Y2Fl
NDE0YjdmMjNiL2RtZXNnLXF1YW50YWwtYXRoZW5zLTYzOjIwMTQwMjEzMTgxNzE0OmkzODYt
cmFuZGNvbmZpZy1jMS0wMjEyMTM1MDozLjE0LjAtcmMyLTAxODkyLWdhYTZjZTkyOjMwCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwL2FhNmNlOTJkNjA0MzlmMmQyYWY4
ODc5MzUwZTRjYWU0MTRiN2YyM2IvZG1lc2ctcXVhbnRhbC1iZW5zLTE6MjAxNDAyMTMxODE4
MDY6aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwOjMuMTQuMC1yYzItMDE4OTItZ2FhNmNl
OTI6MzAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTAvYWE2Y2U5MmQ2MDQz
OWYyZDJhZjg4NzkzNTBlNGNhZTQxNGI3ZjIzYi9kbWVzZy1xdWFudGFsLXhpYW4tNDY6MjAx
NDAyMTMxODI1NDQ6aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwOjMuMTQuMC1yYzItMDE4
OTItZ2FhNmNlOTI6MzAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTAvYWE2
Y2U5MmQ2MDQzOWYyZDJhZjg4NzkzNTBlNGNhZTQxNGI3ZjIzYi9kbWVzZy1xdWFudGFsLWF0
aGVucy0zNToyMDE0MDIxMzE4MTc0NzppMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTA6My4x
NC4wLXJjMi0wMTg5Mi1nYWE2Y2U5MjozMAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0w
MjEyMTM1MC9hYTZjZTkyZDYwNDM5ZjJkMmFmODg3OTM1MGU0Y2FlNDE0YjdmMjNiL2RtZXNn
LXF1YW50YWwtamFrZXRvd24tMjY6MjAxNDAyMTMxODM2MDU6aTM4Ni1yYW5kY29uZmlnLWMx
LTAyMTIxMzUwOjMuMTQuMC1yYzItMDE4OTItZ2FhNmNlOTI6MzAKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctYzEtMDIxMjEzNTAvYWE2Y2U5MmQ2MDQzOWYyZDJhZjg4NzkzNTBlNGNhZTQx
NGI3ZjIzYi9kbWVzZy15b2N0by14aWFuLTM6MjAxNDAyMTMxODE1NDM6aTM4Ni1yYW5kY29u
ZmlnLWMxLTAyMTIxMzUwOjMuMTQuMC1yYzItMDE4OTItZ2FhNmNlOTI6MzAKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTAvYWE2Y2U5MmQ2MDQzOWYyZDJhZjg4NzkzNTBl
NGNhZTQxNGI3ZjIzYi9kbWVzZy15b2N0by14aWFuLTQ0OjIwMTQwMjEzMTgxNzAxOmkzODYt
cmFuZGNvbmZpZy1jMS0wMjEyMTM1MDozLjE0LjAtcmMyLTAxODkyLWdhYTZjZTkyOjMwCjA6
MjU6MzggYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCmxpbmVhci1iaXNlY3Q6IGJhZCBi
cmFuY2ggbWF5IGJlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ3dvcmtxdWV1ZXMvZm9yLW5l
eHQnCmxpbmVhci1iaXNlY3Q6IGhhbmRsZSBvdmVyIHRvIGdpdCBiaXNlY3QKbGluZWFyLWJp
c2VjdDogZ2l0IGJpc2VjdCBzdGFydCBhYTZjZTkyZDYwNDM5ZjJkMmFmODg3OTM1MGU0Y2Fl
NDE0YjdmMjNiIGQ2NjQwMmQ5YjYzMzMyNTFhMWY1ZjdmN2ZmZjMzMTliYTk5YjYwMzggLS0K
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgYWE2Y2U5Mi4uLiBNZXJnZSByZW1vdGUtdHJh
Y2tpbmcgYnJhbmNoICd3b3JrcXVldWVzL2Zvci1uZXh0JwpIRUFEIGlzIG5vdyBhdCAzYzBl
ZWUzLi4uIExpbnV4IDIuNi4zNwpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMpCls4NDYwNDM0MGQwMzRhMDc0MDM2ZTg2
ZTg1YzQwNTVhMWM3ZWE1NTI5XSB3b3JrcXVldWU6IEZpeCB3b3JrcXVldWUgbG9ja2RlcCBu
YW1lCmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3QgcnVuIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tL29iai1iaXNlY3QKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dm
Zy9tbS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWctYzEtMDIxMjEzNTAvbmV4dDptYXN0ZXI6ODQ2MDQzNDBkMDM0YTA3NDAz
NmU4NmU4NWM0MDU1YTFjN2VhNTUyOTpiaXNlY3QtbW0KIFRFU1QgRkFJTFVSRQpbICAgMjAu
MTgxMTQ0XSBwYXJpZGU6IGt0dGkgcmVnaXN0ZXJlZCBhcyBwcm90b2NvbCA5ClsgICAyMC4x
ODI1MjddIHBkOiBwZCB2ZXJzaW9uIDEuMDUsIG1ham9yIDQ1LCBjbHVzdGVyIDY0LCBuaWNl
IDAKWyAgIDMzLjE0Njg5NV0gcmFuZG9tOiBub25ibG9ja2luZyBwb29sIGlzIGluaXRpYWxp
emVkClsgIDI1Mi43NjgwNTRdIElORk86IHRhc2sgc3dhcHBlcjoxIGJsb2NrZWQgZm9yIG1v
cmUgdGhhbiAxMjAgc2Vjb25kcy4KWyAgMjUyLjc2OTEyN10gICAgICAgTm90IHRhaW50ZWQg
My4xNC4wLXJjMS0wMDAwMS1nODQ2MDQzNCAjMzEKWyAgMjUyLjc3MDE2NF0gImVjaG8gMCA+
IC9wcm9jL3N5cy9rZXJuZWwvaHVuZ190YXNrX3RpbWVvdXRfc2VjcyIgZGlzYWJsZXMgdGhp
cyBtZXNzYWdlLgpbICAyNTIuNzcxNDY0XSBzd2FwcGVyICAgICAgICAgRCBiMjY3NWEwMSAg
ICAgMCAgICAgMSAgICAgIDAgMHgwMDAwMDAwMApbICAyNTIuNzcyNTgyXSAgYmRjMjllMjQg
MDAwMDAwNDYgYmRjMjYwMDAgYjI2NzVhMDEgMDAwMDAwMDQgYjdhMTIwMDAgYmRjMjYwMDAg
MDAwMDAwMDcKWyAgMjUyLjc3NDE5MV0gIDAwMDAwMDA2IGJkYzI2MDAwIGIyYTAxOTY5IGI3
NDY5NTc0IGJkYzI5ZGY4IGIxMGY5M2U3IDAwMDAwMjU2IGI3NDY5NTljClsgIDI1Mi43NzU2
OTNdICBiZGMyOWUwMCBiMTBmOTQwYyBiZGMyOWUxMCAwMDAwMDI1NiBiNmE5MzEzOCBiNzQ2
OTQzOCBiZGMyOWUyYyBiMTk4ODI0MQpbICAyNTIuNzc3MjkzXSBDYWxsIFRyYWNlOgpbICAy
NTIuNzc3ODA0XSAgWzxiMjY3NWEwMT5dID8gaWdtcF9tY2Zfc2VxX3N0YXJ0KzB4MmRlLzB4
NDAwClsgIDI1Mi43Nzg3NjFdICBbPGIyYTAxOTY5Pl0gPyBfcmF3X3dyaXRlX3VubG9ja19p
cnFyZXN0b3JlKzB4NTcvMHg2OQpbICAyNTIuNzc5ODIwXSAgWzxiMTBmOTNlNz5dID8gdHJh
Y2VfaGFyZGlycXNfb25fY2FsbGVyKzB4MTU1LzB4MTZmClsgIDI1Mi43ODA5MDddICBbPGIx
MGY5NDBjPl0gPyB0cmFjZV9oYXJkaXJxc19vbisweGIvMHhkClsgIDI1Mi43ODE3NzRdICBb
PGIxOTg4MjQxPl0gPyBwYXJwb3J0X2NsYWltKzB4MzBjLzB4MzE5ClsgIDI1Mi43ODI2Mjdd
ICBbPGIyOWZjMDE4Pl0gc2NoZWR1bGUrMHg5Zi8weGExClsgIDI1Mi43ODM0ODZdICBbPGIy
MWI2ZTU1Pl0gcGlfY2xhaW0rMHhjMS8weGQ0ClsgIDI1Mi43ODQyMTFdICBbPGIxMGYwZjE2
Pl0gPyBfX3dha2VfdXBfY29tbW9uKzB4NzcvMHg3NwpbICAyNTIuNzg1MDgyXSAgWzxiMjFi
NmVhYj5dIHBpX3Rlc3RfcHJvdG8rMHgxYi8weDE0ZApbICAyNTIuNzg1ODk3XSAgWzxiMjFi
NzBmOT5dIHBpX3Byb2JlX21vZGUrMHgxMWMvMHgxNmEKWyAgMjUyLjc4NjgyOF0gIFs8YjIx
YjczNWE+XSBwaV9wcm9iZV91bml0KzB4MjEzLzB4MjNmClsgIDI1Mi43ODc2NjBdICBbPGIy
MWI3ODI4Pl0gcGlfaW5pdCsweDI0Yy8weDM0MQpbICAyNTIuNzg4NDM3XSAgWzxiNDE4MjAx
MT5dIHBkX2luaXQrMHgxOGIvMHgzNGQKWyAgMjUyLjc4OTE4MV0gIFs8YjQxODFlODY+XSA/
IGt0dGlfaW5pdCsweGYvMHhmClsgIDI1Mi43ODk5NDNdICBbPGI0MTA1ZWEzPl0gZG9fb25l
X2luaXRjYWxsKzB4ODEvMHgxNzYKWyAgMjUyLjc5MDg2OF0gIFs8YjQxMDU1MDA+XSA/IHJl
cGFpcl9lbnZfc3RyaW5nKzB4My8weDlkClsgIDI1Mi43OTE3NDBdICBbPGIxMGQxZGVlPl0g
PyBwYXJzZV9hcmdzKzB4MmU4LzB4M2ExClsgIDI1Mi43OTI1NDhdICBbPGI0MTA2MTNmPl0g
a2VybmVsX2luaXRfZnJlZWFibGUrMHgxYTcvMHgyNmQKWyAgMjUyLjc5MzU4NV0gIFs8YjI5
YTMwZTA+XSBrZXJuZWxfaW5pdCsweGUvMHgxNWMKWyAgMjUyLjc5NDM1NF0gIFs8YjJhMDI2
ZGI+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MWIvMHgzMApbICAyNTIuNzk1MjgyXSAg
WzxiMjlhMzBkMj5dID8gcmVzdF9pbml0KzB4MTMxLzB4MTMxClsgIDI1Mi43OTYwODJdIG5v
IGxvY2tzIGhlbGQgYnkgc3dhcHBlci8xLgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0w
MjEyMTM1MC84NDYwNDM0MGQwMzRhMDc0MDM2ZTg2ZTg1YzQwNTVhMWM3ZWE1NTI5L2RtZXNn
LXF1YW50YWwteGlhbi00NToyMDE0MDIxMzE5MDQyNzppMzg2LXJhbmRjb25maWctYzEtMDIx
MjEzNTA6My4xNC4wLXJjMS0wMDAwMS1nODQ2MDQzNDozMQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1jMS0wMjEyMTM1MC84NDYwNDM0MGQwMzRhMDc0MDM2ZTg2ZTg1YzQwNTVhMWM3ZWE1
NTI5L2RtZXNnLXF1YW50YWwtcm9hbS00NDoyMDE0MDIxMzE4NTQwODppMzg2LXJhbmRjb25m
aWctYzEtMDIxMjEzNTA6My4xNC4wLXJjMS0wMDAwMS1nODQ2MDQzNDozMQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC84NDYwNDM0MGQwMzRhMDc0MDM2ZTg2ZTg1YzQw
NTVhMWM3ZWE1NTI5L2RtZXNnLXF1YW50YWwteGd3by02OjIwMTQwMjEzMTkwODMyOmkzODYt
cmFuZGNvbmZpZy1jMS0wMjEyMTM1MDozLjE0LjAtcmMxLTAwMDAxLWc4NDYwNDM0OjMxCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwLzg0NjA0MzQwZDAzNGEwNzQwMzZl
ODZlODVjNDA1NWExYzdlYTU1MjkvZG1lc2ctcXVhbnRhbC1yb2FtLTU1OjIwMTQwMjEzMTg1
NDU3OmkzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MDozLjE0LjAtcmMxLTAwMDAxLWc4NDYw
NDM0OjMxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwLzg0NjA0MzQwZDAz
NGEwNzQwMzZlODZlODVjNDA1NWExYzdlYTU1MjkvZG1lc2cteW9jdG8taW5uLTQ1OjIwMTQw
MjEzMTkwNDUyOmkzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MDozLjE0LjAtcmMxLTAwMDAx
LWc4NDYwNDM0OjMxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwLzg0NjA0
MzQwZDAzNGEwNzQwMzZlODZlODVjNDA1NWExYzdlYTU1MjkvZG1lc2ctcXVhbnRhbC1pbm4t
Mjg6MjAxNDAyMTMxOTA0NTc6aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwOjMuMTQuMC1y
YzEtMDAwMDEtZzg0NjA0MzQ6MzEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDIxMjEz
NTAvODQ2MDQzNDBkMDM0YTA3NDAzNmU4NmU4NWM0MDU1YTFjN2VhNTUyOS9kbWVzZy1xdWFu
dGFsLXhpYW4tOToyMDE0MDIxMzE5MDQyNzppMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTA6
My4xNC4wLXJjMS0wMDAwMS1nODQ2MDQzNDozMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1j
MS0wMjEyMTM1MC84NDYwNDM0MGQwMzRhMDc0MDM2ZTg2ZTg1YzQwNTVhMWM3ZWE1NTI5L2Rt
ZXNnLXF1YW50YWwteHBzLTM6MjAxNDAyMTMxOTA4MzI6aTM4Ni1yYW5kY29uZmlnLWMxLTAy
MTIxMzUwOjMuMTQuMC1yYzEtMDAwMDEtZzg0NjA0MzQ6MzEKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYzEtMDIxMjEzNTAvODQ2MDQzNDBkMDM0YTA3NDAzNmU4NmU4NWM0MDU1YTFjN2Vh
NTUyOS9kbWVzZy1xdWFudGFsLWlubi00OjIwMTQwMjEzMTkwNTAzOmkzODYtcmFuZGNvbmZp
Zy1jMS0wMjEyMTM1MDozLjE0LjAtcmMxLTAwMDAxLWc4NDYwNDM0OjMxCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwLzg0NjA0MzQwZDAzNGEwNzQwMzZlODZlODVjNDA1
NWExYzdlYTU1MjkvZG1lc2cteW9jdG8teGd3by0yOjIwMTQwMjEzMTg1NTU0OmkzODYtcmFu
ZGNvbmZpZy1jMS0wMjEyMTM1MDozLjE0LjAtcmMxLTAwMDAxLWc4NDYwNDM0OjMxCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwLzg0NjA0MzQwZDAzNGEwNzQwMzZlODZl
ODVjNDA1NWExYzdlYTU1MjkvZG1lc2ctcXVhbnRhbC1pbm4tMTQ6MjAxNDAyMTMxOTA4MTU6
aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwOjMuMTQuMC1yYzEtMDAwMDEtZzg0NjA0MzQ6
MzEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTAvODQ2MDQzNDBkMDM0YTA3
NDAzNmU4NmU4NWM0MDU1YTFjN2VhNTUyOS9kbWVzZy1xdWFudGFsLWlubi0yMToyMDE0MDIx
MzE5MDA0MTppMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTA6My4xNC4wLXJjMS0wMDAwMS1n
ODQ2MDQzNDozMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC84NDYwNDM0
MGQwMzRhMDc0MDM2ZTg2ZTg1YzQwNTVhMWM3ZWE1NTI5L2RtZXNnLXlvY3RvLWlubi00MToy
MDE0MDIxMzE5MDIwODppMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTA6My4xNC4wLXJjMS0w
MDAwMS1nODQ2MDQzNDozMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC84
NDYwNDM0MGQwMzRhMDc0MDM2ZTg2ZTg1YzQwNTVhMWM3ZWE1NTI5L2RtZXNnLXlvY3RvLWlu
bi04OjIwMTQwMjEzMTkwNTAzOmkzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MDozLjE0LjAt
cmMxLTAwMDAxLWc4NDYwNDM0OjMxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIx
MzUwLzg0NjA0MzQwZDAzNGEwNzQwMzZlODZlODVjNDA1NWExYzdlYTU1MjkvZG1lc2cteW9j
dG8tYmVucy0xOjIwMTQwMjEzMTg1NjA5OmkzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MDoz
LjE0LjAtcmMxLTAwMDAxLWc4NDYwNDM0OjMxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMx
LTAyMTIxMzUwLzg0NjA0MzQwZDAzNGEwNzQwMzZlODZlODVjNDA1NWExYzdlYTU1MjkvZG1l
c2cteW9jdG8tcm9hbS0xNjoyMDE0MDIxMzE5MDc1NzppMzg2LXJhbmRjb25maWctYzEtMDIx
MjEzNTA6My4xNC4wLXJjMS0wMDAwMS1nODQ2MDQzNDozMQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1jMS0wMjEyMTM1MC84NDYwNDM0MGQwMzRhMDc0MDM2ZTg2ZTg1YzQwNTVhMWM3ZWE1
NTI5L2RtZXNnLXlvY3RvLWlubi0xOToyMDE0MDIxMzE5MDQ1NzppMzg2LXJhbmRjb25maWct
YzEtMDIxMjEzNTA6My4xNC4wLXJjMS0wMDAwMS1nODQ2MDQzNDozMQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1jMS0wMjEyMTM1MC84NDYwNDM0MGQwMzRhMDc0MDM2ZTg2ZTg1YzQwNTVh
MWM3ZWE1NTI5L2RtZXNnLXlvY3RvLWlubi00OjIwMTQwMjEzMTkwMjIyOmkzODYtcmFuZGNv
bmZpZy1jMS0wMjEyMTM1MDozLjE0LjAtcmMxLTAwMDAxLWc4NDYwNDM0OjMxCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwLzg0NjA0MzQwZDAzNGEwNzQwMzZlODZlODVj
NDA1NWExYzdlYTU1MjkvZG1lc2ctcXVhbnRhbC14aWFuLTE2OjIwMTQwMjEzMTg1MDE0Omkz
ODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MDozLjE0LjAtcmMxLTAwMDAxLWc4NDYwNDM0OjMx
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwLzg0NjA0MzQwZDAzNGEwNzQw
MzZlODZlODVjNDA1NWExYzdlYTU1MjkvZG1lc2cteW9jdG8taW5uLTQ0OjIwMTQwMjEzMTkw
ODE1OmkzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MDozLjE0LjAtcmMxLTAwMDAxLWc4NDYw
NDM0OjMxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwLzg0NjA0MzQwZDAz
NGEwNzQwMzZlODZlODVjNDA1NWExYzdlYTU1MjkvZG1lc2cteW9jdG8teGlhbi0xNjoyMDE0
MDIxMzE5MDg1MTppMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTA6My4xNC4wLXJjMS0wMDAw
MS1nODQ2MDQzNDozMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC84NDYw
NDM0MGQwMzRhMDc0MDM2ZTg2ZTg1YzQwNTVhMWM3ZWE1NTI5L2RtZXNnLXF1YW50YWwtaW5u
LTE0OjIwMTQwMjEzMTkwMDQxOmkzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MDozLjE0LjAt
cmMxLTAwMDAxLWc4NDYwNDM0OjMxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIx
MzUwLzg0NjA0MzQwZDAzNGEwNzQwMzZlODZlODVjNDA1NWExYzdlYTU1MjkvZG1lc2ctcXVh
bnRhbC1qYWtldG93bi0zOjIwMTQwMjEzMTkxMTA5OmkzODYtcmFuZGNvbmZpZy1jMS0wMjEy
MTM1MDozLjE0LjAtcmMxLTAwMDAxLWc4NDYwNDM0OjMxCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWMxLTAyMTIxMzUwLzg0NjA0MzQwZDAzNGEwNzQwMzZlODZlODVjNDA1NWExYzdlYTU1
MjkvZG1lc2cteW9jdG8taW5uLTQ3OjIwMTQwMjEzMTg1NTA1OmkzODYtcmFuZGNvbmZpZy1j
MS0wMjEyMTM1MDozLjE0LjAtcmMxLTAwMDAxLWc4NDYwNDM0OjMxCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWMxLTAyMTIxMzUwLzg0NjA0MzQwZDAzNGEwNzQwMzZlODZlODVjNDA1NWEx
YzdlYTU1MjkvZG1lc2cteW9jdG8tc25iLTI2OjIwMTQwMjEzMTkzNjAyOmkzODYtcmFuZGNv
bmZpZy1jMS0wMjEyMTM1MDozLjE0LjAtcmMxLTAwMDAxLWc4NDYwNDM0OjMxCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwLzg0NjA0MzQwZDAzNGEwNzQwMzZlODZlODVj
NDA1NWExYzdlYTU1MjkvZG1lc2ctcXVhbnRhbC14aWFuLTY6MjAxNDAyMTMxOTA0Mjc6aTM4
Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwOjMuMTQuMC1yYzEtMDAwMDEtZzg0NjA0MzQ6MzEK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTAvODQ2MDQzNDBkMDM0YTA3NDAz
NmU4NmU4NWM0MDU1YTFjN2VhNTUyOS9kbWVzZy15b2N0by1pbm4tMzQ6MjAxNDAyMTMxOTAw
NDE6aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwOjMuMTQuMC1yYzEtMDAwMDEtZzg0NjA0
MzQ6MzEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTAvODQ2MDQzNDBkMDM0
YTA3NDAzNmU4NmU4NWM0MDU1YTFjN2VhNTUyOS9kbWVzZy1xdWFudGFsLWJlbnMtMToyMDE0
MDIxMzE5MDEzNjppMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTA6My4xNC4wLXJjMS0wMDAw
MS1nODQ2MDQzNDozMQowOjI4OjM5IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgo4NDYw
NDM0MGQwMzRhMDc0MDM2ZTg2ZTg1YzQwNTVhMWM3ZWE1NTI5IGlzIHRoZSBmaXJzdCBiYWQg
Y29tbWl0CmNvbW1pdCA4NDYwNDM0MGQwMzRhMDc0MDM2ZTg2ZTg1YzQwNTVhMWM3ZWE1NTI5
CkF1dGhvcjogUGV0ZXIgWmlqbHN0cmEgPHBldGVyekBpbmZyYWRlYWQub3JnPgpEYXRlOiAg
IFR1ZSBGZWIgMTEgMTI6MDA6MzYgMjAxNCArMDEwMAoKICAgIHdvcmtxdWV1ZTogRml4IHdv
cmtxdWV1ZSBsb2NrZGVwIG5hbWUKICAgIAogICAgVG9tbWkgbm90aWNlZCBhICdmdW5ueScg
bG9jayBjbGFzcyBuYW1lOiAiJXMjNSIgZnJvbSBhIGxvY2sgYWNxdWlyZWQKICAgIGluIHBy
b2Nlc3Nfb25lX3dvcmsoKS4gSXQgdHVybnMgb3V0IHRoYXQgY29tbWl0IGIxOTZiZTg5Y2Rj
MTQgZm9yZ290CiAgICB0byBjaGFuZ2UgdGhlIGxvY2tkZXBfaW5pdF9tYXAoKSB3aGVuIGl0
IGNoYW5nZWQgdGhlIEBsb2NrX25hbWUKICAgIGFyZ3VtZW50IGZyb20gYSBzdHJpbmcgdG8g
YSBmb3JtYXQuCiAgICAKICAgIEZpeGVzOiBiMTk2YmU4OWNkYzE0ICgid29ya3F1ZXVlOiBt
YWtlIGFsbG9jX3dvcmtxdWV1ZSgpIHRha2UgcHJpbnRmCiAgICBmbXQgYW5kIGFyZ3MgZm9y
IG5hbWUiKQogICAgCiAgICBSZXBvcnRlZC1ieTogVG9tbWkgUmFudGFsYSA8dHQucmFudGFs
YUBnbWFpbC5jb20+CiAgICBTaWduZWQtb2ZmLWJ5OiBQZXRlciBaaWpsc3RyYSA8cGV0ZXJ6
QGluZnJhZGVhZC5vcmc+CiAgICBTaWduZWQtb2ZmLWJ5OiBUZWp1biBIZW8gPHRqQGtlcm5l
bC5vcmc+CiAgICBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZwoKOjA0MDAwMCAwNDAwMDAg
M2U3YWRjYmMzMzVlMjJhNjAwNDQyOTEzZjA2ZDQ3ZGY5ZTFhMjI4YyBiNTZjMGY3OTlkYzky
MTY3N2RiODg4ZTBkYzA1OWRmZDUwNmUyYzNmIE0Ja2VybmVsCmJpc2VjdCBydW4gc3VjY2Vz
cwpleGl0Ci9jL2tlcm5lbC10ZXN0cy9saW5lYXItYmlzZWN0OjE2MzppbiBgZXhpdCcKL2Mv
a2VybmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6MTYzOmluIGBnaXRfYmlzZWN0JwovYy9rZXJu
ZWwtdGVzdHMvbGluZWFyLWJpc2VjdDoyOTA6aW4gYGxpbmVhcl9iaXNlY3QnCi9jL2tlcm5l
bC10ZXN0cy9saW5lYXItYmlzZWN0OjI5NDppbiBgPG1haW4+JwpleGl0Ci9jL2tlcm5lbC10
ZXN0cy9saW5lYXItYmlzZWN0OjE2MzppbiBgZXhpdCcKL2Mva2VybmVsLXRlc3RzL2xpbmVh
ci1iaXNlY3Q6MTYzOmluIGBnaXRfYmlzZWN0JwovYy9rZXJuZWwtdGVzdHMvbGluZWFyLWJp
c2VjdDoyOTA6aW4gYGxpbmVhcl9iaXNlY3QnCi9jL2tlcm5lbC10ZXN0cy9saW5lYXItYmlz
ZWN0OjI5NDppbiBgPG1haW4+JwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwL25leHQ6bWFzdGVyOjM4ZGJmYjU5ZDExNzVl
ZjQ1OGQwMDY1NTYwNjFhZGVhYTg3NTFiNzI6YmlzZWN0LW1tCgoyMDE0LTAyLTE1LTE5OjMy
OjEwIDM4ZGJmYjU5ZDExNzVlZjQ1OGQwMDY1NTYwNjFhZGVhYTg3NTFiNzIgcmV1c2UgL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTAvMzhkYmZiNTlkMTE3NWVmNDU4ZDAw
NjU1NjA2MWFkZWFhODc1MWI3Mi92bWxpbnV6LTMuMTQuMC1yYzEKCjIwMTQtMDItMTUtMTk6
MzI6MTAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4JMQk0CTYuCTcuLi4uLi4uCTgu
Li4JMTAJMTIJMTcJMjAJMjIuCTIzLgkyNQkyNy4uCTI5CTM0Li4uCTM2Li4JMzcuLi4uLi4u
Li4uLi4uLi4uLi4uLi4uCTM5Li4uCTQyCTQzLi4JNDQuLgk0NQk0Ngk0Nwk0OQk1MC4JNTQJ
NTYJNTguCTYwLi4JNjEuCTYyLi4JNjMJNjQuCTcyLgk3OS4JODIuCTg0Lgk4Nwk4OQk5MC4u
Li4uLi4uLi4uLgk5MS4JOTMgU1VDQ0VTUwoKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC9uZXh0Om1hc3Rlcjo0NjAyMTc1
ODNjOTM0MTEwODY1YTJmNWRjZTVlMWI1Yzk4ODM1YTQ2OmJpc2VjdC1tbQogVEVTVCBGQUlM
VVJFClsgICAzMC40MzQyMjJdIHBhcmlkZToga3R0aSByZWdpc3RlcmVkIGFzIHByb3RvY29s
IDkKWyAgIDMwLjQzODU1OF0gcGQ6IHBkIHZlcnNpb24gMS4wNSwgbWFqb3IgNDUsIGNsdXN0
ZXIgNjQsIG5pY2UgMApbICAgNDAuMjUwMjY5XSByYW5kb206IG5vbmJsb2NraW5nIHBvb2wg
aXMgaW5pdGlhbGl6ZWQKWyAgMjQwLjQwNDMyNF0gSU5GTzogdGFzayBzd2FwcGVyOjEgYmxv
Y2tlZCBmb3IgbW9yZSB0aGFuIDEyMCBzZWNvbmRzLgpbICAyNDAuNDA1NDYyXSAgICAgICBO
b3QgdGFpbnRlZCAzLjE0LjAtcmMyLW5leHQtMjAxNDAyMTItMDIzMDktZzQ2MDIxNzUgIzMK
WyAgMjQwLjQwNjY0NF0gImVjaG8gMCA+IC9wcm9jL3N5cy9rZXJuZWwvaHVuZ190YXNrX3Rp
bWVvdXRfc2VjcyIgZGlzYWJsZXMgdGhpcyBtZXNzYWdlLgpbICAyNDAuNDA4MTc1XSBzd2Fw
cGVyICAgICAgICAgRCAxM2YxNzcwMSAgICAgMCAgICAgMSAgICAgIDAgMHgwMDAwMDAwMApb
ICAyNDAuNDA5NjI4XSAgYzFjNDVlMjQgMDAwMDAwNDYgYzFjMmUwMDAgMTNmMTc3MDEgMDAw
MDAwMDcgYzFjNGEwMDAgYzFjMmUwMDAgMDAwMDAwMDcKWyAgMjQwLjQxMjAwNl0gIDAwMDAw
MDA2IGMxYzJlMDAwIGIyYTFjOGQ5IGJiNGUyN2Q0IGMxYzQ1ZGY4IGIxMGY5MmQwIDAwMDAw
MjQ2IGJiNGUyN2ZjClsgIDI0MC40MTM3NTldICBjMWM0NWUwMCBiMTBmOTJmNSBjMWM0NWUx
MCAwMDAwMDI0NiBiYWIxMzgzOCBiYjRlMjY5OCBjMWM0NWUyYyBiMTk4MWQ3MgpbICAyNDAu
NDE1MDI0XSBDYWxsIFRyYWNlOgpbICAyNDAuNDE1NDE2XSAgWzxiMmExYzhkOT5dID8gX3Jh
d193cml0ZV91bmxvY2tfaXJxcmVzdG9yZSsweDU3LzB4NjkKWyAgMjQwLjQxNjE5Ml0gIFs8
YjEwZjkyZDA+XSA/IHRyYWNlX2hhcmRpcnFzX29uX2NhbGxlcisweDE1NS8weDE2ZgpbICAy
NDAuNDE3MDQyXSAgWzxiMTBmOTJmNT5dID8gdHJhY2VfaGFyZGlycXNfb24rMHhiLzB4ZApb
ICAyNDAuNDE3NjMzXSAgWzxiMTk4MWQ3Mj5dID8gcGFycG9ydF9jbGFpbSsweDMwYy8weDMx
OQpbICAyNDAuNDE4MTk3XSAgWzxiMmExNmY4Yj5dIHNjaGVkdWxlKzB4OWYvMHhhMQpbICAy
NDAuNDE4Njk3XSAgWzxiMjFjZTdhMT5dIHBpX2NsYWltKzB4YzEvMHhkNApbICAyNDAuNDE5
MTg0XSAgWzxiMTBmMGRmZj5dID8gX193YWtlX3VwX2NvbW1vbisweDc3LzB4NzcKWyAgMjQw
LjQxOTc2NF0gIFs8YjIxY2U3Zjc+XSBwaV90ZXN0X3Byb3RvKzB4MWIvMHgxNGQKWyAgMjQw
LjQyMDUwN10gIFs8YjIxY2VhNDU+XSBwaV9wcm9iZV9tb2RlKzB4MTFjLzB4MTZhClsgIDI0
MC40MjEyNzNdICBbPGIyMWNlY2E2Pl0gcGlfcHJvYmVfdW5pdCsweDIxMy8weDIzZgpbICAy
NDAuNDIxOTY0XSAgWzxiMjFjZjE3ND5dIHBpX2luaXQrMHgyNGMvMHgzNDEKWyAgMjQwLjQy
MjUwNF0gIFs8YjQxZGNkZjQ+XSBwZF9pbml0KzB4MThiLzB4MzRkClsgIDI0MC40MjMwMDJd
ICBbPGI0MWRjYzY5Pl0gPyBrdHRpX2luaXQrMHhmLzB4ZgpbICAyNDAuNDIzNzQ4XSAgWzxi
NDE1ZmVhMz5dIGRvX29uZV9pbml0Y2FsbCsweDgxLzB4MTc2ClsgIDI0MC40MjQzNDVdICBb
PGIxMGY5MmQwPl0gPyB0cmFjZV9oYXJkaXJxc19vbl9jYWxsZXIrMHgxNTUvMHgxNmYKWyAg
MjQwLjQyNTYwM10gIFs8YjE3ZGNkZGU+XSA/IHRyYWNlX2hhcmRpcnFzX29uX3RodW5rKzB4
Yy8weDEwClsgIDI0MC40MjY2MDhdICBbPGIyYTFkMDY1Pl0gPyByZXN0b3JlX2FsbCsweGYv
MHhmClsgIDI0MC40Mjc2ODZdICBbPGI0MTYwMTNmPl0ga2VybmVsX2luaXRfZnJlZWFibGUr
MHgxYTcvMHgyNmQKWyAgMjQwLjQyODc4NF0gIFs8YjI5YmUxMDA+XSBrZXJuZWxfaW5pdCsw
eGUvMHgxM2UKWyAgMjQwLjQyOTU3NF0gIFs8YjJhMWQ2M2I+XSByZXRfZnJvbV9rZXJuZWxf
dGhyZWFkKzB4MWIvMHgzMApbICAyNDAuNDMwNzE0XSAgWzxiMjliZTBmMj5dID8gcmVzdF9p
bml0KzB4MTMxLzB4MTMxClsgIDI0MC40MzE1ODFdIG5vIGxvY2tzIGhlbGQgYnkgc3dhcHBl
ci8xLgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC80NjAyMTc1ODNjOTM0
MTEwODY1YTJmNWRjZTVlMWI1Yzk4ODM1YTQ2L2RtZXNnLXlvY3RvLWNhaXJvLTc6MjAxNDAy
MTIxNDMxNDY6aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwOjMuMTQuMC1yYzItbmV4dC0y
MDE0MDIxMi0wMjMwOS1nNDYwMjE3NTozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTAy
MTIxMzUwLzQ2MDIxNzU4M2M5MzQxMTA4NjVhMmY1ZGNlNWUxYjVjOTg4MzVhNDYvZG1lc2ct
cXVhbnRhbC1zbmItMjE6MjAxNDAyMTIxNTAxNDI6aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIx
MzUwOjMuMTQuMC1yYzItbmV4dC0yMDE0MDIxMi0wMjMwOS1nNDYwMjE3NTozCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwLzQ2MDIxNzU4M2M5MzQxMTA4NjVhMmY1ZGNl
NWUxYjVjOTg4MzVhNDYvZG1lc2cteW9jdG8teGlhbi0yOjIwMTQwMjE1MTIyMTE0OmkzODYt
cmFuZGNvbmZpZy1jMS0wMjEyMTM1MDozLjE0LjAtcmMyLW5leHQtMjAxNDAyMTItMDIzMDkt
ZzQ2MDIxNzU6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC80NjAyMTc1
ODNjOTM0MTEwODY1YTJmNWRjZTVlMWI1Yzk4ODM1YTQ2L2RtZXNnLXlvY3RvLXhpYW4tNTY6
MjAxNDAyMTMwNzU0MTU6aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwOjMuMTQuMC1yYzIt
bmV4dC0yMDE0MDIxMi0wMjMwOS1nNDYwMjE3NTozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWMxLTAyMTIxMzUwLzQ2MDIxNzU4M2M5MzQxMTA4NjVhMmY1ZGNlNWUxYjVjOTg4MzVhNDYv
ZG1lc2cteW9jdG8teGlhbi0xOjIwMTQwMjEzMDc1NDE2OmkzODYtcmFuZGNvbmZpZy1jMS0w
MjEyMTM1MDozLjE0LjAtcmMyLW5leHQtMjAxNDAyMTItMDIzMDktZzQ2MDIxNzU6Mwova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC80NjAyMTc1ODNjOTM0MTEwODY1YTJm
NWRjZTVlMWI1Yzk4ODM1YTQ2L2RtZXNnLXF1YW50YWwteGlhbi0xOjIwMTQwMjEzMDc1NDE2
OmkzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MDozLjE0LjAtcmMyLW5leHQtMjAxNDAyMTIt
MDIzMDktZzQ2MDIxNzU6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC80
NjAyMTc1ODNjOTM0MTEwODY1YTJmNWRjZTVlMWI1Yzk4ODM1YTQ2L2RtZXNnLXlvY3RvLWF0
aGVucy04OjIwMTQwMjEyMTQzMzE2OmkzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MDozLjE0
LjAtcmMyLW5leHQtMjAxNDAyMTItMDIzMDktZzQ2MDIxNzU6Mwova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1jMS0wMjEyMTM1MC80NjAyMTc1ODNjOTM0MTEwODY1YTJmNWRjZTVlMWI1Yzk4
ODM1YTQ2L2RtZXNnLXF1YW50YWwtamFrZXRvd24tNDoyMDE0MDIxMjE0MzcxMjppMzg2LXJh
bmRjb25maWctYzEtMDIxMjEzNTA6My4xNC4wLXJjMi1uZXh0LTIwMTQwMjEyLTAyMzA5LWc0
NjAyMTc1OjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTAvNDYwMjE3NTgz
YzkzNDExMDg2NWEyZjVkY2U1ZTFiNWM5ODgzNWE0Ni9kbWVzZy15b2N0by1hdGhlbnMtMzE6
MjAxNDAyMTUxMjIxMjY6aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwOjMuMTQuMC1yYzIt
bmV4dC0yMDE0MDIxMi0wMjMwOS1nNDYwMjE3NTozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWMxLTAyMTIxMzUwLzQ2MDIxNzU4M2M5MzQxMTA4NjVhMmY1ZGNlNWUxYjVjOTg4MzVhNDYv
ZG1lc2ctcXVhbnRhbC14aWFuLTMzOjIwMTQwMjEzMDc1NDE2OmkzODYtcmFuZGNvbmZpZy1j
MS0wMjEyMTM1MDozLjE0LjAtcmMyLW5leHQtMjAxNDAyMTItMDIzMDktZzQ2MDIxNzU6Mwov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC80NjAyMTc1ODNjOTM0MTEwODY1
YTJmNWRjZTVlMWI1Yzk4ODM1YTQ2L2RtZXNnLXF1YW50YWwteGlhbi02MDoyMDE0MDIxMzA3
NTQxNTppMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTA6My4xNC4wLXJjMi1uZXh0LTIwMTQw
MjEyLTAyMzA5LWc0NjAyMTc1OjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDIxMjEz
NTAvNDYwMjE3NTgzYzkzNDExMDg2NWEyZjVkY2U1ZTFiNWM5ODgzNWE0Ni9kbWVzZy1xdWFu
dGFsLXhpYW4tMzoyMDE0MDIxMzA3NTQxOTppMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTA6
My4xNC4wLXJjMi1uZXh0LTIwMTQwMjEyLTAyMzA5LWc0NjAyMTc1OjMKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYzEtMDIxMjEzNTAvNDYwMjE3NTgzYzkzNDExMDg2NWEyZjVkY2U1ZTFi
NWM5ODgzNWE0Ni9kbWVzZy15b2N0by1yb2FtLTI0OjIwMTQwMjE1MTIyODAxOmkzODYtcmFu
ZGNvbmZpZy1jMS0wMjEyMTM1MDozLjE0LjAtcmMyLW5leHQtMjAxNDAyMTItMDIzMDktZzQ2
MDIxNzU6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC80NjAyMTc1ODNj
OTM0MTEwODY1YTJmNWRjZTVlMWI1Yzk4ODM1YTQ2L2RtZXNnLXlvY3RvLXN0b2FrbGV5LTc6
MjAxNDAyMTUxMjM2MjQ6aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwOjMuMTQuMC1yYzIt
bmV4dC0yMDE0MDIxMi0wMjMwOS1nNDYwMjE3NTozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWMxLTAyMTIxMzUwLzQ2MDIxNzU4M2M5MzQxMTA4NjVhMmY1ZGNlNWUxYjVjOTg4MzVhNDYv
ZG1lc2cteW9jdG8tY2Fpcm8tOToyMDE0MDIxMjE0MzE0NjppMzg2LXJhbmRjb25maWctYzEt
MDIxMjEzNTA6My4xNC4wLXJjMi1uZXh0LTIwMTQwMjEyLTAyMzA5LWc0NjAyMTc1OjMKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTAvNDYwMjE3NTgzYzkzNDExMDg2NWEy
ZjVkY2U1ZTFiNWM5ODgzNWE0Ni9kbWVzZy15b2N0by1pbm4tMTQ6MjAxNDAyMTIxNDI4MDk6
aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwOjMuMTQuMC1yYzItbmV4dC0yMDE0MDIxMi0w
MjMwOS1nNDYwMjE3NTozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwLzQ2
MDIxNzU4M2M5MzQxMTA4NjVhMmY1ZGNlNWUxYjVjOTg4MzVhNDYvZG1lc2cteW9jdG8taW5u
LTM2OjIwMTQwMjEyMTQyODM0OmkzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MDozLjE0LjAt
cmMyLW5leHQtMjAxNDAyMTItMDIzMDktZzQ2MDIxNzU6Mwova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1jMS0wMjEyMTM1MC80NjAyMTc1ODNjOTM0MTEwODY1YTJmNWRjZTVlMWI1Yzk4ODM1
YTQ2L2RtZXNnLXF1YW50YWwteGlhbi05OjIwMTQwMjEzMDc1NDE2OmkzODYtcmFuZGNvbmZp
Zy1jMS0wMjEyMTM1MDozLjE0LjAtcmMyLW5leHQtMjAxNDAyMTItMDIzMDktZzQ2MDIxNzU6
Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC80NjAyMTc1ODNjOTM0MTEw
ODY1YTJmNWRjZTVlMWI1Yzk4ODM1YTQ2L2RtZXNnLXF1YW50YWwtcm9hbS0zNjoyMDE0MDIx
NTEyMzMwNTppMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTA6My4xNC4wLXJjMi1uZXh0LTIw
MTQwMjEyLTAyMzA5LWc0NjAyMTc1OjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDIx
MjEzNTAvNDYwMjE3NTgzYzkzNDExMDg2NWEyZjVkY2U1ZTFiNWM5ODgzNWE0Ni9kbWVzZy1x
dWFudGFsLWF0aGVucy0zNzoyMDE0MDIxNTEyMjE0OTppMzg2LXJhbmRjb25maWctYzEtMDIx
MjEzNTA6My4xNC4wLXJjMi1uZXh0LTIwMTQwMjEyLTAyMzA5LWc0NjAyMTc1OjMKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTAvNDYwMjE3NTgzYzkzNDExMDg2NWEyZjVk
Y2U1ZTFiNWM5ODgzNWE0Ni9kbWVzZy15b2N0by1zdG9ha2xleS00OjIwMTQwMjEyMTQzNDE0
OmkzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MDozLjE0LjAtcmMyLW5leHQtMjAxNDAyMTIt
MDIzMDktZzQ2MDIxNzU6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC80
NjAyMTc1ODNjOTM0MTEwODY1YTJmNWRjZTVlMWI1Yzk4ODM1YTQ2L2RtZXNnLXF1YW50YWwt
Y2Fpcm8tNjI6MjAxNDAyMTMwNzUzMzg6aTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwOjMu
MTQuMC1yYzItbmV4dC0yMDE0MDIxMi0wMjMwOS1nNDYwMjE3NTozCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWMxLTAyMTIxMzUwLzQ2MDIxNzU4M2M5MzQxMTA4NjVhMmY1ZGNlNWUxYjVj
OTg4MzVhNDYvZG1lc2ctcXVhbnRhbC14aWFuLTQ2OjIwMTQwMjEzMDc1NDE1OmkzODYtcmFu
ZGNvbmZpZy1jMS0wMjEyMTM1MDozLjE0LjAtcmMyLW5leHQtMjAxNDAyMTItMDIzMDktZzQ2
MDIxNzU6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC80NjAyMTc1ODNj
OTM0MTEwODY1YTJmNWRjZTVlMWI1Yzk4ODM1YTQ2L2RtZXNnLXF1YW50YWwtaW5uLTE0OjIw
MTQwMjEyMTQyODE4OmkzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MDozLjE0LjAtcmMyLW5l
eHQtMjAxNDAyMTItMDIzMDktZzQ2MDIxNzU6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1j
MS0wMjEyMTM1MC80NjAyMTc1ODNjOTM0MTEwODY1YTJmNWRjZTVlMWI1Yzk4ODM1YTQ2L2Rt
ZXNnLXF1YW50YWwtY2Fpcm8tNjA6MjAxNDAyMTMwNzUzMzg6aTM4Ni1yYW5kY29uZmlnLWMx
LTAyMTIxMzUwOjMuMTQuMC1yYzItbmV4dC0yMDE0MDIxMi0wMjMwOS1nNDYwMjE3NTozCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTAyMTIxMzUwLzQ2MDIxNzU4M2M5MzQxMTA4NjVh
MmY1ZGNlNWUxYjVjOTg4MzVhNDYvZG1lc2cteW9jdG8teGlhbi01MDoyMDE0MDIxNTEyMzYz
NTppMzg2LXJhbmRjb25maWctYzEtMDIxMjEzNTA6My4xNC4wLXJjMi1uZXh0LTIwMTQwMjEy
LTAyMzA5LWc0NjAyMTc1OjMKMDoyNjoyOSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoK
W2RldGFjaGVkIEhFQUQgNWFmMjVmY10gUmV2ZXJ0ICJ3b3JrcXVldWU6IEZpeCB3b3JrcXVl
dWUgbG9ja2RlcCBuYW1lIgogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRl
bGV0aW9uKC0pCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWctYzEtMDIxMjEzNTAvbmV4dDptYXN0ZXI6NWFmMjVmY2M0Mzg0ZGY5ZTU1NThmNDZi
YjkzZmNhM2UwZDc2MGE5NzpiaXNlY3QtbW0KCjIwMTQtMDItMTUtMjA6MzU6MTAgNWFmMjVm
Y2M0Mzg0ZGY5ZTU1NThmNDZiYjkzZmNhM2UwZDc2MGE5NyBjb21waWxpbmcKCjIwMTQtMDIt
MTUtMjA6NDQ6MzUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjMi1uZXh0LTIwMTQw
MjEyLTAwMDAxLWc1YWYyNWZjLi4uLi4uLi4uCTEuLi4JMgk1Lgk4CTEwCTEzLgkyNC4uCTI1
CTI5CTMxCTQ0CTQ2CTU4CTgyLi4uLi4uCTg5CTkzIFNVQ0NFU1MKCgo9PT09PT09PT0gdXBz
dHJlYW0gPT09PT09PT09CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWctYzEtMDIxMjEzNTAvbmV4dDptYXN0ZXI6Y2EwMzMzOTBhNTM3ZGFjZGMy
MTI3YzY2ZDYyZTc4NjJhZDE1ZmZkYjpiaXNlY3QtbW0KCjIwMTQtMDItMTUtMjE6MDM6NTQg
Y2EwMzMzOTBhNTM3ZGFjZGMyMTI3YzY2ZDYyZTc4NjJhZDE1ZmZkYiBjb21waWxpbmcKCjIw
MTQtMDItMTUtMjE6Mzk6MjMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjMi0wMDQ4
OC1nY2EwMzMzOS4uLi4uLi4uLi4uCTQJOAk5CTIzCTM4CTQwCTQxCTQyCTQ0Li4JNDUJNDgu
CTQ5CTUwLgk1MS4uCTU2CTU4CTYxCTYzCTY0CTY1CTcwCTc2CTgwCTkyIFRFU1QgRkFJTFVS
RQpbICAgMTEuMjk3NjcxXSBwYXJpZGU6IGt0dGkgcmVnaXN0ZXJlZCBhcyBwcm90b2NvbCA5
ClsgICAxMS4yOTg5NTVdIHBkOiBwZCB2ZXJzaW9uIDEuMDUsIG1ham9yIDQ1LCBjbHVzdGVy
IDY0LCBuaWNlIDAKWyAgIDMyLjE5MzU1M10gcmFuZG9tOiBub25ibG9ja2luZyBwb29sIGlz
IGluaXRpYWxpemVkClsgIDI0NS44MjAwODZdIElORk86IHRhc2sgc3dhcHBlcjoxIGJsb2Nr
ZWQgZm9yIG1vcmUgdGhhbiAxMjAgc2Vjb25kcy4KWyAgMjQ1LjgyMDYxNl0gICAgICAgTm90
IHRhaW50ZWQgMy4xNC4wLXJjMi0wMDQ4OC1nY2EwMzMzOSAjNzI5ClsgIDI0NS44MjEwNjld
ICJlY2hvIDAgPiAvcHJvYy9zeXMva2VybmVsL2h1bmdfdGFza190aW1lb3V0X3NlY3MiIGRp
c2FibGVzIHRoaXMgbWVzc2FnZS4KWyAgMjQ1LjgyMTcxMF0gc3dhcHBlciAgICAgICAgIEQg
YTBmOTc4MDEgICAgIDAgICAgIDEgICAgICAwIDB4MDAwMDAwMDAKWyAgMjQ1LjgyMjI1N10g
IGMxYzQzZTI0IDAwMDAwMDQ2IGMxYzQwMDAwIGEwZjk3ODAxIDAwMDAwMDAyIGJiYTM2MDAw
IGMxYzQwMDAwIDAwMDAwMDA3ClsgIDI0NS44MjI5ODBdICAwMDAwMDAwNiBjMWM0MDAwMCBi
MmEwMjMwMSBiMDEzMGM3NCBjMWM0M2RmOCBiMTBmOTM4ZiAwMDAwMDI0NiBiMDEzMGM5Ywpb
ICAyNDUuODI0Mzc3XSAgYzFjNDNlMDAgYjEwZjkzYjQgYzFjNDNlMTAgMDAwMDAyNDYgYmI0
OWYxMzggYjAxMzBiMzggYzFjNDNlMmMgYjE5ODc3NzIKWyAgMjQ1LjgyNTczOV0gQ2FsbCBU
cmFjZToKWyAgMjQ1LjgyNjIwNV0gIFs8YjJhMDIzMDE+XSA/IF9yYXdfd3JpdGVfdW5sb2Nr
X2lycXJlc3RvcmUrMHg1Ny8weDY5ClsgIDI0NS44Mjc4ODVdICBbPGIxMGY5MzhmPl0gPyB0
cmFjZV9oYXJkaXJxc19vbl9jYWxsZXIrMHgxNTUvMHgxNmYKWyAgMjQ1LjgyODU4NF0gIFs8
YjEwZjkzYjQ+XSA/IHRyYWNlX2hhcmRpcnFzX29uKzB4Yi8weGQKWyAgMjQ1LjgyOTIwMV0g
IFs8YjE5ODc3NzI+XSA/IHBhcnBvcnRfY2xhaW0rMHgzMGMvMHgzMTkKWyAgMjQ1LjgyOTg2
OF0gIFs8YjI5ZmM5YjA+XSBzY2hlZHVsZSsweDlmLzB4YTEKWyAgMjQ1LjgzMDU2M10gIFs8
YjIxYjc0YzA+XSBwaV9jbGFpbSsweGMxLzB4ZDQKWyAgMjQ1LjgzMTEzN10gIFs8YjEwZjBl
YmU+XSA/IF9fd2FrZV91cF9jb21tb24rMHg3Ny8weDc3ClsgIDI0NS44MzE4MjhdICBbPGIy
MWI3NTE2Pl0gcGlfdGVzdF9wcm90bysweDFiLzB4MTRkClsgIDI0NS44MzI0NDddICBbPGIy
MWI3NzY0Pl0gcGlfcHJvYmVfbW9kZSsweDExYy8weDE2YQpbICAyNDUuODMzMDg3XSAgWzxi
MjFiNzljNT5dIHBpX3Byb2JlX3VuaXQrMHgyMTMvMHgyM2YKWyAgMjQ1LjgzMzg1Ml0gIFs8
YjIxYjdlOTM+XSBwaV9pbml0KzB4MjRjLzB4MzQxClsgIDI0NS44MzQ1OTNdICBbPGI0MTdl
MGY1Pl0gcGRfaW5pdCsweDE4Yi8weDM0ZApbICAyNDUuODM0OTQ1XSAgWzxiNDE3ZGY2YT5d
ID8ga3R0aV9pbml0KzB4Zi8weGYKWyAgMjQ1LjgzNTM1M10gIFs8YjQxMDFlYTM+XSBkb19v
bmVfaW5pdGNhbGwrMHg4MS8weDE3NgpbICAyNDUuODM1NzUyXSAgWzxiNDEwMTUwMD5dID8g
cmVwYWlyX2Vudl9zdHJpbmcrMHgzLzB4OWQKWyAgMjQ1LjgzNjE2Nl0gIFs8YjEwZDFkOTY+
XSA/IHBhcnNlX2FyZ3MrMHgyZTgvMHgzYTEKWyAgMjQ1LjgzNjU2MV0gIFs8YjQxMDIxM2Y+
XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDFhNy8weDI2ZApbICAyNDUuODM3MTE4XSAgWzxi
MjlhM2E5ZD5dIGtlcm5lbF9pbml0KzB4ZS8weDEzZQpbICAyNDUuODM3NjQzXSAgWzxiMmEw
MzA3Yj5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDMwClsgIDI0NS44MzgwOTFd
ICBbPGIyOWEzYThmPl0gPyByZXN0X2luaXQrMHgxMzEvMHgxMzEKWyAgMjQ1LjgzODQ3OF0g
bm8gbG9ja3MgaGVsZCBieSBzd2FwcGVyLzEuCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMx
LTAyMTIxMzUwL2NhMDMzMzkwYTUzN2RhY2RjMjEyN2M2NmQ2MmU3ODYyYWQxNWZmZGIvZG1l
c2ctcXVhbnRhbC1yb2FtLTU0OjIwMTQwMjE1MjIwMDQ1OmkzODYtcmFuZGNvbmZpZy1jMS0w
MjEyMTM1MDozLjE0LjAtcmMyLTAwNDg4LWdjYTAzMzM5OjcyOQowOjE6OTMgYWxsX2dvb2Q6
YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDItMTUgMjI6MDE6MDEgUkVQRUFUIENP
VU5UOiA5NDAgICMgL2NjL3dmZy9tbS1iaXNlY3QvLnJlcGVhdBtbMG0KCgo9PT09PT09PT0g
bGludXgtbmV4dCA9PT09PT09PT0KbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3Zt
L2kzODYtcmFuZGNvbmZpZy1jMS0wMjEyMTM1MC9uZXh0Om1hc3RlcjpkYThkMzA4ZmJkYjgz
NjAwNzg3ODZiM2UxMjUyMzgxMjJjNGZjNjExOmJpc2VjdC1tbQoKMjAxNC0wMi0xNS0yMjow
MTowNiBkYThkMzA4ZmJkYjgzNjAwNzg3ODZiM2UxMjUyMzgxMjJjNGZjNjExIGNvbXBpbGlu
ZwoKMjAxNC0wMi0xNS0yMjozOToyNiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmMy
LW5leHQtMjAxNDAyMTQuLi4uLi4uLgkxNAkyOAkzOQk0Mi4uCTQzLgk0NAk0OAk1Mgk1NQk1
OS4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JNjMuLi4JNjUJNzMJNzYJMTA1CTE1OQkxODQJMTkw
LgkxOTYJMjEzCTIzNQkyMzcuLgkyMzgJMjM5Li4JMjQzLgkyNDQuLi4uLgkyNDUuLi4uCTI0
Ny4JMjQ4CTI0OS4uLi4uLi4uLgkyNTMJMjY3CTI3NQkyODgJMzA5CTM1MQkzNjAuLi4JMzYx
CTM2MgkzNjUuCTM3MwkzNzYuLi4uCTM3NwkzODYJMzkzLgkzOTYJMzk5CTQwMQk0MDkJNDEy
Li4uCTQxNS4JNDE4CTQyNgk0NDMuLi4uCTQ0NQk0NTEJNDU3CTQ1OS4uCTQ2MAk0NjQJNDcw
CTQ3NQk0NzkuLgk0ODMJNDg2CTQ4OQk1MDAJNTAyCTUwMwk1MDcJNTA4CTUxNgk1MTgJNTE5
Li4uCTUyMC4uCTUyNQk1MzIJNTM0CTU0NAk1NDYJNTUzLi4uLi4uLi4uLi4uLi4JNTU1Lgk1
NTcuCTU1OC4uCTU2Mgk1NjYJNTc0CTU3OAk1ODQJNTg4CTU5Mi4uLi4JNTk0CTYwMwk2MDgJ
NjMxCTY0OAk2NTMJNjU3Lgk2NzIJNjg4CTcwMQk3MDUJNzA2Lgk3NDYJNzY1Lgk3OTcJODQ4
CTg4NAk4OTYJOTAzCTkxMS4JOTIxCTkzNS4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4bWzE7MzVtMjAxNC0wMi0xNiAwMzowNDozMyBhZGRfdG9fcnVuX3F1ZXVlIDUbWzBtCi4u
Li4uLi4uLi4uLi4uLi4uLi4uCTkzNi4uLi4uLgk5MzkJOTQwIFNVQ0NFU1MKCg==

--qOrJKOH36bD5yhNe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc2-next-20140212-02309-g4602175"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.14.0-rc2 Kernel Configuration
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
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
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
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
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
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
CONFIG_CGROUP_HUGETLB=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
# CONFIG_RD_XZ is not set
CONFIG_RD_LZO=y
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
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
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
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
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
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_NONE is not set
CONFIG_CC_STACKPROTECTOR_REGULAR=y
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
CONFIG_BASE_SMALL=0
CONFIG_SYSTEM_TRUSTED_KEYRING=y
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set
# CONFIG_BLK_DEV_THROTTLING is not set
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
CONFIG_ACORN_PARTITION_EESOX=y
# CONFIG_ACORN_PARTITION_ICS is not set
# CONFIG_ACORN_PARTITION_ADFS is not set
CONFIG_ACORN_PARTITION_POWERTEC=y
# CONFIG_ACORN_PARTITION_RISCIX is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
# CONFIG_CFQ_GROUP_IOSCHED is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
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
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
CONFIG_MWINCHIP3D=y
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
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
# CONFIG_X86_UP_APIC is not set
CONFIG_X86_MCE=y
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_INJECT=y
CONFIG_VM86=y
CONFIG_TOSHIBA=y
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_EARLY=y
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
CONFIG_VMSPLIT_3G_OPT=y
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xB0000000
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
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_FRONTSWAP is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
CONFIG_PM_SLEEP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
CONFIG_ACPI_EC_DEBUGFS=y
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
# CONFIG_ACPI_FAN is not set
CONFIG_ACPI_DOCK=y
# CONFIG_ACPI_PROCESSOR is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_BGRT=y
CONFIG_ACPI_REDUCED_HARDWARE_ONLY=y
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
# CONFIG_APM_DO_ENABLE is not set
# CONFIG_APM_DISPLAY_BLANK is not set
CONFIG_APM_ALLOW_INTS=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_POWERNOW_K6 is not set
CONFIG_X86_POWERNOW_K7=y
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=y
CONFIG_X86_P4_CLOCKMOD=y
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y

#
# CPU Idle
#
# CONFIG_CPU_IDLE is not set
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_GOBIOS=y
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_BIOS=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
# CONFIG_PCIEAER is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
CONFIG_PCI_PASID=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_OLPC=y
# CONFIG_OLPC_XO15_SCI is not set
# CONFIG_ALIX is not set
CONFIG_NET5501=y
CONFIG_GEOS=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_COMPAQ=y
# CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM is not set
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=y
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
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
# CONFIG_XFRM_USER is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
# CONFIG_IP_MULTIPLE_TABLES is not set
# CONFIG_IP_ROUTE_MULTIPATH is not set
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
# CONFIG_IP_PNP_DHCP is not set
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
CONFIG_NET_IPGRE=y
# CONFIG_SYN_COOKIES is not set
# CONFIG_NET_IPVTI is not set
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_INET_UDP_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
# CONFIG_IPV6_ROUTE_INFO is not set
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
CONFIG_INET6_IPCOMP=y
CONFIG_IPV6_MIP6=y
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_BEET=y
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
# CONFIG_IPV6_SIT is not set
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_GRE=y
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=y

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
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE=y
# CONFIG_SCTP_COOKIE_HMAC_MD5 is not set
# CONFIG_SCTP_COOKIE_HMAC_SHA1 is not set
# CONFIG_RDS is not set
CONFIG_TIPC=y
CONFIG_TIPC_PORTS=8191
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=y
CONFIG_ATM_MPOA=y
CONFIG_ATM_BR2684=y
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=y
CONFIG_L2TP_DEBUGFS=y
# CONFIG_L2TP_V3 is not set
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
# CONFIG_LTPC is not set
# CONFIG_COPS is not set
CONFIG_IPDDP=y
CONFIG_IPDDP_ENCAP=y
CONFIG_X25=y
# CONFIG_LAPB is not set
CONFIG_PHONET=y
# CONFIG_IEEE802154 is not set
CONFIG_6LOWPAN_IPHC=y
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_BLA=y
CONFIG_BATMAN_ADV_DAT=y
CONFIG_BATMAN_ADV_NC=y
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=y
# CONFIG_OPENVSWITCH_GRE is not set
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=y
# CONFIG_NET_MPLS_GSO is not set
CONFIG_HSR=y
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
CONFIG_NET_DROP_MONITOR=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=y
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=y
# CONFIG_CAN_CALC_BITTIMING is not set
# CONFIG_CAN_LEDS is not set
CONFIG_CAN_MCP251X=y
CONFIG_CAN_JANZ_ICAN3=y
CONFIG_PCH_CAN=y
CONFIG_CAN_GRCAN=y
# CONFIG_CAN_SJA1000 is not set
CONFIG_CAN_C_CAN=y
# CONFIG_CAN_C_CAN_PLATFORM is not set
CONFIG_CAN_C_CAN_PCI=y
CONFIG_CAN_CC770=y
CONFIG_CAN_CC770_ISA=y
CONFIG_CAN_CC770_PLATFORM=y
CONFIG_CAN_SOFTING=y
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
# CONFIG_IRNET is not set
CONFIG_IRCOMM=y
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
# CONFIG_IRDA_FAST_RR is not set
# CONFIG_IRDA_DEBUG is not set

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
CONFIG_NSC_FIR=y
# CONFIG_WINBOND_FIR is not set
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=y
CONFIG_VLSI_FIR=y
# CONFIG_VIA_FIR is not set
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
# CONFIG_BT_RFCOMM_TTY is not set
# CONFIG_BT_BNEP is not set
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIVHCI=y
# CONFIG_BT_MRVL is not set
CONFIG_BT_WILINK=y
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_CERTIFICATION_ONUS=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
# CONFIG_MAC80211_RC_PID is not set
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_MINSTREL_HT is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_RDMA is not set
CONFIG_NET_9P_DEBUG=y
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=y
CONFIG_CAIF_USB=y
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set

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
# CONFIG_FW_LOADER_USER_HELPER is not set
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=y
# CONFIG_MTD_OF_PARTS is not set
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
# CONFIG_MTD_BLOCK is not set
CONFIG_MTD_BLOCK_RO=y
# CONFIG_FTL is not set
CONFIG_NFTL=y
CONFIG_NFTL_RW=y
CONFIG_INFTL=y
# CONFIG_RFD_FTL is not set
CONFIG_SSFDC=y
# CONFIG_SM_FTL is not set
CONFIG_MTD_OOPS=y
CONFIG_MTD_SWAP=y

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
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
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
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
CONFIG_MTD_PHYSMAP_OF=y
CONFIG_MTD_TS5500=y
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
# CONFIG_MTD_ESB2ROM is not set
CONFIG_MTD_CK804XROM=y
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
CONFIG_MTD_PMC551_BUGFIX=y
# CONFIG_MTD_PMC551_DEBUG is not set
# CONFIG_MTD_DATAFLASH is not set
# CONFIG_MTD_M25P80 is not set
# CONFIG_MTD_SST25L is not set
CONFIG_MTD_SLRAM=y
# CONFIG_MTD_PHRAM is not set
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
# CONFIG_MTD_NAND is not set
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
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
# CONFIG_PROC_DEVICETREE is not set
CONFIG_OF_SELFTEST=y
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_NET=y
CONFIG_OF_MDIO=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
CONFIG_OF_MTD=y
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=y
CONFIG_PARPORT_SERIAL=y
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_ISAPNP=y
CONFIG_PNPBIOS=y
CONFIG_PNPBIOS_PROC_FS=y
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=y
CONFIG_BLK_DEV_FD=y
CONFIG_PARIDE=y

#
# Parallel IDE high-level drivers
#
CONFIG_PARIDE_PD=y
CONFIG_PARIDE_PCD=y
CONFIG_PARIDE_PF=y
CONFIG_PARIDE_PT=y
# CONFIG_PARIDE_PG is not set

#
# Parallel IDE protocol modules
#
CONFIG_PARIDE_ATEN=y
CONFIG_PARIDE_BPCK=y
# CONFIG_PARIDE_BPCK6 is not set
# CONFIG_PARIDE_COMM is not set
CONFIG_PARIDE_DSTR=y
CONFIG_PARIDE_FIT2=y
CONFIG_PARIDE_FIT3=y
CONFIG_PARIDE_EPAT=y
CONFIG_PARIDE_EPATC8=y
CONFIG_PARIDE_EPIA=y
CONFIG_PARIDE_FRIQ=y
CONFIG_PARIDE_FRPW=y
# CONFIG_PARIDE_KBIC is not set
CONFIG_PARIDE_KTTI=y
# CONFIG_PARIDE_ON20 is not set
# CONFIG_PARIDE_ON26 is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
# CONFIG_BLK_CPQ_CISS_DA is not set
CONFIG_BLK_DEV_DAC960=y
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_NVME=y
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_BLK_DEV_RBD=y
CONFIG_BLK_DEV_RSXX=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_BMP085_SPI is not set
CONFIG_PCH_PHUB=y
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_LATTICE_ECP3_CONFIG=y
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=y
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
CONFIG_INTEL_MEI_TXE=y
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_IDE_LEGACY=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
# CONFIG_IDE_GD_ATA is not set
CONFIG_IDE_GD_ATAPI=y
# CONFIG_BLK_DEV_IDECD is not set
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_CMD640=y
# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
CONFIG_BLK_DEV_IDEPNP=y
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
CONFIG_BLK_DEV_OFFBOARD=y
# CONFIG_BLK_DEV_GENERIC is not set
CONFIG_BLK_DEV_OPTI621=y
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
CONFIG_BLK_DEV_ALI15X3=y
CONFIG_BLK_DEV_AMD74XX=y
# CONFIG_BLK_DEV_ATIIXP is not set
CONFIG_BLK_DEV_CMD64X=y
CONFIG_BLK_DEV_TRIFLEX=y
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
CONFIG_BLK_DEV_CS5535=y
CONFIG_BLK_DEV_CS5536=y
CONFIG_BLK_DEV_HPT366=y
CONFIG_BLK_DEV_JMICRON=y
CONFIG_BLK_DEV_SC1200=y
CONFIG_BLK_DEV_PIIX=y
CONFIG_BLK_DEV_IT8172=y
# CONFIG_BLK_DEV_IT8213 is not set
CONFIG_BLK_DEV_IT821X=y
CONFIG_BLK_DEV_NS87415=y
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
CONFIG_BLK_DEV_PDC202XX_NEW=y
# CONFIG_BLK_DEV_SVWKS is not set
CONFIG_BLK_DEV_SIIMAGE=y
# CONFIG_BLK_DEV_SIS5513 is not set
CONFIG_BLK_DEV_SLC90E66=y
CONFIG_BLK_DEV_TRM290=y
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
CONFIG_BLK_DEV_4DRIVES=y
CONFIG_BLK_DEV_ALI14XX=y
# CONFIG_BLK_DEV_DTC2278 is not set
CONFIG_BLK_DEV_HT6560B=y
CONFIG_BLK_DEV_QD65XX=y
CONFIG_BLK_DEV_UMC8672=y
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_ISCSI_BOOT_SYSFS=y
CONFIG_SCSI_CXGB3_ISCSI=y
CONFIG_SCSI_CXGB4_ISCSI=y
CONFIG_SCSI_BNX2_ISCSI=y
CONFIG_SCSI_BNX2X_FCOE=y
CONFIG_BE2ISCSI=y
CONFIG_BLK_DEV_3W_XXXX_RAID=y
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
CONFIG_SCSI_3W_SAS=y
# CONFIG_SCSI_7000FASST is not set
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AHA152X=y
CONFIG_SCSI_AHA1542=y
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_BUILD_FIRMWARE is not set
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
# CONFIG_AIC79XX_BUILD_FIRMWARE is not set
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC94XX is not set
CONFIG_SCSI_MVSAS=y
CONFIG_SCSI_MVSAS_DEBUG=y
# CONFIG_SCSI_MVSAS_TASKLET is not set
CONFIG_SCSI_MVUMI=y
CONFIG_SCSI_DPT_I2O=y
# CONFIG_SCSI_ADVANSYS is not set
CONFIG_SCSI_IN2000=y
CONFIG_SCSI_ARCMSR=y
CONFIG_SCSI_ESAS2R=y
# CONFIG_MEGARAID_NEWGEN is not set
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS_LOGGING is not set
# CONFIG_SCSI_MPT3SAS is not set
# CONFIG_SCSI_UFSHCD is not set
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=y
# CONFIG_SCSI_FLASHPOINT is not set
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
CONFIG_FCOE=y
# CONFIG_FCOE_FNIC is not set
CONFIG_SCSI_DMX3191D=y
# CONFIG_SCSI_DTC3280 is not set
CONFIG_SCSI_EATA=y
# CONFIG_SCSI_EATA_TAGGED_QUEUE is not set
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
# CONFIG_SCSI_FUTURE_DOMAIN is not set
CONFIG_SCSI_GDTH=y
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_GENERIC_NCR5380 is not set
CONFIG_SCSI_GENERIC_NCR5380_MMIO=y
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_PPA=y
CONFIG_SCSI_IMM=y
CONFIG_SCSI_IZIP_EPP16=y
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
CONFIG_SCSI_NCR53C406A=y
# CONFIG_SCSI_STEX is not set
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
# CONFIG_SCSI_SYM53C8XX_MMIO is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_PAS16 is not set
CONFIG_SCSI_QLOGIC_FAS=y
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
CONFIG_SCSI_QLA_ISCSI=y
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_SYM53C416=y
CONFIG_SCSI_DC395x=y
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_T128 is not set
# CONFIG_SCSI_U14_34F is not set
# CONFIG_SCSI_ULTRASTOR is not set
# CONFIG_SCSI_NSP32 is not set
CONFIG_SCSI_DEBUG=y
CONFIG_SCSI_PMCRAID=y
# CONFIG_SCSI_PM8001 is not set
CONFIG_SCSI_SRP=y
CONFIG_SCSI_BFA_FC=y
CONFIG_SCSI_VIRTIO=y
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
CONFIG_SCSI_DH_HP_SW=y
# CONFIG_SCSI_DH_EMC is not set
# CONFIG_SCSI_DH_ALUA is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
# CONFIG_ATA_ACPI is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=y
CONFIG_AHCI_IMX=y
CONFIG_SATA_INIC162X=y
CONFIG_SATA_ACARD_AHCI=y
CONFIG_SATA_SIL24=y
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=y
CONFIG_SATA_QSTOR=y
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
CONFIG_SATA_HIGHBANK=y
# CONFIG_SATA_MV is not set
CONFIG_SATA_NV=y
# CONFIG_SATA_PROMISE is not set
CONFIG_SATA_RCAR=y
# CONFIG_SATA_SIL is not set
CONFIG_SATA_SIS=y
# CONFIG_SATA_SVW is not set
CONFIG_SATA_ULI=y
CONFIG_SATA_VIA=y
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
CONFIG_PATA_ALI=y
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
CONFIG_PATA_CMD64X=y
# CONFIG_PATA_CS5520 is not set
CONFIG_PATA_CS5530=y
# CONFIG_PATA_CS5535 is not set
CONFIG_PATA_CS5536=y
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
CONFIG_PATA_HPT366=y
CONFIG_PATA_HPT37X=y
CONFIG_PATA_HPT3X2N=y
CONFIG_PATA_HPT3X3=y
# CONFIG_PATA_HPT3X3_DMA is not set
CONFIG_PATA_IT8213=y
CONFIG_PATA_IT821X=y
# CONFIG_PATA_JMICRON is not set
CONFIG_PATA_MARVELL=y
# CONFIG_PATA_NETCELL is not set
CONFIG_PATA_NINJA32=y
# CONFIG_PATA_NS87415 is not set
CONFIG_PATA_OLDPIIX=y
CONFIG_PATA_OPTIDMA=y
# CONFIG_PATA_PDC2027X is not set
CONFIG_PATA_PDC_OLD=y
CONFIG_PATA_RADISYS=y
CONFIG_PATA_RDC=y
CONFIG_PATA_SC1200=y
CONFIG_PATA_SCH=y
CONFIG_PATA_SERVERWORKS=y
CONFIG_PATA_SIL680=y
CONFIG_PATA_SIS=y
# CONFIG_PATA_TOSHIBA is not set
CONFIG_PATA_TRIFLEX=y
CONFIG_PATA_VIA=y
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
CONFIG_PATA_CMD640_PCI=y
CONFIG_PATA_ISAPNP=y
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_NS87410=y
CONFIG_PATA_OPTI=y
CONFIG_PATA_PLATFORM=y
# CONFIG_PATA_OF_PLATFORM is not set
CONFIG_PATA_QDI=y
CONFIG_PATA_RZ1000=y
# CONFIG_PATA_WINBOND_VLB is not set

#
# Generic fallback / legacy drivers
#
CONFIG_ATA_GENERIC=y
CONFIG_PATA_LEGACY=y
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BCACHE=y
# CONFIG_BCACHE_DEBUG is not set
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=y
CONFIG_DM_BIO_PRISON=y
CONFIG_DM_PERSISTENT_DATA=y
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_THIN_PROVISIONING=y
# CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
CONFIG_DM_CACHE=y
CONFIG_DM_CACHE_MQ=y
CONFIG_DM_CACHE_CLEANER=y
CONFIG_DM_MIRROR=y
# CONFIG_DM_LOG_USERSPACE is not set
# CONFIG_DM_RAID is not set
CONFIG_DM_ZERO=y
# CONFIG_DM_MULTIPATH is not set
CONFIG_DM_DELAY=y
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=y
CONFIG_DM_VERITY=y
# CONFIG_DM_SWITCH is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
# CONFIG_FUSION_SPI is not set
CONFIG_FUSION_FC=y
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
CONFIG_FIREWIRE_SBP2=y
# CONFIG_FIREWIRE_NET is not set
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
# CONFIG_I2O_EXT_ADAPTEC is not set
# CONFIG_I2O_CONFIG is not set
CONFIG_I2O_BUS=y
# CONFIG_I2O_BLOCK is not set
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
CONFIG_CAIF_TTY=y
CONFIG_CAIF_SPI_SLAVE=y
# CONFIG_CAIF_SPI_SYNC is not set
CONFIG_CAIF_HSI=y
# CONFIG_CAIF_VIRTIO is not set
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
CONFIG_ADAPTEC_STARFIRE=y
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=y
CONFIG_ACENIC_OMIT_TIGON_I=y
# CONFIG_NET_VENDOR_AMD is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_ARC_EMAC=y
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
CONFIG_ATL1=y
CONFIG_ATL1E=y
CONFIG_ATL1C=y
# CONFIG_ALX is not set
# CONFIG_NET_CADENCE is not set
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=y
CONFIG_CNIC=y
CONFIG_TIGON3=y
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=y
CONFIG_NET_CALXEDA_XGMAC=y
CONFIG_NET_VENDOR_CHELSIO=y
CONFIG_CHELSIO_T1=y
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T3=y
CONFIG_CHELSIO_T4=y
# CONFIG_CHELSIO_T4VF is not set
# CONFIG_NET_VENDOR_CIRRUS is not set
# CONFIG_NET_VENDOR_CISCO is not set
CONFIG_DNET=y
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
CONFIG_TULIP=y
# CONFIG_TULIP_MWI is not set
CONFIG_TULIP_MMIO=y
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=y
CONFIG_WINBOND_840=y
CONFIG_DM9102=y
CONFIG_ULI526X=y
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
CONFIG_SUNDANCE=y
CONFIG_SUNDANCE_MMIO=y
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=y
CONFIG_NET_VENDOR_EXAR=y
CONFIG_S2IO=y
CONFIG_VXGE=y
CONFIG_VXGE_DEBUG_TRACE_ALL=y
CONFIG_NET_VENDOR_HP=y
CONFIG_HP100=y
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=y
CONFIG_E1000=y
CONFIG_E1000E=y
# CONFIG_IGB is not set
CONFIG_IGBVF=y
CONFIG_IXGB=y
# CONFIG_IXGBE is not set
CONFIG_I40E=y
CONFIG_I40E_DCB=y
# CONFIG_NET_VENDOR_I825XX is not set
CONFIG_IP1000=y
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_MVMDIO=y
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_EN=y
# CONFIG_MLX4_EN_DCB is not set
CONFIG_MLX4_CORE=y
CONFIG_MLX4_DEBUG=y
CONFIG_MLX5_CORE=y
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8851 is not set
CONFIG_KS8851_MLL=y
CONFIG_KSZ884X_PCI=y
# CONFIG_NET_VENDOR_MICROCHIP is not set
CONFIG_NET_VENDOR_MYRI=y
CONFIG_MYRI10GE=y
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
# CONFIG_NET_VENDOR_REALTEK is not set
CONFIG_SH_ETH=y
# CONFIG_NET_VENDOR_RDC is not set
# CONFIG_NET_VENDOR_SEEQ is not set
CONFIG_NET_VENDOR_SILAN=y
CONFIG_SC92031=y
CONFIG_NET_VENDOR_SIS=y
CONFIG_SIS900=y
# CONFIG_SIS190 is not set
CONFIG_SFC=y
# CONFIG_SFC_MTD is not set
# CONFIG_SFC_MCDI_MON is not set
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
CONFIG_NET_VENDOR_TEHUTI=y
CONFIG_TEHUTI=y
CONFIG_NET_VENDOR_TI=y
# CONFIG_TLAN is not set
# CONFIG_NET_VENDOR_VIA is not set
CONFIG_NET_VENDOR_WIZNET=y
CONFIG_WIZNET_W5100=y
CONFIG_WIZNET_W5300=y
CONFIG_WIZNET_BUS_DIRECT=y
# CONFIG_WIZNET_BUS_INDIRECT is not set
# CONFIG_WIZNET_BUS_ANY is not set
CONFIG_FDDI=y
CONFIG_DEFXX=y
CONFIG_DEFXX_MMIO=y
CONFIG_SKFP=y
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
CONFIG_AMD_PHY=y
# CONFIG_MARVELL_PHY is not set
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
CONFIG_BCM87XX_PHY=y
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
# CONFIG_STE10XP is not set
CONFIG_LSI_ET1011C_PHY=y
# CONFIG_MICREL_PHY is not set
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
# CONFIG_MDIO_GPIO is not set
CONFIG_MDIO_BUS_MUX=y
CONFIG_MDIO_BUS_MUX_GPIO=y
CONFIG_MDIO_BUS_MUX_MMIOREG=y
CONFIG_MICREL_KS8995MA=y
CONFIG_PLIP=y
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_DEFLATE=y
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
CONFIG_LIBERTAS_THINFIRM=y
CONFIG_LIBERTAS_THINFIRM_DEBUG=y
CONFIG_AIRO=y
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
CONFIG_RTL8180=y
CONFIG_ADM8211=y
CONFIG_MAC80211_HWSIM=y
CONFIG_MWL8K=y
# CONFIG_ATH_CARDS is not set
CONFIG_B43=y
CONFIG_B43_BCMA=y
CONFIG_B43_SSB=y
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_BCMA_PIO=y
CONFIG_B43_PIO=y
# CONFIG_B43_PHY_N is not set
CONFIG_B43_PHY_LP=y
CONFIG_B43_PHY_HT=y
CONFIG_B43_LEDS=y
CONFIG_B43_HWRNG=y
# CONFIG_B43_DEBUG is not set
CONFIG_B43LEGACY=y
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_HWRNG=y
# CONFIG_B43LEGACY_DEBUG is not set
CONFIG_B43LEGACY_PIO=y
# CONFIG_B43LEGACY_DMA_AND_PIO_MODE is not set
# CONFIG_B43LEGACY_DMA_MODE is not set
CONFIG_B43LEGACY_PIO_MODE=y
CONFIG_BRCMUTIL=y
CONFIG_BRCMSMAC=y
CONFIG_BRCMFMAC=y
CONFIG_BRCM_TRACING=y
# CONFIG_BRCMDBG is not set
CONFIG_HOSTAP=y
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_HOSTAP_FIRMWARE_NVRAM=y
CONFIG_HOSTAP_PLX=y
CONFIG_HOSTAP_PCI=y
CONFIG_IPW2100=y
CONFIG_IPW2100_MONITOR=y
CONFIG_IPW2100_DEBUG=y
CONFIG_IPW2200=y
# CONFIG_IPW2200_MONITOR is not set
CONFIG_IPW2200_QOS=y
# CONFIG_IPW2200_DEBUG is not set
CONFIG_LIBIPW=y
CONFIG_LIBIPW_DEBUG=y
CONFIG_IWLWIFI=y
CONFIG_IWLDVM=y
CONFIG_IWLMVM=y

#
# Debugging Options
#
# CONFIG_IWLWIFI_DEBUG is not set
CONFIG_IWLWIFI_DEBUGFS=y
CONFIG_IWLWIFI_DEVICE_TRACING=y
CONFIG_IWLEGACY=y
# CONFIG_IWL4965 is not set
CONFIG_IWL3945=y

#
# iwl3945 / iwl4965 Debugging Options
#
# CONFIG_IWLEGACY_DEBUG is not set
# CONFIG_IWLEGACY_DEBUGFS is not set
# CONFIG_LIBERTAS is not set
CONFIG_HERMES=y
CONFIG_HERMES_PRISM=y
# CONFIG_HERMES_CACHE_FW_ON_INIT is not set
# CONFIG_PLX_HERMES is not set
# CONFIG_TMD_HERMES is not set
# CONFIG_NORTEL_HERMES is not set
CONFIG_PCI_HERMES=y
CONFIG_P54_COMMON=y
CONFIG_P54_PCI=y
CONFIG_P54_SPI=y
# CONFIG_P54_SPI_DEFAULT_EEPROM is not set
CONFIG_P54_LEDS=y
# CONFIG_RT2X00 is not set
CONFIG_RTL_CARDS=y
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8723AE is not set
# CONFIG_RTL8188EE is not set
# CONFIG_WL_TI is not set
CONFIG_MWIFIEX=y
# CONFIG_MWIFIEX_PCIE is not set
CONFIG_CW1200=y
CONFIG_CW1200_WLAN_SPI=y

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=y
CONFIG_HDLC_RAW=y
CONFIG_HDLC_RAW_ETH=y
CONFIG_HDLC_CISCO=y
CONFIG_HDLC_FR=y
CONFIG_HDLC_PPP=y

#
# X.25/LAPB support is disabled
#
CONFIG_PCI200SYN=y
# CONFIG_WANXL is not set
# CONFIG_PC300TOO is not set
CONFIG_N2=y
# CONFIG_C101 is not set
# CONFIG_FARSYNC is not set
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
CONFIG_SDLA=y
CONFIG_SBNI=y
CONFIG_SBNI_MULTILINE=y
CONFIG_VMXNET3=y
# CONFIG_ISDN is not set

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
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5520 is not set
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ADP5589=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
CONFIG_KEYBOARD_QT2160=y
CONFIG_KEYBOARD_LKKBD=y
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
CONFIG_KEYBOARD_TCA6416=y
CONFIG_KEYBOARD_TCA8418=y
CONFIG_KEYBOARD_MATRIX=y
# CONFIG_KEYBOARD_LM8323 is not set
CONFIG_KEYBOARD_LM8333=y
CONFIG_KEYBOARD_MAX7359=y
# CONFIG_KEYBOARD_MCS is not set
CONFIG_KEYBOARD_MPR121=y
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_SH_KEYSC is not set
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_TWL4030 is not set
CONFIG_KEYBOARD_XTKBD=y
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_LEDS=y
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
# CONFIG_JOYSTICK_GRIP_MP is not set
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=y
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
CONFIG_JOYSTICK_SPACEBALL=y
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
CONFIG_JOYSTICK_DB9=y
CONFIG_JOYSTICK_GAMECON=y
# CONFIG_JOYSTICK_TURBOGRAFX is not set
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_JOYSTICK_WALKERA0701=y
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
CONFIG_TOUCHSCREEN_AD7877=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
CONFIG_TOUCHSCREEN_BU21013=y
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_EETI=y
CONFIG_TOUCHSCREEN_EGALAX=y
CONFIG_TOUCHSCREEN_FUJITSU=y
CONFIG_TOUCHSCREEN_ILI210X=y
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_WACOM_I2C=y
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
# CONFIG_TOUCHSCREEN_MMS114 is not set
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_HTCPEN=y
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
# CONFIG_TOUCHSCREEN_UCB1400 is not set
# CONFIG_TOUCHSCREEN_PIXCIR is not set
CONFIG_TOUCHSCREEN_WM831X=y
CONFIG_TOUCHSCREEN_WM97XX=y
CONFIG_TOUCHSCREEN_WM9705=y
# CONFIG_TOUCHSCREEN_WM9712 is not set
CONFIG_TOUCHSCREEN_WM9713=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_MC13783=y
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
CONFIG_TOUCHSCREEN_TSC2005=y
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_ST1232=y
CONFIG_TOUCHSCREEN_STMPE=y
CONFIG_TOUCHSCREEN_TPS6507X=y
# CONFIG_TOUCHSCREEN_ZFORCE is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM860X_ONKEY=y
CONFIG_INPUT_88PM80X_ONKEY=y
CONFIG_INPUT_AD714X=y
CONFIG_INPUT_AD714X_I2C=y
# CONFIG_INPUT_AD714X_SPI is not set
CONFIG_INPUT_ARIZONA_HAPTICS=y
CONFIG_INPUT_BMA150=y
# CONFIG_INPUT_MAX8925_ONKEY is not set
CONFIG_INPUT_MC13783_PWRBUTTON=y
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=y
# CONFIG_INPUT_GPIO_BEEPER is not set
CONFIG_INPUT_GPIO_TILT_POLLED=y
# CONFIG_INPUT_WISTRON_BTNS is not set
CONFIG_INPUT_ATLAS_BTNS=y
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=y
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_RETU_PWRBUTTON is not set
CONFIG_INPUT_TWL4030_PWRBUTTON=y
CONFIG_INPUT_TWL4030_VIBRA=y
CONFIG_INPUT_TWL6040_VIBRA=y
# CONFIG_INPUT_UINPUT is not set
CONFIG_INPUT_PCF50633_PMU=y
CONFIG_INPUT_PCF8574=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_DA9055_ONKEY=y
# CONFIG_INPUT_WM831X_ON is not set
CONFIG_INPUT_ADXL34X=y
# CONFIG_INPUT_ADXL34X_I2C is not set
CONFIG_INPUT_ADXL34X_SPI=y
# CONFIG_INPUT_CMA3000 is not set
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
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_SERIO_APBPS2=y
# CONFIG_SERIO_OLPC_APSP is not set
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=y
# CONFIG_CYCLADES is not set
CONFIG_MOXA_INTELLIO=y
CONFIG_MOXA_SMARTIO=y
CONFIG_SYNCLINK=y
# CONFIG_SYNCLINKMP is not set
CONFIG_SYNCLINK_GT=y
CONFIG_NOZOMI=y
CONFIG_ISI=y
# CONFIG_N_HDLC is not set
# CONFIG_N_GSM is not set
CONFIG_TRACE_ROUTER=y
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
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_FOURPORT=y
CONFIG_SERIAL_8250_ACCENT=y
# CONFIG_SERIAL_8250_BOCA is not set
CONFIG_SERIAL_8250_EXAR_ST16C554=y
CONFIG_SERIAL_8250_HUB6=y
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CLPS711X=y
CONFIG_SERIAL_CLPS711X_CONSOLE=y
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_UARTLITE=y
# CONFIG_SERIAL_UARTLITE_CONSOLE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_SERIAL_OF_PLATFORM=y
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
CONFIG_SERIAL_PCH_UART=y
CONFIG_SERIAL_PCH_UART_CONSOLE=y
# CONFIG_SERIAL_XILINX_PS_UART is not set
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
CONFIG_SERIAL_ST_ASC=y
# CONFIG_SERIAL_ST_ASC_CONSOLE is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
# CONFIG_HW_RANDOM_VIRTIO is not set
# CONFIG_HW_RANDOM_TPM is not set
CONFIG_NVRAM=y
CONFIG_DTLK=y
CONFIG_R3964=y
CONFIG_APPLICOM=y
CONFIG_SONYPI=y
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=y
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HPET_MMAP_DEFAULT=y
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=y
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
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
CONFIG_I2C_ARB_GPIO_CHALLENGE=y
CONFIG_I2C_MUX_GPIO=y
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
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
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=y
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

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
CONFIG_I2C_EG20T=y
CONFIG_I2C_GPIO=y
CONFIG_I2C_KEMPLD=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_RIIC is not set
CONFIG_I2C_SH_MOBILE=y
CONFIG_I2C_SIMTEC=y
# CONFIG_I2C_XILINX is not set
CONFIG_I2C_RCAR=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=y
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_ELEKTOR is not set
CONFIG_I2C_PCA_ISA=y
CONFIG_SCx200_I2C=y
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
# CONFIG_SCx200_ACB is not set
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
# CONFIG_SPI_ATMEL is not set
CONFIG_SPI_BCM2835=y
CONFIG_SPI_BCM63XX_HSSPI=y
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
CONFIG_SPI_EP93XX=y
CONFIG_SPI_GPIO=y
# CONFIG_SPI_IMX is not set
CONFIG_SPI_LM70_LLP=y
# CONFIG_SPI_FSL_SPI is not set
# CONFIG_SPI_FSL_DSPI is not set
# CONFIG_SPI_OC_TINY is not set
CONFIG_SPI_TI_QSPI=y
CONFIG_SPI_OMAP_100K=y
CONFIG_SPI_ORION=y
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
CONFIG_SPI_SC18IS602=y
CONFIG_SPI_SH=y
# CONFIG_SPI_SH_HSPI is not set
CONFIG_SPI_TOPCLIFF_PCH=y
CONFIG_SPI_TXX9=y
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
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
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
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
CONFIG_DP83640_PHY=y
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9055 is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_CLPS711X=y
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_SCH311X is not set
CONFIG_GPIO_TS5500=y
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
# CONFIG_GPIO_VX855 is not set
CONFIG_GPIO_LYNXPOINT=y
CONFIG_GPIO_GRGPIO=y

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_LP3943 is not set
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_RC5T583 is not set
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_STMPE=y
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL4030=y
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_WM8350=y
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5520=y
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set
# CONFIG_GPIO_ADNP is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_AMD8111=y
# CONFIG_GPIO_INTEL_MID is not set
CONFIG_GPIO_PCH=y
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_SODAVILLE=y
# CONFIG_GPIO_TIMBERDALE is not set
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MCP23S08=y
# CONFIG_GPIO_MC33880 is not set
CONFIG_GPIO_74X164=y

#
# AC97 GPIO expanders:
#
CONFIG_GPIO_UCB1400=y

#
# LPC GPIO expanders:
#
# CONFIG_GPIO_KEMPLD is not set

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=y
# CONFIG_GPIO_PALMAS is not set
CONFIG_GPIO_BCM_KONA=y

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2413 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
# CONFIG_GENERIC_ADC_BATTERY is not set
CONFIG_MAX8925_POWER=y
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
CONFIG_WM8350_POWER=y
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_88PM860X is not set
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_OLPC=y
CONFIG_BATTERY_WM97XX=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
# CONFIG_BATTERY_TWL4030_MADC is not set
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_BATTERY_RX51=y
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_TWL4030=y
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MANAGER=y
# CONFIG_CHARGER_MAX14577 is not set
# CONFIG_CHARGER_MAX8997 is not set
CONFIG_CHARGER_MAX8998=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_BQ24735=y
# CONFIG_CHARGER_SMB347 is not set
CONFIG_BATTERY_GOLDFISH=y
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_AS3722 is not set
CONFIG_POWER_RESET_GPIO=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
CONFIG_SENSORS_ADT7410=y
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_GPIO_FAN=y
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IIO_HWMON=y
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC2945=y
CONFIG_SENSORS_LTC4151=y
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4222=y
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
# CONFIG_SENSORS_PMBUS is not set
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_LM25066=y
# CONFIG_SENSORS_LTC2978 is not set
CONFIG_SENSORS_MAX16064=y
# CONFIG_SENSORS_MAX34440 is not set
# CONFIG_SENSORS_MAX8688 is not set
CONFIG_SENSORS_UCD9000=y
# CONFIG_SENSORS_UCD9200 is not set
# CONFIG_SENSORS_ZL6100 is not set
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
CONFIG_SENSORS_SCH5636=y
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_TWL4030_MADC=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=y
# CONFIG_SENSORS_VT1211 is not set
CONFIG_SENSORS_VT8231=y
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
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
CONFIG_SENSORS_ACPI_POWER=y
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_OF is not set
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_EMULATION=y
CONFIG_RCAR_THERMAL=y
CONFIG_INTEL_POWERCLAMP=y
CONFIG_ACPI_INT3403_THERMAL=y

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_DA9055_WATCHDOG=y
# CONFIG_GPIO_WATCHDOG is not set
CONFIG_WM831X_WATCHDOG=y
CONFIG_WM8350_WATCHDOG=y
# CONFIG_DW_WATCHDOG is not set
CONFIG_TWL4030_WATCHDOG=y
CONFIG_RETU_WATCHDOG=y
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
CONFIG_F71808E_WDT=y
CONFIG_SP5100_TCO=y
CONFIG_SC520_WDT=y
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
CONFIG_IBMASR=y
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=y
CONFIG_ITCO_WDT=y
# CONFIG_ITCO_VENDOR_SUPPORT is not set
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
CONFIG_HP_WATCHDOG=y
# CONFIG_KEMPLD_WDT is not set
CONFIG_HPWDT_NMI_DECODING=y
CONFIG_SC1200_WDT=y
# CONFIG_SCx200_WDT is not set
CONFIG_PC87413_WDT=y
CONFIG_NV_TCO=y
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_SBC7240_WDT is not set
CONFIG_CPU5_WDT=y
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
# CONFIG_MEN_A21_WDT is not set

#
# ISA-based Watchdog Cards
#
# CONFIG_PCWATCHDOG is not set
# CONFIG_MIXCOMWD is not set
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
CONFIG_WDTPCI=y
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
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_BLOCKIO=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
CONFIG_MFD_AS3722=y
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
CONFIG_MFD_CROS_EC_SPI=y
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
CONFIG_UCB1400_CORE=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
# CONFIG_STMPE_SPI is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=y
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
CONFIG_TWL4030_MADC=y
CONFIG_MFD_TWL4030_AUDIO=y
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM831X_SPI is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_88PM800=y
# CONFIG_REGULATOR_88PM8607 is not set
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_AAT2870=y
CONFIG_REGULATOR_ARIZONA=y
CONFIG_REGULATOR_AS3722=y
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_LP8788=y
CONFIG_REGULATOR_MAX14577=y
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX8997=y
CONFIG_REGULATOR_MAX8998=y
CONFIG_REGULATOR_MAX77686=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
# CONFIG_REGULATOR_PALMAS is not set
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_RC5T583=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
# CONFIG_REGULATOR_TPS6507X is not set
# CONFIG_REGULATOR_TPS6524X is not set
# CONFIG_REGULATOR_TPS65912 is not set
CONFIG_REGULATOR_TWL4030=y
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8350=y
# CONFIG_REGULATOR_WM8994 is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=y
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
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=y
# CONFIG_FB_EFI is not set
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_OPENCORES=y
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
# CONFIG_FB_ATY_GENERIC_LCD is not set
# CONFIG_FB_ATY_GX is not set
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=y
CONFIG_FB_S3_DDC=y
CONFIG_FB_SAVAGE=y
# CONFIG_FB_SAVAGE_I2C is not set
# CONFIG_FB_SAVAGE_ACCEL is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=y
CONFIG_FB_TMIO_ACCELL=y
# CONFIG_FB_SM501 is not set
CONFIG_FB_GOLDFISH=y
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
CONFIG_FB_AUO_K1901=y
# CONFIG_FB_SIMPLE is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_L4F00242T03=y
CONFIG_LCD_LMS283GF05=y
# CONFIG_LCD_LTV350QV is not set
CONFIG_LCD_ILI922X=y
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_TDO24M=y
# CONFIG_LCD_VGG2432A4 is not set
# CONFIG_LCD_PLATFORM is not set
# CONFIG_LCD_S6E63M0 is not set
CONFIG_LCD_LD9040=y
CONFIG_LCD_AMS369FG06=y
CONFIG_LCD_LMS501KF03=y
# CONFIG_LCD_HX8357 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_CARILLO_RANCH=y
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_MAX8925=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
# CONFIG_BACKLIGHT_ADP5520 is not set
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_88PM860X=y
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_AAT2870=y
CONFIG_BACKLIGHT_LM3630A=y
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=y
# CONFIG_BACKLIGHT_LP8788 is not set
# CONFIG_BACKLIGHT_PANDORA is not set
CONFIG_BACKLIGHT_GPIO=y
# CONFIG_BACKLIGHT_LV5207LP is not set
CONFIG_BACKLIGHT_BD6107=y
# CONFIG_LOGO is not set
CONFIG_FB_SSD1307=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
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
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_HRTIMER is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_OPL4_LIB=y
CONFIG_SND_VX_LIB=y
CONFIG_SND_AC97_CODEC=y
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_WSS_LIB=y
CONFIG_SND_SB_COMMON=y
CONFIG_SND_SB8_DSP=y
CONFIG_SND_SB16_DSP=y
CONFIG_SND_ISA=y
# CONFIG_SND_ADLIB is not set
# CONFIG_SND_AD1816A is not set
# CONFIG_SND_AD1848 is not set
CONFIG_SND_ALS100=y
# CONFIG_SND_AZT1605 is not set
# CONFIG_SND_AZT2316 is not set
CONFIG_SND_AZT2320=y
CONFIG_SND_CMI8328=y
CONFIG_SND_CMI8330=y
CONFIG_SND_CS4231=y
CONFIG_SND_CS4236=y
# CONFIG_SND_ES1688 is not set
CONFIG_SND_ES18XX=y
CONFIG_SND_SC6000=y
CONFIG_SND_GUSCLASSIC=y
CONFIG_SND_GUSEXTREME=y
CONFIG_SND_GUSMAX=y
CONFIG_SND_INTERWAVE=y
# CONFIG_SND_INTERWAVE_STB is not set
CONFIG_SND_JAZZ16=y
# CONFIG_SND_OPL3SA2 is not set
# CONFIG_SND_OPTI92X_AD1848 is not set
# CONFIG_SND_OPTI92X_CS4231 is not set
CONFIG_SND_OPTI93X=y
CONFIG_SND_MIRO=y
# CONFIG_SND_SB8 is not set
CONFIG_SND_SB16=y
CONFIG_SND_SBAWE=y
CONFIG_SND_SB16_CSP=y
CONFIG_SND_SSCAPE=y
CONFIG_SND_WAVEFRONT=y
CONFIG_SND_MSND_PINNACLE=y
# CONFIG_SND_MSND_CLASSIC is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
CONFIG_SND_ALS300=y
CONFIG_SND_ALS4000=y
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
CONFIG_SND_AU8820=y
# CONFIG_SND_AU8830 is not set
CONFIG_SND_AW2=y
# CONFIG_SND_AZT3328 is not set
CONFIG_SND_BT87X=y
CONFIG_SND_BT87X_OVERCLOCK=y
# CONFIG_SND_CA0106 is not set
CONFIG_SND_CMIPCI=y
CONFIG_SND_OXYGEN_LIB=y
CONFIG_SND_OXYGEN=y
CONFIG_SND_CS4281=y
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
CONFIG_SND_CTXFI=y
# CONFIG_SND_DARLA20 is not set
CONFIG_SND_GINA20=y
# CONFIG_SND_LAYLA20 is not set
CONFIG_SND_DARLA24=y
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
CONFIG_SND_MIA=y
CONFIG_SND_ECHO3G=y
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
CONFIG_SND_INDIGODJ=y
# CONFIG_SND_INDIGOIOX is not set
CONFIG_SND_INDIGODJX=y
CONFIG_SND_EMU10K1=y
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
CONFIG_SND_ES1938=y
# CONFIG_SND_ES1968 is not set
CONFIG_SND_FM801=y
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
CONFIG_SND_HDSPM=y
# CONFIG_SND_ICE1712 is not set
CONFIG_SND_ICE1724=y
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
CONFIG_SND_KORG1212=y
CONFIG_SND_LOLA=y
CONFIG_SND_LX6464ES=y
# CONFIG_SND_MAESTRO3 is not set
CONFIG_SND_MIXART=y
CONFIG_SND_NM256=y
CONFIG_SND_PCXHR=y
CONFIG_SND_RIPTIDE=y
# CONFIG_SND_RME32 is not set
CONFIG_SND_RME96=y
CONFIG_SND_RME9652=y
CONFIG_SND_SIS7019=y
CONFIG_SND_SONICVIBES=y
CONFIG_SND_TRIDENT=y
CONFIG_SND_VIA82XX=y
# CONFIG_SND_VIA82XX_MODEM is not set
CONFIG_SND_VIRTUOSO=y
CONFIG_SND_VX222=y
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_SPI=y
CONFIG_SND_AT73C213=y
CONFIG_SND_AT73C213_TARGET_BITRATE=48000
# CONFIG_SND_FIREWIRE is not set
CONFIG_SND_SOC=y
CONFIG_SND_SOC_GENERIC_DMAENGINE_PCM=y
CONFIG_SND_SOC_ADI=y
CONFIG_SND_SOC_ADI_AXI_I2S=y
CONFIG_SND_SOC_ADI_AXI_SPDIF=y
CONFIG_SND_ATMEL_SOC=y
# CONFIG_SND_BCM2835_SOC_I2S is not set
CONFIG_SND_EP93XX_SOC=y
CONFIG_SND_SOC_FSL_SSI=y
CONFIG_SND_SOC_FSL_SPDIF=y
CONFIG_SND_IMX_SOC=y
CONFIG_SND_SOC_IMX_PCM_DMA=y
CONFIG_SND_SOC_IMX_AUDMUX=y
CONFIG_SND_SOC_IMX_WM8962=y
CONFIG_SND_SOC_IMX_SGTL5000=y
CONFIG_SND_SOC_IMX_SPDIF=y
CONFIG_SND_KIRKWOOD_SOC=y
# CONFIG_SND_KIRKWOOD_SOC_OPENRD is not set
CONFIG_SND_KIRKWOOD_SOC_T5325=y
CONFIG_SND_SOC_I2C_AND_SPI=y

#
# CODEC drivers
#
CONFIG_SND_SOC_ALL_CODECS=y
CONFIG_SND_SOC_88PM860X=y
CONFIG_SND_SOC_ARIZONA=y
CONFIG_SND_SOC_WM_HUBS=y
CONFIG_SND_SOC_WM_ADSP=y
CONFIG_SND_SOC_AD1836=y
CONFIG_SND_SOC_AD193X=y
CONFIG_SND_SOC_AD73311=y
CONFIG_SND_SOC_ADAU1701=y
CONFIG_SND_SOC_ADAU1373=y
CONFIG_SND_SOC_ADAV80X=y
CONFIG_SND_SOC_ADS117X=y
CONFIG_SND_SOC_AK4104=y
CONFIG_SND_SOC_AK4535=y
CONFIG_SND_SOC_AK4554=y
CONFIG_SND_SOC_AK4641=y
CONFIG_SND_SOC_AK4642=y
CONFIG_SND_SOC_AK4671=y
CONFIG_SND_SOC_AK5386=y
CONFIG_SND_SOC_ALC5623=y
CONFIG_SND_SOC_ALC5632=y
CONFIG_SND_SOC_CS42L51=y
CONFIG_SND_SOC_CS42L52=y
CONFIG_SND_SOC_CS42L73=y
CONFIG_SND_SOC_CS4270=y
CONFIG_SND_SOC_CS4271=y
CONFIG_SND_SOC_CX20442=y
CONFIG_SND_SOC_JZ4740_CODEC=y
CONFIG_SND_SOC_L3=y
CONFIG_SND_SOC_DA7210=y
CONFIG_SND_SOC_DA7213=y
CONFIG_SND_SOC_DA732X=y
CONFIG_SND_SOC_DA9055=y
CONFIG_SND_SOC_BT_SCO=y
CONFIG_SND_SOC_HDMI_CODEC=y
CONFIG_SND_SOC_ISABELLE=y
CONFIG_SND_SOC_LM49453=y
CONFIG_SND_SOC_MAX98088=y
CONFIG_SND_SOC_MAX98090=y
CONFIG_SND_SOC_MAX98095=y
CONFIG_SND_SOC_MAX9850=y
CONFIG_SND_SOC_PCM1681=y
CONFIG_SND_SOC_PCM1792A=y
CONFIG_SND_SOC_PCM3008=y
CONFIG_SND_SOC_PCM512x=y
CONFIG_SND_SOC_RT5631=y
CONFIG_SND_SOC_RT5640=y
CONFIG_SND_SOC_SGTL5000=y
CONFIG_SND_SOC_SI476X=y
CONFIG_SND_SOC_SIGMADSP=y
CONFIG_SND_SOC_SPDIF=y
CONFIG_SND_SOC_SSM2518=y
CONFIG_SND_SOC_SSM2602=y
CONFIG_SND_SOC_STA32X=y
CONFIG_SND_SOC_STA529=y
CONFIG_SND_SOC_TAS5086=y
CONFIG_SND_SOC_TLV320AIC23=y
CONFIG_SND_SOC_TLV320AIC26=y
CONFIG_SND_SOC_TLV320AIC32X4=y
CONFIG_SND_SOC_TLV320AIC3X=y
CONFIG_SND_SOC_TLV320DAC33=y
CONFIG_SND_SOC_TWL4030=y
CONFIG_SND_SOC_TWL6040=y
CONFIG_SND_SOC_UDA134X=y
CONFIG_SND_SOC_UDA1380=y
CONFIG_SND_SOC_WL1273=y
CONFIG_SND_SOC_WM0010=y
CONFIG_SND_SOC_WM1250_EV1=y
CONFIG_SND_SOC_WM2000=y
CONFIG_SND_SOC_WM2200=y
CONFIG_SND_SOC_WM5100=y
CONFIG_SND_SOC_WM5102=y
CONFIG_SND_SOC_WM8350=y
CONFIG_SND_SOC_WM8510=y
CONFIG_SND_SOC_WM8523=y
CONFIG_SND_SOC_WM8580=y
CONFIG_SND_SOC_WM8711=y
CONFIG_SND_SOC_WM8727=y
CONFIG_SND_SOC_WM8728=y
CONFIG_SND_SOC_WM8731=y
CONFIG_SND_SOC_WM8737=y
CONFIG_SND_SOC_WM8741=y
CONFIG_SND_SOC_WM8750=y
CONFIG_SND_SOC_WM8753=y
CONFIG_SND_SOC_WM8770=y
CONFIG_SND_SOC_WM8776=y
CONFIG_SND_SOC_WM8782=y
CONFIG_SND_SOC_WM8804=y
CONFIG_SND_SOC_WM8900=y
CONFIG_SND_SOC_WM8903=y
CONFIG_SND_SOC_WM8904=y
CONFIG_SND_SOC_WM8940=y
CONFIG_SND_SOC_WM8955=y
CONFIG_SND_SOC_WM8960=y
CONFIG_SND_SOC_WM8961=y
CONFIG_SND_SOC_WM8962=y
CONFIG_SND_SOC_WM8971=y
CONFIG_SND_SOC_WM8974=y
CONFIG_SND_SOC_WM8978=y
CONFIG_SND_SOC_WM8983=y
CONFIG_SND_SOC_WM8985=y
CONFIG_SND_SOC_WM8988=y
CONFIG_SND_SOC_WM8990=y
CONFIG_SND_SOC_WM8991=y
CONFIG_SND_SOC_WM8993=y
CONFIG_SND_SOC_WM8994=y
CONFIG_SND_SOC_WM8995=y
CONFIG_SND_SOC_WM8996=y
CONFIG_SND_SOC_WM8997=y
CONFIG_SND_SOC_WM9081=y
CONFIG_SND_SOC_WM9090=y
CONFIG_SND_SOC_LM4857=y
CONFIG_SND_SOC_MAX9768=y
CONFIG_SND_SOC_MAX9877=y
CONFIG_SND_SOC_MC13783=y
CONFIG_SND_SOC_ML26124=y
CONFIG_SND_SOC_TPA6130A2=y
CONFIG_SND_SIMPLE_CARD=y
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=y

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
CONFIG_UHID=y
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
# CONFIG_HID_CHICONY is not set
CONFIG_HID_PRODIKEYS=y
# CONFIG_HID_CYPRESS is not set
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EMS_FF=y
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_EZKEY is not set
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
# CONFIG_HID_LENOVO_TPKBD is not set
# CONFIG_HID_LOGITECH is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
# CONFIG_HID_MONTEREY is not set
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=y
# CONFIG_HID_PICOLCD_FB is not set
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
# CONFIG_HID_PICOLCD_LCD is not set
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=y
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=y
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
# CONFIG_HID_ZYDACRON is not set
CONFIG_HID_SENSOR_HUB=y

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
# CONFIG_KEYSTONE_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_OMAP_CONTROL_USB is not set
# CONFIG_OMAP_USB3 is not set
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
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
# CONFIG_MSPRO_BLOCK is not set
CONFIG_MS_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
CONFIG_MEMSTICK_R592=y
# CONFIG_MEMSTICK_REALTEK_PCI is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_NET48XX=y
# CONFIG_LEDS_WRAP is not set
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
# CONFIG_LEDS_LP8788 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
# CONFIG_LEDS_PCA9685 is not set
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_WM8350=y
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_REGULATOR=y
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=y
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_ADP5520 is not set
# CONFIG_LEDS_DELL_NETBOOKS is not set
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_MAX8997=y
CONFIG_LEDS_LM355x=y
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
# CONFIG_INFINIBAND_MTHCA is not set
CONFIG_INFINIBAND_AMSO1100=y
# CONFIG_INFINIBAND_AMSO1100_DEBUG is not set
CONFIG_INFINIBAND_CXGB3=y
# CONFIG_INFINIBAND_CXGB3_DEBUG is not set
# CONFIG_INFINIBAND_CXGB4 is not set
# CONFIG_MLX4_INFINIBAND is not set
CONFIG_MLX5_INFINIBAND=y
# CONFIG_INFINIBAND_NES is not set
CONFIG_INFINIBAND_OCRDMA=y
# CONFIG_INFINIBAND_IPOIB is not set
CONFIG_INFINIBAND_SRP=y
# CONFIG_INFINIBAND_ISER is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
# CONFIG_RTC_INTF_PROC is not set
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=y
CONFIG_RTC_DRV_88PM80X=y
CONFIG_RTC_DRV_AS3722=y
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_DS3232=y
CONFIG_RTC_DRV_HYM8563=y
CONFIG_RTC_DRV_LP8788=y
# CONFIG_RTC_DRV_MAX6900 is not set
CONFIG_RTC_DRV_MAX8925=y
CONFIG_RTC_DRV_MAX8998=y
CONFIG_RTC_DRV_MAX8997=y
# CONFIG_RTC_DRV_MAX77686 is not set
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
CONFIG_RTC_DRV_ISL12057=y
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PALMAS is not set
CONFIG_RTC_DRV_PCF2127=y
CONFIG_RTC_DRV_PCF8523=y
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
CONFIG_RTC_DRV_M41T80_WDT=y
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_TWL4030=y
# CONFIG_RTC_DRV_RC5T583 is not set
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=y
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
CONFIG_RTC_DRV_R9701=y
CONFIG_RTC_DRV_RS5C348=y
CONFIG_RTC_DRV_DS3234=y
CONFIG_RTC_DRV_PCF2123=y
CONFIG_RTC_DRV_RX4581=y

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DA9055=y
CONFIG_RTC_DRV_STK17TA8=y
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
# CONFIG_RTC_DRV_V3020 is not set
CONFIG_RTC_DRV_DS2404=y
CONFIG_RTC_DRV_WM831X=y
# CONFIG_RTC_DRV_WM8350 is not set
CONFIG_RTC_DRV_PCF50633=y

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MC13XXX is not set
# CONFIG_RTC_DRV_SNVS is not set
# CONFIG_RTC_DRV_MOXART is not set

#
# HID Sensor RTC drivers
#
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
# CONFIG_KS0108 is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=y
# CONFIG_UIO_DMEM_GENIRQ is not set
# CONFIG_UIO_AEC is not set
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
# CONFIG_UIO_MF624 is not set
# CONFIG_VIRT_DRIVERS is not set
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
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=y
CONFIG_ACERHDF=y
CONFIG_ASUS_LAPTOP=y
CONFIG_DELL_LAPTOP=y
# CONFIG_DELL_WMI is not set
CONFIG_DELL_WMI_AIO=y
# CONFIG_FUJITSU_LAPTOP is not set
CONFIG_FUJITSU_TABLET=y
# CONFIG_AMILO_RFKILL is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_HP_ACCEL is not set
CONFIG_HP_WIRELESS=y
CONFIG_HP_WMI=y
CONFIG_MSI_LAPTOP=y
CONFIG_PANASONIC_LAPTOP=y
CONFIG_COMPAL_LAPTOP=y
# CONFIG_SONY_LAPTOP is not set
CONFIG_IDEAPAD_LAPTOP=y
CONFIG_THINKPAD_ACPI=y
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
CONFIG_THINKPAD_ACPI_DEBUGFACILITIES=y
CONFIG_THINKPAD_ACPI_DEBUG=y
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
# CONFIG_THINKPAD_ACPI_VIDEO is not set
# CONFIG_THINKPAD_ACPI_HOTKEY_POLL is not set
CONFIG_SENSORS_HDAPS=y
CONFIG_EEEPC_LAPTOP=y
CONFIG_ASUS_WMI=y
CONFIG_ASUS_NB_WMI=y
# CONFIG_EEEPC_WMI is not set
CONFIG_ACPI_WMI=y
CONFIG_MSI_WMI=y
CONFIG_TOPSTAR_LAPTOP=y
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_TOSHIBA_BT_RFKILL=y
CONFIG_ACPI_CMPC=y
CONFIG_INTEL_IPS=y
# CONFIG_IBM_RTL is not set
CONFIG_XO1_RFKILL=y
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=y
CONFIG_INTEL_OAKTRAIL=y
# CONFIG_SAMSUNG_Q10 is not set
CONFIG_APPLE_GMUX=y
# CONFIG_INTEL_RST is not set
CONFIG_INTEL_SMARTCONNECT=y
# CONFIG_PVPANIC is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
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
CONFIG_OF_EXTCON=y
# CONFIG_EXTCON_GPIO is not set
CONFIG_EXTCON_ADC_JACK=y
CONFIG_EXTCON_MAX14577=y
# CONFIG_EXTCON_MAX8997 is not set
CONFIG_EXTCON_ARIZONA=y
CONFIG_EXTCON_PALMAS=y
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
# CONFIG_BMA180 is not set
# CONFIG_HID_SENSOR_ACCEL_3D is not set
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y
CONFIG_IIO_ST_ACCEL_SPI_3AXIS=y
CONFIG_KXSD9=y

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
CONFIG_AD7266=y
CONFIG_AD7298=y
CONFIG_AD7476=y
CONFIG_AD7791=y
# CONFIG_AD7793 is not set
CONFIG_AD7887=y
CONFIG_AD7923=y
# CONFIG_EXYNOS_ADC is not set
# CONFIG_LP8788_ADC is not set
CONFIG_MAX1363=y
CONFIG_MCP320X=y
CONFIG_MCP3422=y
CONFIG_NAU7802=y
# CONFIG_TI_ADC081C is not set
CONFIG_TI_AM335X_ADC=y
CONFIG_TWL6030_GPADC=y

#
# Amplifiers
#
# CONFIG_AD8366 is not set

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
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
CONFIG_AD5624R_SPI=y
# CONFIG_AD5686 is not set
CONFIG_AD5755=y
CONFIG_AD5764=y
# CONFIG_AD5791 is not set
# CONFIG_AD7303 is not set
CONFIG_MAX517=y
CONFIG_MCP4725=y

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
# CONFIG_ADIS16080 is not set
# CONFIG_ADIS16130 is not set
# CONFIG_ADIS16136 is not set
CONFIG_ADIS16260=y
CONFIG_ADXRS450=y
# CONFIG_HID_SENSOR_GYRO_3D is not set
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_IIO_ST_GYRO_SPI_3AXIS=y
CONFIG_ITG3200=y

#
# Humidity sensors
#
# CONFIG_DHT11 is not set
CONFIG_SI7005=y

#
# Inertial measurement units
#
# CONFIG_ADIS16400 is not set
CONFIG_ADIS16480=y
# CONFIG_INV_MPU6050_IIO is not set
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
CONFIG_APDS9300=y
CONFIG_CM32181=y
CONFIG_CM36651=y
# CONFIG_GP2AP020A00F is not set
# CONFIG_HID_SENSOR_ALS is not set
CONFIG_SENSORS_LM3533=y
CONFIG_LTR501=y
# CONFIG_TCS3472 is not set
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_TSL4531 is not set
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
CONFIG_AK8975=y
# CONFIG_MAG3110 is not set
# CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
CONFIG_IIO_ST_MAGN_SPI_3AXIS=y

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=y

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure sensors
#
# CONFIG_MPL3115 is not set
# CONFIG_IIO_ST_PRESS is not set

#
# Temperature sensors
#
CONFIG_TMP006=y
CONFIG_NTB=y
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_LP3943=y
CONFIG_PWM_PCA9685=y
CONFIG_PWM_RENESAS_TPU=y
CONFIG_PWM_TWL=y
CONFIG_PWM_TWL_LED=y
CONFIG_IRQCHIP=y
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_EXYNOS_MIPI_VIDEO=y
CONFIG_PHY_EXYNOS_DP_VIDEO=y
# CONFIG_BCM_KONA_USB2_PHY is not set
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y

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
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_ISCSI_IBFT is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
# CONFIG_EFI_VARS is not set
# CONFIG_EFI_RUNTIME_MAP is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
# CONFIG_REISERFS_FS_POSIX_ACL is not set
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
CONFIG_XFS_DEBUG=y
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=y
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
CONFIG_OCFS2_DEBUG_FS=y
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
# CONFIG_ZISOFS is not set
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
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_VMCORE=y
# CONFIG_PROC_SYSCTL is not set
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=y
# CONFIG_ECRYPT_FS_MESSAGING is not set
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
CONFIG_HFSPLUS_FS_POSIX_ACL=y
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
# CONFIG_JFFS2_SUMMARY is not set
# CONFIG_JFFS2_FS_XATTR is not set
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
CONFIG_UBIFS_FS=y
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
CONFIG_LOGFS=y
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_FILE_CACHE=y
# CONFIG_SQUASHFS_FILE_DIRECT is not set
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZO is not set
# CONFIG_SQUASHFS_XZ is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
# CONFIG_QNX6FS_FS is not set
CONFIG_ROMFS_FS=y
# CONFIG_ROMFS_BACKED_BY_BLOCK is not set
CONFIG_ROMFS_BACKED_BY_MTD=y
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
CONFIG_PSTORE_FTRACE=y
CONFIG_PSTORE_RAM=y
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=y
CONFIG_UFS_FS_WRITE=y
# CONFIG_UFS_DEBUG is not set
CONFIG_F2FS_FS=y
# CONFIG_F2FS_STAT_FS is not set
# CONFIG_F2FS_FS_XATTR is not set
CONFIG_F2FS_CHECK_FS=y
CONFIG_EFIVAR_FS=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_CEPH_FS=y
CONFIG_CEPH_FS_POSIX_ACL=y
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
CONFIG_CODA_FS=y
# CONFIG_AFS_FS is not set
# CONFIG_9P_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
# CONFIG_DLM_DEBUG is not set

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
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
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
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=y
CONFIG_DEBUG_HIGHMEM=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
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
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_TRACE_IRQFLAGS=y
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
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
# CONFIG_FAULT_INJECTION is not set
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
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
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
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_TRUSTED_KEYS=y
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
CONFIG_SECURITY_YAMA=y
CONFIG_SECURITY_YAMA_STACKED=y
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
# CONFIG_IMA_TEMPLATE is not set
# CONFIG_IMA_NG_TEMPLATE is not set
CONFIG_IMA_SIG_TEMPLATE=y
CONFIG_IMA_DEFAULT_TEMPLATE="ima-sig"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
# CONFIG_IMA_DEFAULT_HASH_SHA256 is not set
# CONFIG_IMA_DEFAULT_HASH_WP512 is not set
CONFIG_IMA_DEFAULT_HASH="sha1"
# CONFIG_IMA_APPRAISE is not set
CONFIG_EVM=y
CONFIG_EVM_HMAC_VERSION=2
CONFIG_DEFAULT_SECURITY_SMACK=y
# CONFIG_DEFAULT_SECURITY_YAMA is not set
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="smack"
CONFIG_XOR_BLOCKS=y
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
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER=y
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
# CONFIG_CRYPTO_CMAC is not set
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
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_CRYPTO_DEV_GEODE=y
CONFIG_CRYPTO_DEV_HIFN_795X=y
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
CONFIG_CRYPTO_DEV_CCP=y
# CONFIG_CRYPTO_DEV_CCP_DD is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
# CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE is not set
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
CONFIG_KVM_AMD=y
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_LGUEST=y
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
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
# CONFIG_CRC64_ECMA is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_BTREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
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
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_UCS2_STRING=y

--qOrJKOH36bD5yhNe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--qOrJKOH36bD5yhNe--
