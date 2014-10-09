Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaJICEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 22:04:24 -0400
Received: from mga03.intel.com ([134.134.136.65]:52878 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbaJICEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 22:04:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,682,1406617200"; 
   d="scan'208";a="585753229"
Date: Thu, 9 Oct 2014 10:04:10 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [mm] BUG: Int 6: CR2   (null)
Message-ID: <20141009020410.GA7968@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Marek,

FYI, we noticed the below changes on

git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
commit 478e86d7c8c5f41e29abb81b05b459d24bdc71a2 ("mm: cma: adjust address l=
imit to avoid hitting low/high memory boundary")


+------------------------------------------+------------+------------+
|                                          | 81febe58a8 | 478e86d7c8 |
+------------------------------------------+------------+------------+
| boot_successes                           | 10         | 0          |
| boot_failures                            | 5          | 10         |
| kernel_BUG_at_arch/x86/mm/physaddr.c     | 5          |            |
| invalid_opcode                           | 5          |            |
| EIP_is_at__phys_addr                     | 5          |            |
| Kernel_panic-not_syncing:Fatal_exception | 5          |            |
| backtrace:vm_mmap_pgoff                  | 5          |            |
| backtrace:SyS_mmap_pgoff                 | 5          |            |
| BUG:Int_CR2(null)                        | 0          | 10         |
+------------------------------------------+------------+------------+

[    0.000000] BRK [0x025ee000, 0x025eefff] PGTABLE
[    0.000000] cma: dma_contiguous_reserve(limit 13ffe000)
[    0.000000] cma: dma_contiguous_reserve: reserving 31 MiB for global area
[    0.000000] BUG: Int 6: CR2   (null)
[    0.000000]      EDI c0000000  ESI   (null)  EBP 41c11ea4  EBX 425cc101
[    0.000000]      ESP 41c11e98   ES 0000007b   DS 0000007b
[    0.000000]      EDX 00000001  ECX   (null)  EAX 41cd8150
[    0.000000]      vec 00000006  err   (null)  EIP 41072227   CS 00000060 =
 flg 00210002
[    0.000000] Stack: 425cc150   (null)   (null) 41c11ef4 41d4ee4d   (null)=
 13ffe000 41c11ec4
[    0.000000]        41c2d900   (null) 13ffe000   (null) 4185793e 0000002e=
 410c2982 41c11f00
[    0.000000]        410c2df5   (null)   (null)   (null) 425cc150 00013efe=
   (null) 41c11f28
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.17.0-next-20141008=
 #815
[    0.000000]  00000000 425cc101 41c11e48 41850786 41c11ea4 41d2b1db 41d95=
f71 00000006
[    0.000000]  00000000 c0000000 00000000 41c11ea4 425cc101 41c11e98 00000=
07b 0000007b
[    0.000000]  00000001 00000000 41cd8150 00000006 00000000 41072227 00000=
060 00210002
[    0.000000] Call Trace:
[    0.000000]  [<41850786>] dump_stack+0x16/0x18
[    0.000000]  [<41d2b1db>] early_idt_handler+0x6b/0x6b
[    0.000000]  [<41072227>] ? __phys_addr+0x2e/0xca
[    0.000000]  [<41d4ee4d>] cma_declare_contiguous+0x3c/0x2d7
[    0.000000]  [<4185793e>] ? _raw_spin_unlock_irqrestore+0x59/0x91
[    0.000000]  [<410c2982>] ? wake_up_klogd+0x8/0x33
[    0.000000]  [<410c2df5>] ? console_unlock+0x448/0x461
[    0.000000]  [<41d6d359>] dma_contiguous_reserve_area+0x27/0x47
[    0.000000]  [<41d6d4d1>] dma_contiguous_reserve+0x158/0x163
[    0.000000]  [<41d33e0f>] setup_arch+0x79b/0xc68
[    0.000000]  [<4184c0b4>] ? printk+0x1c/0x1e
[    0.000000]  [<41d2b7cf>] start_kernel+0x9c/0x456
[    0.000000]  [<41d2b2ca>] i386_start_kernel+0x79/0x7d

Elapsed time: 5
qemu-system-i386 -enable-kvm -kernel /kernel/i386-randconfig-hxb2-1008/0996=
69ed953121e1b00248f65326b6b092fa47c8/vmlinuz-3.17.0-next-20141008 -append '=
user=3Dlkp job=3D/lkp/scheduled/vm-kbuild-yocto-i386-58/rand_boot-1-yocto-m=
inimal-i386.cgz-i386-randconfig-hxb2-1008-099669ed953121e1b00248f65326b6b09=
2fa47c8-0.yaml ARCH=3Di386 BOOT_IMAGE=3D/kernel/i386-randconfig-hxb2-1008/0=
99669ed953121e1b00248f65326b6b092fa47c8/vmlinuz-3.17.0-next-20141008 kconfi=
g=3Di386-randconfig-hxb2-1008 commit=3D099669ed953121e1b00248f65326b6b092fa=
47c8 branch=3Dnext/master root=3D/dev/ram0 max_uptime=3D3600 RESULT_ROOT=3D=
/result/vm-kbuild-yocto-i386/boot/1/yocto-minimal-i386.cgz/i386-randconfig-=
hxb2-1008/099669ed953121e1b00248f65326b6b092fa47c8/0 ip=3D::::vm-kbuild-yoc=
to-i386-58::dhcp earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always=
_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D-1 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 =
console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal rw drbd.minor_count=3D8'=
  -initrd /fs/sdf1/initrd-vm-kbuild-yocto-i386-58 -m 320 -smp 2 -net nic,vl=
an=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchd=
og i6300esb -rtc base=3Dlocaltime -drive file=3D/fs/sdf1/disk0-vm-kbuild-yo=
cto-i386-58,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdf1/disk1-vm-kbuild=
-yocto-i386-58,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdf1/disk2-vm-kbu=
ild-yocto-i386-58,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdf1/disk3-vm-=
kbuild-yocto-i386-58,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdf1/disk4-=
vm-kbuild-yocto-i386-58,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdf1/dis=
k5-vm-kbuild-yocto-i386-58,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot=
/pid-vm-kbuild-yocto-i386-58 -serial file:/dev/shm/kboot/serial-vm-kbuild-y=
octo-i386-58 -daemonize -display none -monitor null=20



Thanks,
Fengguang

--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".dmesg"
Content-Transfer-Encoding: quoted-printable

Linux version 3.17.0-next-20141008 #815
Command line: user=3Dlkp job=3D/lkp/scheduled/vm-kbuild-yocto-i386-58/rand_=
boot-1-yocto-minimal-i386.cgz-i386-randconfig-hxb2-1008-099669ed953121e1b00=
248f65326b6b092fa47c8-0.yaml ARCH=3Di386 BOOT_IMAGE=3D/kernel/i386-randconf=
ig-hxb2-1008/099669ed953121e1b00248f65326b6b092fa47c8/vmlinuz-3.17.0-next-2=
0141008 kconfig=3Di386-randconfig-hxb2-1008 commit=3D099669ed953121e1b00248=
f65326b6b092fa47c8 branch=3Dnext/master root=3D/dev/ram0 max_uptime=3D3600 =
RESULT_ROOT=3D/result/vm-kbuild-yocto-i386/boot/1/yocto-minimal-i386.cgz/i3=
86-randconfig-hxb2-1008/099669ed953121e1b00248f65326b6b092fa47c8/0 ip=3D:::=
:vm-kbuild-yocto-i386-58::dhcp earlyprintk=3DttyS0,115200 debug apic=3Ddebu=
g sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D-1 soft=
lockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_=
ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal rw drbd.mino=
r_count=3D8

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-next-20141008 (kbuild@lkp-hsx02) (gcc v=
ersion 4.9.1 (Debian 4.9.1-11) ) #815 Wed Oct 8 16:03:07 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
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
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[400fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x033fffff]
[    0.000000] Base memory trampoline at [4009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x025ed000, 0x025edfff] PGTABLE
[    0.000000] BRK [0x025ee000, 0x025eefff] PGTABLE
[    0.000000] cma: dma_contiguous_reserve(limit 13ffe000)
[    0.000000] cma: dma_contiguous_reserve: reserving 31 MiB for global area
[    0.000000] BUG: Int 6: CR2   (null)
[    0.000000]      EDI c0000000  ESI   (null)  EBP 41c11ea4  EBX 425cc101
[    0.000000]      ESP 41c11e98   ES 0000007b   DS 0000007b
[    0.000000]      EDX 00000001  ECX   (null)  EAX 41cd8150
[    0.000000]      vec 00000006  err   (null)  EIP 41072227   CS 00000060 =
 flg 00210002
[    0.000000] Stack: 425cc150   (null)   (null) 41c11ef4 41d4ee4d   (null)=
 13ffe000 41c11ec4
[    0.000000]        41c2d900   (null) 13ffe000   (null) 4185793e 0000002e=
 410c2982 41c11f00
[    0.000000]        410c2df5   (null)   (null)   (null) 425cc150 00013efe=
   (null) 41c11f28
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.17.0-next-20141008=
 #815
[    0.000000]  00000000 425cc101 41c11e48 41850786 41c11ea4 41d2b1db 41d95=
f71 00000006
[    0.000000]  00000000 c0000000 00000000 41c11ea4 425cc101 41c11e98 00000=
07b 0000007b
[    0.000000]  00000001 00000000 41cd8150 00000006 00000000 41072227 00000=
060 00210002
[    0.000000] Call Trace:
[    0.000000]  [<41850786>] dump_stack+0x16/0x18
[    0.000000]  [<41d2b1db>] early_idt_handler+0x6b/0x6b
[    0.000000]  [<41072227>] ? __phys_addr+0x2e/0xca
[    0.000000]  [<41d4ee4d>] cma_declare_contiguous+0x3c/0x2d7
[    0.000000]  [<4185793e>] ? _raw_spin_unlock_irqrestore+0x59/0x91
[    0.000000]  [<410c2982>] ? wake_up_klogd+0x8/0x33
[    0.000000]  [<410c2df5>] ? console_unlock+0x448/0x461
[    0.000000]  [<41d6d359>] dma_contiguous_reserve_area+0x27/0x47
[    0.000000]  [<41d6d4d1>] dma_contiguous_reserve+0x158/0x163
[    0.000000]  [<41d33e0f>] setup_arch+0x79b/0xc68
[    0.000000]  [<4184c0b4>] ? printk+0x1c/0x1e
[    0.000000]  [<41d2b7cf>] start_kernel+0x9c/0x456
[    0.000000]  [<41d2b2ca>] i386_start_kernel+0x79/0x7d

Elapsed time: 5
qemu-system-i386 -enable-kvm -kernel /kernel/i386-randconfig-hxb2-1008/0996=
69ed953121e1b00248f65326b6b092fa47c8/vmlinuz-3.17.0-next-20141008 -append '=
user=3Dlkp job=3D/lkp/scheduled/vm-kbuild-yocto-i386-58/rand_boot-1-yocto-m=
inimal-i386.cgz-i386-randconfig-hxb2-1008-099669ed953121e1b00248f65326b6b09=
2fa47c8-0.yaml ARCH=3Di386 BOOT_IMAGE=3D/kernel/i386-randconfig-hxb2-1008/0=
99669ed953121e1b00248f65326b6b092fa47c8/vmlinuz-3.17.0-next-20141008 kconfi=
g=3Di386-randconfig-hxb2-1008 commit=3D099669ed953121e1b00248f65326b6b092fa=
47c8 branch=3Dnext/master root=3D/dev/ram0 max_uptime=3D3600 RESULT_ROOT=3D=
/result/vm-kbuild-yocto-i386/boot/1/yocto-minimal-i386.cgz/i386-randconfig-=
hxb2-1008/099669ed953121e1b00248f65326b6b092fa47c8/0 ip=3D::::vm-kbuild-yoc=
to-i386-58::dhcp earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always=
_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D-1 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 =
console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal rw drbd.minor_count=3D8'=
  -initrd /fs/sdf1/initrd-vm-kbuild-yocto-i386-58 -m 320 -smp 2 -net nic,vl=
an=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchd=
og i6300esb -rtc base=3Dlocaltime -drive file=3D/fs/sdf1/disk0-vm-kbuild-yo=
cto-i386-58,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdf1/disk1-vm-kbuild=
-yocto-i386-58,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdf1/disk2-vm-kbu=
ild-yocto-i386-58,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdf1/disk3-vm-=
kbuild-yocto-i386-58,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdf1/disk4-=
vm-kbuild-yocto-i386-58,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdf1/dis=
k5-vm-kbuild-yocto-i386-58,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot=
/pid-vm-kbuild-yocto-i386-58 -serial file:/dev/shm/kboot/serial-vm-kbuild-y=
octo-i386-58 -daemonize -display none -monitor null=20

--n8g4imXOkfNTN/H1--
