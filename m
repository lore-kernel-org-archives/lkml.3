Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaG3OR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:17:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:34358 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbaG3OR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:17:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,764,1400050800"; 
   d="log'?scan'208";a="569466093"
Date: Wed, 30 Jul 2014 22:17:32 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andy Lutomirski <luto@amacapital.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [x86,kaslr] [    0.000000] WARNING: CPU: 0 PID: 0 at
 arch/x86/kernel/cpu/common.c:1422 warn_pre_alternatives()
Message-ID: <20140730141732.GP16537@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="TDVcAd+kFgbLxwBe"
Content-Disposition: inline
In-Reply-To: <20140730140756.GN16537@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TDVcAd+kFgbLxwBe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 30, 2014 at 10:07:56PM +0800, Fengguang Wu wrote:
> Hi Andy,
> 
> Here is another WARNING message for the same commit.
> 
> commit d07c7f1ed61789e175fa975134855be32263be2c
> Author:     Andy Lutomirski <luto@amacapital.net>
> AuthorDate: Tue Jul 15 18:34:20 2014 -0700
> Commit:     Andy Lutomirski <luto@amacapital.net>
> CommitDate: Wed Jul 16 10:01:27 2014 -0700
> 
>     x86,kaslr: Use MSR_KVM_GET_RNG_SEED for KASLR if available
>     
>     It's considerably better than any of the alternatives on KVM.
>     
>     Rather than reinventing all of the cpu feature query code, this fixes
>     native_cpuid to work in PIC objects.
>     
>     I haven't combined it with boot/cpuflags.c's cpuid implementation:
>     including asm/processor.h from boot/cpuflags.c results in a flood of
>     unrelated errors, and fixing it might be messy.
>     
>     Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> 
> +-------------------------------------------------------------------------+------------+------------+
> |                                                                         | c6f07a6360 | d07c7f1ed6 |
> +-------------------------------------------------------------------------+------------+------------+
> | boot_successes                                                          | 1000       | 636        |
> | boot_failures                                                           | 0          | 84         |
> | WARNING:CPU:PID:at_arch/x86/kernel/cpu/common.c:warn_pre_alternatives() | 0          | 84         |
> | BUG:unable_to_handle_kernel_NULL_pointer_dereference                    | 0          | 84         |
> | Oops                                                                    | 0          | 84         |
> | RIP:__free_pages_bootmem                                                | 0          | 84         |
> | Kernel_panic-not_syncing:Fatal_exception                                | 0          | 84         |
> | backtrace:free_all_bootmem                                              | 0          | 84         |
> | backtrace:mem_init                                                      | 0          | 84         |
> +-------------------------------------------------------------------------+------------+------------+
> 
> [    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
> [    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x0
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: CPU: 0 PID: 0 at arch/x86/kernel/cpu/common.c:1422 warn_pre_alternatives+0x1e/0x20()
> [    0.000000] You're using static_cpu_has before alternatives have run!
> [    0.000000] Modules linked in:
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.16.0-rc5-00004-gd07c7f1 #4
> [    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    0.000000]  0000000000000000 ffffffff81803c18 ffffffff813a7bd2 ffffffff81803c60
> [    0.000000]  ffffffff81803c50 ffffffff810a5485 ffffffff810102f9 ffffffff81803e08
> [    0.000000]  0000000000000002 000000000000077c 0000000000000000 ffffffff81803cb0
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff813a7bd2>] dump_stack+0x4d/0x66
> [    0.000000]  [<ffffffff810a5485>] warn_slowpath_common+0x7f/0x98
> [    0.000000]  [<ffffffff810102f9>] ? warn_pre_alternatives+0x1e/0x20
> [    0.000000]  [<ffffffff810a54ea>] warn_slowpath_fmt+0x4c/0x4e
> [    0.000000]  [<ffffffff813b14e3>] ? restore_args+0x30/0x30
> [    0.000000]  [<ffffffff810102f9>] warn_pre_alternatives+0x1e/0x20
> [    0.000000]  [<ffffffff810378b5>] __do_page_fault+0x1bd/0x7ca
> [    0.000000]  [<ffffffff810f5782>] ? console_unlock+0x377/0x3c1
> [    0.000000]  [<ffffffff810e912e>] ? trace_hardirqs_off+0xd/0xf
> [    0.000000]  [<ffffffff813afcc5>] ? _raw_spin_unlock_irqrestore+0x40/0x5e
> [    0.000000]  [<ffffffff81b93d22>] ? __next_mem_range_rev+0x205/0x232
> [    0.000000]  [<ffffffff810e90e0>] ? trace_hardirqs_off_caller+0xe7/0x128
> [    0.000000]  [<ffffffff81226d8a>] ? trace_hardirqs_off_thunk+0x3a/0x3c
> [    0.000000]  [<ffffffff81037ee4>] do_page_fault+0x22/0x27
> [    0.000000]  [<ffffffff813b2378>] page_fault+0x28/0x30
> [    0.000000]  [<ffffffff81b74f76>] ? __free_pages_bootmem+0x2d/0xf9
> [    0.000000]  [<ffffffff81b78d61>] __free_memory_core+0xa7/0xbe
> [    0.000000]  [<ffffffff81b78fe9>] free_all_bootmem+0x51/0xd2
> [    0.000000]  [<ffffffff81b67188>] mem_init+0x5c/0x8d
> [    0.000000]  [<ffffffff81b53cca>] start_kernel+0x1f7/0x53d
> [    0.000000]  [<ffffffff81b53814>] ? set_init_arg+0x55/0x55
> [    0.000000]  [<ffffffff81b53120>] ? early_idt_handlers+0x120/0x120
> [    0.000000]  [<ffffffff81b53471>] x86_64_start_reservations+0x2a/0x2c
> [    0.000000]  [<ffffffff81b535b3>] x86_64_start_kernel+0x140/0x14d
> [    0.000000] ---[ end trace e4962b91bd705c64 ]---
> [    0.000000] BUG: unable to handle kernel NULL pointer dereference at 000000000000077c


Interestingly, the other bisect result for the above WARNING message
is

commit ddfb3b363440172d62ce62fbffdf046670d3ce2b
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Fri Jul 11 11:30:24 2014 -0700
Commit:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
CommitDate: Mon Jul 14 04:48:30 2014 -0700

    rcu: Create rcuo kthreads only for onlined CPUs
    
    RCU currently uses for_each_possible_cpu() to spawn rcuo kthreads,
    which can result in more rcuo kthreads than one would expect, for
    example, derRichard reported 64 CPUs worth of rcuo kthreads on an
    8-CPU image.  This commit therefore creates rcuo kthreads only for
    those CPUs that actually come online.
    
    This was reported by derRichard on the OFTC IRC network.
    
    Reported-by: Richard Weinberger <richard@nod.at>
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    Reviewed-by: Josh Triplett <josh@joshtriplett.org>

===================================================
PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
===================================================
Attached dmesg for the parent commit, too, to help confirm whether it is a noise error.

+-------------------------------------------------------------------------+------------+------------+---------------+
|                                                                         | 08e8ea1b45 | ddfb3b3634 | next-20140716 |
+-------------------------------------------------------------------------+------------+------------+---------------+
| boot_successes                                                          | 0          | 0          | 0             |
| boot_failures                                                           | 80         | 20         | 11            |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference                    | 80         | 20         | 11            |
| Oops                                                                    | 80         | 20         | 11            |
| RIP:__bitmap_or                                                         | 80         | 20         | 11            |
| Kernel_panic-not_syncing:Fatal_exception                                | 80         | 20         | 11            |
| backtrace:kernel_init_freeable                                          | 80         |            |               |
| WARNING:CPU:PID:at_arch/x86/kernel/cpu/common.c:warn_pre_alternatives() | 0          | 20         | 11            |
| backtrace:async_page_fault                                              | 0          | 20         | 11            |
| backtrace:rcu_init_one                                                  | 0          | 20         | 11            |
| backtrace:rcu_init                                                      | 0          | 20         | 11            |
+-------------------------------------------------------------------------+------------+------------+---------------+

[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at arch/x86/kernel/cpu/common.c:1422 warn_pre_alternatives+0x2e/0x40()
[    0.000000] You're using static_cpu_has before alternatives have run!
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc1-00050-gddfb3b3 #1
[    0.000000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[    0.000000]  0000000000000009 ffffffff82603bc8 ffffffff81cca80d ffffffff82603c10
[    0.000000]  ffffffff82603c00 ffffffff810e6627 0000000000000000 0000000000000000
[    0.000000]  0000000000000000 ffffffff826186c0 00000000000000a8 ffffffff82603c60
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81cca80d>] dump_stack+0xd2/0x18e
[    0.000000]  [<ffffffff810e6627>] warn_slowpath_common+0xc7/0x100
[    0.000000]  [<ffffffff810e6747>] warn_slowpath_fmt+0x57/0x70
[    0.000000]  [<ffffffff8100e23d>] ? print_context_stack+0x16d/0x210
[    0.000000]  [<ffffffff8102f69e>] warn_pre_alternatives+0x2e/0x40
[    0.000000]  [<ffffffff810839b6>] __do_page_fault+0x2a6/0x1110
[    0.000000]  [<ffffffff8116c112>] ? sched_clock_cpu+0x62/0x2b0
[    0.000000]  [<ffffffff81084ed6>] trace_do_page_fault+0x556/0x770
[    0.000000]  [<ffffffff8107c84b>] do_async_page_fault+0x3b/0x1d0
[    0.000000]  [<ffffffff81ce0d78>] async_page_fault+0x28/0x30
[    0.000000]  [<ffffffff81860e78>] ? __bitmap_or+0x38/0x50
[    0.000000]  [<ffffffff830bd666>] rcu_init_one+0x773/0xa5c
[    0.000000]  [<ffffffff830bdf59>] rcu_init+0x60a/0x6e9
[    0.000000]  [<ffffffff8308d891>] start_kernel+0x46f/0x9f9
[    0.000000]  [<ffffffff8308ce3f>] ? set_init_arg+0xec/0xec
[    0.000000]  [<ffffffff8308c120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff8308c775>] x86_64_start_reservations+0x64/0x6d
[    0.000000]  [<ffffffff8308c943>] x86_64_start_kernel+0x1c5/0x1db
[    0.000000] ---[ end trace 6f39130c1118624e ]---
[    0.000000] ------------[ cut here ]------------

git bisect start d4f4d1d45cd1b9aa60e61c2eab25a5d9a79a26f3 1795cd9b3a91d4b5473c97f491d63892442212ab --
git bisect good 8ab2f8e06b863345c4366c7b94935d105fd4ca01  # 04:50     20+      0  Merge remote-tracking branch 'bluetooth/master'
git bisect good a37140130e816ab7965645bb7f5d2d62e6ed34ca  # 05:06     20+      0  Merge remote-tracking branch 'ftrace/for-next'
git bisect  bad 302d91d7dd1ad5981fe014b65caac5ac3c84aed8  # 05:13      0-      3  Merge remote-tracking branch 'cgroup/for-next'
git bisect  bad de129c7519ac0a86b31124ba79ad05102b30681d  # 05:51      0-      1  Merge remote-tracking branch 'leds/for-next'
git bisect  bad 67d8d9fec86b5f36a2dbecfdbe8adf59f4ce5906  # 06:34      0-      3  Merge remote-tracking branch 'xen-tip/linux-next'
git bisect  bad f9274c7576848a9f0385a4206c6b78bbf40da54e  # 06:52      0-     20  Merge remote-tracking branch 'kvm/linux-next'
git bisect  bad bdc23fbab64e104ba656b931d9ed6ba9b4bc25f9  # 07:07      0-     20  Merge remote-tracking branch 'rcu/rcu/next'
git bisect good b41d1b924d0bd41a225a17f39297b9de0dca93d9  # 07:16     20+      0  rcu: Fix a sparse warning in rcu_report_unblock_qs_rnp()
git bisect good e5ca9705168d0167ce68361045422acd12941be0  # 08:08     20+     20  rcu: Remove remaining read-modify-write ACCESS_ONCE() calls
git bisect good f2c8bbd3e06206b7af836d62ece5fc73c393a3f6  # 08:29     20+     20  rcu: Return false instead of 0 in rcu_nocb_adopt_orphan_cbs()
git bisect good 104c6d8fa94553b1b51f5d8094e619e4aa120b08  # 08:35     20+     20  rcutorture: Use bash shell for all the test scripts
git bisect good 08e8ea1b45c2f62aadc6dff73ade2942a28030bb  # 08:41     20+     20  rcu: Rationalize kthread spawning
git bisect  bad ddfb3b363440172d62ce62fbffdf046670d3ce2b  # 08:47      0-     20  rcu: Create rcuo kthreads only for onlined CPUs
# first bad commit: [ddfb3b363440172d62ce62fbffdf046670d3ce2b] rcu: Create rcuo kthreads only for onlined CPUs
git bisect good 08e8ea1b45c2f62aadc6dff73ade2942a28030bb  # 08:48     60+     80  rcu: Rationalize kthread spawning
git bisect  bad d4f4d1d45cd1b9aa60e61c2eab25a5d9a79a26f3  # 08:48      0-     11  Add linux-next specific files for 20140716
git bisect good b6603fe574af289dbe9eb9fb4c540bca04f5a053  # 08:57     60+      0  Merge tag 'for-linus-20140716' of git://git.infradead.org/linux-mtd
git bisect  bad d4f4d1d45cd1b9aa60e61c2eab25a5d9a79a26f3  # 08:57      0-     11  Add linux-next specific files for 20140716


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1

kvm=(
	qemu-system-x86_64
	-cpu kvm64
	-enable-kvm
	-kernel $kernel
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

--TDVcAd+kFgbLxwBe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-ivb41-15:20140717084615:x86_64-randconfig-iv1-07170145::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-rc1-00050-gddfb3b3 (kbuild@ivytown2) (g=
cc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP PREEMPT Thu Jul 17 08:45:22 CST=
 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-iv1-07170145/next:master=
:ddfb3b363440172d62ce62fbffdf046670d3ce2b:bisect-linux7/.vmlinuz-ddfb3b3634=
40172d62ce62fbffdf046670d3ce2b-20140717084610-11-ivb41 branch=3Dnext/master=
 BOOT_IMAGE=3D/kernel/x86_64-randconfig-iv1-07170145/ddfb3b363440172d62ce62=
fbffdf046670d3ce2b/vmlinuz-3.16.0-rc1-00050-gddfb3b3 drbd.minor_count=3D8
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
[    0.000000] BRK [0x04434000, 0x04434fff] PGTABLE
[    0.000000] BRK [0x04435000, 0x04435fff] PGTABLE
[    0.000000] BRK [0x04436000, 0x04436fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x04437000, 0x04437fff] PGTABLE
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
[    0.000000] mapped APIC to ffffffffff57d000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:128bd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1064 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57d000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff57c000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr=
_node_ids:1
[    0.000000] PERCPU: Embedded 475 pages/cpu @ffff880012400000 s1916864 r8=
192 d20544 u2097152
[    0.000000] pcpu-alloc: s1916864 r8192 d20544 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1240cf00
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80679
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-iv1-07170145/next=
:master:ddfb3b363440172d62ce62fbffdf046670d3ce2b:bisect-linux7/.vmlinuz-ddf=
b3b363440172d62ce62fbffdf046670d3ce2b-20140717084610-11-ivb41 branch=3Dnext=
/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-iv1-07170145/ddfb3b363440172=
d62ce62fbffdf046670d3ce2b/vmlinuz-3.16.0-rc1-00050-gddfb3b3 drbd.minor_coun=
t=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 239932K/327280K available (13196K kernel code, 8923K=
 rwdata, 7044K rodata, 3228K init, 18748K bss, 87348K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at arch/x86/kernel/cpu/common.c:1422 =
warn_pre_alternatives+0x2e/0x40()
[    0.000000] You're using static_cpu_has before alternatives have run!
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc1-00050-g=
ddfb3b3 #1
[    0.000000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
Bochs 01/01/2011
[    0.000000]  0000000000000009 ffffffff82603bc8 ffffffff81cca80d ffffffff=
82603c10
[    0.000000]  ffffffff82603c00 ffffffff810e6627 0000000000000000 00000000=
00000000
[    0.000000]  0000000000000000 ffffffff826186c0 00000000000000a8 ffffffff=
82603c60
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81cca80d>] dump_stack+0xd2/0x18e
[    0.000000]  [<ffffffff810e6627>] warn_slowpath_common+0xc7/0x100
[    0.000000]  [<ffffffff810e6747>] warn_slowpath_fmt+0x57/0x70
[    0.000000]  [<ffffffff8100e23d>] ? print_context_stack+0x16d/0x210
[    0.000000]  [<ffffffff8102f69e>] warn_pre_alternatives+0x2e/0x40
[    0.000000]  [<ffffffff810839b6>] __do_page_fault+0x2a6/0x1110
[    0.000000]  [<ffffffff8116c112>] ? sched_clock_cpu+0x62/0x2b0
[    0.000000]  [<ffffffff81084ed6>] trace_do_page_fault+0x556/0x770
[    0.000000]  [<ffffffff8107c84b>] do_async_page_fault+0x3b/0x1d0
[    0.000000]  [<ffffffff81ce0d78>] async_page_fault+0x28/0x30
[    0.000000]  [<ffffffff81860e78>] ? __bitmap_or+0x38/0x50
[    0.000000]  [<ffffffff830bd666>] rcu_init_one+0x773/0xa5c
[    0.000000]  [<ffffffff830bdf59>] rcu_init+0x60a/0x6e9
[    0.000000]  [<ffffffff8308d891>] start_kernel+0x46f/0x9f9
[    0.000000]  [<ffffffff8308ce3f>] ? set_init_arg+0xec/0xec
[    0.000000]  [<ffffffff8308c120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff8308c775>] x86_64_start_reservations+0x64/0x6d
[    0.000000]  [<ffffffff8308c943>] x86_64_start_kernel+0x1c5/0x1db
[    0.000000] ---[ end trace 6f39130c1118624e ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at arch/x86/kernel/cpu/common.c:1422 =
warn_pre_alternatives+0x2e/0x40()
[    0.000000] You're using static_cpu_has before alternatives have run!
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W     3.16.0=
-rc1-00050-gddfb3b3 #1
[    0.000000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
Bochs 01/01/2011
[    0.000000]  0000000000000009 ffffffff82603bc8 ffffffff81cca80d ffffffff=
82603c10
[    0.000000]  ffffffff82603c00 ffffffff810e6627 0000000000000000 00000000=
00000000
[    0.000000]  0000000000000000 ffffffff826186c0 00000000000000a8 ffffffff=
82603c60
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81cca80d>] dump_stack+0xd2/0x18e
[    0.000000]  [<ffffffff810e6627>] warn_slowpath_common+0xc7/0x100
[    0.000000]  [<ffffffff810e6747>] warn_slowpath_fmt+0x57/0x70
[    0.000000]  [<ffffffff8100e23d>] ? print_context_stack+0x16d/0x210
[    0.000000]  [<ffffffff8102f69e>] warn_pre_alternatives+0x2e/0x40
[    0.000000]  [<ffffffff81083a38>] __do_page_fault+0x328/0x1110
[    0.000000]  [<ffffffff8116c112>] ? sched_clock_cpu+0x62/0x2b0
[    0.000000]  [<ffffffff81084ed6>] trace_do_page_fault+0x556/0x770
[    0.000000]  [<ffffffff8107c84b>] do_async_page_fault+0x3b/0x1d0
[    0.000000]  [<ffffffff81ce0d78>] async_page_fault+0x28/0x30
[    0.000000]  [<ffffffff81860e78>] ? __bitmap_or+0x38/0x50
[    0.000000]  [<ffffffff830bd666>] rcu_init_one+0x773/0xa5c
[    0.000000]  [<ffffffff830bdf59>] rcu_init+0x60a/0x6e9
[    0.000000]  [<ffffffff8308d891>] start_kernel+0x46f/0x9f9
[    0.000000]  [<ffffffff8308ce3f>] ? set_init_arg+0xec/0xec
[    0.000000]  [<ffffffff8308c120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff8308c775>] x86_64_start_reservations+0x64/0x6d
[    0.000000]  [<ffffffff8308c943>] x86_64_start_kernel+0x1c5/0x1db
[    0.000000] ---[ end trace 6f39130c1118624f ]---
[    0.000000] BUG: unable to handle kernel NULL pointer dereference at    =
       (null)
[    0.000000] IP: [<ffffffff81860e78>] __bitmap_or+0x38/0x50
[    0.000000] PGD 0=20
[    0.000000] Oops: 0000 [#1] PREEMPT SMP=20
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W     3.16.0=
-rc1-00050-gddfb3b3 #1
[    0.000000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
Bochs 01/01/2011
[    0.000000] task: ffffffff826186c0 ti: ffffffff82600000 task.ti: fffffff=
f82600000
[    0.000000] RIP: 0010:[<ffffffff81860e78>]  [<ffffffff81860e78>] __bitma=
p_or+0x38/0x50
[    0.000000] RSP: 0000:ffffffff82603ea8  EFLAGS: 00010002
[    0.000000] RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 00000000000=
00001
[    0.000000] RDX: 0000000000000000 RSI: ffff880011424800 RDI: ffff8800114=
24800
[    0.000000] RBP: ffffffff82603ea8 R08: 0000000000000001 R09: 00000000000=
00002
[    0.000000] R10: 0000000000000000 R11: ffffffff839c5eb0 R12: 01400000000=
00000
[    0.000000] R13: 00000000001cd500 R14: ffff8800127cd540 R15: ffffffff827=
1a140
[    0.000000] FS:  0000000000000000(0000) GS:ffff880012400000(0000) knlGS:=
0000000000000000
[    0.000000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.000000] CR2: 0000000000000000 CR3: 0000000002611000 CR4: 00000000000=
006b0
[    0.000000] Stack:
[    0.000000]  ffffffff82603f10 ffffffff830bd666 00000000001cd540 ffffffff=
00000001
[    0.000000]  0000000000000001 0000000000000000 0000000000000006 ffff8800=
127cd540
[    0.000000]  0000000000000002 0000000000000002 ffff8800128bcb00 ffffffff=
8316d0a0
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff830bd666>] rcu_init_one+0x773/0xa5c
[    0.000000]  [<ffffffff830bdf59>] rcu_init+0x60a/0x6e9
[    0.000000]  [<ffffffff8308d891>] start_kernel+0x46f/0x9f9
[    0.000000]  [<ffffffff8308ce3f>] ? set_init_arg+0xec/0xec
[    0.000000]  [<ffffffff8308c120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff8308c775>] x86_64_start_reservations+0x64/0x6d
[    0.000000]  [<ffffffff8308c943>] x86_64_start_kernel+0x1c5/0x1db
[    0.000000] Code: 06 48 89 e5 85 c9 41 89 c8 7f 18 0f 1f 84 00 00 00 00 =
00 48 83 05 a0 f5 a1 02 01 5d c3 66 0f 1f 44 00 00 48 83 05 88 f5 a1 02 01 =
<48> 8b 0c c2 48 0b 0c c6 48 89 0c c7 48 83 c0 01 41 39 c0 7f e3=20
[    0.000000] RIP  [<ffffffff81860e78>] __bitmap_or+0x38/0x50
[    0.000000]  RSP <ffffffff82603ea8>
[    0.000000] CR2: 0000000000000000
[    0.000000] ---[ end trace 6f39130c11186250 ]---
[    0.000000] Kernel panic - not syncing: Fatal exception
[    0.000000] Rebooting in 10 seconds..
Elapsed time: 10
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-iv1-07170145/ddfb3b363440172d62ce62fbffdf046670d3ce2b/vmlinuz-3.16.0-rc1-0=
0050-gddfb3b3 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug=
 apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 pan=
ic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 conso=
le=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/=
kbuild-tests/run-queue/kvm/x86_64-randconfig-iv1-07170145/next:master:ddfb3=
b363440172d62ce62fbffdf046670d3ce2b:bisect-linux7/.vmlinuz-ddfb3b363440172d=
62ce62fbffdf046670d3ce2b-20140717084610-11-ivb41 branch=3Dnext/master BOOT_=
IMAGE=3D/kernel/x86_64-randconfig-iv1-07170145/ddfb3b363440172d62ce62fbffdf=
046670d3ce2b/vmlinuz-3.16.0-rc1-00050-gddfb3b3 drbd.minor_count=3D8'  -init=
rd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 320 -smp 2 -net nic,vlan=
=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog=
 i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-quantal-ivb41-1=
5 -serial file:/dev/shm/kboot/serial-quantal-ivb41-15 -daemonize -display n=
one -monitor null=20

--TDVcAd+kFgbLxwBe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-ivb41-100:20140717084820:x86_64-randconfig-iv1-07170145::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-rc1-00049-g08e8ea1 (kbuild@ivytown2) (g=
cc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP PREEMPT Thu Jul 17 08:40:15 CST=
 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-iv1-07170145/next:master=
:08e8ea1b45c2f62aadc6dff73ade2942a28030bb:bisect-linux7/.vmlinuz-08e8ea1b45=
c2f62aadc6dff73ade2942a28030bb-20140717084708-51-ivb41 branch=3Dnext/master=
 BOOT_IMAGE=3D/kernel/x86_64-randconfig-iv1-07170145/08e8ea1b45c2f62aadc6df=
f73ade2942a28030bb/vmlinuz-3.16.0-rc1-00049-g08e8ea1 drbd.minor_count=3D8
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
[    0.000000] BRK [0x04434000, 0x04434fff] PGTABLE
[    0.000000] BRK [0x04435000, 0x04435fff] PGTABLE
[    0.000000] BRK [0x04436000, 0x04436fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x04437000, 0x04437fff] PGTABLE
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
[    0.000000] mapped APIC to ffffffffff57d000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:128bd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1064 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57d000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff57c000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr=
_node_ids:1
[    0.000000] PERCPU: Embedded 475 pages/cpu @ffff880012400000 s1916864 r8=
192 d20544 u2097152
[    0.000000] pcpu-alloc: s1916864 r8192 d20544 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1240cf00
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80679
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-iv1-07170145/next=
:master:08e8ea1b45c2f62aadc6dff73ade2942a28030bb:bisect-linux7/.vmlinuz-08e=
8ea1b45c2f62aadc6dff73ade2942a28030bb-20140717084708-51-ivb41 branch=3Dnext=
/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-iv1-07170145/08e8ea1b45c2f62=
aadc6dff73ade2942a28030bb/vmlinuz-3.16.0-rc1-00049-g08e8ea1 drbd.minor_coun=
t=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 239932K/327280K available (13195K kernel code, 8922K=
 rwdata, 7044K rodata, 3228K init, 18748K bss, 87348K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:524544 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-rc1-00049-g08e8ea1 (kbuild@ivytown2) (g=
cc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP PREEMPT Thu Jul 17 08:40:15 CST=
 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-iv1-07170145/next:master=
:08e8ea1b45c2f62aadc6dff73ade2942a28030bb:bisect-linux7/.vmlinuz-08e8ea1b45=
c2f62aadc6dff73ade2942a28030bb-20140717084708-51-ivb41 branch=3Dnext/master=
 BOOT_IMAGE=3D/kernel/x86_64-randconfig-iv1-07170145/08e8ea1b45c2f62aadc6df=
f73ade2942a28030bb/vmlinuz-3.16.0-rc1-00049-g08e8ea1 drbd.minor_count=3D8
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
[    0.000000] BRK [0x04434000, 0x04434fff] PGTABLE
[    0.000000] BRK [0x04435000, 0x04435fff] PGTABLE
[    0.000000] BRK [0x04436000, 0x04436fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x04437000, 0x04437fff] PGTABLE
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
[    0.000000] mapped APIC to ffffffffff57d000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:128bd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1064 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57d000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff57c000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr=
_node_ids:1
[    0.000000] PERCPU: Embedded 475 pages/cpu @ffff880012400000 s1916864 r8=
192 d20544 u2097152
[    0.000000] pcpu-alloc: s1916864 r8192 d20544 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1240cf00
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80679
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-iv1-07170145/next=
:master:08e8ea1b45c2f62aadc6dff73ade2942a28030bb:bisect-linux7/.vmlinuz-08e=
8ea1b45c2f62aadc6dff73ade2942a28030bb-20140717084708-51-ivb41 branch=3Dnext=
/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-iv1-07170145/08e8ea1b45c2f62=
aadc6dff73ade2942a28030bb/vmlinuz-3.16.0-rc1-00049-g08e8ea1 drbd.minor_coun=
t=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 239932K/327280K available (13195K kernel code, 8922K=
 rwdata, 7044K rodata, 3228K init, 18748K bss, 87348K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:524544 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
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
[    0.000000]  memory used by lock dependency info: 8671 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.510 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5387.02 Bogo=
MIPS (lpj=3D26935100)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] ACPI: Core revision 20140424
[    0.027468] ACPI: All ACPI Tables successfully acquired
[    0.030879] Security Framework initialized
[    0.032123] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.033665] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.038883] Initializing cgroup subsys devices
[    0.040176] Initializing cgroup subsys freezer
[    0.041416] Initializing cgroup subsys blkio
[    0.042770] mce: CPU supports 10 MCE banks
[    0.043917] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.043917] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.043917] tlb_flushall_shift: 6
[    0.048079] Freeing SMP alternatives memory: 20K (ffffffff831df000 - fff=
fffff831e4000)
[    0.056145] Getting VERSION: 1050014
[    0.057228] Getting VERSION: 1050014
[    0.058249] Getting ID: 0
[    0.059088] Getting ID: ff000000
[    0.060128] Getting LVT0: 8700
[    0.061059] Getting LVT1: 8400
[    0.062000] enabled ExtINT on CPU#0
[    0.064147] ENABLING IO-APIC IRQs
[    0.065123] init IO_APIC IRQs
[    0.066029]  apic 0 pin 0 not connected
[    0.067216] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.070075] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.072171] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.074265] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.076361] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.078452] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.080115] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.082989] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.085097] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.087185] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.090066] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.092200] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.094344] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.096489] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.098616] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.100067]  apic 0 pin 16 not connected
[    0.101162]  apic 0 pin 17 not connected
[    0.102244]  apic 0 pin 18 not connected
[    0.103362]  apic 0 pin 19 not connected
[    0.104454]  apic 0 pin 20 not connected
[    0.105546]  apic 0 pin 21 not connected
[    0.106628]  apic 0 pin 22 not connected
[    0.107714]  apic 0 pin 23 not connected
[    0.110237] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.112200] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.115504] Using local APIC timer interrupts.
[    0.115504] calibrating APIC timer ...
[    0.120000] ... lapic delta =3D 8125139
[    0.120000] ... PM-Timer delta =3D 465356
[    0.120000] APIC calibration not consistent with PM-Timer: 130ms instead=
 of 100ms
