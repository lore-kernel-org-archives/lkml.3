Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbaG3O3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:29:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:53782 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbaG3O3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:29:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,764,1400050800"; 
   d="log'?scan'208";a="569470356"
Date: Wed, 30 Jul 2014 22:29:23 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: [x86_64,vsyscall] Kernel panic - not syncing: Attempted to kill
 init! exitcode=0x0000000b
Message-ID: <20140730142923.GR16537@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0WGqsT62A4RTsSXf"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0WGqsT62A4RTsSXf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git x86/vsyscall
commit 442aba0c6131f0c41dfc5edb6bfb88335556523f
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Mon Jun 16 18:50:12 2014 -0700
Commit:     Andy Lutomirski <luto@amacapital.net>
CommitDate: Mon Jun 30 14:32:44 2014 -0700

    x86_64,vsyscall: Make vsyscall emulation configurable
   =20
    This adds CONFIG_X86_VSYSCALL_EMULATION, guarded by CONFIG_EXPERT.
    Turning it off completely disables vsyscall emulation, saving ~3.5k
    for vsyscall_64.c, 4k for vsyscall_emu_64.S (the fake vsyscall
    page), some tiny amount of core mm code that supports a gate area,
    and possibly 4k for a wasted pagetable.  The latter is because the
    vsyscall addresses are misaligned and fit poorly in the fixmap.
   =20
    Signed-off-by: Andy Lutomirski <luto@amacapital.net>

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Attached dmesg for the parent commit, too, to help confirm whether it is a =
noise error.

+-----------------------------------------------------------+------------+-=
-----------+------------------+
|                                                           | e1656ab2ad | =
442aba0c61 | v3.16-rc4_071018 |
+-----------------------------------------------------------+------------+-=
-----------+------------------+
| boot_successes                                            | 1160       | =
99         | 3                |
| boot_failures                                             | 160        | =
231        | 8                |
| BUG:kernel_boot_hang                                      | 160        | =
51         | 2                |
| Kernel_panic-not_syncing:Attempted_to_kill_init_exitcode=3D | 0          =
| 180        | 6                |
| INFO:suspicious_RCU_usage                                 | 0          | =
180        | 6                |
+-----------------------------------------------------------+------------+-=
-----------+------------------+

mount: can't read '/proc/mounts': No such file or directory
[   33.736413] init[1]: segfault at ffffffffff600400 ip ffffffffff600400 sp=
 00007fff2894a8a8 error 15
[   33.737608] init[1]: segfault at ffffffffff600400 ip ffffffffff600400 sp=
 00007fff28949eb8 error 15
[   33.739046] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x0000000b
[   33.739046]=20
[   33.740015] CPU: 0 PID: 1 Comm: init Not tainted 3.16.0-rc3-00010-g442ab=
a0 #4
[   33.740015]  0000000000000000 ffff880000033cc0 ffffffff81ff485f ffff8800=
00033d38
[   33.740015]  ffffffff81ff1342 ffff880000000010 ffff880000033d48 ffff8800=
00033ce8
[   33.740015]  ffffffff82c440c0 000000000000000b 8c6318c6318c6320 00000007=
db00a678
[   33.740015] Call Trace:
[   33.740015]  [<ffffffff81ff485f>] dump_stack+0x19/0x1b
[   33.740015]  [<ffffffff81ff1342>] panic+0xcb/0x1fb
[   33.740015]  [<ffffffff81093b2f>] do_exit+0x3dd/0x80f
[   33.740015]  [<ffffffff810b071d>] ? local_clock+0x14/0x1d
[   33.740015]  [<ffffffff81094002>] do_group_exit+0x75/0xb4
[   33.740015]  [<ffffffff8109c7e7>] get_signal_to_deliver+0x48a/0x4aa
[   33.740015]  [<ffffffff8100231a>] do_signal+0x43/0x5ba
[   33.740015]  [<ffffffff810b4b79>] ? lock_release_holdtime+0x6c/0x77
[   33.740015]  [<ffffffff810b83b5>] ? lock_release_non_nested+0xd0/0x21e
[   33.740015]  [<ffffffff810b0646>] ? sched_clock_cpu+0x4e/0x62
[   33.740015]  [<ffffffff810fd465>] ? might_fault+0x4f/0x9c
[   33.740015]  [<ffffffff810b6163>] ? trace_hardirqs_off_caller+0x36/0xa5
[   33.740015]  [<ffffffff82004298>] ? retint_signal+0x11/0x99
[   33.740015]  [<ffffffff810028b5>] do_notify_resume+0x24/0x53
[   33.740015]  [<ffffffff820042d4>] retint_signal+0x4d/0x99
[   33.740015] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range=
: 0xffffffff80000000-0xffffffff9fffffff)
[   33.740015] drm_kms_helper: panic occurred, switching back to text conso=
le
[   33.740015]=20
[   33.740015] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   33.740015] [ INFO: suspicious RCU usage. ]
[   33.740015] 3.16.0-rc3-00010-g442aba0 #4 Not tainted
[   33.740015] -------------------------------
[   33.740015] include/linux/rcupdate.h:539 Illegal context switch in RCU r=
ead-side critical section!
[   33.740015]=20
[   33.740015] other info that might help us debug this:
[   33.740015]=20
[   33.740015]=20
[   33.740015] rcu_scheduler_active =3D 1, debug_locks =3D 0
[   33.740015] 3 locks held by init/1:
[   33.740015]  #0:  (panic_lock){....+.}, at: [<ffffffff81ff12ba>] panic+0=
x43/0x1fb
[   33.740015]  #1:  (rcu_read_lock){......}, at: [<ffffffff810ab879>] rcu_=
lock_acquire+0x0/0x23
[   33.740015]  #2:  (&dev->mode_config.mutex){+.+.+.}, at: [<ffffffff814a7=
4d7>] drm_fb_helper_panic+0x5d/0xab
[   33.740015]=20
[   33.740015] stack backtrace:
[   33.740015] CPU: 0 PID: 1 Comm: init Not tainted 3.16.0-rc3-00010-g442ab=
a0 #4
[   33.740015]  0000000000000000 ffff8800000339d0 ffffffff81ff485f ffff8800=
00033a00
[   33.740015]  ffffffff810b8824 ffffffff82836248 000000000000024a 00000000=
00000000
[   33.740015]  ffff88001012e008 ffff880000033a10 ffffffff810adce3 ffff8800=
00033a38
[   33.740015] Call Trace:
[   33.740015]  [<ffffffff81ff485f>] dump_stack+0x19/0x1b
[   33.740015]  [<ffffffff810b8824>] lockdep_rcu_suspicious+0xf6/0xff
[   33.740015]  [<ffffffff810adce3>] rcu_preempt_sleep_check+0x45/0x47
[   33.740015]  [<ffffffff810afedf>] __might_sleep+0x17/0x19a
[   33.740015]  [<ffffffff8200019e>] mutex_lock_nested+0x2e/0x369
[   33.740015]  [<ffffffff810b8657>] ? lock_release+0x154/0x185
[   33.740015]  [<ffffffff810b61df>] ? trace_hardirqs_off+0xd/0xf
[   33.740015]  [<ffffffff814b4ad3>] _object_find+0x25/0x6c
[   33.740015]  [<ffffffff814b5283>] drm_mode_object_find+0x38/0x53
[   33.740015]  [<ffffffff81593f6e>] cirrus_connector_best_encoder+0x21/0x2f
[   33.740015]  [<ffffffff814a5382>] drm_crtc_helper_set_config+0x38c/0x83c
[   33.740015]  [<ffffffff814b6c44>] drm_mode_set_config_internal+0x53/0xca
[   33.740015]  [<ffffffff814a731f>] restore_fbdev_mode+0x91/0xad
[   33.740015]  [<ffffffff814a74e3>] drm_fb_helper_panic+0x69/0xab
[   33.740015]  [<ffffffff810ab92c>] notifier_call_chain+0x61/0x8b
[   33.740015]  [<ffffffff810aba4f>] __atomic_notifier_call_chain+0x7e/0xe6
[   33.740015]  [<ffffffff810abac6>] atomic_notifier_call_chain+0xf/0x11
[   33.740015]  [<ffffffff81ff1367>] panic+0xf0/0x1fb
[   33.740015]  [<ffffffff81093b2f>] do_exit+0x3dd/0x80f
[   33.740015]  [<ffffffff810b071d>] ? local_clock+0x14/0x1d
[   33.740015]  [<ffffffff81094002>] do_group_exit+0x75/0xb4
[   33.740015]  [<ffffffff8109c7e7>] get_signal_to_deliver+0x48a/0x4aa
[   33.740015]  [<ffffffff8100231a>] do_signal+0x43/0x5ba
[   33.740015]  [<ffffffff810b4b79>] ? lock_release_holdtime+0x6c/0x77
[   33.740015]  [<ffffffff810b83b5>] ? lock_release_non_nested+0xd0/0x21e
[   33.740015]  [<ffffffff810b0646>] ? sched_clock_cpu+0x4e/0x62
[   33.740015]  [<ffffffff810fd465>] ? might_fault+0x4f/0x9c
[   33.740015]  [<ffffffff810b6163>] ? trace_hardirqs_off_caller+0x36/0xa5
[   33.740015]  [<ffffffff82004298>] ? retint_signal+0x11/0x99
[   33.740015]  [<ffffffff810028b5>] do_notify_resume+0x24/0x53
[   33.740015]  [<ffffffff820042d4>] retint_signal+0x4d/0x99
[   33.740015] Rebooting in 10 seconds..
Elapsed time: 40
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-hsxa0-07110255/442aba0c6131f0c41dfc5edb6bfb88335556523f/vmlinuz-3.16.0-rc3=
-00010-g442aba0 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 deb=
ug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 p=
anic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 con=
sole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-07110255/linux-devel=
:devel-hourly-2014071018:442aba0c6131f0c41dfc5edb6bfb88335556523f:bisect-li=
nux9/.vmlinuz-442aba0c6131f0c41dfc5edb6bfb88335556523f-20140711073043-10-iv=
b41 branch=3Dlinux-devel/devel-hourly-2014071018 BOOT_IMAGE=3D/kernel/x86_6=
4-randconfig-hsxa0-07110255/442aba0c6131f0c41dfc5edb6bfb88335556523f/vmlinu=
z-3.16.0-rc3-00010-g442aba0 drbd.minor_count=3D8'  -initrd /kernel-tests/in=
itrd/yocto-minimal-x86_64.cgz -m 320 -smp 1 -net nic,vlan=3D1,model=3De1000=
 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc bas=
e=3Dlocaltime -pidfile /dev/shm/kboot/pid-yocto-ivb41-17 -serial file:/dev/=
shm/kboot/serial-yocto-ivb41-17 -daemonize -display none -monitor null=20

git bisect start c80be3ae11770011071103d3e920864c275472a8 cd3de83f147601356=
395b57a8673e9c5ff1e59d1 --
git bisect  bad 6e36d433610a3ebfdef000f1fb283e3f218a8a32  # 20:54      0-  =
   19  Merge 'omap/omap-for-v3.16/fixes' into devel-hourly-2014071018
git bisect  bad 14604ab36faba88a89cb2c9611509f5a1c1cac21  # 20:54      0-  =
  222  Merge 'ulf.hansson-mmc/next' into devel-hourly-2014071018
git bisect good 9141a68d71aa193f78aac5306fc728fba8fb59f4  # 21:50    330+  =
   94  Merge 'm68k/for-linus' into devel-hourly-2014071018
git bisect  bad 13987d1746951b727146fef187406b7be00a3fd0  # 22:12      0-  =
    7  Merge 'luto/x86/vsyscall' into devel-hourly-2014071018
git bisect good 7104a2e08de8bddb52d4714fad63d8a7977ea7f2  # 23:19    330+  =
   22  x86_64: Move getcpu code from vsyscall_64.c to vdso/vma.c
git bisect good e1656ab2adfd1891f62610abe3e85ad992ee0cbf  # 23:26    330+  =
  113  arm64,ia64,ppc,s390,sh,tile,um,x86,mm: Remove default gate area
git bisect  bad 465c34985bb9823bb4536eb6751197f2d295ca32  # 23:29     54-  =
   91  x86,vdso: Set VM_MAYREAD for the vvar vma
git bisect  bad 442aba0c6131f0c41dfc5edb6bfb88335556523f  # 23:31      0-  =
   37  x86_64,vsyscall: Make vsyscall emulation configurable
# first bad commit: [442aba0c6131f0c41dfc5edb6bfb88335556523f] x86_64,vsysc=
all: Make vsyscall emulation configurable
git bisect good e1656ab2adfd1891f62610abe3e85ad992ee0cbf  # 12:09    990+  =
  160  arm64,ia64,ppc,s390,sh,tile,um,x86,mm: Remove default gate area
git bisect  bad c80be3ae11770011071103d3e920864c275472a8  # 12:10      0-  =
    8  0day head guard for 'devel-hourly-2014071018'
git bisect good 85d90faed31ec74fb28a450fbc368d982a785924  # 13:11    990+  =
  518  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/li=
nux
git bisect good 47cf0ce945c8310228ff2d4bd756e5313f4659c1  # 13:21    990+  =
  418  Add linux-next specific files for 20140710



Thanks,
Fengguang

--0WGqsT62A4RTsSXf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-ivb41-17:20140710233048:x86_64-randconfig-hsxa0-07110255::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Linux version 3.16.0-rc3-00010-g442aba0 (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #4 Fri Jul 11 07:30:28 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-07110255/linux-dev=
el:devel-hourly-2014071018:442aba0c6131f0c41dfc5edb6bfb88335556523f:bisect-=
linux9/.vmlinuz-442aba0c6131f0c41dfc5edb6bfb88335556523f-20140711073043-10-=
ivb41 branch=3Dlinux-devel/devel-hourly-2014071018 BOOT_IMAGE=3D/kernel/x86=
_64-randconfig-hsxa0-07110255/442aba0c6131f0c41dfc5edb6bfb88335556523f/vmli=
nuz-3.16.0-rc3-00010-g442aba0 drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0ed0-0x000f0edf] mapped at =
[ffff8800000f0ed0]
[    0.000000]   mpc: f0ee0-f0fb0
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03efb000, 0x03efbfff] PGTABLE
[    0.000000] BRK [0x03efc000, 0x03efcfff] PGTABLE
[    0.000000] BRK [0x03efd000, 0x03efdfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 4k
[    0.000000] BRK [0x03efe000, 0x03efefff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 4k
[    0.000000] BRK [0x03eff000, 0x03efffff] PGTABLE
[    0.000000] BRK [0x03f00000, 0x03f00fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] cma: CMA: reserved 32 MiB at 11800000
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0D50 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFFBC1 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFF1C0 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE040 001180 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FFE000 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF234 0008DD (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFFB11 000078 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFFB89 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff7fc000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA32 zone: 1280 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 81820 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff7fc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
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
[    0.000000] mapped IOAPIC to ffffffffff7fb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 2c3a040
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-07110255/li=
nux-devel:devel-hourly-2014071018:442aba0c6131f0c41dfc5edb6bfb88335556523f:=
bisect-linux9/.vmlinuz-442aba0c6131f0c41dfc5edb6bfb88335556523f-20140711073=
043-10-ivb41 branch=3Dlinux-devel/devel-hourly-2014071018 BOOT_IMAGE=3D/ker=
nel/x86_64-randconfig-hsxa0-07110255/442aba0c6131f0c41dfc5edb6bfb8833555652=
3f/vmlinuz-3.16.0-rc3-00010-g442aba0 drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 235228K/327280K available (16414K kernel code, 4000K=
 rwdata, 8528K rodata, 780K init, 14644K bss, 92052K reserved)
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] Linux version 3.16.0-rc3-00010-g442aba0 (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #4 Fri Jul 11 07:30:28 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-07110255/linux-dev=
el:devel-hourly-2014071018:442aba0c6131f0c41dfc5edb6bfb88335556523f:bisect-=
linux9/.vmlinuz-442aba0c6131f0c41dfc5edb6bfb88335556523f-20140711073043-10-=
ivb41 branch=3Dlinux-devel/devel-hourly-2014071018 BOOT_IMAGE=3D/kernel/x86=
_64-randconfig-hsxa0-07110255/442aba0c6131f0c41dfc5edb6bfb88335556523f/vmli=
nuz-3.16.0-rc3-00010-g442aba0 drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0ed0-0x000f0edf] mapped at =
[ffff8800000f0ed0]
[    0.000000]   mpc: f0ee0-f0fb0
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03efb000, 0x03efbfff] PGTABLE
[    0.000000] BRK [0x03efc000, 0x03efcfff] PGTABLE
[    0.000000] BRK [0x03efd000, 0x03efdfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 4k
[    0.000000] BRK [0x03efe000, 0x03efefff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 4k
[    0.000000] BRK [0x03eff000, 0x03efffff] PGTABLE
[    0.000000] BRK [0x03f00000, 0x03f00fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] cma: CMA: reserved 32 MiB at 11800000
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0D50 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFFBC1 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFF1C0 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE040 001180 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FFE000 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF234 0008DD (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFFB11 000078 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFFB89 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff7fc000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA32 zone: 1280 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 81820 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff7fc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
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
[    0.000000] mapped IOAPIC to ffffffffff7fb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 2c3a040
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-07110255/li=
nux-devel:devel-hourly-2014071018:442aba0c6131f0c41dfc5edb6bfb88335556523f:=
bisect-linux9/.vmlinuz-442aba0c6131f0c41dfc5edb6bfb88335556523f-20140711073=
043-10-ivb41 branch=3Dlinux-devel/devel-hourly-2014071018 BOOT_IMAGE=3D/ker=
nel/x86_64-randconfig-hsxa0-07110255/442aba0c6131f0c41dfc5edb6bfb8833555652=
3f/vmlinuz-3.16.0-rc3-00010-g442aba0 drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 235228K/327280K available (16414K kernel code, 4000K=
 rwdata, 8528K rodata, 780K init, 14644K bss, 92052K reserved)
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
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
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8671 kB
[    0.000000]  memory used by lock dependency info: 8671 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value..=20
[    0.020000] Calibrating delay loop (skipped) preset value.. 5387.01 Bogo=
MIPS (lpj=3D26935080)
5387.01 BogoMIPS (lpj=3D26935080)
[    0.020000] pid_max: default: 4096 minimum: 301
[    0.020000] pid_max: default: 4096 minimum: 301
[    0.020000] ACPI: Core revision 20140424
[    0.020000] ACPI: Core revision 20140424
[    0.024389] ACPI:=20
[    0.024389] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.025984] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.025984] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.027713] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.027713] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.030333] mce: CPU supports 10 MCE banks
[    0.030333] mce: CPU supports 10 MCE banks
[    0.031469] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.031469] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.031469] tlb_flushall_shift: 6
[    0.031469] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.031469] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.031469] tlb_flushall_shift: 6
[    0.035373] CPU:=20
[    0.035373] CPU: Intel Intel Common KVM processorCommon KVM processor (f=
am: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.039072] Performance Events:=20
[    0.039072] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.045269] Getting VERSION: 1050014
[    0.045269] Getting VERSION: 1050014
[    0.046235] Getting VERSION: 1050014
[    0.046235] Getting VERSION: 1050014
[    0.047169] Getting ID: 0
[    0.047169] Getting ID: 0
[    0.047878] Getting ID: ff000000
[    0.047878] Getting ID: ff000000
[    0.048897] Getting LVT0: 8700
[    0.048897] Getting LVT0: 8700
[    0.050012] Getting LVT1: 8400
[    0.050012] Getting LVT1: 8400
[    0.050770] enabled ExtINT on CPU#0
[    0.050770] enabled ExtINT on CPU#0
[    0.052508] ENABLING IO-APIC IRQs
[    0.052508] ENABLING IO-APIC IRQs
[    0.053359] init IO_APIC IRQs
[    0.053359] init IO_APIC IRQs
[    0.054144]  apic 0 pin 0 not connected
[    0.054144]  apic 0 pin 0 not connected
[    0.055198] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.055198] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.057266] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.057266] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.059318] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.059318] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.060036] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.060036] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.062102] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.062102] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.064136] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.064136] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.066010] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.066010] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.067906] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.067906] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.070044] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.070044] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.072028] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.072028] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.074112] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.074112] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.076665] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.076665] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.080048] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.080048] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.082958] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.082958] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.085763] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.085763] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.088129]  apic 0 pin 16 not connected
[    0.088129]  apic 0 pin 16 not connected
[    0.090013]  apic 0 pin 17 not connected
[    0.090013]  apic 0 pin 17 not connected
[    0.091163]  apic 0 pin 18 not connected
[    0.091163]  apic 0 pin 18 not connected
[    0.092799]  apic 0 pin 19 not connected
[    0.092799]  apic 0 pin 19 not connected
[    0.093939]  apic 0 pin 20 not connected
[    0.093939]  apic 0 pin 20 not connected
[    0.095076]  apic 0 pin 21 not connected
[    0.095076]  apic 0 pin 21 not connected
[    0.096221]  apic 0 pin 22 not connected
[    0.096221]  apic 0 pin 22 not connected
[    0.097376]  apic 0 pin 23 not connected
[    0.097376]  apic 0 pin 23 not connected
[    0.100162] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.100162] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.101866] Using local APIC timer interrupts.
[    0.101866] calibrating APIC timer ...
[    0.101866] Using local APIC timer interrupts.
[    0.101866] calibrating APIC timer ...
[    0.110000] ... lapic delta =3D 6249353
[    0.110000] ... lapic delta =3D 6249353
[    0.110000] ... PM-Timer delta =3D 357911
[    0.110000] ... PM-Timer delta =3D 357911
[    0.110000] ... PM-Timer result ok
[    0.110000] ... PM-Timer result ok
[    0.110000] ..... delta 6249353
[    0.110000] ..... delta 6249353
[    0.110000] ..... mult: 268407667
[    0.110000] ..... mult: 268407667
[    0.110000] ..... calibration result: 9998964
[    0.110000] ..... calibration result: 9998964
[    0.110000] ..... CPU clock speed is 2693.1843 MHz.
[    0.110000] ..... CPU clock speed is 2693.1843 MHz.
[    0.110000] ..... host bus clock speed is 999.8964 MHz.
[    0.110000] ..... host bus clock speed is 999.8964 MHz.
[    0.110000] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.110000] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.110000] devtmpfs: initialized
[    0.110000] devtmpfs: initialized
[    0.111973] xor: measuring software checksum speed
[    0.111973] xor: measuring software checksum speed
[    0.210009]    prefetch64-sse:  8760.000 MB/sec
[    0.210009]    prefetch64-sse:  8760.000 MB/sec
[    0.310008]    generic_sse:  7219.200 MB/sec
[    0.310008]    generic_sse:  7219.200 MB/sec
[    0.311103] xor: using function: prefetch64-sse (8760.000 MB/sec)
[    0.311103] xor: using function: prefetch64-sse (8760.000 MB/sec)
[    0.312625] prandom: seed boundary self test passed
[    0.312625] prandom: seed boundary self test passed
[    0.314438] prandom: 100 self tests passed
[    0.314438] prandom: 100 self tests passed
[    0.315473] atomic64_test: passed for x86-64 platform with CX8 and with =
SSE
[    0.315473] atomic64_test: passed for x86-64 platform with CX8 and with =
SSE
[    0.317813] regulator-dummy: no parameters
[    0.317813] regulator-dummy: no parameters
[    0.319971] NET: Registered protocol family 16
[    0.319971] NET: Registered protocol family 16
[    0.321641] cpuidle: using governor ladder
[    0.321641] cpuidle: using governor ladder
[    0.322681] cpuidle: using governor menu
[    0.322681] cpuidle: using governor menu
[    0.324728] ACPI: bus type PCI registered
[    0.324728] ACPI: bus type PCI registered
[    0.325838] dca service started, version 1.12.1
[    0.325838] dca service started, version 1.12.1
[    0.327041] PCI: Using configuration type 1 for base access
[    0.327041] PCI: Using configuration type 1 for base access
[    0.560013] raid6: sse2x1    4872 MB/s
[    0.560013] raid6: sse2x1    4872 MB/s
[    0.730018] raid6: sse2x2    6748 MB/s
[    0.730018] raid6: sse2x2    6748 MB/s
[    0.900009] raid6: sse2x4    6366 MB/s
[    0.900009] raid6: sse2x4    6366 MB/s
[    0.901021] raid6: using algorithm sse2x2 (6748 MB/s)
[    0.901021] raid6: using algorithm sse2x2 (6748 MB/s)
[    0.902342] raid6: using intx1 recovery algorithm
[    0.902342] raid6: using intx1 recovery algorithm
[    0.904101] ACPI: Added _OSI(Module Device)
[    0.904101] ACPI: Added _OSI(Module Device)
[    0.905263] ACPI: Added _OSI(Processor Device)
[    0.905263] ACPI: Added _OSI(Processor Device)
[    0.906428] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.906428] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.907582] ACPI: Added _OSI(Processor Aggregator Device)
[    0.907582] ACPI: Added _OSI(Processor Aggregator Device)
[    0.922402] ACPI: Interpreter enabled
[    0.922402] ACPI: Interpreter enabled
[    0.923461] ACPI: (supports S0 S4 S5)
[    0.923461] ACPI: (supports S0 S4 S5)
[    0.924460] ACPI: Using IOAPIC for interrupt routing
[    0.924460] ACPI: Using IOAPIC for interrupt routing
[    0.925884] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.925884] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.948320] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.948320] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.950018] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.950018] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.951620] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.951620] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.954315] PCI host bridge to bus 0000:00
[    0.954315] PCI host bridge to bus 0000:00
[    0.955436] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.955436] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.956907] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.956907] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.958564] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.958564] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.960009] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.960009] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.961659] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.961659] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.963313] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.963313] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.964981] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.964981] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.966834] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.966834] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.968750] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.968750] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.971096] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.971096] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.973796] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.973796] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.978463] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.978463] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.981191] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.981191] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.983117] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.983117] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.984867] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.984867] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.986769] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.986769] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.989188] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.989188] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.990505] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.990505] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.992449] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.992449] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.995073] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.995073] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.998246] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.998246] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.001432] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.001432] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.011412] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.011412] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.014175] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.014175] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.016930] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    1.016930] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    1.019679] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.019679] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.025302] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    1.025302] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    1.027787] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    1.027787] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    1.030611] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    1.030611] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    1.036699] pci_bus 0000:00: on NUMA node 0
[    1.036699] pci_bus 0000:00: on NUMA node 0
[    1.040531] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    1.040531] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    1.042546] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    1.042546] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    1.044542] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    1.044542] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    1.046542] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    1.046542] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    1.048337] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    1.048337] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    1.050747] ACPI:=20
[    1.050747] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    1.055439] SCSI subsystem initialized
[    1.055439] SCSI subsystem initialized
[    1.056552] libata version 3.00 loaded.
[    1.056552] libata version 3.00 loaded.
[    1.057856] ACPI: bus type USB registered
[    1.057856] ACPI: bus type USB registered
[    1.059114] usbcore: registered new interface driver usbfs
[    1.059114] usbcore: registered new interface driver usbfs
[    1.060079] usbcore: registered new interface driver hub
[    1.060079] usbcore: registered new interface driver hub
[    1.061634] usbcore: registered new device driver usb
[    1.061634] usbcore: registered new device driver usb
[    1.063421] pps_core: LinuxPPS API ver. 1 registered
[    1.063421] pps_core: LinuxPPS API ver. 1 registered
[    1.064770] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.064770] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.067229] PTP clock support registered
[    1.067229] PTP clock support registered
[    1.068893] wmi: Mapper loaded
[    1.068893] wmi: Mapper loaded
[    1.070328] PCI: Using ACPI for IRQ routing
[    1.070328] PCI: Using ACPI for IRQ routing
[    1.071466] PCI: pci_cache_line_size set to 64 bytes
[    1.071466] PCI: pci_cache_line_size set to 64 bytes
[    1.072962] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.072962] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.074598] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    1.074598] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    1.077028] irda_init()
[    1.077028] irda_init()
[    1.077714] NET: Registered protocol family 23
[    1.077714] NET: Registered protocol family 23
[    1.078857] Bluetooth: Core ver 2.19
[    1.078857] Bluetooth: Core ver 2.19
[    1.080054] NET: Registered protocol family 31
[    1.080054] NET: Registered protocol family 31
[    1.081152] Bluetooth: HCI device and connection manager initialized
[    1.081152] Bluetooth: HCI device and connection manager initialized
[    1.082713] Bluetooth: HCI socket layer initialized
[    1.082713] Bluetooth: HCI socket layer initialized
[    1.083921] Bluetooth: L2CAP socket layer initialized
[    1.083921] Bluetooth: L2CAP socket layer initialized
[    1.085250] Bluetooth: SCO socket layer initialized
[    1.085250] Bluetooth: SCO socket layer initialized
[    1.086556] NET: Registered protocol family 8
[    1.086556] NET: Registered protocol family 8
[    1.087700] NET: Registered protocol family 20
[    1.087700] NET: Registered protocol family 20
[    1.090284] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    1.090284] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    1.092344] Switched to clocksource kvm-clock
[    1.092344] Switched to clocksource kvm-clock
[    1.093850] pnp: PnP ACPI init
[    1.093850] pnp: PnP ACPI init
[    1.094757] ACPI: bus type PNP registered
[    1.094757] ACPI: bus type PNP registered
[    1.095912] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    1.095912] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    1.098178] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.098178] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.099956] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    1.099956] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    1.100000] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.100000] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.101747] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    1.101747] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    1.104017] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.104017] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.105862] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    1.105862] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    1.107971] pnp 00:03: [dma 2]
[    1.107971] pnp 00:03: [dma 2]
[    1.108942] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.108942] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.110802] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    1.110802] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    1.113042] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.113042] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.114981] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    1.114981] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    1.117237] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.117237] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.119995] pnp: PnP ACPI: found 6 devices
[    1.119995] pnp: PnP ACPI: found 6 devices
[    1.121106] ACPI: bus type PNP unregistered
[    1.121106] ACPI: bus type PNP unregistered
[    1.128956] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.128956] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.130452] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    1.130452] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    1.131922] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    1.131922] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    1.133388] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    1.133388] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    1.134867] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    1.134867] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    1.136330] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    1.136330] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    1.137979] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    1.137979] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    1.139705] NET: Registered protocol family 2
[    1.139705] NET: Registered protocol family 2
[    1.141222] TCP established hash table entries: 4096 (order: 3, 32768 by=
tes)
[    1.141222] TCP established hash table entries: 4096 (order: 3, 32768 by=
tes)
[    1.143183] TCP bind hash table entries: 4096 (order: 6, 327680 bytes)
[    1.143183] TCP bind hash table entries: 4096 (order: 6, 327680 bytes)
[    1.145312] TCP: Hash tables configured (established 4096 bind 4096)
[    1.145312] TCP: Hash tables configured (established 4096 bind 4096)
[    1.147030] TCP: reno registered
[    1.147030] TCP: reno registered
[    1.147914] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    1.147914] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    1.149539] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    1.149539] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    1.151493] NET: Registered protocol family 1
[    1.151493] NET: Registered protocol family 1
[    1.152676] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.152676] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.154248] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.154248] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.155793] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.155793] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.157435] pci 0000:00:02.0: Boot video device
[    1.157435] pci 0000:00:02.0: Boot video device
[    1.158669] PCI: CLS 0 bytes, default 64
[    1.158669] PCI: CLS 0 bytes, default 64
[    1.159999] Trying to unpack rootfs image as initramfs...
[    1.159999] Trying to unpack rootfs image as initramfs...
[    1.266952] debug: unmapping init [mem 0xffff880013ce6000-0xffff880013fe=
ffff]
[    1.266952] debug: unmapping init [mem 0xffff880013ce6000-0xffff880013fe=
ffff]
[    1.271178] Machine check injector initialized
[    1.271178] Machine check injector initialized
[    1.273541] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    1.273541] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    1.276138] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    1.276138] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    1.279410] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    1.279410] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    1.284291] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usab=
le.
[    1.284291] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usab=
le.
[    1.286313] PCLMULQDQ-NI instructions are not detected.
[    1.286313] PCLMULQDQ-NI instructions are not detected.
[    1.287857] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.287857] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.289699] AVX or AES-NI instructions are not detected.
[    1.289699] AVX or AES-NI instructions are not detected.
[    1.291263] AVX instructions are not detected.
[    1.291263] AVX instructions are not detected.
[    1.292551] AVX instructions are not detected.
[    1.292551] AVX instructions are not detected.
[    1.293840] AVX2 instructions are not detected.
[    1.293840] AVX2 instructions are not detected.
[    1.296426] Initializing RT-Tester: OK
[    1.296426] Initializing RT-Tester: OK
[    1.297554] spin_lock-torture:--- Start of test: nwriters_stress=3D2 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    1.297554] spin_lock-torture:--- Start of test: nwriters_stress=3D2 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    1.301961] spin_lock-torture: Creating torture_shuffle task
[    1.301961] spin_lock-torture: Creating torture_shuffle task
[    1.303686] spin_lock-torture: Creating torture_stutter task
[    1.303686] spin_lock-torture: Creating torture_stutter task
[    1.305346] spin_lock-torture: torture_shuffle task started
[    1.305346] spin_lock-torture: torture_shuffle task started
[    1.306965] spin_lock-torture: Creating lock_torture_writer task
[    1.306965] spin_lock-torture: Creating lock_torture_writer task
[    1.308732] spin_lock-torture: torture_stutter task started
[    1.308732] spin_lock-torture: torture_stutter task started
[    1.310365] spin_lock-torture: Creating lock_torture_writer task
[    1.310365] spin_lock-torture: Creating lock_torture_writer task
[    1.312129] spin_lock-torture: lock_torture_writer task started
[    1.312129] spin_lock-torture: lock_torture_writer task started
[    1.313862] spin_lock-torture: Creating lock_torture_stats task
[    1.313862] spin_lock-torture: Creating lock_torture_stats task
[    1.315593] spin_lock-torture: lock_torture_writer task started
[    1.315593] spin_lock-torture: lock_torture_writer task started
[    1.318532] futex hash table entries: 16 (order: -2, 1536 bytes)
[    1.318532] futex hash table entries: 16 (order: -2, 1536 bytes)
[    1.320290] Initialise system trusted keyring
[    1.320290] Initialise system trusted keyring
[    1.321940] spin_lock-torture: lock_torture_stats task started
[    1.321940] spin_lock-torture: lock_torture_stats task started
[    1.324555] ntfs: driver 2.1.30 [Flags: R/O DEBUG].
[    1.324555] ntfs: driver 2.1.30 [Flags: R/O DEBUG].
[    1.325886] fuse init (API version 7.23)
[    1.325886] fuse init (API version 7.23)
[    1.327379] SGI XFS with security attributes, realtime, large block/inod=
e numbers, debug enabled
[    1.327379] SGI XFS with security attributes, realtime, large block/inod=
e numbers, debug enabled
[    1.331260] gfs2: GFS2 installed
[    1.331260] gfs2: GFS2 installed
[    1.332239] ceph: loaded (mds proto 32)
[    1.332239] ceph: loaded (mds proto 32)
[    1.333355] msgmni has been set to 523
[    1.333355] msgmni has been set to 523
[    1.339850] alg: No test for crc32 (crc32-table)
[    1.339850] alg: No test for crc32 (crc32-table)
[    1.341594] alg: No test for lz4 (lz4-generic)
[    1.341594] alg: No test for lz4 (lz4-generic)
[    1.342980] alg: No test for stdrng (krng)
[    1.342980] alg: No test for stdrng (krng)
[    1.344318] NET: Registered protocol family 38
[    1.344318] NET: Registered protocol family 38
[    1.345597] async_tx: api initialized (async)
[    1.345597] async_tx: api initialized (async)
[    1.346892] Key type asymmetric registered
[    1.346892] Key type asymmetric registered
[    1.347986] Asymmetric key parser 'x509' registered
[    1.347986] Asymmetric key parser 'x509' registered
[    1.349433] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    1.349433] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    1.351443] io scheduler noop registered
[    1.351443] io scheduler noop registered
[    1.352482] io scheduler cfq registered (default)
[    1.352482] io scheduler cfq registered (default)
[    1.353732] list_sort_test: start testing list_sort()
[    1.353732] list_sort_test: start testing list_sort()
[    1.356602] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    1.356602] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    1.358070] crc32: self tests passed, processed 225944 bytes in 179791 n=
sec
[    1.358070] crc32: self tests passed, processed 225944 bytes in 179791 n=
sec
[    1.360291] crc32c: CRC_LE_BITS =3D 64
[    1.360291] crc32c: CRC_LE_BITS =3D 64
[    1.361296] crc32c: self tests passed, processed 225944 bytes in 88877 n=
sec
[    1.361296] crc32c: self tests passed, processed 225944 bytes in 88877 n=
sec
[    1.608517] crc32_combine: 8373 self tests passed
[    1.608517] crc32_combine: 8373 self tests passed
[    1.879499] crc32c_combine: 8373 self tests passed
[    1.879499] crc32c_combine: 8373 self tests passed
[    1.881075] xz_dec_test: module loaded
[    1.881075] xz_dec_test: module loaded
[    1.881996] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
249 0' and write .xz files to it.
[    1.881996] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
249 0' and write .xz files to it.
[    1.884667] rbtree testing
[    1.884667] rbtree testing -> 12206 cycles
 -> 12206 cycles
[    2.377274] augmented rbtree testing
[    2.377274] augmented rbtree testing -> 19355 cycles
 -> 19355 cycles
[    3.150581] tsc: Refined TSC clocksource calibration: 2693.511 MHz
[    3.150581] tsc: Refined TSC clocksource calibration: 2693.511 MHz
[    3.152495] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.152495] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.154118] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.154118] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.156556] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    3.156556] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    3.157985] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    3.157985] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    3.160458] rivafb_setup START
[    3.160458] rivafb_setup START
[    3.161388] nvidiafb_setup START
[    3.161388] nvidiafb_setup START
[    3.163127] vmlfb: initializing
[    3.163127] vmlfb: initializing
[    3.164064] Could not find Carillo Ranch MCH device.
[    3.164064] Could not find Carillo Ranch MCH device.
[    3.165781] hgafb: HGA card not detected.
[    3.165781] hgafb: HGA card not detected.
[    3.166853] hgafb: probe of hgafb.0 failed with error -22
[    3.166853] hgafb: probe of hgafb.0 failed with error -22
[    3.168775] usbcore: registered new interface driver udlfb
[    3.168775] usbcore: registered new interface driver udlfb
[    3.170309] usbcore: registered new interface driver smscufx
[    3.170309] usbcore: registered new interface driver smscufx
[    3.172073] ipmi message handler version 39.2
[    3.172073] ipmi message handler version 39.2
[    3.173356] ipmi device interface
[    3.173356] ipmi device interface
[    3.174357] IPMI System Interface driver.
[    3.174357] IPMI System Interface driver.
[    3.175582] ipmi_si: Adding default-specified kcs state machine
[    3.175582] ipmi_si: Adding default-specified kcs state machine

[    3.177204] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    3.177204] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    3.179814] ipmi_si: Interface detection failed
[    3.179814] ipmi_si: Interface detection failed
[    3.181092] ipmi_si: Adding default-specified smic state machine
[    3.181092] ipmi_si: Adding default-specified smic state machine

[    3.182696] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    3.182696] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    3.185403] ipmi_si: Interface detection failed
[    3.185403] ipmi_si: Interface detection failed
[    3.186581] ipmi_si: Adding default-specified bt state machine
[    3.186581] ipmi_si: Adding default-specified bt state machine

[    3.188156] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    3.188156] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    3.190778] ipmi_si: Interface detection failed
[    3.190778] ipmi_si: Interface detection failed
[    3.192205] ipmi_si: Unable to find any System Interface(s)
[    3.192205] ipmi_si: Unable to find any System Interface(s)
[    3.193809] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    3.193809] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    3.196386] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    3.196386] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    3.198334] ACPI: Power Button [PWRF]
[    3.198334] ACPI: Power Button [PWRF]
[    3.200053] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    3.200053] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    3.272383] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.272383] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.296960] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    3.296960] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    3.301781] lp: driver loaded but no devices found
[    3.301781] lp: driver loaded but no devices found
[    3.303169] Non-volatile memory driver v1.3
[    3.303169] Non-volatile memory driver v1.3
[    3.304262] ppdev: user-space parallel port driver
[    3.304262] ppdev: user-space parallel port driver
[    3.305483] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    3.305483] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    3.306759] Linux agpgart interface v0.103
[    3.306759] Linux agpgart interface v0.103
[    3.308450] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    3.308450] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    3.310746] Hangcheck: Using getrawmonotonic().
[    3.310746] Hangcheck: Using getrawmonotonic().
[    3.312326] [drm] Initialized drm 1.1.0 20060810
[    3.312326] [drm] Initialized drm 1.1.0 20060810
[    3.313811] [drm] radeon kernel modesetting enabled.
[    3.313811] [drm] radeon kernel modesetting enabled.
[    3.316754] [TTM] Zone  kernel: Available graphics memory: 133998 kiB
[    3.316754] [TTM] Zone  kernel: Available graphics memory: 133998 kiB
[    3.318371] [TTM] Initializing pool allocator
[    3.318371] [TTM] Initializing pool allocator
[    3.319514] [TTM] Initializing DMA pool allocator
[    3.319514] [TTM] Initializing DMA pool allocator
[    3.322181] [drm] fb mappable at 0xFC000000
[    3.322181] [drm] fb mappable at 0xFC000000
[    3.323258] [drm] vram aper at 0xFC000000
[    3.323258] [drm] vram aper at 0xFC000000
[    3.324256] [drm] size 4194304
[    3.324256] [drm] size 4194304
[    3.325027] [drm] fb depth is 24
[    3.325027] [drm] fb depth is 24
[    3.325840] [drm]    pitch is 3072
[    3.325840] [drm]    pitch is 3072
[    3.327729] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
[    3.327729] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
[    3.329340] cirrus 0000:00:02.0: registered panic notifier
[    3.329340] cirrus 0000:00:02.0: registered panic notifier
[    3.330741] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on =
minor 0
[    3.330741] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on =
minor 0
[    3.332958] usbcore: registered new interface driver udl
[    3.332958] usbcore: registered new interface driver udl
[    3.334585] parport_pc 00:04: reported by Plug and Play ACPI
[    3.334585] parport_pc 00:04: reported by Plug and Play ACPI
[    3.336169] parport0: PC-style at 0x378
[    3.336169] parport0: PC-style at 0x378, irq 7, irq 7 [ [PCSPPPCSPP,TRIS=
TATE,TRISTATE]
]
[    3.410830] lp0: using parport0 (interrupt-driven).
[    3.410830] lp0: using parport0 (interrupt-driven).
[    3.424483] brd: module loaded
[    3.424483] brd: module loaded
[    3.432301] loop: module loaded
[    3.432301] loop: module loaded
[    3.433121] HP CISS Driver (v 3.6.26)
[    3.433121] HP CISS Driver (v 3.6.26)
[    3.434974] skd:  v2.2.1-b0260 loaded
[    3.434974] skd:  v2.2.1-b0260 loaded
[    3.436075] MM: desc_per_page =3D 128
[    3.436075] MM: desc_per_page =3D 128
[    3.437635] nbd: registered device at major 43
[    3.437635] nbd: registered device at major 43
[    3.452066] mtip32xx Version 1.3.1
[    3.452066] mtip32xx Version 1.3.1
[    3.454005]  nullb0: unknown partition table
[    3.454005]  nullb0: unknown partition table
[    3.456219]  nullb1: unknown partition table
[    3.456219]  nullb1: unknown partition table
[    3.457772] null: module loaded
[    3.457772] null: module loaded
[    3.458849] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    3.458849] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    3.460947] dummy-irq: no IRQ given.  Use irq=3DN
[    3.460947] dummy-irq: no IRQ given.  Use irq=3DN
[    3.462423] lkdtm: No crash points registered, enable through debugfs
[    3.462423] lkdtm: No crash points registered, enable through debugfs
[    3.465724] mic_init not running on X100 ret -19
[    3.465724] mic_init not running on X100 ret -19
[    3.467308] usbcore: registered new interface driver rtsx_usb
[    3.467308] usbcore: registered new interface driver rtsx_usb
[    3.470328] usbcore: registered new interface driver viperboard
[    3.470328] usbcore: registered new interface driver viperboard
[    3.472615] Loading iSCSI transport class v2.0-870.
[    3.472615] Loading iSCSI transport class v2.0-870.
[    3.474837] rdac: device handler registered
[    3.474837] rdac: device handler registered
[    3.476120] hp_sw: device handler registered
[    3.476120] hp_sw: device handler registered
[    3.477639] fnic: Cisco FCoE HBA Driver, ver 1.6.0.10
[    3.477639] fnic: Cisco FCoE HBA Driver, ver 1.6.0.10
[    3.479270] fnic: Successfully Initialized Trace Buffer
[    3.479270] fnic: Successfully Initialized Trace Buffer
[    3.481041] fnic: Successfully Initialized FC_CTLR Trace Buffer
[    3.481041] fnic: Successfully Initialized FC_CTLR Trace Buffer
[    3.483199] bnx2fc: Broadcom NetXtreme II FCoE Driver bnx2fc v2.4.2 (Dec=
 11, 2013)
[    3.483199] bnx2fc: Broadcom NetXtreme II FCoE Driver bnx2fc v2.4.2 (Dec=
 11, 2013)
[    3.485829] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    3.485829] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    3.488030] scsi: <fdomain> Detection failed (no card)
[    3.488030] scsi: <fdomain> Detection failed (no card)
[    3.489551] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.07.00.08-k.
[    3.489551] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.07.00.08-k.
[    3.492281] iscsi: registered transport (qla4xxx)
[    3.492281] iscsi: registered transport (qla4xxx)
[    3.493744] QLogic iSCSI HBA Driver
[    3.493744] QLogic iSCSI HBA Driver
[    3.494802] Brocade BFA FC/FCOE SCSI driver - version: 3.2.23.0
[    3.494802] Brocade BFA FC/FCOE SCSI driver - version: 3.2.23.0
[    3.496602] csiostor: Chelsio FCoE driver 1.0.0
[    3.496602] csiostor: Chelsio FCoE driver 1.0.0
[    3.498537] DC390: clustering now enabled by default. If you get problem=
s load
[    3.498537] DC390: clustering now enabled by default. If you get problem=
s load
[    3.500645]        with "disable_clustering=3D1" and report to maintaine=
rs
[    3.500645]        with "disable_clustering=3D1" and report to maintaine=
rs
[    3.502704] megasas: 06.803.01.00-rc1 Mon. Mar. 10 17:00:00 PDT 2014
[    3.502704] megasas: 06.803.01.00-rc1 Mon. Mar. 10 17:00:00 PDT 2014
[    3.504747] mpt2sas version 16.100.00.00 loaded
[    3.504747] mpt2sas version 16.100.00.00 loaded
[    3.506404] mpt3sas version 02.100.00.00 loaded
[    3.506404] mpt3sas version 02.100.00.00 loaded
[    3.508194] 3ware 9000 Storage Controller device driver for Linux v2.26.=
02.014.
[    3.508194] 3ware 9000 Storage Controller device driver for Linux v2.26.=
02.014.
[    3.510518] LSI 3ware SAS/SATA-RAID Controller device driver for Linux v=
3.26.02.000.
[    3.510518] LSI 3ware SAS/SATA-RAID Controller device driver for Linux v=
3.26.02.000.
[    3.512852] imm: Version 2.05 (for Linux 2.4.0)
[    3.512852] imm: Version 2.05 (for Linux 2.4.0)
[    3.514867] ipr: IBM Power RAID SCSI Device Driver version: 2.6.0 (Novem=
ber 16, 2012)
[    3.514867] ipr: IBM Power RAID SCSI Device Driver version: 2.6.0 (Novem=
ber 16, 2012)
[    3.517211] RocketRAID 3xxx/4xxx Controller driver v1.8
[    3.517211] RocketRAID 3xxx/4xxx Controller driver v1.8
[    3.519070] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age =
0xf, 4 bits.
[    3.519070] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age =
0xf, 4 bits.
[    3.521349] libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx=
 0.
[    3.521349] libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx=
 0.
[    3.523416] Chelsio T4/T5 iSCSI Driver cxgb4i v0.9.4
[    3.523416] Chelsio T4/T5 iSCSI Driver cxgb4i v0.9.4
[    3.525001] iscsi: registered transport (cxgb4i)
[    3.525001] iscsi: registered transport (cxgb4i)
[    3.526551] iscsi: registered transport (be2iscsi)
[    3.526551] iscsi: registered transport (be2iscsi)
[    3.527966] In beiscsi_module_init, tt=3Dffffffff82ec3930
[    3.527966] In beiscsi_module_init, tt=3Dffffffff82ec3930
[    3.529870] esas2r: driver will not be loaded because no ATTO esas2r dev=
ices were found
[    3.529870] esas2r: driver will not be loaded because no ATTO esas2r dev=
ices were found
[    3.532680] VMware PVSCSI driver - version 1.0.5.0-k
[    3.532680] VMware PVSCSI driver - version 1.0.5.0-k
[    3.534278] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    3.534278] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    3.536289] osst :I: Tape driver with OnStream support version 0.99.4
[    3.536289] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    3.536289] osst :I: Tape driver with OnStream support version 0.99.4
[    3.536289] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    3.540614] SCSI Media Changer driver v0.25=20
[    3.540614] SCSI Media Changer driver v0.25=20
[    3.548116] scsi_debug: host protection
[    3.548116] scsi_debug: host protection
[    3.549281] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    3.549281] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    3.552541] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    3.552541] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    3.557877] parport0: powerup/reset Butterfly
[    3.557877] parport0: powerup/reset Butterfly
[    3.560087] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[    3.560087] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[    3.570108] sd 0:0:0:0: [sda] Write Protect is off
[    3.570108] sd 0:0:0:0: [sda] Write Protect is off
[    3.571589] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    3.571589] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    3.590110] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[    3.590110] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[    3.660091]  sda: unknown partition table
[    3.660091]  sda: unknown partition table
[    3.680319] parport_pc 00:04: registered master spi42
[    3.680319] parport_pc 00:04: registered master spi42
[    3.682085] spi spi42.1: spi_bitbang_setup, 66 nsec/bit
[    3.682085] spi spi42.1: spi_bitbang_setup, 66 nsec/bit
[    3.683683] spi spi42.1: setup mode 0, 8 bits/w, 15000000 Hz max --> 0
[    3.683683] spi spi42.1: setup mode 0, 8 bits/w, 15000000 Hz max --> 0
[    3.685894] parport_pc 00:04: registered child spi42.1
[    3.685894] parport_pc 00:04: registered child spi42.1
[    3.687427] parport0: dataflash at spi42.1
[    3.687427] parport0: dataflash at spi42.1
[    3.688653] parport0: AVR Butterfly
[    3.688653] parport0: AVR Butterfly
[    3.689970] parport0: cannot grant exclusive access for device spi-lm70l=
lp
[    3.689970] parport0: cannot grant exclusive access for device spi-lm70l=
lp
[    3.692121] spi-lm70llp: spi_lm70llp probe fail, status -12
[    3.692121] spi-lm70llp: spi_lm70llp probe fail, status -12
[    3.694121] bonding: Ethernet Channel Bonding Driver: v3.7.1 (April 27, =
2011)
[    3.694121] bonding: Ethernet Channel Bonding Driver: v3.7.1 (April 27, =
2011)
[    3.701381] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.701381] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.706529] libphy: Fixed MDIO Bus: probed
[    3.706529] libphy: Fixed MDIO Bus: probed
[    3.708341] tun: Universal TUN/TAP device driver, 1.6
[    3.708341] tun: Universal TUN/TAP device driver, 1.6
[    3.709801] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    3.709801] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    3.712739] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.=
de
[    3.712739] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.=
de
[    3.715144] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.20 (March =
14, 2014)
[    3.715144] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.20 (March =
14, 2014)
[    3.717482] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ether=
net Driver bnx2x 1.78.19-0 (2014/02/10)
[    3.717482] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ether=
net Driver bnx2x 1.78.19-0 (2014/02/10)
[    3.721859] vxge: Copyright(c) 2002-2010 Exar Corp.
[    3.721859] vxge: Copyright(c) 2002-2010 Exar Corp.
[    3.723315] vxge: Driver version: 2.5.3.22640-k
[    3.723315] vxge: Driver version: 2.5.3.22640-k
[    3.725772] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[    3.725772] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[    3.728082] QLogic 1/10 GbE Converged/Intelligent Ethernet Driver v5.3.60
[    3.728082] QLogic 1/10 GbE Converged/Intelligent Ethernet Driver v5.3.60
[    3.730401] QLogic/NetXen Network Driver v4.0.82
[    3.730401] QLogic/NetXen Network Driver v4.0.82
[    3.732154] Solarflare NET driver v4.0
[    3.732154] Solarflare NET driver v4.0
[    3.734191] tehuti: Tehuti Networks(R) Network Driver, 7.29.3
[    3.734191] tehuti: Tehuti Networks(R) Network Driver, 7.29.3
[    3.735881] tehuti: Options: hw_csum=20
[    3.735881] tehuti: Options: hw_csum=20
[    3.737421] usbcore: registered new interface driver irda-usb
[    3.737421] usbcore: registered new interface driver irda-usb
[    3.739170] usbcore: registered new interface driver stir4200
[    3.739170] usbcore: registered new interface driver stir4200
[    3.741653] usbcore: registered new interface driver mcs7780
[    3.741653] usbcore: registered new interface driver mcs7780
[    3.743410] usbcore: registered new interface driver ksdazzle-sir
[    3.743410] usbcore: registered new interface driver ksdazzle-sir
[    3.745384] usbcore: registered new interface driver ks959-sir
[    3.745384] usbcore: registered new interface driver ks959-sir
[    3.748147] NET3 PLIP version 2.4-parport gniibe@mri.co.jp
[    3.748147] NET3 PLIP version 2.4-parport gniibe@mri.co.jp
[    3.749797] plip0: Parallel port at 0x378, using IRQ 7.
[    3.749797] plip0: Parallel port at 0x378, using IRQ 7.
[    3.751445] PPP generic driver version 2.4.2
[    3.751445] PPP generic driver version 2.4.2
[    3.752950] PPP Deflate Compression module registered
[    3.752950] PPP Deflate Compression module registered
[    3.754312] PPP MPPE Compression module registered
[    3.754312] PPP MPPE Compression module registered
[    3.755575] DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
[    3.755575] DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
[    3.757759] usbcore: registered new interface driver i2400m_usb
[    3.757759] usbcore: registered new interface driver i2400m_usb
[    3.759382] VMware vmxnet3 virtual NIC driver - version 1.2.0.0-k-NAPI
[    3.759382] VMware vmxnet3 virtual NIC driver - version 1.2.0.0-k-NAPI
[    3.761447] usbcore: registered new interface driver catc
[    3.761447] usbcore: registered new interface driver catc
[    3.762996] usbcore: registered new interface driver kaweth
[    3.762996] usbcore: registered new interface driver kaweth
[    3.764664] usbcore: registered new interface driver rtl8150
[    3.764664] usbcore: registered new interface driver rtl8150
[    3.766412] usbcore: registered new interface driver r8152
[    3.766412] usbcore: registered new interface driver r8152
[    3.767992] usbcore: registered new interface driver ipheth
[    3.767992] usbcore: registered new interface driver ipheth
[    3.770896] parport0: cannot grant exclusive access for device ks0108
[    3.770896] parport0: cannot grant exclusive access for device ks0108
[    3.772685] ks0108: ERROR: parport didn't register new device
[    3.772685] ks0108: ERROR: parport didn't register new device
[    3.774382] cfag12864b: ERROR: ks0108 is not initialized
[    3.774382] cfag12864b: ERROR: ks0108 is not initialized
[    3.775475] cfag12864bfb: ERROR: cfag12864b is not initialized
[    3.775475] cfag12864bfb: ERROR: cfag12864b is not initialized
[    3.776985] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.776985] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.778565] ehci-pci: EHCI PCI platform driver
[    3.778565] ehci-pci: EHCI PCI platform driver
[    3.780086] ehci-platform: EHCI generic platform driver
[    3.780086] ehci-platform: EHCI generic platform driver
[    3.781765] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.781765] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.782841] ohci-pci: OHCI PCI platform driver
[    3.782841] ohci-pci: OHCI PCI platform driver
[    3.784090] ohci-platform: OHCI generic platform driver
[    3.784090] ohci-platform: OHCI generic platform driver
[    3.785602] uhci_hcd: USB Universal Host Controller Interface driver
[    3.785602] uhci_hcd: USB Universal Host Controller Interface driver
[    3.787211] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    3.787211] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    3.788300] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[    3.788300] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[    3.789943] usbcore: registered new interface driver usblp
[    3.789943] usbcore: registered new interface driver usblp
[    3.790985] usbcore: registered new interface driver mdc800
[    3.790985] usbcore: registered new interface driver mdc800
[    3.791951] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    3.791951] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    3.793304] usbcore: registered new interface driver microtekX6
[    3.793304] usbcore: registered new interface driver microtekX6
[    3.794369] usbcore: registered new interface driver adutux
[    3.794369] usbcore: registered new interface driver adutux
[    3.795495] usbcore: registered new interface driver appledisplay
[    3.795495] usbcore: registered new interface driver appledisplay
[    3.796586] usbcore: registered new interface driver cypress_cy7c63
[    3.796586] usbcore: registered new interface driver cypress_cy7c63
[    3.797860] usbcore: registered new interface driver cytherm
[    3.797860] usbcore: registered new interface driver cytherm
[    3.799670] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    3.799670] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    3.801110] ftdi_elan: driver ftdi-elan
[    3.801110] ftdi_elan: driver ftdi-elan
[    3.801951] usbcore: registered new interface driver ftdi-elan
[    3.801951] usbcore: registered new interface driver ftdi-elan
[    3.803035] usbcore: registered new interface driver isight_firmware
[    3.803035] usbcore: registered new interface driver isight_firmware
[    3.804163] usbcore: registered new interface driver usblcd
[    3.804163] usbcore: registered new interface driver usblcd
[    3.805186] usbcore: registered new interface driver ldusb
[    3.805186] usbcore: registered new interface driver ldusb
[    3.806275] usbcore: registered new interface driver usbled
[    3.806275] usbcore: registered new interface driver usbled
[    3.807282] usbcore: registered new interface driver legousbtower
[    3.807282] usbcore: registered new interface driver legousbtower
[    3.808872] usbcore: registered new interface driver rio500
[    3.808872] usbcore: registered new interface driver rio500
[    3.809922] usbcore: registered new interface driver usb_ehset_test
[    3.809922] usbcore: registered new interface driver usb_ehset_test
[    3.811073] usbcore: registered new interface driver trancevibrator
[    3.811073] usbcore: registered new interface driver trancevibrator
[    3.812208] usbcore: registered new interface driver usbsevseg
[    3.812208] usbcore: registered new interface driver usbsevseg
[    3.813273] usbcore: registered new interface driver yurex
[    3.813273] usbcore: registered new interface driver yurex
[    3.814389] usbcore: registered new interface driver sisusb
[    3.814389] usbcore: registered new interface driver sisusb
[    3.815595] usbcore: registered new interface driver cxacru
[    3.815595] usbcore: registered new interface driver cxacru
[    3.816669] usbcore: registered new interface driver ueagle-atm
[    3.816669] usbcore: registered new interface driver ueagle-atm
[    3.817785] xusbatm: malformed module parameters
[    3.817785] xusbatm: malformed module parameters
[    3.819329] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 M=
ay 2005
[    3.819329] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 M=
ay 2005
[    3.820607] dummy_hcd dummy_hcd.0: Dummy host controller
[    3.820607] dummy_hcd dummy_hcd.0: Dummy host controller
[    3.821906] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus =
number 1
[    3.821906] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus =
number 1
[    3.823364] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    3.823364] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    3.824522] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    3.824522] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    3.825784] usb usb1: Product: Dummy host controller
[    3.825784] usb usb1: Product: Dummy host controller
[    3.826672] usb usb1: Manufacturer: Linux 3.16.0-rc3-00010-g442aba0 dumm=
y_hcd
[    3.826672] usb usb1: Manufacturer: Linux 3.16.0-rc3-00010-g442aba0 dumm=
y_hcd
[    3.828022] usb usb1: SerialNumber: dummy_hcd.0
[    3.828022] usb usb1: SerialNumber: dummy_hcd.0
[    3.829751] hub 1-0:1.0: USB hub found
[    3.829751] hub 1-0:1.0: USB hub found
[    3.830461] hub 1-0:1.0: 1 port detected
[    3.830461] hub 1-0:1.0: 1 port detected
[    3.832328] udc dummy_udc.0: registering UDC driver [g_ether]
[    3.832328] udc dummy_udc.0: registering UDC driver [g_ether]
[    3.833382] using random self ethernet address
[    3.833382] using random self ethernet address
[    3.834168] using random host ethernet address
[    3.834168] using random host ethernet address
[    3.834940] g_ether gadget: adding config #1 'CDC Ethernet (ECM)'/ffffff=
ff82eeeb40
[    3.834940] g_ether gadget: adding config #1 'CDC Ethernet (ECM)'/ffffff=
ff82eeeb40
[    3.836265] g_ether gadget: adding 'cdc_ethernet'/ffff8800114463f8 to co=
nfig 'CDC Ethernet (ECM)'/ffffffff82eeeb40
[    3.836265] g_ether gadget: adding 'cdc_ethernet'/ffff8800114463f8 to co=
nfig 'CDC Ethernet (ECM)'/ffffffff82eeeb40
[    3.838761] usb0: HOST MAC fa:02:89:ff:37:f4
[    3.838761] usb0: HOST MAC fa:02:89:ff:37:f4
[    3.839527] usb0: MAC e6:b8:3b:58:e0:ad
[    3.839527] usb0: MAC e6:b8:3b:58:e0:ad
[    3.840216] g_ether gadget: CDC Ethernet: super speed IN/ep1in-bulk OUT/=
ep2out-bulk NOTIFY/ep5in-int
[    3.840216] g_ether gadget: CDC Ethernet: super speed IN/ep1in-bulk OUT/=
ep2out-bulk NOTIFY/ep5in-int
[    3.841824] g_ether gadget: cfg 1/ffffffff82eeeb40 speeds: super high fu=
ll
[    3.841824] g_ether gadget: cfg 1/ffffffff82eeeb40 speeds: super high fu=
ll
[    3.842994] g_ether gadget:   interface 0 =3D cdc_ethernet/ffff880011446=
3f8
[    3.842994] g_ether gadget:   interface 0 =3D cdc_ethernet/ffff880011446=
3f8
[    3.844144] g_ether gadget:   interface 1 =3D cdc_ethernet/ffff880011446=
3f8
[    3.844144] g_ether gadget:   interface 1 =3D cdc_ethernet/ffff880011446=
3f8
[    3.845293] g_ether gadget: Ethernet Gadget, version: Memorial Day 2008
[    3.845293] g_ether gadget: Ethernet Gadget, version: Memorial Day 2008
[    3.846461] g_ether gadget: g_ether ready
[    3.846461] g_ether gadget: g_ether ready
[    3.847154] dummy_udc dummy_udc.0: binding gadget driver 'g_ether'
[    3.847154] dummy_udc dummy_udc.0: binding gadget driver 'g_ether'
[    3.848334] dummy_udc dummy_udc.0: This device can perform faster if you=
 connect it to a super-speed port...
[    3.848334] dummy_udc dummy_udc.0: This device can perform faster if you=
 connect it to a super-speed port...
[    3.850346] dummy_hcd dummy_hcd.0: port status 0x00010101 has changes
[    3.850346] dummy_hcd dummy_hcd.0: port status 0x00010101 has changes
[    3.852328] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    3.852328] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    3.855744] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.855744] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.856726] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.856726] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.857796] parport0: cannot grant exclusive access for device parkbd
[    3.857796] parport0: cannot grant exclusive access for device parkbd
[    3.914755] mousedev: PS/2 mouse device common for all mice
[    3.914755] mousedev: PS/2 mouse device common for all mice
[    3.916340] usbcore: registered new interface driver iforce
[    3.916340] usbcore: registered new interface driver iforce
[    3.917853] usbcore: registered new interface driver xpad
[    3.917853] usbcore: registered new interface driver xpad
[    3.918861] parport0: cannot grant exclusive access for device walkera07=
01
[    3.918861] parport0: cannot grant exclusive access for device walkera07=
01
[    3.920067] walkera0701: failed to register parport device
[    3.920067] walkera0701: failed to register parport device
[    3.921134] usbcore: registered new interface driver gtco
[    3.921134] usbcore: registered new interface driver gtco
[    3.922492] usbcore: registered new interface driver hanwang
[    3.922492] usbcore: registered new interface driver hanwang
[    3.924205] usbcore: registered new interface driver kbtab
[    3.924205] usbcore: registered new interface driver kbtab
[    3.926752] usbcore: registered new interface driver usbtouchscreen
[    3.926752] usbcore: registered new interface driver usbtouchscreen
[    3.929043] I2O subsystem v1.325
[    3.929043] I2O subsystem v1.325
[    3.930131] i2o: max drivers =3D 8
[    3.930131] i2o: max drivers =3D 8
[    3.931227] dummy_hcd dummy_hcd.0: port status 0x00010101 has changes
[    3.931227] dummy_hcd dummy_hcd.0: port status 0x00010101 has changes
[    3.932926] I2O Configuration OSM v1.323
[    3.932926] I2O Configuration OSM v1.323
[    3.933680] I2O Bus Adapter OSM v1.317
[    3.933680] I2O Bus Adapter OSM v1.317
[    3.934609] I2O Block Device OSM v1.325
[    3.934609] I2O Block Device OSM v1.325
[    3.935546] i2c /dev entries driver
[    3.935546] i2c /dev entries driver
[    3.936569] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0x700, re=
vision 0
[    3.936569] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0x700, re=
vision 0
[    3.940610] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    3.940610] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    3.971006] i2c-parport: adapter type unspecified
[    3.971006] i2c-parport: adapter type unspecified
[    3.972366] i2c-parport-light: adapter type unspecified
[    3.972366] i2c-parport-light: adapter type unspecified
[    3.973968] usbcore: registered new interface driver RobotFuzz Open Sour=
ce InterFace, OSIF
[    3.973968] usbcore: registered new interface driver RobotFuzz Open Sour=
ce InterFace, OSIF
[    3.976627] usbcore: registered new interface driver i2c-tiny-usb
[    3.976627] usbcore: registered new interface driver i2c-tiny-usb
[    3.978930] pps pps0: new PPS source ktimer
[    3.978930] pps pps0: new PPS source ktimer
[    3.980158] pps pps0: ktimer PPS source registered
[    3.980158] pps pps0: ktimer PPS source registered
[    3.981562] pps_parport: parallel port PPS client
[    3.981562] pps_parport: parallel port PPS client
[    3.982909] parport0: cannot grant exclusive access for device pps_parpo=
rt
[    3.982909] parport0: cannot grant exclusive access for device pps_parpo=
rt
[    3.984894] pps_parport: couldn't register with parport0
[    3.984894] pps_parport: couldn't register with parport0
[    3.986579] Driver for 1-wire Dallas network protocol.
[    3.986579] Driver for 1-wire Dallas network protocol.
[    3.988503] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    3.988503] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    4.090072] g_ether gadget: resume
[    4.090072] g_ether gadget: resume
[    4.091010] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[    4.091010] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[    4.150298] usb 1-1: new high-speed USB device number 2 using dummy_hcd
[    4.150298] usb 1-1: new high-speed USB device number 2 using dummy_hcd
[    4.220072] g_ether gadget: resume
[    4.220072] g_ether gadget: resume
[    4.221012] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[    4.221012] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[    4.290045] dummy_udc dummy_udc.0: set_address =3D 2
[    4.290045] dummy_udc dummy_udc.0: set_address =3D 2
[    4.390083] usb 1-1: Dual-Role OTG device on HNP port
[    4.390083] usb 1-1: Dual-Role OTG device on HNP port
[    4.400143] usb 1-1: device v0525 pa4a1 is not supported
[    4.400143] usb 1-1: device v0525 pa4a1 is not supported
[    4.401572] g_ether gadget: suspend
[    4.401572] g_ether gadget: suspend
[    4.402571] usb usb1-port1: unable to enumerate USB device
[    4.402571] usb usb1-port1: unable to enumerate USB device
[    6.200089] i2c i2c-0: detect fail: address match, 0x2c
[    6.200089] i2c i2c-0: detect fail: address match, 0x2c
[    6.240106] i2c i2c-0: detect fail: address match, 0x2d
[    6.240106] i2c i2c-0: detect fail: address match, 0x2d
[    6.280100] i2c i2c-0: detect fail: address match, 0x2e
[    6.280100] i2c i2c-0: detect fail: address match, 0x2e
[    6.320095] i2c i2c-0: detect fail: address match, 0x2f
[    6.320095] i2c i2c-0: detect fail: address match, 0x2f
[   26.260471] pc87360: PC8736x not detected, module not inserted
[   26.260471] pc87360: PC8736x not detected, module not inserted
[   27.360955] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[   27.360955] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[   27.362897] usbcore: registered new interface driver pcwd_usb
[   27.362897] usbcore: registered new interface driver pcwd_usb
[   27.364447] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[   27.364447] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[   27.366511] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D0)
[   27.366511] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D0)
[   27.367805] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver v0.05
[   27.367805] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver v0.05
[   27.369129] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[   27.369129] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[   27.370587] wafer5823wdt: I/O address 0x0443 already in use
[   27.370587] wafer5823wdt: I/O address 0x0443 already in use
[   27.371979] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   27.371979] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   27.373543] iTCO_vendor_support: vendor-support=3D0
[   27.373543] iTCO_vendor_support: vendor-support=3D0
[   27.374465] it87_wdt: no device
[   27.374465] it87_wdt: no device
[   27.375113] sc1200wdt: build 20020303
[   27.375113] sc1200wdt: build 20020303
[   27.375888] sc1200wdt: io parameter must be specified
[   27.375888] sc1200wdt: io parameter must be specified
[   27.376875] pc87413_wdt: Version 1.1 at io 0x2E
[   27.376875] pc87413_wdt: Version 1.1 at io 0x2E
[   27.377699] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[   27.377699] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[   27.378916] nv_tco: NV TCO WatchDog Timer Driver v0.01
[   27.378916] nv_tco: NV TCO WatchDog Timer Driver v0.01
[   27.380139] cpu5wdt: misc_register failed
[   27.380139] cpu5wdt: misc_register failed
[   27.381038] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[   27.381038] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[   27.383581] smsc37b787_wdt: Unable to register miscdev on minor 130
[   27.383581] smsc37b787_wdt: Unable to register miscdev on minor 130
[   27.384849] w83877f_wdt: I/O address 0x0443 already in use
[   27.384849] w83877f_wdt: I/O address 0x0443 already in use
[   27.386298] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[   27.386298] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[   27.387791] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[   27.387791] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[   27.389351] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D0)
[   27.389351] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D0)
[   27.391457] md: linear personality registered for level -1
[   27.391457] md: linear personality registered for level -1
[   27.392656] md: raid0 personality registered for level 0
[   27.392656] md: raid0 personality registered for level 0
[   27.393553] md: raid1 personality registered for level 1
[   27.393553] md: raid1 personality registered for level 1
[   27.394509] md: raid10 personality registered for level 10
[   27.394509] md: raid10 personality registered for level 10
[   27.395777] md: raid6 personality registered for level 6
[   27.395777] md: raid6 personality registered for level 6
[   27.396707] md: raid5 personality registered for level 5
[   27.396707] md: raid5 personality registered for level 5
[   27.397685] md: raid4 personality registered for level 4
[   27.397685] md: raid4 personality registered for level 4
[   27.398678] md: faulty personality registered for level -5
[   27.398678] md: faulty personality registered for level -5
[   27.399741] device-mapper: uevent: version 1.0.3
[   27.399741] device-mapper: uevent: version 1.0.3
[   27.400962] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[   27.400962] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[   27.402696] device-mapper: multipath: version 1.7.0 loaded
[   27.402696] device-mapper: multipath: version 1.7.0 loaded
[   27.403652] device-mapper: multipath round-robin: version 1.0.0 loaded
[   27.403652] device-mapper: multipath round-robin: version 1.0.0 loaded
[   27.404849] device-mapper: multipath queue-length: version 0.1.0 loaded
[   27.404849] device-mapper: multipath queue-length: version 0.1.0 loaded
[   27.406067] device-mapper: multipath service-time: version 0.2.0 loaded
[   27.406067] device-mapper: multipath service-time: version 0.2.0 loaded
[   27.407260] device-mapper: raid: Loading target version 1.5.2
[   27.407260] device-mapper: raid: Loading target version 1.5.2
[   27.408364] device-mapper: cache cleaner: version 1.0.0 loaded
[   27.408364] device-mapper: cache cleaner: version 1.0.0 loaded
[   27.409385] Bluetooth: Virtual HCI driver ver 1.4
[   27.409385] Bluetooth: Virtual HCI driver ver 1.4
[   27.410545] usbcore: registered new interface driver bcm203x
[   27.410545] usbcore: registered new interface driver bcm203x
[   27.411799] usbcore: registered new interface driver bfusb
[   27.411799] usbcore: registered new interface driver bfusb
[   27.413116] usbcore: registered new interface driver btusb
[   27.413116] usbcore: registered new interface driver btusb
[   27.414096] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[   27.414096] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[   27.415271] usbcore: registered new interface driver ath3k
[   27.415271] usbcore: registered new interface driver ath3k
[   27.416465] usbcore: registered new interface driver ushc
[   27.416465] usbcore: registered new interface driver ushc
[   33.440102]  (null): enodev DEV ADDR =3D 0xFF
[   33.440102]  (null): enodev DEV ADDR =3D 0xFF
[   33.444396] rdma_ucm: couldn't register sysctl paths
[   33.444396] rdma_ucm: couldn't register sysctl paths
[   33.448097] iscsi: registered transport (iser)
[   33.448097] iscsi: registered transport (iser)
[   33.454033] usbcore: registered new interface driver usbkbd
[   33.454033] usbcore: registered new interface driver usbkbd
[   33.455695] usbcore: registered new interface driver usbmouse
[   33.455695] usbcore: registered new interface driver usbmouse
[   33.457421] usbip_core: USB/IP Core v1.0.0
[   33.457421] usbip_core: USB/IP Core v1.0.0
[   33.458851] usbcore: registered new interface driver r8712u
[   33.458851] usbcore: registered new interface driver r8712u
[   33.460732] usbcore: registered new interface driver tranzport
[   33.460732] usbcore: registered new interface driver tranzport
[   33.462361] usbcore: registered new interface driver alphatrack
[   33.462361] usbcore: registered new interface driver alphatrack
[   33.463924] vme_user: VME User Space Access Driver
[   33.463924] vme_user: VME User Space Access Driver
[   33.465166] vme_user: No cards, skipping registration
[   33.465166] vme_user: No cards, skipping registration
[   33.466512] vme_pio2: No cards, skipping registration
[   33.466512] vme_pio2: No cards, skipping registration
[   33.470583] beceem: Beceem Communications Inc. WiMAX driver, 5.2.45
[   33.470583] beceem: Beceem Communications Inc. WiMAX driver, 5.2.45
[   33.472279] Copyright 2010. Beceem Communications Inc
[   33.472279] Copyright 2010. Beceem Communications Inc
[   33.473745] usbcore: registered new interface driver usbbcm
[   33.473745] usbcore: registered new interface driver usbbcm
[   33.476064] ozwpan ozwpan: Ozmo Devices WPAN
[   33.476064] ozwpan ozwpan: Ozmo Devices WPAN
[   33.477430] ozwpan ozwpan: new USB bus registered, assigned bus number 2
[   33.477430] ozwpan ozwpan: new USB bus registered, assigned bus number 2
[   33.479390] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[   33.479390] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[   33.481375] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   33.481375] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   33.483300] usb usb2: Product: Ozmo Devices WPAN
[   33.483300] usb usb2: Product: Ozmo Devices WPAN
[   33.484487] usb usb2: Manufacturer: Linux 3.16.0-rc3-00010-g442aba0 Ozmo=
 WPAN
[   33.484487] usb usb2: Manufacturer: Linux 3.16.0-rc3-00010-g442aba0 Ozmo=
 WPAN
[   33.486354] usb usb2: SerialNumber: ozwpan
[   33.486354] usb usb2: SerialNumber: ozwpan
[   33.488575] hub 2-0:1.0: USB hub found
[   33.488575] hub 2-0:1.0: USB hub found
[   33.489638] hub 2-0:1.0: 8 ports detected
[   33.489638] hub 2-0:1.0: 8 ports detected
[   33.497543]  fake-fmc-carrier: mezzanine 0
[   33.497543]  fake-fmc-carrier: mezzanine 0
[   33.498687]       Manufacturer: fake-vendor
[   33.498687]       Manufacturer: fake-vendor
[   33.499770]       Product name: fake-design-for-testing
[   33.499770]       Product name: fake-design-for-testing
[   33.502124] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   33.502124] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   33.504000] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[   33.504000] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[   33.506751] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   33.506751] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   33.508830] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[   33.508830] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[   33.511892] NET: Registered protocol family 26
[   33.511892] NET: Registered protocol family 26
[   33.513097] Netfilter messages via NETLINK v0.30.
[   33.513097] Netfilter messages via NETLINK v0.30.
[   33.514362] nf_conntrack version 0.5.0 (2093 buckets, 8372 max)
[   33.514362] nf_conntrack version 0.5.0 (2093 buckets, 8372 max)
[   33.516039] nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>
[   33.516039] nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>
[   33.517787] IPVS: Registered protocols (TCP, SCTP, ESP)
[   33.517787] IPVS: Registered protocols (TCP, SCTP, ESP)
[   33.519213] IPVS: Connection hash table configured (size=3D4096, memory=
=3D64Kbytes)
[   33.519213] IPVS: Connection hash table configured (size=3D4096, memory=
=3D64Kbytes)
[   33.521357] IPVS: Creating netns size=3D2120 id=3D0
[   33.521357] IPVS: Creating netns size=3D2120 id=3D0
[   33.522725] IPVS: ipvs loaded.
[   33.522725] IPVS: ipvs loaded.
[   33.523545] IPVS: [wrr] scheduler registered.
[   33.523545] IPVS: [wrr] scheduler registered.
[   33.524687] IPVS: [lc] scheduler registered.
[   33.524687] IPVS: [lc] scheduler registered.
[   33.525794] IPVS: [lblcr] scheduler registered.
[   33.525794] IPVS: [lblcr] scheduler registered.
[   33.527019] IPVS: [dh] scheduler registered.
[   33.527019] IPVS: [dh] scheduler registered.
[   33.528141] IPVS: [sh] scheduler registered.
[   33.528141] IPVS: [sh] scheduler registered.
[   33.529251] IPVS: [nq] scheduler registered.
[   33.529251] IPVS: [nq] scheduler registered.
[   33.530661] IPv4 over IPSec tunneling driver
[   33.530661] IPv4 over IPSec tunneling driver
[   33.532772] TCP: cubic registered
[   33.532772] TCP: cubic registered
[   33.533718] NET: Registered protocol family 10
[   33.533718] NET: Registered protocol family 10
[   33.536004] sit: IPv6 over IPv4 tunneling driver
[   33.536004] sit: IPv6 over IPv4 tunneling driver
[   33.538449] ip6_gre: GRE over IPv6 tunneling driver
[   33.538449] ip6_gre: GRE over IPv6 tunneling driver
[   33.540431] NET: Registered protocol family 15
[   33.540431] NET: Registered protocol family 15
[   33.541761] NET: Registered protocol family 4
[   33.541761] NET: Registered protocol family 4
[   33.542989] NET: Registered protocol family 5
[   33.542989] NET: Registered protocol family 5
[   33.544497] Bluetooth: RFCOMM socket layer initialized
[   33.544497] Bluetooth: RFCOMM socket layer initialized
[   33.545868] Bluetooth: RFCOMM ver 1.11
[   33.545868] Bluetooth: RFCOMM ver 1.11
[   33.546911] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   33.546911] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   33.548285] Bluetooth: BNEP filters: multicast
[   33.548285] Bluetooth: BNEP filters: multicast
[   33.549425] Bluetooth: BNEP socket layer initialized
[   33.549425] Bluetooth: BNEP socket layer initialized
[   33.550944] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   33.550944] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   33.552460] Bluetooth: HIDP socket layer initialized
[   33.552460] Bluetooth: HIDP socket layer initialized
[   33.553799] NET: Registered protocol family 33
[   33.553799] NET: Registered protocol family 33
[   33.555003] Key type rxrpc registered
[   33.555003] Key type rxrpc registered
[   33.555957] Key type rxrpc_s registered
[   33.555957] Key type rxrpc_s registered
[   33.556999] lec:lane_module_init: lec.c: initialized
[   33.556999] lec:lane_module_init: lec.c: initialized
[   33.558373] l2tp_core: L2TP core driver, V2.0
[   33.558373] l2tp_core: L2TP core driver, V2.0
[   33.559533] l2tp_ip: L2TP IP encapsulation support (L2TPv3)
[   33.559533] l2tp_ip: L2TP IP encapsulation support (L2TPv3)
[   33.561076] l2tp_netlink: L2TP netlink interface
[   33.561076] l2tp_netlink: L2TP netlink interface
[   33.562531] l2tp_debugfs: L2TP debugfs support
[   33.562531] l2tp_debugfs: L2TP debugfs support
[   33.563712] l2tp_ip6: L2TP IP encapsulation support for IPv6 (L2TPv3)
[   33.563712] l2tp_ip6: L2TP IP encapsulation support for IPv6 (L2TPv3)
[   33.565405] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[   33.565405] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[   33.567588] DECnet: Routing cache hash table of 128 buckets, 10Kbytes
[   33.567588] DECnet: Routing cache hash table of 128 buckets, 10Kbytes
[   33.569414] NET: Registered protocol family 12
[   33.569414] NET: Registered protocol family 12
[   33.571210] 8021q: 802.1Q VLAN Support v1.8
[   33.571210] 8021q: 802.1Q VLAN Support v1.8
[   33.572575] sctp: Hash tables configured (established 910 bind 819)
[   33.572575] sctp: Hash tables configured (established 910 bind 819)
[   33.574316] lib80211: common routines for IEEE802.11 drivers
[   33.574316] lib80211: common routines for IEEE802.11 drivers
[   33.575825] lib80211_crypt: registered algorithm 'NULL'
[   33.575825] lib80211_crypt: registered algorithm 'NULL'
[   33.577169] lib80211_crypt: registered algorithm 'WEP'
[   33.577169] lib80211_crypt: registered algorithm 'WEP'
[   33.578553] lib80211_crypt: registered algorithm 'CCMP'
[   33.578553] lib80211_crypt: registered algorithm 'CCMP'
[   33.579916] lib80211_crypt: registered algorithm 'TKIP'
[   33.579916] lib80211_crypt: registered algorithm 'TKIP'
[   33.581480] NET: Registered protocol family 37
[   33.581480] NET: Registered protocol family 37
[   33.582760] Key type dns_resolver registered
[   33.582760] Key type dns_resolver registered
[   33.583985] Key type ceph registered
[   33.583985] Key type ceph registered
[   33.584959] libceph: loaded (mon/osd proto 15/24)
[   33.584959] libceph: loaded (mon/osd proto 15/24)
[   33.586205] mpls_gso: MPLS GSO support
[   33.586205] mpls_gso: MPLS GSO support
[   33.589371]=20
[   33.589371] printing PIC contents
[   33.589371]=20
[   33.589371] printing PIC contents
[   33.590735] ... PIC  IMR: ffff
[   33.590735] ... PIC  IMR: ffff
[   33.591547] ... PIC  IRR: 1013
[   33.591547] ... PIC  IRR: 1013
[   33.592356] ... PIC  ISR: 0000
[   33.592356] ... PIC  ISR: 0000
[   33.593163] ... PIC ELCR: 0c00
[   33.593163] ... PIC ELCR: 0c00
[   33.593961] printing local APIC contents on CPU#0/0:
[   33.593961] printing local APIC contents on CPU#0/0:
[   33.595289] ... APIC ID:      00000000 (0)
[   33.595289] ... APIC ID:      00000000 (0)
[   33.596347] ... APIC VERSION: 01050014
[   33.596347] ... APIC VERSION: 01050014
[   33.597317] ... APIC TASKPRI: 00000000 (00)
[   33.597317] ... APIC TASKPRI: 00000000 (00)
[   33.598441] ... APIC PROCPRI: 00000000
[   33.598441] ... APIC PROCPRI: 00000000
[   33.599428] ... APIC LDR: 01000000
[   33.599428] ... APIC LDR: 01000000
[   33.600315] ... APIC DFR: ffffffff
[   33.600315] ... APIC DFR: ffffffff
[   33.600705] ... APIC SPIV: 000001ff
[   33.600705] ... APIC SPIV: 000001ff
[   33.600705] ... APIC ISR field:
[   33.600705] ... APIC ISR field:
[   33.600705] 00000000
[   33.600705] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[   33.600705] ... APIC TMR field:
[   33.600705] ... APIC TMR field:
[   33.600705] 00000000
[   33.600705] 000000000200000002000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[   33.600705] ... APIC IRR field:
[   33.600705] ... APIC IRR field:
[   33.600705] 00000000
[   33.600705] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000800000008000

[   33.600705] ... APIC ESR: 00000000
[   33.600705] ... APIC ESR: 00000000
[   33.600705] ... APIC ICR: 00000831
[   33.600705] ... APIC ICR: 00000831
[   33.600705] ... APIC ICR2: 01000000
[   33.600705] ... APIC ICR2: 01000000
[   33.600705] ... APIC LVTT: 000000ef
[   33.600705] ... APIC LVTT: 000000ef
[   33.600705] ... APIC LVTPC: 00010000
[   33.600705] ... APIC LVTPC: 00010000
[   33.600705] ... APIC LVT0: 00010700
[   33.600705] ... APIC LVT0: 00010700
[   33.600705] ... APIC LVT1: 00000400
[   33.600705] ... APIC LVT1: 00000400
[   33.600705] ... APIC LVTERR: 000000fe
[   33.600705] ... APIC LVTERR: 000000fe
[   33.600705] ... APIC TMICT: 0008dc1b
[   33.600705] ... APIC TMICT: 0008dc1b
[   33.600705] ... APIC TMCCT: 00000000
[   33.600705] ... APIC TMCCT: 00000000
[   33.600705] ... APIC TDCR: 00000003
[   33.600705] ... APIC TDCR: 00000003
[   33.600705]=20
[   33.600705]=20
[   33.621233] number of MP IRQ sources: 15.
[   33.621233] number of MP IRQ sources: 15.
[   33.622300] number of IO-APIC #0 registers: 24.
[   33.622300] number of IO-APIC #0 registers: 24.
[   33.623493] testing the IO APIC.......................
[   33.623493] testing the IO APIC.......................
[   33.624841] IO APIC #0......
[   33.624841] IO APIC #0......
[   33.625588] .... register #00: 00000000
[   33.625588] .... register #00: 00000000
[   33.626636] .......    : physical APIC id: 00
[   33.626636] .......    : physical APIC id: 00
[   33.627762] .......    : Delivery Type: 0
[   33.627762] .......    : Delivery Type: 0
[   33.628793] .......    : LTS          : 0
[   33.628793] .......    : LTS          : 0
[   33.629825] .... register #01: 00170011
[   33.629825] .... register #01: 00170011
[   33.630896] .......     : max redirection entries: 17
[   33.630896] .......     : max redirection entries: 17
[   33.632200] .......     : PRQ implemented: 0
[   33.632200] .......     : PRQ implemented: 0
[   33.633307] .......     : IO APIC version: 11
[   33.633307] .......     : IO APIC version: 11
[   33.634473] .... register #02: 00000000
[   33.634473] .... register #02: 00000000
[   33.635480] .......     : arbitration: 00
[   33.635480] .......     : arbitration: 00
[   33.636523] .... IRQ redirection table:
[   33.636523] .... IRQ redirection table:
[   33.637525] 1    0    0   0   0    0    0    00
[   33.637525] 1    0    0   0   0    0    0    00
[   33.638768] 0    0    0   0   0    1    1    31
[   33.638768] 0    0    0   0   0    1    1    31
[   33.639951] 0    0    0   0   0    1    1    30
[   33.639951] 0    0    0   0   0    1    1    30
[   33.641158] 0    0    0   0   0    1    1    33
[   33.641158] 0    0    0   0   0    1    1    33
[   33.642371] 1    0    0   0   0    1    1    34
[   33.642371] 1    0    0   0   0    1    1    34
[   33.643569] 1    1    0   0   0    1    1    35
[   33.643569] 1    1    0   0   0    1    1    35
[   33.644761] 0    0    0   0   0    1    1    36
[   33.644761] 0    0    0   0   0    1    1    36
[   33.645943] 0    0    0   0   0    1    1    37
[   33.645943] 0    0    0   0   0    1    1    37
[   33.647167] 0    0    0   0   0    1    1    38
[   33.647167] 0    0    0   0   0    1    1    38
[   33.648348] 0    1    0   0   0    1    1    39
[   33.648348] 0    1    0   0   0    1    1    39
[   33.649524] 1    1    0   0   0    1    1    3A
[   33.649524] 1    1    0   0   0    1    1    3A
[   33.650799] 1    1    0   0   0    1    1    3B
[   33.650799] 1    1    0   0   0    1    1    3B
[   33.651983] 0    0    0   0   0    1    1    3C
[   33.651983] 0    0    0   0   0    1    1    3C
[   33.653163] 0    0    0   0   0    1    1    3D
[   33.653163] 0    0    0   0   0    1    1    3D
[   33.654372] 0    0    0   0   0    1    1    3E
[   33.654372] 0    0    0   0   0    1    1    3E
[   33.655572] 0    0    0   0   0    1    1    3F
[   33.655572] 0    0    0   0   0    1    1    3F
[   33.656759] 1    0    0   0   0    0    0    00
[   33.656759] 1    0    0   0   0    0    0    00
[   33.657935] 1    0    0   0   0    0    0    00
[   33.657935] 1    0    0   0   0    0    0    00
[   33.659159] 1    0    0   0   0    0    0    00
[   33.659159] 1    0    0   0   0    0    0    00
[   33.660359] 1    0    0   0   0    0    0    00
[   33.660359] 1    0    0   0   0    0    0    00
[   33.661542] 1    0    0   0   0    0    0    00
[   33.661542] 1    0    0   0   0    0    0    00
[   33.662780] 1    0    0   0   0    0    0    00
[   33.662780] 1    0    0   0   0    0    0    00
[   33.663962] 1    0    0   0   0    0    0    00
[   33.663962] 1    0    0   0   0    0    0    00
[   33.665141] 1    0    0   0   0    0    0    00
[   33.665141] 1    0    0   0   0    0    0    00
[   33.666332] IRQ to pin mappings:
[   33.666332] IRQ to pin mappings:
[   33.667192] IRQ0=20
[   33.667192] IRQ0 -> 0:2-> 0:2

[   33.667883] IRQ1=20
[   33.667883] IRQ1 -> 0:1-> 0:1

[   33.668565] IRQ3=20
[   33.668565] IRQ3 -> 0:3-> 0:3

[   33.669255] IRQ4=20
[   33.669255] IRQ4 -> 0:4-> 0:4

[   33.669944] IRQ5=20
[   33.669944] IRQ5 -> 0:5-> 0:5

[   33.670709] IRQ6=20
[   33.670709] IRQ6 -> 0:6-> 0:6

[   33.671395] IRQ7=20
[   33.671395] IRQ7 -> 0:7-> 0:7

[   33.672088] IRQ8=20
[   33.672088] IRQ8 -> 0:8-> 0:8

[   33.672779] IRQ9=20
[   33.672779] IRQ9 -> 0:9-> 0:9

[   33.673461] IRQ10=20
[   33.673461] IRQ10 -> 0:10-> 0:10

[   33.674216] IRQ11=20
[   33.674216] IRQ11 -> 0:11-> 0:11

[   33.674975] IRQ12=20
[   33.674975] IRQ12 -> 0:12-> 0:12

[   33.675710] IRQ13=20
[   33.675710] IRQ13 -> 0:13-> 0:13

[   33.676434] IRQ14=20
[   33.676434] IRQ14 -> 0:14-> 0:14

[   33.677164] IRQ15=20
[   33.677164] IRQ15 -> 0:15-> 0:15

[   33.677898] .................................... done.
[   33.677898] .................................... done.
[   33.680135] bootconsole [earlyser0] disabled
[   33.680135] bootconsole [earlyser0] disabled
[   33.681325] Loading compiled-in X.509 certificates
[   33.681999] registered taskstats version 1
[   33.682645] kAFS: Red Hat AFS client v0.1 registering.
[   33.683414] kAFS: failed to register: -12
[   33.684660] Btrfs loaded, debug=3Don, integrity-checker=3Don
[   33.685873] Key type trusted registered
[   33.687443] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   33.688256] EDD information not available.
[   33.690225] debug: unmapping init [mem 0xffffffff82fea000-0xffffffff830a=
cfff]
[   33.691320] Write protecting the kernel read-only data: 28672k
[   33.693165] debug: unmapping init [mem 0xffff88000200a000-0xffff8800021f=
ffff]
[   33.694294] debug: unmapping init [mem 0xffff880002a54000-0xffff880002bf=
ffff]
mount: mounting proc on /proc failed: No such device
/etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: not found

Please wait: booting...
mount: mounting proc on /proc failed: No such device
grep: /proc/filesystems: No such file or directory
Starting Bootlog daemon: bootlogd: cannot allocate pseudo tty: No such file=
 or directory
bootlogd.
mount: can't read '/proc/mounts': No such file or directory
[   33.736413] init[1]: segfault at ffffffffff600400 ip ffffffffff600400 sp=
 00007fff2894a8a8 error 15
[   33.737608] init[1]: segfault at ffffffffff600400 ip ffffffffff600400 sp=
 00007fff28949eb8 error 15
[   33.739046] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x0000000b
[   33.739046]=20
[   33.740015] CPU: 0 PID: 1 Comm: init Not tainted 3.16.0-rc3-00010-g442ab=
a0 #4
[   33.740015]  0000000000000000 ffff880000033cc0 ffffffff81ff485f ffff8800=
00033d38
[   33.740015]  ffffffff81ff1342 ffff880000000010 ffff880000033d48 ffff8800=
00033ce8
[   33.740015]  ffffffff82c440c0 000000000000000b 8c6318c6318c6320 00000007=
db00a678
[   33.740015] Call Trace:
[   33.740015]  [<ffffffff81ff485f>] dump_stack+0x19/0x1b
[   33.740015]  [<ffffffff81ff1342>] panic+0xcb/0x1fb
[   33.740015]  [<ffffffff81093b2f>] do_exit+0x3dd/0x80f
[   33.740015]  [<ffffffff810b071d>] ? local_clock+0x14/0x1d
[   33.740015]  [<ffffffff81094002>] do_group_exit+0x75/0xb4
[   33.740015]  [<ffffffff8109c7e7>] get_signal_to_deliver+0x48a/0x4aa
[   33.740015]  [<ffffffff8100231a>] do_signal+0x43/0x5ba
[   33.740015]  [<ffffffff810b4b79>] ? lock_release_holdtime+0x6c/0x77
[   33.740015]  [<ffffffff810b83b5>] ? lock_release_non_nested+0xd0/0x21e
[   33.740015]  [<ffffffff810b0646>] ? sched_clock_cpu+0x4e/0x62
[   33.740015]  [<ffffffff810fd465>] ? might_fault+0x4f/0x9c
[   33.740015]  [<ffffffff810b6163>] ? trace_hardirqs_off_caller+0x36/0xa5
[   33.740015]  [<ffffffff82004298>] ? retint_signal+0x11/0x99
[   33.740015]  [<ffffffff810028b5>] do_notify_resume+0x24/0x53
[   33.740015]  [<ffffffff820042d4>] retint_signal+0x4d/0x99
[   33.740015] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range=
: 0xffffffff80000000-0xffffffff9fffffff)
[   33.740015] drm_kms_helper: panic occurred, switching back to text conso=
le
[   33.740015]=20
[   33.740015] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   33.740015] [ INFO: suspicious RCU usage. ]
[   33.740015] 3.16.0-rc3-00010-g442aba0 #4 Not tainted
[   33.740015] -------------------------------
[   33.740015] include/linux/rcupdate.h:539 Illegal context switch in RCU r=
ead-side critical section!
[   33.740015]=20
[   33.740015] other info that might help us debug this:
[   33.740015]=20
[   33.740015]=20
[   33.740015] rcu_scheduler_active =3D 1, debug_locks =3D 0
[   33.740015] 3 locks held by init/1:
[   33.740015]  #0:  (panic_lock){....+.}, at: [<ffffffff81ff12ba>] panic+0=
x43/0x1fb
[   33.740015]  #1:  (rcu_read_lock){......}, at: [<ffffffff810ab879>] rcu_=
lock_acquire+0x0/0x23
[   33.740015]  #2:  (&dev->mode_config.mutex){+.+.+.}, at: [<ffffffff814a7=
4d7>] drm_fb_helper_panic+0x5d/0xab
[   33.740015]=20
[   33.740015] stack backtrace:
[   33.740015] CPU: 0 PID: 1 Comm: init Not tainted 3.16.0-rc3-00010-g442ab=
a0 #4
[   33.740015]  0000000000000000 ffff8800000339d0 ffffffff81ff485f ffff8800=
00033a00
[   33.740015]  ffffffff810b8824 ffffffff82836248 000000000000024a 00000000=
00000000
[   33.740015]  ffff88001012e008 ffff880000033a10 ffffffff810adce3 ffff8800=
00033a38
[   33.740015] Call Trace:
[   33.740015]  [<ffffffff81ff485f>] dump_stack+0x19/0x1b
[   33.740015]  [<ffffffff810b8824>] lockdep_rcu_suspicious+0xf6/0xff
[   33.740015]  [<ffffffff810adce3>] rcu_preempt_sleep_check+0x45/0x47
[   33.740015]  [<ffffffff810afedf>] __might_sleep+0x17/0x19a
[   33.740015]  [<ffffffff8200019e>] mutex_lock_nested+0x2e/0x369
[   33.740015]  [<ffffffff810b8657>] ? lock_release+0x154/0x185
[   33.740015]  [<ffffffff810b61df>] ? trace_hardirqs_off+0xd/0xf
[   33.740015]  [<ffffffff814b4ad3>] _object_find+0x25/0x6c
[   33.740015]  [<ffffffff814b5283>] drm_mode_object_find+0x38/0x53
[   33.740015]  [<ffffffff81593f6e>] cirrus_connector_best_encoder+0x21/0x2f
[   33.740015]  [<ffffffff814a5382>] drm_crtc_helper_set_config+0x38c/0x83c
[   33.740015]  [<ffffffff814b6c44>] drm_mode_set_config_internal+0x53/0xca
[   33.740015]  [<ffffffff814a731f>] restore_fbdev_mode+0x91/0xad
[   33.740015]  [<ffffffff814a74e3>] drm_fb_helper_panic+0x69/0xab
[   33.740015]  [<ffffffff810ab92c>] notifier_call_chain+0x61/0x8b
[   33.740015]  [<ffffffff810aba4f>] __atomic_notifier_call_chain+0x7e/0xe6
[   33.740015]  [<ffffffff810abac6>] atomic_notifier_call_chain+0xf/0x11
[   33.740015]  [<ffffffff81ff1367>] panic+0xf0/0x1fb
[   33.740015]  [<ffffffff81093b2f>] do_exit+0x3dd/0x80f
[   33.740015]  [<ffffffff810b071d>] ? local_clock+0x14/0x1d
[   33.740015]  [<ffffffff81094002>] do_group_exit+0x75/0xb4
[   33.740015]  [<ffffffff8109c7e7>] get_signal_to_deliver+0x48a/0x4aa
[   33.740015]  [<ffffffff8100231a>] do_signal+0x43/0x5ba
[   33.740015]  [<ffffffff810b4b79>] ? lock_release_holdtime+0x6c/0x77
[   33.740015]  [<ffffffff810b83b5>] ? lock_release_non_nested+0xd0/0x21e
[   33.740015]  [<ffffffff810b0646>] ? sched_clock_cpu+0x4e/0x62
[   33.740015]  [<ffffffff810fd465>] ? might_fault+0x4f/0x9c
[   33.740015]  [<ffffffff810b6163>] ? trace_hardirqs_off_caller+0x36/0xa5
[   33.740015]  [<ffffffff82004298>] ? retint_signal+0x11/0x99
[   33.740015]  [<ffffffff810028b5>] do_notify_resume+0x24/0x53
[   33.740015]  [<ffffffff820042d4>] retint_signal+0x4d/0x99
[   33.740015] Rebooting in 10 seconds..
Elapsed time: 40
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-hsxa0-07110255/442aba0c6131f0c41dfc5edb6bfb88335556523f/vmlinuz-3.16.0-rc3=
-00010-g442aba0 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 deb=
ug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 p=
anic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 con=
sole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-07110255/linux-devel=
:devel-hourly-2014071018:442aba0c6131f0c41dfc5edb6bfb88335556523f:bisect-li=
nux9/.vmlinuz-442aba0c6131f0c41dfc5edb6bfb88335556523f-20140711073043-10-iv=
b41 branch=3Dlinux-devel/devel-hourly-2014071018 BOOT_IMAGE=3D/kernel/x86_6=
4-randconfig-hsxa0-07110255/442aba0c6131f0c41dfc5edb6bfb88335556523f/vmlinu=
z-3.16.0-rc3-00010-g442aba0 drbd.minor_count=3D8'  -initrd /kernel-tests/in=
itrd/yocto-minimal-x86_64.cgz -m 320 -smp 1 -net nic,vlan=3D1,model=3De1000=
 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc bas=
e=3Dlocaltime -pidfile /dev/shm/kboot/pid-yocto-ivb41-17 -serial file:/dev/=
shm/kboot/serial-yocto-ivb41-17 -daemonize -display none -monitor null=20

--0WGqsT62A4RTsSXf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-ivb41-101:20140710232215:x86_64-randconfig-hsxa0-07110255::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Linux version 3.16.0-rc3-00009-ge1656ab (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #2 Fri Jul 11 07:20:45 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-07110255/linux-dev=
el:devel-hourly-2014071018:e1656ab2adfd1891f62610abe3e85ad992ee0cbf:bisect-=
linux9/.vmlinuz-e1656ab2adfd1891f62610abe3e85ad992ee0cbf-20140711072142-159=
-ivb41 branch=3Dlinux-devel/devel-hourly-2014071018 BOOT_IMAGE=3D/kernel/x8=
6_64-randconfig-hsxa0-07110255/e1656ab2adfd1891f62610abe3e85ad992ee0cbf/vml=
inuz-3.16.0-rc3-00009-ge1656ab drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[ffff8800000f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03efc000, 0x03efcfff] PGTABLE
[    0.000000] BRK [0x03efd000, 0x03efdfff] PGTABLE
[    0.000000] BRK [0x03efe000, 0x03efefff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 4k
[    0.000000] BRK [0x03eff000, 0x03efffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 4k
[    0.000000] BRK [0x03f00000, 0x03f00fff] PGTABLE
[    0.000000] BRK [0x03f01000, 0x03f01fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
[    0.000000]  [mem 0x12800000-0x13ffdfff] page 4k
[    0.000000] cma: CMA: reserved 32 MiB at 10400000
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
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA32 zone: 1280 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 81820 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 2c3b040
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-07110255/li=
nux-devel:devel-hourly-2014071018:e1656ab2adfd1891f62610abe3e85ad992ee0cbf:=
bisect-linux9/.vmlinuz-e1656ab2adfd1891f62610abe3e85ad992ee0cbf-20140711072=
142-159-ivb41 branch=3Dlinux-devel/devel-hourly-2014071018 BOOT_IMAGE=3D/ke=
rnel/x86_64-randconfig-hsxa0-07110255/e1656ab2adfd1891f62610abe3e85ad992ee0=
cbf/vmlinuz-3.16.0-rc3-00009-ge1656ab drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 215088K/327280K available (16415K kernel code, 4004K=
 rwdata, 8528K rodata, 780K init, 14644K bss, 112192K reserved)
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] Linux version 3.16.0-rc3-00009-ge1656ab (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #2 Fri Jul 11 07:20:45 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-07110255/linux-dev=
el:devel-hourly-2014071018:e1656ab2adfd1891f62610abe3e85ad992ee0cbf:bisect-=
linux9/.vmlinuz-e1656ab2adfd1891f62610abe3e85ad992ee0cbf-20140711072142-159=
-ivb41 branch=3Dlinux-devel/devel-hourly-2014071018 BOOT_IMAGE=3D/kernel/x8=
6_64-randconfig-hsxa0-07110255/e1656ab2adfd1891f62610abe3e85ad992ee0cbf/vml=
inuz-3.16.0-rc3-00009-ge1656ab drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[ffff8800000f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03efc000, 0x03efcfff] PGTABLE
[    0.000000] BRK [0x03efd000, 0x03efdfff] PGTABLE
[    0.000000] BRK [0x03efe000, 0x03efefff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 4k
[    0.000000] BRK [0x03eff000, 0x03efffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 4k
[    0.000000] BRK [0x03f00000, 0x03f00fff] PGTABLE
[    0.000000] BRK [0x03f01000, 0x03f01fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
[    0.000000]  [mem 0x12800000-0x13ffdfff] page 4k
[    0.000000] cma: CMA: reserved 32 MiB at 10400000
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
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA32 zone: 1280 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 81820 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 2c3b040
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-07110255/li=
nux-devel:devel-hourly-2014071018:e1656ab2adfd1891f62610abe3e85ad992ee0cbf:=
bisect-linux9/.vmlinuz-e1656ab2adfd1891f62610abe3e85ad992ee0cbf-20140711072=
142-159-ivb41 branch=3Dlinux-devel/devel-hourly-2014071018 BOOT_IMAGE=3D/ke=
rnel/x86_64-randconfig-hsxa0-07110255/e1656ab2adfd1891f62610abe3e85ad992ee0=
cbf/vmlinuz-3.16.0-rc3-00009-ge1656ab drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 215088K/327280K available (16415K kernel code, 4004K=
 rwdata, 8528K rodata, 780K init, 14644K bss, 112192K reserved)
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
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
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8671 kB
[    0.000000]  memory used by lock dependency info: 8671 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value..=20
[    0.020000] Calibrating delay loop (skipped) preset value.. 5387.01 Bogo=
MIPS (lpj=3D26935080)
5387.01 BogoMIPS (lpj=3D26935080)
[    0.020000] pid_max: default: 4096 minimum: 301
[    0.020000] pid_max: default: 4096 minimum: 301
[    0.020000] ACPI: Core revision 20140424
[    0.020000] ACPI: Core revision 20140424
[    0.026680] ACPI:=20
[    0.026680] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.028169] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.028169] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.029808] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.029808] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.030528] mce: CPU supports 10 MCE banks
[    0.030528] mce: CPU supports 10 MCE banks
[    0.031613] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.031613] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.031613] tlb_flushall_shift: 6
[    0.031613] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.031613] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.031613] tlb_flushall_shift: 6
[    0.035128] CPU:=20
[    0.035128] CPU: Intel Intel Common KVM processorCommon KVM processor (f=
am: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.040212] Performance Events:=20
[    0.040212] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.046931] Getting VERSION: 1050014
[    0.046931] Getting VERSION: 1050014
[    0.047859] Getting VERSION: 1050014
[    0.047859] Getting VERSION: 1050014
[    0.048730] Getting ID: 0
[    0.048730] Getting ID: 0
[    0.049396] Getting ID: ff000000
[    0.049396] Getting ID: ff000000
[    0.050016] Getting LVT0: 8700
[    0.050016] Getting LVT0: 8700
[    0.050814] Getting LVT1: 8400
[    0.050814] Getting LVT1: 8400
[    0.051573] enabled ExtINT on CPU#0
[    0.051573] enabled ExtINT on CPU#0
[    0.053398] ENABLING IO-APIC IRQs
[    0.053398] ENABLING IO-APIC IRQs
[    0.054234] init IO_APIC IRQs
[    0.054234] init IO_APIC IRQs
[    0.054989]  apic 0 pin 0 not connected
[    0.054989]  apic 0 pin 0 not connected
[    0.055970] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.055970] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.057973] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.057973] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.060034] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.060034] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.062001] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.062001] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.063952] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.063952] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.065927] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.065927] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.067854] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.067854] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.070032] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.070032] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.072021] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.072021] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.073949] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.073949] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.075963] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.075963] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.077965] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.077965] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.080033] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.080033] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.082034] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.082034] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.084008] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.084008] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.086013]  apic 0 pin 16 not connected
[    0.086013]  apic 0 pin 16 not connected
[    0.086989]  apic 0 pin 17 not connected
[    0.086989]  apic 0 pin 17 not connected
[    0.087945]  apic 0 pin 18 not connected
[    0.087945]  apic 0 pin 18 not connected
[    0.088891]  apic 0 pin 19 not connected
[    0.088891]  apic 0 pin 19 not connected
[    0.089876]  apic 0 pin 20 not connected
[    0.089876]  apic 0 pin 20 not connected
[    0.090008]  apic 0 pin 21 not connected
[    0.090008]  apic 0 pin 21 not connected
[    0.090963]  apic 0 pin 22 not connected
[    0.090963]  apic 0 pin 22 not connected
[    0.091941]  apic 0 pin 23 not connected
[    0.091941]  apic 0 pin 23 not connected
[    0.093067] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.093067] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.095428] Using local APIC timer interrupts.
[    0.095428] calibrating APIC timer ...
[    0.095428] Using local APIC timer interrupts.
[    0.095428] calibrating APIC timer ...
[    0.100000] ... lapic delta =3D 6306671
[    0.100000] ... lapic delta =3D 6306671
[    0.100000] ... PM-Timer delta =3D 361210
[    0.100000] ... PM-Timer delta =3D 361210
[    0.100000] ... PM-Timer result ok
[    0.100000] ... PM-Timer result ok
[    0.100000] ..... delta 6306671
[    0.100000] ..... delta 6306671
[    0.100000] ..... mult: 270869456
[    0.100000] ..... mult: 270869456
[    0.100000] ..... calibration result: 10090673
[    0.100000] ..... calibration result: 10090673
[    0.100000] ..... CPU clock speed is 2718.0169 MHz.
[    0.100000] ..... CPU clock speed is 2718.0169 MHz.
[    0.100000] ..... host bus clock speed is 1009.0673 MHz.
[    0.100000] ..... host bus clock speed is 1009.0673 MHz.
[    0.100172] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.100172] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.103447] devtmpfs: initialized
[    0.103447] devtmpfs: initialized
[    0.114031] xor: measuring software checksum speed
[    0.114031] xor: measuring software checksum speed
[    0.210011]    prefetch64-sse:  8260.400 MB/sec
[    0.210011]    prefetch64-sse:  8260.400 MB/sec
[    0.310008]    generic_sse:  6876.800 MB/sec
[    0.310008]    generic_sse:  6876.800 MB/sec
[    0.311965] xor: using function: prefetch64-sse (8260.400 MB/sec)
[    0.311965] xor: using function: prefetch64-sse (8260.400 MB/sec)
[    0.314579] prandom: seed boundary self test passed
[    0.314579] prandom: seed boundary self test passed
[    0.317335] prandom: 100 self tests passed
[    0.317335] prandom: 100 self tests passed
[    0.319065] atomic64_test: passed for x86-64 platform with CX8 and with =
SSE
[    0.319065] atomic64_test: passed for x86-64 platform with CX8 and with =
SSE
[    0.320714] regulator-dummy: no parameters
[    0.320714] regulator-dummy: no parameters
[    0.323887] NET: Registered protocol family 16
[    0.323887] NET: Registered protocol family 16
[    0.330440] cpuidle: using governor ladder
[    0.330440] cpuidle: using governor ladder
[    0.332181] cpuidle: using governor menu
[    0.332181] cpuidle: using governor menu
[    0.335054] ACPI: bus type PCI registered
[    0.335054] ACPI: bus type PCI registered
[    0.336829] dca service started, version 1.12.1
[    0.336829] dca service started, version 1.12.1
[    0.339937] PCI: Using configuration type 1 for base access
[    0.339937] PCI: Using configuration type 1 for base access
[    0.590048] raid6: sse2x1    4078 MB/s
[    0.590048] raid6: sse2x1    4078 MB/s
[    0.760016] raid6: sse2x2    4858 MB/s
[    0.760016] raid6: sse2x2    4858 MB/s
[    0.930010] raid6: sse2x4    6965 MB/s
[    0.930010] raid6: sse2x4    6965 MB/s
[    0.931618] raid6: using algorithm sse2x4 (6965 MB/s)
[    0.931618] raid6: using algorithm sse2x4 (6965 MB/s)
[    0.933729] raid6: using intx1 recovery algorithm
[    0.933729] raid6: using intx1 recovery algorithm
[    0.936238] ACPI: Added _OSI(Module Device)
[    0.936238] ACPI: Added _OSI(Module Device)
[    0.938011] ACPI: Added _OSI(Processor Device)
[    0.938011] ACPI: Added _OSI(Processor Device)
[    0.940008] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.940008] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.942434] ACPI: Added _OSI(Processor Aggregator Device)
[    0.942434] ACPI: Added _OSI(Processor Aggregator Device)
[    0.960561] ACPI: Interpreter enabled
[    0.960561] ACPI: Interpreter enabled
[    0.962169] ACPI: (supports S0 S4 S5)
[    0.962169] ACPI: (supports S0 S4 S5)
[    0.963721] ACPI: Using IOAPIC for interrupt routing
[    0.963721] ACPI: Using IOAPIC for interrupt routing
[    0.965880] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.965880] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.990359] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.990359] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.992989] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.992989] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.995451] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.995451] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.999227] PCI host bridge to bus 0000:00
[    0.999227] PCI host bridge to bus 0000:00
[    1.000012] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.000012] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.002337] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.002337] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.004914] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    1.004914] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    1.007567] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    1.007567] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    1.010010] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    1.010010] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    1.012601] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    1.012601] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    1.015176] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.015176] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.018152] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    1.018152] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    1.020115] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.020115] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.023636] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.023636] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.027480] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.027480] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.032993] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    1.032993] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    1.036663] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    1.036663] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    1.040010] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    1.040010] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    1.042755] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    1.042755] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    1.045726] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    1.045726] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    1.050412] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.050412] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.053440] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    1.053440] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    1.056472] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    1.056472] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    1.060315] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.060315] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.064401] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.064401] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.068687] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.068687] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.076807] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.076807] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.080905] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.080905] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.084469] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    1.084469] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    1.088253] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.088253] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.095220] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    1.095220] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    1.100784] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    1.100784] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    1.104133] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    1.104133] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    1.112650] pci_bus 0000:00: on NUMA node 0
[    1.112650] pci_bus 0000:00: on NUMA node 0
[    1.115689] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    1.115689] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    1.118832] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    1.118832] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    1.121109] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    1.121109] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    1.123985] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    1.123985] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    1.126873] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    1.126873] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    1.131355] ACPI:=20
[    1.131355] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    1.139252] SCSI subsystem initialized
[    1.139252] SCSI subsystem initialized
[    1.140098] libata version 3.00 loaded.
[    1.140098] libata version 3.00 loaded.
[    1.142134] ACPI: bus type USB registered
[    1.142134] ACPI: bus type USB registered
[    1.143965] usbcore: registered new interface driver usbfs
[    1.143965] usbcore: registered new interface driver usbfs
[    1.146355] usbcore: registered new interface driver hub
[    1.146355] usbcore: registered new interface driver hub
[    1.148834] usbcore: registered new device driver usb
[    1.148834] usbcore: registered new device driver usb
[    1.150429] pps_core: LinuxPPS API ver. 1 registered
[    1.150429] pps_core: LinuxPPS API ver. 1 registered
[    1.152633] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.152633] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.156524] PTP clock support registered
[    1.156524] PTP clock support registered
[    1.160255] wmi: Mapper loaded
[    1.160255] wmi: Mapper loaded
[    1.161686] PCI: Using ACPI for IRQ routing
[    1.161686] PCI: Using ACPI for IRQ routing
[    1.163364] PCI: pci_cache_line_size set to 64 bytes
[    1.163364] PCI: pci_cache_line_size set to 64 bytes
[    1.165593] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.165593] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.168118] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    1.168118] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    1.171013] irda_init()
[    1.171013] irda_init()
[    1.172119] NET: Registered protocol family 23
[    1.172119] NET: Registered protocol family 23
[    1.173997] Bluetooth: Core ver 2.19
[    1.173997] Bluetooth: Core ver 2.19
[    1.175539] NET: Registered protocol family 31
[    1.175539] NET: Registered protocol family 31
[    1.178525] Bluetooth: HCI device and connection manager initialized
[    1.178525] Bluetooth: HCI device and connection manager initialized
[    1.180023] Bluetooth: HCI socket layer initialized
[    1.180023] Bluetooth: HCI socket layer initialized
[    1.181819] Bluetooth: L2CAP socket layer initialized
[    1.181819] Bluetooth: L2CAP socket layer initialized
[    1.183941] Bluetooth: SCO socket layer initialized
[    1.183941] Bluetooth: SCO socket layer initialized
[    1.186310] NET: Registered protocol family 8
[    1.186310] NET: Registered protocol family 8
[    1.188472] NET: Registered protocol family 20
[    1.188472] NET: Registered protocol family 20
[    1.191437] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    1.191437] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    1.196009] Switched to clocksource kvm-clock
[    1.196009] Switched to clocksource kvm-clock
[    1.197996] pnp: PnP ACPI init
[    1.197996] pnp: PnP ACPI init
[    1.197996] ACPI: bus type PNP registered
[    1.197996] ACPI: bus type PNP registered
[    1.197996] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    1.197996] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    1.199515] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.199515] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.202505] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    1.202505] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    1.206199] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.206199] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.210810] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    1.210810] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    1.214524] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.214524] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.217535] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    1.217535] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    1.221151] pnp 00:03: [dma 2]
[    1.221151] pnp 00:03: [dma 2]
[    1.222714] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.222714] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.225743] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    1.225743] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    1.229565] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.229565] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.232621] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    1.232621] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    1.236329] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.236329] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.240430] pnp: PnP ACPI: found 6 devices
[    1.240430] pnp: PnP ACPI: found 6 devices
[    1.242160] ACPI: bus type PNP unregistered
[    1.242160] ACPI: bus type PNP unregistered
[    1.252887] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.252887] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.255402] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    1.255402] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    1.257875] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    1.257875] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    1.260483] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    1.260483] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    1.262648] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    1.262648] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    1.264874] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    1.264874] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    1.267720] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    1.267720] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    1.270407] NET: Registered protocol family 2
[    1.270407] NET: Registered protocol family 2
[    1.272855] TCP established hash table entries: 4096 (order: 3, 32768 by=
tes)
[    1.272855] TCP established hash table entries: 4096 (order: 3, 32768 by=
tes)
[    1.275911] TCP bind hash table entries: 4096 (order: 6, 327680 bytes)
[    1.275911] TCP bind hash table entries: 4096 (order: 6, 327680 bytes)
[    1.278931] TCP: Hash tables configured (established 4096 bind 4096)
[    1.278931] TCP: Hash tables configured (established 4096 bind 4096)
[    1.281599] TCP: reno registered
[    1.281599] TCP: reno registered
[    1.283070] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    1.283070] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    1.285762] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    1.285762] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    1.289008] NET: Registered protocol family 1
[    1.289008] NET: Registered protocol family 1
[    1.290964] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.290964] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.293620] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.293620] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.296204] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.296204] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.299075] pci 0000:00:02.0: Boot video device
[    1.299075] pci 0000:00:02.0: Boot video device
[    1.301159] PCI: CLS 0 bytes, default 64
[    1.301159] PCI: CLS 0 bytes, default 64
[    1.303253] Trying to unpack rootfs image as initramfs...
[    1.303253] Trying to unpack rootfs image as initramfs...
[    2.906610] debug: unmapping init [mem 0xffff88001293d000-0xffff880013fe=
ffff]
[    2.906610] debug: unmapping init [mem 0xffff88001293d000-0xffff880013fe=
ffff]
[    2.913674] Machine check injector initialized
[    2.913674] Machine check injector initialized
[    2.920163] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    2.920163] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    2.925589] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    2.925589] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    2.930031] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    2.930031] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    2.934790] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usab=
le.
[    2.934790] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usab=
le.
[    2.937016] PCLMULQDQ-NI instructions are not detected.
[    2.937016] PCLMULQDQ-NI instructions are not detected.
[    2.938837] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.938837] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.941033] AVX or AES-NI instructions are not detected.
[    2.941033] AVX or AES-NI instructions are not detected.
[    2.942954] AVX instructions are not detected.
[    2.942954] AVX instructions are not detected.
[    2.944497] AVX instructions are not detected.
[    2.944497] AVX instructions are not detected.
[    2.945902] AVX2 instructions are not detected.
[    2.945902] AVX2 instructions are not detected.
[    2.948756] Initializing RT-Tester: OK
[    2.948756] Initializing RT-Tester: OK
[    2.950160] spin_lock-torture:--- Start of test: nwriters_stress=3D2 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    2.950160] spin_lock-torture:--- Start of test: nwriters_stress=3D2 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    2.955414] spin_lock-torture: Creating torture_shuffle task
[    2.955414] spin_lock-torture: Creating torture_shuffle task
[    2.957459] spin_lock-torture: Creating torture_stutter task
[    2.957459] spin_lock-torture: Creating torture_stutter task
[    2.959403] spin_lock-torture: torture_shuffle task started
[    2.959403] spin_lock-torture: torture_shuffle task started
[    2.961375] spin_lock-torture: Creating lock_torture_writer task
[    2.961375] spin_lock-torture: Creating lock_torture_writer task
[    2.963456] spin_lock-torture: Creating lock_torture_writer task
[    2.963456] spin_lock-torture: Creating lock_torture_writer task
[    2.965567] spin_lock-torture: lock_torture_writer task started
[    2.965567] spin_lock-torture: lock_torture_writer task started
[    2.967666] spin_lock-torture: torture_stutter task started
[    2.967666] spin_lock-torture: torture_stutter task started
[    2.969443] spin_lock-torture: Creating lock_torture_stats task
[    2.969443] spin_lock-torture: Creating lock_torture_stats task
[    2.971739] spin_lock-torture: lock_torture_writer task started
[    2.971739] spin_lock-torture: lock_torture_writer task started
[    2.975686] futex hash table entries: 16 (order: -2, 1536 bytes)
[    2.975686] futex hash table entries: 16 (order: -2, 1536 bytes)
[    2.977954] Initialise system trusted keyring
[    2.977954] Initialise system trusted keyring
[    2.980128] spin_lock-torture: lock_torture_stats task started
[    2.980128] spin_lock-torture: lock_torture_stats task started
[    2.984945] ntfs: driver 2.1.30 [Flags: R/O DEBUG].
[    2.984945] ntfs: driver 2.1.30 [Flags: R/O DEBUG].
[    2.986758] fuse init (API version 7.23)
[    2.986758] fuse init (API version 7.23)
[    2.989161] SGI XFS with security attributes, realtime, large block/inod=
e numbers, debug enabled
[    2.989161] SGI XFS with security attributes, realtime, large block/inod=
e numbers, debug enabled
[    2.993570] gfs2: GFS2 installed
[    2.993570] gfs2: GFS2 installed
[    2.994831] ceph: loaded (mds proto 32)
[    2.994831] ceph: loaded (mds proto 32)
[    2.996094] msgmni has been set to 484
[    2.996094] msgmni has been set to 484
[    3.003816] alg: No test for crc32 (crc32-table)
[    3.003816] alg: No test for crc32 (crc32-table)
[    3.005662] alg: No test for lz4 (lz4-generic)
[    3.005662] alg: No test for lz4 (lz4-generic)
[    3.007513] alg: No test for stdrng (krng)
[    3.007513] alg: No test for stdrng (krng)
[    3.009013] NET: Registered protocol family 38
[    3.009013] NET: Registered protocol family 38
[    3.010707] async_tx: api initialized (async)
[    3.010707] async_tx: api initialized (async)
[    3.012433] Key type asymmetric registered
[    3.012433] Key type asymmetric registered
[    3.013754] Asymmetric key parser 'x509' registered
[    3.013754] Asymmetric key parser 'x509' registered
[    3.015569] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    3.015569] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    3.018219] io scheduler noop registered
[    3.018219] io scheduler noop registered
[    3.019510] io scheduler cfq registered (default)
[    3.019510] io scheduler cfq registered (default)
[    3.021007] list_sort_test: start testing list_sort()
[    3.021007] list_sort_test: start testing list_sort()
[    3.024804] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    3.024804] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    3.026426] crc32: self tests passed, processed 225944 bytes in 188204 n=
sec
[    3.026426] crc32: self tests passed, processed 225944 bytes in 188204 n=
sec
[    3.028958] crc32c: CRC_LE_BITS =3D 64
[    3.028958] crc32c: CRC_LE_BITS =3D 64
[    3.030260] crc32c: self tests passed, processed 225944 bytes in 93705 n=
sec
[    3.030260] crc32c: self tests passed, processed 225944 bytes in 93705 n=
sec
[    3.318807] crc32_combine: 8373 self tests passed
[    3.318807] crc32_combine: 8373 self tests passed
[    3.586625] crc32c_combine: 8373 self tests passed
[    3.586625] crc32c_combine: 8373 self tests passed
[    3.589040] xz_dec_test: module loaded
[    3.589040] xz_dec_test: module loaded
[    3.590436] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
249 0' and write .xz files to it.
[    3.590436] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
249 0' and write .xz files to it.
[    3.596878] rbtree testing
[    3.596878] rbtree testing -> 13832 cycles
 -> 13832 cycles
[    4.153781] augmented rbtree testing
[    4.153781] augmented rbtree testing -> 21232 cycles
 -> 21232 cycles
[    5.001428] [sched_delayed] sched: RT throttling activated
[    5.001428] [sched_delayed] sched: RT throttling activated
[    5.001468] tsc: Refined TSC clocksource calibration: 2693.505 MHz
[    5.001468] tsc: Refined TSC clocksource calibration: 2693.505 MHz
[    5.020888] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.020888] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.023531] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    5.023531] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    5.027477] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    5.027477] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    5.029900] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    5.029900] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    5.033696] rivafb_setup START
[    5.033696] rivafb_setup START
[    5.035304] nvidiafb_setup START
[    5.035304] nvidiafb_setup START
[    5.037689] vmlfb: initializing
[    5.037689] vmlfb: initializing
[    5.039326] Could not find Carillo Ranch MCH device.
[    5.039326] Could not find Carillo Ranch MCH device.
[    5.041889] hgafb: HGA card not detected.
[    5.041889] hgafb: HGA card not detected.
[    5.043920] hgafb: probe of hgafb.0 failed with error -22
[    5.043920] hgafb: probe of hgafb.0 failed with error -22
[    5.046969] usbcore: registered new interface driver udlfb
[    5.046969] usbcore: registered new interface driver udlfb
[    5.049690] usbcore: registered new interface driver smscufx
[    5.049690] usbcore: registered new interface driver smscufx
[    5.052577] ipmi message handler version 39.2
[    5.052577] ipmi message handler version 39.2
[    5.054727] ipmi device interface
[    5.054727] ipmi device interface
[    5.056320] IPMI System Interface driver.
[    5.056320] IPMI System Interface driver.
[    5.058385] ipmi_si: Adding default-specified kcs state machine
[    5.058385] ipmi_si: Adding default-specified kcs state machine

[    5.061276] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    5.061276] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    5.065143] ipmi_si: Interface detection failed
[    5.065143] ipmi_si: Interface detection failed
[    5.066801] ipmi_si: Adding default-specified smic state machine
[    5.066801] ipmi_si: Adding default-specified smic state machine

[    5.068834] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    5.068834] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    5.072452] ipmi_si: Interface detection failed
[    5.072452] ipmi_si: Interface detection failed
[    5.074293] ipmi_si: Adding default-specified bt state machine
[    5.074293] ipmi_si: Adding default-specified bt state machine

[    5.076627] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    5.076627] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    5.080285] ipmi_si: Interface detection failed
[    5.080285] ipmi_si: Interface detection failed
[    5.082060] ipmi_si: Unable to find any System Interface(s)
[    5.082060] ipmi_si: Unable to find any System Interface(s)
[    5.084069] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    5.084069] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    5.087902] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    5.087902] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    5.091402] ACPI: Power Button [PWRF]
[    5.091402] ACPI: Power Button [PWRF]
[    5.093862] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    5.093862] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    5.290219] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    5.290219] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    5.325189] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    5.325189] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    5.330773] lp: driver loaded but no devices found
[    5.330773] lp: driver loaded but no devices found
[    5.332748] Non-volatile memory driver v1.3
[    5.332748] Non-volatile memory driver v1.3
[    5.334133] ppdev: user-space parallel port driver
[    5.334133] ppdev: user-space parallel port driver
[    5.335666] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    5.335666] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    5.337232] Linux agpgart interface v0.103
[    5.337232] Linux agpgart interface v0.103
[    5.338714] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    5.338714] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    5.341567] Hangcheck: Using getrawmonotonic().
[    5.341567] Hangcheck: Using getrawmonotonic().
[    5.343704] [drm] Initialized drm 1.1.0 20060810
[    5.343704] [drm] Initialized drm 1.1.0 20060810
[    5.345446] [drm] radeon kernel modesetting enabled.
[    5.345446] [drm] radeon kernel modesetting enabled.
[    5.349353] [TTM] Zone  kernel: Available graphics memory: 123928 kiB
[    5.349353] [TTM] Zone  kernel: Available graphics memory: 123928 kiB
[    5.351437] [TTM] Initializing pool allocator
[    5.351437] [TTM] Initializing pool allocator
[    5.352970] [TTM] Initializing DMA pool allocator
[    5.352970] [TTM] Initializing DMA pool allocator
[    5.356104] [drm] fb mappable at 0xFC000000
[    5.356104] [drm] fb mappable at 0xFC000000
[    5.357481] [drm] vram aper at 0xFC000000
[    5.357481] [drm] vram aper at 0xFC000000
[    5.358786] [drm] size 4194304
[    5.358786] [drm] size 4194304
[    5.359727] [drm] fb depth is 24
[    5.359727] [drm] fb depth is 24
[    5.360764] [drm]    pitch is 3072
[    5.360764] [drm]    pitch is 3072
[    5.363353] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
[    5.363353] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
[    5.365396] cirrus 0000:00:02.0: registered panic notifier
[    5.365396] cirrus 0000:00:02.0: registered panic notifier
[    5.367197] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on =
minor 0
[    5.367197] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on =
minor 0
[    5.370019] usbcore: registered new interface driver udl
[    5.370019] usbcore: registered new interface driver udl
[    5.371988] parport_pc 00:04: reported by Plug and Play ACPI
[    5.371988] parport_pc 00:04: reported by Plug and Play ACPI
[    5.374016] parport0: PC-style at 0x378
[    5.374016] parport0: PC-style at 0x378, irq 7, irq 7 [ [PCSPPPCSPP,TRIS=
TATE,TRISTATE]
]
[    5.451533] lp0: using parport0 (interrupt-driven).
[    5.451533] lp0: using parport0 (interrupt-driven).
[    5.468271] brd: module loaded
[    5.468271] brd: module loaded
[    5.479584] loop: module loaded
[    5.479584] loop: module loaded
[    5.480873] HP CISS Driver (v 3.6.26)
[    5.480873] HP CISS Driver (v 3.6.26)
[    5.484105] skd:  v2.2.1-b0260 loaded
[    5.484105] skd:  v2.2.1-b0260 loaded
[    5.485778] MM: desc_per_page =3D 128
[    5.485778] MM: desc_per_page =3D 128
[    5.488288] nbd: registered device at major 43
[    5.488288] nbd: registered device at major 43
[    5.510779] mtip32xx Version 1.3.1
[    5.510779] mtip32xx Version 1.3.1
[    5.514029]  nullb0: unknown partition table
[    5.514029]  nullb0: unknown partition table
[    5.517568]  nullb1: unknown partition table
[    5.517568]  nullb1: unknown partition table
[    5.519873] null: module loaded
[    5.519873] null: module loaded
[    5.521159] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    5.521159] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    5.523942] dummy-irq: no IRQ given.  Use irq=3DN
[    5.523942] dummy-irq: no IRQ given.  Use irq=3DN
[    5.526418] lkdtm: No crash points registered, enable through debugfs
[    5.526418] lkdtm: No crash points registered, enable through debugfs
[    5.531437] mic_init not running on X100 ret -19
[    5.531437] mic_init not running on X100 ret -19
[    5.533982] usbcore: registered new interface driver rtsx_usb
[    5.533982] usbcore: registered new interface driver rtsx_usb
[    5.538124] usbcore: registered new interface driver viperboard
[    5.538124] usbcore: registered new interface driver viperboard
[    5.541497] Loading iSCSI transport class v2.0-870.
[    5.541497] Loading iSCSI transport class v2.0-870.
[    5.544516] rdac: device handler registered
[    5.544516] rdac: device handler registered
[    5.546696] hp_sw: device handler registered
[    5.546696] hp_sw: device handler registered
[    5.548945] fnic: Cisco FCoE HBA Driver, ver 1.6.0.10
[    5.548945] fnic: Cisco FCoE HBA Driver, ver 1.6.0.10
[    5.552430] fnic: Successfully Initialized Trace Buffer
[    5.552430] fnic: Successfully Initialized Trace Buffer
[    5.555689] fnic: Successfully Initialized FC_CTLR Trace Buffer
[    5.555689] fnic: Successfully Initialized FC_CTLR Trace Buffer
[    5.558945] bnx2fc: Broadcom NetXtreme II FCoE Driver bnx2fc v2.4.2 (Dec=
 11, 2013)
[    5.558945] bnx2fc: Broadcom NetXtreme II FCoE Driver bnx2fc v2.4.2 (Dec=
 11, 2013)
[    5.563049] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    5.563049] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    5.566639] scsi: <fdomain> Detection failed (no card)
[    5.566639] scsi: <fdomain> Detection failed (no card)
[    5.569155] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.07.00.08-k.
[    5.569155] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.07.00.08-k.
[    5.573388] iscsi: registered transport (qla4xxx)
[    5.573388] iscsi: registered transport (qla4xxx)
[    5.575857] QLogic iSCSI HBA Driver
[    5.575857] QLogic iSCSI HBA Driver
[    5.577514] Brocade BFA FC/FCOE SCSI driver - version: 3.2.23.0
[    5.577514] Brocade BFA FC/FCOE SCSI driver - version: 3.2.23.0
[    5.580423] csiostor: Chelsio FCoE driver 1.0.0
[    5.580423] csiostor: Chelsio FCoE driver 1.0.0
[    5.583861] DC390: clustering now enabled by default. If you get problem=
s load
[    5.583861] DC390: clustering now enabled by default. If you get problem=
s load
[    5.587187]        with "disable_clustering=3D1" and report to maintaine=
rs
[    5.587187]        with "disable_clustering=3D1" and report to maintaine=
rs
[    5.589342] megasas: 06.803.01.00-rc1 Mon. Mar. 10 17:00:00 PDT 2014
[    5.589342] megasas: 06.803.01.00-rc1 Mon. Mar. 10 17:00:00 PDT 2014
[    5.592041] mpt2sas version 16.100.00.00 loaded
[    5.592041] mpt2sas version 16.100.00.00 loaded
[    5.594330] mpt3sas version 02.100.00.00 loaded
[    5.594330] mpt3sas version 02.100.00.00 loaded
[    5.597249] 3ware 9000 Storage Controller device driver for Linux v2.26.=
02.014.
[    5.597249] 3ware 9000 Storage Controller device driver for Linux v2.26.=
02.014.
[    5.600188] LSI 3ware SAS/SATA-RAID Controller device driver for Linux v=
3.26.02.000.
[    5.600188] LSI 3ware SAS/SATA-RAID Controller device driver for Linux v=
3.26.02.000.
[    5.603720] imm: Version 2.05 (for Linux 2.4.0)
[    5.603720] imm: Version 2.05 (for Linux 2.4.0)
[    5.606639] ipr: IBM Power RAID SCSI Device Driver version: 2.6.0 (Novem=
ber 16, 2012)
[    5.606639] ipr: IBM Power RAID SCSI Device Driver version: 2.6.0 (Novem=
ber 16, 2012)
[    5.610048] RocketRAID 3xxx/4xxx Controller driver v1.8
[    5.610048] RocketRAID 3xxx/4xxx Controller driver v1.8
[    5.612387] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age =
0xf, 4 bits.
[    5.612387] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age =
0xf, 4 bits.
[    5.616031] libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx=
 0.
[    5.616031] libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx=
 0.
[    5.619274] Chelsio T4/T5 iSCSI Driver cxgb4i v0.9.4
[    5.619274] Chelsio T4/T5 iSCSI Driver cxgb4i v0.9.4
[    5.621649] iscsi: registered transport (cxgb4i)
[    5.621649] iscsi: registered transport (cxgb4i)
[    5.623908] iscsi: registered transport (be2iscsi)
[    5.623908] iscsi: registered transport (be2iscsi)
[    5.626188] In beiscsi_module_init, tt=3Dffffffff82ec4930
[    5.626188] In beiscsi_module_init, tt=3Dffffffff82ec4930
[    5.629013] esas2r: driver will not be loaded because no ATTO esas2r dev=
ices were found
[    5.629013] esas2r: driver will not be loaded because no ATTO esas2r dev=
ices were found
[    5.633175] VMware PVSCSI driver - version 1.0.5.0-k
[    5.633175] VMware PVSCSI driver - version 1.0.5.0-k
[    5.635784] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    5.635784] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    5.638594] osst :I: Tape driver with OnStream support version 0.99.4
[    5.638594] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    5.638594] osst :I: Tape driver with OnStream support version 0.99.4
[    5.638594] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    5.644248] SCSI Media Changer driver v0.25=20
[    5.644248] SCSI Media Changer driver v0.25=20
[    5.652092] scsi_debug: host protection
[    5.652092] scsi_debug: host protection
[    5.653600] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    5.653600] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    5.657566] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    5.657566] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    5.664407] parport0: powerup/reset Butterfly
[    5.664407] parport0: powerup/reset Butterfly
[    5.670251] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[    5.670251] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[    5.680184] sd 0:0:0:0: [sda] Write Protect is off
[    5.680184] sd 0:0:0:0: [sda] Write Protect is off
[    5.682211] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    5.682211] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    5.700211] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[    5.700211] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[    5.770165]  sda: unknown partition table
[    5.770165]  sda: unknown partition table
[    5.790356] parport_pc 00:04: registered master spi42
[    5.790356] parport_pc 00:04: registered master spi42
[    5.792048] spi spi42.1: spi_bitbang_setup, 66 nsec/bit
[    5.792048] spi spi42.1: spi_bitbang_setup, 66 nsec/bit
[    5.793401] spi spi42.1: setup mode 0, 8 bits/w, 15000000 Hz max --> 0
[    5.793401] spi spi42.1: setup mode 0, 8 bits/w, 15000000 Hz max --> 0
[    5.794999] parport_pc 00:04: registered child spi42.1
[    5.794999] parport_pc 00:04: registered child spi42.1
[    5.796032] parport0: dataflash at spi42.1
[    5.796032] parport0: dataflash at spi42.1
[    5.797682] parport0: AVR Butterfly
[    5.797682] parport0: AVR Butterfly
[    5.799124] parport0: cannot grant exclusive access for device spi-lm70l=
lp
[    5.799124] parport0: cannot grant exclusive access for device spi-lm70l=
lp
[    5.801480] spi-lm70llp: spi_lm70llp probe fail, status -12
[    5.801480] spi-lm70llp: spi_lm70llp probe fail, status -12
[    5.803532] bonding: Ethernet Channel Bonding Driver: v3.7.1 (April 27, =
2011)
[    5.803532] bonding: Ethernet Channel Bonding Driver: v3.7.1 (April 27, =
2011)
[    5.811506] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.811506] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.815648] libphy: Fixed MDIO Bus: probed
[    5.815648] libphy: Fixed MDIO Bus: probed
[    5.817566] tun: Universal TUN/TAP device driver, 1.6
[    5.817566] tun: Universal TUN/TAP device driver, 1.6
[    5.819163] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    5.819163] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    5.821638] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.=
de
[    5.821638] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.=
de
[    5.823720] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.20 (March =
14, 2014)
[    5.823720] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.20 (March =
14, 2014)
[    5.825122] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ether=
net Driver bnx2x 1.78.19-0 (2014/02/10)
[    5.825122] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ether=
net Driver bnx2x 1.78.19-0 (2014/02/10)
[    5.830434] vxge: Copyright(c) 2002-2010 Exar Corp.
[    5.830434] vxge: Copyright(c) 2002-2010 Exar Corp.
[    5.832010] vxge: Driver version: 2.5.3.22640-k
[    5.832010] vxge: Driver version: 2.5.3.22640-k
[    5.834562] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[    5.834562] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[    5.837200] QLogic 1/10 GbE Converged/Intelligent Ethernet Driver v5.3.60
[    5.837200] QLogic 1/10 GbE Converged/Intelligent Ethernet Driver v5.3.60
[    5.839082] QLogic/NetXen Network Driver v4.0.82
[    5.839082] QLogic/NetXen Network Driver v4.0.82
[    5.840521] Solarflare NET driver v4.0
[    5.840521] Solarflare NET driver v4.0
[    5.842054] tehuti: Tehuti Networks(R) Network Driver, 7.29.3
[    5.842054] tehuti: Tehuti Networks(R) Network Driver, 7.29.3
[    5.844447] tehuti: Options: hw_csum=20
[    5.844447] tehuti: Options: hw_csum=20
[    5.845814] usbcore: registered new interface driver irda-usb
[    5.845814] usbcore: registered new interface driver irda-usb
[    5.847978] usbcore: registered new interface driver stir4200
[    5.847978] usbcore: registered new interface driver stir4200
[    5.850236] usbcore: registered new interface driver mcs7780
[    5.850236] usbcore: registered new interface driver mcs7780
[    5.852484] usbcore: registered new interface driver ksdazzle-sir
[    5.852484] usbcore: registered new interface driver ksdazzle-sir
[    5.854667] usbcore: registered new interface driver ks959-sir
[    5.854667] usbcore: registered new interface driver ks959-sir
[    5.858300] NET3 PLIP version 2.4-parport gniibe@mri.co.jp
[    5.858300] NET3 PLIP version 2.4-parport gniibe@mri.co.jp
[    5.859719] plip0: Parallel port at 0x378, using IRQ 7.
[    5.859719] plip0: Parallel port at 0x378, using IRQ 7.
[    5.861454] PPP generic driver version 2.4.2
[    5.861454] PPP generic driver version 2.4.2
[    5.863718] PPP Deflate Compression module registered
[    5.863718] PPP Deflate Compression module registered
[    5.865491] PPP MPPE Compression module registered
[    5.865491] PPP MPPE Compression module registered
[    5.867118] DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
[    5.867118] DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
[    5.869402] usbcore: registered new interface driver i2400m_usb
[    5.869402] usbcore: registered new interface driver i2400m_usb
[    5.870957] VMware vmxnet3 virtual NIC driver - version 1.2.0.0-k-NAPI
[    5.870957] VMware vmxnet3 virtual NIC driver - version 1.2.0.0-k-NAPI
[    5.872473] usbcore: registered new interface driver catc
[    5.872473] usbcore: registered new interface driver catc
[    5.873745] usbcore: registered new interface driver kaweth
[    5.873745] usbcore: registered new interface driver kaweth
[    5.875032] usbcore: registered new interface driver rtl8150
[    5.875032] usbcore: registered new interface driver rtl8150
[    5.876242] usbcore: registered new interface driver r8152
[    5.876242] usbcore: registered new interface driver r8152
[    5.877502] usbcore: registered new interface driver ipheth
[    5.877502] usbcore: registered new interface driver ipheth
[    5.879723] parport0: cannot grant exclusive access for device ks0108
[    5.879723] parport0: cannot grant exclusive access for device ks0108
[    5.881109] ks0108: ERROR: parport didn't register new device
[    5.881109] ks0108: ERROR: parport didn't register new device
[    5.882284] cfag12864b: ERROR: ks0108 is not initialized
[    5.882284] cfag12864b: ERROR: ks0108 is not initialized
[    5.883470] cfag12864bfb: ERROR: cfag12864b is not initialized
[    5.883470] cfag12864bfb: ERROR: cfag12864b is not initialized
[    5.885977] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.885977] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.887853] ehci-pci: EHCI PCI platform driver
[    5.887853] ehci-pci: EHCI PCI platform driver
[    5.889175] ehci-platform: EHCI generic platform driver
[    5.889175] ehci-platform: EHCI generic platform driver
[    5.890812] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.890812] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.892495] ohci-pci: OHCI PCI platform driver
[    5.892495] ohci-pci: OHCI PCI platform driver
[    5.893930] ohci-platform: OHCI generic platform driver
[    5.893930] ohci-platform: OHCI generic platform driver
[    5.895390] uhci_hcd: USB Universal Host Controller Interface driver
[    5.895390] uhci_hcd: USB Universal Host Controller Interface driver
[    5.897371] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    5.897371] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    5.899560] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[    5.899560] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[    5.902662] usbcore: registered new interface driver usblp
[    5.902662] usbcore: registered new interface driver usblp
[    5.904134] usbcore: registered new interface driver mdc800
[    5.904134] usbcore: registered new interface driver mdc800
[    5.905263] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    5.905263] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    5.907014] usbcore: registered new interface driver microtekX6
[    5.907014] usbcore: registered new interface driver microtekX6
[    5.909266] usbcore: registered new interface driver adutux
[    5.909266] usbcore: registered new interface driver adutux
[    5.911601] usbcore: registered new interface driver appledisplay
[    5.911601] usbcore: registered new interface driver appledisplay
[    5.914075] usbcore: registered new interface driver cypress_cy7c63
[    5.914075] usbcore: registered new interface driver cypress_cy7c63
[    5.916317] usbcore: registered new interface driver cytherm
[    5.916317] usbcore: registered new interface driver cytherm
[    5.918599] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    5.918599] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    5.921357] ftdi_elan: driver ftdi-elan
[    5.921357] ftdi_elan: driver ftdi-elan
[    5.923188] usbcore: registered new interface driver ftdi-elan
[    5.923188] usbcore: registered new interface driver ftdi-elan
[    5.925620] usbcore: registered new interface driver isight_firmware
[    5.925620] usbcore: registered new interface driver isight_firmware
[    5.928230] usbcore: registered new interface driver usblcd
[    5.928230] usbcore: registered new interface driver usblcd
[    5.930529] usbcore: registered new interface driver ldusb
[    5.930529] usbcore: registered new interface driver ldusb
[    5.932883] usbcore: registered new interface driver usbled
[    5.932883] usbcore: registered new interface driver usbled
[    5.935180] usbcore: registered new interface driver legousbtower
[    5.935180] usbcore: registered new interface driver legousbtower
[    5.937714] usbcore: registered new interface driver rio500
[    5.937714] usbcore: registered new interface driver rio500
[    5.939920] usbcore: registered new interface driver usb_ehset_test
[    5.939920] usbcore: registered new interface driver usb_ehset_test
[    5.942455] usbcore: registered new interface driver trancevibrator
[    5.942455] usbcore: registered new interface driver trancevibrator
[    5.944780] usbcore: registered new interface driver usbsevseg
[    5.944780] usbcore: registered new interface driver usbsevseg
[    5.946892] usbcore: registered new interface driver yurex
[    5.946892] usbcore: registered new interface driver yurex
[    5.948844] usbcore: registered new interface driver sisusb
[    5.948844] usbcore: registered new interface driver sisusb
[    5.950792] usbcore: registered new interface driver cxacru
[    5.950792] usbcore: registered new interface driver cxacru
[    5.951997] usbcore: registered new interface driver ueagle-atm
[    5.951997] usbcore: registered new interface driver ueagle-atm
[    5.953618] xusbatm: malformed module parameters
[    5.953618] xusbatm: malformed module parameters
[    5.955745] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 M=
ay 2005
[    5.955745] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 M=
ay 2005
[    5.957979] dummy_hcd dummy_hcd.0: Dummy host controller
[    5.957979] dummy_hcd dummy_hcd.0: Dummy host controller
[    5.960455] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus =
number 1
[    5.960455] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus =
number 1
[    5.963047] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    5.963047] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    5.965233] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    5.965233] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    5.967532] usb usb1: Product: Dummy host controller
[    5.967532] usb usb1: Product: Dummy host controller
[    5.969169] usb usb1: Manufacturer: Linux 3.16.0-rc3-00009-ge1656ab dumm=
y_hcd
[    5.969169] usb usb1: Manufacturer: Linux 3.16.0-rc3-00009-ge1656ab dumm=
y_hcd
[    5.971563] usb usb1: SerialNumber: dummy_hcd.0
[    5.971563] usb usb1: SerialNumber: dummy_hcd.0
[    5.974451] hub 1-0:1.0: USB hub found
[    5.974451] hub 1-0:1.0: USB hub found
[    5.975726] hub 1-0:1.0: 1 port detected
[    5.975726] hub 1-0:1.0: 1 port detected
[    5.978224] udc dummy_udc.0: registering UDC driver [g_ether]
[    5.978224] udc dummy_udc.0: registering UDC driver [g_ether]
[    5.980193] using random self ethernet address
[    5.980193] using random self ethernet address
[    5.981643] using random host ethernet address
[    5.981643] using random host ethernet address
[    5.983050] g_ether gadget: adding config #1 'CDC Ethernet (ECM)'/ffffff=
ff82eefb40
[    5.983050] g_ether gadget: adding config #1 'CDC Ethernet (ECM)'/ffffff=
ff82eefb40
[    5.985474] g_ether gadget: adding 'cdc_ethernet'/ffff88000e46aa68 to co=
nfig 'CDC Ethernet (ECM)'/ffffffff82eefb40
[    5.985474] g_ether gadget: adding 'cdc_ethernet'/ffff88000e46aa68 to co=
nfig 'CDC Ethernet (ECM)'/ffffffff82eefb40
[    5.989661] usb0: HOST MAC 2e:7b:a6:83:5a:7b
[    5.989661] usb0: HOST MAC 2e:7b:a6:83:5a:7b
[    5.991080] usb0: MAC 5e:41:bd:b8:18:df
[    5.991080] usb0: MAC 5e:41:bd:b8:18:df
[    5.992219] g_ether gadget: CDC Ethernet: super speed IN/ep1in-bulk OUT/=
ep2out-bulk NOTIFY/ep5in-int
[    5.992219] g_ether gadget: CDC Ethernet: super speed IN/ep1in-bulk OUT/=
ep2out-bulk NOTIFY/ep5in-int
[    5.995162] g_ether gadget: cfg 1/ffffffff82eefb40 speeds: super high fu=
ll
[    5.995162] g_ether gadget: cfg 1/ffffffff82eefb40 speeds: super high fu=
ll
[    5.997051] g_ether gadget:   interface 0 =3D cdc_ethernet/ffff88000e46a=
a68
[    5.997051] g_ether gadget:   interface 0 =3D cdc_ethernet/ffff88000e46a=
a68
[    5.999252] g_ether gadget:   interface 1 =3D cdc_ethernet/ffff88000e46a=
a68
[    5.999252] g_ether gadget:   interface 1 =3D cdc_ethernet/ffff88000e46a=
a68
[    6.000739] g_ether gadget: Ethernet Gadget, version: Memorial Day 2008
[    6.000739] g_ether gadget: Ethernet Gadget, version: Memorial Day 2008
[    6.002478] g_ether gadget: g_ether ready
[    6.002478] g_ether gadget: g_ether ready
[    6.003526] dummy_udc dummy_udc.0: binding gadget driver 'g_ether'
[    6.003526] dummy_udc dummy_udc.0: binding gadget driver 'g_ether'
[    6.004960] dummy_udc dummy_udc.0: This device can perform faster if you=
 connect it to a super-speed port...
[    6.004960] dummy_udc dummy_udc.0: This device can perform faster if you=
 connect it to a super-speed port...
[    6.007300] dummy_hcd dummy_hcd.0: port status 0x00010101 has changes
[    6.007300] dummy_hcd dummy_hcd.0: port status 0x00010101 has changes
[    6.009327] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    6.009327] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    6.012028] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.012028] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.013402] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.013402] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.015300] parport0: cannot grant exclusive access for device parkbd
[    6.015300] parport0: cannot grant exclusive access for device parkbd
[    6.076240] dummy_hcd dummy_hcd.0: port status 0x00010101 has changes
[    6.076240] dummy_hcd dummy_hcd.0: port status 0x00010101 has changes
[    6.079912] mousedev: PS/2 mouse device common for all mice
[    6.079912] mousedev: PS/2 mouse device common for all mice
[    6.081917] usbcore: registered new interface driver iforce
[    6.081917] usbcore: registered new interface driver iforce
[    6.084088] usbcore: registered new interface driver xpad
[    6.084088] usbcore: registered new interface driver xpad
[    6.085270] parport0: cannot grant exclusive access for device walkera07=
01
[    6.085270] parport0: cannot grant exclusive access for device walkera07=
01
[    6.087257] walkera0701: failed to register parport device
[    6.087257] walkera0701: failed to register parport device
[    6.089546] usbcore: registered new interface driver gtco
[    6.089546] usbcore: registered new interface driver gtco
[    6.091813] usbcore: registered new interface driver hanwang
[    6.091813] usbcore: registered new interface driver hanwang
[    6.094041] usbcore: registered new interface driver kbtab
[    6.094041] usbcore: registered new interface driver kbtab
[    6.097752] usbcore: registered new interface driver usbtouchscreen
[    6.097752] usbcore: registered new interface driver usbtouchscreen
[    6.101445] I2O subsystem v1.325
[    6.101445] I2O subsystem v1.325
[    6.102787] i2o: max drivers =3D 8
[    6.102787] i2o: max drivers =3D 8
[    6.104576] I2O Configuration OSM v1.323
[    6.104576] I2O Configuration OSM v1.323
[    6.106209] I2O Bus Adapter OSM v1.317
[    6.106209] I2O Bus Adapter OSM v1.317
[    6.107798] I2O Block Device OSM v1.325
[    6.107798] I2O Block Device OSM v1.325
[    6.109617] i2c /dev entries driver
[    6.109617] i2c /dev entries driver
[    6.111511] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0x700, re=
vision 0
[    6.111511] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0x700, re=
vision 0
[    6.117436] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    6.117436] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    6.151226] i2c-parport: adapter type unspecified
[    6.151226] i2c-parport: adapter type unspecified
[    6.153103] i2c-parport-light: adapter type unspecified
[    6.153103] i2c-parport-light: adapter type unspecified
[    6.155252] usbcore: registered new interface driver RobotFuzz Open Sour=
ce InterFace, OSIF
[    6.155252] usbcore: registered new interface driver RobotFuzz Open Sour=
ce InterFace, OSIF
[    6.158340] usbcore: registered new interface driver i2c-tiny-usb
[    6.158340] usbcore: registered new interface driver i2c-tiny-usb
[    6.161229] pps pps0: new PPS source ktimer
[    6.161229] pps pps0: new PPS source ktimer
[    6.162869] pps pps0: ktimer PPS source registered
[    6.162869] pps pps0: ktimer PPS source registered
[    6.164712] pps_parport: parallel port PPS client
[    6.164712] pps_parport: parallel port PPS client
[    6.166513] parport0: cannot grant exclusive access for device pps_parpo=
rt
[    6.166513] parport0: cannot grant exclusive access for device pps_parpo=
rt
[    6.169481] pps_parport: couldn't register with parport0
[    6.169481] pps_parport: couldn't register with parport0
[    6.171682] Driver for 1-wire Dallas network protocol.
[    6.171682] Driver for 1-wire Dallas network protocol.
[    6.173999] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    6.173999] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    6.230205] g_ether gadget: resume
[    6.230205] g_ether gadget: resume
[    6.231186] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[    6.231186] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[    6.290273] usb 1-1: new high-speed USB device number 2 using dummy_hcd
[    6.290273] usb 1-1: new high-speed USB device number 2 using dummy_hcd
[    6.360156] g_ether gadget: resume
[    6.360156] g_ether gadget: resume
[    6.361118] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[    6.361118] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[    6.430142] dummy_udc dummy_udc.0: set_address =3D 2
[    6.430142] dummy_udc dummy_udc.0: set_address =3D 2
[    6.530211] usb 1-1: Dual-Role OTG device on HNP port
[    6.530211] usb 1-1: Dual-Role OTG device on HNP port
[    6.540137] usb 1-1: device v0525 pa4a1 is not supported
[    6.540137] usb 1-1: device v0525 pa4a1 is not supported
[    6.541461] g_ether gadget: suspend
[    6.541461] g_ether gadget: suspend
[    6.542377] usb usb1-port1: unable to enumerate USB device
[    6.542377] usb usb1-port1: unable to enumerate USB device
[    8.370152] i2c i2c-0: detect fail: address match, 0x2c
[    8.370152] i2c i2c-0: detect fail: address match, 0x2c
[    8.410193] i2c i2c-0: detect fail: address match, 0x2d
[    8.410193] i2c i2c-0: detect fail: address match, 0x2d
[    8.450196] i2c i2c-0: detect fail: address match, 0x2e
[    8.450196] i2c i2c-0: detect fail: address match, 0x2e
[    8.490211] i2c i2c-0: detect fail: address match, 0x2f
[    8.490211] i2c i2c-0: detect fail: address match, 0x2f

BUG: kernel boot hang
Elapsed time: 35
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-hsxa0-07110255/e1656ab2adfd1891f62610abe3e85ad992ee0cbf/vmlinuz-3.16.0-rc3=
-00009-ge1656ab -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 deb=
ug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 p=
anic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 con=
sole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-07110255/linux-devel=
:devel-hourly-2014071018:e1656ab2adfd1891f62610abe3e85ad992ee0cbf:bisect-li=
nux9/.vmlinuz-e1656ab2adfd1891f62610abe3e85ad992ee0cbf-20140711072142-159-i=
vb41 branch=3Dlinux-devel/devel-hourly-2014071018 BOOT_IMAGE=3D/kernel/x86_=
64-randconfig-hsxa0-07110255/e1656ab2adfd1891f62610abe3e85ad992ee0cbf/vmlin=
uz-3.16.0-rc3-00009-ge1656ab drbd.minor_count=3D8'  -initrd /kernel-tests/i=
nitrd/quantal-core-x86_64.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=3De1000=
 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc bas=
e=3Dlocaltime -pidfile /dev/shm/kboot/pid-quantal-ivb41-101 -serial file:/d=
ev/shm/kboot/serial-quantal-ivb41-101 -daemonize -display none -monitor nul=
l=20

--0WGqsT62A4RTsSXf
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-hsxa0-07110255-c80be3ae11770011071103d3e920864c275472a8-Kernel-panic---not-syncing:-Attempted-to-kill----exitcode--114769.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgYzgwYmUzYS4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1o
b3VybHktMjAxNDA3MTAxOCcKZ2l0IGNoZWNrb3V0IGNkM2RlODNmMTQ3NjAxMzU2Mzk1YjU3
YTg2NzNlOWM1ZmYxZTU5ZDEKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1L2xpbnV4LWRldmVsOmRldmVsLWhvdXJs
eS0yMDE0MDcxMDE4OmNkM2RlODNmMTQ3NjAxMzU2Mzk1YjU3YTg2NzNlOWM1ZmYxZTU5ZDE6
YmlzZWN0LWxpbnV4OQoKMjAxNC0wNy0xMC0xOTo0Mjo1NSBjZDNkZTgzZjE0NzYwMTM1NjM5
NWI1N2E4NjczZTljNWZmMWU1OWQxIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEw
MjU1LWNkM2RlODNmMTQ3NjAxMzU2Mzk1YjU3YTg2NzNlOWM1ZmYxZTU5ZDEKQ2hlY2sgZm9y
IGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1L2Nk
M2RlODNmMTQ3NjAxMzU2Mzk1YjU3YTg2NzNlOWM1ZmYxZTU5ZDEKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmln
LWhzeGEwLTA3MTEwMjU1LWNkM2RlODNmMTQ3NjAxMzU2Mzk1YjU3YTg2NzNlOWM1ZmYxZTU5
ZDEKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1L2Nk
M2RlODNmMTQ3NjAxMzU2Mzk1YjU3YTg2NzNlOWM1ZmYxZTU5ZDEvdm1saW51ei0zLjE2LjAt
cmM0CgoyMDE0LTA3LTEwLTE5OjQ0OjU1IGRldGVjdGluZyBib290IHN0YXRlIC4JNC4JMjIJ
MjMgU1VDQ0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCBjZDNkZTgzZjE0NzYwMTM1NjM5NWI1
N2E4NjczZTljNWZmMWU1OWQxCmdpdCBiaXNlY3Qgc3RhcnQgYzgwYmUzYWUxMTc3MDAxMTA3
MTEwM2QzZTkyMDg2NGMyNzU0NzJhOCBjZDNkZTgzZjE0NzYwMTM1NjM5NWI1N2E4NjczZTlj
NWZmMWU1OWQxIC0tCi9jL2tlcm5lbC10ZXN0cy9saW5lYXItYmlzZWN0OiBbIi1iIiwgImM4
MGJlM2FlMTE3NzAwMTEwNzExMDNkM2U5MjA4NjRjMjc1NDcyYTgiLCAiLWciLCAiY2QzZGU4
M2YxNDc2MDEzNTYzOTViNTdhODY3M2U5YzVmZjFlNTlkMSIsICIvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIiwgIi9jL2Jvb3QtYmlzZWN0L2xpbnV4OS9v
YmotYmlzZWN0Il0KQmlzZWN0aW5nOiA4MjUgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRl
ciB0aGlzIChyb3VnaGx5IDEwIHN0ZXBzKQpbNmUzNmQ0MzM2MTBhM2ViZmRlZjAwMGYxZmIy
ODNlM2YyMThhOGEzMl0gTWVyZ2UgJ29tYXAvb21hcC1mb3ItdjMuMTYvZml4ZXMnIGludG8g
ZGV2ZWwtaG91cmx5LTIwMTQwNzEwMTgKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4OS9vYmotYmlzZWN0
CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMC0wNzExMDI1NS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA3MTAxODo2ZTM2
ZDQzMzYxMGEzZWJmZGVmMDAwZjFmYjI4M2UzZjIxOGE4YTMyOmJpc2VjdC1saW51eDkKCjIw
MTQtMDctMTAtMTk6NDc6MjYgNmUzNmQ0MzM2MTBhM2ViZmRlZjAwMGYxZmIyODNlM2YyMThh
OGEzMiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS02ZTM2ZDQzMzYxMGEz
ZWJmZGVmMDAwZjFmYjI4M2UzZjIxOGE4YTMyCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS82ZTM2ZDQzMzYxMGEzZWJmZGVm
MDAwZjFmYjI4M2UzZjIxOGE4YTMyCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS02
ZTM2ZDQzMzYxMGEzZWJmZGVmMDAwZjFmYjI4M2UzZjIxOGE4YTMyCndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDEtY29uc3Vt
ZXIveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUtNmUzNmQ0MzM2MTBhM2ViZmRl
ZjAwMGYxZmIyODNlM2YyMThhOGEzMgprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDcxMTAyNTUvNmUzNmQ0MzM2MTBhM2ViZmRlZjAwMGYxZmIyODNlM2YyMThh
OGEzMi92bWxpbnV6LTMuMTYuMC1yYzQtMDAxNzYtZzZlMzZkNDMKCjIwMTQtMDctMTAtMTk6
NTA6MjYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkyIFRFU1QgRkFJTFVSRQovYmluL3NoOiAv
cHJvYy9zZWxmL2ZkLzk6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkKL2Jpbi9zaDogL3By
b2Mvc2VsZi9mZC85OiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5CgpCVUc6IGtlcm5lbCBi
b290IGhhbmcKRWxhcHNlZCB0aW1lOiA1MApxZW11LXN5c3RlbS14ODZfNjQgLWNwdSBrdm02
NCAtZW5hYmxlLWt2bSAta2VybmVsIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAt
MDcxMTAyNTUvNmUzNmQ0MzM2MTBhM2ViZmRlZjAwMGYxZmIyODNlM2YyMThhOGEzMi92bWxp
bnV6LTMuMTYuMC1yYzQtMDAxNzYtZzZlMzZkNDMgLWFwcGVuZCAnaHVuZ190YXNrX3Bhbmlj
PTEgZWFybHlwcmludGs9dHR5UzAsMTE1MjAwIGRlYnVnIGFwaWM9ZGVidWcgc3lzcnFfYWx3
YXlzX2VuYWJsZWQgcmN1cGRhdGUucmN1X2NwdV9zdGFsbF90aW1lb3V0PTEwMCBwYW5pYz0x
MCBzb2Z0bG9ja3VwX3BhbmljPTEgbm1pX3dhdGNoZG9nPXBhbmljICBwcm9tcHRfcmFtZGlz
az0wIGNvbnNvbGU9dHR5UzAsMTE1MjAwIGNvbnNvbGU9dHR5MCB2Z2E9bm9ybWFsICByb290
PS9kZXYvcmFtMCBydyBsaW5rPS9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAx
NDA3MTAxODo2ZTM2ZDQzMzYxMGEzZWJmZGVmMDAwZjFmYjI4M2UzZjIxOGE4YTMyOmJpc2Vj
dC1saW51eDkvLnZtbGludXotNmUzNmQ0MzM2MTBhM2ViZmRlZjAwMGYxZmIyODNlM2YyMThh
OGEzMi0yMDE0MDcxMTAzNTAyOS0xMi12cCBicmFuY2g9bGludXgtZGV2ZWwvZGV2ZWwtaG91
cmx5LTIwMTQwNzEwMTggQk9PVF9JTUFHRT0va2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhz
eGEwLTA3MTEwMjU1LzZlMzZkNDMzNjEwYTNlYmZkZWYwMDBmMWZiMjgzZTNmMjE4YThhMzIv
dm1saW51ei0zLjE2LjAtcmM0LTAwMTc2LWc2ZTM2ZDQzIGRyYmQubWlub3JfY291bnQ9OCcg
IC1pbml0cmQgL2tlcm5lbC10ZXN0cy9pbml0cmQvcXVhbnRhbC1jb3JlLXg4Nl82NC5jZ3og
LW0gMzIwIC1zbXAgMiAtbmV0IG5pYyx2bGFuPTEsbW9kZWw9ZTEwMDAgLW5ldCB1c2VyLHZs
YW49MSAtYm9vdCBvcmRlcj1uYyAtbm8tcmVib290IC13YXRjaGRvZyBpNjMwMGVzYiAtcnRj
IGJhc2U9bG9jYWx0aW1lIC1kcml2ZSBmaWxlPS9mcy9MQUJFTD1LVk0vZGlzazAtcXVhbnRh
bC12cC0xNCxtZWRpYT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMvTEFCRUw9S1ZN
L2Rpc2sxLXF1YW50YWwtdnAtMTQsbWVkaWE9ZGlzayxpZj12aXJ0aW8gLWRyaXZlIGZpbGU9
L2ZzL0xBQkVMPUtWTS9kaXNrMi1xdWFudGFsLXZwLTE0LG1lZGlhPWRpc2ssaWY9dmlydGlv
IC1kcml2ZSBmaWxlPS9mcy9MQUJFTD1LVk0vZGlzazMtcXVhbnRhbC12cC0xNCxtZWRpYT1k
aXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMvTEFCRUw9S1ZNL2Rpc2s0LXF1YW50YWwt
dnAtMTQsbWVkaWE9ZGlzayxpZj12aXJ0aW8gLWRyaXZlIGZpbGU9L2ZzL0xBQkVMPUtWTS9k
aXNrNS1xdWFudGFsLXZwLTE0LG1lZGlhPWRpc2ssaWY9dmlydGlvIC1waWRmaWxlIC9kZXYv
c2htL2tib290L3BpZC1xdWFudGFsLXZwLTE0IC1zZXJpYWwgZmlsZTovZGV2L3NobS9rYm9v
dC9zZXJpYWwtcXVhbnRhbC12cC0xNCAtZGFlbW9uaXplIC1kaXNwbGF5IG5vbmUgLW1vbml0
b3IgbnVsbCAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS82ZTM2
ZDQzMzYxMGEzZWJmZGVmMDAwZjFmYjI4M2UzZjIxOGE4YTMyL2RtZXNnLXlvY3RvLXZwLTE0
OjIwMTQwNzEwMTk1MTAyOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjMuMTYu
MC1yYzQtMDAxNzYtZzZlMzZkNDM6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEw
LTA3MTEwMjU1LzZlMzZkNDMzNjEwYTNlYmZkZWYwMDBmMWZiMjgzZTNmMjE4YThhMzIvZG1l
c2cteW9jdG8tdnAtMjE6MjAxNDA3MTAxOTUxMDY6eDg2XzY0LXJhbmRjb25maWctaHN4YTAt
MDcxMTAyNTU6My4xNi4wLXJjNC0wMDE3Ni1nNmUzNmQ0MzoyCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctaHN4YTAtMDcxMTAyNTUvNmUzNmQ0MzM2MTBhM2ViZmRlZjAwMGYxZmIyODNl
M2YyMThhOGEzMi9kbWVzZy15b2N0by12cC0yNDoyMDE0MDcxMDE5NTEwODp4ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMC0wNzExMDI1NTozLjE2LjAtcmM0LTAwMTc2LWc2ZTM2ZDQzOjIKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS82ZTM2ZDQzMzYxMGEzZWJm
ZGVmMDAwZjFmYjI4M2UzZjIxOGE4YTMyL2RtZXNnLXlvY3RvLXZwLTQyOjIwMTQwNzEwMTk1
MTAzOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjMuMTYuMC1yYzQtMDAxNzYt
ZzZlMzZkNDM6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzZl
MzZkNDMzNjEwYTNlYmZkZWYwMDBmMWZiMjgzZTNmMjE4YThhMzIvZG1lc2cteW9jdG8tdnAt
NDoyMDE0MDcxMDE5NTEwNTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTozLjE2
LjAtcmM0LTAwMTc2LWc2ZTM2ZDQzOjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MC0wNzExMDI1NS82ZTM2ZDQzMzYxMGEzZWJmZGVmMDAwZjFmYjI4M2UzZjIxOGE4YTMyL2Rt
ZXNnLXlvY3RvLXZwLTU3OjIwMTQwNzEwMTk1MTA4Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEw
LTA3MTEwMjU1OjMuMTYuMC1yYzQtMDAxNzYtZzZlMzZkNDM6Mgova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzZlMzZkNDMzNjEwYTNlYmZkZWYwMDBmMWZiMjgz
ZTNmMjE4YThhMzIvZG1lc2cteW9jdG8tdnAtNjE6MjAxNDA3MTAxOTUxMDQ6eDg2XzY0LXJh
bmRjb25maWctaHN4YTAtMDcxMTAyNTU6My4xNi4wLXJjNC0wMDE3Ni1nNmUzNmQ0MzoyCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvNmUzNmQ0MzM2MTBhM2Vi
ZmRlZjAwMGYxZmIyODNlM2YyMThhOGEzMi9kbWVzZy15b2N0by12cC02MzoyMDE0MDcxMDE5
NTEwNDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTozLjE2LjAtcmM0LTAwMTc2
LWc2ZTM2ZDQzOjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS82
ZTM2ZDQzMzYxMGEzZWJmZGVmMDAwZjFmYjI4M2UzZjIxOGE4YTMyL2RtZXNnLXlvY3RvLXZw
LTk6MjAxNDA3MTAxOTUxMDI6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6My4x
Ni4wLXJjNC0wMDE3Ni1nNmUzNmQ0MzoyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDcxMTAyNTUvNmUzNmQ0MzM2MTBhM2ViZmRlZjAwMGYxZmIyODNlM2YyMThhOGEzMi9k
bWVzZy15b2N0by12cC0xNjoyMDE0MDcxMDE5NTExNTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MC0wNzExMDI1NTozLjE2LjAtcmM0LTAwMTc2LWc2ZTM2ZDQzOjIKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS82ZTM2ZDQzMzYxMGEzZWJmZGVmMDAwZjFmYjI4
M2UzZjIxOGE4YTMyL2RtZXNnLXlvY3RvLXZwLTM5OjIwMTQwNzEwMTk1MTEzOng4Nl82NC1y
YW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjMuMTYuMC1yYzQtMDAxNzYtZzZlMzZkNDM6Mgov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzZlMzZkNDMzNjEwYTNl
YmZkZWYwMDBmMWZiMjgzZTNmMjE4YThhMzIvZG1lc2cteW9jdG8tdnAtNDE6MjAxNDA3MTAx
OTUxMTQ6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6My4xNi4wLXJjNC0wMDE3
Ni1nNmUzNmQ0MzoyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUv
NmUzNmQ0MzM2MTBhM2ViZmRlZjAwMGYxZmIyODNlM2YyMThhOGEzMi9kbWVzZy15b2N0by12
cC01NjoyMDE0MDcxMDE5NTExMzp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NToz
LjE2LjAtcmM0LTAwMTc2LWc2ZTM2ZDQzOjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMC0wNzExMDI1NS82ZTM2ZDQzMzYxMGEzZWJmZGVmMDAwZjFmYjI4M2UzZjIxOGE4YTMy
L2RtZXNnLXlvY3RvLXZwLTY0OjIwMTQwNzEwMTk1MTE2Ong4Nl82NC1yYW5kY29uZmlnLWhz
eGEwLTA3MTEwMjU1OjMuMTYuMC1yYzQtMDAxNzYtZzZlMzZkNDM6Mgova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzZlMzZkNDMzNjEwYTNlYmZkZWYwMDBmMWZi
MjgzZTNmMjE4YThhMzIvZG1lc2cteW9jdG8tdnAtMzA6MjAxNDA3MTAxOTUxMjA6eDg2XzY0
LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6My4xNi4wLXJjNC0wMDE3Ni1nNmUzNmQ0Mzoy
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvNmUzNmQ0MzM2MTBh
M2ViZmRlZjAwMGYxZmIyODNlM2YyMThhOGEzMi9kbWVzZy15b2N0by12cC0zMjoyMDE0MDcx
MDE5NTEyODp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTozLjE2LjAtcmM0LTAw
MTc2LWc2ZTM2ZDQzOjIKMDoxNjoxOCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKQmlz
ZWN0aW5nOiAxNzYgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDggc3RlcHMpClsxNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxXSBN
ZXJnZSAndWxmLmhhbnNzb24tbW1jL25leHQnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwNzEw
MTgKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9jL2Jvb3QtYmlzZWN0L2xpbnV4OS9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMv
cnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS9saW51eC1k
ZXZlbDpkZXZlbC1ob3VybHktMjAxNDA3MTAxODoxNDYwNGFiMzZmYWJhODhhODljYjJjOTYx
MTUwOWY1YTFjMWNhYzIxOmJpc2VjdC1saW51eDkKCjIwMTQtMDctMTAtMTk6NTE6MjcgMTQ2
MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMSBjb21waWxpbmcKUXVldWVk
IGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNv
bmZpZy1oc3hhMC0wNzExMDI1NS0xNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFj
MWNhYzIxCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIx
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS0xNDYwNGFiMzZmYWJhODhhODljYjJj
OTYxMTUwOWY1YTFjMWNhYzIxCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDEtY29uc3VtZXIveDg2XzY0LXJhbmRjb25maWct
aHN4YTAtMDcxMTAyNTUtMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMy
MQprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2
MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS92bWxpbnV6LTMuMTYuMC1y
YzQtMDAxMTktZzE0NjA0YWIKCjIwMTQtMDctMTAtMTk6NTc6MjcgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgLi4uCTE2CTIzIFNVQ0NFU1MKCkJpc2VjdGluZzogNTcgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDYgc3RlcHMpCltlZDUxYjg3ZDBiOWU4ODRk
NTY0NjJlMzY0YjE1ZDZkY2QzMTk0MWQ2XSBNZXJnZSAnZHJtL2RybS1maXhlcycgaW50byBk
ZXZlbC1ob3VybHktMjAxNDA3MTAxOApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg5L29iai1iaXNlY3QK
bHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhz
eGEwLTA3MTEwMjU1L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDcxMDE4OmVkNTFi
ODdkMGI5ZTg4NGQ1NjQ2MmUzNjRiMTVkNmRjZDMxOTQxZDY6YmlzZWN0LWxpbnV4OQoKMjAx
NC0wNy0xMC0xOTo1OTo1OCBlZDUxYjg3ZDBiOWU4ODRkNTY0NjJlMzY0YjE1ZDZkY2QzMTk0
MWQ2IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LWVkNTFiODdkMGI5ZTg4
NGQ1NjQ2MmUzNjRiMTVkNmRjZDMxOTQxZDYKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1L2VkNTFiODdkMGI5ZTg4NGQ1NjQ2
MmUzNjRiMTVkNmRjZDMxOTQxZDYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LWVk
NTFiODdkMGI5ZTg4NGQ1NjQ2MmUzNjRiMTVkNmRjZDMxOTQxZDYKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMS1jb25zdW1l
ci94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS1lZDUxYjg3ZDBiOWU4ODRkNTY0
NjJlMzY0YjE1ZDZkY2QzMTk0MWQ2Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMC0wNzExMDI1NS9lZDUxYjg3ZDBiOWU4ODRkNTY0NjJlMzY0YjE1ZDZkY2QzMTk0
MWQ2L3ZtbGludXotMy4xNi4wLXJjNC0wMDE1MS1nZWQ1MWI4NwoKMjAxNC0wNy0xMC0yMDow
Mzo1OCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMTggVEVTVCBGQUlMVVJFClsgICAgOS4wNDAw
OTldIGkyYyBpMmMtMDogZGV0ZWN0IGZhaWw6IGFkZHJlc3MgbWF0Y2gsIDB4MmYKWyAgICA5
LjA0MDA5OV0gaTJjIGkyYy0wOiBkZXRlY3QgZmFpbDogYWRkcmVzcyBtYXRjaCwgMHgyZgoK
QlVHOiBrZXJuZWwgYm9vdCBoYW5nCkVsYXBzZWQgdGltZTogMzUKcWVtdS1zeXN0ZW0teDg2
XzY0IC1jcHUga3ZtNjQgLWVuYWJsZS1rdm0gLWtlcm5lbCAva2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWhzeGEwLTA3MTEwMjU1L2VkNTFiODdkMGI5ZTg4NGQ1NjQ2MmUzNjRiMTVkNmRj
ZDMxOTQxZDYvdm1saW51ei0zLjE2LjAtcmM0LTAwMTUxLWdlZDUxYjg3IC1hcHBlbmQgJ2h1
bmdfdGFza19wYW5pYz0xIGVhcmx5cHJpbnRrPXR0eVMwLDExNTIwMCBkZWJ1ZyBhcGljPWRl
YnVnIHN5c3JxX2Fsd2F5c19lbmFibGVkIHJjdXBkYXRlLnJjdV9jcHVfc3RhbGxfdGltZW91
dD0xMDAgcGFuaWM9MTAgc29mdGxvY2t1cF9wYW5pYz0xIG5taV93YXRjaGRvZz1wYW5pYyAg
cHJvbXB0X3JhbWRpc2s9MCBjb25zb2xlPXR0eVMwLDExNTIwMCBjb25zb2xlPXR0eTAgdmdh
PW5vcm1hbCAgcm9vdD0vZGV2L3JhbTAgcncgbGluaz0va2J1aWxkLXRlc3RzL3J1bi1xdWV1
ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvbGludXgtZGV2ZWw6ZGV2
ZWwtaG91cmx5LTIwMTQwNzEwMTg6ZWQ1MWI4N2QwYjllODg0ZDU2NDYyZTM2NGIxNWQ2ZGNk
MzE5NDFkNjpiaXNlY3QtbGludXg5Ly52bWxpbnV6LWVkNTFiODdkMGI5ZTg4NGQ1NjQ2MmUz
NjRiMTVkNmRjZDMxOTQxZDYtMjAxNDA3MTEwNDA0MDUtMi1pdmI0NCBicmFuY2g9bGludXgt
ZGV2ZWwvZGV2ZWwtaG91cmx5LTIwMTQwNzEwMTggQk9PVF9JTUFHRT0va2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1L2VkNTFiODdkMGI5ZTg4NGQ1NjQ2MmUzNjRi
MTVkNmRjZDMxOTQxZDYvdm1saW51ei0zLjE2LjAtcmM0LTAwMTUxLWdlZDUxYjg3IGRyYmQu
bWlub3JfY291bnQ9OCcgIC1pbml0cmQgL2tlcm5lbC10ZXN0cy9pbml0cmQvcXVhbnRhbC1j
b3JlLXg4Nl82NC5jZ3ogLW0gMzIwIC1zbXAgMiAtbmV0IG5pYyx2bGFuPTEsbW9kZWw9ZTEw
MDAgLW5ldCB1c2VyLHZsYW49MSAtYm9vdCBvcmRlcj1uYyAtbm8tcmVib290IC13YXRjaGRv
ZyBpNjMwMGVzYiAtcnRjIGJhc2U9bG9jYWx0aW1lIC1waWRmaWxlIC9kZXYvc2htL2tib290
L3BpZC1xdWFudGFsLWl2YjQ0LTEwNyAtc2VyaWFsIGZpbGU6L2Rldi9zaG0va2Jvb3Qvc2Vy
aWFsLXF1YW50YWwtaXZiNDQtMTA3IC1kYWVtb25pemUgLWRpc3BsYXkgbm9uZSAtbW9uaXRv
ciBudWxsIAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1L2VkNTFi
ODdkMGI5ZTg4NGQ1NjQ2MmUzNjRiMTVkNmRjZDMxOTQxZDYvZG1lc2cteW9jdG8taXZiNDQt
Njk6MjAxNDA3MTAyMDAyMzM6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1L2VkNTFiODdkMGI5ZTg4
NGQ1NjQ2MmUzNjRiMTVkNmRjZDMxOTQxZDYvZG1lc2cteW9jdG8taXZiNDQtNzg6MjAxNDA3
MTAyMDAyMzI6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6OgowOjI6MjAgYWxs
X2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDctMTAgMjA6MDQ6MjkgUkVQ
RUFUIENPVU5UOiAxMTAgICMgL2MvYm9vdC1iaXNlY3QvbGludXg5L29iai1iaXNlY3QvLnJl
cGVhdBtbMG0KCkJpc2VjdGluZzogMzIgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0
aGlzIChyb3VnaGx5IDYgc3RlcHMpClszZTZkOTE2YTgzY2VlMDczMDFhNGVkMzExOTZiNWUz
M2I1NGI4NWE2XSBNZXJnZSAncmN1L21haW50YWluZXJzLjIwMTQuMDcuMDhiJyBpbnRvIGRl
dmVsLWhvdXJseS0yMDE0MDcxMDE4CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDkvb2JqLWJpc2VjdAps
cyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDcxMTAyNTUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNzEwMTg6M2U2ZDkx
NmE4M2NlZTA3MzAxYTRlZDMxMTk2YjVlMzNiNTRiODVhNjpiaXNlY3QtbGludXg5CgoyMDE0
LTA3LTEwLTIwOjA0OjI5IDNlNmQ5MTZhODNjZWUwNzMwMWE0ZWQzMTE5NmI1ZTMzYjU0Yjg1
YTYgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUtM2U2ZDkxNmE4M2NlZTA3
MzAxYTRlZDMxMTk2YjVlMzNiNTRiODVhNgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvM2U2ZDkxNmE4M2NlZTA3MzAxYTRl
ZDMxMTk2YjVlMzNiNTRiODVhNgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUtM2U2
ZDkxNmE4M2NlZTA3MzAxYTRlZDMxMTk2YjVlMzNiNTRiODVhNgprZXJuZWw6IC9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvM2U2ZDkxNmE4M2NlZTA3MzAxYTRl
ZDMxMTk2YjVlMzNiNTRiODVhNi92bWxpbnV6LTMuMTYuMC1yYzQtMDAxMjctZzNlNmQ5MTYK
CjIwMTQtMDctMTAtMjA6MTE6MjkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTI1CTI5IFRFU1Qg
RkFJTFVSRQpbICAgIDguMzcwMDg0XSBpMmMgaTJjLTA6IGRldGVjdCBmYWlsOiBhZGRyZXNz
IG1hdGNoLCAweDJmClsgICAgOC4zNzAwODRdIGkyYyBpMmMtMDogZGV0ZWN0IGZhaWw6IGFk
ZHJlc3MgbWF0Y2gsIDB4MmYKCkJVRzoga2VybmVsIGJvb3QgaGFuZwpFbGFwc2VkIHRpbWU6
IDM1CnFlbXUtc3lzdGVtLXg4Nl82NCAtY3B1IGt2bTY0IC1lbmFibGUta3ZtIC1rZXJuZWwg
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8zZTZkOTE2YTgzY2Vl
MDczMDFhNGVkMzExOTZiNWUzM2I1NGI4NWE2L3ZtbGludXotMy4xNi4wLXJjNC0wMDEyNy1n
M2U2ZDkxNiAtYXBwZW5kICdodW5nX3Rhc2tfcGFuaWM9MSBlYXJseXByaW50az10dHlTMCwx
MTUyMDAgZGVidWcgYXBpYz1kZWJ1ZyBzeXNycV9hbHdheXNfZW5hYmxlZCByY3VwZGF0ZS5y
Y3VfY3B1X3N0YWxsX3RpbWVvdXQ9MTAwIHBhbmljPTEwIHNvZnRsb2NrdXBfcGFuaWM9MSBu
bWlfd2F0Y2hkb2c9cGFuaWMgIHByb21wdF9yYW1kaXNrPTAgY29uc29sZT10dHlTMCwxMTUy
MDAgY29uc29sZT10dHkwIHZnYT1ub3JtYWwgIHJvb3Q9L2Rldi9yYW0wIHJ3IGxpbms9L2ti
dWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEw
MjU1L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDcxMDE4OjNlNmQ5MTZhODNjZWUw
NzMwMWE0ZWQzMTE5NmI1ZTMzYjU0Yjg1YTY6YmlzZWN0LWxpbnV4OS8udm1saW51ei0zZTZk
OTE2YTgzY2VlMDczMDFhNGVkMzExOTZiNWUzM2I1NGI4NWE2LTIwMTQwNzExMDQxMTMwLTE2
LWl2YjQ0IGJyYW5jaD1saW51eC1kZXZlbC9kZXZlbC1ob3VybHktMjAxNDA3MTAxOCBCT09U
X0lNQUdFPS9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvM2U2ZDkx
NmE4M2NlZTA3MzAxYTRlZDMxMTk2YjVlMzNiNTRiODVhNi92bWxpbnV6LTMuMTYuMC1yYzQt
MDAxMjctZzNlNmQ5MTYgZHJiZC5taW5vcl9jb3VudD04JyAgLWluaXRyZCAva2VybmVsLXRl
c3RzL2luaXRyZC9xdWFudGFsLWNvcmUteDg2XzY0LmNneiAtbSAzMjAgLXNtcCAyIC1uZXQg
bmljLHZsYW49MSxtb2RlbD1lMTAwMCAtbmV0IHVzZXIsdmxhbj0xIC1ib290IG9yZGVyPW5j
IC1uby1yZWJvb3QgLXdhdGNoZG9nIGk2MzAwZXNiIC1ydGMgYmFzZT1sb2NhbHRpbWUgLXBp
ZGZpbGUgL2Rldi9zaG0va2Jvb3QvcGlkLXF1YW50YWwtaXZiNDQtMTAwIC1zZXJpYWwgZmls
ZTovZGV2L3NobS9rYm9vdC9zZXJpYWwtcXVhbnRhbC1pdmI0NC0xMDAgLWRhZW1vbml6ZSAt
ZGlzcGxheSBub25lIC1tb25pdG9yIG51bGwgCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
aHN4YTAtMDcxMTAyNTUvM2U2ZDkxNmE4M2NlZTA3MzAxYTRlZDMxMTk2YjVlMzNiNTRiODVh
Ni9kbWVzZy15b2N0by1pdmI0NC0xMDc6MjAxNDA3MTAyMDEwMTU6eDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3
MTEwMjU1LzNlNmQ5MTZhODNjZWUwNzMwMWE0ZWQzMTE5NmI1ZTMzYjU0Yjg1YTYvZG1lc2ct
eW9jdG8taXZiNDQtMTEzOjIwMTQwNzEwMjAxMDE2Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEw
LTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8z
ZTZkOTE2YTgzY2VlMDczMDFhNGVkMzExOTZiNWUzM2I1NGI4NWE2L2RtZXNnLXlvY3RvLWl2
YjQ0LTEyNjoyMDE0MDcxMDIwMTAxNTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1
NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvM2U2ZDkxNmE4
M2NlZTA3MzAxYTRlZDMxMTk2YjVlMzNiNTRiODVhNi9kbWVzZy15b2N0by1pdmI0NC0yODoy
MDE0MDcxMDIwMTAxNjp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvM2U2ZDkxNmE4M2NlZTA3MzAx
YTRlZDMxMTk2YjVlMzNiNTRiODVhNi9kbWVzZy15b2N0by1pdmI0NC0zMzoyMDE0MDcxMDIw
MTAxNTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvM2U2ZDkxNmE4M2NlZTA3MzAxYTRlZDMxMTk2
YjVlMzNiNTRiODVhNi9kbWVzZy15b2N0by1pdmI0NC0zNjoyMDE0MDcxMDIwMTAxNjp4ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDcxMTAyNTUvM2U2ZDkxNmE4M2NlZTA3MzAxYTRlZDMxMTk2YjVlMzNiNTRi
ODVhNi9kbWVzZy15b2N0by1pdmI0NC0zOjIwMTQwNzEwMjAxMDE1Ong4Nl82NC1yYW5kY29u
ZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0w
NzExMDI1NS8zZTZkOTE2YTgzY2VlMDczMDFhNGVkMzExOTZiNWUzM2I1NGI4NWE2L2RtZXNn
LXlvY3RvLWl2YjQ0LTQxOjIwMTQwNzEwMjAxMDE2Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEw
LTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8z
ZTZkOTE2YTgzY2VlMDczMDFhNGVkMzExOTZiNWUzM2I1NGI4NWE2L2RtZXNnLXlvY3RvLWl2
YjQ0LTUzOjIwMTQwNzEwMjAxMDE2Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1
OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8zZTZkOTE2YTgz
Y2VlMDczMDFhNGVkMzExOTZiNWUzM2I1NGI4NWE2L2RtZXNnLXlvY3RvLWl2YjQ0LTU1OjIw
MTQwNzEwMjAxMDE1Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8zZTZkOTE2YTgzY2VlMDczMDFh
NGVkMzExOTZiNWUzM2I1NGI4NWE2L2RtZXNnLXlvY3RvLWl2YjQ0LTU2OjIwMTQwNzEwMjAx
MDE1Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8zZTZkOTE2YTgzY2VlMDczMDFhNGVkMzExOTZi
NWUzM2I1NGI4NWE2L2RtZXNnLXlvY3RvLWl2YjQ0LTYyOjIwMTQwNzEwMjAxMDE1Ong4Nl82
NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMC0wNzExMDI1NS8zZTZkOTE2YTgzY2VlMDczMDFhNGVkMzExOTZiNWUzM2I1NGI4
NWE2L2RtZXNnLXlvY3RvLWl2YjQ0LTczOjIwMTQwNzEwMjAxMDE1Ong4Nl82NC1yYW5kY29u
ZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0w
NzExMDI1NS8zZTZkOTE2YTgzY2VlMDczMDFhNGVkMzExOTZiNWUzM2I1NGI4NWE2L2RtZXNn
LXlvY3RvLWl2YjQ0LTc4OjIwMTQwNzEwMjAxMDE2Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEw
LTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8z
ZTZkOTE2YTgzY2VlMDczMDFhNGVkMzExOTZiNWUzM2I1NGI4NWE2L2RtZXNnLXlvY3RvLWl2
YjQ0LTgzOjIwMTQwNzEwMjAxMDE2Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1
OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8zZTZkOTE2YTgz
Y2VlMDczMDFhNGVkMzExOTZiNWUzM2I1NGI4NWE2L2RtZXNnLXlvY3RvLWl2YjQ0LTkyOjIw
MTQwNzEwMjAxMDE2Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8zZTZkOTE2YTgzY2VlMDczMDFh
NGVkMzExOTZiNWUzM2I1NGI4NWE2L2RtZXNnLXlvY3RvLWl2YjQ0LTMyOjIwMTQwNzEwMjAx
MDE5Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8zZTZkOTE2YTgzY2VlMDczMDFhNGVkMzExOTZi
NWUzM2I1NGI4NWE2L2RtZXNnLXlvY3RvLWl2YjQ0LTEwMDoyMDE0MDcxMDIwMTAyMTp4ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDcxMTAyNTUvM2U2ZDkxNmE4M2NlZTA3MzAxYTRlZDMxMTk2YjVlMzNiNTRi
ODVhNi9kbWVzZy15b2N0by1pdmI0NC0xMDM6MjAxNDA3MTAyMDEwMjM6eDg2XzY0LXJhbmRj
b25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEw
LTA3MTEwMjU1LzNlNmQ5MTZhODNjZWUwNzMwMWE0ZWQzMTE5NmI1ZTMzYjU0Yjg1YTYvZG1l
c2cteW9jdG8taXZiNDQtMTA4OjIwMTQwNzEwMjAxMDI0Ong4Nl82NC1yYW5kY29uZmlnLWhz
eGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1
NS8zZTZkOTE2YTgzY2VlMDczMDFhNGVkMzExOTZiNWUzM2I1NGI4NWE2L2RtZXNnLXlvY3Rv
LWl2YjQ0LTEwOToyMDE0MDcxMDIwMTAzMDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzEx
MDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvM2U2ZDkx
NmE4M2NlZTA3MzAxYTRlZDMxMTk2YjVlMzNiNTRiODVhNi9kbWVzZy15b2N0by1pdmI0NC0x
MDoyMDE0MDcxMDIwMTAyMzp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvM2U2ZDkxNmE4M2NlZTA3
MzAxYTRlZDMxMTk2YjVlMzNiNTRiODVhNi9kbWVzZy15b2N0by1pdmI0NC0xMTI6MjAxNDA3
MTAyMDEwMjM6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzNlNmQ5MTZhODNjZWUwNzMwMWE0ZWQz
MTE5NmI1ZTMzYjU0Yjg1YTYvZG1lc2cteW9jdG8taXZiNDQtMTE0OjIwMTQwNzEwMjAxMDIz
Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8zZTZkOTE2YTgzY2VlMDczMDFhNGVkMzExOTZiNWUz
M2I1NGI4NWE2L2RtZXNnLXlvY3RvLWl2YjQ0LTExNToyMDE0MDcxMDIwMTAyNTp4ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
aHN4YTAtMDcxMTAyNTUvM2U2ZDkxNmE4M2NlZTA3MzAxYTRlZDMxMTk2YjVlMzNiNTRiODVh
Ni9kbWVzZy15b2N0by1pdmI0NC0xMTc6MjAxNDA3MTAyMDEwMjE6eDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3
MTEwMjU1LzNlNmQ5MTZhODNjZWUwNzMwMWE0ZWQzMTE5NmI1ZTMzYjU0Yjg1YTYvZG1lc2ct
eW9jdG8taXZiNDQtMTE5OjIwMTQwNzEwMjAxMDI0Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEw
LTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8z
ZTZkOTE2YTgzY2VlMDczMDFhNGVkMzExOTZiNWUzM2I1NGI4NWE2L2RtZXNnLXlvY3RvLWl2
YjQ0LTExOjIwMTQwNzEwMjAxMDIxOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1
OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8zZTZkOTE2YTgz
Y2VlMDczMDFhNGVkMzExOTZiNWUzM2I1NGI4NWE2L2RtZXNnLXlvY3RvLWl2YjQ0LTEyMToy
MDE0MDcxMDIwMTAyMjp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvM2U2ZDkxNmE4M2NlZTA3MzAx
YTRlZDMxMTk2YjVlMzNiNTRiODVhNi9kbWVzZy15b2N0by1pdmI0NC0xMjg6MjAxNDA3MTAy
MDEwMjU6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzNlNmQ5MTZhODNjZWUwNzMwMWE0ZWQzMTE5
NmI1ZTMzYjU0Yjg1YTYvZG1lc2cteW9jdG8taXZiNDQtMTI6MjAxNDA3MTAyMDEwMjM6eDg2
XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWhzeGEwLTA3MTEwMjU1LzNlNmQ5MTZhODNjZWUwNzMwMWE0ZWQzMTE5NmI1ZTMzYjU0
Yjg1YTYvZG1lc2cteW9jdG8taXZiNDQtMTM6MjAxNDA3MTAyMDEwMjk6eDg2XzY0LXJhbmRj
b25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEw
LTA3MTEwMjU1LzNlNmQ5MTZhODNjZWUwNzMwMWE0ZWQzMTE5NmI1ZTMzYjU0Yjg1YTYvZG1l
c2cteW9jdG8taXZiNDQtMTU6MjAxNDA3MTAyMDEwMjU6eDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1
LzNlNmQ5MTZhODNjZWUwNzMwMWE0ZWQzMTE5NmI1ZTMzYjU0Yjg1YTYvZG1lc2cteW9jdG8t
aXZiNDQtMTc6MjAxNDA3MTAyMDEwMjM6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAy
NTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzNlNmQ5MTZh
ODNjZWUwNzMwMWE0ZWQzMTE5NmI1ZTMzYjU0Yjg1YTYvZG1lc2cteW9jdG8taXZiNDQtMTk6
MjAxNDA3MTAyMDEwMjg6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzNlNmQ5MTZhODNjZWUwNzMw
MWE0ZWQzMTE5NmI1ZTMzYjU0Yjg1YTYvZG1lc2cteW9jdG8taXZiNDQtMToyMDE0MDcxMDIw
MTAyMDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvM2U2ZDkxNmE4M2NlZTA3MzAxYTRlZDMxMTk2
YjVlMzNiNTRiODVhNi9kbWVzZy15b2N0by1pdmI0NC0yMDoyMDE0MDcxMDIwMTAyMzp4ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDcxMTAyNTUvM2U2ZDkxNmE4M2NlZTA3MzAxYTRlZDMxMTk2YjVlMzNiNTRi
ODVhNi9kbWVzZy15b2N0by1pdmI0NC0yMjoyMDE0MDcxMDIwMTAyMjp4ODZfNjQtcmFuZGNv
bmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAt
MDcxMTAyNTUvM2U2ZDkxNmE4M2NlZTA3MzAxYTRlZDMxMTk2YjVlMzNiNTRiODVhNi9kbWVz
Zy15b2N0by1pdmI0NC0yNToyMDE0MDcxMDIwMTAyNTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUv
M2U2ZDkxNmE4M2NlZTA3MzAxYTRlZDMxMTk2YjVlMzNiNTRiODVhNi9kbWVzZy15b2N0by1p
dmI0NC0yNjoyMDE0MDcxMDIwMTAyMjp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1
NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvM2U2ZDkxNmE4
M2NlZTA3MzAxYTRlZDMxMTk2YjVlMzNiNTRiODVhNi9kbWVzZy15b2N0by1pdmI0NC0yNzoy
MDE0MDcxMDIwMTAyNTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvM2U2ZDkxNmE4M2NlZTA3MzAx
YTRlZDMxMTk2YjVlMzNiNTRiODVhNi9kbWVzZy15b2N0by1pdmI0NC0yOToyMDE0MDcxMDIw
MTAyNDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvM2U2ZDkxNmE4M2NlZTA3MzAxYTRlZDMxMTk2
YjVlMzNiNTRiODVhNi9kbWVzZy15b2N0by1pdmI0NC0yOjIwMTQwNzEwMjAxMDIzOng4Nl82
NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMC0wNzExMDI1NS8zZTZkOTE2YTgzY2VlMDczMDFhNGVkMzExOTZiNWUzM2I1NGI4
NWE2L2RtZXNnLXlvY3RvLWl2YjQ0LTMwOjIwMTQwNzEwMjAxMDIzOng4Nl82NC1yYW5kY29u
ZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0w
NzExMDI1NS8zZTZkOTE2YTgzY2VlMDczMDFhNGVkMzExOTZiNWUzM2I1NGI4NWE2L2RtZXNn
LXlvY3RvLWl2YjQ0LTMxOjIwMTQwNzEwMjAxMDI1Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEw
LTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8z
ZTZkOTE2YTgzY2VlMDczMDFhNGVkMzExOTZiNWUzM2I1NGI4NWE2L2RtZXNnLXlvY3RvLWl2
YjQ0LTM1OjIwMTQwNzEwMjAxMDIzOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1
OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8zZTZkOTE2YTgz
Y2VlMDczMDFhNGVkMzExOTZiNWUzM2I1NGI4NWE2L2RtZXNnLXlvY3RvLWl2YjQ0LTM5OjIw
MTQwNzEwMjAxMDI0Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8zZTZkOTE2YTgzY2VlMDczMDFh
NGVkMzExOTZiNWUzM2I1NGI4NWE2L2RtZXNnLXlvY3RvLWl2YjQ0LTQyOjIwMTQwNzEwMjAx
MDI0Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8zZTZkOTE2YTgzY2VlMDczMDFhNGVkMzExOTZi
NWUzM2I1NGI4NWE2L2RtZXNnLXlvY3RvLWl2YjQ0LTQ0OjIwMTQwNzEwMjAxMDI2Ong4Nl82
NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMC0wNzExMDI1NS8zZTZkOTE2YTgzY2VlMDczMDFhNGVkMzExOTZiNWUzM2I1NGI4
NWE2L2RtZXNnLXlvY3RvLWl2YjQ0LTQ5OjIwMTQwNzEwMjAxMDIwOng4Nl82NC1yYW5kY29u
ZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0w
NzExMDI1NS8zZTZkOTE2YTgzY2VlMDczMDFhNGVkMzExOTZiNWUzM2I1NGI4NWE2L2RtZXNn
LXlvY3RvLWl2YjQ0LTUwOjIwMTQwNzEwMjAxMDI0Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEw
LTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8z
ZTZkOTE2YTgzY2VlMDczMDFhNGVkMzExOTZiNWUzM2I1NGI4NWE2L2RtZXNnLXlvY3RvLWl2
YjQ0LTU3OjIwMTQwNzEwMjAxMDIyOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1
OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8zZTZkOTE2YTgz
Y2VlMDczMDFhNGVkMzExOTZiNWUzM2I1NGI4NWE2L2RtZXNnLXlvY3RvLWl2YjQ0LTU4OjIw
MTQwNzEwMjAxMDI1Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8zZTZkOTE2YTgzY2VlMDczMDFh
NGVkMzExOTZiNWUzM2I1NGI4NWE2L2RtZXNnLXlvY3RvLWl2YjQ0LTU5OjIwMTQwNzEwMjAx
MDI0Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8zZTZkOTE2YTgzY2VlMDczMDFhNGVkMzExOTZi
NWUzM2I1NGI4NWE2L2RtZXNnLXlvY3RvLWl2YjQ0LTU6MjAxNDA3MTAyMDEwMjU6eDg2XzY0
LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWhzeGEwLTA3MTEwMjU1LzNlNmQ5MTZhODNjZWUwNzMwMWE0ZWQzMTE5NmI1ZTMzYjU0Yjg1
YTYvZG1lc2cteW9jdG8taXZiNDQtNjE6MjAxNDA3MTAyMDEwMjU6eDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3
MTEwMjU1LzNlNmQ5MTZhODNjZWUwNzMwMWE0ZWQzMTE5NmI1ZTMzYjU0Yjg1YTYvZG1lc2ct
eW9jdG8taXZiNDQtNjU6MjAxNDA3MTAyMDEwMjQ6eDg2XzY0LXJhbmRjb25maWctaHN4YTAt
MDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzNl
NmQ5MTZhODNjZWUwNzMwMWE0ZWQzMTE5NmI1ZTMzYjU0Yjg1YTYvZG1lc2cteW9jdG8taXZi
NDQtNjk6MjAxNDA3MTAyMDEwMjI6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6
Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzNlNmQ5MTZhODNj
ZWUwNzMwMWE0ZWQzMTE5NmI1ZTMzYjU0Yjg1YTYvZG1lc2cteW9jdG8taXZiNDQtNzI6MjAx
NDA3MTAyMDEwMjY6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzNlNmQ5MTZhODNjZWUwNzMwMWE0
ZWQzMTE5NmI1ZTMzYjU0Yjg1YTYvZG1lc2cteW9jdG8taXZiNDQtNzU6MjAxNDA3MTAyMDEw
MjM6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzNlNmQ5MTZhODNjZWUwNzMwMWE0ZWQzMTE5NmI1
ZTMzYjU0Yjg1YTYvZG1lc2cteW9jdG8taXZiNDQtNzc6MjAxNDA3MTAyMDEwMzA6eDg2XzY0
LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWhzeGEwLTA3MTEwMjU1LzNlNmQ5MTZhODNjZWUwNzMwMWE0ZWQzMTE5NmI1ZTMzYjU0Yjg1
YTYvZG1lc2cteW9jdG8taXZiNDQtNzk6MjAxNDA3MTAyMDEwMjQ6eDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3
MTEwMjU1LzNlNmQ5MTZhODNjZWUwNzMwMWE0ZWQzMTE5NmI1ZTMzYjU0Yjg1YTYvZG1lc2ct
eW9jdG8taXZiNDQtODE6MjAxNDA3MTAyMDEwMjk6eDg2XzY0LXJhbmRjb25maWctaHN4YTAt
MDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzNl
NmQ5MTZhODNjZWUwNzMwMWE0ZWQzMTE5NmI1ZTMzYjU0Yjg1YTYvZG1lc2cteW9jdG8taXZi
NDQtODQ6MjAxNDA3MTAyMDEwMjI6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6
Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzNlNmQ5MTZhODNj
ZWUwNzMwMWE0ZWQzMTE5NmI1ZTMzYjU0Yjg1YTYvZG1lc2cteW9jdG8taXZiNDQtODU6MjAx
NDA3MTAyMDEwMjU6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzNlNmQ5MTZhODNjZWUwNzMwMWE0
ZWQzMTE5NmI1ZTMzYjU0Yjg1YTYvZG1lc2cteW9jdG8taXZiNDQtODg6MjAxNDA3MTAyMDEw
MjE6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzNlNmQ5MTZhODNjZWUwNzMwMWE0ZWQzMTE5NmI1
ZTMzYjU0Yjg1YTYvZG1lc2cteW9jdG8taXZiNDQtODk6MjAxNDA3MTAyMDEwMjQ6eDg2XzY0
LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWhzeGEwLTA3MTEwMjU1LzNlNmQ5MTZhODNjZWUwNzMwMWE0ZWQzMTE5NmI1ZTMzYjU0Yjg1
YTYvZG1lc2cteW9jdG8taXZiNDQtOTE6MjAxNDA3MTAyMDEwMjE6eDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3
MTEwMjU1LzNlNmQ5MTZhODNjZWUwNzMwMWE0ZWQzMTE5NmI1ZTMzYjU0Yjg1YTYvZG1lc2ct
eW9jdG8taXZiNDQtOTM6MjAxNDA3MTAyMDEwMjQ6eDg2XzY0LXJhbmRjb25maWctaHN4YTAt
MDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzNl
NmQ5MTZhODNjZWUwNzMwMWE0ZWQzMTE5NmI1ZTMzYjU0Yjg1YTYvZG1lc2cteW9jdG8taXZi
NDQtOTY6MjAxNDA3MTAyMDEwMjU6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6
Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzNlNmQ5MTZhODNj
ZWUwNzMwMWE0ZWQzMTE5NmI1ZTMzYjU0Yjg1YTYvZG1lc2cteW9jdG8taXZiNDQtOTk6MjAx
NDA3MTAyMDEwMjE6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzNlNmQ5MTZhODNjZWUwNzMwMWE0
ZWQzMTE5NmI1ZTMzYjU0Yjg1YTYvZG1lc2cteW9jdG8taXZiNDQtOToyMDE0MDcxMDIwMTAy
Mzp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6CjA6NzI6MTAxIGFsbF9nb29k
OmJhZDphbGxfYmFkIGJvb3RzCgpsaW5lYXItYmlzZWN0OiBiYWQgYnJhbmNoIG1heSBiZSBy
Y3UvbWFpbnRhaW5lcnMuMjAxNC4wNy4wOGIKbGluZWFyLWJpc2VjdDogaGFuZGxlIG92ZXIg
dG8gZ2l0IGJpc2VjdApsaW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0IHN0YXJ0IDNlNmQ5MTZh
ODNjZWUwNzMwMWE0ZWQzMTE5NmI1ZTMzYjU0Yjg1YTYgMTQ2MDRhYjM2ZmFiYTg4YTg5Y2Iy
Yzk2MTE1MDlmNWExYzFjYWMyMSAtLQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAzZTZk
OTE2Li4uIE1lcmdlICdyY3UvbWFpbnRhaW5lcnMuMjAxNC4wNy4wOGInIGludG8gZGV2ZWwt
aG91cmx5LTIwMTQwNzEwMTgKSEVBRCBpcyBub3cgYXQgZTZkNjlhNi4uLiBNZXJnZSBicmFu
Y2ggJ25leHQnIG9mIGdpdDovL2dpdC5pbmZyYWRlYWQub3JnL3VzZXJzL3Zrb3VsL3NsYXZl
LWRtYQpCaXNlY3Rpbmc6IDMgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChy
b3VnaGx5IDIgc3RlcHMpCls0NjMyYTE5MTljZTFiNDJlOTMzMjFjOGVlYjM3NDdjYjI2YmNj
NWFjXSByY3U6IEFkZCBkZXNpZ25hdGVkIHJldmlld2VycyBmb3IgUkNVCmxpbmVhci1iaXNl
Y3Q6IGdpdCBiaXNlY3QgcnVuIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg5L29iai1iaXNlY3QKcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0
L2xpbnV4OS9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS9saW51eC1kZXZlbDpkZXZlbC1ob3Vy
bHktMjAxNDA3MTAxODo0NjMyYTE5MTljZTFiNDJlOTMzMjFjOGVlYjM3NDdjYjI2YmNjNWFj
OmJpc2VjdC1saW51eDkKCjIwMTQtMDctMTAtMjA6MTI6NDYgNDYzMmExOTE5Y2UxYjQyZTkz
MzIxYzhlZWIzNzQ3Y2IyNmJjYzVhYyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8g
L2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzEx
MDI1NS00NjMyYTE5MTljZTFiNDJlOTMzMjFjOGVlYjM3NDdjYjI2YmNjNWFjCkNoZWNrIGZv
ciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS80
NjMyYTE5MTljZTFiNDJlOTMzMjFjOGVlYjM3NDdjYjI2YmNjNWFjCndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMC0wNzExMDI1NS00NjMyYTE5MTljZTFiNDJlOTMzMjFjOGVlYjM3NDdjYjI2YmNj
NWFjCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS9sa3AtaHN4MDEtY29uc3VtZXIveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUt
NDYzMmExOTE5Y2UxYjQyZTkzMzIxYzhlZWIzNzQ3Y2IyNmJjYzVhYwprZXJuZWw6IC9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvNDYzMmExOTE5Y2UxYjQyZTkz
MzIxYzhlZWIzNzQ3Y2IyNmJjYzVhYy92bWxpbnV6LTMuMTYuMC1yYzEtMDAwMDQtZzQ2MzJh
MTkKCjIwMTQtMDctMTAtMjA6MTc6NDYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTU5CTY5CTcw
CTExMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDEgcmV2aXNpb24gbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgMSBzdGVwKQpbMzRlMmQ1NjBiY2RkNjM5NzE3MzY3YTU3MDA2MzAx
MWFlNzRiNjc4Ml0gcmN1OiBVcGRhdGUgcmN1IHRvcnR1cmUgbWFpbnRhaW5lcnNoaXAgZmls
ZW5hbWUgcGF0dGVybnMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4OS9vYmotYmlzZWN0CmxzIC1hIC9r
YnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzEx
MDI1NS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA3MTAxODozNGUyZDU2MGJjZGQ2
Mzk3MTczNjdhNTcwMDYzMDExYWU3NGI2NzgyOmJpc2VjdC1saW51eDkKCjIwMTQtMDctMTAt
MjA6MTk6NDYgMzRlMmQ1NjBiY2RkNjM5NzE3MzY3YTU3MDA2MzAxMWFlNzRiNjc4MiBjb21w
aWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS0zNGUyZDU2MGJjZGQ2Mzk3MTczNjdh
NTcwMDYzMDExYWU3NGI2NzgyCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8zNGUyZDU2MGJjZGQ2Mzk3MTczNjdhNTcwMDYz
MDExYWU3NGI2NzgyCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS0zNGUyZDU2MGJj
ZGQ2Mzk3MTczNjdhNTcwMDYzMDExYWU3NGI2NzgyCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9qYWtldG93bi1jb25zdW1lci94ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS0zNGUyZDU2MGJjZGQ2Mzk3MTczNjdhNTcwMDYz
MDExYWU3NGI2NzgyCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0w
NzExMDI1NS8zNGUyZDU2MGJjZGQ2Mzk3MTczNjdhNTcwMDYzMDExYWU3NGI2NzgyL3ZtbGlu
dXotMy4xNi4wLXJjMS0wMDAwNi1nMzRlMmQ1NgoKMjAxNC0wNy0xMC0yMDozMTo0NyBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAuCTQuCTIyCTI0Lgk0NC4JNTMJNTQJNjgJODEJODIJODcJOTEJ
MTA4CTExMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMpCltjMWMzZjJjOTA2ZTM1YmNiNmU0Y2RmNWI4
ZTA3NzY2MGZlYWQxNGZlXSBzY3JpcHRzOiBUZWFjaCBnZXRfbWFpbnRhaW5lci5wbCBhYm91
dCB0aGUgbmV3ICJSOiIgdGFnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDkvb2JqLWJpc2VjdApscyAt
YSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaHN4YTAt
MDcxMTAyNTUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNzEwMTg6YzFjM2YyYzkw
NmUzNWJjYjZlNGNkZjViOGUwNzc2NjBmZWFkMTRmZTpiaXNlY3QtbGludXg5CgoyMDE0LTA3
LTEwLTIwOjQwOjE3IGMxYzNmMmM5MDZlMzViY2I2ZTRjZGY1YjhlMDc3NjYwZmVhZDE0ZmUg
Y29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUtYzFjM2YyYzkwNmUzNWJjYjZl
NGNkZjViOGUwNzc2NjBmZWFkMTRmZQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvYzFjM2YyYzkwNmUzNWJjYjZlNGNkZjVi
OGUwNzc2NjBmZWFkMTRmZQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUtYzFjM2Yy
YzkwNmUzNWJjYjZlNGNkZjViOGUwNzc2NjBmZWFkMTRmZQprZXJuZWw6IC9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvYzFjM2YyYzkwNmUzNWJjYjZlNGNkZjVi
OGUwNzc2NjBmZWFkMTRmZS92bWxpbnV6LTMuMTYuMC1yYzEtMDAwMDctZ2MxYzNmMmMKCjIw
MTQtMDctMTAtMjA6NDI6MTcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTQJNwk4CTM3Lgk2MQk2
NQk3OAkxMTAgU1VDQ0VTUwoKM2U2ZDkxNmE4M2NlZTA3MzAxYTRlZDMxMTk2YjVlMzNiNTRi
ODVhNiBpcyB0aGUgZmlyc3QgYmFkIGNvbW1pdApiaXNlY3QgcnVuIHN1Y2Nlc3MKUHJldmlv
dXMgSEVBRCBwb3NpdGlvbiB3YXMgYzFjM2YyYy4uLiBzY3JpcHRzOiBUZWFjaCBnZXRfbWFp
bnRhaW5lci5wbCBhYm91dCB0aGUgbmV3ICJSOiIgdGFnCkhFQUQgaXMgbm93IGF0IDE0NjA0
YWIuLi4gTWVyZ2UgJ3VsZi5oYW5zc29uLW1tYy9uZXh0JyBpbnRvIGRldmVsLWhvdXJseS0y
MDE0MDcxMDE4CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMC0wNzExMDI1NS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA3
MTAxODoxNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxOmJpc2VjdC1s
aW51eDkKCjIwMTQtMDctMTAtMjA6NDY6NDggMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1
MDlmNWExYzFjYWMyMSByZXVzZSAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3
MTEwMjU1LzE0NjA0YWIzNmZhYmE4OGE4OWNiMmM5NjExNTA5ZjVhMWMxY2FjMjEvdm1saW51
ei0zLjE2LjAtcmM0LTAwMTE5LWcxNDYwNGFiCgoyMDE0LTA3LTEwLTIwOjQ2OjQ4IGRldGVj
dGluZyBib290IHN0YXRlIC4JNTEgVEVTVCBGQUlMVVJFClsgICAgOC4wMzAzODhdIGkyYyBp
MmMtMDogZGV0ZWN0IGZhaWw6IGFkZHJlc3MgbWF0Y2gsIDB4MmYKWyAgICA4LjAzMDM4OF0g
aTJjIGkyYy0wOiBkZXRlY3QgZmFpbDogYWRkcmVzcyBtYXRjaCwgMHgyZgoKQlVHOiBrZXJu
ZWwgYm9vdCBoYW5nCkVsYXBzZWQgdGltZTogMzUKcWVtdS1zeXN0ZW0teDg2XzY0IC1jcHUg
a3ZtNjQgLWVuYWJsZS1rdm0gLWtlcm5lbCAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhz
eGEwLTA3MTEwMjU1LzE0NjA0YWIzNmZhYmE4OGE4OWNiMmM5NjExNTA5ZjVhMWMxY2FjMjEv
dm1saW51ei0zLjE2LjAtcmM0LTAwMTE5LWcxNDYwNGFiIC1hcHBlbmQgJ2h1bmdfdGFza19w
YW5pYz0xIGVhcmx5cHJpbnRrPXR0eVMwLDExNTIwMCBkZWJ1ZyBhcGljPWRlYnVnIHN5c3Jx
X2Fsd2F5c19lbmFibGVkIHJjdXBkYXRlLnJjdV9jcHVfc3RhbGxfdGltZW91dD0xMDAgcGFu
aWM9MTAgc29mdGxvY2t1cF9wYW5pYz0xIG5taV93YXRjaGRvZz1wYW5pYyAgcHJvbXB0X3Jh
bWRpc2s9MCBjb25zb2xlPXR0eVMwLDExNTIwMCBjb25zb2xlPXR0eTAgdmdhPW5vcm1hbCAg
cm9vdD0vZGV2L3JhbTAgcncgbGluaz0va2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2
XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5
LTIwMTQwNzEwMTg6MTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMTpi
aXNlY3QtbGludXg5Ly52bWxpbnV6LTE0NjA0YWIzNmZhYmE4OGE4OWNiMmM5NjExNTA5ZjVh
MWMxY2FjMjEtMjAxNDA3MTAyMDQ2NDgtMTIyLWl2YjQxIGJyYW5jaD1saW51eC1kZXZlbC9k
ZXZlbC1ob3VybHktMjAxNDA3MTAxOCBCT09UX0lNQUdFPS9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWEx
YzFjYWMyMS92bWxpbnV6LTMuMTYuMC1yYzQtMDAxMTktZzE0NjA0YWIgZHJiZC5taW5vcl9j
b3VudD04JyAgLWluaXRyZCAva2VybmVsLXRlc3RzL2luaXRyZC9xdWFudGFsLWNvcmUteDg2
XzY0LmNneiAtbSAzMjAgLXNtcCAyIC1uZXQgbmljLHZsYW49MSxtb2RlbD1lMTAwMCAtbmV0
IHVzZXIsdmxhbj0xIC1ib290IG9yZGVyPW5jIC1uby1yZWJvb3QgLXdhdGNoZG9nIGk2MzAw
ZXNiIC1ydGMgYmFzZT1sb2NhbHRpbWUgLXBpZGZpbGUgL2Rldi9zaG0va2Jvb3QvcGlkLXF1
YW50YWwtaXZiNDEtMTA4IC1zZXJpYWwgZmlsZTovZGV2L3NobS9rYm9vdC9zZXJpYWwtcXVh
bnRhbC1pdmI0MS0xMDggLWRhZW1vbml6ZSAtZGlzcGxheSBub25lIC1tb25pdG9yIG51bGwg
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFi
YTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS0xMToyMDE0
MDcxMDIwNDcyMjp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2Iy
Yzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS0xOToyMDE0MDcxMDIwNDcy
Mzp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlm
NWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS0xMTQ6MjAxNDA3MTAyMDQ3MjQ6eDg2XzY0
LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWhzeGEwLTA3MTEwMjU1LzE0NjA0YWIzNmZhYmE4OGE4OWNiMmM5NjExNTA5ZjVhMWMxY2Fj
MjEvZG1lc2cteW9jdG8taXZiNDEtMTQ6MjAxNDA3MTAyMDQ3MjQ6eDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3
MTEwMjU1LzE0NjA0YWIzNmZhYmE4OGE4OWNiMmM5NjExNTA5ZjVhMWMxY2FjMjEvZG1lc2ct
eW9jdG8taXZiNDEtMjM6MjAxNDA3MTAyMDQ3MjQ6eDg2XzY0LXJhbmRjb25maWctaHN4YTAt
MDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzE0
NjA0YWIzNmZhYmE4OGE4OWNiMmM5NjExNTA5ZjVhMWMxY2FjMjEvZG1lc2cteW9jdG8taXZi
NDEtNTA6MjAxNDA3MTAyMDQ3MjQ6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6
Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzE0NjA0YWIzNmZh
YmE4OGE4OWNiMmM5NjExNTA5ZjVhMWMxY2FjMjEvZG1lc2cteW9jdG8taXZiNDEtNTU6MjAx
NDA3MTAyMDQ3MjQ6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzE0NjA0YWIzNmZhYmE4OGE4OWNi
MmM5NjExNTA5ZjVhMWMxY2FjMjEvZG1lc2cteW9jdG8tdnAtMTI6MjAxNDA3MTAyMDQ3NDg6
eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6My4xNi4wLXJjNC0wMDExOS1nMTQ2
MDRhYjozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRh
YjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by12cC0zOToy
MDE0MDcxMDIwNDc0Nzp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTozLjE2LjAt
cmM0LTAwMTE5LWcxNDYwNGFiOjMKMjM6OTozNyBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290
cwoKG1sxOzM1bTIwMTQtMDctMTAgMjA6NDc6NDkgYmFkIGJpc2VjdCwgcmV0cnkgd2l0aCBp
bmNyZWFzZWQgcmVwZWF0IGNvdW50IDMzMBtbMG0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3
YXMgMTQ2MDRhYi4uLiBNZXJnZSAndWxmLmhhbnNzb24tbW1jL25leHQnIGludG8gZGV2ZWwt
aG91cmx5LTIwMTQwNzEwMTgKSEVBRCBpcyBub3cgYXQgYzgwYmUzYS4uLiAwZGF5IGhlYWQg
Z3VhcmQgZm9yICdkZXZlbC1ob3VybHktMjAxNDA3MTAxOCcKZ2l0IGNoZWNrb3V0IGNkM2Rl
ODNmMTQ3NjAxMzU2Mzk1YjU3YTg2NzNlOWM1ZmYxZTU5ZDEKbHMgLWEgL2tidWlsZC10ZXN0
cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1L2xpbnV4
LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDcxMDE4OmNkM2RlODNmMTQ3NjAxMzU2Mzk1YjU3
YTg2NzNlOWM1ZmYxZTU5ZDE6YmlzZWN0LWxpbnV4OQoKMjAxNC0wNy0xMC0yMDo0Nzo1MSBj
ZDNkZTgzZjE0NzYwMTM1NjM5NWI1N2E4NjczZTljNWZmMWU1OWQxIHJldXNlIC9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvY2QzZGU4M2YxNDc2MDEzNTYzOTVi
NTdhODY3M2U5YzVmZjFlNTlkMS92bWxpbnV6LTMuMTYuMC1yYzQKCjIwMTQtMDctMTAtMjA6
NDc6NTEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLgk0CTcwCTEyMQkxMjUJMTYzCTI1OQky
ODcJMzExCTMzMCBTVUNDRVNTCgpiaXNlY3Q6IGdvb2QgY29tbWl0IGNkM2RlODNmMTQ3NjAx
MzU2Mzk1YjU3YTg2NzNlOWM1ZmYxZTU5ZDEKZ2l0IGJpc2VjdCBzdGFydCBjODBiZTNhZTEx
NzcwMDExMDcxMTAzZDNlOTIwODY0YzI3NTQ3MmE4IGNkM2RlODNmMTQ3NjAxMzU2Mzk1YjU3
YTg2NzNlOWM1ZmYxZTU5ZDEgLS0KL2Mva2VybmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6IFsi
LWIiLCAiYzgwYmUzYWUxMTc3MDAxMTA3MTEwM2QzZTkyMDg2NGMyNzU0NzJhOCIsICItZyIs
ICJjZDNkZTgzZjE0NzYwMTM1NjM5NWI1N2E4NjczZTljNWZmMWU1OWQxIiwgIi9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2giLCAiL2MvYm9vdC1iaXNlY3Qv
bGludXg5L29iai1iaXNlY3QiXQpCaXNlY3Rpbmc6IDgyNSByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTAgc3RlcHMpCls2ZTM2ZDQzMzYxMGEzZWJmZGVm
MDAwZjFmYjI4M2UzZjIxOGE4YTMyXSBNZXJnZSAnb21hcC9vbWFwLWZvci12My4xNi9maXhl
cycgaW50byBkZXZlbC1ob3VybHktMjAxNDA3MTAxOApydW5uaW5nIC9jL2tlcm5lbC10ZXN0
cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg5L29i
ai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5k
Y29uZmlnLWhzeGEwLTA3MTEwMjU1L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDcx
MDE4OjZlMzZkNDMzNjEwYTNlYmZkZWYwMDBmMWZiMjgzZTNmMjE4YThhMzI6YmlzZWN0LWxp
bnV4OQogVEVTVCBGQUlMVVJFCi9iaW4vc2g6IC9wcm9jL3NlbGYvZmQvOTogTm8gc3VjaCBm
aWxlIG9yIGRpcmVjdG9yeQovYmluL3NoOiAvcHJvYy9zZWxmL2ZkLzk6IE5vIHN1Y2ggZmls
ZSBvciBkaXJlY3RvcnkKCkJVRzoga2VybmVsIGJvb3QgaGFuZwpFbGFwc2VkIHRpbWU6IDUw
CnFlbXUtc3lzdGVtLXg4Nl82NCAtY3B1IGt2bTY0IC1lbmFibGUta3ZtIC1rZXJuZWwgL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS82ZTM2ZDQzMzYxMGEzZWJm
ZGVmMDAwZjFmYjI4M2UzZjIxOGE4YTMyL3ZtbGludXotMy4xNi4wLXJjNC0wMDE3Ni1nNmUz
NmQ0MyAtYXBwZW5kICdodW5nX3Rhc2tfcGFuaWM9MSBlYXJseXByaW50az10dHlTMCwxMTUy
MDAgZGVidWcgYXBpYz1kZWJ1ZyBzeXNycV9hbHdheXNfZW5hYmxlZCByY3VwZGF0ZS5yY3Vf
Y3B1X3N0YWxsX3RpbWVvdXQ9MTAwIHBhbmljPTEwIHNvZnRsb2NrdXBfcGFuaWM9MSBubWlf
d2F0Y2hkb2c9cGFuaWMgIHByb21wdF9yYW1kaXNrPTAgY29uc29sZT10dHlTMCwxMTUyMDAg
Y29uc29sZT10dHkwIHZnYT1ub3JtYWwgIHJvb3Q9L2Rldi9yYW0wIHJ3IGxpbms9L2tidWls
ZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1
L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDcxMDE4OjZlMzZkNDMzNjEwYTNlYmZk
ZWYwMDBmMWZiMjgzZTNmMjE4YThhMzI6YmlzZWN0LWxpbnV4OS8udm1saW51ei02ZTM2ZDQz
MzYxMGEzZWJmZGVmMDAwZjFmYjI4M2UzZjIxOGE4YTMyLTIwMTQwNzExMDM1MDI5LTEyLXZw
IGJyYW5jaD1saW51eC1kZXZlbC9kZXZlbC1ob3VybHktMjAxNDA3MTAxOCBCT09UX0lNQUdF
PS9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvNmUzNmQ0MzM2MTBh
M2ViZmRlZjAwMGYxZmIyODNlM2YyMThhOGEzMi92bWxpbnV6LTMuMTYuMC1yYzQtMDAxNzYt
ZzZlMzZkNDMgZHJiZC5taW5vcl9jb3VudD04JyAgLWluaXRyZCAva2VybmVsLXRlc3RzL2lu
aXRyZC9xdWFudGFsLWNvcmUteDg2XzY0LmNneiAtbSAzMjAgLXNtcCAyIC1uZXQgbmljLHZs
YW49MSxtb2RlbD1lMTAwMCAtbmV0IHVzZXIsdmxhbj0xIC1ib290IG9yZGVyPW5jIC1uby1y
ZWJvb3QgLXdhdGNoZG9nIGk2MzAwZXNiIC1ydGMgYmFzZT1sb2NhbHRpbWUgLWRyaXZlIGZp
bGU9L2ZzL0xBQkVMPUtWTS9kaXNrMC1xdWFudGFsLXZwLTE0LG1lZGlhPWRpc2ssaWY9dmly
dGlvIC1kcml2ZSBmaWxlPS9mcy9MQUJFTD1LVk0vZGlzazEtcXVhbnRhbC12cC0xNCxtZWRp
YT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMvTEFCRUw9S1ZNL2Rpc2syLXF1YW50
YWwtdnAtMTQsbWVkaWE9ZGlzayxpZj12aXJ0aW8gLWRyaXZlIGZpbGU9L2ZzL0xBQkVMPUtW
TS9kaXNrMy1xdWFudGFsLXZwLTE0LG1lZGlhPWRpc2ssaWY9dmlydGlvIC1kcml2ZSBmaWxl
PS9mcy9MQUJFTD1LVk0vZGlzazQtcXVhbnRhbC12cC0xNCxtZWRpYT1kaXNrLGlmPXZpcnRp
byAtZHJpdmUgZmlsZT0vZnMvTEFCRUw9S1ZNL2Rpc2s1LXF1YW50YWwtdnAtMTQsbWVkaWE9
ZGlzayxpZj12aXJ0aW8gLXBpZGZpbGUgL2Rldi9zaG0va2Jvb3QvcGlkLXF1YW50YWwtdnAt
MTQgLXNlcmlhbCBmaWxlOi9kZXYvc2htL2tib290L3NlcmlhbC1xdWFudGFsLXZwLTE0IC1k
YWVtb25pemUgLWRpc3BsYXkgbm9uZSAtbW9uaXRvciBudWxsIAova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzZlMzZkNDMzNjEwYTNlYmZkZWYwMDBmMWZiMjgz
ZTNmMjE4YThhMzIvZG1lc2cteW9jdG8tdnAtMzA6MjAxNDA3MTAxOTUxMjA6eDg2XzY0LXJh
bmRjb25maWctaHN4YTAtMDcxMTAyNTU6My4xNi4wLXJjNC0wMDE3Ni1nNmUzNmQ0MzoyCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvNmUzNmQ0MzM2MTBhM2Vi
ZmRlZjAwMGYxZmIyODNlM2YyMThhOGEzMi9kbWVzZy15b2N0by12cC05OjIwMTQwNzEwMTk1
MTAyOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjMuMTYuMC1yYzQtMDAxNzYt
ZzZlMzZkNDM6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzZl
MzZkNDMzNjEwYTNlYmZkZWYwMDBmMWZiMjgzZTNmMjE4YThhMzIvZG1lc2cteW9jdG8tdnAt
MjQ6MjAxNDA3MTAxOTUxMDg6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6My4x
Ni4wLXJjNC0wMDE3Ni1nNmUzNmQ0MzoyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDcxMTAyNTUvNmUzNmQ0MzM2MTBhM2ViZmRlZjAwMGYxZmIyODNlM2YyMThhOGEzMi9k
bWVzZy15b2N0by12cC00MToyMDE0MDcxMDE5NTExNDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MC0wNzExMDI1NTozLjE2LjAtcmM0LTAwMTc2LWc2ZTM2ZDQzOjIKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS82ZTM2ZDQzMzYxMGEzZWJmZGVmMDAwZjFmYjI4
M2UzZjIxOGE4YTMyL2RtZXNnLXlvY3RvLXZwLTM5OjIwMTQwNzEwMTk1MTEzOng4Nl82NC1y
YW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjMuMTYuMC1yYzQtMDAxNzYtZzZlMzZkNDM6Mgov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzZlMzZkNDMzNjEwYTNl
YmZkZWYwMDBmMWZiMjgzZTNmMjE4YThhMzIvZG1lc2cteW9jdG8tdnAtNTc6MjAxNDA3MTAx
OTUxMDg6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6My4xNi4wLXJjNC0wMDE3
Ni1nNmUzNmQ0MzoyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUv
NmUzNmQ0MzM2MTBhM2ViZmRlZjAwMGYxZmIyODNlM2YyMThhOGEzMi9kbWVzZy15b2N0by12
cC0yMToyMDE0MDcxMDE5NTEwNjp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NToz
LjE2LjAtcmM0LTAwMTc2LWc2ZTM2ZDQzOjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMC0wNzExMDI1NS82ZTM2ZDQzMzYxMGEzZWJmZGVmMDAwZjFmYjI4M2UzZjIxOGE4YTMy
L2RtZXNnLXlvY3RvLXZwLTYzOjIwMTQwNzEwMTk1MTA0Ong4Nl82NC1yYW5kY29uZmlnLWhz
eGEwLTA3MTEwMjU1OjMuMTYuMC1yYzQtMDAxNzYtZzZlMzZkNDM6Mgova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzZlMzZkNDMzNjEwYTNlYmZkZWYwMDBmMWZi
MjgzZTNmMjE4YThhMzIvZG1lc2cteW9jdG8tdnAtNDI6MjAxNDA3MTAxOTUxMDM6eDg2XzY0
LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6My4xNi4wLXJjNC0wMDE3Ni1nNmUzNmQ0Mzoy
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvNmUzNmQ0MzM2MTBh
M2ViZmRlZjAwMGYxZmIyODNlM2YyMThhOGEzMi9kbWVzZy15b2N0by12cC01NjoyMDE0MDcx
MDE5NTExMzp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTozLjE2LjAtcmM0LTAw
MTc2LWc2ZTM2ZDQzOjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1
NS82ZTM2ZDQzMzYxMGEzZWJmZGVmMDAwZjFmYjI4M2UzZjIxOGE4YTMyL2RtZXNnLXlvY3Rv
LXZwLTYxOjIwMTQwNzEwMTk1MTA0Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1
OjMuMTYuMC1yYzQtMDAxNzYtZzZlMzZkNDM6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWhzeGEwLTA3MTEwMjU1LzZlMzZkNDMzNjEwYTNlYmZkZWYwMDBmMWZiMjgzZTNmMjE4YThh
MzIvZG1lc2cteW9jdG8tdnAtNjQ6MjAxNDA3MTAxOTUxMTY6eDg2XzY0LXJhbmRjb25maWct
aHN4YTAtMDcxMTAyNTU6My4xNi4wLXJjNC0wMDE3Ni1nNmUzNmQ0MzoyCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvNmUzNmQ0MzM2MTBhM2ViZmRlZjAwMGYx
ZmIyODNlM2YyMThhOGEzMi9kbWVzZy15b2N0by12cC0zMjoyMDE0MDcxMDE5NTEyODp4ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTozLjE2LjAtcmM0LTAwMTc2LWc2ZTM2ZDQz
OjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS82ZTM2ZDQzMzYx
MGEzZWJmZGVmMDAwZjFmYjI4M2UzZjIxOGE4YTMyL2RtZXNnLXlvY3RvLXZwLTI4OjIwMTQw
NzEwMTk1MjMxOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjMuMTYuMC1yYzQt
MDAxNzYtZzZlMzZkNDM6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEw
MjU1LzZlMzZkNDMzNjEwYTNlYmZkZWYwMDBmMWZiMjgzZTNmMjE4YThhMzIvZG1lc2cteW9j
dG8tdnAtNDoyMDE0MDcxMDE5NTEwNTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1
NTozLjE2LjAtcmM0LTAwMTc2LWc2ZTM2ZDQzOjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMC0wNzExMDI1NS82ZTM2ZDQzMzYxMGEzZWJmZGVmMDAwZjFmYjI4M2UzZjIxOGE4
YTMyL2RtZXNnLXlvY3RvLXZwLTE2OjIwMTQwNzEwMTk1MTE1Ong4Nl82NC1yYW5kY29uZmln
LWhzeGEwLTA3MTEwMjU1OjMuMTYuMC1yYzQtMDAxNzYtZzZlMzZkNDM6Mgova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzZlMzZkNDMzNjEwYTNlYmZkZWYwMDBm
MWZiMjgzZTNmMjE4YThhMzIvZG1lc2cteW9jdG8tdnAtMTQ6MjAxNDA3MTAxOTUxMDI6eDg2
XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6My4xNi4wLXJjNC0wMDE3Ni1nNmUzNmQ0
MzoyCjQ6MTc6MTkgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzogMTc2
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpb
MTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMV0gTWVyZ2UgJ3VsZi5o
YW5zc29uLW1tYy9uZXh0JyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDcxMDE4CnJ1bm5pbmcg
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJp
c2VjdC9saW51eDkvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9r
dm0veDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvbGludXgtZGV2ZWw6ZGV2ZWwt
aG91cmx5LTIwMTQwNzEwMTg6MTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFj
YWMyMTpiaXNlY3QtbGludXg5CiBURVNUIEZBSUxVUkUKWyAgICA5LjAwMDEwNF0gaTJjIGky
Yy0wOiBkZXRlY3QgZmFpbDogYWRkcmVzcyBtYXRjaCwgMHgyZgpbICAgIDkuMDAwMTA0XSBp
MmMgaTJjLTA6IGRldGVjdCBmYWlsOiBhZGRyZXNzIG1hdGNoLCAweDJmCgpCVUc6IGtlcm5l
bCBib290IGhhbmcKRWxhcHNlZCB0aW1lOiAzNQpxZW11LXN5c3RlbS14ODZfNjQgLWNwdSBr
dm02NCAtZW5hYmxlLWt2bSAta2VybmVsIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS92
bWxpbnV6LTMuMTYuMC1yYzQtMDAxMTktZzE0NjA0YWIgLWFwcGVuZCAnaHVuZ190YXNrX3Bh
bmljPTEgZWFybHlwcmludGs9dHR5UzAsMTE1MjAwIGRlYnVnIGFwaWM9ZGVidWcgc3lzcnFf
YWx3YXlzX2VuYWJsZWQgcmN1cGRhdGUucmN1X2NwdV9zdGFsbF90aW1lb3V0PTEwMCBwYW5p
Yz0xMCBzb2Z0bG9ja3VwX3BhbmljPTEgbm1pX3dhdGNoZG9nPXBhbmljICBwcm9tcHRfcmFt
ZGlzaz0wIGNvbnNvbGU9dHR5UzAsMTE1MjAwIGNvbnNvbGU9dHR5MCB2Z2E9bm9ybWFsICBy
b290PS9kZXYvcmFtMCBydyBsaW5rPS9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHkt
MjAxNDA3MTAxODoxNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxOmJp
c2VjdC1saW51eDkvLnZtbGludXotMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWEx
YzFjYWMyMS0yMDE0MDcxMDIwNDY0OC0xNTktaXZiNDEgYnJhbmNoPWxpbnV4LWRldmVsL2Rl
dmVsLWhvdXJseS0yMDE0MDcxMDE4IEJPT1RfSU1BR0U9L2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFj
MWNhYzIxL3ZtbGludXotMy4xNi4wLXJjNC0wMDExOS1nMTQ2MDRhYiBkcmJkLm1pbm9yX2Nv
dW50PTgnICAtaW5pdHJkIC9rZXJuZWwtdGVzdHMvaW5pdHJkL3F1YW50YWwtY29yZS14ODZf
NjQuY2d6IC1tIDMyMCAtc21wIDIgLW5ldCBuaWMsdmxhbj0xLG1vZGVsPWUxMDAwIC1uZXQg
dXNlcix2bGFuPTEgLWJvb3Qgb3JkZXI9bmMgLW5vLXJlYm9vdCAtd2F0Y2hkb2cgaTYzMDBl
c2IgLXJ0YyBiYXNlPWxvY2FsdGltZSAtcGlkZmlsZSAvZGV2L3NobS9rYm9vdC9waWQtcXVh
bnRhbC1pdmI0MS0xMDEgLXNlcmlhbCBmaWxlOi9kZXYvc2htL2tib290L3NlcmlhbC1xdWFu
dGFsLWl2YjQxLTEwMSAtZGFlbW9uaXplIC1kaXNwbGF5IG5vbmUgLW1vbml0b3IgbnVsbCAK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJh
ODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTY1OjIwMTQw
NzEwMjA0ODM1Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJj
OTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTExNjoyMDE0MDcxMDIwNDkw
MTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlm
NWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS0xNDoyMDE0MDcxMDIwNDcyNDp4ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
aHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMy
MS9kbWVzZy15b2N0by1pdmI0MS01NToyMDE0MDcxMDIwNDg1Nzp4ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcx
MTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15
b2N0by1pdmI0MS0zMDoyMDE0MDcxMDIwNDgzMjp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0w
NzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2
MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0
MS04MToyMDE0MDcxMDIwNDc1OTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFi
YTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS01MDoyMDE0
MDcxMDIwNDgxMDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2Iy
Yzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by12cC0yNDoyMDE0MDcxMDIwNDgwMTp4
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTozLjE2LjAtcmM0LTAwMTE5LWcxNDYw
NGFiOjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFi
MzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTEx
NDoyMDE0MDcxMDIwNDcyNDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4
YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS02MToyMDE0MDcx
MDIwNDg0Nzp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2
MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS04OToyMDE0MDcxMDIwNDgwMDp4
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWEx
YzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS02OToyMDE0MDcxMDIwNDc1OTp4ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9k
bWVzZy15b2N0by1pdmI0MS0zODoyMDE0MDcxMDIwNDgyNTp4ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAy
NTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0
by1pdmI0MS05MDoyMDE0MDcxMDIwNDgwMDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzEx
MDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRh
YjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS0z
NToyMDE0MDcxMDIwNDgzMDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4
YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS00MjoyMDE0MDcx
MDIwNDgzNTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2
MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS0xOToyMDE0MDcxMDIwNDcyMzp4
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWEx
YzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS00ODoyMDE0MDcxMDIwNDgzMTp4ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9k
bWVzZy15b2N0by1pdmI0MS01NDoyMDE0MDcxMDIwNDg1Nzp4ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAy
NTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0
by1pdmI0MS04ODoyMDE0MDcxMDIwNDc0Mzp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzEx
MDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRh
YjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS01
NToyMDE0MDcxMDIwNDcyNDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4
YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS0zNjoyMDE0MDcx
MDIwNDgwMDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2
MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS0zMjoyMDE0MDcxMDIwNDg0Mjp4
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWEx
YzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS0xNzoyMDE0MDcxMDIwNDgzMTp4ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9k
bWVzZy15b2N0by1pdmI0MS01OjIwMTQwNzEwMjA0NzQyOng4Nl82NC1yYW5kY29uZmlnLWhz
eGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1
NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3Rv
LWl2YjQxLTk3OjIwMTQwNzEwMjA0ODQxOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEw
MjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFi
MzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTEy
MDoyMDE0MDcxMDIwNDg0NTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4
YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS0xMTQ6MjAxNDA3
MTAyMDQ4NTE6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzE0NjA0YWIzNmZhYmE4OGE4OWNiMmM5
NjExNTA5ZjVhMWMxY2FjMjEvZG1lc2cteW9jdG8tdnAtNTg6MjAxNDA3MTAyMDQ4MzI6eDg2
XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6My4xNi4wLXJjNC0wMDExOS1nMTQ2MDRh
YjozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2
ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS05Mjoy
MDE0MDcxMDIwNDgyNTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5
Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS01MzoyMDE0MDcxMDIw
NDg0Nzp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1
MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by12cC0yNToyMDE0MDcxMDIwNDgzMzp4ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTozLjE2LjAtcmM0LTAwMTE5LWcxNDYwNGFiOjMK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJh
ODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTMwOjIwMTQw
NzEwMjA0NzM5Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJj
OTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLXZwLTM5OjIwMTQwNzEwMjA0NzQ3Ong4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjMuMTYuMC1yYzQtMDAxMTktZzE0NjA0
YWI6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzE0NjA0YWIz
NmZhYmE4OGE4OWNiMmM5NjExNTA5ZjVhMWMxY2FjMjEvZG1lc2cteW9jdG8taXZiNDEtMTE0
OjIwMTQwNzEwMjA0ODEwOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhh
ODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLXZwLTE6MjAxNDA3MTAyMDQ4
MzQ6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6My4xNi4wLXJjNC0wMDExOS1n
MTQ2MDRhYjozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2
MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0
MS0xMTU6MjAxNDA3MTAyMDQ4MzA6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6
Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzE0NjA0YWIzNmZh
YmE4OGE4OWNiMmM5NjExNTA5ZjVhMWMxY2FjMjEvZG1lc2cteW9jdG8taXZiNDEtNTc6MjAx
NDA3MTAyMDQ4MTA6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzE0NjA0YWIzNmZhYmE4OGE4OWNi
MmM5NjExNTA5ZjVhMWMxY2FjMjEvZG1lc2cteW9jdG8tdnAtMTU6MjAxNDA3MTAyMDQ3NTU6
eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6My4xNi4wLXJjNC0wMDExOS1nMTQ2
MDRhYjozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRh
YjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by12cC0yMDoy
MDE0MDcxMDIwNDc1Njp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTozLjE2LjAt
cmM0LTAwMTE5LWcxNDYwNGFiOjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0w
NzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNn
LXlvY3RvLWl2YjQxLTExOjIwMTQwNzEwMjA0ODA4Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEw
LTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8x
NDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLXZw
LTQ6MjAxNDA3MTAyMDQ4MDY6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6My4x
Ni4wLXJjNC0wMDExOS1nMTQ2MDRhYjozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9k
bWVzZy15b2N0by1pdmI0MS02NDoyMDE0MDcxMDIwNDg0Njp4ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAy
NTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0
by1pdmI0MS0xMTg6MjAxNDA3MTAyMDQ4MTY6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcx
MTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzE0NjA0
YWIzNmZhYmE4OGE4OWNiMmM5NjExNTA5ZjVhMWMxY2FjMjEvZG1lc2cteW9jdG8taXZiNDEt
NDM6MjAxNDA3MTAyMDQ4MDY6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzE0NjA0YWIzNmZhYmE4
OGE4OWNiMmM5NjExNTA5ZjVhMWMxY2FjMjEvZG1lc2cteW9jdG8taXZiNDEtMTI1OjIwMTQw
NzEwMjA0ODM2Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJj
OTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTEyMzoyMDE0MDcxMDIwNDgy
Mzp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlm
NWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS0xMDU6MjAxNDA3MTAyMDQ4MDA6eDg2XzY0
LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWhzeGEwLTA3MTEwMjU1LzE0NjA0YWIzNmZhYmE4OGE4OWNiMmM5NjExNTA5ZjVhMWMxY2Fj
MjEvZG1lc2cteW9jdG8taXZiNDEtNzQ6MjAxNDA3MTAyMDQ4NTI6eDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3
MTEwMjU1LzE0NjA0YWIzNmZhYmE4OGE4OWNiMmM5NjExNTA5ZjVhMWMxY2FjMjEvZG1lc2ct
eW9jdG8taXZiNDEtNDk6MjAxNDA3MTAyMDQ4MDg6eDg2XzY0LXJhbmRjb25maWctaHN4YTAt
MDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzE0
NjA0YWIzNmZhYmE4OGE4OWNiMmM5NjExNTA5ZjVhMWMxY2FjMjEvZG1lc2cteW9jdG8taXZi
NDEtODA6MjAxNDA3MTAyMDQ4NDE6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6
Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzE0NjA0YWIzNmZh
YmE4OGE4OWNiMmM5NjExNTA5ZjVhMWMxY2FjMjEvZG1lc2cteW9jdG8taXZiNDEtNTg6MjAx
NDA3MTAyMDQ3NDM6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzE0NjA0YWIzNmZhYmE4OGE4OWNi
MmM5NjExNTA5ZjVhMWMxY2FjMjEvZG1lc2cteW9jdG8taXZiNDEtMjg6MjAxNDA3MTAyMDQ4
NDI6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzE0NjA0YWIzNmZhYmE4OGE4OWNiMmM5NjExNTA5
ZjVhMWMxY2FjMjEvZG1lc2cteW9jdG8taXZiNDEtMTE3OjIwMTQwNzEwMjA0NzU5Ong4Nl82
NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNh
YzIxL2RtZXNnLXlvY3RvLWl2YjQxLTY5OjIwMTQwNzEwMjA0ODQ2Ong4Nl82NC1yYW5kY29u
ZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0w
NzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNn
LXlvY3RvLWl2YjQxLTM0OjIwMTQwNzEwMjA0ODMwOng4Nl82NC1yYW5kY29uZmlnLWhzeGEw
LTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8x
NDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2
YjQxLTIxOjIwMTQwNzEwMjA0ODAwOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1
OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZm
YWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTcyOjIw
MTQwNzEwMjA0ODMxOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODlj
YjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTc0OjIwMTQwNzEwMjA0
ODEwOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUw
OWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTg6MjAxNDA3MTAyMDQ5MDE6eDg2XzY0
LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWhzeGEwLTA3MTEwMjU1LzE0NjA0YWIzNmZhYmE4OGE4OWNiMmM5NjExNTA5ZjVhMWMxY2Fj
MjEvZG1lc2cteW9jdG8taXZiNDEtNDQ6MjAxNDA3MTAyMDQ4MzE6eDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3
MTEwMjU1LzE0NjA0YWIzNmZhYmE4OGE4OWNiMmM5NjExNTA5ZjVhMWMxY2FjMjEvZG1lc2ct
eW9jdG8taXZiNDEtMTAzOjIwMTQwNzEwMjA0ODM2Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEw
LTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8x
NDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2
YjQxLTIyOjIwMTQwNzEwMjA0ODAwOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1
OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZm
YWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLXZwLTEyOjIwMTQw
NzEwMjA0NzQ4Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjMuMTYuMC1yYzQt
MDAxMTktZzE0NjA0YWI6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEw
MjU1LzE0NjA0YWIzNmZhYmE4OGE4OWNiMmM5NjExNTA5ZjVhMWMxY2FjMjEvZG1lc2cteW9j
dG8taXZiNDEtMTA0OjIwMTQwNzEwMjA0ODQyOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3
MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYw
NGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQx
LTExOjIwMTQwNzEwMjA0NzIyOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJh
ODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTU4OjIwMTQw
NzEwMjA0ODMwOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJj
OTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTI3OjIwMTQwNzEwMjA0ODE4
Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1
YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTUxOjIwMTQwNzEwMjA0ODM1Ong4Nl82NC1y
YW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIx
L2RtZXNnLXlvY3RvLXZwLTQxOjIwMTQwNzEwMjA0ODA2Ong4Nl82NC1yYW5kY29uZmlnLWhz
eGEwLTA3MTEwMjU1OjMuMTYuMC1yYzQtMDAxMTktZzE0NjA0YWI6Mwova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzE0NjA0YWIzNmZhYmE4OGE4OWNiMmM5NjEx
NTA5ZjVhMWMxY2FjMjEvZG1lc2cteW9jdG8taXZiNDEtMzc6MjAxNDA3MTAyMDQ4MzE6eDg2
XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWhzeGEwLTA3MTEwMjU1LzE0NjA0YWIzNmZhYmE4OGE4OWNiMmM5NjExNTA5ZjVhMWMx
Y2FjMjEvZG1lc2cteW9jdG8taXZiNDEtMTI0OjIwMTQwNzEwMjA0ODU5Ong4Nl82NC1yYW5k
Y29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2Rt
ZXNnLXlvY3RvLWl2YjQxLTk2OjIwMTQwNzEwMjA0ODE3Ong4Nl82NC1yYW5kY29uZmlnLWhz
eGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1
NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3Rv
LWl2YjQxLTMxOjIwMTQwNzEwMjA0ODUwOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEw
MjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFi
MzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTc6
MjAxNDA3MTAyMDQ4NDY6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzE0NjA0YWIzNmZhYmE4OGE4
OWNiMmM5NjExNTA5ZjVhMWMxY2FjMjEvZG1lc2cteW9jdG8tdnAtMTk6MjAxNDA3MTAyMDQ3
NTk6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6My4xNi4wLXJjNC0wMDExOS1n
MTQ2MDRhYjozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2
MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0
MS04MToyMDE0MDcxMDIwNDg1Njp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFi
YTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS05MToyMDE0
MDcxMDIwNDgwMDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2Iy
Yzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS0xMTM6MjAxNDA3MTAyMDQ4
NDE6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzE0NjA0YWIzNmZhYmE4OGE4OWNiMmM5NjExNTA5
ZjVhMWMxY2FjMjEvZG1lc2cteW9jdG8taXZiNDEtMjM6MjAxNDA3MTAyMDQ3MjQ6eDg2XzY0
LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWhzeGEwLTA3MTEwMjU1LzE0NjA0YWIzNmZhYmE4OGE4OWNiMmM5NjExNTA5ZjVhMWMxY2Fj
MjEvZG1lc2cteW9jdG8tdnAtMjoyMDE0MDcxMDIwNDgzMjp4ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMC0wNzExMDI1NTozLjE2LjAtcmM0LTAwMTE5LWcxNDYwNGFiOjMKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYx
MTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTYzOjIwMTQwNzEwMjA0ODEwOng4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFj
MWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTMzOjIwMTQwNzEwMjA0ODU5Ong4Nl82NC1yYW5k
Y29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2Rt
ZXNnLXlvY3RvLWl2YjQxLTE0OjIwMTQwNzEwMjA0ODExOng4Nl82NC1yYW5kY29uZmlnLWhz
eGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1
NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3Rv
LWl2YjQxLTE2OjIwMTQwNzEwMjA0ODAwOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEw
MjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFi
MzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTg2
OjIwMTQwNzEwMjA0ODMxOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhh
ODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTcxOjIwMTQwNzEw
MjA0ODMwOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYx
MTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTgzOjIwMTQwNzEwMjA0ODQyOng4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFj
MWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTEyNjoyMDE0MDcxMDIwNDgzNzp4ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9k
bWVzZy15b2N0by1pdmI0MS0xMjQ6MjAxNDA3MTAyMDQ4MTc6eDg2XzY0LXJhbmRjb25maWct
aHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEw
MjU1LzE0NjA0YWIzNmZhYmE4OGE4OWNiMmM5NjExNTA5ZjVhMWMxY2FjMjEvZG1lc2cteW9j
dG8taXZiNDEtNzY6MjAxNDA3MTAyMDQ3NTk6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcx
MTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzE0NjA0
YWIzNmZhYmE4OGE4OWNiMmM5NjExNTA5ZjVhMWMxY2FjMjEvZG1lc2cteW9jdG8tdnAtMTY6
MjAxNDA3MTAyMDQ3NTk6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6My4xNi4w
LXJjNC0wMDExOS1nMTQ2MDRhYjozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAt
MDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVz
Zy15b2N0by12cC0xODoyMDE0MDcxMDIwNDc1OTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0w
NzExMDI1NTozLjE2LjAtcmM0LTAwMTE5LWcxNDYwNGFiOjMKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1
YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTk4OjIwMTQwNzEwMjA0ODE3Ong4Nl82NC1y
YW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIx
L2RtZXNnLXlvY3RvLWl2YjQxLTQ3OjIwMTQwNzEwMjA0ODQwOng4Nl82NC1yYW5kY29uZmln
LWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzEx
MDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlv
Y3RvLWl2YjQxLTM5OjIwMTQwNzEwMjA0ODMxOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3
MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYw
NGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLXZwLTQ0
OjIwMTQwNzEwMjA0ODAyOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjMuMTYu
MC1yYzQtMDAxMTktZzE0NjA0YWI6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEw
LTA3MTEwMjU1LzE0NjA0YWIzNmZhYmE4OGE4OWNiMmM5NjExNTA5ZjVhMWMxY2FjMjEvZG1l
c2cteW9jdG8taXZiNDEtNjc6MjAxNDA3MTAyMDQ3NDM6eDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1
LzE0NjA0YWIzNmZhYmE4OGE4OWNiMmM5NjExNTA5ZjVhMWMxY2FjMjEvZG1lc2cteW9jdG8t
aXZiNDEtNzY6MjAxNDA3MTAyMDQ4NDU6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAy
NTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzE0NjA0YWIz
NmZhYmE4OGE4OWNiMmM5NjExNTA5ZjVhMWMxY2FjMjEvZG1lc2cteW9jdG8taXZiNDEtMTIx
OjIwMTQwNzEwMjA0ODAwOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhh
ODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTY2OjIwMTQwNzEw
MjA0ODAwOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYx
MTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTExOjIwMTQwNzEwMjA0ODQ5Ong4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFj
MWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTkzOjIwMTQwNzEwMjA0ODQyOng4Nl82NC1yYW5k
Y29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2Rt
ZXNnLXlvY3RvLWl2YjQxLTIzOjIwMTQwNzEwMjA0ODExOng4Nl82NC1yYW5kY29uZmlnLWhz
eGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1
NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3Rv
LWl2YjQxLTE4OjIwMTQwNzEwMjA0ODQyOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEw
MjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFi
MzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTE1
OjIwMTQwNzEwMjA0ODI0Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhh
ODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTg6MjAxNDA3MTAy
MDQ4MTU6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzE0NjA0YWIzNmZhYmE4OGE4OWNiMmM5NjEx
NTA5ZjVhMWMxY2FjMjEvZG1lc2cteW9jdG8taXZiNDEtMTE1OjIwMTQwNzEwMjA0NzQzOng4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFj
MWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTg0OjIwMTQwNzEwMjA0ODMxOng4Nl82NC1yYW5k
Y29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2Rt
ZXNnLXlvY3RvLWl2YjQxLTgyOjIwMTQwNzEwMjA0ODUxOng4Nl82NC1yYW5kY29uZmlnLWhz
eGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1
NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3Rv
LWl2YjQxLTExNzoyMDE0MDcxMDIwNDg1Njp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzEx
MDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRh
YjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS03
ODoyMDE0MDcxMDIwNDgxODp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4
YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS01OjIwMTQwNzEw
MjA0ODI4Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYx
MTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTQzOjIwMTQwNzEwMjA0ODUzOng4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFj
MWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTExODoyMDE0MDcxMDIwNDkwODp4ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9k
bWVzZy15b2N0by12cC01OToyMDE0MDcxMDIwNDgwMjp4ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MC0wNzExMDI1NTozLjE2LjAtcmM0LTAwMTE5LWcxNDYwNGFiOjMKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUw
OWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLXZwLTc6MjAxNDA3MTAyMDQ4MzI6eDg2XzY0LXJh
bmRjb25maWctaHN4YTAtMDcxMTAyNTU6My4xNi4wLXJjNC0wMDExOS1nMTQ2MDRhYjozCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4
YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS05OToyMDE0MDcx
MDIwNDgyODp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2
MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS01NzoyMDE0MDcxMDIwNDg1MTp4
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWEx
YzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS01MDoyMDE0MDcxMDIwNDcyNDp4ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9k
bWVzZy15b2N0by1pdmI0MS04NToyMDE0MDcxMDIwNDczODp4ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAy
NTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0
by1pdmI0MS04ODoyMDE0MDcxMDIwNDgzMTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzEx
MDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRh
YjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS03
NzoyMDE0MDcxMDIwNDgxMjp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4
YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by12cC0yODoyMDE0MDcxMDIw
NDc1Nzp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTozLjE2LjAtcmM0LTAwMTE5
LWcxNDYwNGFiOjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8x
NDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2
YjQxLTUzOjIwMTQwNzEwMjA0NzU5Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1
OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZm
YWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTY3OjIw
MTQwNzEwMjA0ODMxOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODlj
YjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTQ1OjIwMTQwNzEwMjA0
ODQ5Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xNDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUw
OWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2YjQxLTc6MjAxNDA3MTAyMDQ3NTg6eDg2XzY0
LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWhzeGEwLTA3MTEwMjU1LzE0NjA0YWIzNmZhYmE4OGE4OWNiMmM5NjExNTA5ZjVhMWMxY2Fj
MjEvZG1lc2cteW9jdG8taXZiNDEtNzM6MjAxNDA3MTAyMDQ4MzQ6eDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3
MTEwMjU1LzE0NjA0YWIzNmZhYmE4OGE4OWNiMmM5NjExNTA5ZjVhMWMxY2FjMjEvZG1lc2ct
eW9jdG8taXZiNDEtMTI3OjIwMTQwNzEwMjA0ODExOng4Nl82NC1yYW5kY29uZmlnLWhzeGEw
LTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8x
NDYwNGFiMzZmYWJhODhhODljYjJjOTYxMTUwOWY1YTFjMWNhYzIxL2RtZXNnLXlvY3RvLWl2
YjQxLTExMDoyMDE0MDcxMDIwNDgyOTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1
NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2
ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS04Mjoy
MDE0MDcxMDIwNDgwODp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5
Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS0zNzoyMDE0MDcxMDIw
NDc0NDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1
MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by1pdmI0MS0yNDoyMDE0MDcxMDIwNDgyOTp4ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFj
YWMyMS9kbWVzZy15b2N0by1pdmI0MS04NToyMDE0MDcxMDIwNDgzMTp4ODZfNjQtcmFuZGNv
bmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAt
MDcxMTAyNTUvMTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVz
Zy15b2N0by1pdmI0MS01NToyMDE0MDcxMDIwNDgxMTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUv
MTQ2MDRhYjM2ZmFiYTg4YTg5Y2IyYzk2MTE1MDlmNWExYzFjYWMyMS9kbWVzZy15b2N0by1p
dmI0MS0xOToyMDE0MDcxMDIwNDgyNDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1
NTo6CjEwODoxMzc6MjIyIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6
IDExOSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNyBzdGVw
cykKWzkxNDFhNjhkNzFhYTE5M2Y3OGFhYzUzMDZmYzcyOGZiYThmYjU5ZjRdIE1lcmdlICdt
NjhrL2Zvci1saW51cycgaW50byBkZXZlbC1ob3VybHktMjAxNDA3MTAxOApydW5uaW5nIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNl
Y3QvbGludXg5L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3Zt
L3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1L2xpbnV4LWRldmVsOmRldmVsLWhv
dXJseS0yMDE0MDcxMDE4OjkxNDFhNjhkNzFhYTE5M2Y3OGFhYzUzMDZmYzcyOGZiYThmYjU5
ZjQ6YmlzZWN0LWxpbnV4OQoKMjAxNC0wNy0xMC0yMDo1NDoyNSA5MTQxYTY4ZDcxYWExOTNm
NzhhYWM1MzA2ZmM3MjhmYmE4ZmI1OWY0IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0
byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3
MTEwMjU1LTkxNDFhNjhkNzFhYTE5M2Y3OGFhYzUzMDZmYzcyOGZiYThmYjU5ZjQKQ2hlY2sg
Zm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1
LzkxNDFhNjhkNzFhYTE5M2Y3OGFhYzUzMDZmYzcyOGZiYThmYjU5ZjQKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29u
ZmlnLWhzeGEwLTA3MTEwMjU1LTkxNDFhNjhkNzFhYTE5M2Y3OGFhYzUzMDZmYzcyOGZiYThm
YjU5ZjQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL2pha2V0b3duLWNvbnN1bWVyL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1
LTkxNDFhNjhkNzFhYTE5M2Y3OGFhYzUzMDZmYzcyOGZiYThmYjU5ZjQKa2VybmVsOiAva2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzkxNDFhNjhkNzFhYTE5M2Y3
OGFhYzUzMDZmYzcyOGZiYThmYjU5ZjQvdm1saW51ei0zLjE2LjAtcmM0LTAwMDA3LWc5MTQx
YTY4CgoyMDE0LTA3LTEwLTIxOjEyOjI1IGRldGVjdGluZyBib290IHN0YXRlIC4JMQkyCTUu
Li4JNgk3CTMyLi4uLgk1MQk1Mgk1NS4JNjYJNjgJNzIJNzMJODAJODEJODQJOTkJMTAwCTEx
NgkxMTkJMTIyCTEzNAkxMzUJMTQ3CTE0OS4JMTU2LgkxNjgJMTY5LgkxODMJMTg1CTE5Ngkx
OTkuCTIxMgkyMTMJMjE0CTIyNS4JMjI3CTIyOQkyNDEJMjQzCTI0NAkyNDcJMjU4CTI2MQky
NjIuCTI2MwkyNzQuLi4JMjkwCTI5NQkyOTYuCTI5NwkzMTIJMzE0CTMxNwkzMjEJMzI3CTMz
MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDExMiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgNyBzdGVwcykKWzEzOTg3ZDE3NDY5NTFiNzI3MTQ2ZmVmMTg3NDA2
YjdiZTAwYTNmZDBdIE1lcmdlICdsdXRvL3g4Ni92c3lzY2FsbCcgaW50byBkZXZlbC1ob3Vy
bHktMjAxNDA3MTAxOApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290
LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg5L29iai1iaXNlY3QKbHMgLWEgL2ti
dWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEw
MjU1L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDcxMDE4OjEzOTg3ZDE3NDY5NTFi
NzI3MTQ2ZmVmMTg3NDA2YjdiZTAwYTNmZDA6YmlzZWN0LWxpbnV4OQoKMjAxNC0wNy0xMC0y
MTo1MDoyNSAxMzk4N2QxNzQ2OTUxYjcyNzE0NmZlZjE4NzQwNmI3YmUwMGEzZmQwIGNvbXBp
bGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LTEzOTg3ZDE3NDY5NTFiNzI3MTQ2ZmVm
MTg3NDA2YjdiZTAwYTNmZDAKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzEzOTg3ZDE3NDY5NTFiNzI3MTQ2ZmVmMTg3NDA2
YjdiZTAwYTNmZDAKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LTEzOTg3ZDE3NDY5
NTFiNzI3MTQ2ZmVmMTg3NDA2YjdiZTAwYTNmZDAKa2VybmVsOiAva2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzEzOTg3ZDE3NDY5NTFiNzI3MTQ2ZmVmMTg3NDA2
YjdiZTAwYTNmZDAvdm1saW51ei0zLjE2LjAtcmM0LTAwMDE5LWcxMzk4N2QxCgoyMDE0LTA3
LTEwLTIxOjUyOjI1IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4gVEVTVCBGQUlMVVJFCm1vdW50OiBjYW4ndCByZWFkICcv
cHJvYy9tb3VudHMnOiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5ClsgICAzMi45OTcyMzVd
IGluaXRbMV06IHNlZ2ZhdWx0IGF0IGZmZmZmZmZmZmY2MDA0MDAgaXAgZmZmZmZmZmZmZjYw
MDQwMCBzcCAwMDAwN2ZmZjU0MDNkZDQ4IGVycm9yIDE1ClsgICAzMi45OTgwNTVdIGluaXRb
MV06IHNlZ2ZhdWx0IGF0IGZmZmZmZmZmZmY2MDA0MDAgaXAgZmZmZmZmZmZmZjYwMDQwMCBz
cCAwMDAwN2ZmZjU0MDNkMzc4IGVycm9yIDE1ClsgICAzMi45OTg5NTNdIEtlcm5lbCBwYW5p
YyAtIG5vdCBzeW5jaW5nOiBBdHRlbXB0ZWQgdG8ga2lsbCBpbml0ISBleGl0Y29kZT0weDAw
MDAwMDBiClsgICAzMi45OTg5NTNdIApbICAgMzIuOTk5NzU0XSBDUFU6IDAgUElEOiAxIENv
bW06IGluaXQgTm90IHRhaW50ZWQgMy4xNi4wLXJjNC0wMDAxOS1nMTM5ODdkMSAjMQpbICAg
MzMuMDAwMDEyXSAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDAwMDMzY2MwIGZmZmZmZmZm
ODFmZjRlOGYgZmZmZjg4MDAwMDAzM2QzOApbICAgMzMuMDAwMDEyXSAgZmZmZmZmZmY4MWZm
MTk3MiBmZmZmODgwMDAwMDAwMDEwIGZmZmY4ODAwMDAwMzNkNDggZmZmZjg4MDAwMDAzM2Nl
OApbICAgMzMuMDAwMDEyXSAgZmZmZmZmZmY4MmM0NDBjMCAwMDAwMDAwMDAwMDAwMDBiIDhj
NjMxOGM2MzE4YzYzMjAgMDAwMDAwMDdhZWUzZGNmMApbICAgMzMuMDAwMDEyXSBDYWxsIFRy
YWNlOgpbICAgMzMuMDAwMDEyXSAgWzxmZmZmZmZmZjgxZmY0ZThmPl0gZHVtcF9zdGFjaysw
eDE5LzB4MWIKWyAgIDMzLjAwMDAxMl0gIFs8ZmZmZmZmZmY4MWZmMTk3Mj5dIHBhbmljKzB4
Y2IvMHgxZmIKWyAgIDMzLjAwMDAxMl0gIFs8ZmZmZmZmZmY4MTA5M2IyZj5dIGRvX2V4aXQr
MHgzZGQvMHg4MGYKWyAgIDMzLjAwMDAxMl0gIFs8ZmZmZmZmZmY4MTBiMDcyYz5dID8gbG9j
YWxfY2xvY2srMHgxNC8weDFkClsgICAzMy4wMDAwMTJdICBbPGZmZmZmZmZmODEwOTQwMDI+
XSBkb19ncm91cF9leGl0KzB4NzUvMHhiNApbICAgMzMuMDAwMDEyXSAgWzxmZmZmZmZmZjgx
MDljN2Y2Pl0gZ2V0X3NpZ25hbF90b19kZWxpdmVyKzB4NDhhLzB4NGFhClsgICAzMy4wMDAw
MTJdICBbPGZmZmZmZmZmODEwMDIzMWE+XSBkb19zaWduYWwrMHg0My8weDViYQpbICAgMzMu
MDAwMDEyXSAgWzxmZmZmZmZmZjgxMGI0Yjg4Pl0gPyBsb2NrX3JlbGVhc2VfaG9sZHRpbWUr
MHg2Yy8weDc3ClsgICAzMy4wMDAwMTJdICBbPGZmZmZmZmZmODEwYjgzYzQ+XSA/IGxvY2tf
cmVsZWFzZV9ub25fbmVzdGVkKzB4ZDAvMHgyMWUKWyAgIDMzLjAwMDAxMl0gIFs8ZmZmZmZm
ZmY4MTBiMDY1NT5dID8gc2NoZWRfY2xvY2tfY3B1KzB4NGUvMHg2MgpbICAgMzMuMDAwMDEy
XSAgWzxmZmZmZmZmZjgxMGZkNDMyPl0gPyBtaWdodF9mYXVsdCsweDRmLzB4OWMKWyAgIDMz
LjAwMDAxMl0gIFs8ZmZmZmZmZmY4MTBiNjE3Mj5dID8gdHJhY2VfaGFyZGlycXNfb2ZmX2Nh
bGxlcisweDM2LzB4YTUKWyAgIDMzLjAwMDAxMl0gIFs8ZmZmZmZmZmY4MjAwNDhkOD5dID8g
cmV0aW50X3NpZ25hbCsweDExLzB4OTkKWyAgIDMzLjAwMDAxMl0gIFs8ZmZmZmZmZmY4MTAw
MjhiNT5dIGRvX25vdGlmeV9yZXN1bWUrMHgyNC8weDUzClsgICAzMy4wMDAwMTJdICBbPGZm
ZmZmZmZmODIwMDQ5MTQ+XSByZXRpbnRfc2lnbmFsKzB4NGQvMHg5OQpbICAgMzMuMDAwMDEy
XSBLZXJuZWwgT2Zmc2V0OiAweDAgZnJvbSAweGZmZmZmZmZmODEwMDAwMDAgKHJlbG9jYXRp
b24gcmFuZ2U6IDB4ZmZmZmZmZmY4MDAwMDAwMC0weGZmZmZmZmZmOWZmZmZmZmYpClsgICAz
My4wMDAwMTJdIGRybV9rbXNfaGVscGVyOiBwYW5pYyBvY2N1cnJlZCwgc3dpdGNoaW5nIGJh
Y2sgdG8gdGV4dCBjb25zb2xlClsgICAzMy4wMDAwMTJdIApbICAgMzMuMDAwMDEyXSA9PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09ClsgICAzMy4wMDAwMTJdIFsgSU5GTzogc3Vz
cGljaW91cyBSQ1UgdXNhZ2UuIF0KWyAgIDMzLjAwMDAxMl0gMy4xNi4wLXJjNC0wMDAxOS1n
MTM5ODdkMSAjMSBOb3QgdGFpbnRlZApbICAgMzMuMDAwMDEyXSAtLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tClsgICAzMy4wMDAwMTJdIC9rYnVpbGQvc3JjL2NvbnN1bWVyL2lu
Y2x1ZGUvbGludXgvcmN1cGRhdGUuaDo1MzkgSWxsZWdhbCBjb250ZXh0IHN3aXRjaCBpbiBS
Q1UgcmVhZC1zaWRlIGNyaXRpY2FsIHNlY3Rpb24hClsgICAzMy4wMDAwMTJdIApbICAgMzMu
MDAwMDEyXSBvdGhlciBpbmZvIHRoYXQgbWlnaHQgaGVscCB1cyBkZWJ1ZyB0aGlzOgpbICAg
MzMuMDAwMDEyXSAKWyAgIDMzLjAwMDAxMl0gClsgICAzMy4wMDAwMTJdIHJjdV9zY2hlZHVs
ZXJfYWN0aXZlID0gMSwgZGVidWdfbG9ja3MgPSAwClsgICAzMy4wMDAwMTJdIDMgbG9ja3Mg
aGVsZCBieSBpbml0LzE6ClsgICAzMy4wMDAwMTJdICAjMDogIChwYW5pY19sb2NrKXsuLi4u
Ky59LCBhdDogWzxmZmZmZmZmZjgxZmYxOGVhPl0gcGFuaWMrMHg0My8weDFmYgpbICAgMzMu
MDAwMDEyXSAgIzE6ICAocmN1X3JlYWRfbG9jayl7Li4uLi4ufSwgYXQ6IFs8ZmZmZmZmZmY4
MTBhYjg4OD5dIHJjdV9sb2NrX2FjcXVpcmUrMHgwLzB4MjMKWyAgIDMzLjAwMDAxMl0gICMy
OiAgKCZkZXYtPm1vZGVfY29uZmlnLm11dGV4KXsrLisuKy59LCBhdDogWzxmZmZmZmZmZjgx
NGE3ODQ3Pl0gZHJtX2ZiX2hlbHBlcl9wYW5pYysweDVkLzB4YWIKWyAgIDMzLjAwMDAxMl0g
ClsgICAzMy4wMDAwMTJdIHN0YWNrIGJhY2t0cmFjZToKWyAgIDMzLjAwMDAxMl0gQ1BVOiAw
IFBJRDogMSBDb21tOiBpbml0IE5vdCB0YWludGVkIDMuMTYuMC1yYzQtMDAwMTktZzEzOTg3
ZDEgIzEKWyAgIDMzLjAwMDAxMl0gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAwMDAzMzlk
MCBmZmZmZmZmZjgxZmY0ZThmIGZmZmY4ODAwMDAwMzNhMDAKWyAgIDMzLjAwMDAxMl0gIGZm
ZmZmZmZmODEwYjg4MzMgZmZmZmZmZmY4MjgzNjM0OCAwMDAwMDAwMDAwMDAwMjRhIDAwMDAw
MDAwMDAwMDAwMDAKWyAgIDMzLjAwMDAxMl0gIGZmZmY4ODAwMTAxNDQwMDggZmZmZjg4MDAw
MDAzM2ExMCBmZmZmZmZmZjgxMGFkY2YyIGZmZmY4ODAwMDAwMzNhMzgKWyAgIDMzLjAwMDAx
Ml0gQ2FsbCBUcmFjZToKWyAgIDMzLjAwMDAxMl0gIFs8ZmZmZmZmZmY4MWZmNGU4Zj5dIGR1
bXBfc3RhY2srMHgxOS8weDFiClsgICAzMy4wMDAwMTJdICBbPGZmZmZmZmZmODEwYjg4MzM+
XSBsb2NrZGVwX3JjdV9zdXNwaWNpb3VzKzB4ZjYvMHhmZgpbICAgMzMuMDAwMDEyXSAgWzxm
ZmZmZmZmZjgxMGFkY2YyPl0gcmN1X3ByZWVtcHRfc2xlZXBfY2hlY2srMHg0NS8weDQ3Clsg
ICAzMy4wMDAwMTJdICBbPGZmZmZmZmZmODEwYWZlZWU+XSBfX21pZ2h0X3NsZWVwKzB4MTcv
MHgxOWEKWyAgIDMzLjAwMDAxMl0gIFs8ZmZmZmZmZmY4MjAwMDdjZT5dIG11dGV4X2xvY2tf
bmVzdGVkKzB4MmUvMHgzNjkKWyAgIDMzLjAwMDAxMl0gIFs8ZmZmZmZmZmY4MTBiODY2Nj5d
ID8gbG9ja19yZWxlYXNlKzB4MTU0LzB4MTg1ClsgICAzMy4wMDAwMTJdICBbPGZmZmZmZmZm
ODEwYjYxZWU+XSA/IHRyYWNlX2hhcmRpcnFzX29mZisweGQvMHhmClsgICAzMy4wMDAwMTJd
ICBbPGZmZmZmZmZmODE0YjRlNDM+XSBfb2JqZWN0X2ZpbmQrMHgyNS8weDZjClsgICAzMy4w
MDAwMTJdICBbPGZmZmZmZmZmODE0YjU1ZjM+XSBkcm1fbW9kZV9vYmplY3RfZmluZCsweDM4
LzB4NTMKWyAgIDMzLjAwMDAxMl0gIFs8ZmZmZmZmZmY4MTU5NDNlMD5dIGNpcnJ1c19jb25u
ZWN0b3JfYmVzdF9lbmNvZGVyKzB4MjEvMHgyZgpbICAgMzMuMDAwMDEyXSAgWzxmZmZmZmZm
ZjgxNGE1NmYyPl0gZHJtX2NydGNfaGVscGVyX3NldF9jb25maWcrMHgzOGMvMHg4M2MKWyAg
IDMzLjAwMDAxMl0gIFs8ZmZmZmZmZmY4MTRiNmZiND5dIGRybV9tb2RlX3NldF9jb25maWdf
aW50ZXJuYWwrMHg1My8weGNhClsgICAzMy4wMDAwMTJdICBbPGZmZmZmZmZmODE0YTc2OGY+
XSByZXN0b3JlX2ZiZGV2X21vZGUrMHg5MS8weGFkClsgICAzMy4wMDAwMTJdICBbPGZmZmZm
ZmZmODE0YTc4NTM+XSBkcm1fZmJfaGVscGVyX3BhbmljKzB4NjkvMHhhYgpbICAgMzMuMDAw
MDEyXSAgWzxmZmZmZmZmZjgxMGFiOTNiPl0gbm90aWZpZXJfY2FsbF9jaGFpbisweDYxLzB4
OGIKWyAgIDMzLjAwMDAxMl0gIFs8ZmZmZmZmZmY4MTBhYmE1ZT5dIF9fYXRvbWljX25vdGlm
aWVyX2NhbGxfY2hhaW4rMHg3ZS8weGU2ClsgICAzMy4wMDAwMTJdICBbPGZmZmZmZmZmODEw
YWJhZDU+XSBhdG9taWNfbm90aWZpZXJfY2FsbF9jaGFpbisweGYvMHgxMQpbICAgMzMuMDAw
MDEyXSAgWzxmZmZmZmZmZjgxZmYxOTk3Pl0gcGFuaWMrMHhmMC8weDFmYgpbICAgMzMuMDAw
MDEyXSAgWzxmZmZmZmZmZjgxMDkzYjJmPl0gZG9fZXhpdCsweDNkZC8weDgwZgpbICAgMzMu
MDAwMDEyXSAgWzxmZmZmZmZmZjgxMGIwNzJjPl0gPyBsb2NhbF9jbG9jaysweDE0LzB4MWQK
WyAgIDMzLjAwMDAxMl0gIFs8ZmZmZmZmZmY4MTA5NDAwMj5dIGRvX2dyb3VwX2V4aXQrMHg3
NS8weGI0ClsgICAzMy4wMDAwMTJdICBbPGZmZmZmZmZmODEwOWM3ZjY+XSBnZXRfc2lnbmFs
X3RvX2RlbGl2ZXIrMHg0OGEvMHg0YWEKWyAgIDMzLjAwMDAxMl0gIFs8ZmZmZmZmZmY4MTAw
MjMxYT5dIGRvX3NpZ25hbCsweDQzLzB4NWJhClsgICAzMy4wMDAwMTJdICBbPGZmZmZmZmZm
ODEwYjRiODg+XSA/IGxvY2tfcmVsZWFzZV9ob2xkdGltZSsweDZjLzB4NzcKWyAgIDMzLjAw
MDAxMl0gIFs8ZmZmZmZmZmY4MTBiODNjND5dID8gbG9ja19yZWxlYXNlX25vbl9uZXN0ZWQr
MHhkMC8weDIxZQpbICAgMzMuMDAwMDEyXSAgWzxmZmZmZmZmZjgxMGIwNjU1Pl0gPyBzY2hl
ZF9jbG9ja19jcHUrMHg0ZS8weDYyClsgICAzMy4wMDAwMTJdICBbPGZmZmZmZmZmODEwZmQ0
MzI+XSA/IG1pZ2h0X2ZhdWx0KzB4NGYvMHg5YwpbICAgMzMuMDAwMDEyXSAgWzxmZmZmZmZm
ZjgxMGI2MTcyPl0gPyB0cmFjZV9oYXJkaXJxc19vZmZfY2FsbGVyKzB4MzYvMHhhNQpbICAg
MzMuMDAwMDEyXSAgWzxmZmZmZmZmZjgyMDA0OGQ4Pl0gPyByZXRpbnRfc2lnbmFsKzB4MTEv
MHg5OQpbICAgMzMuMDAwMDEyXSAgWzxmZmZmZmZmZjgxMDAyOGI1Pl0gZG9fbm90aWZ5X3Jl
c3VtZSsweDI0LzB4NTMKWyAgIDMzLjAwMDAxMl0gIFs8ZmZmZmZmZmY4MjAwNDkxND5dIHJl
dGludF9zaWduYWwrMHg0ZC8weDk5ClsgICAzMy4wMDAwMTJdIFJlYm9vdGluZyBpbiAxMCBz
ZWNvbmRzLi4KRWxhcHNlZCB0aW1lOiAzNQpxZW11LXN5c3RlbS14ODZfNjQgLWNwdSBrdm02
NCAtZW5hYmxlLWt2bSAta2VybmVsIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAt
MDcxMTAyNTUvMTM5ODdkMTc0Njk1MWI3MjcxNDZmZWYxODc0MDZiN2JlMDBhM2ZkMC92bWxp
bnV6LTMuMTYuMC1yYzQtMDAwMTktZzEzOTg3ZDEgLWFwcGVuZCAnaHVuZ190YXNrX3Bhbmlj
PTEgZWFybHlwcmludGs9dHR5UzAsMTE1MjAwIGRlYnVnIGFwaWM9ZGVidWcgc3lzcnFfYWx3
YXlzX2VuYWJsZWQgcmN1cGRhdGUucmN1X2NwdV9zdGFsbF90aW1lb3V0PTEwMCBwYW5pYz0x
MCBzb2Z0bG9ja3VwX3BhbmljPTEgbm1pX3dhdGNoZG9nPXBhbmljICBwcm9tcHRfcmFtZGlz
az0wIGNvbnNvbGU9dHR5UzAsMTE1MjAwIGNvbnNvbGU9dHR5MCB2Z2E9bm9ybWFsICByb290
PS9kZXYvcmFtMCBydyBsaW5rPS9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAx
NDA3MTAxODoxMzk4N2QxNzQ2OTUxYjcyNzE0NmZlZjE4NzQwNmI3YmUwMGEzZmQwOmJpc2Vj
dC1saW51eDkvLnZtbGludXotMTM5ODdkMTc0Njk1MWI3MjcxNDZmZWYxODc0MDZiN2JlMDBh
M2ZkMC0yMDE0MDcxMTA1NTIwNC0xMDgtdnAgYnJhbmNoPWxpbnV4LWRldmVsL2RldmVsLWhv
dXJseS0yMDE0MDcxMDE4IEJPT1RfSU1BR0U9L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMC0wNzExMDI1NS8xMzk4N2QxNzQ2OTUxYjcyNzE0NmZlZjE4NzQwNmI3YmUwMGEzZmQw
L3ZtbGludXotMy4xNi4wLXJjNC0wMDAxOS1nMTM5ODdkMSBkcmJkLm1pbm9yX2NvdW50PTgn
ICAtaW5pdHJkIC9rZXJuZWwtdGVzdHMvaW5pdHJkL3lvY3RvLW1pbmltYWwteDg2XzY0LmNn
eiAtbSAzMjAgLXNtcCAxIC1uZXQgbmljLHZsYW49MSxtb2RlbD1lMTAwMCAtbmV0IHVzZXIs
dmxhbj0xIC1ib290IG9yZGVyPW5jIC1uby1yZWJvb3QgLXdhdGNoZG9nIGk2MzAwZXNiIC1y
dGMgYmFzZT1sb2NhbHRpbWUgLWRyaXZlIGZpbGU9L2ZzL0xBQkVMPUtWTS9kaXNrMC15b2N0
by12cC0xMyxtZWRpYT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMvTEFCRUw9S1ZN
L2Rpc2sxLXlvY3RvLXZwLTEzLG1lZGlhPWRpc2ssaWY9dmlydGlvIC1kcml2ZSBmaWxlPS9m
cy9MQUJFTD1LVk0vZGlzazIteW9jdG8tdnAtMTMsbWVkaWE9ZGlzayxpZj12aXJ0aW8gLWRy
aXZlIGZpbGU9L2ZzL0xBQkVMPUtWTS9kaXNrMy15b2N0by12cC0xMyxtZWRpYT1kaXNrLGlm
PXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMvTEFCRUw9S1ZNL2Rpc2s0LXlvY3RvLXZwLTEzLG1l
ZGlhPWRpc2ssaWY9dmlydGlvIC1kcml2ZSBmaWxlPS9mcy9MQUJFTD1LVk0vZGlzazUteW9j
dG8tdnAtMTMsbWVkaWE9ZGlzayxpZj12aXJ0aW8gLXBpZGZpbGUgL2Rldi9zaG0va2Jvb3Qv
cGlkLXlvY3RvLXZwLTEzIC1zZXJpYWwgZmlsZTovZGV2L3NobS9rYm9vdC9zZXJpYWwteW9j
dG8tdnAtMTMgLWRhZW1vbml6ZSAtZGlzcGxheSBub25lIC1tb25pdG9yIG51bGwgCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTM5ODdkMTc0Njk1MWI3Mjcx
NDZmZWYxODc0MDZiN2JlMDBhM2ZkMC9kbWVzZy15b2N0by12cC0xMzoyMDE0MDcxMDIyMTIy
Mjp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTozLjE2LjAtcmM0LTAwMDE5LWcx
Mzk4N2QxOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xMzk4
N2QxNzQ2OTUxYjcyNzE0NmZlZjE4NzQwNmI3YmUwMGEzZmQwL2RtZXNnLXlvY3RvLXZwLTE1
OjIwMTQwNzEwMjIxMjE4Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjMuMTYu
MC1yYzQtMDAwMTktZzEzOTg3ZDE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEw
LTA3MTEwMjU1LzEzOTg3ZDE3NDY5NTFiNzI3MTQ2ZmVmMTg3NDA2YjdiZTAwYTNmZDAvZG1l
c2cteW9jdG8tdnAtMjM6MjAxNDA3MTAyMjEyMjA6eDg2XzY0LXJhbmRjb25maWctaHN4YTAt
MDcxMTAyNTU6My4xNi4wLXJjNC0wMDAxOS1nMTM5ODdkMToxCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctaHN4YTAtMDcxMTAyNTUvMTM5ODdkMTc0Njk1MWI3MjcxNDZmZWYxODc0MDZi
N2JlMDBhM2ZkMC9kbWVzZy15b2N0by12cC00NzoyMDE0MDcxMDIyMTIxOTp4ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMC0wNzExMDI1NTozLjE2LjAtcmM0LTAwMDE5LWcxMzk4N2QxOjEKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS8xMzk4N2QxNzQ2OTUxYjcy
NzE0NmZlZjE4NzQwNmI3YmUwMGEzZmQwL2RtZXNnLXlvY3RvLXZwLTUwOjIwMTQwNzEwMjIx
MjIxOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjMuMTYuMC1yYzQtMDAwMTkt
ZzEzOTg3ZDE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzEz
OTg3ZDE3NDY5NTFiNzI3MTQ2ZmVmMTg3NDA2YjdiZTAwYTNmZDAvZG1lc2cteW9jdG8tdnAt
NTI6MjAxNDA3MTAyMjEyMTk6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6My4x
Ni4wLXJjNC0wMDAxOS1nMTM5ODdkMToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDcxMTAyNTUvMTM5ODdkMTc0Njk1MWI3MjcxNDZmZWYxODc0MDZiN2JlMDBhM2ZkMC9k
bWVzZy15b2N0by12cC04OjIwMTQwNzEwMjIxMjE5Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEw
LTA3MTEwMjU1OjMuMTYuMC1yYzQtMDAwMTktZzEzOTg3ZDE6MQowOjc6NyBhbGxfZ29vZDpi
YWQ6YWxsX2JhZCBib290cwoKbGluZWFyLWJpc2VjdDogYmFkIGJyYW5jaCBtYXkgYmUgbHV0
by94ODYvdnN5c2NhbGwKbGluZWFyLWJpc2VjdDogaGFuZGxlIG92ZXIgdG8gZ2l0IGJpc2Vj
dApsaW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0IHN0YXJ0IDEzOTg3ZDE3NDY5NTFiNzI3MTQ2
ZmVmMTg3NDA2YjdiZTAwYTNmZDAgOTE0MWE2OGQ3MWFhMTkzZjc4YWFjNTMwNmZjNzI4ZmJh
OGZiNTlmNCAtLQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAxMzk4N2QxLi4uIE1lcmdl
ICdsdXRvL3g4Ni92c3lzY2FsbCcgaW50byBkZXZlbC1ob3VybHktMjAxNDA3MTAxOApIRUFE
IGlzIG5vdyBhdCBlNmQ2OWE2Li4uIE1lcmdlIGJyYW5jaCAnbmV4dCcgb2YgZ2l0Oi8vZ2l0
LmluZnJhZGVhZC5vcmcvdXNlcnMvdmtvdWwvc2xhdmUtZG1hCkJpc2VjdGluZzogNSByZXZp
c2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMyBzdGVwcykKWzcxMDRh
MmUwOGRlOGJkZGI1MmQ0NzE0ZmFkNjNkOGE3OTc3ZWE3ZjJdIHg4Nl82NDogTW92ZSBnZXRj
cHUgY29kZSBmcm9tIHZzeXNjYWxsXzY0LmMgdG8gdmRzby92bWEuYwpsaW5lYXItYmlzZWN0
OiBnaXQgYmlzZWN0IHJ1biAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4OS9vYmotYmlzZWN0CnJ1bm5pbmcgL2Mva2Vy
bmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9s
aW51eDkvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2
XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5
LTIwMTQwNzEwMTg6NzEwNGEyZTA4ZGU4YmRkYjUyZDQ3MTRmYWQ2M2Q4YTc5NzdlYTdmMjpi
aXNlY3QtbGludXg5CgoyMDE0LTA3LTEwLTIyOjEyOjQ5IDcxMDRhMmUwOGRlOGJkZGI1MmQ0
NzE0ZmFkNjNkOGE3OTc3ZWE3ZjIgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAy
NTUtNzEwNGEyZTA4ZGU4YmRkYjUyZDQ3MTRmYWQ2M2Q4YTc5NzdlYTdmMgpDaGVjayBmb3Ig
a2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvNzEw
NGEyZTA4ZGU4YmRkYjUyZDQ3MTRmYWQ2M2Q4YTc5NzdlYTdmMgp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWct
aHN4YTAtMDcxMTAyNTUtNzEwNGEyZTA4ZGU4YmRkYjUyZDQ3MTRmYWQ2M2Q4YTc5NzdlYTdm
Mgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUv
amFrZXRvd24tY29uc3VtZXIveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUtNzEw
NGEyZTA4ZGU4YmRkYjUyZDQ3MTRmYWQ2M2Q4YTc5NzdlYTdmMgprZXJuZWw6IC9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvNzEwNGEyZTA4ZGU4YmRkYjUyZDQ3
MTRmYWQ2M2Q4YTc5NzdlYTdmMi92bWxpbnV6LTMuMTYuMC1yYzMtMDAwMDYtZzcxMDRhMmUK
CjIwMTQtMDctMTAtMjI6NTE6NDkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTEJMgkxNgkxNy4J
MzUuCTQ3Lgk1NAk2MS4JNjkuCTg2CTg3CTg4CTk5CTEwMAkxMjQuCTEzMi4JMTM0CTE1MS4J
MTU2CTE1OQkxNjAJMTY3CTE2OQkxODQuCTE5OC4JMjA1CTIxMQkyMTIJMjM0LgkyMzgJMjQy
LgkyNTYuCTI2OC4JMjcyCTI4NQkyODYJMjkzLgkzMTcJMzI3CTMzMCBTVUNDRVNTCgpCaXNl
Y3Rpbmc6IDIgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDIg
c3RlcHMpCltlMTY1NmFiMmFkZmQxODkxZjYyNjEwYWJlM2U4NWFkOTkyZWUwY2JmXSBhcm02
NCxpYTY0LHBwYyxzMzkwLHNoLHRpbGUsdW0seDg2LG1tOiBSZW1vdmUgZGVmYXVsdCBnYXRl
IGFyZWEKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4OS9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVz
dHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS9saW51
eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA3MTAxODplMTY1NmFiMmFkZmQxODkxZjYyNjEw
YWJlM2U4NWFkOTkyZWUwY2JmOmJpc2VjdC1saW51eDkKCjIwMTQtMDctMTAtMjM6MTk6MjAg
ZTE2NTZhYjJhZGZkMTg5MWY2MjYxMGFiZTNlODVhZDk5MmVlMGNiZiBjb21waWxpbmcKUXVl
dWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMC0wNzExMDI1NS1lMTY1NmFiMmFkZmQxODkxZjYyNjEwYWJlM2U4NWFk
OTkyZWUwY2JmCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMC0wNzExMDI1NS9lMTY1NmFiMmFkZmQxODkxZjYyNjEwYWJlM2U4NWFkOTkyZWUw
Y2JmCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS1lMTY1NmFiMmFkZmQxODkxZjYy
NjEwYWJlM2U4NWFkOTkyZWUwY2JmCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDEtY29uc3VtZXIveDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDcxMTAyNTUtZTE2NTZhYjJhZGZkMTg5MWY2MjYxMGFiZTNlODVhZDk5MmVl
MGNiZgprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUv
ZTE2NTZhYjJhZGZkMTg5MWY2MjYxMGFiZTNlODVhZDk5MmVlMGNiZi92bWxpbnV6LTMuMTYu
MC1yYzMtMDAwMDktZ2UxNjU2YWIKCjIwMTQtMDctMTAtMjM6MjI6MjAgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgCTYxCTk3CTEzMgkxNjgJMjU0CTI3NQkyNzgJMzMwIFNVQ0NFU1MKCkJpc2Vj
dGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMSBz
dGVwKQpbNDY1YzM0OTg1YmI5ODIzYmI0NTM2ZWI2NzUxMTk3ZjJkMjk1Y2EzMl0geDg2LHZk
c286IFNldCBWTV9NQVlSRUFEIGZvciB0aGUgdnZhciB2bWEKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4
OS9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAx
NDA3MTAxODo0NjVjMzQ5ODViYjk4MjNiYjQ1MzZlYjY3NTExOTdmMmQyOTVjYTMyOmJpc2Vj
dC1saW51eDkKCjIwMTQtMDctMTAtMjM6MjY6MjEgNDY1YzM0OTg1YmI5ODIzYmI0NTM2ZWI2
NzUxMTk3ZjJkMjk1Y2EzMiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS00
NjVjMzQ5ODViYjk4MjNiYjQ1MzZlYjY3NTExOTdmMmQyOTVjYTMyCkNoZWNrIGZvciBrZXJu
ZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS80NjVjMzQ5
ODViYjk4MjNiYjQ1MzZlYjY3NTExOTdmMmQyOTVjYTMyCndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MC0wNzExMDI1NS00NjVjMzQ5ODViYjk4MjNiYjQ1MzZlYjY3NTExOTdmMmQyOTVjYTMyCmtl
cm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS80NjVjMzQ5
ODViYjk4MjNiYjQ1MzZlYjY3NTExOTdmMmQyOTVjYTMyL3ZtbGludXotMy4xNi4wLXJjMy0w
MDAxMS1nNDY1YzM0OQoKMjAxNC0wNy0xMC0yMzoyODoyMSBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAuCTU0IFRFU1QgRkFJTFVSRQpbICAgIDguMzEwMDg1XSBpMmMgaTJjLTA6IGRldGVjdCBm
YWlsOiBhZGRyZXNzIG1hdGNoLCAweDJmClsgICAgOC4zMTAwODVdIGkyYyBpMmMtMDogZGV0
ZWN0IGZhaWw6IGFkZHJlc3MgbWF0Y2gsIDB4MmYKCkJVRzoga2VybmVsIGJvb3QgaGFuZwpF
bGFwc2VkIHRpbWU6IDM1CnFlbXUtc3lzdGVtLXg4Nl82NCAtY3B1IGt2bTY0IC1lbmFibGUt
a3ZtIC1rZXJuZWwgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS80
NjVjMzQ5ODViYjk4MjNiYjQ1MzZlYjY3NTExOTdmMmQyOTVjYTMyL3ZtbGludXotMy4xNi4w
LXJjMy0wMDAxMS1nNDY1YzM0OSAtYXBwZW5kICdodW5nX3Rhc2tfcGFuaWM9MSBlYXJseXBy
aW50az10dHlTMCwxMTUyMDAgZGVidWcgYXBpYz1kZWJ1ZyBzeXNycV9hbHdheXNfZW5hYmxl
ZCByY3VwZGF0ZS5yY3VfY3B1X3N0YWxsX3RpbWVvdXQ9MTAwIHBhbmljPTEwIHNvZnRsb2Nr
dXBfcGFuaWM9MSBubWlfd2F0Y2hkb2c9cGFuaWMgIHByb21wdF9yYW1kaXNrPTAgY29uc29s
ZT10dHlTMCwxMTUyMDAgY29uc29sZT10dHkwIHZnYT1ub3JtYWwgIHJvb3Q9L2Rldi9yYW0w
IHJ3IGxpbms9L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmln
LWhzeGEwLTA3MTEwMjU1L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDcxMDE4OjQ2
NWMzNDk4NWJiOTgyM2JiNDUzNmViNjc1MTE5N2YyZDI5NWNhMzI6YmlzZWN0LWxpbnV4OS8u
dm1saW51ei00NjVjMzQ5ODViYjk4MjNiYjQ1MzZlYjY3NTExOTdmMmQyOTVjYTMyLTIwMTQw
NzExMDcyODE3LTExNC1pdmI0MSBicmFuY2g9bGludXgtZGV2ZWwvZGV2ZWwtaG91cmx5LTIw
MTQwNzEwMTggQk9PVF9JTUFHRT0va2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3
MTEwMjU1LzQ2NWMzNDk4NWJiOTgyM2JiNDUzNmViNjc1MTE5N2YyZDI5NWNhMzIvdm1saW51
ei0zLjE2LjAtcmMzLTAwMDExLWc0NjVjMzQ5IGRyYmQubWlub3JfY291bnQ9OCcgIC1pbml0
cmQgL2tlcm5lbC10ZXN0cy9pbml0cmQvcXVhbnRhbC1jb3JlLXg4Nl82NC5jZ3ogLW0gMzIw
IC1zbXAgMiAtbmV0IG5pYyx2bGFuPTEsbW9kZWw9ZTEwMDAgLW5ldCB1c2VyLHZsYW49MSAt
Ym9vdCBvcmRlcj1uYyAtbm8tcmVib290IC13YXRjaGRvZyBpNjMwMGVzYiAtcnRjIGJhc2U9
bG9jYWx0aW1lIC1waWRmaWxlIC9kZXYvc2htL2tib290L3BpZC1xdWFudGFsLWl2YjQxLTEw
MiAtc2VyaWFsIGZpbGU6L2Rldi9zaG0va2Jvb3Qvc2VyaWFsLXF1YW50YWwtaXZiNDEtMTAy
IC1kYWVtb25pemUgLWRpc3BsYXkgbm9uZSAtbW9uaXRvciBudWxsIAova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzQ2NWMzNDk4NWJiOTgyM2JiNDUzNmViNjc1
MTE5N2YyZDI5NWNhMzIvZG1lc2cteW9jdG8taXZiNDEtMTEyOjIwMTQwNzEwMjMyODQ3Ong4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1oc3hhMC0wNzExMDI1NS80NjVjMzQ5ODViYjk4MjNiYjQ1MzZlYjY3NTExOTdmMmQy
OTVjYTMyL2RtZXNnLXlvY3RvLWl2YjQxLTExNzoyMDE0MDcxMDIzMjg0NDp4ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDcxMTAyNTUvNDY1YzM0OTg1YmI5ODIzYmI0NTM2ZWI2NzUxMTk3ZjJkMjk1Y2EzMi9k
bWVzZy15b2N0by1pdmI0MS0xMTg6MjAxNDA3MTAyMzI4NDQ6eDg2XzY0LXJhbmRjb25maWct
aHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEw
MjU1LzQ2NWMzNDk4NWJiOTgyM2JiNDUzNmViNjc1MTE5N2YyZDI5NWNhMzIvZG1lc2cteW9j
dG8taXZiNDEtMTIzOjIwMTQwNzEwMjMyODQ0Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3
MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS80NjVj
MzQ5ODViYjk4MjNiYjQ1MzZlYjY3NTExOTdmMmQyOTVjYTMyL2RtZXNnLXlvY3RvLWl2YjQx
LTEyNToyMDE0MDcxMDIzMjg0NDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvNDY1YzM0OTg1YmI5
ODIzYmI0NTM2ZWI2NzUxMTk3ZjJkMjk1Y2EzMi9kbWVzZy15b2N0by1pdmI0MS0xMjg6MjAx
NDA3MTAyMzI4NDU6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzQ2NWMzNDk4NWJiOTgyM2JiNDUz
NmViNjc1MTE5N2YyZDI5NWNhMzIvZG1lc2cteW9jdG8taXZiNDEtMjQ6MjAxNDA3MTAyMzI4
NDQ6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzQ2NWMzNDk4NWJiOTgyM2JiNDUzNmViNjc1MTE5
N2YyZDI5NWNhMzIvZG1lc2cteW9jdG8taXZiNDEtMzA6MjAxNDA3MTAyMzI4NDU6eDg2XzY0
LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWhzeGEwLTA3MTEwMjU1LzQ2NWMzNDk4NWJiOTgyM2JiNDUzNmViNjc1MTE5N2YyZDI5NWNh
MzIvZG1lc2cteW9jdG8taXZiNDEtMzM6MjAxNDA3MTAyMzI4NDk6eDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3
MTEwMjU1LzQ2NWMzNDk4NWJiOTgyM2JiNDUzNmViNjc1MTE5N2YyZDI5NWNhMzIvZG1lc2ct
eW9jdG8taXZiNDEtMzk6MjAxNDA3MTAyMzI4NDU6eDg2XzY0LXJhbmRjb25maWctaHN4YTAt
MDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzQ2
NWMzNDk4NWJiOTgyM2JiNDUzNmViNjc1MTE5N2YyZDI5NWNhMzIvZG1lc2cteW9jdG8taXZi
NDEtNTk6MjAxNDA3MTAyMzI4NDQ6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6
Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzQ2NWMzNDk4NWJi
OTgyM2JiNDUzNmViNjc1MTE5N2YyZDI5NWNhMzIvZG1lc2cteW9jdG8taXZiNDEtODI6MjAx
NDA3MTAyMzI4NDk6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzQ2NWMzNDk4NWJiOTgyM2JiNDUz
NmViNjc1MTE5N2YyZDI5NWNhMzIvZG1lc2cteW9jdG8taXZiNDEtODk6MjAxNDA3MTAyMzI4
NDg6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzQ2NWMzNDk4NWJiOTgyM2JiNDUzNmViNjc1MTE5
N2YyZDI5NWNhMzIvZG1lc2cteW9jdG8taXZiNDEtMTA4OjIwMTQwNzEwMjMyODUyOng4Nl82
NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMC0wNzExMDI1NS80NjVjMzQ5ODViYjk4MjNiYjQ1MzZlYjY3NTExOTdmMmQyOTVj
YTMyL2RtZXNnLXlvY3RvLWl2YjQxLTU3OjIwMTQwNzEwMjMyODUyOng4Nl82NC1yYW5kY29u
ZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0w
NzExMDI1NS80NjVjMzQ5ODViYjk4MjNiYjQ1MzZlYjY3NTExOTdmMmQyOTVjYTMyL2RtZXNn
LXlvY3RvLWl2YjQxLTcxOjIwMTQwNzEwMjMyODU5Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEw
LTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS80
NjVjMzQ5ODViYjk4MjNiYjQ1MzZlYjY3NTExOTdmMmQyOTVjYTMyL2RtZXNnLXlvY3RvLWl2
YjQxLTcyOjIwMTQwNzEwMjMyODU0Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1
OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS80NjVjMzQ5ODVi
Yjk4MjNiYjQ1MzZlYjY3NTExOTdmMmQyOTVjYTMyL2RtZXNnLXlvY3RvLXZwLTExOjIwMTQw
NzEwMjMyOTE3Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjMuMTYuMC1yYzMt
MDAwMTEtZzQ2NWMzNDk6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEw
MjU1LzQ2NWMzNDk4NWJiOTgyM2JiNDUzNmViNjc1MTE5N2YyZDI5NWNhMzIvZG1lc2cteW9j
dG8tdnAtMTI6MjAxNDA3MTAyMzI5MTY6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAy
NTU6My4xNi4wLXJjMy0wMDAxMS1nNDY1YzM0OTozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDcxMTAyNTUvNDY1YzM0OTg1YmI5ODIzYmI0NTM2ZWI2NzUxMTk3ZjJkMjk1
Y2EzMi9kbWVzZy15b2N0by12cC0xODoyMDE0MDcxMDIzMjkyMjp4ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMC0wNzExMDI1NTozLjE2LjAtcmMzLTAwMDExLWc0NjVjMzQ5OjMKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS80NjVjMzQ5ODViYjk4MjNiYjQ1MzZl
YjY3NTExOTdmMmQyOTVjYTMyL2RtZXNnLXlvY3RvLXZwLTE6MjAxNDA3MTAyMzI5MjI6eDg2
XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6My4xNi4wLXJjMy0wMDAxMS1nNDY1YzM0
OTozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvNDY1YzM0OTg1
YmI5ODIzYmI0NTM2ZWI2NzUxMTk3ZjJkMjk1Y2EzMi9kbWVzZy15b2N0by12cC0yODoyMDE0
MDcxMDIzMjkxNjp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTozLjE2LjAtcmMz
LTAwMDExLWc0NjVjMzQ5OjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzEx
MDI1NS80NjVjMzQ5ODViYjk4MjNiYjQ1MzZlYjY3NTExOTdmMmQyOTVjYTMyL2RtZXNnLXlv
Y3RvLXZwLTU6MjAxNDA3MTAyMzI5MTY6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAy
NTU6My4xNi4wLXJjMy0wMDAxMS1nNDY1YzM0OTozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDcxMTAyNTUvNDY1YzM0OTg1YmI5ODIzYmI0NTM2ZWI2NzUxMTk3ZjJkMjk1
Y2EzMi9kbWVzZy15b2N0by12cC02MToyMDE0MDcxMDIzMjkxODp4ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMC0wNzExMDI1NTozLjE2LjAtcmMzLTAwMDExLWc0NjVjMzQ5OjMKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS80NjVjMzQ5ODViYjk4MjNiYjQ1MzZl
YjY3NTExOTdmMmQyOTVjYTMyL2RtZXNnLXlvY3RvLXZwLTYyOjIwMTQwNzEwMjMyOTE5Ong4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjMuMTYuMC1yYzMtMDAwMTEtZzQ2NWMz
NDk6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzQ2NWMzNDk4
NWJiOTgyM2JiNDUzNmViNjc1MTE5N2YyZDI5NWNhMzIvZG1lc2cteW9jdG8tdnAtNjoyMDE0
MDcxMDIzMjkxNTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTozLjE2LjAtcmMz
LTAwMDExLWc0NjVjMzQ5OjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzEx
MDI1NS80NjVjMzQ5ODViYjk4MjNiYjQ1MzZlYjY3NTExOTdmMmQyOTVjYTMyL2RtZXNnLXlv
Y3RvLWl2YjQxLTEwNDoyMDE0MDcxMDIzMjkwNDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0w
NzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvNDY1
YzM0OTg1YmI5ODIzYmI0NTM2ZWI2NzUxMTk3ZjJkMjk1Y2EzMi9kbWVzZy15b2N0by1pdmI0
MS0xMDY6MjAxNDA3MTAyMzI5MDQ6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6
Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzQ2NWMzNDk4NWJi
OTgyM2JiNDUzNmViNjc1MTE5N2YyZDI5NWNhMzIvZG1lc2cteW9jdG8taXZiNDEtMTE6MjAx
NDA3MTAyMzI5MDQ6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzQ2NWMzNDk4NWJiOTgyM2JiNDUz
NmViNjc1MTE5N2YyZDI5NWNhMzIvZG1lc2cteW9jdG8taXZiNDEtMzQ6MjAxNDA3MTAyMzI5
MDQ6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzQ2NWMzNDk4NWJiOTgyM2JiNDUzNmViNjc1MTE5
N2YyZDI5NWNhMzIvZG1lc2cteW9jdG8taXZiNDEtNTI6MjAxNDA3MTAyMzI5MDQ6eDg2XzY0
LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWhzeGEwLTA3MTEwMjU1LzQ2NWMzNDk4NWJiOTgyM2JiNDUzNmViNjc1MTE5N2YyZDI5NWNh
MzIvZG1lc2cteW9jdG8taXZiNDEtNTM6MjAxNDA3MTAyMzI5MDQ6eDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3
MTEwMjU1LzQ2NWMzNDk4NWJiOTgyM2JiNDUzNmViNjc1MTE5N2YyZDI5NWNhMzIvZG1lc2ct
eW9jdG8taXZiNDEtNjk6MjAxNDA3MTAyMzI5MDQ6eDg2XzY0LXJhbmRjb25maWctaHN4YTAt
MDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzQ2
NWMzNDk4NWJiOTgyM2JiNDUzNmViNjc1MTE5N2YyZDI5NWNhMzIvZG1lc2cteW9jdG8taXZi
NDEtODg6MjAxNDA3MTAyMzI5MDQ6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6
Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzQ2NWMzNDk4NWJi
OTgyM2JiNDUzNmViNjc1MTE5N2YyZDI5NWNhMzIvZG1lc2cteW9jdG8tdnAtMTQ6MjAxNDA3
MTAyMzI5MjM6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6My4xNi4wLXJjMy0w
MDAxMS1nNDY1YzM0OTozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAy
NTUvNDY1YzM0OTg1YmI5ODIzYmI0NTM2ZWI2NzUxMTk3ZjJkMjk1Y2EzMi9kbWVzZy15b2N0
by12cC0xOToyMDE0MDcxMDIzMjkyMzp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1
NTozLjE2LjAtcmMzLTAwMDExLWc0NjVjMzQ5OjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMC0wNzExMDI1NS80NjVjMzQ5ODViYjk4MjNiYjQ1MzZlYjY3NTExOTdmMmQyOTVj
YTMyL2RtZXNnLXlvY3RvLXZwLTMwOjIwMTQwNzEwMjMyOTI0Ong4Nl82NC1yYW5kY29uZmln
LWhzeGEwLTA3MTEwMjU1OjMuMTYuMC1yYzMtMDAwMTEtZzQ2NWMzNDk6MwowOjM3OjkxIGFs
bF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMpCls0NDJhYmEwYzYxMzFmMGM0
MWRmYzVlZGI2YmZiODgzMzU1NTY1MjNmXSB4ODZfNjQsdnN5c2NhbGw6IE1ha2UgdnN5c2Nh
bGwgZW11bGF0aW9uIGNvbmZpZ3VyYWJsZQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg5L29iai1iaXNl
Y3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmln
LWhzeGEwLTA3MTEwMjU1L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDcxMDE4OjQ0
MmFiYTBjNjEzMWYwYzQxZGZjNWVkYjZiZmI4ODMzNTU1NjUyM2Y6YmlzZWN0LWxpbnV4OQoK
MjAxNC0wNy0xMC0yMzoyOToyMiA0NDJhYmEwYzYxMzFmMGM0MWRmYzVlZGI2YmZiODgzMzU1
NTY1MjNmIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LTQ0MmFiYTBjNjEz
MWYwYzQxZGZjNWVkYjZiZmI4ODMzNTU1NjUyM2YKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzQ0MmFiYTBjNjEzMWYwYzQx
ZGZjNWVkYjZiZmI4ODMzNTU1NjUyM2YKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1
LTQ0MmFiYTBjNjEzMWYwYzQxZGZjNWVkYjZiZmI4ODMzNTU1NjUyM2YKa2VybmVsOiAva2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzQ0MmFiYTBjNjEzMWYwYzQx
ZGZjNWVkYjZiZmI4ODMzNTU1NjUyM2Yvdm1saW51ei0zLjE2LjAtcmMzLTAwMDEwLWc0NDJh
YmEwCgoyMDE0LTA3LTEwLTIzOjMxOjIyIGRldGVjdGluZyBib290IHN0YXRlIC4gVEVTVCBG
QUlMVVJFCm1vdW50OiBjYW4ndCByZWFkICcvcHJvYy9tb3VudHMnOiBObyBzdWNoIGZpbGUg
b3IgZGlyZWN0b3J5ClsgICAzNC4wNzk5NDFdIGluaXRbMV06IHNlZ2ZhdWx0IGF0IGZmZmZm
ZmZmZmY2MDA0MDAgaXAgZmZmZmZmZmZmZjYwMDQwMCBzcCAwMDAwN2ZmZjlkNzBmODA4IGVy
cm9yIDE1ClsgICAzNC4wODA4NjFdIGluaXRbMV06IHNlZ2ZhdWx0IGF0IGZmZmZmZmZmZmY2
MDA0MDAgaXAgZmZmZmZmZmZmZjYwMDQwMCBzcCAwMDAwN2ZmZjlkNzBlZTM4IGVycm9yIDE1
ClsgICAzNC4wODE3NDddIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBBdHRlbXB0ZWQg
dG8ga2lsbCBpbml0ISBleGl0Y29kZT0weDAwMDAwMDBiClsgICAzNC4wODE3NDddIApbICAg
MzQuMDgyNTY2XSBDUFU6IDAgUElEOiAxIENvbW06IGluaXQgTm90IHRhaW50ZWQgMy4xNi4w
LXJjMy0wMDAxMC1nNDQyYWJhMCAjNApbICAgMzQuMDgzMTg4XSAgMDAwMDAwMDAwMDAwMDAw
MCBmZmZmODgwMDAwMDMzY2MwIGZmZmZmZmZmODFmZjQ4NWYgZmZmZjg4MDAwMDAzM2QzOApb
ICAgMzQuMDgzODgzXSAgZmZmZmZmZmY4MWZmMTM0MiBmZmZmODgwMDAwMDAwMDEwIGZmZmY4
ODAwMDAwMzNkNDggZmZmZjg4MDAwMDAzM2NlOApbICAgMzQuMDg0NTcxXSAgZmZmZmZmZmY4
MmM0NDBjMCAwMDAwMDAwMDAwMDAwMDBiIDhjNjMxOGM2MzE4YzYzMjAgMDAwMDAwMDdlZjZl
MDBmYwpbICAgMzQuMDg1MjYzXSBDYWxsIFRyYWNlOgpbICAgMzQuMDg1NDg2XSAgWzxmZmZm
ZmZmZjgxZmY0ODVmPl0gZHVtcF9zdGFjaysweDE5LzB4MWIKWyAgIDM0LjA4NTkzOF0gIFs8
ZmZmZmZmZmY4MWZmMTM0Mj5dIHBhbmljKzB4Y2IvMHgxZmIKWyAgIDM0LjA4NjM1NV0gIFs8
ZmZmZmZmZmY4MTA5M2IyZj5dIGRvX2V4aXQrMHgzZGQvMHg4MGYKWyAgIDM0LjA4NjgyNl0g
IFs8ZmZmZmZmZmY4MTBiMDcxZD5dID8gbG9jYWxfY2xvY2srMHgxNC8weDFkClsgICAzNC4w
ODcyOTRdICBbPGZmZmZmZmZmODEwOTQwMDI+XSBkb19ncm91cF9leGl0KzB4NzUvMHhiNApb
ICAgMzQuMDg3NzU5XSAgWzxmZmZmZmZmZjgxMDljN2U3Pl0gZ2V0X3NpZ25hbF90b19kZWxp
dmVyKzB4NDhhLzB4NGFhClsgICAzNC4wODgzMDNdICBbPGZmZmZmZmZmODEwMDIzMWE+XSBk
b19zaWduYWwrMHg0My8weDViYQpbICAgMzQuMDg4NzQ4XSAgWzxmZmZmZmZmZjgxMGI0Yjc5
Pl0gPyBsb2NrX3JlbGVhc2VfaG9sZHRpbWUrMHg2Yy8weDc3ClsgICAzNC4wODkyOTFdICBb
PGZmZmZmZmZmODEwYjgzYjU+XSA/IGxvY2tfcmVsZWFzZV9ub25fbmVzdGVkKzB4ZDAvMHgy
MWUKWyAgIDM0LjA4OTg1NV0gIFs8ZmZmZmZmZmY4MTBiMDY0Nj5dID8gc2NoZWRfY2xvY2tf
Y3B1KzB4NGUvMHg2MgpbICAgMzQuMDkwNDU5XSAgWzxmZmZmZmZmZjgxMGZkNDY1Pl0gPyBt
aWdodF9mYXVsdCsweDRmLzB4OWMKWyAgIDM0LjA5MDc3MF0gIFs8ZmZmZmZmZmY4MTBiNjE2
Mz5dID8gdHJhY2VfaGFyZGlycXNfb2ZmX2NhbGxlcisweDM2LzB4YTUKWyAgIDM0LjA5MDc3
MF0gIFs8ZmZmZmZmZmY4MjAwNDI5OD5dID8gcmV0aW50X3NpZ25hbCsweDExLzB4OTkKWyAg
IDM0LjA5MDc3MF0gIFs8ZmZmZmZmZmY4MTAwMjhiNT5dIGRvX25vdGlmeV9yZXN1bWUrMHgy
NC8weDUzClsgICAzNC4wOTA3NzBdICBbPGZmZmZmZmZmODIwMDQyZDQ+XSByZXRpbnRfc2ln
bmFsKzB4NGQvMHg5OQpbICAgMzQuMDkwNzcwXSBLZXJuZWwgT2Zmc2V0OiAweDAgZnJvbSAw
eGZmZmZmZmZmODEwMDAwMDAgKHJlbG9jYXRpb24gcmFuZ2U6IDB4ZmZmZmZmZmY4MDAwMDAw
MC0weGZmZmZmZmZmOWZmZmZmZmYpClsgICAzNC4wOTA3NzBdIGRybV9rbXNfaGVscGVyOiBw
YW5pYyBvY2N1cnJlZCwgc3dpdGNoaW5nIGJhY2sgdG8gdGV4dCBjb25zb2xlClsgICAzNC4w
OTA3NzBdIApbICAgMzQuMDkwNzcwXSA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
ClsgICAzNC4wOTA3NzBdIFsgSU5GTzogc3VzcGljaW91cyBSQ1UgdXNhZ2UuIF0KWyAgIDM0
LjA5MDc3MF0gMy4xNi4wLXJjMy0wMDAxMC1nNDQyYWJhMCAjNCBOb3QgdGFpbnRlZApbICAg
MzQuMDkwNzcwXSAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tClsgICAzNC4wOTA3
NzBdIC9rYnVpbGQvc3JjL2NvbnN1bWVyL2luY2x1ZGUvbGludXgvcmN1cGRhdGUuaDo1Mzkg
SWxsZWdhbCBjb250ZXh0IHN3aXRjaCBpbiBSQ1UgcmVhZC1zaWRlIGNyaXRpY2FsIHNlY3Rp
b24hClsgICAzNC4wOTA3NzBdIApbICAgMzQuMDkwNzcwXSBvdGhlciBpbmZvIHRoYXQgbWln
aHQgaGVscCB1cyBkZWJ1ZyB0aGlzOgpbICAgMzQuMDkwNzcwXSAKWyAgIDM0LjA5MDc3MF0g
ClsgICAzNC4wOTA3NzBdIHJjdV9zY2hlZHVsZXJfYWN0aXZlID0gMSwgZGVidWdfbG9ja3Mg
PSAwClsgICAzNC4wOTA3NzBdIDMgbG9ja3MgaGVsZCBieSBpbml0LzE6ClsgICAzNC4wOTA3
NzBdICAjMDogIChwYW5pY19sb2NrKXsuLi4uKy59LCBhdDogWzxmZmZmZmZmZjgxZmYxMmJh
Pl0gcGFuaWMrMHg0My8weDFmYgpbICAgMzQuMDkwNzcwXSAgIzE6ICAocmN1X3JlYWRfbG9j
ayl7Li4uLi4ufSwgYXQ6IFs8ZmZmZmZmZmY4MTBhYjg3OT5dIHJjdV9sb2NrX2FjcXVpcmUr
MHgwLzB4MjMKWyAgIDM0LjA5MDc3MF0gICMyOiAgKCZkZXYtPm1vZGVfY29uZmlnLm11dGV4
KXsrLisuKy59LCBhdDogWzxmZmZmZmZmZjgxNGE3NGQ3Pl0gZHJtX2ZiX2hlbHBlcl9wYW5p
YysweDVkLzB4YWIKWyAgIDM0LjA5MDc3MF0gClsgICAzNC4wOTA3NzBdIHN0YWNrIGJhY2t0
cmFjZToKWyAgIDM0LjA5MDc3MF0gQ1BVOiAwIFBJRDogMSBDb21tOiBpbml0IE5vdCB0YWlu
dGVkIDMuMTYuMC1yYzMtMDAwMTAtZzQ0MmFiYTAgIzQKWyAgIDM0LjA5MDc3MF0gIDAwMDAw
MDAwMDAwMDAwMDAgZmZmZjg4MDAwMDAzMzlkMCBmZmZmZmZmZjgxZmY0ODVmIGZmZmY4ODAw
MDAwMzNhMDAKWyAgIDM0LjA5MDc3MF0gIGZmZmZmZmZmODEwYjg4MjQgZmZmZmZmZmY4Mjgz
NjI0OCAwMDAwMDAwMDAwMDAwMjRhIDAwMDAwMDAwMDAwMDAwMDAKWyAgIDM0LjA5MDc3MF0g
IGZmZmY4ODAwMTAxMmUwMDggZmZmZjg4MDAwMDAzM2ExMCBmZmZmZmZmZjgxMGFkY2UzIGZm
ZmY4ODAwMDAwMzNhMzgKWyAgIDM0LjA5MDc3MF0gQ2FsbCBUcmFjZToKWyAgIDM0LjA5MDc3
MF0gIFs8ZmZmZmZmZmY4MWZmNDg1Zj5dIGR1bXBfc3RhY2srMHgxOS8weDFiClsgICAzNC4w
OTA3NzBdICBbPGZmZmZmZmZmODEwYjg4MjQ+XSBsb2NrZGVwX3JjdV9zdXNwaWNpb3VzKzB4
ZjYvMHhmZgpbICAgMzQuMDkwNzcwXSAgWzxmZmZmZmZmZjgxMGFkY2UzPl0gcmN1X3ByZWVt
cHRfc2xlZXBfY2hlY2srMHg0NS8weDQ3ClsgICAzNC4wOTA3NzBdICBbPGZmZmZmZmZmODEw
YWZlZGY+XSBfX21pZ2h0X3NsZWVwKzB4MTcvMHgxOWEKWyAgIDM0LjA5MDc3MF0gIFs8ZmZm
ZmZmZmY4MjAwMDE5ZT5dIG11dGV4X2xvY2tfbmVzdGVkKzB4MmUvMHgzNjkKWyAgIDM0LjA5
MDc3MF0gIFs8ZmZmZmZmZmY4MTBiODY1Nz5dID8gbG9ja19yZWxlYXNlKzB4MTU0LzB4MTg1
ClsgICAzNC4wOTA3NzBdICBbPGZmZmZmZmZmODEwYjYxZGY+XSA/IHRyYWNlX2hhcmRpcnFz
X29mZisweGQvMHhmClsgICAzNC4wOTA3NzBdICBbPGZmZmZmZmZmODE0YjRhZDM+XSBfb2Jq
ZWN0X2ZpbmQrMHgyNS8weDZjClsgICAzNC4wOTA3NzBdICBbPGZmZmZmZmZmODE0YjUyODM+
XSBkcm1fbW9kZV9vYmplY3RfZmluZCsweDM4LzB4NTMKWyAgIDM0LjA5MDc3MF0gIFs8ZmZm
ZmZmZmY4MTU5M2Y2ZT5dIGNpcnJ1c19jb25uZWN0b3JfYmVzdF9lbmNvZGVyKzB4MjEvMHgy
ZgpbICAgMzQuMDkwNzcwXSAgWzxmZmZmZmZmZjgxNGE1MzgyPl0gZHJtX2NydGNfaGVscGVy
X3NldF9jb25maWcrMHgzOGMvMHg4M2MKWyAgIDM0LjA5MDc3MF0gIFs8ZmZmZmZmZmY4MTRi
NmM0ND5dIGRybV9tb2RlX3NldF9jb25maWdfaW50ZXJuYWwrMHg1My8weGNhClsgICAzNC4w
OTA3NzBdICBbPGZmZmZmZmZmODE0YTczMWY+XSByZXN0b3JlX2ZiZGV2X21vZGUrMHg5MS8w
eGFkClsgICAzNC4wOTA3NzBdICBbPGZmZmZmZmZmODE0YTc0ZTM+XSBkcm1fZmJfaGVscGVy
X3BhbmljKzB4NjkvMHhhYgpbICAgMzQuMDkwNzcwXSAgWzxmZmZmZmZmZjgxMGFiOTJjPl0g
bm90aWZpZXJfY2FsbF9jaGFpbisweDYxLzB4OGIKWyAgIDM0LjA5MDc3MF0gIFs8ZmZmZmZm
ZmY4MTBhYmE0Zj5dIF9fYXRvbWljX25vdGlmaWVyX2NhbGxfY2hhaW4rMHg3ZS8weGU2Clsg
ICAzNC4wOTA3NzBdICBbPGZmZmZmZmZmODEwYWJhYzY+XSBhdG9taWNfbm90aWZpZXJfY2Fs
bF9jaGFpbisweGYvMHgxMQpbICAgMzQuMDkwNzcwXSAgWzxmZmZmZmZmZjgxZmYxMzY3Pl0g
cGFuaWMrMHhmMC8weDFmYgpbICAgMzQuMDkwNzcwXSAgWzxmZmZmZmZmZjgxMDkzYjJmPl0g
ZG9fZXhpdCsweDNkZC8weDgwZgpbICAgMzQuMDkwNzcwXSAgWzxmZmZmZmZmZjgxMGIwNzFk
Pl0gPyBsb2NhbF9jbG9jaysweDE0LzB4MWQKWyAgIDM0LjA5MDc3MF0gIFs8ZmZmZmZmZmY4
MTA5NDAwMj5dIGRvX2dyb3VwX2V4aXQrMHg3NS8weGI0ClsgICAzNC4wOTA3NzBdICBbPGZm
ZmZmZmZmODEwOWM3ZTc+XSBnZXRfc2lnbmFsX3RvX2RlbGl2ZXIrMHg0OGEvMHg0YWEKWyAg
IDM0LjA5MDc3MF0gIFs8ZmZmZmZmZmY4MTAwMjMxYT5dIGRvX3NpZ25hbCsweDQzLzB4NWJh
ClsgICAzNC4wOTA3NzBdICBbPGZmZmZmZmZmODEwYjRiNzk+XSA/IGxvY2tfcmVsZWFzZV9o
b2xkdGltZSsweDZjLzB4NzcKWyAgIDM0LjA5MDc3MF0gIFs8ZmZmZmZmZmY4MTBiODNiNT5d
ID8gbG9ja19yZWxlYXNlX25vbl9uZXN0ZWQrMHhkMC8weDIxZQpbICAgMzQuMDkwNzcwXSAg
WzxmZmZmZmZmZjgxMGIwNjQ2Pl0gPyBzY2hlZF9jbG9ja19jcHUrMHg0ZS8weDYyClsgICAz
NC4wOTA3NzBdICBbPGZmZmZmZmZmODEwZmQ0NjU+XSA/IG1pZ2h0X2ZhdWx0KzB4NGYvMHg5
YwpbICAgMzQuMDkwNzcwXSAgWzxmZmZmZmZmZjgxMGI2MTYzPl0gPyB0cmFjZV9oYXJkaXJx
c19vZmZfY2FsbGVyKzB4MzYvMHhhNQpbICAgMzQuMDkwNzcwXSAgWzxmZmZmZmZmZjgyMDA0
Mjk4Pl0gPyByZXRpbnRfc2lnbmFsKzB4MTEvMHg5OQpbICAgMzQuMDkwNzcwXSAgWzxmZmZm
ZmZmZjgxMDAyOGI1Pl0gZG9fbm90aWZ5X3Jlc3VtZSsweDI0LzB4NTMKWyAgIDM0LjA5MDc3
MF0gIFs8ZmZmZmZmZmY4MjAwNDJkND5dIHJldGludF9zaWduYWwrMHg0ZC8weDk5ClsgICAz
NC4wOTA3NzBdIFJlYm9vdGluZyBpbiAxMCBzZWNvbmRzLi4KRWxhcHNlZCB0aW1lOiA0MApx
ZW11LXN5c3RlbS14ODZfNjQgLWNwdSBrdm02NCAtZW5hYmxlLWt2bSAta2VybmVsIC9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvNDQyYWJhMGM2MTMxZjBjNDFk
ZmM1ZWRiNmJmYjg4MzM1NTU2NTIzZi92bWxpbnV6LTMuMTYuMC1yYzMtMDAwMTAtZzQ0MmFi
YTAgLWFwcGVuZCAnaHVuZ190YXNrX3BhbmljPTEgZWFybHlwcmludGs9dHR5UzAsMTE1MjAw
IGRlYnVnIGFwaWM9ZGVidWcgc3lzcnFfYWx3YXlzX2VuYWJsZWQgcmN1cGRhdGUucmN1X2Nw
dV9zdGFsbF90aW1lb3V0PTEwMCBwYW5pYz0xMCBzb2Z0bG9ja3VwX3BhbmljPTEgbm1pX3dh
dGNoZG9nPXBhbmljICBwcm9tcHRfcmFtZGlzaz0wIGNvbnNvbGU9dHR5UzAsMTE1MjAwIGNv
bnNvbGU9dHR5MCB2Z2E9bm9ybWFsICByb290PS9kZXYvcmFtMCBydyBsaW5rPS9rYnVpbGQt
dGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS9s
aW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA3MTAxODo0NDJhYmEwYzYxMzFmMGM0MWRm
YzVlZGI2YmZiODgzMzU1NTY1MjNmOmJpc2VjdC1saW51eDkvLnZtbGludXotNDQyYWJhMGM2
MTMxZjBjNDFkZmM1ZWRiNmJmYjg4MzM1NTU2NTIzZi0yMDE0MDcxMTA3MzA0My0xMDQtaXZi
NDEgYnJhbmNoPWxpbnV4LWRldmVsL2RldmVsLWhvdXJseS0yMDE0MDcxMDE4IEJPT1RfSU1B
R0U9L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS80NDJhYmEwYzYx
MzFmMGM0MWRmYzVlZGI2YmZiODgzMzU1NTY1MjNmL3ZtbGludXotMy4xNi4wLXJjMy0wMDAx
MC1nNDQyYWJhMCBkcmJkLm1pbm9yX2NvdW50PTgnICAtaW5pdHJkIC9rZXJuZWwtdGVzdHMv
aW5pdHJkL3lvY3RvLW1pbmltYWwteDg2XzY0LmNneiAtbSAzMjAgLXNtcCAxIC1uZXQgbmlj
LHZsYW49MSxtb2RlbD1lMTAwMCAtbmV0IHVzZXIsdmxhbj0xIC1ib290IG9yZGVyPW5jIC1u
by1yZWJvb3QgLXdhdGNoZG9nIGk2MzAwZXNiIC1ydGMgYmFzZT1sb2NhbHRpbWUgLXBpZGZp
bGUgL2Rldi9zaG0va2Jvb3QvcGlkLXlvY3RvLWl2YjQxLTEwMiAtc2VyaWFsIGZpbGU6L2Rl
di9zaG0va2Jvb3Qvc2VyaWFsLXlvY3RvLWl2YjQxLTEwMiAtZGFlbW9uaXplIC1kaXNwbGF5
IG5vbmUgLW1vbml0b3IgbnVsbCAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0w
NzExMDI1NS80NDJhYmEwYzYxMzFmMGM0MWRmYzVlZGI2YmZiODgzMzU1NTY1MjNmL2RtZXNn
LXlvY3RvLWl2YjQxLTExODoyMDE0MDcxMDIzMzA0ODp4ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUv
NDQyYWJhMGM2MTMxZjBjNDFkZmM1ZWRiNmJmYjg4MzM1NTU2NTIzZi9kbWVzZy15b2N0by1p
dmI0MS0xMTk6MjAxNDA3MTAyMzMwNDg6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAy
NTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzQ0MmFiYTBj
NjEzMWYwYzQxZGZjNWVkYjZiZmI4ODMzNTU1NjUyM2YvZG1lc2cteW9jdG8taXZiNDEtMTc6
MjAxNDA3MTAyMzMwNDg6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzQ0MmFiYTBjNjEzMWYwYzQx
ZGZjNWVkYjZiZmI4ODMzNTU1NjUyM2YvZG1lc2cteW9jdG8taXZiNDEtMjM6MjAxNDA3MTAy
MzMwNDg6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzQ0MmFiYTBjNjEzMWYwYzQxZGZjNWVkYjZi
ZmI4ODMzNTU1NjUyM2YvZG1lc2cteW9jdG8taXZiNDEtNTI6MjAxNDA3MTAyMzMwNDg6eDg2
XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWhzeGEwLTA3MTEwMjU1LzQ0MmFiYTBjNjEzMWYwYzQxZGZjNWVkYjZiZmI4ODMzNTU1
NjUyM2YvZG1lc2cteW9jdG8taXZiNDEtMTAyOjIwMTQwNzEwMjMzMDUzOng4Nl82NC1yYW5k
Y29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MC0wNzExMDI1NS80NDJhYmEwYzYxMzFmMGM0MWRmYzVlZGI2YmZiODgzMzU1NTY1MjNmL2Rt
ZXNnLXlvY3RvLWl2YjQxLTEwNToyMDE0MDcxMDIzMzA1Mjp4ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAy
NTUvNDQyYWJhMGM2MTMxZjBjNDFkZmM1ZWRiNmJmYjg4MzM1NTU2NTIzZi9kbWVzZy15b2N0
by1pdmI0MS05NzoyMDE0MDcxMDIzMzA1Mzp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzEx
MDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvNDQyYWJh
MGM2MTMxZjBjNDFkZmM1ZWRiNmJmYjg4MzM1NTU2NTIzZi9kbWVzZy15b2N0by1pdmI0MS04
MToyMDE0MDcxMDIzMzA1Mzp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvNDQyYWJhMGM2MTMxZjBj
NDFkZmM1ZWRiNmJmYjg4MzM1NTU2NTIzZi9kbWVzZy15b2N0by1pdmI0MS0xMDM6MjAxNDA3
MTAyMzMxMDQ6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzQ0MmFiYTBjNjEzMWYwYzQxZGZjNWVk
YjZiZmI4ODMzNTU1NjUyM2YvZG1lc2cteW9jdG8taXZiNDEtNDM6MjAxNDA3MTAyMzMxMDQ6
eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWhzeGEwLTA3MTEwMjU1LzQ0MmFiYTBjNjEzMWYwYzQxZGZjNWVkYjZiZmI4ODMz
NTU1NjUyM2YvZG1lc2cteW9jdG8taXZiNDEtNDk6MjAxNDA3MTAyMzMwNTU6eDg2XzY0LXJh
bmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhz
eGEwLTA3MTEwMjU1LzQ0MmFiYTBjNjEzMWYwYzQxZGZjNWVkYjZiZmI4ODMzNTU1NjUyM2Yv
ZG1lc2cteW9jdG8taXZiNDEtNTc6MjAxNDA3MTAyMzMwNTQ6eDg2XzY0LXJhbmRjb25maWct
aHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEw
MjU1LzQ0MmFiYTBjNjEzMWYwYzQxZGZjNWVkYjZiZmI4ODMzNTU1NjUyM2YvZG1lc2cteW9j
dG8taXZiNDEtNToyMDE0MDcxMDIzMzA1NTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzEx
MDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvNDQyYWJh
MGM2MTMxZjBjNDFkZmM1ZWRiNmJmYjg4MzM1NTU2NTIzZi9kbWVzZy15b2N0by1pdmI0MS03
MToyMDE0MDcxMDIzMzA1NTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvNDQyYWJhMGM2MTMxZjBj
NDFkZmM1ZWRiNmJmYjg4MzM1NTU2NTIzZi9kbWVzZy15b2N0by1pdmI0MS03NzoyMDE0MDcx
MDIzMzEwNDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvNDQyYWJhMGM2MTMxZjBjNDFkZmM1ZWRi
NmJmYjg4MzM1NTU2NTIzZi9kbWVzZy15b2N0by1pdmI0MS04NToyMDE0MDcxMDIzMzA1Njp4
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaHN4YTAtMDcxMTAyNTUvNDQyYWJhMGM2MTMxZjBjNDFkZmM1ZWRiNmJmYjg4MzM1
NTU2NTIzZi9kbWVzZy15b2N0by1pdmI0MS04ODoyMDE0MDcxMDIzMzEwMTp4ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDcxMTAyNTUvNDQyYWJhMGM2MTMxZjBjNDFkZmM1ZWRiNmJmYjg4MzM1NTU2NTIzZi9k
bWVzZy15b2N0by1pdmI0MS0xNjoyMDE0MDcxMDIzMzEwNzp4ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMC0wNzExMDI1NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAy
NTUvNDQyYWJhMGM2MTMxZjBjNDFkZmM1ZWRiNmJmYjg4MzM1NTU2NTIzZi9kbWVzZy15b2N0
by1pdmI0MS0xMTI6MjAxNDA3MTAyMzMxMDg6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcx
MTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzQ0MmFi
YTBjNjEzMWYwYzQxZGZjNWVkYjZiZmI4ODMzNTU1NjUyM2YvZG1lc2cteW9jdG8taXZiNDEt
MTE6MjAxNDA3MTAyMzMxMDc6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LzQ0MmFiYTBjNjEzMWYw
YzQxZGZjNWVkYjZiZmI4ODMzNTU1NjUyM2YvZG1lc2cteW9jdG8taXZiNDEtMTI3OjIwMTQw
NzEwMjMzMTA3Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS80NDJhYmEwYzYxMzFmMGM0MWRmYzVl
ZGI2YmZiODgzMzU1NTY1MjNmL2RtZXNnLXlvY3RvLWl2YjQxLTIyOjIwMTQwNzEwMjMzMTA3
Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMC0wNzExMDI1NS80NDJhYmEwYzYxMzFmMGM0MWRmYzVlZGI2YmZiODgz
MzU1NTY1MjNmL2RtZXNnLXlvY3RvLWl2YjQxLTI3OjIwMTQwNzEwMjMzMTA3Ong4Nl82NC1y
YW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMC0wNzExMDI1NS80NDJhYmEwYzYxMzFmMGM0MWRmYzVlZGI2YmZiODgzMzU1NTY1MjNm
L2RtZXNnLXlvY3RvLWl2YjQxLTI4OjIwMTQwNzEwMjMzMTA4Ong4Nl82NC1yYW5kY29uZmln
LWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzEx
MDI1NS80NDJhYmEwYzYxMzFmMGM0MWRmYzVlZGI2YmZiODgzMzU1NTY1MjNmL2RtZXNnLXlv
Y3RvLWl2YjQxLTI5OjIwMTQwNzEwMjMzMTA4Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3
MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS80NDJh
YmEwYzYxMzFmMGM0MWRmYzVlZGI2YmZiODgzMzU1NTY1MjNmL2RtZXNnLXlvY3RvLWl2YjQx
LTMyOjIwMTQwNzEwMjMzMTA4Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS80NDJhYmEwYzYxMzFm
MGM0MWRmYzVlZGI2YmZiODgzMzU1NTY1MjNmL2RtZXNnLXlvY3RvLWl2YjQxLTM0OjIwMTQw
NzEwMjMzMTA3Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS80NDJhYmEwYzYxMzFmMGM0MWRmYzVl
ZGI2YmZiODgzMzU1NTY1MjNmL2RtZXNnLXlvY3RvLWl2YjQxLTM2OjIwMTQwNzEwMjMzMTE0
Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMC0wNzExMDI1NS80NDJhYmEwYzYxMzFmMGM0MWRmYzVlZGI2YmZiODgz
MzU1NTY1MjNmL2RtZXNnLXlvY3RvLWl2YjQxLTQ0OjIwMTQwNzEwMjMzMTA5Ong4Nl82NC1y
YW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMC0wNzExMDI1NS80NDJhYmEwYzYxMzFmMGM0MWRmYzVlZGI2YmZiODgzMzU1NTY1MjNm
L2RtZXNnLXlvY3RvLWl2YjQxLTQ3OjIwMTQwNzEwMjMzMTA4Ong4Nl82NC1yYW5kY29uZmln
LWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzEx
MDI1NS80NDJhYmEwYzYxMzFmMGM0MWRmYzVlZGI2YmZiODgzMzU1NTY1MjNmL2RtZXNnLXlv
Y3RvLWl2YjQxLTUwOjIwMTQwNzEwMjMzMTA4Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3
MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS80NDJh
YmEwYzYxMzFmMGM0MWRmYzVlZGI2YmZiODgzMzU1NTY1MjNmL2RtZXNnLXlvY3RvLWl2YjQx
LTUzOjIwMTQwNzEwMjMzMTE0Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS80NDJhYmEwYzYxMzFm
MGM0MWRmYzVlZGI2YmZiODgzMzU1NTY1MjNmL2RtZXNnLXlvY3RvLWl2YjQxLTg5OjIwMTQw
NzEwMjMzMTE0Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS80NDJhYmEwYzYxMzFmMGM0MWRmYzVl
ZGI2YmZiODgzMzU1NTY1MjNmL2RtZXNnLXlvY3RvLWl2YjQxLTkzOjIwMTQwNzEwMjMzMTE0
Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMC0wNzExMDI1NS80NDJhYmEwYzYxMzFmMGM0MWRmYzVlZGI2YmZiODgz
MzU1NTY1MjNmL2RtZXNnLXlvY3RvLWl2YjQxLTk6MjAxNDA3MTAyMzMxMDg6eDg2XzY0LXJh
bmRjb25maWctaHN4YTAtMDcxMTAyNTU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhz
eGEwLTA3MTEwMjU1LzQ0MmFiYTBjNjEzMWYwYzQxZGZjNWVkYjZiZmI4ODMzNTU1NjUyM2Yv
ZG1lc2cteW9jdG8taXZiNDEtMTExOjIwMTQwNzEwMjMzMTIwOng4Nl82NC1yYW5kY29uZmln
LWhzeGEwLTA3MTEwMjU1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzEx
MDI1NS80NDJhYmEwYzYxMzFmMGM0MWRmYzVlZGI2YmZiODgzMzU1NTY1MjNmL2RtZXNnLXlv
Y3RvLXZwLTQwOjIwMTQwNzEwMjMzMTUzOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEw
MjU1OjMuMTYuMC1yYzMtMDAwMTAtZzQ0MmFiYTA6NAova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWhzeGEwLTA3MTEwMjU1LzQ0MmFiYTBjNjEzMWYwYzQxZGZjNWVkYjZiZmI4ODMzNTU1
NjUyM2YvZG1lc2cteW9jdG8tdnAtNTQ6MjAxNDA3MTAyMzMxNTQ6eDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDcxMTAyNTU6My4xNi4wLXJjMy0wMDAxMC1nNDQyYWJhMDo0CjA6Mzk6Mzcg
YWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCjQ0MmFiYTBjNjEzMWYwYzQxZGZjNWVkYjZi
ZmI4ODMzNTU1NjUyM2YgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQKY29tbWl0IDQ0MmFiYTBj
NjEzMWYwYzQxZGZjNWVkYjZiZmI4ODMzNTU1NjUyM2YKQXV0aG9yOiBBbmR5IEx1dG9taXJz
a2kgPGx1dG9AYW1hY2FwaXRhbC5uZXQ+CkRhdGU6ICAgTW9uIEp1biAxNiAxODo1MDoxMiAy
MDE0IC0wNzAwCgogICAgeDg2XzY0LHZzeXNjYWxsOiBNYWtlIHZzeXNjYWxsIGVtdWxhdGlv
biBjb25maWd1cmFibGUKICAgIAogICAgVGhpcyBhZGRzIENPTkZJR19YODZfVlNZU0NBTExf
RU1VTEFUSU9OLCBndWFyZGVkIGJ5IENPTkZJR19FWFBFUlQuCiAgICBUdXJuaW5nIGl0IG9m
ZiBjb21wbGV0ZWx5IGRpc2FibGVzIHZzeXNjYWxsIGVtdWxhdGlvbiwgc2F2aW5nIH4zLjVr
CiAgICBmb3IgdnN5c2NhbGxfNjQuYywgNGsgZm9yIHZzeXNjYWxsX2VtdV82NC5TICh0aGUg
ZmFrZSB2c3lzY2FsbAogICAgcGFnZSksIHNvbWUgdGlueSBhbW91bnQgb2YgY29yZSBtbSBj
b2RlIHRoYXQgc3VwcG9ydHMgYSBnYXRlIGFyZWEsCiAgICBhbmQgcG9zc2libHkgNGsgZm9y
IGEgd2FzdGVkIHBhZ2V0YWJsZS4gIFRoZSBsYXR0ZXIgaXMgYmVjYXVzZSB0aGUKICAgIHZz
eXNjYWxsIGFkZHJlc3NlcyBhcmUgbWlzYWxpZ25lZCBhbmQgZml0IHBvb3JseSBpbiB0aGUg
Zml4bWFwLgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBBbmR5IEx1dG9taXJza2kgPGx1dG9A
YW1hY2FwaXRhbC5uZXQ+Cgo6MDQwMDAwIDA0MDAwMCBkMTlhZWM4NGQ2ODkxM2ZhMjlhNTlk
MGM5ZTg2YzMxZDcxY2FmM2MyIGQzYmQ1NTFhNGNiMmNiN2MwMzRjYWU4YzM3MmUxZjdkZGJh
MDVjNWUgTQlhcmNoCmJpc2VjdCBydW4gc3VjY2VzcwpQcmV2aW91cyBIRUFEIHBvc2l0aW9u
IHdhcyA0NDJhYmEwLi4uIHg4Nl82NCx2c3lzY2FsbDogTWFrZSB2c3lzY2FsbCBlbXVsYXRp
b24gY29uZmlndXJhYmxlCkhFQUQgaXMgbm93IGF0IGUxNjU2YWIuLi4gYXJtNjQsaWE2NCxw
cGMsczM5MCxzaCx0aWxlLHVtLHg4NixtbTogUmVtb3ZlIGRlZmF1bHQgZ2F0ZSBhcmVhCmxz
IC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MC0wNzExMDI1NS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA3MTAxODplMTY1NmFi
MmFkZmQxODkxZjYyNjEwYWJlM2U4NWFkOTkyZWUwY2JmOmJpc2VjdC1saW51eDkKCjIwMTQt
MDctMTAtMjM6MzE6NTQgZTE2NTZhYjJhZGZkMTg5MWY2MjYxMGFiZTNlODVhZDk5MmVlMGNi
ZiByZXVzZSAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1L2UxNjU2
YWIyYWRmZDE4OTFmNjI2MTBhYmUzZTg1YWQ5OTJlZTBjYmYvdm1saW51ei0zLjE2LjAtcmMz
LTAwMDA5LWdlMTY1NmFiCgoyMDE0LTA3LTEwLTIzOjMxOjU1IGRldGVjdGluZyBib290IHN0
YXRlIC4uLgkzNAkxMzMJMTgzCTE4NAkyMjgJMzUxCTM3OQkzODUJNDQ4CTU2NAk1NzQJNTkw
CTYwMQk2NDMJNzU2CTc3OQk4NDIuCTg5MAk5NjYuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uCTk4Mwk5OTAgU1VDQ0VTUwoKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgZTE2
NTZhYi4uLiBhcm02NCxpYTY0LHBwYyxzMzkwLHNoLHRpbGUsdW0seDg2LG1tOiBSZW1vdmUg
ZGVmYXVsdCBnYXRlIGFyZWEKSEVBRCBpcyBub3cgYXQgYzgwYmUzYS4uLiAwZGF5IGhlYWQg
Z3VhcmQgZm9yICdkZXZlbC1ob3VybHktMjAxNDA3MTAxOCcKbHMgLWEgL2tidWlsZC10ZXN0
cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1L2xpbnV4
LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDcxMDE4OmM4MGJlM2FlMTE3NzAwMTEwNzExMDNk
M2U5MjA4NjRjMjc1NDcyYTg6YmlzZWN0LWxpbnV4OQogVEVTVCBGQUlMVVJFClsgICAyOC44
ODgxMTNdIHVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2ZXIgdXNoYwpb
ICAgMjguODg4MTEzXSB1c2Jjb3JlOiByZWdpc3RlcmVkIG5ldyBpbnRlcmZhY2UgZHJpdmVy
IHVzaGMKCkJVRzoga2VybmVsIGJvb3QgaGFuZwpFbGFwc2VkIHRpbWU6IDQwCnFlbXUtc3lz
dGVtLXg4Nl82NCAtY3B1IGt2bTY0IC1lbmFibGUta3ZtIC1rZXJuZWwgL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS9jODBiZTNhZTExNzcwMDExMDcxMTAzZDNl
OTIwODY0YzI3NTQ3MmE4L3ZtbGludXotMy4xNi4wLXJjNC0wMDgyNS1nYzgwYmUzYSAtYXBw
ZW5kICdodW5nX3Rhc2tfcGFuaWM9MSBlYXJseXByaW50az10dHlTMCwxMTUyMDAgZGVidWcg
YXBpYz1kZWJ1ZyBzeXNycV9hbHdheXNfZW5hYmxlZCByY3VwZGF0ZS5yY3VfY3B1X3N0YWxs
X3RpbWVvdXQ9MTAwIHBhbmljPTEwIHNvZnRsb2NrdXBfcGFuaWM9MSBubWlfd2F0Y2hkb2c9
cGFuaWMgIHByb21wdF9yYW1kaXNrPTAgY29uc29sZT10dHlTMCwxMTUyMDAgY29uc29sZT10
dHkwIHZnYT1ub3JtYWwgIHJvb3Q9L2Rldi9yYW0wIHJ3IGxpbms9L2tidWlsZC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1L2xpbnV4LWRl
dmVsOmRldmVsLWhvdXJseS0yMDE0MDcxMDE4OmM4MGJlM2FlMTE3NzAwMTEwNzExMDNkM2U5
MjA4NjRjMjc1NDcyYTg6YmlzZWN0LWxpbnV4OS8udm1saW51ei1jODBiZTNhZTExNzcwMDEx
MDcxMTAzZDNlOTIwODY0YzI3NTQ3MmE4LTIwMTQwNzEwMTk0MDUzLTYtdnAgYnJhbmNoPWxp
bnV4LWRldmVsL2RldmVsLWhvdXJseS0yMDE0MDcxMDE4IEJPT1RfSU1BR0U9L2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS9jODBiZTNhZTExNzcwMDExMDcxMTAz
ZDNlOTIwODY0YzI3NTQ3MmE4L3ZtbGludXotMy4xNi4wLXJjNC0wMDgyNS1nYzgwYmUzYSBk
cmJkLm1pbm9yX2NvdW50PTgnICAtaW5pdHJkIC9rZXJuZWwtdGVzdHMvaW5pdHJkL3F1YW50
YWwtY29yZS14ODZfNjQuY2d6IC1tIDMyMCAtc21wIDIgLW5ldCBuaWMsdmxhbj0xLG1vZGVs
PWUxMDAwIC1uZXQgdXNlcix2bGFuPTEgLWJvb3Qgb3JkZXI9bmMgLW5vLXJlYm9vdCAtd2F0
Y2hkb2cgaTYzMDBlc2IgLXJ0YyBiYXNlPWxvY2FsdGltZSAtZHJpdmUgZmlsZT0vZnMvTEFC
RUw9S1ZNL2Rpc2swLXF1YW50YWwtdnAtMTgsbWVkaWE9ZGlzayxpZj12aXJ0aW8gLWRyaXZl
IGZpbGU9L2ZzL0xBQkVMPUtWTS9kaXNrMS1xdWFudGFsLXZwLTE4LG1lZGlhPWRpc2ssaWY9
dmlydGlvIC1kcml2ZSBmaWxlPS9mcy9MQUJFTD1LVk0vZGlzazItcXVhbnRhbC12cC0xOCxt
ZWRpYT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMvTEFCRUw9S1ZNL2Rpc2szLXF1
YW50YWwtdnAtMTgsbWVkaWE9ZGlzayxpZj12aXJ0aW8gLWRyaXZlIGZpbGU9L2ZzL0xBQkVM
PUtWTS9kaXNrNC1xdWFudGFsLXZwLTE4LG1lZGlhPWRpc2ssaWY9dmlydGlvIC1kcml2ZSBm
aWxlPS9mcy9MQUJFTD1LVk0vZGlzazUtcXVhbnRhbC12cC0xOCxtZWRpYT1kaXNrLGlmPXZp
cnRpbyAtcGlkZmlsZSAvZGV2L3NobS9rYm9vdC9waWQtcXVhbnRhbC12cC0xOCAtc2VyaWFs
IGZpbGU6L2Rldi9zaG0va2Jvb3Qvc2VyaWFsLXF1YW50YWwtdnAtMTggLWRhZW1vbml6ZSAt
ZGlzcGxheSBub25lIC1tb25pdG9yIG51bGwgCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
aHN4YTAtMDcxMTAyNTUvYzgwYmUzYWUxMTc3MDAxMTA3MTEwM2QzZTkyMDg2NGMyNzU0NzJh
OC9kbWVzZy15b2N0by12cC0zOjIwMTQwNzEwMTk0MjM3Ong4Nl82NC1yYW5kY29uZmlnLWhz
eGEwLTA3MTEwMjU1OjMuMTYuMC1yYzQtMDA4MjUtZ2M4MGJlM2E6MTkKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS9jODBiZTNhZTExNzcwMDExMDcxMTAzZDNl
OTIwODY0YzI3NTQ3MmE4L2RtZXNnLXlvY3RvLXZwLTIyOjIwMTQwNzEwMTk0MjI2Ong4Nl82
NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1OjMuMTYuMC1yYzQtMDA4MjUtZ2M4MGJlM2E6
MTkKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNzExMDI1NS9jODBiZTNhZTEx
NzcwMDExMDcxMTAzZDNlOTIwODY0YzI3NTQ3MmE4L2RtZXNnLXlvY3RvLXZwLTY6MjAxNDA3
MTAxOTQyMzM6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6My4xNi4wLXJjNC0w
MDgyNS1nYzgwYmUzYToxOQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEw
MjU1L2M4MGJlM2FlMTE3NzAwMTEwNzExMDNkM2U5MjA4NjRjMjc1NDcyYTgvZG1lc2cteW9j
dG8tdnAtNDk6MjAxNDA3MTAxOTM2NTg6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAy
NTU6My4xNi4wLXJjNC0wMDgyNS1nYzgwYmUzYToxOQova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWhzeGEwLTA3MTEwMjU1L2M4MGJlM2FlMTE3NzAwMTEwNzExMDNkM2U5MjA4NjRjMjc1
NDcyYTgvZG1lc2cteW9jdG8tdnAtNTY6MjAxNDA3MTAxOTQyMjg6eDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDcxMTAyNTU6My4xNi4wLXJjNC0wMDgyNS1nYzgwYmUzYToxOQova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1L2M4MGJlM2FlMTE3NzAwMTEwNzEx
MDNkM2U5MjA4NjRjMjc1NDcyYTgvZG1lc2cteW9jdG8tdnAtMjE6MjAxNDA3MTAxOTQyMzg6
eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTU6My4xNi4wLXJjNC0wMDgyNS1nYzgw
YmUzYToxOQozOjY6OCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKSEVBRCBpcyBub3cg
YXQgYzgwYmUzYSAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1ob3VybHktMjAxNDA3MTAx
OCcKCj09PT09PT09PSB1cHN0cmVhbSA9PT09PT09PT0KRnJvbSBnaXQ6Ly9naXRtaXJyb3Iv
bGludXMKICAgNGY0NDBjZC4uODVkOTBmYSAgbWFzdGVyICAgICAtPiBsaW51cy9tYXN0ZXIK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgYzgwYmUzYS4uLiAwZGF5IGhlYWQgZ3VhcmQg
Zm9yICdkZXZlbC1ob3VybHktMjAxNDA3MTAxOCcKSEVBRCBpcyBub3cgYXQgODVkOTBmYS4u
LiBNZXJnZSBicmFuY2ggJ2RybS1maXhlcycgb2YgZ2l0Oi8vcGVvcGxlLmZyZWVkZXNrdG9w
Lm9yZy9+YWlybGllZC9saW51eApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvbGludXM6bWFzdGVyOjg1ZDkwZmFl
ZDMxZWM3NGZiMjhhNDUwZmJjMzY4ZDk4MmE3ODU5MjQ6YmlzZWN0LWxpbnV4OQoKMjAxNC0w
Ny0xMS0xMjoxMTowOSA4NWQ5MGZhZWQzMWVjNzRmYjI4YTQ1MGZiYzM2OGQ5ODJhNzg1OTI0
IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LTg1ZDkwZmFlZDMxZWM3NGZi
MjhhNDUwZmJjMzY4ZDk4MmE3ODU5MjQKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1Lzg1ZDkwZmFlZDMxZWM3NGZiMjhhNDUw
ZmJjMzY4ZDk4MmE3ODU5MjQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1LTg1ZDkw
ZmFlZDMxZWM3NGZiMjhhNDUwZmJjMzY4ZDk4MmE3ODU5MjQKa2VybmVsOiAva2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA3MTEwMjU1Lzg1ZDkwZmFlZDMxZWM3NGZiMjhhNDUw
ZmJjMzY4ZDk4MmE3ODU5MjQvdm1saW51ei0zLjE2LjAtcmM0LTAwMTIwLWc4NWQ5MGZhCgoy
MDE0LTA3LTExLTEyOjEzOjA5IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4JMQkxMQkxMwkzMAk1MAk2NwkxMDMJMTE3CTEyOS4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkxMzAJMTM2CTE1MgkxNzQJMTkyCTE5My4u
Li4uLi4uCTIxNQkyNDcJMjg4CTMzNwkzNzMJMzk5CTQxNQk0ODkJNTEzCTU1NQk2MDMJNjI0
CTY1OQk2NzcJNzA1CTczMgk3NDQJNzczCTc4OQk4ODMJOTA2CTkyNAk5NjUJOTY2CTk4Mwk5
OTAgU1VDQ0VTUwoKCj09PT09PT09PSBsaW51eC1uZXh0ID09PT09PT09PQpGcm9tIGdpdDov
L2dpdG1pcnJvci9uZXh0CiArIGExZTNkZDEuLi4wNzRiZTU2IGFrcG0gICAgICAgLT4gbmV4
dC9ha3BtICAoZm9yY2VkIHVwZGF0ZSkKICsgOTJmNjg4Ni4uLjJjOTY5MTcgYWtwbS1iYXNl
ICAtPiBuZXh0L2FrcG0tYmFzZSAgKGZvcmNlZCB1cGRhdGUpCiArIGQ1ODRmMmEuLi40N2Nm
MGNlIG1hc3RlciAgICAgLT4gbmV4dC9tYXN0ZXIgIChmb3JjZWQgdXBkYXRlKQogICBjZDNk
ZTgzLi40ZjQ0MGNkICBzdGFibGUgICAgIC0+IG5leHQvc3RhYmxlCkZyb20gZ2l0Oi8vZ2l0
bWlycm9yL25leHQKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDcwOCAtPiBuZXh0
LTIwMTQwNzA4CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDA3MDkgLT4gbmV4dC0y
MDE0MDcwOQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwNzEwIC0+IG5leHQtMjAx
NDA3MTAKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgODVkOTBmYS4uLiBNZXJnZSBicmFu
Y2ggJ2RybS1maXhlcycgb2YgZ2l0Oi8vcGVvcGxlLmZyZWVkZXNrdG9wLm9yZy9+YWlybGll
ZC9saW51eApIRUFEIGlzIG5vdyBhdCA0N2NmMGNlLi4uIEFkZCBsaW51eC1uZXh0IHNwZWNp
ZmljIGZpbGVzIGZvciAyMDE0MDcxMApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9r
dm0veDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvbmV4dDptYXN0ZXI6NDdjZjBj
ZTk0NWM4MzEwMjI4ZmYyZDRiZDc1NmU1MzEzZjQ2NTljMTpiaXNlY3QtbGludXg5CgoyMDE0
LTA3LTExLTEzOjEyOjUxIDQ3Y2YwY2U5NDVjODMxMDIyOGZmMmQ0YmQ3NTZlNTMxM2Y0NjU5
YzEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUtNDdjZjBjZTk0NWM4MzEw
MjI4ZmYyZDRiZDc1NmU1MzEzZjQ2NTljMQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvNDdjZjBjZTk0NWM4MzEwMjI4ZmYy
ZDRiZDc1NmU1MzEzZjQ2NTljMQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUtNDdj
ZjBjZTk0NWM4MzEwMjI4ZmYyZDRiZDc1NmU1MzEzZjQ2NTljMQprZXJuZWw6IC9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDcxMTAyNTUvNDdjZjBjZTk0NWM4MzEwMjI4ZmYy
ZDRiZDc1NmU1MzEzZjQ2NTljMS92bWxpbnV6LTMuMTYuMC1yYzQtbmV4dC0yMDE0MDcxMAoK
MjAxNC0wNy0xMS0xMzoxNDo1MiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJNjkJODkJMTQxCTIw
NgkyNDAJMzAxCTM5OQk0NjUJNjM3CTY4Mgk3OTkJODA5CTg3Nwk5OTAgU1VDQ0VTUwoK

--0WGqsT62A4RTsSXf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.16.0-rc3-00010-g442aba0"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.16.0-rc3 Kernel Configuration
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
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
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
CONFIG_KERNEL_LZO=y
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
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
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
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
# CONFIG_TICK_CPU_ACCOUNTING is not set
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_STALL_COMMON is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_CGROUPS is not set
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
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
# CONFIG_EVENTFD is not set
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
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_PROFILING=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
# CONFIG_UPROBES is not set
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
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
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
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
# CONFIG_ACORN_PARTITION_ADFS is not set
CONFIG_ACORN_PARTITION_POWERTEC=y
CONFIG_ACORN_PARTITION_RISCIX=y
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
# CONFIG_MSDOS_PARTITION is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
# CONFIG_GART_IOMMU is not set
CONFIG_CALGARY_IOMMU=y
# CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
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
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
# CONFIG_X86_VSYSCALL_EMULATION is not set
CONFIG_I8K=y
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
# CONFIG_ARCH_MEMORY_PROBE is not set
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSWAP is not set
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_EXTLOG is not set
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
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
CONFIG_PCIEAER_INJECT=y
# CONFIG_PCIEASPM is not set
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_PRI=y
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
# CONFIG_ISA_DMA_API is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PD6729=y
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_X86_X32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_IOSF_MBI=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_USER is not set
CONFIG_XFRM_SUB_POLICY=y
# CONFIG_XFRM_MIGRATE is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=y
# CONFIG_IP_ROUTE_MULTIPATH is not set
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=y
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
CONFIG_INET_XFRM_MODE_TUNNEL=y
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
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
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
CONFIG_INET6_IPCOMP=y
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_BEET=y
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
CONFIG_IPV6_SIT=y
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_GRE=y
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
# CONFIG_IPV6_MROUTE_MULTIPLE_TABLES is not set
# CONFIG_IPV6_PIMSM_V2 is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
# CONFIG_NETFILTER_NETLINK_LOG is not set
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_FTP=y
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_BROADCAST=y
CONFIG_NF_CONNTRACK_NETBIOS_NS=y
CONFIG_NF_CONNTRACK_SIP=y
# CONFIG_NF_CT_NETLINK is not set
CONFIG_NF_TABLES=y
CONFIG_NF_TABLES_INET=y
CONFIG_NFT_EXTHDR=y
CONFIG_NFT_META=y
CONFIG_NFT_CT=y
CONFIG_NFT_RBTREE=y
# CONFIG_NFT_HASH is not set
# CONFIG_NFT_COUNTER is not set
CONFIG_NFT_LOG=y
CONFIG_NFT_LIMIT=y
CONFIG_NFT_REJECT=y
CONFIG_NFT_REJECT_INET=y
# CONFIG_NETFILTER_XTABLES is not set
# CONFIG_IP_SET is not set
CONFIG_IP_VS=y
# CONFIG_IP_VS_IPV6 is not set
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
# CONFIG_IP_VS_PROTO_UDP is not set
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
# CONFIG_IP_VS_PROTO_AH is not set
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
# CONFIG_IP_VS_RR is not set
CONFIG_IP_VS_WRR=y
CONFIG_IP_VS_LC=y
# CONFIG_IP_VS_WLC is not set
# CONFIG_IP_VS_LBLC is not set
CONFIG_IP_VS_LBLCR=y
CONFIG_IP_VS_DH=y
CONFIG_IP_VS_SH=y
# CONFIG_IP_VS_SED is not set
CONFIG_IP_VS_NQ=y

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#
CONFIG_IP_VS_NFCT=y

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_TABLES_IPV4=y
CONFIG_NFT_CHAIN_ROUTE_IPV4=y
CONFIG_NFT_REJECT_IPV4=y
CONFIG_NF_TABLES_ARP=y
# CONFIG_IP_NF_IPTABLES is not set

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=y
CONFIG_NF_CONNTRACK_IPV6=y
CONFIG_NF_TABLES_IPV6=y
# CONFIG_NFT_CHAIN_ROUTE_IPV6 is not set
CONFIG_NFT_REJECT_IPV6=y
# CONFIG_IP6_NF_IPTABLES is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_COOKIE_HMAC_SHA1 is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
CONFIG_ATM_CLIP_NO_ICMP=y
CONFIG_ATM_LANE=y
# CONFIG_ATM_MPOA is not set
# CONFIG_ATM_BR2684 is not set
CONFIG_L2TP=y
CONFIG_L2TP_DEBUGFS=y
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=y
# CONFIG_L2TP_ETH is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_MRP=y
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
# CONFIG_IPDDP is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
CONFIG_PHONET=y
# CONFIG_IEEE802154 is not set
CONFIG_6LOWPAN_IPHC=y
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
# CONFIG_NETLINK_DIAG is not set
CONFIG_NET_MPLS_GSO=y
CONFIG_HSR=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
CONFIG_IRNET=y
# CONFIG_IRCOMM is not set
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
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
# CONFIG_KINGSUN_DONGLE is not set
CONFIG_KSDAZZLE_DONGLE=y
CONFIG_KS959_DONGLE=y

#
# FIR device drivers
#
CONFIG_USB_IRDA=y
CONFIG_SIGMATEL_FIR=y
CONFIG_VLSI_FIR=y
CONFIG_MCS_FIR=y
CONFIG_BT=y
CONFIG_BT_6LOWPAN=y
CONFIG_BT_RFCOMM=y
# CONFIG_BT_RFCOMM_TTY is not set
CONFIG_BT_BNEP=y
CONFIG_BT_BNEP_MC_FILTER=y
# CONFIG_BT_BNEP_PROTO_FILTER is not set
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
CONFIG_BT_HCIBTSDIO=y
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIBCM203X=y
# CONFIG_BT_HCIBPA10X is not set
CONFIG_BT_HCIBFUSB=y
CONFIG_BT_HCIDTL1=y
CONFIG_BT_HCIBT3C=y
CONFIG_BT_HCIBLUECARD=y
# CONFIG_BT_HCIBTUART is not set
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
# CONFIG_BT_MRVL_SDIO is not set
CONFIG_BT_ATH3K=y
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
# CONFIG_RXKAD is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
# CONFIG_CFG80211 is not set
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
CONFIG_LIB80211_DEBUG=y

#
# CFG80211 needs to be enabled for MAC80211
#
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
CONFIG_RFKILL_REGULATOR=y
# CONFIG_NET_9P is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=y
CONFIG_CAIF_USB=y
CONFIG_CEPH_LIB=y
CONFIG_CEPH_LIB_PRETTYDEBUG=y
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
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
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_DMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_PERCENTAGE=10
# CONFIG_CMA_SIZE_SEL_MBYTES is not set
CONFIG_CMA_SIZE_SEL_PERCENTAGE=y
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
# CONFIG_MTD is not set
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_PC_PCMCIA=y
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=y
# CONFIG_PARIDE is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
# CONFIG_ZRAM is not set
CONFIG_BLK_CPQ_CISS_DA=y
CONFIG_BLK_DEV_DAC960=y
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=y

#
# DRBD disabled because PROC_FS or INET not selected
#
CONFIG_BLK_DEV_NBD=y
# CONFIG_BLK_DEV_NVME is not set
CONFIG_BLK_DEV_SKD=y
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
CONFIG_BLK_DEV_RSXX=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_AD525X_DPOT_SPI=y
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=y
# CONFIG_PHANTOM is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_HP_ILO=y
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=y
CONFIG_ISL29020=y
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=y
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_BMP085_SPI is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_LATTICE_ECP3_CONFIG is not set
CONFIG_SRAM=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_AT25=y
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
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
CONFIG_ALTERA_STAPL=y
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
CONFIG_INTEL_MEI_TXE=y
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#
CONFIG_INTEL_MIC_HOST=y

#
# Intel MIC Card Driver
#
CONFIG_INTEL_MIC_CARD=y
# CONFIG_GENWQE is not set
CONFIG_ECHO=y
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

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_ENCLOSURE=y
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
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_SRP_TGT_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
CONFIG_ISCSI_BOOT_SYSFS=y
# CONFIG_SCSI_CXGB3_ISCSI is not set
CONFIG_SCSI_CXGB4_ISCSI=y
# CONFIG_SCSI_BNX2_ISCSI is not set
CONFIG_SCSI_BNX2X_FCOE=y
CONFIG_BE2ISCSI=y
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
CONFIG_SCSI_HPSA=y
CONFIG_SCSI_3W_9XXX=y
CONFIG_SCSI_3W_SAS=y
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_BUILD_FIRMWARE is not set
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC79XX is not set
CONFIG_SCSI_AIC94XX=y
CONFIG_AIC94XX_DEBUG=y
# CONFIG_SCSI_MVSAS is not set
CONFIG_SCSI_MVUMI=y
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
CONFIG_SCSI_ARCMSR=y
CONFIG_SCSI_ESAS2R=y
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS_LOGGING=y
CONFIG_SCSI_MPT3SAS=y
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
# CONFIG_SCSI_MPT3SAS_LOGGING is not set
CONFIG_SCSI_UFSHCD=y
CONFIG_SCSI_UFSHCD_PCI=y
# CONFIG_SCSI_UFSHCD_PLATFORM is not set
CONFIG_SCSI_HPTIOP=y
CONFIG_VMWARE_PVSCSI=y
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
# CONFIG_FCOE is not set
CONFIG_FCOE_FNIC=y
CONFIG_SCSI_DMX3191D=y
CONFIG_SCSI_FUTURE_DOMAIN=y
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
CONFIG_SCSI_IMM=y
CONFIG_SCSI_IZIP_EPP16=y
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
CONFIG_SCSI_IPR=y
# CONFIG_SCSI_IPR_TRACE is not set
# CONFIG_SCSI_IPR_DUMP is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=y
CONFIG_SCSI_QLA_ISCSI=y
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_DC395x=y
CONFIG_SCSI_DC390T=y
CONFIG_SCSI_DEBUG=y
CONFIG_SCSI_PMCRAID=y
# CONFIG_SCSI_PM8001 is not set
CONFIG_SCSI_SRP=y
CONFIG_SCSI_BFA_FC=y
CONFIG_SCSI_VIRTIO=y
CONFIG_SCSI_CHELSIO_FCOE=y
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
# CONFIG_SCSI_DH_EMC is not set
# CONFIG_SCSI_DH_ALUA is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
CONFIG_SATA_AHCI_PLATFORM=y
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
CONFIG_SATA_SIL24=y
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
# CONFIG_MD_MULTIPATH is not set
CONFIG_MD_FAULTY=y
CONFIG_BCACHE=y
# CONFIG_BCACHE_DEBUG is not set
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=y
CONFIG_DM_BIO_PRISON=y
CONFIG_DM_PERSISTENT_DATA=y
CONFIG_DM_DEBUG_BLOCK_STACK_TRACING=y
CONFIG_DM_CRYPT=y
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_THIN_PROVISIONING is not set
CONFIG_DM_CACHE=y
# CONFIG_DM_CACHE_MQ is not set
CONFIG_DM_CACHE_CLEANER=y
# CONFIG_DM_ERA is not set
CONFIG_DM_MIRROR=y
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_RAID=y
# CONFIG_DM_ZERO is not set
CONFIG_DM_MULTIPATH=y
CONFIG_DM_MULTIPATH_QL=y
CONFIG_DM_MULTIPATH_ST=y
CONFIG_DM_DELAY=y
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=y
CONFIG_DM_VERITY=y
# CONFIG_DM_SWITCH is not set
# CONFIG_TARGET_CORE is not set
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
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
# CONFIG_I2O_EXT_ADAPTEC_DMA64 is not set
CONFIG_I2O_CONFIG=y
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
CONFIG_I2O_BUS=y
CONFIG_I2O_BLOCK=y
# CONFIG_I2O_SCSI is not set
# CONFIG_I2O_PROC is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
CONFIG_BONDING=y
CONFIG_DUMMY=y
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
CONFIG_NET_TEAM=y
CONFIG_NET_TEAM_MODE_BROADCAST=y
# CONFIG_NET_TEAM_MODE_ROUNDROBIN is not set
# CONFIG_NET_TEAM_MODE_RANDOM is not set
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=y
# CONFIG_NET_TEAM_MODE_LOADBALANCE is not set
CONFIG_MACVLAN=y
CONFIG_MACVTAP=y
CONFIG_VXLAN=y
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_NTB_NETDEV is not set
CONFIG_TUN=y
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=y
# CONFIG_NLMON is not set
CONFIG_SUNGEM_PHY=y
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
CONFIG_VHOST_RING=y

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_ETHERNET=y
CONFIG_MDIO=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_PCMCIA_3C574=y
CONFIG_PCMCIA_3C589=y
CONFIG_VORTEX=y
CONFIG_TYPHOON=y
# CONFIG_NET_VENDOR_ADAPTEC is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
CONFIG_PCNET32=y
# CONFIG_PCMCIA_NMCLAN is not set
# CONFIG_NET_VENDOR_ARC is not set
# CONFIG_NET_VENDOR_ATHEROS is not set
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=y
CONFIG_CNIC=y
CONFIG_TIGON3=y
CONFIG_BNX2X=y
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_CALXEDA_XGMAC=y
CONFIG_NET_VENDOR_CHELSIO=y
CONFIG_CHELSIO_T1=y
# CONFIG_CHELSIO_T1_1G is not set
# CONFIG_CHELSIO_T3 is not set
CONFIG_CHELSIO_T4=y
CONFIG_CHELSIO_T4VF=y
# CONFIG_NET_VENDOR_CISCO is not set
CONFIG_CX_ECAT=y
CONFIG_DNET=y
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
# CONFIG_NET_VENDOR_DLINK is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=y
CONFIG_BE2NET_VXLAN=y
CONFIG_NET_VENDOR_EXAR=y
CONFIG_S2IO=y
CONFIG_VXGE=y
# CONFIG_VXGE_DEBUG_TRACE_ALL is not set
CONFIG_NET_VENDOR_FUJITSU=y
CONFIG_PCMCIA_FMVJ18X=y
CONFIG_NET_VENDOR_HP=y
CONFIG_HP100=y
# CONFIG_NET_VENDOR_INTEL is not set
CONFIG_IP1000=y
# CONFIG_JME is not set
# CONFIG_NET_VENDOR_MARVELL is not set
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_EN=y
CONFIG_MLX4_EN_VXLAN=y
CONFIG_MLX4_CORE=y
CONFIG_MLX4_DEBUG=y
CONFIG_MLX5_CORE=y
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8842=y
CONFIG_KS8851=y
# CONFIG_KS8851_MLL is not set
CONFIG_KSZ884X_PCI=y
# CONFIG_NET_VENDOR_MICROCHIP is not set
# CONFIG_NET_VENDOR_MYRI is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NATSEMI=y
CONFIG_NS83820=y
# CONFIG_NET_VENDOR_8390 is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_ETHOC=y
# CONFIG_NET_PACKET_ENGINE is not set
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=y
CONFIG_QLCNIC=y
# CONFIG_QLCNIC_VXLAN is not set
# CONFIG_QLCNIC_HWMON is not set
CONFIG_QLGE=y
CONFIG_NETXEN_NIC=y
# CONFIG_NET_VENDOR_REALTEK is not set
CONFIG_SH_ETH=y
CONFIG_NET_VENDOR_RDC=y
CONFIG_R6040=y
# CONFIG_NET_VENDOR_SAMSUNG is not set
# CONFIG_NET_VENDOR_SEEQ is not set
CONFIG_NET_VENDOR_SILAN=y
CONFIG_SC92031=y
# CONFIG_NET_VENDOR_SIS is not set
CONFIG_SFC=y
# CONFIG_SFC_MCDI_MON is not set
CONFIG_NET_VENDOR_SMSC=y
CONFIG_PCMCIA_SMC91C92=y
CONFIG_EPIC100=y
# CONFIG_SMSC911X is not set
CONFIG_SMSC9420=y
# CONFIG_NET_VENDOR_STMICRO is not set
CONFIG_NET_VENDOR_SUN=y
CONFIG_HAPPYMEAL=y
CONFIG_SUNGEM=y
CONFIG_CASSINI=y
CONFIG_NIU=y
CONFIG_NET_VENDOR_TEHUTI=y
CONFIG_TEHUTI=y
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
CONFIG_WIZNET_W5300=y
# CONFIG_WIZNET_BUS_DIRECT is not set
CONFIG_WIZNET_BUS_INDIRECT=y
# CONFIG_WIZNET_BUS_ANY is not set
CONFIG_NET_VENDOR_XIRCOM=y
CONFIG_PCMCIA_XIRC2PS=y
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
# CONFIG_SKFP is not set
CONFIG_HIPPI=y
CONFIG_ROADRUNNER=y
CONFIG_ROADRUNNER_LARGE_RINGS=y
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
# CONFIG_BROADCOM_PHY is not set
CONFIG_BCM7XXX_PHY=y
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=y
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
CONFIG_LSI_ET1011C_PHY=y
# CONFIG_MICREL_PHY is not set
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=y
CONFIG_MICREL_KS8995MA=y
CONFIG_PLIP=y
CONFIG_PPP=y
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=y
# CONFIG_PPPOE is not set
# CONFIG_PPPOL2TP is not set
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
# CONFIG_USB_PEGASUS is not set
CONFIG_USB_RTL8150=y
CONFIG_USB_RTL8152=y
# CONFIG_USB_USBNET is not set
# CONFIG_USB_CDC_PHONET is not set
CONFIG_USB_IPHETH=y
CONFIG_WLAN=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_PRISM54 is not set
CONFIG_HOSTAP=y
CONFIG_HOSTAP_FIRMWARE=y
# CONFIG_HOSTAP_FIRMWARE_NVRAM is not set
# CONFIG_HOSTAP_PLX is not set
CONFIG_HOSTAP_PCI=y
CONFIG_HOSTAP_CS=y
CONFIG_WL_TI=y

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=y
CONFIG_WIMAX_I2400M_USB=y
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
CONFIG_WAN=y
# CONFIG_HDLC is not set
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
CONFIG_SBNI=y
# CONFIG_SBNI_MULTILINE is not set
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
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=y
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
# CONFIG_JOYSTICK_WARRIOR is not set
CONFIG_JOYSTICK_MAGELLAN=y
# CONFIG_JOYSTICK_SPACEORB is not set
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
# CONFIG_JOYSTICK_DB9 is not set
CONFIG_JOYSTICK_GAMECON=y
CONFIG_JOYSTICK_TURBOGRAFX=y
CONFIG_JOYSTICK_AS5011=y
# CONFIG_JOYSTICK_JOYDUMP is not set
CONFIG_JOYSTICK_XPAD=y
# CONFIG_JOYSTICK_XPAD_FF is not set
# CONFIG_JOYSTICK_XPAD_LEDS is not set
CONFIG_JOYSTICK_WALKERA0701=y
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
CONFIG_TABLET_USB_GTCO=y
CONFIG_TABLET_USB_HANWANG=y
CONFIG_TABLET_USB_KBTAB=y
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
# CONFIG_TOUCHSCREEN_AD7877 is not set
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
# CONFIG_TOUCHSCREEN_AD7879_SPI is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
CONFIG_TOUCHSCREEN_BU21013=y
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP_SPI=y
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP4_SPI=y
CONFIG_TOUCHSCREEN_DA9052=y
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_EETI=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=y
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
CONFIG_TOUCHSCREEN_MAX11801=y
# CONFIG_TOUCHSCREEN_MCS5000 is not set
CONFIG_TOUCHSCREEN_MMS114=y
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_WM831X=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
# CONFIG_TOUCHSCREEN_MC13783 is not set
# CONFIG_TOUCHSCREEN_USB_EGALAX is not set
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
# CONFIG_TOUCHSCREEN_USB_ITM is not set
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
# CONFIG_TOUCHSCREEN_USB_DMC_TSC10 is not set
# CONFIG_TOUCHSCREEN_USB_IRTOUCH is not set
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
# CONFIG_TOUCHSCREEN_USB_ELO is not set
# CONFIG_TOUCHSCREEN_USB_E2I is not set
# CONFIG_TOUCHSCREEN_USB_ZYTRONIC is not set
# CONFIG_TOUCHSCREEN_USB_ETT_TC45USB is not set
# CONFIG_TOUCHSCREEN_USB_NEXIO is not set
# CONFIG_TOUCHSCREEN_USB_EASYTOUCH is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_TOUCHSCREEN_TSC_SERIO=y
# CONFIG_TOUCHSCREEN_TSC2005 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_TOUCHSCREEN_PCAP=y
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_SUR40 is not set
CONFIG_TOUCHSCREEN_TPS6507X=y
CONFIG_TOUCHSCREEN_ZFORCE=y
# CONFIG_INPUT_MISC is not set

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
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
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
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
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
# CONFIG_SERIAL_MRST_MAX3110 is not set
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_UARTLITE is not set
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
# CONFIG_SERIAL_MEN_Z135 is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_SI_PROBE_DEFAULTS=y
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=y
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
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
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
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
CONFIG_I2C_ALI1563=y
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
# CONFIG_I2C_ISMT is not set
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_NFORCE2_S4985 is not set
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_KEMPLD=y
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_ROBOTFUZZ_OSIF=y
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=y
CONFIG_I2C_VIPERBOARD=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
CONFIG_SPI_GPIO=y
CONFIG_SPI_LM70_LLP=y
CONFIG_SPI_OC_TINY=y
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_SC18IS602 is not set
CONFIG_SPI_XCOMM=y
# CONFIG_SPI_XILINX is not set
CONFIG_SPI_DESIGNWARE=y
CONFIG_SPI_DW_PCI=y
CONFIG_SPI_DW_MID_DMA=y
CONFIG_SPI_DW_MMIO=y

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=y
# CONFIG_SPMI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_PARPORT=y
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
# CONFIG_DP83640_PHY is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_DA9055=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_F7188X is not set
CONFIG_GPIO_SCH311X=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
CONFIG_GPIO_LP3943=y
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_RC5T583 is not set
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_TC3589X is not set
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM831X=y
# CONFIG_GPIO_WM8994 is not set
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_INTEL_MID=y
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_TIMBERDALE=y
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=y

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=y
CONFIG_GPIO_PALMAS=y

#
# USB GPIO expanders:
#
CONFIG_GPIO_VIPERBOARD=y
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
# CONFIG_W1_MASTER_DS2490 is not set
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_MAX8925_POWER=y
CONFIG_WM831X_BACKUP=y
# CONFIG_WM831X_POWER is not set
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_88PM860X is not set
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9052 is not set
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_CHARGER_ISP1704=y
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_LP8788=y
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_MAX14577 is not set
CONFIG_CHARGER_MAX8997=y
CONFIG_CHARGER_BQ2415X=y
# CONFIG_CHARGER_BQ24190 is not set
CONFIG_CHARGER_BQ24735=y
# CONFIG_CHARGER_SMB347 is not set
CONFIG_CHARGER_TPS65090=y
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_AD7314=y
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
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
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_DA9055 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_MC13783_ADC is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IIO_HWMON=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_HTU21 is not set
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_NCT6683=y
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SHTC1=y
CONFIG_SENSORS_SIS5595=y
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
CONFIG_INTEL_POWERCLAMP=y
# CONFIG_X86_PKG_TEMP_THERMAL is not set
# CONFIG_ACPI_INT3403_THERMAL is not set
CONFIG_INTEL_SOC_DTS_THERMAL=y

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_DA9052_WATCHDOG=y
CONFIG_DA9055_WATCHDOG=y
CONFIG_WM831X_WATCHDOG=y
CONFIG_XILINX_WATCHDOG=y
CONFIG_DW_WATCHDOG=y
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=y
CONFIG_SP5100_TCO=y
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
CONFIG_HP_WATCHDOG=y
# CONFIG_KEMPLD_WDT is not set
# CONFIG_HPWDT_NMI_DECODING is not set
CONFIG_SC1200_WDT=y
CONFIG_PC87413_WDT=y
CONFIG_NV_TCO=y
# CONFIG_60XX_WDT is not set
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
CONFIG_VIA_WDT=y
# CONFIG_W83627HF_WDT is not set
CONFIG_W83877F_WDT=y
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_MEN_A21_WDT=y

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
CONFIG_WDTPCI=y

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
CONFIG_SSB_SDIOHOST=y
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
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_HOST_SOC=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_AXP20X is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_HTC_PASIC3 is not set
CONFIG_HTC_I2CPLD=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
CONFIG_EZX_PCAP=y
CONFIG_MFD_VIPERBOARD=y
# CONFIG_MFD_RETU is not set
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
CONFIG_PCF50633_GPIO=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RTSX_USB=y
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=y
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS65218 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_ARIZONA_SPI is not set
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_88PM800 is not set
# CONFIG_REGULATOR_88PM8607 is not set
# CONFIG_REGULATOR_ACT8865 is not set
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9210=y
# CONFIG_REGULATOR_FAN53555 is not set
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
CONFIG_REGULATOR_LTC3589=y
CONFIG_REGULATOR_MAX14577=y
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8997=y
# CONFIG_REGULATOR_MAX8998 is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_PALMAS=y
# CONFIG_REGULATOR_PCAP is not set
# CONFIG_REGULATOR_PCF50633 is not set
CONFIG_REGULATOR_PFUZE100=y
# CONFIG_REGULATOR_RC5T583 is not set
CONFIG_REGULATOR_S2MPA01=y
CONFIG_REGULATOR_S2MPS11=y
CONFIG_REGULATOR_S5M8767=y
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS6105X=y
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65090=y
# CONFIG_REGULATOR_TPS6524X is not set
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8994=y
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
CONFIG_DRM=y
CONFIG_DRM_USB=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
CONFIG_DRM_I2C_NXP_TDA998X=y
# CONFIG_DRM_PTN3460 is not set
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_UMS=y
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=y
CONFIG_DRM_SIS=y
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
# CONFIG_DRM_VMWGFX is not set
CONFIG_DRM_GMA500=y
# CONFIG_DRM_GMA600 is not set
CONFIG_DRM_GMA3600=y
CONFIG_DRM_UDL=y
# CONFIG_DRM_AST is not set
CONFIG_DRM_MGAG200=y
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_QXL=y
# CONFIG_DRM_BOCHS is not set

#
# Frame buffer Devices
#
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
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=y
CONFIG_FB_PM2_FIFO_DISCONNECT=y
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=y
CONFIG_FB_OPENCORES=y
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
CONFIG_FB_NVIDIA_DEBUG=y
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=y
CONFIG_FB_RIVA_I2C=y
CONFIG_FB_RIVA_DEBUG=y
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_I740=y
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
CONFIG_FB_MATROX=y
CONFIG_FB_MATROX_MILLENIUM=y
# CONFIG_FB_MATROX_MYSTIQUE is not set
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=y
CONFIG_FB_MATROX_MAVEN=y
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
# CONFIG_FB_ATY_GENERIC_LCD is not set
CONFIG_FB_ATY_GX=y
# CONFIG_FB_ATY_BACKLIGHT is not set
CONFIG_FB_S3=y
CONFIG_FB_S3_DDC=y
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
# CONFIG_FB_SAVAGE_ACCEL is not set
CONFIG_FB_SIS=y
# CONFIG_FB_SIS_300 is not set
# CONFIG_FB_SIS_315 is not set
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
# CONFIG_FB_CARMINE is not set
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
CONFIG_FB_AUO_K1901=y
CONFIG_FB_SIMPLE=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
CONFIG_LCD_LTV350QV=y
CONFIG_LCD_ILI922X=y
CONFIG_LCD_ILI9320=y
# CONFIG_LCD_TDO24M is not set
CONFIG_LCD_VGG2432A4=y
CONFIG_LCD_PLATFORM=y
CONFIG_LCD_S6E63M0=y
# CONFIG_LCD_LD9040 is not set
# CONFIG_LCD_AMS369FG06 is not set
CONFIG_LCD_LMS501KF03=y
CONFIG_LCD_HX8357=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_CARILLO_RANCH=y
CONFIG_BACKLIGHT_DA9052=y
# CONFIG_BACKLIGHT_MAX8925 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
# CONFIG_BACKLIGHT_88PM860X is not set
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
# CONFIG_BACKLIGHT_BD6107 is not set
CONFIG_VGASTATE=y
CONFIG_HDMI=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
# CONFIG_LOGO_LINUX_CLUT224 is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
# CONFIG_SND is not set
CONFIG_SOUND_PRIME=y

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
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
# CONFIG_HID_CHICONY is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=y
# CONFIG_HID_ELECOM is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_ORTEK=y
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
# CONFIG_HID_PICOLCD_FB is not set
CONFIG_HID_PICOLCD_BACKLIGHT=y
# CONFIG_HID_PICOLCD_LCD is not set
# CONFIG_HID_PICOLCD_LEDS is not set
CONFIG_HID_PRIMAX=y
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_RMI=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=y
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
# CONFIG_USB_HID is not set
CONFIG_HID_PID=y

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=y
CONFIG_USB_MOUSE=y

#
# I2C HID support
#
CONFIG_I2C_HID=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_OTG_FSM=y
CONFIG_USB_MON=y
CONFIG_USB_WUSB_CBAF=y
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
CONFIG_USB_OXU210HP_HCD=y
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_FUSBH200_HCD=y
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_MAX3421_HCD=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
CONFIG_USB_OHCI_HCD_SSB=y
CONFIG_USB_OHCI_HCD_PLATFORM=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_U132_HCD is not set
CONFIG_USB_SL811_HCD=y
CONFIG_USB_SL811_HCD_ISO=y
# CONFIG_USB_SL811_CS is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_BCMA is not set
CONFIG_USB_HCD_SSB=y
# CONFIG_USB_HCD_TEST_MODE is not set
# CONFIG_USB_RENESAS_USBHS is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
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
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y
CONFIG_USB_MUSB_HDRC=y
CONFIG_USB_MUSB_HOST=y
# CONFIG_USB_MUSB_GADGET is not set
# CONFIG_USB_MUSB_DUAL_ROLE is not set
# CONFIG_USB_MUSB_TUSB6010 is not set
CONFIG_USB_MUSB_UX500=y
CONFIG_USB_UX500_DMA=y
# CONFIG_MUSB_PIO_ONLY is not set
# CONFIG_USB_DWC3 is not set
CONFIG_USB_DWC2=y
CONFIG_USB_DWC2_HOST=y
CONFIG_USB_DWC2_PLATFORM=y
# CONFIG_USB_DWC2_PCI is not set

#
# Gadget mode requires USB Gadget support to be enabled
#
CONFIG_USB_DWC2_PERIPHERAL=y
# CONFIG_USB_DWC2_DEBUG is not set
# CONFIG_USB_DWC2_TRACK_MISSED_SOFS is not set
CONFIG_USB_CHIPIDEA=y
# CONFIG_USB_CHIPIDEA_UDC is not set
# CONFIG_USB_CHIPIDEA_HOST is not set
# CONFIG_USB_CHIPIDEA_DEBUG is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
CONFIG_USB_EHSET_TEST_FIXTURE=y
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
# CONFIG_USB_EZUSB_FX2 is not set
CONFIG_USB_HSIC_USB3503=y
CONFIG_USB_ATM=y
# CONFIG_USB_SPEEDTOUCH is not set
CONFIG_USB_CXACRU=y
CONFIG_USB_UEAGLEATM=y
CONFIG_USB_XUSBATM=y

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_USB_GPIO_VBUS=y
CONFIG_USB_ISP1301=y
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_DEBUG=y
CONFIG_USB_GADGET_VERBOSE=y
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FOTG210_UDC=y
# CONFIG_USB_GR_UDC is not set
CONFIG_USB_R8A66597=y
# CONFIG_USB_PXA27X is not set
# CONFIG_USB_MV_UDC is not set
CONFIG_USB_MV_U3D=y
# CONFIG_USB_M66592 is not set
# CONFIG_USB_AMD5536UDC is not set
# CONFIG_USB_NET2272 is not set
CONFIG_USB_NET2280=y
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
CONFIG_USB_DUMMY_HCD=y
CONFIG_USB_LIBCOMPOSITE=y
CONFIG_USB_U_ETHER=y
CONFIG_USB_F_ECM=y
CONFIG_USB_F_SUBSET=y
# CONFIG_USB_CONFIGFS is not set
# CONFIG_USB_ZERO is not set
CONFIG_USB_ETH=y
# CONFIG_USB_ETH_RNDIS is not set
# CONFIG_USB_ETH_EEM is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_NOKIA is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
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
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_SPI=y
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
CONFIG_MMC_USHC=y
CONFIG_MMC_USDHI6ROL0=y
CONFIG_MMC_REALTEK_PCI=y
CONFIG_MMC_REALTEK_USB=y
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y
CONFIG_MS_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_MEMSTICK_REALTEK_PCI=y
CONFIG_MEMSTICK_REALTEK_USB=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8501=y
# CONFIG_LEDS_LP8788 is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_MAX8997=y
CONFIG_LEDS_LM355x=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=y
# CONFIG_INFINIBAND_USER_MAD is not set
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=y
# CONFIG_INFINIBAND_MTHCA_DEBUG is not set
CONFIG_INFINIBAND_QIB=y
CONFIG_INFINIBAND_AMSO1100=y
CONFIG_INFINIBAND_AMSO1100_DEBUG=y
# CONFIG_INFINIBAND_CXGB4 is not set
CONFIG_MLX4_INFINIBAND=y
CONFIG_MLX5_INFINIBAND=y
# CONFIG_INFINIBAND_NES is not set
CONFIG_INFINIBAND_OCRDMA=y
# CONFIG_INFINIBAND_IPOIB is not set
# CONFIG_INFINIBAND_SRP is not set
CONFIG_INFINIBAND_ISER=y
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
CONFIG_INTEL_IOATDMA=y
CONFIG_DW_DMAC_CORE=y
# CONFIG_DW_DMAC is not set
CONFIG_DW_DMAC_PCI=y
CONFIG_TIMB_DMA=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DMA_ENGINE_RAID=y
CONFIG_DCA=y
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=y
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=y
CONFIG_CFAG12864B_RATE=20
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
CONFIG_UIO_AEC=y
# CONFIG_UIO_SERCOS3 is not set
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
CONFIG_UIO_MF624=y
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_ET131X is not set
CONFIG_SLICOSS=y
CONFIG_USBIP_CORE=y
# CONFIG_USBIP_VHCI_HCD is not set
# CONFIG_USBIP_HOST is not set
# CONFIG_USBIP_DEBUG is not set
# CONFIG_PANEL is not set
CONFIG_R8712U=y
# CONFIG_R8188EU is not set
# CONFIG_RTS5208 is not set
CONFIG_TRANZPORT=y
CONFIG_DX_SEP=y

#
# IIO staging drivers
#

#
# Accelerometers
#
# CONFIG_ADIS16201 is not set
CONFIG_ADIS16203=y
# CONFIG_ADIS16204 is not set
# CONFIG_ADIS16209 is not set
CONFIG_ADIS16220=y
# CONFIG_ADIS16240 is not set
# CONFIG_LIS3L02DQ is not set
# CONFIG_SCA3000 is not set

#
# Analog to digital converters
#
# CONFIG_AD7291 is not set
CONFIG_AD7606=y
# CONFIG_AD7606_IFACE_PARALLEL is not set
CONFIG_AD7606_IFACE_SPI=y
CONFIG_AD7780=y
CONFIG_AD7816=y
CONFIG_AD7192=y
CONFIG_AD7280=y

#
# Analog digital bi-direction converters
#
# CONFIG_ADT7316 is not set

#
# Capacitance to digital converters
#
CONFIG_AD7150=y
CONFIG_AD7152=y
CONFIG_AD7746=y

#
# Direct Digital Synthesis
#
CONFIG_AD5930=y
# CONFIG_AD9832 is not set
CONFIG_AD9834=y
# CONFIG_AD9850 is not set
# CONFIG_AD9852 is not set
CONFIG_AD9910=y
# CONFIG_AD9951 is not set

#
# Digital gyroscope sensors
#
# CONFIG_ADIS16060 is not set

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=y

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=y
CONFIG_SENSORS_ISL29028=y
CONFIG_TSL2583=y
CONFIG_TSL2x7x=y

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=y

#
# Active energy metering IC
#
CONFIG_ADE7753=y
# CONFIG_ADE7754 is not set
CONFIG_ADE7758=y
CONFIG_ADE7759=y
# CONFIG_ADE7854 is not set

#
# Resolver to digital converters
#
CONFIG_AD2S90=y
CONFIG_AD2S1200=y
# CONFIG_AD2S1210 is not set

#
# Triggers - standalone
#
CONFIG_IIO_DUMMY_EVGEN=y
CONFIG_IIO_SIMPLE_DUMMY=y
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
# CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set
# CONFIG_WLAGS49_H2 is not set
CONFIG_WLAGS49_H25=y
# CONFIG_CRYSTALHD is not set
CONFIG_FB_XGI=y
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_BCM_WIMAX=y
CONFIG_FT1000=y
# CONFIG_FT1000_USB is not set
# CONFIG_FT1000_PCMCIA is not set

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_USB_WPAN_HCD=y
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_NET_VENDOR_SILICOM is not set
# CONFIG_CED1401 is not set
# CONFIG_DGRP is not set
# CONFIG_FIREWIRE_SERIAL is not set
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
# CONFIG_GS_FPGABOOT is not set
CONFIG_CRYPTO_SKEIN=y
CONFIG_CRYPTO_THREEFISH=y
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ALIENWARE_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_DELL_SMO8800 is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_HP_WMI is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ASUS_WMI is not set
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=y
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
CONFIG_CHROME_PLATFORMS=y
# CONFIG_CHROMEOS_PSTORE is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
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
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=y
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
CONFIG_EXTCON_ADC_JACK=y
CONFIG_EXTCON_MAX14577=y
CONFIG_EXTCON_MAX8997=y
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
CONFIG_BMA180=y
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y
CONFIG_IIO_ST_ACCEL_SPI_3AXIS=y
# CONFIG_KXSD9 is not set
CONFIG_MMA8452=y

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
CONFIG_AD7266=y
CONFIG_AD7298=y
CONFIG_AD7476=y
# CONFIG_AD7791 is not set
CONFIG_AD7793=y
CONFIG_AD7887=y
CONFIG_AD7923=y
CONFIG_AD799X=y
CONFIG_LP8788_ADC=y
# CONFIG_MAX1363 is not set
CONFIG_MCP320X=y
CONFIG_MCP3422=y
CONFIG_MEN_Z188_ADC=y
# CONFIG_NAU7802 is not set
# CONFIG_TI_ADC081C is not set
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
# CONFIG_AD5064 is not set
CONFIG_AD5360=y
CONFIG_AD5380=y
# CONFIG_AD5421 is not set
CONFIG_AD5446=y
CONFIG_AD5449=y
CONFIG_AD5504=y
CONFIG_AD5624R_SPI=y
CONFIG_AD5686=y
# CONFIG_AD5755 is not set
CONFIG_AD5764=y
CONFIG_AD5791=y
CONFIG_AD7303=y
# CONFIG_MAX517 is not set
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
# CONFIG_ADF4350 is not set

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
CONFIG_ITG3200=y

#
# Humidity sensors
#
# CONFIG_DHT11 is not set
CONFIG_SI7005=y

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
CONFIG_APDS9300=y
CONFIG_CM32181=y
# CONFIG_CM36651 is not set
CONFIG_GP2AP020A00F=y
CONFIG_SENSORS_LM3533=y
CONFIG_LTR501=y
CONFIG_TCS3472=y
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_TSL4531 is not set
# CONFIG_VCNL4000 is not set

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
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
CONFIG_MPL115=y
# CONFIG_MPL3115 is not set
# CONFIG_IIO_ST_PRESS is not set

#
# Lightning sensors
#
CONFIG_AS3935=y

#
# Temperature sensors
#
# CONFIG_MLX90614 is not set
# CONFIG_TMP006 is not set
CONFIG_NTB=y
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
# CONFIG_VME_CA91CX42 is not set
CONFIG_VME_TSI148=y

#
# VME Board Drivers
#
# CONFIG_VMIVME_7805 is not set

#
# VME Device Drivers
#
CONFIG_VME_USER=y
CONFIG_VME_PIO2=y
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_PHY_SAMSUNG_USB2 is not set
# CONFIG_POWERCAP is not set
CONFIG_MCB=y
CONFIG_MCB_PCI=y

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
CONFIG_EXT2_FS_XIP=y
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_FS_XIP=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
CONFIG_GFS2_FS=y
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
CONFIG_BTRFS_DEBUG=y
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
# CONFIG_AUTOFS4_FS is not set
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
CONFIG_JOLIET=y
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
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_CEPH_FS=y
CONFIG_CEPH_FS_POSIX_ACL=y
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
CONFIG_AFS_FS=y
CONFIG_AFS_DEBUG=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
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
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
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
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
# CONFIG_DEBUG_OBJECTS is not set
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
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0

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
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_PI_LIST is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
# CONFIG_FAULT_INJECTION is not set
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
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_STRESS=y
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
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
CONFIG_TRUSTED_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
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
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
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
# CONFIG_CRYPTO_CMAC is not set
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
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
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
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_BINARY_PRINTF is not set

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
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
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
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y

--0WGqsT62A4RTsSXf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--0WGqsT62A4RTsSXf--