[    0.120000] APIC delta adjusted to PM-Timer: 6249894 (8125139)
[    0.120000] TSC delta adjusted to PM-Timer: 269351069 (350168280)
[    0.120000] ..... delta 6249894
[    0.120000] ..... mult: 268430903
[    0.120000] ..... calibration result: 9999830
[    0.120000] ..... CPU clock speed is 2693.5106 MHz.
[    0.120000] ..... host bus clock speed is 999.9830 MHz.
[    0.120185] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.142066] BUG: unable to handle kernel NULL pointer dereference at    =
       (null)
[    0.144323] IP: [<ffffffff81860b28>] __bitmap_or+0x38/0x50
[    0.145748] PGD 0=20
[    0.146517] Oops: 0000 [#1] PREEMPT SMP=20
[    0.147804] Modules linked in:
[    0.148843] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.16.0-rc1-00049-g=
08e8ea1 #1
[    0.150000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
Bochs 01/01/2011
[    0.150000] task: ffff8800114d0010 ti: ffff8800114d4000 task.ti: ffff880=
0114d4000
[    0.150000] RIP: 0010:[<ffffffff81860b28>]  [<ffffffff81860b28>] __bitma=
p_or+0x38/0x50
[    0.150000] RSP: 0000:ffff8800114d7e28  EFLAGS: 00010202
[    0.150000] RAX: 0000000000000000 RBX: ffffffff826afec0 RCX: 00000000000=
00001
[    0.150000] RDX: 0000000000000000 RSI: ffff880011424800 RDI: ffff8800114=
24800
[    0.150000] RBP: ffff8800114d7e28 R08: 0000000000000001 R09: 00000000000=
00001
[    0.150000] R10: 0000000000000000 R11: ffffffff839c5eb0 R12: 00000000fff=
fffff
[    0.150000] R13: 0000000000000001 R14: ffff880011524190 R15: ffffffff826=
16dd0
[    0.150000] FS:  0000000000000000(0000) GS:ffff880012400000(0000) knlGS:=
0000000000000000
[    0.150000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.150000] CR2: 0000000000000000 CR3: 0000000002611000 CR4: 00000000000=
006f0
[    0.150000] Stack:
[    0.150000]  ffff8800114d7e78 ffffffff830bd61d ffffffff811ab3fd ffff8800=
114d7e78
[    0.150000]  0000000000000202 ffff8800114bc4e0 0000000000000202 00000000=
00000001
[    0.150000]  0000000000000000 ffffffff82616dd0 ffff8800114d7f08 ffffffff=
8100053e
[    0.150000] Call Trace:
[    0.150000]  [<ffffffff830bd61d>] rcu_spawn_gp_kthread+0x175/0x568
[    0.150000]  [<ffffffff811ab3fd>] ? trace_hardirqs_on+0x1d/0x30
[    0.150000]  [<ffffffff8100053e>] do_one_initcall+0x2ae/0x490
[    0.150000]  [<ffffffff830bd4a8>] ? rcu_nocb_setup+0x4d/0x4d
[    0.150000]  [<ffffffff830a728d>] ? native_smp_prepare_cpus+0x9cd/0xa06
[    0.150000]  [<ffffffff8308dff2>] kernel_init_freeable+0x1d7/0x472
[    0.150000]  [<ffffffff81caf841>] ? kernel_init+0x11/0x230
[    0.150000]  [<ffffffff81caf830>] ? rest_init+0x230/0x230
[    0.150000]  [<ffffffff81caf841>] kernel_init+0x11/0x230
[    0.150000]  [<ffffffff81cdeabc>] ret_from_fork+0x7c/0xb0
[    0.150000]  [<ffffffff81caf830>] ? rest_init+0x230/0x230
[    0.150000] Code: 06 48 89 e5 85 c9 41 89 c8 7f 18 0f 1f 84 00 00 00 00 =
00 48 83 05 f0 f7 a1 02 01 5d c3 66 0f 1f 44 00 00 48 83 05 d8 f7 a1 02 01 =
<48> 8b 0c c2 48 0b 0c c6 48 89 0c c7 48 83 c0 01 41 39 c0 7f e3=20
[    0.150000] RIP  [<ffffffff81860b28>] __bitmap_or+0x38/0x50
[    0.150000]  RSP <ffff8800114d7e28>
[    0.150000] CR2: 0000000000000000
[    0.150000] ---[ end trace 671605eb0493e456 ]---
[    0.150000] Kernel panic - not syncing: Fatal exception
[    0.150000] Rebooting in 10 seconds..
Elapsed time: 10
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-iv1-07170145/08e8ea1b45c2f62aadc6dff73ade2942a28030bb/vmlinuz-3.16.0-rc1-0=
0049-g08e8ea1 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug=
 apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 pan=
ic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 conso=
le=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/=
kbuild-tests/run-queue/kvm/x86_64-randconfig-iv1-07170145/next:master:08e8e=
a1b45c2f62aadc6dff73ade2942a28030bb:bisect-linux7/.vmlinuz-08e8ea1b45c2f62a=
adc6dff73ade2942a28030bb-20140717084708-51-ivb41 branch=3Dnext/master BOOT_=
IMAGE=3D/kernel/x86_64-randconfig-iv1-07170145/08e8ea1b45c2f62aadc6dff73ade=
2942a28030bb/vmlinuz-3.16.0-rc1-00049-g08e8ea1 drbd.minor_count=3D8'  -init=
rd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 320 -smp 2 -net nic,vlan=
=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog=
 i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-quantal-ivb41-1=
00 -serial file:/dev/shm/kboot/serial-quantal-ivb41-100 -daemonize -display=
 none -monitor null=20

--TDVcAd+kFgbLxwBe
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-iv1-07170145-d4f4d1d45cd1b9aa60e61c2eab25a5d9a79a26f3-WARNING:---at----warn_pre_alternatives+-x-74432.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgZDRmNGQxZC4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxl
cyBmb3IgMjAxNDA3MTYKZ2l0IGNoZWNrb3V0IDE3OTVjZDliM2E5MWQ0YjU0NzNjOTdmNDkx
ZDYzODkyNDQyMjEyYWIKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82
NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS9uZXh0Om1hc3RlcjoxNzk1Y2Q5YjNhOTFkNGI1
NDczYzk3ZjQ5MWQ2Mzg5MjQ0MjIxMmFiOmJpc2VjdC1saW51eDcKCjIwMTQtMDctMTctMDM6
NDU6MDIgMTc5NWNkOWIzYTkxZDRiNTQ3M2M5N2Y0OTFkNjM4OTI0NDIyMTJhYiBjb21waWxp
bmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZf
NjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUtMTc5NWNkOWIzYTkxZDRiNTQ3M2M5N2Y0OTFk
NjM4OTI0NDIyMTJhYgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaXYxLTA3MTcwMTQ1LzE3OTVjZDliM2E5MWQ0YjU0NzNjOTdmNDkxZDYzODkyNDQy
MjEyYWIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS0xNzk1Y2Q5YjNhOTFkNGI1NDcz
Yzk3ZjQ5MWQ2Mzg5MjQ0MjIxMmFiCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS9pdnl0b3duMi1zbW9rZS94ODZfNjQtcmFuZGNvbmZpZy1p
djEtMDcxNzAxNDUtMTc5NWNkOWIzYTkxZDRiNTQ3M2M5N2Y0OTFkNjM4OTI0NDIyMTJhYgpr
ZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1LzE3OTVjZDli
M2E5MWQ0YjU0NzNjOTdmNDkxZDYzODkyNDQyMjEyYWIvdm1saW51ei0zLjE2LjAtcmM1Cgoy
MDE0LTA3LTE3LTA0OjA1OjAyIGRldGVjdGluZyBib290IHN0YXRlIC4uLi4JMTEuLgkyMCBT
VUNDRVNTCgpiaXNlY3Q6IGdvb2QgY29tbWl0IDE3OTVjZDliM2E5MWQ0YjU0NzNjOTdmNDkx
ZDYzODkyNDQyMjEyYWIKZ2l0IGJpc2VjdCBzdGFydCBkNGY0ZDFkNDVjZDFiOWFhNjBlNjFj
MmVhYjI1YTVkOWE3OWEyNmYzIDE3OTVjZDliM2E5MWQ0YjU0NzNjOTdmNDkxZDYzODkyNDQy
MjEyYWIgLS0KL2Mva2VybmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6IFsiLWIiLCAiZDRmNGQx
ZDQ1Y2QxYjlhYTYwZTYxYzJlYWIyNWE1ZDlhNzlhMjZmMyIsICItZyIsICIxNzk1Y2Q5YjNh
OTFkNGI1NDczYzk3ZjQ5MWQ2Mzg5MjQ0MjIxMmFiIiwgIi9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2giLCAiL2MvYm9vdC1iaXNlY3QvbGludXg3L29iai1i
aXNlY3QiXQpCaXNlY3Rpbmc6IDY1MDggcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0
aGlzIChyb3VnaGx5IDEzIHN0ZXBzKQpbOGFiMmY4ZTA2Yjg2MzM0NWM0MzY2YzdiOTQ5MzVk
MTA1ZmQ0Y2EwMV0gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnYmx1ZXRvb3RoL21h
c3RlcicKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4Ny9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVz
dHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUvbmV4dDpt
YXN0ZXI6OGFiMmY4ZTA2Yjg2MzM0NWM0MzY2YzdiOTQ5MzVkMTA1ZmQ0Y2EwMTpiaXNlY3Qt
bGludXg3CgoyMDE0LTA3LTE3LTA0OjA5OjA1IDhhYjJmOGUwNmI4NjMzNDVjNDM2NmM3Yjk0
OTM1ZDEwNWZkNGNhMDEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1LThhYjJm
OGUwNmI4NjMzNDVjNDM2NmM3Yjk0OTM1ZDEwNWZkNGNhMDEKQ2hlY2sgZm9yIGtlcm5lbCBp
biAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS84YWIyZjhlMDZiODYz
MzQ1YzQzNjZjN2I5NDkzNWQxMDVmZDRjYTAxCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2Yg
L2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAx
NDUtOGFiMmY4ZTA2Yjg2MzM0NWM0MzY2YzdiOTQ5MzVkMTA1ZmQ0Y2EwMQp3YWl0aW5nIGZv
ciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaXZ5dG93bjItc21v
a2UveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1LThhYjJmOGUwNmI4NjMzNDVjNDM2
NmM3Yjk0OTM1ZDEwNWZkNGNhMDEKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWl2MS0wNzE3MDE0NS84YWIyZjhlMDZiODYzMzQ1YzQzNjZjN2I5NDkzNWQxMDVmZDRjYTAx
L3ZtbGludXotMy4xNi4wLXJjNS0wMjUyMy1nOGFiMmY4ZQoKMjAxNC0wNy0xNy0wNDozMDow
NiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgkyCTMuLgk1CTgJOQkxMC4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDM5ODUgcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEyIHN0ZXBzKQpbYTM3MTQwMTMw
ZTgxNmFiNzk2NTY0NWJiN2Y1ZDJkNjJlNmVkMzRjYV0gTWVyZ2UgcmVtb3RlLXRyYWNraW5n
IGJyYW5jaCAnZnRyYWNlL2Zvci1uZXh0JwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg3L29iai1iaXNl
Y3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmln
LWl2MS0wNzE3MDE0NS9uZXh0Om1hc3RlcjphMzcxNDAxMzBlODE2YWI3OTY1NjQ1YmI3ZjVk
MmQ2MmU2ZWQzNGNhOmJpc2VjdC1saW51eDcKCjIwMTQtMDctMTctMDQ6NTE6MDYgYTM3MTQw
MTMwZTgxNmFiNzk2NTY0NWJiN2Y1ZDJkNjJlNmVkMzRjYSBjb21waWxpbmcKUXVldWVkIGJ1
aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZp
Zy1pdjEtMDcxNzAxNDUtYTM3MTQwMTMwZTgxNmFiNzk2NTY0NWJiN2Y1ZDJkNjJlNmVkMzRj
YQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3
MTcwMTQ1L2EzNzE0MDEzMGU4MTZhYjc5NjU2NDViYjdmNWQyZDYyZTZlZDM0Y2EKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1y
YW5kY29uZmlnLWl2MS0wNzE3MDE0NS1hMzcxNDAxMzBlODE2YWI3OTY1NjQ1YmI3ZjVkMmQ2
MmU2ZWQzNGNhCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS9pdnl0b3duMi1zbW9rZS94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUt
YTM3MTQwMTMwZTgxNmFiNzk2NTY0NWJiN2Y1ZDJkNjJlNmVkMzRjYQprZXJuZWw6IC9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L2EzNzE0MDEzMGU4MTZhYjc5NjU2
NDViYjdmNWQyZDYyZTZlZDM0Y2Evdm1saW51ei0zLjE2LjAtcmM1LTAzODkwLWdhMzcxNDAx
CgoyMDE0LTA3LTE3LTA1OjA0OjA2IGRldGVjdGluZyBib290IHN0YXRlIC4uLgk4CTIwIFNV
Q0NFU1MKCkJpc2VjdGluZzogMjYxOCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgMTIgc3RlcHMpClszMDJkOTFkN2RkMWFkNTk4MWZlMDE0YjY1Y2FhYzVh
YzNjODRhZWQ4XSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdjZ3JvdXAvZm9yLW5l
eHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCAvYy9ib290LWJpc2VjdC9saW51eDcvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L25leHQ6bWFz
dGVyOjMwMmQ5MWQ3ZGQxYWQ1OTgxZmUwMTRiNjVjYWFjNWFjM2M4NGFlZDg6YmlzZWN0LWxp
bnV4NwoKMjAxNC0wNy0xNy0wNTowNjozOCAzMDJkOTFkN2RkMWFkNTk4MWZlMDE0YjY1Y2Fh
YzVhYzNjODRhZWQ4IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS0zMDJkOTFk
N2RkMWFkNTk4MWZlMDE0YjY1Y2FhYzVhYzNjODRhZWQ4CkNoZWNrIGZvciBrZXJuZWwgaW4g
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUvMzAyZDkxZDdkZDFhZDU5
ODFmZTAxNGI2NWNhYWM1YWMzYzg0YWVkOAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1
LTMwMmQ5MWQ3ZGQxYWQ1OTgxZmUwMTRiNjVjYWFjNWFjM2M4NGFlZDgKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2l2eXRvd24yLXNtb2tl
L3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS0zMDJkOTFkN2RkMWFkNTk4MWZlMDE0
YjY1Y2FhYzVhYzNjODRhZWQ4Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1p
djEtMDcxNzAxNDUvMzAyZDkxZDdkZDFhZDU5ODFmZTAxNGI2NWNhYWM1YWMzYzg0YWVkOC92
bWxpbnV6LTMuMTYuMC1yYzUtMDU4NDMtZzMwMmQ5MWQKCjIwMTQtMDctMTctMDU6MTI6Mzgg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLiBURVNUIEZBSUxVUkUKWyAgICAwLjAwMDAwMF0gUHJl
ZW1wdGlibGUgaGllcmFyY2hpY2FsIFJDVSBpbXBsZW1lbnRhdGlvbi4KWyAgICAwLjAwMDAw
MF0gUkNVOiBBZGp1c3RpbmcgZ2VvbWV0cnkgZm9yIHJjdV9mYW5vdXRfbGVhZj0xNiwgbnJf
Y3B1X2lkcz0xClsgICAgMC4wMDAwMDBdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0t
LS0tLS0tLQpbICAgIDAuMDAwMDAwXSBXQVJOSU5HOiBDUFU6IDAgUElEOiAwIGF0IC9rYnVp
bGQvc3JjL3Ntb2tlL2FyY2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmM6MTQzOSB3YXJuX3By
ZV9hbHRlcm5hdGl2ZXMrMHgyZS8weDQwKCkKWyAgICAwLjAwMDAwMF0gWW91J3JlIHVzaW5n
IHN0YXRpY19jcHVfaGFzIGJlZm9yZSBhbHRlcm5hdGl2ZXMgaGF2ZSBydW4hClsgICAgMC4w
MDAwMDBdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDAuMDAwMDAwXSBDUFU6IDAgUElEOiAw
IENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE2LjAtcmM1LTA1ODQzLWczMDJkOTFk
ICMxClsgICAgMC4wMDAwMDBdIEhhcmR3YXJlIG5hbWU6IFFFTVUgU3RhbmRhcmQgUEMgKGk0
NDBGWCArIFBJSVgsIDE5OTYpLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAwLjAwMDAw
MF0gIDAwMDAwMDAwMDAwMDAwMDkgZmZmZmZmZmY4MjYwM2JjOCBmZmZmZmZmZjgxY2RlMjhl
IGZmZmZmZmZmODI2MDNjMTAKWyAgICAwLjAwMDAwMF0gIGZmZmZmZmZmODI2MDNjMDAgZmZm
ZmZmZmY4MTBlYTNjNyAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAKWyAgICAw
LjAwMDAwMF0gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZmZmZmY4MjYxODcwMCAwMDAwMDAwMDAw
MDAwMGE4IGZmZmZmZmZmODI2MDNjNjAKWyAgICAwLjAwMDAwMF0gQ2FsbCBUcmFjZToKWyAg
ICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNkZTI4ZT5dIGR1bXBfc3RhY2srMHhkMi8weDE4
ZQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxMGVhM2M3Pl0gd2Fybl9zbG93cGF0aF9j
b21tb24rMHhjNy8weDEwMApbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxMGVhNGU3Pl0g
d2Fybl9zbG93cGF0aF9mbXQrMHg1Ny8weDcwClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZm
ODEwMGU0MWQ+XSA/IHByaW50X2NvbnRleHRfc3RhY2srMHgxNmQvMHgyMTAKWyAgICAwLjAw
MDAwMF0gIFs8ZmZmZmZmZmY4MTAyZmUwZT5dIHdhcm5fcHJlX2FsdGVybmF0aXZlcysweDJl
LzB4NDAKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTA4NDNmNj5dIF9fZG9fcGFnZV9m
YXVsdCsweDJhNi8weDExMTAKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTAyYjMyZT5d
ID8gc2F2ZV9zdGFja190cmFjZSsweDJlLzB4ODAKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZm
ZmY4MTA4NTkxNj5dIHRyYWNlX2RvX3BhZ2VfZmF1bHQrMHg1NTYvMHg3NzAKWyAgICAwLjAw
MDAwMF0gIFs8ZmZmZmZmZmY4MTA3ZDI4Yj5dIGRvX2FzeW5jX3BhZ2VfZmF1bHQrMHgzYi8w
eDFkMApbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2Y0OTM4Pl0gYXN5bmNfcGFnZV9m
YXVsdCsweDI4LzB4MzAKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTg2YTA4OD5dID8g
X19iaXRtYXBfb3IrMHgzOC8weDUwClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODMwYzRh
OTk+XSByY3VfaW5pdF9vbmUrMHg3NzMvMHhhNWMKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZm
ZmY4MzBjNTM4Yz5dIHJjdV9pbml0KzB4NjBhLzB4NmU5ClsgICAgMC4wMDAwMDBdICBbPGZm
ZmZmZmZmODMwOTU4OTE+XSBzdGFydF9rZXJuZWwrMHg0NmYvMHg5ZjkKWyAgICAwLjAwMDAw
MF0gIFs8ZmZmZmZmZmY4MzA5NGUzZj5dID8gc2V0X2luaXRfYXJnKzB4ZWMvMHhlYwpbICAg
IDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgzMDk0MTIwPl0gPyBlYXJseV9pZHRfaGFuZGxlcnMr
MHgxMjAvMHgxMjAKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MzA5NDc3NT5dIHg4Nl82
NF9zdGFydF9yZXNlcnZhdGlvbnMrMHg2NC8weDZkClsgICAgMC4wMDAwMDBdICBbPGZmZmZm
ZmZmODMwOTQ5NDM+XSB4ODZfNjRfc3RhcnRfa2VybmVsKzB4MWM1LzB4MWRiClsgICAgMC4w
MDAwMDBdIC0tLVsgZW5kIHRyYWNlIDFkMzFmZTU5Yzk4NWFjNDkgXS0tLQpbICAgIDAuMDAw
MDAwXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUvMzAyZDkxZDdkZDFhZDU5ODFmZTAxNGI2NWNh
YWM1YWMzYzg0YWVkOC9kbWVzZy15b2N0by12cC0yMjoyMDE0MDcxNzA1MTMwNTp4ODZfNjQt
cmFuZGNvbmZpZy1pdjEtMDcxNzAxNDU6My4xNi4wLXJjNS0wNTg0My1nMzAyZDkxZDoxCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1LzMwMmQ5MWQ3ZGQxYWQ1OTgx
ZmUwMTRiNjVjYWFjNWFjM2M4NGFlZDgvZG1lc2cteW9jdG8tdnAtMzI6MjAxNDA3MTcwNTEz
MDQ6eDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1OjMuMTYuMC1yYzUtMDU4NDMtZzMw
MmQ5MWQ6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS8zMDJkOTFk
N2RkMWFkNTk4MWZlMDE0YjY1Y2FhYzVhYzNjODRhZWQ4L2RtZXNnLXlvY3RvLWl2YjQyLTQ1
OjIwMTQwNzE3MDUxODQ2Ong4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NTo6CjA6Mzoz
IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA3LTE3IDA1OjEzOjA5
IFJFUEVBVCBDT1VOVDogMjAgICMgL2MvYm9vdC1iaXNlY3QvbGludXg3L29iai1iaXNlY3Qv
LnJlcGVhdBtbMG0KCkJpc2VjdGluZzogMTk1MyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgMTEgc3RlcHMpCltkZTEyOWM3NTE5YWMwYTg2YjMxMTI0YmE3
OWFkMDUxMDJiMzA2ODFkXSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdsZWRzL2Zv
ci1uZXh0JwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1
cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg3L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10
ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS9uZXh0
Om1hc3RlcjpkZTEyOWM3NTE5YWMwYTg2YjMxMTI0YmE3OWFkMDUxMDJiMzA2ODFkOmJpc2Vj
dC1saW51eDcKCjIwMTQtMDctMTctMDU6MTM6MTAgZGUxMjljNzUxOWFjMGE4NmIzMTEyNGJh
NzlhZDA1MTAyYjMwNjgxZCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUtZGUx
MjljNzUxOWFjMGE4NmIzMTEyNGJhNzlhZDA1MTAyYjMwNjgxZApDaGVjayBmb3Iga2VybmVs
IGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L2RlMTI5Yzc1MTlh
YzBhODZiMzExMjRiYTc5YWQwNTEwMmIzMDY4MWQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3
MDE0NS1kZTEyOWM3NTE5YWMwYTg2YjMxMTI0YmE3OWFkMDUxMDJiMzA2ODFkCndhaXRpbmcg
Zm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pdnl0b3duMi1z
bW9rZS94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUtZGUxMjljNzUxOWFjMGE4NmIz
MTEyNGJhNzlhZDA1MTAyYjMwNjgxZAprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaXYxLTA3MTcwMTQ1L2RlMTI5Yzc1MTlhYzBhODZiMzExMjRiYTc5YWQwNTEwMmIzMDY4
MWQvdm1saW51ei0zLjE2LjAtcmM1LTA0MDY2LWdkZTEyOWM3CgoyMDE0LTA3LTE3LTA1OjUx
OjEwIGRldGVjdGluZyBib290IHN0YXRlIC4gVEVTVCBGQUlMVVJFClsgICAgMC4wMDAwMDBd
IFByZWVtcHRpYmxlIGhpZXJhcmNoaWNhbCBSQ1UgaW1wbGVtZW50YXRpb24uClsgICAgMC4w
MDAwMDBdIFJDVTogQWRqdXN0aW5nIGdlb21ldHJ5IGZvciByY3VfZmFub3V0X2xlYWY9MTYs
IG5yX2NwdV9pZHM9MQpbICAgIDAuMDAwMDAwXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0t
LS0tLS0tLS0tLS0KWyAgICAwLjAwMDAwMF0gV0FSTklORzogQ1BVOiAwIFBJRDogMCBhdCAv
a2J1aWxkL3NyYy9zbW9rZS9hcmNoL3g4Ni9rZXJuZWwvY3B1L2NvbW1vbi5jOjE0Mzkgd2Fy
bl9wcmVfYWx0ZXJuYXRpdmVzKzB4MmUvMHg0MCgpClsgICAgMC4wMDAwMDBdIFlvdSdyZSB1
c2luZyBzdGF0aWNfY3B1X2hhcyBiZWZvcmUgYWx0ZXJuYXRpdmVzIGhhdmUgcnVuIQpbICAg
IDAuMDAwMDAwXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAwLjAwMDAwMF0gQ1BVOiAwIFBJ
RDogMCBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xNi4wLXJjNS0wNDA2Ni1nZGUx
MjljNyAjMQpbICAgIDAuMDAwMDAwXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklP
UyBCb2NocyAwMS8wMS8yMDExClsgICAgMC4wMDAwMDBdICAwMDAwMDAwMDAwMDAwMDA5IGZm
ZmZmZmZmODI2MDNiYzggZmZmZmZmZmY4MWNkMzc2ZSBmZmZmZmZmZjgyNjAzYzEwClsgICAg
MC4wMDAwMDBdICBmZmZmZmZmZjgyNjAzYzAwIGZmZmZmZmZmODEwZWEzYzcgMDAwMDAwMDAw
MDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwClsgICAgMC4wMDAwMDBdICAwMDAwMDAwMDAwMDAw
MDAwIGZmZmZmZmZmODI2MTg3MDAgMDAwMDAwMDAwMDAwMDBhOCBmZmZmZmZmZjgyNjAzYzYw
ClsgICAgMC4wMDAwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZm
ODFjZDM3NmU+XSBkdW1wX3N0YWNrKzB4ZDIvMHgxOGUKWyAgICAwLjAwMDAwMF0gIFs8ZmZm
ZmZmZmY4MTBlYTNjNz5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4YzcvMHgxMDAKWyAgICAw
LjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTBlYTRlNz5dIHdhcm5fc2xvd3BhdGhfZm10KzB4NTcv
MHg3MApbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxMDBlNDFkPl0gPyBwcmludF9jb250
ZXh0X3N0YWNrKzB4MTZkLzB4MjEwClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEwMmZl
MGU+XSB3YXJuX3ByZV9hbHRlcm5hdGl2ZXMrMHgyZS8weDQwClsgICAgMC4wMDAwMDBdICBb
PGZmZmZmZmZmODEwODQzZjY+XSBfX2RvX3BhZ2VfZmF1bHQrMHgyYTYvMHgxMTEwClsgICAg
MC4wMDAwMDBdICBbPGZmZmZmZmZmODEwMmIzMmU+XSA/IHNhdmVfc3RhY2tfdHJhY2UrMHgy
ZS8weDgwClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEwODU5MTY+XSB0cmFjZV9kb19w
YWdlX2ZhdWx0KzB4NTU2LzB4NzcwClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEwN2Qy
OGI+XSBkb19hc3luY19wYWdlX2ZhdWx0KzB4M2IvMHgxZDAKWyAgICAwLjAwMDAwMF0gIFs8
ZmZmZmZmZmY4MWNlOWUzOD5dIGFzeW5jX3BhZ2VfZmF1bHQrMHgyOC8weDMwClsgICAgMC4w
MDAwMDBdICBbPGZmZmZmZmZmODE4NjkwMDg+XSA/IF9fYml0bWFwX29yKzB4MzgvMHg1MApb
ICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgzMGJmYTk5Pl0gcmN1X2luaXRfb25lKzB4Nzcz
LzB4YTVjClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODMwYzAzOGM+XSByY3VfaW5pdCsw
eDYwYS8weDZlOQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgzMDkwODkxPl0gc3RhcnRf
a2VybmVsKzB4NDZmLzB4OWY5ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODMwOGZlM2Y+
XSA/IHNldF9pbml0X2FyZysweGVjLzB4ZWMKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4
MzA4ZjEyMD5dID8gZWFybHlfaWR0X2hhbmRsZXJzKzB4MTIwLzB4MTIwClsgICAgMC4wMDAw
MDBdICBbPGZmZmZmZmZmODMwOGY3NzU+XSB4ODZfNjRfc3RhcnRfcmVzZXJ2YXRpb25zKzB4
NjQvMHg2ZApbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgzMDhmOTQzPl0geDg2XzY0X3N0
YXJ0X2tlcm5lbCsweDFjNS8weDFkYgpbICAgIDAuMDAwMDAwXSAtLS1bIGVuZCB0cmFjZSBk
ZjQ5MGQ5OGRmMWM0Zjg0IF0tLS0KWyAgICAwLjAwMDAwMF0gLS0tLS0tLS0tLS0tWyBjdXQg
aGVyZSBdLS0tLS0tLS0tLS0tCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcw
MTQ1L2RlMTI5Yzc1MTlhYzBhODZiMzExMjRiYTc5YWQwNTEwMmIzMDY4MWQvZG1lc2cteW9j
dG8ta2J1aWxkLTEwOjIwMTQwNzE3MDU0OTE1Ong4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3
MDE0NTozLjE2LjAtcmM1LTA0MDY2LWdkZTEyOWM3OjEKMDoxOjEgYWxsX2dvb2Q6YmFkOmFs
bF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDctMTcgMDU6NTE6NDAgUkVQRUFUIENPVU5UOiAy
MCAgIyAvYy9ib290LWJpc2VjdC9saW51eDcvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlz
ZWN0aW5nOiAxNzYgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDggc3RlcHMpCls2N2Q4ZDlmZWM4NmI1ZjM2YTJkYmVjZmRiZThhZGY1OWY0Y2U1OTA2XSBN
ZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICd4ZW4tdGlwL2xpbnV4LW5leHQnCnJ1bm5p
bmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290
LWJpc2VjdC9saW51eDcvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1
ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L25leHQ6bWFzdGVyOjY3ZDhk
OWZlYzg2YjVmMzZhMmRiZWNmZGJlOGFkZjU5ZjRjZTU5MDY6YmlzZWN0LWxpbnV4NwoKMjAx
NC0wNy0xNy0wNTo1MTo0MSA2N2Q4ZDlmZWM4NmI1ZjM2YTJkYmVjZmRiZThhZGY1OWY0Y2U1
OTA2IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS02N2Q4ZDlmZWM4NmI1ZjM2
YTJkYmVjZmRiZThhZGY1OWY0Y2U1OTA2CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUvNjdkOGQ5ZmVjODZiNWYzNmEyZGJlY2Zk
YmU4YWRmNTlmNGNlNTkwNgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1LTY3ZDhkOWZl
Yzg2YjVmMzZhMmRiZWNmZGJlOGFkZjU5ZjRjZTU5MDYKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2l2eXRvd24yLXNtb2tlL3g4Nl82NC1y
YW5kY29uZmlnLWl2MS0wNzE3MDE0NS02N2Q4ZDlmZWM4NmI1ZjM2YTJkYmVjZmRiZThhZGY1
OWY0Y2U1OTA2Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAx
NDUvNjdkOGQ5ZmVjODZiNWYzNmEyZGJlY2ZkYmU4YWRmNTlmNGNlNTkwNi92bWxpbnV6LTMu
MTYuMC1yYzUtMDQwMTktZzY3ZDhkOWYKCjIwMTQtMDctMTctMDY6MzM6NDEgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgLi4gVEVTVCBGQUlMVVJFClsgICAgMC4wMDAwMDBdIFByZWVtcHRpYmxl
IGhpZXJhcmNoaWNhbCBSQ1UgaW1wbGVtZW50YXRpb24uClsgICAgMC4wMDAwMDBdIFJDVTog
QWRqdXN0aW5nIGdlb21ldHJ5IGZvciByY3VfZmFub3V0X2xlYWY9MTYsIG5yX2NwdV9pZHM9
MgpbICAgIDAuMDAwMDAwXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0K
WyAgICAwLjAwMDAwMF0gV0FSTklORzogQ1BVOiAwIFBJRDogMCBhdCAva2J1aWxkL3NyYy9z
bW9rZS9hcmNoL3g4Ni9rZXJuZWwvY3B1L2NvbW1vbi5jOjE0Mzkgd2Fybl9wcmVfYWx0ZXJu
YXRpdmVzKzB4MmUvMHg0MCgpClsgICAgMC4wMDAwMDBdIFlvdSdyZSB1c2luZyBzdGF0aWNf
Y3B1X2hhcyBiZWZvcmUgYWx0ZXJuYXRpdmVzIGhhdmUgcnVuIQpbICAgIDAuMDAwMDAwXSBN
b2R1bGVzIGxpbmtlZCBpbjoKWyAgICAwLjAwMDAwMF0gQ1BVOiAwIFBJRDogMCBDb21tOiBz
d2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xNi4wLXJjNS0wNDAxOS1nNjdkOGQ5ZiAjMQpbICAg
IDAuMDAwMDAwXSBIYXJkd2FyZSBuYW1lOiBRRU1VIFN0YW5kYXJkIFBDIChpNDQwRlggKyBQ
SUlYLCAxOTk2KSwgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMC4wMDAwMDBdICAwMDAw
MDAwMDAwMDAwMDA5IGZmZmZmZmZmODI2MDNiYzggZmZmZmZmZmY4MWNkMzg1ZSBmZmZmZmZm
ZjgyNjAzYzEwClsgICAgMC4wMDAwMDBdICBmZmZmZmZmZjgyNjAzYzAwIGZmZmZmZmZmODEw
ZWEzYzcgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwClsgICAgMC4wMDAwMDBd
ICAwMDAwMDAwMDAwMDAwMDAwIGZmZmZmZmZmODI2MTg3MDAgMDAwMDAwMDAwMDAwMDBhOCBm
ZmZmZmZmZjgyNjAzYzYwClsgICAgMC4wMDAwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4wMDAw
MDBdICBbPGZmZmZmZmZmODFjZDM4NWU+XSBkdW1wX3N0YWNrKzB4ZDIvMHgxOGUKWyAgICAw
LjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTBlYTNjNz5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4
YzcvMHgxMDAKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTBlYTRlNz5dIHdhcm5fc2xv
d3BhdGhfZm10KzB4NTcvMHg3MApbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxMDBlNDFk
Pl0gPyBwcmludF9jb250ZXh0X3N0YWNrKzB4MTZkLzB4MjEwClsgICAgMC4wMDAwMDBdICBb
PGZmZmZmZmZmODEwMmZlMGU+XSB3YXJuX3ByZV9hbHRlcm5hdGl2ZXMrMHgyZS8weDQwClsg
ICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEwODQzZjY+XSBfX2RvX3BhZ2VfZmF1bHQrMHgy
YTYvMHgxMTEwClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEwODU5MTY+XSB0cmFjZV9k
b19wYWdlX2ZhdWx0KzB4NTU2LzB4NzcwClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEw
N2QyOGI+XSBkb19hc3luY19wYWdlX2ZhdWx0KzB4M2IvMHgxZDAKWyAgICAwLjAwMDAwMF0g
IFs8ZmZmZmZmZmY4MWNlOWYzOD5dIGFzeW5jX3BhZ2VfZmF1bHQrMHgyOC8weDMwClsgICAg
MC4wMDAwMDBdICBbPGZmZmZmZmZmODE4NjkxMjg+XSA/IF9fYml0bWFwX29yKzB4MzgvMHg1
MApbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgzMGJmYTk5Pl0gcmN1X2luaXRfb25lKzB4
NzczLzB4YTVjClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODMwYzAzOGM+XSByY3VfaW5p
dCsweDYwYS8weDZlOQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgzMDkwODkxPl0gc3Rh
cnRfa2VybmVsKzB4NDZmLzB4OWY5ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODMwOGZl
M2Y+XSA/IHNldF9pbml0X2FyZysweGVjLzB4ZWMKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZm
ZmY4MzA4ZjEyMD5dID8gZWFybHlfaWR0X2hhbmRsZXJzKzB4MTIwLzB4MTIwClsgICAgMC4w
MDAwMDBdICBbPGZmZmZmZmZmODMwOGY3NzU+XSB4ODZfNjRfc3RhcnRfcmVzZXJ2YXRpb25z
KzB4NjQvMHg2ZApbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgzMDhmOTQzPl0geDg2XzY0
X3N0YXJ0X2tlcm5lbCsweDFjNS8weDFkYgpbICAgIDAuMDAwMDAwXSAtLS1bIGVuZCB0cmFj
ZSAwNjUxODE0NjhiMzdmNmE2IF0tLS0KWyAgICAwLjAwMDAwMF0gLS0tLS0tLS0tLS0tWyBj
dXQgaGVyZSBdLS0tLS0tLS0tLS0tCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3
MTcwMTQ1LzY3ZDhkOWZlYzg2YjVmMzZhMmRiZWNmZGJlOGFkZjU5ZjRjZTU5MDYvZG1lc2ct
cXVhbnRhbC1pdmI0NC0xMjoyMDE0MDcxNzA2MzQxMzp4ODZfNjQtcmFuZGNvbmZpZy1pdjEt
MDcxNzAxNDU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS82N2Q4
ZDlmZWM4NmI1ZjM2YTJkYmVjZmRiZThhZGY1OWY0Y2U1OTA2L2RtZXNnLXF1YW50YWwtaXZi
NDQtNTA6MjAxNDA3MTcwNjM0MTI6eDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1OjoK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUvNjdkOGQ5ZmVjODZiNWYz
NmEyZGJlY2ZkYmU4YWRmNTlmNGNlNTkwNi9kbWVzZy1xdWFudGFsLWl2YjQ0LTg1OjIwMTQw
NzE3MDYzNDE1Ong4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NTo6CjA6MzozIGFsbF9n
b29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA3LTE3IDA2OjM0OjQyIFJFUEVB
VCBDT1VOVDogMjAgICMgL2MvYm9vdC1iaXNlY3QvbGludXg3L29iai1iaXNlY3QvLnJlcGVh
dBtbMG0KCkJpc2VjdGluZzogMTI5IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSA4IHN0ZXBzKQpbZjkyNzRjNzU3Njg0OGE5ZjAzODVhNDIwNmM2Yjc4YmJm
NDBkYTU0ZV0gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAna3ZtL2xpbnV4LW5leHQn
CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAv
Yy9ib290LWJpc2VjdC9saW51eDcvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1
bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L25leHQ6bWFzdGVy
OmY5Mjc0Yzc1NzY4NDhhOWYwMzg1YTQyMDZjNmI3OGJiZjQwZGE1NGU6YmlzZWN0LWxpbnV4
NwoKMjAxNC0wNy0xNy0wNjozNDo0MiBmOTI3NGM3NTc2ODQ4YTlmMDM4NWE0MjA2YzZiNzhi
YmY0MGRhNTRlIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS1mOTI3NGM3NTc2
ODQ4YTlmMDM4NWE0MjA2YzZiNzhiYmY0MGRhNTRlCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUvZjkyNzRjNzU3Njg0OGE5ZjAz
ODVhNDIwNmM2Yjc4YmJmNDBkYTU0ZQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1LWY5
Mjc0Yzc1NzY4NDhhOWYwMzg1YTQyMDZjNmI3OGJiZjQwZGE1NGUKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2l2eXRvd24yLXNtb2tlL3g4
Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS1mOTI3NGM3NTc2ODQ4YTlmMDM4NWE0MjA2
YzZiNzhiYmY0MGRhNTRlCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjEt
MDcxNzAxNDUvZjkyNzRjNzU3Njg0OGE5ZjAzODVhNDIwNmM2Yjc4YmJmNDBkYTU0ZS92bWxp
bnV6LTMuMTYuMC1yYzUtMDM5NzgtZ2Y5Mjc0YzcKCjIwMTQtMDctMTctMDY6NTE6NDIgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgLiBURVNUIEZBSUxVUkUKWyAgICAwLjAwMDAwMF0gUHJlZW1w
dGlibGUgaGllcmFyY2hpY2FsIFJDVSBpbXBsZW1lbnRhdGlvbi4KWyAgICAwLjAwMDAwMF0g
UkNVOiBBZGp1c3RpbmcgZ2VvbWV0cnkgZm9yIHJjdV9mYW5vdXRfbGVhZj0xNiwgbnJfY3B1
X2lkcz0yClsgICAgMC4wMDAwMDBdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0t
LS0tLQpbICAgIDAuMDAwMDAwXSBXQVJOSU5HOiBDUFU6IDAgUElEOiAwIGF0IC9rYnVpbGQv
c3JjL3Ntb2tlL2FyY2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmM6MTQzOSB3YXJuX3ByZV9h
bHRlcm5hdGl2ZXMrMHgyZS8weDQwKCkKWyAgICAwLjAwMDAwMF0gWW91J3JlIHVzaW5nIHN0
YXRpY19jcHVfaGFzIGJlZm9yZSBhbHRlcm5hdGl2ZXMgaGF2ZSBydW4hClsgICAgMC4wMDAw
MDBdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDAuMDAwMDAwXSBDUFU6IDAgUElEOiAwIENv
bW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE2LjAtcmM1LTAzOTc4LWdmOTI3NGM3ICMx
ClsgICAgMC4wMDAwMDBdIEhhcmR3YXJlIG5hbWU6IFFFTVUgU3RhbmRhcmQgUEMgKGk0NDBG
WCArIFBJSVgsIDE5OTYpLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAwLjAwMDAwMF0g
IDAwMDAwMDAwMDAwMDAwMDkgZmZmZmZmZmY4MjYwM2JjOCBmZmZmZmZmZjgxY2QzODVlIGZm
ZmZmZmZmODI2MDNjMTAKWyAgICAwLjAwMDAwMF0gIGZmZmZmZmZmODI2MDNjMDAgZmZmZmZm
ZmY4MTBlYTNjNyAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjAw
MDAwMF0gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZmZmZmY4MjYxODcwMCAwMDAwMDAwMDAwMDAw
MGE4IGZmZmZmZmZmODI2MDNjNjAKWyAgICAwLjAwMDAwMF0gQ2FsbCBUcmFjZToKWyAgICAw
LjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNkMzg1ZT5dIGR1bXBfc3RhY2srMHhkMi8weDE4ZQpb
ICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxMGVhM2M3Pl0gd2Fybl9zbG93cGF0aF9jb21t
b24rMHhjNy8weDEwMApbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxMGVhNGU3Pl0gd2Fy
bl9zbG93cGF0aF9mbXQrMHg1Ny8weDcwClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEw
MGU0MWQ+XSA/IHByaW50X2NvbnRleHRfc3RhY2srMHgxNmQvMHgyMTAKWyAgICAwLjAwMDAw
MF0gIFs8ZmZmZmZmZmY4MTAyZmUwZT5dIHdhcm5fcHJlX2FsdGVybmF0aXZlcysweDJlLzB4
NDAKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTA4NDNmNj5dIF9fZG9fcGFnZV9mYXVs
dCsweDJhNi8weDExMTAKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTA4NTkxNj5dIHRy
YWNlX2RvX3BhZ2VfZmF1bHQrMHg1NTYvMHg3NzAKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZm
ZmY4MTA3ZDI4Yj5dIGRvX2FzeW5jX3BhZ2VfZmF1bHQrMHgzYi8weDFkMApbICAgIDAuMDAw
MDAwXSAgWzxmZmZmZmZmZjgxY2U5ZjM4Pl0gYXN5bmNfcGFnZV9mYXVsdCsweDI4LzB4MzAK
WyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTg2OTEyOD5dID8gX19iaXRtYXBfb3IrMHgz
OC8weDUwClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODMwYmZhOTk+XSByY3VfaW5pdF9v
bmUrMHg3NzMvMHhhNWMKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MzBjMDM4Yz5dIHJj
dV9pbml0KzB4NjBhLzB4NmU5ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODMwOTA4OTE+
XSBzdGFydF9rZXJuZWwrMHg0NmYvMHg5ZjkKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4
MzA4ZmUzZj5dID8gc2V0X2luaXRfYXJnKzB4ZWMvMHhlYwpbICAgIDAuMDAwMDAwXSAgWzxm
ZmZmZmZmZjgzMDhmMTIwPl0gPyBlYXJseV9pZHRfaGFuZGxlcnMrMHgxMjAvMHgxMjAKWyAg
ICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MzA4Zjc3NT5dIHg4Nl82NF9zdGFydF9yZXNlcnZh
dGlvbnMrMHg2NC8weDZkClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODMwOGY5NDM+XSB4
ODZfNjRfc3RhcnRfa2VybmVsKzB4MWM1LzB4MWRiClsgICAgMC4wMDAwMDBdIC0tLVsgZW5k
IHRyYWNlIDYzMjM1YjBjYzBiZjNiYzcgXS0tLQpbICAgIDAuMDAwMDAwXSAtLS0tLS0tLS0t
LS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1p
djEtMDcxNzAxNDUvZjkyNzRjNzU3Njg0OGE5ZjAzODVhNDIwNmM2Yjc4YmJmNDBkYTU0ZS9k
bWVzZy1xdWFudGFsLWl2YjQzLTExMDoyMDE0MDcxNzA2NTUxODp4ODZfNjQtcmFuZGNvbmZp
Zy1pdjEtMDcxNzAxNDU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0
NS9mOTI3NGM3NTc2ODQ4YTlmMDM4NWE0MjA2YzZiNzhiYmY0MGRhNTRlL2RtZXNnLXlvY3Rv
LWl2YjQxLTEwOToyMDE0MDcxNzA2NTEwNTp4ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAx
NDU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS9mOTI3NGM3NTc2
ODQ4YTlmMDM4NWE0MjA2YzZiNzhiYmY0MGRhNTRlL2RtZXNnLXlvY3RvLWl2YjQxLTg1OjIw
MTQwNzE3MDY1MTA2Ong4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NTo6Ci9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L2Y5Mjc0Yzc1NzY4NDhhOWYwMzg1YTQy
MDZjNmI3OGJiZjQwZGE1NGUvZG1lc2ctcXVhbnRhbC1pdmI0MS0zMToyMDE0MDcxNzA2NTEx
MDp4ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDU6Ogova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWl2MS0wNzE3MDE0NS9mOTI3NGM3NTc2ODQ4YTlmMDM4NWE0MjA2YzZiNzhiYmY0
MGRhNTRlL2RtZXNnLXF1YW50YWwtaXZiNDMtMTE6MjAxNDA3MTcwNjU1MzA6eDg2XzY0LXJh
bmRjb25maWctaXYxLTA3MTcwMTQ1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjEt
MDcxNzAxNDUvZjkyNzRjNzU3Njg0OGE5ZjAzODVhNDIwNmM2Yjc4YmJmNDBkYTU0ZS9kbWVz
Zy1xdWFudGFsLWl2YjQzLTEyNjoyMDE0MDcxNzA2NTUyODp4ODZfNjQtcmFuZGNvbmZpZy1p
djEtMDcxNzAxNDU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS9m
OTI3NGM3NTc2ODQ4YTlmMDM4NWE0MjA2YzZiNzhiYmY0MGRhNTRlL2RtZXNnLXlvY3RvLWl2
YjQzLTE6MjAxNDA3MTcwNjU1MzY6eDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1OjoK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUvZjkyNzRjNzU3Njg0OGE5
ZjAzODVhNDIwNmM2Yjc4YmJmNDBkYTU0ZS9kbWVzZy1xdWFudGFsLWl2YjQxLTExMjoyMDE0
MDcxNzA2NTEyOTp4ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDU6Ogova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS9mOTI3NGM3NTc2ODQ4YTlmMDM4NWE0MjA2
YzZiNzhiYmY0MGRhNTRlL2RtZXNnLXF1YW50YWwtaXZiNDEtMTE1OjIwMTQwNzE3MDY1MTI3
Ong4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaXYxLTA3MTcwMTQ1L2Y5Mjc0Yzc1NzY4NDhhOWYwMzg1YTQyMDZjNmI3OGJiZjQw
ZGE1NGUvZG1lc2ctcXVhbnRhbC1pdmI0My00NzoyMDE0MDcxNzA2NTU0Mjp4ODZfNjQtcmFu
ZGNvbmZpZy1pdjEtMDcxNzAxNDU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0w
NzE3MDE0NS9mOTI3NGM3NTc2ODQ4YTlmMDM4NWE0MjA2YzZiNzhiYmY0MGRhNTRlL2RtZXNn
LXF1YW50YWwtaXZiNDMtNTM6MjAxNDA3MTcwNjU1NDM6eDg2XzY0LXJhbmRjb25maWctaXYx
LTA3MTcwMTQ1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUvZjky
NzRjNzU3Njg0OGE5ZjAzODVhNDIwNmM2Yjc4YmJmNDBkYTU0ZS9kbWVzZy1xdWFudGFsLWl2
YjQzLTkwOjIwMTQwNzE3MDY1NTQzOng4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NTo6
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L2Y5Mjc0Yzc1NzY4NDhh
OWYwMzg1YTQyMDZjNmI3OGJiZjQwZGE1NGUvZG1lc2ctcXVhbnRhbC1pdmI0NC00OjIwMTQw
NzE3MDY1MTAxOng4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NTo6Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L2Y5Mjc0Yzc1NzY4NDhhOWYwMzg1YTQyMDZj
NmI3OGJiZjQwZGE1NGUvZG1lc2ctcXVhbnRhbC1pdmI0NC05NDoyMDE0MDcxNzA2NTEwMjp4
ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWl2MS0wNzE3MDE0NS9mOTI3NGM3NTc2ODQ4YTlmMDM4NWE0MjA2YzZiNzhiYmY0MGRh
NTRlL2RtZXNnLXlvY3RvLWl2YjQzLTc6MjAxNDA3MTcwNjU1NDA6eDg2XzY0LXJhbmRjb25m
aWctaXYxLTA3MTcwMTQ1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAx
NDUvZjkyNzRjNzU3Njg0OGE5ZjAzODVhNDIwNmM2Yjc4YmJmNDBkYTU0ZS9kbWVzZy1xdWFu
dGFsLWl2YjQxLTEwNToyMDE0MDcxNzA2NTEzMDp4ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcx
NzAxNDU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS9mOTI3NGM3
NTc2ODQ4YTlmMDM4NWE0MjA2YzZiNzhiYmY0MGRhNTRlL2RtZXNnLXF1YW50YWwtaXZiNDEt
NDoyMDE0MDcxNzA2NTEyOTp4ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDU6Ogova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS9mOTI3NGM3NTc2ODQ4YTlmMDM4
NWE0MjA2YzZiNzhiYmY0MGRhNTRlL2RtZXNnLXF1YW50YWwtaXZiNDEtNjY6MjAxNDA3MTcw
NjUxMzA6eDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1OjoKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUvZjkyNzRjNzU3Njg0OGE5ZjAzODVhNDIwNmM2Yjc4
YmJmNDBkYTU0ZS9kbWVzZy1xdWFudGFsLWl2YjQxLTk1OjIwMTQwNzE3MDY1MTMwOng4Nl82
NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
aXYxLTA3MTcwMTQ1L2Y5Mjc0Yzc1NzY4NDhhOWYwMzg1YTQyMDZjNmI3OGJiZjQwZGE1NGUv
ZG1lc2ctcXVhbnRhbC1pdmI0My04OToyMDE0MDcxNzA2NTU0Njp4ODZfNjQtcmFuZGNvbmZp
Zy1pdjEtMDcxNzAxNDU6OgowOjIwOjIwIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtb
MTszNW0yMDE0LTA3LTE3IDA2OjUyOjEzIFJFUEVBVCBDT1VOVDogMjAgICMgL2MvYm9vdC1i
aXNlY3QvbGludXg3L29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzogODggcmV2
aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDcgc3RlcHMpCltiZGMy
M2ZiYWI2NGUxMDRiYTY1NmI5MzFkOWVkNmJhOWI0YmMyNWY5XSBNZXJnZSByZW1vdGUtdHJh
Y2tpbmcgYnJhbmNoICdyY3UvcmN1L25leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDcvb2JqLWJp
c2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25m
aWctaXYxLTA3MTcwMTQ1L25leHQ6bWFzdGVyOmJkYzIzZmJhYjY0ZTEwNGJhNjU2YjkzMWQ5
ZWQ2YmE5YjRiYzI1Zjk6YmlzZWN0LWxpbnV4NwoKMjAxNC0wNy0xNy0wNjo1MjoxMyBiZGMy
M2ZiYWI2NGUxMDRiYTY1NmI5MzFkOWVkNmJhOWI0YmMyNWY5IGNvbXBpbGluZwpRdWV1ZWQg
YnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29u
ZmlnLWl2MS0wNzE3MDE0NS1iZGMyM2ZiYWI2NGUxMDRiYTY1NmI5MzFkOWVkNmJhOWI0YmMy
NWY5CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjEt
MDcxNzAxNDUvYmRjMjNmYmFiNjRlMTA0YmE2NTZiOTMxZDllZDZiYTliNGJjMjVmOQp3YWl0
aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0
LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1LWJkYzIzZmJhYjY0ZTEwNGJhNjU2YjkzMWQ5ZWQ2
YmE5YjRiYzI1ZjkKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlL2xrcC1oc3gwMS1jb25zdW1lci94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcx
NzAxNDUtYmRjMjNmYmFiNjRlMTA0YmE2NTZiOTMxZDllZDZiYTliNGJjMjVmOQprZXJuZWw6
IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L2JkYzIzZmJhYjY0ZTEw
NGJhNjU2YjkzMWQ5ZWQ2YmE5YjRiYzI1Zjkvdm1saW51ei0zLjE2LjAtcmM1LTAzOTM3LWdi
ZGMyM2ZiCgoyMDE0LTA3LTE3LTA3OjA3OjEzIGRldGVjdGluZyBib290IHN0YXRlIC4gVEVT
VCBGQUlMVVJFClsgICAgMC4wMDAwMDBdIFByZWVtcHRpYmxlIGhpZXJhcmNoaWNhbCBSQ1Ug
aW1wbGVtZW50YXRpb24uClsgICAgMC4wMDAwMDBdIFJDVTogQWRqdXN0aW5nIGdlb21ldHJ5
IGZvciByY3VfZmFub3V0X2xlYWY9MTYsIG5yX2NwdV9pZHM9MQpbICAgIDAuMDAwMDAwXSAt
LS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAwLjAwMDAwMF0gV0FS
TklORzogQ1BVOiAwIFBJRDogMCBhdCAva2J1aWxkL3NyYy9jb25zdW1lci9hcmNoL3g4Ni9r
ZXJuZWwvY3B1L2NvbW1vbi5jOjE0Mzkgd2Fybl9wcmVfYWx0ZXJuYXRpdmVzKzB4MmUvMHg0
MCgpClsgICAgMC4wMDAwMDBdIFlvdSdyZSB1c2luZyBzdGF0aWNfY3B1X2hhcyBiZWZvcmUg
YWx0ZXJuYXRpdmVzIGhhdmUgcnVuIQpbICAgIDAuMDAwMDAwXSBNb2R1bGVzIGxpbmtlZCBp
bjoKWyAgICAwLjAwMDAwMF0gQ1BVOiAwIFBJRDogMCBDb21tOiBzd2FwcGVyLzAgTm90IHRh
aW50ZWQgMy4xNi4wLXJjNS0wMzkzNy1nYmRjMjNmYiAjMQpbICAgIDAuMDAwMDAwXSBIYXJk
d2FyZSBuYW1lOiBRRU1VIFN0YW5kYXJkIFBDIChpNDQwRlggKyBQSUlYLCAxOTk2KSwgQklP
UyBCb2NocyAwMS8wMS8yMDExClsgICAgMC4wMDAwMDBdICAwMDAwMDAwMDAwMDAwMDA5IGZm
ZmZmZmZmODI2MDNiYzggZmZmZmZmZmY4MWNkMzg1ZSBmZmZmZmZmZjgyNjAzYzEwClsgICAg
MC4wMDAwMDBdICBmZmZmZmZmZjgyNjAzYzAwIGZmZmZmZmZmODEwZWEzYzcgMDAwMDAwMDAw
MDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwClsgICAgMC4wMDAwMDBdICAwMDAwMDAwMDAwMDAw
MDAwIGZmZmZmZmZmODI2MTg3MDAgMDAwMDAwMDAwMDAwMDBhOCBmZmZmZmZmZjgyNjAzYzYw
ClsgICAgMC4wMDAwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZm
ODFjZDM4NWU+XSBkdW1wX3N0YWNrKzB4ZDIvMHgxOGUKWyAgICAwLjAwMDAwMF0gIFs8ZmZm
ZmZmZmY4MTBlYTNjNz5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4YzcvMHgxMDAKWyAgICAw
LjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTBlYTRlNz5dIHdhcm5fc2xvd3BhdGhfZm10KzB4NTcv
MHg3MApbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxMDBlNDFkPl0gPyBwcmludF9jb250
ZXh0X3N0YWNrKzB4MTZkLzB4MjEwClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEwMmZl
MGU+XSB3YXJuX3ByZV9hbHRlcm5hdGl2ZXMrMHgyZS8weDQwClsgICAgMC4wMDAwMDBdICBb
PGZmZmZmZmZmODEwODQzZjY+XSBfX2RvX3BhZ2VfZmF1bHQrMHgyYTYvMHgxMTEwClsgICAg
MC4wMDAwMDBdICBbPGZmZmZmZmZmODEwMmIzMmU+XSA/IHNhdmVfc3RhY2tfdHJhY2UrMHgy
ZS8weDgwClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEwODU5MTY+XSB0cmFjZV9kb19w
YWdlX2ZhdWx0KzB4NTU2LzB4NzcwClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEwN2Qy
OGI+XSBkb19hc3luY19wYWdlX2ZhdWx0KzB4M2IvMHgxZDAKWyAgICAwLjAwMDAwMF0gIFs8
ZmZmZmZmZmY4MWNlOWYzOD5dIGFzeW5jX3BhZ2VfZmF1bHQrMHgyOC8weDMwClsgICAgMC4w
MDAwMDBdICBbPGZmZmZmZmZmODE4NjkxMjg+XSA/IF9fYml0bWFwX29yKzB4MzgvMHg1MApb
ICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgzMGJmYTk5Pl0gcmN1X2luaXRfb25lKzB4Nzcz
LzB4YTVjClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODMwYzAzOGM+XSByY3VfaW5pdCsw
eDYwYS8weDZlOQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgzMDkwODkxPl0gc3RhcnRf
a2VybmVsKzB4NDZmLzB4OWY5ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODMwOGZlM2Y+
XSA/IHNldF9pbml0X2FyZysweGVjLzB4ZWMKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4
MzA4ZjEyMD5dID8gZWFybHlfaWR0X2hhbmRsZXJzKzB4MTIwLzB4MTIwClsgICAgMC4wMDAw
MDBdICBbPGZmZmZmZmZmODMwOGY3NzU+XSB4ODZfNjRfc3RhcnRfcmVzZXJ2YXRpb25zKzB4
NjQvMHg2ZApbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgzMDhmOTQzPl0geDg2XzY0X3N0
YXJ0X2tlcm5lbCsweDFjNS8weDFkYgpbICAgIDAuMDAwMDAwXSAtLS1bIGVuZCB0cmFjZSAz
ZDAwZTM5MzUxMDE4YzkyIF0tLS0KWyAgICAwLjAwMDAwMF0gLS0tLS0tLS0tLS0tWyBjdXQg
aGVyZSBdLS0tLS0tLS0tLS0tCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcw
MTQ1L2JkYzIzZmJhYjY0ZTEwNGJhNjU2YjkzMWQ5ZWQ2YmE5YjRiYzI1ZjkvZG1lc2cteW9j
dG8taXZiNDQtMTAxOjIwMTQwNzE3MDcwNjM0Ong4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3
MDE0NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L2JkYzIzZmJh
YjY0ZTEwNGJhNjU2YjkzMWQ5ZWQ2YmE5YjRiYzI1ZjkvZG1lc2cteW9jdG8taXZiNDQtMTE6
MjAxNDA3MTcwNzA2MzQ6eDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1OjoKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUvYmRjMjNmYmFiNjRlMTA0YmE2NTZi
OTMxZDllZDZiYTliNGJjMjVmOS9kbWVzZy15b2N0by1pdmI0NC0xMjE6MjAxNDA3MTcwNzA2
MzQ6eDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1OjoKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1pdjEtMDcxNzAxNDUvYmRjMjNmYmFiNjRlMTA0YmE2NTZiOTMxZDllZDZiYTli
NGJjMjVmOS9kbWVzZy15b2N0by1pdmI0NC0xMjoyMDE0MDcxNzA3MDYzNDp4ODZfNjQtcmFu
ZGNvbmZpZy1pdjEtMDcxNzAxNDU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0w
NzE3MDE0NS9iZGMyM2ZiYWI2NGUxMDRiYTY1NmI5MzFkOWVkNmJhOWI0YmMyNWY5L2RtZXNn
LXlvY3RvLWl2YjQ0LTE0OjIwMTQwNzE3MDcwNjM0Ong4Nl82NC1yYW5kY29uZmlnLWl2MS0w
NzE3MDE0NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L2JkYzIz
ZmJhYjY0ZTEwNGJhNjU2YjkzMWQ5ZWQ2YmE5YjRiYzI1ZjkvZG1lc2cteW9jdG8taXZiNDQt
MTc6MjAxNDA3MTcwNzA2MzQ6eDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1OjoKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUvYmRjMjNmYmFiNjRlMTA0YmE2
NTZiOTMxZDllZDZiYTliNGJjMjVmOS9kbWVzZy15b2N0by1pdmI0NC0yMToyMDE0MDcxNzA3
MDYzMzp4ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDU6Ogova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWl2MS0wNzE3MDE0NS9iZGMyM2ZiYWI2NGUxMDRiYTY1NmI5MzFkOWVkNmJh
OWI0YmMyNWY5L2RtZXNnLXlvY3RvLWl2YjQ0LTMyOjIwMTQwNzE3MDcwNjM0Ong4Nl82NC1y
YW5kY29uZmlnLWl2MS0wNzE3MDE0NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYx
LTA3MTcwMTQ1L2JkYzIzZmJhYjY0ZTEwNGJhNjU2YjkzMWQ5ZWQ2YmE5YjRiYzI1ZjkvZG1l
c2cteW9jdG8taXZiNDQtMzg6MjAxNDA3MTcwNzA2MzQ6eDg2XzY0LXJhbmRjb25maWctaXYx
LTA3MTcwMTQ1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUvYmRj
MjNmYmFiNjRlMTA0YmE2NTZiOTMxZDllZDZiYTliNGJjMjVmOS9kbWVzZy15b2N0by1pdmI0
NC00NToyMDE0MDcxNzA3MDYzNDp4ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDU6Ogov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS9iZGMyM2ZiYWI2NGUxMDRi
YTY1NmI5MzFkOWVkNmJhOWI0YmMyNWY5L2RtZXNnLXlvY3RvLWl2YjQ0LTUzOjIwMTQwNzE3
MDcwNjM0Ong4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NTo6Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L2JkYzIzZmJhYjY0ZTEwNGJhNjU2YjkzMWQ5ZWQ2
YmE5YjRiYzI1ZjkvZG1lc2cteW9jdG8taXZiNDQtNTU6MjAxNDA3MTcwNzA2MzQ6eDg2XzY0
LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1p
djEtMDcxNzAxNDUvYmRjMjNmYmFiNjRlMTA0YmE2NTZiOTMxZDllZDZiYTliNGJjMjVmOS9k
bWVzZy15b2N0by1pdmI0NC02ODoyMDE0MDcxNzA3MDYzNDp4ODZfNjQtcmFuZGNvbmZpZy1p
djEtMDcxNzAxNDU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS9i
ZGMyM2ZiYWI2NGUxMDRiYTY1NmI5MzFkOWVkNmJhOWI0YmMyNWY5L2RtZXNnLXlvY3RvLWl2
YjQ0LTY5OjIwMTQwNzE3MDcwNjM0Ong4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NTo6
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L2JkYzIzZmJhYjY0ZTEw
NGJhNjU2YjkzMWQ5ZWQ2YmE5YjRiYzI1ZjkvZG1lc2cteW9jdG8taXZiNDQtNzk6MjAxNDA3
MTcwNzA2MzQ6eDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1OjoKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUvYmRjMjNmYmFiNjRlMTA0YmE2NTZiOTMxZDll
ZDZiYTliNGJjMjVmOS9kbWVzZy15b2N0by1pdmI0NC04NDoyMDE0MDcxNzA3MDYzNDp4ODZf
NjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWl2MS0wNzE3MDE0NS9iZGMyM2ZiYWI2NGUxMDRiYTY1NmI5MzFkOWVkNmJhOWI0YmMyNWY5
L2RtZXNnLXlvY3RvLWl2YjQ0LTg1OjIwMTQwNzE3MDcwNjM0Ong4Nl82NC1yYW5kY29uZmln
LWl2MS0wNzE3MDE0NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1
L2JkYzIzZmJhYjY0ZTEwNGJhNjU2YjkzMWQ5ZWQ2YmE5YjRiYzI1ZjkvZG1lc2cteW9jdG8t
aXZiNDQtODg6MjAxNDA3MTcwNzA2MzQ6eDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1
OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUvYmRjMjNmYmFiNjRl
MTA0YmE2NTZiOTMxZDllZDZiYTliNGJjMjVmOS9kbWVzZy15b2N0by1pdmI0NC05MToyMDE0
MDcxNzA3MDYzNDp4ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDU6Ogova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS9iZGMyM2ZiYWI2NGUxMDRiYTY1NmI5MzFk
OWVkNmJhOWI0YmMyNWY5L2RtZXNnLXlvY3RvLWl2YjQ0LTkzOjIwMTQwNzE3MDcwNjM0Ong4
Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NTo6CjA6MjA6MjAgYWxsX2dvb2Q6YmFkOmFs
bF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDctMTcgMDc6MDc6NDQgUkVQRUFUIENPVU5UOiAy
MCAgIyAvYy9ib290LWJpc2VjdC9saW51eDcvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKbGlu
ZWFyLWJpc2VjdDogYmFkIGJyYW5jaCBtYXkgYmUgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAn
cmN1L3JjdS9uZXh0JwpsaW5lYXItYmlzZWN0OiBoYW5kbGUgb3ZlciB0byBnaXQgYmlzZWN0
CmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3Qgc3RhcnQgYmRjMjNmYmFiNjRlMTA0YmE2NTZi
OTMxZDllZDZiYTliNGJjMjVmOSBhMzcxNDAxMzBlODE2YWI3OTY1NjQ1YmI3ZjVkMmQ2MmU2
ZWQzNGNhIC0tClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGJkYzIzZmIuLi4gTWVyZ2Ug
cmVtb3RlLXRyYWNraW5nIGJyYW5jaCAncmN1L3JjdS9uZXh0JwpIRUFEIGlzIG5vdyBhdCA4
Yjk0OTk3Li4uIE1lcmdlICdrZWVzL2xzbS1tbnQtcmVzdHJpY3QnIGludG8gZGV2ZWwtaG91
cmx5LTIwMTQwNjA5MTAKQmlzZWN0aW5nOiAzMSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgNSBzdGVwcykKW2I0MWQxYjkyNGQwYmQ0MWEyMjVhMTdmMzky
OTdiOWRlMGRjYTkzZDldIHJjdTogRml4IGEgc3BhcnNlIHdhcm5pbmcgaW4gcmN1X3JlcG9y
dF91bmJsb2NrX3FzX3JucCgpCmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3QgcnVuIC9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3Qv
bGludXg3L29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4Ny9vYmotYmlzZWN0CmxzIC1h
IC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcx
NzAxNDUvbmV4dDptYXN0ZXI6YjQxZDFiOTI0ZDBiZDQxYTIyNWExN2YzOTI5N2I5ZGUwZGNh
OTNkOTpiaXNlY3QtbGludXg3CgoyMDE0LTA3LTE3LTA3OjA4OjAxIGI0MWQxYjkyNGQwYmQ0
MWEyMjVhMTdmMzkyOTdiOWRlMGRjYTkzZDkgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNr
IHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaXYxLTA3
MTcwMTQ1LWI0MWQxYjkyNGQwYmQ0MWEyMjVhMTdmMzkyOTdiOWRlMGRjYTkzZDkKQ2hlY2sg
Zm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS9i
NDFkMWI5MjRkMGJkNDFhMjI1YTE3ZjM5Mjk3YjlkZTBkY2E5M2Q5CndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZp
Zy1pdjEtMDcxNzAxNDUtYjQxZDFiOTI0ZDBiZDQxYTIyNWExN2YzOTI5N2I5ZGUwZGNhOTNk
OQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUv
aXZ5dG93bjItc21va2UveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1LWI0MWQxYjky
NGQwYmQ0MWEyMjVhMTdmMzkyOTdiOWRlMGRjYTkzZDkKa2VybmVsOiAva2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS9iNDFkMWI5MjRkMGJkNDFhMjI1YTE3ZjM5Mjk3
YjlkZTBkY2E5M2Q5L3ZtbGludXotMy4xNi4wLXJjMS0wMDAxOS1nYjQxZDFiOQoKMjAxNC0w
Ny0xNy0wNzoxNDowMSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgk1CTEzCTIwIFNVQ0NFU1MK
CkJpc2VjdGluZzogMTUgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3Vn
aGx5IDQgc3RlcHMpCltlNWNhOTcwNTE2OGQwMTY3Y2U2ODM2MTA0NTQyMmFjZDEyOTQxYmUw
XSByY3U6IFJlbW92ZSByZW1haW5pbmcgcmVhZC1tb2RpZnktd3JpdGUgQUNDRVNTX09OQ0Uo
KSBjYWxscwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1
cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg3L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10
ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS9uZXh0
Om1hc3RlcjplNWNhOTcwNTE2OGQwMTY3Y2U2ODM2MTA0NTQyMmFjZDEyOTQxYmUwOmJpc2Vj
dC1saW51eDcKCjIwMTQtMDctMTctMDc6MTY6MzIgZTVjYTk3MDUxNjhkMDE2N2NlNjgzNjEw
NDU0MjJhY2QxMjk0MWJlMCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUtZTVj
YTk3MDUxNjhkMDE2N2NlNjgzNjEwNDU0MjJhY2QxMjk0MWJlMApDaGVjayBmb3Iga2VybmVs
IGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L2U1Y2E5NzA1MTY4
ZDAxNjdjZTY4MzYxMDQ1NDIyYWNkMTI5NDFiZTAKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3
MDE0NS1lNWNhOTcwNTE2OGQwMTY3Y2U2ODM2MTA0NTQyMmFjZDEyOTQxYmUwCndhaXRpbmcg
Zm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9qYWtldG93bi1j
b25zdW1lci94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUtZTVjYTk3MDUxNjhkMDE2
N2NlNjgzNjEwNDU0MjJhY2QxMjk0MWJlMAprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaXYxLTA3MTcwMTQ1L2U1Y2E5NzA1MTY4ZDAxNjdjZTY4MzYxMDQ1NDIyYWNkMTI5
NDFiZTAvdm1saW51ei0zLjE2LjAtcmMxLTAwMDM1LWdlNWNhOTcwCgoyMDE0LTA3LTE3LTA4
OjA3OjMyIGRldGVjdGluZyBib290IHN0YXRlIAkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDcg
cmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMpCltm
MmM4YmJkM2UwNjIwNmI3YWY4MzZkNjJlY2U1ZmM3M2MzOTNhM2Y2XSByY3U6IFJldHVybiBm
YWxzZSBpbnN0ZWFkIG9mIDAgaW4gcmN1X25vY2JfYWRvcHRfb3JwaGFuX2NicygpCnJ1bm5p
bmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290
LWJpc2VjdC9saW51eDcvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1
ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L25leHQ6bWFzdGVyOmYyYzhi
YmQzZTA2MjA2YjdhZjgzNmQ2MmVjZTVmYzczYzM5M2EzZjY6YmlzZWN0LWxpbnV4NwoKMjAx
NC0wNy0xNy0wODowODowMiBmMmM4YmJkM2UwNjIwNmI3YWY4MzZkNjJlY2U1ZmM3M2MzOTNh
M2Y2IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS1mMmM4YmJkM2UwNjIwNmI3
YWY4MzZkNjJlY2U1ZmM3M2MzOTNhM2Y2CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUvZjJjOGJiZDNlMDYyMDZiN2FmODM2ZDYy
ZWNlNWZjNzNjMzkzYTNmNgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1LWYyYzhiYmQz
ZTA2MjA2YjdhZjgzNmQ2MmVjZTVmYzczYzM5M2EzZjYKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2l2eXRvd24yLXNtb2tlL3g4Nl82NC1y
YW5kY29uZmlnLWl2MS0wNzE3MDE0NS1mMmM4YmJkM2UwNjIwNmI3YWY4MzZkNjJlY2U1ZmM3
M2MzOTNhM2Y2Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAx
NDUvZjJjOGJiZDNlMDYyMDZiN2FmODM2ZDYyZWNlNWZjNzNjMzkzYTNmNi92bWxpbnV6LTMu
MTYuMC1yYzEtMDAwNDMtZ2YyYzhiYmQKCjIwMTQtMDctMTctMDg6Mjk6MDIgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMyByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMiBzdGVwcykKWzEwNGM2ZDhmYTk0NTUzYjFi
NTFmNWQ4MDk0ZTYxOWU0YWExMjBiMDhdIHJjdXRvcnR1cmU6IFVzZSBiYXNoIHNoZWxsIGZv
ciBhbGwgdGhlIHRlc3Qgc2NyaXB0cwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg3L29iai1iaXNlY3QK
bHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWl2
MS0wNzE3MDE0NS9uZXh0Om1hc3RlcjoxMDRjNmQ4ZmE5NDU1M2IxYjUxZjVkODA5NGU2MTll
NGFhMTIwYjA4OmJpc2VjdC1saW51eDcKCjIwMTQtMDctMTctMDg6Mjk6MzMgMTA0YzZkOGZh
OTQ1NTNiMWI1MWY1ZDgwOTRlNjE5ZTRhYTEyMGIwOCBjb21waWxpbmcKUXVldWVkIGJ1aWxk
IHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1p
djEtMDcxNzAxNDUtMTA0YzZkOGZhOTQ1NTNiMWI1MWY1ZDgwOTRlNjE5ZTRhYTEyMGIwOApD
aGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcw
MTQ1LzEwNGM2ZDhmYTk0NTUzYjFiNTFmNWQ4MDk0ZTYxOWU0YWExMjBiMDgKd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5k
Y29uZmlnLWl2MS0wNzE3MDE0NS0xMDRjNmQ4ZmE5NDU1M2IxYjUxZjVkODA5NGU2MTllNGFh
MTIwYjA4CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS9pdnl0b3duMi1zbW9rZS94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUtMTA0
YzZkOGZhOTQ1NTNiMWI1MWY1ZDgwOTRlNjE5ZTRhYTEyMGIwOAprZXJuZWw6IC9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1LzEwNGM2ZDhmYTk0NTUzYjFiNTFmNWQ4
MDk0ZTYxOWU0YWExMjBiMDgvdm1saW51ei0zLjE2LjAtcmMxLTAwMDQ3LWcxMDRjNmQ4Cgoy
MDE0LTA3LTE3LTA4OjM0OjMzIGRldGVjdGluZyBib290IHN0YXRlIAkyMCBTVUNDRVNTCgpC
aXNlY3Rpbmc6IDEgcmV2aXNpb24gbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
MSBzdGVwKQpbMDhlOGVhMWI0NWMyZjYyYWFkYzZkZmY3M2FkZTI5NDJhMjgwMzBiYl0gcmN1
OiBSYXRpb25hbGl6ZSBrdGhyZWFkIHNwYXduaW5nCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDcvb2Jq
LWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRj
b25maWctaXYxLTA3MTcwMTQ1L25leHQ6bWFzdGVyOjA4ZThlYTFiNDVjMmY2MmFhZGM2ZGZm
NzNhZGUyOTQyYTI4MDMwYmI6YmlzZWN0LWxpbnV4NwoKMjAxNC0wNy0xNy0wODozNTowNCAw
OGU4ZWExYjQ1YzJmNjJhYWRjNmRmZjczYWRlMjk0MmEyODAzMGJiIGNvbXBpbGluZwpRdWV1
ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5k
Y29uZmlnLWl2MS0wNzE3MDE0NS0wOGU4ZWExYjQ1YzJmNjJhYWRjNmRmZjczYWRlMjk0MmEy
ODAzMGJiCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1p
djEtMDcxNzAxNDUvMDhlOGVhMWI0NWMyZjYyYWFkYzZkZmY3M2FkZTI5NDJhMjgwMzBiYgp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2
XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1LTA4ZThlYTFiNDVjMmY2MmFhZGM2ZGZmNzNh
ZGUyOTQyYTI4MDMwYmIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL2l2eXRvd24yLXNtb2tlL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3
MDE0NS0wOGU4ZWExYjQ1YzJmNjJhYWRjNmRmZjczYWRlMjk0MmEyODAzMGJiCmtlcm5lbDog
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUvMDhlOGVhMWI0NWMyZjYy
YWFkYzZkZmY3M2FkZTI5NDJhMjgwMzBiYi92bWxpbnV6LTMuMTYuMC1yYzEtMDAwNDktZzA4
ZThlYTEKCjIwMTQtMDctMTctMDg6NDE6MDQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTIwIFNV
Q0NFU1MKCkJpc2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgMCBzdGVwcykKW2RkZmIzYjM2MzQ0MDE3MmQ2MmNlNjJmYmZmZGYwNDY2NzBk
M2NlMmJdIHJjdTogQ3JlYXRlIHJjdW8ga3RocmVhZHMgb25seSBmb3Igb25saW5lZCBDUFVz
CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAv
Yy9ib290LWJpc2VjdC9saW51eDcvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1
bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L25leHQ6bWFzdGVy
OmRkZmIzYjM2MzQ0MDE3MmQ2MmNlNjJmYmZmZGYwNDY2NzBkM2NlMmI6YmlzZWN0LWxpbnV4
NwoKMjAxNC0wNy0xNy0wODo0MTozNCBkZGZiM2IzNjM0NDAxNzJkNjJjZTYyZmJmZmRmMDQ2
NjcwZDNjZTJiIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS1kZGZiM2IzNjM0
NDAxNzJkNjJjZTYyZmJmZmRmMDQ2NjcwZDNjZTJiCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUvZGRmYjNiMzYzNDQwMTcyZDYy
Y2U2MmZiZmZkZjA0NjY3MGQzY2UyYgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1LWRk
ZmIzYjM2MzQ0MDE3MmQ2MmNlNjJmYmZmZGYwNDY2NzBkM2NlMmIKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2l2eXRvd24yLXNtb2tlL3g4
Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS1kZGZiM2IzNjM0NDAxNzJkNjJjZTYyZmJm
ZmRmMDQ2NjcwZDNjZTJiCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjEt
MDcxNzAxNDUvZGRmYjNiMzYzNDQwMTcyZDYyY2U2MmZiZmZkZjA0NjY3MGQzY2UyYi92bWxp
bnV6LTMuMTYuMC1yYzEtMDAwNTAtZ2RkZmIzYjMKCjIwMTQtMDctMTctMDg6NDY6MzQgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgLiBURVNUIEZBSUxVUkUKWyAgICAwLjAwMDAwMF0gUHJlZW1w
dGlibGUgaGllcmFyY2hpY2FsIFJDVSBpbXBsZW1lbnRhdGlvbi4KWyAgICAwLjAwMDAwMF0g
UkNVOiBBZGp1c3RpbmcgZ2VvbWV0cnkgZm9yIHJjdV9mYW5vdXRfbGVhZj0xNiwgbnJfY3B1
X2lkcz0yClsgICAgMC4wMDAwMDBdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0t
LS0tLQpbICAgIDAuMDAwMDAwXSBXQVJOSU5HOiBDUFU6IDAgUElEOiAwIGF0IC9rYnVpbGQv
c3JjL3Ntb2tlL2FyY2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmM6MTQyMiB3YXJuX3ByZV9h
bHRlcm5hdGl2ZXMrMHgyZS8weDQwKCkKWyAgICAwLjAwMDAwMF0gWW91J3JlIHVzaW5nIHN0
YXRpY19jcHVfaGFzIGJlZm9yZSBhbHRlcm5hdGl2ZXMgaGF2ZSBydW4hClsgICAgMC4wMDAw
MDBdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDAuMDAwMDAwXSBDUFU6IDAgUElEOiAwIENv
bW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE2LjAtcmMxLTAwMDUwLWdkZGZiM2IzICMx
ClsgICAgMC4wMDAwMDBdIEhhcmR3YXJlIG5hbWU6IFFFTVUgU3RhbmRhcmQgUEMgKGk0NDBG
WCArIFBJSVgsIDE5OTYpLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAwLjAwMDAwMF0g
IDAwMDAwMDAwMDAwMDAwMDkgZmZmZmZmZmY4MjYwM2JjOCBmZmZmZmZmZjgxY2NhODBkIGZm
ZmZmZmZmODI2MDNjMTAKWyAgICAwLjAwMDAwMF0gIGZmZmZmZmZmODI2MDNjMDAgZmZmZmZm
ZmY4MTBlNjYyNyAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjAw
MDAwMF0gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZmZmZmY4MjYxODZjMCAwMDAwMDAwMDAwMDAw
MGE4IGZmZmZmZmZmODI2MDNjNjAKWyAgICAwLjAwMDAwMF0gQ2FsbCBUcmFjZToKWyAgICAw
LjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNjYTgwZD5dIGR1bXBfc3RhY2srMHhkMi8weDE4ZQpb
ICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxMGU2NjI3Pl0gd2Fybl9zbG93cGF0aF9jb21t
b24rMHhjNy8weDEwMApbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxMGU2NzQ3Pl0gd2Fy
bl9zbG93cGF0aF9mbXQrMHg1Ny8weDcwClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEw
MGUyM2Q+XSA/IHByaW50X2NvbnRleHRfc3RhY2srMHgxNmQvMHgyMTAKWyAgICAwLjAwMDAw
MF0gIFs8ZmZmZmZmZmY4MTAyZjY5ZT5dIHdhcm5fcHJlX2FsdGVybmF0aXZlcysweDJlLzB4
NDAKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTA4MzliNj5dIF9fZG9fcGFnZV9mYXVs
dCsweDJhNi8weDExMTAKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTE2YzExMj5dID8g
c2NoZWRfY2xvY2tfY3B1KzB4NjIvMHgyYjAKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4
MTA4NGVkNj5dIHRyYWNlX2RvX3BhZ2VfZmF1bHQrMHg1NTYvMHg3NzAKWyAgICAwLjAwMDAw
MF0gIFs8ZmZmZmZmZmY4MTA3Yzg0Yj5dIGRvX2FzeW5jX3BhZ2VfZmF1bHQrMHgzYi8weDFk
MApbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2UwZDc4Pl0gYXN5bmNfcGFnZV9mYXVs
dCsweDI4LzB4MzAKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTg2MGU3OD5dID8gX19i
aXRtYXBfb3IrMHgzOC8weDUwClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODMwYmQ2NjY+
XSByY3VfaW5pdF9vbmUrMHg3NzMvMHhhNWMKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4
MzBiZGY1OT5dIHJjdV9pbml0KzB4NjBhLzB4NmU5ClsgICAgMC4wMDAwMDBdICBbPGZmZmZm
ZmZmODMwOGQ4OTE+XSBzdGFydF9rZXJuZWwrMHg0NmYvMHg5ZjkKWyAgICAwLjAwMDAwMF0g
IFs8ZmZmZmZmZmY4MzA4Y2UzZj5dID8gc2V0X2luaXRfYXJnKzB4ZWMvMHhlYwpbICAgIDAu
MDAwMDAwXSAgWzxmZmZmZmZmZjgzMDhjMTIwPl0gPyBlYXJseV9pZHRfaGFuZGxlcnMrMHgx
MjAvMHgxMjAKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MzA4Yzc3NT5dIHg4Nl82NF9z
dGFydF9yZXNlcnZhdGlvbnMrMHg2NC8weDZkClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZm
ODMwOGM5NDM+XSB4ODZfNjRfc3RhcnRfa2VybmVsKzB4MWM1LzB4MWRiClsgICAgMC4wMDAw
MDBdIC0tLVsgZW5kIHRyYWNlIDFmMGZlYWUzMjEzNzcyNDUgXS0tLQpbICAgIDAuMDAwMDAw
XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUvZGRmYjNiMzYzNDQwMTcyZDYyY2U2MmZiZmZkZjA0
NjY3MGQzY2UyYi9kbWVzZy15b2N0by1pdmI0MS0xMDI6MjAxNDA3MTcwODQ2MDk6eDg2XzY0
LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1p
djEtMDcxNzAxNDUvZGRmYjNiMzYzNDQwMTcyZDYyY2U2MmZiZmZkZjA0NjY3MGQzY2UyYi9k
bWVzZy15b2N0by1pdmI0MS0xMjI6MjAxNDA3MTcwODQ2MTE6eDg2XzY0LXJhbmRjb25maWct
aXYxLTA3MTcwMTQ1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUv
ZGRmYjNiMzYzNDQwMTcyZDYyY2U2MmZiZmZkZjA0NjY3MGQzY2UyYi9kbWVzZy15b2N0by1p
dmI0MS02NjoyMDE0MDcxNzA4NDYxMDp4ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDU6
Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS9kZGZiM2IzNjM0NDAx
NzJkNjJjZTYyZmJmZmRmMDQ2NjcwZDNjZTJiL2RtZXNnLXlvY3RvLWl2YjQxLTg5OjIwMTQw
NzE3MDg0NjA5Ong4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NTo6Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L2RkZmIzYjM2MzQ0MDE3MmQ2MmNlNjJmYmZm
ZGYwNDY2NzBkM2NlMmIvZG1lc2ctcXVhbnRhbC1pdmI0MS0xMDE6MjAxNDA3MTcwODQ2MjA6
eDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1pdjEtMDcxNzAxNDUvZGRmYjNiMzYzNDQwMTcyZDYyY2U2MmZiZmZkZjA0NjY3MGQz
Y2UyYi9kbWVzZy1xdWFudGFsLWl2YjQxLTExNToyMDE0MDcxNzA4NDYxNjp4ODZfNjQtcmFu
ZGNvbmZpZy1pdjEtMDcxNzAxNDU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0w
NzE3MDE0NS9kZGZiM2IzNjM0NDAxNzJkNjJjZTYyZmJmZmRmMDQ2NjcwZDNjZTJiL2RtZXNn
LXF1YW50YWwtaXZiNDEtMTU6MjAxNDA3MTcwODQ2MTU6eDg2XzY0LXJhbmRjb25maWctaXYx
LTA3MTcwMTQ1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUvZGRm
YjNiMzYzNDQwMTcyZDYyY2U2MmZiZmZkZjA0NjY3MGQzY2UyYi9kbWVzZy1xdWFudGFsLWl2
YjQxLTMzOjIwMTQwNzE3MDg0NjE2Ong4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NTo6
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L2RkZmIzYjM2MzQ0MDE3
MmQ2MmNlNjJmYmZmZGYwNDY2NzBkM2NlMmIvZG1lc2ctcXVhbnRhbC1pdmI0MS00MjoyMDE0
MDcxNzA4NDYyMDp4ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDU6Ogova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS9kZGZiM2IzNjM0NDAxNzJkNjJjZTYyZmJm
ZmRmMDQ2NjcwZDNjZTJiL2RtZXNnLXF1YW50YWwtaXZiNDEtNDc6MjAxNDA3MTcwODQ2MTY6
eDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1pdjEtMDcxNzAxNDUvZGRmYjNiMzYzNDQwMTcyZDYyY2U2MmZiZmZkZjA0NjY3MGQz
Y2UyYi9kbWVzZy1xdWFudGFsLWl2YjQxLTYyOjIwMTQwNzE3MDg0NjIwOng4Nl82NC1yYW5k
Y29uZmlnLWl2MS0wNzE3MDE0NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3
MTcwMTQ1L2RkZmIzYjM2MzQ0MDE3MmQ2MmNlNjJmYmZmZGYwNDY2NzBkM2NlMmIvZG1lc2ct
cXVhbnRhbC1pdmI0MS03OjIwMTQwNzE3MDg0NjIwOng4Nl82NC1yYW5kY29uZmlnLWl2MS0w
NzE3MDE0NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L2RkZmIz
YjM2MzQ0MDE3MmQ2MmNlNjJmYmZmZGYwNDY2NzBkM2NlMmIvZG1lc2ctcXVhbnRhbC1pdmI0
MS05MzoyMDE0MDcxNzA4NDYxNzp4ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDU6Ogov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS9kZGZiM2IzNjM0NDAxNzJk
NjJjZTYyZmJmZmRmMDQ2NjcwZDNjZTJiL2RtZXNnLXlvY3RvLWl2YjQxLTExMToyMDE0MDcx
NzA4NDYxMjp4ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDU6Ogova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS9kZGZiM2IzNjM0NDAxNzJkNjJjZTYyZmJmZmRm
MDQ2NjcwZDNjZTJiL2RtZXNnLXlvY3RvLWl2YjQxLTE3OjIwMTQwNzE3MDg0NjEyOng4Nl82
NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
aXYxLTA3MTcwMTQ1L2RkZmIzYjM2MzQ0MDE3MmQ2MmNlNjJmYmZmZGYwNDY2NzBkM2NlMmIv
ZG1lc2cteW9jdG8taXZiNDMtMTAwOjIwMTQwNzE3MDg1MDMzOng4Nl82NC1yYW5kY29uZmln
LWl2MS0wNzE3MDE0NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1
L2RkZmIzYjM2MzQ0MDE3MmQ2MmNlNjJmYmZmZGYwNDY2NzBkM2NlMmIvZG1lc2cteW9jdG8t
aXZiNDMtMTE2OjIwMTQwNzE3MDg1MDMzOng4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0
NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L2RkZmIzYjM2MzQ0
MDE3MmQ2MmNlNjJmYmZmZGYwNDY2NzBkM2NlMmIvZG1lc2cteW9jdG8taXZiNDMtMTIxOjIw
MTQwNzE3MDg1MDM0Ong4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NTo6Ci9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L2RkZmIzYjM2MzQ0MDE3MmQ2MmNlNjJm
YmZmZGYwNDY2NzBkM2NlMmIvZG1lc2cteW9jdG8taXZiNDMtODk6MjAxNDA3MTcwODUwMzQ6
eDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1pdjEtMDcxNzAxNDUvZGRmYjNiMzYzNDQwMTcyZDYyY2U2MmZiZmZkZjA0NjY3MGQz
Y2UyYi9kbWVzZy15b2N0by12cC01MzoyMDE0MDcxNzA4NDYzMDp4ODZfNjQtcmFuZGNvbmZp
Zy1pdjEtMDcxNzAxNDU6My4xNi4wLXJjMS0wMDA1MC1nZGRmYjNiMzoxCjA6MjA6MjAgYWxs
X2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDctMTcgMDg6NDc6MDUgUkVQ
RUFUIENPVU5UOiAyMCAgIyAvYy9ib290LWJpc2VjdC9saW51eDcvb2JqLWJpc2VjdC8ucmVw
ZWF0G1swbQoKZGRmYjNiMzYzNDQwMTcyZDYyY2U2MmZiZmZkZjA0NjY3MGQzY2UyYiBpcyB0
aGUgZmlyc3QgYmFkIGNvbW1pdApjb21taXQgZGRmYjNiMzYzNDQwMTcyZDYyY2U2MmZiZmZk
ZjA0NjY3MGQzY2UyYgpBdXRob3I6IFBhdWwgRS4gTWNLZW5uZXkgPHBhdWxtY2tAbGludXgu
dm5ldC5pYm0uY29tPgpEYXRlOiAgIEZyaSBKdWwgMTEgMTE6MzA6MjQgMjAxNCAtMDcwMAoK
ICAgIHJjdTogQ3JlYXRlIHJjdW8ga3RocmVhZHMgb25seSBmb3Igb25saW5lZCBDUFVzCiAg
ICAKICAgIFJDVSBjdXJyZW50bHkgdXNlcyBmb3JfZWFjaF9wb3NzaWJsZV9jcHUoKSB0byBz
cGF3biByY3VvIGt0aHJlYWRzLAogICAgd2hpY2ggY2FuIHJlc3VsdCBpbiBtb3JlIHJjdW8g
a3RocmVhZHMgdGhhbiBvbmUgd291bGQgZXhwZWN0LCBmb3IKICAgIGV4YW1wbGUsIGRlclJp
Y2hhcmQgcmVwb3J0ZWQgNjQgQ1BVcyB3b3J0aCBvZiByY3VvIGt0aHJlYWRzIG9uIGFuCiAg
ICA4LUNQVSBpbWFnZS4gIFRoaXMgY29tbWl0IHRoZXJlZm9yZSBjcmVhdGVzIHJjdW8ga3Ro
cmVhZHMgb25seSBmb3IKICAgIHRob3NlIENQVXMgdGhhdCBhY3R1YWxseSBjb21lIG9ubGlu
ZS4KICAgIAogICAgVGhpcyB3YXMgcmVwb3J0ZWQgYnkgZGVyUmljaGFyZCBvbiB0aGUgT0ZU
QyBJUkMgbmV0d29yay4KICAgIAogICAgUmVwb3J0ZWQtYnk6IFJpY2hhcmQgV2VpbmJlcmdl
ciA8cmljaGFyZEBub2QuYXQ+CiAgICBTaWduZWQtb2ZmLWJ5OiBQYXVsIEUuIE1jS2VubmV5
IDxwYXVsbWNrQGxpbnV4LnZuZXQuaWJtLmNvbT4KICAgIFJldmlld2VkLWJ5OiBKb3NoIFRy
aXBsZXR0IDxqb3NoQGpvc2h0cmlwbGV0dC5vcmc+Cgo6MDQwMDAwIDA0MDAwMCA2ZjZhYzQx
MWE4Y2IwZWZlYTAwNzEyNWUyZjMxODU5MDI5ZjhiMGE5IDE5ZjE3OTJkNDFhMzNkOTU1YzA3
YmI4ZmIxNWM1NThjMTU3MjBhNDQgTQlrZXJuZWwKYmlzZWN0IHJ1biBzdWNjZXNzClByZXZp
b3VzIEhFQUQgcG9zaXRpb24gd2FzIGRkZmIzYjMuLi4gcmN1OiBDcmVhdGUgcmN1byBrdGhy
ZWFkcyBvbmx5IGZvciBvbmxpbmVkIENQVXMKSEVBRCBpcyBub3cgYXQgMDhlOGVhMS4uLiBy
Y3U6IFJhdGlvbmFsaXplIGt0aHJlYWQgc3Bhd25pbmcKbHMgLWEgL2tidWlsZC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS9uZXh0Om1hc3Rl
cjowOGU4ZWExYjQ1YzJmNjJhYWRjNmRmZjczYWRlMjk0MmEyODAzMGJiOmJpc2VjdC1saW51
eDcKCjIwMTQtMDctMTctMDg6NDc6MDggMDhlOGVhMWI0NWMyZjYyYWFkYzZkZmY3M2FkZTI5
NDJhMjgwMzBiYiByZXVzZSAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0
NS8wOGU4ZWExYjQ1YzJmNjJhYWRjNmRmZjczYWRlMjk0MmEyODAzMGJiL3ZtbGludXotMy4x
Ni4wLXJjMS0wMDA0OS1nMDhlOGVhMQoKMjAxNC0wNy0xNy0wODo0NzowOCBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAJNQkyOQk2MCBTVUNDRVNTCgpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdh
cyAwOGU4ZWExLi4uIHJjdTogUmF0aW9uYWxpemUga3RocmVhZCBzcGF3bmluZwpIRUFEIGlz
IG5vdyBhdCBkNGY0ZDFkLi4uIEFkZCBsaW51eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZvciAy
MDE0MDcxNgpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRj
b25maWctaXYxLTA3MTcwMTQ1L25leHQ6bWFzdGVyOmQ0ZjRkMWQ0NWNkMWI5YWE2MGU2MWMy
ZWFiMjVhNWQ5YTc5YTI2ZjM6YmlzZWN0LWxpbnV4NwogVEVTVCBGQUlMVVJFClsgICAgMC4w
MDAwMDBdIFByZWVtcHRpYmxlIGhpZXJhcmNoaWNhbCBSQ1UgaW1wbGVtZW50YXRpb24uClsg
ICAgMC4wMDAwMDBdIFJDVTogQWRqdXN0aW5nIGdlb21ldHJ5IGZvciByY3VfZmFub3V0X2xl
YWY9MTYsIG5yX2NwdV9pZHM9MgpbICAgIDAuMDAwMDAwXSAtLS0tLS0tLS0tLS1bIGN1dCBo
ZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAwLjAwMDAwMF0gV0FSTklORzogQ1BVOiAwIFBJRDog
MCBhdCBhcmNoL3g4Ni9rZXJuZWwvY3B1L2NvbW1vbi5jOjE0Mzkgd2Fybl9wcmVfYWx0ZXJu
YXRpdmVzKzB4MmUvMHg0MCgpClsgICAgMC4wMDAwMDBdIFlvdSdyZSB1c2luZyBzdGF0aWNf
Y3B1X2hhcyBiZWZvcmUgYWx0ZXJuYXRpdmVzIGhhdmUgcnVuIQpbICAgIDAuMDAwMDAwXSBN
b2R1bGVzIGxpbmtlZCBpbjoKWyAgICAwLjAwMDAwMF0gQ1BVOiAwIFBJRDogMCBDb21tOiBz
d2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xNi4wLXJjNS1uZXh0LTIwMTQwNzE2ICMxNApbICAg
IDAuMDAwMDAwXSBIYXJkd2FyZSBuYW1lOiBRRU1VIFN0YW5kYXJkIFBDIChpNDQwRlggKyBQ
SUlYLCAxOTk2KSwgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMC4wMDAwMDBdICAwMDAw
MDAwMDAwMDAwMDA5IGZmZmZmZmZmODI2MDNiYzggZmZmZmZmZmY4MWNlNDI3MCBmZmZmZmZm
ZjgyNjAzYzEwClsgICAgMC4wMDAwMDBdICBmZmZmZmZmZjgyNjAzYzAwIGZmZmZmZmZmODEw
ZWI2NzcgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwClsgICAgMC4wMDAwMDBd
ICAwMDAwMDAwMDAwMDAwMDAwIGZmZmZmZmZmODI2MTg3NDAgMDAwMDAwMDAwMDAwMDBhOCBm
ZmZmZmZmZjgyNjAzYzYwClsgICAgMC4wMDAwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4wMDAw
MDBdICBbPGZmZmZmZmZmODFjZTQyNzA+XSBkdW1wX3N0YWNrKzB4ZDIvMHgxOGUKWyAgICAw
LjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTBlYjY3Nz5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4
YzcvMHgxMDAKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTBlYjc5Nz5dIHdhcm5fc2xv
d3BhdGhfZm10KzB4NTcvMHg3MApbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxMDBlNGFk
Pl0gPyBwcmludF9jb250ZXh0X3N0YWNrKzB4MTZkLzB4MjEwClsgICAgMC4wMDAwMDBdICBb
PGZmZmZmZmZmODEwMzA0M2U+XSB3YXJuX3ByZV9hbHRlcm5hdGl2ZXMrMHgyZS8weDQwClsg
ICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEwODU1OTY+XSBfX2RvX3BhZ2VfZmF1bHQrMHgy
YTYvMHgxMTEwClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEwODZhYzY+XSB0cmFjZV9k
b19wYWdlX2ZhdWx0KzB4NTU2LzB4NzcwClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEw
N2UyMmI+XSBkb19hc3luY19wYWdlX2ZhdWx0KzB4M2IvMHgxZDAKWyAgICAwLjAwMDAwMF0g
IFs8ZmZmZmZmZmY4MWNmYWE3OD5dIGFzeW5jX3BhZ2VfZmF1bHQrMHgyOC8weDMwClsgICAg
MC4wMDAwMDBdICBbPGZmZmZmZmZmODE4NmQ3NTg+XSA/IF9fYml0bWFwX29yKzB4MzgvMHg1
MApbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgzMGM4M2JhPl0gcmN1X2luaXRfb25lKzB4
NzgwLzB4YTc4ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODMwYzhjY2Y+XSByY3VfaW5p
dCsweDYxZC8weDZmYwpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgzMDk4OTAwPl0gc3Rh
cnRfa2VybmVsKzB4NGE2LzB4YTMwClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODMwOTdl
NGU+XSA/IHNldF9pbml0X2FyZysweGZiLzB4ZmIKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZm
ZmY4MzA5NzEyMD5dID8gZWFybHlfaWR0X2hhbmRsZXJzKzB4MTIwLzB4MTIwClsgICAgMC4w
MDAwMDBdICBbPGZmZmZmZmZmODMwOTc3NzU+XSB4ODZfNjRfc3RhcnRfcmVzZXJ2YXRpb25z
KzB4NjQvMHg2ZApbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgzMDk3OTQzPl0geDg2XzY0
X3N0YXJ0X2tlcm5lbCsweDFjNS8weDFkYgpbICAgIDAuMDAwMDAwXSAtLS1bIGVuZCB0cmFj
ZSBmZTA5NjRlNjEzZDk2OTdiIF0tLS0KWyAgICAwLjAwMDAwMF0gLS0tLS0tLS0tLS0tWyBj
dXQgaGVyZSBdLS0tLS0tLS0tLS0tCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3
MTcwMTQ1L2Q0ZjRkMWQ0NWNkMWI5YWE2MGU2MWMyZWFiMjVhNWQ5YTc5YTI2ZjMvZG1lc2ct
cXVhbnRhbC12cC00OjIwMTQwNzE3MDM0MjQ3Ong4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3
MDE0NTozLjE2LjAtcmM1LW5leHQtMjAxNDA3MTY6MTQKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1pdjEtMDcxNzAxNDUvZDRmNGQxZDQ1Y2QxYjlhYTYwZTYxYzJlYWIyNWE1ZDlhNzlh
MjZmMy9kbWVzZy1xdWFudGFsLXZwLTE0OjIwMTQwNzE3MDM0MjQ3Ong4Nl82NC1yYW5kY29u
ZmlnLWl2MS0wNzE3MDE0NTozLjE2LjAtcmM1LW5leHQtMjAxNDA3MTY6MTQKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUvZDRmNGQxZDQ1Y2QxYjlhYTYwZTYxYzJl
YWIyNWE1ZDlhNzlhMjZmMy9kbWVzZy1xdWFudGFsLXZwLTEyOjIwMTQwNzE3MDM0MjQ3Ong4
Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NTozLjE2LjAtcmM1LW5leHQtMjAxNDA3MTY6
MTQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUvZDRmNGQxZDQ1Y2Qx
YjlhYTYwZTYxYzJlYWIyNWE1ZDlhNzlhMjZmMy9kbWVzZy15b2N0by1rYnVpbGQtMTg6MjAx
NDA3MTcwMzQwMjU6eDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1OjMuMTYuMC1yYzUt
bmV4dC0yMDE0MDcxNjoxNAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0
NS9kNGY0ZDFkNDVjZDFiOWFhNjBlNjFjMmVhYjI1YTVkOWE3OWEyNmYzL2RtZXNnLXF1YW50
YWwtdnAtMTk6MjAxNDA3MTcwMzQyNDc6eDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1
OjMuMTYuMC1yYzUtbmV4dC0yMDE0MDcxNjoxNAova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWl2MS0wNzE3MDE0NS9kNGY0ZDFkNDVjZDFiOWFhNjBlNjFjMmVhYjI1YTVkOWE3OWEyNmYz
L2RtZXNnLXF1YW50YWwtdnAtNzoyMDE0MDcxNzAzNDI0Nzp4ODZfNjQtcmFuZGNvbmZpZy1p
djEtMDcxNzAxNDU6My4xNi4wLXJjNS1uZXh0LTIwMTQwNzE2OjE0Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L2Q0ZjRkMWQ0NWNkMWI5YWE2MGU2MWMyZWFiMjVh
NWQ5YTc5YTI2ZjMvZG1lc2ctcXVhbnRhbC12cC0yNzoyMDE0MDcxNzAzNDI0OTp4ODZfNjQt
cmFuZGNvbmZpZy1pdjEtMDcxNzAxNDU6My4xNi4wLXJjNS1uZXh0LTIwMTQwNzE2OjE0Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L2Q0ZjRkMWQ0NWNkMWI5YWE2
MGU2MWMyZWFiMjVhNWQ5YTc5YTI2ZjMvZG1lc2ctcXVhbnRhbC12cC0yOToyMDE0MDcxNzAz
NDI0NDp4ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDU6My4xNi4wLXJjNS1uZXh0LTIw
MTQwNzE2OjE0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L2Q0ZjRk
MWQ0NWNkMWI5YWE2MGU2MWMyZWFiMjVhNWQ5YTc5YTI2ZjMvZG1lc2ctcXVhbnRhbC12cC0x
NToyMDE0MDcxNzAzNDI0OTp4ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDU6My4xNi4w
LXJjNS1uZXh0LTIwMTQwNzE2OjE0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3
MTcwMTQ1L2Q0ZjRkMWQ0NWNkMWI5YWE2MGU2MWMyZWFiMjVhNWQ5YTc5YTI2ZjMvZG1lc2ct
cXVhbnRhbC1pdmI0MS05OjIwMTQwNzE3MDE1MzU2Ong4Nl82NC1yYW5kY29uZmlnLWl2MS0w
NzE3MDE0NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L2Q0ZjRk
MWQ0NWNkMWI5YWE2MGU2MWMyZWFiMjVhNWQ5YTc5YTI2ZjMvZG1lc2ctcXVhbnRhbC12cC0x
MDoyMDE0MDcxNzAzNDI0NDp4ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDU6My4xNi4w
LXJjNS1uZXh0LTIwMTQwNzE2OjE0CjA6MTE6MTEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9v
dHMKCkhFQUQgaXMgbm93IGF0IGQ0ZjRkMWQgQWRkIGxpbnV4LW5leHQgc3BlY2lmaWMgZmls
ZXMgZm9yIDIwMTQwNzE2Cgo9PT09PT09PT0gbGludXMvbWFzdGVyID09PT09PT09PQpGcm9t
IGdpdDovL2dpdG1pcnJvci9saW51cwogICAyZGEyOTQ0Li5iNjYwM2ZlICBtYXN0ZXIgICAg
IC0+IGxpbnVzL21hc3RlcgpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBkNGY0ZDFkLi4u
IEFkZCBsaW51eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0MDcxNgpIRUFEIGlzIG5v
dyBhdCBiNjYwM2ZlLi4uIE1lcmdlIHRhZyAnZm9yLWxpbnVzLTIwMTQwNzE2JyBvZiBnaXQ6
Ly9naXQuaW5mcmFkZWFkLm9yZy9saW51eC1tdGQKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4t
cXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS9saW51czptYXN0ZXI6
YjY2MDNmZTU3NGFmMjg5ZGJlOWViOWZiNGM1NDBiY2EwNGY1YTA1MzpiaXNlY3QtbGludXg3
CgoyMDE0LTA3LTE3LTA4OjQ5OjAyIGI2NjAzZmU1NzRhZjI4OWRiZTllYjlmYjRjNTQwYmNh
MDRmNWEwNTMgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1LWI2NjAzZmU1NzRh
ZjI4OWRiZTllYjlmYjRjNTQwYmNhMDRmNWEwNTMKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS9iNjYwM2ZlNTc0YWYyODlkYmU5
ZWI5ZmI0YzU0MGJjYTA0ZjVhMDUzCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUtYjY2
MDNmZTU3NGFmMjg5ZGJlOWViOWZiNGM1NDBiY2EwNGY1YTA1Mwp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAxLWNvbnN1bWVy
L3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS1iNjYwM2ZlNTc0YWYyODlkYmU5ZWI5
ZmI0YzU0MGJjYTA0ZjVhMDUzCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1p
djEtMDcxNzAxNDUvYjY2MDNmZTU3NGFmMjg5ZGJlOWViOWZiNGM1NDBiY2EwNGY1YTA1My92
bWxpbnV6LTMuMTYuMC1yYzUtMDAxNDMtZ2I2NjAzZmUKCjIwMTQtMDctMTctMDg6NTQ6MDIg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgk3CTI3CTMxCTQxCTU0CTYwIFNVQ0NFU1MKCgo9PT09
PT09PT0gbmV4dC9tYXN0ZXIgPT09PT09PT09ClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2Fz
IGI2NjAzZmUuLi4gTWVyZ2UgdGFnICdmb3ItbGludXMtMjAxNDA3MTYnIG9mIGdpdDovL2dp
dC5pbmZyYWRlYWQub3JnL2xpbnV4LW10ZApIRUFEIGlzIG5vdyBhdCBkNGY0ZDFkLi4uIEFk
ZCBsaW51eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0MDcxNgpscyAtYSAva2J1aWxk
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L25l
eHQ6bWFzdGVyOmQ0ZjRkMWQ0NWNkMWI5YWE2MGU2MWMyZWFiMjVhNWQ5YTc5YTI2ZjM6Ymlz
ZWN0LWxpbnV4NwogVEVTVCBGQUlMVVJFClsgICAgMC4wMDAwMDBdIFByZWVtcHRpYmxlIGhp
ZXJhcmNoaWNhbCBSQ1UgaW1wbGVtZW50YXRpb24uClsgICAgMC4wMDAwMDBdIFJDVTogQWRq
dXN0aW5nIGdlb21ldHJ5IGZvciByY3VfZmFub3V0X2xlYWY9MTYsIG5yX2NwdV9pZHM9Mgpb
ICAgIDAuMDAwMDAwXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAg
ICAwLjAwMDAwMF0gV0FSTklORzogQ1BVOiAwIFBJRDogMCBhdCBhcmNoL3g4Ni9rZXJuZWwv
Y3B1L2NvbW1vbi5jOjE0Mzkgd2Fybl9wcmVfYWx0ZXJuYXRpdmVzKzB4MmUvMHg0MCgpClsg
ICAgMC4wMDAwMDBdIFlvdSdyZSB1c2luZyBzdGF0aWNfY3B1X2hhcyBiZWZvcmUgYWx0ZXJu
YXRpdmVzIGhhdmUgcnVuIQpbICAgIDAuMDAwMDAwXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAg
ICAwLjAwMDAwMF0gQ1BVOiAwIFBJRDogMCBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQg
My4xNi4wLXJjNS1uZXh0LTIwMTQwNzE2ICMxNApbICAgIDAuMDAwMDAwXSBIYXJkd2FyZSBu
YW1lOiBRRU1VIFN0YW5kYXJkIFBDIChpNDQwRlggKyBQSUlYLCAxOTk2KSwgQklPUyBCb2No
cyAwMS8wMS8yMDExClsgICAgMC4wMDAwMDBdICAwMDAwMDAwMDAwMDAwMDA5IGZmZmZmZmZm
ODI2MDNiYzggZmZmZmZmZmY4MWNlNDI3MCBmZmZmZmZmZjgyNjAzYzEwClsgICAgMC4wMDAw
MDBdICBmZmZmZmZmZjgyNjAzYzAwIGZmZmZmZmZmODEwZWI2NzcgMDAwMDAwMDAwMDAwMDAw
MCAwMDAwMDAwMDAwMDAwMDAwClsgICAgMC4wMDAwMDBdICAwMDAwMDAwMDAwMDAwMDAwIGZm
ZmZmZmZmODI2MTg3NDAgMDAwMDAwMDAwMDAwMDBhOCBmZmZmZmZmZjgyNjAzYzYwClsgICAg
MC4wMDAwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFjZTQy
NzA+XSBkdW1wX3N0YWNrKzB4ZDIvMHgxOGUKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4
MTBlYjY3Nz5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4YzcvMHgxMDAKWyAgICAwLjAwMDAw
MF0gIFs8ZmZmZmZmZmY4MTBlYjc5Nz5dIHdhcm5fc2xvd3BhdGhfZm10KzB4NTcvMHg3MApb
ICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxMDBlNGFkPl0gPyBwcmludF9jb250ZXh0X3N0
YWNrKzB4MTZkLzB4MjEwClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEwMzA0M2U+XSB3
YXJuX3ByZV9hbHRlcm5hdGl2ZXMrMHgyZS8weDQwClsgICAgMC4wMDAwMDBdICBbPGZmZmZm
ZmZmODEwODU1OTY+XSBfX2RvX3BhZ2VfZmF1bHQrMHgyYTYvMHgxMTEwClsgICAgMC4wMDAw
MDBdICBbPGZmZmZmZmZmODEwODZhYzY+XSB0cmFjZV9kb19wYWdlX2ZhdWx0KzB4NTU2LzB4
NzcwClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEwN2UyMmI+XSBkb19hc3luY19wYWdl
X2ZhdWx0KzB4M2IvMHgxZDAKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNmYWE3OD5d
IGFzeW5jX3BhZ2VfZmF1bHQrMHgyOC8weDMwClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZm
ODE4NmQ3NTg+XSA/IF9fYml0bWFwX29yKzB4MzgvMHg1MApbICAgIDAuMDAwMDAwXSAgWzxm
ZmZmZmZmZjgzMGM4M2JhPl0gcmN1X2luaXRfb25lKzB4NzgwLzB4YTc4ClsgICAgMC4wMDAw
MDBdICBbPGZmZmZmZmZmODMwYzhjY2Y+XSByY3VfaW5pdCsweDYxZC8weDZmYwpbICAgIDAu
MDAwMDAwXSAgWzxmZmZmZmZmZjgzMDk4OTAwPl0gc3RhcnRfa2VybmVsKzB4NGE2LzB4YTMw
ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODMwOTdlNGU+XSA/IHNldF9pbml0X2FyZysw
eGZiLzB4ZmIKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MzA5NzEyMD5dID8gZWFybHlf
aWR0X2hhbmRsZXJzKzB4MTIwLzB4MTIwClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODMw
OTc3NzU+XSB4ODZfNjRfc3RhcnRfcmVzZXJ2YXRpb25zKzB4NjQvMHg2ZApbICAgIDAuMDAw
MDAwXSAgWzxmZmZmZmZmZjgzMDk3OTQzPl0geDg2XzY0X3N0YXJ0X2tlcm5lbCsweDFjNS8w
eDFkYgpbICAgIDAuMDAwMDAwXSAtLS1bIGVuZCB0cmFjZSBmZTA5NjRlNjEzZDk2OTdiIF0t
LS0KWyAgICAwLjAwMDAwMF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0t
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L2Q0ZjRkMWQ0NWNkMWI5
YWE2MGU2MWMyZWFiMjVhNWQ5YTc5YTI2ZjMvZG1lc2ctcXVhbnRhbC12cC00OjIwMTQwNzE3
MDM0MjQ3Ong4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NTozLjE2LjAtcmM1LW5leHQt
MjAxNDA3MTY6MTQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDUvZDRm
NGQxZDQ1Y2QxYjlhYTYwZTYxYzJlYWIyNWE1ZDlhNzlhMjZmMy9kbWVzZy1xdWFudGFsLXZw
LTE0OjIwMTQwNzE3MDM0MjQ3Ong4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NTozLjE2
LjAtcmM1LW5leHQtMjAxNDA3MTY6MTQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjEt
MDcxNzAxNDUvZDRmNGQxZDQ1Y2QxYjlhYTYwZTYxYzJlYWIyNWE1ZDlhNzlhMjZmMy9kbWVz
Zy1xdWFudGFsLXZwLTEyOjIwMTQwNzE3MDM0MjQ3Ong4Nl82NC1yYW5kY29uZmlnLWl2MS0w
NzE3MDE0NTozLjE2LjAtcmM1LW5leHQtMjAxNDA3MTY6MTQKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1pdjEtMDcxNzAxNDUvZDRmNGQxZDQ1Y2QxYjlhYTYwZTYxYzJlYWIyNWE1ZDlh
NzlhMjZmMy9kbWVzZy15b2N0by1rYnVpbGQtMTg6MjAxNDA3MTcwMzQwMjU6eDg2XzY0LXJh
bmRjb25maWctaXYxLTA3MTcwMTQ1OjMuMTYuMC1yYzUtbmV4dC0yMDE0MDcxNjoxNAova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS9kNGY0ZDFkNDVjZDFiOWFhNjBl
NjFjMmVhYjI1YTVkOWE3OWEyNmYzL2RtZXNnLXF1YW50YWwtdnAtMTk6MjAxNDA3MTcwMzQy
NDc6eDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1OjMuMTYuMC1yYzUtbmV4dC0yMDE0
MDcxNjoxNAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NS9kNGY0ZDFk
NDVjZDFiOWFhNjBlNjFjMmVhYjI1YTVkOWE3OWEyNmYzL2RtZXNnLXF1YW50YWwtdnAtNzoy
MDE0MDcxNzAzNDI0Nzp4ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDU6My4xNi4wLXJj
NS1uZXh0LTIwMTQwNzE2OjE0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcw
MTQ1L2Q0ZjRkMWQ0NWNkMWI5YWE2MGU2MWMyZWFiMjVhNWQ5YTc5YTI2ZjMvZG1lc2ctcXVh
bnRhbC12cC0yNzoyMDE0MDcxNzAzNDI0OTp4ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAx
NDU6My4xNi4wLXJjNS1uZXh0LTIwMTQwNzE2OjE0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaXYxLTA3MTcwMTQ1L2Q0ZjRkMWQ0NWNkMWI5YWE2MGU2MWMyZWFiMjVhNWQ5YTc5YTI2
ZjMvZG1lc2ctcXVhbnRhbC12cC0yOToyMDE0MDcxNzAzNDI0NDp4ODZfNjQtcmFuZGNvbmZp
Zy1pdjEtMDcxNzAxNDU6My4xNi4wLXJjNS1uZXh0LTIwMTQwNzE2OjE0Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L2Q0ZjRkMWQ0NWNkMWI5YWE2MGU2MWMyZWFi
MjVhNWQ5YTc5YTI2ZjMvZG1lc2ctcXVhbnRhbC12cC0xNToyMDE0MDcxNzAzNDI0OTp4ODZf
NjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDU6My4xNi4wLXJjNS1uZXh0LTIwMTQwNzE2OjE0
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L2Q0ZjRkMWQ0NWNkMWI5
YWE2MGU2MWMyZWFiMjVhNWQ5YTc5YTI2ZjMvZG1lc2ctcXVhbnRhbC1pdmI0MS05OjIwMTQw
NzE3MDE1MzU2Ong4Nl82NC1yYW5kY29uZmlnLWl2MS0wNzE3MDE0NTo6Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaXYxLTA3MTcwMTQ1L2Q0ZjRkMWQ0NWNkMWI5YWE2MGU2MWMyZWFi
MjVhNWQ5YTc5YTI2ZjMvZG1lc2ctcXVhbnRhbC12cC0xMDoyMDE0MDcxNzAzNDI0NDp4ODZf
NjQtcmFuZGNvbmZpZy1pdjEtMDcxNzAxNDU6My4xNi4wLXJjNS1uZXh0LTIwMTQwNzE2OjE0
CjA6MTE6MTEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCg==

--TDVcAd+kFgbLxwBe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.16.0-rc1-00050-gddfb3b3"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.16.0-rc1 Kernel Configuration
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
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_FHANDLE=y
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
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
# CONFIG_NO_HZ_FULL_ALL is not set
CONFIG_NO_HZ_FULL_SYSIDLE=y
CONFIG_NO_HZ_FULL_SYSIDLE_SMALL=8
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_RCU_USER_QS=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
# CONFIG_RCU_NOCB_CPU_ZERO is not set
CONFIG_RCU_NOCB_CPU_ALL=y
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
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
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
CONFIG_SYSTEM_TRUSTED_KEYRING=y
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
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
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_NONE is not set
CONFIG_CC_STACKPROTECTOR_REGULAR=y
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
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
CONFIG_GCOV_FORMAT_3_4=y
# CONFIG_GCOV_FORMAT_4_7 is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
CONFIG_MODULE_SIG_FORCE=y
# CONFIG_MODULE_SIG_ALL is not set

#
# Do not forget to sign required modules with scripts/sign-file
#
CONFIG_MODULE_SIG_SHA1=y
# CONFIG_MODULE_SIG_SHA224 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha1"
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_THROTTLING is not set
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_CFQ_GROUP_IOSCHED is not set
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
CONFIG_QUEUE_RWLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
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
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=8192
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_I8K=y
CONFIG_MICROCODE=m
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
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
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
# CONFIG_COMPACTION is not set
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_EC_DEBUGFS=m
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=m
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=m
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_ACPI_APEI=y
# CONFIG_ACPI_APEI_GHES is not set
CONFIG_ACPI_APEI_EINJ=m
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
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
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=m

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=m
CONFIG_X86_X32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_IOSF_MBI=m
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
# CONFIG_NET_PTP_CLASSIFY is not set
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
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set
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
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
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
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
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
CONFIG_BLK_DEV_FD=m
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=m
# CONFIG_ZRAM is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
CONFIG_BLK_DEV_DAC960=m
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
CONFIG_BLK_DEV_SKD=y
CONFIG_BLK_DEV_OSD=y
CONFIG_BLK_DEV_SX8=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
CONFIG_BLK_DEV_HD=y
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=m
# CONFIG_AD525X_DPOT_I2C is not set
CONFIG_DUMMY_IRQ=m
CONFIG_IBM_ASM=m
CONFIG_PHANTOM=m
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=m
CONFIG_ICS932S401=m
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_HP_ILO=m
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=m
CONFIG_DS1682=m
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
CONFIG_C2PORT=m
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=m
# CONFIG_EEPROM_93CX6 is not set
CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#
CONFIG_INTEL_MIC_HOST=m

#
# Intel MIC Card Driver
#
CONFIG_INTEL_MIC_CARD=y
CONFIG_GENWQE=m
# CONFIG_ECHO is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=m
CONFIG_SCSI_DH_RDAC=m
# CONFIG_SCSI_DH_HP_SW is not set
CONFIG_SCSI_DH_EMC=m
# CONFIG_SCSI_DH_ALUA is not set
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=y
CONFIG_TCM_FILEIO=m
# CONFIG_TCM_PSCSI is not set
CONFIG_LOOPBACK_TARGET=y
# CONFIG_ISCSI_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=m
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=m
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set
# CONFIG_VHOST_SCSI is not set
CONFIG_VHOST_RING=m

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
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
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
CONFIG_MOUSE_VSXXXAA=y
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=m
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=m
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
CONFIG_JOYSTICK_SIDEWINDER=y
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=m
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
CONFIG_JOYSTICK_AS5011=m
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=m
CONFIG_SERIO_ARC_PS2=y
CONFIG_HYPERV_KEYBOARD=m
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=m
# CONFIG_N_GSM is not set
CONFIG_TRACE_ROUTER=m
CONFIG_TRACE_SINK=m
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set
CONFIG_SERIAL_8250_DW=m

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MFD_HSU=y
CONFIG_SERIAL_MFD_HSU_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_SC16IS7XX=m
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
CONFIG_SERIAL_RP2=m
CONFIG_SERIAL_RP2_NR_UARTS=32
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_SI_PROBE_DEFAULTS=y
CONFIG_IPMI_WATCHDOG=y
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=m
# CONFIG_HW_RANDOM_TPM is not set
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_TIS_I2C_NUVOTON=m
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_ST33_I2C is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=m
CONFIG_I2C_MUX_PCA9541=m
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
# CONFIG_I2C_ISMT is not set
CONFIG_I2C_PIIX4=m
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=m
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIA=m
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=m
CONFIG_I2C_DESIGNWARE_CORE=m
CONFIG_I2C_DESIGNWARE_PLATFORM=m
CONFIG_I2C_DESIGNWARE_PCI=m
CONFIG_I2C_GPIO=m
# CONFIG_I2C_KEMPLD is not set
CONFIG_I2C_OCORES=m
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_SPMI=y
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
CONFIG_HSI_CHAR=m

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_F7188X is not set
CONFIG_GPIO_SCH311X=m
CONFIG_GPIO_SCH=m
CONFIG_GPIO_ICH=m
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_LP3943=m
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
CONFIG_GPIO_ADP5588=m

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=y
# CONFIG_GPIO_AMD8111 is not set
CONFIG_GPIO_INTEL_MID=y
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#

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
# CONFIG_GPIO_JANZ_TTL is not set

#
# USB GPIO expanders:
#
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_SBS=m
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_MAX17040=m
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_LP8727=m
CONFIG_CHARGER_GPIO=m
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_BQ24190=m
CONFIG_CHARGER_BQ24735=m
# CONFIG_CHARGER_SMB347 is not set
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=m
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=m
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=m
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=m
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_G762=m
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=m
CONFIG_SENSORS_IBMAEM=m
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
CONFIG_SENSORS_LINEAGE=m
CONFIG_SENSORS_LTC2945=m
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4222 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4260 is not set
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_MAX16065=m
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=m
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_HTU21=m
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=m
# CONFIG_SENSORS_PMBUS is not set
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_LM25066 is not set
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_MAX16064 is not set
CONFIG_SENSORS_MAX34440=m
# CONFIG_SENSORS_MAX8688 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
# CONFIG_SENSORS_ZL6100 is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS1015=m
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA_CPUTEMP=m
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=m
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y

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
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=m
CONFIG_ACPI_INT3403_THERMAL=m
CONFIG_INTEL_SOC_DTS_THERMAL=m

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_BCM590XX=m
# CONFIG_MFD_CROS_EC is not set
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=m
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_SI476X_CORE=m
# CONFIG_MFD_SM501 is not set
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=m
CONFIG_MFD_LP3943=m
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=m
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS65218=m
# CONFIG_MFD_TPS65912 is not set
CONFIG_MFD_WL1273_CORE=m
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=m
CONFIG_AGP_INTEL=m
CONFIG_AGP_SIS=m
# CONFIG_AGP_VIA is not set
CONFIG_INTEL_GTT=m
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y

#
# Direct Rendering Manager
#
CONFIG_DRM=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=m

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
# CONFIG_DRM_I2C_SIL164 is not set
CONFIG_DRM_I2C_NXP_TDA998X=m
CONFIG_DRM_PTN3460=m
CONFIG_DRM_TDFX=m
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_NOUVEAU=m
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
CONFIG_DRM_I915=m
CONFIG_DRM_I915_KMS=y
CONFIG_DRM_I915_FBDEV=y
# CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT is not set
CONFIG_DRM_MGA=m
CONFIG_DRM_SIS=m
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
CONFIG_DRM_VMWGFX=m
# CONFIG_DRM_VMWGFX_FBCON is not set
CONFIG_DRM_GMA500=m
# CONFIG_DRM_GMA600 is not set
CONFIG_DRM_GMA3600=y
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=m
CONFIG_DRM_MGAG200=m
# CONFIG_DRM_CIRRUS_QEMU is not set
CONFIG_DRM_QXL=m
CONFIG_DRM_BOCHS=m

#
# Frame buffer Devices
#
CONFIG_FB=m
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=m
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=m
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=m
CONFIG_FB_CYBER2000_DDC=y
# CONFIG_FB_ARC is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_N411=m
# CONFIG_FB_HGA is not set
CONFIG_FB_OPENCORES=m
CONFIG_FB_S1D13XXX=m
CONFIG_FB_NVIDIA=m
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
# CONFIG_FB_RIVA is not set
CONFIG_FB_I740=m
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
CONFIG_FB_RADEON_DEBUG=y
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
# CONFIG_FB_ATY_GENERIC_LCD is not set
CONFIG_FB_ATY_GX=y
# CONFIG_FB_ATY_BACKLIGHT is not set
# CONFIG_FB_S3 is not set
CONFIG_FB_SAVAGE=m
# CONFIG_FB_SAVAGE_I2C is not set
CONFIG_FB_SAVAGE_ACCEL=y
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=m
# CONFIG_FB_VIA_DIRECT_PROCFS is not set
# CONFIG_FB_VIA_X_COMPATIBILITY is not set
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=m
CONFIG_FB_3DFX=m
# CONFIG_FB_3DFX_ACCEL is not set
# CONFIG_FB_3DFX_I2C is not set
CONFIG_FB_VOODOO1=m
CONFIG_FB_VT8623=m
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=m
CONFIG_FB_PM3=m
CONFIG_FB_CARMINE=m
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
CONFIG_FB_VIRTUAL=m
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
CONFIG_FB_BROADSHEET=m
# CONFIG_FB_AUO_K190X is not set
CONFIG_FB_HYPERV=m
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_APPLE=m
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_ADP8860=m
CONFIG_BACKLIGHT_ADP8870=m
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_GPIO=y
# CONFIG_BACKLIGHT_LV5207LP is not set
CONFIG_BACKLIGHT_BD6107=m
CONFIG_VGASTATE=m
CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=m
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
CONFIG_LOGO_LINUX_VGA16=y
# CONFIG_LOGO_LINUX_CLUT224 is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
# CONFIG_SND is not set
CONFIG_SOUND_PRIME=y
# CONFIG_SOUND_OSS is not set

#
# HID support
#
CONFIG_HID=m
CONFIG_HIDRAW=y
CONFIG_UHID=m
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=m
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EMS_FF=m
CONFIG_HID_ELECOM=m
CONFIG_HID_EZKEY=m
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
CONFIG_HID_LENOVO_TPKBD=m
CONFIG_HID_LOGITECH=m
CONFIG_HID_LOGITECH_DJ=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=m
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
CONFIG_PANTHERLORD_FF=y
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PRIMAX=m
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SPEEDLINK=m
CONFIG_HID_STEELSERIES=m
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_RMI=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_HYPERV_MOUSE=m
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=m
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=m
# CONFIG_HID_SENSOR_HUB is not set

#
# I2C HID support
#
CONFIG_I2C_HID=m
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
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
# CONFIG_UWB_WHCI is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=m
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=m
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=m
CONFIG_LEDS_LP8501=m
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=m
CONFIG_LEDS_PCA963X=m
CONFIG_LEDS_BD2802=m
CONFIG_LEDS_INTEL_SS4200=m
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_DELL_NETBOOKS=m
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_LM355x is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_ACCESSIBILITY is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_DECODE_MCE=y
# CONFIG_EDAC_MCE_INJ is not set
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_AMD64=m
# CONFIG_EDAC_AMD64_ERROR_INJECTION is not set
CONFIG_EDAC_E752X=m
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
CONFIG_EDAC_I3200=m
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
# CONFIG_EDAC_I5000 is not set
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV_GENIRQ=m
CONFIG_UIO_DMEM_GENIRQ=m
# CONFIG_UIO_AEC is not set
CONFIG_UIO_SERCOS3=y
# CONFIG_UIO_PCI_GENERIC is not set
CONFIG_UIO_NETX=m
# CONFIG_UIO_MF624 is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=m
CONFIG_HYPERV_BALLOON=m
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_COMEDI is not set
# CONFIG_RTS5208 is not set
CONFIG_DX_SEP=m
# CONFIG_CRYSTALHD is not set
CONFIG_FB_XGI=m
CONFIG_ACPI_QUICKSTART=m
CONFIG_FT1000=m

#
# Speakup console speech
#
CONFIG_SPEAKUP=y
CONFIG_SPEAKUP_SYNTH_ACNTSA=y
CONFIG_SPEAKUP_SYNTH_APOLLO=y
CONFIG_SPEAKUP_SYNTH_AUDPTR=m
CONFIG_SPEAKUP_SYNTH_BNS=y
CONFIG_SPEAKUP_SYNTH_DECTLK=m
CONFIG_SPEAKUP_SYNTH_DECEXT=y
# CONFIG_SPEAKUP_SYNTH_LTLK is not set
# CONFIG_SPEAKUP_SYNTH_SOFT is not set
# CONFIG_SPEAKUP_SYNTH_SPKOUT is not set
CONFIG_SPEAKUP_SYNTH_TXPRT=m
# CONFIG_SPEAKUP_SYNTH_DUMMY is not set
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=m
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
CONFIG_STAGING_MEDIA=y

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_DGRP is not set
# CONFIG_XILLYBUS is not set
CONFIG_DGNC=y
CONFIG_DGAP=y
CONFIG_GS_FPGABOOT=m
# CONFIG_CRYPTO_SKEIN is not set
# CONFIG_CRYPTO_THREEFISH is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=m
CONFIG_ACERHDF=y
# CONFIG_ALIENWARE_WMI is not set
CONFIG_ASUS_LAPTOP=y
# CONFIG_DELL_LAPTOP is not set
CONFIG_DELL_WMI=m
# CONFIG_DELL_WMI_AIO is not set
CONFIG_DELL_SMO8800=y
CONFIG_FUJITSU_LAPTOP=y
CONFIG_FUJITSU_LAPTOP_DEBUG=y
# CONFIG_FUJITSU_TABLET is not set
CONFIG_HP_ACCEL=y
CONFIG_HP_WIRELESS=y
CONFIG_HP_WMI=m
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=m
# CONFIG_INTEL_MENLOW is not set
CONFIG_ACPI_WMI=m
CONFIG_MSI_WMI=m
# CONFIG_TOPSTAR_LAPTOP is not set
CONFIG_ACPI_TOSHIBA=m
CONFIG_TOSHIBA_BT_RFKILL=m
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=m
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_MXM_WMI=m
CONFIG_SAMSUNG_Q10=m
CONFIG_APPLE_GMUX=m
# CONFIG_INTEL_RST is not set
CONFIG_INTEL_SMARTCONNECT=y
CONFIG_PVPANIC=y
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_LAPTOP=m
CONFIG_CHROMEOS_PSTORE=y

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
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=m

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
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
CONFIG_VMIVME_7805=y

#
# VME Device Drivers
#
# CONFIG_VME_USER is not set
CONFIG_VME_PIO2=y
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=m
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=m
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_BCM_KONA_USB2_PHY is not set
CONFIG_PHY_SAMSUNG_USB2=m
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=m
# CONFIG_MCB is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=m
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_GOOGLE_MEMCONSOLE=y
CONFIG_UEFI_CPER=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=m
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
# CONFIG_EXT3_FS_SECURITY is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
CONFIG_XFS_WARN=y
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=m
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
CONFIG_BTRFS_DEBUG=y
CONFIG_BTRFS_ASSERT=y
CONFIG_NILFS2_FS=m
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
# CONFIG_CUSE is not set

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_STATS is not set
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_FSCACHE_OBJECT_LIST=y
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
CONFIG_FAT_FS=m
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=m
CONFIG_ECRYPT_FS=m
CONFIG_ECRYPT_FS_MESSAGING=y
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=y
# CONFIG_HFSPLUS_FS_POSIX_ACL is not set
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
# CONFIG_OMFS_FS is not set
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=m
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
# CONFIG_PSTORE_RAM is not set
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=y
CONFIG_UFS_FS_WRITE=y
# CONFIG_UFS_DEBUG is not set
CONFIG_EXOFS_FS=m
# CONFIG_EXOFS_DEBUG is not set
# CONFIG_F2FS_FS is not set
CONFIG_ORE=m
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=m
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=m
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
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
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
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_PREEMPT=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
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
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_VERBOSE=y
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
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
# CONFIG_FUNCTION_TRACER is not set
CONFIG_IRQSOFF_TRACER=y
# CONFIG_PREEMPT_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
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
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
CONFIG_MMIOTRACE_TEST=m
CONFIG_TRACEPOINT_BENCHMARK=y
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
CONFIG_INTERVAL_TREE_TEST=m
CONFIG_PERCPU_TEST=m
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=m
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_MODULE=m
# CONFIG_TEST_USER_COPY is not set
# CONFIG_TEST_BPF is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
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
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
CONFIG_BIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=m
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_TEMPLATE=y
# CONFIG_IMA_NG_TEMPLATE is not set
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
CONFIG_IMA_DEFAULT_HASH="sha1"
CONFIG_IMA_APPRAISE=y
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
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
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER=y
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
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256_SSSE3=m
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=m
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=m
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=m
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=m
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
CONFIG_CRYPTO_TEA=m
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=m

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
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
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4HC_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_INTERVAL_TREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_FONT_SUPPORT=m
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y

--TDVcAd+kFgbLxwBe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--TDVcAd+kFgbLxwBe--
